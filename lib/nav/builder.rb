module Nav #:nodoc:
  class Builder #:nodoc:
    def initialize(template, options = {})
      @template = template
      @options = options
      @actions = []

      yield(self) if block_given?
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
        @actions << [@template.capture(&block), name || {}, {}]
      else
        return unless html_options.fetch(:if, true)
        return if html_options.fetch(:unless, false)

        wrapper_options = {
          current: html_options.delete(:current),
          disabled: html_options.delete(:disabled)
        }

        @actions << [
          link_to(name, url_for_options, html_options),
          wrapper_options,
          url_for_options
        ]
      end
    end

    def build
      return if @actions.empty?
      content_tag(:ul, actions.join.html_safe, @options).html_safe
    end

    private

    def actions
      @actions.map do |content, options, url_for_options|
        action_wrapper(content, options, url_for_options)
      end
    end

    # rubocop:disable
    def action_wrapper(content, options = {}, url_for_options = {})
      present = [content, options, url_for_options] # the one we're dealing with
      present_index  = @actions.index(present)

      before_present = @actions.at(present_index - 1) if present_index > 0
      after_present  = @actions.at(present_index + 1) if present_index < @actions.size

      classes = [*options[:class]]
      classes << 'first' if present == @actions.first
      classes << 'after_first' if present_index == 1
      classes << 'before_last' if present == @actions[-2]
      classes << 'last' if present == @actions.last
      classes << 'current' if current?(*present)
      classes << 'disabled' if options[:disabled]
      classes << 'before_current' if after_present && current?(*after_present)
      classes << 'after_current'  if before_present && current?(*before_present)

      content_tag(:li, content.html_safe, class: classes.join(' '))
    end

    def current?(content, options = {}, url_for_options = {})
      return false if !!options[:disabled]

      current = options[:current] || url_for_options

      case current
      when TrueClass, FalseClass then current
      when Regexp then request_uri.match(current)
      when Proc then current.call
      when Array then current.map { |c| current?(content, options.merge(current: c), url_for_options) }.any?
      else current_page?(current)
      end
    end

    def current_page?(options)
      @template.current_page?(options)
    end

    def content_tag(*args)
      @template.content_tag(*args).html_safe
    end

    def link_to(*args)
      @template.link_to(*args).html_safe
    end

    def request_uri
      request.respond_to?(:request_uri) ? request.request_uri : request.url
    end

    def request
      @template.request
    end
  end
end
