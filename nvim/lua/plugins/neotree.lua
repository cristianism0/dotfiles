return {
   {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
    -- options go here
         },
        
    config = function()
        local opts = {noremap = true, silent = true}
        vim.keymap.set('n', '\\', '<cmd>Neotree reveal<CR>', opts)
        vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', opts)
    end
    }
}
