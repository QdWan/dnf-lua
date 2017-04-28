local Formatter = {}

Formatter.regular_size = "{size 18}"

Formatter.black = "{color (0, 0, 15, 255)}"

Formatter.blue = "{color (0, 0, 204, 255)}"

Formatter.light_blue = "{color (31, 100, 255, 255)}"

Formatter.red = "{color (204, 0, 0, 255)}"

Formatter.green = "{color (0, 255, 0, 255)}"

Formatter.white = "{color (223, 223, 223, 255)}"

Formatter.light_gray = "{color (160, 160, 160)}"

Formatter.gray = "{color (223, 223, 223, 255)}"

Formatter.italic = "{italic true}"

Formatter.tab_size = 8

Formatter.color = Formatter.white

Formatter.highlight = Formatter.light_blue

Formatter.title_color = Formatter.light_blue

Formatter.regular = "{style}" .. Formatter.regular_size .. Formatter.color

Formatter.regular_c = "{style}" .. Formatter.regular_size

Formatter.paragraph = ("\n" .. string.rep(" ", Formatter.tab_size) ..
                       Formatter.regular)
Formatter.par = Formatter.paragraph

Formatter.title_1 = (
    "{style}{align center}{bold True}{size 32}{italic True}{indent 0}" ..
    Formatter.title_color
)
Formatter.title1 = Formatter.title_1; Formatter.t1 = Formatter.title_1

Formatter.title_2 = (
    "{style}{size 6}" ..
    "\n" .. "\n" ..
    "{style}{align center}{bold True}{size 24}" ..
    "{italic False}" .. Formatter.title_color
)
Formatter.t2 = Formatter.title_2; Formatter.title2 = Formatter.title_2

Formatter.title_3 = (
    "{style}{size 4}" ..
    "\n" .. "\n" ..
    string.rep(" ", Formatter.tab_size) ..
    "{style}{align left}{bold True}" .. Formatter.regular_size ..
    "{italic True}" .. Formatter.title_color
)
Formatter.t3 = Formatter.title_3; Formatter.title3 = Formatter.title_3

Formatter.table = (
    "\n" ..
    "{style}{font 'Cousine-Regular'}{align center}" ..
    Formatter.regular_size .. Formatter.color
)

Formatter.credits = (
    Formatter.par .. string.rep("#", 12) ..
    Formatter.par .. "Section 15 - Copyright Notice" ..
    Formatter.par
)

local function style(format, string)
    string = string or ''
    local result
    if format == 't1' then
        result = (
            Formatter[format] ..
            "~~ " .. string .." ~~" ..
            "\n" .. Formatter['regular']
        )
    elseif format == 't1-' then
        result = (
            Formatter['t1'] ..
            "~~~ " .. string .. " ~~~"
        )
    elseif format == 't2' then
        result = (
            Formatter[format] ..
            "> " .. string .. " <" ..
            "\n" .. Formatter['regular']
        )
    elseif string.find('italic', format) then
        result = Formatter.regular ..
                 Formatter[format] ..
                 string ..
                 Formatter.regular
    elseif string.find('blue;italic;highlight', format) then
        result = Formatter['regular_c'] ..
                 Formatter[format] ..
                 string ..
                 Formatter.regular
    else
        result = Formatter[format] .. string
    end
    return result
end

local function get()
local DISCLAIMER = {
["disclaimer"] = (
style('t1', "Dungeons & Fiends") ..
style('par') .. style('par') ..
style('t1', "DISCLAIMER") ..
style('par') ..
[[This game's core rules are built upon Open Game Content (OGC). This game is not published, endorsed, or specifically approved by the OGC's copyright owners. The use of the OGC relies only on the license granted by the Open Game License (OGL) itself.]] ..
style('par') ..
style('par') ..
[[The full OGL and the OGC as in the official (or community maintained, when specified) System Reference Document are available through the "Open Game Content" option in the "Main Menu" (or during the game, at any time, by pressing the F1 key).]] ..
style('par') ..
style('par') ..
[[The game art (graphics, sound, etc.) is used under varying licenses. A complete list with each of the multimedia resource's credits and license is available through the "Credits" (for simple textual information) or the "Art Gallery" options on the "Main Menu".]] ..
style('par') ..
style('par') ..
[[The game and its source code is released under GNU GPL v3.]] ..

style('par') ..
style('credits') ..
[[Original game concept and design by: Lucas Siqueira]]
)
}

local NAVIGATOR_HELP = (
[[{style}{align center}{bold True}{size 32}Help on navigating

— Use <left> and <right> to select an item;
— Items between brackets ([]) can be expanded with <return> key;
— <backspace> will take you back the previous level;
— Typing the first letter of an existing key will select it or cycle
through multiple matches.
]]
)

local RACES_GENERIC = (
[[In fantasy roleplaying games, race is fundamental. It both provides a starting point for character creation and sets the tone for a character as it progresses. Race mixes biology and culture, then translates those concepts into racial traits. Yet since both biology and culture are mutable — especially when one considers the powerful forces of magic — racial traits can be so diverse that two elves can be extremely different while still manifesting aspects of their shared heritage and culture. A race's traits, its history, its relations with other races, and the culture that all of these things imply — all of these frame your character. This is true whether you play to or against the stereotypes. A savage and bloodthirsty half-orc who lives only for battle is fun to play, but so is a stern and conflicted half-orc paladin constantly struggling to keep her bloodlust in check. Both fit comfortably within the theme of half-orc, but come off as very different characters around the game table.]] ..

style('par') ..
[[Race is an important part of what makes characters who they are, yet it's often all too easy to gloss over the details. After all, most people know the basics: dwarves are short, elves live a long time, and gnomes are dangerously curious. Half-orcs are ugly. Humans are — well, human. To some players, choosing a race is simply a matter of finding which racial modifiers best fit a character's class. Yet there's so much more to race than that. From their deep halls beneath craggy mountains, dwarves sing mournful ballads that teach children of the heroes of old, helping them dream of the day when they might give their own lives in the stronghold's defense. In the spires of their forest cities, elves find a kinship with nature, as the great trees are some of the few non-elven friends who won't grow old and wither before their eyes. By exploring the cultures and traditions of a character's race, we can better understand where she comes from and what makes her tick, thus immersing ourselves that much deeper in the campaign world.]] )

local DATA = {
["Help"] = (
    style('t1', "Navigating through the documentation") ..
    style('par') ..
    style('par') ..
    [[— Use <left> and <right> to select an item;]] ..
    style('par') ..
    [[— Items between brackets ([]) can be expanded with <return> key;]] ..
    style('par') ..
    [[— <backspace> will take you back the previous level;]] ..
    style('par') ..
    [[— Typing the first letter of an existing key will select it or cycle through multiple matches.]] .. "\n"),

["Open Game License"] = (
    style('par') ..
    [[OPEN GAME LICENSE Version 1.0a]] ..

    style('par') ..
    style('par') ..
    [[The following text is the property of Wizards of the Coast, Inc. and is Copyright 2000 Wizards of the Coast, Inc ("Wizards"). All Rights Reserved.]] ..

    style('par') ..
    [[1. Definitions: (a) "Contributors" means the copyright and/or trademark owners who have contributed Open Game Content; (b) "Derivative Material" means copyrighted material including derivative works and translations (including into other computer languages), potation, modification, correction, addition, extension, upgrade, improvement, compilation, abridgment or other form in which an existing work may be recast, transformed or adapted; (c) "Distribute" means to reproduce, license, rent, lease, sell, broadcast, publicly display, transmit or otherwise distribute; (d) "Open Game Content" means the game mechanic and includes the methods, procedures, processes and routines to the extent such content does not embody the Product Identity and is an enhancement over the prior art and any additional content clearly identified as Open Game Content by the Contributor, and means any work covered by this License, including translations and derivative works under copyright law, but specifically excludes Product Identity. (e) "Product Identity" means product and product line names, logos and identifying marks including trade dress; artifacts, creatures, characters, stories, storylines, plots, thematic elements, dialogue, incidents, language, artwork, symbols, designs, depictions, likenesses, formats, poses, concepts, themes and graphic, photographic and other visual or audio representations; names and descriptions of characters, spells, enchantments, personalities, teams, personas, likenesses and special abilities; places, locations, environments, creatures, equipment, magical or supernatural abilities or effects, logos, symbols, or graphic designs; and any other trademark or registered trademark clearly identified as Product identity by the owner of the Product Identity, and which specifically excludes the Open Game Content; (f) "Trademark" means the logos, names, mark, sign, motto, designs that are used by a Contributor to identify itself or its products or the associated products contributed to the Open Game License by the Contributor (g) "Use", "Used" or "Using" means to use, Distribute, copy, edit, format, modify, translate and otherwise create Derivative Material of Open Game Content. (h) "You" or "Your" means the licensee in terms of this agreement.]] ..

    style('par') ..
    [[2. The License: This License applies to any Open Game Content that contains a notice indicating that the Open Game Content may only be Used under and in terms of this License. You must affix such a notice to any Open Game Content that you Use. No terms may be added to or subtracted from this License except as described by the License itself. No other terms or conditions may be applied to any Open Game Content distributed using this License.]] ..

    style('par') ..
    [[3. Offer and Acceptance: By Using the Open Game Content You indicate Your acceptance of the terms of this License.]] ..

    style('par') ..
    [[4. Grant and Consideration: In consideration for agreeing to use this License, the Contributors grant You a perpetual, worldwide, royalty-free, non-exclusive license with the exact terms of this License to Use, the Open Game Content.]] ..

    style('par') ..
    [[5. Representation of Authority to Contribute: If You are contributing original material as Open Game Content, You represent that Your Contributions are Your original creation and/or You have sufficient rights to grant the rights conveyed by this License.]] ..

    style('par') ..
    [[6. Notice of License Copyright: You must update the COPYRIGHT NOTICE portion of this License to include the exact text of the COPYRIGHT NOTICE of any Open Game Content You are copying, modifying or distributing, and You must add the title, the copyright date, and the copyright holder's name to the COPYRIGHT NOTICE of any original Open Game Content you Distribute.]] ..

    style('par') ..
    [[7. Use of Product Identity: You agree not to Use any Product Identity, including as an indication as to compatibility, except as expressly licensed in another, independent Agreement with the owner of each element of that Product Identity. You agree not to indicate compatibility or co-adaptability with any Trademark or Registered Trademark in conjunction with a work containing Open Game Content except as expressly licensed in another, independent Agreement with the owner of such Trademark or Registered Trademark. The use of any Product Identity in Open Game Content does not constitute a challenge to the ownership of that Product Identity. The owner of any Product Identity used in Open Game Content shall retain all rights, title and interest in and to that Product Identity.]] ..

    style('par') ..
    [["8. Identification: If you distribute Open Game Content You must clearly indicate which portions of the work that you are distributing are Open Game Content.]] ..

    style('par') ..
    [[9. Updating the License: Wizards or its designated Agents may publish updated versions of this License. You may use any authorized version of this License to copy, modify and distribute any Open Game Content originally distributed under any version of this License.]] ..

    style('par') ..
    [[10. Copy of this License: You MUST include a copy of this License with every copy of the Open Game Content You distribute.]] ..

    style('par') ..
    [[11. Use of Contributor Credits: You may not market or advertise the Open Game Content using the name of any Contributor unless You have written permission from the Contributor to do so.]] ..

    style('par') ..
    [[12. Inability to Comply: If it is impossible for You to comply with any of the terms of this License with respect to some or all of the Open Game Content due to statute, judicial order, or governmental regulation then You may not Use any Open Game Material so affected.]] ..

    style('par') ..
    [[13. Termination: This License will terminate automatically if You fail to comply with all terms herein and fail to cure such breach within 30 days of becoming aware of the breach. All sublicenses shall survive the termination of this License.]] ..

    style('par') ..
    [[14. Reformation: If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it enforceable.]] ..

    style('par') ..
    [[15. COPYRIGHT NOTICE]] ..

    style('par') ..
    [[Open Game License v 1.0a Copyright 2000, Wizards of the Coast, Inc.]] .. "\n"),

["alignment"] = {
    ["*"] = (
        style('t1', "Alignment") ..
        style('par') ..
        [[A creature's general moral and personal attitudes are represented by its alignment: lawful good, neutral good, chaotic good, lawful neutral, neutral, chaotic neutral, lawful evil, neutral evil, or chaotic evil.]] ..
        style('par') ..
        [[Alignment is a tool for developing your character's identity — it is not a straitjacket for restricting your character. Each alignment represents a broad range of personality types or personal philosophies, so two characters of the same alignment can still be quite different from each other. In addition, few people are completely consistent.]] ..
        style('par') ..
        [[All creatures have an alignment. Alignment determines the effectiveness of some spells and magic items.]] ..
        style('par') ..
        [[Animals and other creatures incapable of moral action are neutral. Even deadly vipers and tigers that eat people are neutral because they lack the capacity for morally right or wrong behavior. Dogs may be obedient and cats free-spirited, but they do not have the moral capacity to be truly lawful or chaotic.]] ..

        style('t2', [[Good Versus Evil]]) ..
        style('par') ..
        [[Good characters and creatures protect innocent life. Evil characters and creatures debase or destroy innocent life, whether for fun or profit.]] ..
        style('par') ..
        [[Good implies altruism, respect for life, and a concern for the dignity of sentient beings. Good characters make personal sacrifices to help others.]] ..
        style('par') ..
        [[Evil implies hurting, oppressing, and killing others. Some evil creatures simply have no compassion for others and kill without qualms if doing so is convenient. Others actively pursue evil, killing for sport or out of duty to some evil deity or master.]] ..
        style('par') ..
        [[People who are neutral with respect to good and evil have compunctions against killing the innocent, but may lack the commitment to make sacrifices to protect or help others.]] ..

        style('t2', "Law Versus Chaos") ..
        style('par') ..
        [[Lawful characters tell the truth, keep their word, respect authority, honor tradition, and judge those who fall short of their duties. Chaotic characters follow their consciences, resent being told what to do, favor new ideas over tradition, and do what they promise if they feel like it.]] ..
        style('par') ..
        [[Law implies honor, trustworthiness, obedience to authority, and reliability. On the downside, lawfulness can include closed-mindedness, reactionary adherence to tradition, self-righteousness, and a lack of adaptability. Those who consciously promote lawfulness say that only lawful behavior creates a society in which people can depend on each other and make the right decisions in full confidence that others will act as they should.]] ..
        style('par') ..
        [[Chaos implies freedom, adaptability, and flexibility. On the downside, chaos can include recklessness, resentment toward legitimate authority, arbitrary actions, and irresponsibility. Those who promote chaotic behavior say that only unfettered personal freedom allows people to express themselves fully and lets society benefit from the potential that its individuals have within them.]] ..
        style('par') ..
        [[Someone who is neutral with respect to law and chaos has some respect for authority and feels neither a compulsion to obey nor a compulsion to rebel. She is generally honest, but can be tempted into lying or deceiving others.]] ..

        style('t2', "Alignment Steps") ..
        style('par') ..
        [[Occasionally the rules refer to "steps" when dealing with alignment. In this case, "steps" refers to the number of alignment shifts between the two alignments, as shown on the following diagram. Note that diagonal "steps" count as two steps. For example, a lawful neutral character is one step away from a lawful good alignment, and three steps away from a chaotic evil alignment. A cleric's alignment must be within one step of the alignment of her deity.]] ..

        style('par') ..
        style('table') .. "             LAWFUL        NEUTRAL        CHAOTIC     " ..
        style('table') .. " GOOD     Lawful Good    Neutral Good   Chaotic Good  " ..
        style('table') .. "NEUTRAL  Lawful Neutral    Neutral     Chaotic Neutral" ..
        style('table') .. " EVIL     Lawful Evil    Neutral Evil   Chaotic Evil  " ..

        style('t2', "The Nine Alignments") ..
        style('par') ..
        [[Nine distinct alignments define the possible combinations of the lawful-chaotic axis with the good-evil axis. Each description below depicts a typical character of that alignment. Remember that individuals vary from this norm, and that a given character may act more or less in accord with his alignment from day to day. Use these descriptions as guidelines, not as scripts.]] ..
        style('par') ..
        [[The first six alignments, lawful good through chaotic neutral, are standard alignments for player characters. The three evil alignments are usually for monsters and villains. With the GM's permission, a player may assign an evil alignment to his PC, but such characters are often a source of disruption and conflict with good and neutral party members. GMs are encouraged to carefully consider how evil PCs might affect the campaign before allowing them.]] ..

        style('t2', "Lawful Good") ..
        style('par') ..
        [[A lawful good character acts as a good person is expected or required to act. She combines a commitment to oppose evil with the discipline to fight relentlessly. She tells the truth, keeps her word, helps those in need, and speaks out against injustice. A lawful good character hates to see the guilty go unpunished.]] ..
        style('par') ..
        [[Lawful good combines honor with compassion.]] ..

        style('t2', "Neutral Good") ..
        style('par') ..
        [[A neutral good character does the best that a good person can do. He is devoted to helping others. He works with kings and magistrates but does not feel beholden to them.]] ..
        style('par') ..
        [[Neutral good means doing what is good and right without bias for or against order.]] ..

        style('t2', "Chaotic Good") ..
        style('par') ..
        [[A chaotic good character acts as his conscience directs him with little regard for what others expect of him. He makes his own way, but he's kind and benevolent. He believes in goodness and right but has little use for laws and regulations. He hates it when people try to intimidate others and tell them what to do. He follows his own moral compass, which, although good, may not agree with that of society.]] ..
        style('par') ..
        [[Chaotic good combines a good heart with a free spirit.]] ..

        style('t2', "Lawful Neutral") ..
        style('par') ..
        [[A lawful neutral character acts as law, tradition, or a personal code directs her. Order and organization are paramount. She may believe in personal order and live by a code or standard, or she may believe in order for all and favor a strong, organized government.]] ..
        style('par') ..
        [[Lawful neutral means you are reliable and honorable without being a zealot.]] ..

        style('t2', "Neutral") ..
        style('par') ..
        [[A neutral character does what seems to be a good idea. She doesn't feel strongly one way or the other when it comes to good vs. evil or law vs. chaos (and thus neutral is sometimes called "true neutral"). Most neutral characters exhibit a lack of conviction or bias rather than a commitment to neutrality. Such a character probably thinks of good as better than evil — after all, she would rather have good neighbors and rulers than evil ones. Still, she's not personally committed to upholding good in any abstract or universal way.]] ..
        style('par') ..
        [[Some neutral characters, on the other hand, commit themselves philosophically to neutrality. They see good, evil, law, and chaos as prejudices and dangerous extremes. They advocate the middle way of neutrality as the best, most balanced road in the long run.]] ..
        style('par') ..
        [[Neutral means you act naturally in any situation, without prejudice or compulsion.]] ..

        style('t2', "Chaotic Neutral") ..
        style('par') ..
        [[A chaotic neutral character follows his whims. He is an individualist first and last. He values his own liberty but doesn't strive to protect others' freedom. He avoids authority, resents restrictions, and challenges traditions. A chaotic neutral character does not intentionally disrupt organizations as part of a campaign of anarchy. To do so, he would have to be motivated either by good (and a desire to liberate others) or evil (and a desire to make those others suffer). A chaotic neutral character may be unpredictable, but his behavior is not totally random. He is not as likely to jump off a bridge as he is to cross it.]] ..
        style('par') ..
        [[Chaotic neutral represents freedom from both society's restrictions and a do-gooder's zeal.]] ..

        style('t2', "Lawful Evil") ..
        style('par') ..
        [[A lawful evil villain methodically takes what he wants within the limits of his code of conduct without regard for whom it hurts. He cares about tradition, loyalty, and order, but not about freedom, dignity, or life. He plays by the rules but without mercy or compassion. He is comfortable in a hierarchy and would like to rule, but is willing to serve. He condemns others not according to their actions but according to race, religion, homeland, or social rank. He is loath to break laws or promises.]] ..
        style('par') ..
        [[This reluctance comes partly from his nature and partly because he depends on order to protect himself from those who oppose him on moral grounds. Some lawful evil villains have particular taboos, such as not killing in cold blood (but having underlings do it) or not letting children come to harm (if it can be helped). They imagine that these compunctions put them above unprincipled villains.]] ..
        style('par') ..
        [[Some lawful evil people and creatures commit themselves to evil with a zeal like that of a crusader committed to good. Beyond being willing to hurt others for their own ends, they take pleasure in spreading evil as an end unto itself. They may also see doing evil as part of a duty to an evil deity or master.]] ..
        style('par') ..
        [[Lawful evil represents methodical, intentional, and organized evil.]] ..

        style('t2', "Neutral Evil") ..
        style('par') ..
        [[A neutral evil villain does whatever she can get away with. She is out for herself, pure and simple. She sheds no tears for those she kills, whether for profit, sport, or convenience. She has no love of order and holds no illusions that following laws, traditions, or codes would make her any better or more noble. On the other hand, she doesn't have the restless nature or love of conflict that a chaotic evil villain has.]] ..
        style('par') ..
        [[Some neutral evil villains hold up evil as an ideal, committing evil for its own sake. Most often, such villains are devoted to evil deities or secret societies.]] ..
        style('par') ..
        [[Neutral evil represents pure evil without honor and without variation.]] ..

        style('t2', "Chaotic Evil") ..
        style('par') ..
        [[A chaotic evil character does what his greed, hatred, and lust for destruction drive him to do. He is vicious, arbitrarily violent, and unpredictable. If he is simply out for whatever he can get, he is ruthless and brutal. If he is committed to the spread of evil and chaos, he is even worse. Thankfully, his plans are haphazard, and any groups he joins or forms are likely to be poorly organized. Typically, chaotic evil people can be made to work together only by force, and their leader lasts only as long as he can thwart attempts to topple or assassinate him.]] ..
        style('par') ..
        [[Chaotic evil represents the destruction not only of beauty and life, but also of the order on which beauty and life depend.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),
    ["lawful good"] = (
        style('t1', [[Lawful Good]]) ..
        style('par') ..
        [[A lawful good character acts as a good person is expected or required to act. She combines a commitment to oppose evil with the discipline to fight relentlessly. She tells the truth, keeps her word, helps those in need, and speaks out against injustice. A lawful good character hates to see the guilty go unpunished.]] ..
        style('par') ..
        [[Lawful good combines honor with compassion.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["neutral good"] = (
        style('t1', [[Neutral Good]]) ..
        style('par') ..
        [[A neutral good character does the best that a good person can do. He is devoted to helping others. He works with kings and magistrates but does not feel beholden to them.]] ..
        style('par') ..
        [[Neutral good means doing what is good and right without bias for or against order.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["chaotic good"] = (
        style('t1', [[Chaotic Good]]) ..
        style('par') ..
        [[A chaotic good character acts as his conscience directs him with little regard for what others expect of him. He makes his own way, but he's kind and benevolent. He believes in goodness and right but has little use for laws and regulations. He hates it when people try to intimidate others and tell them what to do. He follows his own moral compass, which, although good, may not agree with that of society.]] ..
        style('par') ..
        [[Chaotic good combines a good heart with a free spirit.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["lawful neutral"] = (
        style('t1', [[Lawful Neutral]]) ..
        style('par') ..
        [[A lawful neutral character acts as law, tradition, or a personal code directs her. Order and organization are paramount. She may believe in personal order and live by a code or standard, or she may believe in order for all and favor a strong, organized government.]] ..
        style('par') ..
        [[Lawful neutral means you are reliable and honorable without being a zealot.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["neutral"] = (
        style('t1', [[Neutral]]) ..
        style('par') ..
        [[A neutral character does what seems to be a good idea. She doesn't feel strongly one way or the other when it comes to good vs. evil or law vs. chaos (and thus neutral is sometimes called "true neutral"). Most neutral characters exhibit a lack of conviction or bias rather than a commitment to neutrality. Such a character probably thinks of good as better than evil — after all, she would rather have good neighbors and rulers than evil ones. Still, she's not personally committed to upholding good in any abstract or universal way.]] ..
        style('par') ..
        [[Some neutral characters, on the other hand, commit themselves philosophically to neutrality. They see good, evil, law, and chaos as prejudices and dangerous extremes. They advocate the middle way of neutrality as the best, most balanced road in the long run.]] ..
        style('par') ..
        [[Neutral means you act naturally in any situation, without prejudice or compulsion.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["chaotic neutral"] = (
        style('t1', [[Chaotic Neutral]]) ..
        style('par') ..
        [[A chaotic neutral character follows his whims. He is an individualist first and last. He values his own liberty but doesn't strive to protect others' freedom. He avoids authority, resents restrictions, and challenges traditions. A chaotic neutral character does not intentionally disrupt organizations as part of a campaign of anarchy. To do so, he would have to be motivated either by good (and a desire to liberate others) or evil (and a desire to make those others suffer). A chaotic neutral character may be unpredictable, but his behavior is not totally random. He is not as likely to jump off a bridge as he is to cross it.]] ..
        style('par') ..
        [[Chaotic neutral represents freedom from both society's restrictions and a do-gooder's zeal.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["lawful evil"] = (
        style('t1', [[Lawful Evil]]) ..
        style('par') ..
        [[A lawful evil villain methodically takes what he wants within the limits of his code of conduct without regard for whom it hurts. He cares about tradition, loyalty, and order, but not about freedom, dignity, or life. He plays by the rules but without mercy or compassion. He is comfortable in a hierarchy and would like to rule, but is willing to serve. He condemns others not according to their actions but according to race, religion, homeland, or social rank. He is loath to break laws or promises.]] ..
        style('par') ..
        [[This reluctance comes partly from his nature and partly because he depends on order to protect himself from those who oppose him on moral grounds. Some lawful evil villains have particular taboos, such as not killing in cold blood (but having underlings do it) or not letting children come to harm (if it can be helped). They imagine that these compunctions put them above unprincipled villains.]] ..
        style('par') ..
        [[Some lawful evil people and creatures commit themselves to evil with a zeal like that of a crusader committed to good. Beyond being willing to hurt others for their own ends, they take pleasure in spreading evil as an end unto itself. They may also see doing evil as part of a duty to an evil deity or master.]] ..
        style('par') ..
        [[Lawful evil represents methodical, intentional, and organized evil.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["neutral evil"] = (
        style('t1', [[Neutral Evil]]) ..
        style('par') ..
        [[A neutral evil villain does whatever she can get away with. She is out for herself, pure and simple. She sheds no tears for those she kills, whether for profit, sport, or convenience. She has no love of order and holds no illusions that following laws, traditions, or codes would make her any better or more noble. On the other hand, she doesn't have the restless nature or love of conflict that a chaotic evil villain has.]] ..
        style('par') ..
        [[Some neutral evil villains hold up evil as an ideal, committing evil for its own sake. Most often, such villains are devoted to evil deities or secret societies.]] ..
        style('par') ..
        [[Neutral evil represents pure evil without honor and without variation.]] ..
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    ["chaotic evil"] = (
        style('t1', [[Chaotic Evil]]) ..
        style('par') ..
        [[A chaotic evil character does what his greed, hatred, and lust for destruction drive him to do. He is vicious, arbitrarily violent, and unpredictable. If he is simply out for whatever he can get, he is ruthless and brutal. If he is committed to the spread of evil and chaos, he is even worse. Thankfully, his plans are haphazard, and any groups he joins or forms are likely to be poorly organized. Typically, chaotic evil people can be made to work together only by force, and their leader lasts only as long as he can thwart attempts to topple or assassinate him.]] ..
        style('par') ..
        [[Chaotic evil represents the destruction not only of beauty and life, but also of the order on which beauty and life depend.]] ..
            style('par') ..
            style('credits') ..
            "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.")
},

-- #########################
-- ######## CLASSES ########
-- #########################
["classes"] = {

    -- #####################################
    -- ######## GENERIC DESCRIPTION ########
    -- #####################################
    ["*"] = (
        style('t1', "Classes") ..

        style('par') ..
        [[A character’s class is one of his most defining features. It’s the source of most of his abilities, and gives him a specific role in any adventuring party.]] ..

        style('t2', "Favored Class") .. style('par') ..
        [[Each character begins play with a single favored class of his choosing — typically, this is the same class chosen as the one he chooses at 1st level. Whenever a character gains a level in his favored class, he may choose to receive + 1 hit point, + 1 skill rank or, if the class is one of those favored by his race, the racial favored class reward.]] ..

        style('t3', "Alchemist: ") .. style('regular') ..
        [[The alchemist is the master of alchemy, using extracts to grant him great power, mutagens to enhance his form, and bombs to destroy his enemies.]] ..

        style('t3', "Antipaladins: ") .. style('regular') ..
        [[Antipaladins are champions of evil, the antithesis of Paladins. They make pacts with fiends, take the lives of the innocent, and put nothing ahead of their personal power and wealth. The antipaladin is an alternate class for the paladin core class. ]] ..

        style('t3', "Arcanist: ") .. style('regular') ..
        [[A melding of sorcerer and wizard, the arcanist is an arcane tinkerer and spell-twister, reshaping magic to her whims. Players who like options and variety in their spellcasting should consider this class.]] ..

        style('t3', "Barbarian: ") .. style('regular') ..
        [[The barbarian is a brutal berserker from beyond the edge of civilized lands.]] ..

        style('t3', "Bard: ") .. style('regular') ..
        [[The bard uses skill and spell alike to bolster his allies, confound his enemies, and build upon his fame.]] ..

        style('t3', "Bloodrager: ") .. style('regular') ..
        [[Blending the wrath of the barbarian with the innate magic of the sorcerer, the bloodrager taps into his rage to create brutal magical effects. Players who enjoy eldritch savagery and want their magic to support them in combat should consider this class.]] ..

        style('t3', "Brawler: ") .. style('regular') ..
        [[Unifying two of the game's greatest pugilists, the fighter and the monk, the brawler forgoes mysticism and spiritual training to focus on raw physical mastery. Players who want to take on their opponents in fierce hand-to-hand combat should consider this class.]] ..

        style('t3', "Cavalier: ") .. style('regular') ..
        [[Mounted upon his mighty steed, the cavalier is a brave warrior, using his wit, charm, and strength at arms to rally his companions and achieve his goals.]] ..

        style('t3', "Cleric: ") .. style('regular') ..
        [[A devout follower of a deity, the cleric can heal wounds, raise the dead, and call down the wrath of the gods.]] ..

        style('t3', "Druid: ") .. style('regular') ..
        [[The druid is a worshiper of all things natural — a spellcaster, a friend to animals, and a skilled shapechanger.]] ..

        style('t3', "Fighter: ") .. style('regular') ..
        [[Brave and stalwart, the fighter is a master of all manner of arms and armor.]] ..

        style('t3', "Hunter: ") .. style('regular') ..
        [[Combining the natural skills and animal mastery of the druid and the ranger, the hunter teams up with a devoted animal ally to confront the enemies of the wilds. Players who want an animal companion to be their character's focus should consider this class.]] ..

        style('t3', "Inquisitor: ") .. style('regular') ..
        [[Scourge of the unfaithful and hunter of horrors, the inquisitor roots out the enemies of her faith with grim conviction and an array of divine blessings.]] ..

        style('t3', "Investigator: ") .. style('regular') ..
        [[Mixing the alchemist's arcane insight with the shrewdness of a rogue, the investigator uses his knowledge and a wide range of talents to overcome any conundrum. Players who enjoy clever characters who are always prepared should consider this class.]] ..

        style('t3', "Magus: ") .. style('regular') ..
        [[The magus is a student of both the power of magic and the mastering of individual weapons, blending magical ability and martial prowess into something entirely unique.]] ..

        style('t3', "Monk: ") .. style('regular') ..
        [[A student of martial arts, the monk trains his body to be his greatest weapon and defense.]] ..

        style('t3', "Ninja: ") .. style('regular') ..
        [[Ninjas are shadowy killers, masters of infiltration, sabotage, and assassination, and uses a wide variety of weapons, practiced skills, and mystical powers to achieve their goals. The ninja is an alternate class for the rogue core class.]] ..

        style('t3', "Oracle: ") .. style('regular') ..
        [[Drawing upon divine mysteries, the oracle channels divine power through her body and soul, but at a terrible price.]] ..

        style('t3', "Paladin: ") .. style('regular') ..
        [[The paladin is the knight in shining armor, a devoted follower of law and good.]] ..

        style('t3', "Ranger: ") .. style('regular') ..
        [[A tracker and hunter, the ranger is a creature of the wild and of tracking down his favored foes.]] ..

        style('t3', "Rogue: ") .. style('regular') ..
        [[The rogue is a thief and a scout, an opportunist capable of delivering brutal strikes against unwary foes.]] ..

        style('t3', "Samurai: ") .. style('regular') ..
        [[Dedicated like no others to honor and the code of the warrior, the Samurai is trained from an early age in the art of war. He learns the way of the blade, the bow, and the horse. The samurai is an alternate class for the cavalier base class.]] ..

        style('t3', "Shaman: ") .. style('regular') ..
        [[The occult mysteries of the oracle and witch combine in the shaman, an enigmatic spirit-speaker who calls upon powers from beyond. Players who seek new routes to eerie divine powers should consider this class.]] ..

        style('t3', "Skald: ") .. style('regular') ..
        [[The skald blends the passion and relentlessness of the barbarian with the voice of the bard, inspiring his fellows from the front lines. Players who want to both join their allies in battle and bolster their might should consider this class.]] ..

        style('t3', "Slayer: ") .. style('regular') ..
        [[Deft stalkers of the most dangerous prey, slayers merge the ranger's combat training with the rogue's crippling attacks. Players who seek to deal death from the shadows should consider this class.]] ..

        style('t3', "Sorcerer: ") .. style('regular') ..
        [[The spellcasting sorcerer is born with an innate knack for magic and has strange, eldritch powers.]] ..

        style('t3', "Summoner: ") .. style('regular') ..
        [[Bonded to a mysterious creature called an eidolon, the summoner focuses his power on strengthing that connection and enhancing his strange, otherworldy companion.]] ..

        style('t3', "Warpriest: ") .. style('regular') ..
        [[Adding a fighter's physical might to the force of a cleric's convictions, the warpriest strikes against enemies of his faith. Players who want to play a battle-hardened divine champion should consider this class.]] ..

        style('t3', "Witch: ") .. style('regular') ..
        [[Lurking on the fringe of civilization, the witch makes a powerful connection with a patron that grants her strange and mysterious powers through a special familiar.]] ..

        style('t3', "Wizard: ") .. style('regular') ..
        [[The wizard masters magic through constant study that gives him incredible magical power.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Roleplaying Game Ultimate Magic. © 2011, Paizo Publishing, LLC; Authors: Jason Bulmahn, Tim Hitchcock, Colin McComb, Rob McCreary, Jason Nelson, Stephen Radney-MacFarland, Sean K Reynolds, Owen K.C. Stephens, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Roleplaying Game Ultimate Combat. © 2011, Paizo Publishing, LLC; Authors: Jason Bulmahn, Tim Hitchcock, Colin McComb, Rob McCreary, Jason Nelson, Stephen Radney-MacFarland, Sean K Reynolds, Owen K.C. Stephens, and Russ Taylor"
    .. "\n"),

    -- ###########################
    -- ######## BARBARIAN ########
    -- ###########################
    ["barbarian"] = (
        style('t1', [[Barbarian]]) ..
        style('par') ..
        [[For some, there is only rage. In the ways of their people, in the fury of their passion, in the howl of battle, conflict is all these brutal souls know. Savages, hired muscle, masters of vicious martial techniques, they are not soldiers or professional warriors — they are the battle possessed, creatures of slaughter and spirits of war. Known as barbarians, these warmongers know little of training, preparation, or the rules of warfare; for them, only the moment exists, with the foes that stand before them and the knowledge that the next moment might hold their death. They possess a sixth sense in regard to danger and the endurance to weather all that might entail. These brutal warriors might rise from all walks of life, both civilized and savage, though whole societies embracing such philosophies roam the wild places of the world. Within barbarians storms the primal spirit of battle, and woe to those who face their rage.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Barbarians excel in combat, possessing the martial prowess and fortitude to take on foes seemingly far superior to themselves. With rage granting them boldness and daring beyond that of most other warriors, barbarians charge furiously into battle and ruin all who would stand in their way.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any nonlawful.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d12.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The barbarian's class skills are Acrobatics (Dex), Climb (Str), Craft (Int), Handle Animal (Cha), Intimidate (Cha), Knowledge (nature) (Int), Perception (Wis), Ride (Dex), Survival (Wis), and Swim (Str).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[4 .. Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[A barbarian is proficient with all simple and martial weapons, light armor, medium armor, and shields (except tower shields).]] ..

        style('t3', [[Fast Movement (Ex): ]]) ..
        style('regular') ..
        [[A barbarian's land speed is faster than the norm for her race by ..10 feet. This benefit applies only when she is wearing no armor, light armor, or medium armor, and not carrying a heavy load. Apply this bonus before modifying the barbarian's speed because of any load carried or armor worn. This bonus stacks with any other bonuses to the barbarian's land speed.]] ..

        style('t3', [[Rage (Ex): ]]) ..
        style('regular') ..
        [[A barbarian can call upon inner reserves of strength and ferocity, granting her additional combat prowess. Starting at 1st level, a barbarian can rage for a number of rounds per day equal to 4 + her Constitution modifier. At each level after 1st, she can rage for 2 additional rounds. Temporary increases to Constitution, such as those gained from rage and spells like bear's endurance, do not increase the total number of rounds that a barbarian can rage per day. A barbarian can enter rage as a free action. The total number of rounds of rage per day is renewed after resting for 8 hours, although these hours do not need to be consecutive.]] ..
        style('par') ..
        [[While in rage, a barbarian gains a +4 morale bonus to her Strength and Constitution, as well as a +2 morale bonus on Will saves. In addition, she takes a –2 penalty to Armor Class. The increase to Constitution grants the barbarian 2 hit points per Hit Dice, but these disappear when the rage ends and are not lost first like temporary hit points. While in rage, a barbarian cannot use any Charisma, Dexterity, or Intelligence-based skills (except Acrobatics, Fly, Intimidate, and Ride) or any ability that requires patience or concentration.]] ..
        style('par') ..
        [[A barbarian can end her rage as a free action and is fatigued after rage for a number of rounds equal to 2 times the number of rounds spent in the rage. A barbarian cannot enter a new rage while fatigued or exhausted but can otherwise enter rage multiple times during a single encounter or combat. If a barbarian falls unconscious, her rage immediately ends, placing her in peril of death.]] ..

        style('t3', [[Ex-Barbarians: ]]) ..
        style('regular') ..
        [[A barbarian who becomes lawful loses the ability to rage and cannot gain more levels as a barbarian. She retains all other benefits of the class.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ######################
    -- ######## BARD ########
    -- ######################
    ["bard"] = (
        style('t1', [[Bard]]) ..
        style('par') ..
        [[Untold wonders and secrets exist for those skillful enough to discover them. Through cleverness, talent, and magic, these cunning few unravel the wiles of the world, becoming adept in the arts of persuasion, manipulation, and inspiration. Typically masters of one or many forms of artistry, bards possess an uncanny ability to know more than they should and use what they learn to keep themselves and their allies ever one step ahead of danger. Bards are quick-witted and captivating, and their skills might lead them down many paths, be they gamblers or jacks-of-all-trades, scholars or performers, leaders or scoundrels, or even all of the above. For bards, every day brings its own opportunities, adventures, and challenges, and only by bucking the odds, knowing the most, and being the best might they claim the treasures of each.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Bards capably confuse and confound their foes while inspiring their allies to ever-greater daring. While accomplished with both weapons and magic, the true strength of bards lies outside melee, where they can support their companions and undermine their foes without fear of interruptions to their performances.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d8.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The bard's class skills are Acrobatics (Dex), Appraise (Int), Bluff (Cha), Climb (Str), Craft (Int), Diplomacy (Cha), Disguise (Cha), Escape Artist (Dex), Intimidate (Cha), Knowledge (all) (Int), Linguistics (Int), Perception (Wis), Perform (Cha), Profession (Wis), Sense Motive (Wis), Sleight of Hand (Dex), Spellcraft (Int), Stealth (Dex), and Use Magic Device (Cha).]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[A bard is proficient with all simple weapons, plus the longsword, rapier, sap, short sword, shortbow, and whip. Bards are also proficient with light armor and shields (except tower shields). A bard can cast bard spells while wearing light armor and use a shield without incurring the normal arcane spell failure chance. Like any other arcane spellcaster, a bard wearing medium or heavy armor incurs a chance of arcane spell failure if the spell in question has a somatic component. A multiclass bard still incurs the normal arcane spell failure chance for arcane spells received from other classes.]] ..

        style('t3', [[Spells: ]]) ..
        style('regular') ..
        [[A bard casts arcane spells drawn from the bard spell list presented in Spell Lists. He can cast any spell he knows without preparing it ahead of time. Every bard spell has a verbal component (song, recitation, or music). To learn or cast a spell, a bard must have a Charisma score equal to at least 10 + the spell level. The Difficulty Class for a saving throw against a bard's spell is 10 + the spell level + the bard's Charisma modifier.]] ..
        style('par') ..
        [[Like other spellcasters, a bard can cast only a certain number of spells of each spell level per day. His base daily spell allotment is given on Table: Bard. In addition, he receives bonus spells per day if he has a high Charisma score (see Table: Ability Modifiers and Bonus Spells).]] ..
        style('par') ..
        [[The bard's selection of spells is extremely limited. A bard begins play knowing four 0-level spells and two 1st-level spells of the bard's choice. At each new bard level, he gains one or more new spells, as indicated on Table: Bard Spells Known. (Unlike spells per day, the number of spells a bard knows is not affected by his Charisma score. The numbers on Table: Bard Spells Known are fixed.)]] ..
        style('par') ..
        [[Upon reaching 5th level, and at every third bard level after that (8th, 11th, and so on), a bard can choose to learn a new spell in place of one he already knows. In effect, the bard "loses" the old spell in exchange for the new one. The new spell's level must be the same as that of the spell being exchanged, and it must be at least one level lower than the highest-level bard spell the bard can cast. A bard may swap only a single spell at any given level and must choose whether or not to swap the spell at the same time that he gains new spells known for the level.]] ..
        style('par') ..
        [[Bards don't need to prepare their spells in advance. They can cast any known spell at any time, as long as they haven't used up their allotment of spells per day for the spell's level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ########################
    -- ######## CLERIC ########
    -- ########################
    ["cleric"] = (
        style('t1', [[Cleric]]) ..
        style('par') ..
        [[In faith and the miracles of the divine, many find a greater purpose. Called to serve powers beyond most mortal understanding, all priests preach wonders and provide for the spiritual needs of their people. Clerics are more than mere priests, though; these emissaries of the divine work the will of their deities through strength of arms and the magic of their gods. Devoted to the tenets of the religions and philosophies that inspire them, these ecclesiastics quest to spread the knowledge and influence of their faith. Yet while they might share similar abilities, clerics prove as different from one another as the divinities they serve, with some offering healing and redemption, others judging law and truth, and still others spreading conflict and corruption. The ways of the cleric are varied, yet all who tread these paths walk with the mightiest of allies and bear the arms of the gods themselves.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[More than capable of upholding the honor of their deities in battle, clerics often prove stalwart and capable combatants. Their true strength lies in their capability to draw upon the power of their deities, whether to increase their own and their allies' prowess in battle, to vex their foes with divine magic, or to lend healing to companions in need.]] ..
        style('par') ..
        [[As their powers are influenced by their faith, all clerics must focus their worship upon a divine source. While the vast majority of clerics revere a specific deity, a small number dedicate themselves to a divine concept worthy of devotion — such as battle, death, justice, or knowledge — free of a deific abstraction.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[A cleric's alignment must be within one step of their deity's, along either the law/chaos axis or the good/evil axis.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d8.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The cleric's class skills are Appraise (Int), Craft (Int), Diplomacy (Cha), Heal (Wis), Knowledge (arcana) (Int), Knowledge (history) (Int), Knowledge (nobility) (Int), Knowledge (planes) (Int), Knowledge (religion) (Int), Linguistics (Int), Profession (Wis), Sense Motive (Wis), and Spellcraft (Int).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[2 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Clerics are proficient with all simple weapons, light armor, medium armor, and shields (except tower shields). Clerics are also proficient with the favored weapon of their deity.]] ..

        style('t3', [[Spells: ]]) ..
        style('regular') ..
        [[A cleric casts divine spells. His alignment, however, may restrict them from casting certain spells opposed to their moral or ethical beliefs. A cleric must choose and prepare their spells in advance.]] ..
        style('par') ..
        [[To prepare or cast a spell, a cleric must have a Wisdom score equal to at least 10 + the spell level. The Difficulty Class for a saving throw against a cleric's spell is 10 + the spell level + the cleric's Wisdom modifier.]] ..
        style('par') ..
        [[Like other spellcasters, a cleric can cast only a certain number of spells of each spell level per day. In addition, he receives bonus spells per day if he has a high Wisdom score.]] ..
        style('par') ..
        [[Clerics meditate or pray for their spells. Each cleric must choose a time when he must spend 1 hour each day in quiet contemplation or supplication to regain their daily allotment of spells. A cleric may prepare and cast any spell on the cleric spell list, provided that he can cast spells of that level, but he must choose which spells to prepare during their daily meditation.]] ..

        style('t3', [[Ex-Clerics: ]]) ..
        style('regular') ..
        [[A cleric who grossly violates the code of conduct required by their god loses all spells and class features, except for armor and shield proficiencies and proficiency with simple weapons. He cannot thereafter gain levels as a cleric of that god until he atones for their deeds.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- #######################
    -- ######## DRUID ########
    -- #######################
    ["druid"] = (
        style('t1', [[Druid]]) ..
        style('par') ..
        [[Within the purity of the elements and the order of the wilds lingers a power beyond the marvels of civilization. Furtive yet undeniable, these primal magics are guarded over by servants of philosophical balance known as druids. Allies to beasts and manipulators of nature, these often misunderstood protectors of the wild strive to shield their lands from all who would threaten them and prove the might of the wilds to those who lock themselves behind city walls. Rewarded for their devotion with incredible powers, druids gain unparalleled shape-shifting abilities, the companionship of mighty beasts, and the power to call upon nature's wrath. The mightiest temper powers akin to storms, earthquakes, and volcanoes with primeval wisdom long abandoned and forgotten by civilization.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[While some druids might keep to the fringe of battle, allowing companions and summoned creatures to fight while they confound foes with the powers of nature, others transform into deadly beasts and savagely wade into combat. Druids worship personifications of elemental forces, natural powers, or nature itself. Typically this means devotion to a nature deity, though druids are just as likely to revere vague spirits, animalistic demigods, or even specific awe-inspiring natural wonders.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any neutral.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d8.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The druid's class skills are Climb (Str), Craft (Int), Fly (Dex), Handle Animal (Cha), Heal (Wis), Knowledge (geography) (Int), Knowledge (nature) (Int), Perception (Wis), Profession (Wis), Ride (Dex), Spellcraft (Int), Survival (Wis), and Swim (Str).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[4 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Druids are proficient with the following weapons: club, dagger, dart, quarterstaff, scimitar, scythe, sickle, shortspear, sling, and spear. They are also proficient with all natural attacks (claw, bite, and so forth) of any form they assume with wild shape (see below).]] ..
        style('par') ..
        [[Druids are proficient with light and medium armor but are prohibited from wearing metal armor; thus, they may wear only padded, leather, or hide armor. A druid may also wear wooden armor that has been altered by the ironwood spell so that it functions as though it were steel. Druids are proficient with shields (except tower shields) but must use only those crafted from wood.]] ..
        style('par') ..
        [[A druid who wears prohibited armor or uses a prohibited shield is unable to cast druid spells or use any of her supernatural or spell-like class abilities while doing so and for 24 hours thereafter.]] ..

        style('t3', [[Spells: ]]) ..
        style('regular') ..
        [[A druid casts divine spells which are drawn from the druid spell list presented in Spell Lists. Her alignment may restrict her from casting certain spells opposed to her moral or ethical beliefs; see Chaotic, Evil, Good, and Lawful Spells. A druid must choose and prepare her spells in advance.]] ..
        style('par') ..
        [[To prepare or cast a spell, the druid must have a Wisdom score equal to at least 10 + the spell level. The Difficulty Class for a saving throw against a druid's spell is 10 + the spell level + the druid's Wisdom modifier.]] ..
        style('par') ..
        [[Like other spellcasters, a druid can cast only a certain number of spells of each spell level per day. Her base daily spell allotment is given on Table: Druid. In addition, she receives bonus spells per day if she has a high Wisdom score (see Table: Ability Modifiers and Bonus Spells).]] ..
        style('par') ..
        [[A druid must spend 1 hour each day in a trance-like meditation on the mysteries of nature to regain her daily allotment of spells. A druid may prepare and cast any spell on the druid spell list, provided that she can cast spells of that level, but she must choose which spells to prepare during her daily meditation.]] ..

        style('t3', [[Spontaneous Casting: ]]) ..
        style('regular') ..
        [[A druid can channel stored spell energy into summoning spells that she hasn't prepared ahead of time. She can "lose" a prepared spell in order to cast any summon nature's ally spell of the same level or lower.]] ..

        style('t3', [[Chaotic, Evil, Good, and Lawful Spells: ]]) ..
        style('regular') ..
        [[A druid can't cast spells of an alignment opposed to her own or her deity's (if she has one). Spells associated with particular alignments are indicated by the chaos, evil, good, and law descriptors in their spell descriptions.]] ..

        style('t3', [[Orisons: ]]) ..
        style('regular') ..
        [[Druids can prepare a number of orisons, or 0-level spells, each day, as noted on Table: Druid under "Spells per Day." These spells are cast like any other spell, but they are not expended when cast and may be used again.]] ..

        style('t3', [[Bonus Languages: ]]) ..
        style('regular') ..
        [[A druid's bonus language options include Sylvan, the language of woodland creatures. This choice is in addition to the bonus languages available to the character because of her race.]] ..
        style('par') ..
        [[A druid also knows Druidic, a secret language known only to druids, which she learns upon becoming a 1st-level druid. Druidic is a free language for a druid; that is, she knows it in addition to her regular allotment of languages and it doesn't take up a language slot. Druids are forbidden to teach this language to nondruids.]] ..
        style('par') ..
        [[Druidic has its own alphabet.]] ..

        style('t3', [[Nature Bond (Ex): ]]) ..
        style('regular') ..
        [[At 1st level, a druid forms a bond with nature. This bond can take one of two forms. The first is a close tie to the natural world, granting the druid one of the following cleric domains: Air, Animal, Earth, Fire, Plant, Water, or Weather. When determining the powers and bonus spells granted by this domain, the druid's effective cleric level is equal to her druid level. A druid that selects this option also receives additional domain spell slots, just like a cleric. She must prepare the spell from her domain in this slot and this spell cannot be used to cast a spell spontaneously.]] ..
        style('par') ..
        [[The second option is to form a close bond with an animal companion. A druid may begin play with any of the animals listed in Animal Choices. This animal is a loyal companion that accompanies the druid on her adventures.]] ..
        style('par') ..
        [[Unlike normal animals of its kind, an animal companion's Hit Dice, abilities, skills, and feats advance as the druid advances in level. If a character receives an animal companion from more than one source, her effective druid levels stack for the purposes of determining the statistics and abilities of the companion. Most animal companions increase in size when their druid reaches 4th or 7th level, depending on the companion. If a druid releases her companion from service, she may gain a new one by performing a ceremony requiring 24 uninterrupted hours of prayer in the environment where the new companion typically lives. This ceremony can also replace an animal companion that has perished.]] ..

        style('t3', [[Nature Sense (Ex): ]]) ..
        style('regular') ..
        [[A druid gains a +2 bonus on Knowledge (nature) and Survival checks.]] ..

        style('t3', [[Wild Empathy (Ex): ]]) ..
        style('regular') ..
        [[A druid can improve the attitude of an animal. This ability functions just like a Diplomacy check made to improve the attitude of a person (see Using Skills). The druid rolls 1d20 and adds her druid level and her Charisma modifier to determine the wild empathy check result. The typical domestic animal has a starting attitude of indifferent, while wild animals are usually unfriendly.]] ..
        style('par') ..
        [[To use wild empathy, the druid and the animal must be within 30 feet of one another under normal conditions. Generally, influencing an animal in this way takes 1 minute but, as with influencing people, it might take more or less time.]] ..
        style('par') ..
        [[A druid can also use this ability to influence a magical beast with an Intelligence score of 1 or 2, but she takes a –4 penalty on the check.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- #########################
    -- ######## FIGHTER ########
    -- #########################
    ["fighter"] = (
        style('t1', [[Fighter]]) ..
        style('par') ..
        [[Some take up arms for glory, wealth, or revenge. Others do battle to prove themselves, to protect others, or because they know nothing else. Still others learn the ways of weaponcraft to hone their bodies in battle and prove their mettle in the forge of war. Lords of the battlefield, fighters are a disparate lot, training with many weapons or just one, perfecting the uses of armor, learning the fighting techniques of exotic masters, and studying the art of combat, all to shape themselves into living weapons. Far more than mere thugs, these skilled warriors reveal the true deadliness of their weapons, turning hunks of metal into arms capable of taming kingdoms, slaughtering monsters, and rousing the hearts of armies. Soldiers, knights, hunters, and artists of war, fighters are unparalleled champions, and woe to those who dare stand against them.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Fighters excel at combat — defeating their enemies, controlling the flow of battle, and surviving such sorties themselves. While their specific weapons and methods grant them a wide variety of tactics, few can match fighters for sheer battle prowess.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d10.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The fighter's class skills are Climb (Str), Craft (Int), Handle Animal (Cha), Intimidate (Cha), Knowledge (dungeoneering) (Int), Knowledge (engineering) (Int), Profession (Wis), Ride (Dex), Survival (Wis), and Swim (Str).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[2 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[A fighter is proficient with all simple and martial weapons and with all armor (heavy, light, and medium) and shields (including tower shields).]] ..

        style('t3', [[Bonus Feats: ]]) ..
        style('regular') ..
        [[At 1st level, and at every even level thereafter, a fighter gains a bonus feat in addition to those gained from normal advancement (meaning that the fighter gains a feat at every level). These bonus feats must be selected from those listed as combat feats, sometimes also called "fighter bonus feats".]] ..
        style('par') ..
        [[Upon reaching 4th level, and every four levels thereafter (8th, 12th, and so on), a fighter can choose to learn a new bonus feat in place of a bonus feat he has already learned. In effect, the fighter loses the bonus feat in exchange for the new one. The old feat cannot be one that was used as a prerequisite for another feat, prestige class, or other ability. A fighter can only change one feat at any given level and must choose whether or not to swap the feat at the time he gains a new bonus feat for the level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ######################
    -- ######## MONK ########
    -- ######################
    ["monk"] = (
        style('t1', [[Monk]]) ..
        style('par') ..
        [[For the truly exemplary, martial skill transcends the battlefield — it is a lifestyle, a doctrine, a state of mind. These warrior-artists search out methods of battle beyond swords and shields, finding weapons within themselves just as capable of crippling or killing as any blade. These monks (so called since they adhere to ancient philosophies and strict martial disciplines) elevate their bodies to become weapons of war, from battle-minded ascetics to self-taught brawlers. Monks tread the path of discipline, and those with the will to endure that path discover within themselves not what they are, but what they are meant to be.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Monks excel at overcoming even the most daunting perils, striking where it's least expected, and taking advantage of enemy vulnerabilities. Fleet of foot and skilled in combat, monks can navigate any battlefield with ease, aiding allies wherever they are needed most.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any lawful.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d8.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The monk's class skills are Acrobatics (Dex), Climb (Str), Craft (Int), Escape Artist (Dex), Intimidate (Cha), Knowledge (history) (Int), Knowledge (religion) (Int), Perception (Wis), Perform (Cha), Profession (Wis), Ride (Dex), Sense Motive (Wis), Stealth (Dex), and Swim (Str).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[4 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Monks are proficient with the club, crossbow (light or heavy), dagger, handaxe, javelin, kama, nunchaku, quarterstaff, sai, shortspear, short sword, shuriken, siangham, sling, and spear.]] ..
        style('par') ..
        [[Monks are not proficient with any armor or shields.]] ..
        style('par') ..
        [[When wearing armor, using a shield, or carrying a medium or heavy load, a monk loses his AC bonus, as well as his fast movement and flurry of blows abilities.]] ..

        style('t3', [[AC Bonus (Ex): ]]) ..
        style('regular') ..
        [[When unarmored and unencumbered, the monk adds his Wisdom bonus (if any) to his AC and his CMD. In addition, a monk gains a +1 bonus to AC and CMD at 4th level. This bonus increases by 1 for every four monk levels thereafter, up to a maximum of +5 at 20th level.]] ..
        style('par') ..
        [[These bonuses to AC apply even against touch attacks or when the monk is flat-footed. He loses these bonuses when he is immobilized or helpless, when he wears any armor, when he carries a shield, or when he carries a medium or heavy load.]] ..

        style('t3', [[Flurry of Blows (Ex): ]]) ..
        style('regular') ..
        [[Starting at 1st level, a monk can make a flurry of blows as a full-attack action. When doing so, he may make on additional attack, taking a -2 penalty on all of his attack rolls, as if using the Two-Weapon Fighting feat. These attacks can be any combination of unarmed strikes and attacks with a monk special weapon (he does not need to use two weapons to use this ability). For the purpose of these attacks, the monk's base attack bonus from his monk class levels is equal to his monk level. For all other purposes, such as qualifying for a feat or a prestige class, the monk uses his normal base attack bonus.]] ..
        style('par') ..
        [[At 8th level, the monk can make two additional attacks when he uses flurry of blows, as if using Improved Two-Weapon Fighting (even if the monk does not meet the prerequisites for the feat).]] ..
        style('par') ..
        [[At 15th level, the monk can make three additional attacks using flurry of blows, as if using Greater Two-Weapon Fighting (even if the monk does not meet the prerequisites for the feat).]] ..
        style('par') ..
        [[A monk applies his full Strength bonus to his damage rolls for all successful attacks made with flurry of blows, whether the attacks are made with an off-hand or with a weapon wielded in both hands. A monk may substitute disarm, sunder, and trip combat maneuvers for unarmed attacks as part of a flurry of blows. A monk cannot use any weapon other than an unarmed strike or a special monk weapon as part of a flurry of blows. A monk with natural weapons cannot use such weapons as part of a flurry of blows, nor can he make natural attacks in addition to his flurry of blows attacks.]] ..

        style('t3', [[Unarmed Strike: ]]) ..
        style('regular') ..
        [[At 1st level, a monk gains Improved Unarmed Strike as a bonus feat. A monk's attacks may be with fist, elbows, knees, and feet. This means that a monk may make unarmed strikes with his hands full. There is no such thing as an off-hand attack for a monk striking unarmed. A monk may thus apply his full Strength bonus on damage rolls for all his unarmed strikes.]] ..
        style('par') ..
        [[Usually a monk's unarmed strikes deal lethal damage, but he can choose to deal nonlethal damage instead with no penalty on his attack roll. He has the same choice to deal lethal or nonlethal damage while grappling.]] ..
        style('par') ..
        [[A monk's unarmed strike is treated as both a manufactured weapon and a natural weapon for the purpose of spells and effects that enhance or improve either manufactured weapons or natural weapons.]] ..
        style('par') ..
        [[A monk also deals more damage with his unarmed strikes than a normal person would.]] ..

        style('t3', [[Bonus Feat: ]]) ..
        style('regular') ..
        [[At 1st level, 2nd level, and every 4 levels thereafter, a monk may select a bonus feat. These feats must be taken from the following list: Catch Off-Guard, Combat Reflexes, Deflect Arrows, Dodge, Improved Grapple, Scorpion Style, and Throw Anything. At 6th level, the following feats are added to the list: Gorgon's Fist, Improved Bull Rush, Improved Disarm, Improved Feint, Improved Trip, and Mobility. At 10th level, the following feats are added to the list: Improved Critical, Medusa's Wrath, Snatch Arrows, and Spring Attack. A monk need not have any of the prerequisites normally required for these feats to select them.]] ..

        style('t3', [[Stunning Fist (Ex): ]]) ..
        style('regular') ..
        [[At 1st level, the monk gains Stunning Fist as a bonus feat, even if he does not meet the prerequisites. At 4th level, and every 4 levels thereafter, the monk gains the ability to apply a new condition to the target of his Stunning Fist. This condition replaces stunning the target for 1 round, and a successful saving throw still negates the effect. At 4th level, he can choose to make the target fatigued. At 8th level, he can make the target sickened for 1 minute. At 12th level, he can make the target staggered for 1d6+1 rounds. At 16th level, he can permanently blind or deafen the target. At 20th level, he can paralyze the target for 1d6+1 rounds. The monk must choose which condition will apply before the attack roll is made. These effects do not stack with themselves (a creature sickened by Stunning Fist cannot become nauseated if hit by Stunning Fist again), but additional hits do increase the duration.]] ..

        style('t3', [[Ex-Monks: ]]) ..
        style('regular') ..
        [[A monk who becomes nonlawful cannot gain new levels as a monk but retains all monk abilities.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- #########################
    -- ######## PALADIN ########
    -- #########################
    ["paladin"] = (
        style('t1', [[Paladin]]) ..
        style('par') ..
        [[Through a select, worthy few shines the power of the divine. Called paladins, these noble souls dedicate their swords and lives to the battle against evil. Knights, crusaders, and law-bringers, paladins seek not just to spread divine justice but to embody the teachings of the virtuous deities they serve. In pursuit of their lofty goals, they adhere to ironclad laws of morality and discipline. As reward for their righteousness, these holy champions are blessed with boons to aid them in their quests: powers to banish evil, heal the innocent, and inspire the faithful. Although their convictions might lead them into conflict with the very souls they would save, paladins weather endless challenges of faith and dark temptations, risking their lives to do right and fighting to bring about a brighter future.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Paladins serve as beacons for their allies within the chaos of battle. While deadly opponents of evil, they can also empower goodly souls to aid in their crusades. Their magic and martial skills also make them well suited to defending others and blessing the fallen with the strength to continue fighting.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Lawful good.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d10.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The paladin's class skills are Craft (Int), Diplomacy (Cha), Handle Animal (Cha), Heal (Wis), Knowledge (nobility) (Int), Knowledge (religion) (Int), Profession (Wis), Ride (Dex), Sense Motive (Wis), and Spellcraft (Int).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[2 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Paladins are proficient with all simple and martial weapons, with all types of armor (heavy, medium, and light), and with shields (except tower shields).]] ..

        style('t3', [[Aura of Good (Ex): ]]) ..
        style('regular') ..
        [[The power of a paladin's aura of good (see the detect good spell) is equal to the paladin level.]] ..

        style('t3', [[Detect Evil (Sp): ]]) ..
        style('regular') ..
        [[At will, a paladin can use detect evil, as the spell. A paladin can, as a move action, concentrate on a single item or individual within 60 feet and determine if it is evil, learning the strength of its aura as if having studied it for 3 rounds. While focusing on one individual or object, the paladin does not detect evil in any other object or individual within range.]] ..

        style('t3', [[Smite Evil (Su): ]]) ..
        style('regular') ..
        [[Once per day, a paladin can call out to the powers of good to aid her in her struggle against evil. As a swift action, the paladin chooses one target within sight to smite. If this target is evil, the paladin adds her Charisma bonus (if any) to her attack rolls and adds her paladin level to all damage rolls made against the target of her smite. If the target of smite evil is an outsider with the evil subtype, an evil-aligned dragon, or an undead creature, the bonus to damage on the first successful attack increases to 2 points of damage per level the paladin possesses. Regardless of the target, smite evil attacks automatically bypass any DR the creature might possess.]] ..
        style('par') ..
        [[In addition, while smite evil is in effect, the paladin gains a deflection bonus equal to her Charisma modifier (if any) to her AC against attacks made by the target of the smite. If the paladin targets a creature that is not evil, the smite is wasted with no effect.]] ..
        style('par') ..
        [[The smite evil effect remains until the target of the smite is dead or the next time the paladin rests and regains her uses of this ability. At 4th level, and at every three levels thereafter, the paladin may smite evil one additional time per day, as indicated on Table: Paladin, to a maximum of seven times per day at 19th level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ########################
    -- ######## RANGER ########
    -- ########################
    ["ranger"] = (
        style('t1', [[Ranger]]) ..
        style('par') ..
        [[For those who relish the thrill of the hunt, there are only predators and prey. Be they scouts, trackers, or bounty hunters, rangers share much in common: unique mastery of specialized weapons, skill at stalking even the most elusive game, and the expertise to defeat a wide range of quarries. Knowledgeable, patient, and skilled hunters, these rangers hound man, beast, and monster alike, gaining insight into the way of the predator, skill in varied environments, and ever more lethal martial prowess. While some track man-eating creatures to protect the frontier, others pursue more cunning game — even fugitives among their own people.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Rangers are deft skirmishers, either in melee or at range, capable of skillfully dancing in and out of battle. Their abilities allow them to deal significant harm to specific types of foes, but their skills are valuable against all manner of enemies.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d10.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The ranger's class skills are Climb (Str), Craft (Int), Handle Animal (Cha), Heal (Wis), Intimidate (Cha), Knowledge (dungeoneering) (Int), Knowledge (geography) (Int), Knowledge (nature) (Int), Perception (Wis), Profession (Wis), Ride (Dex), Spellcraft (Int), Stealth (Dex), Survival (Wis), and Swim (Str).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[6 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[A ranger is proficient with all simple and martial weapons and with light armor, medium armor, and shields (except tower shields).]] ..

        style('t3', [[Favored Enemy (Ex): ]]) ..
        style('regular') ..
        [[At 1st level, a ranger selects a creature type from the ranger favored enemies table. He gains a +2 bonus on Bluff, Knowledge, Perception, Sense Motive, and Survival checks against creatures of his selected type. Likewise, he gets a +2 bonus on weapon attack and damage rolls against them. A ranger may make Knowledge skill checks untrained when attempting to identify these creatures.]] ..

        style('par') ..
        [[At 5th level and every five levels thereafter (10th, 15th, and 20th level), the ranger may select an additional favored enemy. In addition, at each such interval, the bonus against any one favored enemy (including the one just selected, if so desired) increases by +2.]] ..
        style('par') ..
        [[If the ranger chooses humanoids or outsiders as a favored enemy, he must also choose an associated subtype, as indicated on the table below. (Note that there are other types of humanoid to choose from — those called out specifically on the table below are merely the most common.) If a specific creature falls into more than one category of favored enemy, the ranger's bonuses do not stack; he simply uses whichever bonus is higher.]] ..

        style('t3', [[Track (Ex): ]]) ..
        style('regular') ..
        [[A ranger adds half his level (minimum 1) to Survival skill checks made to follow tracks.]] ..

        style('t3', [[Wild Empathy (Ex): ]]) ..
        style('regular') ..
        [[A ranger can improve the initial attitude of an animal. This ability functions just like a Diplomacy check to improve the attitude of a person (see Using Skills). The ranger rolls 1d20 and adds his ranger level and his Charisma bonus to determine the wild empathy check result. The typical domestic animal has a starting attitude of indifferent, while wild animals are usually unfriendly.]] ..
        style('par') ..
        [[To use wild empathy, the ranger and the animal must be within 30 feet of one another under normal visibility conditions. Generally, influencing an animal in this way takes 1 minute, but, as with influencing people, it might take more or less time.]] ..
        style('par') ..
        [[The ranger can also use this ability to influence a magical beast with an Intelligence score of 1 or 2, but he takes a –4 penalty on the check.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- #######################
    -- ######## ROGUE ########
    -- #######################
    ["rogue"] = (
        style('t1', [[Rogue]]) ..
        style('par') ..
        [[Life is an endless adventure for those who live by their wits. Ever just one step ahead of danger, rogues bank on their cunning, skill, and charm to bend fate to their favor. Never knowing what to expect, they prepare for everything, becoming masters of a wide variety of skills, training themselves to be adept manipulators, agile acrobats, shadowy stalkers, or masters of any of dozens of other professions or talents. Thieves and gamblers, fast talkers and diplomats, bandits and bounty hunters, and explorers and investigators all might be considered rogues, as well as countless other professions that rely upon wits, prowess, or luck. Although many rogues favor cities and the innumerable opportunities of civilization, some embrace lives on the road, journeying far, meeting exotic people, and facing fantastic danger in pursuit of equally fantastic riches. In the end, any who desire to shape their fates and live life on their own terms might come to be called rogues.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Rogues excel at moving about unseen and catching foes unaware, and tend to avoid head-to-head combat. Their varied skills and abilities allow them to be highly versatile, with great variations in expertise existing between different rogues. Most, however, excel in overcoming hindrances of all types, from unlocking doors and disarming traps to outwitting magical hazards and conning dull-witted opponents.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d8.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The rogue's class skills are Acrobatics (Dex), Appraise (Int), Bluff (Cha), Climb (Str), Craft (Int), Diplomacy (Cha), Disable Device (Dex), Disguise (Cha), Escape Artist (Dex), Intimidate (Cha), Knowledge (dungeoneering) (Int), Knowledge (local) (Int), Linguistics (Int), Perception (Wis), Perform (Cha), Profession (Wis), Sense Motive (Wis), Sleight of Hand (Dex), Stealth (Dex), Swim (Str), and Use Magic Device (Cha).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[8 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Rogues are proficient with all simple weapons, plus the hand crossbow, rapier, sap, shortbow, and short sword. They are proficient with light armor, but not with shields.]] ..

        style('t3', [[Sneak Attack: ]]) ..
        style('regular') ..
        [[If a rogue can catch an opponent when he is unable to defend himself effectively from her attack, she can strike a vital spot for extra damage.]] ..
        style('par') ..
        [[The rogue's attack deals extra damage anytime her target would be denied a Dexterity bonus to AC (whether the target actually has a Dexterity bonus or not), or when the rogue flanks her target. This extra damage is 1d6 at 1st level, and increases by 1d6 every two rogue levels thereafter. Should the rogue score a critical hit with a sneak attack, this extra damage is not multiplied. Ranged attacks can count as sneak attacks only if the target is within 30 feet.]] ..
        style('par') ..
        [[With a weapon that deals nonlethal damage (like a sap, whip, or an unarmed strike), a rogue can make a sneak attack that deals nonlethal damage instead of lethal damage. She cannot use a weapon that deals lethal damage to deal nonlethal damage in a sneak attack, not even with the usual –4 penalty.]] ..
        style('par') ..
        [[The rogue must be able to see the target well enough to pick out a vital spot and must be able to reach such a spot. A rogue cannot sneak attack while striking a creature with concealment.]] ..

        style('t3', [[Trapfinding: ]]) ..
        style('regular') ..
        [[A rogue adds 1/2 her level to Perception skill checks made to locate traps and to Disable Device skill checks (minimum +1). A rogue can use Disable Device to disarm magic traps.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ##########################
    -- ######## SORCERER ########
    -- ##########################
    ["sorcerer"] = (
        style('t1', [[Sorcerer]]) ..
        style('par') ..
        [[Scions of innately magical bloodlines, the chosen of deities, the spawn of monsters, pawns of fate and destiny, or simply flukes of fickle magic, sorcerers look within themselves for arcane prowess and draw forth might few mortals can imagine. Emboldened by lives ever threatening to be consumed by their innate powers, these magic-touched souls endlessly indulge in and refine their mysterious abilities, gradually learning how to harness their birthright and coax forth ever greater arcane feats. Just as varied as these innately powerful spellcasters' abilities and inspirations are the ways in which they choose to utilize their gifts. While some seek to control their abilities through meditation and discipline, becoming masters of their fantastic birthright, others give in to their magic, letting it rule their lives with often explosive results. Regardless, sorcerers live and breathe that which other spellcasters devote their lives to mastering, and for them magic is more than a boon or a field of study; it is life itself.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[Sorcerers excel at casting a selection of favored spells frequently, making them powerful battle mages. As they become familiar with a specific and ever-widening set of spells, sorcerers often discover new and versatile ways of making use of magics other spellcasters might overlook. Their bloodlines also grant them additional abilities, assuring that no two sorcerers are ever quite alike.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d6.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The sorcerer's class skills are Appraise (Int), Bluff (Cha), Craft (Int), Fly (Dex), Intimidate (Cha), Knowledge (arcana) (Int), Profession (Wis), Spellcraft (Int), and Use Magic Device (Cha).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[2 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Sorcerers are proficient with all simple weapons. They are not proficient with any type of armor or shield. Armor interferes with a sorcerer's gestures, which can cause her spells with somatic components to fail (see Arcane Spells and Armor).]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[A sorcerer casts arcane spells drawn primarily from the sorcerer/wizard spell list presented in Spell Lists. She can cast any spell she knows without preparing it ahead of time. To learn or cast a spell, a sorcerer must have a Charisma score equal to at least 10 + the spell level. The Difficulty Class for a saving throw against a sorcerer's spell is 10 + the spell level + the sorcerer's Charisma modifier.]] ..
        style('par') ..
        [[Like other spellcasters, a sorcerer can cast only a certain number of spells of each spell level per day. Her base daily spell allotment is given on Table: Sorcerer. In addition, she receives bonus spells per day if she has a high Charisma score (see Table: Ability Modifiers and Bonus Spells).]] ..
        style('par') ..
        [[A sorcerer's selection of spells is extremely limited. A sorcerer begins play knowing four 0-level spells and two 1st-level spells of her choice. At each new sorcerer level, she gains one or more new spells, as indicated on Table: Sorcerer Spells Known. (Unlike spells per day, the number of spells a sorcerer knows is not affected by her Charisma score; the numbers on Table: Sorcerer Spells Known are fixed.) These new spells can be common spells chosen from the sorcerer/wizard spell list, or they can be unusual spells that the sorcerer has gained some understanding of through study.]] ..
        style('par') ..
        [[Upon reaching 4th level, and at every even-numbered sorcerer level after that (6th, 8th, and so on), a sorcerer can choose to learn a new spell in place of one she already knows. In effect, the sorcerer loses the old spell in exchange for the new one. The new spell's level must be the same as that of the spell being exchanged. A sorcerer may swap only a single spell at any given level, and must choose whether or not to swap the spell at the same time that she gains new spells known for the level.]] ..
        style('par') ..
        [[Unlike a wizard or a cleric, a sorcerer need not prepare her spells in advance. She can cast any spell she knows at any time, assuming she has not yet used up her spells per day for that spell level.]] ..

        style('t3', [[Bloodline: ]]) ..
        style('regular') ..
        [[Each sorcerer has a source of magic somewhere in her heritage that grants her spells, bonus feats, an additional class skill, and other special abilities. This source can represent a blood relation or an extreme event involving a creature somewhere in the family's past. For example, a sorcerer might have a dragon as a distant relative or her grandfather might have signed a terrible contract with a devil. Regardless of the source, this influence manifests in a number of ways as the sorcerer gains levels. A sorcerer must pick one bloodline upon taking her first level of sorcerer. Once made, this choice cannot be changed.]] ..
        style('par') ..
        [[At 3rd level, and every two levels thereafter, a sorcerer learns an additional spell, derived from her bloodline. These spells are in addition to the number of spells given on Table: Sorcerer Spells Known. These spells cannot be exchanged for different spells at higher levels.]] ..
        style('par') ..
        [[At 7th level, and every six levels thereafter, a sorcerer receives one bonus feat, chosen from a list specific to each bloodline. The sorcerer must meet the prerequisites for these bonus feats.]] ..

        style('t3', [[Cantrips: ]]) ..
        style('regular') ..
        [[Sorcerers learn a number of cantrips, or 0-level spells, as noted on Table: Sorcerer Spells Known under "Spells Known." These spells are cast like any other spell, but they do not consume any slots and may be used again.]] ..

        style('t3', [[Eschew Materials: ]]) ..
        style('regular') ..
        [[A sorcerer gains Eschew Materials as a bonus feat at 1st level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ########################
    -- ######## WIZARD ########
    -- ########################
    ["wizard"] = (
        style('t1', [[Wizard]]) ..
        style('par') ..
        [[Beyond the veil of the mundane hide the secrets of absolute power. The works of beings beyond mortals, the legends of realms where gods and spirits tread, the lore of creations both wondrous and terrible — such mysteries call to those with the ambition and the intellect to rise above the common folk to grasp true might. Such is the path of the wizard. These shrewd magic-users seek, collect, and covet esoteric knowledge, drawing on cultic arts to work wonders beyond the abilities of mere mortals. While some might choose a particular field of magical study and become masters of such powers, others embrace versatility, reveling in the unbounded wonders of all magic. In either case, wizards prove a cunning and potent lot, capable of smiting their foes, empowering their allies, and shaping the world to their every desire.]] ..

        style('t3', [[Role: ]]) ..
        style('regular') ..
        [[While universalist wizards might study to prepare themselves for any manner of danger, specialist wizards research schools of magic that make them exceptionally skilled within a specific focus. Yet no matter their specialty, all wizards are masters of the impossible and can aid their allies in overcoming any danger.]] ..

        style('t3', [[Alignment: ]]) ..
        style('regular') ..
        [[Any.]] ..

        style('t3', [[Hit Die: ]]) ..
        style('regular') ..
        [[d6.]] ..

        style('t3', [[Class Skills: ]]) ..
        style('regular') ..
        [[The wizard's class skills are Appraise (Int), Craft (Int), Fly (Dex), Knowledge (all) (Int), Linguistics (Int), Profession (Wis), and Spellcraft (Int).]] ..

        style('t3', [[Skill Ranks per Level: ]]) ..
        style('regular') ..
        [[2 + Int modifier.]] ..

        style('t3', [[Weapon and Armor Proficiency: ]]) ..
        style('regular') ..
        [[Wizards are proficient with the club, dagger, heavy crossbow, light crossbow, and quarterstaff, but not with any type of armor or shield. Armor interferes with a wizard's movements, which can cause his spells with somatic components to fail.]] ..

        style('t3', [[Spells: ]]) ..
        style('regular') ..
        [[A wizard casts arcane spells drawn from the sorcerer/wizard spell list presented in Spell Lists. A wizard must choose and prepare his spells ahead of time.]] ..
        style('par') ..
        [[To learn, prepare, or cast a spell, the wizard must have an Intelligence score equal to at least 10 + the spell level. The Difficulty Class for a saving throw against a wizard's spell is 10 + the spell level + the wizard's Intelligence modifier.]] ..
        style('par') ..
        [[A wizard can cast only a certain number of spells of each spell level per day. His base daily spell allotment is given on Table: Wizard. In addition, he receives bonus spells per day if he has a high Intelligence score (see Table: Ability Modifiers and Bonus Spells).]] ..
        style('par') ..
        [[A wizard may know any number of spells. He must choose and prepare his spells ahead of time by getting 8 hours of sleep and spending 1 hour studying his spellbook. While studying, the wizard decides which spells to prepare.]] ..

        style('t3', [[Bonus Languages: ]]) ..
        style('regular') ..
        [[A wizard may substitute Draconic for one of the bonus languages available to the character because of his race.]] ..

        style('t3', [[Arcane Bond (Ex or Sp): ]]) ..
        style('regular') ..
        [[At 1st level, wizards form a powerful bond with an object or a creature. This bond can take one of two forms: a familiar or a bonded object. A familiar is a magical pet that enhances the wizard's skills and senses and can aid him in magic, while a bonded object is an item a wizard can use to cast additional spells or to serve as a magical item. Once a wizard makes this choice, it is permanent and cannot be changed. Rules for bonded items are given below, while rules for familiars are at the end of this section.]] ..
        style('par') ..
        [[Wizards who select a bonded object begin play with one at no cost. Objects that are the subject of an arcane bond must fall into one of the following categories: amulet, ring, staff, wand, or weapon. These objects are always masterwork quality. Weapons acquired at 1st level are not made of any special material. If the object is an amulet or ring, it must be worn to have effect, while staves, wands, and weapons must be held in one hand. If a wizard attempts to cast a spell without his bonded object worn or in hand, he must make a concentration check or lose the spell. The DC for this check is equal to 20 + the spell's level. If the object is a ring or amulet, it occupies the ring or neck slot accordingly.]] ..
        style('par') ..
        [[A bonded object can be used once per day to cast any one spell that the wizard has in his spellbook and is capable of casting, even if the spell is not prepared. This spell is treated like any other spell cast by the wizard, including casting time, duration, and other effects dependent on the wizard's level. This spell cannot be modified by metamagic feats or other abilities. The bonded object cannot be used to cast spells from the wizard's opposition schools (see arcane school).]] ..
        style('par') ..
        [[A wizard can add additional magic abilities to his bonded object as if he has the required item creation feats and if he meets the level prerequisites of the feat. For example, a wizard with a bonded dagger must be at least 5th level to add magic abilities to the dagger (see the Craft Magic Arms and Armor feat in Feats). If the bonded object is a wand, it loses its wand abilities when its last charge is consumed, but it is not destroyed and it retains all of its bonded object properties and can be used to craft a new wand. The magic properties of a bonded object, including any magic abilities added to the object, only function for the wizard who owns it. If a bonded object's owner dies, or the item is replaced, the object reverts to being an ordinary masterwork item of the appropriate type.]] ..
        style('par') ..
        [[If a bonded object is damaged, it is restored to full hit points the next time the wizard prepares his spells. If the object of an arcane bond is lost or destroyed, it can be replaced after 1 week in a special ritual that costs 200 gp per wizard level plus the cost of the masterwork item. This ritual takes 8 hours to complete. Items replaced in this way do not possess any of the additional enchantments of the previous bonded item. A wizard can designate an existing magic item as his bonded item. This functions in the same way as replacing a lost or destroyed item except that the new magic item retains its abilities while gaining the benefits and drawbacks of becoming a bonded item.]] ..

        style('t3', [[Arcane School: ]]) ..
        style('regular') ..
        [[A wizard can choose to specialize in one school of magic, gaining additional spells and powers based on that school. This choice must be made at 1st level, and once made, it cannot be changed. A wizard that does not select a school receives the universalist school instead.]] ..
        style('par') ..
        [[A wizard that chooses to specialize in one school of magic must select two other schools as his opposition schools, representing knowledge sacrificed in one area of arcane lore to gain mastery in another. A wizard who prepares spells from his opposition schools must use two spell slots of that level to prepare the spell. For example, a wizard with evocation as an opposition school must expend two of his available 3rd-level spell slots to prepare a fireball. In addition, a specialist takes a –4 penalty on any skill checks made when crafting a magic item that has a spell from one of his opposition schools as a prerequisite. A universalist wizard can prepare spells from any school without restriction.]] ..
        style('par') ..
        [[Each arcane school gives the wizard a number of school powers. In addition, specialist wizards receive an additional spell slot of each spell level he can cast, from 1st on up. Each day, a wizard can prepare a spell from his specialty school in that slot. This spell must be in the wizard's spellbook. A wizard can select a spell modified by a metamagic feat to prepare in his school slot, but it uses up a higher-level spell slot. Wizards with the universalist school do not receive a school slot.]] ..

        style('t3', [[Cantrips: ]]) ..
        style('regular') ..
        [[Wizards can prepare a number of cantrips, or 0-level spells, each day, as noted on Table: Wizard under "Spells per Day." These spells are cast like any other spell, but they are not expended when cast and may be used again. A wizard can prepare a cantrip from a prohibited school, but it uses up two of his available slots (see below).]] ..

        style('t3', [[Scribe Scroll: ]]) ..
        style('regular') ..
        [[At 1st level, a wizard gains Scribe Scroll as a bonus feat.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),

    -- ###########################
    -- ######## ALCHEMIST ########
    -- ###########################
    ["alchemist"] = (

        style('t1', "Alchemist") .. style('par') ..
        [[Whether secreted away in a smoky basement laboratory or gleefully experimenting in a well-respected school of magic, the alchemist is often regarded as being just as unstable, unpredictable, and dangerous as the concoctions he brews. While some creators of alchemical items content themselves with sedentary lives as merchants, providing tindertwigs and smokesticks, the true alchemist answers a deeper calling. Rather than cast magic like a spellcaster, the alchemist captures his own magic potential within liquids and extracts he creates, infusing his chemicals with virulent power to grant him impressive skill with poisons, explosives, and all manner of self-transformative magic.]] ..
        style('par') ..
        [[The alchemist's reputation is not softened by his exuberance (some would say dangerous recklessness) in perfecting his magical extracts and potion-like creations, infusing these substances with magic siphoned from his aura and using his own body as experimental stock. Nor is it mollified by the alchemist's almost gleeful passion for building explosive bombs and discovering strange new poisons and methods for their use. These traits, while making him a liability and risk for most civilized organizations and institutions of higher learning, seem to fit quite well with most adventuring groups.]] ..

        style('t3', "Alignment: ") .. style('regular') ..
        [[Any.]] ..

        style('t3', "Hit Die: ") .. style('regular') ..
        [[d8.]] ..

        style('t3', "Starting Wealth: ") .. style('regular') ..
        [[3d6  10 gp (average 105gp.) In addition, each character begins play with an outfit worth 10 gp or less.]] ..

        style('t3', "Class Skills: ") .. style('regular') ..
        [[The alchemist's class skills are Appraise (Int), Craft (any) (Int), Disable Device (Dex), Fly (Dex), Heal (Wis), Knowledge (arcana) (Int), Knowledge (nature) (Int), Perception (Wis), Profession (Wis), Sleight of Hand (Dex), Spellcraft (Int), Survival (Wis), Use Magic Device (Cha).]] ..

        style('t3', "Skill Ranks per Level: ") .. style('regular') ..
        [[4 + Int modifier.]] ..

        style('t3', "Weapon and Armor Proficiency: ") .. style('regular') ..
        [[Alchemists are proficient with all simple weapons and bombs. They are also proficient with light armor, but not with shields.]] ..

        style('t3', "Alchemy (Su): ") .. style('regular') ..
        [[Alchemists are not only masters of creating mundane alchemical substances such as alchemist's fire and smokesticks, but also of fashioning magical potion-like extracts in which they can store spell effects. In effect, an alchemist prepares his spells by mixing ingredients into a number of extracts, and then "casts" his spells by drinking the extract. When an alchemist creates an extract or bomb, he infuses the concoction with a tiny fraction of his own magical power — this enables the creation of powerful effects, but also binds the effects to the creator. When using Craft (alchemy) to create an alchemical item, an alchemist gains a competence bonus equal to his class level on the Craft (alchemy) check. In addition, an alchemist can use Craft (alchemy) to identify potions as if using detect magic. He must hold the potion for 1 round to make such a check.]] ..
        style('par') ..
        [[An alchemist can create three special types of magical items-extracts, bombs, and mutagens are transformative elixirs that the alchemist drinks to enhance his physical abilities — both of these are detailed in their own sections below.]] ..
        style('par') ..
        [[Extracts are the most varied of the three. In many ways, they behave like spells in potion form, and as such their effects can be dispelled by effects like dispel magic using the alchemist's level as the caster level. Unlike potions, though, extracts can have powerful effects and duplicate spells that a potion normally could not.]] ..
        style('par') ..
        [[An alchemist can create only a certain number of extracts of each level per day. In addition, he receives bonus extracts per day if he has a high Intelligence score, in the same way a wizard receives bonus spells per day. When an alchemist mixes an extract, he infuses the chemicals and reagents in the extract with magic siphoned from his own magical aura. An extract immediately becomes inert if it leaves the alchemist's possession, reactivating as soon as it returns to his keeping — an alchemist cannot normally pass out his extracts for allies to use (but see the "infusion" discovery below). An extract, once created, remains potent for 1 day before becoming inert, so an alchemist must re-prepare his extracts every day. Mixing an extract takes 1 minute of work — most alchemists prepare many extracts at the start of the day or just before going on an adventure, but it's not uncommon for an alchemist to keep some (or even all) of his daily extract slots open so that he can prepare extracts in the field as needed.]] ..
        style('par') ..
        [[Although the alchemist doesn't actually cast spells, he does have a formulae list that determines what extracts he can create. An alchemist can utilize spell-trigger items if the spell appears on his formulae list, but not spell-completion items (unless he uses Use Magic Device to do so). An extract is "cast" by drinking it, as if imbibing a potion — the effects of an extract exactly duplicate the spell upon which its formula is based, save that the spell always affects only the drinking alchemist. The alchemist uses his level as the caster level to determine any effect based on caster level. Creating extracts consumes raw materials, but the cost of these materials is insignificant — comparable to the valueless material components of most spells. If a spell normally has a costly material component, that component is expended during the consumption of that particular extract. Extracts cannot be made from spells that have focus requirements (alchemist extracts that duplicate divine spells never have a divine focus requirement). An alchemist can prepare an extract of any formula he knows. To learn or use an extract, an alchemist must have an Intelligence score equal to at least 10 + the extract's level. The Difficulty Class for a saving throw against an alchemist's extract is 10 + the extract level + the alchemist's Intelligence modifier. An alchemist may know any number of formulae. He stores his formulae in a special tome called a formula book. He must refer to this book whenever he prepares an extract but not when he consumes it. An alchemist begins play with two 1st level formulae of his choice, plus a number of additional forumlae equal to his Intelligence modifier. At each new alchemist level, he gains one new formula of any level that he can create. An alchemist can also add formulae to his book just like a wizard adds spells to his spellbook, using the same costs and time requirements. An alchemist can study a wizard's spellbook to learn any formula that is equivalent to a spell the spellbook contains. A wizard, however, cannot learn spells from a formula book. An alchemist does not need to decipher arcane writings before copying them.]] ..

        style('t3', "Bomb (Su): ") .. style('regular') ..
        [[In addition to magical extracts, alchemists are adept at swiftly mixing various volatile chemicals and infusing them with their magical reserves to create powerful bombs that they can hurl at their enemies. An alchemist can use a number of bombs each day equal to his class level + his Intelligence modifier. Bombs are unstable, and if not used in the round they are created, they degrade and become inert — their method of creation prevents large volumes of explosive material from being created and stored. In order to create a bomb, the alchemist must use a small vial containing an ounce of liquid catalyst — the alchemist can create this liquid catalyst from small amounts of chemicals from an alchemy lab, and these supplies can be readily refilled in the same manner as a spellcaster's component pouch. Most alchemists create a number of catalyst vials at the start of the day equal to the total number of bombs they can create in that day — once created, a catalyst vial remains usable by the alchemist for years.]] ..
        style('par') ..
        [[Drawing the components of, creating, and throwing a bomb requires a standard action that provokes an attack of opportunity. Thrown bombs have a range of 20 feet and use the Throw Splash Weapon special attack. Bombs are considered weapons and can be selected using feats such as Point-Blank Shot and Weapon Focus. On a direct hit, an alchemist's bomb inflicts 1d6 points of fire damage + additional damage equal to the alchemist's Intelligence modifier. The damage of an alchemist's bomb increases by 1d6 points at every odd-numbered alchemist level (this bonus damage is not multiplied on a critical hit or by using feats such as Vital Strike). Splash damage from an alchemist bomb is always equal to the bomb's minimum damage (so if the bomb would deal 2d6+4 points of fire damage on a direct hit, its splash damage would be 6 points of fire damage). Those caught in the splash damage can attempt a Reflex save for half damage. The DC of this save is equal to 10 + 1/2 the alchemist's level + the alchemist's Intelligence modifier.]] ..
        style('par') ..
        [[Alchemists can learn new types of bombs as discoveries (see the Discovery ability) as they level up. An alchemist's bomb, like an extract, becomes inert if used or carried by anyone else.]] ..

        style('t3', "Brew Potion (Ex): ") .. style('regular') ..
        [[At 1st level, alchemists receive Brew Potion as a bonus feat. An alchemist can brew potions of any formulae he knows (up to 3rd level), using his alchemist level as his caster level. The spell must be one that can be made into a potion. The alchemist does not need to meet the prerequisites for this feat.]] ..

        style('t3', "Mutagen (Su): ") .. style('regular') ..
        [[At 1st level, an alchemist discovers how to create a mutagen that he can imbibe in order to heighten his physical prowess at the cost of his personality. It takes 1 hour to brew a dose of mutagen, and once brewed, it remains potent until used. An alchemist can only maintain one dose of mutagen at a time — if he brews a second dose, any existing mutagen becomes inert. As with an extract or bomb, a mutagen that is not in an alchemist's possession becomes inert until an alchemist picks it up again.]] ..
        style('par') ..
        [[When an alchemist brews a mutagen, he selects one physical ability score — either Strength, Dexterity, or Constitution. It's a standard action to drink a mutagen. Upon being imbibed, the mutagen causes the alchemist to grow bulkier and more bestial, granting him a +2 natural armor bonus and a +4 alchemical bonus to the selected ability score for 10 minutes per alchemist level. In addition, while the mutagen is in effect, the alchemist takes a -2 penalty to one of his mental ability scores. If the mutagen enhances his Strength, it applies a penalty to his Intelligence. If it enhances his Dexterity, it applies a penalty to his Wisdom. If it enhances his Constitution, it applies a penalty to his Charisma.]] ..
        style('par') ..
        [[A non-alchemist who drinks a mutagen must make a Fortitude save (DC 10 + 1/2 the alchemist's level + the alchemist's Intelligence modifier) or become nauseated for 1 hour — a non-alchemist can never gain the benefit of a mutagen, but an alchemist can gain the effects of another alchemist's mutagen if he drinks it. (Although if the other alchemist creates a different mutagen, the effects of the "stolen" mutagen immediately cease.) The effects of a mutagen do not stack. Whenever an alchemist drinks a mutagen, the effects of any previous mutagen immediately end.]] ..

        style('t3', "Throw Anything (Ex): ") .. style('regular') ..
        [[All alchemists gain the Throw Anything feat as a bonus feat at 1st level. An alchemist adds his Intelligence modifier to damage done with splash weapons, including the splash damage if any. This bonus damage is already included in the bomb class feature.]] ..

        style('t3', "Discovery (Su): ") .. style('regular') ..
        [[At 2nd level, and then again every 2 levels thereafter (up to 18th level), an alchemist makes an incredible alchemical discovery. Unless otherwise noted, an alchemist cannot select an individual discovery more than once. Some discoveries can only be made if the alchemist has met certain prerequisites first, such as uncovering other discoveries. Discoveries that modify bombs that are marked with an asterisk (*) do not stack. Only one such discovery can be applied to an individual bomb. The DC of any saving throw called for by a discovery is equal to 10 + 1/2 the alchemist's level + the alchemist's Intelligence modifier.]] ..

        style('t3', "Poison Resistance (Ex): ") .. style('regular') ..
        [[At 2nd level, an alchemist gains a +2 bonus on all saving throws against poison. This bonus increases to +4 at 5th level, and then again to +6 at 8th level. At 10th level, an alchemist becomes completely immune to poison.]] ..

        style('t3', "Poison Use (Ex): ") .. style('regular') ..
        [[Alchemists are trained in the use of poison and starting at 2nd level, cannot accidentally poison themselves when applying poison to a weapon.]] ..

        style('t3', "Swift Alchemy (Ex): ") .. style('regular') ..
        [[At 3rd level, an alchemist can create alchemical items with astounding speed. It takes an alchemist half the normal amount of time to create alchemical items, and he can apply poison to a weapon as a move action.]] ..

        style('t3', "Swift Poisoning (Ex): ") .. style('regular') ..
        [[At 6th level, an alchemist can apply a dose of poison to a weapon as a swift action.]] ..

        style('t3', "Persistent Mutagen (Su): ") .. style('regular') ..
        [[At 14th level, the effects of a mutagen last for 1 hour per level.]] ..

        style('t3', "Instant Alchemy (Ex): ") .. style('regular') ..
        [[At 18th level, an alchemist can create alchemical items with almost supernatural speed. He can create any alchemical item as a full-round action if he succeeds at the Craft (alchemy) check and has the appropriate resources at hand to fund the creation. He can apply poison to a weapon as an immediate action.]] ..

        style('t3', "Grand Discovery (Su): ") .. style('regular') ..
        [[At 20th level, the alchemist makes a grand discovery. He immediately learns two normal discoveries, but also learns a third discovery chosen from the linked list below, representing a truly astounding alchemical breakthrough of significant import. For many alchemists, the promise of one of these grand discoveries is the primary goal of their experiments and hard work.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
    .."\n"),  --  end of alchemist

    -- ##########################
    -- ######## CAVALIER ########
    -- ##########################
    ["cavalier"] = (

        style('t1', "Cavalier") .. style('par') ..
        [[While many warriors strive to perfect their art, spending all of their time honing their skill at martial arms, others spend as much effort dedicating themselves to a cause. These warriors, known as cavaliers, swear themselves to a purpose, serving it above all else. Cavaliers are skilled at fighting from horseback, and are often found charging across a battlefield, with the symbol of their order trailing on a long, fluttering banner. The cavalier's true power comes from the conviction of his ideals, the oaths that he swears, and the challenges he makes.]] ..

        style('t3', "Role: ") .. style('regular') ..
        [[Cavaliers tend to marshal forces on the battlefield, using their mounted talents and challenges to control the flow of the fight. Outside of battle, cavaliers can be found advancing their cause through diplomacy and, if needed, subterfuge. The cavalier is no stranger to courtly intrigue and can hold his own in even the most delicate of social situations.]] ..

        style('t3', "Alignment: ") .. style('regular') ..
        [[Any.]] ..

        style('t3', "Hit Dice: ") .. style('regular') ..
        [[d10.]] ..

        style('t3', "Starting Wealth: ") .. style('regular') ..
        [[5d6  10 gp (average 175gp.) In addition, each character begins play with an outfit worth 10 gp or less.]] ..

        style('t3', "Class Skills: ") .. style('regular') ..
        [[The cavalier's class skills are Bluff (Cha), Climb (Str), Craft (Int), Diplomacy (Cha), Handle Animal (Cha), Intimidate (Cha), Profession (Wis), Ride (Dex), Sense Motive (Wis), and Swim (Str).]] ..

        style('t3', "Skill Ranks per Level: ") .. style('regular') ..
        [[4 + Int modifier.]] ..

        style('t2', "Class Features") ..

        style('t3', "Weapon and Armor Proficiency: ") .. style('regular') ..
        [[Cavaliers are proficient with all simple and martial weapons, with all types of armor (heavy, light, and medium) and with shields (except tower shields).]] ..

        style('t3', "Challenge (Ex): ") .. style('regular') ..
        [[Once per day, a cavalier can challenge a foe to combat. As a swift action, the cavalier chooses one target within sight to challenge. The cavalier's melee attacks deal extra damage whenever the attacks are made against the target of his challenge. This extra damage is equal to the cavalier's level. The cavalier can use this ability once per day at 1st level, plus one additional time per day for every three levels beyond 1st, to a maximum of seven times per day at 19th level.]] ..
        style('par') ..
        [[Challenging a foe requires much of the cavalier's concentration. The cavalier takes a -2 penalty to his Armor Class, except against attacks made by the target of his challenge.]] ..
        style('par') ..
        [[The challenge remains in effect until the target is dead or unconscious or until the combat ends. Each cavalier's challenge also includes another effect which is listed in the section describing the cavalier's order.]] ..

        style('t3', "Mount (Ex): ") .. style('regular') ..
        [[A cavalier gains the service of a loyal and trusty steed to carry him into battle. This mount functions as a druid's animal companion, using the cavalier's level as his effective druid level. The creature must be one that he is capable of riding and is suitable as a mount. A Medium cavalier can select a camel or a horse. A Small cavalier can select a pony or wolf, but can also select a boar or a dog if he is at least 4th level. The GM might approve other animals as suitable mounts.]] ..
        style('par') ..
        [[A cavalier does not take an armor check penalty on Ride checks while riding his mount. The mount is always considered combat trained and begins play with Light Armor Proficiency as a bonus feat. A cavalier's mount does not gain the share spells special ability.]] ..
        style('par') ..
        [[A cavalier's bond with his mount is strong, with the pair learning to anticipate each other's moods and moves. Should a cavalier's mount die, the cavalier may find another mount to serve him after 1 week of mourning. This new mount does not gain the link, evasion, devotion, or improved evasion special abilities until the next time the cavalier gains a level.]] ..

        style('t3', "Order (Ex): ") .. style('regular') ..
        [[At 1st level, a cavalier must pledge himself to a specific order. The order grants the cavalier a number of bonuses, class skills, and special abilities. In addition, each order includes a number of edicts that the cavalier must follow. If he violates any of these edicts, he loses the benefits from his order's challenge ability for 24 hours. The violation of an edict is subject to GM interpretation. A cavalier cannot change his order without undertaking a lengthy process to dedicate himself to a new cause. When this choice is made, he immediately loses all of the benefits from his old order. He must then follow the edicts of his new order for one entire level without gaining any benefits from that order.]] ..

        style('t3', "Tactician (Ex): ") .. style('regular') ..
        [[At 1st level, a cavalier receives a teamwork feat as a bonus feat. He must meet the prerequisites for this feat. As a standard action, the cavalier can grant this feat to all allies within 30 feet who can see and hear him. Allies retain the use of this bonus feat for 3 rounds plus 1 round for every two levels the cavalier possesses. Allies do not need to meet the prerequisites of these bonus feats. The cavalier can use this ability once per day at 1st level, plus one additional time per day at 5th level and for every 5 levels thereafter.]] ..

        style('t3', "Cavalier's Charge (Ex): ") .. style('regular') ..
        [[At 3rd level, a cavalier learns to make more accurate charge attacks while mounted. The cavalier receives a +4 bonus on melee attack rolls on a charge while mounted (instead of the normal +2). In addition, the cavalier does not suffer any penalty to his AC after making a charge attack while mounted.]] ..

        style('t3', "Expert Trainer (Ex): ") .. style('regular') ..
        [[At 4th level, a cavalier learns to train mounts with speed and unsurpassed expertise. The cavalier receives a bonus equal to 1/2 his cavalier level whenever he uses Handle Animal on an animal that serves as a mount. In addition, he can reduce the time needed to teach a mount a new trick or train a mount for a general purpose to 1 day per 1 week required by increasing the DC by +5. He can also train more than one mount at once, although each mount after the first adds +2 to the DC.]] ..

        style('t3', "Banner (Ex): ") .. style('regular') ..
        [[At 5th level, a cavalier's banner becomes a symbol of inspiration to his allies and companions. As long as the cavalier's banner is clearly visible, all allies within 60 feet receive a +2 morale bonus on saving throws against fear and a +1 morale bonus on attack rolls made as part of a charge. At 10th level, and every five levels thereafter, these bonuses increase by +1. The banner must be at least Small or larger and must be carried or displayed by the cavalier or his mount to function.]] ..

        style('t3', "Bonus Feat: ") .. style('regular') ..
        [[At 6th level, and at every six levels thereafter, a cavalier gains a bonus feat in addition to those gained from normal advancement. These bonus feats must be selected from those listed as combat feats. The cavalier must meet the prerequisites of these bonus feats.]] ..

        style('t3', "Greater Tactician (Ex): ") .. style('regular') ..
        [[At 9th level, the cavalier receives an additional teamwork feat as a bonus feat. He must meet the prerequisites for this feat. The cavalier can grant this feat to his allies using the tactician ability. Using the tactician ability is a swift action.]] ..

        style('t3', "Mighty Charge (Ex): ") .. style('regular') ..
        [[At 11th level, a cavalier learns to make devastating charge attacks while mounted. Double the threat range of any weapons wielded during a charge while mounted. This increase does not stack with other effects that increase the threat range of the weapon. In addition, the cavalier can make a free bull rush, disarm, sunder, or trip combat maneuver if his charge attack is successful. This free combat maneuver does not provoke an attack of opportunity.]] ..

        style('t3', "Demanding Challenge (Ex): ") .. style('regular') ..
        [[At 12th level, whenever a cavalier declares a challenge, his target must pay attention to the threat he poses. As long as the target is within the threatened area of the cavalier, it takes a -2 penalty to its AC from attacks made by anyone other than the cavalier.]] ..

        style('t3', "Greater Banner (Ex): ") .. style('regular') ..
        [[At 14th level, the cavalier's banner becomes a rallying call to his allies. All allies within 60 feet receive a +2 morale bonus on saving throws against charm and compulsion spells and effects. In addition, while his banner is displayed, the cavalier can spend a standard action to wave the banner through the air, granting all allies within 60 feet an additional saving throw against any one spell or effect that is targeting them. This save is made at the original DC. Spells and effects that do not allow saving throws are unaffected by this ability. An ally cannot benefit from this ability more than once per day.]] ..

        style('t3', "Master Tactician (Ex): ") .. style('regular') ..
        [[At 17th level, the cavalier receives an additional teamwork feat as a bonus feat. He must meet the prerequisites for this feat. The cavalier can grant this feat to his allies using the tactician ability. Whenever the cavalier uses the tactician ability, he grants any two teamwork feats that he knows. He can select from any of his teamwork feats, not just his bonus feats.]] ..

        style('t3', "Supreme Charge (Ex): ") .. style('regular') ..
        [[At 20th level, whenever the cavalier makes a charge attack while mounted, he deals double the normal amount of damage (or triple if using a lance). In addition, if the cavalier confirms a critical hit on a charge attack while mounted, the target is stunned for 1d4 rounds. A Will save reduces this to staggered for 1d4 rounds. The DC is equal to 10 + the cavalier's base atteack bonus.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Cavalier

    -- ############################
    -- ######## INQUISITOR ########
    -- ############################
    ["inquisitor"] = (
        style('t1', "Inquisitor") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Inquisitor

    -- ############################
    -- ######## MAGUS ########
    -- ############################
    ["magus"] = (
        style('t1', "Magus") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Roleplaying Game Ultimate Magic. © 2011, Paizo Publishing, LLC; Authors: Jason Bulmahn, Tim Hitchcock, Colin McComb, Rob McCreary, Jason Nelson, Stephen Radney-MacFarland, Sean K Reynolds, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Magus

    -- ########################
    -- ######## ORACLE ########
    -- ########################
    ["oracle"] = (
        style('t1', "Oracle") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Oracle

    -- ##########################
    -- ######## SUMMONER ########
    -- ##########################
    ["summoner"] = (
        style('t1', "Summoner") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Summoner

    -- #######################
    -- ######## WITCH ########
    -- #######################
    ["witch"] = (
        style('t1', "Witch") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Witch

    -- ##########################
    -- ######## ARCANIST ########
    -- ##########################
    ["arcanist"] = (
        style('t1', "Arcanist") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Arcanist

    -- ############################
    -- ######## BLOODRAGER ########
    -- ############################
    ["bloodrager"] = (
        style('t1', "Bloodrager") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Bloodrager

    -- #########################
    -- ######## BRAWLER ########
    -- #########################
    ["brawler"] = (
        style('t1', "Brawler") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Brawler

    -- #########################
    -- ######## HUNTER ########
    -- #########################
    ["hunter"] = (
        style('t1', "Hunter") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Hunter

    -- ##############################
    -- ######## INVESTIGATOR ########
    -- ##############################
    ["investigator"] = (
        style('t1', "Investigator") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Investigator

    -- ########################
    -- ######## SHAMAN ########
    -- ########################
    ["shaman"] = (
        style('t1', "Shaman") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Shaman

    -- #######################
    -- ######## SKALD ########
    -- #######################
    ["skald"] = (
        style('t1', "Skald") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Skald

    -- ########################
    -- ######## SLAYER ########
    -- ########################
    ["slayer"] = (
        style('t1', "Slayer") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Slayer

    -- ##############################
    -- ######## SWASHBUCKLER ########
    -- ##############################
    ["swashbuckler"] = (
        style('t1', "Swashbuckler") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Swashbuckler

    -- ###########################
    -- ######## WARPRIEST ########
    -- ###########################
    ["warpriest"] = (
        style('t1', "Warpriest") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Warpriest

    -- #############################
    -- ######## ANTIPALADIN ########
    -- #############################
    ["antipaladin"] = (
        style('t1', "Antipaladin") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Antipaladin

    -- #######################
    -- ######## NINJA ########
    -- #######################
    ["ninja"] = (
        style('t1', "Ninja") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Ninja

    -- #########################
    -- ######## SAMURAI ########
    -- #########################
    ["samurai"] = (
        style('t1', "Samurai") .. style('par') ..
        -- description and features



        -- credits
        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Class Guide © 2014, Paizo Inc.; Authors: Dennis Baker, Ross Byers, Jesse Benner, Savannah Broadway, Jason Bulmahn, Jim Groves, Tim Hitchcock, Tracy Hurley, Jonathan H. Keith, Will McCardell, Dale C. McCoy, Jr., Tom Phillips, Stephen Radney-MacFarland, Thomas M. Reid, Sean K Reynolds, Tork Shaw, Owen K.C. Stephens, and Russ Taylor."
        .."\n"),  --  end of Samurai

},  --  end of classes

-- #######################
-- ######## RACES ########
-- #######################
["races"] = {
    ["*"] = (
        style('t1', "Races") .. style('par') .. RACES_GENERIC ..

        style('t2', "Available Races") ..

        style('t3', "Aasimars: ") .. style('regular') ..
        [[Creatures blessed with a celestial bloodline, aasimars seem human except for some exotic quality that betrays their otherworldly origin. While aasimars are nearly always beautiful, something simultaneously a part of and apart from humanity, not all of them are good, though very few are evil.]] ..

        style('t3', "Catfolk: ") .. style('regular') ..
        [[A race of graceful explorers, catfolk are both clannish and curious by nature. They tend to get along with races that treat them well and respect their boundaries. They love exploration, both physical and intellectual, and tend to be natural adventurers.]] ..

        style('t3', "Changelings: ") .. style('regular') ..
        [[The offspring of hags and their mortal lovers, changelings are abandoned and raised by foster parents. Always female, changelings all hear a spiritual call during puberty to find their true origins. Tall and slender, with dark hair and eyes mismatched in color, changelings are eerily attractive.]] ..

        style('t3', "Dhampir: ") .. style('regular') ..
        [[The accursed spawn of vampires, dhampirs are living creatures tainted with the curse of undeath, which causes them to take damage from positive energy and gain healing from negative energy. While many members of this race embrace their dark sides, others are powerfully driven to rebel against their taint and hunt down and destroy vampires and their ilk.]] ..

        style('t3', "Drow: ") .. style('regular') ..
        [[Dark reflections of surface elves, drow are shadowy hunters who strive to snuff out the world's light. Drow are powerful magical creatures who typically serve demons, and only their chaotic nature stops them from becoming an even greater menace. A select few forsake their race's depraved and nihilistic society to walk a heroic path.]] ..

        style('t3', "Duergar: ") .. style('regular') ..
        [[Gray skinned, deep-dwelling dwarves who hate their lighter skinned cousins, duergar view life as constant toil ending only in death. Though these dwarves are typically evil, honor and keeping one's word means everything to them, and a rare few make loyal adventuring companions.]] ..

        style('t3', "Dwarf: ") .. style('regular') ..
        [[These short and stocky defenders of mountain fortresses are often seen as stern and humorless. Known for mining the earth's treasures and crafting magnificent items from ore and gemstones, they have an unrivaled affinity for the bounties of the deep earth. Dwarves also have a tendency toward traditionalism and isolation that sometimes manifests as xenophobia.]] ..

        style('t3', "Elf: ") .. style('regular') ..
        [[Tall, noble, and often haughty, elves are long-lived and subtle masters of the wilderness. Elves excel in the arcane arts. Often they use their intrinsic link to nature to forge new spells and create wondrous items that, like their creators, seem nearly impervious to the ravages of time. A private and often introverted race, elves can give the impression they are indifferent to the plights of others.]] ..

        style('t3', "Fetchlings: ") .. style('regular') ..
        [[Long ago, fetchlings were humans exiled to the Shadow Plane, but that plane's persistent umbra has transformed them into a race apart. These creatures have developed an ability to meld into the shadows and have a natural affinity for shadow magic. Fetchlings — who call themselves kayal — often serve as emissaries between the inhabitants of the Shadow Plane and the Material Plane.]] ..

        style('t3', "Gnome: ") .. style('regular') ..
        [[Expatriates of the strange land of fey, these small folk have a reputation for flighty and eccentric behavior. Many gnomes are whimsical artisans and tinkers, creating strange devices powered by magic, alchemy, and their quirky imagination. Gnomes have an insatiable need for new experiences that often gets them in trouble.]] ..

        style('t3', "Gillmen: ") .. style('regular') ..
        [[Survivors of a land-dwelling culture whose homeland was destroyed, gillmen were saved and transformed into an amphibious race by the aboleths. Though in many ways they appear nearly human, gillmen's bright purple eyes and gills set them apart from humanity. Reclusive and suspicious, gillmen know that one day the aboleths will call in the debt owed to them.]] ..

        style('t3', "Goblins: ") .. style('regular') ..
        [[Crazy pyromaniacs with a tendency to commit unspeakable violence, goblins are the smallest of the goblinoid races. While they are a fun-loving race, their humor is often cruel and hurtful. Adventuring goblins constantly wrestle with their darkly mischievous side in order to get along with others. Few are truly successful.]] ..

        style('t3', "Gripplis: ") .. style('regular') ..
        [[Furtive frogfolk with the ability to camouflage themselves among fens and swamps, gripplis typically keep to their wetland homes, only rarely interacting with the outside world. Their chief motivation for leaving their marshy environs is to trade in metal and gems.]] ..

        style('t3', "Half-elf: ") .. style('regular') ..
        [[Often caught between the worlds of their progenitor races, half-elves are a race of both grace and contradiction. Their dual heritage and natural gifts often create brilliant diplomats and peacemakers, but half-elves are often susceptible to an intense and even melancholic isolation, realizing that they are never truly part of elven or human society.]] ..

        style('t3', "Half-orc: ") .. style('regular') ..
        [[Often fierce and savage, sometimes noble and resolute, half-orcs can manifest the best and worst qualities of their parent races. Many half-orcs struggle to keep their more bestial natures in check in order to epitomize the most heroic values of humanity. Unfortunately, many outsiders see half-orcs as hopeless abominations devoid of civility, if not monsters unworthy of pity or parley.]] ..

        style('t3', "Halfling: ") .. style('regular') ..
        [[Members of this diminutive race find strength in family, community, and their own innate and seemingly inexhaustible luck. While their fierce curiosity is sometimes at odds with their intrinsic common sense, half lings are eternal optimists and cunning opportunists with an incredible knack for getting out the worst situations.]] ..

        style('t3', "Hobgoblins: ") .. style('regular') ..
        [[These creatures are the most disciplined and militaristic of the goblinoid races. Tall, tough as nails, and strongly built, hobgoblins would be a boon to any adventuring group, were it not for the fact that they tend to be cruel and malicious, and often keep slaves.]] ..

        style('t3', "Human: ") .. style('regular') ..
        [[Ambitious, sometimes heroic, and always confident, humans have an ability to work together toward common goals that makes them a force to be reckoned with. Though short-lived compared to other races, their boundless energy and drive allow them to accomplish much in their brief lifetimes.]] ..

        style('t3', "Ifrits: ") .. style('regular') ..
        [[Ifrits are a race descended from mortals and the strange inhabitants of the Plane of Fire. Their physical traits and personalities often betray their fiery origins, and they tend to be restless, independent, and imperious. Frequently driven from cities for their ability to manipulate flame, ifrits make powerful fire sorcerers and warriors who can wield flame like no other race.]] ..

        style('t3', "Kitsune: ") .. style('regular') ..
        [[These shapeshifting, fox-like folk share a love of mischief, art, and the finer things in life. They can appear as a single human as well as their true form, that of a foxlike humanoid. Kitsune are quick-witted, nimble, and gregarious, and because of this, a fair number of them become adventurers.]] ..

        style('t3', "Kobolds: ") .. style('regular') ..
        [[Considering themselves the scions of dragons, kobolds have diminutive statures but massive egos. A select few can take on more draconic traits than their kin, and many are powerful sorcerers, canny alchemists, and cunning rogues.]] ..

        style('t3', "Merfolk: ") .. style('regular') ..
        [[These creatures have the upper torso of a well-built and attractive humanoid and a lower half consisting of a finned tail. Though they are amphibious and extremely strong swimmers, their lower bodies make it difficult for them to move on land. Merfolk can be shy and reclusive. Typically keeping to themselves, they are distrustful of land-dwelling strangers.]] ..

        style('t3', "Nagaji: ") .. style('regular') ..
        [[It is believed that nagas created the nagaji as a race of servants and that the nagaji worship their creators as living gods. Due to their reptilian nature and strange mannerisms, these strange, scaly folk inspire fear and wonder in others not of their kind. They are resistant to both poison and mind-affecting magic.]] ..

        style('t3', "Orcs: ") .. style('regular') ..
        [[Savage, brutish, and hard to kill, orcs are often the scourge of far-flung wildernesses and cavern deeps. Many orcs become fearsome barbarians, as they are muscular and prone to bloody rages. Those few who can control their bloodlust make excellent adventurers.]] ..

        style('t3', "Oreads: ") .. style('regular') ..
        [[Creatures of human ancestry mixed with the blood of creatures from the Plane of Earth, oreads are as strong and solid as stone. Often stubborn and steadfast, their unyielding nature makes it hard for them to get along with most races other than dwarves. Oreads make excellent warriors and sorcerers who can manipulate the raw power of stone and earth.]] ..

        style('t3', "Ratfolk: ") .. style('regular') ..
        [[These small, ratlike humanoids are clannish and nomadic masters of trade. Often tinkers and traders, they are more concerned with accumulating interesting trinkets than amassing wealth. Ratfolk often adventure to find new and interesting curiosities rather than coin.]] ..

        style('t3', "Samsarans: ") .. style('regular') ..
        [[Ghostly servants of karma, samsarans are creatures reincarnated hundreds if not thousands of times in the hope of reaching true enlightenment. Unlike humans and other races, these humanoids remember much of their past lives.]] ..

        style('t3', "Strix: ") .. style('regular') ..
        [[Hunted to dwindling numbers by humans, who see them as winged devils, strix are black-skinned masters of the nighttime sky. Their territorial conflicts have fueled their hatred for humans. This longstanding feud means that these nocturnal creatures often attack humans on sight.]] ..

        style('t3', "Sulis: ") .. style('regular') ..
        [[Also called suli-jann, these humanoids are the descendants of mortals and jann. These strong and charismatic individuals manifest mastery over elemental power in their adolescence, giving them the ability to manipulate earth, f ire, ice, or electricity. This elemental power tends to be reflected in the suli's personality as well.]] ..

        style('t3', "Svirfneblin: ") .. style('regular') ..
        [[Gnomes who guard their hidden enclaves within dark tunnels and caverns deep under the earth, svirfneblin are as serious as their surface cousins are whimsical. They are resistant to the magic of the foul creatures that share their subterranean environs, and wield powerful protective magic. Svirfneblin are distrustful of outsiders and often hide at their approach.]] ..

        style('t3', "Sylphs: ") .. style('regular') ..
        [[Ethereal folk of elemental air, sylphs are the result of human blood mixed with that of airy elemental folk. Like ifrits, oreads, and undines, they can become powerful elemental sorcerers with command over their particular elemental dominion. They tend to be beautiful and lithe, and have a knack for eavesdropping.]] ..

        style('t3', "Tengu: ") .. style('regular') ..
        [[These crow-like humanoid scavengers excel in mimicry and swordplay. Flocking into densely populated cities, tengus occasionally join adventuring groups out of curiosity or necessity. Their impulsive nature and strange habits can often be unnerving to those who are not used to them.]] ..

        style('t3', "Tieflings: ") .. style('regular') ..
        [[Diverse and often despised by humanoid society, tieflings are mortals stained with the blood of fiends. Other races rarely trust them, and this lack of empathy usually causes tieflings to embrace the evil, depravity, and rage that seethe within their corrupt blood. A select few see the struggle to smother such dark desires as motivation for grand heroism.]] ..

        style('t3', "Undines: ") .. style('regular') ..
        [[Like their cousins, the ifrits, oreads, and sylphs, undines are humans touched by planar elements. They are the scions of elemental water, equally graceful both on land and in water. Undines are adaptable and resistant to cold, and have an affinity for water magic.]] ..

        style('t3', "Vanaras: ") .. style('regular') ..
        [[These mischievous, monkey-like humanoids dwell in jungles and warm forests. Covered in soft fur and sporting prehensile tails and hand-like feet, vanaras are strong climbers. These creatures are at home both on the ground and among the treetops.]] ..

        style('t3', "Vishkanyas: ") .. style('regular') ..
        [[Strangely beautiful on the outside and poisonous on the inside, vishkanyas see the world through slitted serpent eyes. Vishkanyas possess a serpent's grace and ability to writhe out of their enemies' grasp with ease. Vishkanyas have a reputation for being both seductive and manipulative. They can use their saliva or blood to poison their weapons.]] ..

        style('t3', "Wayangs: ") .. style('regular') ..
        [[The small wayangs are creatures of the Plane of Shadow. They are so attuned to shadow that it even shapes their philosophy, believing that upon death they merely merge back into darkness. The mysteries of their shadowy existence grant them the ability to gain healing from negative energy as well as positive energy.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        style('par') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." ..
        style('par') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor."
    .."\n"),


    -- #############################
    -- ######## RACE: DWARF ########
    -- #############################
    ["dwarf"] = (
        style('t1', "Dwarves") ..

        style('par') ..
        [[These short and stocky defenders of mountain fortresses are often seen as stern and humorless. Known for mining the earth's treasures and crafting magnificent items from ore and gemstones, they have an unrivaled affinity for the bounties of the deep earth. Dwarves also have a tendency toward traditionalism and isolation that sometimes manifests as xenophobia.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Dwarves are both tough and wise, but also a bit gruff. They gain +2 Constitution, +2 Wisdom, and –2 Charisma.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Dwarves are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Dwarves are humanoids with the dwarf subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[(Slow and Steady) Dwarves have a base speed of 20 feet, but their speed is never modified by armor or encumbrance.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Dwarves begin play speaking Common and Dwarven. Dwarves with high Intelligence scores can choose from Giant, Gnome, Goblin, Orc, Terran and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Defensive Training: ") .. style('regular') ..
        [[Dwarves gain a +4 dodge bonus to AC against monsters of the giant subtype.]] ..

        style('t3', "Hardy: ") .. style('regular') ..
        [[Dwarves gain a +2 racial bonus on saving throws against poison, spells, and spell-like abilities.]] ..

        style('t3', "Stability: ") .. style('regular') ..
        [[Dwarves gain a +4 racial bonus to their Combat Maneuver Defense when resisting a bull rush or trip attempt while standing on the ground.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Greed: ") .. style('regular') ..
        [[Dwarves gain a +2 racial bonus on Appraise checks made to determine the price of non-magical goods that contain precious metals or gemstones.]] ..

        style('t3', "Stonecunning: ") .. style('regular') ..
        [[Dwarves gain a +2 bonus on Perception checks to notice unusual stonework, such as traps and hidden doors located in stone walls or floors. They receive a check to notice such features whenever they pass within 10 feet of them, whether or not they are actively looking.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Dwarves can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Hatred: ") .. style('regular') ..
        [[Dwarves gain a +1 racial bonus on attack rolls against humanoid creatures of the orc and goblinoid subtypes because of their special training against these hated foes.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Dwarves are proficient with battleaxes, heavy picks, and warhammers, and treat any weapon with the word “dwarven” in its name as a martial weapon.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Dwarves are a stoic but stern race, ensconced in cities carved from the hearts of mountains and fiercely determined to repel the depredations of savage races like orcs and goblins. More than any other race, dwarves have acquired a reputation as dour and humorless artisans of the earth. It could be said that their history shapes the dark disposition of many dwarves, for they reside in high mountains and dangerous realms below the earth, constantly at war with giants, goblins, and other such horrors.]] ..
        style('par') ..
        [[Dwarves are lovers of history and tradition, and their long lifespan leads to far less in the way of generational shifts in attitudes, styles, fashions, and trends than shorter-lived races exhibit. If a thing is not broken, they do not fix it or change it; and if it is broken, they fix it rather than replace it. Thrifty as a rule, dwarves are loath to discard anything unless it is truly ruined and unable to be fixed. At the same time, dwarves' meticulous, near-obsessive attention to detail and durability in their craftsmanship makes that a rare occurrence, as the things they make are built to last. As a result, buildings, artwork, tools, housewares, garments, weapons, and virtually everything else made by dwarves still sees regular use at an age when such items would be relegated to museum pieces, dusty antique shelves, or junkyard fodder by other races. Taken together, these traits create the impression that dwarves are a race frozen in time.]] ..
        [[Nothing could be further from the truth, however, as dwarves are both thoughtful and imaginative, willing to experiment, if always keen to refine and perfect a new technique or product before moving on to the next one. Dwarves have achieved feats of metallurgy, stonework, and engineering that have consistently outpaced the technological advances of other races, though some non-dwarven races have used magic to supplement and perfect their own creations to achieve the same ends through mystical rather than mundane means. They are also a race typified by stubborn courage and dedication to seeing tasks through to completion, whatever the risks. These traits have led dwarves to explore and settle in extreme environments that would cause other races to quail and retreat. From the darkest depths of the underworld to the highest mountain peaks, from rusting iron citadels along desolate rocky coasts to squat jungle ziggurats, dwarves have established their enclaves and redoubts, holding them against all comers or perishing to the last and leaving only their enduring monuments to stand as their legacy. While it is said that dwarves are not venturesome or inventive, it would be more accurate to say that they maintain a focus on and dedication to each task they undertake and every change they adopt, vetting such changes thoroughly before adopting them wholeheartedly. When faced with new circumstances and new needs, they react by applying tried and true tools and techniques systematically, using existing methods whenever possible rather than trying to invent novel solutions for every situation. If necessity requires, however, they throw themselves with equal vigor into developing the next perfect procedure for demolishing the obstacles that get in their way. Once their desired goal is obtained, they focus on consolidating each new piece of territory or conceptual advance. Dwarves thus rarely overextend themselves, but they also may miss opportunities to seize the initiative and maximize the advantages they create.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Dwarves are a short and stocky race, and stand about a foot shorter than most humans, with wide, compact bodies that account for their burly appearance. Male and female dwarves pride themselves on the long length of their hair, and men often decorate their beards with a variety of clasps and intricate braids. Clean-shavenness on a male dwarf is a sure sign of madness, or worse — no one familiar with their race trusts a beardless dwarven man.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[The great distances between dwarves' mountain citadels account for many of the cultural differences that exist within their society. Despite these schisms, dwarves throughout the world are characterized by their love of stonework, their passion for stone and metal-based craftsmanship and architecture, and their fierce hatred of giants, orcs, and goblinoids. In some remote enclaves, such as those areas where these races are uncommon or unheard of, dwarves' fixation on security and safety combined with their rather pugnacious nature leads them to find enemies or at least rivals wherever they settle. While they are not precisely militaristic, they learned long ago that those without axes can be hewn apart by them, and thus dwarves everywhere are schooled to be ready to enforce their rights and claims by force of arms. When their patience with diplomacy is exhausted, dwarves do not hesitate to adopt what they call “aggressive negotiations.”]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Dwarves and orcs have long dwelt in proximity to one another, and share a history of violence as old as both races. Dwarves generally distrust and shun half-orcs. They find elves, gnomes, and halflings to be too frail, flighty, or “pretty” to be worthy of proper respect. It is with humans that dwarves share the strongest link, for humans' industrious nature and hearty appetites come closest to matching those of the dwarven ideal.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Dwarves are driven by honor and tradition. While they are often stereotyped as standoffish, they have a strong sense of friendship and justice, and those who win their trust understand that while they work hard, they play even harder — especially when good ale is involved. Most dwarves are lawful good.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Although dwarven adventurers are rare compared to humans, they can be found in most regions of the world. Dwarves often leave the confines of their redoubts to seek glory for their clans, to find wealth with which to enrich the fortress-homes of their birth, or to reclaim fallen dwarven citadels from racial enemies. Dwarven warfare is often characterized by tunnel fighting and melee combat, and as such most dwarves tend toward classes such as fighters and barbarians.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###########################
    -- ######## RACE: ELF ########
    -- ###########################
    ['elf'] = (
        style('t1', "Elves") ..

        style('par') ..
        [[Tall, noble, and often haughty, elves are long-lived and subtle masters of the wilderness. Elves excel in the arcane arts. Often they use their intrinsic link to nature to forge new spells and create wondrous items that, like their creators, seem nearly impervious to the ravages of time. A private and often introverted race, elves can give the impression they are indifferent to the plights of others.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Elves are nimble, both in body and mind, but their form is frail. They gain +2 Dexterity, +2 Intelligence, and -2 Constitution.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Elves are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Elves are Humanoids with the elf subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Elves have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Elves begin play speaking Common and Elven. Elves with high Intelligence scores can choose from Celestial, Draconic, Gnoll, Gnome, Goblin, Orc and Sylvan languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Elven Immunities: ") .. style('regular') ..
        [[Elves are immune to magic sleep effects and gain a +2 racial saving throw bonus against enchantment spells and effects.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Elves receive a +2 racial bonus on Perception checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Elven Magic: ") .. style('regular') ..
        [[Elves receive a +2 racial bonus on caster level checks made to overcome spell resistance. In addition, elves receive a +2 racial bonus on Spellcraft skill checks made to identify the properties of magic items.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Elves are proficient with longbows (including composite longbows), longswords, rapiers, and shortbows (including composite shortbows), and treat any weapon with the word "elven" in its name as a martial weapon.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Elves can see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The long-lived elves are children of the natural world, similar in many superficial ways to fey creatures, though with key differences. While fey are truly linked to the flora and fauna of their homes, existing as the nearly immortal voices and guardians of the wilderness, elves are instead mortals who are in tune with the natural world around them. Elves seek to live in balance with the wild and understand it better than most other mortals. Some of this understanding is mystical, but an equal part comes from the elves' long lifespans, which in turn gives them long-ranging outlooks. Elves can expect to remain active in the same locale for centuries. By necessity, they must learn to maintain sustainable lifestyles, and this is most easily done when they work with nature, rather than attempting to bend it to their will. However, their links to nature are not entirely driven by pragmatism. Elves' bodies slowly change over time, taking on a physical representation of their mental and spiritual states, and those who dwell in a region for a long period of time find themselves physically adapting to match their surroundings, most noticeably taking on coloration that reflects the local environment.]] ..
        style('par') ..
        [[Elves value their privacy and traditions, and while they are often slow to make friends at both the personal and national levels, once an outsider is accepted as a comrade, the resulting alliances can last for generations. Elves take great joy in forging alliances with races that share or exceed their long lifetimes, and often work to befriend dragons, outsiders, and fey. Those elves who spend their lives among the short-lived races, on the other hand, often develop a skewed perception of mortality and become morose, the result of watching wave after wave of companions age and die before their eyes.]] ..
        style('t3', "Physical Description: ") .. style('regular') ..
        [[Elves are slightly shorter then humans and posses a graceful, slender physique that is accentuated by their long, pointed ears. It is a mistake, however, to consider them weak or feeble, as the thin limbs of an elf can contain surprising power. Their eyes are wide and almond-shaped, and filled with large, vibrantly colored pupils. The coloration of elves as a whole varies wildly, and is much more diverse than that of human populations. However, as their coloration often matches their surroundings, the elves of a single community may appear quite similar. Forest-dwelling elves often have variations of green, brown, and tan in their hair, eye, and even skin tones.]] ..
        style('par') ..
        [[While elven clothing often plays off the beauty of the natural world, those elves who live in cities tend to bedeck themselves in the latest fashions. Where city-dwelling elves encounter other urbanites, the elves are often fashion trendsetters.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Many elves feel a bond with nature and strive to live in harmony with the natural world. Although, like most, elves prefer bountiful lands where resources are plentiful, when driven to live in harsher climates, they work hard to protect and shepherd the region's bounty, and learn how to maximize the benefit they receive from what little can be harvested. When they can carve out a sustainable, reliable life in deserts and wastelands, they take pride as a society in the accomplishment. While this can make them excellent guides to outsiders they befriend who must travel through such lands, their disdain of those who have not learned to live off the scant land as they have makes such friends rare.]] ..
        style('par') ..
        [[Elves have an innate gift for craftsmanship and artistry, especially when working in wood, bone, ivory, or leather. Most, however, find manipulating earth and stone to be distasteful, and prefer to avoid forging, stonework, and pottery. When such work must be done within a community, a few elves may find themselves drawn to it, but regardless of their craftsmanship, such “dirt-wrights” are generally seen by other elves as being a bit off. In the most insular of elven societies, they may even be treated as lower class.]] ..
        style('par') ..
        [[Elves also have an appreciation for the written word, magic, and painstaking research. Their naturally keen minds and senses, combined with their inborn patience, make them particularly suited to wizardry. Arcane research and accomplishment are seen as both practical goals, in line with being a soldier or architect, and artistic endeavors as great as poetry or sculpture. Within elven society, wizards are held in extremely high regard as masters of an art both powerful and aesthetically valued. Other spellcasters are not disdained, but do not gain the praise lavished upon elven wizards.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Elves are prone to dismissing other races, writing them off as rash and impulsive, yet on an individual level, they are excellent judges of character. In many cases an elf will come to value a specific member of another race, seeing that individual as deserving and respectable, while still dismissing the race as a whole. If called on this behavior, the elf often doesn't understand why their “special friend” is upset the elf has noticed the friend is “so much better than the rest of their kind.” Even elves who see such prejudice for what it is must constantly watch themselves to prevent such views from coloring their thinking.]] ..
        style('par') ..
        [[Elves are not foolish enough, however, to dismiss all aspects of other races and cultures. An elf might not want a dwarf neighbor, but would be the first to acknowledge dwarves' skill at smithing and their tenacity in facing orc threats. Elves regard gnomes as strange (and sometimes dangerous) curiosities, but regard their magical talent as being worthy of praise and respect. Halflings are often viewed with a measure of pity, for these small folk seem to the elves to be adrift, without a traditional home. Elves are fascinated with humans, who seem to live in a few short years as full a life as an elf manages in centuries. In fact, many elves become infatuated with humans, as evidenced by the number of half-elves in the world. Elves have difficulty accepting crossbreeds of any sort, however, and usually disown such offspring. They similarly regard half-orcs with distrust and suspicion, assuming they possess the worst aspects of orc and human personalities.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Elves are emotional and capricious, yet value kindness and beauty. Most elves are chaotic good, wishing all creatures to be safe and happy, but unwilling to sacrifice personal freedom or choice to accomplish such goals. They prefer deities who share their love of the mystic qualities of the world.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Many elves embark on adventures out of a desire to explore the world, leaving their secluded realms to reclaim forgotten elven magic or search out lost kingdoms established millennia ago by their ancestors. This need to see a wider world is accepted by their societies as a natural part of becoming mature and experienced individuals. Such elves are expected to return in some few decades and take up lives in their homelands once more, enriched both in treasure and in worldview. For those elves raised among humans, however, life within their homes — watching friends and family swiftly age and die — is often stifling, and the ephemeral and unfettered life of an adventurer holds a natural appeal. Elves generally eschew melee because of their relative frailty, preferring instead to engage enemies at range. Most see combat as unpleasant even when needful, and prefer it be done as quickly as possible, preferably without getting close enough to smell their foes. This preference for making war at a distance, coupled with their natural accuracy and grasp of the arcane, encourages elves to pursue classes such as wizards and rangers.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##############################
    -- ######## RACE: GNOMES ########
    -- ##############################
    ['gnome'] = (
        style('t1', "Gnomes") ..

        style('par') ..
        [[Expatriates of the strange land of fey, these small folk have a reputation for flighty and eccentric behavior. Many gnomes are whimsical artisans and tinkers, creating strange devices powered by magic, alchemy, and their quirky imagination. Gnomes have an insatiable need for new experiences that often gets them in trouble.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Gnomes are physically weak but surprisingly hardy, and their attitude makes them naturally agreeable. They gain +2 Constitution, +2 Charisma, and –2 Strength.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Gnomes are Humanoid creatures with the gnome subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Gnomes are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a –1 penalty to their Combat Maneuver Bonus and Combat Maneuver Defense, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[(Slow Speed) Gnomes have a base speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Gnomes begin play speaking Common, Gnome, and Sylvan. Gnomes with high Intelligence scores can choose from Draconic, Dwarven, Elven, Giant, Goblin and Orc languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Defensive Training: ") .. style('regular') ..
        [[Gnomes gain a +4 dodge bonus to AC against monsters of the giant subtype.]] ..

        style('t3', "Illusion Resistance: ") .. style('regular') ..
        [[Gnomes gain a +2 racial saving throw bonus against illusion spells and effects.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Gnomes receive a +2 racial bonus on Perception checks.]] ..

        style('t3', "Obsessive: ") .. style('regular') ..
        [[Gnomes receive a +2 racial bonus on a Craft or Profession skill of their choice.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Gnome Magic: ") .. style('regular') ..
        [[Gnomes add +1 to the DC of any saving throws against illusion spells that they cast. Gnomes with Charisma scores of 11 or higher also gain the following spell-like abilities: 1/day — dancing lights, ghost sound, prestidigitation, and speak with animals. The caster level for these effects is equal to the gnome's level. The DC for these spells is equal to 10 + the spell's level + the gnome's Charisma modifier.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Hatred: ") .. style('regular') ..
        [[Gnomes receive a +1 bonus on attack rolls against humanoid creatures of the reptilian and goblinoid subtypes because of their special training against these hated foes.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Gnomes treat any weapon with the word “gnome” in its name as a martial weapon.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Gnomes can see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Gnomes are distant relatives of the fey, and their history tells of a time when they lived in the fey's mysterious realm, a place where colors are brighter, the wildlands wilder, and emotions more primal. Unknown forces drove the ancient gnomes from that realm long ago, forcing them to seek refuge in this world; despite this, the gnomes have never completely abandoned their fey roots or adapted to mortal culture. Though gnomes are no longer truly fey, their fey heritage can be seen in their innate magic powers, their oft-capricious natures, and their outlooks on life and the world.]] ..
        style('par') ..
        [[Gnomes can have the same concerns and motivations as members of other races, but just as often they are driven by passions and desires that non-gnomes see as eccentric at best, and nonsensical at worst. A gnome may risk their life to taste the food at a giant's table, to reach the bottom of a pit just because it would be the lowest place he's ever been, or to tell jokes to a dragon — and to the gnome those goals are as worthy as researching a new spell, gaining vast wealth, or putting down a powerful evil force. While such apparently fickle and impulsive acts are not universal among gnomes, they are common enough for the race as a whole to have earned a reputation for being impetuous and at least a little mad.]] ..
        style('par') ..
        [[Combined with their diminutive sizes, vibrant coloration, and lack of concern for the opinions of others, these attitudes have caused gnomes to be widely regarded by the other races as alien and strange. Gnomes, in turn, are often amazed how alike other common, civilized races are. It seems stranger to a gnome that humans and elves share so many similarities than that the gnomes do not. Indeed, gnomes often confound their allies by treating everyone who is not a gnome as part of a single, vast non-gnome collective race.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Gnomes are one of the smallest of the common races, generally standing just over 3 feet in height. Despite their small frames, however, gnomes are extremely resilient, and not as weak as many of their foes assume. Though their diminutive stature reduces their ability to move quickly, gnomes often train to take advantage of their size, especially when fighting foes much larger than themselves.]] ..
        style('par') ..
        [[The coloration of gnomes varies so wildly that many outsiders assume gnomes commonly use dyes and illusions to change their skin and hair tones. While gnomes are certainly not above cosmetic enhancement (and may wish to change their appearance just to see how outlandish they can look), their natural hues truly range over a rainbow of coloration. Their hair tends toward vibrant colors such as the fiery orange of autumn leaves, the verdant green of forests at springtime, or the deep reds and purples of wildflowers in bloom. Similarly, their flesh tones range from earthy browns to floral pinks, and gnomes with black, pastel blue, or even green skin are not unknown. Gnomes' coloration has little regard for heredity, with the color of a gnome's parents and other kin having no apparent bearing on the gnome's appearance. Gnomes possess highly mutable facial characteristics, and their proportions often don't match the norm of other humanoid races. Many have overly large mouths and eyes, an effect which can be both disturbing and stunning, depending on the individual. Others may have extremely small features spread over an otherwise blank expanse of face, or may mix shockingly large eyes with a tiny, pursed mouth and a pert button of a nose. Gnomes rarely take pride in or show embarrassment about their features, but members of other races often fixate on a gnome's most prominent feature and attempt to use it as the focus of insults or endearments.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Unlike most races, gnomes do not generally organize themselves within classic societal structures. Gnome cities are unusual and gnome kingdoms almost unknown. Further, gnomes have no particular tendency to gather in specific neighborhoods even when a large number of them live among other races. While specific laws meant to contain the potential impact of gnomes on a society may require a “gnome quarter,” and societal pressure sometimes causes all non-gnomes to move away from areas with high gnome populations, left to their own devices, gnomes tend to spread evenly throughout communities that allow them.]] ..
        style('par') ..
        [[However, even when gnomes are common within a community as a group, individual gnomes tend to be always on the move. Whimsical creatures at heart, they typically travel alone or with temporary companions, ever seeking new and more exciting experiences. They rarely form enduring relationships among themselves or with members of other races, instead pursuing crafts, professions, or collections with a passion that borders on zealotry. If a gnome does settle in an area or stay with a group for a longer period, it is almost always the result of some benefit that area gives to a vocation or obsession to which the gnome had dedicated himself.]] ..
        style('par') ..
        [[Despite their extremely varied backgrounds and lack of a unifying homeland, gnomes do possess some common cultural traits. Male gnomes have a strange fondness for unusual hats and headgear, often wearing the most expensive and ostentatious head-covering they can afford (and that their chosen careers will allow them to wear without causing problems). Females rarely cover their heads, but proudly wear elaborate and eccentric hairstyles that often include intricate jeweled combs and headpieces.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Gnomes have difficulty interacting with the other races, on both emotional and physical levels. In many ways the very fact other races see gnomes as odd is itself the thing gnomes find most odd about other races, and this leads to a strong lack of common ground upon which understanding and relationships can be built. When two gnomes encounter one another, they generally assume some mutually beneficial arrangement can be reached, no matter how different their beliefs and traditions may be. Even if this turns out not to be the case, the gnomes continue to look for commonalities in their dealings with each other. The inability or unwillingness of members of other races to make the same effort when dealing with gnomes is both frustrating and confusing to most gnomes.]] ..
        style('par') ..
        [[In many ways, it is gnomes' strong connection to a wide range of apparently unconnected ideas that makes it difficult for other races to build relationships with them. Gnome humor, for example, is often focused on physical pranks, nonsensical rhyming nicknames, and efforts to convince others of outrageous lies that strain all credibility. Gnomes find such efforts hysterically funny, but their pranks often come across as malicious or senseless to other races, while gnomes in turn tend to think of the taller races as dull and lumbering giants. Gnomes get along reasonably well with halflings and humans, who at least have some traditions of bizarre, gnome-like humor. Gnomes generally feel dwarves and half-orcs need to lighten up, and attempt to bring levity into their lives with tricks, jokes, and outrageous tales the more dour races simply cannot see the sense of. Gnomes respect elves, but often grow frustrated with the slow pace at which members of the long-lived race make decisions. To gnomes, action is always better than inaction, and many gnomes carry several highly involved projects with them at all times to keep themselves entertained during rest periods.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Although gnomes are impulsive tricksters, with sometimes inscrutable motives and equally confusing methods, their hearts are generally in the right place. What may seem a malicious act to a non-gnome is more likely an effort to introduce new acquaintances to new experiences, however unpleasant the experiences may be. Gnomes are prone to powerful fits of emotion, and find themselves most at peace within the natural world. They are usually neutral good, and prefer to worship deities who value individuality and nature.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Gnomes' propensity for wanderlust, deep curiosity, and desire to master odd or esoteric skills and languages make them natural adventurers. They often become wanderers to experience new aspects of life, for nothing is as novel as the uncounted dangers facing adventurers. Many gnomes see adventuring as the only worthwhile purpose in life, and seek out adventures for no other motive than to experience them. Other gnomes desire to find some lost lore or material that has ties to their chosen vocation and believe only dragon hoards and ancient ruins can contain the lore they need, which can result in gnomes who think of themselves as bakers or weavers being just as accomplished adventurers as those who declare themselves to be mages or scouts.]] ..
        style('par') ..
        [[Gnomes are physically weak compared to many races, and see this as a simple fact of life to be planned for accordingly. Most adventuring gnomes make up for their weakness with a proclivity for sorcery or bardic music, while others turn to alchemy or exotic weapons to grant them an edge in conflicts.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ################################
    -- ######## RACE: HALF-ELF ########
    -- ################################
    ['half-elf'] = (

        style('t1', "Half-elves") ..

        style('par') ..
        [[Often caught between the worlds of their progenitor races, half-elves are a race of both grace and contradiction. Their dual heritage and natural gifts often create brilliant diplomats and peacemakers, but half-elves are often susceptible to an intense and even melancholic isolation, realizing that they are never truly part of elven or human society.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Half-elf characters gain a +2 bonus to one ability score of their choice at creation to represent their varied nature.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Half-elves are humanoid creatures with both the human and the elf subtypes.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Half-elves are Medium creatures and have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Half-elves have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Half-elves begin play speaking Common and Elven. Half-elves with high Intelligence scores can choose any languages they want (except secret languages, such as Druidic). See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Elven Immunities: ") .. style('regular') ..
        [[Half-elves are immune to magic sleep effects and gain a +2 racial saving throw bonus against enchantment spells and effects.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Adaptability: ") .. style('regular') ..
        [[Half-elves receive Skill Focus as a bonus feat at 1st level.]] ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Half-elves receive a +2 racial bonus on Perception checks.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Half-elves can see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Elf Blood: ") .. style('regular') ..
        [[Half-elves count as both elves and humans for any effect related to race.]] ..

        style('t3', "Multitalented: ") .. style('regular') ..
        [[Half-elves choose two favored classes at first level and gain +1 hit point or +1 skill point whenever they take a level in either one of those classes.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Elves have long drawn the covetous gazes of other races. Their generous lifespans, magical affinity, and inherent grace each contribute to the admiration or bitter envy of their neighbors. Of all their traits, however, none so entrance their human associates as their beauty. Since the two races first came into contact with each other, humans have held up elves as models of physical perfection, seeing in these fair folk idealized versions of themselves. For their part, many elves find humans attractive despite their comparatively barbaric ways, and are drawn to the passion and impetuosity with which members of the younger race play out their brief lives.]] ..
        style('par') ..
        [[Sometimes this mutual infatuation leads to romantic relationships. Though usually short-lived, even by human standards, such trysts may lead to the birth of half-elves, a race descended from two cultures yet inheritor of neither. Half-elves can breed with one another, but even these “pureblood” half-elves tend to be viewed as bastards by humans and elves alike. Caught between destiny and derision, half-elves often view themselves as the middle children of the world.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Half-elves stand taller than humans but shorter than elves. They inherit the lean build and comely features of their elven lineage, but their skin color is normally dictated by their human side. While half-elves retain the pointed ears of elves, theirs are more rounded and less pronounced. Their eyes tend to be human-like in shape, but feature an exotic range of colors from amber or violet to emerald green and deep blue. This pattern changes for half-elves of drow descent, however. Such elves are almost unfailingly marked with the white or silver hair of the drow parent, and more often than not have dusky gray skin that takes on a purplish or bluish tinge in the right light, while their eye color usually favors that of the human parent.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Their lack of a unified homeland and culture forces half-elves to remain versatile, able to conform to nearly any environment. While often considered attractive to both races for the same reasons as their parents, half-elves rarely fit in with either humans or elves, as both races see too much evidence of the other in them. This lack of acceptance weighs heavily on many half-elves, yet others are bolstered by their unique status, seeing in their lack of a formalized culture the ultimate freedom. As a result, half-elves are incredibly adaptable, capable of adjusting their mind-sets and talents to whatever societies they find themselves in. Even half-elves welcomed by one side of their heritage often find themselves caught between cultures, as they are encouraged, cajoled, or even forced into taking on diplomatic responsibilities between human and elven kind. Many half-elves rise to the occasion of such service, seeing it as a chance to prove their worth to both races. Others, however, come to resent the pressures and presumptions foisted upon them by both races and turn any opportunity to broker power, make peace, or advance trade between humans and elves into an exercise in personal profit.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Half-elves understand loneliness, and know that character is often less a product of race than of life experience. As such, they are often open to friendships and alliances with other races, and less likely than most to rely on first impressions when forming opinions of new acquaintances. While many races join together to produce mixed offspring of notable power, such as half-orcs, half-dragons, and half-fiends, half-elves seem to have a unique position in the eyes of their progenitors and the rest of the world. Those humans who admire elvenkind see half-elves as a living link or bridge between the two races. But this attitude often foists unfair expectations and elevated standards upon half-elves, and quickly turns to derision when they do not live up to the grand destinies that others set for them. Additionally, those half-elves raised by or in the company of elves often have the human half of their parentage dubbed a mere obstacle, something to be overcome with proper immersion and schooling in the elven ways, and even the most well-meaning elven mentors often push their half-elven charges to reject a full half of themselves in order to “better” themselves. The exception is those few half-elves born of humans and drow. Not unlike most half-orcs, such unions are commonly born out of violence and savagery that leaves the child unwanted by its mother if not killed outright. Moreover, as the physical features of half-drow clearly mark their parentage, crafting a reputation founded on deeds and character instead of heritage is more challenging for them. Even the most empathetic of other half-elves balk at the sight of a half-drow. Among other races, half-elves form unique and often unexpected bonds. Dwarves, despite their traditional mistrust of elves, see a half-elf's human parentage as something hopeful, and treat them as half-humans rather than half-elves. Additionally, while dwarves are long-lived, the lifespan of the stout folk is closer to a half-elf's own than that of either of their parents. As a result, half-elves and dwarves often form lasting bonds, be they ones of friendship, business, or even competitive rivalry.]] ..
        style('par') ..
        [[Gnomes and halflings often see half-elves as a curiosity. Those half-elves who have seen themselves pushed to the edges of society, truly without a home, typically find gnomes and halflings frivolous and worthy of disdain, but secretly envy their seemingly carefree ways. Clever and enterprising gnomes and halflings sometimes partner with a half-elf for adventures or even business ventures, using the half-elf's participation to lend their own endeavors an air of legitimacy that they cannot acquire on their own.]] ..
        style('par') ..
        [[Perhaps the most peculiar and dichotomous relations exist between half-elves and half-orcs. Those half-orcs and half-elves who were raised among their non-human kin normally see one another as hated and ancient foes. However, half-elves who have been marginalized by society feel a deep, almost instant kinship with half-orcs, knowing their burdens are often that much harder because of their appearance and somewhat brutish nature. Not all half-orcs are inclined or able to understand such empathy, but those who do often find themselves with a dedicated diplomat, liaison, and apologist. For their own part, half-orcs usually return the favor by acting as bodyguards or intimidators, and take on other roles uniquely suited to their brawny forms.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Half-elves' isolation strongly influences their characters and philosophies. Cruelty does not come naturally to them, nor does blending in or bending to societal convention — as a result, most half-elves are chaotic good. Half-elves' lack of a unified culture makes them less likely to turn to religion, but those who do generally follow the common faiths of their homeland. Others come to religion and worship later in their lives, especially if they have been made to feel part of a community through faith or the work of clerical figures. Some half-elves feel the pull of the divine but live beyond the formal religious instruction of society. Such individuals often worship ideas and concepts like freedom, harmony, or balance, or the primal forces of the world. Still others gravitate toward long-forgotten gods, finding comfort and kinship in the idea that even deities can be overlooked.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Half-elves tend to be itinerants, wandering the lands in search of a place they might finally call home. The desire to prove themselves to the community and establish a personal identity — or even a legacy — drives many half-elf adventurers to lives of bravery. Some half-elves claim that despite their longevity, they perceive the passage of time more like humans than elves, and are driven to amass wealth, power, or fame early on in life so they may spend the rest of their years enjoying it.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ################################
    -- ######## RACE: HALFLING ########
    -- ################################

    ['halfling'] = (
        style('t1', "Halflings") ..

        style('par') ..
        [[Members of this diminutive race find strength in family, community, and their own innate and seemingly inexhaustible luck. While their fierce curiosity is sometimes at odds with their intrinsic common sense, half lings are eternal optimists and cunning opportunists with an incredible knack for getting out the worst situations.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Halflings are nimble and strong-willed, but their small stature makes them weaker than other races. They gain +2 Dexterity, +2 Charisma, and -2 Strength.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Halflings are Small creatures and gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty to their CMB and CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Base Speed (Slow Speed): ") .. style('regular') ..
        [[Halflings have a base speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Halflings begin play speaking Common and Halfling. Halflings with high Intelligence scores can choose from Dwarven, Elven, Gnome and Goblin languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Fearless: ") .. style('regular') ..
        [[Halflings receive a +2 racial bonus on all saving throws against fear. This bonus stacks with the bonus granted by halfling luck.]] ..

        style('t3', "Halfling Luck: ") .. style('regular') ..
        [[Halflings receive a +1 racial bonus on all saving throws.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Sure-Footed: ") .. style('regular') ..
        [[Halflings receive a +2 racial bonus on Acrobatics and Climb checks.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Halflings are proficient with slings and treat any weapon with the word "halfling" in its name as a martial weapon.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Halflings receive a +2 racial bonus on Perception checks.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Optimistic and cheerful by nature, blessed with uncanny luck, and driven by a powerful wanderlust, halflings make up for their short stature with an abundance of bravado and curiosity. At once excitable and easy-going, halflings like to keep an even temper and a steady eye on opportunity, and are not as prone to violent or emotional outbursts as some of the more volatile races. Even in the jaws of catastrophe, halflings almost never lose their sense of humor. Their ability to find humor in the absurd, no matter how dire the situation, often allows halflings to distance themselves ever so slightly from the dangers that surround them. This sense of detachment can also help shield them from terrors that might immobilize their allies.]] ..
        style('par') ..
        [[Halflings are inveterate opportunists. They firmly believe they can turn any situation to their advantage, and sometimes gleefully leap into trouble without any solid plan to extricate themselves if things go awry. Often unable to physically defend themselves from the rigors of the world, they know when to bend with the wind and when to hide away. Yet halflings' curiosity often overwhelms their good sense, leading to poor decisions and narrow escapes. While harsh experience sometimes teaches halflings a measure of caution, it rarely makes them completely lose faith in their luck or stop believing that the universe, in some strange way, exists for their entertainment and would never really allow them to come to harm. Though their curiosity drives them to seek out new places and experiences, halflings possess a strong sense of hearth and home, often spending above their means to enhance the comforts of domestic life. Without a doubt, halflings enjoy luxury and comfort, but they have equally strong reasons to make their homes a showcase. Halflings consider this urge to devote time, money, and energy toward improving their dwellings a sign of both respect for strangers and affection for their loved ones. Whether for their own blood kin, cherished friends, or honored guests, halflings make their homes beautiful in order to express their feelings toward those they welcome inside. Even traveling halflings typically decorate their wagons or carry a few cherished keepsakes to adorn their campsites.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Halflings rise to a humble height of 3 feet. They prefer to walk barefoot, leading the bottoms of their feet to become roughly calloused. Tufts of thick, curly hair warm the tops of their broad, tanned feet.]] ..
        style('par') ..
        [[Their skin tends toward a rich cinnamon color and their hair toward light shades of brown. A halfling's ears are pointed, but proportionately not much larger than those of a human.]] ..
        style('par') ..
        [[Halflings prefer simple and modest clothing. Though willing and able to dress up if the situation demands it, their racial urge to remain quietly in the background makes them rather conservative dressers in most situations. Halfling entertainers, on the other hand, make their livings by drawing attention, and tend to go overboard with gaudy and flashy costumes.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Rather than place their faith in empires or great causes, many halflings prefer to focus on the simpler and humbler virtues of their families and local communities. Halflings claim no cultural homeland and control no settlements larger than rural assemblies of free towns. Most often, they dwell at the knees of their human cousins in human cities, eking out livings as they can from the scraps of larger societies. Many halflings lead perfectly fulfilling lives in the shadow of their larger neighbors, while some prefer more nomadic lives, traveling the world and experiencing all it has to offer.]] ..
        style('par') ..
        [[Halflings rely on customs and traditions to maintain their own culture. They have an extensive oral history filled with important stories about folk heroes who exemplify particular halfling virtues, but otherwise see little purpose in studying history in and of itself. Given a choice between a pointless truth and a useful fable, halflings almost always opt for the fable. This tendency helps to explain at least something of the famous halfling adaptability. Halflings look to the future and find it very easy to cast off the weight of ancient grudges or obligations that drag down so many other races.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[A typical halfling prides himself on their ability to go unnoticed by other races — a trait that allows many halflings to excel at thievery and trickery. Most halflings know full well the stereotypical view other races take of them as a result, and go out of their way to be forthcoming and friendly to the bigger races when they're not trying to go unnoticed. They get along fairly well with gnomes, although most halflings regard these eccentric creatures with a hefty dose of caution. Halflings respect elves and dwarves, but these races often live in remote regions far from the comforts of civilization that halflings enjoy, thus limiting opportunities for interaction. By and large, only half-orcs are shunned by halflings, for their great size and violent natures are a bit too intimidating for most halflings to cope with. Halflings coexist well with humans as a general rule, but since some of the more aggressive human societies value halflings as slaves, they try not to grow too complacent. Halflings strongly value their freedom, especially the ability to travel in search of new experiences and the autonomy this requires. However, practical and flexible as always, enslaved halflings seldom fight back directly against their masters. When possible, they wait for the perfect opportunity and then simply slip away. Sometimes, if enslaved for long enough, halflings even come to adopt their owners as their new families. Though they still dream of escape and liberty, these halflings also make the best of their lives.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Halflings are loyal to their friends and families, but since they dwell in a world dominated by races twice as large as themselves, they have come to grips with the fact that sometimes they need to scrape and scrounge for survival. Most halflings are neutral as a result. Though they usually make a show of respecting the laws and endorsing the prejudices of their communities, halflings place an even greater emphasis on the innate common sense of the individual. When a halfling disagrees with society at large, he will do what he thinks is best. Always practical, halflings frequently worship the deity most favored by their larger and more powerful neighbors. They also usually cover their bets, however. The goddess of both luck and travel seems a natural fit for most halflings and offering their a quick prayer every now and then is only common sense.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Their inherent luck coupled with their insatiable wanderlust makes halflings ideal candidates for lives of adventure. Though perfectly willing to pocket any valuables they come across, halflings often care more for the new experiences adventuring brings them than for any material reward. Halflings tend to view money as a means of making their lives easier and more comfortable, not as an end in and of itself. Other such vagabonds often put up with this curious race in hopes that some of their mystical luck will rub off. Halflings see nothing wrong with encouraging this belief, not just in their traveling companions, but also in the larger world. Many try to use their reputation for luck to haggle for reduced fare when traveling by ship or caravan, or even for an overnight stay at an inn. They meet with mixed success, but there are just enough stories circulating about the good fortune that befalls people traveling with halflings to give even the most skeptical pause. Of course, some suspect that halflings deliberately spread these reports for just that reason.]] ..

            style('par') ..
            style('credits') ..
            "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ################################
    -- ######## RACE: HALF-ORC ########
    -- ################################
    ['half-orc'] = (
        style('t1', "Half-orcs") ..

        style('par') ..
        [[Often fierce and savage, sometimes noble and resolute, half-orcs can manifest the best and worst qualities of their parent races. Many half-orcs struggle to keep their more bestial natures in check in order to epitomize the most heroic values of humanity. Unfortunately, many outsiders see half-orcs as hopeless abominations devoid of civility, if not monsters unworthy of pity or parley.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Half-orc characters gain a +2 bonus to one ability score of their choice at creation to represent their varied nature.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Half-orcs are Humanoid creatures with both the human and orc subtypes.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Half-orcs are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Half-orcs have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Half-orcs begin play speaking Common and Orc. Half-orcs with high Intelligence scores can choose from Abyssal, Draconic, Giant, Gnoll and Goblin languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Intimidating: ") .. style('regular') ..
        [[Half-orcs receive a +2 racial bonus on Intimidate checks due to their fearsome nature.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Orc Ferocity: ") .. style('regular') ..
        [[Once per day, when a half-orc is brought below 0 hit points but not killed, he can fight on for 1 more round as if disabled. At the end of his next turn, unless brought to above 0 hit points, he immediately falls unconscious and begins dying.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Half-orcs are proficient with greataxes and falchions and treat any weapon with the word "orc" in its name as a martial weapon.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Half-orcs can see in the dark up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Orc Blood: ") .. style('regular') ..
        [[Half-orcs count as both humans and orcs for any effect related to race.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[As seen by civilized races, half-orcs are monstrosities, the result of perversion and violence — whether or not this is actually true. Half-orcs are rarely the result of loving unions, and as such are usually forced to grow up hard and fast, constantly fighting for protection or to make names for themselves. Half-orcs as a whole resent this treatment, and rather than play the part of the victim, they tend to lash out, unknowingly confirming the biases of those around them. A few feared, distrusted, and spat-upon half-orcs manage to surprise their detractors with great deeds and unexpected wisdom — though sometimes it's easier just to crack a few skulls. Some half-orcs spend their entire lives proving to full-blooded orcs that they are just as fierce. Others opt for trying to blend into human society, constantly demonstrating that they aren't monsters. Their need to always prove themselves worthy encourages half-orcs to strive for power and greatness within the society around them.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Half-orcs average around 6 feet tall, with powerful builds and greenish or grayish skin. Their canine teeth often grow long enough to protrude from their mouths, and these “tusks,” combined with heavy brows and slightly pointed ears, give them their notoriously bestial appearance. While half-orcs may be impressive, few ever describe them as beautiful. Despite these obvious orc traits, half-orcs are as varied as their human parents.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Unlike half-elves, where at least part of society's discrimination is born out of jealousy or attraction, half-orcs get the worst of both worlds: physically weaker than their orc kin, they also tend to be feared or attacked outright by humans who don't bother making the distinction between full orcs and half bloods. Even on the best of terms, half-orcs in civilized societies are not exactly accepted, and tend to be valued only for their physical abilities. On the other hand, orc leaders have been known to deliberately spawn half-orcs, as the half breeds make up for their lack of physical strength with increased cunning and aggression, making them natural leaders and strategic advisors. Within orc tribes, half-orcs find themselves constantly striving to prove their worth in battle and with feats of strength. Half-orcs raised within orc tribes are more likely to file their tusks and cover themselves in tribal tattoos. Tribal leaders quietly recognize that half-orcs are often more clever than their orc cousins and often apprentice them to the tribe's shaman, where their cunning might eventually strengthen the tribe. Apprenticeship to a shaman is a brutal and often short-lived distinction, however, and those half-orcs who survive it either become influential in the tribe or are eventually driven to leave.]] ..
        style('par') ..
        [[Half-orcs have a much more mixed experience in human society, where many cultures view them as little more than monsters. They often are unable even to get normal work, and are pressed into service in the military or sold into slavery. In these cultures, half-orcs often lead furtive lives, hiding their nature whenever possible. The dark underworld of society is often the most welcoming place, and many half-orcs wind up serving as enforcers for thieves guilds or other types of organized crime. Less commonly, human cities may allow half-orcs a more normal existence, even enabling them to develop small communities of their own. These communities are usually centered around the arena districts, the military, or mercenary organizations where their brute strength is valued and their appearance is more likely to be overlooked. Even surrounded by their own kind, half-orc life isn't easy. Bullying and physical confrontation comes easy to a people who have been raised with few other examples of behavior. It is, however, one of the best places for young half-orcs to grow up without prejudice, and these small enclaves are one of the few places where half-orc marriages and children are truly accepted and sometimes cherished.]] ..
        style('par') ..
        [[Even more rarely, certain human cultures come to embrace half-orcs for their strength. There are stories of places where people see half-orc children as a blessing and seek out half-orc or orc lovers. In these cultures, half-orcs lead lives not much different from full-blooded humans.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Elves and dwarves tend to be the least accepting of half-orcs, seeing in them too great a resemblance to their racial enemies, and other races aren't much more understanding. A lifetime of persecution leaves the average half-orc wary and quick to anger, yet people who break through their savage exterior might find a well-hidden core of empathy. Human societies with few orc problems tend to be the most accommodating, and half-orcs dwelling there can often find work as mercenaries and enforcers. Even in places where there is a general tolerance for half-orcs, however, many humans mistreat them when they can get away with it.]] ..
        style('par') ..
        [[Half-orcs are envious of the measure of acceptance half-elves have within human and elven society and resent their physical beauty, which contrasts starkly to the half-orcs' brutish appearance. While half-orcs avoid antagonizing their half-breed cousins directly, they won't hesitate to undermine them if the opportunity presents itself.]] ..
        style('par') ..
        [[Of all the other races, half-orcs are most sympathetic with halflings, who often have an equally rough lot in life. Half-orcs respect the halfling's ability to blend in and disappear and admire their perpetually cheerful outlook on life in spite of hardships. Halflings fail to appreciate this fact because they usually are too busy avoiding the large, intimidating half-orcs.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Forced to live either among brutish orcs or as lonely outcasts in civilized lands, most half-orcs are bitter, violent, and reclusive. Evil comes easily to them, but they are not evil by nature — rather, most half-orcs are chaotic neutral, having been taught by long experience that there's no point doing anything but that which directly benefits themselves. Half-orcs worship the human or orc gods venerated in the area where they were raised. Those who live alongside humans most often worship human gods of war, freedom, or destruction. Half-orcs raised in orc tribes find themselves most drawn to the gods of blood, fire, and iron — depending more on what god the tribe worships rather than the half-orcs' personal preference. Many half-orcs are contrary about religion, either ignoring it entirely, or getting deeply involved in it and trying to find meaning in a life filled with hate and misunderstanding; even a half-orc divine spellcaster may wrestle with doubt and anger about religion and faith.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Staunchly independent, many half-orcs take to lives of adventure out of necessity, seeking to escape their painful pasts or improve their lot through force of arms. Others, more optimistic or desperate for acceptance, take up the mantle of crusaders in order to prove their worth to the world. Half-orcs raised in orc societies often take up the brutish ways of those around them, becoming fighters, barbarians, or rangers. Half-orcs who survive their shaman training may eventually succeed their masters as tribal shamans, or flee the tribe and practice their magic as outcasts or explorers.]] ..
        style('par') ..
        [[Half-orcs are just as likely to have children that possess an innate talent for sorcery as any other race, with the abyssal, destined, and elemental (fire) bloodlines being the most common types of sorcerers. Half-orcs are fascinated by alchemy, and its destructive capabilities make its usefulness obvious in any orc tribe. Half-orc alchemists treat themselves as living experiments, even to the point of trying to separate their orc and human halves through alchemy. Other alchemists use their powers to enhance their physical abilities and thus increase their status within orc communities.]] ..
        style('par') ..
        [[In human societies, half-orcs have a few more options. Many find it easy to take advantage of the brute strength and work as mercenaries or caravan guards. Crime is another easy route for half-orcs, as there are plenty of criminals looking for a strong arm. Half-orc clerics in human communities are fairly rare; the more religious half-orcs more often turn to (or get pushed to) the martial aspects of religious service and become paladins or inquisitors. Half-orcs usually lack the patience and money required to become a wizard.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- #############################
    -- ######## RACE: HUMAN ########
    -- #############################
    ['human'] = (
        style('t1', [[Humans]]) ..

        style('par') ..
        [[Ambitious, sometimes heroic, and always confident, humans have an ability to work together toward common goals that makes them a force to be reckoned with. Though short-lived compared to other races, their boundless energy and drive allow them to accomplish much in their brief lifetimes.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Human characters gain a +2 racial bonus to one ability score of their choice at creation to represent their varied nature.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Humans are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Humans have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Humans begin play speaking Common. Humans with high Intelligence scores can choose any languages they want (except secret languages, such as Druidic). See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Bonus Feat: ") .. style('regular') ..
        [[Humans select one extra feat at 1st level.]] ..

        style('t3', "Skilled: ") .. style('regular') ..
        [[Humans gain an additional skill rank at first level and one additional rank whenever they gain a level.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Humans possess exceptional drive and a great capacity to endure and expand, and as such are currently the dominant race in the world. Their empires and nations are vast, sprawling things, and the citizens of these societies carve names for themselves with the strength of their sword arms and the power of their spells. Humanity is best characterized by its tumultuousness and diversity, and human cultures run the gamut from savage but honorable tribes to decadent, devil-worshiping noble families in the most cosmopolitan cities. Humans' curiosity and ambition often triumph over their predilection for a sedentary lifestyle, and many leave their homes to explore the innumerable forgotten corners of the world or lead mighty armies to conquer their neighbors, simply because they can.]] ..
        style('par') ..
        [[Human society is a strange amalgam of nostalgia and futurism, being enamored of past glories and wistfully remembered “golden ages,” yet at the same time quick to discard tradition and history and strike off into new ventures. Relics of the past are kept as prized antiques and museum pieces, as humans love to collect things — not only inanimate relics but also living creatures — to display for their amusement or to serve by their side. Other races suggest this behavior is due to a deep-rooted urge to dominate and assert power in the human psyche, an urge to take, till, or tame the wild things and places of the world. Those with a more charitable view believe humans are simply collectors of experiences, and the things they take and keep, whether living, dead, or never alive, are just tokens to remind themselves of the places they have gone, the things they have seen, and the deeds they have accomplished. Their present and future value is just a bonus; their real value is as an ongoing reminder of the inevitable progress of humanity.]] ..
        style('par') ..
        [[Humans in many places are fascinated by older races and cultures, though at times they grow frustrated or even contemptuous of ancient and (to their mind) outmoded traditions. Their attitudes toward other races are thus a curious mix of exoticism and even fetishism, though usually with a very superficial level of understanding and appreciation of those cultures, alongside a deeply rooted arrogance that means most humans have a hard time regarding themselves as anything other than the default standard of society. Human scholars engaged in the study of other races — who might be assumed to be the most cosmopolitan and well versed in their nature and culture — have often proved no better than the less-learned members of their race when it comes to genuine closing of the social distance. Humans are gregarious, often friendly, and willing to mix and interact with others, but their sheer obliviousness to their off handed marginalization of others is what so chagrins other races when dealing with them.]] ..
        style('par') ..
        [[Of course, well-meaning, blundering ignorance and numerical superiority are not the only things that make other races suspicious of humans. Entirely too many examples can be found throughout history wherein human xenophobia and intolerance has led to social isolationism, civil oppression, bloody purges, inquisitions, mob violence, and open war. Humans are not the only race to hate what is different among them, but they seem to have a susceptibility to fear-mongering and suspicion, whether about race, language, religion, class, gender, or another difference. More moderate human citizens often sit idly by while their more extreme compatriots dominate the political and cultural conversation, yet there are also many who stand in opposition to extremists and embody a spirit of unity across the bounds of difference, transcending barriers and forming alliances and relationships both large and small across every color, creed, country, or species.]] ..
        style('t3', [[Physical Description: ]]) .. style('regular') ..
        [[The physical characteristics of humans are as varied as the world's climes. From the dark-skinned tribesmen of the southern continents to the pale and barbaric raiders of the northern lands, humans possess a wide variety of skin colors, body types, and facial features. Generally speaking, humans' skin color assumes a darker hue the closer to the equator they live. At the same time, bone structure, hair color and texture, eye color, and a host of facial and bodily phenotypic characteristics vary immensely from one locale to another. Cheekbones may be high or broad, noses aquiline or flat, and lips full or thin; eyes range wildly in hue, some deep set in their sockets, and others with full epicanthic folds. Appearance is hardly random, of course, and familial, tribal, or national commonalities often allow the knowledgeable to identify a human's place of origin on sight, or at least to hazard a good guess. Humans' origins are also indicated through their traditional styles of bodily decoration, not only in the clothing or jewelry worn, but also in elaborate hairstyles, piercing, tattooing, and even scarification.]] ..

        style('t3', [[Society: ]]) .. style('regular') ..
        [[Human society comprises a multitude of governments, attitudes, and lifestyles. Though the oldest human cultures trace their histories thousands of years into the past, when compared to the societies of other races like elves and dwarves, human society seems to be in a state of constant flux as empires fragment and new kingdoms subsume the old. In general, humans are known for their flexibility, ingenuity, and ambition. Other races sometimes envy humans their seemingly limitless adaptability, not so much biologically speaking but in their willingness to step beyond the known and press on to whatever might await them. While many or even most humans as individuals are content to stay within their comfortable routine, there is a dauntless spirit of discovery endemic to humans as a species that drives them in striving toward possibilities beyond every horizon.]] ..

        style('t3', [[Relations: ]]) .. style('regular') ..
        [[Humans are fecund, and their drive and numbers often spur them into contact with other races during bouts of territorial expansion and colonization. In many cases, this tendency leads to violence and war, yet humans are also swift to forgive and forge alliances with races who do not try to match or exceed them in violence. Proud, sometimes to the point of arrogance, humans might look upon dwarves as miserly drunkards, elves as flighty fops, halflings as craven thieves, gnomes as twisted maniacs, and half-elves and half-orcs as embarrassments — but the race's diversity among its own members also makes many humans quite adept at accepting others for what they are. Humans may become so absorbed in their own affairs that they remain ignorant of the language and culture of others, and some take this ignorance to a hateful extreme of intolerance, oppression, and rarely even extermination of others they perceive as dangerous, strange, or “impure.” Thankfully, while such incidents and movements may taint all of humanity in the eyes of some, they are more often the exception than the rule.]] ..

        style('t3', [[Alignment and Religion: ]]) .. style('regular') ..
        [[Humanity is perhaps the most diverse of all the common races, with a capacity for both great evil and boundless good. Some humans assemble into vast barbaric hordes, while others build sprawling cities that cover miles. Taken as a whole, most humans are neutral, yet they generally tend to congregate in nations and civilizations with specific alignments. Humans also have the widest range of gods and religions, lacking other races' ties to tradition and eager to turn to anyone offering them glory or protection.]] ..

        style('t3', [[Adventurers: ]]) .. style('regular') ..
        [[Ambition alone drives countless humans, and for many, adventuring serves as a means to an end, whether it be wealth, acclaim, social status, or arcane knowledge. A few pursue adventuring careers simply for the thrill of danger. Humans hail from myriad regions and backgrounds, and as such can fill any role within an adventuring party.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),
    -- ###############################
    -- ######## RACE: AASIMAR ########
    -- ###############################
    ["aasimar"] = (
        style('t1', "Aasimar") ..

        style('par') ..
        [[Creatures blessed with a celestial bloodline, aasimars seem human except for some exotic quality that betrays their otherworldly origin. While aasimars are nearly always beautiful, something simultaneously a part of and apart from humanity, not all of them are good, though very few are evil.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', 'Ability Score Racial Traits: ') .. style('regular') ..
        [[Aasimars are insightful, confident, and personable. They gain +2 Wisdom and +2 Charisma.]] ..

        style('t3', 'Type: ') .. style('regular') ..
        [[Aasimars are outsiders with the native subtype.]] ..

        style('t3', 'Size: ') .. style('regular') ..
        [[Aasimars are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', 'Base Speed: ') .. style('regular') ..
        [[Aasimars have a base speed of 30 feet.]] ..

        style('t3', 'Languages: ') .. style('regular') ..
        [[Aasimars begin play speaking Common and Celestial. Aasimars with high Intelligence scores can choose from Draconic, Dwarven, Elven, Gnome, Halfling and Sylvan languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', 'Celestial Resistance: ') .. style('regular') ..
        [[Aasimars have acid resistance 5, cold resistance 5, and electricity resistance 5.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', 'Skilled: ') .. style('regular') ..
        [[Aasimar have a +2 racial bonus on Diplomacy and Perception checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', 'Spell-Like Ability (Sp): ') .. style('regular') ..
        [[Aasimars can use daylight once per day as a spell-like ability (caster level equal to the aasimar's class level).]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', 'Darkvision: ') .. style('regular') ..
        [[Aasimar have darkvision 60 ft. (they can see perfectly in the dark up to 60 feet.)]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Aasimars are humans with a significant amount of celestial or other good outsider blood in their ancestry. While not always benevolent, aasimars are more inclined toward acts of kindness rather than evil, and they gravitate toward faiths or organizations associated with celestials. Aasimar heritage can lie dormant for generations, only to appear suddenly in the child of two apparently human parents. Most societies interpret aasimar births as good omens, though it must be acknowledged that some aasimars take advantage of the reputation of their kind, brutally subverting the expectations of others with acts of terrifying cruelty or abject venality. “It's always the one you least suspect” is the axiom these evil aasimars live by, and they often lead double lives as upstanding citizens or false heroes, keeping their corruption well hidden. Thankfully, these few are the exception and not the rule.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Aasimars look mostly human except for some minor physical trait that reveals their unusual heritage. Typical aasimar features include hair that shines like metal, jewel-toned eyes, lustrous skin color, or even glowing, golden halos.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Aasimars cannot truly be said to have an independent society of their own. As an offshoot of humanity, they adopt the societal norms around them, though most find themselves drawn to those elements of society that work for the redress of injustice and the assuagement of suffering. This sometimes puts them on the wrong side of the law in more tyrannical societies, but aasimars can be careful and cunning when necessary, able to put on a dissembling guise to divert the attention of oppressors elsewhere. While corrupt aasimars may be loners or may establish secret societies to conceal their involvement in crime, righteous aasimars are often found congregating in numbers as part of good-aligned organizations, especially (though not always) churches and religious orders.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Aasimars are most common and most comfortable in human communities. This is especially true of those whose lineage is more distant and who bear only faint marks of their heavenly ancestry. It is unclear why the touch of the celestial is felt so much more strongly in humanity than other races, though it may be that humanity's inherent adaptability and affinity for change is responsible for the evolution of aasimars as a distinct race. Perhaps the endemic racial traits of other races are too deeply bred, too strongly present, and too resistant to change. Whatever dalliances other races may have had with the denizens of the upper planes, the progeny of such couplings are vanishingly rare and have never bred true. However, even if they generally tend toward human societies, aasimars can become comfortable in virtually any environment. They have an easy social grace and are disarmingly personable. They get on well with half-elves, who share a similar not-quite-human marginal status, though their relations are often less cordial with half-orcs, who have no patience for aasimars' overly pretty words and faces. Elven courtiers sometimes dismiss aasimars as unsophisticated, and criticize them for relying on natural charm to overcome faux pas. Perhaps of all the known races, gnomes find aasimars most fascinating, and have an intense appreciation for their varied appearances as well as the mystique surrounding their celestial heritage.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Aasimars are most often of good alignment, though this isn't necessarily universal, and aasimars that have turned their back on righteousness may fall into an unfathomable abyss of depravity. For the most part, however, aasimars favor deities of honor, valor, protection, healing, and refuge, or simple and prosaic faiths of home, community, and family. Some also follow the paths of art, music, and lore, finding truth and wisdom in beauty and learning.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Aasimars frequently become adventurers, as they often do not quite feel at home in human society and feel the pull of some greater destiny. Clerics, oracles, and paladins are most plentiful in their ranks, though bards, sorcerers, and summoners are not uncommon among those with a fondness for arcane magic. Aasimar barbarians are rare, but when born into such tribes they often rise to leadership and encourage their clans to embrace celestial totems.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: CATFOLK ########
    -- ###############################
    ["catfolk"] = (
        style('t1', "Catfolk") ..

        style('par') ..
        [[A race of graceful explorers, catfolk are both clannish and curious by nature. They tend to get along with races that treat them well and respect their boundaries. They love exploration, both physical and intellectual, and tend to be natural adventurers.]] ..

        style('t2', 'Standard Racial Traits') ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Catfolk are sociable and agile, but often lack common sense. They gain +2 Dexterity, +2 Charisma, -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Catfolk are humanoids with the catfolk subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Catfolk are Medium creatures and have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Catfolk have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Catfolk begin play speaking Common and Catfolk. catfolk with high Intelligence scores can choose from Elven, Gnoll, Gnome, Goblin, Halfling, Orc and Sylvan languages.]] ..

        style('t2', 'Defense Racial Traits') ..
        style('t3', "Cat's Luck (Ex): ") .. style('regular') ..
        [[Once per day when a catfolk makes a Reflex saving throw, he can roll the saving throw twice and take the better result. He must decide to use this ability before the saving throw is attempted.]] ..

        style('t2', 'Feat and Skill Racial Traits') ..
        style('t3', "Natural Hunter: ") .. style('regular') ..
        [[Catfolk receive a +2 racial bonus on Perception, Stealth, and Survival checks.]] ..

        style('t2', 'Movement Racial Traits') ..
        style('t3', "Sprinter: ") .. style('regular') ..
        [[Catfolk gain a 10-foot racial bonus to their speed when using the charge, run, or withdraw actions.]] ..

        style('t2', 'Senses Racial Traits') ..
        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[catfolk have low-light vision allowing them to see twice as far as humans in dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Catfolk are a race of natural explorers who rarely tire of trailblazing, but such trailblazing is not limited merely to the search for new horizons in distant lands. Many catfolk see personal growth and development as equally valid avenues of exploration. While most catfolk are nimble, capable, and often active creatures, there is also a strong tendency among some catfolk to engage in quiet contemplation and study. Such individuals are interested in finding new solutions to age-old problems and questioning even the most steadfast philosophical certainties of the day. They are curious by nature, and catfolk culture never discourages inquisitiveness, but rather fosters and encourages it. Many are seen as quirky extroverts by members of other races, but within catfolk tribes there is no shame attached to minor peculiarities, eccentricities, or foolhardiness. All but the most inwardly focused catfolk enjoy being the center of attention, but not at the expense of their tribe, whether it's the one the catfolk are born into or the tribe they choose through the bonds of friendship with other creatures. catfolk tend to be both generous and loyal to their family and friends.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[In general, catfolk are lithe and slender, standing midway between dwarves and humans in stature. While clearly humanoid, they possess many feline features, including a coat of soft fine fur, slit pupils, and a sleek, slender tail. Their ears are pointed, but unlike those of elves, are more rounded and catlike. They manipulate objects as easily as any other humanoid, but their fingers terminate in small, sharp, retractable claws. These claws are typically not powerful enough to be used as weapons, but some members of the species — either by quirk of birth or from years of honing — can use them with deadly effect. Feline whiskers are not uncommon, but not universal, and hair and eye color vary greatly.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[While self-expression is an important aspect of catfolk culture, it is mitigated by a strong sense of community and group effort. In the wild, catfolk are a hunter-gatherer tribal people. The pursuit of personal power never comes before the health and well-being of the tribe. More than one race has underestimated this seemingly gentle people only to discover much too late that their cohesion also provides them great strength.]] ..
        style('par') ..
        [[Catfolk prefer to be led by their most competent members, usually a council of sub-chieftains chosen by their peers, either though consensus or election. The sub-chiefs then choose a chieftain to lead in times of danger and to mediate disputes among the sub-chiefs. The chieftain is the most capable member of the tribe, and is often magically talented. catfolk who settle in more urban and civilized areas still cling to a similar tribal structure, but often see friends outside the tribe, even those from other races, as part of their extended tribe. Within adventuring groups, catfolk who do not consider themselves the obvious choice as chieftain often defer to the person who most resembles their cultural ideal of a chieftain.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Adaptable and curious, catfolk get along with almost any race that extends reciprocal goodwill. They acclimate easily to halflings, humans, and especially elves. catfolk and elves share a passionate nature, as well as a love of music, dance, and storytelling; elven communities often gently mentor catfolk tribes, though such elves are careful not to act in a patronizing manner toward their feline friends. Gnomes make natural companions for catfolk, as catfolk enjoy gnomes' strange and obsessive qualities. catfolk are tolerant of kobolds as long as the reptilian beings respect the Catfolk's boundaries. The feral nature of orcs stirs as much puzzlement as it does revulsion among catfolk, as they don't understand orcs' savagery and propensity for self-destruction. Half-orcs, on the other hand, intrigue catfolk, especially those half-orcs who strive to excel beyond the deleterious and hateful nature of their savage kin. Catfolk often view goblins and ratfolk as vermin, as they disdain the swarming and pernicious tendencies of those races.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[With community and unselfish cooperation at the center of their culture, as well as a good-natured curiosity and willingness to adapt to the customs of many other races, most catfolk tend toward good alignments. The clear majority of catfolk are also chaotic, as wisdom is not their strongest virtue; nevertheless, there are exceptions with cause.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Natural born trackers, the hunter-gatherer aspect of their tribes pushes many catfolk toward occupations as rangers and druids by default, but such roles don't always speak to their love of performance art, be it song, dance, or storytelling. catfolk legends also speak of a rich tradition of great sorcerer heroes. Those catfolk who internalize their wanderlust often become wizards and monks, with many of those monks taking the path of the nimble guardian. While catfolk cavaliers and inquisitors are rare (steadfast dedication to a cause is often alien to the catfolk mindset) individuals who choose these paths are never looked down upon. catfolk understand that exploration and self-knowledge can lead down many roads, and are accepting of nearly all professions and ways of life.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: DHAMPIR ########
    -- ###############################
    ["dhampir"] = (
        style('t1', "Dhampir") ..

        style('par') ..
        [[The accursed spawn of vampires, dhampirs are living creatures tainted with the curse of undeath, which causes them to take damage from positive energy and gain healing from negative energy. While many members of this race embrace their dark sides, others are powerfully driven to rebel against their taint and hunt down and destroy vampires and their ilk.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', 'Ability Score Racial Traits: ') .. style('regular') ..
        [[Dhampirs are fast and seductive, but their racial bond to the undead impedes their mortal vigor. They gain +2 Dexterity, +2 Charisma, and -2 Constitution.]] ..

        style('t3', 'Type: ') .. style('regular') ..
        [[Dhampirs are humanoids with the dhampir subtype.]] ..

        style('t3', 'Size: ') .. style('regular') ..
        [[Dhampirs are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', 'Base Speed: ') .. style('regular') ..
        [[Dhampirs have a base speed of 30 feet.]] ..

        style('t3', 'Languages: ') .. style('regular') ..
        [[Dhampirs begin play speaking Common. Those with high Intelligence scores can choose any language it wants (except secret languages, such as Druidic). See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', 'Undead Resistance: ') .. style('regular') ..
        [[Dhampirs gain a +2 racial bonus on saving throws against disease and mind-affecting effects.]] ..

        style('t3', 'Resist Level Drain (Ex): ') .. style('regular') ..
        [[A dhampir takes no penalties from energy drain effects, though he can still be killed if he accrues more negative levels then he has Hit Dice. After 24 hours, any negative levels a dhampir takes are removed without the need for an additional saving throw.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', 'Manipulative: ') .. style('regular') ..
        [[Dhampire gain a +2 racial bonus on Bluff and Perception checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', 'Spell-Like Abilities (Su): ') .. style('regular') ..
        [[A dhampir can use detect undead three times per day as a spell-like ability. The caster level for this ability equals the dhampir's class level.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', 'Darkvision: ') .. style('regular') ..
        [[Dhampir see perfectly in the dark up to 60 feet.]] ..

        style('t3', 'Low-light vision: ') .. style('regular') ..
        [[In addition to their ability to see perfectly in the dark up to 60 ft, dhampir have low-light vision, allowing them to see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', 'Light Sensitivity: ') .. style('regular') ..
        [[Dhampirs are dazzled in areas of bright sunlight or within the radius of a daylight spell.]] ..

        style('t3', 'Negative Energy Affinity: ') .. style('regular') ..
        [[Though a living creature, a dhampir reacts to positive and negative energy as if it were undead-positive energy harms it, while negative energy heals it.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The half-living children of vampires birthed by human females, dhampirs are progenies of both horror and tragedy. The circumstances of a dhampir's conception are often called into question but scarcely understood, as few mortal mothers survive the childbirth. Those who do often abandon their monstrous children and refuse to speak of the matter. While some speculate that dhampirs result when mortal women couple with vampires, others claim that they form when a pregnant woman suffers a vampire bite. Some particularly zealous scholars even contest dhampirs' status as a unique race, instead viewing them as humans suffering from an unholy affliction. Indeed, this hypothesis is strengthened by dhampirs' seeming inability to reproduce, their offspring inevitably humans (usually sorcerers with the undead bloodline).]] ..
        style('par') ..
        [[Regardless, they live and die just like any other mortal creatures, despite possessing a supernatural longevity akin to that of elves. Hardship and suffering fill a dhampir's formative years. Most grow up as orphans, and despite their exquisite features and innate charm, they face a lifetime of prejudice, mistrust, fear, and persecution. Humans who witness the seemingly sinister nature of a dhampir child's supernatural powers or sensitivity to daylight display an array of reactions ranging from awe to terror to outright hatred. Eventually, a dhampir must learn to cope with these difficulties in order to find his place in the world. While most dhampirs succumb to the innate evil of their undead heritage and devolve into the monstrous fiends depicted by society, a few reject their unholy conceptions, instead vowing to avenge their mothers by hunting the very creatures that sired them. Dhampirs keep few, if any, close companions. Ultimately, the majority of evil dhampirs regard their allies as little more than tools or fodder. Those whom they deem useful are judged by their merits as individuals, not by their race. However, even with those they feel attached to, most dhampirs are sullen and reserved. Some fear the persecution heaped upon them may be transferred to their companions, whereas others worry their own bloodlust will one day overwhelm them and they'll inadvertently turn upon their friends. In any case, an alliance with a dhampir almost always leads to an ill-fated conclusion.]] ..

        style('t3', 'Physical Description: ') .. style('regular') ..
        [[Tall and slender and with well-defined musculature, dhampirs look like statuesque humans of unearthly beauty. Their hair, eye, and skin colors resemble unnerving versions of their mothers'; many possess a ghastly pallor, particularly in the sunlight, while those with dark complexions often possess skin the color of a bruise.]] ..
        style('par') ..
        [[While many dhampirs can pass as humans in ideal conditions, their features are inevitably more pronounced and they move with an unnaturally fluid grace. All dhampirs have elongated incisors. While not true fangs, these teeth are sharp enough to draw blood, and many suffer a reprehensible desire to indulge in sanguinary delights, despite the fact that the act provides most no physical benefit.]] ..

        style('t3', 'Society: ') .. style('regular') ..
        [[Dhampirs have no culture of their own, nor do they have any known lands or even communities. Often born in secret and abandoned at orphanages or left to die on the outskirts of town, they tend to live solitary lives as exiles and outcasts. Individuals acquire the cultural beliefs and teachings of the regions in which they grew up, and adopt additional philosophies over the course of their complex lives. This ability to adapt to a verity of circumstances provides dhampirs with a social camouflage that hides them from both predators and prey. In rare instances, dhampirs might gather to form small groups or cabals dedicated to resolving their joint issues. Even so, the philosophies of such groups reflect the interests of the individuals involved, not any common dhampir culture.]] ..

        style('t3', 'Relations: ') .. style('regular') ..
        [[As dhampirs are scions of evil, few races view them favorably. They share an affinity for those half-breeds whose sinister ancestry also sets them apart from human society, particularly tieflings and half-orcs. Humans view them with a combination of fear and pity, though such feelings often devolve into hatred and violence. Other humanoid races, such as dwarves, elves, and halflings, simply shun them. Similarly, dhampirs bear a deep-seeded loathing for living creatures, their hatred planted by jealousy and fed by frustration.]] ..

        style('t3', 'Alignment and Religion: ') .. style('regular') ..
        [[Most dhampirs succumb to the evil within their blood. They are unnatural creatures, and the foul influence of their undead heritage makes an evil outlook difficult to overcome. Those who struggle against their wicked natures rarely progress beyond a neutral outlook.]] ..

        style('t3', 'Adventurers: ') .. style('regular') ..
        [[The life of an adventurer comes naturally to most dhampirs, since constant persecution condemns many to spend their days wandering. Evil dhampirs keep moving to maintain their secrecy and evade lynch mobs, while those who follow the path of vengeance venture forth in search of their despised fathers. Regardless of their reasons, most dhampirs simply feel more at home on the road than in a settlement. Having little formal training, a great many of these journeyers become fighters and rogues.]] ..
        style('par') ..
        [[Almost universally, those inclined toward magic pursue the field of necromancy, though dhampir alchemists have been known to obsess over transforming their own bodies. Those who feel the call of the hunt often become inquisitors.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ############################
    -- ######## RACE: DROW ########
    -- ############################
    ["drow"] = (
        style('t1', "Drow") ..

        style('par') ..
        [[Dark reflections of surface elves, drow are shadowy hunters who strive to snuff out the world's light. Drow are powerful magical creatures who typically serve demons, and only their chaotic nature stops them from becoming an even greater menace. A select few forsake their race's depraved and nihilistic society to walk a heroic path.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Drow are nimble and manipulative. They gain +2 Dexterity, +2 Charisma, and -2 Constitution.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Drow are humanoids with the elf subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Drow are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Drow have a base speed of 30 feet.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Drow are proficient with the hand crossbow, rapier, and shortsword.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Drow begin play speaking Elven and Undercommon. Drow with high Intelligence scores can choose from Abyssal, Aklo, Aquan, Common, Draconic, Drow Sign Language, Gnome or Goblin languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Immunities: ") .. style('regular') ..
        [[Drow are immune to magic sleep effects and gain a +2 racial bonus on saving throws against enchantment spells and effects.]] ..

        style('t3', "Spell Resistance: ") .. style('regular') ..
        [[Drow possess spell resistance (SR) equal to 6 plus their total number of class levels.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Drow gain a +2 racial bonus on Perception checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Abilities (Su): ") .. style('regular') ..
        [[Drow can cast dancing lights, darkness, and faerie fire, once each per day, using their total character level as caster level.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Poison Use: ") .. style('regular') ..
        [[Drow are skilled in the use of poisons and never risk accidentally poisoning themselves.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Superior Darkvision: ") .. style('regular') ..
        [[Drow have superior darkvision, allowing them to see perfectly in the dark up to 120 feet.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', "Light Blindness: ") .. style('regular') ..
        [[As deep underground dwellers naturally, drow suffer from light blindness. Abrupt exposure to any bright light blinds drow for 1 round. On subsequent rounds, they are dazzled as long as they remain in the affected area.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Cruel and cunning, drow are a dark reflection of the elven race. Also called dark elves, they dwell deep underground in elaborate cities shaped from the rock of cyclopean caverns. Drow seldom make themselves known to surface folk, preferring to remain legends while advancing their sinister agendas through proxies and agents. Drow have no love for anyone but themselves, and are adept at manipulating other creatures. While they are not born evil, malignancy is deep-rooted in their culture and society, and nonconformists rarely survive for long. Some stories tell that given the right circumstances, a particularly hateful elf might turn into a drow, though such a transformation would require a truly heinous individual.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Drow are similar in stature to humans, but share the slender build and features of elves, including the distinctive long, pointed ears. Their eyes lack pupils and are usually solid white or red. Drow skin ranges from coal black to a dusky purple. Their hair is typically white or silver, though some variation is not unknown.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Drow society is traditionally class-oriented and matriarchal. Male drow usually fulfill martial roles, defending the species from external threats, while female drow assume positions of leadership and authority. Reinforcing these gender roles, one in 20 drow are born with exceptional abilities and thus considered to be nobility, and the majority of these special drow are female. Noble houses define drow politics, with each house governed by a noble matriarch and composed of lesser families, business enterprises, and military companies. Each house is also associated with a demon lord patron. Drow are strongly driven by individual self-interest and advancement, which shapes their culture with seething intrigue and politics, as common drow jockey for favor of the nobility, and the nobility rise in power through a combination of assassination, seduction, and treachery.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Drow have a strong sense of racial superiority and divide non-drow into two groups]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Drow place a premium on power and survival, and are unapologetic about any vile choices they might make to ensure their survival. After all, they do not just survive adversity — they conquer it. They have no use for compassion, and are unforgiving of their enemies, both ancient and contemporary. Drow retain the elven traits of strong emotion and passion, but channel it through negative outlets, such as hatred, vengeance, lust for power, and raw carnal sensation. Consequently, most drow are chaotic evil. Demon lords are their chosen patrons, sharing their inclination toward power and destruction.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Conquerors and slavers, drow are driven to expand their territory, and many seek to settle ancient grudges upon elven and dwarven nations in ruinous and dreary sites of contested power on the surface. Male drow favor martial or stealth classes that put them close to their enemies and their homes, as either soldiers or spies. Female drow typically assume classes that lend themselves to leadership, such as bards and especially clerics. Both genders have an innate talent for the arcane arts, and may be wizards or summoners. Drow make natural antipaladins, but males are often discouraged from this path, as the feminine nobility feel discomforted by the idea of strong-willed males with autonomous instincts and a direct relationship with a demon lord.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##################################
    -- ######## RACE: FETCHLINGS ########
    -- ##################################
    ["fetchlings"] = (
        style('t1', "Fetchlings") ..

        style('par') ..
        [[Long ago, fetchlings were humans exiled to the Shadow Plane, but that plane's persistent umbra has transformed them into a race apart. These creatures have developed an ability to meld into the shadows and have a natural affinity for shadow magic. Fetchlings — who call themselves kayal — often serve as emissaries between the inhabitants of the Shadow Plane and the Material Plane.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Fetchlings are quick and forceful, but often strange and easily distracted by errant thoughts.They gain +2 Dexterity, +2 Charisma, and -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Fetchlings are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Fetchlings are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Fetchlings have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Fetchlings begin play speaking Common. Fetchlings with a high Intelligence scores can choose from Aklo, Aquan, Auran, Draconic, D'ziriak (understanding only, cannot speak), Ignan, Terran and any regional human tongue. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Shadow Blending (Su): ") .. style('regular') ..
        [[Attacks against a fetchling in dim light have a 50% miss chance instead of the normal 20% miss chance. This ability does not grant total concealment; it just increases the miss chance.]] ..

        style('t3', "Shadowy Resistance: ") .. style('regular') ..
        [[Fetchlings have cold resistance 5 and electricity resistance 5.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Skilled: ") .. style('regular') ..
        [[Fetchlings have a +2 racial bonus on Knowledge (planes) and Stealth checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Abilities (Sp): ") .. style('regular') ..
        [[A fetchling can use disguise self once per day as a spell-like ability. He can assume the form of any humanoid creature. A fetchling's caster level is equal to his total Hit Dice. When a fetchling reaches 9th level in any combination of classes, he gains shadow walk (self only) as a spell-like ability usable once per day as a spell-like ability. A fetchling's caster level is equal to his total Hit Dice. When a fetchling reaches 13th level in any combination of classes, he gains plane shift (self only, to the Shadow Plane or the Material Plane only) usable once per day as a spell-like ability. A fetchling's caster level is equal to his total Hit Dice.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Fetchlings can see perfectly in the dark up to 60 feet.]] ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[In addition to their ability to see perfectly in the dark up to 60 ft, fetchlings have low-light vision, allowing them to see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Descended from humans trapped on the Shadow Plane, fetchlings are creatures of darkness and light intertwined. Generations of contact with that strange plane and its denizens have made fetchlings a race apart from humanity. While fetchlings acknowledge their origins, they exhibit little physical or cultural resemblance to their ancestors on the Material Plane, and are often insulted when compared to humans. Some members of the race also take offense at the name fetchling, as it was given to them by humans who saw them as little more than fetchers of rare materials from the Shadow Plane. Most fetchlings instead prefer to be called kayal, a word borrowed from Aklo that roughly translates to “shadow people” or “dusk dwellers.” Infused with the essence of the Shadow Plane and possessing human blood commingled with that of the Shadow Plane's natives, fetchlings have developed traits and abilities that complement their native plane's bleak and colorless terrain. Though most fetchlings treat the Shadow Plane as home, they often trade and deal with creatures of the Material Plane. Some fetchlings go so far as to create enclaves on the Material Plane in order to establish alliances and trade routes in areas where the boundary between the two planes is less distinct. These fetchlings often serve as merchants, middlemen, and guides for races on both sides of the planar boundary.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Superficially, fetchlings resemble unnaturally lithe — bordering on fragile — humans. Their adopted home has drained their skin and hair of bright colors. Their complexion ranges from stark white to deep black, and includes all the various shades of gray between those two extremes. Their eyes are pupilless and pronounced, and they typically glow a luminescent shade of yellow or greenish yellow, though rare individuals possess blue-green eyes. While their hair tends to be stark white or pale gray, many fetchlings dye their hair black. Some members of higher station or those who dwell on the Material Plane dye their hair with more striking colors, often favoring deep shades of violet, blue, and crimson.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[fetchling are adaptable creatures, and as such display no singular preference for moral philosophy or the rule of law. Most mimic the cultural norms and governmental structures of those they live near or the creatures they serve. While fetchlings are arguably the most populous race on the Shadow Plane, they rarely rule over their own kind; most serve as vassals or subjects to the great umbral dragons of their homeland, or the bizarre nihiloi who dwell in the deeper darkness. Above all, fetchlings are survivors. Their tenacity, versatility, and devious pragmatism have helped them survive the harsh environs of the Shadow Plane and plots of the powerful creatures dwelling within it. On the Material Plane, especially if unable to return to their home plane at will, fetchlings tend to cluster in small, insular communities of their own kind, mimicking the cultural norms and political structures of those they trade with.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Because of their shared ancestry, fetchlings interact most easily with humans, though they also find kinship with gnomes and other races that were cut off from their home planes or are not native to the Material Plane. Their pragmatism and adaptable nature put them at odds with warlike or destructive races, and when they do have to deal with orcs, goblinoids, or other savage cultures, fetchlings will often play the part of the fawning sycophant, a tactic learned from serving umbral dragons and one they see as key to their race's survival. Strangely, their relationship with dwarves and elves are rather strained. Dwarves find fetchlings duplicitous and creepy, while the tension with elves is so subtle and inexplicable that both races find it difficult to explain.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Fetchlings — especially those living outside the Shadow Plane — worship a wide variety of gods. A small number of evil fetchlings worship demon lords of darkness and lust.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[The Shadow Plane's ever-present hazards pose great danger to fetchling adventurers, but also great opportunity. Because of their servile status on their home plane, however, most fetchlings prefer to adventure on the Material Plane, which often offers more freedom and trading opportunities between the two planes. Fetchlings make excellent ninjas, oracles, rangers, rogues, and summoners.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: GOBLINS ########
    -- ###############################
    ["goblins"] = (
        style('t1', "Goblins") ..

        style('par') ..
        [[Crazy pyromaniacs with a tendency to commit unspeakable violence, goblins are the smallest of the goblinoid races. While they are a fun-loving race, their humor is often cruel and hurtful. Adventuring goblins constantly wrestle with their darkly mischievous side in order to get along with others. Few are truly successful.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Goblins are fast, but weak and unpleasant to be around. They gain +4 Dexterity, -2 Strength, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Goblins are humanoids with the goblinoid subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Goblins are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty to their CMB and CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Goblins are fast for their size, and have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Goblins begin play speaking Goblin. Goblins with high Intelligence scores can choose from Common, Draconic, Dwarven, Gnoll, Gnome, Halfling, and Orc languages. See the Linguistics skill page for more information about these languages]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Skilled: ") .. style('regular') ..
        [[Goblins gain a +4 racial bonus on Ride and Stealth checks.]] ..

        style('t2', "Movement Racial Traits") ..

        style('t3', "Fast Movement: ") .. style('regular') ..
        [[Goblins gain a +10 foot bonus to their base speed (this is already added to their Base Speed above.)]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Goblins see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Goblins are a race of childlike creatures with a destructive and voracious nature that makes them almost universally despised. Weak and cowardly, goblins are frequently manipulated or enslaved by stronger creatures that need destructive, disposable foot soldiers. Those goblins that rely on their own wits to survive live on the fringes of society and feed on refuse and the weaker members of more civilized races. Most other races view them as virulent parasites that have proved impossible to exterminate.]] ..
        style('par') ..
        [[Goblins can eat nearly anything, but prefer a diet of meat and consider the flesh of humans and gnomes a rare and difficult-to-obtain delicacy. While they fear the bigger races, goblins' short memories and bottomless appetites mean they frequently go to war or execute raids against other races to sate their pernicious urges and fill their vast larders.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Goblins are short, ugly humanoids that stand just over 3 feet tall. Their scrawny bodies are topped with over-sized and usually hairless heads with massive ears and beady red or occasionally yellow eyes. Goblins' skin tone varies based on the surrounding environment; common skin tones include green, gray, and blue, though black and even pale white goblins have been sighted. Their voracious appetites are served well by their huge mouths filled with jagged teeth.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Violent but fecund, goblins exist in primitive tribal structures with constant shifts in power. Rarely able to sustain their own needs through farming or hunting and gathering, goblin tribes live where food is abundant or near places that they can steal it from. Since they are incapable of building significant fortifications and have been driven out of most easily accessible locations, goblins tend to live in unpleasant and remote locations, and their poor building and planning skills ensure that they dwell primarily in crude caves, ramshackle villages, and abandoned structures. Few goblins are good with tools or skilled at farming, and the rare items of any value that they possess are usually cast-off implements from humans or other civilized cultures. Goblins' appetites and poor planning lead to small tribes dominated by the strongest warriors. Even the hardiest goblin leaders quickly find out that their survival depends on conducting frequent raids to secure sources of food and kill off the more aggressive youth of the tribe. Both goblin men and women are ugly and vicious, and both sexes are just as likely to rise to positions of power in a tribe. goblin babies are almost completely self-sufficient not long after birth, and such infants are treated almost like pets. Many tribes raise their children communally in cages or pens where adults can largely ignore them. Mortality is high among young goblins, and when the adults fail to feed them or food runs low, youths learn at an early age that cannibalism is sometimes the best means of survival in a goblin tribe.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Goblins tend to view other beings as sources of food, which makes for poor relations with most civilized races. Goblins often survive on the fringes of human civilization, preying on weak or lost travelers and occasionally raiding small settlements to fuel their voracious appetites. They have a special animosity toward gnomes, and celebrate the capturing or killing of such victims with a feast. Of the most common races, half-orcs are the most tolerant of goblins, sharing a similar ancestry and experiencing the same hatred within many societies. Goblins are mostly unaware of half-orcs' sympathy, however, and avoid them because they are larger, meaner, and less flavorful than other humanoids.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Goblins are greedy, capricious, and destructive by nature, and thus most are neutral or chaotic evil.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[goblin adventurers are usually curious and inclined to explore the world, though they are often killed off by their own foolish misdeeds or hunted down for their random acts of destruction. Their pernicious nature makes interacting with civilized races almost impossible, so goblins tend to adventure on the fringes of civilization or in the wilds. Adventurous individuals who survive long enough often ride goblin dogs or other exotic mounts, and focus on archery to avoid close confrontation with larger enemies. goblin spellcasters prefer fire magic and bombs over almost all other methods of spreading mayhem.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##################################
    -- ######## RACE: HOBGOBLINS ########
    -- ##################################
    ["hobgoblins"] = (

        style('t1', "Hobgoblins") ..

        style('par') ..
        [[These creatures are the most disciplined and militaristic of the goblinoid races. Tall, tough as nails, and strongly built, hobgoblins would be a boon to any adventuring group, were it not for the fact that they tend to be cruel and malicious, and often keep slaves.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Hobgoblins are fast and hardy. They gain +2 Dexterity, and +2 Constitution.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Hobgoblins are humanoids with the goblinoid subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Hobgoblins are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Hobgoblins have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Hobgoblins begin play speaking Common and Goblin. Hobgoblins with high Intelligence scores can choose from Draconic, Dwarven, Infernal, Giant and Orc languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Sneaky: ") .. style('regular') ..
        [[Hobgoblins receive a +4 racial bonus on Stealth checks.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Hobgoblins can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Fierce and militaristic, hobgoblins survive by conquest. The raw materials to fuel their war machines come from raids, their armaments and buildings from the toil of slaves worked to death. Naturally ambitious and envious, hobgoblins seek to better themselves at the expense of others of their kind, yet in battle they put aside petty differences and fight with discipline rivaling that of the finest soldiers. Hobgoblins have little love or trust for one another, and even less for outsiders. Life for these brutes consists of duty to those of higher station, domination of those below, and the rare opportunities to seize personal glory and elevate their status.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Burly and muscled, hobgoblins stand a few inches shorter than the average human, and their long arms, thick torsos, and relatively short legs give them an almost apelike stature. Hobgoblins' skin is a sickly gray-green that darkens to mossy green after long exposure to the sun. Their eyes burn fiery orange or red, and their broad faces and sharply pointed ears give their features a somewhat feline cast. Hobgoblins lack facial hair, and even hobgoblin women are bald. Except for their size, hobgoblins bear a strong physical resemblance to their goblin cousins.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Hobgoblins live in militaristic tyrannies, each community under the absolute rule of a hobgoblin general. Every hobgoblin in a settlement receives military training, with those who excel serving in the army and the rest left to serve more menial roles. Those deemed unfit for military service have little social status, barely rating above favored slaves. Despite this, hobgoblin society is egalitarian after a fashion. Gender and birth offer no barrier to advancement, which is determined almost solely by each individual's personal merit. Hobgoblins eschew strong attachments, even to their young. Matings are matters of convenience, and are almost always limited to hobgoblins of equal rank. Any resulting baby is taken from its mother and forcibly weaned after 3 weeks of age. Young mature quickly — most take no more than 6 months to learn to talk and care for themselves. Hobgoblins' childhoods last a scant 14 years, a mirthless span filled with brutal training in the art of war.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Hobgoblins view other races as nothing more than tools — implements to be enslaved, cowed, and put to work. Without slaves, hobgoblin society would collapse, so reliant is it on stolen labor. An injured, sickly, or defiant slave is like a broken tool, useless waste to be tossed out with the day's garbage. Not surprisingly, hobgoblin communities count no other races as their friends, and few as allies. Elves and dwarves earn special enmity, and are devilishly hard to break into proper slavery as both races hold blood feuds against goblinkind. Halflings and half-orcs make especially prized slaves-the former for their agile skills and the ease of breaking them to the collar, and the latter for their talent at thriving under the harshest of conditions. Hobgoblins have little love for the rest of goblinkind, though they typically treat goblinoid slaves better than they do other races.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[hobgoblin life is nothing if not ordered and hierarchical, and hobgoblins lean strongly toward the lawful alignments. While not innately evil, the callous and brutal training that fills the too-short childhood of hobgoblins leaves most embittered and full of hate. Hobgoblins of good alignment number the fewest, and almost exclusively consist of individuals raised in other cultures. More numerous but still rare are hobgoblins of chaotic bent, most often exiles cast out by the despots of their homelands. Religion, like most non-militaristic pursuits, matters little to the majority of hobgoblins. Most pay lip-service to one or more gods and occasionally make offerings to curry favor or turn aside ill fortune. Those hobgoblins who feel a stronger religious calling venerate fearsome, tyrannical gods and devils.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[hobgoblin adventurers tend to be iconoclasts, loners who chafe under the strict hierarchy of military life. Others have fled or been exiled in disgrace for showing weakness or cowardice. Some harbor dreams of one day returning to the hobgoblin flock flush with wealth and tales of great deeds. A few serve farsighted hobgoblin generals, who send the most promising youths out into the world that they might someday return as mighty heroes for the hobgoblin cause. Hobgoblins lean toward martial classes, particularly cavaliers, fighters, monks, and rogues. The arcane arts are distrusted in hobgoblin society and consequently their practitioners are rare, save for alchemists, who gain grudging praise and admiration for their pyrotechnic talents.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##############################
    -- ######## RACE: IFRITS ########
    -- ##############################
    ["ifrits"] = (

        style('t1', "Ifrits") ..

        style('par') ..
        [[Ifrits are a race descended from mortals and the strange inhabitants of the Plane of Fire. Their physical traits and personalities often betray their fiery origins, and they tend to be restless, independent, and imperious. Frequently driven from cities for their ability to manipulate flame, ifrits make powerful fire sorcerers and warriors who can wield flame like no other race.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Ifrits are passionate and quick, but impetuous and destructive. They gain +2 Dexterity, +2 Charisma, and -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Ifrits are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Ifrits are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Ifrits have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Ifrits begin play speaking Common and Ignan. Ifrits with high Intelligence scores can choose from Aquan, Auran, Dwarven, Elven, Gnome, Halfling and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Energy Resistance: ") .. style('regular') ..
        [[Ifrits have fire resistance 5.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Ability (Sp): ") .. style('regular') ..
        [[Ifrits can use burning hands 1/day as a spell-like ability (caster level equals the ifrit's level; DC 11 + Charisma modifier).]] ..

        style('t3', "Fire Affinity: ") .. style('regular') ..
        [[Ifrit sorcerers with the elemental (fire) bloodline treat their Charisma score as 2 points higher for all sorcerer spells and class abilities. Ifrit spellcasters with the Fire domain use their domain powers and spells at +1 caster level.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Ifrits can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Humans whose ancestry includes beings of elemental fire such as efreet, ifrits are a passionate and fickle race. No ifrit is satisfied with a sedentary life; like a wildfire, ifrits must keep moving or burn away into nothingness. Ifrits not only adore flames, but personify multiple aspects of them as well, embodying both fire's dynamic, ever-changing energy and its destructive, pitiless nature.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Ifrits vary in appearance as widely as their elemental ancestors do. Most have pointy ears, red or mottled horns on the brow, and hair that flickers and waves as if it were aflame. Some possess skin the color of polished brass or have charcoal-hued scales covering their arms and legs. Ifrits favor revealing and ostentatious clothing in bright oranges and reds, preferably paired with gaudy jewelry.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Ifrits are most often born into human communities, and rarely form societies of their own. Those who grow up in a city are almost always imprisoned or driven off before they reach adulthood; most are simply too hot-headed and independent to fit into civilized society, and their predilection toward pyromania doesn't endear them to the local authorities. Those born into nomadic or tribal societies fare much better, since ifrits' instinctive urge to explore and conquer their surroundings can easily earn them a place among their tribe's leadership.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Even the best-natured ifrits tend to view other individuals as tools to use as they see fit, and as such they get along best with races they can charm or browbeat into submission. Half-elves and gnomes often find themselves caught up in an ifrit's schemes, while halflings, half-orcs, and dwarves usually bridle at ifrits' controlling nature. Strangely, ifrits sometimes form incredibly close bonds with elves, whose calm, aloof nature seems to counterbalance an ifrit's impulsiveness. Most ifrits refuse to associate with sylphs, but are otherwise on peaceable terms with the other elemental-touched races.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Ifrits are a dichotomous people — on one hand, fiercely independent, and on the other, imperious and demanding. They are often accused of being morally impoverished, but their troublemaking behavior is rarely motivated by true malice. Ifrits are usually lawful neutral or chaotic neutral, with a few falling into true neutrality. Most ifrits lack the mindset to follow a god's teachings, and resent the strictures placed on them by organized faith. When ifrits do take to worship (usually venerating a fire-related deity), they prove to be zealous and devoted followers.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Ifrits adventure for the sheer thrill of it and for the chance to test their skill against worthy foes, but most of all they adventure in search of power. Once ifrits dedicate themselves to a task, they pursue it unflinchingly, never stopping to consider the dangers ahead of them. When this brashness finally catches up with them, ifrits often rely on sorcery or bardic magic to combat their resulting troubles.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: KOBOLDS ########
    -- ###############################
    ["kobolds"] = (

        style('t1', "Kobolds") ..

        style('par') ..
        [[Considering themselves the scions of dragons, kobolds have diminutive statures but massive egos. A select few can take on more draconic traits than their kin, and many are powerful sorcerers, canny alchemists, and cunning rogues.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Kobolds are fast but weak. They gain +2 Dexterity, -4 Strength, and -2 Constitution.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Kobolds are humanoids with the reptilian subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Kobolds are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty on their combat maneuver checks and to Combat Maneuver Defense, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Kobolds have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Kobolds begin play speaking only Draconic. Kobolds with high Intelligence scores can choose from Common, Dwarven, Gnome, and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Armor: ") .. style('regular') ..
        [[Kobolds naturally scaly skin grants them a +1 natural armor bonus.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Crafty: ") .. style('regular') ..
        [[Kobolds gain a +2 racial bonus on Craft (trapmaking), Perception, and Profession (miner) checks. Craft (trapmaking) and Stealth are always class skills for a kobold.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Kobolds can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', "Light Sensitivity: ") .. style('regular') ..
        [[Kobolds lives in darkness have caused them to suffer from light sensitivity.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Kobolds are weak, craven, and seethe with a festering resentment for the rest of the world, especially members of races that seem stronger, smarter, or superior to them in any way. They proudly claim kinship to dragons, but beneath all the bluster, the comparison to their glorious cousins leaves kobolds with a profound sense of inadequacy. Though they are hardworking, clever, and blessed with a natural talent for mechanical devices and mining, they spend their days nursing grudges and hatreds instead of celebrating their own gifts. Kobold tactics specialize in traps and ambushes, but kobolds enjoy anything that allows them to harm others without putting themselves at risk. Often, they seek to capture rather than to kill, taking out their frustrations on the helpless victims they drag back to their claustrophobic lairs.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Kobolds are small, bipedal reptilian humanoids. Most stand around 3 feet tall and weigh about 35 pounds. They have powerful jaws for creatures of their size and noticeable claws on their hands and feet. Often kobolds' faces are curiously devoid of expression, as they favor showing their emotions by simply swishing their tails. Kobolds' thick hides vary in color, and most have scales that match the hue of one of the varieties of chromatic dragons, with red scales being predominant. A few kobolds, however, have more exotic colors such as orange or yellow, which in some tribes raises or lowers an individual's status in the eyes of his fellows.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Kobolds thrive in cramped quarters far from the light of the sun. Most live in vast warrens deep beneath the earth, but a few instead prefer to make their homes beneath tangles of overgrown trees and brush. Saving their malice for other races, most kobolds get along well with their own kind. While squabbles and feuds do occur, the elders who rule kobold communities tend to settle such conflicts swiftly. Kobolds delight in taking slaves, relishing the chance to torment and humiliate them. They are also cowardly and practical, and often end up bowing to more powerful beings. If these creatures are of another humanoid race, kobolds often scheme to free themselves from subjugation as soon as possible. If the overlord is a powerful draconic or monstrous creature, however, kobolds see no shame in submission, and often shower adoration on their new leader. This is especially true if the kobolds serve a true dragon, who they tend to worship outright.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Kobolds often seethe with hatred and jealousy, but their innate caution ensures that they only act on these impulses when they have the upper hand. If unable to safely indulge their urge to physically harm and degrade members of other races, they resort to careful insults and "practical jokes" instead. They consider both dwarves and elves to be deadly rivals. Kobolds fear the brute power of half-orcs and resent humans for the dominant status that race enjoys. They believe half-elves blend the best qualities of both parent races, which strikes kobolds as fundamentally unfair. Kobolds believe halflings, small in stature, make wonderful slaves and targets for kobold rage and practical jokes. When the gnomes first arrived in the mortal realm, kobolds saw them as perfect victims. This sparked waves of retaliation and reprisal that have echoed on down through the centuries and earned the kobolds' permanent enmity.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Kobolds readily knuckle under to superior force but rarely stop scheming to gain an edge over their oppressors. Most kobolds are lawful evil, though some, more concerned with procedure than their own personal advantage, become lawful neutral instead. Kobolds often pray to Asmodeus or other evil gods in hopes of bringing ruin to their foes or power to themselves. In addition to these deities, kobolds, supremely opportunistic, also sometimes worship nearby monsters as a way of placating them or earning their favor.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Kobolds rarely leave their cozy warrens by their own choice. Most of those who set out on adventures are the last of their tribe, and such individuals often settle down again as soon as they find another kobold community willing to take them in. Kobolds who cannot rein in, or at least conceal, their spiteful and malicious natures have great difficulty surviving in the larger world.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ############################
    -- ######## RACESE: ORCS ########
    -- ############################
    ["orcs"] = (

        style('t1', "Orcs") ..

        style('par') ..
        [[Savage, brutish, and hard to kill, orcs are often the scourge of far-flung wildernesses and cavern deeps. Many orcs become fearsome barbarians, as they are muscular and prone to bloody rages. Those few who can control their bloodlust make excellent adventurers.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Orcs are brutal and savage. They gain +4 Strength, -2 Intelligence, -2 Wisdom, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Orcs are humanoids with the orc subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Orcs are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Orcs have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Orcs begin play speaking Common and Orc. Orcs with high Intelligence scores can chose from Dwarven, Giant, Gnoll, Goblin and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Ferocity: ") .. style('regular') ..
        [[Orcs possess the ferocity ability which allows them to remain conscious and continue fighting even if their hit point totals fall below 0. Orcs are still staggered at 0 hit points or lower and lose 1 hit point each round as normal.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Orcs are always proficient with greataxes and falchions, and treat any weapon with the word "orc" in its name as a martial weapon.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Orcs can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', "Light Sensitivity: ") .. style('regular') ..
        [[Orcs are dazzled in areas of bright sunlight or within the radius of a daylight spell.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Orcs are aggressive, callous, and domineering. Bullies by nature, they respect strength and power as the highest virtues. On an almost instinctive level, orcs believe they are entitled to anything they want unless someone stronger can stop them from seizing it. They rarely exert themselves off the battlefield except when forced to do so; this attitude stems not just from laziness but also from an ingrained belief that work should trickle down through the pecking order until it falls upon the shoulders of the weak. They take slaves from other races, orc men brutalize orc women, and both abuse children and elders, on the grounds that anyone too feeble to fight back deserves little more than a life of suffering. Surrounded at all times by bitter enemies, orcs cultivate an attitude of indifference to pain, vicious tempers, and a fierce willingness to commit unspeakable acts of vengeance against anyone who dares to defy them.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Powerfully built, orcs typically stand just a few inches taller than most humans but have much greater muscle mass, their broad shoulders and thick, brawny hips often giving them a slightly lurching gait. They typically have dull green skin, coarse dark hair, beady red eyes, and protruding, tusk-like teeth. Orcs consider scars a mark of distinction and frequently use them as a form of body art.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Orcs usually live amid squalor and constant mayhem, and intimidation and brutal violence are the glue that holds orc culture together. They settle disputes by making increasingly grisly threats until, when a rival fails to back down, the conflict escalates into actual bloodshed. Orcs who win these ferocious brawls not only feel free to take whatever they want from the loser, but also frequently indulge in humiliating physical violation, casual mutilation, and even outright murder. Orcs rarely spend much time improving their homes or belongings since doing so merely encourages a stronger orc to seize them. In fact, whenever possible, they prefer to occupy buildings and communities originally built by other races.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Orcs admire strength above all things. Even members of enemy races can sometimes win an orc's grudging respect, or at least tolerance, if they break his nose enough times.]] ..
        style('par') ..
        [[rcs regard dwarves and elves with an odd mix of fierce hatred, sullen resentment, and a trace of wariness. They respect power, and, on some level, understand that these two races have kept them at bay for countless ages. Though they never miss a chance to torment a dwarf or elf who falls into their clutches, they tend to proceed cautiously unless certain of victory. Orcs dismiss halflings and gnomes as weaklings barely worth the trouble of enslaving. They often regard half-elves, who appear less threatening than full-blooded elves but have many elven features, as particularly appealing targets. Orcs view humans as race of sheep with a few wolves living in their midst. They freely kill or oppress humans too weak to fend them off but always keep one eye on the nearest exit in case they run into a formidable human.]] ..
        style('par') ..
        [[rcs look upon half-orcs with a strange mixture of contempt, envy, and pride. Though weaker than typical orcs, these half-breeds are also usually smarter, more cunning, and better leaders. Tribes led, or at least advised, by half-orcs are often more successful than those led by pure-blooded orcs. On a more fundamental level, orcs believe each half-orc also represents an orc exerting dominance over a weaker race.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Orcs have few redeeming qualities. Most are violent, cruel, and selfish. Concepts such as honor or loyalty usually strike them as odd character flaws that tend to afflict members of the weaker races. Orcs are typically not just evil, but chaotic to boot, though those with greater self-control may gravitate toward lawful evil. Orcs pray to gods of fire, war, and blood, often creating tribal "pantheons" by combining these aspects into uniquely orc concepts.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Orcs usually leave their tribes only after losing out in a power struggle. Facing humiliation, slavery, or even death at the hands of their own kind, they opt instead to live and work with members of other races. Orcs who fail to rein in their tempers and the instinctive drive to dominate rarely last long once they strike out on their own. Though orcs who do manage to get by in other societies often enjoy the luxuries and comforts these societies can deliver, they still tend to dream of returning home, seizing power, and taking revenge.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##############################
    -- ######## RACE: OREADS ########
    -- ##############################
    ["oreads"] = (

        style('t1', "Oreads") ..

        style('par') ..
        [[Creatures of human ancestry mixed with the blood of creatures from the Plane of Earth, oreads are as strong and solid as stone. Often stubborn and steadfast, their unyielding nature makes it hard for them to get along with most races other than dwarves. Oreads make excellent warriors and sorcerers who can manipulate the raw power of stone and earth.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Oreads are strong, solid, stable, and stoic. They gain +2 Strength, +2 Wisdom, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Oreads are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Oreads are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Speed (Slow): ") .. style('regular') ..
        [[Oreads have a base speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Oreads begin play speaking Common and Terran. Oreads with high Intelligence scores can choose from Aquan, Auran, Dwarven, Elven, Gnome, Halfling, Ignan and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Energy Resistance: ") .. style('regular') ..
        [[Oreads have acid resistance 5.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Abilities: ") .. style('regular') ..
        [[Oread can use magic stone 1/day (caster level equals the oread's total level; DC 11 + Charisma modifier).]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Oreads can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Earth Affinity: ") .. style('regular') ..
        [[Oread sorcerers with the elemental (earth) bloodline treat their Charisma score as 2 points higher for all sorcerer spells and class abilities. Oread clerics with the Earth domain use their domain powers and spells at +1 caster level.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Oreads are humans whose ancestry includes the touch of an elemental being of earth somewhere along the line, often that of a shaitan genie. Stoic and contemplative, oreads are a race not easily moved, yet almost unstoppable when spurred to action. They remain a mystery to most of the world thanks to their reclusive nature, but those who seek them out in their secluded mountain hideaways find oreads to be quiet, dependable, and protective of their friends.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Oreads are strong and solidly built, with skin and hair colored stony shades of black, brown, gray, or white. While all oreads appear vaguely earthy, a few bear more pronounced signs of their elemental heritage — skin that shines like polished onyx, rocky outcroppings protruding from their flesh, glowing gemstones for eyes, or hair like crystalline spikes. They often dress in earthy tones, wearing practical clothing well suited to vigorous physical activity and preferring fresh flowers, simple gemstones, and other natural accents to complex manufactured jewelry.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[As a minor offshoot of the human race, oreads have no real established society of their own. Instead, most oreads grow up in human communities learning the customs of their parents. Adult oreads have a well-deserved reputation among other races for being hermits and loners. Few take well to the bustle of city life, preferring instead to spend their days in quiet contemplation atop some remote mountain peak or deep below the earth in a secluded cavern. Oreads with a greater tolerance for life among humans often join the city watch, or find some other way to serve their community in a position of responsibility.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Oreads feel comfortable in the company of dwarves, with whom they have much in common. They find gnomes too strange and many halflings far too brash, and so avoid these races in general. Oreads gladly associate with half-orcs and half-elves, feeling a sense of kinship with the other part-human races despite inevitable personality conflicts. Among the elemental-touched races, oreads have few friends but no true enemies.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Oreads are, perhaps above all else, set in their ways, and any disruption of their routine is met with quiet disapproval. Oreads are fiercely protective of their friends, but don't seem particularly concerned with the well-being of those outside their small circle of acquaintances. As such, most oreads are lawful neutral. Religious life comes easily to the earth-touched. They appreciate the quiet, contemplative life of the monastic order, and most dedicate themselves to the worship of earth or nature-related deities.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Oreads are initially hesitant adventurers. They dislike leaving their homes and don't handle the shock of new experiences well. Usually it takes some outside force to rouse oreads into action, often by threatening their homes, lives, or friends. Once the initial threat is dealt with, however, oreads often find they've grown accustomed to the adventuring life, and continue to pursue it through the rest of their days. Oreads make good monks and fighters thanks to their prodigious strength and self-discipline.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: RATFOLK ########
    -- ###############################
    ["ratfolk"] = (

        style('t1', "Ratfolk") ..

        style('par') ..
        [[These small, ratlike humanoids are clannish and nomadic masters of trade. Often tinkers and traders, they are more concerned with accumulating interesting trinkets than amassing wealth. Ratfolk often adventure to find new and interesting curiosities rather than coin.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Ratfolk are agile and clever, yet physically weak. They gain +2 Dexterity, +2 Intelligence, and -2 Strength.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Ratfolk are humanoids with the ratfolk subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Ratfolk are Small and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty on combat maneuver checks and to their CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Speed (Slow): ") .. style('regular') ..
        [[Ratfolk have a base speed of 20 ft.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Ratfolk begin play speaking Common. Ratfolk with high Intelligence scores can choose from Aklo, Draconic, Dwarven, Gnoll, Gnome, Goblin, Halfling, Orc and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Tinker: ") .. style('regular') ..
        [[Ratfolk gain a +2 racial bonus on Craft (alchemy), Perception, and Use Magic Device checks.]] ..

        style('t3', "Rodent Empathy: ") .. style('regular') ..
        [[Ratfolk gain a +4 racial bonus on Handle Animal checks made to influence rodents.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Swarming: ") .. style('regular') ..
        [[Ratfolk are used to living and fighting communally, and are adept at swarming foes for their own gain and their foes' detriment. Up to two ratfolk can share the same square at the same time. If two ratfolk in the same square attack the same foe, they are considered to be flanking that foe as if they were in two opposite squares.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Ratfolk can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Ratfolk are small, rodent-like humanoids; originally native to subterranean areas in dry deserts and plains, they are now more often found in nomadic trading caravans. Much like the pack rats they resemble, ratfolk are tinkerers and hoarders by nature, and as a whole are masters of commerce, especially when it comes to acquiring and repairing mechanical or magical devices. Though some are shrewd merchants who carefully navigate the shifting alliances of black markets and bazaars, many ratfolk love their stockpiles of interesting items far more than money, and would rather trade for more such prizes to add to their hoards over mere coins. It's common to see a successful crew of ratfolk traders rolling out of town with an even larger bundle than they entered with, the whole mess piled precariously high on a cart drawn by giant rats.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Typical ratfolk are average 4 feet tall and weigh 80 pounds. They often wear robes to stay cool in the desert or conceal their forms in cities, as they know other humanoids find their rodent features distasteful. Ratfolk have a strong attraction to shiny jewelry, especially copper, bronze, and gold, and many decorate their ears and tails with small rings made of such metals. They are known to train giant rats (dire rats with the giant creature simple template), which they often use as pack animals and mounts.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Ratfolk are extremely communal, and live in large warrens with plenty of hidden crannies in which to stash their hoards or flee in times of danger, gravitating toward subterranean tunnels or tightly packed tenements in city slums. They feel an intense bond with their large families and kin networks, as well as with ordinary rodents of all sorts, living in chaotic harmony and fighting fiercely to defend each other when threatened. They are quick to use their stockpiles of gear in combat, but prefer to work out differences and settle disputes with mutually beneficial trades.]] ..
        style('par') ..
        [[When a specific ratfolk warren grows overcrowded and the surrounding environment won't support a larger community, young ratfolk instinctively seek out new places in which to dwell. If a large enough group of ratfolk immigrants all settle down in a new, fertile area, they may create a new warren, often with strong political ties to their original homeland. Otherwise, individual ratfolk are inclined to simply leave home and take up residence elsewhere, or wander on caravan trips that last most of the year, reducing the pressure of overcrowding at home.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Ratfolk tend to get along quite well with humans, and often develop ratfolk societies dwelling in the sewers, alleys, and shadows of human cities. Ratfolk find dwarves too hidebound and territorial, and often mistake even mild criticisms from dwarves as personal attacks. Ratfolk have no particular feelings about gnomes and halflings, although in areas where those races and ratfolk must compete for resources, clan warfare can become dogma for generations. Ratfolk enjoy the company of elves and half-elves, often seeing them as the calmest and most sane of the civilized humanoid races. Ratfolk are particularly fond of elven music and art, and many ratfolk warrens are decorated with elven art pieces acquired through generations of friendly trade.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Ratfolk individuals are driven by a desire to acquire interesting items and a compulsion to tinker with complex objects. The strong ties of ratfolk communities give them an appreciation for the benefits of an orderly society, even if they are willing to bend those rules when excited about accomplishing their individual goals. Most ratfolk are neutral, and those who take to religion tend to worship deities that represent commerce and family.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Ratfolk are often driven by a desire to seek out new opportunities for trade, both for themselves and for their warrens. Ratfolk adventurers may seek potential markets for their clan's goods, keep an eye out for sources of new commodities, or just wander about in hopes of unearthing enough treasure to fund less dangerous business ventures. Ratfolk battles are often decided by cunning traps, ambushes, or sabotage of enemy positions, and accordingly young ratfolk heroes often take up classes such as alchemist, gunslinger, and rogue.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ##############################
    -- ######## RACE: SYLPHS ########
    -- ##############################
    ["sylphs"] = (

        style('t1', "Sylphs") ..

        style('par') ..
        [[Ethereal folk of elemental air, sylphs are the result of human blood mixed with that of airy elemental folk. Like ifrits, oreads, and undines, they can become powerful elemental sorcerers with command over their particular elemental dominion. They tend to be beautiful and lithe, and have a knack for eavesdropping.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Sylphs are quick and insightful, but slight and delicate. They gain +2 Dexterity, +2 Intelligence, and -2 Constitution.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Sylphs are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Sylphs are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Speed: ") .. style('regular') ..
        [[Sylphs have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Sylphs begin play speaking Common and Auran. Sylphs with high Intelligence scores can choose from Aquan, Dwarven, Elven, Gnome, Halfling, Ignan and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Energy Resistance: ") .. style('regular') ..
        [[Sylphs have electricity resistance 5.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Ability: ") .. style('regular') ..
        [[Sylphs can use feather fall 1/day (caster level equals the sylph's total level).]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Sylphs can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Air Affinity: ") .. style('regular') ..
        [[Sylph sorcerers with the elemental (air) bloodline treat their Charisma score as 2 points higher for all sorcerer spells and class abilities. Sylph spellcasters with the Air domain use their domain powers and spells at +1 caster level.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Born from the descendants of humans and beings of elemental air such as djinn, sylphs are a shy and reclusive race consumed by intense curiosity. Sylphs spend their lives blending into the crowd, remaining unnoticed as they spy and eavesdrop on the people around them. They call this hobby “listening to the wind,” and for many sylphs it becomes an obsession. Sylphs rely on their capable, calculating intellects and on knowledge gleaned from eavesdropping to deliver them from danger.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Sylphs tend to be pale and thin to the point of appearing delicate, but their skinny bodies are often more resilient than they look. Many sylphs can easily pass for humans with some effort, though the complex blue markings that swirl across their skin reveal their elemental ancestry. Sylphs also bear more subtle signs of their heritage, such as a slight breeze following them wherever they go. These signs become more pronounced as a Sylph experiences intense passion or anger, spontaneous gusts of wind tousling the sylph's hair or hot blusters knocking small items off of shelves.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Sylphs are usually born to human parents, and so are raised according to human customs. Most sylphs dislike the attention they receive growing up in human society, so it's common for them to leave home soon after coming of age. They rarely abandon civilization altogether, however, preferring instead to find some new city or settlement where they can go unnoticed among (and spy upon) the masses. A Sylph who happens upon another Sylph unnoticed instantly becomes obsessed with her kin, spying on and learning as much about the other as she possibly can. Only after weighing all the pros and cons and formulating plans for every potential outcome will the Sylph introduce herself to the other. Rarely, two sylphs will discover each other's presence in a community at the same time. What ensues thereafter is a sort of cat-and-mouse game, a convoluted dance in which each sylph spies on the other as both attempt to gain the upper hand. Sylphs who meet this way always become either inseparable friends or intractable enemies.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Sylphs enjoy prying into the affairs of most other races, but have little taste for actually associating with most of them. Sylphs can relate on some level with elves, who share their tendency toward aloofness, but often spoil any possible relationship by violating the elven sense of privacy. Dwarves distrust sylphs intensely, considering them flighty and unreliable. They form excellent partnerships with halflings, relying on the short folk's courage and people skills to cover their own shortcomings. Sylphs are amused by the annoyed reactions they provoke in ifrits, and find oreads too boring to give them much attention.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Sylphs have little regard for laws and traditions, for such strictures often prohibit the very things sylphs love-subterfuge and secrecy. This doesn't mean sylphs are opposed to law, merely that they use the most expedient means available to accomplish their goals, legal or not. Most sylphs are thus neutrally aligned. Sylphs are naturally drawn to mystery cults, and to deities who focus on secrets, travel, or knowledge.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[An inborn urge to get to the bottom of things drives many sylphs to the adventuring life. A Sylph who runs across the trail of a mystery will never be satisfied until she has uncovered every thread of evidence, followed up on every lead, and found the very heart of the trouble. Such sylphs make plenty of enemies by poking around into other peoples' affairs, and usually turn to their roguish talents or wizardry to defend themselves.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- #############################
    -- ######## RACE: TENGU ########
    -- #############################
    ["tengu"] = (

        style('t1', "Tengu") ..

        style('par') ..
        [[These crow-like humanoid scavengers excel in mimicry and swordplay. Flocking into densely populated cities, tengus occasionally join adventuring groups out of curiosity or necessity. Their impulsive nature and strange habits can often be unnerving to those who are not used to them.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Tengus are fast and observant, but relatively fragile and delicate. They gain +2 Dexterity, +2 Wisdom, -2 Constitution.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Tengus are humanoids with the tengu subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Tengus are Medium creatures and receive no bonuses or penalties due to their size.]] ..

        style('t3', "Speed: ") .. style('regular') ..
        [[Tengus have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Tengus begin play speaking Common and Tengu. Tengus with high Intelligence scores can choose any languages they want (except for secret languages, such as Druidic). See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Sneaky: ") .. style('regular') ..
        [[Tengus gain a +2 racial bonus on Perception and Stealth checks.]] ..

        style('t3', "Gifted Linguist: ") .. style('regular') ..
        [[Tengus gain a +4 racial bonus on Linguistics checks, and learn 2 languages each time they gain a rank in Linguistics rather than 1 language.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Swordtrained: ") .. style('regular') ..
        [[Tengus are trained from birth in swordplay, and as a result are automatically proficient with sword-like weapons (including bastard swords, daggers, elven curve blades, falchions, greatswords, kukris, longswords, punching daggers, rapiers, scimitars, short swords, and two-bladed swords).]] ..

        style('t3', "Natural Weapons: ") .. style('regular') ..
        [[A tengu has a bite attack that deals 1d3 points of damage.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Senses: ") .. style('regular') ..
        [[Tengus have low-light vision allowing them to see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The crow-like tengus are known as a race of scavengers and irrepressible thieves. Covetous creatures predominantly motivated by greed, they are vain and easily won over with flattery. Deceptive, duplicitous, and cunning, tengus seek circumstances in which they can take advantage of the situation, often at the expense of others, including their own kind. They can be highly competitive, but impulsive and rash. Some claim their behavior is innate, while others believe their selfish mannerisms are cultural and developed as a learned adaptation that has enabled their people to endure through centuries of oppression.]] ..
        style('par') ..
        [[Tengus are natural survivalists. For many, only theft and guile have afforded them the temporary luxuries other races take for granted. In the past, both humans and powerful races such as giants sought the bird-folk as slaves and servitors. Many tengus scavenged for survival, scraping for food in the shadows of cities or living as subsistence hunters and gatherers in the wild. Their descendants now struggle to find their place in contemporary society, often competing against negative stereotypes or driven to embrace them, and they rely on thievery and swordplay to get by in a harsh and unforgiving world.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Tengus are avian humanoids whose features strongly resemble crows. They have broad beaks and both their arms and their legs end in powerful talons. Though tengus are unable to fly, iridescent feathers cover their bodies — this plumage is usually black, though occasionally brown or blue-back. Their skin, talons, beaks, and eyes are similarly colored, and most non-tengus have great difficulty telling individuals apart. Tengus who wish to be more easily identified by other humanoids may bleach certain feathers or decorate their beaks with dyes, paint, or tiny glued ornaments. Though they are about the same height as humans, they have slight builds and tend to hunch over. A tengu's eyes sit slightly back and to the sides of his head, giving him binocular vision with a slightly more panoramic field of view than other humanoids. Like many avians, tengus have hollow bones and reproduce by laying eggs.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Tengus live in close-knit communities in which they keep to themselves. In urban centers, they tend to group in communal slums, while those living in rural areas establish isolated settlements. Overall, they remain secretive about their culture, which is a combination of old traditions laced with newer bits of culture scavenged from the races common in the neighboring regions. Cultural scavenging also extends to language, and regional dialects of Tengu are peppered with terms and colloquialisms from other languages. Unsurprisingly, tengus have a knack for language and pick up new ones quickly.]] ..
        style('par') ..
        [[Most tengu communities tend to follow a tribal structure. Tribal rules remain loose and subjective, and tribe members settle any conflicts through public arbitration (and occasionally personal combat). While every tengu has a voice in her society, in most settlements, tengus still defer to their revered elders for wisdom and advice.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Few races easily tolerate tengus. Of the most common races, only humans allow them to settle within their cities with any regularity. When this occurs, tengus inevitably form their own ghettos and ramshackle communities, typically in the most wretched neighborhoods. Regardless of their tolerance, most humans maintain as little contact with tengus as possible. Tengus occasionally make friends with halflings and gnomes, but only when they share mutual interests. Conversely, most dwarves have no patience for tengus whatsoever. Other races tend to view tengus in a similar fashion to humans, though many actively discourage them from settling in their realms.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Tengus tend to be neutral, though those who allow their impulsiveness to get the better of them lean toward chaotic neutral. Religious beliefs vary from tribe to tribe; some worship the traditional tengu gods (most of which are aspects of better-known deities), while others take to the worship of human gods or celestial spirits. Tengus can be fickle with regard to their patrons, quickly abandoning religious customs when they cease to provide any tangible benefit. Many embrace polytheism, picking and choosing to uphold the tenets of whatever deities best suit them at the time.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[With little at home to leave behind, many tengus turn to a life of adventure seeking fame, fortune, and glory. A common tengu belief portrays a life on the road as a series of experiences and trials that form a path to enlightenment. Some take this to mean a path of spiritual empowerment; others view it as a way to perfect their arts or swordsmanship. Perhaps in spite of the prejudices upheld by outsiders, many tengu adventurers embrace their stereotypes. These individuals seek to succeed by epitomizing tengu racial qualities, and proudly flaunt their heritage. Despite their avian frailty, with their quick reflexes and quicker wits, tengus make excellent rogues and rangers, while those with a strong connection to the spirit world often become oracles. Those disciplined in the practice of martial arts take jobs as mercenaries and bodyguards in order to profit from their talents.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- #################################
    -- ######## RACE: TIEFLINGS ########
    -- #################################
    ["tieflings"] = (

        style('t1', "Tieflings") ..

        style('par') ..
        [[Diverse and often despised by humanoid society, tieflings are mortals stained with the blood of fiends. Other races rarely trust them, and this lack of empathy usually causes tieflings to embrace the evil, depravity, and rage that seethe within their corrupt blood. A select few see the struggle to smother such dark desires as motivation for grand heroism.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Tieflings are quick in body and mind, but are inherently strange and unnerving. They gain +2 Dexterity, +2 Intelligence, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Tieflings are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Tieflings are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Speed: ") .. style('regular') ..
        [[Tieflings have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Tieflings begin play speaking Common and either Abyssal or Infernal. Tieflings with high intelligence scores can choose from Abyssal, Draconic, Dwarven, Elven, Gnome, Goblin, Halfling, Infernal and Orc languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Fiendish Resistance: ") .. style('regular') ..
        [[Tieflings have cold resistance 5, electricity resistance 5, and fire resistance 5.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Skilled: ") .. style('regular') ..
        [[Tieflings gain a +2 racial bonus on Bluff and Stealth checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-like ability: ") .. style('regular') ..
        [[Tieflings can use darkness once per day as a spell-like ability. The caster level for this ability equals the tiefling's class level.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Tieflings can see perfectly in the dark for up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Fiendish Sorcery: ") .. style('regular') ..
        [[Tiefling sorcerers with the Abyssal or Infernal bloodlines treat their Charisma score as 2 points higher for all sorcerer class abilities.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Simultaneously more and less than mortal, tieflings are the offspring of humans and fiends. With otherworldly blood and traits to match, tieflings are often shunned and despised out of reactionary fear. Most tieflings never know their fiendish sire, as the coupling that produced their curse occurred generations earlier. The taint is long-lasting and persistent, often manifesting at birth or sometimes later in life, as a powerful, though often unwanted, boon. Despite their fiendish appearance and netherworld origins, tieflings have a human's capacity of choosing their fate, and while many embrace their dark heritage and side with fiendish powers, others reject their darker predilections. Though the power of their blood calls nearly every tiefling to fury, destruction, and wrath, even the spawn of a succubus can become a saint and the grandchild of a pit fiend an unsuspecting hero.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[No two tieflings look alike; the fiendish blood running through their veins manifests inconsistently, granting them an array of fiendish traits. One tiefling might appear as a human with small horns, a barbed tail, and oddly colored eyes, while another might manifest a mouth of fangs, tiny wings, and claws, and yet another might possess the perpetual smell of blood, foul incenses, and brimstone. Typically, these qualities hearken back in some way to the manner of fiend that spawned the tiefling's bloodline, but even then the admixture of human and fiendish blood is rarely ruled by sane, mortal laws, and the vast flexibility it produces in tieflings is a thing of wonder, running the gamut from oddly beautiful to utterly terrible.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Tieflings on the Material Plane rarely create their own settlements and holdings. Instead, they live on the fringes of the land where they were born or choose to settle. Most societies view tieflings as aberrations or curses, but in cultures where there are frequent interactions with summoned fiends, and especially where the worship of demons, devils, or other evil outsiders is legal or obligatory, tieflings might be much more populous and accepted, even cherished as blessings of their fiendish overlords. Tieflings seldom see another of their own kind, and thus they usually simply adopt the culture and mannerisms of their human parents. On other planes, tieflings form enclaves of their own kind. But often such enclaves are less than harmonious — the diversity of tiefling forms and philosophies is an inherent source of conflict between members of the race, and cliques and factions constantly form in an ever-shifting hierarchy where only the most opportunistic or devious gain advantage. Only those of common bloodlines or those who manage to divorce their worldview from the inherently selfish, devious, and evil nature of their birth manage to find true acceptance, camaraderie, and common ground among others of their kind.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Tieflings face a significant amount of prejudice from most other races, who view them as fiend-spawn, seeds of evil, monsters, and lingering curses placed upon the world. Far too often, civilized races shun or marginalize them, while more monstrous ones simply fear and reject them unless forced or cowed into acceptance. But half-elves, half-orcs, fetchlings and — most oddly — aasimars tend to view them as kindred spirits who are too often rejected or who don't fit into most societies by virtue of their birth. The widespread assumption that tieflings are innately evil — ill-founded though it may be — prevents many from easily fitting into most cultures on the Material Plane except in exceedingly cosmopolitan or planar-influenced nations.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Despite their fiendish heritage and the insidious influence of prejudice, tieflings can be of any alignment. Many of them fall prey to the dark desires that haunt their psyches, and give in to the seduction of the whispering evil within, yet others steadfastly reject their origins and actively fight against evil lures and the negative assumptions they face from others by performing acts of good. Most, however, strive to simply find their own way in the world, though they tend to adopt a very amoral, neutral view when they do. Though many creatures just assume that tieflings worship devils and demons, their religious views are as varied as their physical forms. Individual tieflings worship all manner of deities, but they are just as likely to shun religion all together. Those who give in to the dark whispers that haunt the psyche of all tieflings serve all manner of powerful fiends.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Tieflings rarely integrate into the mortal societies they call home. Drawn to the adventuring life as a method of escape, they hope to make a better life for themselves, to prove their freedom from their blood's taint, or to punish a world that fears and rejects them. Tieflings make skilled rogues, powerful wizards and magi, and especially puissant sorcerers as their potent blood empowers them. Those who succumb to the evil within often become powerful clerics of fiendish powers.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###############################
    -- ######## RACE: UNDINES ########
    -- ###############################
    ["undines"] = (

        style('t1', "Undines") ..

        style('par') ..
        [[Like their cousins, the ifrits, oreads, and sylphs, undines are humans touched by planar elements. They are the scions of elemental water, equally graceful both on land and in water. Undines are adaptable and resistant to cold, and have an affinity for water magic.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Undines are both perceptive and agile, but tend to adapt rather than match force with force. They gain +2 Dexterity, +2 Wisdom, and -2 Strength.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Undines are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Undines are Medium creatures and thus receive no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Undines have a base speed of 30 feet on land. They also have a swim speed of 30 feet, can move in water without making Swim checks, and always treat Swim as a class skill.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Undines begin play speaking Common and Aquan. Undines with high Intelligence scores can choose from Auran, Dwarven, Elven, Gnome, Halfling, Ignan and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Energy Resistance: ") .. style('regular') ..
        [[Undines have cold resistance 5.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Spell-Like Ability (Sp): ") .. style('regular') ..
        [[Undines can use hydraulic push 1/day (caster level equals the undine's level).]] ..

        style('t3', "Water Affinity: ") .. style('regular') ..
        [[undine sorcerers with the elemental (water) bloodline treat their Charisma score as 2 points higher for all sorcerer spells and class abilities. undine clerics with the Water domain cast their Water domain powers and spells at +1 caster level.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Undines can see perfectly in the dark up to 60 feet.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Undines are humans who trace their ancestry to creatures from the Plane of Water. Even at first glance, one notices the potency of their ancestry, for an undine's very flesh mimics the color of lakes, seas, and oceans. Whether they have the blood of marids or water mephits as their kin, all undines define themselves through their ancestry. They perceive their individual differences as gifts and explore the supernatural aspects of their unique heritage to the fullest.]] ..
        style('par') ..
        [[The undines are a proud race and show little outward fear. While good-natured and somewhat playful among their own kind, they behave with slightly more reserve and seriousness in the company of non-undines. They have excellent emotional control, and can edge their tempers from calm to raging and back again within but a few minutes. While some might dub their behavior erratic, undines are simply a bit more outwardly melodramatic than most races. Certainly, they are not moody and do not become angered, excited, or otherwise emotional without provocation. As close friends, some find them overly possessive, though they are also extremely protective of those they care about.]] ..
        style('par') ..
        [[Undines tend to settle near water, usually in warmer climates. Though land-dwellers, they spend a fair amount of time in the water. For this reason, most dress sparsely, wearing only enough clothing to protect themselves from the elements, and few wear shoes. They avoid wearing jewelry around their necks and keep their hair slicked back and tied into tight knots. This prevents hair or other objects from becoming a distraction or hindrance while swimming. Similarly, undines pursuing martial classes choose weapons that they can wield efficiently on land as well as in water.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Undines display a wide variation of skin tones, ranging from pale turquoise to deep blue to sea green. An undine's straight, thick hair tends to be of a similar, yet slightly darker color than her skin. All have limpid blue eyes. Physically, undines most resemble humans, and their physiques show human diversity in regard to overall height and body type. Aside from their coloration, their most racially defining traits remain their fin-like ears and webbed hands and feet.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Undines define themselves as a unique race and are capable of producing undine offspring. While they remain able to interbreed with humans, they tend to keep to themselves, and form small, reclusive communities near bodies of water, or in some cases, floating settlements. A typical undine community lives under the guidance of a small council comprising officials appointed by consensus. Council positions can be held indefinitely, though a community unhappy with the performance of a council member can call for her resignation.]] ..

        style('par') ..
        [[Intermarriage in undine communities is common, with children raised communally. A fair amount of regional diversity exists in undine culture, as influenced by the specific ancestry of independent settlements. It should also be noted that not all undine in a single settlement claim the same ancestry, as undines may marry other undines from outside their own communities.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Undines hold no biases or prejudices toward any particular races. Their communities rely primarily on trade, giving them ample opportunity to interact with a diverse range of outsiders and foreigners. They have no qualms about establishing neighborhoods within the settlements of other races, provided adequate respect is given to both the undines and any nearby bodies of water. Still, in such instances, a given undine community does what it can to retain its autonomy.]] ..

        style('par') ..
        [[Undines get along quite well with elves and gnomes. Often these races share protective duties over forested lakes and streams. Similarly, they interact favorably with good or neutral aquatic humanoids, sharing many common interests. They barter most freely with humans and dwarves for resources such as metal and cloth.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Most undines are neutral. Their principle interests lie in the welfare of their people, and thus their moral concerns focus upon the community and upon themselves. This neutral view also allows them to interact with a broad scope of non-undine races with whom they trade. While not deeply religious, undines possess a strong spiritual connection to both their supernatural ancestors and to water itself. Those who pursue nonsecular paths almost always worship the gods of their ancestors or gods whose portfolios feature some aspect of water.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[On occasion, an undine leaves her people to seek out a life of adventure. Like water itself, some undines simply feel compelled to move, and adventuring gives them an ample excuse for living on the road. Others adventure for less wholesome reasons, and exile is a common punishment for crimes within undine society. With few other options, most exiles turn to adventuring hoping to find a new place in the world. Undines' affinity toward water makes them particularly good druids, while undine sorcerers usually have aquatic bloodlines.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ###################################
    -- ######## RACE: CHANGELINGS ########
    -- ###################################
    ["changelings"] = (

        style('t1', "Changelings") ..

        style('par') ..
        [[The offspring of hags and their mortal lovers, changelings are abandoned and raised by foster parents. Always female, changelings all hear a spiritual call during puberty to find their true origins. Tall and slender, with dark hair and eyes mismatched in color, changelings are eerily attractive.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Changelings are frail, but are clever and comely. They gain +2 Wisdom, +2 Charisma, -2 Constitution.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Changelings are Medium creatures and have no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Changelings are humanoids with the changeling subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Changelings have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Changelings begin play speaking Common and the primary language of their host society. Changelings with high Intelligence scores can choose from Aklo, Draconic, Dwarven, Elven, Giant, Gnoll, Goblin and Orc languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Natural Armor: ") .. style('regular') ..
        [[Changelings have a +1 natural armor bonus.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Claws: ") .. style('regular') ..
        [[Changelings' fingernails are hard and sharp, granting them two claw attacks (1d4 points of damage each).]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Changelings see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('par') ..
        [[A changeling inherits one of the following racial traits, depending on her mother's hag type.]] ..

        style('t3', "Hulking Changeling (Annis Hag): ") .. style('regular') ..
        [[The changeling gains a +1 racial bonus on melee damage.]] ..

        style('t3', "Green Widow (Green Hag): ") .. style('regular') ..
        [[The changeling gains a +2 racial bonus on Bluff checks against creatures that are sexually attracted to her.]] ..

        style('t3', "Sea Lungs (Sea Hag): ") .. style('regular') ..
        [[The changeling may hold her breath for a number of rounds equal to three times her Constitution before she risks drowning.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[A race of foundlings, isolated from one another and often unaware of their heritage, changelings are the offspring of hags and mortal fathers. Hags are able to produce children with fathers of nearly any race, but as unyielding fonts of supernatural  hate,  they  make  miserable  parents.  Their scant maternal instincts extend only far enough to prompt them  to  abandon  their  children  on  welcoming-looking doorsteps  rather  than  killing  them.  As  a  result,  most changelings  attribute  their  odd  behavior  and  outsider status  to  the  fact  that  they  are  orphans  and  somehow broken  inside,  rather  than  to  the  seeds  of  potent  magic that lie dormant within them.]] ..
        style('par') ..
        [[A  changeling  hews  close  enough  to  her  father’s  race that  she  rarely  suspects  anything  is  odd  about  her origins.  Even  so,  most  humanoids  recognize  some unnatural taint in the awkward, sickly children who grow into women of great beauty and grace. By the time  a  changeling’s  arcane  powers begin  to  develop,  her  community has either embraced the foundling as  a  quirky  treasure  or  shunned her. Her treatment at others’ hands plays a large role in whether, when her true mother comes calling, the changeling  resists  her  mother’s fell  inf luence  or  embraces  her destiny as a hag.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Hags bear only girls. Most changelings have human fathers, and so closely resemble their fathers that a changeling can grow up alongside human siblings with few suspecting the changeling has a different mother. Changelings of elven, dwarven, and even goblin blood blend in just as well with their father's races. At puberty, however, real distinctions begin to emerge as the young women become unusually tall and graceful, their fingernails harden into claws, and their eyes begin to be able to pick out distinct forms in the shadows. Even then, a changeling is nearly indistinguishable from members of her father's race, and she can live, marry, and raise children among them, if she wishes.]] ..
        style('par') ..
        [[Yet changelings are infused with twisted, inhuman magic. Though many learn to control this power and become potent witches or sorcerers, it allows their mothers to subject them to brutal transformative rituals. The hags torture the changelings spirits and scourge their flesh until hatred and sorrow kindle those magical embers into a blinding flame. The process transforms a changeling into a new hag as she sheds her old skin, life, and personality to become a creature of primeval cruelty.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Though seemingly designed to fit in perfectly among the societies into which their hag mothers insert them, changelings possess uncanny awareness and unusual ways of looking at the world. This perspective and unsettling insight can turn them into outcasts whose exclusion is not acknowledged as such. They are rarely overtly shunned, but their families and neighbors usually find them eerie and discomfiting despite their beauty.For this reason, people tend not to form close bonds with changelings. Most changelings journey toward adulthood with a growing awareness that something is wrong with them, but they are unable to identify what it is or how to fix it. Instead, growing frustration mixed with grief often builds within their hearts. As changelings begin to come into their power, these feelings might harden into resentment of those who subtly reject them but refuse to explain their reasoning. Alternatively, changelings' feelings might turn into a deep insecurity and desperation for approval and love — emotions that their hag mothers gleefully exploit when coming to claim them.]] ..
        style('par') ..
        [[Apart from the vague but persistent sense of not belonging and their talent for magic, changelings ref lect the society that raised them. The only constant in changelings' experience is "the call," a psychic cry that beckons a daughter to leave home and venture into the world. Most changelings believe they hear destiny beckoning, but in reality hags initiate the call to lure their children back to them. Those who resist the siren song long enough eventually stop hearing it, and blissfully, might never learn the truth of their origins. Those who follow the honeyed whispers in their head finally meet their mothers and are abducted for the grisly process of transformation into the next step of the hag life cycle. Hags must form a coven to call their children, and the groups often summon three or more daughters at a time. These horrifying family reunions are often the first time each summoned offspring has laid eyes on another changeling.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Changelings' attitudes toward others mirror those of their parent race, but their outsider status colors them. Most live as objects of both jealousy or ire, desired for their beauty and feared for their magic. They might get along well with members of other common humanoid races, but they usually find the company of their foster families and communities uncomfortable. Whether aware of their heritage or not, many changelings prefer the company of other half-bloods — especially half-elves — with whom they share the burden of rejection tainted with envy. Those women who do learn about their roots often take to the road as wanderers or adventurers, or else withdraw from society to become hermits; some fear society's reaction to their bloodline, while others fear the implications of what that bloodline might mean.]] ..
        style('par') ..
        [[Whether they embrace or reject their maternal heritage, or even remain blissfully ignorant of their origins, all changelings have a strong emotional connection to hags. Powerful arcane magic and fey emotion binds mother to daughter. This connection is the root of the call, and changelings instinctively react passionately to hags, either more loving and accepting than any sentient being should be toward such fickle and cruel abusers, or else displaying a vitriol unmatched in human experience.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." .. "\n"),

    -- ###############################
    -- ######## RACE: DUERGAR ########
    -- ###############################
    ["duergar"] = (

        style('t1', "Duergar") ..

        style('par') ..
        [[Gray skinned, deep-dwelling dwarves who hate their lighter skinned cousins, duergar view life as constant toil ending only in death. Though these dwarves are typically evil, honor and keeping one's word means everything to them, and a rare few make loyal adventuring companions.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Duergar are hearty and observant, but also belligerent. They gain +2 Constitution, +2 Wisdom, and -4 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Duergar are humanoids with the dwarf subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Duergar are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Slow and Steady — Duergar have a base speed of 20 feet, but their speed is never modified by armor or encumbrance.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Duergar begin play speaking Common, Dwarven, and Undercommon. Duergar with high Intelligence scores can choose from Aklo, Draconic, Giant, Goblin, Orc and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Duergar Immunities: ") .. style('regular') ..
        [[Duergar are immune to paralysis, phantasms, and poison. They gain a +2 racial bonus on saves against spells and spell-like abilities.]] ..

        style('t3', "Stability: ") .. style('regular') ..
        [[Duergar receive a +4 racial bonus to their CMD against bull rush or trip attempts while on solid ground.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Enlarge Person Spell-Like Ability (Sp): ") .. style('regular') ..
        [[A duergar can use enlarge person once per day, using its character level as its caster level and affecting itself only.]] ..

        style('t3', "Invisibility Spell-Like Ability (Sp): ") .. style('regular') ..
        [[A duergar can use invisibility once per day, using its character level as its caster level and affecting itself only.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Superior Darkvision: ") .. style('regular') ..
        [[Duergar have superior darkvision, allowing them to see perfectly in the dark up to 120 feet.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', "Light Sensitivity: ") .. style('regular') ..
        [[Duergar are dazzled in areas of bright light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Duergar dwell in subterranean caverns far from the touch of light. They detest all races living beneath the sun, but that hatred pales beside their loathing of their surface-dwarf cousins. Dwarves and duergar once were one race, but the dwarves left the deeps for their mountain strongholds. The Duergar chose to remain in the depths, a choice that drove a permanent wedge between clans and shattered family bonds forever. Duergar consider themselves the only true dwarves, and the rightful heirs of all beneath the world’s surface.]] ..

        style('t3', "History: ") .. style('regular') ..
        [[After the departure of many dwarven clans, the remaining ones soon found that their numbers were now too few to hold the defenses against the many dangers of the depths. These dwarves found themselves in a perpetual retreat, beset on all sides by all manner of beasts. They had to flee deeper into the earth in search of pockets of relative safety and calm, competing with an influx of ancient enemies, displaced predators, and unspeakable evils freed from once-sealed vaults deep under the earth. As they retreated, they nursed a growing hatred for their former kin, whom they felt had betrayed them and left them to die.]] ..
        style('par') ..
        [[In their hour of need, their calls to the old gods were answered only with silence. But an outcast dwarven god heard the pleas and offered these forsaken dwarves one chance for survival: if they worshiped and served him, and bound their descendants to the same fate, he would restore them to glory.]] ..
        style('par') ..
        [[Given little choice, the desperate dwarves agreed. The fell god imbued the duergar with an innate mastery of magic, but also turned the dwarves' skin ashen gray and caused most of the males' hair (except for eyebrows and beards) to fall out as a reminder of the bargain made: ]] ..
        style('italic', [[their gray faces — or duergar in the Dwarven tongue — would set them apart from those cowards who fled the crucible that forged the true members of the dwarven race]]) .. "." ..
        style('par') ..
        [[ Since that cataclysm and the deal they wrought, the duergar have steadily taken back what was once theirs using the tools of their new lord: murder, slavery, toil, and hatred.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Duergar are bald, long-bearded, with dull gray skin, low arching brows and eyes that seem to absorb rather than reflect the light.]] ..
        style('par') ..
        [[While short and broad, standing roughly 4 1/2 feet tall, the rippling muscles of the duergars make most people uneasy, for beneath their skin, the muscles move of their own accord, snaking and twisting. Many duergars have long scars from their constant battles against underground enemies.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Duergar society is brutal and filled with toil. Over the ages, they have modified and rebuilt the ancient dwarven cities, often trading in artistry for functionality. Their cities generally have little evidence of rebellious activity, vagabonds, extensive slums, or similar problems that often plague other cities, yet a duergar city is by no means a utopia. They are places of endless labor, where the only ones who work harder than the duergar to perfect their weapons and defenses are their hapless slaves — duergar are perhaps the race most dependant on slavery in the underground, although not out of necessity. To a duergar, the concept of forcing a lesser race to toil unto death is the greatest mark of personal success one can hope to achieve.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[The Duergar detest all races living beneath the sun, but that hatred pales beside their loathing of their surface-dwarf cousins. They favor taking captives in battle over wanton slaughter, save for surface dwarves — who are slain without hesitation. Duergar view life as ceaseless toil ended only by death. Though few can be described as anything other than vile and cruel, duergar still value honor and rarely break their word.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Most Duergar are lawful evil and worship the dark god that made them what they are. They tend to be cruel and eager for battle, seeking to enslave all and kill dwarves, a lifestyle that suits the underground living.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[A duergar may become an adventurer to pursue vengeance upon the dwarves, to attack the underground foes of his kind, or tosomehow acquire more power to help them on those goals. As evil as lawful, a duergar may also become an adventurer if somehow someone manages to gain his favor or out of a debt.]] ..

        style('par') ..
        style('credits') ..
        "Adapted from various sources:" ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        "\n" .. style('par') ..
        "Pathfinder Chronicles: Into the Darklands. Copyright 2008, Paizo Publishing, LLC; Authors: James Jacobs and Greg A. Vaughan." ..
        "\n" .. style('par') ..
        "Psionics Unleashed. Copyright 2010, Dreamscarred Press." ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Monster Codex © 2014, Paizo Inc.; Authors: Dennis Baker, Jesse Benner, Logan Bonner, Jason Bulmahn, Ross Byers, John Compton, Robert N. Emerson, Jonathan H. Keith, Dale C. McCoy, Jr., Mark Moreland, Tom Phillips, Stephen Radney-MacFarland, Sean K Reynolds, Thomas M. Reid, Patrick Renie, Mark Seifter, Tork Shaw, Neil Spicer, Owen K.C. Stephens, and Russ Taylor." ..
        "\n" .. style('par') ..
        "Pathfinder RPG Bestiary. Copyright 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams."  .. "\n"),

    -- ###############################
    -- ######## RACE: GILLMEN ########
    -- ###############################
    ["gillmen"] = (

        style('t1', "Gillmen") ..

        style('par') ..
        [[Survivors of a land-dwelling culture whose homeland was destroyed, gillmen were saved and transformed into an amphibious race by the aboleths. Though in many ways they appear nearly human, gillmen's bright purple eyes and gills set them apart from humanity. Reclusive and suspicious, gillmen know that one day the aboleths will call in the debt owed to them.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Gillmen are vigorous and beautiful, but their domination by the aboleths has made them weak-willed. They gain +2 Constitution, +2 Charisma, and -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Gillmen are humanoids with the aquatic subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Gillmen are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Gillmen have a base speed of 30 feet on land. As aquatic creatures, they also have a swim speed of 30 feet, can move in water without making Swim checks, and always treat Swim as a class skill.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Gillmen begin play speaking Common and Aboleth. Gillmen with high Intelligence scores can choose from Aklo, Aquan, Draconic and Elven languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Enchantment Resistance: ") .. style('regular') ..
        [[Gillmen gain a +2 racial bonus to saving throws against non-aboleth enchantment spells and effects, but take a -2 penalty on such saving throws against aboleth sources.]] ..

        style('t2', "Weakness Racial Traits") ..

        style('t3', "Water Dependent: ") .. style('regular') ..
        [[A gillman's body requires constant submersion in fresh or salt water. Gillmen who spend more than one day without fully submerging themselves in water risk internal organ failure, painful cracking of the skin, and death within 4d6 hours.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Amphibious: ") .. style('regular') ..
        [[Gillmen can breathe both water and air.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The alluring yet reclusive aquatic gillmen live in coastal waters throughout the Inner Sea. They closely resemble humans, but with the addition of three gills above each collarbone. Gillmen generally avoid land-dwellers, but they occasionally trade with seaside communities for treasures they discover in the depths.]] ..
        style('par') ..
        [[Few air-breathers have seen a gillman, and those who have are usually suspicious of the humanoids. When they choose to interact with surface-dwellers, gillmen prefer to send lone emissaries and leave the remainder of their group underwater, leading many people to wonder whether the shallow seas teem with lurking gillmen armies. Gillmen hold strange superstitions and seem preternaturally attuned to storms and other weather patterns in a way that shore-dwellers find uncanny. Gillmen are universally reluctant to discuss the wonders and terrors beneath the waves, and particularly resistant to discussing the mind-bending aboleths. The logical conclusion, to particularly learned scholars, is that gillmen are a race of sleeper agents for the ocean’s terrifying masters.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Gillmen closely resemble humans, but with three gill-slits on each side of their necks and slight webbing between their fingers and toes that rarely reaches past the first knuckle. They have lean, athletic physiques, high foreheads, and expressive eyebrows. Nearly all gillmen have purple eyes. A gillman's visual acuity is no better than a human's, so most make their homes in shallow, sunlit water.]] ..
        style('par') ..
        [[The pores of gillmen continuously ooze a thin, clear mucus that protects their skin from salt water. This mucus dries out when exposed too long to air, causing the skin to itch and crack. Without regular immersion in water, a gillman eventually succumbs to organ failure and, ultimately, death. Most can survive out of water for a few days, but prefer not to take the risk. Rare, river-dwelling gillmen have adapted to living in fresh water; such gillmen can often survive on land for a much longer period.]] ..
        style('par') ..
        [[Gillmen age more slowly than humans; most can expect to live more than a century. Older gillmen develop white hair and waxy skin, and cannot survive out of the water as long as their younger kin.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Land-dwellers tend to see gillmen as reclusive creatures, and they do prefer to keep to the company of close family or extended groups of kin rather than gathering in large numbers, unless forced to assemble en masse to war against undersea enemies such as sahuagin. Their reputation as clannish isolationists or loners, however, is exacerbated by other creatures' inability to identify and interpret gillmen's gestures and other forms of nonverbal communication. Signs  of affection, camaraderie, or even simple recognition between gillmen are often invisible to others.]] ..
        style('par') ..
        [[Gillmen commonly make their homes in undersea caves, or in clusters of semicircular huts cunningly formed of coral and seaweed; each dwelling is usually home to an individual or a nuclear family. Like humans, they enjoy keeping pets and often spend time training aquatic animals as companions, mounts, and hunters. They prefer squid and hippocampi as pets; they avoid training predators such as sharks for much the same reason humans rarely domesticate wolves or bears. Some maintain schools of fish for food, culling diseased individuals and guiding the school with trained rays or octopuses.]] ..
        style('par') ..
        [[Gillmen rarely wear more than a loincloth and a tool belt, as they find most attire confining. When more clothing is necessary for warmth or protection, gillmen prefer form-fitting garments that do not impair their movement. They enjoy jewelry, particularly bracelets and circlets of pearl, gold, and colorful shells; affluent gillmen show their wealth by wearing eccentric jewelry in contrasting styles.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Gillmen are reclusive and suspicious by nature, so their interactions with land-dwellers are rare. Humans and halflings often live near the open ocean, giving gillmen the most familiarity with them. Contact with coastal peoples is brief and businesslike, but occasional friendships develop as both sides learn to trust each other.]] ..
        style('par') ..
        [[Gillmen's reluctance to interact with others has led them to unfairly rely on stereotypes of other races. For example, many gillmen assume that dwarves are basically stocky humans with a talent for craftsmanship, a generalization that usually offends dwarven honor. Half-orcs who take to the water often do so as pirates, so most gillmen assume that all half-orcs are brutal raiders. Gillmen respect aquatic elves and their beautiful workmanship, but pity surface elves and half-elves as their unfortunate land-bound relatives. They don't judge gnomes for their flightiness; while gillmen are not as overtly erratic, they must also be changeable given the vagaries of undersea life.]] ..
        style('par') ..
        [[The rare land-dweller who manages to truly gain the trust of a gillman usually finds that her alien perspective and cool reserve do not hamper her loyalty to friends and family. Gillman adventurers are rare, but make level-headed and highly competent party members who can apply logical practicality to problems in stressful situations while most of their companions are still reacting with fear or other intense emotions.]] ..
        style('par') ..
        [[Thanks to their origins above the waves, [... the Gillmen] have complicated relationships with other aquatic races. Merfolk, cecaelia, and siyokoy all consider anything that sinks beneath the waves to be their domain, and take offense at gillmen plundering their heritage to sell items back to surface folk. Tritons, on the other hand, take issue with the gillman tendency to exaggerate the importance of the salvaged treasures they sell. None of these ocean-going races entirely trust "aquatic humans" (as they call them), suspecting them of constant collusion with surface humans. Only aquatic elves share some empathy with gillmen thanks to their similar history of descent from surface-dwellers, but relations between the two races are no closer than those between humans and elves on land.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." .. "\n"),

    -- ################################
    -- ######## RACE: GRIPPLIS ########
    -- ################################
    ["gripplis"] = (

        style('t1', "Gripplis") ..

        style('par') ..
        [[Furtive frogfolk with the ability to camouflage themselves among fens and swamps, gripplis typically keep to their wetland homes, only rarely interacting with the outside world. Their chief motivation for leaving their marshy environs is to trade in metal and gems.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Gripplis are nimble and alert, but spindly. They gain +2 Dexterity, +2 Wisdom, and -2 Strength.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Gripplis are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty to their CMB and CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Gripplis are humanoids with the grippli subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Gripplis have a base speed of 30 feet and a climb speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Gripplis begin play speaking Common and Grippli. Gripplis with high Intelligence scores can choose from Boggard, Draconic, Elven, Gnome, Goblin, and Sylvan languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Camouflage: ") .. style('regular') ..
        [[Gripplis receive a +4 racial bonus on Stealth checks in marshes and forested areas.]] ..

        style('t2', "Movement Racial Traits") ..

        style('t3', "Swamp Stride (Ex): ") .. style('regular') ..
        [[A grippli can move through difficult terrain at its normal speed while within a swamp. Magically altered terrain affects a grippli normally.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Gripplis are proficient with nets.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Gripplis can see perfectly in the dark up to 60 feet.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Furtive frogfolk with the ability to camouflage themselves among fens and swamps, gripplis typically keep to their wetland homes, only rarely interacting with the outside world. Their chief motivation for leaving their marshy environs is to trade in metal and gems.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Gripplis stand just over 2 feet tall and have slick, mottled green-and-brown skin. They are an agile frog-like humanoid.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Ancient accounts suggest the grippli are originally from another world. Yet if the grippli were native to another realm, they show no signs of it now; they thrive wherever there are warm jungles and swamps.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Most gripplis are primitive hunter gatherers, living on large insects and fish found near their treetop homes, and are unconcerned about events outside their swamps.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[The rare grippli who leaves the safety of the swamp tends to be a ranger or alchemist seeking to trade for metals and gems. In places where human civilization expasion have brought them to close to their habitats, Grippli may leave to travel and embark on adventures.]] ..

        style('par') ..
        style('credits') ..
        "A gathering of diverse information on Grippli from:" ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        "\n" .. style('par') ..
        "Pathfinder RPG Bestiary. Copyright 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." ..
        "\n" .. style('par') ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." ..
        "\n" .. style('par') ..
        "Pathfinder Roleplaying Game Reference Document. © 2011, Paizo Publishing, LLC; Author: Paizo Publishing, LLC." .. "\n"),

    -- ################################
    -- ######## RACE: KITSUNE #########
    -- ################################
    ["kitsune"] = (

        style('t1', "Kitsune") ..

        style('par') ..
        [[These shapeshifting, fox-like folk share a love of mischief, art, and the finer things in life. They can appear as a single human as well as their true form, that of a foxlike humanoid. Kitsune are quick-witted, nimble, and gregarious, and because of this, a fair number of them become adventurers.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Kitsune are agile and companionable, but tend to be physically weak. They gain +2 Dexterity, +2 Charisma, and -2 Strength.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Kitsune are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Kitsune are humanoids with the kitsune and shapechanger subtypes.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Kitsune have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Kitsune begin play speaking Common and Sylvan. Kitsune with high Intelligence scores can choose from Aklo, Celestial, Elven, Gnome and Tengu or any human language. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Agile (Ex): ") .. style('regular') ..
        [[Kitsune receive a +2 racial bonus on Acrobatics checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Change Shape (Su): ") .. style('regular') ..
        [[A kitsune can assume the appearance of a specific single human form of the same sex. The kitsune always takes this specific form when she uses this ability. A kitsune in human form cannot use her bite attack, but gains a +10 racial bonus on Disguise checks made to appear human. Changing shape is a standard action. This ability otherwise functions as alter self, except that the kitsune does not adjust her ability scores and can remain in this form indefinitely.]] ..

        style('t3', "Kitsune Magic (Ex/Sp): ") .. style('regular') ..
        [[Kitsune add +1 to the DC of any saving throws against enchantment spells that they cast. Kitsune with a Charisma score of 11 or higher gain the spell-like ability 3/day-dancing lights (caster level equals the kitsune's level).]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Natural Weapons (Ex): ") .. style('regular') ..
        [[In her natural form, a kitsune has a bite attack that deals 1d4 points of damage.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Kitsune can see twice as far as humans in conditions of dim light.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Kitsune, or fox folk, are vulpine shapeshifters known for their love of both trickery and art. Kitsune possess two forms: that of an attractive human of slender build with salient eyes, and their true form of an anthropomorphic fox. Despite an irrepressible penchant for deception, kitsune prize loyalty and make true companions. They delight in the arts, particularly riddles and storytelling, and settle in ancestral clans, taking their wisdom from both the living and spirits.]] ..
        style('par') ..
        [[Quick-witted and nimble, kitsune make excellent bards and rogues. It is not uncommon for one to pursue sorcery, while those few born with white fur and pale eyes usually become oracles.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[A kitsune has two forms — a single human form and its true form, that of a humanoid fox. In their human forms, kitsune tend toward quickness and lithe beauty. In all forms they possess golden, amber, or brilliant blue eyes. In their true forms, they are covered with a downy coat of auburn fur, although more exotic coloration is possible.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Kitsune society is enigmatic, as kitsune prize loyalty among their friends but delight in good-natured mischief and trickery. Kitsune take pleasure in the pursuit of creative arts and in all forms of competition, especially the telling of stories interwoven with tall tales and falsehoods.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Kitsune deal well with elves and samsarans, but their reputation as tricksters follows them when they interact with other races. Many kitsune, particularly those who dwell in mixed-race societies, choose to hide their true natures and pose as humans in public.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Kitsune tend to be neutral, or of alignments with a neutral component. Most kitsune worship the goddess of craftsmanship.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Keenly interested in adding their own names to the myths and legends of explorers and heroes of old, Kitsune adventurers range across the world.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Dragon Empires Gazetteer © 2011, Paizo Publishing, LLC; Authors: Matthew Goodall, Dave Gross, James Jacobs, Steve Kenson, Michael Kortes, Colin McComb, Rob McCreary, Richard Pett, F. Wesley Schneider, Mike Shel, and Todd Stewart." .. "\n"),

    -- ################################
    -- ######## RACE: MERFOLK #########
    -- ################################
    ["merfolk"] = (

        style('t1', "Merfolk") ..

        style('par') ..
        [[These creatures have the upper torso of a well-built and attractive humanoid and a lower half consisting of a finned tail. Though they are amphibious and extremely strong swimmers, their lower bodies make it difficult for them to move on land. Merfolk can be shy and reclusive. Typically keeping to themselves, they are distrustful of land-dwelling strangers.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Merfolk are graceful, hale, and beautiful. They gain +2 Dexterity, +2 Constitution, and +2 Charisma.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Merfolk are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed (Slow Speed): ") .. style('regular') ..
        [[Merfolk have a base speed of 5 feet. They have a swim speed of 50 feet.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Merfolk are humanoids with the aquatic subtype.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Merfolk begin play speaking Common and Aquan. Merfolk with high Intelligence scores can choose from Aboleth, Aklo, Draconic, Elven and Sylvan. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Armor: ") .. style('regular') ..
        [[Merfolk have a +2 natural armor bonus.]] ..

        style('t3', "Legless: ") .. style('regular') ..
        [[Merfolk have no legs, and therefore cannot be tripped.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Merfolk have low-light vision allowing them to see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Amphibious: ") .. style('regular') ..
        [[Merfolk are amphibious, but prefer not to spend long periods out of the water.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[These creatures have the upper torso of a well-built and attractive humanoid and a lower half consisting of a finned tail. Though they are amphibious and extremely strong swimmers, their lower bodies make it difficult for them to move on land. Merfolk can be shy and reclusive. Typically keeping to themselves, they are distrustful of land-dwelling strangers.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Merfolk have the upper torsos of well-built and attractive humans and lower halves consisting of the tail and fins of a great fish. Their hair and scales span a wide range of hues, with Merfolk in a given region closely resembling each other. Merfolk can breathe air freely but move on dry land only with difficulty, and rarely spend long periods out of water.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Merfolk are found in every body of water, and those who live in the same region tend to have similar coloring and traits. Merfolk are a proud race and find much value in art and music. They spend a great deal of time honoring one another in performances and other enjoyable activities. Merfolk are also natural explorers and driven by curiosity, often finding themselves accused of being nosey — or worse, of theft. Their grace in the water can be trained to be used on land but only with great concentration and practice. Merfolk are cautious around other races. While capable of becoming great friends with individuals, they are guarded upon first approach.]] ..
        "{italic True}(Source: JBE:BoHR:AM)" ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Adapted  almost  exclusively  for  life  in  the  water,  merfolk rarely have reason to interact with the surface world. Even among aquatic races, they are remarkably xenophobic, and merfolk have been known to attack passing ships to defend their  territory.  As  a  result,  sailors  have  long  associated merfolk sightings with bad luck. The elves maintain amicable relations with neighboring groups, but otherwise  the  only  noteworthy  creatures  from  which  the merfolk do not isolate themselves are the aboleths, whom many merfolk serve — as often willingly as not.]] ..
        "{italic True} (Source PCS:ISR)" ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Although most merfolk have a strong inclination toward neutral alignments, some stray more towards chaotic alignments in their quest for knowledge and power. Since they are tied to the seas, they prefer aquatic deities and have a strong desire to protect nature, often times through the destruction or demise of others.]] ..
        "{italic True} (Source: JBE:BoHR:AM)" ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "{italic True}JBE:BoHR:AM >{italic False}   " ..
        "Book of Heroic Races: Advanced Merfolk. © 2015, Jon Brazer Enterprises; Author: Rachel Ventura." ..
        style('par') ..
        "{italic True}PCS:ISR >{italic False}   "..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich."

        .."\n"),

    -- ###############################
    -- ######## RACE: NAGAJI #########
    -- ###############################
    ["nagaji"] = (

        style('t1', "Nagaji") ..

        style('par') ..
        [[It is believed that nagas created the nagaji as a race of servants and that the nagaji worship their creators as living gods. Due to their reptilian nature and strange mannerisms, these strange, scaly folk inspire fear and wonder in others not of their kind. They are resistant to both poison and mind-affecting magic.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Nagaji are strong and have forceful personalities, but tend to ignore logic and mock scholastic pursuits. They gain +2 Strength, +2 Charisma, and -2 Intelligence.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Nagaji are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Nagaji are humanoids with the reptilian subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Nagaji have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Nagaji begin play speaking Common and Draconic. Nagaji with high Intelligence scores can choose from Abyssal, Aklo, Celestial, Draconic, Giant, Infernal, Sylvan or any human tongue. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Armored Scales: ") .. style('regular') ..
        [[Nagaji have a +1 natural armor bonus from their scaly flesh.]] ..

        style('t3', "Resistant (Ex): ") .. style('regular') ..
        [[Nagaji receive a +2 racial saving throw bonus against mind-affecting effects and poison.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Serpent's Sense (Ex): ") .. style('regular') ..
        [[Nagaji receive a +2 racial bonus on Handle Animal checks against reptiles, and a +2 racial bonus on Perception checks.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Nagaji have low-light vision allowing them to see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The nagaji are a race of ophidian humanoids with scaled skin that mimics the dramatic appearance of true nagas. Like serpents, they have forked tongues and lidless eyes, giving them an unblinking gaze that most other races find unnerving. Their physical forms are otherwise humanlike, raising wary speculation about their origins. It is widely believed that true nagas created them as a servitor race, through crossbreeding, magic, or both, and indeed nagaji revere nagas as living gods. Nagaji often inspire awe and fear among other humanoids, as much for their mysterious ancestry as for their talent for both swords and sorcery.]] ..
        style('par') ..
        [[Bred in the ancient past by nagas seeking a servitor race that combined the loyalty of a slave with the versatility of the human form, the nagaji have long since developed into a vibrant and proud race.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[The reptilian nagaji have scaly flesh — these scales are typically green, gray, or brown in hue, with colorful ridges of red, blue, or orange on their skulls or backs. Their ears and noses are flat, almost to the point of being nonexistent, while their eyes are those of serpents, ranging widely in color but tending toward golds, reds, yellows, and other warm hues.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Nagaji society places honor, devotion, and dedication above all else. Less charitable observers from outside such societies might call the nagaji "born slaves," but the nagaji do not think of themselves as slaves to their naga overlords, and point to the fact that they are free to make their own life decisions. Furthermore, when a naga oversteps its bounds as ruler of its people, the nagaji are no strangers to resistance or outright rebellion.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[For their part, nagaji regard humans as violent expansionists not to be trusted as political neighbors or allies. They tend to see kitsune and tengus as too capricious and mischievous to trust, but they grudgingly respect the samsarans' wisdom. Wayangs are mistrusted as well, for their apparent lack of a strong national heritage worries and confounds the nagaji.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Most nagaji are lawful neutral, but nagaji of any alignment are possible. While many non-nagaji believe they worship their naga lords as gods, this is not true — yet religion does play a secondary role in nagaji society to civic obedience.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Nagaji are often drawn to lives of adventure out of a desire to prove themselves to their naga masters, or to prove their own worth outside of this racial obligation. Strong of body and personality, nagaji excel as sorcerers, fighters, and for the right personality, serve exceptionally well as paladins.]] ..


        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Dragon Empires Gazetteer © 2011, Paizo Publishing, LLC; Authors: Matthew Goodall, Dave Gross, James Jacobs, Steve Kenson, Michael Kortes, Colin McComb, Rob McCreary, Richard Pett, F. Wesley Schneider, Mike Shel, and Todd Stewart." .. "\n"),


    -- ##################################
    -- ######## RACE: SAMSARANS #########
    -- ##################################
    ["samsarans"] = (

        style('t1', "Samsarans") ..

        style('par') ..
        [[Ghostly servants of karma, samsarans are creatures reincarnated hundreds if not thousands of times in the hope of reaching true enlightenment. Unlike humans and other races, these humanoids remember much of their past lives.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Samsarans are insightful and strong-minded, but their bodies tend to be frail. They gain +2 Intelligence, +2 Wisdom, and -2 Constitution.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Samsarans are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Samsarans are humanoids with the samsaran subtype.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Samsarans have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Samsarans begin play speaking Common and Samsaran. Samsarans with high Intelligence scores can choose from Abyssal, Aquan, Auran, Celestial, Draconic, Giant, Ignan, Infernal, Nagaji, Tengu, Terran or any human language. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Lifebound (Ex): ") .. style('regular') ..
        [[Samsarans gain a +2 racial bonus on all saving throws made to resist death effects, saving throws against negative energy effects, Fortitude saves made to remove negative levels, and Constitution checks made to stabilize if reduced to negative hit points.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Shards of the Past (Ex): ") .. style('regular') ..
        [[A samsaran's past lives grant her bonuses on two particular skills. A samsaran chooses two skills — she gains a +2 racial bonus on both of these skills, and they are treated as class skills regardless of what class he/she actually takes.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Samsarans can see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Samsaran Magic (Sp): ") .. style('regular') ..
        [[Samsarans with a Charisma score of 11 or higher gain the spell-like abilities 1/day-comprehend languages, deathwatch and stabilize. The caster level for these effects is equal to the samsaran's level.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Mysterious humanoids with pale blue flesh and transparent blood like the waters of a trickling brook, samsarans are ancient creatures even in their youth. A samsaran's life is not a linear progression from birth to death, but rather a circle of birth to death to rebirth. Whenever a samsaran dies, it reincarnates anew as a young samsaran to live a new life. Her past memories remain vague and indistinct — and each new incarnation is as different a creature and personality as a child is to a parent. Samsarans appear similar to humans, with dark hair and solid white eyes with no pupils or irises. Skin tones are generally shades of light blue.]] ..
        style('par') ..
        [[Capable of recalling the lessons and failings of their previous incarnations, the samsarans seek to live lives of balance and enlightenment in order to ensure they are reborn upon death to continue their trek through history.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Samsarans appear as humans with pale blue skin, solid white eyes with no pupil or iris, and dark hair. A samsaran's blood is crystal clear, like the water of a pure mountain spring.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Samsarans prefer to live simple lives of reflection, scholarship, and worship. They try to live their lives free of the ambitions and greed that mortality often imposes, since they view their lives as only the latest incarnation of many to come. Any accomplishments left undone in this current life can surely be achieved in the next, or the one after that. Samsarans' memories of their past lives are not complete — they most often feel like half-remembered dreams. Samsarans can give birth, yet they do not give birth to samsarans — instead, they birth human children. Typically, samsarans give up their children not long after birth to be raised in human society, where the children grow and live their lives normally. Upon death, such offspring sometimes reincarnate as samsaran children, if they lived their lives in keeping with harmony. While most samsarans who die also reincarnate as samsaran children, this is not always the case. When a samsaran has utterly failed at maintaining harmony in her current life, or when she has succeeded perfectly at it, her soul instead travels to the Great Beyond to receive its final, long-delayed reward or doom. Samsarans do not keep family names, but often retain the names of their previous one or two incarnations, regardless of gender, as a sort of replacement for a family name to honor their previous lives' accomplishments or to remind them of their past shames.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Humans and others often misunderstand samsarans' nature. Many fear or even hate samsarans' unusual association with death, thinking them to be strangely cursed souls at best or vengeful spirits made flesh at worst.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Most samsarans are lawful good — but samsarans of any alignment are possible. Deeply religious, the majority of samsarans take patron deities even if they aren't clerics.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Adventuring allows samsarans to see the world's wonders, deepens their understanding of life, and lets them visit places half remembered from their previous lives.]] ..


        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Dragon Empires Gazetteer © 2011, Paizo Publishing, LLC; Authors: Matthew Goodall, Dave Gross, James Jacobs, Steve Kenson, Michael Kortes, Colin McComb, Rob McCreary, Richard Pett, F. Wesley Schneider, Mike Shel, and Todd Stewart." .. "\n"),

    -- ##############################
    -- ######## RACE: STRIX #########
    -- ##############################
    ["strix"] = (

        style('t1', "Strix") ..

        style('par') ..
        [[Hunted to dwindling numbers by humans, who see them as winged devils, strix are black-skinned masters of the nighttime sky. Their territorial conflicts have fueled their hatred for humans. This longstanding feud means that these nocturnal creatures often attack humans on sight.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Strix are swift and elusive, but tend to be stubborn and swift to anger. They gain +2 Dexterity, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Strix are humanoids with the strix subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Strix are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Strix have a base speed of 30 feet on land. They also have a fly speed of 60 feet (average).]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Strix begin play speaking Strix. Those with high Intelligence scores can choose from Auran, Common, Draconic, Giant, Gnome, Goblin, Infernal languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Nocturnal: ") .. style('regular') ..
        [[Strix gain a +2 racial bonus on Perception and Stealth checks in dim light or darkness.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Suspicious: ") .. style('regular') ..
        [[Strix receive a +2 racial bonus on saving throws against illusion spells and effects.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Hatred: ") .. style('regular') ..
        [[Strix receive a +1 racial bonus on attack rolls against humanoid creatures with the human subtype because of their special training against these hated foes.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Strix see perfectly in the dark up to 60 feet.]] ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[In addition to their ability to see perfectly in the dark up to 60 ft, Strix have low-light vision, allowing them to see twice as far as humans in conditions of dim light.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[With their pupil-less eyes and 12-foot feathered wingspans, strix appear terrifying to many, who weave tales about murderous winged devils that steal into villages at night and devour children’s f lesh. Many humans communities believe that these strange creatures are abominations — cast-off children of  evil deities. Few scholars have actually approached strix territory to document the creatures’ history, so very little reliable information exists to counteract the wild rumors.]] ..
        style('par') ..
        [[Complex truths lie behind the strix’s fearsome appearance and monstrous reputation, and most of the alarmist stories about them are untrue. In reality, strix are insular people who — although ruthlessly vengeful when attacked — simply wish for strangers to leave them alone. Strix themselves believe that they evolved as a separate and superior race, but that the gods cursed them for some terrible misdeed. The details of this transgression have long been lost to time, but strix blame the curse for humans’ continued and often murderous forays into their lands. Under these circumstances, strix see nothing wrong with using deadly force to protect their own.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Aside  from  their  pronounced  ears,  dark  wings,  and  clawed  limbs,  strix  resemble  humans  with gray  to  black  skin  tones.  They  are  a  leathery-skinned,  lanky  people;  most  adults  stand  just over  6  feet  tall,  but  strix  rarely  weigh  more  than 170  pounds.  Their  ears  are  pointed,  their  hair  is universally  white,  and  their  large  eyes  give  off an  eerie  glow  that  ranges  from  ghostly  white  to crimson. As nocturnal creatures, they prefer the cool mist of the midnight moon to the hot glare of the midday sun. Nictitating membranes, which slide sideways over their eyes, add to their alien appearance. Oddly, strix eyes are fixed within their heads, forcing them to turn their heads to look around, and giving them a skittish demeanor.]] ..
        style('par') ..
        [[Strix are neither particularly prolific nor long-lived, which keeps their numbers low. A strix couple might have only two children, and many pairings remain childless, ensuring they cherish every member of their society. Such makes each death all the more devastating.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Strix society is led by a rokoa, an elder female strix who functions as a spiritual, social, and military leader. A council of elders and senior warriors advises her. Rokoa do not often bear children, since most do not ascend to the position until they are in their twilight years. However, they do participate in a spring fertility ritual that involves coupling with multiple male tribesmen, and occasionally bear offspring after this rite. A daughter conceived during the ritual is considered to be the daughter of the entire tribe, and often inherits her mother's position.]] ..
        style('par') ..
        [[Strix see their tight-knit, territorial, and insular society as an extended family, even if some members of the tribe lack close blood ties. Each individual considers it a personal duty to ensure that their tribe survives. Even strix who disagree with one another generally discuss the subject of contention politely and respectfully, and remain protective of one another.]] ..
        style('par') ..
        [[Their low population and fertility rates ensure that strix consider the well-being of the tribe far more important than any tensions between individuals. Strix do not formally recognize marriage or permanent bonds outside of blood relations. While some individuals do form pair-bonds, strix more commonly see sexual relationships as transient, and organize the family unit around sibling relationships. Mothers are the primary caregivers for their children, and while fathers are often involved with raising their offspring, aunts, uncles, grandparents, and close friends from both parents' sides tend to be equally involved.]] ..
        style('par') ..
        [[While their legends paint them as a once proud and noble race, strix see themselves as fallen, and have internalized the myths of their curse and the legacy of their bloody history with humans. They take pride in their warriors' prowess, while feeling shame at the need for constant violence. They acknowledge that their survival requires such aggressiveness on occasion, but remain divided on the morality of killing — even killing humans. Those who consider it a necessary evil wear masks when fighting so that their victims will not see their faces.]] ..
        style('par') ..
        [[Strix rarely attack first, but don't hesitate to kill dozens of humans in retaliation for the loss of one of their own. Ironically, their vengeful nature and their tendency toward destructive witchcraft feeds into their wide-spread reputation as diabolical or otherwise evil beings.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[The strix are a paranoid lot, but those who leave their homeland to pursue a life of adventure grow more open-minded toward other races. Regardless, no strix ever truly shakes her distrust of humans. That motley race, strix believe, has simply committed too many atrocities against the winged people to ever be viewed as trusted friends. Some strix adventurers flat-out refuse to ally with humans. Others may grudgingly accept a human, but only after that human makes a sincere gesture of peace and goodwill. Oftentimes, saving a strix's life is the only way to earn his/her trust. Strix have few qualms about other non-human races, though they are standoffish with all non-strix. Any non-human that shows respect for and interest in the strix culture can eventually befriend them. The process might be slow, but the reward can be a fierce and loyal ally.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." .. "\n"),

    -- #############################
    -- ######## RACE: SULI #########
    -- #############################
    ["suli"] = (

        style('t1', "Suli") ..

        style('par') ..
        [[Also called suli-jann, these humanoids are the descendants of mortals and jann. These strong and charismatic individuals manifest mastery over elemental power in their adolescence, giving them the ability to manipulate earth, f ire, ice, or electricity. This elemental power tends to be reflected in the suli's personality as well.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Sulis are brawny and charming, but slow-witted. They gain +2 Strength, +2 Charisma, and -2 Intelligence.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Sulis are outsiders with the native subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Sulis are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Sulis have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Sulis begin play speaking Common and one elemental language (Aquan, Auran, Ignan, or Terran). Sulis with high Intelligence scores can choose from Aquan, Auran, Draconic, Ignan and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Energy Resistance 5: ") .. style('regular') ..
        [[Sulis have resistance to acid 5, cold 5, electricity 5, and fire 5.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Negotiator: ") .. style('regular') ..
        [[Sulis are keen negotiators, and gain a +2 racial bonus on Diplomacy and Sense Motive checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Elemental Assault (Su): ") .. style('regular') ..
        [[Once per day as a swift action, a suli can shroud her arms in acid, cold, electricity, or fire. This lasts for one round per level, and can be dismissed as a free action. Unarmed strikes with her arms or hands (or attacks with weapons held in those hands) deal +1d6 points of damage of the appropriate energy type.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Sulis can see twice as far as humans in dim light.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[Also known as suli-jann, sulis are geniekin touched by all four elements, most often the result of humans interbreeding with jann. Crossing two or more elemental bloodlines may also produce a suli, who will then possess an affinity for only those particular elements. Sulis are the most humanlike of the geniekin, though they possess an unearthly charm and intensity that hints at their elemental ancestry.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Of all the geniekin, sulis bear the least visible traces of their ancestry, and many can pass as especially tall and beautiful members of their mortal parent’s race.]] ..
        style('par') ..
        "They are extradimensional beings housed in f lesh and bone. Like humans, they must still eat and sleep (though their unusual physiology allows them to consume unusual foods), and like most mortals their souls and physical bodies are separate and distinct. But geniekin souls are alien things shot through with elemental power. They gravitate naturally to their own elements and channel such magic as easily as a human might sing or paint. Likewise, their powerful souls resist many magic spells designed to bend the humanoid will, and impart them with instinctual knowledge of ancient tongues." ..
        style('par') ..
        "While most geniekin are born to at least one human parent, geniekin of other humanoid races do exist. These geniekin resemble their humanoid parents in height and stature, but are otherwise indistinguishable from other geniekin of the same kind. Geniekin born from direct unions between humans and elemental beings (in the rare cases where these couplings can be safely performed) typically bear more pronounced elemental features, such as hair made entirely from flames or mist." ..

        style('t3', "Society: ") .. style('regular') ..
        "Geniekin are rare, forming small, unique niches within larger parent societies. They bond over shared experiences and shared language, or at least commiserate over hardships they experienced as social and literal outsiders in human culture. Where they gather in thicker numbers geniekin tend to break apart along elemental lines, and develop unique cultures that blend their host societies and those of the genies from which they descend." ..

        style('t3', "Relations: ") .. style('regular') ..
        "Sulis share sympathies with halflings, as both races count slavery as a very serious concern in the Inner Sea region. They make easy friends among humans and half-elves, and often try to pass as these races when traveling in hostile lands." ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        "Sulis often feel pulled toward many different faiths at once, and many adopt a patchwork belief system or a pantheistic mind-set. Overall, religion offers some stability and community to geniekin. Their talents can help bolster a church’s reputation, as some parishioners may see their unusual natures as divinely inspired. Because of this meritocratic setting, many geniekin become clergy or prefer to work as temple servants and scholars." ..

        style('t3', "Adventures: ") .. style('regular') ..
        "The elemental magic in the blood of geniekin shapes their attitudes and approaches to adventuring. [... They] are driven to take in everything they can, wrest the most out of their lives, and move through challenges with speed and passion. They seek out novel experiences, and often assume the mantle of adventurer not for money or some noble cause, but simply for raw excitement. As age and wisdom teach them the discipline to channel their volatile natures, they may seek more." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." .. "\n"),

    -- ####################################
    -- ######## RACE: SVIRFNEBLIN #########
    -- ####################################
    ["svirfneblin"] = (

        style('t1', "Svirfneblin") ..

        style('par') ..
        [[Gnomes who guard their hidden enclaves within dark tunnels and caverns deep under the earth, svirfneblin are as serious as their surface cousins are whimsical. They are resistant to the magic of the foul creatures that share their subterranean environs, and wield powerful protective magic. Svirfneblin are distrustful of outsiders and often hide at their approach.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Svirfneblin are fast and observant but relatively weak and emotionally distant. They gain -2 Strength, +2 Dexterity, +2 Wisdom, and -4 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Svirfneblin are humanoids with the gnome subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Svirfneblin are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty to their CMB and CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Speed: ") .. style('regular') ..
        [[Svirfneblin have a base speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Svirfneblin begin play speaking Gnome and Undercommon. Those with high Intelligence scores can choose from Aklo, Common, Draconic, Dwarven, Elven, Giant, Goblin, Orc and Terran languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Defensive Training: ") .. style('regular') ..
        [[Svirfneblin gain a +2 dodge bonus to Armor Class.]] ..

        style('t3', "Fortunate: ") .. style('regular') ..
        [[Svirfneblin gain a +2 racial bonus on all saving throws.]] ..

        style('t3', "Spell Resistance: ") .. style('regular') ..
        [[Svirfneblin have spell resistance (SR) equal to 11 + their class levels.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Skills: ") .. style('regular') ..
        [[Svirfneblin gain a +2 racial bonus on Stealth checks; this improves to a +4 bonus underground. They gain a +2 racial bonus on Craft (alchemy) checks and Perception checks.]] ..

        style('t3', "Stonecunning: ") .. style('regular') ..
        [[Svirfneblin gain stonecunning (as dwarves.)]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Svirfneblin Magic: ") .. style('regular') ..
        [[Svirfneblin add +1 to the DC of any illusion spells they cast. Svirfneblin also gain spell-like abilities (caster level equals the svirfneblin's class levels) "nondetection"(constant), 1/day "blindness"/"deafness" (DC 12 + Charisma modifier), "blur" and "disguise self".]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Hatred: ") .. style('regular') ..
        [[Svirfneblin receive a +1 bonus on attack rolls against humanoid creatures of the reptilian and dwarf subtypes due to training against these hated foes.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Svirfneblin can see perfectly in the dark up to 120 feet.]] ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[In addition to their ability to see perfectly in the dark up to 60 ft, svirfneblin have low-light vision, allowing them to see twice as far as humans in conditions of dim light.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Sinister in appearance and reputation, the svirfneblin live where no other race would even consider: deep underground. Neighbors to some of the most terrible of the Old Ones' spawn, these quiet and sneaky gnomes must do everything within their power and ingenuity to survive and, luck and skill willing, even thrive. Of a much more somber disposition than almost any other race, the svirfneblin toil and work, asking for no quarter among their enemies and giving none.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Svirfneblin are slightly shorter than normal gnomes, standing a little below three and a half feet tall but otherwise built similarly to their cousins. Most of that build is muscle, however, as the svirfneblin are wiry, with somewhat gnarled limbs. Their skin has the coloration of rock, a grayish beige, in order to blend with their surroundings. Their eyes are of a pale muted color, ranging from gray to clear blue, creating a rather disquieting stare for some surface dwellers. Men are typically bald and women have thin and stringy gray hair. Their clothing is austere and utilitarian, with dark shades of brown or other earth tones prevailing. They adorn themselves with lovingly-crafted gems on special occasions, but such festivals are rare and unpredictable, so they like to keep their best clothes in tucked away in good care for the next festivity.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('t3', "Society: ") .. style('regular') ..
        [[Svirfneblin value hard work, and in their case, it is really hard. Their communities entrench themselves in deep and spacious caves that give them access to their precious mines, which form one of the pillars of their society. Mining is the undying passion of the svirfneblin, it is why they endure all the hardships of their subterranean existence and why they are willing to face some of the vilest enemies in the world.]] ..
        style('par') ..
        [[Bent on survival, svirfneblin are nowhere near as sociable as the surface races and are definitely not as friendly. Nobody can blame them when their closest neighbors are more eager to eat them or enslave them. Insular by necessity, they view outsiders with distrust and wariness. Svirfneblin communities resemble city-states, for they are as large as many human cities and are ruled by a king and a queen.]] ..
        style('par') ..
        [[Their spartan way of life divides labor between the sexes, with males in charge of all the mining activities and the community's defense, and females in charge of managing supplies and tending to fungus crops, fishing and housekeeping. This is a division born of necessity, not prejudice; even the king and queen are subject to this aspect of svirfneblin culture, each sharing power in equal measure and responsible for their gender-assigned tasks.]] ..
        [[The svirfneblin make their home in caverns deep underground, where no light can possibly reach. They use magic and craftsmanship to carve their cities out of the living rock and hide the caves and corridors that connect them to the rest of the underground complexes that harbor them. They have little or no contact with other svirfneblin communities because travel between them endangers both, risking exposing them to their countless enemies.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('t3', "Relations: ") .. style('regular') ..
        [[In the past, svirfneblin have not kept stable relations with any other race. However, this xenophobic mindset is quickly changing as the number of horrors continue to grow. Svirfneblin are accepting the fact that they need the aid of the surface dwellers.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[ The svirfneblin have no religion of their own, or if they did have long forgotten the names of those deities. Many svirfneblin do praise their ancestors and have festivals to honor the dead.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Svirfneblin found alone, far from their communities, are explorers or emissaries, looking for new ways to battle the [... many horrors of the underground] and to make allies with the other races. Lone svirfneblin adventurers set out to hunt down and fight their race's enemies, a task considered a great honor and a duty that is becoming ever more needed. They rarely venture above ground and most of the other races don't know how to take these gruff creatures.]] ..
        "{italic True} (Source: FGG:SoV){italic False}." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "{italic True}FGG:SoV >{italic False}   " ..
        "Shadows over Vathak, © 2012, Fat Goblin Games. Jason Stoffa and Rick Hershey." .. "\n"),

    -- ################################
    -- ######## RACE: VANARAS #########
    -- ################################
    ["vanaras"] = (

        style('t1', "Vanaras") ..

        style('regular') ..
        [[These mischievous, monkey-like humanoids dwell in jungles and warm forests. Covered in soft fur and sporting prehensile tails and hand-like feet, vanaras are strong climbers. These creatures are at home both on the ground and among the treetops.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Vanaras are agile and insightful, but are also rather mischievous. They gain +2 Dexterity, +2 Wisdom, and -2 Charisma.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Vanaras are humanoids with the vanara subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Vanaras are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Speed: ") .. style('regular') ..
        [[Vanaras have a base speed of 30 feet and a climb speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Vanaras begin play speaking Common and Vanaran. Vanaras with high Intelligence scores can choose from Aklo, Celestial, Elven, Gnome, Goblin and Sylvan languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Nimble: ") .. style('regular') ..
        [[Vanaras have a +2 racial bonus on Acrobatics and Stealth checks.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[A vanara can see twice as far as a human in dim light.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Prehensile Tail: ") .. style('regular') ..
        [[A vanara has a long, flexible tail that she can use to carry objects. She cannot wield weapons with her tail, but the tail allows her to retrieve a small, stowed object carried on her person as a swift action.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Vanaras  are  intelligent,  simian  humanoids  who  live  in deep forests and jungles. They are both agile and clever, but saddled with boundless curiosity and a love of pranks that, while  normally  harmless,  hinder  ingratiations  with  those they  encounter.]] ..
        "{italic True} (Source: PB3)" ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[A  vanara’s  body  is  covered  in  a  thin  coat of soft fur, and individuals with chestnut, ivory, and even golden coats are common. Despite its fur, a vanara can grow lengthy hair on its head just like a human, and both male and female vanaras take pains to wear elaborate hairstyles for  important  social  functions.  The  hair  on  a  vanara’s head  matches  the  color  of  its  fur.  All  vanaras  have  long, prehensile tails and handlike feet capable of well-articulated movements. A vanara stands slightly shorter than a typical human. Males weigh from 150 to 200 pounds at most, with females weighing slightly less. Vanaras live for 60 to 75 years.]] ..
        "{italic True} (Source: PB3)" ..

        style('t3', "Society: ") .. style('regular') ..
        [[Vanaras  live  in  large,  tree-top  villages  connected  by rope-bridges  and  ladders.  Homes  are  carved  out  of  trees but usually left open to the elements except for woven leaf canopies and overhangs. Vanara villages are typically led by the community’s religious leader — usually a cleric, oracle, or monk.]] ..
        "{italic True} (Source: PB3)" ..

        style('t3', "Relations: ") .. style('regular') ..
        "Extremely curious and blunty honest, the vanaras are usually considered childish and irritating by other races that do not understand them. They get along reasonably well with other good aligned humanoid races, but don't hesitate to show their hatred for the evil ones." ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        "Most vanaras are lawful good, obeying their strict cast system, being loyal and kind to their kin and friends, not hesitating to perform acts of bravery to protect them. Some of those who become adventurers, however, may have any good alignment." ..
        style('par') ..
        "The vanaras pray to the forest spirits, offering prayers and songs to them, under the guidance of their religious leaders."..

        style('t3', "Adventurers: ") .. style('regular') ..
        "Some vanaras become adventurers and explorers as a way to fullfill their curiosity about the foreign society, or to seek fortune. Others seek, as adventurers, a way to free themselves from the limitations imposed by the caste system of the vanara society." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "{italic True}PB3 >{italic False}   " ..
        "Pathfinder Roleplaying Game Bestiary 3, © 2011, Paizo Publishing, LLC; Authors Jesse Benner, Jason Bulmahn, Adam Daigle, James Jacobs, Michael Kenway, Rob McCreary, Patrick Renie, Chris Sims, F. Wesley Schneider, James L. Sutter, and Russ Taylor, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." .. "\n"),

    -- ###################################
    -- ######## RACE: VISHKANYAS #########
    -- ###################################
    ["vishkanyas"] = (

        style('t1', "Vishkanyas") ..

        style('par') ..
        [[Strangely beautiful on the outside and poisonous on the inside, vishkanyas see the world through slitted serpent eyes. Vishkanyas possess a serpent's grace and ability to writhe out of their enemies' grasp with ease. Vishkanyas have a reputation for being both seductive and manipulative. They can use their saliva or blood to poison their weapons.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Vishkanyas are graceful and elegant, but they are often irrational. They gain +2 Dexterity, +2 Charisma, and -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Vishkanyas are humanoids with the vishkanya subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Vishkanyas are Medium creatures and thus have no bonuses or penalties due to their size.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Vishkanyas have a base speed of 30 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Vishkanyas begin play speaking Common and Vishkanya. Vishkanyas with high Intelligence scores can choose from Aklo, Draconic, Elven, Goblin, Sylvan and Undercommon languages. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Poison Resistance: ") .. style('regular') ..
        [[A vishkanya has a racial bonus on saving throws against poison equal to its Hit Dice.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Keen Senses: ") .. style('regular') ..
        [[Vishkanyas receive a +2 racial bonus on Perception checks.]] ..

        style('t3', "Limber: ") .. style('regular') ..
        [[Vishkanyas receive a +2 racial bonus on Escape Artist and Stealth checks.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Low-Light Vision: ") .. style('regular') ..
        [[Vishkanyas can see twice as far as humans in conditions of dim light.]] ..

        style('t2', "Offense Racial Traits") ..

        style('t3', "Poison Use: ") .. style('regular') ..
        [[Vishkanyas are skilled in the use of poison and never accidentally poison themselves when using or applying poison.]] ..

        style('t3', "Toxic: ") .. style('regular') ..
        [[A number of times per day equal to his Constitution modifier (minimum 1/day), a vishkanya can envenom a weapon that he wields with his toxic saliva or blood (using blood requires the vishkanya to be injured when he uses this ability). Applying venom in this way is a swift action.]] ..

        style('t3', "Vishkanya Venom: ") .. style('regular') ..
        [[Injury; save Fort DC 10 + 1/2 the vishkanya's Hit Dice + the vishkanya's Constitution modifier; frequency 1/round for 6 rounds; effect 1d2 Dex; cure 1 save.]] ..

        style('t3', "Weapon Familiarity: ") .. style('regular') ..
        [[Vishkanyas are always proficient with blowguns, kukri, and shuriken.]] ..


        style('t2', "Full Description") .. style('par') ..
        [[Strangely beautiful on the outside and poisonous on the inside, vishkanyas see the world through slitted serpent eyes. Vishkanyas possess a serpent’s grace and ability to writhe out of their enemies’ grasp with ease. Vishkanyas have a reputation for being both seductive and manipulative. They can use their saliva or blood to poison their weapons.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Vishkanyas are a race of exotic humanoids known for their guile and affinity for poisons of all kinds. A vishkanya’s flesh is made up of fine scales that from a distance of even a few feet look just like particularly smooth skin. These scales  are  usually  a  single  dark  color,  although  some  of them have complex patterns like stripes or even spirals. A vishkanya’s tongue is forked like a serpent’s tongue, and its eyes lack visible pupils.]] ..
        style('par') ..
        [[Although  legends  abound  that  the  merest  touch  from a vishkanya can slay a mortal humanoid, these tales are patently  false.  A  vishkanya’s  skin  is  no  more  poisonous than that of any human, but it is true that their blood, spit, and other bodily fluids can be dangerous. Vishkanyas are skilled in using their own spittle or even their blood to envenom their weapons, and those who fight them should be  wary  of  exposure  to  the  vishkanya’s  poison.  A vishkanya is 6 feet tall and weighs 130 pounds.]] ..
        "{italic True} (Source: PB3)" ..

        style('t3', "Society: ") .. style('regular') ..
        [[Vishkanyas' origins point to somewhere in the far east, a homeland from wich they were banished a long time ago, but nowadays they can be found anywhere.]] ..
        [[Thanks  to  their  largely  human  appearance,  vishkanyas have  gradually  moved  throughout  [... human cities] with few being any wiser. Knowledge of vishkanyas remains uncommon,  so  even  if  someone  spots  their  faint  scales or  pupil-less  eyes,  most  people  assume  they’re  tieflings, dragon-blooded sorcerers, or other such individuals.]] ..
        [[The vishkanyas  have  gravitated toward  population  centers  that  reward  their  particular talents:  poison,  espionage,  and  the  arts. Not all pursue these deadly arts, but even those who choose a more peaceful path sometimes attract the attention of recruiters.]] ..
        "{italic True} (Source: PCS:ISR)" ..

        style('t3', "Relations: ") .. style('regular') ..
        [[The Vishkanyas tend to get along well with humans, as long as they can pass themselves as one of them. Apart from that, the way they relate with other is more or less the way humans do, being also influenced by the vishkanya's alignment.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[The Vishkanyas can be of any alignment, being heavily influenced by the culture they grew up in. Some of them embrace their talents and make a living out of poisoning and assasination, and tend to follow evil alignments. Others, however, refuse to take that path and dedicate their lives to fight evil, maybe to prove themselves as worthy members of the society. And there are those who strive to simply find their place in the world, becoming usually neutral.]] ..
        style('par') ..
        [[The vishkanyas religious possibilities are open as those of humans, but may tend to dieties that approve the assassination for those who follow that path]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        "Living among humans the Vishkanyans can become adventurers due to many reasons, such as ambition alone, a personal quest, to prove themselves, etc. Some of them can also take the path of adventuring after to avoid persecution, should their origin or occupation (in the case of assassins) become public. Others may conviced to do so by people in need of their talents." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..

        style('par') ..
        "{italic True}PB3 >{italic False}   " ..
        "Pathfinder Roleplaying Game Bestiary 3, © 2011, Paizo Publishing, LLC; Authors Jesse Benner, Jason Bulmahn, Adam Daigle, James Jacobs, Michael Kenway, Rob McCreary, Patrick Renie, Chris Sims, F. Wesley Schneider, James L. Sutter, and Russ Taylor, based on material by Jonathan Tweet, Monte Cook, and Skip Williams." ..

        style('par') ..
        "{italic True}PCS:ISR >{italic False}   " ..
        "Pathfinder Campaign Setting: Inner Sea Races © 2015, Paizo Inc.; Authors: Ross Byers, John Compton, Adam Daigle, Crystal Frasier, Matthew Goodall, Alex Greenshields, James Jacobs, Amanda Hamon Kunz, Ron Lundeen, Rob McCreary, Jessica Price, David N. Ross, Owen K.C. Stephens, James L. Sutter, Russ Taylor, and Jerome Virnich." .. "\n"),

    -- ################################
    -- ######## RACE: WAYANGS #########
    -- ################################
    ["wayangs"] = (

        style('t1', "Wayangs") ..

        style('par') ..
        [[The small wayangs are creatures of the Plane of Shadow. They are so attuned to shadow that it even shapes their philosophy, believing that upon death they merely merge back into darkness. The mysteries of their shadowy existence grant them the ability to gain healing from negative energy as well as positive energy.]] ..

        style('t2', "Standard Racial Traits") ..

        style('t3', "Ability Score Racial Traits: ") .. style('regular') ..
        [[Wayang are nimble and cagey, but their perception of the world is clouded by shadows. They gain +2 Dexterity, +2 Intelligence, and -2 Wisdom.]] ..

        style('t3', "Type: ") .. style('regular') ..
        [[Wayangs are humanoids with the wayang subtype.]] ..

        style('t3', "Size: ") .. style('regular') ..
        [[Wayangs are Small creatures and thus gain a +1 size bonus to their AC, a +1 size bonus on attack rolls, a -1 penalty on their CMB and to CMD, and a +4 size bonus on Stealth checks.]] ..

        style('t3', "Base Speed: ") .. style('regular') ..
        [[Wayangs have a base speed of 20 feet.]] ..

        style('t3', "Languages: ") .. style('regular') ..
        [[Wayangs begin play speaking Common and Wayang. Wayangs with high Intelligence scores can choose from Abyssal, Aklo, Draconic, Goblin, Infernal, Nagaji, Samsaran, Tengu or any human language. See the Linguistics skill page for more information about these languages.]] ..

        style('t2', "Defense Racial Traits") ..

        style('t3', "Shadow Resistance: ") .. style('regular') ..
        [[Wayangs get a +2 racial bonus on saving throws against spells of the shadow subschool.]] ..

        style('t2', "Feat and Skill Racial Traits") ..

        style('t3', "Lurker: ") .. style('regular') ..
        [[Wayangs gain a +2 racial bonus on Perception and Stealth checks.]] ..

        style('t2', "Magical Racial Traits") ..

        style('t3', "Shadow Magic: ") .. style('regular') ..
        [[Wayangs add +1 to the DC of any saving throws against spells of the shadow subschool that they cast. Wayangs with a Charisma score of 11 or higher also gain the spell-like abilities '1/day-ghost sound', 'pass without trace', and 'ventriloquism'. The caster level for these effects is equal to the wayang's level. The DC for these spells is equal to 10 + the spell's level + the wayang's Charisma modifier.]] ..

        style('t2', "Senses Racial Traits") ..

        style('t3', "Darkvision: ") .. style('regular') ..
        [[Wayangs can see in the dark up to 60 feet.]] ..

        style('t2', "Other Racial Traits") ..

        style('t3', "Light and Dark (Su): ") .. style('regular') ..
        [[Once per day as an immediate action, a wayang can treat positive and negative energy effects as if she were an undead creature, taking damage from positive energy and healing damage from negative energy. This ability lasts for 1 minute once activated.]] ..

        style('t2', "Full Description") .. style('par') ..
        [[The wayangs are a race of small supernatural humanoids who trace their ancestry to the Plane of Shadows. They are extremely gaunt, with pixielike stature and skin the color of deep shadow. Deeply spiritual, they follow a philosophy which teaches that in passing they may again merge into the shadow. They readily express their beliefs through ritual scarification and skin bleaching, marking their bodies with raised white dots in ornate spirals and geometric patterns. Shy and elusive, they live in small, interdependent tribes. Wayangs rarely associate with outsiders.]] ..

        style('t3', "Physical Description: ") .. style('regular') ..
        [[Wayangs are short and lean, similar in stature to gnomes, though tending toward darker, more muted colorations. Their features are sharp, and their skin tones range from shades of twilight plum and dark gray to depthless black. Most undergo ritual scarification and tattooing from a young age.]] ..

        style('t3', "Society: ") .. style('regular') ..
        [[Forming small, tightly knit tribes, wayangs live a communal existence, sharing what they have with their friends and families. Their culture seems morbid to most outsiders, one that idealizes a shadowy state of non-being while demonizing the fierce clarity of light.]] ..

        style('t3', "Relations: ") .. style('regular') ..
        [[Most wayang tribes do their best to avoid the notice of others. To them, the hunting jaguar, the sharp-taloned hawk, and the greedy human are relentless co-conspirators, seeking to exploit, torment, and kill the wayangs. Only through their nimbleness and secretiveness have wayangs survived.]] ..

        style('t3', "Alignment and Religion: ") .. style('regular') ..
        [[Wayang culture guides its members toward neutrality; wayangs avoid the conflicts of others and seek the balance found in shadow, although they can be of any alignment.]] ..

        style('t3', "Adventurers: ") .. style('regular') ..
        [[Sometimes the folktales and warnings of wayang elders have the opposite of their intended effect, fascinating bold youths with stories of the countless creatures and brilliant worlds beyond their hidden communities.]] ..


        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Advanced Race Guide. © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Jason Bulmahn, Adam Daigle, Jim Groves, Tim Hitchcock, Hal MacLean, Jason Nelson, Stephen Radney-MacFarland, Owen K.C. Stephens, Todd Stewart, and Russ Taylor." ..
        style('par') ..
        "Pathfinder Campaign Setting: Dragon Empires Gazetteer © 2011, Paizo Publishing, LLC; Authors: Matthew Goodall, Dave Gross, James Jacobs, Steve Kenson, Michael Kortes, Colin McComb, Rob McCreary, Richard Pett, F. Wesley Schneider, Mike Shel, and Todd Stewart.")

    -- ###############################
    -- ###############################
    -- ######## END OF RACES #########
    -- ###############################
    -- ###############################
},

-- ########################
-- ######## STATS #########
-- ########################
["stats"] = {

    -- ###########################
    -- ######## STRENGHT #########
    -- ###########################
    ['strenght'] = (
        style('t1', "Strenght") .. style('par') ..
        "Strength measures your character's muscle and physical power. This ability is especially important for " .. (
            style('highlight', 'fighters') .. ", " ..
            style('highlight', 'barbarians') .. ", " ..
            style('highlight', 'paladins') .. ", " ..
            style('highlight', 'rangers') .. " and " ..
            style('highlight', 'monks')
        ) ..
        " because it helps them prevail in combat. Strength also limits the amount of equipment your character can carry." ..
        style('par') ..
        "You apply your character's Strength modifier to:" ..
        style('t3', "   > ") .. style('regular') .. "Melee attack rolls." ..
        style('t3', "   > ") .. style('regular') .. "Damage rolls when using a melee weapon or a thrown weapon, including a sling. (Exceptions: Off-hand attacks receive only one-half the character's Strength bonus, while two-handed attacks receive one and a half times the Strength bonus. A Strength penalty, but not a bonus, applies to attacks made with a bow that is not a composite bow.)" ..
        style('t3', "   > ") .. style('regular') .. "Climb, Jump, and Swim checks. These are the skills that have Strength as their key ability." ..
        style('t3', "   > ") .. style('regular') .. "Strength checks (for breaking down doors and the like)." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams."),

    -- ###############################
    -- ######## INTELLIGENCE #########
    -- ###############################
    ['intelligence'] =
        style('t1', "Intelligence") ..

        style('par') ..
        [[Intelligence determines how well your character learns and reasons. This ability is important for ]] .. style('blue', "wizards") .. [[ because it affects how many spells they can cast, how hard their spells are to resist, and how powerful their spells can be. It's also important for any character who wants to have a wide assortment of skills.]] ..
        style('par') ..
        [[You apply your character's Intelligence modifier to:]] ..
        style('t3', "   > ") .. style('regular') .. "The number of languages your character knows at the start of the game." ..
        style('t3', "   > ") .. style('regular') .. "The number of skill points gained each level. (But your character always gets at least 1 skill point per level.)" ..
        style('t3', "   > ") .. style('regular') .. "Appraise, Craft, Decipher Script, Disable Device, Forgery, Knowledge, Search, and Spellcraft checks. These are the skills that have Intelligence as their key ability." ..
        style('par') ..
        "A wizard gains bonus spells based on their Intelligence score. The minimum Intelligence score needed to cast a wizard spell is 10 + the spell's level."..
        style('par') ..
        "An animal has an Intelligence score of 1 or 2. A creature of humanlike intelligence has a score of at least 3." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.",

    -- ############################
    -- ######## DEXTERITY #########
    -- ############################
    ['dexterity'] =
        style('t1', "Dexterity") .. style('par') ..
        [[Dexterity measures hand-eye coordination, agility, reflexes, and balance. This ability is the most important one for ]] ..
        (
            style('blue', 'rogues')
        ) ..
        [[, but it's also high on the list for characters who typically wear light or medium armor or no armor at all.This ability is vital for characters seeking to excel with ranged weapons, such as the bow or sling. A character with a Dexterity score of 0 is incapable of moving and is effectively immobile (but not unconscious).]] ..
        style('par') ..
        "You apply your character's Dexterity modifier to:" ..
        style('t3', "   > ") .. style('regular') .. "Ranged attack rolls, including those for attacks made with bows, crossbows, throwing axes, and other ranged weapons." ..
        style('t3', "   > ") .. style('regular') .. "Armor Class (AC), provided that the character can react to the attack." ..
        style('t3', "   > ") .. style('regular') .. "Reflex saving throws, for avoiding fireballs and other attacks that you can escape by moving quickly." ..
        style('t3', "   > ") .. style('regular') .. "Balance, Escape Artist, Hide, Move Silently, Open Lock, Ride, Sleight of Hand, Tumble, and Use Rope checks. These are the skills that have Dexterity as their key ability." ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.",


    -- ###############################
    -- ######## CONSTITUTION #########
    -- ###############################
    ['constitution'] =
        style('t1', "Constitution") .. style('par') ..
        [[Constitution represents your character's health and stamina. A Constitution bonus increases a character's hit points, so the ability is important for all classes.]] ..
        style('par') ..
        "You apply your character's Constitution modifier to:" ..
        style('t3', "   > ") .. style('regular') .. "Each roll of a Hit Die (though a penalty can never drop a result below 1 — that is, a character always gains at least 1 hit point each time he or she advances in level)." ..
        style('t3', "   > ") .. style('regular') .. "Fortitude saving throws, for resisting poison and similar threats." ..
        style('par') ..
        [[If a character's Constitution score changes enough to alter their or their Constitution modifier, the character's hit points also increase or decrease accordingly.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.",

    -- #########################
    -- ######## WISDOM #########
    -- #########################
    ['wisdom'] =
        style('t1', "Wisdom") .. style('par') ..
        [[Wisdom describes a character's willpower, common sense, perception, and intuition. While Intelligence represents one's ability to analyze information, Wisdom represents being in tune with and aware of one's surroundings. Wisdom is the most important ability for ]] ..
        (
            style('blue', 'clerics') .. ' and ' ..
            style('blue', 'druids')
        ) ..
        [[, and it is also important for ]] ..
        (
            style('blue', 'paladins') .. ' and ' ..
            style('blue', 'rangers')
        ) ..
        [[. If you want your character to have acute senses, put a high score in Wisdom. Every creature has a Wisdom score.]] ..
        "You apply your character's Wisdom modifier to:" ..
        style('t3', "   > ") .. style('regular') .. "Will saving throws (for negating the effect of charm person and other spells)." ..
        style('t3', "   > ") .. style('regular') .. "Heal, Listen, Profession, Sense Motive, Spot, and Survival checks. These are the skills that have Wisdom as their key ability." ..
        style('t3', "   > ") .. style('regular') .. [[Clerics, druids, paladins, and rangers get bonus spells based on their Wisdom scores. The minimum Wisdom score needed to cast a cleric, druid, paladin, or ranger spell is 10 + the spell's level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.",


    -- ###########################
    -- ######## CHARISMA #########
    -- ###########################
    ['charisma'] =
        style('t1', "Charisma") .. style('par') ..
        [[Charisma measures a character's force of personality, persuasiveness, personal magnetism, ability to lead, and physical attractiveness. This ability represents actual strength of personality, not merely how one is perceived by others in a social setting. Charisma is most important for ]] ..
        (
            style('blue', 'paladins') .. ', ' ..
            style('blue', 'sorcerers') .. ' and ' ..
            style('blue', 'bards')
        ) ..
        ". It is also important for " .. style('blue', 'clerics') .. ", since it affects their ability to turn undead. Every creature has a Charisma score." ..
        style('par') ..
        "You apply your character's Charisma modifier to:" ..
        style('t3', "   > ") .. style('regular') .. "Bluff, Diplomacy, Disguise, Gather Information, Handle Animal, Intimidate, Perform, and Use Magic Device checks. These are the skills that have Charisma as their key ability." ..
        style('t3', "   > ") .. style('regular') .. "Checks that represent attempts to influence others." ..
        style('t3', "   > ") .. style('regular') .. "Turning checks for clerics and paladins attempting to turn zombies, vampires, and other undead." ..
        style('par') ..
        [[Sorcerers and bards get bonus spells based on their Charisma scores. The minimum Charisma score needed to cast a sorcerer or bard spell is 10 + the spell's level.]] ..

        style('par') ..
        style('credits') ..
        "Pathfinder Roleplaying Game Core Rulebook. © 2010, Paizo Publishing, LLC; Author: Jason Buhlman, based on material by Jonathan Tweet, Monte Cook, and Skip Williams."
},
["equipment"] = {
    ["weapons"] = {
        ["*"] = (
            style('t1', "Weapon Rules") ..
            style('par') ..
            [[Without a doubt, weapons number among adventurers’ most coveted possessions. Whether weapons are used as tools to lay foul monsters low, as the medium for magical enhancements, or as outlets for a host of fundamental class abilities, few heroes head into the field without their favorite — or perhaps even a whole arsenal of their favorites. This section presents all manner of nonmagical weapons for PCs to purchase and put to use, whatever their adventures might entail. The weapons presented here should be relatively easy to find and purchase in most towns and cities, although GMs might wish to restrict the availability of some of the more expensive and exotic items.]] ..
            style('par') ..
            [[From the common longsword to the exotic dwarven urgrosh, weapons come in a wide variety of shapes and sizes.]] ..
            style('par') ..
            [[All weapons deal hit point damage. This damage is subtracted from the current hit points of any creature struck by the weapon. When the result of the die roll to make an attack is a natural 20 (that is, the die actually shows a 20), this is known as a critical threat (although some weapons can score a critical threat on a roll of less than 20). If a critical threat is scored, another attack roll is made, using the same modifiers as the original attack roll. If this second attack roll exceeds the target's AC, the hit becomes a critical hit, dealing additional damage.]] ..
            style('par') ..
            [[Weapons are grouped into several interlocking sets of categories. These categories pertain to what training is needed to become proficient in a weapon's use (simple, martial, or exotic), the weapon's usefulness either in close combat (melee) or at a distance (ranged, which includes both thrown and projectile weapons), its relative encumbrance (light, one-handed, or two-handed), and its size (Small, Medium, or Large).]] ..

            style('t3', "Simple, Martial, and Exotic Weapons: ") ..
            style('regular') ..
            [[Most character classes are proficient with all simple weapons. Combat-oriented classes such as barbarians, cavaliers, and fighters are proficient with all simple and all martial weapons. Characters of other classes are proficient with an assortment of simple weapons and possibly some martial or even exotic weapons. All characters are proficient with unarmed strikes and any natural weapons they gain from their race. A character who uses a weapon with which he is not proficient takes a –4 penalty on attack rolls with that weapon.]] ..

            style('t3', "Melee and Ranged Weapons: ") .. style('regular') ..
            [[Melee weapons are used for making melee attacks, though some of them can be thrown as well. Ranged weapons are thrown weapons or projectile weapons that are not effective in melee.]] ..

            style('t3', "Reach Weapons: ") .. style('regular') ..
            [[A reach weapon is a melee weapon that allows its wielder to strike at targets that aren't adjacent to him. Most reach weapons double the wielder's natural reach, meaning that a typical Small or Medium wielder of such a weapon can attack a creature 10 feet away, but not a creature in an adjacent square. A typical Large character wielding a reach weapon of the appropriate size can attack a creature 15 or 20 feet away, but not adjacent creatures or creatures up to 10 feet away.]] ..

            style('t3', "Double Weapons: ") .. style('regular') ..
            [[A character can fight with both ends of a double weapon as if fighting with two weapons, but he incurs all the normal attack penalties associated with two-weapon combat, just as though the character were wielding a one-handed weapon and a light weapon. The character can also choose to use a double weapon two-handed, attacking with only one end of it. A creature wielding a double weapon in one hand can't use it as a double weapon — only one end of the weapon can be used in any given round.]] ..

            style('t3', "Thrown Weapons: ") .. style('regular') ..
            [[The wielder applies his Strength modifier to damage dealt by thrown weapons (except for splash weapons). It is possible to throw a weapon that isn't designed to be thrown (that is, a melee weapon that doesn't have a numeric entry in the Range column on Table: Weapons), and a character who does so takes a –4 penalty on the attack roll. Throwing a light or one-handed weapon is a standard action, while throwing a two-handed weapon is a full-round action. Regardless of the type of weapon, such an attack scores a threat only on a natural 20 and deals double damage on a critical hit. Such a weapon has a range increment of 10 feet.]] ..

            style('t3', "Projectile Weapons: ") .. style('regular') ..
            [[Most projectile weapons require two hands to use (see specific weapon descriptions). A character gets no Strength bonus on damage rolls with a projectile weapon unless it's a specially built composite shortbow or longbow, or a sling. If the character has a penalty for low Strength, apply it to damage rolls when he uses a bow or a sling.]] ..

            style('t3', "Ammunition: ") .. style('regular') ..
            [[Projectile weapons use ammunition: arrows (for bows), bolts (for crossbows), darts (for blowguns), or sling bullets (for slings and halfling sling staves). When using a bow, a character can draw ammunition as a free action; crossbows and slings require an action for reloading (as noted in their descriptions). Generally speaking, ammunition that hits its target is destroyed or rendered useless, while ammunition that misses has a 50% chance of being destroyed or lost. Although they are thrown weapons, shuriken are treated as ammunition for the purposes of drawing them, crafting masterwork or otherwise special versions of them, and what happens to them after they are thrown.]] ..

            style('t2', "Light, One-Handed, and Two-Handed Melee Weapons")
            .. style('par') ..
            [[This designation is a measure of how much effort it takes to wield a weapon in combat. It indicates whether a melee weapon, when wielded by a character of the weapon's size category, is considered a light weapon, a one-handed weapon, or a two-handed weapon.]] ..

            style('t3') .. "Light: " ..
            style('regular') ..
            [[A light weapon is used in one hand. It is easier to use in one's off hand than a one-handed weapon is, and can be used while grappling (see Combat). Add the wielder's Strength modifier to damage rolls for melee attacks with a light weapon if it's used in the primary hand, or half the wielder's Strength bonus if it's used in the off hand. Using two hands to wield a light weapon gives no advantage on damage; the Strength bonus applies as though the weapon were held in the wielder's primary hand only. An unarmed strike is always considered a light weapon.]] ..

            style('t3', "One-Handed: ") .. style('regular') ..
            [[A one-handed weapon can be used in either the primary hand or the off hand. Add the wielder's Strength bonus to damage rolls for melee attacks with a one-handed weapon if it's used in the primary hand, or 1/2 his Strength bonus if it's used in the off hand. If a one-handed weapon is wielded with two hands during melee combat, add 1-1/2 times the character's Strength bonus to damage rolls.]] ..

            style('t3', "Two-Handed: ") .. style('regular') ..
            [[Two hands are required to use a two-handed melee weapon effectively. Apply 1-1/2 times the character's Strength bonus to damage rolls for melee attacks with such a weapon (see FAQ at right for more information.)]] ..

            style('t2', "Weapon Size") .. style('par') ..
            [[Every weapon has a size category. This designation indicates the size of the creature for which the weapon was designed.]] ..
            style('par') ..
            [[A weapon's size category isn't the same as its size as an object. Instead, a weapon's size category is keyed to the size of the intended wielder. In general, a light weapon is an object two size categories smaller than the wielder, a one-handed weapon is an object one size category smaller than the wielder, and a two-handed weapon is an object of the same size category as the wielder.]] ..

            style('t3', "Inappropriately Sized Weapons: ") ..
            style('regular') ..
            [[A creature can't make optimum use of a weapon that isn't properly sized for it. A cumulative –2 penalty applies on attack rolls for each size category of difference between the size of its intended wielder and the size of its actual wielder. If the creature isn't proficient with the weapon, a –4 nonproficiency penalty also applies.]] ..
            style('par') ..
            [[The measure of how much effort it takes to use a weapon (whether the weapon is designated as a light, one-handed, or two-handed weapon for a particular wielder) is altered by one step for each size category of difference between the wielder's size and the size of the creature for which the weapon was designed. For example, a Small creature would wield a Medium one-handed weapon as a two-handed weapon. If a weapon's designation would be changed to something other than light, one-handed, or two-handed by this alteration, the creature can't wield the weapon at all.]] ..

            style('par') ..
            style('credits') ..
            "Pathfinder Roleplaying Game Ultimate Equipment © 2012, Paizo Publishing, LLC; Authors: Dennis Baker, Jesse Benner, Benjamin Bruck, Ross Byers, Brian J. Cortijo, Ryan Costello, Mike Ferguson, Matt Goetz, Jim Groves, Tracy Hurley, Matt James, Jonathan H. Keith, Michael Kenway, Hal MacLean, Jason Nelson, Tork Shaw, Owen KC Stephens, and Russ Taylor." ..
            style('par') ..
            "Pathfinder RPG Core Rulebook. Copyright 2009, Paizo Publishing, LLC; Author: Jason Bulmahn, based on material by Jonathan Tweet, Monte Cook, and Skip Williams.")
    }
}
}

DATA["Racial bonus"] = (
style('t1', "+2 to One Ability Score") ..
style('par') ..
"Some races, such as humans and half-elves, get a +2 bonus to one ability of their choice at creation — instead of a fixed bonus, like most races. This represents their varied nature.\n"
)
DATA["character creation"] = (
style('t1', "Generating a Character") ..
style('par') ..
[[From the sly rogue to the stalwart paladin, a fighter who goes toe-to-toe with terrible monsters, matching sword and shield against claws and fangs, or a mystical seer who draws his powers from the great beyond to further his own ends... Nearly anything is possible.]] ..
style('par') ..
[[Once you have a general concept worked out (you can also let fate decide it for you), you can modify the fields described below and bring your idea to life. Besides its effects on game mechanics, each aspect of your character should provide some flavour to your role-playing and hopefully the wide list of possibilities should provide some replayability (for that, be sure to try some unusual combinations).]] ..

style('t3', "Name: ") ..
style('regular') ..
[[Althought it doest not affect the game mechanics, a name provides flavour to the role-playing. A large set of possible 'fantasy names' is provided for each race/gender, and you can pick one of those by pressing the <right>/<left> keys, clicking or using the mouse wheel when the name field is selected. You can also edit the name as you wish by typing and using <backspace> (again, the name field must be selected).]] ..

style('t3', "Gender: ") ..
style('regular') ..
[[Gender affects weight, height and may affect some abilities (how much it affects depends on the race). Gender may also affect some specific spells and abilities that rely on it.]] ..

style('t3', "Race: ") ..
style('regular') .. RACES_GENERIC ..

style('t3', "Class: ") ..
style('regular') ..
[[A character's class represents his/her profession, such as ]] ..
style('highlight', 'fighter') ..
" or " ..
style('highlight', 'wizard') ..
[[. If this is a new character, he starts at 1st level in his chosen class. As he gains experience points (XP) for defeating monsters, he goes up in level, granting him new powers and abilities.]] ..

style('t3', "Ability Scores: ") ..
style('regular') ..
[[The six scores (Strenght, Dexterity, Constitution, Intelligence, Wisdom and Charisma)  determine your character's most basic attributes and are used to decide a wide variety of details and statistics. Some class selections require you to have better than average scores for some of your abilities.]] ..

style('t3', "Skills: ") ..
style('regular') .. [[The number of skill ranks possessed by you character is determined by his Intelligence modifier (and any other bonuses, such as the bonus received by humans). You can spend these ranks on skills, limited to your level in any one skill (for a starting character, this is usually one).]] ..

style('t3', "Feats: ") ..
style('regular') .. [[How many feats you character receive is based on his class and level.]] ..

style('t3', "Equipment: ") ..
style('regular') .. [[Each new character begins the game with an amount of gold, based on his class, that can be spent on a wide range of equipment and gear. This gear helps your character survive while adventuring. Be sure to prepare yourself before venturing — there is a world full of danger out there!]] .. "\n\n")
collectgarbage()
return DATA
end

return get
