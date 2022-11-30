local QTR_version = GetAddOnMetadata("RingOfWar", "Version");
 
Rowtr:SetScript("OnEvent", function() Rowtr:OnEvent(this, event, name, arg1,arg2,arg3,arg4,arg5) end);  


local QTR_onDebug = false;      
local QTR_name = UnitName("player");
local QTR_class= UnitClass("player");
local QTR_race = UnitRace("player");
local QTR_sex = UnitSex("player");     -- 1:neutral,  2:męski,  3:żeński 
local QTR_OldQuestCache
local QTR_QuestCache
local QTROptionsFrame
local _G = Rowtr.G
local print
local c_hooksecurefunc
local c_HookScript

if(Rowtr.target <= 2) then
   if(Rowtr.SecHookScript) then
      c_HookScript = Rowtr.SecHookScript
   end
   if(Rowtr.HookSecureFunction) then
      c_hooksecurefunc = Rowtr.HookSecureFunction
   end
end

if(Rowtr.Print) then
   print = Rowtr.Print 
end


local QTR_flaggedForItemFix = false;
local QTR_flaggedDisableTT = {};
local QTR_MessOrig = {
      details    = "Description", 
      objectives = "Objectives", 
      rewards    = "Rewards", 
      itemchoose1= "You will be able to choose one of these rewards:", 
      itemchoose2= "Choose one of these rewards:", 
      itemreceiv1= "You will also receive:", 
      itemreceiv2= "You receiving the reward:", 
      learnspell = "Learn Spell:", 
      reqmoney   = "Required Money:", 
      reqitems   = "Required items:", 
      experience = "Experience:", 
      currquests = "Current Quests", 
      avaiquests = "Available Quests", };

      local QTR_Reklama = { 
         ON = "Eklentiyi aktif et",
         PERIOD = "Ardışık sürümler arasındaki süre:",
         TEXT1 = "%s görevi, Ring Of War eklentisi wowtercuman kullanılarak çevrildi ve kabul edildi",
         TEXT2 = "Ringofwar - Görevleri, becerileri ve ögeleri ceviren bir Eklenti",
         CHANNEL = "Mesajı yaymak için kullanılan kanal (0, /say)",
   }; 

local QTR_GameTooltip = GameTooltip;
local QTR_GameTooltipTextLeft = "GameTooltipTextLeft"
local QTR_GameTooltipTextLeft1 = "GameTooltipTextLeft1"
local QTR_GameTooltipTextRight = "GameTooltipTextRight"
local QTR_GameTooltipMoneyFrame1PrefixText = "GameTooltipMoneyFrame1PrefixText"
local QTR_GameTooltipMoneyFrame2PrefixText = "GameTooltipMoneyFrame1PrefixText"


local QTR_quest_EN = {
      id = 0,
      title = "",
      details = "",
      objectives = "",
      progress = "",
      completion = "",
      itemchoose = "",
      itemreceive = "", };      
local QTR_quest_LG = {
      id = 0,
      title = "",
      details = "", 
      objectives = "", 
      progress = "", 
      completion = "", 
      itemchoose = "",
      itemreceive = "", };       
local last_time = GetTime();
local last_text = 0;
local curr_trans = "1";
local curr_goss = "X";
local QTR_GS_MENUS = {};
local curr_hash = 0;
local Original_Font1 = "Fonts\\MORPHEUS.ttf";
local Original_Font2 = "Fonts\\FRIZQT__.ttf";
local WT_Font = Original_Font2;
local p_race = {
      ["Blood Elf"] = { M1="Kanlı Elf", D1="Kanlı Elf", C1="Kanlı Elf", B1="Kanlı Elf", N1="Kanlı Elf", K1="Kanlı Elf", W1="Kanlı Elf", M2="Kanlı Elf", D2="Kanlı Elf", C2="Kanlı Elf", B2="Kanlı Elf", N2="Kanlı Elf", K2="Kanlı Elf", W2="Kanlı Elf" }, 
	  ["Dark Iron Dwarf"] = { M1="Kara Demir Cüce", D1="Karanlık Demir Cüce", C1="Karanlık Demir Cüce", B1="Karanlık Demir Cüce", N1="Kara Demir Cüce", K1 ="Kara Demir Cüceler", W1="Kara Demir Cüce", M2="Kara Demir Cüce", D2="DKara Demir Cüce", C2="Kara Demir Cüce", B2="Kara Demir Cüce", N2="Kara Demir Cüce", K2="Kara Demir Cüce", W2="Kara Demir Cüce" },  
	  ["Draenei"] = { M1="Draenei", D1="Draenei", C1="Draenei", B1="Draenei", N1="Draenei", K1="Draenei", W1="Draenei", M2="Draenei", D2="Draenei", C2="Draenei", B2="Draenei", N2="Draenei", K2="Draenei", W2="Draenei" },
      ["Dwarf"] = { M1="Dwarf", D1="Dwarf", C1="Dwarf", B1="Dwarf", N1="Dwarf", K1="Dwarf", W1="Dwarf", M2="Dwarf", D2="Dwarf", C2="Dwarf", B2="Dwarf", N2="Dwarf", K2="Dwarf", W2="Dwarf" },
      ["Gnome"] = { M1="Gnome", D1="Gnome", C1="Gnome", B1="Gnome", N1="Gnome", K1="Gnome", W1="Gnome", M2="Gnome", D2="Gnome", C2="Gnome", B2="Gnome", N2="Gnome", K2="Gnome", W2="Gnome" },
      ["Goblin"] = { M1="Goblin", D1="Goblin", C1="Goblin", B1="Goblin", N1="Goblin", K1="Goblin", W1="Goblin", M2="Goblin", D2="Goblin", C2="Goblin", B2="Goblin", N2="Goblin", K2="Goblin", W2="Goblin" },
      ["Highmountain Tauren"] = { M1="Highmountain Tauren", D1="Highmountain Tauren", C1="Highmountain Tauren", B1="Highmountain Tauren", N1="Highmountain Tauren", K1="Highmountain Tauren", W1="Highmountain Tauren", M2="Highmountain Tauren", D2="Highmountain Tauren", C2="Highmountain Tauren", B2="Highmountain Tauren", N2="Highmountain Tauren", K2="Highmountain Tauren", W2="Highmountain Tauren" },
      ["Human"] = { M1="Human", D1="Human", C1="Human", B1="Human", N1="Human", K1="human", W1="human", M2="human", D2="human", C2="human", B2="human", N2="human", K2="human", W2="human" },
      ["Kul Tiran"] = { M1="Kul Tiran", D1="Kul Tirana", C1="Kul Tiran", B1="Kul Tiran", N1="Kul Tiran", K1="Kul Tiran", W1="Kul Tiran", M2="Kul Tiran", D2="Kul Tiranki", C2="Kul Tirance", B2="Kul Tirankę", N2="Kul Tiran", K2="Kul Tiran", W2="Kul Tiran" },
      ["Lightforged Draenei"] = { M1="Lightforged Draenei", D1="Lightforged Draenei", C1="Lightforged Draenei", B1="Lightforged Draenei", N1="Lightforged Draenei", K1="Lightforged Draenei", W1="Lightforged Draenei", M2="Lightforged Draenei", D2="świetlistej draeneiki", C2="Lightforged Draenei", B2="Lightforged Draenei", N2="Lightforged Draenei", K2="Lightforged Draenei", W2="Lightforged Draenei" },
      ["Mag'har Orc"] = { M1="Mag'har Orc", D1="Mag'har Orc", C1="Mag'har Orc", B1="Mag'har Orc", N1="Mag'har Orc", K1="Mag'har Orc", W1="Mag'har Orc", M2="Mag'har Orc", D2="Mag'har Orc", C2="Mag'har Orc", B2="Mag'har Orc", N2="Mag'har Orc", K2="Mag'har Orc", W2="Mag'har Orc" },
      ["Nightborne"] = { M1="Nightborne", D1="Nightborne", C1="Nightborne", B1="Nightborne", N1="Nightborne", K1="Nightborne", W1="Nightborne", M2="Nightborne", D2="Nightborne", C2="Nightborne", B2="Nightborne", N2="Nightborne", K2="Nightborne", W2="Nightborne" },
      ["Night Elf"] = { M1="Night Elf", D1="Night Elf", C1="Night Elf", B1="Night Elf", N1="Night Elf", K1="Night Elf", W1="Night Elf", M2="Night Elf", D2="Night Elf", C2="Night Elf", B2="Night Elf", N2="Night Elf", K2="Night Elf", W2="Night Elf" },
      ["Orc"] = { M1="Orc", D1="Orc", C1="Orc", B1="Orc", N1="Orc", K1="Orc", W1="Orc", M2="Orc", D2="Orc", C2="Orc", B2="Orc", N2="Orc", K2="Orc", W2="Orc" },
      ["Pandaren"] = { M1="Pandaren", D1="Pandaren", C1="Pandaren", B1="Pandaren", N1="Pandaren", K1="Pandaren", W1="Pandaren", M2="Pandaren", D2="Pandaren", C2="Pandaren", B2="Pandaren", N2="Pandaren", K2="Pandaren", W2="Pandaren" },
      ["Tauren"] = { M1="Tauren", D1="Tauren", C1="Tauren", B1="Tauren", N1="Tauren", K1="Tauren", W1="Tauren", M2="Tauren", D2="Tauren", C2="Tauren", B2="Tauren", N2="Tauren", K2="Tauren", W2="Tauren" },
      ["Troll"] = { M1="Troll", D1="Troll", C1="Troll", B1="Troll", N1="Troll", K1="Troll", W1="Troll", M2="Troll", D2="Troll", C2="Troll", B2="Troll", N2="Troll", K2="Troll", W2="Troll" },
      ["Undead"] = { M1="Undead", D1="Undead", C1="Undead", B1="Undead", N1="Undead", K1="Undead", W1="Undead", M2="Undead", D2="Undead", C2="Undead", B2="Undead", N2="Undead", K2="Undead", W2="Undead" },
      ["Void Elf"] = { M1="Void Elf", D1="Void Elf", C1="Void Elf", B1="Void Elf", N1="Void Elf", K1="Void Elf", W1="Void Elf", M2="Void Elf", D2="Void Elf", C2="Void Elf", B2="Void Elf", N2="Void Elf", K2="Void Elf", W2="Void Elf" },
      ["Worgen"] = { M1="Worgen", D1="Worgen", C1="Worgen", B1="Worgen", N1="Worgen", K1="Worgen", W1="Worgen", M2="Worgen", D2="Worgen", C2="Worgen", B2="Worgen", N2="Worgen", K2="Worgen", W2="Worgen" },
      ["Zandalari Troll"] = { M1="Zandalari Troll", D1="Zandalari Troll", C1="Zandalari Troll", B1="Zandalari Troll", N1="Zandalari Troll", K1="trollu Zandalari", W1="Troll Zandalari", M2="Trollica Zandalari", D2="trollicy Zandalari", C2="trollicy Zandalari", B2="trollicę Zandalari", N2="trollicą Zandalari", K2="trollicy Zandalari", W2="Trolesa Zandalari" }, }
local p_class = {
      ["Death Knight"] = { M1="Death Knight", D1="Death Knight", C1="Death Knight", B1="Death Knight", N1="Death Knight", K1="Death Knight", W1="Death Knight", M2="Death Knight", D2="Death Knight", C2="Death Knight", B2="Death Knight", N2="Death Knight", K2="Death Knight", W2="Death Knight" },
      ["Demon Hunter"] = { M1="Demon Hunter", D1="Demon Hunter", C1="Demon Hunter", B1="Demon Hunter", N1="Demon Hunter", K1="Demon Hunter", W1="Demon Hunter", M2="Demon Hunter", D2="Demon Hunter", C2="Demon Hunter", B2="Demon Hunter", N2="Demon Hunter", K2="Demon Hunter", W2="Demon Hunter" },
      ["Druid"] = { M1="Druid", D1="Druid", C1="Druid", B1="Druid", N1="Druid", K1="Druid", W1="Druid", M2="Druid", D2="Druid", C2="Druid", B2="Druid", N2="Druid", K2="Druid", W2="Druid" },
      ["Hunter"] = { M1="Hunter", D1="Hunter", C1="Hunter", B1="Hunter", N1="Hunter", K1="Hunter", W1="Hunter", M2="Hunter", D2="Hunter", C2="Hunter", B2="Hunter", N2="Hunter", K2="Hunter", W2="Hunter" },
      ["Mage"] ={ M1="Büyücü", D1="sihirbaz", C1="büyücü", B1="büyücü", N1="büyücü", K1="büyücü", W1="Mago", M2="büyücü", D2 ="büyücüler", C2="büyücü", B2="büyücü", N2="büyücü", K2="büyücü", W2="Büyücü" },
      ["Monk"] = { M1="Monk", D1="Monk", C1="Monk", B1="Monk", N1="Monk", K1="Monk", W1="Monk", M2="Monk", D2="Monk", C2="Monk", B2="Monk", N2="Monk", K2="Monk", W2="Monk" },
      ["Paladin"] = { M1="Paladin", D1="Paladin", C1="Paladin", B1="paladin", N1="paladin", K1="paladin", W1="paladin", M2="paladin", D2="paladin", C2="paladin", B2="paladin", N2="paladin", K2="paladin", W2="paladin" },
      ["Priest"] = { M1="priest", D1="priest", C1="priest", B1="priest", N1="priest", K1="priest", W1="priest", M2="priest", D2="priest", C2="priest", B2="priest", N2="priest", K2="priest", W2="priest" },
      ["Rogue"] = { M1="rogue", D1="rogue", C1="rogue", B1="rogue", N1="rogue", K1="rogue", W1="rogue", M2="rogue", D2="rogue", C2="rogue", B2="rogue", N2="rogue", K2="rogue", W2="rogue" },
      ["Shaman"] = { M1="Shaman", D1="Shaman", C1="Shaman", B1="Shaman", N1="Shaman", K1="Shaman", W1="Shaman", M2="Shaman", D2="Shaman", C2="Shaman", B2="Shaman", N2="Shaman", K2="Shaman", W2="Shaman" },
      ["Warlock"] = { M1="Warlock", D1="Warlock", C1="Warlock", B1="Warlock", N1="Warlock", K1="Warlock", W1="Warlock", M2="Warlock", D2="Warlock", C2="Warlock", B2="Warlock", N2="Warlock", K2="Warlock", W2="Warlock" },
      ["Warrior"] = { M1="Warrior", D1="Warrior", C1="Warrior", B1="Warrior", N1="Warrior", K1="Warrior", W1="Warrior", M2="Warrior", D2="Warrior", C2="Warrior", B2="Warrior", N2="Warrior", K2="Warrior", W2="Warrior" }, }
if (p_race[QTR_race]) then      
   player_race = { M1=p_race[QTR_race].M1, D1=p_race[QTR_race].D1, C1=p_race[QTR_race].C1, B1=p_race[QTR_race].B1, N1=p_race[QTR_race].N1, K1=p_race[QTR_race].K1, W1=p_race[QTR_race].W1, M2=p_race[QTR_race].M2, D2=p_race[QTR_race].D2, C2=p_race[QTR_race].C2, B2=p_race[QTR_race].B2, N2=p_race[QTR_race].N2, K2=p_race[QTR_race].K2, W2=p_race[QTR_race].W2 };
else   
   player_race = { M1=QTR_race, D1=QTR_race, C1=QTR_race, B1=QTR_race, N1=QTR_race, K1=QTR_race, W1=QTR_race, M2=QTR_race, D2=QTR_race, C2=QTR_race, B2=QTR_race, N2=QTR_race, K2=QTR_race, W2=QTR_race };
  -- print ("|cff55ff00QTR - nowa rasa: "..QTR_race);
end
if (p_class[QTR_class]) then
   player_class = { M1=p_class[QTR_class].M1, D1=p_class[QTR_class].D1, C1=p_class[QTR_class].C1, B1=p_class[QTR_class].B1, N1=p_class[QTR_class].N1, K1=p_class[QTR_class].K1, W1=p_class[QTR_class].W1, M2=p_class[QTR_class].M2, D2=p_class[QTR_class].D2, C2=p_class[QTR_class].C2, B2=p_class[QTR_class].B2, N2=p_class[QTR_class].N2, K2=p_class[QTR_class].K2, W2=p_class[QTR_class].W2 };
else
   player_class = { M1=QTR_class, D1=QTR_class, C1=QTR_class, B1=QTR_class, N1=QTR_class, K1=QTR_class, W1=QTR_class, M2=QTR_class, D2=QTR_class, C2=QTR_class, B2=QTR_class, N2=QTR_class, K2=QTR_class, W2=QTR_class };
   --print ("|cff55ff00QTR - nowa klasa: "..QTR_class);
end


local function StringHash(text)           -- funkcja tworząca Hash (32-bitowa liczba) podanego tekstu 
  return Rowtr:StringHash(text);
end

-- Zmienne programowe zapisane na stałe na komputerze
function Rowtr:CheckVars()
  if (not QTR_PS) then
     QTR_PS = {};
  end
  if (not QTRTTT_PS) then
   QTRTTT_PS = {};
   end
  if (not QTR_MISSING) then
     QTR_MISSING = {};
  end 
  -- inicjalizacja: tłumaczenia włączone
  if (not QTR_PS["active"]) then
     QTR_PS["active"] = "1";
  end
  -- inicjalizacja: tłumaczenie tytułu questu włączone
  if (not QTR_PS["transtitle"] ) then
     QTR_PS["transtitle"] = "0";   
  end

  if (not QTR_PS["enablegoss"] ) then
      QTR_PS["enablegoss"] = "1";   
  end
  -- zmienna specjalna dostępności funkcji GetQuestID 
  if ( QTR_PS["isGetQuestID"] ) then
     isGetQuestID=QTR_PS["isGetQuestID"];
  end;
  -- okresowe wyświetlanie reklam o dodatku 
  if (not QTR_PS["reklama"] ) then
     QTR_PS["reklama"] = "1";
     QTR_PS["period"] = 15; 
     QTR_PS["channel"] = "0";
  end;
  if (not QTR_PS["other1"] ) then
     QTR_PS["other1"] = "1";
  end;
  if (not QTR_PS["other2"] ) then
     QTR_PS["other2"] = "1";
  end;
  if (not QTR_PS["other3"] ) then
     QTR_PS["other3"] = "1";
  end;
  if (not QTR_PS["channel"] ) then
     QTR_PS["channel"] = "0";
  end;
   -- zapis kontrolny oryginalnych questów EN
  if (not QTR_PS["control"]) then
     QTR_PS["control"] = "1";
  end
   -- zapis wersji patcha Wow'a
  if (not QTR_PS["patch"]) then
     QTR_PS["patch"] = GetBuildInfo();
  end

    -- initialize check options
    if (not QTRTTT_PS["active"] ) then
      QTRTTT_PS["active"] = "1";   
   end
   if (not QTRTTT_PS["showID"] ) then
      QTRTTT_PS["showID"] = "0";   
   end
   if (not QTRTTT_PS["saveNW"] ) then
      QTRTTT_PS["saveNW"] = "0";   
   end
   if (not QTRTTT_PS["saveWH"] ) then
      QTRTTT_PS["saveWH"] = "0";   
   end
   if (not QTRTTT_PS["compOR"] ) then
      QTRTTT_PS["compOR"] = "1";   
   end
   if (not QTRTTT_PS["body"] ) then
      QTRTTT_PS["body"] = "1";   
   end
   if (not QTRTTT_PS["mats"] ) then
      QTRTTT_PS["mats"] = "1";   
   end
   if (not QTRTTT_PS["weapon"] ) then
      QTRTTT_PS["weapon"] = "1";   
   end
   if (not QTRTTT_PS["info"] ) then
      QTRTTT_PS["info"] = "1";   
   end
   if (not QTRTTT_PS["ener"] ) then
      QTRTTT_PS["ener"] = "1";   
   end
   if (not QTRTTT_PS["try"] ) then
      QTRTTT_PS["try"] = "1";   
   end
   if(not QTRTTT_PS["isstat"]) then
      QTRTTT_PS["isstat"] = "1"
   end

   if (not QTRTTT_PS["questHelp"] ) then
      QTRTTT_PS["questHelp"] = "1";   
   end
  
  if(not QTR_FIXEDQUEST) then
     QTR_FIXEDQUEST = {};
  end
  if(not QTR_FIXEDITEM) then
     QTR_FIXEDITEM = {};
  end
  if(not QTR_FIXEDSPELL) then
     QTR_FIXEDSPELL = {};
  end 
 -- jeszcze nazwa gracza w przepadkach / per character
  if (not QTR_QUESTSTATUS) then
     QTR_QUESTSTATUS = {};
  end

  if(not QTR_PLAYERQUESTS) then
     QTR_PLAYERQUESTS = {};
  end

  if(not QTR_LASTCOMP) then
    QTR_LASTCOMP = {};
  end

   if(not QTR_LASTCOMP["id"]) then
      QTR_LASTCOMP["id"] = "0";
      QTR_LASTCOMP["completion"] = "";
      QTR_LASTCOMP["objectives"] = "";
      QTR_LASTCOMP["description"] = "";
      QTR_LASTCOMP["progress"] = "";
      QTR_LASTCOMP["completion"] = "";
   end 

  QTR_GS = {};       -- tablica na teksty oryginalne 
end 
-- Obsługa komend slash
function Rowtr:SlashCommand(msg)
   if (msg=="on" or msg=="ON") then
      if (QTR_PS["active"]=="1") then
         print ("Rowtr - Etkinlestirildi");
      else
         print ("|cffffff00QTR - Cevirileri etkinlestirme");
         QTR_PS["active"] = "1";
         QTR_ToggleButton0:Enable();
         QTR_ToggleButton1:Enable();
         QTR_ToggleButton2:Enable(); 
         QTR_ToggleButtonWM:Enable();  
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:Enable();
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:Enable();
         end
         Rowtr:Translate_On(1);
      end
   elseif (msg=="off" or msg=="OFF") then
      if (QTR_PS["active"]=="0") then
         print ("Rowtr - Eklenti devre disi birakildi");
      else
         print ("|cffffff00QTR - Cevirileri devre dısı bırakma.");
         QTR_PS["active"] = "0";
         QTR_ToggleButton0:Disable();
         QTR_ToggleButton1:Disable();
         QTR_ToggleButton2:Disable();
         QTR_ToggleButtonWM:Disable(); 
         if (RowtrisQuestGuru()) then
            QTR_ToggleButton3:Disable();
         end
         if (RowtrisImmersion()) then
            QTR_ToggleButton4:Disable();
         end  
         Rowtr:Translate_Off(1);
      end
   elseif (msg=="title on" or msg=="TITLE ON" or msg=="title 1") then
      if (QTR_PS["transtilte"]=="1") then
         print ("Rowtr - Baslik cevirisi etkinlestirildi.");
      else
         print ("|cffffff00QTR - Baslik cevirisinin etkinlestirilmesi");
         QTR_PS["transtitle"] = "1";
         --QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
      end
   elseif (msg=="title off" or msg=="TITLE OFF" or msg=="title 0") then
      if (QTR_PS["transtilte"]=="0") then
         print ("Rowtr - Baslik cevirisi devre disi");
      else
         print ("|cffffff00QTR - Baslik cevirisini devre disi birakma");
         QTR_PS["transtitle"] = "0";
         --QuestInfoTitleHeader:SetFont(Original_Font1, 18);
      end
   elseif (msg=="title" or msg=="TITLE") then
      if (QTR_PS["transtilte"]=="1") then
         print ("Rowtr - Baslik cevirisi etkinlestirildi");
      else
         print ("Rowtr - Baslik cevirisi devre disi birakildi.");
      end
   elseif (msg=="") then 
      if(Rowtr.target < 3) then
         if(QTROptionsFrame) then
            if(QTROptionsFrame:IsVisible() and not QTROptionsFrame.QTRMoreOptions:IsVisible()) then
               QTROptionsFrame:Hide();
            elseif(not QTROptionsFrame:IsVisible() and QTROptionsFrame.QTRMoreOptions:IsVisible()) then
               QTROptionsFrame.QTRMoreOptions:Hide();
            else
               QTROptionsFrame:Show();
               QTROptionsFrame.QTRMoreOptions:Hide();
            end
         end
      else 
         InterfaceOptionsFrame_Show();
         InterfaceOptionsFrame_OpenToCategory("Rowtr");
      end  
   else
      print ("Rowtr - Gorev komut listesi");
      print ("      /qtr  - Eklenti ayarlari penceresini acar");
      print ("      /qtr on  - Eklentiyi aktiflestirir. ");
      print ("      /qtr off - Eklentiyi pasiflestirir");
      print ("      /qtr title on  - Görev baslıklarının çevirisini etkinleştir");
      print ("      /qtr title off - Görev baslıklarının çevirisini devre dışı bırak");
   end 
end



function Rowtr:SetCheckButtonState()
  QTRCheckButton0:SetChecked(QTR_PS["active"]=="1");
  QTRCheckButton3:SetChecked(QTR_PS["transtitle"]=="1");
  QTRCheckButton4:SetChecked(QTR_PS["enablegoss"]=="1"); 
  QTRCheckButton5:SetChecked(QTR_PS["reklama"]=="1");
  WowTranslatorCheckButton0:SetChecked(QTRTTT_PS["active"]=="1");
  WowTranslatorCheckButton1:SetChecked(QTRTTT_PS["showID"]=="1");
  WowTranslatorCheckButton4:SetChecked(QTRTTT_PS["body"]=="1");
  WowTranslatorCheckButton5:SetChecked(QTRTTT_PS["mats"]=="1");
  WowTranslatorCheckButton6:SetChecked(QTRTTT_PS["weapon"]=="1");
  WowTranslatorCheckButton9:SetChecked(QTRTTT_PS["ener"]=="1");
  WowTranslatorCheckButton7:SetChecked(QTRTTT_PS["info"]=="1");
  WowTranslatorCheckButton8:SetChecked(QTRTTT_PS["try"]=="1");
  WowTranslatorCheckButton10:SetChecked(QTRTTT_PS["questHelp"]=="1");
  WowTranslatorCheckButton11:SetChecked(QTRTTT_PS["isstat"]=="1");
