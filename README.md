# Media Syncer
Here I will explain my basic setup for the asset pipeline for Sinatra. It took some fiddling and I'm
hoping to find a better way, but for now it will suffice.

## Serving Slim and Coffeescript
Sinatra comes with templating support for Slim by default. All you have to do is add the Slim gem to
your Gemfile, create a slim template and serve it.

Adding Slim to the Gemfile. Here I use version 3.0 of Slim
```
gem 'slim', '~> 3.0'
```
Then run `bundle install`

I've splitted up my frontend and backend stuff into separate directories. In `app/backend/views/`
I've created a basic layout.slim file and index.slim file. Note that Sinatra does not have the
index.html.slim filename that Rails has, but just the .slim extention.

In layout.slim I've added the following:
```
doctype html
html
  head
    title MediaSyncer

    meta charset="utf-8"
    == css :application
    == js :application

  body
    h1 MediaSyncer
    == yield
```

And in index.slim:
```
img src="images/kitten.jpg"

p.lead This is my first Sinatra app with a Slim template
```

It contains a link to an image, because I wanted to test out serving images with Sinatra.

In your application.rb add the following code within the `class MediaSyncerApplication < Sinatra::Base` class.

```
  set :root, File.dirname(__FILE__) + "/app"
  set :views, settings.root + '/backend/views'

  get '/' do
    slim :index
  end
```

And add the following require at the top of the file
```
require 'slim'
```

It will serve the index.slim when you go the root url. So now when you start up the server and go to
localhost:4567 it should show the main page, only without the image and any styling.

I've set the :root directory of Sinatra to /app and the :views to the root with /backend/views, because that is where my files will be.
Sinatra will now know where to find them.

## Setting up the asset pipeline
To serve assets with Sinatra I've followed the recipe on the Sinatra website [here](http://recipes.sinatrarb.com/p/asset_management/sinatra_assetpack).
I'm using the [sinatra-assetpack](https://github.com/rstacruz/sinatra-assetpack) gem. We will also
be using Sass, so we need that gem as well. So lets it to our Gemfile.

```
gem 'sinatra-assetpack' , '~> 0.3'
gem 'sass', '~> 3.4'
```

And of course run `bundle install`

Now we need to tell Sinatra to register the asset pack and show it what stylesheets and images to
serve.

At the top of the application.rb file we add the following require statements.
```
require 'sinatra/assetpack'
require 'sass'
```

We add the following lines to our application.rb file between the `set :views` and `get '/' do`
```
  register Sinatra::AssetPack
  assets {
    serve '/stylesheets',       from: 'frontend/stylesheets'
    serve '/images',            from: 'frontend/images'

    css :application, [
      'stylesheets/application.css'
    ]

    css_compression :sass
  }
```
Because we don't use the default directory structure we need to mention where the stylesheets and
images can be found. I've created a directory `images` and `stylesheets` within the `frontend`
directory. The `css :application` will serve all the files in the array when it is called in the
layout, for now it's only serving the application.css file and it will automatically compile the
scss files with the same name by adding the `css_compression :sass`.

In `app/frontend/stylesheets/application.scss` we add the following code
```
body {
  background-color: lightgrey;
}
```
This not our definitive style, but just to prove that it works. And don't forget to add a kitten.jpg
image in `app/frontend/images/`.

If we not restart the webserver the image and style should show up on the index page.

## Adding Twitter Bootstrap
Because we have already set up the asset pipeline it's very easy to add Twitter Bootstrap support.
All you have to do is download the latest [Twitter Bootstrap](http://getbootstrap.com/) and place
the CSS files in `stylesheets/vendor/` and adding the files in application.rb

```
  css :application, [
    # External dependencies
    'stylesheets/vendor/bootstrap.css',
    'stylesheets/vendor/bootstrap-responsive.css',

    'stylesheets/application.css'
  ]
```

## Adding Coffeescript support
We haven't added Javascript support to serve with the assetpack yet, so we are going to add that
together with coffee-script. In order to do that we need to add the following gems to our Gemfile.

```
gem 'coffee-script', '~> 2.3'
gem 'uglifier', '~> 2.7'
```

In the application.rb file we require coffee-script at the top of the file.
```
require 'coffee-script'
```

To let assetpack know we want to serve Javascript from the `app/frontend/javascripts` directory we
need to add the following code to the application.rb file within the assets block, just like we did
with the CSS.

```
    serve '/javascripts',       from: 'frontend/javascripts'

    js :application, [
      'javascripts/application.js'
    ]
    js_compression  :uglify
```

Also create a application.coffee file in `app/frontend/javascripts` and for now we add a console.log
message to make sure it works.

```
console.log "Now serving coffee (script)"
```

After restarting the webserver we can go to localhost:4567 and open the console of our browser. It
should now show the message.

## Adding Backbone and others
We will add Backbone and Marionette the same way we added Twitter Bootstrap by downloading the
newest versions and placing them in the `app/frontend/javascripts/vendor/` folder and add them to
the `js :application` array in application.rb. Becauswe we already prepared serving Javascript in
the previous step this is all we need to do.

```
    js :application, [
      # External dependencies
      'javascripts/vendor/json2.js',
      'javascripts/vendor/jquery.js',
      'javascripts/vendor/underscore.js',
      'javascripts/vendor/backbone.js',
      'javascripts/vendor/backbone.babysitter.js',
      'javascripts/vendor/backbone.wreqr.js',
      'javascripts/vendor/backbone.marionette.js',
      'javascripts/vendor/bootstrap.js',

      'javascripts/application.js'
    ]
```

## Summary
It's relatively easy to serve images, CSS and Javascript with Sinatra. Now we are ready to start
creating our Backbone/Marionette application with a Sinatra REST api backend.
