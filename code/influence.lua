--[[
#######               SOCIAL INFLUENCE
--]]

--[[
@SNI_Time_Active: check if a intevention will occur
@SNI_cycle: check if a intervention will recurr every 6 months rather than being one-off
@SNI_Int_Length: duration of the intervention
@par_ext_source_max: change consumers' concerns due not explicitly modelled by the simulation
@Int_Target: intervention targets
@actual_gamma_hlt: decay function of a social-norm campaign based on health impact
@actual_gamma_env: decay function of a social-norm campaign based on env costs
@actual_gamma_awe: decay function of a social-norm campaign based on animal welfare
@gamma_{env, hlt, awe}: campaigns investments (0 = N/A) .25/.50/.75 = Small/Medium/Big
--]]

-- Notes
-- -- par_ext_source_max was subject to sensitivity analysis: To replicate British consumers' meat consumption is suggested to be equal to 0.10

-- Constants
gamma_env = 0.5 -- {0.0, 0.25, 0.5, 0.75}
gamma_hlt = 0.5 -- {0.0, 0.25, 0.5, 0.75}
gamma_awe = 0.5 -- {0.0, 0.25, 0.5, 0.75}
par_ext_source_max = 0.10 -- [0.01, 1.00]
SNI_Time_Active = true
SNI_cycle = false
SNI_Int_Length = 157 -- [0, 157] weeks
Int_Target = 'NA' -- {NA, env_conc, env_unconc}


-- Manage what concerns among the tree ones will undergo a process of influence influence
social_influence = function()
  random_p1 = Random{min = 0, max = 1}:sample()
  random_p2 = Random{min = 0, max = 1}:sample()

  if random_p1 > random_p2 then
    random_p3 = Random{min = 0, max = 1}:sample()
    random_p4 = Random{min = 0, max = 1}:sample()

    if random_p3 > random_p4 then
      social_influence_env(agent) -- agent
    else
      social_influence_hlt(agent) -- agent
    end

  else
    social_influence_awe(agent) -- agent
  end
end -- social_influence

-- Check if an intervention is active looking at the temporal conditions.
-- If so, it set "SNI.Time.Active?" TRUE and allows agents to influence and being influenced due to the intervention.

active_intervention = function(model)
  if model.SNI_Time_Active == true then
    if weeks >= 5 then
      -- Check if the campaigns cycle
      if model.SNI_cycle == true then
        if (weeks <= 26) or (weeks >= 53 and weeks <= 78) or (weeks >= 105 and weeks <= 130) then
          return true
        else
          return false
        end
        if weeks <= SNI_Int_Length then -- CHECAR ESSA CONDIÇÃO ??
          return true
        else
          return false
        end -- SNI_Length
      end -- cycle
    end
  else
    return false
  end -- SNI_Time_Active
end -- actv_intervt


--[[
# Social influence with respect environmental concerns (MeatEnv)
--]]

