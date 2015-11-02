if defined? task
  require 'capistrano/background/command'
  load File.expand_path('../tasks/background.rake', __FILE__)
end
