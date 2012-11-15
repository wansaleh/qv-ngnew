# Asset route definitions

class App < Sinatra::Base

  # compile haml partials, for angular templating
  get "/partials/:file" do
    path = request.path_info.gsub(/\.html$/, "") + ".haml"
    path = root_path("app", path)

    if File.exists?(path)
      content_type :html
      haml File.read(path), :layout => false

    # not found
    else
      404
    end
  end

end
