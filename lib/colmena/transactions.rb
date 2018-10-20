# frozen_string_literal: true

module Colmena
  module Transactions
    class Configuration
      def initialize(transaction, options = {})
        @transaction = transaction
        @options = options
      end

      def [](command)
        Bind.new(@transaction, command, @options)
      end
    end

    class Bind
      def initialize(transaction, command, options = {})
        @transaction = transaction
        @command = command
        @options = options
      end

      def name
        @command.name
      end

      def new(ports)
        Command.new(@command.new(ports), @transaction.new(ports, @options))
      end
    end

    class Command
      def initialize(command, transaction)
        @command = command
        @transaction = transaction
      end

      def call(*args, **options)
        @transaction.call do
          @command.call(*args, **options)
        end
      end

      def parameters
        @command.parameters
      end
    end
  end
end
