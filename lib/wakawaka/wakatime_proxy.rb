require 'uri'
require 'active_support/all'
require 'httparty'

module Wakawaka
  class WakatimeProxy
    API_URL_PREFIX = 'https://wakatime.com/api/v1'
    API_HEARTBEAT_PATH = '/heartbeats'
    API_PORT = 443

    def self.send(body, env, logger = nil)
      url = "#{API_URL_PREFIX}#{API_HEARTBEAT_PATH}"

      headers = {
        'Authorization' => env['HTTP_AUTHORIZATION'],
        'Content-Type' => env['CONTENT_TYPE'],
        'User-Agent' => env['HTTP_USER_AGENT']
      }.reject {|k,v| v.nil?}

      response = HTTParty.post(url, {
        body: body,
        headers: headers
      })

      begin
        if response.code == 200 || response.code == 201
          logger.info "WakatimeProxy.send: success"
        else
          logger.warn "WakatimeProxy.send: failure (status code: #{response.code}, body: #{response.body})"
        end
      rescue => e
        # TODO fix this too large rescue
        logger.warn "WakatimeProxy.send: exception (#{e})"
      end
    end
  end
end

