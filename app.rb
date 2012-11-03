# encoding: utf-8
require "bundler"
Bundler.require

ROOT_DIR = File.expand_path(File.dirname(__FILE__))
Encoding.default_external = "utf-8" if defined?(::Encoding)

def root_path(*args)
  File.join(ROOT_DIR, *args)
end

# The Main Sinatra class
class App < Sinatra::Base

  # Sequel DB connection
  DB = Sequel.mysql2 "quran_sinatra", user: "root", password: "www", host: "localhost"

  # Settings

  set :root,  ROOT_DIR
  set :views, root_path("sinatra/views")

  # Plugins
  configure :development do
    use Rack::LiveReload
    register Sinatra::Reloader
  end

  # HAML options
  set :haml,
    :format       => :html5,
    :attr_wrapper => '"',
    :escape_attrs => false,
    :preserve     => ["textarea", "pre", "code"]

  # Compass and SASS options
  Compass.add_project_configuration root_path("config.rb")
  set :scss, Compass.sass_engine_options
  set :sass, Compass.sass_engine_options

  # Not found error
  error 404 do
    content_type :html
    @body_class = "error error-404"
    haml :error
  end

  # Internal server error
  error 500 do
    content_type :html
    @body_class = "error error-500"
    haml :error
  end

  # Helpers
  helpers do
    include Sinatra::ContentFor

    def hasClass(className)
      @body_class.split("\s+").include?(className)
    end
  end

end

# Require everything
Dir[root_path("{sinatra/ext,sinatra}/*.rb")].each do |file|
  require file
end
