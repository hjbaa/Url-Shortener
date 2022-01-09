# frozen_string_literal: true

class AddNullConstraintToUrls < ActiveRecord::Migration[6.1]
  def change
    change_column_null :urls, :user_id, true
  end
end
