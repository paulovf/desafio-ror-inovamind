Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get "quotes/:tag", to: "quote#show", :via => :all
    #post "user/create", to: "user#create", :via => :all
    #post "user/update", to: "user#update", :via => :all
    #post "user/delete", to: "user#destroy", :via => :all
    post 'authenticate', to: 'authentication#authenticate'
    resources :user
end
