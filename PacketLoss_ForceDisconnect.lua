local Stats = GetService(Stats)
local Player = game.Players.LocalPlayer
local PlayerPLoss = game.Players.LocalPlayer:Stats.PacketLossPercent


if PlayerPLoss >_ 70%:Connect(Kick)
{
	print(Player.Name .. " removed for packet loss.")
}
else
{
	halt()
}


function Kick()
{

	Player:Kick("Packet loss!")

}