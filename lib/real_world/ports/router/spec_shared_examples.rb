# frozen_string_literal: true

require 'colmena/cell'
require 'colmena/query'
require 'colmena/command'
require 'colmena/event'

RSpec.shared_examples 'a router' do
  # We create a very simple and test-oriented cell that acts as a key-value store
  let(:cell) do
    query = Class.new(Colmena::Query) do
      def self.name
        'ReadMessage'
      end

      def call(id:)
        response(port(:repository).get(id))
      end
    end

    command = Class.new(Colmena::Command) do
      def self.name
        'WriteMessage'
      end

      def call(id:, message:)
        port(:repository).set(id, message)
        response(true, events: [Colmena::Event.call(:message_written)])
      end
    end

    cell = Class.new do
      include Colmena::Cell

      register_port :repository
      register_query query
      register_command command
    end

    cell.new(repository: repository)
  end

  let(:repository) do
    klass = Class.new do
      def initialize
        @values = {}
      end

      def set(key, value)
        @values[key] = value
      end

      def get(key)
        @values[key]
      end
    end

    klass.new
  end

  context 'when there are no cells' do
    before { subject.clear }

    it 'can register it' do
      expect { subject.register_cell(cell) }.not_to raise_error
      expect(subject.queries).not_to be_empty
    end

    it 'fails to get a query' do
      expect(subject.query?(:read_message)).to be(false)
      expect { subject.query(:read_message) }.to raise_error(StandardError)
    end

    it 'fails to get a command' do
      expect(subject.command?(:write_message)).to be(false)
      expect { subject.command(:write_message) }.to raise_error(StandardError)
    end
  end

  context 'when there is a registered cell' do
    before do
      subject.clear
      subject.register_cell(cell)
    end

    it 'can register it again' do
      expect { subject.register_cell(cell) }.not_to raise_error
    end

    it 'recognizes queries and commands' do
      expect(subject.query?(:read_message)).to be(true)
      expect(subject.command?(:write_message)).to be(true)
    end

    it 'can invoke queries and commands' do
      outcome = subject.command(:write_message).call(id: 'marco', message: 'polo')
      expect(outcome[:errors]).to be_empty

      outcome = subject.query(:read_message).call(id: 'marco')
      expect(outcome[:data]).to eq('polo')
    end

    it 'keeps the deserialized types of events' do
      outcome = subject.command(:write_message).call(id: 'marco', message: 'polo')
      expect(outcome).to succeed(data: be(true), events: [:message_written])
    end

    it 'can get information about all queries' do
      expect(subject.queries).to include(
        read_message: hash_including(
          params: [
            {
              name: 'id',
              required: true,
            },
          ],
        ),
      )
    end

    it 'can get information about all commands' do
      expect(subject.commands).to include(
        write_message: hash_including(
          params: [
            {
              name: 'id',
              required: true,
            },
            {
              name: 'message',
              required: true,
            },
          ],
        ),
      )
    end
  end
end
