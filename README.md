# Forbidden Knowledge Origin
Thank you to all of the following people for helping out during the process & for code inspiration:

LoneMind for the perk code and a lot of guidance about how many things work.

Abysscrane for the readme format and for making ROTU - the script injection was really informative, as well as for helping format the mod hooks w/ Modern Hooks syntax.

Luft for the helmet remove/re-add method for the grey hair method to work.

Tbonex28b for the help with the Hemomancy perk and related active abilities!

The legends team for the Cabal, Random Solo Party start and for the base functionality that this mod works off of!
## Compatability
- You need Legends 19.1+ and Modding Standard Utilities (MSU) in order to run the latest version of this mod.
## Features
Forbidden Knowledge adds a pretty simple origin that lets you play as a random background with a few necromancy perks! When brothers die, they have a chance to come back as an undead, which is greatly heightened by taking the Brink of Death perk. It's more likely that they'll come back as a zombie, but sometimes they'll come back as a skeleton! Your necromancer can also teach others necromancy, though success is not guaranteed...
## Patchnotes
### Version 1.0.2:
- Released
### Version: 1.0.3
- Your necromancer can now teach other members of the party.
    - The party member to be taught needs to meet the following conditions.
        - Be one of the following backgrounds: Historian, Witch, Alchemist, Anatomist, Astrologist or have the Scholar perk or Bright trait.
        - Neither hate nor fear Undead, not be dumb, and not be undead
        - Not already be a necromancer!
    - The event can fire every 80 days.
### Version: 1.0.4
- When people become necromancers or become skeletons, their hair turns grey.
- When people become necromancers, their skin turns pale and they become ugly and thin (they gain one of the two necromancer faces).
- The event can now fire every 60 days instead of 80.
### Version: 1.0.5
- Raise Dead now terminates all of the people you raise with it, allowing you to loot their items afterwards.
- Horrify has been added to the Necromancer's spells.
### Version: 1.0.6
- Fixed a bug where zombie and skeleton tags were not set correctly, causing strange behavior when an undead character becomes a necromancer.
- Fixed a bug caused by fixing this bug where the set method is incorrect
### Version: 1.0.7
- ***Donkeys*** are now accounted for. They can become necromancers, can't become undead.
- Flags are handled properly.
### Version: 1.1.0
- Your necromancers can now become liches! For your first lich, your necromancer needs to have 200 kills (250 for non-avatars), be level 11, not be undead already, and you need to have 4+ level 6+ brothers in your company who are also not undead.
- You will need to sacrifice two of these brothers to ascend to lichdom.
- When you become a lich, you gain access to a spell called "Chill Touch" that deals damage based on your health, resolve and initiative and acts as either a ranged attack or a melee attack depending on which is higher.
- The donkey check has been standardized.
### Version: 1.1.1
- There is now the Necrotic Scythe perk, which allows you to maximize the potential of using a scythe. When holding a scythe, you add a portion of your Initiative, Resolve and Health stats to the damage, gain more armor penetration and armor damage, and every kill reduces the fatigue cost of necromancy skills. Even more kills reduce the AP cost of necromancy skills. You spend kills to gain these benefits.

Minor Changes:
- Chill Touch has been buffed.
- Base legends Horrify isn't that great so its been removed from the necromancer tree.

Bugfixes:
- Patched Lich so that Chill Touch no longer deletes your melee attack stat.

### Version 1.1.2
- Hemomancy perk has been added. The Hemomancy perk gives you an active skill that allows you to drain your life to drain some of your enemies, or drain your life to get rid of some of your fatigue.

### Version 1.2.0
- Hateful Lich Origin

### Version 1.2.1
- Fixed a bug in the lich event.

### Version 1.2.2
- Fixed a bug in the Hated Lich origin causing undead fights to freeze.
- Fixed a bug in the Raise Dead hook to cause it to function in v19 of Legends.

### Version 1.2.3
- Fixed a bug in the Raise Dead hook where zombies purged wouldn't drop their loot because they counted as allies.
- Hated Lich can now recruit zombies and skeletons from zombie/skeleton faction locations like the Legion can by loitering near them. This event has a 3 day cooldown.
- Version number actually updated to 1.2.3

### Version 1.2.5
- Fixed a bug in the Hated Lich location recruitment that caused it to always be skeletons rather than ever recruiting zombies when standing on a location where both were present.
- Updated the mod to BB 1.5.6 and Legends 19.1

### Version 1.2.6
- Fixed a bug where when you recruited a barbarian as the Hated Lich, there was a chance to get the wildwoman background (Which no longer exists)
- Added a feature for Hated Lich where when you defeat an enemy and are about to recruit them, it tells you if they have the potential to become a necromancer.

### Version 1.2.7
- (Possibly) fixed a bug where the Raise Dead execution will cause the game to crash by causing it to do nothing instead.