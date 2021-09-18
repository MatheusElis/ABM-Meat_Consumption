--[[
#Estimate eaten meat function
--]]

require 'ped_effect'
require 'eat_meat_prob'

--[[
@std_gMeat: habitual amount of meat eaten by a consumer for the standard price in a meal
@tax_gMeat_{b, l, d}: amount of meat eaten by a consumer given the effect of taxes in a meal
@gMeat_day: amount of meat eaten by a consumer given the effect of taxes in a day
--]]

-- Variaveis
-- meal = {"Breakfast", "Lunch", "Dinner"}
--[[agent.std_gMeat = 0
agent.tax_gMeat_b = 0
agent.tax_gMeat_l = 0
agent.tax_gMeat_d = 0
agent.gMeat_day = 0--]]

-- Amount of meat (grams) eaten by a consumer without the effect of taxes
amount_meat = function(i, week, agent)
--		if agent.MeatHab == 1 then
            if agent.Rsex == 1 then
                if i == 1 then
                    std_gMeat_b = (Random{mean = 5.31, sd = 1.65}:sample())^2 * agent.MeatHab
                    tax_gMeat_b = ped_effect(agent, week) * std_gMeat_b
                    return std_gMeat_b, tax_gMeat_b
                elseif i == 2 then
                    std_gMeat_l = (Random{mean = 5.20, sd = 1.69}:sample())^2 * agent.MeatHab
                    tax_gMeat_l = ped_effect(agent, week) * std_gMeat_l
                    return std_gMeat_l, tax_gMeat_l
                elseif i == 3 then
                    std_gMeat_d = (Random{mean = 6.20, sd = 1.79}:sample())^2 * agent.MeatHab
                    tax_gMeat_d = ped_effect(agent, week) * std_gMeat_d
                    return std_gMeat_d, tax_gMeat_d
                end
            elseif agent.Rsex == 2 then
                if i == 1 then
                    std_gMeat_b = (Random{mean = 4.88, sd = 1.52}:sample())^2 * agent.MeatHab
                    tax_gMeat_b = ped_effect(agent, week) * std_gMeat_b
                    return std_gMeat_b, tax_gMeat_b
                elseif i == 2 then
                    std_gMeat_l = (Random{mean = 4.80, sd = 1.61}:sample())^2 * agent.MeatHab
                    tax_gMeat_l = ped_effect(agent, week) * std_gMeat_l
                    return std_gMeat_l, tax_gMeat_l
                elseif i == 3 then
                    std_gMeat_d = (Random{mean = 5.77, sd = 1.63}:sample())^2 * agent.MeatHab
                    tax_gMeat_d = ped_effect(agent, week) * std_gMeat_d
                    return std_gMeat_d, tax_gMeat_d
                end
            end

--        elseif agent.MeatHab == 0 then
--            std_gMeat = 0
--            tax_gMeat = 0
--            return std_gMeat, tax_gMeat
--        end
--    tax_gMeat = tax_gMeat_b + tax_gMeat_d + tax_gMeat_l
--    std_gMeat = std_gMeat_b + std_gMeat_d + std_gMeat_l
--    return std_gMeat, tax_gMeat
end