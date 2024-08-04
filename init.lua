-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
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
vim.opt.whichwrap = "b,s,<,>,[,]"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.title = true
vim.opt.titlestring = '%m%r' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' (%t)'

-- maps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local nx = { 'n', 'x' }
local nxi = { 'n', 'x', 'i' }
local nxit = { 'n', 'x', 'i', 't' }

vim.g.mapleader = ' '

keymap(nxi, '<C-s>', '<cmd>write<CR>')
keymap(nxi, '<C-S>', '<cmd>wa<CR>')
keymap(nxit, '<C-q>', '<cmd>quitall<CR>')
keymap(nx, '<leader>q', '<cmd>quit<CR>')
keymap(nx, '<leader>Q', '<cmd>tabclose<CR>')
keymap('t', '<Esc>', '<cmd>quit<CR>')                    -- exit terminal
keymap('t', '<C-n>', '<C-\\><C-n>')                      -- escape terminal

keymap(nx, 'c', '"_c')                                   -- don't yank on 'c'
keymap(nx, 'd', '"_d')                                   -- don't yank on 'd'
keymap('x', 'y', 'ygv<Esc>')                             -- don't change pos after yank
keymap('x', '<leader>y', '"+ygv<Esc><cmd>let @"=@0<CR>') -- copy to system clipboard
keymap('x', '<leader>Y', '"+Y<cmd>let @"=@0<CR>')
keymap(nx, '<leader>p', '"+p')                           -- paste from system clipboard
keymap(nx, '<leader>P', '"+P')
keymap('x', 'p', '"_dp')                                 -- paste without yanking
keymap('x', 'P', '"_dP')
keymap('i', '<C-H>', '<C-W>')                            -- backspace/delete
keymap('n', '<C-H>', 'db')
keymap('i', '<C-Del>', '<space><Esc>ce')
keymap('n', '<C-Del>', 'dw')

keymap('n', '<C-d>', '<C-d>zz')    -- center screen after move
keymap('n', '<C-u>', '<C-u>zz')
keymap(nx, '<leader>[', '10[{')    -- move to start/end of group
keymap(nx, '<leader>]', '10]}')
keymap('n', '<leader>o', 'o<C-c>') -- empty line
keymap('n', '<leader>O', 'O<C-c>')
keymap('n', 'o', 'o<C-c>"_cc')
keymap('n', 'O', 'O<C-c>"_cc')
keymap('n', 'J', 'mzJ`z')                                    -- keep cursor pos while J
keymap('n', '<C-b>', '<cmd>%bd<bar>e#<bar>bd#<CR>\'"', opts) -- close all buffers
keymap('n', '_', '<cmd>bprev<CR>', opts)
keymap('n', '+', '<cmd>bnext<CR>', opts)
keymap('v', '<', '<gv')                     -- keep selection while indenting
keymap('v', '>', '>gv')
keymap('v', 'J', ":m '>+1<CR>gv=gv")        -- move selected up/down
keymap('v', 'K', ":m '<-2<CR>gv=gv")
keymap(nxi, '<A-Left>', '<C-o>')            -- navigate buffers
keymap(nxi, '<A-Right>', '<C-i>')
keymap(nxi, '<C-w><C-Left>', '<C-w><Left>') -- nawigate windows
keymap(nxi, '<C-W><C-Right>', '<C-w><Right>')
keymap(nxi, '<C-W><C-Up>', '<C-w><Up>')
keymap(nxi, '<C-W><C-Down>', '<C-w><Down>')

keymap('n', '<S-L>', ':Lazy<CR>')
keymap('n', '<S-M>', ':Mason<CR>')

--> lsp
keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', opts)
keymap('n', '<leader>rn', vim.lsp.buf.rename)
keymap('n', '<leader>D', vim.lsp.buf.type_definition)
keymap('n', '<leader>df', vim.lsp.buf.definition)
keymap('n', '<leader>ca', vim.lsp.buf.code_action)
keymap('n', 'K', vim.lsp.buf.hover)
keymap(nxi, '<C-k>', vim.lsp.buf.signature_help)
keymap('n', '<leader>f', vim.lsp.buf.format)

