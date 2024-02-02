this.forbiddenknowledge_lich_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.forbiddenknowledge_lich";
		this.m.Name = "Lichdom";
		this.m.Description = "You have ascended to the apex of the necromancer's form, but you've lost something along the way.";
		this.m.Icon = "ui/traits/lich_forbiddenknowledge_trait.png";
		this.m.Titles = [
			"the Everliving",
			"the Eternal",
			"the Overlord",
			"the Dead Monarch",
			"the Soul Reaper",
			"the Shadowlord",
			"the Cryptkeeper",
			"the Doombringer",
			"the Haunting Hierarch",
			"the Sepulchral Sovereign",
			"the Abyssal Archmage",
			"the Undying",
			"the Grave Whisperer",
			"the Gravelord",
			"the Corpse-King"
		]
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/obituary.png",
				text = "+3 Action Points. Recovers hitpoints at only 10% of the normal rate. Requires no food."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Has no flesh. Immune to Bleeding, poison and fresh injuries."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Has no lungs. Not effected by fatigue, but needs fatigue to equip items."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Not affected by morale or allies fleeing and dying."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/papers.png",
				text = "Not affected by mood. Experience is gained at 110% normal rate."
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has no eyes, Not affected by night."
			}
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		//actor.m.rawset("InjuryType", this.m.InjuryType);
		actor.m.BloodType = this.Const.BloodType.Bones;
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.getFlags().add("undead");
		actor.getFlags().add("lich");
		actor.getFlags().add("PlayerLich");
		// get 2? idk why this works but it does
		actor = actor.get();
		// piercing resistance
		actor.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
		actor.getSkills().add(this.new("scripts/skills/actives/forbiddenknowledge_chill_touch"))
		actor.setTitle(this.m.Titles[this.Math.rand(0, this.m.Titles.len() - 1)]);
		// appearance
		local body = actor.getSprite("body");
		body.setBrush("bust_skeleton_body_02");
		body.Saturation = 0.8;
		body.varySaturation(0.2);
		body.varyColor(0.025, 0.025, 0.025);
		actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
		actor.getSprite("injury").setBrush("bust_skeleton_head_injured");
		local head = actor.getSprite("head");
		head.setBrush("bust_skeleton_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local flames = actor.addSprite("flames");
		flames.setBrush("bust_skeleton_flying_head_flames2");
		actor.setSpriteOffset("flames", this.createVec(8, 0));
		local glow = actor.addSprite("glow");
		glow.setBrush("bust_skeleton_flying_head_glow");
		actor.setSpriteOffset("glow", this.createVec(8, 0));
		local head = actor.getSprite("head");
		head.setBrush("bust_skeleton_flying_head_01");
		actor.setSpriteOffset("head", this.createVec(8,0));
		flames.Color = this.createColor("#00ff62");
		glow.Color = this.createColor("#00ff62");
		flames.Saturation = 5;
		glow.Saturation = 30;
		actor.setAlwaysApplySpriteOffset(true); // THIS IS WHAT I WAS LOOKING FOR THANK YOU NGH

		if (this.isKindOf(actor, "player"))
		{
			actor.improveMood = function ( _change, _text = "" )
			{
			};
			actor.worsenMood = function ( _change, _text = "" )
			{
			};
		}

		actor.onUpdateInjuryLayer = function ()
		{
			local injury = this.getSprite("injury");
			local injury_body = this.getSprite("injury_body");
			local p = this.m.Hitpoints / this.getHitpointsMax();
			if(p < 0.25){
				injury.Visible = true;
			}
			if (p < 0.5){
				injury_body.Visible = true;
			}
			else {
				injury.Visible = false;
				injury_body.Visible = false;
			}
		};
		local sw_onFactionChanged = actor.onFactionChanged;
		actor.onFactionChanged = function ()
		{

			sw_onFactionChanged();
			local flip = !this.isAlliedWithPlayer();
			this.getSprite("injury_body").setHorizontalFlipping(flip);
			this.getSprite("injury").setHorizontalFlipping(flip);
			actor.setSpriteOffset("head", this.createVec(flip ? -8 : 8,0));
			this.getSprite("flames").setHorizontalFlipping(flip);
			actor.setSpriteOffset("flames", this.createVec(flip ? -8 : 8,0));
			this.getSprite("glow").setHorizontalFlipping(flip);
			actor.setSpriteOffset("glow", this.createVec(flip ? -8 : 8,0));
			//this.getSprite("injury").setHorizontalFlipping(flip);
		};

		if (this.m.IsNew)
		{
			this.onApplyAppearance();
			this.m.IsNew = false;
		}

		actor.onFactionChanged();
		actor.onUpdateInjuryLayer();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		_properties.IsAffectedByNight = false;
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByFreshInjuries = false;
		_properties.MoraleEffectMult *= 0.1;
		_properties.FatigueEffectMult *= 0.0;
		_properties.HitpointsRecoveryRateMult *= 0.1;
		_properties.MovementFatigueCostMult *= 0.0;
		_properties.XPGainMult *= 1.1;
		//_properties.DailyWageMult *= 0;
		_properties.DailyFood = 0;
		_properties.ActionPoints += 3;
	}

	function onApplyAppearance()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		body.setBrush("bust_skeleton_body_02");
		body.Saturation = 0.8;
		body.varySaturation(0.2);
		body.varyColor(0.025, 0.025, 0.025);

		if (actor.getFlags().has("human"))
		{
			actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
		}

		if (this.isKindOf(actor, "player"))
		{
			actor.improveMood = function ( _change, _text = "" )
			{
			};
			actor.worsenMood = function ( _change, _text = "" )
			{
			};
		}
		local flames = actor.getSprite("flames");
		flames.setBrush("bust_skeleton_flying_head_flames2");
		actor.setSpriteOffset("flames", this.createVec(8, 0));
		local glow = actor.getSprite("glow");
		glow.setBrush("bust_skeleton_flying_head_glow");
		actor.setSpriteOffset("glow", this.createVec(8, 0));
		local head = actor.getSprite("head");
		head.setBrush("bust_skeleton_flying_head_01");
		actor.setSpriteOffset("head", this.createVec(8,0));
		flames.Color = this.createColor("#00ff62");
		glow.Color = this.createColor("#00ff62");
		flames.Saturation = 5;
		glow.Saturation = 30;
		actor.setAlwaysApplySpriteOffset(true);


		head.Color = body.Color;
		head.Saturation = body.Saturation;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		actor.m.BloodType = this.Const.BloodType.Bones;
		actor.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/skeleton_hurt_01.wav",
			"sounds/enemies/skeleton_hurt_02.wav",
			"sounds/enemies/skeleton_hurt_03.wav",
			"sounds/enemies/skeleton_hurt_04.wav",
			"sounds/enemies/skeleton_hurt_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/skeleton_death_01.wav",
			"sounds/enemies/skeleton_death_02.wav",
			"sounds/enemies/skeleton_death_03.wav",
			"sounds/enemies/skeleton_death_04.wav",
			"sounds/enemies/skeleton_death_05.wav",
			"sounds/enemies/skeleton_death_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/skeleton_idle_01.wav",
			"sounds/enemies/skeleton_idle_02.wav",
			"sounds/enemies/skeleton_idle_03.wav",
			"sounds/enemies/skeleton_idle_04.wav",
			"sounds/enemies/skeleton_idle_05.wav"
		];
		actor.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/skeleton_idle_06.wav"
		];
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.BloodType = this.Const.BloodType.Red;
		actor.m.MoraleState = this.Const.MoraleState.Steady;
		actor.getFlags().remove("undead");
		actor.getFlags().remove("lich");
		actor.getFlags().remove("PlayerLich");
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
//		_out.writeU8(this.m.InjuryType);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
//		this.m.InjuryType = _in.readU8();
	}

});

