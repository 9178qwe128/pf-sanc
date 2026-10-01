--[[
    PY Hub 完整独立版
    包含：反作弊绕过 + 全功能 + UI
    依赖：WindUI（自动加载）、执行器 API
]]

-- ============================================================
-- 1. 环境 stub（占位被反混淆清空的检测函数）
-- ============================================================
do
    local stubFalse = function() return false end
    local stubNoop = function() end
    if type(fn12) ~= "function" then fn12 = stubFalse end
    if type(fn13) ~= "function" then fn13 = stubFalse end
    if type(fn17) ~= "function" then fn17 = function() return "{}" end end
    if type(fn14) ~= "function" then fn14 = function(p) return p end end
    if type(fn21) ~= "function" then fn21 = stubNoop end
    if type(fn22) ~= "function" then fn22 = stubNoop end
    if type(fn23) ~= "function" then fn23 = stubNoop end
    if type(fn24) ~= "function" then fn24 = function() return true, { Body = "{}" } end end
    if type(fn25) ~= "function" then fn25 = function() return true end end
    if type(fn19) ~= "function" then fn19 = function(s) return s end end
    if type(handlers) ~= "table" then handlers = {} end
    placeId = placeId or game.PlaceId
    jobId = jobId or game.JobId
    c = c or 0
    if type(cloneref) == "function" then
        local raw = cloneref
        cloneref = function(inst) if inst == nil then return nil end return raw(inst) end
    elseif cloneref == nil then
        cloneref = function(inst) return inst end
    end
end

-- ============================================================
-- 2. 服务与玩家
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local localPlayer3 = Players.LocalPlayer
if not localPlayer3 then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    localPlayer3 = Players.LocalPlayer
end

local localPlayer2 = localPlayer3

-- ============================================================
-- 3. 反作弊绕过
-- ============================================================

-- 3.1 打瘫游戏 AntiCheat 模块
pcall(function()
    local antiCheat = ReplicatedStorage:FindFirstChild("AntiCheat", true)
    if antiCheat and type(antiCheat) == "table" then
        for k, v in pairs(antiCheat) do
            if type(v) == "function" then
                antiCheat[k] = function(...)
                    local ok, result = pcall(v, ...)
                    if ok then return result end
                    return true
                end
            end
        end
    end
end)

-- 3.2 伪造 Ratchet 序列响应
pcall(function()
    local Ratchet = require(ReplicatedStorage:FindFirstChild("Ratchet", true))
    local Sha256 = require(ReplicatedStorage:FindFirstChild("Sha256", true))
    local mt = getmetatable(Ratchet)
    if mt and mt.__index and not mt.__index.__patched then
        mt.__index.catchUp = function(self, target)
            while self.index < target do self:advance() end
            return true
        end
        mt.__index.respond = function(self, arg)
            return Sha256("resp|" .. tostring(self.state) .. "|" .. tostring(self.index) .. "|" .. tostring(arg))
        end
        mt.__index.__patched = true
    end
end)

-- 3.3 隐藏敏感服务
if hookmetamethod and newcclosure then
    local oldIndex
    local function hookIndex(self, key)
        if self == game and (key == "GetService" or key == "getService") then
            return function(_, service)
                if service == "InsertService" or service == "Selection" or service == "Stats" then
                    return nil
                end
                return oldIndex(self, service)
            end
        end
        return oldIndex(self, key)
    end
    oldIndex = hookmetamethod(game, "__index", newcclosure(hookIndex))
end

-- 3.4 防踢 + 拦截敏感事件
if hookmetamethod and newcclosure and getnamecallmethod then
    local oldNamecall
    local function hookNamecall(self, ...)
        local packed = table.pack(...)
        local method = getnamecallmethod()

        if method == "Kick" and self == localPlayer2 then
            return
        end

        if method == "FireServer" and self.Name == "PlayerEvent" then
            local first = ({ ... })[1]
            if first == "char2" or first == "coreGame" or first == "vehicleTrack"
                or first == "platform" or first == "messageDeliver"
                or first == "runOverVictim" or first == "DEBUG2"
                or first == "chatCommand" or first == "controlsGuide" then
                return
            end
        end

        if method == "InvokeServer" and self.Name == "PlayerFunc" then
            local first = ({ ... })[1]
            if first == "getPlayerData" or first == "getPlayerBanHistory"
                or first == "getPlayerInGame" or first == "getPlayerServerEncounters"
                or first == "getSecret" then
                return true
            end
        end

        return oldNamecall(self, table.unpack(packed, 1, packed.n))
    end
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(hookNamecall))
end

-- ============================================================
-- 4. GUI 容器 fn61
-- ============================================================
local v29
local function fn61()
    local hui
    pcall(function()
        if type(gethui) == "function" then hui = gethui() end
    end)
    if hui then return hui end
    pcall(function() hui = game:FindService("CoreGui") end)
    if hui then return hui end
    pcall(function() hui = localPlayer3:WaitForChild("PlayerGui", 5) end)
    if hui then return hui end
    pcall(function() hui = localPlayer3:FindFirstChild("PlayerGui") end)
    return hui
end
v29 = fn61()

-- ============================================================
-- 5. Remote 获取
-- ============================================================
local remote = ReplicatedStorage:WaitForChild("Remote", 30)
local playerEvent = remote and remote:WaitForChild("PlayerEvent", 30)
local playerFunc = remote and remote:WaitForChild("PlayerFunc", 30)

-- 小地图光标兜底
local function ensureMinimapCursor(root)
    if not root then return end
    local minimap = root.Name == "Minimap" and root or root:FindFirstChild("Minimap", true)
    if not minimap or not minimap:IsA("Frame") or minimap:FindFirstChild("Cursor") then return end
    local cursor = Instance.new("ImageLabel")
    cursor.Name = "Cursor"
    cursor.BackgroundTransparency = 1
    cursor.ImageTransparency = 1
    cursor.AnchorPoint = Vector2.new(0.5, 0.5)
    cursor.Position = UDim2.fromScale(0.5, 0.5)
    cursor.Size = UDim2.fromOffset(10, 10)
    cursor.ZIndex = minimap.ZIndex + 1
    cursor.Parent = minimap
end
task.spawn(function()
    local pg = localPlayer3:FindFirstChild("PlayerGui") or localPlayer3:WaitForChild("PlayerGui", 10)
    ensureMinimapCursor(pg)
    if pg then
        pg.DescendantAdded:Connect(function(d)
            if d.Name == "Minimap" then task.defer(ensureMinimapCursor, d) end
        end)
    end
end)

-- ============================================================
-- 6. 颜色与工具
-- ============================================================
local tbl21 = {
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["黄色"] = Color3.fromRGB(255, 255, 0),
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["蓝色"] = Color3.fromRGB(0, 150, 255),
    ["紫色"] = Color3.fromRGB(150, 0, 255),
    ["白色"] = Color3.fromRGB(255, 255, 255),
    ["黑色"] = Color3.fromRGB(0, 0, 0),
    ["青色"] = Color3.fromRGB(0, 255, 255),
    ["橙色"] = Color3.fromRGB(255, 165, 0),
    ["粉色"] = Color3.fromRGB(255, 105, 180),
}

fn38 = function(n)
    n = n or 5
    return Color3.fromHSV(tick() % n / n, 1, 1)
end

fn39 = function(name)
    if name == "彩虹色" then return fn38(5) end
    return tbl21[name] or Color3.fromRGB(255, 0, 0)
end

fn40 = function(target)
    target = target or localPlayer3
    local seen, list = {}, {}
    local function add(model)
        if model and typeof(model) == "Instance" and model:IsA("Model") and not seen[model] then
            seen[model] = true
            table.insert(list, model)
        end
    end
    pcall(function() add(target.Character) end)
    pcall(function()
        local cf = Workspace:FindFirstChild("Characters")
        if cf then add(cf:FindFirstChild(target.Name)) end
    end)
    for _, character in ipairs(list) do
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:FindFirstChild("Humanoid", true)
        local hrp = character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("UpperTorso")
            or (humanoid and humanoid.RootPart)
        if not hrp then hrp = character.PrimaryPart or character:FindFirstChildWhichIsA("BasePart") end
        if hrp then return character, humanoid, hrp end
    end
end

fn62 = function(target)
    local _, hum = fn40(target)
    return hum ~= nil and hum.Health > 0
end

fn63 = function(target)
    return target and target.Team and target.Team.Name or "Civilian"
end

fn64 = function()
    local char, hum = fn40(localPlayer3)
    if not char or not hum then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return tool end
    local backpack = localPlayer3:FindFirstChild("Backpack")
    if not backpack then return end
    for _, child in ipairs(backpack:GetChildren()) do
        if child:IsA("Tool") then
            hum:EquipTool(child)
            task.wait(0.1)
            return char:FindFirstChildOfClass("Tool")
        end
    end
end

-- ============================================================
-- 7. 加载 WindUI
-- ============================================================
local lib
do
    if hookfunction and Font and Font.new then
        local fontNew = Font.new
        pcall(function()
            hookfunction(fontNew, function(family, weight, style)
                local ok, result = pcall(fontNew, family, weight, style)
                if ok then return result end
                weight = weight or Enum.FontWeight.Medium
                style = style or Enum.FontStyle.Normal
                ok, result = pcall(fontNew, Enum.Font.GothamMedium, weight, style)
                if ok then return result end
                return Font.fromEnum(Enum.Font.GothamMedium)
            end)
        end)
    end

    local ok, err = pcall(function()
        local src = game:HttpGet("https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/UI.lua")
        lib = loadstring(src)()
    end)
    if not ok or not lib then
        warn("[PY Hub] WindUI 加载失败: " .. tostring(err))
        return
    end
end

