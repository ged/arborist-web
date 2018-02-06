# -*- ruby -*-
#encoding: utf-8

require 'set'
require 'time'
require 'yajl'
require 'loggability'
require 'strelka'
require 'strelka/websocketserver'
require 'arborist/client'
require 'arborist/event_api'

require 'arborist/web' unless defined?( Arborist::Web )


# A websocket interface to the Arborist event API.
class Arborist::Web::EventAPI < Strelka::WebSocketServer
	extend Loggability
	include Mongrel2::WebSocket::Constants


	# Loggability API -- log to the Arborist::Web logger
	log_to :arborist_web


	# The Strelka App ID
	ID = 'arborist-events'


	# Disconnect unreachable clients
	plugin :heartbeat
	heartbeat_rate 5.0
	idle_timeout 15.0


	# Handle incoming frames
	plugin :routing
	on_text do |frame|
		self.dispatch_frame( frame )
	end


	### Set up some stuff when the handler is created.
	def initialize( * )
		super
		@system_subscribers = Hash.new {|h,k| h[k] = Set.new }
		@node_subscribers = Hash.new {|h,k| h[k] = Set.new }

		@client = Arborist::Client.new
		@subid = nil
		@manager_runid = nil
	end


	######
	public
	######

	##
	# The Hash of connection IDs, keyed by sender ID, which are subscribed to system
	# events.
	attr_reader :system_subscribers

	##
	# The Hash of connection IDs, keyed by sender ID, which are subscribed to node
	# events.
	attr_reader :node_subscribers

	##
	# The Arborist client object used to communicate with the Manager
	attr_reader :client

	##
	# The ID of the subscription for node events from the manager
	attr_accessor :subid

	##
	# The ID of the manager run sent with the last heartbeat event.
	attr_accessor :manager_runid


	### Subscribe to events when the application starts.
	def run
		self.subscribe_to_system_events
		self.subscribe_to_node_events

		self.reactor.register( self.client.event_api, :read, &self.method(:on_manager_event) )

		return super

	ensure
		self.unsubscribe_from_node_events
		self.unsubscribe_from_system_events
	end


	### Subscribe to system events published by the Manager.
	def subscribe_to_system_events
		self.log.debug "Subscribing to system events from the Manager."
		self.client.event_api.subscribe( 'sys.' )
	end


	### Stop listening for system events published by the Manager.
	def unsubscribe_from_system_events
		self.log.debug "Ignoring system events from the Manager."
		self.client.event_api.unsubscribe( 'sys.' )
	end


	### Create a subscription in the manager for node events and start listening for
	### them.
	def subscribe_to_node_events
		raise "Already subscribed to node events with subid %p" % [ self.subid ] if self.subid
		self.log.debug "Subscribing to node events from the Manager."
		self.subid = self.client.subscribe( identifier: '_' )
		self.client.event_api.subscribe( self.subid )
	end


	### Tear down the subscription to node events and stop listening for them.
	def unsubscribe_from_node_events
		raise "No subscribed to node events." unless self.subid
		self.log.debug "Ignoring node events from the Manager."
		self.client.event_api.unsubscribe( self.subid )
		self.client.unsubscribe( self.subid )
		self.subid = nil
	end


	### CZTop reactor callback -- handle the publication of an event by the Arborist
	### Manager.
	def on_manager_event( event )
		if event.readable?
			msg = event.socket.receive
			identifier, payload = Arborist::EventAPI.decode( msg )

			self.publish_event( identifier, payload )
		elsif event.writable?
			raise "Event socket became writable?!"
		else
			raise "Socket event was neither readable nor writable! (%s)" % [ event ]
		end
	end


	### Publish the given Arborist +event+ to any connected clients that have
	### requested it.
	def publish_event( identifier, event )
		case identifier
		when 'sys.heartbeat'
			self.on_manager_heartbeat( event )
			self.publish_system_event( identifier, event )
		when /\Asys\./
			self.publish_system_event( identifier, event )
		else
			self.publish_node_event( event )
		end
	end


	### When the manager sends a heartbeat +event+, re-subscribe if it has a
	### different run ID.
	def on_manager_heartbeat( event )
		this_runid = event['run_id']

		if self.manager_runid && self.manager_runid != this_runid
			self.unsubscribe_from_node_events
			self.subscribe_to_node_events
		else
			self.log.debug "Manager is alive (runid: %s)" % [ this_runid ]
		end

		self.manager_runid = this_runid
	end


	### Re-publish a system event with the specified +identifier+ and +payload+ to
	### any clients that have subscribed to them.
	def publish_system_event( type, payload )
		self.republish_event({ type: type, data: payload }, self.system_subscribers )
	end


	### Re-publish a node event with the specified +identifier+ and +payload+ to any
	### clients that have subscribed to them.
	def publish_node_event( payload )
		self.republish_event( payload, self.node_subscribers )
	end


	### Re-publish an event with the specified +identifier+ and +payload+ to the
	### clients in the given +subscriber_hash+.
	def republish_event( payload, subscriber_hash )
		data = Yajl::Encoder.encode( payload )
		frame = self.make_event_frame( data )
		subscriber_hash.each do |sender_id, conn_ids|
			self.log.debug "Broadcasting to %d connections for sender %s" %
				[ conn_ids.length, sender_id ]
			self.conn.broadcast( sender_id, conn_ids.to_a, frame )
		end
	end


	### Make and return a raw websocket frame as a binary string from the specified
	### event +payload+.
	def make_event_frame( payload )
		frame = Mongrel2::WebSocket::Frame.new( '', 0, '', {}, payload )
		frame.opcode = :text

		return frame.to_s
	end


	### Dispatch the action specified in the specified +frame+ and return a
	### response.
	def dispatch_frame( frame )
		action = self.parse_action_from_frame( frame )
		return self.dispatch_action( action, frame )
	rescue => err
		self.log.error "%p while handling a text frame: %s" % [ err.class, err.message ]
		self.close_with( frame, CLOSE_EXCEPTION )
	end


	### Parse the payload of the specified +frame+ as a JSON Object and return the
	### value of the `action` key in the resulting Hash.
	def parse_action_from_frame( frame )
		raw_data = frame.payload.read
		data = Yajl::Parser.parse( raw_data )

		raise "Frame payload is not an Object" unless data.is_a?( Hash )
		action = data['action'] or raise "No action present"

		return action
	rescue Yajl::ParseError => err
		self.log.error "%p while parsing action from incoming frame: %s" % [ err.message ]
		self.close_with( frame, CLOSE_BAD_DATA )
		return nil
	end


	### Execute the specified +action+ for the given +frame+.
	def dispatch_action( action, frame )
		case action
		when 'system'
			self.register_for_system_events( frame )
		when 'node'
			self.register_for_node_events( frame )
		else
			self.log.error "Client %p requested unhandled action %p" % [ frame.conn_id, action ]
			self.close_with( frame, CLOSE_BAD_DATA )
		end

		return nil
	end


	### Override to also tear down a client's subscriptions when it disconnects.
	def handle_disconnect( request )
		super
		self.unregister_from_system_events( request )
		self.unregister_from_node_events( request )
	end


	### Subscribe the client that sent the specified +frame+ to system events.
	def register_for_system_events( frame )
		self.system_subscribers[ frame.sender_id ].add( frame.conn_id )
	end


	### Subscribe the client that sent the specified +frame+ to node events.
	def register_for_node_events( frame )
		self.node_subscribers[ frame.sender_id ].add( frame.conn_id )
	end


	### Remove subscriptions for system events for the client that sent the specified +frame+.
	def unregister_from_system_events( frame )
		self.system_subscribers[ frame.sender_id ].delete( frame.conn_id )
	end


	### Remove subscriptions for node events for the client that sent the specified +frame+.
	def unregister_from_node_events( frame )
		self.node_subscribers[ frame.sender_id ].delete( frame.conn_id )
	end

end # class Arborist::Web::EventAPI

