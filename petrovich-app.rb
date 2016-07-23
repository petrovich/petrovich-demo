# encoding: utf-8
require 'bundler/setup'
Bundler.require(:default)

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sprockets'
require 'sprockets-helpers'

require 'petrovich'

class PetrovichApp < Sinatra::Base
  register Sinatra::AssetPipeline

  set :assets_precompile,     %w(application.css application.js)
  set :assets_prefix,         'assets'
  set :assets_css_compressor, :sass
  set :assets_js_compressor,  :uglifier
  set :assets_digest,         false

  set :environment, :production

  helpers do
    include Sprockets::Helpers
  end

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
  # * lastname   - Фамилия
  # * firstname  - Имя
  # * middlename - Отчество
  # * gender     - Пол
  #
  # ФИО должны указываться в именительном падаже
  post '/decline.json' do
    json example(params)
  end

  def example(options)
    petrovich = Petrovich(
      lastname: options[:lastname],
      firstname: options[:firstname],
      middlename: options[:middlename],
      gender: options[:gender]
    )

    create_hash(Petrovich::CASES) do |rcase|
      create_hash([:lastname, :firstname, :middlename]) do |part|
        petrovich.to(rcase).public_send(part) if options[part]
      end
    end
  end

  def create_hash(keys, &block)
    hash = { }
    keys.each { |i| hash[i] = yield(i) }
    hash
  end
end
