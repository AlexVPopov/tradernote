# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    let(:user) { Fabricate(:user) }
    let(:note_params) { Fabricate.attributes_for(:note).merge(tags: tags) }

    context 'unauthenticated request' do
      before(:each) { post_notes(note_params, nil) }

      assert_response_code(401)

      assert_json_schema('unauthorized')
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

        assert_response_code(422)

        assert_json_schema('errors')

        it 'returns the validation errors', skip_before: true do
          note = Fabricate.build(:note, note_params.except(:tags))
          note.valid?
          post_notes(note_params, user.auth_token)

          expect(JSON.parse(response.body)['errors']).to match(note.errors.full_messages)
        end
      end
    end
  end
end

def post_notes(params, token)
  headers = [accept_header, authorization_header(token)].reduce(&:merge)
  post '/notes', {note: params}, headers
end
