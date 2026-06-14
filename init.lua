-- =========================
-- BASIC SETTINGS
-- =========================

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.clipboard = "unnamedplus"

-- Go-specific indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- =========================
-- LAZY BOOTSTRAP
-- =========================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- =========================
  -- FILE EXPLORER (nvim-tree)
  -- =========================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
      vim.keymap.set("n", "<leader>ef", ":NvimTreeFocus<CR>")
      vim.keymap.set("n", "<leader>er", ":NvimTreeFindFile<CR>")
    end,
  },

  -- =========================
  -- TELESCOPE (SEARCH)
  -- =========================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",

    config = function()
      print("AUTOPAIRS LOADED")
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },

  {
    "saadparwaiz1/cmp_luasnip",
  },

  -- =========================
  -- TREESITTER
  -- =========================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "go", "lua", "typescript", "javascript" },
      highlight = { enable = true },
    },
  },
  -- =========================
  -- MASON (TOOLS INSTALLER)
  -- =========================
  {
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "ts_ls",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = false,
      formatters_by_ft = {
        html = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        go = { "gofmt" },
        ruby = { "standardrb" },
      },
    },
  },
  -- =========================
  -- LSP (NEOVIM 0.11+)
  -- =========================
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Enable LSP servers (NEW API)
      vim.lsp.enable("gopls")
      vim.lsp.enable("ts_ls")

      -- Web
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("jsonls")

      -- YAML (blog.yml, config.yml etc.)
      vim.lsp.enable("yamlls")

      -- Markdown (docs, blog writing)
      vim.lsp.enable("marksman")

      -- Ruby (your CLI + Jekyll tooling)
      vim.lsp.enable("solargraph")

      -- Keymaps
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gr", vim.lsp.buf.references)
      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

      -- Diagnostics
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

      -- Format
      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true })
      end)
    end,
  },

  -- =========================
  -- AUTOCOMPLETE (CMP)
  -- =========================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  {
    "hrsh7th/cmp-nvim-lsp",
  },

  -- =========================
  -- TERMINAL
  -- =========================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({})

      vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
    end,
  },

  -- =========================
  -- DEBUGGING
  -- =========================
  {
    "mfussenegger/nvim-dap",
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "tokyonight",
          "catppuccin",
          "gruvbox",
          "rose-pine",
          "kanagawa",
        },
      })

      vim.keymap.set("n", "<leader>tx", ":Themery<CR>")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()

      -- MARK file (add to hot list)
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)

      -- OPEN harpoon menu
      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- QUICK SWITCH (1-4)
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
    end,
  }
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = { buffer = true }

    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
  end,
})

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end)

vim.keymap.set("n", "K", function()
  local line_diags = vim.diagnostic.get(0, {
    lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
  })

  if #line_diags > 0 then
    vim.diagnostic.open_float()
  else
    vim.lsp.buf.hover()
  end
end)


vim.filetype.add({
  extension = {
    tpl = "html",
  },
})
