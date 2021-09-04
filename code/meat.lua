--[[
# An Agent-Based Model to Simulate Meat Consumption Behaviour of Consumers in Britain
--]]

-- Criar a sociedade:
agent = Agent{
    -- Atributos extras:
    -- ag.ped: Price elasticity demand associated with the income level (see Tiffin at al, 2011)
    ped = 0,

    -- fam_alpha: personal susceptibility towards other family members
    fam_alpha  = 0 + Random{mean = 0.15, sd = 0.05}:sample(),

    -- work.alpha: Personal susceptibility towards other colleagues
    work_alpha  = 0 + Random{mean = 0.08, sd = 0.01}:sample(),

    execute = function()
        --[[if agent.REarnD >= 0 and agent.REarnD < 3 then
            agent.ped = 0.839
        else
            agent.ped = 0.804
        end -- ped --]]

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
    end, -- execute
    run = function() end,
}

society = Society{
    file ="D:/documentos/INPE/modelagem/projeto_final/modelo_Terrame/dadosFiltrados.csv",
    sep = ",", -- default
    source = "csv",
    instance = agent,
    quantity = 50
}

society:execute() -- call execute for each agent
society:run() -- call run for each agent

print(#society)

print(society.agent[1])