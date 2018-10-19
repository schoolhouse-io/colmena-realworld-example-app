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
              },
            },
          }.freeze

          def auth(email, user_id)
            encode(:auth, email, data: { user_id: user_id }, lifespan: :default)
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

          def symbolize_keys(hash)
            ::Hash[hash.map { |k, v| [k.to_sym, v] }]
          end
        end
      end
    end
  end
end
