--------------------------------------------------------------------------------
----                   Projeto: An agent based model to                     ----
----                 simulate meat consumption behaviour                    ----
----                       of consumers in britain                          ----
--------------------------------------------------------------------------------
----           CAP-465 Modelagem e Simulação do Sistema Terrestre           ----
----                      Professor: Pedro R. Andrade                       ----
----                    Mestrado em Computação Aplicada                     ----
----             Instituto Nacional de Pesquisas Espaciais (INPE)           ----
----                    Matheus Elis, Sabrina G. Marques                    ----
--------------------------------------------------------------------------------
-- Funcoes usadas
require 'family'
require 'workers'
require 'meat'
require 'amount_meat'
require 'ped_effect'
require 'meat_price'
require 'eat_meat_prob'

-- Seed
random = Random()
random:reSeed(42)

-- Constants
b = {-6.321, 0.655, 0.016, 0.287, 0.623, 0.178, 0.101}
--meat_price_increase = 1 -- [1%, 2%]
--actual_meat_price = 0

-- DataFrame


EMC = Model{
    finalTime = 157*7,
    meat_price_increase = 1.5, -- [1, 2]
    --SNI_Time_Active == false,

    -- Initialise time and meal variables
    week = 1,
    day = 1,
    year = 2014,

    -- Outputs
    eat_meat_t0 = 0,
    avg_prob_eat_meat_day = 0,
    prob_meat_day = 0,
    std_meat_day = 0,
    tax_meat_day = 0,
    low_eat_meat_t0 = 0,
    low_prob_eat_meat_day = 0,
    low_std_meat_day = 0,
    low_tax_meat_day = 0,
    hight_eat_meat_t0 = 0,
    hight_prob_eat_meat_day = 0,
    hight_std_meat_day = 0,
    hight_tax_meat_day = 0,
    young_eat_meat_t0 = 0,
    young_prob_eat_meat_day = 0,
    young_std_meat_day = 0,
    young_tax_meat_day = 0,
    adult_eat_meat_t0 = 0,
    adult_prob_eat_meat_day = 0,
    adult_std_meat_day = 0,
    adult_tax_meat_day = 0,
    elder_eat_meat_t0 = 0,
    elder_prob_eat_meat_day = 0,
    elder_std_meat_day = 0,
    elder_tax_meat_day = 0,

    init = function(model)
        model.society, model.agent = criar_agente()

        model.society:execute() -- call execute for each agent
        -- model.society:createNetworks()

        model.timer = Timer{
            Event{action = model.society},
            Event{action = function()
                    count_veg = 0
                    count_low = 0
                    count_hight = 0
                    div_young = 0
                    div_adult = 0
                    div_elder = 0
                    model.eat_meat_t0 = 0
                    model.avg_prob_eat_meat_day = 0
                    model.prob_meat_day = 0
                    eat_meat_prob_b = 0
                    eat_meat_prob_l = 0
                    eat_meat_prob_d = 0
                    model.std_meat_day = 0
                    model.tax_meat_day = 0
                    model.low_eat_meat_t0 = 0
                    model.low_prob_eat_meat_day = 0
                    model.low_std_meat_day = 0
                    model.low_tax_meat_day = 0
                    model.hight_eat_meat_t0 = 0
                    model.hight_prob_eat_meat_day = 0
                    model.hight_std_meat_day = 0
                    model.hight_tax_meat_day = 0
                    model.young_eat_meat_t0 = 0
                    model.young_prob_eat_meat_day = 0
                    model.young_std_meat_day = 0
                    model.young_tax_meat_day = 0
                    model.adult_eat_meat_t0 = 0
                    model.adult_prob_eat_meat_day = 0
                    model.adult_std_meat_day = 0
                    model.adult_tax_meat_day = 0
                    model.elder_eat_meat_t0 = 0
                    model.elder_prob_eat_meat_day = 0
                    model.elder_std_meat_day = 0
                    model.elder_tax_meat_day = 0
                        forEachAgent(model.society, function(agent)
                            if agent.MeatHab == 1 then
                                for i = 1, 3 do
                                    if eat_meat(agent, model.week, model.meat_price_increase) == 1 then -- prob to eat meat in a meal
                                        if i == 1 then
                                            agent.home_eating = true
                                            agent.work_eating = false

                                            std_gMeat_b, tax_gMeat_b = amount_meat(i, model.week, agent, model.meat_price_increase)
                                            eat_meat_prob_b = eat_meat_prob(model.week, agent, model.meat_price_increase)
                                        elseif i == 2 then
                                            std_gMeat_l, tax_gMeat_l = amount_meat(i, model.week, agent, model.meat_price_increase)
                                            eat_meat_prob_l = eat_meat_prob(model.week, agent, model.meat_price_increase)

                                            if model.day%7 == 6 or model.day%7 == 0 then
                                                -- home
                                                agent.home_eating = true
                                                agent.work_eating = false
                                            else
                                                if model.worker == false then
                                                    -- home
                                                    agent.home_eating = true
                                                    agent.work_eating = false
                                                else
                                                    -- eating at work
                                                    agent.home_eating = false
                                                    agent.work_eating = true
                                                end -- worker
                                            end -- week day
                                        elseif i == 3 then
                                            agent.home_eating = true
                                            agent.work_eating = false

                                            std_gMeat_d, tax_gMeat_d = amount_meat(i, model.week, agent, model.meat_price_increase)
                                            eat_meat_prob_d = eat_meat_prob(model.week, agent, model.meat_price_increase)
                                        end
                                    else
										if i == 1 then
                                            agent.home_eating = true
                                            agent.work_eating = false

                                            std_gMeat_b = 0
											tax_gMeat_b = 0

                                        elseif i == 2 then
                                            if model.day%7 == 6 or model.day%7 == 0 then
                                                -- home
                                                agent.home_eating = true
                                                agent.work_eating = false
                                            else
                                                if model.worker == false then
                                                    -- home
                                                    agent.home_eating = true
                                                    agent.work_eating = false
                                                else
                                                    -- eating at work
                                                    agent.home_eating = false
                                                    agent.work_eating = true
                                                end -- worker
                                            end -- week day

											std_gMeat_l = 0
											tax_gMeat_l = 0

                                        elseif i == 3 then
                                            agent.home_eating = true
                                            agent.work_eating = false

                                            std_gMeat_d = 0
											tax_gMeat_d = 0
                                        end
                                    end  -- eat_meat
                                end -- for
                            else
                                -- vegetarian
                                local count_veg = count_veg + 1
								std_gMeat_b = 0
								tax_gMeat_b = 0
								std_gMeat_l = 0
								tax_gMeat_l = 0
								std_gMeat_d = 0
								tax_gMeat_d = 0
                            end -- meathab

                            prob_eat_meat_day = (eat_meat_prob_b + eat_meat_prob_d + eat_meat_prob_l)/3

                            if agent.MeatHab == 1 then
                                if agent.livcost1 == 0 or agent.livcost1 == 1 or agent.livcost1 == 2 then
                                    local count_low = count_low + 1
                                else
                                    local count_hight = count_hight + 1
                                end

								local tax_gMeat = tax_gMeat_b + tax_gMeat_d + tax_gMeat_l -- amount of meet with tax effect
								local std_gMeat = std_gMeat_b + std_gMeat_d + std_gMeat_l -- standart amount of meat
                                --prob_eat_meat_day = (eat_meat_prob_b + eat_meat_prob_l + eat_meat_prob_d)/3

                                model.eat_meat_t0 = model.eat_meat_t0 + agent.eat_meat_t0  -- prob eat meat at t0
                                model.avg_prob_eat_meat_day = model.avg_prob_eat_meat_day + prob_eat_meat_day -- prob eat meat day
                                model.std_meat_day = model.std_meat_day + std_gMeat
                                model.tax_meat_day = model.tax_meat_day + tax_gMeat

                                if agent.livcost1 == 0 or agent.livcost1 == 1 or agent.livcost1 == 2 then
                                    model.low_eat_meat_t0 = model.low_eat_meat_t0 + agent.eat_meat_t0
                                    model.low_prob_eat_meat_day = model.low_prob_eat_meat_day + prob_eat_meat_day
                                    model.low_std_meat_day = model.low_std_meat_day + std_gMeat
                                    model.low_tax_meat_day = model.low_tax_meat_day + tax_gMeat
                                else
                                    model.hight_eat_meat_t0 = model.hight_eat_meat_t0 + agent.eat_meat_t0
                                    model.hight_prob_eat_meat_day = model.hight_prob_eat_meat_day + prob_eat_meat_day
                                    model.hight_std_meat_day = model.hight_std_meat_day + std_gMeat
                                    model.hight_tax_meat_day = model.hight_tax_meat_day + tax_gMeat
                                end -- hight and low income

                                if agent.Rage < 30 then
                                    div_young = div_young + 1
                                    model.young_eat_meat_t0 = model.young_eat_meat_t0 + agent.eat_meat_t0
                                    model.young_prob_eat_meat_day = model.young_prob_eat_meat_day + prob_eat_meat_day
                                    model.young_std_meat_day = model.young_std_meat_day + std_gMeat
                                    model.young_tax_meat_day = model.young_tax_meat_day + tax_gMeat
                                elseif agent.Rage >= 30 and agent.Rage < 65 then
                                    div_adult = div_adult + 1
                                    model.adult_eat_meat_t0 = model.adult_eat_meat_t0 + agent.eat_meat_t0
                                    model.adult_prob_eat_meat_day = model.adult_prob_eat_meat_day + prob_eat_meat_day
                                    model.adult_std_meat_day = model.adult_std_meat_day + std_gMeat
                                    model.adult_tax_meat_day = model.adult_tax_meat_day + tax_gMeat
                                else
                                    div_elder = div_elder + 1
                                    model.elder_eat_meat_t0 = model.elder_eat_meat_t0 + agent.eat_meat_t0
                                    model.elder_prob_eat_meat_day = model.elder_prob_eat_meat_day + prob_eat_meat_day
                                    model.elder_std_meat_day = model.elder_std_meat_day + std_gMeat
                                    model.elder_tax_meat_day = model.elder_tax_meat_day + tax_gMeat
                                end
                            end
                            --print(model.elder_eat_meat_t0)
                        end) --forEachAgent

                        local div = (#model.society - count_veg)
                        local div_low1 = (#model.society - count_hight)
                        local div_hight1 = (#model.society - count_low)
                        local div_young1 = (#model.society - div_adult - div_elder)
                        local div_adult1 = (#model.society - div_young - div_elder)
                        local div_elder1 = (#model.society - div_young - div_adult)

                        model.prob_eat_meat_t0 = model.eat_meat_t0/ div
                        --print(prob_eat_meat_t0)
                        model.prob_eat_meat_day = model.avg_prob_eat_meat_day / div
                        model.std_meat_day = model.std_meat_day / div
                        model.tax_meat_day = model.tax_meat_day / div
                        model.low_eat_meat_t0 = model.low_eat_meat_t0 / div_low1
                        model.low_prob_eat_meat_day = model.low_prob_eat_meat_day / div_low1
                        model.low_std_meat_day = model.low_std_meat_day / div_low1
                        model.low_tax_meat_day = model.low_tax_meat_day / div_low1
                        model.hight_eat_meat_t0 = model.hight_eat_meat_t0 / div_hight1
                        model.hight_prob_eat_meat_day = model.hight_prob_eat_meat_day / div_hight1
                        model.hight_std_meat_day = model.hight_std_meat_day / div_hight1
                        model.hight_tax_meat_day = model.hight_tax_meat_day / div_hight1
                        model.young_eat_meat_t0 = model.young_eat_meat_t0 / div_young1
                        model.young_prob_eat_meat_day = model.young_prob_eat_meat_day / div_young1
                        model.young_std_meat_day = model.young_std_meat_day / div_young1
                        model.young_tax_meat_day = model.young_tax_meat_day / div_young1
                        model.adult_eat_meat_t0 = model.adult_eat_meat_t0 / div_adult1
                        model.adult_prob_eat_meat_day = model.adult_prob_eat_meat_day / div_adult1
                        model.adult_std_meat_day = model.adult_std_meat_day / div_adult1
                        model.adult_tax_meat_day = model.adult_tax_meat_day / div_adult1
                        model.elder_eat_meat_t0 = model.elder_eat_meat_t0 / div_elder1
                        model.elder_prob_eat_meat_day = model.elder_prob_eat_meat_day / div_elder1
                        model.elder_std_meat_day = model.elder_std_meat_day / div_elder1
                        model.elder_tax_meat_day = model.elder_tax_meat_day / div_elder1


                        dt:add{meat_prince_increase = model.meat_price_increase, current_year = model.year, current_week = model.week, current_day = model.day,prob_eat_meat_t0 = model.prob_eat_meat_t0, prob_eat_meat_day = model.prob_eat_meat_day, std_meat_day = model.std_meat_day, tax_meat_day = model.tax_meat_day, low_eat_meat_t0 = model.low_eat_meat_t0, low_prob_eat_meat_day = model.low_prob_eat_meat_day, low_std_meat_day = model.low_std_meat_day, low_tax_meat_day = model.low_tax_meat_day, hight_eat_meat_t0 = model.hight_eat_meat_t0, hight_prob_eat_meat_day = model.hight_prob_eat_meat_day, hight_std_meat_day = model.hight_std_meat_day, hight_tax_meat_day = model.hight_tax_meat_day, young_eat_meat_t0 = model.young_eat_meat_t0, young_prob_eat_meat_day = model.young_prob_eat_meat_day, young_std_meat_day = model.young_std_meat_day, young_tax_meat_day = model.young_tax_meat_day, adult_eat_meat_t0 = model.adult_eat_meat_t0, adult_prob_eat_meat_day = model.adult_prob_eat_meat_day, adult_std_meat_day = model.adult_std_meat_day, adult_tax_meat_day = model.adult_tax_meat_day, elder_eat_meat_t0 = model.elder_eat_meat_t0, elder_prob_eat_meat_day = model.elder_prob_eat_meat_day, elder_std_meat_day = model.elder_std_meat_day, elder_tax_meat_day = model.elder_tax_meat_day}

                        print(model.day)
                        if model.day%7 == 0 then
                            model.week = model.week + 1
                        end -- update week

                        model.day = model.day + 1 -- update day

                        if model.day >= 731 then
                            model.year = 2016
                        elseif model.day >= 366 then
                            model.year = 2015
                        end
                end} -- event function
        } -- timer

    end -- init
} -- model



-- EMC:run()
--namefile = 'file' .. EMC:get(meat_price_increase)
-- file = File("file.csv")
-- file:write(dt, ",")

