require File.dirname(__FILE__) + '/lib/nav'

if defined?( ActionView::Base )
  ActionView::Base.send :include, Nav
end
