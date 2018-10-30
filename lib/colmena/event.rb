# frozen_string_literal: true

module Colmena
  module Event
    def self.call(name, data = {})
      {
        type: name,
        time: Time.now.to_f,
        data: data,
      }
    end

    def event(*args, **kwargs)
      Event.call(*args, **kwargs)
    end
  end
end
