# frozen_string_literal: true

require 'securerandom'

RSpec.shared_examples 'a tag repository' do
  before { subject.clear }

  let(:some_tag) { 'some-tag' }

  context 'when there are no tags stored' do
    it '#increase count' do
      expect { subject.increase(some_tag) }.not_to raise_error
      expect(subject.read(some_tag)).to include(count: 1)
    end

    it '#decrease count' do
      expect { subject.decrease(some_tag) }.not_to raise_error
      expect(subject.read(some_tag)).to include(count: 0)
    end

    it '#read' do
      expect(subject.read(some_tag)).to include(count: 0)
    end

    it '#list' do
      list, = subject.list
      expect(list).to be_empty
    end
  end

  context 'when there are a few tags stored' do
    let(:some_other_tag) { 'some-other-tag' }

    before do
      3.times { subject.increase(some_tag) }
      2.times { subject.increase(some_other_tag) }
    end

    it '#increase count' do
      expect { subject.increase(some_tag) }.not_to raise_error
      expect(subject.read(some_tag)).to include(count: 4)
    end

    it '#decrease count' do
      expect { subject.decrease(some_tag) }.not_to raise_error
      expect(subject.read(some_tag)).to include(count: 2)
    end

    it '#read' do
      expect(subject.read(some_tag)).to include(count: 3)
    end

    it '#list' do
      list, = subject.list
      expect(list).to(
        contain_exactly(
          { name: some_tag, count: 3 },
          name: some_other_tag, count: 2,
        ),
      )
    end

    it '#list with pagination' do
      list, pagination_info = subject.list(limit: 30, offset: 2)
      expect(list).to be_empty
      expect(pagination_info).to include(limit: 30, offset: 2, total_elements: 2)
    end
  end
end