end

local function QTR_BlizzardOptions()
  -- Create main frame for information text
   local QTROptionsFrame = CreateFrame("FRAME", "Rowtr_Options"); 

   QTROptionsScrollFrame = CreateFrame("ScrollFrame", "QTROptionsScroll", QTROptionsFrame, "UIPanelScrollFrameTemplate");
  
   QTROptionsScrollChild = QTROptionsScrollChild or CreateFrame("Frame");  
   local scrollbarName = QTROptionsScrollFrame:GetName()
   local qtrOptscrollbar = _G[scrollbarName.."ScrollBar"];
   local qtrOptscrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
   local qtrOptscrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
   qtrOptscrollupbutton:ClearAllPoints();
   qtrOptscrollupbutton:SetPoint("TOPRIGHT", QTROptionsScrollFrame, "TOPRIGHT", -2, -2);
 
   qtrOptscrolldownbutton:ClearAllPoints();
   qtrOptscrolldownbutton:SetPoint("BOTTOMRIGHT", QTROptionsScrollFrame, "BOTTOMRIGHT", -2, 2);
 
   qtrOptscrollbar:ClearAllPoints();
   qtrOptscrollbar:SetPoint("TOP", qtrOptscrollupbutton, "BOTTOM", 0, -2);
   qtrOptscrollbar:SetPoint("BOTTOM", qtrOptscrolldownbutton, "TOP", 0, 2); 
   QTROptionsScrollFrame:SetScrollChild(QTROptionsScrollChild); 
   QTROptionsScrollFrame:SetAllPoints(QTROptionsFrame); 
   QTROptionsScrollChild:SetSize(InterfaceOptionsFramePanelContainer:GetWidth(), ( InterfaceOptionsFramePanelContainer:GetHeight() * 2.13 ));
   
   local QTROptions = CreateFrame("Frame", nil, QTROptionsScrollChild);
   QTROptions:SetAllPoints(QTROptionsScrollChild); 

   QTROptionsFrame.name = "Rowtr";
   QTROptionsFrame.refresh = function (self) Rowtr:SetCheckButtonState() end;
  InterfaceOptions_AddCategory(QTROptionsFrame);

  local QTROptionsHeader = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsHeader:SetFontObject(GameFontNormalLarge);
  QTROptionsHeader:SetJustifyH("LEFT"); 
  QTROptionsHeader:SetJustifyV("TOP");
  QTROptionsHeader:ClearAllPoints();
  QTROptionsHeader:SetPoint("TOPLEFT", 12, -12);
  QTROptionsHeader:SetText(string.format("Rowtr Woltk Turkce ceviri. "..QTR_base..",\n WowTranslator by Platine © 2010-2018"));

  local QTRDateOfBase = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRDateOfBase:SetFontObject(GameFontHighlightSmall);
  QTRDateOfBase:SetJustifyH("LEFT"); 
  QTRDateOfBase:SetJustifyV("TOP");
  QTRDateOfBase:ClearAllPoints();
  QTRDateOfBase:SetPoint("TOPLEFT", QTROptionsHeader, "TOPLEFT", 0, -60);
  QTRDateOfBase:SetText(string.format("Guncelleme icin www.ringofwar.com.tr "));
  QTRDateOfBase:SetFont(QTR_Font2, 16);

  local QTRCheckButton0 = CreateFrame("CheckButton", "QTRCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton0:SetPoint("TOPLEFT", QTROptionsHeader, "BOTTOMLEFT", 0, -70);
  QTRCheckButton0:SetScript("OnClick", function(self) if (QTR_PS["active"]=="1") then QTR_PS["active"]="0" else QTR_PS["active"]="1" end;end);  
  QTRCheckButton0Text:SetFont(QTR_Font2, 13);
  QTRCheckButton0Text:SetText(QTR_Interface.active);

  local QTROptionsMode1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode1:SetFontObject(GameFontWhite);
  QTROptionsMode1:SetJustifyH("LEFT");
  QTROptionsMode1:SetJustifyV("TOP");
  QTROptionsMode1:ClearAllPoints();
  QTROptionsMode1:SetPoint("TOPLEFT", QTRCheckButton0, "BOTTOMLEFT", 20, -20);
  QTROptionsMode1:SetFont(QTR_Font2, 13);
  QTROptionsMode1:SetText(QTR_Interface.options1);
  
  local QTRCheckButton3 = CreateFrame("CheckButton", "QTRCheckButton3", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton3:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -5);
  QTRCheckButton3:SetScript("OnClick", function(self) if (QTR_PS["transtitle"]=="0") then QTR_PS["transtitle"]="1" else QTR_PS["transtitle"]="0" end; end);
  QTRCheckButton3Text:SetFont(QTR_Font2, 13);
  QTRCheckButton3Text:SetText(QTR_Interface.transtitle);

  local QTRCheckButton4 = CreateFrame("CheckButton", "QTRCheckButton4", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton4:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -30);
  QTRCheckButton4:SetScript("OnClick", function(self) if (QTR_PS["enablegoss"]=="0") then QTR_PS["enablegoss"]="1"; QTR_ToggleButtonGS:Show() else QTR_PS["enablegoss"]="0"; QTR_ToggleButtonGS:Hide()  end; end);
  QTRCheckButton4Text:SetFont(QTR_Font2, 13);
  QTRCheckButton4Text:SetText(QTR_Interface.enablegoss);

  local QTRCheckButton5 = CreateFrame("CheckButton", "QTRCheckButton5", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton5:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -50);
  QTRCheckButton5:SetScript("OnClick", function(self) if (QTR_PS["reklama"]=="0") then QTR_PS["reklama"]="1" else QTR_PS["reklama"]="0" end; end);
  QTRCheckButton5Text:SetFont(QTR_Font2, 13);
  QTRCheckButton5Text:SetText(QTR_Reklama.ON);
  
  local QTREditBox = CreateFrame("EditBox", "QTREditBox", QTROptions, "InputBoxTemplate");
  QTREditBox:SetPoint("TOPLEFT", QTRCheckButton5Text, "TOPRIGHT", 10, 3);
  QTREditBox:SetHeight(20);
  QTREditBox:SetWidth(20);
  QTREditBox:SetAutoFocus(false);
  QTREditBox:SetText(QTR_PS["channel"]);
  QTREditBox:SetCursorPosition(0);
  QTREditBox:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    getglobal("GameTooltipTextLeft1"):SetFont(QTR_Font2, 13);
     GameTooltip:SetText(QTR_Reklama.CHANNEL, nil, nil, nil, nil, true)
   GameTooltip:Show() --Show the tooltip
   end);
   QTREditBox:SetScript("OnLeave", function(self)
    getglobal("GameTooltipTextLeft1"):SetFont(Original_Font2, 13);
   GameTooltip:Hide() --Hide the tooltip
   end);
  QTREditBox:SetScript("OnTextChanged", function(self) if (strlen(QTREditBox:GetText())>0) then QTR_PS["channel"]=QTREditBox:GetText() end; end);

  local QTRPeriodText = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRPeriodText:SetFontObject(GameFontWhite);
  QTRPeriodText:SetJustifyH("LEFT");
  QTRPeriodText:SetJustifyV("TOP");
  QTRPeriodText:ClearAllPoints();
  QTRPeriodText:SetPoint("TOPLEFT", QTRCheckButton5, "BOTTOMLEFT", 30, -20);
  QTRPeriodText:SetFont(QTR_Font2, 13);
  QTRPeriodText:SetText(QTR_Reklama.PERIOD);
  
  local QTR_slider = CreateFrame("Slider","MyAddonSlider",QTROptions,'OptionsSliderTemplate');
  QTR_slider:ClearAllPoints();
  QTR_slider:SetPoint("TOPLEFT",QTRPeriodText, "BOTTOMLEFT", 80, -30);
  
  getglobal(QTR_slider:GetName() .. 'Low'):SetText('5 min.');
  getglobal(QTR_slider:GetName() .. 'High'):SetText('90 min.');
  getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
  QTR_slider:SetMinMaxValues(5, 90);
  QTR_slider:SetValue(QTR_PS["period"]);
  QTR_slider:SetValueStep(5);
  QTR_slider:SetScript("OnValueChanged", function(self)
      QTR_PS["period"] = math.floor(QTR_slider:GetValue()+0.5);
      getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
      end);



local WowTranslatorOptionsStaff = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsStaff:SetFontObject(GameFontGreen);
WowTranslatorOptionsStaff:SetJustifyH("LEFT"); 
WowTranslatorOptionsStaff:SetJustifyV("TOP");
WowTranslatorOptionsStaff:ClearAllPoints();
WowTranslatorOptionsStaff:SetPoint("TOPLEFT", QTRCheckButton5, "BOTTOMLEFT", -15, -100);
WowTranslatorOptionsStaff:SetFont(WT_Font, 14);
WowTranslatorOptionsStaff:SetText("-----------------------------------------------------------------");


local WowTranslatorOptionsStaff1 = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsStaff1:SetFontObject(GameFontWhite);
WowTranslatorOptionsStaff1:SetJustifyH("LEFT"); 
WowTranslatorOptionsStaff1:SetJustifyV("TOP");
WowTranslatorOptionsStaff1:ClearAllPoints();
WowTranslatorOptionsStaff1:SetPoint("TOPLEFT", WowTranslatorOptionsStaff, "BOTTOMLEFT", 0, -20);
WowTranslatorOptionsStaff1:SetFont(WT_Font, 12);
WowTranslatorOptionsStaff1:SetText(WT_Interface.WTInfo);

