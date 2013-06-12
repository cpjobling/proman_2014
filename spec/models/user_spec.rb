require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      name: { honorific: "Mr",
              last_name: "User",
              first_name: "Example",
              other_names: "A.",
              preferred_name: "Andy"
      },
      :email => "user@#{ENV['EMAIL_DOMAIN']}",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[123456@swan.ac.uk a.p.rofessor@swan.ac.uk 123456@swansea.ac.uk a.p.rofessor@swansea.ac.uk]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@ac,uk user_at_swan.ac.uk example.user@swan.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses from invalid domains" do
    addresses = %w[user@example.com user@foo.com user@cardiff.ac.uk]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should accept email addresses from valid domains" do
    addresses = %w[user@swan.ac.uk user@swansea.ac.uk]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  def title
    read_attribute(:title)
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  

  describe 'roles' do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    describe "default user role" do
      it "should have student role" do
        @user.has_role?(:student).should be_true
      end
    end

    describe '#admin?' do
      it "should not be admin by default" do
        @user.admin?.should be_false
      end

      it "should be admin when admin role added" do
        @user.add_role(:admin)
        @user.admin?.should be_true
      end
    end

    describe '#student' do
      it "should be student by default" do
        @user.student?.should be_true
      end

      it "should be possible to not be a student" do
        @user.remove_role(:student)
        @user.student?.should be_false
      end
    end

    describe '#supervisor' do
      it "should not be supervisor by default" do
        @user.supervisor?.should be_false
      end

      it "should be possible to add supervisor role" do
        @user.add_role(:supervisor)
        @user.supervisor?.should be_true
      end
    end

    describe '#supervisor'

  end

  describe "name" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a name attribute" do
      @user.should respond_to(:name)
    end

    it "should have a name attribute" do
      @user.name.should eq Name.new(@attr[:name])
    end

    it "should have a honorific attribute" do
      @user.should respond_to(:honorific)
    end

    it "should return the user's honorific" do
      @user.honorific.should eq @attr[:name][:honorific]
    end

    it "should have a first_name attribute" do
      @user.should respond_to(:first_name)
    end

    it "should return the user's first name" do
      @user.first_name.should eq @attr[:name][:first_name]
    end

    it "should have a last_name attribute" do
      @user.should respond_to(:last_name)
    end

    it "should return the user's last name" do
      @user.last_name.should eq @attr[:name][:last_name]
    end

    it "should have a other_names attribute" do
      @user.should respond_to(:other_names)
    end

    it "should return the user's other names" do
      @user.other_names.should eq @attr[:name][:other_names]
    end

    it "should have a preferred_name attribute" do
      @user.should respond_to(:preferred_name)
    end

    it "should return the user's preferred name" do
      @user.preferred_name.should eq @attr[:name][:preferred_name]
    end

    it "should return a name" do
      @user.name.to_s.should == "Mr Example A. User"
    end

  end

  describe "name validations" do

    before(:each) do
      @user = User.new(email: @attr[:email])
    end

    it "should be valid without other names and preferred name" do
      @attr[:name].merge!(other_names: "", preferred_name: "")
      @user.update_attributes(@attr)
      @user.should be_valid
    end

    it "should require honorific (title)" do
      @attr[:name].merge!(honorific: "")
      @user.update_attributes(@attr)
      @user.should_not be_valid
    end

    it "should validate first_name" do
      @attr[:name].merge!(first_name: "")
      @user.update_attributes(@attr)
      @user.should_not be_valid
    end

    it "should validate last name" do
       @attr[:name].merge!(last_name: "")
       @user.update_attributes(@attr)
       @user.should_not be_valid
    end

  end

end
