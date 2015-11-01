module SSHKit
  class Command
    alias_method :orig_in_background, :in_background

    def in_background(&_block)
      return yield unless options[:run_in_background]
      pid_file = options[:pid_file]
      if pid_file.nil?
        orig_in_background(&_block)
      else
        sprintf("( nohup %s > /dev/null & \\echo $! > #{pid_file})", yield)
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :background_processes, []
  end
end

namespace :background do
  processes = []

  def get_pid_file(options)
    options[:pid_file] || File.join(shared_path, 'tmp', 'pids', "#{options[:id]}.pid")
  end

  def pid_process_exists?(pid_file)
    file_exists?(pid_file) and test(*("kill -0 $( cat #{pid_file} )").split(' '))
  end

  def file_exists?(file)
    test(*("[ -f #{file} ]").split(' '))
  end

  def start_process(pid_file, options)
    stage = fetch :stage
    args = options[:execute]
    args << {:pid_file => pid_file}
    with(:RAILS_ENV => "#{stage} && ") do
      background *args
    end
  end

  def stop_process(pid_file)
    if file_exists? pid_file
      background "kill -TERM `cat #{pid_file}`" 
      execute "rm #{pid_file}"
    end
  end

  task :add_default_hooks do
    after 'deploy:starting', 'background:quiet'
    after 'deploy:updated', 'background:stop'
    after 'deploy:reverted', 'background:stop'
    after 'deploy:published', 'background:start'
  end

  desc 'Stop background processes'
  task :stop do
    background_processes = fetch :background_processes
    background_processes.each do |options|
      role = options[:role] || :app
      on roles role do
        within release_path do
          stop_process(get_pid_file(options))
        end
      end
    end
  end

  desc 'Start background processes'
  task :start do
    background_processes = fetch :background_processes
    background_processes.each do |options|
      role = options[:role] || :app
      on roles role do
        within release_path do
          pid_file = get_pid_file(options)
          start_process(pid_file, options) unless pid_process_exists?(pid_file)
        end
      end
    end
  end

  desc 'Restart background processes'
  task :restart do
    invoke 'background:stop'
    invoke 'background:start'
  end
end

def add_background_process(options)
  background_processes = fetch :background_processes
  background_processes << options
end
