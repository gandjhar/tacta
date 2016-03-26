# Tacta

Rails example of a simple Contact Manager.

## New

Generate new rails app.  

```
> rails new tacta
```

## Model

Create the Contact model.

```
> rails generate model contact name:string phone:string email:string
```

Adds a model file:

```ruby
# app/models/contact.rb

class Contact < ActiveRecord::Base
end
```

And a migration:

```ruby
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
```

## Migrate

Migrate the Database.

```
> rake db:migrate
```

Adds the Model's table to the database, with columns for name, phone, and email.

## Seeds

Create some database seeds for Contacts.

```ruby
# db/seeds.rb

Contact.create( { name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       } )
Contact.create( { name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  } )
Contact.create( { name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" } )
Contact.create( { name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" } )
Contact.create( { name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     } )
```    

Seed the database:

```
> rake db:seed
```

Or reset the database if you have already seeded it before.  Clears out the old data first.

```
> rake db:reset
```

May give a drop table error if open in a DB viewer or elsewhere, but ok.

## Console

Check to see the data in the database.

```
> rails console

irb(main):008:0>  Contact.all.each { |c| puts c.inspect }

Contact Load (1.0ms)  SELECT "contacts".* FROM "contacts"

#<Contact id: 1, name: "Thomas Jefferson", phone: "+1 206 310 1369", email: "tjeff@us.gov", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
#<Contact id: 2, name: "Charles Darwin", phone: "+44 20 7123 4567", email: "darles@evolve.org", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
#<Contact id: 3, name: "Nikola Tesla", phone: "+385 43 987 3355", email: "nik@inductlabs.com", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
#<Contact id: 4, name: "Genghis Khan", phone: "+976 2 194 2222", email: "contact@empire.com", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
#<Contact id: 5, name: "Malcom X", phone: "+1 310 155 8822", email: "x@roost.org", created_at: "2016-02-14 10:51:15", updated_at: "2016-02-14 10:51:15">
```

## Controller

Generate controller for Contacts.

```
> rails generate controller contacts
```

Produces

```ruby
# app/controllers/contacts_controller.rb

class ContactsController < ApplicationController
end
```

## Index View

Add Index action method to controller.

```ruby
class ContactController < ApplicationController

   def index
      @contacts = Contact.all
   end

end
```

Create index view.

```html
# app/views/contacts/index.html.erb

<h1>Contacts</h1>

<% @contacts.each do |contact| %>
    <p><%= contact.name %></p>
<% end %>
```

Add index to routes.

```ruby
# config/routes.rb

Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'

end
```

## Root

Set home page to be index.

```ruby
Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'

   root 'contacts#index'

end
```

## Show View

Add Show action method to controller.

```ruby
class ContactsController < ApplicationController

   def index
      @contacts = Contact.all
   end

   def show
      @contact = Contact.find( params[:id] )
   end

end
```

Create a Show view.

```html
# app/views/show.html.erb

<h1><%= @contact.name %></h1>

<p>Phone: <%= @contact.phone %></p>
<p>Email: <%= @contact.email %></p>
```

Add a show route.

```ruby
Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'
   get 'contacts/:id' => 'contacts#show'

   root 'contacts#index'

end
```

## Links

Link contacts on index page to their show page.

```html
<% @contacts.each do |contact| %>
    <p><%= link_to contact.name, contact_path( contact.id ) %></p>
<% end %>
```

Augment show route to generate the contact_path helper.

```ruby
Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'
   get 'contacts/:id' => 'contacts#show', as: :contact

end
```

## Home Link

Add a link to home in the application layout, that will appear on all pages.

```ruby
# app/views/layouts/application.html.erb

...

<body>

<%= yield %>

<br><br>
<hr>

<%= link_to "[All Contacts]", root_path %>

</body>
```

## New Contact

Add a New action method to Contact controller.

```ruby
class ContactsController < ApplicationController

   ...

   def new
      @contact = Contact.new
   end

end
```

Create a New Contact form.

```html
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
```

Add a New Contact route.  Must be before the Show route, or it will match first.

```ruby
Rails.application.routes.draw do

   get 'contacts' => 'contacts#index'
   get 'contacts/new' => "contacts#new"
   get 'contacts/:id' => 'contacts#show', as: :contact

end
```

Able to now see the form at

```
localhost:3000/contacts/new
```

## New Link

Add link to New Contact to Index page.

```html
<h1>Contacts</h1>

<% @contacts.each do |contact| %>
    <p><%= link_to contact.name, contact_path( contact.id ) %></p>
<% end %>

<%= link_to "[New Contact]", new_contact_path %>
```

