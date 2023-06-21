local PeaceTime = false
local AOPauth = nil
local PrioAuth = nil
local PTAuth = nil

local citystatus = ''
local countystatus = ''
local statestatus = ''
local aopstatus = ''
local pttext = ''

local citytime = Config.Priority.CooldownLength
local countytime = Config.Priority.CooldownLength
local statetime = Config.Priority.CooldownLength
local PrioStatus = {
    ['cooldown'] = 'Cooldown',
    ['inprogress'] = 'In Progress',
    ['hold'] = 'Hold',
    ['pending'] = 'Pending',
    ['available'] = 'Available'
}
local nearestpostal = ''

local Street = ''
local compass = ''

TriggerServerEvent('AOPandPriority:Server:CheckAuth', 'admin')



RegisterNetEvent('AOPandPriority:client:auth', function(data)
    for i = 1, #data do
        if data[i] == "AOP" then
            AOPauth = true
        elseif data[i] == "Priority" then
            PrioAuth = true
        elseif data[i] == "PeaceTime" then
            PTAuth = true
        end
    end
    SetPerms()
end)

function SetPerms()
    if PrioAuth then

        RegisterCommand('setp', function(source, args, raw)
            if args[1] and args[2] then
                local acceptablelocation = false
                local acceptablestatus = false
                local allowedlocation = {'city', 'county', 'state'}
                if Config.Priority.SplitCountyandCity then
                    allowedlocation = {'city', 'county'}
                elseif not Config.Priority.SplitCountyandCity then
                    allowedlocation = {'state'}
                end
                local allowedstatus = {"cooldown", 'inprogress', 'hold', 'pending', 'available'}
                for _,v in pairs(allowedstatus) do
                    print(v)
                    if v == args[2]:lower() then
                        print('making acceptablestatus true')
                        acceptablestatus = true
                        break
                    end
                end
                for _,v in pairs(allowedlocation) do
                    print(v)
                    if v == args[1]:lower() then
                        print('making acceptablelocation true')
                        acceptablelocation = true
                        break
                    end
                end
                print(acceptablelocation)
                print(acceptablestatus)
                if acceptablelocation and acceptablestatus then
                    local data = {
                        type = 'priority',
                        status = args[2]:lower(),
                        location = args[1]:lower()
                    }
                    TriggerServerEvent('AOPandPriority:server:SetStatus', data)
                    Notify('Priority for '..args[1]:lower()..' has been set to '..args[2]:lower())
                else
                    Notify('You are missing a region or status')
                end
            end
        end)
        if Config.Priority.SplitCountyandCity then
            TriggerEvent('chat:addSuggestion', '/setp', 'Change Priority', {
                { name="location", help="city, county"},
                { name="status", help="cooldown, inprogress, hold, pending, available"}
            })
        else
            TriggerEvent('chat:addSuggestion', '/setp', 'Change Priority', {
                { name="location", help="state"},
                { name="status", help="cooldown, inprogress, hold, pending, available"}
            })
        end
    end
    if AOPauth then
        RegisterCommand('aop', function(source, args, raw)
            if args[1] then
                local data = {
                    type = 'aop',
                    status = args[1]
                }
                TriggerServerEvent('AOPandPriority:server:SetStatus', data)
                Notify('AOP has been set to '..args[1])
            else
                Notify('You are missing a location for AOP')
            end
        end)
        TriggerEvent('chat:addSuggestion', '/aop', 'Change AOP', {
            { name="location", help="Type where the AOP will be located" }
        })
    end
    if PTAuth then
        RegisterCommand('pt', function(source, args, raw)
            local data = {
                type = 'peacetime',
                status = 'change'
            }
            TriggerServerEvent('AOPandPriority:server:SetStatus', data)
            Notify('Peacetime has been toggled')
        end)
        TriggerEvent('chat:addSuggestion', '/pt', 'Toggle Peacetime', {
        })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) --Required
        if Config.Priority then
            if Config.Priority.SplitCountyandCity then
                local tempcitystatus = GetConvar("city_priority", Config.StartupDefaults.city_priority)
                local tempcountystatus = GetConvar("county_priority", Config.StartupDefaults.county_priority)
                local tempcitytime = tonumber(GetConvar("city_time", Config.Priority.CooldownLength))
                local tempcountytime = tonumber(GetConvar("county_time", Config.Priority.CooldownLength))
                if tempcitystatus ~= citystatus or tempcitytime ~= citytime then
                    if tempcitystatus == 'cooldown' then
                        local data = {
                            action = 'show',
                            classname = 'CityPrio',
                            text = 'City Priority:  '..Config.Priority.CooldownColor..tempcitytime..' min Cooldown'
                        }
                        if Config.Priority.FlashOnChange then
                            if tempcitystatus ~= citystatus then
                                data.action = 'showandhighlight'
                            end
                        end
                        TriggerEvent('AOPandPrioity:client:NUI', data)
                    else
                        for k,v in pairs(PrioStatus) do
                            if k == tempcitystatus then
                                citystatus = k
                                local data = {
                                    action = 'show',
                                    classname = 'CityPrio',
                                    text = 'City Priority:  '..Config.Priority.CooldownColor..v
                                }
                                if Config.Priority.FlashOnChange then
                                    data.action = 'showandhighlight'
                                end
                                TriggerEvent('AOPandPrioity:client:NUI', data)
                                break
                            end
                        end
                    end
                    citystatus = tempcitystatus
                    citytime = tempcitytime
                end
                if tempcountystatus ~= countystatus or tempcountytime ~= countytime then
                    if tempcountystatus == 'cooldown' then
                        local data = {
                            action = 'show',
                            classname = 'CountyPrio',
                            text = 'County Priority:  '..Config.Priority.CooldownColor..tempcountytime..' min Cooldown'
                        }
                        if Config.Priority.FlashOnChange then
                            if tempcountystatus ~= countystatus then
                                data.action = 'showandhighlight'
                            end
                        end
                        TriggerEvent('AOPandPrioity:client:NUI', data)
                    else
                        for k,v in pairs(PrioStatus) do
                            if k == tempcountystatus then
                                countystatus = k
                                local data = {
                                    action = 'show',
                                    classname = 'CountyPrio',
                                    text = 'County Priority:  '..Config.Priority.CooldownColor..v
                                }
                                if Config.Priority.FlashOnChange then
                                    data.action = 'showandhighlight'
                                end
                                TriggerEvent('AOPandPrioity:client:NUI', data)
                                break
                            end
                        end
                    end
                    countystatus = tempcountystatus
                    countytime = tempcountytime
                end
            elseif not Config.Priority.SplitCountyandCity then
                local tempstatestatus = GetConvar("state_priority", Config.StartupDefaults.state_priority)
                local tempstatetime = tonumber(GetConvar("state_time", Config.Priority.CooldownLength))
                if tempstatestatus ~= statestatus then
                    if tempstatestatus == 'cooldown' then
                        statestatus = tempstatestatus
                        statetime = tempstatetime
                        local data = {
                            action = 'show',
                            classname = 'StatePrio',
                            text = 'Priority:  '..Config.Priority.CooldownColor..statetime..' min Cooldown'
                        }
                        if Config.Priority.FlashOnChange then
                            data.action = 'showandhighlight'
                        end
                        TriggerEvent('AOPandPrioity:client:NUI', data)
                    else
                        for k,v in pairs(PrioStatus) do
                            if k == tempstatestatus then
                                statestatus = k
                                local data = {
                                    action = 'show',
                                    classname = 'StatePrio',
                                    text = 'Priority:  '..Config.Priority.CooldownColor..v
                                }
                                if Config.Priority.FlashOnChange then
                                    data.action = 'showandhighlight'
                                end
                                TriggerEvent('AOPandPrioity:client:NUI', data)
                                break
                            end
                        end
                    end
                end
            end
        end
        if Config.AOP.UseAOP then
            local tempaoptext = GetConvar("aop", Config.StartupDefaults.aop_text)
            if aoptext ~= tempaoptext then
                aoptext = tempaoptext
                local data = {
                    action = 'show',
                    classname = 'AOP',
                    text = 'AOP:  '..Config.AOP.AOPFontColor..aoptext
                }
                if Config.AOP.FlashOnChange then
                    data.action = 'showandhighlight'
                end
                TriggerEvent('AOPandPrioity:client:NUI', data)
            end
        end
        if Config.PeaceTime.UsePeaceTime then
            local temppt = GetConvar("peacetime", Config.StartupDefaults.pt_text)
            if pttext ~= temppt then
                pttext = temppt
                local data = {
                    action = 'show',
                    classname = 'PT',
                    text = pttext,
                }
                if Config.PeaceTime.FlashOnChange then
                    data.action = 'showandhighlight'
                end
                if pttext == 'Enabled' then
                    data.text = 'PeaceTime:  '..Config.PeaceTime.PeaceTimeColorEnabled..pttext
                    PeaceTime = true
                else
                    data.text = 'PeaceTime:  '..Config.PeaceTime.PeaceTimeColorDisabled..pttext
                    PeaceTime = false
                end
                TriggerEvent('AOPandPrioity:client:NUI', data)
            end
        end
        if Config.Postals.UsePostals then
            if exports['nearest-postal']:getPostal() then
                local postal = exports['nearest-postal']:getPostal()
                if postal ~= nearestpostal then
                    nearestpostal = postal
                    local data = {
                        action = 'show',
                        classname = 'Postal',
                        text = 'Postal:  '..Config.Postals.PostalColor..postal,
                    }
                    TriggerEvent('AOPandPrioity:client:NUI', data)
                end
            end
        end
        if Config.Location.UseLocation then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local tempStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

            if not Config.Location.UseCardinalDirection then
                if tempStreet ~= Street then
                    Street = tempStreet
                    local data = {
                        action = 'show',
                        classname = 'Direction',
                        text = 'Location:  '..Config.Location.StreeNameColor..Street,
                    }
                    TriggerEvent('AOPandPrioity:client:NUI', data)
                end
            else
                local tempcompass = GetDirection(GetEntityHeading(GetPlayerPed(-1)))
                if tempStreet ~= Street or tempcompass ~= compass then
                    Street = tempStreet
                    compass = tempcompass
                    local data = {
                        action = 'show',
                        classname = 'Direction',
                        text = 'Location:  '..Config.Location.CardinalDirectionColor..compass..'|  '..Config.Location.StreeNameColor..Street,
                    }
                    TriggerEvent('AOPandPrioity:client:NUI', data)
                end
            end
        end
    end
