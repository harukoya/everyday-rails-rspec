require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is late when the due date is past today" do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  it "is on time when the due date is today" do
    project = FactoryBot.create(:project, :due_today)
    expect(project).to_not be_late
  end

  it "is on time when the due date is in the furute" do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).to_not be_late
  end

  it "is invalid without name" do
    invalid_project = FactoryBot.build(:project, name: nil)
    invalid_project.valid?
    expect(invalid_project.errors[:name]).to include("can't be blank")
  end

  it "does not allow duplicate project names per user" do
    owner = FactoryBot.build(:user)
    FactoryBot.create(:project, owner: owner, name: "Test Project")
    new_project = FactoryBot.build(:project, owner: owner, name: "Test Project")
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    FactoryBot.create(:project, name: "Test Project")
    other_owner = FactoryBot.build(:user)
    other_project = FactoryBot.build(:project, owner: other_owner, name: "Test Project")

    expect(other_project).to be_valid
  end

  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
end
