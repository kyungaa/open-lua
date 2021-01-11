local ToolsManager = {}
local Rewards = {
	["Chocolate Milk"] = {
		["Stat"] = "HighestTime";
		["Value"] = 100
	};

	["Burger"] = {
		["Stat"] = "HighestTime";
		["Value"] = 250
	};

	["Camo Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 500;
		["GamepassOption"] = 10804695
	};

	["Divine Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 1000;
		["GamepassOption"] = 10804695
	};

	["Golden Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 2000;
		["GamepassOption"] = 10804695
	};

	["Inferno Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 5000;
		["GamepassOption"] = 10804695
	};

	["Cosmic Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 25000
	};

	["Void Sword"] = {
		["Stat"] = "HighestTime";
		["Value"] = 10000;
		["GamepassOption"] = 12557549
	};

	["Venomshank"] = {
		["Stat"] = "Kills";
		["Value"] = 15000
	};
	["Darkheart"] = {
		["Stat"] = "Kills";
		["Value"] = 50000
	};
	["Electric Sword"] = {
		["Stat"] = "Kills";
		["Value"] = 100000
	};
	["Santa Sword"] = {
		["GamepassOption"] = 13337064;
	};
	["Sign"] = {
		["GamepassOption"] = 13077060;
	};
	["Radio"] = {
		["GamepassOption"] = 11260445;
	};
	["Turkey Sword"] = {
		["BadgeOption"] = 2124632918;
	};
	["Firework Sword"] = {
		["BadgeOption"] = 2124660253;
	};
	["Crystal Sword"] = {
		["BadgeOption"] = 2124648944;
	};
	["Ghost Sword"] = {
		["BadgeOption"] = 2124614709;
	};
	["Haunted Sword"] = {
		["BadgeOption"] = 2124620407;
	};
	["Admin Sword"] = {
		["GroupOption"] = 7373551;
	};
	["Invisible"] = {
		["GroupOption"] = 7373551;
	};
}

local MarketplaceService = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")
local PlayerItems = {}
local PassCache = {}
local BadgeCache = {}
local GroupCache = {}

local DefaultIndex = {
	__index = function()
		return {"Sword"}
	end
}
setmetatable(PlayerItems,DefaultIndex)


function ToolsManager:GetPlayerIndex(UserID)
	return PlayerItems[tostring(UserID)]
end

local function HasPass(Player,ID)
	if PassCache[Player.UserId] and PassCache[Player.UserId][ID] == true then
		return true
	else
		local Has = MarketplaceService:UserOwnsGamePassAsync(Player.UserId,ID)
		if Has then
			local Index = PassCache[Player.UserId]
			if not Index then
				PassCache[Player.UserId] = {}
			end
			Index = PassCache[Player.UserId]
			Index[ID] = true
			return true
		end
	end
	return false
end

local function HasBadge(Player,ID)
	if BadgeCache[Player.UserId] and BadgeCache[Player.UserId][ID] == true then
		return true
	else
		local Has = BadgeService:UserHasBadgeAsync(Player.UserId,ID)
		if Has then
			local Index = BadgeCache[Player.UserId]
			if not Index then
				BadgeCache[Player.UserId] = {}
			end
			Index = BadgeCache[Player.UserId]
			Index[ID] = true
			return true
		end
	end
	return false
end

local function InGroup(Player,ID)
	if GroupCache[Player.UserId] and GroupCache[Player.UserId][ID] == false then
		return false
	else
		local In = Player:IsInGroup(ID)
		if In then
			return true
		else
			local Index = GroupCache[Player.UserId]
			if not Index then
				GroupCache[Player.UserId] = {}
			end
			Index = GroupCache[Player.UserId]
			Index[ID] = false
			return false
		end
	end
end

function ToolsManager:IndexPlayer(player) -- PlayerObject
	-- print("Received request to index " .. player.Name .. " in module")
	local Leaderstats = player:WaitForChild("leaderstats")
	-- print("Found " .. player.Name .. "'s leaderstats")
	if Leaderstats then
		-- print("Confirmed " .. player.Name .. "'s leaderstats existed")
		local LeaderstatVals = {}
		LeaderstatVals.HighestTime = Leaderstats.HighestTime.Value
		LeaderstatVals.CurrentTime = Leaderstats.Time.Value
		LeaderstatVals.Kills = Leaderstats.Kills.Value
		local ToolsPlayerHas = PlayerItems[tostring(player.UserId)] or {}
		for ToolName,ToolInfo in pairs (Rewards) do
			if ToolInfo.GamepassOption and not table.find(ToolsPlayerHas,ToolName) then
				--// Item can be obtained via gamepass
				if HasPass(player,ToolInfo.GamepassOption) then
					table.insert(ToolsPlayerHas,ToolName)
					-- print("Added " .. ToolName .. " to " .. player.Name .. "'s index because they own the gamepass for it")
				else
					--// Item cannot be obtained via gamepass
				end
			end
			if ToolInfo.BadgeOption and not table.find(ToolsPlayerHas,ToolName) then
				--// Item can be obtained via badge
				if HasBadge(player,ToolInfo.BadgeOption) then
					table.insert(ToolsPlayerHas,ToolName)
				--	 print("Added " .. ToolName .. " to " .. player.Name .. "'s index because they have the badge for it")
				end
			end
			if ToolInfo.GroupOption and not table.find(ToolsPlayerHas,ToolName) then
				--// Item can be obtained via group
				if InGroup(player, ToolInfo.GroupOption) then
					table.insert(ToolsPlayerHas,ToolName)
					-- print("Added " .. ToolName .. " to " .. player.Name .. "'s index because they have the badge for it")
				end
			end
			local StatRequired = ToolInfo.Stat
			if StatRequired then
				if LeaderstatVals[StatRequired] and not table.find(ToolsPlayerHas,ToolName) then
					if LeaderstatVals[StatRequired] >= ToolInfo.Value then
						table.insert(ToolsPlayerHas,ToolName)
						-- print("Added " .. ToolName .. " to " .. player.Name .. "'s index because they have the correct for stats for it")

					end
				else
					-- print(player.Name .. " does not have " .. StatRequired .. " in their leaderstats")
				end
			else
				-- print("No stat set for " .. ToolName)
			end

		end
		PlayerItems[tostring(player.UserId)] = ToolsPlayerHas
		return ToolsPlayerHas
	end
end

spawn(function()
	while true do
		wait(60)
		PassCache = {}
		BadgeCache = {}
		GroupCache = {}
	end
end)

return ToolsManager