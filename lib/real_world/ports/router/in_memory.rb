# frozen_string_literal: true

module RealWorld
  module Ports
    module Router
      class InMemory
        def initialize
          @queries = {}
          @commands = {}
        end

        def register_cell(cell)
          @queries = @queries.merge(cell.queries)
          @commands = @commands.merge(cell.commands)
        end

        def query(name)
          @queries.fetch(name)
        end

        def command(name)
          @commands.fetch(name)
        end

        def query?(name)
          @queries.key?(name)
        end

        def command?(name)
          @commands.key?(name)
        end

        def queries
          @queries.map { |name, op| [name, { params: op.parameters }] }.to_h
        end

        def commands
          @commands.map { |name, op| [name, { params: op.parameters }] }.to_h
        end

        def clear
          @queries.clear
          @commands.clear
        end
      end
    end
  end
end
