AddCSLuaFile()

if SERVER then
  
   resource.AddFile("materials/piano_launcher/icon_piano.png")
   resource.AddFile("models/fishy/furniture/piano.mdl")
   resource.AddFile("models/fishy/furniture/piano.phy")
   resource.AddFile("models/fishy/furniture/piano.vvd")
   resource.AddFile("Sound/piano.mp3")
   
	sound.Add {
	name="Piano_music",
	channel=CHAN_STATIC,
	volume=1,
	level=100,
	pitch=100,
	sound="piano.mp3"
	}
     
	SWEP.HoldType           = "pistol"
	 
elseif CLIENT then
    SWEP.PrintName          = "Piano Launcher"
    SWEP.Slot               = 6
    SWEP.SlotPos            = 3
    SWEP.DrawCrosshair = false
     
    SWEP.EquipMenuData = {
      type = "Bard's Dream",
      desc = "Launch a god damn piano at your plebian foes\nto teach them some much needed class."
   }
    
   SWEP.Icon = "materials/piano_launcher/icon_piano.png"
end

-- General settings
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Piano Launcher"
SWEP.Base = "weapon_tttbase" -- Set to weapon_tttbase when not testing
SWEP.Author = "RaptureAwaits"
SWEP.ViewModel                 = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel             = "models/weapons/w_pist_usp.mdl"
 
-- TTT Settings
SWEP.NoSights = true
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

-- Gun Behaviour
SWEP.Primary.ClipSize        = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic        = false
SWEP.Primary.Delay				= 0.2
  
local ShootSoundFire = Sound("Airboat.FireGunHeavy")
local ShootSoundFail = Sound("WallHealth.Deny")
  
function SWEP:Initialize() if SERVER then self:SetWeaponHoldType(self.HoldType) end self:SetNWBool("Used", false) end
 
function SWEP:PrimaryAttack()
	if self:Clip1() < 1 then 
		self:EmitSound(ShootSoundFail)
		return
	end
	
	self:EmitSound(ShootSoundFire)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
	
	if SERVER then
		self:TakePrimaryAmmo(1)
		self:LaunchPiano()
	else
		return
	end
end

function SWEP:SecondaryAttack()
	if self:Clip1() < 1 then 
		self:EmitSound(ShootSoundFail)
		return
	end
	
	local play_tr = util.TraceLine({ -- Trace that determines where the player is aiming
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 99999,
		filter = self.Owner
	})
	
	local up_vect = Vector(0, 0, 1)
	local hit_tr = util.TraceLine({ -- Trace that travels directly upwards from the player trace hit position, used to determine if play_tr.HitPos is below open sky
		start = play_tr.HitPos,
		endpos = play_tr.HitPos + up_vect * 99999,
		filter = play_tr.Entity -- Don't want to hit an entity with play_tr just to hit it again with hit_tr, as nothing would happen
	})
	
	if hit_tr.HitSky then -- If hit_tr hits the sky uninterrupted, our orbital piano strike can take place
		self:EmitSound(ShootSoundFire)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
		
		local piano_spawn_pos = play_tr.HitPos + Vector(0, 0, 1000)
		
		if SERVER then
			self:TakePrimaryAmmo(1)
			self:OrbitalPiano(piano_spawn_pos) -- Incoming...
		else
			return
		end
	else
		self:EmitSound(ShootSoundFail)
		return
	end
end

function SWEP:LaunchPiano()
	local piano = ents.Create("prop_physics")
	if (!IsValid(piano)) then return end
	
	piano:SetModel("models/fishy/furniture/piano.mdl")
	piano:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 40))
	piano:SetAngles(self.Owner:EyeAngles())
	piano:EmitSound("Piano_music")
	piano:Spawn()
	
	local phys = piano:GetPhysicsObject()
	if (!IsValid(phys)) then piano:Remove() return end
	
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 100000
	phys:SetVelocity(velocity)
end

function SWEP:OrbitalPiano(trace_hit_pos)
	local piano = ents.Create("prop_physics")
	if (!IsValid(piano)) then return end
	
	piano:SetModel("models/fishy/furniture/piano.mdl")
	piano:SetPos(trace_hit_pos)
	piano:SetAngles(self.Owner:EyeAngles())
	piano:EmitSound("Piano_music")
	piano:Spawn()
	
	local phys = piano:GetPhysicsObject()
	if (!IsValid(phys)) then piano:Remove() return end
	
	local velocity = Vector(0, 0, -1) -- Straight down
	velocity = velocity * 100000 -- Very fast
	phys:SetVelocity(velocity) -- Make piano go straight down very fast
end


function SWEP:ShouldDropOnDie()
    return true
end