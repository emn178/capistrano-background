namespace :load do
  task :defaults do
    set :background_default_hooks, true
    set :background_processes, []
  end
end

namespace :deploy do
  before :starting, :check_background_hooks do
    invoke 'background:add_default_hooks' if fetch(:background_default_hooks)
  end
  after :publishing, :restart_background do
    invoke 'background:restart' if fetch(:background_default_hooks)
  end
end

namespace :background do
  processes = []

  def get_pid_file(options)
    options[:pid_file] || File.join(shared_path, 'tmp', 'pids', "#{options[:id]}.pid")
  end

  def pid_process_exists?(pid_file)
    file_exists?(pid_file) && test(*%{kill -0 `cat #{pid_file}`})
  end

  def file_exists?(file)
    test(*%{[ -f #{file} ]})
  end

  def quiet_process(pid_file)
    if file_exists? pid_file
      background "kill -TERM `cat #{pid_file}`"
    end
  end

  def start_process(pid_file, options)
    stage = fetch :stage
    args = options[:execute]
    args << {:pid_file => pid_file}
    with(:RAILS_ENV => stage) do
      background *args
    end
  end

  def stop_process(pid_file, timeout)
    if file_exists? pid_file
      if pid_process_exists? pid_file
        rake "terminate `cat #{pid_file}` -- -t #{timeout}" 
      end
      execute "rm #{pid_file}"
    end
  end

  task :add_default_hooks do
    after 'deploy:starting', 'background:quiet'
    after 'deploy:updated', 'background:stop'
    after 'deploy:reverted', 'background:stop'
    after 'deploy:published', 'background:start'
  end

  desc 'Quiet background processes'
  task :quiet do
    background_processes = fetch :background_processes
    background_processes.each do |options|
      role = options[:role] || :app
      on roles role do
        within release_path do
          quiet_process(get_pid_file(options))
        end
      end
    end
  end

  desc 'Stop background processes'
  task :stop do
    background_processes = fetch :background_processes
    background_processes.each do |options|
      role = options[:role] || :app
      on roles role do
        within release_path do
          stop_process(get_pid_file(options), options[:timeout] || 60)
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
