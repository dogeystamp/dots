-- tinymist (typst lsp) configuration

local confutil = require("confutil")
local keymap = confutil.keymap

-- live preview command
keymap('<leader>fp',
    function()
        vim.lsp.get_clients({ name = "tinymist" })[1]:exec_cmd({
            command = "tinymist.startDefaultPreview",
            title =
            "Preview"
        })
    end
)

local function get_git_root()
    local root_path = vim.fn.finddir(".git", ";");
    return vim.fn.fnamemodify(root_path, ":h")
end

--- Compile using `typst watch`.
---
--- Does not go through LSP. Compile output buffer is spawned in new tab; use
--- gt/gT to switch to and from it.
local function typst_watch()
    local proj_root = get_git_root()
    local file_path = vim.fn.expand("%:p")
    vim.cmd.tabnew()
    vim.cmd.terminal("typst watch --root " .. proj_root .. ' ' .. file_path)
    vim.cmd.tabprev()
end

--- Open Zathura for the pdf compiled from this buffer.
local function typst_zathura()
    local pdf_path = vim.fn.expand("%:p:r") .. ".pdf";
    local ok = vim.wait(3000, function()
        return vim.uv.fs_stat(pdf_path) ~= nil
    end)
    if ok then
        os.execute("zathura --fork " .. pdf_path .. " &")
    else
        error("file " .. pdf_path .. " did not exist")
    end
end

keymap('<leader>fc', function()
    typst_watch()
    typst_zathura()
end)
keymap('<leader>fr', typst_zathura)
