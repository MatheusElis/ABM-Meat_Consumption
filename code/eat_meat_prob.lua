--[[
#                    Probability to eat meat in a meal
--]]

require 'meat_price'

-- Report the probability to consume a meal based on meat using the inverse log reg function at any time during the simulation
eat_meat_prob = function(week, agent, meat_price_increase)
        y = ( b[1] + (b[2] * agent.Rsex) + (b[3] * agent.Rage) + (b[4] * agent.MeatEnv) + (b[5] * agent.MeatHlth) + (b[6] * agent.MeatWelf) + (b[7] * agent.livcost1) * (meat_price(week, meat_price_increase) / 100))
        above = math.exp(y)
        below = (1 + math.exp(y))
        return ((1 - (above / below)) * agent.MeatHab)
end

-- Report if the agent will eat meat in this meal
eat_meat = function(agent, week, meat_price_increase)
    prob = Random{min = 0, max =1}:sample()
    agt_prob = eat_meat_prob(week, agent, meat_price_increase)

    if prob >= agt_prob then
        return 0 -- agent will not eat meet
    else
        return 1 -- agent will eat meet
    end
end