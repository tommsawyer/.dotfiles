vim.keymap.set("n", "<leader>s", "<cmd>source ~/.dotfiles/files/nvim/lua/snippets/go.lua<cr>")

local ls = require("luasnip")
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt
local get_node_text = vim.treesitter.get_node_text

local function startswith(text, prefix)
  return text:find(prefix, 1, true) == 1
end

local function go_default_value(type_name)
  if type_name == "error" then
    return c(1, {
      t("err"),
      d(2, function()
        return ls.sn(nil, fmt("fmt.Errorf(\"{}: %w\", err)", i(1)))
      end
      )
    })
  end

  local number_types = {
    int = true,
    int32 = true,
    int64 = true,
    float32 = true,
    float64 = true
  }
  if number_types[type_name] then
    return t("0")
  end

  if type_name == "string" then
    return t [[""]]
  end

  local is_pointer_type =
      startswith(type_name, "*") or
      startswith(type_name, "map") or
      startswith(type_name, "func") or
      startswith(type_name, "[]")

  if is_pointer_type then
    return t("nil")
  end

  return t(type_name .. "{}")
end

local function go_result_type()
  local cursor_node = ts_utils.get_node_at_cursor()
  local scope = ts_locals.get_scope_tree(cursor_node, 0)

  local function_node_types = {
    function_declaration = true,
    method_declaration = true,
    func_literal = true,
  }

  local function_node
  for _, v in ipairs(scope) do
    if function_node_types[v:type()] then
      function_node = v
      break
    end
  end

  local query = vim.treesitter.query.parse(
    "go",
    [[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]]
  )

  for _, node in query:iter_captures(function_node, 0) do
    if node:type() ~= "parameter_list" then
      return go_default_value(get_node_text(node, 0))
    end

    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      local matching_node = node:named_child(idx)
      local type_node = matching_node:field("type")[1]

      table.insert(result, go_default_value(get_node_text(type_node, 0)))
      if idx ~= count - 1 then
        table.insert(result, t { ", " })
      end
    end

    return result
  end


  return {}
end

ls.add_snippets("go", {
  s("ie", fmta(
    [[
    if err != nil {
      return <result>
    }
    <finish>
    ]], {
      result = d(1, function() return ls.sn(nil, go_result_type()) end),
      finish = i(0)
    }
  ))
})
