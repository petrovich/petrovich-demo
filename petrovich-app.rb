# encoding: utf-8
require 'bundler/setup'
Bundler.require(:default)

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sprockets-helpers'

require 'petrovich'

class PetrovichApp < Sinatra::Base
  set :assets_precompile,     []
  set :assets_css_compressor, :sass
  set :assets_js_compressor,  :uglifier

  register Sinatra::AssetPipeline
  configure do
    EvilFront.install_all(sprockets)
    EvilBlocks.install_to_slim!
  end

  helpers  Sinatra::JSON

  get '/' do
    @input = { gender:     :male,
               lastname:   'Иванов',
               firstname:  'Иван',
               middlename: 'Иванович' }
    @example = example(@input)
    @cases   = {
      genitive:      ['род.', 'Родительный падеж'],
      dative:        ['дат.', 'Дательный падеж'],
      accusative:    ['вин.', 'Винительный падеж'],
      instrumental:  ['тво.', 'Творительный падеж'],
      prepositional: ['пре.', 'Предложный падеж']
    }

    slim :index
  end

  # Склонять по всем падежам
  #
  # Параметры:
  #
  # * firstname  - Имя
  # * middlename - Отчество
  # * lastname   - Фамилия
  # * gender     - Пол
  #
  # ФИО должны указываться в именительном падаже
  post '/decline.json' do
    json example(params)
  end

  def example(options)
    petrovich = Petrovich.new(options[:gender])
    create_hash(Petrovich::CASES) do |gcase|
      create_hash([:lastname, :firstname, :middlename]) do |part|
        petrovich.send(part, options[part], gcase) if options[part]
      end
    end
  end

  def create_hash(keys, &block)
    hash = { }
    keys.each { |i| hash[i] = yield(i) }
    hash
  end
end
