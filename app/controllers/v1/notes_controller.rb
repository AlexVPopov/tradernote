# frozen_string_literal: true
module V1
  class NotesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def create
      note = current_user.notes.build(note_params)
      current_user.tag(note, with: params[:note][:tags], on: :tags)
      note.save ? render(json: note) : render_validation_failed(note)
    end

    def show
      render json: find_note
    end

    def index
      render json: notes
    end

    def update
      note = find_note
      if note.update(note_params)
        current_user.tag(note, with: params[:note][:tags], on: :tags)
        render json: note
      else
        render_validation_failed(note)
      end
    end

    def destroy
      find_note.destroy ? head(:no_content) : render_not_found
    end

    private

      def find_note
        current_user.notes.find(params[:id])
      end

      def note_params
        params.require(:note).permit(:title, :body)
      end

      def render_not_found
        render json: {message: 'Record not found'}, status: :not_found
      end

      def render_validation_failed(note)
        render json: {message: 'Validation failed', errors: note.errors.full_messages},
               status: :unprocessable_entity
      end

      def notes
        current_user.notes
                    .title_matches(params[:title])
                    .body_matches(params[:body])
                    .tag_matches(params[:tag])
                    .any_matches(params[:any])
      end
  end
end
