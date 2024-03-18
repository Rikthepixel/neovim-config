# RikThePixel's neovim config

## Included features

### Package manager

Using Lazy.nvim most plugins are lazy loaded by default, so no insane startup times.

### Theme

- Catppuccin
    - Applies theme to: Harpoon, Telescope, Treesitter
- Lualine

### Navigation

- Harpoon 2.0
    - Toggle file marks with `<leader>fm` in normal-mode
    - View quick-list using `<leader>fq` in normal-mode
    - Go to next or previous marks with `<leader>fn` and `<leader>fp`
    - Marked files are displayed on the status-line
    - Mark files in telescope using  `<C-f>` in insert-mode or `<leader>fm` in normal-mode
- Telescope

### LSP and highlighting

- Syntax highlighting with Treesitter
- LSP with lspconfig-mason
    - Call the lspconfig setup function and it will automatically install required lsps
    - JavaScript and variants allow for automatic import refactoring when moving files

### Formatting

- Formatter.nvim
    - Helpers to only run certain formatters if conditions are met (Like `.prettierrc` exists)

### Git

- Conflict viewer
- Git signs