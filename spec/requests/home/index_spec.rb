# frozen_string_literal: true

RSpec.describe "GET /", type: :request do
  it "renders the search form" do
    get "/"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('action="/search"')
    expect(last_response.body).to include('name="name"')
  end
end
