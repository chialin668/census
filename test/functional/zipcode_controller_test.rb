require File.dirname(__FILE__) + '/../test_helper'
require 'zipcode_controller'

# Re-raise errors caught by the controller.
class ZipcodeController; def rescue_action(e) raise e end; end

class ZipcodeControllerTest < Test::Unit::TestCase
  def setup
    @controller = ZipcodeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
