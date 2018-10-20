module Colmena
  module Callable
    PARAM_FORMAT = ->(param_def) do
      type, name, = param_def

      {
        name: name.to_s,
        required: type == :keyreq,
      }
    end

    def parameters
      method(:call).parameters.map(&PARAM_FORMAT)
    end
  end
end
