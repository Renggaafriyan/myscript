-- Recovered Luau source by ZeroVector
local function __store_list(t, start, ...)
    for i = 1, select("#", ...) do
        t[start + i - 1] = (select(i, ...))
    end
end

local ReplicatedStorage, RunService, Players, localPlayer, UserInputService, fn, fn2, fn3, lib, obj, flag, str, sharedQueueAutoExecute, fn4, fn5, tbl, tbl2, flag2, v, flag3
local v2, v3

do
    loadstring(" function LPH_NO_VIRTUALIZE(f) return f end ")()
    ReplicatedStorage = game:GetService("ReplicatedStorage")
    game:GetService("Workspace")
    RunService = game:GetService("RunService")
    Players = game:GetService("Players")
    localPlayer = Players.LocalPlayer
    UserInputService = game:GetService("UserInputService")
    local flag4 = false
    _G.AutoMineActive = false
    _G.OrbThrowing = false
    _G._treasureHuntBusy = false
    _G._blockFlags = {epoch = {}, maxSeconds = 300, pollInterval = 1}

    _G.SetBlockFlag = function(arg, arg2)
        local blockFlags = _G._blockFlags
        local v4 = blockFlags.epoch[arg]
        local n = v4 or 0
        local n2 = n + 1
        blockFlags.epoch[arg] = n2
        local v5 = _G
        local flag5 = arg2 and true or false
        v5[arg] = flag5
        if not arg2 then
            return
        end
        local v6 = coroutine.running()
        local n3 = os.clock() + blockFlags.maxSeconds

        task.spawn(function()
            while blockFlags.epoch[arg] == n2 and _G[arg] do
                if coroutine.status(v6) ~= "dead" and n3 >= os.clock() then
                    task.wait(blockFlags.pollInterval)
                    continue
                end

                if blockFlags.epoch[arg] == n2 then
                    _G[arg] = false
                end

                return
            end
        end)
    end

    _G.SetOrbThrowing = function(arg)
        _G.SetBlockFlag("OrbThrowing", arg)
    end

    _G.SetMining = function(arg)
        _G.SetBlockFlag("AutoMineActive", arg)
    end

    _G.SetTreasureBusy = function(arg)
        _G.SetBlockFlag("_treasureHuntBusy", arg)
    end

    local tbl3 = {}

    fn = function(arg)
        if not arg then
            return nil
        end

        if tbl3[arg] then
            return tbl3[arg]
        end

        local ok, result = pcall(function()
            return require(arg)
        end)

        if ok and result then
            tbl3[arg] = result
        end

        local v4 = ok and result or nil
        return v4
    end

    local v4 = nil

    fn2 = function()
        if v4 then
            return v4
        end

        local ok, result = pcall(function()
            local packages = ReplicatedStorage:FindFirstChild("Packages")
            local replion = packages and ReplicatedStorage.Packages:FindFirstChild("Replion")
            local v5 = fn(replion)
            if not v5 then
                return
            end
            return v5.Client:GetReplion("Data")
        end)

        if ok and result then
            v4 = result
        end

        return v4
    end

    local v5 = nil

    fn3 = function()
        if v5 then
            return v5
        end

        local ok, result = pcall(function()
            return fn(ReplicatedStorage.Packages.Replion)
        end)

        if ok and result then
            v5 = result
        end

        return v5
    end

    lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/habibrodriguez7-art/MainLib/refs/heads/main/rewrite.lua"))()

    _G.EventResolver = (function()
        local tbl4 = {
            _isInitialized = false,
            _remoteEvents = {},
            _remoteFunctions = {},
            _netFolder = nil,
        }

        local function fn6(arg)
            local flag5 = #arg >= 32 and arg:match("^[0-9a-f]+$") ~= nil
            return flag5
        end

        local function fn7(arg)
            local match = arg:match("^[A-Z]+/(.+)$")
            local v6 = match or arg
            return v6
        end

        local function fn8()
            if tbl4._netFolder and tbl4._netFolder.Parent then
                return tbl4._netFolder
            end

            local ok, netFolder = pcall(function()
                return ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
            end)

            if not ok or not netFolder then
                return nil
            end
            tbl4._netFolder = netFolder
            return netFolder
        end

        local function fn9(arg)
            local children = arg:GetChildren()
            local n = 1

            while n <= #children do
                local v6 = children[n]
                local v7 = children[n + 1]
                local v8 = fn7(v6.Name)

                if v7 and v6.ClassName == v7.ClassName and not fn6(v8) and fn6(fn7(v7.Name)) then
                    if v6:IsA("RemoteFunction") then
                        tbl4._remoteFunctions[v8] = v7
                    elseif v6:IsA("RemoteEvent") or v6:IsA("UnreliableRemoteEvent") then
                        tbl4._remoteEvents[v8] = v7
                    end

                    n = n + 2
                else
                    n = n + 1
                end
            end
        end

        local function fn10(arg, arg2)
            if not arg[arg2] or not arg[arg2].Parent then
                local v6 = fn8()

                if v6 then
                    fn9(v6)
                end
            end

            return arg[arg2]
        end

        tbl4.Init = function(arg)
            if arg._isInitialized then
                return true
            end
            local v6 = fn8()
            if not v6 then
                warn("[EventResolver] Folder Net tidak ditemukan!")
                return false
            end
            arg._remoteEvents = {}
            arg._remoteFunctions = {}
            fn9(v6)
            arg._isInitialized = true
            return true
        end

        tbl4.GetRemoteFunction = function(arg, arg2)
            if not arg._isInitialized then
                arg:Init()
            end

            return fn10(arg._remoteFunctions, arg2)
        end

        tbl4.GetRemoteEvent = function(arg, arg2)
            if not arg._isInitialized then
                arg:Init()
            end

            return fn10(arg._remoteEvents, arg2)
        end

        tbl4.Reset = function(arg)
            arg._isInitialized = false
            arg._netFolder = nil
            arg._remoteEvents = {}
            arg._remoteFunctions = {}
        end

        tbl4.IsReady = function(arg)
            return arg._isInitialized
        end

        tbl4.GetNetFolder = function(arg)
            return fn8()
        end

        tbl4:Init()
        return tbl4
    end)()

    localPlayer.CharacterAdded:Connect(function()
        task.wait(3)
        v4 = nil
        v5 = nil
        _G.EventResolver:Reset()

        task.spawn(function()
            _G.EventResolver:Init()
        end)
    end)

    obj = setmetatable({}, {
        __index = function(arg, arg2)
            local v6 = ({
                RF_ChargeFishingRod = function()
                    return _G.EventResolver:GetRemoteFunction("ChargeFishingRod")
                end,
                RF_RequestMinigame = function()
                    return _G.EventResolver:GetRemoteFunction("RequestFishingMinigameStarted")
                end,
                RF_CancelFishingInputs = function()
                    return _G.EventResolver:GetRemoteFunction("CancelFishingInputs")
                end,
                RF_UpdateAutoFishingState = function()
                    return _G.EventResolver:GetRemoteFunction("UpdateAutoFishingState")
                end,
                RF_ConsumePotion = function()
                    return _G.EventResolver:GetRemoteFunction("ConsumePotion")
                end,
                RF_PurchaseCharm = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseCharm")
                end,
                RF_SellItem = function()
                    return _G.EventResolver:GetRemoteFunction("SellItem")
                end,
                RF_SellAllItems = function()
                    return _G.EventResolver:GetRemoteFunction("SellAllItems")
                end,
                RF_PurchaseFishingRod = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseFishingRod")
                end,
                RF_PurchaseBait = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseBait")
                end,
                RF_UpdateFishingRadar = function()
                    return _G.EventResolver:GetRemoteFunction("UpdateFishingRadar")
                end,
                RF_StartCrafting = function()
                    return _G.EventResolver:GetRemoteFunction("StartCrafting")
                end,
                RF_ConfirmCrafting = function()
                    return _G.EventResolver:GetRemoteFunction("ConfirmCrafting")
                end,
                RF_CancelCrafting = function()
                    return _G.EventResolver:GetRemoteFunction("CancelCrafting")
                end,
                RF_ConsumeCaveCrystal = function()
                    return _G.EventResolver:GetRemoteFunction("ConsumeCaveCrystal")
                end,
                RF_PurchaseWeatherEvent = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseWeatherEvent")
                end,
                RF_SacrificeAtlantisSellAll = function()
                    return _G.EventResolver:GetRemoteFunction("SacrificeAtlantisSellAll")
                end,
                RF_EquipOxygenTank = function()
                    return _G.EventResolver:GetRemoteFunction("EquipOxygenTank")
                end,
                RF_UnequipOxygenTank = function()
                    return _G.EventResolver:GetRemoteFunction("UnequipOxygenTank")
                end,
                RF_ConsumeItem = function()
                    return _G.EventResolver:GetRemoteFunction("ConsumeItem")
                end,
                RF_EquipToolFromHotbar = function()
                    return _G.EventResolver:GetRemoteEvent("EquipToolFromHotbar")
                end,
                RF_PurchaseMarketItem = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseMarketItem")
                end,
                RF_RodCraftingMinigameClick = function()
                    return _G.EventResolver:GetRemoteFunction("RodCraftingMinigameClick")
                end,
                RF_FinishRodCraftingMinigame = function()
                    return _G.EventResolver:GetRemoteFunction("FinishRodCraftingMinigame")
                end,
                RF_PurchaseBlackMarketItem = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseBlackMarketItem")
                end,
                RF_ThrowBathBomb = function()
                    return _G.EventResolver:GetRemoteFunction("ThrowBathBomb")
                end,
                RE_PlayRodCraftingMinigame = function()
                    return _G.EventResolver:GetRemoteEvent("PlayRodCraftingMinigame")
                end,
                RE_FishingCompleted = function()
                    return _G.EventResolver:GetRemoteEvent("CatchFishCompleted")
                end,
                RE_MinigameChanged = function()
                    return _G.EventResolver:GetRemoteEvent("FishingMinigameChanged")
                end,
                RE_FishCaught = function()
                    return _G.EventResolver:GetRemoteEvent("FishCaught")
                end,
                RE_FavoriteItem = function()
                    return _G.EventResolver:GetRemoteEvent("FavoriteItem")
                end,
                RE_EquipItem = function()
                    return _G.EventResolver:GetRemoteEvent("EquipItem")
                end,
                RE_ActivateEnchantingAltar = function()
                    return _G.EventResolver:GetRemoteEvent("ActivateEnchantingAltar")
                end,
                RE_ActivateSecondEnchantingAltar = function()
                    return _G.EventResolver:GetRemoteEvent("ActivateSecondEnchantingAltar")
                end,
                RE_RollEnchant = function()
                    return _G.EventResolver:GetRemoteEvent("RollEnchant")
                end,
                RE_BaitSpawned = function()
                    return _G.EventResolver:GetRemoteEvent("BaitSpawned")
                end,
                RE_ObtainedNewFishNotification = function()
                    return _G.EventResolver:GetRemoteEvent("ObtainedNewFishNotification")
                end,
                RE_PlaceLeverItem = function()
                    return _G.EventResolver:GetRemoteEvent("PlaceLeverItem")
                end,
                RE_EquipBait = function()
                    return _G.EventResolver:GetRemoteEvent("EquipBait")
                end,
                RE_PlayFishEffect = function()
                    return _G.EventResolver:GetRemoteEvent("PlayFishingEffect")
                end,
                RE_TextEffect = function()
                    return _G.EventResolver:GetRemoteEvent("ReplicateTextEffect")
                end,
                RE_BaitCastVisual = function()
                    return _G.EventResolver:GetRemoteEvent("BaitCastVisual")
                end,
                RE_FishCaughtVisual = function()
                    return _G.EventResolver:GetRemoteEvent("CaughtFishVisual")
                end,
                RE_DialogueEnded = function()
                    return _G.EventResolver:GetRemoteEvent("DialogueEnded")
                end,
                RE_PickaxeMining = function()
                    return _G.EventResolver:GetRemoteEvent("PickaxeMining")
                end,
                RE_SpawnTotem = function()
                    return _G.EventResolver:GetRemoteEvent("SpawnTotem")
                end,
                RE_ClaimPirateChest = function()
                    return _G.EventResolver:GetRemoteEvent("ClaimPirateChest")
                end,
                RE_PlacePressureItem = function()
                    return _G.EventResolver:GetRemoteEvent("PlacePressureItem")
                end,
                RE_TotemPickup = function()
                    return _G.EventResolver:GetRemoteEvent("TotemPickup")
                end,
                RE_TotemCreated = function()
                    return _G.EventResolver:GetRemoteEvent("TotemCreated")
                end,
                RE_PlaceLeviathanPressureItem = function()
                    return _G.EventResolver:GetRemoteEvent("PlaceLeviathanPressureItem")
                end,
                RE_TradePlazaTeleport = function()
                    return _G.EventResolver:GetRemoteEvent("TradePlazaTeleport")
                end,
                RE_TreasureChestClaimed = function()
                    return _G.EventResolver:GetRemoteEvent("TreasureChestClaimed")
                end,
                RE_TextNotification = function()
                    return _G.EventResolver:GetRemoteEvent("TextNotification")
                end,
                RE_BPPurchaseRequest = function()
                    return _G.EventResolver:GetRemoteEvent("BPPurchaseRequest")
                end,
                RF_PurchaseGear = function()
                    return _G.EventResolver:GetRemoteFunction("PurchaseGear")
                end,
                RF_CreateTranscendedStone = function()
                    return _G.EventResolver:GetRemoteFunction("CreateTranscendedStone")
                end,
                RE_DisplaySystemMessage = function()
                    return _G.EventResolver:GetRemoteEvent("DisplaySystemMessage")
                end,
                netFolder = function()
                    return _G.EventResolver:GetNetFolder()
                end,
                IsInitialized = function()
                    return _G.EventResolver:IsReady()
                end,
            })[arg2]

            local v7 = v6 and v6() or nil
            return v7
        end,
        __newindex = function(arg, arg2, arg3)
            rawset(arg, arg2, arg3)
        end,
    })

    if getgenv()._fishNotifConn then
        pcall(function()
            getgenv()._fishNotifConn:Disconnect()
        end)

        getgenv()._fishNotifConn = nil
    end

    if getgenv()._fishNotifThread then
        pcall(task.cancel, getgenv()._fishNotifThread)
        getgenv()._fishNotifThread = nil
    end

    local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
    local v6 = fn(ReplicatedStorage2.Controllers.TextNotificationController)
    local v7 = fn(ReplicatedStorage2.Shared.ItemUtility)

    if v6 and v7 then
        local tbl4 = {}
        local flag5 = false
        local v8 = nil
        local fn6

        fn6 = function(arg, arg2, arg3)
            if type(arg) ~= "function" or arg2 > 3 or arg3[arg] then
                return nil
            end
            arg3[arg] = true
            local ok, result = pcall(debug.getupvalues, arg)
            if not ok or type(result) ~= "table" then
                return nil
            end

            for i = 1, #result - 1 do
                local v9 = result[i + 1]
                if type(result[i]) == "table" and typeof(v9) == "Instance" and v9.Name == "Frame" and v9.Parent and v9.Parent.Name == "Text Notifications" then
                    return result[i]
                end
            end

            local v9, v10, v11 = pairs(result)
            local v12 = v11
            local v13 = v9
            local v14 = v10

            while true do
                local v15, v16 = v13(v14, v12)
                if v15 == nil then
                    break
                end
                v12 = v15

                if type(v16) == "function" then
                    local v17 = fn6(v16, arg2 + 1, arg3)
                    if v17 then
                        return v17
                    end
                    continue
                end

                if type(v16) ~= "table" or arg2 ~= 0 then
                    continue
                end

                for k, v17 in pairs(v16) do
                    local flag6 = type(v17) == "function" and fn6(v17, arg2 + 1, arg3)
                    if flag6 then
                        return flag6
                    end
                end

                v12 = v15
            end

            return nil
        end

        local function fn7()
            if v8 then
                return v8
            end

            pcall(function()
                v8 = fn6(v6.DeliverNotification, 0, {})
            end)

            return v8
        end

        fn7()

        local function fn8(arg)
            if v7.GetItemDataFromItemType("Items", arg) then
                return "Items"
            end

            if not v7.GetItemDataFromItemType("Fishing Rods", arg) then
                return "Items"
            end
            return "Fishing Rods"
        end

        local function fn9()
            if flag5 then
                return
            end
            flag5 = true

            getgenv()._fishNotifThread = task.spawn(function()
                while #tbl4 > 0 do
                    local v9 = table.remove(tbl4, 1)

                    pcall(function()
                        local v10 = fn7()

                        if v10 then
                            v10[string.format("Item:%s:%s", v9.itemType, tostring(v9.itemId))] = nil
                        end

                        v6:DeliverNotification({
                            Type = "Item",
                            ItemType = v9.itemType,
                            ItemId = v9.itemId,
                            InventoryItem = v9.inventoryItem,
                            Quantity = 1,
                            CustomDuration = 5,
                        })
                    end)

                    task.wait(0.6)
                end

                flag5 = false
                getgenv()._fishNotifThread = nil
            end)
        end

        getgenv()._fishNotifConn = obj.RE_ObtainedNewFishNotification.OnClientEvent:Connect(function(arg, arg2)
            if not arg then
                return
            end
            table.insert(tbl4, {itemId = arg, inventoryItem = arg2, itemType = fn8(arg)})
            fn9()
        end)
    end

    local function fn6()
        local v8 = fn2()
        if not v8 then
            return nil
        end

        local ok, result = pcall(function()
            return v8:Get("EquippedType")
        end)

        if not ok then
            return nil
        end
        local flag5 = result == "Fishing Rods"
        return flag5
    end

    local function fn7(arg)
        local n = arg or 12

        for i = 1, n do
            if fn6() then
                return true
            end

            pcall(function()
                local rfCancelFishingInputs = obj.RF_CancelFishingInputs

                if rfCancelFishingInputs then
                    rfCancelFishingInputs:InvokeServer()
                end
            end)

            pcall(function()
                local rfEquipToolFromHotbar = obj.RF_EquipToolFromHotbar

                if rfEquipToolFromHotbar then
                    rfEquipToolFromHotbar:FireServer(1)
                end
            end)

            task.wait(0.15)
        end

        local flag5 = fn6() == true
        return flag5
    end

    local function fn8()
        if not localPlayer.Character then
            return
        end

        if fn6() then
            return
        end
        fn7(12)
    end

    flag = false
    str = tostring(math.random(100000, 999999)) .. tostring(os.time())

    local function fn9()
        local flag5 = typeof(queue_on_teleport) == "function" and queue_on_teleport

        if not flag5 then
            local v8 = syn
            flag5 = v8 and typeof(syn.queue_on_teleport) == "function" and syn.queue_on_teleport
        end

        if not flag5 then
            local v8 = fluxus
            flag5 = v8 and typeof(fluxus.queue_on_teleport) == "function" and fluxus.queue_on_teleport
        end

        if not flag5 then
            local v8 = solara
            flag5 = v8 and typeof(solara.queue_on_teleport) == "function" and solara.queue_on_teleport
        end

        if not flag5 then
            local v8 = Delta
            flag5 = v8 and typeof(Delta.queue_on_teleport) == "function" and Delta.queue_on_teleport
        end

        if not flag5 then
            local v8 = getgenv
            flag5 = v8 and typeof(getgenv().queue_on_teleport) == "function" and getgenv().queue_on_teleport
        end

        return flag5
    end

    local function fn10()
        local v8 = fn9()
        if type(v8) ~= "function" then
            return
        end

        for i = 1, 5 do
            pcall(function()
                v8("return")
            end)
        end

        task.wait(0.05)
    end

    sharedQueueAutoExecute = function(arg)
        if flag then
            return
        end
        flag = true
        local v8 = fn9()

        if type(v8) == "function" then
            fn10()
            task.wait(0.2)
            local str2 = arg and "getgenv().__autoTreasureJoin = true\n" or ""
            local str3 = "https://raw.githubusercontent.com/4LynxX/Lynx/refs/heads/main/LynxxMain.lua?nocache=" .. tostring(os.time()) .. "&r=" .. tostring(math.random(1, 9999999))

            if not pcall(function()
                v8(string.format("        if not game:IsLoaded() then game.Loaded:Wait() end\n        local ok, err = pcall(function()\n            local Players = game:GetService(\"Players\")\n            local LocalPlayer = Players.LocalPlayer\n            if not LocalPlayer.Character then\n                LocalPlayer.CharacterAdded:Wait()\n            end\n            local char = LocalPlayer.Character\n            char:WaitForChild(\"HumanoidRootPart\", 10)\n            local hum = char:WaitForChild(\"Humanoid\", 10)\n            if hum then\n                repeat task.wait(0.5) until hum.Health > 0\n            end\n            task.wait(1.5)\n            %s\n            local src = game:HttpGet(\"%s\", true)\n            if src and #src > 10 then\n                loadstring(src)()\n            end\n        end)\n        if not ok then warn(\"[AutoExec] Error:\", err) end\n        ", str2, str3))
            end) then
                flag = false
            end

            return
        end

        flag = false
    end

    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
        flag = false
        fn10()
    end)

    getgenv().sharedQueueAutoExecute = sharedQueueAutoExecute

    fn4 = function(arg)
        return pcall(arg)
    end

    local tbl4 = {}

    task.spawn(function()
        while true do
            if #tbl4 > 0 then
                local v8 = tbl4
                tbl4 = {}

                for i, v9 in ipairs(v8) do
                    task.spawn(v9[1], table.unpack(v9, 2, v9.n))
                end
            end

            task.wait()
        end
    end)

    fn5 = function(arg)
        return function(...)
            local n = #tbl4 + 1
            local v8 = table.pack(arg, ...)
            tbl4[n] = v8
        end
    end

    local function fn11(arg, arg2, arg3)
        local rfUpdateAutoFishingState = obj.RF_UpdateAutoFishingState
        if not rfUpdateAutoFishingState or not pcall(rfUpdateAutoFishingState.InvokeServer, rfUpdateAutoFishingState, arg) then
            return nil
        end

        if arg and arg2 and arg3 then
            return arg2:OnChange("AutoFishing", fn5(function(arg4)
                if arg4 or not arg3() then
                    return
                end

                task.delay(1, function()
                    if arg3() and not arg2:Get("AutoFishing") then
                        pcall(rfUpdateAutoFishingState.InvokeServer, rfUpdateAutoFishingState, true)
                    end
                end)
            end))
        end

        return true
    end

    local module = nil
    tbl = nil
    tbl2 = nil
    flag2 = false
    v = nil
    flag3 = false
    local value = rawget(_G, "http")
    v2 = value or nil
    v3 = lib:Window({Title = "Lynx", Footer = "Fish It"})
    local v8 = v3:AddTab({Name = "Main", Icon = "home"})

    local tbl5 = {
        AnimConn = nil,
        AnimEnabled = false,
        RodThread = nil,
        RodEnabled = false,
        RodEquipBusy = false,
        LockConn = nil,
        LockEnabled = false,
        LockedCFrame = nil,
        NotifConn = nil,
        VFXDisabled = false,
        VFXController = nil,
        VFXOrigHandle = nil,
        VFXOrigAtPoint = nil,
        VFXOrigInstance = nil,
        VFXSupported = false,
        CutsceneCtrl = nil,
        CutsceneOrigPlay = nil,
        CutsceneDisabled = false,
        WaterEnabled = false,
        WaterPlatform = nil,
        WaterAlign = nil,
        WaterConn = nil,
        WaterSurfaceY = nil,
        WaterCharConn = nil,
        MonitorConn = nil,
        MonitorGui = nil,
        MonitorState = nil,
        AbilityVFXEnabled = false,
        AbilityVFXConn = nil,
        AbilityVFXLoop = nil,
        DivingEnabled = false,
        DivingConn = nil,
        DivingThread = nil,
    }

    local v9 = v8:AddSection("Support Features")

    v9:AddToggle({
        Title = "No Fishing Animation",
        Default = false,
        Callback = function(arg)
            local character = localPlayer.Character
            local result = character or localPlayer.CharacterAdded:Wait()
            local v10 = result
            local animator = result.WaitForChild(v10, "Humanoid"):FindFirstChildOfClass("Animator")
            if not animator then
                return
            end

            if arg then
                tbl5.stopAnimHookEnabled = true

                for i, v11 in ipairs(animator:GetPlayingAnimationTracks()) do
                    v11:Stop(0)
                end

                tbl5.stopAnimConn = animator.AnimationPlayed:Connect(function(arg2)
                    if tbl5.stopAnimHookEnabled then
                        task.defer(function()
                            pcall(function()
                                arg2:Stop(0)
                            end)
                        end)
                    end
                end)
            else
                tbl5.stopAnimHookEnabled = false

                if tbl5.stopAnimConn then
                    tbl5.stopAnimConn:Disconnect()
                    tbl5.stopAnimConn = nil
                end
            end
        end,
    })

    _G._autoEquipRodToggleRef = v9:AddToggle({
        Title = "Auto Equip Rod",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl5.RodEnabled then
                    return
                end
                tbl5.RodEnabled = true

                tbl5.RodThread = task.spawn(function()
                    while tbl5.RodEnabled do
                        if not _G.AutoMineActive and not _G.OrbThrowing and not _G.CosmicTrading and not tbl5.RodEquipBusy and fn6() == false then
                            tbl5.RodEquipBusy = true

                            task.spawn(function()
                                fn7(12)
                                tbl5.RodEquipBusy = false
                            end)
                        end

                        task.wait(1)
                    end
                end)
            else
                tbl5.RodEnabled = false
                tbl5.RodEquipBusy = false

                if tbl5.RodThread then
                    task.cancel(tbl5.RodThread)
                    tbl5.RodThread = nil
                end
            end
        end,
    })

    v9:AddToggle({
        Title = "Bypass Radar",
        Default = false,
        Callback = function(arg)
            pcall(function()
                obj.RF_UpdateFishingRadar:InvokeServer(arg)
            end)
        end,
    })

    v9:AddToggle({
        Title = "Lock Position",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl5.LockEnabled then
                    return
                end
                tbl5.LockEnabled = true
                local character = localPlayer.Character
                local result = character or localPlayer.CharacterAdded:Wait()
                tbl5.LockedCFrame = result:WaitForChild("HumanoidRootPart").CFrame

                tbl5.LockConn = RunService.Heartbeat:Connect((function(t, V)
                    return function()
                        if not t.LockEnabled then
                            return
                        end
                        local L = (V.Character and V.Character:FindFirstChild("HumanoidRootPart"))

                        if L then
                            L.CFrame = t.LockedCFrame
                        end
                    end
                end)(tbl5, localPlayer))
            else
                tbl5.LockEnabled = false

                if tbl5.LockConn then
                    tbl5.LockConn:Disconnect()
                    tbl5.LockConn = nil
                end
            end
        end,
    })

    v9:AddToggle({
        Title = "Show Real Ping Panel",
        Default = false,
        Callback = function(enabled)
            local monitorState = tbl5.MonitorState
            local v10 = monitorState

            if not monitorState then
                local monitorState2 = {
                    enabled = false,
                    conn = nil,
                    inputConn = nil,
                    charConn = nil,
                    gui = nil,
                }

                v10 = monitorState2
                tbl5.MonitorState = monitorState2
            end

            v10.enabled = enabled

            if v10.conn then
                v10.conn:Disconnect()
                v10.conn = nil
            end

            if v10.inputConn then
                v10.inputConn:Disconnect()
                v10.inputConn = nil
            end

            if v10.charConn then
                v10.charConn:Disconnect()
                v10.charConn = nil
            end

            if v10.gui then
                v10.gui:Destroy()
                v10.gui = nil
            end

            if not enabled then
                return
            end
            game:GetService("TweenService")
            local Stats = game:GetService("Stats")
            local playerGui = localPlayer:WaitForChild("PlayerGui")
            local lynxPanelMonitor = playerGui:FindFirstChild("LynxPanelMonitor")

            if lynxPanelMonitor then
                lynxPanelMonitor:Destroy()
            end

            local tbl6 = {
                Good = Color3.fromRGB(80, 255, 140),
                Warn = Color3.fromRGB(255, 220, 90),
                Bad = Color3.fromRGB(255, 90, 90),
            }

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LynxPanelMonitor"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            screenGui.DisplayOrder = 999999
            screenGui.IgnoreGuiInset = true
            screenGui.Parent = playerGui
            v10.gui = screenGui
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 0, 0, 30)
            frame.Position = UDim2.new(0.5, 0, 0, 14)
            frame.AnchorPoint = Vector2.new(0.5, 0)
            frame.AutomaticSize = Enum.AutomaticSize.X
            frame.BackgroundColor3 = Color3.fromRGB(18, 8, 2)
            frame.BackgroundTransparency = 0.45
            frame.BorderSizePixel = 0
            frame.Parent = screenGui
            Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
            local uiGradient = Instance.new("UIGradient")

            uiGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 4, 1)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(30, 12, 2)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 28, 4)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30, 12, 2)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 4, 1)),
            })

            uiGradient.Rotation = 0
            uiGradient.Parent = frame
            local uiPadding = Instance.new("UIPadding")
            uiPadding.PaddingLeft = UDim.new(0, 14)
            uiPadding.PaddingRight = UDim.new(0, 14)
            uiPadding.PaddingTop = UDim.new(0, 0)
            uiPadding.PaddingBottom = UDim.new(0, 0)
            uiPadding.Parent = frame
            local frame2 = Instance.new("Frame")
            frame2.Size = UDim2.new(0.7, 0, 0, 1)
            frame2.Position = UDim2.new(0.15, 0, 0, 1)
            frame2.BackgroundColor3 = Color3.fromRGB(255, 160, 60)
            frame2.BackgroundTransparency = 0.5
            frame2.BorderSizePixel = 0
            frame2.Parent = frame
            Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
            local uiGradient2 = Instance.new("UIGradient")

            uiGradient2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.3),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(0.8, 0.3),
                NumberSequenceKeypoint.new(1, 1),
            })

            uiGradient2.Parent = frame2
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(0, 0, 1, 0)
            textLabel.AutomaticSize = Enum.AutomaticSize.X
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "-- ms  ·  CPU --  ·  -- fps"
            textLabel.TextColor3 = Color3.fromRGB(210, 150, 80)
            textLabel.TextSize = 11
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextXAlignment = Enum.TextXAlignment.Center
            textLabel.RichText = true
            textLabel.Parent = frame

            local tbl7 = {
                active = false,
                input = nil,
                startPos = nil,
                startCont = nil,
                changedConn = nil,
            }

            frame.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                tbl7.active = true
                tbl7.startPos = input.Position
                tbl7.startCont = frame.Position

                if tbl7.changedConn then
                    tbl7.changedConn:Disconnect()
                end

                tbl7.changedConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        tbl7.active = false

                        if tbl7.changedConn then
                            tbl7.changedConn:Disconnect()
                            tbl7.changedConn = nil
                        end
                    end
                end)
            end)

            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    tbl7.input = input
                end
            end)

            v10.inputConn = UserInputService.InputChanged:Connect(function(input)
                if input == tbl7.input and tbl7.active then
                    local n = input.Position - tbl7.startPos
                    frame.Position = UDim2.new(tbl7.startCont.X.Scale, tbl7.startCont.X.Offset + n.X, tbl7.startCont.Y.Scale, tbl7.startCont.Y.Offset + n.Y)
                end
            end)

            local tbl8 = {
                currentFPS = 0,
                ping = 0,
                UI_INTERVAL = 1,
                uiAccum = 0,
                frames = 0,
                fpsAccum = 0,
                currentCpuMs = 0,
            }

            local function fn12(arg, arg2, arg3, arg4)
                local good = arg4 and (arg2 <= arg and tbl6.Good or arg3 <= arg and tbl6.Warn or tbl6.Bad) or (arg <= arg2 and tbl6.Good or arg <= arg3 and tbl6.Warn or tbl6.Bad)
                return string.format("<font color=\"rgb(%d,%d,%d)\">", math.floor(good.R * 255), math.floor(good.G * 255), math.floor(good.B * 255))
            end

            v10.conn = RunService.Heartbeat:Connect((function(t, U, z, V, Z)
                return function(L)
                    t.uiAccum = t.uiAccum + L
                    t.frames = t.frames + 1
                    t.fpsAccum = t.fpsAccum + L
                    t.currentCpuMs = t.currentCpuMs * 0.8 + (L * 1000) * 0.2
                    if t.uiAccum < t.UI_INTERVAL then
                        return
                    end
                    t.uiAccum = 0
                    t.currentFPS = (t.fpsAccum > 0 and math.floor(t.frames / t.fpsAccum) or 0)
                    t.frames = 0
                    t.fpsAccum = 0
                    local L = 0

                    pcall(function()
                        L = math.floor(U.Network.ServerStatsItem["Data Ping"]:GetValue())
                    end)

                    if L <= 0 then
                        pcall(function()
                            L = math.floor(z:GetNetworkPing() * 1000)
                        end)
                    end

                    t.ping = math.max(L, 0)
                    local L = math.floor(math.clamp(t.currentCpuMs, 0, 999))
                    local U = "<font color=\"rgb(90,40,10)\"> · </font>"
                    V.Text = string.format("%s%d ms</font>%sCPU %s%d ms</font>%s%s%d fps</font>", Z(t.ping, 50, 100, false), t.ping, "<font color=\"rgb(90,40,10)\"> · </font>", Z(L, 33, 50, false), L, "<font color=\"rgb(90,40,10)\"> · </font>", Z(t.currentFPS, 50, 30, true), t.currentFPS)
                end
            end)(tbl8, Stats, localPlayer, textLabel, fn12))
        end,
    })

    v9:AddToggle({
        Title = "Disable Cutscenes",
        Default = false,
        Callback = function(cutsceneDisabled)
            tbl5.CutsceneDisabled = cutsceneDisabled

            if cutsceneDisabled then
                if not tbl5.CutsceneCtrl then
                    pcall(function()
                        tbl5.CutsceneCtrl = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CutsceneController"))

                        if tbl5.CutsceneCtrl and tbl5.CutsceneCtrl.Play then
                            tbl5.CutsceneOrigPlay = tbl5.CutsceneCtrl.Play

                            tbl5.CutsceneCtrl.Play = function(arg, ...)
                                if not tbl5.CutsceneDisabled then
                                    return tbl5.CutsceneOrigPlay(arg, ...)
                                end
                            end
                        end
                    end)
                end
            elseif tbl5.CutsceneCtrl and tbl5.CutsceneOrigPlay then
                tbl5.CutsceneCtrl.Play = tbl5.CutsceneOrigPlay
            end
        end,
    })

    v9:AddToggle({
        Title = "Disable Obtained Fish Notification",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl5.NotifConn then
                    return
                end
                local playerGui = localPlayer.PlayerGui
                local smallNotification = playerGui:FindFirstChild("Small Notification")
                local smallNotification2 = smallNotification or playerGui:WaitForChild("Small Notification", 5)
                if not smallNotification2 then
                    return
                end
                smallNotification2.Enabled = false

                tbl5.NotifConn = smallNotification2:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if smallNotification2.Enabled then
                        smallNotification2.Enabled = false
                    end
                end)
            else
                if tbl5.NotifConn then
                    tbl5.NotifConn:Disconnect()
                    tbl5.NotifConn = nil
                end

                local smallNotification = localPlayer.PlayerGui:FindFirstChild("Small Notification")

                if smallNotification then
                    smallNotification.Enabled = true
                end
            end
        end,
    })

    v9:AddToggle({
        Title = "Disable Skin Effect",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl5.VFXDisabled then
                    return
                end

                if not tbl5.VFXSupported and (not pcall(function()
                    tbl5.VFXController = require(ReplicatedStorage:WaitForChild("Controllers").VFXController)
                    tbl5.VFXOrigHandle = tbl5.VFXController.Handle
                    tbl5.VFXOrigAtPoint = tbl5.VFXController.RenderAtPoint
                    tbl5.VFXOrigInstance = tbl5.VFXController.RenderInstance
                    tbl5.VFXSupported = true
                end) or not tbl5.VFXSupported) then
                    return
                end

                tbl5.VFXDisabled = true
                tbl5.VFXController.Handle = function() end
                tbl5.VFXController.RenderAtPoint = function() end
                tbl5.VFXController.RenderInstance = function() end
            else
                tbl5.VFXDisabled = false

                if tbl5.VFXController then
                    tbl5.VFXController.Handle = tbl5.VFXOrigHandle
                    tbl5.VFXController.RenderAtPoint = tbl5.VFXOrigAtPoint
                    tbl5.VFXController.RenderInstance = tbl5.VFXOrigInstance
                end
            end
        end,
    })

    _G._wowToggleRef = v9:AddToggle({
        Title = "Walk On Water",
        Default = false,
        Callback = function(waterEnabled)
            tbl5.WaterEnabled = waterEnabled

            local function fn12()
                if tbl5.WaterConn then
                    tbl5.WaterConn:Disconnect()
                    tbl5.WaterConn = nil
                end

                if tbl5.WaterCharConn then
                    tbl5.WaterCharConn:Disconnect()
                    tbl5.WaterCharConn = nil
                end

                local wwPart = workspace:FindFirstChild("WW_Part")

                if wwPart then
                    wwPart:Destroy()
                end

                tbl5.WaterPlatform = nil
                tbl5.WaterSurfaceY = nil
            end

            if not waterEnabled then
                fn12()
                return
            end
            fn12()

            local function fn13(arg, arg2)
                local filterDescendantsInstances = {arg2}

                pcall(function()
                    local wwPart = workspace:FindFirstChild("WW_Part")

                    if wwPart then
                        table.insert(filterDescendantsInstances, wwPart)
                    end

                    local characters = workspace:FindFirstChild("Characters")
                    local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
                    local vehicles = workspace:FindFirstChild("Vehicles")

                    if characters then
                        table.insert(filterDescendantsInstances, characters)
                    end

                    if cosmeticFolder then
                        table.insert(filterDescendantsInstances, cosmeticFolder)
                    end

                    if vehicles then
                        table.insert(filterDescendantsInstances, vehicles)
                    end
                end)

                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                raycastParams.IgnoreWater = false
                local hit = workspace:Raycast(Vector3.new(arg.X, arg.Y + 5, arg.Z), Vector3.new(0, -150, 0), raycastParams)
                if not hit then
                    return nil
                end
                return hit.Position.Y
            end

            local function fn14(arg)
                local wwPart = workspace:FindFirstChild("WW_Part")

                if wwPart then
                    wwPart:Destroy()
                end

                tbl5.WaterPlatform = nil
                tbl5.WaterSurfaceY = nil

                if tbl5.WaterConn then
                    tbl5.WaterConn:Disconnect()
                    tbl5.WaterConn = nil
                end

                if not tbl5.WaterEnabled then
                    return
                end
                local humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 5)
                if not humanoidRootPart or not tbl5.WaterEnabled then
                    return
                end
                local part = Instance.new("Part")
                part.Name = "WW_Part"
                part.Size = Vector3.new(20, 1, 20)
                part.Anchored = true
                part.CanCollide = true
                part.Transparency = 1
                part.CastShadow = false
                part.CanQuery = false
                part.CanTouch = false
                part.Parent = workspace
                tbl5.WaterPlatform = part
                local n = 0

                tbl5.WaterConn = RunService.Heartbeat:Connect((function(m, U, g, t, Z, J, _, z)
                    return function()
                        if not m.WaterEnabled then
                            return
                        end

                        if not U.Parent then
                            g()
                            return
                        end
                        n = n + 1

                        if n >= t then
                            n = 0
                            local L = Z(U.Position, J)

                            if L then
                                m.WaterSurfaceY = L
                            else
                                m.WaterSurfaceY = nil
                            end
                        end

                        local L = (m.WaterSurfaceY or _)
                        z.CFrame = CFrame.new(U.Position.X, L, U.Position.Z)
                    end
                end)(tbl5, humanoidRootPart, fn12, 10, fn13, arg, -1.8, part))
            end

            tbl5.WaterCharConn = localPlayer.CharacterAdded:Connect(function(character)
                if tbl5.WaterEnabled then
                    task.spawn(fn14, character)
                end
            end)

            local character = localPlayer.Character

            if character then
                task.spawn(fn14, character)
            end
        end,
    })

    _G._divingGearToggleRef = v9:AddToggle({
        Title = "Auto Equip Diving Gear",
        Default = false,
        Callback = function(divingGearEnabled)
            _G._divingGearEnabled = divingGearEnabled
            tbl5.DivingEnabled = divingGearEnabled

            if tbl5.DivingConn then
                pcall(function()
                    tbl5.DivingConn:Disconnect()
                end)

                tbl5.DivingConn = nil
            end

            if tbl5.DivingThread then
                pcall(task.cancel, tbl5.DivingThread)
                tbl5.DivingThread = nil
            end

            if not divingGearEnabled then
                pcall(function()
                    local replion = require(game:GetService("ReplicatedStorage").Packages.Replion).Client:GetReplion("Data")

                    if replion and replion:Get("EquippedOxygenTankId") == 105 then
                        obj.RF_UnequipOxygenTank:InvokeServer()
                    end
                end)

                return
            end

            local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
            local Data = require(ReplicatedStorage3.Packages.Replion).Client:WaitReplion("Data")
            if not Data then
                return
            end

            local function fn12()
                pcall(function()
                    if Data:Get("EquippedOxygenTankId") ~= 105 and not obj.RF_EquipOxygenTank:InvokeServer(105) then
                        local rfPurchaseGear = obj.RF_PurchaseGear

                        if rfPurchaseGear and rfPurchaseGear:InvokeServer(105) then
                            obj.RF_EquipOxygenTank:InvokeServer(105)
                        end
                    end
                end)
            end

            fn12()

            tbl5.DivingConn = Data:OnChange("EquippedOxygenTankId", function(arg)
                if not tbl5.DivingEnabled then
                    return
                end

                if arg == 105 then
                    return
                end

                if tbl5.DivingThread then
                    pcall(task.cancel, tbl5.DivingThread)
                end

                tbl5.DivingThread = task.spawn(function()
                    task.wait(0.5)
                    if not tbl5.DivingEnabled then
                        return
                    end
                    fn12()
                end)
            end)
        end,
    })

    v9:AddToggle({
        Title = "Hide Other Players",
        Default = false,
        NoSave = true,
        Callback = (function()
            local flag5 = false
            local tbl6 = {}
            local tbl7 = {}
            local tbl8 = {}
            local connection = nil
            local connection2 = nil
            local vector = Vector3.zero

            local function fn12(arg)
                if arg:IsA("BasePart") then
                    arg.Transparency = 1
                    arg.LocalTransparencyModifier = 1
                elseif arg:IsA("Decal") then
                    arg.Transparency = 1
                elseif arg:IsA("SpecialMesh") then
                    arg.Scale = vector
                elseif not arg:IsA("ParticleEmitter") and not arg:IsA("Trail") and not arg:IsA("Beam") then
                    if arg:IsA("BillboardGui") or arg:IsA("SurfaceGui") then
                        arg.Enabled = false
                    end
                else
                    arg.Enabled = false
                end
            end

            local function fn13(arg)
                if arg == localPlayer then
                    return
                end
                local character = arg.Character
                if not character or tbl6[arg] then
                    return
                end
                local tbl9 = {}
                tbl6[arg] = tbl9
                local v10 = next
                local descendants, v11 = character:GetDescendants()

                for k, v12 in v10, descendants, v11 do
                    if v12:IsA("BasePart") then
                        tbl9[v12] = {v12.Transparency, v12.LocalTransparencyModifier}
                        v12.Transparency = 1
                        v12.LocalTransparencyModifier = 1
                    elseif v12:IsA("Decal") then
                        tbl9[v12] = {v12.Transparency}
                        v12.Transparency = 1
                    elseif v12:IsA("SpecialMesh") then
                        tbl9[v12] = {v12.Scale}
                        v12.Scale = vector
                    elseif not v12:IsA("ParticleEmitter") and not v12:IsA("Trail") and not v12:IsA("Beam") then
                        if v12:IsA("BillboardGui") or v12:IsA("SurfaceGui") then
                            tbl9[v12] = {v12.Enabled}
                            v12.Enabled = false
                        end
                    else
                        tbl9[v12] = {v12.Enabled}
                        v12.Enabled = false
                    end
                end

                if tbl7[arg] then
                    tbl7[arg]:Disconnect()
                end

                tbl7[arg] = character.DescendantAdded:Connect(function(descendant)
                    if flag5 then
                        fn12(descendant)
                    end
                end)
            end

            local function fn14(arg)
                local v10 = nil
                local v11 = tbl6[arg]
                if not v11 then
                    return
                end

                if arg.Character then
                    local v12 = next

                    while true do
                        local v13, v14 = v12(v11, v10)
                        if v13 == nil then
                            break
                        end
                        v10 = v13

                        if v13 and v13.Parent then
                            if v13:IsA("BasePart") then
                                v13.Transparency = v14[1]
                                v13.LocalTransparencyModifier = v14[2]
                            elseif v13:IsA("Decal") then
                                v13.Transparency = v14[1]
                            elseif v13:IsA("SpecialMesh") then
                                v13.Scale = v14[1]
                            elseif not v13:IsA("ParticleEmitter") and not v13:IsA("Trail") and not v13:IsA("Beam") then
                                if v13:IsA("BillboardGui") or v13:IsA("SurfaceGui") then
                                    v13.Enabled = v14[1]
                                end
                            else
                                v13.Enabled = v14[1]
                            end
                        end
                    end
                end

                tbl6[arg] = nil

                if tbl7[arg] then
                    tbl7[arg]:Disconnect()
                    tbl7[arg] = nil
                end
            end

            local function fn15(arg)
                return arg.CharacterAdded:Connect(function()
                    task.defer(function()
                        if flag5 then
                            tbl6[arg] = nil

                            if tbl7[arg] then
                                tbl7[arg]:Disconnect()
                                tbl7[arg] = nil
                            end

                            fn13(arg)
                        end
                    end)
                end)
            end

            return function(arg)
                local v10 = nil
                flag5 = arg

                if arg then
                    local v11 = next
                    local players, v12 = Players:GetPlayers()

                    for k, v13 in v11, players, v12 do
                        if v13 ~= localPlayer then
                            fn13(v13)
                            tbl8[v13] = fn15(v13)
                        end
                    end

                    connection = Players.PlayerAdded:Connect(function(player)
                        tbl8[player] = fn15(player)

                        task.defer(function()
                            if flag5 then
                                fn13(player)
                            end
                        end)
                    end)

                    connection2 = Players.PlayerRemoving:Connect(function(player)
                        tbl6[player] = nil

                        if tbl7[player] then
                            tbl7[player]:Disconnect()
                            tbl7[player] = nil
                        end

                        if tbl8[player] then
                            tbl8[player]:Disconnect()
                            tbl8[player] = nil
                        end
                    end)

                    lib:MakeNotify({
                        Title = "Remove Players",
                        Content = "Player lain disembunyikan.",
                        Delay = 2,
                    })
                else
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end

                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end

                    local v11 = next

                    while true do
                        local v12, v13 = v11(tbl8, v10)
                        if v12 == nil then
                            break
                        end
                        v10 = v12
                        v13:Disconnect()
                        tbl8[v12] = nil
                    end

                    local v12 = next
                    local players, v13 = Players:GetPlayers()

                    for k, v14 in v12, players, v13 do
                        fn14(v14)
                    end

                    lib:MakeNotify({
                        Title = "Remove Players",
                        Content = "Player lain ditampilkan kembali.",
                        Delay = 2,
                    })
                end
            end
        end)(),
    })

    v9:AddToggle({
        Title = "Disable Ability VFX",
        Default = false,
        Callback = function(abilityVFXEnabled)
            tbl5.AbilityVFXEnabled = abilityVFXEnabled

            if tbl5.AbilityVFXConn then
                tbl5.AbilityVFXConn:Disconnect()
                tbl5.AbilityVFXConn = nil
            end

            if tbl5.AbilityVFXLoop then
                tbl5.AbilityVFXLoop:Disconnect()
                tbl5.AbilityVFXLoop = nil
            end

            if not abilityVFXEnabled then
                return
            end

            for i, descendant in ipairs(workspace:GetDescendants()) do
                if descendant:GetAttribute("AbilityVFX") == true then
                    pcall(function()
                        descendant:Destroy()
                    end)
                end
            end

            tbl5.AbilityVFXLoop = workspace.DescendantAdded:Connect(function(descendant)
                if not tbl5.AbilityVFXEnabled then
                    return
                end

                task.defer(function()
                    if descendant and descendant.Parent and descendant:GetAttribute("AbilityVFX") == true then
                        pcall(function()
                            descendant:Destroy()
                        end)
                    end
                end)
            end)
        end,
    })

    local tbl6 = {enabled = false, conn = nil}

    v8:AddSection("Stable Result Good/Perfection"):AddToggle({
        Title = "Stable Result Good/Perfection",
        Default = false,
        Callback = function(enabled)
            if enabled == tbl6.enabled then
                return
            end
            tbl6.enabled = enabled

            if tbl6.conn then
                tbl6.conn:Disconnect()
                tbl6.conn = nil
            end

            if not enabled then
                fn11(false)

                pcall(function()
                    localPlayer:SetAttribute("Loading", false)
                end)

                return
            end

            task.spawn(function()
                local v10 = nil

                for i = 1, 20 do
                    local v11 = fn2()
                    v10 = v11
                    if v11 then
                        break
                    end
                    task.wait(0.5)
                end

                if not v10 or not tbl6.enabled then
                    return
                end

                tbl6.conn = fn11(true, v10, function()
                    return tbl6.enabled
                end)

                if tbl6.conn then
                    pcall(function()
                        localPlayer:SetAttribute("Loading", nil)
                    end)
                end
            end)
        end,
    })

    local v10 = v8:AddSection("Skip Rarity", false)
    local tbl7 = {enabled = false, targetRarity = "None", connection = nil}

    getgenv()._shouldSkipRarity = function(arg)
        if not tbl7.enabled or not arg or type(arg) ~= "table" or not arg.SelectedRarity then
            return false
        end
        local v11 = fn(ReplicatedStorage.Shared.TierUtility)
        if not v11 then
            return false
        end
        local tierFromRarity = v11:GetTierFromRarity(arg.SelectedRarity)
        if not tierFromRarity or not tierFromRarity.Tier then
            return false
        end

        local v12 = ({
            "Common",
            "Uncommon",
            "Rare",
            "Epic",
            "Legendary",
            "Mythic",
            "Secret",
            "Forgotten",
        })[tierFromRarity.Tier]

        if not v12 then
            return false
        end
        local targetRarity = tbl7.targetRarity

        if type(targetRarity) == "table" then
            local flag5 = false
            local flag6 = false
            local n = 0

            for k, v13 in pairs(targetRarity) do
                local flag7 = type(k) == "number" and v13 or k
                local flag8 = type(k) == "number" or v13 == true

                if flag8 and type(flag7) == "string" then
                    n = n + 1

                    if flag7:lower() == v12:lower() then
                        flag5 = true
                    end

                    if flag7:lower() == "none" then
                        flag6 = true
                    end
                end
            end

            if not flag5 and not flag6 and n > 0 then
                return true
            end
        elseif type(targetRarity) == "string" and targetRarity:lower() ~= "none" and targetRarity:lower() ~= v12:lower() then
            return true
        end

        return false
    end

    v10:AddParagraph({
        Title = "Note",
        Content = "This Skip Rarity feature only works for the Legit Fishing, Instant Fishing, and Instant Fast Reel features.",
    })

    v10:AddDropdown({
        Title = "Target Rarity",
        Options = {
            "None",
            "Common",
            "Uncommon",
            "Rare",
            "Epic",
            "Legendary",
            "Mythic",
            "Secret",
            "Forgotten",
        },
        Multi = true,
        Default = "None",
        Callback = function(targetRarity)
            tbl7.targetRarity = targetRarity
        end,
    })

    v10:AddToggle({
        Title = "Enable Skip Rarity",
        Default = false,
        Callback = function(enabled)
            tbl7.enabled = enabled

            if enabled and not getgenv()._skipRarityHooked_V8 then
                getgenv()._skipRarityHooked_V8 = true
                local fishingRuntime = ReplicatedStorage.Modules:FindFirstChild("FishingRuntime")
                local network = fishingRuntime and fishingRuntime:FindFirstChild("Network") and fn(fishingRuntime.Network)

                if type(network) == "table" and network.Cast then
                    local cast = network.Cast

                    network.Cast = function(...)
                        local v11, v12 = cast(...)
                        if not v11 or not getgenv()._shouldSkipRarity(v12) then
                            return v11, v12
                        end
                        getgenv()._skipRarityAt = os.clock()
                        return false
                    end

                    localPlayer:GetAttributeChangedSignal("FishingCooldownTime"):Connect(function()
                        local now = os.clock()
                        local skipRarityAt = getgenv()._skipRarityAt
                        local n = skipRarityAt or 0

                        if now - n < 3 and localPlayer:GetAttribute("FishingCooldownTime") ~= nil then
                            localPlayer:SetAttribute("FishingCooldownTime", nil)
                        end
                    end)
                end

                local v11 = fn(ReplicatedStorage.Controllers.FishingController)

                if type(v11) == "table" and v11.SendFishingRequestToServer then
                    local sendFishingRequestToServer = v11.SendFishingRequestToServer

                    v11.SendFishingRequestToServer = function(arg, ...)
                        local v12 = sendFishingRequestToServer(arg, ...)
                        if type(v12) ~= "table" or not v12.Success or not getgenv()._shouldSkipRarity(v12.State) then
                            return v12
                        end

                        task.spawn(pcall, function()
                            obj.RF_CancelFishingInputs:InvokeServer()
                        end)

                        return {Success = false, Message = "Canceled"}
                    end
                end
            end
        end,
    })

    local tbl8 = {
        active = false,
        autoShaking = false,
        settings = {clickWait = 0.05, shakeDelay = 0.05},
        fishThread = nil,
        shakeThread = nil,
        watchConn = nil,
        respawnConn = nil,
    }

    local v11 = nil

    local function fn12()
        if not module then
            local controllers = ReplicatedStorage:FindFirstChild("Controllers")
            local fishingController = controllers and controllers:FindFirstChild("FishingController")
            if not fishingController then
                return nil
            end
            module = require(fishingController)
        end

        return module
    end

    local function fn13()
        if v11 then
            return v11
        end
        v11 = fn2()
        return v11
    end

    local v12 = v8:AddSection("Legit Fishing", false)

    v12:AddInput({
        Title = "Shake Delay",
        Default = "0.05",
        Callback = function(arg)
            local clickWait = tonumber(arg)

            if clickWait and clickWait >= 0 then
                tbl8.settings.clickWait = clickWait
                tbl8.settings.shakeDelay = clickWait
            end
        end,
    })

    v12:AddToggle({
        Title = "Enable Legit Fishing",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl8.active or flag4 then
                    return
                end
                local v13 = fn12()
                local v14 = fn13()
                if not v13 or not v14 then
                    return
                end

                tbl8.watchConn = fn11(true, v14, function()
                    return tbl8.active
                end)

                if not tbl8.watchConn then
                    return
                end
                flag4 = true
                tbl8.active = true

                tbl8.respawnConn = localPlayer.CharacterAdded:Connect(function(character)
                    if not tbl8.active then
                        return
                    end
                    local humanoid = character:WaitForChild("Humanoid", 10)

                    if humanoid then
                        repeat
                            task.wait(0.3)
                        until humanoid.Health > 0
                    end

                    task.wait(1)

                    if tbl8.active then
                        fn8()
                    end
                end)

                tbl8.fishThread = task.spawn(function()
                    fn8()

                    while tbl8.active do
                        if not _G.AutoMineActive and not _G.OrbThrowing then
                            pcall(function()
                                if v13:GetCurrentGUID() then
                                    v13:RequestFishingMinigameClick()
                                end
                            end)

                            task.wait(tbl8.settings.clickWait)
                        else
                            task.wait(1)
                        end
                    end
                end)
            elseif tbl8.active then
                flag4 = false
                tbl8.active = false

                if tbl8.watchConn then
                    tbl8.watchConn:Disconnect()
                    tbl8.watchConn = nil
                end

                if tbl8.respawnConn then
                    tbl8.respawnConn:Disconnect()
                    tbl8.respawnConn = nil
                end

                if tbl8.fishThread then
                    task.cancel(tbl8.fishThread)
                    tbl8.fishThread = nil
                end

                fn11(false)
            end
        end,
    })

    v12:AddToggle({
        Title = "Auto Shake (klik terus)",
        Default = false,
        Callback = function(arg)
            if arg then
                local v13 = fn12()
                if not v13 then
                    return
                end
                tbl8.autoShaking = true

                tbl8.shakeThread = task.spawn(function()
                    while tbl8.autoShaking do
                        if not _G.AutoMineActive and not _G.OrbThrowing then
                            pcall(function()
                                v13:RequestFishingMinigameClick()
                            end)

                            task.wait(tbl8.settings.shakeDelay)
                        else
                            task.wait(1)
                        end
                    end
                end)
            else
                tbl8.autoShaking = false

                if tbl8.shakeThread then
                    task.cancel(tbl8.shakeThread)
                    tbl8.shakeThread = nil
                end
            end
        end,
    })

    local function fn14(arg, arg2, arg3, arg4, arg5)
        local fishingRuntime = ReplicatedStorage.Modules.FishingRuntime
        local fishingController = ReplicatedStorage.Controllers.FishingController
        if require(fishingRuntime.Core):GetSnapshot().Phase ~= "Idle" then
            return
        end

        if arg and arg5 and arg5.origin then
            local delay = task.delay
            local delayTime = arg5.delayTime
            local n = delayTime or 0
            delay(n, require(fishingController.FishCaughtVisual).playCaughtFishVisual, localPlayer, arg5.origin, arg, arg2)
        end

        local itemData = arg and require(ReplicatedStorage.Shared.ItemUtility):GetItemData(arg)
        local forcedProbability = itemData

        if itemData then
            local probability = itemData.Probability
            forcedProbability = probability or itemData.ForcedProbability
        end

        local v13 = forcedProbability

        if forcedProbability then
            local sounds = require(ReplicatedStorage.Shared.Soundbook).Sounds
            local str2 = forcedProbability.Chance <= 0.0005 and "SuperRareCatch" or forcedProbability.Chance <= 0.004 and "RareCatch" or "Catch"
            v13 = sounds[str2]
        end

        if v13 then
            v13:Play()
        end

        local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        AnimationController:DestroyActiveAnimationTracks()
        local flag5

        if AnimationController:IsDisabled("FishCaught") then
            flag5 = false
        else
            flag5 = true
        end

        if flag5 then
            local flag6 = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Swimming

            if flag6 then
                flag5 = false
            else
                flag5 = true
            end
        end

        if flag5 then
            flag5 = AnimationController:PlayAnimation("FishCaught")
        end

        if flag5 then
            require(fishingController.RodEffectCallbacks).FireAndReplicate("FishCaught", character)
        end

        local function fn15()
            AnimationController:DestroyActiveAnimationTracks({"EquipIdle"})
            require(fishingRuntime.Equipment).RefreshIdle()
        end

        if flag5 then
            flag5.Stopped:Once(fn15)
        else
            fn15()
        end
    end

    local function fn15()
        if not obj.RE_FishCaught then
            return nil
        end

        return obj.RE_FishCaught.OnClientEvent:Connect(function(...)
            pcall(fn14, ...)
        end)
    end

    local tbl9 = {
        active = false,
        castMode = "normal",
        completeDelay = 0.04,
        loopThread = nil,
        respawnConn = nil,
        caughtConn = nil,
    }

    local v13 = v8:AddSection("Instant Fishing")

    v13:AddDropdown({
        Title = "Mode Cast",
        Options = {"Normal", "Perfect"},
        Default = "Normal",
        Callback = function(arg)
            tbl9.castMode = arg:lower()
        end,
    })

    v13:AddInput({
        Title = "Instant Delay",
        Default = "0.04",
        Callback = function(arg)
            local completeDelay = tonumber(arg)

            if completeDelay then
                tbl9.completeDelay = completeDelay
            end
        end,
    })

    v13:AddToggle({
        Title = "Enable Instant",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl9.active then
                    return
                end

                if not obj.IsInitialized then
                    return
                end
                tbl9.active = true

                if tbl9.respawnConn then
                    tbl9.respawnConn:Disconnect()
                    tbl9.respawnConn = nil
                end

                if tbl9.caughtConn then
                    tbl9.caughtConn:Disconnect()
                end

                tbl9.caughtConn = fn15()

                tbl9.respawnConn = localPlayer.CharacterAdded:Connect(function(character)
                    if not tbl9.active then
                        return
                    end
                    local humanoid = character:WaitForChild("Humanoid", 10)

                    if humanoid then
                        repeat
                            task.wait(0.3)
                        until humanoid.Health > 0
                    end

                    task.wait(1)

                    if tbl9.active then
                        fn8()
                    end
                end)

                tbl9.loopThread = task.spawn(function()
                    local n, n2, n3, n4, now, flag5, v14, v15, v16, ok, result, n5
                    n5 = 1

                    while true do
                        if n5 == 1 then
                            n = 734427128
                            fn8()

                            if tbl9.active then
                                n5 = 2
                            else
                                n5 = 22
                            end
                        elseif n5 == 2 then
                            n2 = nil
                            n3 = nil
                            n4 = nil
                            n5 = 3
                        elseif n5 == 3 then
                            if tbl9.active then
                                n5 = 4
                            else
                                n5 = 21
                            end
                        elseif n5 == 4 then
                            if not _G.AutoMineActive and not _G.OrbThrowing then
                                n5 = 6
                            else
                                n5 = 5
                            end
                        elseif n5 == 5 then
                            task.wait(1)
                            n5 = 3
                        elseif n5 == 6 then
                            if obj.IsInitialized then
                                n5 = 7
                            else
                                n5 = 20
                            end
                        elseif n5 == 7 then
                            now = os.clock()

                            fn4(function()
                                n3 = 855196327
                                n4 = 562708434
                                obj.RF_ChargeFishingRod:InvokeServer(nil, nil, now, nil)
                            end)

                            if tbl9.castMode == "perfect" then
                                n5 = 9
                            else
                                n5 = 8
                            end
                        elseif n5 == 8 then
                            flag5 = false
                            n5 = 10
                        elseif n5 == 9 then
                            flag5 = true
                            n5 = 10
                        elseif n5 == 10 then
                            if flag5 then
                                n5 = 11
                            else
                                n5 = 12
                            end
                        elseif n5 == 11 then
                            flag5 = 0.95
                            n5 = 12
                        elseif n5 == 12 then
                            if flag5 then
                                n5 = 14
                            else
                                n5 = 13
                            end
                        elseif n5 == 13 then
                            flag5 = 0
                            n5 = 14
                        elseif n5 == 14 then
                            v14, v15, v16 = fn4(function()
                                n2 = 956848364
                                return obj.RF_RequestMinigame:InvokeServer(-1.2, flag5, now)
                            end)

                            if v14 and v15 and getgenv()._shouldSkipRarity then
                                n5 = 15
                            else
                                n5 = 16
                            end
                        elseif n5 == 15 then
                            ok, result = pcall(getgenv()._shouldSkipRarity, v16)

                            if ok and result then
                                n5 = 19
                            else
                                n5 = 16
                            end
                        elseif n5 == 16 then
                            if tbl9.completeDelay > 0 then
                                n5 = 17
                            else
                                n5 = 18
                            end
                        elseif n5 == 17 then
                            task.wait(tbl9.completeDelay)
                            n5 = 18
                        elseif n5 == 18 then
                            fn4(function()
                                obj.RE_FishingCompleted:FireServer()
                            end)

                            task.wait(0.1)
                            n5 = 3
                        elseif n5 == 19 then
                            fn4(function()
                                return obj.RF_CancelFishingInputs:InvokeServer()
                            end)

                            n5 = 3
                        elseif n5 == 20 then
                            task.wait(1)
                            n5 = 3
                        elseif n5 == 21 then
                            return
                        elseif n5 == 22 then
                            return
                        end
                    end
                end)
            else
                tbl9.active = false

                if tbl9.loopThread then
                    task.cancel(tbl9.loopThread)
                    tbl9.loopThread = nil
                end

                if tbl9.respawnConn then
                    tbl9.respawnConn:Disconnect()
                    tbl9.respawnConn = nil
                end

                if tbl9.caughtConn then
                    tbl9.caughtConn:Disconnect()
                    tbl9.caughtConn = nil
                end

                fn4(function()
                    obj.RF_CancelFishingInputs:InvokeServer()
                end)
            end
        end,
    })

    local tbl10 = {
        active = false,
        castMode = "normal",
        settings = {completeDelay = 0.02, baitSpeed = 99999, notifMult = 1.3},
        loopThread = nil,
        animThread = nil,
        respawnConn = nil,
        connections = {},
        curveUtil = nil,
        origCurve = nil,
        notifCtrl = nil,
        origDeliver = nil,
        notifHooked = false,
    }

    local v14 = v8:AddSection("Instant Fast Reel [BETA]", false)

    v14:AddDropdown({
        Title = "Mode",
        Default = "normal",
        Options = {"normal", "perfect"},
        Callback = function(castMode)
            tbl10.castMode = castMode
        end,
    })

    v14:AddInput({
        Title = "Complete Delay",
        Default = "0.02",
        Callback = function(arg)
            local completeDelay = tonumber(arg)

            if completeDelay and completeDelay >= 0 then
                tbl10.settings.completeDelay = completeDelay
            end
        end,
    })

    v14:AddToggle({
        Title = "Instant Fast Reel",
        Default = false,
        Callback = function(arg)
            if arg then
                if not obj.IsInitialized then
                    lib:MakeNotify({
                        Title = "IFR",
                        Description = "NetEvents belum siap.",
                        Delay = 2,
                    })

                    return
                end

                if flag4 then
                    return
                end

                for i, connection in ipairs(tbl10.connections) do
                    connection:Disconnect()
                end

                tbl10.connections = {}
                flag4 = true
                tbl10.active = true

                pcall(function()
                    local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
                    tbl10.curveUtil = CurveUtil
                    tbl10.origCurve = CurveUtil.GetCurveBetween

                    CurveUtil.GetCurveBetween = function(arg2)
                        if tbl10.active and tbl10.origCurve then
                            local finish = arg2.finish
                            local finish2 = finish or arg2.finish
                            local baitSpeed = tbl10.settings.baitSpeed
                            local n = baitSpeed or 999
                            if n >= 99 then
                                return {CFrame.new(finish2), CFrame.new(finish2)}
                            end
                            local v15 = tbl10.origCurve(arg2)
                            local n2 = #v15
                            local n3 = math.max(2, math.floor(n2 / tbl10.settings.baitSpeed))
                            local tbl11 = {}

                            for i = 1, n3 do
                                local n4 = math.clamp(math.round((i - 1) / (n3 - 1) * (n2 - 1)) + 1, 1, n2)
                                table.insert(tbl11, v15[n4])
                            end

                            return tbl11
                        end

                        local origCurve = tbl10.origCurve
                        local tbl11 = origCurve and tbl10.origCurve(arg2) or {}
                        return tbl11
                    end
                end)

                pcall(function()
                    local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
                    tbl10.notifCtrl = TextNotificationController
                    tbl10.origDeliver = TextNotificationController.DeliverNotification
                    tbl10.notifHooked = true

                    TextNotificationController.DeliverNotification = function(arg2, arg3)
                        local v15 = table.clone(arg3)

                        if v15.CustomDuration then
                            v15.CustomDuration = v15.CustomDuration * tbl10.settings.notifMult
                        else
                            local n = 3

                            if v15.Type == "Location" then
                                n = 4
                            elseif v15.Type == "Event" then
                                n = 5
                            end

                            v15.CustomDuration = n * tbl10.settings.notifMult
                        end

                        return tbl10.origDeliver(arg2, v15)
                    end
                end)

                local tbl11 = {["Bait Dive"] = true, ["Water Impact"] = true}
                local cosmeticFolder = workspace:WaitForChild("CosmeticFolder", 10)

                if cosmeticFolder and cosmeticFolder:IsA("Folder") then
                    for i, child in ipairs(cosmeticFolder:GetChildren()) do
                        if tbl11[child.Name] then
                            child.Parent = nil
                        end
                    end

                    table.insert(tbl10.connections, cosmeticFolder.ChildAdded:Connect(function(child)
                        if tbl10.active and tbl11[child.Name] then
                            child.Parent = nil
                        end
                    end))
                end

                table.insert(tbl10.connections, fn15())

                if tbl10.respawnConn then
                    tbl10.respawnConn:Disconnect()
                    tbl10.respawnConn = nil
                end

                tbl10.respawnConn = localPlayer.CharacterAdded:Connect(function(character)
                    if not tbl10.active then
                        return
                    end
                    local humanoid = character:WaitForChild("Humanoid", 10)

                    if humanoid then
                        repeat
                            task.wait(0.3)
                        until humanoid.Health > 0
                    end

                    task.wait(1)

                    if tbl10.active then
                        fn8()
                    end
                end)

                tbl10.animThread = task.spawn(function()
                    while tbl10.active do
                        if not _G.AutoMineActive and not _G.OrbThrowing then
                            local character = localPlayer.Character

                            if character then
                                local humanoid = character:FindFirstChildOfClass("Humanoid")

                                if humanoid then
                                    local animator = humanoid:FindFirstChildOfClass("Animator")

                                    if animator then
                                        for k, v15 in pairs(animator:GetPlayingAnimationTracks()) do
                                            if v15.Name:find("Reel") or v15.Name:find("Fish") and v15.Name ~= "FishCaught" then
                                                v15:Stop(0)
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        task.wait(0.3)
                    end
                end)

                tbl10.loopThread = task.spawn(function()
                    local n, n2, n3, n4, n5, now, flag5, v15, v16, v17, ok, result, n6
                    n6 = 1

                    while true do
                        if n6 == 1 then
                            n = 62151605
                            fn8()

                            if tbl10.active then
                                n6 = 2
                            else
                                n6 = 20
                            end
                        elseif n6 == 2 then
                            n2 = nil
                            n3 = nil
                            n4 = nil
                            n5 = nil
                            n6 = 3
                        elseif n6 == 3 then
                            if tbl10.active then
                                n6 = 4
                            else
                                n6 = 19
                            end
                        elseif n6 == 4 then
                            if not _G.AutoMineActive and not _G.OrbThrowing then
                                n6 = 6
                            else
                                n6 = 5
                            end
                        elseif n6 == 5 then
                            task.wait(1)
                            n6 = 3
                        elseif n6 == 6 then
                            if obj.IsInitialized then
                                n6 = 7
                            else
                                n6 = 18
                            end
                        elseif n6 == 7 then
                            now = os.clock()

                            fn4(function()
                                obj.RF_ChargeFishingRod:InvokeServer(nil, nil, now, nil)
                            end)

                            if tbl10.castMode == "perfect" then
                                n6 = 9
                            else
                                n6 = 8
                            end
                        elseif n6 == 8 then
                            flag5 = false
                            n6 = 10
                        elseif n6 == 9 then
                            flag5 = true
                            n6 = 10
                        elseif n6 == 10 then
                            if flag5 then
                                n6 = 11
                            else
                                n6 = 12
                            end
                        elseif n6 == 11 then
                            flag5 = 0.95
                            n6 = 12
                        elseif n6 == 12 then
                            if flag5 then
                                n6 = 14
                            else
                                n6 = 13
                            end
                        elseif n6 == 13 then
                            flag5 = 0
                            n6 = 14
                        elseif n6 == 14 then
                            v15, v16, v17 = fn4(function()
                                n2 = 57855744
                                n3 = 365946413
                                return obj.RF_RequestMinigame:InvokeServer(-1.2, flag5, now)
                            end)

                            if v15 and v16 and getgenv()._shouldSkipRarity then
                                n6 = 15
                            else
                                n6 = 16
                            end
                        elseif n6 == 15 then
                            ok, result = pcall(getgenv()._shouldSkipRarity, v17)

                            if ok and result then
                                n6 = 17
                            else
                                n6 = 16
                            end
                        elseif n6 == 16 then
                            task.wait(tbl10.settings.completeDelay)

                            fn4(function()
                                n4 = 936154952
                                n5 = 493484642
                                obj.RE_FishingCompleted:FireServer()
                            end)

                            task.wait(0.1)
                            n6 = 3
                        elseif n6 == 17 then
                            fn4(function()
                                return obj.RF_CancelFishingInputs:InvokeServer()
                            end)

                            n6 = 3
                        elseif n6 == 18 then
                            task.wait(1)
                            n6 = 3
                        elseif n6 == 19 then
                            return
                        elseif n6 == 20 then
                            return
                        end
                    end
                end)

                lib:MakeNotify({
                    Title = "Instant Fast Reel",
                    Description = "Mode: " .. tbl10.castMode,
                    Delay = 2,
                })
            else
                flag4 = false
                tbl10.active = false

                if tbl10.loopThread then
                    task.cancel(tbl10.loopThread)
                    tbl10.loopThread = nil
                end

                if tbl10.animThread then
                    task.cancel(tbl10.animThread)
                    tbl10.animThread = nil
                end

                if tbl10.respawnConn then
                    tbl10.respawnConn:Disconnect()
                    tbl10.respawnConn = nil
                end

                if tbl10.curveUtil and tbl10.origCurve then
                    pcall(function()
                        tbl10.curveUtil.GetCurveBetween = tbl10.origCurve
                    end)

                    tbl10.curveUtil = nil
                    tbl10.origCurve = nil
                end

                if tbl10.notifHooked and tbl10.notifCtrl and tbl10.origDeliver then
                    pcall(function()
                        tbl10.notifCtrl.DeliverNotification = tbl10.origDeliver
                    end)

                    tbl10.notifHooked = false
                    tbl10.origDeliver = nil
                end

                for i, connection in ipairs(tbl10.connections) do
                    connection:Disconnect()
                end

                tbl10.connections = {}

                pcall(function()
                    obj.RF_CancelFishingInputs:InvokeServer()
                end)

                lib:MakeNotify({
                    Title = "Instant Fast Reel",
                    Description = "Dimatikan.",
                    Delay = 2,
                })
            end
        end,
    })

    local tbl11 = {
        active = false,
        completeDelay = 0.04,
        spamDelay = 0.1,
        loopThread = nil,
        fishConn = nil,
        playFXConn = nil,
        onChangeConn = nil,
        notifConn = nil,
        origSet = nil,
        hooksReady = false,
    }

    local v15 = nil
    local v16 = nil
    local v17 = nil
    local v18 = nil

    local function fn16()
        if not v15 then
            pcall(function()
                v15 = fn(ReplicatedStorage.Areas)
            end)
        end

        return v15
    end

    local function fn17()
        if not v16 then
            pcall(function()
                v16 = fn(ReplicatedStorage.Tiers)
            end)
        end

        return v16
    end

    local function fn18()
        if not v17 then
            pcall(function()
                v17 = fn(ReplicatedStorage.Items)
            end)
        end

        return v17
    end

    local function fn19()
        if not v18 then
            v18 = fn2()
        end

        return v18
    end

    local n = 2
    local flag5 = false
    local flag6 = false
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local flag7 = false
    local flag8 = false
    _G._lynxVisualUUIDs = {}

    local tbl12 = {
        [559] = true,
        [257] = true,
        [948] = true,
        [978] = true,
        [979] = true,
    }

    local tbl13 = {
        ColorSequence.new(Color3.fromRGB(255, 250, 246)),
        ColorSequence.new(Color3.fromRGB(195, 255, 85)),
        ColorSequence.new(Color3.fromRGB(85, 162, 255)),
        ColorSequence.new(Color3.fromRGB(178, 114, 247)),
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 184, 42)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 184, 42)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 232, 142)),
        }),
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 24, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(102, 0, 0)),
        }),
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 255, 151)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 149, 255)),
        }),
    }

    local function fn20()
        if tbl11.playFXConn then
            return
        end
        local rePlayFishEffect = obj.RE_PlayFishEffect

        if rePlayFishEffect then
            tbl11.playFXConn = rePlayFishEffect.OnClientEvent:Connect(function(arg, arg2, arg3)
                if arg == localPlayer and not flag5 and type(arg3) == "number" and arg3 > 0 then
                    n = arg3
                end
            end)
        end
    end

    local function fn21(arg)
        if flag7 then
            return
        end
        flag7 = true
        local n5 = arg or 1
        local v19 = n5
        n2 = n2 + v19
        n3 = n3 + v19
        n4 = n4 + v19

        if n2 > 10 then
            n2 = 1
        end

        if n3 > 40 then
            n3 = 1
        end

        local v20 = fn19()

        if v20 then
            flag8 = true

            pcall(function()
                v20:_set("Modifiers.Golden", n2)
            end)

            pcall(function()
                v20:_set("Modifiers.Rainbow", n3)
            end)

            pcall(function()
                v20:_set("InventoryNotifications.Fish", n4)
            end)

            flag8 = false
        end

        flag7 = false
    end

    local function fn22(arg)
        local v19 = fn17()
        if not v19 then
            return 1
        end
        local n5 = 1

        for k, v20 in pairs(v19) do
            if type(v20) == "table" and v20.Rarity and v20.Tier and arg <= v20.Rarity and n5 < v20.Tier and v20.Tier <= 7 then
                n5 = v20.Tier
            end
        end

        return n5
    end

    local function fn23(arg)
        local v19 = fn18()
        if not v19 then
            return 0
        end

        for k, v20 in pairs(v19) do
            if v20.Data and v20.Data.Name == arg and v20.Data.Type == "Fish" then
                local id = v20.Data.Id
                local n5 = id or 0
                return n5
            end
        end

        return 0
    end

    local function fn24(arg)
        local v19 = fn18()
        if not v19 then
            return tbl13[1]
        end

        for k, v20 in pairs(v19) do
            if v20.Data and v20.Data.Name == arg and v20.Data.Type == "Fish" then
                local tier = v20.Data.Tier
                local n5 = tier or 1
                local v21 = tbl13[n5]
                local v22 = v21 or tbl13[1]
                return v22
            end
        end

        return tbl13[1]
    end

    local function fn25()
        local v19 = fn19()
        if not v19 then
            return n
        end
        local EquippedId = v19:Get("EquippedId")
        if not EquippedId or EquippedId == "" then
            return n
        end
        local v20 = v19:Get("Inventory.Fishing Rods")
        local tbl14 = v20 or {}
        local v21, v22, v23 = ipairs(tbl14)
        local v24 = v23
        local v25 = v21
        local v26 = v22

        while true do
            local v27, v28 = v25(v26, v24)
            if v27 == nil then
                break
            end
            v24 = v27

            if v28.UUID == EquippedId then
                local v29 = fn18()
                local tbl15 = v29 or {}

                for k, v30 in pairs(tbl15) do
                    if v30.Data and tostring(v30.Data.Id) == tostring(v28.Id) and v30.Data.Type == "Fishing Rods" then
                        local tier = v30.Data.Tier
                        local v31 = tier or n
                        return v31
                    end
                end

                v24 = v27
            end
        end

        return n
    end

    local function fn26()
        local v19 = fn19()
        if not v19 then
            return false
        end
        local EquippedId = v19:Get("EquippedId")
        if not EquippedId or EquippedId == "" then
            return false
        end
        local v20 = v19:Get("Inventory.Fishing Rods")
        local tbl14 = v20 or {}

        for i, v21 in ipairs(tbl14) do
            if v21.UUID == EquippedId then
                local flag9 = tbl12[v21.Id] == true
                return flag9
            end
        end

        return false
    end

    local function fn27()
        local ok, result = pcall(function()
            return localPlayer.LocationName
        end)

        if ok and result and tostring(result) ~= "" then
            return tostring(result)
        end
        local character = localPlayer.Character

        if character then
            local attribute = character:GetAttribute("LocationName")
            if attribute and tostring(attribute) ~= "" then
                return tostring(attribute)
            end
        end

        local attribute = localPlayer:GetAttribute("LocationName")
        if attribute and tostring(attribute) ~= "" then
            return tostring(attribute)
        end
    end

    local function fn28()
        local character = localPlayer.Character
        if not character then
            return Vector3.zero, Vector3.new(0, 6, 0)
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return Vector3.zero, Vector3.new(0, 6, 0)
        end
        local lookVector = humanoidRootPart.CFrame.LookVector
        local n5 = humanoidRootPart.Position + lookVector * 10
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {character}
        local hit = Workspace:Raycast(n5 + Vector3.new(0, 50, 0), Vector3.new(0, -150, 0), raycastParams)
        local n6 = hit and hit.Position + Vector3.new(0, 0.1, 0) or n5 + Vector3.new(0, -5, 0)
        return n6, humanoidRootPart.Position + lookVector * 5 + Vector3.new(0, 6.5, 0)
    end

    local function fn29(arg)
        local v19 = fn18()
        local v20 = fn16()
        if not v19 or not v20 then
            return {}
        end
        local v21 = fn27()
        local fishermanIsland = v21 and v20[v21] or v20["Fisherman Island"]
        if not fishermanIsland or not fishermanIsland.Items then
            return {}
        end
        local tbl14 = {}
        local v22, v23, v24 = ipairs(fishermanIsland.Items)
        local v25 = v24
        local v26 = v22
        local v27 = v23

        while true do
            local v28, v29 = v26(v27, v25)
            if v28 == nil then
                break
            end
            local v30, v31, v32 = pairs(v19)
            local v33 = v26
            local v34 = v27
            local v35 = v32
            local v36 = v28
            local v37 = v33
            local v38 = v34

            while true do
                local v39, v40 = v30(v31, v35)
                if v39 == nil then
                    break
                end
                v35 = v39

                if v40.Data and v40.Data.Name == v29 and v40.Data.Type == "Fish" then
                    local probability = v40.Probability
                    local chance = probability and v40.Probability.Chance and fn22(v40.Probability.Chance) or v40.Data.Tier or 1

                    for i, v41 in ipairs(arg) do
                        if chance == v41 then
                            local insert = table.insert
                            local tbl15 = {Name = v29}
                            local id = v40.Data.Id
                            local id2 = id or 0
                            tbl15.Id = id2
                            insert(tbl14, tbl15)
                            break
                        end
                    end

                    v36 = v28
                    v37 = v33
                    v38 = v34
                    break
                end
            end

            v25 = v36
            v26 = v37
            v27 = v38
        end

        return tbl14
    end

    local function fn30()
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(arg)
            local format = string.format
            local n5 = arg == "x" and math.random(0, 15) or math.random(8, 11)
            return format("%x", n5)
        end)
    end

    local function fn31()
        local ok, result = pcall(function()
            return localPlayer.FishingRod
        end)

        local str2 = ok and result and tostring(result) ~= "" and tostring(result) or ""
        return str2
    end

    local function fn32()
        local ok, result = pcall(function()
            return localPlayer.FishingRodSkin
        end)

        local str2 = ok and result and tostring(result) ~= "" and tostring(result) or ""
        return str2
    end

    local n5 = 0

    for k in pairs(_G._lynxVisualUUIDs) do
        n5 = n5 + 1
    end

    local function fn33(arg)
        if flag5 then
            return
        end
        flag5 = true
        local v19 = fn30()
        _G._lynxVisualUUIDs[v19] = true
        n5 = n5 + 1

        if n5 > 200 then
            _G._lynxVisualUUIDs = {}
            _G._lynxVisualUUIDs[v19] = true
            n5 = 1
        end

        local id = arg.Id
        local name = arg.Name
        local n6 = math.random(100, 2500) / 700
        local v20, v21 = fn28()
        local character = localPlayer.Character
        local head = character and localPlayer.Character:FindFirstChild("Head") or localPlayer.Character

        pcall(function()
            local v22 = firesignal
            local onClientEvent = obj.RE_BaitCastVisual.OnClientEvent

            local tbl14 = {
                CastPosition = v20,
                Power = 0.86895783044309,
                RodName = fn31(),
                CosmeticTemplateId = -1,
            }

            local character2 = localPlayer.Character
            local equippedTool = character2 and localPlayer.Character:FindFirstChild("!!!EQUIPPED_TOOL!!!") or nil
            tbl14.EquippedToolModel = equippedTool
            tbl14.ConnectingJoint = 0
            tbl14.NoFishingZone = false
            tbl14.BaitIdentifier = 3
            tbl14.Origin = v21
            tbl14.CustomModel = false
            v22(onClientEvent, localPlayer, tbl14)
        end)

        pcall(function()
            firesignal(obj.RE_PlayFishEffect.OnClientEvent, localPlayer, head, fn25())
        end)

        pcall(function()
            firesignal(obj.RE_BaitSpawned.OnClientEvent, localPlayer, fn32(), Vector3.new(v20.X, v20.Y + 0.1, v20.Z))
        end)

        flag5 = false
        task.wait(0.05)

        pcall(function()
            firesignal(obj.RE_TextEffect.OnClientEvent, {
                Channel = "All",
                TextData = {
                    AttachTo = head,
                    Text = "!",
                    TextColor = fn24(name),
                    EffectType = "Exclaim",
                },
                Duration = 0.5,
                Container = head,
            })
        end)

        pcall(function()
            local v22 = fn19()
            if not v22 then
                return
            end
            local Items = v22:Get("Inventory.Items")
            local tbl14 = Items or {}

            table.insert(tbl14, {
                Id = id,
                Favorited = false,
                UUID = v19,
                Metadata = {Weight = n6},
            })

            v22:_set("Inventory.Items", tbl14)
        end)

        flag6 = true

        pcall(function()
            firesignal(obj.RE_ObtainedNewFishNotification.OnClientEvent, id, {Weight = n6}, {
                CustomDuration = 5,
                InventoryItem = {
                    Id = id,
                    Favorited = false,
                    UUID = v19,
                    Metadata = {Weight = n6},
                },
                ItemType = "Fish",
                _newlyIndexed = false,
                Type = "Item",
                ItemId = id,
            }, false)
        end)

        fn21(1)
        flag6 = false
        flag5 = true

        pcall(function()
            firesignal(obj.RE_FishCaught.OnClientEvent, name, {Weight = n6}, 0, 0)
        end)

        task.wait(0.1)
        flag5 = false
        pcall(fn14, name, {Weight = n6}, nil, nil, {origin = v20})
    end

    local function fn34()
        if tbl11.hooksReady then
            return
        end
        local v19 = fn19()
        if not v19 then
            return
        end
        tbl11.hooksReady = true
        local Modifiers = v19:Get("Modifiers")

        if Modifiers then
            local golden = Modifiers.Golden
            local n6 = golden or 0
            n2 = n6
            local rainbow = Modifiers.Rainbow
            local n7 = rainbow or 0
            n3 = n7
        end

        local InventoryNotifications = v19:Get("InventoryNotifications")

        if InventoryNotifications then
            local fish = InventoryNotifications.Fish
            local n6 = fish or 0
            n4 = n6
        end

        pcall(function()
            tbl11.onChangeConn = v19:OnChange("InventoryNotifications.Fish", function(arg)
                if arg == 0 then
                    n4 = 0
                end
            end)
        end)

        tbl11.origSet = v19._set

        v19._set = function(arg, arg2, arg3)
            if flag8 then
                return tbl11.origSet(arg, arg2, arg3)
            end

            if arg2 == "Modifiers.Golden" then
                return tbl11.origSet(arg, arg2, n2)
            end

            if arg2 == "Modifiers.Rainbow" then
                return tbl11.origSet(arg, arg2, n3)
            end

            if arg2 == "InventoryNotifications.Fish" then
                return tbl11.origSet(arg, arg2, n4)
            end
            return tbl11.origSet(arg, arg2, arg3)
        end

        if obj.RE_ObtainedNewFishNotification then
            tbl11.notifConn = obj.RE_ObtainedNewFishNotification.OnClientEvent:Connect(function()
                if not flag6 then
                    fn21(1)
                end
            end)
        end
    end

    local function fn35()
        if tbl11.playFXConn then
            tbl11.playFXConn:Disconnect()
            tbl11.playFXConn = nil
        end

        if tbl11.onChangeConn then
            pcall(function()
                tbl11.onChangeConn:Disconnect()
            end)

            tbl11.onChangeConn = nil
        end

        if tbl11.notifConn then
            tbl11.notifConn:Disconnect()
            tbl11.notifConn = nil
        end

        if tbl11.origSet then
            local v19 = fn19()

            if v19 then
                v19._set = tbl11.origSet
            end

            tbl11.origSet = nil
        end

        tbl11.hooksReady = false
    end

    local v19 = v8:AddSection("Ini Blatant kayaknya [Visual]", false)

    v19:AddInput({
        Title = "Fishing Complete Delay",
        Default = "0.3",
        Callback = function(arg)
            local completeDelay = tonumber(arg)

            if completeDelay and completeDelay >= 0 then
                tbl11.completeDelay = completeDelay
            end
        end,
    })

    v19:AddToggle({
        Title = "Enable Ultra Blatant",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if not obj.IsInitialized then
                    return
                end

                if flag4 then
                    warn("[Module] Fishing lain sudah aktif!")
                    return
                end
                flag4 = true
                tbl11.active = true
                fn20()
                fn34()

                tbl11.loopThread = task.spawn(function()
                    while tbl11.active do
                        if not _G.AutoMineActive and not _G.OrbThrowing then
                            local now = tick()

                            pcall(function()
                                obj.RF_ChargeFishingRod:InvokeServer({now})
                            end)

                            pcall(function()
                                obj.RF_RequestMinigame:InvokeServer(1, 0, now)
                            end)

                            task.wait(tbl11.completeDelay)

                            pcall(function()
                                obj.RE_FishingCompleted:FireServer()
                            end)

                            task.wait(tbl11.spamDelay)
                        else
                            task.wait(1)
                        end
                    end
                end)

                task.spawn(function()
                    local n6 = 0

                    while not obj.RE_FishCaught and n6 < 10 do
                        task.wait(0.5)
                        n6 = n6 + 0.5
                    end

                    if not obj.RE_FishCaught then
                        return
                    end

                    tbl11.fishConn = obj.RE_FishCaught.OnClientEvent:Connect(function(name, ...)
                        if not tbl11.active or flag5 then
                            return
                        end
                        pcall(fn14, name, ...)
                        if not fn26() then
                            return
                        end

                        task.spawn(function()
                            if tbl11.completeDelay > 0 then
                                task.wait(tbl11.completeDelay)
                            end

                            local tbl14 = nil

                            if name and name ~= "" then
                                local v20 = fn18()
                                local n7 = 1

                                if v20 then
                                    for k, v21 in pairs(v20) do
                                        if v21.Data and v21.Data.Name == name and v21.Data.Type == "Fish" then
                                            local probability = v21.Probability
                                            local chance = probability and v21.Probability.Chance and fn22(v21.Probability.Chance) or v21.Data.Tier or 1
                                            n7 = chance
                                            break
                                        end
                                    end
                                end

                                if n7 >= 4 then
                                    local v21 = fn29({3})
                                    local v22 = fn29({2})

                                    if math.random(1, 10) <= 8 and #v21 > 0 then
                                        tbl14 = v21[math.random(1, #v21)]
                                    elseif #v22 > 0 then
                                        tbl14 = v22[math.random(1, #v22)]
                                    elseif #v21 > 0 then
                                        tbl14 = v21[math.random(1, #v21)]
                                    end
                                elseif math.random(1, 10) <= 7 then
                                    tbl14 = {Name = name, Id = fn23(name)}
                                else
                                    local tbl15 = {}
                                    local v21 = fn29({n7})

                                    for i, v22 in ipairs(v21) do
                                        if v22.Name ~= name then
                                            table.insert(tbl15, v22)
                                        end
                                    end

                                    local flag9 = #tbl15 > 0 and tbl15[math.random(1, #tbl15)]

                                    if not flag9 then
                                        local tbl16 = {}
                                        flag9 = tbl16
                                        tbl16.Name = name
                                        tbl16.Id = fn23(name)
                                    end

                                    tbl14 = flag9
                                end
                            end

                            if tbl14 then
                                fn33(tbl14)
                            end
                        end)
                    end)
                end)
            else
                flag4 = false
                tbl11.active = false

                if tbl11.loopThread then
                    task.cancel(tbl11.loopThread)
                    tbl11.loopThread = nil
                end

                if tbl11.fishConn then
                    tbl11.fishConn:Disconnect()
                    tbl11.fishConn = nil
                end

                fn35()

                pcall(function()
                    obj.RF_CancelFishingInputs:InvokeServer()
                end)
            end
        end,
    })

    local tbl14 = {
        active = false,
        settings = {completeDelay = 0.01, spamDelay = 0.05, chargeSpam = 1},
        thread = nil,
        minConn = nil,
        respawnConn = nil,
        caughtConn = nil,
    }

    local function fn36(arg)
        task.spawn(function()
            pcall(arg)
        end)
    end

    local v20 = v8:AddSection("Blatant V2 [BETA]")

    v20:AddToggle({
        Title = "Enable Blatant V2",
        Default = false,
        Callback = function(arg)
            if arg then
                if not obj.IsInitialized then
                    warn("[BlatantV2] EventResolver belum siap!")
                    return
                end

                if flag4 then
                    warn("[Module] Fishing lain sudah aktif!")
                    return
                end
                flag4 = true
                tbl14.active = true

                if obj.RE_MinigameChanged then
                    tbl14.minConn = obj.RE_MinigameChanged.OnClientEvent:Connect(function()
                        if not tbl14.active then
                            return
                        end

                        pcall(function()
                            obj.RE_FishingCompleted:FireServer()
                        end)
                    end)
                end

                tbl14.caughtConn = fn15()

                tbl14.respawnConn = localPlayer.CharacterAdded:Connect(function(character)
                    if not tbl14.active then
                        return
                    end
                    local humanoid = character:WaitForChild("Humanoid", 10)

                    if humanoid then
                        repeat
                            task.wait(0.3)
                        until humanoid.Health > 0
                    end

                    task.wait(1)

                    if tbl14.active then
                        fn8()
                    end
                end)

                tbl14.thread = task.spawn(function()
                    fn8()
                    if not tbl14.active then
                        return
                    end

                    while tbl14.active do
                        if not _G.AutoMineActive and not _G.OrbThrowing then
                            if obj.IsInitialized then
                                local now = os.clock()

                                for i = 1, tbl14.settings.chargeSpam do
                                    fn36(function()
                                        obj.RF_ChargeFishingRod:InvokeServer({now})
                                    end)

                                    fn36(function()
                                        obj.RF_RequestMinigame:InvokeServer(1, 0, now)
                                    end)

                                    if i < tbl14.settings.chargeSpam then
                                        task.wait(0.05)
                                    end
                                end

                                task.wait(tbl14.settings.completeDelay)

                                fn36(function()
                                    obj.RE_FishingCompleted:FireServer()
                                end)

                                task.wait(tbl14.settings.spamDelay)
                            end
                        else
                            task.wait(1)
                        end
                    end
                end)
            else
                flag4 = false
                tbl14.active = false

                if tbl14.thread then
                    task.cancel(tbl14.thread)
                    tbl14.thread = nil
                end

                if tbl14.minConn then
                    tbl14.minConn:Disconnect()
                    tbl14.minConn = nil
                end

                if tbl14.respawnConn then
                    tbl14.respawnConn:Disconnect()
                    tbl14.respawnConn = nil
                end

                if tbl14.caughtConn then
                    tbl14.caughtConn:Disconnect()
                    tbl14.caughtConn = nil
                end

                pcall(function()
                    obj.RF_CancelFishingInputs:InvokeServer()
                end)
            end
        end,
    })

    v20:AddInput({
        Title = "Spam Cast Delay v2",
        Default = "0.05",
        Callback = function(arg)
            local spamDelay = tonumber(arg)

            if spamDelay then
                tbl14.settings.spamDelay = spamDelay
            end
        end,
    })

    v20:AddInput({
        Title = "Complete Delay v2",
        Default = "0.01",
        Callback = function(arg)
            local completeDelay = tonumber(arg)

            if completeDelay then
                tbl14.settings.completeDelay = completeDelay
            end
        end,
    })

    local v21 = v8:AddSection("Perfect Rod/Bait Crafting", false)
    local tbl15 = {enabled = false, thread = nil, eventConn = nil}

    v21:AddParagraph({
        Title = "Info",
        Content = "Otomatis klik di zona Perfect untuk setiap bar saat minigame crafting rod berlangsung.\nAktifkan lalu klik Craft Rod secara manual di UI crafting.\n⚠️Diwajibkan untuk menyalakan fitur ini dulu sebelum memulai crafting, dan ketika crafting nya sudah di mulai tinggal tunggu saja sampai notif mendapatkan Perfect Forgotten Rod nya muncul.",
    })

    local function fn37(arg, arg2)
        local RodCraftingMinigame = require(ReplicatedStorage.Shared.RodCraftingMinigame)
        local perfectStart = RodCraftingMinigame.PerfectStart
        local n6 = perfectStart or 0.8

        while true do
            local serverTimeNow = Workspace:GetServerTimeNow()
            local v22 = RodCraftingMinigame.GetBarPosition(serverTimeNow, arg2, arg)
            if n6 <= v22 then
                break
            end

            if n6 - v22 > 0.05 then
                task.wait(0.01)
            else
                task.wait(0.001)
            end
        end
    end

    local function fn38(arg)
        local RodCraftingMinigame = require(ReplicatedStorage.Shared.RodCraftingMinigame)
        local rfRodCraftingMinigameClick = obj.RF_RodCraftingMinigameClick
        local rfFinishRodCraftingMinigame = obj.RF_FinishRodCraftingMinigame
        if not rfRodCraftingMinigameClick then
            warn("[AutoCraft] RF_RodCraftingMinigameClick not found")
            return
        end
        local startedAt = arg.StartedAt
        local bars = arg.Bars
        local barCount = RodCraftingMinigame.BarCount
        local n6 = barCount or 4
        local n7 = 1

        while n7 <= n6 and tbl15.enabled do
            local v22 = bars and bars[n7]

            if not v22 then
                task.wait(0.1)
                n7 = n7 + 1
                continue
            end

            fn37(v22, startedAt)
            if not tbl15.enabled then
                break
            end
            local response = nil

            local ok, result = pcall(function()
                response = rfRodCraftingMinigameClick:InvokeServer(n7)
            end)

            if not ok then
                warn("[AutoCraft] Click error:", result)
                break
            end

            if not response then
                break
            end

            if not response.Complete then
                if response.Accepted then
                    local nextStartedAt = response.NextStartedAt
                    local serverTimeNow = nextStartedAt or Workspace:GetServerTimeNow()
                    startedAt = serverTimeNow
                    local nextBarIndex = response.NextBarIndex
                    local n8 = nextBarIndex or n7 + 1
                    n7 = n8
                else
                    task.wait(0.05)
                end

                continue
            end

            if response.Passed and rfFinishRodCraftingMinigame then
                task.wait(0.3)

                pcall(function()
                    rfFinishRodCraftingMinigame:InvokeServer()
                end)
            end

            break
        end
    end

    local function fn39()
        if tbl15.eventConn then
            pcall(function()
                tbl15.eventConn:Disconnect()
            end)

            tbl15.eventConn = nil
        end

        local rePlayRodCraftingMinigame = obj.RE_PlayRodCraftingMinigame
        if not rePlayRodCraftingMinigame then
            warn("[AutoCraft] RE_PlayRodCraftingMinigame not found")
            return
        end

        tbl15.eventConn = rePlayRodCraftingMinigame.OnClientEvent:Connect(function(arg)
            if not tbl15.enabled then
                return
            end

            if not arg then
                return
            end

            if tbl15.thread then
                pcall(task.cancel, tbl15.thread)
                tbl15.thread = nil
            end

            tbl15.thread = task.spawn(function()
                task.wait(0.4)

                if tbl15.enabled then
                    fn38(arg)
                end
            end)
        end)
    end

    v21:AddToggle({
        Title = "Enable Auto Perfect Crafting",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl15.enabled = enabled

            if tbl15.thread then
                pcall(task.cancel, tbl15.thread)
                tbl15.thread = nil
            end

            if enabled then
                fn39()

                lib:MakeNotify({
                    Title = "Auto Craft",
                    Description = "Aktif — akan auto perfect saat minigame crafting rod dimulai.",
                    Delay = 3,
                })
            else
                if tbl15.eventConn then
                    pcall(function()
                        tbl15.eventConn:Disconnect()
                    end)

                    tbl15.eventConn = nil
                end

                lib:MakeNotify({
                    Title = "Auto Craft",
                    Description = "Dinonaktifkan.",
                    Delay = 2,
                })
            end
        end,
    })

    local v22 = v3:AddTab({Name = "Favorite", Icon = "star"})

    local tbl16 = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "SECRET",
        "FORGOTTEN",
        [90] = "Trophy",
    }

    local tbl17 = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "SECRET",
        "FORGOTTEN",
    }

    local tbl18 = {}

    for i, v23 in ipairs(tbl17) do
        tbl18[v23] = true
    end

    local tbl19 = {
        Gears = true,
        ["Enchant Stones"] = true,
        Trophies = true,
        Equipment = true,
    }

    local tbl20 = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "SECRET",
        "FORGOTTEN",
        "Trophy",
    }

    local tbl21 = {}

    for i, v23 in ipairs(tbl20) do
        tbl21[v23] = true
    end

    local tbl22 = {
        itemUtility = nil,
        replion = nil,
        fishList = {},
        equipList = {},
        variantList = {},
        watchConn = nil,
        watchers = {},
        pending = false,
    }

    local function fn40(arg)
        local tbl23 = {}

        if type(arg) == "table" then
            for i, v23 in ipairs(arg) do
                tbl23[v23] = true
            end
        end

        return tbl23
    end

    local function fn41(arg, arg2)
        local tbl23 = {}

        if type(arg) == "table" then
            for i, v23 in ipairs(arg) do
                if arg2[v23] then
                    tbl23[#tbl23 + 1] = v23
                end
            end
        end

        return tbl23
    end

    local function fn42(arg, arg2, arg3)
        local makeNotify = lib.MakeNotify
        local tbl23 = {Title = arg, Description = arg2}
        local delay = arg3 or 3
        tbl23.Delay = delay
        makeNotify(lib, tbl23)
    end

    local function fn43()
        if not tbl22.itemUtility then
            pcall(function()
                tbl22.itemUtility = fn(ReplicatedStorage.Shared.ItemUtility)
            end)
        end

        if not tbl22.replion then
            tbl22.replion = fn2()
        end

        local flag9 = tbl22.replion ~= nil and tbl22.itemUtility ~= nil
        return flag9
    end

    local function fn44()
        tbl22.fishList = {}
        tbl22.equipList = {}
        tbl22.variantList = {}

        pcall(function()
            local v23 = fn(ReplicatedStorage:FindFirstChild("Items"))
            if type(v23) ~= "table" then
                return
            end
            local tbl23 = {}
            local tbl24 = {}

            for k, v24 in pairs(v23) do
                local data = v24.Data

                if data and data.Type then
                    local displayName = data.DisplayName
                    local name = displayName or data.Name

                    if name and data.Type == "Fish" then
                        if not tbl23[name] then
                            tbl23[name] = true
                            tbl22.fishList[#tbl22.fishList + 1] = name
                        end
                    elseif name and tbl19[data.Type] and not tbl24[name] then
                        tbl24[name] = true
                        tbl22.equipList[#tbl22.equipList + 1] = name
                    end
                end
            end

            table.sort(tbl22.fishList)
            table.sort(tbl22.equipList)
        end)

        pcall(function()
            local variants = ReplicatedStorage:FindFirstChild("Variants")
            if not variants then
                return
            end

            for i, child in ipairs(variants:GetChildren()) do
                if child:IsA("ModuleScript") and child.Name ~= "1x1x1x1" then
                    tbl22.variantList[#tbl22.variantList + 1] = child.Name
                end
            end

            table.sort(tbl22.variantList)
        end)
    end

    local function fn45(arg)
        local metadata = arg and arg.Metadata
        if not metadata then
            return nil
        end
        local variant = metadata.Variant
        local variantName = variant or metadata.VariantName or metadata.MutationName or metadata.VariantId
        if type(variantName) ~= "string" then
            return nil
        end
        local str2 = variantName:gsub("^%s+", ""):gsub("%s+$", "")
        if str2 ~= "" and str2 ~= "None" then
            return str2
        end
        return nil
    end

    local function fn46(arg, arg2, arg3)
        if arg3.tier and arg2.Tier ~= arg3.tier then
            return false
        end

        if arg3.names and next(arg3.names) then
            local displayName = arg2.DisplayName
            local name = displayName or arg2.Name
            if not name or not arg3.names[name] then
                return false
            end
        end

        if arg3.rarities and next(arg3.rarities) then
            local v23 = tbl16[arg2.Tier]
            if not v23 or not arg3.rarities[v23] then
                return false
            end
        end

        if arg3.variants and next(arg3.variants) then
            local v23 = fn45(arg)
            if not v23 or not arg3.variants[v23] then
                return false
            end
        end

        return true
    end

    local function fn47(arg)
        local flag9 = arg.tier ~= nil

        if not flag9 then
            local names = arg.names
            flag9 = names and next(arg.names) ~= nil
        end

        if not flag9 then
            local rarities = arg.rarities
            flag9 = rarities and next(arg.rarities) ~= nil
        end

        if not flag9 then
            local variants = arg.variants
            flag9 = variants and next(arg.variants) ~= nil
        end

        return flag9
    end

    local function fn48(arg)
        local v23 = tbl22.replion:Get({"Inventory", "Items"})
        if type(v23) ~= "table" then
            return nil
        end

        for i, v24 in ipairs(v23) do
            if v24.UUID == arg then
                local flag9 = v24.Favorited == true
                return flag9
            end
        end

        return nil
    end

    local function fn49(arg, arg2)
        local v23 = fn48(arg)
        if v23 == nil then
            return false
        end

        if v23 == arg2 then
            return true
        end

        pcall(function()
            obj.RE_FavoriteItem:FireServer(arg)
        end)

        local n6 = os.clock() + 2
        local v24

        repeat
            task.wait(0.05)
            v24 = fn48(arg)
        until v24 == arg2 or v24 == nil or n6 < os.clock()

        local flag9 = v24 == arg2
        return flag9
    end

    local function fn50(arg, arg2, arg3)
        if arg.busy or not arg.enabled then
            return
        end

        if not fn43() then
            return
        end

        if not fn47(arg2) then
            return
        end
        arg.busy = true
        local n6 = 0
        local n7 = 0

        pcall(function()
            local v23 = tbl22.replion:Get({"Inventory", "Items"})
            if type(v23) ~= "table" then
                return
            end

            for i, v24 in ipairs(v23) do
                if not arg.enabled then
                    break
                end
                local flag9 = v24.Favorited == true

                if flag9 ~= arg3 then
                    local itemData = tbl22.itemUtility:GetItemData(v24.Id)
                    local data = itemData and itemData.Data
                    local v25 = data
                    local flag10 = data

                    if flag10 then
                        local types = arg2.types
                        flag10 = types and arg2.types[v25.Type] == true

                        if not flag10 then
                            if arg2.types then
                                flag10 = false
                            else
                                flag10 = true
                            end

                            if flag10 then
                                flag10 = v25.Type == "Fish"
                            end
                        end
                    end

                    if flag10 and fn46(v24, v25, arg2) then
                        n6 = n6 + 1

                        if fn49(v24.UUID, arg3) then
                            n7 = n7 + 1
                        end
                    end
                end
            end
        end)

        arg.busy = false
        return n6, n7
    end

    local function fn51()
        local flag9 = false

        for i, watcher in ipairs(tbl22.watchers) do
            if watcher.state.enabled then
                flag9 = true
                break
            end
            continue
        end

        if flag9 and not tbl22.watchConn and tbl22.replion then
            tbl22.watchConn = tbl22.replion:OnChange({"Inventory", "Items"}, function()
                if tbl22.pending then
                    return
                end
                tbl22.pending = true

                task.delay(0.5, function()
                    tbl22.pending = false

                    for i, watcher in ipairs(tbl22.watchers) do
                        if watcher.state.enabled then
                            fn50(watcher.state, watcher.filter(), true)
                        end
                    end
                end)
            end)
        elseif not flag9 and tbl22.watchConn then
            pcall(function()
                tbl22.watchConn:Disconnect()
            end)

            tbl22.watchConn = nil
        end
    end

    local function fn52(arg, arg2)
        tbl22.watchers[#tbl22.watchers + 1] = {state = arg, filter = arg2}
    end

    local v23 = v22:AddSection("Auto Favorite")

    local tbl23 = {
        enabled = false,
        busy = false,
        names = {},
        rarities = {},
        variants = {},
    }

    local function fn53()
        return {
            names = tbl23.names,
            rarities = tbl23.rarities,
            variants = tbl23.variants,
        }
    end

    fn52(tbl23, fn53)

    v23:AddParagraph({
        Title = "Filter Logic (AND)",
        Content = "Semua filter aktif bekerja sebagai AND.\n\n• Name saja    → ikan cocok name\n• Rarity saja  → ikan cocok rarity\n• Variant saja → ikan cocok variant\n• Gabungan     → harus cocok semuanya\n\nFilter kosong diabaikan.\nContoh: Mythic + Corrupt → hanya ikan Mythic ber-variant Corrupt.",
    })

    local function fn54()
        if tbl23.enabled then
            task.spawn(function()
                fn50(tbl23, fn53(), true)
            end)
        end
    end

    v23:AddDropdown({
        Title = "Name",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl23.names = fn40(arg)
            fn54()
        end,
    })

    v23:AddDropdown({
        Title = "Variant",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl23.variants = fn40(arg)
            fn54()
        end,
    })

    v23:AddDropdown({
        Title = "Rarity",
        Multi = true,
        Options = tbl17,
        Default = {},
        Callback = function(arg)
            tbl23.rarities = fn40(fn41(arg, tbl18))
            fn54()
        end,
    })

    local v24 = nil

    v24 = v23:AddToggle({
        Title = "Auto Favorite",
        Default = false,
        Callback = function(enabled)
            if enabled and not fn43() then
                fn42("Auto Favorite", "Gagal inisialisasi data.", 3)

                pcall(function()
                    v24:SetValue(false)
                end)

                return
            end

            tbl23.enabled = enabled
            fn51()

            if enabled then
                task.spawn(function()
                    fn50(tbl23, fn53(), true)
                end)
            end

            local str2 = enabled and "Started" or "Stopped"
            fn42("Auto Favorite", str2, 2)
        end,
    })

    local v25 = v22:AddSection("Un-Favorite")

    local tbl24 = {
        enabled = false,
        busy = false,
        names = {},
        rarities = {},
        variants = {},
    }

    v25:AddParagraph({
        Title = "Info",
        Content = "Un-favorite ikan yang cocok dengan filter.\nSemua filter aktif bekerja sebagai AND.\nFilter kosong diabaikan.\n\nContoh: Mythic + Corrupt → hanya un-favorite\nikan Mythic ber-variant Corrupt.",
    })

    v25:AddDropdown({
        Title = "Unfav Name",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl24.names = fn40(arg)
        end,
    })

    v25:AddDropdown({
        Title = "Unfav Variant",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl24.variants = fn40(arg)
        end,
    })

    v25:AddDropdown({
        Title = "Unfav Rarity",
        Multi = true,
        Options = tbl17,
        Default = {},
        Callback = function(arg)
            tbl24.rarities = fn40(fn41(arg, tbl18))
        end,
    })

    v25:AddButton({
        Title = "Un-Favorite Selected",
        Callback = function()
            if not tbl24.busy then
                if not fn43() then
                    fn42("Un-Favorite", "Gagal inisialisasi data.", 3)
                    return
                end

                local tbl25 = {
                    names = tbl24.names,
                    rarities = tbl24.rarities,
                    variants = tbl24.variants,
                }

                if not fn47(tbl25) then
                    fn42("Un-Favorite", "Pilih minimal satu filter dulu.", 3)
                    return
                end

                task.spawn(function()
                    tbl24.enabled = true
                    fn42("Un-Favorite", "Scanning...", 2)
                    local v26, v27 = fn50(tbl24, tbl25, false)
                    tbl24.enabled = false
                    local n6 = v26 or 0
                    local n7 = v27 or 0
                    fn42("Un-Favorite", string.format("Cocok: %d | Berhasil: %d", n6, n7), 4)
                end)

                return
            end

            fn42("Un-Favorite", "Masih berjalan...", 2)
        end,
    })

    local function fn55(arg, arg2, arg3)
        local tbl25 = {enabled = false, busy = false}
        local v26 = v22:AddSection(arg)

        fn52(tbl25, function()
            return arg3
        end)

        v26:AddToggle({
            Title = arg2,
            Default = false,
            Callback = function(enabled)
                if enabled and not fn43() then
                    fn42(arg2, "Gagal inisialisasi data.", 3)
                    return
                end
                tbl25.enabled = enabled
                fn51()

                if enabled then
                    task.spawn(function()
                        fn50(tbl25, arg3, true)
                    end)
                end

                local str2 = enabled and "Started" or "Stopped"
                fn42(arg2, str2, 2)
            end,
        })
    end

    fn55("Auto Favorite Ruby (Gemstone)", "Auto Favorite Ruby (Gemstone)", {names = {Ruby = true}, variants = {Gemstone = true}})
    fn55("Auto Favorite Legendary (Crystalized)", "Auto Favorite Legendary (Crystalized)", {tier = 5, variants = {Crystalized = true}})
    local v26 = v22:AddSection("Auto Favorite Equipment", false)

    local tbl25 = {
        enabled = false,
        busy = false,
        names = {},
        rarities = {},
        variants = {},
    }

    local function fn56()
        return {
            names = tbl25.names,
            rarities = tbl25.rarities,
            variants = tbl25.variants,
            types = tbl19,
        }
    end

    fn52(tbl25, fn56)

    v26:AddParagraph({
        Title = "Info",
        Content = "Auto favorite untuk barang NON-ikan di tab Items: <b>Gears</b> (Withering Core, Diamond Key, Diving Gear, ...), <b>Enchant Stones</b> (Enchant Stone, Transcended Stone, ...), <b>Trophies</b>, dan <b>Equipment</b>.\nRod tidak termasuk -- rod disimpan di bucket terpisah, bukan di Items.\n\nSemua filter bekerja sebagai AND, dan filter yang kosong diabaikan.\n<i>Kebanyakan equipment tidak punya variant, jadi mengisi filter Variant biasanya justru membuat tidak ada yang cocok.</i>",
    })

    local function fn57()
        if tbl25.enabled then
            task.spawn(function()
                fn50(tbl25, fn56(), true)
            end)
        end
    end

    v26:AddDropdown({
        Title = "Equip Name",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl25.names = fn40(arg)
            fn57()
        end,
    })

    v26:AddDropdown({
        Title = "Equip Variant",
        Multi = true,
        Options = {"Loading..."},
        Default = {},
        Callback = function(arg)
            tbl25.variants = fn40(arg)
            fn57()
        end,
    })

    v26:AddDropdown({
        Title = "Equip Rarity",
        Multi = true,
        Options = tbl20,
        Default = {},
        Callback = function(arg)
            tbl25.rarities = fn40(fn41(arg, tbl21))
            fn57()
        end,
    })

    local v27 = nil

    v27 = v26:AddToggle({
        Title = "Auto Favorite Equipment",
        Default = false,
        Callback = function(enabled)
            if enabled and not fn43() then
                fn42("Auto Favorite Equipment", "Gagal inisialisasi data.", 3)

                pcall(function()
                    v27:SetValue(false)
                end)

                return
            end

            tbl25.enabled = enabled
            fn51()

            if enabled then
                task.spawn(function()
                    local v28, v29 = fn50(tbl25, fn56(), true)

                    if v28 and v28 > 0 then
                        local n6 = v29 or 0
                        fn42("Auto Favorite Equipment", string.format("%d cocok, %d berhasil di-favorite.", v28, n6), 3)
                    end
                end)
            end

            local str2 = enabled and "Started" or "Stopped"
            fn42("Auto Favorite Equipment", str2, 2)
        end,
    })

    local function fn58(arg, arg2, arg3)
        local flags = lib.flags
        local v28 = flags and lib.flags[arg]
        if not v28 or not v28.SetValues then
            return
        end

        pcall(function()
            local setValues = v28.SetValues
            local tbl26 = arg3 or {}
            setValues(v28, arg2, tbl26)
        end)
    end

    local function fn59(arg)
        local fishList = #tbl22.fishList > 0 and tbl22.fishList

        if not fishList then
            local tbl26 = {}
            fishList = tbl26
            tbl26[1] = "No Fish Found"
        end

        local variantList = #tbl22.variantList > 0 and tbl22.variantList

        if not variantList then
            local tbl26 = {}
            variantList = tbl26
            tbl26[1] = "No Variants Found"
        end

        local tbl26 = {}
        local tbl27 = {}
        local tbl28 = {}

        if arg then
            local v28 = fn41(lib.ConfigSystem.Get("MultiDropdowns.Name", {}), fn40(tbl22.fishList))
            tbl26 = v28
            local v29 = fn41(lib.ConfigSystem.Get("MultiDropdowns.Variant", {}), fn40(tbl22.variantList))
            tbl27 = v29
            tbl28 = fn41(lib.ConfigSystem.Get("MultiDropdowns.Rarity", {}), tbl18)
            tbl23.names = fn40(v28)
            tbl23.variants = fn40(v29)
            tbl23.rarities = fn40(tbl28)
        end

        fn58("Name", fishList, tbl26)
        fn58("Variant", variantList, tbl27)

        if arg and #tbl28 > 0 then
            local flags = lib.flags
            local rarity = flags and lib.flags.Rarity

            if rarity and rarity.Set then
                pcall(function()
                    rarity:Set(tbl28)
                end)
            end
        end

        fn58("Unfav_Name", fishList, {})
        fn58("Unfav_Variant", variantList, {})
        local equipList = #tbl22.equipList > 0 and tbl22.equipList

        if not equipList then
            local tbl29 = {}
            equipList = tbl29
            tbl29[1] = "No Equipment Found"
        end

        local tbl29 = {}

        if arg then
            local v28 = fn41(lib.ConfigSystem.Get("MultiDropdowns.Equip_Name", {}), fn40(tbl22.equipList))
            tbl29 = v28
            tbl25.names = fn40(v28)
        end

        fn58("Equip_Name", equipList, tbl29)
        fn58("Equip_Variant", variantList, {})
    end

    local function fn60(arg)
        fn44()
        fn59(arg)
        return #tbl22.fishList, #tbl22.variantList, #tbl22.equipList
    end

    v23:AddButton({
        Title = "Refresh Lists",
        Callback = function()
            local v28, v29, v30 = fn60(false)
            fn42("Refresh", string.format("Fish: %d | Variant: %d | Equipment: %d", v28, v29, v30), 3)
        end,
    })

    v25:AddButton({
        Title = "Refresh List Items",
        Callback = function()
            local v28, v29 = fn60(false)
            fn42("Refresh", string.format("Fish: %d | Variant: %d", v28, v29), 3)
        end,
    })

    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end

        task.wait(1)

        if not fn43() then
            task.wait(2)
            fn43()
        end

        local v28, v29, v30 = fn60(true)

        if v28 > 0 or v29 > 0 or v30 > 0 then
            fn42("Auto Favorite", string.format("Loaded: %d fish | %d variants | %d equipment", v28, v29, v30), 3)
        end
    end)
end

do
    local tbl3 = {
        SelectedIsland = nil,
        SelectedPlayer = nil,
        AutoTeleportEnabled = false,
        AutoTeleportConnection = nil,
        ReplicatedEventData = {},
        EventDataLoaded = false,
        WorkspaceEventCache = {},
        IsTeleporting = false,
        ForceTeleportCancel = false,
        CurrentEventName = nil,
        CachedEventPosition = nil,
        CachedEventObject = nil,
        IsEventActive = false,
        LastManualScanTime = 0,
        LastAutoScanTime = 0,
        TeleportLoopThread = nil,
        ScanCooldown = 5,
        HeightOffset = 15,
        SafeRadius = 150,
        CheckInterval = 8,
        WaitTimeout = 300,
    }

    local HttpService = game:GetService("HttpService")
    local tbl4 = {}
    local tbl5 = {}
    local flag4 = false
    local v4 = nil

    local function fn6()
        if not v4 then
            return
        end
        local flag5 = #tbl5 > 0 and tbl5

        if not flag5 then
            local tbl6 = {}
            flag5 = tbl6
            tbl6[1] = "(Gagal load)"
        end

        local v5 = nil

        if #tbl5 > 0 then
            local ok, result = pcall(function()
                return lib.ConfigSystem.Get("Dropdowns.Select_Island", nil)
            end)

            if ok and type(result) == "string" and tbl4[result] then
                v5 = result
            end
        end

        local selectIsland = lib and lib.flags and lib.flags.Select_Island

        if selectIsland and selectIsland.SetValues then
            pcall(function()
                selectIsland:SetValues(flag5, v5)
            end)
        elseif v4.SetOptions then
            v4:SetOptions(flag5)
        end

        if v5 and tbl4[v5] then
            tbl3.SelectedIsland = v5
        end
    end

    local function fn7(arg)
        if not flag4 then
            task.spawn(function()
                local ok, result = pcall(function()
                    local v5 = syn
                    local request_ = v5 and syn.request or v2 and v2.request or request

                    local v6 = request_({
                        Url = "https://raw.githubusercontent.com/4LynxX/Coords/refs/heads/main/coords.json",
                        Method = "GET",
                    })

                    return HttpService:JSONDecode(v6.Body)
                end)

                if ok and result and type(result) == "table" then
                    table.clear(tbl4)
                    table.clear(tbl5)

                    for k, v5 in pairs(result) do
                        if v5.pos and v5.look then
                            tbl4[k] = {
                                pos = Vector3.new(v5.pos[1], v5.pos[2], v5.pos[3]),
                                look = Vector3.new(v5.look[1], v5.look[2], v5.look[3]),
                            }

                            table.insert(tbl5, k)
                        end
                    end

                    table.sort(tbl5)
                    flag4 = true
                    fn6()

                    if arg then
                        arg()
                    end

                    return
                end

                warn(string.format("[Teleport] Gagal load island coords (attempt %d/%d): %s", 1, 3, tostring(result)))
                task.wait(2)

                local ok2, result2 = pcall(function()
                    local v5 = syn
                    local request_ = v5 and syn.request or v2 and v2.request or request

                    local v6 = request_({
                        Url = "https://raw.githubusercontent.com/4LynxX/Coords/refs/heads/main/coords.json",
                        Method = "GET",
                    })

                    return HttpService:JSONDecode(v6.Body)
                end)

                if ok2 and result2 and type(result2) == "table" then
                    table.clear(tbl4)
                    table.clear(tbl5)

                    for k, v5 in pairs(result2) do
                        if v5.pos and v5.look then
                            tbl4[k] = {
                                pos = Vector3.new(v5.pos[1], v5.pos[2], v5.pos[3]),
                                look = Vector3.new(v5.look[1], v5.look[2], v5.look[3]),
                            }

                            table.insert(tbl5, k)
                        end
                    end

                    table.sort(tbl5)
                    flag4 = true
                    fn6()

                    if arg then
                        arg()
                    end

                    return
                end

                warn(string.format("[Teleport] Gagal load island coords (attempt %d/%d): %s", 2, 3, tostring(result2)))
                task.wait(2)

                local ok3, result3 = pcall(function()
                    local v5 = syn
                    local request_ = v5 and syn.request or v2 and v2.request or request

                    local v6 = request_({
                        Url = "https://raw.githubusercontent.com/4LynxX/Coords/refs/heads/main/coords.json",
                        Method = "GET",
                    })

                    return HttpService:JSONDecode(v6.Body)
                end)

                if ok3 and result3 and type(result3) == "table" then
                    table.clear(tbl4)
                    table.clear(tbl5)

                    for k, v5 in pairs(result3) do
                        if v5.pos and v5.look then
                            tbl4[k] = {
                                pos = Vector3.new(v5.pos[1], v5.pos[2], v5.pos[3]),
                                look = Vector3.new(v5.look[1], v5.look[2], v5.look[3]),
                            }

                            table.insert(tbl5, k)
                        end
                    end

                    table.sort(tbl5)
                    flag4 = true
                    fn6()

                    if arg then
                        arg()
                    end

                    return
                end

                warn(string.format("[Teleport] Gagal load island coords (attempt %d/%d): %s", 3, 3, tostring(result3)))
                warn("[Teleport] Island coords tidak bisa diload setelah 3 percobaan.")
                fn6()
            end)

            return
        end

        if arg then
            arg()
        end
    end

    fn7()

    str = {
        ["Shark Hunt"] = {
            Vector3.new(1.649, -1.35, 2095.72),
            Vector3.new(1369.94, -1.35, 930.125),
            Vector3.new(-1585.5, -1.35, 1242.87),
            Vector3.new(-1896.8, -1.35, 2634.37),
        },
        ["Worm Hunt"] = {
            Vector3.new(2190.85, -1.399, 97.574),
            Vector3.new(-2450.6, -1.399, 139.731),
            Vector3.new(-267.47, -1.399, 5188.53),
        },
        ["Megalodon Hunt"] = {
            Vector3.new(-1076.3, -1.399, 1676.19),
            Vector3.new(-1191.8, -1.399, 3597.3),
            Vector3.new(412.7, -1.399, 4134.39),
        },
        ["Ghost Shark Hunt"] = {
            Vector3.new(489.558, -1.35, 25.406),
            Vector3.new(-1358.2, -1.35, 4100.55),
            Vector3.new(627.859, -1.35, 3798.08),
        },
    }

    local function fn8(arg, arg2, arg3)
        lib:MakeNotify({Title = arg, Description = arg2, Delay = 3})
    end

    local function fn9()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        return humanoidRootPart
    end

    local function fn10(cFrame)
        tbl3.ForceTeleportCancel = false

        task.spawn(function()
            for i = 1, 10 do
                if tbl3.ForceTeleportCancel then
                    break
                end

                if flag2 then
                    task.wait(0.5)
                else
                    local v5 = fn9()

                    if v5 and v5.Parent then
                        v5.CFrame = cFrame
                    end

                    task.wait(0.1)
                end
            end
        end)
    end

    local function fn11()
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile("LynxGUI_Configs/LynxSavedLocationn.json"))
        end)

        if not ok or not result or type(result) ~= "table" then
            return nil
        end

        if #result == 12 then
            local cframe = nil
            if pcall(function()
                cframe = CFrame.new(table.unpack(result))
            end) and cframe then
                return cframe
            end
            warn("[SavedLocation] Gagal parse CFrame dari file lokasi")
            return nil
        end

        warn("[SavedLocation] File lokasi corrupt (jumlah komponen: " .. tostring(#result) .. "), expected 12")
        return nil
    end

    local function fn12(arg)
        if not arg then
            return false
        end

        local ok, result = pcall(function()
            local flag5 = arg.Parent ~= nil and arg:IsDescendantOf(workspace)
            return flag5
        end)

        local v5 = ok and result
        return v5
    end

    local function fn13(arg)
        if arg:IsA("Model") then
            if arg.PrimaryPart then
                return arg.PrimaryPart.Position
            end

            local ok, result, result2 = pcall(function()
                return arg:GetBoundingBox()
            end)

            if ok and result then
                return Vector3.new(result.Position.X, result.Position.Y - result2.Y / 4, result.Position.Z)
            end
        elseif arg:IsA("BasePart") then
            return arg.Position
        end

        return nil
    end

    local function fn14(arg)
        return Vector3.new(arg.X, arg.Y + tbl3.HeightOffset, arg.Z)
    end

    local fn15

    fn15 = function(arg, arg2, arg3)
        local n = arg3 or 0
        local v5 = n
        local tbl6 = arg2 or {}
        local v6 = tbl6
        if v5 > 4 then
            return
        end

        for i, child in ipairs(arg:GetChildren()) do
            if child.Name == "Props" and (child:IsA("Model") or child:IsA("Folder")) then
                table.insert(v6, child)
            end

            if child:IsA("Model") or child:IsA("Folder") then
                fn15(child, v6, v5 + 1)
            end
        end

        return v6
    end

    local function fn16()
        local events = ReplicatedStorage:FindFirstChild("Events")
        local v5 = events

        if not events then
            local ok, result = pcall(function()
                return ReplicatedStorage:WaitForChild("Events", 5)
            end)

            if ok and result then
                v5 = result
            end
        end

        if not v5 then
            return
        end
        tbl3.ReplicatedEventData = {}
        local v6, v7, v8 = ipairs(v5:GetChildren())
        local v9 = v8
        local v10 = v6
        local v11 = v7

        while true do
            local v12, v13 = v10(v11, v9)
            if v12 == nil then
                break
            end
            v9 = v12

            if v13:IsA("ModuleScript") then
                local ok, result = pcall(function()
                    return require(v13)
                end)

                if ok and result and type(result) == "table" and result.Name then
                    local tbl6 = {}

                    if result.Coordinates then
                        for i, coordinate in ipairs(result.Coordinates) do
                            table.insert(tbl6, coordinate)
                        end

                        v9 = v12
                    end

                    tbl3.ReplicatedEventData[result.Name] = {coords = tbl6, icon = result.Icon}
                end
            end
        end

        tbl3.EventDataLoaded = true
    end

    local function fn17()
        local now = tick()
        if now - tbl3.LastAutoScanTime < 3 then
            return tbl3.WorkspaceEventCache
        end
        tbl3.LastAutoScanTime = now

        if not tbl3.EventDataLoaded then
            fn16()
        end

        tbl3.WorkspaceEventCache = {}
        local v5, v6, v7 = ipairs(fn15(workspace))
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            local v13, v14, v15 = ipairs(v12:GetChildren())
            local v16 = v15
            local v17 = v13
            local v18 = v14
            local v19 = v11
            local v20 = v9
            local v21 = v10

            while true do
                local v22, v23 = v17(v18, v16)
                if v22 == nil then
                    break
                end
                v16 = v22
                local name = nil

                if tbl3.ReplicatedEventData[v23.Name] then
                    name = v23.Name
                else
                    for k in pairs(tbl3.ReplicatedEventData) do
                        if v23.Name:find(k, 1, true) or k:find(v23.Name, 1, true) then
                            name = k
                            break
                        end
                        continue
                    end

                    v16 = v22
                end

                if name and fn12(v23) then
                    local v24 = fn13(v23)

                    if v24 then
                        tbl3.WorkspaceEventCache[name] = {position = fn14(v24), object = v23}
                    end
                end
            end

            v8 = v19
            v9 = v20
            v10 = v21
        end

        return tbl3.WorkspaceEventCache
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Props" and tbl3.EventDataLoaded then
            task.wait(0.5)
            tbl3.LastAutoScanTime = 0
            fn17()
        end
    end)

    workspace.ChildRemoved:Connect(function(child)
        if child.Name == "Props" and tbl3.EventDataLoaded then
            tbl3.LastAutoScanTime = 0
            fn17()
        end
    end)

    local v5 = v3:AddTab({Name = "Teleport", Icon = "gps"})
    local v6 = v5:AddSection("Teleport to Island")
    local addDropdown = v6.AddDropdown
    local tbl6 = {Title = "Select Island", Multi = false}
    local options = #tbl5 > 0 and tbl5

    if not options then
        local tbl7 = {}
        options = tbl7
        tbl7[1] = "Loading..."
    end

    tbl6.Options = options
    tbl6.Default = nil

    tbl6.Callback = function(arg)
        local v7 = arg

        if type(arg) == "table" then
            local key, v8 = next(arg)
            local flag5 = type(key) == "number" and v8 or type(v8) == "boolean" and key or key
            v7 = flag5
        end

        if v7 ~= "Loading..." and v7 ~= "(Gagal load)" then
            local selectedIsland = type(v7) == "string" and v7 or ""
            tbl3.SelectedIsland = selectedIsland
            return
        end

        tbl3.SelectedIsland = ""
    end

    v4 = addDropdown(v6, tbl6)

    v6:AddButton({
        Title = "Teleport",
        Callback = function()
            if not flag4 then
                fn7(function()
                    fn8("Teleport", "Island list sudah dimuat, pilih island lalu tekan Teleport lagi.", nil)
                end)

                return
            end

            if tbl3.SelectedIsland and tbl3.SelectedIsland ~= "" then
                local v7 = tbl4[tbl3.SelectedIsland]
                if not v7 then
                    fn8("Teleport", "Island tidak valid!", Color3.fromRGB(255, 85, 127))
                    return
                end
                local character = localPlayer.Character
                local result = character or localPlayer.CharacterAdded:Wait()
                result:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(v7.pos, v7.look)
                fn8("Teleport", "Teleported to " .. tbl3.SelectedIsland, Color3.fromRGB(123, 239, 178))
                return
            end

            fn8("Teleport", "Pilih island dulu dari dropdown!", Color3.fromRGB(255, 179, 71))
        end,
    })

    local v7 = v5:AddSection("Teleport to Player", false)
    local tbl7 = {}
    local tbl8 = {}

    local function fn18(arg)
        local characters = workspace:FindFirstChild("Characters")
        local v8 = characters and characters:FindFirstChild(arg.Name)
        return v8
    end

    local function fn19()
        table.clear(tbl7)
        table.clear(tbl8)

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local displayName = player.DisplayName
                local name = displayName or player.Name
                local str2 = name .. " (" .. player.Name .. ")"
                table.insert(tbl7, str2)
                tbl8[str2] = player
            end
        end

        table.sort(tbl7)
    end

    fn19()

    local v8 = v7:AddDropdown({
        Title = "Select Player",
        Multi = false,
        Options = tbl7,
        Default = nil,
        NoSave = false,
        Callback = function(arg)
            local v8 = arg

            if type(arg) == "table" then
                local key, v9 = next(arg)
                local flag5 = type(key) == "number" and v9 or type(v9) == "boolean" and key or key
                v8 = flag5
            end

            local selectedPlayerLabel = type(v8) == "string" and v8 or ""
            tbl3.SelectedPlayer = tbl8[selectedPlayerLabel]
            tbl3.SelectedPlayerLabel = selectedPlayerLabel
        end,
    })

    v7:AddButton({
        Title = "Teleport to selected Player",
        Callback = function()
            if not tbl3.SelectedPlayer then
                fn8("Teleport", "Pilih player dulu dari dropdown!", Color3.fromRGB(255, 179, 71))
                return
            end
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if character and humanoidRootPart then
                local v9 = fn18(tbl3.SelectedPlayer)
                if not v9 then
                    fn8("Teleport", "Karakter target tidak ditemukan!", Color3.fromRGB(255, 85, 127))
                    return
                end
                local humanoidRootPart2 = v9:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart2 then
                    fn8("Teleport", "HumanoidRootPart target tidak ditemukan!", Color3.fromRGB(255, 85, 127))
                    return
                end
                humanoidRootPart.CFrame = humanoidRootPart2.CFrame * CFrame.new(0, 3, 0)
                local selectedPlayerLabel = tbl3.SelectedPlayerLabel
                local str2 = selectedPlayerLabel or ""
                fn8("Teleport", "Teleported to " .. str2, Color3.fromRGB(123, 239, 178))
                return
            end

            fn8("Teleport", "Karakter kamu belum siap!", Color3.fromRGB(255, 85, 127))
        end,
    })

    v7:AddButton({
        Title = "Refresh Player List",
        Callback = function()
            fn19()

            if v8 and v8.SetOptions then
                v8:SetOptions(tbl7)
            elseif v8 and v8.Refresh then
                v8:Refresh(tbl7)
            end

            fn8("Teleport", "Player list diperbarui.", Color3.fromRGB(100, 200, 255))
        end,
    })

    local v9 = nil
    local v10 = v5:AddSection("Saved Location", false)

    v10:AddButton({
        Title = "Save Current Location",
        Callback = function()
            local v11 = fn9()
            if not v11 then
                fn8("Error", "Character tidak ditemukan!", Color3.fromRGB(255, 85, 127))
                return
            end

            pcall(function()
                if not isfolder("LynxGUI_Configs") then
                    makefolder("LynxGUI_Configs")
                end
            end)

            if pcall(function()
                writefile("LynxGUI_Configs/LynxSavedLocationn.json", HttpService:JSONEncode({v11.CFrame:GetComponents()}))
            end) then
                fn8("Saved", "Lokasi berhasil disimpan!", Color3.fromRGB(123, 239, 178))
            else
                fn8("Error", "Gagal menyimpan lokasi!", Color3.fromRGB(255, 85, 127))
            end
        end,
    })

    v10:AddButton({
        Title = "Teleport to Saved",
        Callback = function()
            local v11 = fn11()
            if not v11 then
                fn8("Error", "Tidak ada lokasi tersimpan!", Color3.fromRGB(255, 85, 127))
                return
            end

            if not fn9() then
                fn8("Error", "Character tidak ditemukan!", Color3.fromRGB(255, 85, 127))
                return
            end
            fn10(v11)
            fn8("Teleported", "Teleport ke lokasi tersimpan berhasil!", Color3.fromRGB(123, 239, 178))
        end,
    })

    v10:AddButton({
        Title = "Reset Saved Location",
        Callback = function()
            tbl3.ForceTeleportCancel = true
            tbl3.AutoTeleportEnabled = false

            if tbl3.AutoTeleportConnection then
                tbl3.AutoTeleportConnection:Disconnect()
                tbl3.AutoTeleportConnection = nil
            end

            if v9 then
                pcall(function()
                    v9:SetValue(false)
                end)
            end

            local flag5 = false

            pcall(function()
                if isfile("LynxGUI_Configs/LynxSavedLocationn.json") then
                    delfile("LynxGUI_Configs/LynxSavedLocationn.json")
                    local flag6

                    if isfile("LynxGUI_Configs/LynxSavedLocationn.json") then
                        flag6 = false
                    else
                        flag6 = true
                    end

                    flag5 = flag6
                else
                    flag5 = true
                end
            end)

            tbl3.ForceTeleportCancel = false

            if flag5 then
                fn8("Reset", "Lokasi tersimpan & auto teleport telah direset.", Color3.fromRGB(255, 179, 71))
            else
                fn8("Error", "Gagal menghapus file lokasi!", Color3.fromRGB(255, 85, 127))
            end
        end,
    })

    v9 = v10:AddToggle({
        Title = "Auto Teleport on Spawn",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl3.AutoTeleportEnabled then
                    return
                end
                tbl3.AutoTeleportEnabled = true

                local function fn20(character)
                    task.spawn(function()
                        if not character:WaitForChild("HumanoidRootPart", 10) then
                            return
                        end
                        task.wait(1.5)
                        local n = 0

                        while flag2 and n < 30 do
                            task.wait(1)
                            n = n + 1
                        end

                        if n > 0 then
                            task.wait(1.5)
                        end

                        local v11 = fn11()

                        if v11 then
                            fn10(v11)
                            fn8("Auto Teleport", "Teleported ke lokasi tersimpan!", Color3.fromRGB(123, 239, 178))
                        end
                    end)
                end

                tbl3.AutoTeleportConnection = localPlayer.CharacterAdded:Connect(fn20)

                if localPlayer.Character then
                    fn20(localPlayer.Character)
                end
            else
                tbl3.AutoTeleportEnabled = false

                if tbl3.AutoTeleportConnection then
                    tbl3.AutoTeleportConnection:Disconnect()
                    tbl3.AutoTeleportConnection = nil
                end
            end
        end,
    })

    local tbl9 = {
        active = false,
        selectedEvents = {},
        priorityEvent = nil,
        loopThread = nil,
        origCF = nil,
        curCF = nil,
        curEventName = nil,
        flt = false,
        con = nil,
        charConn = nil,
        refreshThread = nil,
        wowAutoEnabled = false,
    }

    local v11 = (function()
        local v11 = fn3()

        if v11 then
            local ok, result = pcall(function()
                return v11.Client:GetReplion("Events")
            end)

            if ok and result then
                return result
            end

            local ok2, result2 = pcall(function()
                return v11.Client:WaitReplion("Events")
            end)

            if ok2 and result2 then
                return result2
            end
        end

        return nil
    end)()

    local v12 = fn(ReplicatedStorage:FindFirstChild("Events"))

    local tbl10 = {
        Cloudy = true,
        Day = true,
        ["Increased Luck"] = true,
        Mutated = true,
        Night = true,
        Snow = true,
        ["Sparkling Cove"] = true,
        Storm = true,
        Wind = true,
        Radiant = true,
        ["Present Rain"] = true,
        ["Admin - Super Mutated"] = true,
        ["Admin - Shocked"] = true,
        ["Admin - MEGA Luck"] = true,
        ["Admin - Super Luck"] = true,
        ["Admin - Night Celebration"] = true,
        ["Admin - Forgotten Tier"] = true,
        ["Admin - Galaxy Storm"] = true,
    }

    flag2 = false

    local function fn20()
        if not v11 then
            return {}
        end
        local Events = v11:Get("Events")
        if not Events then
            return {}
        end
        local tbl11 = {}

        for k, Event in pairs(Events) do
            if typeof(Event) == "string" then
                tbl11[Event] = true
            end
        end

        return tbl11
    end

    local function fn21()
        local tbl11 = {}
        if not v12 then
            return tbl11
        end

        for k, v13 in pairs(v12) do
            if v13.Coordinates and not tbl10[k] then
                table.insert(tbl11, k)
            end
        end

        local flag5 = false

        for i, v13 in ipairs(tbl11) do
            if string.find(v13, "Glacial Serpent") then
                flag5 = true
                break
            end
            continue
        end

        if not flag5 then
            table.insert(tbl11, "Glacial Serpent")
        end

        table.sort(tbl11)
        return tbl11
    end

    local function fn22(arg)
        local basePart = arg

        if arg then
            local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
            basePart = humanoidRootPart or arg:FindFirstChildWhichIsA("BasePart")
        end

        return basePart
    end

    local function fn23(arg, anchored)
        if not arg then
            return
        end

        for i, descendant in ipairs(arg:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = anchored
            end
        end
    end

    local function fn24(arg, arg2, arg3)
        if tbl9.con then
            tbl9.con:Disconnect()
            tbl9.con = nil
        end

        local flt = arg3 or false
        tbl9.flt = flt
        if not arg then
            return
        end
        local floatPart = arg:FindFirstChild("FloatPart")

        if floatPart then
            floatPart:Destroy()
        end

        if not arg3 then
            return
        end
        local v13 = arg2 or fn22(arg)
        local v14 = v13
        if not v13 then
            return
        end
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {arg}
        raycastParams.IgnoreWater = false
        local n = v14.Position + Vector3.new(0, 60, 0)
        local vector = Vector3.new(0, -220, 0)
        local hit = workspace:Raycast(n, vector, raycastParams)
        if not hit then
            return
        end
        local y = hit.Position.Y
        local hipHeight = humanoid and humanoid.HipHeight or 2
        local pivot = arg:GetPivot()
        arg:PivotTo(pivot.Rotation + Vector3.new(pivot.Position.X, y + hipHeight + 2.5, pivot.Position.Z))
    end

    local tbl11 = {}
    local tbl12 = {}

    local function createPart(arg)
        if not arg then
            return nil
        end

        if not string.find(arg, "Glacial Serpent") then
            local now = tick()

            if tbl11[arg] and tbl12[arg] and now - tbl12[arg] < 3 then
                local v13 = tbl11[arg]
                if v13 and v13.Parent then
                    return v13
                end
                tbl11[arg] = nil
            end

            local tbl13 = {}

            for i, child in ipairs(workspace:GetChildren()) do
                if child.Name == "Props" then
                    tbl13[#tbl13 + 1] = child
                end
            end

            local v13, v14, v15 = ipairs(tbl13)
            local v16 = v15
            local v17 = v13
            local v18 = v14

            while true do
                local v19, v20 = v17(v18, v16)
                if v19 == nil then
                    break
                end
                local v21, v22, v23 = ipairs(v20:GetChildren())
                local v24 = v23
                local v25 = v21
                local v26 = v22
                local v27 = v19
                local v28 = v17
                local v29 = v18

                while true do
                    local v30, v31 = v25(v26, v24)
                    if v30 == nil then
                        break
                    end

                    for i, descendant in ipairs(v31:GetDescendants()) do
                        if descendant:IsA("TextLabel") and descendant.Name == "DisplayName" then
                            local contentText = descendant.ContentText ~= "" and descendant.ContentText or descendant.Text

                            if contentText:lower() == arg:lower() then
                                local basePart = descendant:FindFirstAncestorWhichIsA("BasePart")

                                if not basePart then
                                    local part = v31:FindFirstChild("Part")

                                    if part and part:IsA("BasePart") then
                                        tbl11[arg] = part
                                        tbl12[arg] = now
                                        return part
                                    end

                                    continue
                                end

                                tbl11[arg] = basePart
                                tbl12[arg] = now
                                return basePart
                            end
                        end
                    end

                    v24 = v30
                end

                v16 = v27
                v17 = v28
                v18 = v29
            end

            local v19, v20, v21 = ipairs(tbl13)
            local v22 = v21
            local v23 = v19
            local v24 = v20

            while true do
                local v25, v26 = v23(v24, v22)
                if v25 == nil then
                    break
                end
                v22 = v25
                local v27 = v26:FindFirstChild(arg)

                if v27 then
                    local v28 = v27:FindFirstChild(arg, true)

                    if v28 and v28:IsA("BasePart") then
                        tbl11[arg] = v28
                        tbl12[arg] = now
                        return v28
                    end

                    local part = v27:FindFirstChild("Part")

                    if part and part:IsA("BasePart") then
                        tbl11[arg] = part
                        tbl12[arg] = now
                        return part
                    end

                    local v29 = nil
                    local huge = math.huge

                    for i, descendant in ipairs(v27:GetDescendants()) do
                        if descendant:IsA("BasePart") and descendant.Position.Y < huge and descendant.Position.Y > -10 then
                            huge = descendant.Position.Y
                            v29 = descendant
                        end
                    end

                    v22 = v25
                    if not v29 then
                        continue
                    end
                    tbl11[arg] = v29
                    tbl12[arg] = now
                    return v29
                end
            end

            local v25 = v12 and v12[arg]
            if not v25 or not v25.Coordinates or #v25.Coordinates <= 0 then
                return nil
            end
            local v26 = fn22(localPlayer.Character)
            local v27 = v25.Coordinates[1]

            if #v25.Coordinates > 1 and v26 then
                local huge = math.huge

                for i, coordinate in ipairs(v25.Coordinates) do
                    local magnitude = (v26.Position - coordinate).Magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v27 = coordinate
                    end
                end
            end

            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Size = Vector3.new(1, 1, 1)
            part.CFrame = CFrame.new(v27)
            part.Parent = workspace

            task.delay(5, function()
                pcall(function()
                    part:Destroy()
                end)
            end)

            return part
        end

        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Size = Vector3.new(1, 1, 1)
        part.CFrame = CFrame.new(Vector3.new(877.625, 3.919, 3692.855), Vector3.new(872.989, 3.919, 3683.995))
        part.Parent = workspace

        task.delay(5, function()
            pcall(function()
                part:Destroy()
            end)
        end)

        return part
    end

    local function fn25()
        tbl9.active = false

        if tbl9.loopThread then
            pcall(task.cancel, tbl9.loopThread)
            tbl9.loopThread = nil
        end

        if tbl9.charConn then
            pcall(function()
                tbl9.charConn:Disconnect()
            end)

            tbl9.charConn = nil
        end

        if tbl9.wowAutoEnabled and _G._wowToggleRef then
            tbl9.wowAutoEnabled = false

            pcall(function()
                _G._wowToggleRef:SetValue(false)
            end)
        end

        local character = localPlayer.Character
        fn23(character, false)
        fn24(character, nil, false)

        if tbl9.origCF and character then
            character:PivotTo(tbl9.origCF)
        end

        tbl9.origCF = nil
        tbl9.curCF = nil
        tbl9.curEventName = nil
    end

    local function fn26()
        if tbl9.active then
            fn25()
        end

        if #tbl9.selectedEvents == 0 and not tbl9.priorityEvent then
            return false
        end
        tbl9.active = true
        tbl9.origCF = nil
        tbl9.curCF = nil
        tbl9.curEventName = nil

        local thread = task.spawn(function()
            while tbl9.active do
                if flag2 then
                    task.wait(2)
                elseif _G._treasureHuntBusy then
                    task.wait(1)
                else
                    local v13 = fn20()
                    local v14 = nil
                    local priorityEvent = nil

                    if tbl9.priorityEvent and v13[tbl9.priorityEvent] then
                        local v15 = createPart(tbl9.priorityEvent)

                        if v15 then
                            v14 = v15
                            priorityEvent = tbl9.priorityEvent
                        end
                    end

                    if not v14 then
                        for i, selectedEvent in ipairs(tbl9.selectedEvents) do
                            if v13[selectedEvent] then
                                local v15 = createPart(selectedEvent)
                                if not v15 then
                                    continue
                                end
                                v14 = v15
                                priorityEvent = selectedEvent
                                break
                            end

                            continue
                        end
                    end

                    local character = localPlayer.Character
                    local v15 = fn22(character)

                    if v14 and v15 then
                        if tbl9.curEventName ~= priorityEvent then
                            fn23(character, false)
                            fn24(character, nil, false)
                            tbl9.curCF = nil
                            tbl9.curEventName = priorityEvent
                        end

                        if not tbl9.origCF then
                            tbl9.origCF = v15.CFrame
                        end

                        if (v15.Position - v14.Position).Magnitude > 40 then
                            local cframe

                            if string.find(priorityEvent, "Glacial Serpent") then
                                local position = v14.CFrame.Position
                                local lookVector = v14.CFrame.LookVector
                                cframe = CFrame.new(Vector3.new(position.X, position.Y + 10, position.Z), Vector3.new(position.X, position.Y + 10, position.Z) + lookVector)
                            else
                                local position = v14.Position
                                local n = v14.Position - Vector3.new(0, 0, 0)
                                cframe = CFrame.new(Vector3.new(position.X, position.Y + 10, position.Z), Vector3.new(position.X, position.Y + 10, position.Z) + v14.CFrame.LookVector)
                            end

                            tbl9.curCF = cframe
                            v15.CFrame = cframe
                            fn24(character, v15, false)
                            fn23(character, true)

                            task.delay(3, function()
                                if character and character.Parent then
                                    fn23(character, false)
                                end
                            end)
                        end
                    elseif v14 == nil and tbl9.curCF and v15 then
                        fn23(character, false)
                        fn24(character, nil, false)

                        if tbl9.origCF then
                            character:PivotTo(tbl9.origCF)
                            tbl9.origCF = nil
                        end

                        tbl9.curCF = nil
                        tbl9.curEventName = nil
                    end

                    task.wait(1)
                end
            end

            local character = localPlayer.Character
            fn23(character, false)
            fn24(character, nil, false)

            if tbl9.origCF and character then
                character:PivotTo(tbl9.origCF)
            end

            tbl9.origCF = nil
            tbl9.curCF = nil
            tbl9.curEventName = nil
        end)

        tbl9.loopThread = thread

        if tbl9.charConn then
            pcall(function()
                tbl9.charConn:Disconnect()
            end)

            tbl9.charConn = nil
        end

        local connection = localPlayer.CharacterAdded:Connect(function(character)
            if not tbl9.active then
                return
            end

            task.spawn(function()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
                task.wait(0.3)
                if not humanoidRootPart then
                    return
                end

                if tbl9.curCF then
                    if tbl9.curEventName and string.find(tbl9.curEventName, "Glacial Serpent") then
                        humanoidRootPart.CFrame = tbl9.curCF
                        fn24(character, humanoidRootPart, false)
                    else
                        character:PivotTo(tbl9.curCF)
                        fn24(character, humanoidRootPart, true)
                    end
                elseif tbl9.origCF then
                    character:PivotTo(tbl9.origCF)
                    fn24(character, humanoidRootPart, true)
                end
            end)
        end)

        tbl9.charConn = connection

        if _G._wowToggleRef and not _G._wowToggleRef:GetValue() then
            tbl9.wowAutoEnabled = true

            pcall(function()
                _G._wowToggleRef:SetValue(true)
            end)
        end

        return true
    end

    local v13 = v5:AddSection("Event Teleport", false)
    local v14 = nil
    local v15 = nil

    local function fn27(arg)
        local v16 = fn21()
        local tbl13 = {}

        for i, v17 in ipairs(v16) do
            tbl13[v17] = true
        end

        if v14 then
            local selectedEvents = {}

            for i, selectedEvent in ipairs(tbl9.selectedEvents) do
                if tbl13[selectedEvent] then
                    table.insert(selectedEvents, selectedEvent)
                end
            end

            v14:SetOptions(v16)
            tbl9.selectedEvents = selectedEvents
        end

        if v then
            v:SetOptions(v16)

            if tbl9.priorityEvent and not tbl13[tbl9.priorityEvent] then
                tbl9.priorityEvent = nil
            end
        end

        if not arg then
            fn8("Event Scan", "Ditemukan " .. #v16 .. " event.", Color3.fromRGB(100, 200, 255))
        end
    end

    v14 = v13:AddDropdown({
        Title = "Select Event",
        Options = fn21(),
        Default = nil,
        Multi = true,
        Callback = function(arg)
            local selectedEvents = type(arg) == "table" and arg

            if not selectedEvents then
                selectedEvents = arg

                if arg then
                    local tbl13 = {}
                    selectedEvents = tbl13
                    tbl13[1] = arg
                end

                if not selectedEvents then
                    selectedEvents = {}
                end
            end

            tbl9.selectedEvents = selectedEvents

            if v15 and v15:GetValue() and #tbl9.selectedEvents > 0 then
                fn25()
                task.wait(0.1)
                fn26()
            end
        end,
    })

    v = v13:AddDropdown({
        Title = "Priority Event",
        Options = fn21(),
        Default = nil,
        Multi = false,
        Callback = function(arg)
            local priorityEvent = arg and arg ~= "" and arg or nil
            tbl9.priorityEvent = priorityEvent

            if v15 and v15:GetValue() then
                fn25()
                task.wait(0.1)
                fn26()
            end
        end,
    })

    v13:AddButton({
        Title = "Refresh Event List",
        Callback = function()
            fn27(false)
        end,
    })

    v15 = v13:AddToggle({
        Title = "Auto Event Teleport",
        Default = false,
        Callback = function(arg)
            if arg then
                if #tbl9.selectedEvents == 0 then
                    fn8("Auto Teleport", "Pilih event terlebih dahulu!", Color3.fromRGB(255, 100, 100))

                    if v15 then
                        v15:SetValue(false)
                    end

                    return
                end

                if fn26() then
                    fn8("Auto Teleport", "Monitoring " .. #tbl9.selectedEvents .. " event...", Color3.fromRGB(100, 200, 255))
                else
                    fn8("Auto Teleport", "Gagal start. Pilih event lagi.", Color3.fromRGB(255, 180, 50))

                    if v15 then
                        v15:SetValue(false)
                    end
                end
            else
                fn25()
                fn8("Auto Teleport", "Auto teleport dimatikan.", Color3.fromRGB(255, 100, 100))
            end
        end,
    })

    if v11 then
        v11:OnChange("Events", fn5(function()
            if not tbl9.active then
                fn27(true)
            end
        end))
    end

    tbl9.refreshThread = task.spawn(function()
        task.wait(3)
        fn27(true)

        while task.wait(120) do
            if not tbl9.active then
                fn27(true)
            end
        end
    end)

    local v16 = v5:AddSection("Plaza Teleport", false)

    v16:AddButton({
        Title = "Teleport ke Trade Plaza",
        Callback = function()
            pcall(function()
                obj.RE_TradePlazaTeleport:FireServer(79378095465365)
            end)
        end,
    })

    v16:AddButton({
        Title = "Teleport ke Trade Plaza (Alt)",
        Callback = function()
            pcall(function()
                obj.RE_TradePlazaTeleport:FireServer(82602826017494)
            end)
        end,
    })

    local npc = nil
    local tbl13 = {}
    local v17 = nil
    local flag5 = false
    local v18 = nil
    local v19 = v5:AddSection("Teleport to NPC", false)

    local function fn28()
        if not npc then
            npc = workspace:FindFirstChild("NPC")
        end

        return npc
    end

    local function fn29()
        tbl13 = {}
        if not fn28() then
            return
        end

        for i, child in ipairs(npc:GetChildren()) do
            if child:IsA("Model") then
                table.insert(tbl13, child.Name)
            end
        end

        table.sort(tbl13, function(arg, arg2)
            local flag6 = arg < arg2
            return flag6
        end)

        if v18 and v18.SetOptions then
            v18:SetOptions(tbl13)
        elseif v18 and v18.Refresh then
            v18:Refresh(tbl13)
        end

        flag5 = true
    end

    v18 = v19:AddDropdown({
        Title = "Pilih NPC",
        Options = {},
        Default = "",
        Callback = function(arg)
            if not flag5 then
                fn29()
            end

            v17 = arg
        end,
    })

    v19:AddButton({
        Title = "Teleport to NPC",
        Callback = function()
            if not flag5 then
                fn29()
            end

            if v17 and v17 ~= "" then
                local v20 = npc
                local v21 = v20 and npc:FindFirstChild(v17)

                if not v21 then
                    lib:MakeNotify({
                        Title = "NPC TP",
                        Description = "NPC tidak ditemukan!",
                        Color = Color3.fromRGB(255, 100, 100),
                        Delay = 2,
                    })

                    return
                end

                local character = localPlayer.Character
                local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    return
                end

                local ok, result = pcall(function()
                    return v21:GetPivot()
                end)

                if ok and result then
                    humanoidRootPart.CFrame = result * CFrame.new(0, 0, 3)
                end

                return
            end

            lib:MakeNotify({
                Title = "NPC TP",
                Description = "Pilih NPC dulu!",
                Color = Color3.fromRGB(255, 100, 100),
                Delay = 2,
            })
        end,
    })

    v19:AddButton({
        Title = "Refresh List",
        Callback = function()
            fn29()

            lib:MakeNotify({
                Title = "NPC TP",
                Description = string.format("Ditemukan %d NPC", #tbl13),
                Color = Color3.fromRGB(123, 239, 178),
                Delay = 2,
            })
        end,
    })

    local v20 = nil
    local v21 = nil

    local function fn30()
        if not v20 then
            pcall(function()
                v20 = fn(ReplicatedStorage.Shared.ItemUtility)
            end)
        end

        return v20
    end

    local function fn31()
        if not v21 then
            pcall(function()
                v21 = fn2()
            end)
        end

        return v21
    end

    local obj2 = setmetatable({}, {
        __index = function(arg, arg2)
            local v22 = fn30()
            local v23 = v22 and v22[arg2]
            return v23
        end,
    })

    local obj3 = setmetatable({}, {
        __index = function(arg, arg2)
            local v22 = fn31()
            if not v22 then
                return nil
            end
            local v23 = v22[arg2]
            if type(v23) == "function" then
                return function(arg3, ...)
                    return v23(v22, ...)
                end
            end
            return v23
        end,
    })

    local v22 = v3:AddTab({Name = "Shop", Icon = "cart"})
    local v23 = v22:AddSection("Auto Sell")

    local tbl14 = {
        enabled = false,
        mode = "Timer",
        interval = 5,
        target = 235,
        lastSell = 0,
        timerTask = nil,
        countTask = nil,
        countConn = nil,
    }

    local function fn32()
        return obj.RF_SellAllItems
    end

    local function fn33(arg)
        if not arg or arg == "" then
            return 0
        end
        local str2 = tostring(arg):gsub("%D", "")
        local v24 = tonumber
        local str3 = str2 == "" and "0" or str2
        local v25 = v24(str3)
        local n = v25 or 0
        return n
    end

    local function fn34()
        local playerGui = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui then
            return nil
        end
        local inventory = playerGui:FindFirstChild("Inventory")
        if not inventory then
            return nil
        end
        local main = inventory:FindFirstChild("Main")
        local bagSize = main and inventory.Main:FindFirstChild("Top") and inventory.Main.Top:FindFirstChild("Options") and inventory.Main.Top.Options:FindFirstChild("Fish") and inventory.Main.Top.Options.Fish:FindFirstChild("Label") and inventory.Main.Top.Options.Fish.Label:FindFirstChild("BagSize")
        if bagSize and bagSize:IsA("TextLabel") then
            return bagSize
        end
        return inventory:FindFirstChild("BagSize", true)
    end

    local function fn35()
        local v24 = fn32()
        if not v24 then
            return
        end

        if tick() - tbl14.lastSell < 0.5 then
            return
        end

        pcall(function()
            v24:InvokeServer()
        end)

        tbl14.lastSell = tick()
    end

    local function fn36()
        if tbl14.timerTask then
            task.cancel(tbl14.timerTask)
            tbl14.timerTask = nil
        end

        if tbl14.countTask then
            task.cancel(tbl14.countTask)
            tbl14.countTask = nil
        end

        if tbl14.countConn then
            tbl14.countConn:Disconnect()
            tbl14.countConn = nil
        end
    end

    local function fn37()
        fn36()

        if tbl14.mode == "Timer" then
            tbl14.timerTask = task.spawn(function()
                while tbl14.enabled do
                    task.wait(tbl14.interval)

                    if tbl14.enabled then
                        fn35()
                    end
                end
            end)
        else
            (function()
                local v24 = fn34()

                if not v24 then
                    tbl14.countTask = task.spawn(function()
                        while tbl14.enabled do
                            task.wait(1)
                            local v25 = fn34()

                            if v25 then
                                local v26 = fn33(v25.Text:match("(.+)%/"))

                                if tbl14.target <= v26 then
                                    fn35()
                                end

                                if tbl14.countConn then
                                    tbl14.countConn:Disconnect()
                                end

                                tbl14.countConn = v25:GetPropertyChangedSignal("Text"):Connect(function()
                                    if not tbl14.enabled then
                                        return
                                    end
                                    local v27 = fn33(v25.Text:match("(.+)%/"))

                                    if tbl14.target <= v27 then
                                        fn35()
                                    end
                                end)

                                break
                            end

                            continue
                        end
                    end)

                    return
                end

                local v25 = fn33(v24.Text:match("(.+)%/"))

                if tbl14.target <= v25 then
                    fn35()
                end

                tbl14.countConn = v24:GetPropertyChangedSignal("Text"):Connect(function()
                    if not tbl14.enabled then
                        return
                    end
                    local v26 = fn33(v24.Text:match("(.+)%/"))

                    if tbl14.target <= v26 then
                        fn35()
                    end
                end)
            end)()
        end
    end

    v23:AddButton({Title = "Sell All Now", Callback = fn35})

    v23:AddDropdown({
        Title = "Auto Sell Mode",
        Options = {"Timer", "By Count"},
        Default = "Timer",
        Callback = function(mode)
            tbl14.mode = mode

            if tbl14.enabled then
                fn37()
            end
        end,
    })

    v23:AddInput({
        Title = "Value (Seconds / Fish Count)",
        Default = "5",
        Callback = function(arg)
            local interval = tonumber(arg)

            if interval and interval >= 1 then
                tbl14.interval = interval
                tbl14.target = interval

                if tbl14.enabled and tbl14.mode ~= "Timer" then
                    fn37()
                end
            end
        end,
    })

    v23:AddToggle({
        Title = "Enable Auto Sell",
        Default = false,
        Callback = function(enabled)
            tbl14.enabled = enabled

            if enabled then
                if not fn32() then
                    tbl14.enabled = false
                    return
                end
                fn37()
            else
                fn36()
            end
        end,
    })

    local tbl15 = {
        enabled = false,
        selected = {},
        task = nil,
        cooldownNotified = {},
    }

    local v24 = v22:AddSection("Buy Weather", false)

    v24:AddDropdown({
        Title = "Weather",
        Multi = true,
        Options = (function()
            local ok, result = pcall(function()
                return require(game.ReplicatedStorage.Events)
            end)

            if not ok or type(result) ~= "table" then
                return {}
            end
            local tbl16 = {}

            for k, v25 in pairs(result) do
                if type(v25) == "table" and v25.WeatherMachine and v25.WeatherMachinePrice then
                    table.insert(tbl16, k)
                end
            end

            table.sort(tbl16)
            return tbl16
        end)(),
        Default = {},
        Callback = function(arg)
            local selected = type(arg) == "table" and arg or {}
            tbl15.selected = selected
        end,
    })

    v24:AddToggle({
        Title = "Enable Auto Buy Weather",
        Default = false,
        Callback = function(enabled)
            tbl15.enabled = enabled

            if tbl15.task then
                pcall(task.cancel, tbl15.task)
                tbl15.task = nil
            end

            if not enabled then
                tbl15.cooldownNotified = {}

                lib:MakeNotify({
                    Title = "Auto Buy Weather",
                    Description = "Stopped.",
                    Delay = 2,
                })

                return
            end

            if #tbl15.selected == 0 then
                tbl15.enabled = false

                lib:MakeNotify({
                    Title = "Auto Buy Weather",
                    Description = "Pilih cuaca dulu.",
                    Delay = 3,
                })

                return
            end

            tbl15.task = task.spawn(function()
                local Replion = require(game.ReplicatedStorage.Packages.Replion)
                local Events = Replion.Client:WaitReplion("Events")
                local Data = Replion.Client:WaitReplion("Data")
                local rfPurchaseWeatherEvent = obj.RF_PurchaseWeatherEvent

                lib:MakeNotify({
                    Title = "Auto Buy Weather",
                    Description = "Active!",
                    Delay = 2,
                })

                while tbl15.enabled do
                    local ok, result = pcall(function()
                        local WeatherMachine = Events:Get("WeatherMachine")
                        local tbl16 = WeatherMachine or {}
                        return tbl16
                    end)

                    if ok then
                        local n = #result

                        for i, v25 in ipairs(tbl15.selected) do
                            if not tbl15.enabled or n >= 3 then
                                break
                            end
                            local Events2 = Events:Find("Events", v25)
                            local WeatherMachine = Events:Find("WeatherMachine", v25)
                            local v26 = nil

                            pcall(function()
                                local WeatherCooldown = Data:Get("WeatherCooldown")
                                local tbl16 = WeatherCooldown or {}
                                v26 = tbl16[v25]
                            end)

                            local flag6 = v26 and DateTime.now().UnixTimestamp < v26

                            if flag6 then
                                if not tbl15.cooldownNotified[v25] then
                                    local v27 = math.ceil((v26 - DateTime.now().UnixTimestamp) / 60)

                                    lib:MakeNotify({
                                        Title = v25,
                                        Description = "Cooldown: " .. v27 .. " menit lagi",
                                        Delay = 3,
                                    })

                                    tbl15.cooldownNotified[v25] = true
                                end
                            else
                                tbl15.cooldownNotified[v25] = nil
                            end

                            if not Events2 and not WeatherMachine and not flag6 then
                                local ok2, result2 = pcall(function()
                                    return rfPurchaseWeatherEvent:InvokeServer(v25)
                                end)

                                if ok2 and result2 then
                                    n = n + 1
                                    tbl15.cooldownNotified[v25] = nil

                                    lib:MakeNotify({
                                        Title = "Auto Buy Weather",
                                        Description = v25 .. " berhasil diaktifkan!",
                                        Delay = 3,
                                    })
                                end

                                task.wait(1)
                            end
                        end
                    end

                    task.wait(15)
                end
            end)
        end,
    })

    local tbl16 = {enabled = false, thread = nil, buying = false}
    local v25 = v22:AddSection("Buy Black Market", false)
    local v26 = v25:AddParagraph({Title = "Status", Content = "Idle"})
    local tbl17 = {}
    local tbl18 = {}
    local tbl19 = {}
    local v27 = fn(game:GetService("ReplicatedStorage").Shared.BlackMarketConfig)

    pcall(function()
        for i, v28 in ipairs(v27.GetItems()) do
            local displayName = v28.DisplayName
            local id = displayName or v28.Id
            table.insert(tbl17, id)
            tbl18[id] = v28
        end
    end)

    local v28 = v25:AddDropdown({
        Title = "Select Item",
        Multi = true,
        Options = tbl17,
        Default = {},
        NoSave = true,
        Callback = function(arg)
            local tbl20 = type(arg) == "table" and arg or {}
            tbl19 = tbl20
        end,
    })

    v25:AddButton({
        Title = "Refresh Item List",
        Callback = function()
            table.clear(tbl17)
            table.clear(tbl18)
            tbl19 = {}
            local v29 = fn(game:GetService("ReplicatedStorage").Shared.BlackMarketConfig)

            pcall(function()
                for i, v30 in ipairs(v29.GetItems()) do
                    local displayName = v30.DisplayName
                    local id = displayName or v30.Id
                    table.insert(tbl17, id)
                    tbl18[id] = v30
                end
            end)

            if v28 and v28.SetOptions then
                v28:SetOptions(tbl17)
            end

            lib:MakeNotify({
                Title = "Black Market",
                Description = "List diperbarui.",
                Delay = 2,
            })
        end,
    })

    v25:AddToggle({
        Title = "Auto Buy Black Market",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl16.enabled = enabled

            if tbl16.thread then
                pcall(task.cancel, tbl16.thread)
                tbl16.thread = nil
            end

            if not enabled then
                tbl16.buying = false

                pcall(function()
                    v26:SetTitle("Status")
                    v26:SetContent("Idle")
                end)

                lib:MakeNotify({Title = "Auto Buy BM", Description = "Stopped.", Delay = 2})
                return
            end

            if #tbl19 == 0 then
                pcall(function()
                    v26:SetTitle("Status")
                    v26:SetContent("Pilih item dulu!")
                end)

                lib:MakeNotify({
                    Title = "Auto Buy BM",
                    Description = "Pilih item dulu!",
                    Delay = 2,
                })

                return
            end

            lib:MakeNotify({Title = "Auto Buy BM", Description = "Active!", Delay = 2})

            tbl16.thread = task.spawn(function()
                local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
                local v29 = fn(ReplicatedStorage2.Shared.BlackMarketConfig)
                local v30 = fn(ReplicatedStorage2.Modules.CurrencyUtility)
                local Replion = require(ReplicatedStorage2.Packages.Replion)
                local RunService2 = game:GetService("RunService")
                local v31 = nil
                local Data = nil
                local path = nil

                pcall(function()
                    v31 = Replion.Client:WaitReplion(v29.ChannelName)
                    Data = Replion.Client:WaitReplion("Data")
                    path = v30:GetCurrency("Coins").Path
                end)

                local function fn38(arg, arg2)
                    pcall(function()
                        v26:SetTitle(arg)
                        v26:SetContent(arg2)
                    end)
                end

                local function fn39(arg)
                    if not v31 then
                        return 0
                    end
                    local Items = v31:Get("Items")
                    if not Items or not Items[arg] then
                        return 0
                    end
                    local stock = Items[arg].Stock
                    local n = stock or 0
                    return n
                end

                local function fn40()
                    if not Data or not path then
                        return math.huge
                    end

                    local ok, result = pcall(function()
                        return Data:Get(path)
                    end)

                    local huge = ok and type(result) == "number" and result or math.huge
                    return huge
                end

                local function fn41(arg)
                    if not arg or not arg.Price then
                        return true
                    end
                    local v32 = fn40()
                    local flag6 = arg.Price <= v32
                    return flag6
                end

                local function fn42()
                    for i, descendant in ipairs(workspace:GetDescendants()) do
                        if descendant:IsA("BasePart") and descendant.Name == "Blackmarket Dealer" then
                            return descendant
                        end
                    end
                end

                local function fn43(arg)
                    if not arg then
                        return false
                    end

                    if fn39(arg.Id) <= 0 then
                        return false
                    end

                    local ok, result = pcall(function()
                        return obj.RF_PurchaseBlackMarketItem:InvokeServer(arg.Id)
                    end)

                    local success = ok and result and result.Success
                    return success
                end

                local function fn44(arg)
                    if not arg or not arg.SingleCopy then
                        return false
                    end

                    if not Data then
                        return false
                    end
                    local rewardInfo = arg.RewardInfo
                    if not rewardInfo or rewardInfo.Type == "Currency" then
                        return false
                    end
                    local v32 = fn(ReplicatedStorage2.Shared.ItemUtility)
                    local v33 = fn(ReplicatedStorage2.Shared.InventoryMapping)

                    local ok, result = pcall(function()
                        local v34 = v32.GetItemDataFromItemType(rewardInfo.Type, rewardInfo.Identifier)
                        if not v34 then
                            return false
                        end
                        local v35 = v33[v34.Data.Type]
                        local str2 = v35 or "Items"
                        local Inventory = Data:Get("Inventory")
                        if not Inventory then
                            return false
                        end
                        local v36 = Inventory[str2]
                        if not v36 then
                            return false
                        end

                        for i, v37 in ipairs(v36) do
                            if v37.Id == v34.Data.Id then
                                return true
                            end
                        end

                        return false
                    end)

                    local v34 = ok and result
                    return v34
                end

                local function fn45(arg, arg2)
                    if not arg or not arg2 then
                        return
                    end

                    pcall(function()
                        local n = 0
                        local connection = nil

                        connection = RunService2.Heartbeat:Connect((function(V, t)
                            return function(L)
                                n = n + L

                                pcall(function()
                                    V.CFrame = t
                                    V.Velocity = Vector3.zero
                                    V.RotVelocity = Vector3.zero
                                end)

                                if n >= 0.5 then
                                    connection:Disconnect()
                                end
                            end
                        end)(arg, arg2))

                        while connection.Connected do
                            task.wait()
                        end
                    end)
                end

                local function fn46()
                    for i, v32 in ipairs(tbl19) do
                        local v33 = tbl18[v32]
                        if v33 and not fn44(v33) and fn39(v33.Id) > 0 and fn41(v33) then
                            return true
                        end
                    end

                    return false
                end

                local function fn47()
                    if not v31 then
                        task.wait(10)
                        return
                    end
                    local flag6 = false
                    local Items = nil

                    Items = v31:OnChange("Items", function(arg)
                        if not tbl16.enabled or flag6 then
                            return
                        end

                        if not arg then
                            return
                        end

                        for i, v32 in ipairs(tbl19) do
                            local v33 = tbl18[v32]

                            if v33 and arg[v33.Id] then
                                local stock = arg[v33.Id].Stock
                                local n = stock or 0

                                if n > 0 then
                                    flag6 = true
                                    Items:Disconnect()
                                    return
                                end
                            end
                        end
                    end)

                    while tbl16.enabled and not flag6 do
                        task.wait(1)
                    end

                    if Items then
                        pcall(function()
                            Items:Disconnect()
                        end)
                    end
                end

                while tbl16.enabled do
                    if tbl16.buying then
                        task.wait(1)
                    elseif #tbl19 == 0 then
                        task.wait(1)
                    else
                        local flag6 = false

                        for i, v32 in ipairs(tbl19) do
                            if not tbl16.enabled or tbl16.buying then
                                break
                            end
                            local v33 = tbl18[v32]

                            if v33 then
                                if fn44(v33) then
                                    fn38("Status", v32 .. " sudah dimiliki — skip.")
                                else
                                    local v34 = fn39(v33.Id)

                                    if v34 <= 0 then
                                        fn38("Status", v32 .. " — out of stock, skip.")
                                    elseif fn41(v33) then
                                        flag6 = true
                                        tbl16.buying = true
                                        fn38("Status", "Stock: " .. v34 .. " — Beli " .. v32 .. "...")
                                        local character = localPlayer.Character
                                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                                        local cFrame = humanoidRootPart and humanoidRootPart.CFrame or nil
                                        local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                                        local jumpPower = humanoid and humanoid.JumpPower or 50
                                        local v35 = fn42()
                                        local cFrame2 = v35 and v35.CFrame * CFrame.new(0, 0, -3)

                                        if humanoid then
                                            pcall(function()
                                                humanoid.WalkSpeed = 0
                                                humanoid.JumpPower = 0
                                                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                                            end)
                                        end

                                        if humanoidRootPart and cFrame2 then
                                            pcall(function()
                                                humanoidRootPart.CFrame = cFrame2
                                                humanoidRootPart.Velocity = Vector3.zero
                                                humanoidRootPart.RotVelocity = Vector3.zero
                                            end)

                                            task.wait(0.3)
                                        end

                                        local thread = task.spawn(function()
                                            while tbl16.buying do
                                                pcall(function()
                                                    if humanoidRootPart and cFrame2 then
                                                        humanoidRootPart.CFrame = cFrame2
                                                        humanoidRootPart.Velocity = Vector3.zero
                                                        humanoidRootPart.RotVelocity = Vector3.zero
                                                    end
                                                end)

                                                task.wait()
                                            end
                                        end)

                                        local n = 0
                                        local n2 = 0

                                        while tbl16.enabled and fn39(v33.Id) > 0 do
                                            if not fn41(v33) then
                                                fn38("Status", "Coin kurang — timeout " .. 8 - math.floor(n2) .. "s...")
                                                task.wait(1)
                                                local n3 = n2 + 1
                                                n2 = n3
                                                if n3 >= 8 then
                                                    break
                                                end
                                                continue
                                            end

                                            if not fn43(v33) then
                                                local n3 = n2 + 1
                                                n2 = n3
                                                fn38("Status", "Server reject — retry... (" .. 8 - math.floor(n3) .. "s)")
                                                task.wait(1)
                                                if n3 >= 8 then
                                                    break
                                                end
                                                continue
                                            end

                                            local n3 = n + 1
                                            n = n3
                                            n2 = 0
                                            fn38("Status", "Dibeli x" .. n3 .. " " .. v32 .. " — sisa: " .. fn39(v33.Id))
                                            if v33.SingleCopy then
                                                break
                                            end
                                            task.wait(0.3)
                                        end

                                        tbl16.buying = false
                                        pcall(task.cancel, thread)

                                        if humanoid then
                                            pcall(function()
                                                humanoid.WalkSpeed = walkSpeed
                                                humanoid.JumpPower = jumpPower
                                                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                            end)
                                        end

                                        fn45(humanoidRootPart, cFrame)

                                        if n > 0 then
                                            lib:MakeNotify({
                                                Title = "Auto Buy BM",
                                                Description = "Dibeli x" .. n .. " " .. v32 .. "!",
                                                Delay = 3,
                                            })
                                        end

                                        task.wait(0.5)
                                    else
                                        fn38("Status", v32 .. " — coin kurang, skip.")
                                    end
                                end
                            end
                        end

                        if tbl16.enabled then
                            if not flag6 and not fn46() then
                                fn38("Status", "Semua item out of stock — nunggu restock...")
                                fn47()
                            else
                                task.wait(5)
                            end
                        end
                    end
                end
            end)
        end,
    })

    local tbl20 = {enabled = false, thread = nil, amount = 1}
    local v29 = v22:AddSection("Buy Battlepass Shop", false)
    local v30 = v29:AddParagraph({Title = "Status", Content = "Idle"})

    local function fn38(arg, arg2)
        pcall(function()
            v30:SetTitle(arg)
            v30:SetContent(arg2)
        end)
    end

    local tbl21 = {}
    local tbl22 = {}
    local v31 = fn(game:GetService("ReplicatedStorage").Shared.BattlepassShop)

    for k, v32 in pairs(v31) do
        local str2 = nil

        pcall(function()
            local rewardInfo = v32.RewardInfo
            local price = v32.Price

            if rewardInfo.Type == "Currency" then
                local quantity = rewardInfo.Quantity
                local amount = quantity or rewardInfo.Amount or 1
                local name = rewardInfo.Name
                local str3 = name or "Currency"
                str2 = string.format("Slot %d — +%d %s [%d]", k, amount, str3, price)
            else
                local identifier = rewardInfo.Identifier
                local type_ = identifier or rewardInfo.Type
                str2 = string.format("Slot %d — %s [%d]", k, type_, price)
            end
        end)

        if str2 then
            table.insert(tbl21, str2)
            tbl22[str2] = k
        end
    end

    table.sort(tbl21, function(arg, arg2)
        local num = tonumber(arg:match("^Slot (%d+)"))
        local n = num or 0
        local num2 = tonumber(arg2:match("^Slot (%d+)"))
        local n2 = num2 or 0
        local flag6 = n < n2
        return flag6
    end)

    local tbl23 = {}

    v29:AddDropdown({
        Title = "Item yang Dibeli",
        Multi = true,
        Options = tbl21,
        Default = {},
        Callback = function(arg)
            tbl23 = arg
        end,
    })

    v29:AddInput({
        Title = "Jumlah Pembelian",
        Default = "1",
        Callback = function(arg)
            local num = tonumber(arg)
            local amount = num and num > 0 and math.floor(num) or 1
            tbl20.amount = amount
        end,
    })

    v29:AddToggle({
        Title = "Auto Buy Balttlepass",
        Default = false,
        Callback = function(enabled)
            tbl20.enabled = enabled

            if tbl20.thread then
                pcall(task.cancel, tbl20.thread)
                tbl20.thread = nil
            end

            if not enabled then
                fn38("Status", "Idle")

                lib:MakeNotify({
                    Title = "Auto Buy BP",
                    Description = "Dihentikan.",
                    Delay = 2,
                })

                return
            end

            tbl20.thread = task.spawn(function()
                local reBPPurchaseRequest = obj.RE_BPPurchaseRequest
                local v32 = fn3()

                local function fn39(arg)
                    local flag6 = false

                    pcall(function()
                        local expect = v32:GetExpect({"GalaxyBP26"})
                        local flag7 = expect and expect[tostring(arg)] ~= nil
                        flag6 = flag7
                    end)

                    return flag6
                end

                local function fn40(arg)
                    if fn39(arg) then
                        return false, "already_owned"
                    end

                    local ok, result = pcall(function()
                        reBPPurchaseRequest:FireServer(arg)
                    end)

                    return ok, result
                end

                lib:MakeNotify({
                    Title = "Auto Buy BP",
                    Description = "Berjalan...",
                    Delay = 2,
                })

                fn38("Status", "Berjalan...")
                local n = 0
                local tbl24 = {}

                for i, v33 in ipairs(tbl23) do
                    local v34 = tbl22[v33]

                    if v34 then
                        table.insert(tbl24, v34)
                    end
                end

                if #tbl24 == 0 then
                    fn38("Status", "Tidak ada item dipilih")

                    lib:MakeNotify({
                        Title = "Auto Buy BP",
                        Description = "Pilih item dulu!",
                        Delay = 3,
                    })

                    tbl20.enabled = false
                    return
                end

                local n2 = #tbl24 * tbl20.amount

                while tbl20.enabled do
                    local v33, v34, v35 = ipairs(tbl24)
                    local v36 = v35
                    local v37 = v33
                    local v38 = v34

                    while true do
                        local v39, v40 = v37(v38, v36)
                        if v39 == nil then
                            break
                        end

                        if not tbl20.enabled then
                            break
                        end

                        for i = 1, tbl20.amount do
                            if not tbl20.enabled then
                                break
                            end
                            local v41, v42 = fn40(v40)

                            if v42 == "already_owned" then
                                local n3 = n + 1
                                n = n3
                                fn38(string.format("Beli %d/%d", n3, n2), string.format("Slot %d sudah dimiliki, skip", v40))
                            elseif v41 then
                                local n3 = n + 1
                                n = n3
                                fn38(string.format("Beli %d/%d", n3, n2), string.format("Slot %d berhasil dibeli", v40))
                            else
                                fn38(string.format("Gagal — Slot %d", v40), tostring(v42))
                            end

                            task.wait(0.5)
                        end

                        v36 = v39
                    end

                    if n2 <= n then
                        fn38("Selesai", string.format("Total %d item dibeli", n))

                        lib:MakeNotify({
                            Title = "Auto Buy BP",
                            Description = string.format("Selesai! %d item dibeli.", n),
                            Delay = 3,
                        })

                        tbl20.enabled = false
                        break
                    end

                    task.wait(1)
                end

                fn38("Status", "Idle")
            end)
        end,
    })

    local v32 = v22:AddSection("Sell Present")
    local tbl24 = {enabled = false, interval = 10, task = nil, lastSell = 0}

    v32:AddInput({
        Title = "Interval (Seconds)",
        Default = "10",
        Callback = function(arg)
            local interval = tonumber(arg)

            if interval and interval >= 1 then
                tbl24.interval = interval
            end
        end,
    })

    v32:AddToggle({
        Title = "Enable Auto Sell Present",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl24.enabled then
                    return
                end
                local rfSellItem = obj.RF_SellItem
                if not rfSellItem or not obj3 or not obj2 then
                    return
                end
                tbl24.enabled = true

                tbl24.task = task.spawn(function()
                    while tbl24.enabled do
                        pcall(function()
                            if tick() - tbl24.lastSell >= 0.5 then
                                local expect = obj3:GetExpect({"Inventory", "Items"})

                                for i, v33 in ipairs(expect) do
                                    local itemData = obj2:GetItemData(v33.Id)

                                    if itemData and itemData.Present == true then
                                        pcall(function()
                                            rfSellItem:InvokeServer(v33.UUID)
                                        end)

                                        task.wait(0.1)
                                    end
                                end

                                tbl24.lastSell = tick()
                            end
                        end)

                        task.wait(tbl24.interval)
                    end
                end)
            else
                tbl24.enabled = false

                if tbl24.task then
                    task.cancel(tbl24.task)
                    tbl24.task = nil
                end
            end
        end,
    })

    v32:AddButton({
        Title = "Sell Present Now",
        Callback = function()
            local rfSellItem = obj.RF_SellItem
            if not rfSellItem or not obj3 or not obj2 then
                return
            end

            pcall(function()
                local expect = obj3:GetExpect({"Inventory", "Items"})

                for i, v33 in ipairs(expect) do
                    local itemData = obj2:GetItemData(v33.Id)

                    if itemData and itemData.Present == true then
                        pcall(function()
                            rfSellItem:InvokeServer(v33.UUID)
                        end)

                        task.wait(0.1)
                    end
                end
            end)
        end,
    })

    local v33 = v22:AddSection("Remote Merchant")
    local playerGui = localPlayer:FindFirstChild("PlayerGui")

    v33:AddButton({
        Title = "Open Merchant",
        Callback = function()
            pcall(function()
                local playerGui2 = playerGui or localPlayer:WaitForChild("PlayerGui", 5)
                local merchant = playerGui2

                if playerGui2 then
                    local merchant2 = playerGui2:FindFirstChild("Merchant")
                    merchant = merchant2 or playerGui2:WaitForChild("Merchant", 3)
                end

                if merchant then
                    merchant.Enabled = true
                end
            end)
        end,
    })

    v33:AddButton({
        Title = "Close Merchant",
        Callback = function()
            pcall(function()
                local playerGui2 = playerGui or localPlayer:FindFirstChild("PlayerGui")
                local merchant = playerGui2 and playerGui2:FindFirstChild("Merchant")

                if merchant then
                    merchant.Enabled = false
                end
            end)
        end,
    })

    local v34 = v22:AddSection("Buy Merchant Items", false)

    local tbl25 = {
        enabled = false,
        task = nil,
        selectedItem = nil,
        amount = 1,
        boughtCount = 0,
        data = nil,
        merchantData = nil,
    }

    local tbl26 = {}
    local tbl27 = {}

    local v35 = v34:AddParagraph({
        Title = "Status",
        Content = "Item   : -\nHarga  : -\nDibeli : 0 / 0",
    })

    local v36 = v34:AddDropdown({
        Title = "Pilih Item",
        Options = {},
        NoSave = true,
        Callback = function(arg)
            tbl25.selectedItem = tbl27[arg]
            tbl25.boughtCount = 0
            local selectedItem = tbl25.selectedItem
            local setContent = v35.SetContent
            local name = selectedItem and selectedItem.name or "-"
            local str2 = selectedItem and tostring(selectedItem.price) .. " " .. selectedItem.currency or "-"
            setContent(v35, string.format("Item   : %s\nHarga  : %s\nDibeli : %d / %d", name, str2, 0, tbl25.amount))
        end,
    })

    v34:AddInput({
        Title = "Jumlah Beli",
        Default = "1",
        Numeric = true,
        NoSave = true,
        Callback = function(arg)
            local num = tonumber(arg)

            if num and num >= 1 then
                tbl25.amount = math.floor(num)
            end
        end,
    })

    v34:AddButton({
        Title = "Refresh Item Merchant",
        Callback = function()
            if pcall(function()
                local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
                local Replion = require(ReplicatedStorage2.Packages.Replion)

                if not tbl25.data then
                    tbl25.data = Replion.Client:WaitReplion("Data")
                end

                if not tbl25.merchantData then
                    tbl25.merchantData = Replion.Client:WaitReplion("Merchant")
                end
            end) and tbl25.merchantData then
                tbl26 = {}
                tbl27 = {}

                pcall(function()
                    local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
                    local ItemUtility = require(ReplicatedStorage2.Shared.ItemUtility)
                    local MarketItemData = require(ReplicatedStorage2.Shared.MarketItemData)
                    local CurrencyUtility = require(ReplicatedStorage2.Modules.CurrencyUtility)
                    local expect = tbl25.merchantData:GetExpect("Items")
                    local v37, v38, v39 = ipairs(expect)
                    local v40 = v39
                    local v41 = v37
                    local v42 = v38

                    while true do
                        local v43, v44 = v41(v42, v40)
                        if v43 == nil then
                            break
                        end
                        local v45 = nil

                        for k, v46 in MarketItemData do
                            if v46.Id == v44 then
                                v45 = v46
                                break
                            end
                        end

                        v40 = v43

                        if v45 and not v45.SkinCrate and not v45.ProductId and v45.Price and v45.Currency then
                            local v46 = ItemUtility.GetItemDataFromItemType(v45.Type, v45.Identifier)

                            if v46 then
                                local currency = CurrencyUtility:GetCurrency(v45.Currency)

                                if currency then
                                    local tbl28 = {id = v44}
                                    local name = v46.Data.Name
                                    local name2 = name or "Item #" .. v44
                                    tbl28.name = name2
                                    tbl28.price = v45.Price
                                    tbl28.currency = v45.Currency
                                    tbl28.currencyPath = currency.Path
                                    table.insert(tbl26, tbl28.name)
                                    tbl27[tbl28.name] = tbl28
                                end
                            end
                        end
                    end
                end)

                v36:SetOptions(tbl26)

                if tbl25.selectedItem and not tbl27[tbl25.selectedItem.name] then
                    tbl25.selectedItem = nil
                end

                if not tbl25.selectedItem and #tbl26 > 0 then
                    tbl25.selectedItem = tbl27[tbl26[1]]
                end

                lib:MakeNotify({
                    Title = "Auto Buy Merchant",
                    Description = string.format("Ditemukan %d item di merchant", #tbl26),
                    Delay = 3,
                })

                return
            end

            warn("[AutoBuyMerchant] Gagal init refs.")
        end,
    })

    v34:AddToggle({
        Title = "Auto Buy",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl25.enabled then
                    return
                end

                if not tbl25.data or not tbl25.merchantData then
                    lib:MakeNotify({
                        Title = "Auto Buy Merchant",
                        Description = "Tekan Refresh dulu!",
                        Delay = 3,
                    })

                    return
                end

                if not tbl25.selectedItem then
                    lib:MakeNotify({
                        Title = "Auto Buy Merchant",
                        Description = "Pilih item dulu dari dropdown!",
                        Delay = 3,
                    })

                    return
                end

                tbl25.enabled = true
                tbl25.boughtCount = 0

                tbl25.task = task.spawn(function()
                    while tbl25.enabled do
                        if tbl25.amount <= tbl25.boughtCount then
                            tbl25.enabled = false

                            lib:MakeNotify({
                                Title = "Auto Buy Merchant",
                                Description = string.format("Selesai! Terbeli %d x %s", tbl25.boughtCount, tbl25.selectedItem.name),
                                Delay = 4,
                            })

                            break
                        end

                        local selectedItem = tbl25.selectedItem
                        local v37 = tbl25.data:Get(selectedItem.currencyPath)
                        local n = v37 or 0

                        if n < selectedItem.price then
                            tbl25.enabled = false

                            lib:MakeNotify({
                                Title = "Auto Buy Merchant",
                                Description = "Saldo tidak cukup, dihentikan.",
                                Delay = 4,
                            })

                            break
                        end

                        local ok, result = pcall(function()
                            return obj.RF_PurchaseMarketItem:InvokeServer(selectedItem.id)
                        end)

                        if ok and result then
                            tbl25.boughtCount = tbl25.boughtCount + 1
                            v35:SetContent(string.format("Item   : %s\nHarga  : %s\nDibeli : %d / %d", selectedItem.name, tostring(selectedItem.price) .. " " .. selectedItem.currency, tbl25.boughtCount, tbl25.amount))
                            task.wait(0.05)
                            continue
                        end

                        tbl25.enabled = false

                        lib:MakeNotify({
                            Title = "Auto Buy Merchant",
                            Description = "Gagal beli, dihentikan.",
                            Delay = 4,
                        })

                        break
                    end

                    tbl25.task = nil
                end)
            else
                tbl25.enabled = false

                if tbl25.task then
                    task.cancel(tbl25.task)
                    tbl25.task = nil
                end

                lib:MakeNotify({
                    Title = "Auto Buy Merchant",
                    Description = string.format("Dihentikan. Terbeli: %d item", tbl25.boughtCount),
                    Delay = 3,
                })
            end
        end,
    })

    v34:AddButton({
        Title = "Buy Once (Manual)",
        Callback = function()
            if tbl25.data and tbl25.merchantData then
                if not tbl25.selectedItem then
                    lib:MakeNotify({
                        Title = "Auto Buy Merchant",
                        Description = "Pilih item dulu dari dropdown!",
                        Delay = 3,
                    })

                    return
                end

                local selectedItem = tbl25.selectedItem
                local v37 = tbl25.data:Get(selectedItem.currencyPath)
                local n = v37 or 0

                if n < selectedItem.price then
                    lib:MakeNotify({
                        Title = "Auto Buy Merchant",
                        Description = "Saldo tidak cukup!",
                        Delay = 3,
                    })

                    return
                end

                local ok, result = pcall(function()
                    return obj.RF_PurchaseMarketItem:InvokeServer(selectedItem.id)
                end)

                if ok and result then
                    tbl25.boughtCount = tbl25.boughtCount + 1
                end

                local makeNotify = lib.MakeNotify
                local tbl28 = {Title = "Auto Buy Merchant"}
                local description = ok and result and "Berhasil beli: " .. selectedItem.name or "Gagal beli item!"
                tbl28.Description = description
                tbl28.Delay = 3
                makeNotify(lib, tbl28)
                return
            end

            lib:MakeNotify({
                Title = "Auto Buy Merchant",
                Description = "Tekan Refresh dulu!",
                Delay = 3,
            })
        end,
    })

    local v37 = v22:AddSection("Buy Rod")
    local tbl28 = {selectedName = nil, selectedId = nil}
    local tbl29 = {}
    local tbl30 = {}
    local flag6 = false

    local function fn39()
        if flag6 then
            return
        end
        flag6 = true

        pcall(function()
            local fishingRods = obj2:GetFishingRods()

            for i, fishingRod in ipairs(fishingRods) do
                local price = fishingRod.Price
                local n = price or 0

                if n >= 1 and not fishingRod.LinkedGamePass then
                    local name = fishingRod.Data.Name
                    table.insert(tbl29, name)
                    tbl30[name] = {Id = fishingRod.Data.Id, Price = n}
                end
            end

            table.sort(tbl29, function(arg, arg2)
                local flag7 = tbl30[arg].Price < tbl30[arg2].Price
                return flag7
            end)
        end)

        if tbl29[1] then
            tbl28.selectedName = tbl29[1]
            local v38 = tbl30[tbl29[1]]

            if v38 then
                tbl28.selectedId = v38.Id
            end
        end
    end

    fn39()

    v37:AddDropdown({
        Title = "Select Rod",
        Options = tbl29,
        Default = nil,
        Callback = function(selectedName)
            fn39()
            tbl28.selectedName = selectedName
            local v38 = tbl30[selectedName]

            if v38 then
                tbl28.selectedId = v38.Id
            end
        end,
    })

    v37:AddButton({
        Title = "Buy Rod",
        Callback = function()
            fn39()

            pcall(function()
                if not tbl28.selectedName or not tbl28.selectedId then
                    return
                end
                local v38 = tbl30[tbl28.selectedName]
                if not v38 then
                    return
                end
                local expect = obj3:GetExpect({"Inventory", "Fishing Rods"})

                for i, v39 in ipairs(expect) do
                    if v39.Id == tbl28.selectedId then
                        return
                    end
                end

                local expect2 = obj3:GetExpect("Coins")
                local n = expect2 or 0
                if n < v38.Price then
                    return
                end
                local response, v39 = obj.RF_PurchaseFishingRod:InvokeServer(tbl28.selectedId)

                if response and v39 then
                    obj.RE_EquipItem:FireServer(v39, "Fishing Rods")
                end
            end)
        end,
    })

    local v38 = v22:AddSection("Buy Bait")
    local tbl31 = {selectedName = nil, selectedId = nil}
    local tbl32 = {}
    local tbl33 = {}
    local flag7 = false

    local function fn40()
        if flag7 then
            return
        end
        flag7 = true

        pcall(function()
            local baits = obj2:GetBaits()

            for i, bait in ipairs(baits) do
                if not bait.HiddenInShop then
                    local price = bait.Price
                    local n = price or 0

                    if n >= 1 and not bait.LinkedGamePass then
                        local name = bait.Data.Name
                        table.insert(tbl32, name)
                        tbl33[name] = {Id = bait.Data.Id, Price = n}
                    end
                end
            end

            table.sort(tbl32, function(arg, arg2)
                local flag8 = tbl33[arg].Price < tbl33[arg2].Price
                return flag8
            end)
        end)

        if tbl32[1] then
            tbl31.selectedName = tbl32[1]
            local v39 = tbl33[tbl32[1]]

            if v39 then
                tbl31.selectedId = v39.Id
            end
        end
    end

    fn40()

    v38:AddDropdown({
        Title = "Select Bait",
        Options = tbl32,
        Default = nil,
        Callback = function(selectedName)
            fn40()
            tbl31.selectedName = selectedName
            local v39 = tbl33[selectedName]

            if v39 then
                tbl31.selectedId = v39.Id
            end
        end,
    })

    v38:AddButton({
        Title = "Buy Bait",
        Callback = function()
            fn40()

            pcall(function()
                if not tbl31.selectedName or not tbl31.selectedId then
                    return
                end
                local v39 = tbl33[tbl31.selectedName]
                if not v39 then
                    return
                end
                local expect = obj3:GetExpect({"Inventory", "Baits"})

                for i, v40 in ipairs(expect) do
                    if v40.Id == tbl31.selectedId then
                        return
                    end
                end

                local expect2 = obj3:GetExpect("Coins")
                local n = expect2 or 0
                if n < v39.Price then
                    return
                end
                local response, v40 = obj.RF_PurchaseBait:InvokeServer(tbl31.selectedId)

                if response and v40 then
                    obj.RE_EquipBait:FireServer(tbl31.selectedId)
                end
            end)
        end,
    })
end

local v4 = v3:AddTab({Name = "Automation", Icon = "next"})
local tbl3

do
    local CollectionService = game:GetService("CollectionService")
    local v5 = v4:AddSection("Complete Fish Index [BETA]", false)

    local tbl4 = {
        enabled = false,
        thread = nil,
        statusParagraph = nil,
        excludedTiers = {},
    }

    local tbl5 = {
        ["Ancient Jungle"] = {
            pos = Vector3.new(1467.427, 7.574, -327.697),
            look = Vector3.new(1610.471, 7.574, -282.549),
        },
        ["Ancient Ruin"] = {
            pos = Vector3.new(6045.402, -588.601, 4608.938),
            look = Vector3.new(6059.215, -588.601, 4758.3),
        },
        ["Coral Reefs"] = {
            pos = Vector3.new(-2921.858, 3.25, 2083.297),
            look = Vector3.new(-3068.679, 3.25, 2052.582),
        },
        ["Crater Island"] = {
            pos = Vector3.new(1074.376, 4.027, 5098.477),
            look = Vector3.new(928.264, 4.027, 5064.545),
        },
        ["Esoteric Depths"] = {
            pos = Vector3.new(3206.972, -1302.855, 1417.3),
            look = Vector3.new(3274.385, -1302.855, 1551.298),
        },
        ["Fisherman Island"] = {
            pos = Vector3.new(-61.728, 3.532, 2770.768),
            look = Vector3.new(-211.452, 3.532, 2761.671),
        },
        Kohana = {
            pos = Vector3.new(-655.469, 17.245, 501.038),
            look = Vector3.new(-511.246, 17.245, 542.266),
        },
        ["Kohana Lab"] = {
            pos = Vector3.new(-201.608, 63.556, 475.351),
            look = Vector3.new(-206.758, 63.556, 483.923),
        },
        ["Kohana Volcano"] = {
            pos = Vector3.new(-552.305, 20.729, 183.195),
            look = Vector3.new(-604.901, 20.729, 42.719),
        },
        ["Lost Isle"] = {
            pos = Vector3.new(-3685.375, 5.426, -1066.627),
            look = Vector3.new(-3638.585, 5.426, -1209.143),
        },
        ["Sisyphus Statue"] = {
            pos = Vector3.new(-3656.654, -134.358, -963.251),
            look = Vector3.new(-3802.689, -134.358, -928.99),
        },
        ["Sacred Temple"] = {
            pos = Vector3.new(1453.839, -22.125, -621.652),
            look = Vector3.new(1480.257, -22.125, -473.996),
        },
        ["Treasure Room"] = {
            pos = Vector3.new(-3597.324, -275.674, -1641.224),
            look = Vector3.new(-3722.606, -275.674, -1558.736),
        },
        ["Tropical Grove"] = {
            pos = Vector3.new(-2140.796, 53.487, 3622.714),
            look = Vector3.new(-2216.205, 53.487, 3752.381),
        },
        ["Underground Cellar"] = {
            pos = Vector3.new(2161.391, -91.198, -729.227),
            look = Vector3.new(2022.332, -91.198, -672.99),
        },
        ["Pirate Cove"] = {
            pos = Vector3.new(3406.972, 4.193, 3497.086),
            look = Vector3.new(3512.487, 4.193, 3390.472),
        },
        ["Leviathan's Den"] = {
            pos = Vector3.new(3472.983, -287.843, 3471.071),
            look = Vector3.new(3530.812, -287.843, 3609.456),
        },
        ["Pirate Treasure Room"] = {
            pos = Vector3.new(3349.351, -297.941, 3086.003),
            look = Vector3.new(3247.83, -297.941, 2975.578),
        },
        ["Crystal Depths"] = {
            pos = Vector3.new(5729.334, -904.818, 15408.078),
            look = Vector3.new(5691.893, -904.818, 15262.826),
        },
        ["Volcanic Cavern"] = {
            pos = Vector3.new(1145.14, 74.942, -10234.558),
            look = Vector3.new(1277.255, 74.942, -10163.525),
        },
        ["Lava Basin"] = {
            pos = Vector3.new(894.223, 89.033, -10195.547),
            look = Vector3.new(1032.501, 89.033, -10137.418),
        },
        ["Weather Machine"] = {
            pos = Vector3.new(-1528.407, 2.875, 1915.324),
            look = Vector3.new(-1513.045, 2.875, 2064.535),
        },
        ["Underwater City"] = {
            pos = Vector3.new(-3140.833, -643.477, -10415.806),
            look = Vector3.new(-2990.863, -643.477, -10418.791),
        },
        ["Planetary Observatory"] = {
            pos = Vector3.new(440.902, 9.178, 2148.801),
            look = Vector3.new(436.536, 9.178, 2157.798),
        },
        Sewers = {
            pos = Vector3.new(-1448.109, -1041.589, -10447.079),
            look = Vector3.new(-1598.04, -1041.589, -10442.528),
        },
        ["Stingray Shores"] = {
            pos = Vector3.new(-2131.052, 16.685, -848.953),
            look = Vector3.new(-2129.987, 16.685, -858.896),
        },
        ["Classic Island"] = {
            pos = Vector3.new(1442.234, 58.001, 2877.836),
            look = Vector3.new(1407.905, -34.288, 2764.68),
        },
        ["Classic Cave"] = {
            pos = Vector3.new(1503.046, -1132, 2869.713),
            look = Vector3.new(1602.93, -1132, 2874.513),
        },
        ["Iron Cave"] = {
            pos = Vector3.new(1469.62, -1109, 2576.64),
            look = Vector3.new(1483.381, -1109, 2477.591),
        },
        ["Classic School"] = {
            pos = Vector3.new(1374.785, 54, 2730.551),
            look = Vector3.new(1374.494, 54, 2630.552),
        },
        Aquarium = {
            pos = Vector3.new(-3039.558, -624.243, -10573.49),
            look = Vector3.new(-3036.04, -624.243, -10582.851),
        },
        ["Copper Canyon"] = {
            pos = Vector3.new(-4145.043, 7.947, 617.358),
            look = Vector3.new(-4154.176, 7.947, 613.285),
        },
        ["Copper Canyon Mines"] = {
            pos = Vector3.new(-4079.106, -547.174, 548.035),
            look = Vector3.new(-4069.595, -547.174, 551.125),
        },
        Ocean = {
            pos = Vector3.new(-1528.407, 2.875, 1915.324),
            look = Vector3.new(-1513.045, 2.875, 2064.535),
        },
        ["Gloomcap Grotto"] = {
            pos = Vector3.new(5940.166, -850.189, 12468.711),
            look = Vector3.new(5932.439, -850.189, 12475.059),
        },
        ["Lucky Abyss"] = {
            pos = Vector3.new(-9132.198, -269.54, 813.391),
            look = Vector3.new(-9126.932, -269.54, 804.89),
        },
        ["Lucky Volcano"] = {
            pos = Vector3.new(-8569.072, -69.104, -424.655),
            look = Vector3.new(-8560.575, -69.104, -429.927),
        },
        ["Mariana Trench"] = {
            pos = Vector3.new(-9255.898, -255.588, -1.051),
            look = Vector3.new(-9261.076, -255.588, -9.606),
        },
        ["Mutation Vents"] = {
            pos = Vector3.new(-9112.335, -91.77, -1639.629),
            look = Vector3.new(-9116.346, -91.77, -1648.789),
        },
        ["Rushing Current"] = {
            pos = Vector3.new(-9687.612, -74.279, -1779.643),
            look = Vector3.new(-9685.838, -74.279, -1789.484),
        },
        ["Shiny Abyss"] = {
            pos = Vector3.new(-9729.081, -269.54, 810.506),
            look = Vector3.new(-9725.213, -269.54, 819.728),
        },
        ["Silent Reach"] = {
            pos = Vector3.new(-10021.376, -72.101, 178.305),
            look = Vector3.new(-10017.688, -72.101, 169.009),
        },
        ["Starfall Gardens"] = {
            pos = Vector3.new(-22266.74, -252.372, -7991.041),
            look = Vector3.new(-22267.477, -252.372, -7981.068),
        },
        ["The Celestarium"] = {
            pos = Vector3.new(-28372.205, -161.001, -8254.719),
            look = Vector3.new(-28373.098, -161.001, -8244.759),
        },
        ["Titan Pressure"] = {
            pos = Vector3.new(-9867.534, -84.105, -1188.156),
            look = Vector3.new(-9871.007, -84.105, -1197.534),
        },
        ["Elemental Island"] = {
            pos = Vector3.new(-859.987, 56.557, 5311.898),
            look = Vector3.new(-868.137, 56.557, 5317.693),
        },
    }

    local tbl6 = {
        Ocean = {
            "Ghost Worm Fish",
            "Megalodon",
            "Thunderzilla",
            "Bloodmoon Whale",
            "1x1x1x1 Comet Shark",
        },
        ["Ancient Jungle"] = {
            "Crescent Artifact",
            "Arrow Artifact",
            "Hourglass Diamond Artifact",
            "Diamond Artifact",
        },
        ["Ancient Ruin"] = {"Ancient Lochness Monster"},
        ["Sisyphus Statue"] = {"Depthseeker Ray"},
        ["Copper Canyon Mines"] = {"Cerulean Dragon"},
        ["Pirate Treasure Room"] = {"Pirate Starfish", "Stormy Dumbo"},
        ["Pirate Cove"] = {"Rainy Dumbo"},
        ["Crystal Depths"] = {"Cute Dumbo", "Hank's Diary"},
        ["Underwater City"] = {"Mutant Runic Koi"},
    }

    local function fn6(arg, arg2)
        pcall(function()
            tbl4.statusParagraph:SetTitle(arg)
            tbl4.statusParagraph:SetContent(arg2)
        end)
    end

    local function fn7(arg)
        local n, Replion, Areas, ItemUtility, TierUtility, replion, CaughtFishMastery, tbl7, tbl8, v6, v7, v8, v9, v10, v11, tbl9, n2, tbl10, n3, v12
        local v13, v14, v15, v16, v17, v18, v19, tbl11, tbl12, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30
        local v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, itemData, data, name, probability
        local forcedProbability, v47, data2, tier, v48, insert, tbl13, order, order2, n4
        n4 = 1

        while true do
            if n4 == 1 then
                n = 613992213
                Replion = require(ReplicatedStorage.Packages.Replion)
                Areas = require(ReplicatedStorage.Areas)
                ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
                TierUtility = require(ReplicatedStorage.Shared.TierUtility)
                replion = Replion.Client:GetReplion("Data")

                if replion then
                    n4 = 2
                else
                    n4 = 42
                end
            elseif n4 == 2 then
                CaughtFishMastery = replion:Get("CaughtFishMastery")
                tbl7 = CaughtFishMastery

                if CaughtFishMastery then
                    n4 = 4
                else
                    n4 = 3
                end
            elseif n4 == 3 then
                tbl7 = {}
                n4 = 4
            elseif n4 == 4 then
                tbl8 = {}

                if arg then
                    n4 = 5
                else
                    n4 = 8
                end
            elseif n4 == 5 then
                v6, v7, v8 = ipairs(arg)
                v9 = v8
                n4 = 6
            elseif n4 == 6 then
                v10, v11 = v6(v7, v9)

                if v10 == nil then
                    n4 = 8
                else
                    n4 = 7
                end
            elseif n4 == 7 then
                v9 = v10
                tbl8[v11] = true
                n4 = 6
            elseif n4 == 8 then
                tbl9 = {
                    ["Starfall Gardens"] = true,
                    ["The Celestarium"] = true,
                    ["Mariana Trench"] = true,
                    Arcadia = true,
                    ["Throne Room"] = true,
                }

                n2 = 656237737
                tbl10 = {}
                n3 = 215656379
                v12, v13, v14 = pairs(Areas)
                v15 = v14
                v16 = v12
                v17 = v13
                n4 = 9
            elseif n4 == 9 then
                v18, v19 = v16(v17, v15)

                if v18 == nil then
                    n4 = 41
                else
                    n4 = 10
                end
            elseif n4 == 10 then
                v15 = v18

                if not tbl9[v18] and not v19.NoDisplay and not v19.Hidden and not v19.ComingSoon and tbl5[v18] then
                    n4 = 11
                else
                    n4 = 9
                end
            elseif n4 == 11 then
                tbl11 = {}
                tbl12 = {}

                if v19.Items then
                    n4 = 12
                else
                    n4 = 16
                end
            elseif n4 == 12 then
                v20, v21, v22 = ipairs(v19.Items)
                v23 = v16
                v24 = v17
                v25 = v22
                n4 = 13
            elseif n4 == 13 then
                v26, v27 = v20(v21, v25)

                if v26 == nil then
                    n4 = 15
                else
                    n4 = 14
                end
            elseif n4 == 14 then
                v25 = v26
                table.insert(tbl12, v27)
                n4 = 13
            elseif n4 == 15 then
                v15 = v18
                v16 = v23
                v17 = v24
                n4 = 16
            elseif n4 == 16 then
                v28 = tbl6[v18]

                if v28 then
                    n4 = 17
                else
                    n4 = 21
                end
            elseif n4 == 17 then
                v29, v30, v31 = ipairs(v28)
                v32 = v15
                v33 = v16
                v34 = v17
                v35 = v31
                n4 = 18
            elseif n4 == 18 then
                v36, v37 = v29(v30, v35)

                if v36 == nil then
                    n4 = 20
                else
                    n4 = 19
                end
            elseif n4 == 19 then
                v35 = v36
                table.insert(tbl12, v37)
                n4 = 18
            elseif n4 == 20 then
                v15 = v32
                v16 = v33
                v17 = v34
                n4 = 21
            elseif n4 == 21 then
                v38, v39, v40 = ipairs(tbl12)
                v41 = v15
                v42 = v16
                v43 = v17
                v44 = v40
                n4 = 22
            elseif n4 == 22 then
                v45, v46 = v38(v39, v44)

                if v45 == nil then
                    n4 = 37
                else
                    n4 = 23
                end
            elseif n4 == 23 then
                v44 = v45
                itemData = ItemUtility:GetItemData(v46)

                if itemData then
                    n4 = 24
                else
                    n4 = 22
                end
            elseif n4 == 24 then
                data = itemData.Data
                name = data

                if data then
                    n4 = 25
                else
                    n4 = 26
                end
            elseif n4 == 25 then
                name = itemData.Data.Name
                n4 = 26
            elseif n4 == 26 then
                if name and itemData.Events == nil then
                    n4 = 27
                else
                    n4 = 22
                end
            elseif n4 == 27 then
                probability = itemData.Probability
                forcedProbability = probability

                if probability then
                    n4 = 29
                else
                    n4 = 28
                end
            elseif n4 == 28 then
                forcedProbability = itemData.ForcedProbability
                n4 = 29
            elseif n4 == 29 then
                if forcedProbability then
                    n4 = 30
                else
                    n4 = 31
                end
            elseif n4 == 30 then
                v47 = TierUtility.GetTierFromRarity(nil, forcedProbability.Chance)

                if v47 and tbl8[v47.Name] then
                    n4 = 22
                else
                    n4 = 35
                end
            elseif n4 == 31 then
                data2 = itemData.Data
                tier = data2

                if data2 then
                    n4 = 32
                else
                    n4 = 33
                end
            elseif n4 == 32 then
                tier = itemData.Data.Tier
                n4 = 33
            elseif n4 == 33 then
                if tier then
                    n4 = 34
                else
                    n4 = 35
                end
            elseif n4 == 34 then
                v48 = TierUtility.GetTier(nil, tier)

                if v48 and tbl8[v48.Name] then
                    n4 = 22
                else
                    n4 = 35
                end
            elseif n4 == 35 then
                if tbl7[name] then
                    n4 = 22
                else
                    n4 = 36
                end
            elseif n4 == 36 then
                table.insert(tbl11, name)
                n4 = 22
            elseif n4 == 37 then
                v15 = v41
                v16 = v42
                v17 = v43

                if #tbl11 > 0 then
                    n4 = 38
                else
                    n4 = 9
                end
            elseif n4 == 38 then
                insert = table.insert
                tbl13 = {areaName = v18, missing = tbl11, coords = tbl5[v18]}
                order = v19.Order
                order2 = order

                if order then
                    n4 = 40
                else
                    n4 = 39
                end
            elseif n4 == 39 then
                order2 = 9999
                n4 = 40
            elseif n4 == 40 then
                tbl13.order = order2
                insert(tbl10, tbl13)
                n4 = 9
            elseif n4 == 41 then
                table.sort(tbl10, function(arg2, arg3)
                    local flag4 = arg2.order < arg3.order
                    return flag4
                end)

                return tbl10
            elseif n4 == 42 then
                return {}
            end
        end
    end

    local function fn8(arg, area)
        local cframe = CFrame.lookAt(arg.pos, arg.look)
        local flag4 = false
        if not tbl4.enabled then
            return false
        end
        fn6("Teleporting... (attempt 1/5)", "Area: " .. area)
        local flag5 = true
        local character = localPlayer.Character
        local result = character or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart = result and result:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            humanoidRootPart.CFrame = cframe
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        else
            flag5 = false
        end

        task.wait(0.5)

        if flag5 then
            local character2 = localPlayer.Character
            local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
            local magnitude = humanoidRootPart2 and (humanoidRootPart2.Position - arg.pos).Magnitude or math.huge

            if magnitude <= 700 then
                flag4 = true
            else
                lib:MakeNotify({
                    Title = "Auto Index",
                    Description = "Karakter masih jauh dari " .. area .. ", retry...",
                    Delay = 3,
                })
            end
        else
            lib:MakeNotify({
                Title = "Auto Index",
                Description = "Boat flow gagal ke " .. area .. ", retry...",
                Delay = 3,
            })
        end

        if flag4 or not tbl4.enabled then
            return flag4
        end
        fn6("Teleporting... (attempt 2/5)", "Area: " .. area)
        local flag6 = true
        local character2 = localPlayer.Character
        local result2 = character2 or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart2 = result2 and result2:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart2 then
            humanoidRootPart2.CFrame = cframe
            humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
        else
            flag6 = false
        end

        task.wait(0.5)

        if flag6 then
            local character3 = localPlayer.Character
            local humanoidRootPart3 = character3 and character3:FindFirstChild("HumanoidRootPart")
            local magnitude = humanoidRootPart3 and (humanoidRootPart3.Position - arg.pos).Magnitude or math.huge

            if magnitude <= 700 then
                flag4 = true
            else
                lib:MakeNotify({
                    Title = "Auto Index",
                    Description = "Karakter masih jauh dari " .. area .. ", retry...",
                    Delay = 3,
                })
            end
        else
            lib:MakeNotify({
                Title = "Auto Index",
                Description = "Boat flow gagal ke " .. area .. ", retry...",
                Delay = 3,
            })
        end

        if flag4 or not tbl4.enabled then
            return flag4
        end
        fn6("Teleporting... (attempt 3/5)", "Area: " .. area)
        local flag7 = true
        local character3 = localPlayer.Character
        local result3 = character3 or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart3 = result3 and result3:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart3 then
            humanoidRootPart3.CFrame = cframe
            humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
        else
            flag7 = false
        end

        task.wait(0.5)

        if flag7 then
            local character4 = localPlayer.Character
            local humanoidRootPart4 = character4 and character4:FindFirstChild("HumanoidRootPart")
            local magnitude = humanoidRootPart4 and (humanoidRootPart4.Position - arg.pos).Magnitude or math.huge

            if magnitude <= 700 then
                flag4 = true
            else
                lib:MakeNotify({
                    Title = "Auto Index",
                    Description = "Karakter masih jauh dari " .. area .. ", retry...",
                    Delay = 3,
                })
            end
        else
            lib:MakeNotify({
                Title = "Auto Index",
                Description = "Boat flow gagal ke " .. area .. ", retry...",
                Delay = 3,
            })
        end

        if flag4 or not tbl4.enabled then
            return flag4
        end
        fn6("Teleporting... (attempt 4/5)", "Area: " .. area)
        local flag8 = true
        local character4 = localPlayer.Character
        local result4 = character4 or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart4 = result4 and result4:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart4 then
            humanoidRootPart4.CFrame = cframe
            humanoidRootPart4.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart4.AssemblyAngularVelocity = Vector3.zero
        else
            flag8 = false
        end

        task.wait(0.5)

        if flag8 then
            local character5 = localPlayer.Character
            local humanoidRootPart5 = character5 and character5:FindFirstChild("HumanoidRootPart")
            local magnitude = humanoidRootPart5 and (humanoidRootPart5.Position - arg.pos).Magnitude or math.huge

            if magnitude <= 700 then
                flag4 = true
            else
                lib:MakeNotify({
                    Title = "Auto Index",
                    Description = "Karakter masih jauh dari " .. area .. ", retry...",
                    Delay = 3,
                })
            end
        else
            lib:MakeNotify({
                Title = "Auto Index",
                Description = "Boat flow gagal ke " .. area .. ", retry...",
                Delay = 3,
            })
        end

        if flag4 or not tbl4.enabled then
            return flag4
        end
        fn6("Teleporting... (attempt 5/5)", "Area: " .. area)
        local flag9 = true
        local character5 = localPlayer.Character
        local result5 = character5 or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart5 = result5 and result5:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart5 then
            humanoidRootPart5.CFrame = cframe
            humanoidRootPart5.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart5.AssemblyAngularVelocity = Vector3.zero
        else
            flag9 = false
        end

        task.wait(0.5)

        if flag9 then
            local character6 = localPlayer.Character
            local humanoidRootPart6 = character6 and character6:FindFirstChild("HumanoidRootPart")
            local magnitude = humanoidRootPart6 and (humanoidRootPart6.Position - arg.pos).Magnitude or math.huge

            if magnitude <= 700 then
                flag4 = true
            else
                lib:MakeNotify({
                    Title = "Auto Index",
                    Description = "Karakter masih jauh dari " .. area .. ", retry...",
                    Delay = 3,
                })
            end
        else
            lib:MakeNotify({
                Title = "Auto Index",
                Description = "Boat flow gagal ke " .. area .. ", retry...",
                Delay = 3,
            })
        end

        return flag4
    end

    tbl4.statusParagraph = v5:AddParagraph({Title = "Status", Content = "Idle"})

    v5:AddParagraph({
        Title = "Info",
        Content = "Otomatis teleport ke setiap area yang masih ada ikan belum di-index.\nTunggu di area sampai semua ikan tertangkap, lalu pindah ke area berikutnya.\nEvent fish dan special/limited fish dilewati.",
    })

    v5:AddDropdown({
        Title = "Exclude/kecualikan Rarity",
        Multi = true,
        Default = {},
        Options = {
            "Common",
            "Uncommon",
            "Rare",
            "Epic",
            "Legendary",
            "Mythic",
            "SECRET",
            "FORGOTTEN",
            "Trophy",
            "Collectible",
            "Exclusive",
        },
        Callback = function(excludedTiers)
            tbl4.excludedTiers = excludedTiers
        end,
    })

    v5:AddToggle({
        Title = "Enable Auto Complete Fish Index",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl4.enabled = enabled

            if tbl4.thread then
                pcall(task.cancel, tbl4.thread)
                tbl4.thread = nil
            end

            if not enabled then
                fn6("Status", "Idle")
                return
            end

            tbl4.thread = task.spawn(function()
                fn6("Scanning...", "Mengecek index yang belum lengkap...")
                local v6 = fn7(tbl4.excludedTiers)

                if #v6 == 0 then
                    fn6("Complete!", "Semua fish index sudah lengkap!")

                    lib:MakeNotify({
                        Title = "Auto Index",
                        Description = "Semua fish index sudah lengkap!",
                        Delay = 4,
                    })

                    tbl4.enabled = false
                    return
                end

                local n = #v6
                local n2 = 0
                local v7, v8, v9 = ipairs(v6)
                local v10 = v9
                local v11 = v7
                local v12 = v8

                while true do
                    local v13, v14 = v11(v12, v10)
                    if v13 == nil then
                        break
                    end
                    v10 = v13
                    if not tbl4.enabled then
                        break
                    end
                    local n3 = n2 + 1
                    n2 = n3
                    local areaName = v14.areaName
                    local missing = v14.missing
                    local coords = v14.coords

                    lib:MakeNotify({
                        Title = "Auto Index",
                        Description = "Menuju: " .. areaName .. " (" .. #missing .. " ikan)",
                        Delay = 3,
                    })

                    local v15 = fn8(coords, areaName)
                    if not tbl4.enabled then
                        break
                    end

                    if not v15 then
                        lib:MakeNotify({
                            Title = "Auto Index",
                            Description = "Gagal sampai ke " .. areaName .. ", skip area ini.",
                            Delay = 4,
                        })

                        continue
                    end

                    task.wait(2)
                    if not tbl4.enabled then
                        break
                    end
                    local tbl7 = {}
                    local v16 = tbl7

                    for i, v17 in ipairs(missing) do
                        table.insert(tbl7, v17)
                    end

                    v10 = v13

                    while #v16 > 0 and tbl4.enabled do
                        local replion = require(ReplicatedStorage.Packages.Replion).Client:GetReplion("Data")

                        if replion then
                            local CaughtFishMastery = replion:Get("CaughtFishMastery")
                            local tbl8 = CaughtFishMastery or {}
                            local tbl9 = {}

                            for i, v17 in ipairs(v16) do
                                if not tbl8[v17] then
                                    table.insert(tbl9, v17)
                                end
                            end

                            v16 = tbl9
                        end

                        if #v16 > 0 then
                            fn6("Fishing at " .. areaName .. " (" .. n3 .. "/" .. n .. ")", "Sisa: " .. table.concat(v16, ", "))
                            task.wait(3)
                        end
                    end

                    if #v16 == 0 then
                        lib:MakeNotify({
                            Title = "Auto Index",
                            Description = "Area " .. areaName .. " complete!",
                            Delay = 3,
                        })
                    end

                    task.wait(1)
                end

                if tbl4.enabled then
                    fn6("Done!", "Semua area sudah dikunjungi.")

                    lib:MakeNotify({
                        Title = "Auto Index",
                        Description = "Auto Complete Fish Index selesai!",
                        Delay = 4,
                    })

                    tbl4.enabled = false
                else
                    fn6("Status", "Idle")
                end
            end)
        end,
    })

    v5:AddButton({
        Title = "Scan Missing Now",
        Callback = function()
            task.spawn(function()
                fn6("Scanning...", "Mengecek index...")
                local v6 = fn7(tbl4.excludedTiers)

                if #v6 == 0 then
                    fn6("Complete!", "Semua fish index sudah lengkap!")

                    lib:MakeNotify({
                        Title = "Auto Index",
                        Description = "Semua index sudah lengkap!",
                        Delay = 3,
                    })
                else
                    local n = 0
                    local tbl7 = {}

                    for i, v7 in ipairs(v6) do
                        n = n + #v7.missing
                        table.insert(tbl7, v7.areaName .. " (" .. #v7.missing .. ")")
                    end

                    fn6("Missing: " .. n .. " ikan", table.concat(tbl7, "\n"))

                    lib:MakeNotify({
                        Title = "Auto Index",
                        Description = n .. " ikan belum di-index di " .. #v6 .. " area.",
                        Delay = 4,
                    })
                end
            end)
        end,
    })

    local v6 = v4:AddSection("Join Treasure Hunt Server", false)

    local tbl7 = {
        enabled = false,
        thread = nil,
        lastJobId = nil,
        scanning = false,
        triedJobs = {},
        cooldowns = {},
    }

    local v7 = v6:AddParagraph({Title = "Status", Content = "Idle"})

    local function fn9(arg, arg2)
        pcall(function()
            v7:SetTitle(arg)
            v7:SetContent(arg2)
        end)
    end

    local function fn10()
        local ok, result = pcall(function()
            return require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("ServerBrowser")
        end)

        if ok and result then
            return result
        end
        return nil
    end

    local function fn11(arg, arg2)
        tbl7.cooldowns[arg] = tick() + arg2
    end

    local function fn12(arg)
        local v8 = tbl7.cooldowns[arg]
        if not v8 then
            return false
        end

        if v8 > tick() then
            return true
        end
        tbl7.cooldowns[arg] = nil
        return false
    end

    local function fn13(arg)
        if arg.Players and type(arg.Players) == "table" then
            return #arg.Players
        end
        return 0
    end

    local function fn14()
        local v8 = fn10()
        if not v8 then
            return {}
        end
        local data = v8.Data
        local servers = data and v8.Data.Servers
        if not servers then
            return {}
        end
        local maxPlayers = Players.MaxPlayers
        local tbl8 = {}
        local n = 0
        local n2 = 0
        local v9, v10, v11 = pairs(servers)
        local v12 = v11
        local v13 = v9
        local v14 = v10

        while true do
            local v15, v16 = v13(v14, v12)
            if v15 == nil then
                break
            end
            v12 = v15

            if v15 ~= game.JobId and v16.Events then
                local v17 = fn13(v16)

                if maxPlayers <= v17 then
                    n2 = n2 + 1

                    if not fn12(v15) then
                        fn11(v15, 60)
                    end
                elseif fn12(v15) then
                    n = n + 1
                else
                    local flag4 = false

                    for i, event in ipairs(v16.Events) do
                        if event == "Treasure Hunt" then
                            flag4 = true
                            break
                        end
                    end

                    v12 = v15

                    if flag4 then
                        local insert = table.insert
                        local tbl9 = {jobId = v15}
                        local ping = v16.Ping
                        local ping2 = ping or 9999
                        tbl9.ping = ping2
                        tbl9.players = v17
                        tbl9.max = maxPlayers
                        insert(tbl8, tbl9)
                    end
                end
            end
        end

        table.sort(tbl8, function(arg, arg2)
            if arg.players == arg2.players then
                local flag4 = arg.ping < arg2.ping
                return flag4
            end
            local flag4 = arg.players < arg2.players
            return flag4
        end)

        return tbl8, n, n2
    end

    local function fn15(arg)
        local ok = pcall(function()
            local TeleportService = game:GetService("TeleportService")
            sharedQueueAutoExecute(true)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, arg, localPlayer)
        end)

        if not ok then
            flag = false
        end

        return ok
    end

    local function fn16()
        local ok, result = pcall(function()
            local v8 = fn10()
            if not v8 then
                return false
            end
            local data = v8.Data
            local servers = data and v8.Data.Servers
            if not servers then
                return false
            end
            local v9 = servers[game.JobId]
            if not v9 or not v9.Events then
                return false
            end

            for i, event in ipairs(v9.Events) do
                if event == "Treasure Hunt" then
                    return true
                end
            end

            return false
        end)

        local v8 = ok and result
        return v8
    end

    local function fn17(arg)
        if #arg == 0 then
            return false
        end
        local flag4 = false
        local n = 0
        local n2 = #arg

        for i, v8 in ipairs(arg) do
            if tbl7.enabled then
                if fn12(v8.jobId) then
                    n = n + 1
                else
                    task.spawn(function()
                        if not flag4 and tbl7.enabled then
                            local str2 = v8.jobId:sub(1, 8) .. "..."
                            local str3 = v8.players .. "/" .. v8.max .. " | ping " .. v8.ping .. "ms"
                            local v9 = fn15(v8.jobId)

                            if v9 and not flag4 then
                                flag4 = true
                                tbl7.lastJobId = v8.jobId
                                fn9("Teleporting", "Joining " .. str2 .. "...\n" .. str3)

                                lib:MakeNotify({
                                    Title = "Treasure Hunt",
                                    Description = "Joining → " .. str2 .. " | " .. str3,
                                    Delay = 3,
                                })
                            else
                                local jobId = v8.jobId
                                local n3 = v9 and 30 or 120
                                fn11(jobId, n3)

                                if not flag4 then
                                    lib:MakeNotify({
                                        Title = "Treasure Hunt",
                                        Description = "Failed → " .. str2,
                                        Delay = 2,
                                    })
                                end
                            end

                            n = n + 1
                            return
                        end

                        n = n + 1
                    end)

                    task.wait(0.1)
                end
            else
                n = n + 1
            end
        end

        local now = tick()

        while n < n2 and tick() - now < 10 do
            task.wait(0.2)
        end

        return flag4
    end

    local function fn18()
        if tbl7.thread then
            pcall(task.cancel, tbl7.thread)
            tbl7.thread = nil
        end

        tbl7.thread = task.spawn(function()
            local n, n2, n3, tbl8, n4, n5, v8, fn19, flag4, huge, v9, v10, v11, v12, v13, v14, n6, min, ceil, flag5
            local v15, n7, enabled, v16, huge2, v17, v18, v19, v20, v21, v22, n8, flag6, n9, n10
            n10 = 1

            while true do
                if n10 == 1 then
                    n = 954085614
                    n2 = 905104299
                    n3 = 82151365
                    n10 = 2
                elseif n10 == 2 then
                    if tbl7.enabled then
                        n10 = 3
                    else
                        n10 = 101
                    end
                elseif n10 == 3 then
                    if fn16() then
                        n10 = 4
                    else
                        n10 = 8
                    end
                elseif n10 == 4 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 5
                elseif n10 == 5 then
                    if tbl7.enabled then
                        n10 = 6
                    else
                        n10 = 7
                    end
                elseif n10 == 6 then
                    task.wait(5)

                    if fn16() then
                        n10 = 5
                    else
                        n10 = 7
                    end
                elseif n10 == 7 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 2
                elseif n10 == 8 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 9 then
                    v8(fn19)
                    tbl7.scanning = false

                    if #tbl8 > 0 then
                        n10 = 86
                    else
                        n10 = 10
                    end
                elseif n10 == 10 then
                    if n4 > 0 then
                        n10 = 12
                    else
                        n10 = 11
                    end
                elseif n10 == 11 then
                    flag4 = false
                    n10 = 13
                elseif n10 == 12 then
                    flag4 = true
                    n10 = 13
                elseif n10 == 13 then
                    if flag4 then
                        n10 = 14
                    else
                        n10 = 17
                    end
                elseif n10 == 14 then
                    if #tbl8 == 0 then
                        n10 = 16
                    else
                        n10 = 15
                    end
                elseif n10 == 15 then
                    flag4 = false
                    n10 = 17
                elseif n10 == 16 then
                    flag4 = true
                    n10 = 17
                elseif n10 == 17 then
                    if flag4 then
                        n10 = 18
                    else
                        n10 = 32
                    end
                elseif n10 == 18 then
                    huge = math.huge
                    v9, v10, v11 = pairs(tbl7.cooldowns)
                    v12 = v11
                    n10 = 19
                elseif n10 == 19 then
                    v13, v14 = v9(v10, v12)

                    if v13 == nil then
                        n10 = 22
                    else
                        n10 = 20
                    end
                elseif n10 == 20 then
                    v12 = v13
                    n6 = v14 - tick()

                    if n6 > 0 and n6 < huge then
                        n10 = 21
                    else
                        n10 = 19
                    end
                elseif n10 == 21 then
                    huge = n6
                    n10 = 19
                elseif n10 == 22 then
                    min = math.min
                    ceil = math.ceil

                    if huge == math.huge then
                        n10 = 24
                    else
                        n10 = 23
                    end
                elseif n10 == 23 then
                    flag5 = true
                    n10 = 25
                elseif n10 == 24 then
                    flag5 = false
                    n10 = 25
                elseif n10 == 25 then
                    if flag5 then
                        n10 = 26
                    else
                        n10 = 27
                    end
                elseif n10 == 26 then
                    flag5 = huge
                    n10 = 27
                elseif n10 == 27 then
                    if flag5 then
                        n10 = 29
                    else
                        n10 = 28
                    end
                elseif n10 == 28 then
                    flag5 = 10
                    n10 = 29
                elseif n10 == 29 then
                    v15 = min(ceil(flag5), 10)
                    fn9("Cooldown (" .. v15 .. "s)", "Semua server Treasure Hunt sedang cooldown.\n" .. n4 .. " server dalam cooldown.\nMenunggu " .. v15 .. " detik...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "All servers on cooldown. Waiting " .. v15 .. "s...",
                        Delay = 3,
                    })

                    n7 = 0
                    n10 = 30
                elseif n10 == 30 then
                    if tbl7.enabled and n7 < v15 then
                        n10 = 31
                    else
                        n10 = 2
                    end
                elseif n10 == 31 then
                    task.wait(1)
                    n7 = n7 + 1
                    n10 = 30
                elseif n10 == 32 then
                    fn9("Not Found", "Tidak ada server Treasure Hunt aktif.\nRescan dalam 5 detik...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "No Treasure Hunt server found. Rescanning in 5s...",
                        Delay = 3,
                    })

                    if tbl7.enabled then
                        n10 = 33
                    else
                        n10 = 78
                    end
                elseif n10 == 33 then
                    task.wait(1)

                    if tbl7.enabled then
                        n10 = 34
                    else
                        n10 = 70
                    end
                elseif n10 == 34 then
                    task.wait(1)

                    if tbl7.enabled then
                        n10 = 35
                    else
                        n10 = 62
                    end
                elseif n10 == 35 then
                    task.wait(1)

                    if tbl7.enabled then
                        n10 = 36
                    else
                        n10 = 54
                    end
                elseif n10 == 36 then
                    task.wait(1)

                    if tbl7.enabled then
                        n10 = 37
                    else
                        n10 = 46
                    end
                elseif n10 == 37 then
                    task.wait(1)
                    enabled = tbl7.enabled
                    n10 = 38
                elseif n10 == 38 then
                    if tbl7.enabled then
                        n10 = 39
                    else
                        n10 = 45
                    end
                elseif n10 == 39 then
                    if fn16() then
                        n10 = 40
                    else
                        n10 = 44
                    end
                elseif n10 == 40 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 41
                elseif n10 == 41 then
                    if tbl7.enabled then
                        n10 = 42
                    else
                        n10 = 43
                    end
                elseif n10 == 42 then
                    task.wait(5)

                    if fn16() then
                        n10 = 41
                    else
                        n10 = 43
                    end
                elseif n10 == 43 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 38
                elseif n10 == 44 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 45 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 46 then
                    if tbl7.enabled then
                        n10 = 47
                    else
                        n10 = 53
                    end
                elseif n10 == 47 then
                    if fn16() then
                        n10 = 48
                    else
                        n10 = 52
                    end
                elseif n10 == 48 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 49
                elseif n10 == 49 then
                    if tbl7.enabled then
                        n10 = 50
                    else
                        n10 = 51
                    end
                elseif n10 == 50 then
                    task.wait(5)

                    if fn16() then
                        n10 = 49
                    else
                        n10 = 51
                    end
                elseif n10 == 51 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 46
                elseif n10 == 52 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 53 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 54 then
                    if tbl7.enabled then
                        n10 = 55
                    else
                        n10 = 61
                    end
                elseif n10 == 55 then
                    if fn16() then
                        n10 = 56
                    else
                        n10 = 60
                    end
                elseif n10 == 56 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 57
                elseif n10 == 57 then
                    if tbl7.enabled then
                        n10 = 58
                    else
                        n10 = 59
                    end
                elseif n10 == 58 then
                    task.wait(5)

                    if fn16() then
                        n10 = 57
                    else
                        n10 = 59
                    end
                elseif n10 == 59 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 54
                elseif n10 == 60 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 61 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 62 then
                    if tbl7.enabled then
                        n10 = 63
                    else
                        n10 = 69
                    end
                elseif n10 == 63 then
                    if fn16() then
                        n10 = 64
                    else
                        n10 = 68
                    end
                elseif n10 == 64 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 65
                elseif n10 == 65 then
                    if tbl7.enabled then
                        n10 = 66
                    else
                        n10 = 67
                    end
                elseif n10 == 66 then
                    task.wait(5)

                    if fn16() then
                        n10 = 65
                    else
                        n10 = 67
                    end
                elseif n10 == 67 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 62
                elseif n10 == 68 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 69 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 70 then
                    if tbl7.enabled then
                        n10 = 71
                    else
                        n10 = 77
                    end
                elseif n10 == 71 then
                    if fn16() then
                        n10 = 72
                    else
                        n10 = 76
                    end
                elseif n10 == 72 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 73
                elseif n10 == 73 then
                    if tbl7.enabled then
                        n10 = 74
                    else
                        n10 = 75
                    end
                elseif n10 == 74 then
                    task.wait(5)

                    if fn16() then
                        n10 = 73
                    else
                        n10 = 75
                    end
                elseif n10 == 75 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 70
                elseif n10 == 76 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 77 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 78 then
                    if tbl7.enabled then
                        n10 = 79
                    else
                        n10 = 85
                    end
                elseif n10 == 79 then
                    if fn16() then
                        n10 = 80
                    else
                        n10 = 84
                    end
                elseif n10 == 80 then
                    fn9("Active", "Sudah di server Treasure Hunt!\nMenunggu event selesai...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "Already on a Treasure Hunt server!",
                        Delay = 3,
                    })

                    n10 = 81
                elseif n10 == 81 then
                    if tbl7.enabled then
                        n10 = 82
                    else
                        n10 = 83
                    end
                elseif n10 == 82 then
                    task.wait(5)

                    if fn16() then
                        n10 = 81
                    else
                        n10 = 83
                    end
                elseif n10 == 83 then
                    tbl7.cooldowns = {}
                    fn9("Scanning...", "Event selesai. Mencari server berikutnya...")
                    n10 = 78
                elseif n10 == 84 then
                    tbl8 = {}
                    n4 = 0
                    n5 = 0
                    tbl7.scanning = true
                    v8 = pcall

                    fn19 = function()
                        local v23, v24, v25 = fn14()
                        tbl8 = v23
                        n4 = v24
                        n5 = v25
                    end

                    n10 = 9
                elseif n10 == 85 then
                    fn9("Status", "Idle")
                    return
                elseif n10 == 86 then
                    v16 = tbl8[1]
                    fn9("Found! (" .. #tbl8 .. " server)", "Terbaik: " .. v16.players .. "/" .. v16.max .. " players | ping " .. v16.ping .. "ms\nSkip cooldown: " .. n4 .. " | Skip penuh: " .. n5)

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = #tbl8 .. " server(s) found! Trying all parallel...",
                        Delay = 2,
                    })

                    if not fn17(tbl8) and tbl7.enabled then
                        n10 = 87
                    else
                        n10 = 2
                    end
                elseif n10 == 87 then
                    huge2 = math.huge
                    v17, v18, v19 = pairs(tbl7.cooldowns)
                    v20 = v19
                    n10 = 88
                elseif n10 == 88 then
                    v21, v22 = v17(v18, v20)

                    if v21 == nil then
                        n10 = 91
                    else
                        n10 = 89
                    end
                elseif n10 == 89 then
                    v20 = v21
                    n8 = v22 - tick()

                    if n8 > 0 and n8 < huge2 then
                        n10 = 90
                    else
                        n10 = 88
                    end
                elseif n10 == 90 then
                    huge2 = n8
                    n10 = 88
                elseif n10 == 91 then
                    if huge2 == math.huge then
                        n10 = 93
                    else
                        n10 = 92
                    end
                elseif n10 == 92 then
                    flag6 = true
                    n10 = 94
                elseif n10 == 93 then
                    flag6 = false
                    n10 = 94
                elseif n10 == 94 then
                    if flag6 then
                        n10 = 95
                    else
                        n10 = 96
                    end
                elseif n10 == 95 then
                    flag6 = math.min(math.ceil(huge2), 10)
                    n10 = 96
                elseif n10 == 96 then
                    if flag6 then
                        n10 = 98
                    else
                        n10 = 97
                    end
                elseif n10 == 97 then
                    flag6 = 5
                    n10 = 98
                elseif n10 == 98 then
                    fn9("Waiting " .. flag6 .. "s...", "Semua kandidat dicoba.\n" .. n4 .. " server masih cooldown.\nRescan dalam " .. flag6 .. " detik...")

                    lib:MakeNotify({
                        Title = "Treasure Hunt",
                        Description = "All tried. Waiting " .. flag6 .. "s before rescan...",
                        Delay = 3,
                    })

                    n9 = 0
                    n10 = 99
                elseif n10 == 99 then
                    if tbl7.enabled and n9 < flag6 then
                        n10 = 100
                    else
                        n10 = 2
                    end
                elseif n10 == 100 then
                    task.wait(1)
                    n9 = n9 + 1
                    n10 = 99
                elseif n10 == 101 then
                    fn9("Status", "Idle")
                    return
                end
            end
        end)
    end

    v6:AddParagraph({
        Title = "Info",
        Content = "Otomatis scan dan teleport ke server dengan event Treasure Hunt aktif.\nSemua server dicoba secara parallel (serentak) untuk join lebih cepat.\nServer yang gagal join mendapat cooldown 120 detik.\nServer penuh mendapat cooldown 60 detik.\n\nUrutan prioritas: player paling sedikit → ping terendah.",
    })

    local v8 = v6:AddToggle({
        Title = "Enable Auto Join Treasure Hunt",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl7.enabled = enabled

            if not enabled then
                if tbl7.thread then
                    pcall(task.cancel, tbl7.thread)
                    tbl7.thread = nil
                end

                tbl7.cooldowns = {}
                fn9("Status", "Idle")
                return
            end

            tbl7.cooldowns = {}
            fn18()
        end,
    })

    v6:AddButton({
        Title = "Scan Now",
        Callback = function()
            if not tbl7.scanning then
                tbl7.scanning = true
                fn9("Scanning...", "Manual scan untuk server Treasure Hunt...")

                task.spawn(function()
                    local tbl8 = {}
                    local n = 0
                    local n2 = 0

                    pcall(function()
                        local v9, v10, v11 = fn14()
                        tbl8 = v9
                        n = v10
                        n2 = v11
                    end)

                    tbl7.scanning = false

                    if #tbl8 > 0 then
                        local v9 = tbl8[1]
                        tbl7.lastJobId = v9.jobId
                        local str2 = v9.players .. "/" .. v9.max .. " players | ping " .. v9.ping .. "ms"
                        fn9("Found! (" .. #tbl8 .. ")", str2 .. "\nSkip cooldown: " .. n .. " | Skip penuh: " .. n2)

                        lib:MakeNotify({
                            Title = "Treasure Hunt",
                            Description = #tbl8 .. " server(s) found! " .. str2,
                            Delay = 4,
                        })
                    else
                        fn9("Not Found", "Tidak ada server Treasure Hunt tersedia.\n" .. n .. " sedang cooldown | " .. n2 .. " penuh")

                        lib:MakeNotify({
                            Title = "Treasure Hunt",
                            Description = "No available Treasure Hunt server found.",
                            Delay = 3,
                        })
                    end
                end)

                return
            end

            lib:MakeNotify({
                Title = "Treasure Hunt",
                Description = "Sedang scanning...",
                Delay = 2,
            })
        end,
    })

    v6:AddButton({
        Title = "Teleport Now",
        Callback = function()
            if not tbl7.lastJobId then
                lib:MakeNotify({
                    Title = "Treasure Hunt",
                    Description = "Belum ada server. Scan dulu!",
                    Delay = 3,
                })

                return
            end

            lib:MakeNotify({
                Title = "Treasure Hunt",
                Description = "Teleporting to: " .. tbl7.lastJobId,
                Delay = 3,
            })

            fn15(tbl7.lastJobId)
        end,
    })

    v6:AddButton({
        Title = "Reset Cooldowns",
        Callback = function()
            tbl7.cooldowns = {}
            fn9("Status", "Cooldown di-reset. Siap scan ulang.")

            lib:MakeNotify({
                Title = "Treasure Hunt",
                Description = "Semua cooldown di-reset!",
                Delay = 2,
            })
        end,
    })

    task.spawn(function()
        task.wait(8)

        if getgenv().__autoTreasureJoin then
            getgenv().__autoTreasureJoin = nil

            if v8 then
                v8:SetValue(true)
            end
        end
    end)

    local flag4 = false

    local tbl8 = {
        savedPos = nil,
        isAtEvent = false,
        loopThread = nil,
        childAddedConn = nil,
        charAddedConn = nil,
        antiDrownThread = nil,
        o2Equipped = false,
        activeTween = nil,
        processing = false,
        divingConn = nil,
    }

    local n = 0
    local v9 = v4:AddSection("Treasure Hunt", false)

    v9:AddParagraph({
        Title = "Info",
        Content = "Automatically detects Treasure Hunt (Sunken Wreckage) when event starts, teleports & collects chests, then returns to last position before the event.\nUses Oxygen Tank to avoid drowning.\nAfter finishing will idle and wait for the next event automatically.",
    })

    local v10 = v9:AddParagraph({Title = "Status", Content = "Inactive"})

    local function fn19(arg)
        pcall(function()
            v10:SetContent(arg)
        end)
    end

    local function fn20(arg, cFrame)
        pcall(function()
            arg.CFrame = cFrame
            arg.AssemblyLinearVelocity = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end)

        task.wait(0.05)

        pcall(function()
            arg.CFrame = cFrame
            arg.AssemblyLinearVelocity = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function fn21(arg, cFrame, arg2, arg3)
        local n2 = arg2 or 6
        local v11 = n2
        local n3 = arg3 or 0.08
        local v12 = n3
        local cFrame2 = arg.CFrame

        for i = 1, v11 do
            local v13 = cFrame2:Lerp(cFrame, i / v11)

            pcall(function()
                arg.CFrame = v13
                arg.AssemblyLinearVelocity = Vector3.zero
                arg.AssemblyAngularVelocity = Vector3.zero
            end)

            task.wait(v12)
        end

        pcall(function()
            arg.CFrame = cFrame
            arg.AssemblyLinearVelocity = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function fn22()
        if tbl8.activeTween then
            pcall(function()
                tbl8.activeTween:Cancel()
            end)

            tbl8.activeTween = nil
        end
    end

    local function fn23(arg, cFrame, arg2)
        fn22()
        local flag5 = false

        tbl8.activeTween = {
            Cancel = function()
                flag5 = true
            end,
        }

        local cFrame2 = arg.CFrame
        local max = math.max
        local n2 = arg2 or 2
        local v11 = max(0.1, n2)
        local n3 = 0

        pcall(function()
            arg.Anchored = true
            arg.AssemblyLinearVelocity = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end)

        local RunService2 = game:GetService("RunService")
        local connection = nil

        connection = RunService2.Heartbeat:Connect((function(g, Z, z, m)
            return function(L)
                if flag5 or not g or not g.Parent then
                    connection:Disconnect()
                    return
                end
                n3 = n3 + L
                local L = math.clamp(n3 / Z, 0, 1)
                local t = (L < 0.5 and 2 * L * L or 1 - (-2 * L + 2) ^ 2 / 2)

                pcall(function()
                    g.CFrame = z:Lerp(m, t)
                end)

                if L >= 1 then
                    connection:Disconnect()
                end
            end
        end)(arg, v11, cFrame2, cFrame))

        while not flag5 and v11 > 0 do
            task.wait()
        end

        pcall(function()
            connection:Disconnect()
        end)

        pcall(function()
            arg.Anchored = false

            if not flag5 then
                arg.CFrame = cFrame
            end

            arg.AssemblyLinearVelocity = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end)

        tbl8.activeTween = nil
    end

    local function fn24()
        local ok, result = pcall(function()
            local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
            local replion = require(ReplicatedStorage2.Packages.Replion).Client:GetReplion("Data")
            if not replion then
                return nil
            end
            return replion:Get("EquippedOxygenTankId")
        end)

        if not ok then
            return nil
        end
        return result
    end

    local function fn25()
        if tbl8.divingConn then
            pcall(function()
                tbl8.divingConn:Disconnect()
            end)

            tbl8.divingConn = nil
        end

        local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
        local Data = require(ReplicatedStorage2.Packages.Replion).Client:WaitReplion("Data")
        if not Data then
            return
        end

        if Data:Get("EquippedOxygenTankId") ~= 105 then
            pcall(function()
                obj.RF_EquipOxygenTank:InvokeServer(105)
            end)
        end

        tbl8.o2Equipped = true

        tbl8.divingConn = Data:OnChange("EquippedOxygenTankId", function(arg)
            if not tbl8.o2Equipped then
                return
            end

            if not flag4 then
                return
            end

            if not tbl8.isAtEvent then
                return
            end

            if arg == 105 then
                return
            end
            task.wait(0.5)
            if not tbl8.o2Equipped then
                return
            end

            if not flag4 then
                return
            end

            if not tbl8.isAtEvent then
                return
            end

            if Data:Get("EquippedOxygenTankId") ~= 105 then
                pcall(function()
                    obj.RF_EquipOxygenTank:InvokeServer(105)
                end)
            end
        end)
    end

    local function fn26()
        if tbl8.divingConn then
            pcall(function()
                tbl8.divingConn:Disconnect()
            end)

            tbl8.divingConn = nil
        end

        tbl8.o2Equipped = false
        task.wait(1.5)

        if fn24() == 105 then
            pcall(function()
                obj.RF_UnequipOxygenTank:InvokeServer()
            end)
        end
    end

    local function fn27()
        if tbl8.antiDrownThread then
            pcall(task.cancel, tbl8.antiDrownThread)
            tbl8.antiDrownThread = nil
        end

        tbl8.antiDrownThread = task.spawn(function()
            while flag4 and tbl8.isAtEvent do
                pcall(function()
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local humanoid = character:FindFirstChild("Humanoid")

                    if humanoid then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)

                task.wait(0.3)
            end
        end)
    end

    local function fn28()
        if tbl8.antiDrownThread then
            pcall(task.cancel, tbl8.antiDrownThread)
            tbl8.antiDrownThread = nil
        end
    end

    local function fn29(arg)
        local now = tick()
        if now - n < 20 then
            return
        end
        n = now

        pcall(function()
            localPlayer:RequestStreamAroundAsync(arg, 300)
        end)
    end

    local function fn30()
        local tbl9 = {}
        local sunkenWreckage = workspace:FindFirstChild("Sunken Wreckage")
        if not sunkenWreckage then
            return tbl9
        end

        for i, child in ipairs(sunkenWreckage:GetChildren()) do
            if child.Name == "Treasure" and child.Parent and not child:GetAttribute("Opened") then
                table.insert(tbl9, child)
            end
        end

        return tbl9
    end

    local function fn31(arg)
        if not arg or not arg.Parent then
            return true
        end

        if not arg:GetAttribute("Opened") then
            return false
        end
        return true
    end

    local function fn32(arg)
        return arg:FindFirstChildWhichIsA("ProximityPrompt", true)
    end

    local function fn33()
        fn22()
        fn28()

        if tbl8.divingConn then
            pcall(function()
                tbl8.divingConn:Disconnect()
            end)

            tbl8.divingConn = nil
        end

        if tbl8.o2Equipped then
            tbl8.o2Equipped = false

            if fn24() == 105 then
                pcall(function()
                    obj.RF_UnequipOxygenTank:InvokeServer()
                end)
            end
        end

        if tbl8.loopThread then
            pcall(task.cancel, tbl8.loopThread)
            tbl8.loopThread = nil
        end

        if tbl8.childAddedConn then
            pcall(function()
                tbl8.childAddedConn:Disconnect()
            end)

            tbl8.childAddedConn = nil
        end

        if tbl8.charAddedConn then
            pcall(function()
                tbl8.charAddedConn:Disconnect()
            end)

            tbl8.charAddedConn = nil
        end

        tbl8.processing = false
        _G.SetTreasureBusy(false)
    end

    local function fn34()
        local savedPos = tbl8.savedPos

        if not savedPos then
            tbl8.isAtEvent = false
            local v11 = flag4
            local str2 = v11 and "Waiting for Treasure Hunt..." or "Inactive"
            fn19(str2)
            return false
        end

        fn22()
        tbl8.isAtEvent = false
        fn28()
        fn19("Returning to last position...")
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and humanoidRootPart.Parent then
            pcall(function()
                humanoidRootPart.Anchored = false
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end)

            task.wait(0.05)
            fn20(humanoidRootPart, savedPos)
            task.wait(0.1)
            fn20(humanoidRootPart, savedPos)
            tbl8.savedPos = nil
            return true
        end

        tbl8.savedPos = nil
        return false
    end

    local function fn35()
        local sunkenWreckage = workspace:FindFirstChild("Sunken Wreckage")

        if not sunkenWreckage then
            fn19("Sunken Wreckage tidak ditemukan!")

            task.spawn(function()
                task.wait(2)
                local v11 = flag4
                local str2 = v11 and "Waiting for Treasure Hunt..." or "Inactive"
                fn19(str2)
            end)

            return
        end

        local position = sunkenWreckage:GetPivot().Position
        local cframe = CFrame.new(Vector3.new(position.X, position.Y + 80, position.Z))
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            fn19("Character tidak ditemukan!")
            return
        end
        _G.SetTreasureBusy(true)
        fn19("Teleporting di atas Treasure Hunt...")
        fn21(humanoidRootPart, cframe, 6, 0.08)
        fn19("Teleport selesai! (di atas lokasi event)")
        _G.SetTreasureBusy(false)

        task.spawn(function()
            task.wait(2)
            local v11 = flag4
            local str2 = v11 and "Waiting for Treasure Hunt..." or "Inactive"
            fn19(str2)
        end)
    end

    local function fn36()
        local n2, n3, n4, sunkenWreckage, n5, n6, character, humanoidRootPart, v11, n7, n8, v12, character2, humanoidRootPart2, v13, position, cFrame, n9, cframe, magnitude
        local n10, v14, n11, n12, v15, now, n13, n14, now2, n15, n16, v16, now3, n17, n18, now4, n19, n20, v17, now5
        local n21, n22, now6, v18, str2, v19, str3, v20, str4, v21, str5, v22, str6, v23, str7, n23
        n23 = 1

        while true do
            if n23 == 1 then
                if flag4 then
                    n23 = 2
                else
                    n23 = 105
                end
            elseif n23 == 2 then
                n2 = 47760671

                if tbl8.isAtEvent then
                    n23 = 3
                else
                    n23 = 4
                end
            elseif n23 == 3 then
                return
            elseif n23 == 4 then
                if tbl8.processing then
                    n23 = 5
                else
                    n23 = 6
                end
            elseif n23 == 5 then
                return
            elseif n23 == 6 then
                tbl8.processing = true
                n3 = 834973540
                n4 = 498311252
                tbl8.isAtEvent = true
                _G.SetTreasureBusy(true)
                sunkenWreckage = workspace:FindFirstChild("Sunken Wreckage")

                if sunkenWreckage then
                    n23 = 7
                else
                    n23 = 104
                end
            elseif n23 == 7 then
                n5 = nil
                n6 = nil

                pcall(function()
                    n5 = 93570289
                    n6 = 629095425
                    fn29(sunkenWreckage:GetPivot().Position)
                end)

                task.wait(0.5)

                if #fn30() == 0 then
                    n23 = 103
                else
                    n23 = 8
                end
            elseif n23 == 8 then
                character = localPlayer.Character
                humanoidRootPart = character

                if character then
                    n23 = 9
                else
                    n23 = 10
                end
            elseif n23 == 9 then
                humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                n23 = 10
            elseif n23 == 10 then
                if humanoidRootPart then
                    n23 = 11
                else
                    n23 = 102
                end
            elseif n23 == 11 then
                tbl8.savedPos = humanoidRootPart.CFrame
                fn19("Equipping Oxygen Tank...")
                fn25()
                task.wait(0.5)
                v11 = fn30()
                n7 = nil
                n8 = nil

                if #v11 > 0 then
                    n23 = 12
                else
                    n23 = 21
                end
            elseif n23 == 12 then
                v12 = v11[1]
                character2 = localPlayer.Character
                humanoidRootPart2 = character2

                if humanoidRootPart2 then
                    n23 = 13
                else
                    n23 = 14
                end
            elseif n23 == 13 then
                humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
                n23 = 14
            elseif n23 == 14 then
                v13 = humanoidRootPart2

                if v13 and flag4 and tbl8.isAtEvent then
                    n23 = 15
                else
                    n23 = 21
                end
            elseif n23 == 15 then
                position = v12:GetPivot().Position
                cFrame = v12:GetPivot() * CFrame.new(0, 3, 3)
                fn29(position)

                pcall(function()
                    localPlayer:RequestStreamAroundAsync(position, 300)
                end)

                n9 = sunkenWreckage:GetPivot().Position.Y + 80
                cframe = CFrame.new(Vector3.new(position.X, n9, position.Z))
                fn19("Instant teleport ke permukaan air...")
                fn27()
                fn20(v13, cframe)
                task.wait(0.3)

                if tbl8.isAtEvent and flag4 then
                    n23 = 17
                else
                    n23 = 16
                end
            elseif n23 == 16 then
                fn28()
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 17 then
                magnitude = (cframe.Position - cFrame.Position).Magnitude
                n10 = math.max(1, magnitude / 100)
                fn19(string.format("Diving to chest... (%.0f studs, %.1fs)", magnitude, n10))
                fn23(v13, cFrame, n10)

                if tbl8.isAtEvent and flag4 then
                    n23 = 19
                else
                    n23 = 18
                end
            elseif n23 == 18 then
                fn28()
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 19 then
                fn19("Settling at chest location...")

                pcall(function()
                    local v24 = character2
                    local humanoid = v24 and character2:FindFirstChild("Humanoid")

                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
                    end
                end)

                task.wait(1)

                pcall(function()
                    v13.CFrame = cFrame
                    v13.AssemblyLinearVelocity = Vector3.zero
                    v13.AssemblyAngularVelocity = Vector3.zero
                end)

                fn28()

                if fn31(v12) then
                    n23 = 20
                else
                    n23 = 28
                end
            elseif n23 == 20 then
                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                n23 = 21
            elseif n23 == 21 then
                if tbl8.isAtEvent and flag4 then
                    n23 = 23
                else
                    n23 = 22
                end
            elseif n23 == 22 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 23 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v23 = flag4
                str7 = v23

                if v23 then
                    n23 = 24
                else
                    n23 = 25
                end
            elseif n23 == 24 then
                str7 = "Waiting for Treasure Hunt..."
                n23 = 25
            elseif n23 == 25 then
                if str7 then
                    n23 = 27
                else
                    n23 = 26
                end
            elseif n23 == 26 then
                str7 = "Inactive"
                n23 = 27
            elseif n23 == 27 then
                fn19(str7)
                return
            elseif n23 == 28 then
                v14 = nil
                n11 = 0
                n23 = 29
            elseif n23 == 29 then
                n12 = n11 + 1

                if n12 <= 8 then
                    n23 = 30
                else
                    n23 = 31
                end
            elseif n23 == 30 then
                n11 = n12
                v15 = fn32(v12)
                v14 = v15

                if v15 then
                    n23 = 31
                else
                    n23 = 101
                end
            elseif n23 == 31 then
                if v14 then
                    n23 = 32
                else
                    n23 = 94
                end
            elseif n23 == 32 then
                pcall(function()
                    v13.Anchored = false
                end)

                task.wait(0.05)

                pcall(function()
                    v13.CFrame = cFrame
                    v13.AssemblyLinearVelocity = Vector3.zero
                    v13.AssemblyAngularVelocity = Vector3.zero
                end)

                fn27()

                if not fn31(v12) and tbl8.isAtEvent and flag4 then
                    n23 = 40
                else
                    n23 = 33
                end
            elseif n23 == 33 then
                fn28()
                task.wait(0.3)

                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                if tbl8.isAtEvent and flag4 then
                    n23 = 35
                else
                    n23 = 34
                end
            elseif n23 == 34 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 35 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v21 = flag4
                str5 = v21

                if v21 then
                    n23 = 36
                else
                    n23 = 37
                end
            elseif n23 == 36 then
                str5 = "Waiting for Treasure Hunt..."
                n23 = 37
            elseif n23 == 37 then
                if str5 then
                    n23 = 39
                else
                    n23 = 38
                end
            elseif n23 == 38 then
                str5 = "Inactive"
                n23 = 39
            elseif n23 == 39 then
                fn19(str5)
                return
            elseif n23 == 40 then
                fn19("Attempt 1/3 - Opening chest...")
                now = tick()
                n13 = 0
                n14 = 0
                n23 = 41
            elseif n23 == 41 then
                if not fn31(v12) and tick() - now < 60 and tbl8.isAtEvent and flag4 then
                    n23 = 89
                else
                    n23 = 42
                end
            elseif n23 == 42 then
                if fn31(v12) then
                    n23 = 82
                else
                    n23 = 43
                end
            elseif n23 == 43 then
                if tbl8.isAtEvent and flag4 then
                    n23 = 44
                else
                    n23 = 47
                end
            elseif n23 == 44 then
                fn19("Chest locked, re-approaching... 1/3")
                fn28()
                n15 = cFrame * CFrame.new(0, 15, 15)
                fn23(v13, n15, 2)
                task.wait(1.5)
                fn27()
                n16 = math.max(1, (n15.Position - cFrame.Position).Magnitude / 100)
                fn23(v13, cFrame, n16)
                task.wait(1)

                if tbl8.isAtEvent and flag4 then
                    n23 = 45
                else
                    n23 = 82
                end
            elseif n23 == 45 then
                v16 = fn32(v12)
                v14 = v16

                if v16 then
                    n23 = 46
                else
                    n23 = 82
                end
            elseif n23 == 46 then
                pcall(function()
                    n7 = 332253670
                    n8 = 42394931
                    v13.CFrame = cFrame
                    v13.AssemblyLinearVelocity = Vector3.zero
                    v13.AssemblyAngularVelocity = Vector3.zero
                end)

                n23 = 47
            elseif n23 == 47 then
                if not fn31(v12) and tbl8.isAtEvent and flag4 then
                    n23 = 48
                else
                    n23 = 82
                end
            elseif n23 == 48 then
                fn19("Attempt 2/3 - Opening chest...")
                now3 = tick()
                n17 = 0
                n18 = 0
                n23 = 49
            elseif n23 == 49 then
                if not fn31(v12) and tick() - now3 < 60 and tbl8.isAtEvent and flag4 then
                    n23 = 77
                else
                    n23 = 50
                end
            elseif n23 == 50 then
                if fn31(v12) then
                    n23 = 70
                else
                    n23 = 51
                end
            elseif n23 == 51 then
                if tbl8.isAtEvent and flag4 then
                    n23 = 52
                else
                    n23 = 55
                end
            elseif n23 == 52 then
                fn19("Chest locked, re-approaching... 2/3")
                fn28()
                n19 = cFrame * CFrame.new(0, 15, 15)
                fn23(v13, n19, 2)
                task.wait(1.5)
                fn27()
                n20 = math.max(1, (n19.Position - cFrame.Position).Magnitude / 100)
                fn23(v13, cFrame, n20)
                task.wait(1)

                if tbl8.isAtEvent and flag4 then
                    n23 = 53
                else
                    n23 = 70
                end
            elseif n23 == 53 then
                v17 = fn32(v12)
                v14 = v17

                if v17 then
                    n23 = 54
                else
                    n23 = 70
                end
            elseif n23 == 54 then
                pcall(function()
                    n7 = 332253670
                    n8 = 42394931
                    v13.CFrame = cFrame
                    v13.AssemblyLinearVelocity = Vector3.zero
                    v13.AssemblyAngularVelocity = Vector3.zero
                end)

                n23 = 55
            elseif n23 == 55 then
                if not fn31(v12) and tbl8.isAtEvent and flag4 then
                    n23 = 56
                else
                    n23 = 70
                end
            elseif n23 == 56 then
                fn19("Attempt 3/3 - Opening chest...")
                now5 = tick()
                n21 = 0
                n22 = 0
                n23 = 57
            elseif n23 == 57 then
                if not fn31(v12) and tick() - now5 < 60 and tbl8.isAtEvent and flag4 then
                    n23 = 65
                else
                    n23 = 58
                end
            elseif n23 == 58 then
                fn31(v12)
                fn28()
                task.wait(0.3)

                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                if tbl8.isAtEvent and flag4 then
                    n23 = 60
                else
                    n23 = 59
                end
            elseif n23 == 59 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 60 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v18 = flag4
                str2 = v18

                if v18 then
                    n23 = 61
                else
                    n23 = 62
                end
            elseif n23 == 61 then
                str2 = "Waiting for Treasure Hunt..."
                n23 = 62
            elseif n23 == 62 then
                if str2 then
                    n23 = 64
                else
                    n23 = 63
                end
            elseif n23 == 63 then
                str2 = "Inactive"
                n23 = 64
            elseif n23 == 64 then
                fn19(str2)
                return
            elseif n23 == 65 then
                now6 = tick()

                if now6 - n21 >= 0.15 then
                    n23 = 66
                else
                    n23 = 67
                end
            elseif n23 == 66 then
                pcall(fireproximityprompt, v14)
                n21 = now6
                n23 = 67
            elseif n23 == 67 then
                if now6 - n22 >= 0.8 then
                    n23 = 68
                else
                    n23 = 69
                end
            elseif n23 == 68 then
                pcall(function()
                    if v13 and v13.Parent then
                        v13.CFrame = cFrame
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                n22 = now6
                n23 = 69
            elseif n23 == 69 then
                task.wait(0.05)
                n23 = 57
            elseif n23 == 70 then
                fn28()
                task.wait(0.3)

                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                if tbl8.isAtEvent and flag4 then
                    n23 = 72
                else
                    n23 = 71
                end
            elseif n23 == 71 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 72 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v19 = flag4
                str3 = v19

                if v19 then
                    n23 = 73
                else
                    n23 = 74
                end
            elseif n23 == 73 then
                str3 = "Waiting for Treasure Hunt..."
                n23 = 74
            elseif n23 == 74 then
                if str3 then
                    n23 = 76
                else
                    n23 = 75
                end
            elseif n23 == 75 then
                str3 = "Inactive"
                n23 = 76
            elseif n23 == 76 then
                fn19(str3)
                return
            elseif n23 == 77 then
                now4 = tick()

                if now4 - n17 >= 0.15 then
                    n23 = 78
                else
                    n23 = 79
                end
            elseif n23 == 78 then
                pcall(fireproximityprompt, v14)
                n17 = now4
                n23 = 79
            elseif n23 == 79 then
                if now4 - n18 >= 0.8 then
                    n23 = 80
                else
                    n23 = 81
                end
            elseif n23 == 80 then
                pcall(function()
                    if v13 and v13.Parent then
                        v13.CFrame = cFrame
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                n18 = now4
                n23 = 81
            elseif n23 == 81 then
                task.wait(0.05)
                n23 = 49
            elseif n23 == 82 then
                fn28()
                task.wait(0.3)

                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                if tbl8.isAtEvent and flag4 then
                    n23 = 84
                else
                    n23 = 83
                end
            elseif n23 == 83 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 84 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v20 = flag4
                str4 = v20

                if v20 then
                    n23 = 85
                else
                    n23 = 86
                end
            elseif n23 == 85 then
                str4 = "Waiting for Treasure Hunt..."
                n23 = 86
            elseif n23 == 86 then
                if str4 then
                    n23 = 88
                else
                    n23 = 87
                end
            elseif n23 == 87 then
                str4 = "Inactive"
                n23 = 88
            elseif n23 == 88 then
                fn19(str4)
                return
            elseif n23 == 89 then
                now2 = tick()

                if now2 - n13 >= 0.15 then
                    n23 = 90
                else
                    n23 = 91
                end
            elseif n23 == 90 then
                pcall(fireproximityprompt, v14)
                n13 = now2
                n23 = 91
            elseif n23 == 91 then
                if now2 - n14 >= 0.8 then
                    n23 = 92
                else
                    n23 = 93
                end
            elseif n23 == 92 then
                pcall(function()
                    if v13 and v13.Parent then
                        v13.CFrame = cFrame
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                n14 = now2
                n23 = 93
            elseif n23 == 93 then
                task.wait(0.05)
                n23 = 41
            elseif n23 == 94 then
                task.wait(0.5)

                pcall(function()
                    if v13 and v13.Parent then
                        v13.Anchored = false
                        v13.AssemblyLinearVelocity = Vector3.zero
                        v13.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                if tbl8.isAtEvent and flag4 then
                    n23 = 96
                else
                    n23 = 95
                end
            elseif n23 == 95 then
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 96 then
                task.wait(0.5)
                fn19("Chest claimed! Returning...")
                fn34()
                task.wait(1.5)
                fn26()
                task.wait(0.5)
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                v22 = flag4
                str6 = v22

                if v22 then
                    n23 = 97
                else
                    n23 = 98
                end
            elseif n23 == 97 then
                str6 = "Waiting for Treasure Hunt..."
                n23 = 98
            elseif n23 == 98 then
                if str6 then
                    n23 = 100
                else
                    n23 = 99
                end
            elseif n23 == 99 then
                str6 = "Inactive"
                n23 = 100
            elseif n23 == 100 then
                fn19(str6)
                return
            elseif n23 == 101 then
                pcall(function()
                    v13.CFrame = cFrame
                    v13.AssemblyLinearVelocity = Vector3.zero
                    v13.AssemblyAngularVelocity = Vector3.zero
                end)

                task.wait(0.1)
                n23 = 29
            elseif n23 == 102 then
                tbl8.isAtEvent = false
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 103 then
                tbl8.isAtEvent = false
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 104 then
                tbl8.isAtEvent = false
                tbl8.processing = false
                _G.SetTreasureBusy(false)
                return
            elseif n23 == 105 then
                return
            end
        end
    end

    v9:AddButton({
        Title = "Teleport Now (di atas lokasi)",
        Callback = function()
            task.spawn(fn35)
        end,
    })

    v9:AddToggle({
        Title = "Auto Treasure Hunt",
        Default = false,
        Callback = function(arg)
            flag4 = arg

            if not arg then
                if tbl8.isAtEvent and tbl8.savedPos then
                    fn34()
                    task.wait(0.3)
                end

                fn33()
                fn19("Inactive")
                return
            end

            fn19("Waiting for Treasure Hunt...")
            fn33()

            tbl8.childAddedConn = workspace.ChildAdded:Connect(function(child)
                if not flag4 then
                    return
                end

                if child.Name == "Sunken Wreckage" then
                    task.wait(2)

                    if flag4 and not tbl8.processing then
                        task.spawn(fn36)
                    end
                end
            end)

            tbl8.charAddedConn = localPlayer.CharacterAdded:Connect(function()
                task.wait(3)
                fn22()
                tbl8.isAtEvent = false
                tbl8.o2Equipped = false
                tbl8.processing = false

                if tbl8.divingConn then
                    pcall(function()
                        tbl8.divingConn:Disconnect()
                    end)

                    tbl8.divingConn = nil
                end

                fn28()
            end)

            tbl8.loopThread = task.spawn(function()
                if workspace:FindFirstChild("Sunken Wreckage") and not tbl8.processing then
                    task.spawn(fn36)
                end

                while flag4 do
                    task.wait(3)
                    if not flag4 then
                        break
                    end

                    if not tbl8.isAtEvent and not tbl8.processing and #fn30() > 0 then
                        task.spawn(fn36)
                    end
                end
            end)
        end,
    })

    local v11 = v4:AddSection("Mining Crystal")
    local tbl9 = {enabled = false, loopThread = nil, savedPos = nil}

    v11:AddParagraph({
        Title = "Note",
        Content = "Untuk menggunakan fitur ini harus berada di Crystal Depths!",
    })

    v11:AddToggle({
        Title = "Enable Auto Mine Crystal",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                tbl9.enabled = true

                tbl9.loopThread = task.spawn(function()
                    local n2, fn37, n3, fn38, fn39, fn40, fn41, n4, fn42, fn43, fn44, n5, n6, fn45, character, humanoidRootPart, n7, n8, n9, v12
                    local v13, v14, v15, v16, v17, v18, v19, v20, v21, prompt, part, v22, v23, n10, n11, n12, n13, now, n14
                    n14 = 1

                    while true do
                        if n14 == 1 then
                            n2 = 584030416

                            fn37 = function()
                                local v24 = fn2()
                                if v24 then
                                    return v24
                                end
                                local v25 = fn3()
                                if not v25 then
                                    return nil
                                end

                                local ok, result = pcall(function()
                                    return v25.Client:WaitReplion("Data")
                                end)

                                local v26 = ok and result or nil
                                return v26
                            end

                            n3 = nil

                            fn38 = function()
                                n3 = 119224004
                                local character2 = localPlayer.Character
                                if not character2 then
                                    return false
                                end

                                for i, child in ipairs(character2:GetChildren()) do
                                    if child:IsA("Tool") and (child.Name:lower():find("pick") or child.Name == "Pickaxe") then
                                        return true
                                    end
                                end

                                return false
                            end

                            fn39 = function(arg2)
                                if not arg2 then
                                    return false
                                end
                                local uuid = nil

                                pcall(function()
                                    local v24 = arg2:Get({"Inventory", "Gears"})
                                    local tbl10 = v24 or {}

                                    for k, v25 in pairs(tbl10) do
                                        if v25.Id == 20220 then
                                            uuid = v25.UUID
                                            break
                                        end
                                    end
                                end)

                                if not uuid then
                                    pcall(function()
                                        local v24 = arg2:Get({"Inventory", "Items"})
                                        local tbl10 = v24 or {}

                                        for k, v25 in pairs(tbl10) do
                                            if v25.Id == 20220 then
                                                uuid = v25.UUID
                                                break
                                            end
                                        end
                                    end)
                                end

                                if not uuid then
                                    return false
                                end
                                local v24 = nil
                                local now2 = tick()

                                while tick() - now2 < 5 do
                                    local EquippedItems = arg2:Get("EquippedItems")
                                    local tbl10 = EquippedItems or {}

                                    for k, v25 in pairs(tbl10) do
                                        if v25 == uuid then
                                            v24 = k
                                            break
                                        end
                                    end

                                    if v24 then
                                        break
                                    end

                                    pcall(function()
                                        obj.RE_EquipItem:FireServer(uuid, "Gears")
                                    end)

                                    task.wait(0.5)
                                end

                                if not v24 then
                                    return false
                                end

                                pcall(function()
                                    obj.RF_EquipToolFromHotbar:FireServer(v24)
                                end)

                                task.wait(0.5)
                                return true
                            end

                            fn40 = function(arg2)
                                if not fn38() then
                                    return fn39(arg2)
                                end
                                return true
                            end

                            fn41 = function(arg2)
                                local character2 = localPlayer.Character
                                local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                                if not humanoidRootPart2 then
                                    return false
                                end
                                local n15 = (humanoidRootPart2.Position - arg2.Position).Magnitude / 40
                                local n16 = n15

                                if n15 < 0.1 then
                                    n16 = 0.1
                                end

                                local tweenInfo = TweenInfo.new(n16, Enum.EasingStyle.Linear)
                                local tween = game:GetService("TweenService"):Create(humanoidRootPart2, tweenInfo, {CFrame = arg2})
                                local bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.Velocity = Vector3.zero
                                bodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                bodyVelocity.Parent = humanoidRootPart2

                                local connection = game:GetService("RunService").Stepped:Connect((function(t)
                                    return function()
                                        if t then
                                            for L, L in ipairs(t:GetDescendants()) do
                                                if L:IsA("BasePart") then
                                                    L.CanCollide = false
                                                end
                                            end
                                        end
                                    end
                                end)(character2))

                                tween:Play()
                                tween.Completed:Wait()

                                if connection then
                                    connection:Disconnect()
                                end

                                if bodyVelocity then
                                    bodyVelocity:Destroy()
                                end

                                if humanoidRootPart2 then
                                    humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
                                    humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
                                end

                                return true
                            end

                            n4 = nil

                            fn42 = function(arg2)
                                n4 = 240706138
                                return fn41(CFrame.new(arg2 + Vector3.new(0, 4, 0)))
                            end

                            fn43 = function()
                                if not tbl9.savedPos then
                                    return
                                end
                                fn41(tbl9.savedPos)
                            end

                            fn44 = function(arg2)
                                local flag5 = false

                                local connection = obj.RE_PickaxeMining.OnClientEvent:Connect(function()
                                    flag5 = true
                                end)

                                local n15 = 0

                                while not flag5 and n15 < arg2 do
                                    task.wait(0.2)
                                    n15 = n15 + 0.2
                                end

                                connection:Disconnect()
                                return flag5
                            end

                            n5 = nil
                            n6 = nil

                            fn45 = function()
                                n5 = 82807871
                                n6 = 649117071
                                local character2 = localPlayer.Character
                                local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                                local position = humanoidRootPart2 and humanoidRootPart2.Position or Vector3.new(0, 0, 0)
                                local tbl10 = {}
                                local tbl11 = {}

                                for i, v24 in ipairs(CollectionService:GetTagged("GlowingCrystal")) do
                                    local proximityPrompt = v24:FindFirstChildOfClass("ProximityPrompt")

                                    if proximityPrompt and proximityPrompt.Enabled then
                                        table.insert(tbl10, {part = v24, prompt = proximityPrompt})
                                        tbl11[v24] = true
                                    end
                                end

                                pcall(function()
                                    local islands = workspace:FindFirstChild("Islands")

                                    if islands then
                                        local v24, v25, v26 = ipairs(islands:GetChildren())
                                        local v27 = v26
                                        local v28 = v24
                                        local v29 = v25

                                        while true do
                                            local v30, v31 = v28(v29, v27)
                                            if v30 == nil then
                                                break
                                            end
                                            v27 = v30
                                            local crystals = v31:FindFirstChild("Crystals")

                                            if crystals then
                                                for i, descendant in ipairs(crystals:GetDescendants()) do
                                                    if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                                                        local parent = descendant.Parent

                                                        if parent and parent:IsA("BasePart") and not tbl11[parent] then
                                                            table.insert(tbl10, {part = parent, prompt = descendant})
                                                            tbl11[parent] = true
                                                        end
                                                    end
                                                end

                                                v27 = v30
                                            end
                                        end
                                    end
                                end)

                                table.sort(tbl10, function(arg2, arg3)
                                    local flag5 = (arg2.part.Position - position).Magnitude < (arg3.part.Position - position).Magnitude
                                    return flag5
                                end)

                                return tbl10
                            end

                            character = localPlayer.Character
                            humanoidRootPart = character

                            if character then
                                n14 = 2
                            else
                                n14 = 3
                            end
                        elseif n14 == 2 then
                            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            n14 = 3
                        elseif n14 == 3 then
                            if humanoidRootPart then
                                n14 = 4
                            else
                                n14 = 5
                            end
                        elseif n14 == 4 then
                            tbl9.savedPos = humanoidRootPart.CFrame
                            n14 = 5
                        elseif n14 == 5 then
                            n7 = nil
                            n8 = nil
                            n9 = nil
                            n14 = 6
                        elseif n14 == 6 then
                            if tbl9.enabled then
                                n14 = 7
                            else
                                n14 = 42
                            end
                        elseif n14 == 7 then
                            task.wait(0.5)
                            v12 = fn37()

                            if v12 then
                                n14 = 8
                            else
                                n14 = 41
                            end
                        elseif n14 == 8 then
                            v13 = fn45()

                            if #v13 == 0 then
                                n14 = 37
                            else
                                n14 = 9
                            end
                        elseif n14 == 9 then
                            _G.SetMining(true)
                            flag2 = true

                            if fn40(v12) then
                                n14 = 10
                            else
                                n14 = 36
                            end
                        elseif n14 == 10 then
                            task.wait(0.5)
                            v14, v15, v16 = ipairs(v13)
                            v17 = v16
                            v18 = v14
                            v19 = v15
                            n14 = 11
                        elseif n14 == 11 then
                            v20, v21 = v18(v19, v17)

                            if v20 == nil then
                                n14 = 34
                            else
                                n14 = 12
                            end
                        elseif n14 == 12 then
                            v17 = v20

                            if tbl9.enabled then
                                n14 = 13
                            else
                                n14 = 34
                            end
                        elseif n14 == 13 then
                            prompt = v21.prompt
                            part = v21.part

                            if prompt and prompt.Parent and prompt.Enabled then
                                n14 = 14
                            else
                                n14 = 11
                            end
                        elseif n14 == 14 then
                            fn42(part.Position)
                            task.wait(0.5)

                            if tbl9.enabled then
                                n14 = 15
                            else
                                n14 = 34
                            end
                        elseif n14 == 15 then
                            if prompt and prompt.Parent and prompt.Enabled then
                                n14 = 16
                            else
                                n14 = 11
                            end
                        elseif n14 == 16 then
                            if fn40(v12) then
                                n14 = 17
                            else
                                n14 = 33
                            end
                        elseif n14 == 17 then
                            task.wait(0.3)
                            v22 = v18
                            v23 = v19
                            n10 = 0
                            n14 = 18
                        elseif n14 == 18 then
                            n11 = n10 + 1

                            if n11 <= 15 then
                                n14 = 19
                            else
                                n14 = 24
                            end
                        elseif n14 == 19 then
                            n10 = n11

                            if tbl9.enabled and prompt and prompt.Parent and prompt.Enabled then
                                n14 = 20
                            else
                                n14 = 24
                            end
                        elseif n14 == 20 then
                            if fn40(v12) then
                                n14 = 21
                            else
                                n14 = 32
                            end
                        elseif n14 == 21 then
                            task.wait(0.2)

                            pcall(function()
                                n9 = 295025792
                                fireproximityprompt(prompt, 0)
                            end)

                            n12 = prompt.HoldDuration + 0.5
                            n13 = 0
                            n14 = 22
                        elseif n14 == 22 then
                            if n13 < n12 and tbl9.enabled then
                                n14 = 30
                            else
                                n14 = 23
                            end
                        elseif n14 == 23 then
                            if fn44(3) then
                                n14 = 24
                            else
                                n14 = 29
                            end
                        elseif n14 == 24 then
                            v17 = v20
                            v18 = v22
                            v19 = v23
                            now = tick()
                            n14 = 25
                        elseif n14 == 25 then
                            if prompt and prompt.Parent and prompt.Enabled and tick() - now < 5 then
                                n14 = 28
                            else
                                n14 = 26
                            end
                        elseif n14 == 26 then
                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Crystal " .. v20 .. "/" .. #v13 .. " selesai!",
                                Delay = 2,
                            })

                            if v20 < #v13 and tbl9.enabled then
                                n14 = 27
                            else
                                n14 = 11
                            end
                        elseif n14 == 27 then
                            task.wait(3)
                            n14 = 11
                        elseif n14 == 28 then
                            task.wait(0.3)
                            n14 = 25
                        elseif n14 == 29 then
                            task.wait(1)
                            n14 = 18
                        elseif n14 == 30 then
                            task.wait(0.3)
                            n13 = n13 + 0.3

                            if fn38() then
                                n14 = 22
                            else
                                n14 = 31
                            end
                        elseif n14 == 31 then
                            fn40(v12)
                            task.wait(0.2)

                            pcall(function()
                                n7 = 391092805
                                n8 = 812011441
                                fireproximityprompt(prompt, 0)
                            end)

                            n14 = 22
                        elseif n14 == 32 then
                            task.wait(1)
                            n14 = 18
                        elseif n14 == 33 then
                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Pickaxe tidak ditemukan!",
                                Delay = 3,
                            })

                            tbl9.enabled = false
                            n14 = 34
                        elseif n14 == 34 then
                            _G.SetMining(false)
                            flag2 = false

                            if tbl9.enabled then
                                n14 = 35
                            else
                                n14 = 6
                            end
                        elseif n14 == 35 then
                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Semua crystal selesai! Menunggu respawn...",
                                Delay = 3,
                            })

                            fn43()
                            n14 = 6
                        elseif n14 == 36 then
                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Pickaxe tidak ditemukan!",
                                Delay = 3,
                            })

                            _G.SetMining(false)
                            flag2 = false
                            tbl9.enabled = false
                            n14 = 42
                        elseif n14 == 37 then
                            fn43()

                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Tidak ada crystal, menunggu respawn...",
                                Delay = 3,
                            })

                            n14 = 38
                        elseif n14 == 38 then
                            if tbl9.enabled then
                                n14 = 39
                            else
                                n14 = 6
                            end
                        elseif n14 == 39 then
                            task.wait(5)

                            if #fn45() > 0 then
                                n14 = 40
                            else
                                n14 = 38
                            end
                        elseif n14 == 40 then
                            lib:MakeNotify({
                                Title = "Auto Mine",
                                Description = "Crystal respawn! Mulai mining lagi...",
                                Delay = 3,
                            })

                            n14 = 6
                        elseif n14 == 41 then
                            task.wait(2)
                            n14 = 6
                        elseif n14 == 42 then
                            _G.SetMining(false)
                            flag2 = false
                            return
                        end
                    end
                end)

                lib:MakeNotify({
                    Title = "Auto Mine",
                    Description = "Auto Mine Crystal aktif!",
                    Delay = 2,
                })
            else
                tbl9.enabled = false
                _G.SetMining(false)
                flag2 = false

                if tbl9.loopThread then
                    pcall(task.cancel, tbl9.loopThread)
                    tbl9.loopThread = nil
                end

                lib:MakeNotify({
                    Title = "Auto Mine",
                    Description = "Auto Mine Crystal dihentikan.",
                    Delay = 2,
                })
            end
        end,
    })

    local v12 = v4:AddSection("Mining Veilshard")
    local tbl10 = {enabled = false, loopThread = nil, savedPos = nil}

    v12:AddParagraph({
        Title = "Note",
        Content = "Otomatis mining Veilshard di Lava Basin.\nCrystal terdeteksi via ProximityPrompt.\nPickaxe di-equip otomatis saat mulai mining tiap crystal.",
    })

    v12:AddToggle({
        Title = "Enable Auto Mine Veilshard",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                tbl10.enabled = true

                tbl10.loopThread = task.spawn(function()
                    local n2, n3, n4, fn37, fn38, fn39, n5, fn40, fn41, n6, n7, fn42, n8, fn43, n9, n10, fn44, fn45, n11, fn46
                    local fn47, fn48, character, humanoidRootPart, n12, n13, v13, v14, character2, humanoidRootPart2, v15, v16, v17, v18, v19, v20, v21, v22, prompt, part
                    local v23, v24, n14, n15, n16, n17, now, n18
                    n18 = 1

                    while true do
                        if n18 == 1 then
                            n2 = 561657022
                            n3 = 657466661
                            n4 = 804359979

                            fn37 = function()
                                local v25 = fn2()
                                if v25 then
                                    return v25
                                end
                                local v26 = fn3()
                                if not v26 then
                                    return nil
                                end

                                local ok, result = pcall(function()
                                    return v26.Client:WaitReplion("Data")
                                end)

                                local v27 = ok and result or nil
                                return v27
                            end

                            fn38 = function()
                                local character3 = localPlayer.Character
                                if not character3 then
                                    return false
                                end

                                for i, child in ipairs(character3:GetChildren()) do
                                    if child:IsA("Tool") and (child.Name:lower():find("pick") or child.Name == "Pickaxe") then
                                        return true
                                    end
                                end

                                return false
                            end

                            fn39 = function(arg2)
                                if not arg2 then
                                    return false
                                end
                                local uuid = nil

                                pcall(function()
                                    local v25 = arg2:Get({"Inventory", "Gears"})
                                    local tbl11 = v25 or {}

                                    for k, v26 in pairs(tbl11) do
                                        if v26.Id == 20220 then
                                            uuid = v26.UUID
                                            break
                                        end
                                    end
                                end)

                                if not uuid then
                                    pcall(function()
                                        local v25 = arg2:Get({"Inventory", "Items"})
                                        local tbl11 = v25 or {}

                                        for k, v26 in pairs(tbl11) do
                                            if v26.Id == 20220 then
                                                uuid = v26.UUID
                                                break
                                            end
                                        end
                                    end)
                                end

                                if not uuid then
                                    return false
                                end
                                local v25 = nil
                                local now2 = tick()

                                while tick() - now2 < 5 do
                                    local EquippedItems = arg2:Get("EquippedItems")
                                    local tbl11 = EquippedItems or {}

                                    for k, v26 in pairs(tbl11) do
                                        if v26 == uuid then
                                            v25 = k
                                            break
                                        end
                                    end

                                    if v25 then
                                        break
                                    end

                                    pcall(function()
                                        obj.RE_EquipItem:FireServer(uuid, "Gears")
                                    end)

                                    task.wait(0.5)
                                end

                                if not v25 then
                                    return false
                                end

                                pcall(function()
                                    obj.RF_EquipToolFromHotbar:FireServer(v25)
                                end)

                                task.wait(0.5)
                                return true
                            end

                            n5 = nil

                            fn40 = function(arg2)
                                n5 = 293639882
                                if not fn38() then
                                    return fn39(arg2)
                                end
                                return true
                            end

                            fn41 = function(arg2)
                                local character3 = localPlayer.Character
                                local humanoidRootPart3 = character3 and character3:FindFirstChild("HumanoidRootPart")
                                if not humanoidRootPart3 then
                                    return false
                                end
                                local n19 = math.max((humanoidRootPart3.Position - arg2.Position).Magnitude / 40, 0.1)
                                local tweenInfo = TweenInfo.new(n19, Enum.EasingStyle.Linear)
                                local tween = game:GetService("TweenService"):Create(humanoidRootPart3, tweenInfo, {CFrame = arg2})
                                local bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.Velocity = Vector3.zero
                                bodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                bodyVelocity.Parent = humanoidRootPart3

                                local connection = game:GetService("RunService").Stepped:Connect((function(t)
                                    return function()
                                        if t then
                                            for L, L in ipairs(t:GetDescendants()) do
                                                if L:IsA("BasePart") then
                                                    L.CanCollide = false
                                                end
                                            end
                                        end
                                    end
                                end)(character3))

                                tween:Play()
                                tween.Completed:Wait()
                                connection:Disconnect()
                                bodyVelocity:Destroy()
                                humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
                                humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
                                return true
                            end

                            n6 = nil
                            n7 = nil

                            fn42 = function(arg2)
                                n6 = 1055114405
                                n7 = 696636979
                                return fn41(CFrame.new(arg2 + Vector3.new(0, 4, 0)))
                            end

                            n8 = nil

                            fn43 = function()
                                n8 = 495366656
                                if not tbl10.savedPos then
                                    return
                                end
                                fn41(tbl10.savedPos)
                            end

                            n9 = nil
                            n10 = nil

                            fn44 = function(arg2)
                                n9 = 808315696
                                n10 = 49467393
                                local flag5 = false

                                local connection = obj.RE_PickaxeMining.OnClientEvent:Connect(function()
                                    flag5 = true
                                end)

                                local n19 = 0

                                while not flag5 and n19 < arg2 do
                                    task.wait(0.2)
                                    n19 = n19 + 0.2
                                end

                                connection:Disconnect()
                                return flag5
                            end

                            fn45 = function()
                                local islands = workspace:FindFirstChild("Islands")
                                local lavaBasin = islands and islands:FindFirstChild("Lava Basin") or nil
                                return lavaBasin
                            end

                            n11 = nil

                            fn46 = function()
                                n11 = 855657542
                                local v25 = fn45()
                                if not v25 then
                                    return nil
                                end

                                pcall(function()
                                    localPlayer:RequestStreamAroundAsync(v25:GetPivot().Position, 500)
                                end)

                                local v26 = nil
                                local n19 = tick() + 8

                                while tick() < n19 do
                                    local crystals = v25:FindFirstChild("Crystals")
                                    v26 = crystals
                                    if crystals and #crystals:GetChildren() > 0 then
                                        return crystals
                                    end
                                    task.wait(0.3)
                                end

                                return v26
                            end

                            fn47 = function(arg2)
                                for i, child in ipairs(arg2:GetChildren()) do
                                    if child.Name == "BasinCrystal" then
                                        local proximityPrompt = child:FindFirstChildOfClass("ProximityPrompt")
                                        if proximityPrompt and proximityPrompt.Enabled then
                                            return true, child, proximityPrompt
                                        end
                                    end
                                end

                                return false, nil, nil
                            end

                            fn48 = function()
                                local character3 = localPlayer.Character
                                local humanoidRootPart3 = character3 and character3:FindFirstChild("HumanoidRootPart")
                                local position = humanoidRootPart3 and humanoidRootPart3.Position or Vector3.new(0, 0, 0)
                                local tbl11 = {}
                                local v25 = fn45()
                                if not v25 then
                                    return tbl11
                                end
                                local crystals = v25:FindFirstChild("Crystals")
                                if not crystals then
                                    return tbl11
                                end

                                for i, child in ipairs(crystals:GetChildren()) do
                                    if child.Name == "Crystal" then
                                        local v26, v27, v28 = fn47(child)

                                        if v26 then
                                            table.insert(tbl11, {part = v27, prompt = v28, folder = child})
                                        end
                                    end
                                end

                                table.sort(tbl11, function(arg2, arg3)
                                    local flag5 = (arg2.part.Position - position).Magnitude < (arg3.part.Position - position).Magnitude
                                    return flag5
                                end)

                                return tbl11
                            end

                            character = localPlayer.Character
                            humanoidRootPart = character

                            if character then
                                n18 = 2
                            else
                                n18 = 3
                            end
                        elseif n18 == 2 then
                            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            n18 = 3
                        elseif n18 == 3 then
                            if humanoidRootPart then
                                n18 = 4
                            else
                                n18 = 5
                            end
                        elseif n18 == 4 then
                            tbl10.savedPos = humanoidRootPart.CFrame
                            n18 = 5
                        elseif n18 == 5 then
                            n12 = nil
                            n13 = nil
                            n18 = 6
                        elseif n18 == 6 then
                            if tbl10.enabled then
                                n18 = 7
                            else
                                n18 = 44
                            end
                        elseif n18 == 7 then
                            task.wait(0.5)
                            v13 = fn37()

                            if v13 then
                                n18 = 8
                            else
                                n18 = 43
                            end
                        elseif n18 == 8 then
                            fn46()
                            v14 = fn48()

                            if #v14 == 0 then
                                n18 = 39
                            else
                                n18 = 9
                            end
                        elseif n18 == 9 then
                            character2 = localPlayer.Character
                            humanoidRootPart2 = character2

                            if character2 then
                                n18 = 10
                            else
                                n18 = 11
                            end
                        elseif n18 == 10 then
                            humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
                            n18 = 11
                        elseif n18 == 11 then
                            if humanoidRootPart2 then
                                n18 = 12
                            else
                                n18 = 13
                            end
                        elseif n18 == 12 then
                            tbl10.savedPos = humanoidRootPart2.CFrame
                            n18 = 13
                        elseif n18 == 13 then
                            _G.SetMining(true)
                            flag2 = true
                            v15, v16, v17 = ipairs(v14)
                            v18 = v17
                            v19 = v15
                            v20 = v16
                            n18 = 14
                        elseif n18 == 14 then
                            v21, v22 = v19(v20, v18)

                            if v21 == nil then
                                n18 = 37
                            else
                                n18 = 15
                            end
                        elseif n18 == 15 then
                            v18 = v21

                            if tbl10.enabled then
                                n18 = 16
                            else
                                n18 = 37
                            end
                        elseif n18 == 16 then
                            prompt = v22.prompt
                            part = v22.part

                            if prompt and prompt.Parent and prompt.Enabled then
                                n18 = 17
                            else
                                n18 = 14
                            end
                        elseif n18 == 17 then
                            fn42(part.Position)
                            task.wait(0.5)

                            if tbl10.enabled then
                                n18 = 18
                            else
                                n18 = 37
                            end
                        elseif n18 == 18 then
                            if prompt and prompt.Parent and prompt.Enabled then
                                n18 = 19
                            else
                                n18 = 14
                            end
                        elseif n18 == 19 then
                            if fn40(v13) then
                                n18 = 20
                            else
                                n18 = 36
                            end
                        elseif n18 == 20 then
                            task.wait(0.3)
                            v23 = v19
                            v24 = v20
                            n14 = 0
                            n18 = 21
                        elseif n18 == 21 then
                            n15 = n14 + 1

                            if n15 <= 15 then
                                n18 = 22
                            else
                                n18 = 27
                            end
                        elseif n18 == 22 then
                            n14 = n15

                            if tbl10.enabled and prompt and prompt.Parent and prompt.Enabled then
                                n18 = 23
                            else
                                n18 = 27
                            end
                        elseif n18 == 23 then
                            if fn40(v13) then
                                n18 = 24
                            else
                                n18 = 35
                            end
                        elseif n18 == 24 then
                            task.wait(0.2)

                            pcall(function()
                                n12 = 75308659
                                fireproximityprompt(prompt, 0)
                            end)

                            n16 = prompt.HoldDuration + 0.5
                            n17 = 0
                            n18 = 25
                        elseif n18 == 25 then
                            if n17 < n16 and tbl10.enabled then
                                n18 = 33
                            else
                                n18 = 26
                            end
                        elseif n18 == 26 then
                            if fn44(3) then
                                n18 = 27
                            else
                                n18 = 32
                            end
                        elseif n18 == 27 then
                            v18 = v21
                            v19 = v23
                            v20 = v24
                            now = tick()
                            n18 = 28
                        elseif n18 == 28 then
                            if prompt and prompt.Parent and prompt.Enabled and tick() - now < 5 then
                                n18 = 31
                            else
                                n18 = 29
                            end
                        elseif n18 == 29 then
                            lib:MakeNotify({
                                Title = "Auto Veilshard",
                                Description = "Veilshard " .. v21 .. "/" .. #v14 .. " selesai!",
                                Delay = 2,
                            })

                            if tbl10.enabled then
                                n18 = 30
                            else
                                n18 = 14
                            end
                        elseif n18 == 30 then
                            task.wait(12)
                            n18 = 14
                        elseif n18 == 31 then
                            task.wait(0.3)
                            n18 = 28
                        elseif n18 == 32 then
                            task.wait(1)
                            n18 = 21
                        elseif n18 == 33 then
                            task.wait(0.3)
                            n17 = n17 + 0.3

                            if fn38() then
                                n18 = 25
                            else
                                n18 = 34
                            end
                        elseif n18 == 34 then
                            fn40(v13)
                            task.wait(0.2)

                            pcall(function()
                                n13 = 519420076
                                fireproximityprompt(prompt, 0)
                            end)

                            n18 = 25
                        elseif n18 == 35 then
                            task.wait(1)
                            n18 = 21
                        elseif n18 == 36 then
                            lib:MakeNotify({
                                Title = "Auto Veilshard",
                                Description = "Pickaxe tidak ditemukan!",
                                Delay = 3,
                            })

                            tbl10.enabled = false
                            n18 = 37
                        elseif n18 == 37 then
                            _G.SetMining(false)
                            flag2 = false

                            if tbl10.enabled then
                                n18 = 38
                            else
                                n18 = 6
                            end
                        elseif n18 == 38 then
                            lib:MakeNotify({
                                Title = "Auto Veilshard",
                                Description = "Semua crystal selesai! Menunggu respawn...",
                                Delay = 3,
                            })

                            fn43()
                            n18 = 6
                        elseif n18 == 39 then
                            fn43()
                            _G.SetMining(false)
                            flag2 = false

                            lib:MakeNotify({
                                Title = "Auto Veilshard",
                                Description = "Tidak ada crystal, menunggu respawn...",
                                Delay = 3,
                            })

                            n18 = 40
                        elseif n18 == 40 then
                            if tbl10.enabled then
                                n18 = 41
                            else
                                n18 = 6
                            end
                        elseif n18 == 41 then
                            task.wait(5)
                            fn46()

                            if #fn48() > 0 then
                                n18 = 42
                            else
                                n18 = 40
                            end
                        elseif n18 == 42 then
                            lib:MakeNotify({
                                Title = "Auto Veilshard",
                                Description = "Crystal muncul! Mulai mining...",
                                Delay = 3,
                            })

                            n18 = 6
                        elseif n18 == 43 then
                            task.wait(2)
                            n18 = 6
                        elseif n18 == 44 then
                            _G.SetMining(false)
                            flag2 = false
                            return
                        end
                    end
                end)

                lib:MakeNotify({
                    Title = "Auto Veilshard",
                    Description = "Auto Mine Veilshard aktif!",
                    Delay = 2,
                })
            else
                tbl10.enabled = false
                _G.SetMining(false)
                flag2 = false

                if tbl10.loopThread then
                    pcall(task.cancel, tbl10.loopThread)
                    tbl10.loopThread = nil
                end

                lib:MakeNotify({
                    Title = "Auto Veilshard",
                    Description = "Auto Mine Veilshard dihentikan.",
                    Delay = 2,
                })
            end
        end,
    })

    local v13 = v4:AddSection("Claim Pirate Chest", false)
    local tbl11 = {enabled = false, thread = nil, busy = false}

    local function fn37(arg, arg2)
        local makeNotify = lib.MakeNotify
        local tbl12 = {Title = "Pirate Chest", Description = arg}
        local delay = arg2 or 2
        tbl12.Delay = delay
        makeNotify(lib, tbl12)
    end

    local function fn38()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        return humanoidRootPart
    end

    local function fn39(arg, cFrame)
        arg.CFrame = cFrame
        arg.AssemblyLinearVelocity = Vector3.zero
        arg.AssemblyAngularVelocity = Vector3.zero
    end

    local function fn40()
        local v14 = fn3()
        local replion = v14 and v14.Client and v14.Client:GetReplion("PirateTreasureChests")
        local v15 = replion

        local ok, result = pcall(function()
            local v16 = v15
            local SpawnedChests = v16 and v15:Get("SpawnedChests")
            return SpawnedChests
        end)

        local tbl12 = ok and type(result) == "table" and result or {}
        return tbl12
    end

    local function fn41()
        if tbl11.busy then
            return
        end
        local v14 = fn38()
        local v15 = fn40()
        if not v14 or #v15 == 0 then
            return
        end
        tbl11.busy = true
        local cFrame = v14.CFrame
        local flag5 = false
        local n2 = 0
        local tbl12 = {}
        local v16, v17, v18 = ipairs(v15)
        local v19 = v18
        local v20 = v16
        local v21 = v17

        while true do
            local v22, v23 = v20(v21, v19)
            if v22 == nil then
                break
            end
            v19 = v22
            if not tbl11.enabled then
                break
            end

            if tbl12[v23.Id] or not v23.Location then
                continue
            end
            local v24 = fn38()
            local v25 = v24
            if not v24 then
                break
            end

            if (v24.Position - v23.Location).Magnitude > 100 then
                flag5 = true
                pcall(fn39, v24, CFrame.new(v23.Location + Vector3.new(0, 5, 0)))
                task.wait(0.35)
                local v26 = fn38()
                v25 = v26
                if not v26 then
                    break
                end
            end

            local position = v25.Position

            for i, v26 in ipairs(v15) do
                if not tbl12[v26.Id] and v26.Location and (position - v26.Location).Magnitude <= 100 then
                    tbl12[v26.Id] = true
                    n2 = n2 + 1

                    pcall(function()
                        obj.RE_ClaimPirateChest:FireServer(v26.Id)
                    end)

                    task.wait(0.1)
                end
            end

            v19 = v22
        end

        if flag5 then
            local v22 = fn38()

            if v22 then
                pcall(fn39, v22, cFrame)
            end
        end

        if n2 > 0 then
            fn37(string.format("Claim %d chest.", n2))
        end

        tbl11.busy = false
    end

    v13:AddParagraph({
        Title = "Info",
        Content = "Claim langsung lewat remote, gak pakai buka peti satu-satu.\nServer masih batasi jarak <b>~100 studs</b>, jadi kalau chest-nya jauh tetap teleport sebentar — tapi sekali teleport langsung nyikat semua chest di radius itu, terus balik ke posisi semula.",
    })

    v13:AddToggle({
        Title = "Enable Auto Claim",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl11.enabled = enabled

            if tbl11.thread then
                pcall(task.cancel, tbl11.thread)
                tbl11.thread = nil
            end

            if not enabled then
                tbl11.busy = false
                fn37("Stopped.")
                return
            end

            tbl11.thread = task.spawn(function()
                while tbl11.enabled do
                    fn41()
                    task.wait(1)
                end
            end)

            fn37("Active!")
        end,
    })

    v13:AddButton({
        Title = "Claim Now",
        Callback = function()
            if tbl11.busy then
                return
            end

            task.spawn(function()
                tbl11.enabled = true
                fn41()

                if not tbl11.thread then
                    tbl11.enabled = false
                end
            end)
        end,
    })

    local v14 = v4:AddSection("Craft Charm", false)

    local tbl12 = {
        enabled = false,
        loop = nil,
        selectedItem = nil,
        amount = 1,
        crafted = 0,
    }

    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local craftingItems = shared and ReplicatedStorage.Shared:FindFirstChild("CraftingItems")
    local v15 = fn(craftingItems)
    local tbl13 = {}
    local tbl14 = {}
    local tbl15 = {}

    local function fn42()
        tbl13 = {}
        tbl14 = {}
        tbl15 = {}

        pcall(function()
            if not v15 or not v15.Items then
                return
            end

            for i, item in ipairs(v15.Items) do
                if type(item) == "table" and item.Type == "Charms" and item.Name and not tbl14[item.Name] then
                    tbl14[item.Name] = item
                    tbl15[item.Name] = i
                    table.insert(tbl13, item.Name)
                end
            end

            table.sort(tbl13)
        end)

        return tbl13
    end

    fn42()

    v14:AddParagraph({
        Title = "Info",
        Content = "Auto Craft Charm otomatis start & confirm crafting.\nPilih charm dari dropdown lalu aktifkan toggle.\nPastikan bahan crafting tersedia di inventory.\nQuest Kohana Gatekeeper harus sudah selesai.",
    })

    local addDropdown = v14.AddDropdown
    local tbl16 = {Title = "Pilih Charm"}
    local options = #tbl13 > 0 and tbl13

    if not options then
        local tbl17 = {}
        options = tbl17
        tbl17[1] = "Loading..."
    end

    tbl16.Options = options
    tbl16.Default = nil

    tbl16.Callback = function(selectedItem)
        tbl12.selectedItem = selectedItem
    end

    local v16 = addDropdown(v14, tbl16)

    v14:AddInput({
        Title = "Jumlah Craft",
        Default = 1,
        Callback = function(amount)
            tbl12.amount = amount
        end,
    })

    v14:AddToggle({
        Title = "Enable Auto Craft",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl12.enabled then
                    return
                end

                if not tbl12.selectedItem then
                    lib:MakeNotify({
                        Title = "Auto Craft Charm",
                        Description = "Pilih charm dari dropdown dulu!",
                        Delay = 3,
                    })

                    return
                end

                tbl12.enabled = true
                tbl12.crafted = 0

                lib:MakeNotify({
                    Title = "Auto Craft Charm",
                    Description = "Mulai craft " .. tbl12.amount .. "x " .. tbl12.selectedItem,
                    Delay = 2,
                })

                tbl12.loop = task.spawn(function()
                    while tbl12.enabled and tbl12.crafted < tbl12.amount do
                        local selectedItem = tbl12.selectedItem
                        if not selectedItem then
                            task.wait(1)
                            continue
                        end

                        if not tbl14[selectedItem] then
                            lib:MakeNotify({
                                Title = "Auto Craft Charm",
                                Description = "Item tidak ditemukan: " .. tostring(selectedItem),
                                Delay = 3,
                            })

                            tbl12.enabled = false
                            break
                        end

                        local v17 = tbl15[selectedItem]

                        if not v17 then
                            lib:MakeNotify({
                                Title = "Auto Craft Charm",
                                Description = "Index craft tidak ketemu untuk " .. tostring(selectedItem) .. ". Tekan Refresh Charm List dulu.",
                                Delay = 4,
                            })

                            tbl12.enabled = false
                            break
                        end

                        local ok, result = pcall(function()
                            return obj.RF_StartCrafting:InvokeServer(v17)
                        end)

                        if ok and result then
                            task.wait(0.1)
                            if not tbl12.enabled then
                                break
                            end

                            local ok2, result2 = pcall(function()
                                return obj.RF_ConfirmCrafting:InvokeServer()
                            end)

                            if ok2 and result2 then
                                tbl12.crafted = tbl12.crafted + 1

                                lib:MakeNotify({
                                    Title = "Auto Craft Charm",
                                    Description = "[" .. tbl12.crafted .. "/" .. tbl12.amount .. "] Berhasil craft: " .. selectedItem,
                                    Delay = 2,
                                })

                                task.wait()
                            else
                                pcall(function()
                                    obj.RF_CancelCrafting:InvokeServer()
                                end)

                                lib:MakeNotify({
                                    Title = "Auto Craft Charm",
                                    Description = "Gagal confirm craft, mencoba lagi...",
                                    Delay = 2,
                                })

                                task.wait(1)
                            end

                            continue
                        end

                        lib:MakeNotify({
                            Title = "Auto Craft Charm",
                            Description = "Gagal start! Bahan kurang atau quest belum selesai.",
                            Delay = 3,
                        })

                        pcall(function()
                            obj.RF_CancelCrafting:InvokeServer()
                        end)

                        tbl12.enabled = false
                        break
                    end

                    if tbl12.enabled and tbl12.amount <= tbl12.crafted then
                        local makeNotify = lib.MakeNotify
                        local tbl17 = {Title = "Auto Craft Charm"}
                        local crafted = tbl12.crafted
                        local selectedItem = tbl12.selectedItem
                        local str2 = selectedItem or ""
                        tbl17.Description = "Selesai! Total craft: " .. crafted .. "x " .. str2
                        tbl17.Delay = 4
                        makeNotify(lib, tbl17)
                        tbl12.enabled = false
                    end
                end)
            else
                tbl12.enabled = false

                if tbl12.loop then
                    task.cancel(tbl12.loop)
                    tbl12.loop = nil
                end

                pcall(function()
                    obj.RF_CancelCrafting:InvokeServer()
                end)

                lib:MakeNotify({
                    Title = "Auto Craft Charm",
                    Description = "Dihentikan. Tercrafted: " .. tbl12.crafted .. "/" .. tbl12.amount,
                    Delay = 3,
                })
            end
        end,
    })

    v14:AddButton({
        Title = "Refresh Charm List",
        Callback = function()
            fn42()

            if v16 and v16.SetOptions then
                local setOptions = v16.SetOptions
                local flag5 = #tbl13 > 0 and tbl13

                if not flag5 then
                    local tbl17 = {}
                    flag5 = tbl17
                    tbl17[1] = "No Items Found"
                end

                setOptions(v16, flag5)
            end

            lib:MakeNotify({
                Title = "Auto Craft Charm",
                Description = "List diperbarui: " .. #tbl13 .. " charm.",
                Delay = 2,
            })
        end,
    })

    local v17 = v4:AddSection("Atlantis Machine")

    tbl3 = {
        enabled = false,
        thread = nil,
        delay = 0.5,
        savedPos = nil,
        selling = false,
        replion = nil,
        dataReplion = nil,
        config = nil,
        machinePos = nil,
    }

    local function fn43()
        if tbl3.replion and tbl3.dataReplion and tbl3.config then
            return true
        end

        local ok = pcall(function()
            local client = fn3().Client
            local v18 = fn(ReplicatedStorage.Shared.AtlantisMachineConfig)
            tbl3.config = v18
            local v19 = client:WaitReplion(tbl3.config.Channel)
            tbl3.replion = v19
            local Data = client:WaitReplion("Data")
            tbl3.dataReplion = Data
        end)

        local config = ok and tbl3.replion and tbl3.dataReplion and tbl3.config
        return config
    end

    local function fn44()
        if tbl3.machinePos then
            return tbl3.machinePos
        end

        local ok, result = pcall(function()
            local underwaterCity = workspace.Islands:FindFirstChild("Underwater City")
            local atlantisMachine = underwaterCity and underwaterCity:FindFirstChild("Atlantis Machine")
            local basePart = atlantisMachine and atlantisMachine:FindFirstChildWhichIsA("BasePart")
            local position = basePart and basePart.Position
            return position
        end)

        if ok and result then
            local cframe = CFrame.new(result + Vector3.new(0, 3, 0))
            tbl3.machinePos = cframe
        end

        return tbl3.machinePos
    end

    local function fn45()
        local ok, result = pcall(function()
            local CurrentPoints = tbl3.replion:Get("CurrentPoints")
            local n2 = CurrentPoints or 0
            return n2
        end)

        local n2 = ok and result or 0
        return n2
    end

    local function fn46()
        local maxPoints = tbl3.config.MaxPoints
        local n2 = maxPoints or 1000
        return n2
    end

    local function fn47()
        local ok, result = pcall(function()
            return tbl3.replion:Get("ActiveBoostId")
        end)

        if not ok or not result or result == "" then
            return false
        end

        local ok2, result2 = pcall(function()
            local ActiveBoostEndsAt = tbl3.replion:Get("ActiveBoostEndsAt")
            local n2 = ActiveBoostEndsAt or 0
            return n2
        end)

        local flag5 = ok2 and result2 and workspace:GetServerTimeNow() < result2
        return flag5
    end

    local function fn48()
        local ok, result = pcall(function()
            local v18 = tbl3.dataReplion:Get({"Inventory", "Items"})
            local tbl17 = v18 or {}
            return tbl17
        end)

        if not ok then
            return {}
        end

        local ok2, result2 = pcall(function()
            return tbl3.config:BuildEligibleEntries(result)
        end)

        local tbl17 = ok2 and result2 or {}
        return tbl17
    end

    local function fn49()
        local v18 = fn48()
        local n2 = 0

        for i, v19 in ipairs(v18) do
            local points = v19.Points
            local n3 = points or 0
            n2 = n2 + n3
        end

        return n2, v18
    end

    local function fn50()
        if not tbl3.savedPos then
            return
        end

        for i = 1, 5 do
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.CFrame = tbl3.savedPos
            end

            task.wait(0.15)
        end
    end

    local function fn51()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end

        if flag3 then
            return
        end
        tbl3.savedPos = humanoidRootPart.CFrame
        local v18 = fn44()
        if not v18 then
            return
        end

        for i = 1, 3 do
            humanoidRootPart.CFrame = v18
            task.wait(0.15)
        end

        task.wait(0.3)
        tbl3.selling = true

        for i = 1, 3 do
            local ok, result = pcall(function()
                return obj.RF_SacrificeAtlantisSellAll:InvokeServer()
            end)

            if ok and result and result.Success then
                lib:MakeNotify({
                    Title = "Atlantis",
                    Description = "Sacrifice All berhasil!",
                    Delay = 2,
                })

                break
            end

            task.wait(1)
        end

        task.wait(0.3)
        tbl3.selling = false
        fn50()
    end

    v17:AddParagraph({
        Title = "Info",
        Content = "Otomatis sacrifice ikan ke Atlantis Machine di Underwater City.\n• Kumpulkan poin dulu dari hasil mancing\n• Kalau inventory sudah cukup untuk isi mesin → baru teleport\n• Sacrifice sekaligus → langsung balik ke posisi mancing\n• Boost sedang aktif → idle, tunggu selesai\n• Mesin penuh → idle, cek ulang tiap 10 detik\n• Toggle OFF → langsung balik ke posisi terakhir",
    })

    v17:AddToggle({
        Title = "Auto Atlantis Machine",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl3.enabled = enabled

            if tbl3.thread then
                task.cancel(tbl3.thread)
                tbl3.thread = nil
            end

            if not enabled then
                tbl3.selling = false
                fn50()
                tbl3.savedPos = nil
                return
            end

            local thread = task.spawn(function()
                if not fn43() then
                    return
                end

                while tbl3.enabled do
                    if flag3 then
                        task.wait(1)
                    elseif fn47() then
                        task.wait(10)
                    else
                        local v18 = fn45()
                        local n2 = fn46() - v18

                        if n2 <= 0 then
                            task.wait(10)
                        elseif fn49() < n2 then
                            task.wait(5)
                        else
                            fn51()
                            task.wait(3)
                        end
                    end
                end
            end)

            tbl3.thread = thread
        end,
    })

    v17:AddButton({
        Title = "Sacrifice Now",
        Callback = function()
            task.spawn(function()
                if not fn43() then
                    return
                end
                fn51()
            end)
        end,
    })

    local v18 = v4:AddSection("Buy Charm", false)

    local tbl17 = {
        charmList = {},
        selectedId = nil,
        selectedName = nil,
        selectedPrice = nil,
        amount = 1,
        delay = 0.5,
        isBuying = false,
        loaded = false,
        pending = nil,
    }

    local v19 = v18:AddParagraph({Title = "Charm Info", Content = "Memuat daftar charm..."})
    local fn52 = nil

    local v20 = v18:AddDropdown({
        Title = "Charm Type",
        Options = {"Memuat..."},
        Default = "Memuat...",
        Callback = function(arg)
            local pending = type(arg) == "table" and arg[1] or arg

            if not tbl17.loaded then
                tbl17.pending = pending

                if fn52 then
                    task.spawn(fn52)
                end

                return
            end

            for i, v20 in ipairs(tbl17.charmList) do
                if v20.Name == pending then
                    tbl17.selectedId = v20.Id
                    tbl17.selectedName = v20.Name
                    tbl17.selectedPrice = v20.Price
                    v19:SetContent("Name: " .. v20.Name .. "\nPrice: " .. tostring(v20.Price) .. " coins")
                    break
                end
            end
        end,
    })

    fn52 = function()
        v19:SetContent("Memuat daftar charm...")

        pcall(function()
            local charms = ReplicatedStorage:FindFirstChild("Charms")
            local v21 = charms

            if not charms then
                local ok, result = pcall(function()
                    return ReplicatedStorage:WaitForChild("Charms", 5)
                end)

                if ok and result then
                    v21 = result
                end
            end

            if not v21 then
                return
            end
            local charmList = {}

            for i, child in ipairs(v21:GetChildren()) do
                if child:IsA("ModuleScript") then
                    local ok, result = pcall(function()
                        return require(child)
                    end)

                    if ok and type(result) == "table" and result.Data then
                        local price = result.Price
                        local price2 = price or 0

                        if price2 > 0 then
                            local insert = table.insert
                            local tbl18 = {}
                            local v22 = tostring
                            local name = result.Data.Name
                            local name2 = name or child.Name
                            tbl18.Name = v22(name2)
                            tbl18.Id = result.Data.Id
                            tbl18.Price = price2
                            insert(charmList, tbl18)
                        end
                    end
                end
            end

            table.sort(charmList, function(arg, arg2)
                local name = arg.Name
                local str2 = name or ""
                local name2 = arg2.Name
                local str3 = name2 or ""
                local flag5 = str2 < str3
                return flag5
            end)

            tbl17.charmList = charmList
            tbl17.loaded = true
            local tbl18 = {}

            for i, v22 in ipairs(charmList) do
                table.insert(tbl18, v22.Name)
            end

            if #tbl18 > 0 then
                if v20 and v20.SetOptions then
                    v20:SetOptions(tbl18)
                end

                local pending = tbl17.pending
                local name = pending or charmList[1].Name
                local v22 = charmList[1]

                for i, v23 in ipairs(charmList) do
                    if v23.Name == name then
                        v22 = v23
                        break
                    end
                end

                tbl17.selectedId = v22.Id
                tbl17.selectedName = v22.Name
                tbl17.selectedPrice = v22.Price

                if v20 then
                    pcall(function()
                        v20:SetValue(v22.Name)
                    end)
                end

                v19:SetContent("Name: " .. v22.Name .. "\nPrice: " .. tostring(v22.Price) .. " coins")
            else
                v19:SetContent("Tidak ada charm ditemukan di game.")
            end
        end)
    end

    local function fn53()
        if not tbl17.loaded then
            fn52()
        end
    end

    local container = v18._container
    local v21 = container or v18

    v18:AddInput({
        Title = "Amount",
        Default = "1",
        Callback = function(arg)
            local num = tonumber(arg)

            if num and num > 0 then
                tbl17.amount = math.floor(num)
            end
        end,
    })

    local function fn54()
        local tbl18 = {}

        pcall(function()
            if v21 and v21.GetDescendants then
                for i, descendant in ipairs(v21:GetDescendants()) do
                    if descendant:IsA("TextBox") then
                        table.insert(tbl18, descendant)
                    end
                end
            end
        end)

        return tbl18
    end

    local function fn55()
        local v22 = fn54()[1]
        local amount = tbl17.amount
        local n2 = amount or 1

        if v22 then
            local num = tonumber(v22.Text)

            if num and num > 0 then
                n2 = math.floor(num)
            end
        end

        return n2
    end

    v18:AddButton({
        Title = "Buy Charm",
        Callback = function()
            fn53()
            if tbl17.isBuying then
                return
            end

            if not tbl17.selectedId then
                v19:SetContent("Pilih charm terlebih dahulu!")
                return
            end
            local rfPurchaseCharm = obj.RF_PurchaseCharm

            if not rfPurchaseCharm then
                lib:MakeNotify({
                    Title = "Auto Buy Charm",
                    Description = "Remote RF_PurchaseCharm tidak ditemukan!",
                    Delay = 3,
                })

                return
            end

            local v22 = fn55()
            local selectedId = tbl17.selectedId
            local selectedName = tbl17.selectedName
            local str2 = selectedName or "Unknown"
            tbl17.amount = v22
            tbl17.delay = 0.1
            tbl17.isBuying = true

            lib:MakeNotify({
                Title = "Auto Buy Charm",
                Description = "Mulai membeli " .. v22 .. "x " .. str2 .. "...",
                Delay = 3,
            })

            task.spawn(function()
                local n2, n3, n4, n5, n6, n7, n8, n9, n10, makeNotify, tbl18, color, color2, v23, setContent, v24, v25, selectedPrice, color3, n11
                n11 = 1

                while true do
                    if n11 == 1 then
                        n2 = 0
                        n3 = 985418121
                        n4 = 856897077
                        n5 = 1030922934
                        n6 = 0
                        n7 = nil
                        n8 = v22 + 0
                        n9 = 0
                        n11 = 2
                    elseif n11 == 2 then
                        n10 = n9 + 1

                        if n10 <= n8 then
                            n11 = 3
                        else
                            n11 = 8
                        end
                    elseif n11 == 3 then
                        n9 = n10

                        if tbl17.isBuying then
                            n11 = 4
                        else
                            n11 = 8
                        end
                    elseif n11 == 4 then
                        task.spawn(function()
                            n7 = 1001851221

                            local ok, result = pcall(function()
                                if type(rfPurchaseCharm) == "table" and type(rfPurchaseCharm.InvokeServer) == "function" then
                                    local response = rfPurchaseCharm:InvokeServer(selectedId)
                                    if response and type(response.await) == "function" then
                                        return response:await()
                                    end
                                    return response
                                end

                                if typeof(rfPurchaseCharm) == "Instance" and rfPurchaseCharm:IsA("RemoteFunction") then
                                    return rfPurchaseCharm:InvokeServer(selectedId)
                                end
                            end)

                            if ok and result ~= false then
                                n2 = n2 + 1
                            else
                                n6 = n6 + 1
                            end
                        end)

                        if n10 % 5 ~= 0 and n10 ~= v22 then
                            n11 = 6
                        else
                            n11 = 5
                        end
                    elseif n11 == 5 then
                        v19:SetContent("Buying: " .. str2 .. "\nProgress: " .. n10 .. "/" .. v22 .. " (OK: " .. n2 .. ", Fail: " .. n6 .. ")")
                        n11 = 6
                    elseif n11 == 6 then
                        if n10 < v22 and tbl17.isBuying then
                            n11 = 7
                        else
                            n11 = 2
                        end
                    elseif n11 == 7 then
                        task.wait(0.1)
                        n11 = 2
                    elseif n11 == 8 then
                        tbl17.isBuying = false
                        makeNotify = lib.MakeNotify

                        tbl18 = {
                            Title = "Auto Buy Charm",
                            Description = "Selesai! Berhasil: " .. n2 .. "/" .. v22 .. " " .. str2,
                        }

                        if n2 > 0 then
                            n11 = 10
                        else
                            n11 = 9
                        end
                    elseif n11 == 9 then
                        color = false
                        n11 = 11
                    elseif n11 == 10 then
                        color = true
                        n11 = 11
                    elseif n11 == 11 then
                        if color then
                            n11 = 12
                        else
                            n11 = 15
                        end
                    elseif n11 == 12 then
                        color2 = Color3.fromRGB(34, 197, 94)

                        if color2 then
                            n11 = 13
                        else
                            n11 = 14
                        end
                    elseif n11 == 13 then
                        tbl18.Color = color2
                        tbl18.Delay = 4
                        makeNotify(lib, tbl18)
                        v23 = v19
                        setContent = v19.SetContent
                        v24 = str2
                        v25 = tostring
                        selectedPrice = tbl17.selectedPrice
                        n11 = 19
                    elseif n11 == 14 then
                        color3 = Color3.fromRGB
                        n11 = 18
                    elseif n11 == 15 then
                        if color then
                            n11 = 16
                        else
                            n11 = 17
                        end
                    elseif n11 == 16 then
                        tbl18.Color = color
                        tbl18.Delay = 4
                        makeNotify(lib, tbl18)
                        v23 = v19
                        setContent = v19.SetContent
                        v24 = str2
                        v25 = tostring
                        selectedPrice = tbl17.selectedPrice
                        n11 = 19
                    elseif n11 == 17 then
                        color3 = Color3.fromRGB
                        n11 = 18
                    elseif n11 == 18 then
                        tbl18.Color = color3(255, 80, 80)
                        tbl18.Delay = 4
                        makeNotify(lib, tbl18)
                        v23 = v19
                        setContent = v19.SetContent
                        v24 = str2
                        v25 = tostring
                        selectedPrice = tbl17.selectedPrice
                        n11 = 19
                    elseif n11 == 19 then
                        if selectedPrice then
                            n11 = 21
                        else
                            n11 = 20
                        end
                    elseif n11 == 20 then
                        selectedPrice = "?"
                        n11 = 21
                    elseif n11 == 21 then
                        setContent(v23, "Name: " .. v24 .. "\nPrice: " .. v25(selectedPrice) .. " coins\nLast Buy: " .. n2 .. "/" .. v22 .. " berhasil")
                        return
                    end
                end
            end)
        end,
    })

    v18:AddButton({
        Title = "Stop Buying",
        Callback = function()
            tbl17.isBuying = false
        end,
    })

    v18:AddButton({
        Title = "Refresh Charm List [Buy]",
        Callback = function()
            if tbl17.isBuying then
                return
            end
            task.spawn(fn52)
        end,
    })

    local v22 = v4:AddSection("Use Potion", false)
    local tbl18 = {enabled = false, task = nil, selected = {}}
    local tbl19 = {}
    local tbl20 = {}
    local v23 = pairs
    local v24 = fn(ReplicatedStorage:FindFirstChild("Potions"))
    local tbl21 = v24 or {}

    for k, v25 in v23(tbl21) do
        local data = type(v25) == "table" and v25.Data
        local moduleScript = v25 and v25._moduleScript

        if type(data) == "table" and data.Id and data.Name and not v25.Infinite and (not moduleScript or not moduleScript.Name:find("Totem")) and not data.Name:find("Totem") and (v25.VFX or v25.InstantWeather or data.Name:find("Potion")) then
            tbl19[data.Name] = data.Id
            tbl20[#tbl20 + 1] = data.Name
        end
    end

    table.sort(tbl20, function(arg, arg2)
        local flag5 = tbl19[arg] < tbl19[arg2]
        return flag5
    end)

    v22:AddDropdown({
        Title = "Select Potions",
        Options = tbl20,
        Multi = true,
        Default = {},
        Callback = function(arg)
            local selected = type(arg) == "table" and arg or {}
            tbl18.selected = selected
        end,
    })

    v22:AddToggle({
        Title = "Auto Use Potions",
        Default = false,
        Callback = function(enabled)
            tbl18.enabled = enabled

            if tbl18.task then
                pcall(task.cancel, tbl18.task)
                tbl18.task = nil
            end

            if not enabled then
                return
            end

            tbl18.task = task.spawn(function()
                while tbl18.enabled do
                    local v25 = fn2()
                    local v26 = ipairs
                    local selected = v25 and tbl18.selected or {}
                    local v27, v28, v29 = v26(selected)
                    local v30 = v29
                    local v31 = v27
                    local v32 = v28

                    while true do
                        local v33, v34 = v31(v32, v30)
                        if v33 == nil then
                            break
                        end
                        v30 = v33

                        if v34 == "Cave Crystal" then
                            pcall(function()
                                obj.RF_ConsumeCaveCrystal:InvokeServer()
                            end)
                        elseif tbl19[v34] then
                            local v35 = ipairs
                            local v36 = v25:Get({"Inventory", "Potions"})
                            local tbl22 = v36 or {}

                            for k, v37 in v35(tbl22) do
                                if v37.Id == tbl19[v34] then
                                    pcall(function()
                                        obj.RF_ConsumePotion:InvokeServer(v37.UUID, 1)
                                    end)

                                    break
                                end
                            end

                            v30 = v33
                        end
                    end

                    task.wait(1)
                end
            end)
        end,
    })

    local v25 = v4:AddSection("Use Orb", false)

    local tbl22 = {
        0,
        30,
        -30,
        60,
        -60,
        90,
        -90,
        120,
        -120,
        150,
        -150,
        180,
    }

    local tbl23 = {14, 22, 32, 45, 60, 70}
    local tbl24 = {enabled = false, thread = nil, thrown = 0}
    local str2 = ""
    local v26 = nil

    local function fn56(arg, arg2)
        local makeNotify = lib.MakeNotify
        local tbl25 = {Title = "Auto Orb", Description = arg}
        local delay = arg2 or 3
        tbl25.Delay = delay
        makeNotify(lib, tbl25)
    end

    local tbl25 = {
        ready = false,
        maxDist = 75,
        clearance = 5,
        container = "BathBombPools",
    }

    local function fn57()
        if tbl25.ready then
            return tbl25
        end

        pcall(function()
            tbl25.data = fn2()
            tbl25.item = fn(ReplicatedStorage.Shared.ItemUtility)
            tbl25.area = fn(ReplicatedStorage.Shared.AreaUtility)
            tbl25.ray = fn(ReplicatedStorage.Shared.RaycastUtility)
            local v27 = fn(ReplicatedStorage.Shared.BathBombConfig)
            local tbl26 = v27 or {}
            local limits = tbl26.Limits
            local tbl27 = limits or {}
            local poolContainerName = tbl26.PoolContainerName
            local container2 = poolContainerName or tbl25.container
            tbl25.container = container2
            local maximumThrowDistance = tbl27.MaximumThrowDistance
            local maxDist = maximumThrowDistance or tbl25.maxDist
            tbl25.maxDist = maxDist
            local placementClearance = tbl27.PlacementClearance
            local clearance = placementClearance or tbl25.clearance
            tbl25.clearance = clearance
        end)

        local data = tbl25.data
        local ray = data and tbl25.item and tbl25.area and tbl25.ray
        local ready = ray ~= nil
        tbl25.ready = ready
        return tbl25
    end

    local function fn58()
        local tbl26 = {}
        local v27 = fn57()
        if not v27.ready then
            return tbl26
        end

        pcall(function()
            local v28 = pairs
            local v29 = v27.data:Get({"Inventory", "Items"})
            local tbl27 = v29 or {}

            for k, v30 in v28(tbl27) do
                local itemData = v27.item:GetItemData(v30.Id)

                if itemData and itemData.BathBomb and itemData.Data and itemData.Data.Type == "Gears" then
                    table.insert(tbl26, {name = itemData.Data.Name, item = v30, info = itemData})
                end
            end
        end)

        return tbl26
    end

    local function fn59()
        local tbl26 = {}
        local tbl27 = {}

        for i, v27 in ipairs(fn58()) do
            if not tbl27[v27.name] then
                tbl27[v27.name] = true
                table.insert(tbl26, v27.name)
            end
        end

        table.sort(tbl26)
        return tbl26
    end

    local function fn60(arg)
        for i, v27 in ipairs(fn58()) do
            if v27.name == arg then
                local quantity = v27.item.Quantity
                local n2 = quantity or 1
                if n2 > 0 then
                    return v27
                end
            end
        end

        return nil
    end

    local function fn61()
        local v27 = workspace:FindFirstChild(fn57().container)
        local children = v27 and v27:IsA("Folder") and v27:GetChildren() or {}
        return children
    end

    local function fn62()
        for i, v27 in ipairs(fn61()) do
            if v27:GetAttribute("OwnerUserId") == localPlayer.UserId and v27:GetAttribute("State") ~= "Expired" then
                return v27
            end
        end

        return nil
    end

    local function fn63(arg, arg2)
        for i, v27 in ipairs(fn61()) do
            local attribute = v27:GetAttribute("Position")
            local attribute2 = v27:GetAttribute("Radius")

            if v27:GetAttribute("State") ~= "Expired" and typeof(attribute) == "Vector3" and typeof(attribute2) == "number" then
                local n2 = arg2 + attribute2 + fn57().clearance
                if (arg - attribute).Magnitude < n2 then
                    return true
                end
            end
        end

        return false
    end

    local function fn64()
        local filterDescendantsInstances = {}

        pcall(function()
            filterDescendantsInstances = fn57().ray:getFilteredTargets(localPlayer)
            local boat = fn57().ray:GetBoat(localPlayer)

            if boat then
                table.insert(filterDescendantsInstances, boat)
            end
        end)

        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = filterDescendantsInstances
        raycastParams.IgnoreWater = true
        raycastParams.RespectCanCollide = false
        return raycastParams
    end

    local function fn65(arg)
        local v27 = fn57()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil, "Character belum siap"
        end
        local v28 = fn64()
        local cFrame = humanoidRootPart.CFrame
        local str3 = "Tidak ada air yang valid di sekitar"
        local v29, v30, v31 = ipairs(tbl23)
        local v32 = v31
        local v33 = v29
        local v34 = v30

        while true do
            local v35, v36 = v33(v34, v32)
            if v35 == nil then
                break
            end

            for i, v37 in ipairs(tbl22) do
                local lookVector = (cFrame * CFrame.Angles(0, math.rad(v37), 0)).LookVector
                local hit = workspace:Raycast(cFrame.Position + lookVector * v36 + Vector3.new(0, 8, 0), Vector3.new(0, -220, 0), v28)
                local instance = hit and hit.Instance
                local flag5 = false

                if instance and instance:IsA("BasePart") then
                    pcall(function()
                        local flag6 = v27.area:ResolveFishingArea(instance) ~= nil
                        flag5 = flag6
                    end)
                end

                if not flag5 then
                    continue
                end
                local vector = Vector3.new(hit.Position.X, instance.Position.Y + instance.Size.Y / 2, hit.Position.Z)
                local flag6 = false

                pcall(function()
                    local flag7 = v27.area:ValidateFishingArea(instance, v27.data) == true
                    flag6 = flag7
                end)

                if not flag6 then
                    str3 = "Area memancing belum terbuka"
                    continue
                end

                if v27.maxDist < (vector - humanoidRootPart.Position).Magnitude then
                    str3 = "Air terdekat di luar jangkauan lempar"
                    continue
                end

                if not fn63(vector, arg) then
                    return vector
                end
                str3 = "Ada pool lain yang terlalu dekat"
            end

            v32 = v35
        end

        return nil, str3
    end

    local function fn66()
        local ok, result, result2 = pcall(function()
            local data = fn57().data
            return data:Get("EquippedId"), data:Get("EquippedType")
        end)

        if not ok then
            return nil, nil
        end
        return result, result2
    end

    local function fn67(arg)
        local ok, result = pcall(function()
            return fn57().data:Get("EquippedItems")
        end)

        if not ok then
            return nil
        end
        local v27 = pairs
        local tbl26 = result or {}

        for k, v28 in v27(tbl26) do
            if v28 == arg then
                return k
            end
        end

        return nil
    end

    local function fn68(arg)
        if not obj.RE_EquipItem or not obj.RF_EquipToolFromHotbar then
            return false, "Remote equip tidak tersedia"
        end
        local v27 = fn67(arg)

        if not v27 then
            pcall(function()
                obj.RE_EquipItem:FireServer(arg, "Gears")
            end)

            local n2 = os.clock() + 5

            while os.clock() < n2 and not v27 do
                if not tbl24.enabled then
                    return false, "Dimatikan"
                end
                task.wait(0.1)
                v27 = fn67(arg)
            end

            if not v27 then
                return false, "Orb tidak masuk ke hotbar"
            end
        end

        local n2 = os.clock() + 6

        while os.clock() < n2 do
            if not tbl24.enabled then
                return false, "Dimatikan"
            end

            pcall(function()
                obj.RF_EquipToolFromHotbar:FireServer(v27)
            end)

            local n3 = os.clock() + 1

            while os.clock() < n3 do
                local v28, v29 = fn66()
                if v28 == arg and v29 == "Gears" then
                    return true
                end
                task.wait(0.1)
            end

            local v28 = fn67(arg)
            local v29 = v28 or v27
            v27 = v29
        end

        return false, "Gagal memegang orb"
    end

    local function fn69(arg)
        if not obj.RF_EquipToolFromHotbar then
            return
        end
        local flag5 = arg and arg ~= "" and fn67(arg) or nil

        pcall(function()
            local rfEquipToolFromHotbar = obj.RF_EquipToolFromHotbar
            local fireServer = rfEquipToolFromHotbar.FireServer
            local n2 = flag5 or 1
            fireServer(rfEquipToolFromHotbar, n2)
        end)
    end

    local function fn70(arg)
        if not obj.RF_ThrowBathBomb then
            return false, "Remote throw tidak tersedia"
        end
        local bathBomb = arg.info.BathBomb
        local radius = bathBomb and arg.info.BathBomb.Radius or 12
        local v27, v28 = fn65(radius)
        if not v27 then
            return false, v28
        end
        local v29 = fn66()
        _G.SetOrbThrowing(true)

        local function fn71(arg2, arg3)
            fn69(v29)
            _G.SetOrbThrowing(false)
            return arg2, arg3
        end

        pcall(function()
            obj.RF_CancelFishingInputs:InvokeServer()
        end)

        task.wait(1.1)
        if not tbl24.enabled then
            return fn71(false, "Dimatikan")
        end
        local v30, v31 = fn68(arg.item.UUID)
        if not v30 then
            return fn71(false, v31)
        end
        local v32 = fn65(radius)
        local v33 = v32 or v27
        local v34 = v33
        local v35, v36 = fn66()
        if v35 ~= arg.item.UUID or v36 ~= "Gears" then
            return fn71(false, "Orb tertukar sebelum dilempar")
        end

        local ok, result = pcall(function()
            return obj.RF_ThrowBathBomb:InvokeServer(arg.item.UUID, v34)
        end)

        if not ok then
            return fn71(false, "Remote error saat melempar")
        end

        if typeof(result) ~= "table" then
            return fn71(false, "Balasan server tidak dikenal")
        end

        if result.Success == true then
            return fn71(true, nil)
        end
        local errorMessage = result.ErrorMessage
        local str3 = errorMessage or "Ditolak server"
        return fn71(false, str3)
    end

    local function fn71(arg)
        while tbl24.enabled and arg.Parent do
            if arg:GetAttribute("State") == "Expired" then
                return
            end
            local attribute = arg:GetAttribute("ExpiresAt")
            local n2 = typeof(attribute) == "number" and attribute - workspace:GetServerTimeNow() or nil
            if n2 and n2 <= 0 then
                return
            end
            task.wait(2)
        end
    end

    local v27 = v25:AddDropdown({
        Title = "Pilih Orb",
        Options = fn59(),
        Default = "",
        NoSave = true,
        Callback = function(arg)
            local str3 = arg or ""
            str2 = str3
        end,
    })

    v25:AddButton({
        Title = "Refresh Orb List",
        Callback = function()
            local v28 = fn59()

            pcall(function()
                v27:SetOptions(v28)
            end)

            fn56(string.format("List diperbarui: %d jenis orb.", #v28), 2)
        end,
    })

    v26 = v25:AddToggle({
        Title = "Enable Auto Use Orb",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl24.enabled = enabled

            if tbl24.thread then
                pcall(task.cancel, tbl24.thread)
                tbl24.thread = nil
            end

            _G.SetOrbThrowing(false)
            if not enabled then
                fn56("Stopped.", 2)
                return
            end

            local function fn72(arg)
                tbl24.enabled = false
                fn56(arg, 3)

                task.defer(function()
                    pcall(function()
                        v26:SetValue(false)
                    end)
                end)
            end

            if str2 == "" then
                return fn72("Pilih orb dulu!")
            end

            if not fn57().ready then
                return fn72("Gagal memuat data game, coba lagi.")
            end
            fn56("Active!", 2)

            tbl24.thread = task.spawn(function()
                local v28 = nil

                local function fn73(arg)
                    if v28 == arg then
                        return
                    end
                    v28 = arg
                    fn56(arg, 3)
                end

                while tbl24.enabled do
                    local v29 = fn62()

                    if v29 then
                        fn71(v29)
                        task.wait(1)
                    else
                        local v30 = fn60(str2)

                        if v30 then
                            local v31, v32 = fn70(v30)

                            if v31 then
                                v28 = nil
                                tbl24.thrown = tbl24.thrown + 1
                                fn56(string.format("%s #%d dilempar!", str2, tbl24.thrown), 3)
                                task.wait(2)
                            else
                                fn73("Gagal: " .. tostring(v32))
                                task.wait(3)
                            end
                        else
                            fn73(str2 .. " sudah habis di inventory.")
                            task.wait(5)
                        end
                    end
                end
            end)
        end,
    })

    local v28 = v4:AddSection("Enchant Features", false)

    local tbl26 = {
        enabled = false,
        task = nil,
        statusTask = nil,
        rollCount = 0,
        targetEnchantId = 10,
        targetEnchantName = "XPerienced I",
        enchantType = 1,
        enchantStoneItemId = 10,
        waitingForUpdate = false,
        listenerConnected = false,
        replionUpdateConn = nil,
        atAltar = false,
        savedPos = nil,
        lastRolledEnchantId = nil,
        rollGeneration = 0,
    }

    local tbl27 = {}
    local tbl28 = {}

    pcall(function()
        local enchants = ReplicatedStorage:FindFirstChild("Enchants")
        local v29 = enchants

        if not enchants then
            local ok, result = pcall(function()
                return ReplicatedStorage:WaitForChild("Enchants", 5)
            end)

            if ok and result then
                v29 = result
            end
        end

        if not v29 then
            return
        end

        for i, child in ipairs(v29:GetChildren()) do
            if child:IsA("ModuleScript") then
                local ok, result = pcall(function()
                    return require(child)
                end)

                if ok and result and result.Data and result.Data.Name and result.Data.Id then
                    tbl27[result.Data.Name] = result.Data.Id
                    table.insert(tbl28, result.Data.Name)
                end
            end
        end

        table.sort(tbl28)
    end)

    local v29 = nil

    localPlayer.CharacterAdded:Connect(function()
        tbl26.atAltar = false
        tbl26.savedPos = nil
        v29 = nil
    end)

    local function fn72()
        if not v29 then
            return nil
        end
        local enchantId2 = nil

        pcall(function()
            local EquippedItems = v29:Get("EquippedItems")
            local tbl29 = EquippedItems or {}
            local v30 = v29:Get({"Inventory", "Fishing Rods"})
            local tbl30 = v30 or {}
            local v31, v32, v33 = pairs(tbl29)
            local v34 = v33
            local v35 = v31
            local v36 = v32

            while true do
                local v37, v38 = v35(v36, v34)
                if v37 == nil then
                    break
                end

                for i, v39 in ipairs(tbl30) do
                    if v39.UUID == v38 then
                        if v39.Metadata then
                            if tbl26.enchantType == 2 then
                                enchantId2 = v39.Metadata.EnchantId2
                            else
                                enchantId2 = v39.Metadata.EnchantId
                            end
                        end

                        return
                    end
                end

                v34 = v37
            end
        end)

        return enchantId2
    end

    local v30 = v28:AddParagraph({
        Title = "Enchant Status",
        Content = "Current Rod : None\nEnchant 1 : None\nEnchant 2 : None\nEnchant Stones Left : 0",
    })

    local function fn73()
        if tbl26.statusTask then
            pcall(function()
                task.cancel(tbl26.statusTask)
            end)

            tbl26.statusTask = nil
        end

        tbl26.statusTask = task.spawn(function()
            local ItemUtility = nil

            pcall(function()
                ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
            end)

            while tbl26.enabled do
                task.wait(2)

                if v29 and ItemUtility then
                    pcall(function()
                        local str3 = "None"
                        local str4 = "None"
                        local str5 = "None"
                        local n2 = 0
                        local EquippedItems = v29:Get("EquippedItems")
                        local tbl29 = EquippedItems or {}
                        local v31 = v29:Get({"Inventory", "Fishing Rods"})
                        local tbl30 = v31 or {}
                        local v32, v33, v34 = pairs(tbl29)
                        local v35 = v34
                        local v36 = v32
                        local v37 = v33

                        while true do
                            local v38, v39 = v36(v37, v35)
                            if v38 == nil then
                                break
                            end

                            for i, v40 in ipairs(tbl30) do
                                if v40.UUID == v39 then
                                    local itemData = ItemUtility:GetItemData(v40.Id)
                                    local name = itemData and itemData.Data.Name or "None"
                                    str3 = name

                                    if v40.Metadata then
                                        if v40.Metadata.EnchantId then
                                            local enchantData = ItemUtility:GetEnchantData(v40.Metadata.EnchantId)

                                            if enchantData and enchantData.Data and enchantData.Data.Name then
                                                str4 = enchantData.Data.Name
                                            end
                                        end

                                        if v40.Metadata.EnchantId2 then
                                            local enchantData = ItemUtility:GetEnchantData(v40.Metadata.EnchantId2)

                                            if enchantData and enchantData.Data and enchantData.Data.Name then
                                                str5 = enchantData.Data.Name
                                            end
                                        end
                                    end

                                    break
                                end
                            end

                            v35 = v38
                        end

                        for k, v38 in pairs(v29:GetExpect({"Inventory", "Items"})) do
                            if v38.Id == tbl26.enchantStoneItemId then
                                n2 = n2 + 1
                            end
                        end

                        v30:SetContent(string.format("Current Rod : %s\nEnchant 1 : %s\nEnchant 2 : %s\nEnchant Stones Left : %d", str3, str4, str5, n2))
                    end)
                end
            end

            tbl26.statusTask = nil
        end)
    end

    local function fn74()
        if tbl26.replionUpdateConn then
            pcall(function()
                tbl26.replionUpdateConn:Disconnect()
            end)

            tbl26.replionUpdateConn = nil
        end

        tbl26.listenerConnected = false
    end

    local function fn75()
        if tbl26.listenerConnected and tbl26.replionUpdateConn then
            return
        end

        pcall(function()
            local update = ReplicatedStorage.Packages._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Update

            if update and not tbl26.replionUpdateConn then
                tbl26.replionUpdateConn = update.OnClientEvent:Connect(function(arg, arg2, arg3)
                    if not tbl26.enabled or not tbl26.waitingForUpdate then
                        return
                    end

                    if not arg2 or type(arg2) ~= "table" or #arg2 < 4 then
                        return
                    end

                    if arg2[1] ~= "Inventory" or arg2[2] ~= "Fishing Rods" or arg2[4] ~= "Metadata" then
                        return
                    end
                    local enchantId2 = nil

                    if #arg2 >= 5 then
                        local v31 = arg2[5]

                        if tbl26.enchantType == 2 and v31 == "EnchantId2" then
                            enchantId2 = arg3
                        elseif tbl26.enchantType ~= 2 and v31 == "EnchantId" then
                            enchantId2 = arg3
                        end
                    end

                    if not enchantId2 and type(arg3) == "table" then
                        if tbl26.enchantType == 2 then
                            enchantId2 = arg3.EnchantId2
                        else
                            enchantId2 = arg3.EnchantId
                        end
                    elseif not enchantId2 and type(arg3) == "number" then
                        enchantId2 = arg3
                    end

                    if not enchantId2 then
                        local v31 = fn72()

                        if v31 then
                            enchantId2 = v31
                        end
                    end

                    if not enchantId2 then
                        return
                    end
                    tbl26.rollCount = tbl26.rollCount + 1
                    tbl26.lastRolledEnchantId = enchantId2
                    tbl26.waitingForUpdate = false
                end)

                local listenerConnected = tbl26.replionUpdateConn ~= nil
                tbl26.listenerConnected = listenerConnected
            end
        end)
    end

    local function fn76()
        if not tbl26.enabled then
            return true
        end
        local lastRolledEnchantId = tbl26.lastRolledEnchantId
        local v31 = lastRolledEnchantId

        if not lastRolledEnchantId then
            v31 = fn72()
        end

        if not v31 or v31 ~= tbl26.targetEnchantId then
            return false
        end
        tbl26.enabled = false
        fn74()
        tbl26.savedPos = nil
        tbl26.atAltar = false

        pcall(function()
            lib:MakeNotify({
                Title = "Auto Enchant",
                Description = "Successfully obtained enchant: " .. tostring(tbl26.targetEnchantName),
                Delay = 5,
            })
        end)

        return true
    end

    v28:AddDropdown({
        Title = "Enchant Type",
        Options = {
            "Normal Enchant",
            "Second Enchant",
            "Evolved Enchant",
            "Candy Enchant",
            "Eggy Enchant",
            "Runic Enchant",
        },
        Default = "Normal Enchant",
        Callback = function(arg)
            if arg == "Evolved Enchant" then
                tbl26.enchantStoneItemId = 558
                tbl26.enchantType = 1
            elseif arg == "Second Enchant" then
                tbl26.enchantStoneItemId = 246
                tbl26.enchantType = 2
            elseif arg == "Candy Enchant" then
                tbl26.enchantStoneItemId = 714
                tbl26.enchantType = 1
            elseif arg == "Eggy Enchant" then
                tbl26.enchantStoneItemId = 873
                tbl26.enchantType = 1
            elseif arg == "Runic Enchant" then
                tbl26.enchantStoneItemId = 929
                tbl26.enchantType = 1
            else
                tbl26.enchantStoneItemId = 10
                tbl26.enchantType = 1
            end
        end,
    })

    v28:AddDropdown({
        Title = "Target Enchant",
        Options = tbl28,
        Default = "XPerienced I",
        Callback = function(targetEnchantName)
            local v31 = tbl27[targetEnchantName]

            if v31 then
                tbl26.targetEnchantId = v31
                tbl26.targetEnchantName = targetEnchantName
            end
        end,
    })

    v28:AddToggle({
        Title = "Auto Enchant Reroll",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl26.enabled then
                    return
                end

                if not v29 then
                    pcall(function()
                        v29 = fn2()
                    end)
                end

                local v31 = fn72()

                if v31 and v31 == tbl26.targetEnchantId then
                    pcall(function()
                        lib:MakeNotify({
                            Title = "Auto Enchant",
                            Description = "Rod already has enchant: " .. tostring(tbl26.targetEnchantName),
                            Delay = 3,
                        })
                    end)

                    return
                end

                tbl26.enabled = true
                tbl26.rollCount = 0
                tbl26.waitingForUpdate = false
                tbl26.lastRolledEnchantId = nil
                fn73()
                fn75()

                tbl26.task = task.spawn(function()
                    local n2, n3, n4, n5, n6, n7, character, uuid, v32, now, flag5, EquippedItems, tbl29, v33, v34, v35, v36, v37, v38, v39
                    local now2, v40, n8, n9
                    n9 = 1

                    while true do
                        if n9 == 1 then
                            n2 = 667245342
                            n3 = nil
                            n4 = nil
                            n5 = nil
                            n6 = nil
                            n7 = nil
                            n9 = 2
                        elseif n9 == 2 then
                            if tbl26.enabled then
                                n9 = 3
                            else
                                n9 = 38
                            end
                        elseif n9 == 3 then
                            character = localPlayer.Character

                            if character and character:FindFirstChild("HumanoidRootPart") then
                                n9 = 5
                            else
                                n9 = 4
                            end
                        elseif n9 == 4 then
                            task.wait(1)
                            n9 = 2
                        elseif n9 == 5 then
                            if tbl26.atAltar then
                                n9 = 7
                            else
                                n9 = 6
                            end
                        elseif n9 == 6 then
                            tbl26.atAltar = true
                            n9 = 7
                        elseif n9 == 7 then
                            if tbl26.enabled then
                                n9 = 8
                            else
                                n9 = 38
                            end
                        elseif n9 == 8 then
                            uuid = nil

                            pcall(function()
                                for k, v41 in pairs(v29:GetExpect({"Inventory", "Items"})) do
                                    if v41.Id == tbl26.enchantStoneItemId then
                                        uuid = v41.UUID
                                        break
                                    end
                                end
                            end)

                            if uuid then
                                n9 = 9
                            else
                                n9 = 37
                            end
                        elseif n9 == 9 then
                            v32 = nil
                            now = tick()
                            n9 = 10
                        elseif n9 == 10 then
                            if tick() - now < 5 and tbl26.enabled then
                                n9 = 11
                            else
                                n9 = 21
                            end
                        elseif n9 == 11 then
                            flag5 = false

                            pcall(function()
                                n6 = 11437400
                                n7 = 1051648648

                                for k, v41 in pairs(v29:GetExpect({"Inventory", "Items"})) do
                                    if v41.UUID == uuid and v41.Id == tbl26.enchantStoneItemId then
                                        flag5 = true
                                        break
                                    end
                                end
                            end)

                            if flag5 then
                                n9 = 12
                            else
                                n9 = 20
                            end
                        elseif n9 == 12 then
                            EquippedItems = v29:Get("EquippedItems")
                            tbl29 = EquippedItems

                            if EquippedItems then
                                n9 = 14
                            else
                                n9 = 13
                            end
                        elseif n9 == 13 then
                            tbl29 = {}
                            n9 = 14
                        elseif n9 == 14 then
                            v33, v34, v35 = pairs(tbl29)
                            v36 = v35
                            n9 = 15
                        elseif n9 == 15 then
                            v37, v38 = v33(v34, v36)

                            if v37 == nil then
                                n9 = 18
                            else
                                n9 = 16
                            end
                        elseif n9 == 16 then
                            v36 = v37

                            if v38 == uuid then
                                n9 = 17
                            else
                                n9 = 15
                            end
                        elseif n9 == 17 then
                            v32 = v37
                            n9 = 15
                        elseif n9 == 18 then
                            if v32 then
                                n9 = 21
                            else
                                n9 = 19
                            end
                        elseif n9 == 19 then
                            pcall(function()
                                n5 = 602790348
                                obj.RE_EquipItem:FireServer(uuid, "Enchant Stones")
                            end)

                            task.wait(0.5)
                            n9 = 10
                        elseif n9 == 20 then
                            uuid = nil
                            n9 = 21
                        elseif n9 == 21 then
                            if uuid then
                                n9 = 22
                            else
                                n9 = 2
                            end
                        elseif n9 == 22 then
                            if v32 and tbl26.enabled then
                                n9 = 24
                            else
                                n9 = 23
                            end
                        elseif n9 == 23 then
                            task.wait(1)
                            n9 = 2
                        elseif n9 == 24 then
                            pcall(function()
                                obj.RF_EquipToolFromHotbar:FireServer(v32)
                            end)

                            task.wait(0.4)

                            if tbl26.enabled then
                                n9 = 25
                            else
                                n9 = 38
                            end
                        elseif n9 == 25 then
                            pcall(function()
                                n3 = 712481099
                                n4 = 782665184

                                if tbl26.enchantType == 2 then
                                    obj.RE_ActivateSecondEnchantingAltar:FireServer()
                                else
                                    obj.RE_ActivateEnchantingAltar:FireServer()
                                end
                            end)

                            task.wait(0.6)

                            if tbl26.enabled then
                                n9 = 26
                            else
                                n9 = 38
                            end
                        elseif n9 == 26 then
                            v39 = fn72()
                            tbl26.rollGeneration = tbl26.rollGeneration + 1
                            tbl26.waitingForUpdate = true
                            tbl26.lastRolledEnchantId = nil

                            pcall(function()
                                obj.RE_RollEnchant:FireServer()
                            end)

                            now2 = tick()
                            n9 = 27
                        elseif n9 == 27 then
                            if tbl26.waitingForUpdate and tbl26.enabled and tick() - now2 < 5 then
                                n9 = 36
                            else
                                n9 = 28
                            end
                        elseif n9 == 28 then
                            if tbl26.waitingForUpdate then
                                n9 = 29
                            else
                                n9 = 32
                            end
                        elseif n9 == 29 then
                            tbl26.waitingForUpdate = false
                            v40 = fn72()

                            if v40 and v40 ~= v39 then
                                n9 = 31
                            else
                                n9 = 30
                            end
                        elseif n9 == 30 then
                            tbl26.atAltar = false
                            task.wait(1.5)
                            n9 = 2
                        elseif n9 == 31 then
                            tbl26.lastRolledEnchantId = v40
                            tbl26.rollCount = tbl26.rollCount + 1
                            n9 = 32
                        elseif n9 == 32 then
                            if fn76() then
                                n9 = 38
                            else
                                n9 = 33
                            end
                        elseif n9 == 33 then
                            n8 = tick() + 5.5
                            n9 = 34
                        elseif n9 == 34 then
                            if tbl26.enabled and tick() < n8 then
                                n9 = 35
                            else
                                n9 = 2
                            end
                        elseif n9 == 35 then
                            task.wait(0.5)
                            n9 = 34
                        elseif n9 == 36 then
                            task.wait(0.1)
                            n9 = 27
                        elseif n9 == 37 then
                            tbl26.enabled = false
                            fn74()

                            pcall(function()
                                lib:MakeNotify({
                                    Title = "Auto Enchant",
                                    Description = "Out of enchant stones!",
                                    Delay = 4,
                                })
                            end)

                            n9 = 38
                        elseif n9 == 38 then
                            return
                        end
                    end
                end)
            else
                tbl26.enabled = false
                tbl26.waitingForUpdate = false
                tbl26.atAltar = false
                tbl26.savedPos = nil
                tbl26.lastRolledEnchantId = nil

                if tbl26.task then
                    pcall(function()
                        task.cancel(tbl26.task)
                    end)

                    tbl26.task = nil
                end

                if tbl26.statusTask then
                    pcall(function()
                        task.cancel(tbl26.statusTask)
                    end)

                    tbl26.statusTask = nil
                end

                fn74()
            end
        end,
    })

    v28:AddButton({
        Title = "Teleport to Altar 1",
        Callback = function()
            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(3245, -1301, 1394)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end,
    })

    v28:AddButton({
        Title = "Teleport to Altar 2",
        Callback = function()
            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(1479.35742, 124.582748, -604.037476, -0.171021342, 0.0301617607, 0.984805524, 0.173656046, 0.984806359, -4.67896461e-06, -0.969842851, 0.171016648, -0.173660636)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end,
    })

    local tbl29 = {enabled = false, thread = nil, amount = 1, target = nil}
    local tbl30 = {}
    local v31 = nil
    local v32 = v4:AddSection("Create Transcended Stone", false)
    local v33 = v32:AddParagraph({Title = "Status", Content = "Idle"})

    local function fn77(arg, arg2)
        pcall(function()
            v33:SetTitle(arg)
            v33:SetContent(arg2)
        end)
    end

    local v34 = v32:AddDropdown({
        Title = "Select Secret Fish",
        Options = {},
        Default = "",
        NoSave = true,
        Callback = function(arg)
            if not arg or arg == "" then
                return
            end
            local match = arg:match("^(.-)%s+x%d+$")
            local v34 = match or arg
            tbl29.target = v34
        end,
    })

    local function fn78()
        local tbl31 = {}

        for k, v35 in pairs(tbl30) do
            if #v35 > 0 then
                table.insert(tbl31, k .. " x" .. #v35)
            end
        end

        return tbl31
    end

    local function fn79()
        pcall(function()
            v34:SetOptions(fn78())
        end)
    end

    local function fn80()
        pcall(function()
            local v35 = fn2()
            if not v35 then
                fn77("Error", "Replion data not available.")
                return
            end
            local v36 = fn(ReplicatedStorage.Shared.ItemUtility)
            local v37 = fn(ReplicatedStorage.Shared.TierUtility)
            local expect = v35:GetExpect({"Inventory", "Items"})
            table.clear(tbl30)

            for i, v38 in ipairs(expect) do
                if v38.Favorited ~= true then
                    local Fish = v36.GetItemDataFromItemType("Fish", v38.Id)

                    if Fish and Fish.Data and Fish.Data.Type == "Fish" and Fish.Probability then
                        local tierFromRarity = v37:GetTierFromRarity(Fish.Probability.Chance)

                        if tierFromRarity and tierFromRarity.Tier == 7 then
                            local name = Fish.Data.Name
                            local str3 = name or tostring(v38.Id)

                            if not tbl30[str3] then
                                tbl30[str3] = {}
                            end

                            table.insert(tbl30[str3], v38.UUID)
                        end
                    end
                end
            end

            local v38 = fn78()
            v34:SetOptions(v38)

            if #v38 > 0 then
                local match = v38[1]:match("^(.-)%s+x%d+$")
                local v39 = match or v38[1]

                if not tbl29.target or not tbl30[tbl29.target] then
                    tbl29.target = v39
                end

                fn77("Fish List", #v38 .. " type(s) of secret fish found")
            else
                tbl29.target = nil
                fn77("Fish List", "No unfavorited secret fish found")
            end
        end)
    end

    v32:AddButton({
        Title = "Refresh Fish List",
        Callback = function()
            task.spawn(fn80)
        end,
    })

    v32:AddInput({
        Title = "Create Amount",
        Default = "1",
        Callback = function(arg)
            local num = tonumber(arg)

            if num and num > 0 then
                tbl29.amount = math.floor(num)
            end
        end,
    })

    v31 = v32:AddToggle({
        Title = "Enable Auto Create",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl29.enabled = enabled

            if tbl29.thread then
                pcall(task.cancel, tbl29.thread)
                tbl29.thread = nil
            end

            if not enabled then
                fn77("Status", "Idle")

                lib:MakeNotify({
                    Title = "Transcended Stone",
                    Description = "Stopped.",
                    Delay = 2,
                })

                return
            end

            tbl29.thread = task.spawn(function()
                local function fn81(arg)
                    local flag5 = false

                    pcall(function()
                        local v35 = fn2()
                        if not v35 then
                            return
                        end
                        local flag6 = false

                        for i, v36 in ipairs(v35:GetExpect({"Inventory", "Items"})) do
                            if v36.UUID == arg then
                                flag6 = true
                                break
                            end
                        end

                        if not flag6 then
                            return
                        end
                        local v36 = nil
                        local now = tick()

                        while tick() - now < 5 do
                            local EquippedItems = v35:Get("EquippedItems")
                            local tbl31 = EquippedItems or {}

                            for k, v37 in pairs(tbl31) do
                                if v37 == arg then
                                    v36 = k
                                end
                            end

                            if v36 then
                                break
                            end
                            obj.RE_EquipItem:FireServer(arg, "Fish")
                            task.wait(0.1)
                        end

                        if not v36 then
                            return
                        end
                        obj.RF_EquipToolFromHotbar:FireServer(v36)
                        local now2 = tick()

                        while tick() - now2 < 5 do
                            task.wait(0.1)
                            if v35:Get("EquippedId") == arg then
                                flag5 = true
                                break
                            end
                        end
                    end)

                    return flag5
                end

                local function fn82()
                    local flag5 = false
                    local str3 = nil

                    pcall(function()
                        local rfCreateTranscendedStone = obj.RF_CreateTranscendedStone
                        if not rfCreateTranscendedStone then
                            str3 = "Remote not found."
                            return
                        end
                        obj.RE_DialogueEnded:FireServer("Temple Guardian", 1, 3)
                        task.wait(0.1)
                        obj.RE_DialogueEnded:FireServer("Temple Guardian", 2, 2)
                        task.wait(0.1)
                        obj.RE_DialogueEnded:FireServer("Temple Guardian", 3, 2)
                        task.wait(0.2)
                        local response, v35 = rfCreateTranscendedStone:InvokeServer()

                        if response then
                            flag5 = true
                        else
                            local v36 = tostring
                            local str4 = v35 or "Unknown error"
                            str3 = v36(str4)
                        end
                    end)

                    return flag5, str3
                end

                local n2 = 0

                lib:MakeNotify({
                    Title = "Transcended Stone",
                    Description = "Starting...",
                    Delay = 2,
                })

                while tbl29.enabled and n2 < tbl29.amount do
                    if tbl29.target and tbl29.target ~= "" then
                        local target = tbl29.target
                        local v35 = tbl30[target]

                        if v35 and #v35 ~= 0 then
                            local v36 = v35[1]
                            fn77("Equipping", target)

                            if not fn81(v36) then
                                table.remove(v35, 1)

                                if #v35 == 0 then
                                    fn79()
                                    fn77("Out of Stock", target .. " is out of stock.")

                                    lib:MakeNotify({
                                        Title = "Transcended Stone",
                                        Description = target .. " ran out. Process stopped.",
                                        Delay = 4,
                                    })

                                    break
                                end

                                fn79()
                                fn77("Skipped", "Equip failed, retrying " .. target .. "...")
                                task.wait(0.3)
                                continue
                            end

                            local v37, v38 = fn82()

                            if v37 then
                                local n3 = n2 + 1
                                n2 = n3
                                table.remove(v35, 1)
                                fn79()
                                fn77("Success", "Created: " .. n3 .. " / " .. tbl29.amount)

                                lib:MakeNotify({
                                    Title = "Transcended Stone",
                                    Description = "Created " .. n3 .. " of " .. tbl29.amount,
                                    Delay = 3,
                                })

                                task.wait(0.5)
                            else
                                local str3 = v38 or "Server rejected."
                                fn77("Failed", str3)
                                local makeNotify = lib.MakeNotify
                                local tbl31 = {Title = "Transcended Stone"}
                                local description = v38 or "Creation failed."
                                tbl31.Description = description
                                tbl31.Delay = 3
                                makeNotify(lib, tbl31)
                                task.wait(1.5)
                            end

                            continue
                        end

                        fn77("Out of Stock", target .. " is out of stock.")

                        lib:MakeNotify({
                            Title = "Transcended Stone",
                            Description = target .. " ran out. Process stopped.",
                            Delay = 4,
                        })

                        break
                    end

                    fn77("Error", "No fish selected. Refresh list first.")
                    task.wait(2)
                end

                if tbl29.amount <= n2 then
                    fn77("Done", "Completed: " .. n2 .. " stones created.")

                    lib:MakeNotify({
                        Title = "Transcended Stone",
                        Description = "All " .. n2 .. " stones created!",
                        Delay = 4,
                    })
                end

                tbl29.enabled = false
                tbl29.thread = nil

                if v31 then
                    pcall(function()
                        v31:SetValue(false)
                    end)
                end
            end)
        end,
    })

    local v35 = v4:AddSection("Spawn Totem", false)
    local tbl31 = {}

    local tbl32 = {
        enabled = false,
        task = nil,
        selectedTotem = nil,
        data = nil,
        totemMap = {},
        totemNames = {},
        totemCreatedConn = nil,
        ancestryConns = {},
    }

    local function fn81()
        if tbl32.totemCreatedConn then
            pcall(function()
                tbl32.totemCreatedConn:Disconnect()
            end)

            tbl32.totemCreatedConn = nil
        end

        for i, ancestryConn in ipairs(tbl32.ancestryConns) do
            pcall(function()
                ancestryConn:Disconnect()
            end)
        end

        table.clear(tbl32.ancestryConns)
    end

    local v36 = nil

    local function fn82()
        tbl32.totemMap = {}
        tbl32.totemNames = {}

        pcall(function()
            local totems = ReplicatedStorage:FindFirstChild("Totems")
            if not totems then
                return
            end

            for i, child in ipairs(totems:GetChildren()) do
                if child:IsA("ModuleScript") then
                    local ok, result = pcall(function()
                        return require(child)
                    end)

                    if ok and type(result) == "table" and result.Data and result.Data.Id then
                        local name = result.Data.Name
                        local name2 = name or child.Name
                        tbl32.totemMap[name2] = result.Data.Id
                        table.insert(tbl32.totemNames, name2)
                    end
                end
            end

            table.sort(tbl32.totemNames)
        end)
    end

    task.spawn(function()
        fn82()
        tbl32.selectedTotem = tbl32.totemNames[1]

        if v36 and v36.SetOptions then
            local v37 = v36
            local setOptions = v37.SetOptions
            local totemNames = #tbl32.totemNames > 0 and tbl32.totemNames

            if not totemNames then
                local tbl33 = {}
                totemNames = tbl33
                tbl33[1] = "No Totems Found"
            end

            setOptions(v37, totemNames)
        end
    end)

    local addDropdown2 = v35.AddDropdown
    local tbl33 = {Title = "Totem Type"}
    local totemNames = #tbl32.totemNames > 0 and tbl32.totemNames

    if not totemNames then
        local tbl34 = {}
        totemNames = tbl34
        tbl34[1] = "Loading..."
    end

    tbl33.Options = totemNames
    tbl33.Default = nil

    tbl33.Callback = function(selectedTotem)
        tbl32.selectedTotem = selectedTotem
    end

    v36 = addDropdown2(v35, tbl33)

    v35:AddButton({
        Title = "Refresh Totem List",
        Callback = function()
            fn82()

            if v36 and v36.SetOptions then
                local v37 = v36
                local setOptions = v37.SetOptions
                local totemNames2 = #tbl32.totemNames > 0 and tbl32.totemNames

                if not totemNames2 then
                    local tbl34 = {}
                    totemNames2 = tbl34
                    tbl34[1] = "No Totems Found"
                end

                setOptions(v37, totemNames2)
            end
        end,
    })

    v35:AddToggle({
        Title = "Enable Auto Spawn",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl32.enabled then
                    return
                end

                if not tbl32.data then
                    pcall(function()
                        tbl32.data = fn2()
                    end)

                    if not tbl32.data then
                        local v37 = fn3()

                        if v37 then
                            tbl32.data = v37.Client:WaitReplion("Data")
                        end
                    end
                end

                if not tbl32.data then
                    warn("[AutoSpawn] Data belum siap!")
                    return
                end

                if not obj.IsInitialized then
                    warn("[AutoSpawn] EventResolver belum siap!")
                    return
                end
                fn81()

                pcall(function()
                    local reTotemCreated = obj.RE_TotemCreated
                    if not reTotemCreated then
                        return
                    end

                    tbl32.totemCreatedConn = reTotemCreated.OnClientEvent:Connect(function(arg2, arg3)
                        if not tbl32.enabled or not arg2 or not arg3 then
                            return
                        end
                        tbl31[arg2] = arg3

                        local connection = arg2.AncestryChanged:Connect(function()
                            if not arg2.Parent then
                                tbl31[arg2] = nil

                                pcall(function()
                                    anc:Disconnect()
                                end)
                            end
                        end)

                        table.insert(tbl32.ancestryConns, connection)
                    end)
                end)

                tbl32.enabled = true

                tbl32.task = task.spawn(function()
                    while tbl32.enabled do
                        local flag5 = false

                        pcall(function()
                            local ok, result = pcall(function()
                                return tbl32.data:Get("TotemBoosts")
                            end)

                            if ok and result and #result > 0 then
                                flag5 = true
                            end
                        end)

                        if not flag5 then
                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                local v37 = nil
                                local huge = math.huge

                                for k, v38 in pairs(tbl31) do
                                    if k and k.Parent then
                                        local handle = k:FindFirstChild("Handle")
                                        local primaryPart = handle or k.PrimaryPart

                                        if primaryPart then
                                            local magnitude = (primaryPart.Position - humanoidRootPart.Position).Magnitude

                                            if magnitude < huge then
                                                huge = magnitude
                                                v37 = v38
                                            end
                                        end
                                    else
                                        tbl31[k] = nil
                                    end
                                end

                                if v37 then
                                    fn4(function()
                                        obj.RE_TotemPickup:FireServer(v37)
                                    end)

                                    task.wait(2)
                                else
                                    local uuid = nil

                                    pcall(function()
                                        local v38 = tbl32.totemMap[tbl32.selectedTotem]
                                        if not v38 then
                                            return
                                        end

                                        local ok, result = pcall(function()
                                            return tbl32.data:Get("Inventory")
                                        end)

                                        if ok and result and result.Totems then
                                            for k, totem in pairs(result.Totems) do
                                                if totem and totem.UUID and tonumber(totem.Id) == v38 then
                                                    local count = totem.Count
                                                    local n2 = count or 1
                                                    if n2 >= 1 then
                                                        uuid = totem.UUID
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end)

                                    if uuid then
                                        pcall(function()
                                            obj.RE_SpawnTotem:FireServer(uuid)
                                        end)
                                    end
                                end
                            end
                        end

                        task.wait(3)
                    end
                end)

                lib:MakeNotify({
                    Title = "Auto Spawn Totem",
                    Description = "Aktif.",
                    Delay = 2,
                })
            else
                tbl32.enabled = false
                fn81()
                table.clear(tbl31)

                if tbl32.task then
                    task.cancel(tbl32.task)
                    tbl32.task = nil
                end

                lib:MakeNotify({
                    Title = "Auto Spawn Totem",
                    Description = "Dihentikan.",
                    Delay = 2,
                })
            end
        end,
    })

    v35:AddButton({
        Title = "Spawn Now",
        Callback = function()
            if not tbl32.data then
                pcall(function()
                    tbl32.data = fn2()
                end)
            end

            if not tbl32.data then
                return
            end
            local uuid = nil

            pcall(function()
                local v37 = tbl32.totemMap[tbl32.selectedTotem]
                if not v37 then
                    return
                end

                local ok, result = pcall(function()
                    return tbl32.data:Get("Inventory")
                end)

                if ok and result and result.Totems then
                    for k, totem in pairs(result.Totems) do
                        if totem and totem.UUID and tonumber(totem.Id) == v37 then
                            local count = totem.Count
                            local n2 = count or 1
                            if n2 >= 1 then
                                uuid = totem.UUID
                                break
                            end
                        end
                    end
                end
            end)

            if uuid then
                pcall(function()
                    obj.RE_SpawnTotem:FireServer(uuid)
                end)
            end
        end,
    })
end

do
    local v5 = v4:AddSection("Spawn 4X Totem(Mix)[BETA]", false)

    local tbl4 = {
        active = false,
        thread = nil,
        monitorThread = nil,
        stateConn = nil,
        holdConn = nil,
        noclipConn = nil,
        physicsSession = 0,
        totemMap = {},
        totemNames = {},
        selectedSlots = {nil, nil, nil, nil},
        data = nil,
    }

    local tbl5 = {
        States = {},
        AnimateEnabled = true,
        CFrame = nil,
        CanCollide = {},
    }

    local tbl6 = {nil, nil, nil, nil}
    local vector = Vector3.new(93.932, 9.532, 2684.134)

    local tbl7 = {
        Vector3.new(45.0468979, 9.51625347, 2730.19067),
        Vector3.new(45.0468979, 110.516253, 2730.19067),
        Vector3.new(84.6406631, 10.2174253, 2636.05786),
        Vector3.new(84.6406631, 111.217425, 2636.05786),
    }

    local tbl8 = {
        Enum.HumanoidStateType.Running,
        Enum.HumanoidStateType.Swimming,
        Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.GettingUp,
        Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.Landed,
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.PlatformStanding,
        Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Seated,
        Enum.HumanoidStateType.Flying,
    }

    local function fn6()
        tbl4.totemMap = {}
        tbl4.totemNames = {}

        pcall(function()
            local totems = ReplicatedStorage:FindFirstChild("Totems")
            if not totems then
                return
            end

            for i, child in ipairs(totems:GetChildren()) do
                if child:IsA("ModuleScript") then
                    local ok, result = pcall(function()
                        return require(child)
                    end)

                    if ok and type(result) == "table" and result.Data and result.Data.Id then
                        local name = result.Data.Name
                        local name2 = name or child.Name
                        tbl4.totemMap[name2] = result.Data.Id
                        table.insert(tbl4.totemNames, name2)
                    end
                end
            end

            table.sort(tbl4.totemNames)
        end)
    end

    local function fn7()
        local totemNames = #tbl4.totemNames > 0 and tbl4.totemNames

        if not totemNames then
            local tbl9 = {}
            totemNames = tbl9
            tbl9[1] = "No Totems Found"
        end

        for i = 1, 3 do
            if tbl6[i] and tbl6[i].SetOptions then
                tbl6[i]:SetOptions(totemNames)
            end
        end

        if tbl6[4] and tbl6[4].SetOptions then
            local tbl9 = {"None (Skip)"}

            for i, totemName in ipairs(tbl4.totemNames) do
                table.insert(tbl9, totemName)
            end

            tbl6[4]:SetOptions(tbl9)
        end

        for i = 1, 3 do
            if not tbl4.selectedSlots[i] then
                local selectedSlots = tbl4.selectedSlots
                local v6 = tbl4.totemNames[i]
                local v7 = v6 or tbl4.totemNames[1]
                selectedSlots[i] = v7
            end
        end
    end

    local function fn8(arg)
        if not tbl4.data or not arg then
            return nil
        end
        local v6 = tbl4.totemMap[arg]
        if not v6 then
            return nil
        end
        local uuid = nil

        pcall(function()
            local ok, result = pcall(function()
                return tbl4.data:Get("Inventory")
            end)

            if ok and result and result.Totems then
                for k, totem in pairs(result.Totems) do
                    if totem and totem.UUID and tonumber(totem.Id) == v6 then
                        local count = totem.Count
                        local n = count or 1
                        if n >= 1 then
                            uuid = totem.UUID
                            break
                        end
                    end
                end
            end
        end)

        return uuid
    end

    local function fn9()
        local tbl9 = {}

        pcall(function()
            local ok, result = pcall(function()
                return tbl4.data:Get("TotemBoosts")
            end)

            if ok and result then
                for k, v6 in pairs(result) do
                    if v6 and v6.Id then
                        tbl9[tonumber(v6.Id)] = true
                    end
                end
            end
        end)

        return tbl9
    end

    fn6()

    v5:AddParagraph({
        Title = "Auto Totem Info",
        Content = "[EN] Select different totems for each slot. Slot 4 is optional (for event totems). If a totem effect expires (15s), it will auto re-spawn.\n[ID] Pilih totem yang berbeda di setiap slot. Slot 4 opsional (untuk totem event). Jika efek totem habis (15 detik), otomatis pasang ulang.",
    })

    for i = 1, 3 do
        local addDropdown = v5.AddDropdown
        local tbl9 = {Title = string.format("Totem Slot %d", i)}
        local totemNames = #tbl4.totemNames > 0 and tbl4.totemNames

        if not totemNames then
            local tbl10 = {}
            totemNames = tbl10
            tbl10[1] = "No Totems Found"
        end

        tbl9.Options = totemNames
        local v6 = tbl4.totemNames[i]
        local v7 = v6 or tbl4.totemNames[1]
        tbl9.Default = v7

        tbl9.Callback = function(arg)
            tbl4.selectedSlots[i] = arg
        end

        tbl6[i] = addDropdown(v5, tbl9)
        local selectedSlots = tbl4.selectedSlots
        local v8 = tbl4.totemNames[i]
        local v9 = v8 or tbl4.totemNames[1]
        selectedSlots[i] = v9
    end

    local tbl9 = {"None (Skip)"}

    for i, totemName in ipairs(tbl4.totemNames) do
        table.insert(tbl9, totemName)
    end

    tbl6[4] = v5:AddDropdown({
        Title = "Slot 4 Event Totem (optional)",
        Options = tbl9,
        Default = "None (Skip)",
        Callback = function(arg)
            local selectedSlots = tbl4.selectedSlots
            local flag4 = arg ~= "None (Skip)" and arg or nil
            selectedSlots[4] = flag4
        end,
    })

    tbl4.selectedSlots[4] = nil

    v5:AddButton({
        Title = "Refresh Totem List [Mix]",
        Callback = function()
            fn6()
            fn7()
        end,
    })

    v5:AddToggle({
        Title = "Enable Spawn Totem Mix",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            local function fn10()
                local character = localPlayer.Character
                if not character then
                    return nil
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local torso = humanoidRootPart or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                return torso
            end

            local function fn11()
                pcall(function()
                    if obj.RF_EquipOxygenTank then
                        obj.RF_EquipOxygenTank:InvokeServer(575)
                    end
                end)
            end

            local function fn12()
                pcall(function()
                    if obj.RF_UnequipOxygenTank then
                        obj.RF_UnequipOxygenTank:InvokeServer()
                    end
                end)
            end

            local function fn13(cFrame)
                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if not humanoid then
                    return
                end
                tbl5.CFrame = cFrame
                tbl5.States = {}
                tbl5.CanCollide = {}
                tbl5.AnimateEnabled = true

                if character:FindFirstChild("Animate") then
                    local animateEnabled = character.Animate.Disabled == false
                    tbl5.AnimateEnabled = animateEnabled
                end

                for i, v6 in ipairs(tbl8) do
                    tbl5.States[v6] = humanoid:GetStateEnabled(v6)
                end

                for i, descendant in ipairs(character:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        tbl5.CanCollide[descendant] = descendant.CanCollide
                    end
                end
            end

            local function fn14()
                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local cFrame = tbl5.CFrame
                local cFrame2 = cFrame or humanoidRootPart and humanoidRootPart.CFrame

                if humanoidRootPart then
                    pcall(function()
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        local flyGuiVelocity = humanoidRootPart:FindFirstChild("FlyGuiVelocity")
                        local flyGuiGyro = humanoidRootPart:FindFirstChild("FlyGuiGyro")

                        if flyGuiVelocity then
                            flyGuiVelocity.velocity = Vector3.zero
                            flyGuiVelocity.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                        end

                        if flyGuiGyro then
                            flyGuiGyro.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)

                            if cFrame2 then
                                flyGuiGyro.CFrame = cFrame2
                            end
                        end

                        if cFrame2 then
                            humanoidRootPart.CFrame = cFrame2
                            humanoidRootPart.CFrame = cFrame2
                        end
                    end)
                end

                if humanoid then
                    pcall(function()
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    end)
                end

                if tbl4.holdConn then
                    tbl4.holdConn:Disconnect()
                    tbl4.holdConn = nil
                end

                if tbl4.stateConn then
                    tbl4.stateConn:Disconnect()
                    tbl4.stateConn = nil
                end

                if tbl4.noclipConn then
                    tbl4.noclipConn:Disconnect()
                    tbl4.noclipConn = nil
                end

                tbl4.physicsSession = tbl4.physicsSession + 1
                task.wait(0.15)

                if character then
                    pcall(function()
                        for k, v6 in pairs(tbl5.CanCollide) do
                            if k and k.Parent then
                                k.CanCollide = v6
                            end
                        end
                    end)
                end

                if humanoid then
                    for k, state in pairs(tbl5.States) do
                        pcall(function()
                            humanoid:SetStateEnabled(k, state)
                        end)
                    end
                end

                if character then
                    pcall(function()
                        if character:FindFirstChild("Animate") then
                            local animate = character.Animate
                            local disabled

                            if tbl5.AnimateEnabled then
                                disabled = false
                            else
                                disabled = true
                            end

                            animate.Disabled = disabled
                        end
                    end)
                end

                if humanoid then
                    humanoid.PlatformStand = false

                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    end)
                end

                task.wait(0.1)

                if humanoidRootPart then
                    pcall(function()
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

                        if cFrame2 then
                            humanoidRootPart.CFrame = cFrame2
                        end
                    end)
                end

                if humanoidRootPart then
                    pcall(function()
                        for i, child in ipairs(humanoidRootPart:GetChildren()) do
                            if child.Name == "FlyGuiGyro" or child.Name == "FlyGuiVelocity" then
                                child:Destroy()
                            end
                        end
                    end)
                end

                if humanoidRootPart then
                    pcall(function()
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    end)
                end

                if humanoidRootPart then
                    task.spawn(function()
                        for i = 1, 30 do
                            pcall(function()
                                if humanoidRootPart and humanoidRootPart.Parent then
                                    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                                    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                                end
                            end)

                            RunService.Heartbeat:Wait()
                        end
                    end)
                end
            end

            local function fn15()
                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                local v6 = fn10()
                if not v6 or not humanoid then
                    return
                end
                tbl4.physicsSession = tbl4.physicsSession + 1
                local physicsSession = tbl4.physicsSession

                pcall(function()
                    if character:FindFirstChild("Animate") then
                        character.Animate.Disabled = true
                    end
                end)

                humanoid.PlatformStand = true

                pcall(function()
                    for i, v7 in ipairs(tbl8) do
                        humanoid:SetStateEnabled(v7, false)
                    end
                end)

                if not tbl4.stateConn then
                    local connection = RunService.Heartbeat:Connect((function(t)
                        return function()
                            if t and t.Parent and tbl4.active then
                                pcall(function()
                                    t:ChangeState(Enum.HumanoidStateType.Swimming)
                                    t:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                                end)
                            end
                        end
                    end)(humanoid))

                    tbl4.stateConn = connection
                end

                local flyGuiGyro = v6:FindFirstChild("FlyGuiGyro")
                local bodyGyro = flyGuiGyro or Instance.new("BodyGyro", v6)
                bodyGyro.Name = "FlyGuiGyro"
                bodyGyro.P = 90000
                bodyGyro.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
                bodyGyro.CFrame = v6.CFrame
                local flyGuiVelocity = v6:FindFirstChild("FlyGuiVelocity")
                local bodyVelocity = flyGuiVelocity or Instance.new("BodyVelocity", v6)
                bodyVelocity.Name = "FlyGuiVelocity"
                bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                bodyVelocity.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                local tbl10 = {}

                local function fn16(arg2)
                    if arg2 and arg2:IsA("BasePart") then
                        arg2.CanCollide = false
                        tbl10[arg2] = true
                    end
                end

                for i, descendant in ipairs(character:GetDescendants()) do
                    fn16(descendant)
                end

                if tbl4.noclipConn then
                    tbl4.noclipConn:Disconnect()
                    tbl4.noclipConn = nil
                end

                local connection = character.DescendantAdded:Connect(function(descendant)
                    if tbl4.active and tbl4.physicsSession == physicsSession then
                        fn16(descendant)
                    end
                end)

                tbl4.noclipConn = connection

                task.spawn(function()
                    while tbl4.active and tbl4.physicsSession == physicsSession and character and character.Parent do
                        for k in pairs(tbl10) do
                            if k and k.Parent then
                                k.CanCollide = false
                            else
                                tbl10[k] = nil
                            end
                        end

                        task.wait(0.25)
                    end
                end)

                task.spawn(function()
                    while tbl4.active and tbl4.physicsSession == physicsSession and humanoid and humanoid.Parent do
                        humanoid.Health = humanoid.MaxHealth
                        task.wait(1)
                    end
                end)
            end

            local function fn16(arg2)
                local v6 = fn10()
                if not v6 then
                    return
                end

                if tbl4.holdConn then
                    tbl4.holdConn:Disconnect()
                    tbl4.holdConn = nil
                end

                local connection = RunService.Heartbeat:Connect((function(V, t)
                    return function()
                        if V and V.Parent then
                            V.CFrame = t
                            V.Velocity = Vector3.zero
                            V.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end)(v6, arg2))

                tbl4.holdConn = connection
            end

            local function fn17()
                if tbl4.holdConn then
                    tbl4.holdConn:Disconnect()
                    tbl4.holdConn = nil
                end
            end

            local function fn18(arg2)
                local v6 = fn10()
                if not v6 then
                    return
                end
                v6.CFrame = CFrame.new(arg2)
                v6.AssemblyLinearVelocity = Vector3.zero
                v6.AssemblyAngularVelocity = Vector3.zero
            end

            local function fn19()
                local v6 = flag3
                local selling = v6 or tbl3.selling
                return selling
            end

            local function fn20()
                if not fn19() then
                    return true
                end

                lib:MakeNotify({
                    Title = "3x Totem Mix",
                    Description = "Menunggu fitur lain selesai...",
                    Delay = 3,
                })

                while tbl4.active and fn19() do
                    task.wait(1)
                end

                if not tbl4.active then
                    return false
                end
                task.wait(5)
                return tbl4.active
            end

            local function fn21(arg2, arg3)
                if not fn20() then
                    return false
                end
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    return false
                end
                local flag4 = false
                flag2 = true
                fn13(humanoidRootPart.CFrame)
                fn11()
                task.wait(0.3)
                fn15()
                task.wait(0.5)

                for i, v6 in ipairs(arg3) do
                    if not tbl4.active then
                        break
                    end
                    local v7 = tbl4.selectedSlots[v6]

                    if v7 then
                        local v8 = fn8(v7)

                        if v8 then
                            local n = arg2.Position + (tbl7[v6] - vector)
                            fn18(n)
                            fn16(CFrame.new(n))
                            task.wait(1.5)

                            fn4(function()
                                obj.RE_SpawnTotem:FireServer(v8)
                            end)

                            flag4 = true
                            task.wait(0.3)
                            fn17()
                            task.wait(0.2)
                        end
                    end
                end

                fn17()
                fn12()
                task.wait(0.2)
                fn14()
                flag2 = false
                return flag4
            end

            local function fn22()
                if tbl4.monitorThread then
                    pcall(task.cancel, tbl4.monitorThread)
                    tbl4.monitorThread = nil
                end

                local thread = task.spawn(function()
                    local tbl10 = {}
                    local tbl11 = tbl10
                    tbl10[1] = 0
                    tbl10[2] = 0
                    tbl10[3] = 0
                    tbl10[4] = 0

                    while tbl4.active do
                        task.wait(1)
                        if not tbl4.active then
                            break
                        end
                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            local v6 = fn9()

                            for i = 1, 4 do
                                local v7 = tbl4.selectedSlots[i]

                                if v7 then
                                    local v8 = tbl4.totemMap[v7]

                                    if v8 then
                                        local v9 = v6[v8]
                                        local n = v9 and 0 or tbl11[i] + 1
                                        tbl11[i] = n
                                    else
                                        tbl11[i] = 0
                                    end
                                else
                                    tbl11[i] = 0
                                end
                            end

                            local tbl12 = {}

                            for i = 1, 4 do
                                if tbl11[i] >= 15 then
                                    local v7 = tbl4.selectedSlots[i]

                                    if v7 and fn8(v7) then
                                        table.insert(tbl12, i)
                                    end
                                end
                            end

                            if #tbl12 ~= 0 then
                                for i, v7 in ipairs(tbl12) do
                                    tbl11[v7] = 0
                                end

                                local tbl13 = {}

                                for i, v7 in ipairs(tbl12) do
                                    local insert = table.insert
                                    local v8 = tbl4.selectedSlots[v7]
                                    local str2 = v8 or "?"
                                    insert(tbl13, str2)
                                end

                                lib:MakeNotify({
                                    Title = "3x Totem Mix",
                                    Description = "Re-spawn: " .. table.concat(tbl13, ", "),
                                    Delay = 3,
                                })

                                fn21(humanoidRootPart.CFrame, tbl12)
                            end
                        else
                            tbl11 = {0, 0, 0, 0}
                        end
                    end
                end)

                tbl4.monitorThread = thread
            end

            if arg then
                if tbl4.active then
                    return
                end

                if not tbl4.data then
                    warn("[3xTotem] Data belum siap!")
                    return
                end

                if not obj.IsInitialized then
                    warn("[3xTotem] EventResolver belum siap!")
                    return
                end
                tbl4.active = true

                local thread = task.spawn(function()
                    if not fn20() then
                        tbl4.active = false
                        return
                    end
                    local tbl10 = {}
                    local tbl11 = {}
                    local tbl12 = {}

                    for i = 1, 4 do
                        local v6 = tbl4.selectedSlots[i]

                        if v6 and tbl4.totemMap[v6] then
                            local v7 = fn8(v6)

                            if v7 then
                                tbl10[i] = v7
                                table.insert(tbl11, i)
                            else
                                table.insert(tbl12, v6)
                            end
                        end
                    end

                    if #tbl11 == 0 then
                        warn("[3xTotem] Tidak ada totem yang tersedia di inventory!")

                        lib:MakeNotify({
                            Title = "3x Totem Mix",
                            Description = "Gagal: tidak ada totem di inventory!",
                            Delay = 4,
                        })

                        tbl4.active = false
                        return
                    end

                    if #tbl12 > 0 then
                        lib:MakeNotify({
                            Title = "3x Totem Mix",
                            Description = "Skip (tidak di tas): " .. table.concat(tbl12, ", "),
                            Delay = 4,
                        })
                    end

                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then
                        tbl4.active = false
                        return
                    end
                    local cFrame = humanoidRootPart.CFrame
                    fn13(cFrame)
                    local humanoid = character:FindFirstChild("Humanoid")

                    if humanoid then
                        humanoid.Health = humanoid.MaxHealth
                    end

                    flag2 = true
                    fn11()
                    task.wait(0.3)
                    fn15()
                    task.wait(0.5)

                    for i, v6 in ipairs(tbl11) do
                        if not tbl4.active then
                            break
                        end
                        local n = cFrame.Position + (tbl7[v6] - vector)
                        fn18(n)
                        fn16(CFrame.new(n))
                        task.wait(1.5)

                        if tbl10[v6] and obj.RE_SpawnTotem then
                            fn4(function()
                                obj.RE_SpawnTotem:FireServer(tbl10[v6])
                            end)
                        end

                        task.wait(0.3)
                        fn17()
                        task.wait(0.2)
                    end

                    fn17()
                    fn12()
                    task.wait(0.2)
                    fn14()
                    flag2 = false

                    lib:MakeNotify({
                        Title = "3x Totem Mix",
                        Description = string.format("Selesai! %d totem berhasil di-spawn.", #tbl11),
                        Delay = 3,
                    })

                    fn22()
                end)

                tbl4.thread = thread
                local v6 = tbl4.selectedSlots[1]
                local str2 = v6 or "?"
                local v7 = tbl4.selectedSlots[2]
                local str3 = v7 or "?"
                local v8 = tbl4.selectedSlots[3]
                local str4 = v8 or "?"
                local str5 = string.format("Dimulai: %s | %s | %s", str2, str3, str4)
                local str6 = str5

                if tbl4.selectedSlots[4] then
                    str6 = str5 .. " | " .. tbl4.selectedSlots[4]
                end

                lib:MakeNotify({Title = "3x Totem Mix", Description = str6, Delay = 3})
            else
                tbl4.active = false
                flag2 = false
                task.wait()

                if tbl4.stateConn then
                    tbl4.stateConn:Disconnect()
                    tbl4.stateConn = nil
                end

                if tbl4.holdConn then
                    tbl4.holdConn:Disconnect()
                    tbl4.holdConn = nil
                end

                if tbl4.noclipConn then
                    tbl4.noclipConn:Disconnect()
                    tbl4.noclipConn = nil
                end

                if tbl4.thread then
                    pcall(task.cancel, tbl4.thread)
                    tbl4.thread = nil
                end

                if tbl4.monitorThread then
                    pcall(task.cancel, tbl4.monitorThread)
                    tbl4.monitorThread = nil
                end

                if not tbl5.CFrame then
                    local character = localPlayer.Character
                    local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart then
                        tbl5.CFrame = humanoidRootPart.CFrame
                    end
                end

                task.spawn(function()
                    fn12()
                    task.wait(0.3)
                    fn14()
                end)

                lib:MakeNotify({
                    Title = "3x Totem Mix",
                    Description = "Dihentikan.",
                    Delay = 2,
                })
            end
        end,
    })

    task.spawn(function()
        pcall(function()
            local v6 = fn2()
            tbl4.data = v6
        end)

        if not tbl4.data then
            local v6 = fn3()

            if v6 then
                local Data = v6.Client:WaitReplion("Data")
                tbl4.data = Data
            end
        end
    end)

    local v6 = nil

    local function fn10()
        if v6 then
            return v6
        end

        local ok, result = pcall(function()
            return workspace:WaitForChild("!!! DEPENDENCIES", 60)
        end)

        if not ok or not result then
            return nil
        end
        v6 = result
        return v6
    end

    local function fn11(arg)
        task.spawn(function()
            pcall(function()
                localPlayer:RequestStreamAroundAsync(arg, 1000)
            end)
        end)
    end

    local function fn12(arg)
        local v7 = arg.GetStats()
        if not v7 then
            return false
        end
        local flag4 = v7.Visible == true
        return flag4
    end

    local function fn13(arg)
        local ok, result = pcall(function()
            return arg.GetStats().Timer.Label.Text
        end)

        local str2 = ok and result or "?"
        return str2
    end

    local function fn14(cFrame)
        local character = localPlayer.Character
        local result = character or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart = result and result:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return false
        end
        humanoidRootPart.CFrame = cFrame
        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        return true
    end

    local tbl10 = {
        {
            Name = "Ancient Lochness Monster",
            Position = Vector3.new(6096.14, -585.92, 4669.5),
            LookDirection = Vector3.new(-0.8317, -0.4007, 0.3842),
            GetStats = function()
                local v7 = fn10()
                if not v7 then
                    return nil
                end

                local ok, result = pcall(function()
                    return v7["Event Tracker"].Main.Gui.Content.Items.Stats
                end)

                local v8 = ok and result or nil
                return v8
            end,
            GetCountdownText = function()
                local v7 = fn10()
                if not v7 then
                    return "?"
                end

                local ok, result = pcall(function()
                    return v7["Event Tracker"].Main.Gui.Content.Items.Countdown.Label.Text
                end)

                local str2 = ok and result or "?"
                return str2
            end,
        },
        {
            Name = "Mutant Runic Koi",
            Position = Vector3.new(-3140.386, -643.4843, -10451.0654),
            LookDirection = Vector3.new(1, 0, -0.0054),
            GetStats = function()
                local v7 = fn10()
                if not v7 then
                    return nil
                end

                local ok, result = pcall(function()
                    return v7["UnderwaterCity Event Tracker"].Main.Gui.Content.Items.Stats
                end)

                local v8 = ok and result or nil
                return v8
            end,
            GetCountdownText = function()
                local v7 = fn10()
                if not v7 then
                    return "?"
                end

                local ok, result = pcall(function()
                    return v7["UnderwaterCity Event Tracker"].Main.Gui.Content.Items.Countdown.Label.Text
                end)

                local str2 = ok and result or "?"
                return str2
            end,
        },
    }

    for i, v7 in ipairs(tbl10) do
        local tbl11 = {
            enabled = false,
            thread = nil,
            statusThread = nil,
            depsThread = nil,
            respawnConn = nil,
            savedPos = nil,
            isAtEvent = false,
            lastWasActive = false,
            depsReady = false,
        }

        local cframe = CFrame.lookAt(v7.Position, v7.Position + v7.LookDirection)
        local v8 = v4:AddSection("Auto " .. v7.Name, false)
        local v9 = v8:AddParagraph({Title = "Status", Content = "Idle"})

        v8:AddParagraph({
            Title = "Info",
            Content = "Saves current position before TP to event\nAuto return after event ends\n6 events per day",
        })

        v8:AddButton({
            Title = "Teleport to " .. v7.Name,
            Callback = function()
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    tbl11.savedPos = humanoidRootPart.CFrame
                end

                fn14(cframe)
            end,
        })

        v8:AddButton({
            Title = "Return to Saved Pos (" .. v7.Name .. ")",
            Callback = function()
                if not tbl11.savedPos then
                    lib:MakeNotify({
                        Title = v7.Name,
                        Description = "No saved position!",
                        Delay = 2,
                    })

                    return
                end

                fn14(tbl11.savedPos)
                tbl11.savedPos = nil
                tbl11.isAtEvent = false
            end,
        })

        v8:AddToggle({
            Title = "Auto " .. v7.Name .. " Teleport",
            Default = false,
            NoSave = true,
            Callback = function(enabled)
                tbl11.enabled = enabled

                if tbl11.statusThread then
                    pcall(task.cancel, tbl11.statusThread)
                    tbl11.statusThread = nil
                end

                if tbl11.thread then
                    pcall(task.cancel, tbl11.thread)
                    tbl11.thread = nil
                end

                if tbl11.depsThread then
                    pcall(task.cancel, tbl11.depsThread)
                    tbl11.depsThread = nil
                end

                if tbl11.respawnConn then
                    pcall(function()
                        tbl11.respawnConn:Disconnect()
                    end)

                    tbl11.respawnConn = nil
                end

                if not enabled then
                    v9:SetTitle("Status")
                    v9:SetContent("Idle")
                    tbl11.isAtEvent = false
                    tbl11.lastWasActive = false
                    return
                end

                tbl11.depsThread = task.spawn(function()
                    if not fn10() then
                        v9:SetTitle("Waiting...")
                        v9:SetContent("Waiting for DEPENDENCIES to load...")
                        local now = tick()

                        while not fn10() and tick() - now < 120 do
                            task.wait(1)
                            if not tbl11.enabled then
                                return
                            end
                        end

                        if not fn10() then
                            v9:SetTitle("Error")
                            v9:SetContent("DEPENDENCIES not found after 120s.\nTry re-enabling the toggle.")
                            tbl11.enabled = false
                            return
                        end
                    end

                    tbl11.depsReady = true

                    tbl11.statusThread = task.spawn(function()
                        while tbl11.enabled do
                            task.wait(1)

                            pcall(function()
                                fn11(v7.Position)

                                if fn12(v7) then
                                    v9:SetTitle("EVENT ACTIVE")
                                    local setContent = v9.SetContent
                                    local v10 = fn13(v7)
                                    local isAtEvent = tbl11.isAtEvent
                                    local str2 = isAtEvent and "At event location" or "Teleporting..."
                                    setContent(v9, "Time left: " .. v10 .. "\nStatus: " .. str2)
                                else
                                    v9:SetTitle("Waiting for Event")
                                    v9:SetContent("Starts in: " .. v7.GetCountdownText())
                                end
                            end)
                        end

                        v9:SetTitle("Status")
                        v9:SetContent("Idle")
                    end)

                    tbl11.respawnConn = localPlayer.CharacterAdded:Connect(function()
                        if not tbl11.enabled then
                            return
                        end
                        task.wait(3)

                        if fn12(v7) and tbl11.isAtEvent then
                            task.wait(1)
                            fn14(cframe)
                        end
                    end)

                    tbl11.thread = task.spawn(function()
                        while tbl11.enabled do
                            task.wait(1)

                            pcall(function()
                                fn11(v7.Position)
                                local v10 = fn12(v7)

                                if v10 and not tbl11.lastWasActive then
                                    tbl11.lastWasActive = true
                                    local character = localPlayer.Character
                                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                                    if humanoidRootPart then
                                        tbl11.savedPos = humanoidRootPart.CFrame
                                    end

                                    task.wait(0.5)

                                    if fn14(cframe) then
                                        tbl11.isAtEvent = true

                                        lib:MakeNotify({
                                            Title = v7.Name,
                                            Description = "Event active! Teleporting to location.",
                                            Delay = 3,
                                        })

                                        repeat
                                            task.wait(1)
                                            fn11(v7.Position)
                                        until not fn12(v7) or not tbl11.enabled

                                        if tbl11.enabled and tbl11.savedPos then
                                            task.wait(2)
                                            fn14(tbl11.savedPos)
                                            tbl11.isAtEvent = false
                                            tbl11.lastWasActive = false
                                            tbl11.savedPos = nil

                                            lib:MakeNotify({
                                                Title = v7.Name,
                                                Description = "Event ended! Returned to original position.",
                                                Delay = 3,
                                            })
                                        end
                                    end
                                elseif not v10 then
                                    tbl11.lastWasActive = false
                                    tbl11.isAtEvent = false
                                end
                            end)
                        end

                        if tbl11.respawnConn then
                            pcall(function()
                                tbl11.respawnConn:Disconnect()
                            end)

                            tbl11.respawnConn = nil
                        end

                        tbl11.isAtEvent = false
                        tbl11.lastWasActive = false
                    end)
                end)
            end,
        })
    end

    local v7 = v3:AddTab({Name = "Trade", Icon = "payment"})
    local v8 = nil
    local v9 = nil
    local v10 = nil
    local v11 = nil
    local v12 = nil
    local v13 = nil
    local v14 = nil

    pcall(function()
        v8 = fn3()
        v9 = fn(ReplicatedStorage.Shared.ItemUtility)
        v10 = fn(ReplicatedStorage.Shared.VendorUtility)
        v11 = fn(ReplicatedStorage.Shared.PlayerStatsUtility)
        v12 = fn(ReplicatedStorage.Shared.Trading.TradeData)
        v14 = fn(ReplicatedStorage.Shared:FindFirstChild("InventoryMapping"))
        v13 = fn2()
    end)

    local tbl11 = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
    }

    local n = 20
    local n2 = 5
    local n3 = 14

    pcall(function()
        local maxItemsInTrade = v12.MaxItemsInTrade

        if type(maxItemsInTrade) == "number" and maxItemsInTrade > 0 then
            n = math.floor(maxItemsInTrade)
        end

        local max = math.max
        local confirmCountdownTime = v12.ConfirmCountdownTime
        local n4 = confirmCountdownTime or 5
        local changeCountdownTime = v12.ChangeCountdownTime
        local n5 = changeCountdownTime or 5
        n2 = max(n4, n5)
        local tradeOfferExpiration = v12.TradeOfferExpiration
        local n6 = tradeOfferExpiration or 10
        n3 = n6 + 4
    end)

    local tbl12 = {addItem = 0.05, settle = 0.35}

    local tbl13 = {
        Fish = "Items",
        Gears = "Items",
        ["Enchant Stones"] = "Items",
        Equipment = "Items",
        Trophies = "Items",
        Charms = "Charms",
        Baits = "Baits",
        ["Fishing Rods"] = "Fishing Rods",
        Boats = "Boats",
        Emotes = "Emotes",
        Halos = "Halos",
        Lanterns = "Lanterns",
        Pets = "Pets",
        ["Pet Eggs"] = "Pet Eggs",
        Potions = "Potions",
        Totems = "Totems",
    }

    local function fn15(arg)
        if type(v14) == "table" and type(v14[arg]) == "string" then
            return v14[arg]
        end
        local v15 = tbl13[arg]
        local v16 = v15 or arg
        return v16
    end

    local tbl14 = {
        running = false,
        thread = nil,
        threadAlive = false,
        monitor = nil,
        toggle = nil,
        target = nil,
        mode = "ByName",
        status = "Idle",
        lastError = "",
        sent = {},
        blocked = {},
        activeCleanup = nil,
        item = nil,
        itemAmount = 1,
        coins = 0,
        rarity = "Common",
        rarityAmount = 1,
        stones = {},
        stoneAmount = 1,
        attempts = 0,
        success = 0,
        failed = 0,
        batches = 0,
        itemsSent = 0,
        coinsSent = 0,
        skipped = 0,
    }

    local function fn16()
        if not tbl14.monitor then
            return
        end

        pcall(function()
            local monitor = tbl14.monitor
            local setContent = monitor.SetContent
            local status = tbl14.status
            local itemsSent = tbl14.itemsSent
            local success = tbl14.success
            local attempts = tbl14.attempts
            local failed = tbl14.failed
            local str2 = tbl14.skipped > 0 and string.format("\nDilewati (ditolak server): %d", tbl14.skipped) or ""
            local str3 = tbl14.coinsSent > 0 and string.format("\nCoins: %d", tbl14.coinsSent) or ""
            setContent(monitor, string.format("%s\nTerkirim: %d unit | Batch sukses: %d | Percobaan: %d | Gagal: %d%s%s", status, itemsSent, success, attempts, failed, str2, str3))
        end)
    end

    local function fn17(status)
        if status == tbl14.status then
            return
        end
        tbl14.status = status
        fn16()
    end

    local function fn18()
        tbl14.attempts = 0
        tbl14.success = 0
        tbl14.failed = 0
        tbl14.batches = 0
        tbl14.itemsSent = 0
        tbl14.coinsSent = 0
        tbl14.skipped = 0
        tbl14.lastError = ""
        tbl14.sent = {}
        tbl14.blocked = {}
    end

    local function fn19(arg, arg2, ...)
        if not arg then
            return false, "no remote"
        end
        local tbl15 = {done = false, expired = false, result = nil}
        local v15 = table.pack(...)

        task.spawn(function()
            local v16 = table.pack(pcall(function()
                return arg:InvokeServer(table.unpack(v15, 1, v15.n))
            end))

            if not tbl15.expired then
                tbl15.result = v16
                tbl15.done = true
            end
        end)

        local n4 = os.clock() + arg2

        while not tbl15.done and os.clock() < n4 do
            task.wait(0.05)
        end

        if tbl15.done then
            return table.unpack(tbl15.result, 1, tbl15.result.n)
        end
        tbl15.expired = true
        return false, "timeout"
    end

    local function fn20(arg)
        local quantity = arg and arg.Quantity
        local n4 = type(quantity) == "number" and quantity > 0 and math.floor(quantity) or 1
        return n4
    end

    local function fn21(arg)
        local ok, result = pcall(function()
            local v15 = v13
            local v16 = v15

            if v15 then
                local v17 = v13
                local get = v17.Get
                local tbl15 = {}
                local str2 = arg or "Items"
                tbl15[1] = "Inventory"
                tbl15[2] = str2
                v16 = get(v17, tbl15)
            end

            return v16
        end)

        local tbl15 = ok and type(result) == "table" and result or {}
        return tbl15
    end

    local function fn22(arg, arg2)
        if not v9 or arg2 == nil then
            return nil
        end

        local ok, result = pcall(function()
            return v9.GetItemDataFromItemType(arg, arg2)
        end)

        if ok and result and result.Data then
            return result
        end
        return nil
    end

    local function fn23(arg, arg2)
        if not arg or not arg.Data then
            return "data item gak ketemu"
        end
        local type_ = arg.Data.Type

        if v12 then
            local find = table.find
            local tradableItemTypes = v12.TradableItemTypes
            local tbl15 = tradableItemTypes or {}

            if find(tbl15, type_) then
                local tradableItemsSkinOnly = v12.TradableItemsSkinOnly
                local tbl16 = tradableItemsSkinOnly or {}
                if tbl16[type_] and not arg.IsSkin then
                    return "cuma versi SKIN yang bisa ditrade"
                end
                local excludeCoinsItems = v12.ExcludeCoinsItems
                local tbl17 = excludeCoinsItems or {}
                if tbl17[type_] and arg.Price then
                    return "bisa dibeli pakai coin, jadi gak bisa ditrade"
                end

                if arg2 then
                    if arg2.Metadata and arg2.Metadata.TradeLock or arg.TradeLocked then
                        return "kena trade lock"
                    end

                    if typeof(arg2.PetCargo) == "table" and #arg2.PetCargo > 0 then
                        return "pet lagi bawa cargo"
                    end
                end

                if type_ ~= "Potions" and type_ ~= "Pets" and type_ ~= "Charms" and arg.Modifiers then
                    return "punya Modifiers"
                end
                return nil
            end
        end

        return string.format("tipe %s gak bisa ditrade", tostring(type_))
    end

    local function fn24(arg, arg2)
        if not arg or not arg.Data then
            return false
        end

        if v12 and type(v12.FollowTradeRules) == "function" then
            local ok, result = pcall(v12.FollowTradeRules, arg, arg2)
            if ok then
                local flag4 = result == true
                return flag4
            end
        end

        local flag4 = fn23(arg, arg2) == nil
        return flag4
    end

    local function fn25(arg)
        local v15 = tbl14.sent[arg]
        local v16 = v15 or tbl14.blocked[arg]
        return v16
    end

    local function fn26(arg)
        local tbl15 = {}
        local tbl16 = {}

        for i, v15 in ipairs(arg) do
            local bucket = v15.Bucket
            local str2 = bucket or "Items"
            tbl15[str2] = true
        end

        local v15, v16, v17 = pairs(tbl15)
        local v18 = v17
        local v19 = v15
        local v20 = v16

        while true do
            local v21 = v19(v20, v18)
            if v21 == nil then
                break
            end

            for i, v22 in ipairs(fn21(v21)) do
                if v22.UUID then
                    tbl16[v22.UUID] = fn20(v22)
                end
            end

            v18 = v21
        end

        local tbl17 = {}

        for i, v21 in ipairs(arg) do
            local uuid = v21.UUID
            local v22 = tbl16[v21.UUID]
            local n4 = v22 or 0
            tbl17[uuid] = n4
        end

        return tbl17
    end

    local function fn27(arg, arg2)
        local v15 = fn26(arg)
        local n4 = 0

        for i, v16 in ipairs(arg) do
            local v17 = arg2[v16.UUID]
            local n5 = v17 or 0
            local v18 = v15[v16.UUID]
            local n6 = v18 or 0
            local n7 = n5 - n6

            if n7 > 0 then
                n4 = n4 + n7
            end
        end

        return n4, v15
    end

    local function fn28(arg, arg2)
        local tbl15 = {}

        for i, v15 in ipairs(fn21(arg)) do
            local uuid = v15.UUID

            if uuid and not fn25(uuid) then
                local v16 = fn22(arg, v15.Id)

                if v16 and fn24(v16, v15) and arg2(v16, v15) then
                    local insert = table.insert
                    local tbl16 = {UUID = uuid, Bucket = arg, Category = v16.Data.Type}
                    local name = v16.Data.Name
                    local name2 = name or "?"
                    tbl16.Name = name2
                    tbl16.Stock = fn20(v15)
                    tbl16.Price = 0
                    insert(tbl15, tbl16)
                end
            end
        end

        return tbl15
    end

    local function fn29(arg)
        local n4 = 0

        for i, v15 in ipairs(arg) do
            n4 = n4 + v15.Stock
        end

        return n4
    end

    local function fn30(arg, arg2)
        table.sort(arg, function(arg3, arg4)
            if arg3.Stock == arg4.Stock then
                local flag4 = tostring(arg3.UUID) < tostring(arg4.UUID)
                return flag4
            end
            local flag4 = arg3.Stock < arg4.Stock
            return flag4
        end)

        local tbl15 = {}

        for i = 1, math.min(n, arg2, #arg) do
            tbl15[i] = arg[i]
        end

        return tbl15, #tbl15
    end

    local function fn31()
        return workspace:GetServerTimeNow()
    end

    local function fn32(arg)
        local flag4 = arg and arg.Parent and arg:GetAttribute("IsTrading") and true or false
        return flag4
    end

    local function fn33(arg, arg2)
        local now = os.clock()
        local n4 = arg2 or 25
        local n5 = now + n4

        while os.clock() < n5 do
            if not tbl14.running then
                return false
            end

            if not fn32(localPlayer) and not fn32(arg) then
                return true
            end
            fn17("Nunggu trade sebelumnya kelar...")
            task.wait(0.2)
        end

        local flag4

        if fn32(localPlayer) then
            flag4 = false
        else
            flag4 = true
        end

        if flag4 then
            if fn32(arg) then
                flag4 = false
            else
                flag4 = true
            end
        end

        return flag4
    end

    local function fn34(arg)
        if not v8 or not v8.Client then
            return true
        end

        local ok, result = pcall(function()
            return v8.Client:GetReplion("ReplicatedPlayerData")
        end)

        if not ok or not result then
            return true
        end

        local ok2, result2 = pcall(function()
            return result:Get("User_" .. arg.UserId)
        end)

        if not ok2 or type(result2) ~= "table" then
            return true
        end
        local tradeSettings = result2.TradeSettings
        if type(tradeSettings) ~= "table" then
            return true
        end
        local flag4 = tradeSettings.Trades == true
        return flag4
    end

    local function fn35(arg, arg2)
        if not tbl14.running or not v12 or not v8 then
            return false, 0
        end
        local findFirstChild = Players.FindFirstChild
        local target = tbl14.target
        local str2 = target or ""
        local v15 = findFirstChild(Players, str2)

        if not v15 then
            tbl14.lastError = "target player gak ada di server"
            fn17("Error: " .. tbl14.lastError)
            return false, 0
        end

        if not fn34(v15) then
            tbl14.lastError = string.format("%s lagi matiin trade request di setting-nya", v15.Name)
            fn17("Error: " .. tbl14.lastError)
            return false, 0
        end

        if not fn33(v15, 25) then
            if not tbl14.running then
                return false, 0
            end
            tbl14.failed = tbl14.failed + 1
            tbl14.lastError = "salah satu pemain masih nyangkut di trade sebelumnya"
            fn17("Gagal: " .. tbl14.lastError)
            return false, 0
        end

        tbl14.attempts = tbl14.attempts + 1
        local name = #arg == 1 and arg[1].Name or string.format("%d item", #arg)
        local str3 = tostring(localPlayer.UserId)

        local tbl15 = {
            replion = nil,
            replionId = nil,
            result = nil,
            offerSent = false,
            alive = true,
            conns = {},
        }

        local function fn36(arg3, arg4)
            local ok, result = pcall(function()
                return arg3:Connect(arg4)
            end)

            if ok and result then
                table.insert(tbl15.conns, result)
            end
        end

        local function activeCleanup()
            tbl15.alive = false

            for i, conn in ipairs(tbl15.conns) do
                pcall(function()
                    conn:Disconnect()
                end)
            end

            table.clear(tbl15.conns)

            if tbl14.activeCleanup then
                tbl14.activeCleanup = nil
            end
        end

        tbl14.activeCleanup = activeCleanup

        local function fn37(replion)
            if not tbl15.alive or tbl15.replion then
                return
            end

            if not replion or replion.Destroyed then
                return
            end
            local data = replion.Data
            if type(data) ~= "table" then
                return
            end

            if type(data.Players) ~= "table" or not data.Players[str3] then
                return
            end
            tbl15.replion = replion
        end

        local function fn38(arg3)
            if not arg3 then
                return nil
            end

            local ok, result = pcall(function()
                return v8.Client:GetReplion(arg3)
            end)

            local v16 = ok and result or nil
            return v16
        end

        fn36(v12.Remotes.TradeCompleted.OnClientEvent, function()
            if tbl15.offerSent and tbl15.result == nil then
                tbl15.result = true
            end
        end)

        fn36(v12.Remotes.TradeEnded.OnClientEvent, function()
            if tbl15.offerSent and tbl15.result == nil then
                tbl15.result = false
            end
        end)

        fn36(v12.Remotes.TradeStarted.OnClientEvent, function(replionId)
            if not tbl15.alive then
                return
            end
            tbl15.replionId = replionId
            fn37(fn38(replionId))
        end)

        pcall(function()
            local v16 = v8.Client:OnReplionAdded(function(arg3)
                if tbl15.alive then
                    fn37(arg3)
                end
            end)

            if v16 then
                table.insert(tbl15.conns, v16)
            end
        end)

        local function fn39()
            local replion = tbl15.replion
            if not replion or replion.Destroyed then
                return nil
            end
            local data = replion.Data
            local flag4 = type(data) == "table" and data or nil
            return flag4
        end

        local function fn40()
            local v16 = fn39()
            local flag4 = v16 and type(v16.Players) == "table" and v16.Players[str3] or nil
            return flag4
        end

        local function fn41()
            local running = tbl14.running
            local flag4 = running and tbl15.result == nil and fn39() ~= nil
            return flag4
        end

        local function fn42()
            local v16 = fn39()
            local lastModifiedTime = v16 and v16.LastModifiedTime
            if type(lastModifiedTime) == "number" then
                return lastModifiedTime + n2 - fn31()
            end
            return 0
        end

        local function fn43()
            local v16 = fn40()
            if not v16 or type(v16.Items) ~= "table" then
                return nil
            end
            local tbl16 = {}
            local v17, v18, v19 = pairs(v16.Items)
            local v20 = v19
            local v21 = v17
            local v22 = v18

            while true do
                local v23, v24 = v21(v22, v20)
                if v23 == nil then
                    break
                end
                v20 = v23

                if type(v24) == "table" then
                    for k, v25 in pairs(v24) do
                        local uuid = type(v25) == "table" and v25.UUID or k

                        if type(uuid) == "string" then
                            tbl16[uuid] = true
                        end
                    end

                    v20 = v23
                end
            end

            return tbl16
        end

        local v16 = nil

        local function fn44(arg3, arg4, arg5)
            if not v16 then
                return
            end
            local now = os.clock()
            local n4 = arg5 or 6
            local n5 = now + n4

            while os.clock() < n5 do
                if arg4 <= fn27(arg3, v16) then
                    return
                end
                task.wait(0.15)
            end
        end

        local function fn45(arg3, arg4)
            activeCleanup()
            local v17 = v16
            local v18 = v17 or fn26(arg3)
            v16 = v18

            if arg4 ~= false then
                local n4 = #arg3
                local n5 = arg4 and 6 or 3
                fn44(arg3, n4, n5)
            end

            local v19, v20 = fn27(arg3, v16)

            for i, v21 in ipairs(arg3) do
                local v22 = v20[v21.UUID]
                local n4 = v22 or 0

                if n4 <= 0 then
                    tbl14.sent[v21.UUID] = true
                end
            end

            local flag4 = v19 > 0

            if flag4 then
                tbl14.success = tbl14.success + 1
                tbl14.itemsSent = tbl14.itemsSent + v19
                local coinsSent = tbl14.coinsSent
                local n4 = arg2 or 0
                tbl14.coinsSent = coinsSent + n4
                fn17(string.format("Sukses: %s - %d unit pindah (total %d)", name, v19, tbl14.itemsSent))
            else
                tbl14.failed = tbl14.failed + 1

                if tbl14.lastError == "" then
                    tbl14.lastError = "trade kelar tapi gak ada item yang pindah"
                end

                fn17(string.format("Gagal: %s", name))
            end

            task.wait(tbl12.settle)
            return flag4, v19
        end

        local function fn46(lastError, arg3)
            tbl14.lastError = lastError

            task.spawn(function()
                pcall(function()
                    v12.Remotes.CancelTrade:InvokeServer()
                end)
            end)

            activeCleanup()
            local n4 = 0

            if arg3 and v16 then
                task.wait(0.5)
                local v17, v18 = fn27(arg3, v16)
                n4 = v17

                for i, v19 in ipairs(arg3) do
                    local v20 = v18[v19.UUID]
                    local n5 = v20 or 0

                    if n5 <= 0 then
                        tbl14.sent[v19.UUID] = true
                    end
                end
            end

            if n4 > 0 then
                tbl14.success = tbl14.success + 1
                tbl14.itemsSent = tbl14.itemsSent + n4
                fn17(string.format("Sukses (nyusul): %s - %d unit pindah", name, n4))
                task.wait(tbl12.settle)
                return true, n4
            end

            tbl14.failed = tbl14.failed + 1
            fn17(lastError)
            task.wait(0.8)
            return false, 0
        end

        fn17(string.format("Kirim offer ke %s: %s", v15.Name, name))
        local v17, v18, v19 = fn19(v12.Remotes.SendTradeOffer, 10, v15)

        if v17 and v18 then
            tbl15.offerSent = true
            fn17("Nunggu target nerima offer...")
            local n4 = os.clock() + n3

            while tbl15.alive and not tbl15.replion and os.clock() < n4 do
                if not tbl14.running then
                    activeCleanup()
                    return false, 0
                end

                if tbl15.result ~= nil then
                    return fn45(arg, tbl15.result)
                end

                if tbl15.replionId then
                    fn37(fn38(tbl15.replionId))
                end

                task.wait(0.1)
            end

            if not tbl15.replion then
                return fn46(string.format("Target gak nerima offer dalam %ds", n3))
            end
            v16 = fn26(arg)
            fn17(string.format("Masukin %d item ke offer...", #arg))
            local tbl16 = {}

            for i, v20 in ipairs(arg) do
                tbl16[v20.UUID] = true
            end

            local n5 = os.clock() + 75
            local n6 = 0

            while true do
                local n7 = n6 + 1
                if n7 > 3 then
                    break
                end
                local tbl17 = {}

                for i, v20 in ipairs(arg) do
                    if tbl16[v20.UUID] then
                        table.insert(tbl17, v20)
                    end
                end

                if #tbl17 == 0 then
                    break
                end

                for i, v20 in ipairs(tbl17) do
                    if not fn41() or n5 < os.clock() then
                        break
                    end
                    local v21, v22, v23 = fn19(v12.Remotes.AddItem, 8, v20.Category, v20.UUID)

                    if v21 and v22 then
                        tbl16[v20.UUID] = nil
                    elseif v21 then
                        tbl16[v20.UUID] = nil
                        tbl14.blocked[v20.UUID] = true
                        tbl14.skipped = tbl14.skipped + 1
                        local name2 = v20.Name
                        local v24 = tostring
                        local v25 = v23 or v22
                        tbl14.lastError = string.format("%s ditolak: %s", name2, v24(v25))
                    end

                    task.wait(tbl12.addItem)
                end

                n6 = n7
                local v20 = fn43()

                if v20 then
                    for k in pairs(v20) do
                        if tbl16[k] then
                            tbl16[k] = nil
                        end

                        if tbl14.blocked[k] then
                            tbl14.blocked[k] = nil
                            tbl14.skipped = math.max(0, tbl14.skipped - 1)
                        end
                    end

                    n6 = n7
                end

                if next(tbl16) == nil or not fn41() or n5 < os.clock() then
                    break
                end
                task.wait(0.3)
            end

            if tbl15.result ~= nil then
                return fn45(arg, tbl15.result)
            end

            if not fn41() then
                return fn46("Trade keburu berakhir pas masukin item", arg)
            end
            local v20 = fn43()
            local tbl17 = {}

            for i, v21 in ipairs(arg) do
                if v20 then
                    if v20[v21.UUID] then
                        table.insert(tbl17, v21)
                    end
                elseif not tbl16[v21.UUID] and not tbl14.blocked[v21.UUID] then
                    table.insert(tbl17, v21)
                end
            end

            if #tbl17 == 0 then
                return fn46("Gak ada item yang berhasil masuk ke offer", arg)
            end
            local n7 = os.clock() + 60

            while os.clock() < n7 and fn41() do
                local v21 = fn42()
                if v21 <= 0 then
                    break
                end
                fn17(string.format("Lock countdown: %.1fs (%d item siap)", v21, #tbl17))
                task.wait(math.clamp(v21, 0.1, 0.5))
            end

            if tbl15.result ~= nil then
                return fn45(tbl17, tbl15.result)
            end

            if not fn41() then
                return fn46("Trade berakhir pas lock countdown", tbl17)
            end

            local function fn47()
                local v21 = fn40()
                local flag4 = v21 ~= nil and v21.IsReady == true
                return flag4
            end

            local function fn48()
                local v21 = fn39()
                if not v21 then
                    return false
                end

                if v21.PlayersReady == true then
                    return true
                end

                if type(v21.PlayersReady) ~= "table" then
                    return false
                end
                local flag4 = false

                for k, v22 in pairs(v21.PlayersReady) do
                    if not v22 then
                        return false
                    end
                    flag4 = true
                end

                return flag4
            end

            fn17(string.format("Set ready (%d item)...", #tbl17))
            local n8 = os.clock() + 180
            local n9 = 0
            local flag4 = false

            while os.clock() < n8 and fn41() do
                if not fn48() then
                    if not fn47() and fn42() <= 0 and n9 <= os.clock() then
                        n9 = os.clock() + 1.2
                        fn19(v12.Remotes.SetReady, 8, true)
                    elseif fn47() then
                        fn17("Nunggu lawan ready...")
                    end

                    task.wait(0.15)
                    continue
                end

                flag4 = true
                break
            end

            if tbl15.result ~= nil then
                return fn45(tbl17, tbl15.result)
            end

            if not fn41() then
                return fn46("Trade berakhir pas nunggu ready", tbl17)
            end

            if not flag4 then
                return fn46("Lawan gak ready dalam 180s", tbl17)
            end

            local function fn49()
                local v21 = fn40()
                local flag5 = v21 ~= nil and v21.IsConfirmed == true
                return flag5
            end

            fn17("Konfirmasi trade...")
            local n10 = os.clock() + 180
            local n11 = 0

            while tbl15.result == nil and os.clock() < n10 and tbl14.running and fn39() ~= nil do
                if not fn49() and fn42() <= 0 and n11 <= os.clock() then
                    n11 = os.clock() + 1.2

                    task.spawn(function()
                        pcall(function()
                            v12.Remotes.ConfirmTrade:InvokeServer()
                        end)
                    end)
                elseif fn49() then
                    fn17("Nunggu lawan konfirmasi...")
                end

                task.wait(0.15)
            end

            if tbl15.result == nil and n10 <= os.clock() then
                return fn46("Lawan gak konfirmasi dalam 180s", tbl17)
            end
            return fn45(tbl17, tbl15.result)
        end

        activeCleanup()
        tbl14.failed = tbl14.failed + 1
        local v20 = tostring
        local str4 = v19 or v18 or "?"
        tbl14.lastError = "Gagal kirim offer: " .. v20(str4)
        fn17(tbl14.lastError)
        task.wait(1)
        return false, 0
    end

    local v15 = (function(arg, arg2)
        local tbl15 = arg2 or {}
        local v15 = tbl15

        local tbl16 = {
            itemType = arg,
            bucket = fn15(arg),
            names = {},
            blockedNames = {},
        }

        local tbl17 = {}

        tbl16.buildCatalog = function()
            tbl16.names = {}
            tbl16.blockedNames = {}

            pcall(function()
                if not v9 or not v15.getAll then
                    return
                end
                local tbl18 = {}
                local v16 = pairs
                local v17 = v15.getAll()
                local tbl19 = v17 or {}

                for k, v18 in v16(tbl19) do
                    local data = v18 and v18.Data

                    if type(data) == "table" and data.Name and data.Type == arg and not tbl18[data.Name] and (not v15.filter or v15.filter(v18)) then
                        tbl18[data.Name] = true

                        if fn24(v18, tbl17) then
                            table.insert(tbl16.names, data.Name)
                        else
                            local blockedNames = tbl16.blockedNames
                            local name = data.Name
                            local v19 = fn23(v18, tbl17)
                            local str2 = v19 or "ditolak server"
                            blockedNames[name] = str2
                        end
                    end
                end

                table.sort(tbl16.names)
            end)

            return tbl16.names
        end

        tbl16.countOwned = function()
            local tbl18 = {}
            local tbl19 = {}

            for i, v16 in ipairs(fn21(tbl16.bucket)) do
                local v17 = fn22(tbl16.bucket, v16.Id)

                if v17 and v17.Data.Type == arg and (not v15.filter or v15.filter(v17)) then
                    local name = v17.Data.Name
                    local str2 = name or "?"
                    local v18 = tbl18[str2]
                    local n4 = v18 or 0
                    tbl18[str2] = n4 + fn20(v16)

                    if not fn24(v17, v16) then
                        local v19 = fn23(v17, v16)
                        local str3 = v19 or "ditolak server"
                        tbl19[str2] = str3
                    end
                end
            end

            return tbl18, tbl19
        end

        tbl16.collect = function(arg3)
            return fn28(tbl16.bucket, function(arg4)
                if arg4.Data.Type ~= arg then
                    return false
                end

                if v15.filter and not v15.filter(arg4) then
                    return false
                end
                local name = arg4.Data.Name
                local str2 = name or "?"
                local flag4 = arg3[str2] == true
                return flag4
            end)
        end

        return tbl16
    end)("Enchant Stones", {
        getAll = function()
            return v9:GetEnchantStones()
        end,
    })

    local function fn36(arg)
        return fn28("Items", function(arg2, arg3)
            local flag4 = arg2.Data.Type == "Fish" and arg3.Favorited ~= true and arg(arg2, arg3)
            return flag4
        end)
    end

    local tbl15 = {
        ByName = {
            label = "ikan",
            collect = function()
                return fn36(function(arg)
                    local flag4 = arg.Data.Name == tbl14.item
                    return flag4
                end)
            end,
            total = function()
                return tbl14.itemAmount
            end,
            empty = "Ikan itu gak ada / gak bisa ditrade",
            needSelection = function()
                local flag4 = tbl14.item ~= nil
                return flag4
            end,
            missing = "pilih ikan dulu di dropdown",
        },
        ByRarity = {
            label = "ikan",
            collect = function()
                return fn36(function(arg)
                    local flag4 = tbl11[arg.Data.Tier] == tbl14.rarity
                    return flag4
                end)
            end,
            total = function()
                return tbl14.rarityAmount
            end,
            empty = "Gak ada ikan dengan rarity itu",
        },
        ByEnchantStone = {
            label = "enchant stone",
            collect = function()
                return v15.collect(tbl14.stones)
            end,
            total = function()
                return tbl14.stoneAmount
            end,
            empty = "Enchant stone terpilih habis / gak bisa ditrade",
            needSelection = function()
                local flag4 = next(tbl14.stones) ~= nil
                return flag4
            end,
            missing = "pilih enchant stone dulu di dropdown",
        },
        ByCoin = {
            label = "ikan",
            byCoin = true,
            total = function()
                return tbl14.coins
            end,
            empty = "Gak ada ikan yang bisa dijual",
        },
    }

    local function fn37()
        local n4 = 1

        pcall(function()
            local playerModifiers = v11:GetPlayerModifiers(localPlayer)
            local coinMultiplier = playerModifiers and playerModifiers.CoinMultiplier or 1
            n4 = coinMultiplier
        end)

        local tbl16 = {}

        for i, v16 in ipairs(fn21("Items")) do
            local uuid = v16.UUID

            if uuid and not fn25(uuid) and v16.Favorited ~= true then
                local Items = fn22("Items", v16.Id)

                if Items and Items.Data.Type == "Fish" and fn24(Items, v16) then
                    local price = 0

                    pcall(function()
                        local sellPrice = v10:GetSellPrice(v16)
                        local sellPrice2 = sellPrice or Items.SellPrice or 0
                        price = sellPrice2
                    end)

                    if price == 0 then
                        local sellPrice = Items.SellPrice
                        local n5 = sellPrice or 0
                        price = n5
                    end

                    price = math.ceil(price * n4)

                    if price > 0 then
                        local insert = table.insert
                        local tbl17 = {UUID = uuid, Bucket = "Items", Category = "Fish"}
                        local name = Items.Data.Name
                        local name2 = name or "?"
                        tbl17.Name = name2
                        tbl17.Stock = fn20(v16)
                        tbl17.Price = price
                        insert(tbl16, tbl17)
                    end
                end
            end
        end

        table.sort(tbl16, function(arg, arg2)
            local flag4 = arg.Price < arg2.Price
            return flag4
        end)

        return tbl16
    end

    local function fn38(arg)
        local n4 = math.min(2 + arg, 8)
        local lastError = tbl14.lastError ~= "" and tbl14.lastError or "gak diketahui"
        fn17(string.format("Gagal (%d/%d), ulangi %ds lagi... [%s]", arg, 10, n4, lastError))

        for i = 1, math.ceil(n4 / 0.25) do
            if not tbl14.running then
                return
            end
            task.wait(0.25)
        end
    end

    local function fn39(arg)
        local v16 = arg.total()
        local n4 = v16
        if v16 <= 0 then
            fn17("Error: target coins harus lebih dari 0")
            return
        end
        local n5 = 0

        while tbl14.running and n4 > 0 do
            local v17 = fn37()
            if #v17 == 0 then
                fn17("Berhenti: " .. arg.empty)
                break
            end
            local tbl16 = {}
            local n6 = 0

            for i, v18 in ipairs(v17) do
                if n <= #tbl16 or n4 <= n6 then
                    break
                end
                table.insert(tbl16, v18)
                n6 = n6 + v18.Price
            end

            if #tbl16 == 0 then
                break
            end
            fn17(string.format("Batch %d - %d ikan ~%d coins", tbl14.success + 1, #tbl16, n6))

            if not fn35(tbl16, n6) then
                if not tbl14.running then
                    break
                end
                local n7 = n5 + 1
                n5 = n7

                if n7 >= 10 then
                    local lastError = tbl14.lastError ~= "" and tbl14.lastError or "gak diketahui"
                    fn17(string.format("Berhenti: gagal %dx berturut-turut. Terakhir: %s", n7, lastError))
                    break
                end

                fn38(n7)
                continue
            end

            n5 = 0
            n4 = n4 - n6
        end
    end

    local function fn40(arg)
        if arg.needSelection and not arg.needSelection() then
            local missing = arg.missing
            local error = missing or "pilihan belum diisi"
            fn17("Error: " .. error)
            return
        end

        local v16 = arg.total()
        local v17 = v16
        if v16 < 1 then
            fn17("Error: jumlah harus lebih dari 0")
            return
        end
        local v18 = fn29(arg.collect())
        if v18 == 0 then
            fn17("Error: " .. arg.empty)
            return
        end

        if v18 < v16 then
            v17 = v18
        end

        tbl14.batches = math.max(1, math.ceil(v17 / n))
        fn17(string.format("Mulai: %d unit %s (punya %d)", v17, arg.label, v18))
        local n4 = 0
        local n5 = 0

        while tbl14.running and n4 < v17 do
            local v19 = arg.collect()
            if #v19 == 0 then
                fn17(string.format("Berhenti: %s (%d/%d unit terkirim)", arg.empty, n4, v17))
                break
            end
            local v20, v21 = fn30(v19, v17 - n4)
            if #v20 == 0 then
                break
            end
            local n6 = 0

            for i, v22 in ipairs(v20) do
                if v22.Stock > 1 then
                    n6 = n6 + 1
                end
            end

            local n7 = tbl14.success + 1
            local str2 = n6 > 0 and string.format(" (%d dari stack)", n6) or ""
            fn17(string.format("Batch %d - kirim %d unit%s | progress %d/%d", n7, v21, str2, n4, v17))
            local v22, v23 = fn35(v20, 0)

            if not v22 then
                if not tbl14.running then
                    break
                end
                local n8 = n5 + 1
                n5 = n8

                if n8 >= 10 then
                    local lastError = tbl14.lastError ~= "" and tbl14.lastError or "gak diketahui"
                    fn17(string.format("Berhenti: gagal %dx berturut-turut (%d/%d unit). Terakhir: %s", n8, n4, v17, lastError))
                    break
                end

                fn38(n8)
                continue
            end

            n5 = 0
            local flag4 = v23 > 0 and v23 or v21
            local n8 = n4 + flag4
            n4 = n8

            if n8 < v17 and tbl14.running then
                fn17(string.format("Terkirim %d/%d unit. Lanjut...", n8, v17))
            end
        end
    end

    local function fn41()
        if not tbl14.running then
            return
        end
        tbl14.running = false

        if tbl14.activeCleanup then
            pcall(tbl14.activeCleanup)
        end

        task.spawn(function()
            pcall(function()
                v12.Remotes.CancelTrade:InvokeServer()
            end)
        end)

        fn17(string.format("Dihentikan - %d unit terkirim", tbl14.itemsSent))
    end

    local function fn42(mode, monitor, toggle)
        if tbl14.running then
            fn41()
        end

        local n4 = os.clock() + 12

        while tbl14.threadAlive and os.clock() < n4 do
            task.wait(0.1)
        end

        if tbl14.threadAlive then
            if tbl14.thread then
                pcall(task.cancel, tbl14.thread)
            end

            tbl14.threadAlive = false
            tbl14.thread = nil
        end

        tbl14.monitor = monitor
        tbl14.toggle = toggle
        tbl14.mode = mode

        local function fn43(error)
            fn17("Error: " .. error)

            task.defer(function()
                pcall(function()
                    toggle:SetValue(false)
                end)
            end)
        end

        if not v12 or not v8 then
            return fn43("modul trade gagal dimuat")
        end

        if not v13 then
            v13 = fn2()
            if not v13 then
                return fn43("data inventory belum siap, coba lagi")
            end
        end

        if not tbl14.target then
            return fn43("target player belum dipilih")
        end
        local v16 = Players:FindFirstChild(tbl14.target)
        if not v16 then
            return fn43("target player gak ada di server")
        end

        if not fn34(v16) then
            return fn43(string.format("%s matiin trade request di setting-nya", v16.Name))
        end
        local v17 = tbl15[mode]
        if not v17 then
            return fn43("mode trade gak dikenal")
        end
        fn18()
        tbl14.running = true
        tbl14.threadAlive = true
        fn17("Mulai...")

        tbl14.thread = task.spawn(function()
            local ok, result = pcall(function()
                if v17.byCoin then
                    fn39(v17)
                else
                    fn40(v17)
                end
            end)

            if not ok then
                tbl14.lastError = tostring(result)
                fn17("Error: " .. tostring(result))
            end

            if tbl14.running then
                tbl14.running = false
                local status = tbl14.status
                local str2 = status or ""

                if not str2:find("^Berhenti") and not str2:find("^Error") then
                    local str3 = tbl14.attempts == 0 and "Selesai: gak ada trade yang dijalankan" or string.format("Selesai - %d unit terkirim", tbl14.itemsSent)
                    fn17(str3)
                end
            end

            if tbl14.activeCleanup then
                pcall(tbl14.activeCleanup)
            end

            tbl14.threadAlive = false

            pcall(function()
                toggle:SetValue(false)
            end)
        end)
    end

    local v16 = v7:AddSection("Select Player", false)

    local v17 = v16:AddDropdown({
        Title = "Target Player",
        Options = {},
        Default = nil,
        NoSave = true,
        Callback = function(target)
            tbl14.target = target
        end,
    })

    v16:AddButton({
        Title = "Refresh Players",
        Callback = function()
            local tbl16 = {}

            for i, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    table.insert(tbl16, player.Name)
                end
            end

            table.sort(tbl16)

            pcall(function()
                v17:SetOptions(tbl16)
            end)
        end,
    })

    v16:AddParagraph({
        Title = "Info",
        Content = "Trade By Name, By Rarity dan By Coin <b>melewati ikan yang di-Favorite</b>. Trade Enchant Stone ke bawah tetap ikut ngirim item yang di-Favorite.\n\nServer cuma mindahin <b>1 unit per entry tiap trade</b>. Jadi item yang kepecah-pecah bisa dikirim sampai 20 sekaligus, sedangkan item yang numpuk jadi 1 stack kekirimnya satu-satu tiap trade sampai jumlahnya kekejar.",
    })

    local function fn43(arg, arg2, arg3, arg4)
        local v18 = v7:AddSection(arg, false)
        local v19 = v18:AddParagraph({Title = "Status", Content = "Idle"})
        arg4(v18, v19)
        local v20 = nil

        v20 = v18:AddToggle({
            Title = arg3,
            Default = false,
            NoSave = true,
            Callback = function(arg5)
                if arg5 then
                    fn42(arg2, v19, v20)
                else
                    fn41()
                end
            end,
        })

        v18:AddButton({
            Title = "Reset Stats",
            Callback = function()
                if tbl14.running then
                    return
                end
                fn18()
                tbl14.monitor = v19
                tbl14.status = ""
                fn17("Idle")
            end,
        })

        return v19
    end

    fn43("Trade By Name", "ByName", "Start Trade ByName", function(arg)
        local v18 = arg:AddDropdown({
            Title = "Select Item",
            Options = {},
            Default = nil,
            Callback = function(arg2)
                if arg2 then
                    local match = arg2:match("^(.-) x%d+$")
                    local v18 = match or arg2
                    tbl14.item = v18
                end
            end,
        })

        arg:AddButton({
            Title = "Refresh Fish Items",
            Callback = function()
                local tbl16 = {}

                for i, v19 in ipairs(fn21("Items")) do
                    local Items = v19.Favorited ~= true and fn22("Items", v19.Id)

                    if Items and Items.Data.Type == "Fish" and fn24(Items, v19) then
                        local name = Items.Data.Name
                        local str2 = name or "?"
                        local v20 = tbl16[str2]
                        local n4 = v20 or 0
                        tbl16[str2] = n4 + fn20(v19)
                    end
                end

                local tbl17 = {}

                for k, v19 in pairs(tbl16) do
                    table.insert(tbl17, string.format("%s x%d", k, v19))
                end

                table.sort(tbl17)

                pcall(function()
                    v18:SetOptions(tbl17)
                end)
            end,
        })

        arg:AddInput({
            Title = "Amount Fish Name",
            Default = "1",
            Callback = function(arg2)
                local max = math.max
                local floor = math.floor
                local num = tonumber(arg2)
                local n4 = num or 1
                tbl14.itemAmount = max(1, floor(n4))
            end,
        })
    end)

    fn43("Trade By Coin", "ByCoin", "Start Trade ByCoin", function(arg)
        arg:AddInput({
            Title = "Target Coins",
            Default = "0",
            Callback = function(arg2)
                local max = math.max
                local floor = math.floor
                local num = tonumber(arg2)
                local n4 = num or 0
                tbl14.coins = max(0, floor(n4))
            end,
        })
    end)

    fn43("Trade By Rarity", "ByRarity", "Start Trade ByRarity", function(arg)
        arg:AddDropdown({
            Title = "Select Rarity",
            Options = {
                "Common",
                "Uncommon",
                "Rare",
                "Epic",
                "Legendary",
                "Mythic",
                "Secret",
            },
            Default = "Common",
            Callback = function(rarity)
                tbl14.rarity = rarity
            end,
        })

        arg:AddInput({
            Title = "Amount Fish Rarity",
            Default = "1",
            Callback = function(arg2)
                local max = math.max
                local floor = math.floor
                local num = tonumber(arg2)
                local n4 = num or 1
                tbl14.rarityAmount = max(1, floor(n4))
            end,
        })
    end);

    (function(arg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        return fn43(arg, arg2, arg3, function(arg10, arg11)
            if arg5 then
                arg10:AddParagraph({Title = "Info", Content = arg5})
            end

            arg4.buildCatalog()
            local addDropdown = arg10.AddDropdown
            local tbl16 = {Title = arg6}
            local names = #arg4.names > 0 and arg4.names

            if not names then
                local tbl17 = {}
                names = tbl17
                tbl17[1] = "Tidak ada yang bisa ditrade"
            end

            tbl16.Options = names
            tbl16.Default = {}
            tbl16.Multi = true

            tbl16.Callback = function(arg12)
                local tbl17 = {}

                if type(arg12) == "table" then
                    for i, v18 in ipairs(arg12) do
                        tbl17[v18] = true
                    end
                end

                arg9(tbl17, nil)
            end

            local v18 = addDropdown(arg10, tbl16)

            arg10:AddInput({
                Title = arg7,
                Default = "1",
                Callback = function(arg12)
                    local max = math.max
                    local floor = math.floor
                    local num = tonumber(arg12)
                    local n4 = num or 1
                    arg9(nil, max(1, floor(n4)))
                end,
            })

            arg10:AddButton({
                Title = "Check " .. arg8,
                Callback = function()
                    local v19, v20 = arg4.countOwned()
                    local tbl17 = {}

                    for k, v21 in pairs(v19) do
                        local insert = table.insert
                        local v22 = v20[k]
                        local str2 = v22 and "  [GAK BISA: " .. v20[k] .. "]" or ""
                        insert(tbl17, string.format("%s x%d%s", k, v21, str2))
                    end

                    table.sort(tbl17)

                    pcall(function()
                        local setContent = arg11.SetContent
                        local str2 = #tbl17 > 0 and arg8 .. " di inventory:\n" .. table.concat(tbl17, "\n") or "Gak ada " .. arg8 .. " di inventory"
                        setContent(arg11, str2)
                    end)
                end,
            })

            arg10:AddButton({
                Title = "Refresh " .. arg8 .. " List",
                Callback = function()
                    arg4.buildCatalog()

                    pcall(function()
                        local setOptions = v18.SetOptions
                        local names2 = #arg4.names > 0 and arg4.names

                        if not names2 then
                            local tbl17 = {}
                            names2 = tbl17
                            tbl17[1] = "Tidak ada yang bisa ditrade"
                        end

                        setOptions(v18, names2)
                    end)

                    local tbl17 = {}

                    for k, blockedName in pairs(arg4.blockedNames) do
                        table.insert(tbl17, string.format("%s - %s", k, blockedName))
                    end

                    table.sort(tbl17)

                    pcall(function()
                        local setContent = arg11.SetContent
                        local n4 = #arg4.names
                        local str2 = #tbl17 > 0 and "\n\nDikunci server:\n" .. table.concat(tbl17, "\n") or ""
                        setContent(arg11, string.format("List diperbarui: %d %s bisa ditrade.%s", n4, arg8, str2))
                    end)
                end,
            })
        end)
    end)("Trade Enchant Stone", "ByEnchantStone", "Start Trade EnchantStone", v15, "Nama stone diambil langsung dari game, jadi selalu ikut update. Stone yang di-lock server (contoh: <b>Transcended Stone</b>) sengaja gak dimunculin karena AddItem-nya pasti ditolak.", "Pilih Enchant Stone", "Amount Enchant Stone", "Enchant Stone", function(stones, stoneAmount)
        if stones then
            tbl14.stones = stones
        end

        if stoneAmount then
            tbl14.stoneAmount = stoneAmount
        end
    end)

    local v18 = v7:AddSection("Auto Accept Trade", false)

    local tbl16 = {
        enabled = false,
        hooked = false,
        origFire = nil,
        conns = {},
    }

    v18:AddParagraph({
        Title = "Info",
        Content = "Auto accept semua trade request masuk tanpa klik. Otomatis nonaktif sementara kalau auto trade di atas lagi jalan, biar gak saling rebutan nge-confirm sebelum item masuk.",
    })

    local function fn44(arg)
        local str2 = tostring(localPlayer.UserId)
        local v19 = nil
        local n4 = os.clock() + 10

        while os.clock() < n4 do
            local ok, result = pcall(function()
                return v8.Client:GetReplion(arg)
            end)

            if ok and result and not result.Destroyed and type(result.Data) == "table" and type(result.Data.Players) == "table" and result.Data.Players[str2] then
                v19 = result
                break
            end
            task.wait(0.1)
        end

        if not v19 then
            return
        end

        local function fn45()
            if v19.Destroyed then
                return nil
            end
            local data = type(v19.Data) == "table" and v19.Data or nil
            return data
        end

        local function fn46()
            local enabled = tbl16.enabled
            local flag4 = enabled

            if enabled then
                if tbl14.running then
                    flag4 = false
                else
                    flag4 = true
                end
            end

            if flag4 then
                flag4 = fn45() ~= nil
            end

            return flag4
        end

        local function fn47()
            local v20 = fn45()
            local flag4 = v20 and type(v20.Players) == "table" and v20.Players[str2] or nil
            return flag4
        end

        local function fn48()
            local v20 = fn45()
            local lastModifiedTime = v20 and v20.LastModifiedTime
            if type(lastModifiedTime) == "number" then
                return lastModifiedTime + n2 - workspace:GetServerTimeNow()
            end
            return 0
        end

        local function fn49()
            local v20 = fn45()
            if not v20 then
                return false
            end

            if v20.PlayersReady == true then
                return true
            end

            if type(v20.PlayersReady) ~= "table" then
                return false
            end
            local flag4 = false

            for k, v21 in pairs(v20.PlayersReady) do
                if not v21 then
                    return false
                end
                flag4 = true
            end

            return flag4
        end

        local n5 = os.clock() + 600
        local n6 = 0
        local n7 = 0

        while fn46() and os.clock() < n5 do
            local v20 = fn47()

            if v20 and fn48() <= 0 then
                if fn49() then
                    if v20.IsConfirmed ~= true and n7 <= os.clock() then
                        n7 = os.clock() + 1.2

                        pcall(function()
                            v12.Remotes.ConfirmTrade:InvokeServer()
                        end)
                    end
                elseif v20.IsReady ~= true and n6 <= os.clock() then
                    n6 = os.clock() + 1.2

                    pcall(function()
                        v12.Remotes.SetReady:InvokeServer(true)
                    end)
                end
            end

            task.wait(0.2)
        end
    end

    v18:AddToggle({
        Title = "Enable Auto Accept Trade",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if not arg then
                tbl16.enabled = false

                if tbl16.hooked and tbl16.origFire then
                    pcall(function()
                        fn(ReplicatedStorage.Controllers.PromptController).FirePrompt = tbl16.origFire
                    end)

                    tbl16.origFire = nil
                    tbl16.hooked = false
                end

                for i, conn in ipairs(tbl16.conns) do
                    pcall(function()
                        conn:Disconnect()
                    end)
                end

                table.clear(tbl16.conns)

                lib:MakeNotify({
                    Title = "Auto Accept Trade",
                    Description = "Dihentikan",
                    Delay = 2,
                })

                return
            end

            if tbl16.enabled then
                return
            end

            if v12 and v8 then
                if not tbl16.hooked then
                    pcall(function()
                        local v19 = fn(ReplicatedStorage.Controllers.PromptController)
                        tbl16.origFire = v19.FirePrompt

                        v19.FirePrompt = function(arg2, arg3, ...)
                            if tbl16.enabled then
                                local v20 = tostring
                                local str2 = arg3 or ""
                                local str3 = v20(str2):lower()
                                if str3:find("trade request") or str3:find("do you want to accept") then
                                    return fn(ReplicatedStorage.Packages.Promise).resolve(true)
                                end
                            end

                            return tbl16.origFire(arg2, arg3, ...)
                        end

                        tbl16.hooked = true
                    end)
                end

                tbl16.enabled = true

                table.insert(tbl16.conns, v12.Remotes.TradeStarted.OnClientEvent:Connect(function(arg2)
                    if not tbl16.enabled or tbl14.running then
                        return
                    end

                    task.spawn(function()
                        fn44(arg2)
                    end)
                end))

                local flag4 = false

                pcall(function()
                    local replion = v8.Client:GetReplion("ReplicatedPlayerData")
                    local v19 = replion and replion:Get("User_" .. localPlayer.UserId)
                    local tradeSettings = v19 and v19.TradeSettings

                    if type(tradeSettings) == "table" and tradeSettings.Trades ~= true then
                        flag4 = true

                        lib:MakeNotify({
                            Title = "Auto Accept Trade",
                            Description = "Setting 'Trades' kamu lagi OFF - request masuk gak bakal kebaca",
                            Delay = 5,
                        })
                    end
                end)

                if not flag4 then
                    lib:MakeNotify({
                        Title = "Auto Accept Trade",
                        Description = "Dimulai",
                        Delay = 2,
                    })
                end

                return
            end

            lib:MakeNotify({
                Title = "Auto Accept Trade",
                Description = "Modul trade gagal dimuat",
                Delay = 3,
            })
        end,
    })

    local request_ = nil

    local function fn45()
        if request_ then
            return request_
        end

        for i, v19 in ipairs({"request", "http_request"}) do
            local v20 = rawget
            local v21 = getfenv
            local env = v21 and getfenv(0) or _G
            local v22 = v20(env, v19)
            local v23 = v22

            if not v22 then
                local v24 = rawget
                local v25 = getgenv
                local genv = v25 and getgenv() or {}
                v23 = v24(genv, v19)
            end

            if type(v23) == "function" then
                request_ = v23
                return v23
            end
        end

        for i, v19 in ipairs({syn, fluxus, solara, v2}) do
            if type(v19) == "table" and type(v19.request) == "function" then
                request_ = v19.request
                return v19.request
            end
        end

        return nil
    end

    local HttpService = game:GetService("HttpService")

    local function fn46(arg)
        return tostring(arg):gsub("^%s*(.-)%s*$", "%1")
    end

    local function fn47(arg)
        if type(arg) == "number" then
            return string.format("%.0f", arg)
        end
        return tostring(arg):gsub("%D", ""):gsub("^%s*(.-)%s*$", "%1")
    end

    local function fn48(arg)
        return tostring(math.floor(arg)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end

    local tbl17 = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "SECRET",
        "FORGOTTEN",
    }

    local tbl18 = {
        9807270,
        3066993,
        3447003,
        10181046,
        15844367,
        16711680,
        65535,
        8355711,
    }

    local tbl19 = {}
    local flag4 = false

    local function fn49()
        if flag4 then
            return
        end
        flag4 = true

        task.spawn(function()
            while #tbl19 > 0 do
                local v19 = table.remove(tbl19, 1)

                if v19 then
                    pcall(function()
                        local v20 = fn45()

                        if v20 and v19.url and v19.url ~= "" then
                            v20({
                                Url = v19.url,
                                Method = "POST",
                                Headers = {["Content-Type"] = "application/json"},
                                Body = HttpService:JSONEncode(v19.payload),
                            })
                        end
                    end)

                    if #tbl19 > 0 then
                        task.wait(1.5)
                    end
                end
            end

            flag4 = false
        end)
    end

    local function fn50(arg, arg2)
        if not arg or arg == "" then
            return false
        end

        if not fn45() then
            return false
        end
        table.insert(tbl19, {url = arg, payload = arg2})
        fn49()
        return true
    end

    local function fn51(arg, arg2)
        local v19 = fn45()
        if not v19 or not arg or arg == "" then
            return false
        end

        return pcall(function()
            v19({
                Url = arg,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(arg2),
            })
        end)
    end

    local function fn52(arg)
        if arg ~= "" and #arg >= 17 then
            return "<@" .. arg .. ">"
        end
        return ""
    end

    local function fn53(arg)
        local userId = arg.userId
        local str2 = userId or ""
        local v19 = fn52(str2)
        local contentText = arg.contentText
        local flag5 = contentText

        if not contentText then
            flag5 = v19 ~= ""

            if flag5 then
                local alertText = arg.alertText
                local str3 = alertText or ""
                flag5 = v19 .. " " .. str3
            end

            if not flag5 then
                local alertText = arg.alertText
                flag5 = alertText or ""
            end
        end

        local tbl20 = {
            content = flag5,
            username = "Lynx",
            avatar_url = "https://raw.githubusercontent.com/habibrodriguez7-art/kontol/refs/heads/main/majesticons--planet-ring-2.png",
        }

        local allowedMentions = v19 ~= ""

        if allowedMentions then
            local tbl21 = {}
            allowedMentions = tbl21
            tbl21.parse = {"users"}
        end

        if not allowedMentions then
            allowedMentions = nil
        end

        tbl20.allowed_mentions = allowedMentions
        local embeds = {}
        local tbl21 = {}
        local author = {}
        local headerTitle = arg.headerTitle
        local str3 = headerTitle or ""
        author.name = "Lynx Webhook | " .. str3
        author.icon_url = "https://raw.githubusercontent.com/habibrodriguez7-art/kontol/refs/heads/main/majesticons--planet-ring-2.png"
        tbl21.author = author
        local bodyText = arg.bodyText
        local description = bodyText or ""
        tbl21.description = description
        local color = arg.color
        local color2 = color or 3447003
        tbl21.color = color2
        local fields = arg.fields
        local fields2 = fields or {}
        tbl21.fields = fields2

        tbl21.footer = {
            text = "Lynx Webhook • " .. os.date("%m/%d/%Y %I:%M"),
            icon_url = "https://raw.githubusercontent.com/habibrodriguez7-art/kontol/refs/heads/main/majesticons--planet-ring-2.png",
        }

        tbl21.timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        embeds[1] = tbl21
        tbl20.embeds = embeds

        if arg.imageUrl then
            tbl20.embeds[1].image = {url = arg.imageUrl}
        end

        return tbl20
    end

    local function fn54(arg, arg2)
        local flag5 = arg ~= "" and arg

        if not flag5 then
            flag5 = arg2

            if not arg2 then
                local displayName = localPlayer.DisplayName
                flag5 = displayName or localPlayer.Name
            end
        end

        return flag5
    end

    local tbl20 = {}
    local tbl21 = {}
    local flag5 = false
    local flag6 = false
    local fn55

    fn55 = function(arg, arg2)
        for i, child in ipairs(arg:GetChildren()) do
            if child:IsA("ModuleScript") then
                local ok, result = pcall(require, child)

                if ok and type(result) == "table" and result.Data then
                    table.insert(arg2, result)
                end
            else
                local flag7 = false

                pcall(function()
                    local flag8 = #child:GetChildren() > 0
                    flag7 = flag8
                end)

                if flag7 then
                    fn55(child, arg2)
                end
            end
        end
    end

    local function fn56()
        if flag5 then
            return true
        end

        if flag6 then
            return false
        end
        flag6 = true

        pcall(function()
            local items = ReplicatedStorage:FindFirstChild("Items")
            local variants = ReplicatedStorage:FindFirstChild("Variants")

            if items then
                fn55(items, tbl20)
            end

            if variants then
                fn55(variants, tbl21)
            end
        end)

        flag5 = true
        flag6 = false
        return true
    end

    local function fn57(arg)
        local num = tonumber(arg)
        local str2 = tostring(arg)

        for i, v19 in ipairs(tbl20) do
            if not v19.Data then
                continue
            end
            local id = v19.Data.Id
            if id == num or id == str2 or tostring(id) == str2 then
                return v19
            end
        end

        return nil
    end

    local function fn58(arg)
        local str2 = tostring(arg)

        for i, v19 in ipairs(tbl21) do
            if v19.Data and (tostring(v19.Data.Id) == str2 or tostring(v19.Data.Name) == str2) then
                return v19
            end
        end

        return nil
    end

    local tbl22 = {}

    local function fn59(arg)
        if not arg then
            return nil
        end
        local str2 = tostring(arg)

        if tbl22[str2] == nil then
            local v19 = fn45()
            if not v19 then
                return nil
            end

            local ok, result = pcall(function()
                local v20 = v19({
                    Url = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false", str2),
                    Method = "GET",
                })

                if v20 and v20.Body then
                    local data = HttpService:JSONDecode(v20.Body)
                    if data and data.data and data.data[1] then
                        return data.data[1].imageUrl
                    end
                end
            end)

            local v20 = ok and result or nil
            local flag7 = v20 or false
            tbl22[str2] = flag7
            return v20
        end

        local v19 = tbl22[str2]
        local v20 = v19 or nil
        return v20
    end

    local function fn60(arg)
        if not arg then
            return nil
        end
        local match = tostring(arg):match("%d+")
        local flag7 = match and match ~= "" and match or nil
        return flag7
    end

    local function fn61(arg)
        if not arg or not arg.Data then
            return "https://i.imgur.com/UMWNYK7.png"
        end
        local data = arg.Data
        local v19 = fn60(data.Icon)
        local v20 = v19 or fn60(data.ImageId) or fn60(data.Image)

        if v20 then
            local v21 = fn59(v20)
            if v21 then
                return v21
            end
        end

        return "https://i.imgur.com/UMWNYK7.png"
    end

    local v19 = v3:AddTab({Name = "Webhook", Icon = "send"})
    local v20 = v19:AddSection("Fish Caught Webhook")

    local tbl23 = {
        url = "",
        id = "",
        hide = "",
        rarities = {},
        filterNames = {},
        filterVariants = {},
        running = false,
        conn = nil,
        gearConn = nil,
        caughtConn = nil,
    }

    local tbl24 = {}
    local tbl25 = {}
    local n4 = 0

    v20:AddInput({
        Title = "Webhook URL (Fish)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl23.url = fn46(arg)
        end,
    })

    v20:AddInput({
        Title = "Discord User ID (Fish)",
        Default = "",
        Placeholder = "123456789012345678",
        Callback = function(arg)
            tbl23.id = fn47(arg)
        end,
    })

    v20:AddInput({
        Title = "Hide Identity (Fish)",
        Default = "",
        Placeholder = "Enter custom name...",
        Callback = function(arg)
            tbl23.hide = fn46(arg)
        end,
    })

    v20:AddParagraph({
        Title = "Filter Logic (AND)",
        Content = "All active filters work as AND.\nEmpty filters are ignored.\nExample: Mythic + Corrupt → only Mythic fish with Corrupt variant.",
    })

    v20:AddDropdown({
        Title = "Rarity Filter (empty = all)",
        Options = {
            "Common",
            "Uncommon",
            "Rare",
            "Epic",
            "Legendary",
            "Mythic",
            "SECRET",
            "FORGOTTEN",
        },
        Multi = true,
        Default = {},
        Callback = function(arg)
            local rarities = type(arg) == "table" and arg or {}
            tbl23.rarities = rarities
        end,
    })

    local tbl26 = {}
    local tbl27 = {}
    local flag7 = false
    local tbl28 = {Fish = true, Gears = true, ["Enchant Stones"] = true}

    local function fn62()
        if flag7 then
            return
        end
        flag7 = true

        pcall(function()
            local items = ReplicatedStorage:FindFirstChild("Items")
            if not items then
                return
            end
            local tbl29 = {}
            local fn63

            fn63 = function(arg)
                for i, child in ipairs(arg:GetChildren()) do
                    if child:IsA("ModuleScript") then
                        local ok, result = pcall(require, child)

                        if ok and result and result.Data and tbl28[result.Data.Type] then
                            local displayName = result.Data.DisplayName
                            local name = displayName or result.Data.Name

                            if name and not tbl29[name] then
                                tbl29[name] = true
                                tbl26[#tbl26 + 1] = name
                            end
                        end
                    else
                        local flag8 = false

                        pcall(function()
                            local flag9 = #child:GetChildren() > 0
                            flag8 = flag9
                        end)

                        if flag8 then
                            fn63(child)
                        end
                    end
                end
            end

            fn63(items)
        end)

        table.sort(tbl26)

        pcall(function()
            local variants = ReplicatedStorage:FindFirstChild("Variants")
            if not variants then
                return
            end

            for i, child in ipairs(variants:GetChildren()) do
                if child:IsA("ModuleScript") and child.Name ~= "1x1x1x1" and not table.find(tbl27, child.Name) then
                    tbl27[#tbl27 + 1] = child.Name
                end
            end
        end)

        table.sort(tbl27)
    end

    v20:AddDropdown({
        Title = "Name Filter (empty = all)",
        Options = tbl26,
        Multi = true,
        Default = {},
        Callback = function(arg)
            local filterNames = {}

            if type(arg) == "table" then
                for i, v21 in ipairs(arg) do
                    filterNames[v21] = true
                end
            end

            tbl23.filterNames = filterNames
        end,
    })

    v20:AddDropdown({
        Title = "Variant Filter (empty = all)",
        Options = tbl27,
        Multi = true,
        Default = {},
        Callback = function(arg)
            local filterVariants = {}

            if type(arg) == "table" then
                for i, v21 in ipairs(arg) do
                    filterVariants[v21] = true
                end
            end

            tbl23.filterVariants = filterVariants
        end,
    })

    task.spawn(function()
        task.wait(3)
        fn62()
        local v21 = lib.ConfigSystem.Get("MultiDropdowns.Name_Filter_(empty_=_all)", {})
        local tbl29 = v21
        local v22 = lib.ConfigSystem.Get("MultiDropdowns.Variant_Filter_(empty_=_all)", {})
        local tbl30 = v22

        if type(v21) ~= "table" then
            tbl29 = {}
        end

        if type(v22) ~= "table" then
            tbl30 = {}
        end

        local flags = lib.flags
        local nameFilterEmptyAll = flags and lib.flags["Name_Filter_(empty_=_all)"]
        local flags2 = lib.flags
        local variantFilterEmptyAll = flags2 and lib.flags["Variant_Filter_(empty_=_all)"]

        if nameFilterEmptyAll and nameFilterEmptyAll.SetValues then
            nameFilterEmptyAll:SetValues(tbl26, tbl29)
        end

        if variantFilterEmptyAll and variantFilterEmptyAll.SetValues then
            variantFilterEmptyAll:SetValues(tbl27, tbl30)
        end

        if #tbl29 > 0 then
            local filterNames = {}

            for i, v23 in ipairs(tbl29) do
                filterNames[v23] = true
            end

            tbl23.filterNames = filterNames
        end

        if #tbl30 > 0 then
            local filterVariants = {}

            for i, v23 in ipairs(tbl30) do
                filterVariants[v23] = true
            end

            tbl23.filterVariants = filterVariants
        end
    end)

    v20:AddToggle({
        Title = "Enable Fish Webhook",
        Default = false,
        Callback = function(arg)
            if arg then
                if tbl23.running then
                    return
                end

                if tbl23.url == "" then
                    warn("[Webhook] Fish URL is not set!")
                    return
                end

                if not fn45() then
                    warn("[Webhook] Executor does not support HTTP!")
                    return
                end
                task.spawn(fn56)
                task.spawn(fn62)
                local reObtainedNewFishNotification = obj.RE_ObtainedNewFishNotification
                if not reObtainedNewFishNotification then
                    warn("[Webhook] Event not found!")
                    return
                end
                tbl23.running = true

                tbl23.conn = reObtainedNewFishNotification.OnClientEvent:Connect(function(arg2, arg3, arg4)
                    local now = tick()
                    if tbl24[arg2] and now - tbl24[arg2] < 0.5 then
                        return
                    end
                    tbl24[arg2] = now

                    if now - n4 > 30 then
                        n4 = now

                        for k, v21 in pairs(tbl24) do
                            if now - v21 > 10 then
                                tbl24[k] = nil
                            end
                        end
                    end

                    task.spawn(function()
                        if not flag5 then
                            local now2 = tick()

                            while not flag5 and tick() - now2 < 3 do
                                task.wait(0.3)
                            end

                            if not flag5 then
                                pcall(fn56)
                            end
                        end

                        local v21 = fn57(arg2)
                        if not v21 then
                            return
                        end
                        local tbl29 = arg3 or {}
                        local tbl30 = arg4 or {}
                        local data = v21.Data
                        local tier = data and v21.Data.Tier
                        local v22 = tbl17[tier]
                        local str2 = v22 or "Unknown"
                        local data2 = v21.Data
                        local tier2 = data2 and v21.Data.Tier
                        local v23 = tbl18[tier2]
                        local n5 = v23 or 3447003
                        local rarities = tbl23.rarities
                        local key = rarities and next(tbl23.rarities)
                        local flag8 = next(tbl23.filterNames) ~= nil
                        local flag9 = next(tbl23.filterVariants) ~= nil
                        local flag10 = true
                        local flag11 = true
                        local flag12 = true

                        if key then
                            flag10 = false

                            for i, rarity in ipairs(tbl23.rarities) do
                                if rarity == str2 then
                                    flag10 = true
                                    break
                                end
                            end
                        end

                        if flag8 then
                            local data3 = v21.Data
                            local name = data3

                            if data3 then
                                local displayName = v21.Data.DisplayName
                                name = displayName or v21.Data.Name
                            end

                            if not name then
                                name = ""
                            end

                            flag11 = tbl23.filterNames[name] == true
                        end

                        if not flag10 or not flag11 then
                            return
                        end
                        local metadata = type(tbl30.InventoryItem) == "table" and type(tbl30.InventoryItem.Metadata) == "table" and tbl30.InventoryItem.Metadata or nil
                        local mutation = metadata

                        if metadata then
                            local variant = metadata.Variant
                            mutation = variant or metadata.Mutation or metadata.VariantId
                        end

                        if not mutation then
                            mutation = tbl30.Variant
                        end

                        if not mutation then
                            mutation = tbl30.Mutation
                        end

                        if not mutation then
                            mutation = tbl30.VariantId
                        end

                        if not mutation then
                            mutation = tbl29.Variant
                        end

                        if not mutation then
                            mutation = tbl29.Mutation
                        end

                        if not mutation then
                            mutation = tbl29.VariantId
                        end

                        local shiny = tbl29.Shiny
                        local shiny2 = shiny or tbl30.Shiny or metadata and metadata.Shiny
                        local str3 = "None"
                        local sellPrice = v21.SellPrice
                        local n6 = sellPrice or 0

                        if shiny2 then
                            str3 = "Shiny"
                            n6 = n6 * 2
                        end

                        if mutation then
                            local v24 = fn58(mutation)

                            if v24 then
                                local data3 = v24.Data
                                local name = data3 and v24.Data.Name or tostring(mutation)
                                local str4 = shiny2 and "Shiny " or ""
                                local v25 = tostring
                                local sellMultiplier = v24.SellMultiplier
                                local str5 = sellMultiplier or "?"
                                str3 = str4 .. name .. " (" .. v25(str5) .. "x)"
                                local sellMultiplier2 = v24.SellMultiplier
                                local n7 = sellMultiplier2 or 1
                                n6 = n6 * n7

                                if flag9 then
                                    local flag13 = tbl23.filterVariants[name] == true or tbl23.filterVariants[tostring(mutation)] == true
                                    flag12 = flag13
                                end
                            else
                                local str4 = shiny2 and "Shiny " or ""
                                str3 = str4 .. tostring(mutation)

                                if flag9 then
                                    flag12 = tbl23.filterVariants[tostring(mutation)] == true
                                end
                            end
                        elseif flag9 then
                            flag12 = false
                        end

                        if not flag12 then
                            return
                        end
                        local data3 = v21.Data
                        local displayName = data3

                        if data3 then
                            local name = v21.Data.Name
                            displayName = name or v21.Data.DisplayName
                        end

                        if not displayName then
                            displayName = "Unknown"
                        end

                        local v24 = fn54(tbl23.hide)

                        local tbl31 = {
                            userId = tbl23.id,
                            alertText = "New **" .. str2 .. "** fish caught! **" .. displayName .. "**",
                            headerTitle = "Fish Caught",
                            bodyText = string.format("**||%s||** You have obtained a new **%s** fish — **%s**!", v24, str2, displayName),
                            color = n5,
                            imageUrl = "https://i.imgur.com/UMWNYK7.png",
                        }

                        local fields = {}
                        local tbl32 = {name = "〢Fish Name :", value = displayName, inline = false}
                        local tbl33 = {name = "〢Fish Tier :", value = str2, inline = false}
                        local tbl34 = {name = "〢Weight :"}
                        local format = string.format
                        local weight = tbl29.Weight
                        local n7 = weight or 0
                        tbl34.value = format("%.2f Kg", n7)
                        tbl34.inline = false

                        local tbl35 = {
                            name = "〢Sell Price :",
                            value = fn48(n6),
                            inline = false,
                        }

                        fields[1] = tbl32
                        fields[2] = tbl33
                        fields[3] = tbl34
                        fields[4] = {name = "〢Mutation :", value = str3, inline = false}
                        fields[5] = tbl35
                        tbl31.fields = fields
                        local v25 = fn53(tbl31)
                        local ok, result = pcall(fn61, v21)

                        if ok and result then
                            v25.embeds[1].image = {url = result}
                        end

                        fn50(tbl23.url, v25)
                    end)
                end)

                pcall(function()
                    tbl23.caughtConn = obj.RE_FishCaught.OnClientEvent:Connect(function(arg2, arg3)
                        if type(arg2) == "string" and type(arg3) == "table" then
                            tbl25[arg2] = {meta = arg3, at = os.clock()}
                        end
                    end)
                end)

                pcall(function()
                    local reTextNotification = obj.RE_TextNotification
                    if not reTextNotification then
                        return
                    end

                    tbl23.gearConn = reTextNotification.OnClientEvent:Connect(function(arg2)
                        if not tbl23.running or tbl23.url == "" then
                            return
                        end

                        if type(arg2) ~= "table" then
                            return
                        end

                        if arg2.Type ~= "Item" then
                            return
                        end

                        if not arg2.ItemType or not arg2.ItemId then
                            return
                        end

                        if arg2.ItemType ~= "Gears" then
                            return
                        end
                        local str2 = tostring(arg2.ItemId)
                        local now = tick()
                        if tbl24["gear_" .. str2] and now - tbl24["gear_" .. str2] < 0.5 then
                            return
                        end
                        tbl24["gear_" .. str2] = now

                        task.spawn(function()
                            local v21 = fn(game:GetService("ReplicatedStorage").Shared.ItemUtility)
                            local v22 = nil

                            pcall(function()
                                v22 = v21.GetItemDataFromItemType(arg2.ItemType, arg2.ItemId)
                            end)

                            local data = v22 and v22.Data

                            if data then
                                local name = v22.Data.Name
                                data = name or v22.Data.DisplayName
                            end

                            if not data then
                                data = tostring(arg2.ItemId)
                            end

                            local tier = v22 and v22.Data and v22.Data.Tier or 7
                            local v23 = tbl17[tier]
                            local str3 = v23 or "SECRET"
                            local v24 = tbl18[tier]
                            local n5 = v24 or 65535
                            local v25 = fn54(tbl23.hide)
                            local rarities = tbl23.rarities
                            local key = rarities and next(tbl23.rarities)

                            if key then
                                local flag8 = false

                                for i, rarity in ipairs(tbl23.rarities) do
                                    if rarity == str3 then
                                        flag8 = true
                                        break
                                    end
                                end

                                if not flag8 then
                                    return
                                end
                            end

                            if next(tbl23.filterNames) ~= nil and not tbl23.filterNames[data] then
                                return
                            end
                            local str4 = "None"

                            local function fn63(arg3)
                                if type(arg3) ~= "table" then
                                    return nil
                                end
                                local variant = arg3.Variant
                                local mutation = variant or arg3.Mutation or arg3.VariantId
                                return mutation
                            end

                            local inventoryItem = type(arg2.InventoryItem) == "table" and arg2.InventoryItem or nil
                            local metadata = inventoryItem and type(inventoryItem.Metadata) == "table" and inventoryItem.Metadata or nil
                            local meta = nil

                            for i = 1, 20 do
                                local v26 = tbl25[data]
                                if v26 and os.clock() - v26.at < 5 then
                                    meta = v26.meta
                                    break
                                end
                                task.wait(0.1)
                            end

                            local v26 = fn63(meta)
                            local v27 = v26 or fn63(metadata) or fn63(arg2) or fn63(arg2.Metadata) or fn63(arg2.ExtraData)
                            local shiny = meta and meta.Shiny or metadata and metadata.Shiny or arg2.Shiny or type(arg2.Metadata) == "table" and arg2.Metadata.Shiny or type(arg2.ExtraData) == "table" and arg2.ExtraData.Shiny
                            local weight = meta and meta.Weight or metadata and metadata.Weight or type(arg2.Metadata) == "table" and arg2.Metadata.Weight or nil
                            local sellPrice = v22 and v22.SellPrice or nil
                            local n6 = sellPrice

                            if shiny then
                                str4 = "Shiny"

                                if sellPrice then
                                    n6 = sellPrice * 2
                                end
                            end

                            local flag8 = next(tbl23.filterVariants) ~= nil
                            local flag9 = true

                            if v27 then
                                local v28 = fn58(v27)

                                if v28 then
                                    local data2 = v28.Data
                                    local name = data2 and v28.Data.Name or tostring(v27)
                                    local str5 = shiny and "Shiny " or ""
                                    local v29 = tostring
                                    local sellMultiplier = v28.SellMultiplier
                                    local str6 = sellMultiplier or "?"
                                    str4 = str5 .. name .. " (" .. v29(str6) .. "x)"

                                    if n6 then
                                        local sellMultiplier2 = v28.SellMultiplier
                                        local n7 = sellMultiplier2 or 1
                                        n6 = n6 * n7
                                    end

                                    if flag8 then
                                        local flag10 = tbl23.filterVariants[name] == true or tbl23.filterVariants[tostring(v27)] == true
                                        flag9 = flag10
                                    end
                                else
                                    local str5 = shiny and "Shiny " or ""
                                    str4 = str5 .. tostring(v27)

                                    if flag8 then
                                        flag9 = tbl23.filterVariants[tostring(v27)] == true
                                    end
                                end
                            elseif flag8 then
                                flag9 = false
                            end

                            if not flag9 then
                                return
                            end
                            local str5 = "https://i.imgur.com/UMWNYK7.png"

                            pcall(function()
                                local v28 = v22
                                local icon = v28 and v22.Data and v22.Data.Icon or arg2.Icon or ""
                                local v29 = fn60(icon)

                                if v29 then
                                    local v30 = fn59(v29)

                                    if v30 and v30 ~= "" then
                                        str5 = v30
                                    end
                                end
                            end)

                            local tbl29 = {}
                            local tbl30 = {name = "〢Item Name :", value = data, inline = false}
                            local tbl31 = {name = "〢Item Tier :", value = str3, inline = false}
                            local tbl32 = {name = "〢Item Type :"}
                            local itemType = arg2.ItemType
                            local value = itemType or "?"
                            tbl32.value = value
                            tbl32.inline = false
                            tbl29[1] = tbl30
                            tbl29[2] = tbl31
                            tbl29[3] = tbl32

                            if weight then
                                tbl29[#tbl29 + 1] = {
                                    name = "〢Weight :",
                                    value = string.format("%.2f Kg", weight),
                                    inline = false,
                                }
                            end

                            tbl29[#tbl29 + 1] = {name = "〢Mutation :", value = str4, inline = false}

                            if n6 then
                                tbl29[#tbl29 + 1] = {
                                    name = "〢Sell Price :",
                                    value = fn48(n6),
                                    inline = false,
                                }
                            end

                            fn50(tbl23.url, fn53({
                                userId = tbl23.id,
                                alertText = "New **" .. str3 .. "** item obtained! **" .. data .. "**",
                                headerTitle = "Fish Caught",
                                bodyText = string.format("**||%s||** You have obtained **%s**!", v25, data),
                                color = n5,
                                imageUrl = str5,
                                fields = tbl29,
                            }))
                        end)
                    end)
                end)
            else
                tbl23.running = false

                if tbl23.conn then
                    tbl23.conn:Disconnect()
                    tbl23.conn = nil
                end

                if tbl23.gearConn then
                    tbl23.gearConn:Disconnect()
                    tbl23.gearConn = nil
                end

                if tbl23.caughtConn then
                    tbl23.caughtConn:Disconnect()
                    tbl23.caughtConn = nil
                end

                table.clear(tbl25)
            end
        end,
    })

    v20:AddButton({
        Title = "Test Fish Webhook",
        Callback = function()
            if tbl23.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Webhook URL is not set!",
                    Delay = 3,
                })

                return
            end

            local v21 = fn54(tbl23.hide)

            local v22 = fn51(tbl23.url, fn53({
                userId = tbl23.id,
                alertText = "New **FORGOTTEN** fish caught! **Webhook Test**",
                headerTitle = "Fish Caught",
                bodyText = string.format("**||%s||** You have obtained a new **FORGOTTEN** fish — **Webhook Test**!", v21),
                color = 15844367,
                imageUrl = "https://i.imgur.com/UMWNYK7.png",
                fields = {
                    {
                        name = "〢Fish Name :",
                        value = "Webhook Test",
                        inline = false,
                    },
                    {
                        name = "〢Fish Tier :",
                        value = "FORGOTTEN",
                        inline = false,
                    },
                    {name = "〢Weight :", value = "12.50 Kg", inline = false},
                    {name = "〢Mutation :", value = "None", inline = false},
                    {name = "〢Sell Price :", value = "10,000", inline = false},
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl29 = {Title = "Webhook"}
            local description = v22 and "Test message sent!" or "Failed! Check executor / URL."
            tbl29.Description = description
            local delay = v22 and 3 or 4
            tbl29.Delay = delay
            makeNotify(lib, tbl29)
        end,
    })

    local v21 = v19:AddSection("Disconnect Webhook")

    local tbl29 = {
        url = "",
        id = "",
        hide = "",
        enabled = false,
        errorConn = nil,
        overlayConn = nil,
    }

    local function fn63()
        if tbl29.errorConn then
            pcall(function()
                tbl29.errorConn:Disconnect()
            end)

            tbl29.errorConn = nil
        end

        if tbl29.overlayConn then
            pcall(function()
                tbl29.overlayConn:Disconnect()
            end)

            tbl29.overlayConn = nil
        end
    end

    v21:AddParagraph({
        Title = "Info",
        Content = "Sends a notification to Discord when Roblox disconnects, then auto-rejoins.",
    })

    v21:AddInput({
        Title = "Webhook URL (Disconnect)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl29.url = fn46(arg)
        end,
    })

    v21:AddInput({
        Title = "Discord User ID (Disconnect)",
        Default = "",
        Placeholder = "123456789012345678",
        Callback = function(arg)
            tbl29.id = fn47(arg)
        end,
    })

    v21:AddInput({
        Title = "Hide Identity (Disconnect)",
        Default = "",
        Placeholder = "Enter custom name...",
        Callback = function(arg)
            tbl29.hide = fn46(arg)
        end,
    })

    v21:AddToggle({
        Title = "Enable Disconnect Webhook",
        Default = false,
        Callback = function(enabled)
            tbl29.enabled = enabled
            fn63()
            if not enabled then
                return
            end
            local flag8 = false

            local function fn64(arg)
                if flag8 or not tbl29.enabled or tbl29.url == "" then
                    return
                end
                flag8 = true
                local hide = tbl29.hide
                local name = localPlayer and localPlayer.Name or "Unknown"
                local v22 = fn54(hide, name)
                local url = tbl29.url

                local tbl30 = {
                    userId = tbl29.id,
                    alertText = "Your account got disconnected from the server!",
                    headerTitle = "Disconnect Alert",
                    bodyText = "**Your Roblox session was disconnected.**\n\nAttempting to rejoin...",
                    color = 16711680,
                }

                local fields = {}

                local tbl31 = {
                    name = "Account",
                    value = "```" .. v22 .. "```",
                    inline = true,
                }

                local tbl32 = {
                    name = "Time",
                    value = "```" .. os.date("%m/%d/%Y at %I:%M %p") .. "```",
                    inline = true,
                }

                local tbl33 = {name = "Reason"}
                local str2 = arg or "Disconnected"
                tbl33.value = "```" .. str2 .. "```"
                tbl33.inline = false
                fields[1] = tbl31
                fields[2] = tbl32
                fields[3] = tbl33
                tbl30.fields = fields
                fn51(url, fn53(tbl30))
                task.wait(2)

                pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
                end)
            end

            pcall(function()
                tbl29.errorConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function(arg)
                    if arg and arg ~= "" then
                        fn64(arg)
                    end
                end)
            end)

            pcall(function()
                local robloxPromptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                local promptOverlay = robloxPromptGui and game:GetService("CoreGui").RobloxPromptGui:FindFirstChild("promptOverlay")

                if promptOverlay then
                    tbl29.overlayConn = promptOverlay.ChildAdded:Connect(function(child)
                        if child.Name == "ErrorPrompt" then
                            task.wait(1)
                            local textLabel = child:FindFirstChildWhichIsA("TextLabel", true)
                            local text = textLabel and textLabel.Text or "Disconnected"
                            fn64(text)
                        end
                    end)
                end
            end)
        end,
    })

    v21:AddButton({
        Title = "Test Disconnect Webhook",
        Callback = function()
            if tbl29.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Disconnect URL is not set!",
                    Delay = 3,
                })

                return
            end

            local hide = tbl29.hide
            local name = localPlayer and localPlayer.Name or "Unknown"
            local v22 = fn54(hide, name)

            local v23 = fn51(tbl29.url, fn53({
                userId = tbl29.id,
                alertText = "Your account got disconnected from the server!",
                headerTitle = "Disconnect Alert",
                bodyText = "**Your Roblox session was disconnected.**\n\nAttempting to rejoin...",
                color = 16711680,
                fields = {
                    {
                        name = "Account",
                        value = "```" .. v22 .. "```",
                        inline = true,
                    },
                    {
                        name = "Time",
                        value = "```" .. os.date("%m/%d/%Y at %I:%M %p") .. "```",
                        inline = true,
                    },
                    {
                        name = "Reason",
                        value = "```Test Successfully :3```",
                        inline = false,
                    },
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl30 = {Title = "Webhook"}
            local description = v23 and "Disconnect test sent!" or "Failed! Check executor / URL."
            tbl30.Description = description
            local delay = v23 and 3 or 4
            tbl30.Delay = delay
            makeNotify(lib, tbl30)
        end,
    })

    local v22 = v19:AddSection("Webhook Server")

    local tbl30 = {
        url = "",
        urlJoinLeave = "",
        customName = "",
        enabled = false,
        trackJoin = false,
        trackLeave = false,
        selectedTiers = {
            Epic = false,
            Legendary = false,
            Mythic = false,
            SECRET = false,
            FORGOTTEN = false,
        },
        chatConn = nil,
        joinConn = nil,
        leaveConn = nil,
    }

    local tbl31 = {
        {
            name = "Epic",
            discordColor = 10181046,
            r = 179,
            g = 115,
            b = 248,
        },
        {
            name = "Legendary",
            discordColor = 15844367,
            r = 255,
            g = 185,
            b = 43,
        },
        {
            name = "Mythic",
            discordColor = 16711680,
            r = 255,
            g = 25,
            b = 25,
        },
        {
            name = "SECRET",
            discordColor = 65535,
            r = 24,
            g = 255,
            b = 152,
        },
        {
            name = "FORGOTTEN",
            discordColor = 8421504,
            r = 0,
            g = 0,
            b = 0,
        },
    }

    local tbl32 = {}

    local function fn64()
        if #tbl32 > 0 then
            return
        end

        pcall(function()
            local variants = ReplicatedStorage:FindFirstChild("Variants")
            if not variants then
                return
            end

            for i, descendant in ipairs(variants:GetDescendants()) do
                if descendant:IsA("ModuleScript") then
                    local ok, result = pcall(require, descendant)

                    if ok and type(result) == "table" and result.Data and result.Data.Name then
                        local name = result.Data.Name

                        if not table.find(tbl32, name) then
                            table.insert(tbl32, name)
                        end
                    end
                end
            end

            table.sort(tbl32, function(arg, arg2)
                local flag8 = #arg2 < #arg
                return flag8
            end)
        end)
    end

    local tbl33 = {}

    for i, v23 in ipairs(tbl31) do
        tbl33[v23.name] = v23
    end

    local v23 = nil
    local flag8 = false

    local function fn65(arg)
        if type(arg) ~= "string" then
            return nil
        end
        local str2 = arg:lower():gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
        local flag9 = str2 ~= "" and str2 or nil
        return flag9
    end

    local function fn66()
        if v23 or flag8 then
            return
        end
        flag8 = true
        pcall(fn56)
        local tbl34 = {}

        pcall(function()
            local v24, v25, v26 = ipairs(tbl20)
            local v27 = v26
            local v28 = v24
            local v29 = v25

            while true do
                local v30, v31 = v28(v29, v27)
                if v30 == nil then
                    break
                end
                v27 = v30
                local data = v31.Data

                if data then
                    for i, v32 in ipairs({data.Name, data.DisplayName}) do
                        local v33 = fn65(v32)

                        if v33 and not tbl34[v33] then
                            tbl34[v33] = v31
                        end
                    end

                    v27 = v30
                end
            end
        end)

        v23 = tbl34
        flag8 = false
    end

    local function fn67(arg)
        local v24 = fn65(arg)
        if v24 and v23 then
            return v23[v24]
        end
        return nil
    end

    local function fn68(arg)
        if fn67(arg) then
            return nil, arg
        end
        local str2 = arg:lower()

        for i, v24 in ipairs(tbl32) do
            if str2:sub(1, #v24 + 1) == v24:lower() .. " " then
                local str3 = arg:sub(#v24 + 2):gsub("^%s*", "")
                if fn67(str3) then
                    return v24, str3
                end
            end
        end

        if v23 then
            return nil, arg
        end

        for i, v24 in ipairs(tbl32) do
            if str2:sub(1, #v24 + 1) == v24:lower() .. " " then
                local str3 = arg:sub(#v24 + 2):gsub("^%s*", "")
                if str3 ~= "" then
                    return v24, str3
                end
            end
        end

        return nil, arg
    end

    local function fn69(arg)
        if type(arg) ~= "string" or arg == "" then
            return nil
        end
        local str2 = arg:lower()

        for i, v24 in ipairs(tbl32) do
            if v24:lower() == str2 then
                return v24
            end
        end

        return nil
    end

    local function fn70(arg)
        if not arg then
            return nil
        end
        local v24 = nil
        local huge = math.huge

        for i, v25 in ipairs(tbl31) do
            local v26 = math.sqrt((arg.r - v25.r) ^ 2 + (arg.g - v25.g) ^ 2 + (arg.b - v25.b) ^ 2)

            if v26 < huge then
                v24 = v25
                huge = v26
            end
        end

        if v24 and huge < 55 then
            return v24
        end
        return nil
    end

    local function fn71(arg, arg2)
        fn64()
        local pos = arg:find("obtained")
        local pos2 = pos or arg:find("caught") or arg:find("found") or arg:find("unboxed") or 1
        local tbl34 = {}

        for match in arg:sub(pos2):gmatch("<font color=\"rgb%(([%d%.,%s]+)%)\">") do
            local match2, v24, v25 = match:match("(%d+),%s*(%d+),%s*(%d+)")

            if match2 and v24 and v25 then
                table.insert(tbl34, {
                    r = tonumber(match2),
                    g = tonumber(v24),
                    b = tonumber(v25),
                })
            end
        end

        if #tbl34 == 0 then
            return nil
        end
        local v24 = tbl34[1]

        if arg2 and arg2 ~= "" and #tbl34 > 1 then
            v24 = tbl34[2]
        end

        return fn70(v24)
    end

    local function fn72(arg)
        local str2 = arg:gsub("<[^>]+>", ""):gsub("^%s*%b[]%s*:%s*", "")
        local match = str2:match("obtained")
        local match2 = match or str2:match("caught") or str2:match("found") or str2:match("unboxed")
        if not match2 then
            return nil
        end
        local match3 = str2:match("^%s*(.-)%s+" .. match2)
        local match4 = str2:match("with a (1 in [%d%.,KkMmBb]+) chance")
        local str3 = match4 or "Unknown"
        if not match3 or match3 == "" then
            return nil
        end
        local text = nil
        local str4 = nil
        local color = nil
        local pos = arg:find(match2, 1, true)

        if pos then
            local str5 = arg:sub(pos)
            local str6 = str5
            local pos2 = str5:find("with a", 1, true)

            if pos2 then
                str6 = str5:sub(1, pos2 - 1)
            end

            local tbl34 = {}

            for match5, match22 in str6:gmatch("<font([^>]*)>(.-)</font>") do
                local match6, v24, v25 = match5:match("rgb%((%d+)%s*,%s*(%d+)%s*,%s*(%d+)%)")
                local n5 = #tbl34 + 1

                local tbl35 = {
                    text = match22:gsub("<[^>]+>", ""):gsub("^%s*(.-)%s*$", "%1"),
                }

                local v26 = match6

                if match6 then
                    local tbl36 = {}
                    v26 = tbl36
                    tbl36.r = tonumber(match6)
                    tbl36.g = tonumber(v24)
                    tbl36.b = tonumber(v25)
                end

                if not v26 then
                    v26 = nil
                end

                tbl35.color = v26
                tbl34[n5] = tbl35
            end

            local v24 = tbl34[#tbl34]

            if v24 and v24.text ~= "" then
                text = v24.text
                color = v24.color
                local v25 = tbl34[#tbl34 - 1]

                if v25 and v25.text ~= "" then
                    local v26 = fn69(v25.text)
                    str4 = v26

                    if not v26 and v25.text == v25.text:upper() then
                        str4 = v25.text:sub(1, 1) .. v25.text:sub(2):lower()
                    end
                end
            end
        end

        local flag9 = text ~= nil

        if not text then
            local match5 = str2:match(match2 .. " an?%s+(.-)%s+with a")
            local match6 = match5 or str2:match(match2 .. " an?%s+([^!%.]+)") or str2:match(match2 .. "%s+(.-)%s+with a") or str2:match(match2 .. "%s+([^!%.]+)") or ""
            text = match6
        end

        local str5 = nil
        local match5 = text:match("%(([^%(%)]*)%)%s*$")

        if match5 and match5:lower():find("kg", 1, true) then
            str5 = match5:gsub("^%s*(.-)%s*$", "%1")
            text = text:gsub("%s*%([^%(%)]*%)%s*$", "")
        end

        local str6 = text:gsub("^%s*(.-)%s*$", "%1")
        local str7 = str6
        local flag10 = false

        if str6:lower():sub(1, 6) == "shiny " and not fn67(str6) then
            flag10 = true
            str7 = str6:sub(7):gsub("^%s*", "")
        end

        local v24 = str7

        if not flag9 then
            local v25, v26 = fn68(str7)
            str4 = v25
            v24 = v26
        end

        local str8 = v24:gsub("^%s*(.-)%s*$", "%1")
        if str8 == "" then
            return nil
        end

        return {
            player = match3:gsub("^%s*(.-)%s*$", "%1"),
            fish = str8,
            weight = str5,
            variant = str4,
            shiny = flag10,
            chance = str3,
            tierColor = color,
        }
    end

    local tbl34 = {}

    local function fn73(arg)
        if tbl34[arg] then
            return tbl34[arg]
        end

        if not flag5 then
            pcall(fn56)
        end

        local v24 = fn67(arg)

        if v24 and v24.Data then
            local data = v24.Data
            local v25 = fn60(data.Icon)
            local v26 = v25 or fn60(data.ImageId) or fn60(data.Image) or fn60(data.Thumbnail) or fn60(data.AssetId)

            if v26 then
                local v27 = fn59(v26)
                if v27 and v27 ~= "" then
                    tbl34[arg] = v27
                    return v27
                end
            end
        end

        local str2 = arg:gsub("%s*%b()%s*$", ""):gsub("^%s*(.-)%s*$", "%1"):lower():gsub("%s+", " ")
        local v25 = nil
        local n5 = 0
        local v26, v27, v28 = ipairs(tbl20)
        local v29 = v28
        local v30 = v26
        local v31 = v27

        while true do
            local v32, v33 = v30(v31, v29)
            if v32 == nil then
                break
            end
            v29 = v32
            local data = v33.Data
            if not data then
                continue
            end

            for i, v34 in ipairs({
                data.Name,
                data.DisplayName,
                data.InternalName,
                data.ShortName,
            }) do
                if not v34 then
                    continue
                end
                local str3 = tostring(v34):lower():gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                local n6 = 0

                if str3 == str2 then
                    n6 = 100
                elseif str3:find(str2, 1, true) then
                    n6 = math.floor(#str2 / #str3 * 90)
                elseif str2:find(str3, 1, true) then
                    n6 = math.floor(#str3 / #str2 * 70)
                end

                if n5 < n6 then
                    n5 = n6
                    v25 = v33
                end

                if n5 == 100 then
                    break
                end
            end

            v29 = v32
            if n5 == 100 then
                break
            end
        end

        local str3 = "https://i.imgur.com/UMWNYK7.png"

        if v25 and n5 >= 30 then
            local data = v25.Data
            local v32 = fn60(data.Icon)
            local v33 = v32 or fn60(data.ImageId) or fn60(data.Image) or fn60(data.Thumbnail) or fn60(data.AssetId)

            if v33 then
                local v34 = fn59(v33)

                if v34 and v34 ~= "" then
                    str3 = v34
                end
            end
        end

        tbl34[arg] = str3
        return str3
    end

    local function fn74(arg, arg2)
        local v24 = fn67(arg.fish)

        if v24 and v24.Data and v24.Data.Tier then
            local v25 = tbl17[v24.Data.Tier]
            local str2 = v25 or ""
            return tbl33[str2]
        end

        local v25 = fn70(arg.tierColor)
        local v26 = v25 or fn71(arg2, arg.variant)
        return v26
    end

    local function fn75(arg)
        if not tbl30.enabled or tbl30.url == "" then
            return
        end

        task.spawn(function()
            if not v23 then
                fn66()
                local now = tick()

                while not v23 and tick() - now < 5 do
                    task.wait(0.1)
                end
            end

            fn64()
            local v24 = fn72(arg)
            if not v24 then
                return
            end
            local v25 = fn74(v24, arg)
            if not v25 or not tbl30.selectedTiers[v25.name] then
                return
            end
            local v26 = fn73(v24.fish)
            local customName = tbl30.customName ~= "" and tbl30.customName or v24.player

            local tbl35 = {
                {
                    name = "〢Fish Name :",
                    value = v24.fish,
                    inline = false,
                },
                {
                    name = "〢Fish Tier :",
                    value = v25.name,
                    inline = false,
                },
            }

            local variant = v24.variant
            local v27 = variant

            if v24.shiny then
                local str2 = variant and "Shiny " .. variant or "Shiny"
                v27 = str2
            end

            if v27 then
                table.insert(tbl35, {name = "〢Variant :", value = v27, inline = false})
            end

            if v24.weight then
                table.insert(tbl35, {name = "〢Weight :", value = v24.weight, inline = false})
            end

            table.insert(tbl35, {name = "〢Scope :", value = "[Server]", inline = false})
            table.insert(tbl35, {name = "〢Chance :", value = v24.chance, inline = false})

            fn50(tbl30.url, fn53({
                alertText = "New **" .. v25.name .. "** fish caught!",
                headerTitle = "Fish Caught",
                bodyText = string.format("**||%s||** You have obtained a new **%s** fish!", customName, v25.name),
                color = v25.discordColor,
                imageUrl = v26,
                fields = tbl35,
            }))
        end)
    end

    local function fn76()
        if tbl30.chatConn then
            return
        end

        task.spawn(function()
            local reDisplaySystemMessage = nil
            local now = tick()

            while not reDisplaySystemMessage and tick() - now < 10 do
                pcall(function()
                    reDisplaySystemMessage = obj.RE_DisplaySystemMessage
                end)

                if not reDisplaySystemMessage then
                    task.wait(0.5)
                end
            end

            if not reDisplaySystemMessage then
                return
            end

            tbl30.chatConn = reDisplaySystemMessage.OnClientEvent:Connect(function(arg, arg2)
                if type(arg) ~= "string" or arg2 ~= nil then
                    return
                end

                if not arg:find("obtained") or not arg:find("<font") then
                    return
                end
                fn75(arg)
            end)
        end)
    end

    local function fn77(arg, arg2)
        local urlJoinLeave = tbl30.urlJoinLeave ~= "" and tbl30.urlJoinLeave or tbl30.url
        if not tbl30.enabled or urlJoinLeave == "" then
            return
        end

        if arg2 and not tbl30.trackJoin then
            return
        end

        if not arg2 and not tbl30.trackLeave then
            return
        end
        local displayName = arg.DisplayName
        local name = displayName or arg.Name
        local tbl35 = {}
        local headerTitle = arg2 and "Player Joined" or "Player Left"
        tbl35.headerTitle = headerTitle
        local format = string.format
        local str2 = arg2 and "joined" or "left"
        tbl35.bodyText = format("**||%s||** has %s the server.", name, str2)
        local color = arg2 and 5635925 or 16733525
        tbl35.color = color
        local fields = {}

        local tbl36 = {
            name = "〢Display Name :",
            value = "||" .. name .. "||",
            inline = false,
        }

        local tbl37 = {name = "〢Status :"}
        local value = arg2 and "Joined" or "Left"
        tbl37.value = value
        tbl37.inline = false
        fields[1] = tbl36
        fields[2] = tbl37
        tbl35.fields = fields
        fn50(urlJoinLeave, fn53(tbl35))
    end

    v22:AddParagraph({
        Title = "Info",
        Content = "Monitors server chat for fish catch logs.\nAlso tracks player join/leave events.",
    })

    v22:AddInput({
        Title = "Webhook URL (Server)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl30.url = fn46(arg)
        end,
    })

    v22:AddInput({
        Title = "Webhook URL (Join/Leave)",
        Default = "",
        Placeholder = "Optional, uses Server URL if empty",
        Callback = function(arg)
            tbl30.urlJoinLeave = fn46(arg)
        end,
    })

    v22:AddInput({
        Title = "Custom Display Name",
        Default = "",
        Callback = function(arg)
            tbl30.customName = fn46(arg)
        end,
    })

    v22:AddDropdown({
        Title = "Select Tiers to Log",
        Options = {"Epic", "Legendary", "Mythic", "SECRET", "FORGOTTEN"},
        Multi = true,
        Default = {},
        Callback = function(arg)
            for k in pairs(tbl30.selectedTiers) do
                tbl30.selectedTiers[k] = false
            end

            if type(arg) == "table" then
                for i, v24 in ipairs(arg) do
                    tbl30.selectedTiers[v24] = true
                end
            end
        end,
    })

    v22:AddToggle({
        Title = "Track Player Join",
        Default = false,
        Callback = function(trackJoin)
            tbl30.trackJoin = trackJoin
        end,
    })

    v22:AddToggle({
        Title = "Track Player Leave",
        Default = false,
        Callback = function(trackLeave)
            tbl30.trackLeave = trackLeave
        end,
    })

    v22:AddToggle({
        Title = "Enable Webhook Server",
        Default = false,
        Callback = function(enabled)
            tbl30.enabled = enabled

            if enabled then
                if tbl30.url == "" and tbl30.urlJoinLeave == "" then
                    lib:MakeNotify({
                        Title = "Webhook",
                        Description = "Server webhook URL is not set!",
                        Delay = 3,
                    })

                    return
                end

                if not fn45() then
                    return
                end
                task.spawn(fn56)
                task.spawn(fn64)
                task.spawn(fn66)
                fn76()

                if not tbl30.joinConn then
                    tbl30.joinConn = Players.PlayerAdded:Connect(function(player)
                        fn77(player, true)
                    end)
                end

                if not tbl30.leaveConn then
                    tbl30.leaveConn = Players.PlayerRemoving:Connect(function(player)
                        fn77(player, false)
                    end)
                end
            else
                if tbl30.chatConn then
                    tbl30.chatConn:Disconnect()
                    tbl30.chatConn = nil
                end

                if tbl30.joinConn then
                    tbl30.joinConn:Disconnect()
                    tbl30.joinConn = nil
                end

                if tbl30.leaveConn then
                    tbl30.leaveConn:Disconnect()
                    tbl30.leaveConn = nil
                end
            end
        end,
    })

    v22:AddButton({
        Title = "Test Webhook Server",
        Callback = function()
            if tbl30.url == "" and tbl30.urlJoinLeave == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Server webhook URL is not set!",
                    Delay = 3,
                })

                return
            end

            local flag9 = tbl30.url ~= "" and fn51(tbl30.url, fn53({
                headerTitle = "Fish Caught",
                bodyText = "**Lynx** You have obtained a new **FORGOTTEN** fish!",
                color = 5614335,
                imageUrl = "https://i.imgur.com/UMWNYK7.png",
                fields = {
                    {
                        name = "〢Fish Name :",
                        value = "Webhook Test",
                        inline = false,
                    },
                    {
                        name = "〢Fish Tier :",
                        value = "FORGOTTEN",
                        inline = false,
                    },
                    {name = "〢Variant :", value = "Corrupt", inline = false},
                    {name = "〢Weight :", value = "471.10Kg", inline = false},
                    {name = "〢Scope :", value = "[Server]", inline = false},
                    {
                        name = "〢Chance :",
                        value = "1 in 1,000,000",
                        inline = false,
                    },
                },
            }))

            local urlJoinLeave = tbl30.urlJoinLeave ~= "" and tbl30.urlJoinLeave or tbl30.url

            local flag10 = urlJoinLeave ~= "" and fn51(urlJoinLeave, fn53({
                headerTitle = "Player Joined",
                bodyText = "**||TestUser||** has joined the server. (Test)",
                color = 5635925,
                fields = {
                    {
                        name = "〢Display Name :",
                        value = "||TestUser||",
                        inline = false,
                    },
                    {name = "〢Status :", value = "Joined", inline = false},
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl35 = {Title = "Webhook"}
            local description = (flag9 or flag10) and "Server webhook test sent!" or "Failed! Check executor / URL."
            tbl35.Description = description
            local delay = (flag9 or flag10) and 3 or 4
            tbl35.Delay = delay
            makeNotify(lib, tbl35)
        end,
    })

    local v24 = v19:AddSection("Event Spawn Webhook")

    local tbl35 = {
        url = "",
        enabled = false,
        selectedEvents = {},
        activeEvents = {},
        conn = nil,
    }

    local function fn78()
        local tbl36 = {}
        local v25 = fn(ReplicatedStorage:FindFirstChild("Events"))
        if not v25 then
            return tbl36
        end

        local tbl37 = {
            Cloudy = true,
            Day = true,
            ["Increased Luck"] = true,
            Mutated = true,
            Night = true,
            Snow = true,
            ["Sparkling Cove"] = true,
            Storm = true,
            Wind = true,
            Radiant = true,
            ["Present Rain"] = true,
            ["Admin - Super Mutated"] = true,
            ["Admin - Shocked"] = true,
            ["Admin - MEGA Luck"] = true,
            ["Admin - Super Luck"] = true,
            ["Admin - Night Celebration"] = true,
            ["Admin - Forgotten Tier"] = true,
            ["Admin - Galaxy Storm"] = true,
            ["Admin - 1x1x1x1 Rage"] = true,
            ["Admin - 2025 Anniversary"] = true,
            ["Admin - 2025 Christmas"] = true,
            ["Admin - 2026 Valentines"] = true,
            ["Admin - 3RR0R 3V3NT"] = true,
            ["Admin - Volcano Eruption"] = true,
            ["Admin - Meteor Rain"] = true,
            ["Admin - Leviathan Awakening"] = true,
        }

        for k, v26 in pairs(v25) do
            if v26.Coordinates and not tbl37[k] then
                table.insert(tbl36, k)
            end
        end

        table.sort(tbl36)
        return tbl36
    end

    v24:AddParagraph({
        Title = "Info",
        Content = "Sends a Discord notification when selected events spawn.",
    })

    v24:AddInput({
        Title = "Webhook URL (Event)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl35.url = fn46(arg)
        end,
    })

    local v25 = v24:AddDropdown({
        Title = "Select Events",
        Options = fn78(),
        Default = {},
        Multi = true,
        Callback = function(arg)
            local selectedEvents = type(arg) == "table" and arg

            if not selectedEvents then
                selectedEvents = arg

                if arg then
                    local tbl36 = {}
                    selectedEvents = tbl36
                    tbl36[1] = arg
                end

                if not selectedEvents then
                    selectedEvents = {}
                end
            end

            tbl35.selectedEvents = selectedEvents
        end,
    })

    v24:AddButton({
        Title = "Refresh Event List",
        Callback = function()
            if v25 and v25.SetOptions then
                v25:SetOptions(fn78())
            end

            lib:MakeNotify({
                Title = "Webhook",
                Description = "Event list refreshed.",
                Delay = 3,
            })
        end,
    })

    local function fn79(arg)
        local str2 = "https://i.imgur.com/UMWNYK7.png"
        local n5 = 16766720

        pcall(function()
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            local events = playerGui and playerGui:FindFirstChild("Events") and playerGui.Events:FindFirstChild("Frame") and playerGui.Events.Frame:FindFirstChild("Events")

            if events then
                local v26 = events:FindFirstChild(arg)
                local v27 = v26

                if v26 and v26:IsA("Frame") then
                    local imageLabel = v26:FindFirstChildOfClass("ImageLabel")
                    local imageButton = imageLabel or v26:FindFirstChildOfClass("ImageButton")
                    v27 = imageButton
                end

                if v27 and (v27:IsA("ImageLabel") or v27:IsA("ImageButton")) then
                    local v28 = fn60(v27.Image)

                    if v28 then
                        local v29 = fn59(v28)

                        if v29 and v29 ~= "" then
                            str2 = v29
                        end
                    end

                    local imageColor3 = v27.ImageColor3
                    n5 = math.floor(imageColor3.R * 255) * 65536 + math.floor(imageColor3.G * 255) * 256 + math.floor(imageColor3.B * 255)
                    local uiGradient = v27:FindFirstChildOfClass("UIGradient")
                    local uiGradient2 = uiGradient or v26 and v26:FindFirstChildOfClass("UIGradient")

                    if uiGradient2 and uiGradient2.Color and uiGradient2.Color.Keypoints and uiGradient2.Color.Keypoints[1] then
                        local value = uiGradient2.Color.Keypoints[1].Value
                        n5 = math.floor(value.R * 255) * 65536 + math.floor(value.G * 255) * 256 + math.floor(value.B * 255)
                    end
                end
            end
        end)

        if str2 == "https://i.imgur.com/UMWNYK7.png" and (arg == "Ghost Shark Hunt" or arg == "Shark Hunt" or arg == "Megalodon Hunt") then
            local v26 = fn59("74938397479780")

            if v26 and v26 ~= "" then
                str2 = v26
            end

            n5 = 7603173
        end

        return str2, n5
    end

    v24:AddToggle({
        Title = "Enable Event Spawn Webhook",
        Default = false,
        Callback = function(enabled)
            tbl35.enabled = enabled

            if tbl35.conn then
                pcall(function()
                    tbl35.conn:Disconnect()
                end)

                tbl35.conn = nil
            end

            if not enabled then
                return
            end

            if tbl35.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Event URL is not set!",
                    Delay = 3,
                })

                return
            end

            local v26 = fn3()
            if not v26 then
                return
            end
            local replion = nil

            pcall(function()
                replion = v26.Client:GetReplion("Events")
            end)

            if not replion then
                pcall(function()
                    replion = v26.Client:WaitReplion("Events")
                end)
            end

            if replion then
                local function fn80()
                    local Events = replion:Get("Events")
                    local activeEvents = {}

                    if Events then
                        for k, Event in pairs(Events) do
                            if typeof(Event) == "string" then
                                activeEvents[Event] = true
                            end
                        end
                    end

                    for i, selectedEvent in ipairs(tbl35.selectedEvents) do
                        if activeEvents[selectedEvent] and not tbl35.activeEvents[selectedEvent] then
                            local v27, v28 = fn79(selectedEvent)

                            fn50(tbl35.url, fn53({
                                headerTitle = "Event Started",
                                bodyText = string.format("**||Event Alert||** **%s** has started in your server!", selectedEvent),
                                color = v28,
                                imageUrl = v27,
                                fields = {
                                    {name = "〢Event Name :", value = selectedEvent, inline = false},
                                    {
                                        name = "〢Server ID :",
                                        value = "||" .. game.JobId .. "||",
                                        inline = false,
                                    },
                                    {
                                        name = "〢Time :",
                                        value = os.date("%m/%d/%Y at %I:%M %p"),
                                        inline = false,
                                    },
                                },
                            }))
                        end
                    end

                    tbl35.activeEvents = activeEvents
                end

                local Events = replion:Get("Events")

                if Events then
                    for k, Event in pairs(Events) do
                        if typeof(Event) == "string" then
                            tbl35.activeEvents[Event] = true
                        end
                    end
                end

                tbl35.conn = replion:OnChange("Events", fn5(function()
                    if not tbl35.enabled or tbl35.url == "" then
                        return
                    end
                    fn80()
                end))
            end
        end,
    })

    v24:AddButton({
        Title = "Test Event Webhook",
        Callback = function()
            if tbl35.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Event URL is not set!",
                    Delay = 3,
                })

                return
            end

            local megalodonHunt, v26 = fn79("Megalodon Hunt")

            local v27 = fn51(tbl35.url, fn53({
                headerTitle = "Event Started",
                bodyText = "**||Event Alert||** **Megalodon Hunt** has started in your server! (Test)",
                color = v26,
                imageUrl = megalodonHunt,
                fields = {
                    {
                        name = "〢Event Name :",
                        value = "Megalodon Hunt",
                        inline = false,
                    },
                    {
                        name = "〢Server ID :",
                        value = "||" .. game.JobId .. "||",
                        inline = false,
                    },
                    {
                        name = "〢Time :",
                        value = os.date("%m/%d/%Y at %I:%M %p"),
                        inline = false,
                    },
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl36 = {Title = "Webhook"}
            local description = v27 and "Event test sent!" or "Failed! Check executor / URL."
            tbl36.Description = description
            local delay = v27 and 3 or 4
            tbl36.Delay = delay
            makeNotify(lib, tbl36)
        end,
    })

    local v26 = v19:AddSection("Treasure Hunt Webhook")
    local tbl36 = {url = "", id = "", hide = "", enabled = false, conn = nil}

    v26:AddParagraph({
        Title = "Info",
        Content = "Sends a Discord notification when a Treasure Hunt (Sunken Wreckage) event starts in the server.",
    })

    v26:AddInput({
        Title = "Webhook URL (Treasure Hunt)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl36.url = fn46(arg)
        end,
    })

    v26:AddInput({
        Title = "Discord User ID (Treasure Hunt)",
        Default = "",
        Placeholder = "123456789012345678",
        Callback = function(arg)
            tbl36.id = fn47(arg)
        end,
    })

    v26:AddInput({
        Title = "Hide Identity (Treasure Hunt)",
        Default = "",
        Placeholder = "Enter custom name...",
        Callback = function(arg)
            tbl36.hide = fn46(arg)
        end,
    })

    v26:AddToggle({
        Title = "Enable Treasure Hunt Webhook",
        Default = false,
        Callback = function(enabled)
            tbl36.enabled = enabled

            if tbl36.conn then
                pcall(function()
                    tbl36.conn:Disconnect()
                end)

                tbl36.conn = nil
            end

            if not enabled then
                return
            end

            if tbl36.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Treasure Hunt URL is not set!",
                    Delay = 3,
                })

                return
            end

            if not fn45() then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Executor does not support HTTP!",
                    Delay = 3,
                })

                return
            end

            local function fn80(arg)
                if not tbl36.enabled or tbl36.url == "" then
                    return
                end
                local v27 = fn54(tbl36.hide)
                local str2 = "Unknown"

                pcall(function()
                    local position = arg:GetPivot().Position
                    str2 = string.format("%.1f, %.1f, %.1f", position.X, position.Y, position.Z)
                end)

                local n5 = 0

                pcall(function()
                    for i, child in ipairs(arg:GetChildren()) do
                        if child.Name == "Treasure" then
                            n5 = n5 + 1
                        end
                    end
                end)

                fn50(tbl36.url, fn53({
                    userId = tbl36.id,
                    alertText = "Treasure Hunt event started!",
                    headerTitle = "Treasure Hunt",
                    bodyText = string.format("**||%s||** A **Treasure Hunt** event has started in your server!", v27),
                    color = 16744272,
                    fields = {
                        {
                            name = "〢Event :",
                            value = "Sunken Wreckage",
                            inline = false,
                        },
                        {
                            name = "〢Chests :",
                            value = tostring(n5) .. " chest(s)",
                            inline = false,
                        },
                        {name = "〢Location :", value = str2, inline = false},
                        {
                            name = "〢Server ID :",
                            value = "||" .. game.JobId .. "||",
                            inline = false,
                        },
                        {
                            name = "〢Time :",
                            value = os.date("%m/%d/%Y at %I:%M %p"),
                            inline = false,
                        },
                    },
                }))
            end

            tbl36.conn = workspace.ChildAdded:Connect(function(child)
                if not tbl36.enabled then
                    return
                end

                if child.Name == "Sunken Wreckage" then
                    task.wait(1)

                    task.spawn(function()
                        fn80(child)

                        lib:MakeNotify({
                            Title = "Treasure Hunt Webhook",
                            Description = "Notification sent to Discord!",
                            Color = Color3.fromRGB(255, 140, 0),
                            Delay = 3,
                        })
                    end)
                end
            end)

            local sunkenWreckage = workspace:FindFirstChild("Sunken Wreckage")

            if sunkenWreckage then
                task.spawn(function()
                    fn80(sunkenWreckage)

                    lib:MakeNotify({
                        Title = "Treasure Hunt Webhook",
                        Description = "Event already active — notification sent!",
                        Color = Color3.fromRGB(255, 140, 0),
                        Delay = 3,
                    })
                end)
            end
        end,
    })

    v26:AddButton({
        Title = "Test Treasure Hunt Webhook",
        Callback = function()
            if tbl36.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Treasure Hunt URL is not set!",
                    Delay = 3,
                })

                return
            end

            local v27 = fn54(tbl36.hide)

            local v28 = fn51(tbl36.url, fn53({
                userId = tbl36.id,
                alertText = "Treasure Hunt event started!",
                headerTitle = "Treasure Hunt",
                bodyText = string.format("**||%s||** A **Treasure Hunt** event has started in your server!", v27),
                color = 16744272,
                fields = {
                    {
                        name = "〢Event :",
                        value = "Sunken Wreckage",
                        inline = false,
                    },
                    {name = "〢Chests :", value = "5 chest(s)", inline = false},
                    {
                        name = "〢Location :",
                        value = "120.0, -45.0, 300.0",
                        inline = false,
                    },
                    {
                        name = "〢Server ID :",
                        value = "||" .. game.JobId .. "||",
                        inline = false,
                    },
                    {
                        name = "〢Time :",
                        value = os.date("%m/%d/%Y at %I:%M %p"),
                        inline = false,
                    },
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl37 = {Title = "Webhook"}
            local description = v28 and "Treasure Hunt test sent!" or "Failed! Check executor / URL."
            tbl37.Description = description
            local delay = v28 and 3 or 4
            tbl37.Delay = delay
            makeNotify(lib, tbl37)
        end,
    })

    local tbl37 = {
        url = "",
        id = "",
        hide = "",
        enabled = false,
        conn = nil,
        claimConn = nil,
    }

    local v27 = v19:AddSection("Treasure Hunt Reward Webhook")

    v27:AddParagraph({
        Title = "Info",
        Content = "Sends a Discord notification when you receive a reward from a Treasure Hunt chest.",
    })

    v27:AddInput({
        Title = "Webhook URL (Treasure Reward)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl37.url = fn46(arg)
        end,
    })

    v27:AddInput({
        Title = "Discord User ID (Treasure Reward)",
        Default = "",
        Placeholder = "123456789012345678",
        Callback = function(arg)
            tbl37.id = fn47(arg)
        end,
    })

    v27:AddInput({
        Title = "Hide Identity (Treasure Reward)",
        Default = "",
        Placeholder = "Enter custom name...",
        Callback = function(arg)
            tbl37.hide = fn46(arg)
        end,
    })

    v27:AddToggle({
        Title = "Enable Treasure Reward Webhook",
        Default = false,
        Callback = function(enabled)
            tbl37.enabled = enabled

            if tbl37.conn then
                pcall(function()
                    tbl37.conn:Disconnect()
                end)

                tbl37.conn = nil
            end

            if tbl37.claimConn then
                pcall(function()
                    tbl37.claimConn:Disconnect()
                end)

                tbl37.claimConn = nil
            end

            if not enabled then
                return
            end

            if tbl37.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Treasure Reward URL is not set!",
                    Delay = 3,
                })

                return
            end

            if not fn45() then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Executor does not support HTTP!",
                    Delay = 3,
                })

                return
            end

            local reTreasureChestClaimed = obj.RE_TreasureChestClaimed

            if not reTreasureChestClaimed then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "TreasureChestClaimed event not found!",
                    Delay = 3,
                })

                return
            end

            local flag9 = false

            tbl37.conn = reTreasureChestClaimed.OnClientEvent:Connect(function(arg, arg2)
                if not tbl37.enabled or not arg then
                    return
                end
                flag9 = {itemData = arg, tierKey = arg2, time = os.clock()}

                task.delay(3, function()
                    flag9 = false
                end)
            end)

            local function fn80(arg, arg2, arg3, arg4, arg5)
                local v28 = fn54(tbl37.hide)

                fn50(tbl37.url, fn53({
                    userId = tbl37.id,
                    alertText = "Treasure Hunt reward received!",
                    headerTitle = "Treasure Hunt Reward",
                    bodyText = string.format("**||%s||** obtained a reward from **Treasure Hunt**!", v28),
                    color = arg4,
                    imageUrl = arg5,
                    fields = {
                        {name = "〢Item :", value = arg, inline = false},
                        {name = "〢Type :", value = arg2, inline = false},
                        {name = "〢Tier :", value = arg3, inline = false},
                        {
                            name = "〢Server ID :",
                            value = "||" .. game.JobId .. "||",
                            inline = false,
                        },
                        {
                            name = "〢Time :",
                            value = os.date("%m/%d/%Y at %I:%M %p"),
                            inline = false,
                        },
                    },
                }))
            end

            pcall(function()
                fn(ReplicatedStorage.Packages.Replion).Client:AwaitReplion("Data", function(arg)
                    local v28 = fn(ReplicatedStorage.Modules.CurrencyUtility.Currency)

                    for k, v29 in pairs(v28) do
                        arg:OnChange(v29.Path, fn5(function(arg2, arg3)
                            if not tbl37.enabled or not flag9 then
                                return
                            end
                            local n5 = arg3 or 0
                            if arg2 <= n5 then
                                return
                            end
                            local v30 = flag9
                            flag9 = false

                            task.spawn(function()
                                pcall(function()
                                    local singular = v29.Singular
                                    local prefix = singular or v29.Prefix or k
                                    local type_ = v30.itemData.Type
                                    local str2 = type_ or "Unknown"
                                    local str3 = "https://i.imgur.com/UMWNYK7.png"
                                    local v31 = fn60(v29.Icon)

                                    if v31 then
                                        pcall(function()
                                            local v32 = fn59(v31)

                                            if v32 and v32 ~= "" then
                                                str3 = v32
                                            end
                                        end)
                                    end

                                    local v32 = tbl18[1]
                                    local n6 = v32 or 3447003
                                    fn80(prefix, str2, "Common", n6, str3)
                                end)
                            end)
                        end))
                    end

                    arg:OnChange({"Inventory"}, fn5(function(arg2, arg3)
                        if not tbl37.enabled or not flag9 then
                            return
                        end
                        local v29 = flag9
                        flag9 = false

                        task.spawn(function()
                            pcall(function()
                                local itemData = v29.itemData
                                local tierKey = v29.tierKey
                                local type_ = itemData.Type
                                local str2 = type_ or "Unknown"
                                local id = itemData.Id
                                local n5 = id or 0
                                local str3 = tostring(n5)
                                local n6 = 1
                                local str4 = "https://i.imgur.com/UMWNYK7.png"

                                local function fn81(arg4)
                                    if not arg4 or arg4 == "" then
                                        return
                                    end

                                    pcall(function()
                                        local v30 = fn59(arg4)

                                        if v30 and v30 ~= "" then
                                            str4 = v30
                                        end
                                    end)
                                end

                                pcall(function()
                                    local v30 = fn(ReplicatedStorage.Shared.ItemUtility).GetItemDataFromItemType(str2, n5)

                                    if v30 and v30.Data then
                                        local data = v30.Data
                                        local displayName = data.DisplayName
                                        local name = displayName or data.Name or str3
                                        str3 = name
                                        local tier = data.Tier
                                        local n7 = tier or 1
                                        n6 = n7
                                        local v31 = fn60(data.Icon)
                                        local v32 = v31 or fn60(data.ImageId) or fn60(data.Image) or fn60(data.Thumbnail)
                                        fn81(v32)
                                    end
                                end)

                                if str3 == tostring(n5) then
                                    pcall(function()
                                        local lanterns = ReplicatedStorage.Modules.ModelDownloader.Collection:FindFirstChild("Lanterns")

                                        if lanterns then
                                            for i, child in ipairs(lanterns:GetChildren()) do
                                                if tostring(n5):lower() == child.Name:lower() or child.Name:lower():find(tostring(n5):lower(), 1, true) then
                                                    str3 = child.Name
                                                    local attribute = child:GetAttribute("Tier")
                                                    local n7 = attribute or 5
                                                    n6 = n7
                                                    local decal = child:FindFirstChildOfClass("Decal")
                                                    local imageLabel = decal or child:FindFirstChildOfClass("ImageLabel")

                                                    if imageLabel then
                                                        local texture = imageLabel.Texture
                                                        local image = texture or imageLabel.Image
                                                        fn81(fn60(image))
                                                    end

                                                    break
                                                end

                                                continue
                                            end
                                        end
                                    end)
                                end

                                local str5 = tbl17[n6] or "Unknown"
                                local n7 = tbl18[n6] or 3447003

                                if tierKey then
                                    pcall(function()
                                        local v30 = fn(ReplicatedStorage.Tiers)[tierKey]

                                        if v30 then
                                            str5 = tierKey
                                            local tierColor = v30.TierColor
                                            local keypoints = tierColor and v30.TierColor.Keypoints

                                            if keypoints and keypoints[1] then
                                                local value = keypoints[1].Value
                                                n7 = math.floor(value.R * 255) * 65536 + math.floor(value.G * 255) * 256 + math.floor(value.B * 255)
                                            end
                                        end
                                    end)
                                end

                                fn80(str3, str2, str5, n7, str4)
                            end)
                        end)
                    end))
                end)
            end)

            lib:MakeNotify({
                Title = "Treasure Reward Webhook",
                Description = "Listening for Treasure Hunt rewards!",
                Color = Color3.fromRGB(255, 140, 0),
                Delay = 2,
            })
        end,
    })

    local v28 = v19:AddSection("Booth Sold Webhook")
    local tbl38 = {url = "", id = "", hide = "", enabled = false, conn = nil}

    v28:AddParagraph({
        Title = "Info",
        Content = "Sends a Discord notification when someone buys an item from your booth.",
    })

    v28:AddInput({
        Title = "Webhook URL (Booth)",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(arg)
            tbl38.url = fn46(arg)
        end,
    })

    v28:AddInput({
        Title = "Discord User ID (Booth)",
        Default = "",
        Placeholder = "123456789012345678",
        Callback = function(arg)
            tbl38.id = fn47(arg)
        end,
    })

    v28:AddInput({
        Title = "Hide Identity (Booth)",
        Default = "",
        Placeholder = "Enter custom name...",
        Callback = function(arg)
            tbl38.hide = fn46(arg)
        end,
    })

    v28:AddToggle({
        Title = "Enable Booth Sold Webhook",
        Default = false,
        Callback = function(enabled)
            tbl38.enabled = enabled

            if enabled then
                if tbl38.url == "" then
                    lib:MakeNotify({
                        Title = "Webhook",
                        Description = "Booth webhook URL is not set!",
                        Delay = 3,
                    })

                    return
                end

                if not fn45() then
                    warn("[Webhook] Executor does not support HTTP!")
                    return
                end

                if tbl38.conn then
                    return
                end
                task.spawn(fn56)

                task.spawn(function()
                    local v29 = fn(ReplicatedStorage.Shared.Trading.TradeData)
                    if not v29 then
                        warn("[Webhook] Failed to load TradeData!")
                        return
                    end
                    local v30 = fn(ReplicatedStorage.Shared.ItemUtility)

                    tbl38.conn = v29.Remotes.SaleListingSold.OnClientEvent:Connect(function(arg, arg2, arg3, arg4, arg5, arg6)
                        task.spawn(function()
                            if not tbl38.enabled or tbl38.url == "" then
                                return
                            end
                            local str2 = "Unknown"
                            local str3 = "Unknown"
                            local n5 = 3447003
                            local str4 = "https://i.imgur.com/UMWNYK7.png"
                            local v31 = nil

                            pcall(function()
                                if v30 and arg5 then
                                    local getItemDataFromItemType = v30.GetItemDataFromItemType
                                    local id = arg5.Id
                                    local name = id or arg5.Name
                                    v31 = getItemDataFromItemType(arg4, name)

                                    if v31 and v31.Data then
                                        local data = v31.Data
                                        local displayName = data.DisplayName
                                        local name2 = displayName or data.Name or str2
                                        str2 = name2
                                        local tier = data.Tier
                                        local n6 = tier or 1
                                        local v32 = tbl17[n6]
                                        local v33 = v32 or str3
                                        str3 = v33
                                        local v34 = tbl18[n6]
                                        local v35 = v34 or n5
                                        n5 = v35
                                        local v36 = fn60(data.Icon)
                                        local v37 = v36 or fn60(data.ImageId) or fn60(data.Image)

                                        if v37 then
                                            local v38 = fn59(v37)

                                            if v38 and v38 ~= "" then
                                                str4 = v38
                                            end
                                        end
                                    end
                                end
                            end)

                            if str2 == "Unknown" and arg5 then
                                local displayName = arg5.DisplayName
                                local name = displayName or arg5.Name

                                if not name then
                                    local v32 = tostring
                                    local id = arg5.Id
                                    local str5 = id or "Unknown"
                                    name = v32(str5)
                                end

                                str2 = name
                            end

                            if str3 == "Unknown" and arg5 and arg5.Tier then
                                local v32 = tbl17[arg5.Tier]
                                local str5 = v32 or "Unknown"
                                str3 = str5
                                local v33 = tbl18[arg5.Tier]
                                local v34 = v33 or n5
                                n5 = v34
                            end

                            local v32 = fn54(tbl38.hide)
                            local name = arg

                            if arg then
                                local displayName = arg.DisplayName
                                name = displayName or arg.Name
                            end

                            if not name then
                                name = "Unknown"
                            end

                            local n6 = arg6 or 0
                            local v33 = fn48(n6)
                            local url = tbl38.url

                            local tbl39 = {
                                userId = tbl38.id,
                                alertText = "Your item was sold at the booth!",
                                headerTitle = "Booth Item Sold",
                                bodyText = string.format("**||%s||**'s item was purchased from the booth!", v32),
                                color = n5,
                                imageUrl = str4,
                            }

                            local fields = {}
                            local tbl40 = {name = "〢Item Name :", value = str2, inline = false}
                            local tbl41 = {name = "〢Item Tier :", value = str3, inline = false}
                            local tbl42 = {name = "〢Item Type :"}
                            local v34 = tostring
                            local str5 = arg4 or "Unknown"
                            tbl42.value = v34(str5)
                            tbl42.inline = false
                            fields[1] = tbl40
                            fields[2] = tbl41
                            fields[3] = tbl42
                            fields[4] = {name = "〢Bought by :", value = name, inline = false}

                            fields[5] = {
                                name = "〢Tokens Received :",
                                value = v33 .. " Trade Tokens",
                                inline = false,
                            }

                            tbl39.fields = fields
                            fn50(url, fn53(tbl39))
                        end)
                    end)
                end)
            elseif tbl38.conn then
                tbl38.conn:Disconnect()
                tbl38.conn = nil
            end
        end,
    })

    v28:AddButton({
        Title = "Test Booth Sold Webhook",
        Callback = function()
            if tbl38.url == "" then
                lib:MakeNotify({
                    Title = "Webhook",
                    Description = "Booth webhook URL is not set!",
                    Delay = 3,
                })

                return
            end

            local v29 = fn54(tbl38.hide)

            local v30 = fn51(tbl38.url, fn53({
                userId = tbl38.id,
                alertText = "Your item was sold at the booth!",
                headerTitle = "Booth Item Sold",
                bodyText = string.format("**||%s||**'s item was purchased from the booth! *(Test)*", v29),
                color = 15844367,
                imageUrl = "https://i.imgur.com/UMWNYK7.png",
                fields = {
                    {
                        name = "〢Item Name :",
                        value = "Booth Sold Test",
                        inline = false,
                    },
                    {
                        name = "〢Item Tier :",
                        value = "FORGOTTEN",
                        inline = false,
                    },
                    {name = "〢Item Type :", value = "Fish", inline = false},
                    {
                        name = "〢Bought by :",
                        value = "TestPlayer",
                        inline = false,
                    },
                    {
                        name = "〢Tokens Received :",
                        value = "10,000 Trade Tokens",
                        inline = false,
                    },
                },
            }))

            local makeNotify = lib.MakeNotify
            local tbl39 = {Title = "Webhook"}
            local description = v30 and "Booth sold test sent!" or "Failed! Check executor / URL."
            tbl39.Description = description
            local delay = v30 and 3 or 4
            tbl39.Delay = delay
            makeNotify(lib, tbl39)
        end,
    })
end

do
    local v5 = v3:AddTab({Name = "Skin Features", Icon = "user"})

    local function fn6(arg, arg2, arg3)
        local makeNotify = lib.MakeNotify
        local tbl4 = {Title = arg, Description = arg2}
        local delay = arg3 or 3
        tbl4.Delay = delay
        makeNotify(lib, tbl4)
    end

    local function fn7(arg, arg2)
        pcall(function()
            if arg.Refresh then
                arg:Refresh(arg2, true)
            elseif arg.SetOptions then
                arg:SetOptions(arg2)
            end
        end)
    end

    local function fn8(arg)
        local tbl4 = {}

        for k in pairs(arg) do
            tbl4[#tbl4 + 1] = k
        end

        table.sort(tbl4)
        return tbl4
    end

    local v6 = v5:AddSection("Accessory Changer")
    local accessoryAktif = nil
    local accessory = nil

    local function fn9()
        if accessory and accessory.Parent then
            return accessory
        end

        pcall(function()
            accessory = ReplicatedStorage:WaitForChild("Controllers", 10):WaitForChild("AccessoryReplicationController", 5):WaitForChild("Accessory", 5)
        end)

        return accessory
    end

    local function fn10(arg)
        return pcall(function()
            localPlayer:SetAttribute("FishingRodSkin", arg)
        end)
    end

    local function fn11()
        local v7 = fn9()
        if not v7 then
            return {}
        end
        local tbl4 = {}

        for i, child in ipairs(v7:GetChildren()) do
            tbl4[#tbl4 + 1] = child.Name
        end

        table.sort(tbl4)
        return tbl4
    end

    local flag4 = false

    local v7 = v6:AddDropdown({
        Title = "Pilih Accessory",
        Options = {},
        NoSave = false,
        Callback = function(accessoryAktif2)
            accessoryAktif = accessoryAktif2

            if flag4 then
                local v7 = fn10(accessoryAktif2)
                local str2 = v7 and "Accessory aktif: " .. accessoryAktif2 or "Gagal apply accessory!"
                fn6("Accessory", str2)
            end
        end,
    })

    v6:AddButton({
        Title = "Refresh Accessory List",
        Callback = function()
            task.spawn(function()
                local v8 = fn11()
                fn7(v7, v8)
                local str2 = #v8 > 0 and "Loaded " .. #v8 .. " accessories." or "Accessory folder tidak ditemukan!"
                fn6("Accessory", str2, 2)
            end)
        end,
    })

    v6:AddToggle({
        Title = "Enable Accessory",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if not arg then
                flag4 = false
                fn10(nil)
                fn6("Accessory", "Accessory dilepas.", 2)
                return
            end

            if not accessoryAktif then
                fn6("Accessory", "Pilih accessory dulu dari dropdown!", 2)
                return
            end

            if not fn9() then
                fn6("Accessory", "Gagal akses AccessoryFolder!")
                return
            end
            flag4 = true
            local v8 = fn10(accessoryAktif)
            local str2 = v8 and "Accessory aktif: " .. accessoryAktif or "Gagal apply accessory!"
            fn6("Accessory", str2)
        end,
    })

    v6:AddButton({
        Title = "Remove Accessory",
        Callback = function()
            flag4 = false
            fn10(nil)
            fn6("Accessory", "Accessory dilepas.", 2)
        end,
    })

    local v8 = v5:AddSection("Rod Model Skin", false)

    local tbl4 = {
        enabled = false,
        choice = nil,
        clone = nil,
        viewModel = nil,
        hidden = {},
        conn = nil,
        thread = nil,
    }

    local tbl5 = {}
    local flag5 = false

    local function fn12(arg)
        if not arg:IsA("Model") then
            return false
        end

        for i, descendant in ipairs(arg:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                return true
            end
        end

        return false
    end

    local function fn13()
        local ok, result = pcall(function()
            return ReplicatedStorage.Modules.ModelDownloader.Collection:FindFirstChild("Fishing Rods")
        end)

        local v9 = ok and result or nil
        return v9
    end

    local function fn14()
        flag5 = true
        local v9 = fn13()

        if v9 then
            for i, child in ipairs(v9:GetChildren()) do
                if fn12(child) then
                    tbl5[child.Name] = child
                end
            end
        end

        pcall(function()
            local v10, v11, v12 = ipairs(ReplicatedStorage.Assets:GetChildren())
            local v13 = v12
            local v14 = v10
            local v15 = v11

            while true do
                local v16, v17 = v14(v15, v13)
                if v16 == nil then
                    break
                end
                v13 = v16

                if v17:IsA("Model") then
                    for i, child in ipairs(v17:GetChildren()) do
                        if fn12(child) then
                            tbl5[child.Name] = child
                        end
                    end

                    v13 = v16
                end
            end
        end)

        pcall(function()
            local tbl6 = {}
            local v10 = pairs
            local v11 = fn(ReplicatedStorage.Items)
            local tbl7 = v11 or {}

            for k, v12 in v10(tbl7) do
                local data = v12.Data

                if data and data.Type == "Fishing Rods" and data.Name then
                    tbl6[data.Name] = true
                end
            end

            for i, descendant in ipairs(workspace:GetDescendants()) do
                if tbl6[descendant.Name] and not tbl5[descendant.Name] and fn12(descendant) then
                    tbl5[descendant.Name] = descendant
                end
            end
        end)

        return fn8(tbl5)
    end

    local function fn15(arg)
        local v9 = tbl5[arg]
        if v9 and v9.Parent then
            return v9
        end
        tbl5[arg] = nil
        fn14()
        return tbl5[arg]
    end

    local function fn16()
        local character = localPlayer.Character
        local fishingViewModel = character and character:FindFirstChild("!!!FISHING_VIEW_MODEL!!!")
        return fishingViewModel
    end

    local function fn17()
        if tbl4.clone then
            pcall(function()
                tbl4.clone:Destroy()
            end)

            tbl4.clone = nil
        end

        for i, v9 in ipairs(tbl4.hidden) do
            pcall(function()
                v9.part.Transparency = v9.value
            end)
        end

        table.clear(tbl4.hidden)
        tbl4.viewModel = nil
    end

    local function fn18()
        fn17()
        if not tbl4.enabled or not tbl4.choice then
            return false
        end
        local v9 = fn15(tbl4.choice)
        local v10 = fn16()
        local handle = v10 and v10:FindFirstChild("Handle")
        if not v9 or not handle then
            return false
        end
        local clone = v9:Clone()
        local handle2 = clone:FindFirstChild("Handle")
        local basePart = handle2 or clone:FindFirstChildWhichIsA("BasePart")
        if not basePart then
            clone:Destroy()
            return false
        end
        clone.Name = "!!!LYNX_ROD_MODEL!!!"

        for i, descendant in ipairs(v10:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                tbl4.hidden[#tbl4.hidden + 1] = {part = descendant, value = descendant.Transparency}
                descendant.Transparency = 1
            end
        end

        for i, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.Massless = true
                descendant.Anchored = false
            end
        end

        clone.Parent = localPlayer.Character
        basePart.CFrame = handle.CFrame

        local function fn19(part0, part1)
            local weldConstraint = Instance.new("WeldConstraint")
            weldConstraint.Part0 = part0
            weldConstraint.Part1 = part1
            weldConstraint.Parent = part0
        end

        for i, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant ~= basePart then
                fn19(basePart, descendant)
            end
        end

        fn19(handle, basePart)
        tbl4.clone = clone
        tbl4.viewModel = v10
        return true
    end

    local function fn19()
        if not tbl4.clone or not tbl4.clone.Parent then
            return false
        end
        local v9 = fn16()
        if v9 ~= tbl4.viewModel then
            return false
        end

        for i, descendant in ipairs(v9:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                return false
            end
        end

        return true
    end

    local function fn20()
        table.clear(tbl4.hidden)
        tbl4.clone = nil
        fn18()
    end

    local v9 = v8:AddDropdown({
        Title = "Pilih Model Rod",
        Options = {},
        NoSave = false,
        Callback = function(modelRod)
            tbl4.choice = modelRod

            if tbl4.enabled then
                local v9 = fn18()
                local str2 = v9 and "Model rod: " .. modelRod or "Gagal pasang model rod!"
                fn6("Rod Model Skin", str2, 2)
            end
        end,
    })

    v8:AddButton({
        Title = "Refresh Model List",
        Callback = function()
            task.spawn(function()
                local v10 = fn14()
                fn7(v9, v10)
                fn6("Rod Model Skin", string.format("%d model rod tersedia di client.", #v10))
            end)
        end,
    })

    v8:AddToggle({
        Title = "Enable Rod Model Skin",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if not arg then
                tbl4.enabled = false

                if tbl4.thread then
                    pcall(task.cancel, tbl4.thread)
                    tbl4.thread = nil
                end

                if tbl4.conn then
                    tbl4.conn:Disconnect()
                    tbl4.conn = nil
                end

                fn17()
                fn6("Rod Model Skin", "Model rod dikembalikan ke aslinya.", 2)
                return
            end

            if tbl4.enabled then
                return
            end

            if not flag5 then
                fn7(v9, fn14())
            end

            if not tbl4.choice then
                fn6("Rod Model Skin", "Pilih model rod dulu dari dropdown!", 2)
                return
            end
            tbl4.enabled = true
            local v10 = fn18()
            local str2 = v10 and "Model rod: " .. tbl4.choice or "Gagal pasang -- rod sedang tidak terpegang?"
            fn6("Rod Model Skin", str2)

            tbl4.conn = localPlayer.CharacterAdded:Connect(function()
                if not tbl4.enabled then
                    return
                end
                task.wait(4)
                fn20()
            end)

            tbl4.thread = task.spawn(function()
                while tbl4.enabled do
                    task.wait(1)

                    if tbl4.enabled and fn16() and not fn19() then
                        fn20()
                    end
                end
            end)

            local v11 = fn13()

            if v11 and not tbl4.colConn then
                tbl4.colConn = v11.ChildAdded:Connect(function(child)
                    task.wait(0.5)

                    if fn12(child) then
                        tbl5[child.Name] = child
                        fn7(v9, fn8(tbl5))
                    end
                end)
            end
        end,
    })

    local v10 = v5:AddSection("Avatar Changer")
    local tbl6 = {enabled = false, id = nil, label = "", conn = nil}
    local v11 = nil

    local tbl7 = {
        {Id = 7077243300, Label = "TV_TIKMAN"},
        {Id = 6010134024, Label = "Ninjaso02YT"},
        {Id = 1105009763, Label = "s1mple"},
        {Id = 3232392707, Label = "G0DG0MER"},
        {Id = 8673396266, Label = "spiderman"},
        {Id = 9939245108, Label = "ApiqqStoreeX8"},
        {Id = 8849874931, Label = "SnoopDogs"},
        {Id = 495215054, Label = "SnoopDog"},
        {Id = 3658593465, Label = "CFIDxMuell"},
        {Id = 8723543936, Label = "Izyy"},
        {Id = 9068204572, Label = "Cero"},
        {Id = 1922874709, Label = "StanniBunny"},
        {Id = 3853262070, Label = "S4INTRL"},
        {Id = 1718757907, Label = "1_PFT"},
        {Id = 8343523, Label = "Neko_Overlord"},
        {Id = 925872199, Label = "gamer"},
        {Id = 9758684471, Label = "Azure"},
        {Id = 776077949, Label = "DuckXander"},
        {Id = 293229095, Label = "SinisterUGC"},
        {Id = 3622565596, Label = "Bluff_006"},
        {Id = 77696047, Label = "caIIdrops"},
        {Id = 32958887, Label = "Juno"},
        {Id = 63578527, Label = "MistyPhantom"},
        {Id = 293215507, Label = "LoneWalker_L"},
        {Id = 178596165, Label = "LilDisquit"},
        {Id = 7712365803, Label = "TATA"},
        {Id = 9331384193, Label = "Ficha_NR"},
        {Id = 8898545773, Label = "Gracee"},
        {Id = 8997690084, Label = "3quinox"},
        {Id = 9273180503, Label = "Your_Miffy"},
        {Id = 425367613, Label = "QueenChroma"},
        {Id = 147302717, Label = "Hoshiko"},
        {Id = 8476353635, Label = "kify168"},
        {Id = 40397833, Label = "WILDES"},
        {Id = 75974130, Label = "TALON"},
        {Id = 510075070, Label = "Solace A.K.A Soleh"},
        {Id = 7909420830, Label = "ZAER"},
        {Id = 111233359, Label = "EA_GAMES"},
        {Id = 56602747, Label = "Stealthy"},
        {Id = 47058434, Label = "RZXTL"},
    }

    local tbl8 = {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "RightUpperArm",
        "LeftLowerArm",
        "RightLowerArm",
        "LeftHand",
        "RightHand",
        "LeftUpperLeg",
        "RightUpperLeg",
        "LeftLowerLeg",
        "RightLowerLeg",
        "LeftFoot",
        "RightFoot",
    }

    local tbl9 = {
        Accessory = true,
        Hat = true,
        Shirt = true,
        Pants = true,
        ShirtGraphic = true,
        CharacterMesh = true,
    }

    local function fn21(arg)
        for i, v12 in ipairs(tbl7) do
            if v12.Label == arg then
                return v12.Id
            end
        end
    end

    local function fn22(arg, arg2)
        local handle = arg:FindFirstChild("Handle")
        if not handle then
            return
        end
        local accessoryWeld = handle:FindFirstChild("AccessoryWeld")

        if accessoryWeld then
            accessoryWeld:Destroy()
        end

        local name = nil

        for i, child in ipairs(handle:GetChildren()) do
            if child:IsA("Attachment") then
                name = child.Name
                break
            end
            continue
        end

        local parent = nil
        local v12 = nil

        for i, descendant in ipairs(arg2:GetDescendants()) do
            if descendant:IsA("Attachment") and descendant.Name == name and descendant.Parent ~= handle then
                parent = descendant.Parent
                v12 = descendant
                break
            end
        end

        local weld = Instance.new("Weld")
        weld.Name = "AccessoryWeld"
        weld.Part1 = handle

        if parent and parent:IsA("BasePart") then
            weld.Part0 = parent
            weld.C0 = v12.CFrame
            local v13 = handle:FindFirstChild(name)
            local cFrame = v13 and v13.CFrame or CFrame.new()
            weld.C1 = cFrame
        else
            local head = arg2:FindFirstChild("Head")
            local humanoidRootPart = head or arg2:FindFirstChild("HumanoidRootPart")
            weld.Part0 = humanoidRootPart
            if not weld.Part0 then
                return
            end
        end

        weld.Parent = handle
    end

    local function fn23(arg, parent, arg2)
        for i, child in ipairs(parent:GetChildren()) do
            if tbl9[child.ClassName] then
                child:Destroy()
            end
        end

        for i, child in ipairs(arg:GetChildren()) do
            local className = child.ClassName

            if className ~= "Accessory" and className ~= "Hat" then
                if tbl9[className] then
                    pcall(function()
                        child:Clone().Parent = parent
                    end)
                end
            else
                pcall(function()
                    local clone = child:Clone()
                    clone.Parent = parent
                    fn22(clone, parent)
                end)
            end
        end

        local function fn24(arg3, arg4, arg5)
            if arg5 and arg5 ~= 0 and not parent:FindFirstChildOfClass(arg3) then
                pcall(function()
                    local instance = Instance.new(arg3)
                    instance[arg4] = "rbxassetid://" .. tostring(arg5)
                    instance.Parent = parent
                end)
            end
        end

        if arg2 then
            fn24("Shirt", "ShirtTemplate", arg2.Shirt)
            fn24("Pants", "PantsTemplate", arg2.Pants)
            fn24("ShirtGraphic", "Graphic", arg2.GraphicTShirt)
        end

        local bodyColors = arg:FindFirstChildOfClass("BodyColors")
        local bodyColors2 = parent:FindFirstChildOfClass("BodyColors")

        if bodyColors and bodyColors2 then
            local torsoColor3 = bodyColors.TorsoColor3
            bodyColors2.HeadColor3 = bodyColors.HeadColor3
            bodyColors2.TorsoColor3 = torsoColor3
            local rightArmColor3 = bodyColors.RightArmColor3
            bodyColors2.LeftArmColor3 = bodyColors.LeftArmColor3
            bodyColors2.RightArmColor3 = rightArmColor3
            local rightLegColor3 = bodyColors.RightLegColor3
            bodyColors2.LeftLegColor3 = bodyColors.LeftLegColor3
            bodyColors2.RightLegColor3 = rightLegColor3
        end

        local head = arg:FindFirstChild("Head")
        local head2 = parent:FindFirstChild("Head")

        if head and head2 then
            local specialMesh = head:FindFirstChildOfClass("SpecialMesh")

            if specialMesh then
                local specialMesh2 = head2:FindFirstChildOfClass("SpecialMesh")

                if not specialMesh2 then
                    specialMesh2 = Instance.new("SpecialMesh")
                    specialMesh2.Name = "Mesh"
                    specialMesh2.Parent = head2
                end

                pcall(function()
                    local scale = specialMesh.Scale
                    local offset = specialMesh.Offset
                    specialMesh2.MeshType = specialMesh.MeshType
                    specialMesh2.Scale = scale
                    specialMesh2.Offset = offset
                    local meshId = specialMesh.MeshId
                    local meshId2 = meshId or ""
                    local textureId = specialMesh.TextureId
                    local textureId2 = textureId or ""
                    specialMesh2.MeshId = meshId2
                    specialMesh2.TextureId = textureId2
                end)
            end

            if arg2 and arg2.Face and arg2.Face ~= 0 then
                local face = head2:FindFirstChild("face") or head2:FindFirstChildOfClass("Decal")

                if not face then
                    face = Instance.new("Decal")
                    local front = Enum.NormalId.Front
                    face.Name = "face"
                    face.Face = front
                    face.Parent = head2
                end

                pcall(function()
                    local texture = "rbxassetid://" .. tostring(arg2.Face)
                    face.Texture = texture
                end)
            end

            pcall(function()
                head2.Color = head.Color
            end)
        end

        for i, v12 in ipairs(tbl8) do
            local v13 = arg:FindFirstChild(v12)
            local v14 = parent:FindFirstChild(v12)

            if v13 and v14 then
                pcall(function()
                    v14.Color = v13.Color
                end)

                local surfaceAppearance = v13:FindFirstChildOfClass("SurfaceAppearance")
                local surfaceAppearance2 = v14:FindFirstChildOfClass("SurfaceAppearance")

                if surfaceAppearance then
                    if not surfaceAppearance2 then
                        surfaceAppearance2 = Instance.new("SurfaceAppearance")
                        surfaceAppearance2.Parent = v14
                    end

                    pcall(function()
                        local normalMap = surfaceAppearance.NormalMap
                        surfaceAppearance2.ColorMap = surfaceAppearance.ColorMap
                        surfaceAppearance2.NormalMap = normalMap
                        local metalnessMap = surfaceAppearance.MetalnessMap
                        surfaceAppearance2.RoughnessMap = surfaceAppearance.RoughnessMap
                        surfaceAppearance2.MetalnessMap = metalnessMap
                    end)
                elseif surfaceAppearance2 then
                    surfaceAppearance2:Destroy()
                end
            end
        end
    end

    local function fn24(arg, arg2)
        local ok, result = pcall(function()
            return Players:CreateHumanoidModelFromDescription(arg, Enum.HumanoidRigType.R6)
        end)

        if not ok or not result then
            return false
        end

        local ok2 = pcall(function()
            fn23(result, arg2, arg)
            local humanoid = arg2:FindFirstChildOfClass("Humanoid")

            if humanoid then
                pcall(function()
                    humanoid.BodyDepthScale.Value = arg.DepthScale
                    humanoid.BodyHeightScale.Value = arg.HeightScale
                    humanoid.BodyWidthScale.Value = arg.WidthScale
                    humanoid.HeadScale.Value = arg.HeadScale
                end)
            end
        end)

        pcall(function()
            result:Destroy()
        end)

        return ok2
    end

    local function fn25(arg)
        local ok, result = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(arg)
        end)

        local v12 = ok and result or nil
        return v12
    end

    local function fn26(arg, arg2)
        local character = arg2 or localPlayer.Character
        local v12 = character
        if not character then
            return false
        end
        local v13 = fn25(arg)
        local flag6 = v13 and fn24(v13, v12) or false
        return flag6
    end

    local function fn27()
        local character = localPlayer.Character
        if not character then
            return
        end
        local v12 = v11
        local v13 = v12 or fn25(localPlayer.UserId)

        if v13 then
            fn24(v13, character)
        end
    end

    local function fn28(arg, arg2)
        local str2 = arg and arg2 or "Gagal apply avatar!"
        local n = arg and 3 or 2
        fn6("Avatar Changer", str2, n)
    end

    v10:AddDropdown({
        Title = "Select Avatar",
        Options = (function()
            local tbl10 = {}

            for i, v12 in ipairs(tbl7) do
                tbl10[#tbl10 + 1] = v12.Label
            end

            return tbl10
        end)(),
        NoSave = true,
        Callback = function(avatar)
            tbl6.id = fn21(avatar)
            tbl6.label = avatar
            if not tbl6.enabled or not tbl6.id then
                return
            end

            task.spawn(function()
                fn28(fn26(tbl6.id), "Avatar: " .. avatar)
            end)
        end,
    })

    v10:AddToggle({
        Title = "Enable Avatar Changer",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl6.enabled = enabled

            if tbl6.conn then
                tbl6.conn:Disconnect()
                tbl6.conn = nil
            end

            if not enabled then
                task.spawn(function()
                    fn27()
                    fn6("Avatar Changer", "Avatar dikembalikan ke asli.", 2)
                end)

                return
            end

            if not tbl6.id then
                fn6("Avatar Changer", "Pilih avatar dari dropdown dulu!", 2)
                return
            end

            task.spawn(function()
                local v12 = v11
                local v13 = v12 or fn25(localPlayer.UserId)
                v11 = v13
                fn28(fn26(tbl6.id), "Avatar aktif: " .. tbl6.label)
            end)

            tbl6.conn = localPlayer.CharacterAdded:Connect(function(character)
                if not tbl6.enabled or not tbl6.id then
                    return
                end
                task.wait(2)
                fn26(tbl6.id, character)
            end)
        end,
    })

    v10:AddButton({
        Title = "Apply Now",
        Callback = function()
            if not tbl6.id then
                fn6("Avatar Changer", "Pilih avatar dari dropdown dulu!", 2)
                return
            end

            task.spawn(function()
                fn28(fn26(tbl6.id), "Applied: " .. tbl6.label)
            end)
        end,
    })

    v10:AddButton({
        Title = "Reset to Original",
        Callback = function()
            tbl6.enabled = false

            if tbl6.conn then
                tbl6.conn:Disconnect()
                tbl6.conn = nil
            end

            task.spawn(function()
                fn27()
                fn6("Avatar Changer", "Avatar dikembalikan ke asli.", 2)
            end)
        end,
    })

    local v12 = v5:AddSection("Aura Skin")
    local tbl10 = {current = nil, enabled = false, conn = nil}

    local function fn29()
        local assets = ReplicatedStorage:FindFirstChild("Assets")
        local auras = assets and assets:FindFirstChild("Auras") or nil
        return auras
    end

    local function fn30()
        local v13 = fn29()
        if not v13 then
            return {}
        end
        local tbl11 = {}

        for i, child in ipairs(v13:GetChildren()) do
            tbl11[#tbl11 + 1] = child.Name
        end

        table.sort(tbl11)
        return tbl11
    end

    local function fn31()
        local character = localPlayer.Character
        if not character then
            return
        end
        local v13, v14, v15 = ipairs(character:GetChildren())
        local v16 = v15
        local v17 = v13
        local v18 = v14

        while true do
            local v19, v20 = v17(v18, v16)
            if v19 == nil then
                break
            end

            for i, child in ipairs(v20:GetChildren()) do
                if child:GetAttribute("IsAura") then
                    child:Destroy()
                end
            end

            v16 = v19
        end
    end

    local function fn32(arg)
        local character = localPlayer.Character
        local v13 = fn29()
        local v14 = arg and v13 and v13:FindFirstChild(arg)
        if not character or not v14 then
            return
        end
        fn31()
        local v15, v16, v17 = ipairs(v14:GetChildren())
        local v18 = v17
        local v19 = v15
        local v20 = v16

        while true do
            local v21, v22 = v19(v20, v18)
            if v21 == nil then
                break
            end
            v18 = v21
            local v23 = character:FindFirstChild(v22.Name)

            if v23 then
                for i, child in ipairs(v22:GetChildren()) do
                    local clone = child:Clone()
                    clone:SetAttribute("IsAura", true)
                    clone.Parent = v23
                end

                v18 = v21
            end
        end
    end

    local v13 = v12:AddDropdown({
        Title = "Pilih Aura",
        Options = {},
        NoSave = false,
        Callback = function(current)
            tbl10.current = current

            if tbl10.enabled then
                fn32(current)
            end
        end,
    })

    v12:AddButton({
        Title = "Refresh Aura List",
        Callback = function()
            local v14 = fn30()
            fn7(v13, v14)
            local str2 = #v14 > 0 and "Loaded " .. #v14 .. " auras." or "Aura folder tidak ditemukan!"
            fn6("Aura", str2, 2)
        end,
    })

    v12:AddToggle({
        Title = "Enable Aura",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl10.enabled = enabled

            if enabled then
                fn32(tbl10.current)
            else
                fn31()
            end
        end,
    })

    v12:AddToggle({
        Title = "Auto Re-apply saat Respawn",
        Default = false,
        NoSave = true,
        Callback = function(arg)
            if arg then
                if tbl10.conn then
                    return
                end

                tbl10.conn = localPlayer.CharacterAdded:Connect(function()
                    task.wait(1)

                    if tbl10.enabled and tbl10.current then
                        fn32(tbl10.current)
                    end
                end)
            elseif tbl10.conn then
                tbl10.conn:Disconnect()
                tbl10.conn = nil
            end
        end,
    })

    v12:AddButton({
        Title = "Remove Aura",
        Callback = function()
            tbl10.enabled = false
            fn31()
            fn6("Aura", "Aura berhasil dihapus.", 2)
        end,
    })

    local v14 = v5:AddSection("Rod Bait Visual Override", false)
    local tbl11 = {enabled = false, choice = "Default", conn = nil, keys = {}}

    local function fn33()
        local ok, result, result2, result3 = pcall(function()
            return fn(ReplicatedStorage.Controllers.VFXController), fn(ReplicatedStorage.Shared.ItemUtility), fn(ReplicatedStorage.Shared.VFXDownloader)
        end)

        if not ok then
            return
        end
        return result, result2, result3
    end

    local function fn34()
        local v15, v16 = fn33()
        if not v16 then
            return {}
        end

        local ok, result = pcall(function()
            return v16:GetFishingRods()
        end)

        if not ok or not result then
            return {}
        end
        local tbl12 = {}

        for i, v17 in ipairs(result) do
            local data = v17 and v17.Data

            if data and data.Name then
                tbl12[#tbl12 + 1] = data.Name
            end
        end

        table.sort(tbl12)
        return tbl12
    end

    local function fn35(arg)
        local v15 = tbl11.keys[arg]
        local str2 = v15 or arg .. " Dive"
        return str2
    end

    local v15 = v14:AddDropdown({
        Title = "Bait Dive VFX (by Rod Skin)",
        Options = {"Default"},
        Default = "Default",
        NoSave = false,
        Callback = function(choice)
            tbl11.choice = choice
        end,
    })

    v14:AddButton({
        Title = "Muat Daftar Rod",
        Callback = function()
            task.spawn(function()
                local v16 = fn34()
                table.insert(v16, 1, "Default")
                fn7(v15, v16)
                fn6("Rod VFX", string.format("%d rod dimuat. VFX diunduh saat dipakai.", #v16 - 1))
            end)
        end,
    })

    v14:AddButton({
        Title = "Scan VFX (lama, ~30 detik)",
        Callback = function()
            task.spawn(function()
                local v16, v17
                v17, v17, v16 = fn33()
                if not v16 then
                    return
                end
                fn6("Rod VFX", "Memindai... ini butuh sekitar 30 detik.", 4)
                local tbl12 = {"Default"}
                tbl11.keys = {}

                for i, v18 in ipairs(fn34()) do
                    local str2 = v18 .. " Dive"

                    if pcall(function()
                        v16:Ensure(str2)
                    end) then
                        task.wait(0.05)

                        if v16:Find(str2) then
                            tbl11.keys[v18] = str2
                            tbl12[#tbl12 + 1] = v18
                        end
                    end
                end

                fn7(v15, tbl12)
                fn6("Rod VFX", string.format("Ditemukan %d rod skin VFX.", #tbl12 - 1))
            end)
        end,
    })

    v14:AddToggle({
        Title = "Override Bait Dive VFX",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl11.enabled = enabled

            if tbl11.conn then
                tbl11.conn:Disconnect()
                tbl11.conn = nil
            end

            if not enabled then
                fn6("Rod VFX", "Override dimatikan.", 2)
                return
            end
            local v16, v17, v18 = fn33()
            local reBaitCastVisual = obj.RE_BaitCastVisual

            if v16 and v18 and reBaitCastVisual then
                tbl11.conn = reBaitCastVisual.OnClientEvent:Connect(function(arg, arg2)
                    if not tbl11.enabled or arg ~= localPlayer then
                        return
                    end

                    if tbl11.choice == "Default" or type(arg2) ~= "table" then
                        return
                    end
                    local castPosition = arg2.CastPosition
                    if not castPosition then
                        return
                    end

                    task.spawn(function()
                        local v19 = fn35(tbl11.choice)

                        if not v18:Find(v19) then
                            if not pcall(function()
                                v18:Ensure(v19)
                            end) then
                                return
                            end

                            if not v18:Find(v19) then
                                return
                            end
                        end

                        pcall(function()
                            v16.PlayVFX:Fire(v19, CFrame.new(castPosition + Vector3.new(0, 0.5, 0)))
                        end)
                    end)
                end)

                fn6("Rod VFX", "Override aktif!")
                return
            end

            tbl11.enabled = false
            fn6("Rod VFX", "Gagal akses VFXController / remote.")
        end,
    })

    local v16 = v5:AddSection("Skin Animation")

    local tbl12 = {
        enabled = false,
        current = "",
        conns = {},
        pools = {},
        poolIdx = {},
        killed = setmetatable({}, {__mode = "k"}),
        active = {},
        replacing = {},
        charConn = nil,
        listPushed = false,
    }

    local v17 = nil
    local humanoid = nil
    local v18 = nil

    local tbl13 = {
        FishCaught = {},
        EquipIdle = {},
        RodThrow = {},
        ReelStart = {},
        ReelingIdle = {},
        ReelIntermission = {},
    }

    local tbl14 = {EquipIdle = true, ReelingIdle = true}

    local tbl15 = {
        FishCaught = Enum.AnimationPriority.Action4,
        EquipIdle = Enum.AnimationPriority.Action3,
        RodThrow = Enum.AnimationPriority.Action4,
        ReelStart = Enum.AnimationPriority.Action4,
        ReelingIdle = Enum.AnimationPriority.Action3,
        ReelIntermission = Enum.AnimationPriority.Action4,
    }

    local tbl16 = {
        "ReelingIdle",
        "ReelIntermission",
        "ReelStart",
        "RodThrow",
        "FishCaught",
        "EquipIdle",
    }

    local tbl17 = {
        ReelingIdle = {"reelingidle", "reeling idle"},
        ReelIntermission = {"reelintermission", "reel intermission"},
        ReelStart = {"reelstart", "reel start"},
        RodThrow = {"rodthrow", "rod throw"},
        FishCaught = {"fishcaught", "fish caught"},
        EquipIdle = {"equipidle", "equip idle"},
    }

    local tbl18 = {}
    local flag6 = false

    local function fn36()
        if flag6 then
            return
        end
        flag6 = true

        local ok, result = pcall(function()
            return fn(ReplicatedStorage.Modules.Animations)
        end)

        if not ok or type(result) ~= "table" then
            return
        end
        local tbl19 = {}
        local v19, v20, v21 = pairs(result)
        local v22 = v21
        local v23 = v19
        local v24 = v20

        while true do
            local v25, v26 = v23(v24, v22)
            if v25 == nil then
                break
            end
            v22 = v25

            if type(v25) == "string" and type(v26) == "table" and not v26.Disabled then
                local str2 = v25:lower()
                local v27 = nil
                local v28, v29, v30 = ipairs(tbl16)
                local v31 = v30
                local v32 = v28
                local v33 = v29
                local v34 = v25
                local v35 = v23
                local v36 = v24
                local v37, v38

                repeat
                    v37, v38 = v32(v33, v31)
                    if v37 == nil then
                        break
                    end

                    for i, v39 in ipairs(tbl17[v38]) do
                        if str2:find(v39, 1, true) then
                            v27 = v38
                            break
                        end
                        continue
                    end

                    v31 = v37
                until v27

                v22 = v34
                v23 = v35
                v24 = v36
                local match = v27 and v25:match("^(.-)%s*%-")

                if match then
                    match = match:match("^%s*(.-)%s*$")
                end

                local animation = v26.Animation
                local animationId = animation and v26.Animation.AnimationId or v26.AnimationId

                if v27 and match and match ~= "" and animationId and animationId ~= "" then
                    tbl13[v27][match] = animationId

                    if not tbl19[match] then
                        tbl19[match] = true
                        tbl18[#tbl18 + 1] = match
                    end
                end
            end
        end

        table.sort(tbl18)
    end

    local function fn37()
        local character = localPlayer.Character
        local result = character or localPlayer.CharacterAdded:Wait()
        v17 = result
        humanoid = v17:WaitForChild("Humanoid")
        local animator = humanoid:FindFirstChildOfClass("Animator")
        local animator2 = animator or Instance.new("Animator", humanoid)
        v18 = animator2
    end

    local function fn38(arg)
        local flag7 = arg

        if arg then
            local name = arg.Name
            local str2 = name or ""
            local v19 = str2
            flag7 = str2.lower(v19):find("_pool_") ~= nil
        end

        return flag7
    end

    local function fn39(arg)
        if not arg or fn38(arg) then
            return nil
        end
        local tbl19 = {}
        local name = arg.Name
        local str2 = name or ""
        local v19 = str2
        __store_list(tbl19, 1, str2.lower(v19))

        if arg.Animation then
            local n = #tbl19 + 1
            local name2 = arg.Animation.Name
            local str3 = name2 or ""
            local v20 = str3
            tbl19[n] = str3.lower(v20)
        end

        local v20, v21, v22 = ipairs(tbl19)
        local v23 = v22
        local v24 = v20
        local v25 = v21

        while true do
            local v26, v27 = v24(v25, v23)
            if v26 == nil then
                break
            end
            local v28, v29, v30 = ipairs(tbl16)
            local v31 = v30
            local v32 = v28
            local v33 = v29
            local v34 = v26
            local v35 = v24
            local v36 = v25

            while true do
                local v37, v38 = v32(v33, v31)
                if v37 == nil then
                    break
                end

                for i, v39 in ipairs(tbl17[v38]) do
                    if v27:find(v39, 1, true) then
                        return v38
                    end
                end

                v31 = v37
            end

            v23 = v34
            v24 = v35
            v25 = v36
        end
    end

    local function fn40(arg, arg2)
        local v19 = tbl13[arg]
        local v20 = v19 and tbl13[arg][arg2]
        if not v20 then
            return false
        end
        local v21 = ipairs
        local v22 = tbl12.pools[arg]
        local tbl19 = v22 or {}

        for k, v23 in v21(tbl19) do
            pcall(function()
                v23:Stop(0)
                v23:Destroy()
            end)
        end

        local poolIdx = tbl12.poolIdx
        tbl12.pools[arg] = {}
        poolIdx[arg] = 1
        local replacing = tbl12.replacing
        tbl12.active[arg] = nil
        replacing[arg] = false
        local v23 = tbl14[arg]
        local looped = v23 or false
        local animation = Instance.new("Animation")
        local name = "CUSTOM_" .. arg:upper()
        animation.AnimationId = v20
        animation.Name = name
        local n = looped and 1 or 3

        for i = 1, n do
            local ok, result = pcall(function()
                return v18:LoadAnimation(animation)
            end)

            if ok and result then
                local v24 = tbl15[arg]
                local action4 = v24 or Enum.AnimationPriority.Action4
                result.Priority = action4
                result.Looped = looped
                result.Name = arg .. "_POOL_" .. i
                table.insert(tbl12.pools[arg], result)
            end
        end

        animation:Destroy()
        local flag7 = #tbl12.pools[arg] > 0
        return flag7
    end

    local function fn41(arg)
        local flag7 = false

        for k in pairs(tbl13) do
            if fn40(k, arg) then
                flag7 = true
            end
        end

        return flag7
    end

    local function fn42(arg)
        for k, v19 in pairs(tbl12.active) do
            if k ~= arg and v19 and v19.IsPlaying then
                pcall(function()
                    v19:Stop(0.1)
                end)

                tbl12.active[k] = nil
            end
        end
    end

    local function fn43(arg, arg2)
        local function fn44(arg3)
            tbl12.killed[arg3] = tick()

            pcall(function()
                arg3:Stop(0)
                arg3:AdjustSpeed(0)
            end)
        end

        local v19 = tbl12.active[arg2]

        if not tbl12.replacing[arg2] and (not v19 or not v19.IsPlaying) then
            local v20 = tbl12.pools[arg2]
            if not v20 or #v20 == 0 then
                return
            end
            tbl12.replacing[arg2] = true
            fn44(arg)

            pcall(function()
                arg.TimePosition = 0
            end)

            if arg2 == "FishCaught" then
                fn42("FishCaught")

                for i, v21 in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    if not fn38(v21) and not tbl12.killed[v21] then
                        fn44(v21)
                    end
                end
            elseif not tbl14[arg2] then
                for k, v21 in pairs(tbl12.active) do
                    if k ~= arg2 and k ~= "FishCaught" and not tbl14[k] and v21 and v21.IsPlaying then
                        pcall(function()
                            v21:Stop(0.1)
                        end)

                        tbl12.active[k] = nil
                    end
                end
            end

            local v21 = nil

            for i, v22 in ipairs(v20) do
                if not v22.IsPlaying then
                    v21 = v22
                    break
                end
            end

            if not v21 then
                local v22 = tbl12.poolIdx[arg2]
                local n = v22 or 1
                local n2 = n % #v20 + 1
                tbl12.poolIdx[arg2] = n2
                v21 = v20[n2]

                pcall(function()
                    v21:Stop(0)
                end)
            end

            pcall(function()
                local v22 = tbl14[arg2]
                local looped = v22 or false
                v21.Looped = looped
                v21:Play(0, 1, 1)
                v21:AdjustSpeed(1)
            end)

            tbl12.active[arg2] = v21
            local connection = nil

            connection = v21.Stopped:Connect(function()
                if tbl12.active[arg2] == v21 then
                    tbl12.active[arg2] = nil
                end

                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end)

            tbl12.replacing[arg2] = false

            task.delay(2, function()
                tbl12.killed[arg] = nil
            end)

            return
        end

        fn44(arg)
    end

    local function fn44()
        for k, conn in pairs(tbl12.conns) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end

        tbl12.conns = {}
    end

    local function fn45()
        fn44()

        tbl12.conns.played = humanoid.AnimationPlayed:Connect(function(arg)
            if not tbl12.enabled or fn38(arg) then
                return
            end
            local v19 = fn39(arg)

            if v19 and tbl12.pools[v19] and #tbl12.pools[v19] > 0 then
                task.spawn(fn43, arg, v19)
            end
        end)

        local n = 0

        tbl12.conns.heartbeat = RunService.Heartbeat:Connect((function(Z, V, z, U)
            return function()
                if not Z.enabled then
                    return
                end
                n = n + 1
                if n < 45 then
                    return
                end
                n = 0

                for L, L in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    if not V(L) and L.IsPlaying then
                        if Z.killed[L] then
                            pcall(function()
                                L:Stop(0)
                                L:AdjustSpeed(0)
                            end)
                        else
                            local t = z(L)

                            if t and Z.pools[t] and #Z.pools[t] > 0 then
                                local V = Z.active[t]

                                if not V or not V.IsPlaying then
                                    task.spawn(U, L, t)
                                else
                                    Z.killed[L] = tick()

                                    pcall(function()
                                        L:Stop(0)
                                        L:AdjustSpeed(0)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end)(tbl12, fn38, fn39, fn43))
    end

    local function fn46()
        tbl12.killed = setmetatable({}, {__mode = "k"})
        tbl12.active = {}
        tbl12.replacing = {}
    end

    local v19 = v16:AddDropdown({
        Title = "Select Skin",
        Options = {},
        NoSave = false,
        Callback = function(current)
            fn36()
            tbl12.current = current

            if tbl12.enabled then
                fn46()
                fn41(current)
            end
        end,
    })

    v16:AddButton({
        Title = "Refresh Skin List",
        Callback = function()
            flag6 = false
            tbl18 = {}

            for k, v20 in pairs(tbl13) do
                table.clear(v20)
            end

            fn36()
            fn7(v19, tbl18)
            local str2 = #tbl18 > 0 and "Loaded " .. #tbl18 .. " skins." or "Skin database kosong!"
            fn6("Skin Anim", str2, 2)
        end,
    })

    v16:AddToggle({
        Title = "Enable Skin Animation",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl12.enabled = enabled

            if not enabled then
                fn44()
                local v20, v21, v22 = pairs(tbl12.pools)
                local v23 = v22
                local v24 = v20
                local v25 = v21

                while true do
                    local v26, v27 = v24(v25, v23)
                    if v26 == nil then
                        break
                    end

                    for i, v28 in ipairs(v27) do
                        pcall(function()
                            v28:Stop(0)
                        end)
                    end

                    v23 = v26
                end

                fn46()

                if tbl12.charConn then
                    tbl12.charConn:Disconnect()
                    tbl12.charConn = nil
                end

                fn6("Skin Anim", "Skin Animation dihentikan.", 2)
                return
            end

            fn36()

            if not tbl12.listPushed then
                tbl12.listPushed = true
                fn7(v19, tbl18)
            end

            if tbl12.current == "" then
                tbl12.enabled = false
                fn6("Skin Anim", "Pilih skin dulu!")
                return
            end

            if not v17 or not v17.Parent then
                fn37()
            end

            if not fn41(tbl12.current) then
                tbl12.enabled = false
                fn6("Skin Anim", "Skin tidak ditemukan di database!")
                return
            end

            fn46()
            fn45()

            if not tbl12.charConn then
                tbl12.charConn = localPlayer.CharacterAdded:Connect(function(character)
                    task.wait(1.5)
                    v17 = character
                    humanoid = v17:WaitForChild("Humanoid")
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    local animator2 = animator or Instance.new("Animator", humanoid)
                    v18 = animator2
                    fn46()

                    if tbl12.enabled and tbl12.current ~= "" then
                        task.wait(0.5)
                        fn41(tbl12.current)
                        fn45()
                    end
                end)
            end

            fn6("Skin Anim", "Skin Animation aktif!", 2)
        end,
    })

    local Emote = v5:AddSection("Emote", false)

    local tbl19 = {
        selected = "",
        enabled = false,
        conn = nil,
        loop = nil,
        track = nil,
        loaded = {},
        data = {},
        list = {},
    }

    local flag7 = false

    local function fn47()
        if flag7 then
            return
        end
        flag7 = true
        local emotes = ReplicatedStorage:FindFirstChild("Emotes")
        if not emotes then
            return
        end

        for i, child in ipairs(emotes:GetChildren()) do
            local ok, result = pcall(function()
                return fn(child)
            end)

            if ok and type(result) == "table" and result.Data and result.Data.Name and result.AnimationId then
                local name = result.Data.Name
                tbl19.list[#tbl19.list + 1] = name
                local data = tbl19.data
                local tbl20 = {AnimationId = result.AnimationId}
                local animationPriority = result.AnimationPriority
                local action3 = animationPriority or Enum.AnimationPriority.Action3
                tbl20.Priority = action3
                local looped = result.Looped
                local looped2 = looped or false
                tbl20.Looped = looped2
                local playbackSpeed = result.PlaybackSpeed
                local speed = playbackSpeed or 1
                tbl20.Speed = speed
                data[name] = tbl20
            end
        end

        table.sort(tbl19.list)

        if tbl19.selected == "" then
            local v20 = tbl19.list[1]
            local selected = v20 or ""
            tbl19.selected = selected
        end
    end

    local function fn48()
        local character = localPlayer.Character
        local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid2 then
            return nil
        end
        local animator = humanoid2:FindFirstChildOfClass("Animator")
        local animator2 = animator or Instance.new("Animator", humanoid2)
        return animator2
    end

    local function fn49()
        if tbl19.track and tbl19.track.IsPlaying then
            pcall(function()
                tbl19.track:Stop(0.2)
            end)
        end

        tbl19.track = nil
    end

    local function fn50(arg)
        local enabled = tbl19.enabled
        local v20 = enabled and tbl19.data[arg]
        local v21 = v20 and fn48()
        if not v21 then
            return
        end
        fn49()

        if not tbl19.loaded[arg] then
            local animation = Instance.new("Animation")
            animation.AnimationId = v20.AnimationId

            local ok, result = pcall(function()
                return v21:LoadAnimation(animation)
            end)

            animation:Destroy()
            if not ok or not result then
                return
            end
            tbl19.loaded[arg] = result
        end

        local v22 = tbl19.loaded[arg]
        local looped = v20.Looped
        v22.Priority = v20.Priority
        v22.Looped = looped

        pcall(function()
            v22:Play(0.1, 1, v20.Speed)
        end)

        tbl19.track = v22
    end

    local v20 = Emote:AddDropdown({
        Title = "Select Emote",
        Options = {},
        NoSave = false,
        Callback = function(selected)
            tbl19.selected = selected
        end,
    })

    Emote:AddButton({
        Title = "Refresh Emote List",
        Callback = function()
            flag7 = false
            tbl19.list = {}
            tbl19.data = {}
            fn47()
            fn7(v20, tbl19.list)
            local str2 = #tbl19.list > 0 and "Loaded " .. #tbl19.list .. " emotes." or "Emote folder tidak ditemukan!"
            fn6("Emote", str2, 2)
        end,
    })

    Emote:AddToggle({
        Title = "Enable Emote",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl19.enabled = enabled

            if not enabled then
                if tbl19.conn then
                    tbl19.conn:Disconnect()
                    tbl19.conn = nil
                end

                if tbl19.loop then
                    pcall(task.cancel, tbl19.loop)
                    tbl19.loop = nil
                end

                fn49()
                tbl19.loaded = {}
                return
            end

            fn47()

            if tbl19.selected == "" then
                tbl19.enabled = false
                fn6("Emote", "Pilih emote dari dropdown dulu!", 2)
                return
            end

            fn7(v20, tbl19.list)
            fn50(tbl19.selected)

            if tbl19.conn then
                tbl19.conn:Disconnect()
            end

            tbl19.conn = localPlayer.CharacterAdded:Connect(function()
                tbl19.loaded = {}
                tbl19.track = nil

                if tbl19.enabled and tbl19.selected ~= "" then
                    task.wait(1)
                    fn50(tbl19.selected)
                end
            end)

            if tbl19.loop then
                pcall(task.cancel, tbl19.loop)
            end

            tbl19.loop = task.spawn(function()
                while tbl19.enabled do
                    task.wait(0.5)

                    if not tbl19.track or not tbl19.track.IsPlaying then
                        fn50(tbl19.selected)
                    end
                end
            end)
        end,
    })
end

do
    local Data = nil

    pcall(function()
        Data = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
    end)

    local CollectionService = game:GetService("CollectionService")
    local jungleInteractions = nil

    local function fn6()
        if jungleInteractions and jungleInteractions.Parent then
            return jungleInteractions
        end
        jungleInteractions = workspace:FindFirstChild("JUNGLE INTERACTIONS")
        return jungleInteractions
    end

    local function fn7()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        return humanoidRootPart
    end

    local tbl4 = {
        ["Arrow Artifact"] = CFrame.new(875, 3, -368) * CFrame.Angles(0, math.rad(90), 0),
        ["Crescent Artifact"] = CFrame.new(1403, 3, 123) * CFrame.Angles(0, math.rad(180), 0),
        ["Hourglass Diamond Artifact"] = CFrame.new(1487, 3, -842) * CFrame.Angles(0, math.rad(180), 0),
        ["Diamond Artifact"] = CFrame.new(1844, 3, -287) * CFrame.Angles(0, math.rad(-90), 0),
    }

    local tbl5 = {
        "Arrow Artifact",
        "Crescent Artifact",
        "Hourglass Diamond Artifact",
        "Diamond Artifact",
    }

    local tbl6 = {
        ["Arrow Artifact"] = 265,
        ["Crescent Artifact"] = 266,
        ["Diamond Artifact"] = 267,
        ["Hourglass Diamond Artifact"] = 271,
    }

    local tbl7 = {
        ["Freshwater Piranha"] = 284,
        ["Goliath Tiger"] = 270,
        ["Sacred Guardian Squid"] = 283,
        Crocodile = 263,
    }

    local tbl8 = {
        "Freshwater Piranha",
        "Goliath Tiger",
        "Sacred Guardian Squid",
        "Crocodile",
    }

    local function fn8(arg, arg2)
        local cframe = typeof(arg) == "Vector3" and CFrame.new(arg) or arg
        local position = cframe.Position
        local v5 = fn7()
        if not arg2 and v5 and (v5.Position - position).Magnitude <= 5 then
            return
        end
        local v6 = Random.new()
        local vector = Vector3.new(v6:NextNumber(-2, 2), 0, v6:NextNumber(-2, 2))
        local cFrame = CFrame.new(position + vector) * (cframe - cframe.Position)

        if v5 then
            v5.CFrame = cFrame
            v5.AssemblyLinearVelocity = Vector3.zero
            v5.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function fn9(arg)
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"CompletedQuests"})
        end)

        if not ok or type(result) ~= "table" then
            return false
        end

        for k, v5 in pairs(result) do
            if tostring(v5) == arg then
                return true
            end
        end

        return false
    end

    local function fn10()
        if not Data then
            return nil
        end

        local ok, result = pcall(function()
            return Data:Get({"Quests", "Mainline", "Element Quest"})
        end)

        if ok and type(result) == "table" then
            return result
        end
        return nil
    end

    local function fn11()
        if fn9("Element Quest") then
            return "DONE"
        end
        local v5 = fn10()
        if not v5 then
            return "STAGE1"
        end
        tbl = {1, 1, 1, 3}

        local function fn12(arg)
            if not v5.Objectives then
                return 0, tbl[arg]
            end
            local n = 4 - #v5.Objectives
            local n2 = n

            if n < 0 then
                n2 = 0
            end

            if arg <= n2 then
                return tbl[arg], tbl[arg]
            end
            local v6 = v5.Objectives[arg - n2]
            if not v6 then
                return 0, tbl[arg]
            end
            local progress = v6.Progress
            local n3 = progress or 0
            return n3, tbl[arg]
        end

        fn12(1)
        local v6, v7 = fn12(2)
        local v8, v9 = fn12(3)
        local v10, v11 = fn12(4)
        if v11 <= v10 then
            return "DONE"
        end

        if v9 <= v8 then
            return "STAGE3"
        end

        if v7 <= v6 then
            return "STAGE2"
        end
        return "STAGE1"
    end

    local function fn12()
        if fn9("Deep Sea Quest") then
            return "DONE"
        end

        if not Data then
            return "SISYPHUS"
        end

        local ok, result = pcall(function()
            return Data:Get({"Quests", "Mainline", "Deep Sea Quest"})
        end)

        if not ok or type(result) ~= "table" then
            return "SISYPHUS"
        end
        tbl2 = {300, 3, 1, 1000000}

        local function fn13(arg)
            if not result.Objectives then
                return 0, tbl2[arg]
            end
            local n = 4 - #result.Objectives
            local n2 = n

            if n < 0 then
                n2 = 0
            end

            if arg <= n2 then
                return tbl2[arg], tbl2[arg]
            end
            local v5 = result.Objectives[arg - n2]
            if not v5 then
                return 0, tbl2[arg]
            end
            local progress = v5.Progress
            local n3 = progress or 0
            return n3, tbl2[arg]
        end

        local v5, v6 = fn13(1)
        local v7, v8 = fn13(2)
        local v9, v10 = fn13(3)
        local v11, v12 = fn13(4)
        if v9 < v10 or v7 < v8 or v11 < v12 then
            return "SISYPHUS"
        end

        if v5 < v6 then
            return "TREASURE"
        end
        return "DONE"
    end

    local function fn13(arg)
        if not Data then
            return false
        end
        local v5 = tbl6[arg]
        if not v5 then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"Inventory"})
        end)

        if not ok or not result then
            return false
        end
        local v6, v7, v8 = ipairs({result.Items, result.Gears, result.Artifacts})
        local v9 = v8
        local v10 = v6
        local v11 = v7

        while true do
            local v12, v13 = v10(v11, v9)
            if v12 == nil then
                break
            end
            v9 = v12
            if not v13 then
                continue
            end

            for k, v14 in pairs(v13) do
                if v14 and tonumber(v14.Id) == v5 then
                    return true
                end
            end

            v9 = v12
        end

        return false
    end

    local function fn14(arg)
        local rePlaceLeverItem = obj.RE_PlaceLeverItem
        if rePlaceLeverItem and pcall(function()
            rePlaceLeverItem:FireServer(arg)
        end) then
            return true
        end
        local v5 = fn6()
        if not v5 then
            return false
        end

        for i, descendant in ipairs(v5:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name == "TempleLever" and descendant:GetAttribute("Type") == arg then
                local rootPart = descendant:FindFirstChild("RootPart")
                local proximityPrompt = rootPart and descendant.RootPart:FindFirstChildWhichIsA("ProximityPrompt")
                if proximityPrompt then
                    fireproximityprompt(proximityPrompt)
                    return true
                end
                continue
            end
        end

        return false
    end

    local function fn15(arg)
        if Data then
            local ok, result = pcall(function()
                return Data:GetExpect({"TempleLevers"})
            end)

            if ok and result and result[arg] then
                return true
            end

            local ok2, result2 = pcall(function()
                return Data:Get({"TempleLevers"})
            end)

            if ok2 and result2 and result2[arg] then
                return true
            end
        end

        local v5 = fn6()
        if not v5 then
            return false
        end

        for i, descendant in ipairs(v5:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name == "TempleLever" and descendant:GetAttribute("Type") == arg then
                local rootPart = descendant:FindFirstChild("RootPart")
                local proximityPrompt = rootPart and descendant.RootPart:FindFirstChildWhichIsA("ProximityPrompt")
                local flag4 = proximityPrompt == nil
                return flag4
            end
        end

        return false
    end

    local function fn16(arg)
        return fn15(arg)
    end

    local tbl9 = nil

    local function fn17()
        tbl9 = {}

        for i, v5 in ipairs(CollectionService:GetTagged("PressurePlate")) do
            local parent = v5.Parent
            local attribute = parent and v5.Parent:GetAttribute("Type")

            if attribute then
                tbl9[attribute] = v5
            end
        end
    end

    local connection = nil
    local connection2 = nil

    local function fn18()
        if connection then
            return
        end

        connection = CollectionService:GetInstanceAddedSignal("PressurePlate"):Connect(function(arg)
            local parent = arg.Parent
            local attribute = parent and arg.Parent:GetAttribute("Type")

            if attribute then
                if not tbl9 then
                    tbl9 = {}
                end

                tbl9[attribute] = arg
            end
        end)

        connection2 = CollectionService:GetInstanceRemovedSignal("PressurePlate"):Connect(function(arg)
            if not tbl9 then
                return
            end
            local parent = arg.Parent
            local attribute = parent and arg.Parent:GetAttribute("Type")

            if attribute then
                tbl9[attribute] = nil
            end
        end)
    end

    local function fn19()
        if connection then
            connection:Disconnect()
            connection = nil
        end

        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        tbl9 = nil
    end

    local function fn20()
        if not Data then
            return {}
        end

        local ok, result = pcall(function()
            return Data:Get({"RuinPressurePlates"})
        end)

        local tbl10 = ok and type(result) == "table" and result or {}
        return tbl10
    end

    local function fn21(arg)
        for i, v5 in ipairs(tbl8) do
            if not arg[v5] then
                return false
            end
        end

        return true
    end

    local tbl10 = {enabled = false}
    local tbl11 = {enabled = false}
    local tbl12 = {enabled = false}
    local tbl13 = {enabled = false}

    local function fn22(arg)
        local str2 = arg and "<font color=\"rgb(123,239,178)\">[●]</font>" or "<font color=\"rgb(255,100,100)\">[●]</font>"
        return str2
    end

    local function fn23(arg, arg2, arg3)
        if arg3 and arg3 ~= "" then
            return string.format("%s %s <font color=\"rgb(170,170,170)\">(%s)</font>", fn22(arg), arg2, arg3)
        end
        return string.format("%s %s", fn22(arg), arg2)
    end

    local tbl14 = {}
    local thread = nil

    local function fn24()
        local v5 = tbl10
        local enabled = v5 and tbl10.enabled

        if not enabled then
            local v6 = tbl11
            enabled = v6 and tbl11.enabled
        end

        if not enabled then
            local v6 = tbl12
            enabled = v6 and tbl12.enabled
        end

        if not enabled then
            local v6 = tbl13
            enabled = v6 and tbl13.enabled
        end

        return enabled
    end

    local function fn25()
        if fn24() then
            return
        end

        if thread then
            pcall(task.cancel, thread)
            thread = nil
        end
    end

    local function fn26()
        if thread then
            return
        end

        thread = task.spawn(function()
            while fn24() do
                local v5 = tbl10
                local enabled = v5 and tbl10.enabled
                local v6 = tbl11
                local enabled2 = v6 and tbl11.enabled
                local v7 = tbl12
                local enabled3 = v7 and tbl12.enabled
                local v8 = tbl13
                local enabled4 = v8 and tbl13.enabled
                local n = 2

                pcall(function()
                    local artifact = tbl14.artifact

                    if enabled and artifact and artifact.SetContent then
                        local tbl15 = {}

                        for i, v9 in ipairs(tbl5) do
                            local str2 = v9:gsub(" Artifact", "")
                            table.insert(tbl15, fn23(fn16(v9), str2))
                        end

                        artifact:SetContent(table.concat(tbl15, "\n"))
                    end

                    local deepSea = tbl14.deepSea

                    if enabled2 and deepSea and deepSea.SetContent then
                        if Data then
                            if fn9("Deep Sea Quest") then
                                deepSea:SetContent(fn23(true, "Deep Sea Quest selesai"))
                            else
                                local ok, result = pcall(function()
                                    return Data:Get({"Quests", "Mainline", "Deep Sea Quest"})
                                end)

                                if ok and type(result) == "table" then
                                    local tbl15 = {300, 3, 1, 1000000}

                                    local function fn27(arg)
                                        if not result.Objectives then
                                            return 0, tbl15[arg]
                                        end
                                        local n2 = 4 - #result.Objectives
                                        local n3 = n2

                                        if n2 < 0 then
                                            n3 = 0
                                        end

                                        if arg <= n3 then
                                            return tbl15[arg], tbl15[arg]
                                        end
                                        local v9 = result.Objectives[arg - n3]
                                        if not v9 then
                                            return 0, tbl15[arg]
                                        end
                                        local progress = v9.Progress
                                        local n4 = progress or 0
                                        return n4, tbl15[arg]
                                    end

                                    local tbl16 = {}

                                    for i, v9 in ipairs({
                                        "Catch 300 Rare/Epic @ Treasure Room",
                                        "Catch 3 Mythic @ Sisyphus Statue",
                                        "Catch 1 SECRET @ Sisyphus Statue",
                                        "Earn 1M Coins",
                                    }) do
                                        local v10, v11 = fn27(i)
                                        local flag4 = v11 <= v10
                                        local insert = table.insert
                                        local str2 = flag4 and "DONE" or string.format("%d/%d", v10, v11)
                                        insert(tbl16, fn23(flag4, v9, str2))
                                    end

                                    deepSea:SetContent(table.concat(tbl16, "\n"))
                                else
                                    deepSea:SetContent("Menunggu data quest...")
                                end
                            end
                        else
                            deepSea:SetContent("Menunggu data...")
                        end
                    end

                    local element = tbl14.element

                    if enabled3 and element and element.SetContent then
                        if Data then
                            if fn9("Element Quest") then
                                element:SetContent(fn23(true, "Element Quest selesai"))
                            else
                                local v9 = fn10()

                                if v9 then
                                    local tbl15 = {1, 1, 1, 3}

                                    local function fn27(arg)
                                        if not v9.Objectives then
                                            return 0, tbl15[arg]
                                        end
                                        local n2 = 4 - #v9.Objectives
                                        local n3 = n2

                                        if n2 < 0 then
                                            n3 = 0
                                        end

                                        if arg <= n3 then
                                            return tbl15[arg], tbl15[arg]
                                        end
                                        local v10 = v9.Objectives[arg - n3]
                                        if not v10 then
                                            return 0, tbl15[arg]
                                        end
                                        local progress = v10.Progress
                                        local n4 = progress or 0
                                        return n4, tbl15[arg]
                                    end

                                    local tbl16 = {}

                                    for i, v10 in ipairs({
                                        "Own Ghostfinn Rod",
                                        "Catch SECRET @ Ancient Jungle",
                                        "Catch SECRET @ Sacred Temple",
                                        "Create Transcended Stones",
                                    }) do
                                        local v11, v12 = fn27(i)
                                        local flag4 = v12 <= v11
                                        local insert = table.insert
                                        local str2 = flag4 and "DONE" or string.format("%d/%d", v11, v12)
                                        insert(tbl16, fn23(flag4, v10, str2))
                                    end

                                    element:SetContent(table.concat(tbl16, "\n"))
                                else
                                    element:SetContent("Menunggu data quest...")
                                end
                            end
                        else
                            element:SetContent("Menunggu data...")
                        end
                    end

                    local ruin = tbl14.ruin

                    if enabled4 and ruin and ruin.SetContent then
                        if Data then
                            local v9 = fn20()

                            if fn21(v9) then
                                ruin:SetContent(fn23(true, "Semua plate selesai"))
                            else
                                local tbl15 = {}

                                for i, v10 in ipairs(tbl8) do
                                    table.insert(tbl15, fn23(v9[v10], v10))
                                end

                                ruin:SetContent(table.concat(tbl15, "\n"))
                            end
                        else
                            ruin:SetContent("Menunggu data sync...")
                        end
                    end

                    local flag4 = false
                    local flag5 = true

                    if enabled and artifact and artifact.SetContent then
                        flag4 = true

                        for i, v9 in ipairs(tbl5) do
                            if not fn16(v9) then
                                flag5 = false
                                break
                            end
                        end
                    end

                    if enabled2 and deepSea and deepSea.SetContent then
                        flag4 = true

                        if not fn9("Deep Sea Quest") then
                            flag5 = false
                        end
                    end

                    if enabled3 and element and element.SetContent then
                        flag4 = true

                        if not fn9("Element Quest") then
                            flag5 = false
                        end
                    end

                    if enabled4 and ruin and ruin.SetContent then
                        flag4 = true

                        if not fn21(fn20()) then
                            flag5 = false
                        end
                    end

                    if flag4 and flag5 then
                        n = 60
                    elseif not flag4 then
                        n = 15
                    end
                end)

                task.wait(n)
            end

            thread = nil
        end)
    end

    local v5 = v3:AddTab({Name = "Quest", Icon = "scroll"})
    local tbl15 = {enabled = false, thread = nil}
    local v6 = v5:AddSection("Auto Trigger Divine Power Quest", false)
    local v7 = v6:AddParagraph({Title = "Status", Content = "Idle"})

    local function fn27(arg, arg2)
        pcall(function()
            v7:SetTitle(arg)
            v7:SetContent(arg2)
        end)
    end

    local function fn28(arg)
        return string.format("%02dh %02dm %02ds", math.floor(arg / 3600), math.floor(arg % 3600 / 60), math.floor(arg % 60))
    end

    local function fn29()
        local ok, result = pcall(fn, ReplicatedStorage.Modules.Quests)
        local divinePower = ok and result and result.Mainline and result.Mainline["Divine Power"] or nil
        return divinePower
    end

    local function fn30(arg)
        return arg:Get({"Quests", "Mainline", "Divine Power"})
    end

    local function fn31(arg, arg2)
        if arg and arg.Timestamp then
            return math.max(arg2 - (workspace:GetServerTimeNow() - arg.Timestamp), 0)
        end
        return 0
    end

    local function fn32(arg)
        local flag4 = arg ~= nil

        if flag4 then
            if arg.Claimed then
                flag4 = false
            else
                flag4 = true
            end
        end

        return flag4
    end

    local function fn33(arg)
        local v8 = fn30(arg)
        if fn32(v8) then
            return true
        end

        for i = 1, 3 do
            pcall(function()
                obj.RE_DialogueEnded:FireServer("Lucid", 1, 1)
            end)

            for i2 = 1, 6 do
                task.wait(0.5)
                if fn32(fn30(arg)) then
                    return true
                end
            end
        end

        return false
    end

    local function fn34(arg, arg2, arg3)
        local tbl16 = {}

        if arg and arg.Objectives and arg2 then
            for i, objective in ipairs(arg.Objectives) do
                local v8 = arg2.Objectives[i]
                local progress = objective.Progress
                local n = progress or 0
                local goal = v8 and v8.Goal or "?"
                local flag4 = type(goal) == "number" and goal <= n
                local insert = table.insert
                local str2 = flag4 and "✓ " or "• "
                local name = v8 and v8.Name or "Obj " .. i
                insert(tbl16, str2 .. name .. " (" .. n .. "/" .. tostring(goal) .. ")")
            end
        end

        local v8 = fn31(arg, arg3)
        local insert = table.insert
        local str2 = v8 > 0 and fn28(v8) or "Ready!"
        insert(tbl16, "\n⏱ Next: " .. str2)
        return table.concat(tbl16, "\n")
    end

    v6:AddToggle({
        Title = "Auto Divine Power",
        Default = false,
        Callback = function(enabled)
            tbl15.enabled = enabled

            if tbl15.thread then
                pcall(task.cancel, tbl15.thread)
                tbl15.thread = nil
            end

            if not enabled then
                fn27("Status", "Idle")

                lib:MakeNotify({
                    Title = "Divine Power",
                    Description = "Stopped.",
                    Delay = 2,
                })

                return
            end

            lib:MakeNotify({Title = "Divine Power", Description = "Active!", Delay = 2})

            tbl15.thread = task.spawn(function()
                local v8, v9, repeatCooldown, v10, n
                n = 1

                while true do
                    if n == 1 then
                        v8 = fn2()
                        n = 2
                    elseif n == 2 then
                        v9 = fn29()

                        if v9 then
                            n = 4
                        else
                            n = 3
                        end
                    elseif n == 3 then
                        task.wait(1)
                        n = 4
                    elseif n == 4 then
                        if not v9 and tbl15.enabled then
                            n = 2
                        else
                            n = 5
                        end
                    elseif n == 5 then
                        if tbl15.enabled then
                            n = 6
                        else
                            n = 16
                        end
                    elseif n == 6 then
                        repeatCooldown = v9.RepeatCooldown
                        n = 7
                    elseif n == 7 then
                        if tbl15.enabled then
                            n = 8
                        else
                            n = 15
                        end
                    elseif n == 8 then
                        v10 = fn30(v8)

                        if fn31(v10, repeatCooldown) > 0 then
                            n = 14
                        else
                            n = 9
                        end
                    elseif n == 9 then
                        if fn32(v10) then
                            n = 12
                        else
                            n = 10
                        end
                    elseif n == 10 then
                        fn27("Accepting", "Triggering quest...")

                        if fn33(v8) then
                            n = 11
                        else
                            n = 13
                        end
                    elseif n == 11 then
                        lib:MakeNotify({
                            Title = "Divine Power",
                            Description = "Quest accepted!",
                            Delay = 3,
                        })

                        n = 12
                    elseif n == 12 then
                        fn27("Divine Power", fn34(fn30(v8), v9, repeatCooldown))
                        task.wait(1)
                        n = 7
                    elseif n == 13 then
                        fn27("Failed", "Gagal accept, retry in 5s...")
                        task.wait(5)
                        n = 7
                    elseif n == 14 then
                        fn27("Cooldown", fn34(v10, v9, repeatCooldown))
                        task.wait(1)
                        n = 7
                    elseif n == 15 then
                        fn27("Status", "Idle")
                        return
                    elseif n == 16 then
                        return
                    end
                end
            end)
        end,
    })

    tbl10 = {enabled = false, thread = nil, fishConn = nil}
    local v8 = v5:AddSection("Artifact Lever", false)

    local v9 = v8:AddParagraph({
        Title = "Artifact Status",
        Content = "Nyalakan Auto Artifact Progress untuk memuat status.",
    })

    tbl14.artifact = v9

    v8:AddToggle({
        Title = "Auto Artifact Progress",
        Default = false,
        Callback = function(enabled)
            tbl10.enabled = enabled

            if tbl10.fishConn then
                tbl10.fishConn:Disconnect()
                tbl10.fishConn = nil
            end

            if tbl10.thread then
                task.cancel(tbl10.thread)
                tbl10.thread = nil
            end

            if not enabled then
                pcall(function()
                    v9:SetContent("Nyalakan Auto Artifact Progress untuk memuat status.")
                end)

                fn25()
                return
            end

            fn26()

            local thread2 = task.spawn(function()
                while tbl10.enabled do
                    local flag4 = true

                    for i, v10 in ipairs(tbl5) do
                        if not fn16(v10) then
                            flag4 = false

                            if fn13(v10) then
                                local v11 = fn7()

                                if v11 and tbl4[v10] then
                                    v11.CFrame = tbl4[v10]
                                    task.wait(1.5)
                                end

                                if not fn14(v10) then
                                    task.wait(1.5)
                                    fn14(v10)
                                end

                                local n = tick() + 10

                                repeat
                                    task.wait(0.5)
                                until fn16(v10) or n < tick()
                            else
                                local v11 = fn7()

                                if v11 and tbl4[v10] and (v11.Position - tbl4[v10].Position).Magnitude > 15 then
                                    v11.CFrame = tbl4[v10]
                                    task.wait(1.5)
                                end

                                local flag5 = false
                                local reFishCaught = obj.RE_FishCaught

                                if reFishCaught then
                                    local connection3 = nil

                                    connection3 = reFishCaught.OnClientEvent:Connect(function()
                                        if not tbl10.enabled then
                                            connection3:Disconnect()
                                            return
                                        end

                                        if fn13(v10) then
                                            flag5 = true
                                            connection3:Disconnect()
                                        end
                                    end)

                                    tbl10.fishConn = connection3
                                end

                                local n = tick() + 90

                                repeat
                                    task.wait(2)

                                    if fn13(v10) then
                                        flag5 = true
                                    end
                                until flag5 or not tbl10.enabled or n < tick()

                                if tbl10.fishConn then
                                    tbl10.fishConn:Disconnect()
                                    tbl10.fishConn = nil
                                end

                                if flag5 and tbl10.enabled then
                                    local v12 = fn7()

                                    if v12 and tbl4[v10] then
                                        v12.CFrame = tbl4[v10]
                                        task.wait(1.5)
                                    end

                                    if not fn14(v10) then
                                        task.wait(1.5)
                                        fn14(v10)
                                    end

                                    local n2 = tick() + 10

                                    repeat
                                        task.wait(0.5)
                                    until fn16(v10) or n2 < tick()
                                end
                            end

                            break
                        end
                    end

                    if not flag4 then
                        task.wait(1)
                        continue
                    end
                    tbl10.enabled = false

                    lib:MakeNotify({
                        Title = "Artifact",
                        Description = "Semua artifact selesai!",
                        Color = Color3.fromRGB(123, 239, 178),
                        Delay = 3,
                    })

                    break
                end

                if tbl10.fishConn then
                    tbl10.fishConn:Disconnect()
                    tbl10.fishConn = nil
                end
            end)

            tbl10.thread = thread2
        end,
    })

    v8:AddButton({
        Title = "TP: Arrow Artifact",
        Callback = function()
            fn8(tbl4["Arrow Artifact"])
        end,
    })

    v8:AddButton({
        Title = "TP: Crescent Artifact",
        Callback = function()
            fn8(tbl4["Crescent Artifact"])
        end,
    })

    v8:AddButton({
        Title = "TP: Hourglass Diamond Artifact",
        Callback = function()
            fn8(tbl4["Hourglass Diamond Artifact"])
        end,
    })

    v8:AddButton({
        Title = "TP: Diamond Artifact",
        Callback = function()
            fn8(tbl4["Diamond Artifact"])
        end,
    })

    tbl11 = {enabled = false, thread = nil}
    local v10 = nil
    local v11 = v5:AddSection("Deep Sea Quest", false)

    local v12 = v11:AddParagraph({
        Title = "Deep Sea Tracker",
        Content = "Nyalakan Auto Deep Sea Quest untuk memuat status.",
    })

    tbl14.deepSea = v12

    local tbl16 = {
        treasure = CFrame.lookAt(Vector3.new(-3599, -276, -1641), Vector3.new(-3722.606, -275.674, -1558.736)),
        sisyphus = CFrame.lookAt(Vector3.new(-3763, -135, -995), Vector3.new(-3698, -135, -1008)),
    }

    v11:AddToggle({
        Title = "Auto Deep Sea Quest",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl11.enabled = enabled

            if tbl11.thread then
                task.cancel(tbl11.thread)
                tbl11.thread = nil
            end

            if not enabled then
                v10 = nil

                pcall(function()
                    v12:SetContent("Nyalakan Auto Deep Sea Quest untuk memuat status.")
                end)

                fn25()
                return
            end

            fn26()

            local thread2 = task.spawn(function()
                while tbl11.enabled do
                    pcall(function()
                        local v13 = fn12()

                        if v13 == "DONE" then
                            tbl11.enabled = false

                            lib:MakeNotify({
                                Title = "Deep Sea Quest",
                                Description = "Deep Sea Quest selesai!",
                                Delay = 3,
                            })

                            return
                        end

                        if v10 and v10 ~= v13 then
                            lib:MakeNotify({
                                Title = "Deep Sea Quest",
                                Description = "Stage berubah! Pindah lokasi...",
                                Delay = 3,
                            })
                        end

                        v10 = v13
                        local sisyphus = nil

                        if v13 == "SISYPHUS" then
                            sisyphus = tbl16.sisyphus
                        elseif v13 == "TREASURE" then
                            sisyphus = tbl16.treasure
                        elseif v13 == "COINS" then
                            sisyphus = nil
                        end

                        if sisyphus then
                            local v14 = fn7()

                            if v14 and (v14.Position - sisyphus.Position).Magnitude > 10 then
                                fn8(sisyphus, true)
                            end
                        end
                    end)

                    task.wait(1)
                end
            end)

            tbl11.thread = thread2
        end,
    })

    v11:AddButton({
        Title = "TP: Treasure Room",
        Callback = function()
            fn8(tbl16.treasure, true)
        end,
    })

    v11:AddButton({
        Title = "TP: Sisyphus Statue",
        Callback = function()
            fn8(tbl16.sisyphus, true)
        end,
    })

    tbl12 = {enabled = false, thread = nil}
    local v13 = v5:AddSection("Element Quest", false)

    local v14 = v13:AddParagraph({
        Title = "Element Tracker",
        Content = "Nyalakan Auto Element Quest untuk memuat status.",
    })

    tbl14.element = v14

    local tbl17 = {
        stage1 = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0),
        stage2 = CFrame.new(1453, -22, -636),
        stage3 = CFrame.new(1480, 128, -593),
    }

    local v15 = nil

    v13:AddToggle({
        Title = "Auto Element Quest",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl12.enabled = enabled

            if tbl12.thread then
                task.cancel(tbl12.thread)
                tbl12.thread = nil
            end

            if not enabled then
                v15 = nil

                pcall(function()
                    v14:SetContent("Nyalakan Auto Element Quest untuk memuat status.")
                end)

                fn25()
                return
            end

            fn26()

            local thread2 = task.spawn(function()
                while tbl12.enabled do
                    pcall(function()
                        local v16 = fn11()

                        if v16 == "DONE" then
                            tbl12.enabled = false

                            lib:MakeNotify({
                                Title = "Element Quest",
                                Description = "Element Quest selesai!",
                                Delay = 3,
                            })

                            return
                        end

                        if v15 and v15 ~= v16 then
                            lib:MakeNotify({
                                Title = "Element Quest",
                                Description = "Stage berubah! Pindah lokasi...",
                                Delay = 3,
                            })
                        end

                        v15 = v16
                        local stage1 = nil

                        if v16 == "STAGE1" then
                            stage1 = tbl17.stage1
                        elseif v16 == "STAGE2" then
                            stage1 = tbl17.stage2
                        elseif v16 == "STAGE3" then
                            stage1 = tbl17.stage3
                        end

                        if stage1 then
                            local v17 = fn7()

                            if v17 and (v17.Position - stage1.Position).Magnitude > 10 then
                                fn8(stage1, true)
                            end
                        end
                    end)

                    task.wait(1)
                end
            end)

            tbl12.thread = thread2
        end,
    })

    v13:AddButton({
        Title = "TP: Ancient Jungle (Stage 1)",
        Callback = function()
            fn8(tbl17.stage1, true)
        end,
    })

    v13:AddButton({
        Title = "TP: Sacred Temple (Stage 2)",
        Callback = function()
            fn8(tbl17.stage2, true)
        end,
    })

    v13:AddButton({
        Title = "TP: Transcended Stones (Stage Final)",
        Callback = function()
            fn8(tbl17.stage3, true)
        end,
    })

    v13:AddButton({
        Title = "TP: Underground Cellar",
        Callback = function()
            fn8(CFrame.new(2136, -91, -701), true)
        end,
    })

    local tbl18 = {enabled = false, thread = nil, paraThread = nil}
    local cframe = CFrame.new(-1775.255, -222.634995, 23922.1328, 0.707134247, -0.0, -0.707079291, 0, 1, -0.0, 0.707079291, 0, 0.707134247)
    local tbl19 = {"Diamond Researcher", "Lary the Scientist", "Lary"}

    local tbl20 = {
        ruby = {Id = 243, Metadata = {VariantId = 3}},
        lochness = {Id = 228},
    }

    local tbl21 = {
        coral = CFrame.lookAt(Vector3.new(-2921.858, 3.25, 2083.297), Vector3.new(-3068.679, 3.25, 2052.582)),
        tropical = CFrame.lookAt(Vector3.new(-2140.796, 53.487, 3622.714), Vector3.new(-2216.205, 53.487, 3752.381)),
        treasure_room = CFrame.lookAt(Vector3.new(-3597.324, -275.674, -1641.224), Vector3.new(-3722.606, -275.674, -1558.736)),
        kohana = CFrame.lookAt(Vector3.new(-655.469, 17.245, 501.038), Vector3.new(-511.246, 17.245, 542.266)),
    }

    local tbl22 = {1, 1, 1, 1, 1, 1000}
    local v16 = v5:AddSection("Diamond Researcher Quest", false)

    local v17 = v16:AddParagraph({
        Title = "Diamond Quest Status",
        Content = "Nyalakan Auto Diamond Researcher untuk memuat status.",
    })

    local function fn35()
        if not Data then
            return nil
        end

        local ok, result = pcall(function()
            return Data:Get({"Quests", "Mainline", "Diamond Researcher"})
        end)

        local v18 = ok and result or nil
        return v18
    end

    local function fn36()
        if not Data then
            return false
        end
        local v18 = Data:Get({"CompletedQuests"})
        local tbl23 = v18 or {}

        for i, v19 in ipairs(tbl23) do
            if v19 == "Diamond Researcher" then
                return true
            end
        end

        return false
    end

    local function fn37(arg, arg2)
        if arg and arg.Objectives then
            local v18 = arg.Objectives[arg2]

            if not v18 then
                local v19 = tbl22[arg2]
                local n = v19 or 1
                return 0, n
            end

            local progress = v18.Progress
            local n = progress or 0
            local v19 = tbl22[arg2]
            local n2 = v19 or 1
            return n, n2
        end

        local v18 = tbl22[arg2]
        local n = v18 or 1
        return 0, n
    end

    local function fn38(arg, arg2)
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"Inventory"})
        end)

        if not ok or not result then
            return false
        end
        local v18, v19, v20 = ipairs({result.Items, result.Gears, result.Artifacts, result.Fish})
        local v21 = v20
        local v22 = v18
        local v23 = v19

        while true do
            local v24, v25 = v22(v23, v21)
            if v24 == nil then
                break
            end
            v21 = v24
            if not v25 then
                continue
            end

            for k, v26 in pairs(v25) do
                if v26 and tonumber(v26.Id) == arg then
                    if not arg2 then
                        return true
                    end

                    if v26.Metadata and v26.Metadata.VariantId == arg2.VariantId then
                        return true
                    end
                end
            end

            v21 = v24
        end

        return false
    end

    local function fn39(cFrame)
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end

        if (humanoidRootPart.Position - cFrame.Position).Magnitude > 10 then
            humanoidRootPart.CFrame = cFrame
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function fn40(arg, arg2)
        local npc = workspace:FindFirstChild("NPC")
        local flag4 = false

        if npc then
            for i, v18 in ipairs(tbl19) do
                local v19 = npc:FindFirstChild(v18)

                if v19 then
                    local proximityPrompt = v19:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if not proximityPrompt then
                        continue
                    end
                    pcall(fireproximityprompt, proximityPrompt)
                    flag4 = true
                    break
                end

                continue
            end
        end

        if not flag4 then
            for i, v18 in ipairs(tbl19) do
                local v19 = workspace:FindFirstChild(v18, true)

                if v19 then
                    local proximityPrompt = v19:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if not proximityPrompt then
                        continue
                    end
                    pcall(fireproximityprompt, proximityPrompt)
                    flag4 = true
                    break
                end

                continue
            end
        end

        if not flag4 then
            return false
        end
        task.wait(1)

        pcall(function()
            obj.RE_DialogueEnded:FireServer("Diamond Researcher", arg, arg2)
        end)

        task.wait(1)
        return true
    end

    local function fn41()
        if tbl18.paraThread then
            task.cancel(tbl18.paraThread)
            tbl18.paraThread = nil
        end
    end

    local function fn42()
        fn41()

        tbl18.paraThread = task.spawn(function()
            while tbl18.enabled do
                task.wait(2)

                pcall(function()
                    if not v17 or not v17.SetContent then
                        return
                    end

                    if not Data then
                        v17:SetContent("Menunggu data...")
                        return
                    end

                    if not fn36() then
                        local v18 = fn35()
                        if not v18 then
                            v17:SetContent("Quest belum dimulai / data belum tersedia")
                            return
                        end
                        local tbl23 = {}

                        for i, v19 in ipairs({
                            "Own Element Rod",
                            "Catch SECRET @ Coral Reefs",
                            "Catch SECRET @ Tropical Grove",
                            "Submit Ruby Mutated",
                            "Submit Lochness Monster",
                            "Catch 1000 PERFECT fish",
                        }) do
                            local v20, v21 = fn37(v18, i)
                            local flag4 = v21 <= v20
                            local insert = table.insert
                            local str2 = flag4 and "DONE" or string.format("%d/%d", v20, v21)
                            insert(tbl23, fn23(flag4, v19, str2))
                        end

                        v17:SetContent(table.concat(tbl23, "\n"))
                        return
                    end

                    v17:SetContent(fn23(true, "Diamond Researcher Quest selesai"))
                    fn41()
                end)
            end

            tbl18.paraThread = nil
        end)
    end

    v16:AddToggle({
        Title = "Auto Diamond Researcher Quest",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl18.enabled = enabled

            if enabled then
                if tbl18.thread then
                    task.cancel(tbl18.thread)
                    tbl18.thread = nil
                end

                fn42()

                tbl18.thread = task.spawn(function()
                    while tbl18.enabled do
                        pcall(function()
                            if not Data then
                                task.wait(3)
                                return
                            end

                            if not fn36() then
                                local v18 = fn35()

                                if not v18 then
                                    fn39(cframe)
                                    task.wait(2)
                                    fn40(1, 1)
                                    task.wait(2)
                                    return
                                end

                                fn37(v18, 1)
                                local v19, v20 = fn37(v18, 2)
                                local v21, v22 = fn37(v18, 3)
                                local v23, v24 = fn37(v18, 4)
                                local v25, v26 = fn37(v18, 5)
                                local v27, v28 = fn37(v18, 6)
                                local flag4 = v20 <= v19
                                local flag5 = v22 <= v21
                                local flag6 = v24 <= v23
                                local flag7 = v26 <= v25
                                local flag8 = v28 <= v27

                                if flag4 then
                                    if flag5 then
                                        if flag6 then
                                            if flag7 then
                                                if flag8 then
                                                    fn39(cframe)
                                                    task.wait(2)
                                                    fn40(1, 2)
                                                else
                                                    fn39(tbl21.coral)
                                                end
                                            elseif fn38(tbl20.lochness.Id) then
                                                fn39(cframe)
                                                task.wait(2)
                                                fn40(2, 2)
                                            else
                                                fn39(tbl21.kohana)
                                            end
                                        elseif fn38(tbl20.ruby.Id, tbl20.ruby.Metadata) then
                                            fn39(cframe)
                                            task.wait(2)
                                            fn40(2, 1)
                                        else
                                            fn39(tbl21.treasure_room)
                                        end
                                    else
                                        fn39(tbl21.tropical)
                                    end
                                else
                                    fn39(tbl21.coral)
                                end

                                return
                            end

                            tbl18.enabled = false
                            fn41()

                            pcall(function()
                                v17:SetContent(fn23(true, "Diamond Researcher Quest selesai"))
                            end)

                            lib:MakeNotify({
                                Title = "Diamond Researcher",
                                Description = "Quest selesai!",
                                Delay = 3,
                            })
                        end)

                        task.wait(2)
                    end
                end)
            else
                if tbl18.thread then
                    task.cancel(tbl18.thread)
                    tbl18.thread = nil
                end

                fn41()

                pcall(function()
                    v17:SetContent("Nyalakan Auto Diamond Researcher untuk memuat status.")
                end)
            end
        end,
    })

    v16:AddButton({
        Title = "TP: Diamond Researcher NPC",
        Callback = function()
            fn39(cframe)
        end,
    })

    v16:AddButton({
        Title = "TP: Coral Reefs",
        Callback = function()
            fn39(tbl21.coral)
        end,
    })

    v16:AddButton({
        Title = "TP: Tropical Grove",
        Callback = function()
            fn39(tbl21.tropical)
        end,
    })

    v16:AddButton({
        Title = "TP: Treasure Room",
        Callback = function()
            fn39(tbl21.treasure_room)
        end,
    })

    v16:AddButton({
        Title = "TP: Kohana (Lochness)",
        Callback = function()
            fn39(tbl21.kohana)
        end,
    })

    v16:AddButton({
        Title = "Manual: Submit Ruby Mutated",
        Callback = function()
            fn39(cframe)
            task.wait(2)
            fn40(2, 1)
        end,
    })

    v16:AddButton({
        Title = "Manual: Submit Lochness Monster",
        Callback = function()
            fn39(cframe)
            task.wait(2)
            fn40(2, 2)
        end,
    })

    tbl13 = {enabled = false, thread = nil}
    local v18 = v5:AddSection("Auto Ancient Ruin", false)

    local v19 = v18:AddParagraph({
        Title = "Ancient Ruin Status",
        Content = "Nyalakan Auto Ancient Ruin untuk memuat status.",
    })

    tbl14.ruin = v19

    v18:AddToggle({
        Title = "Auto Ancient Ruin",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl13.enabled = enabled

            if tbl13.thread then
                task.cancel(tbl13.thread)
                tbl13.thread = nil
            end

            if not enabled then
                fn19()

                pcall(function()
                    v19:SetContent("Nyalakan Auto Ancient Ruin untuk memuat status.")
                end)

                fn25()
                return
            end

            fn17()
            fn18()
            fn26()

            local thread2 = task.spawn(function()
                while tbl13.enabled do
                    pcall(function()
                        if not Data then
                            return
                        end
                        local v20 = fn20()

                        if not fn21(v20) then
                            local ok, result = pcall(function()
                                return Data:Get({"Inventory"})
                            end)

                            local items = ok and result and result.Items or {}
                            local v21, v22, v23 = ipairs(tbl8)
                            local v24 = v23
                            local v25 = v21
                            local v26 = v22

                            while true do
                                local v27, v28 = v25(v26, v24)
                                if v27 == nil then
                                    break
                                end
                                v24 = v27

                                if not v20[v28] then
                                    local v29 = tbl7[v28]
                                    local flag4 = false

                                    for i, item in ipairs(items) do
                                        if tonumber(item.Id) == v29 then
                                            flag4 = true
                                            break
                                        end
                                    end

                                    v24 = v27

                                    if flag4 then
                                        local v30 = tbl9
                                        local v31 = v30 and tbl9[v28]

                                        if root and v31 then
                                            local cframe2 = CFrame.new(v31.Position + Vector3.new(0, 3, 0))
                                            local v32 = fn7()

                                            if v32 then
                                                v32.CFrame = cframe2
                                                task.wait(0.6)
                                            end
                                        end

                                        local rePlacePressureItem = obj.RE_PlacePressureItem

                                        if rePlacePressureItem then
                                            pcall(function()
                                                rePlacePressureItem:FireServer(v28)
                                            end)

                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end

                            return
                        end

                        tbl13.enabled = false

                        lib:MakeNotify({
                            Title = "Ancient Ruin",
                            Description = "Semua pressure plate selesai!",
                            Color = Color3.fromRGB(123, 239, 178),
                            Delay = 3,
                        })
                    end)

                    task.wait(1.5)
                end
            end)

            tbl13.thread = thread2
        end,
    })

    local tbl23 = {enabled = false, thread = nil, paraThread = nil}

    local tbl24 = {
        crystal_depths = CFrame.lookAt(Vector3.new(5729.334, -904.818, 15408.078), Vector3.new(5691.893, -904.818, 15262.826)),
        npc = CFrame.new(5700.34424, -894.733459, 15299.3174, 0.943476617, 0, 0.331439078, 0, 1, 0, -0.331439078, 0, 0.943476617),
    }

    local tbl25 = {1, 1, 1, 1, 1}

    local tbl26 = {
        "Own an Element Rod",
        "Own a Singularity Bait",
        "Exchange a Cursed Kraken",
        "Catch an Elpirate Gran Maja",
        "Catch Legendary Crystalized @ Crystal Depths",
    }

    local tbl27 = {cursed_kraken = {Id = 589}, elpirate = {Id = 661}}

    local function fn43()
        if not Data then
            return nil
        end

        local ok, result = pcall(function()
            return Data:Get({"Quests", "Mainline", "Crystalline Secrets"})
        end)

        local v20 = ok and result or nil
        return v20
    end

    local function fn44()
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"CompletedQuests"})
        end)

        if not ok or type(result) ~= "table" then
            return false
        end

        for k, v20 in pairs(result) do
            if tostring(v20) == "Crystalline Secrets" then
                return true
            end
        end

        return false
    end

    local function fn45(arg, arg2)
        if arg and arg.Objectives then
            local v20 = arg.Objectives[arg2]

            if not v20 then
                local v21 = tbl25[arg2]
                local n = v21 or 1
                return 0, n
            end

            local progress = v20.Progress
            local n = progress or 0
            local v21 = tbl25[arg2]
            local n2 = v21 or 1
            return n, n2
        end

        local v20 = tbl25[arg2]
        local n = v20 or 1
        return 0, n
    end

    local function fn46(arg, arg2)
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"Inventory"})
        end)

        if not ok or not result then
            return false
        end

        local v20, v21, v22 = ipairs({
            result.Items,
            result.Gears,
            result.Artifacts,
            result.Fish,
            result.Baits,
        })

        local v23 = v22
        local v24 = v20
        local v25 = v21

        while true do
            local v26, v27 = v24(v25, v23)
            if v26 == nil then
                break
            end
            v23 = v26
            if not v27 then
                continue
            end

            for k, v28 in pairs(v27) do
                if v28 and tonumber(v28.Id) == arg then
                    if not arg2 then
                        return true
                    end

                    if v28.Metadata and v28.Metadata.VariantId == arg2.VariantId then
                        return true
                    end
                end
            end

            v23 = v26
        end

        return false
    end

    local function fn47(cFrame)
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end

        if (humanoidRootPart.Position - cFrame.Position).Magnitude > 10 then
            humanoidRootPart.CFrame = cFrame
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function fn48()
        local reDialogueEnded = obj.RE_DialogueEnded

        if reDialogueEnded then
            pcall(function()
                reDialogueEnded:FireServer("Crystalline Secret", 3, 1)
            end)
        end
    end

    local v20 = v5:AddSection("Crystalline Secret Quest", false)

    local v21 = v20:AddParagraph({
        Title = "Crystalline Secret Status",
        Content = "Nyalakan Auto Crystalline Secret Quest untuk memuat status.",
    })

    local function fn49()
        if tbl23.paraThread then
            task.cancel(tbl23.paraThread)
            tbl23.paraThread = nil
        end
    end

    local function fn50()
        fn49()

        tbl23.paraThread = task.spawn(function()
            while tbl23.enabled do
                task.wait(2)

                pcall(function()
                    if not v21 or not v21.SetContent then
                        return
                    end

                    if not Data then
                        v21:SetContent("Menunggu data...")
                        return
                    end

                    if not fn44() then
                        local v22 = fn43()
                        if not v22 then
                            v21:SetContent("Quest belum dimulai / data belum tersedia")
                            return
                        end
                        local tbl28 = {}

                        for i, v23 in ipairs(tbl26) do
                            local v24, v25 = fn45(v22, i)
                            local flag4 = v25 <= v24
                            local insert = table.insert
                            local str2 = flag4 and "DONE" or string.format("%d/%d", v24, v25)
                            insert(tbl28, fn23(flag4, v23, str2))
                        end

                        v21:SetContent(table.concat(tbl28, "\n"))
                        return
                    end

                    v21:SetContent(fn23(true, "Crystalline Secret Quest selesai"))
                    fn49()
                end)
            end

            tbl23.paraThread = nil
        end)
    end

    v20:AddToggle({
        Title = "Auto Crystalline Secret Quest",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl23.enabled = enabled

            if enabled then
                if tbl23.thread then
                    task.cancel(tbl23.thread)
                    tbl23.thread = nil
                end

                fn50()

                tbl23.thread = task.spawn(function()
                    while tbl23.enabled do
                        pcall(function()
                            if not Data then
                                task.wait(3)
                                return
                            end

                            if not fn44() then
                                local v22 = fn43()

                                if not v22 then
                                    fn47(tbl24.crystal_depths)
                                    task.wait(3)
                                    return
                                end

                                fn45(v22, 1)
                                fn45(v22, 2)
                                local v23, v24 = fn45(v22, 3)
                                local v25, v26 = fn45(v22, 4)
                                local v27, v28 = fn45(v22, 5)

                                if v23 < v24 then
                                    if fn46(tbl27.cursed_kraken.Id) then
                                        fn47(tbl24.npc)
                                        task.wait(2)
                                        fn48()
                                    else
                                        fn47(tbl24.crystal_depths)
                                    end
                                elseif v25 < v26 then
                                    fn47(tbl24.crystal_depths)
                                elseif v27 < v28 then
                                    fn47(tbl24.crystal_depths)
                                else
                                    fn47(tbl24.crystal_depths)
                                end

                                return
                            end

                            tbl23.enabled = false
                            fn49()

                            pcall(function()
                                v21:SetContent(fn23(true, "Crystalline Secret Quest selesai"))
                            end)

                            lib:MakeNotify({
                                Title = "Crystalline Secret",
                                Description = "Quest selesai!",
                                Delay = 3,
                            })
                        end)

                        task.wait(2)
                    end
                end)
            else
                if tbl23.thread then
                    task.cancel(tbl23.thread)
                    tbl23.thread = nil
                end

                fn49()

                pcall(function()
                    v21:SetContent("Nyalakan Auto Crystalline Secret Quest untuk memuat status.")
                end)
            end
        end,
    })

    v20:AddButton({
        Title = "TP: Crystal Depths",
        Callback = function()
            fn47(tbl24.crystal_depths)
        end,
    })

    v20:AddButton({
        Title = "TP: NPC (Exchange)",
        Callback = function()
            fn47(tbl24.npc)
        end,
    })

    v20:AddButton({
        Title = "Manual: Exchange Cursed Kraken",
        Callback = function()
            fn47(tbl24.npc)
            task.wait(2)
            fn48()
        end,
    })

    local tbl28 = {enabled = false, thread = nil, paraThread = nil}
    local cframe2 = CFrame.new(3435.933, -287.845, 3411.405)
    local cframe3 = CFrame.lookAt(Vector3.new(-655.469, 17.245, 501.038), Vector3.new(-511.246, 17.245, 542.266))

    local tbl29 = {
        CFrame.new(3443.019, -290.466, 3390.035),
        CFrame.new(3431.017, -290.466, 3396.531),
        CFrame.new(3456.389, -290.466, 3387.298),
    }

    local tbl30 = {
        {index = 1, name = "Sunken Eye Relic"},
        {index = 2, name = "Blacktide Relic"},
        {index = 3, name = "Burntflame Relic"},
    }

    local tbl31 = {1, 1, 1, 200}

    local tbl32 = {
        "Catch Magma Core",
        "Catch Leviathan Essence",
        "Catch Ocean Core",
        "Catch 200 PERFECT fish",
    }

    local function fn51()
        local ok, result = pcall(function()
            return require(game:GetService("ReplicatedStorage").Packages.Replion).Client:GetReplion("LeviathanEvent")
        end)

        local v22 = ok and result or nil
        return v22
    end

    local function fn52()
        if not Data then
            return nil
        end

        local ok, result = pcall(function()
            return Data:Get({"Quests", "Mainline", "Forgotten Scale"})
        end)

        local v22 = ok and result or nil
        return v22
    end

    local function fn53()
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"CompletedQuests"})
        end)

        if not ok or type(result) ~= "table" then
            return false
        end

        for k, v22 in pairs(result) do
            if tostring(v22) == "Forgotten Scale" then
                return true
            end
        end

        return false
    end

    local function fn54(arg, arg2)
        if arg and arg.Objectives then
            local v22 = arg.Objectives[arg2]

            if not v22 then
                local v23 = tbl31[arg2]
                local n = v23 or 1
                return 0, n
            end

            local progress = v22.Progress
            local n = progress or 0
            local v23 = tbl31[arg2]
            local n2 = v23 or 1
            return n, n2
        end

        local v22 = tbl31[arg2]
        local n = v22 or 1
        return 0, n
    end

    local function fn55(arg)
        if not Data then
            return nil
        end

        local ok, result = pcall(function()
            return Data:Get({"Inventory"})
        end)

        if not ok or not result or not result.Gears then
            return nil
        end

        for k, gear in pairs(result.Gears) do
            if gear and gear.Name == arg then
                return gear.UUID
            end
        end

        return nil
    end

    local function fn56()
        for i, v22 in ipairs(tbl30) do
            if not fn55(v22.name) then
                return false
            end
        end

        return true
    end

    local function fn57(arg, arg2)
        if not arg then
            return false
        end

        local ok, result = pcall(function()
            return arg:GetExpect("PressurePlates")
        end)

        if not ok or not result then
            return false
        end
        local flag4 = table.find(result, arg2) ~= nil
        return flag4
    end

    local function fn58(cFrame)
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            humanoidRootPart.CFrame = cFrame
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function fn59()
        local npc = workspace:FindFirstChild("NPC")
        if not npc then
            return
        end
        local archaeologist = npc:FindFirstChild("Archaeologist")
        if not archaeologist then
            return
        end
        local proximityPrompt = archaeologist:FindFirstChildWhichIsA("ProximityPrompt", true)

        if proximityPrompt then
            pcall(fireproximityprompt, proximityPrompt)
        end
    end

    local function fn60()
        if not Data then
            return false
        end

        local ok, result = pcall(function()
            return Data:Get({"Inventory"})
        end)

        if not ok or not result then
            return false
        end
        local v22, v23, v24 = ipairs({result.Items, result.Gears})
        local v25 = v24
        local v26 = v22
        local v27 = v23

        while true do
            local v28, v29 = v26(v27, v25)
            if v28 == nil then
                break
            end
            v25 = v28
            if not v29 then
                continue
            end

            for k, v30 in pairs(v29) do
                if v30 and v30.Name == "Leviathan Scale" then
                    return true, v30.UUID
                end
            end

            v25 = v28
        end

        return false, nil
    end

    local function fn61()
        local v22, v23 = fn60()

        if not v22 then
            lib:MakeNotify({
                Title = "Leviathan",
                Description = "Leviathan Scale tidak ada!",
                Color = Color3.fromRGB(255, 100, 100),
                Delay = 3,
            })

            return false
        end

        pcall(function()
            obj.RF_ConsumeItem:InvokeServer(v23)
        end)

        lib:MakeNotify({
            Title = "Leviathan",
            Description = "Leviathan Scale dikonsumsi!",
            Color = Color3.fromRGB(123, 239, 178),
            Delay = 3,
        })

        return true
    end

    local v22 = v5:AddSection("Leviathan Hunt", false)

    local v23 = v22:AddParagraph({
        Title = "Leviathan Status",
        Content = "Nyalakan Auto Leviathan Hunt untuk memuat status.",
    })

    local function fn62()
        if tbl28.paraThread then
            task.cancel(tbl28.paraThread)
            tbl28.paraThread = nil
        end
    end

    local function fn63()
        fn62()

        tbl28.paraThread = task.spawn(function()
            while tbl28.enabled do
                local n = 2

                pcall(function()
                    if not v23 or not v23.SetContent then
                        return
                    end

                    if not Data then
                        v23:SetContent("Menunggu data...")
                        return
                    end
                    local tbl33 = {}

                    if fn53() then
                        table.insert(tbl33, fn23(true, "Forgotten Scale Quest"))

                        if fn60() then
                            table.insert(tbl33, fn23(false, "Consume Leviathan Scale"))
                        else
                            table.insert(tbl33, "<font color=\"rgb(200,200,200)\">== Leviathan Hunt ==</font>")

                            if fn56() then
                                local v24 = fn51()

                                if v24 then
                                    for i, v25 in ipairs(tbl30) do
                                        local v26 = fn57(v24, v25.index)
                                        table.insert(tbl33, fn23(v26, v25.name))
                                    end
                                else
                                    table.insert(tbl33, "Event tidak aktif")
                                end
                            else
                                table.insert(tbl33, "Farming relics @ Kohana Volcano")

                                for i, v24 in ipairs(tbl30) do
                                    local flag4 = fn55(v24.name) ~= nil
                                    table.insert(tbl33, fn23(flag4, v24.name))
                                end
                            end
                        end
                    else
                        table.insert(tbl33, "<font color=\"rgb(200,200,200)\">== Forgotten Scale Quest ==</font>")
                        local v24 = fn52()

                        if v24 then
                            for i, v25 in ipairs(tbl32) do
                                local v26, v27 = fn54(v24, i)
                                local flag4 = v27 <= v26
                                local insert = table.insert
                                local str2 = flag4 and "DONE" or string.format("%d/%d", v26, v27)
                                insert(tbl33, fn23(flag4, v25, str2))
                            end
                        else
                            table.insert(tbl33, "Quest belum dimulai (talk to Archaeologist)")
                        end
                    end

                    v23:SetContent(table.concat(tbl33, "\n"))

                    if fn53() and not fn60() and fn56() then
                        local v24 = fn51()

                        if v24 then
                            local flag4 = true

                            for i, v25 in ipairs(tbl30) do
                                if not fn57(v24, v25.index) then
                                    flag4 = false
                                    break
                                end
                            end

                            if flag4 then
                                n = 120
                            end
                        else
                            n = 45
                        end
                    end
                end)

                task.wait(n)
            end

            tbl28.paraThread = nil
        end)
    end

    v22:AddToggle({
        Title = "Auto Leviathan Hunt",
        Default = false,
        NoSave = true,
        Callback = function(enabled)
            tbl28.enabled = enabled

            if enabled then
                if tbl28.thread then
                    task.cancel(tbl28.thread)
                    tbl28.thread = nil
                end

                fn63()

                tbl28.thread = task.spawn(function()
                    while tbl28.enabled do
                        pcall(function()
                            if not Data then
                                task.wait(3)
                                return
                            end

                            if not fn53() then
                                local v24 = fn52()

                                if not v24 then
                                    fn58(cframe2)
                                    task.wait(1.5)
                                    fn59()
                                    task.wait(3)
                                    return
                                end

                                local v25, v26 = fn54(v24, 1)
                                local v27, v28 = fn54(v24, 2)
                                local v29, v30 = fn54(v24, 3)
                                local v31, v32 = fn54(v24, 4)

                                if v25 < v26 or v27 < v28 or v29 < v30 or v31 < v32 then
                                    fn58(cframe3)
                                end

                                return
                            end

                            if not fn60() then
                                if not fn56() then
                                    fn58(cframe3)
                                    return
                                end
                                local v24 = fn51()
                                if not v24 then
                                    task.wait(3)
                                    return
                                end

                                local ok, result = pcall(function()
                                    return v24:GetExpect("Lobby")
                                end)

                                if not result then
                                    task.wait(3)
                                    return
                                end
                                local flag4 = true

                                for i, v25 in ipairs(tbl30) do
                                    if not fn57(v24, v25.index) then
                                        flag4 = false
                                        break
                                    end
                                end

                                if not flag4 then
                                    for i, v25 in ipairs(tbl30) do
                                        if not tbl28.enabled then
                                            break
                                        end

                                        if not fn57(v24, v25.index) then
                                            local v26 = fn55(v25.name)

                                            if v26 then
                                                fn58(tbl29[v25.index])
                                                task.wait(1)

                                                pcall(function()
                                                    obj.RE_PlaceLeviathanPressureItem:FireServer(v26, v25.index)
                                                end)

                                                task.wait(1)
                                            else
                                                lib:MakeNotify({
                                                    Title = "Leviathan",
                                                    Description = v25.name .. " tidak ada!",
                                                    Color = Color3.fromRGB(255, 179, 71),
                                                    Delay = 3,
                                                })
                                            end
                                        end
                                    end

                                    return
                                end

                                lib:MakeNotify({
                                    Title = "Leviathan",
                                    Description = "Semua relic terpasang! Leviathan Hunt dimulai!",
                                    Color = Color3.fromRGB(123, 239, 178),
                                    Delay = 3,
                                })

                                tbl28.enabled = false
                                fn62()

                                pcall(function()
                                    v23:SetContent("Semua relic terpasang — Leviathan Hunt dimulai.")
                                end)

                                return
                            end

                            fn58(cframe2)
                            task.wait(1.5)
                            fn61()
                            task.wait(3)
                        end)

                        task.wait(2)
                    end
                end)
            else
                if tbl28.thread then
                    task.cancel(tbl28.thread)
                    tbl28.thread = nil
                end

                fn62()

                pcall(function()
                    v23:SetContent("Nyalakan Auto Leviathan Hunt untuk memuat status.")
                end)
            end
        end,
    })

    v22:AddButton({
        Title = "TP: Archaeologist NPC",
        Callback = function()
            fn58(cframe2)
        end,
    })

    v22:AddButton({
        Title = "TP: Kohana Volcano (Farming)",
        Callback = function()
            fn58(cframe3)
        end,
    })

    v22:AddButton({
        Title = "TP: Plate 1 (Sunken Eye)",
        Callback = function()
            fn58(tbl29[1])
        end,
    })

    v22:AddButton({
        Title = "TP: Plate 2 (Blacktide)",
        Callback = function()
            fn58(tbl29[2])
        end,
    })

    v22:AddButton({
        Title = "TP: Plate 3 (Burntflame)",
        Callback = function()
            fn58(tbl29[3])
        end,
    })

    v22:AddButton({
        Title = "Manual: Talk to Archaeologist",
        Callback = function()
            fn58(cframe2)
            task.wait(1.5)
            fn59()
        end,
    })

    v22:AddButton({
        Title = "Manual: Consume Leviathan Scale",
        Callback = function()
            fn61()
        end,
    })
end

local v5 = v3:AddTab({Name = "Settings", Icon = "settings"})
local Protection = v5:AddSection("Protection")
local tbl4 = {enabled = false, conns = {}, task = nil}
local tbl5 = {enabled = false, task = nil}

local tbl6 = {
    [2] = true,
    [3] = true,
    [4] = true,
    [30] = true,
    [35] = true,
    [55] = true,
    [75] = true,
    [76] = true,
    [79] = true,
    [100] = true,
    [145] = true,
    [250] = true,
    [252] = true,
    [254] = true,
    [255] = true,
}

local tbl7 = {
    [2] = "Trial Moderator",
    [3] = "Moderator",
    [4] = "Senior Moderator",
    [30] = "Trial Administrator",
    [35] = "Administrator",
    [55] = "Senior Administrator",
    [75] = "Trial Manager",
    [76] = "Manager",
    [79] = "Senior Manager",
    [100] = "Director",
    [145] = "Trial Developer",
    [250] = "Developer",
    [252] = "Senior Developer",
    [254] = "Co-Owner",
    [255] = "Owner",
}

local tbl8 = {
    [2] = "Junior Staff",
    [3] = "Staff",
    [4] = "Senior Staff",
    [5] = "Admin",
}

Protection:AddToggle({
    Title = "Stay Active (Anti-AFK)",
    Default = true,
    Callback = function(arg)
        if arg then
            if tbl4.enabled then
                return
            end
            tbl4.enabled = true

            if type(getconnections) == "function" then
                pcall(function()
                    for i, v6 in ipairs(getconnections(localPlayer.Idled)) do
                        if v6 and v6.Disable then
                            pcall(v6.Disable, v6)
                            table.insert(tbl4.conns, v6)
                        end
                    end
                end)
            end
        else
            tbl4.enabled = false

            pcall(function()
                for i, conn in ipairs(tbl4.conns) do
                    if conn and conn.Enable then
                        pcall(conn.Enable, conn)
                    end
                end

                tbl4.conns = {}
            end)
        end
    end,
}):SetValue(true)

Protection:AddToggle({
    Title = "Anti Staff (Auto Kick)",
    Default = false,
    Callback = function(enabled)
        tbl5.enabled = enabled

        if enabled then
            if tbl5.task then
                return
            end

            tbl5.task = task.spawn(function()
                local UserPriority = nil

                pcall(function()
                    UserPriority = require(game:GetService("ReplicatedStorage").Shared.UserPriority)
                end)

                while tbl5.enabled do
                    for i, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer then
                            local flag4 = false
                            local str2 = ""
                            local str3 = ""
                            local n = 0

                            pcall(function()
                                n = player:GetRankInGroup(35102746)
                            end)

                            if tbl6[n] then
                                flag4 = true
                                str2 = "Group Rank"
                                local v6 = tbl7[n]
                                local str4 = v6 or "Rank " .. n
                                str3 = str4
                            end

                            if not flag4 and UserPriority then
                                local n2 = 0

                                pcall(function()
                                    n2 = UserPriority:GetPriorityLevel(player)
                                end)

                                if n2 >= 2 then
                                    flag4 = true
                                    str2 = "Priority Level"
                                    local v6 = tbl8[n2]
                                    local str4 = v6 or "Priority " .. n2
                                    str3 = str4
                                end
                            end

                            if not flag4 then
                                continue
                            end
                            local str4 = string.format("Staff Detected!\nNama: %s\nRole: %s\nDeteksi: %s\nAuto Kicked for Safety.", player.Name, str3, str2)
                            localPlayer:Kick(str4)
                            return
                        end

                        continue
                    end

                    task.wait(1)
                end
            end)
        elseif tbl5.task then
            task.cancel(tbl5.task)
            tbl5.task = nil
        end
    end,
})

local Camera = v5:AddSection("Camera")
local currentCamera = workspace.CurrentCamera

Camera:AddParagraph({
    Title = "Freecam",
    Content = "Gerakkan kamera bebas tanpa batas.\n• PC: Toggle via UI atau tekan [F3]\n• Gerak: WASD, E/Space = naik, Q/Shift = turun\n• Mobile: Jari kiri = gerak, jari kanan = rotasi",
})

local ContextActionService = game:GetService("ContextActionService")

local function fn6()
    ContextActionService:BindActionAtPriority("FreecamBlockMovement", function()
        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
end

local function fn7()
    ContextActionService:UnbindAction("FreecamBlockMovement")
end

local v6 = Camera:AddToggle({
    Title = "Freecam",
    Default = false,
    NoSave = true,
    Callback = function(enabled)
        if not _G._Freecam then
            local v6 = _G

            local freecam = {
                enabled = false,
                camPos = Vector3.new(),
                camRot = Vector3.new(),
                speed = 50,
                sensitivity = 0.3,
                hiddenGuis = {},
                renderConn = nil,
                inputBegan = nil,
                inputChanged = nil,
                inputEnded = nil,
                freezeThread = nil,
                charConn = nil,
                character = nil,
                humanoid = nil,
                frozenCFrame = nil,
            }

            local touchEnabled = UserInputService.TouchEnabled
            local isMobile = touchEnabled

            if touchEnabled then
                if UserInputService.KeyboardEnabled then
                    isMobile = false
                else
                    isMobile = true
                end
            end

            freecam.isMobile = isMobile
            freecam.joystickInput = Vector3.new()
            freecam.cameraTouch = nil
            freecam.cameraTouchStart = nil
            freecam.joystickTouch = nil
            freecam.joystickOrigin = nil
            v6._Freecam = freecam
            local freecam2 = _G._Freecam
            local character = localPlayer.Character
            local character2 = character or localPlayer.CharacterAdded:Wait()
            freecam2.character = character2
            freecam2.humanoid = freecam2.character:WaitForChild("Humanoid")

            freecam2.charConn = localPlayer.CharacterAdded:Connect(function(character3)
                freecam2.character = character3
                freecam2.humanoid = character3:WaitForChild("Humanoid")
            end)
        end

        local freecam = _G._Freecam

        local function fn8()
            local character = freecam.character
            if not character then
                return
            end
            local core = character:FindFirstChild("Core")

            if core then
                local bootstrapper = core:FindFirstChild("BOOTSTRAPPER")

                if bootstrapper then
                    bootstrapper.Disabled = true
                end
            end

            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                freecam.frozenCFrame = humanoidRootPart.CFrame
                humanoidRootPart.Anchored = true
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end

            local humanoid = freecam.humanoid

            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                humanoid.AutoRotate = false
            end
        end

        local function fn9()
            local character = freecam.character
            if not character then
                return
            end
            local core = character:FindFirstChild("Core")

            if core then
                local bootstrapper = core:FindFirstChild("BOOTSTRAPPER")

                if bootstrapper then
                    bootstrapper.Disabled = false
                end
            end

            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                humanoidRootPart.Anchored = false
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end

            local humanoid = freecam.humanoid

            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                humanoid.AutoRotate = true
            end
        end

        freecam.enabled = enabled

        if enabled then
            local cFrame = currentCamera.CFrame
            freecam.camPos = cFrame.Position
            local v6, v7, v8 = cFrame:ToEulerAnglesYXZ()
            freecam.camRot = Vector3.new(v6, v7, v8)
            fn8()
            fn6()

            freecam.freezeThread = task.spawn(function()
                while freecam.enabled do
                    local character = freecam.character
                    local humanoidRootPart = character and freecam.character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart and freecam.frozenCFrame then
                        humanoidRootPart.CFrame = freecam.frozenCFrame
                        humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    end

                    task.wait(0.03)
                end
            end)

            freecam.hiddenGuis = {}

            for k, child in pairs(localPlayer.PlayerGui:GetChildren()) do
                if child.Name ~= "LynxPanelMonitor" and child:IsA("ScreenGui") and child.Enabled then
                    table.insert(freecam.hiddenGuis, child)
                    child.Enabled = false
                end
            end

            currentCamera.CameraType = Enum.CameraType.Scriptable
            task.wait()

            if freecam.isMobile then
                local x = currentCamera.ViewportSize.X

                freecam.inputBegan = UserInputService.InputBegan:Connect(function(input)
                    if not freecam.enabled then
                        return
                    end

                    if input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    local position = input.Position

                    if position.X < x / 2 then
                        if not freecam.joystickTouch then
                            freecam.joystickTouch = input
                            freecam.joystickOrigin = Vector2.new(position.X, position.Y)
                            freecam.joystickInput = Vector3.new()
                        end
                    elseif not freecam.cameraTouch then
                        freecam.cameraTouch = input
                        freecam.cameraTouchStart = Vector2.new(position.X, position.Y)
                    end
                end)

                freecam.inputChanged = UserInputService.InputChanged:Connect(function(input)
                    if not freecam.enabled then
                        return
                    end

                    if input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    local position = input.Position

                    if input == freecam.joystickTouch and freecam.joystickOrigin then
                        local n = position.X - freecam.joystickOrigin.X
                        local n2 = position.Y - freecam.joystickOrigin.Y
                        local v9 = math.sqrt(n * n + n2 * n2)

                        if v9 < 10 then
                            freecam.joystickInput = Vector3.new()
                        else
                            local n3 = math.min(v9, 80)
                            freecam.joystickInput = Vector3.new(n / v9 * (n3 / 80), 0, n2 / v9 * (n3 / 80))
                        end
                    elseif input == freecam.cameraTouch and freecam.cameraTouchStart then
                        local vector2 = Vector2.new(position.X, position.Y)
                        local n = vector2 - freecam.cameraTouchStart
                        freecam.camRot = Vector3.new(math.clamp(freecam.camRot.X - n.Y * freecam.sensitivity * 0.005, -math.pi / 2 + 0.05, math.pi / 2 - 0.05), freecam.camRot.Y - n.X * freecam.sensitivity * 0.005, 0)
                        freecam.cameraTouchStart = vector2
                    end
                end)

                freecam.inputEnded = UserInputService.InputEnded:Connect(function(input)
                    if not freecam.enabled then
                        return
                    end

                    if input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    if input == freecam.joystickTouch then
                        freecam.joystickTouch = nil
                        freecam.joystickOrigin = nil
                        freecam.joystickInput = Vector3.new()
                    end

                    if input == freecam.cameraTouch then
                        freecam.cameraTouch = nil
                        freecam.cameraTouchStart = nil
                    end
                end)
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                UserInputService.MouseIconEnabled = false
            end

            freecam.renderConn = RunService.RenderStepped:Connect((function(t, V, U)
                return function(L)
                    if not t.enabled then
                        return
                    end

                    if not t.isMobile then
                        local Z = V:GetMouseDelta()

                        if Z.Magnitude > 0 then
                            t.camRot = Vector3.new(math.clamp(t.camRot.X - Z.Y * t.sensitivity * 0.01, -math.pi / 2 + 0.05, math.pi / 2 - 0.05), t.camRot.Y - Z.X * t.sensitivity * 0.01, 0)
                        end

                        local Z = Vector3.zero

                        if V:IsKeyDown(Enum.KeyCode.W) then
                            Z = Z + Vector3.new(0, 0, 1)
                        end

                        if V:IsKeyDown(Enum.KeyCode.S) then
                            Z = Z + Vector3.new(0, 0, -1)
                        end

                        if V:IsKeyDown(Enum.KeyCode.A) then
                            Z = Z + Vector3.new(-1, 0, 0)
                        end

                        if V:IsKeyDown(Enum.KeyCode.D) then
                            Z = Z + Vector3.new(1, 0, 0)
                        end

                        if V:IsKeyDown(Enum.KeyCode.Space) or V:IsKeyDown(Enum.KeyCode.E) then
                            Z = Z + Vector3.new(0, 1, 0)
                        end

                        if V:IsKeyDown(Enum.KeyCode.LeftShift) or V:IsKeyDown(Enum.KeyCode.Q) then
                            Z = Z + Vector3.new(0, -1, 0)
                        end

                        if Z.Magnitude > 0 then
                            Z = Z.Unit
                            local V = CFrame.new(t.camPos) * CFrame.fromEulerAnglesYXZ(t.camRot.X, t.camRot.Y, t.camRot.Z)
                            local z = V.LookVector * Z.Z + V.RightVector * Z.X + V.UpVector * Z.Y
                            t.camPos = t.camPos + z * t.speed * L
                        end
                    else
                        local V = t.joystickInput

                        if V.Magnitude > 0 then
                            local Z = CFrame.new(t.camPos) * CFrame.fromEulerAnglesYXZ(t.camRot.X, t.camRot.Y, t.camRot.Z)
                            local z = Z.LookVector * V.Z + Z.RightVector * V.X
                            t.camPos = t.camPos + z * t.speed * L
                        end
                    end

                    U.CFrame = CFrame.new(t.camPos) * CFrame.fromEulerAnglesYXZ(t.camRot.X, t.camRot.Y, t.camRot.Z)
                end
            end)(freecam, UserInputService, currentCamera))
        else
            if freecam.renderConn then
                freecam.renderConn:Disconnect()
                freecam.renderConn = nil
            end

            if freecam.inputBegan then
                freecam.inputBegan:Disconnect()
                freecam.inputBegan = nil
            end

            if freecam.inputChanged then
                freecam.inputChanged:Disconnect()
                freecam.inputChanged = nil
            end

            if freecam.inputEnded then
                freecam.inputEnded:Disconnect()
                freecam.inputEnded = nil
            end

            if freecam.freezeThread then
                task.cancel(freecam.freezeThread)
                freecam.freezeThread = nil
            end

            fn7()
            fn9()

            if freecam.frozenCFrame then
                local character = freecam.character
                local humanoidRootPart = character and freecam.character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    humanoidRootPart.CFrame = freecam.frozenCFrame
                end

                freecam.frozenCFrame = nil
            end

            for k, hiddenGui in pairs(freecam.hiddenGuis) do
                if hiddenGui and hiddenGui:IsA("ScreenGui") and (not _hideGui or not _hideGui.enabled or hiddenGui.Name == "LynxPanelMonitor") then
                    hiddenGui.Enabled = true
                end
            end

            freecam.hiddenGuis = {}
            currentCamera.CameraType = Enum.CameraType.Custom
            currentCamera.CameraSubject = freecam.humanoid
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            freecam.cameraTouch = nil
            freecam.cameraTouchStart = nil
            freecam.joystickTouch = nil
            freecam.joystickOrigin = nil
            freecam.joystickInput = Vector3.new()
        end
    end,
})

if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.F3 then
            local setValue = v6.SetValue
            local freecam = _G._Freecam
            local enabled = freecam and _G._Freecam.enabled
            local flag4

            if enabled then
                flag4 = false
            else
                flag4 = true
            end

            setValue(v6, flag4)
        end
    end)
end

Camera:AddInput({
    Title = "Freecam Speed",
    Default = "50",
    Callback = function(arg)
        local num = tonumber(arg)

        if num then
            if not _G._Freecam then
                _G._Freecam = {}
            end

            _G._Freecam.speed = math.max(1, num)
        end
    end,
})

Camera:AddInput({
    Title = "Freecam Sensitivity",
    Default = "0.3",
    Callback = function(arg)
        local num = tonumber(arg)

        if num then
            if not _G._Freecam then
                _G._Freecam = {}
            end

            _G._Freecam.sensitivity = math.clamp(num, 0.01, 5)
        end
    end,
})

local tbl9 = {
    originalMin = localPlayer.CameraMinZoomDistance,
    originalMax = localPlayer.CameraMaxZoomDistance,
}

Camera:AddToggle({
    Title = "Unlimited Zoom",
    Default = false,
    Callback = function(arg)
        if arg then
            localPlayer.CameraMinZoomDistance = 0.5
            localPlayer.CameraMaxZoomDistance = 9999
        else
            localPlayer.CameraMinZoomDistance = tbl9.originalMin
            localPlayer.CameraMaxZoomDistance = tbl9.originalMax
        end
    end,
})

local v7 = v5:AddSection("Player Features")

local function fn8()
    return localPlayer.Character
end

local function fn9()
    local v8 = fn8()
    local humanoid = v8 and v8:FindFirstChildOfClass("Humanoid")
    return humanoid
end

local function fn10()
    local v8 = fn8()
    local humanoidRootPart = v8 and v8:FindFirstChild("HumanoidRootPart")
    return humanoidRootPart
end

local tbl10 = {enabled = false, value = 50, conn = nil, charConn = nil}

v7:AddToggle({
    Title = "Enable Sprint",
    Default = false,
    Callback = function(enabled)
        tbl10.enabled = enabled

        if tbl10.conn then
            tbl10.conn:Disconnect()
            tbl10.conn = nil
        end

        if tbl10.charConn then
            tbl10.charConn:Disconnect()
            tbl10.charConn = nil
        end

        if not enabled then
            local v8 = fn9()

            if v8 then
                v8.WalkSpeed = 16
            end

            return
        end

        local v8 = fn9()

        if v8 then
            v8.WalkSpeed = tbl10.value
        end

        local n = 0

        tbl10.conn = RunService.Heartbeat:Connect((function(t, U)
            return function(L)
                if not t.enabled then
                    return
                end
                n = n + L
                if n < 0.25 then
                    return
                end
                n = 0
                local L = U()

                if L and L.WalkSpeed ~= t.value then
                    L.WalkSpeed = t.value
                end
            end
        end)(tbl10, fn9))

        tbl10.charConn = localPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if not tbl10.enabled then
                return
            end
            local v9 = fn9()

            if v9 then
                v9.WalkSpeed = tbl10.value
            end
        end)
    end,
})

v7:AddInput({
    Title = "Sprint Speed",
    Default = "50",
    Callback = function(arg)
        local value = tonumber(arg)
        if not value then
            return
        end
        tbl10.value = value

        if tbl10.enabled then
            local v8 = fn9()

            if v8 then
                v8.WalkSpeed = value
            end
        end
    end,
})

local tbl11 = {enabled = false, conn = nil}

v7:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(enabled)
        tbl11.enabled = enabled

        if tbl11.conn then
            tbl11.conn:Disconnect()
            tbl11.conn = nil
        end

        if not enabled then
            return
        end

        tbl11.conn = UserInputService.JumpRequest:Connect(function()
            if not tbl11.enabled then
                return
            end
            local v8 = fn9()

            if v8 then
                v8:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end,
})

local tbl12 = {flying = false, speed = 50}
local touchEnabled = UserInputService.TouchEnabled
local isMobile = touchEnabled

if touchEnabled then
    if UserInputService.KeyboardEnabled then
        isMobile = false
    else
        isMobile = true
    end
end

tbl12.isMobile = isMobile
tbl12.keyDown = nil
tbl12.keyUp = nil
tbl12.loop = nil
tbl12.bg = nil
tbl12.bv = nil

local function fn11()
    tbl12.flying = false

    if tbl12.keyDown then
        tbl12.keyDown:Disconnect()
        tbl12.keyDown = nil
    end

    if tbl12.keyUp then
        tbl12.keyUp:Disconnect()
        tbl12.keyUp = nil
    end

    if tbl12.loop then
        tbl12.loop:Disconnect()
        tbl12.loop = nil
    end

    if tbl12.bg then
        tbl12.bg:Destroy()
        tbl12.bg = nil
    end

    if tbl12.bv then
        tbl12.bv:Destroy()
        tbl12.bv = nil
    end

    local v8 = fn9()

    if v8 then
        v8.PlatformStand = false
    end
end

v7:AddToggle({
    Title = "Enable Fly",
    Default = false,
    NoSave = true,
    Callback = function(arg)
        if not arg then
            fn11()
            return
        end
        local v8 = fn8()
        local v9 = fn9()
        local v10 = fn10()

        if v8 and v9 and v10 then
            tbl12.flying = true
            v9.PlatformStand = true
            tbl12.bg = Instance.new("BodyGyro")
            tbl12.bg.P = 90000
            tbl12.bg.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
            tbl12.bg.CFrame = v10.CFrame
            tbl12.bg.Parent = v10
            tbl12.bv = Instance.new("BodyVelocity")
            tbl12.bv.Velocity = Vector3.zero
            tbl12.bv.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
            tbl12.bv.Parent = v10

            if tbl12.isMobile then
                local ok, result = pcall(function()
                    return require(localPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
                end)

                tbl12.loop = RunService.RenderStepped:Connect((function(t, Z, z, U, V)
                    return function()
                        if not t.flying or not t.bv or not t.bv.Parent then
                            return
                        end
                        local L = Z()
                        local Z = z()
                        if not L or not Z then
                            return
                        end
                        local L = workspace.CurrentCamera
                        local z = Vector3.zero
                        t.bg.CFrame = L.CFrame

                        if U and V then
                            local U = V:GetMoveVector()

                            if U.Magnitude > 0 then
                                local V = Vector3.new(L.CFrame.LookVector.X, 0, L.CFrame.LookVector.Z).Unit
                                local g = Vector3.new(L.CFrame.RightVector.X, 0, L.CFrame.RightVector.Z).Unit
                                z = z - V * U.Z
                                z = z + g * U.X
                            end
                        else
                            local V = Z.MoveDirection

                            if V.Magnitude > 0 then
                                local U = Vector3.new(L.CFrame.LookVector.X, 0, L.CFrame.LookVector.Z).Unit
                                local Z = Vector3.new(L.CFrame.RightVector.X, 0, L.CFrame.RightVector.Z).Unit
                                z = z + U * (-V.Z)
                                z = z + Z * V.X
                            end
                        end

                        t.bv.Velocity = (z.Magnitude > 0 and {z.Unit * t.speed} or {Vector3.zero})[1]
                    end
                end)(tbl12, fn8, fn9, ok, result))
            else
                local tbl13 = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}

                tbl12.keyDown = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.W then
                        tbl13.F = 1
                    elseif input.KeyCode == Enum.KeyCode.S then
                        tbl13.B = 1
                    elseif input.KeyCode == Enum.KeyCode.A then
                        tbl13.L = 1
                    elseif input.KeyCode == Enum.KeyCode.D then
                        tbl13.R = 1
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        tbl13.U = 1
                    elseif input.KeyCode == Enum.KeyCode.E then
                        tbl13.U = 1
                    elseif input.KeyCode == Enum.KeyCode.Q then
                        tbl13.D = 1
                    elseif input.KeyCode == Enum.KeyCode.LeftControl then
                        tbl13.D = 1
                    end
                end)

                tbl12.keyUp = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if gameProcessed then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.W then
                        tbl13.F = 0
                    elseif input.KeyCode == Enum.KeyCode.S then
                        tbl13.B = 0
                    elseif input.KeyCode == Enum.KeyCode.A then
                        tbl13.L = 0
                    elseif input.KeyCode == Enum.KeyCode.D then
                        tbl13.R = 0
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        tbl13.U = 0
                    elseif input.KeyCode == Enum.KeyCode.E then
                        tbl13.U = 0
                    elseif input.KeyCode == Enum.KeyCode.Q then
                        tbl13.D = 0
                    elseif input.KeyCode == Enum.KeyCode.LeftControl then
                        tbl13.D = 0
                    end
                end)

                tbl12.loop = RunService.Heartbeat:Connect((function(V, t)
                    return function()
                        if not V.flying or not V.bv or not V.bv.Parent then
                            return
                        end
                        local L = workspace.CurrentCamera
                        local U = Vector3.zero
                        U = U + L.CFrame.LookVector * (t.F - t.B)
                        U = U + L.CFrame.RightVector * (t.R - t.L)
                        U = U + Vector3.new(0, 1, 0) * (t.U - t.D)
                        V.bv.Velocity = (U.Magnitude > 0 and {U.Unit * V.speed} or {Vector3.zero})[1]
                        V.bg.CFrame = L.CFrame
                    end
                end)(tbl12, tbl13))
            end

            return
        end

        warn("[Fly] Character not ready")
    end,
})

v7:AddInput({
    Title = "Fly Speed",
    Default = "50",
    NoSave = true,
    Callback = function(arg)
        local clamp = math.clamp
        local num = tonumber(arg)
        local n = num or 50
        tbl12.speed = clamp(n, 1, 500)
    end,
})

local tbl13 = {enabled = false, conn = nil, charConn = nil}

local function fn12()
    tbl13.enabled = false

    if tbl13.conn then
        tbl13.conn:Disconnect()
        tbl13.conn = nil
    end

    if tbl13.charConn then
        tbl13.charConn:Disconnect()
        tbl13.charConn = nil
    end

    local v8 = fn8()

    if v8 then
        for i, descendant in ipairs(v8:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = true
            end
        end
    end
end

local function fn13()
    if tbl13.conn then
        tbl13.conn:Disconnect()
        tbl13.conn = nil
    end

    tbl13.conn = RunService.Stepped:Connect((function(V, t)
        return function()
            if not V.enabled then
                return
            end
            local L = t()
            if not L then
                return
            end

            for t, t in ipairs(L:GetDescendants()) do
                if t:IsA("BasePart") then
                    t.CanCollide = false
                end
            end
        end
    end)(tbl13, fn8))
end

v7:AddToggle({
    Title = "No Clip",
    Default = false,
    NoSave = true,
    Callback = function(arg)
        if tbl13.charConn then
            tbl13.charConn:Disconnect()
            tbl13.charConn = nil
        end

        if not arg then
            fn12()
            return
        end
        tbl13.enabled = true
        fn13()

        tbl13.charConn = localPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if not tbl13.enabled then
                return
            end
            fn13()
        end)
    end,
})

local tbl14 = {conns = {}, guards = {}}
local CollectionService = game:GetService("CollectionService")

local function fn14(arg)
    if not arg:IsA("BasePart") or tbl14.guards[arg] then
        return
    end
    arg.CanTouch = false

    tbl14.guards[arg] = arg:GetPropertyChangedSignal("CanTouch"):Connect(function()
        if arg.CanTouch then
            arg.CanTouch = false
        end
    end)
end

local function fn15(arg)
    local v8 = tbl14.guards[arg]

    if v8 then
        v8:Disconnect()
        tbl14.guards[arg] = nil
    end
end

v7:AddToggle({
    Title = "Anti Lava Kill",
    Default = true,
    NoSave = true,
    Callback = function(arg)
        for i, conn in ipairs(tbl14.conns) do
            conn:Disconnect()
        end

        table.clear(tbl14.conns)

        for k, guard in pairs(tbl14.guards) do
            guard:Disconnect()
            k.CanTouch = true
        end

        table.clear(tbl14.guards)

        if not arg then
            lib:MakeNotify({
                Title = "Anti Lava Kill",
                Description = "Disabled.",
                Delay = 2,
            })

            return
        end

        table.insert(tbl14.conns, CollectionService:GetInstanceAddedSignal("KillBrick"):Connect(fn14))
        table.insert(tbl14.conns, CollectionService:GetInstanceRemovedSignal("KillBrick"):Connect(fn15))

        for i, v8 in ipairs(CollectionService:GetTagged("KillBrick")) do
            fn14(v8)
        end

        lib:MakeNotify({
            Title = "Anti Lava Kill",
            Description = "Active!",
            Delay = 2,
        })
    end,
}):SetValue(true)

local Performance = v5:AddSection("Performance")
local terrain = workspace:FindFirstChildOfClass("Terrain")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local smoothNoOutlines = Enum.SurfaceType.SmoothNoOutlines
local smoothPlastic = Enum.Material.SmoothPlastic
local legacy = Enum.Technology.Legacy
local level01 = Enum.QualityLevel.Level01
local level012 = Enum.MeshPartDetailLevel.Level01
local automatic = Enum.QualityLevel.Automatic
local distanceBased = Enum.MeshPartDetailLevel.DistanceBased
local automatic2 = Enum.SavedQualitySetting.Automatic
local qualityLevel1 = Enum.SavedQualitySetting.QualityLevel1
local noReverb = Enum.ReverbType.NoReverb
local camera = Enum.ListenerType.Camera
local color = Color3.new(1, 1, 1)

local tbl15 = {
    "TopSurface",
    "BottomSurface",
    "LeftSurface",
    "RightSurface",
    "FrontSurface",
    "BackSurface",
}

local tbl16 = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    ForceField = true,
    Explosion = true,
    BloomEffect = true,
    BlurEffect = true,
    ColorCorrectionEffect = true,
    SunRaysEffect = true,
    DepthOfFieldEffect = true,
    Atmosphere = true,
    Decal = true,
    Texture = true,
    SurfaceAppearance = true,
    SpecialMesh = true,
    BlockMesh = true,
    CylinderMesh = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true,
    Accessory = true,
    Hat = true,
    Shirt = true,
    Pants = true,
    ShirtGraphic = true,
    CharacterMesh = true,
    BodyColors = true,
    Clothing = true,
    HumanoidDescription = true,
}

local tbl17 = {
    enabled = false,
    connections = {},
    processedObjects = setmetatable({}, {__mode = "k"}),
    origStates = {lighting = {}, water = {}, camera = {}},
}

local function fn16(arg)
    if tbl17.processedObjects[arg] then
        return
    end
    tbl17.processedObjects[arg] = true

    if not tbl16[arg.ClassName] then
        if arg:IsA("BasePart") then
            arg.Material = smoothPlastic
            arg.CastShadow = false
            arg.Reflectance = 0

            for i = 1, 6 do
                arg[tbl15[i]] = smoothNoOutlines
            end
        end

        return
    end

    arg:Destroy()
end

local function fn17(arg)
    if not arg or tbl17.processedObjects[arg] then
        return
    end
    tbl17.processedObjects[arg] = true

    pcall(function()
        local descendants = arg:GetDescendants()
        local n = 0
        local n2 = #descendants + 0

        while true do
            local n3 = n + 1
            if n3 > n2 then
                break
            end
            n = n3
            local v8 = descendants[n3]

            if tbl16[v8.ClassName] then
                v8:Destroy()
            elseif v8:IsA("BasePart") then
                if v8.Name == "Head" then
                    v8.Transparency = 1
                end

                v8.Material = smoothPlastic
                v8.CastShadow = false
                v8.Reflectance = 0
                local canCollide = v8.Name == "HumanoidRootPart" or v8.Name == "Head"
                v8.CanCollide = canCollide

                for i = 1, 6 do
                    v8[tbl15[i]] = smoothNoOutlines
                end

                n = n3
            elseif v8:IsA("Humanoid") then
                local playingAnimationTracks = v8:GetPlayingAnimationTracks()

                for i = 1, #playingAnimationTracks do
                    playingAnimationTracks[i]:Stop(0)
                end

                n = n3
                v8.HealthDisplayDistance = 0
                v8.NameDisplayDistance = 0
            end
        end
    end)
end

local function fn18()
    local connections = tbl17.connections

    for i = 1, #connections do
        pcall(connections[i].Disconnect, connections[i])
    end

    tbl17.connections = {}
    tbl17.processedObjects = setmetatable({}, {__mode = "k"})
end

local function fn19()
    if terrain then
        pcall(function()
            tbl17.origStates.water = {
                WaterReflectance = terrain.WaterReflectance,
                WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed,
                WaterTransparency = terrain.WaterTransparency,
            }

            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
            terrain.Decoration = false
        end)

        local clouds = terrain:FindFirstChildOfClass("Clouds")

        if clouds then
            clouds:Destroy()
        end
    end

    pcall(function()
        tbl17.origStates.lighting = {
            GlobalShadows = Lighting.GlobalShadows,
            Brightness = Lighting.Brightness,
            Technology = Lighting.Technology,
        }

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9000000000
        Lighting.Technology = legacy
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0

        if not _brightState.enabled then
            Lighting.Brightness = 0
            Lighting.OutdoorAmbient = color
            Lighting.Ambient = color
        end
    end)

    local children = Lighting:GetChildren()

    for i = 1, #children do
        local v8 = children[i]

        if not v8:IsA("PostEffect") and not v8:IsA("Atmosphere") then
            if v8:IsA("Sky") then
                pcall(function()
                    v8.StarCount = 0
                    v8.SunAngularSize = 0
                    v8.MoonAngularSize = 0
                    v8.CelestialBodiesShown = false
                    v8.SkyboxBk = ""
                    v8.SkyboxDn = ""
                    v8.SkyboxFt = ""
                    v8.SkyboxLf = ""
                    v8.SkyboxRt = ""
                    v8.SkyboxUp = ""
                end)
            end
        else
            pcall(v8.Destroy, v8)
        end
    end

    pcall(function()
        SoundService.AmbientReverb = noReverb
        SoundService:SetListener(camera)
    end)

    pcall(function()
        local rendering = settings().Rendering
        rendering.QualityLevel = level01
        rendering.MeshPartDetailLevel = level012
        rendering.EditQualityLevel = level01
    end)

    pcall(function()
        local UserGameSettings = UserSettings():GetService("UserGameSettings")
        UserGameSettings.SavedQualityLevel = qualityLevel1
        UserGameSettings.GraphicsQualityLevel = 1
    end)

    pcall(function()
        local currentCamera2 = workspace.CurrentCamera

        if currentCamera2 then
            tbl17.origStates.camera = {FieldOfView = currentCamera2.FieldOfView}
            currentCamera2.FieldOfView = 70
        end
    end)

    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    end)
end

local function fn20()
    if terrain and tbl17.origStates.water.WaterReflectance ~= nil then
        pcall(function()
            local water = tbl17.origStates.water
            terrain.WaterReflectance = water.WaterReflectance
            terrain.WaterWaveSize = water.WaterWaveSize
            terrain.WaterWaveSpeed = water.WaterWaveSpeed
            terrain.WaterTransparency = water.WaterTransparency
            terrain.Decoration = true
        end)
    end

    pcall(function()
        local lighting = tbl17.origStates.lighting

        if lighting.GlobalShadows ~= nil then
            Lighting.GlobalShadows = lighting.GlobalShadows
            Lighting.Brightness = lighting.Brightness
            Lighting.Technology = lighting.Technology
        end
    end)

    pcall(function()
        local currentCamera2 = workspace.CurrentCamera

        if currentCamera2 and tbl17.origStates.camera.FieldOfView then
            currentCamera2.FieldOfView = tbl17.origStates.camera.FieldOfView
        end
    end)

    pcall(function()
        local rendering = settings().Rendering
        rendering.QualityLevel = automatic
        rendering.MeshPartDetailLevel = distanceBased
    end)

    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = automatic2
    end)

    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    end)

    tbl17.origStates = {lighting = {}, water = {}, camera = {}}
end

Performance:AddToggle({
    Title = "FPS Booster (Potato Mode)",
    Default = false,
    Callback = function(enabled)
        tbl17.enabled = enabled
        fn18()

        if not enabled then
            fn20()

            lib:MakeNotify({
                Title = "FPS Booster",
                Description = "Dimatikan, grafik dikembalikan.",
                Delay = 3,
            })

            return
        end

        fn19()

        task.spawn(function()
            while tbl17.enabled do
                tbl17.processedObjects = setmetatable({}, {__mode = "k"})
                local descendants = workspace:GetDescendants()
                local n = #descendants

                for i = 1, n, 50 do
                    if not tbl17.enabled then
                        break
                    end

                    for i2 = i, math.min(i + 50 - 1, n) do
                        fn16(descendants[i2])
                    end

                    task.wait()
                end

                if not tbl17.enabled then
                    break
                end

                for i, player in ipairs(Players:GetPlayers()) do
                    if player.Character then
                        task.defer(fn17, player.Character)
                    end
                end

                local n2 = 600

                while n2 > 0 and tbl17.enabled do
                    task.wait(1)
                    n2 = n2 - 1
                end

                if tbl17.enabled then
                    pcall(fn19)
                end
            end
        end)

        tbl17.connections[#tbl17.connections + 1] = Players.PlayerAdded:Connect(function(player)
            tbl17.connections[#tbl17.connections + 1] = player.CharacterAdded:Connect(function(character)
                if not tbl17.enabled then
                    return
                end

                task.delay(0.2, function()
                    if tbl17.enabled then
                        fn17(character)
                    end
                end)
            end)

            if player.Character then
                task.defer(fn17, player.Character)
            end
        end)

        tbl17.connections[#tbl17.connections + 1] = localPlayer.CharacterAdded:Connect(function(character)
            if not tbl17.enabled then
                return
            end

            task.delay(0.2, function()
                if tbl17.enabled then
                    fn17(character)
                end
            end)
        end)

        tbl17.connections[#tbl17.connections + 1] = workspace.DescendantAdded:Connect(function(descendant)
            if not tbl17.enabled then
                return
            end
            fn16(descendant)
        end)

        lib:MakeNotify({
            Title = "FPS Booster",
            Description = "Aktif! Grafik diringankan.",
            Delay = 3,
        })
    end,
})

local tbl18 = {enabled = false, conns = {}, originalVals = nil}

Performance:AddToggle({
    Title = "Always Bright",
    Default = false,
    Callback = function(enabled)
        tbl18.enabled = enabled

        for i, conn in ipairs(tbl18.conns) do
            pcall(function()
                conn:Disconnect()
            end)
        end

        tbl18.conns = {}
        local Lighting2 = game:GetService("Lighting")

        if not enabled then
            if tbl18.originalVals then
                pcall(function()
                    local originalVals = tbl18.originalVals
                    Lighting2.ClockTime = originalVals.ClockTime
                    Lighting2.Brightness = originalVals.Brightness
                    Lighting2.GlobalShadows = originalVals.GlobalShadows
                    Lighting2.OutdoorAmbient = originalVals.OutdoorAmbient
                    Lighting2.Ambient = originalVals.Ambient
                    Lighting2.FogEnd = originalVals.FogEnd
                    Lighting2.ExposureCompensation = originalVals.ExposureCompensation
                end)

                tbl18.originalVals = nil
            end

            lib:MakeNotify({
                Title = "Always Bright",
                Description = "Dimatikan, lighting dikembalikan.",
                Delay = 2,
            })

            return
        end

        pcall(function()
            tbl18.originalVals = {
                ClockTime = Lighting2.ClockTime,
                Brightness = Lighting2.Brightness,
                GlobalShadows = Lighting2.GlobalShadows,
                OutdoorAmbient = Lighting2.OutdoorAmbient,
                Ambient = Lighting2.Ambient,
                FogEnd = Lighting2.FogEnd,
                ExposureCompensation = Lighting2.ExposureCompensation,
            }
        end)

        local function fn21()
            pcall(function()
                Lighting2.ClockTime = 14
                Lighting2.Brightness = 2
                Lighting2.GlobalShadows = false
                Lighting2.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting2.Ambient = Color3.new(1, 1, 1)
                Lighting2.FogEnd = 9000000000
                Lighting2.ExposureCompensation = 1
            end)
        end

        fn21()

        for i, v8 in ipairs({
            "ClockTime",
            "Brightness",
            "GlobalShadows",
            "OutdoorAmbient",
            "Ambient",
            "FogEnd",
            "ExposureCompensation",
        }) do
            local connection = Lighting2:GetPropertyChangedSignal(v8):Connect(function()
                if not tbl18.enabled then
                    return
                end
                fn21()
            end)

            table.insert(tbl18.conns, connection)
        end

        lib:MakeNotify({
            Title = "Always Bright",
            Description = "Aktif! Lighting selalu terang.",
            Delay = 2,
        })
    end,
})

local tbl19 = {enabled = false, charConn = nil}

Performance:AddToggle({
    Title = "Disable 3D Rendering",
    Default = false,
    Callback = function(enabled)
        tbl19.enabled = enabled

        if tbl19.charConn then
            tbl19.charConn:Disconnect()
            tbl19.charConn = nil
        end

        if not enabled then
            pcall(function()
                RunService:Set3dRenderingEnabled(true)
            end)

            lib:MakeNotify({
                Title = "Disable Rendering",
                Description = "3D Rendering dinyalakan kembali.",
                Delay = 3,
            })

            return
        end

        local ok = pcall(function()
            RunService:Set3dRenderingEnabled(false)
        end)

        if not ok then
            pcall(function()
                local currentCamera2 = workspace.CurrentCamera

                if currentCamera2 then
                    currentCamera2.CameraType = Enum.CameraType.Scriptable
                end
            end)
        end

        tbl19.charConn = localPlayer.CharacterAdded:Connect(function()
            if not tbl19.enabled then
                return
            end
            task.wait(0.3)

            local ok2 = pcall(function()
                RunService:Set3dRenderingEnabled(false)
            end)

            if not ok2 then
                pcall(function()
                    local currentCamera2 = workspace.CurrentCamera

                    if currentCamera2 then
                        currentCamera2.CameraType = Enum.CameraType.Scriptable
                    end
                end)
            end
        end)

        lib:MakeNotify({
            Title = "Disable Rendering",
            Description = "3D Rendering dinyalakan kembali.",
            Delay = 3,
        })
    end,
})

Performance:AddToggle({
    Title = "Disable Weather VFX",
    Default = false,
    Callback = function(arg)
        if not _G._WeatherVFX2 then
            _G._WeatherVFX2 = {}
        end

        local weatherVFX2 = _G._WeatherVFX2

        if weatherVFX2.conns then
            for i, conn in ipairs(weatherVFX2.conns) do
                pcall(function()
                    conn:Disconnect()
                end)
            end
        end

        weatherVFX2.conns = {}
        local tbl20 = {}

        for i, v8 in ipairs({
            "Storm",
            "Cloudy",
            "Snow",
            "Rain",
            "Fog",
            "Galaxy",
            "Sandstorm",
            "Blizzard",
        }) do
            tbl20[v8] = true
        end

        local function fn21(arg2)
            local flag4 = tbl20[arg2.Name] == true
            return flag4
        end

        local function fn22()
            for i, child in ipairs(workspace:GetChildren()) do
                if fn21(child) then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end

            local character = game:GetService("Players").LocalPlayer.Character

            if character then
                for i, child in ipairs(character:GetChildren()) do
                    if fn21(child) then
                        pcall(function()
                            child:Destroy()
                        end)
                    end
                end
            end
        end

        if arg then
            fn22()

            table.insert(weatherVFX2.conns, workspace.ChildAdded:Connect(function(child)
                if fn21(child) then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end))

            local localPlayer2 = game:GetService("Players").LocalPlayer

            local function fn23(arg2)
                table.insert(weatherVFX2.conns, arg2.ChildAdded:Connect(function(child)
                    if fn21(child) then
                        pcall(function()
                            child:Destroy()
                        end)
                    end
                end))

                fn22()
            end

            if localPlayer2.Character then
                fn23(localPlayer2.Character)
            end

            table.insert(weatherVFX2.conns, localPlayer2.CharacterAdded:Connect(function(character)
                fn23(character)
            end))
        end
    end,
})

local tbl20 = {
    enabled = false,
    savedState = {},
    backpackConn = nil,
    propConn = nil,
}

Performance:AddToggle({
    Title = "Hide All GUI",
    Default = false,
    NoSave = true,
    Callback = function(enabled)
        tbl20.enabled = enabled

        if enabled then
            pcall(function()
                tbl20.savedState = {}

                for i, child in ipairs(localPlayer.PlayerGui:GetChildren()) do
                    if child.Name ~= "LynxPanelMonitor" and (child:IsA("ScreenGui") or child:IsA("BillboardGui") or child:IsA("SurfaceGui")) then
                        tbl20.savedState[child] = child.Enabled
                        child.Enabled = false
                    end
                end
            end)

            local backpack = localPlayer.PlayerGui:FindFirstChild("Backpack")

            if backpack then
                tbl20.propConn = backpack:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if tbl20.enabled and backpack.Enabled then
                        pcall(function()
                            backpack.Enabled = false
                        end)
                    end
                end)
            end

            tbl20.backpackConn = localPlayer.PlayerGui.ChildAdded:Connect(function(child)
                if not tbl20.enabled then
                    return
                end

                if child.Name == "LynxPanelMonitor" then
                    return
                end

                pcall(function()
                    task.wait(0.05)

                    if child:IsA("ScreenGui") or child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                        child.Enabled = false
                    end
                end)
            end)

            lib:MakeNotify({
                Title = "Hide GUI",
                Description = "Semua GUI disembunyikan.",
                Delay = 2,
            })
        else
            if tbl20.propConn then
                pcall(function()
                    tbl20.propConn:Disconnect()
                end)

                tbl20.propConn = nil
            end

            if tbl20.backpackConn then
                pcall(function()
                    tbl20.backpackConn:Disconnect()
                end)

                tbl20.backpackConn = nil
            end

            pcall(function()
                for k, v8 in pairs(tbl20.savedState) do
                    pcall(function()
                        k.Enabled = v8
                    end)
                end

                tbl20.savedState = {}
            end)

            lib:MakeNotify({
                Title = "Hide GUI",
                Description = "GUI dikembalikan.",
                Delay = 2,
            })
        end
    end,
})

local tbl21 = {enabled = false, cap = 240, originalCap = nil}

Performance:AddToggle({
    Title = "Unlock FPS",
    Default = false,
    Callback = function(enabled)
        tbl21.enabled = enabled

        if not enabled then
            if tbl21.originalCap and setfpscap then
                setfpscap(tbl21.originalCap)
            end

            tbl21.originalCap = nil
            return
        end

        if not setfpscap then
            lib:MakeNotify({
                Title = "Unlock FPS",
                Description = "setfpscap() tidak tersedia di executor kamu.",
                Delay = 3,
            })

            return
        end

        local v8 = getfpscap
        local v9 = v8 and getfpscap() or nil
        tbl21.originalCap = v9
        setfpscap(tbl21.cap)

        lib:MakeNotify({
            Title = "Unlock FPS",
            Description = "FPS Cap diset ke " .. tostring(tbl21.cap) .. " FPS.",
            Delay = 3,
        })
    end,
})

Performance:AddDropdown({
    Title = "FPS Cap",
    Options = {"60", "90", "120", "144", "240"},
    Default = "240",
    Callback = function(arg)
        local num = tonumber(arg)
        local cap = num or 240
        tbl21.cap = cap
        if not tbl21.enabled or not setfpscap then
            return
        end
        setfpscap(tbl21.cap)

        lib:MakeNotify({
            Title = "FPS Cap",
            Description = "FPS Cap diubah ke " .. arg .. " FPS.",
            Delay = 2,
        })
    end,
})

local v8 = v5:AddSection("Notification Position")
local flag4 = false
local str2 = "Tengah"
local v9 = nil

local function fn21()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return
    end
    local textNotifications = playerGui:FindFirstChild("Text Notifications")
    if not textNotifications then
        return
    end
    local frame = textNotifications:FindFirstChild("Frame")
    if not frame then
        return
    end
    local uiListLayout = frame:FindFirstChildOfClass("UIListLayout")

    if not v9 then
        local tbl22 = {AnchorPoint = frame.AnchorPoint, Position = frame.Position}
        local horizontalAlignment = uiListLayout and uiListLayout.HorizontalAlignment or Enum.HorizontalAlignment.Center
        tbl22.HorizontalAlignment = horizontalAlignment
        v9 = tbl22
    end

    if not flag4 then
        if v9 then
            frame.AnchorPoint = v9.AnchorPoint
            frame.Position = v9.Position

            if uiListLayout then
                uiListLayout.HorizontalAlignment = v9.HorizontalAlignment
            end
        end

        return
    end

    if str2 == "Kiri" then
        frame.AnchorPoint = Vector2.new(0, 0)
        frame.Position = UDim2.new(0, 5, 0, 110)

        if uiListLayout then
            uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        end
    elseif str2 == "Tengah" then
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.Position = UDim2.new(0.5, 0, 0, 110)

        if uiListLayout then
            uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        end
    elseif str2 == "Kanan" then
        frame.AnchorPoint = Vector2.new(1, 0)
        frame.Position = UDim2.new(1, -5, 0, 110)

        if uiListLayout then
            uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        end
    end
end

v8:AddToggle({
    Title = "Enable Custom Notification Position",
    Default = false,
    Callback = function(arg)
        flag4 = arg
        fn21()
    end,
})

v8:AddDropdown({
    Title = "Select Position",
    Options = {"Kiri", "Tengah", "Kanan"},
    Default = "Tengah",
    Callback = function(arg)
        str2 = arg
        fn21()
    end,
})

local v10 = v5:AddSection("Hide Stats")

local tbl22 = {
    enabled = false,
    showScriptLabel = true,
    scriptName = "discord.gg/lynxx",
    premiumLogo = false,
    verifyLogo = false,
    fakeName = "LynX",
    fakeLevel = "501",
    charConn = nil,
    sysMsgHooked = false,
    origSysMsg = nil,
    otherFakeNames = setmetatable({}, {__mode = "k"}),
    otherState = setmetatable({}, {__mode = "k"}),
    playerAddedConn = nil,
    playerRemovingConn = nil,
}

local tbl23 = {
    origTexts = {},
    textConns = setmetatable({}, {__mode = "k"}),
    descConn = nil,
}

local function fn22()
    local fakeName = tbl22.fakeName
    local str3 = fakeName

    if tbl22.premiumLogo then
        str3 = fakeName .. ""
    end

    if tbl22.verifyLogo then
        str3 = str3 .. ""
    end

    return str3
end

local function fn23(arg)
    return arg:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
end

local function fn24(arg)
    if arg == localPlayer then
        return fn22()
    end
    local v11 = tbl22.otherFakeNames[arg]
    if v11 then
        return v11
    end
    local str3 = "Player" .. tostring(1000 + arg.UserId % 9000)
    tbl22.otherFakeNames[arg] = str3
    return str3
end

local function fn25()
    if tbl22.sysMsgHooked then
        return
    end

    pcall(function()
        for i, descendant in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if descendant:IsA("ModuleScript") and descendant.Name == "SystemMessage" then
                local module = require(descendant)

                if module and module._displaySystemMessage then
                    tbl22.origSysMsg = module._displaySystemMessage

                    module._displaySystemMessage = function(arg, arg2, ...)
                        local v11 = arg2

                        if tbl22.enabled and type(arg2) == "string" then
                            local v12, v13, v14 = ipairs(Players:GetPlayers())
                            local v15 = v14
                            local v16 = v12
                            local v17 = v13

                            while true do
                                local v18, v19 = v16(v17, v15)
                                if v18 == nil then
                                    break
                                end
                                local v20 = fn24(v19)

                                for i2, v21 in ipairs({v19.Name, v19.DisplayName}) do
                                    if type(v21) == "string" and #v21 > 2 then
                                        v11 = string.gsub(v11, fn23(v21), v20)
                                    end
                                end

                                v15 = v18
                            end
                        end

                        return tbl22.origSysMsg(arg, v11, ...)
                    end

                    tbl22.sysMsgHooked = true
                end

                break
            end
        end
    end)
end

local function fn26()
    if not tbl22.sysMsgHooked then
        return
    end

    pcall(function()
        for i, descendant in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if descendant:IsA("ModuleScript") and descendant.Name == "SystemMessage" then
                local module = require(descendant)

                if module and tbl22.origSysMsg then
                    module._displaySystemMessage = tbl22.origSysMsg
                end

                break
            end
        end
    end)

    tbl22.sysMsgHooked = false
    tbl22.origSysMsg = nil
end

local function fn27(arg)
    if not arg then
        return nil
    end

    for i, v11 in ipairs({"Head", "HumanoidRootPart"}) do
        local v12 = arg:FindFirstChild(v11)
        local overhead = v12 and v12:FindFirstChild("Overhead")
        if overhead then
            return overhead
        end
    end

    return nil
end

local function fn28(arg)
    local n = os.clock() + 10
    local v11

    while true do
        v11 = fn27(arg)
        if v11 then
            break
        end
        task.wait(0.25)
        if n < os.clock() or not arg.Parent then
            return nil
        end
    end

    return v11
end

local function fn29(arg)
    return fn27(arg.Character)
end

local function fn30()
    local v11 = fn29(localPlayer)
    local lynxFrame = v11 and v11:FindFirstChild("LynxFrame")
    if not lynxFrame then
        return
    end
    local header = v11:FindFirstChild("Header", true)
    local parent = header and header.Parent

    if parent and parent:IsA("Frame") then
        local position = parent.Position
        parent.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale - 0.25, position.Y.Offset)
    end

    lynxFrame:Destroy()
end

local function fn31(arg)
    local overhead = arg:FindFirstAncestor("Overhead")
    if not overhead or overhead:FindFirstChild("LynxFrame") then
        return
    end
    local parent = arg.Parent
    if not parent or not parent:IsA("Frame") then
        return
    end
    local position = parent.Position
    parent.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale + 0.25, position.Y.Offset)
    local frame = Instance.new("Frame")
    frame.Name = "LynxFrame"
    frame.Size = parent.Size
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = overhead
    local clone = arg:Clone()
    clone.Name = "LynxLabel"
    clone.Text = tbl22.scriptName
    clone.TextScaled = true
    clone.Font = Enum.Font.GothamBold
    clone.TextStrokeTransparency = 0.5
    clone.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    clone.TextColor3 = Color3.fromRGB(255, 140, 0)
    clone.Parent = frame
end

local function fn32(arg, arg2, arg3, arg4)
    if not arg:IsA("TextLabel") then
        return
    end
    local fullName = arg:GetFullName()

    if not arg2.origTexts[fullName] then
        arg2.origTexts[fullName] = arg.Text
    end

    local v11 = arg2.origTexts[fullName]
    if not v11 or v11 == "" then
        return
    end

    if arg.Name == "Header" then
        if arg4 and tbl22.showScriptLabel then
            fn31(arg)
        end

        arg.Text = arg3()
    elseif arg4 and string.find(string.lower(v11), "lvl") then
        arg.Text = string.gsub(v11, "[%d,]+", tbl22.fakeLevel)
    end
end

local function fn33(arg, arg2, arg3, arg4)
    if not arg:IsA("TextLabel") then
        return
    end
    fn32(arg, arg2, arg3, arg4)
    if arg2.textConns[arg] then
        return
    end

    arg2.textConns[arg] = arg:GetPropertyChangedSignal("Text"):Connect(function()
        if not tbl22.enabled then
            return
        end
        local fullName = arg:GetFullName()
        local text = arg.Text

        if text ~= arg3() and (not arg4 or not string.find(text, tbl22.fakeLevel)) then
            arg2.origTexts[fullName] = text
        end

        fn32(arg, arg2, arg3, arg4)
    end)
end

local function fn34(arg, arg2, arg3, arg4)
    for k, textConn in pairs(arg2.textConns) do
        pcall(function()
            textConn:Disconnect()
        end)
    end

    arg2.textConns = setmetatable({}, {__mode = "k"})

    if arg2.descConn then
        pcall(function()
            arg2.descConn:Disconnect()
        end)

        arg2.descConn = nil
    end

    if not arg then
        return
    end

    for i, descendant in ipairs(arg:GetDescendants()) do
        fn33(descendant, arg2, arg3, arg4)
    end

    arg2.descConn = arg.DescendantAdded:Connect(function(descendant)
        task.defer(function()
            if tbl22.enabled and descendant and descendant.Parent then
                fn33(descendant, arg2, arg3, arg4)
            end
        end)
    end)
end

local function fn35()
    if not tbl22.enabled then
        return
    end
    fn34(fn29(localPlayer), tbl23, fn22, true)
end

local function fn36()
    fn30()

    for k, origText in pairs(tbl23.origTexts) do
        pcall(function()
            local v11 = game

            for match in string.gmatch(k, "[^.]+") do
                local v12 = v11 and v11:FindFirstChild(match)
                v11 = v12
            end

            if v11 and v11:IsA("TextLabel") then
                v11.Text = origText
            end
        end)
    end

    tbl23.origTexts = {}

    for k, textConn in pairs(tbl23.textConns) do
        pcall(function()
            textConn:Disconnect()
        end)
    end

    tbl23.textConns = setmetatable({}, {__mode = "k"})

    if tbl23.descConn then
        pcall(function()
            tbl23.descConn:Disconnect()
        end)

        tbl23.descConn = nil
    end
end

local function fn37(arg)
    local v11 = tbl22.otherState[arg]
    if not v11 then
        return
    end

    for k, textConn in pairs(v11.textConns) do
        pcall(function()
            textConn:Disconnect()
        end)
    end

    if v11.descConn then
        pcall(function()
            v11.descConn:Disconnect()
        end)
    end

    if v11.charConn then
        pcall(function()
            v11.charConn:Disconnect()
        end)
    end

    tbl22.otherState[arg] = nil
end

local function fn38(arg)
    if not tbl22.enabled or arg == localPlayer then
        return
    end
    local tbl24 = tbl22.otherState[arg]

    if not tbl24 then
        tbl24 = {
            origTexts = {},
            textConns = setmetatable({}, {__mode = "k"}),
            descConn = nil,
            charConn = nil,
        }

        tbl22.otherState[arg] = tbl24
    end

    local function fn39()
        return fn24(arg)
    end

    if tbl24.charConn then
        pcall(function()
            tbl24.charConn:Disconnect()
        end)
    end

    tbl24.charConn = arg.CharacterAdded:Connect(function(character)
        if not tbl22.enabled then
            return
        end
        tbl24.origTexts = {}
        local v11 = fn28(character)

        if v11 and tbl22.enabled then
            fn34(v11, tbl24, fn39, false)
        end
    end)

    fn34(fn29(arg), tbl24, fn39, false)
end

local function fn39()
    for i, player in ipairs(Players:GetPlayers()) do
        fn38(player)
    end
end

local function fn40()
    for k in pairs(tbl22.otherState) do
        fn37(k)
    end
end

local function fn41()
    tbl22.playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if tbl22.enabled then
            fn38(player)
        end
    end)

    tbl22.playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
        fn37(player)
        tbl22.otherFakeNames[player] = nil
    end)
end

local function fn42()
    if tbl22.playerAddedConn then
        tbl22.playerAddedConn:Disconnect()
        tbl22.playerAddedConn = nil
    end

    if tbl22.playerRemovingConn then
        tbl22.playerRemovingConn:Disconnect()
        tbl22.playerRemovingConn = nil
    end
end

local tbl24 = {
    conn = nil,
    playerConns = {},
    nameMap = {},
    sortedNames = {},
    textConns = setmetatable({}, {__mode = "k"}),
}

local function fn43()
    local nameMap = {}
    local tbl25 = {}
    local sortedNames = {}
    local v11, v12, v13 = ipairs(Players:GetPlayers())
    local v14 = v13
    local v15 = v11
    local v16 = v12

    while true do
        local v17, v18 = v15(v16, v14)
        if v17 == nil then
            break
        end
        local v19 = fn24(v18)

        for i, v20 in ipairs({v18.Name, v18.DisplayName}) do
            if type(v20) == "string" and #v20 > 2 and not tbl25[v20] then
                tbl25[v20] = true
                nameMap[v20] = v19
                sortedNames[#sortedNames + 1] = v20
            end
        end

        v14 = v17
    end

    table.sort(sortedNames, function(arg, arg2)
        local flag5 = #arg2 < #arg
        return flag5
    end)

    tbl24.nameMap = nameMap
    tbl24.sortedNames = sortedNames
end

local fn44 = nil

fn44 = function(arg)
    if not arg:IsA("TextLabel") and not arg:IsA("TextButton") then
        return
    end
    local text = arg.Text
    if type(text) ~= "string" or #text == 0 then
        return
    end
    local text2 = text

    for i, sortedName in ipairs(tbl24.sortedNames) do
        text2 = text2:gsub(fn23(sortedName), tbl24.nameMap[sortedName])
    end

    if text2 ~= text then
        arg.Text = text2
    end

    if not tbl24.textConns[arg] then
        tbl24.textConns[arg] = arg:GetPropertyChangedSignal("Text"):Connect(function()
            if not tbl22.enabled then
                return
            end
            fn44(arg)
        end)
    end
end

local function fn45()
    if tbl24.conn then
        tbl24.conn:Disconnect()
        tbl24.conn = nil
    end

    for i, playerConn in ipairs(tbl24.playerConns) do
        pcall(function()
            playerConn:Disconnect()
        end)
    end

    tbl24.playerConns = {}

    for k, textConn in pairs(tbl24.textConns) do
        pcall(function()
            textConn:Disconnect()
        end)

        tbl24.textConns[k] = nil
    end
end

local function fn46()
    if not tbl22.enabled then
        return
    end
    fn45()
    fn43()
    local experienceChat = game:GetService("CoreGui"):FindFirstChild("ExperienceChat")
    if not experienceChat then
        return
    end

    for i, descendant in ipairs(experienceChat:GetDescendants()) do
        pcall(fn44, descendant)
    end

    tbl24.conn = experienceChat.DescendantAdded:Connect(function(descendant)
        if not tbl22.enabled then
            return
        end

        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            task.defer(function()
                if tbl22.enabled then
                    pcall(fn44, descendant)
                end
            end)
        end
    end)

    local connection = Players.PlayerAdded:Connect(function()
        fn43()
    end)

    local connection2 = Players.PlayerRemoving:Connect(function()
        fn43()
    end)

    table.insert(tbl24.playerConns, connection)
    table.insert(tbl24.playerConns, connection2)
end

local tbl25 = {
    RarestFish = true,
    MonthlyCaughtFish = true,
    GalaxyVariantsCaught = true,
}

local tbl26 = {conns = {}, guiWatchConn = nil}

local function fn47(arg)
    if arg.Name == "DisplayName" or arg.Name == "Username" then
        return true
    end
    local text = arg.Text
    local flag5 = type(text) == "string" and text:find("@[%w_]+") ~= nil
    return flag5
end

local function fn48(arg)
    if not arg:IsA("TextLabel") then
        return
    end

    if not fn47(arg) then
        return
    end
    local text = arg.Text
    if type(text) ~= "string" or text == "" then
        return
    end
    local str3 = text:gsub("%S+%s*%(@[%w_]+%)", "Hidden (@Hidden)"):gsub("@[%w_]+", "@Hidden")
    local text2 = str3

    if str3 == text and arg.Name == "DisplayName" then
        text2 = "Hidden"
    end

    if text2 ~= text then
        arg.Text = text2
    end
end

local function fn49(arg)
    for i, descendant in ipairs(arg:GetDescendants()) do
        pcall(fn48, descendant)
    end

    table.insert(tbl26.conns, arg.DescendantAdded:Connect(function(descendant)
        if not tbl22.enabled then
            return
        end

        task.defer(function()
            if descendant and descendant.Parent then
                pcall(fn48, descendant)
            end
        end)
    end))
end

local function fn50()
    for i, conn in ipairs(tbl26.conns) do
        pcall(function()
            conn:Disconnect()
        end)
    end

    tbl26.conns = {}

    if tbl26.guiWatchConn then
        pcall(function()
            tbl26.guiWatchConn:Disconnect()
        end)

        tbl26.guiWatchConn = nil
    end
end

local function fn51()
    if not tbl22.enabled then
        return
    end
    fn50()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return
    end

    for k in pairs(tbl25) do
        local v11 = playerGui:FindFirstChild(k)

        if v11 then
            fn49(v11)
        end
    end

    tbl26.guiWatchConn = playerGui.ChildAdded:Connect(function(child)
        if not tbl22.enabled then
            return
        end

        if tbl25[child.Name] then
            task.defer(function()
                if tbl22.enabled then
                    fn49(child)
                end
            end)
        end
    end)
end

local tbl27 = {conns = setmetatable({}, {__mode = "k"}), panelConn = nil}

local function fn52(arg)
    if not arg:IsA("TextLabel") then
        return
    end
    local nameFrame = arg:FindFirstAncestor("NameFrame")
    if not nameFrame then
        return
    end
    local num = nil
    local parent = nameFrame.Parent

    while parent do
        local match = parent.Name:match("^PlayerEntry_(%d+)$")
        if not match then
            parent = parent.Parent
            continue
        end
        num = tonumber(match)
        break
    end

    if not num then
        return
    end

    local function fn53()
        local playerByUserId = Players:GetPlayerByUserId(num)
        local text = playerByUserId and fn24(playerByUserId) or "Player" .. tostring(1000 + num % 9000)

        if arg.Text ~= text then
            arg.Text = text
        end
    end

    fn53()

    if not tbl27.conns[arg] then
        tbl27.conns[arg] = arg:GetPropertyChangedSignal("Text"):Connect(function()
            if tbl22.enabled then
                fn53()
            end
        end)
    end
end

local function fn53()
    for k, conn in pairs(tbl27.conns) do
        pcall(function()
            conn:Disconnect()
        end)
    end

    tbl27.conns = setmetatable({}, {__mode = "k"})

    if tbl27.panelConn then
        pcall(function()
            tbl27.panelConn:Disconnect()
        end)

        tbl27.panelConn = nil
    end
end

local function fn54()
    if not tbl22.enabled then
        return
    end
    fn53()
    local playerList = game:GetService("CoreGui"):FindFirstChild("PlayerList")
    if not playerList then
        return
    end

    for i, descendant in ipairs(playerList:GetDescendants()) do
        pcall(fn52, descendant)
    end

    tbl27.panelConn = playerList.DescendantAdded:Connect(function(descendant)
        if not tbl22.enabled then
            return
        end

        task.defer(function()
            if descendant and descendant.Parent then
                pcall(fn52, descendant)
            end
        end)
    end)
end

local function fn55()
    fn45()
    fn50()
    fn53()
    fn40()
    fn42()

    if tbl22.charConn then
        tbl22.charConn:Disconnect()
        tbl22.charConn = nil
    end

    fn36()
    fn26()
end

v10:AddToggle({
    Title = "Enable Hide Stats",
    Default = false,
    Callback = function(enabled)
        tbl22.enabled = enabled
        if not enabled then
            fn55()
            return
        end
        fn35()
        fn25()
        fn46()
        fn51()
        fn54()
        fn39()
        fn41()

        if tbl22.charConn then
            tbl22.charConn:Disconnect()
            tbl22.charConn = nil
        end

        tbl22.charConn = localPlayer.CharacterAdded:Connect(function(character)
            if not tbl22.enabled then
                return
            end
            tbl23.origTexts = {}
            local v11 = fn28(character)

            if v11 and tbl22.enabled then
                fn34(v11, tbl23, fn22, true)
            end
        end)
    end,
})

v10:AddToggle({
    Title = "Show Script Title",
    Default = true,
    Callback = function(showScriptLabel)
        tbl22.showScriptLabel = showScriptLabel
        if not tbl22.enabled then
            return
        end

        if not showScriptLabel then
            fn30()
        end

        fn35()
    end,
})

v10:AddToggle({
    Title = "Enable Premium Logo",
    Default = false,
    Callback = function(premiumLogo)
        tbl22.premiumLogo = premiumLogo
        if not tbl22.enabled then
            return
        end
        fn35()
    end,
})

v10:AddToggle({
    Title = "Enable Verification Logo",
    Default = false,
    Callback = function(verifyLogo)
        tbl22.verifyLogo = verifyLogo
        if not tbl22.enabled then
            return
        end
        fn35()
    end,
})

v10:AddInput({
    Title = "Fake Name",
    Default = "LynX",
    Callback = function(arg)
        local fakeName = arg or "LynX"
        tbl22.fakeName = fakeName
        if not tbl22.enabled then
            return
        end
        fn35()
    end,
})

v10:AddInput({
    Title = "Fake Level",
    Default = "501",
    Callback = function(arg)
        local v11 = tostring
        local str3 = arg or "501"
        tbl22.fakeLevel = v11(str3)
        if not tbl22.enabled then
            return
        end
        fn35()
    end,
})

local Server = v5:AddSection("Server")

Server:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
        end)
    end,
})

Server:AddButton({
    Title = "Serverhop",
    Callback = function()
        task.spawn(function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            local placeId = game.PlaceId
            local jobId = game.JobId
            local id = nil
            local nextPageCursor = nil
            local ok, result

            repeat
                ok, result = pcall(function()
                    local v11 = getHTTP()
                    if not v11 then
                        return nil
                    end
                    local format = string.format
                    local v12 = nextPageCursor
                    local str3 = v12 and "&cursor=" .. nextPageCursor or ""

                    local v13 = v11({
                        Url = format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s", placeId, str3),
                        Method = "GET",
                    })

                    if v13 and v13.Body then
                        return HttpService:JSONDecode(v13.Body)
                    end
                    return nil
                end)

                if not ok or not result or not result.data then
                    break
                end

                for i, v11 in ipairs(result.data) do
                    if v11.id ~= jobId and v11.maxPlayers - v11.playing > 0 then
                        id = v11.id
                        break
                    end
                end

                nextPageCursor = result.nextPageCursor
            until id or not nextPageCursor

            pcall(function()
                if id then
                    TeleportService:TeleportToPlaceInstance(placeId, id, localPlayer)
                else
                    TeleportService:Teleport(placeId, localPlayer)
                end
            end)
        end)
    end,
})

local v11 = v5:AddSection("Auto Reconnect & Execute")

local tbl28 = {
    enabled = false,
    setup = false,
    fired = false,
    errorConn = nil,
    overlayConn = nil,
}

local function fn56()
    if tbl28.errorConn then
        pcall(function()
            tbl28.errorConn:Disconnect()
        end)

        tbl28.errorConn = nil
    end

    if tbl28.overlayConn then
        pcall(function()
            tbl28.overlayConn:Disconnect()
        end)

        tbl28.overlayConn = nil
    end

    tbl28.setup = false
end

v11:AddParagraph({
    Title = "Info",
    Content = "Auto rejoin server on disconnect.\nUses Roblox ErrorPrompt detection.\nScript will auto execute after reconnect.",
})

v11:AddToggle({
    Title = "Enable Auto Reconnect",
    Default = false,
    Callback = function(enabled)
        tbl28.enabled = enabled

        if enabled then
            fn56()
            tbl28.setup = true
            tbl28.fired = false

            local function fn57(arg)
                if not tbl28.enabled or tbl28.fired then
                    return
                end
                tbl28.fired = true
                sharedQueueAutoExecute()
                task.wait(2)

                pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
                end)
            end

            pcall(function()
                local GuiService = game:GetService("GuiService")

                tbl28.errorConn = GuiService.ErrorMessageChanged:Connect(function(arg)
                    if arg and arg ~= "" then
                        fn57(arg)
                    end
                end)
            end)

            pcall(function()
                local robloxPromptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                local promptOverlay = robloxPromptGui and game:GetService("CoreGui").RobloxPromptGui:FindFirstChild("promptOverlay")

                if promptOverlay then
                    tbl28.overlayConn = promptOverlay.ChildAdded:Connect(function(child)
                        if child.Name == "ErrorPrompt" then
                            task.wait(0.5)
                            local textLabel = child:FindFirstChildWhichIsA("TextLabel", true)
                            local text = textLabel and textLabel.Text or "Disconnected"
                            fn57(text)
                        end
                    end)
                end
            end)

            lib:MakeNotify({
                Title = "Auto Reconnect",
                Description = "Active — will auto rejoin and execute script on disconnect.",
                Delay = 2,
            })
        else
            fn56()

            lib:MakeNotify({
                Title = "Auto Reconnect",
                Description = "Disabled.",
                Delay = 2,
            })
        end
    end,
})

local v12 = v5:AddSection("Color Correction")
local Lighting2 = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local tbl29 = {
    enabled = false,
    selected = "Normal",
    correction = nil,
    tween = nil,
}

local tbl30 = {
    Normal = {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255),
    },
    HD = {
        Brightness = 0.02,
        Contrast = 0.28,
        Saturation = 0.18,
        TintColor = Color3.fromRGB(250, 250, 255),
    },
    ["4K"] = {
        Brightness = 0.03,
        Contrast = 0.32,
        Saturation = 0.22,
        TintColor = Color3.fromRGB(252, 252, 255),
    },
    HDR = {
        Brightness = 0.05,
        Contrast = 0.38,
        Saturation = 0.28,
        TintColor = Color3.fromRGB(255, 252, 248),
    },
    Crisp = {
        Brightness = 0.01,
        Contrast = 0.35,
        Saturation = 0.15,
        TintColor = Color3.fromRGB(255, 255, 255),
    },
    Golden = {
        Brightness = 0.06,
        Contrast = 0.22,
        Saturation = 0.2,
        TintColor = Color3.fromRGB(255, 210, 160),
    },
    Sunset = {
        Brightness = 0.04,
        Contrast = 0.25,
        Saturation = 0.22,
        TintColor = Color3.fromRGB(255, 175, 110),
    },
    Warm = {
        Brightness = 0.03,
        Contrast = 0.18,
        Saturation = 0.12,
        TintColor = Color3.fromRGB(255, 225, 190),
    },
    Cool = {
        Brightness = 0.02,
        Contrast = 0.2,
        Saturation = 0.1,
        TintColor = Color3.fromRGB(190, 215, 255),
    },
    Arctic = {
        Brightness = 0.05,
        Contrast = 0.22,
        Saturation = -0.1,
        TintColor = Color3.fromRGB(205, 228, 255),
    },
    Ocean = {
        Brightness = 0,
        Contrast = 0.2,
        Saturation = 0.15,
        TintColor = Color3.fromRGB(150, 200, 235),
    },
    Cinematic = {
        Brightness = -0.02,
        Contrast = 0.3,
        Saturation = -0.1,
        TintColor = Color3.fromRGB(225, 215, 200),
    },
    ["Teal & Orange"] = {
        Brightness = 0.02,
        Contrast = 0.28,
        Saturation = 0.18,
        TintColor = Color3.fromRGB(205, 225, 210),
    },
    Matte = {
        Brightness = 0.04,
        Contrast = -0.08,
        Saturation = -0.12,
        TintColor = Color3.fromRGB(218, 212, 205),
    },
    Film = {
        Brightness = 0.03,
        Contrast = 0.2,
        Saturation = 0.08,
        TintColor = Color3.fromRGB(255, 228, 195),
    },
    Night = {
        Brightness = -0.15,
        Contrast = 0.22,
        Saturation = -0.1,
        TintColor = Color3.fromRGB(165, 185, 225),
    },
    Moody = {
        Brightness = -0.08,
        Contrast = 0.3,
        Saturation = 0.05,
        TintColor = Color3.fromRGB(190, 178, 168),
    },
    Vibrant = {
        Brightness = 0.04,
        Contrast = 0.2,
        Saturation = 0.45,
        TintColor = Color3.fromRGB(255, 255, 255),
    },
    Anime = {
        Brightness = 0.05,
        Contrast = 0.22,
        Saturation = 0.38,
        TintColor = Color3.fromRGB(245, 240, 255),
    },
    Forest = {
        Brightness = 0.02,
        Contrast = 0.18,
        Saturation = 0.22,
        TintColor = Color3.fromRGB(195, 225, 190),
    },
    Tropical = {
        Brightness = 0.05,
        Contrast = 0.2,
        Saturation = 0.3,
        TintColor = Color3.fromRGB(200, 238, 220),
    },
    Dreamy = {
        Brightness = 0.08,
        Contrast = -0.06,
        Saturation = 0.12,
        TintColor = Color3.fromRGB(232, 218, 255),
    },
    Vintage = {
        Brightness = 0.04,
        Contrast = 0.12,
        Saturation = -0.2,
        TintColor = Color3.fromRGB(242, 222, 178),
    },
    Grayscale = {
        Brightness = 0,
        Contrast = 0.15,
        Saturation = -1,
        TintColor = Color3.fromRGB(255, 255, 255),
    },
}

local tbl31 = {"Normal"}

for k in pairs(tbl30) do
    if k ~= "Normal" then
        table.insert(tbl31, k)
    end
end

table.sort(tbl31, function(arg, arg2)
    if arg == "Normal" then
        return true
    end

    if arg2 == "Normal" then
        return false
    end
    local flag5 = arg < arg2
    return flag5
end)

local function createColorCorrectionEffect()
    if tbl29.correction and tbl29.correction.Parent then
        return tbl29.correction
    end
    local colorCorrectionEffect = Lighting2:FindFirstChildOfClass("ColorCorrectionEffect")
    if colorCorrectionEffect and colorCorrectionEffect:GetAttribute("LynxCC") then
        tbl29.correction = colorCorrectionEffect
        return colorCorrectionEffect
    end
    local colorCorrectionEffect2 = Instance.new("ColorCorrectionEffect")
    colorCorrectionEffect2.Name = "LynxColorCorrection"
    colorCorrectionEffect2.Enabled = true
    colorCorrectionEffect2:SetAttribute("LynxCC", true)
    colorCorrectionEffect2.Parent = Lighting2
    tbl29.correction = colorCorrectionEffect2
    return colorCorrectionEffect2
end

local function fn57(arg)
    local v13 = tbl30[arg]
    if not v13 then
        return
    end
    local v14 = createColorCorrectionEffect()

    if tbl29.tween then
        tbl29.tween:Cancel()
    end

    tbl29.tween = TweenService:Create(v14, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = v13.Brightness,
        Contrast = v13.Contrast,
        Saturation = v13.Saturation,
        TintColor = v13.TintColor,
    })

    tbl29.tween:Play()
end

local function fn58()
    if tbl29.tween then
        tbl29.tween:Cancel()
    end

    if tbl29.correction and tbl29.correction.Parent then
        local tween = TweenService:Create(tbl29.correction, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255),
        })

        tween:Play()

        tween.Completed:Once(function()
            if tbl29.correction and tbl29.correction.Parent then
                tbl29.correction:Destroy()
                tbl29.correction = nil
            end
        end)
    end
end

v12:AddDropdown({
    Title = "Color Preset",
    Options = tbl31,
    Default = "Normal",
    Callback = function(selected)
        tbl29.selected = selected

        if tbl29.enabled then
            fn57(selected)
        end
    end,
})

v12:AddToggle({
    Title = "Enable Color Correction",
    Default = false,
    NoSave = true,
    Callback = function(enabled)
        tbl29.enabled = enabled

        if enabled then
            fn57(tbl29.selected)

            lib:MakeNotify({
                Title = "Color Correction",
                Content = "Preset: " .. tbl29.selected,
                Delay = 2,
            })
        else
            fn58()

            lib:MakeNotify({
                Title = "Color Correction",
                Content = "Dimatikan.",
                Delay = 2,
            })
        end
    end,
})

local v13 = v5:AddSection("Change Time")
local ClientTimeController = nil

pcall(function()
    ClientTimeController = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers", 3):WaitForChild("ClientTimeController", 3))
end)

local tbl32 = {enabled = false, profile = "Night"}

v13:AddToggle({
    Title = "Change Time",
    Default = false,
    Callback = function(enabled)
        tbl32.enabled = enabled

        if enabled then
            if ClientTimeController then
                ClientTimeController:_forceUpdateAndOverride(tbl32.profile)
            end
        elseif ClientTimeController then
            ClientTimeController:_removeOverride()
        end
    end,
})

v13:AddDropdown({
    Title = "Time Profile",
    Options = {"Night", "Day", "Bloodmoon", "Purple Bloodmoon", "Galaxy"},
    Default = "Night",
    Callback = function(profile)
        tbl32.profile = profile

        if tbl32.enabled and ClientTimeController then
            ClientTimeController:_forceUpdateAndOverride(profile)
        end
    end,
})

lib:Init()
