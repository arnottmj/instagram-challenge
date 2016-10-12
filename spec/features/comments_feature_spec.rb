require 'rails_helper'

feature "comments" do
  context 'when not logged in' do
    scenario 'a visitor cannot leave a comment' do
      Picture.create(name:'test',
                     avatar_file_name: 'test.jpg',
                     avatar_file_size: '10',
                     avatar_content_type: 'image/jpeg')
      visit '/pictures'
      click_link 'comment'
      expect(page).to have_content 'Log in'
    end

    scenario 'a visitor cannot delete a comment' do
      Picture.create(name:'test',
                     avatar_file_name: 'test.jpg',
                     avatar_file_size: '10',
                     avatar_content_type: 'image/jpeg')
      visit '/pictures'
      # click_link 'comment'
      # expect(page).to have_content 'Log in'
      expect(page).not_to have_link('delete comment', exact: true)
    end
  end

  context 'when logged in' do
    before do
      sign_up
      new_picture
      leave_comment
    end

    scenario 'allows users to leave a comment using a form' do
      expect(current_path).to eq '/pictures'
      expect(page).to have_content('so so')
    end

    scenario 'allows users to delete a comment if it belongs to them' do
      visit '/pictures'
      click_link 'delete comment'
      expect(page).not_to have_content 'delete comment'
      expect(page).to have_content 'Comment deleted successfully'
    end

    scenario 'doesnt allow users to delete a comment if it doesnt belong to them' do
      click_link('Sign out')
      sign_up_2
      expect(page).not_to have_link('delete comment', exact: true)

    end

    def sign_up
      visit '/pictures'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@makers.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
    end

    def sign_up_2
      visit '/pictures'
      click_link 'Sign up'
      fill_in 'Email', with: 'test2@makers.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
    end

    def new_picture
      visit '/pictures'
      click_link 'Add a picture'
      attach_file 'Avatar', 'spec/features/test.jpg'
      fill_in 'Name', with: 'test'
      click_button 'Create Picture'
    end

    def leave_comment
      visit '/pictures'
      click_link 'comment'
      fill_in "Thoughts", with: "so so"
      click_button 'Post comment'
    end
  end
end

