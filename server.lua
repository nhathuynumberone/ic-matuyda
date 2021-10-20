Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local playersProcessingCannabis = {}

function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

AddEventHandler('Framework:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('ic-matuyda:onPlayerDeath')
AddEventHandler('ic-matuyda:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)


RegisterServerEvent('ic-matuyda:huy')
AddEventHandler('ic-matuyda:huy', function()
	CancelProcessing(source)
end)

Framework.Functions.CreateCallback('ic-matuyda:GetItemData', function(source, cb, itemName)
	local retval = false
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)	


---------------------------------------------------------------------------------------------------------------------------------


RegisterServerEvent('ic-matuyda:nhatla')
AddEventHandler('ic-matuyda:nhatla', function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local ite = xPlayer.Functions.GetItemByName('ic-lmt')
    if ite == nil then
        TriggerClientEvent("Framework:Notify", src, "Đã nhặt 1x lá ma túy!", "Success", 8000) 
        xPlayer.Functions.AddItem('ic-lmt', 1) 
        TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-lmt'], "add")
    else
        if ite.amount < Config.LaMax then
            xPlayer.Functions.AddItem('ic-lmt', 1)
            TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-lmt'], "add")
        else
            TriggerClientEvent('Framework:Notify', source, 'Đầy túi đồ!', "error")  
        end
    end    
end)

RegisterServerEvent('ic-matuyda:tron')
AddEventHandler('ic-matuyda:tron', function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    if xPlayer ~= nil then
        local Ite = xPlayer.Functions.GetItemByName('ic-mtdg')
        if Ite == nil then
            TriggerClientEvent("Framework:Notify", src, "Đã chế 1x ma túy dg!", "Success", 8000) 
            xPlayer.Functions.AddItem('ic-mtdg', 1) 
            xPlayer.Functions.RemoveItem('ic-ddmt', 1)
            xPlayer.Functions.RemoveItem('ic-lmt', 1)
            TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-mtdg'], "add")
            TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-ddmt'], "remove")
            TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-lmt'], "remove")
        else
            if Ite.amount < Config.SayMax then
                xPlayer.Functions.AddItem('ic-mtdg', 1) 
                xPlayer.Functions.RemoveItem('ic-lmt', 1)
                TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-mtdg'], "add")
                TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['ic-lmt'], "remove")
            else
                TriggerClientEvent('Framework:Notify', source, 'Đầy túi đồ!', "error")  
            end
        end  
    end    
end)

RegisterServerEvent('ic-matuyda:sell')
AddEventHandler('ic-matuyda:sell', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
              for i = 1, Item.amount do
                  Player.Functions.RemoveItem(Item.name, 1)
                  TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
                  if v['Type'] == 'item' then
                      Player.Functions.AddItem(v['Item'], v['Amount'])
                  else
                      Player.Functions.AddMoney('cash', v['Amount'])
                  end
                  Citizen.Wait(500)
              end
          end
        end
    end
end)