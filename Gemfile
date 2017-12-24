source 'https://rubygems.org'

ruby '2.3.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Official Sass port of Bootstrap 2 and 3. http://getbootstrap.com/css/#sass
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
# The font-awesome font
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Forms made easy for Rails! It's tied to a simple DSL, with no opinion on markup. http://blog.plataformatec.com.br/tag/…
gem 'simple_form', '~> 3.5'
# https://github.com/mileszs/wicked_pdf
gem 'wicked_pdf'
# This gem provides a wkhtmltopdf binary and configures wisepdf, wicked_pdf, and pdfkit for ruby based applications.
gem 'wkhtmltopdf-heroku', '~> 2.12', '>= 2.12.4.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0', '>= 5.0.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# New Relic RPM Ruby Agent http://www.newrelic.com
gem 'newrelic_rpm', '~> 4.7', '>= 4.7.1.340'

# Rails asset pipeline wrapper for socket.io. https://github.com/jhchen/socket.io-rails
gem 'socket.io-rails', '~> 2.0', '>= 2.0.4'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.15', '>= 2.15.1'
  # RSpec for Rails-3+ http://relishapp.com/rspec/rspec-rails
  gem 'rspec-rails', '~> 3.6'
  # A Ruby gem to load environment variables from `.env`.
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # A Ruby static code analyzer, based on the community Ruby style guide. http://rubocop.readthedocs.io
  gem 'rubocop', '~> 0.52'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # AppServer ligero. https://github.com/macournoyer/thin
  gem 'thin', '~> 1.7', '>= 1.7.1'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
