function GetPlayerSkillTier(skill, isRookie, adagradSum, isBot) --TODO-HIVE Update for Team-context
    if isBot then return -1, "BOT" end
    if isRookie then return 0, "ROOKIE", 0 end
    if not skill or skill == -1 then return -2, "UNKNOWN" end

    if adagradSum then
        -- capping the skill values using sum of squared adagrad gradients
        -- This should stop the skill tier from changing too often for some players due to short term trends
        -- The used factor may need some further adjustments
        if adagradSum <= 0 then
            skill = 0
        else
            skill = math.max(skill - 25 / math.sqrt(adagradSum), 0)
        end
    end

    if skill <= 300 then return 1, "RECRUIT", skill end
    if skill <= 750 then return 2, "FRONTIERSMAN", skill end
    if skill <= 1400 then return 3, "SQUADLEADER", skill end
    if skill <= 2100 then return 4, "VETERAN", skill end
    if skill <= 2900 then return 5, "COMMANDANT", skill end
    if skill <= 3600 then return 6, "KIRBYOPS", skill end
    if skill <= 4100 then return 7, "SPECIALOPS", skill end
    if skill <= 5000 then return 8, "SANJISURVIVOR", skill end
    return 9, "WOOZANATOR", skill
end

local kSkillTierToDescMap =
{
    [-1] = "BOT",
    [ 0] = "ROOKIE",
    [ 1] = "RECRUIT",
    [ 2] = "FRONTIERSMAN",
    [ 3] = "SQUADLEADER",
    [ 4] = "VETERAN",
    [ 5] = "COMMANDANT",
    [ 6] = "KIRBYOPS",
    [ 7] = "SPECIALOPS",
    [ 8] = "SANJISURVIVOR",
    [ 9] = "WOOZANATOR",
    unknown = "UNKNOWN",
}
