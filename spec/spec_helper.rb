# -*- ruby -*-
#encoding: utf-8

BEGIN {
	$LOAD_PATH.unshift '../Arborist/lib'
}

require 'simplecov' if ENV['COVERAGE']

require 'rspec'
require 'loggability/spechelpers'
require 'mongrel2/testing'


### Mock with RSpec
RSpec.configure do |config|
	config.run_all_when_everything_filtered = true
	config.filter_run :focus
	config.order = 'random'
	config.mock_with( :rspec ) do |mock|
		mock.syntax = :expect
	end

	config.include( Loggability::SpecHelpers )
	config.include( Mongrel2::SpecHelpers )
end


