require 'action_view'

module ActionViewDeclaration #:nodoc:
  extend RSpec::SharedContext

  let(:view) { ActionView::Base.new }
end

RSpec.configure do |config|
  config.include ActionViewDeclaration
end
