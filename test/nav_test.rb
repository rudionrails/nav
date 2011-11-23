require File.expand_path( File.dirname(__FILE__) + '/test_helper' )

describe Nav do

  # <ul id="nav">
  #   <li class="">before <a href="/">test</a></li>
  # </ul>

  before do
    @view = ActionView::Base.new
    @view.output_buffer = ''

    stub( @view ).current_page? { false }
  end

  it "should render ul with given html options" do
    nav = @view.nav(:id => 'my-nav') { |n| n.action('my-link', '/link') }
    assert_match /<ul.*id=\"my-nav\">.*<\/ul>/, nav.to_s
  end

  it "should render li" do
    nav = @view.nav { |n| n.action('my-link', '/link') }
    assert_match /<li.*>.*<\/li>/, nav.to_s
  end

  it "should render link" do
    nav = @view.nav { |n| n.action('my-link', '/link') }
    assert_match /<a.*href=\"\/link\">my-link<\/a>/, nav.to_s
  end

  it "should render :prepend options before the link" do
    nav = @view.nav { |n| n.action('my-link', '/link', :prepend => 'something before') }
    assert_match /<li.*>something before<a/, nav.to_s
  end

  it "should render :append options after the link" do
    nav = @view.nav { |n| n.action('my-link', '/link', :append => 'something after') }
    assert_match /<\/a>something after<\/li>/, nav.to_s
  end

end
