# -*- ruby -*-
#encoding: utf-8

require 'strelka/discovery'

Strelka::Discovery.register_apps(
	'arborist-manager' => 'arborist/web/manager_api.rb',
	'arborist-events' => 'arborist/web/event_api.rb',
)

