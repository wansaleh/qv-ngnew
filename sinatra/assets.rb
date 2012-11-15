# Asset route definitions

class App < Sinatra::Base

  # compile haml partials, for angular templating
  get "/partials/:file" do
    # path = request.path_info.gsub(/\.html$/, "") + ".haml"

    path = request.path_info
    ext = File.extname(path)[1..-1]

    path = root_path("app", path)

    if File.exists?(path)
      content_type :html

      if (ext == "haml")
        haml File.read(path), :layout => false
      elsif (ext == "slim")
        slim File.read(path), :layout => false
      end

    # not found
    else
      404
    end
  end

end
