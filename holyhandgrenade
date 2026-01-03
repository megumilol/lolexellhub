local gernade = game:GetObjects("rbxassetid://13074073903")[1]
gernade.Parent = game.Players.LocalPlayer.Backpack
local humanoid = game.Players.LocalPlayer.Character.Humanoid
gernade.Equipped:Connect(function()
    local anm = gernade.Animations.idle
    humanoid:LoadAnimation(anm):Play()
end)
gernade.Unequipped:Connect(function()
    for i,animation in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        animation:Stop()
    end
end)
gernade.Activated:Connect(function()
    local anm = gernade.Animations.throw
    humanoid:LoadAnimation(anm):Play()
    task.wait(0.5)
    local sound = gernade.throwsound
    sound:Play()
    local pos = game.Players.LocalPlayer:GetMouse().Hit
    local throwngernade = gernade.Handle:Clone()
    throwngernade.Parent = game.Workspace
    throwngernade.Position = game.Players.LocalPlayer.Character.RightHand.Position
    local bv = Instance.new("BodyVelocity",throwngernade)
    bv.Velocity = pos.LookVector * 50
    throwngernade.CanCollide = true
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 5
    light.Parent = throwngernade
    task.wait(0.2)
    bv:Destroy()
    local bouncesound = Instance.new("Sound")
    bouncesound.SoundId = "rbxassetid://12939209801"
    bouncesound.Volume = 10
    bouncesound.Parent = throwngernade
    local counter = 0
    repeat
    bouncesound:Play()
    counter += 1
    task.wait(0.2 + counter/10)
    until counter == 3
    throwngernade.Anchored = true
    light.Brightness = 10
    light.Range = 10
    local beforeexplodesound = Instance.new("Sound")
    beforeexplodesound.SoundId = "rbxassetid://6152971423"
    beforeexplodesound.Volume = 10
    beforeexplodesound.Parent = throwngernade
    beforeexplodesound:Play()
    beforeexplodesound.Ended:wait()
    light.Brightness = 25
    light.Range = 30
    local explodesound = Instance.new("Sound")
    explodesound.SoundId = "rbxassetid://12939357117"
    explodesound.Volume = 10
    explodesound.Parent = throwngernade
    explodesound:Play()
    local nearbyParts = game.Workspace:GetPartBoundsInBox(throwngernade.CFrame,Vector3.new(30,30,30))
    local forcetable = {}
    for _, part in ipairs(nearbyParts) do
        local check = false
        local partname = part.name
        if string.find(partname,"Wall") or string.find(partname,"Floor") then
            check = true
        end
        if check == false then
            part.Anchored = false
            local distance = (part.Position - throwngernade.Position).Magnitude
            local force = (15 - distance) * 100 -- adjust this multiplier as needed
            local bodyforce = Instance.new("BodyVelocity",part)
            bodyforce.Velocity = (force * (part.Position - throwngernade.Position).Unit)
            table.insert(forcetable,bodyforce)
            part.CFrame = part.CFrame * CFrame.new(math.random(1,5),0,math.random(1,5))
        end
    end
    task.wait(0.1)
    for i,aforce in ipairs(forcetable) do
        aforce:Destroy()
    end
    explodesound.Ended:wait()
    throwngernade:Destroy()
end)
