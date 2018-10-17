require 'colmena/error'

module Colmena
  # Responses in Colmena have a predictable data structure.
  # As a convention, data is usually nil when there are errors.
  module Response
    include Colmena::Error

    def response(data, events: [], errors: [], opts: {})
      response_skeleton
        .merge(
          data: data,
          events: events,
          errors: errors,
        )
        .merge(opts)
    end

    def error_response(*args)
      response_skeleton.merge(
        errors: [error(*args)],
      )
    end

    def response_skeleton
      {
        data: nil,
        events: [],
        errors: [],
      }
    end

    # Return errors immediately (if any), or execute the block and return its response
    def capture_errors(*responses)
      errors = responses.flat_map { |response| response[:errors] }
      errors.empty? ? yield : response(nil, errors: errors)
    end
  end
end
