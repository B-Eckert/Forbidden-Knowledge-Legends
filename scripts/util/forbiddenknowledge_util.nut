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
	_actor.getFlags().add("PlayerSkeleton");
	_actor.getFlags().add("undead");
	_actor.getFlags().add("skeleton");
	local fleshlessSkill = gt.new("scripts/skills/traits/legend_fleshless_trait");
	_actor.getSkills().add(fleshlessSkill);
	_actor.getSkills().add(gt.new("scripts/skills/racial/skeleton_racial"));
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
	_actor.getFlags().add("PlayerZombie");
	_actor.getFlags().add("undead");
	_actor.getFlags().add("zombie_minion");
	local rottenSkill = gt.new("scripts/skills/traits/legend_rotten_flesh_trait");
	_actor.getSkills().add(rottenSkill);
	if (this.isKindOf(_actor, "player")) {
		_actor.improveMood = function(_change, _text = "") {};
		_actor.worsenMood = function(_change, _text = "") {};
	}
	_actor.getSkills().add(gt.new("scripts/skills/perks/perk_legend_zombie_bite"));
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
	_actor.getBackground().addPerkGroup(this.Const.Perks.ForbiddenKnowledgeNecromancerTree.Tree);
	_actor.getFlags().add("IsNecromancer");
	// _actor.getSprite("socket").setBrush("bust_base_undead"); this is just here for reference
	if (!gt.Const.Necromance.CanChangeSprite(_actor)) { // if they're undead theyre probably a skeleton and we dont want to change anything
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
	_actor.getSprite("body").Color = this.createColor("#ffffff");
	_actor.getSprite("body").Saturation = 0.6;
}

gt.Const.Necromance.IsFBOrigin <- function(_origin){
	if (_origin == "scenario.dse_forbidden_knowledge" || _origin == "scenario.dse_forbidden_knowledge_hated_lich") {
		return true;
	}
	return false;
}

gt.Const.Necromance.CanLearnNecromancy <- function(_bro){
	if ((_bro.getBackground().getID() == "background.historian" || _bro.getBackground().getID() == "background.legend_witch" || _bro.getBackground().getID() == "background.legend_commander_witch") || _bro.getBackground().getID() == "background.legend_alchemist" || _bro.getBackground().getID() == "background.legend_astrologist" || _bro.getBackground().getID() == "background.anatomist" || _bro.getSkills().hasSkill("perk.legend_scholar") || _bro.getSkills().hasSkill("trait.bright") || _bro.getSkills().hasSkill("trait.legend_ambitious") || _bro.getSkills().hasSkill("trait.legend_natural"))
	{ // historians, witches, alchemists, anatomists, astrologists, and other smart people (scholars, ambitious & bright characters)
    // who neither hate undead nor fear them and aren't dumb, also aren't already undead
        if(!(_bro.getSkills().hasSkill("trait.dumb") || _bro.getSkills().hasSkill("trait.fear_undead") || _bro.getSkills().hasSkill("trait.hate_undead") || _bro.getSkills().hasSkill("trait.legend_fleshless") || _bro.getSkills().hasSkill("trait.legend_rotten_flesh") || _bro.getFlags().has("IsNecromancer")))
        {
            return true;
    	}
	}
	return false;
}