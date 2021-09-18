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

-- Dataframe
dt = DataFrame{
    agent_id = {},
    MeatHab = {},
    Worker = {},
    eatmeat_t0 = {},
    actual_day = {},
    breakfast = {},
    lunch = {},
    dinner = {},
    breakfast_tax = {},
    lunch_tax = {},
    dinner_tax = {},
    notax_meat = {},
    tax_meat = {}
}

-- Seed
random = Random()
random:reSeed(42)

-- Constants
b = {-6.321, 0.655, 0.016, 0.287, 0.623, 0.178, 0.101}
week_day = {"Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado", "Domingo"}
year = {2014, 2015, 2016}
meal = {"Breakfast", "Lunch", "Dinner"}
--meat_price_increase = 1 -- [1%, 2%]
--actual_meat_price = 0

EMC = Model{
    finalTime = 157*7,
    --SNI_Time_Active == false,

    -- Initialise time and meal variables
    week = 1,
    day = 1,
    current_day = 0,
    eating_episodes = 2,
    current_meal = meal[1],
    upd_meal = 1,

    init = function(model)
        model.society, model.agent = criar_agente()

        model.society:execute() -- call execute for each agent
        -- model.society:createNetworks()

        model.timer = Timer{
            Event{action = model.society},
            Event{action = function()
                        forEachAgent(model.society, function(agent)
                            if agent.MeatHab == 1 then
                                for i = 1, 3 do
                                    if eat_meat(agent, model.week) == 1 then -- prob to eat meat in a meal
                                        if i == 1 then
                                            agent.home_eating = true
                                            agent.work_eating = false

                                            std_gMeat_b, tax_gMeat_b = amount_meat(i, model.week, agent)
                                        elseif i == 2 then
                                            std_gMeat_l, tax_gMeat_l = amount_meat(i, model.week, agent)

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

                                            std_gMeat_d, tax_gMeat_d = amount_meat(i, model.week, agent)
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
								std_gMeat_b = 0
								tax_gMeat_b = 0
								std_gMeat_l = 0
								tax_gMeat_l = 0
								std_gMeat_d = 0
								tax_gMeat_d = 0
                            end -- meathab

							tax_gMeat = tax_gMeat_b + tax_gMeat_d + tax_gMeat_l
                            std_gMeat = std_gMeat_b + std_gMeat_d + std_gMeat_l

                            --print(dt)
                            dt:add{agent_id = agent.SSerial, MeatHab = agent.MeatHab, Worker = agent.worker, eatmeat_t0= agent.eat_meat_t0,  actual_day = model.day, breakfast = std_gMeat_b, lunch = std_gMeat_l, dinner = std_gMeat_d,breakfast_tax = tax_gMeat_b, lunch_tax = tax_gMeat_l, dinner_tax = tax_gMeat_d, notax_meat = std_gMeat, tax_meat = tax_gMeat}
                        end) --forEachAgent

                        print(model.day)
                        if model.day%7 == 0 then
                            model.week = model.week + 1
                        end -- update week

                        model.day = model.day + 1 -- update day
                end} -- event function
        } -- timer

    end -- init
} -- model

EMC:run()

file = File("file.csv")
file:write(dt, ",")
	-- file:deleteIfExists()