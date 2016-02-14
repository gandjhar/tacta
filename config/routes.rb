Rails.application.routes.draw do

   resources :contacts
   # get 'contacts' => 'contacts#index'
   # get 'contacts/new' => "contacts#new", as: :new_contact
   # get 'contacts/:id/edit' => 'contacts#edit', as: :edit_contact
   # get 'contacts/:id' => 'contacts#show', as: :contact
   # post 'contacts' => "contacts#create"
   # patch 'contacts/:id' => "contacts#update"
   # delete 'contacts/:id' => "contacts#destroy"

   root 'contacts#index'

end
