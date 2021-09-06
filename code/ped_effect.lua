-- Ped effect function

-- Estimate the amount of eaten meat based on sex, time of the day, and price/price elasticity
-- Fuction ped_effect etimates how the meat price will affect the amount of meat eaten, based on price elasticity of the agent.
-- If tax = 0 then ped_effect = 1, for an increase in taxes the ped_effect decreases the amount of meat eaten;

ped_effect = function(week, agent)
    return (1 - (society:get(agent.id).ped  * ((meat_price(week) / 100) - 1)))
end