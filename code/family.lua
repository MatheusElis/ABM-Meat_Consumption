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
    
    agente_id = {}
    eat_meat_id = {}
    forEachAgent(soc, function(agente)
        table.insert(agente_id, tonumber(agente.id))
        table.insert(eat_meat_id, agente.eat_meat_t0)
    end)
    
    bubbleSort(eat_meat_id,agente_id)
    
    for index, agent_index in pairs(agente_id) do
        local f_size = Random{mean = 5, sd = 2.90}:sample()
        while f_size <= 1 or f_size >= 9 do f_size = Random{mean = 5, sd = 2.90}:sample() end
        f_size = math.floor(f_size)
        if (index + f_size) > #soc then f_size = #soc - index end
        local agent_index_final = index + f_size
        --print(agent_index .. "                       " .. index) 
        
        individuo = society:get(agent_index)
        if individuo.family_member == false then
          --print(index)
          local name = 'family_'..tostring(family_ID)
          local rs = getFamilyNetwork(soc, family_ID, index, f_size, agente_id)
          individuo:addSocialNetwork(rs,name)
          forEachConnection(individuo,name, function(friend)
            local sn = individuo:getSocialNetwork(name)
            friend:addSocialNetwork(sn,name)
          end)
          family_ID = family_ID + 1
        end
        
        
        

    end
    return family_ID
end

function getFamilyNetwork(soc, family_ID, index, f_size, agente_id)
    local rs = SocialNetwork{}
    local quanti = 0
    while quanti <= f_size do 
      sabrina = soc:get(agente_id[index])
      if sabrina.family_member == false then
        rs:add(sabrina)
        sabrina.family_member = true
        sabrina.agent_family_ID = family_ID
        quanti = quanti + 1
        index = index + 1
      end
    end
    
    return rs
end

   
