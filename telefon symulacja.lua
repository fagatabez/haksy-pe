local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", player)

-- Usunięcie starego GUI, jeśli istnieje
local oldScreenGui = playerGui:FindFirstChild("ScreenGui")
if oldScreenGui then
    oldScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Funkcja do symulowania naciśnięcia klawisza
local function simulateKeyPress(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- Funkcja do usuwania starych przycisków
local function clearButtons()
    for _, button in pairs(screenGui:GetChildren()) do
        if button:IsA("TextButton") then
            button:Destroy()
        end
    end
end

-- Funkcja do tworzenia przycisków
local function createButtons()
    clearButtons() -- Usunięcie starych przycisków

    local keys = {"E", "U", "J", "K", "X", "F", "G", "Q", "C", "Y", "H"}
    local buttons = {}

    for i, key in ipairs(keys) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 25, 0, 25) -- Możesz dostosować rozmiar
        button.Position = UDim2.new(0, 60 * i, 0, 50)
        button.Text = key
        button.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        button.TextSize = 20
        button.Parent = screenGui

        -- Obsługa kliknięcia
        button.MouseButton1Click:Connect(function()
            simulateKeyPress(Enum.KeyCode[key])
        end)

        -- Obsługa przesuwania
        local dragging, dragInput, startPos

        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startPos = input.Position
            end
        end)

        button.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - startPos
                button.Position = UDim2.new(0, button.Position.X.Offset + delta.X, 0, button.Position.Y.Offset + delta.Y)
                startPos = input.Position
            end
        end)

        table.insert(buttons, button)
    end
end

-- Tworzenie przycisków przy starcie
createButtons()
