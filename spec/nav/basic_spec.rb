RSpec.describe Nav::Builder do
  it 'renders noting when no actions are present' do
    builder = Nav::Builder.new(view)
    expect(builder.build).to be_nil
  end

  context 'when actions are present' do
    let(:options) do
      {
        id: 'my-nav',
        data: { stuff: 'awesome' }
      }
    end
    let(:builder) do
      Nav::Builder.new(view, options) do |n|
        n.action 'Home', '/home'
      end
    end

    before do
      allow(builder).to receive(:current_page?) { false }
    end

    it 'renders <ul> with :id attribute' do
      ul = Nokogiri::HTML(builder.build).xpath('//ul').first
      expect(ul['id']).to eq('my-nav')
    end

    it 'renders <ul> with data attribute' do
      ul = Nokogiri::HTML(builder.build).xpath('//ul').first
      expect(ul['data-stuff']).to eq('awesome')
    end
  end
end
