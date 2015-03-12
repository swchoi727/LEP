class UsersController < ApplicationController

  #@user = nil

  def new
    @user = User.new
  end

  def create
    #@auth = request.env['omniauth.auth']['credentials']
    #@email = request.env['omniauth.auth']['info']['email']
    @user = User.new(user_params)
    @user.application = true
    @user.admin = false
    @user.save
    redirect_to user_path(@user)
  end

  def index
    @users = User.all
  end

  def show
    #@id = params[:id]
    @id = @user.pluck(:id)
    @user = User.find(@id) #this is nil right now
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
  end

  def home
    @email = request.env['omniauth.auth']['info']['email']
    if @email =~ /.*berkeley.edu$/
      @user = User.where(:email => @email)
      #no application yet
      if @user.blank?
        redirect_to new_user_path
      else
        is_admin = @user.pluck(:admin)
        print "**********************", @user.id
        session[:id] = @user.id
        redirect_to user_path(@user.pluck[:id]) if not is_admin 
        redirect_to admin_path(@user.pluck[:id]) if is_admin
      end
    else
      redirect_to users_invalid_path :email => @email
    end
  end

def invalid
  @email = params[:email]
end

  private

  #rails 4 idiosyncracy; helper method for create
  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :sid, :email, :academic_title, :major, :residency,
                                :gender, :gender_preference, :fluent_languages, :lang_additional_info,
                                :first_lang_preference, :first_lang_proficiency, :second_lang_preference,
                                :second_lang_proficiency, :time_preference, :time_additional_info, 
                                :user_motivation, :user_plan, :admin, :application)
  end

end
