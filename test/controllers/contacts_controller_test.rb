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

end
