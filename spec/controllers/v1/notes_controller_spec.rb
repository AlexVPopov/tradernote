# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::NotesController, type: :controller, scope: :notes do
  let(:user) { Fabricate(:user) }

  describe 'routing' do
    it { should route(:post, '/notes').to(action: :create, format: :json) }
    it { should route(:get, '/notes/1').to(action: :show, format: :json, id: 1) }
    it { should route(:get, '/notes').to(action: :index, format: :json) }
    it { should route(:patch, '/notes/1').to(action: :update, format: :json, id: 1) }
    it { should route(:delete, '/notes/1').to(action: :destroy, format: :json, id: 1) }
  end

  describe 'create' do
    it { should use_before_action(:authenticate) }

    it do
      skip('Possible bug in shoulda-matchers, see https://git.io/vr5XS')
      params = {note: Fabricate.attributes_for(:note)}
      permitted_params = %i(title body)
      should permit(*permitted_params).for(:create, params: params).on(:note)
    end

    context 'with valid parameters' do
      let(:note_params) { Fabricate.attributes_for(:note, user: user).merge(tags: tags) }

      it 'saves a new note to the database' do
        expect { create_note(note_params, user.auth_token) }.to change(Note, :count).by(1)
      end

      it 'tags a note by its owner' do
        tags = FFaker::Lorem.words(rand(1..3))
        create_note(note_params.merge(tags: tags.join(',')), user.auth_token)

        expect(Note.first.tags_from(user)).to match_array(tags)
      end
    end

    context 'with invalid parameters' do
      let(:note_params) { Fabricate.attributes_for(:note, body: nil) }

      it 'does not save a new note to the database' do
        expect { create_note(note_params, user.auth_token) }.not_to change(Note, :count)
      end
    end
  end

  describe 'show' do
    it { should use_before_action(:authenticate) }
  end

  describe 'index' do
    it { should use_before_action(:authenticate) }
  end

  describe 'update' do
    let(:note) { Fabricate(:note) }

    it { should use_before_action(:authenticate) }

    it do
      skip('Possible bug in shoulda-matchers, see https://git.io/vr5XS')
      params = {id: note.id, note: {title: 'New title', body: 'New body'}}
      permitted_params = %i(title body)
      should permit(*permitted_params).for(:update, params: params).on(:note)
    end

    context 'with valid parameters' do
      let(:note_params) { {title: 'New title', body: 'New body', tags: 'some,new,tags'} }

      before(:each) do
        update_note(note.id, note_params, note.user.auth_token)
        note.reload
      end

      it 'saves note with updated attributes' do
        expect(note.title).to eq(note_params[:title])
        expect(note.body).to eq(note_params[:body])
      end

      it 'tags a note with new tags' do
        expect(note.tags_from(note.user)).to match_array(note_params[:tags].split(','))
      end
    end

    context 'with invalid parameters' do
      let(:note_params) { {title: nil, body: nil} }

      it 'does not save note with updated attributes' do
        update_note(note.id, note_params, note.user.auth_token)
        note.reload

        expect(note.title).not_to eq(note_params[:title])
        expect(note.body).not_to eq(note_params[:body])
      end
    end
  end

  describe 'destroy' do
    it { should use_before_action(:authenticate) }

    it 'deletes the note' do
      note = Fabricate(:note)

      expect do
        destroy_note(note.id, note.user.auth_token)
      end.to change(Note, :count).by(-1)
    end
  end
end
