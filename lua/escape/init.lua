-- Configuration to exit insert mode by typing a key combination (e.g., jk/kj)
-- How it works:
-- 1. When the first key of the combo is pressed, it's immediately inserted into the buffer.
-- 2. A timer is set for a short duration (configurable, defaults to 50ms).
-- 3. If the second key is pressed within that time frame:
--    - The combo is considered complete.
--    - The first character is deleted, and Neovim enters normal mode.
-- 4. If the timer expires before the second key is pressed, the state is reset,
--    allowing for normal single-key input without delay.

local M = {}

-- Default configuration
local config = {
  key1 = 'j',
  key2 = 'k',
  timeout = 50, -- in milliseconds
}

-- Table to store the runtime state
local state = {
  last_key = nil,
  timer_id = nil,
}

-- Function to reset the state when the timer expires or the combo is completed/failed.
local function reset_state()
  if state.timer_id then
    vim.fn.timer_stop(state.timer_id)
    state.timer_id = nil
  end
  state.last_key = nil
end

-- Function called when one of the configured keys is pressed.
function M.handle_key(current_key)
  -- Check if the current key completes the combo with the previously pressed key.
  local is_combo_complete = (current_key == config.key2 and state.last_key == config.key1) or (current_key == config.key1 and state.last_key == config.key2)

  if is_combo_complete then
    -- Combo complete: reset the state, delete the previous character, and execute Esc.
    reset_state()
    return '<BS><Esc>'
  end

  -- Not a combo (either the first key or too much time has passed since the last key).
  -- If there's a previous timer, stop it and reset the state.
  reset_state()

  -- Record the current key as the 'start of the combo'.
  state.last_key = current_key

  -- Set a timer to reset the state after the configured timeout.
  state.timer_id = vim.fn.timer_start(config.timeout, reset_state)

  -- Since it's not a combo, return the current key to be inserted into the buffer.
  return current_key
end

-- Function to set up the keymappings and apply user configuration.
-- @param opts (table | nil): User-defined options to override defaults.
--   - key1 (string): The first key for the combo. Defaults to 'j'.
--   - key2 (string): The second key for the combo. Defaults to 'k'.
--   - timeout (number): The time window for the combo in milliseconds. Defaults to 50.
function M.setup(opts)
  -- Merge user options with defaults
  config = vim.tbl_deep_extend('force', config, opts or {})

  local desc_key1 = string.format('Combo Escape - %s', config.key1)
  local desc_key2 = string.format('Combo Escape - %s', config.key2)

  vim.keymap.set('i', config.key1, function()
    return M.handle_key(config.key1)
  end, { expr = true, silent = true, desc = desc_key1 })
  vim.keymap.set('i', config.key2, function()
    return M.handle_key(config.key2)
  end, { expr = true, silent = true, desc = desc_key2 })
end

return M
