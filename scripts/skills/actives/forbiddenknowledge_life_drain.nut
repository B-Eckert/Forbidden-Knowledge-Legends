this.forbiddenknowledge_life_drain <- this.inherit("scripts/skills/legend_magic_skill", {
	m = {
		Range = 4,
		BaseFatigueCost = 5,
		HPCostPercentage = 0.25,
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
		this.m.Description = "You drain the very life of the creature before you, granting their vitality to yourself.";
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
		local user = this.getContainer().getActor();
		local hpLoss = this.Math.ceil(user.getHitpointsMax() * this.m.HPCostPercentage);
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
			icon = "ui/icons/health.png",
			text = "Accuracy based on melee skill or ranged skill (whichever is higher). You deal damage equal to 20-40% + a half your learning rate of your max HP and heal for the damage dealt. Costs [color=" + this.Const.UI.Color.DamageValue + "]" + hpLoss + "[/color] to use."
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
			_properties.DamageRegularMin = this.Math.ceil((user.getHitpointsMax() * (0.20 + ((learnRate-1) * 0.5))));
			_properties.DamageRegularMax = this.Math.ceil((user.getHitpointsMax() * (0.40 + ((learnRate-1) * 0.5))));
			if (user.getSkills().getSkillByID("special.double_grip").canDoubleGrip()) {
				_properties.MeleeDamageMult /= 1.25;
			}
			// Pick higher between melee and ranged.
			if(user.getCurrentProperties().getMeleeSkill() > user.getCurrentProperties().getRangedSkill()){
				_properties.MeleeSkill = user.getCurrentProperties().getMeleeSkill();
			}
			else{
				_properties.MeleeSkill = user.getCurrentProperties().getRangedSkill();
			}
			//_properties.DamageArmorMult *= 0.0
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}
	function onUse( _user, _targetTile )
	{
		//_user.setHitpoints(this.Math.max(_user.getHitpoints() - Math.floor((_user.getHitpointsMax() * 0.05)));
		_user.setHitpoints(_user.getHitpoints() - this.Math.ceil(_user.getHitpointsMax() * this.m.HPCostPercentage));
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function isUsable(){
		// check for regulr usability
		if (!this.legend_magic_skill.isUsable()){
			return false;
		}
		// check for user hp
		local user = this.getContainer().getActor();
		if (user.getHitpoints() < this.Math.ceil((user.getHitpointsMax() * this.m.HPCostPercentage))){
			return false;
		}
		// all passed
		return true;
	}
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill != this)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local maxHP = actor.getHitpointsMax();
		actor.setHitpoints(this.Math.min(actor.getHitpoints() + _damageInflictedHitpoints, maxHP));
	}
});

