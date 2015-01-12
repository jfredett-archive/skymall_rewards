# Skymall Rewards -- a simpler EPGP tracker.

EPGP is a great system, and it's addons are fantastic, but they rely on an
assumption that one guild corresponds to one, single group that supports one
'main' raid and (potentially) some second-string raids. My guild violates that
assumption. We use officer notes for tracking account information and other
logistical and clerical necessities. So we needed another option. This is that
system.

In general, Skymall Rewards aims to do three things differently from the
original EPGP addon.

* Rely on conventional use over extensive configuration.

As minimally as possible, values should be 'configurable'. In general, sensible
defaults, or explicit arguments to commands, should be preferred.

* Avoid complexity where simplicity will do

See the 'Simpler GP calculation' section below for an example of this
philosophy. Similarly, rather than relying on building UI around every
component. Most features will be offered (at least at first), via slash
commands which are macro-friendly and thus open to fitting into your UI however
you prefer.

* Avoid making assumptions about how raids, and their host guilds, function.

Ideally this means assuming nothing about how raids function at all. Presently,
for instance, Mythic only allows same-server players, but that may change,
Skymall Rewards should therefore not assume that all players are on the same
server for any group. The original impetus for this addon was due to a mistaken
assumption, and we seek to avoid making that mistake again.

Again, EPGP and it's addon and team are awesome. None of this should be taken as
an indictment of their ability or intent. We just need to build something that
suits our needs, if it suits yours too, great.

## Installation

Clone this repo, copy it to your WoW interface directory. It's not on Curse or
anything (yet, perhaps ever), so this is how it works.

## Features

The initial version, "Skymall Rewards (Manager)" will offer the following features.

* All EPGP information will be stored as file, on the master-looters system,
   which may be serialized and synced between interested parties.

* Supports manual allocation/editing of EP and GP, en masses, via a
  slash-command (which makes award macros easy to make). e.g.,

      /skymall_rewards award 100 <EP|GP> all
      /skymall_rewards award 10 EP Somespecificperson
      /skymall_rewards decay 10% <EP|GP|BOTH>
      /skymall_rewards reset <ALL|Somespecificperson>

  and similar. Much of the interface will be available via slash-commands, with
  UI to be added later, and sparingly.

* EPGP raiders are added manually to the list, and removed manually from it.
  e.g.,

      /skymall_rewards add <name>
      /skymall_rewards add ALL

  The latter will ensure that all current members of the raid are in the EPGP
  system with default values.

* It will support awarding EP, GP, and Decaying both. Manually only.

* It will support custom base EP, GP values.

* It will support a simple system for organizing loot assignment, in
  particular, those wanting an item will simply type:

      <MS|OS|GR> [link to item]

  In raid, the addon will automatically register that person's intent on that item
  and -- in the case of multiple people requisitioning that item -- will show, in
  a convenient frame, only the person with highest priority. It follows the usual
  system with MS always winning over OS always winning over GR (greed) rolls
  regardless of priority, and priority determining within a particular roll class.

* In the aforementioned frame, it will have a 'Give Item and Assign GP' button
  (probably with a less clumsy name), which will do what it says on the tin.

* Upon giving the item away, it disappears from the frame.

In particular, this is the minimum set of functionality needed. Eventually, a
second mode will be added to th, "Skymall Rewards (Shopper)" will encapsulate
the linking approach in some UI.

## Future Feature plans.

* Allow for automatic award of EP after a boss kill
  - Include a 'Trivial Farm', 'Nontrivial Farm', and 'Progression' kill
    modifier, which will award less / more EP as appropriate.
* Allow for multiple independent, easily switchable lists.
* Previously mentioned "Skymall Rewards (Shopper)" UI.
* Allow for custom roll classes beyond or replacing MS/OS/GR

## Simpler GP calculation

As mentioned, EPGP is a great system, but I think it may lack in a few areas. In
particular, the attempt to automate GP calculation through a simple formula is
not bad, but perhaps less than ideal. Generally speaking it may be better to
simply assign each current tier of raiding a 'base' GP for an average peice, and
then modify based on slot type as appropriate. This makes EP rewards not have to
scale per tier. The Previous tier can simply be deducted by some
user-configurable fraction, and the higher tiers (if you are in the midst of
transitioning to new content) be weighed up by some fraction. It is doubtful
that anyone needs to run all the tiers at once. Most groups only raid the
current and *maybe* some of the upper level parts of the previous tier. Skymall
Rewards thus will use the following system for GP assignment.

The Master Looter selects an item level to define the current progression tier.
Say that ilvl is 685 (Mythic Highmaul, at time of writing). A 670 peice then has
a base GP of 1000. Heroic gear (670ilvl) would have 75% of the GP value of an
equivalent peice of Mythic gear, and normal a 50% GP value. Slots would add GP
to the value as appropriate. A weapon might be worth 150% of the GP value of the
regular piece, a trinket worth 125%. So if a Mythic Weapon dropped, it would be
valued at 1500GP, if the same weapon dropped on heroic, it would be worth 75% of
that, or 1125GP, and a normal version 750GP. This allows the group to award a
consistent amount of EP for killing bosses. Indeed, if killing a mythic boss
awards 1000EP for everyone in the raid (enough to earn offset one regular piece
of gear), then killing a 'farm' boss in heroic might only give 750EP, and a
'trivial' boss in normal might give 500EP.

These percentages and base values should be tweakable for your group.

Similarly, next-tier content (e.g., any gear at a higher ilvl than the current
tier) might get a value boost, so a 690ilvl peice might be worth 150% of the GP
value. If you manage to get something down past your progression point (e.g.,
when you're transitioning between finishing up some old content and working on
some new content), then that new gear will be valued higher. Most groups, most
of the time, will not find themselves in a situation where this happens, and
manual override should always be available

## Example use

Say `Jfre Dette's Glowing Rod` drops of Mythic Gromsmasher. This item is a
healer staff, and is base valued at `1000GP` since it's current-progression.
Since it's a weapon, it's value is multiplied by the weapon-slot modifier of
1.5, and it's actual GP value is 1500GP. In raid, the following is typed:

    [Raid] <DK>: Hell yah, Gromsmasher down!
    [Raid] <Priesthealer>: Ooh nice staff, it's real big.
    [Raid] <Druidcat>: OS [Jfre Dette's Glowing Rod]
    [Raid] <Priesthealer>: MS [Jfre Dette's Glowing Rod]
    [Raid] <Druidhealer>: Yah, it's awesome.
    [Raid] <Druidhealer>: MS [Jfre Dette's Glowing Rod]
    ... a short time passes ...
    [Raid] <Masterlooter>: Looting closing in 3.
    [Raid] <Masterlooter>: 2
    [Raid] <Masterlooter>: 1
    [Raid] <Masterlooter>: Loot's going out.

At that point, the ML clicks the 'give item' button for each item in his UI
frame. Say that the Priest had 6250EP and 3500GP, the Druidhealer had 7000EP and
4000GP, then the respective priorities would be 1.785 and 1.750. So the Priest
would get the staff, and their priority would go to 1.25. EP is manually
awarded, so if you prefer to award EP after a boss or before (though it should
not matter in terms of priority), you may do so simply by clicking the
appropriate buttons.

## Nota Bene

I'm using dummy values here, mostly to make the arithmetic pleasant. Giving out
equal amounts of EP and GP is probably not, ultimately, the best way to do
things. You probably should give out a small amount of EP for wipes, and a
larger amount for kills on farm, etc. EP inflation will lead to very large
priority values which will make it harder to fold in new raiders easily.















