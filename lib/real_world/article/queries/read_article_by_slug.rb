# frozen_string_literal: true

require 'colmena/query'

module RealWorld
  module Article
    module Queries
      class ReadArticleBySlug < Colmena::Query
        def call(slug:)
          article = port(:repository).read_by_slug(slug)
          return error_response(:article_does_not_exist) unless article

          response(article)
        end
      end
    end
  end
end
