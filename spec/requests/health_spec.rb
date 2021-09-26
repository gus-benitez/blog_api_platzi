require 'rails_helper'

RSpec.describe 'Health endpoint', type: :request do
  describe 'GET /health' do
    before { get '/health'}

    it 'should return ok' do
      expect(response).to have_http_status(200)
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq('OK')
    end
  end
end