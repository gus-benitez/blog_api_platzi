class TokenGenerationService
  def self.generate
    # Rails module, to generate random
    SecureRandom.hex
  end
end
