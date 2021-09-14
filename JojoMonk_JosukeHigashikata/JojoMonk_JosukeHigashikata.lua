    local Channeled = {
        --[117952] = {'Crackling Jade Lightning',1,0,}, -- No Sound 
		[101546] = {'Spinning Crane Kick',4,0,},
		[191837] = {'Cast heal',5,0,}, -- [[ Essence Font ]]
		[115175] = {'Cast heal',5,0,}, -- [[ Soothing Mist ]]
		[113656] = {'Fists of Fury',2,0,},
    }
	
	local Cast = {
		[116670] = {'Vivify',1,0,},
		[124682] = {'Cast heal',4,0}, -- [[ Enveloping Mist ]]
		[115178] = {'Resuscitate',1,0,},
		[212051] = {'Resuscitate',1,0,}, -- [[ Reawaken ]]
	
	
	}
     
     local Instants = {
        [100784] = {'Blackout Kick',6,0,}, 
        [107428] = {'Rising Sun Kick',8,0,},
		[152175] = {'Rising Sun Kick',8,0,}, --[[ Hurricane Strike]]
        [100780] = {'Tiger Palm',8,0,},
        --[115176] = {'Zen Meditation',1,0,}, -- No Sound
        [115078] = {'Paralysis',3,0,},
        --[115203] = {'Fortifying Brew',1,0,}, -- No Sound 
        [119381] = {'Leg Sweep',1,0,},
        --[116095] = {'Disable',1,0,}, -- No Sound
		[123986] = {'Chi Burst',1,0,},
		[122280] = {'Instant heal',8,0,}, -- [[ Healing Elixirs ]]
		--[122278] = {'Dampen Harm',1,0,}, -- No Sound
		[115546] = {'Provoke',9,0,},
		[115313] = {'Provoke',9,0,}, -- [[ Summon Jade Serpent Statue ]]
		[115008] = {'Movement',2,0,}, -- [[ Chi Torpedo ]]
		[109132] = {'Movement',2,0,}, -- [[ Roll ]]
		[116841] = {'Movement',2,0,}, -- [[ Tigers Lust ]]
		[101545] = {'Flying Serpent Kick',5,0,}, 
		--[116844] = {'Ring of Peace',1,0,}, -- No Sound
		[119996] = {'TranscendenceTransfer',1,0,},
		[101643] = {'Transcendence',1,0,},
		[115151] = {'Instant heal',8,0,}, -- [[ Renewing Mist ]]
		[116849] = {'Life Cocoon',1,0,},
		[152173] = {'Serenity',2,0,},
		[137639] = {'Serenity',2,0,}, -- [[ Storm, Earth, and Fire]]
		--[115310] = {'Revival',1,0,}, -- No Sound 
		[116680] = {'Instant heal',8,0,}, -- [[ Thunder Focus Tea ]]
		--[197908] = {'Mana Tea',1,0,}, -- No Sound
		
		[196725] = {'Spinning Crane Kick',4,0,}, -- [[ Refreshing Jade Wind ]]
		[122470] = {'Touch of Karma',4,0,},
		
		
		
    }
	 
    
   local SoundPath = [[Interface\AddOns\JojoMonk_JosukeHigashikata\sounds\]];
   local SoundPath_Hurt = [[Interface\AddOns\JojoMonk_JosukeHigashikata\sounds\hurt\]];
   local SoundPath_Quote = [[Interface\AddOns\JojoMonk_JosukeHigashikata\sounds\quote\]]
   local SoundPath_QuotePlayer = [[Interface\AddOns\JojoMonk_JosukeHigashikata\sounds\quote_Player\]]
   local SoundPath_deadElite = [[Interface\AddOns\JojoMonk_JosukeHigashikata\sounds\dead_Elite\]]
   
   local nb_hurt_sfx = 9;
   local nb_dead_sfx = 9;
   local nb_quotes = 12;
   local nb_quotes_player = 7;
   local nb_deadElite_sfx = 9;
   
   
   local last_quote = 0;
   local last_deadRare = 0;
   local last_quotePlayer = 0;
   local hurt_time = 0;
   local noAction_time = GetTime();
   local lastTargetInfos = {};
   local character_except = L['Josuke_Higashikata_drop']
   
	
   
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
					print("|cff1eff00" .. "Josuke Higashikata : " .."|r", L['Josuke_Higashikata_QuotePlayer_'.. random_quotePlayer])
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
			print("|cff1eff00" .. "Josuke Higashikata : " .."|r", L['Josuke_Higashikata_Quote_'.. random_quote])
			noAction_time = GetTime()
		end
	
	
	end)

     
    
	
	
	
	local frame = CreateFrame("FRAME");
	frame:RegisterEvent("ADDON_LOADED"); 
	frame:RegisterEvent("PLAYER_LOGOUT");

	function frame:OnEvent(event, arg1)
		if event == "ADDON_LOADED" and arg1 == "JojoMonk_JosukeHigashikata" then
			--[[if jojo_sound == nil then
				print("Thanks for using Jojo's Monk_Josuke Higashikata addon ! Initialisation...");
				print("The addon is ready, enjoy !");
				jojo_sound = 1; ]]
			if JojoMonk_Config.ActiveCharacter == L['Josuke_Higashikata_drop'] then 
				print("Jojo's Monk_Josuke Higashikata SFX is select.");
			end
		end
	end
	frame:SetScript("OnEvent", frame.OnEvent);
	
	
	
	
	
	
	
	