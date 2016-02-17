require 'test_helper'

class ContactTest < ActiveSupport::TestCase

   test "should save new contact" do
      contact = Contact.new( name: "Alan Turing", phone: "+44 20 7123 7654", email: "auto@mata.net" )
      assert contact.save
   end

end
