vim.g.lazyvim_blink_main = true
return {
  'milanglacier/minuet-ai.nvim',
  config = function(_, opts)
    local ollamaPort = os.getenv("OLLAMA_PORT") or "11434"
    local ollamaHost = os.getenv("OLLAMA_HOST") or "localhost"
    local ollamaModel = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:7b"
    require('minuet').setup {
      provider = 'openai_fim_compatible',
      n_completions = 1, -- recommend for local model for resource saving
      -- I recommend beginning with a small context window size and incrementally
      -- expanding it, depending on your local computing power. A context window
      -- of 512, serves as an good starting point to estimate your computing
      -- power. Once you have a reliable estimate of your local computing power,
      -- you should adjust the context window to a larger value.
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'Ollama',
          end_point = 'http://'..ollamaHost..':'..ollamaPort..'/v1/completions',
          model = ollamaModel,
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
          request_timeout = 10,
        },
      },
    }
  end,
}
