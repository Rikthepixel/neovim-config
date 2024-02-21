require("rikthepixel.modules.settings")

local plugins = {}
local modules = {
    require("rikthepixel.modules.theme")
}

for _, module in ipairs(modules) do
    if not module.plugins then goto continue end
    vim.list_extend(plugins, module.plugins)
    ::continue::
end

require("rikthepixel.modules.package_manager")("rikthepixel", plugins)