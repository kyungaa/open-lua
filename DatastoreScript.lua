local dataStoreService = game:GetService('DataStoreService')
local players = game:GetService('Players')
local httpService = game:GetService('HttpService')
local marketplaceService = game:GetService('MarketplaceService')
local replicatedStorage = game:GetService('ReplicatedStorage')

local dataStore = dataStoreService:GetDataStore('PLAYERDATA')

local remotes = replicatedStorage:WaitForChild('Remotes')

local dataFinished = remotes:WaitForChild('DataFinished')
local requestData = remotes:WaitForChild('RequestData')

local playersRequestingData = {}

local defaultData = {
    ['Coins'] = 0;
    ['Wins'] = 0;
    ['Completed Obbies'] = 0;
    ['Inventory'] = {
        ['Accessories'] = {};
        ['Packages'] = {};
        ['Gear'] = {};
        ['Trails'] = {};
    };
    ['Passes'] = {
        ['Premium'] = false;
    };
    ['Rank'] = 'AlphaTester';
    ['Permission'] = 1;
    ['Settings'] = {
        ['UIPrimaryColour'] = {
            ['R'] = 86;
            ['G'] = 146;
            ['B'] = 127;
        };
        ['UISecondaryColour'] = {
            ['R'] = 255;
            ['G'] = 255;
            ['B'] = 255;
        };
        ['UIFont'] = 'SourceSans';
        ['GlobalShadows'] = true;
        ['PlayerMode'] = 'Visible';
        ['ResetKeybind'] = 'R';
    };        
}

local instanceTypes = {
    ['boolean'] = 'BoolValue';
    ['string'] = 'StringValue';
    ['number'] = 'NumberValue';
}

function toboolean(str)
    if string.lower(tostring(str)) == 'true' then
        return true
    elseif string.lower(tostring(str)) == 'false' then
        return false
    else
        return nil
    end
end

function convertDataToInstance(data, folder)
    
    function dataFunction(data, folder)
        for i,v in pairs(data) do
            local boolean = toboolean(v)
            if boolean ~= nil then
                data[i] = boolean
            end
            local number = tonumber(v)
            if number then
                data[i] = number
            end
            if typeof(v) == 'table' then
                local currentFolder = Instance.new('Folder', folder)
                currentFolder.Name = i
                dataFunction(v, currentFolder)
            else
                for i2,v2 in pairs(instanceTypes) do
                    if typeof(v) == i2 then
                        local currentValue = Instance.new(v2, folder)
                        currentValue.Name = i
                        currentValue.Value = v
                    end
                end
            end
        end
    end
    dataFunction(data, folder)
    
    dataFinished:FireClient(folder.Parent)
end


local function verifyData(data, player)

    function verifyCurrentTable(tableToVerify, currentIteration)
        local tableToReturn = {}
        for i,v in pairs(currentIteration) do
            if tableToVerify[i] then
                tableToReturn[i] = tableToVerify[i]
                if typeof(tableToVerify[i]) == 'table' then
                    tableToReturn[i] = tableToVerify[i]
                    verifyCurrentTable(tableToReturn[i], v)
                else
                    tableToReturn[i] = tableToVerify[i]
                end
            else
                tableToReturn[i] = v
            end
        end
        return tableToReturn
    end
    local dataFolder = Instance.new('Folder', player)
    dataFolder.Name = 'PlayerData'

    local newData = verifyCurrentTable(data, defaultData)

    if newData['Passes']['Premium'] == false then
        if marketplaceService:UserOwnsGamePassAsync(player.UserId, 13535231) then
            newData['Passes']['Premium'] = true
        end
    end

    if newData['Passes']['Premium'] then
        newData['Rank'] = 'Premium'
    end

    convertDataToInstance(newData, dataFolder)
end

requestData.OnServerInvoke = function(player)
    local key = 'PLAYERDATA_'..player.UserId

    local data
    
    if not table.find(playersRequestingData, player) then
        table.insert(playersRequestingData, #playersRequestingData + 1, player)
        coroutine.wrap(function()
            wait(6)
            table.remove(playersRequestingData, table.find(playersRequestingData, player))
        end)()
    else
        return player:Kick('Too many data requests!')
    end
    
    local successful, errorMessage = pcall(function()
        data = dataStore:GetAsync(key)
    end)
    print(data)
    if successful then
        if not data then
            data = defaultData
        end
        verifyData(data, player)
    else
        print(tostring(errorMessage))
    end
    return successful
end

function saveData(player)
    local key = 'PLAYERDATA_'..player.UserId
    local playerFolder = player:FindFirstChild('PlayerData')

    function convertInstanceToData(currentFolder)
        local returnedData = {}
        for i,v in pairs(currentFolder:GetChildren()) do
            if v:IsA('Folder') then
                returnedData[v.Name] = convertInstanceToData(v)
            else
                returnedData[v.Name] = v.Value
            end
        end
        return returnedData
    end

    local constructedTable = convertInstanceToData(playerFolder)

    print(constructedTable)

    local successful, errorMessage = pcall(function()
        dataStore:SetAsync(key, constructedTable)
    end)

    if not successful then
        warn(tostring(errorMessage))
    end
end

players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
    for i, player in pairs(players:GetPlayers()) do
        saveData(player)
    end
end)