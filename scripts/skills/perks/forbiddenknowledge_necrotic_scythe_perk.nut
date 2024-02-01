this.forbiddenknowledge_necrotic_scythe_perk <- this.inherit("scripts/skills/skill", {
	m = {
        Kills = 0,
        StoredFatigue = -1,
        StoredActionPointCost = -1,
        StoredSkill = null,
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

    function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.legend_raise_undead" || _skill.getID() == "actives.legend_siphon_skill" || _skill.getID() == "actives.legend_possession_skill" || _skill.getID() ==  "actives.legend_wither" || _skill.getID() ==  "actives.legend_horrify" || _skill.getID() ==  "actives.legend_miasma" || _skill.getID() ==  "actives.legend_deathtouch")
		{
            ::logInfo("SCYTHE: Kill Counter - " + this.m.Kills);
            local user = this.getContainer().getActor();
            //::logInfo("SCYTHE: Storing variables...")
            //this.m.StoredFatigue = _skill.m.FatigueCost;
            //this.m.StoredActionPointCost = _skill.m.ActionPointCost;
            //this.m.StoredSkill = _skill;
            //::logInfo("SCYTHE: Stored Skill: " + this.m.StoredSkill.getName() + " | Stored AP Cost: " + this.m.StoredActionPointCost + " | Stored Fatigue Cost: " + this.m.StoredFatigue);
            if (this.m.Kills <= 5 && this.m.Kills != 0) {
                _properties.FatigueEffectMult -= this.m.Kills * 0.2;
                //_skill.m.FatigueCost *= (1 - this.m.Kills * 0.2);
                this.m.Kills -= 2;

                ::logInfo("SCYTHE: New Fatigue Cost = " + _skill.m.FatigueCost);
            }
            else if(this.m.Kills > 5) {
                _properties.FatigueEffectMult -= 1;
                //_skill.m.FatigueCost *= 0;
                local apReduction = this.Math.floor(this.m.Kills / 3) - 1;
                ::logInfo("SCYTHE: New Fatigue Cost [MAX KILLS] = " + _skill.m.FatigueCost + "; AP Reduction = " + apReduction);
                //_skill.m.ActionPointCost -= apReduction;
                //_properties.ActionPointCost -= apReduction;
                this.m.Kills -= 2; //3;// when action point stuff works
            }
            // negative check
            if (this.m.Kills <=  0){
                this.m.Kills = 0;
            }
            if (_skill.m.FatigueCost < 0){
                //_properties.FatigueEffectMult = 0;
            }
		}
	}
    // increase kill counter when a scythe kills someone
    function onTargetKilled( _targetEntity, _skill )
	{
		local item = this.getContainer().getActor().getMainhandItem();
        if (item.getID() == "weapon.legend_grisly_scythe" || item.getID() == "weapon.legend_scythe" || item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe")
		{
            if(_skill.getID() == "actives.cleave" || _skill.getID() == "actives.reap" || _skill.getID() == "actives.strike"){
                ::logInfo("SCYTHE: Killstreak! Kill counter currently " + this.m.Kills);
                this.m.Kills += 1;
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
                    multiplier = 1.1;
                }
                if (item.getID() == "weapon.legend_grisly_scythe"){
                    multiplier = 0.75;
                }
                if(item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe"){
                    multiplier = 0.3;
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
        		_properties.DamageArmorMult += (learnRate - 0.95) * 1.5 * (multiplier/2); // .1 + learnrate bonus x2
                //_properties.DamageDirectAdd += ((_properties.DamageRegularMin + _properties.DamageRegularMax)/2) * (learnRate - 0.8)*2 + 1; // .2 + learnrate bonus x2
                _properties.DamageDirectMult += (learnRate - 0.8)* 2 * (multiplier + 0.3); // .1 + learnrate bonus x2
			}
		}
	}

    function reset(){
        if(this.m.StoredSkill != null && this.m.StoredFatigue != -1 && this.m.StoredActionPointCost != -1){
            ::logInfo("SCYTHE: Resetting values of " + this.m.StoredSkill.getName())
            this.m.StoredSkill.m.FatigueCost = this.m.StoredFatigue;
            this.m.StoredSkill.m.ActionPointCost = this.m.StoredActionPointCost;

            this.m.StoredSkill = null;
            this.m.StoredFatigue = -1;
            this.m.StoredActionPointCost = -1;
        }
    }

    function onTurnEnd()
	{
        ::logInfo("SCYTHE: Turn has ended; resetting.");
        reset();
	}
    /*
    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
        ::logInfo("SCYTHE: Target was hit; resetting.")
        reset();
	}

	function onTargetMissed( _skill, _targetEntity )
	{
        ::logInfo("SCYTHE: Target was missed; resetting.")
        reset();
	}

	function onTargetKilled( _targetEntity, _skill )
	{
        ::logInfo("SCYTHE: Target was killed; resetting.")
        reset();
    }*/
});

