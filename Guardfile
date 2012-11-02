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

# guard 'copy',
#   from: 'app/scripts',
#   to: 'public/assets/js',
#   all_on_start: true do

#   watch(%r{^(.+\.(js|html))$})
# end

# watch the app/styles dir
guard 'sass',
  output: 'public/assets/css',
  compass: true,
  hide_success: true,
  all_on_start: true do

  watch %r{^app/styles/(.+\.s[ac]ss)$}
end

# # watch haml (for angular partials)
# guard 'haml',
#   :input  => 'app',
#   :output => 'public',
#   :all_on_start => true do

#   watch(%r{^app/partials/(.+\.haml)})
# end

# watch changes for livereloading
guard 'livereload' do
  watch(%r{.+\.(rb|html|haml)})
  watch(%r{^public/assets/(js|css)/.+$})
end
