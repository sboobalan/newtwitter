class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

  end

  def type_change
	@users = User.all.where("designation != 'admin'").paginate(:page => params[:page], :per_page => 10)
  end
  def status_set
        @user = User.find(params[:user_id])
        @user.update_attributes(:designation => params["format"])
	@query = "$(\"##{params[:user_id]}\").text(\"#{params[:format]}\")"
	render js: @query
  end


  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create

    if( User.find_by username: params["user"]["username"])
	respond_to do |format|
	  format.html {redirect_to new_user_url, notice: 'Username already exists'}
	end
    elsif(!(params["user"]["password"] .eql? params["user"]["confirm_password"]))
	respond_to do |format|
	  format.html {redirect_to new_user_url, notice: 'Passwords doesnot match'}
	end
    elsif(User.find_by email: params["user"]["email"])
	respond_to do |format|
	  format.html {redirect_to new_user_url, notice: 'Email Id already exists'}
	end
    else
    @user = User.new(user_params)
    @user.designation="user"
    respond_to do |format|
      if @user.save
	session[:username] = params["user"]["username"]
	puts "aaaaaaaaaaaaaaaaaaaaaa"
	puts session[:username]
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        #format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
   end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
	if( User.find_by username: params[:uname])
		@newuser = User.find_by username: params[:uname]
		puts @newuser,"aaaaaaaaaaaaaaa"
		if(@newuser[:password] .eql? params[:password])
			respond_to do |format|
				if(@newuser[:designation]) .eql? "moderator"
					session[:username] = params[:uname]
					puts @newuser[:designation]
					format.html { redirect_to new_tweet_url}
				else
					format.html { redirect_to new_tweet_url, flash[:notice] => "LoggedIn Successfully" }
					session[:username] = params[:uname]
					#format.json { render :show, status: :created, location: @newuser }
				end
			end
		else
			respond_to do |format|
				format.html {redirect_to users_url, notice: 'Invalid password'}
			end
		end
	else
		respond_to do |format|
			format.html {redirect_to users_url, notice: 'Invalid username'}
		end
	end

  end
  def check_user


      @checkuser = User.find_by username: params[:username]
      if @checkuser .nil?

	render js: ""

      elsif(@checkuser[:username] .eql? params[:username])
	render js: "username already exist"
      end

  end

  def checkmail_user


      @checkuser = User.find_by email: params[:email]
      if @checkuser .nil?

	render js: " "

      elsif(@checkuser[:email] .eql? params[:email])
	render js: "email Id already exist"
      end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :username, :password, :email, :designation)
    end
end