-- ============================================================
-- 8. 配置持久化
-- ============================================================
local tbl8 = {
    randomBg = true, borderColor = nil,
    isBorderRainbow = true, borderEnabled = false,
}

pcall(function()
    local ok, content = pcall(function() return readfile("PYHub_Settings.txt") end)
    if ok and content then
        local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok2 and type(data) == "table" then
            for k, v in pairs(data) do tbl8[k] = v end
        end
    end
end)

local function saveSettings()
    pcall(function()
        writefile("PYHub_Settings.txt", HttpService:JSONEncode(tbl8))
    end)
end

local tbl22 = {
    "https://raw.githubusercontent.com/PYHub/assets/main/bg.jpg",
    "https://raw.githubusercontent.com/PYHub/assets/main/bg.jpg",
    "https://raw.githubusercontent.com/PYHub/assets/main/bg.jpg",
    "https://raw.githubusercontent.com/PYHub/assets/main/bg.jpg",
    "https://raw.githubusercontent.com/PYHub/assets/main/bg.jpg",
}
local fn42 = function()
    if not tbl8.randomBg or #tbl22 == 0 then return "" end
    return tbl22[math.random(1, #tbl22)]
end

-- ============================================================
-- 9. 边框 fn43
-- ============================================================
local v27, v28, connection, connection2, flag8, flag9, flag10, textButton

local fn43 = function(color, isRainbow)
    local main = v27 and v27.UIElements and v27.UIElements.Main
    if not main then return end
    local mainBorder = main:FindFirstChild("MainBorder")
    if not mainBorder then return end
    local grad = mainBorder:FindFirstChild("BorderGradient")
    if not grad then return end
    mainBorder.Enabled = tbl8.borderEnabled
    if connection2 then connection2:Disconnect(); connection2 = nil end
    if isRainbow then
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
            ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
            ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
            ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
            ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE")),
        })
        connection2 = RunService.Heartbeat:Connect(function()
            if grad.Parent then grad.Rotation = (grad.Rotation + 1.5) % 360 end
        end)
        tbl8.isBorderRainbow = true
    else
        color = color or Color3.new(1, 1, 1)
        mainBorder.Color = color
        grad.Color = ColorSequence.new(color)
        grad.Rotation = 0
        tbl8.isBorderRainbow = false
    end
end

-- ============================================================
-- 10. 状态表
-- ============================================================
local Settings = {
    stamina = false, food = false, combatBlock = false, ghost = false,
    noRagdoll = false, noFallDamage = false, antiPrisonPull = false,
    autoMoney = false, infiniteAmmo = false, rapidFire = false,
    farmer = false, taxi = false, bus = false, autoMission = false,
    autoHack = false, golf = false, autoCuff = false,
}

-- Framework 引用
local Character, Core, module
pcall(function()
    local framework = localPlayer3:WaitForChild("PlayerScripts", 15):WaitForChild("Framework", 15)
    Character = require(framework:WaitForChild("Character", 15))
    Core = require(framework:WaitForChild("Core", 15))
    local inventory = framework.Character:FindFirstChild("Inventory")
    if inventory then module = require(inventory) end
end)

-- ============================================================
-- 11. 主要功能
-- ============================================================

-- 11.1 无限体力/饥饿 + 无限子弹 + 快速射击
fn66 = function()
    RunService.Heartbeat:Connect(function()
        if Core then
            if Settings.stamina then pcall(function() Core.stamina = 100 end) end
            if Settings.food then pcall(function() Core.food = 100 end) end
            if Settings.rapidFire then pcall(fn44) end
        end

        if Settings.infiniteAmmo then
            local folder = Workspace:FindFirstChild("Characters")
            local me = folder and folder:FindFirstChild(localPlayer3.Name)
            if me then
                for _, child in ipairs(me:GetChildren()) do
                    local config = child:FindFirstChild("Config")
                    if config then
                        local ammo = config:FindFirstChild("Ammo")
                        local totalAmmo = config:FindFirstChild("TotalAmmo")
                        if ammo then ammo.Value = math.huge end
                        if totalAmmo then totalAmmo.Value = math.huge end
                    end
                end
            end
        end
    end)
end

fn44 = function()
    if not Settings.rapidFire or not getgc then return end
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            if rawget(v, "SHOOT_MODE") ~= nil then rawset(v, "SHOOT_MODE", 2) end
            if rawget(v, "RPM") ~= nil then rawset(v, "RPM", math.huge) end
        end
    end
end

-- 11.2 战斗拦截
local v30
fn45 = function(enable)
    Settings.combatBlock = enable
    if enable and not v30 and hookmetamethod and newcclosure then
        v30 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local packed = table.pack(...)
            local args = { ... }
            local method = getnamecallmethod()
            if Settings.combatBlock and method == "FireServer" and args[1] == "combatMode" then
                return nil
            end
            return v30(self, table.unpack(packed, 1, packed.n))
        end))
    end
end

-- 11.3 隐身
local connection3, flagGhost
fn46 = function(enable)
    Settings.ghost = enable
    local character = localPlayer3.Character
    if not character then return end

    if enable then
        pcall(function()
            local stuff = ReplicatedStorage:FindFirstChild("Stuff")
            local locations = stuff and stuff:FindFirstChild("Locations")
            locations = locations and locations:GetChildren()[1] or nil
            if playerFunc then playerFunc:InvokeServer("hideCharacterLocation", locations) end
        end)
        if module and module.canEquipSlot then
            pcall(function() module.canEquipSlot(true) end)
        end
        if Character and Character.lockHumanoidState then
            pcall(function() Character.lockHumanoidState("ghostMode", nil) end)
        end
        pcall(function()
            GuiService.TouchControlsEnabled = true
            ContextActionService:UnbindAction("LoadingGuiNoResetOnDeath")
            ContextActionService:UnbindAction("DisableCameraMovementNoResetOnDeath")
        end)
        if connection3 then connection3:Disconnect() end
        connection3 = RunService.RenderStepped:Connect(function() end)
    else
        if connection3 then connection3:Disconnect(); connection3 = nil end
        pcall(function()
            if playerFunc then playerFunc:InvokeServer("hideCharacterLocation", false) end
        end)
    end
end

-- 11.4 防布娃娃
pcall(function()
    local Ragdoll = require(ReplicatedStorage.Modules.Ragdoll)
    local activate = Ragdoll.activate
    local activateServer = Ragdoll.activateServer
    Ragdoll.activate = function(a, b, c2, ...)
        if Settings.noRagdoll and b then return end
        local packed = table.pack(...)
        packed.n = 4 + packed.n - 1
        table.move(packed, 1, packed.n, 4, packed)
        packed[1] = a; packed[2] = b; packed[3] = c2
        return activate(table.unpack(packed, 1, packed.n))
    end
    if activateServer then
        Ragdoll.activateServer = function(a, b, c2, ...)
            if Settings.noRagdoll and b then return end
            local packed = table.pack(...)
            packed.n = 4 + packed.n - 1
            table.move(packed, 1, packed.n, 4, packed)
            packed[1] = a; packed[2] = b; packed[3] = c2
            return activateServer(table.unpack(packed, 1, packed.n))
        end
    end
end)

-- 11.5 防摔伤
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local packed = table.pack(...)
        local args = { ... }
        local method = getnamecallmethod()
        if Settings.noFallDamage and method == "FireServer"
            and tostring(self) == "PlayerEvent" and args[1] == "takeDamage" then
            return nil
        end
        return oldNamecall(self, table.unpack(packed, 1, packed.n))
    end)
    setreadonly(mt, true)
end)

-- 11.6 防越狱拉回
local charPivotTo, notify
fn49 = function(enable)
    Settings.antiPrisonPull = enable
    pcall(function()
        local Algorithms = require(ReplicatedStorage.Modules.Algorithms)
        if enable and not charPivotTo then
            charPivotTo = Algorithms.charPivotTo
            Algorithms.charPivotTo = function() return nil end
        elseif not enable and charPivotTo then
            Algorithms.charPivotTo = charPivotTo
            charPivotTo = nil
        end
    end)
    pcall(function()
        if not Core then return end
        if enable and not notify then
            notify = Core.notify
            Core.notify = function(arg)
                if arg and arg.message and string.find(arg.message, "You can't leave prison yet") then
                    return nil
                end
                return notify(arg)
            end
        elseif not enable and notify then
            Core.notify = notify
            notify = nil
        end
    end)
end

-- ============================================================
-- 12. 传送与交互工具
-- ============================================================
fn70 = function(inst)
    if not inst or not inst.Parent then return end
    local parent = inst.Parent
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Attachment") then return parent.WorldPosition end
    if parent:IsA("Model") then
        local primary = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
        if primary then return primary.Position end
    end
end

fn71 = function(prompt)
    if not prompt then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end
    end)
end

fn72 = function(position)
    local char, _, hrp = fn40(localPlayer3)
    if not char or not hrp or not position then return end
    local cf = CFrame.new(position + Vector3.new(0, 3, 0))
    char:PivotTo(cf)
    pcall(function()
        if playerEvent then
            local n = ((char:GetAttribute("CharPivotToId") or 0) + 1) % 100
            char:SetAttribute("CharPivotToId", n)
            playerEvent:FireServer("charPivotTo", cf, char, n)
        end
    end)
end

