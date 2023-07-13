require 'spec_helper'

feature 'fae_file_form' do

  scenario 'should display uploader', js: true do
    admin_login
    visit new_admin_release_path

    expect(page).to have_css('.release_label_pdf_asset button.button')
  end

end
