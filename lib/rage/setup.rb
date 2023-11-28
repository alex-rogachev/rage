Iodine.patch_rack

require_relative "#{Rage.root}/config/environments/#{Rage.env}"
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir("#{Rage.root}/app")
loader.setup # ready


require_relative "#{Rage.root}/config/routes"
