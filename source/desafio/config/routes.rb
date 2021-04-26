Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root :to => 'quote#index'
    get "quotes/:tag", to: "quote#show", :via => :all
    post 'authenticate', to: 'authentication#authenticate'
    resources :user
end
