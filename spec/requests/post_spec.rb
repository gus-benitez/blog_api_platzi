require 'rails_helper'
require "byebug"

RSpec.describe 'Post endpoint', type: :request do
  describe 'GET /posts' do
    before { get '/posts'}

    it 'It should return OK, when there are no posts' do
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
    end

    # let, is from rspec => let! (The execution is immediate), let(Execution is done when the variable is used)
    # create_list is from Factory bot
    let!(:posts) { create_list(:post, 10, published: true) }
    it 'It should return OK, when it returns multiple posts' do
      get '/posts'
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
    end
  end

  describe 'GET /posts/{id}' do
    let(:post) { create(:post) }
    it 'It should return OK, when it return a post' do
      get "/posts/#{post.id}"
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
    end
  end
end