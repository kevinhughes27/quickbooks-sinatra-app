require 'sinatra/base'
require 'rack-flash'
require 'omniauth-quickbooks'

module Sinatra
  module Quickbooks

    module Methods
      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end

      private

      def close_and_refresh_parent
        erb "<script>
               window.opener.location.reload();
               close();
             </script>", :layout => false
      end
    end

    def self.registered(app)
      app.helpers Quickbooks::Methods

      app.enable :sessions

      app.set :secret, ENV['SECRET']

      app.set :qbo_key, ENV['QBO_KEY']
      app.set :qbo_secret, ENV['QBO_SECRET']

      app.use Rack::Flash, :sweep => true

      app.use Rack::Session::Cookie, :key => '#{base_url}.session',
                                     :path => '/',
                                     :secret => app.settings.secret,
                                     :expire_after => 60*30 # half an hour in seconds

      app.use OmniAuth::Builder do
        provider :quickbooks, app.settings.qbo_key, app.settings.qbo_secret
      end

      app.get '/auth/quickbooks/callback' do
        session[:qbo_token] = request.env['omniauth.auth']['credentials']['token']
        session[:qbo_secret] = request.env['omniauth.auth']['credentials']['secret']
        session[:realm_id] = params['realmId']

        flash[:notice] = 'Your QuickBooks account has been successfully linked'
        close_and_refresh_parent
      end

      app.get '/auth/failure' do
        flash[:error] = "Quickbooks authentication failed"
        close_and_refresh_parent
      end
    end

  end
end
