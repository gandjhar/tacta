Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'

   root 'contacts#index'

end