Augment route to generate new_contact_path helper used in the link.

```ruby
get 'contacts/new' => "contacts#new", as: :new_contact
```

## Create Contact

Add Create action method to Contacts controller, to handle form submit.

```ruby
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
```

Add route for create post.

```ruby
Rails.application.routes.draw do

   ...

   get 'contacts/new' => "contacts#new", as: :new_contact
   post 'contacts' => "contacts#create"

end
```

## Edit Form

To share the form for edit and new, create a \_form partial view.

```html
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
```

Note the change to the submit button, to test for new or edit.

Alter the New view to use the partial.

```html
<h1>New Contact</h1>

<%= render "form" %>
```

Create an Edit view with the same partial.

```html
<h1>Edit Contact</h1>

<%= render "form" %>
```

Add an edit route

```ruby
Rails.application.routes.draw do

   ...

   get 'contacts/new' => "contacts#new", as: :new_contact
   get 'contacts/:id/edit' => 'contacts#edit'

end
```

Now can view the edit form at

```
localhost:3000/contacts/5/edit
```

## Edit Link

Add Edit link to Contact Show view.

```html
<h1><%= @contact.name %></h1>

<p>Phone: <%= @contact.phone %></p>
<p>Email: <%= @contact.email %></p>

<%= link_to "[Edit]", edit_contact_path( @contact.id ) %>
```

Augment route to generate edit_contact_path helper used in the link.

```ruby
get 'contacts/:id/edit' => 'contacts#edit', as: :edit_contact
```

## Update

Add Update action method to Contacts controller, to handle edit form submit.

```ruby
def update
  @contact = Contact.find( params[:id] )

  contact_params = params.require( :contact ).permit( :name, :phone, :email )

  if @contact.update_attributes( contact_params )
     redirect_to @contact
  else
     render 'edit'
  end
end
```

Add route for update patch.

```ruby
Rails.application.routes.draw do

   ...

   post 'contacts' => "contacts#create"
   patch 'contacts/:id' => "contacts#update"

end
```

Now submiting the edit form will update the database.

## Factor contact_params

Factor the common code for contact params into a private method.

```ruby
class ContactsController < ApplicationController

   ...

private

   def contact_params
      params.require( :contact ).permit( :name, :phone, :email )
   end

end
```

Remove the old code for contact_params from the create and update methods.

## Delete Contact

Add Destroy action method to Contacts controller.

```ruby
class ContactsController < ApplicationController

   ...

   def destroy
      @contact = Contact.find( params[:id] )

      @contact.destroy

      redirect_to contacts_path
   end

end
```

Add a Delete link to the Contact Show page.

```html
<h1><%= @contact.name %></h1>

<p>Phone: <%= @contact.phone %></p>
<p>Email: <%= @contact.email %></p>

<%= link_to "[Edit]", edit_contact_path( @contact.id ) %>
<%= link_to "[Delete]", contact_path( @contact.id ), method: :delete, data: { confirm: "Are you sure?" } %>
```

Add route for delete Contact to the destroy Contact action.

```ruby
Rails.application.routes.draw do

   ...

   delete 'contacts/:id' => "contacts#destroy"

end
```

## Resources Routes

The many routes for individual actions can be replaced with a resources statement.

```ruby
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
```

Could have used resources from the beginning, but instructive to see the code for each route.

## Test Index

Test to see if index page renders without errors.

```ruby
# app/test/controllers/contacts_controller_test.rb

class ContactsControllerTest < ActionController::TestCase

   test "should get index" do
      get :index
      assert_response :success
   end

end
```

Make some records for the Test Database

```yaml
tjeff:
   name: Thomas Jefferson
   phone: +1 206 310 1369
   email: tjeff@us.gov

cdar:
   name: Charles Darwin
   phone: +44 20 7123 4567
   email: darles@evolve.org

cdar:
   name: Nikola Tesla
   phone: +385 43 987 3355
   email: nik@inductlabs.com

cdar:
   name: Genghis Khan
   phone: +976 2 194 2222
   email: contact@empire.com

cdar:
   name: Malcom X
   phone: +1 310 155 8822
   email: x@theroost.org
```

Run tests

