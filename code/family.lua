function bubbleSort(A,B)
    local n = #A
    local swapped = false
    repeat
      swapped = false
      for i=2,n do   -- 0 based is for i=1,n-1 do
        if A[i-1] > A[i] then
          A[i-1],A[i] = A[i],A[i-1]
          B[i-1],B[i] = B[i],B[i-1]
          swapped = true
        end
      end
    until not swapped
end


family_ID = 1
function createFamilyNetWork(soc)
    agent_index = 1
    agente_id = {}
    eat_meat_id = {}
    forEachAgent(soc, function(agente)
        table.insert(agente_id, tonumber(agente.id))
        table.insert(eat_meat_id, agente.eat_meat_t0)
    end)
    bubbleSort(eat_meat_id,agente_id)
    
    while soc:sample(agent.family_member == false) do
        local f_size = Random{mean = 5, sd = 2.90}:sample()
        while f_size <= 1 or f_size >= 9 do f_size = Random{mean = 5, sd = 2.90}:sample() end
        agent:addSocialNetwork(getFamilyNetwork(soc, family_ID, agent_index, agent_index + f_size, agente_id))
        agent_index = agent_index + f_size
        family_ID = family_ID + 1
    end
    return family_ID
end

function getFamilyNetwork(soc, family_ID, agent_index, agent_index_final, agente_id)
    local rs = SocialNetwork{}
    for i = agent_index, agent_index_final do 

        rs:add(society:get(agente_id[i]))
        society:get(agente_id[i]).family_member = true
        society:get(agente_id[i]).agent_family_ID = family_ID
    end

    return rs
end

   
