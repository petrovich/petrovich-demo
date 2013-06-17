# encoding: utf-8
require 'bundler/setup'
Bundler.require(:default)

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/asset_pipeline'

require 'petrovich'

class PetrovichApp < Sinatra::Base
  set :assets_precompile,     []
  set :assets_css_compressor, :sass
  set :assets_js_compressor,  :uglifier

  register Sinatra::AssetPipeline
  helpers  Sinatra::JSON

  configure do
    AutoprefixerRails.install(sprockets)
    RailsSassImages.install(sprockets)
    EvilFront.install(sprockets)
  end

  # TODO: реализовать интерфейс
  get '/' do
    slim :index
  end

  # Склонять по всем падежам
  #
  # Параметры:
  #
  # * firstname  - Имя
  # * middlename - Отчество
  # * lastname   - Фамилия
  #
  # ФИО должны указываться в именительном падаже
  post '/decline.json' do
    petrovich = Petrovich.new
    result    = []

    Petrovich::CASES.each do |gcase|
      result << {
        firstname:  petrovich.firstname(params[:firstname], gcase),
        middlename: petrovich.middlename(params[:middlename], gcase),
        lastname:   petrovich.lastname(params[:lastname], gcase),
        case:       gcase
      }
    end

    json result
  end

  # Список всех падежей
  # NOTICE: вдруг пригодится - если нет, удалить
  get '/cases.json' do
    json Petrovich::CASES
  end
end
