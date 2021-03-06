# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { Fabricate(:user) }

  it('has a valid fabricator') { expect(Fabricate(:user)).to be_valid }
  it { should have_secure_password }
  it { should have_db_index :email }

  context :associations do
    it { should have_many(:notes).dependent(:destroy) }
  end

  context :validations do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :auth_token }
    it { should validate_uniqueness_of :auth_token }
    it { should validate_length_of(:auth_token).is_equal_to(32) }
  end
end
