QuickBooks-Sinatra-App
======================

Sinatra extension for building QuickBooks Online Apps

Installing
----------
```
gem install quickbooks-sinatra-app
```

Put your QuickBooks Online API credentials in a `.env` file:

```
QBO_KEY=...
QBO_SECRET=...
```

Example Usage
-------------

```ruby
require 'sinatra/quickbooks-sinatra-app'

class SinatraApp < Sinatra::Base
  register Sinatra::Quickbooks

  get '/' do
    erb "<script type='text/javascript' src='https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js'></script>
         <script>
           intuit.ipp.anywhere.setup({menuProxy: '/path/to/blue-dot', grantUrl: '#{base_url}/auth/quickbooks'});
         </script>
         <ipp:connectToIntuit></ipp:connectToIntuit>"
  end
end
```

For an example including making a few api calls see the `/example`
