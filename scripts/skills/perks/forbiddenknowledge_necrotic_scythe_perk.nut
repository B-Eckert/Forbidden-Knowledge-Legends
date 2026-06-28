this.forbiddenknowledge_necrotic_scythe_perk <- this.inherit("scripts/skills/skill", {
	m = {
        Kills = 0,
        SkillDictionary = { // Idea #52323 - Use a skill dictionary to save the skills when a turn starts and reset the skill dictionary after.

        }
    },
	function create()
	{
		this.m.ID = "perk.forbiddenknowledge_necrotic_scythe";
		this.m.Name = this.Const.Strings.PerkName.ForbiddenKnowledgeNecroticScythe;
		this.m.Description = this.Const.Strings.PerkDescription.ForbiddenKnowledgeNecroticScythe;
        this.m.Icon = "ui/perks/perk_necrotic_scythe_forbidden_knowledge.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}


    // store all the values at the start of combat
    function onCombatStarted(){
        foreach(skill in this.getContainer().getActor().getSkills().getAllSkillsOfType(this.Const.SkillType.Active)){
            if (skill.getID() == "actives.legend_raise_undead" || skill.getID() == "actives.legend_siphon_skill" || skill.getID() == "actives.legend_possession_skill" || skill.getID() ==  "actives.legend_wither" || skill.getID() ==  "actives.legend_horrify" || skill.getID() ==  "actives.legend_miasma" || skill.getID() ==  "actives.legend_deathtouch")
		    {
                this.m.SkillDictionary[skill.getID()] <- {
                    FatigueCost     = skill.m.FatigueCost,
                    ActionPointCost = skill.m.ActionPointCost
                };
            }
        }
    }

    function onCombatFinished(){
        this.m.Kills = 0;
    }

    function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.getID() == "actives.legend_raise_undead" || _skill.getID() == "actives.legend_siphon_skill" || _skill.getID() == "actives.legend_possession_skill" || _skill.getID() ==  "actives.legend_wither" || _skill.getID() ==  "actives.legend_horrify" || _skill.getID() ==  "actives.legend_miasma" || _skill.getID() ==  "actives.legend_deathtouch")
		{
			if (this.m.Kills <= 5 && this.m.Kills != 0) {
                this.m.Kills -= 2;
            }
            else if(this.m.Kills > 5) {
                this.m.Kills -= 3
            }
            // negative check
            if (this.m.Kills <=  0){
                this.m.Kills = 0;
            }
            //reset();
		}
	}
    // increase kill counter when a scythe kills someone
    function onTargetKilled( _targetEntity, _skill )
	{
		local item = this.getContainer().getActor().getMainhandItem();
        if(item != null){
            if (item.getID() == "weapon.legend_grisly_scythe" || item.getID() == "weapon.legend_scythe" || item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe")
		    {
                if(_skill.getID() == "actives.cleave" || _skill.getID() == "actives.reap" || _skill.getID() == "actives.strike"){
                    this.m.Kills += 1;
                    ::logInfo("SCYTHE: Killstreak! Kill counter currently " + this.m.Kills);
                    // REDUCE ALL SKILLS AP AND FATIGUE COST WHEN SOMEONE KILLS
                }
            }
        }
	}

	function onUpdate( _properties )
	{
		local item = this.getContainer().getActor().getMainhandItem();
		if (item != null)
		{
			if (item.getID() == "weapon.legend_grisly_scythe" || item.getID() == "weapon.legend_scythe" || item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe")
			{
                local multiplier = 0;
                if(item.getID() == "weapon.legend_scythe"){
                    multiplier = 1.0;
                }
                if (item.getID() == "weapon.legend_grisly_scythe"){
                    multiplier = 0.75;
                }
                if(item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe"){
                    multiplier = 0.5;
                }
                local user = this.getContainer().getActor();
                local learnRate = user.getCurrentProperties().XPGainMult;
                if(user.getSkills().hasSkill("effects.trained")){
                    local trained = user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
                    learnRate /= trained;
                }
                if(user.getSkills().hasSkill("effects.knowledge_potion")){ // 100% increase is just X2
                    learnRate /= 2;
                }
                _properties.DamageRegularMin += this.Math.floor(((user.getBravery() * 0.1) + (user.getHitpointsMax() * 0.075) + (user.getInitiative() * 0.075)) * learnRate * multiplier);
                _properties.DamageRegularMax += this.Math.floor(((user.getBravery() * 0.15) + (user.getHitpointsMax() * 0.125) + (user.getInitiative() * 0.125)) * learnRate * multiplier);
        		_properties.DamageArmorMult += (learnRate - 0.95) * 1.5 * (multiplier/2); // .1 + learnrate bonus x1.5
                //_properties.DamageDirectAdd += ((_properties.DamageRegularMin + _properties.DamageRegularMax)/2) * (learnRate - 0.8)*2 + 1; // .2 + learnrate bonus x2
                _properties.DamageDirectMult += (learnRate - 0.8)* 2 * (multiplier + 0.3); // .1 + learnrate bonus x2
			}
		}
        foreach(skill in this.getContainer().getActor().getSkills().getAllSkillsOfType(this.Const.SkillType.Active)){
            if (skill.getID() == "actives.legend_raise_undead" || skill.getID() == "actives.legend_siphon_skill" || skill.getID() == "actives.legend_possession_skill" ||   skill.getID() ==  "actives.legend_wither" || skill.getID() ==  "actives.legend_horrify" || skill.getID() ==  "actives.legend_miasma" || skill.getID() ==      "actives.legend_deathtouch")
            {
                if (this.m.Kills <= 4 && this.m.Kills != 0) {
                    skill.m.FatigueCost = this.Math.floor(this.m.SkillDictionary[skill.getID()].FatigueCost * (1 - (this.m.Kills * 0.25)));
                }
                else if(this.m.Kills > 4) {
                    skill.m.FatigueCost = 0;
                    local apReduction = this.Math.floor((this.m.Kills - 1) / 2) - 1;
                    skill.m.ActionPointCost = this.m.SkillDictionary[skill.getID()].ActionPointCost - apReduction;
                }
                if (skill.m.FatigueCost < 0){
                    skill.m.FatigueCost = 0;
                    //_properties.FatigueEffectMult = 0;
                }
                //skill.m.FatigueCost     = this.m.SkillDictionary[skill.getID()].FatigueCost;
                //skill.m.ActionPointCost = this.m.SkillDictionary[skill.getID()].ActionPointCost;
            }
        }
	}
});

