require_relative 'test_helper'
puts 'awesome'

describe Nav do

  # <ul id="nav">
  #   <li class="">before <a href="/">test</a></li>
  #   <li class="">before <a href="#" onclick="new Ajax.Request('/', {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('7016ef6fd7413d836cd720a6071e22e4f14e0212')}); return false;">test</a></li>
  # </ul>

  before do
    @view = ActionView::Base.new
    @view.output_buffer = ''

    stub( @view ).current_page? { false }
  end

  it "should display ul" do
    m = @view.nav(:id => 'my-nav') { |m| m.action('my-link', '/link') }
    assert_match(/<ul.*id=\"my-nav\">.*<\/ul>/, m)
  end

  it "should display li" do
    m = @view.nav { |m| m.action('my-link', '/link') }
    assert_match(/<li.*>.*<\/li>/, m)
  end

  it "should display link" do
    m = @view.nav { |m| m.action('my-link', '/link') }
    assert_match(/<a.*href=\"\/link\">my-link<\/a>/, m)
  end

  it "should display :prepend options before the link" do
    m = @view.nav { |m| m.action('my-link', '/link', :prepend => 'something before') }
    assert_match(/<li.*>something before<a/, m)
  end
  
  it "should display :append options after the link" do
    m = @view.nav { |m| m.action('my-link', '/link', :append => 'something after') }
    assert_match(/<\/a>something after<\/li>/, m)
  end

end
