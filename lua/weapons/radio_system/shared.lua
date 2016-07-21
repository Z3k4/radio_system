if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	util.AddNetworkString("RS_ChangeFrequence")
end

SWEP.Author = "Z3k4"
SWEP.Contact = "z3k4@outlook.fr"
SWEP.Purpose = "Une radio ? Vous pensez que je peux écouter du psy avec ?"
SWEP.Category = "Radio"


SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/dorado/tarjeta4.mdl"
SWEP.ViewModelFOV = 1


SWEP.PrintName = "Radio"

SWEP.Slot = 1
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Frequence" )
	self:NetworkVar( "Bool", 0, "Enabled")
end

function SWEP:Initialize()
	self:SetFrequence(100)
end

if (CLIENT) then
	local activate = false
	local opacity = 20

	surface.CreateFont("RS_FrequenceFont", {
	font = "Digital-7",
	size = 80

	})

	local function CreateCustomRect(posx,posy,w,h,color)
		surface.SetDrawColor(color)
		surface.DrawRect(posx,posy,w,h)
	end

	function SWEP:DrawHUD()
		if self:GetEnabled() then
			opacity = 255
		else
			opacity = 20
		end

		local w,h = 250,400
		local posx,posy = ScrW() - w,ScrH() - h

		
		draw.RoundedBox(15,posx -10,posy,w,h / 2,Color(110,110,110))
		draw.RoundedBoxEx(15,posx + 15 - 10,posy + h /2,w - 30,h / 2.5,Color(110,110,110),false,false,true,true)
		draw.RoundedBox(20,posx + 10,posy + 20,w- 40,100,Color(0,0,0))

		draw.RoundedBox(15,posx + w - 70,posy + 130,30,30,Color(0,0,0))
		draw.RoundedBox(15,posx + w - 70,posy + 130,30,30,Color(255,0,0,opacity))

		surface.SetDrawColor(0,100,255)
		surface.DrawRect(posx + 20,posy + 30, w-60,80)

		CreateCustomRect(posx + 10,posy - 60,25,60,Color(110,110,110))
		CreateCustomRect(posx + 15,posy - 120,15,60,Color(110,110,110))
		draw.RoundedBox(12,posx + 10,posy - 130,25,25,Color(0,0,0))

		draw.DrawText(string.format( "%.1f", self:GetFrequence()),"RS_FrequenceFont",posx + 200,posy + 30,Color(255,255,255),TEXT_ALIGN_RIGHT)
	end

	function SWEP:PrimaryAttack()
	
	end

	function SWEP:SecondaryAttack()
	
	end

end

if (SERVER) then
	function SWEP:PrimaryAttack()
		if timer.Exists("RS_CoolDownFrequence") then return end
			timer.Create("RS_CoolDownFrequence",0.1,1,function()
				local frequence = self:GetFrequence()
				self:SetFrequence(frequence + 0.5)
			end)
		end

	function SWEP:SecondaryAttack()
		if timer.Exists("RS_CoolDownFrequence") then return end
			timer.Create("RS_CoolDownFrequence",0.1,1,function()
				local frequence = self:GetFrequence()
				self:SetFrequence(frequence - 0.5)
			end)
		end
end

function SWEP:Think()
	local ply = self.Owner

	if ply:GetActiveWeapon() == self then
		if ply:KeyDown(IN_USE) then
			if (SERVER) then
				self:SetEnabled(true)
			else
				RunConsoleCommand("+voicerecord")
			end
		else
			if (SERVER) then
				self:SetEnabled(false)
			else
				RunConsoleCommand("-voicerecord")
			end
		end
	end
end