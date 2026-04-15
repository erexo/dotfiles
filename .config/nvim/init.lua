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
vim.opt.cursorline = true
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
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true
vim.opt.whichwrap = "b,s,<,>,[,]"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.title = true
vim.opt.titlestring = '%m%r%{fnamemodify(getcwd(), ":t")} (%t)'

-- maps
local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command
local key_opts = { noremap = true, silent = true }
local nx = { 'n', 'x' }
local nxi = { 'n', 'x', 'i' }
local nxit = { 'n', 'x', 'i', 't' }

vim.g.mapleader = ' '
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}

keymap(nxi, '<C-s>', '<cmd>write<CR>')
keymap(nxi, '<C-S>', '<cmd>wa<CR>')
keymap(nxit, '<C-q>', '<cmd>quitall<CR>')
keymap(nx, '<leader>q', '<cmd>quit<CR>')
keymap(nx, '<leader>Q', '<cmd>tabclose<CR>')
keymap('t', '<C-c>', '<cmd>quit<CR>')                    -- exit terminal
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
keymap('n', 'J', 'mzJ`z')                                        -- keep cursor pos while J
keymap('n', '<C-b>', '<cmd>%bd<bar>e#<bar>bd#<CR>\'"', key_opts) -- close all buffers
keymap('n', '_', '<cmd>bprev<CR>', key_opts)
keymap('n', '+', '<cmd>bnext<CR>', key_opts)
keymap('v', '<', '<gv')                     -- keep selection while indenting
keymap('v', '>', '>gv')
keymap('v', 'J', ":m '>+1<CR>gv=gv")        -- move selected up/down
keymap('v', 'K', ":m '<-2<CR>gv=gv")
keymap('v', 'il', "^o$h")                   -- select line
keymap(nxi, '<A-Left>', '<C-o>')            -- navigate buffers
keymap(nxi, '<A-Right>', '<C-i>')
keymap(nxi, '<C-w><C-Left>', '<C-w><Left>') -- nawigate windows
keymap(nxi, '<C-W><C-Right>', '<C-w><Right>')
keymap(nxi, '<C-W><C-Up>', '<C-w><Up>')
keymap(nxi, '<C-W><C-Down>', '<C-w><Down>')

keymap('n', '<leader>N', function() vim.o.cole = vim.o.cole == 0 and 2 or 0 end, key_opts)
keymap('n', '<leader>w', function() vim.o.wrap = not vim.o.wrap end, key_opts)
keymap('n', '<C-w>a', '<C-w>v<C-w>w')
keymap('n', '<C-w><C-e>', function()
    if vim.wo[0].winfixwidth then return end
    local win = vim.api.nvim_get_current_win()
    local function get_row(n)
        if n[1] == 'leaf' then return n[2] == win end
        for _, c in ipairs(n[2]) do
            local r = get_row(c)
            if r then return type(r) == 'table' and r or (n[1] == 'row' and n or true) end
        end
    end
    local row = get_row(vim.fn.winlayout())
    local total, count = 0, 0
    local function calc(n)
        if n[1] == 'leaf' then
            if not vim.wo[n[2]].winfixwidth then
                total = total + vim.api.nvim_win_get_width(n[2])
                count = count + 1
            end
        else
            calc(n[2][1])
        end
    end
    if type(row) == 'table' then
        for _, c in ipairs(row[2]) do calc(c) end
    else
        calc({ 'leaf', win })
    end
    local exp = math.ceil(total * 4 / 5)
    vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) >= exp - 1 and math.ceil(total / count) or exp)
end, key_opts)

-- managers
keymap('n', '<S-L>', '<cmd>Lazy<CR>')
keymap('n', '<S-M>', '<cmd>Mason<CR>')

