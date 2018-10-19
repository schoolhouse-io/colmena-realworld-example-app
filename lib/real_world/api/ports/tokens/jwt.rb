# frozen_string_literal: true

require 'jwt'
require 'base64'
require 'openssl'
require 'digest'
require 'securerandom'

module RealWorld
  module Api
    module Ports
      module Tokens
        class JWT
          ENCODING = 'HS512'
          TYPES = {
            auth: {
              secret: ENV.fetch('API_AUTH_TOKEN_SECRET'),
              lifespan: {
                default: 60 * 60 * 3, # 3 hours
                long: 60 * 60 * 24 * 14, # 2 weeks
              },
            },
          }.freeze

          def auth(email, user_id, remember_me: false)
            encode(:auth, email, data: { user_id: user_id }, lifespan: remember_me ? :long : :default)
          end

          def decode_auth(token)
            decode(:auth, token)
          end

          private

          def encode(type, email, data: {}, lifespan: :default)
            token_params = TYPES.fetch(type)
            payload = data.merge(
              email: email,
              exp: Time.now.to_i + token_params.fetch(:lifespan).fetch(lifespan),
              lifespan: lifespan.to_s,
            )

            ::JWT.encode(payload, token_params.fetch(:secret), ENCODING)
          end

          def decode(type, token)
            payload, encoding = ::JWT.decode(token, TYPES.fetch(type).fetch(:secret))
            typ, alg = encoding.values_at('typ', 'alg')

            return nil, :invalid_token unless typ == 'JWT' && alg == ENCODING

            return symbolize_keys(payload), nil
          rescue ::JWT::ExpiredSignature
            return nil, :expired_token
          rescue ::JWT::DecodeError
            return nil, :invalid_token
          end

          def as_utf8(str)
            Base64.encode64(str).encode('utf-8')
          end

          def from_utf8(str)
            Base64.decode64(str.encode('ascii-8bit'))
          end

          def symbolize_keys(hash)
            ::Hash[hash.map { |k, v| [k.to_sym, v] }]
          end
        end
      end
    end
  end
end
