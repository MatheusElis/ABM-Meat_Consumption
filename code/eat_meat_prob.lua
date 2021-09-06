-- Probability to eat meat in a meal

-- Report the probability to consume a meal based on meat using the inverse log reg function at any time during the simulation
eat_meat_prob = function(week, agent)
        y = ( b[1] + (b[2] * society:get(agent.id).Rsex) + (b[3] * society:get(agent.id).Rage) + (b[4] * society:get(agent.id).MeatEnv) + (b[5] * society:get(agent.id).MeatHlth) + (b[6] * society:get(agent.id).MeatWelf) + (b[7] * society:get(agent.id).livcost1) * (meat_price(week) / 100))
        above = math.exp(y)
        below = (1 + math.exp(y))
        return (1 - (above / below)) * society:get(agent.id).MeatHab
end

-- Report if the agent will eat meat in this meal
eat_meat = function(agent)
    prob = Random{min = 0, max =1}:sample()
    agt_prob = eat_meat_prob(week, agent)

    if prob >= agt_prob then
        return 0 -- agent will not eat meet
    else
        return 1 -- agent will eat meet
    end
end