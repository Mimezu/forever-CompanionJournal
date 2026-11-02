-- Exercise the real shared picker behavior under native/missing widget APIs,
-- with gamepad UI enabled and both possible ancestor OnHide event orders.
local checks = 0
local function check(ok, message) checks = checks + 1; assert(ok, message) end
local function same(actual, expected)
    for i = 1, 3 do if math.abs(actual[i] - expected[i]) > .000001 then return false end end
    return true
end
for _, addon in ipairs({"CompanionJournal", "ForeverNames"}) do
    for _, widget in ipairs({"native", "missing", "unsupported"}) do
        for _, childFirst in ipairs({false, true}) do
            local M = {}; M.__index = M
            local function object(parent)
                local v = setmetatable({parent = parent, children = {}, scripts = {}, shown = true, enabled = true}, M)
                if parent then parent.children[#parent.children + 1] = v end
                return v
            end
            function M:GetParent() return self.parent end
            function M:SetParent(parent) self.parent = parent; parent.children[#parent.children + 1] = self end
            function M:IsShown() return self.shown end
            function M:IsVisible() return self.shown and (not self.parent or self.parent:IsVisible()) end
            function M:Show() self.shown = true end
            local function hiddenChildren(v)
                for _, child in ipairs(v.children) do
                    if child.shown then
                        if childFirst then hiddenChildren(child) end
                        if child.scripts.OnHide then child.scripts.OnHide(child) end
                        if not childFirst then hiddenChildren(child) end
                    end
                end
            end
            function M:Hide()
                if not self.shown then return end
                self.shown = false
                if childFirst then hiddenChildren(self) end
                if self.scripts.OnHide then self.scripts.OnHide(self) end
                if not childFirst then hiddenChildren(self) end
            end
            function M:SetShown(v) if v then self:Show() else self:Hide() end end
            function M:SetEnabled(v) self.enabled = v end
            function M:SetScript(k, v) self.scripts[k] = v end
            function M:GetFrameLevel() return 5 end
            function M:SetText(v) self.text = v end
            function M:SetColorTexture(...) self.color = {...} end
            function M:SetTexture(v) self.texture = v end
            function M:SetTexCoord(...) self.coords = {...} end
            function M:SetPoint(...) self.point = {...} end
            function M:ClearAllPoints() self.point = nil end
            function M:SetSize(w, h) self.width, self.height = w, h end
            function M:GetFontString() return self.label end
            function M:CreateTexture() return object(self) end
            function M:CreateFontString() return object(self) end
            function M:SetValue(v)
                self.value = v
                if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self, v) end
            end
            for _, name in ipairs({"SetFrameLevel", "SetFrameStrata", "EnableMouse", "SetBackdrop", "SetBackdropColor",
                "SetWidth", "SetHeight", "SetJustifyH", "SetAlpha", "SetTextColor", "SetVertexColor", "SetClampedToScreen",
                "SetMinMaxValues", "SetValueStep", "SetObeyStepOnDrag"}) do M[name] = function() end end
            function CreateFrame(kind, name, parent)
                if kind == "ColorSelect" and widget == "unsupported" then error("unsupported frame type") end
                local v = object(parent); v.label = object(v)
                if kind == "ColorSelect" and widget ~= "unsupported" then
                    if widget == "native" then
                        function v:GetColorRGB() return unpack(self.rgb) end
                    end
                    function v:SetColorRGB(r, g, b)
                        self.rgb = {r, g, b}
                        if self.scripts.OnColorSelect then self.scripts.OnColorSelect(self, r, g, b) end
                    end
                    function v:SetColorWheelTexture(t) self.wheelTexture = t end
                    function v:SetColorValueTexture(t) self.valueTexture = t end
                    function v:SetColorWheelThumbTexture(asset) check(type(asset) == "string", "thumb setter takes a texture asset"); self.wheelThumb = object(self) end
                    function v:GetColorWheelThumbTexture() return self.wheelThumb end
                    function v:SetColorValueThumbTexture(asset) check(type(asset) == "string", "thumb setter takes a texture asset"); self.valueThumb = object(self) end
                    function v:GetColorValueThumbTexture() return self.valueThumb end
                end
                if name then _G[name] = v end
                return v
            end
            UIParent = object(); UISpecialFrames = {}
            InputUtil = {IsGamepadUIEnabled = function() return true end}
            ColorPickerFrame = setmetatable({}, {__index = function() error("must not use Blizzard's protected color picker") end})
            local A = {glyphs = {}, glyphsReserved = {}}
            assert(loadfile("Interface/AddOns/" .. addon .. "/ColorPicker.lua"))(addon, A)
            local ownerA, ownerB = object(UIParent), object(UIParent)
            local anchorA, anchorB = object(object(ownerA)), object(ownerB)
            local value, original, applies, cancels = {.8, .2, .1}, {.8, .2, .1}, 0, 0
            local function apply(r, g, b) applies = applies + 1; value = {r, g, b} end
            local function cancel() cancels = cancels + 1; value = {unpack(original)} end
            local function open(anchor, modes)
                return A.PickColor(anchor or anchorA, value[1], value[2], value[3], apply, cancel, modes)
            end
            local function click(button) check(button.enabled, "picker action is enabled in gamepad UI"); button.scripts.OnClick(button) end
            local picker = open()
            check(picker:GetParent() == ownerA and applies == 0, "opening attaches to its window without applying")
            click(picker.swatches[7])
            local beforeWheel = {unpack(value)}
            click(picker.wheel)
            local wheel = picker.wheelPicker
            check(wheel:IsShown() and wheel:GetParent() == picker, "Wheel opens an addon-owned child")
            check((widget == "native") == (wheel.selector ~= nil), "unsupported/incomplete native APIs use working sliders")
            check(same(value, beforeWheel) and applies == 1, "wheel initialization does not apply")
            local function change(r, g, b)
                if wheel.selector then wheel.selector:SetColorRGB(r, g, b)
                else
                    wheel.sliders[1]:SetValue(r); wheel.sliders[2]:SetValue(g); wheel.sliders[3]:SetValue(b)
                end
            end
            change(.123, .456, .789)
            check(same(value, {.123, .456, .789}), "continuous color changes preview live")
            check(same(picker.preview.color, value), "main swatch follows wheel preview")
            click(wheel.cancelButton)
            check(same(value, beforeWheel) and picker:IsShown(), "wheel Cancel restores the pre-wheel color and leaves the palette open")
            click(picker.wheel); change(.21, .32, .43); wheel:Hide()
            check(same(value, beforeWheel), "wheel Escape/close restores the pre-wheel color")
            click(picker.wheel); change(.21, .32, .43); click(wheel.done)
            check(same(value, {.21, .32, .43}) and picker:IsShown(), "wheel Done retains the live preview within the popover")
            click(picker.cancelButton)
            check(same(value, original) and cancels == 1 and not wheel:IsShown(), "popover Cancel restores the original setting after wheel Done")
            picker = open(); click(picker.wheel); change(.31, .42, .53); click(picker.done)
            check(same(value, {.31, .42, .53}) and not wheel:IsShown() and cancels == 1, "popover Done commits an open wheel preview")
            original = {unpack(value)}
            picker = open(); click(picker.wheel); change(.44, .55, .66)
            picker = open(anchorB)
            check(same(value, original) and cancels == 2 and not wheel:IsShown(), "switching owner cancels both outstanding previews")
            check(picker:GetParent() == ownerB, "reused picker attaches to the new visible window")
            click(picker.wheel); change(.54, .65, .76); ownerB:Hide()
            check(same(value, original) and cancels == 3, "closing its window restores the original setting once")
            check(not picker:IsShown() and not wheel:IsShown() and not wheel.original, "closing its window clears nested wheel state")
            local settled = applies
            ownerB:Show(); picker = open(anchorB)
            check(applies == settled and wheel.original == nil, "reopening does not revive a stale wheel transaction")
            picker:Cancel()
            local mode, modeCalls
            picker = open(anchorA, {current = "custom", set = function(v) mode, modeCalls = v, (modeCalls or 0) + 1 end})
            click(picker.wheel); change(.2, .4, .6); click(wheel.done); click(picker.modeButtons[1])
            check(mode == "class" and modeCalls == 1 and not picker:IsShown() and not wheel:IsShown(), "dynamic color choice closes both pickers")
            picker = open(anchorA, {current = "class", set = function(v) mode = v end})
            click(picker.modeButtons[1])
            check(mode == "custom", "selected dynamic mode can return to custom color")
        end
    end
end
print("ColorPicker: " .. checks .. " checks passed")
