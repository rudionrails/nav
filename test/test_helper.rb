require 'minitest/autorun'

require 'action_view'
require 'rr'

require File.dirname(__FILE__) + "/../lib/nav"

class MiniTest::Spec
  include RR::Adapters::MiniTest

end
