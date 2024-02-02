this.forbiddenknowledge_life_drain <- this.inherit("scripts/skills/legend_magic_skill", {
	m = {
		Range = 4,
		BaseFatigueCost = 5
    },
	function create()
	{
		this.legend_magic_skill.create();
		this.m.AdditionalAccuracy = 0;
		this.m.DamageInitiativeMin = 1;
		this.m.DamageInitiativeMax = 2;
		this.m.ID = "actives.forbiddenknowledge_life_drain";
		this.m.Name = "Life Drain";
		/* Design
		Adds a "hemomancy" perk that unlocks a "drain life" spell that replaces the current legends "SIPHON" one in the necromancer perk tree. Effectively it'd be a perk that adds a skill which scales entirely off of your health. It works very similarly, but rather than costing a lot of fatigue its a risk; you spend 5% of your current hit points to cast it. Like Chill Touch, it uses the better of your ranged and melee attack skills and acts like the whip. If it hits, it deals damage equal to 20-40% of your health and heals you for that amount, with a net gain of +10-30% health.
		*/
		this.m.Description = "You drain the very life of the creature before you, granting life to yourself. You spend 5% of your current hit points to cast Life Drain. The attack uses the better of your Ranged and Melee skill. If you hit, you deal damage equal to 10-20% + a quarter-half your learning rate of your max HP and heal for the damage dealt.";
		this.m.KilledString = "Their life was drained away.";
		this.m.Icon = "skills/drain_life_forbidden_knowledge.png";
		this.m.IconDisabled = "skills/drain_life_forbidden_knowledge_bw.png";
		//this.m.Overlay = "chill_touch";
		this.m.SoundOnHit = [
			"sounds/enemies/vampire_life_drain_01.wav",
			"sounds/enemies/vampire_life_drain_02.wav",
			"sounds/enemies/vampire_life_drain_03.wav"
		];
        this.m.SoundOnUse = [
			"sounds/combat/drain_01.wav",
			"sounds/combat/drain_02.wav",
			"sounds/combat/drain_03.wav",
			"sounds/combat/drain_04.wav"
		];
		this.m.IsUsingActorPitch = false;
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
		this.m.IsShieldwallRelevant = false,
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = this.m.BaseFatigueCost;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 6;
		this.m.ProjectileType = this.Const.ProjectileType.Missile;
		this.m.HPCost = 0;
	}

    function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles on even ground, more if shooting downhill."
			}
		]);
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/health.png",
			text = "Accuracy based on melee skill or ranged skill (whichever is higher). You deal damage equal to 10-20% + a quarter-half your learning rate of your max HP and heal for the damage dealt."
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.legend_magic_skill.onAnySkillUsed(_skill, _targetEntity, _properties);
		if (_skill == this)
		{
			local user = this.getContainer().getActor();
			// take the damage
			this.m.HPCost = (user.getHitpointsMax() * 0.05);

			local learnRate = user.getCurrentProperties().XPGainMult;
			if(user.getSkills().hasSkill("effects.trained")){
				local trained = user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
				learnRate /= trained;
			}
			if(user.getSkills().hasSkill("effects.knowledge_potion")){
				learnRate /= 2; // 100% increase is just X2
			}
			_properties.DamageRegularMin = this.Math.floor((user.getHitpointsMax() * (0.10 + (learnRate * 0.25))));
			_properties.DamageRegularMax = this.Math.floor((user.getHitpointsMax() * (0.20 + (learnRate * 0.5))));

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

