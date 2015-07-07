require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user=User.create(name:"wilda", email:"dddd@dd.com")
  	@micropost= Micropost.new(content:"ddd", user_id: @user.user_id)
  end

  test "Should be valid" do 
  	assert @micropost.valid?
  end
  test "user id should be present" do 
  	@micropost.user_id = nil
  	assert_not @micropost.valid?
  end
end
