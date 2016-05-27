class Note < ActiveRecord::Base
  belongs_to :user, required: true

  validates :title, :body, presence: true
end
