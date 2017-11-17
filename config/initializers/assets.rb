Rails.application.config.assets.precompile += %w( gestion.js )
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/