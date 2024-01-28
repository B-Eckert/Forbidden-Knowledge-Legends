this.forbiddenknowledge_chill_touch <- this.inherit("scripts/skills/skill", {
	m = {
        AdditionalAccuracy = 0,
		AdditionalHitChance = 0
    },
	function create()
	{
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
		this.m.IsUsingHitchance = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 10;
		_properties.DamageRegularMax += 30;
		_properties.IsIgnoringArmorOnAttack = true;
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

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

