require 'minitest/autorun'


begin
  require 'action_view'
  require 'rr'
rescue LoadError
  STDERR.puts "Unable to run Nav tests."
else
  require File.dirname(__FILE__) + "/../rails/init"
end


class MiniTest::Unit::TestCase
  include RR::Adapters::TestUnit
  
end
