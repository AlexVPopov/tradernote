# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Note, type: :model, scope: :notes do
  subject { Fabricate(:note) }

  it('has a valid fabricator') { expect(Fabricate(:note)).to be_valid }

  context :associations do
    it { should belong_to(:user) }
  end

  context :validations do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  context :scopes do
    let(:user) { Fabricate(:user) }
    let!(:first_note) do
      Fabricate :note,
                title: 'xxx',
                body: 'ggg, hhh, iii',
                user_tags: 'aaa,bbb,ccc',
                user: user
    end
    let!(:second_note) do
      Fabricate :note,
                title: 'yyy',
                body: 'hhh, iii, jjj, lll',
                user_tags: 'bbb,ccc,ddd,fff',
                user: user
    end
    let!(:third_note) do
      Fabricate :note,
                title: 'zzz',
                body: 'iii,jjj,kkk',
                user_tags: 'ccc,ddd,eee',
                user: user
    end

    context 'title_matches' do
      include_examples 'scope returns all' do
        let(:query) { Note.title_matches }
      end

      it 'works correctly with parameter' do
        title_matches('x', first_note)
        title_matches('y', second_note)
        title_matches('z', third_note)
      end
    end

    context 'body_matches' do
      include_examples 'scope returns all' do
        let(:query) { Note.body_matches }
      end

      it 'works correctly with parameter' do
        body_matches('g', first_note)
        body_matches('h', first_note, second_note)
        body_matches('i', first_note, second_note, third_note)
        body_matches('j', second_note, third_note)
        body_matches('k', third_note)
        body_matches('l', second_note)
      end
    end

    context 'tag_matches' do
      include_examples 'scope returns all' do
        let(:query) { Note.tag_matches }
      end
    end

    context 'any_matches' do
      include_examples 'scope returns all' do
        let(:query) { Note.any_matches }
      end

      it 'works correctly with parameter' do
        matches('a', first_note)
        matches('b', first_note, second_note)
        matches('c', first_note, second_note, third_note)
        matches('d', second_note, third_note)
        matches('e', third_note)
        matches('f', second_note)
        matches('g', first_note)
        matches('h', first_note, second_note)
        matches('i', first_note, second_note, third_note)
        matches('j', second_note, third_note)
        matches('k', third_note)
        matches('l', second_note)
        matches('x', first_note)
        matches('y', second_note)
        matches('z', third_note)
      end
    end
  end
end
