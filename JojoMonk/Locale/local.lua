

function GetLocalCharacterListView()
	
	Character = { -- Name of the addon / Name you want to display on the interface (can be change in the langage files).
		{"JojoMonk_DioBrando",L['Dio_Brando_drop'],},
		{"JojoMonk_JotaroKujo",L['Jotaro_Kujo_drop'],},
		{"JojoMonk_JonathanJoestar",L['Jonathan_Joestar_drop'],},
		{"JojoMonk_JosephJoestar",L['Joseph_Joestar_drop'],},
		{"JojoMonk_JosukeHigashikata",L['Josuke_Higashikata_drop'],},
		{"JojoMonk_GiornoGiovanna",L['Giorno_Giovanna_drop'],},
	}
	local vide = true;
	JojoMonk_CharacterListView = { };
	for i = 1,6 do
	name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(Character[i][1]);
	if(enabled) then 
		table.insert(JojoMonk_CharacterListView, Character[i][2])
		
		vide = false;
	end -- if

	end -- for

	if(vide) then
		return {L['no_addon_load']};
	end
	return JojoMonk_CharacterListView
end

function GetLocalLanguageListView()

	return {
	"English",
	"Français"
	}

end
