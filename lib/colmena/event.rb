module Colmena
  module Event
    # TODO: Decide the best strategy to simplify this
    def self.event(name, data={})
      {
        type: name,
        time: Time.now.to_f,
        data: data
      }
    end

    def event(name, data={})
      {
        type: name,
        time: Time.now.to_f,
        data: data
      }
    end
  end
end
