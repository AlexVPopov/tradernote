# frozen_string_literal: true
module V1
  class NotesController < ApplicationController
    def create
      note = current_user.notes.build(note_params)
      current_user.tag(note, with: params[:note][:tags], on: :tags)
      if note.save
        render json: note
      else
        render json: {message: 'Validation failed', errors: note.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    def show
      note = current_user.notes.find_by(id: params[:id])
      if note
        render json: note
      else
        render json: {message: 'Record not found'}, status: :not_found
      end
    end

    def index
      render json: current_user.notes
    end

    private

      def note_params
        params.require(:note).permit(:title, :body)
      end
  end
end