-- Compute social influence with respect to agent's environmental concerns
social_influence_env = function(model, agent)
  local temp_alpha = 0
  if agent.home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif agent.work_eating == true then
    temp_alpha  = agent.work_alpha
  end -- eating

  -- Count weeks
  SNI_week_counter = weeks
  if (weeks <= 26) then
    SNI_week_counter = weeks
  elseif ((weeks >= 53) and (weeks <= 78)) then
    SNI_week_counter = weeks - 52
  elseif ((weeks >= 105) and (weeks <= 130)) then
    SNI_week_counter = weeks - 104
  end

  actual_gamma_env = 0
  if model.SNI_Time_Active == true and model.SNI_Time_Active == true then
    actual_gamma_env = gamma_env * math.exp(-0.125 * SNI_week_counter)
  end

  ------------------------------ ENVIRONMENT ------------------------------------
  -- Individual concern of the agent weighted for personal factor alpha
  agent.ind_env = (1 - temp_alpha) * agent.MeatEnv

  local friends_pos_env  = (1 + actual_gamma_env) * more

  if agent.home_eating == true then
    id = agent.agent_family_ID
    network_name = "family_"..id
  elseif agent.work_eating == true then
    id = agent.agent_team_ID
    network_name = "team_"..id
  end

  forEachConnection(agent, network_name, function(friend, weight, agent)
      friend_pos_env_many = 0
      friend_neg_env_many = 0
      friends_pos_env = 0
      friends_neg_env = 0

      if friend.MeatEnv > agent.MeatEnv then
        -- Sum the concerns regarding the health of those friends with a concern higher than the agent
        friends_pos_env = friends_pos_env + (1 + actual_gamma_env) * friend.MeatEnv

        -- Count how many friends the agent has with higher concern for the health compared to itself
        friend_pos_env_many = friend_pos_env_many + 1

      elseif friend.MeatEnv <= agent.MeatEnv then
        -- Sum the concerns regarding the enviroment of those friends with a concern lower than the agent
        friends_neg_env = friends_neg_env + (1 - actual_gamma_env) * friend.MeatEnv

        -- Count how many friends the agent has with lower concern for the environment compared to itself
        friend_neg_env_many = friend_neg_env_many + 1
      end
    end)

  -- Count gamma factor one time per each previous friends
  pos_gamma_env = actual_gamma_env * friend_pos_env_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_pos_env_many = friend_pos_env_many + pos_gamma_env

  -- Count gamma factor one time per each previous friends
  neg_gamma_env = actual_gamma_env * friend_neg_env_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_neg_env_many = friend_neg_env_many - neg_gamma_env

  agent.MeatEnv = ind_env + temp_alpha * ((friends_pos_env + friends_neg_env)/ (w_friend_pos_env_many + w_friend_neg_env_many))

  if agent.MeatEnv <= 1 then
    agent.MeatEnv = 1
  elseif agent.MeatEnv >= 5 then
    agent.MeatEnv = 5
  end
end -- social_influence_env


--[[
# Social influence with respect health concerns (MeatHlth)
--]]
-- Compute social influence with respect to agent's health concerns
social_influence_hlt = function(agent)
  local temp_alpha = 0

  if home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif work_eating == true then
    temp_alpha = agent.work_alpha
  end -- eating

  -- Count weeks
  SNI_week_counter = weeks
  if (weeks <= 26) then
    SNI_week_counter = weeks
  elseif ((weeks >= 53) and (weeks <= 78)) then
    SNI_week_counter = weeks - 52
  elseif ((weeks >= 105) and (weeks <= 130)) then
    SNI_week_counter = weeks - 104
  end

  actual_gamma_hlt = 0

  if SNI_Time_Active == true and SNI_Time_Active == true then
    actual_gamma_hlt = gamma_hlt * math.exp(-0.0125 * SNI_week_counter)
  end

  -------------------------------- HEALTH --------------------------------------
  -- Individual concern of the agent weighted for personal factor alpha
  agent.ind_hlt = (1 - temp_alpha) * agent.MeatHlth

  --  Sum the concerns regarding the health of those friends with a concern higher than the agent
  local friends_pos_hlt  = (1 + actual_gamma_hlt) * more

  forEachConnection(agent, function(friend, weight, agent)
      friend_pos_hlt_many = 0
      friend_neg_hlt_many = 0
      friends_pos_hlt = 0
      friends_neg_hlt = 0


      if friend.MeatHlth > agent.MeatHlth then
        -- Sum the concerns regarding the health of those friends with a concern higher than the agent
        friends_pos_hlt = friends_pos_hlt + (1 + actual_gamma_hlt) * friend.MeatHlth

        -- Count how many friends the agent has with higher concern for the health compared to itself
        friend_pos_hlt_many = friend_pos_hlt_many + 1

      elseif friend.MeatHlth <= agent.MeatHlth then
        -- Sum the concerns regarding the hltiroment of those friends with a concern lower than the agent
        friends_neg_hlt = friends_neg_hlt + (1 - actual_gamma_hlt) * friend.MeatHlth

        -- Count how many friends the agent has with lower concern for the hltironment compared to itself
        friend_neg_hlt_many = friend_neg_hlt_many + 1
      end
    end)

  -- Count gamma factor one time per each previous friends
  pos_gamma_hlt = actual_gamma_hlt * friend_pos_hlt_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_pos_hlt_many = friend_pos_hlt_many + pos_gamma_hlt

  -- Count gamma factor one time per each previous friends
  neg_gamma_hlt = actual_gamma_hlt * friend_neg_hlt_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_neg_hlt_many = friend_neg_hlt_many - neg_gamma_hlt

  agent.MeatHlth = ind_hlt + temp_alpha * ((friends_pos_hlt + friends_neg_hlt)/ (w_friend_pos_hlt_many + w_friend_neg_hlt_many))

  if agent.MeatHlth <= 1 then
    agent.MeatHlth = 1
  elseif agent.MeatHlth >= 5 then
    agent.MeatHlth = 5
  end
