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

  # # Asset manager
  # get "/assets/*/*.*" do |type, path, ext|
  #   expires Time.now, :public, :must_revalidate
  #   path = request.path_info
  #   path.chomp!(File.extname(path))

  #   # javascript/coffeesscript
  #   if type == "js"
  #     # set content type
  #     content_type :js

  #     path.sub!("/assets/js", "/app/scripts")

  #     file = {
  #       :coffee => root_path("#{path}.coffee"),
  #       :js     => root_path("#{path}.js")
  #     }


  #     # look for coffeescript files
  #     if File.exists?(file[:coffee])
  #       coffee File.read(file[:coffee])

  #     # next look for plain old js files
  #     elsif File.exists?(file[:js])
  #       send_file file[:js]

  #     # not found
  #     else
  #       404

  #     end

  #   # scss stylesheets
  #   elsif type == "css"
  #     # set content type
  #     content_type :css

  #     path.sub!("/assets/css", "/app/styles")

  #     file = {
  #       :scss => root_path("#{path}.scss"),
  #       :css  => root_path("#{path}.css")
  #     }

  #     # we support scss only
  #     # look for scss files
  #     if File.exists?(file[:scss])
  #       scss File.read(file[:scss])

  #     # next look plain old css files
  #     elsif File.exists?(file[:css])
  #       send_file file[:css]

  #     # not found
  #     else
  #       404

  #     end

  #   # not found
  #   else
  #     404
  #   end
  # end

end
