# frozen_string_literal: true

module Admin
  class UrlsController < ApplicationController
    before_action :require_authentication
    before_action :set_url!, only: %i[edit update destroy]
    before_action :authorize_user!

    def index
      @urls = Url.order(created_at: :desc)
    end

    def destroy
      @url.destroy
      flash[:success] = 'Url successfully destroyed!'
      redirect_to admin_urls_path
    end

    private

    def set_url!
      @url = Url.find(params[:id])
    end

    def authorize_user!
      authorize([:admin, @user || User])
    end
  end
end
