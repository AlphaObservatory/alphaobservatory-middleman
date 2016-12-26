# require_relative './lib/i18n'

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

ignore '/templates/*'

set :url_root, 'https://www.alphaobservatory.org'

configure :development do
  activate :livereload
end


set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true,
              footnotes: true, with_toc_data: true

activate :i18n, langs: [:en, :it, :es], :mount_at_root => false
activate :pagination
activate :dato,
  token: '6336ab2933f064d4649df76ed97a92b3',
  base_url: 'https://www.alphaobservatory.org'

activate :external_pipeline,
  name: :webpack,
  command: build? ?
    "./node_modules/webpack/bin/webpack.js --bail -p --display-error-details" :
    "./node_modules/webpack/bin/webpack.js --watch -d --progress --color --display-error-details",
  source: ".tmp/dist",
  latency: 1

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true,
               footnotes: true, with_toc_data: true

configure :build do
  activate :minify_html
  activate :minify_javascript
  activate :search_engine_sitemap,
    default_priority: 0.5,
    default_change_frequency: 'weekly'

  # We need this for Netlify, but the after_build stuff may be deprecated when upgrading to Middleman v4
  after_build do |builder|\
    # Netlify requires a _redirects file for its redirects, but Middleman ignores files which
    # start with an underscore! So we have to hack it a little.
    src = File.join(config[:source],"_redirects")
    dst = File.join(config[:build_dir],"_redirects")
    builder.thor.source_paths << File.dirname(__FILE__)
    builder.thor.copy_file(src,dst)
  end
end

module Helpers
  def path(id, params = {}, lang = I18n.locale)
   if id == "home"
     locale_url_prefix(lang)
   else
     chunk = I18n.with_locale(lang) { I18n.t("paths.#{id}", params.merge(default: id)) }
     locale_url_prefix(lang) + chunk
   end
  end
  def locale_url_prefix(lang = I18n.locale)
   "/#{lang}/"
  end
  def other_lang(lang = I18n.locale)
   lang == :en ? "it" : "en"
  end

  # Returns a hash of localized paths for a given page
  def localized_paths_for(page)
   return {} if page.path == "index.html"
   localized_paths = {}
   (langs).each do |locale|
     # Loop over all pages to find the ones using the same templates (proxied_to) for each language
     sitemap.resources.each do |resource|
       next if !resource.is_a?(Middleman::Sitemap::ProxyResource)
       if resource.target_resource == page.target_resource
         if resource.metadata[:options][:locale] == locale
           localized_paths[locale] = resource.url
           break
         end
       end
     end
   end

   localized_paths
  end

end

helpers Helpers

dato.news_its.values.each do |article|
  proxy "/it/news/#{article.slug}/index.html", "/templates/news_template.html", :locals=>{ article: article, lang: :it}, ignore: true, locale: :it
end
dato.news_ens.values.each do |article|
  proxy "/en/news/#{article.slug}/index.html", "/templates/news_template.html", :locals=> { article: article}, ignore: true, locale: :it
end

activate :directory_indexes
