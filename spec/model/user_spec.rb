require 'rails_helper'

RSpec.describe User, type: :model do
  it 'Should not validate user' do
    usr = User.new(name: 'Egor', password: 'abcd', email: 'qwert')
    expect(usr.valid?).to be_falsey
  end

  it 'Should validate user' do
    usr = User.new(name: 'Egor', password: 'QweRtY!@223', email: 'sample@test.com')
    expect(usr.valid?).to be_truthy
  end
end
