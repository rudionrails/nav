require 'rubygems'
require 'minitest/autorun'

require 'rr'

begin
  require 'action_view'
rescue LoadError
  STDERR.puts "Unable to run Nav tests."
else
  require File.dirname(__FILE__) + "/../lib/nav"
end


class MiniTest::Unit::TestCase
  include RR::Adapters::TestUnit

end
