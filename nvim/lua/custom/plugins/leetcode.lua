return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html', -- you have nvim-treesitter installed
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    -- configuration goes here, see :h leetcode.nvim or the README
    -- lang = 'python3',
  },
}
