Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'
   get 'contacts/:id' => 'contacts#show'

   root 'contacts#index'

end
