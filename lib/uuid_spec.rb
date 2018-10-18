# coding: utf-8
require 'uuid'
require 'securerandom'

describe UUID do
  describe 'UUID::VALIDATION_REGEX' do
    it 'matches valid UUIDv4' do
      expect(UUID::VALIDATION_REGEX.match(SecureRandom.uuid)).not_to be(nil)
    end

    [
      '',
      'abcd',
      'a'*36,
    ].each do |invalid_uuid| 
      it "does not match #{invalid_uuid}" do
        expect(UUID::VALIDATION_REGEX.match(invalid_uuid)).to be(nil)
      end
    end
  end
end
