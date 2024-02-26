# Todo Registry
This is a place for me to record my ideas so whenever I feel like adding more, I can go "OH WAIT I SAID THIS A WEEK AGO" and then do it.

## Misc
### Building Destroying & Necropolis Raising
Whether through League of Evil or otherwise, discover how to make an event that allows the player to choose to destroy a settlement or turn it into a necropolis. The code for necropolis is in the kill_settlement hook comments.

### Horrify V2
Make a new version of 'Horrify' that works the same way the Ancient Priest 'horrify' works. I think the one that's currently on the tree is broken and should probably be removed in the next patch.

## Traits
### Fleshless
I want to hook into fleshless to make it work like Rotten and add faces as well. The Ancient Dead skeletons have a lot of face assets that Fleshless just doesn't capitalize on. Also, for whatever reason the appearance update doesnt do anything so really you'd just need to put it all in an onAdded() function. Then, you don't need the Skeletonize util.
### Lich (Partially Complete)
These are just some of the other features I want to add to becoming a Lich that aren't necessarily in-combat but will make playing a Lich feel a lot cooler.

- When you are a Lich, you are guaranteed to survive when killed without gaining a new permanent injury. After being killed in a fight that the rest of your party wins, you get a long term injury called Weakened Spirit that reduces your AP by 5 (to 7) and expires after 10-20 days. While you have Weakened Spirit, you have the funny ghost lich overlay.
- Every 100 kills after becoming a Lich you gain an additional perk point.

### Powerful Spirit - Wraith/Necromancer
You shed your mortal form and become a disembodied spirit. You gain access to a few new abilities and no longer spend fatigue. You take less damage in general due to your incorporeal nature.

- You take 5% damage from non-famed weapons (magic is unaffected)
- You deal 10% of your damage dealt by weapons; damage dealt by magic is unaffected.
- (Stretch Goal) When you're hit, you teleport to a random space at least 3 tiles away from all enemies
- You gain Death Touch for free
- You have 30% your regular health.

#### Possession (Stretch Goal)
You possess an enemy. You disappear from the map and the enemy gets a little symbol over their head and flips sides. If it's possible to do, you now control that enemy. They make a resolve check at the end of every one of their turns while possessed. If the battle ends and they're still controlled, you leave their body and they die automatically. Minibosses like the Ijirok, Crazy Berserker, Kraken, etc, are all immune to being possessed as their spirits are "too great" to be controlled.

## Events
Event ideas go here.

## Origins
The origins are listed in order of difficulty to actually make, from easiest to hardest. They'll be rated out of 5 on how hard they are to make, with 1 being a straight rip from another origin and 5 being a lot of new mechanics.

---

### Accursed Village (1/5)
You all come from a cursed village that was wiped off the map by a necromancer. Your company from that village carries the curse with you.
#### Benefits
- Curse of Undeath: Everyone has Spectre of Death upon joining the company.
### Detriments
- Peasant Army: This is a clone of the Peasant Militia origin but undead. You can only hire lowborn, scaling is reduced, but you are a human wave.

---

### Misleading Witchdoctor (1/5)
See Accursed Village but instead of everyone having the Spectre of Death trait, you have an avatar character who acts as the person who would have cursed the village. They have a random lowborn background but the necromancy tree.

---

### Reclusive Necromancer (2/5)
You are a reclusive necromancer with three impetuous students who cant wait to go out into the world and practice. You know they're green, but you take them out anyway. The idea is that it's the Cabal origin's backstory, where instead of the necromancer having a heart attack and getting resurrected by his students, he takes his students out for some "Field Research." You start with three "students;" one random background with the Bright & Deathwish traits, one Anatomist with random traits who cant have the excluded traits, and one Historian. The necromancer is your avatar and has the special "Necromancer" background that acts like a lightly armored dagger/cleaver warrior with the cleaver bloodthirsty perks, the scythe skills, and the necromancy tree. You also start with the necromancer clothes from the NPC. Copy that from the Necromancer tactical nut file.

#### Benefits/Detriments
Benefits/Detriments are copied from the Cabal origin. Gravediggers have spectre of death, everyone else doesn't until the Necromancer actually gets there.

---

### Amnesiac Lich (2/5)
You are a necromancer who has always been something like a village hero, fighting off bandits with your army of wiedergangers. At some point, you learned the secrets of how to become a lich, but you performed the ritual in an unusual way. Instead of using two "powerful" souls, you used two random bandit captives. As a result, you have been stripped of your powers but still have the powerful form of a lich

#### Details
- Start at a random village.

#### Benefits
- Lichdom: Start as a Level 1 Lich who is your avatar with a custom "Lich Avatar" background that focuses on Resolve, Health and Initiative.
- Loyal Servants: Start with 2 random Criminal backgrounds with the Fleshless trait, representing the zombies you used to protect the village with

### Detriments
- Distrust: Prices are worse the same way they are in the Beast Slayers origin
- Weakened Lich: Your AP is capped at 9 until you hit level 11.

---

### Draugr Wandering Tribe (3/5)
You are a barbarian that has found an ancient stone slab containing dark, terrible secrets. You gain the following benefits:
#### Benefits
- The Necrotic Scythe perk applies to Barbarian weapons.
- Barbarians will join you randomly but not infrequently if you travel in the North.
- Wild men will join you randomly if you travel in the middle.
- Nomads have a small chance of joining your tribe in the south.
- A Dark Druid has a small chance of joining you at some point in your journey. They are also a Necromancer.
- Necromancy
#### Detriments
- A random northern faction is hostile with you. Other northern factions and the South starts at 'cold' relations due to lack of exposure.
- Non-Barbarian backgrounds cost 200% more to hire and upkeep; Barbarians, Cultists and Wildmen are 50% cheaper to hire and upkeep.
- [SEE RAIDERS ORIGIN]

