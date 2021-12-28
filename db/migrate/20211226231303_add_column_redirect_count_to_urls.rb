# frozen_string_literal: true

class AddColumnRedirectCountToUrls < ActiveRecord::Migration[6.1]
  def change
    add_column :urls, :redirect_count, :integer, null: false, default: 0
  end
end
