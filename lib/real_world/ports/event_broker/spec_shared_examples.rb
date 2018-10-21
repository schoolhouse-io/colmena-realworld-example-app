# frozen_string_literal: true

RSpec.shared_examples 'an event broker' do
  before { subject.clear(stream) }

  let(:stream) { :test_stream }

  let(:event) do
    {
      type: :event_type,
      time: Time.now.to_f.round(5),
      data: {
        a: 'A',
        b: 'B',
      },
    }
  end

  def event_with_number(number)
    event.merge(_meta: { number: number })
  end

  context 'when a particular stream does not exist' do
    it '#stream?' do
      expect(subject.stream?(stream)).to be(false)
    end

    context 'when #publish to such stream' do
      let(:published_events) { subject.publish(stream, [event_with_number(1)]) }
      before { published_events }

      it 'creates the stream' do
        expect(subject.stream?(stream)).to be(true)
      end

      it 'returns the published events' do
        expect(published_events).to be_instance_of(Array)
        expect(published_events.size).to eq(1)
        expect(published_events.first).to include(event)
        expect(published_events.first).to include(:_meta)
      end
    end

    it '#subscribe successfully' do
      outcome = subject.subscribe(->(_) {}, stream: stream)
      expect(outcome).to be(true)
    end
  end

  context 'when there are several events in a stream' do
    let(:published_events) do
      subject.publish(
        stream,
        Array.new(3, event),
      )
    end

    before { published_events }

    it '#stream?' do
      expect(subject.stream?(stream)).to be(true)
    end

    it '#subscribe sucessfully' do
      outcome = subject.subscribe(->(_) {}, stream: stream)
      expect(outcome).to be(true)
    end
  end

  context 'when new events are being published in real time' do
    it '#subscribe only to new events' do
      # Publish first event (synchronously) and subscribe afterwards
      subject.publish(stream, [event_with_number(1)])
      numbers_received = []
      subject.subscribe(->(ev) { numbers_received << ev[:_meta][:number] }, stream: stream)

      # Publish second event and make sure we receive that one and only that one
      second_number = subject.publish(stream, [event_with_number(2)]).first[:_meta][:number]

      3.times do # Wait for 3 seconds, if needed
        sleep(1) unless numbers_received.size == 1
      end
      expect(numbers_received).to eq([second_number])
    end

    it '#transaction does not publish events upon a failure' do
      received_events = []
      subject.subscribe(->(e) { received_events << e }, stream: stream)

      error = Class.new(StandardError)

      expect {
        subject.transaction do
          subject.publish(stream, [event])
          raise(error)
        end
      }.to raise_error(error)

      expect(received_events).to be_empty
    end
  end
end
