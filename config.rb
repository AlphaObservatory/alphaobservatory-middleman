
require_relative './lib/i18n'

activate :i18n, langs: [:en, :it], :mount_at_root => false

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


# data.typologies.each do |t|
#   proxy "/#{t.slug}.#{I18n.locale}.html", "/results.#{I18n.locale}.html", :locals => { :typology => t }
# end
# ignore "/localizable/results.#{I18n.locale}.html"

langs.each do |l|
  data.typologies.each do |type_lang|
    type_lang[l.to_s].each do |t|
      page "/#{l}/#{t.slug}.html", :proxy => "/localizable/results.#{l}.html", :ignore => true, :locals => { :typology => t}
    end
  end
  ignore "/localizable/results.#{l}.html"

  data.typologies.each do |type_lang|
    type_lang[l.to_s].each do |t|
      page "/#{l}/#{t.slug}-offline.html", :proxy => "/localizable/results-offline.#{l}.html", :ignore => true, :locals => { :typology => t}
    end
  end
  ignore "/localizable/results-offline.#{l}.html"
end




activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 8']
  config.cascade  = false
  config.inline   = true
end


# Build-specific configuration
configure :build do  # For example, change the Compass output style for deployment
  activate :minify_css
  activate :directory_indexes
  activate :minify_javascript
end
