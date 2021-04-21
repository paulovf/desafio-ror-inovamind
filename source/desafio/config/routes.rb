Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get "quotes/:tag", to: "quote#show", :via => :all
end