local WowTranslatorCheckButton0 = CreateFrame("CheckButton", "WowTranslatorCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton0:SetPoint("TOPLEFT", WowTranslatorOptionsStaff1, "BOTTOMLEFT", 0, -10);
WowTranslatorCheckButton0:SetScript("OnClick", function(self) if (QTRTTT_PS["active"]=="1") then QTRTTT_PS["active"]="0" else QTRTTT_PS["active"]="1" end; end);
WowTranslatorCheckButton0Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton0Text:SetText(WT_Interface.active);

local WowTranslatorOptionsMode = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsMode:SetFontObject(GameFontWhite);
WowTranslatorOptionsMode:SetJustifyH("LEFT"); 
WowTranslatorOptionsMode:SetJustifyV("TOP");
WowTranslatorOptionsMode:ClearAllPoints();
WowTranslatorOptionsMode:SetPoint("TOPLEFT", WowTranslatorCheckButton0, "BOTTOMLEFT", 0, -20);
WowTranslatorOptionsMode:SetFont(WT_Font, 13);
WowTranslatorOptionsMode:SetText(WT_Interface.mode);

local WowTranslatorCheckButton1 = CreateFrame("CheckButton", "WowTranslatorCheckButton1", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton1:SetPoint("TOPLEFT", WowTranslatorOptionsMode, "BOTTOMLEFT", 2, -4);
WowTranslatorCheckButton1:SetScript("OnClick", function(self) if (QTRTTT_PS["showID"]=="1") then QTRTTT_PS["showID"]="0" else QTRTTT_PS["showID"]="1" end; end);
WowTranslatorCheckButton1Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton1Text:SetText(WT_Interface.showID);

local WowTranslatorCheckButton2 = CreateFrame("CheckButton", "WowTranslatorCheckButton2", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton2:SetPoint("TOPLEFT", WowTranslatorCheckButton1, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton2:SetScript("OnClick", function(self) return end);
WowTranslatorCheckButton2Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton2Text:SetText(WT_Interface.saveNW);
WowTranslatorCheckButton2:Hide();

-- local WowTranslatorCheckButton2b = CreateFrame("CheckButton", "WowTranslatorCheckButton2b", QTROptions, "OptionsCheckButtonTemplate");
-- WowTranslatorCheckButton2b:SetPoint("TOPLEFT", WowTranslatorCheckButton2Text, "TOPRIGHT", 24, 6);
-- WowTranslatorCheckButton2b:SetScript("OnClick", function(self) QTRTTT_PS["saveWH"] = not QTRTTT_PS["saveWH"]; end);
-- WowTranslatorCheckButton2bText:SetFont(WT_Font, 13);
-- WowTranslatorCheckButton2bText:SetText(WT_Interface.saveWH);

--local WowTranslatorCheckButton3 = CreateFrame("CheckButton", "WowTranslatorCheckButton3", QTROptions, "OptionsCheckButtonTemplate");
--WowTranslatorCheckButton3:SetPoint("TOPLEFT", WowTranslatorCheckButton2, "BOTTOMLEFT", 0, 0);
--WowTranslatorCheckButton3:SetScript("OnClick", function(self) QTRTTT_PS["compOR"] = not QTRTTT_PS["compOR"]; end);
--WowTranslatorCheckButton3Text:SetFont(WT_Font, 13);
--WowTranslatorCheckButton3Text:SetText(WT_Interface.compOR);


local WowTranslatorOptionsOnTheFly = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsOnTheFly:SetFontObject(GameFontWhite);
WowTranslatorOptionsOnTheFly:SetJustifyH("LEFT");
WowTranslatorOptionsOnTheFly:SetJustifyV("TOP");
WowTranslatorOptionsOnTheFly:ClearAllPoints();
WowTranslatorOptionsOnTheFly:SetPoint("TOPLEFT", WowTranslatorCheckButton2, "BOTTOMLEFT", -2, -20);
WowTranslatorOptionsOnTheFly:SetFont(WT_Font, 13);
WowTranslatorOptionsOnTheFly:SetText(WT_Interface.transl);

local WowTranslatorCheckButton4 = CreateFrame("CheckButton", "WowTranslatorCheckButton4", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton4:SetPoint("TOPLEFT", WowTranslatorOptionsOnTheFly, "BOTTOMLEFT", 0, -4);
WowTranslatorCheckButton4:SetScript("OnClick", function(self) if (QTRTTT_PS["body"]=="1") then QTRTTT_PS["body"]="0" else QTRTTT_PS["body"]="1" end; end);
WowTranslatorCheckButton4Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton4Text:SetText(WT_Interface.body);

local WowTranslatorCheckButton5 = CreateFrame("CheckButton", "WowTranslatorCheckButton5", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton5:SetPoint("TOPLEFT", WowTranslatorCheckButton4, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton5:SetScript("OnClick", function(self) if (QTRTTT_PS["mats"]=="1") then QTRTTT_PS["mats"]="0" else QTRTTT_PS["mats"]="1" end; end);
WowTranslatorCheckButton5Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton5Text:SetText(WT_Interface.mats);

local WowTranslatorCheckButton6 = CreateFrame("CheckButton", "WowTranslatorCheckButton6", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton6:SetPoint("TOPLEFT", WowTranslatorCheckButton5, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton6:SetScript("OnClick", function(self) if (QTRTTT_PS["weapon"]=="1") then QTRTTT_PS["weapon"]="0" else QTRTTT_PS["weapon"]="1" end; end);
WowTranslatorCheckButton6Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton6Text:SetText(WT_Interface.weapon);

local WowTranslatorCheckButton9 = CreateFrame("CheckButton", "WowTranslatorCheckButton9", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton9:SetPoint("TOPLEFT", WowTranslatorCheckButton6, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton9:SetScript("OnClick", function(self) if (QTRTTT_PS["ener"]=="1") then QTRTTT_PS["ener"]="0" else QTRTTT_PS["ener"]="1" end; end);
WowTranslatorCheckButton9Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton9Text:SetText(WT_Interface.ener);

local WowTranslatorCheckButton7 = CreateFrame("CheckButton", "WowTranslatorCheckButton7", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton7:SetPoint("TOPLEFT", WowTranslatorCheckButton9, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton7:SetScript("OnClick", function(self) if (QTRTTT_PS["info"]=="1") then QTRTTT_PS["info"]="0" else QTRTTT_PS["info"]="1" end; end);
WowTranslatorCheckButton7Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton7Text:SetText(WT_Interface.info);

local WowTranslatorCheckButton11 = CreateFrame("CheckButton", "WowTranslatorCheckButton11", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton11:SetPoint("TOPLEFT", WowTranslatorCheckButton7, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton11:SetScript("OnClick", function(self) if (QTRTTT_PS["isstat"]=="1") then QTRTTT_PS["isstat"]="0" else QTRTTT_PS["isstat"]="1" end; end);
WowTranslatorCheckButton11Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton11Text:SetText(WT_Interface.stats);

local WowTranslatorCheckButton8 = CreateFrame("CheckButton", "WowTranslatorCheckButton8", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton8:SetPoint("TOPLEFT", WowTranslatorCheckButton11, "BOTTOMLEFT", 0, -10);
WowTranslatorCheckButton8:SetScript("OnClick", function(self) if (QTRTTT_PS["try"]=="1") then QTRTTT_PS["try"]="0" else QTRTTT_PS["try"]="1" end; end);
WowTranslatorCheckButton8Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton8Text:SetText(WT_Interface.try);

local WowTranslatorCheckButton10 = CreateFrame("CheckButton", "WowTranslatorCheckButton10", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton10:SetPoint("TOPLEFT", WowTranslatorCheckButton8, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton10:SetScript("OnClick", function(self) if (QTRTTT_PS["questHelp"]=="1") then QTRTTT_PS["questHelp"]="0" else QTRTTT_PS["questHelp"]="1" end; end);
WowTranslatorCheckButton10Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton10Text:SetText(WT_Interface.questHelp);

local QTRCommandsLBL = QTROptions:CreateFontString(nil, "ARTWORK");
QTRCommandsLBL:SetFontObject(GameFontWhite);
QTRCommandsLBL:SetJustifyH("LEFT"); 
QTRCommandsLBL:SetJustifyV("TOP");
QTRCommandsLBL:ClearAllPoints();
QTRCommandsLBL:SetPoint("TOPLEFT", WowTranslatorCheckButton10, "BOTTOMLEFT", 0, -20);
QTRCommandsLBL:SetFont(WT_Font, 12);
QTRCommandsLBL:SetText(QTR_Interface.commands);
  
end 

function Rowtr:LoadOptionsFrame()   
  -- Create main frame for information text
   
   if(Rowtr.target > 2) then
      QTR_BlizzardOptions()
      return
   end
   
   QTROptionsFrame = CreateFrame("FRAME", "Rowtr_Options"); 
   QTROptionsFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
   edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
   tile = true, tileSize = 16, edgeSize = 16, 
   insets = { left = 4, right = 4, top = 4, bottom = 4 }});
   QTROptionsFrame:SetBackdropColor(0,0,0,1); 
   QTROptionsFrame:SetPoint("CENTER",0,0);
   QTROptionsFrame:SetWidth(500)
   QTROptionsFrame:SetFrameStrata("DIALOG")
   QTROptionsFrame:SetHeight(600) 
   QTROptionsFrame:Hide();

   
   local QTROptions = QTROptionsFrame
   
   QTROptions:SetScript("OnUpdate", function () Rowtr:SetCheckButtonState() end);


  local QTROptionsHeader = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsHeader:SetFontObject(GameFontNormalLarge);
  QTROptionsHeader:SetJustifyH("LEFT"); 
  QTROptionsHeader:SetJustifyV("TOP");
  QTROptionsHeader:ClearAllPoints();
  QTROptionsHeader:SetPoint("TOPLEFT", 12, -12);
  QTROptionsHeader:SetText(string.format("Rowtr by Leandro ver. "..QTR_base..",\nbackport and merge of WoWpoPolsku-Quests\nand WowTranslator by Platine © 2010-2018"));

  

  local QTR_CloseBtn = CreateFrame("Button",nil, QTROptions, "UIPanelButtonTemplate");
  QTR_CloseBtn:SetWidth(35);
  QTR_CloseBtn:SetHeight(25);
  QTR_CloseBtn:SetText("X"); 
  QTR_CloseBtn:Show();
  QTR_CloseBtn:ClearAllPoints();
  QTR_CloseBtn:SetPoint("TOPRIGHT", -5, -5);
  QTR_CloseBtn:SetScript("OnClick", function() QTROptions:Hide() end);


  local QTRDateOfBase = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRDateOfBase:SetFontObject(GameFontHighlightSmall);
  QTRDateOfBase:SetJustifyH("LEFT"); 
  QTRDateOfBase:SetJustifyV("TOP");
  QTRDateOfBase:ClearAllPoints();
  QTRDateOfBase:SetPoint("TOPLEFT", QTROptionsHeader, "TOPLEFT", 0, -50);
  QTRDateOfBase:SetText(string.format("Versão para WOTLK(3.3), TBC(2.4), Vanilla  (1.12.1) e \nbanco de dados feitos por Leandro, Github: leoaviana/Rowtr "));
  QTRDateOfBase:SetFont(QTR_Font2, 16);


  local QTRCheckButton0 = CreateFrame("CheckButton", "QTRCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton0:SetPoint("TOPLEFT", QTROptionsHeader, "BOTTOMLEFT", 0, -40);
  QTRCheckButton0:SetScript("OnClick", function(self) if (QTR_PS["active"]=="1") then QTR_PS["active"]="0" else QTR_PS["active"]="1" end;end);  
  QTRCheckButton0Text:SetFont(QTR_Font2, 13);
  QTRCheckButton0Text:SetText(QTR_Interface.active);
  

  local QTROptionsMode1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode1:SetFontObject(GameFontWhite);
  QTROptionsMode1:SetJustifyH("LEFT");
  QTROptionsMode1:SetJustifyV("TOP");
  QTROptionsMode1:ClearAllPoints();
  QTROptionsMode1:SetPoint("TOPLEFT", QTRCheckButton0, "BOTTOMLEFT", 20, -10);
  QTROptionsMode1:SetFont(QTR_Font2, 13);
  QTROptionsMode1:SetText(QTR_Interface.options1);
  
  local QTRCheckButton3 = CreateFrame("CheckButton", "QTRCheckButton3", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton3:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -5);
  QTRCheckButton3:SetScript("OnClick", function(self) if (QTR_PS["transtitle"]=="0") then QTR_PS["transtitle"]="1" else QTR_PS["transtitle"]="0" end; end);
  QTRCheckButton3Text:SetFont(QTR_Font2, 13);
  QTRCheckButton3Text:SetText(QTR_Interface.transtitle);

  local QTRCheckButton4 = CreateFrame("CheckButton", "QTRCheckButton4", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton4:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -30);
  QTRCheckButton4:SetScript("OnClick", function(self) if (QTR_PS["enablegoss"]=="0") then QTR_PS["enablegoss"]="1"; QTR_ToggleButtonGS:Show() else QTR_PS["enablegoss"]="0"; QTR_ToggleButtonGS:Hide()  end; end);
  QTRCheckButton4Text:SetFont(QTR_Font2, 13);
  QTRCheckButton4Text:SetText(QTR_Interface.enablegoss);

  local QTRCheckButton5 = CreateFrame("CheckButton", "QTRCheckButton5", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton5:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -50);
  QTRCheckButton5:SetScript("OnClick", function(self) if (QTR_PS["reklama"]=="0") then QTR_PS["reklama"]="1" else QTR_PS["reklama"]="0" end; end);
  QTRCheckButton5Text:SetFont(QTR_Font2, 13);
  QTRCheckButton5Text:SetText(QTR_Reklama.ON);
  
  local QTREditBox = CreateFrame("EditBox", "QTREditBox", QTROptions, "InputBoxTemplate");
  QTREditBox:SetPoint("TOPLEFT", QTRCheckButton5Text, "TOPRIGHT", 10, 3);
  QTREditBox:SetHeight(20);
  QTREditBox:SetWidth(20);
  QTREditBox:SetAutoFocus(false);
  QTREditBox:SetText(QTR_PS["channel"]); 
  QTREditBox:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(QTREditBox, "ANCHOR_TOPRIGHT") 
      GameTooltip:SetText(QTR_Reklama.CHANNEL, nil, nil, nil, nil, true)
      GameTooltip:Show() --Show the tooltip
   end);
   QTREditBox:SetScript("OnLeave", function(self) 
   GameTooltip:Hide() --Hide the tooltip
   end);
  QTREditBox:SetScript("OnTextChanged", function(self) if (strlen(QTREditBox:GetText())>0) then QTR_PS["channel"]=QTREditBox:GetText() end; end);

  local QTRPeriodText = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRPeriodText:SetFontObject(GameFontWhite);
  QTRPeriodText:SetJustifyH("LEFT");
  QTRPeriodText:SetJustifyV("TOP");
  QTRPeriodText:ClearAllPoints();
  QTRPeriodText:SetPoint("TOPLEFT", QTRCheckButton5, "BOTTOMLEFT", 30, -10);
  QTRPeriodText:SetFont(QTR_Font2, 13);
  QTRPeriodText:SetText(QTR_Reklama.PERIOD);
  
  local QTR_slider = CreateFrame("Slider","MyAddonSlider",QTROptions,'OptionsSliderTemplate');
  QTR_slider:ClearAllPoints();
  QTR_slider:SetPoint("TOPLEFT",QTRPeriodText, "BOTTOMLEFT", 80, -30);
  
  getglobal(QTR_slider:GetName() .. 'Low'):SetText('5 min.');
  getglobal(QTR_slider:GetName() .. 'High'):SetText('90 min.');
  getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
  QTR_slider:SetMinMaxValues(5, 90);
  QTR_slider:SetValue(QTR_PS["period"]);
  QTR_slider:SetValueStep(5);
  QTR_slider:SetScript("OnValueChanged", function(self)
      QTR_PS["period"] = math.floor(QTR_slider:GetValue()+0.5);
      getglobal(QTR_slider:GetName() .. 'Text'):SetText(QTR_PS["period"] .. " min.");
      end); 


local WowTranslatorOptionsStaff1 = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsStaff1:SetFontObject(GameFontWhite);
WowTranslatorOptionsStaff1:SetJustifyH("LEFT"); 
WowTranslatorOptionsStaff1:SetJustifyV("TOP");
WowTranslatorOptionsStaff1:ClearAllPoints();
WowTranslatorOptionsStaff1:SetPoint("TOPRIGHT", QTRCheckButton5, "BOTTOMRIGHT", 250, -100);
WowTranslatorOptionsStaff1:SetFont(WT_Font, 12);
WowTranslatorOptionsStaff1:SetText(WT_Interface.WTInfo);

local WowTranslatorCheckButton0 = CreateFrame("CheckButton", "WowTranslatorCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton0:SetPoint("TOPLEFT", WowTranslatorOptionsStaff1, "BOTTOMLEFT", 0, -10);
WowTranslatorCheckButton0:SetScript("OnClick", function(self) if (QTRTTT_PS["active"]=="1") then QTRTTT_PS["active"]="0" else QTRTTT_PS["active"]="1" end; end);
WowTranslatorCheckButton0Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton0Text:SetText(WT_Interface.active);

local WowTranslatorOptionsMode = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsMode:SetFontObject(GameFontWhite);
WowTranslatorOptionsMode:SetJustifyH("LEFT"); 
WowTranslatorOptionsMode:SetJustifyV("TOP");
WowTranslatorOptionsMode:ClearAllPoints();
WowTranslatorOptionsMode:SetPoint("TOPLEFT", WowTranslatorCheckButton0, "BOTTOMLEFT", 0, -5);
WowTranslatorOptionsMode:SetFont(WT_Font, 13);
WowTranslatorOptionsMode:SetText(WT_Interface.mode);

local WowTranslatorCheckButton1 = CreateFrame("CheckButton", "WowTranslatorCheckButton1", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton1:SetPoint("TOPLEFT", WowTranslatorOptionsMode, "BOTTOMLEFT", 2, -4);
WowTranslatorCheckButton1:SetScript("OnClick", function(self) if (QTRTTT_PS["showID"]=="1") then QTRTTT_PS["showID"]="0" else QTRTTT_PS["showID"]="1" end; end);
WowTranslatorCheckButton1Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton1Text:SetText(WT_Interface.showID); 

local WowTranslatorOptionsOnTheFly = QTROptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsOnTheFly:SetFontObject(GameFontWhite);
WowTranslatorOptionsOnTheFly:SetJustifyH("LEFT");
WowTranslatorOptionsOnTheFly:SetJustifyV("TOP");
WowTranslatorOptionsOnTheFly:ClearAllPoints();
WowTranslatorOptionsOnTheFly:SetPoint("TOPLEFT", WowTranslatorCheckButton1, "TOPLEFT", -2, -30);
WowTranslatorOptionsOnTheFly:SetFont(WT_Font, 13);
WowTranslatorOptionsOnTheFly:SetText(WT_Interface.transl);


local WowTranslatorCheckButton10 = CreateFrame("CheckButton", "WowTranslatorCheckButton10", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton10:SetPoint("TOPLEFT", WowTranslatorCheckButton1, "BOTTOMLEFT", 0, -15);
WowTranslatorCheckButton10:SetScript("OnClick", function(self) if (QTRTTT_PS["questHelp"]=="1") then QTRTTT_PS["questHelp"]="0" else QTRTTT_PS["questHelp"]="1" end; end);
WowTranslatorCheckButton10Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton10Text:SetText(WT_Interface.questHelp);


local WowTranslatorCheckButton8 = CreateFrame("CheckButton", "WowTranslatorCheckButton8", QTROptions, "OptionsCheckButtonTemplate");
WowTranslatorCheckButton8:SetPoint("TOPLEFT", WowTranslatorCheckButton10, "BOTTOMLEFT", 0, 0);
WowTranslatorCheckButton8:SetScript("OnClick", function(self) if (QTRTTT_PS["try"]=="1") then QTRTTT_PS["try"]="0" else QTRTTT_PS["try"]="1" end; end);
WowTranslatorCheckButton8Text:SetFont(WT_Font, 13);
WowTranslatorCheckButton8Text:SetText(WT_Interface.try);


-----------------------------------------------------------------------------------------------------------------------------------------------

local QTRMoreOptions = CreateFrame("FRAME", "Rowtr_MoreOptions"); 
QTRMoreOptions:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
tile = true, tileSize = 16, edgeSize = 16, 
insets = { left = 4, right = 4, top = 4, bottom = 4 }});
QTRMoreOptions:SetBackdropColor(0,0,0,1); 
QTRMoreOptions:SetPoint("CENTER",0,0);
QTRMoreOptions:SetWidth(500)
QTRMoreOptions:SetFrameStrata("DIALOG")
QTRMoreOptions:SetHeight(600) 
QTRMoreOptions:Hide();
QTROptions.QTRMoreOptions = QTRMoreOptions;
 
QTRMoreOptions:SetScript("OnUpdate", function () Rowtr:SetCheckButtonState() end);

local QTROptionsHeaderM = QTRMoreOptions:CreateFontString(nil, "ARTWORK");
  QTROptionsHeaderM:SetFontObject(GameFontNormalLarge);
  QTROptionsHeaderM:SetJustifyH("LEFT"); 
  QTROptionsHeaderM:SetJustifyV("TOP");
  QTROptionsHeaderM:ClearAllPoints();
  QTROptionsHeaderM:SetPoint("TOPLEFT", 12, -12);
  QTROptionsHeaderM:SetText(string.format("Rowtr by Leandro ver. "..QTR_base..",\nbackport and merge of WoWpoPolsku-Quests\nand WowTranslator by Platine © 2010-2018"));

  

  local QTR_CloseBtnM = CreateFrame("Button",nil, QTRMoreOptions, "UIPanelButtonTemplate");
  QTR_CloseBtnM:SetWidth(35);
  QTR_CloseBtnM:SetHeight(25);
  QTR_CloseBtnM:SetText("X"); 
  QTR_CloseBtnM:Show();
  QTR_CloseBtnM:ClearAllPoints();
  QTR_CloseBtnM:SetPoint("TOPRIGHT", -5, -5);
  QTR_CloseBtnM:SetScript("OnClick", function() QTROptions:Show() QTRMoreOptions:Hide() end);


  local QTRDateOfBaseM = QTRMoreOptions:CreateFontString(nil, "ARTWORK");
  QTRDateOfBaseM:SetFontObject(GameFontHighlightSmall);
  QTRDateOfBaseM:SetJustifyH("LEFT"); 
  QTRDateOfBaseM:SetJustifyV("TOP");
  QTRDateOfBaseM:ClearAllPoints();
  QTRDateOfBaseM:SetPoint("TOPLEFT", QTROptionsHeader, "TOPLEFT", 0, -50);
  QTRDateOfBaseM:SetText(string.format("Versão para WOTLK(3.3), TBC(2.4), Vanilla  (1.12.1) e \nbanco de dados feitos por Leandro, Github @leoaviana "));
  QTRDateOfBaseM:SetFont(QTR_Font2, 16);

  
local WowTranslatorOptionsOnTheFlyM = QTRMoreOptions:CreateFontString(nil, "ARTWORK");
WowTranslatorOptionsOnTheFlyM:SetFontObject(GameFontWhite);
WowTranslatorOptionsOnTheFlyM:SetJustifyH("LEFT");
WowTranslatorOptionsOnTheFlyM:SetJustifyV("TOP");
WowTranslatorOptionsOnTheFlyM:ClearAllPoints();
WowTranslatorOptionsOnTheFlyM:SetPoint("TOPLEFT", QTRDateOfBaseM, "TOPLEFT", 0, -50);
WowTranslatorOptionsOnTheFlyM:SetFont(WT_Font, 13);
WowTranslatorOptionsOnTheFlyM:SetText(WT_Interface.transl);


  local WowTranslatorCheckButton4 = CreateFrame("CheckButton", "WowTranslatorCheckButton4", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton4:SetPoint("TOPLEFT", WowTranslatorOptionsOnTheFlyM, "BOTTOMLEFT", 0, -4);
  WowTranslatorCheckButton4:SetScript("OnClick", function(self) if (QTRTTT_PS["body"]=="1") then QTRTTT_PS["body"]="0" else QTRTTT_PS["body"]="1" end; end);
  WowTranslatorCheckButton4Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton4Text:SetText(WT_Interface.body);
  
  local WowTranslatorCheckButton5 = CreateFrame("CheckButton", "WowTranslatorCheckButton5", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton5:SetPoint("TOPLEFT", WowTranslatorCheckButton4, "BOTTOMLEFT", 0, 0);
  WowTranslatorCheckButton5:SetScript("OnClick", function(self) if (QTRTTT_PS["mats"]=="1") then QTRTTT_PS["mats"]="0" else QTRTTT_PS["mats"]="1" end; end);
  WowTranslatorCheckButton5Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton5Text:SetText(WT_Interface.mats);
  
  local WowTranslatorCheckButton6 = CreateFrame("CheckButton", "WowTranslatorCheckButton6", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton6:SetPoint("TOPLEFT", WowTranslatorCheckButton5, "BOTTOMLEFT", 0, 0);
  WowTranslatorCheckButton6:SetScript("OnClick", function(self) if (QTRTTT_PS["weapon"]=="1") then QTRTTT_PS["weapon"]="0" else QTRTTT_PS["weapon"]="1" end; end);
  WowTranslatorCheckButton6Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton6Text:SetText(WT_Interface.weapon);
  
  local WowTranslatorCheckButton9 = CreateFrame("CheckButton", "WowTranslatorCheckButton9", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton9:SetPoint("TOPLEFT", WowTranslatorCheckButton6, "BOTTOMLEFT", 0, 0);
  WowTranslatorCheckButton9:SetScript("OnClick", function(self) if (QTRTTT_PS["ener"]=="1") then QTRTTT_PS["ener"]="0" else QTRTTT_PS["ener"]="1" end; end);
  WowTranslatorCheckButton9Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton9Text:SetText(WT_Interface.ener);
  
  local WowTranslatorCheckButton7 = CreateFrame("CheckButton", "WowTranslatorCheckButton7", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton7:SetPoint("TOPLEFT", WowTranslatorCheckButton9, "BOTTOMLEFT", 0, 0);
  WowTranslatorCheckButton7:SetScript("OnClick", function(self) if (QTRTTT_PS["info"]=="1") then QTRTTT_PS["info"]="0" else QTRTTT_PS["info"]="1" end; end);
  WowTranslatorCheckButton7Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton7Text:SetText(WT_Interface.info);
  
  local WowTranslatorCheckButton11 = CreateFrame("CheckButton", "WowTranslatorCheckButton11", QTRMoreOptions, "OptionsCheckButtonTemplate");
  WowTranslatorCheckButton11:SetPoint("TOPLEFT", WowTranslatorCheckButton7, "BOTTOMLEFT", 0, 0);
  WowTranslatorCheckButton11:SetScript("OnClick", function(self) if (QTRTTT_PS["isstat"]=="1") then QTRTTT_PS["isstat"]="0" else QTRTTT_PS["isstat"]="1" end; end);
  WowTranslatorCheckButton11Text:SetFont(WT_Font, 13);
  WowTranslatorCheckButton11Text:SetText(WT_Interface.stats);

  
local QTR_GoBackBtn = CreateFrame("Button",nil, QTRMoreOptions, "UIPanelButtonTemplate");
QTR_GoBackBtn:SetWidth(90);
QTR_GoBackBtn:SetHeight(25);
QTR_GoBackBtn:SetText("<- Voltar"); 
QTR_GoBackBtn:Show();
QTR_GoBackBtn:ClearAllPoints();
QTR_GoBackBtn:SetPoint("TOPLEFT", WowTranslatorCheckButton11, "BOTTOMRIGHT", 360, -215);
QTR_GoBackBtn:SetScript("OnClick", function() QTROptions:Show() QTRMoreOptions:Hide() end);


-----------------------------------------------------------------------------------------------------------------------------


local QTR_MoreOptionsBtn = CreateFrame("Button",nil, QTROptions, "UIPanelButtonTemplate");
QTR_MoreOptionsBtn:SetWidth(90);
QTR_MoreOptionsBtn:SetHeight(25);
QTR_MoreOptionsBtn:SetText("Mais Opções"); 
QTR_MoreOptionsBtn:Show();
QTR_MoreOptionsBtn:ClearAllPoints();
QTR_MoreOptionsBtn:SetPoint("TOPLEFT", WowTranslatorCheckButton8, "BOTTOMRIGHT", 350, 0);
QTR_MoreOptionsBtn:SetScript("OnClick", function() QTROptions:Hide() QTRMoreOptions:Show() end);


local QTRCommandsLBL = QTROptions:CreateFontString(nil, "ARTWORK");
QTRCommandsLBL:SetFontObject(GameFontWhite);
QTRCommandsLBL:SetJustifyH("LEFT"); 
QTRCommandsLBL:SetJustifyV("TOP");
QTRCommandsLBL:ClearAllPoints();
QTRCommandsLBL:SetPoint("TOPLEFT", WowTranslatorCheckButton8, "BOTTOMLEFT", 0, -20);
QTRCommandsLBL:SetFont(WT_Font, 12);
QTRCommandsLBL:SetText(QTR_Interface.commands);
  
end

local timer = CreateFrame("FRAME");

function Rowtr:wait(delay, func, arg1,arg2,arg3,arg4,arg5) 
   local endTime = GetTime() + delay;
	
	timer:SetScript("OnUpdate", function()
		if(endTime < GetTime()) then
			--time is up 
			func(arg1,arg2,arg3,arg4,arg5);
			timer:SetScript("OnUpdate", nil);
		end
	end);
end 

function Rowtr:ToggleQuestTranslate()
   if (curr_trans=="1") then
      curr_trans="0";
      Rowtr:Translate_Off(1);
   else   
      curr_trans="1";
      Rowtr:Translate_On(1);
   end
end 
 

function Rowtr:ToggleGossipTranslate()
   if (curr_goss=="1") then         -- wyłącz tłumaczenie - pokaż oryginalny tekst
      curr_goss="0";
      Rowtr:TranslateGossip_OFF();
   else                             -- pokaż tłumaczenie PL
      curr_goss="1";
      Rowtr:TranslateGossip_ON();
   end
end

function Rowtr:TranslateGossip_ON() 

   if(Rowtr:isImmersion()) then
      local Greeting_PL = GS_Gossip[curr_hash];
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(Rowtr:ExpandUnitInfo(Greeting_PL)); 
      QTR_ToggleButtonGS4:SetText("Gossip-Hash=["..tostring(curr_hash).."] "..GS_lang);  
      
      local titleButton;
         for i = 1, ImmersionFrame.TitleButtons:GetNumActive(), 1 do 
            titleButton=ImmersionFrame.TitleButtons:GetButton(i);
            if (titleButton:GetText()) then
               Hash = StringHash(titleButton:GetText());
               if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu dodatkowego
                  QTR_GS_MENUS[i] = titleButton:GetText(); -- gets original text from button
                  local fontf, fontsz = titleButton:GetFontString():GetFont();
                  titleButton:SetText(Rowtr:ExpandUnitInfo(GS_Gossip[Hash]));
                  titleButton:GetFontString():SetFont(fontf, fontsz); 
               end
            end
         end 
   else
      local Greeting_PL = GS_Gossip[curr_hash]; 
      GreetingText:SetText(Rowtr:ExpandUnitInfo(Greeting_PL));  
      GossipGreetingText:SetText(Rowtr:ExpandUnitInfo(Greeting_PL));   
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] "..GS_lang); 

      if (Rowtr:GetNumGossipOptions()>0) then    -- są jeszcze przyciski funkcji dodatkowych
         local pozycja=GetNumGossipActiveQuests()+GetNumGossipAvailableQuests()+1;
         local titleButton; 
         for i = 1, Rowtr:GetNumGossipOptions(), 1 do 
            titleButton=getglobal("GossipTitleButton"..tostring(pozycja+i)); 
            if (titleButton:GetText()) then
               Hash = StringHash(titleButton:GetText());
               if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu dodatkowego
                  QTR_GS_MENUS[i] = titleButton:GetText(); -- gets original text from button 
                  titleButton:SetText(Rowtr:ExpandUnitInfo(GS_Gossip[Hash]));
                  titleButton:GetFontString():SetFont(QTR_Font2, 13); 
               end
            end
         end
      end
   end
end

function Rowtr:TranslateGossip_OFF()   
   if(Rowtr:isImmersion()) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_GS[curr_hash]);    
      QTR_ToggleButtonGS4:SetText("Gossip-Hash=["..tostring(curr_hash).."] EN");  

         local titleButton; 
         for i = 1, ImmersionFrame.TitleButtons:GetNumActive(), 1 do 
            titleButton=ImmersionFrame.TitleButtons:GetButton(i);
            if (titleButton:GetText()) then  
               if ( QTR_GS_MENUS[i] ) then   -- istnieje tłumaczenie tekstu dodatkowego 
                  local fontf, fontsz = titleButton:GetFontString():GetFont();
                  titleButton:SetText(QTR_GS_MENUS[i]);
                  titleButton:GetFontString():SetFont(fontf, fontsz); 
               end
            end
         end
         QTR_GS_MENUS = {}; -- clear the array 
   else 
      GreetingText:SetText(QTR_GS[curr_hash]);  
      GossipGreetingText:SetText(QTR_GS[curr_hash]);   
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] EN"); 

      if (Rowtr:GetNumGossipOptions()>0) then    -- są jeszcze przyciski funkcji dodatkowych
         local pozycja=GetNumGossipActiveQuests()+GetNumGossipAvailableQuests()+1;
         local titleButton; 
         for i = 1, Rowtr:GetNumGossipOptions(), 1 do 
            titleButton=getglobal("GossipTitleButton"..tostring(pozycja+i)); 
            if (titleButton:GetText()) then  
               if ( QTR_GS_MENUS[i] ) then   -- istnieje tłumaczenie tekstu dodatkowego 
                  titleButton:SetText(QTR_GS_MENUS[i]);
                  titleButton:GetFontString():SetFont(QTR_Font2, 13); 
               end
            end
         end
         QTR_GS_MENUS = {}; -- clear the array
      end
   end
end


function Rowtr:LoadUIElements() 

   -- przycisk z nr ID questu w QuestFrame (NPC)
   QTR_ToggleButton0 = CreateFrame("Button",nil, QuestFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton0:SetWidth(150);
   QTR_ToggleButton0:SetHeight(20);
   QTR_ToggleButton0:SetText("Quest ID=?");
   QTR_ToggleButton0:Show();
   QTR_ToggleButton0:ClearAllPoints();
   QTR_ToggleButton0:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 115, -50);
   QTR_ToggleButton0:SetScript("OnClick", Rowtr.ToggleQuestTranslate);
   
   -- przycisk z nr ID questu w QuestFrameProgressPanel
   QTR_ToggleButton1 = CreateFrame("Button",nil, QuestLogFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton1:SetWidth(150);
   QTR_ToggleButton1:SetHeight(18);
   QTR_ToggleButton1:SetText("Quest ID=?");
   QTR_ToggleButton1:Show();
   QTR_ToggleButton1:ClearAllPoints();
   QTR_ToggleButton1:GetFontString():SetPoint("CENTER", 0, 1);
   QTR_ToggleButton1:SetPoint("TOPLEFT", QuestLogFrame, "TOPLEFT", 178, -42);
   QTR_ToggleButton1:SetScript("OnClick", Rowtr.ToggleQuestTranslate); 

   -- QuestLogDetailFrame
   QTR_ToggleButton2 = CreateFrame("Button",nil, QuestLogDetailFrame, "UIPanelButtonTemplate");
   QTR_ToggleButton2:SetWidth(135);
   QTR_ToggleButton2:SetHeight(20);
   QTR_ToggleButton2:SetText("Quest ID=?");
   if(Rowtr.target > 2) then 
      QTR_ToggleButton2:Show();
   else
      QTR_ToggleButton2:Hide();
   end
   QTR_ToggleButton2:ClearAllPoints();
   QTR_ToggleButton2:SetPoint("TOPLEFT", QuestLogDetailFrame, "TOPLEFT", 70, -45);
   QTR_ToggleButton2:SetScript("OnClick", Rowtr.ToggleQuestTranslate);

   QTR_ToggleButtonWM = CreateFrame("Button",nil, WorldMapQuestDetailScrollFrame, "UIPanelButtonTemplate");
   QTR_ToggleButtonWM:SetWidth(135);
   QTR_ToggleButtonWM:SetHeight(17);
   QTR_ToggleButtonWM:SetText("Quest ID=?"); 
   if(Rowtr.target > 2) then 
      QTR_ToggleButtonWM:Show();
   else
      QTR_ToggleButtonWM:Hide();
   end 
   QTR_ToggleButtonWM:ClearAllPoints();
   QTR_ToggleButtonWM:SetPoint("BOTTOMRIGHT", WorldMapQuestDetailScrollFrame, "BOTTOMRIGHT", 0, -21);
   QTR_ToggleButtonWM:SetScript("OnClick", Rowtr.ToggleQuestTranslate);

 

   -- przycisk z nr HASH gossip w QuestMapDetailsScrollFrame 

   QTR_ToggleButtonGS = CreateFrame("Button",nil, GossipFrameGreetingPanel, "UIPanelButtonTemplate");
   QTR_ToggleButtonGS:SetWidth(220);
   QTR_ToggleButtonGS:SetHeight(20);
   QTR_ToggleButtonGS:SetText("Gossip-Hash=?");
   QTR_ToggleButtonGS:Show(); 
   QTR_ToggleButtonGS:ClearAllPoints();
   QTR_ToggleButtonGS:SetPoint("TOPLEFT", GossipFrameGreetingPanel, "TOPLEFT", 90, -50);
   QTR_ToggleButtonGS:SetScript("OnClick", Rowtr.ToggleGossipTranslate);

   -- funkcja wywoływana po kliknięciu na nazwę questu w QuestLog

   if(Rowtr.target > 1) then 
      QuestLogDetailScrollFrame:HookScript( "OnShow", Rowtr.Prepare1sek);
      EmptyQuestLogFrame:HookScript("OnShow", Rowtr.EmptyQuestLog); 
      hooksecurefunc("SelectQuestLogEntry", Rowtr.Prepare1sek);
      if(Rowtr.target > 2) then
         hooksecurefunc("WorldMapFrame_SelectQuestFrame", Rowtr.SelectedMapQuest); -- needed for worldmapquest handling
      end 
   else  
      c_HookScript(QuestLogDetailScrollFrame, "OnShow", Rowtr.Prepare1sek);
      c_HookScript(EmptyQuestLogFrame,"OnShow", Rowtr.EmptyQuestLog); 
      c_hooksecurefunc("SelectQuestLogEntry", Rowtr.Prepare1sek);
   end


   Rowtr:isQuestGuru();
   Rowtr:isImmersion();
   Rowtr:isStoryline();
end

function Rowtr:SetupGSButton(isQuestGreeting) 
   if(isQuestGreeting == true) then 
      QTR_ToggleButtonGS:SetParent(QuestFrame);
      QTR_ToggleButtonGS:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 90, -50);  
   else
      QTR_ToggleButtonGS:SetParent(GossipFrameGreetingPanel); 
      QTR_ToggleButtonGS:SetPoint("TOPLEFT", GossipFrameGreetingPanel, "TOPLEFT", 90, -50); 
   end
end

function Rowtr:SelectedMapQuest(questFrame) 
   Rowtr:QuestPrepare("WORLDMAP_SELECTED_QUEST");
end   

function Rowtr:splitstr (str, inSplitPattern, outResults )
   if not outResults then
     outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( str, inSplitPattern, theStart )
   while theSplitStart do
     table.insert( outResults, string.sub( str, theStart, theSplitStart-1 ) )
     theStart = theSplitEnd + 1
     theSplitStart, theSplitEnd = string.find( str, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( str, theStart ) )
   return outResults
end
 

function Rowtr:IsQuestAvailableForPlayerRace(questId)
   if(QuestTranslator_QuestRaceList[questId]) then
      local bs = QuestTranslator_QuestRaceList[questId];
      local playerRace, playerRaceEn = UnitRace("player");

      if(bs == "0" or bs == "1791") then
         return true; -- the quest is available for all races...
      end  

      if(QuestTranslator_PlayerRaceList[tostring(playerRaceEn)]) then
         local qtr_raceInfo =  Rowtr:splitstr(QuestTranslator_PlayerRaceList[tostring(playerRaceEn)], ","); 
         local raceId = qtr_raceInfo[1];
         local IsHorde = qtr_raceInfo[2]; 

         if(bs == raceId) then
            return true;
         end

         if(bs == "690") then  -- 690 means the quest is available for all horde races
            if(IsHorde == "true") then
               return true;
            end
         end  
         
         if(bs == "1101") then -- 1101 means the quest is available for all alliance races
            if(IsHorde == "false") then
               return true;
            end
         end
      end

   end

   return false;
      
end

function Rowtr:isQuestFromTargetNPC(questId, targetNPC) 
   if (QuestTranslator_QuestGiverList[tostring(targetNPC)]) then
      local q_lists=QuestTranslator_QuestGiverList[tostring(targetNPC)];
      q_i=string.find(q_lists, ",");
      if ( string.find(q_lists, ",")==nil ) then
         -- only 1 questID to this npcID
         quest_ID=tonumber(q_lists);
         if(tonumber(questId) == quest_ID) then
            return true;
         else
            return false;
         end
      else
         local QTR_table=Rowtr:splitqinfo(q_lists, ",", -1);
         for ii,vv in ipairs(QTR_table) do
            if(tonumber(vv) == tonumber(questId)) then
               return true;
            end
         end
      end 
   end
   return false;
end

function Rowtr:splitqinfo(str, c, t) 
   local aCount = 0;
   local array = {};
   local a = string.find(str, c);
   while a do
      if(t == -1) then
         if(Rowtr:IsQuestAvailableForPlayerRace(string.sub(str, 1, a-1))) then 
            aCount = aCount + 1;
            array[aCount] = string.sub(str, 1, a-1); 
         end
      else
         if(Rowtr:isQuestFromTargetNPC(string.sub(str, 1, a-1), t)) then
            if(Rowtr:IsQuestAvailableForPlayerRace(string.sub(str, 1, a-1))) then 
                  aCount = aCount + 1;
                  array[aCount] = string.sub(str, 1, a-1); 
            end
         end
      end 

      str=string.sub(str, a+1);
      a = string.find(str, c);
   end

   if(t == -1) then
      if(Rowtr:IsQuestAvailableForPlayerRace(str)) then 
         aCount = aCount + 1;
         array[aCount] = str; 
      end
   else
      if(Rowtr:isQuestFromTargetNPC(str, t)) then
         if(Rowtr:IsQuestAvailableForPlayerRace(str)) then 
               aCount = aCount + 1;
               array[aCount] = str; 
         end
      end
   end

   return array;
 end
 
function Rowtr:isQuestGuru() 
   if (QuestGuru ~= nil ) then
      if (QTR_ToggleButton3==nil) then
         -- przycisk z nr ID questu w QuestGuru
         QTR_ToggleButton3 = CreateFrame("Button",nil, QuestGuru, "UIPanelButtonTemplate");
         QTR_ToggleButton3:SetWidth(150);
         QTR_ToggleButton3:SetHeight(20);
         QTR_ToggleButton3:SetText("Quest ID=?");
         QTR_ToggleButton3:Show();
         QTR_ToggleButton3:ClearAllPoints();
         QTR_ToggleButton3:SetPoint("TOPLEFT", QuestGuru, "TOPLEFT", 330, -33);
         QTR_ToggleButton3:SetScript("OnClick", Rowtr.ToggleQuestTranslate);
         -- uaktualniono dane w QuestLogu
         if(Rowtr.target > 1) then
            QuestGuru:HookScript("OnUpdate", function() Rowtr:PrepareReload() end);
         else
            c_HookScript(QuestGuru, "OnUpdate", function() Rowtr:PrepareReload() end);
         end

      end
      return true;
   else
      return false;   
   end
end


function Rowtr:isImmersion() 
   if (ImmersionFrame ~= nil ) then
      if (QTR_ToggleButton4==nil and QTR_ToggleButtonGS4 == nil) then
         -- przycisk z nr ID questu
         QTR_ToggleButton4 = CreateFrame("Button",nil, ImmersionFrame.TalkBox, "UIPanelButtonTemplate");
         QTR_ToggleButton4:SetWidth(150);
         QTR_ToggleButton4:SetHeight(20);
         QTR_ToggleButton4:SetText("Quest ID=?");
         QTR_ToggleButton4:Show();
         QTR_ToggleButton4:ClearAllPoints();
         QTR_ToggleButton4:SetPoint("TOPLEFT", ImmersionFrame.TalkBox, "TOPRIGHT", -200, -116);
         QTR_ToggleButton4:SetScript("OnClick", Rowtr.ToggleQuestTranslate);
         -- otworzono okno dodatku Immersion : wywołanie przez OnEvent
         if(Rowtr.target > 1) then
            ImmersionFrame.TalkBox:HookScript("OnHide",function() QTR_ToggleButton4:Hide(); end);
         else 
            c_HookScript(ImmersionFrame.TalkBox, "OnHide",function() QTR_ToggleButton4:Hide(); end);
         end

         QTR_ToggleButton4:Disable();     -- nie można na razie przyciskać
         QTR_ToggleButton4:Hide();        -- wstępnie przycisk niewidoczny (bo może jest wybór questów)

         QTR_ToggleButtonGS4 = CreateFrame("Button",nil, ImmersionFrame.TalkBox, "UIPanelButtonTemplate");
         QTR_ToggleButtonGS4:SetWidth(220);
         QTR_ToggleButtonGS4:SetHeight(20);
         QTR_ToggleButtonGS4:SetText("Quest ID=?");
         QTR_ToggleButtonGS4:Show();
         QTR_ToggleButtonGS4:ClearAllPoints();
         QTR_ToggleButtonGS4:SetPoint("TOPLEFT", ImmersionFrame.TalkBox, "TOPRIGHT", -270, -116);
         QTR_ToggleButtonGS4:SetScript("OnClick", Rowtr.ToggleGossipTranslate);
         -- otworzono okno dodatku Immersion : wywołanie przez OnEvent
         if(Rowtr.target > 1) then
            ImmersionFrame.TalkBox:HookScript("OnHide",function() QTR_ToggleButtonGS4:Hide(); end);
         else
            c_HookScript(ImmersionFrame.TalkBox,"OnHide",function() QTR_ToggleButtonGS4:Hide(); end);
         end

         QTR_ToggleButtonGS4:Disable();     -- nie można na razie przyciskać
         QTR_ToggleButtonGS4:Hide();        -- wstępnie przycisk niewidoczny (bo może jest wybór questów)
      end
      return true;
   else   
      return false;
   end
end
   

function Rowtr:isStoryline() 
if (Storyline_NPCFrame ~= nil ) then
      if (QTR_ToggleButton5==nil) then
         -- przycisk z nr ID questu
         QTR_ToggleButton5 = CreateFrame("Button",nil, Storyline_NPCFrameChat, "UIPanelButtonTemplate");
         QTR_ToggleButton5:SetWidth(150);
         QTR_ToggleButton5:SetHeight(20);
         QTR_ToggleButton5:SetText("Quest ID=?");
         QTR_ToggleButton5:Hide();
         QTR_ToggleButton5:ClearAllPoints();
         QTR_ToggleButton5:SetPoint("BOTTOMLEFT", Storyline_NPCFrameChat, "BOTTOMLEFT", 244, -16);
         QTR_ToggleButton5:SetScript("OnClick", Rowtr.ToggleQuestTranslate);
         if(Rowtr.target > 1) then
            Storyline_NPCFrameObjectivesContent:HookScript("OnShow", function() Rowtr:Storyline_Objectives() end);
            Storyline_NPCFrameRewards:HookScript("OnShow", function() Rowtr:Storyline_Rewards() end);
            Storyline_NPCFrameChat:HookScript("OnHide", function() Rowtr:Storyline_Hide() end);
         else
            c_HookScript(Storyline_NPCFrameObjectivesContent,"OnShow", function() Rowtr:Storyline_Objectives() end);
            c_HookScript(Storyline_NPCFrameRewards,"OnShow", function() Rowtr:Storyline_Rewards() end);
            c_HookScript(Storyline_NPCFrameChat,"OnHide", function() Rowtr:Storyline_Hide() end); 
         end
--         QTR_ToggleButton5:Disable();     -- nie można przyciskać
      end 
      return true;
   else
      return false;
   end
end

function Rowtr:GetQuestID(titleText) 

   local q_title = GetTitleText();  
   local q_i = 1;
   quest_ID = 0; 

   if(titleText) then
      q_title = titleText
   end 
   
   if ( quest_ID==0 or quest_ID==nil) then
      -- search in QuestLog 
      if(Rowtr.target > 2) then
         while GetQuestLogTitle(q_i) do
            local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(q_i)
            if ( not isHeader ) then
               if ( q_title == questTitle ) then 
                  quest_ID=questID;
                  break;
               end
             end
            q_i = q_i + 1;
         end
      else
         local index = 1  
         while GetQuestLogTitle(index) do
            local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(index)
            if ( not isHeader ) then 
               if ( q_title == questTitle ) then 
                  return Rowtr:GetQuestIDFromQuestLog(q_title, index, QTR_name, QTR_race, QTR_class) 
               end
             end
            index = index + 1;
         end
      end
   end

   
   if ( q_title == nil or q_title == "") then 
      q_title = GetQuestLogTitle(GetQuestLogSelection()) 
   end

   if ( quest_ID == 0 or quest_ID==nil) then
      if ( isGetQuestID=="1" ) then
         quest_ID = GetQuestID();
      end
      if ( quest_ID == 0 ) then
         if (QuestTranslator_QuestList[q_title]) then
            local q_lists=QuestTranslator_QuestList[q_title];
            q_i=string.find(q_lists, ","); 
            if ( string.find(q_lists, ",")==nil ) then
               -- only 1 questID to this title
               quest_ID=tonumber(q_lists); 
            else
               -- multiple questIDs - get first, available (not completed) questID from QuestLists and which the NPC is in the target from QuestGiverList
               
               -- get target NPC id 
                  local targetNPC = 0;

                  if(UnitName("target") == nil or UnitName("target") == "") then
                     targetNPC = -1;
                  else
                     targetNPC = UnitName('target')
                  end 

                  local QTR_table=Rowtr:splitqinfo(q_lists, ",", targetNPC);
               
                  if(QTR_table == nil) then
                     return 0;
                  end

                  local QTR_multiple = "";
                  local QTR_Center=""; 

                  for ii,vv in ipairs(QTR_table) do 
                     if (QuestTranslator_QuestMatch[tonumber(vv)]) then
                        local origQuestText = GetQuestText();
                        if (origQuestText == "" or origQuestText == nil) then origQuestText = GetQuestLogQuestText() end
                        local questTxtMatch = QuestTranslator_QuestMatch[tonumber(vv)]; 
                        questTxtMatch = string.gsub(questTxtMatch, '$N$', string.upper(QTR_name));
                        questTxtMatch = string.gsub(questTxtMatch, '$N', QTR_name);
                        questTxtMatch = string.gsub(questTxtMatch, '$B', '\n');
                        questTxtMatch = string.gsub(questTxtMatch, '$R', QTR_race);
                        questTxtMatch = string.gsub(questTxtMatch, '$C', QTR_class); 
                        questTxtMatch = string.gsub(questTxtMatch, '$b$', string.upper(QTR_name));
                        questTxtMatch = string.gsub(questTxtMatch, '$n', QTR_name);
                        questTxtMatch = string.gsub(questTxtMatch, '$b', '\n');
                        questTxtMatch = string.gsub(questTxtMatch, '$r', QTR_race);
                        questTxtMatch = string.gsub(questTxtMatch, '$c', QTR_class); 
                      
                        if(string.find(origQuestText, questTxtMatch)) then 
                           if (QTR_Center=="") then
                               QTR_Center=vv;
                           else
                               QTR_multiple = QTR_multiple .. ", " .. vv;
                           end 
                        end
                     end 
                  end
                  if ( string.len(QTR_Center)>0 ) then
                     quest_ID=tonumber(QTR_Center);
                     if ( string.len(QTR_multiple)>0 ) then 
                        QTR_multiple = " (" .. string.sub(QTR_multiple, 3) .. ")";
                        -- Essa quest possui duplicatas, sua tradução pode estar incorreta, porem, é garantida a seleção correta da quest no banco
                        -- de dados utilizando o QuestLog (L) (WOTLK apenas.)
                     end
                  end
               end
            end
         end
      end 
   return (quest_ID);
end  

function Rowtr:GameTooltipHooks()
   if(Rowtr.target > 2) then
      GameTooltip:HookScript("OnShow", Rowtr.ToolTipTranslator_ShowTranslationG);
      GameTooltip:HookScript("OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues); 

      --ItemRefTooltip:HookScript("OnShow", QTRToolTipTranslator_ShowTranslationR);
      ItemRefTooltip:HookScript("OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues);
      hooksecurefunc("SetItemRef", Rowtr.ToolTipTranslator_ShowTranslationR)

      if(AtlasLootTooltip) then
         AtlasLootTooltip:HookScript("OnShow", Rowtr.ToolTipTranslator_ShowTranslationA);
         AtlasLootTooltip:HookScript("OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues); 
      end

      for i = 1, 2, 1 do -- i think max 2 of those are shown
         if _G["ShoppingTooltip"..i] then
            _G["ShoppingTooltip"..i]:HookScript("OnShow", function() Rowtr:ToolTipTranslator_ShowTranslationS(i) end);
            _G["ShoppingTooltip"..i]:HookScript("OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues);
         end
      end  
   else
      c_HookScript(GameTooltip,"OnShow", Rowtr.ToolTipTranslator_ShowTranslationG);
      c_HookScript(GameTooltip,"OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues); 

      --ItemRefTooltip:HookScript("OnShow", QTRToolTipTranslator_ShowTranslationR);
      c_HookScript(ItemRefTooltip, "OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues);
      if(Rowtr.target < 2) then
         c_hooksecurefunc("SetItemRef", Rowtr.ToolTipTranslator_ShowTranslationR)
      else
         hooksecurefunc("SetItemRef", Rowtr.ToolTipTranslator_ShowTranslationR)
      end


      if(AtlasLootTooltip) then
         c_HookScript(AtlasLootTooltip,"OnShow", Rowtr.ToolTipTranslator_ShowTranslationA);
         c_HookScript(AtlasLootTooltip,"OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues); 
      end

      for i = 1, 2, 1 do -- i think max 2 of those are shown
         if _G["ShoppingTooltip"..i] then
            c_HookScript(_G["ShoppingTooltip"..i],"OnShow", function() Rowtr:ToolTipTranslator_ShowTranslationS(i) end);
            c_HookScript(_G["ShoppingTooltip"..i],"OnHide", Rowtr.ToolTipTranslator_ResetChangedTooltipValues);
         end
      end
   end
end


function Rowtr:SendChatAd(qName) 
   local now = GetTime(); 
   if (last_time + QTR_PS["period"]*60 < now) then  -- OK, czas wypisać reklamę
      if(qName) then
         if (tonumber(QTR_PS["channel"])>0) then
            SendChatMessage(string.gsub(QTR_Reklama.TEXT1, '%%s', qName),"CHANNEL",nil,tonumber(QTR_PS["channel"]));
         else
            SendChatMessage(string.gsub(QTR_Reklama.TEXT1, '%%s', qName),"SAY");
         end
         last_text = 1;
      else
         if (tonumber(QTR_PS["channel"])>0) then
            SendChatMessage(QTR_Reklama.TEXT2,"CHANNEL",nil,tonumber(QTR_PS["channel"]));
         else
            SendChatMessage(QTR_Reklama.TEXT2,"SAY");
         end
         last_text = 2;
      end   
   last_time = now;
   elseif(last_text == 0) then
      if(qName) then
         if (tonumber(QTR_PS["channel"])>0) then
            SendChatMessage(string.gsub(QTR_Reklama.TEXT1, '%%s', qName),"CHANNEL",nil,tonumber(QTR_PS["channel"]));
         else
            SendChatMessage(string.gsub(QTR_Reklama.TEXT1, '%%s', qName),"SAY");
         end
         last_text = 1;
      end
   end   
 end

-- Wywoływane przy przechwytywanych zdarzeniach
function Rowtr:OnEvent(self, event, name, arg1,arg2,arg3,arg4,arg5)  
   if (QTR_onDebug) then
      print('OnEvent-event: '..event);   
   end   
   if (event=="ADDON_LOADED" and arg1=="Rowtr") then 

      Rowtr:GameTooltipHooks();
      Rowtr:CheckVars();
      Rowtr:LoadUIElements();

      SlashCmdList["WOWPOPOLSKU_QUESTS"] = function(msg) Rowtr:SlashCommand(msg); end
      SLASH_WOWPOPOLSKU_QUESTS1 = "/Rowtr";
      SLASH_WOWPOPOLSKU_QUESTS2 = "/qtr";
      
      Rowtr:LoadOptionsFrame();
      -- twórz interface Options w Blizzard-Interface-Addons 
      print ("|cffffff00Rowtr ver. "..QTR_version.." - "..QTR_Messages.loaded);
      Rowtr:UnregisterEvent("ADDON_LOADED");
      Rowtr.ADDON_LOADED = nil; 
      
      if(QTR_PS["enablegoss"]=="1") then
         QTR_ToggleButtonGS:Show();
      else
         QTR_ToggleButtonGS:Hide();
      end 

   elseif (event=="QUEST_DETAIL" or event=="QUEST_PROGRESS" or event=="QUEST_COMPLETE") then   
      QTR_ToggleButtonGS:Hide();
      QTR_ToggleButton0:Show();
      if ( QuestFrame:IsVisible() or Rowtr:isImmersion()) then 
         Rowtr:wait(0.1, Rowtr.QuestPrepare, self, event); 
      elseif (Rowtr:isStoryline()) then
         if (not Rowtr:wait(1,Rowtr.Storyline_Quest)) then
         -- opóźnienie 1 sek
         end
      end	-- QuestFrame is Visible 
   elseif (event=="GOSSIP_SHOW" or event=="QUEST_GREETING") then   
      QTR_ToggleButtonGS:Show();
      QTR_ToggleButton0:Hide();
      if(QTR_PS["enablegoss"]=="1") then
         Rowtr:Gossip_Show();
      end
   elseif (Rowtr:isImmersion() and event=="QUEST_LOG_UPDATE") then
      Rowtr:delayed3();
   elseif (event=="QUEST_LOG_UPDATE") then
     if(Rowtr.target < 2) then
        Rowtr:CheckQuestLog();
     end
   elseif (event=="QUEST_ACCEPTED") then
      if(Rowtr.target > 1) then
         SelectQuestLogEntry(arg1); 
         local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(GetQuestLogSelection()); 

         if(not (questID == 0)) then  
            if (QTR_PS["reklama"]=="1") then
               Rowtr:SendChatAd(questTitle);
            end 
         else
            if (QTR_PS["reklama"]=="1") then
               Rowtr:SendChatAd(nil);
            end
         end
      end 
   end  
end

function Rowtr:UpdateGameClientCache()  
   local id = 1; 
   QTR_QuestCache = {} 
   local qc = 0; 
   local nEntry, nQuests = GetNumQuestLogEntries();
   while qc < nQuests do
      local questName, level, _, isHeader, isCollapsed, _ = GetQuestLogTitle(id);
      if not isHeader and not isCollapsed then
         SelectQuestLogEntry(id);
         local questText, objectiveText = GetQuestLogQuestText();
         local hash = StringHash(questName..level..objectiveText); 

         QTR_QuestCache[hash] = questName; 
      end
        if not isHeader then
            qc = qc + 1;
        end
        id = id + 1;
   end   
end
 
function Rowtr:CheckQuestLog()
   local function map_length(t)
      local c = 0
      for k, v in pairs(t) do
           c = c + 1
      end
      return c
   end

   if(not QTR_QuestCache) then
      QTR_QuestCache = {} 
      Rowtr:UpdateGameClientCache();
      QTR_OldQuestCache = QTR_QuestCache;
   else
      Rowtr:UpdateGameClientCache(); 
      if(map_length(QTR_QuestCache) > map_length(QTR_OldQuestCache)) then
         for k,v in pairs(QTR_QuestCache) do 
            if(not QTR_OldQuestCache[k]) then
               if (QTR_PS["reklama"]=="1") then
                  Rowtr:SendChatAd(QTR_QuestCache[k]);
               end
            end
         end
      end 

      QTR_OldQuestCache = QTR_QuestCache;
   end
end

function Rowtr:GetQuestData(ID, FIELD)
   return QTR_QuestData[ID][FIELD]; 
end



function Rowtr:Immersion_GOSSIP()
   local Greeting_Text = ImmersionFrame.TalkBox.TextFrame.Text.storedText;
   Nazwa_NPC = GetUnitName('npc'); 

   if (string.find(Greeting_Text," ")==nil) then         -- nie jest to tekst po polsku (nie ma twardej spacji)
      Nazwa_NPC = string.gsub(Nazwa_NPC, '"', '\"');
      Greeting_Text = string.gsub(Greeting_Text, '"', '\"');
      local Czysty_Text = string.gsub(Greeting_Text, '\r', '');
      Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
      Czysty_Text = string.gsub(Czysty_Text, QTR_name, '$N');
      Czysty_Text = string.gsub(Czysty_Text, string.upper(QTR_name), '$N$');
      Czysty_Text = string.gsub(Czysty_Text, QTR_race, '$R');
      Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_race), '$R');
      Czysty_Text = string.gsub(Czysty_Text, QTR_class, '$C');
      Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_class), '$C');
      Czysty_Text = string.gsub(Czysty_Text, '$N$', '');
      Czysty_Text = string.gsub(Czysty_Text, '$N', '');
      Czysty_Text = string.gsub(Czysty_Text, '$B', '');
      Czysty_Text = string.gsub(Czysty_Text, '$R', '');
      Czysty_Text = string.gsub(Czysty_Text, '$C', ''); 
      local Hash = StringHash(Czysty_Text); 
      curr_hash = Hash;
      QTR_GS[Hash] = Greeting_Text;                      -- zapis oryginalnego tekstu
      if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu GOSSIP tego NPC
         curr_goss = "1";
         local Greeting_PL = GS_Gossip[Hash];  
         ImmersionFrame.TalkBox.TextFrame.Text:SetText(Rowtr:ExpandUnitInfo(Greeting_PL)); 
         QTR_ToggleButtonGS4:SetText("Gossip-Hash=["..tostring(Hash).."] "..GS_lang);
         QTR_ToggleButtonGS4:Enable();
         QTR_ToggleButtonGS4:Show();
         QTR_ToggleButton4:Hide(); 
      else                               -- nie ma tłumaczenia w bazie GOSSIP
         curr_goss = "0"; 
         QTR_ToggleButtonGS4:SetText("Gossip-Hash=["..tostring(Hash).."] "..GS_lang);
         QTR_ToggleButtonGS4:Disable();
         QTR_ToggleButtonGS4:Show();
         QTR_ToggleButton4:Hide(); 
      end

      local titleButton; 
      for i = 1, ImmersionFrame.TitleButtons:GetNumActive(), 1 do 
         titleButton=ImmersionFrame.TitleButtons:GetButton(i);
         if (titleButton:GetText()) then 
            Hash = StringHash(titleButton:GetText());
            if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu dodatkowego
               QTR_GS_MENUS[i] = titleButton:GetText(); -- gets and saves original text from button
               local fontf, fontsz = titleButton:GetFontString():GetFont();
               titleButton:SetText(Rowtr:ExpandUnitInfo(GS_Gossip[Hash]));
               titleButton:GetFontString():SetFont(fontf, fontsz);
            end
         end
      end
   end
end


-- Otworzono okienko rozmowy z NPC
function Rowtr:Gossip_Show()
   QTR_GS_MENUS = {}; -- clear the menu array 

   if(Rowtr:isImmersion()) then
      Rowtr:wait(0.1, Rowtr.Immersion_GOSSIP); -- need to wait ImmersionFrame things load.
      return;
   end

   local Nazwa_NPC = GossipFrameNpcNameText:GetText();   
   
   if(Nazwa_NPC ~= GetUnitName('npc')) then
      Nazwa_NPC = nil; 
   end

   curr_hash = 0;
   if (Nazwa_NPC) then
      Rowtr:SetupGSButton(false);
      local Greeting_Text = GossipGreetingText:GetText(); 
      if (string.find(Greeting_Text," ")==nil) then         -- nie jest to tekst po polsku (nie ma twardej spacji)
         Nazwa_NPC = string.gsub(Nazwa_NPC, '"', '\"');
         Greeting_Text = string.gsub(Greeting_Text, '"', '\"');
         local Czysty_Text = string.gsub(Greeting_Text, '\r', '');
         Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
         Czysty_Text = string.gsub(Czysty_Text, QTR_name, '$N');
         Czysty_Text = string.gsub(Czysty_Text, string.upper(QTR_name), '$N$');
         Czysty_Text = string.gsub(Czysty_Text, QTR_race, '$R');
         Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_race), '$R');
         Czysty_Text = string.gsub(Czysty_Text, QTR_class, '$C');
         Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_class), '$C');
         Czysty_Text = string.gsub(Czysty_Text, '$N$', '');
         Czysty_Text = string.gsub(Czysty_Text, '$N', '');
         Czysty_Text = string.gsub(Czysty_Text, '$B', '');
         Czysty_Text = string.gsub(Czysty_Text, '$R', '');
         Czysty_Text = string.gsub(Czysty_Text, '$C', ''); 
         local Hash = StringHash(Czysty_Text); 
         curr_hash = Hash;
         QTR_GS[Hash] = Greeting_Text;                      -- zapis oryginalnego tekstu
         if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu GOSSIP tego NPC
            curr_goss = "1";
            local Greeting_PL = GS_Gossip[Hash];
            GossipGreetingText:SetText(Rowtr:ExpandUnitInfo(Greeting_PL)); 
            QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] "..GS_lang);
            QTR_ToggleButtonGS:Enable(); 
            QTR_ToggleButtonGS:Show()
         else                               -- nie ma tłumaczenia w bazie GOSSIP
            curr_goss = "0";
            QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] EN");
            QTR_ToggleButtonGS:Disable(); 
            QTR_ToggleButtonGS:Show()
         end
         if (Rowtr:GetNumGossipOptions()>0) then    -- są jeszcze przyciski funkcji dodatkowych 
            local pozycja=Rowtr:GetNumGossipActiveQuests()+Rowtr:GetNumGossipAvailableQuests();
            if pozycja > 0 then pozycja = pozycja+1 end
            local titleButton;
            for i = 1, Rowtr:GetNumGossipOptions(), 1 do 
               titleButton=getglobal("GossipTitleButton"..tostring(pozycja+i));
               if (titleButton:GetText()) then 
                  Hash = StringHash(titleButton:GetText());
                  if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu dodatkowego
                     QTR_GS_MENUS[i] = titleButton:GetText(); -- gets and saves original text from button
                     titleButton:SetText(Rowtr:ExpandUnitInfo(GS_Gossip[Hash]));
                     titleButton:GetFontString():SetFont(QTR_Font2, 13); 
                  end
               end
            end
         end
      end
   elseif (GetGreetingText() ~= nil or GetGreetingText() ~= "" and Nazwa_NPC ~= (GetUnitName('npc')) ) then  
         Rowtr:SetupGSButton(true);
         QTR_ToggleButton0:Hide(); -- hide translate quest button 
         local Greeting_Text = GetGreetingText(); 
         Nazwa_NPC = GetUnitName('npc');

         if(Nazwa_NPC == nil) then return end
   
         if (string.find(Greeting_Text," ")==nil) then         -- nie jest to tekst po polsku (nie ma twardej spacji)
            Nazwa_NPC = string.gsub(Nazwa_NPC, '"', '\"');
            Greeting_Text = string.gsub(Greeting_Text, '"', '\"');
            local Czysty_Text = string.gsub(Greeting_Text, '\r', '');
            Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
            Czysty_Text = string.gsub(Czysty_Text, QTR_name, '$N');
            Czysty_Text = string.gsub(Czysty_Text, string.upper(QTR_name), '$N$');
            Czysty_Text = string.gsub(Czysty_Text, QTR_race, '$R');
            Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_race), '$R');
            Czysty_Text = string.gsub(Czysty_Text, QTR_class, '$C');
            Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_class), '$C');
            Czysty_Text = string.gsub(Czysty_Text, '$N$', '');
            Czysty_Text = string.gsub(Czysty_Text, '$N', '');
            Czysty_Text = string.gsub(Czysty_Text, '$B', '');
            Czysty_Text = string.gsub(Czysty_Text, '$R', '');
            Czysty_Text = string.gsub(Czysty_Text, '$C', ''); 
            local Hash = StringHash(Czysty_Text); 
            curr_hash = Hash;
            QTR_GS[Hash] = Greeting_Text;                      -- zapis oryginalnego tekstu
            if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu GOSSIP tego NPC
               curr_goss = "1";
               local Greeting_PL = GS_Gossip[Hash];
               GreetingText:SetText(Rowtr:ExpandUnitInfo(Greeting_PL)); 
               QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] "..GS_lang);
               QTR_ToggleButtonGS:Enable(); 
               QTR_ToggleButtonGS:Show()
            else                               -- nie ma tłumaczenia w bazie GOSSIP
               curr_goss = "0";
               -- zapis do pliku
               QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] EN");
               QTR_ToggleButtonGS:Disable(); 
               QTR_ToggleButtonGS:Show()
            end
         end
   end
end


-- Otworzono pusty QuestLog
function Rowtr:EmptyQuestLog()
   QTR_ToggleButton1:Hide();
end
 
-- Otworzono okienko QuestLogFrame lub QuestMapDetailsScrollFrame lub QuestGuru lub Immersion
function Rowtr:QuestPrepare(zdarzeniere)

   local zdarzenie = zdarzeniere;   
   
   QTR_ToggleButton1:Show();        -- Show, bo mógł być ukryty przy pustym QuestLogu 

   if(Rowtr.target < 3) then
      QTR_ToggleButton1:SetPoint("TOPLEFT", QuestLogFrame, "TOPRIGHT", -220, -15);
      QuestLogTitleText:SetPoint("TOPLEFT",-40,-16)
   end

   if (Rowtr:isQuestGuru()) then
      if (QTR_PS["other1"]=="0") then       -- jest aktywny QuestGuru, ale nie zezwolono na tłumaczenie
         QTR_ToggleButton3:Hide();
         return;
      else   
         QTR_ToggleButton3:Show();
         if (QuestGuru:IsVisible() and (curr_trans=="0")) then
            QTR_Translate_Off(1);
            local questTitle, level, questTag, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(GetQuestLogSelection());
            if (QTR_quest_EN.id==questID) then
               return;
            end
         end
      end   
   end  

   
   if (Rowtr:isImmersion()) then
      if (QTR_PS["other2"]=="0") then       -- jest aktywny Immersion, ale nie zezwolono na tłumaczenie
         QTR_ToggleButton4:Hide();
         return
      else
         QTR_ToggleButton4:Show();
         if (ImmersionContentFrame:IsVisible() and (curr_trans=="0")) then
            Rowtr:Translate_Off(1);
            return;
         end
      end      
   end

   -- questlogdetailframe and questlogframe check, there are differences in the lua functions.

   if(zdarzenie == "WORLDMAP_SELECTED_QUEST") then
      if ((GetQuestLogTitle(GetQuestLogSelection()) == 0 or GetQuestLogTitle(GetQuestLogSelection()) == nil)) then
         if (QTR_onDebug) then
            print('GetQuestLogTItle null, qtr1');  
            return;
         end   
      else 
         local questTitleer, leveler, questTager, isHeaderer, isCollapseder, isCompleteer, isDailyer, Niller, questIDer = GetQuestLogTitle(GetQuestLogSelection());
         if (QTR_onDebug) then
            print('prntando questid do item selecionado: '..questTitleer);
            print(GetQuestLogTitle(GetQuestLogSelection()));
         end

         q_ID = questIDer; 
         str_ID = tostring(questIDer); 
         
         QTR_quest_EN.id = questIDer; 
         QTR_quest_LG.id = questIDer;  
      end  
   else  
      if(Rowtr.QuestLogDetailFrame:IsVisible() or QuestLogFrame:IsVisible() or WorldMapFrame:IsVisible()) then   
         if ((GetQuestLogTitle(GetQuestLogSelection()) == 0 or GetQuestLogTitle(GetQuestLogSelection()) == nil)) then
            if (QTR_onDebug) then
               print('GetQuestLogTItle null, qtr2');  
               return;
            end   
         else 
            local questTitleer, leveler, questTager, isHeaderer, isCollapseder, isCompleteer, isDailyer, Niller, questIDer = GetQuestLogTitle(GetQuestLogSelection());
            if(Rowtr.target < 3) then
               if(Rowtr:GetQuestID(questTitleer) == 0 or Rowtr:GetQuestID(questTitleer) == nil) then 
                  if(QTR_onDebug) then
                     print("GetQuestID on qtr3 returned 0 or nil");
                     print(zdarzenie);  
                  end 
               else   
                  q_ID = Rowtr:GetQuestID(questTitleer); 
                  str_ID = tostring(q_ID); 
            
                  QTR_quest_EN.id = q_ID; 
                  QTR_quest_LG.id = q_ID; 
                  zdarzenie = "QUEST_DETAIL_LOG"; -- just because of some functions...
               end
            else
               if (QTR_onDebug) then
                  print('prntando questid do item selecionado: '..questTitleer);
                  print(GetQuestLogTitle(GetQuestLogSelection()));
               end 
 
               q_ID = questIDer;
               str_ID = tostring(questIDer); 
            
               QTR_quest_EN.id = questIDer; 
               QTR_quest_LG.id = questIDer; 
               zdarzenie = "QUEST_DETAIL_LOG"; -- just because of some functions...
            end
         end  
      else 
         if(Rowtr:GetQuestID() == 0 or Rowtr:GetQuestID() == nil) then
            if(QTR_onDebug) then
               print("GetQuestID on qtr3 returned 0 or nil");
               print(zdarzenie);  
            end 
         else  
            q_ID = Rowtr:GetQuestID();
            str_ID = tostring(q_ID);
            QTR_quest_EN.id = q_ID; 
            QTR_quest_LG.id = q_ID;  
         end
      end
   end

   if(q_ID == 0 or q_ID == nil) then
      return; -- despite all efforts, no quest id so we won't continue.
   end
 
   if (QTR_PS["control"]=="1") then         -- zapisuj kontrolnie treść oryginalnych questów EN
      QTR_quest_EN.title = GetTitleText(); 
      if (QTR_quest_EN.title=="") then
         QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection());  
      end
      if (zdarzenie=="QUEST_DETAIL") then 
         QTR_quest_EN.details = GetQuestText();
         QTR_quest_EN.objectives = GetObjectiveText();
      end
      if (zdarzenie=="QUEST_DETAIL_LOG" or zdarzenie=="WORLDMAP_SELECTED_QUEST") then 
         QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection()); 
         local questDescription, questObjectives = GetQuestLogQuestText(); 
         QTR_quest_EN.details = questDescription;
         QTR_quest_EN.objectives = questObjectives; 
      end
      if (zdarzenie=="QUEST_PROGRESS") then 
         QTR_quest_EN.progress = GetProgressText(); 
      end
      if (zdarzenie=="QUEST_COMPLETE") then
         QTR_quest_EN.completion = GetRewardText(); 
         if(QTR_PLAYERQUESTS[QTR_quest_EN.id]) then  
            QTR_PLAYERQUESTS[QTR_quest_EN.id]["Completion"] = GetRewardText();
         end
      end
   end
   if ( QTR_PS["active"]=="1" ) then	-- tłumaczenia włączone
      QTR_ToggleButton0:Enable();
      QTR_ToggleButton1:Enable();
      QTR_ToggleButton2:Enable();
      QTR_ToggleButtonWM:Enable();  

      if (Rowtr:isImmersion()) then
         if (q_ID==0) then
            return;
         end   
         QTR_ToggleButton4:Enable();
      end
      curr_trans = "1";
      if ( QTR_QuestData[str_ID] or QTR_FIXEDQUEST[str_ID]) then   -- wyświetlaj tylko, gdy istnieje tłumaczenie
         if (QTR_onDebug) then
            print('Znalazł tłumaczenie dla ID: '..str_ID);   
         end   
         QTR_quest_LG.title = Rowtr:ExpandUnitInfo(Rowtr:GetQuestData(str_ID, "Title"));
         QTR_quest_EN.title = GetTitleText();
         if (QTR_quest_EN.title=="") then
            QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection()); 
         end
         QTR_quest_LG.details = Rowtr:ExpandUnitInfo(Rowtr:GetQuestData(str_ID, "Description"));
         QTR_quest_LG.objectives = Rowtr:ExpandUnitInfo(Rowtr:GetQuestData(str_ID, "Objectives"));
         if (zdarzenie=="QUEST_DETAIL") then
            QTR_quest_EN.details = GetQuestText();
            QTR_quest_EN.objectives = GetObjectiveText();
            QTR_quest_EN.itemchoose = QTR_MessOrig.itemchoose1;
            QTR_quest_LG.itemchoose = QTR_Messages.itemchoose1;
            QTR_quest_EN.itemreceive = QTR_MessOrig.itemreceiv1;
            QTR_quest_LG.itemreceive = QTR_Messages.itemreceiv1; 
            
            if (strlen(QTR_quest_EN.details)>0 and strlen(QTR_quest_LG.details)==0) then
               --QTR_MISSING[QTR_quest_EN.id.." DESCRIPTION"]=QTR_quest_EN.details;     -- save missing translation part
               if(Rowtr.target > 1) then
                  QTR_quest_LG.details = QTR_quest_EN.details .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing); 
               else
                  QTR_quest_LG.details = QTR_quest_EN.details .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v); 
               end
            end
            if (strlen(QTR_quest_EN.objectives)>0 and strlen(QTR_quest_LG.objectives)==0) then
               --QTR_MISSING[QTR_quest_EN.id.." OBJECTIVE"]=QTR_quest_EN.objectives;    -- save missing translation part
               
               if(Rowtr.target > 1) then
                  QTR_quest_LG.objectives = QTR_quest_EN.objectives .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing);
               else
                  QTR_quest_LG.objectives = QTR_quest_EN.objectives .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v);
               end
            end 
         else   
            if (QTR_quest_LG.details ~= GetQuestText()) then
               QTR_quest_EN.details =  GetQuestText();
            end
            if (QTR_quest_LG.objectives ~= GetObjectiveText()) then
               QTR_quest_EN.objectives = GetObjectiveText();
            end
         end
         if(zdarzenie=="QUEST_DETAIL_LOG" or zdarzenie=="WORLDMAP_SELECTED_QUEST") then
            QTR_quest_EN.title=GetQuestLogTitle(GetQuestLogSelection()); 
            local questDescription, questObjectives = GetQuestLogQuestText();  
            QTR_quest_EN.details = questDescription;
            QTR_quest_EN.objectives = questObjectives;
            QTR_quest_EN.itemchoose = QTR_MessOrig.itemchoose1;
            QTR_quest_LG.itemchoose = QTR_Messages.itemchoose1;
            QTR_quest_EN.itemreceive = QTR_MessOrig.itemreceiv1;
            QTR_quest_LG.itemreceive = QTR_Messages.itemreceiv1; 

            if(QTR_quest_EN.details == nil or QTR_quest_EN.objectives == nil) then
               return; 
            end
            
            if (strlen(QTR_quest_EN.details)>0 and strlen(QTR_quest_LG.details)==0) then
               --QTR_MISSING[QTR_quest_EN.id.." DESCRIPTION"]=QTR_quest_EN.details;     -- save missing translation part
               if(Rowtr.target > 1 ) then
                  QTR_quest_LG.details = QTR_quest_EN.details .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing); 
               else
                  QTR_quest_LG.details = QTR_quest_EN.details .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v); 
               end
            end
            if (strlen(QTR_quest_EN.objectives)>0 and strlen(QTR_quest_LG.objectives)==0) then
              -- QTR_MISSING[QTR_quest_EN.id.." OBJECTIVE"]=QTR_quest_EN.objectives;    -- save missing translation part
               if(Rowtr.target > 1 ) then
                  QTR_quest_LG.objectives = QTR_quest_EN.objectives .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing); 
               else
                  QTR_quest_LG.objectives = QTR_quest_EN.objectives .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v); 
               end
            end
         end
         if (zdarzenie=="QUEST_PROGRESS") then
            QTR_quest_EN.progress = GetProgressText(); 
            if(QTR_PLAYERQUESTS[QTR_quest_EN.id]) then
               QTR_PLAYERQUESTS[QTR_quest_EN.id]["Progress"] = GetProgressText();
            end
            QTR_quest_LG.progress = Rowtr:ExpandUnitInfo(Rowtr:GetQuestData(str_ID, "Progress"));
            if (strlen(QTR_quest_EN.progress)>0 and strlen(QTR_quest_LG.progress)==0) then
               --QTR_MISSING[QTR_quest_EN.id.." PROGRESS"]=QTR_quest_EN.progress;     -- save missing translation part
               if(Rowtr.target > 1 ) then
                  QTR_quest_LG.progress = QTR_quest_EN.progress .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing); 
               else
                  QTR_quest_LG.progress = QTR_quest_EN.progress .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v); 
               end
            end
            if (strlen(QTR_quest_LG.progress)==0) then      -- treść jest pusta, a otworzono okienko Progress
               QTR_quest_LG.progress = Rowtr:ExpandUnitInfo(QTR_ExtraTexts.missingProgressText); 
            end
         end
         if (zdarzenie=="QUEST_COMPLETE") then
            QTR_quest_EN.completion = GetRewardText();  
            if(QTR_PLAYERQUESTS[QTR_quest_EN.id]) then  
               QTR_PLAYERQUESTS[QTR_quest_EN.id]["Completion"] = GetRewardText();
            end
            QTR_quest_LG.completion = Rowtr:ExpandUnitInfo(Rowtr:GetQuestData(str_ID, "Completion"));
            QTR_quest_EN.itemchoose = QTR_MessOrig.itemchoose2;
            QTR_quest_LG.itemchoose = QTR_Messages.itemchoose2;
            QTR_quest_EN.itemreceive = QTR_MessOrig.itemreceiv2;
            QTR_quest_LG.itemreceive = QTR_Messages.itemreceiv2;
            if (strlen(QTR_quest_EN.completion)>0 and strlen(QTR_quest_LG.completion)==0) then
               --QTR_MISSING[QTR_quest_EN.id.." COMPLETE"]=QTR_quest_EN.completion;     -- save missing translation part
               if(Rowtr.target > 1 ) then
                  QTR_quest_LG.completion = QTR_quest_EN.completion .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing); 
               else
                  QTR_quest_LG.completion = QTR_quest_EN.completion .. Rowtr:ExpandUnitInfo(QTR_ExtraTexts.translationmissing_v); 
               end
            end
         end         
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");  
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            QTR_ToggleButton3:Enable();
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            QTR_quest_EN.details = GetQuestText();
            QTR_quest_EN.progress = GetProgressText();
            QTR_quest_EN.completion = GetRewardText();
         end
         if (Rowtr:isStoryline() and Storyline_NPCFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         end
         Rowtr:Translate_On(1); -- tds estao sendo chamados daq

      else	      -- nie ma przetłumaczonego takiego questu
         if (QTR_onDebug) then
            print('Nie znalazł tłumaczenia dla ID: '..str_ID);   
         end   
         QTR_ToggleButton0:Disable();
         QTR_ToggleButton1:Disable();
         QTR_ToggleButton2:Disable(); 
         QTR_ToggleButtonWM:Disable(); 
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:Disable();
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:Disable();
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:Disable();
         end
         QTR_ToggleButton0:SetText("Quest ID="..str_ID);
         QTR_ToggleButton1:SetText("Quest ID="..str_ID);
         QTR_ToggleButton2:SetText("Quest ID="..str_ID);  
         QTR_ToggleButtonWM:SetText("Quest ID="..str_ID); 
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID);
         end
         if (Rowtr:isImmersion()) then
            if (q_ID==0) then
               if (ImmersionFrame.TitleButtons:IsVisible()) then
                  QTR_ToggleButton4:SetText("wybierz wpierw quest");
               end
            else
               QTR_ToggleButton4:SetText("Quest ID="..str_ID);
            end
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID);
         end
         Rowtr:Translate_On(0); 
      end -- jest przetłumaczony quest w bazie
   else	-- tłumaczenia wyłączone
      QTR_ToggleButton0:Disable();
      QTR_ToggleButton1:Disable();
      QTR_ToggleButton2:Disable(); 
      QTR_ToggleButtonWM:Disable() 

      if ( QTR_QuestData[str_ID] ) then	-- ale jest tłumaczenie w bazie
         QTR_ToggleButton1:SetText("Quest ID="..str_ID.." (EN)");
         QTR_ToggleButton2:SetText("Quest ID="..str_ID.." (EN)"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..str_ID.." (EN)");
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID.." (EN)");
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..str_ID.." (EN)");
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID.." (EN)");
         end 
      else
         QTR_ToggleButton1:SetText("Quest ID="..str_ID);
         QTR_ToggleButton2:SetText("Quest ID="..str_ID); 
         QTR_ToggleButtonWM:SetText("Quest ID="..str_ID);
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..str_ID);
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..str_ID);
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..str_ID);
         end  
      end
   end	-- tłumaczenia są włączone 
   
