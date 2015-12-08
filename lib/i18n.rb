module FixSubpaths
  def parse_locale_extension(path)
    path_bits = path.split('.')
    return nil if path_bits.size < 3

    lang = path_bits.delete_at(-2).to_sym
    return nil unless langs.include?(lang)

    path = path_bits.join('.')
    page_id = path_bits[0..-2].join('.')

    [lang, path, page_id]
  end
end

Middleman::CoreExtensions::Internationalization.send :prepend, FixSubpaths


