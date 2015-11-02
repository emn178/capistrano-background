module SSHKit
  class Command
    alias_method :orig_in_background, :in_background

    def in_background(&_block)
      return yield unless options[:run_in_background]
      pid_file = options[:pid_file]
      if pid_file.nil?
        orig_in_background(&_block)
      else
        env_str = environment_string
        if env_str.nil?
          sprintf("( nohup %s > /dev/null & \\echo $! > #{pid_file})", yield)
        else
          sprintf(" && ( #{env_str} nohup %s > /dev/null & \\echo $! > #{pid_file})", yield)
        end
      end
    end
  end
end