end 

local function QTR_WOTLK_Translate_On(typ) -- WOTLK
   if (QTR_onDebug) then
      print('traduzindo');   
   end   
   QuestInfoObjectivesHeader:SetFont(QTR_Font1, 18);
   QuestInfoObjectivesHeader:SetText(QTR_Messages.objectives); -- "Zadanie"

   QuestInfoRewardsHeader:SetFont(QTR_Font1, 18);
   QuestInfoRewardsHeader:SetText(QTR_Messages.rewards);      -- "Nagroda" 

   QuestInfoDescriptionHeader:SetFont(QTR_Font1, 18);
   QuestInfoDescriptionHeader:SetText(QTR_Messages.details);     -- "Szczegóły"
   
   QuestProgressRequiredItemsText:SetFont(QTR_Font1, 18);
   QuestProgressRequiredItemsText:SetText(QTR_Messages.reqitems);
   
--   QuestInfoSpellObjectiveLearnLabel:SetFont(QTR_Font2, 13);
--   QuestInfoSpellObjectiveLearnLabel:SetText(QTR_Messages.learnspell);
   QuestInfoXPFrameReceiveText:SetFont(QTR_Font2, 13);
   QuestInfoXPFrameReceiveText:SetText(QTR_Messages.experience);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetFont(QTR_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetFont(QTR_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1);
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1);
   if (typ==1) then			-- pełne przełączenie (jest tłumaczenie)
      QuestInfoItemChooseText:SetFont(QTR_Font2, 13);
      QuestInfoItemChooseText:SetText(QTR_Messages.itemchoose1);
      QuestInfoItemReceiveText:SetFont(QTR_Font2, 13);
      QuestInfoItemReceiveText:SetText(QTR_Messages.itemreceiv1);
      numer_ID = QTR_quest_LG.id;
      str_ID = tostring(numer_ID);
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć przetłumaczoną wersję napisów
         if (QTR_onDebug) then
            print('tłum.ID='..str_ID);   
         end   
         if (QTR_PS["transtitle"]=="1") then    -- wyświetl przetłumaczony tytuł
          --  QuestLogQuestTitle:SetFont(QTR_Font1, 18);
          --  QuestLogQuestTitle:SetText(QTR_quest_LG.title);
            QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
            QuestInfoTitleHeader:SetText(QTR_quest_LG.title);
           QuestProgressTitleText:SetFont(QTR_Font1, 18);
            QuestProgressTitleText:SetText(QTR_quest_LG.title);
         end
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")"); 
         
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            if (not Rowtr:wait(0.2, Rowtr.Immersion)) then    -- wywołaj podmienianie danych po 0.2 sek
               -- opóźnienie 0.2 sek
            end
         end
         if (Rowtr:isStoryline() and Storyline_NPCFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            Rowtr:Storyline(1);
         end
         QuestInfoDescriptionText:SetFont(QTR_Font2, 13);
         QuestInfoDescriptionText:SetText(QTR_quest_LG.details);
         QuestInfoDescriptionText:SetFont(QTR_Font2, 13);
         QuestInfoDescriptionText:SetText(QTR_quest_LG.details);
         QuestInfoObjectivesText:SetFont(QTR_Font2, 13);
         QuestInfoObjectivesText:SetText(QTR_quest_LG.objectives);
         QuestProgressText:SetFont(QTR_Font2, 13);
         QuestProgressText:SetText(QTR_quest_LG.progress);
         
         
        -- QuestLogObjectivesText:SetFont(QTR_Font2, 13);
        -- QuestLogObjectivesText:SetText(QTR_quest_LG.objectives);
         
         QuestProgressText:SetFont(QTR_Font2, 13);
         QuestProgressText:SetText(QTR_quest_LG.progress);
         QuestInfoRewardText:SetFont(QTR_Font2, 13);
         QuestInfoRewardText:SetText(QTR_quest_LG.completion);
         
    --     QuestInfoRewardsFrame.ItemChooseText:SetFont(QTR_Font2, 13);
      --   QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_quest_LG.itemchoose);
        -- QuestInfoRewardsFrame.ItemReceiveText:SetFont(QTR_Font2, 13);
        -- QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_quest_LG.itemreceive);
      end
   else
      if (curr_trans == "1") then
       --  QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1);
        -- QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1);
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not Rowtr:wait(0.2,Rowtr.Immersion_Static)) then
               -- podmiana tekstu z opóźnieniem 0.2 sek
            end
         end
      end
   end
