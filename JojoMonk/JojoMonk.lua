
function getNameServer()

	return GetRealmName()

end

function JojoMonkPanel_Close()

	JojoMonk_Config.ActiveSFX = JojoMonkGUIFrame_CBSFXActive:GetChecked();
	
	local dropdownCharacter = JojoMonkGUIFrame_CharacterDropDown
	
	if(dropdownCharacter:GetText() ~= L['no_addon_load']) then
		JojoMonk_Config.ActiveCharacter = dropdownCharacter:GetText();
	else
		setActiveCharacterOnDropDown(JojoMonk_Config.ActiveCharacter)
	end
	
	JojoMonk_Config.ActiveHurtSFX = JojoMonkGUIFrame_CBSFXHurt:GetChecked();
	JojoMonk_Config.ActiveQuoteSFX = JojoMonkGUIFrame_CBQuoteSFX:GetChecked();
	JojoMonk_Config.ActiveDeadEliteSFX = JojoMonkGUIFrame_CBDeadEliteSFX:GetChecked();
	JojoMonk_Config.QuoteFrequencyTime = JojoMonkGUIFrame_SLQuoteSFX:GetValue()
	
end

function JojoMonkPanel_CancelOrLoad()

	JojoMonk_Initialise()
	
	JojoMonkGUIFrame_CBSFXActive:SetChecked(JojoMonk_Config.ActiveSFX);
	JojoMonkGUIFrame_CBSFXHurt:SetChecked(JojoMonk_Config.ActiveHurtSFX);
	JojoMonkGUIFrame_CBQuoteSFX:SetChecked(JojoMonk_Config.ActiveQuoteSFX);
	JojoMonkGUIFrame_CBDeadEliteSFX:SetChecked(JojoMonk_Config.ActiveDeadEliteSFX);
	setActiveCharacterOnDropDown(JojoMonk_Config.ActiveCharacter)
	JojoMonkGUIFrame_SLQuoteSFX:SetValue(JojoMonk_Config.QuoteFrequencyTime);
	
	
end


function JojoMonk_OnLoad(frame)
	realm = getNameServer();
	-- respond to the Player logging in.
    --
	L = {};
	L.locale = GetLocale();
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");
end


function setActiveCharacterOnDropDown(characterName)
	JojoMonkGUIFrame_CharacterDropDown:SetText(characterName)
end

function JojoMonk_Initialise()
	
	if(JojoMonk_Init) then
		return
	end
	 -- initialise data structures
    --
    if (JojoMonk_Config == nil) then
        JojoMonk_Config = { };
		JojoMonk_Config.lang = "English";
		JojoMonk_Config.ActiveSFX = true;
		JojoMonk_Config.ActiveHurtSFX = true;
		JojoMonk_Config.ActiveQuoteSFX = true;
		JojoMonk_Config.ActiveDeadEliteSFX = true;
		JojoMonk_Config.QuoteFrequencyTime = 300;
		JojoMonk_Config.ActiveCharacter = L['Dio_Brando_drop'];
    end
	-- Initialize the content of the dropdown button
	local dropdown = JojoMonkGUIFrame_CharacterDropDown
	
	dropdown:SetText(JojoMonk_Config.ActiveCharacter)
	
	local function MenuGenerator(owner, rootDescription)
		for index, characterName in ipairs(GetLocalCharacterListView()) do
			rootDescription:CreateButton(characterName, function() setActiveCharacterOnDropDown(characterName) end)
		end
	end

	dropdown:SetupMenu(MenuGenerator);
	
	-- Use for debug
	--[[ for k, v in pairs(dropdown) do
		print(k, v)
	end ]]
	
	-- Configure the slider
	if(JojoMonk_Config.QuoteFrequencyTime == nil) then JojoMonk_Config.QuoteFrequencyTime = 300 end
	JojoMonkGUIFrame_SLQuoteSFX:SetWidth(100);
	JojoMonkGUIFrame_SLQuoteSFX:SetHeight(20);
	JojoMonkGUIFrame_SLQuoteSFX:Enable();
	JojoMonkGUIFrame_SLQuoteSFX:SetMinMaxValues(90, 600)
	JojoMonkGUIFrame_SLQuoteSFX:SetValue(JojoMonk_Config.QuoteFrequencyTime)
	JojoMonkGUIFrame_SLQuoteSFX:SetValueStep(1) 
	
		
	print("Jojo's Monk : If you encounter problems with the interface, type /jojom");
	JojoMonk_Init = 1;
