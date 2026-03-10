local MM_Initialized = false

--
-- Global variable for storage of settings/options
--

MiniMageOptions = { };

--
-- Initialization functions
--

function class_OnLoad()
    MM_class = UnitClass("player");
    if (MM_class ~= "Mage") then
        this:Hide();
    end
end

function MM_Initialize()
    if MM_Initialized then return end
    MM_Initialized = true
    MM_fac = UnitFactionGroup('player');
    M_class = UnitClass("player");
    if (M_class == "Mage") then
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(MINIMAGE_ANNOUNCE_GREETING..M_class..MINIMAGE_ANNOUNCE_ENABLED);
        end
    else
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(MINIMAGE_ANNOUNCE_GREETING..M_class..MINIMAGE_ANNOUNCE_DISABLED);
        end
    end
end

function MM_Button_Initialize()
    if(event == "VARIABLES_LOADED") then
        if (MiniMageOptions.MMButtonPosition == nil) then
            MiniMageOptions.MMButtonPosition = 0;
        end
        if (MiniMageOptions.HidePortals == nil) then
            MiniMageOptions.HidePortals = false;
        end
    end
end

function MM_DropDown_Initialize()
    local dropdown;
    if ( UIDROPDOWNMENU_OPEN_MENU ) then
        dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
    else
        dropdown = this;
    end
    MM_DropDown_InitButtons();
end

function MM_DropDown_OnLoad()
    UIDropDownMenu_Initialize(this, MM_DropDown_Initialize, "MENU");
end

--
-- Minimap button drag/drop functions
-- Thanks to Atlas for the button dragging code
--

function MM_Button_BeingDragged()
    local xpos,ypos = GetCursorPosition();
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();
    xpos = xmin-xpos/UIParent:GetScale()+70;
    ypos = ypos/UIParent:GetScale()-ymin-70;
    MM_Button_SetPosition(math.deg(math.atan2(ypos,xpos)));
end

function MM_Button_OnClick()
    MM_ToggleDropDown();
end

function MM_Button_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT");
    GameTooltip:SetText(MINIMAGE_BUTTON_TOOLTIP0);
    GameTooltip:AddLine(MINIMAGE_BUTTON_TOOLTIP1);
    GameTooltip:AddLine(MINIMAGE_BUTTON_TOOLTIP2);
    GameTooltip:Show();
end

function MM_Button_SetPosition(v)
    if(v < 0) then
        v = v + 360;
    end
    MiniMageOptions.MMButtonPosition = v;
    MM_Button_UpdatePosition();
end

function MM_Button_UpdatePosition()
    MM_ButtonFrame:SetPoint(
        "TOPLEFT",
        "Minimap",
        "TOPLEFT",
        54 - (78 * cos(MiniMageOptions.MMButtonPosition)),
        (78 * sin(MiniMageOptions.MMButtonPosition)) - 55
    );
end

--
-- Required level table (unchanged)
--

local MM_SpellLevels = {
    -- Horde
    ["Teleport: Orgrimmar"] = 20,
    ["Portal: Orgrimmar"]   = 40,

    ["Teleport: Thunder Bluff"] = 30,
    ["Portal: Thunder Bluff"]   = 50,

    ["Teleport: Undercity"] = 20,
    ["Portal: Undercity"]   = 40,

    ["Teleport: Stonard"] = 20,
    ["Portal: Stonard"]   = 40,

    -- Alliance
    ["Teleport: Stormwind"] = 20,
    ["Portal: Stormwind"]   = 40,

    ["Teleport: Ironforge"] = 20,
    ["Portal: Ironforge"]   = 40,

    ["Teleport: Darnassus"] = 30,
    ["Portal: Darnassus"]   = 50,

    ["Teleport: Theramore"] = 40,
    ["Portal: Theramore"]   = 60,

    ["Teleport: Alah'Thalas"] = 20,
    ["Portal: Alah'Thalas"]   = 40,
}

function MM_CanCastSpell(spellName)
    local req = MM_SpellLevels[spellName]
    if not req then return true end
    return UnitLevel("player") >= req
end

--
-- Drop down menu functions
--

function MM_ToggleDropDown()
    MM_DropDownFrame.point = "TOPRIGHT";
    MM_DropDownFrame.relativePoint = "BOTTOMLEFT";
    ToggleDropDownMenu(1, nil, MM_DropDownFrame);
end

function MM_DropDown_InitButtons()
    local info = {};
    info.text = "|cff00ff00"..MINIMAGE_LABEL_TITLE.."|r";
    info.isTitle = 1;
    info.justifyH = "CENTER";
    info.notCheckable = 1;

    info.tooltipTitle = info.text
    info.tooltipText = "Click to cast"
    info.tooltipOnButton = true

    UIDropDownMenu_AddButton(info);

    MM_DropDown_AllCities();
end

-----------------------------------------------------
-- ALL CITIES (HORDE + ALLIANCE)
-----------------------------------------------------

