   local Channeled = {
        [113656] = {'Fists of Fury',3,0,},
        --[117952] = {'Crackling Jade Lightning',1,0,}, -- No sound
		[101546] = {'Spinning Crane Kick',2,0,},
		
    }
	
	local Cast = {
		--[116670] = {'Vivify',2,0,},
	
	
	
	}
     
     local Instants = {
        [100784] = {'Blackout Kick',14,0,}, 
        --[115072] = {'Expel Harm',1,0,}, -- No sound
        [101545] = {'Flying Serpent Kick',1,0,},
		--[116841] = {'Flying Serpent Kick',5,0,}, -- [[Tiger Lust]]
        --[115178] = {'Resuscitate',1,0,}, -- No sound
        [107428] = {'Rising Sun Kick',5,0,},
		[261947] = {'Rising Sun Kick',5,0,}, --[[Fist of the White Tiger]]
        [116705] = {'Spear Hand Strike',2,0,},
        [100780] = {'Tiger Palm',8,0,},
        [122470] = {'Touch of Karma',3,0,},
        --[115176] = {'Zen Meditation',1,0,}, -- No sound
        [115078] = {'Paralysis',4,0,},
        --[115203] = {'Fortifying Brew',1,0,}, -- No sound
        [115080] = {'Touch of Death',2,0,},
        --[119381] = {'Leg Sweep',1,0,}, -- No sound
        [116095] = {'Disable',2,0,},
        --[137648] = {'Nimble Brew',1,0,}, -- No sound
        --[123407] = {'Spinning Fire Blossom',1,0,}, -- No sound
		[152175] = {'Hurricane Strike',1,0,},
		[123986] = {'Chi Burst',1,0,},
		[115098] = {'Chi Burst',1,0,}, --[[ Chi Wave]]
		--[122280] = {'Healing Elixirs',1,0,}, -- No sound
		[122278] = {'Dampen Harm',1,0,},
		[122783] = {'Diffuse Magic',1,0,}, --[[ Diffuse Magic]]
		[115546] = {'Provoke',9,0,},
		[115315] = {'Provoke',9,0,}, --[[Summon Black Ox Statue]]
		--[115008] = {'Chi Torpedo',1,0,}, -- No sound
		--[116844] = {'Ring of Peace',1,0,}, -- No sound
		[152173] = {'Serenity',2,0,},
		[137639] = {'Serenity',2,0,}, -- [[ Storm, Earth, and Fire]]
		[119996] = {'Transcendance Transfert',1,0,},
		[101643] = {'Transcendence',1,0,},
    }
	
	
   local SoundPath = [[Interface\AddOns\JojoMonk_GiornoGiovanna\sounds\]];
   local SoundPath_Hurt = [[Interface\AddOns\JojoMonk_GiornoGiovanna\sounds\hurt\]];
   
   
   local nb_hurt_sfx = 9;
   local hurt_time = 0;
   local nb_death_sfx = 5;

    local f = CreateFrame('frame');
	f:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player');
    f:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player');
	f:RegisterUnitEvent('UNIT_SPELLCAST_START','player');
	f:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED','player');
    f:RegisterEvent('PLAYER_DEAD');
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");		
	f:RegisterEvent('UNIT_COMBAT','player');
    f:SetScript('OnEvent', function(self, event, unit, _, spellID)
		
		if (JojoMonk_Config.ActiveSFX ~= true or JojoMonk_Config.ActiveCharacter ~= L['Giorno_Giovanna_drop']) then
			return false;
		end
		playerGUID = UnitGUID("player");
		self:OnPlayerSpellEvent(event,unit,_,spellID)
		self:OnCombatEvent(event,CombatLogGetCurrentEventInfo())	
		
	end)
	

     function f:OnPlayerSpellEvent(event, unit, _, spellID)
	
		if event == 'UNIT_SPELLCAST_CHANNEL_START' and Channeled[spellID] then
			if Channeled[spellID][2] ~= 1 then
				repeat
					rand_spell = math.random(1,Channeled[spellID][2]);
				until rand_spell ~= Channeled[spellID][3];
				Channeled[spellID][3] = rand_spell;
			else
				rand_spell = 1;
			end
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
			willPlay,soundHandle = PlaySoundFile(SoundPath .. Channeled[spellID][1] .. '_' .. rand_spell .. '.ogg', 'SFX');
		elseif event == 'UNIT_SPELLCAST_SUCCEEDED' and Instants[spellID] then
			if Instants[spellID][2] ~= 1 then
				repeat
					rand_spell = math.random(1,Instants[spellID][2]);
				until rand_spell ~= Instants[spellID][3];
				Instants[spellID][3] = rand_spell;
			else
				rand_spell = 1;
			end
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
			willPlay,soundHandle = PlaySoundFile(SoundPath .. Instants[spellID][1] .. '_' .. rand_spell .. '.ogg', 'SFX');
		elseif event == 'UNIT_SPELLCAST_START' and Cast[spellID] then
			if Cast[spellID][2] ~= 1 then
				repeat
					rand_spell = math.random(1,Cast[spellID][2]);
				until rand_spell ~= Cast[spellID][3];
				Cast[spellID][3] = rand_spell;
			else
				rand_spell = 1;
			end
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
			willPlay,soundHandle = PlaySoundFile(SoundPath .. Cast[spellID][1] .. '_' .. rand_spell .. '.ogg', 'SFX');
		elseif event == 'PLAYER_DEAD' then
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
			willPlay,soundHandle = PlaySoundFile(SoundPath .. 'DeadSound_' .. math.random(1,nb_death_sfx) .. '.ogg', 'SFX');
		elseif event == 'UNIT_SPELLCAST_INTERRUPTED' then
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
		end
	 
	 end -- f:OnPlayerSpellEvent
    
	
	function f:OnCombatEvent(event,...)
		
		if(JojoMonk_Config.ActiveHurtSFX ~= true) then
			return false;
		
		end
	
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand
		local base, stat, posBuff, negBuff = UnitStat("player",3); -- Get stamina amount
		
		if subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
		
			if destGUID == playerGUID then 
				if(hurt_time == 0 or GetTime() > hurt_time + 2) then -- 2 s delay for start the hurt sfx
					willPlay,soundHandle = PlaySoundFile(SoundPath_Hurt .. 'hurt_' .. math.random(1,nb_hurt_sfx) .. '.ogg', 'SFX');
					hurt_time = GetTime();
				end
			end
		end
	
	end -- f:OnCombatEvent
	

	
	
	
	local frame = CreateFrame("FRAME");
	frame:RegisterEvent("ADDON_LOADED"); 
	frame:RegisterEvent("PLAYER_LOGOUT");

	function frame:OnEvent(event, arg1)
		if event == "ADDON_LOADED" and arg1 == "JojoMonk_GiornoGiovanna" then
			--[[if jojo_sound == nil then
				print("Thanks for using Jojo's Monk_Dio Brando addon ! Initialisation...");
				print("The addon is ready, enjoy !");
				jojo_sound = 1; ]]
			if JojoMonk_Config.ActiveCharacter == L['Giorno_Giovanna_drop'] then 
				print("Jojo's Monk_Giorno Giovanna SFX is select.");
			end
		end
	end
	frame:SetScript("OnEvent", frame.OnEvent);
	
	--[[SLASH_JOJOSFX1 = "/jojosfx";

	function SlashCmdList.JOJOSFX(option)
		if option == "on" then
			print("Jojo's Monk_Dio Brando SFX -> activate");
			jojo_sound = 1;
		elseif option == "off" then
			print("Jojo's Monk_Dio Brando SFX -> desactivate");
			jojo_sound = 0;
		else
			print("Jojo's Monk_Dio Brando SFX command : /jojosfx <on-off>");
		end
	end
	
	]]
	
	function getPourcentageDamage(amount_dmg,stamina_player)
		return (amount_dmg / stamina_player) * 100
	end
	
	
	
	
	
	
	