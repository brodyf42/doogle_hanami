# frozen_string_literal: true

module Doogle
  module Actions
    module Words
      class Search < Doogle::Action
        include Deps['repos.word_repo']

        params do
          required(:name).filled(:string, format?: /\S/)
        end

        def handle(request, response)
          if request.params.valid?
            word = word_repo.find_or_create(request.params[:name])
            # TODO: include API lookup if word is not found in the database then create it before rendering the view
            response.render(view, word: word, valid_input: true)
          else
            # TODO: add robust handling for invalid params - behavior TBD
            response.render(view, word: nil, valid_input: false)
          end
        end
      end
    end
  end
end
