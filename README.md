# RubygemDigger

RubygemDigger is a prototype research tool that explores the Rubygem repos.

RubyGems.org contains the packages of most of the Ruby gems open source
software ever pubished and all their versions. It's a great resource to
do research.

## Dependencies

You'll need the RubyGems respository to do the exploring. Use tool like
https://github.com/rubygems/rubygems-mirror to mirror the entire
RubyGems.

So far, the tool depends on 3 open source static code analyzers.

    $ pip install lizard
    $ gem install rubocop
    $ gem install reek

Check the Gemfile if you care about the specific versions. Of course,
extending to more analyzers should be easy.


## Installation

You can have the source and do

    $ bundle
    $ rake

That will start the test and the data process.

To use it in your Ruby code, add this line to your application's Gemfile:

```ruby
gem 'rubygem_digger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubygem_digger

## Usage

The dispatcher folder is a separate Ruby on Rails web server by itself.
Go t that folder, and do:

    $ bundle
    $ bundle exec rails s

This will start to server, which provide distributed computing for
getting the static analysis result.

Then on another computer:

    $ bundle
    $ bundle exec rails c
    > Client.new("http://<server address>:3000").new.run

This will make that computer a client to do the computing job.

The output will be the JSON files inside the notebook folder. Use
Jupyter notebook to open the .ipynb files in the notebook folder and the
machine learning work will be carried on there.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/terryyin/rubygem_digger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

