this.forbiddenknowledge_chill_touch <- this.inherit("scripts/skills/legend_magic_skill", {
	m = {
		Range = 6,
		BaseFatigueCost = 20
    },
	function create()
	{
		this.legend_magic_skill.create();
		this.m.AdditionalAccuracy = 0;
		this.m.DamageInitiativeMin = 20;
		this.m.DamageInitiativeMax = 50;
		this.m.ID = "actives.forbiddenknowledge_chill_touch";
		this.m.Name = "Chill Touch";
		this.m.Description = "You reach out with your necromantic power to touch the very soul of your target and shred it.";
		this.m.KilledString = "Soul was ripped apart.";
		this.m.Icon = "skills/chill_touch.png";
		this.m.IconDisabled = "skills/chill_touch_bw.png";
		this.m.Overlay = "chill_touch";
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
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsShieldRelevant = false,
		this.m.IsShieldwallRelevant = false,
		this.m.IsDoingForwardMove = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = this.m.BaseFatigueCost;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
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
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles on even ground, more if shooting downhill."
			}
		]);
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = "Accuracy based on ranged skill, damage based on initiative. Bypasses shields."
		});
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		this.legend_magic_skill.onAnySkillUsed(_skill, _targetEntity, _properties);
		if (_skill == this)
		{
			//local user = this.getContainer().getActor();
			//_properties.DamageRegularMin = this.Math.floor((user.getBravery() * .25) + (user.getHitpointsMax() * .25) + (user.getInitiative() * .25));
			//_properties.DamageRegularMax = this.Math.floor((user.getBravery() * .5) + (user.getHitpointsMax() * .5) + (user.getInitiative() * .5));
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCost = this.m.BaseFatigueCost;
		this.m.MaxRange = this.m.Range;
		this.m.FatigueCostMult = 1.0;
		this.m.ActionPointCost = 4;
	}

});

