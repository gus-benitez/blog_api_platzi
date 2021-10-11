require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  describe 'GET /posts' do
    before { get '/posts' }

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

  describe 'GET /posts with Search' do
    let!(:post_hola_mundo) { create(:published_post, title: 'Hola mundo') }
    let!(:post_hola_rails) { create(:published_post, title: 'Hola rails') }
    let!(:post_curso_rails) { create(:published_post, title: 'Curso rails') }
    it 'It should filter posts by title' do
      get '/posts?search=hola'
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload.size).to eq(2)
      expect(payload.map { |p| p['id'] }.sort).to eq([post_hola_mundo.id, post_hola_rails.id].sort)
    end
  end

  describe 'GET /posts/{id}' do
    let(:post) { create(:post, published: true) }
    it 'It should return OK, when it return a post' do
      get "/posts/#{post.id}"
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']['id']).to eq(post.user.id)
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
    end
  end
end
