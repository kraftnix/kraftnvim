return {
  'nvim-java',
  enabled = nixInfo(false, "settings", "languages", "lsp", "enable"),
  ft = 'java',
  for_cat = "java",
  after = function()
    require('java').setup({
      checks = {
        nvim_version = false,        -- Check Neovim version
        nvim_jdtls_conflict = false, -- Check for nvim-jdtls conflict
      },

      -- JDTLS configuration
      jdtls = {
        auto_install = false,
        version = '1.54.0',
        path = nixInfo(false, "settings", "languages", "java", "jdtls"),
      },

      -- Extensions
      lombok = {
        enable = true,
        -- auto_install = false,
        version = '1.18.42',
        path = nixInfo(false, "settings", "languages", "java", "lombok"),
      },

      java_test = {
        enable = false,
        auto_install = false,
        version = '0.44.0',
        path = nixInfo(false, "settings", "languages", "java", "jscode-java-test"),
      },

      java_debug_adapter = {
        enable = false,
        version = '0.58.2',
        path = nixInfo(false, "settings", "languages", "java", "jscode-java-debug"),
      },

      spring_boot_tools = {
        enable = false,
        version = '1.55.1',
      },

      -- JDK installation
      jdk = {
        auto_install = false,
        version = '25',
      },

      -- Logging
      log = {
        use_console = true,
        use_file = true,
        level = 'info',
        log_file = vim.fn.stdpath('state') .. '/nvim-java.log',
        max_lines = 1000,
        show_location = false,
      },

    })
    vim.lsp.enable('jdtls')
  end,
}
