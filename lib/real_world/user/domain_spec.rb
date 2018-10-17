# frozen_string_literal: true

require 'real_world/user/domain'

describe RealWorld::User::Domain do
  let(:email) { 'some@email.com' }
  let(:username) { 'username' }
  let(:bio) { '' }
  let(:image) { '' }

  describe '.create' do
    subject { described_class.create(email, username, bio, image) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(
              id: be_a(String),
              email: email,
              username: username,
              bio: bio,
              image: image,
            ),
            events: [:user_created],
          ),
        )
      }
    end

    [nil, 1, 'a', '@', 'a@'].each do |invalid_email|
      context "when the email is '#{invalid_email}'" do
        let(:email) { invalid_email }
        it { is_expected.to fail_with_errors(:email_is_invalid) }
      end
    end

    [nil, 1, '', 'x', 'long'*20].each do |invalid_username|
      context "when the username is '#{invalid_username}'" do
        let(:username) { invalid_username }
        it { is_expected.to fail_with_errors(:username_is_invalid) }
      end
    end

    [1, 'too long' * 100].each do |invalid_bio|
      context "when the bio is '#{invalid_bio}'" do
        let(:bio) { invalid_bio }
        it { is_expected.to fail_with_errors(:bio_is_invalid) }
      end
    end

    [1, 'not a url'].each do |invalid_image|
      context "when the image is '#{invalid_image}'" do
        let(:image) { invalid_image }
        it { is_expected.to fail_with_errors(:image_is_invalid) }
      end
    end

    ['a reasonable bio'].each do |valid_bio|
      context "when the bio is '#{valid_bio}'" do
        let(:bio) { valid_bio }
        it { is_expected.to succeed(data: include(bio: bio), events: [:user_created]) }
      end
    end

    ['https://images.org/image.jpg'].each do |valid_image|
      context "when the image is '#{valid_image}'" do
        let(:image) { valid_image }
        it { is_expected.to succeed(data: include(image: image), events: [:user_created]) }
      end
    end
  end

  describe '.update' do
    let(:user) do
      described_class.create(
        'old@email.com',
        'old_username',
        'this an old bio',
        'http://old.image',
      ).fetch(:data)
    end
    subject { described_class.update(user, email, username, bio, image) }

    context 'when all attributes are valid' do
      it {
        is_expected.to(
          succeed(
            data: include(
              id: be_a(String),
              email: email,
              username: username,
              bio: bio,
              image: image,
            ),
            events: [:user_updated],
          ),
        )
      }
    end

    [nil, 1, 'a', '@', 'a@'].each do |invalid_email|
      context "when the email is '#{invalid_email}'" do
        let(:email) { invalid_email }
        it { is_expected.to fail_with_errors(:email_is_invalid) }
      end
    end

    [nil, 1, '', 'x', 'long'*20].each do |invalid_username|
      context "when the username is '#{invalid_username}'" do
        let(:username) { invalid_username }
        it { is_expected.to fail_with_errors(:username_is_invalid) }
      end
    end

    [1, 'too long' * 100].each do |invalid_bio|
      context "when the bio is '#{invalid_bio}'" do
        let(:bio) { invalid_bio }
        it { is_expected.to fail_with_errors(:bio_is_invalid) }
      end
    end

    [1, 'not a url'].each do |invalid_image|
      context "when the image is '#{invalid_image}'" do
        let(:image) { invalid_image }
        it { is_expected.to fail_with_errors(:image_is_invalid) }
      end
    end
  end
end
