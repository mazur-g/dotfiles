--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.
In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)



--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
--
--
--

local wrap = function(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
end



vim.wo.relativenumber = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  -- camel case, snake case etc
  'tpope/vim-abolish',

  'backdround/improved-ft.nvim',


  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'f-person/git-blame.nvim',
  'rhysd/conflict-marker.vim',

  -- -- visual selections
  -- 'iago-lito/vim-visualMarks',

  -- toggle maximizing

  -- lazygit as floating window

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  -- nicer prompt display

  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  {
    'aserebryakov/vim-todo-lists',
    opts = {},
    config = function()
    end
  },

  -- better quickfix list
  --

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      vim.api.nvim_create_user_command("FindAndReplace", function(opts)
        vim.api.nvim_command(string.format("cdo s/%s/%s/g", opts.fargs[1], opts.fargs[2]))
        vim.api.nvim_command("cfdo update")
      end, { nargs = "*" })


      vim.api.nvim_set_keymap(
        "n",
        "<leader>rp",
        ":FindAndReplace ",
        { noremap = true })
    end
  },
  {
    'junegunn/fzf',
    config = function()
      vim.fn['fzf#install']()
    end
  },

  {
    'mrcjkb/haskell-tools.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- SQL integration
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
    },
  },
  'kristijanhusak/vim-dadbod-completion',

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {}
    end
  },

  -- json support
  {
    'theprimeagen/jvim.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' }

  },

  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    config = function()
      require("output_panel").setup()
    end
  },

  -- kind of submodes handling
  {
    'anuvyklack/hydra.nvim',
    config = function()
      local Hydra = require('hydra')
      local jvim = require('jvim')

      Hydra({
        name = 'Side scroll',
        mode = 'n',
        body = 'z',
        heads = {
          { 'h', '5zh', { desc = '←' } },
          { 'l', '5zl', { desc = '→' } },
          { 'H', 'zH', { desc = 'half screen ←' } },
          { 'L', 'zL', { desc = 'half screen →' } },
        }
      })
      Hydra({
        name = 'Json browser',
        mode = 'n',
        body = '<leader>jm',
        heads = {
          { 'h', jvim.to_parent, { desc = '←' } },
          { 'l', jvim.descend, { desc = '→' } },
          { 'j', jvim.next_sibling, { desc = 'next sibling' } },
          { 'k', jvim.prev_sibling, { desc = 'prev sibling' } },
        }
      })
    end
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  'tpope/vim-abolish',



  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },


  -- debugging
  { 'mfussenegger/nvim-dap' },

  {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup()
      vim.keymap.set('n', '<leader>dv', require('dapui').toggle, { desc = '[D]ebug [V]iew' })
    end
  },

  {
    'macguirerintoul/night_owl_light.vim',
    priority = 993,
    config = function()
      vim.cmd.colorscheme 'night_owl_light'
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 2,
    config = function()
      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },


  {
    'DAddYE/soda.vim',
    priority = 994,
    config = function()
      vim.cmd.colorscheme 'soda'
    end,
  },

  {
    'sainnhe/gruvbox-material',
    priority = 883,
    config = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  {
    'catppuccin/nvim',
    priority = 10,
    config = function()
      vim.cmd.colorscheme 'catppuccin-latte'
    end,
  },



  {
    'sainnhe/sonokai',
    priority = 997,
    config = function()
      vim.cmd.colorscheme 'sonokai'
    end,
  },


  {
    'mstcl/dmg',
    priority = 3,
    config = function()
      vim.cmd.colorscheme 'dmg'
    end,
  },



  {
    'gmr458/vscode_modern_theme.nvim',
    priority = 1,

    config = function()
      require("vscode_modern").setup({
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      })
      vim.cmd.colorscheme 'vscode_modern'
    end,
  },


  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'sonokai',
        component_separators = '|',
        section_separators = '',

      },
      sections = {

        lualine_a = { 'mode' },
        lualine_b = {},
        -- lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },

    },
  },

  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help indent_blankline.txt`
  --   main = 'ibl',
  --   config = function()
  --     require('ibl').setup()
  --   end,
  -- },
  --

  -- command palette

  {
    "LinArcX/telescope-command-palette.nvim",
    config = function()
      vim.keymap.set("n", "<leader>cp", ":Telescope command_palette<cr>", { desc = '[C]ommand [P]alette' })
    end,
  },

  -- running tests support

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "jfpedroza/neotest-elixir"
    },

    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
        }
      })
      vim.keymap.set('n', '<leader>trn', require('neotest').run.run, { desc = '[T]est [R] [N]earest' })
      vim.keymap.set('n', '<leader>trl', require('neotest').run.run_last, { desc = '[T]est [R]un [L]ast' })
      vim.keymap.set('n', '<leader>to', require('neotest').output_panel.toggle, { desc = '[T]est [O]utput toggle' })
      vim.keymap.set('n', '<leader>ts', require('neotest').summary.toggle, { desc = '[T]est [S]summary toggle' })
      vim.keymap.set('n', '<leader>tw', wrap(require('neotest').watch.toggle, vim.fn.expand('%')),
        { desc = '[T]est [W]atch toggle' })
    end
  },

  -- "gc" to comment visual regions/lines
  --  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = 'master', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Grep with file picker
  {
    "kelly-lin/telescope-ag",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },


  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true



local dap = require('dap')
dap.adapters.mix_task = {
  type = 'executable',
  command = '/Users/gracjanmazur/.local/share/nvim/mason/packages/elixir-ls/debug_adapter.sh', -- debugger.bat for windows
  args = {}
}


dap.configurations.elixir = {
  {
    type = "mix_task",
    name = "mix test",
    task = 'test',
    -- taskArgs = { "--trace" },
    taskArgs = { "${relativeFile}" },
    request = "launch",
    startApps = true, -- for Phoenix projects
    projectDir = "${workspaceFolder}",
    debugAutoInterpretAllModules = false,
    debugInterpretModulesPatterns = { ".*Test" },
    requireFiles = {
      "test/**/test_helper.exs",
      "test/**/batch_ingested_test.exs"
    }
  },
}


-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<C-l>', '<C-w>l', { desc = "window switch - right" })
map('n', '<C-h>', '<C-w>h', { desc = "window switch - left" })
map('n', '<C-j>', '<C-w>j', { desc = "window switch - down" })
map('n', '<C-k>', '<C-w>k', { desc = "window switch - up" })

map('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true })
map('n', '<leader>tf', ':NvimTreeFindFile<CR>', { silent = true })
map('n', '<leader>z', ':tabnew %<CR>', { silent = true })
map('n', '<leader>yp', ':let @+ = expand("%:.")<CR>', { silent = true })
map('n', '<leader>o', ':OutputPanel<CR>', { silent = true })
map('n', '<leader>df', ':Gvdiffsplit!<CR>', { desc = '3-way diff on git file', silent = true })
map('n', '<leader>db', ':DBUIToggle<CR>', { desc = 'Toggle DB UI', silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Format on save ]]
local format_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  group = format_group
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-s>'] = require('telescope.actions').send_selected_to_qflist,
      },
      n = {
        ['<C-s>'] = require('telescope.actions').send_selected_to_qflist,
      },
    },
  },

  extensions = {
    command_palette = {
      { "vim",
        { "jumps", ":lua require('telescope.builtin').jumplist()" },
      },
      { "themes",
        { "kanagawa-dragon",  ":lua require('kanagawa').load('dragon')" },
        { "gruvbox-material", ":lua vim.cmd.colorscheme('gruvbox-material')" },
        { "vscode-modern",    ":lua vim.cmd.colorscheme('vscode_modern')" },
        { "sonokai",          ":lua vim.cmd.colorscheme('sonokai')" },
      },

      { "test",
        { "run marked", ":lua require('neotest').summary.run_marked()" },
        { "watch file", ":lua require('neotest').watch.toggle(vim.fn.expand('%'))" }
      },
    }
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ag')
pcall(require('telescope').load_extension('command_palette'))


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })


vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sa', wrap(require('telescope.builtin').find_files, { no_ignore = true, hidden = true }),
  { desc = '[S]earch [A]ll files (even ignored in .gitignore)' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'elixir', 'json', 'heex', 'eex' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']['] = '@class.outer',
        [']c'] = '@conditional.outer',
        [']a'] = '@parameter.outer'
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
        ['[c'] = '@conditional.outer',
        ['[a'] = '@parameter.outer'
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = {
      spacing = 4,
    },
    -- Use a function to dynamically turn signs off
    -- and on, using buffer local variables
    signs = function(_, bufnr)
      return vim.b[bufnr].show_signs == true
    end,
    -- Disable a feature
    update_in_insert = false,
  }
)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  --  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },

  elixirls = {
    autoBuild = false,
    dialyzerEnabled = false,
    fetchDeps = false
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- capabilities.textDocument.completion.dynamicRegistration = true
-- capabilities.workspace = { didChangeConfiguration = { dynamicRegistration = true } }

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- vim.lsp.set_log_level("debug")

-- nvim-cmp setup
local cmp = require('cmp')

local luasnip = require('luasnip')

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nerd_fonts = 1

vim.cmd([[

autocmd BufWritePre * :%s/\s\+$//e

:set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
:set list


" if exists('+termguicolors')
"   let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"   set termguicolors
" endif

function! s:GotoFirstFloat() abort
  for w in range(1, winnr('$'))
    let c = nvim_win_get_config(win_getid(w))
    if c.focusable && !empty(c.relative)
      execute w . 'wincmd w'
    endif
  endfor
endfunction
noremap <c-w><space> :<c-u>call <sid>GotoFirstFloat()<cr>


" DB integration

let g:db_ui_execute_on_save = 0
"let g:db_ui_auto_execute_table_helpers = 1
"let g:db_ui_use_nerd_fonts = 1



function! s:populate_query() abort
  let rows = db_ui#query(printf(
    \ "select column_name, data_type from information_schema.columns where table_name='%s' and table_schema='%s'",
    \ b:dbui_table_name,
    \ b:dbui_schema_name
    \ ))
  let lines = ['INSERT INTO '.b:dbui_table_name.' (']
  for [column, datatype] in rows
    call add(lines, column)
  endfor
  call add(lines, ') VALUES (')
  for [column, datatype] in rows
    call add(lines, printf('%s <%s>', column, datatype))
  endfor
  call add(lines, ')')
  call setline(1, lines)
endfunction

autocmd FileType sql nnoremap <buffer><leader>i :call <sid>populate_query()

autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

" Source is automatically added, you just need to include it in the chain complete list
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1

]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
