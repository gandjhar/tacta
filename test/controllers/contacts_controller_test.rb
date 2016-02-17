require 'test_helper'

class ContactsControllerTest < ActionController::TestCase

   test "should get index" do
      get :index
      assert_response :success
   end

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
