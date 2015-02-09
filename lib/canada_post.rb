require "canada_post/version"
require "canada_post/request/base"
require "canada_post/request/rate"
require "canada_post/shipment"
require "canada_post/rate"
require "canada_post/credentials"

module CanadaPost
  #Exceptions: CandaPost::RateError
  class RateError < StandardError; end
end
