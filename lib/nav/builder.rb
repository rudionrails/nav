module Nav
  class Builder
    def initialize( template, options = {} )
      @template, @options = template, options
      @actions = []
      
      yield self if block_given?
    end

    def action( name, options = {}, html_options = {} )
      wrapper_options = {
        :current => html_options.delete(:current),
        :disabled => html_options.delete(:disabled),
        :force_current => html_options.delete(:force_current),
        :url => options,
        :prepend => html_options.delete(:prepend),
        :append => html_options.delete(:append)
      }
      
      @actions << [link_to(name, options, html_options), wrapper_options, options]
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
      classes << "first" if @actions.first == present
      classes << "last"  if @actions.last == present
      classes << "current"  if current?( *present )
      classes << "disabled" if options.delete(:disabled)
      classes << "before_current" if after_present && current?( *after_present )
      classes << "after_current"  if before_present && current?( *before_present )
      classes << classes.join("_") if classes.any?

      contents = options[:prepend].to_s + contents + options[:append].to_s

      content_tag :li, contents.html_safe, :class => classes.join(" ")
    end

    def current?( contents, options = {}, url_for_options = {} )
      current = options[:current]
      
      is_current = case current
        when TrueClass then true
        when Regexp then request_uri.match(current).nil? ? false : true
        when Proc then current.call
        else false
      end

      return true if is_current && !options[:disabled] && options[:force_current]
      return true if is_current || !url_for_options.is_a?(Symbol) && @template.current_page?(url_for_options) && url_for_options != {} && !options[:disabled]

      false
    end

    def content_tag( *args )
      @template.content_tag( *args ).html_safe
    end

    def link_to( *args )
      @template.link_to( *args ).html_safe
    end

    def request_uri
      @request_uri or @request_uri = request.respond_to?(:request_uri) ? request.request_uri : request.url
    end

    def request
      @template.request
    end
  end
end

