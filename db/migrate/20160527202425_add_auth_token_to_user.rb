# frozen_string_literal: true
class AddAuthTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string, null: false
    add_index :users, :auth_token, unique: true
  end
end
