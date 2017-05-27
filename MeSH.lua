-- städa koden


-- Healing spell --

-- Lesser Heal(Rank 1-3) - one target heal
-- Heal(Rank 1-4) - one target heal
-- Grater Heal(Rank 1-5) - one target heal

-- Flash Heal(Rank 1-7) - one target heal
-- Renew(Rank 1-10) - heal over time
-- Desperate Prayer (Rank 1-5) - self heal only
-- Prayer of Healing(Rank 1-5) - aoe heal
-- Binding heal (Self and target)

-- Cure --

-- Cure Disease - off/incombat
-- Resuraction (Rank 1-5) -- offcombat
-- Dispel Magic(Rank 1-2) -- off/incombat

-- Protection --
-- Power Word: Shield (Rank 1-10) -- pre/incombat
-- Power Word: Fortitude (Rank 6) -- precombat
-- Prayer of Fortitute (Rank 2) -- precombat
-- Lightwell(Rank 3) - offcombat


-- bra att hittat
-- button.clickable = 1;




function MeSHinit()
  ChatFrame1:AddMessage( MeSHtext['loaded'] , 1.0, 1.0, 0.0, 1.0);

  SLASH_MeSH1 = "/mesh";
  SlashCmdList["MeSH"] = function (msg)
    cmd, param = MeSHcommandFormat( msg );

    if cmd == "reload" then
      ReloadUI();
    elseif cmd == "info" then
      if not UnitIsPlayer("target") then
        return;
      end

      local name, server = GetUnitName("target");
      local class = UnitClass("target");
      local power = UnitMana("target");
      local powe = UnitManaMax("target");
      local hp = UnitHealth("target");
      local hpMax = UnitHealthMax("target");

      ChatFrame1:AddMessage( name .. " (" .. class .. ")" , 1.0, 1.0, 0.0, 1.0);
      ChatFrame1:AddMessage( "Health: " .. hp .. "/" .. hpMax , 1.0, 1.0, 0.0, 1.0);
      ChatFrame1:AddMessage( "Mana/Rage: " .. power .. "/" .. powerMax , 1.0, 1.0, 0.0, 1.0);
    else
      --ChatFrame1:AddMessage( ghostText['slashHelp'] , 1.0, 1.0, 0.0, 1.0);
    end
  end
  local title = CreateFrame("Button", "MeSH1", UIParent )
  title:SetMovable(1)
  title:RegisterForClicks("AnyUp", "AnyDown")
  title:EnableMouse(1)
--  title:SetScript("OnMouseDown",function()
  --      this:StartMoving();
--    end)
  --title:SetScript("ç",function() this:StopMovingOrSizing() end)
  title:SetPoint("CENTER",0, -100)
  title:SetWidth(180)
  title:SetHeight(20)

  --title:SetScript("OnMouseup", function()
--    this:StopMovingOrSizing();
--  end)
  title:SetScript("OnClick", function()
    ChatFrame1:AddMessage( "Mesh Button Click: " .. arg1 , 1.0, 1.0, 0.0, 1.0);
--
   if arg1 == "LeftButton" and IsShiftKeyDown()  then
      CastSpellByName("Lesser Heal(Rank 3)");
  elseif arg1 == "LeftButton" and IsAltKeyDown() then
      CastSpellByName("Renew(Rank 2)");
  elseif arg1 == "LeftButton" then
      CastSpellByName("Power Word: Fortitude(Rank 2)");
    end
  end)


  -- shiftDown = IsShiftKeyDown();
  -- ctrlDown  = IsControlKeyDown();
  -- altDown   = IsAltKeyDown();

  title:SetBackdrop( { edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 } )
	local back = title:CreateTexture(nil,"BACKGROUND")
	back:SetTexture("Interface\\TutorialFrame\\TutorialFrameBackground")
	back:SetPoint("TOPLEFT",title,"TOPLEFT",3,-3)
	back:SetPoint("BOTTOMRIGHT",title,"BOTTOMRIGHT",-3,3)

  title.title = title:CreateFontString("MeSH_Target", "OVERLAY")
  title.title:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
  title.title:SetTextColor(1, 1, 0, .8)
  title.title:SetPoint("TOP", title, "TOP", 0, -1)
  title.title:SetText("")


