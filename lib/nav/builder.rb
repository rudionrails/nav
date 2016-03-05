module Nav #:nodoc:
  class Builder #:nodoc:
    def initialize(template, options = {})
      @actions = []
      @template = template
      @options = options

      yield self if block_given?
    end

    # @example A basic action
    #   action "Home", home_url
    #   action "Home, home_url, :current => true
    #
    # @example Given a block
    #   action do
    #     content_tag :span, "A simple text""
    #   end
    #
    #   action :current => true do
    #     content_tag :span, "A simple text""
    #   end
    def action(name = nil, url_for_options = {}, html_options = {}, &block)
      if block_given?
        @actions << [
          @template.capture(&block),
          name || {},
          {}
        ]
      else
        @actions << [
          @template.link_to(name, url_for_options, html_options),
          {
            current: html_options.delete(:current),
            disabled: html_options.delete(:disabled)
          },
          url_for_options
        ]
      end
    end

    def build
      html = ''.html_safe
      @actions.each do |content, options, url_for_options|
        html << build_action(content, options, url_for_options)
      end

      content_tag(:ul, html, @options).html_safe
    end

    private

    def build_action(content, options = {}, url_for_options = {})
      current = [content, options, url_for_options] # the one we're dealing with
      index  = @actions.index(current)

      before_current = @actions.at(index - 1) if index > 0
      after_current  = @actions.at(index + 1) if index < @actions.size

      classes = ['nav-item', *options[:class]]
      classes << 'first' if current == @actions.first
      classes << 'after_first' if index == 1
      classes << 'before_last' if current == @actions[-2]
      classes << 'last' if current == @actions.last
      classes << 'current' if current?(*current)
      classes << 'disabled' if options[:disabled]
      classes << 'before_current' if after_current && current?(*after_current)
      classes << 'after_current'  if before_current && current?(*before_current)

      content_tag(:li, content.html_safe, class: classes.join(' '))
    end

    def current?(content, options = {}, url_for_options = {})
      return false if options[:disabled]
      current = options[:current] || url_for_options

      case current
      when TrueClass, FalseClass then current
      when Regexp then request_uri.match(current)
      when Proc then current.call
      when Array then current.map { |c| current?(content, options.merge(current: c), url_for_options) }.any?
      else @template.current_page?(current)
      end
    end

    def content_tag(*args)
      @template.content_tag(*args).html_safe
    end

    def request_uri
      request = @template.request

      request.respond_to?(:request_uri) ?
        request.request_uri :
        request.url
    end
  end
end
