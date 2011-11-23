require File.dirname(__FILE__) + '/nav/builder'

module Nav

  def nav( options = {}, &block )
    Nav::Builder.new( self, options, &block )
  end

end

ActionView::Base.send :include, Nav

