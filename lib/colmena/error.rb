# frozen_string_literal: true

module Colmena
  module Error
    def self.new(name, data = {})
      {
        type: name,
        data: data,
      }
    end

    def error(*args, **kwargs)
      Error.new(*args, **kwargs)
    end
  end
end
