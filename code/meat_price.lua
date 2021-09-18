--[[
#Meat price function
--]]

-- Constants
meat_price_index = {0, 0.1, -0.1, -1.5, -2.0, -1.8, -1.7, -2.4, -3.0, -2.8, -2.4, -2.6, -2.6, -3.7, -3.7, -4.3, -3.8, -4.1, -3.8, -4.3, -4.4, -4.9, -5.2, -4.1, -5.4, -4.0, -4.5, -3.3, -2.9, -2.3, -1.6, -0.8, 0, 1.4, 2.1, 1.4, 2.2, 1.7, 3.2, 3.9, 3.8}   -- given
-- meat_price_increase = 1.5 -- [1, 2]

-- Fuction
meat_price = function(week, meat_price_increase)
    local price = ((meat_price_index[math.ceil(week/4)] + 100) * (meat_price_increase))
    return price
end

-- print(meat_price(week))