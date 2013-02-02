module Nav
  class Builder
    def initialize( template, options = {} )
      @template, @options = template, options
      @actions = []

      yield self if block_given?
    end

    # @example A basic action
    #   action "Home", home_url
    #   action "Tome, home_url, :current => true
    #
    # @example Given a block
    #   action do
    #     content_tag :span, "A simple text""
    #   end
    #
    #   action :current => true do
    #     content_tag :span, "A simple text""
    #   end
    def action( name = nil, options = {}, html_options = {}, &block )
      @actions << if block
        [ @template.capture(&block), name || {}, {} ]
      else
        wrapper_options = {
          :current => html_options.delete(:current),
          :disabled => html_options.delete(:disabled),
        }

        [ link_to(name, options, html_options), wrapper_options, options ]
      end
    end

    def to_s
      content_tag( :ul, actions.html_safe, @options ).html_safe if actions?
    end


    private

    def actions
      @actions.collect { |a| action_wrapper(*a) }.join
    end

    def actions?
      @actions.any?
    end

    def action_wrapper( contents, options = {}, url_for_options = {} )
      present = [contents, options, url_for_options] # the one we're dealing with
      present_index  = @actions.index( present )

      before_present = @actions.at( present_index - 1 ) if present_index > 0
      after_present  = @actions.at( present_index + 1 ) if present_index < @actions.size

      classes = []
      classes << options[:class] if options.key?(:class)
      classes << "first" if present == @actions.first
      classes << "after_first" if present_index == 1
      classes << "before_last" if present == @actions[-2]
      classes << "last"  if present == @actions.last
      classes << "current"  if current?( *present )
      classes << "disabled" if options[:disabled]
      classes << "before_current" if after_present && current?( *after_present )
      classes << "after_current"  if before_present && current?( *before_present )

      content_tag :li, contents.html_safe, :class => classes.join(" ")
    end

    def current?( contents, options = {}, url_for_options = {} )
      return false if !!options[:disabled]
      return false unless current = options[:current]

      if current.is_a?(Array)
        current.map { |c| current?(contents, options.merge(current: c), url_for_options) }.any?
      else
        case current
          when TrueClass then true
          when Regexp then !request_uri.match(current).nil?
          when Proc then current.call
          else current_page?(url_for_options)
        end
      end
    end

    def current_page?( options )
      @template.current_page?( options )
    end

    def content_tag( *args )
      @template.content_tag( *args ).html_safe
    end

    def link_to( *args )
      @template.link_to( *args ).html_safe
    end

    def request_uri
      request.respond_to?(:request_uri) ? request.request_uri : request.url
    end

    def request
      @template.request
    end
  end
end

