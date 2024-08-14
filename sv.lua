/*
    BY SHPAGA
*/
util.AddNetworkString( 'GalaxyShop_recode')

net.Receive( 'GalaxyShop_recode', function( len, ply ) 
    local id = net.ReadInt(32)
    local itemData = GalaxyShop.Items[id]
    if not itemData then return end

    local canAfford = ply:canAfford(itemData.price)
    local HasWeapon = ply:HasWeapon(itemData.weaponname)
    if HasWeapon then
        ply:ChatPrint( 'Покупка не прошла. Вы уже имеете это оружие' )
        return 
    end

    if not canAfford then
        ply:ChatPrint( 'У вас не хватает средств!' )
        return 
    end

    ply:addMoney(-itemData.price)
    ply:Give( itemData.weaponname )

    if itemData.weaponname == 'weapon_smg' then
        ply:GiveAmmo(15, 'SMG1_Grenade', false)
    end

end)
