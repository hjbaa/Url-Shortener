# frozen_string_literal: true

class Url < ApplicationRecord
  belongs_to :user, optional: true

  validates :protocol, format: /\Ahttps?:\/\/\Z/
  validates :domain_path, format: /\A.+\..+\Z/, presence: true
  validates :key, presence: true

end
