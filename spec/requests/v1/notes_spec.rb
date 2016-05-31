# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Notes', type: :request, scope: :notes do
  describe 'POST /notes' do
    let(:user) { Fabricate(:user) }
    let(:note_params) { Fabricate.attributes_for(:note).merge(tags: tags) }

    include_context 'unauthenticated' do
      before(:each) { post_notes(note_params) }
    end

    context 'authenticated request' do
      context 'with valid paramters' do
        let(:note_params) { Fabricate.attributes_for(:note).merge(tags: tags) }

        before(:each) { post_notes(note_params, user.auth_token) }

        assert_response_code(200)

        assert_json_schema('note')

        it 'returns a note with correct attributes' do
          note = extract(response, :note)
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

          expect(extract(response, :errors)).to match(note.errors.full_messages)
        end
      end
    end
  end

  describe 'GET /notes/:id' do
    let(:note) { Fabricate(:note) }

    include_context 'unauthenticated' do
      before(:each) { get_note(note.id) }
    end

    context 'authenticated request' do
      context 'note exists and requester is note owner' do
        before(:each) { get_note(note.id, note.user.auth_token) }

        assert_response_code(200)

        assert_json_schema('note')

        it 'return the correct note' do
          response_note = extract(response, :note)

          expect(response_note[:title]).to eq note.title
          expect(response_note[:body]).to eq note.body
          expect(response_note[:tags]).to match_array(note.tags_from(note.user))
          expect(response_note[:user_id]).to eq note.user.id
        end
      end

      context "note doesn't exists" do
        before(:each) { get_note(note.id + rand(1..10), note.user.auth_token) }

        include_examples 'record not found'
      end

      context 'requester is not note owner' do
        let(:other_user) { Fabricate(:user) }

        before(:each) { get_note(note.id, other_user.auth_token) }

        include_examples 'record not found'
      end
    end
  end

  describe 'GET /notes' do
    let!(:user) { Fabricate(:user) }
    let!(:notes) { Fabricate.times(3, :note, user: user) }
    let!(:other_user) { Fabricate(:user) }
    let!(:other_notes) { Fabricate.times(3, :note, user: other_user) }

    include_context 'unauthenticated' do
      before(:each) { get_notes }
    end

    context 'authenticated' do
      before(:each) { get_notes(user.auth_token) }

      assert_response_code(200)

      assert_json_schema('notes')

      it 'returns the correct notes' do
        response_notes = extract(response, :notes)
        titles = response_notes.map { |note| note[:title] }
        bodies = response_notes.map { |note| note[:body] }
        response_tags = response_notes.map { |note| note[:tags] }
        user_ids = response_notes.map { |note| note[:user_id] }.uniq
        note_tags = notes.map { |note| note.tags_from(note.user) }

        expect(response_notes.count).to eq notes.count
        expect(titles).to match_array(notes.map(&:title))
        expect(bodies).to match_array(notes.map(&:body))
        expect(response_tags.flatten).to match_array(note_tags.flatten)
        expect(user_ids).to include(user.id)
        expect(user_ids).not_to include(other_user.id)
      end
    end
  end

  describe 'PATCH /notes/:id' do
    let(:note) { Fabricate(:note) }
    let(:update_prams) { {title: 'New title'} }

    include_context 'unauthenticated' do
      before(:each) { patch_note(note.id, update_prams) }
    end

    context 'authenticated' do
      context 'requester is note owner' do
        context 'with valid paramters' do
          before(:each) do |example|
            if example.metadata[:skip_before].blank?
              patch_note(note.id, update_prams, note.user.auth_token)
            end
          end

          assert_response_code(200)

          assert_json_schema('note')

          it 'updates title' do
            response_note = extract(response, :note)

            expect(response_note[:title]).to eq(update_prams[:title])
          end

          it 'updates body', skip_before: true do
            note_params = {body: 'New body'}
            patch_note(note.id, note_params, note.user.auth_token)
            response_note = extract(response, :note)

            expect(response_note[:body]).to eq(note_params[:body])
          end

          it 'updates tags', skip_before: true do
            note_params = {tags: 'new tag,another new tag'}
            patch_note(note.id, note_params, note.user.auth_token)
            response_note = extract(response, :note)

            expect(response_note[:tags]).to eq(note_params[:tags].split(',').map(&:strip))
          end

          it 'removes tags', skip_before: true do
            patch_note(note.id, {tags: nil}, note.user.auth_token)
            response_note = extract(response, :note)

            expect(response_note[:tags]).to be_blank
          end
        end

        context 'with invalid paramters' do
          let(:note_params) { {title: nil, body: nil} }

          before(:each) { patch_note(note.id, note_params, note.user.auth_token) }

          include_examples 'validation failed'
        end
      end

      context 'requester is not note owner' do
        let(:other_user) { Fabricate(:user) }

        before(:each) { patch_note(note.id, update_prams, other_user.auth_token) }

        include_examples 'record not found'
      end
    end
  end

  describe 'DELETE /notes/:id' do
    let(:note) { Fabricate(:note) }

    include_context 'unauthenticated' do
      before(:each) { delete_note(note.id) }
    end

    context 'authenticated' do
      context 'requester is owner of note and note exists' do
        before(:each) { delete_note(note.id, note.user.auth_token) }

        assert_response_code(204)

        it 'response body has not content' do
          expect(response.body).to be_blank
        end
      end

      context 'note does not exist' do
        before(:each) { delete_note(note.id + rand(1..10), note.user.auth_token) }

        include_examples 'record not found'
      end

      context 'requester is not owner of note' do
        let(:other_user) { Fabricate(:user) }

        before(:each) { delete_note(note.id, other_user.auth_token) }

        include_examples 'record not found'
      end
    end
  end
end
