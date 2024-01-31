this.forbiddenknowledge_necrotic_scythe_perk <- this.inherit("scripts/skills/skill", {
	m = {
        Kills = 0,
    },
	function create()
	{
		this.m.ID = "perk.forbiddenknowledge_necrotic_scythe";
		this.m.Name = "Necrotic Scythe";
		this.m.Description = "Infuse your scythe with a small portion of your necromantic magic. Scythes gain damage equal to a portion of your initiative, health and resolve. Warscythes gain a smaller portion of this damage. You gain additional damage against armor and direct damage equal to 40% + twice the increases in your learning rate. Trained and knowledge potions don't count for this effect.\n\n[color=";
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
            if (this.m.Kills <= 5 && this.m.Kills != 0) {
                _properties.FatigueEffectMult -= this.m.Kills * 0.2;
                this.m.Kills -= 2;
            }
            else {
                _properties.FatigueEffectMult -= 1;
                local apReduction = this.Math.floor(this.m.Kills / 3) - 1;
               _properties.ActionPointCost -= apReduction;
               this.m.Kills -= 3;
            }
            // negative check
            if (this.m.Kills <=  0){
                this.m.Kills = 0;
            }
            if (_properties.FatigueEffectMult < 0){
                _properties.FatigueEffectMult = 0;
            }
		}
	}
    // increase kill counter.
    function onTargetKilled( _targetEntity, _skill )
	{
		this.m.Kills += 1;
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
                    multiplier = .7;
                }
                if (item.getID() == "weapon.legend_grisly_scythe"){
                    multiplier = .55;
                }
                if(item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe"){
                    multiplier = .4;
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
                _properties.DamageRegularMax += this.Math.floor(((user.getBravery() * 0.15) + (user.getHitpointsMax() * 0.125) + (user.getInitiative() * 0.125))* learnRate * multiplier);
        		_properties.DamageArmorMult += (learnRate - 0.8)*2; // .2 + learnrate bonus x2
                _properties.DirectDamageMult += (learnRate - 0.8)*2; // .2 + learnrate bonus x2
			}
		}
	}
});

