local config_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
config_path = config_path:sub(1, #config_path - 1)
local config_name = config_path:match(".*[\\/](.*)$")

_G.config_path = config_path
_G.config_name = config_name

require(config_name .. ".bootstrap")
require(config_name .. ".settings")
package.path = package.path .. ";" .. _G.config_path .. "/?.lua;"
require(config_name .. ".lazy")(config_name, config_name .. ".plugins")
