// Credit to Legends Risen Legion Origin for baseline.
this.forbiddenknowledge_hated_lich_recruits_from_location <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
        location = null,
        skeletonSites = [
            // skeleton
            "location.undead_mass_grave",
            "location.black_monolith",
            "location.undead_vampire_coven",
            "location.undead_buried_castle"
        ],
        zombieSites = [
            "location.undead_graveyard",
            "location.undead_crypt",
            "location.undead_necromancers_lair",
            "location.undead_ruins"
        ],
        bothSites = [
            "location.undead_necropolis"
        ],
        civilianBackgrounds = [
			"anatomist_background",
			"apprentice_background",
			"beggar_background",
			"bowyer_background",
			"brawler_background",
			"butcher_background",
			"cripple_background",
			"daytaler_background",
			"eunuch_background",
			"farmhand_background",
			"fisherman_background",
			"gambler_background",
			"gravedigger_background",
			"graverobber_background",
			"historian_background",
			"houndmaster_background",
			"juggler_background",
			"lumberjack_background",
			"mason_background",
			"messenger_background",
			"miller_background",
			"miner_background",
			"minstrel_background",
			"monk_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"shepherd_background",
			"tailor_background",
			"legend_herbalist_background",
			"legend_inventor_background",
			"legend_ironmonger_background",
			"legend_taxidermist_background",
			"legend_trader_background",
		]
	},
	function create()
	{
		this.m.ID = "event.forbiddenknowledge_hated_lich_recruits_from_location";
		this.m.Title = "An Act of Necromancy";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_raising_undead.png[/img]{There are sites of great necromantic power in the world, where death clings to the earth like dew to grass. This is one such place. You channel your innate powers into the earth itself, rising up a body to suit your own purposes. One such body has arisen, though whether it is suitable to your purposes, only you can decide. | You have wandered the earth as an ageless, deathless thing for years, and always you were comforted by places like this. Death sweetens the air with its own sickly metallic scent - of course, your nose has long since rotted away, but you remember the smell fondly. You reach into the earth and draw from it a body, animated by your will. You may choose to keep it, if you wish; or discard it and let its denizen rest. | You feel the tug of undeath, the jerk of a servile soulless husk willing to be bent to your will. You follow that impulse, and at the end of it lies a body crawling up from the earth beneath you. Your magic reforms its essence but now you have the ultimate choice of keeping it or halting the process, robbing it of your magic and returning it to the earth. | Places like this are not rare, but they are each unique in their own way. This one's uniqueness has presented itself in the form of a wandering undead who seems to have lost themselves amidst the flagstones. They gaze at you with empty eyes, devoid of any semblance of will or consciousness. You could fill that void with your own easily, but do you want to? | As you wander in these liminal spaces of life and unlife, you have come to find that its denizens flock to you like sheep to a shephard. You do not mind this, of course; it has always served your needs. Another lost lamb approaches you now, witless and mindless. It is yours, if you choose; or you could simply smash it back into the earth. The choice is yours.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rise, my minion!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}
				},
                {
                    Text = "Back to your slumber, corpse.",
                    function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}
                }
			],
			function start( _event )
			{

		        local rarity = this.Math.rand(1, 100);
				local roster = this.World.getTemporaryRoster();
                local coinflip = 0;
                if(_event.m.bothSites.find(_event.m.location) !=  null){
                    // both
                    if (rarity % 2 ==  0) {
                        coinflip = 1
                    }
                    else {
                        coinflip = 2
                    }
                }
                if (_event.m.skeletonSites.find(_event.m.location) != null || coinflip == 1) {
                    // skeletons
                    local undeadBackgrounds = [
                        ["militia_background"], // auxiliary gear
                        ["retired_soldier_background"], // soldier gear
                        ["gladiator_background",  "beast_hunter_background"], // gladiator gear
                        ["hedge_knight_background",  "swordmaster_background"] // honorguard gear
                    ];
                    local choice = ["vagabond_background"];
                    /*if(rarity > 95){ - Add this in if you can figure dependency checks out. Then you can use Red Court stuff.
                        this.m.ChosenBackground = "legend_necrosavant_background";
                        return "Necrosavant";
                    }*/
                    if (rarity > 90){ // 10
                        choice = undeadBackgrounds[3];
                    }
                    else if(rarity > 80){ // 10
                        choice = undeadBackgrounds[2];
                    }
                    else if(rarity > 50){ // 30
                        choice = undeadBackgrounds[1];
                    }
                    else{ // 50
                        choice = undeadBackgrounds[0];
                    }
                    local background = choice[this.Math.rand(0, choice.len() - 1)]; // random skele background.
                    _event.m.Dude = roster.create("scripts/entity/tactical/player");
                    _event.m.Dude.setStartValuesEx([
                        background,
                    ]);
                    _event.m.Dude.getBackground().m.RawDescription = "A " + "soldier of the old empire" + " who has been brought under your control after seeming lost.";
                    _event.m.Dude.getBackground().buildDescription(true);
                    this.Const.Necromance.Skeletonize(_event.m.Dude); // B O N E S
                    local inventory = _event.m.Dude.getItems();
                    if(true) {// this is because im lazy and for formatting purposes so i can minimize everything
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Offhand));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Body));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Head));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Ammo));
                        if (undeadBackgrounds[0].find(background) !=  null) {
                            local r = this.Math.rand(1, 3);
                            if (r == 1)
                            {
                                inventory.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
                            }
                            else if (r == 2)
                            {
                                inventory.equip(this.new("scripts/items/weapons/ancient/falx"));
                            }
                            else if (r == 3)
                            {
                                inventory.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
                            }

                            if (this.Math.rand(1, 100) <= 66)
                            {
                                inventory.equip(this.new("scripts/items/shields/ancient/auxiliary_shield"));
                            }

                            local armor = [
                                [
                                    1,
                                    "ancient/ancient_ripped_cloth"
                                ]
                            ];
                            local item = this.Const.World.Common.pickArmor(armor);
                            inventory.equip(item);
                            item = this.Const.World.Common.pickHelmet([
                                [
                                    66,
                                    "ancient/ancient_household_helmet"
                                ],
                                [
                                    34,
                                    ""
                                ]
                            ]);

                            if (item != null)
                            {
                                inventory.equip(item);
                            }
                        }
                        else if (undeadBackgrounds[1].find(background) !=  null) {
                            local weapons = [
                                [
                                    1,
                                    "weapons/ancient/broken_ancient_sword"
                                ],
                                [
                                    2,
                                    "weapons/ancient/ancient_sword"
                                ],
                                [
                                    1,
                                    "weapons/ancient/legend_gladius"
                                ],
                                [
                                    1,
                                    "weapons/ancient/broken_bladed_pike"
                                ],
                                [
                                    1,
                                    "weapons/ancient/bladed_pike"
                                ]
                            ];
                            inventory.equip(this.Const.World.Common.pickItem(weapons, "scripts/items/"));

                            if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
                            {
                                if (this.Math.rand(1, 100) <= 66)
                                {
                                    inventory.equip(this.new("scripts/items/shields/ancient/coffin_shield"));
                                }
                                else
                                {
                                    inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
                                }
                            }

                            local armor = [
                                [
                                    1,
                                    "ancient/ancient_scale_harness"
                                ],
                                [
                                    1,
                                    "ancient/ancient_breastplate"
                                ],
                                [
                                    1,
                                    "ancient/ancient_mail"
                                ],
                                [
                                    1,
                                    "ancient/ancient_double_layer_mail"
                                ]
                            ];
                            local item = this.Const.World.Common.pickArmor(armor);
                            inventory.equip(item);
                            local item = this.Const.World.Common.pickHelmet([
                                [
                                    99,
                                    "ancient/ancient_honorguard_helmet"
                                ],
                                [
                                    1,
                                    "ancient/legend_ancient_legionary_helmet_restored"
                                ]
                            ]);

                            if (item != null)
                            {
                                inventory.equip(item);
                            }
                        }
                        else if (undeadBackgrounds[2].find(background) !=  null) {
                            inventory.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
                            inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
                            inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
                            inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
                            inventory.equip(this.new("scripts/items/tools/throwing_net"));
                            inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
                            local item = this.Const.World.Common.pickArmor([
                                [
                                    1,
                                    "ancient/ancient_ripped_cloth"
                                ]
                            ]);
                            inventory.equip(item);
                            local item = this.Const.World.Common.pickHelmet([
                                [
                                    66,
                                    "ancient/ancient_gladiator_helmet"
                                ]
                            ]);

                            if (item != null)
                            {
                                inventory.equip(item);
                            }
                        }
                        else if (undeadBackgrounds[3].find(background) !=  null) {
                            if (inventory.hasEmptySlot(this.Const.ItemSlot.Mainhand))
                            {
                                local weapons = [
                                    "weapons/ancient/ancient_sword",
                                    "weapons/ancient/legend_gladius",
                                    "weapons/ancient/khopesh"
                                ];

                                if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
                                {
                                    weapons.extend([
                                        "weapons/ancient/warscythe",
                                        "weapons/ancient/crypt_cleaver",
                                        "weapons/ancient/rhomphaia",
                                        "weapons/ancient/bladed_pike"
                                    ]);
                                }

                                inventory.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
                            }

                            if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
                            {
                                inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
                            }

                            if (inventory.hasEmptySlot(this.Const.ItemSlot.Body))
                            {
                                local armor = [
                                    [
                                        1,
                                        "ancient/ancient_plated_scale_hauberk"
                                    ],
                                    [
                                        1,
                                        "ancient/ancient_scale_coat"
                                    ],
                                    [
                                        1,
                                        "ancient/ancient_plate_harness"
                                    ],
                                    [
                                        1,
                                        "ancient/ancient_plated_mail_hauberk"
                                    ]
                                ];
                                local item = this.Const.World.Common.pickArmor(armor);
                                inventory.equip(item);
                            }

                            if (inventory.hasEmptySlot(this.Const.ItemSlot.Head))
                            {
                                local item = this.Const.World.Common.pickHelmet([
                                    [
                                        66,
                                        "ancient/ancient_honorguard_helmet"
                                    ]
                                ]);

                                if (item != null)
                                {
                                    inventory.equip(item);
                                }
                            }
                        }
                    }
                }
                else if (_event.m.zombieSites.find(_event.m.location) != null || coinflip == 2) {
                    // zombies
                    local zombieBackgrounds = [
                        _event.m.civilianBackgrounds, // Regular Zombies
                        ["militia_background", "deserter_background",  "retired_soldier_background"], // Armored Zombies
                        ["hedge_knight_background",  "paladin_background"], // Fallen Heroes
                    ];
                    local background = "vagabond_background";
                    if (rarity > 80) { // 20% fallen hero
                        background = zombieBackgrounds[2][this.Math.rand(0, zombieBackgrounds[2].len() - 1)];
                    }
                    else if (rarity > 50){ // 30% armored
                        background = zombieBackgrounds[1][this.Math.rand(0, zombieBackgrounds[1].len() - 1)];
                    }
                    else{ // 50% civilian
                        background = zombieBackgrounds[0][this.Math.rand(0, zombieBackgrounds[0].len() - 1)];
                    }
                    _event.m.Dude = roster.create("scripts/entity/tactical/player");
                    _event.m.Dude.setStartValuesEx([
                        background,
                    ]);
                    _event.m.Dude.getBackground().m.RawDescription = "A " + "zombie" + " who has been brought under your control, stolen from a rival.";
                    _event.m.Dude.getBackground().buildDescription(true);
                    this.Const.Necromance.Zombify(_event.m.Dude); // he dead
                    local inventory = _event.m.Dude.getItems();
                    if (zombieBackgrounds[0].find(background) == null) {
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Offhand));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Body));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Head));
                        inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Ammo));
                        if (zombieBackgrounds[1].find(background) !=  null) {
                            local r;
                            r = this.Math.rand(1, 7);
                            if (r == 1)
                            {
                                inventory.equip(this.new("scripts/items/weapons/bludgeon"));
                            }
                            else if (r == 2)
                            {
                                inventory.equip(this.new("scripts/items/weapons/hatchet"));
                            }
                            else if (r == 3)
                            {
                                inventory.equip(this.new("scripts/items/weapons/hand_axe"));
                            }
                            else if (r == 4)
                            {
                                inventory.equip(this.new("scripts/items/weapons/scramasax"));
                            }
                            else if (r == 5)
                            {
                                inventory.equip(this.new("scripts/items/weapons/militia_spear"));
                            }
                            else if (r == 6)
                            {
                                inventory.equip(this.new("scripts/items/weapons/shortsword"));
                            }
                            else if (r == 7)
                            {
                                inventory.equip(this.new("scripts/items/weapons/legend_militia_glaive"));
                            }

                            local aList = [
                                [
                                    1,
                                    "padded_leather"
                                ],
                                [
                                    1,
                                    "worn_mail_shirt"
                                ],
                                [
                                    1,
                                    "patched_mail_shirt"
                                ],
                                [
                                    1,
                                    "ragged_surcoat"
                                ],
                                [
                                    1,
                                    "basic_mail_shirt"
                                ]
                            ];
                            local armor = this.Const.World.Common.pickArmor(aList);

                            if (this.Math.rand(1, 100) <= 66)
                            {
                                armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1));
                            }

                            inventory.equip(armor);

                            if (this.Math.rand(1, 100) <= 75)
                            {
                                local item = this.Const.World.Common.pickHelmet([
                                    [
                                        1,
                                        "aketon_cap"
                                    ],
                                    [
                                        1,
                                        "full_aketon_cap"
                                    ],
                                    [
                                        1,
                                        "kettle_hat"
                                    ],
                                    [
                                        1,
                                        "padded_kettle_hat"
                                    ],
                                    [
                                        1,
                                        "dented_nasal_helmet"
                                    ],
                                    [
                                        1,
                                        "mail_coif"
                                    ],
                                    [
                                        1,
                                        "full_leather_cap"
                                    ]
                                ]);

                                if (item != null)
                                {
                                    if (this.Math.rand(1, 100) <= 66)
                                    {
                                        item.setArmor(this.Math.round(item.getArmorMax() / 2 - 1));
                                    }

                                    inventory.equip(item);
                                }
                            }
                        }
                        else if (zombieBackgrounds[2].find(background) !=  null) {
                            local r;
                            if (inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
                            {
                                local weapons = [
                                    "weapons/winged_mace",
                                    "weapons/hand_axe",
                                    "weapons/fighting_axe",
                                    "weapons/morning_star",
                                    "weapons/arming_sword",
                                    "weapons/flail",
                                    "weapons/military_cleaver"
                                ];

                                if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
                                {
                                    weapons.extend([
                                        "weapons/longsword",
                                        "weapons/legend_longsword",
                                        "weapons/greataxe",
                                        "weapons/legend_reinforced_flail"
                                    ]);
                                }

                                if (this.Const.DLC.Unhold && inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
                                {
                                    weapons.extend([
                                        "weapons/two_handed_flail"
                                    ]);
                                }

                                inventory.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
                            }

                            if (inventory.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
                            {
                                local shields = [
                                    "shields/worn_heater_shield",
                                    "shields/worn_kite_shield"
                                ];
                                inventory.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
                            }

                            local aList = [
                                [
                                    1,
                                    "decayed_coat_of_plates"
                                ],
                                [
                                    1,
                                    "decayed_coat_of_scales"
                                ],
                                [
                                    1,
                                    "decayed_reinforced_mail_hauberk"
                                ]
                            ];
                            local armor = this.Const.World.Common.pickArmor(aList);

                            if (this.Math.rand(1, 100) <= 33)
                            {
                                armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1));
                            }

                            inventory.equip(armor);

                            if (inventory.getItemAtSlot(this.Const.ItemSlot.Head) == null && this.Math.rand(1, 100) <= 90)
                            {
                                local helmet = [
                                    [
                                        1,
                                        "decayed_closed_flat_top_with_sack"
                                    ],
                                    [
                                        3,
                                        "decayed_closed_flat_top_with_mail"
                                    ],
                                    [
                                        3,
                                        "decayed_full_helm"
                                    ],
                                    [
                                        3,
                                        "decayed_great_helm"
                                    ]
                                ];
                                local h = this.Const.World.Common.pickHelmet(helmet);

                                if (this.Math.rand(1, 100) <= 33)
                                {
                                    h.setArmor(this.Math.round(h.getArmorMax() / 2 - 1));
                                }

                                inventory.equip(h);
                            }
                        }
                    }
                }
                else {
                    ::logInfo("HLICH RECRUIT FROM LOCATION: Clearly a mistake has been had as no background has been given. Generating a vagabond zombie.")
                    _event.m.Dude = roster.create("scripts/entity/tactical/player");
                    _event.m.Dude.setStartValuesEx([
                        "vagabond_background",
                    ]);
                    _event.m.Dude.getBackground().m.RawDescription = "A " + "zombie" + " who has been brought under your control, stolen from a rival.";
                    _event.m.Dude.getBackground().buildDescription(true);
                    this.Const.Necromance.Zombify(_event.m.Dude); // he dead
                }
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.dse_forbidden_knowledge_hated_lich")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local locations = this.World.EntityManager.getLocations();
		local nearSite = false;
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( v in locations )
		{
			if ((this.m.skeletonSites.find(v.getTypeID()) != null || this.m.zombieSites.find(v.getTypeID()) != null || this.m.bothSites.find(v.getTypeID()) !=  null) && v.getTile().getDistanceTo(currentTile) < 5)
			{
                this.m.location = v.getTypeID();
				nearSite = true;
				break;
			}
		}

		if (!nearSite)
		{
			return;
		}

		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

