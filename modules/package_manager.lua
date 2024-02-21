return function(config_name, plugins)
  local lazy_path = vim.fn.stdpath("data") .. "/" .. config_name .. "/lazy/lazy.nvim"
  local lazy_packages = vim.fn.stdpath("data") .. "/" .. config_name .. "/lazy"

  if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazy_path,
    })
  end

  vim.opt.rtp:prepend(lazy_path)
  require("lazy").setup(plugins, {
    root = lazy_packages,
    defaults = {
      lazy = true,
    },
    lockfile = vim.fn.stdpath("config") .. "/lua/" .. config_name .. "/lazy-lock.json",
  })
end