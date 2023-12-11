Iodine.patch_rack

require_relative "#{Rage.root}/config/environments/#{Rage.env}"
require 'zeitwerk'
require 'filewatcher'

autoload_path = "#{Rage.root}/app/"

loader = Zeitwerk::Loader.new
loader.push_dir(autoload_path)
loader.enable_reloading
loader.setup
file_watcher = Filewatcher.new(autoload_path )
Thread.new(file_watcher) { |fw| fw.watch { |_| loader.reload } }


require_relative "#{Rage.root}/config/routes"
