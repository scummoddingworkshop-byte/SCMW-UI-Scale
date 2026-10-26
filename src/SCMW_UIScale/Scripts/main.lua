-- SCMW — UI Scale v1.0.0
-- Makes SCUM's interface smaller or bigger in 10-point steps.
-- Uses the game's own layout scale, so mouse clicks stay on the right control.
--
-- Ctrl + - : 10 points smaller
-- Ctrl + + : 10 points bigger (or Ctrl + Shift + + on some keyboards)
-- Ctrl + 0 : back to 100%
--
-- The chosen size is saved between sessions in:
--   %LOCALAPPDATA%\SCUM\Saved\SCMW_UIScale.txt
--
-- No game files are edited. Disable the mod to remove it.

local MOD_VERSION = "1.0.0"
local SETTINGS_PATH = "/Script/Engine.Default__UserInterfaceSettings"

local STEP = 0.1
local MIN_SCALE = 0.4
local MAX_SCALE = 1.5
local DEFAULT_SCALE = 1.0

local settings = nil
local last_seen = nil
local reported_missing = false
local applied_starting_scale = false

local function round2(value)
    return math.floor(value * 100 + 0.5) / 100
end

local function clamp(value)
    if value < MIN_SCALE then return MIN_SCALE end
    if value > MAX_SCALE then return MAX_SCALE end
    return value
end

local function save_file_path()
    local base = os.getenv("LOCALAPPDATA")
    if not base or base == "" then
        return nil
    end
    return base .. "\\SCUM\\Saved\\SCMW_UIScale.txt"
end

local function read_saved_scale()
    local path = save_file_path()
    if not path then
        print("[SCMW] no LOCALAPPDATA; UI scale will start at 100%")
        return nil
    end

    local file = io.open(path, "r")
    if not file then
        print("[SCMW] no saved UI scale yet; starting at 100%")
        return nil
    end

    local text = file:read("*a")
    file:close()

    local value = tonumber(text)
    if not value then
        print("[SCMW] saved UI scale is not a number: " .. tostring(text))
        return nil
    end

    value = round2(clamp(value))
    print(string.format("[SCMW] saved UI scale: %.2f", value))
    return value
end

local function write_saved_scale(value)
    local path = save_file_path()
    if not path then
        print("[SCMW] could not save UI scale: no LOCALAPPDATA")
        return
    end

    local file, err = io.open(path, "w")
    if not file then
        print("[SCMW] could not save UI scale: " .. tostring(err))
        return
    end

    file:write(string.format("%.2f\n", value))
    file:close()
    print(string.format("[SCMW] saved UI scale %.2f to %s", value, path))
end

local function get_settings()
    if settings and settings:IsValid() then
        return settings
    end

    settings = StaticFindObject(SETTINGS_PATH)
    if not settings or not settings:IsValid() then
        -- Fallback: the game may use its own subclass of the same settings class.
        settings = StaticFindObject("/Script/SCUM.Default__UserInterfaceSettings")
    end
    if not settings or not settings:IsValid() then
        settings = FindFirstOf("UserInterfaceSettings")
    end

    if not settings or not settings:IsValid() then
        settings = nil
        if not reported_missing then
            reported_missing = true
            print("[SCMW] UserInterfaceSettings not found: " .. SETTINGS_PATH)
        end
    else
        print("[SCMW] UserInterfaceSettings: " .. settings:GetFullName())
    end
    return settings
end

local function current_scale()
    local s = get_settings()
    if not s then return nil end
    local ok, value = pcall(function() return s.ApplicationScale end)
    if not ok then
        print("[SCMW] could not read ApplicationScale: " .. tostring(value))
        return nil
    end
    return value
end

local function set_scale(value)
    local s = get_settings()
    if not s then return false end

    local ok, err = pcall(function() s.ApplicationScale = value end)
    if not ok then
        print("[SCMW] could not set ApplicationScale: " .. tostring(err))
        return false
    end

    local now = current_scale()
    print(string.format("[SCMW] UI scale requested %.2f, now %.2f",
        value, now or -1))
    return true
end

local saved_scale = read_saved_scale()
local starting_scale = saved_scale or DEFAULT_SCALE

local function apply_starting_scale()
    if applied_starting_scale then return end
    if set_scale(starting_scale) then
        applied_starting_scale = true
    end
end

local last_action = 0

-- Two key bindings can match one physical press (for example Ctrl+Shift+= for
-- "+"), and Windows key repeat can fire quickly. Ignore a second action within
-- a short window so one press is always one step.
local function ready()
    local now = os.clock()
    if now - last_action < 0.12 then
        return false
    end
    last_action = now
    return true
end

local function step(delta)
    if not ready() then return end
    local now = current_scale()
    if not now then return end
    local next_value = round2(clamp(now + delta))
    if set_scale(next_value) then
        applied_starting_scale = true
        write_saved_scale(next_value)
    end
end

local function reset()
    if not ready() then return end
    if set_scale(DEFAULT_SCALE) then
        applied_starting_scale = true
        write_saved_scale(DEFAULT_SCALE)
    end
end

RegisterKeyBindAsync(Key.OEM_MINUS, { ModifierKey.CONTROL }, function()
    step(-STEP)
end)

RegisterKeyBindAsync(Key.OEM_MINUS, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
    step(-STEP)
end)

RegisterKeyBindAsync(Key.OEM_PLUS, { ModifierKey.CONTROL }, function()
    step(STEP)
end)

RegisterKeyBindAsync(Key.OEM_PLUS, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
    step(STEP)
end)

RegisterKeyBindAsync(Key.SUBTRACT, { ModifierKey.CONTROL }, function()
    step(-STEP)
end)

RegisterKeyBindAsync(Key.ADD, { ModifierKey.CONTROL }, function()
    step(STEP)
end)

RegisterKeyBindAsync(Key.ZERO, { ModifierKey.CONTROL }, function()
    reset()
end)

RegisterKeyBindAsync(Key.NUM_ZERO, { ModifierKey.CONTROL }, function()
    reset()
end)

-- Apply the saved size as soon as the game's UI settings are available.
print("[SCMW] UI Scale v" .. MOD_VERSION .. " loaded")
apply_starting_scale()

LoopAsync(1000, function()
    apply_starting_scale()

    local now = current_scale()
    if now and now ~= last_seen then
        last_seen = now
        print(string.format("[SCMW] UI scale now %.2f", now))
    end
end)
