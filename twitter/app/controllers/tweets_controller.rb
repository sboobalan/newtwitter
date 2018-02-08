class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :twt, only: [:create, :new, :indexn,:index,:mod_front]

  def index
    @tweets = Tweet.all
    puts session[:username],"ddddddddddddddddddddd"
  end

  def set_stat
        @tweet = Tweet.find(params[:tweet_id])
        @tweet.update_attributes(:status => params["format"])
        @tweet.update_attributes(:approvedby => session[:username])
	@query = "$(\"##{params[:tweet_id]}\").text(\"#{params[:format]}\")"
	render js: @query
  end

  def indexn
     	puts params
	user=Tweet.find(params[:tweet_id])
	@tweets = Tweet.all.where("username= ? AND status='active'",user[:username]).order(created_at: :desc, updated_at: :desc)
	@uname = session[:username]

	puts "aaaaaaaaaaaaaaaaaaaaaaa" +  @uname

  end

  def moderator
  end
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    

    @twts = Tweet.all.where("status='active'").order(created_at: :desc, updated_at: :desc)


  end

  # GET /tweets/1/edit
  def edit
  end

    # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.status="inactive"
    
    @tweet.username=@uname
    @tweets = Tweet.all
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweet_indexn_url(@tweet), notice: 'Tweet is submitted for approval.' }
        format.json { render :indexn, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to tweet_indexn_url(@tweet), notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mod_front
	@tweets = Tweet.all
	render :mod_front
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:username, :text, :status, :approvedby)
    end
    def twt
	@uname = session[:username]
	@twts = Tweet.all.where("status='active'").order(created_at: :desc, updated_at: :desc)
	@usr=Tweet.all.where("username= ? ",@uname)[0]
	@type=(User.find_by username: @uname)[:designation]
	puts @type,"ssssssssssssssssssssssssssssss",@usr
    end
end
