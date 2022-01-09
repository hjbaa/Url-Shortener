# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
describe 'application' do
  before(:each) do
    User.delete_all
    Url.delete_all
    visit root_path
  end

  it 'should not sign up', js: true do
    click_on 'Sign Up'
    fill_in 'user[email]', with: '123@mail.ru'
    fill_in 'user[name]', with: 'kek'
    fill_in 'user[password]', with: 'meme'
    fill_in 'user[password_confirmation]', with: '1488'
    click_on 'Register!'
    expect(page.body).to include('Password is too short')
    expect(page.body).to include('Password complexity requirement not met')
  end

  it 'Should sign up', js: true do
    click_on 'Sign Up'
    fill_in 'user[email]', with: 'sample@test.com'
    fill_in 'user[name]', with: 'Egor'
    fill_in 'user[password]', with: 'QwER@!213'
    fill_in 'user[password_confirmation]', with: 'QwER@!213'
    click_on 'Register!'
    expect(page.body).to include('Welcome to the app, Egor!')
  end

  it 'Should log in', js: true do
    FactoryBot.create(:user, email: 'sample@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    expect(page.body).to include('Welcome back, Egor!')
  end

  it 'Should not let guest/based user visit admins page', js: true do
    visit admin_users_path
    expect(page.body).to include('You are not signed in!')
    FactoryBot.create(:user, email: 'sample@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    visit admin_users_path
    expect(page.body).to include('Not Authorized!')
  end

  it 'Should create new short url', js: true do
    expect do
      fill_in 'url[url]', with: 'vk.com'
      click_on 'Get short url!'
      expect(page.body).to include('Your short url:')
    end.to change { Url.count }.from(0).to(1)
  end

  it 'Should not create short url', js: true do
    fill_in 'url[url]', with: 'abcd'
    click_on 'Get short url!'
    click_on 'redirected'
    expect(page.body).to include('Invalid input for URL!')
  end

  it 'Should edit users information', js: true do
    FactoryBot.create(:user, email: 'sample@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    click_on 'Egor'
    click_on 'Edit profile'
    fill_in 'user[password]', with: 'QwER@!2133'
    fill_in 'user[password_confirmation]', with: 'QwER@!2133'
    fill_in 'user[old_password]', with: 'QwER@!213'
    click_on 'Save'
    expect(page.body).to include('Your profile was successfully updated!')
  end

  it 'Should log out', js: true do
    FactoryBot.create(:user, email: 'sample@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    click_on 'Egor'
    click_on 'Log Out'
    expect(page.body).to include('See you later!')
  end

  it 'Should get admin panel', js: true do
    FactoryBot.create(:user, email: 'sample1@test.com', name: 'Egor', password: 'QwER@!213', role: 1)
    FactoryBot.create(:user, email: 'sample2@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample1@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    visit admin_users_path
    expect(page.body).to include('sample1@test.com')
    expect(page.body).to include('sample2@test.com')
  end

  it 'Should edit user using admin panel', js: true do
    FactoryBot.create(:user, email: 'sample1@test.com', name: 'Egor', password: 'QwER@!213', role: 1)
    FactoryBot.create(:user, email: 'sample2@test.com', name: 'Egor', password: 'QwER@!213')
    click_on 'Log In'
    fill_in 'email', with: 'sample1@test.com'
    fill_in 'password', with: 'QwER@!213'
    click_on 'Sign In!'
    visit admin_users_path
    click_on 'Edit', match: :first
    fill_in 'user[password]', with: 'AbcD!@12'
    fill_in 'user[password_confirmation]', with: 'AbcD!@12'
    click_on 'Save'
    expect(page.body).to include('User successfully updated!')
  end
end
# rubocop:enable Metrics/BlockLength
