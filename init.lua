-- -------------------- OPTIONS --------------------
vim.opt.guicursor = 'i:block'
vim.opt.belloff = 'all'
vim.opt.shortmess:append('I')
vim.cmd('syntax on')
vim.opt.swapfile = false
vim.opt.listchars = { tab = '··', trail = '·', leadmultispace = '·' }
vim.opt.list = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.signcolumn = 'yes'
vim.opt.smarttab = true
vim.opt.cursorline = true
vim.opt.numberwidth = 4
vim.opt.laststatus = 2
vim.opt.showmode = false

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')
if vim.fn.isdirectory(vim.opt.undodir:get()[1]) == 0 then
    vim.fn.mkdir(vim.opt.undodir:get()[1], 'p')
end

-- ---------------- STATUSLINE ----------------

local function current_mode()
    local mode_map = {
        n = 'NORMAL',
        i = 'INSERT',
        v = 'VISUAL',
        V = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        R = 'REPLACE',
        c = 'COMMAND',
    }
    return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
end

_G.current_mode = current_mode
vim.opt.statusline = ' %{luaeval("_G.current_mode()")} | %f%m%r%h%w%=%l,%c %p%% '

-- -------------------- PLUGINS --------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    -- Colorscheme
     {
         "zenbones-theme/zenbones.nvim",
         dependencies = "rktjmp/lush.nvim",
         lazy = false,
         priority = 1000,
         config = function()
              vim.g.zenbones_darken_comments = 45
              vim.cmd.colorscheme('zenbones')
          end
      },

--    {
--        "p00f/alabaster.nvim",
--        priority = 1000,
--        config = function()
--            vim.cmd.colorscheme('alabaster')
--        end,
--    },

    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = {{ "nvim-mini/mini.icons", opts = {} }},
        lazy = false,
    },

    -- ---------------- COMPLETION ----------------

    {
        'hrsh7th/nvim-cmp',
        priority = 100,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp', max_item_count = 5 },
                    { name = 'buffer',   max_item_count = 5 },
                    { name = 'path',     max_item_count = 5 },
                },
            })
        end,
    },

    -- ---------------- LSP ----------------

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.lsp.config('ts_ls', {
                cmd = { 'typescript-language-server', '--stdio' },
                filetypes = {
                    'javascript',
                    'javascriptreact',
                    'typescript',
                    'typescriptreact',
                },
                root_markers = {
                    'package.json',
                    'tsconfig.json',
                    'jsconfig.json',
                    '.git',
                },
                capabilities = capabilities,
            })

            vim.lsp.config('clangd', {
                cmd = { 'clangd' },
                filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
                root_markers = {
                    'compile_commands.json',
                    'compile_flags.txt',
                    '.git',
                },
                capabilities = capabilities,
            })

            vim.lsp.enable({ 'ts_ls', 'clangd' })
        end,
    },

    -- JSX
    { 'maxmellon/vim-jsx-pretty' },

    -- Auto pairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({})
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'c', 'cpp', 'lua', 'javascript', 'typescript',
                    'python', 'bash', 'json', 'html', 'css',
                },
                highlight = { enable = true },
                indent = { enable = false },
            })
        end,
    },

    -- Auto close HTML/JSX tags
    {
        'windwp/nvim-ts-autotag',
        ft = { 'html', 'javascriptreact', 'typescriptreact' },
        config = function()
            require('nvim-ts-autotag').setup()
        end,
    },
})

-- -------------------- COMMANDS --------------------

vim.api.nvim_create_user_command('Tab', function(opts)
    local n = tonumber(opts.args)
    if n then
        vim.opt.tabstop = n
        vim.opt.shiftwidth = n
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command('GitDiff', function()
    vim.cmd('new')
    vim.bo.buftype = 'nofile'
    vim.bo.swapfile = false
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist('git diff'))
    vim.bo.modified = false
end, {})

vim.api.nvim_set_hl(0, 'Whitespace', {
    fg = '#2e2e2e',  -- very close to background
})

-- -------------------- KEYMAPS --------------------

vim.keymap.set('n', '<S-l>', ':bn<CR>', { silent = true })
vim.keymap.set('n', '<S-h>', ':bp<CR>', { silent = true })

vim.keymap.set('n', '<C-d>', vim.diagnostic.open_float, {
    silent = true,
    desc = 'Show diagnostics',
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual", -- or "IncSearch" / custom group
      timeout = 100,      -- ms
    })
  end,
})

-- Move selected text up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.cmd("cabbrev Ex Oil")
-- -------------------- NEOVIDE SPECIFIC --------------------

if vim.g.neovide == true then
  vim.o.guifont = "ZedMono Nerd Font Mono:h20"
  vim.api.nvim_set_keymap("n", "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
end
