-- make vim.ui functions prettier.
-- uses handcrafted and also fzf.vim UI

M = {}

--- Replacement for `vim.ui.select`.
---@param items any[] Arbitrary items
---@param opts table? Additional options
---     - prompt (string|nil)
---     - format_item (function item -> text)
---     - kind (string|nil)
---@param on_choice fun(item: any|nil, idx: integer|nil)
local function select_new(items, opts, on_choice)
    vim.validate({
        items = { items, 'table', false },
        on_choice = { on_choice, 'function', false },
    })
    opts = opts or {}

    ---@type string[]
    local items_fmt = {}

    local fmt = opts.format_item or tostring
    for i, v in ipairs(items) do
        table.insert(items_fmt, string.format("%d: %s", i, fmt(v)))
    end

    vim.fn["fzf#run"]({
        source = items_fmt,
        sink = function(sel)
            if not sel or sel == "" then
                on_choice(nil, nil)
                return
            end

            local idx_str = string.match(sel, "^(%d+):")
            local idx = tonumber(idx_str)
            assert(idx, "Could not parse fzf output.")
            on_choice(items[idx], idx)
        end,
        options = { "--prompt", (opts.prompt or ">") .. " " },
        window = {
            width = 80,
            height = 20,
        }
    })
end

--- Replacement for `vim.ui.input`.
---@param opts table? Additional options. See |input()|
---     - prompt (string|nil)
---     - default (string|nil)
---@param on_confirm function ((input|nil) -> ())
local function input_new(opts, on_confirm)
    vim.validate({
        opts = { opts, 'table', true },
        on_confirm = { on_confirm, 'function', false },
    })

    opts = (opts and not vim.tbl_isempty(opts)) and opts or vim.empty_dict()

    opts.on_confirm = opts.on_confirm or function() end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true,
        {
            relative = "cursor",
            width = 30,
            height = 1,
            col = 1,
            row = 1,
            border = "rounded",
            title = opts.prompt,
        })

    if opts.default then
        vim.api.nvim_buf_set_lines(buf, 0, 1, true, { opts.default })
    end

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd [[startinsert!]]

    local map_opts = { noremap = true, buffer = buf }

    local function close_win()
        vim.api.nvim_win_close(0, false)
        vim.cmd.stopinsert()
    end

    vim.keymap.set({ "i", "n" }, "<Enter>",
        function()
            close_win()
            on_confirm(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, true), "\n"))
        end,
        map_opts
    )
    vim.keymap.set({ "i" }, "<C-c>", function()
        close_win()
        on_confirm(nil)
    end, map_opts)
end

---Sets up `vim.ui` hooks to use scope.
function M.setup()
    vim.ui.select = select_new
    vim.ui.input = input_new
end

return M