--> git
keymap('n', '<leader>gs', vim.cmd.Git)
keymap('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', opts)
keymap('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', opts)
keymap('n', '<leader>gl', '<cmd>Git log<CR>', opts)
keymap('n', '<leader>gB', '<cmd>Git blame<CR>', opts)
keymap('n', '<leader>gc', '<cmd>Git commit<CR>', opts)
keymap('n', '<leader>gp', '<cmd>Git push<CR>', opts)
keymap('n', '<leader>ga', '<cmd>Git show<CR>', opts)
keymap('n', '<leader>gb', '<cmd>Gitsigns blame_line<CR>', opts)
keymap('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<CR>', opts)
keymap('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', opts)
keymap('n', '<leader>gN', '<cmd>Gitsigns prev_hunk<CR>', opts)

local diagnostics_active = true
local toggle_diagnostics = function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then vim.diagnostic.show() else vim.diagnostic.hide() end
end
keymap('n', '<leader>td', toggle_diagnostics)

-- Lazy.nvim setup
require("lazy").setup({
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup({
                overrides = function(colors)
                    return {
                        Function = { bold = true }
                    }
                end
            })
            vim.cmd 'colorscheme kanagawa-wave'
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "nvim-telescope/telescope-ui-select.nvim",
            "molecule-man/telescope-menufacture",
            "debugloop/telescope-undo.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    prompt_prefix = "   ",
                },
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown {} },
                    menufacture = {
                        mappings = {
                            main_menu = { [{ "i", "n" }] = "<C-^>" },
                            search_in_directory = { [{ "i", "n" }] = "<C-r>" },
                            search_by_filename = { [{ "i", "n" }] = "<C-t>" },
                        },
                    }
                }
            })
            telescope.load_extension("ui-select")
            telescope.load_extension("menufacture")
            telescope.load_extension("undo")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            -- Debugging
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
        }
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
        },
        config = function()
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    end,
                },
            }, neotest_ns)
            require("neotest").setup({
                adapters = {
                    require("neotest-go"),
                },
            })
        end
    },
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup {
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
            }
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function() require("trouble").setup() end
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function() require("persistence").setup() end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end
    },
    {
        "saecki/crates.nvim",
        version = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end
    },
    {
        "nat-418/boole.nvim",
        config = function()
            require("boole").setup {
                mappings = {
                    increment = "<C-a>",
                    decrement = "<C-x>"
                },
            }
        end
    },
    {
        "rguruprakash/simple-note.nvim",
        config = function()
            require("simple-note").setup()
        end
    },
    {
        "MeanderingProgrammer/markdown.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("render-markdown").setup()
        end
    },
    {
        "Isrothy/neominimap.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        init = function()
            vim.g.neominimap = {
                auto_enable = false,
                minimap_width = 10,
            }
        end,
    },
    {
        "axkirillov/hbac.nvim",
        config = function()
            local actions = require("hbac.telescope.actions")
            require("hbac").setup({
                threshold = 25,
                telescope = {
                    use_default_mappings = false,
                    mappings = {
                        i = {
                            ["<C-r>"] = actions.delete_buffer,
                            ["<C-p>"] = actions.toggle_pin
                        }
                    }
                }
            })
        end
    },
    "kyazdani42/nvim-web-devicons",
    "tpope/vim-fugitive", -- git management
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "mg979/vim-visual-multi", -- multicursor
    "nvim-tree/nvim-tree.lua",
    "terrortylor/nvim-comment",
    "RRethy/vim-illuminate", -- highlight same words
    "tpope/vim-surround",
    "lambdalisue/vim-suda",  -- :SudaWrite
})

vim.cmd [[autocmd VimEnter * nested if !argc() && !exists("s:std_in") | execute 'lua require("persistence").load()' | endif]]

keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', opts)
keymap('n', '<leader>tf', ':NvimTreeFindFile<CR>', opts)
keymap('n', '<leader>tr', ':TroubleToggle<CR>', opts)
keymap('n', '<leader>tw', ':WhichKey<CR>', opts)
keymap('n', '<leader>;', ':ToggleTerm direction=float<CR>', opts)
keymap('n', '<leader>:', ':ToggleTerm direction=horizontal<CR>', opts)
keymap('n', '<leader>n', ':SimpleNoteList<CR>', opts)
keymap('n', '<leader>N', function() vim.o.cole = vim.o.cole == 0 end, opts)
keymap('n', '<leader>w', function() vim.o.wrap = not vim.o.wrap end, opts)

keymap('n', '<leader>te', ":Neotest run<CR>", opts)
keymap('n', '<leader>tE', ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", opts)
keymap('n', '<leader>tk', ":Neotest output<CR>", opts)
keymap('n', '<leader>to', ":Neotest output-panel toggle<CR>", opts)
keymap('n', '<leader>tO', ":Neotest output-panel clear<CR>", opts)
keymap('n', '<leader>ts', ":Neotest summary toggle<CR>", opts)

local crates = require('crates')
keymap('n', '<leader>ct', crates.toggle, opts)
keymap('n', '<leader>cr', crates.reload, opts)
keymap('n', '<leader>ci', crates.show_popup, opts)
keymap('n', '<leader>cf', crates.show_features_popup, opts)
keymap('n', '<leader>cv', crates.show_versions_popup, opts)
keymap('n', '<leader>cd', crates.show_dependencies_popup, opts)
keymap('n', '<leader>cu', crates.upgrade_crate, opts)
keymap('n', '<leader>cU', crates.upgrade_all_crates, opts)
keymap('v', '<leader>cu', crates.upgrade_crates, opts)

local telescope = require('telescope')
local telescopebin = require('telescope.builtin')
keymap(nx, '<leader>rf', telescopebin.lsp_references)
keymap(nx, '<leader>ef', telescopebin.lsp_implementations)
keymap(nx, '<leader>ds', telescopebin.lsp_document_symbols)
keymap('n', '<leader>a', telescope.extensions.menufacture.find_files)
keymap('n', '<leader>A', telescopebin.resume)
keymap('n', '<leader>s', telescope.extensions.menufacture.live_grep)
keymap('n', '<leader>S', telescope.extensions.menufacture.grep_string)
keymap('v', '<leader>S', function()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    if #text == 0 then
        text = ''
    end
    telescope.extensions.menufacture.live_grep({ default_text = text })
end, opts)
keymap('n', '<leader>u', telescope.extensions.undo.undo)
keymap('n', '<leader>b', telescope.extensions.hbac.buffers)
keymap('n', '<leader>m', ':Neominimap toggle<CR>', opts)
keymap('n', '<leader>k', telescopebin.keymaps)
keymap('n', '<leader>K', telescopebin.command_history)
keymap('n', '<C-w>a', '<C-w>v<C-w>w<cmd>lua require\'telescope\'.extensions.menufacture.find_files()<CR>') -- open windows
keymap('n', '<C-w>A', '<C-w>v<C-w>w<cmd>lua require\'telescope.builtin\'.resume()<CR>')                    -- open windows
keymap('n', '<C-w>s', '<C-w>v<C-w>w<cmd>lua require\'telescope\'.extensions.menufacture.live_grep()<CR>')
keymap('n', '<C-w>S', '<C-w>v<C-w>w<cmd>lua require\'telescope\'.extensions.menufacture.grep_string()<CR>')
keymap('n', '<C-w><C-e>', function()
    if vim.api.nvim_win_get_option(0, 'winfixwidth') then
        return
    end
    local total_width = 0
    local windows = 0
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if not vim.api.nvim_win_get_option(win, 'winfixwidth') then
            total_width = total_width + vim.api.nvim_win_get_width(win)
            windows = windows + 1
        end
    end
    local expandWidth = math.ceil(total_width * 2 / 3)
    if vim.api.nvim_win_get_width(0) >= expandWidth then
        vim.api.nvim_win_set_width(0, math.ceil(total_width / windows))
    else
        vim.api.nvim_win_set_width(0, expandWidth)
    end
end, opts)

require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'lua', 'vim',
        'rust',
        'go', 'gomod', 'gosum',
        'c', 'cpp',
        'c_sharp',
        'json', 'yaml', 'toml',
        'markdown', 'markdown_inline'
    },
    highlight = { enable = true },
    diagnostics = { enabled = true },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]f"] = "@function.inner",
                ["]p"] = "@parameter.inner"
            },
            goto_previous_start = {
                ["[f"] = "@function.inner",
                ["[p"] = "@parameter.inner"
            }
        },
        select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
                ["ib"] = "@block.inner",
                ["ab"] = "@block.outer",
                ["if"] = "@function.inner",
                ["af"] = "@function.outer",
                ["ip"] = "@parameter.inner",
                ["ap"] = "@parameter.outer"
            }
        },
        swap = {
            enable = true,
            swap_next = {
                ["]F"] = "@function.outer",
                ["]P"] = "@parameter.inner"
            },
            swap_previous = {
                ["[F"] = "@function.outer",
                ["[P"] = "@parameter.inner"
            }
        }
    }
}