-- lsp
keymap('n', '<leader>do', vim.diagnostic.open_float, key_opts)
keymap('n', '<leader>d[', function() vim.diagnostic.jump({ count = -1 }) end, key_opts)
keymap('n', '<leader>d]', function() vim.diagnostic.jump({ count = 1 }) end, key_opts)
keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', key_opts)
keymap('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, key_opts)

-- Lazy.nvim setup
require("lazy").setup({
    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        config = function()
            require('vscode').setup()
            vim.cmd.colorscheme "vscode"
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} }
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 'gopls', 'rust_analyzer', 'marksman' }
            })
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local servers = { gopls = {}, rust_analyzer = {}, marksman = {} }

            local on_attach = function(_, bufnr)
                local lsp_opts = { noremap = true, silent = true, buffer = bufnr }
                keymap('n', '<leader>rn', vim.lsp.buf.rename, lsp_opts)
                keymap('n', '<leader>D', vim.lsp.buf.type_definition, lsp_opts)
                keymap('n', '<leader>df', vim.lsp.buf.definition, lsp_opts)
                keymap('n', '<leader>ca', vim.lsp.buf.code_action, lsp_opts)
                keymap('n', 'K', vim.lsp.buf.hover, lsp_opts)
                keymap(nxi, '<C-k>', vim.lsp.buf.signature_help, lsp_opts)
                keymap('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, lsp_opts)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    on_attach(client, args.buf)
                end,
            })

            for server, config in pairs(servers) do
                config.capabilities = capabilities
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.HINT]  = "",
                        [vim.diagnostic.severity.INFO]  = "",
                    },
                },
                virtual_text = true
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope-ui-select.nvim",
            "molecule-man/telescope-menufacture",
            "debugloop/telescope-undo.nvim",
        },
        event = "VeryLazy",
        cmd = "Telescope",
        keys = {
            { "<leader>rf", function() require('telescope.builtin').lsp_references() end,       desc = "LSP References" },
            { "<leader>ef", function() require('telescope.builtin').lsp_implementations() end,  desc = "LSP Implementations" },
            { "<leader>ds", function() require('telescope.builtin').lsp_document_symbols() end, desc = "LSP Document Symbols" },
            { "<leader>A",  function() require('telescope.builtin').resume() end,               desc = "Telescope Resume" },
            { "<leader>u",  function() require('telescope').extensions.undo.undo() end,         desc = "Telescope Undo" },
            { "<leader>K",  function() require('telescope.builtin').keymaps() end,              desc = "Telescope Keymaps" },
            { "<leader>h",  function() require('telescope.builtin').command_history() end,      desc = "Telescope Command History" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = { ["<esc>"] = require("telescope.actions").close }
                    },
                    layout_config = {
                        horizontal = {
                            preview_width = 0.6
                        },
                        height = 0.9,
                        width = 0.9
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--fixed-strings",
                    },
                    prompt_prefix = "   ",
                    file_ignore_patterns = {
                        "testmock/"
                    }
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
        "FabianWirth/search.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        event = "VeryLazy",
        cmd = "Search",
        keys = {
            { "<leader>a", function() require('search').open({ tab_name = 'Files' }) end,                                         desc = "Search Files" },
            { "<leader>s", function() require('search').open({ tab_name = 'Grep' }) end,                                          desc = "Search Grep" },
            { "<leader>S", function() require('search').open({ tab_name = 'Grep', default_text = vim.fn.expand("<cword>") }) end, desc = "Search Word Under Cursor" },
            {
                "<leader>S",
                function()
                    vim.cmd('noau normal! "vy"')
                    local text = vim.fn.getreg('v')
                    vim.fn.setreg('v', {})
                    text = string.gsub(text, "\n", "")
                    if #text == 0 then text = '' end
                    require('search').open({ tab_name = 'Grep', default_text = text })
                end,
                mode = "v",
                desc = "Search Visual Selection"
            }
        },
        config = function()
            require('search').setup({
                tabs = {
                    { "Files", function(o) require('telescope').extensions.menufacture.find_files(o) end },
                    { "Grep",  function(o) require('telescope').extensions.menufacture.live_grep(o) end }
                },
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        main = "nvim-treesitter.configs",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        opts = {
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
        }
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                move = { set_jumps = true },
                select = {
                    lookahead = true,
                    include_surrounding_whitespace = true,
                }
            })

            local select = require("nvim-treesitter-textobjects.select")
            keymap({ "x", "o" }, "ib", function() select.select_textobject("@block.inner", "textobjects") end,
                { desc = "Select inner block" })
            keymap({ "x", "o" }, "ab", function() select.select_textobject("@block.outer", "textobjects") end,
                { desc = "Select outer block" })
            keymap({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end,
                { desc = "Select inner function" })
            keymap({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end,
                { desc = "Select outer function" })
            keymap({ "x", "o" }, "ip", function() select.select_textobject("@parameter.inner", "textobjects") end,
                { desc = "Select inner parameter" })
            keymap({ "x", "o" }, "ap", function() select.select_textobject("@parameter.outer", "textobjects") end,
                { desc = "Select outer parameter" })

            local move = require("nvim-treesitter-textobjects.move")
            keymap({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.inner", "textobjects") end,
                { desc = "Next function inner" })
            keymap({ "n", "x", "o" }, "]p", function() move.goto_next_start("@parameter.inner", "textobjects") end,
                { desc = "Next parameter inner" })
            keymap({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.inner", "textobjects") end,
                { desc = "Prev function inner" })
            keymap({ "n", "x", "o" }, "[p", function() move.goto_previous_start("@parameter.inner", "textobjects") end,
                { desc = "Prev parameter inner" })

            local swap = require("nvim-treesitter-textobjects.swap")
            keymap("n", "]F", function() swap.swap_next("@function.outer") end, { desc = "Swap next function" })
            keymap("n", "]P", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
            keymap("n", "[F", function() swap.swap_previous("@function.outer") end, { desc = "Swap prev function" })
            keymap("n", "[P", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })
        end
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        opts = { useDefaultKeymaps = false },
        keys = {
            { "iW", "<cmd>lua require('various-textobjs').subword('inner')<CR>",    mode = { "o", "x" }, desc = "Inner Subword" },
            { "aW", "<cmd>lua require('various-textobjs').subword('outer')<CR>",    mode = { "o", "x" }, desc = "Outer Subword" },
            { "io", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>", mode = { "o", "x" }, desc = "Inner Any Bracket" },
            { "ao", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>", mode = { "o", "x" }, desc = "Outer Any Bracket" },
            { "iq", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>",   mode = { "o", "x" }, desc = "Inner Any Quote" },
            { "aq", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>",   mode = { "o", "x" }, desc = "Outer Any Quote" },
            { "l",  "<cmd>lua require('various-textobjs').url()<CR>",               mode = { "o", "x" }, desc = "URL" },
        },
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'xzbdmw/colorful-menu.nvim',
            'rafamadriz/friendly-snippets',
            'milanglacier/minuet-ai.nvim',
            'bydlw98/blink-cmp-env',
            'barrettruth/blink-cmp-tmux',
            'moyiz/blink-emoji.nvim',
            "folke/lazydev.nvim",
        },
        version = '1.*',
        opts = {
            keymap = {
                preset = 'enter',
                ['<Esc>'] = { 'hide', 'fallback' }
            },
            completion = {
                ghost_text = { enabled = false },
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'env', 'tmux', 'emoji', 'lazydev' },
                providers = {
                    env = { name = 'Env', module = 'blink-cmp-env' },
                    tmux = { name = 'Tmux', module = 'blink-cmp-tmux' },
                    emoji = { name = 'Emoji', module = 'blink-emoji' },
                    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
                },
            },
        },
        opts_extend = { "sources.default" }
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                go = { "golangcilint" },
            }
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = "*.go",
                callback = function()
                    require('lint').try_lint()
                end
            })
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = {},
        keys = {
            { "<leader>tt", "<cmd>NvimTreeToggle<CR>",   desc = "NvimTree Toggle" },
            { "<leader>tf", "<cmd>NvimTreeFindFile<CR>", desc = "NvimTree Find File" },
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = 'vscode',
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_x = { "encoding", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location", function() return require("opencode").statusline() end }
            }
        }
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            keymap(nx, "<C-Up>", function() mc.lineAddCursor(-1) end)
            keymap(nx, "<C-Down>", function() mc.lineAddCursor(1) end)
            keymap(nx, "<A-Up>", function() mc.lineSkipCursor(-1) end)
            keymap(nx, "<A-Down>", function() mc.lineSkipCursor(1) end)

            keymap(nx, "<C-n>", function() mc.matchAddCursor(1) end)
            keymap(nx, "<A-n>", function() mc.matchSkipCursor(1) end)
            keymap(nx, "<A-N>", function() mc.matchSkipCursor(-1) end)
            keymap(nx, "<C-m>", mc.matchAllAddCursors)

            keymap("n", "<c-leftmouse>", mc.handleMouse)
            keymap("n", "<c-leftdrag>", mc.handleMouseDrag)
            keymap("n", "<c-leftrelease>", mc.handleMouseRelease)

            mc.addKeymapLayer(function(layerSet)
                layerSet(nx, "<Up>", function() mc.lineAddCursor(-1) end)
                layerSet(nx, "<Down>", function() mc.lineAddCursor(1) end)
                layerSet(nx, "<Left>", mc.prevCursor)
                layerSet(nx, "<Right>", mc.nextCursor)
                layerSet(nx, "n", function() mc.matchAddCursor(1) end)
                layerSet(nx, "Q", mc.deleteCursor)
                layerSet(nx, "A", mc.alignCursors)
                layerSet(nx, "t", function() mc.transposeCursors(1) end)
                layerSet(nx, "T", function() mc.transposeCursors(-1) end)

                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end
    },
    {
        "nickjvandyke/opencode.nvim",
        version = "*",
        config = function()
            local opencode_opts = {
                prompts = {
                    ask = { prompt = "@this ", ask = true, submit = true },
                    diff = vim.NIL,
                    document = vim.NIL,
                    comment = {
                        prompt = [[Generate and insert a single-line comment for @this to be placed above the code.
                    - If it's a struct or function declaration: start with the name.
                    - If it's code inside a function: start with lowercase.
                    - Constraint: Do not include a period at the end.
                    - Output ONLY the comment text.
                    ]],
                        submit = true
                    },
                }
            }
            -- vim.g variables strip vim.NIL, so we must set it after load using the plugin's module
            vim.g.opencode_opts = opencode_opts

            -- Hook into the module to force deletion of keys since vim.tbl_deep_extend ignores vim.NIL
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyLoad",
                callback = function(args)
                    if args.data == "opencode.nvim" then
                        local opts = require("opencode.config").opts
                        opts.prompts.diff = nil
                        opts.prompts.document = nil
                    end
                end,
            })

            vim.o.autoread = true
            keymap(nx, "<C-f>", function() require("opencode").select() end)
            keymap('t', "<C-u>", function() require("opencode").command("session.half.page.up") end)
            keymap('t', "<C-d>", function() require("opencode").command("session.half.page.down") end)
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { { "<leader>gs", "<cmd>LazyGit<cr>" } }
    },
    {
        "ramilito/kubectl.nvim",
        opts = {},
        keys = {
            { "<leader>k", function() require('kubectl').toggle({}) end, desc = "Kubectl Toggle" }

        }
    },
    {
        "axkirillov/hbac.nvim",
        cmd = "Hbac",
        keys = {
            { "<leader>b", function() require('telescope').extensions.hbac.buffers() end, desc = "HBAC Buffers" },
        },
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
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "<leader>gB", "<cmd>Gitsigns blame<CR>",      desc = "Gitsigns Blame" },
            { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Gitsigns Blame Line" }
        },
        config = function()
            require("gitsigns").setup()
            require("scrollbar.handlers.gitsigns").setup()
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end,
        keys = {
            { "<leader>tw", "<cmd>WhichKey<CR>", desc = "WhichKey" }
        }
    },
    {
        "nat-418/boole.nvim",
        config = function()
            require("boole").setup {
                mappings = {
                    increment = "<C-i>",
                    decrement = "<C-x>"
                },
            }
            keymap('n', '<C-a>', '<Nop>')
        end
    },
    {
        "jakobknauer/cppswitch",
        opts = {},
        keys = { { "<leader>C", "<cmd>CppswitchSwitch<cr>" } }
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
        keys = {
            { "<leader>T", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble Diagnostics" }
        }
    },
    {
        "rguruprakash/simple-note.nvim",
        opts = {},
        keys = {
            { "<leader>n", "<cmd>SimpleNoteList<CR>", desc = "SimpleNote List" }
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim"
        },
        opts = {
            cmdline = { view = "cmdline" },
            messages = { view_search = false }
        }
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
    },
    {
        "MeanderingProgrammer/markdown.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        main = "render-markdown",
        opts = {}
    },
    {
        "petertriho/nvim-scrollbar",
        opts = {
            handle = { blend = 25 },
            marks = {
                GitAdd = { text = "│" },
                GitChange = { text = "│" }
            },
            handlers = { cursor = false }
        }
    },
    {
        "RRethy/vim-illuminate", -- highlight same words
        config = function()
            require('illuminate').configure()
        end
    },
    {
        "Isrothy/neominimap.nvim",
        keys = {
            { "<leader>m", "<cmd>Neominimap Toggle<CR>", desc = "Neominimap Toggle" }
        }
    },
    { "windwp/nvim-autopairs",  opts = {} },
    { 'rmagatti/auto-session',  opts = {} },
    { "kylechui/nvim-surround", opts = {} },
    "lambdalisue/vim-suda",    -- :SudaWrite
    "vimpostor/vim-tpipeline", -- tmux support
})


-- commands
local function goTags(param, opts)
    local file_path = vim.fn.expand("%:p")
    local struct_name = vim.fn.expand("<cword>")
    vim.cmd("!" ..
        string.format("gomodifytags -w -file %s -struct %s -transform keep -%s-tags %s", file_path, struct_name, param,
            opts.args))
end
command('GoAddTag', function(opts) goTags("add", opts) end, { nargs = 1 })
command('GoRemoveTag', function(opts) goTags("remove", opts) end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ name = "gopls", async = false })
    end
})
