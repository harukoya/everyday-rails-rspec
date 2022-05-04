require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  scenario "user creates a new project" do
    sign_in user

    expect {
      go_to_create_new_project_page
      insert_project_name "Test Project"
      insert_project_description "Trying out Capybara"
      submit_create_project
    }.to change(user.projects, :count).by(1)

    expect_create_project "Test Project"
  end

  scenario "edit project" do
    sign_in user
    go_to_edit_project_page project.name

    expect_edit_project_page project.name
  end

  def go_to_create_new_project_page
    visit root_path
    click_link "New Project"
  end

  def go_to_edit_project_page(project_name)
    visit root_path
    click_link project_name
  end

  def insert_project_name(name)
    fill_in "Name", with: name
  end

  def insert_project_description(description)
    fill_in "Description", with: description
  end

  def submit_create_project
    click_button "Create Project"
  end

  def expect_create_project(project_name)
    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content project_name
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  def expect_edit_project_page(project_name)
    aggregate_failures do
      expect(page).to have_content project_name
      expect(page).to have_content "Owner: #{user.name}"
      expect(page).to have_link "Edit"
    end
  end

  scenario "user completes a project" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)

    sign_in user
    visit project_path(project)

    expect(page).to_not have_content "Completed"

    click_button "Complete"

    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end
