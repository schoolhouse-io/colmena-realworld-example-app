# frozen_string_literal: true

require 'real_world/email'

describe RealWorld::Email do
  describe 'RealWorld::Email::VALIDATION_REGEX' do
    # A nice list of valid email addresses. Source: http://jmduke.com/posts/email-addresses/
    [
      'foo@baz.com',
      'foo.bar@baz.com',
      'foo@bar.baz.com',
      'foo+bar@baz.com',
      '123456789@baz.com',
      'foo@baz-quz.com',
      '_@baz.com',
      '________@baz.com',
      'foo@baz.name',
      'foo@baz.co.uk',
      'foo-bar@baz.com',
      'baz.com@baz.com',
      'foo.bar+qux@baz.com',
      'foo.bar-qux@baz.com',
      'f@baz.com',
      '_foo@baz.com',
      'foo/bar=qux@baz.com',
      'foo@bar--baz.com',
      'foob*ar@baz.com',
    ].each do |valid_email|
      it "recognizes #{valid_email} as valid" do
        expect(RealWorld::Email::VALIDATION_REGEX.match(valid_email)).not_to be(nil)
      end
    end

    # A nice list of invalid email addresses. Source: http://jmduke.com/posts/email-addresses/
    [
      'foo',
      '#@%^%#$@#$@#.com',
      '@baz.com',
      'Jane Doe <foo@baz.com>',
      'qux.baz.com',
      '.foo@baz.com',
      'foo..bar@baz.com',
      'あいうえお@baz.com',
      'foo@baz.com (Jane Doe)',
      'foo@baz',
      'foo@123.456.789.12345',
      'foo@baz..com',
      'foo..123456@baz.com',
      'a"b(c)d,e:f;g<h>I[j\k]l@baz.com ',
      'foo@baz.com-',
      'foo@baz,qux.com',
      'foo\@bar@baz.com',
      'foo.bar',
      '@',
      '@@',
      '.@',
    ].each do |invalid_email|
      it "recognizes #{invalid_email} as invalid" do
        expect(RealWorld::Email::VALIDATION_REGEX.match(invalid_email)).to be(nil)
      end
    end
  end
end
