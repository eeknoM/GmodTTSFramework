if not SERVER then return end

include("config.lua")
--AddCSLuaFile("sh_config.lua")

util.AddNetworkString( "SayTTS" )
util.AddNetworkString("TTSEnable")
util.AddNetworkString("TTSChangeVoice")
util.AddNetworkString("TTSChangeModel")
util.AddNetworkString("TTSChangePitch")
util.AddNetworkString("TTSChangeSpeed")

tts_player_enabled = enabled_tts_players or {}

tts_player_voices = tts_player_voices or {}

for _, m in pairs(tts_models) do
	if not tts_player_voices[_] then tts_player_voices[_] = {} end
end

tts_player_models = tts_player_models or {}

tts_player_pitch = tts_player_pitch or {}

tts_player_speed = tts_player_speed or {}

net.Receive("TTSEnable", function(len, pl) 
    local enable = net.ReadBool() or false

    pl:SetNWBool("tts_enabled", enable)

	tts_player_enabled[ pl:SteamID() ] = pl:GetNWBool("tts_enabled")

	if enable then
		pl:ChatPrint("Enabled TTS")
	else
		pl:ChatPrint("Disabled TTS")
	end

    print("Changed TTS status for " .. pl:Nick())
end)

net.Receive("TTSChangeVoice", function(len, pl)
	local sel_voice = net.ReadString()
	sel_voice = string.lower(sel_voice)
	if not tts_player_models[pl:SteamID()] then tts_player_models[pl:SteamID()]  = "google" end

	if not tts_voices[tts_player_models[pl:SteamID()]][sel_voice] then 
		 print("Invalid voice!")
		 pl:PrintMessage(1, "Invalid voice! Valid voices:")
		 for _, voice in pairs (tts_voices[tts_player_models[pl:SteamID()]]) do
			pl:PrintMessage(1, _ )
		 end
		 return  
	end
	tts_player_voices[tts_player_models[pl:SteamID()]][pl:SteamID()] = tts_voices[tts_player_models[pl:SteamID()]][sel_voice]
	pl:ChatPrint("Set TTS voice to " .. sel_voice)
end)


net.Receive("TTSChangeModel", function(len, pl)
	local model = net.ReadString()
	model = string.lower(model)
	if not tts_models[model] then
		print("Invalid model!")
		pl:PrintMessage(1, "Invalid model! Valid models:")
		for _, voice in pairs(tts_models) do
			print(voice)
		   pl:PrintMessage(1, _ )
		end
		return
	end
	tts_player_models[pl:SteamID()] = model
	pl:SetNWString("tts_model", model)
	pl:ChatPrint("Set TTS model to " .. model)
end)

net.Receive("TTSChangePitch", function(len, pl)
	local num = net.ReadString()
	num = tonumber(num)
	if not num then print("Invalid number!") return end 
	if num < 50 then print("Must be > 50") return end
	if num > 400 then print("Must be < 400 ") return end
	tts_player_pitch[pl:SteamID()] = tonumber(num)
	pl:SetNWInt("tts_pitch", num)
end)

net.Receive("TTSChangeSpeed", function(len, pl)
	local num = net.ReadString()
	num = tonumber(num)
	if not num then print("Invalid number!") return end 
	if num < 50 then print("Must be > 50") return end
	if num > 250 then print("Must be < 250 ") return end
	tts_player_speed[pl:SteamID()] = tonumber(num)
	pl:SetNWInt("tts_speed", num)
end)

local function getFirst(tbl)
	for _, t in pairs(tbl) do
		return _
	end
end

hook.Add( "PlayerSay", "TTSsay", function( pl, str, team )

    if string.StartWith(str, "!") or string.StartWith(str,"/") then return end

    if not pl:GetNWBool("tts_enabled") then print("Text to Speech is not enabled for " .. pl:Nick()) return end

	
	if not tts_player_models[pl:SteamID()] then 
		tts_player_models[pl:SteamID()] = "bonzi" 
	end

	local model = tts_player_models[pl:SteamID()]


	if not tts_player_voices[model][pl:SteamID()] then 
		tts_player_voices[model][pl:SteamID()] = tts_voices[model][getFirst(tts_voices[model])] 
	end

	

	local voice = tts_player_voices[model][pl:SteamID()] 
	entSayTTS(pl, str, model,voice,tts_player_pitch[pl:SteamID()] or 100, tts_player_speed[pl:SteamID()] or 150 )


end )

function entSayTTS(ent, text, model, voice, pitch, speed)
	if tts_voices[model] and tts_voices[model][voice] then voice = tts_voices[model][voice] end
	if not voice then voice = getFirst(tts_voices[model]) end
	net.Start( "SayTTS" )
		net.WriteString(model) -- model
		net.WriteString( text ) -- text
		net.WriteString( voice ) -- voice
		net.WriteInt(speed or 100, 32) -- pitch
		net.WriteInt(pitch or 150, 32) -- speed
		net.WriteEntity( ent ) -- entity that sound will come from
	net.Broadcast()
end
