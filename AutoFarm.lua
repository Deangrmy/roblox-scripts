print("✅ Cultivation Hub Loaded!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
pcall(function()
    gui.Parent = player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

print("✅ GUI Injected Successfully!")

local function createButton(text, pos, color, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.MouseButton1Click:Connect(callback)
end

createButton("Auto Qi: OFF", 0, Color3.fromRGB(255, 0, 0), function(btn)
    local gatherQi = ReplicatedStorage:FindFirstChild("GatherQi")
    if not gatherQi then warn("❌ GatherQi RemoteFunction not found!") return end
    
    local farming = not farming
    btn.Text = farming and "Auto Qi: ON" or "Auto Qi: OFF"
    btn.BackgroundColor3 = farming and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    if farming then
        print("⚡ Auto Qi Started...")
        task.spawn(function()
            while farming do
                gatherQi:InvokeServer()
                print("⚡ Qi Collected!")
                wait(5)
            end
        end)
    else
        print("⏸ Auto Qi Stopped.")
    end
end)

createButton("Auto Harvest", 40, Color3.fromRGB(0, 150, 255), function()
    local workspace = game:GetService("Workspace")

    for _, plant in pairs(workspace:GetChildren()) do
        if plant:IsA("Model") and plant:FindFirstChild("ReadyToHarvest") then
            local harvestEvent = plant:FindFirstChild("HarvestEvent")
            if harvestEvent then
                harvestEvent:FireServer()
                print("🌱 Harvested: " .. plant.Name)
            end
        end
    end
end)

createButton("Auto Alchemy", 80, Color3.fromRGB(255, 165, 0), function()
    local alchemy = ReplicatedStorage:FindFirstChild("Alchemy")
    if not alchemy then warn("❌ Alchemy RemoteFunction not found!") return end

    print("🧪 Creating Potion...")
    alchemy:InvokeServer("Best_Potion")
end)
