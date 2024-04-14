-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

if SLOT_DATA == nil then
        return
end

is_area_rando = false
	for k,v in pairs(slot_data["AreaRando"]) do
	if k ~= tostring(v) then
	is_area_rando = true
  end
end
print(is_area_rando)

if is_area_rando == false then
            Tracker:FindObjectForCode("area").Active = 1
        elseif is_area_rando == true then 
            Tracker:FindObjectForCode("area").Active = 0
    end
    
if slot_data['StrictMoves'] then
        print("slot_data['StrictMoves']: " .. slot_data['StrictMoves'])
        if slot_data['StrictMoves'] == 0 then
            Tracker:FindObjectForCode("moves").Active = 1
        elseif slot_data['StrictMoves'] == 1 then 
            Tracker:FindObjectForCode("moves").Active = 0
        end
    end

if slot_data['StrictCaps'] then
        print("slot_data['StrictCaps']: " .. slot_data['StrictCaps'])
        if slot_data['StrictCaps'] == 0 then
            Tracker:FindObjectForCode("caps").Active = 1
        elseif slot_data['StrictCaps'] == 1 then 
            Tracker:FindObjectForCode("caps").Active = 0
        end
    end
	
if slot_data['StrictCannons'] then
        print("slot_data['StrictCannons']: " .. slot_data['StrictCannons'])
        if slot_data['StrictCannons'] == 0 then
            Tracker:FindObjectForCode("cannons").Active = 1
        elseif slot_data['StrictCannons'] == 1 then 
            Tracker:FindObjectForCode("cannons").Active = 0
        end
    end
	
if slot_data['100Coins'] then
        print("slot_data['100Coins']: " .. slot_data['100Coins'])
        if slot_data['100Coins'] == 0 then
            Tracker:FindObjectForCode("100coins").Active = 0
        elseif slot_data['100Coins'] == 1 then 
            Tracker:FindObjectForCode("100coins").Active = 1
        end
    end
	
if slot_data['1UpBoxes'] then
        print("slot_data['1UpBoxes']: " .. slot_data['1UpBoxes'])
        if slot_data['1UpBoxes'] == 0 then
            Tracker:FindObjectForCode("1upbox").Active = 0
        elseif slot_data['1UpBoxes'] == 1 then 
            Tracker:FindObjectForCode("1upbox").Active = 1
        end
    end
	
if slot_data['MoveRandoVec'] then
	print("slot_data['MoveRandoVec']: " .. slot_data['MoveRandoVec'])
	if slot_data['MoveRandoVec'] == 0 then
		Tracker:FindObjectForCode("tj").Active = 1
		Tracker:FindObjectForCode("lj").Active = 1
		Tracker:FindObjectForCode("bf").Active = 1
		Tracker:FindObjectForCode("sf").Active = 1
		Tracker:FindObjectForCode("wk").Active = 1
		Tracker:FindObjectForCode("dv").Active = 1
		Tracker:FindObjectForCode("gp").Active = 1
		Tracker:FindObjectForCode("kk").Active = 1
		Tracker:FindObjectForCode("cl").Active = 1
		Tracker:FindObjectForCode("lg").Active = 1
	end
end	
    -- manually run snes interface functions after onClear in case we are already ingame
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	print(item_name, item_id)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
	print(location_name, location_id)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
