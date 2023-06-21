

Citizen.CreateThread(function()
    if Config.Priority.UsePriority then
        while true do
            Wait(60000)
            local citytime = tonumber(GetConvar("city_time", Config.Priority.CooldownLength))
            local countytime = tonumber(GetConvar("county_time", Config.Priority.CooldownLength))
            local prioritytime = tonumber(GetConvar("state_time", Config.Priority.CooldownLength))
            if Config.Priority.SplitCountyandCity then
                if GetConvar("city_priority", "cooldown") == "cooldown" then
                    if citytime ~= 0 then
                        local newcitytime = citytime - 1
                        SetConvarReplicated("city_time", tostring(newcitytime))
                    end
                end
                if GetConvar("county_priority", "cooldown") == "cooldown" then
                    if countytime ~= 0 then
                        local newcountytime = countytime - 1
                        SetConvarReplicated("county_time", tostring(newcountytime))
                    end
                end
            else
                if GetConvar("state_priority", "cooldown") == "cooldown" then
                    if prioritytime ~= 0 then
                        local newpriority = prioritytime - 1
                        SetConvarReplicated("state_time", tostring(newpriority))
                    end
                end
            end
        end
    end
end)

local PeaceTime = false

Citizen.CreateThread(function()
    for k,v in pairs(Config.StartupDefaults) do
        SetConvarReplicated(k, v)
    end
    SetConvarReplicated("city_time", Config.Priority.CooldownLength)
    SetConvarReplicated("county_time", Config.Priority.CooldownLength)
    SetConvarReplicated("state_time", Config.Priority.CooldownLength)
    if Config.StartupDefaults.pt_text == 'Enabled' then
        PeaceTime = true
    end
end)

AddEventHandler('AOPandPriority:Server:CheckAuth', function(job)
    
    for k,v in pairs(Config.Auth) do
        if k == job then
            TriggerClientEvent('AOPandPriority:client:auth', source, v)
            break
        end
    end
end)

RegisterServerEvent('AOPandPriority:server:SetStatus', function(data)
    if data.type == 'priority' then
        SetConvarReplicated(data.location.."_priority", data.status)
        SetConvarReplicated(data.location.."_time", Config.Priority.CooldownLength)
        Notify(source, 'changed '..data.location..' to '..data.status)
    elseif data.type == 'aop' then
        SetConvarReplicated(data.type, tostring(data.status))
        Notify(source, 'changed AOP to '..data.status)
    elseif data.type == 'peacetime' then
        if not PeaceTime then
            PeaceTime = true
            SetConvarReplicated(data.type, 'Enabled')
        else
            PeaceTime = false
            SetConvarReplicated(data.type, 'Disabled')
        end
        Notify(source, 'toggled PeaceTime')
    end
end)


function Notify(source, message)
    --You can Notify everyone of what changed and/or discord log here
    TriggerClientEvent('chatMessage', -1, '', {255, 255, 255}, '^8'..GetPlayerName(source)..' ' ..message)
end