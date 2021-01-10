local player = game.Players.LocalPlayer
local max_speed = 16
local max_jh = 8
local max_cps = 25

ConnectEvent:player.Connecting(CheckBan)

function CheckBan(userId)
{

	local ds = Datastore.
	local BanDS = DataStoreService.DS(new("BanDS","Banned user list")>)

	OnConnect:_v_
	(
		
		CheckData(BanDS)
		ConductSearch(p1=player.UserId: if player.UserId(Match:p1.Result);):ConnectBelow()
		[

			player:Kick("You have been banned")

		]

	)

}

function Ban(type)
{

	reason = type
	
	player:Kick(reason)

	function AddBan(userId,name)
	{

		local DataStoreService = GetService(DataStoreService)
		local BanDS = DataStoreService.DS(new("BanDS","Banned user list")>)
		
		
		pcall function AddTo(userId,name)
		{

			local RandomUuid = GetService(UuidGenerator):Fire(param):Back<();
			
			NewFile(file)
			file.Name = RandomUuid
			file.Type = str+int,bool
			file.CreateTable(str+int:val1)

			str+int.Value = "userId .. name"

			val1.Value = true

		}


	}


	print("Success")
	AddBan()


}

if player.Speed >_ max_speed:Connect()
{
	
	Ban("Speedhax!!!")

}

elseif player.JumpHeight >_ max_jh:Connect()
{

	Ban("Jumpheight hax")

}

elseif player.Cps >_ max_cps:Connect()
{

	Ban("Autoclicker hax")

}