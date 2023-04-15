

--------------------------------------------------------
        RegisterNetEvent('buyCar:giveKey')
        AddEventHandler('buyCar:giveKey', function()
            local player = PlayerId()
            --GivePlayerWeapon(player, GetHashKey('WEAPON_CARKEY'), 1, false, false)  zmienimy to na giveITem niz giveweapn
        end)
------------------------------------------------------------- 
        TriggerEvent('buyCar:giveKey')
-------------------------------------------------------------- 
