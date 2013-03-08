# ReadOnlyFilter::Rails

Read only support for Rails ActiveController, allows for protection of controller actions from write by preventing access to the `:create :update :destroy` actions.

By default read only filter redirects back with a flash error message. However redirects to 403, 404 or 500 status code error pages are available through custom options.

## Installation

Add this line to your application's Gemfile:

```ruby
	gem 'read_only_filter', '~> 1.0.0'
```
    
	
And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install read_only_filter
    
	
## Using read only filter

Just follow these simple steps to enable read only protection of your `:create :update :destroy` actions in all controllers in your rails project.

1. ####Add support for read only filter to your project:

	In order to add support for read only protected controllers to your project you will
need to create an initializer file in your projects config initializers directory.

	```ruby
	# config/initializers/read_only_filter.rb
	require 'read_only_filter'
	```

	one liner:
	
	```shell
	$ echo 'require \'read_only_filter\'' config/initializers/read_only_filter.rb
	```
		
2. ####Enable read only filter in your project:

	Enable should be triggered early in your controllers before_filters, such as
	your `:signed_in_user` or other authentication filter.
	
	```ruby
	@enable_read_only = true
	```
	
	It can also be enabled from a user flag to mark specific users as read_only.
	
	```ruby
	@enable_read_only = current_user.read_only
	```
	
	   
3. ####Customize the way read only filter works:

	Add additional methods to protect besides the defaults. Optionally exclude a default `:update` action. The following examples can be added to the top of any rails controller.

	```ruby
	read_only only: [:index, :show], except: [:update]
    ```
    Use custom status codes and redirect messages.
    
    ```ruby
    read_only render_error: [:create,:udpate], status_code: 404
    ```
	


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
 

## Copyright

Copyright (c) 2013 @geothird. See LICENSE.txt for
further details.