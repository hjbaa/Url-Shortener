# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :protocol, default: 'https://'
      t.string :domain_path, null: false
      t.string :key, unique: true, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