end

-- wyświetla tłumaczenie
function Rowtr:Translate_On(typ)
   
   if(Rowtr.target > 2) then QTR_WOTLK_Translate_On(typ) return end

   if (QTR_onDebug) then
      print('traduzindo');   
   end 
   if(QuestDetailObjectiveTitleText)  then
      QuestDetailObjectiveTitleText:SetFont(QTR_Font1, 18);
      QuestDetailObjectiveTitleText:SetText(QTR_Messages.objectives); -- "Zadanie" 
   end
   if(QuestLogObjectiveTitleText) then
      QuestLogObjectiveTitleText:SetFont(QTR_Font1, 18);
      QuestLogObjectiveTitleText:SetText(QTR_Messages.objectives); -- "Zadanie" 
   end

   if(QuestLogDescriptionTitle) then 
      QuestLogDescriptionTitle:SetFont(QTR_Font1, 18);       -- Description
      QuestLogDescriptionTitle:SetText(QTR_Messages.details);
   end
   
   if(QuestLogRewardTitleText) then
      QuestLogRewardTitleText:SetFont(QTR_Font1, 18);
      QuestLogRewardTitleText:SetText(QTR_Messages.rewards);
   end

   if(QuestDetailRewardTitleText) then
      QuestDetailRewardTitleText:SetFont(QTR_Font1, 18);
      QuestDetailRewardTitleText:SetText(QTR_Messages.rewards);
   end 
   

   if(QuestRewardRewardTitleText) then
      QuestRewardRewardTitleText:SetFont(QTR_Font1, 18);
      QuestRewardRewardTitleText:SetText(QTR_Messages.rewards);
   end 

   if (typ==1) then			-- pełne przełączenie (jest tłumaczenie)
      if(QuestLogItemChooseText) then
         QuestLogItemChooseText:SetFont(QTR_Font2, 13);
         QuestLogItemChooseText:SetText(QTR_Messages.itemchoose1);
      end
      
      if(QuestRewardItemChooseText) then
         QuestRewardItemChooseText:SetFont(QTR_Font2, 13);
         QuestRewardItemChooseText:SetText(QTR_Messages.itemchoose1);
      end
      
      if(QuestDetailItemChooseText) then
         QuestDetailItemChooseText:SetFont(QTR_Font2, 13);
         QuestDetailItemChooseText:SetText(QTR_Messages.itemchoose1);
      end

      if(QuestLogItemReceiveText) then 
         QuestLogItemReceiveText:SetFont(QTR_Font2, 13);
         QuestLogItemReceiveText:SetText(QTR_Messages.itemreceiv1);
      end
      
      if(QuestRewardItemReceiveText) then
         QuestRewardItemReceiveText:SetFont(QTR_Font2, 13);
         QuestRewardItemReceiveText:SetText(QTR_Messages.itemreceiv1);
      end
      
      if(QuestDetailItemReceiveText) then
         QuestDetailItemReceiveText:SetFont(QTR_Font2, 13);
         QuestDetailItemReceiveText:SetText(QTR_Messages.itemreceiv1);
      end

      numer_ID = QTR_quest_LG.id;
      str_ID = tostring(numer_ID);
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć przetłumaczoną wersję napisów
         if (QTR_onDebug) then
            print('tłum.ID='..str_ID);   
         end   
         if (QTR_PS["transtitle"]=="1") then    -- wyświetl przetłumaczony tytuł
            QuestTitleText:SetFont(QTR_Font1, 18);
            QuestTitleText:SetText(QTR_quest_LG.title);
            if(QuestProgressTitleText) then
               QuestProgressTitleText:SetFont(QTR_Font1, 18);
               QuestProgressTitleText:SetText(QTR_quest_LG.title);
            end
            if(QuestRewardTitleText) then
               QuestRewardTitleText:SetFont(QTR_Font1, 18);
               QuestRewardTitleText:SetText(QTR_quest_LG.title);
            end 
            if(QuestLogTitleText) then
               QuestLogQuestTitle:SetFont(QTR_Font1, 18);
               QuestLogQuestTitle:SetText(QTR_quest_LG.title);
            end
         end
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")"); 
         
         if (Rowtr:isQuestGuru()) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
         end
         if (Rowtr:isImmersion()) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            if (not Rowtr:wait(0.2, Rowtr.Immersion)) then    -- wywołaj podmienianie danych po 0.2 sek
               -- opóźnienie 0.2 sek
            end
         end
         if (Rowtr:isStoryline() and Storyline_NPCFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_LG.id.." ("..QTR_lang..")");
            Rowtr:Storyline(1);
         end

         if(QuestDescription) then
            QuestDescription:SetFont(QTR_Font2, 13);
            QuestDescription:SetText(QTR_quest_LG.details);
         end
         if(QuestLogQuestDescription) then
            QuestLogQuestDescription:SetFont(QTR_Font2, 13);
            QuestLogQuestDescription:SetText(QTR_quest_LG.details);
         end

         if(QuestObjectiveText) then
            QuestObjectiveText:SetFont(QTR_Font2, 13);
            QuestObjectiveText:SetText(QTR_quest_LG.objectives);
         end
         if(QuestLogObjectivesText) then 
            QuestLogObjectivesText:SetFont(QTR_Font2, 13);
            QuestLogObjectivesText:SetText(QTR_quest_LG.objectives);
         end
         if(QuestProgressText) then
            QuestProgressText:SetFont(QTR_Font2, 13);
            QuestProgressText:SetText(QTR_quest_LG.progress);
         end
         
        if(QuestRewardText) then
         QuestRewardText:SetFont(QTR_Font2, 13);
         QuestRewardText:SetText(QTR_quest_LG.completion);
        end
         
      end
   else
      if (curr_trans == "1") then
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not Rowtr:wait(0.2, Rowtr.Immersion_Static)) then
               -- podmiana tekstu z opóźnieniem 0.2 sek
            end
         end
      end
   end
