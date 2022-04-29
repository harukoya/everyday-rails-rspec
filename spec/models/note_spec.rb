require 'rails_helper'

RSpec.describe Note, type: :model do
  before :each do
    @user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavillion"
    )

    @project = @user.projects.create(
      name: "Test Project"
    )
  end

  it "generates associated data from a factory" do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end

  it "is valid with a user, project, and message" do
    note = Note.new(
      message:  "This is a sample note.",
      user:     @user,
      project:  @project
    )
    expect(note).to be_valid
  end

  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "search message for a term" do
    before :each do
      @note1 = @project.notes.create(
        message:  "This is the first note.",
        user:     @user
      )
      @note2 = @project.notes.create(
        message:  "This is the second note.",
        user:     @user
      )
      @note3 = @project.notes.create(
        message:  "First, preheat the oven.",
        user:     @user
      )
    end

    context "when a match is found" do
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
        expect(Note.search("first")).to_not include(@note2)
      end
    end

    context "when no match is found" do
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
