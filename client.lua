

Framework = nil

local CurrentCops = 0
local dangban = false


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(0)
        end
    end
end)

local icspawnMatuy = 0
local CaymaTuy = {}
local danglam, dang phoi = false, false

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
	CheckCoords()
	Citizen.Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.Vitri.Canhdong.coords, true) < 50 then
		icSpawnCayMatuy()
	end
end)

function CheckCoords()
	Citizen.CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.Vitri.Canhdong.coords, true) < 50 then
				icSpawnCayMatuy()
			end
			Citizen.Wait(8 * 400)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)



RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)





AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(CaymaTuy) do
			Framework.Functions.DeleteObject(v)
		end
	end
end)

function icSpawnCayMatuy()
	while icspawnMatuy < 25 do
		Citizen.Wait(1)
		local Vitrimatuy = MaTuyCoords()
		Framework.Functions.SpawnLocalObject('prop_cs_plant_01', Vitrimatuy, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(CaymaTuy, obj)
			icspawnMatuy = icspawnMatuy + 1
		end)
	end
	Citizen.Wait(8 * 60000)
end

function CheckCoordsmatuy(plantCoord)
    if icspawnMatuy > 0 then 
        local validate = true
        for k, v in pairs(CaymaTuy) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.Vitri.Canhdong.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
    end 
end       

function MaTuyCoords()
    while true do
        Citizen.Wait(1)

        local VitrimatuyX, VitrimatuyY
        math.randomseed(GetGameTimer())

		local modX = math.random(-60, 60)
		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-60, 60)

        VitrimatuyX = Config.Vitri.Canhdong.coords.x + modX
        VitrimatuyY = Config.Vitri.Canhdong.coords.y + modY

        local coordZ = GetCoordZ(VitrimatuyX, VitrimatuyY)
		local coord = vector3(VitrimatuyX, VitrimatuyY, coordZ)

		if CheckCoordsmatuy(coord) then
			return coord
		end
	end
end 

function GetCoordZ(x, y)
	local groundCheckHeights = { 100.0, 111.0, 112.0, 113.0, 114.0, 115.0,116.0, 117.0, 118.0, 119.0, 120.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 70
end

function Drawtextxt(msg, thisFrame, beep, duration)
	AddTextEntry('help', ""..msg)

	if thisFrame then
		DisplayHelpTextThisFrame('help', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('help')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end


function iCHaimatuy()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
		
		
	for i=1, #CaymaTuy, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(CaymaTuy[i]), false) < 1 then
			nearbyObject, nearbyID = CaymaTuy[i], i
		end
	end
	TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
	Framework.Functions.Progressbar("search_register", "Nhặt lá ma túy..", 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		ClearPedTasks(GetPlayerPed(-1))
		Framework.Functions.DeleteObject(nearbyObject)

		table.remove(CaymaTuy, nearbyID)
		icspawnMatuy = icspawnMatuy - 1

		TriggerServerEvent('ic-matuyda:nhatla')

	end, function()
		ClearPedTasks(GetPlayerPed(-1))
	end) -- Cancel
		danglam = false
end	

function iCSaymatuy()
	TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, true)
	Framework.Functions.Progressbar("search_register", "Đang làm..", 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('ic-matuyda:tron')

		local timeLeft = Config.Delays.MTD / 1000
		while timeLeft > 0 do
			Citizen.Wait(1000)
			timeLeft = timeLeft - 1
			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				TriggerServerEvent('ic-matuyda:huy')
				break
			end
		end
		ClearPedTasks(GetPlayerPed(-1))

	end, function()
		ClearPedTasks(GetPlayerPed(-1))
	end) -- Cancel
	danglam = false	
end	

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		for i=1, #CaymaTuy, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(CaymaTuy[i]), false) < 1 then
				nearbyObject, nearbyID = CaymaTuy[i], i
			end
		end
		if nearbyObject and IsPedOnFoot(playerPed) then
			if not danglam then
				Drawtextxt('Nhấn ~g~[ E ]~w~ hái ma túy')
			end
			if IsControlJustReleased(0, 38) and not danglam then
				Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
					if HasItem then

						if CurrentCops >= Config.CanhSat then
							danglam = true
							iCHaimatuy()
						else
							Framework.Functions.Notify("Không đủ cảnh sát..", "error")
						end	

					else
						Framework.Functions.Notify("Thiếu xẻng..", "error")
					end
				end, 'ic-xeng')	
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.Vitri.Say.coords, true) < 1 then
			DrawMarker(1, Config.Vitri.Say.coords.x, Config.Vitri.Say.coords.y, Config.Vitri.Say.coords.z -0.66, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if not danglam then
				Drawtextxt('Nhấn ~g~[E]~w~ để sấy khô')
			end
			if IsControlJustReleased(0, 38) and not danglam then

				Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem, amount)
					if HasItem then
						if CurrentCops >= Config.CanhSat then
							danglam = true
							iCSaymatuy()
						else
							Framework.Functions.Notify("Không đủ cảnh sát..", "error")
						end	
					else
						Framework.Functions.Notify("Thiếu la ma tuy..", "error")
					end
				end, 'ic-lmt', 1)	

			end		
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.Vitri.Ban.coords, true) < 1 then
			DrawMarker(1, Config.Vitri.Ban.coords.x, Config.Vitri.Ban.coords.y, Config.Vitri.Ban.coords.z -0.66, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			Drawtextxt('Nhấn ~g~[E]~w~ để Bán')
			if IsControlJustReleased(0, 38) then
				Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem, amount)
					if HasItem then
						if CurrentCops >= Config.CanhSat then
							danglam = true
							TriggerServerEvent('ic-matuyda:sell')
						else
							Framework.Functions.Notify("Không đủ cảnh sát..", "error")
						end	
					else
						Framework.Functions.Notify("Thiếu MTDG..", "error")
					end
				end, 'ic-mtdg', 1)	

			end		
		end
	end
end)
