
# require_relative './lib/i18n'

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

langs.each do |l|
  data.typologies.each do |type_lang|
    type_lang[l.to_s].each do |t|
      proxy "/#{l}/#{t.slug}.html", "/results.html", :ignore => true, :locals => { :typology => t}, locale: l, lang: l
    end
  end

  data.typologies.each do |type_lang|
    type_lang[l.to_s].each do |t|
      proxy "/#{l}/#{t.slug}-offline.html", "/results-offline.html", :ignore => true, :locals => { :typology => t}, locale: l, lang: l
    end
  end
end

# DATO
##################################

activate :dato,
  domain: 'admin.alphaobservatory.org',
  token: "6336ab2933f064d4649df76ed97a92b3",
  base_url: 'www.alphaobservatory.org'
set :url_root, 'www.alphaobservatory.org/'


dato.news_its.values.each do |article|
  proxy "/it/news/#{article.slug}.html", "/news_template.html", locals: { article: article, lang: :it} do
    ::I18n.locale = :it
    @lang         = :it
  end
end
dato.news_ens.values.each do |article|
  proxy "/en/news/#{article.slug}.html", "/news_template.html", locals: { article: article}  do
    ::I18n.locale = :en
    @lang         = :en
  end
end
ignore "/news_template.html.slim"



# ACTIVATES

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
