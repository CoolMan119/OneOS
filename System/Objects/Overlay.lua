Inherit = 'View'

TextColour = colours.black
BackgroundColour = colours.white

OnDraw = function(self, x, y)
	self:UpdateButtons()

	if self.BackgroundColour then
		Drawing.DrawBlankArea(x, y, self.Width, self.Height, self.BackgroundColour)
	end
end

OnLoad = function(self)
	self:GetObject('OneButton').OnClick = function(btn)
		if btn:ToggleMenu('onemenu') then
			self.Bedrock:GetObject('DesktopMenuItem').OnClick = function(itm)
				Current.Desktop:SwitchTo()
			end
		end
	end
end

UpdateButtons = function(self)
	if Current.Program then
		if Current.Program.Environment.OneOS.ToolBarColor ~= colours.white then
			self.BackgroundColour = Current.Program.Environment.OneOS.ToolBarColor
		else
			self.BackgroundColour = Current.Program.Environment.OneOS.ToolBarColour
		end
		
		if Current.Program.Environment.OneOS.ToolBarTextColor ~= colours.black then
			self.TextColour = Current.Program.Environment.OneOS.ToolBarTextColor
		else
			self.TextColour = Current.Program.Environment.OneOS.ToolBarTextColour
		end
	else
		self.BackgroundColour = colours.white
		self.TextColour = colours.black
	end

	for i, v in ipairs(self.Children) do
		if v.TextColour then
			v.TextColour = self.TextColour
		end
	end

	self:RemoveObjects('ProgramButton')

	local x = 6
	for i, program in ipairs(Current.Programs) do
		if not program.Hidden then
			local bg = self.BackgroundColour
			local tc = self.TextColour
			local button = ''
			if Current.Program and Current.Program == program then
				bg = colours.lightBlue
				tc = colours.white
				button = 'x '
			end

			local object = self:AddObject({
		      ["Y"]=1,
		      ["X"]=x,
		      ["Name"]="ProgramButton",
		      ["Type"]="Button",
		      ["Text"]=button..program.Title,
		      ["TextColour"]=tc,
		      ["BackgroundColour"]=bg
		    })
		    x = x + object.Width

			object.Program = program

		    object.OnClick = function(obj, event, side, x, y)
		    	if side == 3 then
		    		obj.Program:Close()
		    	elseif button == 'x ' then
		    		if x == 2 then
		    			obj.Program:Close()
		    		end
		    	else
		    		obj.Program:SwitchTo()
		    	end
		   	end
		end
	end
end