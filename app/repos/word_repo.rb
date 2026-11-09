# frozen_string_literal: true

module Doogle
  module Repos
    class WordRepo < Doogle::DB::Repo
      def find_or_create(input)
        name = clean(input)
        normalized = name.downcase
        return nil if normalized.empty?

        words.by_normalized_name(normalized).one || create_word(name, normalized)
      end

      private

      def create_word(name, normalized)
        words.changeset(:create, name: name, normalized_name: normalized).commit
      rescue ROM::SQL::UniqueConstraintError
        words.by_normalized_name(normalized).one
      end

      def clean(input)
        input.to_s.gsub(/[[:space:]]+/, " ").strip.unicode_normalize(:nfc)
      end
    end
  end
end
