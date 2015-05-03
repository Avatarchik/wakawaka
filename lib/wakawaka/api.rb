require 'sinatra/base'
require 'json'
require 'base64'
require 'wakawaka/heartbeat'
require 'wakawaka/wakatime_proxy'

module Wakawaka
  class API < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    post '/wakatime_heartbeat' do

      raw_body = request.body.read
      heartbeat_attributes = {
        user_agent: env['HTTP_USER_AGENT'],
        time_zone: env['HTTP_TIMEZONE'],
        api_secret_key: extract_api_secret_key(env),
        body: JSON.parse(raw_body)
      }
      Heartbeat.create(heartbeat_attributes)

      WakatimeProxy.send(raw_body, env, logger)

      status 200
      'Wakawaka: ok'
    end

    private

    def extract_api_secret_key(env)
      header = env['HTTP_AUTHORIZATION']
      Base64.decode64(header.gsub('Basic ', ''))
    end
  end
end
