require 'spec_helper'

describe UsersController do

  describe '#new' do
  	it 'renders form template' do
      get :new
      expect(response).to render_template('new')
  	end
  end

  describe '#create' do
    let(:valid_params) { {'user' => {first_name: 'Bob', id: 5, email: 'bob@berkeley.edu'} }}
    it 'creates a user' do
      post :create, valid_params
      assigns(:user).should be_persisted
    end
  end

  describe '#index' do
  	it 'renders index template' do
  	  get :index
  	  expect(response).to render_template('index')
  	end
  end

  describe '#show' do
    before :each do
      @user = double(User, first_name: 'Jane', id: '10', admin: false)
    end
    it 'should call User with find' do
      User.should_receive(:find).with(@user.id).and_return(double('User'))
      get :show, id: '10'
    end
    it 'should call check_email and redirect when the email is invalid' do
      get :show, {:id => "10"}, {:invalid_email => "lep@gmail.com"}
      response.should redirect_to users_invalid_path
      flash[:warning].should eq("lep@gmail.com is not a valid email. \n Please Logout and reauthenticate with a Berkeley email address.")
    end
    it "'should call check_user and redirect when the user id doesn't match" do
      get :show, {:id => "5"}, {:id => "10"}
      assigns(:admin).should be_false
      response.should redirect_to user_path(session[:id])
    end
  end

  describe '#edit' do
    before :each do
      @user = double(User, first_name: 'John', id: '27')
    end
    it 'should call User with find' do
      User.should_receive(:find).with(@user.id).and_return(double('User'))
      get :edit, id: '27'
    end
  end

  describe '#destroy' do
    before :each do
      @user = User.create(id: 2, first_name: 'Bob', email: 'delete@berkeley.edu', admin: false)
    end

    it 'should redirect to admin path when admin deletes a user' do
      @admin = User.create(first_name: 'Admin', id: 1, admin: true)
      get(:destroy, {id: @user.id}, {id: @admin.id})
      response.should redirect_to admins_path
    end

    it 'should redirect to user path when user tries to delete a user' do
      get(:destroy, {id: @user.id}, {id: @user.id})
      response.should redirect_to user_path(session[:id])
    end
  end

  # describe '#home' do
  #   # before :each do
  #   #   @user = double(User, first_name: 'John', id: '27', email: 'john@berkeley.edu')
  #   #   @invalid_user = double(User, first_name: 'Billy', id: '3', email: 'billy@gmail.com')
  #   # end
  #   context 'berkeley email' do
  #     before :each do
  #       @user = double(User, first_name: 'John', id: '27', email: 'john@berkeley.edu')
  #     end
  #     it 'is a new user' do
  #     end
  #     it 'is an old user' do
  #     end
  #   end
  #   context 'invalid email' do
  #     before :each do
  #       @invalid_user = double(User, first_name: 'Billy', id: '3', email: 'billy@gmail.com')
  #     end
  #     it 'redirects to invalid page' do
  #       flash[:warning].should_not be_blank
  #     end
  #   end
  # end

end
