local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local function getChar()
    local ch = player.Character or player.CharacterAdded:Wait()
    ch:WaitForChild("Humanoid")
    ch:WaitForChild("HumanoidRootPart")
    return ch
end

local character = getChar()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flykey = Enum.Keycode.F
local flySpeed = 40           
local stepDistance = 6           
local verticalSpeed = 20           
local easingStyle = Enum.EasingStyle.Linear

local flying = false
local moveDir = Vector3.zero
local verticalDir = 0        
local currentTween


local function setFlying(state)
    flying = state
    if flying then
        humanoid.PlatformStand = true 
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
    end
end

local function updateMoveDir()
    local dir2d = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        dir2d = dir2d + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        dir2d = dir2d + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        dir2d = dir2d + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        dir2d = dir2d + Vector3.new(1, 0, 0)
    end

    if dir2d.Magnitude > 0 then
        dir2d = dir2d.Unit

        local cam = workspace.CurrentCamera
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector

        local forward = Vector3.new(look.X, 0, look.Z).Unit
        local rightFlat = Vector3.new(right.X, 0, right.Z).Unit

        moveDir = (forward * -dir2d.Z + rightFlat * dir2d.X).Unit
    else
        moveDir = Vector3.zero
    end
end

local function updateVerticalDir()
    local up = UserInputService:IsKeyDown(Enum.KeyCode.Space)
    local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
    if up and not down then
        verticalDir = 1
    elseif down and not up then
        verticalDir = -1
    else
        verticalDir = 0
    end
end

local function stepTween()
    if not flying then return end

    local direction = moveDir
    local vertical = verticalDir

    if direction.Magnitude == 0 and vertical == 0 then
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        return
    end

    local startCFrame = hrp.CFrame
    local offset = Vector3.zero

    if direction.Magnitude > 0 then
        offset = offset + direction * stepDistance
    end
    if vertical ~= 0 then
        offset = offset + Vector3.new(0, vertical * verticalSpeed * (stepDistance / flySpeed), 0)
    end

    local goalPos = startCFrame.Position + offset
    local duration = stepDistance / flySpeed

    if currentTween then
        currentTween:Cancel()
    end

    local tweenInfo = TweenInfo.new(duration, easingStyle, Enum.EasingDirection.InOut)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(goalPos, goalPos + startCFrame.LookVector)})
    currentTween:Play()
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == flyKey then
        setFlying(not flying)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not flying then return end

    if input.KeyCode == Enum.KeyCode.W
    or input.KeyCode == Enum.KeyCode.A
    or input.KeyCode == Enum.KeyCode.S
    or input.KeyCode == Enum.KeyCode.D
    or input.KeyCode == Enum.KeyCode.Space
    or input.KeyCode == Enum.KeyCode.LeftControl then
        updateMoveDir()
        updateVerticalDir()
        stepTween()
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if not flying then return end

    if input.KeyCode == Enum.KeyCode.W
    or input.KeyCode == Enum.KeyCode.A
    or input.KeyCode == Enum.KeyCode.S
    or input.KeyCode == Enum.KeyCode.D
    or input.KeyCode == Enum.KeyCode.Space
    or input.KeyCode == Enum.KeyCode.LeftControl then
        updateMoveDir()
        updateVerticalDir()
    end
end)

RunService.RenderStepped:Connect(function()
    if not flying then return end
    updateMoveDir()
    updateVerticalDir()
    if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
        stepTween()
    end
end)


player.CharacterAdded:Connect(function()
    character = getChar()
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    flying = false
    currentTween = nil
end)
