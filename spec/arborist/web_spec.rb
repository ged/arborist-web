#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'arborist/web'


describe Arborist::Web do

	it "sets the ZMQ context to the one from Mongrel2" do
		expect( Arborist.zmq_context ).to be( Mongrel2.zmq_context )
	end

end


