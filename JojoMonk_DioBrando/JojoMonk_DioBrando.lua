   local Channeled = {
        [113656] = {'Fists of Fury',8,0,},
        --[117952] = {'Crackling Jade Lightning',1,0,}, -- No sound
		[101546] = {'Spinning Crane Kick',2,0,},
		
    }
	
	local Cast = {
		[116670] = {'Vivify',2,0,},
	
	
	
	}
     
     local Instants = {
        [100784] = {'Blackout Kick',8,0,},
		--[115008] = {'Chi Torpedo',1,0,}, -- No sound
		[123986] = {'Chi Burst',1,0,},
		[115098] = {'Chi Burst',1,0,}, --[[ Chi Wave]]
		[122278] = {'Dampen Harm',3,0,},
		[122783] = {'Dampen Harm',3,0,}, --[[ Diffuse Magic]]
		[116095] = {'Disable',1,0,},
        --[115072] = {'Expel Harm',1,0,}, -- No sound
        [101545] = {'Flying Serpent Kick',8,0,},
		[116841] = {'Flying Serpent Kick',8,0,}, -- [[Tiger Lust]]
		--[115203] = {'Fortifying Brew',1,0,}, -- No sound
        [152175] = {'Hurricane Strike',2,0,},
		[119381] = {'Leg Sweep',2,0,},
		[115078] = {'Paralysis',3,0,},
		[115546] = {'Provoke',14,0,},
		[115315] = {'Provoke',14,0,}, --[[Summon Black Ox Statue]]
		--[115178] = {'Resuscitate',1,0,}, -- No sound
        [107428] = {'Rising Sun Kick',2,0,},
		[261947] = {'Rising Sun Kick',2,0,}, --[[Fist of the White Tiger]]
		[152173] = {'Serenity',2,0,},
		[137639] = {'Serenity',2,0,}, -- [[ Storm, Earth, and Fire]]
        [116705] = {'Spear Hand Strike',2,0,},
        [100780] = {'Tiger Palm',3,0,},
		[115080] = {'Touch of Death',2,0,},
        [122470] = {'Touch of Karma',4,0,},
		[119996] = {'TranscendenceTransfer',1,0,},
		[101643] = {'Transcendence',1,0,},
        --[115176] = {'Zen Meditation',1,0,}, -- No sound
        
        --[137648] = {'Nimble Brew',1,0,}, -- No sound
        --[123407] = {'Spinning Fire Blossom',1,0,}, -- No sound
		--[122280] = {'Healing Elixirs',1,0,}, -- No sound
		--[116844] = {'Ring of Peace',1,0,}, -- No sound
		
		
    }
	
	
   local SoundPath = [[Interface\AddOns\JojoMonk_DioBrando\sounds\]];
   local SoundPath_Hurt = [[Interface\AddOns\JojoMonk_DioBrando\sounds\hurt\]];
   local SoundPath_Quote = [[Interface\AddOns\JojoMonk_DioBrando\sounds\quote\]]
   local SoundPath_QuotePlayer = [[Interface\AddOns\JojoMonk_DioBrando\sounds\quote_Player\]]
   local SoundPath_deadElite = [[Interface\AddOns\JojoMonk_DioBrando\sounds\dead_Elite\]]
   
   local nb_hurt_sfx = 6;
   local nb_dead_sfx = 4;
   local nb_quotes = 17;
   local nb_quotes_player = 7;
   local nb_deadElite_sfx = 15;
   
   local last_quote = 0;
   local last_quotePlayer = 0;
   local last_deadRare = 0;
   local hurt_time = 0;
   local noAction_time = GetTime();
   local lastTargetInfos = {};
   local character_except = L['Dio_Brando_drop']
	
    local f = CreateFrame('frame');
	f:RegisterEvent('PLAYER_ENTER_COMBAT');
	f:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player');
    f:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player');
	f:RegisterUnitEvent('UNIT_SPELLCAST_START','player');
	f:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED','player');
    f:RegisterEvent('PLAYER_DEAD');
	f:RegisterEvent('BOSS_KILL');
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");		
	f:RegisterEvent('UNIT_COMBAT','player');
	f:RegisterEvent('PLAYER_TARGET_CHANGED');
    f:SetScript('OnEvent', function(self, event, unit, _, spellID)
		
		if (JojoMonk_Config.ActiveSFX ~= true or JojoMonk_Config.ActiveCharacter ~= character_except) then
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
			willPlay,soundHandle = PlaySoundFile(SoundPath .. 'DeadSound_' .. math.random(1,nb_dead_sfx) .. '.ogg', 'SFX');
		elseif event == 'UNIT_SPELLCAST_INTERRUPTED' then
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
		elseif event == 'PLAYER_TARGET_CHANGED' then
			
			guidTarget = UnitGUID("target");
			classification = UnitClassification("target");
			if (UnitIsPlayer("target")) then classification = "player"; end
			
			if(guidTarget ~= nil) then
				lastTargetInfos = { [guidTarget] = {classification,GetTime(),}, }

			end
			
		end
	 
	 end -- f:OnPlayerSpellEvent
    
	
	function f:OnCombatEvent(event,...)
			
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand
		local base, stat, posBuff, negBuff = UnitStat("player",3); -- Get stamina amount
		--print(timestamp, subevent, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags);
		if(sourceGUID == playerGUID) then
			noAction_time = GetTime();
		end
		
		if(JojoMonk_Config.ActiveHurtSFX == true) then
		
		
			if subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" then
				amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
		
				if destGUID == playerGUID then 
					if(hurt_time == 0 or GetTime() > hurt_time + 2) then -- 2 s delay for start the hurt sfx
						willPlay,soundHandle = PlaySoundFile(SoundPath_Hurt .. 'hurt_' .. math.random(1,nb_hurt_sfx) .. '.ogg', 'SFX');
						hurt_time = GetTime();
					end
				end
			end
		
		end
		
		if(JojoMonk_Config.ActiveDeadEliteSFX == true) then
		
			if subevent == "UNIT_DIED" and lastTargetInfos[destGUID] then
				
				if(lastTargetInfos[destGUID][1] == "player") then
					repeat
						random_quotePlayer = math.random(1,nb_quotes_player);
					until random_quotePlayer ~= last_quotePlayer;
					if(soundHandle ~= nil) then
					StopSound(soundHandle);
					end
					willPlay,soundHandle = PlaySoundFile(SoundPath_QuotePlayer .. 'quotePlayer_' .. random_quotePlayer .. '.ogg', 'SFX');
					print("|cff1eff00" .. "Dio Brando : " .."|r", L['Dio_Brando_QuotePlayer_'.. random_quotePlayer])
				elseif(lastTargetInfos[destGUID][1] ~= "normal" and lastTargetInfos[destGUID][1] ~= "minus" and lastTargetInfos[destGUID][1] ~= "trivial" ) then
					repeat
						random_deadRare = math.random(1,nb_deadElite_sfx);
					until random_deadRare ~= last_deadRare;
					last_deadRare = random_deadRare;
					if(soundHandle ~= nil) then
					StopSound(soundHandle);
					end
					willPlay,soundHandle = PlaySoundFile(SoundPath_deadElite .. 'deadElite_' .. random_deadRare .. '.ogg', 'SFX');
					
				end
				
			end
		end

	
	end -- f:OnCombatEvent
	
	f:SetScript('OnUpdate', function()
	
		if(JojoMonk_Config.ActiveQuoteSFX ~= true or JojoMonk_Config.ActiveCharacter ~= character_except) then
			return false;
		end
		
		if(GetTime() > noAction_time + JojoMonk_Config.QuoteFrequencyTime ) then
			repeat
				random_quote = math.random(1,nb_quotes);
			until random_quote ~= last_quote
			last_quote = random_quote;
			if(soundHandle ~= nil) then
				StopSound(soundHandle);
			end
			willPlay,soundHandle = PlaySoundFile(SoundPath_Quote .. 'quote_' .. random_quote .. '.ogg', 'SFX');
			print("|cff1eff00" .. "Dio Brando : " .."|r", L['Dio_Brando_Quote_'.. random_quote])
			noAction_time = GetTime()
		end
	
	
	end)
	
	local frame = CreateFrame("FRAME");
	frame:RegisterEvent("ADDON_LOADED"); 
	frame:RegisterEvent("PLAYER_LOGOUT");

	function frame:OnEvent(event, arg1)
		if event == "ADDON_LOADED" and arg1 == "JojoMonk_DioBrando" then
			--[[if jojo_sound == nil then
				print("Thanks for using Jojo's Monk_Dio Brando addon ! Initialisation...");
				print("The addon is ready, enjoy !");
				jojo_sound = 1; ]]
			if JojoMonk_Config.ActiveCharacter == L['Dio_Brando_drop'] then 
				print("Jojo's Monk_Dio Brando SFX is select.");
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
	
	
	function printTable(table)
	local temp = "";
		for k, v in pairs(table) do
			print(k);
			for index,value in pairs(v) do
			
				print(index,value);
			end
			
			
		end
	end
	
	function printTable2(table)
	local temp = "";
		for k, v in pairs(table) do
			print(k,v);
			
			
		end
	end
	
	