end)

function GetDirection(heading)
    if not heading then
        return "N"
    end
	if ((heading >= 0 and heading < 22.5) or (heading >= 337.5 and heading < 360)) then
		return "N"
    elseif (heading >= 22.5 and heading < 67.5) then
        return "NW"
	elseif (heading >= 67.5 and heading < 112.5) then
		return "W"
    elseif (heading >= 112.5 and heading < 157.5) then
		return "SW"
	elseif (heading >= 157.5 and heading < 202.5) then
		return "S"
    elseif (heading >= 202.5 and heading < 247.5) then
		return "SE"
	elseif (heading >= 247.5 and heading < 292.5) then
		return "E"
    elseif (heading >= 292.5 and heading < 337.5) then
		return "NE"
	end
end

AddEventHandler('AOPandPrioity:client:NUI', function(data)
    SendNUIMessage({
        action = data.action,
        classname = data.classname,
        text = data.text,
    })
end)

AddEventHandler('gameEventTriggered',function(name,args)
    if PeaceTime and Config.PeaceTime.UsePeaceTime then
        if not Config.PeaceTime.TakeDamage.FromEverything then
            local max = GetPedMaxHealth(PlayerPedId())
            SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
        elseif not Config.PeaceTime.TakeDamage.FromVehicles then
            local VehicleDamage = {
                [`WEAPON_RUN_OVER_BY_CAR`] = true,
                [`WEAPON_RAMMED_BY_CAR`] = true,
                [`VEHICLE_WEAPON_ROTORS`] = true,
                [`WEAPON_HIT_BY_WATER_CANNON`] = true,
                [`WEAPON_VEHICLE_ROCKET`] = true,
                [`VEHICLE_WEAPON_TANK`] = true,
                [`VEHICLE_WEAPON_SPACE_ROCKET`] = true,
                [`VEHICLE_WEAPON_PLANE_ROCKET`] = true,
                [`VEHICLE_WEAPON_PLAYER_LASER`] = true,
                [`VEHICLE_WEAPON_PLAYER_BULLET`] = true,
                [`VEHICLE_WEAPON_PLAYER_BUZZARD`] = true,
                [`VEHICLE_WEAPON_PLAYER_HUNTER`] = true,
                [`VEHICLE_WEAPON_PLAYER_LAZER`] = true,
                [`VEHICLE_WEAPON_ENEMY_LASER`] = true,
            }
            for k,_ in pairs(VehicleDamage) do
                if tonumber(k) == args[5] then
                    SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
                end
            end
        end
    end
end)




function Notify(message)
    --You may change this to any notification script you have
    TriggerEvent('chatMessage', '[AOPandPriority]', {255, 255, 255}, '^8'..message)
end