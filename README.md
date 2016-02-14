# Tacta

Rails example of a simple Contact List.

## New

Generate new rails app.

    > rails new tacta

## Model

Create the Contact model.

    > rails generate model contact name:string phone:string email:string

Adds a model file:

    # app/models/contact.rb

    class Contact < ActiveRecord::Base
    end

And a migration:

    # db/migrate/20160214094710_create_contacts.rb

    class CreateContacts < ActiveRecord::Migration
      def change
        create_table :contacts do |t|
          t.string :name
          t.string :phone
          t.string :email

          t.timestamps null: false
        end
      end
    end

## Migrate

Migrate the Database.

    > rake db:migrate

Adds the Models table to the database, with columns for name, phone, and email.

## Seeds

Create some database seeds for Contacts.

    # db/seeds.rb

    Contact.create( { name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       } )
    Contact.create( { name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  } )
    Contact.create( { name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" } )
    Contact.create( { name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" } )
    Contact.create( { name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     } )

Seed the database:

    > rake db:seed

Or reset the database if you have already seeded it before.  Clears out the old data first.

    > rake db:reset

May give a drop table error if open in a DB viewer or elsewhere, but ok.

## Console

Check to see the data in the database.

    > rails console

    irb(main):008:0>  Contact.all.each { |c| puts c.inspect }

    Contact Load (1.0ms)  SELECT "contacts".* FROM "contacts"

    #<Contact id: 1, name: "Thomas Jefferson", phone: "+1 206 310 1369", email: "tjeff@us.gov", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
    #<Contact id: 2, name: "Charles Darwin", phone: "+44 20 7123 4567", email: "darles@evolve.org", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
    #<Contact id: 3, name: "Nikola Tesla", phone: "+385 43 987 3355", email: "nik@inductlabs.com", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
    #<Contact id: 4, name: "Genghis Khan", phone: "+976 2 194 2222", email: "contact@empire.com", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
    #<Contact id: 5, name: "Malcom X", phone: "+1 310 155 8822", email: "x@roost.org", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">

## Controller

Generate controller for Contacts.

    > rails generate controller contacts

Produces

    # app/controllers/contacts_controller.rb

    class ContactsController < ApplicationController
    end

## Index View

Add Index action method to controller.

    class ContactController < ApplicationController

       def index
          @contacts = Contact.all
       end

    end

Create index view.

    # app/views/contacts/index.html.erb

    <h1>Contacts</h1>

    <% @contacts.each do |contact| %>
        <p><%= contact.name %></p>
    <% end %>

Add index to routes.

    # config/routes.rb

    Rails.application.routes.draw do

       get 'contacts' => 'contacts#index'

    end

## Root

Set home page to be index.

    Rails.application.routes.draw do

       get 'contacts' => 'contacts#index'

       root 'contacts#index'

    end

## Show View

Add Show action method to controller.

    class ContactsController < ApplicationController

       def index
          @contacts = Contact.all
       end

       def show
          @contact = Contact.find( params[:id] )
       end

    end

Create a Show view.

    # app/views/show.html.erb

    <h1><%= @contact.name %></h1>

    <p>Phone: <%= @contact.phone %></p>
    <p>Email: <%= @contact.email %></p>

Add a show route.

    Rails.application.routes.draw do

       get 'contacts' => 'contacts#index'
       get 'contacts/:id' => 'contacts#show'

       root 'contacts#index'

    end

## Links

Link contacts on index page to their show page.

    <% @contacts.each do |contact| %>
        <p><%= link_to contact.name, contact_path( contact.id ) %></p>
    <% end %>

Augment show route to generate the contact_path helper.

    Rails.application.routes.draw do

       get 'contacts' => 'contacts#index'
       get 'contacts/:id' => 'contacts#show', as: :contact

    end

## Home Link

Add a link to home in the application layout, that will appear on all pages.

    # app/views/layouts/application.html.erb

    ...

    <body>

    <%= yield %>

    <br><br>
    <hr>

    <%= link_to "[All Contacts]", root_path %>

    </body>

## New Contact

Add a New action method to Contact controller.

    class ContactsController < ApplicationController

       ...

       def new
          @contact = Contact.new
       end

    end

Create a New Contact form.

    <h1>New Contact</h1>

    <%= form_for @contact do |f| %>

        <%= f.label :name %>
        <%= f.text_field :name %>

        <%= f.label :phone %>
        <%= f.text_field :phone, size: 15 %>

        <%= f.label :email %>
        <%= f.text_field :email, size: 20 %>

        <%= f.submit "Create" %>

    <% end %>

Add a New Contact route.  Must be before the Show route, or it will match first.

    Rails.application.routes.draw do

       get 'contacts' => 'contacts#index'
       get 'contacts/new' => "contacts#new"
       get 'contacts/:id' => 'contacts#show', as: :contact

    end

Able to now see the form at

    localhost:3000/contacts/new

## New Link

Add link to New Contact to Index page.

    <h1>Contacts</h1>

    <% @contacts.each do |contact| %>
        <p><%= link_to contact.name, contact_path( contact.id ) %></p>
    <% end %>

    <%= link_to "[New Contact]", new_contact_path %>

Augment route to generate new_contact_path helper used in the link.

    get 'contacts/new' => "contacts#new", as: :new_contact

## Create Contact

Add Create action method to Contacts controller, to handle form submit.

    class ContactsController < ApplicationController

       ...

       def create
          contact_params = params.require( :contact ).permit( :name, :phone, :email )

          @contact = Contact.new( contact_params )

          if @contact.save
             redirect_to @contact
          else
             render 'new'
          end
       end

    end

Add route for create post.

    Rails.application.routes.draw do

       ...

       get 'contacts/new' => "contacts#new", as: :new_contact
       post 'contacts' => "contacts#create"

    end

## Edit Form

To share the form for edit and new, create a _form partial view.

    # app/views/contacts/_form.html.erb

    <%= form_for @contact do |f| %>

        <%= f.label :name %>
        <%= f.text_field :name %>

        <%= f.label :phone %>
        <%= f.text_field :phone, size: 15 %>

        <%= f.label :email %>
        <%= f.text_field :email, size: 20 %>

        <%= f.submit (@contact.new_record? ? "Create" : "Update") %>

    <% end %>

Note the change to the submit button, to test for new or edit.

Alter the New view to use the partial.

    <h1>New Contact</h1>

    <%= render "form" %>

Create an Edit view with the same partial.

    <h1>Edit Contact</h1>

    <%= render "form" %>

Add an edit route

    Rails.application.routes.draw do

       ...

       get 'contacts/new' => "contacts#new", as: :new_contact
       get 'contacts/:id/edit' => 'contacts#edit'

    end

Now can view the edit form at

    localhost:3000/contacts/5/edit

## Edit Link

Add Edit link to Contact Show view.

    <h1><%= @contact.name %></h1>

    <p>Phone: <%= @contact.phone %></p>
    <p>Email: <%= @contact.email %></p>

    <%= link_to "[Edit]", edit_contact_path( @contact.id ) %>

Augment route to generate edit_contact_path helper used in the link.

    get 'contacts/:id/edit' => 'contacts#edit', as: :edit_contact

## Update

Add Update action method to Contacts controller, to handle edit form submit.

       def update
          @contact = Contact.find( params[:id] )

          contact_params = params.require( :contact ).permit( :name, :phone, :email )

          if @contact.update_attributes( contact_params )
             redirect_to @contact
          else
             render 'edit'
          end
       end

Add route for update patch.

    Rails.application.routes.draw do

       ...

       post 'contacts' => "contacts#create"
       patch 'contacts/:id' => "contacts#update"

    end

Now submiting the edit form will update the database.




