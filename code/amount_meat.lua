-- Estimate eaten meat function

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
amount_meat = function(meal)
    if agent.MeatHab == 1 then
        if agent.Rsex == 1 then
            if meal == meal[1] then
                std_gMeat = (Random{mean = 5.31, sd = 1.65}:sample())^2
                tax_gMeat_b = ped_effect(week) * std_gMeat
            elseif meal == meal[2] then
                std_gMeat = (Random{mean = 5.20, sd = 1.69}:sample())^2
                tax_gMeat_l = ped_effect(week) * std_gMeat
            elseif meal == meal[3] then
                std_gMeat = (Random{mean = 6.20, sd = 1.79}:sample())^2
                tax_gMeat_d = ped_effect(week) * std_gMeat
            end
        elseif agent.Rsex == 2 then
            if meal == meal[1] then
                std_gMeat = (Random{mean = 4.88, sd = 1.52}:sample())^2
                tax_gMeat_b = ped_effect(week) * std_gMeat
            elseif meal == meal[2] then
                std_gMeat = (Random{mean = 4.80, sd = 1.61}:sample())^2
                tax_gMeat_l = ped_effect(week) * std_gMeat
            elseif meal == meal[3] then
                std_gMeat = (Random{mean = 5.77, sd = 1.63}:sample())^2
                tax_gMeat_d = ped_effect(week) * std_gMeat
            end
        end
        return std_gMeat, tax_gMeat_b
    elseif agent.MeatHab == 0 then
        std_gMeat = 0
        tax_gMeat_b = 0
        return std_gMeat, tax_gMeat_b
    end
end

-- Correct amount of meat eaten by a consumer given the effect of taxes
tax_meat = function(meal, agent)
    if meal == meal[1] then
        tax_gMeat_b = ped_effect(week) * agent.std_gMeat
        return tax_gMeat_b
    elseif meal == meal[2] then
        tax_gMeat_l = ped_effect(week) * agent.std_gMeat
        return tax_gMeat_d
    elseif meal == meal[3] then
        tax_gMeat_d = ped_effect(week) * agent.std_gMeat
        return tax_gMeat_l
    end
end

--[[day_meat = function(meal, id)
    if meal == meal[3] then
        return gMeat.day = agent.tax_gMeat_b + agent.tax_gMeat_d + agent.tax_gMeat_l
    end
end--]]