---

### Hated Lich (WIP Leftovers)
You are a necromancer who has done the impossible, ascend to lichdom. That being said, people aren't taking kindly to your new transformation. Benefits/Detriments are that you...
#### Benefits
- Powerful: Start at level 11 with a custom "Lich Avatar" background that focuses on Resolve, Health and Initiative - likes Daggers, Polearms, Swords, and Cleavers, wears Light Armor.
#### Detriments
- Rule through Fear: People are much less likely to desert but negative moods are slower to go away.

#### Forced Conscription
Finish the description text.

#### Complication: There's no clear way to determine what the composition of the last battle was
Solution 1: Hook into the battle manager and when you win a battle, record the participants in a globally accessible constant value like this.Const.Necromance.LastFoughtArmyComp. Then analyze that. Pick a random unit that you fought and when the event fires, you get a guy based on the random unit. If you pick something rare (like a necromancer) reroll. Prune unpickable options like Hollenhunds,Gheists, etc and if the list is empty then return & do nothing.

Solution 2: Guess the composition based on the day. You can also suspend your disbelief and say there was one that didn't quite enter the battlefield that you didn't fight that you recruit. Maybe the Fallen Hero was a bit glitchy that day. You have a base percent chance for the rarer stuff to happen that goes up per day passed and hits a cap around day 200. So like, maybe at first its like 60% Wieder, 35% Armored Wieder, 5% Fallen Hero. Then, the days pass and it becomes like 58% Amored Wieder, 40% Armored Weider, 7% Fallen Hero. Something like that.

---

### Death Knight (???/5)
???

#### Details
It'll be something like an independent Fallen Hero I think - undead hedge knight.

#### Benefits
???

### Detriments
???

---

## Sub-Sub Mod: Luft's Red Court Integration
### Event: Necromancer becomes Necrosavant
**Requirements:** The necromancer must have the Hemomancy perk. \
**Risk/Reward:** You have the choice to become a Necrosavant. If you go through with it, you start at 1 hit hit point and you gain three random temporary injuries as a part of the ritual process. You then get a choice. When you become a necrosavant, you can choose to drain one of your brothers at random. When you do so, you will heal all permanent and impermanent injuries but kill them in the process. You can choose to reject your cravings, but there's a 10% chance it happens anyway.

### Origin: Necrosavant Necromancer (1/5)
This is a copy of the Red Court background but rather than starting with two necrosavants, you start with yourself and two guys and you have the necromancer perk tree.

---

# Complete Stuff
## Perks
### Death-Magic Scythe
Adds a damage bonus scythes that has Health/Initiative/Resolve scaling. Scales more for base scythe, less for warscythe, never seen the 3rd kind of scythe but find/cheat one in and then see what numbers it has. Uses roughly the same scale formula as Chill Touch but probably like 1/10th of that.

## Perks:
### Hemomancy
Adds a "hemomancy" perk that unlocks a "drain life" spell that replaces the current legends "SIPHON" one in the necromancer perk tree. Effectively it'd be a perk that adds a skill which scales entirely off of your health. It works very similarly, but rather than costing a lot of fatigue its a risk; you spend 5% of your current hit points to cast it. Like Chill Touch, it uses the better of your ranged and melee attack skills and acts like the whip. If it hits, it deals damage equal to 20-40% of your health and heals you for that amount, with a net gain of +15-35% health.

## Origins
### Hated Lich (Partially)
#### Benefits
- Eternal Servitude: People in your party can become undead when they die. You start with the "Brink of Death" perk unlocked without spending a perk point.
- Necromantic Pacts: Ancient Dead and Necromancer factions won't attack you. (You can still betray them - use CTRL + LCLICK to attack them anyway.)
#### Detriments
- Vile Creature of Undeath: Everyone is hostile with you. Negative relations become positive at a much slower rate.
- Forced Conscription.

#### Stretch Goal Mechanic - Forced Conscription
[Actually very doable - its just the Manhunters script but more complicated.]

Like the Manhunters origin, people only join you through force. When you finish a battle, there is a chance that a person with a background relevant to that battle will join you. Examples include...

- Raiders, Vagabonds and Killers on the Run for Brigands,
- Militiamen, Farmers, Milkers, Apprentices, etc for Militia
- Footman, Deserter, Old Soldier for Nobles
- Indebted (can get multiple), Nomad, Blade Dancer for Nomads
- Southern military backgrounds for Southern Troops (look into this)
- Barbarians and Wildmen from Northmen

You can also actually recruit from the Undead as well if you choose to fight them.

- Military backgrounds with Fleshless & Ancient Dead equipment will come from a fight with the Ancient Dead. Look at the Legion origin for inspo.
- Random backgrounds with Rotten & random shitty equipment will come from a fight with Undead.
- Defecting necromancers (low chance)

For factions like the Ancient Dead and Undead, the backgrounds you can get will depend on the army composition. If you have 'Armored Wiedergangers' you'll get mid-level fighting backgrounds - deserters, caravan hands, etc. If you have 'Fallen Heroes' you can get stuff like Hedge Knights and Oathbringers. If you have regular 'Wiedergangers,' you only get civilian backgrounds.


Current Solution: Random choice of background based on the party you just fought.