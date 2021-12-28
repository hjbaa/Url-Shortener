# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_authentication

    def index
      @users = User.order(created_at: :desc)
    end

  end
end
