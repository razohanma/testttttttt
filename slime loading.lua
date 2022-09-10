--// Wait Game Loaded
while task.wait() do
    if game:IsLoaded() then break; end
end

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/razohanma/Slime/main/Slime%20theme.lua", true))();
local w = Library.new(true,"Bread | Razohan#6069")
w.ChangeToggleKey(Enum.KeyCode.RightControl)

--// Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

--// Remote
local event = {
    Merge = game:GetService("ReplicatedStorage").GTycoonClient.Remotes.MergeDroppers,
    Buy_Dropper = game:GetService("ReplicatedStorage").GTycoonClient.Remotes.BuyDropper,
    Buy_Speed = game:GetService("ReplicatedStorage").GTycoonClient.Remotes.BuySpeed,
    Deposit = game:GetService("ReplicatedStorage").GTycoonClient.Remotes.DepositDrops,
}

--// Setting
getgenv().Setting = {
    Grab_slime = false,
    Merge = false,
    Buy_Dropper = {boolean = false,unit = 1},
    Buy_Speed = false,
    Deposit = false,
}

--// Script
local tab_1 = w:Category("Main")

local auto = tab_1:Sector("Automatic")
local misc = tab_1:Sector("Misc")
local credit = tab_1:Sector("Credit")

auto:Cheat("Toggle","Auto Collect",function(x)
    getgenv().Setting.Grab_slime = x;
    if x then
        Grab_slime()
    end
end)

auto:Cheat("Toggle","Auto Sell",function(x)
    getgenv().Setting.Deposit = x;
    if x then
        Deposit()
    end
end)

auto:Cheat("Dropdown","Buy Slime Unit",function(x)
    getgenv().Setting.Buy_Dropper.unit = x;
end,{options = {"1","5"}})

auto:Cheat("Toggle","Auto Buy Slime",function(x)
    getgenv().Setting.Buy_Dropper.boolean = x;
    if x then
        Buy_Dropper(getgenv().Setting.Buy_Dropper.unit)
    end
end)

auto:Cheat("Toggle","Auto Buy RATE",function(x)
    getgenv().Setting.Buy_Speed = x;
    if x then
        Buy_Speed()
    end
end)

auto:Cheat("Toggle","Auto Merge Slime",function(x)
    getgenv().Setting.Merge = x;
    if x then
        Merge()
    end
end)

getgenv().WS = 16;getgenv().JP = 50;
misc:Cheat("Slider","Walk speed", function(x)
    getgenv().WS = x;
end,{min = 16,max = 500, suffix = " value"})
misc:Cheat("Slider","Jump Height", function(x)
    getgenv().JP = x;
end,{min = 50,max = 500, suffix = " value"})

local Plots = {}
for i,v in ipairs(workspace["Plots"]:GetChildren()) do
    if v:IsA("Folder") and not table.find(Plots,tostring("Plot "..v.Name)) then
        table.insert(Plots,tostring("Plot "..v.Name))
    end
end

misc:Cheat("Dropdown","Waypoints",function(x)
    if LocalPlayer.Character then
        pcall(function()
            local plot_name = tostring(x):split("Plot ");
            local hrp = LocalPlayer.Character.HumanoidRootPart

            for i,v in ipairs(workspace["Plots"]:GetChildren()) do
                if v:IsA("Folder") and tostring(v.Name):find(plot_name[2]) then
                    for i2,v2 in ipairs(v:GetDescendants()) do
                        if v2:IsA("Part") and tostring(v2.Name):lower():find("plotteleport") or tostring(v2.Name):lower():match("plotteleport")  then
                            local cf = v2.CFrame * CFrame.new(0,1.5,0)
                            hrp.CFrame = cf
                        end
                    end
                end
            end
        end)
    end
end,{options = Plots,default = "None"})

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = tonumber(getgenv().WS)
            Humanoid.JumpPower = tonumber(getgenv().JP)
            if Humanoid.UseJumpPower ~= true then Humanoid.UseJumpPower = true end
        end
    end
end)

credit:Cheat("Label", "Made by Razohan#6069")
credit:Cheat("Label","Ui: Project Finity")
credit:Cheat("button","Discord Invite",function()
    if setclipboard then setclipboard("https://discord.gg/rYF7McmUeM") end
end,{text = "Copy"})

--// Function
function Grab_slime()
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for i,v in ipairs(workspace["Drops"]:GetChildren()) do
            if v:IsA("Part") then
                v.CFrame = hrp.CFrame
            end
         end
    end
    local added;
    added = workspace["Drops"].ChildAdded:Connect(function(v)
        task.wait(.2)
        if v:IsA("Part") and LocalPlayer.Character then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            v.CFrame = hrp.CFrame
        end
    end)
    task.spawn(function()
        while task.wait(.1) do
            if getgenv().Setting.Grab_slime ~= true then added:Disconnect() break; end
        end
    end)
end

function Deposit()
    task.spawn(function()
        while getgenv().Setting.Deposit and task.wait(.1) do
            event.Deposit:FireServer()
        end
    end)
end

function Buy_Dropper(value)
    task.spawn(function()
        while getgenv().Setting.Buy_Dropper.boolean and task.wait(.1) do
            local v = value or 1
            event.Buy_Dropper:FireServer(tonumber(v))
        end
    end)
end

function Buy_Speed()
    task.spawn(function()
        while getgenv().Setting.Buy_Speed and task.wait(.1) do
            event.Buy_Speed:FireServer(1)
        end
    end)
end

function Merge()
    task.spawn(function()
        while getgenv().Setting.Merge and task.wait(.1) do
            event.Merge:FireServer()
        end
    end)
end
