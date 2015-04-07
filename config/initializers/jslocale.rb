translations = {}
[:en, :de, :ru].each do |lang|
  File.open Rails.root.join('config', 'locales', lang.to_s + '.yml') do |f1|
    y = YAML.load f1
    translations[lang.to_s] = y[lang.to_s]['js']
  end
end 
f = File.open Rails.root.join('app', 'assets', 'javascripts', 'locale.js'), 'w'
f.puts "var I18n = JSON.parse('" + translations.to_json + "');\n"
f.close
