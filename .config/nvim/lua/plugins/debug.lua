return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      opts = {
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.25,
              },
              {
                id = "breakpoints",
                size = 0.25,
              },
              {
                id = "stacks",
                size = 0.25,
              },
              {
                id = "watches",
                size = 0.25,
              },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              {
                id = "console",
                size = 1,
              },
            },
            position = "right",
            size = 80,
          },
          {
            elements = {
              {
                id = "repl",
                size = 1,
              },
            },
            position = "bottom",
            size = 10,
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
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "javadbg",
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
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

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
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
