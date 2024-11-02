local envreader = {}
local fs = require("@lune/fs")

-- function to load the .env file and parse it
local function loadEnvFile(filePath)
    local content = fs.readFile(filePath) -- read the file content as a string
    local envVars = {}

    for line in string.gmatch(content, "[^\r\n]+") do
        -- split each line into key-value pairs
        local key, value = string.match(line, "([^=]+)=([^=]+)")
        
        -- Do extra spaces still exist?
        -- I'll leave that issue to future me !!!
        if key and value then
            -- store the key-value pair
            envVars[key] = value
        end
    end

    return envVars
end

function envreader.get(envFilePath: string)
    return loadEnvFile(envFilePath)
end

return envreader