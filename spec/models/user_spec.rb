require 'rails_helper'

RSpec.describe User, type: :model do
  it('has a valid fabricator') { expect(Fabricate(:user)).to be_valid }
  it { should have_secure_password }
  it { should have_db_index :email }

  context :validations do
    subject { Fabricate :user }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
