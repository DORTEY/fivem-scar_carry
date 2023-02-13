--//-----------------------------------------\\
--|| [SCAR] Carry
--|| meuntouchable#5555 (655378313514057759)
--|| Main systems from "rubbertoe98"
--|| https://scar-studios.tebex.io
--\\-----------------------------------------//

ScarCarry={};

ScarCarry.Notify=function(type,xPlayer,message)  --// SCAR Notify   https://github.com/meuntouchable/fivem-scar_notify
	if(type=="client")then --client side
		--ESX.ShowNotification(message);   ESX example
		--exports["scar_notify"]:ScarNotify(message,"info",true,5000);    SCAR Notify
		Notify(message);
	end
end

ScarCarry.Settings={
	Distance = 3,--max distance between u and a other player
	Cooldown = 5,--5 seconds
	
	Messages={
		NoPersonInRange = "No one is in your Range to carry!",
		Cooldown = "You've to wait %s before carry again!",
	},
	
	Animations={
		Carrying={
			Anim = "missfinale_c2mcs_1",
			Anim2 = "fin_c2_mcs_1_camman",
			AnimFlag = 49,
		},
		Carried={
			Anim = "nm",
			Anim2 = "firemans_carry",
			AnimFlag = 33,
			
			Attach={0.27, 0.15, 0.63}
		},
	}
}