end

function JojoMonk_OnEvent(self, event, ...)

	if (event == "PLAYER_ENTERING_WORLD") then
		-- initialise configuration and frames
		JojoMonk_Initialise();
		
		
		
		JojoMonkGUIFrame_CBSFXActive:SetChecked(JojoMonk_Config.ActiveSFX);
		JojoMonkGUIFrame_CBSFXHurt:SetChecked(JojoMonk_Config.ActiveHurtSFX);
		JojoMonkGUIFrame_CBQuoteSFX:SetChecked(JojoMonk_Config.ActiveQuoteSFX);
		JojoMonkGUIFrame_CBDeadEliteSFX:SetChecked(JojoMonk_Config.ActiveDeadEliteSFX);
		local isLoad = isActiveCharacterLoad();
		

		if(isLoad == false) then
			JojoMonk_Config.ActiveCharacter = "";
		end
		setActiveCharacterOnDropDown(JojoMonk_Config.ActiveCharacter)
		
	end
end

function isActiveCharacterLoad() -- Verify if our active character is load this time for correct display on the interface

	for index, filename in ipairs(GetLocalCharacterListView()) do 
			if(JojoMonk_Config.ActiveCharacter == filename) then return true; end
		end
	return false;
end

-- Create a slider template in Lua (equivalent to MySlider_Template in XML)
function UpdateSliderUi(slider)
    -- Create the slider with the "Slider" widget
    
    -- Set the size of the slider
    slider:SetSize(144, 17)
    
    -- Set the orientation (horizontal)
    slider:SetOrientation("HORIZONTAL")

    -- Enable mouse interaction
    slider:EnableMouse(true)

    -- Define the thumb texture
    local thumb = slider:CreateTexture(nil, "ARTWORK")
    thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    thumb:SetSize(32, 32)
    slider:SetThumbTexture(thumb)

    -- Optional: Apply a backdrop (background and border)
    slider:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    })

    -- Set HitRectInsets for interaction area
    slider:SetHitRectInsets(0, 0, -10, -10)

    return slider
end


function JojoMonk_PanelOnload(self)
		
		
		
		-- Set the text for the check box
		JojoMonkGUIFrame_CBSFXActiveText:SetText(L['Active_SFX']);
		JojoMonkGUIFrame_CBSFXActiveText:SetWidth(80); -- Set the width of the text
		
		JojoMonkGUIFrame_CBSFXHurtText:SetText(L['Active_Hurt_SFX']);
		JojoMonkGUIFrame_CBSFXHurtText:SetWidth(150);
		
		JojoMonkGUIFrame_CBQuoteSFXText:SetText(L['Active_Quote_SFX']);
		JojoMonkGUIFrame_CBQuoteSFXText:SetWidth(115);
		
		JojoMonkGUIFrame_CBDeadEliteSFXText:SetText(L['Active_DeadElite_SFX']);
		JojoMonkGUIFrame_CBDeadEliteSFXText:SetWidth(130);
		
		--Set the text for the description slider
		
		JojoMonkGUIFrame_QuoteFrequency:SetText(L['Frequency']);
		JojoMonkGUIFrame_QuoteFrequency:SetFont(JojoMonkGUIFrame_QuoteFrequency:GetFont(),11);
		
		JojoMonkGUIFrame_QuoteFrequencyMin:SetText("|cff1eff00" ..L['Often'] .. "|r");
		JojoMonkGUIFrame_QuoteFrequencyMin:SetFont(JojoMonkGUIFrame_QuoteFrequencyMin:GetFont(),11);
		
		JojoMonkGUIFrame_QuoteFrequencyMax:SetText("|cffff8000" ..L['Rarely'] .. "|r");
		JojoMonkGUIFrame_QuoteFrequencyMax:SetFont(JojoMonkGUIFrame_QuoteFrequencyMax:GetFont(),11);
		
		-- Update the slider ui , need to do it now in lua code instead of xml because since 11.0 the backdrop ui is not availabed in xml
		local slider = JojoMonkGUIFrame_SLQuoteSFX
		slider = UpdateSliderUi(slider)
		
		 -- Register the frame using the new settings system
		 local category = Settings.RegisterCanvasLayoutCategory(self, "Jojo Monk SFX " .. C_AddOns.GetAddOnMetadata("JojoMonk", "Version"))
		 Settings.RegisterAddOnCategory(category)

		 -- Save settings when the panel is hidden (replaces `okay`)
		self:SetScript("OnHide", function(self)
			JojoMonkPanel_Close()
		end)

		--[[ self:SetScript("OnShow", function(self)
			JojoMonkPanel_CancelOrLoad()
		end) ]]
