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

random = Random()
random:reSeed(42)

-- Constants
b = {-6.321, 0.655, 0.016, 0.287, 0.623, 0.178, 0.101}
week_day = {"Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado", "Domingo"}
year = {2014, 2015, 2016}
meal = {"Breakfast", "Lunch", "Dinner"}

EMC = Model{
    finalTime = 157,
    SNI_Time_Active == false,

    -- Initialise time and meal variables
    week = 1,
    days = 0,
    current_day = 0,
    eating_episodes = 2,
    current_meal = meal[1],

    init = function(model)
        model.society, model.agent = criar_agente()

        model.society:execute() -- call execute for each agent
        model.society:createNetworks()

        model.timer = Timer{
            Event{action = model.society},
            Event{action = function()
                    week = 1
                    upd_meal = 1
                    day = 1
                    current_meal = meal[1]
                    while week < 15 do
                        forEachAgent(model.society, function()
                                -- Meals
                                if current_meal == meal[1] or current_meal == meal[3] then
                                    agent.home_eating = true
                                    agent.work_eating = false


                                elseif current_meal == meal[2] then
                                    -- Check if is a work day
                                    if day%7 == 6 or day%7 == 0 then
                                        --eating home
                                        agent.home_eating = true
                                        agent.work_eating = false

                                    else
                                        --Check if is at home or at work
                                        if agent.worker == true then
                                            -- eating at work
                                            agent.home_eating = false
                                            agent.work_eating = true

                                        elseif agent.worker == false then
                                            -- eating home
                                            agent.home_eating == true
                                            agent. work_eating == false

                                        end -- if worker
                                    end -- if day
                                end -- current meal
                            end) -- forEachAgent

                        -- Update week
                        if day%7 == 0 then
                            week = week + 1
                        end
                        -- Update day
                        if current_meal == meal[3] then
                           day = day + 1
                        end
                        -- Update meal
                        upd_meal = upd_meal + 1
                        current_meal = meal[upd_meal%3]

                    end -- while week
                end} -- event function
        } -- timer

    end -- init
} -- model

EMC:run()