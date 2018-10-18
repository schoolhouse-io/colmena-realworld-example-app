module RealWorld
  module Sequel
    def self.with_pagination_info(query, limit, offset)
      [
        query.limit(offset..offset + limit).to_a,
        {limit: limit, offset: offset, total_elements: query.count }
      ]
    end
  end
end
