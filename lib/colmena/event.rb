module Colmena
  module Event
    def event(name, data={})
      {
        type: name,
        time: Time.now.to_f,
        data: data
      }
    end
  end
end
