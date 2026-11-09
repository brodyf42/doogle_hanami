# frozen_string_literal: true

module Doogle
  module Relations
    class Words < Doogle::DB::Relation
      schema :words, infer: true

      def by_normalized_name(normalized_name)
        where(normalized_name: normalized_name)
      end
    end
  end
end
