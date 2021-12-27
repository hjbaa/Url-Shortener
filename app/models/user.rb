class User < ApplicationRecord
  has_many :urls

  has_secure_password
end
