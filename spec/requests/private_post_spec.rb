require 'rails_helper'

RSpec.describe 'Posts with authentication', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }
  let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }

  describe 'GET /posts/{id} with valid auth' do
    context 'When requesting a post by another user' do
      context 'When post is public' do
        before { get "/posts/#{other_user_post.id}", headers: auth_headers }

        context 'payload' do
          subject { JSON.parse(response.body) }
          it { is_expected.to include('id') }
        end
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end
      end
      context 'When post is draft' do
        before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }

        context 'payload' do
          subject { JSON.parse(response.body) }
          it { is_expected.to include('error') }
        end
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end
      end
    end
    context 'when requesting a post from the same user' do
    end
  end

  describe 'POST /posts' do
  end

  describe 'PUT /posts' do
  end
end
