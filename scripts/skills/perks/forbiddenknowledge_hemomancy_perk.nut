this.forbiddenknowledge_hemomancy_perk <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.forbiddenknowledge_hemomancy";
		this.m.Name = this.Const.Strings.PerkName.ForbiddenKnowledgeHemomancy;
		this.m.Description = this.Const.Strings.PerkDescription.ForbiddenKnowledgeHemomancy;
		this.m.Icon = "ui/perks/perk_hemomancy_forbidden_knowledge.png";
		this.m.IconDisabled = "ui/perks/perk_hemomancy_forbidden_knowledge_bw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.forbiddenknowledge_life_drain"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/forbiddenknowledge_life_drain"));
		}
		if (!this.m.Container.hasSkill("actives.forbiddenknowledge_bloodlet"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/forbiddenknowledge_bloodlet"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.forbiddenknowledge_life_drain");
		this.m.Container.removeByID("actives.forbiddenknowledge_bloodlet");
	}

});

