# Watch the app/js dir
guard 'coffeescript',
  output:       'public/assets/js',
  hide_success: true,
  all_on_start: true do

  watch(%r{^app/scripts/(.+\.coffee)$})
end

guard 'shell',
  :all_on_start => true do

  watch %r{^app/scripts/(.+\.(js|template))} do |m|
    # puts "File changed: #{m[0]}"
    system "rsync -ar --exclude '.git' --exclude '.DS_Store' --exclude '*.coffee' app/scripts/ public/assets/js/"
  end
end

# watch the app/styles dir
guard 'sass',
  output: 'public/assets/css',
  compass: true,
  hide_success: true,
  all_on_start: true do

  watch %r{^app/styles/(.+\.s[ac]ss)$}
end

# watch changes for livereloading
guard 'livereload' do
  watch(%r{.+\.(rb|html|haml)})
  watch(%r{^public/assets/(js|css)/.+$})
  # watch(%r{.+\.(rb|coffee|js|css|haml|erb|html)})
end

# guard 'livereload' do
#   watch(%r{.+\.(rb|coffee|js|scss|haml|erb|html)})
# end
