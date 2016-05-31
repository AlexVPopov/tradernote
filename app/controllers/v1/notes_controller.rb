# frozen_string_literal: true
module V1
  class NotesController < ApplicationController
    def create
      note = current_user.notes.build(note_params)
      current_user.tag(note, with: params[:note][:tags], on: :tags)
      note.save ? render(json: note) : render_validation_failed(note)
    end

    def show
      note = current_user.notes.find_by(id: params[:id])
      note ? render(json: note) : render_not_found
    end

    def index
      render json: current_user.notes
    end

    def update
      note = current_user.notes.find_by(id: params[:id])
      if note&.update(note_params)
        current_user.tag(note, with: params[:note][:tags], on: :tags)
        render json: note
      elsif note
        render_validation_failed(note)
      else
        render_not_found
      end
    end

    private

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
  end
end
