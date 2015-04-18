require "omniauth/strategies/oauth"
require "multi_xml"

module OmniAuth
  module Strategies
    class Xero < OmniAuth::Strategies::OAuth

      args [:consumer_key, :consumer_secret]

      option :client_options, {
        :access_token_path  => "/oauth/AccessToken",
        :authorize_path     => "/oauth/Authorize",
        :request_token_path => "/oauth/RequestToken",
        :site               => "https://api.xero.com",
      }

      info do
        {
          :name => raw_info["Name"],
          :legal_name  => raw_info["LegalName"],
        }
      end

      uid { raw_info["UserID"] }

      extra do
        { "raw_info" => raw_info }
      end

      private

      def raw_info
        @raw_info ||= JSON.parse(access_token.get("/api.xro/2.0/Organisation", {'Accept'=>'application/json'}).body)["Organisation"]
      end

    end
  end
end