end


local function QTR_WOTLK_Translate_Off(typ) -- WOTLK
   QuestInfoTitleHeader:SetFont(Original_Font1, 18);
   QuestInfoTitleHeader:SetText(QTR_quest_EN.title);
   QuestProgressTitleText:SetText(QTR_quest_EN.title);        
   QuestProgressTitleText:SetFont(Original_Font1, 18);
   
--   QuestLogQuestTitle:SetFont(Original_Font1, 18);
--   QuestLogQuestTitle:SetText(QTR_quest_EN.title);
   
   QuestInfoObjectivesHeader:SetFont(Original_Font1, 18);      -- Quest Objectives
   QuestInfoObjectivesHeader:SetText(QTR_MessOrig.objectives);

   QuestInfoRewardsHeader:SetFont(Original_Font1, 18);        -- Reward
   QuestInfoRewardsHeader:SetText(QTR_MessOrig.rewards); 
   
   QuestInfoDescriptionHeader:SetFont(Original_Font1, 18);       -- Description
   QuestInfoDescriptionHeader:SetText(QTR_MessOrig.details);
   
   QuestProgressRequiredItemsText:SetFont(Original_Font1, 18);
   QuestProgressRequiredItemsText:SetText(QTR_MessOrig.reqitems);
   
--   MapQuestInfoRewardsFrame.ItemReceiveText:SetFont(Original_Font2, 11);
--   MapQuestInfoRewardsFrame.ItemChooseText:SetFont(Original_Font2, 11);
   QuestInfoSpellLearnText:SetFont(Original_Font2, 13);
   QuestInfoSpellLearnText:SetText(QTR_MessOrig.learnspell);
   QuestInfoXPFrameReceiveText:SetFont(Original_Font2, 13);
   QuestInfoXPFrameReceiveText:SetText(QTR_MessOrig.experience);
   if (typ==1) then			-- pełne przełączenie (jest tłumaczenie)
      QuestInfoItemChooseText:SetFont(Original_Font2, 13);
      QuestInfoItemChooseText:SetText(QTR_MessOrig.itemchoose1);
      QuestInfoItemReceiveText:SetFont(Original_Font2, 13);
      QuestInfoItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
--      MapQuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
--      MapQuestInfoRewardsFrame.ItemChooseText:SetText(QTR_MessOrig.itemreceiv1);
      numer_ID = QTR_quest_EN.id;
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć oryginalną wersję napisów
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_EN.id.." (EN)"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..QTR_quest_EN.id.." (EN)"); 
         if (QuestGuru ~= nil ) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         end 

         if (ImmersionFrame ~= nil ) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            Rowtr:Immersion_OFF();
            ImmersionFrame.TalkBox.TextFrame.Text:RepeatTexts();   --reload text
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            Rowtr:Storyline_OFF(1);
         end

  --       QuestLogQuestDescription:SetFont(Original_Font2, 13);
  --       QuestLogQuestDescription:SetText(QTR_quest_EN.details);
         QuestInfoDescriptionText:SetFont(Original_Font2, 13);
         QuestInfoDescriptionText:SetText(QTR_quest_EN.details);
         QuestInfoObjectivesText:SetFont(Original_Font2, 13);
         QuestInfoObjectivesText:SetText(QTR_quest_EN.objectives);
         
 --        QuestLogObjectivesText:SetFont(Original_Font2, 13);
  --       QuestLogObjectivesText:SetText(QTR_quest_EN.objectives);
         
         QuestProgressText:SetFont(Original_Font2, 13);
         QuestProgressText:SetText(QTR_quest_EN.progress);
         QuestInfoRewardText:SetFont(Original_Font2, 13);
         QuestInfoRewardText:SetText(QTR_quest_EN.completion);
         
 --        QuestInfoRewardsFrame.ItemChooseText:SetFont(Original_Font2, 13);
  --       QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_quest_EN.itemchoose);
 --        QuestInfoRewardsFrame.ItemReceiveText:SetFont(Original_Font2, 13);
  --       QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_quest_EN.itemreceive);
      end
   else   
      if (curr_trans == "0") then
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not Rowtr:wait(0.2, Rowtr.Immersion_OFF_Static)) then
               -- podmiana tekstu z opóźnieniem 0.2 sek
            end
         end
      end
   end
end


function Rowtr:Translate_Off(typ)

   if(Rowtr.target > 2) then QTR_WOTLK_Translate_Off(typ) return end

   if(QuestDetailObjectiveTitleText)  then
      QuestDetailObjectiveTitleText:SetFont(Original_Font1, 18);
      QuestDetailObjectiveTitleText:SetText(QTR_MessOrig.objectives); -- "Zadanie" 
   end
   if(QuestLogObjectiveTitleText) then
      QuestLogObjectiveTitleText:SetFont(Original_Font1, 18);
      QuestLogObjectiveTitleText:SetText(QTR_MessOrig.objectives); -- "Zadanie" 
   end

   if(QuestLogDescriptionTitle) then 
      QuestLogDescriptionTitle:SetFont(Original_Font1, 18);       -- Description
      QuestLogDescriptionTitle:SetText(QTR_MessOrig.details);
   end
   
   if(QuestLogRewardTitleText) then
      QuestLogRewardTitleText:SetFont(Original_Font1, 18);
      QuestLogRewardTitleText:SetText(QTR_MessOrig.rewards);
   end

   if(QuestRewardRewardTitleText) then
      QuestRewardRewardTitleText:SetFont(Original_Font1, 18);
      QuestRewardRewardTitleText:SetText(QTR_MessOrig.rewards);
   end
   if(QuestDetailRewardTitleText) then
      QuestDetailRewardTitleText:SetFont(Original_Font1, 18);
      QuestDetailRewardTitleText:SetText(QTR_MessOrig.rewards);
   end

   if(QuestProgressTitleText) then
      QuestProgressTitleText:SetFont(Original_Font1, 18);
      QuestProgressTitleText:SetText(QTR_quest_EN.title);
   end
   if(QuestTitleText) then
      QuestTitleText:SetFont(Original_Font1, 18);
      QuestTitleText:SetText(QTR_quest_EN.title);
   end

   if(QuestLogTitleText) then
      QuestLogQuestTitle:SetFont(Original_Font1, 18);
      QuestLogQuestTitle:SetText(QTR_quest_EN.title);
   end
   
   if(QuestRewardTitleText) then
      QuestRewardTitleText:SetFont(Original_Font1, 18);
      QuestRewardTitleText:SetText(QTR_quest_EN.title);
   end





   if (typ==1) then
      if(QuestLogItemChooseText) then
         QuestLogItemChooseText:SetFont(Original_Font2, 13);
         QuestLogItemChooseText:SetText(QTR_MessOrig.itemchoose1);
      end

      if(QuestRewardItemChooseText) then
         QuestRewardItemChooseText:SetFont(Original_Font2, 13);
         QuestRewardItemChooseText:SetText(QTR_MessOrig.itemchoose1);
      end

      if(QuestDetailItemChooseText) then
         QuestDetailItemChooseText:SetFont(Original_Font2, 13);
         QuestDetailItemChooseText:SetText(QTR_MessOrig.itemchoose1);
      end

      if(QuestLogItemReceiveText) then 
         QuestLogItemReceiveText:SetFont(Original_Font2, 13);
         QuestLogItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
      end

      if(QuestRewardItemReceiveText) then
         QuestRewardItemReceiveText:SetFont(Original_Font2, 13);
         QuestRewardItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
      end

      if(QuestDetailItemReceiveText) then
         QuestDetailItemReceiveText:SetFont(Original_Font2, 13);
         QuestDetailItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
      end


      numer_ID = QTR_quest_EN.id;
      if (numer_ID>0 and QTR_QuestData[str_ID]) then	-- przywróć oryginalną wersję napisów
         QTR_ToggleButton0:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton1:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         QTR_ToggleButton2:SetText("Quest ID="..QTR_quest_EN.id.." (EN)"); 
         QTR_ToggleButtonWM:SetText("Quest ID="..QTR_quest_EN.id.." (EN)"); 
         if (QuestGuru ~= nil ) then
            QTR_ToggleButton3:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
         end 

         if (ImmersionFrame ~= nil ) then
            QTR_ToggleButton4:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            Rowtr:Immersion_OFF();
            ImmersionFrame.TalkBox.TextFrame.Text:RepeatTexts();   --reload text
         end
         if (Rowtr:isStoryline()) then
            QTR_ToggleButton5:SetText("Quest ID="..QTR_quest_EN.id.." (EN)");
            Rowtr:Storyline_OFF(1);
         end

         if(QuestDescription) then
            QuestDescription:SetFont(Original_Font2, 13);
            QuestDescription:SetText(QTR_quest_EN.details);
         end
         if(QuestLogQuestDescription) then
            QuestLogQuestDescription:SetFont(Original_Font2, 13);
            QuestLogQuestDescription:SetText(QTR_quest_EN.details);
         end

         if(QuestObjectiveText) then
            QuestObjectiveText:SetFont(Original_Font2, 13);
            QuestObjectiveText:SetText(QTR_quest_EN.objectives);
         end
         if(QuestLogObjectivesText) then 
            QuestLogObjectivesText:SetFont(Original_Font2, 13);
            QuestLogObjectivesText:SetText(QTR_quest_EN.objectives);
         end
         if(QuestProgressText) then
            QuestProgressText:SetFont(Original_Font2, 13);
            QuestProgressText:SetText(QTR_quest_EN.progress);
         end
         
        if(QuestRewardText) then
         QuestRewardText:SetFont(Original_Font2, 13);
         QuestRewardText:SetText(QTR_quest_EN.completion);
        end
      end
   else   
      if (curr_trans == "0") then
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not Rowtr:wait(0.2,Rowtr.Immersion_OFF_Static)) then
               -- 
            end
         end
      end
   end
end


function Rowtr:delayed3()
   QTR_ToggleButton4:SetText("wybierz wpierw quest");
   QTR_ToggleButton4:Hide();
   if (not Rowtr:wait(1,Rowtr.delayed4)) then
   ---
   end
end


function Rowtr:delayed4()
   if (ImmersionFrame.TitleButtons:IsVisible()) then
      if (ImmersionFrame.TitleButtons.Buttons[1] ~= nil ) then
         if(Rowtr.target > 1) then
            ImmersionFrame.TitleButtons.Buttons[1]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
         else
            HookScript(ImmersionFrame.TitleButtons.Buttons[1], "OnClick", function() QTR_PrepareDelay(1) end);
         end
      end
      if (ImmersionFrame.TitleButtons.Buttons[2] ~= nil ) then
         if(Rowtr.target > 1) then
            ImmersionFrame.TitleButtons.Buttons[2]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
         else
            HookScript(ImmersionFrame.TitleButtons.Buttons[2], "OnClick", function() QTR_PrepareDelay(1) end);
         end 
      end
      if (ImmersionFrame.TitleButtons.Buttons[3] ~= nil ) then
         if(Rowtr.target > 1) then
            ImmersionFrame.TitleButtons.Buttons[3]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
         else
            HookScript(ImmersionFrame.TitleButtons.Buttons[3], "OnClick", function() QTR_PrepareDelay(1) end);
         end  
      end   
      if (ImmersionFrame.TitleButtons.Buttons[4] ~= nil ) then
         if(Rowtr.target > 1) then
            ImmersionFrame.TitleButtons.Buttons[4]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
         else
            HookScript(ImmersionFrame.TitleButtons.Buttons[4], "OnClick", function() QTR_PrepareDelay(1) end);
         end  
      end
      if (ImmersionFrame.TitleButtons.Buttons[5] ~= nil ) then
         if(Rowtr.target > 1) then
            ImmersionFrame.TitleButtons.Buttons[5]:HookScript("OnClick", function() QTR_PrepareDelay(1) end);
         else
            HookScript(ImmersionFrame.TitleButtons.Buttons[5], "OnClick", function() QTR_PrepareDelay(1) end);
         end  
      end
   end

   Rowtr:QuestPrepare('');
end;      


function Rowtr:PrepareDelay(czas)     -- wywoływane po kliknięciu na nazwę questu z listy NPC
   if (czas==1) then
      if (not Rowtr:wait(1,Rowtr.PrepareReload)) then
      ---
      end
   end
   if (czas==3) then
      if (not Rowtr:wait(3,Rowtr.PrepareReload)) then
      ---
      end
   end
end;      


function Rowtr:PrepareReload()
   Rowtr:QuestPrepare('');
end;      


function Rowtr:Prepare1sek()   
   if (not Rowtr:wait(0.1,Rowtr.PrepareReload)) then
   ---
   end
end;       


function Rowtr:Immersion()   -- wywoływanie tłumaczenia z opóźnieniem 0.2 sek 
  ImmersionContentFrame.ObjectivesText:SetText(QTR_quest_LG.objectives); 
  ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_quest_LG.title); 
  if (strlen(QTR_quest_EN.details)>0) then                                    -- mamy zdarzenie DETAILS
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.details);
  elseif (strlen(QTR_quest_EN.completion)>0) then
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.completion);
  else
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_LG.progress);
  end
  Rowtr:Immersion_Static();        -- inne statyczne dane
end


function Rowtr:Immersion_Static()  
  ImmersionContentFrame.ObjectivesHeader:SetText(QTR_Messages.objectives);  -- "Zadanie" 
  ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_Messages.rewards);  -- "Nagroda" 
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_Messages.itemchoose1); -- "Możesz wybrać nagrodę:" 
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_Messages.itemreceiv1); -- "Otrzymasz w nagrodę:" 
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_Messages.experience);  -- "Doświadczenie" 
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_Messages.reqitems);  -- "Wymagane itemy:"
end


function Rowtr:Immersion_OFF()   -- wywoływanie oryginału ;
  ImmersionContentFrame.ObjectivesText:SetText(QTR_quest_EN.objectives); 
  ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_quest_EN.title); 
  if (strlen(QTR_quest_EN.details)>0) then                                    -- przywróć oryginalny tekst
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.details);
  elseif (strlen(QTR_quest_EN.progress)>0) then
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.progress);
  else
     ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN.completion);
  end
  Rowtr:Immersion_OFF_Static();       -- inne statyczne dane
end


function Rowtr:Immersion_OFF_Static() 
  ImmersionContentFrame.ObjectivesHeader:SetText(QTR_MessOrig.objectives);  -- "Zadanie" 
  ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_MessOrig.rewards);  -- "Nagroda" 
  ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_MessOrig.itemchoose1); -- "Możesz wybrać nagrodę:" 
  ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_MessOrig.itemreceiv1); -- "Otrzymasz w nagrodę:" 
  ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_MessOrig.experience);  -- "Doświadczenie" 
  ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_MessOrig.reqitems);  -- "Wymagane itemy:"
end


function Rowtr:Storyline_Delay()
   Rowtr:Storyline(1);
end


function Rowtr:Storyline_Quest()
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1" and Storyline_NPCFrameTitle:IsVisible()) then
      Rowtr:QuestPrepare('');
   end
end


function Rowtr:Storyline_Hide()
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1") then
      QTR_ToggleButton5:Hide();
   end
end


function Rowtr:Storyline_Objectives()
   if (QTR_onDebug) then
      print("QTR_ST: objectives");
   end
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1" and QTR_quest_LG.id>0) then
      local string_ID= tostring(QTR_quest_LG.id);
      Storyline_NPCFrameObjectivesContent.Title:SetText('Zadanie');
      if (QTR_QuestData[string_ID] ) then
         Storyline_NPCFrameObjectivesContent.Objectives:SetText(Rowtr:ExpandUnitInfo(QTR_QuestData[string_ID]["Objectives"])); 
      end   
   end
end


function Rowtr:Storyline_Rewards()
   if (QTR_onDebug) then
      print("QTR_ST: rewards");
   end
   if (QTR_PS["active"]=="1" and QTR_PS["other3"]=="1") then
      Storyline_NPCFrameRewards.Content.Title:SetText('Recompensa');
   end
end


function Rowtr:Storyline(nr)
   if (QTR_onDebug) then
      print('QTR_ST: Podmieniam quest '..QTR_quest_LG.id);
   end
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrameTitle:SetText(QTR_quest_LG.title);
      Storyline_NPCFrameTitle:SetFont(QTR_Font2, 18);
   end
   local string_ID= tostring(QTR_quest_LG.id);
   local texts = { "" };
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event;
      if (event=="QUEST_DETAIL") then
     	   texts = { strsplit("\n", Rowtr:ExpandUnitInfo(QTR_QuestData[string_ID]["Description"])) };
      end   
      if (event=="QUEST_PROGRESS") then
     	   texts = { strsplit("\n", Rowtr:ExpandUnitInfo(QTR_QuestData[string_ID]["Progress"])) };
      end   
      if (event=="QUEST_COMPLETE") then
     	   texts = { strsplit("\n", Rowtr:ExpandUnitInfo(QTR_QuestData[string_ID]["Completion"])) };
      end   
   end
   local ileOry = table.getn(Storyline_NPCFrameChat.texts);
   local indeks = 0;
   for i=1, table.getn(texts) do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1;
            Storyline_NPCFrameChat.texts[indeks]=texts[i];
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(QTR_Font2, 16);
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide();
      Storyline_NPCFrame.chat.currentIndex = 0;
      Storyline_API.playNext(Storyline_NPCFrameModelsYou);  -- reload
   end
end


function Rowtr:Storyline_OFF(nr)
   if (QTR_onDebug) then
      print('QTR_SToff: Przywracam quest '..QTR_quest_EN.id);
   end
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrameTitle:SetText(QTR_quest_EN.title);
      Storyline_NPCFrameTitle:SetFont(Original_Font2, 18);
   end
   local string_ID= tostring(QTR_quest_EN.id);
   local texts = { "" };
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event;
      if (event=="QUEST_DETAIL") then
     	   texts = { strsplit("\n", GetQuestText()) };
      end   
      if (event=="QUEST_PROGRESS") then
     	   texts = { strsplit("\n", GetProgressText()) };
      end   
      if (event=="QUEST_COMPLETE") then
     	   texts = { strsplit("\n", GetRewardText()) };
      end   
   end
   local ileOry = table.getn(Storyline_NPCFrameChat.texts);
   local indeks = 0;
   for i=1, table.getn(texts) do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1;
            Storyline_NPCFrameChat.texts[indeks]=texts[i];
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(Original_Font2, 16);
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide();
      Storyline_NPCFrame.chat.currentIndex = 0;
      Storyline_API.playNext(Storyline_NPCFrameModelsYou);  -- reload
   end
end


-- podmieniaj specjane znaki w tekście
function Rowtr:ExpandUnitInfo(msg)
   msg = string.gsub(msg, "NEW_LINE", "\n");
   msg = string.gsub(msg, "YOUR_NAME", QTR_name);
   
-- jeszcze obsłużyć YOUR_GENDER(x;y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "YOUR_GENDER");    -- gdy nie znalazł, jest: nil
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "YOUR_GENDER");
   end

-- jeszcze obsłużyć NPC_GENDER(x;y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "NPC_GENDER");    -- gdy nie znalazł, jest: nil
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "NPC_GENDER");
   end

   if (QTR_sex==3) then        -- płeć żeńska
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M2);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D2);          -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C2);          -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B2);          -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N2);          -- Narzędnik (z kim, z czym?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K2);          -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W2);          -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M2);            -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D2);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C2);            -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B2);            -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N2);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K2);            -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W2);            -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M2);     -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ą YOUR_RACE", "ą "..player_race.N2);              -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N2);    -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W2);                        -- Wołacz - pozostałe wystąpienia
      msg = string.gsub(msg, "ą YOUR_CLASS", "ą "..player_class.N2);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N2);      -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M2);    -- Mianownik (kto, co?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M2.." do ");   -- Mianownik (kto, co?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M2);      -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M2);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B2);     -- Biernik (kogo, co?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B2);  -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B2.." taki jak ");    -- Biernik (kogo, co?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B2);        -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W2);                      -- Wołacz - pozostałe wystąpienia
   else                    -- płeć męska
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M1);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D1);          -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C1);          -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B1);          -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N1);          -- Narzędnik (z kim, z czym?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K1);          -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W1);          -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M1);            -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D1);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C1);            -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B1);            -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N1);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K1);            -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W1);            -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M1);     -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ym YOUR_RACE", "ym "..player_race.N1);              -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N1);    -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W1);                        -- Wołacz - pozostałe wystąpienia
      msg = string.gsub(msg, "ym YOUR_CLASS", "ym "..player_class.N1);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N1);      -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M1);    -- Mianownik (kto, co?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M1.." do ");   -- Mianownik (kto, co?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M1);      -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M1);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B1);     -- Biernik (kogo, co?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B1);  -- Biernik (kogo, co?)
      msg = string.gsub(msg, "ego YOUR_CLASS", "ego "..player_class.B1);                -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B1.." taki jak ");    -- Biernik (kogo, co?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B1);        -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W1);                      -- Wołacz - pozostałe wystąpienia
   end
   
   return msg;
end 

