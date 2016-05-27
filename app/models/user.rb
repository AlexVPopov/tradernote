class User < ActiveRecord::Base
  has_secure_password

  has_many :notes
  acts_as_tagger

  validates :email,
            presence: true,
            uniqueness: true,
            format: {with: /@/, message: 'must contain @'}
  validates :auth_token, presence: true, uniqueness: true, length: {is: 32}

  before_validation :set_auth_token, on: :create

  private

    def set_auth_token
      auth_token.present? ? return : self.auth_token = generate_auth_token
    end

    def generate_auth_token
      loop do
        token = SecureRandom.hex
        break token unless User.exists?(auth_token: token)
      end
    end
end
