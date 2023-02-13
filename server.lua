--//-----------------------------------------\\
--|| [SCAR] Carry
--|| meuntouchable#5555 (655378313514057759)
--|| https://scar-studios.tebex.io
--\\-----------------------------------------//

local ScarCarrying={};
local ScarCarried={};

RegisterServerEvent("ScarCarry->Sync->S")
AddEventHandler("ScarCarry->Sync->S", function(targetSrc)
	local source=source;
	local PlayerPED=GetPlayerPed(source);
	local sourceCoords=GetEntityCoords(PlayerPED);
	local TargetPED=GetPlayerPed(targetSrc);
	local targetCoords=GetEntityCoords(TargetPED);
	
	if(#(sourceCoords-targetCoords)<=ScarCarry.Settings.Distance)then 
		TriggerClientEvent("ScarCarry->Sync->C",targetSrc,source);
		ScarCarrying[source]=targetSrc;
		ScarCarried[targetSrc]=source;
	end
end)

RegisterServerEvent("ScarCarry->Stop->S")
AddEventHandler("ScarCarry->Stop->S", function(targetSrc)
	local source=source;

	if(ScarCarrying[source])then
		TriggerClientEvent("ScarCarry->Stop",targetSrc)
		ScarCarrying[source]=nil;
		ScarCarried[targetSrc]=nil;
	elseif(ScarCarried[source])then
		TriggerClientEvent("ScarCarry->Stop",ScarCarried[source])
		ScarCarrying[ScarCarried[source]]=nil;
		ScarCarried[source]=nil;
	end
end)

AddEventHandler("playerDropped",function(reason)
	local source=source;
	
	if(ScarCarrying[source])then
		TriggerClientEvent("ScarCarry->Stop",ScarCarrying[source]);
		ScarCarried[ScarCarrying[source]]=nil;
		ScarCarrying[source]=nil;
	end

	if(ScarCarried[source])then
		TriggerClientEvent("ScarCarry->Stop",ScarCarried[source]);
		ScarCarrying[ScarCarried[source]]=nil;
		ScarCarried[source]=nil;
	end
end)
