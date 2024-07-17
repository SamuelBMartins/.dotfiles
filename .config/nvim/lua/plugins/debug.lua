return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      opts = {
        -- Terminal as vplit to the right
        layouts = {
          {
            elements = {
              {
                id = "console",
                size = 1,
              },
            },
            position = "bottom",
            size = 17,
          },
          {
            elements = {
              {
                id = "scopes",
                size = 0.33,
              },
              {
                id = "stacks",
                size = 0.33,
              },
              {
                id = "watches",
                size = 0.33,
              },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              {
                id = "repl",
                size = 0.5,
              },
              {
                id = "breakpoints",
                size = 0.5,
              },
            },
            position = "right",
            size = 40,
          },
        },
      },
    },
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("mason-nvim-dap").setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "javadbg",
      },
    }

    vim.keymap.set(
      "n",
      "<leader>dc",
      dap.continue,
      { desc = "Debug: Start/Continue" }
    )
    vim.keymap.set(
      "n",
      "<leader>dj",
      dap.step_into,
      { desc = "Debug: Step Into" }
    )
    vim.keymap.set(
      "n",
      "<leader>dl",
      dap.step_over,
      { desc = "Debug: Step Over" }
    )
    vim.keymap.set(
      "n",
      "<leader>dk",
      dap.step_out,
      { desc = "Debug: Step Out" }
    )
    vim.keymap.set(
      "n",
      "<leader>bb",
      dap.toggle_breakpoint,
      { desc = "Debug: Toggle Breakpoint" }
    )
    vim.keymap.set("n", "<leader>bc", function()
      dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end, { desc = "Debug: Set Breakpoint" })

    vim.keymap.set(
      "n",
      "<leader>du",
      dapui.toggle,
      { desc = "Debug: See last session result." }
    )

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    -- dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
