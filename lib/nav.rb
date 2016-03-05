module Nav #:nodoc:
  def nav(options = {}, &block)
    Nav::Builder.new(self, options, &block).build
  end
end

require File.join(File.dirname(__FILE__), 'nav', 'builder')

require 'action_view/base'
ActionView::Base.send :include, Nav
