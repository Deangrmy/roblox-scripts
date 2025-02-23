local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
    local autoFarm = Instance.new("RemoteFunction", ReplicatedStorage)
    autoFarm.Name = "AutoFarm"

    local sellWheat = Instance.new("RemoteEvent", ReplicatedStorage)
    sellWheat.Name = "SellWheat"

    autoFarm.OnServerInvoke = function(player)
        local stats = player:FindFirstChild("leaderstats") or Instance.new("Folder", player)
        stats.Name = "leaderstats"

        local wheat = stats:FindFirstChild("Wheat") or Instance.new("IntValue", stats)
        wheat.Name = "Wheat"
        wheat.Value = wheat.Value + 1

        return wheat.Value
    end

    sellWheat.OnServerEvent:Connect(function(player)
        local stats = player:FindFirstChild("leaderstats")
        if not stats then return end

        local wheat = stats:FindFirstChild("Wheat")
        local coins = stats:FindFirstChild("Coins") or Instance.new("IntValue", stats)
        coins.Name = "Coins"

        if wheat and wheat.Value > 0 then
            coins.Value = coins.Value + wheat.Value * 5
            wheat.Value = 0
        end
    end)

    return
end

local autoFarm = ReplicatedStorage:WaitForChild("AutoFarm")
local sellWheat = ReplicatedStorage:WaitForChild("SellWheat")
local player = Players.LocalPlayer
local farming = false

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size, frame.Position, frame.BackgroundColor3 = UDim2.new(0, 200, 0, 120), UDim2.new(0.5, -100, 0.4, 0), Color3.fromRGB(50, 50, 50)

local function createButton(text, pos, color, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size, btn.Position, btn.Text, btn.BackgroundColor3 = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, pos), text, color
    btn.MouseButton1Click:Connect(callback)
end

createButton("Auto Farm: OFF", 0, Color3.fromRGB(255, 0, 0), function(btn)
    farming = not farming
    btn.Text, btn.BackgroundColor3 = farming and "Auto Farm: ON" or "Auto Farm: OFF", farming and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if farming then task.spawn(function() while farming do autoFarm:InvokeServer() wait(5) end end) end
end)

createButton("Sell Wheat", 40, Color3.fromRGB(0, 150, 255), function() sellWheat:FireServer() end)
