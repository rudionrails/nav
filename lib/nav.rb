module Nav

  autoload :Builder, File.dirname(__FILE__) + '/nav/builder'

  def nav( options = {}, &block )
    Nav::Builder.new( self, options, &block ).to_s
  end

end

ActionView::Base.send :include, Nav

