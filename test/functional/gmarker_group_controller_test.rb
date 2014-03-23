require File.dirname(__FILE__) + '/../test_helper'
require 'gmarker_group_controller'

# Re-raise errors caught by the controller.
class GmarkerGroupController; def rescue_action(e) raise e end; end

class GmarkerGroupControllerTest < Test::Unit::TestCase
  def setup
    @controller = GmarkerGroupController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
