module Colmena
  module Error
    def error(name, data = {})
      {
        type: name,
        data: data,
      }
    end
  end
end
