--[[
~/.config/nvim/init.lua
%userprofile%\AppData\Local\nvim\init.lua

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

go install github.com/go-delve/delve/cmd/dlv@latest
apt install -y xclip ripgrep fd-find unzip
unzip -q codelldb-x86_64-linux.vsix -d ~/lldb
]]

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 5
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- maps
vim.g.mapleader = ' '
vim.keymap.set({'n', 'x'}, 'c', '"_c') -- don't yank on 'c'
vim.keymap.set({'n', 'x'}, 'd', '"_d') -- don't yank on 'd'

vim.keymap.set({'n', 'x', 'i'}, '<C-s>', '<cmd>write<CR>')
vim.keymap.set({'n', 'x', 'i', 't'}, '<C-q>', '<cmd>quitall<CR>')
vim.keymap.set({'n', 'x'}, '<leader>q', '<cmd>quit<CR>')
vim.keymap.set({'n', 'x'}, '<leader>Q', '<cmd>tabclose<CR>')
vim.keymap.set('t', '<Esc>', '<cmd>quit<CR>') -- exit terminal
vim.keymap.set('t', '<C-n>', '<C-\\><C-n>') -- escape terminal

vim.keymap.set('n', '<C-d>', '<C-d>zz') -- center screen after move
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<leader>o', 'o<C-c>') -- empty line
vim.keymap.set('n', '<leader>O', 'O<C-c>')
vim.keymap.set('n', 'o', 'o<C-c>"_cc')
vim.keymap.set('n', 'O', 'O<C-c>"_cc')
vim.keymap.set('n', 'J', 'mzJ`z') -- keep cursor pos while J
vim.keymap.set('x', '<leader>y', [["+y]]) -- copy to system clipboard
vim.keymap.set('x', '<leader>Y', [["+Y]])
vim.keymap.set('v', 'p', '"_dp') -- paste without yanking
vim.keymap.set('v', 'P', '"_dP')
vim.keymap.set('v', '<', '<gv') -- keep selection while indenting
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- move selected up/down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('i', '<C-h>', '<C-o>b') -- move by word on hl
vim.keymap.set('i', '<C-l>', '<C-o>w')
vim.keymap.set({'n', 'x'}, '<C-h>', 'b')
vim.keymap.set({'n', 'x'}, '<C-l>', 'w')
vim.keymap.set({'n', 'x', 'i'}, '<A-Left>', '<C-o>') -- navigate buffers
vim.keymap.set({'n', 'x', 'i'}, '<A-Right>', '<C-i>')

--> lsp
vim.keymap.set('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>df', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

--> git
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gl', '<cmd>Git log<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gB', '<cmd>Git blame<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>ga', '<cmd>Git show<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', { noremap = true, silent = true})
vim.keymap.set('n', '<leader>gN', '<cmd>Gitsigns prev_hunk<CR>', { noremap = true, silent = true})

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle) -- undotree

local diagnostics_active = true
local toggle_diagnostics = function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then vim.diagnostic.show() else vim.diagnostic.hide() end
end
vim.keymap.set('n', '<leader>td', toggle_diagnostics)

-- packer
vim.cmd.packadd('packer.nvim')
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'morhetz/gruvbox',
        as = 'gruvbox',
        config = function()
            vim.cmd('colorscheme gruvbox')
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'} }
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'onsails/lspkind.nvim'},
            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
            -- Debugging
            {'mfussenegger/nvim-dap'},
            {'rcarriga/nvim-dap-ui'},
            {'theHamsta/nvim-dap-virtual-text'},
            {'simrat39/rust-tools.nvim'},
            {'leoluz/nvim-dap-go'},
        }
    }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    }
    use {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup {
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
            }
        end
    }
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function() require("trouble").setup() end
    }
    use({
        "folke/persistence.nvim",
        event = "BufReadPre",
        module = "persistence",
        config = function() require("persistence").setup() end
    })
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end
    }
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end
    }
    use 'nvim-telescope/telescope-ui-select.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'tpope/vim-fugitive' -- git management
    use 'nvim-lua/plenary.nvim'
    use 'sindrets/diffview.nvim'
    use 'mbbill/undotree'
    use 'mg979/vim-visual-multi' -- multicursor
    use 'nvim-tree/nvim-tree.lua'
    use 'terrortylor/nvim-comment'
    use 'RRethy/vim-illuminate' -- highlight same words
    use 'tpope/vim-surround'
end)

vim.cmd[[autocmd VimEnter * nested if !argc() && !exists("s:std_in") | execute 'lua require("persistence").load()' | endif]]

vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tr', ':TroubleToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tw', ':WhichKey<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>;', ':ToggleTerm direction=float<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>:', ':ToggleTerm direction=horizontal<CR>', { noremap = true, silent = true })

