# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Note, type: :model do
  subject { Fabricate(:note) }

  it('has a valid fabricator') { expect(Fabricate(:note)).to be_valid }

  context :associations do
    it { should belong_to(:user) }
  end

  context :validations do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