function Rowtr:ExpandUnitInfoFQ(msg, IsSave) 
   if(IsSave == false) then 
      msg = string.gsub(msg, "NEW_LINE", "\n");
      msg = string.gsub(msg, '\"', '"'); -- avoiding problems...
      msg = string.gsub(msg, '"', '\"');
      msg = string.gsub(msg, '\r', ''); 
      msg = string.gsub(msg, QTR_name, 'YOUR_NAME');
      msg = string.gsub(msg, string.upper(QTR_name), 'YOUR_NAME');
      msg = string.gsub(msg, QTR_race, 'YOUR_RACE');
      msg = string.gsub(msg, string.lower(QTR_race), 'YOUR_RACE');
      msg = string.gsub(msg, QTR_class, 'YOUR_CLASS');
      msg = string.gsub(msg, string.lower(QTR_class), 'YOUR_CLASS');
   else
      msg = string.gsub(msg, "\n", "NEW_LINE");
      msg = string.gsub(msg, '\"', '"'); -- avoiding problems...
      msg = string.gsub(msg, '"', '\"');
      msg = string.gsub(msg, '\r', ''); 
      msg = string.gsub(msg, QTR_name, 'YOUR_NAME');
      msg = string.gsub(msg, string.upper(QTR_name), 'YOUR_NAME');
      msg = string.gsub(msg, QTR_race, 'YOUR_RACE');
      msg = string.gsub(msg, string.lower(QTR_race), 'YOUR_RACE');
      msg = string.gsub(msg, QTR_class, 'YOUR_CLASS');
      msg = string.gsub(msg, string.lower(QTR_class), 'YOUR_CLASS');
   end 
   return msg;
end

------------------------------------------------------------- starting spells // items // mobs translation code.

local WT_TTReset = {}

local WT_colors = {
   ["c1"]={r=1,g=1,b=1,a=1.0},          -- white: Name
   ["c2"]={r=1,g=0.125,b=0.125,a=1.0},  -- red:   Requires
   ["c3"]={r=1,g=0.8235,b=0,a=1.0},     -- gold:  Description
   ["c4"]={r=0,g=1,b=0,a=1.0},          -- green: Click to learn
   ["c5"]={r=1,g=0.125,b=1,a=1.0},      -- purple:
   };


-- stolen from pfUI
local function GetItemLinkByName(name)
  for itemID = 1, 25818 do
    local itemName, hyperLink, itemQuality = GetItemInfo(itemID)
    if (itemName and itemName == name) then
      local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
      return hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
    end
  end
end


local function GetItemIDByName(name)
   local itemLink = GetItemLinkByName(name)
   if not itemLink then return end 
     local _, _, itemID = string.find(itemLink, "item:(%d+):%d+:%d+:%d+") 
 
   return tonumber(itemID) 
 end

 local function GetTranslatedMobInfo(name)
   for k, v in pairs(WT_NPCs) do 
      if(v["TitleEN"] == name) then 
         return k,v["Title"]
      end
    end  
 end
 


function Rowtr:ToolTipTranslator_IsBody(line,ind)                              -- lewy tekst
  local WT_isbody=false;
  local WT_trans="";
  if (line=="Back" or line==WT_CustomLocale.Back) then WT_trans=WT_Body.Back;
    elseif (line=="Chest" or line==WT_CustomLocale.Chest) then WT_trans=WT_Body.Chest;
    elseif (line=="Feet" or line==WT_CustomLocale.Feet) then WT_trans=WT_Body.Feet;
    elseif (line=="Finger" or line==WT_CustomLocale.Finger) then WT_trans=WT_Body.Finger;
    elseif (line=="Hands" or line==WT_CustomLocale.Hands) then WT_trans=WT_Body.Hands;
    elseif (line=="Head" or line==WT_CustomLocale.Head) then WT_trans=WT_Body.Head;
    elseif (line=="Legs" or line==WT_CustomLocale.Legs) then WT_trans=WT_Body.Legs;
    elseif (line=="Neck" or line==WT_CustomLocale.Neck) then WT_trans=WT_Body.Neck;
    elseif (line=="Shirt" or line==WT_CustomLocale.Shirt) then WT_trans=WT_Body.Shirt;
    elseif (line=="Shoulder" or line==WT_CustomLocale.Shoulder) then WT_trans=WT_Body.Shoulder;
    elseif (line=="Shoulders" or line==WT_CustomLocale.Shoulder) then WT_trans=WT_Body.Shoulder;
    elseif (line=="Trinket" or line==WT_CustomLocale.Trinket) then WT_trans=WT_Body.Trinket;
    elseif (line=="Waist" or line==WT_CustomLocale.Waist) then WT_trans=WT_Body.Waist;
    elseif (line=="Wrist" or line==WT_CustomLocale.Wrist) then WT_trans=WT_Body.Wrist;
    elseif (line=="One-Hand" or line==WT_CustomLocale.One_Hand) then WT_trans=WT_Body.One_Hand;
    elseif (line=="Two-Hand" or line==WT_CustomLocale.Two_Hand) then WT_trans=WT_Body.Two_Hand;
    elseif (line=="Main Hand" or line==WT_CustomLocale.Main_Hand) then WT_trans=WT_Body.Main_Hand;
    elseif (line=="Off Hand" or line==WT_CustomLocale.Off_Hand) then WT_trans=WT_Body.Off_Hand;
    elseif (line=="Ranged" or line==WT_CustomLocale.Ranged) then WT_trans=WT_Body.Ranged;
    elseif (line=="Melee Range" or line==WT_CustomLocale.MeleeR) then WT_trans=WT_Weapon.MeleeR;
    elseif (line=="Thrown" or line==WT_CustomLocale.Thrown) then WT_trans=WT_Body.Thrown;
    elseif (line=="Mount" or line==WT_CustomLocale.Mount) then WT_trans=WT_Body.Mount;
    elseif (line=="Relic" or line==WT_CustomLocale.Relic) then WT_trans=WT_Body.Relic;
    elseif (line=="Projectile" or line==WT_CustomLocale.Projectile) then WT_trans=WT_Body.Projectile;
  end	
  if (WT_trans~="") then
     WT_isbody=true;
  end
  if (QTRTTT_PS["mats"] == "1" and WT_isbody) then
    getglobal(QTR_GameTooltipTextLeft..ind):SetText(WT_trans);         -- podmieniamy tekst
  end
  return WT_isbody;
end


function Rowtr:ToolTipTranslator_IsInfoL(line,ind)                             -- lewy tekst
  local WT_isinfo=false;
  local WT_trans="";
  if (line=="Already known" or line==WT_CustomLocale.AlreadyKnown) then WT_trans=WT_InfoL.AlreadyKnown;
    elseif (line=="Binds when equipped" or line==WT_CustomLocale.BindsEq) then WT_trans=WT_InfoL.BindsEq;
    elseif (line=="Binds when picked up" or line==WT_CustomLocale.BindsPickup) then WT_trans=WT_InfoL.BindsPickup;
    elseif (line=="Cannot be disenchanted" or line==WT_CustomLocale.CannotDisench) then WT_trans=WT_InfoL.CannotDisench;
    elseif (string.sub(line,1,8)=="Classes:") then WT_trans=WT_InfoL.Classes..string.sub(line,9);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Classes))==WT_CustomLocale.Classes) then WT_trans=WT_InfoL.Classes..string.sub(line,(strlen(WT_CustomLocale.Classes)+1));
    elseif (string.sub(line,1,6)=="Races:") then WT_trans=WT_InfoL.Races..string.sub(line,7);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Races))==WT_CustomLocale.Races) then WT_trans=WT_InfoL.Races..string.sub(line,(strlen(WT_CustomLocale.Races)+1));
    elseif (line=="Conjured Item" or line== WT_CustomLocale.ConjuredItem) then WT_trans=WT_InfoL.ConjuredItem;
    elseif (string.sub(line,1,19)=="Cooldown remaining:") then WT_trans=WT_InfoL.CooldownRem..string.sub(line,20);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.CooldownRem))==WT_CustomLocale.CooldownRem) then WT_trans=WT_InfoL.CooldownRem..string.sub(line,(strlen(WT_CustomLocale.CooldownRem)+1));
    elseif (string.sub(line,1,10)=="Durability") then WT_trans=WT_InfoL.Durability..string.sub(line,11);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Durability))==WT_CustomLocale.Durability) then WT_trans=WT_InfoL.Durability..string.sub(line,(strlen(WT_CustomLocale.Durability)+1));
    elseif (string.sub(line,1,9)=="Duration:") then WT_trans=WT_InfoL.Duration..string.sub(line,10);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Duration))==strlen(WT_CustomLocale.Duration)) then WT_trans=WT_InfoL.Duration..string.sub(line,(strlen(WT_CustomLocale.Duration)+1));
    elseif (string.sub(line,1,10)=="Item Level") then WT_trans=WT_InfoL.ItemLevel..string.sub(line,11);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.ItemLevel))==WT_CustomLocale.ItemLevel) then WT_trans=WT_InfoL.ItemLevel..string.sub(line,(strlen(WT_CustomLocale.ItemLevel)+1));
    elseif (line=="This Item Begins a Quest" or line==WT_CustomLocale.ItemBegQuest) then WT_trans=WT_InfoL.ItemBegQuest;
    elseif (line=="Locked" or line==WT_CustomLocale.Locked) then WT_trans=WT_InfoL.Locked;
    elseif (line=="No sell price" or line==NoSellPrice) then WT_trans=WT_InfoL.NoSellPrice;
    elseif (line=="Quest Item" or line==WT_CustomLocale.QuestItem) then WT_trans=WT_InfoL.QuestItem;
    elseif (string.sub(line,1,9)=="Reagents:") then WT_trans=WT_InfoL.Reagents..string.sub(line,10);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Reagents))==WT_CustomLocale.Reagents) then WT_trans=WT_InfoL.Reagents..string.sub(line,(strlen(WT_CustomLocale.Reagents)+1));
    elseif (string.sub(line,1,8)=="Requires") then WT_trans=WT_InfoL.Requires..string.sub(line,9);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Requires))==WT_CustomLocale.Requires) then WT_trans=WT_InfoL.Requires..string.sub(line,(strlen(WT_CustomLocale.Requires)+1));
    elseif (string.sub(line,1,20)=="<Right Click to Read" or line==WT_CustomLocale.RClick) then WT_trans=WT_InfoL.RClick; 
    elseif (string.sub(line,1,20)=="<Right Click to Open" or line==WT_CustomLocale.OClick) then WT_trans=WT_InfoL.OClick;
    elseif (string.sub(line,1,19)=="<Shift-Click to buy" or line==WT_CustomLocale.SClick) then WT_trans=WT_InfoL.SClick;
    elseif (string.sub(line,1,29)=="<Shift Right Click to Socket>" or line==WT_CustomLocale.RCSocket) then WT_trans=WT_InfoL.RCSocket;
    elseif (line=="Soulbound" or line==WT_CustomLocale.Soulbound) then WT_trans=WT_InfoL.Soulbound;
    elseif (string.sub(line,1,6)=="Tools:") then WT_trans=WT_InfoL.Tools..string.sub(line,7);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.Tools))==WT_CustomLocale.Tools) then WT_trans=WT_InfoL.Tools..string.sub(line,(strlen(WT_CustomLocale.Tools)+1));
    elseif (line=="Unique" or line==WT_CustomLocale.Unique) then WT_trans=WT_InfoL.Unique;
    elseif (line=="Unique-Equipped" or line==WT_CustomLocale.UniqueEq) then WT_trans=WT_InfoL.UniqueEq;
    elseif (string.sub(line,1,7)=="Unique:") then WT_trans=WT_InfoL.UniqueC..string.sub(line, 8);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.UniqueC))==WT_CustomLocale.UniqueC) then WT_trans=WT_InfoL.UniqueC..string.sub(line, (strlen(WT_CustomLocale.UniqueC)+1));
    elseif (string.sub(line,1,16)=="Unique-Equipped:") then WT_trans=WT_InfoL.UniqueC..string.sub(line, 17);
    elseif (string.sub(line,1,strlen(WT_CustomLocale.UniqueEqC))==WT_CustomLocale.UniqueEqC) then WT_trans=WT_InfoL.UniqueC..string.sub(line, (strlen(WT_CustomLocale.UniqueEqC)+1));
    elseif (string.sub(line,1,6)=="Unique") then WT_trans=WT_InfoL.Unique..string.sub(line, 7);
    elseif (line=="Instant cast" or line==WT_CustomLocale.InstCast) then WT_trans=WT_InfoL.InstCast;
    elseif (line=="Instant" or line==WT_CustomLocale.Instant) then WT_trans=WT_InfoL.Instant;
    elseif (line=="Channeled" or line==WT_CustomLocale.Channeled) then WT_trans=WT_InfoL.Channeled;
    elseif (string.len(line)<16 and string.sub(line,-5)=="range") then
       WT_trans=string.sub(line,1,string.len(line)-5)..WT_InfoL.Range;
    elseif (string.sub(line,(strlen(WT_CustomLocale.Range)+1))==" "..WT_CustomLocale.Range) then
       WT_trans=string.sub(line,1,string.len(line)-strlen(WT_CustomLocale.Range))..WT_InfoL.Range;
  end	
  if (WT_trans~="") then
     WT_isinfo=true;
  end
  if (QTRTTT_PS["info"] == "1" and WT_isinfo) then
    getglobal(QTR_GameTooltipTextLeft..ind):SetText(WT_trans);         -- podmieniamy tekst
  end
  return WT_isinfo;
end


function Rowtr:GetStatFormatedStr(lineL, txt)
   local tekst = txt
   local wartab={0,0,0,0,0,0,0,0,0};             -- max. 9 liczb
   local arg0=0; 
   if(Rowtr.target < 2) then
      for w in string.gfind(lineL, "%d+") do
         arg0=arg0+1;
         wartab[arg0]=w;
      end;
   else
      for w in string.gmatch(lineL, "%d+") do
         arg0=arg0+1;
         wartab[arg0]=w;
      end;
   end
   if (arg0>0) then
      tekst=string.gsub(tekst, "$1", wartab[1]);
   end
   if (arg0>1) then
      tekst=string.gsub(tekst, "$2", wartab[2]);
   end
   if (arg0>2) then
      tekst=string.gsub(tekst, "$3", wartab[3]);
   end
   if (arg0>3) then
      tekst=string.gsub(tekst, "$4", wartab[4]);
   end
   if (arg0>4) then
      tekst=string.gsub(tekst, "$5", wartab[5]);
   end
   if (arg0>5) then
      tekst=string.gsub(tekst, "$6", wartab[6]);
   end
   if (arg0>6) then
      tekst=string.gsub(tekst, "$7", wartab[7]);
   end
   if (arg0>7) then
      tekst=string.gsub(tekst, "$8", wartab[8]);
   end
   if (arg0>8) then
      tekst=string.gsub(tekst, "$9", wartab[9]);
   end

   return tekst;
