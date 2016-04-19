require 'yaml'
require 'uri'
require 'erb'

def load_config(path)
  YAML.load(ERB.new(File.read(path), nil, "%").result)
end

redirects = load_config("./redirects.yml")
augmented_redirects = redirects.dup

redirects.each do |from, to|
  uri = URI(from)
  unless uri.path =~ /\/$/
    uri.path += "/index.html"
    alternate_from = uri.to_s
    augmented_redirects[alternate_from] = to
  end
end

config = load_config("./raw_s3_website.yml")
config['redirects'] = augmented_redirects

config = config.merge(load_config("./credentials.yml"))

File.open('./s3_website.yml', 'w') do |f|
  f.write YAML.dump(config)
end
