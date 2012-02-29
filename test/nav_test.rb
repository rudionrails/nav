require_relative 'test_helper'

describe Nav do

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

  # TODO: Add test cases for actions with blocks
end
