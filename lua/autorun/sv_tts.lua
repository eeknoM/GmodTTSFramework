-- Ensure the script only runs on the server
if not SERVER then return end

-- Include the configuration file
include("config.lua")

-- Network strings for communication between client and server
util.AddNetworkString("SayTTS")
util.AddNetworkString("TTSEnable")
util.AddNetworkString("TTSChangeVoice")
util.AddNetworkString("TTSChangeModel")
util.AddNetworkString("TTSChangePitch")
util.AddNetworkString("TTSChangeSpeed")

-- Tables to store player TTS preferences
tts_player_enabled = enabled_tts_players or {}
tts_player_voices = tts_player_voices or {}
tts_player_models = tts_player_models or {}
tts_player_pitch = tts_player_pitch or {}
tts_player_speed = tts_player_speed or {}

-- Ensure each TTS model has a corresponding voice table
for model, _ in pairs(tts_models) do
    if not tts_player_voices[model] then
        tts_player_voices[model] = {}
    end
end

-- Handle TTS enable/disable requests
net.Receive("TTSEnable", function(len, pl)
    local enable = net.ReadBool() or false

    pl:SetNWBool("tts_enabled", enable)
    tts_player_enabled[pl:SteamID()] = enable

    if enable then
        pl:ChatPrint("TTS enabled")
    else
        pl:ChatPrint("TTS disabled")
    end

    print("Changed TTS status for " .. pl:Nick())
end)

-- Handle TTS voice change requests
net.Receive("TTSChangeVoice", function(len, pl)
    local sel_voice = net.ReadString():lower()
    local steamID = pl:SteamID()

    -- Ensure the player has a selected model
    if not tts_player_models[steamID] then
        tts_player_models[steamID] = "google"
    end

    local model = tts_player_models[steamID]

    -- Validate the selected voice
    if not tts_voices[model][sel_voice] then
        pl:PrintMessage(1, "Invalid voice! Valid voices:")
        for voice, _ in pairs(tts_voices[model]) do
            pl:PrintMessage(1, voice)
        end
        return
    end

    -- Set the player's selected voice
    tts_player_voices[model][steamID] = tts_voices[model][sel_voice]
    pl:ChatPrint("Set TTS voice to " .. sel_voice)
end)

-- Handle TTS model change requests
net.Receive("TTSChangeModel", function(len, pl)
    local model = net.ReadString():lower()
    local steamID = pl:SteamID()

    -- Validate the selected model
    if not tts_models[model] then
        pl:PrintMessage(1, "Invalid model! Valid models:")
        for model_name, _ in pairs(tts_models) do
            pl:PrintMessage(1, model_name)
        end
        return
    end

    -- Set the player's selected model
    tts_player_models[steamID] = model
    pl:SetNWString("tts_model", model)
    pl:ChatPrint("Set TTS model to " .. model)
end)

-- Handle TTS pitch change requests
net.Receive("TTSChangePitch", function(len, pl)
    local num = tonumber(net.ReadString())
    local steamID = pl:SteamID()

    -- Validate the pitch value
    if not num then
        pl:ChatPrint("Invalid pitch value!")
        return
    elseif num < 50 or num > 400 then
        pl:ChatPrint("Pitch must be between 50 and 400")
        return
    end

    -- Set the player's selected pitch
    tts_player_pitch[steamID] = num
    pl:SetNWInt("tts_pitch", num)
end)

-- Handle TTS speed change requests
net.Receive("TTSChangeSpeed", function(len, pl)
    local num = tonumber(net.ReadString())
    local steamID = pl:SteamID()

    -- Validate the speed value
    if not num then
        pl:ChatPrint("Invalid speed value!")
        return
    elseif num < 50 or num > 250 then
        pl:ChatPrint("Speed must be between 50 and 250")
        return
    end

    -- Set the player's selected speed
    tts_player_speed[steamID] = num
    pl:SetNWInt("tts_speed", num)
end)

-- Helper function to get the first key in a table
local function getFirst(tbl)
    for key, _ in pairs(tbl) do
        return key
    end
end

-- Hook to handle player chat messages
hook.Add("PlayerSay", "TTSsay", function(pl, str, team)
    -- Ignore commands and empty TTS state
    if string.StartWith(str, "!") or string.StartWith(str, "/") then return end
    if not pl:GetNWBool("tts_enabled") then
        print("TTS is not enabled for " .. pl:Nick())
        return
    end

    local steamID = pl:SteamID()
    local model = tts_player_models[steamID] or "bonzi"

    -- Ensure the player has a selected voice
    if not tts_player_voices[model][steamID] then
        tts_player_voices[model][steamID] = tts_voices[model][getFirst(tts_voices[model])]
    end

    local voice = tts_player_voices[model][steamID]
    local pitch = tts_player_pitch[steamID] or 100
    local speed = tts_player_speed[steamID] or 150

    -- Trigger the TTS function
    entSayTTS(pl, str, model, voice, pitch, speed)
end)

-- Function to broadcast the TTS to all clients
function entSayTTS(ent, text, model, voice, pitch, speed)
    if tts_voices[model] and tts_voices[model][voice] then
        voice = tts_voices[model][voice]
    end

    if not voice then
        voice = getFirst(tts_voices[model])
    end

    net.Start("SayTTS")
        net.WriteString(model)
        net.WriteString(text)
        net.WriteString(voice)
        net.WriteInt(speed or 100, 32)
        net.WriteInt(pitch or 150, 32)
        net.WriteEntity(ent)
    net.Broadcast()
end