```
> rake test

Finished in 0.405137s, 2.4683 runs/s, 2.4683 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

## Tests - Show, Edit & New

Test to get Show, Edit and New pages.

```ruby
class ContactsControllerTest < ActionController::TestCase

   ...

   test "should get show" do
      get :show, id: contacts(:tjeff).id
      assert_response :success
   end

   test "should get new" do
      get :new
      assert_response :success
   end

   test "should get edit" do
      get :edit, id: contacts(:tjeff).id
      assert_response :success
   end

end
```

## Test Create, Update and Delete

Test for modify actions Create, Update and Delete

```ruby
class ContactsControllerTest < ActionController::TestCase

   ...

   test "should create contact" do
      assert_difference( 'Contact.count' ) do
         post :create, contact: { name: "Nelson Mandela", phone: "+27 21 654-4321", email: "mandela@change.org" }
      end

      assert_redirected_to contact_path( assigns( :contact ) )
   end

   test "should update contact" do
      patch :update, id: contacts(:cdar).id, contact: { name: "Albert Einstein", phone: "+49 40 2244 3355", email: "space@time.org" }

      assert_redirected_to contact_path( assigns(:contact) )
   end

   test "should destroy contact" do
      assert_difference('Contact.count', -1) do
         delete :destroy, id: contacts(:cdar).id
      end

      assert_redirected_to contacts_path
   end
end
```

## Test Model

A simple model test to create a new Contact.

```ruby
# test/models/contact_test.rb

class ContactTest < ActiveSupport::TestCase

   test "should save new contact" do
      contact = Contact.new( name: "Alan Turing", phone: "+44 20 7123 7654", email: "auto@mata.net" )
      assert contact.save
   end

end
```

## Validation & Forms

Add validations to Contact that enforce rules about the data.

```ruby
# app/models/contact.rb

class Contact
   validates :name, presence: true
   validates :name, uniqueness: true

   validates :phone, allow_blank: true, length: { in: 5..20 }
   validates :email, allow_blank: true, length: { in: 5..50 }

   validates_format_of :phone, allow_blank: true, :with => /\A[+ 0-9]+$\z/
   validates_format_of :email, allow_blank: true, :with => /@/, message: 'must contain @.'
end
```

A save operation to the database will fail if data is not valid.  On failure, Rails attaches error  to the object.  When save fails in the controller, we rerender the form.

```ruby
class ContactsController

   # ...

   def create
      @contact = Contact.new( contact_params )

      if @contact.save
         redirect_to @contact
      else
         render 'new'
      end
   end

end
```

And similar to fail to update on edit.

```ruby
class ContactsController

   # ...

   def update
      @contact = Contact.find( params[:id] )

      if @contact.update_attributes( contact_params )
         redirect_to @contact
      else
         render 'edit'
      end
   end

end
```

Display the error messages in the Contact form.

```html+erb
<%= form_for @contact do |f| %>

   <ul>
      <% @contact.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
      <% end %>
   </ul>

   <%= f.label :name %>
   <%= f.text_field :name %>
   <%= f.label :phone %>
   <%= f.text_field :phone, size: 15 %>
   <%= f.label :email %>
   <%= f.text_field :email, size: 20 %>
   <%= f.submit (@contact.new_record? ? "Create" : "Update") %>
<% end %>
```

Rails also wraps the error fields in divs automatically.  After errors, the form will render to something like

```html
<form class="new_contact" id="new_contact" action="/contacts" method="post">

   <ul>
          <li>Name can&#39;t be blank</li>
   </ul>

   <div class="field_with_errors"><label for="contact_name">Name</label></div>
   <div class="field_with_errors"><input type="text" value="" name="contact[name]" id="contact_name" /></div>
   <label for="contact_phone">Phone</label>
   <input size="15" type="text" value="" name="contact[phone]" id="contact_phone" />
   <label for="contact_email">Email</label>
   <input size="20" type="text" value="" name="contact[email]" id="contact_email" />
   <input type="submit" name="commit" value="Create" />
</form>
```

Highlight the fields with errors using style rules to give a red border and background.

```css
div.field_with_errors {
    display: inline;

    input {
        padding: 2px 2px;
        border: 1px solid #E66;
        background-color: #FFF7F7;
    }
}
```

## Summary

The Rails version of Tacta builds on concepts from the Ruby and Sinatra versions, adding

- Rails
- Models
- Databases
- Migrations
- Routes to Controllers & Actions
- Resources
- Link helpers
- Form helpers
- Safe params
- Validation
- Partials
- Form errors
- Testing (Controller Actions and Models)

And strengthens concepts

- Views
- Erb
- Restful Structure

Does not cover
- Multiple models, Joins, Many to X
- Sessions
- Users/Login & Devise
