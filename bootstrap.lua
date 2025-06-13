table.unpack = table.unpack or unpack

-- Disable default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

vim.filetype.add({
	pattern = {
		[".env.*"] = "sh",
		[".*%.env"] = "sh",
	},
})

vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
vim.filetype.add({ extension = { mdx = "mdx" } })