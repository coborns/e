--[[

                                                                     
                                                                     
LLLLLLLLLLL                                                    iiii  
L:::::::::L                                                   i::::i 
L:::::::::L                                                    iiii  
LL:::::::LL                                                          
  L:::::L                  ooooooooooo      ggggggggg   gggggiiiiiii 
  L:::::L                oo:::::::::::oo   g:::::::::ggg::::gi:::::i 
  L:::::L               o:::::::::::::::o g:::::::::::::::::g i::::i 
  L:::::L               o:::::ooooo:::::og::::::ggggg::::::gg i::::i 
  L:::::L               o::::o     o::::og:::::g     g:::::g  i::::i 
  L:::::L               o::::o     o::::og:::::g     g:::::g  i::::i 
  L:::::L               o::::o     o::::og:::::g     g:::::g  i::::i 
  L:::::L         LLLLLLo::::o     o::::og::::::g    g:::::g  i::::i 
LL:::::::LLLLLLLLL:::::Lo:::::ooooo:::::og:::::::ggggg:::::g i::::::i
L::::::::::::::::::::::Lo:::::::::::::::o g::::::::::::::::g i::::::i
L::::::::::::::::::::::L oo:::::::::::oo   gg::::::::::::::g i::::::i
LLLLLLLLLLLLLLLLLLLLLLLL   ooooooooooo       gggggggg::::::g iiiiiiii
                                                     g:::::g         
                                         gggggg      g:::::g         
                                         g:::::gg   gg:::::g         
                                          g::::::ggg:::::::g         
                                           gg:::::::::::::g          
                                             ggg::::::ggg            
                                                gggggg               



                                                                                                                        MADE BY @COBORNS 
                                                                                                                 DONT SKID OR ITS GONNA BE OBSF
]]--
















































































































































































































































































































































-- bruh stop coming down here skid!*&@#^*!&@^#*&!@^#*&








































































































































-- ok and your still here wow







































































































































-- if ur gonna skid atleast ask me first



















































































--[[

HAHAHAHAHAHA ITS OBSF YOU FUCKIONG SKID 

]]--






local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId

--// Declare the Prefabs asset
ReGui:Init({
	Prefabs = InsertService:LoadLocalAsset(PrefabsId)
})

ReGui:DefineTheme("Cherry", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 100, 120),
	Text = Color3.fromRGB(200, 180, 200),
	
	FrameBg = Color3.fromRGB(25, 20, 25),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(120, 100, 120),
	FrameBgTransparencyActive = 0.4,
	
	CheckMark = Color3.fromRGB(150, 100, 150),
	SliderGrab = Color3.fromRGB(150, 100, 150),
	ButtonsBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
	RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),
	
	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(50, 45, 50),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
	RegionBgTransparency = 1,
})

--// Tabs
local Window = ReGui:Window({
	Title = "Logi - " .. Player.Name,
	Theme = "Cherry",
	NoCollapse = true,
	NoResize = true,
	NoClose = false,
	Size = UDim2.new(0, 450, 0, 79),
}):Center()


Window:Label({
    Text = "thx for using ts click the buttons for the stuff ig"
})

Window:Separator() --// Only line

local Row = Window:Row()


Row:Button({
	Text = "Main",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Visual",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Self",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Combat",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Movement",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Teleport",
	Callback = function(self)
		print("cuming soon")
	end
})



Row:Button({
	Text = "World",
	Callback = function(self)
		print("cuming soon")
	end
})

Row:Button({
	Text = "Settings",
	Callback = function(self)
		print("cuming soon")
	end
})
