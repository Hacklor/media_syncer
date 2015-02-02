require 'sinatra/base'
require 'sinatra/assetpack'
require 'coffee-script'
require 'sass'
require 'slim'

class MediaSyncerApplication < Sinatra::Base
  set :root, File.dirname(__FILE__) + "/app"
  set :views, settings.root + '/backend/views'

  register Sinatra::AssetPack
  assets {
    serve '/javascripts',       from: 'frontend/javascripts'
    serve '/stylesheets',       from: 'frontend/stylesheets'
    serve '/images',            from: 'frontend/images'

    css :application, [
      # External dependencies
      'stylesheets/vendor/bootstrap.css',
      'stylesheets/vendor/bootstrap-responsive.css',

      'stylesheets/application.css'
    ]

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

    js_compression  :uglify
    css_compression :sass
  }

  get '/' do
    slim :index
  end
end
