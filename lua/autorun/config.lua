-- If running on the server, add this file to the list of client files to be sent to clients
if SERVER then AddCSLuaFile() end

-- Table containing available text-to-speech (TTS) voices categorized by provider
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
        ["en"] = "en",   -- English
        --["au"] = "au", -- Uncomment this line for Australian English support
        ["ja"] = "ja",   -- Japanese
        ["fr"] = "fr",   -- French
        ["ru"] = "ru",   -- Russian
        ["de"] = "de",   -- German
        ["cs"] = "cs"    -- Czech
    },
    ["murf"] = {
        ["nate"] = "en-US-nate",   -- US English, Nate voice
        ["ethan"] = "en-CA-ethan", -- Canadian English, Ethan voice
        ["hazel"] = "en-UK-hazel"  -- UK English, Hazel voice
    }
}

-- Table mapping TTS providers to their respective processing functions
tts_models = {
    ["google"] = getTTSGoogle,
    ["bonzi"] = getTTSBonzi,
    ["murf"] = getTTSMurf
}

-- Function to convert a character to its hexadecimal representation
local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

-- Function to URL encode a given string
local function urlencode(url)
    if url == nil then
        return ""
    end
    -- Replace newline with carriage return + newline
    url = url:gsub("\n", "\r\n")
    -- Encode all characters except alphanumeric and spaces
    url = url:gsub("([^%w ])", char_to_hex)
    -- Replace spaces with '+'
    url = url:gsub(" ", "+")
    -- Additional replacements for specific characters
    url = string.Replace(url, " ", "+")
    url = string.Replace(url, ",", "%2C")
    return url
end

-- Function to generate a TTS URL for the Bonzi provider
function getTTSBonzi(pl, text, voice, pitch, speed)
    -- Ensure text length does not exceed 100 characters
    text = string.sub(text, 1, 100)
    -- URL encode the text and voice parameters
    text = urlencode(text)
    voice = urlencode(voice)
    
    -- Check if text or voice is empty
    if text == "" or voice == "" then
        print("Error: Invalid text or voice input")
        return nil
    end
    
    -- Construct the Bonzi TTS URL
    local url = "https://www.tetyys.com/SAPI4/SAPI4?text=" .. text .. 
                "&voice=" .. voice .. 
                "&pitch=" .. (pitch or 150) .. 
                "&speed=" .. (speed or 100)
    return url
end

-- Function to generate a TTS URL for the Google provider
function getTTSGoogle(pl, text, voice)
    -- Ensure text length does not exceed 100 characters
    text = string.sub(text, 1, 100)
    -- URL encode the voice parameter
    voice = urlencode(voice)
    
    -- Check if text or voice is empty
    if text == "" or voice == "" then
        print("Error: Invalid text or voice input")
        return nil
    end
    
    -- Construct the Google TTS URL
    return "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=" .. voice .. "&q=" .. text
end

-- Function to generate a TTS URL for the Murf provider
function getTTSMurf(pl, text, voice)
    -- Ensure text length does not exceed 100 characters
    text = string.sub(text, 1, 100)
    -- URL encode the text and voice parameters
    text = urlencode(text)
    voice = urlencode(voice)
    
    -- Check if text or voice is empty
    if text == "" or voice == "" then
        print("Error: Invalid text or voice input")
        return nil
    end
    
    -- Construct the Murf TTS URL
    local url = "https://murf.ai/Prod/anonymous-tts/audio?" .. 
                "name=" .. voice .. 
                "&text=" .. text
    return url
end
