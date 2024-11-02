--> Part of the Rocloud-Fortuna project.

local DataStoreObject = require("DataStoreObject")
local OpenCloudRequest = require("../../OpenCloudRequest")


export type SetAsyncParams = {
    DataStore: string,
    Key: string,

    FailSafe_OnlySetIfKeyExists: boolean
}

local CloudDataStore = {}
CloudDataStore.__index = CloudDataStore --> i still hate this oop

--// Constructor

function CloudDataStore.new(apiKey: string, universeId: number)    
    assert(type(apiKey) == "string")
    assert(type(universeId) == "number")

    assert(apiKey:len() > 800, "Invalid OpenCloud API key.")

    local self = {
        UniverseId = universeId,

        OpenCloud = OpenCloudRequest.new(apiKey, universeId) 
    }

    setmetatable(self, CloudDataStore)

    return table.freeze(self)
end

--// Object functions

function CloudDataStore:GetDataStore(name: string, scope: string)
  
    assert(
        type(name) == "string" or type(name) == "number",
        `[Rocloud-Fortuna CloudDataStore:GetDataStore]: DataStore "name" field must be a string! Recieved type {typeof(name)}.`
    )

    assert(
        type(scope) == "string" or type(scope) == "number" or scope == nil,
        `[Rocloud-Fortuna CloudDataStore:GetDataStore]: DataStore "scope" field must be a string or nil! Recieved type {typeof(scope)}.`
    )

    if type(scope) == "number" then
        scope = tostring(scope)
    end

    return DataStoreObject.new(name, scope, self.OpenCloud)
end


return CloudDataStore