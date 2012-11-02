task :default do
  puts "Run server/guard"
  run_task "server"
end

desc "Start everything"
task :watch do
  rm_rf './public/assets/js'
  rm_rf './public/assets/css'
  # system "rsync -ar --exclude '.git' --exclude '.DS_Store' --exclude '*.coffee' app/scripts/ public/assets/js/"
  run_command 'powder restart', 'guard'
end

desc "Start server"
task :server do
  rm_rf './public/assets/js'
  rm_rf './public/assets/css'
  # system "rsync -ar --exclude '.git' --exclude '.DS_Store' --exclude '*.coffee' app/scripts/ public/assets/js/"
  run_command 'puma', 'guard'
end

task :w => :watch
task :s => :server

# run command(s) and capture SIGINT
def run_command(*cmds)
  pids = cmds.map { |cmd| Process.spawn("bundle exec #{cmd}") }

  trap('INT') {
    pids.each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    puts '==> Stopped!'
    exit 0
  }

  pids.each { |pid| Process.wait(pid) }
end

# rerun rake task
def run_task(*tasks)
  tasks.each do |task|
    Rake::Task[task].reenable
    Rake::Task[task].invoke
  end
end
