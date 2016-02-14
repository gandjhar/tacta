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



