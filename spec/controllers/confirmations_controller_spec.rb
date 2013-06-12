require 'spec_helper'

describe ConfirmationsController do

  before (:each) do
    @user = FactoryGirl.create(:unconfirmed_registered_user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET '/user/confirmation?confirmation_token=abcdef'" do

    before(:each) do
      get :show, :confirmation_token => @user.confirmation_token
    end

    it "should be successful" do
      response.should be_success
    end

    it "should render confirmation view" do
      response.should render_template("devise/confirmations/show")
    end

  end

  describe "PUT '/user/confirmation'" do

    context "valid attributes" do
      before(:each) do
        @new_name = { first_name: 'Jeremy', last_name: 'Guscott', 
          honorific: 'Mr', other_names: 'Frederick', preferred_name: 'Jerry'}
        @user = FactoryGirl.create(:unconfirmed_registered_user)
        @params = { user: @user.attributes, confirmation_token: @user.confirmation_token }
        @params[:user][:name_attributes] = @new_name
        @params[:user].merge!(password: 'changeme', password_confirmation: 'changeme')
      end

      it "located the requested @user" do
        put :update, @params
        @user.reload
        assigns(:user).should eq(@user)
      end

      it "changes @user's attributes" do
        put :update, @params
        @user.reload
        @user.name.full_name.should eq 'Mr Jeremy Frederick Guscott'
      end

      it "should be successful" do
        response.should be_success
      end

    end

    context "invalid attributes" do
      before(:each) do
        @user = FactoryGirl.create(:unconfirmed_registered_user)
      end

      it "should reject invalid confirmation token" do
        @params = { user: @user.attributes, confirmation_token: "somejunkstring" }
        put :update, @params
        response.should render_template('devise/confirmations/new')
      end

      it "should reject invalid password" do
        @params = { user: @user.attributes, confirmation_token: @user.confirmation_token }
        @params[:user].merge!(password: 'changeme', password_confirmation: 'password')
        put :update, @params
        response.should render_template('devise/confirmations/show')
      end

      it "should reject invalid name" do
        @new_name = { first_name: nil, last_name: nil, other_names: 'Frederick', preferred_name: 'Jerry'}
        @params = { user: @user.attributes, confirmation_token: @user.confirmation_token }
        @params[:user][:name_attributes] = @new_name
        @params[:user].merge!(password: 'changeme', password_confirmation: 'changeme')
        put :update, @params
        response.should render_template('devise/confirmations/show')
      end

      it "does not change @user's attributes for invalid name" do
        original_name = @user.name
        @new_name = { other_names: 'Frederick', preferred_name: 'Jerry'}
        @params = { user: @user.attributes, confirmation_token: @user.confirmation_token }
        @params[:user][:name_attributes] = @new_name
        @params[:user].merge!(password: 'changeme', password_confirmation: 'changeme')
        put :update, @params
        @user.name.should eq original_name 
      end

    end

  end

end
