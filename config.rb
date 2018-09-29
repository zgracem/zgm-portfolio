config[:site] = {}

config[:site][:title] = "My Site"
config[:site][:url]   = "https://example.org"
config[:site][:description] = %(This is my website.)

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
    config.livereload_css_target = "#{config[:css_dir]}/site.css"
  end
end

# configure :build do
#   config[:http_prefix] = "/www"
# end

activate :directory_indexes
config[:relative_links] = true
config[:trailing_slash] = false

# Redcarpet Markdown

markdown_options = {
  smartypants: true,
  # do not parse emphasis inside of words, e.g. foo_bar_baz
  no_intra_emphasis: true,
  # do not parse usual (indented) markdown code blocks
  disable_indented_code_blocks: true,
  # parse links even when they are not enclosed in <> characters
  autolink: false,
  # parse strikethrough, PHP-Markdown style, e.g. this is ~~good~~ bad
  strikethrough: true,
  # HTML blocks do not require empty lines around them
  lax_spacing: true,
  # a space is always required between the hash at the beginning of a header
  # (e.g. "#this is my header" would not be valid)
  space_after_headers: true
}

config[:markdown_engine] = :redcarpet
config[:markdown] = markdown_options

# Slim

Slim::Embedded.options[:markdown]   = markdown_options
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

activate :autoprefixer do |config|
  config.browsers = ["last 3 versions", "Explorer >= 9", "> 5%"]
end
