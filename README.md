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
