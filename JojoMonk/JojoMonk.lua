
function getNameServer()

	return GetRealmName()

end

function JojoMonkPanel_Close()

	JojoMonk_Config.ActiveSFX = JojoMonkGUIFrame_CBSFXActive:GetChecked();
	if(LibDD:UIDropDownMenu_GetText(JojoMonk_CharacterDropDown) ~= L['no_addon_load']) then
		JojoMonk_Config.ActiveCharacter = LibDD:UIDropDownMenu_GetText(JojoMonk_CharacterDropDown);
	else
		LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, JojoMonk_Config.ActiveCharacter);
	end
	JojoMonk_Config.ActiveHurtSFX = JojoMonkGUIFrame_CBSFXHurt:GetChecked();
	JojoMonk_Config.ActiveQuoteSFX = JojoMonkGUIFrame_CBQuoteSFX:GetChecked();
	JojoMonk_Config.ActiveDeadEliteSFX = JojoMonkGUIFrame_CBDeadEliteSFX:GetChecked();
	
	JojoMonk_Config.QuoteFrequencyTime = JojoMonkGUIFrame_SLQuoteSFX:GetValue()
	
end

function  JojoMonkPanel_CancelOrLoad()


	JojoMonkGUIFrame_CBSFXActive:SetChecked(JojoMonk_Config.ActiveSFX);
	JojoMonkGUIFrame_CBSFXHurt:SetChecked(JojoMonk_Config.ActiveHurtSFX);
	JojoMonkGUIFrame_CBQuoteSFX:SetChecked(JojoMonk_Config.ActiveQuoteSFX);
	JojoMonkGUIFrame_CBDeadEliteSFX:SetChecked(JojoMonk_Config.ActiveDeadEliteSFX);
	LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, JojoMonk_Config.ActiveCharacter);
	JojoMonkGUIFrame_SLQuoteSFX:SetValue(JojoMonk_Config.QuoteFrequencyTime);
	
end

function setActiveCharacterOnDropDown()

LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, JojoMonk_Config.ActiveCharacter);
end

function setActiveSFXOnDropDown()
JojoMonkGUIFrame_CBSFXActive:SetChecked(JojoMonk_Config.ActiveSFX);
end

function JojoMonk_OnLoad(frame)
	realm = getNameServer();
	-- respond to the Player logging in.
    --
	L = {};
	LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
	L.locale = GetLocale();
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");
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

        


	local frame = LibDD:Create_UIDropDownMenu(JojoMonk_CharacterDropDown) -->

	--Create and initialise the drop down frame for character choose
	--CreateFrame("Frame", frame);
	LibDD:UIDropDownMenu_Initialize(JojoMonk_CharacterDropDown, JojoMonk_CharacterDropDown_Init);
	LibDD:UIDropDownMenu_JustifyText(JojoMonk_CharacterDropDown, "LEFT");
	LibDD:UIDropDownMenu_SetWidth(JojoMonk_CharacterDropDown, 150);
	LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, JojoMonk_Config.ActiveCharacter);

	JojoMonk_CharacterDropDown:Show();
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



function JojoMonk_CharacterDropDown_Init(self)
	-- Gets the current text in the DropDown frame
	--

	local ddtext = LibDD:UIDropDownMenu_GetText(JojoMonk_CharacterDropDown);
	local info = LibDD:UIDropDownMenu_CreateInfo();
	for index, filename in ipairs(GetLocalCharacterListView()) do
		info.text = filename;
		-- Give it a tick instead of a radio button, and only tick when selected
		--
		info.isNotRadio = true;
		info.checked = (filename == ddtext);

		-- Function to be called when the menu option is selected
		--
		info.func = function (self)
			-- Sets the text of the DropDown frame
			--
			LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, self:GetText());
		end

		LibDD:UIDropDownMenu_AddButton(info);
	end
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
		LibDD:UIDropDownMenu_SetText(JojoMonk_CharacterDropDown, JojoMonk_Config.ActiveCharacter);
		
	end
end

function isActiveCharacterLoad() -- Verify if our active character is load this time for correct display on the interface

	for index, filename in ipairs(GetLocalCharacterListView()) do 
			if(JojoMonk_Config.ActiveCharacter == filename) then return true; end
		end
	return false;
end

function JojoMonk_PanelOnload(panel)
		
		
		
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
		
		
		-- Set the name for the Category for the Panel
        --
        panel.name = "Jojo Monk SFX " .. GetAddOnMetadata("JojoMonk", "Version");
        -- When the player clicks okay, run this function.
        --
        panel.okay = function (self) JojoMonkPanel_Close(); end;

        -- When the player clicks cancel, run this function.
        --
        panel.cancel = function (self)  JojoMonkPanel_CancelOrLoad();  end;

        -- Add the panel to the Interface Options
        --
        InterfaceOptions_AddCategory(panel);

end


SLASH_JOJOMONK1 = "/jojom"; 

function SlashCmdList.JOJOMONK(option)
	if option == "dio" then
		print("Jojo's Monk_Dio Brando SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Dio_Brando_drop'];
	elseif option == "jonathan" then
		print("Jojo's Monk_Jonathan Joestar SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Jonathan_Joestar_drop'];
	elseif option == "joseph" then
		print("Jojo's Monk_Joseph Joestar SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Joseph_Joestar_drop'];
	elseif option == "josuke" then
		print("Jojo's Monk__Josuke Higashikata SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Josuke_Higashikata_drop'];
	elseif option == "jotaro" then
		print("Jojo's Monk_Jotaro Kujo SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Jotaro_Kujo_drop'];
	elseif option == "giorno" then
		print("Jojo's Monk_Giorno Giovanna SFX -> activate");
		JojoMonk_Config.ActiveCharacter = L['Giorno_Giovanna_drop'];
	elseif option == "on" then
		print("Jojo's Monk -> Activate SFX");
		JojoMonk_Config.ActiveSFX = true;
	elseif option == "off" then
		print("Jojo's Monk -> Desactivate SFX");
		JojoMonk_Config.ActiveSFX = false;
	else
		print("Jojo's Monk command : ");
		print("Choose character : /jojom <dio - jonathan - joseph - josuke - jotaro - giorno>");
		print("Activate/Desactivate SFX : /jojom <on-off>");
		
	end
	setActiveCharacterOnDropDown();
	setActiveSFXOnDropDown();
end


	