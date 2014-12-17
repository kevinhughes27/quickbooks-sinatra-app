require 'sinatra/base'
require 'omniauth-quickbooks'

module Sinatra
  module Quickbooks

    module Methods
      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end
    end

    def self.registered(app)
      app.helpers Quickbooks::Methods

      app.enable :sessions

      app.set :secret, ENV['SECRET']

      app.set :qbo_key, ENV['QBO_KEY']
      app.set :qbo_secret, ENV['QBO_SECRET']

      app.use Rack::Session::Cookie, :key => '#{base_url}.session',
                                     :path => '/',
                                     :secret => app.settings.secret,
                                     :expire_after => 60*30 # half an hour in seconds

      app.use OmniAuth::Builder do
        provider :quickbooks, app.settings.qbo_key, app.settings.qbo_secret
      end

      app.get '/auth/quickbooks/callback' do
        token = request.env['omniauth.auth']['credentials']['token']
        session[:token] = token
        session[:realm_id] = params['realmId']

        erb 'Your QuickBooks account has been successfully linked', :layout => false
      end

      app.get '/auth/failure' do
        erb "<h1>Authentication Failed:</h1>
             <h3>message:<h3> <pre>#{params}</pre>", :layout => false
      end
    end

  end
end
