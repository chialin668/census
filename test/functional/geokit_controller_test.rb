require File.dirname(__FILE__) + '/../test_helper'
require 'geokit_controller'

# Re-raise errors caught by the controller.
class GeokitController; def rescue_action(e) raise e end; end

class GeokitControllerTest < Test::Unit::TestCase
  def setup
    @controller = GeokitController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
