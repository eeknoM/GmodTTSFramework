if SERVER then AddCSLuaFile() return end

include("config.lua")

concommand.Add("tts_toggle", function()
	net.Start("TTSEnable")
		net.WriteBool(not LocalPlayer():GetNWBool("tts_enabled"))
	net.SendToServer()
end)

concommand.Add("tts_voice", function(pl,cmd, args)
	if not args[1] then print("Missing voice") return end
	net.Start("TTSChangeVoice")
		net.WriteString(args[1])
	net.SendToServer()
end)

concommand.Add("tts_model", function(pl,cmd, args)
	if not args[1] then print("Missing model") return end
	net.Start("TTSChangeModel")
		net.WriteString(args[1])
	net.SendToServer()
end)

concommand.Add("tts_pitch", function(pl, cmd, args)
	if not args[1] then print("Missing pitch") return end
	if not tonumber(args[1]) then print("Invalid number") return end
	net.Start("TTSChangePitch")
		net.WriteString(args[1])
	net.SendToServer()
end)

concommand.Add("tts_speed", function(pl, cmd, args)
	if not args[1] then print("Missing speed") return end
	if not tonumber(args[1]) then print("Invalid number") return end
	net.Start("TTSChangeSpeed")
		net.WriteString(args[1])
	net.SendToServer()
end)


net.Receive( "SayTTS",  function()
	print("Processing tts")
	local model = net.ReadString()
	local text = net.ReadString()
	local voice = net.ReadString()
	local pitch = net.ReadUInt(32)
	local speed = net.ReadUInt(32)
	local pl = net.ReadEntity()

	print("MODDEL: " .. model)
	local url = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=" .. text -- BACKUP URL

	f = tts_models[model] or "google"

	url = f(pl, text, voice, pitch, speed)

	sound.PlayURL( url , "3d", function( sound )

		if IsValid( sound ) then
			sound:SetPos( ply:GetPos() )
			sound:SetVolume( 5 )
			sound:Play()
			sound:Set3DFadeDistance( 200, 1000 )
			pl.sound = sound
		end

	end)

end )

hook.Add( "Think", "FollowPlayerSound", function()
	for k,v in pairs( player.GetAll() ) do
		if IsValid( v.sound ) then
			v.sound:SetPos( v:GetPos() )
		end
	end
end )