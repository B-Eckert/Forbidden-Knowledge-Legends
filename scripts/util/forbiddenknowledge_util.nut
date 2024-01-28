// thank you lonemind for showing me how to do this
local gt = this.getroottable();

if (!("Necromance" in gt.Const)) {
	gt.Const.Necromance <- {};
}

gt.Const.Necromance.CanChangeSprite <- function(_actor){
	if(_actor.getFlags().has("undead") || !_actor.getFlags().has("human") || _actor.getSkills().hasSkill("background.legend_donkey")){
		return false;
	}
	return true;
}

gt.Const.Necromance.Skeletonize <-  function(_actor) {
	_actor.setMoraleState(gt.Const.MoraleState.Ignore);
	_actor.getFlags().set("PlayerSkeleton", true);
	_actor.getFlags().set("undead", true);
	_actor.getFlags().set("skeleton", true);
	local fleshlessSkill = gt.new("scripts/skills/traits/legend_fleshless_trait");
	_actor.getSkills().add(fleshlessSkill);
	_actor.getSkills().add(gt.new("scripts/skills/racial/skeleton_racial"));
	_actor.getSkills().add(gt.new("scripts/skills/perks/perk_nine_lives"));
	local body = _actor.getSprite("body");
	body.setBrush("bust_skeleton_body_0" + gt.Math.rand(1, 2));
	body.Saturation = 0.8;
	body.varySaturation(0.2);
	body.varyColor(0.025, 0.025, 0.025);

	if (_actor.getFlags().has("human")) {
		_actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
	}

	if (this.isKindOf(_actor, "player")) {
		_actor.improveMood = function(_change, _text = "") {};
		_actor.worsenMood = function(_change, _text = "") {};
	}

	local head = _actor.getSprite("head");
	head.setBrush("bust_skeleton_head");
	head.Color = body.Color;
	head.Saturation = body.Saturation;
    // speculative skeleton face
}

gt.Const.Necromance.Zombify <-  function(_actor) {
	_actor.setMoraleState(gt.Const.MoraleState.Ignore);
	_actor.getFlags().set("PlayerZombie", true);
	_actor.getFlags().set("undead", true);
	_actor.getFlags().set("zombie_minion", true);
	local rottenSkill = gt.new("scripts/skills/traits/legend_rotten_flesh_trait");
	_actor.getSkills().add(rottenSkill);
	_actor.getSkills().add(gt.new("scripts/skills/perks/perk_legend_zombie_bite"));
	_actor.getSkills().add(gt.new("scripts/skills/perks/perk_nine_lives"));
}

gt.Const.Necromance.GreyHair <-  function(_actor, hair) {
	// take the helmet off
	local helm = _actor.getItems().getData()[this.Const.ItemSlot.Head][0];
	_actor.getItems().getData()[this.Const.ItemSlot.Head][0] = -1; // thank you Luft for this code, its taken from the Red Court Hemovore trait

	local target;
	if (hair) {
		target = "hair";
	} else {
		target = "beard";
	}
	if (!_actor.getSprite(target).HasBrush) {
		_actor.getItems().getData()[this.Const.ItemSlot.Head][0] = helm;
		return;
	}

	_actor.getSprite(target).Color = this.createColor("#ffffff");
	local hair = _actor.getSprite(target).getBrush().Name;
    local color;
    if (this.String.contains(hair, "_black_")) {
		color = "black";
	} else if (this.String.contains(hair, "_blonde_")) {
		color = "blonde";
	} else if (this.String.contains(hair, "_grey_")) {
        // returning because we already wanted grey hair
		_actor.getItems().getData()[this.Const.ItemSlot.Head][0] = helm;
		return;
	} else if (this.String.contains(hair, "_red_")) {
		color = "red";
	} else if (this.String.contains(hair, "_brown_")) {
		color = "brown";
	}
    else{
        _actor.getItems().getData()[this.Const.ItemSlot.Head][0] = helm;
		return;
    }
	local firstUnderscore = hair.find("_" + color);
	local secondUnderscore = hair.find("_", firstUnderscore+2)
	local newHair = hair.slice(0, firstUnderscore + 1) + "grey" + hair.slice(secondUnderscore);
    if (this.doesBrushExist(newHair)) {
		_actor.getSprite(target).setBrush(newHair);
	}
    if(this.doesBrushExist(newHair + "_top")){
        _actor.getSprite(target + "_top").setBrush(newHair + "_top");
    }

	// put the helmet back on
	_actor.getItems().getData()[this.Const.ItemSlot.Head][0] = helm;
}

