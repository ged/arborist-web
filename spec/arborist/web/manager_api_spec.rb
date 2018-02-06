#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'arborist/web/manager_api'


describe Arborist::Web::ManagerAPI do

	let( :request_factory ) do
		Mongrel2::RequestFactory.new( route: '/v1/manager' )
	end

	let( :send_spec ) { 'tcp://127.0.0.1:*' }
	let( :recv_spec ) { 'tcp://127.0.0.1:*' }
	let( :app_id ) { described_class::ID }
	let( :app ) { described_class.new( app_id, send_spec, recv_spec ) }

	let( :client ) { instance_double(Arborist::Client) }


	before( :each ) do
		allow( Arborist::Client ).to receive( :new ).and_return( client )
	end


	describe "GET /v1/manager" do

		it "returns the status of the manager" do
			status_data = {
				"server_version" => "0.1.0",
				"state" => "running",
				"uptime" => 32.290478,
				"nodecount" => 71
			}
			expect( client ).to receive( :status ).and_return( status_data )

			request = request_factory.get( '/v1/manager' )
			response = app.handle( request )

			expect( response.status_line ).to match( /200 ok/i )
			expect( response.body.read ).to eq( Yajl::Encoder.encode(status_data) )
		end

	end


	describe "GET /v1/manager/tree" do

		let( :tree_data ) do
			[
				{
					"identifier" => "_",
					"type" => "root",
					"parent" => nil,
					"description" => "The root node.",
					"tags" => [],
					"config" => {},
					"status" => "up",
					"properties" => {},
					"ack" => nil,
					"last_contacted" => "1969-12-31T16:00:00-08:00",
					"status_changed" => "1969-12-31T16:00:00-08:00",
					"errors" => {},
					"dependencies" => {"behavior" => "all", "identifiers" => [], "subdeps" => []},
					"quieted_reasons" => {},
					"children" => {}
				},
				{
					"identifier" => "faeriemud",
					"type" => "host",
					"parent" => "_",
					"description" => "FaerieMUD.org public host",
					"tags" => ["public"],
					"config" => {},
					"status" => "up",
					"properties" => {"_monitor_key" => "pinger", "rtt" => 30.2},
					"ack" => nil,
					"last_contacted" => "2018-01-03T14:46:10-08:00",
					"status_changed" => "2018-01-03T14:28:10-08:00",
					"errors" => {},
					"dependencies" => {"behavior" => "all", "identifiers" => [], "subdeps" => []},
					"quieted_reasons" => {"primary" => "Parent down: localhost-testing"},
					"children" => {},
					"addresses" => ["1.1.1.206"]
				},
				{
					"identifier" => "faeriemud-disk",
					"type" => "resource",
					"parent" => "faeriemud",
					"description" => nil,
					"tags" => [],
					"config" => {},
					"status" => "unknown",
					"properties" => {},
					"ack" => nil,
					"last_contacted" => "1969-12-31T16:00:00-08:00",
					"status_changed" => "2018-01-03T14:28:10-08:00",
					"errors" => {},
					"dependencies" => {"behavior" => "all", "identifiers" => [], "subdeps" => []},
					"quieted_reasons" => {},
					"children" => {},
					"addresses" => ["1.1.1.206"],
				}
			]
		end


		it "returns the node tree" do
			expect( client ).to receive( :fetch ).
				with( {} ).
				and_return( tree_data )

			request = request_factory.get( '/v1/manager/tree' )
			response = app.handle( request )

			expect( response.status_line ).to match( /200 ok/i )
			expect( response.body.read ).to eq( Yajl::Encoder.encode(tree_data) )
		end

	end


	describe "GET /v1/manager/search" do

		let( :node_data ) do
			{
				"_" => {
					"type" => "root",
					"status" => "up",
					"tags" => [],
					"parent" => nil,
					"description" => "The root node.",
					"dependencies" => {
						"behavior" => "all",
						"identifiers" => [],
						"subdeps" => []
					},
					"status_changed" => "1969-12-31T16:00:00-08:00",
					"last_contacted" => "1969-12-31T16:00:00-08:00",
					"ack" => nil,
					"errors" => {},
					"quieted_reasons" => {},
					"config" => {}
				},
				"faeriemud" => {
					"_monitor_key" => "pinger",
					"rtt" => 30.2,
					"type" => "host",
					"status" => "up",
					"tags" => ["public"],
					"parent" => "_",
					"description" => "FaerieMUD.org public host",
					"dependencies" => {
						"behavior" => "all",
						"identifiers" => [],
						"subdeps" => []
					},
					"status_changed" => "2018-01-03T14:28:10-08:00",
					"last_contacted" => "2018-01-03T14:46:10-08:00",
					"ack" => nil,
					"errors" => {},
					"quieted_reasons" => {"primary" => "Parent down: localhost-testing"},
					"config" => {},
					"addresses" => ["1.1.1.206"]
				},
			}
		end


		it "returns the node tree" do
			expect( client ).to receive( :search ).
				with( criteria: {}, properties: :all, include_down: false ).
				and_return( node_data )

			request = request_factory.get( '/v1/manager/nodes' )
			response = app.handle( request )

			expect( response.status_line ).to match( /200 ok/i )
			expect( response.body.read ).to eq( Yajl::Encoder.encode(node_data) )
		end

	end

end

