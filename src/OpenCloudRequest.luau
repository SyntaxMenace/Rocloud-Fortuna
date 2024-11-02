--// Rocloud-Fortuna OpenCloudRequest.luau

local serde = require("@lune/serde")
local net = require("@lune/net")

local base64 = require("Base64")

local OpenCloudRequest = {}
OpenCloudRequest.__index = OpenCloudRequest

local function generateGUID()
    local template = "xxxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx"

    return template:gsub("[xy]", function(c)
        local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
        return string.format("%x", v)
    end)
end

-- Using this function until Lune adds support for serde digest encoding
local function md5_base64digest(message)
    local hex = serde.hash("md5", message)
    local digest = buffer.create(#hex / 2)

    for index = 0, #hex - 1, 2 do
        buffer.writeu8(digest, index // 2, tonumber(hex:sub(index + 1, index + 2), 16) :: number)
    end

    return base64.encode(buffer.tostring(digest))
end

--> Hopefully developers don't leak their API key even when its like this (unless..?)
local apiKey_store: {[string]: string} = {}

-- This is good-practice for me too, I can push code without worrying about this module leaking keys.

function OpenCloudRequest.new(apiKey: string, universeId: number)
    assert(type(apiKey) == "string")

    assert(apiKey:len() > 800, "APIKey is too small to be a Roblox OpenCloud key. Please use the correct OpenCloud key provided by Roblox.")

    local keyId = generateGUID()
    
    apiKey_store[keyId] = apiKey

    local self = {
        _apiKeyId = keyId, --> to fetch later from "apiKey_store", we're not directly storing this in the table.
        _universeId = universeId
    }

    setmetatable(self, OpenCloudRequest)

    return self
end

function OpenCloudRequest:HttpGET(path: string, query: net.HttpQueryMap)
    assert(
        type(path) == "string",
        `[Rocloud-Fortuna OpenCloudRequest:HttpGET]: Expected type string on path, recieved {typeof(path)}.\n`
    )
    
    local self: typeof(OpenCloudRequest.new("", 0)) = self

    local fetchResponse = net.request({
        method = "GET",
        url = path :: string,

        headers = {
            ["x-api-key"] = apiKey_store[self._apiKeyId],
        },

        query = query,
    })

    return fetchResponse
end


function OpenCloudRequest:HttpPOST(path: string, body: string | buffer, query: net.HttpQueryMap)
    assert(
        type(path) == "string",
        `[Rocloud-Fortuna OpenCloudRequest:HttpPOST]: Expected type string on path, recieved {typeof(path)}.\n`
    )

    local self: typeof(OpenCloudRequest.new("", 0)) = self

    local fetchResponse = net.request({
        method = "POST",
        url = path :: string,

        body = body,

        headers = {
            ["Content-Type"] = "application/json",
            ["content-md5"] = md5_base64digest(body),
            ["x-api-key"] = apiKey_store[self._apiKeyId],
        },

        query = query
    })

    
    if fetchResponse.statusCode >= 400 then
        error(fetchResponse)
    end

    return fetchResponse
end

function OpenCloudRequest:HttpPATCH(path: string, body: string | buffer)
    assert(
        type(path) == "string",
        `[Rocloud-Fortuna OpenCloudRequest:HttpPATCH]: Expected type string on path, recieved {typeof(path)}.\n`
    )

    local self: typeof(OpenCloudRequest.new("", 0)) = self
    
    local fetchResponse = net.request({
        method = "PATCH",
        url = path :: string,

        body = body,

        headers = {
            ["content-md5"] = md5_base64digest(body),
            ["x-api-key"] = apiKey_store[self._apiKeyId],
        },
    })

    
    if fetchResponse.statusCode >= 400 then
        error(fetchResponse)
    end

    return fetchResponse
end

function OpenCloudRequest:HttpDELETE(path: string)
    assert(
        type(path) == "string",
        `[Rocloud-Fortuna OpenCloudRequest:HttpDELETE]: Expected type string on path, recieved {typeof(path)}.\n`
    )

    local self: typeof(OpenCloudRequest.new("", 0)) = self
    
    local fetchResponse = net.request({
        method = "PATCH",

        url = path :: string,

        headers = {
            ["x-api-key"] = apiKey_store[self._apiKeyId],
        },
    })
    
    if fetchResponse.statusCode >= 400 then
        error(fetchResponse)
    end

    return fetchResponse
end

return OpenCloudRequest