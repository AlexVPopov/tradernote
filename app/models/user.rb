class User < ActiveRecord::Base
  has_secure_password

  has_many :notes

  validates :email,
            presence: true,
            uniqueness: true,
            format: {with: /@/, message: 'must contain @'}

  acts_as_tagger
end
