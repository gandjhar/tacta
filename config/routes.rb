Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'
   get 'contacts/new' => "contacts#new", as: :new_contact
   get 'contacts/:id/edit' => 'contacts#edit'
   get 'contacts/:id' => 'contacts#show', as: :contact
   post 'contacts' => "contacts#create"

   root 'contacts#index'

end
