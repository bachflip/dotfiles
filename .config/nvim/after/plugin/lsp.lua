local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr }
    local bind = vim.keymap.set

    bind('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    lsp_zero.buffer_autoformat()
end)

lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                }
            },
        }
    }
}

require('rust-tools').setup({
    tools = {
        parameter_hints_prefix = "◀︎ ",
        inlay_hints = {
            other_hints_prefix = "▶︎ "
        }
    }
})

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'tsserver',
        'rust_analyzer',
        'lua_ls',
        'bashls',
        'cssls',
        'jsonls',
        'marksman',
        'sqlls',
        'tflint',
        'yamlls',
        'tailwindcss',
        'vimls',
        'pyright',
        'volar',
    },
    handlers = {
        lsp_zero.default_setup,
        tsserver = function()
            require('lspconfig').tsserver.setup({
                settings = {
                    completions = {
                        completeFunctionCalls = true
                    }
                }
            })
        end,
    },
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ['<C-k>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'select' })
            end
        end),

        ['<C-j>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'select' })
            end
        end),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        }),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
