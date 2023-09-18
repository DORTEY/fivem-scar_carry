--//-----------------------------------------\\
--|| [SCAR] Carry
--|| meuntouchable#5555 (655378313514057759)
--|| Main systems from "rubbertoe98"
--|| https://scar-studios.tebex.io
--\\-----------------------------------------//

local ScarCarryProgress=false;
local ScarTargetPED=-1;
local ScarCarryType="";
local ScarCarryCooldown=false;

local function GetClosestPlayer(radius)
	local players=GetActivePlayers();
	local closestDistance=-1;
	local closestPlayer=-1;
	local PlayerPED=PlayerPedId();
	local playerCoords=GetEntityCoords(PlayerPED);
	
	for _,v in ipairs(players)do
		local TargetPED=GetPlayerPed(v);
		
		if(TargetPED~=PlayerPED)then
			local targetCoords=GetEntityCoords(TargetPED);
			local distance=#(targetCoords-playerCoords);
			
			if(closestDistance==-1 or closestDistance>distance)then
				closestPlayer=v;
				closestDistance=distance;
			end
		end
	end
	if(closestDistance~=-1 and closestDistance<=radius)then
		return closestPlayer;
	else
		return nil;
	end
end

local function ensureAnimDict(anim)
    if(not HasAnimDictLoaded(anim))then
        RequestAnimDict(anim);
        while(not HasAnimDictLoaded(anim))do
            Wait(0);
        end        
    end
    return anim;
end


RegisterNetEvent("ScarCarry->Sync->C")
AddEventHandler("ScarCarry->Sync->C",function(targetSrc)
	local TargetPED=GetPlayerPed(GetPlayerFromServerId(targetSrc));
	
	ScarCarryProgress=true;
	ensureAnimDict(ScarCarry.Settings.Animations.Carried.Anim);
	AttachEntityToEntity(PlayerPedId(),TargetPED,0,ScarCarry.Settings.Animations.Carried.Attach[1],ScarCarry.Settings.Animations.Carried.Attach[2],ScarCarry.Settings.Animations.Carried.Attach[3],0.5,0.5,180,false,false,false,false,2,false);
	ScarCarryType="beingcarried";
end)

RegisterNetEvent("ScarCarry->Stop")
AddEventHandler("ScarCarry->Stop",function()
	ScarCarryProgress=false;
	ClearPedSecondaryTask(PlayerPedId());
	DetachEntity(PlayerPedId(),true,false);
end)

Citizen.CreateThread(function()
	while true do
		if(ScarCarryProgress)then
			if(ScarCarryType=="beingcarried")then
				if(not IsEntityPlayingAnim(PlayerPedId(),ScarCarry.Settings.Animations.Carried.Anim,ScarCarry.Settings.Animations.Carried.Anim2,3))then
					TaskPlayAnim(PlayerPedId(),ScarCarry.Settings.Animations.Carried.Anim,ScarCarry.Settings.Animations.Carried.Anim2,8.0,-8.0,100000,ScarCarry.Settings.Animations.Carried.AnimFlag,0,false,false,false);
				end
			elseif(ScarCarryType=="carrying")then
				if(not IsEntityPlayingAnim(PlayerPedId(),ScarCarry.Settings.Animations.Carrying.Anim,ScarCarry.Settings.Animations.Carrying.Anim2,3))then
					TaskPlayAnim(PlayerPedId(),ScarCarry.Settings.Animations.Carrying.Anim,ScarCarry.Settings.Animations.Carrying.Anim2,8.0,-8.0,100000,ScarCarry.Settings.Animations.Carrying.AnimFlag,0,false,false,false);
				end
			end
		end
		Wait(0);
	end
end)


RegisterCommand("carry",function(source,args)
	if(not(IsEntityDead(PlayerPedId())))then
		if(not ScarCarryProgress)then
			local closestPlayer=GetClosestPlayer(ScarCarry.Settings.Distance);
			if(closestPlayer)then
				if(not(ScarCarryCooldown))then
					local TargetPED=GetPlayerServerId(closestPlayer);
					if(TargetPED~=-1)then
						ScarCarryProgress=true;
						ScarTargetPED=TargetPED;
						TriggerServerEvent("ScarCarry->Sync->S",TargetPED);
						ensureAnimDict(ScarCarry.Settings.Animations.Carrying.Anim);
						ScarCarryType="carrying";
						
						StartCarryCooldown();
					else
						ScarCarry.Notify("client",_,ScarCarry.Settings.Messages.NoPersonInRange);
					end
				else
					ScarCarry.Notify("client",_,(ScarCarry.Settings.Messages.Cooldown:format(coolDownTimeRemaining)));
				end
			else
				ScarCarry.Notify("client",_,ScarCarry.Settings.Messages.NoPersonInRange);
			end
		else
			ScarCarryProgress=false;
			ClearPedSecondaryTask(PlayerPedId());
			DetachEntity(PlayerPedId(),true,false);
			TriggerServerEvent("ScarCarry->Stop->S",ScarTargetPED);
			ScarTargetPED=0;
		end
	end
end,false)





function StartCarryCooldown()
	ScarCarryCooldown=true;
	coolDownTimeRemaining=ScarCarry.Settings.Cooldown;
	
	CreateThread(function()
		while(coolDownTimeRemaining~=0)do
			Wait(1*1000);
			coolDownTimeRemaining=coolDownTimeRemaining-1;
		end
	end)
	
	Wait(ScarCarry.Settings.Cooldown*1000);
	ScarCarryCooldown=false;
end


function Notify(text)
    BeginTextCommandThefeedPost("STRING");
    AddTextComponentSubstringPlayerName(text);
    EndTextCommandThefeedPostTicker(false,false);
end