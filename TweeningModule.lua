  function TweeningModule.Tween(Speed, Obj, PropIndies, TargetValue, InitialValue, EasingDirection, EasingStyle, functionToRun)
	if Obj == nil or Obj and Obj.Parent == nil then return end
	
	for _,PropIndex in pairs (PropIndies) do
		
		-- Create number value for referencing the tween
		local val = Instance.new("NumberValue")
		val.Value = InitialValue or Obj[PropIndex]
		
		local tween = TweenService:Create(
			val,
			TweenInfo.new( Speed, EasingStyle or Enum.EasingStyle.Linear,
				EasingDirection or Enum.EasingDirection.Out
			), 
			{Value = TargetValue}
		)
		
		-- Create object dictionary if not exists
		if TweeningObjs[Obj] == nil then
			TweeningObjs[Obj] = {}
		end
		
		--[[
			Inserting 2 things to the dictionary: Tag and the property index.
			The tag is used when a tween is being overrided by a new tween.
			The property index is used to distinguish whether the property is being overrided by a new tween.
		--]]
		
		local tag = tick()
		local ind = #TweeningObjs[Obj] + 1
		-- Check is this property already being added. (It should be already added if this is overwriting an existing tween, if it is, replace with a new tag.)
		for i,v in pairs (TweeningObjs[Obj]) do
			if v.Prop == PropIndex then
				ind = i
				break
			end
		end	
		
		TweeningObjs[Obj][ind] = {Tag = tag, Prop = PropIndex}
		
		tween:Play()
		
		--[[
			Function to terminate a tween:
			When a tween is completed or overwritten, this will be called.
			If it is overrided, it will keep the object dictionary for the upcoming overrided tween, or else remove it from the dictionary.
		--]]
		
		local conn
		local function Terminate(IsOverrided)
			if conn then
				conn:Disconnect()
				conn = nil
			end
			if val then
				val:Destroy()
				val = nil
			end
						
			if IsOverrided ~= true then
				TweeningObjs[Obj] = nil
				if functionToRun and type(functionToRun) == "function" then
					functionToRun()
				end
			end
			
			--[[
				The print code below is to test whether dictionaries are getting removed correctly when the tween completes
				in order to remove unnecessary and unused dictionaries to prevent memory leak.
				It should print {}.
			--]]
			--print(TweeningObjs)
			tween = nil
		end	
		
		-- Constantly setting the object's value.
		conn = RunService.RenderStepped:Connect(function(dt)
			if TweeningObjs[Obj] then
				-- Match the property.
				for i,v in pairs (TweeningObjs[Obj]) do
					if v.Prop == PropIndex then
						-- If the tag has been changed, it means it got overrided.
						if v.Tag == tag then
							Obj[PropIndex] = val.Value
						else
							conn:Disconnect()
							conn = nil
							tween:Pause()
							Terminate(true)
						end
						break
					end
					
				end		
			end
		end)
		
		PropIndies, TargetValue, InitialValue, EasingDirection, EasingStyle = nil,nil,nil,nil,nil
		tween.Completed:Connect(Terminate)
	end

end