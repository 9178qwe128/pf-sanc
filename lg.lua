-- [[ // Error Handling // ]]
local Passed, Statement = pcall(function()
	-- [[ // Libraries // ]]
	local library = {
		Renders = {},
		Connections = {},
		Folder = "PuppyWare", -- Change if wanted
		Assets = "Assets", -- Change if wanted
		Configs = "Configs" -- Change if wanted
	}
	local utility = {}
	-- [[ // Tables // ]]
	local pages = {}
	local sections = {}
	-- [[ // Indexes // ]]
	do
		library.__index = library
		pages.__index = pages
		sections.__index = sections
	end
	-- [[ // Variables // ]] 
	local tws = game:GetService("TweenService")
	local uis = game:GetService("UserInputService")
	local cre = game:GetService("CoreGui")
	-- [[ // Functions // ]]
	function utility:RenderObject(RenderType, RenderProperties, RenderHidden)
		local Render = Instance.new(RenderType)
		--
		if RenderProperties and typeof(RenderProperties) == "table" then
			for Property, Value in pairs(RenderProperties) do
				if Property ~= "RenderTime" then
					Render[Property] = Value
				end
			end
		end
		--
		library.Renders[#library.Renders + 1] = {Render, RenderProperties, RenderHidden, RenderProperties["RenderTime"] or nil}
		--
		return Render
	end
	--
	function utility:CreateConnection(ConnectionType, ConnectionCallback)
		local Connection = ConnectionType:Connect(ConnectionCallback)
		--
		library.Connections[#library.Connections + 1] = Connection
		--
		return Connection
	end
	--
	function utility:MouseLocation()
		return uis:GetMouseLocation()
	end
	--
	function utility:Serialise(Table)
		local Serialised = ""
		--
		for Index, Value in pairs(Table) do
			Serialised = Serialised .. Value .. ", "
		end
		--
		return Serialised:sub(0, #Serialised - 2)
	end
	--
	function utility:Sort(Table1, Table2)
		local Table3 = {}
		--
		for Index, Value in pairs(Table2) do
			if table.find(Table1, Index) then
				Table3[#Table3 + 1] = Value
			end
		end
		--
		return Table3
	end
	-- [[ // UI Functions // ]]
	function library:CreateWindow(Properties)
		Properties = Properties or {}
		--
		local Window = {
			Pages = {},
			Accent = Color3.fromRGB(255, 120, 30), -- Color3.fromRGB(136, 180, 57) -- Change if wanted
			Enabled = true,
			Key = Enum.KeyCode.Z -- Change if wanted
		}
		--
		do
			local ScreenGui = utility:RenderObject("ScreenGui", {
				DisplayOrder = 9999,
				Enabled = true,
				IgnoreGuiInset = true,
				Parent = cre,
				ResetOnSpawn = false,
				ZIndexBehavior = "Global"
			})
			-- //
			local ScreenGui_MainFrame = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(12, 12, 12),
				BorderMode = "Inset",
				BorderSizePixel = 1,
				Parent = ScreenGui,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 660, 0, 560)
			})
			-- //
			local ScreenGui_MainFrame_InnerBorder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = ScreenGui_MainFrame,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2)
			})
			-- //
			local MainFrame_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(60, 60, 60),
				BorderMode = "Inset",
				BorderSizePixel = 1,
				Parent = ScreenGui_MainFrame,
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(1, -6, 1, -6)
			})
			-- //
			local InnerBorder_InnerFrame_Tabs = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 4),
				Size = UDim2.new(0, 74, 1, -4)
			})
			--
			local InnerBorder_InnerFrame_Pages = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(1, 0, 0, 4),
				Size = UDim2.new(1, -73, 1, -4)
			})
			--
			local InnerBorder_InnerFrame_TopGradient = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 4)
			})
			-- //
			local InnerFrame_Tabs_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 4),
				Parent = InnerBorder_InnerFrame_Tabs,
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Top"
			})
			--
			local InnerFrame_Tabs_Padding = utility:RenderObject("UIPadding", {
				Parent = InnerBorder_InnerFrame_Tabs,
				PaddingTop = UDim.new(0, 9)
			})
			--
			local InnerFrame_Pages_InnerBorder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerBorder_InnerFrame_Pages,
				Position = UDim2.new(0, 1, 0, 0),
				Size = UDim2.new(1, -1, 1, 0)
			})
			--
			local InnerFrame_TopGradient_Gradient = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerBorder_InnerFrame_TopGradient,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				Image = "rbxassetid://8508019876",
				ImageColor3 = Color3.fromRGB(255, 255, 255)
			})
			-- //
			local Pages_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerFrame_Pages_InnerBorder,
				Position = UDim2.new(0, 1, 0, 0),
				Size = UDim2.new(1, -1, 1, 0)
			})
			-- //
			local InnerBorder_InnerFrame_Folder = utility:RenderObject("Folder", {
				Parent = Pages_InnerBorder_InnerFrame
			})
			--
			local InnerBorder_InnerFrame_Pattern = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Pages_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Image = "rbxassetid://8547666218",
				ImageColor3 = Color3.fromRGB(12, 12, 12),
				ScaleType = "Tile",
				TileSize = UDim2.new(0, 8, 0, 8)
			})
			--
			do -- // Functions
				function Window:SetPage(Page)
					for index, page in pairs(Window.Pages) do
						if page.Open and page ~= Page then
							page:Set(false)
						end
					end
				end
				--
				function Window:Fade(state)
					if state then
						ScreenGui.Enabled = true
					else
						task.delay(0.3, function()
							if not Window.Enabled then
								ScreenGui.Enabled = false
							end
						end)
					end
					--
					for index, render in pairs(library.Renders) do
						if not render[3] then
							if render[1].ClassName == "Frame" and (render[2]["BackgroundTransparency"] or 0) ~= 1 then
								tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
							elseif render[1].ClassName == "ImageLabel" then
								if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
								end
								--
								if (render[2]["ImageTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ImageTransparency = state and (render[2]["ImageTransparency"] or 0) or 1}):Play()
								end
							elseif render[1].ClassName == "TextLabel" then
								if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
								end
								--
								if (render[2]["TextTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {TextTransparency = state and (render[2]["TextTransparency"] or 0) or 1}):Play()
								end
							elseif render[1].ClassName == "ScrollingFrame" then
								if (render[2]["BackgroundTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1}):Play()
								end
								--
								if (render[2]["ScrollBarImageTransparency"] or 0) ~= 1 then
									tws:Create(render[1], TweenInfo.new(render[4] or 0.25, Enum.EasingStyle["Linear"], state and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ScrollBarImageTransparency = state and (render[2]["ScrollBarImageTransparency"] or 0) or 1}):Play()
								end
							end
						end
					end
				end
				--
				function Window:Unload()
					ScreenGui:Remove()
					--
					for index, connection in pairs(library.Connections) do
						connection:Disconnect()
					end
					--
					library = nil
					utility = nil
				end
			end
			--
			do -- // Index Setting
				Window["TabsHolder"] = InnerBorder_InnerFrame_Tabs
				Window["PagesHolder"] = InnerBorder_InnerFrame_Folder
			end
			--
			do -- // Connections
				utility:CreateConnection(uis.InputBegan, function(Input)
					if Input.KeyCode and Input.KeyCode == Window.Key then
						Window.Enabled = not Window.Enabled
						--
						Window:Fade(Window.Enabled)
					elseif Input.KeyCode and Input.KeyCode == Enum.KeyCode.X then
						Window.Enabled = not Window.Enabled
						--
						Window:Fade(Window.Enabled)
					end
				end)
			end
		end
		--
		return setmetatable(Window, library)
	end
	--
	function library:CreatePage(Properties)
		Properties = Properties or {}
		--
		local Page = {
			Image = (Properties.image or Properties.Image or Properties.icon or Properties.Icon),
			Size = (Properties.size or Properties.Size or UDim2.new(0, 50, 0, 50)),
			Open = false,
			Window = self
		}
		--
		do
			local Page_Tab = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page.Window["TabsHolder"],
				Size = UDim2.new(1, 0, 0, 72)
			})
			-- //
			local Page_Tab_Border = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = false,
				ZIndex = 2,
				RenderTime = 0.15
			})
			--
			local Page_Tab_Image = utility:RenderObject("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = Page.Size,
				ZIndex = 2,
				Image = Page.Image,
				ImageColor3 = Color3.fromRGB(100, 100, 100)
			})
			--
			local Page_Tab_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			-- //
			local Tab_Border_Inner = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab_Border,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 1, 1, -2),
				ZIndex = 2,
				RenderTime = 0.15
			})
			-- //
			local Border_Inner_Inner = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Tab_Border_Inner,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 0, 1, -2),
				ZIndex = 2,
				RenderTime = 0.15
			})
			--
			local Inner_Inner_Pattern = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Border_Inner_Inner,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Image = "rbxassetid://8509210785",
				ImageColor3 = Color3.fromRGB(12, 12, 12),
				ScaleType = "Tile",
				TileSize = UDim2.new(0, 8, 0, 8),
				ZIndex = 2
			})
			-- //
			local Page_Page = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page.Window["PagesHolder"],
				Position = UDim2.new(0, 20, 0, 20),
				Size = UDim2.new(1, -40, 1, -40),
				Visible = false
			})
			-- //
			local Page_Page_Left = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Page,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			--
			local Page_Page_Right = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Page,
				Position = UDim2.new(0.5, 10, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			-- //
			local Page_Left_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = Page_Page_Left,
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Top"
			})
			--
			local Page_Right_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = Page_Page_Right,
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Top"
			})
			--
			do -- // Index Setting
				Page["Page"] = Page_Page
				Page["Left"] = Page_Page_Left
				Page["Right"] = Page_Page_Right
			end
			--
			do -- // Functions
				function Page:Set(state)
					Page.Open = state
					--
					Page_Page.Visible = Page.Open
					Page_Tab_Border.Visible = Page.Open
					Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
					--
					if Page.Open then
						Page.Window:SetPage(Page)
					end
				end
			end
			--
			do -- // Connections
				utility:CreateConnection(Page_Tab_Button.MouseButton1Click, function(Input)
					if not Page.Open then
						Page:Set(true)
					end
				end)
				--
				utility:CreateConnection(Page_Tab_Button.MouseEnter, function(Input)
					Page_Tab_Image.ImageColor3 = Color3.fromRGB(172, 172, 172)
				end)
				--
				utility:CreateConnection(Page_Tab_Button.MouseLeave, function(Input)
					Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
				end)
			end
		end
		--
		if #Page.Window.Pages == 0 then Page:Set(true) end
		Page.Window.Pages[#Page.Window.Pages + 1] = Page
		return setmetatable(Page, pages)
	end
	--
	function pages:CreateSection(Properties)
		Properties = Properties or {}
		--
		local Section = {
			Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Section"),
			Size = (Properties.size or Properties.Size or 150),
			Side = (Properties.side or Properties.Side or "Left"),
			Content = {},
			Window = self.Window,
			Page = self
		}
		--
		do
			local Section_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(12, 12, 12),
				BorderMode = "Inset",
				BorderSizePixel = 1,
				Parent = Section.Page[Section.Side],
				Size = UDim2.new(1, 0, 0, Section.Size),
				ZIndex = 2
			})
			-- //
			local Section_Holder_Extra = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 2
			})
			--
			local Section_Holder_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 2
			})
			--
			local Section_Holder_TitleInline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 9, 0, -1),
				Size = UDim2.new(0, 0, 0, 2),
				ZIndex = 5
			})
			--
			local Section_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -26, 0, 15),
				ZIndex = 5,
				Font = "Code",
				RichText = true,
				Text = "<b>" .. Section.Name .. "</b>",
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 11,
				TextStrokeTransparency = 1,
				TextXAlignment = "Left"
			})
			-- //
			local Holder_Extra_Gradient1 = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 1, 0, 1),
				Rotation = 180,
				Size = UDim2.new(1, -2, 0, 20),
				Visible = false,
				ZIndex = 4,
				Image = "rbxassetid://7783533907",
				ImageColor3 = Color3.fromRGB(23, 23, 23)
			})
			--
			local Holder_Extra_Gradient2 = utility:RenderObject("ImageLabel", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, -2, 0, 20),
				Visible = false,
				ZIndex = 4,
				Image = "rbxassetid://7783533907",
				ImageColor3 = Color3.fromRGB(23, 23, 23)
			})
			--
			local Holder_Extra_ArrowUp = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, -21, 0, 0),
				Size = UDim2.new(0, 7 + 8, 0, 6 + 8),
				Text = "",
                Visible = false,
				ZIndex = 4
			})
			--
			local Holder_Extra_ArrowDown = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, -21, 1, -(6 + 8)),
				Size = UDim2.new(0, 7 + 8, 0, 6 + 8),
				Text = "",
                Visible = false,
				ZIndex = 4
			})
			-- //
			local Extra_ArrowUp_Image = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Extra_ArrowUp,
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 7, 0, 6),
				Visible = true,
				ZIndex = 4,
				Image = "rbxassetid://8548757311",
				ImageColor3 = Color3.fromRGB(205, 205, 205)
			})
			--
			local Extra_ArrowDown_Image = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Extra_ArrowDown,
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 7, 0, 6),
				Visible = true,
				ZIndex = 4,
				Image = "rbxassetid://8548723563",
				ImageColor3 = Color3.fromRGB(205, 205, 205)
			})
			--
			local Holder_Extra_Bar = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 6, 1, 0),
				Visible = false,
				ZIndex = 4
			})
			--
			local Holder_Extra_Line = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 0, 0, -1),
				Size = UDim2.new(1, 0, 0, 1),
				ZIndex = 4
			})
			--
			local Holder_Frame_ContentHolder = utility:RenderObject("ScrollingFrame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Frame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 4,
				AutomaticCanvasSize = "Y",
				BottomImage = "rbxassetid://7783554086",
				CanvasSize = UDim2.new(0, 0, 0, 0),
				MidImage = "rbxassetid://7783554086",
				ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
				ScrollBarImageTransparency = 0,
				ScrollBarThickness = 5,
				TopImage = "rbxassetid://7783554086",
				VerticalScrollBarInset = "None"
			})
			-- //
			local Frame_ContentHolder_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 0),
				Parent = Holder_Frame_ContentHolder,
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Top"
			})
			--
			local Frame_ContentHolder_Padding = utility:RenderObject("UIPadding", {
				Parent = Holder_Frame_ContentHolder,
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15)
			})
			--
			do -- // Section Init
				Section_Holder_TitleInline.Size = UDim2.new(0, Section_Holder_Title.TextBounds.X + 6, 0, 2)
			end
			--
			do -- // Index Setting
				Section["Holder"] = Holder_Frame_ContentHolder
				Section["Extra"] = Section_Holder_Extra
			end
			--
			do -- // Functions
				function Section:CloseContent()
					if Section.Content.Open then
						Section.Content:Close()
						--
						Section.Content = {}
					end
				end
			end
			--
			do -- // Connections
				utility:CreateConnection(Holder_Frame_ContentHolder:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
					Holder_Extra_Gradient1.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
					Holder_Extra_Gradient2.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
					Holder_Extra_Bar.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
                    --
                    if (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y) then
                        Holder_Extra_ArrowUp.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y > 5)
                        Holder_Extra_ArrowDown.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y + 5 < (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
                    end
				end)
				--
				utility:CreateConnection(Holder_Frame_ContentHolder:GetPropertyChangedSignal("CanvasPosition"), function()
					if Section.Content.Open then
						Section.Content:Close()
						--
						Section.Content = {}
					end
                    --
                    Holder_Extra_ArrowUp.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y > 1)
                    Holder_Extra_ArrowDown.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y + 1 < (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
				end)
                --
                utility:CreateConnection(Holder_Extra_ArrowUp.MouseButton1Click, function()
					Holder_Frame_ContentHolder.CanvasPosition = Vector2.new(0, math.clamp(Holder_Frame_ContentHolder.CanvasPosition.Y - 10, 0, Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
				end)
                --
                utility:CreateConnection(Holder_Extra_ArrowDown.MouseButton1Click, function()
					Holder_Frame_ContentHolder.CanvasPosition = Vector2.new(0, math.clamp(Holder_Frame_ContentHolder.CanvasPosition.Y + 10, 0, Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
				end)
			end
		end
		--
		return setmetatable(Section, sections)
	end
	--
	do -- // Content
		function sections:CreateToggle(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Toggle"),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or false),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 8 + 10),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 20, 0, 5),
					Size = UDim2.new(0, 8, 0, 8),
					ZIndex = 3
				})
				--
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				-- //
				local Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(77, 77, 77),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 3
				})
				-- //
				local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140)),
					Enabled = true,
					Rotation = 90,
					Parent = Holder_Outline_Frame
				})
				--
				do -- // Functions
					function Content:Set(state)
						Content.State = state
						--
						Holder_Outline_Frame.BackgroundColor3 = Content.State and Content.Window.Accent or Color3.fromRGB(77, 77, 77)
						--
						Content.Callback(Content:Get())
					end
					--
					function Content:Get()
						return Content.State
					end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function(Input)
						Content:Set(not Content:Get())
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180))
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140))
					end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateSlider(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or nil),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or false),
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				Max = (Properties.max or Properties.Max or Properties.maxmimum or Properties.Maximum or 100),
				Ending = (Properties.ending or Properties.Ending or Properties.suffix or Properties.Suffix or ""),
				Decimals = (1 / (Properties.decimals or Properties.Decimals or Properties.tick or Properties.Tick or 1)),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Holding = false,
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, (Content.Name and 24 or 13) + 5),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 40, 0, Content.Name and 18 or 5),
					Size = UDim2.new(1, -99, 0, 7),
					ZIndex = 3
				})
				--
				if Content.Name then
					local Content_Holder_Title = utility:RenderObject("TextLabel", {
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Content_Holder,
						Position = UDim2.new(0, 41, 0, 4),
						Size = UDim2.new(1, -41, 0, 10),
						ZIndex = 3,
						Font = "Code",
						RichText = true,
						Text = Content.Name,
						TextColor3 = Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextXAlignment = "Left"
					})
					--
					local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Content_Holder,
						Position = UDim2.new(0, 41, 0, 4),
						Size = UDim2.new(1, -41, 0, 10),
						ZIndex = 3,
						Font = "Code",
						RichText = true,
						Text = Content.Name,
						TextColor3 = Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextTransparency = 0.5,
						TextXAlignment = "Left"
					})
				end
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				-- //
				local Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(71, 71, 71),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 3
				})
				-- //
				local Outline_Frame_Slider = utility:RenderObject("Frame", {
					BackgroundColor3 = Content.Window.Accent,
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					ZIndex = 3
				})
				--
				local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175)),
					Enabled = true,
					Rotation = 270,
					Parent = Holder_Outline_Frame
				})
                -- //
                local Frame_Slider_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175)),
					Enabled = true,
					Rotation = 90,
					Parent = Outline_Frame_Slider
				})
				-- //
				local Frame_Slider_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Outline_Frame_Slider,
					Position = UDim2.new(1, 0, 0.5, 1),
					Size = UDim2.new(0, 2, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 11,
					TextStrokeTransparency = 0.5,
					TextXAlignment = "Center",
					RenderTime = 0.15
				})
				--
				local Frame_Slider_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Outline_Frame_Slider,
					Position = UDim2.new(1, 0, 0.5, 1),
					Size = UDim2.new(0, 2, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 11,
					TextStrokeTransparency = 0.5,
					TextTransparency = 0,
					TextXAlignment = "Center",
					RenderTime = 0.15
				})
				--
				do -- // Functions
					function Content:Set(state)
						Content.State = math.clamp(math.round(state * Content.Decimals) / Content.Decimals, Content.Min, Content.Max)
						--
						Frame_Slider_Title.Text = "<b>" .. Content.State .. Content.Ending .. "</b>"
						Outline_Frame_Slider.Size = UDim2.new((1 - ((Content.Max - Content.State) / (Content.Max - Content.Min))), 0, 1, 0)
						--
						Content.Callback(Content:Get())
					end
					--
					function Content:Refresh()
						local Mouse = utility:MouseLocation()
						--
						Content:Set(math.clamp(math.floor((Content.Min + (Content.Max - Content.Min) * math.clamp(Mouse.X - Outline_Frame_Slider.AbsolutePosition.X, 0, Holder_Outline_Frame.AbsoluteSize.X) / Holder_Outline_Frame.AbsoluteSize.X) * Content.Decimals) / Content.Decimals, Content.Min, Content.Max))
					end
					--
					function Content:Get()
						return Content.State
					end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function(Input)
						Content:Refresh()
						--
						Content.Holding = true
                        --
                        Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
                        Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
					end)
                    --
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
                        Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Content.Holding and Color3.fromRGB(215, 215, 215) or Color3.fromRGB(175, 175, 175))
                        Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Content.Holding and Color3.fromRGB(215, 215, 215) or Color3.fromRGB(175, 175, 175))
					end)
					--
					utility:CreateConnection(uis.InputChanged, function(Input)
						if Content.Holding then
							Content:Refresh()
						end
					end)
					--
					utility:CreateConnection(uis.InputEnded, function(Input)
						if Content.Holding and Input.UserInputType == Enum.UserInputType.MouseButton1 then
							Content.Holding = false
                            --
                            Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175))
                        	Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175))
						end
					end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateDropdown(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Dropdown"),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or 1),
				Options = (Properties.options or Properties.Options or Properties.list or Properties.List or {1, 2, 3}),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Content = {
					Open = false
				},
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 34 + 5),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 40, 0, 15),
					Size = UDim2.new(1, -98, 0, 20),
					ZIndex = 3
				})
				--
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				-- //
				local Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(36, 36, 36),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 3
				})
				-- //
				local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
					Enabled = true,
					Rotation = 270,
					Parent = Holder_Outline_Frame
				})
				--
				local Outline_Frame_Title = utility:RenderObject("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(155, 155, 155),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Outline_Frame_Title2 = utility:RenderObject("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(155, 155, 155),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0,
					TextXAlignment = "Left"
				})
				--
				local Outline_Frame_Arrow = utility:RenderObject("ImageLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(1, -11, 0.5, -4),
					Size = UDim2.new(0, 7, 0, 6),
					Image = "rbxassetid://8532000591",
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					ZIndex = 3
				})
				--
				do -- // Functions
					function Content:Set(state)
						Content.State = state
						--
						Outline_Frame_Title.Text = Content.Options[Content:Get()]
						Outline_Frame_Title2.Text = Content.Options[Content:Get()]
						--
						Content.Callback(Content:Get())
						--
						if Content.Content.Open then
							Content.Content:Refresh(Content:Get())
						end
					end
					--
					function Content:Get()
						return Content.State
					end
					--
					function Content:Open()
						Content.Section:CloseContent()
						--
						local Open = {}
						local Connections = {}
						--
						local InputCheck
						--
						local Content_Open_Holder = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content.Section.Extra,
							Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 21),
							Size = UDim2.new(1, -98, 0, (18 * #Content.Options) + 2),
							ZIndex = 6
						})
						-- //
						local Open_Holder_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(12, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content_Open_Holder,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 6
						})
						-- //
						local Open_Holder_Outline_Frame = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(35, 35, 35),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Holder_Outline,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							ZIndex = 6
						})
						-- //
						for Index, Option in pairs(Content.Options) do
							local Outline_Frame_Option = utility:RenderObject("Frame", {
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								BackgroundTransparency = 0,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Open_Holder_Outline_Frame,
								Position = UDim2.new(0, 0, 0, 18 * (Index - 1)),
								Size = UDim2.new(1, 0, 1 / #Content.Options, 0),
								ZIndex = 6
							})
							-- //
							local Frame_Option_Title = utility:RenderObject("TextLabel", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Position = UDim2.new(0, 8, 0, 0),
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 6,
								Font = "Code",
								RichText = true,
								Text = tostring(Option),
								TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
								TextSize = 9,
								TextStrokeTransparency = 1,
								TextXAlignment = "Left"
							})
							--
							local Frame_Option_Title2 = utility:RenderObject("TextLabel", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Position = UDim2.new(0, 8, 0, 0),
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 6,
								Font = "Code",
								RichText = true,
								Text = tostring(Option),
								TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
								TextSize = 9,
								TextStrokeTransparency = 1,
								TextTransparency = 0.5,
								TextXAlignment = "Left"
							})
							--
							local Frame_Option_Button = utility:RenderObject("TextButton", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Size = UDim2.new(1, 0, 1, 0),
								Text = "",
								ZIndex = 6
							})
							--
							do -- // Connections
								local Clicked = utility:CreateConnection(Frame_Option_Button.MouseButton1Click, function(Input)
									Content:Set(Index)
								end)
								--
								local Entered = utility:CreateConnection(Frame_Option_Button.MouseEnter, function(Input)
									Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
								end)
								--
								local Left = utility:CreateConnection(Frame_Option_Button.MouseLeave, function(Input)
									Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
								end)
								--
								Connections[#Connections + 1] = Clicked
								Connections[#Connections + 1] = Entered
								Connections[#Connections + 1] = Left
							end
							--
							Open[#Open + 1] = {Index, Frame_Option_Title, Frame_Option_Title2, Outline_Frame_Option, Frame_Option_Button}
						end
						--
						do -- // Functions
							function Content.Content:Close()
								Content.Content.Open = false
								--
								Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
								--
								for Index, Value in pairs(Connections) do
									Value:Disconnect()
								end
								--
								InputCheck:Disconnect()
								--
								for Index, Value in pairs(Open) do
									Value[2]:Remove()
									Value[3]:Remove()
									Value[4]:Remove()
									Value[5]:Remove()
								end
								--
								Content_Open_Holder:Remove()
								Open_Holder_Outline:Remove()
								Open_Holder_Outline_Frame:Remove()
								--
								function Content.Content:Refresh() end
								--
								InputCheck = nil
								Connections = nil
								Open = nil
							end
							--
							function Content.Content:Refresh(state)
								for Index, Value in pairs(Open) do
									Value[2].TextColor3 = Value[1] == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
									Value[3].TextColor3 = Value[1] == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
								end
							end
						end
						--
						Content.Content.Open = true
						Content.Section.Content = Content.Content
						--
						Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
						--
						do -- // Connections
							task.wait()
							--
							InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
								if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
									local Mouse = utility:MouseLocation()
									--
									if not (Mouse.X > Content_Open_Holder.AbsolutePosition.X  and Mouse.Y > (Content_Open_Holder.AbsolutePosition.Y + 36) and Mouse.X < (Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X) and Mouse.Y < (Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y + 36)) then
										Content.Section:CloseContent()
									end
								end
							end)
						end
					end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function(Input)
						if Content.Content.Open then
							Content.Section:CloseContent()
						else
							Content:Open()
						end
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Holder_Outline_Frame.BackgroundColor3 = Content.Content.Open and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(36, 36, 36)
					end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateMultibox(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Dropdown"),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or {1}),
				Options = (Properties.options or Properties.Options or Properties.list or Properties.List or {1, 2, 3}),
				Minimum = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				Maximum = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 1000),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Content = {
					Open = false
				},
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 34 + 5),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 40, 0, 15),
					Size = UDim2.new(1, -98, 0, 20),
					ZIndex = 3
				})
				--
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				-- //
				local Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(36, 36, 36),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 3
				})
				-- //
				local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
					Enabled = true,
					Rotation = 270,
					Parent = Holder_Outline_Frame
				})
				--
				local Outline_Frame_Title = utility:RenderObject("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(155, 155, 155),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Outline_Frame_Title2 = utility:RenderObject("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = "",
					TextColor3 = Color3.fromRGB(155, 155, 155),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0,
					TextXAlignment = "Left"
				})
				--
				local Outline_Frame_Arrow = utility:RenderObject("ImageLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Holder_Outline_Frame,
					Position = UDim2.new(1, -11, 0.5, -4),
					Size = UDim2.new(0, 7, 0, 6),
					Image = "rbxassetid://8532000591",
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					ZIndex = 3
				})
				--
				do -- // Functions
					function Content:Set(state)
						table.sort(state)
						Content.State = state
						--
						local Serialised = utility:Serialise(utility:Sort(Content:Get(), Content.Options))
						--
						Serialised = Serialised == "" and "-" or Serialised
						--
						Outline_Frame_Title.Text = Serialised
						Outline_Frame_Title2.Text = Serialised
						--
						Content.Callback(Content:Get())
						--
						if Content.Content.Open then
							Content.Content:Refresh(Content:Get())
						end
					end
					--
					function Content:Get()
						return Content.State
					end
					--
					function Content:Open()
						Content.Section:CloseContent()
						--
						local Open = {}
						local Connections = {}
						--
						local InputCheck
						--
						local Content_Open_Holder = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content.Section.Extra,
							Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 21),
							Size = UDim2.new(1, -98, 0, (18 * #Content.Options) + 2),
							ZIndex = 6
						})
						-- //
						local Open_Holder_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(12, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content_Open_Holder,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 6
						})
						-- //
						local Open_Holder_Outline_Frame = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(21, 21, 21),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Holder_Outline,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							ZIndex = 6
						})
						-- //
						for Index, Option in pairs(Content.Options) do
							local Outline_Frame_Option = utility:RenderObject("Frame", {
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								BackgroundTransparency = 0,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Open_Holder_Outline_Frame,
								Position = UDim2.new(0, 0, 0, 18 * (Index - 1)),
								Size = UDim2.new(1, 0, 1 / #Content.Options, 0),
								ZIndex = 6
							})
							-- //
							local Frame_Option_Title = utility:RenderObject("TextLabel", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Position = UDim2.new(0, 8, 0, 0),
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 6,
								Font = "Code",
								RichText = true,
								Text = tostring(Option),
								TextColor3 = table.find(Content.State, Index) and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
								TextSize = 9,
								TextStrokeTransparency = 1,
								TextXAlignment = "Left"
							})
							--
							local Frame_Option_Title2 = utility:RenderObject("TextLabel", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Position = UDim2.new(0, 8, 0, 0),
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 6,
								Font = "Code",
								RichText = true,
								Text = tostring(Option),
								TextColor3 = table.find(Content.State, Index) and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
								TextSize = 9,
								TextStrokeTransparency = 1,
								TextTransparency = 0.5,
								TextXAlignment = "Left"
							})
							--
							local Frame_Option_Button = utility:RenderObject("TextButton", {
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Parent = Outline_Frame_Option,
								Size = UDim2.new(1, 0, 1, 0),
								Text = "",
								ZIndex = 6
							})
							--
							do -- // Connections
								local Clicked = utility:CreateConnection(Frame_Option_Button.MouseButton1Click, function(Input)
									local NewTable = Content:Get()
									--
									if table.find(NewTable, Index) then
										if (#NewTable - 1) >= Content.Minimum then
											table.remove(NewTable, table.find(NewTable, Index))
										end
									else
										if (#NewTable + 1) <= Content.Maximum then
											table.insert(NewTable, Index)
										end
									end
									--
									Content:Set(NewTable)
								end)
								--
								local Entered = utility:CreateConnection(Frame_Option_Button.MouseEnter, function(Input)
									Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
								end)
								--
								local Left = utility:CreateConnection(Frame_Option_Button.MouseLeave, function(Input)
									Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
								end)
								--
								Connections[#Connections + 1] = Clicked
								Connections[#Connections + 1] = Entered
								Connections[#Connections + 1] = Left
							end
							--
							Open[#Open + 1] = {Index, Frame_Option_Title, Frame_Option_Title2, Outline_Frame_Option, Frame_Option_Button}
						end
						--
						do -- // Functions
							function Content.Content:Close()
								Content.Content.Open = false
                                --
								Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
								--
								for Index, Value in pairs(Connections) do
									Value:Disconnect()
								end
								--
								InputCheck:Disconnect()
								--
								for Index, Value in pairs(Open) do
									Value[2]:Remove()
									Value[3]:Remove()
									Value[4]:Remove()
									Value[5]:Remove()
								end
								--
								Content_Open_Holder:Remove()
								Open_Holder_Outline:Remove()
								Open_Holder_Outline_Frame:Remove()
								--
								function Content.Content:Refresh() end
								--
								InputCheck = nil
								Connections = nil
								Open = nil
							end
							--
							function Content.Content:Refresh(state)
								for Index, Value in pairs(Open) do
									Value[2].TextColor3 = table.find(Content.State, Value[1]) and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
									Value[3].TextColor3 = table.find(Content.State, Value[1]) and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
								end
							end
						end
						--
						Content.Content.Open = true
						Content.Section.Content = Content.Content
                        --
						Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
						--
						do -- // Connections
							task.wait()
							--
							InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
								if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
									local Mouse = utility:MouseLocation()
									--
									if not (Mouse.X > Content_Open_Holder.AbsolutePosition.X and Mouse.Y > (Content_Open_Holder.AbsolutePosition.Y + 36) and Mouse.X < (Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X) and Mouse.Y < (Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y + 36)) then
										Content.Section:CloseContent()
									end
								end
							end)
						end
					end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function(Input)
						if Content.Content.Open then
							Content.Section:CloseContent()
						else
							Content:Open()
						end
					end)
                    --
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Holder_Outline_Frame.BackgroundColor3 = Content.Content.Open and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(36, 36, 36)
					end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateKeybind(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Toggle"),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil),
                Mode = (Properties.mode or Properties.Mode or "Hold"),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
                Active = false,
                Holding = false,
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
            --
            local Keys = {
                KeyCodes = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "One", "Two", "Three", "Four", "Five", "Six", "Seveen", "Eight", "Nine", "0", "Insert", "Tab", "Home", "End", "LeftAlt", "LeftControl", "LeftShift", "RightAlt", "RightControl", "RightShift", "CapsLock"},
                Inputs = {"MouseButton1", "MouseButton2", "MouseButton3"},
                Shortened = {["MouseButton1"] = "M1", ["MouseButton2"] = "M2", ["MouseButton3"] = "M3", ["Insert"] = "INS", ["LeftAlt"] = "LA", ["LeftControl"] = "LC", ["LeftShift"] = "LS", ["RightAlt"] = "RA", ["RightControl"] = "RC", ["RightShift"] = "RS", ["CapsLock"] = "CL"}
            }
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 8 + 10),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
                -- //
                local Content_Holder_Value = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -61, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text =  "",
					TextColor3 = Color3.fromRGB(114, 114, 114),
                    TextStrokeColor3 = Color3.fromRGB(15, 15, 15),
					TextSize = 9,
					TextStrokeTransparency = 0,
					TextXAlignment = "Right"
				})
				--
				do -- // Functions
					function Content:Set(state)
						Content.State = state or {}
                        Content.Active = false
                        --
                        Content_Holder_Value.Text = "[" .. (#Content:Get() > 0 and Content:Shorten(Content:Get()[2]) or "-") .. "]"
						--
						Content.Callback(Content:Get())
					end
					--
					function Content:Get()
						return Content.State
					end
                    --
                    function Content:Shorten(Str)
                        for Index, Value in pairs(Keys.Shortened) do
                            Str = string.gsub(Str, Index, Value)
                        end
                        --
                        return Str
                    end
                    --
                    function Content:Change(Key)
                        if Key.EnumType then
                            if Key.EnumType == Enum.KeyCode or Key.EnumType == Enum.UserInputType then
                                if table.find(Keys.KeyCodes, Key.Name) or table.find(Keys.Inputs, Key.Name) then
                                    Content:Set({Key.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType", Key.Name})
                                    return true
                                end
                            end
                        end
                    end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function(Input)
						Content.Holding = true
                        --
                        Content_Holder_Value.TextColor3 = Color3.fromRGB(255, 0, 0)
					end)
                    --
                    utility:CreateConnection(Content_Holder_Button.MouseButton2Click, function(Input)
						Content:Set()
					end)
                    --
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Content_Holder_Value.TextColor3 = Color3.fromRGB(164, 164, 164)
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Content_Holder_Value.TextColor3 = Content.Holding and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(114, 114, 114)
					end)
                    --
                    utility:CreateConnection(uis.InputBegan, function(Input)
                        if Content.Holding then
                            local Success = Content:Change(Input.KeyCode.Name ~= "Unknown" and Input.KeyCode or Input.UserInputType)
                            --
                            if Success then
                                Content.Holding = false
                                --
                                Content_Holder_Value.TextColor3 = Color3.fromRGB(114, 114, 114)
                            end
                        end
                        --
                        if Content:Get()[1] and Content:Get()[2] then
                            if Input.KeyCode == Enum[Content:Get()[1]][Content:Get()[2]] or Input.UserInputType == Enum[Content:Get()[1]][Content:Get()[2]] then
                                if Content.Mode == "Hold" then
                                    Content.Active = true
                                elseif Content.Mode == "Toggle" then
                                    Content.Active = not Content.Active
                                end
                            end
                        end
                    end)
                    --
                    utility:CreateConnection(uis.InputEnded, function(Input)
                        if Content:Get()[1] and Content:Get()[2] then
                            if Input.KeyCode == Enum[Content:Get()[1]][Content:Get()[2]] or Input.UserInputType == Enum[Content:Get()[1]][Content:Get()[2]] then
                                if Content.Mode == "Hold" then
                                    Content.Active = false
                                end
                            end
                        end
                    end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateColorpicker(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Toggle"),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 255, 255)),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Content = {
					Open = false
				},
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 8 + 10),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(1, -38, 0, 4),
					Size = UDim2.new(0, 17, 0, 9),
					ZIndex = 3
				})
				--
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 0),
					Size = UDim2.new(1, -41, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = "Left"
				})
				--
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				-- //
				local Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 3
				})
				-- //
				local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140)),
					Enabled = true,
					Rotation = 90,
					Parent = Holder_Outline_Frame
				})
				--
				do -- // Functions
					function Content:Set(state)
						Content.State = state
						--
						Holder_Outline_Frame.BackgroundColor3 = Content.State
						--
						if Content.Content.Open and Content.Content.Refresh then
							Content.Content:Refresh(Content.State)
						end
						--
						Content.Callback(Content:Get())
					end
					--
					function Content:Get()
						return Content.State
					end
					--
					function Content:Open()
						Content.Section:CloseContent()
						--
						local Connections = {}
						--
						local InputCheck
						--
						local Content_Open_Holder = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content.Section.Extra,
							Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 10),
							Size = UDim2.new(0, 180, 0, 175),
							ZIndex = 6
						})
						-- //
						local Open_Holder_Button = utility:RenderObject("TextButton", {
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Content_Open_Holder,
							Position = UDim2.new(0, -1, 0, -1),
							Size = UDim2.new(1, 2, 1, 2),
							Text = ""
						})
						-- //
						local Open_Holder_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(60, 60, 60),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(12, 12, 12),
							BorderMode = "Inset",
							BorderSizePixel = 1,
							Parent = Content_Open_Holder,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 6
						})
						-- //
						local Open_Outline_Frame = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Holder_Outline,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							ZIndex = 6
						})
						-- //
						local ValSat_Picker_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(12, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Outline_Frame,
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(0, 152, 0, 152),
							ZIndex = 6
						})
						--
						local Hue_Picker_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(12, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Outline_Frame,
							Position = UDim2.new(1, -19, 0, 2),
							Size = UDim2.new(0, 17, 0, 152),
							ZIndex = 6
						})
						--
						local Transparency_Picker_Outline = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(12, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = Open_Outline_Frame,
							Position = UDim2.new(0, 2, 1, -14),
							Size = UDim2.new(0, 152, 0, 12),
							ZIndex = 6
						})
						-- //
						local ValSat_Picker_Color = utility:RenderObject("Frame", {
							BackgroundColor3 = Color3.fromRGB(255, 12, 12),
							BackgroundTransparency = 0,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Parent = ValSat_Picker_Outline,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							ZIndex = 6
						})
						--
						do -- // Functions
							local Hue, Sat, Val = Color3.toHSV(Content.State)
							Hue = Hue or 0
							Sat = Sat or 1
							Val = Val or 1
							--
							local Picking = nil
							--
							do -- // Pickers
								ValSat_Picker_Color.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
								--
								local ValSat_White_Gradient = utility:RenderObject("UIGradient", {
									Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)),
									Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
									Enabled = true,
									Rotation = 0,
									Parent = ValSat_Picker_Color
								})
								--
								local ValSat_Black_Gradient = utility:RenderObject("UIGradient", {
									Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)),
									Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
									Enabled = true,
									Rotation = 90,
									Parent = ValSat_Picker_Color
								})
								--
								local ValSat_Knob = utility:RenderObject("Frame", {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 0,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 1,
									Parent = ValSat_Picker_Color,
									Size = UDim2.new(0, 7, 0, 7),
									ZIndex = 8
								})
								--
								local ValSat_Btn = utility:RenderObject("TextButton", {
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Parent = ValSat_Picker_Color,
									Size = UDim2.new(1, 0, 1, 0),
									Text = "",
									ZIndex = 9
								})
								-- //
								local Hue_Picker_Color = utility:RenderObject("Frame", {
									BackgroundColor3 = Color3.fromRGB(255, 0, 0),
									BackgroundTransparency = 0,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Parent = Hue_Picker_Outline,
									Position = UDim2.new(0, 1, 0, 1),
									Size = UDim2.new(1, -2, 1, -2),
									ZIndex = 6
								})
								--
								local Hue_Picker_Gradient = utility:RenderObject("UIGradient", {
									Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 0, 0)),
									Enabled = true,
									Rotation = 90,
									Parent = Hue_Picker_Color
								})
								--
								local Hue_Knob = utility:RenderObject("Frame", {
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 0,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 1,
									Parent = Hue_Picker_Color,
									Size = UDim2.new(0, 7, 0, 7),
									ZIndex = 8
								})
								--
								local Hue_Btn = utility:RenderObject("TextButton", {
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Parent = Hue_Picker_Color,
									Size = UDim2.new(1, 0, 1, 0),
									Text = "",
									ZIndex = 9
								})
								--
								local function Apply()
									Content.State = Color3.fromHSV(Hue, Sat, Val)
									--
									Holder_Outline_Frame.BackgroundColor3 = Content.State
									ValSat_Knob.Position = UDim2.fromScale(Sat, 1 - Val)
									Hue_Knob.Position = UDim2.fromScale(0.5, Hue)
									--
									Content.Callback(Content.State)
								end
								--
								local function UpdateValSat()
									local Mouse = utility:MouseLocation()
									local Pos = ValSat_Picker_Color.AbsolutePosition
									local Size = ValSat_Picker_Color.AbsoluteSize
									Sat = math.clamp((Mouse.X - Pos.X) / Size.X, 0, 1)
									Val = 1 - math.clamp((Mouse.Y - Pos.Y) / Size.Y, 0, 1)
									--
									Apply()
								end
								--
								local function UpdateHue()
									local Mouse = utility:MouseLocation()
									local Pos = Hue_Picker_Color.AbsolutePosition
									local Size = Hue_Picker_Color.AbsoluteSize
									Hue = math.clamp((Mouse.Y - Pos.Y) / Size.Y, 0, 1)
									--
									ValSat_Picker_Color.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
									--
									Apply()
								end
								--
								table.insert(Connections, utility:CreateConnection(ValSat_Btn.MouseButton1Down, function(Input)
									Picking = "valsat"
								end))
								--
								table.insert(Connections, utility:CreateConnection(Hue_Btn.MouseButton1Down, function(Input)
									Picking = "hue"
								end))
								--
								table.insert(Connections, utility:CreateConnection(uis.InputChanged, function(Input)
									if not Picking or Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
									--
									if Picking == "valsat" then
										UpdateValSat()
									else
										UpdateHue()
									end
								end))
								--
								table.insert(Connections, utility:CreateConnection(uis.InputEnded, function(Input)
									if Input.UserInputType == Enum.UserInputType.MouseButton1 then
										Picking = nil
									end
								end))
							end
							--
							function Content.Content:Close()
								Content.Content.Open = false
								--
								Picking = nil
								--
								for Index, Value in pairs(Connections) do
									Value:Disconnect()
								end
								--
								InputCheck:Disconnect()
								--
								Content_Open_Holder:Remove()
								--
								function Content.Content:Refresh() end
								--
								InputCheck = nil
								Connections = nil
							end
							--
							function Content.Content:Refresh(state)
								local h, s, v = Color3.toHSV(state)
								Hue = (h and h > 0 and h) or Hue or 0
								Sat = s or Sat or 1
								Val = v or Val or 1
								--
								ValSat_Picker_Color.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
								ValSat_Knob.Position = UDim2.fromScale(Sat, 1 - Val)
								Hue_Knob.Position = UDim2.fromScale(0.5, Hue)
							end
						end
						--
						Content.Content.Open = true
						Content.Section.Content = Content.Content
						--
						do -- // Connections
							InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
								if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
									local Mouse = utility:MouseLocation()
									--
									if not (Mouse.X > Content_Open_Holder.AbsolutePosition.X and Mouse.Y > (Content_Open_Holder.AbsolutePosition.Y + 36) and Mouse.X < (Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X) and Mouse.Y < (Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y + 36)) then
										if not (Mouse.X > Content_Holder.AbsolutePosition.X and Mouse.Y > (Content_Holder.AbsolutePosition.Y) and Mouse.X < (Content_Holder.AbsolutePosition.X + Content_Holder.AbsoluteSize.X) and Mouse.Y < (Content_Holder.AbsolutePosition.Y + Content_Holder.AbsoluteSize.Y)) then
											if Content.Content.Open then
												Content.Section:CloseContent()
											end
										end
									end
								end
							end)
						end
					end
				end
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function(Input)
						if Content.Content.Open then
							Content.Section:CloseContent()
						else
							Content:Open()
						end
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180))
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140))
					end)
				end
				--
				Content:Set(Content.State)
			end
			--
			return Content
		end
		--
		function sections:CreateButton(Properties)
			Properties = Properties or {}
			--
			local Content = {
				Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Button"),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Content = {
					Open = false
				},
				Window = self.Window,
				Page = self.Page,
				Section = self
			}
			--
			do
				local Content_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Holder,
					Size = UDim2.new(1, 0, 0, 8 + 10),
					ZIndex = 3
				})
				-- //
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -60, 1, 0),
					ZIndex = 3,
					Font = "Code",
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = "Left"
				})
				-- //
				local Content_Holder_Button = utility:RenderObject("TextButton", {
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Font = "Code",
					Parent = Content_Holder,
					Position = UDim2.new(1, -46, 0, 4),
					Size = UDim2.new(0, 42, 0, 9),
					Text = "OK",
					TextColor3 = Color3.fromRGB(190, 190, 190),
					TextSize = 8,
					TextStrokeTransparency = 1,
					ZIndex = 3
				})
				--
				local Button_Gradient = utility:RenderObject("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140)),
					Enabled = true,
					Rotation = 90,
					Parent = Content_Holder_Button
				})
				--
				do -- // Connections
					utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function(Input)
						Content.Callback()
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseEnter, function(Input)
						Button_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 190, 190))
					end)
					--
					utility:CreateConnection(Content_Holder_Button.MouseLeave, function(Input)
						Button_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140))
					end)
				end
			end
			--
			return Content
		end
	end
