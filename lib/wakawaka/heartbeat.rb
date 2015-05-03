require 'mongoid'
require 'config/mongo'

module Wakawaka
  class Heartbeat
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'heartbeats'

    field :user_agent,      type: String
    field :time_zone,       type: String
    field :api_secret_key,  type: String
    field :body,            type: Hash
  end
end
