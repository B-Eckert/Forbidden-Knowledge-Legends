this.forbiddenknowledge_chill_touch <- this.inherit("scripts/skills/legend_magic_skill", {
	m = {
		Range = 4,
		BaseFatigueCost = 20,
		StoreMeleeSkill = -1,
    },
	function create()
	{
		this.legend_magic_skill.create();
		this.m.AdditionalAccuracy = 0;
		this.m.DamageInitiativeMin = 1;
		this.m.DamageInitiativeMax = 2;
		this.m.ID = "actives.forbiddenknowledge_chill_touch";
		this.m.Name = "Chill Touch";
		this.m.Description = "You reach out with your necromantic power to touch the very soul of your target and shred it.";
		this.m.KilledString = "Soul was ripped apart.";
		this.m.Icon = "skills/chill_touch_forbidden_knowledge.png";
		this.m.IconDisabled = "skills/chill_touch_forbidden_knowledge_bw.png";
		//this.m.Overlay = "chill_touch";
		this.m.SoundOnHit = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
        this.m.SoundOnUse = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 400;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsShieldRelevant = false,
		//this.m.IsShieldwallRelevant = false,
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = this.m.BaseFatigueCost;
		this.m.MinRange = 1;
		this.m.MaxRange = this.m.Range;
		this.m.MaxLevelDifference = 6;
		this.m.ProjectileType = this.Const.ProjectileType.Missile;
	}

    function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles."
			}
		]);
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = "Accuracy based on melee skill or ranged skill (whichever is higher), damage based on health, resolve and initiative, and then is multiplied by your learning rate. Bypasses shields and armor."
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.legend_magic_skill.onAnySkillUsed(_skill, _targetEntity, _properties);
		if (_skill == this)
		{
			local user = this.getContainer().getActor();
			local learnRate = user.getCurrentProperties().XPGainMult;
			if(user.getSkills().hasSkill("effects.trained")){
				local trained = user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
				learnRate /= trained;
			}
			if(user.getSkills().hasSkill("effects.knowledge_potion")){
				learnRate /= 2; // 100% increase is just X2
			}
			_properties.DamageRegularMin = this.Math.floor(((user.getBravery() * 0.1) + (user.getHitpointsMax() * 0.075) + (user.getInitiative() * 0.075)) * learnRate * 0.85);
			_properties.DamageRegularMax = this.Math.floor(((user.getBravery() * 0.15) + (user.getHitpointsMax() * 0.125) + (user.getInitiative() * 0.125))* learnRate * 0.85);
			if (user.getSkills().getSkillByID("special.double_grip").canDoubleGrip()) {
				_properties.MeleeDamageMult /= 1.25;
			}
			// Pick higher between melee and ranged.
			this.m.StoreMeleeSkill = user.getCurrentProperties().getMeleeSkill();
			if(user.getCurrentProperties().getMeleeSkill() > user.getCurrentProperties().getRangedSkill()){
				_properties.MeleeSkill = user.getCurrentProperties().getMeleeSkill();
			}
			else{
				_properties.MeleeSkill = user.getCurrentProperties().getRangedSkill();
			}
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}
});

