--[[
# Society, Agents and Networks
--]]

-- Função

--[[
Agents atributes:
@SSerial: respondent survey ID;
@Rsex: 1 = M, 2 = F;
@Rage: consumer's age;
@Country: country of origin (1=England, 2=Scotland, 3=Wales);
@MeatEnv: concerns related to the impact of meat on the Environment;
@MeatHlth: concerns related to the impact of meat on the Health;
@MeatWelf: concerns related to the impact of meat on the Animal Welfare;
@livcost1: price sensitivity;
@ag.ped: price elasticity demand associated with the income level;
@fam_alpha: personal susceptibility towards other family members;
@work_alpha: personal susceptibility towards other colleagues;
@eat_meat_t0: probability to consume a meal based on meat at t = 0;
--]]
require 'family'
require 'workers'
random = Random()

random:reSeed(42)
-- Constants
b = {-6.321, 0.655, 0.016, 0.287, 0.623, 0.178, 0.101}

-- Função para gerar a Sociedade a partir do arquivo csv, os agentes e as redes sociais de familia e trabalho necessarias para a simulacao;

criar_agente = function()
        agent = Agent{
            family_member = false,                       -- A flag to mark those agents who are part of a family
            agent_family_ID = 0,                    -- Agent's family ID
            worker = false,                              -- Every one is part of a family, but only some agents are workers
            team_member = false,                         -- A flag to mark those agents who are part of a work team
            agent_team_ID = 0,                     -- Agent's team ID
            home_eating = false,                        -- A flag to mark those agents who are eating in home
            work_eating = false,                        -- A flag to mark those agents who are eating in work
            eat_meat_t0 = {},
            ped = 0,
            fam_alpha  = 0 + Random{mean = 0.15, sd = 0.05}:sample(),
            work_alpha  = 0 + Random{mean = 0.08, sd = 0.01}:sample(),
            tax_gMeat_b = 0,
            tax_gMeat_l = 0,
            tax_gMeat_d = 0,
            tax_gMeat = 0,
            gMeat_day = 0,
            std_gMeat_b = 0,
            std_gMeat_l = 0,
            std_gMeat_d = 0,
            eat_meat = 0,

            execute = function(agent)

                if agent.REconAct == 1 then
                    agent.worker = true
                end

                if society:get(agent.id).REarnD >= 0 and society:get(agent.id).REarnD < 3 then
                    agent.ped = 0.839
                else
                    agent.ped = 0.804
                end -- ped

                if agent.fam_alpha < 0 then
                    agent.fam_alpha = 0

                elseif agent.fam_alpha > 0.30 then
                    agent.fam_alpha = 0.30
                end -- if alpha

                if agent.work_alpha < 0 then
                    agent.work_alpha = 0

                elseif agent.work_alpha > 0.12 then
                    agent.work_alpha = 0.12
                end -- if work

                -- prob-at-time-zero: probability of eating meat at time zero
                local y = ( b[1] + (b[2] * society:get(agent.id).Rsex) + (b[3] * society:get(agent.id).Rage) + (b[4] * society:get(agent.id).MeatEnv) + (b[5] * society:get(agent.id).MeatHlth) + (b[6] * society:get(agent.id).MeatWelf) + (b[7] * society:get(agent.id).livcost1) * (1 / 100))
                local above = math.exp(y)
                local below = (1 + math.exp(y))
                agent.eat_meat_t0 = (1 - (above / below)) * society:get(agent.id).MeatHab

            end, -- execute
            createNetworks = function ()
                createFamilyNetWork(society)
                --print(max_family_ID)
                createWorkerNetWork(society)

            end,
        } -- agent

    society = Society{
        file ="C:/Users/mathe/Documents/modelagemSistemasTerrestres/ABM-Meat_Consumption/data/dadosFiltrados.csv",
        sep = ",", -- default
        source = "csv",
        instance = agent
    } -- society

    return society, agent
end -- criar agentes