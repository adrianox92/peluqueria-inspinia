source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.20.0'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'font-awesome-rails', '4.7.0.1'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.4'

gem 'nokogiri', '1.13.9'

gem 'simple_form'

#https://github.com/mileszs/wicked_pdf
gem 'wicked_pdf'
#gem 'wkhtmltopdf-binary'

gem 'newrelic_rpm'
gem 'wkhtmltopdf-heroku'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem install rdoc -v '6.0.4'gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :production do
  gem 'puma'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
