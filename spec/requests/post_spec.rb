require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  describe 'GET /post' do
    before { get '/post'}

    it 'It should return OK, when there are no posts' do
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(payload['api']).to eq('OK')
    end

    it 'It should return OK, when it returns multiple posts' do
      # let, is from rspec
      # create_list is from Factory bot
      let(:posts) { create_list(:post,  10, published: true) }

      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(payload['api']).to eq('OK')
    end
  end

  describe 'GET /post/{id}' do
    it 'It should return OK, when it return a post' do
      let(:posts) { create_list(:post) }
      get "/post/#{post.id}"

      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
    end
  end
end