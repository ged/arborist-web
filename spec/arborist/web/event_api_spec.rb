#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'arborist/web/manager_api'


describe Arborist::Web::ManagerAPI do

	let( :request_factory ) do
		Mongrel2::WebSocketFrameFactory.new( route: '/v1/events' )
	end

	let( :send_spec ) { 'tcp://127.0.0.1:*' }
	let( :recv_spec ) { 'tcp://127.0.0.1:*' }
	let( :app_id ) { described_class::ID }


	it "publishes events that arrive from the manager to connected clients" do
		
		
	end

end

