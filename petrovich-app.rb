# encoding: utf-8
require 'sinatra/base'
require 'sinatra/json'
require 'petrovich'

class PetrovichApp < Sinatra::Base
  helpers Sinatra::JSON

  # TODO: реализовать интерфейс
  get '/' do

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
        :firstname  => petrovich.firstname(params[:firstname], gcase),
        :middlename => petrovich.middlename(params[:middlename], gcase),
        :lastname   => petrovich.lastname(params[:lastname], gcase),
        :case       => gcase
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