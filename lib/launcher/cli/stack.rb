require 'launcher/template'
require 'launcher/stack'

module Launcher
  class CLI < Thor
    # Provides AWS Cloudformation Stack based functionality.
    #
    # @example Create a new stack
    #   launcher stack create --name foo --template foobar.cloudformation --params foo:bar
    #
    # @example Updating a pre-existing stack
    #   launcher stack update --name foo --template new_foobar.cloudformation
    class Stack < Thor

      class_option :params, :type => :hash, :aliases => "-p"
      class_option :name, :type => :string, :aliases => "-n"
      class_option :config_files, :type => :array, :aliases => "-c"
      class_option :template, :type => :string, :aliases => "-t", :required => true

      desc "stack create", "Launch a new AWS Cloudformation template using discoverable parameters"
      # This CLI command launches a new Cloudformation given the provided arguments passed to it.
      # For more help on this command, use `launcher help create` from the command line.
      def create
        cloudformation(:create)
      end

      desc "stack update", "Updates a pre-existing Cloudformation template."
      # This CLI command updates an pre-existing AWS Cloudformation template, updating parameters.
      # For more help on this command, use `launcher help update` from the command line.
      def update
        cloudformation(:update)
      end

      desc "stack cost", "Retrieves a URL that provides an estimate cost this template."
      # This CLI command retrieves a URL from the AWS API that provides an estimate cost for the template.
      def cost
        cloudformation(:cost)
      end

      private

        def cloudformation(op)
          stack = Launcher::Stack.new(name, template, discovered) { |message, opts|
            Launcher::Log.send(opts[:type] || :info, message)
          }
          stack.send(op)
        end

        def discovered
          Launcher::Parameters.new
        end

        def template
          template = Launcher::Template.new(options[:template])
        end

        def name 
          options[:name] || template.name
        end

    end
  end
end