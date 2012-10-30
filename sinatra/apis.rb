# API routes

class App < Sinatra::Base

  get "/api/ayas.json" do
    sura_id =  params[:sura_id].to_i
    limit   = !params[:limit].blank? ? params[:limit].to_i   : 10
    offset  = !params[:offset].blank? ? params[:offset].to_i : 0

    limit  = [limit, 0].max
    offset = [offset, 0].max

    if !valid?(sura_id)
      hash = {:error => "Invalid sura"}
    else
      hash = ayas(sura_id, limit, offset)
    end

    json hash
  end

  get "/api/suras.json" do
    sura_id = !params[:sura_id].blank? ? params[:sura_id].to_i : false

    if sura_id
      if !valid?(sura_id)
        hash = {:error => "Invalid sura"}
      else
        hash = suras(sura_id)
      end
    else
      hash = suras
    end

    json hash
  end

private

  def ayas(sura_id, limit, offset)
    DB[:ayas]
      .select(
        :ayas__id,
        :ayas__sura_id,
        :ayas__aya,
        :ayas__text___text,
        :translations__text___translation)
      .join(:translations, :ayas__id => :translations__aya_id)
      .where(:ayas__sura_id => sura_id, :translations__language_id => 1)
      .limit(limit, offset)
      .all
  end

  def suras(sura_id = :all)
    if sura_id == :all
      DB[:suras].all
    else
      DB[:suras].where(:id => sura_id).first
    end
  end

  def json(hash)
    json = JSON.pretty_generate hash
    json = "#{params[:callback]}(#{json})" unless params[:callback].blank?

    content_type :json, :charset => "utf-8"
    json
  end

end
