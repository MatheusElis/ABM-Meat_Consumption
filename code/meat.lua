--[[
# An Agent-Based Model to Simulate Meat Consumption Behaviour of Consumers in Britain
--]]

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
require 'code/family'
require 'code/workers'


-- Constants
b = {-6.321, 0.655, 0.016, 0.287, 0.623, 0.178, 0.101}

-- Functions


-- Criar a sociedade:
agent = Agent{
    family_member = false,                       -- A flag to mark those agents who are part of a family
    agent_family_ID = 0,                    -- Agent's family ID
    worker = false,                              -- Every one is part of a family, but only some agents are workers
    team_member = false,                         -- A flag to mark those agents who are part of a work team
    agent_team_ID = 0,                     -- Agent's team ID
    eat_meat_t0 = {},
    ped = 0,
    fam_alpha  = 0 + Random{mean = 0.15, sd = 0.05}:sample(),
    work_alpha  = 0 + Random{mean = 0.08, sd = 0.01}:sample(),

    execute = function(agent)

        if agent.REconAct == 1 then
            agent.worker = true
        end
        local max_team_ID = createWorkerNetWork(society)
        local max_family_ID = createFamilyNetWork(society)
        print(max_family_ID)
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

    run = function() end,
}

society = Society{
    file ="data/sample_397.csv",
    sep = ",", -- default
    source = "csv",
    instance = agent
}

society:execute() -- call execute for each agent
society:run() -- call run for each agent


print(society.get(87))
