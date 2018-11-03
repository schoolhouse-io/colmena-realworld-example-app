# frozen_string_literal: true

require 'colmena/event'
require 'real_world/tag/ports/spec_shared_context'
require 'real_world/tag/listeners/counter'

describe RealWorld::Tag::Listeners::Counter do
  include_context 'tag ports'

  let(:listener) { described_class.new(ports) }

  let(:some_tag) { 'some-tag' }
  before { 3.times { repository.increase(some_tag) } }

  context 'when it receives a :tag_added event' do
    it 'increases the counter for that tag' do
      expect(repository).to receive(:increase).and_call_original
      listener.call(Colmena::Event.call(:article_tag_added, tag: some_tag))
      expect(repository.read(some_tag)).to include(count: 4)
    end
  end

  context 'when it receives a :tag_removed event' do
    it 'decreases the counter for that tag' do
      expect(repository).to receive(:decrease).and_call_original
      listener.call(Colmena::Event.call(:article_tag_deleted, tag: some_tag))
      expect(repository.read(some_tag)).to include(count: 2)
    end
  end
end
