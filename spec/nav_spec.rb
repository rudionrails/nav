RSpec.describe Nav do
  let(:view) { ActionView::Base.new }

  before do
    allow(view).to receive(:current_page?) { false }
  end

  it 'renders the <ul> element' do
    html = view.nav(id: 'my-nav') do |n|
      n.action 'Home', '/home'
    end
    document = Nokogiri::HTML(html)

    ul = document.xpath('//ul').first
    expect(ul['id']).to eq('my-nav')
    expect(ul.xpath('li').length).to eq(1)
  end
end
