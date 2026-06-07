--@module 'lazy'
--@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = function(_, opts) return require('indent-rainbowline').make_opts(opts) end,
  dependencies = {
    'TheGLander/indent-rainbowline.nvim',
  },
}
-- vim: ts=2 sts=2 sw=2 et
