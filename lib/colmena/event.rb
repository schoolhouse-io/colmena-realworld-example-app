# frozen_string_literal: true

module Colmena
  module Event
    def self.new(name, data = {})
      {
        type: name,
        time: Time.now.to_f,
        data: data,
      }
    end

    def event(*args, **kwargs)
      Event.new(*args, **kwargs)
    end
  end
end
