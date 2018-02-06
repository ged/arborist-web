# -*- ruby -*-
#encoding: utf-8

require 'arborist'
require 'loggability'
require 'configurability'
require 'strelka'
require 'mongrel2'


# Web services and interface for Arborist
module Arborist::Web
	extend Loggability

	# Loggability API -- set up a logger for Arborist::Web objects
	log_as :arborist_web


	# Package version
	VERSION = '0.0.1'

	# Version control revision
	REVISION = %q$Revision$

end # module Arborist::Web