end


SLASH_JOJOMONK1 = "/jojom"; 

function SlashCmdList.JOJOMONK(option)
	
	local command, suboption = strsplit(" ", option)
	
	-- Control SFX chracters
	if command == "dio" then
		print("Jojo's Monk_Dio Brando SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Dio_Brando_drop'];
	elseif command == "jonathan" then
		print("Jojo's Monk_Jonathan Joestar SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Jonathan_Joestar_drop'];
	elseif command == "joseph" then
		print("Jojo's Monk_Joseph Joestar SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Joseph_Joestar_drop'];
	elseif command == "josuke" then
		print("Jojo's Monk__Josuke Higashikata SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Josuke_Higashikata_drop'];
	elseif command == "jotaro" then
		print("Jojo's Monk_Jotaro Kujo SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Jotaro_Kujo_drop'];
	elseif command == "giorno" then
		print("Jojo's Monk_Giorno Giovanna SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Giorno_Giovanna_drop'];
	
	-- Control SFX activation and deactivation
	elseif command == "on" then
		print("Jojo's Monk -> Activate SFX");
		JojoMonk_Config.ActiveSFX = true;
	elseif command == "off" then
		print("Jojo's Monk -> Desactivate SFX");
		JojoMonk_Config.ActiveSFX = false;
	
	 -- Control hurt damage sound effects
    elseif command == "hurtdamage" then
        if suboption == "on" then
			print("Jojo's Monk -> Hurt Damage SFX activated");
			JojoMonk_Config.ActiveHurtSFX = true;
        elseif suboption == "off" then
            print("Jojo's Monk -> Hurt Damage SFX deactivated");
            JojoMonk_Config.ActiveHurtSFX = false;
        end

    -- Control player and elite SFX
    elseif command == "playersandelite" then
        if suboption == "on" then
            print("Jojo's Monk -> Player and Elite SFX activated");
            JojoMonk_Config.ActiveDeadEliteSFX = true;
        elseif suboption == "off" then
            print("Jojo's Monk -> Player and Elite SFX deactivated");
            JojoMonk_Config.ActiveDeadEliteSFX = false;
        end

    -- Control quote SFX
    elseif command == "quotesfx" then
        if suboption == "on" then
            print("Jojo's Monk -> Quote SFX activated");
            JojoMonk_Config.ActiveQuoteSFX = true;
        elseif suboption == "off" then
            print("Jojo's Monk -> Quote SFX deactivated");
            JojoMonk_Config.ActiveQuoteSFX = false;
        end	
	-- Control frequency quote
	elseif command == "frequencyquote" then
		local frequencyValue = tonumber(suboption);
        if frequencyValue and frequencyValue >= 90 and frequencyValue <= 600 then
            print("Jojo's Monk -> Frequency quote set to " .. frequencyValue)
            JojoMonk_Config.QuoteFrequencyTime = frequencyValue
        else
            print("Invalid frequency value. Please provide a value between 0 and 600.")
        end
	else
		print("Jojo's Monk command : ");
		print("Choose character : /jojom <dio - jonathan - joseph - josuke - jotaro - giorno>");
		print("Activate/Desactivate SFX : /jojom <on-off>");
		print("Control Hurt Damage SFX: /jojom hurtdamage <on-off>");
        print("Control Player and Elite SFX: /jojom playersandelite <on-off>");
        print("Control Quote SFX: /jojom quotesfx <on-off>");
		print("Set Frequency for quote (in seconds): /jojom frequencyquote <90-600>")
		
	end

	JojoMonkPanel_CancelOrLoad()
end


	