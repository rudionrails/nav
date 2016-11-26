require File.dirname(__FILE__) + '/nav/builder'

module Nav #:nodoc:
  def nav(options = {}, &block)
    Nav::Builder.new(self, options, &block).build
  end
end

ActionView::Base.send(:include, Nav)
