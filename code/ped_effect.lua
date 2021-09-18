--[[
#Ped effect function
--]]

require 'meat_price'

-- Estimate the amount of eaten meat based on sex, time of the day, and price/price elasticity
-- Fuction ped_effect etimates how the meat price will affect the amount of meat eaten, based on price elasticity of the agent.
-- If tax = 0 then ped_effect = 1, for an increase in taxes the ped_effect decreases the amount of meat eaten;

ped_effect = function(agent, week, meat_price_increase)
    ped = (1 - (agent.ped  * ((meat_price(week, meat_price_increase) / 100) - 1)))
    return ped
end