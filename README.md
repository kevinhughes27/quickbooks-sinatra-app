Quickbooks-Sinatra-App
======================

Sinatra extension for building Quickbooks Online Apps

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

For an example including making a few api calls see this [repo](https://github.com/pickle27/quickbooks-sinatra-example)
