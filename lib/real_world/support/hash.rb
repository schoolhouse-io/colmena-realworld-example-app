# frozen_string_literal: true

module RealWorld
  module Support
    module Hash
      def self.index_by(items, key)
        ::Hash[items.map { |item| [item.fetch(key), item] }]
      end
    end
  end
end
