# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::NotesController, type: :controller do
  let(:user) { Fabricate(:user) }

  describe 'create' do
    it do
      pending('Possible bug in shoulda-matchers')
      params = {note: Fabricate.attributes_for(:note)}
      permitted_params = %i(title body)
      should permit(*permitted_params).for(:create, params: params)
    end

    it { should route(:post, '/notes').to(action: :create, format: :json) }

    it { should use_before_action(:authenticate) }

    context 'with valid parameters' do
      let(:note_params) { Fabricate.attributes_for(:note, user: user).merge(tags: tags) }

      it 'saves a new note to the database' do
        expect { create_note(note_params, user.auth_token) }.to change(Note, :count).by(1)
      end

      it 'tags a note by its owner' do
        tags = FFaker::Lorem.words(rand(1..3))
        create_note(note_params.merge(tags: tags.join(',')), user.auth_token)

        expect(Note.first.tags_from(user)).to contain_exactly(*tags)
      end

      it do
        create_note(note_params, user.auth_token)

        should respond_with(200)
      end
    end

    context 'with invalid parameters' do
      let(:note_params) { Fabricate.attributes_for(:note, body: nil) }

      it 'does not save a new user to the database' do
        expect { create_note(note_params, user.auth_token) }.not_to change(Note, :count)
      end

      it do
        create_note(note_params, user.auth_token)

        should respond_with(422)
      end
    end
  end
end

def create_note(params, token)
  request.headers.merge!(accept_header)
  request.headers.merge!(authorization_header(token))
  post :create, note: params
end
