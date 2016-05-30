# frozen_string_literal: true
module V1
  class NotesController < ApplicationController
    def create
      note = current_user.notes.build(note_params)
      current_user.tag(note, with: params[:note][:tags], on: :tags)
      if note.save
        render json: note
      else
        render json: {message: 'Validation failed.', errors: note.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    private

      def note_params
        params.require(:note).permit(:title, :body)
      end
  end
end