gt.Const.Necromance.LearnNecromancy <-  function(_actor) { // very sadly when you become a necromancer you become northern cus all the faces are northern.
	// i explain this by saying "the necromancy drains all pigmentation from your skin" and call it a day
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendBrinkOfDeath, 4, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendPossession, 2, false);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendMiasma, 6, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendDeathtouch, 5, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendWither, 1, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendSiphon, 5, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendSpecialistScytheSkill, 0, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendSpecialistScytheDamage, 2, true);
	_actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendHorrify, 5, true);
	_actor.getFlags().add("IsNecromancer");
	// _actor.getSprite("socket").setBrush("bust_base_undead"); this is just here for reference
	if (!gt.Necromance.CanChangeSprite(_actor)) { // if they're undead theyre probably a skeleton and we dont want to change anything
		return;
	}
	if (_actor.getGender() == 1) {
		_actor.getSprite("head").setBrush("bust_head_necro_female_0" + gt.Math.rand(1, 2));
		_actor.getSprite("body").setBrush("bust_female_northern_body_00"); // become skinny
	} else {
		_actor.getSprite("head").setBrush("bust_head_necro_0" + gt.Math.rand(1, 2));
		_actor.getSprite("body").setBrush("bust_naked_body_00"); // become skinny
	}

	gt.Const.Necromance.GreyHair(_actor, true);
	gt.Const.Necromance.GreyHair(_actor, false);

	_actor.getSprite("head").Color = this.createColor("#ffffff");
	_actor.getSprite("head").Saturation = 1.0;
	_actor.getSprite("body").Saturation = 0.6;
}
/*
gt.Const.Necromance.AchieveLichdom <- function(_actor){
     TODO: Make a Lich trait to replace Fleshless
        - Sparknotes
            - 12 AP (+3 AP to cast 2 Possesses or 3 Raise Dead)
            - Strong bones (no halved HP, just 75%)
            - Magically Powered (no fatigue)
            - Deathless (On death do not die)
            - Innately have Death Touch
        Later Ideas for Features
            - You lose all of your items when you die.
            - You are the 'ghost' lich and have an 'injury' that is removed after a few days.
                - While a ghost, you can equip nothing but you have Death Touch as your only move.

    gt.Const.Necromance.Skeletonize(_actor);
	gt.Const.Necromance.LearnNecromancy(_actor);
	 // turn them into a skeleton // give them necromancy
	// AESTHETICS
	if(_actor.getSprite("face")){
		_actor.removeSprite("face");
	}
	local flames = _actor.addSprite("flames");
	flames.setBrush("bust_skeleton_flying_head_flames2");
	_actor.setSpriteOffset("flames", this.createVec(6, 0));
	local glow = _actor.addSprite("glow");
	glow.setBrush("bust_skeleton_flying_head_glow");
	_actor.setSpriteOffset("glow", this.createVec(9, 0));
	local head = _actor.getSprite("head");
	head.setBrush("bust_skeleton_flying_head_02");
	_actor.setSpriteOffset("head", this.createVec(9,0));
	_actor.setAlwaysApplySpriteOffset(true); // THIS IS WHAT I WAS LOOKING FOR THANK YOU NGH
	// AESTHETICS OVER

	// ARMOR
    local armor = [
        [
            1,
            "ancient/ancient_lich_attire"
        ]
    ];
    local item = gt.Const.World.Common.pickArmor(armor);
    _actor.getItems().equip(item);
    local helmet = [
        [
            1,
            "ancient/ancient_lich_headpiece"
        ]
    ];
    _actor.getItems().equip(gt.Const.World.Common.pickHelmet(helmet));
	// ARMOR OVER
}*/