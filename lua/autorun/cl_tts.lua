-- Ensure the script only runs on the client
if SERVER then AddCSLuaFile() return end

-- Include the configuration file
include("config.lua")

-- Toggle TTS functionality
concommand.Add("tts_toggle", function()
    local player = LocalPlayer()
    local currentState = player:GetNWBool("tts_enabled")
    net.Start("TTSEnable")
        net.WriteBool(not currentState)
    net.SendToServer()
end)

-- Change TTS voice
concommand.Add("tts_voice", function(pl, cmd, args)
    if not args[1] then
        print("Error: Missing voice argument.")
        return
    end

    net.Start("TTSChangeVoice")
        net.WriteString(args[1])
    net.SendToServer()
end)

-- Change TTS model
concommand.Add("tts_model", function(pl, cmd, args)
    if not args[1] then
        print("Error: Missing model argument.")
        return
    end

    net.Start("TTSChangeModel")
        net.WriteString(args[1])
    net.SendToServer()
end)

-- Change TTS pitch
concommand.Add("tts_pitch", function(pl, cmd, args)
    local pitch = tonumber(args[1])
    if not pitch then
        print("Error: Invalid pitch value.")
        return
    end

    net.Start("TTSChangePitch")
        net.WriteString(args[1])
    net.SendToServer()
end)

-- Change TTS speed
concommand.Add("tts_speed", function(pl, cmd, args)
    local speed = tonumber(args[1])
    if not speed then
        print("Error: Invalid speed value.")
        return
    end

    net.Start("TTSChangeSpeed")
        net.WriteString(args[1])
    net.SendToServer()
end)

-- Handle incoming TTS network messages
net.Receive("SayTTS", function()
    print("Processing TTS request")

    local model = net.ReadString()
    local text = net.ReadString()
    local voice = net.ReadString()
    local pitch = net.ReadUInt(32)
    local speed = net.ReadUInt(32)
    local pl = net.ReadEntity()

    -- Print debug information
    print("Model: " .. model)
    print("Text: " .. text)

    -- Use a default URL if the model is not found
    local url = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=" .. text
    local ttsFunction = tts_models[model] or tts_models["google"]

    -- Generate the TTS URL
    url = ttsFunction(pl, text, voice, pitch, speed)

    -- Play the TTS sound
    sound.PlayURL(url, "3d", function(sound)
        if IsValid(sound) then
            sound:SetPos(pl:GetPos())
            sound:SetVolume(5)
            sound:Play()
            sound:Set3DFadeDistance(200, 1000)
            pl.sound = sound
        else
            print("Error: Failed to play sound.")
        end
    end)
end)

-- Update the position of TTS sounds to follow players
hook.Add("Think", "FollowPlayerSound", function()
    for _, player in pairs(player.GetAll()) do
        if IsValid(player.sound) then
            player.sound:SetPos(player:GetPos())
        end
    end
end)
