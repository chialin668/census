require File.dirname(__FILE__) + '/../test_helper'
require 'school_county_controller'

# Re-raise errors caught by the controller.
class SchoolCountyController; def rescue_action(e) raise e end; end

class SchoolCountyControllerTest < Test::Unit::TestCase
  def setup
    @controller = SchoolCountyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
