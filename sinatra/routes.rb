# Sinatra route definitions

class App < Sinatra::Base

  get "/" do
    showIndex
  end

  get "/index/?:sort?" do
    showIndex
  end

  get "/sura/:id" do
    id = params[:id].to_i

    if valid?(id)
      showIndex
    else
      @error = "You've put in an invalid Sura ID. Quran has 114 suras.<br>
      Be sure to request a sura id between 1 and 114."
      500
    end
  end

private

  def showIndex
    @main = true
    @body_class = 'main'
    haml :index
  end

  def valid?(sura_id)
    sura_id.to_i.between?(1, 114)
  end

end
