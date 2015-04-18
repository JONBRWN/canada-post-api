require 'httparty'
require 'nokogiri'
require 'active_support/core_ext/hash'
require 'canada_post/helpers'
require 'canada_post/rate'

module CanadaPost
  module Request
    class Base
      include Helpers
      include HTTParty

      # CanadaPost API Test URL
      TEST_URL = "https://ct.soa-gw.canadapost.ca"

      # CanadaPost API Production URL
      PRODUCTION_URL = "https://soa-gw.canadapost.ca"

      # List of available Option Codes
      # SO - Signature
      # COV - Coverage  (requires qualifier)
      # COD - COD (requires qualifier)
      # PA18 - Proof of Age Required - 18
      # PA19 - Proof of Age Required - 19
      # HFP - Card for pickup
      # DNS - Do not safe drop
      # LAD - Leave at door - do not card
      OPTION_CODES = ["SO", "COV", "COD", "PA18", "PA19", "HFP", "DNS", "LAD"]

      #List of available Service Codes
      # DOM.RP - Regular Parcel
      # DOM.EP - Expedited Parcel
      # DOM.XP - Xpresspost
      # DOM.XP.CERT - Xpresspost Certified
      # DOM.PC - Priority
      # DOM.DT - Delivered Tonight
      # DOM.LIB - Library Books
      # USA.EP - Expedited Parcel USA
      # USA.PW.ENV - Priority Worldwide Envelope USA
      # USA.PW.PAK - Priority Worldwide pak USA
      # USA.PW.Parcel - Priority Worldwide Parcel USA
      # USA.SP.AIR - Small Packet USA Air
      # USA.TP - Tracked Package - USA
      # USA.TP.LVM - Tracked Package - USA (LVM) (large volume mailers)
      # USA.XP - Xpresspost USA
      # INT.XP - Xpresspost international
      # INT.IP.AIR - International Parcel Air
      # INT.IP.SURF - International Parcel Surface
      # INT.PW.ENV - Priority Worldwide Envelope Int'l
      # INT.PW.PAK - Priority Worldwide pak Int'l
      # INT.PW.PARCEL - Priority Worldwide Parcel Int'l
      # INT.SP.AIR - Small Packet International Air
      # INT.SP.SURF - Small Packet International Surface
      # INT.TP - Tracked Package - International
      SERVICE_CODES = ["DOM.RP", "DOM.EP", "DOM.XP", "DOM.XP.CERT", "DOM.PC.CERT", "DOM.PC", "DOM.DT", "DOM.LIB", "USA.EP", "USA.PW.ENV", "USA.PW.PAK", "USA.PW.PARCEL", "USA.SP.AIR", "USA.TP", "USA.TP.LVM", "USA.XP", "INT.XP", "INT.IP.AIR", "INT.IP.SURF", "INT.PW.ENV", "INT.PW.PAK", "INT.PW.PARCEL", "INT.SP.AIR", "INT.SP.SURF", "INT.TP"]

      def initialize(credentials, options={})
        requires!(options, :shipper, :recipient, :package)
        @credentials = credentials
        @shipper, @recipient, @package, @service_type = options[:shipper], options[:recipient], options[:package], options[:service_type]
        @authorization = { username: @credentials.username, password: @credentials.password }
        @customer_number = @credentials.customer_number
      end

      def process_request
        raise NotImplementedError, "Override #process_request in subclass"
      end

      def api_url
        @credentials.mode == "production" ? PRODUCTION_URL : TEST_URL
      end

      def build_xml
        raise NotImplementedError, "Override #build_xml in subclass"
      end

      def add_package(xml)
        xml.send(:"parcel-characteristics") {
          xml.weight @package[:weight][:value]
          if @package[:dimensions]
            xml.dimensions {
              xml.height @package[:dimensions][:height].round(1)
              xml.width @package[:dimensions][:width].round(1)
              xml.length @package[:dimensions][:length].round(1)
            }
          end
        }
      end

      # Parse response, convert keys to underscore symbols
      def parse_response(response)
        response = Hash.from_xml( response.parsed_response.gsub("\n", "") ) if response.parsed_response.is_a? String
        response = sanitize_response_keys(response)
      end

      # Recursively sanitizes the response object by cleaning up any hash keys.
      def sanitize_response_keys(response)
        if response.is_a?(Hash)
          response.inject({}) { |result, (key, value)| result[underscorize(key).to_sym] = sanitize_response_keys(value); result }
        elsif response.is_a?(Array)
          response.collect { |result| sanitize_response_keys(result) }
        else
          response
        end
      end

    end
  end
end