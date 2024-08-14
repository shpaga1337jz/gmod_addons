/*
    BY SHPAGA
*/
surface.CreateFont('shopfont_24', {
    font = 'EuropaNuovaExtraBold',
    size = 24,
    extended = true,
})

surface.CreateFont('shopfont_18', {
    font = 'EuropaNuovaExtraBold',
    size = 18,
    extended = true,
})

function GalaxyShop.Open()
    local scrw, scrh = ScrW(), ScrH()
    GalaxyShop.Menu = vgui.Create('DFrame')
    GalaxyShop.Menu:SetSize(scrw * .35, scrh * .8)
    GalaxyShop.Menu:Center()
    GalaxyShop.Menu:SetTitle('')
    GalaxyShop.Menu:MakePopup()
    GalaxyShop.Menu:ShowCloseButton(false)
    GalaxyShop.Menu.Paint = function(me, w, h)
        local gradientColor1 = Color(28, 44, 60, 240)
        local gradientColor2 = Color(55, 65, 74, 240)
        local gradientColor3 = Color(68, 84, 99, 240)
        for i = 0, h do
            local fraction = i / h
            local r, g, b, a
            if fraction < 0.5 then
                local subFraction = fraction / 0.5
                r = Lerp(subFraction, gradientColor1.r, gradientColor2.r)
                g = Lerp(subFraction, gradientColor1.g, gradientColor2.g)
                b = Lerp(subFraction, gradientColor1.b, gradientColor2.b)
                a = Lerp(subFraction, gradientColor1.a, gradientColor2.a)
            else
                local subFraction = (fraction - 0.5) / 0.5
                r = Lerp(subFraction, gradientColor2.r, gradientColor3.r)
                g = Lerp(subFraction, gradientColor2.g, gradientColor3.g)
                b = Lerp(subFraction, gradientColor2.b, gradientColor3.b)
                a = Lerp(subFraction, gradientColor2.a, gradientColor3.a)
            end
            surface.SetDrawColor(r, g, b, a)
            surface.DrawLine(0, i, w, i)
            --draw.SimpleText('GalaxyShop', 'shopfont_18', w / 2, h * .012, Color(200, 200, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    
    local scroll = vgui.Create('DScrollPanel', GalaxyShop.Menu)
    scroll:Dock(FILL)
    scroll.VBar.Paint = function( me, w, h ) end
 
    local FrameH, FrameW = GalaxyShop.Menu:GetTall(), GalaxyShop.Menu:GetWide()
    yspc = FrameH * .025

    local cls = vgui.Create( 'DButton', GalaxyShop.Menu )
    cls:SetSize( 17.5, 17.5 )
    cls:SetPos( FrameW - 17.5, 0)
    cls:SetText('')
    cls.DoClick = function()
        GalaxyShop.Menu:Close()
    end
    cls.Paint = function( me, w, h )
        surface.SetDrawColor(0, 0, 0, 70)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.SetMaterial(Material("materials/bizneswoman/close.png"))
		surface.DrawTexturedRect(0,0,w,h)
    end

    for k, itemData in pairs(GalaxyShop.Items) do
        local itempanel = vgui.Create('DPanel', scroll)
        itempanel:DockMargin(0, 0, 0, yspc)
        itempanel:Dock(TOP)
        itempanel:SetTall(FrameH * .1)
        itempanel.Paint = function(me, w, h)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(itemData.name, 'shopfont_18', w * .02, h * .10, GalaxyShop.col['text'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(itemData.desc, 'shopfont_18', w * .02, h * .40, GalaxyShop.col['text'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(DarkRP.formatMoney(itemData.price), 'shopfont_18', w * .02, h * 0.70, GalaxyShop.col['text'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end   

        local margin = FrameW * .02
        local button = vgui.Create('DButton', itempanel)
        button:Dock(RIGHT)
        button:SetWide(FrameW * .2)
        button:DockMargin(0, margin, margin, margin)
        button:SetText('')
        button.Paint = function(me, w, h)
            surface.SetDrawColor(GalaxyShop.col['buttons'])
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText('Купить', 'shopfont_18', w / 2, h / 2, GalaxyShop.col['text'], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        button.DoClick = function()
            net.Start('GalaxyShop_recode')
            net.WriteInt(k, 32)
            net.SendToServer()
        end

    end

end

concommand.Add( 'galaxyshop_recode', function()
    GalaxyShop.Open()
end)