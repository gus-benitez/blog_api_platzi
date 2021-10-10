class User < ApplicationRecord
  has_many :post

  validates :email, presence: true
  validates :name, presence: true
  validates :auth_token, presence: true

  after_initialize :generate_auth_token

  def generate_auth_token
    # User.new
    self.auth_token = TokenGenerationService.generate unless auth_token.present? # Generate token
  end
end
