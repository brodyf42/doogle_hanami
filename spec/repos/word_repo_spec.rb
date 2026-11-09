# frozen_string_literal: true

RSpec.describe Doogle::Repos::WordRepo, :db do
  subject(:repo) { Hanami.app["repos.word_repo"] }

  let(:words) { Hanami.app["relations.words"] }

  describe "#find_or_create" do
    it "creates a word with the cleaned name and its normalized key" do
      word = repo.find_or_create("  Résumé  ")

      expect(word.name).to eq("Résumé")
      expect(word.normalized_name).to eq("résumé")
    end

    it "returns the existing word when the normalized form matches" do
      original = repo.find_or_create("École")

      expect(repo.find_or_create("école")).to eq(original)
      expect(words.count).to eq(1)
    end

    it "treats composed and decomposed accents as the same word" do
      original = repo.find_or_create("café")

      expect(repo.find_or_create("cafe\u0301")).to eq(original)
      expect(words.count).to eq(1)
    end

    it "collapses internal whitespace, including non-breaking spaces" do
      original = repo.find_or_create("ice cream")

      expect(repo.find_or_create("ice\u00A0\tcream")).to eq(original)
      expect(words.count).to eq(1)
    end

    it "preserves hyphens and apostrophes" do
      word = repo.find_or_create("Mother-in-law o'clock")

      expect(word.name).to eq("Mother-in-law o'clock")
      expect(word.normalized_name).to eq("mother-in-law o'clock")
    end

    it "returns nil and creates nothing for blank input" do
      expect(repo.find_or_create("   ")).to be_nil
      expect(repo.find_or_create("")).to be_nil
      expect(words.count).to eq(0)
    end

    context "when another request inserts the word after the lookup misses" do
      it "returns the word that won the race" do
        winner = words.changeset(:create, name: "Résumé", normalized_name: "résumé").commit

        misses = 1
        allow(repo).to receive(:words).and_wrap_original do |original|
          relation = original.call
          allow(relation).to receive(:by_normalized_name).and_wrap_original do |method, *args|
            if misses.positive?
              misses -= 1
              double(one: nil)
            else
              method.call(*args)
            end
          end
          relation
        end

        expect(repo.find_or_create("RÉSUMÉ").id).to eq(winner[:id])
        expect(words.count).to eq(1)
      end
    end
  end
end
