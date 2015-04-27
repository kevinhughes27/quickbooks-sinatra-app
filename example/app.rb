require 'sinatra/quickbooks-sinatra-app'
require 'sinatra/pretty-flash'

require 'oauth'
require 'json'

require 'pry'
require 'byebug'

class SinatraApp < Sinatra::Base
  register Sinatra::Quickbooks
  register Sinatra::PrettyFlash

  enable :inline_templates

  qbo_company_id = 1313500450
  qbo_url = "https://sandbox-quickbooks.api.intuit.com/v3/company/#{qbo_company_id}"

  get '/' do
    erb :index
  end

  get '/test_get_item' do
    response = QboRestClient :get, qbo_url+'/item/3'

    content_type :json
    response.body
  end

  get '/test_create_item' do
    body = {
      'Name' => "Beans",
      'Description' => "Beans Beans Beans",
      'Active' => true,
      'FullyQualifiedName' => "Beans",
      'Taxable' => true,
      'UnitPrice' => 99,
      'Type' => "Service",
      'IncomeAccountRef' => {
        'value' => "48",
        'name' => "Landscaping Services:Job Materials:Fountains and Garden Lighting"
      },
      'PurchaseCost' => 90,
      'TrackQtyOnHand' => false,
      'domain' => "QBO",
    }

    response = QboRestClient :post, qbo_url+'/item', body: body.to_json

    content_type :json
    response.body
  end

  get '/test_get_journalentry' do
    response = QboRestClient :get, qbo_url+'/journalentry/8'

    content_type :json
    response.body
  end

  private

  def QboRestClient(method, path, body: {}, headers: {})
    consumer = OAuth::Consumer.new(settings.qbo_key, settings.qbo_secret)
    token = OAuth::AccessToken.new(consumer, session[:qbo_token], session[:qbo_secret])

    unless headers.has_key?('Content-Type')
      headers['Content-Type'] = 'application/json'
    end
    unless headers.has_key?('Accept')
      headers['Accept'] = 'application/json'
    end

    response = case method
    when :get
      token.get(path, headers)
    when :post
      token.post(path, body, headers)
    else
      raise
    end

    response
  end
end

__END__

@@ layout
<html>
  <head>
    <%= pretty_flash_css %>
  </head>
  <body>
    <%= erb pretty_flash_html %>
    <%= yield %>
  </body>
  <%= pretty_flash_js %>
</html>

@@ intuit
<script type='text/javascript' src='https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js'></script>
<script>
  intuit.ipp.anywhere.setup({menuProxy: '/path/to/blue-dot', grantUrl: '<%= base_url %>/auth/quickbooks'});
</script>
<ipp:connectToIntuit></ipp:connectToIntuit>

@@ index
<%= erb :intuit %>
</br>
<a href='/test_get_item'>test_get_item</a> </br>
<a href='/test_create_item'>test_create_item</a> </br>
<a href='/test_get_journalentry'>test_get_journalentry</a> </br>