-- ============================================================
-- 13. 自动捡钱
-- ============================================================
fn73 = function()
    task.spawn(function()
        while true do
            if Settings.autoMoney then
                local _, _, hrp = fn40(localPlayer3)
                if hrp then
                    local bestDist, bestPrompt
                    for _, d in ipairs(Workspace:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then
                            local name = d.Name
                            local action = string.lower(tostring(d.ActionText or ""))
                            local obj = string.lower(tostring(d.ObjectText or ""))
                            local match = name == "CashDrop" or name == "GetItem" or name == "Money"
                                or action:find("pick", 1, true) or action:find("cash", 1, true)
                                or action:find("collect", 1, true) or action:find("grab", 1, true)
                                or obj:find("cash", 1, true) or obj:find("money", 1, true)
                            if match then
                                local pos = fn70(d)
                                if pos then
                                    local dist = (hrp.Position - pos).Magnitude
                                    if not bestDist or dist < bestDist then
                                        bestDist = dist
                                        bestPrompt = d
                                    end
                                end
                            end
                        end
                    end
                    if bestPrompt and bestDist and bestDist < 120 then
                        if bestDist > 8 then
                            fn72(fn70(bestPrompt))
                            task.wait(0.3)
                        end
                        fn71(bestPrompt)
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- 14. 自动任务
-- ============================================================
local tbl10 = {
    missionInterval = 2, priorityHighReward = false,
    taxiSafe = false, taxiDelayMode = "随机时间", taxiOrigin = nil,
}

fn74 = function()
    if not getgc then return end
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "teamJobs") then
            return v.teamJobs
        end
    end
end

fn75 = function()
    if localPlayer3:GetAttribute("Mission") then return true end
    local jobs = fn74()
    if jobs then
        for _, j in pairs(jobs) do
            if j.joined then return true end
        end
    end
    return false
end

fn76 = function()
    local jobs = fn74()
    if not jobs then return end
    local best, bestId = -math.huge, nil
    for id, job in pairs(jobs) do
        if not job.joined then
            if not tbl10.priorityHighReward then return id end
            local score = (job.profitability or 1) * 1000000 + (job.reward or 0)
            if best < score then best = score; bestId = id end
        end
    end
    return bestId
end

fn77 = function()
    task.spawn(function()
        while true do
            if Settings.autoMission and playerFunc and not fn75() then
                local id = fn76()
                if id then
                    pcall(function()
                        playerFunc:InvokeServer("talkToMission", tostring(id) .. "join")
                    end)
                end
            end
            task.wait(tbl10.missionInterval)
        end
    end)
end

-- ============================================================
-- 15. 农民刷钱
-- ============================================================
fn79 = function()
    task.spawn(function()
        while true do
            if Settings.farmer then
                local char = localPlayer3.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then task.wait(0.4) end
                local _, _, hrp = fn40(localPlayer3)
                if hrp then
                    local bestDist, bestPrompt
                    for _, d in ipairs(Workspace:GetDescendants()) do
                        if d:IsA("ProximityPrompt") and d.ActionText == "Pick Up" then
                            local pos = fn70(d)
                            if pos then
                                local dist = (hrp.Position - pos).Magnitude
                                if not bestDist or dist < bestDist then
                                    bestDist = dist
                                    bestPrompt = d
                                end
                            end
                        end
                    end
                    if bestPrompt then
                        local pos = fn70(bestPrompt)
                        if pos then
                            local dist = (hrp.Position - pos).Magnitude
                            if dist > 8 then
                                fn72(pos)
                                task.wait(0.3)
                            else
                                fn71(bestPrompt)
                            end
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- 16. 出租车刷钱
-- ============================================================
fn80 = function()
    task.spawn(function()
        local lastPos = nil
        while true do
            if Settings.taxi then
                local gameplay = Workspace:FindFirstChild("Gameplay")
                gameplay = gameplay and gameplay:FindFirstChild("Entities")
                gameplay = gameplay and gameplay:FindFirstChild("ClientContent")
                if gameplay and gameplay:IsA("Model") then
                    local primary = gameplay.PrimaryPart or gameplay:FindFirstChildWhichIsA("BasePart")
                    local _, _, hrp = fn40(localPlayer3)
                    if primary and hrp then
                        local pos = primary.Position
                        if lastPos == nil or (pos - lastPos).Magnitude > 5 then
                            if tbl10.taxiSafe and tbl10.taxiOrigin then
                                hrp.CFrame = CFrame.new(tbl10.taxiOrigin)
                                local dist = (tbl10.taxiOrigin - pos).Magnitude
                                local delay
                                if tbl10.taxiDelayMode == "距离测算" then
                                    delay = math.clamp(15 + (math.clamp(dist, 2000, 6000) - 2000) / 4000 * 30 + math.random() * 2 - 1, 15, 45)
                                else
                                    delay = dist > 2000 and math.random(15, 45) or 15
                                end
                                task.wait(delay)
                            end
                            hrp.CFrame = CFrame.new(pos)
                            lastPos = pos
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ============================================================
-- 17. 公交车刷钱
-- ============================================================
fn81 = function()
    local gameplay = Workspace:FindFirstChild("Gameplay")
    gameplay = gameplay and gameplay:FindFirstChild("Entities")
    gameplay = gameplay and gameplay:FindFirstChild("ClientContent")
    gameplay = gameplay and gameplay:GetChildren()[1]
    return gameplay and gameplay:FindFirstChild("Area")
end

fn82 = function()
    task.spawn(function()
        while true do
            if Settings.bus then
                local area = fn81()
                local _, hum, hrp = fn40(localPlayer3)
                if area and hum and hrp then
                    local seat = hum.SeatPart
                    if seat then
                        seat.CFrame = area.CFrame * CFrame.new(17.5, 3, 6.5)
                            * CFrame.Angles(0, 4.7123889803846897, 0)
                            * hrp.CFrame:ToObjectSpace(seat.CFrame)
                        seat.AssemblyLinearVelocity = Vector3.zero
                        seat.AssemblyAngularVelocity = Vector3.zero
                        task.wait(0.1)
                        hum.Sit = false
                    else
                        hrp.CFrame = area.CFrame * CFrame.new(17.5, 3, 6.5)
                            * CFrame.Angles(0, 4.7123889803846897, 0)
                    end
                    task.wait(5)
                end
            end
            task.wait(1)
        end
    end)
end

-- ============================================================
-- 18. 自动黑客小游戏
-- ============================================================
local tbl24 = {}
fn50 = function(enable)
    Settings.autoHack = enable
    pcall(function()
        local framework = localPlayer3.PlayerScripts:FindFirstChild("Framework")
        framework = framework and require(framework:FindFirstChild("Character"))
        local GameRules = require(ReplicatedStorage.Modules.GameRules)
        if GameRules then
            GameRules.disableHacking = enable
            GameRules.disableMinigames = enable
        end
        if framework then
            if not tbl24.hackingMinigame then tbl24.hackingMinigame = framework.hackingMinigame end
            if not tbl24.startMinigame then tbl24.startMinigame = framework.startMinigame end
            if enable then
                framework.hackingMinigame = function() return true end
                framework.startMinigame = function() return true end
            else
                if tbl24.hackingMinigame then framework.hackingMinigame = tbl24.hackingMinigame end
                if tbl24.startMinigame then framework.startMinigame = tbl24.startMinigame end
            end
        end
    end)
end

-- ============================================================
-- 19. 高尔夫刷钱
-- ============================================================
fn83 = function()
    task.spawn(function()
        local function findPath(path)
            local cur = Workspace
            for _, name in ipairs(path) do
                cur = cur and cur:FindFirstChild(name)
                if not cur then return end
            end
            return cur
        end
        while true do
            if Settings.golf and playerFunc then
                pcall(function()
                    playerFunc:InvokeServer("miniGolf", "createLobby")
                    task.wait(0.1)
                    playerFunc:InvokeServer("miniGolf", "setLobbyBid", { bid = 500 })
                    task.wait(0.1)
                    playerFunc:InvokeServer("miniGolf", "setLobbyReady")
                    task.wait(4)
                    playerFunc:InvokeServer("miniGolf", "shot")
                    task.wait(0.5)
                    local ball = findPath({ "Gameplay", "Entities", "Content", localPlayer3.Name })
                    local flag = findPath({ "Gameplay", "Entities", "Content", "_Flag", "FlagPole", "Part" })
                    if ball and flag and ball:IsA("BasePart") then
                        ball.Position = flag.Position
                    end
                end)
            end
            task.wait(Settings.golf and 5 or 1)
        end
    end)
end

-- ============================================================
-- 20. 杀戮光环 + 子弹追踪
-- ============================================================
local tbl11 = {
    auraEnabled = false, auraRange = 50, auraDamage = 5, auraInterval = 0.05,
    auraOnlyPolice = false, auraOnlyCivilian = false, auraCombatCheck = false,
    bulletEnabled = false, bulletFov = 360, bulletDistance = 300,
    bulletPart = "Head", bulletShowFov = true, bulletColor = "红色",
}

fn84 = function(player, onlyPolice, onlyCivilian)
    if not player or player == localPlayer3 then return false end
    if onlyPolice then return player.Team and player.Team.Name == "Police" end
    if onlyCivilian then return player.Team and player.Team.Name == "Civilian" end
    return true
end

fn85 = function(player, check)
    if not check then return true end
    return player:GetAttribute("CombatMode") == true or player:GetAttribute("Pursuit") == true
end

local n10 = 0
RunService.Heartbeat:Connect(function()
    if not tbl11.auraEnabled or not playerEvent then return end
    local now = tick()
    if now - n10 < tbl11.auraInterval then return end
    local _, _, hrp = fn40(localPlayer3)
    if not hrp then return end
    local bestPlayer, bestDist
    for _, player in ipairs(Players:GetPlayers()) do
        if fn84(player, tbl11.auraOnlyPolice, tbl11.auraOnlyCivilian)
            and fn62(player) and fn85(player, tbl11.auraCombatCheck) then
            local char = player.Character
            local target = char and fn87(char)
            if target then
                local dist = (target.Position - hrp.Position).Magnitude
                if dist <= tbl11.auraRange and (not bestDist or dist < bestDist) then
                    bestPlayer = player; bestDist = dist
                end
            end
        end
    end
    if bestPlayer then
        local char = bestPlayer.Character
        local target = char and fn87(char)
        if not target then return end
        local pos = hrp.Position
        pcall(function()
            playerEvent:FireServer("damage", {
                bodyParts = { { "Head", 1 } },
                shotCode = { pos, (target.Position - pos).Unit },
                pos = target.Position,
                target = bestPlayer,
                damageFactor = tbl11.auraDamage,
                bulletProofTool = false,
            })
        end)
        n10 = now
    end
end)

-- 子弹追踪 Drawing
local circle = Drawing.new("Circle")
circle.Filled = false
circle.NumSides = 64
circle.Visible = false

local fn86 = function()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local bestFov = tbl11.bulletFov
    local bestPos
    for _, player in ipairs(Players:GetPlayers()) do
        if fn84(player, tbl11.bulletOnlyPolice, tbl11.bulletOnlyCivilian)
            and fn62(player) and fn85(player, tbl11.bulletCombatCheck) then
            local char = player.Character
            if char then
                char = char:FindFirstChild(tbl11.bulletPart) or char:FindFirstChild("HumanoidRootPart")
            end
            if char then
                if (char.Position - cam.CFrame.Position).Magnitude <= tbl11.bulletDistance then
                    local sp, vis = cam:WorldToScreenPoint(char.Position)
                    if vis and sp.Z > 0 then
                        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if dist < bestFov then
                            bestPos = char.Position
                            bestFov = dist
                        end
                    end
                end
            end
        end
    end
    return bestPos
end

pcall(function()
    local raycast = Workspace.Raycast
    hookfunction(Workspace.Raycast, function(self, origin, direction, params)
        if tbl11.bulletEnabled and origin and direction then
            local _, _, hrp = fn40(localPlayer3)
            if hrp and (origin - hrp.Position).Magnitude < 15 then
                local target = fn86()
                if target then direction = (target - origin).Unit * direction.Magnitude end
            end
        end
        return raycast(self, origin, direction, params)
    end)
end)

RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    circle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    circle.Radius = tbl11.bulletFov
    circle.Thickness = 2
    circle.Color = fn38(5)
    circle.Visible = tbl11.bulletEnabled and tbl11.bulletShowFov
end)

-- ============================================================
-- 21. 自瞄
-- ============================================================
local tbl12 = {
    enabled = false, prediction = false, teamCheck = false, wallCheck = false,
    showFov = false, showCrosshair = false, showTracer = false, friendCheck = false,
    onlyPolice = false, onlyCivilian = false, combatCheck = false,
    fov = 50, smoothness = 1, targetMode = "准心最近", targetPart = "头",
    color = "红色", fovThickness = 2,
}

local circle2 = Drawing.new("Circle")
circle2.Filled = false
circle2.NumSides = 64
local line = Drawing.new("Line")

local crossParts = {
    Top = Drawing.new("Line"), Bottom = Drawing.new("Line"),
    Left = Drawing.new("Line"), Right = Drawing.new("Line"), Center = Drawing.new("Line"),
}
for _, v in pairs(crossParts) do v.Thickness = 2; v.Visible = false end

local tbl26 = {
    ["头"] = { "Head" }, ["胸"] = { "UpperTorso", "Torso" },
    ["左手"] = { "LeftHand", "Left Arm" }, ["右手"] = { "RightHand", "Right Arm" },
    ["左腿"] = { "LeftFoot", "Left Leg" }, ["右腿"] = { "RightFoot", "Right Leg" },
}

fn87 = function(char)
    local list = tbl26[tbl12.targetPart] or { "Head" }
    for _, name in ipairs(list) do
        local p = char:FindFirstChild(name)
        if p then return p end
    end
    return char:FindFirstChild("HumanoidRootPart")
end

fn88 = function(part)
    if not tbl12.wallCheck then return true end
    local cam = Workspace.CurrentCamera
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { localPlayer3.Character, cam }
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local hit = Workspace:Raycast(cam.CFrame.Position, part.Position - cam.CFrame.Position, params)
    return not hit or hit.Instance:IsDescendantOf(part.Parent)
end

fn89 = function()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local bestScore, bestTarget
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer3 and fn62(player)
            and fn84(player, tbl12.onlyPolice, tbl12.onlyCivilian)
            and fn85(player, tbl12.combatCheck) then
            if not (tbl12.teamCheck and localPlayer3.Team and player.Team == localPlayer3.Team) then
                local skip = false
                if tbl12.friendCheck then
                    local ok, isFriend = pcall(function() return localPlayer3:IsFriendsWith(player.UserId) end)
                    if ok and isFriend then skip = true end
                end
                if not skip then
                    local char = player.Character
                    if char then
                        local part = fn87(char)
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                            or char:FindFirstChild("Torso")
                            or char:FindFirstChild("UpperTorso")
                        if part and hum and hrp and hum.Health > 0 and fn88(part) then
                            local sp, vis = cam:WorldToViewportPoint(part.Position)
                            if vis then
                                local score = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                if score <= tbl12.fov then
                                    if tbl12.targetMode == "距离最近" then
                                        local _, _, myHrp = fn40(localPlayer3)
                                        score = myHrp and (myHrp.Position - hrp.Position).Magnitude or math.huge
                                    elseif tbl12.targetMode == "血量最低" then
                                        score = hum.Health
                                    end
                                    if not bestScore or score < bestScore then
                                        bestTarget = { player = player, part = part, screen = sp }
                                        bestScore = score
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.RenderStepped:Connect(function(dt)
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local color = fn39(tbl12.color)
    circle2.Position = center
    circle2.Radius = tbl12.fov
    circle2.Thickness = tbl12.fovThickness
    circle2.Color = color
    circle2.Visible = tbl12.enabled and tbl12.showFov

    crossParts.Top.From = Vector2.new(center.X, center.Y - 5)
    crossParts.Top.To = Vector2.new(center.X, center.Y - 20)
    crossParts.Bottom.From = Vector2.new(center.X, center.Y + 5)
    crossParts.Bottom.To = Vector2.new(center.X, center.Y + 20)
    crossParts.Left.From = Vector2.new(center.X - 5, center.Y)
    crossParts.Left.To = Vector2.new(center.X - 20, center.Y)
    crossParts.Right.From = Vector2.new(center.X + 5, center.Y)
    crossParts.Right.To = Vector2.new(center.X + 20, center.Y)
    crossParts.Center.From = Vector2.new(center.X - 2, center.Y)
    crossParts.Center.To = Vector2.new(center.X + 2, center.Y)
    for _, v in pairs(crossParts) do
        v.Color = color
        v.Visible = tbl12.showCrosshair
    end

    line.Visible = false
    if tbl12.enabled then
        local target = fn89()
        if target then
            if tbl12.showTracer then
                line.From = center
                line.To = Vector2.new(target.screen.X, target.screen.Y)
                line.Color = color
                line.Thickness = 2
                line.Transparency = 0.5
                line.Visible = true
            end
            local pos = target.part.Position
            if tbl12.prediction then
                pos = pos + target.part.AssemblyLinearVelocity * dt * 1.5
            end
            local cf = CFrame.new(cam.CFrame.Position, pos)
            cam.CFrame = tbl12.smoothness >= 1 and cf or cam.CFrame:Lerp(cf, tbl12.smoothness)
        end
    end
end)

-- ============================================================
-- 22. Ragebot
-- ============================================================
local tbl13 = {
    enabled = false, range = 150, interval = 0.05, bodyPart = "Head",
    jobCheck = false, wallCheck = false, aliveCheck = false,
    combatCheck = false, policeLock = false, civilianLock = false, beam = false,
}

task.spawn(function()
    while true do
        if tbl13.enabled and playerEvent then
            local _, _, hrp = fn40(localPlayer3)
            if hrp then
                local pos = hrp.Position
                local myJob = fn63(localPlayer3)
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer3 and fn84(player, tbl13.policeLock, tbl13.civilianLock)
                        and fn85(player, tbl13.combatCheck) then
                        local char, hum = fn40(player)
                        local part = char and (char:FindFirstChild(tbl13.bodyPart) or fn87(char))
                        if char and hum and part and hum.Health > 0 then
                            if not (tbl13.jobCheck and fn63(player) == myJob) then
                                if (part.Position - pos).Magnitude <= tbl13.range then
                                    local blocked = false
                                    if tbl13.wallCheck then
                                        local params = RaycastParams.new()
                                        params.FilterDescendantsInstances = { localPlayer3.Character, Workspace.CurrentCamera }
                                        params.FilterType = Enum.RaycastFilterType.Exclude
                                        local hit = Workspace:Raycast(Workspace.CurrentCamera.CFrame.Position,
                                            part.Position - Workspace.CurrentCamera.CFrame.Position, params)
                                        if hit and not hit.Instance:IsDescendantOf(char) then blocked = true end
                                    end
                                    if not blocked then
                                        pcall(function()
                                            playerEvent:FireServer("damage", {
                                                bodyParts = { { tbl13.bodyPart, 1 } },
                                                shotCode = { pos, (part.Position - pos).Unit },
                                                pos = part.Position,
                                                target = player,
                                                damageFactor = 1.5,
                                                bulletProofTool = false,
                                            })
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(tbl13.interval)
    end
end)

-- ============================================================
-- 23. 范围修改
-- ============================================================
local tbl15 = {
    active = false, size = 10, transparency = 0.7, teamCheck = false,
    color = "红色", material = "Neon", rainbow = false,
    checkCorpses = false, outline = false, collision = false,
    glow = false, pulse = false, affectNPC = false,
}
local tbl27 = {}

fn91 = function(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not tbl27[hrp] then
        tbl27[hrp] = {
            Size = hrp.Size, Transparency = hrp.Transparency,
            Material = hrp.Material, CanCollide = hrp.CanCollide, Color = hrp.Color,
        }
    end
    if not tbl15.active then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if tbl15.checkCorpses and hum and hum.Health <= 0 then return end
    local size = tbl15.size
    if tbl15.pulse then size = size * (math.sin(tick() * 2) * 0.2 + 1) end
    hrp.Size = Vector3.new(size, size, size)
    hrp.Transparency = tbl15.transparency
    hrp.Material = Enum.Material[tbl15.material] or Enum.Material.Neon
    hrp.CanCollide = tbl15.collision
    hrp.Color = tbl15.rainbow and fn38(5) or fn39(tbl15.color)
    if tbl15.outline then
        local hl = hrp:FindFirstChild("PY_HitboxHighlight") or Instance.new("Highlight")
        hl.Name = "PY_HitboxHighlight"
        hl.FillTransparency = 1
        hl.OutlineColor = hrp.Color
        hl.OutlineTransparency = tbl15.transparency
        hl.Parent = hrp
    else
        local hl = hrp:FindFirstChild("PY_HitboxHighlight")
        if hl then hl:Destroy() end
    end
    if tbl15.glow then
        local light = hrp:FindFirstChild("PY_HitboxLight") or Instance.new("PointLight")
        light.Name = "PY_HitboxLight"
        light.Brightness = 5
        light.Range = 15
        light.Color = hrp.Color
        light.Parent = hrp
    else
        local light = hrp:FindFirstChild("PY_HitboxLight")
        if light then light:Destroy() end
    end
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer3 and fn40(player) then
            if tbl15.teamCheck and localPlayer3.Team and player.Team == localPlayer3.Team then
                continue
            end
            fn91(fn40(player))
        end
    end
    if tbl15.affectNPC then
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("Model") and d:FindFirstChildOfClass("Humanoid")
                and not Players:GetPlayerFromCharacter(d) then
                fn91(d)
            end
        end
    end
end)

-- ============================================================
-- 24. ESP
-- ============================================================
local tbl16 = {
    enabled = false, name = true, distance = true, health = true,
    highlight = true, tracer = false, tracerOrigin = "屏幕底部",
    showFugitive = true,
    selectedTeams = {
        Chef = true, Civilian = true, Delivery = true, Farmer = true,
        Fire = true, Police = true, Medical = true, Prisoner = true,
        ["Road Service"] = true, Transit = true,
    },
    trackers = {},
}

local tbl17 = {
    Chef = "厨师", Civilian = "平民", Delivery = "配送员", Farmer = "农民",
    Fire = "消防员", Police = "警察", Medical = "医护人员",
    Prisoner = "囚犯", ["Road Service"] = "道路服务", Transit = "交通",
}

local tbl28 = {
    Chef = Color3.fromRGB(255, 200, 0), Civilian = Color3.fromRGB(100, 200, 255),
    Delivery = Color3.fromRGB(255, 150, 50), Farmer = Color3.fromRGB(50, 200, 50),
    Fire = Color3.fromRGB(255, 50, 50), Police = Color3.fromRGB(50, 100, 255),
    Medical = Color3.fromRGB(255, 50, 255), Prisoner = Color3.fromRGB(255, 150, 150),
    ["Road Service"] = Color3.fromRGB(255, 255, 100), Transit = Color3.fromRGB(100, 255, 255),
}

fn92 = function(player)
    local isCivilian = player.Team and player.Team.Name == "Civilian"
    if isCivilian then
        return player:GetAttribute("CombatMode") or player:GetAttribute("Pursuit")
    end
    return isCivilian
end

fn93 = function(player)
    if not tbl16.enabled or player == localPlayer3 then return false end
    if not fn40(player) then return false end
    if tbl16.showFugitive and fn92(player) then return true end
    local selected, total = 0, 0
    for _, v in pairs(tbl16.selectedTeams) do
        total = total + 1
        if v then selected = selected + 1 end
    end
    if selected == 0 or selected >= total then return true end
    local name = player.Team and player.Team.Name
    if not name then return true end
    if tbl16.selectedTeams[name] == true then return true end
    for teamName, label in pairs(tbl17) do
        if (label == name or teamName == name) and tbl16.selectedTeams[teamName] then
            return true
        end
    end
    return false
end

fn52 = function(player)
    local t = tbl16.trackers[player]
    if not t then return end
    for _, obj in pairs(t) do
        pcall(function()
            if typeof(obj) == "RBXScriptConnection" then obj:Disconnect()
            elseif typeof(obj) == "Instance" then obj:Destroy()
            elseif type(obj) == "userdata" and obj.Remove then obj:Remove() end
        end)
    end
    tbl16.trackers[player] = nil
end

local espHolder
local function getEspHolder()
    local parent = v29 or fn61() or localPlayer3:FindFirstChild("PlayerGui")
    v29 = parent
    if not parent then return end
    if espHolder and espHolder.Parent then return espHolder end
    local ok, gui = pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "PYHubESP"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = parent
        return sg
    end)
    if ok then espHolder = gui; return gui end
    return parent
end

fn94 = function(player)
    if tbl16.trackers[player] or not fn93(player) then return end
    local char, _, hrp = fn40(player)
    if not char or not hrp then return end
    local holder = getEspHolder()
    if not holder then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "PlayerESP_" .. player.Name
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(8, 0, 3, 0)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.MaxDistance = 10000
    bill.Adornee = hrp
    bill.Parent = holder

    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.fromScale(1, 1)
    frame.Parent = bill

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.55, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = player.Name
    nameLabel.Parent = frame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.45, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.55, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.TextStrokeTransparency = 0
    infoLabel.Parent = frame

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP_Highlight"
    highlight.Adornee = char
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    pcall(function() highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
    highlight.Parent = char

    local tracerLine
    pcall(function()
        if Drawing and Drawing.new then
            tracerLine = Drawing.new("Line")
            tracerLine.Thickness = 1
            tracerLine.Transparency = 0.5
            tracerLine.Visible = false
        end
    end)

    tbl16.trackers[player] = {
        bill = bill, highlight = highlight, tracer = tracerLine,
        update = RunService.Heartbeat:Connect(function()
            local cChar, hum, cHrp = fn40(player)
            if not fn93(player) or not cChar or not cHrp then
                if tracerLine then tracerLine.Visible = false end
                bill.Enabled = false
                return
            end
            hrp = cHrp
            bill.Adornee = hrp
            bill.Enabled = true
            if highlight.Parent ~= cChar then highlight.Parent = cChar end
            highlight.Adornee = cChar
            local fugitive = fn92(player)
            local teamName = player.Team and player.Team.Name
            local color = fugitive and Color3.fromRGB(255, 0, 0) or tbl28[teamName] or Color3.fromRGB(0, 255, 0)
            nameLabel.Text = "[" .. (fugitive and "逃犯" or tbl17[teamName] or teamName or "未知") .. "] " .. player.Name
            nameLabel.TextColor3 = color
            nameLabel.Visible = tbl16.name
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.Enabled = tbl16.highlight
            local _, _, myHrp = fn40(localPlayer3)
            local parts = {}
            if tbl16.distance and myHrp then
                table.insert(parts, string.format("%.1f", (myHrp.Position - hrp.Position).Magnitude))
            end
            if tbl16.health and hum then
                table.insert(parts, tostring(math.floor(hum.Health)))
            end
            infoLabel.Text = #parts > 0 and "[" .. table.concat(parts, "/") .. "]" or ""
            infoLabel.TextColor3 = color
            infoLabel.Visible = tbl16.distance or tbl16.health
            local cam = Workspace.CurrentCamera
            if tracerLine then
                if tbl16.tracer and cam then
                    local sp, vis = cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local vp = cam.ViewportSize
                        if tbl16.tracerOrigin == "屏幕中心" then
                            tracerLine.From = Vector2.new(vp.X / 2, vp.Y / 2)
                        elseif tbl16.tracerOrigin == "屏幕顶部" then
                            tracerLine.From = Vector2.new(vp.X / 2, 0)
                        else
                            tracerLine.From = Vector2.new(vp.X / 2, vp.Y)
                        end
                        tracerLine.To = Vector2.new(sp.X, sp.Y)
                        tracerLine.Color = color
                        tracerLine.Visible = true
                    else
                        tracerLine.Visible = false
                    end
                else
                    tracerLine.Visible = false
                end
            end
        end),
    }
end

fn53 = function()
    for k in pairs(tbl16.trackers) do
        if not fn93(k) then fn52(k) end
    end
    if tbl16.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer3 and fn93(player) and not tbl16.trackers[player] then
                pcall(fn94, player)
            end
        end
    end
end

local function hookEspPlayer(player)
    if player == localPlayer3 then return end
    player.CharacterAdded:Connect(function()
        task.wait(0.25)
        if tbl16.enabled then
            fn52(player)
            pcall(fn94, player)
        end
    end)
end
for _, player in ipairs(Players:GetPlayers()) do hookEspPlayer(player) end
Players.PlayerAdded:Connect(hookEspPlayer)
Players.PlayerRemoving:Connect(fn52)

local lastEspScan = 0
RunService.Heartbeat:Connect(function()
    if not tbl16.enabled then return end
    if tick() - lastEspScan < 0.2 then return end
    lastEspScan = tick()
    fn53()
end)

-- ============================================================
-- 25. 自动铐
-- ============================================================
local PoliceSettings = { range = 200, delay = 0.5, combatCheck = false, teleport = false }
local cuffThread

fn54 = function()
    if cuffThread then return end
    cuffThread = task.spawn(function()
        while Settings.autoCuff do
            local _, _, hrp = fn40(localPlayer3)
            if hrp and playerFunc then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer3 and fn62(player) and fn85(player, PoliceSettings.combatCheck) then
                        local _, _, targetHrp = fn40(player)
                        if targetHrp and (targetHrp.Position - hrp.Position).Magnitude <= PoliceSettings.range then
                            pcall(function()
                                playerFunc:InvokeServer("handcuff", player, false)
                            end)
                        end
                    end
                end
                if PoliceSettings.teleport then
                    local bestDist, bestPlayer
                    for _, player in ipairs(Players:GetPlayers()) do
                        local isTarget = player ~= localPlayer3 and player.Team and player.Team.Name == "Civilian"
                        if isTarget then isTarget = (player:GetAttribute("WantedLevel") or 0) > 0 end
                        if isTarget then
                            local _, _, tHrp = fn40(player)
                            if tHrp then
                                local dist = (tHrp.Position - hrp.Position).Magnitude
                                if dist <= PoliceSettings.range and (not bestDist or dist < bestDist) then
                                    bestDist = dist; bestPlayer = player
                                end
                            end
                        end
                    end
                    if bestPlayer then
                        local _, _, tHrp = fn40(bestPlayer)
                        if tHrp then hrp.CFrame = CFrame.new(tHrp.Position - tHrp.CFrame.LookVector * 3) end
                    end
                end
            end
            task.wait(PoliceSettings.delay)
        end
        cuffThread = nil
    end)
end

-- ============================================================
-- 26. 移动（跳跃/飞行/无碰撞/行走速度）
-- ============================================================
local MovementSettings = {
    walkEnabled = false, walkSpeed = 200,
    jumpEnabled = false, jumpPower = 50, jumpMultiplier = 1, infiniteJump = false,
    flyEnabled = false, flySpeed = 30, flyMode = "传送", noclip = false,
}
local FlyState = {
    walkConn = nil, jumpConn = nil, flyConn = nil,
    bodyVelocity = nil, bodyGyro = nil, noclipConn = nil, collisionCache = {},
}

local controls
pcall(function()
    controls = require(localPlayer3.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
end)

fn95 = function()
    if FlyState.walkConn then FlyState.walkConn:Disconnect(); FlyState.walkConn = nil end
end
fn60 = function()
    fn95()
    if not MovementSettings.walkEnabled then return end
    FlyState.walkConn = RunService.Heartbeat:Connect(function()
        local _, hum = fn40(localPlayer3)
        if hum and MovementSettings.walkEnabled then hum.WalkSpeed = MovementSettings.walkSpeed end
    end)
end

fn96 = function(hum)
    if not hum then return false end
    local s = hum:GetState()
    return s == Enum.HumanoidStateType.Landed or s == Enum.HumanoidStateType.Running or s == Enum.HumanoidStateType.RunningNoPhysics
end

fn55 = function()
    if FlyState.jumpConn then FlyState.jumpConn:Disconnect(); FlyState.jumpConn = nil end
end
fn56 = function()
    fn55()
    if not MovementSettings.jumpEnabled then return end
    FlyState.jumpConn = UserInputService.JumpRequest:Connect(function()
        if not MovementSettings.jumpEnabled then return end
        local _, hum, hrp = fn40(localPlayer3)
        if not hum or not hrp or hum.Health <= 0 then return end
        if not MovementSettings.infiniteJump and not fn96(hum) then return end
        hrp.CFrame = hrp.CFrame + Vector3.new(0, MovementSettings.jumpPower * MovementSettings.jumpMultiplier * 0.1, 0)
    end)
end

fn97 = function()
    if FlyState.flyConn then FlyState.flyConn:Disconnect(); FlyState.flyConn = nil end
    if FlyState.bodyVelocity then FlyState.bodyVelocity:Destroy(); FlyState.bodyVelocity = nil end
    if FlyState.bodyGyro then FlyState.bodyGyro:Destroy(); FlyState.bodyGyro = nil end
    local _, hum = fn40(localPlayer3)
    if hum then hum.PlatformStand = false; hum.AutoRotate = true end
end

local function flyTeleport()
    local _, hum, hrp = fn40(localPlayer3)
    if not hrp or not hum then return end
    MovementSettings.flyEnabled = true
    hum.AutoRotate = false
    FlyState.flyConn = RunService.RenderStepped:Connect(function(dt)
        if not MovementSettings.flyEnabled or MovementSettings.flyMode ~= "传送" then return end
        local _, h, r = fn40(localPlayer3)
        local cam = Workspace.CurrentCamera
        if not r or not h or not cam then return end
        local mv = controls and controls:GetMoveVector() or Vector3.zero
        local dir = cam.CFrame.LookVector * -mv.Z + cam.CFrame.RightVector * mv.X
        local y = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then y = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then y = -1 end
        r.CFrame = r.CFrame + (dir + Vector3.new(0, y, 0)) * MovementSettings.flySpeed * dt
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
        h:ChangeState(Enum.HumanoidStateType.Climbing)
    end)
end

local function flyPhysics()
    local _, hum, hrp = fn40(localPlayer3)
    if not hrp or not hum then return end
    MovementSettings.flyEnabled = true
    local bv = Instance.new("BodyVelocity")
    bv.Name = "PYPlayerFlyVelocity"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    FlyState.bodyVelocity = bv
    local bg = Instance.new("BodyGyro")
    bg.Name = "PYPlayerFlyGyro"
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 90000
    bg.Parent = hrp
    FlyState.bodyGyro = bg
    hum.PlatformStand = true
    hum.AutoRotate = false
    FlyState.flyConn = RunService.RenderStepped:Connect(function()
        if not MovementSettings.flyEnabled or MovementSettings.flyMode ~= "物理" then return end
        local _, _, r = fn40(localPlayer3)
        local cam = Workspace.CurrentCamera
        if not r or not cam then return end
        if FlyState.bodyVelocity and FlyState.bodyGyro then
            local mv = controls and controls:GetMoveVector() or Vector3.zero
            local dir = cam.CFrame.LookVector * -mv.Z + cam.CFrame.RightVector * mv.X
            local y = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then y = 1
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then y = -1 end
            FlyState.bodyVelocity.Velocity = (dir + Vector3.new(0, y, 0)) * MovementSettings.flySpeed
            FlyState.bodyGyro.CFrame = cam.CFrame
        end
    end)
end

fn57 = function()
    if MovementSettings.flyMode == "物理" then flyPhysics() else flyTeleport() end
end

local function restoreCollision()
    for part, v in pairs(FlyState.collisionCache) do
        if part and part.Parent then
            pcall(function() part.CanCollide = v end)
        end
    end
    FlyState.collisionCache = {}
end

fn58 = function()
    if FlyState.noclipConn then FlyState.noclipConn:Disconnect(); FlyState.noclipConn = nil end
    restoreCollision()
    if not MovementSettings.noclip then return end
    FlyState.noclipConn = RunService.Stepped:Connect(function()
        if not MovementSettings.noclip then return end
        local char = localPlayer3.Character
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                if FlyState.collisionCache[d] == nil then
                    FlyState.collisionCache[d] = d.CanCollide
                end
                d.CanCollide = false
            end
        end
    end)
end

localPlayer3.CharacterAdded:Connect(function()
    task.wait(0.5)
    FlyState.collisionCache = {}
    if MovementSettings.walkEnabled then fn60() end
    if MovementSettings.jumpEnabled then fn56() end
    if MovementSettings.noclip then fn58() end
    if MovementSettings.flyEnabled then
        local mode = MovementSettings.flyMode
        MovementSettings.flyEnabled = false
        task.wait(0.2)
        MovementSettings.flyMode = mode
        fn57()
    end
end)

-- ============================================================
-- 27. 启动后台任务
-- ============================================================
pcall(fn66)
pcall(fn73)
pcall(fn77)
pcall(fn79)
pcall(fn80)
pcall(fn82)
pcall(fn83)

-- ============================================================
-- 28. UI 构建
-- ============================================================
fn59 = function()
    if v27 then pcall(function() v27:Destroy() end); v27 = nil end

    v27 = lib:CreateWindow({
        Title = "PY Hub/圣奥里<font color='#00FF00'>破解版</font>",
        Icon = "zap", IconTransparency = 0.5, IconThemed = true,
        Author = "Xi.Team", Folder = "PYHub",
        Size = UDim2.fromOffset(640, 460),
        Transparent = true, Theme = "Dark",
        User = { Enabled = false, Callback = function() end, Anonymous = false },
        SideBarWidth = 200, ScrollBarEnabled = true,
        Background = fn42(), BackgroundImageTransparency = 0.4,
    })

    flag8 = true
    local parent = v27.Parent
    if parent then
        local function changeFont(d)
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Font ~= Enum.Font.Code then
                d.Font = Enum.Font.PermanentMarker
            end
        end
        for _, d in ipairs(parent:GetDescendants()) do changeFont(d) end
        parent.DescendantAdded:Connect(changeFont)
    end

    local timeTag = v27:Tag({ Title = "当前时间: 00:00:00", Icon = "clock", Color = Color3.fromHex("#FFFFFF"), Border = true })
    local lastTick = 0
    RunService.Heartbeat:Connect(function()
        if tick() - lastTick >= 0.1 then
            timeTag:SetTitle("当前时间: " .. os.date("!%H:%M:%S", os.time() + 28800))
            lastTick = tick()
        end
    end)

    pcall(function()
        v27:EditOpenButton({
            Title = "PYHub<font color='#00FF00'>1.0</font>",
            Icon = "crown", CornerRadius = UDim.new(1, 16), StrokeThickness = 1.5,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("FF1493")),
                ColorSequenceKeypoint.new(0.3, Color3.fromHex("FF69B4")),
                ColorSequenceKeypoint.new(0.6, Color3.fromHex("FFB6C1")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("FFC0CB")),
            }),
            Draggable = true,
        })
    end)

    local main = v27.UIElements.Main
    if main then
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainBorder"
        stroke.Thickness = 3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Enabled = tbl8.borderEnabled
        stroke.Parent = main
        local grad = Instance.new("UIGradient")
        grad.Name = "BorderGradient"
        grad.Parent = stroke
    end

    -- 公告
    local tabNotice = v27:Tab({ Title = "公告", Icon = "message-circle" })
    tabNotice:Paragraph({ Title = "破解版", Desc = "XI团队暴打所有联邦狗", Image = "message-circle", ImageSize = 32 })
    tabNotice:Paragraph({ Title = "开源人", Desc = "苏达", Image = "user", ImageSize = 32 })

    -- 主页
    local tabHome = v27:Tab({ Title = "主页", Icon = "home" })
    tabHome:Paragraph({ Title = "PY Hub", Desc = "圣奥里精简版", Image = "zap", ImageSize = 32 })
    tabHome:Paragraph({ Title = "玩家", Desc = "当前服务器ID: " .. game.PlaceId, Image = "users", ImageSize = 32 })

    -- UI设置
    local tabUI = v27:Tab({ Title = "UI设置", Icon = "settings" })
    tabUI:Toggle({ Title = "自定义光标", Value = false, Callback = function(v) pcall(function() v27:ToggleCustomCursor(v) end) end })
    tabUI:Dropdown({ Title = "通知位置", Values = { "左", "右" }, Value = "右",
        Callback = function(v) pcall(function() lib:SetNotifySide(v == "左" and "Left" or "Right") end) end })
    tabUI:Dropdown({ Title = "DPI缩放",
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" }, Value = "100%",
        Callback = function(v)
            local num = tonumber(v:gsub("%%", ""))
            if num then pcall(function() v27:SetDPIScale(num / 100) end) end
        end })
    tabUI:Keybind({ Title = "菜单按键", Value = "RightShift",
        Callback = function(v) pcall(function() v27:SetToggleKey(Enum.KeyCode[v]) end) end })
    tabUI:Divider()
    tabUI:Toggle({ Title = "随机背景图", Value = tbl8.randomBg, Callback = function(v) tbl8.randomBg = v end })
    tabUI:Divider()
    tabUI:Toggle({ Title = "启用边框颜色", Value = tbl8.borderEnabled,
        Callback = function(v)
            tbl8.borderEnabled = v
            local m = v27 and v27.UIElements and v27.UIElements.Main
            m = m and m:FindFirstChild("MainBorder")
            if m then m.Enabled = v end
        end })
    tabUI:Dropdown({ Title = "边框颜色",
        Values = { "旋转彩虹", "默认白色", "红色", "橙色", "黄色", "绿色", "青色", "蓝色", "紫色", "粉色" },
        Value = "旋转彩虹",
        Callback = function(v)
            if v == "旋转彩虹" then fn43(nil, true)
            elseif v == "默认白色" then fn43(Color3.new(1, 1, 1), false)
            else fn43(fn39(v), false) end
        end })
    tabUI:Divider()
    tabUI:Dropdown({ Title = "文字颜色",
        Values = { "默认", "青色", "粉色", "紫色", "橙色", "红色", "绿色", "蓝色", "黄色", "白色", "彩虹" },
        Value = "默认",
        Callback = function(v) v28 = v end })
    tabUI:Button({ Title = "确认应用文字颜色", Icon = "check",
        Callback = function()
            local themes = lib.GetThemes and lib.GetThemes()
            if not themes or not themes.Dark then return end
            if connection then connection:Disconnect(); connection = nil end
            if v28 == "彩虹" then
                connection = RunService.Heartbeat:Connect(function()
                    local c = fn38(5)
                    themes.Dark.Text = c; themes.Dark.Placeholder = c
                    themes.Dark.Button = c; themes.Dark.TabTitle = c
                    lib:SetTheme("Dark")
                end)
            elseif v28 and v28 ~= "默认" then
                local c = fn39(v28)
                themes.Dark.Text = c; themes.Dark.Placeholder = c
                themes.Dark.Button = c; themes.Dark.TabTitle = c
                lib:SetTheme("Dark")
            else
                lib:SetTheme("Dark")
            end
        end })

    -- 功能 Section
    local section = v27:Section({ Title = "功能", Opened = true })

    -- 主要功能
    local t1 = section:Tab({ Title = "主要功能", Icon = "sliders-h" })
    t1:Toggle({ Title = "无限体力", Default = false, Callback = function(v) Settings.stamina = v end })
    t1:Toggle({ Title = "无限饥饿", Default = false, Callback = function(v) Settings.food = v end })
    t1:Toggle({ Title = "战斗拦截", Default = false, Callback = fn45 })
    t1:Toggle({ Title = "隐身", Default = false, Callback = fn46 })
    t1:Toggle({ Title = "显示隐身悬浮窗", Default = false, Callback = function(v) flag10 = v end })
    t1:Toggle({ Title = "锁定隐身悬浮窗位置", Default = false,
        Callback = function(v)
            flag9 = v
            if textButton then textButton.Active = not v; textButton.Draggable = not v end
        end })
    t1:Toggle({ Title = "防布娃娃", Default = false, Callback = function(v) Settings.noRagdoll = v end })
    t1:Toggle({ Title = "防摔伤", Default = false, Callback = function(v) Settings.noFallDamage = v end })
    t1:Toggle({ Title = "防越狱拉回", Default = false, Callback = fn49 })
    t1:Toggle({ Title = "自动捡钱", Default = false, Callback = function(v) Settings.autoMoney = v end })
    t1:Toggle({ Title = "无限子弹", Default = false, Callback = function(v) Settings.infiniteAmmo = v end })
    t1:Toggle({ Title = "快速射击", Default = false, Callback = function(v) Settings.rapidFire = v end })

    -- 刷钱
    local t2 = section:Tab({ Title = "刷钱", Icon = "money-bill-wave" })
    t2:Toggle({ Title = "自动接取任务", Default = false, Callback = function(v) Settings.autoMission = v end })
    t2:Toggle({ Title = "优先高收益任务", Default = false, Callback = function(v) tbl10.priorityHighReward = v end })
    t2:Input({ Title = "接取间隔", Value = "2", PlaceholderText = "输入间隔秒数", ClearTextOnFocus = false,
        Callback = function(v) local n = tonumber(v); if n and n > 0 then tbl10.missionInterval = n end end })
    t2:Toggle({ Title = "安全模式(出租车)", Default = false,
        Callback = function(v)
            tbl10.taxiSafe = v
            if v then local _, _, hrp = fn40(localPlayer3); if hrp then tbl10.taxiOrigin = hrp.Position end end
        end })
    t2:Dropdown({ Title = "出租车延迟模式", Values = { "随机时间", "距离测算" }, Value = "随机时间",
        Callback = function(v) tbl10.taxiDelayMode = v end })
    t2:Toggle({ Title = "出租车刷钱", Default = false, Callback = function(v) Settings.taxi = v end })
    t2:Toggle({ Title = "公交车刷钱", Default = false, Callback = function(v) Settings.bus = v end })
    t2:Toggle({ Title = "农民刷钱", Default = false, Callback = function(v) Settings.farmer = v end })
    t2:Toggle({ Title = "自动黑客小游戏", Default = false, Callback = fn50 })
    t2:Toggle({ Title = "高尔夫刷钱", Default = false, Callback = function(v) Settings.golf = v end })

    -- 战斗
    local t3 = section:Tab({ Title = "战斗", Icon = "crosshairs" })
    t3:Toggle({ Title = "杀戮光环", Default = false, Callback = function(v) tbl11.auraEnabled = v end })
    t3:Toggle({ Title = "只攻击警察", Default = false,
        Callback = function(v) tbl11.auraOnlyPolice = v; if v then tbl11.auraOnlyCivilian = false end end })
    t3:Toggle({ Title = "只攻击平民", Default = false,
        Callback = function(v) tbl11.auraOnlyCivilian = v; if v then tbl11.auraOnlyPolice = false end end })
    t3:Toggle({ Title = "战斗检测", Default = false, Callback = function(v) tbl11.auraCombatCheck = v end })
    t3:Slider({ Title = "攻击范围", Value = { Min = 10, Max = 500, Default = 50 }, Callback = function(v) tbl11.auraRange = v end })
    t3:Slider({ Title = "伤害倍率", Value = { Min = 1, Max = 100, Default = 5 }, Callback = function(v) tbl11.auraDamage = v end })

    -- 自瞄
    local t4 = section:Tab({ Title = "自瞄", Icon = "crosshairs" })
    t4:Toggle({ Title = "开启/关闭自瞄", Default = false, Callback = function(v) tbl12.enabled = v end })
    t4:Toggle({ Title = "显示Fov圈", Default = false, Callback = function(v) tbl12.showFov = v end })
    t4:Toggle({ Title = "显示准心", Default = false, Callback = function(v) tbl12.showCrosshair = v end })
    t4:Toggle({ Title = "显示追踪线", Default = false, Callback = function(v) tbl12.showTracer = v end })
    t4:Toggle({ Title = "队伍检测", Default = false, Callback = function(v) tbl12.teamCheck = v end })
    t4:Toggle({ Title = "好友检测", Default = false, Callback = function(v) tbl12.friendCheck = v end })
    t4:Toggle({ Title = "墙壁检测", Default = false, Callback = function(v) tbl12.wallCheck = v end })
    t4:Toggle({ Title = "预判自瞄", Default = false, Callback = function(v) tbl12.prediction = v end })
    t4:Toggle({ Title = "只自瞄警察", Default = false,
        Callback = function(v) tbl12.onlyPolice = v; if v then tbl12.onlyCivilian = false end end })
    t4:Toggle({ Title = "只自瞄平民", Default = false,
        Callback = function(v) tbl12.onlyCivilian = v; if v then tbl12.onlyPolice = false end end })
    t4:Toggle({ Title = "战斗检测", Default = false, Callback = function(v) tbl12.combatCheck = v end })
    t4:Dropdown({ Title = "优先锁定模式", Values = { "准心最近", "距离最近", "血量最低" }, Value = "准心最近",
        Callback = function(v) tbl12.targetMode = v end })
    t4:Dropdown({ Title = "瞄准身体部位", Values = { "头", "胸", "左手", "右手", "左腿", "右腿" }, Value = "头",
        Callback = function(v) tbl12.targetPart = v end })
    t4:Slider({ Title = "Fov圈大小", Value = { Min = 1, Max = 500, Default = 50 }, Callback = function(v) tbl12.fov = v end })
    t4:Slider({ Title = "自瞄平滑度", Value = { Min = 1, Max = 10, Default = 10 }, Callback = function(v) tbl12.smoothness = v / 10 end })
    t4:Slider({ Title = "Fov圈厚度", Value = { Min = 1, Max = 5, Default = 2 }, Callback = function(v) tbl12.fovThickness = v end })
    t4:Dropdown({ Title = "颜色选择",
        Values = { "红色", "黄色", "绿色", "蓝色", "紫色", "白色", "黑色", "彩虹色" }, Value = "红色",
        Callback = function(v) tbl12.color = v end })

    -- Ragebot
    local tbl14 = { ["头部"] = "Head", ["躯干"] = "Torso", ["左臂"] = "LeftArm",
        ["右臂"] = "RightArm", ["左腿"] = "LeftLeg", ["右腿"] = "RightLeg" }
    local t5 = section:Tab({ Title = "Ragebot", Icon = "bot" })
    t5:Toggle({ Title = "Ragebot", Default = false, Callback = function(v) tbl13.enabled = v end })
    t5:Slider({ Title = "攻击距离", Value = { Min = 10, Max = 500, Default = 150 }, Step = 1,
        Callback = function(v) tbl13.range = v end })
    t5:Slider({ Title = "攻击间隔", Value = { Min = 0.01, Max = 1, Default = 0.05 }, Step = 0.01,
        Callback = function(v) tbl13.interval = v end })
    t5:Dropdown({ Title = "攻击部位", Values = { "头部", "躯干", "左臂", "右臂", "左腿", "右腿" }, Value = "头部",
        Callback = function(v) tbl13.bodyPart = tbl14[v] or "Head" end })
    t5:Toggle({ Title = "职业检测", Default = false, Callback = function(v) tbl13.jobCheck = v end })
    t5:Toggle({ Title = "墙壁检测", Default = false, Callback = function(v) tbl13.wallCheck = v end })
    t5:Toggle({ Title = "活体检测", Default = false, Callback = function(v) tbl13.aliveCheck = v end })
    t5:Toggle({ Title = "战斗状态检测", Default = false, Callback = function(v) tbl13.combatCheck = v end })
    t5:Toggle({ Title = "锁定警察", Default = false,
        Callback = function(v) tbl13.policeLock = v; if v then tbl13.civilianLock = false end end })
    t5:Toggle({ Title = "锁定平民", Default = false,
        Callback = function(v) tbl13.civilianLock = v; if v then tbl13.policeLock = false end end })
    t5:Toggle({ Title = "弹道显示", Default = false, Callback = function(v) tbl13.beam = v end })

    -- 范围
    local t6 = section:Tab({ Title = "范围", Icon = "bullseye" })
    t6:Toggle({ Title = "开启/关闭范围", Default = false, Callback = function(v) tbl15.active = v end })
    t6:Input({ Title = "范围大小设置", Value = "10",
        Callback = function(v) local n = tonumber(v); if n and n > 0 then tbl15.size = n end end })
    t6:Input({ Title = "范围透明度设置(0-1)", Value = "0.7",
        Callback = function(v) local n = tonumber(v); if n and n >= 0 and n <= 1 then tbl15.transparency = n end end })
    t6:Dropdown({ Title = "选择范围颜色",
        Values = { "红色", "蓝色", "黄色", "绿色", "青色", "橙色", "紫色", "白色", "黑色", "彩虹色" }, Value = "红色",
        Callback = function(v) tbl15.color = v; tbl15.rainbow = (v == "彩虹色") end })
    t6:Dropdown({ Title = "选择范围材质",
        Values = { "Neon", "Plastic", "Wood", "Slate", "Concrete", "Metal", "SmoothPlastic" }, Value = "Neon",
        Callback = function(v) tbl15.material = v end })
    t6:Toggle({ Title = "NPC范围", Default = false, Callback = function(v) tbl15.affectNPC = v end })
    t6:Toggle({ Title = "队伍检测", Default = false, Callback = function(v) tbl15.teamCheck = v end })
    t6:Toggle({ Title = "活体检测", Default = false, Callback = function(v) tbl15.checkCorpses = v end })
    t6:Toggle({ Title = "显示轮廓", Default = false, Callback = function(v) tbl15.outline = v end })
    t6:Toggle({ Title = "启用/禁用碰撞", Default = false, Callback = function(v) tbl15.collision = v end })
    t6:Toggle({ Title = "发光效果", Default = false, Callback = function(v) tbl15.glow = v end })
    t6:Toggle({ Title = "脉动效果", Default = false, Callback = function(v) tbl15.pulse = v end })

    -- 玩家
    local t7 = section:Tab({ Title = "玩家", Icon = "user" })
    t7:Toggle({ Title = "开启/关闭跳跃", Default = false,
        Callback = function(v) MovementSettings.jumpEnabled = v; if v then fn56() else fn55() end end })
    t7:Slider({ Title = "设置跳跃高度", Value = { Min = 50, Max = 400, Default = 50 },
        Callback = function(v) MovementSettings.jumpPower = v end })
    t7:Slider({ Title = "设置跳跃倍数", Value = { Min = 1, Max = 10, Default = 1 },
        Callback = function(v) MovementSettings.jumpMultiplier = v end })
    t7:Toggle({ Title = "无限跳跃", Default = false, Callback = function(v) MovementSettings.infiniteJump = v end })

    -- 警察功能
    local t8 = section:Tab({ Title = "警察功能", Icon = "handcuffs" })
    t8:Toggle({ Title = "自动铐", Default = false,
        Callback = function(v) Settings.autoCuff = v; if v then fn54() end end })
    t8:Toggle({ Title = "自动传送", Default = false, Callback = function(v) PoliceSettings.teleport = v end })
    t8:Toggle({ Title = "战斗检测", Default = false, Callback = function(v) PoliceSettings.combatCheck = v end })
    t8:Slider({ Title = "范围", Value = { Min = 10, Max = 500, Default = 200 }, Step = 5,
        Callback = function(v) PoliceSettings.range = v end })
    t8:Slider({ Title = "间隔", Value = { Min = 0.1, Max = 3, Default = 0.5 }, Step = 0.1,
        Callback = function(v) PoliceSettings.delay = v end })

    -- ESP
    local t9 = section:Tab({ Title = "ESP", Icon = "eye" })
    t9:Toggle({ Title = "玩家透视总开关", Default = false,
        Callback = function(v)
            if type(v) == "table" then v = v.Value end
            tbl16.enabled = (v == true)
            if not tbl16.enabled then
                for k in pairs(tbl16.trackers) do fn52(k) end
            else pcall(fn53) end
        end })
    t9:Toggle({ Title = "显示名字", Default = true, Callback = function(v) tbl16.name = v end })
    t9:Toggle({ Title = "显示距离", Default = true, Callback = function(v) tbl16.distance = v end })
    t9:Toggle({ Title = "显示血量", Default = true, Callback = function(v) tbl16.health = v end })
    t9:Toggle({ Title = "显示高亮", Default = true, Callback = function(v) tbl16.highlight = v end })
    t9:Toggle({ Title = "显示追踪线", Default = false, Callback = function(v) tbl16.tracer = v end })
    t9:Dropdown({ Title = "追踪线起点", Values = { "屏幕底部", "屏幕中心", "屏幕顶部" }, Value = "屏幕底部",
        Callback = function(v) tbl16.tracerOrigin = v end })
    local teamList = { "逃犯", "厨师", "平民", "配送员", "农民", "消防员", "警察", "医护人员", "囚犯", "道路服务", "交通" }
    t9:Dropdown({ Title = "选择透视队伍", Values = teamList, Value = teamList, Multi = true, AllowNone = true,
        Callback = function(v)
            for k in pairs(tbl16.selectedTeams) do tbl16.selectedTeams[k] = false end
            tbl16.showFugitive = false
            if type(v) ~= "table" then return end
            local function applyTeam(label)
                if label == "逃犯" then tbl16.showFugitive = true; return end
                for k, name in pairs(tbl17) do
                    if name == label or k == label then tbl16.selectedTeams[k] = true end
                end
            end
            if v[1] ~= nil then
                for _, val in ipairs(v) do applyTeam(val) end
            else
                for k, val in pairs(v) do
                    if val == true then applyTeam(k)
                    elseif type(val) == "string" then applyTeam(val) end
                end
            end
        end })

    v27:OnClose(function() flag8 = false; saveSettings() end)
    v27:OnDestroy(function() flag8 = false; saveSettings() end)
end

-- ============================================================
-- 29. 启动
-- ============================================================
task.defer(function()
    local ok, err = pcall(fn59)
    if not ok then
        warn("[PY Hub] UI 启动失败: " .. tostring(err))
    end
end)