end -- social_influence_hlt

--[[
# Social influence with respect welfare concerns (MeatWelf)
--]]
-- Compute social influence with respect to agent's animal welfare concerns
social_influence_awe = function(model, agent)
  local temp_alpha = 0
  if agent.home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif agent.work_eating == true then
    temp_alpha  = agent.work_alpha
  end -- eating

  -- Count weeks
  SNI_week_counter = weeks
  if (weeks <= 26) then
    SNI_week_counter = weeks
  elseif ((weeks >= 53) and (weeks <= 78)) then
    SNI_week_counter = weeks - 52
  elseif ((weeks >= 105) and (weeks <= 130)) then
    SNI_week_counter = weeks - 104
  end

  actual_gamma_awe = 0
  if model.SNI_Time_Active == true and model.SNI_Time_Active == true then
    actual_gamma_awe = gamma_awe * math.exp(-0.125 * SNI_week_counter)
  end

  ---------------------------- ANIMAL WELFARE ----------------------------------
  -- Individual concern of the agent weighted for personal factor alpha
  ind_awe = (1 - temp_alpha) * agent.MeatWelf

  local friends_pos_awe  = (1 + actual_gamma_awe) * more

  forEachConnection(agent, function(friend, weight, agent)
      friend_pos_awe_many = 0
      friend_neg_awe_many = 0
      friends_pos_awe = 0
      friends_neg_awe = 0


      if friend.MeatWelf > agent.MeatWelf then
        -- Sum the concerns regarding the health of those friends with a concern higher than the agent
        friends_pos_awe = friends_pos_awe + (1 + actual_gamma_awe) * friend.MeatWelf

        -- Count how many friends the agent has with higher concern for the health compared to itself
        friend_pos_awe_many = friend_pos_awe_many + 1

      elseif friend.MeatWelf <= agent.MeatWelf then
        -- Sum the concerns regarding the aweiroment of those friends with a concern lower than the agent
        friends_neg_awe = friends_neg_awe + (1 - actual_gamma_awe) * friend.MeatWelf

        -- Count how many friends the agent has with lower concern for the aweironment compared to itself
        friend_neg_awe_many = friend_neg_awe_many + 1
      end
    end)

  -- Count gamma factor one time per each previous friends
  pos_gamma_awe = actual_gamma_awe * friend_pos_awe_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_pos_awe_many = friend_pos_awe_many + pos_gamma_awe

  -- Count gamma factor one time per each previous friends
  neg_gamma_awe = actual_gamma_awe * friend_neg_awe_many

  -- Compute the weighted sum of friends for gamma factor
  w_friend_neg_awe_many = friend_neg_awe_many - neg_gamma_awe

  agent.MeatWelf = ind_awe + temp_alpha * ((friends_pos_awe + friends_neg_awe)/ (w_friend_pos_awe_many + w_friend_neg_awe_many))

  if agent.MeatWelf <= 1 then
    agent.MeatWelf = 1
  elseif agent.MeatWelf >= 5 then
    agent.MeatWelf = 5
  end
end -- social_influence_awe