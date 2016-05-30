# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    let(:user) { Fabricate(:user) }
    let(:note_params) { Fabricate.attributes_for(:note).merge(tags: tags) }

    include_context 'unauthenticated' do
      before(:each) { post_notes(note_params, nil) }
    end

    context 'authenticated request' do
      context 'with valid paramters' do
        let(:note_params) { Fabricate.attributes_for(:note).merge(tags: tags) }

        before(:each) { post_notes(note_params, user.auth_token) }

        assert_response_code(200)

        assert_json_schema('note')

        it 'returns a note with correct attributes' do
          note = JSON.parse(response.body, symbolize_names: true)[:note]
          expect(note[:title]).to eq(note_params[:title])
          expect(note[:body]).to eq(note_params[:body])
          expect(note[:tags]).to eq(note_params[:tags])
        end
      end

      context 'with invalid paramters' do
        let(:note_params) { Fabricate.attributes_for(:note, body: nil).merge(tags: tags) }

        before(:each) { post_notes(note_params, user.auth_token) }

        include_examples 'validation failed'

        it 'returns the validation errors', skip_before: true do
          note = Fabricate.build(:note, note_params.except(:tags))
          note.valid?
          post_notes(note_params, user.auth_token)

          expect(JSON.parse(response.body)['errors']).to match(note.errors.full_messages)
        end
      end
    end
  end

  describe 'GET /notes/:id' do
    let(:note) { Fabricate(:note) }

    include_context 'unauthenticated' do
      before(:each) { get_note(note.id, nil) }
    end

    context 'authenticated request' do
      context 'note exists and requester is owner' do
        before(:each) { get_note(note.id, note.user.auth_token) }

        assert_response_code(200)

        assert_json_schema('note')

        it 'return the correct note' do
          response_note = JSON.parse(response.body, symbolize_names: true)[:note]

          expect(response_note[:title]).to eq note.title
          expect(response_note[:body]).to eq note.body
          expect(response_note[:tags]).to contain_exactly(*note.tags_from(note.user))
          expect(response_note[:user_id]).to eq note.user.id
        end
      end

      context "note doesn't exists" do
        before(:each) { get_note(note.id + rand(1..10), note.user.auth_token) }

        include_examples 'record not found'
      end

      context 'requester is not owner' do
        let(:another_user) { Fabricate(:user) }

        before(:each) { get_note(note.id, another_user.auth_token) }

        include_examples 'record not found'
      end
    end
  end
end

def post_notes(params, token)
  headers = [accept_header, authorization_header(token)].reduce(&:merge)
  post '/notes', {note: params}, headers
end

def get_note(note_id, token)
  headers = [accept_header, authorization_header(token)].reduce(&:merge)
  get "/notes/#{note_id}", {}, headers
end
