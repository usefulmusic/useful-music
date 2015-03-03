require_relative '../test_config'

class HomeControllerTest < MyRecordTest
  include ControllerTesting

  def app
    HomeController
  end

  def test_home_page_is_available
    assert_ok get '/'
  end

end
