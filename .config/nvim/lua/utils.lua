return {
  config = function(name, config)
    local project_config = {}
    if _G[name .. "_config"] then
      project_config = _G[name .. "_config"]()
    end

    return vim.tbl_deep_extend("force", config, project_config)
  end,
}
