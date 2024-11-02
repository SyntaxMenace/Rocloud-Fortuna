
local serde = require("@lune/serde")
local net = require("@lune/net")

local OpenCloudRequest = require("../../OpenCloudRequest")

local RequestPaths = {
    Get_Set_Delete = "https://apis.roblox.com/datastores/v1/universes/{universeId}/standard-datastores/datastore/entries/entry",
}

export type OpenCloudHandler = typeof(OpenCloudRequest.new("", 0))

export type SetAsyncParams = {
    FailSafe_OnlySetIfKeyExists: boolean?
}

local DataStoreObject = {}
DataStoreObject.__index = DataStoreObject

-- OpenCloudHandler is an object constructed with OpenCloudRequest.new(apikey, universeid) to make OpenCloud requests. 

function DataStoreObject.new(name: string, scope: string?, OpenCloudHandler: OpenCloudHandler)
    assert(
        type(name) == "string" or type(name) == "number",
        `[Rocloud-Fortuna DataStoreObject.new]: DataStore name must be a string! Recieved type {typeof(name)}.`
    )

    if type(name) == "number" then
        name = tostring(name)
    else
        --> Number values will never actually pass 50 characters

        assert(
            name:len() <= 50,
            `[Rocloud-Fortuna DataStoreObject.new]: DataStore name "{name}" is too long with {name:len()} bytes, expected 50 bytes at most.`
        )
    end

    local self = {
        DataStoreName = name,
        DataStoreScope = scope,

        OpenCloud = OpenCloudHandler :: OpenCloudHandler
    }

    setmetatable(self, DataStoreObject)

    return table.freeze(self)
end

--// Helper functions

local function isJson(str: string): boolean
    if str:match("^%[") or str:match("^{") or str:match("^\"") then
        local success = pcall(net.jsonDecode, str)

        return success
    end

    return false
end

--> Makes a "net" request and only returns the "body" field
-- if the request is failed then that output is to error into the cli.

--// Object functions

function DataStoreObject:SetAsync(Key: string, Data: string, setAsyncParams: SetAsyncParams?): nil
    local self: typeof(DataStoreObject.new("", "", 1)) = self
    
    local setAsyncParams = setAsyncParams or {}

    assert(
        type(Key) == "string" or type(Key) == "number",
        `[Rocloud-Fortuna CloudDataStore:SetAsync] = Expected string while getting DataStore "Key", recieved {typeof(Key)}.`
    )

    if type(Key) == "number" then
        Key = tostring(Key)
    end

    assert(
        type(Data) == "string",
        `[Rocloud-Fortuna CloudDataStore:SetAsync] = Expected string while setting DataStore "Data", recieved {typeof(Data)}.`
    )

    --assert(setAsyncParams.Key, "[Rocloud-Fortuna CloudDataStore:SetAsync] = datastore Key field does not exist! What am I supposed to set?!\n" .. debug.traceback());
    --assert(setAsyncParams.DataStore, "[Rocloud-Fortuna CloudDataStore:SetAsync] = DataStore field does not exist! What am I editing?!\n" .. debug.traceback())

    assert(
        type(setAsyncParams.FailSafe_OnlySetIfKeyExists) == "boolean" or setAsyncParams.FailSafe_OnlySetIfKeyExists == nil,
        `[Rocloud-Fortuna CloudDataStore:SetAsync] = Expected boolean on "FailSafe_OnlySetIfKeyExists", recieved {typeof(setAsyncParams.FailSafe_OnlySetIfKeyExists)}.\n`
    )

    local dataStoreApiPath = RequestPaths.Get_Set_Delete:gsub("{universeId}", self.OpenCloud._universeId)

    self.OpenCloud:HttpPOST(
        dataStoreApiPath,
        net.jsonEncode(Data),
        {
            datastoreName = self.DataStoreName,
            scope = self.DataStoreScope,
            entryKey = Key,

            universeId = tostring(self.UniverseId),

            exclusiveCreate = setAsyncParams.FailSafe_OnlySetIfKeyExists
        }
    )

    return nil
end

function DataStoreObject:GetAsync(Key: string)
    local self: typeof(DataStoreObject.new("", "", 1)) = self

    assert(
        type(Key) == "string" or type(Key) == "number",
        `[Rocloud-Fortuna CloudDataStore:GetAsync] = Expected string while getting DataStore "Key", recieved {typeof(Key)}.`
    )

    local dataStoreApiPath = RequestPaths.Get_Set_Delete:gsub("{universeId}", self.OpenCloud._universeId)


    local GETresponse = self.OpenCloud:HttpGET(
        dataStoreApiPath,
        {
            datastoreName = self.DataStoreName,
            scope = self.DataStoreScope,
            entryKey = Key,

            universeId = tostring(self.UniverseId),
        }
    )

    return 
        if GETresponse.statusCode == 404 then
            nil
        elseif isJson(GETresponse.body) then
            net.jsonDecode(GETresponse.body)
        else
            GETresponse.body
end

return DataStoreObject