local MM_HordeCities = {
    { label = MINIMAGE_LABEL_ORG,       teleport = "Teleport: Orgrimmar",     portal = "Portal: Orgrimmar" },
    { label = MINIMAGE_LABEL_TB,        teleport = "Teleport: Thunder Bluff", portal = "Portal: Thunder Bluff" },
    { label = MINIMAGE_LABEL_STONARD,   teleport = "Teleport: Stonard",       portal = "Portal: Stonard" },
    { label = MINIMAGE_LABEL_UC,        teleport = "Teleport: Undercity",     portal = "Portal: Undercity" },
}

local MM_AllianceCities = {
    { label = MINIMAGE_LABEL_ALAH,      teleport = "Teleport: Alah'Thalas",   portal = "Portal: Alah'Thalas" },
    { label = MINIMAGE_LABEL_THERAMORE, teleport = "Teleport: Theramore",     portal = "Portal: Theramore" },
    { label = MINIMAGE_LABEL_SW,        teleport = "Teleport: Stormwind",     portal = "Portal: Stormwind" },
    { label = MINIMAGE_LABEL_IF,        teleport = "Teleport: Ironforge",     portal = "Portal: Ironforge" },
    { label = MINIMAGE_LABEL_DARNASSUS, teleport = "Teleport: Darnassus",     portal = "Portal: Darnassus" },
}

local function MM_AddSectionTitle(text, tooltipText)
    local info = { }
    info.text = text
    info.isTitle = 1
    info.notCheckable = 1
    info.tooltipTitle = text
    info.tooltipText = tooltipText
    info.tooltipOnButton = true
    UIDropDownMenu_AddButton(info)
end

local function MM_AddSpellButton(cityLabel, spellName)
    local info = { }
    info.text = cityLabel
    info.disabled = not MM_CanCastSpell(spellName)
    info.func = function()
        if MM_CanCastSpell(spellName) then
            MM_TryCast(spellName)
        end
    end
    UIDropDownMenu_AddButton(info)
end

local function MM_AddSeparator()
    local info = { }
    info.text = "----------------"
    info.disabled = 1
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info)
end

local function MM_AddFactionSpellGroup(cityList, spellType)
    for _, city in ipairs(cityList) do
        MM_AddSpellButton(city.label, city[spellType])
    end
end

function MM_DropDown_AllCities()
    local hidePortals = MiniMageOptions.HidePortals or UnitLevel("player") < 40

    if not hidePortals then
        MM_AddSectionTitle(MINIMAGE_LABEL_PORTAL, "Portal spells")
        MM_AddFactionSpellGroup(MM_HordeCities, "portal")
        MM_AddSeparator()
        MM_AddFactionSpellGroup(MM_AllianceCities, "portal")
    end

    MM_AddSectionTitle(MINIMAGE_LABEL_TELEPORT, "Teleport spells")
    MM_AddFactionSpellGroup(MM_HordeCities, "teleport")
    MM_AddSeparator()
    MM_AddFactionSpellGroup(MM_AllianceCities, "teleport")
end

--
-- Slash Commands
--

SLASH_MINIMAGE1 = "/mmage"

SlashCmdList["MINIMAGE"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "reset" then
        MiniMageOptions = {}
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage: options reset.|r")

    elseif msg == "icon" then
        if MM_ButtonFrame:IsShown() then
            MM_ButtonFrame:Hide()
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage: minimap button hidden.|r")
        else
            MM_ButtonFrame:Show()
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage: minimap button shown.|r")
        end

    elseif msg == "portals" then
        MiniMageOptions.HidePortals = not MiniMageOptions.HidePortals

        if MiniMageOptions.HidePortals then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage: Portal hidden.|r")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage: Portal shown.|r")
        end

    elseif msg == "help" or msg == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MiniMage commands:|r")
        DEFAULT_CHAT_FRAME:AddMessage("/mmage help        - Show this help")
        DEFAULT_CHAT_FRAME:AddMessage("/mmage icon        - Show/Hide minimap button")
        DEFAULT_CHAT_FRAME:AddMessage("/mmage reset       - Reset addon saved options")

    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000MiniMage: unknown command.|r")
        DEFAULT_CHAT_FRAME:AddMessage("Type /mmage help for options.")
    end
end

-- ===== Cast tracking + learned-check =====

local MM_LastAttemptedSpell = nil
local MM_LastAttemptTime = 0

function MM_HasSpell(spellName)
    for i=1, GetNumSpellTabs() do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j=1, numSpells do
            local name = GetSpellName(j + offset, BOOKTYPE_SPELL)
            if name == spellName then
                return true
            end
        end
    end
    return false
end

function MM_TryCast(spellName)
    if not MM_HasSpell(spellName) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You Have Not Learned " .. spellName .. ".|r")
        return
    end
    MM_LastAttemptedSpell = spellName
    MM_LastAttemptTime = GetTime()
    CastSpellByName(spellName)
end

local MM_EventFrame = CreateFrame("Frame")
MM_EventFrame:RegisterEvent("UI_ERROR_MESSAGE")

MM_EventFrame:SetScript("OnEvent", function(self, event, message)
    local now = GetTime()

    if MM_LastAttemptedSpell and (now - MM_LastAttemptTime) < 1.0 then
        if message then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000You Have Not Learned " .. MM_LastAttemptedSpell .. ".|r")
        end
        MM_LastAttemptedSpell = nil
        MM_LastAttemptTime = 0
    end
end)
