# frozen_string_literal: true

RSpec.shared_examples 'an event broker' do
  before { subject.clear(topic) }

  let(:topic) { :test_topic }

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

  context 'when a particular topic does not exist' do
    it '#topic?' do
      expect(subject.topic?(topic)).to be(false)
    end

    context 'when #publish to such topic' do
      let(:published_events) { subject.publish(topic, [event_with_number(1)]) }
      before { published_events }

      it 'creates the topic' do
        expect(subject.topic?(topic)).to be(true)
      end

      it 'returns the published events' do
        expect(published_events).to be_instance_of(Array)
        expect(published_events.size).to eq(1)
        expect(published_events.first).to include(event)
        expect(published_events.first).to include(:_meta)
      end
    end

    it '#subscribe successfully' do
      outcome = subject.subscribe(->(_) {}, topic: topic)
      expect(outcome).to be(true)
    end
  end

  context 'when there are several events in a topic' do
    let(:published_events) do
      subject.publish(
        topic,
        Array.new(3, event),
      )
    end

    before { published_events }

    it '#topic?' do
      expect(subject.topic?(topic)).to be(true)
    end

    it '#subscribe sucessfully' do
      outcome = subject.subscribe(->(_) {}, topic: topic)
      expect(outcome).to be(true)
    end
  end

  context 'when new events are being published in real time' do
    it '#subscribe only to new events' do
      # Publish first event (synchronously) and subscribe afterwards
      subject.publish(topic, [event_with_number(1)])
      numbers_received = []
      subject.subscribe(->(ev) { numbers_received << ev[:_meta][:number] }, topic: topic)

      # Publish second event and make sure we receive that one and only that one
      second_number = subject.publish(topic, [event_with_number(2)]).first[:_meta][:number]

      3.times do  # Wait for 3 seconds, if needed
        sleep(1) unless numbers_received.size == 1
      end
      expect(numbers_received).to eq([second_number])
    end

    it '#subscribe only to events that match certain attributes' do
      events_received = []
      subject.subscribe(
        ->(ev) { events_received << ev },
        topic: topic,
        attributes: { attribute: 'match me' },
      )

      fetch_attributes = ->(ev) { { attribute: ev.fetch(:data).fetch(:attribute) } }
      subject.publish(
        topic,
        [event],
        attribute: 'do not match',
      )

      subject.publish(
        topic,
        [event.merge(data: { attribute: 'match me' })],
        fetch_attributes,
      )

      3.times do  # Wait for 3 seconds, if needed
        sleep(1) unless events_received.size == 1
      end

      expect(events_received.size).to eq(1)
      expect(events_received.first.fetch(:data).fetch(:attribute)).to eq('match me')
    end

    it '#subscribe to certain types' do
      events_received = []
      subject.subscribe(
        ->(ev) { events_received << ev },
        topic: topic,
        attributes: { type: 'AAA' },
      )

      subject.publish(topic, [event.merge(type: :AAA)])
      subject.publish(topic, [event.merge(type: :AAA)], other: 'attribute')
      subject.publish(topic, [event.merge(type: :BBB)])

      3.times do  # Wait for 3 seconds, if needed
        sleep(1) unless events_received.size == 2
      end

      expect(events_received.size).to eq(2)
      expect(events_received).to all(include(type: :AAA))
    end

    it '#transaction does not publish events upon a failure' do
      received_events = []
      subject.subscribe(->(e) { received_events << e }, topic: topic)

      error = Class.new(StandardError)

      expect {
        subject.transaction do |channel|
          subject.publish(topic, [event], {}, channel)
          raise(error)
        end
      }.to raise_error(error)

      expect(received_events).to be_empty
    end
  end
end
