# frozen_string_literal: true

module Doogle
  module Views
    module Words
      class Search < Doogle::View
        expose :word
        expose :valid_input
      end
    end
  end
end
