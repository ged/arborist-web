# -*- ruby -*-
#encoding: utf-8

require 'fileutils'

require 'arborist/cli' unless defined?( Arborist::CLI )


# Command to dump a Mongrel2 config database for the web interface
module Arborist::CLI::GenRESTConfig
	extend Arborist::CLI::Subcommand

	desc 'Manage an Arborist-Web installation'
	command :web do |web|

		web.desc 'Set up a new installation'
		web.long_desc <<-END_DESCRIPTION
		Set up a new installation of the Arborist Web interface in the specified DIRECTORY.
		If DIRECTORY is not specified, the current directory will be used instead.
		END_DESCRIPTION
		web.arg_name :DIRECTORY, :optional
		web.command( :setup ) do |cmd|

			cmd.action do |globals, options, args|
				require 'mongrel2'
				require 'mongrel2/config/dsl'
				extend Mongrel2::Config::DSL

				prompt.say( headline_string "Running setup" )

				utils = globals[:v] ? FileUtils::Verbose : FileUtils
				directory = Pathname( args.shift || '.' )
				directory = directory.expand_path

				prompt.say( "Generating config database... " )
				server_config = server 'arborist' do

					name         'Arborist Web'
					default_host 'localhost'

					access_log   'logs/access.log'
					error_log    'logs/error.log'
					pid_file     'run/mongrel2.pid'

					chroot       ''
					bind_addr    '0.0.0.0'
					port         7865

					host 'localhost' do

						route '/', directory( 'public/', 'index.html', 'text/html' )

						# Handlers
						route '/v1/manager', handler( 'tcp://127.0.0.1:12171', 'arborist-manager' )
						route '/v1/events', handler( 'tcp://127.0.0.1:12173', 'arborist-events' )

					end

				end

				setting "zeromq.threads", 1

				setting 'limits.content_length', 8096
				setting 'upload.temp_store', directory + 'var/uploads/mongrel2.upload.XXXXXX'
				setting 'server.daemonize', false
				prompt.say( success_string "ok" )

				prompt.say( "Setting up runtime directories... " )
				utils.mkdir_p( directory + 'var/uploads' )
				utils.mkdir_p( directory + 'run' )
				utils.mkdir_p( directory + 'logs' )
				prompt.say( success_string "ok" )

			end

		end

	end

end # module Arborist::CLI::Clone