end

-- Cut string in half at the first blankspace

function MeSHcommandFormat( msg )
  if msg and strlen(msg) > 0 then
    msg = string.lower(msg)
  else
    msg = ""
  end

  local i, j, cmd, param = string.find(msg, "^([^ ]+) (.+)$")

  if not cmd then
    cmd = msg
  end

  if not cmd then
    cmd = ""
  end

  if not param then
    param = ""
  end

  return cmd, param;
end

-- Slash lock command

-- function slashCommandLock( param )

-- end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("UNIT_COMBAT")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
      MeSHinit();
      if UnitIsPlayer("target") then
        local name, realm = UnitName("target")
        local gText = format("MeSH_Target");
        getglobal(gText):SetText( name );
      else
        local name, realm = UnitName("player")
        local gText = format("MeSH_Target");
        getglobal(gText):SetText( name );
      end
    end

    -- Only fire then Player change target, not party members
    if event == "PLAYER_TARGET_CHANGED" then
      -- DEFAULT_CHAT_FRAME:AddMessage(format(event))
      if UnitIsPlayer("target") then
        local name, realm = UnitName("target")
        local gText = format("MeSH_Target");
        getglobal(gText):SetText( name );
      else
        local name, realm = UnitName("player")
        local gText = format("MeSH_Target");
        getglobal(gText):SetText( name );
      end
    end

    -- Only fire then "player" dies. Only your self?
    if event == "PLAYER_DEAD" then
      MeSHprintMessageToChat( "You Died", "MeSH" );
    end

    -- Enter combat
    if event == "PLAYER_REGEN_DISABLED" then
      MeSHprintMessageToChat( "You entered combat", "MeSH" );
    end

    -- leave combat
    if event == "PLAYER_REGEN_ENABLED" then
      MeSHprintMessageToChat( "You left combat", "MeSH" );
    end

    -- Then a buff or debuff change. Both gain and fade. arg1 == unitid
    if event == "UNIT_AURA" then
      local msg = arg1 .. " buff/debuff changed";
      MeSHprintMessageToChat( msg, "MeSH")
    end



    -- Unit in combat.
    if event == "UNIT_COMBAT" then
      -- arg1 - unitid
      -- arg2 - special (heal, etc.)
      -- arg3 - indicator (crit etc.)
      -- arg4 - damage
      -- arg5 - type of damage
      local damageType = {}
      damageType[0] = "Physical";
      damageType[1] = "Holy";
      damageType[2] = "none";
      damageType[4] = "Frost";
      damageType[5] = "Shadow";
      damageType[8] = "nature";
      damageType[16] = "frost";
      damageType[64] = "arcane";

      local name, realm = UnitName( arg1 )

      msg = name .. " took " .. arg4 .. " in ".. arg2 .. " ( " .. damageType[arg5] .. "("..arg5..") " .. arg3 .. ")"
      MeSHprintMessageToChat( msg , "MeSH");

      -- den här kan uppdatera rutan.
    end
  end)

-- Function to print
function MeSHprintMessageToChat( msg, chat )
  if not chat then
    chat = "default"
  end

  local time = date("%H:%M:%S")
  msg = time .. " " .. msg

  if chat == "default" then
    DEFAULT_CHAT_FRAME:AddMessage( msg )
  elseif chat == "MeSH" then
    ChatFrame3:AddMessage( msg )
  else
    DEFAULT_CHAT_FRAME:AddMessage( "MeSH: Chat error" )
  end
end

local function AddMessageToTab(tabName,...)
  local tab = 1
  for i = 1,10 do
    if GetChatWindowInfo(i)==tabName then
      tab = i
      break
    end
  end
