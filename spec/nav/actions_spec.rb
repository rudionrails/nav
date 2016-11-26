RSpec.describe 'Nav::Builder#action' do
  let(:builder) { Nav::Builder.new(view) }
  let(:document) { Nokogiri::HTML(builder.build) }

  before do
    allow(view).to receive(:current_page?) { false }
  end

  it 'renders' do
    builder.action('Home', '/home')

    a = document.xpath('//ul/li/a').first
    expect(a).to be_present
    expect(a['href']).to eq('/home')
    expect(a.content).to eq('Home')
  end

  context ':if attribute' do
    it 'renders when true' do
      builder.action('Home', '/home', if: true)

      a = document.xpath('//ul/li/a').first
      expect(a).to be_present
    end

    it 'does not render when false' do
      builder.action('Home', '/home', if: false)

      li = document.xpath('//ul/li').first
      expect(li).to be_nil
    end
  end

  context ':unless attribute' do
    it 'renders when false' do
      builder.action('Home', '/home', unless: false)

      a = document.xpath('//ul/li/a').first
      expect(a).to be_present
    end

    it 'does not render when true' do
      builder.action('Home', '/home', unless: true)

      li = document.xpath('//ul/li').first
      expect(li).to be_nil
    end
  end

  context 'multiple actions' do
    it 'renders' do
      builder.action('Home', '/home')
      builder.action('About', '/about')

      expect(
        document.xpath('//a[@href="/home"]').first
      ).to be_present

      expect(
        document.xpath('//a[@href="/about"]').first
      ).to be_present
    end

    it 'renders when :if condition is satisfied' do
      builder.action('Home', '/home', if: false)
      builder.action('About', '/about', if: true)

      expect(
        document.xpath('//a[@href="/home"]').first
      ).to be_nil

      expect(
        document.xpath('//a[@href="/about"]').first
      ).to be_present
    end

    it 'renders when :unless condition is satisfied' do
      builder.action('Home', '/home', unless: true)
      builder.action('About', '/about', unless: false)

      expect(
        document.xpath('//a[@href="/home"]').first
      ).to be_nil

      expect(
        document.xpath('//a[@href="/about"]').first
      ).to be_present
    end

    it 'does not reder anything when no actions present' do
      builder.action('Home', '/home', if: false)
      builder.action('About', '/about', unless: true)

      expect(
        document.xpath('//ul').first
      ).to be_nil
    end
  end
end
