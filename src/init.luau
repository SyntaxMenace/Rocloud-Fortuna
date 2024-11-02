
--> Lune does not allow require() to be called in metamethods
--: it's the best to leave this out of the scope.
local APIv1 = {
    DataStore = require("v1/DataStore"),
}

local _APIv2 = {

}

return function(apiKey: string, universeId: number)
    assert(type(apiKey) == "string", `[Rocloud Fortuna]: expected string for "apiKey" on argument #1, recieved {typeof(apiKey)}.`)
    assert(type(universeId) == "number", `[Rocloud Fortuna]: expected number for "universeId" on argument #2, recieved {typeof(universeId)}.`)


    local self = {
        v1 = {
            DataStore = APIv1.DataStore.new(apiKey, universeId)
        },
        v2 = {}
    }

    return table.freeze(self)
end
