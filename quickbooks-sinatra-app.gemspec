Gem::Specification.new do |s|
  s.name = 'quickbooks-sinatra-app'
  s.version = '0.0.2'

  s.summary     = "A classy quickbooks app"
  s.description = "A Sinatra extension for building Quickbooks Online Apps."

  s.authors = ["Kevin Hughes"]
  s.email = "kevin.hughes@shopify.com"
  s.homepage = "https://github.com/pickle27/quickbooks-sinatra-app/"
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'omniauth-oauth'
  s.add_runtime_dependency 'multi_json' # required by omniauth-oauth - https://github.com/intridea/omniauth-oauth/pull/4
  s.add_runtime_dependency 'omniauth-quickbooks' # ensure your version has this: https://github.com/davidlumley/omniauth-quickbooks/pull/2
end
