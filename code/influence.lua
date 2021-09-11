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
      social_influence_env() -- agent
    else
      social_influence_hlt() -- agent
    end

  else
    social_influence_awe() -- agent
  end
end -- social_influence

-- Check if an intervention is active looking at the temporal conditions.
-- If so, it set "SNI.Time.Active?" TRUE and allows agents to influence and being influenced due to the intervention.

active_intervention = function()
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

-- Compute social influence with respect to agent's environmental concerns
social_influence_env = function()
  local temp_alpha = 0
  if home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif work_eating == true then
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

  local social_influence_env = 0
  if model.SNI_Time_Active == true and model.SNI_Time_Active == true then
    actual_gamma_env = gamma_env * math.exp(-0.125 * SNI_week_counter)
  end

  ------------------------------ ENVIRONMENT ------------------------------------
  -- Individual concern of the agent weighted for personal factor alpha
  agent.ind_env = (1 - temp_alpha) * agent.MeatEnv

end -- social_influence_env

--[[to social-influence-env [locals]
  ;; Sum the concerns regarding the enviroment of those friends ("locals") with a concern higher than the agent
  let friends.pos.env ( (1 + actual.gamma.env) * (sum [ag.env] of locals with [ag.env > [ag.env] of myself]) )
  ;; Count how many friends the agent has with higher concern for the environment compared to itself
  let friend.pos.env.many count locals with [ag.env > [ag.env] of myself]
  ;; Count gamma factor one time per each previous friends
  let pos.gamma.env (actual.gamma.env * friend.pos.env.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.pos.env.many ( friend.pos.env.many + pos.gamma.env )
  ;; Sum the concerns regarding the enviroment of those friends ("locals") with a concern lower than the agent
  let friends.neg.env ( (1 - actual.gamma.env) * (sum [ag.env] of locals with [ag.env <= [ag.env] of myself]) )
  ;; Count how many friends the agent has with lower concern for the environment compared to itself
  let friend.neg.env.many count locals with [ag.env <= [ag.env] of myself]
  ;; Count gamma factor one time per each previous friends
  let neg.gamma.env (actual.gamma.env * friend.neg.env.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.neg.env.many ( friend.neg.env.many - neg.gamma.env )
  set ag.env ag.ind.env + temp.alpha * ( (friends.pos.env + friends.neg.env) / (w.friend.pos.env.many + w.friend.neg.env.many) )
  if ag.env <= 1 [set ag.env 1]
  if ag.env >= 5 [set ag.env 5]
end
--]]

-- Compute social influence with respect to agent's health concerns
social_influence_hlt = function()
  local temp_alpha = 0

  if home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif work_eating == true then
    temp_alpha = agent.work_alpha
  end -- eating

  actual_gamma_hlt = 0

  if SNI_Time_Active == true and SNI_Time_Active == true then
    actual_gamma_hlt = gamma_hlt * math.exp(-0.0125 * SNI_week_counter)
  end

end -- social_influence_hlt

  --[[
;; HEALTH
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Individual concern of the agent weighted for personal factor alpha
  let ag.ind.hlt (1 - temp.alpha) * ag.hlt
  ;; Sum the concerns regarding the health of those friends ("locals") with a concern higher than the agent
  let friends.pos.hlt ( (1 + actual.gamma.hlt) * (sum [ag.hlt] of locals with [ag.hlt > [ag.hlt] of myself]) )
  ;; Count how many friends the agent has with higher concern for the health compared to itself
  let friend.pos.hlt.many count locals with [ag.hlt > [ag.hlt] of myself]
  ;; Count gamma factor one time per each previous friends
  let pos.gamma.hlt (actual.gamma.hlt * friend.pos.hlt.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.pos.hlt.many ( friend.pos.hlt.many + pos.gamma.hlt )
  ;; Sum the concerns regarding the health of those friends ("locals") with a concern lower than the agent
  let friends.neg.hlt ( (1 - actual.gamma.hlt) * (sum [ag.hlt] of locals with [ag.hlt <= [ag.hlt] of myself]) )
  ;; Count how many friends the agent has with lower concern for the health compared to itself
  let friend.neg.hlt.many count locals with [ag.hlt <= [ag.hlt] of myself]
  ;; Count gamma factor one time per each previous friends
  let neg.gamma.hlt (actual.gamma.hlt * friend.neg.hlt.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.neg.hlt.many ( friend.neg.hlt.many - neg.gamma.hlt )
  set ag.hlt ag.ind.hlt + temp.alpha * ( (friends.pos.hlt + friends.neg.hlt) / (w.friend.pos.hlt.many + w.friend.neg.hlt.many) )
  if ag.hlt <= 1 [set ag.hlt 1]
  if ag.hlt >= 5 [set ag.hlt 5]
end
--]]

-- Compute social influence with respect to agent's animal welfare concerns
social_influence_awe = function()
  local temp_alpha = 0

  if home_eating == true then
    temp_alpha = agent.fam_alpha
  elseif work_eating == true then
    temp_alpha = agent.work_alpha
  end -- eating

  actual_gamma_awe = 0

  if SNI_Time_Active == true and SNI_Time_Active == true then
    actual_gamma_awe = gamma_awe * math.exp(-0.0125 * SNI_week_counter)
  end
end -- social_influence_awe

--[[
;; ANIMAL WELFARE
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Individual concern of the agent weighted for personal factor alpha
  let ag.ind.awe (1 - temp.alpha) * ag.awe
  ;; Sum the concerns regarding the animal welfare of those friends ("locals") with a concern higher than the agent
  let friends.pos.awe ( (1 + actual.gamma.awe) * (sum [ag.awe] of locals with [ag.awe > [ag.awe] of myself]) )
  ;; Count how many friends the agent has with higher concern for the animal welfare compared to itself
  let friend.pos.awe.many count locals with [ag.awe > [ag.awe] of myself]
  ;; Count gamma factor one time per each previous friends
  let pos.gamma.awe (actual.gamma.awe * friend.pos.awe.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.pos.awe.many ( friend.pos.awe.many + pos.gamma.awe )
  ;; Sum the concerns regarding the animal welfare of those friends ("locals") with a concern lower than the agent
  let friends.neg.awe ( (1 - actual.gamma.awe) * (sum [ag.awe] of locals with [ag.awe <= [ag.awe] of myself]) )
  ;; Count how many friends the agent has with lower concern for the animal welfare compared to itself
  let friend.neg.awe.many count locals with [ag.awe <= [ag.awe] of myself]
  ;; Count gamma factor one time per each previous friends
  let neg.gamma.awe (actual.gamma.awe * friend.neg.awe.many)
  ;; Compute the weighted sum of friends for gamma factor
  let w.friend.neg.awe.many ( friend.neg.awe.many - neg.gamma.awe )
  set ag.awe ag.ind.awe + temp.alpha * ( (friends.pos.awe + friends.neg.awe) / (w.friend.pos.awe.many + w.friend.neg.awe.many) )
  if ag.awe <= 1 [set ag.awe 1]
  if ag.awe >= 5 [set ag.awe 5]
end
end
--]]

-- Change consumers' concerns due not explicitly modelled by the simulation (e.g. influences by media, bad food experiences, etc.)
ext_sources_of_influence = function()
  local random_p = Random{min = 0, max = 1}:sample()
  if random_p >= 0 and random_p < 0.33 then
    agent.MeatEnv = agent.MeatEnv + (Random{min = 0, max = par_ext_source_max * 2}:sample() - par_ext_source_max)

    if agent.MeatEnv <= 1 then
      agent.MeatEnv = 1

    elseif agent.MeatEnv >= 5 then
      agent.MeatEnv = 5
    end

  elseif (random_p >= 0.33 and random_p < 0.66) then
    agent.MeatHlth = agent.MeatHlth + (Random{min = 0, max = par_ext_source_max * 2}:sample() - par_ext_source_max)

    if agent.MeatHlth <= 1 then
      agent.MeatHlth = 1

    elseif agent.MeatHlth >= 5 then
      agent.MeatHlth = 5
    end

  else
    agent.MeatWelf = agent.MeatWelf + (Random{min = 0, max = par_ext_source_max * 2}:sample() - par_ext_source_max)

    if agent.MeatWelf <= 1 then
      agent.MeatWelf = 1

    elseif agent.MeatWelf >= 5 then
      agent.MeatWelf = 5
    end
  end
end -- ext_sources_of_influence