
data.typologies.each do |t|
  proxy "/#{t.slug}.html", "/results.html", :locals => { :typology => t }
end
ignore "results.html"

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'
set :fonts_dir,    'fonts'
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true,
               footnotes: true, with_toc_data: true
activate :livereload
activate :syntax, line_numbers: false
activate :directory_indexes

# Build-specific configuration
configure :build do  # For example, change the Compass output style for deployment
  activate :minify_css
  activate :directory_indexes
  activate :minify_javascript
  activate :asset_hash
end
