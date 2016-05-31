# frozen_string_literal: true
module NotesRequestSpecHelpers
  def post_notes(params, token = nil)
    post '/notes', {note: params}, headers(token)
  end

  def get_note(note_id, token = nil)
    get "/notes/#{note_id}", {}, headers(token)
  end

  def get_notes(token = nil)
    get '/notes', {}, headers(token)
  end

  def patch_note(note_id, params, token = nil)
    patch "/notes/#{note_id}", {note: params}, headers(token)
  end

  def delete_note(note_id, token = nil)
    delete "/notes/#{note_id}", {}, headers(token)
  end

  private

    def headers(token)
      [accept_header, authorization_header(token)].reduce(&:merge)
    end
end
