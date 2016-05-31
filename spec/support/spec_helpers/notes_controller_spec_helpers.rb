# frozen_string_literal: true
module NotesControllerSpecHelpers
  def create_note(params, token)
    request.headers.merge!(accept_header)
    request.headers.merge!(authorization_header(token))
    post :create, note: params
  end

  def show_note(note_id, token)
    request.headers.merge!(accept_header)
    request.headers.merge!(authorization_header(token))
    get :show, id: note_id
  end

  def update_note(note_id, params, token)
    request.headers.merge!(accept_header)
    request.headers.merge!(authorization_header(token))
    patch :update, id: note_id, note: params
  end

  def destroy_note(note_id, token)
    request.headers.merge!(accept_header)
    request.headers.merge!(authorization_header(token))
    delete :destroy, id: note_id
  end
end
