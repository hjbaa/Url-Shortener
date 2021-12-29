# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'should not validate url' do
    url = Url.new(domain_path: 'abcd', protocol: 'qqqq')
    expect(url.valid?).to be_falsey
  end

  it 'should validate url' do
    url = Url.new(key: 'abcd', domain_path: 'vk.com')
    expect(url.valid?).to be_truthy
  end

  it 'should create url with default protocol' do
    url = Url.new
    expect(url.protocol).to eq('https://')
  end
end
