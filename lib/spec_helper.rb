# frozen_string_literal: true

RSpec::Matchers.define :contain_events do |*expected|
  match do |actual|
    expect(actual.size).to eq(expected.size)
    expected.zip(actual).map { |exp, act| expect(act[:type]).to eq(exp) }
  end
end

RSpec::Matchers.alias_matcher :contain_errors, :contain_events

RSpec::Matchers.define :succeed do |data:, events: []|
  match do |actual|
    expect(actual[:events] || []).to contain_events(*events)
    expect(actual.fetch(:data)).to data
    expect(actual.fetch(:errors)).to be_empty
  end

  failure_message do |actual|
    "actual: #{actual}\nexpected: #{data.inspect}\nevents: #{events}\n"
  end
end

RSpec::Matchers.define :fail_with_errors do |*errors|
  match do |actual|
    expect(actual.fetch(:data)).to be_nil
    expect(actual.fetch(:errors)).to contain_errors(*errors)
  end
end
