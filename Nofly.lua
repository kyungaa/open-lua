local function StartFlyingCheck(Player)
	local HeartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if Player.Character then			
			if Player.Character.Humanoid.FloorMaterial == Enum.Material.Air then				
				if AntiExploit.SuspectTable[Player.UserId] then					
					if not (AntiExploit.SuspectTable[Player.UserId] + 5 > os.time()) then						
						print("flying")						
					else						
						print("not flying")					
					end					
				else					
					AntiExploit.SuspectTable[Player.UserId] = os.time()					
				end				
			else				
				AntiExploit.SuspectTable[Player.UserId] = nil
			end
		end
	end)
end