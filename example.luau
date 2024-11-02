local env = require("envparser").get(".env")
local Rocloud = require("RocloudFortuna")

local OpenCloudApiKey = env["OpenCloud-ApiKey"]
local UniverseId = tonumber(env["UniverseID"])

local FortunaAPI = Rocloud(OpenCloudApiKey, UniverseId)

local DataStoreService = FortunaAPI.v1.DataStore

local TestStore = DataStoreService:GetDataStore("OpenCloudTesting")

print(TestStore:SetAsync("Message", "Hello from lune!"))

print(TestStore:GetAsync("Message"))

-- Currently only supports datastore get and set :c

-- maintainers needed