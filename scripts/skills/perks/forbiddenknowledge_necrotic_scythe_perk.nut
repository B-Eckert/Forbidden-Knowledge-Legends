this.forbiddenknowledge_necrotic_scythe_perk <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.forbiddenknowledge_necrotic_scythe";
		this.m.Name = "Necrotic Scythe";
		this.m.Description = "Infuse your scythe with a small portion of your necromantic magic. Scythes gain damage equal to a portion of your initiative, health and resolve. You gain additional damage against armor and direct damage equal to 40% + twice the increases in your learning rate. Trained and knowledge potions don't count for this effect.";
		this.m.Icon = "ui/perks/perk_necrotic_scythe_forbidden_knowledge.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		local item = this.getContainer().getActor().getMainhandItem();

		if (item != null)
		{
			if (item.getID() == "weapon.legend_grisly_scythe" || item.getID() == "weapon.legend_scythe" || item.getID() == "weapon.warscythe" || item.getID() == "weapon.named_warscythe")
			{
                local user = this.getContainer().getActor();
                local learnRate = user.getCurrentProperties().XPGainMult;
                if(user.getSkills().hasSkill("effects.trained")){
                    local trained = user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
                    learnRate /= trained;
                }
                if(user.getSkills().hasSkill("effects.knowledge_potion")){ // 100% increase is just X2
                    learnRate /= 2;
                }
                _properties.DamageRegularMin += this.Math.floor(((user.getBravery() * 0.1) + (user.getHitpointsMax() * 0.075) + (user.getInitiative() * 0.075)) * learnRate * 0.75);
                _properties.DamageRegularMax += this.Math.floor(((user.getBravery() * 0.15) + (user.getHitpointsMax() * 0.125) + (user.getInitiative() * 0.125))* learnRate * 0.75);
        		_properties.DamageArmorMult += (learnRate - 0.8)*2; // .2 + learnrate bonus x2
                _properties.DirectDamageMult += (learnRate - 0.8)*2; // .2 + learnrate bonus x2
			}
		}
	}
});

