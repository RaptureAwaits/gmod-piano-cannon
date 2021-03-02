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
    SWEP.PrintName          = "Piano launcher"
    SWEP.Slot               = 6
    SWEP.SlotPos            = 3
    SWEP.DrawCrosshair = false
     
    SWEP.EquipMenuData = {
      type = "Bard's Dream",
      desc = "Launch a fucking piano at your plebian foes to teach them some fucking class."
   }
    
   SWEP.Icon = "materials/piano_launcher/icon_piano.png"
end
 
SWEP.Base                      = "weapon_tttbase"
SWEP.Spawnable                 = false
SWEP.AdminSpawnable            = true
SWEP.AdminOnly			= true
SWEP.ViewModel                 = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel             = "models/weapons/w_pist_usp.mdl"
 
SWEP.NoSights = true
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

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
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2)
	
	if SERVER then
		self:TakePrimaryAmmo(1)
		self:LaunchPiano()
	else
		return
	end

end

function SWEP:LaunchPiano()
	local piano = ents.Create( "prop_physics" )
	if ( !IsValid( piano ) ) then return end
	
	piano:SetModel("models/fishy/furniture/piano.mdl")
	piano:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 40 ) )
	piano:SetAngles( self.Owner:EyeAngles() )
	piano:EmitSound("Piano_music")
	piano:Spawn()
	
	local phys = piano:GetPhysicsObject()
	if ( !IsValid( phys ) ) then piano:Remove() return end
	
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 100000
	phys:SetVelocity( velocity )
end


function SWEP:ShouldDropOnDie()
    return true
end