-- [[ // Main // ]]
	local window = library:CreateWindow({})
	--
	local rage = window:CreatePage({Icon = "rbxassetid://8547236654"})
	local aimbot = window:CreatePage({Icon = "rbxassetid://8547249956"})
	local visuals = window:CreatePage({Icon = "rbxassetid://8547254518"})
	local setting = window:CreatePage({Icon = "rbxassetid://8547256547"})
	local skins = window:CreatePage({Icon = "rbxassetid://8547249956"})
	--
	-- [[ // Services & Constants // ]]
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local Lighting = game:GetService("Lighting")
	local TweenService = game:GetService("TweenService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	--
	local RS = ReplicatedStorage
	local LocalPlayer = Players.LocalPlayer
	local Camera = Workspace.CurrentCamera
	--
	-- [[ // Settings // ]]
	local cfg = {
		Silent = false,
		Wallbang = false,
		HitPart = "Head",
		TeamCheck = true,
		MaxDist = 500,
		UseFov = false,
		DrawFov = false,
		FovRadius = 130,
		FovColor = Color3.fromRGB(255, 0, 0),
		NoSpread = false,
		NoRecoil = false,
		ESP = false,
		Boxes = false,
		Skeletons = false,
		Names = false,
		Health = false,
		Distance = false,
		RenderDist = 2500,
		BoxColor = Color3.fromRGB(0, 186, 186),
		OutlineColor = Color3.fromRGB(15, 15, 15),
		NameColor = Color3.fromRGB(255, 255, 255),
		DistanceColor = Color3.fromRGB(179, 179, 179),
		Chams = false,
		ChamsColor = Color3.fromRGB(100, 120, 255),
		Forcefield = false,
		EnemyLight = false,
		NightMode = false,
		Flashlight = false,
		Lightning = false,
		DamageIndicator = false,
		Firerate = false,
		FirerateValue = 0.01,
		ESPTCheck = true,
		TeamColors = false,
		TP = false,
		TPDist = 5,
		TPHeight = 2
	}
	--
	-- [[ // Team Detection // ]]
	local function GetTeam(player)
		if not player then return nil end
		local ok, name = pcall(function() return player.Team and player.Team.Name or nil end)
		if ok and name then return name end
		--
		local char = player.Character
		if char then
			local parentName = char.Parent and char.Parent.Name
			if parentName == "Terrorists" or parentName == "Counter-Terrorists" then return parentName end
			local attr = char:GetAttribute("Team")
			if attr then
				local s = tostring(attr)
				if s == "1" then return "Terrorists"
				elseif s == "2" then return "Counter-Terrorists"
				else return s end
			end
		end
		--
		for _, child in ipairs(player:GetChildren()) do
			if child:IsA("StringValue") and child.Name ~= "UserId" then
				local s = tostring(child.Value)
				if s ~= "" then return s end
			elseif child:IsA("IntValue") then
				return (child.Value == 1 and "Terrorists") or (child.Value == 2 and "Counter-Terrorists") or tostring(child.Value)
			elseif child:IsA("Folder") then
				for _, sub in ipairs(child:GetChildren()) do
					if sub:IsA("StringValue") and tostring(sub.Value) ~= "" then return tostring(sub.Value) end
				end
			end
		end
		--
		return nil
	end
	local TeamColors = {
		["Terrorists"] = Color3.fromRGB(204, 170, 80),
		["Counter-Terrorists"] = Color3.fromRGB(100, 149, 200)
	}
	--
	-- [[ // Silent Aim Target Finder // ]]
	local SilentTarget = nil
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.IgnoreWater = true
	--
	local function IsVisible(target)
		if cfg.Wallbang then return true end
		if not target or not target.Parent or not Camera then return false end
		rayParams.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
		local origin = Camera.CFrame.Position
		local result = Workspace:Raycast(origin, target.Position - origin, rayParams)
		if not result then return true end
		local model = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
		return model and Players:GetPlayerFromCharacter(model) ~= nil
	end
	--
	local function FindSilentTarget()
		if not cfg.Silent or not Camera or not LocalPlayer.Character then
			SilentTarget = nil
			return
		end
		local myTeam = GetTeam(LocalPlayer)
		local screenCenter = Camera.ViewportSize / 2
		local closestDist = math.huge
		local closestPart = nil
		for _, player in next, Players:GetPlayers() do
			if player == LocalPlayer then continue end
			local char = player.Character
			if not char or char:GetAttribute("Dead") or char:GetAttribute("Invincible") then continue end
			if char.Parent and char.Parent.Name == "Debris" then continue end
			local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
			if not root then continue end
			if (Camera.CFrame.Position - root.Position).Magnitude > cfg.MaxDist then continue end
			local pTeam = GetTeam(player)
			local isTeam = myTeam ~= nil and pTeam ~= nil and myTeam == pTeam
			if cfg.TeamCheck and isTeam then continue end
			local targetPart = char:FindFirstChild(cfg.HitPart) or char:FindFirstChild("Head") or root
			if not targetPart then continue end
			local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
			if onScreen then
				local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				local maxRadius = cfg.UseFov and cfg.FovRadius or math.huge
				if distFromCenter <= maxRadius and distFromCenter < closestDist then
					if cfg.Wallbang or IsVisible(targetPart) then
						closestDist = distFromCenter
						closestPart = targetPart
					end
				end
			end
		end
		SilentTarget = closestPart
	end
	--
	-- [[ // FOV Circle // ]]
	local FOVCircle = Drawing.new("Circle")
	FOVCircle.Filled = false
	FOVCircle.Thickness = 1
	FOVCircle.NumSides = 64
	--
	RunService.RenderStepped:Connect(function()
		Camera = Workspace.CurrentCamera
		if not Camera then
			FOVCircle.Visible = false
			return
		end
		FOVCircle.Visible = cfg.DrawFov
		if FOVCircle.Visible then
			FOVCircle.Position = Camera.ViewportSize / 2
			FOVCircle.Radius = cfg.FovRadius
			FOVCircle.Color = cfg.FovColor
		end
		FindSilentTarget()
	end)
	--
	-- [[ // Silent Aim + No Spread Hook // ]]
	task.spawn(function()
		if typeof(hookfunction) ~= "function" or typeof(getgc) ~= "function" then return end
		local bulletClass = nil
		for attempt = 1, 45 do
			for _, obj in next, getgc(true) do
				if type(obj) == "table" and typeof(rawget(obj, "_performRaycast")) == "function" and rawget(obj, "getTrueSpread") ~= nil then
					bulletClass = obj
					break
				end
			end
			if bulletClass then break end
			task.wait(0.5)
		end
		if not bulletClass then return end
		local oldRaycast
		oldRaycast = hookfunction(bulletClass._performRaycast, function(...)
			local returns = table.pack(oldRaycast(...))
			local result = returns[1]
			if type(result) ~= "table" then
				return table.unpack(returns, 1, returns.n)
			end
			pcall(function()
				local hits = rawget(result, "Hits")
				local origin = rawget(result, "Origin")
				if type(hits) ~= "table" or typeof(origin) ~= "Vector3" then return end
				local lastIndex = nil
				for index, hit in pairs(hits) do
					if type(hit) == "table" then
						if lastIndex == nil or index > lastIndex then lastIndex = index end
					end
				end
				local finalHit = lastIndex and hits[lastIndex]
				if type(finalHit) ~= "table" then return end
				--
				local silenced = cfg.Silent and SilentTarget and SilentTarget.Parent
				if silenced then
					local aimPos = SilentTarget.Position
					finalHit.Instance = SilentTarget
					finalHit.Position = aimPos
					if finalHit.Exit ~= nil then finalHit.Exit = false end
					local delta = aimPos - origin
					local length = delta.Magnitude
					if length > 0.001 then
						result.Distance = length
						result.Direction = delta.Unit
						local unit = delta.Unit
						for index, hit in pairs(hits) do
							if index ~= lastIndex and type(hit) == "table" and typeof(hit.Position) == "Vector3" then
								local along = (hit.Position - origin):Dot(unit)
								if along > length then
									hit.Position = origin + unit * (length * 0.5)
								end
							end
						end
					end
				end
				if cfg.NoSpread and not silenced then
					local dir = Camera and Camera.CFrame.LookVector or nil
					if dir then
						local dist = (finalHit.Position and typeof(finalHit.Position) == "Vector3" and (finalHit.Position - origin).Magnitude) or result.Distance or 100
						local centerPos = origin + dir * dist
						finalHit.Position = centerPos
						if finalHit.Exit ~= nil then finalHit.Exit = false end
						result.Direction = dir
						result.Distance = dist
						for index, hit in pairs(hits) do
							if index ~= lastIndex and type(hit) == "table" and typeof(hit.Position) == "Vector3" then
								hit.Position = origin + dir * (hit.Position - origin):Dot(dir)
							end
						end
					end
				end
			end)
			return table.unpack(returns, 1, returns.n)
		end)
	end)
	--
	-- [[ // No Recoil // ]]
	local previousPitch = 0
	RunService:BindToRenderStep("PuppyNoRecoil", Enum.RenderPriority.Camera.Value + 100, function()
		if not cfg.NoRecoil then return end
		local char = LocalPlayer.Character
		if not char then return end
		local tool = char:FindFirstChildWhichIsA("Tool")
		if tool then
			local currentPitch, currentYaw, currentRoll = Camera.CFrame:ToOrientation()
			local pitchDelta = currentPitch - previousPitch
			if pitchDelta > 0.001 then
				local correctedPitch = currentPitch - pitchDelta
				Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(correctedPitch, currentYaw, currentRoll)
				previousPitch = correctedPitch
			else
				previousPitch = currentPitch
			end
		else
			local currentPitch, _, _ = Camera.CFrame:ToOrientation()
			previousPitch = currentPitch
		end
	end)
	--
	-- [[ // Rapid Fire // ]]
	local firerateobjs = {}
	local originalFirerate = {}
	pcall(function()
		for _, obj in pairs(getgc(true)) do
			if type(obj) == "table" and rawget(obj, "FireRate") then
				table.insert(originalFirerate, table.clone(obj))
				table.insert(firerateobjs, obj)
			end
		end
	end)
	--
	task.spawn(function()
		while true do
			task.wait(0.05)
			pcall(function()
				for index, obj in pairs(firerateobjs) do
					local value
					if cfg.Firerate then
						value = math.max(cfg.FirerateValue, 0.01)
					else
						value = (originalFirerate[index] and originalFirerate[index].FireRate) or 0.1
					end
					--
					pcall(function()
						setreadonly(obj, false)
						rawset(obj, "FireRate", value)
						setreadonly(obj, true)
					end)
				end
			end)
		end
	end)
	--
	-- [[ // Third Person // ]]
	RunService:BindToRenderStep("PuppyThirdPerson", Enum.RenderPriority.Camera.Value + 200, function()
		if not cfg.TP or not Camera then return end
		local char = LocalPlayer.Character
		local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
		local head = char and (char:FindFirstChild("Head") or root)
		if not root or not head then return end
		--
		local headPos = head.Position
		local mouse = uis:GetMouseLocation()
		local ray = Camera:ScreenPointToRay(mouse.X, mouse.Y, 1000)
		local lookTarget = ray.Origin + ray.Direction * (headPos - ray.Origin).Magnitude
		--
		local flat = Vector3.new(lookTarget.X - headPos.X, 0, lookTarget.Z - headPos.Z)
		if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, 1) end
		flat = flat / flat.Magnitude
		--
		local newPos = headPos + (flat * -cfg.TPDist) + Vector3.new(0, cfg.TPHeight, 0)
		Camera.CFrame = CFrame.lookAt(newPos, lookTarget)
		Camera.CameraType = Enum.CameraType.Scriptable
	end)
	--
	-- [[ // Night Mode + Flashlight // ]]
	local originalLights = {
		ClockTime = Lighting.ClockTime,
		Brightness = Lighting.Brightness,
		GlobalShadows = Lighting.GlobalShadows,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
		FogEnd = Lighting.FogEnd
	}
	--
	local function UpdateFlashlight(enable)
		local existing = Camera:FindFirstChild("NightFlashlightPart")
		if enable then
			if not existing then
				local part = Instance.new("Part")
				part.Name = "NightFlashlightPart"
				part.Size = Vector3.new(0.2, 0.2, 0.2)
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = true
				part.Parent = Camera
				local spotlight = Instance.new("SpotLight")
				spotlight.Name = "Flashlight"
				spotlight.Color = Color3.fromRGB(100, 120, 255)
				spotlight.Range = 60
				spotlight.Angle = 30
				spotlight.Brightness = 3.5
				spotlight.Face = Enum.NormalId.Front
				spotlight.Shadows = true
				spotlight.Parent = part
			end
		else
			if existing then existing:Destroy() end
		end
	end
	--
	RunService.RenderStepped:Connect(function()
		local flashlightPart = Camera:FindFirstChild("NightFlashlightPart")
		if flashlightPart and cfg.Flashlight then
			flashlightPart.CFrame = Camera.CFrame
		end
	end)
	--
	local function EnableNightMode()
		Lighting.ClockTime = 0
		Lighting.Brightness = 0.2
		Lighting.GlobalShadows = true
		Lighting.OutdoorAmbient = Color3.fromRGB(15, 15, 25)
		Lighting.Ambient = Color3.fromRGB(20, 20, 30)
		Lighting.FogColor = Color3.fromRGB(10, 10, 15)
		Lighting.FogEnd = 1000
	end
	--
	local function RestoreLighting()
		Lighting.ClockTime = originalLights.ClockTime
		Lighting.Brightness = originalLights.Brightness
		Lighting.GlobalShadows = originalLights.GlobalShadows
		Lighting.OutdoorAmbient = originalLights.OutdoorAmbient
		Lighting.Ambient = originalLights.Ambient
		Lighting.FogColor = originalLights.FogColor
		Lighting.FogEnd = originalLights.FogEnd
	end
	--
	local wasNight = false
	task.spawn(function()
		while true do
			if cfg.NightMode then
				if not wasNight then wasNight = true end
				pcall(EnableNightMode)
			else
				if wasNight then
					wasNight = false
					pcall(RestoreLighting)
				end
			end
			UpdateFlashlight(cfg.Flashlight and cfg.NightMode)
			task.wait(1.5)
		end
	end)
	--
	-- [[ // Forcefield Clean Style // ]]
	local function StylePart(part)
		if part:IsA("BasePart") then
			if part.Transparency >= 0.95 or part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name:lower():find("box") or part.Name:lower():find("hitbox") or part:FindFirstAncestorWhichIsA("Accessory") then
				return
			end
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("SurfaceAppearance") or child:IsA("Texture") then
					child:Destroy()
				end
			end
			part.Material = Enum.Material.ForceField
			part.Color = cfg.ChamsColor
			part.Transparency = 0.20
		end
	end
	--
	local function ApplyForceFieldToModel(model)
		if not model then return end
		for _, desc in ipairs(model:GetDescendants()) do
			StylePart(desc)
		end
	end
	--
	Camera.ChildAdded:Connect(function(child)
		task.wait(0.05)
		if cfg.Forcefield then ApplyForceFieldToModel(child) end
	end)
	--
	local function WatchCharacter(char)
		if not char then return end
		char.ChildAdded:Connect(function(child)
			task.wait(0.05)
			if cfg.Forcefield then ApplyForceFieldToModel(child) end
		end)
	end
	--
	if LocalPlayer.Character then WatchCharacter(LocalPlayer.Character) end
	LocalPlayer.CharacterAdded:Connect(WatchCharacter)
	--
	task.spawn(function()
		while true do
			if cfg.Forcefield then
				pcall(function()
					ApplyForceFieldToModel(Camera)
					if LocalPlayer.Character then
						ApplyForceFieldToModel(LocalPlayer.Character)
					end
				end)
			end
			task.wait(0.8)
		end
	end)
	--
	-- [[ // Lightning + Damage Indicator // ]]
	local function SpawnLightning(position)
		local model = Instance.new("Model")
		model.Name = "ProceduralLightning"
		model.Parent = Workspace
		local startPos = position + Vector3.new(0, 35, 0)
		local endPos = position
		local segments = 7
		local currentPos = startPos
		local light = Instance.new("PointLight")
		light.Color = Color3.fromRGB(160, 180, 255)
		light.Range = 15
		light.Brightness = 6
		local parts = {}
		for i = 1, segments do
			local nextPos
			if i == segments then
				nextPos = endPos
			else
				local progress = i / segments
				local targetBase = startPos:Lerp(endPos, progress)
				nextPos = targetBase + Vector3.new(math.random(-4, 4), math.random(-1, 1), math.random(-4, 4))
			end
			local distance = (nextPos - currentPos).Magnitude
			local p = Instance.new("Part")
			p.Anchored = true
			p.CanCollide = false
			p.Material = Enum.Material.Neon
			p.Color = Color3.fromRGB(200, 210, 255)
			p.Size = Vector3.new(0.6, 0.6, distance)
			p.CFrame = CFrame.new(currentPos:Lerp(nextPos, 0.5), nextPos)
			p.Parent = model
			if i == 1 then light.Parent = p end
			table.insert(parts, p)
			currentPos = nextPos
		end
		task.delay(0.12, function()
			for _, part in ipairs(parts) do
				TweenService:Create(part, TweenInfo.new(0.25), {Transparency = 1, Size = Vector3.new(0, 0, part.Size.Z)}):Play()
			end
			TweenService:Create(light, TweenInfo.new(0.25), {Brightness = 0}):Play()
			task.wait(0.3)
			model:Destroy()
		end)
	end
	--
	local function ShowDamageIndicator(position, damage)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 1
		part.CFrame = CFrame.new(position + Vector3.new(math.random(-1, 1), math.random(1, 2), math.random(-1, 1)))
		part.Parent = Workspace
		local bb = Instance.new("BillboardGui")
		bb.Size = UDim2.new(0, 100, 0, 40)
		bb.AlwaysOnTop = true
		bb.Parent = part
		local text = Instance.new("TextLabel")
		text.Parent = bb
		text.BackgroundTransparency = 1
		text.Size = UDim2.new(1, 0, 1, 0)
		text.Font = Enum.Font.GothamBlack
		text.Text = "-" .. tostring(math.floor(damage))
		text.TextColor3 = Color3.fromRGB(255, 80, 80)
		text.TextSize = 16
		text.TextStrokeTransparency = 0
		local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(part, tweenInfo, {CFrame = part.CFrame + Vector3.new(0, 2.5, 0)}):Play()
		local fadeTween = TweenService:Create(text, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
		fadeTween:Play()
		fadeTween.Completed:Connect(function()
			part:Destroy()
		end)
	end
	--
	local function BindDamageWatch(player)
		if player == LocalPlayer then return end
		local character = player.Character
		if not character then return end
		if character:FindFirstChild("PuppyDamageBound") then return end
		local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
		local hum = character:FindFirstChildWhichIsA("Humanoid")
		if hum and root then
			local marker = Instance.new("BoolValue")
			marker.Name = "PuppyDamageBound"
			marker.Parent = character
			local lastHealth = hum.Health
			local conn
			conn = hum.HealthChanged:Connect(function(hp)
				if not character or not character.Parent then
					conn:Disconnect()
					return
				end
				if hp < lastHealth and hp > 0 and cfg.DamageIndicator then
					ShowDamageIndicator(root.Position, lastHealth - hp)
				end
				if hp <= 0 and cfg.Lightning and not character:FindFirstChild("PuppyLightningSpawned") then
					local deadTag = Instance.new("BoolValue")
					deadTag.Name = "PuppyLightningSpawned"
					deadTag.Parent = character
					SpawnLightning(root.Position)
					conn:Disconnect()
				end
				lastHealth = hp
			end)
		end
	end
	--
	local function BindPlayer(player)
		BindDamageWatch(player)
		player.CharacterAdded:Connect(function()
			task.wait(0.3)
			BindDamageWatch(player)
		end)
	end
	--
	for _, player in ipairs(Players:GetPlayers()) do
		BindPlayer(player)
	end
	Players.PlayerAdded:Connect(BindPlayer)
	--
	-- [[ // ESP (Boxes / Skeleton / Name / Health / Distance / Chams / Light) // ]]
	local BONE_MAP_R15 = {
		{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
		{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
		{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
		{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
		{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
	}
	local BONE_MAP_R6 = {
		{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
		{"Torso", "Left Leg"}, {"Torso", "Right Leg"}
	}
	--
	local espInstances = {}
	--
	local function CreateESP(player)
		if espInstances[player] then return end
		local objects = {
			BoxOutline = Drawing.new("Square"),
			Box = Drawing.new("Square"),
			Name = Drawing.new("Text"),
			Distance = Drawing.new("Text"),
			HealthOutline = Drawing.new("Square"),
			Health = Drawing.new("Square"),
			Bones = {}
		}
		objects.BoxOutline.Thickness = 2
		objects.BoxOutline.Filled = false
		objects.BoxOutline.Transparency = 0.5
		objects.BoxOutline.Color = cfg.OutlineColor
		objects.Box.Thickness = 1
		objects.Box.Filled = false
		objects.Box.Transparency = 1
		objects.Name.Center = true
		objects.Name.Outline = true
		objects.Name.Font = 1
		objects.Name.Size = 13
		objects.Name.Color = cfg.NameColor
		objects.Distance.Center = true
		objects.Distance.Outline = true
		objects.Distance.Font = 1
		objects.Distance.Size = 12
		objects.Distance.Color = cfg.DistanceColor
		objects.HealthOutline.Thickness = 1
		objects.HealthOutline.Filled = true
		objects.HealthOutline.Transparency = 0.5
		objects.HealthOutline.Color = cfg.OutlineColor
		objects.Health.Filled = true
		objects.Health.Transparency = 1
		for i = 1, 15 do
			local boneLine = Drawing.new("Line")
			boneLine.Thickness = 1
			boneLine.Transparency = 1
			boneLine.Visible = false
			table.insert(objects.Bones, boneLine)
		end
		espInstances[player] = objects
	end
	--
	local function RemoveESP(player)
		local objects = espInstances[player]
		if objects then
			for _, obj in pairs(objects) do
				if type(obj) == "table" then
					for _, bone in pairs(obj) do bone:Remove() end
				else
					obj:Remove()
				end
			end
			espInstances[player] = nil
		end
	end
	--
	local function CleanChams(char)
		if not char then return end
		local hl = char:FindFirstChild("PuppyChams")
		if hl then hl:Destroy() end
		local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
		local light = root and root:FindFirstChild("PuppyEnemyLight")
		if light then light:Destroy() end
	end
	--
	RunService.RenderStepped:Connect(function()
		Camera = Workspace.CurrentCamera
		if not Camera then return end
		local myTeam = GetTeam(LocalPlayer)
		local camPos = Camera.CFrame.Position
		for _, player in next, Players:GetPlayers() do
			local objects = espInstances[player]
			if player == LocalPlayer then
				if objects then RemoveESP(player) end
				continue
			end
			local char = player.Character
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char.PrimaryPart)
			local isDead = char and (char:GetAttribute("Dead") == true or (humanoid and humanoid.Health <= 0))
			local playerTeam = GetTeam(player)
			local isTeam = myTeam ~= nil and playerTeam == myTeam
			local allowed = cfg.ESP and char and rootPart and not isDead
			if allowed and cfg.ESPTCheck and isTeam then allowed = false end
			if allowed and (camPos - rootPart.Position).Magnitude > cfg.RenderDist then allowed = false end
			if not allowed then
				if objects then
					for _, obj in pairs(objects) do
						if type(obj) ~= "table" then obj.Visible = false end
					end
					for _, bone in pairs(objects and objects.Bones or {}) do bone.Visible = false end
				end
				CleanChams(char)
				continue
			end
			if not objects then
				CreateESP(player)
				objects = espInstances[player]
			end
			local targetColor = cfg.BoxColor
			if cfg.TeamColors and playerTeam and TeamColors[playerTeam] then
				targetColor = TeamColors[playerTeam]
			end
			local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
			--
			if cfg.Chams then
				if not char:FindFirstChild("PuppyChams") then
					local hl = Instance.new("Highlight")
					hl.Name = "PuppyChams"
					hl.Adornee = char
					hl.FillColor = cfg.ChamsColor
					hl.FillTransparency = 0.25
					hl.OutlineColor = cfg.ChamsColor
					hl.OutlineTransparency = 0
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = char
				else
					local hl = char:FindFirstChild("PuppyChams")
					hl.FillColor = cfg.ChamsColor
					hl.OutlineColor = cfg.ChamsColor
				end
			else
				CleanChams(char)
			end
			if cfg.EnemyLight and not isDead then
				if not rootPart:FindFirstChild("PuppyEnemyLight") then
					local light = Instance.new("PointLight")
					light.Name = "PuppyEnemyLight"
					light.Color = Color3.fromRGB(130, 150, 255)
					light.Range = 10
					light.Brightness = 2.0
					light.Shadows = false
					light.Parent = rootPart
				end
			end
			if not onScreen then
				for _, obj in pairs(objects) do
					if type(obj) ~= "table" then obj.Visible = false end
				end
				for _, bone in pairs(objects.Bones) do bone.Visible = false end
				continue
			end
			--
			local head = char:FindFirstChild("Head")
			local headPos = head and Camera:WorldToViewportPoint(head.Position) or Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2, 0))
			local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
			local height = math.abs(headPos.Y - legPos.Y)
			local width = height / 1.6
			local boxX = rootPos.X - (width / 2)
			local boxY = headPos.Y
			--
			objects.Box.Visible = cfg.Boxes
			objects.BoxOutline.Visible = cfg.Boxes
			if cfg.Boxes then
				local size = Vector2.new(width, height)
				local pos = Vector2.new(boxX, boxY)
				objects.Box.Size = size
				objects.Box.Position = pos
				objects.Box.Color = targetColor
				objects.BoxOutline.Size = size
				objects.BoxOutline.Position = pos
				objects.BoxOutline.Color = cfg.OutlineColor
			end
			--
			local isR15 = char:FindFirstChild("UpperTorso") ~= nil
			local activeBoneMap = isR15 and BONE_MAP_R15 or BONE_MAP_R6
			for i, boneLine in ipairs(objects.Bones) do
				local connection = activeBoneMap[i]
				if cfg.Skeletons and connection then
					local partA = char:FindFirstChild(connection[1])
					local partB = char:FindFirstChild(connection[2])
					if partA and partB then
						local posA, visA = Camera:WorldToViewportPoint(partA.Position)
						local posB, visB = Camera:WorldToViewportPoint(partB.Position)
						if visA and visB then
							boneLine.From = Vector2.new(posA.X, posA.Y)
							boneLine.To = Vector2.new(posB.X, posB.Y)
							boneLine.Color = targetColor
							boneLine.Visible = true
						else
							boneLine.Visible = false
						end
					else
						boneLine.Visible = false
					end
				else
					boneLine.Visible = false
				end
			end
			--
			if cfg.Names then
				objects.Name.Text = player.Name
				objects.Name.Position = Vector2.new(rootPos.X, boxY - 15)
				objects.Name.Color = cfg.NameColor
				objects.Name.Visible = true
			else
				objects.Name.Visible = false
			end
			--
			if cfg.Distance then
				local distance = math.floor((camPos - rootPart.Position).Magnitude)
				objects.Distance.Text = tostring(distance) .. "m"
				objects.Distance.Position = Vector2.new(rootPos.X, boxY + height + 2)
				objects.Distance.Color = cfg.DistanceColor
				objects.Distance.Visible = true
			else
				objects.Distance.Visible = false
			end
			--
			if cfg.Health and humanoid then
				local barPadding, barWidth = 4, 2
				local barX = boxX - barPadding - barWidth
				local healthPercentage = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
				local healthHeight = height * healthPercentage
				objects.Health.Color = Color3.fromHex("#32CD32"):Lerp(Color3.fromHex("#FF0000"), 1 - healthPercentage)
				objects.HealthOutline.Position = Vector2.new(barX - 1, boxY - 1)
				objects.HealthOutline.Size = Vector2.new(barWidth + 2, height + 2)
				objects.Health.Position = Vector2.new(barX, boxY + (height - healthHeight))
				objects.Health.Size = Vector2.new(barWidth, healthHeight)
				objects.Health.Visible = true
				objects.HealthOutline.Visible = true
			else
				objects.Health.Visible = false
				objects.HealthOutline.Visible = false
			end
		end
	end)
	--
	Players.PlayerRemoving:Connect(RemoveESP)
	--
	-- [[ // Skin Changer Engine // ]]
	local G = {knifeChangerSupported = true, executor = (identifyexecutor and identifyexecutor()) or "Unknown"}
	--
	if string.find(G.executor, "RonixExploit", 1, true)
		or string.find(G.executor, "Xeno", 1, true)
		or string.find(G.executor, "Solara", 1, true) then
		G.knifeChangerSupported = false
	end
	--
	local SD = {
		SkinsRoot = nil,
		SkinSelections = {},
		GloveSelections = {},
		GloveFolders = {}
	}
	--
	pcall(function()
		SD.SkinsRoot = RS:FindFirstChild("Assets") and RS.Assets:FindFirstChild("Skins")
	end)
	--
	if SD.SkinsRoot then
		pcall(function()
			for _, wf in ipairs(SD.SkinsRoot:GetChildren()) do
				local skinFolderSkins = {}
				for _, sf in ipairs(wf:GetChildren()) do
					skinFolderSkins[#skinFolderSkins + 1] = sf.Name
				end
				table.sort(skinFolderSkins)
				SD.SkinSelections[wf.Name] = skinFolderSkins
			end
			for _, folder in ipairs(SD.SkinsRoot:GetChildren()) do
				if (folder.Name:match("Glove")
					or folder.Name:match("Gloves")
					or folder.Name == "Hand Wraps")
					and not (
						folder.Name:match("T Glove")
						or folder.Name:match("CT Glove")
						or folder.Name:match("T Gloves")
						or folder.Name:match("CT Gloves")
					) then
					SD.GloveFolders[#SD.GloveFolders + 1] = folder
				end
			end
		end)
	end
	--
	for _, gf in ipairs(SD.GloveFolders) do
		local gloveSkins = {"Default"}
		for _, skin in ipairs(gf:GetChildren()) do
			gloveSkins[#gloveSkins + 1] = skin.Name
		end
		SD.GloveSelections[gf.Name] = gloveSkins
	end
	--
	local SKConfig = {
		SkinChanger = {Enabled = false, Skins = {}},
		KnifeChanger = {Enabled = false, Model = "Skeleton Knife"},
		GloveChanger = {Enabled = false, Gloves = {}, Model = "Sports Gloves", Skin = "Default"}
	}
	--
	for w, s in pairs(SD.SkinSelections) do
		SKConfig.SkinChanger.Skins[w] = s[1] or "Default"
	end
	for _, gf in ipairs(SD.GloveFolders) do
		SKConfig.GloveChanger.Gloves[gf.Name] = "Default"
	end
	--
	local Checkifbaseknife = {"CT Knife", "T Knife", "Knife"}
	--
	local function Checkknife(w)
		if not w then return false end
		for _, k in ipairs(Checkifbaseknife) do
			if w == k then return true end
		end
		return false
	end
	--
	local SafeRequire = function(module)
		if not module then return nil end
		local success, result = pcall(function()
			return require(module)
		end)
		if success and result and type(result) == "table" then
			return result
		end
		return nil
	end
	--
	local KM = {"Karambit", "Butterfly Knife", "Flip Knife", "Gut Knife", "M9 Bayonet", "Skeleton Knife", "Stiletto Knife"}
	local EW = {"Driver Gloves", "Sports Gloves", "Operator Gloves", "Hand Wraps"}
	local GM = {}
	for k in pairs(SD.GloveSelections) do
		GM[#GM + 1] = k
	end
	table.sort(GM)
	--
	local function InitKnifeChanger()
		pcall(function()
			local SM = RS:FindFirstChild("Database")
				and RS.Database:FindFirstChild("Components")
				and RS.Database.Components:FindFirstChild("Libraries")
				and RS.Database.Components.Libraries:FindFirstChild("Skins")
			local VM = RS:FindFirstChild("Classes")
				and RS.Classes:FindFirstChild("WeaponComponent")
				and RS.Classes.WeaponComponent:FindFirstChild("Classes")
				and RS.Classes.WeaponComponent.Classes:FindFirstChild("Viewmodel")
			if not SM or not VM then return end
			local Sk = SafeRequire(SM)
			local Vm = SafeRequire(VM)
			if not Sk or not Vm then return end
			--
			local oGCM = Sk.GetCameraModel
			Sk.GetCameraModel = function(w, sk, ...)
				if SKConfig.KnifeChanger.Enabled and w and Checkknife(w) then
					local newKnife = SKConfig.KnifeChanger.Model
					local newSkin = SKConfig.SkinChanger.Skins[newKnife] or "Vanilla"
					local success, result = pcall(oGCM, newKnife, newSkin, ...)
					if success and result then return result end
				end
				local success, result = pcall(oGCM, w, sk, ...)
				if success then return result end
				return nil
			end
			--
			local oGChM = Sk.GetCharacterModel
			Sk.GetCharacterModel = function(w, sk, ...)
				if SKConfig.KnifeChanger.Enabled and w and Checkknife(w) then
					local newKnife = SKConfig.KnifeChanger.Model
					local newSkin = SKConfig.SkinChanger.Skins[newKnife] or "Vanilla"
					local success, result = pcall(oGChM, newKnife, newSkin, ...)
					if success and result then return result end
				end
				local success, result = pcall(oGChM, w, sk, ...)
				if success then return result end
				return nil
			end
			--
			local oVN = Vm.new
			Vm.new = function(vc, w, sk, ...)
				if SKConfig.KnifeChanger.Enabled and w and Checkknife(w) then
					local newKnife = SKConfig.KnifeChanger.Model
					local newSkin = SKConfig.SkinChanger.Skins[newKnife] or "Vanilla"
					local success, result = pcall(oVN, vc, newKnife, newSkin, ...)
					if success and result then return result end
				end
				local success, result = pcall(oVN, vc, w, sk, ...)
				if success then return result end
				return nil
			end
			--
			if Sk.GetGloves then
				local oGG = Sk.GetGloves
				Sk.GetGloves = function(g, sk)
					if SKConfig.GloveChanger.Enabled and SKConfig.GloveChanger.Model then
						local gModel = SKConfig.GloveChanger.Model
						local gloveSkin = SKConfig.GloveChanger.Gloves[gModel] or "Default"
						local success, result = pcall(oGG, gModel, gloveSkin)
						if success and result then return result end
					end
					local success, result = pcall(oGG, g, sk)
					if success then return result end
					return nil
				end
			end
		end)
	end
	--
	if G.knifeChangerSupported then
		InitKnifeChanger()
	end
	--
	local function UpdateInventoryNames()
		local invGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGui")
		if not invGui then return end
		local gameplay = invGui:FindFirstChild("Gameplay")
		if not gameplay then return end
		local bottom = gameplay:FindFirstChild("Bottom")
		if not bottom then return end
		local inv = bottom:FindFirstChild("Inventory")
		if not inv then return end
		local meleeSlot = inv:FindFirstChild("Melee")
		if meleeSlot and SKConfig.KnifeChanger.Enabled then
			local weapon = meleeSlot:FindFirstChild("Weapon")
			if weapon then
				local weaponName = weapon:FindFirstChild("WeaponName")
				if weaponName and weaponName:IsA("TextLabel") then
					local knifeModel = SKConfig.KnifeChanger.Model
					local sel = SKConfig.SkinChanger.Skins[knifeModel]
					local star = utf8.char(9733)
					if sel and sel ~= "Default" then
						weaponName.Text = star .. " " .. knifeModel .. " | " .. sel
					else
						weaponName.Text = star .. " " .. knifeModel
					end
				end
			end
		end
	end
	--
	local function GetWeaponModel()
		local cam = Workspace.CurrentCamera
		if not cam then return nil end
		for _, ch in pairs(cam:GetChildren()) do
			if ch:IsA("Model")
				and ch.Name ~= "Arms"
				and ch.Name ~= "Arms1"
				and ch.Name ~= "Arms2"
				and ch.Name ~= "Viewmodel" then
				return ch
			end
		end
		return nil
	end
	--
	local function ApplySkin()
		if not SD.SkinsRoot then return end
		local wm = GetWeaponModel()
		if not wm then return end
		local own = wm.Name
		local ewn = own
		local canApply = false
		if Checkknife(own) then
			if SKConfig.KnifeChanger.Enabled then
				ewn = SKConfig.KnifeChanger.Model
				canApply = true
			end
		else
			if SKConfig.SkinChanger.Enabled then
				canApply = true
			end
		end
		if not canApply then return end
		local sel = SKConfig.SkinChanger.Skins[ewn]
		if not sel or sel == "Default" then return end
		local wsf = SD.SkinsRoot:FindFirstChild(ewn)
		if not wsf then return end
		local sf = wsf:FindFirstChild(sel)
		if not sf then return end
		local cf = sf:FindFirstChild("Camera")
		if not cf then return end
		local fn = cf:FindFirstChild("Factory New")
		if not fn then return end
		for _, sa in pairs(fn:GetChildren()) do
			if sa:IsA("SurfaceAppearance") then
				local pt = wm:FindFirstChild(sa.Name, true)
				if pt and (pt:IsA("BasePart") or pt:IsA("MeshPart")) then
					for _, old in pairs(pt:GetChildren()) do
						if old:IsA("SurfaceAppearance") then old:Destroy() end
					end
					sa:Clone().Parent = pt
				end
			end
		end
		UpdateInventoryNames()
	end
	--
	local function ApplyGloves()
		if not SKConfig.GloveChanger.Enabled then return end
		local cam = Workspace.CurrentCamera
		if not cam then return end
		local am
		for _, ch in ipairs(cam:GetChildren()) do
			if ch:IsA("Model") and (ch.Name:match("Arms") or ch:FindFirstChild("Right Arm")) then
				am = ch
				break
			end
		end
		if not am then return end
		local la = am:FindFirstChild("Left Arm")
		local ra = am:FindFirstChild("Right Arm")
		if not la or not ra then return end
		local lg = la:FindFirstChild("Glove")
		local rg = ra:FindFirstChild("Glove")
		if not lg or not rg then return end
		for _, old in pairs(lg:GetChildren()) do
			if old:IsA("SurfaceAppearance") then old:Destroy() end
		end
		for _, old in pairs(rg:GetChildren()) do
			if old:IsA("SurfaceAppearance") then old:Destroy() end
		end
		local selectedModel = SKConfig.GloveChanger.Model
		if not selectedModel then return end
		local sel = SKConfig.GloveChanger.Gloves[selectedModel]
		if not sel or sel == "Default" then return end
		if not SD.SkinsRoot then return end
		local gloveSkinFolder = SD.SkinsRoot:FindFirstChild(selectedModel)
		if not gloveSkinFolder then return end
		local skinVariant = gloveSkinFolder:FindFirstChild(sel)
		if not skinVariant then return end
		local cameraFolder = skinVariant:FindFirstChild("Camera")
		if not cameraFolder then return end
		local factoryNew = cameraFolder:FindFirstChild("Factory New")
		if not factoryNew then return end
		for _, sa in pairs(factoryNew:GetChildren()) do
			if sa:IsA("SurfaceAppearance") then
				sa:Clone().Parent = lg
				sa:Clone().Parent = rg
			end
		end
	end
	--
	task.spawn(function()
		while true do
			pcall(function()
				if SKConfig.SkinChanger.Enabled or SKConfig.KnifeChanger.Enabled then
					ApplySkin()
				end
				if SKConfig.GloveChanger.Enabled then
					ApplyGloves()
				end
			end)
			task.wait(0.5)
		end
	end)
	--
	-- [[ // Config System // ]]
	local Controls = {}
	local ConfigFile = "gamesensegui_config.txt"
	--
	do
		local Wrapped = {}
		for _, method in ipairs({"CreateToggle", "CreateSlider", "CreateDropdown", "CreateMultibox", "CreateKeybind", "CreateColorpicker", "CreateButton"}) do
			Wrapped[method] = sections[method]
			sections[method] = function(self, Properties)
				local content = Wrapped[method](self, Properties)
				Controls[#Controls + 1] = content
				return content
			end
		end
	end
	--
	local function SerialiseValue(value)
		local t = typeof(value)
		if t == "boolean" then return "b=" .. tostring(value)
		elseif t == "number" then return "n=" .. tostring(value)
		elseif t == "Color3" then return "c=" .. string.format("%.3f,%.3f,%.3f", value.R, value.G, value.B)
		elseif t == "table" then
			if #value == 2 and typeof(value[1]) == "number" and typeof(value[2]) == "string" then return "d=" .. tostring(value[1]) end
		end
		return nil
	end
	--
	local function DeserialiseValue(kind, value)
		if kind == "b" then return value == "true"
		elseif kind == "n" then return tonumber(value)
		elseif kind == "d" then return tonumber(value)
		elseif kind == "c" then
			local r, g, b = value:match("^([%d%.]+),([%d%.]+),([%d%.]+)$")
			if r then
				return Color3.fromRGB(math.round(tonumber(r) * 255), math.round(tonumber(g) * 255), math.round(tonumber(b) * 255))
			end
		end
		return nil
	end
	--
	local function SaveConfig()
		pcall(function()
			if type(writefile) ~= "function" then return end
			--
			local Lines = {}
			for _, control in ipairs(Controls) do
				if type(control.Get) == "function" then
					local serial = SerialiseValue(control:Get())
					if serial then
						Lines[#Lines + 1] = control.Name .. ";" .. serial
					end
				end
			end
			--
			writefile(ConfigFile, table.concat(Lines, "\n"))
		end)
	end
	--
	local function LoadConfig()
		pcall(function()
			if type(readfile) ~= "function" then return end
			--
			local ok, data = pcall(readfile, ConfigFile)
			if not ok or type(data) ~= "string" or #data == 0 then return end
			--
			for line in (data .. "\n"):gmatch("([^\n]+)\n") do
				local name, kind, value = line:match("^(.+);([bndc])=(.*)$")
				if name and kind and value then
					for _, control in ipairs(Controls) do
						if control.Name == name and type(control.Set) == "function" then
							local decoded = DeserialiseValue(kind, value)
							if decoded ~= nil then
								pcall(function() control:Set(decoded) end)
							end
							break
						end
					end
				end
			end
		end)
	end
	--
	-- [[ // GUI Wiring // ]]
	--
	-- Rage -> Silent Aim
	local silentsec = rage:CreateSection({Name = "Silent Aim", Size = 210, Side = "Left"})
	silentsec:CreateToggle({Name = "Silent Aim", State = cfg.Silent, Callback = function(v) cfg.Silent = v end})
	silentsec:CreateToggle({Name = "Wallbang", State = cfg.Wallbang, Callback = function(v) cfg.Wallbang = v end})
	local HitParts = {"Head", "UpperTorso", "LowerTorso"}
	silentsec:CreateDropdown({Name = "Target Hitpart", State = 1, Options = HitParts, Callback = function(i) cfg.HitPart = HitParts[i] end})
	silentsec:CreateToggle({Name = "Team Check", State = cfg.TeamCheck, Callback = function(v) cfg.TeamCheck = v end})
	silentsec:CreateSlider({Name = "Max Distance", State = cfg.MaxDist, Max = 2000, Min = 50, Decimals = 1, Suffix = "m", Callback = function(v) cfg.MaxDist = v end})
	--
	-- Rage -> Draw FOV
	local fovsec = rage:CreateSection({Name = "Draw FOV", Size = 150, Side = "Right"})
	fovsec:CreateToggle({Name = "Use FOV", State = cfg.UseFov, Callback = function(v) cfg.UseFov = v end})
	fovsec:CreateToggle({Name = "Draw FOV", State = cfg.DrawFov, Callback = function(v) cfg.DrawFov = v end})
	fovsec:CreateSlider({Name = "FOV Radius", State = cfg.FovRadius, Max = 500, Min = 10, Decimals = 1, Suffix = "px", Callback = function(v) cfg.FovRadius = v end})
	fovsec:CreateColorpicker({Name = "FOV Color", State = cfg.FovColor, Callback = function(v) cfg.FovColor = v end})
	--
	-- Rage -> Third Person
	local tpsec = rage:CreateSection({Name = "Third Person", Size = 160, Side = "Right"})
	tpsec:CreateToggle({Name = "Third Person", State = cfg.TP, Callback = function(v) cfg.TP = v end})
	tpsec:CreateSlider({Name = "Distance", State = cfg.TPDist, Max = 10, Min = 2, Decimals = 0.5, Callback = function(v) cfg.TPDist = v end})
	tpsec:CreateSlider({Name = "Height", State = cfg.TPHeight, Max = 5, Min = 0, Decimals = 0.5, Callback = function(v) cfg.TPHeight = v end})
	--
	-- Aimbot -> No Spread
	local spreadsec = aimbot:CreateSection({Name = "No Spread", Size = 90, Side = "Left"})
	spreadsec:CreateToggle({Name = "No Spread", State = cfg.NoSpread, Callback = function(v) cfg.NoSpread = v end})
	--
	-- Aimbot -> No Recoil
	local recoilsec = aimbot:CreateSection({Name = "No Recoil", Size = 90, Side = "Right"})
	recoilsec:CreateToggle({Name = "No Recoil", State = cfg.NoRecoil, Callback = function(v) cfg.NoRecoil = v end})
	--
	-- Aimbot -> Rapid Fire
	local rapidsec = aimbot:CreateSection({Name = "Rapid Fire", Size = 120, Side = "Right"})
	rapidsec:CreateToggle({Name = "Rapid Fire", State = cfg.Firerate, Callback = function(v) cfg.Firerate = v end})
	rapidsec:CreateSlider({Name = "Fire Rate", State = cfg.FirerateValue, Max = 0.1, Min = 0.01, Decimals = 0.01, Suffix = "s", Callback = function(v) cfg.FirerateValue = v end})
	--
	-- Visuals -> Player ESP
	local espsec = visuals:CreateSection({Name = "Player ESP", Size = 330, Side = "Left"})
	espsec:CreateToggle({Name = "ESP", State = cfg.ESP, Callback = function(v) cfg.ESP = v end})
	espsec:CreateToggle({Name = "ESP Team Check", State = cfg.ESPTCheck, Callback = function(v) cfg.ESPTCheck = v end})
	espsec:CreateToggle({Name = "Boxes", State = cfg.Boxes, Callback = function(v) cfg.Boxes = v end})
	espsec:CreateToggle({Name = "Skeletons", State = cfg.Skeletons, Callback = function(v) cfg.Skeletons = v end})
	espsec:CreateToggle({Name = "Names", State = cfg.Names, Callback = function(v) cfg.Names = v end})
	espsec:CreateToggle({Name = "Health", State = cfg.Health, Callback = function(v) cfg.Health = v end})
	espsec:CreateToggle({Name = "Distance", State = cfg.Distance, Callback = function(v) cfg.Distance = v end})
	espsec:CreateSlider({Name = "Max Render Distance", State = cfg.RenderDist, Max = 5000, Min = 100, Decimals = 1, Suffix = "m", Callback = function(v) cfg.RenderDist = v end})
	--
	-- Visuals -> ESP Colors
	local colorsec = visuals:CreateSection({Name = "ESP Colors", Size = 170, Side = "Left"})
	colorsec:CreateColorpicker({Name = "Box Color", State = cfg.BoxColor, Callback = function(v) cfg.BoxColor = v end})
	colorsec:CreateColorpicker({Name = "Outline Color", State = cfg.OutlineColor, Callback = function(v) cfg.OutlineColor = v end})
	colorsec:CreateColorpicker({Name = "Name Color", State = cfg.NameColor, Callback = function(v) cfg.NameColor = v end})
	colorsec:CreateColorpicker({Name = "Distance Color", State = cfg.DistanceColor, Callback = function(v) cfg.DistanceColor = v end})
	colorsec:CreateToggle({Name = "Team Colors", State = cfg.TeamColors, Callback = function(v) cfg.TeamColors = v end})
	--
	-- Visuals -> Chams & Models
	local chamsec = visuals:CreateSection({Name = "Chams & Models", Size = 150, Side = "Right"})
	chamsec:CreateToggle({Name = "Chams", State = cfg.Chams, Callback = function(v) cfg.Chams = v end})
	chamsec:CreateColorpicker({Name = "Chams Color", State = cfg.ChamsColor, Callback = function(v) cfg.ChamsColor = v end})
	chamsec:CreateToggle({Name = "Enemy Light", State = cfg.EnemyLight, Callback = function(v) cfg.EnemyLight = v end})
	chamsec:CreateToggle({Name = "Forcefield Style", State = cfg.Forcefield, Callback = function(v) cfg.Forcefield = v end})
	--
	-- Visuals -> World FX
	local worldsec = visuals:CreateSection({Name = "World FX", Size = 170, Side = "Right"})
	worldsec:CreateToggle({Name = "Night Mode", State = cfg.NightMode, Callback = function(v) cfg.NightMode = v end})
	worldsec:CreateToggle({Name = "Flashlight", State = cfg.Flashlight, Callback = function(v) cfg.Flashlight = v end})
	worldsec:CreateToggle({Name = "Lightning on Kill", State = cfg.Lightning, Callback = function(v) cfg.Lightning = v end})
	worldsec:CreateToggle({Name = "Damage Indicator", State = cfg.DamageIndicator, Callback = function(v) cfg.DamageIndicator = v end})
	--
	-- Settings -> Help
	local helpssec = setting:CreateSection({Name = "Menu", Size = 200, Side = "Left"})
	helpssec:CreateDropdown({Name = "Menu Keys", State = 1, Options = {"Z = Toggle Menu", "X = Toggle Menu"}, Callback = function() end})
	--
	-- Settings -> Config
	local cfgsection = setting:CreateSection({Name = "Config", Size = 80, Side = "Right"})
	cfgsection:CreateButton({Name = "Save Config", Callback = SaveConfig})
	cfgsection:CreateButton({Name = "Load Config", Callback = LoadConfig})
	--
	-- Skins -> Weapon Skins
	local weaponbox = skins:CreateSection({Name = "Weapon Skins", Size = 460, Side = "Left"})
	weaponbox:CreateToggle({Name = "Enable Weapon Skins", State = SKConfig.SkinChanger.Enabled, Callback = function(v) SKConfig.SkinChanger.Enabled = v end})
	for w, s in pairs(SD.SkinSelections) do
		if not table.find(KM, w) and not table.find(GM, w) and not table.find(EW, w) then
			weaponbox:CreateDropdown({Name = w, State = 1, Options = s, Callback = function(i) SKConfig.SkinChanger.Skins[w] = s[i] end})
		end
	end
	--
	local DEFAULT_KNIFE_INDEX = 1
	for ki, kn in ipairs(KM) do
		if kn == "Skeleton Knife" then DEFAULT_KNIFE_INDEX = ki end
	end
	--
	-- Skins -> Knife Changer
	local knifebox = skins:CreateSection({Name = "Knife Changer", Size = 250, Side = "Right"})
	knifebox:CreateToggle({Name = "Enable Knife Changer", State = SKConfig.KnifeChanger.Enabled, Callback = function(v) SKConfig.KnifeChanger.Enabled = v end})
	knifebox:CreateDropdown({Name = "Knife Model", State = DEFAULT_KNIFE_INDEX, Options = KM, Callback = function(i) SKConfig.KnifeChanger.Model = KM[i] end})
	for _, kn in ipairs(KM) do
		local ks = SD.SkinSelections[kn]
		if ks then
			knifebox:CreateDropdown({Name = kn .. " Skin", State = 1, Options = ks, Callback = function(i) SKConfig.SkinChanger.Skins[kn] = ks[i] end})
		end
	end
	--
	local DEFAULT_GLOVE_INDEX = 1
	for gi, gName in ipairs(GM) do
		if gName == "Sports Gloves" then DEFAULT_GLOVE_INDEX = gi end
	end
	--
	-- Skins -> Glove Changer
	local glovebox = skins:CreateSection({Name = "Glove Changer", Size = 250, Side = "Right"})
	glovebox:CreateToggle({Name = "Enable Gloves Changer", State = SKConfig.GloveChanger.Enabled, Callback = function(v) SKConfig.GloveChanger.Enabled = v end})
	if #GM > 0 then
		glovebox:CreateDropdown({Name = "Glove Model", State = DEFAULT_GLOVE_INDEX, Options = GM, Callback = function(i) SKConfig.GloveChanger.Model = GM[i] end})
		for _, gName in ipairs(GM) do
			local gSkins = SD.GloveSelections[gName]
			if gSkins then
				glovebox:CreateDropdown({Name = gName .. " Skin", State = 1, Options = gSkins, Callback = function(i) SKConfig.GloveChanger.Gloves[gName] = gSkins[i] end})
			end
		end
	end
	--
	-- [[ // Load Config On Start // ]]
	LoadConfig()
end)
--