require('lualine').setup {
    options = {
        theme = 'gruvbox-material',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    }
}

require('nvim-tree').setup()
require('nvim_comment').setup({ comment_empty = false })

-- lsp configuration
local lsp = require("lsp-zero")
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'gopls',
        'rust_analyzer',
        'marksman'
    },
    handlers = { lsp.default_setup }
})

require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip").config.setup({
    region_check_events = "CursorMoved",
    delete_check_events = "TextChanged",
})

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
cmp.setup({
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
    },
    mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<CR>'] = cmp.mapping.confirm(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-N>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.abort()
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = require('lspkind').cmp_format({ mode = 'symbol' })
    }
})
lsp.set_sign_icons({
    error = "",
    warn = "",
    hint = "",
    info = ""
})
lsp.format_on_save({
    servers = {
        ['gopls'] = { 'go' },
        ['rust_analyzer'] = { 'rust' }
    }
})
lsp.setup()

-- debugger configuration
require('dap-go').setup()
local dap = require 'dap'
local dapui = require 'dapui'

keymap('n', '<F5>', dap.continue)
keymap('n', '<leader><F5>', dap.terminate)
keymap('n', '<F6>', dap.step_over)
keymap('n', '<F7>', dap.step_into)
keymap('n', '<F8>', dap.step_out)
keymap('n', '<leader>db', dap.toggle_breakpoint)
keymap('n', '<leader>dbp', dap.toggle_breakpoint)
keymap('n', '<leader>dbc', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
keymap('n', '<leader>dbl', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Breakpoint log message: "))<CR>')
keymap('n', '<leader>du', dapui.toggle)

dap.adapters.lldb = function(callback, _)
    local handle
    local pid_or_err
    local opts = {
        args = { "build" },
        detached = true
    }
    vim.api.nvim_command('write')
    handle, pid_or_err = vim.loop.spawn("cargo", opts, function(code)
        handle:close()
        if code ~= 0 then
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
                        args = { '--liblldb', os.getenv('HOME') .. '/lldb/extension/lldb/lib/liblldb.so', '--port',
                            '13000' }
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
        stdio = { nil, stdout },
        args = { "dap", "-l", "127.0.0.1:" .. port },
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
            callback({ type = "server", host = "127.0.0.1", port = port })
        end,
        100)
end
dap.adapters.coreclr = {
    type = 'executable',
    command = os.getenv('HOME') .. '/dotnet/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
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
                { id = "scopes",      size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
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
