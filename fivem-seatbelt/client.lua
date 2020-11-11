
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local toEject	   = 1.0
local ejectRate    = 0.0

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
		
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			toEject = math.random()

			if speedBuffer[1] ~= nil and speedBuffer[2]  ~= nil then
				ejectRate = Cfg.BaseEjectRate + Cfg.EjectRateScale * (speedBuffer[2] - speedBuffer[1])
			else
				ejectRate = Cfg.BaseEjectRate
			end

			if toEject < ejectRate
			   and speedBuffer[2] ~= nil 
			   and not beltOn
			   -- car is going forward, account for recoil when hitting an object
			   and GetEntitySpeedVector(car, true).y > -20.0
			   -- use previous speed to determine if threshold high enough
			   and speedBuffer[2] > Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[2] * Cfg.DiffTrigger) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				-- break windshield
				SmashVehicleWindow(car, 6)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
			
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 311) then
				beltOn = not beltOn				  
				if beltOn then TriggerEvent('chatMessage', Cfg.Strings.belt_on)
				else TriggerEvent('chatMessage', Cfg.Strings.belt_off) end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)
