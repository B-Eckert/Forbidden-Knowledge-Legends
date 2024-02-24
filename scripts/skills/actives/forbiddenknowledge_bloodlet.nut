this.forbiddenknowledge_bloodlet <- this.inherit("scripts/skills/skill", {
	m = {
        HPCostPercentage = 0.2,
    },
	function create()
	{
		this.m.ID = "actives.forbiddenknowledge_bloodlet";
		this.m.Name = "Bloodlet";
		this.m.Description = "You perform a bloodletting ritual that cleanses your body of its weariness, reducing your current fatigue by shedding your life essence.";
		this.m.Icon = "skills/bloodlet_forbidden_knowledge.png";
		this.m.IconDisabled = "skills/bloodlet_forbidden_knowledge_bw.png";
        this.m.SoundOnUse = [
			"sounds/combat/drain_01.wav",
			"sounds/combat/drain_02.wav",
			"sounds/combat/drain_03.wav",
			"sounds/combat/drain_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

    function getTooltip()
	{
		local user = this.getContainer().getActor();
		local hpLoss = this.Math.ceil(user.getHitpointsMax() * this.m.HPCostPercentage);
        local learnRate = user.getCurrentProperties().XPGainMult;
        if(user.getSkills().hasSkill("effects.trained")){
            local trained = user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
            learnRate /= trained;
        }
        if(user.getSkills().hasSkill("effects.knowledge_potion")){
            learnRate /= 2; // 100% increase is just X2
        }
        local fatLoss = this.Math.floor(hpLoss * (1.2 + learnRate));
		local ret = [
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
                icon = "ui/icons/health.png",
                text = "Costs [color=" + this.Const.UI.Color.DamageValue + "]" + hpLoss + "[/color] to use. Your fatigue is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]" + fatLoss + "[/color]."
            }
		];
		return ret;
	}


	function isUsable(){
		// check for regulr usability
		if (!this.skill.isUsable()) {
			return false;
		}
		// check for user hp
		local user = this.getContainer().getActor();
		if (user.getHitpoints() < this.Math.ceil(user.getHitpointsMax() * this.m.HPCostPercentage)){
			return false;
		}
        // if your fatigue mult is 0 there is no point to using it so you cant
        if (user.getCurrentProperties().FatigueEffectMult <= 0 || user.getFatigue() == 0) {
            return false;
        }
		// all passed
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local hpLoss = this.Math.ceil(_user.getHitpointsMax() * this.m.HPCostPercentage);
        local learnRate = _user.getCurrentProperties().XPGainMult;
        if(_user.getSkills().hasSkill("effects.trained")){
            local trained = _user.getSkills().getSkillByID("effects.trained").m.XPGainMult;
            learnRate /= trained;
        }
        if(_user.getSkills().hasSkill("effects.knowledge_potion")){
            learnRate /= 2; // 100% increase is just X2
        }
        local fatLoss = this.Math.floor(hpLoss * (1.2 + learnRate));
		_user.setFatigue(_user.getFatigue() - fatLoss);
        if (_user.getFatigue() < 0){
            _user.setFatigue(0);
        }
		_user.setHitpoints(_user.getHitpoints() - hpLoss);
		return true;
	}
});

