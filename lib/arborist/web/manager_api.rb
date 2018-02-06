# -*- ruby -*-
#encoding: utf-8

require 'cztop'
require 'cztop/reactor'
require 'time'
require 'loggability'
require 'strelka/app'
require 'arborist/client'

require 'arborist/web' unless defined?( Arborist::Web )


# A REST service interface for the Arborist Manager API.
class Arborist::Web::ManagerAPI < Strelka::App
	extend Loggability

	# Loggability API -- log to the Arborist::Web logger
	log_to :arborist_web


	# The Strelka App ID
	ID = 'arborist-manager'


	### Create a new instance of the Arborist::Web manager API handler.
	def initialize( * )
		super

		@client = Arborist::Client.new
	end


	##
	# The Arborist::Client used by the service to talk to the Manager
	attr_reader :client


	# Request parameters
	plugin :parameters

	param :identifier, /\A(?<identifier>#{Arborist::Node::VALID_IDENTIFIER})\Z/,
		"The identifier of the node to operate on"

	# Cross-origin requests
	plugin :cors
	access_control do |req, res|
		res.allow_origin '*'
		res.allow_methods 'GET'
		res.allow_credentials
		res.allow_headers :content_type
	end


	# Strelka content-negotiation middleware
	plugin :negotiation


	# Strelka routing middleware
	plugin :routing
	router :exclusive


	### GET /
	get do |req|
		res = req.response
		status = self.client.status

		res.for( :json, :yaml ) { status }
		res.for( :text ) do
			"Arborist Manager %s with %d nodes, %s since %s" % [
				status['server_version'],
				status['nodecount'],
				status['state'],
				(Time.now - status['uptime']).httpdate
			]
		end

		return res
	end


	get 'tree' do |req|
		req.params.add( :depth, :integer, "The maximum depth of the tree to fetch." )

		finish_with( HTTP::BAD_REQUEST, req.params.error_messages.join("\n") ) unless
			req.params.okay?

		args = {}
		args[:from] = req.params[:identifier] if req.params[:identifier]
		args[:depth] = req.params[:depth] if req.params[:depth]

		tree = self.client.fetch( **args )

		res = req.response
		res.for( :json, :yaml ) { tree }
		res.for( :text ) do
			"Nodes:\n  %p" % [ tree ]
		end

		return res
	end


	get 'nodes' do |req|
		req.params.add( :include_down, :boolean, "Whether or not to include nodes that are down." )
		req.params.add( :criteria, :json, "Node-matching criteria" )
		req.params.add( :properties, /\A(\w+(,\s*\w+)*)\Z/, "What node attributes to return." )
		finish_with( HTTP::BAD_REQUEST, req.params.error_messages.join("\n") ) unless
			req.params.okay?

		criteria = req.params[:criteria] || {}

		options = {}
		options[:properties] = req.params[:properties].split( /,\s*/ ) if req.params[:properties]
		options[:include_down] = req.params[:include_down] ? true : false

		nodes = self.client.search( criteria: criteria, options: options )
		self.log.debug "Presenting %d nodes: %p" % [ nodes.length, nodes ]

		res = req.response
		res.for( :json, :yaml ) { nodes }
		res.for( :text ) do
			"Nodes:\n  %p" % [ nodes ]
		end

		return res
	end

end # class Arborist::Web::ManagerAPI

