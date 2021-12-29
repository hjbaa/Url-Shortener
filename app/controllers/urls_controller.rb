# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :find_url, only: %i[show destroy redirect]
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_url_not_found

  def new
    @url = Url.new
  end

  # rubocop:disable Metrics/AbcSize
  def create
    destroy_expired_urls if Url.count.positive?

    begin
      proto, domain = url_parsing(params[:url][:url])
    rescue RuntimeError
      flash[:error] = 'Invalid input for URL!'
      redirect_to root_url, status: '400 Bad Request'
      return
    end

    key = generate_key
    key = generate_key until Url.find_by_key(key).blank?

    if proto.nil?
      Url.create!(domain_path: domain, key: key, user: current_user)
    else
      Url.create!(protocol: proto, domain_path: domain, key: key, user: current_user)
    end

    @short_url = "#{root_url.gsub('http://', '')}#{key}"
  end
  # rubocop:enable Metrics/AbcSize

  def destroy; end

  def show; end

  def redirect
    @url.update!(redirect_count: @url.redirect_count + 1)
    link = @url.protocol + @url.domain_path
    redirect_to link, status: '308 Permanent Redirect'
  end

  private

  DICT = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'10').to_a

  def rescue_with_url_not_found
    redirect_to root_url, status: :not_found
  end

  def destroy_expired_urls
    Url.where(created_at: 5.year.ago..1.hour.ago).destroy_all
  end

  def find_url
    @url = Url.find_by!(key: params[:key])
  end

  def url_parsing(full_url)
    raise 'Invalid input for url!' unless full_url =~ %r{^(https?://)?.*\..*$}

    return [nil, full_url] unless full_url =~ %r{^https?://.*$}

    protocol = full_url.slice(0..full_url.index('/') + 1)
    domain_path = full_url.gsub(protocol, '')
    [protocol, domain_path]
  end

  def generate_key
    key = ''
    6.times do
      key += DICT.sample
    end
    key
  end
end
