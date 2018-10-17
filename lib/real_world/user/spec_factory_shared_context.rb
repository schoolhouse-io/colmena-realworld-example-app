# frozen_string_literal: true

require 'securerandom'

RSpec.shared_context 'user factory' do
  let(:id) { SecureRandom.uuid }
  let(:email) { 'some@email.org' }
  let(:username) { 'username' }
  let(:bio) { 'This is my bio' }
  let(:image) { 'https://image.com' }
  let(:some_user) do
    { id: id, email: email, username: username, bio: bio, image: image }
  end
end
