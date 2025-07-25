local h = KraftnixHelper
local ollamaModel = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:7b"
local ollamaPort = os.getenv("OLLAMA_PORT") or "11434"
local ollamaHost = os.getenv("OLLAMA_HOST") or "localhost"
-- "llama3.1:7b"
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "echasnovski/mini.diff", -- Inline and better diff over the default
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
    },
    keycommands_meta = {
      --source_plugin = legendary (from lazy.main)
      group_name = 'CodeCompanion LLM',
      description = 'Interact with Ollama via neovim',
      icon = '🤖',
      default_opts = { -- only applies to this lazy keygroup
        silent = true,
      }
    },
    keycommands = {
      h.mapSkipGen { "<C-l><C-l>", 'CodeCompanionActions', 'Open the action palette' },
      h.mapSkipGen { "<leader>al", 'CodeCompanionChat Toggle', 'Toggle a chat buffer' },
      -- h.mapSkipGen { "<leader>aL", 'CodeCompanionChat Add', 'Add code to a code buffer', opts = { mode = { 'v' }, }, },
    },
    opts = {
      show_defaults = false, -- only show our configured options
      display = {
        diff = {
          provider = 'mini_diff',
        },
      },
      strategies = {
        chat = {
          provider = "ollama",
          adapter = "ollama",
          model = ollamaModel,
          system_prompt = "You are an AI programming assistant named \"CodeCompanion\". You are currently plugged into the Neovim text editor.",
        },
        inline = {
          provider = "ollama",
          adapter = "ollama",
          model = ollamaModel,
        },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen3:14b",
              },
              num_ctx = {
                default = 20000,
              },
              num_predict = {
                default = -1,
              },
            },
            env = {
              url = "http://"..ollamaHost..":"..ollamaPort,
            },
            headers = {
              ["Content-Type"] = "application/json",
              -- ["Authorization"] = "Bearer ${api_key}",
            },
            parameters = {
              sync = true,
            },
          })
        end,
        qwen3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen3", -- Give this adapter a different name to differentiate it from the default ollama adapter
            opts = {
              vision = true,
              stream = true,
            },
            schema = {
              model = {
                default = "qwen3:latest",
              },
              num_ctx = {
                default = 16384,
              },
              think = {
                -- default = false,
                -- or, if you want to automatically turn on `think` for certain models:
                default = function(adapter)
                  -- this'll set `think` to true if the model name contain `qwen3` or `deepseek-r1`
                  local model_name = adapter.model.name:lower()
                  return vim.iter({ "qwen3", "deepseek-r1" }):any(function(kw)
                    return string.find(model_name, kw) ~= nil
                  end)
                end,
              },
              keep_alive = {
                default = '5m',
              }
            },
          })
        end,
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    nix_disable = true,
    keycommands_meta = {
      --source_plugin = legendary (from lazy.main)
      group_name = 'Gen LLM',
      description = 'Interact with Ollama via neovim',
      icon = '🤖',
      default_opts = { -- only applies to this lazy keygroup
        silent = true,
      }
    },
    keycommands = {
      h.mapSkipGen { "<leader>aa", 'Gen', 'Open Gen finder' },
      h.mapSkipGen { "<leader>ac", 'Gen Change Code', 'Open Gen :-> Change Coded' },
      h.mapSkipGen { "<leader>aC", 'Gen Change', 'Open Gen :-> Change' },
      h.mapSkipGen { "<leader>a<leader>", 'Gen Chat', 'Open Gen :-> Chat' },
      h.mapSkipGen { "<leader>aec", 'Gen Enhance Code', 'Open Gen :-> Enhance Code' },
      h.mapSkipGen { "<leader>aeg", 'Gen Enhance Grammar Spelling', 'Open Gen :-> Enhance Grammar Spelling' },
      h.mapSkipGen { "<leader>aec", 'Gen Enhance Wording', 'Open Gen :-> Enhance Wording' },
      h.mapSkipGen { "<leader>ag", 'Gen Generate', 'Open Gen :-> Generate' },
      h.mapSkipGen { "<leader>af", 'Gen Fix_Code', 'Open Gen :-> Fix_Code' },
      h.mapSkipGen { "<leader>amc", 'Gen Make Concise', 'Open Gen :-> Make Concise' },
      h.mapSkipGen { "<leader>aml", 'Gen Make List', 'Open Gen :-> Make List' },
      h.mapSkipGen { "<leader>amc", 'Gen Make Table', 'Open Gen :-> Make Table' },
      h.mapSkipGen { "<leader>ar", 'Gen Review Code', 'Open Gen :-> Review Code' },
      h.mapSkipGen { "<leader>as", 'Gen Summarize', 'Open Gen :-> Summarize' },
    },
    opts = {
      model = ollamaModel, -- The default model to use.
      quit_map = "q", -- set keymap for close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
      host = "localhost", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = true, -- Shows the prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = true, -- Never closes the window automatically.
      hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`)
      -- init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = function(options)
        local body = {model = options.model, stream = true}
        return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false -- Prints errors and the command which is run.
    },
    config = function (_, opts)
      local gen = require('gen')
      ollamaPort = os.getenv("OLLAMA_PORT") or opts.port or "11434"
      ollamaHost = os.getenv("OLLAMA_HOST") or opts.host or "localhost"
      ollamaModel = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:7b"
      opts['port'] = ollamaPort
      opts['host'] = ollamaHost
      opts['model'] = ollamaModel
      gen.setup(opts)
      gen.prompts['Fix_Code'] = {
        prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```"
      }
    end
  },
}
