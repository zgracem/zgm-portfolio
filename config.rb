config[:site]         = {}
config[:site][:title] = "Z. (Amy) Grace Moreau"
config[:site][:url]   = "https://inescapable.org/~zgm"
config[:site][:description] = %(Websites. Widgets. Weird Art. Words.)

config[:source]       = "source"
config[:layouts_dir]  = "layouts"
config[:css_dir]      = "css"
config[:fonts_dir]    = "fonts"
config[:js_dir]       = "js"
config[:images_dir]   = "images"

config[:port]         = 7700

configure :server do
  config[:site][:url]     = "http://middleman.test:#{config[:port]}"
  activate :livereload do |config|
    config.no_swf = true
    config.livereload_css_pattern = /_.*\.(?:s[ca]ss|css)$/
    config.livereload_css_target = "#{config[:css_dir]}/main.css"
  end
end

configure :build do
  config[:http_prefix] = "/~zgm"
end

activate :directory_indexes
config[:relative_links] = true
config[:trailing_slash] = false

# Slim

Slim::Engine.options[:format]       = :html
Slim::Engine.options[:sort_attrs]   = false
Slim::Engine.options[:pretty]       = false

# SASS

require "sass"

config[:sass][:cache] = false
config[:sass][:line_numbers] = false
config[:sass][:style] = :compact

configure :development do
  config[:sass][:style] = :expanded
  config[:sass][:line_numbers] = true
end

# Autoprefixer

configure :production do
  activate :autoprefixer do |config|
    config.browsers = ["last 3 versions", "Explorer >= 9", "> 5%"]
  end
end