--  _G["ChatFrame"..tab]:AddMessage(...)
end


local b = CreateFrame("Button", "TestButton", UIParent, "UIPanelButtonTemplate2")
b:SetPoint("CENTER", 0, 0)
b:RegisterForClicks("AnyUp", "AnyDown")
local upDown = { [false] = "Up", [true] = "Down" }
local function show(text, color)
  DEFAULT_CHAT_FRAME:AddMessage(text, color, color, color)
end
local color
b:SetScript("OnMouseDown", function()
  color = .60
  button = "est"
      CastSpellByName("Lesser Heal(Rank 3)");
  show(format("OnMouseDown: %s", arg1), color, color, color)
end)

-- MACRO

-- /cast [@focus] Polymorph

-- UNIT / TARGET

-- FocusUnit("unit")
-- ClearFocus()
-- TargetUnit("unit")
-- UnitAffectingCombat("unit")
-- UnitAura("unit", index [, filter])
-- UnitBuff("unit", index [,raidFilter])
-- UnitDebuff("unit", index [,raidFilter])
-- UnitExists("unit")
-- UnitIsAFK("unit")
-- UnitInRange("unit")
-- UnitIsCharmed("unit")
-- UnitIsConnected("unit")
-- UnitIsCorpse("unit")
-- UnitIsDead("unit")
-- UnitIsDeadOrGhost("unit")
-- UnitIsDND("unit")
-- UnitIsPlayer("unit")
-- UnitIsPVP("unit")
-- UnitIsVisible("unit")
-- UnitRace("unit")
-- UnitSex("unit")
-- UnitStat("unit", statIndex)
--name, realm = UnitName("unit")

-- PARTY/ RAID

-- CastSpell(spellID, "bookType")
-- CastSpellByName("name"[, onSelf])
-- GetSpellCooldown(spellName | spellID, "bookType")
-- GetSpellPowerCost(spellID)
-- IsSpellInRange("spellName", [unit])

-- SPELL

-- GetRaidRosterInfo(raidIndex)
-- GetNumPartyMembers()
-- GetNumRaidMembers()
-- GetPartyLeaderIndex()

-- EVENT

-- PLAYER_DEAD
-- PLAYER_ALIVE
-- PLAYER_UNGHOST
-- PARTY_LEADER_CHANGED
-- PARTY_MEMBERS_CHANGED
-- PARTY_MEMBER_DISABLE
-- PARTY_MEMBER_ENABLE
-- UNIT_AURA
-- PLAYER_FOCUS_CHANGED
-- PLAYER_ENTER_COMBAT
-- PLAYER_CONTROL_LOST
-- PLAYER_CONTROL_GAINED
-- PLAYER_REGEN_DISABLED
-- PLAYER_REGEN_ENABLED
-- PLAYER_TARGET_CHANGED
-- PLAYER_ENTERING_WORLD
-- PLAYER_FLAGS_CHANGED (arg1)
-- PLAYER_LEVEL_UP (arg1)
-- CURRENT_SPELL_CAST_CHANGED
-- SPELL_UPDATE_USABLE
-- UNIT_SPELLCAST_FAILED
-- ADDON_LOADED
-- PLAYER_ENTERING_WORLD
-- PLAYER_LEAVING_WORLD
-- PLAYER_LOGIN"
-- PLAYER_LOGOUT
-- PLAYER_QUITING
-- VARIABLES_LOADED
-- PLAYER_TARGET_CHANGED
-- UNIT_ATTACK (arg1)
-- UNIT_HEALTH
-- UNIT_MANA (arg1)
-- UNIT_MAXENERGY
-- UNIT_MAXHEALTH
-- UNIT_MAXMANA
-- UNIT_MODEL_CHANGED
-- UNIT_POWER
-- UNIT_SPELLCAST_INTERRUPTED
-- UNIT_SPELLCAST_START
-- UNIT_SPELLCAST_STOP
-- UNIT_SPELLCAST_SUCCEEDED
-- UNIT_TARGET
