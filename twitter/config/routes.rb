Rails.application.routes.draw do
  get "/mod_front" => "tweets#mod_front"
  post "/users/dpchange" => "users#dpchange"
  get "users/getDp" => "users#getDp"
  get "users/changepassword" =>"users#passwordChange"
  get "/filter_tweets" => "tweets#filter_tweets"
  resources :tweets do
    get 'set_stat' => 'tweets#set_stat'
    get "indexn"
  end
  resources :users do
    get "/status_set" => 'users#status_set'
  end
  get "/moderator" => 'tweets#moderator'
  get "/type_change" => 'users#type_change'
  get "/stats" => "tweets#statistics"
  post 'users/login'
  get "/check_user" => "users#check_user"
  get "/checkmail_user" => "users#checkmail_user"
end
