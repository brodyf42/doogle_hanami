# frozen_string_literal: true

RSpec.describe "GET /search", type: :request, db: true do
  let(:word_repo) { Hanami.app["repos.word_repo"] }
  let(:words) { Hanami.app["relations.words"] }
  let(:body) { last_response.body.dup.force_encoding(Encoding::UTF_8) }

  context "when the word already exists" do
    before { word_repo.find_or_create("École") }

    it "shows the stored word for a differently cased search" do
      get "/search", name: "école"

      expect(last_response.status).to eq(200)
      expect(body).to include("École")
    end

    it "does not create a duplicate" do
      expect { get "/search", name: "ÉCOLE" }.not_to change { words.count }
    end
  end

  context "when the word does not exist" do
    it "creates the word and shows it" do
      expect { get "/search", name: "piñata" }.to change { words.count }.by(1)

      expect(last_response.status).to eq(200)
      expect(body).to include("piñata")
    end
  end

  context "when the search is blank" do
    it "does not create a word and reports the invalid search" do
      expect { get "/search", name: "   " }.not_to change { words.count }

      expect(last_response.status).to eq(200)
      expect(body).to include("Search term invalid")
    end
  end

  context "when the name param is missing" do
    it "reports the invalid search without creating a word" do
      expect { get "/search" }.not_to change { words.count }

      expect(body).to include("Search term invalid")
    end
  end
end