local telescope = require('telescope.builtin')
vim.keymap.set({'n', 'v'}, '<leader>rf', telescope.lsp_references)
vim.keymap.set({'n', 'v'}, '<leader>ds', telescope.lsp_document_symbols)
vim.keymap.set('n', '<leader>a', telescope.find_files)
vim.keymap.set('n', '<leader>A', telescope.resume)
vim.keymap.set('n', '<leader>s', telescope.live_grep)
vim.keymap.set('n', '<leader>S', telescope.grep_string)
vim.keymap.set('n', '<leader>b', ':Telescope buffers previewer=false<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', ':Telescope oldfiles previewer=false<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', telescope.keymaps)
vim.keymap.set('n', '<leader>N', telescope.command_history)
vim.keymap.set('n', '<C-w>a', '<C-w>v<C-w>w<cmd>lua require\'telescope.builtin\'.find_files()<CR>') -- open windows
vim.keymap.set('n', '<C-w>A', '<C-w>v<C-w>w<cmd>lua require\'telescope.builtin\'.resume()<CR>') -- open windows
vim.keymap.set('n', '<C-w>s', '<C-w>v<C-w>w<cmd>lua require\'telescope.builtin\'.live_grep()<CR>')
vim.keymap.set('n', '<C-w>S', '<C-w>v<C-w>w<cmd>lua require\'telescope.builtin\'.grep_string()<CR>')

require("telescope").setup {
    defaults = {
        prompt_prefix = "   ",
    },
    extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown { } }
    }
}
require("telescope").load_extension("ui-select")

require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'lua', 'help', 'vim',
        'rust',
        'go',
        'c', 'cpp',
        'c_sharp'
    },
    highlight = { enable = true },
    diagnostics = { enabled = true },
}

require('lualine').setup {
    options = {
        theme = 'gruvbox-material',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
    }
}

require('nvim-tree').setup()
require('nvim_comment').setup({comment_empty = false})

-- lsp configuration
local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.ensure_installed({
    'rust_analyzer',
    'gopls',
    'omnisharp',
})
-- lsp.skip_server_setup({'rust_analyzer'})
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
local lspkind = require('lspkind')
lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function (entry, vim_item)
                return vim_item
            end
        })
    }
})
lsp.setup()
vim.diagnostic.config({ virtual_text = true })
local signs = {
    Error = " ",
    Warning = " ",
    Hint = " ",
    Information = " "
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
})
local format_sync_grp = vim.api.nvim_create_augroup("FileFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs", "*.go" },
    callback = function()
        vim.lsp.buf.format()
    end,
    group = format_sync_grp,
})

-- debugger configuration
require('rust-tools').setup()
require('dap-go').setup()
local dap = require 'dap'
local dapui = require 'dapui'

vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<leader><F5>', dap.terminate)
vim.keymap.set('n', '<F6>', dap.step_over)
vim.keymap.set('n', '<F7>', dap.step_into)
vim.keymap.set('n', '<F8>', dap.step_out)
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dbp', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dbc', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
vim.keymap.set('n', '<leader>dbl', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Breakpoint log message: "))<CR>')
vim.keymap.set('n', '<leader>du', dapui.toggle)

dap.adapters.lldb = function(callback, _)
    local handle
    local pid_or_err
    local opts = {
        args = {"build"},
        detached = true
    }
    vim.api.nvim_command('write')
    handle, pid_or_err = vim.loop.spawn("cargo", opts, function(code)
        handle:close()
        if code ~=0 then
            print('cargo build exited with code', code)
            return
        end
        vim.schedule(
        function()
            callback({
                type = 'server', 
                port = 13000, 
                executable = {
                    command = os.getenv('HOME') .. '/lldb/extension/adapter/codelldb',
                    args = { '--liblldb', os.getenv('HOME') .. '/lldb/extension/lldb/lib/liblldb.so', '--port', '13000' }
                }
            })
        end)
    end)
    assert(handle, 'Error running cargo build: ' .. tostring(pid_or_err))
end
dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
        stdio = {nil, stdout},
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then
            print('dlv exited with code', code)
        end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function()
                require('dap.repl').append(chunk)
            end)
        end
    end)
    vim.defer_fn(
    function()
        callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100)
end
dap.adapters.coreclr = {
  type = 'executable',
  command = os.getenv('HOME') .. '/dotnet/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}
dap.configurations.rust = {
    {
        type = "lldb",
        name = "Launch",
        request = "launch",
        cwd = '${workspaceFolder}',
        program = '${workspaceFolder}/target/debug/${workspaceFolderBasename}'
    }
}
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}"
    }
}
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "right",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 0.25,
            position = "bottom",
        },
    },
    controls = { enabled = false },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})
require("nvim-dap-virtual-text").setup()
