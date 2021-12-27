class UrlsController < ApplicationController
  before_action :find_url, only: %i[show destroy redirect]
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_url_not_found

  def new
    @url = Url.new
  end

  def create
    destroy_expired_urls
    proto, domain = url_parsing(params[:url])
    key = generate_key
    if proto.nil?
      Url.create!(domain_path: domain, key: key)
    else
      Url.create!(protocol: proto, domain_path: domain, key: key)
    end
    @short_url = "#{root_url.gsub('http://', '')}#{key}"
  end

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
    Url.destroy_all.where(created_at < 1.hour.ago)
  end

  def find_url
    @url = Url.find_by!(key: params[:key])
  end

  def url_parsing(full_url)
    return [nil, full_url] if full_url.count('http://').zero?

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
