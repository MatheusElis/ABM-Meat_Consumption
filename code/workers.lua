function getSocialWorkerNetwork(soc, agent, team_ID)
	local quant = 1
    local rs = SocialNetwork{}

    local mean_team_size = 4
    local quanti_total = Random{mean = mean_team_size, sd = 0.05}:sample()

    rs:add(agent)
    
    agent.team_member = true
    agent.agent_team_ID = team_ID
    
    --print(team_ID)
    forEachAgent(soc,function(randomagent)
        if quant > quanti_total then 
            return rs 
        end
        
            if randomagent ~= agent and randomagent.team_member == false and randomagent.worker== true then
                
                rs:add(randomagent)
                randomagent.team_member = true
                randomagent.agent_team_ID = team_ID
                quant = quant + 1
            end
    end)
    

	return rs
end

team_ID = 1
function createWorkerNetWork(soc)
    
    forEachAgent(soc, function(agent)
        if agent.worker == true and agent.team_member == false then
            
            local name = 'team_'..tostring(team_ID)
            agent:addSocialNetwork(getSocialWorkerNetwork(soc, agent, team_ID),name)
            team_ID = team_ID + 1
            forEachConnection(agent,name, function(friend)
                local sn = agent:getSocialNetwork(name)

                friend:addSocialNetwork(sn,name)
                
            end)
        end
    end)
    return team_ID
end