end
function Rowtr:ToolTipTranslator_IsItemStats(line,ind)                             -- lewy tekst
   local WT_isitemstat=false;
   local WT_trans="";
   local statPattern = "%d+%.?%d*"  
 
   if (string.find(line, "^++"..statPattern.." Strength$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Strength);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.Strength.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Strength);
     elseif (string.find(line, "^"..statPattern.." Armor$")) then WT_trans=Rowtr:GetStatFormatedStr(line,WT_ItemStats.Armor);
     elseif (string.find(line, "^"..statPattern.." "..WT_CustomLocale.Armor.."$")) then WT_trans=Rowtr:GetStatFormatedStr(line,WT_ItemStats.Armor);
     elseif (string.find(line, "^++"..statPattern.." Stamina$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Stamina);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.Stamina.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Stamina);
     elseif (string.find(line, "^++"..statPattern.." Agility$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Agility); 
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.Agility.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Agility); 
     elseif (string.find(line, "^++"..statPattern.." Intellect$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Intellect);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.Intellect.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Intellect);
     elseif (string.find(line, "^++"..statPattern.." Spirit$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Spirit);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.Spirit.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.Spirit);
     elseif (string.find(line, "^++"..statPattern.." Attack Power$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.AttackPower);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.AttackPower.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.AttackPower);
     elseif (string.find(line, "^++"..statPattern.." Spell Power$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.SpellPower);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.SpellPower.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.SpellPower);
     elseif (string.find(line, "^++"..statPattern.." Critical Strike$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.CriticalStrike);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.CriticalStrike.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.CriticalStrike);
     elseif (string.find(line, "^++"..statPattern.." Armor Penetration$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.ArmorPen);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.ArmorPen.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.ArmorPen);
     elseif (string.find(line, "^++"..statPattern.." Spell Penetration$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.SpellPen);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.SpellPen.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.SpellPen);
     elseif (string.find(line, "^++"..statPattern.." All Stats$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.AllStats);
     elseif (string.find(line, "^++"..statPattern.." "..WT_CustomLocale.AllStats.."$")) then WT_trans="+"..Rowtr:GetStatFormatedStr(line,WT_ItemStats.AllStats);
     elseif (string.find(line, ".+++"..statPattern.." .-$")) then WT_trans="$ignore"; -- ignore ALL untranslated gems/enchants.
   end	
   if (WT_trans~="") then
      WT_isitemstat=true;
   end
   if (QTRTTT_PS["isstat"] == "1" and WT_isitemstat and WT_trans~="$ignore") then 
     getglobal(QTR_GameTooltipTextLeft..ind):SetText(WT_trans);         -- podmieniamy tekst
   end
   return WT_isitemstat;
 end


function Rowtr:ToolTipTranslator_IsWeapon(line,ind)                            -- prawy tekst
  local WT_isweapon=false;
  local WT_trans="";
  if (line=="Axe") then WT_trans=WT_Weapon.Axe;
    elseif (line==WT_CustomLocale.Axe) then WT_trans=WT_Weapon.Axe;
    elseif (line=="Bow") then WT_trans=WT_Weapon.Bow;
    elseif (line==WT_CustomLocale.Bow) then WT_trans=WT_Weapon.Bow;
    elseif (line=="Dagger") then WT_trans=WT_Weapon.Dagger;
    elseif (line==WT_CustomLocale.Dagger) then WT_trans=WT_Weapon.Dagger;
    elseif (line=="Gun") then WT_trans=WT_Weapon.Gun;
    elseif (line==WT_CustomLocale.Gun) then WT_trans=WT_Weapon.Gun;
    elseif (line=="Mace") then WT_trans=WT_Weapon.Mace;
    elseif (line==WT_CustomLocale.Mace) then WT_trans=WT_Weapon.Mace;
    elseif (line=="Polearm") then WT_trans=WT_Weapon.Polearm;
    elseif (line==WT_CustomLocale.Polearm) then WT_trans=WT_Weapon.Polearm;
    elseif (line=="Shield") then WT_trans=WT_Weapon.Shield;
    elseif (line==WT_CustomLocale.Shield) then WT_trans=WT_Weapon.Shield;
    elseif (line=="Staff") then WT_trans=WT_Weapon.Staff;
    elseif (line==WT_CustomLocale.Staff) then WT_trans=WT_Weapon.Staff;
    elseif (line=="Sword") then WT_trans=WT_Weapon.Sword;
    elseif (line==WT_CustomLocale.Sword) then WT_trans=WT_Weapon.Sword;
    elseif (line=="Thrown") then WT_trans=WT_Weapon.Thrown;
    elseif (line==WT_CustomLocale.Thrown) then WT_trans=WT_Weapon.Thrown;
    elseif (line=="Wand") then WT_trans=WT_Weapon.Wand;
    elseif (line==WT_CustomLocale.Wand) then WT_trans=WT_Weapon.Wand;
    elseif (line=="Fist Weapon") then WT_trans=WT_Weapon.FirstW;
    elseif (line==WT_CustomLocale.FirstW) then WT_trans=WT_Weapon.FirstW;
    elseif (line=="Fishing Pole") then WT_trans=WT_Weapon.FishPole;
    elseif (line==WT_CustomLocale.FishPole) then WT_trans=WT_Weapon.FishPole;
    elseif (line=="Melee Range") then WT_trans=WT_Weapon.MeleeR;
    elseif (line==WT_CustomLocale.MeleeR) then WT_trans=WT_Weapon.MeleeR;
    elseif (line=="Arrow") then WT_trans=WT_InfoL.Arrow;
    elseif (line==WT_CustomLocale.Arrow) then WT_trans=WT_InfoL.Arrow;
    elseif (line=="Bullet") then WT_trans=WT_InfoL.Bullet;
    elseif (line==WT_CustomLocale.Bullet) then WT_trans=WT_InfoL.Bullet;
  end	
  if (WT_trans~="") then
     WT_isweapon=true;
  end
  if (QTRTTT_PS["weapon"] == "1" and WT_isweapon) then
    getglobal(QTR_GameTooltipTextRight..ind):SetText(WT_trans);         -- podmieniamy tekst
  end
  return WT_isweapon;
end


function Rowtr:ToolTipTranslator_IsMats(line,ind)                               -- prawy tekst
  local WT_ismats=false;
  local WT_trans="";
  if (line=="Cloth") then WT_trans=WT_Mats.Cloth;
    elseif (line==WT_CustomLocale.Cloth) then WT_trans=WT_Mats.Leather;
    elseif (line=="Leather") then WT_trans=WT_Mats.Leather;
    elseif (line==WT_CustomLocale.Leather) then WT_trans=WT_Mats.Leather;
    elseif (line=="Mail") then WT_trans=WT_Mats.Mail;
    elseif (line==WT_CustomLocale.Mail) then WT_trans=WT_Mats.Mail;
    elseif (line=="Plate") then WT_trans=WT_Mats.Plate;
    elseif (line==WT_CustomLocale.Plate) then WT_trans=WT_Mats.Plate;
  end	
  if (WT_trans~="") then
     WT_ismats=true;
  end
  if (QTRTTT_PS["mats"] == "1" and WT_ismats) then
    getglobal(QTR_GameTooltipTextRight..ind):SetText(WT_trans);         -- podmieniamy tekst
  end
  return WT_ismats;
end


function Rowtr:ToolTipTranslator_IsEnergy(line,ind)                             -- lewy tekst
  local WT_isener=false;
  local WT_trans="";
  if (string.sub(line,3,8)=="Energy") then WT_trans=string.sub(line,1,2)..WT_Energy.Energy;
    elseif(string.sub(line,3,(strlen(WT_CustomLocale.Energy)+2))==WT_CustomLocale.Energy) then WT_trans=string.sub(line,1,2)..WT_Energy.Energy;
    elseif (string.sub(line,4,9)=="Energy") then WT_trans=string.sub(line,1,3)..WT_Energy.Energy;
    elseif (string.sub(line,4,(strlen(WT_CustomLocale.Energy)+3))==WT_CustomLocale.Energy) then WT_trans=string.sub(line,1,3)..WT_Energy.Energy;
    elseif (string.sub(line,3,6)=="Rage") then WT_trans=string.sub(line,1,2)..WT_Energy.Rage;
    elseif (string.sub(line,3,(strlen(WT_CustomLocale.Rage)+2))==WT_CustomLocale.Rage) then WT_trans=string.sub(line,1,2)..WT_Energy.Rage;
    elseif (string.sub(line,4,7)=="Rage") then WT_trans=string.sub(line,1,3)..WT_Energy.Rage;
    elseif (string.sub(line,4,(strlen(WT_CustomLocale.Rage)+3))==WT_CustomLocale.Rage) then WT_trans=string.sub(line,1,3)..WT_Energy.Rage;
    elseif (string.sub(line,3,6)=="Mana") then WT_trans=string.sub(line,1,2)..WT_Energy.Mana;
    elseif (string.sub(line,3,(strlen(WT_CustomLocale.Mana)+2))==WT_CustomLocale.Mana) then WT_trans=string.sub(line,1,2)..WT_Energy.Mana;
    elseif (string.sub(line,4,7)=="Mana") then WT_trans=string.sub(line,1,3)..WT_Energy.Mana;
    elseif (string.sub(line,4,(strlen(WT_CustomLocale.Mana)+3))==WT_CustomLocale.Mana) then WT_trans=string.sub(line,1,3)..WT_Energy.Mana;
    elseif (string.sub(line,5,8)=="Mana") then WT_trans=string.sub(line,1,4)..WT_Energy.Mana;
    elseif (string.sub(line,5,(strlen(WT_CustomLocale.Mana)+4))==WT_CustomLocale.Mana) then WT_trans=string.sub(line,1,4)..WT_Energy.Mana;
    elseif (string.sub(line,6,9)=="Mana") then WT_trans=string.sub(line,1,5)..WT_Energy.Mana;
    elseif (string.sub(line,6,(strlen(WT_CustomLocale.Mana)+5))==WT_CustomLocale.Mana) then WT_trans=string.sub(line,1,5)..WT_Energy.Mana;
    elseif (string.sub(line,3,7)=="Focus") then WT_trans=string.sub(line,1,2)..WT_Energy.Focus;
    elseif (string.sub(line,3,(strlen(WT_CustomLocale.Focus)+2))==WT_CustomLocale.Focus) then WT_trans=string.sub(line,1,2)..WT_Energy.Focus;
    elseif (string.sub(line,4,8)=="Focus") then WT_trans=string.sub(line,1,3)..WT_Energy.Focus;
    elseif (string.sub(line,4,(strlen(WT_CustomLocale.Focus)+3))==WT_CustomLocale.Focus) then WT_trans=string.sub(line,1,3)..WT_Energy.Focus;
    elseif (string.sub(line,5,9)=="Focus") then WT_trans=string.sub(line,1,4)..WT_Energy.Focus;
    elseif (string.sub(line,5,(strlen(WT_CustomLocale.Focus)+4))==WT_CustomLocale.Focus) then WT_trans=string.sub(line,1,4)..WT_Energy.Focus;
  end	
  if (WT_trans~="") then
     WT_isener=true;
  end
  if (QTRTTT_PS["ener"] == "1" and WT_isener) then
    getglobal(QTR_GameTooltipTextLeft..ind):SetText(WT_trans);         -- podmieniamy tekst
  end
  return WT_isener;
end


function Rowtr:ToolTipTranslator_IsInfoR(line,ind)                             -- prawy tekst
  local WT_isinfo=false;
  local WT_trans="";
  if (line=="Channeled") then WT_trans=WT_InfoR.Channeled;
    elseif (line==WT_CustomLocale.Channeled) then WT_trans=WT_InfoR.Channeled;
    elseif (line=="Instant cast") then WT_trans=WT_InfoR.InstCast;
    elseif (line==WT_CustomLocale.InstCast) then WT_trans=WT_InfoR.InstCast;
    elseif (line=="Instant") then WT_trans=WT_InfoR.Instant;
    elseif (line==WT_CustomLocale.Instant) then WT_trans=WT_InfoR.Instant;
    elseif (line=="Idol") then WT_trans=WT_InfoR.Idol;
    elseif (line==WT_CustomLocale.Idol) then WT_trans=WT_InfoR.Idol;
    elseif (line=="Libram") then WT_trans=WT_InfoR.Libram;
    elseif (line==WT_CustomLocale.Libram) then WT_trans=WT_InfoR.Libram;
    elseif (line=="Totem") then WT_trans=WT_InfoR.Totem;
    elseif (line==WT_CustomLocale.Totem) then WT_trans=WT_InfoR.Totem;
    elseif (line=="Sigil") then WT_trans=WT_InfoR.Sigil;
    elseif (line==WT_CustomLocale.Sigil) then WT_trans=WT_InfoR.Sigil;
    elseif ((string.len(line)<16) and (string.sub(line,-5)=="range")) then
       WT_trans=string.sub(line,1,string.len(line)-5)..WT_InfoR.Range;
    elseif (string.sub(line,(strlen(WT_CustomLocale.Range)+1))==" "..WT_CustomLocale.Range) then
         WT_trans=string.sub(line,1,string.len(line)-strlen(WT_CustomLocale.Range))..WT_InfoR.Range;
  end	
  if (WT_trans~="") then
     WT_isinfo=true;
  end
  if (QTRTTT_PS["info"] == "1" and WT_isinfo) then
    getglobal(QTR_GameTooltipTextRight..ind):SetText(WT_trans);        -- podmieniamy tekst
  end
  return WT_isinfo;
end


function Rowtr:ToolTipTranslator_ChangeText(txt,ind)
  local color="";
  if (string.sub(txt,3,3)=="#") then                               -- jest kod koloru w tłumaczeniu
     color=string.lower(string.sub(txt,1,2));                      -- odczytaj kod tego koloru
     txt=string.sub(txt,4);                                        -- pozostaw sam tekst, bez kodu koloru
  end
  local WT_pos=string.find(txt, "|");
  if (WT_pos) then                                     -- jest znak podziału linii na lewą i prawą część
     local color2=color;
     if (string.sub(txt,3,3)=="#") then                            -- jest kod koloru dla prawego tekstu
        color=string.lower(string.sub(txt,1,2));                   -- odczytaj kod tego koloru
        txt=string.sub(txt,4);                                     -- sam tekst, bez kodu koloru
     end
     local WT_pos=string.find(txt, "|");
     local WT_rightText=string.sub(txt,WT_pos+1);
     txt=string.sub(txt,1,WT_pos-1);
     getglobal(QTR_GameTooltipTextRight..ind):SetText(WT_rightText); -- podmieniamy tekst
     if (strlen(color)>0) then                                     -- trzeba zmienić kolor linii
        getglobal(QTR_GameTooltipTextRight..ind):SetTextColor(WT_colors[color2].r,WT_colors[color2].g,WT_colors[color2].b,1);
     end
  end
  getglobal(QTR_GameTooltipTextLeft..ind):SetText(txt);              -- podmieniamy tekst
  if (strlen(color)>0) then                                        -- trzeba zmienić kolor linii
     getglobal(QTR_GameTooltipTextLeft..ind):SetTextColor(WT_colors[color].r,WT_colors[color].g,WT_colors[color].b,1);
  end                                                              -- podmieniamy kolor
end


function Rowtr:ToolTipTranslator_CheckMoneyFrame()
  if (getglobal(QTR_GameTooltipMoneyFrame1PrefixText)) then                            -- czy występuje sekcja 1 "Sell Price"
     if (QTR_GameTooltip:GetWidth()<160) then
        getglobal(QTR_GameTooltipMoneyFrame1PrefixText):SetText(WT_InfoL.PriceShort);  -- podmień tekst
     else
        getglobal(QTR_GameTooltipMoneyFrame1PrefixText):SetText(WT_InfoL.PriceLong);   -- podmień tekst
     end
  end
  if (getglobal(QTR_GameTooltipMoneyFrame2PrefixText)) then                            -- czy występuje sekcja 2 "Sell Price"
     if (QTR_GameTooltip:GetWidth()<160) then
        getglobal(QTR_GameTooltipMoneyFrame2PrefixText):SetText(WT_InfoL.PriceShort);  -- podmień tekst
     else
        getglobal(QTR_GameTooltipMoneyFrame2PrefixText):SetText(WT_InfoL.PriceLong);   -- podmień tekst
     end
  end
end


function Rowtr:ToolTipTranslator_ChangeSpell(ID)
  local WT_ln=0;                              -- licznik odczytanych linii tłumaczeń
  local WT_lines;
  if(WT_Spells[ID]) then
   WT_lines=WT_Spells[ID]["Lines"];  -- tyle jest linii z tłumaczeniem tego spella
  else
   WT_lines=QTR_FIXEDSPELL[ID]["Lines"];     -- tyle jest linii z tłumaczeniem tego spella
  end

  for i = 1, QTR_GameTooltip:NumLines(), 1 do
      local lineL=getglobal(QTR_GameTooltipTextLeft..i):GetText();   -- odczyt lewej linii
      local lineR="";
      if (getglobal(QTR_GameTooltipTextRight..i)) then
	     if (getglobal(QTR_GameTooltipTextRight..i):GetText()) then
            lineR=getglobal(QTR_GameTooltipTextRight..i):GetText();  -- odczyt prawej linii
         end
      end
      if (Rowtr:ToolTipTranslator_IsInfoL(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsBody(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsEnergy(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      else
         WT_ln=WT_ln+1;
         if (WT_ln>WT_lines) then                             -- oryginalnie jest więcej linii
            if (lineL~=" ") then                              -- pozostawiamy je bez zmian
                if (QTRTTT_PS["compOR"]=="1") then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.original..i..":"..lineL);
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.translat..i..":"..WT_Messages.nothing);
                end
            end
         else
            local tekst;
            if(WT_Spells[ID]) then
               tekst=WT_Spells[ID]["Line"..WT_ln];         -- jest kolejna linia z tłumaczeniem
            else
               tekst=QTR_FIXEDSPELL[ID]["Line"..WT_ln];
            end
            if (tekst~="$notranslate") then                   -- nie ma w tej linii zakazu tłumaczenia
                local wartab={0,0,0,0,0,0,0,0,0};             -- max. 9 liczb
                local arg0=0;
                if (getglobal(QTR_GameTooltipTextRight..i):GetText()) then
                   local lineR=getglobal(QTR_GameTooltipTextRight..i):GetText();  -- odczyt prawej linii
                   lineL=lineL.."|"..lineR;
                end
                for w in string.gmatch(lineL, "%d+") do
                   arg0=arg0+1;
                   wartab[arg0]=w;
                end;
                if (arg0>0) then
                   tekst=string.gsub(tekst, "$1", wartab[1]);
                end
                if (arg0>1) then
                   tekst=string.gsub(tekst, "$2", wartab[2]);
                end
                if (arg0>2) then
                   tekst=string.gsub(tekst, "$3", wartab[3]);
                end
                if (arg0>3) then
                   tekst=string.gsub(tekst, "$4", wartab[4]);
                end
                if (arg0>4) then
                   tekst=string.gsub(tekst, "$5", wartab[5]);
                end
                if (arg0>5) then
                   tekst=string.gsub(tekst, "$6", wartab[6]);
                end
                if (arg0>6) then
                   tekst=string.gsub(tekst, "$7", wartab[7]);
                end
                if (arg0>7) then
                   tekst=string.gsub(tekst, "$8", wartab[8]);
                end
                if (arg0>8) then
                   tekst=string.gsub(tekst, "$9", wartab[9]);
                end
                Rowtr:ToolTipTranslator_ChangeText(tekst,i);
                if (QTRTTT_PS["compOR"]=="1") then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.original..i..":"..lineL);
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.translat..i..":"..tekst);
                end
            end
        end
     end
  end
  if (WT_ln<WT_lines) then                                 -- oryginał miał mniej linii
     local nrLinii=QTR_GameTooltip:NumLines();
     for i = WT_ln+1, WT_lines, 1 do
        local tekst;
        if(WT_Spells[ID]) then
         tekst=WT_Spells[ID]["Line"..i];         -- jest kolejna linia z tłumaczeniem
        else
          tekst=QTR_FIXEDSPELL[ID]["Line"..i];
        end       -- kolejna linia z tłumaczeniem
        local kolor="c1";		                           -- kolor domyślny (biały)
        if (string.sub(tekst,3,3)=="#") then               -- jest kod koloru
           kolor=string.lower(string.sub(tekst,1,2));      -- odczytaj kod tego koloru
           tekst=string.sub(tekst,4);                      -- sam tekst, bez kodu koloru
        end
        nrLinii=nrLinii+1;
        local WT_pos=string.find(tekst, "|");
        if (WT_pos) then                                   -- jest znak podziału linii na lewą i prawą część
           local kolor2=kolor1;
           if (string.sub(tekst,3,3)=="#") then            -- jest drugi kolor dla prawego tekstu
              kolor2=string.lower(string.sub(tekst,1,2));  -- odczytaj kod tego koloru
              tekst=string.sub(tekst,4);                   -- sam tekst, bez kodu koloru
           end
           local WT_pos=string.find(tekst, "|");
           local WT_rightText=string.sub(tekst,WT_pos+1);
           local tekst=string.sub(tekst,1,WT_pos-1);
           QTR_GameTooltip:AddDoubleLine(tekst,WT_rightText,WT_colors[kolor].r,WT_colors[kolor].g,WT_colors[kolor].b,WT_colors[kolor2].r,WT_colors[kolor2].g,WT_colors[kolor2].b);
        else
           QTR_GameTooltip:AddLine(tekst,WT_colors[kolor].r,WT_colors[kolor].g,WT_colors[kolor].b,1);
        end
     end
  end

  Rowtr:ToolTipTranslator_CheckMoneyFrame();
  QTR_GameTooltip:Show();                         -- odśwież wyświetloną ramkę
end


function Rowtr:ToolTipTranslator_ChangeItem(ID)
  local WT_ln=0;                              -- licznik odczytanych linii tłumaczeń
  local WT_lines;
  if(WT_Items[ID]) then
   WT_lines =WT_Items[ID]["Lines"];       -- tyle jest linii z tłumaczeniem tego Itemu
  else
   WT_lines =QTR_FIXEDITEM[ID]["Lines"]; 
  end

  for i = 1, QTR_GameTooltip:NumLines(), 1 do                        -- najpierw lecimy po liniach oryginału
      local lineL=getglobal(QTR_GameTooltipTextLeft..i):GetText();  -- odczyt lewej linii
      local lineR="";
      if (getglobal(QTR_GameTooltipTextRight..i)) then
	     if (getglobal(QTR_GameTooltipTextRight..i):GetText()) then
            lineR=getglobal(QTR_GameTooltipTextRight..i):GetText(); -- odczyt prawej linii
         end
      end 
      if (Rowtr:ToolTipTranslator_IsInfoL(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsBody(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsEnergy(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsItemStats(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      else
         WT_ln=WT_ln+1;                                       -- kolejna linia z tłumaczeniem
         if (WT_ln>WT_lines) then                             -- oryginalnie jest więcej linii
            if (lineL~=" ") then                              -- pozostawiamy je bez zmian
                if (QTRTTT_PS["compOR"]=="1") then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.original..i..":"..lineL);
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.translat..i..":"..WT_Messages.nothing);
                end
            end;
         else
            local tekst;          -- jest kolejna linia z tłumaczeniem
            if(WT_Items[ID]) then
               tekst=WT_Items[ID]["Line"..WT_ln];
            else
               tekst=QTR_FIXEDITEM[ID]["Line"..WT_ln];
            end
            if (tekst~="$notranslate") then                   -- nie ma w tej linii zakazu tłumaczenia
                local wartab={0,0,0,0,0,0,0,0,0};             -- max. 9 liczb
                local arg0=0;
                if (getglobal(QTR_GameTooltipTextRight..i):GetText()) then
                   local lineR=getglobal(QTR_GameTooltipTextRight..i):GetText();  -- odczyt prawej linii
                   lineL=lineL.."|"..lineR;
                end
                for w in string.gmatch(lineL, "%d+") do
                   arg0=arg0+1;
                   wartab[arg0]=w;
                end;
                if (arg0>0) then
                   tekst=string.gsub(tekst, "$1", wartab[1]);
		        end
                if (arg0>1) then
                   tekst=string.gsub(tekst, "$2", wartab[2]);
                end
                if (arg0>2) then
                   tekst=string.gsub(tekst, "$3", wartab[3]);
                end
                if (arg0>3) then
                   tekst=string.gsub(tekst, "$4", wartab[4]);
                end
                if (arg0>4) then
                   tekst=string.gsub(tekst, "$5", wartab[5]);
                end
                if (arg0>5) then
                   tekst=string.gsub(tekst, "$6", wartab[6]);
                end
                if (arg0>6) then
                   tekst=string.gsub(tekst, "$7", wartab[7]);
                end
                if (arg0>7) then
                   tekst=string.gsub(tekst, "$8", wartab[8]);
                end
                if (arg0>8) then
                   tekst=string.gsub(tekst, "$9", wartab[9]);
                end
                if (ID=="6948") then           -- Hearthstone
                   local WTR_enddot=string.find(lineL,"  ",21);
                   local WTR_currhome=string.sub(lineL,21,WTR_enddot-2);
                   tekst=string.gsub(tekst, "$homelocation", WTR_currhome);
                end
                Rowtr:ToolTipTranslator_ChangeText(tekst,i);
                if (QTRTTT_PS["compOR"]=="1") then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.original..i..":"..lineL);
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WT_Messages.translat..i..":"..tekst);
                end
            end
         end
      end
  end
  if (WT_ln<WT_lines) then                                 -- oryginał miał mniej linii lub wyczyszczono linie
     local nrLinii=QTR_GameTooltip:NumLines();
     for i = WT_ln+1, WT_lines, 1 do
        local tekst;
        if(WT_Items[ID]) then
            tekst=WT_Items[ID]["Line"..i];
         else
            tekst=QTR_FIXEDITEM[ID]["Line"..i];
         end              -- kolejna linia z tłumaczeniem
        local kolor="c1";		                           -- kolor domyślny (biały)
        if (string.sub(tekst,3,3)=="#") then               -- jest kod koloru
           kolor=string.lower(string.sub(tekst,1,2));      -- odczytaj kod tego koloru
           tekst=string.sub(tekst,4);                      -- sam tekst, bez kodu koloru
        end
        nrLinii=nrLinii+1;
        local WT_pos=string.find(tekst, "|");  
        if (WT_pos) then                                   -- jest znak podziału linii na lewą i prawą część
           local kolor2=kolor1;
           if (string.sub(tekst,3,3)=="#") then            -- jest drugi kolor dla prawego tekstu
              kolor2=string.lower(string.sub(tekst,1,2));  -- odczytaj kod tego koloru
              tekst=string.sub(tekst,4);                   -- sam tekst, bez kodu koloru
           end
           local WT_pos=string.find(tekst, "|");
           local WT_rightText=string.sub(tekst,WT_pos+1);
           local tekst=string.sub(tekst,1,WT_pos-1);
           QTR_GameTooltip:AddDoubleLine(tekst,WT_rightText,WT_colors[kolor].r,WT_colors[kolor].g,WT_colors[kolor].b,WT_colors[kolor2].r,WT_colors[kolor2].g,WT_colors[kolor2].b);
        else
           QTR_GameTooltip:AddLine(tekst,WT_colors[kolor].r,WT_colors[kolor].g,WT_colors[kolor].b,1);
           if (nrLinii==1) then                          -- linia nr 1: trzeba większą czcionką
           else
           end
        end
     end
  end 
  Rowtr:ToolTipTranslator_CheckMoneyFrame()
  QTR_GameTooltip:Show();                                  -- odśwież wyświetloną ramkę
end


function Rowtr:ToolTipTranslator_TryTranslation()
  for i = 1, QTR_GameTooltip:NumLines(), 1 do                        -- lecimy po liniach oryginału

     local lineL=getglobal(QTR_GameTooltipTextLeft..i):GetText();  -- odczyt lewej linii
      local lineR="";
      if (getglobal(QTR_GameTooltipTextRight..i)) then
	     if (getglobal(QTR_GameTooltipTextRight..i):GetText()) then
            lineR=getglobal(QTR_GameTooltipTextRight..i):GetText(); -- odczyt prawej linii
         end
      end 
      if (Rowtr:ToolTipTranslator_IsInfoL(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsBody(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsEnergy(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      elseif (Rowtr:ToolTipTranslator_IsItemStats(lineL,i)==true) then
         if (lineR~="") then
            if (Rowtr:ToolTipTranslator_IsWeapon(lineR,i)==false) then
               if (Rowtr:ToolTipTranslator_IsMats(lineR,i)==false) then
                  Rowtr:ToolTipTranslator_IsInfoR(lineR,i);
               end
            end
         end
      end
   end
   Rowtr:ToolTipTranslator_CheckMoneyFrame()
   QTR_GameTooltip:Show();                                  -- odśwież wyświetloną ramkę
end

function Rowtr:ToolTipTranslator_ResetChangedTooltipValues()
   for i = 1, table.getn(WT_TTReset), 1 do
      if(getglobal(QTR_GameTooltipTextLeft..WT_TTReset[i]["ID"])) then
         getglobal(QTR_GameTooltipTextLeft..WT_TTReset[i]["ID"]):SetFont(WT_TTReset[i]["itFont"], WT_TTReset[i]["itSize"]) 
      end
   end
   WT_TTReset = {};

   for i = 1, 2, 1 do -- lol why not
      if(_G["ShoppingTooltip"..i]) then
         HideUIPanel(_G["ShoppingTooltip"..i]); -- for some weird reason, this frame stays open even after the item frame on shop gets closed.
      end
   end
   
   
end


function Rowtr:ToolTipTranslator_ShowTranslationG()
   QTR_GameTooltip = GameTooltip;
   QTR_GameTooltipTextLeft = "GameTooltipTextLeft"
   QTR_GameTooltipTextLeft1 = "GameTooltipTextLeft1"
   QTR_GameTooltipTextRight = "GameTooltipTextRight"
   QTR_GameTooltipMoneyFrame1PrefixText = "GameTooltipMoneyFrame1PrefixText"
   QTR_GameTooltipMoneyFrame2PrefixText = "GameTooltipMoneyFrame1PrefixText"
   Rowtr:ToolTipTranslator_ShowTranslation()
end
function Rowtr:ToolTipTranslator_ShowTranslationR()
   QTR_GameTooltip = ItemRefTooltip;
   QTR_GameTooltipTextLeft = "ItemRefTooltipTextLeft"
   QTR_GameTooltipTextLeft1 = "ItemRefTooltipTextLeft1"
   QTR_GameTooltipTextRight = "ItemRefTooltipTextRight"
   QTR_GameTooltipMoneyFrame1PrefixText = "ItemRefTooltipMoneyFrame1PrefixText"
   QTR_GameTooltipMoneyFrame2PrefixText = "ItemRefTooltipMoneyFrame1PrefixText"
   Rowtr:ToolTipTranslator_ResetChangedTooltipValues()
   Rowtr:ToolTipTranslator_ShowTranslation()
end
function Rowtr:ToolTipTranslator_ShowTranslationA()
   QTR_GameTooltip = AtlasLootTooltip;
   QTR_GameTooltipTextLeft = "AtlasLootTooltipTextLeft"
   QTR_GameTooltipTextLeft1 = "AtlasLootTooltipTextLeft1"
   QTR_GameTooltipTextRight = "AtlasLootTooltipTextRight"
   QTR_GameTooltipMoneyFrame1PrefixText = "AtlasLootTooltipMoneyFrame1PrefixText"
   QTR_GameTooltipMoneyFrame2PrefixText = "AtlasLootTooltipMoneyFrame1PrefixText"
   Rowtr:ToolTipTranslator_ShowTranslation()
end

function Rowtr:ToolTipTranslator_ShowTranslationS(i)
   QTR_GameTooltip = _G["ShoppingTooltip"..i];
   QTR_GameTooltipTextLeft = "ShoppingTooltip"..i.."TextLeft"
   QTR_GameTooltipTextLeft1 = "ShoppingTooltip"..i.."TextLeft1"
   QTR_GameTooltipTextRight = "ShoppingTooltip"..i.."TextRight"
   QTR_GameTooltipMoneyFrame1PrefixText = "ShoppingTooltip"..i.."MoneyFrame1PrefixText"
   QTR_GameTooltipMoneyFrame2PrefixText = "ShoppingTooltip"..i.."MoneyFrame2PrefixText"
   Rowtr:ToolTipTranslator_ShowTranslation()
end


function Rowtr:ToolTipTranslator_ShowTranslation()
  
   if (QTRTTT_PS["active"]=="1") then
      if (QTRTTT_PS["try"]=="1") then
         Rowtr:ToolTipTranslator_TryTranslation();
      end
      if(QTRTTT_PS["questHelp"]=="1") then  
         local itemID = GetItemIDByName(getglobal(QTR_GameTooltipTextLeft1):GetText());
         if(itemID) then
            if(WT_QuestItemTemp[tostring(itemID)]) then
               local itR,itG,itB,itA = getglobal(QTR_GameTooltipTextLeft1):GetTextColor();
               local itFont, itFontSize = getglobal(QTR_GameTooltipTextLeft1):GetFont();
               QTR_GameTooltip:AddLine(" ",0,0,0);
               QTR_GameTooltip:AddLine(WT_QuestItemTemp[tostring(itemID)]["Title"],itR,itG,itB); 

               for itt = 1, QTR_GameTooltip:NumLines(), 1 do
                  if(getglobal(QTR_GameTooltipTextLeft..itt):GetText() == WT_QuestItemTemp[tostring(itemID)]["Title"]) then 
                     local storedFont, storedSize = getglobal(QTR_GameTooltipTextLeft..itt):GetFont();
                     getglobal(QTR_GameTooltipTextLeft..itt):SetFont(itFont, itFontSize);
                     local numba = table.getn(WT_TTReset)+1;
                     WT_TTReset[numba]={}
                     WT_TTReset[numba]["ID"] = itt;
                     WT_TTReset[numba]["itFont"] = storedFont;
                     WT_TTReset[numba]["itSize"] = storedSize;
                  end
               end
            end
            if (QTRTTT_PS["showID"]=="1") then
               if(QTRTTT_PS["questHelp"]=="0" or not WT_QuestItemTemp[tostring(itemID)]) then
                  QTR_GameTooltip:AddLine(" ",0,0,0);  
               end                         -- dodaj odstęp i itemID
               if (QTRTTT_PS["try"]=="1") then
                  QTR_GameTooltip:AddDoubleLine("Item ID: "..itemID,"try",0,1,1,0,1,1);
               else
                  QTR_GameTooltip:AddLine("Item ID: "..itemID,0,1,1);
               end
               QTR_GameTooltip:Show();                                       -- odśwież wyświetloną ramkę
            end
            QTR_GameTooltip:Show();   
         else 
           local targetNPC, wt_UnitName = GetTranslatedMobInfo(getglobal(QTR_GameTooltipTextLeft1):GetText())
           if(wt_UnitName) then  
               local npR, npG, npB, npA = getglobal(QTR_GameTooltipTextLeft1):GetTextColor(); 
               local itFont, itFontSize = getglobal(QTR_GameTooltipTextLeft1):GetFont();
               QTR_GameTooltip:AddLine(" ",0,0,0);                           
               QTR_GameTooltip:AddLine(wt_UnitName, npR, npG, npB);
               for itt = 1, QTR_GameTooltip:NumLines(), 1 do
                  if(getglobal(QTR_GameTooltipTextLeft..itt):GetText() == wt_UnitName) then 
                     local storedFont, storedSize = getglobal(QTR_GameTooltipTextLeft..itt):GetFont();
                     getglobal(QTR_GameTooltipTextLeft..itt):SetFont(itFont, itFontSize);
                     local numba = table.getn(WT_TTReset)+1;
                     WT_TTReset[numba]={}
                     WT_TTReset[numba]["ID"] = itt;
                     WT_TTReset[numba]["itFont"] = storedFont;
                     WT_TTReset[numba]["itSize"] = storedSize;
                  end
               end 

               if (QTRTTT_PS["showID"]=="1") then 
                  QTR_GameTooltip:AddLine("NPC ID: "..targetNPC,0,1,1);
               end

               QTR_GameTooltip:Show();
            end
         end 
      end
   end
end