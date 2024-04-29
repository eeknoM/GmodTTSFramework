if SERVER then AddCSLuaFile() end
tts_voices = {
	["bonzi"] = {
    	["female"] = "Adult Female #1, American English (TruVoice)",
    	["male"] = "Adult Male #1, American English (TruVoice)",
    	["mary"] = "Mary",
    	["sam"] = "Sam",
    	["mike"] = "Mike",
    	["female whisper"] = "Female Whisper",
    	["male whisper"] = "Male Whisper",
	},
	["google"] = {
		["en"] = "en",
		--["au"] = "au",
		["ja"] = "ja",
		["fr"] = "fr",
		["ru"] = "ru",
		["de"] = "de",
		["cs"] = "cs"
	},
	["murf"] = {
		["nate"] = "en-US-nate",
		["ethan"] = "en-CA-ethan",
		["hazel"] = "en-UK-hazel"
	}
}
tts_models = {
	["google"] = getTTSGoogle,
	["bonzi"] = getTTSBonzi,
	["murf"] = getTTSMurf
}


--            let e = encodeURI("https://murf.ai/Prod/anonymous-tts/audio?" + "name=" + setvoice + "&text=" + t);
-- "https://murf.ai/Prod/anonymous-tts/audio?" + "name=" + setvoice + "&text=" + t

-- en-US-nate
-- en-CA-ethan
-- en-UK-hazel
-- https://murf.ai/Prod/anonymous-tts/audio?name=en-US-nate&text=Hello

local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
  end
  
  local function urlencode(url)
	if url == nil then
	  return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	url = string.Replace(url, " ", "+")
	url = string.Replace(url, ",", "%2C")
	return url
  end


function getTTSBonzi(pl, text, voice, pitch, speed)
	text = string.sub(text , 1, 100 )
	text = urlencode(text)
	voice = urlencode(voice)
	print("Done")
	local url = "https://www.tetyys.com/SAPI4/SAPI4?text=" .. text  .. "&voice=" .. voice .. "&pitch=" .. (pitch or 150) .. "&speed=" .. (speed or 100)
	return url
end

function getTTSGoogle(pl, text, voice)
	text = string.sub(text , 1, 100 )
	voice = urlencode(voice)
	return "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=" .. voice .. "&q=" .. text
end

function getTTSMurf(pl, text, voice)
	text = string.sub(text , 1, 100 )
	text = urlencode(text)
	voice = urlencode(voice)
	local url = "https://murf.ai/Prod/anonymous-tts/audio?" .. "name=" .. voice .. "&text=" .. text
	return url
end

-- https://www.tetyys.com/SAPI4/SAPI4?text=Helloworld&voice=Sam&pitch=100&speed=150;


-- https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=Hello%20everyone

--[[
	VoiceLimitations: async function(voice)
        {
            let wav = await fetch("/SAPI4/VoiceLimitations?voice=" + encodeURIComponent(voice));
            return wav.json();
        }]]


--[[
    <label for="voice">Select voice:</label>
						<select id="voice" onchange="getVoiceLimits()">
							<option value="Adult Female #1, American English (TruVoice)">Adult Female #1, American English (TruVoice)</option>
							<option value="Adult Female #2, American English (TruVoice)">Adult Female #2, American English (TruVoice)</option>
							<option value="Adult Male #1, American English (TruVoice)">Adult Male #1, American English (TruVoice)</option>
							<option value="Adult Male #2, American English (TruVoice)">Adult Male #2, American English (TruVoice)</option>
							<option value="Adult Male #3, American English (TruVoice)">Adult Male #3, American English (TruVoice)</option>
							<option value="Adult Male #4, American English (TruVoice)">Adult Male #4, American English (TruVoice)</option>
							<option value="Adult Male #5, American English (TruVoice)">Adult Male #5, American English (TruVoice)</option>
							<option value="Adult Male #6, American English (TruVoice)">Adult Male #6, American English (TruVoice)</option>
							<option value="Adult Male #7, American English (TruVoice)">Adult Male #7, American English (TruVoice)</option>
							<option value="Adult Male #8, American English (TruVoice)">Adult Male #8, American English (TruVoice)</option>
							<option value="Female Whisper">Female Whisper</option>
							<option value="Male Whisper">Male Whisper</option>
							<option value="Mary">Mary</option>
							<option value="Mary (for Telephone)">Mary (for Telephone)</option>
							<option value="Mary in Hall">Mary in Hall</option>
							<option value="Mary in Space">Mary in Space</option>
							<option value="Mary in Stadium">Mary in Stadium</option>
							<option value="Mike">Mike</option>
							<option value="Mike (for Telephone)">Mike (for Telephone)</option>
							<option value="Mike in Hall">Mike in Hall</option>
							<option value="Mike in Space">Mike in Space</option>
							<option value="Mike in Stadium">Mike in Stadium</option>
							<option value="RoboSoft Five">RoboSoft Five</option>
							<option value="RoboSoft Four">RoboSoft Four</option>
							<option value="RoboSoft One">RoboSoft One</option>
							<option value="RoboSoft Six">RoboSoft Six</option>
							<option value="RoboSoft Three">RoboSoft Three</option>
							<option value="RoboSoft Two">RoboSoft Two</option>
							<option value="Sam" selected="selected">Sam</option>
                            <option value="Bonzi">BonziBUDDY</option>
						</select>
]]