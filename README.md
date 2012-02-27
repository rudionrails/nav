Navigation made easy

## Installation
System wide

```console
gem install nav
```

In your Gemfile

```ruby
gem 'nav'
```

## Usage

Nav is writte for ActionView::Base and can be used in your rails views like so:

```erb
<%= nav do |n| %>
  <% n.action "Home", "/" %>
  <% n.action "Login", login_url %>
<% end %>
```

When rendered, this generates the following:

```html
<ul>
  <li class="first current first_current">
    <a href="/">Home</a>
  </li>
  <li class="last after_current last_after_current">
    <a href="/login">Login</a>
  </li>
</ul>
```

It will determine the current page you are on and add the `current` class to the <li> element. Also, 
the element before and after the current element have the classes `before_current` and `after_current` 
Additionally, Nav will mark the first and last <li> element of the list as `first` and `last`. Like so, 
you can apply styles accordingly.

### Adding attributes to the nav element

You can give any possible html option to nav, like id, classes, etc.

```erb
<%= nav :class => 'main' do |n| %>
  ...
<% end %>
```

Which results in

```html
<ul class='main'>
  ...
</ul>
```

### Adding attributes to an action

#### Disabling an action

You are able to add specific behaviour when defining an `action`. For instance, if you want to disable a specific 
element, you may pass `disabled` to it. It will add a disabled class to the `li` element.

```erb
<%= nav do |n| %>
  <% n.action "Disabled", "/", :disabled => true %>
<% end %>
```

#### Manually set the current action

In case want to define which of the elements is the current one. You can pass `current` as
option. This can be done in various ways.

##### Boolean

```erb
<%= nav do |n| %>
 <% n.action "My special current", "/", :current => true %>
<% end %>
```
##### Regular Expression

Pass a regular expression to the :current: argument. For instance, the following 
will mark any url as current that has "account", followed by a "/" and any type 
of numeric value, like "account/1" or "user/account/123". However, "account/my" will 
not match.

```erb
<%= nav do |n| %>
 <% n.action "My special current", "/", :current => /account\/\d+/ %>
<% end %>
```

##### Proc

Pass a Proc in order to determine the current on the fly. Make sure that it returns
`true` or `false`.

```erb
<%= nav do |n| %>
 <% n.action "My special current", "/", :current => Proc.new { !current_user.nil? } %>
<% end %>
```
## Custom actions

If you prefer to not use links for your navigation or simply want to customize your 
navigation, you may do so by padding a block to the `action`.

You can use any rails view helpers or just good old plain html. The following 
examples are equivalent:

```erb
<%= nav do |n| %>
  <% n.action :class => 'customized' do %>
    <span>Home</span>
  <% end %>
<% end %>
```


```erb
<%= nav do |n| %>
  <% n.action :class => 'customized' do %>
    <%= content_tag :span, 'Home' %>
  <% end %>
<% end %>
```

... and will result in:

```html
<ul>
  <li class="last">
    <span>Home</span>
  </li>
</ul>
```



Copyright (c) 2011-2012 Rudolf Schmidt, released under the MIT license

