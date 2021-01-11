_G.Architect = {}

_G.Architect.Services = {
	["Workspace"] = game:GetService("Workspace");
	["workspace"] = game:GetService("Workspace");
	["Lighting"] = game:GetService("Lighting");
	["ServerStorage"] = game:GetService("ServerStorage");
	["ReplicatedStorage"] = game:GetService("ReplicatedStorage");
	["Players"] = game:GetService("Players");
	["Chat"] = game:GetService("Chat");
	["CollectionService"] = game:GetService("CollectionService");
	["RunService"] = game:GetService("RunService");
	["Run Service"] = game:GetService("RunService");
	["ServerScriptService"] = game:GetService("ServerScriptService");
	["HttpService"] = game:GetService("HttpService");
	["DataStoreService"] = game:GetService("DataStoreService");
	["DataStore"] = game:GetService("DataStoreService");
	["ScriptContext"] = game:GetService("ScriptContext");
	["TweenService"] = game:GetService("TweenService");
	["TS"] = game:GetService("TweenService");
	["SSS"] = game:GetService("ServerScriptService");
	["MPS"] = game:GetService("MarketplaceService");
	["MarketPlaceService"] = game:GetService("MarketplaceService");
	["Debris"] = game:GetService("Debris");
	["Teams"] = game:GetService("Teams");
	["PathfindingService"] = game:GetService("PathfindingService");
	["PFS"] = game:GetService("PathfindingService");
	["PhysicsService"] = game:GetService("PhysicsService");
}

_G.DataStoreVersion = 3

function _G.Architect:GetService(s)
    return ModuleLoad(s)
end
function _G.Architect:SendSnackBar(plr,txt)
	
	_G.Architect:SendClient(plr,"SnackBar",txt)
end
function _G.Architect:SendClient(plr,...)

	game.ReplicatedStorage.Remotes.Post:FireClient(plr,...)
end