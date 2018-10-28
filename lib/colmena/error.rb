# frozen_string_literal: true

module Colmena
  module Error
    def self.call(name, data = {})
      {
        type: name,
        data: data,
      }
    end

    def error(*args, **kwargs)
      Error.call(*args, **kwargs)
    end
  end
end
