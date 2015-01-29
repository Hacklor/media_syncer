# Media Syncer

## Setting up Sinatra
First I created an empty Github repository called 'media_syncer' with only a readme file and cloned
that empty repository.

I use RVM with Bundler so I created a .ruby-version and .ruby-gemset file. This will set your Ruby
version and
create a new gemset specifically for your project.

.ruby-version
```
ruby-2.2.0
```

.ruby-gemset
```
media-syncer
```

Next I created a Gemfile to specify which Ruby Gems and versions of that gem I want to use. Here's
an explanation of the version notations I use.

The '>= 2.1.0' is self-explanatory. It will always give you a version greater than or equal to
2.1.0. This
will also mean that each time a new version is available it will update. Even to a 3.0 version which
can cause nasty surprises when there is a major change. I want to prevent that, so I use the ~>
notation. '~> 2.1' is the same as '>= 2.1.0' and '< 3.0' combined. So it will never switch to a
major version change.

For now I will start with Sinatra and add more gems only when I need them.

.Gemfile
```
source 'https://rubygems.org'

gem 'sinatra, '~> 1.4'
```

Then run 'bundle install' inside your project directory.

Now I would like to check if Sinatra actually works by adding a simple route.

Create a file named app.rb and add the following lines.
```
require 'sinatra'

get '/' do
"Hello World!"
end
```

To start your server run the following command and then in a browser go to 'localhost:4567'
```
ruby app.rb
```

zOMG! We've just created a Hello World app!

To stop your server press CTRL+Z
