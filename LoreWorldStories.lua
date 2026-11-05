local _, A = ...
-- Curated Classic world journeys, not an exhaustive quest database.
-- Evidence: StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt.
-- Each entry identifies its exact evidence record. Shared titles deliberately
-- receive separate, conservative fallbacks below; an early hand-in is not a finale.
-- The supplied corpus_forever_new_quests.txt was empty: no custom lore inferred.
local P = {sources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt", "Lore.lua regional context"}, quests = {}, questIDs = {}, zones = {}, threads = {}}
local function q(id, title, zone, level, thread, importance, why1, why2, after1, after2, shared)
    local v = {title = title, zone = zone, level = level, thread = "world_" .. thread,
        importance = importance, why = {why1, why2}, after = {after1, after2},
        source = {"corpus_vanilla_quests.txt quest " .. id}}
    P.questIDs[id] = v
    if not shared then P.quests[title] = v end
end
local function fallback(title, zone, thread, ids, w1, w2, a1, a2)
    P.quests[title] = {zone = zone, thread = "world_" .. thread, importance = 3,
        why = {w1, w2}, after = {a1, a2}, source = {"corpus_vanilla_quests.txt quests " .. ids}}
end
P.threads = {
    world_ashenvale = "the work around Splintertree", world_stonetalon = "the Venture Company's machines",
    world_syndicate = "the campaign against the Syndicate", world_stromgarde = "the seals of Stromgarde",
    world_myzrael = "the imprisoned earth spirit", world_flame = "the centaur relic",
    world_centaur = "the rivalry between the centaur clans", world_burningblade = "the campaign against the Burning Blade in Desolace",
    world_kurzen = "the rebels' struggle against Colonel Kurzen", world_greenhills = "the scattered manuscript",
    world_diplomat = "the missing diplomat", world_shield = "the shield from the burned inn",
    world_uldaman = "the secrets beneath Uldaman", world_reagents = "the Badlands alchemists",
    world_nethergarde = "the supplies for Nethergarde", world_atalai = "the sunken Atal'ai temple",
    world_woodpaw = "the conflict around Camp Mojache", world_cobalt = "the buried Gordunni minerals",
    world_hinterlands = "the communities of the Hinterlands", world_hakkar = "the ancient egg and Hakkar",
    world_silithid = "the investigation of the desert insects", world_water = "the search for desert water",
    world_thorium = "the stolen fiery flux", world_elune = "the lost prayer to Elune",
    world_azshara = "the seekers in Azshara", world_ungoro = "the crater expeditions",
    world_felwood = "the effort to cleanse Felwood", world_blackrock = "the road into Blackrock",
    world_seven = "the writings of the Seven", world_andorhal = "the campaign around Andorhal",
    world_darrowshire = "the spirits of Darrowshire", world_winterfall = "the Frostfire springs",
    world_hunts = "the hunts of Winterspring", world_yeti = "the mechanical yeti",
    world_noggle = "the poisoned herbalist", world_twilight = "the campaign against the Twilight's Hammer in Silithus",
    world_waterlords = "the service of the Waterlords", world_atiesh = "the pieces of Atiesh",
    world_bear = "the teachings of the bear", world_defiler = "the fight against the Defiler of the Blasted Lands",
    world_tirion = "the Fordring family's redemption", world_hameya = "Hameya's last request",
    world_maraudon = "the broken scepter of Celebras",
}

q(2, "Sharptalon's Claw", "Ashenvale", 30, "ashenvale", 3,
    "Sharptalon had threatened the peons travelling between the lumber camps and Splintertree.",
    "The great hippogryph's claw was a trophy Senani Thunderheart could recognize.",
    "The claw confirmed Sharptalon's death and counted toward the Ashenvale Hunt.",
    "Senani accepted the trophy; one danger on the lumber workers' road had been removed.")
q(1918, "The Befouled Element", "Ashenvale", 27, "ashenvale", 3,
    "A globe of fouled water from Mystral Lake offered a sample of the contamination.",
    "The lake's sickened elemental had left evidence that Mastok might know how to use.",
    "Mastok suggested the Earthen Ring as a better judge of the foul water.",
    "The foul water set Mastok thinking of the Earthen Ring and its possible help with Mystral Lake.")
q(1093, "Super Reaper 6000", "Stonetalon Mountains", 21, "stonetalon", 3,
    "Ziz Fizziks wanted the plans for the Venture Company's enormous woodcutting machine to impress Sputtervalve. Gerenzo wanted him dead on sight, so another hand would have to steal them.",
    "The Venture Company's operators carried plans for the Super Reaper 6000. Ziz hoped the stolen designs would prove his worth to his new employer, Sputtervalve.",
    "Ziz welcomed the stolen blueprints, then struggled to read them. He blamed the baffling designs on the way gnomes thought.",
    "The blueprints delighted Ziz until he tried to understand them. Soon he was grumbling that gnomes could scarcely be trusted to invent the wheel.")
q(1096, "Gerenzo Wrenchwhistle", "Stonetalon Mountains", 27, "stonetalon", 4,
    "Gerenzo oversaw the logging site from high above Cragpool Lake, near its water wheel.",
    "The overseer's mechanical arm could provide proof of his death to Sputtervalve.",
    "Gerenzo's arm provided the required evidence that the overseer was dead.",
    "The work ended with Gerenzo out of commission and his mechanical arm delivered as proof.")
q(505, "Syndicate Assassins", "Alterac Mountains", 33, "syndicate", 3,
    "Southshore's new magistrate suspected the Syndicate of arranging the previous magistrate's murder.",
    "The investigation pointed toward a Syndicate camp north of Tarren Mill, without identifying the assassins.",
    "The Syndicate suffered losses, but responsibility for the magistrate's murder remained uncertain.",
    "Southshore welcomed the blow against the camp, though it could not prove the killers had been among the dead.")
q(549, "WANTED: Syndicate Personnel", "Hillsbrad Foothills", 22, "syndicate", 3,
    "A Forsaken bounty targeted Syndicate members gathering in the ruins of Durnholde Keep.",
    "High Executor Darthalia required proof of action against the Syndicate at Durnholde.",
    "Darthalia accepted the proof and paid the bounty against the Syndicate.",
    "The completed bounty marked a blow against the Syndicate's presence in the ruined keep.")
q(639, "Sigil of Strom", "Arathi Highlands", 37, "stromgarde", 3,
    "Trol'kalar remained sealed away, with its protecting sigils scattered among Stromgarde's survivors.",
    "One of the sigils needed to reach Trollbane's sword had fallen into Syndicate hands.",
    "The first sigil was recovered; the other protections still stood between the search and Trol'kalar.",
    "The recovered Sigil of Strom began the collection needed to open the tomb.")
q(642, "The Princess Trapped", "Arathi Highlands", 37, "myzrael", 3,
    "A voice calling itself Myzrael spoke through crystal shards and asked for motes from the Drywhisker kobolds.",
    "Myzrael claimed imprisonment beneath Arathi and sought power for another cluster of shards.",
    "The motes awakened the Drywhisker shards. Through them, Myzrael said she felt more like herself, though still far from free.",
    "Myzrael's voice answered from the newly powered shards. She welcomed their strength and pleaded that freedom was still distant.")
q(1195, "The Sacred Flame", "Ashenvale", 25, "flame", 3,
    "Water from an Ashenvale moonwell was needed for an attempt to reach a Galak centaur relic.",
    "The task began with a dryad's phial and moonwell water near the Falfarren River.",
    "The moonwell water filled Rau's request, and the phial was entrusted to the next journey into Thousand Needles.",
    "The filled phial was ready for Rau. His associate suggested a visit to Thousand Needles to carry it to him.", true)
q(1196, "The Sacred Flame", "Thousand Needles", 29, "flame", 3,
    "Rau Cliffrunner awaited the moonwell water at Freewind Post.",
    "The filled phial was intended to help breach the flame protecting the centaur relic.",
    "Rau received the water and explained that the dryads' kinship with centaurs would let it breach the relic's protective flame.",
    "At Freewind Post, Rau welcomed the phial. The moonwell water, he explained, could pierce the eternal flame through the shared ancestry of dryads and centaurs.", true)
q(1197, "The Sacred Flame", "Thousand Needles", 29, "flame", 4,
    "The Cloven Hoof lay inside Splithoof Hold behind a flame that moonwell water could briefly douse.",
    "Rau's plan allowed only a short opening in the flame guarding the centaur artifact.",
    "The Cloven Hoof reached Rau for study, its strange energy still unexplained.",
    "The relic was recovered from the Galak stronghold and its examination could begin.", true)
fallback("The Sacred Flame", "Thousand Needles", "flame", "1195,1196,1197",
    "The search for a centaur relic linked Ashenvale moonwell water with the Galak of Thousand Needles.",
    "Rau's investigation concerned the protection surrounding the Cloven Hoof.",
    "Rau Cliffrunner's effort to reach the Cloven Hoof moved forward.",
    "Rau's plan for the centaur relic behind its eternal flame went on.")
q(1367, "Magram Alliance", "Desolace", 33, "centaur", 3,
    "An approach to the Magram relied on their bitter rivalry with the Gelkis.",
    "Warug judged outsiders by the harm they had done to the Magram's enemies.",
    "Warug acknowledged the attacks on the Gelkis and allowed the dealings with the Magram to begin.",
    "The Magram accepted the proof of strength against their rivals, opening an uneasy alliance.")
q(1368, "Gelkis Alliance", "Desolace", 33, "centaur", 3,
    "The Gelkis required action against the Magram before offering an outsider their friendship.",
    "Uthek the Wise waited near the Gelkis village, where the feud shaped any possible alliance.",
    "Uthek accepted the action against the Magram and offered further work for the Gelkis.",
    "The Gelkis recognized a prospective ally through the losses inflicted on their rivals.")
q(1434, "Befouled by Satyr", "Desolace", 33, "burningblade", 3,
    "Takata Steelblade believed the satyrs preyed on pain, ambition and the desire for revenge. Their ties to the Burning Blade had brought orders from Thrall to strike them in Desolace.",
    "The Hatefury satyrs had ties to the Burning Blade. Takata Steelblade saw their cruelty as the work of an evil that found its way in through grief and hunger for power.",
    "The Hatefury lost rogues, felsworn and hellcallers. Takata promised that Thrall would hear who had helped fight them when the Desolace campaign was done.",
    "The attack drove back the Hatefury. Takata was grateful for the help and promised to carry word of it to the Warchief after the campaign.")
q(5741, "Sceptre of Light", "Desolace", 33, "burningblade", 4,
    "A Burning Blade seer studied the Sceptre of Light in a Thunder Axe watchtower.",
    "Rumors of the sceptre's power made its possession by the Burning Blade a cause for alarm.",
    "The sceptre was recovered from the Burning Blade's custody.",
    "The seer's study of the sceptre ended with the artifact removed from the fortress.")
q(202, "Colonel Kurzen", "Stranglethorn Vale", 40, "kurzen", 4,
    "Deep in the Stockpile, Colonel Kurzen commanded the men who hunted his former comrades. Doren placed the rebels' survival in the attack against him and his leaders.",
    "Doren had seen enough to hope for a direct challenge to Kurzen. The Colonel waited beyond his defenders in the depths of the Stockpile.",
    "Proof of Kurzen's defeat convinced Doren of reports he had scarcely dared believe. The rebels were free of the commander whose cruelty and cunning he feared most.",
    "Kurzen and his leaders were defeated. Doren said the rebels could breathe more easily with their former commander's cruel intellect silenced.")
q(207, "Kurzen's Mystery", "Stranglethorn Vale", 38, "kurzen", 3,
    "Brother Nimetz remembered Kurzen as a noble man. Suspecting troll magic behind his fall, he sought copies of four tablets in Stranglethorn's ruins.",
    "Troll legends might explain what had changed Kurzen. Nimetz sent for transcriptions from Bal'lal, the Vile Reef and Zul'Kunda.",
    "Nimetz received the copied legends and set out to look for a link between their magic and Kurzen's corruption.",
    "The four tablets' markings reached Nimetz. He would study their legends for an explanation of Kurzen's fall.")
q(338, "The Green Hills of Stranglethorn", "Stranglethorn Vale", 40, "greenhills", 3,
    "A gust through the hunting camp had scattered pages of Nesingwary's manuscript across the jungle.",
    "Four incomplete chapters stood between the scattered manuscript and a finished book.",
    "The four chapters were assembled and returned, rescuing the manuscript from its scattered state.",
    "The recovered chapters spared the proofreader the loss of Nesingwary's work.")
q(1324, "The Missing Diplomat", "Dustwallow Marsh", 38, "diplomat", 4,
    "The investigation had reached Hendel, whose response to the Defias accusation turned violent.",
    "Hendel's suspected part in the disappearance called for answers that a dead suspect could not give.",
    "Hendel was secured for questioning in Theramore; the search for the king remained open.",
    "The intervention kept Hendel available for questioning; a meeting with Proudmoore was the next invitation.", true)
fallback("The Missing Diplomat", "Dustwallow Marsh", "diplomat", "1241-1250,1264-1266,1274,1324",
    "The diplomat's disappearance had left an investigation spread across several settlements.",
    "Messages, witnesses and suspects formed the scattered leads in the missing diplomat's case.",
    "One more witness or clue in the missing diplomat's case had been run down.",
    "The search for the missing diplomat had another answer, and still no diplomat.")
q(1321, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "The shield recovered in the inn investigation needed a blacksmith's examination.",
    "Do'gol's craft offered a possible way to learn more from the heavy black shield.",
    "The shield reached Do'gol for examination, without yet resolving the investigation.",
    "Do'gol had the shield in hand; its owner and the fire still required investigation.", true)
q(709, "Solution to Doom", "Badlands", 40, "uldaman", 3,
    "The Tablet of Ryun'eh was sought in an ancient chest within Uldaman.",
    "The request for the tablet came with warnings of a danger the requester could scarcely name.",
    "The recovered tablet supplied the hoped-for material for study.",
    "The tablet was delivered from Uldaman; any answer to the feared danger still depended on understanding it.")
q(2258, "Badlands Reagent Run", "Badlands", 39, "reagents", 2,
    "An alchemist needed buzzard gizzards, crag coyote fangs and rock elemental shards from the Badlands.",
    "The local creatures and elementals supplied the ingredients missing from an alchemist's stores.",
    "The reagents replenished the alchemist's stock and earned the promised payment.",
    "The gathered ingredients were accepted, opening the possibility of further work in Uldaman.", true)
fallback("Badlands Reagent Run", "Badlands", "reagents", "2258,2500",
    "Badlands alchemy depended on supplies gathered from the surrounding creatures and elementals.",
    "An alchemist's work called for ingredients found in the Badlands.",
    "Buzzard gizzards, coyote fangs and rock elemental shards went into an alchemist's empty stores.",
    "The Badlands' creatures and elementals restocked an alchemist's shelves.")
q(1423, "The Lost Supplies", "Swamp of Sorrows", 40, "nethergarde", 2,
    "A wax-sealed barrel bore the name of Quartermaster Lungertz at Nethergarde Keep.",
    "Supplies went missing along the route from Darkshire to Nethergarde, and a marked barrel offered a chance to recover some.",
    "Lungertz received the recovered supplies for Nethergarde.",
    "One lost shipment reached its intended quartermaster at the keep.")
q(1424, "Pool of Tears", "Swamp of Sorrows", 43, "atalai", 3,
    "Atal'ai artifacts around the Pool of Tears could help explain the sunken temple and its green dragon guardians.",
    "The Horde's investigation began with relics outside the drowned Temple of Atal'Hakkar.",
    "The artifacts were collected for study of what had happened to the temple.",
    "The recovered objects gave the investigation material to examine, without yet exposing all the Atal'ai rites.")
q(1446, "Jammal'an the Prophet", "Swamp of Sorrows", 53, "atalai", 4,
    "An Atal'ai exile rejected Jammal'an's promise that summoning Hakkar would grant immortality.",
    "Jammal'an's prophecy had driven an exile to seek the prophet's death in the sunken temple.",
    "Jammal'an was slain, but the exile found no restored home in that revenge.",
    "The prophet's head answered the exile's request; the loss of his people remained.")
q(2862, "War on the Woodpaw", "Feralas", 42, "woodpaw", 3,
    "The Woodpaw attacks on Camp Mojache had grown unusually fierce and frequent.",
    "The camp sought gnoll manes as proof of a defense against the Woodpaw's advance.",
    "The bounty was met, but the gnolls' growing desperation still needed an explanation.",
    "The delivered manes proved losses among the attackers without explaining the pressure driving them north.")
q(2902, "Woodpaw Investigation", "Feralas", 43, "woodpaw", 3,
    "Hadoken sought the Woodpaw's plans to explain their coordinated attacks.",
    "A search among the gnolls might reveal what had changed their movements around Camp Mojache.",
    "The map showed movements southward and marks suggesting losses against large insects.",
    "The discovered plans complicated the picture, since the gnolls appeared to be fighting a threat south of the camp.")
q(2987, "Gordunni Cobalt", "Feralas", 43, "cobalt", 2,
    "The Gordunni buried their cobalt, leaving a blue glow to betray its hiding places.",
    "A borrowed shovel and the glow of buried minerals guided the cobalt search at the ogre outpost.",
    "The cobalt was delivered to a buyer intent on selling it during his travels.",
    "The excavation supplied the requested minerals and earned the promised payment.")
q(2880, "Troll Necklace Bounty", "The Hinterlands", 45, "hinterlands", 2,
    "The Wildhammers valued evidence of action against the local trolls over declarations of friendship.",
    "Tribal necklaces served as the proof required by the Wildhammer bounty.",
    "The necklaces were accepted as a step toward earning Wildhammer regard.",
    "The necklaces earned Wildhammer approval as proof of deeds behind an offer of friendship.")
q(7840, "Lard Lost His Lunch", "The Hinterlands", 49, "hinterlands", 2,
    "A Vilebranch attack had interrupted Lard's island picnic and left his lunch behind.",
    "Lard's request led back toward his picnic spot on an island north of Revantusk.",
    "The recovered lunch reached Lard, who repaid the errand with a picnic basket.",
    "Lard had his meal back after the interrupted picnic.")
q(4787, "The Ancient Egg", "The Hinterlands", 50, "hakkar", 4,
    "An ancient egg hidden behind Jintha'Alor's amphitheater was said to hold Hakkar's essence.",
    "The Prophecy of Mosh'aru pointed the search toward a relic at the summit of Jintha'Alor.",
    "The egg was recovered and delivered, while the claims about its purpose still lay ahead of their test.",
    "The ancient relic changed hands; its recovery alone did not settle the danger surrounding Hakkar.")
q(10, "The Scrimshank Redemption", "Tanaris", 48, "silithid", 4,
    "Fizzledowser's best assistant, Scrimshank, had vanished in the Gaping Chasm. His last report placed the strange insects there too; Fizzledowser asked for him, or at least his surveying gear.",
    "Scrimshank's last report carried news of insects in a second part of the desert. Now the surveyor was missing, and Fizzledowser feared that only his equipment could be recovered.",
    "Scrimshank's gear came back from the Gaping Chasm. Fizzledowser mourned the young goblin and hoped his records would give the loss some purpose; the insects' cunning made him suspect another power at work.",
    "Fizzledowser received the missing surveyor's equipment and remembered Scrimshank as a good goblin. He hoped its records could help explain insects so cunning that he feared they served an outside power.")
q(2605, "The Thirsty Goblin", "Tanaris", 49, "noggenfogger", 2,
    "Dew collectors in the cactus garden stored water in glands that might provide a drink.",
    "One goblin's thirst prompted an unusual search among the desert's water-storing creatures.",
    "The gland was delivered for an eager first taste, without yet proving the drink a success.",
    "The collected gland reached the thirsty goblin and put his idea to its first test.")
q(2768, "Divino-matic Rod", "Tanaris", 47, "water", 4,
    "Sergeant Bly had taken a divining rod needed to locate new water holes.",
    "The missing rod's trail led toward Bly's treasure-hunting band in Zul'Farrak.",
    "The divino-matic rod was returned to its owner for the search for water.",
    "The recovered instrument restored the means to choose places for new water holes.")
q(7722, "What the Flux?", "Searing Gorge", 50, "thorium", 3,
    "Maltorius had taken his former clan's fiery flux recipe into the Slag Pit.",
    "The stolen plans were thought to have helped Maltorius secure his place among the Dark Irons.",
    "The fiery flux plans were recovered for the clan that had lost them.",
    "The returned recipe allowed the clan's work with fiery flux to resume.")
q(3377, "Prayer to Elune", "Azshara", 50, "elune", 3,
    "A caged penitent asked that a lost prayer be found.",
    "The request concerned a prayer whose recovery mattered even though the captive expected no release.",
    "The captive's account established the request; the prayer itself still needed recovery.",
    "The appeal had been heard, but the golden tablet had not yet been delivered.", true)
q(3378, "Prayer to Elune", "Azshara", 50, "elune", 4,
    "A prayer etched on a golden tablet was to be recovered and taken to Astarii Starseeker.",
    "The captive sought a hearing for the prayer at Darnassus, without demanding absolution.",
    "Astarii received the prayer at the Temple of the Moon and recognized a soul returned to Elune.",
    "The recovered golden tablet brought the captive's prayer to Astarii in Darnassus.", true)
fallback("Prayer to Elune", "Azshara", "elune", "3377,3378",
    "A captive's appeal centered on a lost prayer to Elune.",
    "The prayer concerned a penitent whose past could not simply be undone.",
    "The search for the lost prayer to Elune went on for the penitent who needed it.",
    "The captive's appeal to Elune had one more piece in place.")
q(3381, "A Meeting with the Master", "Azshara", 48, "azshara", 2,
    "Sanath required hippogryph feathers before permitting an audience with his master.",
    "Access to Sanath's master depended on a small service to the gatekeeper first.",
    "The feather errand satisfied Sanath's stated condition for an audience.",
    "The feathers satisfied Sanath's price for permission to approach his master.")
q(3628, "You Are Rakh'likh, Demon", "Blasted Lands", 60, "defiler", 5,
    "Razelikh's high lair could be reached through teleport runes with the amulet as their key.",
    "The Altar of the Defiler was the appointed place to summon the demonic overlord.",
    "Razelikh fell, and his horn provided proof of the Defiler's defeat.",
    "The recovered horn marked the end of the confrontation with the Blasted Lands' demonic overlord.")
q(3881, "Expedition Salvation", "Un'Goro Crater", 53, "ungoro", 3,
    "Marshal's expedition had abandoned food and research equipment while fleeing its camps.",
    "The crater's dangers had left a stranded expedition short of both provisions and working tools.",
    "Both the food and research equipment were recovered, giving the expedition a chance to continue.",
    "Williden Marshal said the food and equipment had saved his people's lives, and called their helper a friend of Marshal Expeditions.")
q(4284, "Crystals of Power", "Un'Goro Crater", 53, "crystals", 2,
    "The crystals scattered through Un'Goro were the subject of experiments still short of an explanation.",
    "A dwindling stock of crater crystals needed replenishing before the investigation could continue.",
    "The collected crystals supplied another round of experiments.",
    "The investigator had fresh material to work with, while the crystals' power still required study.")
q(4421, "The Corruption of the Jadefire", "Felwood", 54, "felwood", 4,
    "Xavathras and the Jadefire satyrs spread corruption from the Ruins of Constellas.",
    "The Emerald Circle's efforts to heal Felwood faced active resistance from the Jadefire.",
    "Xavathras and the assigned satyrs were defeated, only a first step toward repairing Felwood.",
    "The blow against the Jadefire removed a source of harm without cleansing the forest's wider corruption.")
q(5155, "Forces of Jaedenar", "Felwood", 51, "felwood", 3,
    "Greta Mosshoof would not trust an offer of help on words alone. The Shadow Council plotted with the Burning Legion in Jaedenar's corrupted barrow dens, and she called for a strike inside them.",
    "The Shadow Council had taken over Jaedenar's barrow dens. Greta Mosshoof demanded a blow against its followers before she would trust a newcomer with more of her work.",
    "Council cultists, guards and their hounds fell in Jaedenar. Greta welcomed their losses; with fewer enemies in the dens, she could press them harder.",
    "The assault on the dens killed hounds and followers of the Shadow Council. Greta saw the chance to push further, and set aside the tale of the fighting for more urgent matters.")
q(4182, "Dragonkin Menace", "Burning Steppes", 54, "blackrock", 3,
    "Helendis Riverhorn remembered that the Burning Steppes had once belonged to the Redridge range, before the great explosion. Black dragonkin now gathered below his ridge, and he needed help pushing them back.",
    "Black dragonkin crowded the ground below Helendis Riverhorn's ridge. Amid the shattered buildings of the Burning Steppes, he called for an attack on the broodlings, dragonspawn and drakes.",
    "The fighting cut through the black dragonkin, including a drake. Helendis welcomed the news and offered to discuss the more pressing trouble behind his request.",
    "Broodlings, dragonspawn and a black drake fell below the ridge. Satisfied with the dragon hunt, Helendis was ready to speak of other dangers.")
q(4296, "Tablet of the Seven", "Burning Steppes", 50, "seven", 3,
    "The ruins of Thaurissan were said to hold a tablet preserving knowledge of the Seven.",
    "A seeker of dwarven secrets wanted a transcription from the Tablet of the Seven.",
    "The copied text was delivered and paid for, leaving its deeper secrets to be studied.",
    "The recovered transcription preserved the tablet's words beyond the ruins of Thaurissan.")
q(5097, "All Along the Watchtowers", "Western Plaguelands", 56, "andorhal", 4,
    "Four watchtowers in Andorhal were to be marked with beacons for a later attack.",
    "The towers were suspected of coordinating Scourge movements, making them priority targets.",
    "All four beacon signals were confirmed; the attack they prepared was still to come.",
    "Strong signals from all four towers gave the planned assault on Andorhal its marked targets.", true)
fallback("All Along the Watchtowers", "Western Plaguelands", "andorhal", "5097,5098",
    "Andorhal's watchtowers were targets for beacon marking ahead of an assault.",
    "The campaign required signals at the towers believed to direct Scourge movement.",
    "Beacons now marked Andorhal's watchtowers ahead of the planned assault.",
    "The watchtowers' beacon signals completed preparations for the planned attack on Andorhal.")
q(5215, "The Scourge Cauldrons", "Western Plaguelands", 53, "andorhal", 3,
    "The Scourge cauldrons spread plague, but their necromantic strength prevented simply shutting them down.",
    "A proposed countermeasure aimed to alter the cauldrons' contents against the Scourge.",
    "The briefing with High Priestess MacDonnell established the plan; access to the cauldrons remained to be secured.",
    "The operation had its coordinator and objective, while the work at the four western cauldrons still lay ahead.", true)
q(5228, "The Scourge Cauldrons", "Western Plaguelands", 53, "andorhal", 3,
    "Derrington entrusted Shadow Priestess Vandis with a plan to turn the Scourge's plague cauldrons against their makers.",
    "Kel'Thuzad's power protected the plague cauldrons, so Derrington sought a way to turn their poisons against the Scourge.",
    "At the Bulwark, Vandis explained how she hoped to make the cauldrons' plague harmful to the Scourge.",
    "Vandis laid out a plan to reach the four western cauldrons and change the plague they spread.", true)
fallback("The Scourge Cauldrons", "Western Plaguelands", "andorhal", "5215,5228",
    "The Scourge's plague cauldrons called for an indirect countermeasure.",
    "The proposed operation sought to turn the cauldrons' output against their makers.",
    "The plan to turn the plague cauldrons against the Scourge had been laid out.",
    "The work had reached its initial briefing, without yet securing the cauldrons.")
q(5142, "Little Pamela", "Eastern Plaguelands", 55, "darrowshire", 3,
    "When the battle of Darrowshire began, Marlene Redpath hid her niece Pamela. Now a wandering spirit, Marlene still did not know what had become of the child.",
    "Marlene Redpath's spirit longed for news of Pamela, the niece she had hidden during Darrowshire's battle. She asked for a search among the ruins to the east.",
    "Pamela was found in Darrowshire. She introduced herself and asked her visitor's name.",
    "The search ended with Pamela's simple greeting. She gave her name and wanted to know who had come to see her.")
q(5149, "Pamela's Doll", "Eastern Plaguelands", 55, "darrowshire", 3,
    "Pamela had waited for her father in Darrowshire without the doll left elsewhere in town.",
    "Among the ruined houses, a child's lost doll gave the search a small and immediate purpose.",
    "The recovered doll was returned to Pamela.",
    "Pamela had her doll again, even as the larger tragedy of Darrowshire remained unresolved.")
q(5721, "The Battle of Darrowshire", "Eastern Plaguelands", 60, "darrowshire", 6,
    "Relics in Darrowshire's square could call up the battle's spirits and offer a chance to save Joseph Redpath's spirit.",
    "The spectral battle required Davil to survive Horgus and Redpath's corrupted form to be defeated.",
    "Redpath's spirit was saved, and Pamela heard her father's promise to come home.",
    "The struggle among the spirits ended with Redpath freed from corruption and Pamela awaiting his return.")
q(5054, "Ursius of the Shardtooth", "Winterspring", 56, "hunts", 3,
    "Storm Shadowhoof called for the death of Ursius, a cunning shardtooth bear roaming the slopes northwest of Everlook.",
    "Storm warned that Ursius had turned earlier hunters into prey among Winterspring's snowy hills.",
    "Ursius was slain, and Storm acknowledged the difficult hunt with guarded approval.",
    "Storm recognized the skill it had taken to kill Ursius, though he remained sparing with praise.")
q(5082, "Threat of the Winterfall", "Winterspring", 56, "winterfall", 3,
    "Donova Snowden was studying the Frostfire Hot Springs, but Winterfall furbolgs barred her from the larger pools.",
    "Donova sought the source of the springs' strange qualities while the Winterfall fiercely guarded their waters.",
    "With the Winterfall driven back, Donova could resume her studies at the springs.",
    "Donova could study the waters again and asked whether anything unusual had turned up in the Winterfall camp.")
q(3783, "Are We There, Yeti?", "Winterspring", 56, "yeti", 2,
    "A planned mechanical yeti needed thick fur from the local ice thistle yetis.",
    "The invention's first requirement was a covering for its mechanical parts.",
    "The fur was delivered, providing a start on the mechanical yeti.",
    "The inventor accepted the furs; the horns and demonstration were still ahead.", true)
q(977, "Are We There, Yeti?", "Winterspring", 58, "yeti", 2,
    "Umi Rumplesnicker's mechanical yeti needed two unbroken horns from ice thistle patriarchs or matriarchs.",
    "Umi had fur for her mechanical yeti, but its head still needed the finest horns the local yetis could supply.",
    "Umi attached the recovered horns, finishing the yeti's appearance for the surprise she had planned.",
    "The horns completed Umi's mechanical yeti; showing it to her friends was the next part of her scheme.", true)
q(5163, "Are We There, Yeti?", "Winterspring", 58, "yeti", 3,
    "Umi had a mechanical yeti ready to spring on Legacki in Everlook, Sprinkle in Gadgetzan and Quixxil at Marshal's Refuge.",
    "Umi's friends had mocked her ideas, and her finished mechanical yeti was meant to give all three a fright.",
    "Legacki, Sprinkle and Quixxil had each met Umi's surprise, and the mechanical yeti was returned to her.",
    "With all three friends startled and her yeti back, Umi had the answer she wanted for their teasing.", true)
fallback("Are We There, Yeti?", "Winterspring", "yeti", "3783,977,5163",
    "A mechanical yeti project mixed practical construction with a planned surprise for friends.",
    "The inventor's scheme required materials and, eventually, a demonstration.",
    "The mechanical yeti project in Everlook moved forward.",
    "Work on the mechanical yeti and its planned surprise went on.")
q(8277, "Deadly Desert Venom", "Silithus", 55, "noggle", 3,
    "Noggle returned from gathering herbs with a poison Beetix could slow but not yet neutralize.",
    "Scorpid stingers and spider fangs might identify the venom threatening the herbalist.",
    "The samples reached Beetix for an attempted antidote; Noggle's recovery was not yet assured.",
    "The gathered venom gave Beetix material to work with, while the treatment's result remained uncertain.")
q(8284, "The Twilight Mystery", "Silithus", 58, "twilight", 3,
    "Elementals occupied the wreckage of a Twilight's Hammer camp where clay tablet fragments remained.",
    "A broken tablet offered clues to the cult's activity amid scattered wood and canvas.",
    "The fragments were recovered, but their words proved to be concealed by a code.",
    "The assembled text led to the need for someone familiar with Twilight ciphers.")
q(8279, "The Twilight Lexicon", "Silithus", 60, "twilight", 4,
    "Three Twilight Keepers held separate chapters of the lexicon needed to decode the tablet.",
    "A former cultist needed the scattered cipher book to make sense of the secret text.",
    "The three chapters were gathered and decoding could begin.",
    "The recovered lexicon supplied the missing tool for interpreting the tablet.")
q(8320, "Twilight Geolords", "Silithus", 60, "twilight", 3,
    "Twilight geolords directed rituals in the camps west of Cenarion Hold.",
    "The cult's suspected link to the pulsing red crystals remained unclear, but its leaders presented an immediate target.",
    "The geolords were struck down, disrupting the camps without resolving the cult's larger plan.",
    "The assigned attack dealt the cult a local setback while the crystal mystery remained.")
q(6821, "Eye of the Emberseer", "Azshara", 60, "waterlords", 4,
    "The Waterlords required proof against Pyroguard Emberseer, a fire servant imprisoned high in Blackrock Spire.",
    "The Emberseer's eye was the chosen test of strength against a more powerful enemy of the Waterlords.",
    "The eye was delivered and accepted as proof of success against the Emberseer.",
    "The completed mission established greater standing with the Waterlords without ending their war.")
q(6823, "Agent of Hydraxis", "Azshara", 60, "waterlords", 4,
    "Service to the Waterlords required a sustained campaign against their elemental enemies.",
    "Hydraxis demanded more than a single errand before recognizing an allegiance.",
    "The campaign earned the Waterlords' respect and recognition.",
    "Hydraxis acknowledged the demonstrated service against the Waterlords' enemies.")
q(7487, "Attunement to the Core", "Blackrock Mountain", 60, "blackrock", 5,
    "Lothos required a core fragment from Blackrock Depths to attune passage through his portal.",
    "A rift into the Firelord's domain could be used only after the requested attunement.",
    "The fragment secured attunement to the portal into the Molten Core.",
    "The recovered fragment attuned the traveler to the rift beside Lothos, opening a way into the Firelord's domain.", true)
fallback("Attunement to the Core", "Blackrock Mountain", "blackrock", "7487,7848",
    "A fragment from Blackrock Depths was needed for attunement to the Core's portal.",
    "Lothos offered access through the rift after the recovery of a core fragment.",
    "Lothos Riftwaker took the core fragment as the price of passage through his rift.",
    "Access through the portal was established; the dangers within remained a separate undertaking.")
q(7761, "Blackhand's Command", "Blackrock Spire", 60, "blackrock", 5,
    "Blackhand's letter revealed that the orb required the Mark of Drakkisath.",
    "The protection on the route into Blackwing depended on a brand guarded by Drakkisath.",
    "Drakkisath's smoldering brand left the Mark of Drakkisath on its bearer's hand, the sign Blackhand's orb demanded for passage into Blackwing.",
    "The Mark of Drakkisath satisfied the orb's ward, opening the way into Blackwing.")
q(4742, "Seal of Ascension", "Blackrock Spire", 60, "blackrock", 4,
    "Three gemstones from the lower citadel's leadership were needed to fill an unadorned seal.",
    "The seal's empty sockets made the search among Blackrock's commanders a necessary first stage.",
    "The pieces formed an Unforged Seal of Ascension; the final forging remained.",
    "The gemstones were assembled, leaving the seal ready for the next step rather than complete.", true)
q(4743, "Seal of Ascension", "Dustwallow Marsh", 60, "blackrock", 5,
    "Emberstrife's breath in the Wyrmbog could forge the seal if the drake's will was first broken.",
    "The final forging depended on briefly controlling Emberstrife and directing his flame.",
    "The forged seal received Vaelan's final protective invocation and was complete.",
    "The Seal of Ascension was finished, carrying the protective wards added by Vaelan.", true)
fallback("Seal of Ascension", "Blackrock Spire", "blackrock", "4742,4743",
    "The Seal of Ascension required gemstones and a final forging in dragon flame.",
    "The work on the seal connected Blackrock's commanders with the power of dragonfire.",
    "Work on the Seal of Ascension went forward.",
    "Vaelan's plan for the Seal of Ascension came a step closer.")
q(9251, "Atiesh, the Befouled Greatstaff", "Tanaris", 60, "atiesh", 6,
    "The remaining pieces of Atiesh lay with Kel'Thuzad in Naxxramas and within Ahn'Qiraj.",
    "The dangerous staff could not be restored without recovering its separated pieces.",
    "The recovered pieces revealed the presence of an otherworldly being within the staff.",
    "The components were brought together for examination, but the being inside still required attention.")
q(9257, "Atiesh, Greatstaff of the Guardian", "Stratholme", 60, "atiesh", 6,
    "Consecrated ground in Stratholme offered a place to draw the demonic being out of Atiesh.",
    "The final cleansing required confronting the entity that controlled the befouled staff.",
    "The demon was defeated and the staff returned for the completion of its restoration.",
    "The cleansing task was complete, ending the entity's hold over the staff.", true)
fallback("Atiesh, Greatstaff of the Guardian", "Stratholme", "atiesh", "9257,9269,9270,9271",
    "The restoration of Atiesh required a final confrontation with the being within it.",
    "The staff's corruption had to be addressed before its restoration could be completed.",
    "The corruption within Atiesh had been faced.",
    "The work to cleanse the staff had reached its conclusion.")
q(5921, "Moonglade", "Moonglade", 10, "bear", 3,
    "Dendrite Starblaze in Nighthaven offered the first guidance on the druidic path of the bear.",
    "Moonglade welcomed druids seeking instruction despite tensions within the Cenarion Circle.",
    "Dendrite's introduction began the instruction; mastery of the bear still lay ahead.",
    "The first meeting established the next lesson without yet completing bear training.", true)
fallback("Moonglade", "Moonglade", "bear", "5921,5922,94913,94914",
    "Nighthaven was a place of druidic teaching within the sacred lands of Moonglade.",
    "The journey to Moonglade led toward instruction among the druids.",
    "The journey to Nighthaven in Moonglade was made.",
    "The visit established the next step in druidic instruction.")
q(5929, "Great Bear Spirit", "Moonglade", 10, "bear", 3,
    "The Great Bear Spirit taught in northwestern Moonglade before the next lesson with Dendrite.",
    "Dendrite required the spirit's instruction as preparation for understanding the bear.",
    "The spirit's lesson was completed, preparing the next stage of bear training.",
    "Dendrite accepted the return from the Great Bear Spirit; adopting the bear's form remained a further lesson.", true)
q(5930, "Great Bear Spirit", "Moonglade", 10, "bear", 3,
    "The Great Bear Spirit in northwestern Moonglade had taught every druid the first true understanding of the bear. That lesson had to come before Dendrite would go on.",
    "Every druid sought the Great Bear Spirit's wisdom at some point. Until the spirit released the student, Dendrite would wait in Nighthaven.",
    "Dendrite Starblaze sensed new wisdom in the student, strength not yet focused. Focusing it into the nature of the bear was the next lesson.",
    "Dendrite saw that the Great Bear Spirit had taught well, and named the bear's nature as the next lesson.", true)
P.questIDs[5930].source[2] = "https://classicdb.ch/?quest=5930; world3 pass: mirrors 5929's boundary, adopting the form is a later lesson"
fallback("Great Bear Spirit", "Moonglade", "bear", "5929,5930",
    "The Great Bear Spirit's instruction was a required part of the druidic lesson.",
    "Dendrite sent students to the spirit before continuing the path of the bear.",
    "The Great Bear Spirit had given its teaching, and the path led back to Dendrite.",
    "The return to Dendrite followed the lesson without yet establishing a learned transformation.")
q(5846, "Of Love and Family", "Western Plaguelands", 58, "tirion", 4,
    "Tirion remembered a family portrait painted by Renfray during an excursion to Caer Darrow.",
    "The ruined island might still hold the painting or the artist who had known the Fordrings.",
    "Renfray's spirit was found with knowledge of the painting's fate.",
    "The search reached the artist, but the portrait itself remained to be recovered.", true)
q(5848, "Of Love and Family", "Stratholme", 60, "tirion", 5,
    "Renfray had hidden the Fordring portrait under a painting of the twin moons in the Scarlet Bastion.",
    "Tirion's family portrait survived beneath another layer of paint inside Stratholme.",
    "The uncovered portrait was returned to Tirion, who recognized the preserved image of his family.",
    "The recovered painting brought Tirion the image of the family he had lost.", true)
fallback("Of Love and Family", "Western Plaguelands", "tirion", "5846,5848",
    "Tirion's search concerned a family portrait painted before the losses that divided the Fordrings.",
    "Renfray's painting preserved an earlier moment in the Fordring family's life.",
    "Tirion's wish for Renfray's painting of his family moved closer.",
    "The search for the Fordring portrait went on.")
q(5944, "In Dreams", "Western Plaguelands", 60, "tirion", 6,
    "Taelan sought reunion with his father after breaking with the course of the Scarlet Crusade.",
    "The attempt to bring Taelan to Tirion carried the family's hope beyond the recovered keepsakes.",
    "Taelan died, and Tirion answered the loss by taking up the work of a renewed Silver Hand.",
    "The attempted reunion ended in Taelan's death and Tirion's resolve to rebuild the Order.")
q(6024, "Hameya's Plea", "Eastern Plaguelands", 60, "hameya", 4,
    "Hameya's written plea described an infection driving him toward Zul'Mashar to spread the plague.",
    "Before his will failed, Hameya had left a request for death and directions to a buried chest.",
    "Hameya's key opened the buried chest after the plea had been answered.",
    "The request ended with the recovered key and the opening of Hameya's hidden chest.")
q(7044, "Legends of Maraudon", "Desolace", 49, "maraudon", 5,
    "Cavindra's brother Celebras wandered Maraudon under a curse. She sent for the two pieces of his scepter, stolen by Vyletongue and Noxxion, in the hope that he could be reached.",
    "Beyond Maraudon's purple and orange crystals, Vyletongue and Noxxion held the pieces of Celebras's scepter. His sister Cavindra sought help for the brother lost to their corruption.",
    "Celebras spoke of waking from a long nightmare. With both scepter pieces recovered, he could hope that Maraudon might one day be cleansed.",
    "The recovered rod and diamond gave the awakened Celebras hope for Maraudon. He spoke as one newly released from a nightmare.", true)

-- The local corpus also contains these later Moonglade variants. They acknowledge
-- an existing bear form; they do not teach or award that form in this hand-in.
q(94913, "Moonglade", "Moonglade", 10, "bear", 3,
    "Keeper Remulos watched over the refuge where Dendrite offered druidic guidance.",
    "The introduction directed a druid to Dendrite Starblaze in Nighthaven.",
    "Dendrite acknowledged existing mastery of the bear form and welcomed further instruction.",
    "Dendrite welcomed a druid who had already mastered the bear form and acknowledged that progress.", true)
q(94914, "Moonglade", "Moonglade", 10, "bear", 3,
    "Nighthaven offered instruction under Moonglade's protection.",
    "Dendrite Starblaze awaited the introduction in the druids' refuge.",
    "Dendrite recognized bear training already accomplished before this meeting.",
    "The welcome in Nighthaven acknowledged an existing form and pointed toward further learning.", true)

-- Connected journeys. Quest/Progress/Completion in the cited local record are
-- the evidence; uncertain explanations remain attributed to their investigators.
P.threads.world_raene = "the search for Dartol's rod"
P.threads.world_gormul = "the attempt to help Gor'mul"
P.threads.world_noggenfogger = "Marin's desert drink"
P.threads.world_crystals = "the crystal pylons of Un'Goro"
P.threads.world_ringo = "the missing crater explorer"

q(991, "Raene's Cleansing", "Ashenvale", 19, "raene", 4,
    "Teronis had gone to Lake Falathim seeking a gem for a rod that might help against the furbolg attacks.",
    "Raene's missing friend had left a lead at a shrine overrun by murlocs.",
    "Teronis was found dead on the island, his search unfinished.",
    "The search reached Teronis's body; the wounds told why he had never returned to Raene.", true)
q(1023, "Raene's Cleansing", "Ashenvale", 21, "raene", 4,
    "Teronis's surviving journal and the gem offered a way to continue his work.",
    "The gem sought at Lake Falathim still mattered, even after the discovery of Teronis's body.",
    "Raene received the journal and gem and arranged for Sentinels to recover her friend's body.",
    "News of Teronis's death reached Raene with the materials needed to carry his task forward.", true)
q(1024, "Raene's Cleansing", "Ashenvale", 21, "raene", 3,
    "Teronis's notes pointed toward the remaining pieces of Dartol's rod.",
    "Shael'dryn, at the moonwell east of Iris Lake, could help interpret the unfinished search.",
    "Shael'dryn received Raene's introduction; the rod still needed its missing pieces.",
    "The search reached the dryad at the moonwell, where work on Dartol's rod could continue.", true)
q(1026, "Raene's Cleansing", "Ashenvale", 27, "raene", 3,
    "A corrupted treant near Felwood carried the key to a hidden glade chest. Shael'dryn knew another piece of Dartol's rod lay inside.",
    "Shael'dryn pointed toward a hidden chest near the Felwood border. The treant carrying its wooden key had been twisted by the corruption that troubled her so deeply.",
    "The chest yielded the rod's iron shaft. Shael'dryn welcomed its recovery, though she wished she could do more for the corrupted treants.",
    "The iron shaft reached Shael'dryn from the hidden chest. The treants' corruption weighed on her; she wished she could do more to help them.", true)
q(1027, "Raene's Cleansing", "Ashenvale", 28, "raene", 3,
    "The druids of Dor'danil had kept the rod's final piece, but they had been killed. Shael'dryn could point toward their shelter, though she did not know the piece's hiding place.",
    "The search for the final piece led toward the shelter of Dor'danil's slain druids. Shael'dryn promised to help rebuild the rod once it was found.",
    "The iron pommel reached Shael'dryn. She called the find wonderful news for Raene and turned her thoughts to repairing the rod.",
    "Shael'dryn welcomed the rod's final piece as wonderful news for Raene. Now she could see about putting it together.", true)
q(1028, "Raene's Cleansing", "Ashenvale", 28, "raene", 4,
    "Shael'dryn had rebuilt the rod, but only a hidden shrine could restore its power.",
    "The repaired rod needed the magic of a shrine concealed among the mountains.",
    "The shrine re-enchanted the rod, leaving it whole and charged in the basin.",
    "Dartol's rod recovered its enchantment at the shrine; its use among the furbolgs still lay ahead.", true)
q(1055, "Raene's Cleansing", "Ashenvale", 28, "raene", 3,
    "Shael'dryn awaited news that the rebuilt rod had taken the shrine's enchantment.",
    "The finished rod gave the dryad an answer to the work begun with Teronis's gem.",
    "Shael'dryn learned that the rod was complete.",
    "The report closed the dryad's part in restoring Dartol's creation.", true)
q(1029, "Raene's Cleansing", "Ashenvale", 28, "raene", 3,
    "With Dartol's rod restored, Shael'dryn sent word to Raene in Astranaar. Teronis's unfinished search had finally borne fruit.",
    "Shael'dryn directed news of the completed rod to Raene, trusting her to know what should come next.",
    "Raene said Teronis would be proud. The search he had begun was continuing after his death.",
    "The news delighted Raene. She thought Teronis would be proud to see his work carried on after his death.", true)
q(1030, "Raene's Cleansing", "Ashenvale", 28, "raene", 4,
    "Dartol's rod offered a disguise for approaching a furbolg untouched by Fel Moss.",
    "Raene's search turned toward an uncorrupted furbolg southeast of Mystral Lake.",
    "The disguised approach reached a furbolg who described exile from his corrupted kin and blamed the night elves.",
    "The rod made contact possible with an uncorrupted furbolg, whose account gave the conflict another voice.", true)
q(1045, "Raene's Cleansing", "Ashenvale", 30, "raene", 5,
    "Ran Bloodtooth's violence troubled even a furbolg who bitterly resented the night elves.",
    "The uncorrupted furbolg sought an end to Ran's attacks, refusing to excuse them with the elves' failures.",
    "Ran Bloodtooth was slain, removing one violent leader from a forest that remained tainted.",
    "The furbolg welcomed Ran's defeat as a small repair to Ashenvale, not a cure for its corruption.", true)
q(1046, "Raene's Cleansing", "Ashenvale", 30, "raene", 5,
    "Ran's skull could carry news of the completed task back to Raene and the Sentinels.",
    "The work begun by Teronis now had a trophy to bring home to Astranaar.",
    "Raene received Ran's skull and intended to honor it alongside Dartol's rod in memory of the work Teronis began.",
    "The report brought Teronis's unfinished task back to Raene with proof that Ran's threat had ended.", true)
fallback("Raene's Cleansing", "Ashenvale", "raene", "991,1023,1024,1026,1027,1028,1055,1029,1030,1045,1046",
    "Raene's work concerned the furbolg attacks and Teronis's search for Dartol's rod.",
    "The search for a strange rod offered one approach to Ashenvale's furbolg troubles.",
    "Raene Wolfrunner's work against Ashenvale's troubles had one more piece in place.",
    "The task advanced the effort connected with Teronis's search, without establishing its final result.")

q(1068, "Shredding Machines", "Stonetalon Mountains", 23, "stonetalon", 4,
    "A shaman's account of the suffering tree spirits singled out the shredders XT:4 and XT:9.",
    "Two marked machines in Windshear Crag cut timber at a pace that threatened the woods.",
    "The shredders XT:4 and XT:9 were destroyed. The shaman reported that many tree spirits were soothed, and hoped the Venture Company would leave.",
    "With the two shredders stopped, the shaman heard relief among Stonetalon's spirits. The hope now was that the company would withdraw.")
q(1095, "Further Instructions", "Stonetalon Mountains", 27, "stonetalon", 3,
    "Gerenzo's employment by the Venture Company had drawn opposition within goblin trade circles.",
    "Sputtervalve's instructions turned the stolen engineering plans into a task against their designer.",
    "Fizziks received the order to eliminate Gerenzo and agreed to the task.",
    "The instructions reached Fizziks; Gerenzo's removal was still work to be done.", true)
fallback("Further Instructions", "Stonetalon Mountains", "stonetalon", "1094,1095",
    "Fizziks and Sputtervalve exchanged information about Venture Company engineering.",
    "The plans for the Super Reaper had become part of a dispute over the Company's machines.",
    "The next instructions in the engineering dispute reached their destination.",
    "The exchange continued the work around the Venture Company's machinery.")

q(640, "The Broken Sigil", "Arathi Highlands", 40, "stromgarde", 3,
    "Galen Trollbane had divided the Sigil of Thoradin into eleven pieces among Stromgarde's defenders.",
    "Tor'gan could restore the broken sigil if its scattered pieces were recovered.",
    "Tor'gan received all eleven pieces and found the sigil's magical structure fit for reconstruction.",
    "The broken sigil reached the shaman with no pieces missing; the tomb's other protections remained.")
q(641, "Sigil of Thoradin", "Arathi Highlands", 40, "stromgarde", 3,
    "Tor'gan's restored sigil was ready to be taken back to Zengu.",
    "Reconstruction had made the Sigil of Thoradin usable against the tomb's seal.",
    "Zengu received the second sigil and turned attention to the remaining protections.",
    "The repaired sigil joined the collection at Hammerfall; Trol'kalar was still sealed away.")
q(643, "Sigil of Arathor", "Arathi Highlands", 41, "stromgarde", 3,
    "Lieutenant Valorcall carried a sigil while leading Stromgarde's cavalry across Arathi.",
    "The mobile cavalry patrol made the next protection of Trollbane's tomb difficult to reach.",
    "Valorcall's sigil was recovered, leaving one more needed for the tomb.",
    "The cavalry leader fell and the Sigil of Arathor reached Zengu, but the sword remained beyond the final ward.")
q(644, "Sigil of Trollbane", "Arathi Highlands", 42, "stromgarde", 4,
    "Prince Galen guarded the last sigil inside Stromgarde's militia-held chapel.",
    "The remaining protection of Thoras's tomb rested with his son and the defenders around him.",
    "Galen's sigil completed the set needed to reach Trol'kalar.",
    "The final sigil was in Zengu's possession; taking the sword from the tomb was the next task.")
q(645, "Trol'kalar", "Arathi Highlands", 42, "stromgarde", 4,
    "The four sigils had joined into one whose markings matched Trollbane's tomb.",
    "The Sanctum behind Stromgarde's chapel held the sword behind its last wardings.",
    "The combined sigil was consumed in a flash, releasing Trol'kalar from the stone hands.",
    "The tomb's ward opened and the sword was freed; delivery to Zengu still remained.", true)
q(646, "Trol'kalar", "Arathi Highlands", 42, "stromgarde", 5,
    "The freed sword had to reach Zengu before it could serve the Darkspear's plans.",
    "Trol'kalar's release from the tomb left the final handover at Hammerfall.",
    "Zengu received the sword and promised to send it to Nimboya at Grom'gol.",
    "Trol'kalar entered Darkspear hands; the planned battles in Zul'Gurub were still ahead.", true)
fallback("Trol'kalar", "Arathi Highlands", "stromgarde", "645,646",
    "Trollbane's sword was the object of Zengu's work around Stromgarde.",
    "The Darkspear sought Trol'kalar for their struggle against the trolls of Zul'Gurub.",
    "The task advanced the recovery of Trol'kalar from Stromgarde.",
    "The recovery of Trollbane's sword advanced the Darkspear's preparations for Zul'Gurub.")
q(651, "Stones of Binding", "Arathi Highlands", 38, "myzrael", 3,
    "Myzrael claimed that keys from three stones could unlock the Stone of Inner Binding.",
    "The voice beneath Arathi directed the search among guarded stones that maintained its prison.",
    "Through the opened stones, Myzrael announced that her shackles were loosening and called her helper a rescuer.",
    "The Stones of Binding opened. Myzrael's voice came through them with thanks, for she could feel her restraints loosen.")
q(652, "Breaking the Keystone", "Arathi Highlands", 42, "myzrael", 4,
    "Fozruk carried the Rod of Order needed to open the Keystone's remaining lock.",
    "Myzrael's promised release depended on a stone watcher's key and the charged Keystone.",
    "The Rod of Order was placed in the Keystone, and a shudder passed through the ground.",
    "Fozruk's Rod of Order fitted the Keystone. The ground beneath it shuddered.")
q(688, "Myzrael's Allies", "Arathi Highlands", 40, "myzrael", 3,
    "Myzrael spoke of gathering strength out of the giants' reach. She named Zaruk in Hammerfall as the ally who knew how to summon her to the surface.",
    "Myzrael promised to confront the giants once she was stronger. For the summoning she planned, she directed the search to Zaruk in Hammerfall.",
    "Zaruk was expecting the visit, because the Lady had told him. He welcomed a discussion of how to bring her to the surface.",
    "The introduction found Zaruk ready to discuss Myzrael's summoning. She had already warned him to expect company.", true)
fallback("Myzrael's Allies", "Arathi Highlands", "myzrael", "653,688",
    "Myzrael directed the search toward an ally who knew about summoning her.",
    "The spirit's plan to regain strength depended on help beyond the binding stones.",
    "Contact was made with an ally of Myzrael, leaving the summoning ahead.",
    "The introduction continued Myzrael's plan without bringing her to the surface.")
q(656, "Summoning the Princess", "Arathi Highlands", 50, "myzrael", 5,
    "The effort now called for Myzrael to be defeated before she could challenge the giants who had bound her.",
    "The shards where Myzrael had first asked for help became the place to summon and imprison her again.",
    "Myzrael was defeated and her Eldritch Shackles bound to the shards, trapping her beneath Arathi once more.",
    "The shackles restored Myzrael's prison, and the shards that once offered reassurance pulsed with menace.")
q(655, "Hammerfall", "Arathi Highlands", 34, "gormul", 3,
    "Gor'mul remained haunted by Doomhammer's death during the liberation of the internment camp.",
    "Hammerfall's return to orc hands had not restored the former captive's hope.",
    "Gor'mul's history was explained. He had been left behind and wandered until the Horde returned to Hammerfall.",
    "The inquiry revealed a survivor still living with the loss of Doomhammer, rather than a wound the reclaimed camp had healed.")
q(672, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "Tor'gan hoped an amulet bearing raptor strength might reach Gor'mul where stories of Thrall had failed.",
    "Raptor eyes were needed for a small shamanic gift to the dispirited veteran.",
    "The eyes reached Tor'gan for the amulet; Gor'mul had yet to receive it.",
    "The materials for Tor'gan's gift were gathered, but its effect on the veteran was still unknown.", true)
q(674, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "Tor'gan's amulet was meant to show Gor'mul something of the Horde's renewed shamanic strength.",
    "A small gift carried the hope that the old warrior might find a reason to go on.",
    "Gor'mul dismissed the amulet as polished bone and doubted that a trinket could restore the Horde.",
    "The amulet reached Gor'mul, but the offered comfort did not overcome his despair.", true)
q(675, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "Gor'mul had thrown the amulet down, leaving Tor'gan's attempt at comfort unanswered.",
    "The veteran's rejection had to be reported to the shaman who had prepared the gift.",
    "Tor'gan learned that the amulet had failed and still hoped a stronger demonstration might help.",
    "The report brought Tor'gan no good news. Gor'mul had rejected the amulet.", true)
fallback("Raising Spirits", "Arathi Highlands", "gormul", "672,674,675",
    "Tor'gan sought a way to help Gor'mul through the loss that still shadowed his life at Hammerfall.",
    "The shaman's small amulet was part of an attempt to reach a dispirited veteran.",
    "Tor'gan's attempt to comfort Gor'mul went on.",
    "The errand served Tor'gan's effort to reach the veteran through a shaman's gift.")

q(203, "The Second Rebellion", "Stranglethorn Vale", 33, "kurzen", 3,
    "The rebels opposing Kurzen faced a tactician whose troops vastly outnumbered their camp.",
    "The rebels asked for a strike against the Jungle Fighters before reinforcements could close in.",
    "Losses among Kurzen's Jungle Fighters relieved some of the pressure on the rebel camp.",
    "The strike gave the outnumbered rebels breathing room while Kurzen's larger force remained.")
q(204, "Bad Medicine", "Stranglethorn Vale", 34, "kurzen", 3,
    "Kurzen's Medicine Men kept his troops fighting with Jungle Remedies and used venom extracts against the rebels.",
    "The rebels needed both healing supplies and a sample of the poison stored in Kurzen's camp.",
    "The recovered remedies could treat the rebels, while the extract provided material for their own antidote research.",
    "Medical supplies reached the rebel camp, helping its wounded and giving its healers a poison sample to study.")
q(200, "Bookie Herod", "Stranglethorn Vale", 35, "kurzen", 3,
    "Thorsen's exposed secret raised the possibility of a spy among the rebels.",
    "Bookie Herod's upstairs office held the logistics records that might explain the leak.",
    "Herod's records were found, including supply lists, Kurzen's requests and correspondence.",
    "Herod's upstairs office gave up his supply lists and Kurzen's own correspondence.")
q(574, "Special Forces", "Stranglethorn Vale", 38, "kurzen", 4,
    "Sergeant Yohwa knew Kurzen's elite troops personally, and knew them to be skilled, loyal and cruel. They hunted the rebels, then withdrew to the Stockpile cave behind the compound.",
    "Kurzen's commandos and headshrinkers sheltered deep in the Stockpile. Yohwa sent the attack against soldiers whose skill and cruelty she knew well.",
    "Doren welcomed the news of their defeat. He had feared his rebels stood alone against Kurzen's brilliance; now he could hope they might survive.",
    "The losses among Kurzen's elite gave Doren hope. Yohwa had trusted the help sent against them, and her commander trusted her judgment.")
q(206, "Mai'Zoth", "Stranglethorn Vale", 46, "kurzen", 5,
    "Nimetz believed the ogre mage Mai'Zoth had corrupted Kurzen. He feared the Mind's Eye could bend another mind to the same evil, and called for its recovery.",
    "The inquiry pointed Nimetz toward Mai'Zoth in Stranglethorn's eastern mountains. Convinced that the ogre's magic had ruined Kurzen, he sought the Mind's Eye.",
    "Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve a good purpose; otherwise, he meant to destroy it.",
    "Nimetz received the Mind's Eye after Mai'Zoth's death. His study would decide whether it could serve good or must be destroyed.")

q(1319, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "Caz Twosprocket's smithing knowledge offered a way to examine the burned shield.",
    "The inn's blackened clue needed a blacksmith's eye before it could say more about its owner.",
    "Caz found that the shield was neither his work nor that of any local smith he recognized.",
    "The examination suggested the shield came from elsewhere, without identifying who had carried it.", true)
q(1320, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "Caz thought the burned strap had fitted a large bearer, perhaps a tauren.",
    "The shield offered only a tentative clue to pass back to Captain Vimes.",
    "Vimes received the blacksmith's uncertain assessment and still lacked a clear account of the fire.",
    "The possible tauren connection entered the investigation as a guess, not an identified culprit.", true)
q(1322, "The Black Shield", "Dustwallow Marsh", 37, "shield", 2,
    "Do'gol had found writing hidden beneath the shield's burned surface.",
    "Darkfang venom could supply the acid needed to expose the inscription.",
    "The venom sacs reached Do'gol, who began applying their contents to the shield.",
    "The materials for cleaning the shield were delivered; the inscription's meaning was still ahead.", true)
q(1323, "The Black Shield", "Dustwallow Marsh", 37, "shield", 3,
    "The acid had exposed a damaged name that Do'gol read as Mosarn.",
    "The shield's uncertain inscription offered a name for Krog to consider.",
    "Krog found the name familiar but could not place it or settle the shield's connection to the fire.",
    "Mosarn's name reached Krog, leaving the mystery open rather than establishing responsibility.", true)
fallback("The Black Shield", "Dustwallow Marsh", "shield", "1251,1253,1276,1319-1323",
    "A burned shield offered a physical clue in the investigation of the ruined inn.",
    "Blacksmiths' knowledge could help make sense of the blackened shield.",
    "The shield investigation advanced without settling who had burned the inn.",
    "The blackened shield was examined further, and it still named no culprit.")
q(2863, "Alpha Strike", "Feralas", 43, "woodpaw", 3,
    "Hadoken wanted the Woodpaw alphas struck in quick succession to disrupt their attacks on Camp Mojache.",
    "The defense of the camp called for five gnoll leaders to fall within an hour.",
    "The alphas were defeated within the planned interval, but the reason for the Woodpaw's frenzy still needed investigation.",
    "The rapid strike disrupted Woodpaw leadership and left Hadoken asking what had driven the gnolls to attack.")
q(2903, "The Battle Plans", "Feralas", 43, "woodpaw", 4,
    "The Woodpaw's recovered plans could show Hadoken more than the pattern of their raids.",
    "A scrawled map from the gnoll camps needed a soldier's reading at Camp Mojache.",
    "Hadoken recognized a war on two fronts, with most Woodpaw effort directed against an enemy to the south.",
    "The plans revealed that Camp Mojache was only one of the gnolls' enemies; the southern foe remained to be investigated.")
q(7046, "The Scepter of Celebras", "Desolace", 49, "maraudon", 5,
    "Celebras needed help with the ritual joining the rod and diamond of his broken scepter.",
    "The recovered pieces could restore a means of passage through Maraudon's caverns.",
    "The ritual restored the Scepter of Celebras, opening the way for a further journey through the dangerous caverns.",
    "Celebras entrusted the reunited scepter to the continuing expedition; his uncle's fate still required attention.", true)

q(992, "Gadgetzan Water Survey", "Tanaris", 46, "silithid", 3,
    "Nomads had seized the Gadgetzan Water Company's wells. Fizzledowser supplied a dowsing widget to sample a pool near Sandsorrow Watch, within sight of the trolls.",
    "Fizzledowser offered temporary surveying work, tapping the water near Sandsorrow Watch and bringing the widget back. The company needed new sources after losing its wells to nomads.",
    "The tapped widget returned with news of an insect ambush. Fizzledowser admitted he had dismissed earlier reports of creatures draining the desert's water as more trouble from the nomads.",
    "The water survey ended in an insect ambush. Hearing the report, Fizzledowser could no longer dismiss the stories of water-draining creatures that he had blamed on the nomads.")
q(82, "Noxious Lair Investigation", "Tanaris", 47, "silithid", 3,
    "The insects were draining the pools at the Noxious Lair. Fizzledowser wanted Centipaar parts brought to Pestlezugg so the alchemist could identify the enemy.",
    "Fizzledowser knew what was happening to the Noxious Lair's water, but little about the creatures taking it. Centipaar specimens would give Pestlezugg something to examine.",
    "Pestlezugg began examining the Centipaar parts. He had seen no insects like them and already suspected an outside influence; an emergency with Fizzledowser called for an immediate return.",
    "The specimens baffled Pestlezugg, for these insects were unlike any he knew. He suspected something might be controlling them, then sent word of Fizzledowser's urgent need for help.")
q(110, "Insect Part Analysis", "Tanaris", 48, "silithid", 4,
    "Fizzledowser stayed with Scrimshank's gear and personal effects while asking for news from Pestlezugg. He feared the young surveyor would not be the insects' last victim.",
    "Pestlezugg had been studying the insect parts. Fizzledowser needed the results while he examined Scrimshank's equipment and put the dead surveyor's belongings in order.",
    "Pestlezugg had the results ready, and they troubled him. He believed the insects had been changed into ravagers by a powerful, malignant force whose identity he did not know.",
    "The alchemist's results strengthened his suspicion of outside control. To Pestlezugg, the insects looked like creatures remade for destruction by an unknown and malignant power.", true)
q(113, "Insect Part Analysis", "Tanaris", 48, "silithid", 4,
    "Pestlezugg feared the danger could spread far beyond Tanaris. He wanted Fizzledowser to copy the report so that word could reach others.",
    "The alchemist urged that everyone who could read should see his warning. Fizzledowser needed the report and a request to make a copy for free distribution.",
    "Fizzledowser paid for the report's delivery and agreed to make a copy. He disliked giving away information that could earn good coin, but trusted Pestlezugg's judgment enough to do it.",
    "The warning reached Fizzledowser. Years of knowing Pestlezugg outweighed his reluctance to surrender valuable information for nothing; he agreed to copy the report for others to read.", true)
fallback("Insect Part Analysis", "Tanaris", "silithid", "110,113",
    "The insect specimens had become the subject of an urgent report for the Gadgetzan Water Company.",
    "Pestlezugg's work sought an explanation for the unfamiliar desert insects.",
    "Pestlezugg's work brought a warning of possible outside control into the Water Company's investigation.",
    "The insect investigation yielded a warning from Pestlezugg, who suspected a dangerous power behind the creatures.")
q(2606, "In Good Taste", "Tanaris", 49, "noggenfogger", 2,
    "Marin's dew tasted so bad that his attempt at a desert drink needed a cook's help.",
    "Sprinkle's skill offered a chance to make Noggenfogger's unpleasant brew drinkable.",
    "Sprinkle received the dew and learned what Marin was trying to make.",
    "The experiment reached the cook, leaving the taste problem still to solve.")
q(2641, "Sprinkle's Secret Ingredient", "The Hinterlands", 49, "noggenfogger", 3,
    "Sprinkle's remedy for the brew's taste was Violet Tragan, a mushroom growing beneath a Hinterlands lake.",
    "A cook's secret ingredient sent the search underwater, far from Marin's desert stall.",
    "The Violet Tragan reached Sprinkle, ready to be made into an addition for the brew.",
    "The mushroom was recovered, supplying Sprinkle's missing ingredient without yet finishing the elixir.")
q(2661, "Delivery for Marin", "Tanaris", 49, "noggenfogger", 2,
    "Sprinkle's Violet Powder was ready for Marin, along with a reminder that he owed her a favor.",
    "The attempt to improve the bitter dew returned to Gadgetzan as a packet of powder.",
    "Marin received the Violet Powder and agreed to try it in the brew.",
    "Sprinkle's contribution reached the experiment, whose finished result was still to come.")
q(2662, "Noggenfogger Elixir", "Tanaris", 49, "noggenfogger", 3,
    "Marin mixed Sprinkle's powder with the dew to complete his long-promised drink.",
    "The search for a palatable desert brew had reached Noggenfogger's final mixing stage.",
    "Marin declared the elixir finished and turned eagerly toward selling it.",
    "The finished brew became Noggenfogger's new business, while Sprinkle's requested favor met an evasive response.")

q(4285, "The Northern Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "Rumors placed one of Un'Goro's crystal pylons in the northern reaches of the crater.",
    "The scattered crystals raised a question that a visit to the northern pylon could help answer.",
    "The northern pylon was found. The stories of Un'Goro's crystal structures had led to a real place.",
    "There was indeed a pylon in northern Un'Goro. The rumors of a crystal structure there were confirmed.")
q(4287, "The Eastern Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "A large structure lined with crystals was said to stand in eastern Un'Goro.",
    "The eastern pylon might explain the connection between the crater's structures and its loose crystals.",
    "The eastern pylon was visited and reported as part of the crater's crystal research.",
    "Another pylon had been found, giving the investigation a site in the east to compare with its other observations.")
q(4288, "The Western Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "Failed crystal experiments made the rumored western pylon worth investigating.",
    "Combining colors at a pylon remained only a proposal until the western structure could be found.",
    "The survey found the western pylon, another of Un'Goro's mysterious crystal structures.",
    "The western pylon joined the survey of Un'Goro's mysterious crystal structures.")
q(4321, "Making Sense of It", "Un'Goro Crater", 53, "crystals", 4,
    "The pylon reports supplied the observations needed for calculations about the crystals.",
    "The search around the crater was ready to become diagrams and practical instructions.",
    "The calculations were compiled into a crystal manual, with the author still hoping the diagrams were correct.",
    "The pylon investigation produced a manual explaining the crystals rather than leaving the observations scattered.")
q(4492, "Lost!", "Un'Goro Crater", 55, "ringo", 3,
    "Ringo had been away too long exploring the volcano, and Spraggle feared he needed help.",
    "Spraggle supplied a canteen for the search for her missing friend south of the refuge.",
    "The search found Ringo alive at the volcano. Dazed, he could scarcely express his relief at being found.",
    "Ringo was alive. His halting greeting made clear how grateful he was that someone had found him.")
q(4491, "A Little Help From My Friends", "Un'Goro Crater", 55, "ringo", 4,
    "Heat exhaustion left Ringo able to follow only with help and water if he collapsed again.",
    "Spraggle's canteen had a practical part in getting the missing explorer back to Marshal's Refuge.",
    "Ringo reached Spraggle alive, still in poor shape after the heat.",
    "The escort reunited the two friends at the refuge, with Ringo still weakened by the heat.")
q(5157, "Collection of the Corrupt Water", "Felwood", 52, "felwood", 3,
    "Protective braziers kept Greta from scrying into Shadow Hold to learn who led the cult.",
    "Water from Jaedenar's moonwell was the first material needed for a plan against the Council's protections.",
    "The corrupt water reached Greta, but it still needed purification before use on the braziers.",
    "The canteen was filled for the plan against Shadow Hold; its contents were not yet ready to extinguish the wards.")
q(5159, "Cleansed Water Returns to Felwood", "Felwood", 54, "felwood", 3,
    "Water purified with the spirits' aid was ready to return from Islen to Greta.",
    "The plan against the braziers could proceed once the cleansed moonwell water reached Felwood.",
    "Greta received enough purified water for the braziers, with their extinguishing still to come.",
    "The cleansed water reached the effort against Shadow Hold, giving Greta the material her plan required.")
q(5165, "Dousing the Flames of Protection", "Felwood", 55, "felwood", 4,
    "Each brazier inside Shadow Hold had to be doused to give Greta a brief opening for her scrying.",
    "The purified water was intended to lower the Council's wards long enough to learn about its leaders.",
    "The flames went out and Greta gathered information before the warlocks restored their protections.",
    "A short break in the wards allowed Greta to see into Shadow Hold; the Council itself had not been defeated.")

q(5083, "Winterfall Firewater", "Winterspring", 56, "winterfall", 3,
    "A vial from a Winterfall furbolg held a few drops of nearly glowing green liquid.",
    "Donova's studies at the hot springs made her a possible judge of the strange Winterfall flask.",
    "Donova received the vial and learned that it had come from the Winterfall.",
    "The flask reached the researcher, leaving the green liquid's nature to be investigated.")
q(5084, "Falling to Corruption", "Felwood", 56, "winterfall", 3,
    "The flask's green liquid reminded Donova of Felwood sludge and Winterfall runners passing through Timbermaw.",
    "The Deadwood camp offered a place to look for a connection between the two furbolg tribes.",
    "The search found a cauldron of foul, rotting substance in the Deadwood camp.",
    "A bubbling cauldron supplied a new lead, though resemblance alone did not settle what the Winterfall were drinking.")
q(5085, "Mystery Goo", "Winterspring", 56, "winterfall", 3,
    "The Deadwood cauldron held a green substance similar to the drops in the Winterfall flask.",
    "A sample could let Donova compare the suspected source with the liquid already found.",
    "Donova received the cauldron sample and continued questioning the Winterfall's connection to the Deadwood.",
    "The strange goo reached Donova for examination; its composition still needed a comparison.")
q(5086, "Toxic Horrors", "Felwood", 56, "winterfall", 3,
    "Donova suspected toxic elements in the sample but needed material from the Irontree Woods for comparison.",
    "Felwood's toxic horrors might supply the same substance found in the Deadwood cauldron.",
    "The elemental samples were collected for comparison with the cauldron's contents.",
    "Donova had the comparison material she needed, leaving the analysis to follow.")
q(5087, "Winterfall Runners", "Winterspring", 57, "winterfall", 4,
    "Donova found that hot-spring water reduced the substance's toxicity while retaining its temporary effects.",
    "Winterfall runners carried shipments between Felwood and their village, linking the firewater to the hot springs.",
    "The runners' shipment was seized, and Donova examined it while still questioning its effect on aggression.",
    "One supply run was stopped; Donova's explanation of the furbolgs' behavior remained a suspicion.")
q(5121, "High Chief Winterfall", "Winterspring", 59, "winterfall", 4,
    "Donova suspected the chief's orders behind the Winterfall's changed behavior and sought to halt further harm.",
    "Donova pointed toward Winterfall Village, hoping the chief's death could halt the tribe's worsening aggression.",
    "The high chief was slain, and Donova hoped to resume her studies with less danger of ambush.",
    "With the high chief slain, Donova hoped she could return to her studies free from ambush.")
q(5123, "The Final Piece", "Winterspring", 59, "winterfall", 3,
    "A log taken from the high chief held crude markings that resisted reading.",
    "Donova was the next hope for interpreting the Winterfall chief's extensive but obscure record.",
    "Donova could not decipher the log, leaving its meaning unresolved.",
    "The chief's record reached Donova, but the apparent final clue did not yield an explanation.")

q(5152, "Auntie Marlene", "Western Plaguelands", 56, "darrowshire", 4,
    "Pamela remembered an aunt who had told her to wait and might know where her father had gone.",
    "The child's question led to Marlene's house near Andorhal and the family's unspoken loss.",
    "Marlene grieved for Pamela, then spoke of Joseph, her brother. She could not bear to tell the child what had happened to her father.",
    "Pamela's aunt had no comfort to send home. Marlene knew what had happened to Joseph and could not bring herself to tell his daughter.")
q(5153, "A Strange Historian", "Western Plaguelands", 56, "darrowshire", 4,
    "Joseph's wedding ring lay beneath his monument, a surviving bond to the man the Scourge had twisted.",
    "Marlene proposed taking the ring to Chromie in Andorhal in the hope of changing Joseph's fate.",
    "Chromie recognized the tragedy attached to Joseph's ring. It was too late to help him now, she said; perhaps the past offered a chance.",
    "The ring told Chromie of a great man and a tragic past. She proposed helping Joseph in that past, where his fate might still be changed.")
q(5154, "The Annals of Darrowshire", "Western Plaguelands", 56, "darrowshire", 4,
    "Andorhal's town hall held the account Chromie needed to understand Joseph Redpath's past.",
    "Saving Joseph required learning what had happened during Darrowshire's last battle.",
    "The Annals revealed that Joseph had been corrupted and turned against Darrowshire's defenders.",
    "The recovered history identified Joseph's betrayal as the fate Chromie hoped to change.")
q(5210, "Brother Carlin", "Eastern Plaguelands", 56, "darrowshire", 3,
    "Chromie's magic had extended the Annals beyond the battle to tell of the surviving Carlin Redpath.",
    "New pages in the village history pointed toward Joseph's brother at Light's Hope Chapel.",
    "Carlin received the altered Annals and found passages about himself and Joseph that demanded investigation.",
    "The book reached a survivor of Darrowshire, connecting Chromie's work with Carlin's lost home.")
q(5241, "Uncle Carlin", "Eastern Plaguelands", 56, "darrowshire", 4,
    "Pamela wanted her uncle to know she was waiting and still wanted his story about rabbits and berry jam.",
    "Pamela said she heard her uncle crying far to the east at night. She wanted him told she was all right, and asked for his story about rabbits and berry jam.",
    "Carlin grieved to hear that Pamela was dead and her spirit still suffering. He wished he could take her place in Darrowshire.",
    "Carlin grieved for Pamela and wished to trade places with her in ruined Darrowshire. His duty, he said, was still revenge.")
q(5168, "Heroes of Darrowshire", "Western Plaguelands", 56, "darrowshire", 4,
    "Davil's libram and Joseph's discarded shield survived far from the battle recorded in the Annals.",
    "The search for Darrowshire's defenders led to Hearthglen and the barn at Gahrron's Withering.",
    "Carlin received Davil's libram and Joseph's shield. He believed the relics' histories would meet again in Darrowshire's fate.",
    "The libram and cracked shield were recovered. Carlin saw both as pieces of Darrowshire's history, drawn together once more.")
q(5181, "Villains of Darrowshire", "Eastern Plaguelands", 57, "darrowshire", 4,
    "Horgus's skull and Marduk's broken sword remained near Corin's Crossing after the battle.",
    "The Annals gave locations for relics of Darrowshire's enemies as well as its defenders.",
    "Horgus's skull and Marduk's broken sword stirred Carlin's memories of Darrowshire's last night. He sensed power in the relics that he could not explain.",
    "Carlin received the skull and shattered sword with memories of death and treachery. He believed their unexplained power would one day matter.")
q(5211, "Defenders of Darrowshire", "Eastern Plaguelands", 55, "darrowshire", 4,
    "Some of Darrowshire's fallen defenders still wandered in ghoul and flayer forms under Scourge control.",
    "Carlin asked for the town's dead to be freed from the bodies that kept them in service to the Scourge.",
    "Some of Darrowshire's defenders were freed from their undead forms and their service to the Scourge.",
    "The report brought Carlin word that a number of his village's tortured souls had been released.")
q(5206, "Marauders of Darrowshire", "Eastern Plaguelands", 60, "darrowshire", 4,
    "Chromie's spell required skulls from Scourge champions who had actually taken part in Darrowshire's battle.",
    "An enchanted crystal could distinguish the battle's marauders from other Scourge champions.",
    "The resonating skulls were gathered as the remaining reagents for Chromie's spell.",
    "The collection gained skulls linked to Darrowshire, leaving the spell and battle still ahead.")
q(5941, "Return to Chromie", "Western Plaguelands", 60, "darrowshire", 4,
    "Carlin had gathered the battle relics for delivery to Chromie at the ruined inn in Andorhal.",
    "The separate searches around Darrowshire had produced the reagents for a single spell.",
    "Chromie received the relics and described a spell to raise the spirits and offer a chance to save Joseph.",
    "The collection reached Chromie intact; the battle that might redeem Joseph still had to be faced.")
q(5942, "Hidden Treasures", "Eastern Plaguelands", 60, "darrowshire", 3,
    "Pamela passed along her father's thanks and a key to the chest behind the house.",
    "The family offered a small, practical token of thanks amid Darrowshire's ruined homes.",
    "The old chest opened with the key Pamela had given.",
    "Pamela's key fitted the grime-covered chest, completing the family's offered thanks.")

q(5542, "Demon Dogs", "Eastern Plaguelands", 56, "tirion", 3,
    "Tirion offered a warm meal and conversation in exchange for help against the plaguehounds.",
    "An old man's hospitality depended on reducing the dangerous dogs around his refuge.",
    "The plaguehounds were dealt with, and Tirion offered rest and a meal.",
    "The work earned an invitation to Tirion's table and a welcome at the refuge.")
q(5543, "Blood Tinged Skies", "Eastern Plaguelands", 56, "tirion", 3,
    "Plaguebats threatened travelers from above in country already contested by the Crusade and Scourge.",
    "Tirion's request concerned wildlife transformed into another danger along the plague-stricken roads.",
    "The plaguebat hunt was completed, and Tirion welcomed the help as an act of decency.",
    "One of the refuge's immediate dangers was reduced, giving Tirion reason to welcome the assistance.")
q(5544, "Carrion Grubbage", "Eastern Plaguelands", 56, "tirion", 3,
    "Tirion's food supply was running low, and carrion-worm meat could be preserved for winter.",
    "The old man's offer to share a meal came with a practical shortage in his own stores.",
    "The recovered meat replenished Tirion's supplies for the colder months.",
    "The gathering helped stock the refuge with food that would keep, an ordinary need amid the plague.")
q(5742, "Redemption", "Eastern Plaguelands", 56, "tirion", 4,
    "After the work around his refuge, Tirion offered a proper introduction and asked that his tale be heard.",
    "The invitation shifted from earning a meal to learning the old man's history.",
    "Tirion's story opened the question of the Fordring family's redemption.",
    "The introduction gave the refuge's earlier hospitality a family history, with the work of redemption still ahead.")
q(5781, "Of Forgotten Memories", "Eastern Plaguelands", 57, "tirion", 4,
    "Taelan had buried his childhood hammer at Tirion's false grave after being told his banished father was dead.",
    "A toy replica of Tirion's warhammer survived at the Undercroft as a link to Taelan's seventh birthday.",
    "The toy hammer was recovered and returned to Tirion, restoring a keepsake intended to reach his son.",
    "Tirion received the childhood gift from the false grave; Taelan had not yet seen it again.")
q(5845, "Of Lost Honor", "Eastern Plaguelands", 58, "tirion", 4,
    "Taelan had abandoned the Silver Hand's standard at Northdale when he gave up hope for the Order.",
    "The tattered banner offered another piece of the life Tirion hoped his son might reclaim.",
    "The standard was recovered for Tirion, still recognizable beneath its damage.",
    "The banner joined the keepsakes for Taelan, preserving a reminder of his former allegiance.")
q(5861, "Find Myranda", "Western Plaguelands", 60, "tirion", 4,
    "Taelan's Scarlet guards made an open delivery of the family keepsakes impossible.",
    "Tirion directed the search to Myranda near Uther's tomb for help with a disguise.",
    "Myranda had advised Tirion when he ruled Mardenholde. She had protested his sentence and been banished herself; her loyalty endured.",
    "Tirion's former adviser remembered her own banishment for opposing his sentence. Myranda was ready to help the Fordrings again.")
q(5862, "Scarlet Subterfuge", "Western Plaguelands", 60, "tirion", 5,
    "Myranda's illusion offered only a brief chance to carry Tirion's keepsakes through Hearthglen's defenses.",
    "The recovered family objects needed to reach Taelan while the Scarlet disguise held.",
    "Taelan opened the box and examined the keepsakes. Faced with what they showed him, he sank to one knee.",
    "The family keepsakes reached Taelan under the Scarlet disguise. He could scarcely believe them; then he dropped to one knee beside the opened box.")

-- Additional regional detail is setting, never evidence that a visit occurred.

-- BEGIN REVIEWED WORLD BANDS 20261012
-- Exact Quest / Progress / Completion records, audited in the adjacent
-- StorageInvestigation/cj-world-band-additions-20261012.txt review ledger.
-- This collector corpus is source quest text, not a claim of direct cache capture.
-- Repeated corpus titles are ID-only unless an audited neutral fallback follows.
P.threads.world_ahnqiraj = "the captives of Ahn'Qiraj"
P.threads.world_ancientflute = "the bound ancient spirit"
P.threads.world_caerdarrow = "the lost souls of Caer Darrow"
P.threads.world_caravan = "the Desolace caravan"
P.threads.world_cauldrons = "the western plague cauldrons"
P.threads.world_dustwallow = "the scattered requests of Dustwallow"
P.threads.world_forgewright = "Forgewright's lost hammer"
P.threads.world_gordunni = "the Gordunni investigation"
P.threads.world_harborage = "the survivors of the swamp"
P.threads.world_hivecode = "the messages of the hives"
P.threads.world_lethlor = "the prisoners of Lethlor"
P.threads.world_letweb = "Lethtendris's dangerous web"
P.threads.world_linken = "Linken's missing memory"
P.threads.world_natalia = "the search for Natalia"
P.threads.world_naxxramas = "the road into Naxxramas"
P.threads.world_perenolde = "the Warchief's missing pendant"
P.threads.world_plaguedragons = "the plagued dragon experiments"
P.threads.world_racecar = "the Shimmering Flats' racing machines"
P.threads.world_rackmore = "Rackmore's lost treasure"
P.threads.world_razorfen = "Razorflank's threat to the south"
P.threads.world_restless = "Stratholme's innocent dead"
P.threads.world_retribution = "the Torch of Retribution"
P.threads.world_scarletresearch = "the apothecary's monastery experiment"
P.threads.world_shani = "the search for Sha'ni"
P.threads.world_shen = "the fugitives of Eldre'Thalas"
P.threads.world_soulflayer = "the fall of the Soulflayer"
P.threads.world_timbermaw = "the Timbermaw's guarded friendship"
P.threads.world_yenniku = "the Darkspear's lost son"

q(512, "Noble Deaths", "Alterac Mountains", 36, "syndicate", 3,
    "Southshore feared that former Alterac nobles were directing the Syndicate against the town.",
    "Signet rings from Strahnbrad would identify losses among the Syndicate's noble leadership.",
    "The rings confirmed a blow to the Syndicate's leadership, which Southshore hoped would hinder its plans.",
    "The bounty against the former nobles was accepted as service to Southshore's defense.")

q(525, "Further Mysteries", "Hillsbrad Foothills", 34, "syndicate", 3,
    "A decrypted letter from an Alterac thieves' camp needed to reach Southshore's magistrate.",
    "The cryptic message needed the attention of the town nearest the suspected threat.",
    "Maleb judged that the Syndicate was connected with another power whose nature he still feared to guess.",
    "Maleb read signs of another power behind the Syndicate, one whose identity troubled him.")

q(537, "Dark Council", "Alterac Mountains", 40, "syndicate", 4,
    "The letter named Nagaz of the Argus Wake and pointed to envoys among the Syndicate in the Uplands.",
    "Southshore sought action against Nagaz and the shadow mages supporting the Syndicate.",
    "The envoys were defeated, but Maleb warned that Nagaz had served another power.",
    "The local Argus Wake presence suffered a blow while the organization's wider reach remained unknown.")

q(507, "Lord Aliden Perenolde", "Alterac Mountains", 42, "perenolde", 4,
    "Aliden Perenolde held the pendant sought by the Warchief at a manor beside Lordamere Lake.",
    "The mission against Perenolde required recovering a small possession important enough to draw the Warchief's attention.",
    "The search reached a frightened woman who pleaded to be spared and said she had been held against her will.",
    "Perenolde's captive asked for mercy; the pendant had not yet been returned to the requester.")

q(508, "Taretha's Gift", "Hillsbrad Foothills", 40, "perenolde", 4,
    "The woman surrendered Perenolde's pendant and asked that it and the memories it carried be taken away.",
    "The recovery's last errand returned the pendant sought on the Warchief's orders.",
    "The pendant was delivered, though the officer admitted he did not understand its importance to the Warchief.",
    "The recovery was acknowledged as successful, with word of it still to reach the Warchief.")

q(3821, "Dreadmaul Rock", "Burning Steppes", 52, "shani", 4,
    "Thal'trak had heard nothing from the platoon investigating Firegut rituals, which included his wife Sha'ni.",
    "Unable to leave his post, a worried husband asked for a search near Dreadmaul Rock.",
    "The search found Sha'ni's spirit grieving for the life she and Thal'trak had planned.",
    "Sha'ni was found among the dead, turning the search toward learning what had happened to her.")

q(3822, "Krom'Grul", "Burning Steppes", 53, "shani", 5,
    "Sha'ni's spirit asked that Krom'Grul be killed and her stolen wedding ring returned to Thal'trak.",
    "Her last request was to send her husband the ring and a hope of meeting again in another life.",
    "The ring and news reached Thal'trak, whose grief left him unable to value the keepsake.",
    "The mission returned proof of Sha'ni's loss, but the recovered ring could not console her husband.")

q(3823, "Extinguish the Firegut", "Burning Steppes", 52, "blackrock", 3,
    "Oralius targeted Firegut ogres who guarded Dreadmaul Rock and kept Blackrock supply routes open.",
    "An attack on the ogres was meant to disrupt the forces supporting the Blackrock orcs.",
    "Oralius celebrated the disruption while admitting its effect might be brief.",
    "The strike checked the Firegut force for the moment, leaving the wider Blackrock campaign active.")

q(4726, "Broodling Essence", "Burning Steppes", 52, "plaguedragons", 3,
    "A researcher's unproven device was intended to draw essence from dragon broodlings.",
    "The experiment needed samples to establish whether the new device actually captured draconic essence.",
    "The recovered essence demonstrated that the device worked and supplied material for further study.",
    "The experiment succeeded at gathering essence; capturing living whelps or eggs remained a future ambition.")

q(3627, "Uniting the Shattered Amulet", "Blasted Lands", 60, "defiler", 5,
    "The amulet needed to reach the Defiler was divided among Sevine, Allistarj and Grol.",
    "The demon lord's three lieutenants had to fall before the shattered amulet could be restored.",
    "The three pieces reunited, and the Defiler sensed the disruption of his command.",
    "The restored amulet prepared the approach to Razelikh, whose own defeat still lay ahead.")

q(1131, "Steelsnap", "Thousand Needles", 30, "hunts", 3,
    "Melor described Steelsnap as a tyrant whose pack spread bloodshed among the other beasts.",
    "The hunt concerned a dangerous hyena in Thousand Needles and the lesson Melor attached to its defeat.",
    "Steelsnap's death completed Melor's lesson about a creature he considered outside the Earthmother's blessing.",
    "Melor accepted the hunt as a cleansing of Steelsnap's influence, and made that judgment the day's lesson.")

q(1136, "Frostmaw", "Alterac Mountains", 37, "hunts", 4,
    "Melor sent the hunt far from Thousand Needles to an elusive yeti in Alterac's snow.",
    "Frostmaw's white coat concealed him in the mountains; Melor supplied instructions for drawing him out.",
    "Frostmaw's mane proved the distant hunt, and Melor praised both the strength and cunning it required.",
    "The successful hunt linked the valleys of Thousand Needles with Alterac's heights in Melor's teaching.")

q(1104, "Salt Flat Venom", "Thousand Needles", 30, "racecar", 2,
    "Fizzle wanted the unusually salty venom of the Shimmering Flats' scorpids for an experimental fuel.",
    "A rocket car's next fuel mixture depended on venom gathered out on the salt flats.",
    "The venom reached Fizzle, who still had to process it into his experimental mixture.",
    "Fizzle received his fuel ingredient; a working engine remained a separate achievement.")

q(1105, "Hardened Shells", "Thousand Needles", 30, "racecar", 2,
    "Fizzle's brother feared the new fuel would eat through the rocket car's tanks.",
    "Hard tortoise shells offered material for tanks sturdy enough to hold an aggressive fuel mixture.",
    "The shells were delivered for the replacement tanks, leaving their construction to the engineer.",
    "The rocket car project gained tough shell material to contain the fuel being developed beside it.")

q(1106, "Martek the Exiled", "Badlands", 35, "racecar", 3,
    "Fizzle's failed pistons led him to seek the expertise of Martek, an exiled smith in the Badlands.",
    "A letter carried a racing engineer's problem across the sea. The engine needed metal that could endure greater stress.",
    "Martek agreed to help Fizzle after reading the letter, but suitable piston material still had to be found.",
    "The referral reached a willing smith, turning the rocket car's engineering problem into a Badlands investigation.")

q(1108, "Indurium", "Badlands", 39, "racecar", 3,
    "Martek proposed testing indurium, a metal rumored to withstand intense heat and stress.",
    "Flakes carried by Stonevault troggs offered samples of the metal whose true ore lay deeper in Uldaman.",
    "Martek received the indurium flakes and began testing them in the forge.",
    "The samples reached the smith; their suitability for Fizzle's pistons was still being tested.")

q(1137, "News for Fizzle", "Thousand Needles", 38, "racecar", 3,
    "Martek's tests showed indurium resisted heat, but Fizzle would need actual ore from Uldaman.",
    "The smith sent word that indurium could solve the piston problem if a supply of the ore could be obtained.",
    "Fizzle received the report from Martek and eagerly asked what the smith had learned.",
    "The news reached the racing camp; delivering a report had not yet supplied the required ore.")

q(1110, "Rocket Car Parts", "Thousand Needles", 31, "racecar", 2,
    "Crashes on the Shimmering Flats left rocket car parts that the racing crews might buy again.",
    "Kravel saw a market in salvaging wreckage scattered around the course.",
    "Kravel paid for a heap of recovered parts and considered what he could sell to the crews.",
    "The wreckage became saleable salvage, with Kravel openly treating other racers' misfortune as profit.")

q(720, "A Sign of Hope", "Badlands", 35, "uldaman", 3,
    "A rough message on a map said Hammertoe had been taken to Uldaman and needed help.",
    "Hammertoe's chalked plea offered Ryedol a lead after the expedition's disappearance.",
    "Ryedol learned that Hammertoe had been alive when the message was written.",
    "The message renewed hope for Hammertoe; reaching him inside Uldaman was still ahead.", true)

q(718, "Mirages", "Badlands", 38, "uldaman", 2,
    "The retreat from Uldaman had left expedition supplies in the hands of Camp Kosh's ogres.",
    "Without their abandoned weapons, the stranded expedition could not even hunt for food.",
    "The recovered supplies gave the expedition the means to go out for food again.",
    "The camp's immediate shortage was eased by returning equipment lost during the retreat.")

q(733, "Scrounging", "Badlands", 40, "uldaman", 2,
    "A small expedition camp needed scrap metal for defenses while it waited for help from Ironforge.",
    "Ogre-held metal offered a practical source of material for a vulnerable Badlands camp.",
    "The delivered scrap provided a beginning for the camp's defenses, with outside help still awaited.",
    "Scrap taken from the ogres gave the stranded camp a start on its defenses.")

q(739, "Murdaloc", "Badlands", 42, "uldaman", 3,
    "Agmond's bloody trail ended at his body, beside the name Murdaloc scratched into sandstone.",
    "The fallen prospector's last written clue named a foe among the Badlands troggs.",
    "The report brought confirmation of Agmond's death and a grieving acknowledgment of the prospector's courage.",
    "Agmond's fate was known, even though the news could offer his colleagues little comfort.")

q(717, "Tremors of the Earth", "Badlands", 50, "lethlor", 5,
    "The Kirin Tor's prison for Blacklash and Hematus could no longer be trusted to hold.",
    "Stolen protections and nearby black dragons prompted a final measure against the two imprisoned drakes.",
    "The drakes' defeat ended the danger of their escape, and the agent prepared a report for Krasus.",
    "The prisoners of Lethlor were dealt with; news of success would be carried back to the agent's master.", true)

q(629, "The Vile Reef", "Stranglethorn Vale", 37, "yenniku", 3,
    "A tablet in the sunken troll city told a tale of Gri'lek that the Darkspear held sacred.",
    "Nimboya wanted a shard of the Vile Reef's tablet to preserve a link with troll tradition in Orgrimmar.",
    "Nimboya received the shard and intended to place it in a sacred setting in the Darkspear's new home.",
    "The recovered fragment gave the Darkspear a relic of the tale they wished to remember.")

q(588, "The Fate of Yenniku", "Stranglethorn Vale", 45, "yenniku", 3,
    "From the cauldron, Nezzliok named Zanzil the Outcast as the witchdoctor who held Yenniku. He doubted that the Darkspear had magic powerful enough to break that hold.",
    "Nezzliok said Zanzil the Outcast controlled Yenniku's body and soul. The answer from the Bloodscalp's severed head sent the search back to the Darkspear's own magic.",
    "Kin'weelay feared Zanzil's power. He could offer only the faintest hope for Yenniku, but he would not call it none.",
    "Kin'weelay knew the danger in Zanzil's name. The hope of saving Yenniku was tiny, he said, but still there.")

q(589, "The Singing Crystals", "Stranglethorn Vale", 45, "yenniku", 3,
    "Kin'weelay hoped to rescue Yenniku with a legendary jewel called the Mind's Eye. While he consulted the jungle spirits, he needed blue shards from Crystalvein's basilisks for the ritual.",
    "Blue basilisk shards could help bend the Mind's Eye to Kin'weelay's will. He sought the hidden jewel through the jungle spirits, hoping its power could reach Yenniku.",
    "Kin'weelay said he could already hear the recovered shards singing. The spirits had told him where the Mind's Eye lay, and who guarded it.",
    "The shards were ready. Kin'weelay had learned the Mind's Eye's hiding place from the spirits, along with the identity of its guardian.")

q(592, "Saving Yenniku", "Stranglethorn Vale", 46, "yenniku", 5,
    "The Mind's Eye had been reshaped into a Soul Gem intended to release Yenniku from Zanzil's control.",
    "Yenniku could be found near the Ruins of Aboraz, where the prepared gem was to hold his soul.",
    "Nimboya confirmed that Yenniku was freed from Zanzil's will.",
    "The Soul Gem completed the desperate rescue, bringing Nimboya the outcome he had scarcely dared hope for.")

q(5561, "Kodo Roundup", "Desolace", 34, "caravan", 2,
    "Smeed supplied a device to rejuvenate and tame old kodos for the caravan that crossed Desolace.",
    "The caravan's transport needs had become a business arrangement centered on Smeed's kodo device.",
    "Smeed counted the five returned kodos and welcomed the success of his caravan venture.",
    "The roundup supplied the animals Smeed had requested for his partnership with the caravan.")

q(6161, "Claim Rackmore's Treasure!", "Desolace", 36, "rackmore", 3,
    "Rackmore hid his treasure on Ranazjar Isle after his ship came under attack.",
    "The captain's log described a chest that required both a silver key and a gold one.",
    "The two keys opened Rackmore's chest and revealed the hidden treasure.",
    "Rackmore's precautions were overcome when the recovered keys finally opened his island cache.")

q(1204, "Mudrock Soup and Bugs", "Dustwallow Marsh", 38, "dustwallow", 2,
    "A cook needed forked Mudrock tongues for a dish whose ingredients were dangerous to gather.",
    "Dustwallow's coastal turtles supplied the unusual flavor sought for a planned soup.",
    "The tongues reached the cook for experiments with preparation and flavor.",
    "The ingredient search was complete, though a dish fit for the Blue Recluse still required testing.")

q(1261, "Marg Speaks", "Dustwallow Marsh", 40, "dustwallow", 3,
    "Marg's spirit described stealing a jeweled pendant from an Alliance soldier before a muckshell killed him.",
    "The dead scout's unfinished mission centered on recovering a pendant too rich for an ordinary soldier.",
    "The pendant explained Marg's last mission but opened a new question about the soldier who had worn it.",
    "News of Marg's death came with an unexplained jewel, leaving its larger significance unresolved.")

q(1389, "Draenethyst Crystals", "Swamp of Sorrows", 35, "harborage", 3,
    "The Harborage's draenei sought sacred crystals stolen by their former brethren in Fallow Sanctuary.",
    "The survivors feared losing their way without the draenethyst they lacked the strength to reclaim.",
    "The draenethyst returned to the grateful people of the Harborage.",
    "The recovered crystals answered a vulnerable community's request for something it considered sacred.")

q(1392, "Noboru the Cudgel", "Swamp of Sorrows", 39, "harborage", 3,
    "Noboru's cudgel represented the violence his gang had inflicted on the Harborage.",
    "The weapon offered the draenei evidence concerning a foe they had been unable to face themselves.",
    "The Harborage welcomed Noboru's weapon as news that a direct threat to its survival had fallen.",
    "The cudgel brought relief to the community that Noboru and his gang had terrorized.")

q(1393, "Galen's Escape", "Swamp of Sorrows", 38, "harborage", 3,
    "Galen offered a hidden treasure in exchange for help escaping his captors.",
    "The captive alone knew the trick that opened his strongbox north of Stonard.",
    "Galen's explanation revealed the concealed latch, and the strongbox opened.",
    "The promised reward became accessible through the trick Galen had shared after his escape.")

q(1101, "The Crone of the Kraul", "Razorfen Kraul", 34, "razorfen", 4,
    "Lonebrow's account led to an urgent effort against Charlga Razorflank's gathering force.",
    "Razorflank's medallion was sought as proof that the crone threatening the region had fallen.",
    "The medallion confirmed Razorflank's defeat, allowing local research to resume.",
    "Charlga's force had been checked, but the corruption of Agamaggan's resting place still invited investigation.")

q(1102, "A Vengeful Fate", "Razorfen Kraul", 34, "razorfen", 4,
    "A displaced tauren sought revenge on Charlga Razorflank for the loss of ancestral lands.",
    "Razorflank's heart was demanded as proof against the crone gathering an army in the Kraul.",
    "The heart answered the tauren's demand for vengeance against Razorflank.",
    "Razorflank's heart answered a grievance carried from the tauren's lost ancestral lands.")

q(1113, "Hearts of Zeal", "Scarlet Monastery", 33, "scarletresearch", 3,
    "An apothecary wanted Scarlet Crusader hearts for an experiment combining opposed substances with a toxic agent.",
    "The monastery's zealots were targets both of Forsaken hostility and an unsettling chemical inquiry.",
    "The hearts supplied the apothecary's requested material, and he praised the delivery.",
    "The apothecary welcomed the gathered hearts as material for his grisly experiment.")

q(2975, "The Ogres of Feralas", "Feralas", 43, "gordunni", 3,
    "The Gordunni outpost north of Camp Mojache was expanding into Feralas.",
    "A campaign to check the ogres began with their northern outpost and the damage surrounding it.",
    "The first attack on the Gordunni was welcomed, with recovery of the land still a hope for the future.",
    "The northern outpost suffered a setback; the wider work against the Gordunni continued.", true)

q(2980, "The Ogres of Feralas", "Feralas", 44, "gordunni", 3,
    "The next Gordunni position lay in ruined night elf structures in the High Wilderness.",
    "Stronger ogres occupied damaged ground southwest of Camp Mojache, extending the campaign beyond the first outpost.",
    "The fighting in the High Wilderness earned recognition as a dependable ally.",
    "The attack among the High Wilderness ruins earned Camp Mojache a proven ally against the Gordunni.", true)

q(2978, "The Gordunni Scroll", "Feralas", 43, "gordunni", 3,
    "A soiled scroll from the Gordunni Outpost seemed to depict a gathering or ceremony. Rok Orhan at Camp Mojache might know what it meant to the ogres.",
    "The markings on a dirty Gordunni scroll suggested some kind of ceremony. The question of its meaning led to Rok Orhan in Camp Mojache.",
    "Rok Orhan received the scroll and asked whether it had come from the Gordunni Outpost.",
    "The scroll reached Rok Orhan, whose first question was whether it had come from the Gordunni Outpost.")

q(3002, "The Gordunni Orb", "Orgrimmar", 47, "gordunni", 3,
    "The Gordunni orb required a mage's judgment beyond the knowledge of the warrior who had recovered it.",
    "The investigation carried the orb to Orgrimmar for a better understanding of its magic.",
    "The mage recognized the orb as powerful and dangerous.",
    "The recovered orb drew a mage's warning about the danger bound up in its power.")

q(7730, "Zukk'ash Infestation", "Feralas", 45, "woodpaw", 4,
    "Scouts traced the pressure on the Woodpaw to insect creatures in the Writhing Deep.",
    "Camp Mojache sought carapaces and a reduction in the Zukk'ash numbers while it assessed the new threat.",
    "The attack bought time for a strategy and supplied carapaces for study.",
    "Camp Mojache gained breathing room, while acknowledging that the Zukk'ash presence remained extensive.")

q(7731, "Stinglasher", "Feralas", 47, "woodpaw", 4,
    "An unusually large insect called Stinglasher carried glands that might explain the threat in the Writhing Deep.",
    "Camp Mojache wanted to study the creature whose strange aura set it apart from the other insects.",
    "Stinglasher's glands reached the camp for investigation, and the successful hunt earned a bounty.",
    "The camp gained a promising specimen while the work of defending itself continued.")

q(7732, "Zukk'ash Report", "Orgrimmar", 48, "silithid", 4,
    "Hadoken's report collected what Camp Mojache had learned about the Zukk'ash for an expert in Orgrimmar.",
    "The insect attacks had grown beyond a local matter and needed a specialist's attention.",
    "Zilzibin identified the Zukk'ash as silithid and warned that the Horde was overlooking an ancient danger.",
    "The report connected Feralas's insects with the wider silithid threat and opened a further appeal for help.")

q(7839, "Vilebranch Hooligans", "The Hinterlands", 48, "hinterlands", 3,
    "Tools stolen by the Vilebranch were a keepsake from the gnome who had once saved their owner's life.",
    "Recovering the tools meant restoring a personal gift as well as a working kit.",
    "The stolen tools returned to their delighted owner.",
    "The recovery restored a reminder of an old act of kindness across the divide between peoples.")

q(7861, "Wanted: Vile Priestess Hexx and Her Minions", "The Hinterlands", 51, "hinterlands", 4,
    "Primal Torntusk's bounty targeted Vile Priestess Hexx and her elite guard.",
    "The wanted notice called for action against the priestess and her Aman'zasi defenders.",
    "The completed bounty was recognized as a serious blow against the Vilebranch.",
    "The priestess and her assigned guard were dealt with, earning Torntusk's promised reward.")

q(3442, "The Flawless Flame", "Searing Gorge", 48, "retribution", 3,
    "An attack on four Dark Iron towers required a torch fueled by elemental hearts and golem oil.",
    "The plan began with gathering the materials for a flame that could deny the sentries their posts.",
    "The hearts and oil were delivered, bringing the torch's preparation closer to completion.",
    "The first materials were secured; neither the torch nor the tower attack was finished.")

q(3443, "Forging the Shaft", "Searing Gorge", 48, "retribution", 3,
    "The torch needed a shaft made from the enchanted thorium in Dark Iron weapons.",
    "Daggers carried by the Cauldron's taskmasters and slavers supplied the metal required for the shaft.",
    "The requested daggers were delivered for the torch's construction.",
    "The preparation gained its sturdy metal, while another component was still needed.")

q(3452, "The Flame's Casing", "Searing Gorge", 50, "retribution", 3,
    "A symbol of Ragnaros from the Twilight's Hammer might supply the magic for the torch's casing.",
    "The last component required an enchanted cult symbol from the northwestern encampment.",
    "The symbol proved to carry magic suited to forming the casing.",
    "The final material was accepted, leaving the assembly and binding of the torch ahead.")

q(3453, "The Torch of Retribution", "Searing Gorge", 50, "retribution", 3,
    "The gathered torch components were ready to be combined and enchanted.",
    "The preparation had reached the channeling needed to complete the Torch of Retribution.",
    "The enchantment work ended with one final task still required.",
    "The torch had been assembled, but binding it to its owner remained a separate step.", true)

q(3454, "The Torch of Retribution", "Searing Gorge", 50, "retribution", 4,
    "The completed torch had to be taken up to bind it to its intended bearer.",
    "The last part of the torch's preparation required physically claiming the enchanted weapon.",
    "Taking the torch brought a surge of hatred and anger.",
    "The torch was claimed and bound, while the strike on the towers still lay ahead.", true)

q(3462, "Squire Maltrake", "Searing Gorge", 50, "retribution", 3,
    "Squire Maltrake was to explain how the newly bound torch should be used.",
    "The tower plan passed from preparing the tool to receiving instructions from the envoy.",
    "Maltrake received the bearer and asked whether the strike could begin.",
    "The referral reached the squire; the towers had not yet been set alight by this errand.")

q(3463, "Set Them Ablaze!", "Searing Gorge", 52, "retribution", 5,
    "Maltrake's plan called for burning the towers' interiors so Dark Iron sentries could no longer occupy them.",
    "The torch's lasting fire could make the four watch posts uninhabitable to Dark Iron sentries.",
    "The four towers were set ablaze, and Maltrake celebrated the result.",
    "The fires denied the sentries their posts, completing the assigned strike on the towers.")

q(4441, "Felbound Ancients", "Felwood", 54, "ancientflute", 3,
    "A flute carved from an ancient protector had bound the suffering spirit through fel magic.",
    "Blessed water from the Temple of the Moon was sought for an attempt to purify the flute.",
    "The blessed water arrived, allowing the attempt at purification to begin.",
    "The remedy's material was gathered, but the ancient spirit's bond had not yet been broken.")

q(4442, "Purified!", "Felwood", 54, "ancientflute", 4,
    "The blessed water was ready for an attempt to undo the flute's bond with the ancient.",
    "Purifying the instrument offered a way to end the spirit's suffering under fel magic.",
    "The water broke the link between flute and spirit, and the purified instrument might still call ancient spirits in a sacred place.",
    "The binding was undone; using the flute among the ruins remained a further possibility.")

q(5242, "A Final Blow", "Felwood", 58, "felwood", 5,
    "Shadow Lord Fel'dan's pacts with the Legion made him a central target in Shadow Hold.",
    "The direct assault sought Fel'dan and his two servants at the bottom of the stronghold.",
    "Fel'dan's defeat struck the Shadow Council's leadership and drew a grateful response.",
    "The attack removed the identified leader, while the broader future of the Shadow Council remained uncertain.")

q(8460, "Timbermaw Ally", "Felwood", 48, "timbermaw", 3,
    "Timbermaw suspicion grew from outsiders attacking furbolgs without distinguishing friend from foe.",
    "Action against the corrupted Deadwood offered a way to begin earning the tribe's trust.",
    "The Timbermaw acknowledged the help with an offering of growing friendship.",
    "The Timbermaw answered the defense against the Deadwood with an offering of growing friendship.", true)

q(8461, "Deadwood of the North", "Felwood", 55, "timbermaw", 4,
    "Nafien asked for action against the nearby Deadwood while lamenting the corruption of his own kin.",
    "The Timbermaw guard saw the hostile furbolgs as victims of fel influence as well as a danger to the Hold.",
    "Nafien acknowledged the victory with sadness and warned that the rest of the tribe might still be suspicious.",
    "The defense earned Nafien's trust, but acceptance inside the Hold would take continued care.")

q(8462, "Speak to Nafien", "Felwood", 55, "timbermaw", 3,
    "Further help for the Timbermaw began with a referral to Nafien near the northern entrance of the Hold.",
    "The road north led to another guard seeking allies against the corruption around the tribe's home.",
    "Nafien welcomed the offer of aid while warning that untrusted strangers could still face hostility inside.",
    "Nafien's welcome carried a warning that the Timbermaw still met unproven strangers with hostility.")

q(8465, "Speak to Salfa", "Winterspring", 55, "timbermaw", 3,
    "Salfa guarded the Winterspring entrance, where the Winterfall threatened the Timbermaw from the east.",
    "The referral crossed the Hold toward another front in the tribe's struggle against corrupted furbolgs.",
    "Salfa welcomed an offer of help against the Winterfall.",
    "The journey reached the eastern guard, with the requested aid still to follow.")

q(8464, "Winterfall Activity", "Winterspring", 58, "timbermaw", 4,
    "The Winterfall's growing hostility endangered a tribe that preferred to keep apart from its neighbors.",
    "Salfa asked for a reduction in the Winterfall threat while emphasizing how few allies the Timbermaw had.",
    "Salfa gave thanks for the aid, with sorrow at the necessary fighting, and asked for continued assistance.",
    "Salfa received the news with sorrow for the fighting and a renewed appeal for help against the Winterfall.")

q(3520, "Screecher Spirits", "Feralas", 44, "hakkar", 3,
    "Yeh'kinya wanted the spirits of Feralas's vale screechers, which he linked to an ancient god.",
    "A bramble wand was supplied to gather the essence of fallen screechers.",
    "The collected spirits prompted Yeh'kinya to speak of the prophecy of Hakkar's return.",
    "The hunt opened a larger account of the Soulflayer and the danger of his essence being misused.")

q(3527, "The Prophecy of Mosh'aru", "Zul'Farrak", 47, "hakkar", 4,
    "Two tablets in Zul'Farrak were said to describe how Hakkar's essence could be contained.",
    "Yeh'kinya sought the Mosh'aru tablets held by Theka and Velratha.",
    "The recovered tablets could be joined and studied for their hidden teaching.",
    "Yeh'kinya received the tablets, leaving their study and the capture of Hakkar's essence ahead.")

q(3528, "The God Hakkar", "The Temple of Atal'Hakkar", 53, "hakkar", 5,
    "The egg was to hold the essence of Hakkar's avatar after a ritual in the Sunken Temple.",
    "The task required drawing out the avatar and overcoming it before its essence could be contained.",
    "The avatar's essence filled the egg, which Yeh'kinya accepted while voicing fear about Hakkar's return.",
    "The egg stirred with Hakkar's essence as Yeh'kinya promised to keep it from evil hands.")

q(4788, "The Final Tablets", "Blackrock Spire", 58, "hakkar", 4,
    "The fifth and sixth Mosh'aru tablets were held by the Smolderthorn inside Blackrock Spire.",
    "Further study of the prophecy depended on recovering the last tablets from the mountain stronghold.",
    "The last tablets were delivered, and the earlier readings had already raised fears about what was coming.",
    "The final tablets joined a prophecy whose earlier passages had already raised fears of what was coming.")

q(3508, "Breaking the Ward", "Azshara", 58, "defiler", 3,
    "Breaking the protections around the demon lord's servants required a ritual and rare artifacts.",
    "The demon hunter offered a path toward weapons that could overcome the wards.",
    "The ritual established that the demon's true name had to be found.",
    "Loramus's ritual turned the search toward the demon's true name, the next requirement for his work.")

q(3509, "The Name of the Beast", "Azshara", 58, "defiler", 3,
    "Lord Arkkoroc might know the true name needed for a weapon against the demon lord.",
    "The search for the name led to Azshara, where the information was expected to carry a price.",
    "Arkkoroc offered possible help only after receiving assistance himself.",
    "The search reached a potential source, but the demon's name was not yet supplied.", true)

q(3601, "Kim'jael Indeed!", "Azshara", 53, "azshara", 3,
    "Kim'jael said his former employers had turned on him and kept his scouting equipment.",
    "The abandoned partnership left a goblin seeking help recovering belongings from the treasure hunters.",
    "Kim'jael received his equipment and paid the promised reward.",
    "The recovered gear settled the goblin's immediate loss after the failed partnership.")

q(3844, "It's a Secret to Everybody", "Un'Goro Crater", 52, "linken", 3,
    "A ruined raft beside a small pond invited a search for clues about its arrival.",
    "The water and nearby trees suggested that the raft's surroundings were not as simple as they appeared.",
    "The search found a waterlogged pack on the pond bottom.",
    "The wreck yielded a pack, with its owner and history still unknown.", true)

q(3845, "It's a Secret to Everybody", "Un'Goro Crater", 52, "linken", 3,
    "The recovered pack's contents might identify its owner among the travelers at Marshal's Refuge.",
    "A few personal belongings offered the first lead away from the ruined raft.",
    "Linken found the belongings vaguely familiar, but did not recover a clear account of his past.",
    "The pack reached someone who recognized it only uncertainly; the memory problem remained.", true)

q(3908, "It's a Secret to Everybody", "Winterspring", 52, "linken", 3,
    "Linken remembered that his sword needed strengthening and named Donova Snowden as someone who could help.",
    "His fragmentary memory sent the sword from Un'Goro to Winterspring's hot springs.",
    "Donova accepted the sword for tempering and asked why Linken had delayed sending it.",
    "The sword reached the next craftsperson, while Linken's missing memory still needed attention.", true)

q(3909, "The Videre Elixir", "Feralas", 52, "linken", 3,
    "Donova knew a further step for Linken's sword but first needed a Videre Elixir from Gregan Brewspewer.",
    "An elusive brewer in Feralas offered a possible way to reach the person who could finish the sword.",
    "Donova tested a vial and confirmed that the Videre Elixir was authentic.",
    "The required elixir was secured; reaching the next helper remained a separate task.")

q(3961, "Linken's Adventure", "Un'Goro Crater", 54, "linken", 3,
    "The Silver Totem was to be returned to Linken in the hope it would stir his memory of Blazerunner.",
    "The work on Linken's behalf had produced a tool connected with his unfinished journey.",
    "The totem reached Linken, who asked about the help obtained from J.D.",
    "Linken received the Silver Totem and asked what help J.D. had given.")

q(3962, "It's Dangerous to Go Alone", "Un'Goro Crater", 56, "linken", 5,
    "Linken finally remembered his mission against Blazerunner and the dangerous Golden Flame.",
    "The Silver Totem offered a way through Blazerunner's protection to recover the artifact he guarded.",
    "The Golden Flame was recovered, and Linken planned to return it to his homeland for protection.",
    "Linken's memory and the recovered artifact brought his unfinished mission to its conclusion.")

q(4123, "The Heart of the Mountain", "Blackrock Depths", 55, "blackrock", 4,
    "A collector's failed attempts to buy the Heart of the Mountain led to a plan to take it from the Dark Iron vault.",
    "The coveted gem lay in a secret safe protected by the vault's coffers and Watchman Doomgrip.",
    "The Heart of the Mountain reached its delighted purchaser.",
    "The gem was recovered from the vault and exchanged for the promised payment.")

q(3801, "Dark Iron Legacy", "Blackrock Mountain", 52, "forgewright", 3,
    "Franclorn Forgewright offered a key to his city in exchange for assistance.",
    "The architect's spirit introduced a task concerning the depths of the city he had helped create.",
    "Forgewright's proposal was heard; the work required for his key still lay ahead.",
    "Forgewright offered passage into his accursed city in return for aid he regarded as a common good.", true)

q(3802, "Dark Iron Legacy", "Blackrock Depths", 52, "forgewright", 5,
    "Forgewright required Ironfel to be recovered from Fineous Darkvire and placed in his statue's hands.",
    "The architect's hammer was to open a concealed compartment at the Shrine of Thaurissan.",
    "Ironfel slid into the statue's grasp and the concealed compartment opened.",
    "Returning the hammer to the monument unlocked the hiding place prepared by Forgewright.", true)

q(4263, "Incendius!", "Blackrock Depths", 56, "blackrock", 4,
    "Jalinda believed Incendius was restoring Pyron and preventing an expedition from entering safely.",
    "A name spoken by Pyron pointed toward Lord Incendius and a feared connection with Ragnaros.",
    "Incendius's defeat brought Jalinda another troubling name, Ragnaros.",
    "The mission removed Incendius, but the report left Jalinda considering a greater power behind the danger.")

q(5216, "Target: Felstone Field", "Western Plaguelands", 53, "cauldrons", 3,
    "Felstone Field's cauldron offered an initial opportunity to collect plague poison for a counteragent.",
    "The cauldron lord's key was needed to open the apparatus without simply destroying it.",
    "Bilemaw's key opened the access panel and made the cauldron's contents available for sampling.",
    "The first cauldron was opened; carrying its poison back for analysis remained a separate task.", true)

q(5217, "Return to Chillwind Camp", "Western Plaguelands", 53, "cauldrons", 3,
    "The Felstone sample had to reach MacDonnell so its poison could be studied.",
    "The plan depended on understanding the brew before adding reagents that might weaken the Scourge.",
    "The sample reached Chillwind, where MacDonnell explained that continued treatment would be necessary.",
    "The first poison sample was delivered for analysis, opening ongoing work on a counteragent.", true)

q(5219, "Target: Dalson's Tears", "Western Plaguelands", 55, "cauldrons", 3,
    "Dalson's Tears held another cauldron with its own distinct mixture of plague toxins.",
    "The next sampling operation required a key from the farm's cauldron lord.",
    "The key opened the panel at Dalson's Tears and dissolved, leaving access to the cauldron.",
    "Behind the opened panel at Dalson's Tears, thick plague ichor pulsed through the cauldron's twisted tubes.", true)

q(5220, "Return to Chillwind Camp", "Western Plaguelands", 55, "cauldrons", 3,
    "Dalson's sample required separate analysis because each cauldron used different reagents.",
    "MacDonnell needed the new poison before a suitable counteragent could be prepared.",
    "The sample arrived in sufficient quantity for study, leaving the reagent list to the alchemists.",
    "The second brew reached Chillwind for analysis; its treatment still needed to be worked out.", true)

q(5222, "Target: Writhing Haunt", "Western Plaguelands", 55, "cauldrons", 3,
    "The Writhing Haunt offered a third route for introducing a counteragent into the Scourge's plague apparatus.",
    "The plan again required defeating a cauldron lord and drawing a sample from the opened device.",
    "The key unlocked the Writhing Haunt's panel and vanished, exposing the churning contents.",
    "The Writhing Haunt's opened panel exposed the churning poison and a spigot from which to draw it.", true)

q(5223, "Return to Chillwind Camp", "Western Plaguelands", 55, "cauldrons", 4,
    "The Writhing Haunt sample could give the alchemists another distinct mixture to turn against the Scourge.",
    "The fragile bottle carried the results of the third cauldron mission back to Chillwind.",
    "MacDonnell confirmed that three cauldrons were accessible, while Kel'Thuzad's power still prevented their complete shutdown.",
    "The third sample reached the camp, and preparations turned toward the final western cauldron.", true)

q(5225, "Target: Gahrron's Withering", "Western Plaguelands", 58, "cauldrons", 4,
    "Gahrron's Withering held the last targeted cauldron, defended by stronger undead near the eastern border.",
    "The final access mission sought Soulwrath's key and a sample of the farm's plague mixture.",
    "Soulwrath's key opened the access panel and disintegrated, revealing the cauldron's toxins.",
    "The fourth cauldron became accessible; its sample still needed delivery to Chillwind.", true)

q(5226, "Return to Chillwind Camp", "Western Plaguelands", 58, "cauldrons", 5,
    "The last poison sample would complete access to four different vessels for the proposed counteragents.",
    "MacDonnell awaited the brew from Gahrron's Withering to finish the western cauldron investigation.",
    "MacDonnell acknowledged access to the final cauldron and left its reagent requirements to Arbington.",
    "The last sample reached the camp, giving it a fourth plague mixture for its work on counteragents.", true)

q(5382, "Doctor Theolen Krastinov, the Butcher", "Scholomance", 60, "caerdarrow", 4,
    "Eva sought justice against Krastinov and the burning of her and her husband's remains.",
    "The victims' spirits needed the butcher stopped and their bodies reduced to ashes.",
    "Eva felt her spirit begin to heal after the butcher's defeat and the burning of the remains.",
    "The deed eased the couple's suffering, though Eva believed more still needed doing.")

q(5515, "Krastinov's Bag of Horrors", "Scholomance", 60, "caerdarrow", 4,
    "Kirtonos could not be confronted until a way to summon him was found.",
    "Jandice Barov was believed to carry the blood passed from Krastinov to his master.",
    "The recovered bag of horrors supplied the clue Eva had sought.",
    "The bag reached Eva, leaving the use of its contents against Kirtonos for the next task.")

q(5384, "Kirtonos the Herald", "Scholomance", 60, "caerdarrow", 5,
    "The blood in the bag could lure Kirtonos to the porch brazier and make him vulnerable to a direct confrontation.",
    "Eva wanted the means of feeding Krastinov's master turned into the means of summoning him for justice.",
    "Kirtonos fell, and Eva granted a piece of the couple's essence to allow communication with Caer Darrow's other lost souls.",
    "The victory closed one part of Scholomance's horror and opened contact with further spirits who still needed help.")

q(5529, "Plagued Hatchlings", "Scholomance", 58, "plaguedragons", 4,
    "The Argent Dawn had discovered Scourge efforts to breed a plagued dragonflight within Scholomance.",
    "Destroying the hatchlings offered a chance to check the experiment before the dragons matured.",
    "The hatchling attack was welcomed as a setback to the breeding effort, with no certainty about how long it would last.",
    "The current clutch suffered a blow, while the Dawn still feared the Scourge could try again.")

q(5531, "Betina Bigglezink", "Eastern Plaguelands", 60, "plaguedragons", 3,
    "Recovered frozen eggs had to reach Betina before the next move against the Scourge's dragon research.",
    "Betina's experimental weapon offered another use for the container that had carried the dragon eggs.",
    "Betina accepted the eggs for safekeeping and proposed testing Dawn's Gambit in their container.",
    "The delivery supplied Betina's experiment, but its effectiveness inside Scholomance remained unproven.")

q(4771, "Dawn's Gambit", "Scholomance", 60, "plaguedragons", 5,
    "Dawn's Gambit was to be planted among Vectus's scholars to disrupt the plagued dragon research.",
    "Betina's unproven device needed a trial in Scholomance's viewing room, followed by action against Vectus.",
    "Vectus was defeated, although Betina acknowledged that the device had not performed as well as she had hoped.",
    "Vectus had fallen despite Betina's disappointment in Dawn's Gambit, and she gave thanks on behalf of the Dawn.")

q(5282, "The Restless Souls", "Stratholme", 60, "restless", 4,
    "Egan distinguished innocent undead from the Scourge and wanted Stratholme's tortured souls released.",
    "Egan's blaster offered a way to free the ghosts still trapped in Stratholme's ruined streets.",
    "Egan welcomed the souls' release and anxiously asked whether his mother had been among them.",
    "Egan welcomed the mercy shown to Stratholme's ghosts, then asked through tears whether his mother had been freed.", true)

q(7441, "Pusillin and the Elder Azj'Tordin", "Dire Maul", 58, "shen", 4,
    "Pusillin had stolen the book of incantations from an elder fleeing Prince Tortheldrin's rule.",
    "Azj'Tordin wanted his stolen book back after choosing freedom over his former immortality.",
    "Azj'Tordin received the recovered book and offered what little he could spare.",
    "The elder regained the possession he had sought after escaping the fallen prince.")

q(7488, "Lethtendris's Web", "Dire Maul", 57, "letweb", 4,
    "Lethtendris's web trapped Dire Maul's magical energy, and Latronicus Moonspear feared the damage it could cause.",
    "Latronicus wanted Lethtendris's web recovered from Dire Maul so its stored magic could be released safely.",
    "Lethtendris was dead, and Latronicus received her web with plans to disperse its energy and destroy it.",
    "The recovered web reached Latronicus, who intended to release its power across the wilds before destroying the device.", true)

q(7489, "Lethtendris's Web", "Dire Maul", 57, "letweb", 4,
    "Lethtendris meant to turn Dire Maul's tainted magic against her enemies, and Talo Thornhoof wanted her web taken from her.",
    "Talo sought Lethtendris's web for other blood elves to study, before its maker unleashed the power it had gathered.",
    "Lethtendris was dead, and Talo received the web, intending to entrust its stored power to more careful students of magic.",
    "The web was out of Lethtendris's hands; Talo planned to send it to other students who could guard its power.", true)

q(6822, "The Molten Core", "Molten Core", 60, "waterlords", 4,
    "Hydraxis set a trial against the powerful beings within the Molten Core.",
    "The Waterlords' enemy held a stronghold beyond Blackrock Depths that Hydraxis warned would require allies to face.",
    "Hydraxis recognized the successful trial against the Core's inhabitants.",
    "The victories within the Core earned Hydraxis's respect and his hope of a future alliance.")

q(6824, "Hands of the Enemy", "Molten Core", 60, "waterlords", 5,
    "The Waterlords demanded the hands of Lucifron, Sulfuron, Gehennas and Shazzrah as proof against the fire captains.",
    "Hydraxis considered the mission valuable enough to risk an agent who had already served him well.",
    "The four captains' hands confirmed their defeat and drew Hydraxis's astonished praise.",
    "The Waterlords received proof of a major blow against their enemies, with another conversation still invited.")

q(7848, "Attunement to the Core", "Blackrock Mountain", 60, "blackrock", 5,
    "Lothos sought a core fragment from Blackrock Depths to attune a traveler to the portal nearby.",
    "A passage into the Molten Core required the fragment used in Lothos's attunement.",
    "Lothos confirmed that he could now transport the attuned traveler to the Molten Core.",
    "With the attunement complete, Lothos stood ready to send the traveler through to the Molten Core.", true)

q(8183, "The Heart of Hakkar", "Zul'Gurub", 60, "soulflayer", 6,
    "The defeated Soulflayer's heart still carried a remnant of his power.",
    "The burning heart survived Hakkar's fall as a dangerous trophy to be presented.",
    "The heart was recognized as proof that Hakkar had been slain, and the deed was celebrated.",
    "Hakkar's burning heart bore witness to the Soulflayer's fall, and its bearer was hailed as a hero.")

q(8801, "C'Thun's Legacy", "Ahn'Qiraj Temple", 60, "ahnqiraj", 6,
    "C'Thun's fallen body still radiated menace when an eye was taken to the nearby dragons.",
    "The eye carried proof of the Old God's defeat to those who had been held in its grasp.",
    "The dragons acknowledged their release but chose to remain until they were certain the evil within was gone.",
    "C'Thun's defeat freed the dragons' immediate captivity; they had not yet departed the temple.")

q(8802, "The Savior of Kalimdor", "Tanaris", 60, "ahnqiraj", 6,
    "The dragons sent C'Thun's eye to Anachronos at the Caverns of Time.",
    "The last delivery carried the temple's terrible trophy to the bronze dragon awaiting it.",
    "Anachronos received the eye and offered a choice from his master's ancient artifacts.",
    "The trophy reached the Caverns of Time, completing the requested delivery after C'Thun's fall.")

q(9120, "The Fall of Kel'Thuzad", "Eastern Plaguelands", 60, "naxxramas", 6,
    "Kel'Thuzad's surviving phylactery offered a troubling trophy after the fall of Naxxramas's master.",
    "The object that could allow the lich to return was carried toward Light's Hope for a reward.",
    "Father Montoy eagerly took possession of the phylactery.",
    "Kel'Thuzad's surviving phylactery passed into Father Montoy's eager hands at Light's Hope.", true)

q(9121, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "Arcane cloaking offered passage through the wards on Naxxramas's rune portal in Plaguewood.",
    "The Dawn's entry ritual adapted a Kirin Tor cantrip to conceal a traveler from the portal's defenses.",
    "The cloaking ritual enabled passage into Naxxramas through the Plaguewood portal.",
    "The Dawn's cloaking magic granted passage through the warded portal in Plaguewood.", true)

q(9122, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "Arcane cloaking offered passage through the wards on Naxxramas's rune portal in Plaguewood.",
    "Recognized service to the Dawn reduced the cost of the modified Kirin Tor ritual.",
    "The cloaking ritual enabled passage into Naxxramas through the Plaguewood portal.",
    "The Dawn's cloaking magic granted passage through the warded portal in Plaguewood.", true)

q(9123, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "Arcane cloaking offered passage through the wards on Naxxramas's rune portal in Plaguewood.",
    "The Dawn honored exceptional dedication by waiving the cost of the entry ritual.",
    "The cloaking ritual enabled passage into Naxxramas through the Plaguewood portal.",
    "The Dawn's cloaking magic granted passage through the warded portal in Plaguewood.", true)

q(8285, "The Deserter", "Silithus", 59, "twilight", 3,
    "A restored tablet might be understood by Ortell, a former member of the Twilight's Hammer hiding south of Southwind.",
    "The investigation sought a deserter whose knowledge could help Cenarion Hold interpret the cult's records.",
    "Ortell heard the request and suggested that an exchange of help could benefit both sides.",
    "The search reached a willing source inside the cult's former ranks, but the tablet's secrets were not yet delivered.")

q(8287, "A Terrible Purpose", "Silithus", 60, "twilight", 4,
    "Ortell's information was to be carried to Commander Mar'alith for the struggle against the Twilight's Hammer.",
    "The deserter hoped that helping Cenarion Hold would put him beyond his former sect's reach.",
    "Mar'alith accepted information that clarified the cult's presence in Silithus.",
    "Ortell's account gave Mar'alith a clearer view of the Twilight's Hammer presence in Silithus.")

q(8304, "Dearest Natalia", "Silithus", 60, "natalia", 3,
    "Mar'alith's wife Natalia disappeared after behaving strangely, with her last known route leading toward Bronzebeard's camp.",
    "The commander could not leave his post and asked for questions to be put to the dwarves about Natalia.",
    "The report left Mar'alith resolved to find Natalia, alive or dead.",
    "Still bound to his post, Mar'alith asked for the search to continue until Natalia was found, alive or dead.")

q(8306, "Into The Maw of Madness", "Silithus", 60, "natalia", 5,
    "The search for Natalia led into Hive'Regal, with Mar'alith accepting that madness might make a rescue impossible.",
    "The commander asked that Natalia be found and that whatever proved necessary be done.",
    "The account of Natalia's transformation devastated Mar'alith and introduced him to the name C'Thun.",
    "The hive's revelation tied a personal loss to an unknown power, leaving the commander demanding an explanation.")

q(8314, "Unraveling the Mystery", "Silithus", 60, "hivecode", 3,
    "Recovered glyphs had been copied onto a prism thought to carry messages between the Qiraji and silithid.",
    "Geologist Larksbane was asked to help unlock messages the dwarves could not read.",
    "Larksbane recognized that the outer and inner markings had to align before the prism's message could be accessed.",
    "The prism's mechanism was understood, but its code still had to be unlocked.")

q(8315, "The Calling", "Silithus", 60, "hivecode", 5,
    "The glyphs suggested a meeting at the Bones of Grakkarond where a Qiraji emissary might reveal the crystals' key.",
    "Larksbane proposed using a copied code to draw out the overlords and confront their emissary.",
    "The recovered knowledge left Larksbane holding what she described as twenty thousand years of history.",
    "Larksbane held the recovered record in wonder, calling it twenty thousand years of history.")
-- END REVIEWED WORLD BANDS 20261012



-- The Horde cauldron records have the same staged objectives and outcomes,
-- with Vandis / Dithers / the Bulwark replacing the Chillwind recipients.
-- Each mapping was checked against its own staged corpus record.
for _, pair in ipairs({{5229,5216},{5230,5217},{5231,5219},{5232,5220},
    {5233,5222},{5234,5223},{5235,5225},{5236,5226}}) do
    local original = P.questIDs[pair[2]]
    local function horde(text)
        return (text:gsub("MacDonnell", "Vandis"):gsub("Chillwind", "the Bulwark"):gsub("Arbington", "Dithers"))
    end
    local title = original.title == "Return to Chillwind Camp" and "Return to the Bulwark" or original.title
    q(pair[1], title, original.zone, original.level, "cauldrons", original.importance,
        horde(original.why[1]), horde(original.why[2]), horde(original.after[1]), horde(original.after[2]), true)
end

-- Title-only journal history cannot establish which hand-in was recorded.
-- These fallbacks were checked against every same-title record in the corpus.
fallback("A Sign of Hope", "Badlands", "uldaman", "720,721",
    "The missing Hammertoe had left a lead pointing toward Uldaman.", "Ryedol sought news of the prospector lost near the excavations.",
    "Ryedol's search for Hammertoe Grez had one more lead.", "The search for the missing prospector advanced a step.")
fallback("Tremors of the Earth", "Badlands", "lethlor", "717,732",
    "An agent of Krasus was dealing with the danger around Lethlor Ravine.", "The Kirin Tor's concern in Lethlor depended on old binding magic.",
    "Krasus's agent had help with the danger at Lethlor Ravine.", "The work for Krasus's agent advanced another step.")
fallback("The Ogres of Feralas", "Feralas", "gordunni", "2975,2980",
    "The Gordunni presence was damaging ground around its settlements in Feralas.", "Camp Mojache wanted the ogres' expansion checked.",
    "The Gordunni lost ground near Camp Mojache.", "Camp Mojache's fight against the Gordunni went on.")
fallback("The Torch of Retribution", "Searing Gorge", "retribution", "3453,3454",
    "The gathered components were to become a torch for the planned tower strike.", "The enchanted torch still required preparation before its use against the watch posts.",
    "The Torch of Retribution came closer to being ready for the towers.", "The work on the torch advanced before the strike on the towers.")
fallback("Timbermaw Ally", "Felwood", "timbermaw", "6131,8460",
    "The Timbermaw mistrusted outsiders who failed to distinguish them from corrupted tribes.", "Help against the Deadwood offered a way to earn the Timbermaw's confidence.",
    "The Timbermaw had one more reason to trust an outsider.", "Help given against the Deadwood counted with the Timbermaw.")
fallback("The Name of the Beast", "Azshara", "defiler", "3509,3510,3511",
    "A weapon against the demon lord required his true name and a suitable temper.", "The search for the demon's name brought Loramus's work into Arkkoroc's concerns.",
    "The weapon against the demon lord came a step closer.", "The work toward a weapon against the demon lord advanced a step.")
fallback("It's a Secret to Everybody", false, "linken", "3844,3845,3908",
    "A ruined raft and scattered belongings opened a mystery around a traveler in Un'Goro.", "The inquiry followed personal possessions whose full story remained uncertain.",
    "The traveler's lost belongings yielded one more clue.", "The errand advanced the inquiry without settling the whole mystery.")
fallback("Dark Iron Legacy", false, "forgewright", "3801,3802",
    "Franclorn Forgewright offered access to his city in return for assistance.", "The architect's legacy concerned a hidden key and the return of his hammer.",
    "Franclorn Forgewright's ghost had one more task done in his name.", "The work concerning the architect's legacy advanced a step.")
for _, row in ipairs({{"Target: Felstone Field","5216,5229"},{"Target: Dalson's Tears","5219,5231"},
    {"Target: Writhing Haunt","5222,5233"},{"Target: Gahrron's Withering","5225,5235"}}) do
    fallback(row[1], "Western Plaguelands", "cauldrons", row[2],
        "The cauldron lord's key was needed to reach the plague mixture within.", "The plan called for sampling the cauldron before developing a counteragent.",
        "The access panel was opened, making the cauldron available for sampling.", "The key gave access to the device's contents; the sample still needed analysis.")
end
fallback("Return to Chillwind Camp", "Western Plaguelands", "cauldrons", "5217,5220,5223,5226",
    "A plague sample was needed at Chillwind to develop a counteragent for its cauldron.", "Each cauldron's distinct mixture required examination by the camp's alchemists.",
    "The sample reached Chillwind for study and preparation of the appropriate reagents.", "The delivery gave the camp another cauldron mixture to work with.")
fallback("Return to the Bulwark", "Western Plaguelands", "cauldrons", "5230,5232,5234,5236",
    "A plague sample was needed at the Bulwark to develop a counteragent for its cauldron.", "Each cauldron's distinct mixture required examination by the apothecary.",
    "The sample reached the Bulwark for study and preparation of the appropriate reagents.", "The delivery gave the apothecary another cauldron mixture to work with.")
fallback("The Restless Souls", false, "restless", "5281,5282",
    "Innocent spirits remained trapped among the ruins of Stratholme.", "Egan's work offered a way to help the city's tortured dead.",
    "Egan's effort to help Stratholme's trapped spirits moved forward.", "The restless dead of Stratholme were one step nearer to help.")
fallback("Lethtendris's Web", "Dire Maul", "letweb", "7488,7489",
    "Lethtendris's web held dangerous stores of Dire Maul's magic.", "The device's gathered power prompted a request to take it from its maker.",
    "The web was recovered and handed over, removing it from Lethtendris's control.", "The device reached its intended recipient, whose plans for its power lay beyond the delivery.")
fallback("The Dread Citadel - Naxxramas", "Eastern Plaguelands", "naxxramas", "9121,9122,9123",
    "Arcane cloaking could overcome the wards on Naxxramas's portal in Plaguewood.", "The Dawn adapted a Kirin Tor cantrip to grant entry to the citadel.",
    "The ritual granted access to Naxxramas through the rune portal.", "The cloaking opened the way into the citadel, with its battles still ahead.")

local function z(name, sight1, sight2, stakes1, stakes2)
    P.zones[name] = {sight = {sight1, sight2}, stakes = {stakes1, stakes2}}
end
z("Ashenvale", "Moonwells and ancient trees stood beyond the lumber camps.", "The paths around Splintertree crossed a forest divided by rival claims.", "Work at the lake touched the health of the forest's water.", "The forest held threats beyond the disputes over its timber.")
z("Stonetalon Mountains", "The machinery above Cragpool Lake left the logging operation visible on the mountainside.", "Saws and water wheels interrupted the wooded slopes.", "The Venture Company's machinery sustained its hold on the timber.", "Industrial disputes and damage to the woods met in the same mountain passes.")
z("Hillsbrad Foothills", "Durnholde's ruins stood inland from the farms and coastal roads.", "Southshore and Tarren Mill anchored opposing interests in the foothills.", "Local bounties extended the struggle into ruined strongholds.", "The people of the foothills lived amid competing claims to their land.")
z("Alterac Mountains", "The broken kingdom left camps and strongholds among the highlands.", "The roads north of Tarren Mill approached the Syndicate's refuges.", "The Syndicate carried the influence of fallen Alterac into the surrounding country.", "A ruined kingdom's surviving ambitions still reached into Southshore.")
z("Arathi Highlands", "Stromgarde's divided ruins overlooked the highlands.", "Crystal clusters broke the earth near the Drywhisker reaches.", "The ruins held both living claimants and old protections.", "Ancient weapons and buried powers drew competing searches through Arathi.")
z("Thousand Needles", "Freewind Post stood above the floor of the canyon.", "Splithoof's guarded passages lay among the high stone pillars.", "The Galak defended relics as well as territory.", "A distant moonwell could matter to a task in the dry canyons.")
z("Desolace", "Centaur villages occupied the harsh open country.", "Thunder Axe Fortress gave the Burning Blade a fortified foothold.", "An alliance with one centaur clan deepened the quarrel with another.", "Cult activity and the clans' feuds made different demands on the same land.")
z("Stranglethorn Vale", "Troll inscriptions survived among jungle ruins and submerged stone.", "Hunting camps and military stockpiles occupied separate clearings in the jungle.", "The rebels faced a disciplined human enemy as well as the jungle's other dangers.", "Lost pages and ancient tablets gave the undergrowth more than one kind of search.")
z("Dustwallow Marsh", "Theramore's approaches ran through low marshland.", "The Wyrmbog lay in the south of Dustwallow Marsh.", "Witnesses and physical clues mattered in the investigations around the marsh.", "Old dragon power lay within reach of the same roads used for local errands.")
z("Badlands", "Rock elementals moved among exposed stone and dry ridges.", "Uldaman's excavation opened into works far older than the nearby camps.", "Surface gathering and deep excavation supplied different kinds of knowledge.", "Ancient tablets offered questions as readily as answers.")
z("Swamp of Sorrows", "The Pool of Tears covered the sunken temple's approaches.", "Water and tangled growth hemmed in the swamp's roads.", "Artifacts around the pool preserved traces of the Atal'ai's work.", "Supplies still had to cross the country toward Nethergarde.")
z("Feralas", "Blue traces marked minerals buried near the Gordunni outpost.", "Camp Mojache stood amid thick forest and nearby gnoll territory.", "The Woodpaw's attacks concealed pressure from another direction.", "The forest sustained settlements, expeditions and the creatures pushing against them.")
z("The Hinterlands", "Jintha'Alor rose in terraces toward its high amphitheater.", "The coast and inland hills supported distinct settlements and rival powers.", "The Wildhammers judged assistance by its practical proof.", "Small recoveries mattered beside the searches for ancient relics.")
z("Tanaris", "The Gaping Chasm cut into the desert beyond Gadgetzan.", "Cactus gardens and scattered water holes broke the long reaches of sand.", "Water-finding tools were valuable equipment in the desert.", "The insect burrows raised questions larger than a single missing surveyor.")
z("Searing Gorge", "The Slag Pit cut deep beneath the exposed workings.", "Dark Iron industry marked the gorge with excavations and machinery.", "A stolen recipe could decide who controlled valuable work.", "Rivalries among dwarven craftsmen reached into the gorge's guarded depths.")
z("Azshara", "Old ruins occupied the broken coastline.", "The shore held scattered seekers far from the old city's vanished life.", "A recovered relic could carry meaning far beyond the coast.", "The Waterlords' concerns linked the sea to distant servants of fire.")
z("Blasted Lands", "Razelikh's lair lay above the surrounding wasteland.", "Nethergarde stood watch over a harsh and damaged frontier.", "The stronghold depended on supplies carried across dangerous country.", "Demonic power persisted among the scars of the land.")
z("Un'Goro Crater", "Bright crystals lay scattered through the crater.", "Abandoned expedition camps marked places where research had met danger.", "Food and equipment could decide whether an expedition continued.", "The crater's mysteries required observation as well as survival.")
z("Felwood", "Ruined barrow dens opened beneath the corrupted forest.", "The remains of Constellas stood within the Jadefire's reach.", "Killing a source of corruption did not restore the land at once.", "The forest's recovery faced enemies actively working against it.")
z("Burning Steppes", "The ruins of Thaurissan stood amid scorched ground.", "Dragonkin occupied the slopes below the defended ridges.", "Dwarven records survived where the old landscape had been shattered.", "Local dragon attacks were part of a threat reaching toward Blackrock.")
z("Western Plaguelands", "Watchtowers rose over the ruins of Andorhal.", "The plague cauldrons continued their work among ruined farms.", "A planned assault required preparation before control of a town could change.", "The cauldrons demanded a subtler response than simply breaking them.")
z("Eastern Plaguelands", "The houses of Darrowshire remained after the battle that destroyed its families.", "Ruined settlements and plague-stricken roads carried traces of former lives.", "A child's belongings could matter alongside the campaign against the Scourge.", "The dead left requests that warfare alone could not answer.")
z("Winterspring", "Everlook stood among snowy slopes and the paths toward the ice thistle caves.", "The Frostfire springs interrupted the cold terrain with unusual waters.", "Research at the springs competed with the Winterfall's claim to them.", "Hunts and inventive errands continued beside the region's deeper troubles.")
z("Silithus", "Canvas and broken wood marked a ruined cult camp among the elementals.", "Pulsing red crystals stood out against the desert.", "Cenarion Hold needed care for its workers as well as answers about the cult.", "The Twilight's Hammer hid its plans behind ritual and coded texts.")
z("Moonglade", "Nighthaven's paths lay within the sacred druidic refuge.", "The Great Bear Spirit's domain lay northwest of Nighthaven.", "Druidic instruction proceeded through lessons rather than a single completed errand.", "The refuge welcomed learning despite tensions among the Circle's leaders.")
z("Deadwind Pass", "The pass narrowed among barren rock and dead trees.", "Karazhan stood beyond the lonely approaches through the pass.", "The tower's presence shadowed the surrounding country.", "The road passed through a place set apart from the settled lands on either side.")

-- Coverage: 26 requested regions have setting pools; Deadwind Pass has setting
-- only. Blackrock/Stratholme are additional quest locations. Curated contexts do
-- not imply coverage of every quest, raid, faction, class or Forever addition.
P.zones["Dustwallow Marsh"].source = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #1172 The Brood of Onyxia; #1268 Suspicious Hoofprints; #1252 Lieutenant Paval Reethe"}
-- Scene craft pass 2026-10-15: exact recorded Classic stages only.
-- Evidence and independent review: v2/craft-content-20261015/.
-- Reference-note summaries are deliberately separate from these recollections.
P.threads.world_ashenvale_hunt = "the Ashenvale Hunt"
P.threads.world_jinzil = "Jin'Zil's caged elves"
P.threads.world_mojache_requests = "Krueg's requests at Camp Mojache"
P.threads.world_stonetalon_route = "the stalled route through Stonetalon"
P.threads.world_sven = "Sven Yorgen's search for vengeance"
q(23, "Ursangous's Paw", "Ashenvale", 24, "ashenvale_hunt", 3,
    "Ursangous's severed paw bore a small quarter-crescent. The trophy belonged with Senani Thunderheart at Splintertree Post.",
    "A quarter-crescent marked the paw of Ursangous, one of Ashenvale's mightiest bears. Senani would recognize the trophy.",
    "Senani praised the hunt and took the crescent as a sign of night-elf training. To her, felling Ursangous was a deed worthy of the ancestors.",
    "Senani accepted the bear's paw with praise. She believed its crescent marked a beast trained by the night elves.")
P.questIDs[23].threadLabel = P.threads.world_ashenvale_hunt
P.questIDs[23].source[2] = "https://classicdb.ch/?quest=23"

q(24, "Shadumbra's Head", "Ashenvale", 27, "ashenvale_hunt", 3,
    "Shadumbra's savagery was well known at Splintertree Post, where the nightsaber made the western journey toward Zoram Strand dangerous.",
    "The Ashenvale Hunt counted Shadumbra among its quarry. The swift nightsaber threatened travelers heading west from Splintertree Post.",
    "Senani received Shadumbra's head as a trophy. The western road had lost one of its feared hunters.",
    "The nightsaber's head earned Senani's praise, and she welcomed the easing of the danger on the way to Zoram Strand.")
P.questIDs[24].threadLabel = P.threads.world_ashenvale_hunt
P.questIDs[24].source[2] = "https://classicdb.ch/?quest=24"

q(25, "Stonetalon Standstill", "Ashenvale", 25, "stonetalon_route", 4,
    "Water elementals at Mystral Lake were attacking the transports near Talondeep Path. Mastok also wanted the lake's gazebo surveyed for a view of the Alliance outpost.",
    "Traffic between Ashenvale and Stonetalon had stopped at Mystral Lake. Mastok saw a second use for the expedition in scouting the gazebo overlooking the Alliance outpost.",
    "The elementals were beaten back and the gazebo surveyed. Mastok expected the transports to move more easily, and considered a discreet watch post by the lake.",
    "Mastok welcomed the losses among the lake's elementals. With the gazebo surveyed, he spoke of easier transport and a possible lookout over the Alliance outpost.")
P.questIDs[25].threadLabel = P.threads.world_stonetalon_route
P.questIDs[25].source[2] = "https://classicdb.ch/?quest=25"

q(1058, "Jin'Zil's Forest Magic", "Stonetalon Mountains", 26, "jinzil", 4,
    "Jin'Zil kept three elves in cages at Malaka'jin. His idea of forest magic called for sap, twilight whiskers, courser eyes and a fey dragon's scale.",
    "The elves in Jin'Zil's cages were to receive a brew of his own devising. He sent for ingredients from the plants and creatures of Stonetalon.",
    "Jin'Zil received the ingredients with delight. He promised his concoction would make the captive elves feel at home.",
    "The ingredients reached Jin'Zil, who spoke gleefully of a special concoction for his caged guests.")
P.questIDs[1058].threadLabel = P.threads.world_jinzil
P.questIDs[1058].source[2] = "https://classicdb.ch/?quest=1058"

q(1483, "Ziz Fizziks", "Stonetalon Mountains", 21, "stonetalon", 2,
    "The Venture Company had hired a gnome engineer, Gerenzo Wrenchwhistle. Ziz Fizziks was so affronted that he sought work with Sputtervalve's Tinkers' Union.",
    "Sputtervalve wanted news of Ziz Fizziks at Windshear Crag, the engineer who had left the Venture Company rather than work beside Gerenzo.",
    "Ziz complained that Sputtervalve was worse than his old employers. Still, Union work beat unemployment, and anything was better than working with Gerenzo.",
    "Ziz called Sputtervalve the cruelest of his employers, then conceded that Union work beat a job beside Gerenzo.")
P.questIDs[1483].threadLabel = P.threads.world_stonetalon
P.questIDs[1483].source[2] = "https://classicdb.ch/?quest=1483"

q(2973, "A New Cloak's Sheen", "Feralas", 45, "mojache_requests", 2,
    "Krueg Skullsplitter had come to Feralas on Orgrimmar's business, but his life-mate Korrin was on his mind. She liked new clothes; sprite-darter wings would adorn a cloak.",
    "West of Camp Mojache, sprite darters carried the delicate wings Krueg Skullsplitter wanted for a gift, a new cloak for his life-mate, Korrin.",
    "Krueg received enough wings for Korrin's cloak, perhaps with some to spare. He gave his thanks and hoped Feralas had not made the errand too dangerous.",
    "The wings delighted Krueg. There were enough for the cloak he meant to make for Korrin, and possibly more.")
P.questIDs[2973].threadLabel = P.threads.world_mojache_requests
P.questIDs[2973].source[2] = "https://classicdb.ch/?quest=2973"

q(2974, "A Grim Discovery", "Feralas", 45, "mojache_requests", 4,
    "Krueg recognized the description of the Grimtotem in Feralas. Belgrom had put a bounty on them, and Krueg demanded their horns.",
    "Krueg feared Grimtotem raids on Horde villages. He called for a first strike against the clan in Feralas, with horns as proof.",
    "Krueg accepted the Grimtotem horns and promised to tell Belgrom of the find when he returned to Orgrimmar.",
    "The horns stayed with Krueg at Camp Mojache. He promised a report to Belgrom in Orgrimmar, and offered a future favor in return.", true)
P.questIDs[2974].threadLabel = P.threads.world_mojache_requests
P.questIDs[2974].source[2] = "https://classicdb.ch/?quest=2974"

q(55, "Morbent Fel", "Duskwood", 32, "sven", 5,
    "Morbent Fel's house overlooked Raven Hill cemetery. Sven called for Morbent's Bane to strip away the wizard's protective magic.",
    "Sven's revenge led to the house above Raven Hill cemetery, where Morbent Fel sheltered behind enchantments that Morbent's Bane could undo.",
    "Morbent Fel was dead. For Sven, a small part of a scarcely dared hope had come to pass; the Dark Riders were still at large.",
    "Sven received news of Morbent Fel's defeat with words of wonder. The Dark Riders remained beyond his reach, but this much of his revenge was done.")
P.questIDs[55].threadLabel = P.threads.world_sven
P.questIDs[55].source[2] = "https://classicdb.ch/?quest=55"

q(95, "Sven's Revenge", "Duskwood", 25, "sven", 3,
    "Sven said the Dark Riders had murdered his family. On returning to his farm, he had seen a stranger bury something near the barn before fleeing.",
    "A stranger had fled Sven's farm after hiding something behind an old stump. Sven had left in pursuit of the Dark Riders before he could uncover it.",
    "Behind the old stump lay a mound of hastily piled earth, as though whoever had hidden something there had little time.",
    "The search ended at loose earth behind the old stump, heaped hurriedly over something still concealed.")
P.questIDs[95].threadLabel = P.threads.world_sven
P.questIDs[95].source[2] = "https://classicdb.ch/?quest=95"

-- Source-reviewed continuation 2026-10-15: exact IDs only.
-- Evidence: v2/craft-continuation-content-20261015/final-scenes.json.
P.threads.world_nesingwary = "Hemet Nesingwary's hunting expedition"
q(583, "Welcome to the Jungle", "Stranglethorn Vale", 30, "nesingwary", 3,
    "Barnil Stonepot pointed out Hemet Nesingwary, the Alliance war hero who now hunted Stranglethorn's great beasts. Barnil thought a fellow adventurer might find a welcome despite the dwarf's dislike of strangers.",
    "Barnil Stonepot spoke warmly of Hemet Nesingwary, the veteran Alliance hero and big-game hunter at his expedition's camp. He suggested approaching the dwarf for advice on hunting in Stranglethorn.",
    "Hemet offered a place in the great hunt to anyone who passed three tests, hunting raptors with him, tigers with Ajeck and panthers with Sir Erlgadin.",
    "The welcome came with a challenge. Hemet would judge the raptor hunt, Ajeck the tigers, and Sir Erlgadin the panthers before the expedition shared its greater quarry.", true)
P.questIDs[583].threadLabel = P.threads.world_nesingwary
P.questIDs[583].source[2] = "https://classicdb.ch/?quest=583"

P.threads.world_yenniku = "the Darkspear's lost son"
q(581, "Hunt for Yenniku", "Stranglethorn Vale", 34, "yenniku", 4,
    "Nimboya had come from Orgrimmar to find Yenniku, the Darkspear chief's missing youngest son. He suspected the Bloodscalps held him and called for a hunt among the trolls to the north.",
    "By Darkspear custom, the chief's youngest son Yenniku had been given to the Gurubashi of Zul'Gurub. He was lost to his people after they left with Thrall, and Nimboya now suspected the Bloodscalps held him.",
    "Bloodscalp tusks reached Nimboya. He judged them a sign of strength for the hunting still ahead in the search for Yenniku.",
    "Nimboya accepted the tusks taken from the Bloodscalps. The trophies convinced him that the hunt could go further.", true)
P.questIDs[581].threadLabel = P.threads.world_yenniku
P.questIDs[581].source[2] = "https://classicdb.ch/?quest=581"

P.threads.world_yenniku = "the Darkspear's lost son"
q(582, "Headhunting", "Stranglethorn Vale", 37, "yenniku", 4,
    "Nimboya feared that Yenniku, the Darkspear chief's missing son, might already be dead. He wanted the shrunken heads carried by Bloodscalp Headhunters at Zuuldaia and Zul'Kunda, to see whether the boy's was among them.",
    "The search for Yenniku turned to the Bloodscalp Headhunters' trophies. Nimboya wished a six-hundred-year curse on their chief Gan'zulah's spirit if they had killed the Darkspear chief's son.",
    "The shrunken heads reached Nimboya. He prepared to inspect them, hoping Yenniku had escaped the headhunters' axes.",
    "Nimboya received the headhunters' grisly trophies and said he would examine them for any sign of Yenniku.", true)
P.questIDs[582].threadLabel = P.threads.world_yenniku
P.questIDs[582].source[2] = "https://classicdb.ch/?quest=582"

P.threads.world_yenniku = "the Darkspear's lost son"
q(584, "Bloodscalp Clan Heads", "Stranglethorn Vale", 41, "yenniku", 4,
    "Nimboya thanked the Great Serpent that Yenniku was not among the heads he had examined. He now sought answers from the Bloodscalp chief Gan'zulah and witchdoctor Nezzliok, whose dead heads he meant to question in a cauldron.",
    "Nimboya believed the Bloodscalp chief Gan'zulah and witchdoctor Nezzliok knew what had happened to Yenniku. If they would not speak freely, he intended to make their severed heads tell the truth.",
    "Gan'zulah's and Nezzliok's heads were placed in the bubbling green broth at Grom'gol, ready for Nimboya's questioning.",
    "The two Bloodscalp leaders' heads were brought from Zul'Kunda and lowered into the cauldron. Its greenish broth bubbled around them.", true)
P.questIDs[584].threadLabel = P.threads.world_yenniku
P.questIDs[584].source[2] = "https://classicdb.ch/?quest=584"

P.threads.world_darkspear_trophies = "the Darkspear's Bloodscalp trophies"
q(596, "Bloody Bone Necklaces", "Stranglethorn Vale", 37, "darkspear_trophies", 3,
    "Kin'weelay had come to Grom'gol to help Nimboya, but he also pursued the Darkspear's feud with the Bloodscalps. He claimed that trophies taken from enemies gave his people power over them.",
    "At Grom'gol, Kin'weelay called for the bloody bone necklaces worn by the Bloodscalps to the north. Taking trophies from the Darkspear's enemies, he said, gave his people power over them.",
    "The necklaces reached Kin'weelay. He planned to boil and leech them into paste, claiming that their owners' spirits would weaken with them.",
    "Kin'weelay accepted the bloody necklaces and described how he would render them to paste to weaken their owners' spirits. He repaid the help with a gift.", true)
P.questIDs[596].threadLabel = P.threads.world_darkspear_trophies
P.questIDs[596].source[2] = "https://classicdb.ch/?quest=596"

P.threads.world_dalaran = "Magus Wordeen's Dalaran inquiry"
q(544, "Prison Break In", "Alterac Mountains", 34, "dalaran", 4,
    "Four Forsaken had fled the Undercity with bloodstone artifacts stolen from a secure vault. Magus Wordeen wanted the apothecaries' property recovered from Lordamere Internment Camp, where Dalaran's wizards had quarantined the fugitives.",
    "Magus Wordeen's research at Tarren Mill had been interrupted by a theft from Sylvanas's vault. Four Forsaken had carried the apothecaries' bloodstones to Dalaran and ended up confined in Lordamere Internment Camp.",
    "All four bloodstones returned to Wordeen. He welcomed back the sorely missed artifacts and called the punishment of Kegan and the other fugitives justice.",
    "Wordeen received the stolen bloodstone wedge, marble, shard and oval. The apothecaries had their missing materials back, and he praised the reckoning with the thieves.", true)
P.questIDs[544].threadLabel = P.threads.world_dalaran
P.questIDs[544].source[2] = "https://classicdb.ch/?quest=544"

P.threads.world_dalaran = "Magus Wordeen's Dalaran inquiry"
q(545, "Dalaran Patrols", "Alterac Mountains", 35, "dalaran", 3,
    "Dalaran's great dome kept its purpose hidden. Some said it was for protection, others for the wizards' seclusion. Magus Wordeen cared more about the magical treasures that might remain in the ruins outside it.",
    "Magus Wordeen wanted to search Dalaran's ruined outskirts for magical treasures. Wizards and their enslaved elementals still patrolled outside the dome, and he called for an attack to thin their ranks.",
    "Dalaran summoners and their elemental slaves were defeated among the ruins. Wordeen judged the outskirts safe enough to search, with care.",
    "The fighting thinned the wizard patrols and their bound elementals. Wordeen thought a cautious search of the outskirts could now begin.", true)
P.questIDs[545].threadLabel = P.threads.world_dalaran
P.questIDs[545].source[2] = "https://classicdb.ch/?quest=545"

-- Exact-stage source/editorial review: v2/editorial-20261016/.
P.threads.world_redridge = "Lakeshire's bridge repairs"
P.threads.world_hillsbrad_signal = "Lesh's warning from Hillsbrad"
P.threads.world_plaguelands_campaign = "the campaign beyond the Bulwark"
q(89, "The Everstill Bridge", "Redridge Mountains", 20, "redridge", 3,
    "Lakeshire's iron had gone into arms during the last orc invasion. Gnolls then took Stormwind's replacement shipment, leaving Oslow short of pikes and rivets for Everstill Bridge.",
    "Foreman Oslow needed ironwork for Everstill Bridge. The orc invasion had emptied Lakeshire's stores, and gnolls had seized the replacement caravan from Stormwind.",
    "Oslow welcomed the pikes and rivets. With those supplies, he expected to shore up the crossing soon.",
    "The ironwork gave Oslow's bridge crews the supplies they needed. He promised that the crossing would soon be shored up.", true)
P.questIDs[89].source[2] = "https://classicdb.ch/?quest=89"
q(205, "Troll Witchery", "Stranglethorn Vale", 40, "kurzen", 4,
    "Brother Nimetz turned to the magic carried by the Skullsplitter trolls. He called for fetishes from their witchdoctors and mystics far to the south.",
    "While studying the troll legends, Brother Nimetz wondered whether Skullsplitter magic held a clue to Kurzen's downfall. He needed the tribe's fetishes to examine.",
    "The fetishes drew Nimetz straight to his research. He was eager to learn what their magic might reveal about Kurzen.",
    "The Skullsplitter fetishes gave Nimetz another way into Kurzen's mystery. He was eager to discover what their magic might reveal.", true)
P.questIDs[205].source[2] = "https://classicdb.ch/?quest=205"
q(494, "Time To Strike", "Hillsbrad Foothills", 20, "hillsbrad_signal", 4,
    "Deathstalker Lesh was surveying Hillsbrad and urgently sent word to Darthalia in Tarren Mill. His message spoke of a raven calling from the west.",
    "Lesh's reconnaissance carried a cryptic message for High Executor Darthalia, the raven's cry from the west. He wanted it taken to Tarren Mill at once.",
    "Darthalia understood the signal. Hillsbrad was ready for attack. She expected the plan of destruction to please Varimathras.",
    "The raven's message told Darthalia it was time to strike at Hillsbrad. Varimathras would be pleased, she said.", true)
P.questIDs[494].source[2] = "https://classicdb.ch/?quest=494"
q(5093, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 4,
    "Warcaller Gorlach called for fighters against the Scourge. Rumors of new threats east of the Undercity sent volunteers toward Derrington's base at the Bulwark.",
    "The Horde's call to arms pointed east of the Undercity, where new dangers were rumored among the ruins. Gorlach directed volunteers to High Executor Derrington.",
    "Derrington welcomed the answer to the call at the Bulwark. The Scourge lay to the east, with hard work waiting even at the frontier's edge.",
    "At the Bulwark, Derrington had work for willing hands. He warned that the Plaguelands were among the most dangerous frontiers in Azeroth.", true)
P.questIDs[5093].source[2] = "https://classicdb.ch/?quest=5093"
q(5096, "Scarlet Diversions", "Western Plaguelands", 53, "plaguelands_campaign", 5,
    "Derrington feared fighting the Crusade and Scourge at once. He planned to burn a Scarlet command tent and plant a Scourge banner, turning suspicion toward the undead.",
    "A Scarlet camp between Felstone Field and Dalson's Tears threatened the advance on Andorhal. Derrington wanted its tent burned, then a Scourge banner planted beside the ruins.",
    "The command tent burned and the false banner was planted. Derrington sent a scout to watch the Crusade's response, judging the pressure eased enough to risk Andorhal.",
    "With the Scarlet tent destroyed and the Scourge banner raised, Derrington thought there was time for a move into Andorhal. A scout would watch whether the Crusade took the bait.", true)
P.questIDs[5096].source[2] = "https://classicdb.ch/?quest=5096"
-- Parent owns LoreWorldStories.lua. All five records are deliberately exact-only.
-- Source: corpus_vanilla_quests.txt full blocks #2278/#2279/#2280/#2439/#2440;
-- original #2278 objective/completion and watcher dialogue corroborated online:
-- https://warcraft.wiki.gg/wiki/The_Platinum_Discs_%28neutral%29
-- https://warcraft.wiki.gg/wiki/Lorekeeper_of_Norgannon
q(2278, "The Platinum Discs", "Uldaman", 47, "uldaman", 6,
    "Four platinum discs stood in Uldaman's treasure chamber, attended by a stone keeper of knowledge.",
    "The stone watcher offered the Creators' account of the earthen, preserved in the Discs of Norgannon.",
    "The watcher's history traced dwarves and troggs to the earthen. With the account heard, the discs were ready to produce a portable copy.",
    "The history of earthen, troggs and dwarves ended with a faint hum from the discs. The watcher announced that a portable copy was ready to be made.", true)

q(2279, "The Platinum Discs", "Ironforge", 47, "uldaman", 5,
    "A miniature copy of Uldaman's platinum records offered the Explorers' League a remarkable find.",
    "The portable discs carried ancient knowledge from Uldaman to the scholars of Ironforge.",
    "High Explorer Magellas received the discs with astonishment. He saw possible proof of the dwarves' enchanted creation in the find.",
    "The recovered records astonished Magellas. For the Explorers' League, they might establish the enchanted origins of the dwarves.", true)

q(2280, "The Platinum Discs", "Thunder Bluff", 47, "uldaman", 5,
    "A miniature copy of Uldaman's records offered material for the historians of Thunder Bluff.",
    "The portable platinum discs carried an ancient mystery to the sages of Thunder Bluff.",
    "Sage Truthseeker accepted the discs and sensed secrets that the earth had kept for many years.",
    "Truthseeker welcomed the find, recognizing in the discs a history long hidden within the earth.", true)

q(2439, "The Platinum Discs", "Ironforge", 47, "uldaman", 3,
    "The Explorers' League called for further research into the discs and issued a voucher for a reward from its vault.",
    "A voucher from the League directed the reward for the Uldaman find to Dinita Stonemantle in Ironforge.",
    "Dinita honored the League's voucher with a reward from the vault and a choice of potions.",
    "The League's compensation was collected from Dinita; further study of the discs remained with its scholars.", true)

q(2440, "The Platinum Discs", "Thunder Bluff", 47, "uldaman", 3,
    "Truthseeker intended to study the discs further and sent a reward voucher to Bena Winterhoof.",
    "Bena Winterhoof held a reward from Truthseeker for bringing the ancient records to his attention.",
    "Bena honored Truthseeker's voucher with the promised item and a choice of potions.",
    "The reward was collected from Bena while Truthseeker prepared to investigate the discs' workings.", true)

-- Exact Horde wording after the cauldron contexts have been cloned.
P.questIDs[5229].why = {"Vandis chose Felstone Field for the first sample of plague poison. Its inexperienced Scourge troops guarded a cauldron whose key lay with their lord.", "Felstone's cauldron held the poison Vandis needed for study. Bilemaw guarded the key to its access panel."}
P.questIDs[5229].after = {"Bilemaw's key fitted the panel and vanished. A foul smell rose from the mixture inside, with a spigot ready to draw a sample into the bottle.", "The opened panel released a foul stench. Beneath it, a small spigot offered access to the swirling mixture that Vandis wanted sampled."}
P.questIDs[5230].why = {"A bottle of Felstone's poison was ready for the return to Vandis at the Bulwark.", "The cauldron sample could give the Bulwark's apothecary a way to devise a counteragent."}
P.questIDs[5230].after = {"Vandis received the sample for Apothecary Dithers to analyze. Repeated treatment would be needed, she warned, to turn the cauldrons into an advantage against the Scourge.", "The poison reached Vandis. She hoped Dithers could devise a counteragent and keep enough of it in the cauldrons to weaken the Scourge before battle."}
-- Complete short scenes: exact recorded stages only; see editorial-20261016 author packet.
P.questIDs[1058].highlight = {"Jin'Zil received the forest ingredients for his brew. He promised to make the three elves in his cages feel at home.", "With sap, eyes, whiskers and a fey dragon's scale delivered, Jin'Zil gleefully promised a special brew for his three captive elves."}
P.questIDs[1483].highlight = {"Ziz Fizziks had traded the Venture Company for Sputtervalve's Union. He complained about his new employer, but still preferred him to the gnome Gerenzo.", "At Windshear, Ziz Fizziks complained of Sputtervalve's cruelty. Even that was better, he thought, than working beside Gerenzo at the Venture Company."}
P.questIDs[1093].highlight = {"Ziz received the stolen Super Reaper plans for Sputtervalve, then found himself baffled by Gerenzo's gnomish engineering.", "The Super Reaper blueprints reached Ziz. His eagerness to impress Sputtervalve soon turned to grumbling about incomprehensible gnomish designs."}
P.questIDs[5542].highlight = {"The plaguehounds were dealt with, earning Tirion's invitation to share a warm meal and stories of earlier days.", "Tirion offered rest, food and conversation in thanks for the fight against the plaguehounds near his refuge."}
P.questIDs[5543].highlight = {"Tirion praised the fight against the man-eating plaguebats; the courage behind it lifted his spirits.", "The plaguebat hunt heartened Tirion. Amid the Plaguelands' corrupted wildlife, he welcomed an act of decency."}
P.questIDs[5544].highlight = {"Carrion-worm meat replenished Tirion's dwindling stores. Bland as it was, it would keep through winter.", "Tirion's winter stores were replenished with carrion-worm meat, plain food that could be preserved for months."}
P.questIDs[5241].highlight = {"Pamela sent word that she was waiting for Carlin's story about rabbits and berry jam. Learning of her death, he wished he could take her place.", "Pamela wanted her uncle's tale of rabbits and berry jam again. Carlin grieved for her lingering spirit and wished himself in her place at Darrowshire."}
P.questIDs[5211].highlight = {"Some fallen defenders of Darrowshire were freed from their Scourge bodies. Carlin welcomed news that their tortured souls were released.", "Carlin's plea brought freedom to some of Darrowshire's dead, releasing their souls from the ghouls and flayers that served the Scourge."}
P.questIDs[588].highlight = {"Nezzliok named Zanzil as Yenniku's captor. Kin'weelay feared the witchdoctor's power, but held to a tiny hope of saving the boy.", "The cauldron's answer pointed to Zanzil's hold over Yenniku. To Kin'weelay, the hope of breaking it was faint, but still hope."}
P.questIDs[589].highlight = {"The basilisk shards for Yenniku's rescue reached Kin'weelay. He heard them sing and had learned where the Mind's Eye lay, and who guarded it.", "Kin'weelay welcomed the blue shards for the Mind's Eye ritual. The jungle spirits had meanwhile revealed the jewel's hiding place and guardian."}
P.questIDs[592].highlight = {"The Soul Gem reached Nimboya with Yenniku freed from Zanzil's will. The rescue he had feared impossible was accomplished.", "Nimboya received the Soul Gem and confirmed Yenniku's freedom from Zanzil. He promised that the tribe would remember the rescue in song and stone."}
P.questIDs[652].highlight = {"Fozruk's Rod of Order opened the Keystone that held Myzrael. The ground shuddered beneath it.", "Fozruk's Rod of Order, the key Myzrael sought, was placed in the Keystone. A shudder passed through the earth."}
P.questIDs[688].highlight = {"Myzrael sent word to Zaruk in Hammerfall. He welcomed the visit and was ready to discuss summoning her to the surface.", "Myzrael had told Zaruk to expect the visit in Hammerfall. He was ready to discuss her summoning to the surface."}
P.questIDs[642].highlight = {"Motes taken from the Drywhiskers awakened Myzrael's crystal shards. The imprisoned voice welcomed their strength, still pleading for freedom.", "Myzrael spoke through the newly powered Drywhisker shards. The motes had strengthened her, she said, though freedom was still distant."}
P.questIDs[651].highlight = {"The Stones of Binding opened. Through them Myzrael announced that her shackles were loosening, and thanked her rescuer.", "Opening Arathi's binding stones brought Myzrael's grateful voice through the stone. She could feel her restraints loosen."}
P.questIDs[656].highlight = {"Myzrael was defeated and bound again with her Eldritch Shackles. A wail rose from below, and the once-comforting shards pulsed with menace.", "The summoning ended with Myzrael defeated and shackled beneath Arathi again. Her shards answered with a roar from below and open menace."}
P.questIDs[7044].highlight = {"Vyletongue's and Noxxion's stolen scepter pieces reached Celebras. Newly awake from his nightmare, he could hope for Maraudon's cleansing.", "The two scepter pieces were recovered for Celebras. Waking from corruption's nightmare, he saw a chance that Maraudon might one day be healed."}
P.questIDs[4285].highlight = {"The rumors led to a real pylon in northern Un'Goro, another clue to the crater's scattered crystals.", "The northern pylon was found, confirming the rumors behind the search for Un'Goro's crystal structures."}
P.questIDs[4287].highlight = {"The survey found a crystal-lined pylon in eastern Un'Goro, giving the crater's crystal research another site to study.", "A visit confirmed the rumored eastern pylon, one of the structures being sought among Un'Goro's scattered crystals."}
P.questIDs[4288].highlight = {"The search found Un'Goro's western pylon, extending the survey of its mysterious crystal structures.", "The western pylon was located, another site for the search into Un'Goro's crystals."}
P.questIDs[4492].highlight = {"Spraggle's missing friend Ringo was found alive at the volcano, dazed but grateful that someone had reached him.", "The search for Spraggle's friend found Ringo at the volcano. He was alive, and barely able to express his relief."}
P.questIDs[4491].highlight = {"Despite the heat exhaustion, Ringo reached Marshal's Refuge with help. Spraggle was glad to have her friend back alive.", "Ringo was brought back to Spraggle at Marshal's Refuge, still suffering from the heat but alive."}
P.questIDs[1195].highlight = {"Moonwell water was collected for the Galak relic expedition. The filled phial was ready to carry to Rau in Thousand Needles.", "The filled moonwell phial was prepared for Rau, who had requested it for the search for a Galak centaur relic."}
P.questIDs[1196].highlight = {"Rau received the moonwell water at Freewind Post. He explained how dryads' kinship with centaurs would let it breach the relic's protective flame.", "The phial reached Rau, who explained that through the dryads' shared ancestry with centaurs, moonwell water could pierce the relic's eternal flame."}
P.questIDs[7761].highlight = {"Blackhand's letter exposed the orb's safeguard. Drakkisath's brand gave the Mark of Drakkisath, opening the way into Blackwing.", "The Mark of Drakkisath satisfied the Blackwing orb's ward, just as Blackhand's captured letter had described."}
P.questIDs[4788].highlight = {"The last Mosh'aru tablets were recovered from Blackrock Spire's Smolderthorn. Their reader feared what the earlier passages foretold.", "The fifth and sixth Mosh'aru tablets reached the scholar, whose reading of the earlier pair had already raised fears of what was coming."}
P.questIDs[7848].highlight = {"With a core fragment from Blackrock Depths, Lothos completed the attunement and offered passage into Molten Core.", "Lothos received the core fragment and attuned the traveler to the hidden portal. He could now offer transport to Molten Core."}
P.questIDs[583].highlight = {"At Nesingwary's expedition, Hemet set three tests before the great hunt, with his raptors, Ajeck's tigers and Sir Erlgadin's panthers.", "Barnil's introduction led to Hemet's hunting challenge, three hunts with three different hunters."}
P.questIDs[581].highlight = {"Nimboya sought Yenniku, the Darkspear chief's son once given to the Gurubashi. Bloodscalp tusks convinced him the hunt for the missing boy could go further.", "Bloodscalp tusks reached Nimboya in the search for Yenniku, the Darkspear chief's missing son. Nimboya took the trophies as grounds for a harder hunt."}
P.questIDs[582].highlight = {"Bloodscalp shrunken heads reached Nimboya for inspection. He feared that one might belong to the missing Yenniku.", "Nimboya received the headhunters' trophies and prepared to look for Yenniku among them, hoping the boy had escaped their axes."}
P.questIDs[584].highlight = {"Seeking Yenniku's fate, Nimboya called for Gan'zulah and Nezzliok's heads. Both were placed in the green broth of his cauldron, ready for questioning.", "Gan'zulah's and Nezzliok's severed heads lay in the bubbling cauldron. Nimboya intended to question them about Yenniku."}
P.questIDs[596].highlight = {"Kin'weelay accepted Bloodscalp bone necklaces, planning to render them into paste. He claimed this would weaken their owners' spirits.", "The Bloodscalp trophies reached Kin'weelay. He meant to boil the necklaces into paste, a rite he claimed would weaken the enemy's spirits."}
P.questIDs[2978].highlight = {"A gathering or ceremony seemed to mark a soiled Gordunni scroll. Rok Orhan received it and asked whether it came from the Gordunni Outpost.", "Rok Orhan received the Gordunni scroll, whose markings might show a ceremony. His first question was whether it had come from the outpost."}
P.questIDs[89].highlight = {"With Lakeshire's iron spent on arms and a replacement caravan stolen, Oslow welcomed pikes and rivets for Everstill Bridge. He expected to shore up the crossing soon.", "Pikes and rivets reached Oslow's bridge effort after war and a stolen shipment had emptied Lakeshire's stores. He expected the crossing's repairs to move quickly."}
P.questIDs[205].highlight = {"Skullsplitter fetishes reached Brother Nimetz, who hoped their magic might explain Kurzen's descent into evil.", "Brother Nimetz received the troll fetishes for study, seeking an answer to Kurzen's downfall in Skullsplitter magic."}
P.questIDs[494].highlight = {"Lesh's raven message reached Darthalia in Tarren Mill. She read it as the signal to attack Hillsbrad, and expected Varimathras's approval.", "Darthalia understood the cryptic word from Lesh's reconnaissance. Hillsbrad was ready for attack. She thought Varimathras would be pleased."}
P.questIDs[5093].highlight = {"Gorlach's call against the Scourge led to Derrington at the Bulwark. He welcomed the response and warned of the dangerous frontier beyond.", "Derrington welcomed the answer to Gorlach's summons at the Bulwark, with the Scourge to the east and work waiting along the frontier."}
P.questIDs[5096].highlight = {"The Scarlet command tent was burned and a Scourge banner planted beside it. Derrington had sent a scout to watch the response and judged Andorhal worth the risk.", "Derrington's false-flag raid left a burned Scarlet tent and a Scourge banner. He sent a scout to see whether the deception worked, while considering Andorhal."}
P.questIDs[574].highlight = {"Yohwa's strike against Kurzen's elite brought Doren hope for the rebels. He had feared they were alone against the Colonel's brilliance.", "Kurzen's commandos and headshrinkers were defeated in the Stockpile. Doren took hope from the report, trusting Yohwa's judgment of the help she had found."}
P.questIDs[202].highlight = {"Kurzen and his leaders fell in the Stockpile. Doren welcomed proof that the rebels were free of the commander whose cunning he had feared.", "Proof of Kurzen's defeat reached Doren. The rebels' former commander was dead, and Doren said they could breathe more easily."}
P.questIDs[207].highlight = {"Four troll tablets were transcribed for Nimetz, who hoped their legends might explain how the once-noble Kurzen had fallen into evil.", "The copied legends from Stranglethorn's ruins reached Nimetz for study. He suspected troll magic behind Kurzen's downfall."}
P.questIDs[206].highlight = {"Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve good; if not, he meant to destroy it.", "Nimetz received the Mind's Eye after Mai'Zoth's defeat. He believed the ogre had corrupted Kurzen and would judge whether the artifact must be destroyed."}
P.questIDs[1068].highlight = {"The shredders XT:4 and XT:9 were destroyed. The shaman reported relief among Stonetalon's tree spirits and hoped the Venture Company would withdraw.", "Stopping XT:4 and XT:9 soothed many tree spirits, the shaman said. He hoped the machines' destruction would drive the Venture Company from the mountains."}
P.questIDs[5228].highlight = {"At Derrington's direction, Vandis explained a plan to turn the four western plague cauldrons against the Scourge by changing their poison.", "Vandis outlined the cauldron plan at the Bulwark, to gain access to the four western devices and make their plague harm the Scourge."}
P.questIDs[5229].highlight = {"Bilemaw's key opened the Felstone cauldron and vanished. Foul fumes rose from the mixture inside; its spigot offered a place to draw the sample Vandis needed.", "The Felstone cauldron opened with Bilemaw's key, releasing a foul smell. A spigot made its poisonous mixture accessible for Vandis's sample."}
P.questIDs[5230].highlight = {"The Felstone sample reached Vandis at the Bulwark. Dithers could now study it for a counteragent, though Vandis warned the cauldrons would need repeated treatment.", "Vandis received Felstone's poison for Dithers to analyze. She hoped sustained treatment of the cauldrons could weaken the Scourge before battle."}
P.questIDs[1026].highlight = {"The hidden chest near Felwood yielded Dartol's iron shaft. Shael'dryn welcomed its recovery and wished she could do more for the corrupted treants.", "A corrupted treant's key opened the chest holding the rod's iron shaft. Shael'dryn welcomed the find, still troubled by the treants' fate."}
P.questIDs[1027].highlight = {"The iron pommel, last of the rod's pieces, reached Shael'dryn. She welcomed the news for Raene and could now see about repairing it.", "The search among Dor'danil's slain druids recovered the iron pommel. Shael'dryn called it wonderful news for Raene and offered to help repair the rod."}
P.questIDs[1029].highlight = {"News of the restored rod reached Raene. She said Teronis would be proud that the work he began had continued after his death.", "Raene welcomed word that Dartol's rod was restored. She thought Teronis would be proud to see his search carried on."}

-- The rescue and its return report are distinct stages in each faction's account.
-- Exact IDs only: Moira's later explanation must not enter the rescue outcome.
q(4003, "The Royal Rescue", "Blackrock Depths", 59, "royal_rescue", 5,
    "Thrall believed Emperor Thaurissan held Princess Moira under a spell. He ordered the emperor killed and warned that Moira must be spared, even if she attacked.",
    "Thrall hoped a strike against Thaurissan would shake the Dark Iron kingdom. Killing the emperor was meant to free Moira, whom he strictly forbade anyone to harm.",
    "Emperor Dagran Thaurissan was slain, and Moira survived. She met the deed with a cry of dismay, demanding to know what had been done.",
    "The emperor fell in Blackrock Depths. Moira answered the deed by demanding to know what had been done.", true)
q(4362, "The Fate of the Kingdom", "Blackrock Depths", 59, "royal_rescue", 5,
    "Magni feared Thaurissan held both his daughter and Ironforge at his mercy. He sent help to kill the emperor, insisting that Moira be spared whatever she said or did.",
    "Magni believed only Thaurissan's death could break the spell on his daughter. His plea was to rescue Moira without harming her.",
    "Thaurissan was killed, but Moira wept over his loss. Her only question was why.",
    "The emperor's death brought Moira to tears. The daughter Magni had sent help to rescue mourned Thaurissan and demanded to know why he had been killed.", true)
q(4004, "The Princess Saved?", "Orgrimmar", 60, "royal_rescue", 5,
    "Moira called the slain emperor her husband and said their unborn child would rule Ironforge. She sent word back to Thrall, threatening vengeance for the child's father.",
    "Moira's explanation turned the rescue into an accusation. Thaurissan had been her husband, and their unborn child would inherit Ironforge. Thrall was to hear what his intervention had done.",
    "The news startled Thrall. He saw a future Dark Iron ruler of Ironforge as a new threat, rewarded the completed mission, and dismissed the messenger so he could consult Sylvanas and Cairne.",
    "Thrall was taken aback by Moira's news. He feared what her unborn child's claim to Ironforge would mean, paid the promised reward, and said he must consult Sylvanas and Cairne.", true)
q(4363, "The Princess's Surprise", "Ironforge", 59, "royal_rescue", 5,
    "Moira praised Thaurissan as honorable and said his death had ruined her life and her unborn child's. She demanded that Magni be told Ironforge's heir would be a Dark Iron dwarf.",
    "Moira sent her father a defiant message. The heir to Ironforge would be a Dark Iron dwarf, with or without his approval. News of her unborn child had to reach the king.",
    "Magni was visibly upset by the report. He felt Thaurissan had won even in death, then dismissed the messenger with a reward from the royal vault.",
    "The message reached Magni, who took it as Thaurissan's victory beyond death. Upset, he offered a reward from the royal vault and dismissed the bearer of the news.", true)
P.threads.world_royal_rescue = "the effort to rescue Moira"
P.questIDs[4003].highlight = {"Thaurissan was slain and Moira survived. She greeted the rescue with dismay, demanding to know what had been done.", "The emperor fell in Blackrock Depths. Moira answered the deed by demanding to know what had been done."}
P.questIDs[4362].highlight = {"Thaurissan was killed, but Moira wept over his loss and asked why.", "The emperor fell. Moira, whom Magni had sent help to rescue, mourned his death."}
P.questIDs[4004].highlight = {"Moira's news of her unborn child startled Thrall. He feared a Dark Iron heir to Ironforge, rewarded the mission, and planned to consult Sylvanas and Cairne.", "Thrall heard Moira's account of her husband and unborn child. Fearing the child's claim to Ironforge, he rewarded the messenger and said he must consult Sylvanas and Cairne."}
P.questIDs[4363].highlight = {"Moira's news of a Dark Iron heir reached Magni. Upset, he saw Thaurissan's victory even in death and dismissed the messenger with a royal reward.", "Magni received Moira's message about her unborn child. He felt Thaurissan had won beyond death and offered a reward from the royal vault."}

-- Compact outcomes preserve each step of the Tanaris investigation.
P.questIDs[992].highlight = {"The water survey met an insect ambush. Fizzledowser admitted he had dismissed earlier reports of creatures draining the desert's water.", "The tapped widget came back with news of an ambush. Fizzledowser finally credited the reports of water-draining insects he had blamed on the nomads."}
P.questIDs[82].highlight = {"Pestlezugg began examining the Centipaar parts and suspected outside control. He urged an immediate return to Fizzledowser, who faced an emergency.", "The Centipaar specimens were unlike any insects Pestlezugg knew. He suspected an outside influence, then sent word that Fizzledowser urgently needed help."}
P.questIDs[10].highlight = {"Scrimshank's gear returned from the Gaping Chasm. Fizzledowser mourned him and hoped the records would help explain the unnaturally cunning insects.", "Fizzledowser received Scrimshank's equipment and mourned the young surveyor. He hoped the records would help against insects he suspected were being controlled."}
P.questIDs[110].highlight = {"Pestlezugg's results troubled him. He believed an unknown malignant power had remade the insects into ravagers.", "The analysis strengthened Pestlezugg's suspicion of outside control. He believed the insects had been changed into ravagers by an unknown power."}
P.questIDs[113].highlight = {"Fizzledowser agreed to copy the report for free distribution. He disliked giving away valuable information, but trusted Pestlezugg's warning.", "The report reached Fizzledowser, who agreed to copy it. Pestlezugg's judgment outweighed his reluctance to give valuable findings away."}

-- BEGIN OVERNIGHT WORLD PASS 20261105
-- Exact IDs from corpus_vanilla_quests.txt (Quest / Progress / Completion), read
-- in full before writing; NPC names cross-checked against LoreForever quest
-- metadata (facts only). Report: StorageInvestigation/cj-overnight-20261105/world/.
local function src(id, extra)
    local v = P.questIDs[id]
    v.source[2] = "https://classicdb.ch/?quest=" .. id
    if extra then v.source[3] = extra end
end
local function hl(id, h1, h2) P.questIDs[id].highlight = {h1, h2} end

-- Batch 1: the Tanaris investigation carried to the scholars, Un'Goro and back;
-- Feathermoon's missing courier. Shared titles are exact-only with fallbacks.
P.threads.world_raschal = "the search for Feathermoon's missing courier"
P.threads.world_gahzridian = "the hydra ornaments of Tanaris"
q(32, "Rise of the Silithid", "Orgrimmar", 48, "silithid", 4,
    "Fizzledowser wanted his insect report read by Zilzibin Drumlore, a troll historian who had long studied creatures unique to Azeroth. Zil lived on the upper tier of the Drag in Orgrimmar.",
    "The Gadgetzan report needed a scholar's judgment. Fizzledowser sent it to Zilzibin Drumlore in Orgrimmar, hoping the troll could say what the insects were and how to stop them.",
    "Zilzibin had dealt with these creatures before. He named them silithid, tools of a threat to Horde and Alliance alike, and warned that they would consume Tanaris quickly.",
    "The report reached Zilzibin. He gave the insects a name, silithid, and called them one of the greatest menaces the world would face.", true)
q(162, "Rise of the Silithid", "Darnassus", 49, "silithid", 4,
    "Fizzledowser sent his insect report to Gracina Spiritmight, a night elf historian who had long studied the creatures of Azeroth. She lived in the Temple of the Moon in Darnassus.",
    "A scholar in Darnassus might explain the danger in Tanaris. Fizzledowser trusted Gracina Spiritmight, at the Temple of the Moon, to know how the insects could be stopped.",
    "Gracina recognized the creatures in the report. Her people knew them as silithid, and she called them tools of a danger to Horde and Alliance alike.",
    "In the Temple of the Moon, Gracina named the insects silithid. She warned that they would consume the Tanaris desert and regretted that no one had seen the danger sooner.", true)
q(4267, "Rise of the Silithid", "Darnassus", 46, "raschal", 4,
    "Shandris Feathermoon sent a copy of Raschal's report on the infestation of southeastern Feralas to Gracina Spiritmight, a priestess at the Temple of the Moon.",
    "While Raschal's report went to Darnassus through official hands, General Feathermoon wanted a copy placed with Gracina Spiritmight, whose knowledge of such creatures might help.",
    "Gracina knew the creatures in Raschal's report. She named them silithid, warned that they would consume Feralas, and prayed for the resolve to defeat them.",
    "The copy reached the Temple of the Moon. Gracina called the insects of Feralas silithid, mere tools of a far greater threat to Horde and Alliance.", true)
fallback("Rise of the Silithid", "Tanaris", "silithid", "32,162,4267",
    "Reports of strange insects in southern Kalimdor were carried to a scholar who knew such creatures.",
    "An insect report needed a historian's judgment before anyone could say what the creatures were.",
    "The scholar who received the report named the insects silithid and warned of the danger they posed.",
    "A historian read the insect report and gave the creatures their name, silithid.")
q(4493, "March of the Silithid", "Tanaris", 53, "silithid", 4,
    "Gracina believed the silithid existed to devour everything outside their own ecology, and that their strength came from Un'Goro Crater. She sent her theory to Alchemist Pestlezugg in Gadgetzan.",
    "What had been seen so far, Gracina thought, was only the first stage. She suspected the hives drew their strength from Un'Goro Crater and wanted Pestlezugg in Gadgetzan to hear it.",
    "Pestlezugg took up Gracina's theory. Un'Goro was a mysterious jungle west of Gadgetzan, and he thought it might bring him a step closer to understanding the silithid.",
    "Gracina's message reached Pestlezugg. He was not sure the crater was the heart of the silithid, but he was ready to look there.", true)
q(4494, "March of the Silithid", "Tanaris", 53, "silithid", 4,
    "Zilzibin believed the silithid existed to devour everything outside their own ecology, and that their strength came from Un'Goro Crater. He sent his theory to Alchemist Pestlezugg in Gadgetzan.",
    "What had been seen so far, Zilzibin thought, was only the first stage. He suspected the hives drew their strength from Un'Goro Crater and wanted Pestlezugg in Gadgetzan to hear it.",
    "Pestlezugg took up Zilzibin's theory. Un'Goro was a mysterious jungle west of Gadgetzan, and he thought it might bring him a step closer to understanding the silithid.",
    "Zilzibin's message reached Pestlezugg. He was not sure the crater was the heart of the silithid, but he was ready to look there.", true)
fallback("March of the Silithid", "Tanaris", "silithid", "4493,4494",
    "A scholar suspected that the silithid drew their strength from Un'Goro Crater.",
    "The theory that the hives were rooted in Un'Goro Crater was sent to Alchemist Pestlezugg in Gadgetzan.",
    "Pestlezugg heard the theory about Un'Goro Crater.",
    "The message about the silithid and Un'Goro reached Pestlezugg in Gadgetzan.")
q(4496, "Bungle in the Jungle", "Tanaris", 53, "silithid", 4,
    "Pestlezugg's research suggested that the silithid behaved like bees, and that a dead queen would throw her hive into disarray. His lure needed an undamaged scent gland from the Un'Goro hive and samples of the crater's soil.",
    "To draw a silithid queen into the open, Pestlezugg meant to brew a lure. He needed a scent gland from one of the crater's insects, intact, and some of Un'Goro's native soil.",
    "The gland's membrane was intact and the soil would serve. He began grinding both into the lure he hoped would stop the silithid before they overran Gadgetzan.",
    "Pestlezugg had his reagents. With a few additions of his own, the gland and the Un'Goro soil would become a lure for the hive's queen.")
q(4507, "Pawn Captures Queen", "Tanaris", 54, "silithid", 5,
    "Pestlezugg's lure was meant for a crystal in the hive's hatcheries, which he believed the silithid used to attune the whole hive. It should draw out the queen, and he wanted her brain for study.",
    "The queen would answer the lure with guards around her. Pestlezugg asked for her brain, which he needed to learn whether a malign intelligence controlled the silithid.",
    "The queen's brain reached Pestlezugg, who called the day quite a victory. He still doubted that one queen was the full extent of the silithid; the resolution seemed too clean to him.",
    "Pestlezugg received the brain for study and celebrated the success. Then he admitted his doubt that the silithid ended with this queen.")
q(4508, "Calm Before the Storm", "Darnassus", 54, "silithid", 4,
    "Pestlezugg sent his latest report to Gracina Spiritmight. She had friends among the Alliance's leaders, and Gadgetzan could not fight the silithid alone.",
    "The findings from the Un'Goro hive needed hands that could act on them. Pestlezugg hoped Gracina, in Darnassus, could bring powerful friends into the fight.",
    "Gracina doubted the report would change much. The Alliance looked only for threats from the Horde, she said, and Fandral Staghelm denied that the silithid were the ancient danger she believed them to be.",
    "Gracina accepted Pestlezugg's report with little hope. She blamed leaders who could see no enemy but the Horde, Fandral Staghelm among them, and urged that the fight against the silithid go on.", true)
q(4509, "Calm Before the Storm", "Orgrimmar", 54, "silithid", 4,
    "Pestlezugg sent his latest report to Zilzibin Drumlore. The troll had friends high in the Horde, and Gadgetzan could not fight the silithid alone.",
    "The findings from the Un'Goro hive needed hands that could act on them. Pestlezugg hoped Zilzibin, on the Drag in Orgrimmar, could bring powerful friends into the fight.",
    "Zilzibin doubted the report would do much good. The Horde looked for no enemy but the Alliance, he said; Thrall might act on the facts, but conflicting advice surrounded him.",
    "Zilzibin received Pestlezugg's findings with frustration. He believed Thrall would listen if the facts reached him, and blamed advisers who saw every danger as a chance to strike at the Alliance.", true)
fallback("Calm Before the Storm", "Tanaris", "silithid", "4508,4509",
    "Pestlezugg's findings on the silithid were sent to a scholar with friends among the leaders of a faction.",
    "Gadgetzan could not fight the silithid alone, so Pestlezugg's report went to a scholar who might reach the powerful.",
    "The scholar received Pestlezugg's report, doubtful that the faction's leaders would heed it.",
    "Pestlezugg's report reached the scholar, who urged that the fight against the silithid continue.")
hl(4507, "The silithid queen's brain reached Pestlezugg for study. He called it a victory, then said the resolution seemed too clean to be the end of the hives.",
    "Pestlezugg received the queen's brain from the Un'Goro hive. He doubted one queen was the full extent of the silithid.")
hl(4508, "Pestlezugg's report reached Gracina. She doubted it would move leaders who feared only the Horde, and blamed Fandral Staghelm's arrogance.",
    "Gracina took Pestlezugg's findings, unsure they would help. Fandral Staghelm, she said, refused to see the silithid as the ancient danger she knew them to be.")
hl(4509, "Pestlezugg's report reached Zilzibin. He doubted it would move a Horde that watched only the Alliance, though Thrall might act if the facts reached him.",
    "Zilzibin took Pestlezugg's findings with frustration. Thrall might listen, he said, but conflicting advice surrounded the Warchief.")
q(3161, "Gahz'ridian", "Tanaris", 48, "gahzridian", 2,
    "Long ago the trolls of Tanaris carved ornaments in honor of Gahz'rilla, the hydra they worshipped. Marvon Rivetseeker named their material Gahz'ridian and wanted more of it to study.",
    "Marvon Rivetseeker was a scientist and a treasure hunter at heart. He lent out a helmet of his own invention that detected the buried troll ornaments called Gahz'ridian.",
    "The ornaments suited Marvon's studies perfectly. He thanked the searcher, then asked for his helmet back.",
    "Marvon received the Gahz'ridian ornaments for study. His detector helmet came back to him as well.")

q(4124, "The Missing Courier", "Feralas", 43, "raschal", 3,
    "A Feathermoon courier had been missing for about a week, and the Stronghold's own searches had found nothing. Latronicus Moonspear asked for help on behalf of Ginro Hearthkindle.",
    "Latronicus Moonspear had declared the courier missing in action, but his associate Ginro Hearthkindle still wanted help finding him and the parcels he carried.",
    "Ginro welcomed the help, though he called the search a lost cause. Each day he went out into Feralas looking for Raschal and came back with nothing but gnoll teeth.",
    "At the Stronghold, Ginro accepted the offer of help. A week of his own searching for Raschal had brought him only gnoll teeth and disappointment.", true)
q(4125, "The Missing Courier", "Feralas", 43, "raschal", 3,
    "Raschal had set out for Thalanaar a week earlier, planning to row down the coast and cross southern Feralas away from the Horde camp. Ginro had never found his boat.",
    "Ginro knew Raschal's route. The courier, with Feathermoon since the expedition first landed, meant to take a rowboat down the coast, and the boat might hold a clue.",
    "The rowboat lay wrecked in muddy water, its port side torn with holes and a Feathermoon crest painted on the other. Something had tried to snap it in two.",
    "Raschal's boat was found, nearly shredded to its frame, with the Stronghold's crest on its side. In the mud beneath it, something metal glinted.", true)
fallback("The Missing Courier", "Feralas", "raschal", "4124,4125",
    "Raschal, a Feathermoon courier bound for Thalanaar, had been missing for about a week.",
    "Ginro Hearthkindle was still searching Feralas for the Stronghold's missing courier.",
    "The search for Raschal moved a step forward.",
    "Ginro's search for the missing courier had new help.")
q(4127, "Boat Wreckage", "Feralas", 44, "raschal", 3,
    "A well-kept knife lay in the mud beneath the wrecked boat. Ginro had asked for any clue to be brought back to the Stronghold.",
    "The knife from the wreck might have belonged to whoever was aboard, and Ginro Hearthkindle was waiting at Feathermoon for any clue.",
    "The knife was Raschal's, Ginro believed. Alone it proved little, so he suggested an unusual way to learn more, a reading called psychometry.",
    "It was Raschal's knife, Ginro said. Finding it with the boat did not explain the disappearance, and he began to talk of psychometry.")
q(4129, "The Knife Revealed", "Feralas", 44, "raschal", 3,
    "Quintis Jonespyre, the Stronghold's druid, could read an object's history by touch. Ginro sent the knife to his tree house with a promise to forgive Quint's card debt.",
    "Ginro did not understand Quint's psychometry, but he had seen it work. The druid also owed him money from Kalimdor Hold 'Em.",
    "Quint agreed to read the knife. Psychometry was no exact art, he warned, and it drained him, but he hoped for a glimpse of what had happened to Raschal.",
    "Quint took the knife. Known at the Stronghold's card tables as the King of the Bad Beats, he thought this reading might be the breakthrough the search needed.")
q(4130, "Psychometric Reading", "Feralas", 44, "raschal", 4,
    "Quint's vision showed Raschal carrying two leather backpacks inland and meeting Woodpaw gnolls. Back at his boat, the courier was so frightened that he never saw water elementals forming behind him.",
    "Still unsteady from the reading, Quint described what the knife had shown and sent word to Ginro. Raschal had been terrified of something just before the visions stopped.",
    "Ginro heard Quint's visions and promised to go easier on him at cards. Raschal could handle gnolls, he said, so something else had frightened him.",
    "The visions reached Ginro. Gnolls had never worried Raschal, he said, and the courier's terror pointed to something worse.")
q(4131, "The Woodpaw Gnolls", "Feralas", 44, "raschal", 3,
    "Ginro doubted the Woodpaw had killed Raschal, but their camps were the best place to start. Gnolls kept what they scavenged, and the missing backpacks might be among their spoils.",
    "With Quint's vision to go on, Ginro no longer wanted to avoid a fight. He sent the search straight into the Woodpaw camps for Raschal's backpacks.",
    "Two leather backpacks hung on a tree near the Woodpaw camps, each marked with the small insignia of Feathermoon Stronghold.",
    "The backpacks from Quint's vision turned up among the gnoll camps, tacked to a tree and still bearing the Stronghold's insignia.")
q(4135, "The Writhing Deep", "Feralas", 46, "raschal", 4,
    "Raschal's backpacks held a parcel for Thalanaar and a hurried note. He had found insect creatures in the Writhing Deep, south of the gnoll camps, and gone to investigate them himself.",
    "A note signed by Raschal of Feathermoon described bug-like creatures in a place called the Writhing Deep. He believed they threatened all of Feralas.",
    "Inside the Writhing Deep stood a pod as tall as a person, slick and studded with hardened growths. A faint humanoid shape showed through its skin.",
    "Raschal's trail ended at a pod in the Writhing Deep. Through its skin, the shape of someone sealed inside could just be seen.")
q(4265, "Freed from the Hive", "Feralas", 46, "raschal", 5,
    "The pod split open and released Raschal, alive and stunned. The insects had overwhelmed him, and he had woken paralyzed inside it.",
    "Raschal, the missing courier, came out of the pod alive and thanked Elune. He asked whether the Stronghold had sent help.",
    "Raschal reached Feathermoon and told Ginro what had happened. Ginro said the courier would have died without that timely aid, and promised to remain a friend.",
    "Back at the Stronghold, Raschal had already reported in. Ginro said the rescue had come without a mercenary's fee and called it a hero's deed.")
q(4266, "A Hero's Welcome", "Feralas", 46, "raschal", 4,
    "General Shandris Feathermoon wanted to give her thanks in person, and to discuss the Zukk'ash insects found in southern Feralas.",
    "Ginro sent word that Shandris Feathermoon was waiting in the main compound. The reports of the Zukk'ash had frightened the Stronghold.",
    "Shandris gave her thanks for Raschal's rescue and a reward on behalf of the whole Stronghold. With a Zukk'ash hive now found in Feralas, she asked for help once more.",
    "The general offered the Stronghold's thanks and a reward. She already had another task in mind, one that concerned the Zukk'ash hive.")
hl(4135, "Raschal's backpacks held a note about insect creatures in the Writhing Deep. His trail ended there, at a pod with a humanoid shape inside.",
    "Following Raschal's note into the Writhing Deep led to a pod as tall as a person, with someone sealed inside it.")
hl(4265, "Raschal was freed from the pod alive and made his way back to Feathermoon. Ginro said the courier would have died without the rescue.",
    "The missing courier came out of the Writhing Deep alive. At the Stronghold, Ginro called the rescue a hero's deed and promised his friendship.")
hl(4266, "Shandris Feathermoon gave the Stronghold's thanks for Raschal's rescue, then asked for help against the Zukk'ash hive.",
    "At Feathermoon, General Shandris gave the Stronghold's reward and turned at once to the Zukk'ash hive in southern Feralas.")
for _, id in ipairs({32, 162, 4267, 4493, 4494, 4496, 4507, 4508, 4509, 3161, 4124, 4125, 4127, 4129, 4130, 4131, 4135, 4265, 4266}) do src(id) end
P.questIDs[4267].source[3] = "LoreForever quest:4267 (wiki: Rise of the Silithid (Feralas))"
P.questIDs[4267].threadLabel = P.threads.world_raschal

-- Batch 2: the level-sixty roads to Onyxia's lair. Thread labels stay neutral
-- until the stage that presents the court's secret (6403); Windsor's escape is
-- told only by 4322's completion (LoreDiscoveryData windsor_escaped).
P.threads.world_truemasters = "Lakeshire's appeal to Stormwind"
P.threads.world_windsor = "the search for Marshal Windsor"
P.threads.world_onyxia_key = "the key to the Wyrmbog lair"
P.threads.world_goretooth = "Warlord Goretooth's orders"
q(4183, "The True Masters", "Redridge Mountains", 54, "truemasters", 3,
    "At Morgan's Vigil, Helendis Riverhorn had learned that the Blackrock orcs answered to the black dragonflight, which fed their rage. She sealed the finding in a letter for Magistrate Solomon of Lakeshire.",
    "The Blackrock were not simply savage, Helendis Riverhorn believed. The black dragonflight controlled them, and Magistrate Solomon in Lakeshire needed to know.",
    "Magistrate Solomon broke the seal on Helendis's letter and began to read. It concerned Lakeshire's old enemy and the power behind it.",
    "Helendis's sealed letter reached Solomon, and the magistrate opened it at once.", true)
q(4184, "The True Masters", "Stormwind City", 54, "truemasters", 4,
    "Solomon called the letter grim news. Lakeshire could not survive both the Blackrock and the black dragonflight, and if it fell, he feared Darkshire, Goldshire and Stormwind would follow.",
    "Magistrate Solomon wanted Helendis's findings taken to Highlord Bolvar Fordragon at once. If this did not earn Stormwind's aid for Lakeshire, he said, nothing would.",
    "In Stormwind Keep, Highlord Bolvar Fordragon heard the report and refused to believe it. Dragons, he said, were impossible.",
    "The news from Lakeshire reached Bolvar Fordragon, who dismissed the idea of dragons out of hand.", true)
q(4185, "The True Masters", "Stormwind City", 54, "truemasters", 3,
    "Bolvar would not send his thinly spread troops to Lakeshire on speculation. He wanted proof, and sent the question to Lady Prestor, a learned woman who knew much of dragons.",
    "Before acting on Solomon's claims, Highlord Bolvar wanted the opinion of Lady Prestor, whom the court regarded as learned in dragons and dragonkin.",
    "Bolvar weighed the matter after the visit to Lady Prestor. He respected her stance, he said, but believed another solution might settle everyone's concerns.",
    "The Highlord listened, chin in hand. Lady Prestor had given her view, and Bolvar said he had a solution of his own in mind.", true)
q(4186, "The True Masters", "Redridge Mountains", 54, "truemasters", 3,
    "Bolvar made the bearer of Lakeshire's report an acting deputy of Stormwind and sent a decree back to Magistrate Solomon.",
    "Stormwind's answer to Lakeshire was a decree and a single new deputy. Bolvar sent both back to Solomon.",
    "Solomon read Bolvar's decree and said it could have been worse. Then he judged that Lakeshire's fate rested on the new deputy's shoulders, and his eyes filled with tears.",
    "Bolvar's decree reached Lakeshire. Solomon blinked rapidly as he read it and admitted that the town's fate now rested on one deputy.", true)
q(4223, "The True Masters", "Burning Steppes", 54, "truemasters", 3,
    "As a deputy of Stormwind, the next report was owed to Marshal Maxwell at Morgan's Vigil. Solomon sighed and wished good luck.",
    "Solomon's last instruction sent Stormwind's new deputy back to the Burning Steppes, to report to Marshal Maxwell.",
    "Marshal Maxwell laughed when Stormwind's new deputy reported to him.",
    "At Morgan's Vigil, Marshal Maxwell greeted Bolvar's deputy with a laugh.", true)
q(4224, "The True Masters", "Burning Steppes", 54, "truemasters", 3,
    "Maxwell had seen Stormwind's deputies before, and lost soldiers waiting for the kingdom to act. Marshal Windsor had vanished with all their intelligence on the Blackrock; Ragged John had been with him when a raiding party struck.",
    "The Vigil's evidence against the Blackrock had gone missing with its commander, Marshal Windsor. Maxwell sent the search to Ragged John, last seen in a cave to the north.",
    "Ragged John had been found and heard out in his cave. Maxwell laughed that he might have warned about the man and had chosen not to.",
    "The visit to Ragged John was done. Maxwell admitted he could have given a warning first, but thought that would have spoiled the fun.", true)
fallback("The True Masters", "Burning Steppes", "truemasters", "4183,4184,4185,4186,4223,4224",
    "Morgan's Vigil had evidence that the Blackrock orcs were driven by the black dragonflight.",
    "Lakeshire's fear of the Blackrock and the black dragonflight passed between Morgan's Vigil, Lakeshire and Stormwind.",
    "Another part of Lakeshire's appeal to Stormwind was complete.",
    "The report about the Blackrock's true masters moved one step along its road.")
q(4241, "Marshal Windsor", "Blackrock Depths", 54, "windsor", 4,
    "Ragged John claimed that Marshal Windsor was alive. Maxwell sent his deputy into Blackrock Depths to bring Windsor back, or proof of his death.",
    "If Windsor lived, Maxwell wanted him brought home from the Dark Iron prison. If he was dead, Maxwell wanted proof.",
    "Marshal Windsor was alive in a Blackrock Depths cell, and in a killing rage.",
    "Windsor was found alive in the Dark Iron prison, and his first words were a threat of murder.")
q(4242, "Abandoned Hope", "Burning Steppes", 54, "windsor", 3,
    "Windsor raged at Bolvar's blindness. His proof was lost, he said, and if he ever escaped with Ironfoe, his first stop would be Stormwind.",
    "In his cell, Windsor called Bolvar a blind fool and his own gathered evidence unrecoverable. He sent his visitor away.",
    "Maxwell lowered his head at the news. He believed Windsor's mind had broken, called the search a dead end, and paid his deputy for the work so far.",
    "Hearing how Windsor had spoken, Maxwell mourned a proud warrior turned, as he saw it, into a raving man. He offered a reward for the effort all the same.")
q(4264, "A Crumpled Up Note", "Blackrock Depths", 58, "windsor", 4,
    "A stained note signed by Emperor Dagran Thaurissan spoke of Windsor's notes. General Angerforge had found the pattern of their encryption, and Argelmach was almost done decoding them.",
    "Thaurissan's crumpled note mentioned the fall of the Alliance and Windsor's encrypted notes, nearly decoded by the golem lord Argelmach.",
    "Marshal Windsor saw the note and took it to read in his cell.",
    "Windsor took the emperor's note through the bars of his cell and read it.")
q(4282, "A Shred of Hope", "Blackrock Depths", 58, "windsor", 5,
    "The note gave Windsor hope. His lost information was held by two Dark Iron dwarves, General Angerforge and the golem lord Argelmach, and neither would give it up without a fight.",
    "Windsor shook the note with excitement. Angerforge and Argelmach had his information, and he wanted them destroyed and the records brought back.",
    "Windsor snatched the two tablets of his information and said it was time to get out.",
    "Angerforge and Argelmach were dead, and their tablets reached Windsor's hands. He wanted out of the prison at once.")
q(4322, "Jail Break!", "Burning Steppes", 58, "windsor", 5,
    "Windsor needed his gear from the prison's supply area and his friends freed from their cells. If they escaped, Marshal Maxwell at Morgan's Vigil would give the next orders.",
    "The escape from Blackrock Depths meant recovering Windsor's equipment and freeing the prisoners with him, then reporting to Maxwell at the Vigil.",
    "Maxwell reported that Windsor had stormed through Morgan's Vigil only minutes earlier, carrying his evidence. The marshal was on his way to Stormwind to confront Bolvar and Lady Prestor.",
    "Windsor was free. He had passed through the Vigil with his evidence and gone on toward Stormwind, Maxwell said, to confront Bolvar and Lady Prestor.")
q(6402, "Stormwind Rendezvous", "Stormwind City", 60, "windsor", 4,
    "Maxwell said that what Windsor meant to reveal would shake the kingdom. The meeting was set at Stormwind's gates, and no one was to go there alone.",
    "Windsor would wait at the gates of Stormwind. Maxwell's orders were to gather companions and come armed.",
    "At the gates, Windsor asked for an army to be gathered before anything began.",
    "Windsor waited at Stormwind's gates. Before he went in, he wanted an army behind him.")
q(6403, "The Great Masquerade", "Stormwind City", 60, "windsor", 6,
    "Windsor named Lady Prestor as Onyxia, Deathwing's daughter and Nefarian's twin. He believed her spell held the kingdom, Bolvar included, and meant to break it that day.",
    "Windsor's evidence pointed at Lady Prestor. She was Onyxia, he said, and the Highlord was her puppet; he led the way into Stormwind Keep to end it.",
    "Bolvar held the shattered medallion that had kept his mind captive. Windsor's sacrifice had freed the kingdom, he said, though Onyxia and her kin remained a threat.",
    "The spell over Bolvar broke, and he credited Windsor's sacrifice. The shattered medallion that had controlled him had also given him muddled glimpses of Onyxia's secrets.")
q(6501, "The Dragon's Eye", "Winterspring", 60, "onyxia_key", 4,
    "Bolvar gave a fragment of the shattered medallion. A new key to Onyxia's lair in the Wyrmbog would need help from another of dragon blood, perhaps one living in disguise among mortals.",
    "The medallion's magic had to be rekindled. Bolvar did not know where to find a dragon willing to help, only that some were said to live among the mortal races.",
    "Haleh, in the caverns of Mazthoril, sensed evil in the fragment and named it a piece of Onyxia, the black dragon brood mother. She found it revolting.",
    "Haleh, who kept to the caverns of Mazthoril, knew the fragment for what it was, a piece of Onyxia, and recoiled from it.")
q(6502, "Drakefire Amulet", "Winterspring", 60, "onyxia_key", 5,
    "The fragment was an enchanted dragon scale, Haleh explained, useless while broken. Mending it needed the blood of General Drakkisath, who ruled Nefarian's dragonspawn armies.",
    "Haleh could repair the medallion's scale, but only with the blood of a black dragon champion. That meant General Drakkisath in Blackrock Spire.",
    "Haleh enchanted the fragment with Drakkisath's blood into the Drakefire Amulet. While it was held, Onyxia's wards in Dustwallow Marsh could not bar the way.",
    "Drakkisath's blood restored the scale, and Haleh gave it back as an amulet. The Blue Flight, she said, wished its bearer luck in Onyxia's lair.")

q(4903, "Warlord's Command", "Badlands", 60, "goretooth", 4,
    "Warlord Goretooth ordered three of Blackrock Spire's masters destroyed, Highlord Omokk, War Master Voone and Overlord Wyrmthalak. Any important documents found there were to come back too.",
    "Goretooth's orders from Kargath named Omokk, Voone and Wyrmthalak in the lower Spire, and promised honor to those who succeeded.",
    "Goretooth read the documents brought out of the Spire, and his green skin turned pale for a moment.",
    "The three masters of the lower Spire were dead. When Goretooth saw the documents found there, the color left his face.")
q(4941, "Eitrigg's Wisdom", "Orgrimmar", 60, "goretooth", 4,
    "The documents said that Rend Blackhand lived, though he had been thought dead for decades. Goretooth sent word to Eitrigg, who knew the Blackrock better than anyone, and then to the Warchief.",
    "Rend Blackhand alive was hard to believe. Goretooth wanted Eitrigg told, since no one should be denied vengeance, and Thrall consulted.",
    "Thrall heard the news of Rend Blackhand with dismay.",
    "Word that Rend still lived reached Thrall, and the Warchief was dismayed.")
q(4974, "For The Horde!", "Orgrimmar", 60, "goretooth", 6,
    "Thrall said Rend's grand claims rested on the protection of the black dragonflight. He ordered Rend destroyed beyond the Halls of Ascension and his head brought to Orgrimmar.",
    "The self-named Warchief of the Blackrock had to die. Thrall wanted Rend's head held high in his chambers.",
    "Rend's head came back to Thrall. With their Warchief dead, the Blackrock legion was thrown into chaos, and Thrall promised a reward to the people of Kalimdor.",
    "Thrall received Rend Blackhand's head and called it a crippling blow to the Blackrock. In honor of the deed, he declared, all of Kalimdor would be rewarded.")
q(6567, "The Champion of the Horde", "Desolace", 60, "onyxia_key", 4,
    "One of Thrall's champions had found a possible way into the dragon's lair. Rexxar wandered Desolace between Stonetalon and Feralas, and he was waiting.",
    "Thrall's orders led to Rexxar, who roamed the wastes of Desolace and had word of a path into the dragon's lair.",
    "Rexxar explained that only the strongest of the black dragonflight could enter the brood mother's lair, with a key enchanted by General Drakkisath himself. An outsider would find passage difficult.",
    "There was one way into the lair, Rexxar said. Only black dragonkin who passed many trials earned the key, and Drakkisath enchanted it himself.")
q(6569, "Oculus Illusions", "Western Plaguelands", 60, "onyxia_key", 3,
    "Myranda the Hag could craft an illusion to pass among the black flight, but the divination needed a pack full of black dragonspawn eyes from the upper Spire.",
    "Rexxar and Thrall had sent the request to Myranda. The eyes of the creatures to be mimicked were the most important part of her illusion.",
    "Myranda approved of the eyes. From them she would make a medallion whose illusion could fool the black dragonflight's gatekeeper.",
    "The dragonspawn eyes would do nicely, Myranda said, and she set about making the illusion's medallion.")
q(6570, "Emberstrife", "Dustwallow Marsh", 60, "onyxia_key", 4,
    "Myranda's medallion would hold its illusion inside the den of Emberstrife, an ancient drake of the Wyrmbog who tested dragonspawn seeking to guard Onyxia.",
    "Emberstrife, an old gatekeeper of Nefarian, judged those who would rise to Onyxia's elite guard. Myranda's illusion was made to pass his inspection.",
    "Emberstrife took the disguise for a whelp sent by Nefarian. He sneered and promised his tests would never be passed.",
    "The disguise held. Emberstrife saw only a broodling and complained that Nefarian must be short of soldiers.")
q(6601, "Ascension...", "Desolace", 60, "onyxia_key", 4,
    "Emberstrife gave up a medallion shaped from the skulls of enemies. General Drakkisath was to place its final enchantment, marking ascension to the brood mother's guard.",
    "The medallion of the brood mother's guardians was unfinished. Emberstrife ordered it carried to Drakkisath in the Spire.",
    "Rexxar dismissed Emberstrife's speech as dragon-talk, more hot air than substance.",
    "Rexxar heard about the drake's medallion and laughed off the pompous words as the way of dragons.")
q(6602, "Blood of the Black Dragon Champion", "Desolace", 60, "onyxia_key", 5,
    "Rexxar had no intention of attending Drakkisath's ceremony as one of the black flight. The amulet needed only the General's blood, so Drakkisath had to die.",
    "A black flight ceremony meant bloodletting, Rexxar said. Drakkisath's blood would wake the latent amulet, and he wanted it brought back from the Spire.",
    "Rexxar activated the Drakefire Amulet with Drakkisath's blood. It was the key to Onyxia's lair, and he told its bearer to gather forces and conquer for the Horde.",
    "Rexxar grinned as the amulet came alive with Drakkisath's blood. The deed, he said, would be spoken of for years.")
hl(4282, "Angerforge and Argelmach were dead, and Windsor had his two tablets back. He wanted out of Blackrock Depths at once.",
    "Windsor's lost information came back on two tablets taken from Angerforge and Argelmach. Escape was his next thought.")
hl(4322, "Windsor escaped Blackrock Depths with his evidence. Maxwell said he had gone on to Stormwind to confront Bolvar and Lady Prestor.",
    "The jail break freed Windsor. He stormed through Morgan's Vigil and set out for Stormwind with his evidence.")
hl(6403, "In Stormwind Keep, Onyxia's spell over Bolvar broke. The Highlord credited Windsor's sacrifice and held the shattered medallion that had controlled him.",
    "Windsor's sacrifice freed Bolvar from Onyxia's spell. The shattered medallion in the Highlord's hand still held glimpses of her secrets.")
hl(6502, "Haleh used Drakkisath's blood to turn the medallion fragment into the Drakefire Amulet, the key past Onyxia's wards.",
    "Drakkisath's blood mended the fragment. Haleh gave it back as the Drakefire Amulet, with the Blue Flight's wish for luck.")
hl(4974, "Rend Blackhand's head reached Thrall. The Blackrock were thrown into chaos, and Thrall rewarded all of Kalimdor for the deed.",
    "Thrall took Rend's head as a crippling blow to the Blackrock legion and declared a reward for the people of Kalimdor.")
hl(6602, "Drakkisath's blood activated the Drakefire Amulet. Rexxar called it the key to Onyxia's lair and urged a conquest for the Horde.",
    "Rexxar woke the amulet with Drakkisath's blood and grinned. The way into Onyxia's lair was open.")
for _, id in ipairs({4183, 4184, 4185, 4186, 4223, 4224, 4241, 4242, 4264, 4282, 4322, 6402, 6403, 6501, 6502,
    4903, 4941, 4974, 6567, 6569, 6570, 6601, 6602}) do src(id) end
P.questIDs[6403].source[3] = "LoreDiscoveryData prestor_identity presented/completed 6403; windsor_escaped completed 4322"

-- Batch 3: the Eastern Plaguelands at level sixty. Nathanos's Horde errands
-- name him openly (he is the quest giver); the Alliance SI:7 case learns that
-- he is the Blightcaller only in 6186's text, so 6182-6185 and the thread
-- label keep the two names apart.
P.threads.world_marris_stead = "Nathanos's orders at the Marris Stead"
P.threads.world_marris_case = "SI:7's missing agents"
P.threads.world_lights_hope = "the Argent Dawn's work at Light's Hope"
P.threads.world_smokey = "Smokey LaRue's commissions"
q(6133, "The Ranger Lord's Behest", "Eastern Plaguelands", 60, "marris_stead", 3,
    "The high elves of Quel'Lithien Lodge held a document about Nathanos Blightcaller's life as a mortal. He wanted the registry back and the lodge left in grief, and he refused to explain.",
    "Nathanos sent his agent north to Quel'Lithien Lodge for a registry of his mortal life. Its contents, he said, were none of anyone's business.",
    "The registry was back in his hands, and Nathanos warned that only an idiot would have read it.",
    "The registry from Quel'Lithien reached the Marris Stead. Nathanos's only thanks was the hope that no one had been foolish enough to read it.")
q(6135, "Duskwing, Oh How I Hate Thee...", "Eastern Plaguelands", 60, "marris_stead", 3,
    "Nathanos allowed that his missions had been done, if slowly, and offered a harder one. Duskwing, an albino demon bat, roamed the country to the north, and he wanted its white fur.",
    "The white fur of Duskwing, a demon bat haunting the fields north of the Marris Stead, was Nathanos's next demand. He advised against hunting it alone.",
    "Duskwing's white fur went to Nathanos, who promised to fashion it into something useful.",
    "Duskwing was dead. Nathanos called the work excellent, for once, and set about turning the fur into a reward.")
q(6136, "The Corpulent One", "Eastern Plaguelands", 60, "marris_stead", 3,
    "West of Northdale, past Light's Hope, the maggot beast Borelgore had devoured whole regiments of Nathanos's soldiers. The more it ate, the larger it grew.",
    "Nathanos sent the hunt after Borelgore and warned that the beast had swallowed small battalions. He would not grieve if it ate the hunter, he said, but preferred the other outcome.",
    "Borelgore was dead. Nathanos threatened to promote his agent from imbecile to mental deficient, first class.",
    "Nathanos met the news of Borelgore's death with his usual contempt and a mocking promise of promotion.")
q(6022, "To Kill With Purpose", "Eastern Plaguelands", 58, "marris_stead", 2,
    "Anyone staying on the Marris Stead killed with purpose. Nathanos wanted living rot from the Scourge at Corin's Crossing, ground in his mortar and left to set, to feed his hounds.",
    "Nathanos's hounds needed feeding. The living rot from fresh Scourge carcasses at Corin's Crossing spoiled quickly, so the killing had to be fast.",
    "Nathanos took the coagulated rot with a sigh. He had hoped to feed his agent to the hounds instead.",
    "The rot was good enough for the hounds. Nathanos called it disappointing all the same.")
q(6042, "Un-Life's Little Annoyances", "Eastern Plaguelands", 58, "marris_stead", 2,
    "Bats swarmed the land around the Marris Stead and pestered Nathanos whenever he took his hounds out after the Scourge. He had better things to do than kill them, he said, and called the chore training.",
    "The winged pests around the Marris Stead kept Nathanos from hunting the Scourge with his hounds in peace. Thinning them, in his words, was training.",
    "It was incredible, Nathanos remarked, what a little anger and rage could accomplish.",
    "The bats around the stead were fewer. Nathanos credited anger and rage for the result.")
q(6144, "The Call to Command", "Undercity", 60, "marris_stead", 4,
    "Varimathras wanted Nathanos's most capable agents in the Undercity for a sensitive operation. Nathanos said those had died three years ago, and sent the agent he had with a cold warning not to embarrass him.",
    "Orders came down from Varimathras, and Nathanos sent his agent back to the Undercity to report.",
    "Varimathras said the Grand Crusader sat safe in the Scarlet Bastion while his forces murdered the Forsaken. Sylvanas had ordered Nathanos to deal with him, and Varimathras named the newcomer the instrument of that reckoning.",
    "Varimathras laid out the Dark Lady's command. Nathanos was to strike at the Grand Crusader, whose forces poured into Forsaken lands from the safety of Stratholme.")
q(6145, "The Crimson Courier", "Eastern Plaguelands", 60, "marris_stead", 4,
    "The Scarlet command in Stratholme was too well defended to attack directly. Nathanos's deathstalkers had learned that a courier carried a daily report from there to Tyr's Hand, and he wanted it.",
    "Cut the body out from under the head, Nathanos said. The Crimson Courier's report from Stratholme to Tyr's Hand was the key to his plan.",
    "Nathanos laughed over the courier's report. At last he had a chance to destroy the Scarlet Oracle.",
    "The intercepted report delighted Nathanos. It gave him an opening against the Scarlet Oracle.")
q(6146, "Nathanos' Ruse", "Eastern Plaguelands", 60, "marris_stead", 4,
    "Nathanos altered the courier's command so that it would expose the Scarlet Oracle. Disguised by a rotten apple eaten inside Tyr's Hand, his agent was to hand it to Crusader Lord Valdelmar in person.",
    "A forged command and an enchanted rotten apple were Nathanos's ruse. Eaten in Tyr's Hand, the apple would give its bearer a shape the humans would accept.",
    "Valdelmar took the false courier for one of his own and demanded to know where he had been. The Crusade had feared the Scourge had captured him.",
    "The disguise held in Tyr's Hand. Crusader Lord Valdelmar received the altered command from a courier he thought lost to the Scourge.")
q(6147, "Return to Nathanos", "Eastern Plaguelands", 60, "marris_stead", 3,
    "Valdelmar found the Grand Crusader's request unusual but meant to obey. He sent word that the Oracle would soon be on her way to Stratholme, guarded with every precaution.",
    "The Crusader Lord had swallowed the ruse. His reply promised that the Oracle would travel to Stratholme under heavy protection.",
    "Nathanos exulted that his deception had gone unnoticed and called for a strike with cold cunning.",
    "Valdelmar's answer reached Nathanos, who laughed at the fools of Tyr's Hand and prepared to strike.")
q(6148, "The Scarlet Oracle, Demetria", "Eastern Plaguelands", 60, "marris_stead", 5,
    "Demetria, the Grand Crusader's chief adviser, was called the Oracle for her otherworldly senses. The ruse had drawn her out of Tyr's Hand, and Nathanos wanted her killed on the road.",
    "The Scarlet Oracle had helped the Crusade to several victories over the Scourge. Now she was moving out of Tyr's Hand, perhaps expecting trouble, and Nathanos meant to supply it.",
    "Demetria was dead. Nathanos said the Crusade would be reeling for years, and for once offered his respect along with the reward.",
    "The Oracle fell on the road from Tyr's Hand. Nathanos praised the blow, and the agent he had called imbecile now had his respect.")
hl(6148, "Demetria, the Scarlet Oracle, was killed on the road from Tyr's Hand. Nathanos said the Crusade would be reeling for years and offered his respect.",
    "Nathanos's ruse ended with the Scarlet Oracle dead. He rewarded the deed and, for once, offered respect.")

q(6182, "The First and the Last", "Stormwind City", 60, "marris_case", 4,
    "Nathanos Marris had been the first and last of the human ranger lords, a disciple of Sylvanas Windrunner before she became the Banshee Queen. He was thought killed defending Lordaeron five years earlier, though his body was never found.",
    "The fate of Nathanos Marris, the ranger lord presumed dead in the Eastern Plaguelands, had come under question. Mathias Shaw, at the Old Town barracks, had been investigating.",
    "Mathias Shaw explained that SI:7 agents had gone east after reports of unusual Forsaken activity in the Plaguelands. What they found unsettled him.",
    "Mathias Shaw confirmed that his SI:7 agents had investigated strange Forsaken movements in the Eastern Plaguelands, with troubling results.")
q(6183, "Honor the Dead", "Stormwind City", 60, "marris_case", 4,
    "Five SI:7 agents had taken the Marris case. One came back and died in his sleep three days later, having said little beyond two words, Nathanos and Blightcaller.",
    "Shaw had no agents left for the Marris case, and Ravenholdt would not help. He wanted it closed, if only for the families of his dead.",
    "Shaw nodded at the offer. He had trusted Bolvar to send someone of honor.",
    "Mathias Shaw accepted the help, saying he had expected Bolvar to send the Alliance's most dedicated soldiers.")
q(6184, "Flint Shadowmore", "Western Plaguelands", 60, "marris_case", 3,
    "SI:7's only lead was that a Blightcaller might have killed Nathanos Marris and the missing agents. Shaw sent the case to Flint Shadowmore at Chillwind Point.",
    "Flint Shadowmore, an SI:7 operative at Chillwind Point in the Western Plaguelands, was to brief the next stage of the Marris case.",
    "Flint gave the first assignment plainly. It was reconnaissance, in and out.",
    "At Chillwind Point, Flint Shadowmore took over the case and called the first mission simple reconnaissance.")
q(6185, "The Eastern Plagues", "Western Plaguelands", 60, "marris_case", 4,
    "Flint wanted clues about the Blightcaller and the missing operatives, whom he assumed were dead. Every SI:7 agent carried an insignia, and he swallowed hard as he asked for any that could be found.",
    "SI:7's missing agents would have left bodies somewhere in the Eastern Plaguelands. Flint showed his own insignia so that theirs could be recognized.",
    "Flint clutched the recovered insignias and named his dead, Rutger, Fredo and Turyen. He asked where they had been found and what more was known of the Blightcaller.",
    "The insignias came back to Chillwind Point. Rutger, Fredo and Turyen were all dead, and Flint wanted to know everything that had been learned of their killer.")
q(6186, "The Blightcaller Cometh", "Stormwind City", 60, "marris_case", 5,
    "The color drained from Flint's face. Nathanos was the Blightcaller, the noble ranger lord now an agent of the Forsaken, and Highlord Fordragon had to be told at once.",
    "The evidence named Nathanos Marris as the Blightcaller. Shaken, Flint asked that the news be carried to Stormwind.",
    "Bolvar could not believe that Nathanos had become the Banshee Queen's champion. The Highlord slumped in defeat.",
    "The news reached Highlord Bolvar Fordragon, who cried out that it could not be true.")
q(6187, "Order Must Be Restored", "Stormwind City", 60, "marris_case", 6,
    "Bolvar remembered Nathanos as a tactical genius behind a decade of Alliance victories. He wanted an army sent to the Plaguelands to destroy the Blightcaller.",
    "There had only ever been one human ranger lord, and now he was the Forsaken's champion. Bolvar ordered the Blightcaller destroyed, and wished the army luck.",
    "The Blightcaller was dead. Bolvar called it a tragedy and said humankind seemed cursed to lose its greatest heroes. Wherever Nathanos Marris was now, he said, the ranger lord would be smiling.",
    "Nathanos Blightcaller had been destroyed. Bolvar thanked the army and grieved for the ranger lord Nathanos had once been.")
hl(6186, "Flint's dead agents led to a name. Nathanos Marris was the Blightcaller, and Bolvar slumped in defeat at the news.",
    "The Blightcaller was Nathanos Marris, now champion of the Banshee Queen. Bolvar could not believe it.")
hl(6187, "The Blightcaller was destroyed. Bolvar called it a tragedy and grieved for the ranger lord Nathanos Marris had once been.",
    "Nathanos Blightcaller was dead. Bolvar said humankind seemed cursed to lose its greatest heroes.")

q(5243, "Houses of the Holy", "Eastern Plaguelands", 60, "lights_hope", 3,
    "Leonid Barthalomew treated his undeath as a malady, and as a weapon the Argent Dawn could turn against the Scourge. He wanted the Dawn's surplus of holy water recovered from the supply crates of Stratholme.",
    "The Argent Dawn had left holy water in Stratholme's supply crates. Leonid warned that the Scourge would not touch it, but vermin might have spoiled some.",
    "Leonid received the holy water. Tolerance of others, he said, need not soften the will to destroy Kel'Thuzad's minions.",
    "The holy water came back to Light's Hope, and Leonid praised a dedication that stopped at nothing against the Scourge.")
q(5212, "The Flesh Does Not Lie", "Eastern Plaguelands", 60, "lights_hope", 3,
    "Betina Bigglezink had studied the plague for years and found it growing stronger, not weaker. She wanted samples of the most recently infected flesh from Stratholme.",
    "The plague's potency was rising, Betina believed, and the freshest tainted flesh in Stratholme would show her how.",
    "Betina found that something had changed in the chemistry of the plague's active agents. She needed more data.",
    "The samples confirmed Betina's fear of a change in the plague. One test was not enough, and she asked for more.")
q(5213, "The Active Agent", "Eastern Plaguelands", 60, "lights_hope", 4,
    "The Scourge drew great power from the ziggurats beyond Stratholme's first gates. Betina wanted them searched for anything that might explain the plague's new active agent.",
    "Betina believed she was on the verge of identifying the plague's new agent. The answer, she hoped, lay in the ziggurats of Stratholme.",
    "Betina called the findings astonishing and months of work to analyze. The Argent Dawn thanked the searcher with a Seal or Rune of the Dawn.",
    "The ziggurat data reached Betina, who expected months of analysis. She offered the Dawn's seal or rune in thanks.")
q(5281, "The Restless Souls", "Eastern Plaguelands", 60, "restless", 3,
    "Many of Stratholme's people had thrown themselves into the burning city rather than join the Scourge. Caretaker Alen wanted their restless spirits helped, and sent word to Egan, who studied ghosts near the city.",
    "Alen believed the spirits of Stratholme's dead could still be aided. His associate Egan was testing his inventions in the Eastern Plaguelands.",
    "Egan was glad that Alen had finally found someone brave enough to help.",
    "Egan received Alen's helper with relief. His work on Stratholme's ghosts could go forward.", true)
q(5214, "The Great Fras Siabi", "Eastern Plaguelands", 60, "smokey", 2,
    "Fras Siabi had refused to leave his tobacco shop when Stratholme fell, vowing to burn every leaf first. Smokey LaRue hoped one box had survived.",
    "Smokey LaRue missed Fras Siabi's famous tobacco and suspected the shop in Stratholme had gone up in flames, perhaps with Fras inside.",
    "Smokey had his box of Fras's tobacco and greeted it like an old friend.",
    "One box of Fras's tobacco had survived, to Smokey's delight.")
q(6026, "That's Asking A Lot", "Eastern Plaguelands", 58, "smokey", 3,
    "The Argent Dawn had commissioned Smokey LaRue for demolition work in Plaguewood. He offered to split the fee in return for gathering the parts for his bombs.",
    "Smokey would mark the Scourge buildings in Plaguewood to be destroyed. The bomb components were the missing part of his deal.",
    "Smokey offered half the payment up front and half when the job was done.",
    "The components reached Smokey. He paid half the commission at once and promised the rest after the demolition.")
q(6041, "When Smokey Sings, I Get Violent", "Eastern Plaguelands", 58, "smokey", 3,
    "Smokey's people had marked the Scourge buildings in Plaguewood. Ten sticks of his special compound were to be planted inside them.",
    "The demolition plan was simple, Smokey said. Plant the compound in the marked structures, and the Argent Dawn's job was done.",
    "The marked Scourge buildings were gone. Smokey laughed at the charred look of his partner, paid out the cut and added something for the burns.",
    "Smokey paid the rest of the Argent Dawn's commission, with a little extra to soothe the burns.")
hl(6041, "Smokey's compound brought down the marked Scourge buildings in Plaguewood. He paid out the commission and added something for the burns.",
    "The Plaguewood demolition was done. Smokey laughed, paid the second half and threw in a salve's worth for the burns.")
for _, id in ipairs({6133, 6135, 6136, 6022, 6042, 6144, 6145, 6146, 6147, 6148, 6182, 6183, 6184, 6185, 6186, 6187,
    5243, 5212, 5213, 5281, 5214, 6026, 6041}) do src(id) end

-- Batch 4: Winterspring's elven ruins and the Felstone farm's ghost. Each
-- Felstone stage names only the recipient its own record establishes.
P.threads.world_starfall = "the road to Starfall"
P.threads.world_zinmalor = "the shattered crystal of Kel'Theril"
P.threads.world_wildkin = "Erelas Ambersky's wildkin inquiry"
P.threads.world_felstone = "Janice Felstone's undelivered package"
q(5249, "To Winterspring!", "Winterspring", 56, "starfall", 2,
    "Ivy Leafrunner had too much work in Felwood to visit the elven ruins of Winterspring herself. She suggested a visit to Wynd Nightchaser at Starfall Village, who knew the area well.",
    "Winterspring was harsh country full of old elven ruins. Ivy Leafrunner sent her friends north to Wynd Nightchaser of Starfall Village.",
    "Wynd Nightchaser welcomed a friend of Ivy Leafrunner to Starfall.",
    "Wynd Nightchaser greeted the newcomer Ivy had sent north.")
q(5250, "Starfall", "Winterspring", 56, "starfall", 2,
    "Daryn Lightwind's studies kept him from Winterspring and its elven ruins. He sent a student north to Wynd Nightchaser at Starfall, who knew the area well.",
    "Winterspring held many secrets among its ruins. Daryn Lightwind wanted them studied, and Wynd Nightchaser at Starfall could help.",
    "Wynd Nightchaser welcomed a student of Daryn Lightwind to Starfall.",
    "At Starfall, Wynd Nightchaser greeted Daryn Lightwind's student.")
q(5244, "The Ruins of Kel'Theril", "Winterspring", 56, "zinmalor", 3,
    "The highborne of Kel'Theril had once stolen a sacred artifact to siphon its power. The relic shattered in a great explosion and its pieces sank beneath the ice of the lake, leaving the thieves bound there by a curse.",
    "Kel'Theril's highborne were a cursed people, held at the lake where their ritual had failed. Jaron Stoneshaper had visited the ruins recently and could say more.",
    "Jaron Stoneshaper was willing to describe what he had seen at Kel'Theril, though he was no historian.",
    "Jaron Stoneshaper agreed to share what he had seen among the ruins, with the warning that he was no scholar.")
q(5245, "Troubled Spirits of Kel'Theril", "Eastern Plaguelands", 56, "zinmalor", 3,
    "The highborne spirits still searched for pieces of the relic that had cursed them. Jaron lent his pick for prying the fragments from the lake's ice, and named Aurora Skycaller near Northpass Tower as someone who might understand them.",
    "Jaron could not explain the fragments under Kel'Theril's ice, but he knew Aurora Skycaller, who lived near Northpass Tower in the Eastern Plaguelands.",
    "Aurora Skycaller did not want to speak of the high elves' past. It pained her, she said, and nothing could set it right.",
    "The fragments reached Aurora, who first refused to talk of her ancestors' mistakes. She saw no way to make things right.")
q(5246, "Fragments of the Past", "Eastern Plaguelands", 56, "zinmalor", 4,
    "Aurora relented and examined the fragments. She believed they were the Crystal of Zin-Malor, which could contain great arcane forces, shattered by the evil intentions of its thieves. The sacred writings she needed lay in the Temple of Zin-Malor in Azshara.",
    "The fragments were the Crystal of Zin-Malor, Aurora thought. Only the sacred writings from the Temple of Zin-Malor in Azshara could tell her whether it might be mended.",
    "The pages from Azshara reached Aurora, untouched for many years.",
    "Aurora received the old writings from Azshara. No one had turned those pages in a very long time.", true)
q(5247, "Fragments of the Past", "Eastern Plaguelands", 57, "zinmalor", 4,
    "To fuse the fragments, Aurora needed an enchanted thorium bar, five crystal restores and a vial of water from the dire pool along Eldreth Row in Dire Maul.",
    "Aurora could mend the crystal with strong magic. She asked for enchanted thorium, crystal restores and water from Dire Maul's dire pool, and warned that the relic must never be stolen again.",
    "Aurora had her materials and began fusing the fragments, hoping to restore the crystal to what it had been.",
    "The thorium, restores and dire pool water reached Aurora, and she set to joining the shards.", true)
fallback("Fragments of the Past", "Eastern Plaguelands", "zinmalor", "5246,5247",
    "Aurora Skycaller studied the shards recovered from beneath the ice of Lake Kel'Theril.",
    "The fragments from Kel'Theril needed a high elf's knowledge before anything could be done with them.",
    "Aurora's work on the Kel'Theril fragments went a step further.",
    "Another step toward mending the shattered relic was complete.")
q(5248, "Tormented By the Past", "Winterspring", 58, "zinmalor", 4,
    "Aurora wept for the elves, a race as shattered as the crystal had been. She asked that the restored Crystal of Zin-Malor be shown at Lake Kel'Theril to a highborne spirit who recognized the old error.",
    "The crystal was whole again. Aurora wanted the spirits of Kel'Theril to see that the wrong had been put right, and hoped one of them understood what had been done.",
    "At Lake Kel'Theril, a highborne spirit moaned of its endless curse and begged to be left alone.",
    "The restored crystal was carried among the spirits of Kel'Theril. The one that answered could only plead to be left alone.")
q(5252, "Remorseful Highborne", "Eastern Plaguelands", 58, "zinmalor", 4,
    "One highborne spirit admitted the error of long ago. Knowing the crystal was recovered gave it peace, and it asked that the crystal be returned.",
    "The remorseful spirit could not change the past, but the restored crystal had brought it peace. It insisted the relic go back.",
    "Aurora recognized the crystal at once.",
    "The Crystal of Zin-Malor came back to Aurora Skycaller, who could hardly believe what she saw.")
q(5253, "The Crystal of Zin-Malor", "Darnassus", 58, "zinmalor", 5,
    "The Temple of Zin-Malor lay in ruin, so the crystal could not go back there. Aurora wanted it in the hands of Arch Druid Fandral Staghelm, where its power would not be abused.",
    "Only a handful of the strongest mages could control the Crystal of Zin-Malor. Aurora sent it to Fandral Staghelm in Darnassus for safekeeping.",
    "Fandral knew of the crystal and its power over arcane forces. He said he was impressed that its bearer had not tried to use it, promised the Cenarion Circle would keep it safe, and hoped the cursed spirits would rest.",
    "The Crystal of Zin-Malor reached Fandral Staghelm. The Circle would guard it, he said, and he hoped the spirits that once guarded its shards could finally be at peace.")
hl(5253, "The restored Crystal of Zin-Malor reached Fandral Staghelm for safekeeping. He hoped Kel'Theril's cursed spirits would finally rest.",
    "Fandral Staghelm took charge of the Crystal of Zin-Malor, mended from the shards beneath Kel'Theril's ice.")
q(979, "Find Ranshalla", "Winterspring", 57, "wildkin", 3,
    "Erelas Ambersky found the same magical enchantment in the wildkin feathers that she had noticed before. Her colleague Ranshalla had gone to Winterspring to observe the wildkin in their habitat.",
    "The wildkin feathers held an enchantment Erelas Ambersky could not explain. She sent the question on to Ranshalla, who was studying wildkin in Winterspring.",
    "Ranshalla was glad of company. She was just setting out for the caves.",
    "Ranshalla welcomed help from someone Erelas had sent, and prepared to go up to the caves.")
q(4901, "Guardians of the Altar", "Teldrassil", 59, "wildkin", 4,
    "Ranshalla believed an altar of Elune stood at the top of the ridge. Five torches in each cave had to be lit while she recited incantations copied from the ruins of Kel'Theril.",
    "The way to the altar lay through caves of wildkin. Ranshalla would speak the incantations from Kel'Theril while the torches were lit one by one.",
    "The torches were lit and Ranshalla's incantations spoken. Back in Rut'theran, Erelas asked first whether Ranshalla had been found.",
    "Ranshalla reached the altar of Elune at the top of the ridge, and her findings went back to Erelas Ambersky.")
q(4902, "Wildkin of Elune", "Darnassus", 57, "wildkin", 3,
    "Erelas was fascinated by what the altar had shown and wanted Arch Druid Fandral Staghelm told at once.",
    "The findings from Winterspring were important, Erelas said, and should go straight to Fandral Staghelm in the Cenarion Circle.",
    "Fandral said the Cenarion Circle had long known the wildkin as Elune's chosen guardians of sacred places. It was not news to him, but he complimented the effort with a reward.",
    "The wildkin were Elune's guardians, Fandral confirmed, a fact the druids had known for some time. He thanked the messenger for coming straight to him.")
q(5251, "The Archivist", "Eastern Plaguelands", 60, "lights_hope", 4,
    "The Argent Dawn counted the Scarlet Crusade's zealotry as one more dangerous extreme. Archivist Galford guarded the Crusade's most valued documents in Stratholme, and the Dawn wanted him killed and his archives burned.",
    "How many innocents had the Crusade destroyed in the name of the Light, the Argent Dawn asked. Archivist Galford's archives in Stratholme held its intelligence.",
    "Galford was dead and his archives burned. Years of Scarlet intelligence were lost, and the Crusade would feel the blow for weeks to come.",
    "The Scarlet archives in Stratholme went up in flames. The Argent Dawn called it an outstanding blow against the Crusade.")

q(5021, "Better Late Than Never", "Western Plaguelands", 52, "felstone", 3,
    "Janice Felstone's ghost cowered upstairs in the farmhouse, begging for her package to be delivered before she was trapped. She thought it was still by her horse.",
    "In the Felstone farmhouse, the apparition of a woman cried that a package must be delivered. She was only half aware of anyone near her.",
    "In the barn, among the decay, stood a package easily overlooked. It was likely the one Janice's ghost was clamoring about.",
    "The barn held a dusty package that stood out amid the ruin, probably the one Janice Felstone's ghost wanted delivered.", true)
q(5022, "Better Late Than Never", "Stormwind City", 52, "felstone", 3,
    "Janice's package was addressed in a hurried hand to Emma Felstone of Stormwind, dated more than four years earlier. The Royal Factors of the Stormwind Census might know whether she still lived.",
    "The package from the Felstone farm bore the name of Emma Felstone of Stormwind. Stormwind's census office was the place to look for her.",
    "The census showed an Emma Felstone in Stormwind five years before. The factor wondered aloud whether the package could be meant for Ol' Emma.",
    "Stormwind's census held a record of Emma Felstone from before the plague. The factor began to suspect she was the woman called Ol' Emma.", true)
q(5023, "Better Late Than Never", "Undercity", 52, "felstone", 3,
    "Janice's package was addressed in a hurried hand to Jeremiah Felstone of Lordaeron, dated more than four years earlier. The Undercity's census overseers might know what had become of him.",
    "The package from the Felstone farm bore the name of Jeremiah Felstone of Lordaeron. The Undercity kept a census of its people, living and former.",
    "Jeremiah Felstone had lived in the city before the plague, the overseer found. As one of the Forsaken he now went by Jeremiah Payson, and he sold cockroaches.",
    "The Undercity census traced Jeremiah Felstone to a new name, Jeremiah Payson. The overseer realized he was the cockroach vendor.", true)
fallback("Better Late Than Never", "Western Plaguelands", "felstone", "5021,5022,5023",
    "Janice Felstone's ghost still waited at her farm for a package that had never been delivered.",
    "A package left at the Felstone farm for more than four years was meant for Janice's family.",
    "The search for the package's recipient moved forward.",
    "Janice Felstone's package was one step closer to its owner.")
q(5048, "Good Natured Emma", "Stormwind City", 52, "felstone", 3,
    "Ol' Emma wandered Stormwind talking to herself, ornery but harmless. The census records suggested she was Emma Felstone.",
    "The factor believed Ol' Emma was Emma Felstone. Asking her last name was the simplest test.",
    "Emma confirmed her name, the first time in years anyone had used it. She expected her sister to be dead and took the visitor for a grave-robber, until she heard there was a package from Janice.",
    "Ol' Emma admitted she was Emma Felstone. She had lost most of her family to the plague, and was startled to learn her sister had sent her something.")
q(5049, "The Jeremiah Blues", "Undercity", 52, "felstone", 3,
    "The evidence pointed to Jeremiah Payson, who sold cockroaches near the Undercity bank. The overseer added his good wishes with heavy sarcasm.",
    "The intended recipient was Jeremiah Payson, the cockroach vendor groveling beneath a walkway near the bank.",
    "Jeremiah admitted to the old name and called the messenger a vulture for claiming to have spoken to a sister four years dead. Then he heard there was a package.",
    "Jeremiah Payson had once been Jeremiah Felstone. He was ready to take offense, until he learned his dead sister had sent him a package.")
q(5050, "Good Luck Charm", "Western Plaguelands", 52, "felstone", 4,
    "The package held Janice's personal effects, even the deed to the Felstone farm. Her sibling apologized for the earlier suspicion and sent back half of a good luck charm, hoping it would let her rest. Her husband John had carried the other half.",
    "Janice's sibling kept the farm deed for another day and returned half of her good luck charm, in the hope that her spirit might rest.",
    "Janice's ghost took the half-charm and asked for John's half. They could not be together without both, she said, and she could not see him.",
    "The half-charm reached Janice, who called for her husband and asked where he had put the other half.")
q(5051, "Two Halves Become One", "Western Plaguelands", 54, "felstone", 5,
    "Janice's ghost kept calling for John and his half of the charm, begging him to hurry before the plague changed them both. The other half had to be found and the charm made whole.",
    "Janice could not see John, but she felt him near. Only the whole good luck charm, both halves joined, would answer what her spirit sought.",
    "Janice took the reassembled charm and her form shimmered. With clear, sad eyes she said she was free, and gave the charm away for the solace it had given her.",
    "The two halves of the charm came together in Janice Felstone's hands. Her spirit was freed, and she no longer needed it.")
hl(5051, "Both halves of the good luck charm reached Janice Felstone's ghost. She was freed at last, and gave the charm away.",
    "The reassembled charm released Janice Felstone. She looked on with clear, sad eyes and said she no longer needed it.")
for _, id in ipairs({5249, 5250, 5244, 5245, 5246, 5247, 5248, 5252, 5253, 979, 4901, 4902, 5251,
    5021, 5022, 5023, 5048, 5049, 5050, 5051}) do src(id) end

-- Batch 8: Un'Goro. Linken's chain between the Videre Elixir (3909) and his
-- own adventure (3961); Torwa Pathfinder's hunts; Karna's mechanical ape.
-- Linken never recovers his memory in these stages; Blazerunner is only named.
P.threads.world_torwa = "Torwa Pathfinder's hunts"
P.threads.world_karna = "Karna Remtravel's mechanical ape"
q(3912, "Meet at the Grave", "Tanaris", 52, "linken", 3,
    "The Videre Elixir would let its drinker speak with someone no living eye could see. Taken with Linken's sword to the graveyard outside Gadgetzan, it would lead north to Gaeriyan, waiting in a rocky crevice.",
    "Gregan's elixir and Linken's sword went to the graveyard near Gadgetzan. Only in that other form could Gaeriyan be found and heard.",
    "Gaeriyan spoke from his crevice, saying it had been long since anyone came to talk with him.",
    "In the hills north of the graveyard, Gaeriyan received a rare visitor and was willing to talk.")
q(3913, "A Grave Situation", "Tanaris", 52, "linken", 3,
    "Gaeriyan said one gravestone in the graveyard stood out from the others, and that secrets lay within it.",
    "Pushing on the stone Gaeriyan described would reveal what it hid.",
    "The gravestone slid aside to reveal a small depression, and Linken's sword fitted it perfectly.",
    "Beneath the moved gravestone lay a hollow shaped exactly for Linken's sword.")
q(3914, "Linken's Sword", "Un'Goro Crater", 52, "linken", 4,
    "After a strong flash of light, Linken's sword could be lifted again. It had been transformed.",
    "The grave in Tanaris had remade Linken's sword, and it belonged back with its owner in Un'Goro.",
    "Linken half remembered his visitor and took back the finished sword with delight. He could not recall why he had needed it, but he paid for the work.",
    "The transformed sword reached Linken, who called it finished and then wondered aloud what it had been for.")
q(3941, "A Gnome's Assistance", "Un'Goro Crater", 52, "linken", 3,
    "Linken knew he had come to Un'Goro for something important. J.D., a gnome in a nearby cave who had been kind to him when he arrived, might remember what he had said.",
    "Linken suspected he had told J.D. something in his confused early days. She worked with the crater's glowing crystals in a cave nearby.",
    "J.D. asked her visitor to wait a moment while she tested a new combination of crystals.",
    "In her cave, J.D. was busy with her crystals and asked for a moment before she could talk.")
q(3942, "Linken's Memory", "Felwood", 54, "linken", 4,
    "J.D. remembered Linken mumbling about a totem he meant to make, and a name, Eridan Bluewind, in a place called Felwood.",
    "Linken had once spoken of a totem and of Eridan Bluewind in Felwood. J.D. doubted he could say more himself now.",
    "Eridan Bluewind greeted the traveler and asked what help was needed.",
    "The trail of Linken's memory reached Eridan Bluewind in Felwood, who offered to help.")
q(4084, "Silver Heart", "Felwood", 54, "linken", 4,
    "Eridan did not know Linken, but knew what he had sought. Blazerunner, an elemental at the heart of Un'Goro, was protected by an aura that only great power could dispel, and she would teach of it in return for Felwood's silvery claws and an irontree heart.",
    "Eridan Bluewind offered knowledge to defeat the evil elemental Blazerunner. First she wanted eleven silvery claws and an irontree heart from Felwood's creatures.",
    "Eridan accepted the claws and the irontree heart as proof that the helper was serious about aiding a friend.",
    "The silvery claws and irontree heart reached Eridan, who judged the commitment to Linken sincere.")
q(4005, "Aquementas", "Un'Goro Crater", 54, "linken", 4,
    "Eridan sent a bag of supplies to a circle of stones on the eastmost peninsula of Lost Rigger Cove in Tanaris. Read from the tome of Aquor inside the circle, the words would summon Aquementas, who could transform the items into a totem against Blazerunner.",
    "Aquementas would not be pleased to be woken, Eridan warned, but only he could make the totem, and only for someone who stayed inside the circle.",
    "The finished totem was examined in Un'Goro. Blazerunner was known there, an elemental in the charred heart of the crater whose aura no one had penetrated, and many had been thrown from the rocky paths trying.",
    "Back in the crater, the new totem drew a knowing answer. Everyone kept their distance from Blazerunner, protected by an aura none had broken.")
q(4289, "The Apes of Un'Goro", "Un'Goro Crater", 55, "torwa", 3,
    "To Torwa Pathfinder, Un'Goro's creatures were nobler versions of those found elsewhere, and the crater cried of the Earth Mother. The great apes to the north were a test for any mortal's strength.",
    "Torwa paid homage to the Earth Mother with every hunt across the crater. He asked for the pelts of the great apes as proof of strength.",
    "Torwa accepted the pelts as clothing for his tribe and gave thanks to the Earth Mother and to the spirits of the apes, so they would know their deaths were not wasted.",
    "The ape pelts reached Torwa, who counted the hunt a small challenge beside Lar'korwi and still praised it.")
q(4301, "The Mighty U'cha", "Un'Goro Crater", 55, "torwa", 4,
    "Among the gorillas to the north, Torwa had seen a huge red ape he called U'cha, one of the Earth Mother's greatest sons. He wanted its pelt.",
    "U'cha had teeth like daggers and arms as thick as tree trunks, Torwa said. His people might go generations without seeing such a creature.",
    "U'cha's pelt reached Torwa, who called it one of the greatest apes he had ever seen and gave a sign of his respect.",
    "Torwa praised the strength and courage that had bested U'cha, and rewarded it accordingly.")
q(4290, "The Fare of Lar'korwi", "Un'Goro Crater", 53, "torwa", 3,
    "Long ago, Torwa's brother had taken meat from one of Lar'korwi's kills. The great raptor followed him for days and killed him not far from Torwa's camp. Meat from a fresh kill would provoke the beast again.",
    "Torwa knew how to draw out Lar'korwi, by stealing from the great raptor's kill, the same thing that had cost his brother his life.",
    "Torwa kept the meat for the coming confrontation. He wondered where Lar'korwi had found a threshadon, and judged that the raptor would come for the thief before him.",
    "The meat from Lar'korwi's kill reached Torwa, who would hold it until the time came to face the beast.")
q(4291, "The Scent of Lar'korwi", "Un'Goro Crater", 53, "torwa", 3,
    "Lar'korwi bred with many females, and their scent glands told him when they were ready. Torwa wanted two glands from the ravasaur mothers guarding their eggs to the west.",
    "Torwa's final plan to draw out Lar'korwi needed scent glands from his mates, which would defend their nests fiercely.",
    "Torwa called the two glands fine specimens and the means to bait Lar'korwi into the open.",
    "The ravasaur glands reached Torwa. With them, he said, Lar'korwi would surely come out of hiding.")
q(4292, "The Bait for Lar'korwi", "Un'Goro Crater", 56, "torwa", 5,
    "Torwa had last seen Lar'korwi on a small trail into the mountains to the north, among the bones of great creatures. The stolen meat, rubbed with his mixture of glands, was to be left there as bait.",
    "Both lures together would bring Lar'korwi out if anything would. Torwa warned that fear was the great betrayer.",
    "Lar'korwi was dead. Torwa praised the Earth Mother and said only the greatest of his ancestors could have done such a thing.",
    "Torwa bowed to the hunter who had killed Lar'korwi, calling the deed worthy of his greatest ancestors.")
q(4243, "Chasing A-Me 01", "Un'Goro Crater", 53, "karna", 3,
    "Karna Remtravel had built a mechanical ape with scrying gems for eyes, to watch the apes of Un'Goro. Contact was lost at Fungal Rock, just as an alpha male rushed up to her.",
    "Karna Remtravel's mechanical ape had vanished at the apes' lair east of Marshal's Refuge, and the gnome wanted it found.",
    "The mechanical ape lay inert at Fungal Rock, with one large dent in its shoulder and another in its head.",
    "Karna's mechanical ape was found at Fungal Rock, badly dented and without power.", true)
q(4244, "Chasing A-Me 01", "Un'Goro Crater", 53, "karna", 3,
    "A panel on the mechanical ape's back carried plain instructions to replace the mithril casing and turn the power off and on.",
    "The fix looked simple, written on the ape's own wiring panel. A new mithril casing might be enough.",
    "The burned-out mithril casing came out and a new one slid into place. Only the switch remained.",
    "The ape's casing was replaced, ready for the power to be cycled.", true)
q(4245, "Chasing A-Me 01", "Un'Goro Crater", 53, "karna", 4,
    "With the switch thrown off, Karna's ape waited to be turned back on and led home, if the gorillas stayed away.",
    "The last step was to restart the mechanical ape and bring it back to Karna Remtravel near Marshal's Refuge.",
    "The mechanical ape walked home to Karna, who was delighted and fretted over the dents she would repair.",
    "Karna thanked the rescuer of her mechanical ape and promised to have it running perfectly again.", true)
fallback("Chasing A-Me 01", "Un'Goro Crater", "karna", "4243,4244,4245",
    "Karna Remtravel's mechanical ape had gone silent at Fungal Rock.",
    "Karna's mechanical ape had been built to blend in with the apes of Un'Goro.",
    "Karna's lost mechanical ape was one step nearer to home.",
    "The search for Karna's ape moved forward.")
q(3884, "Williden's Journal", "Un'Goro Crater", 50, "ungoro", 2,
    "A mangled notebook belonged to Williden Marshal. He and his companions had fled to higher ground in the north of the crater when their base camps were overrun.",
    "The torn pages named their owner, Williden Marshal, and suggested he could be found in the northern crater.",
    "Williden was glad to have his notebook back, one of the few things the expedition had not lost.",
    "Williden had given the notebook up for lost, like almost everything else the expedition brought into Un'Goro, and was glad to see it again.")
hl(4292, "Lar'korwi was lured out with his own kill and his mates' scent, and killed. Torwa praised the Earth Mother and the hunter's courage.",
    "The great raptor Lar'korwi was dead. Torwa called it a deed for his greatest ancestors.")
hl(3914, "The grave in Tanaris transformed Linken's sword. He was delighted to have it back, though he could not remember why he needed it.",
    "Linken took back his finished sword and paid for the work, still unsure what it was for.")
for _, id in ipairs({3912, 3913, 3914, 3941, 3942, 4084, 4005, 4289, 4301, 4290, 4291, 4292, 4243, 4244, 4245, 3884}) do src(id) end

-- Batch 9: Silithus at level sixty. The bronze dragonflight's path toward the
-- Scepter stops here at Long Forgotten Memories; no stage claims the scepter.
-- The compendium shows why[1] as a stage note, so Natalia's fate stays out of
-- every why[1]; 8309's second setup may mention it, as its own text does.
P.threads.world_bronze = "the favor of the bronze dragonflight"
P.threads.world_bronzebeard = "the Bronzebeard camp's research"
q(8286, "What Tomorrow Brings", "Tanaris", 60, "bronze", 4,
    "Baristolth of the Shifting Sands had been bound as a Watcher when a great being breathed upon his maimed body. Now he believed a second war was upon the desert, and wanted to know whether his master had returned to the Caverns of Time.",
    "The Watcher of Cenarion Hold could not act until he knew that the resting place of the bronze dragons was no longer empty.",
    "The great one had risen in the Caverns of Time. With that news, the Watcher's long watch came to an end.",
    "Anachronos had returned. The Watcher who had waited for him declared his own watch over.")
q(8288, "Only One May Rise", "Tanaris", 60, "bronze", 5,
    "A champion was needed to become an ally of the bronze Brood. The test was the Broodlord Lashlayer, who guarded the Halls of Strife before Nefarian's inner sanctum, and his head was the proof.",
    "Only one from an army of would-be champions could take up the burden. It began in Blackwing Lair, with the head of Broodlord Lashlayer.",
    "Broodlord Lashlayer's head was delivered. The question now was whether a mortal could be the first in a thousand years to earn the Bronze Flight's favor.",
    "With Lashlayer's head before him, the bronze dragon wondered aloud whether this could be the first champion to win the Brood's favor in a thousand years.")
q(8301, "The Path of the Righteous", "Tanaris", 60, "bronze", 4,
    "The Brood of Nozdormu distrusted the lesser races. Proof for the master meant carapace fragments from the silithid of Hive'Ashi, Hive'Zora and Hive'Regal, as many as could be carried.",
    "Potential was not enough for the bronze dragons. Their champion had to bring back a great load of silithid carapace from the three hives.",
    "The champion would not stand alone. The Brood granted the right to deputize others as Agents of Nozdormu.",
    "With the carapace fragments delivered, the Brood allowed its champion to name deputies to help in the task.")
q(8302, "The Hand of the Righteous", "Tanaris", 60, "bronze", 3,
    "More carapace fragments were needed, and each full load would earn the right to name another deputy.",
    "The Brood wanted still more silithid carapace, and promised a new deputy for every delivery.",
    "Another Agent of Nozdormu could now be deputized.",
    "The fragments earned the right to choose one more deputy, and perhaps one day all of Cenarion Hold would serve under the champion's command.")
q(8303, "Anachronos", "Tanaris", 60, "bronze", 5,
    "The time had come, and the secrets kept out of fear of hidden enemies could be shared. A tome held the knowledge needed to seek out the bronze dragons' master.",
    "The one who handed over the tome apologized for keeping so much secret, with enemies so close. Its knowledge would lead to the master of the Brood.",
    "Anachronos called the champion the hope of Kalimdor.",
    "In the Caverns of Time, Anachronos named the newcomer the hope of Kalimdor.")
q(8305, "Long Forgotten Memories", "Silithus", 60, "bronze", 5,
    "Near the sacred barrier in southern Silithus lay a single crystalline tear, a symbol of the losses of the War of the Shifting Sands. Gazing into it would bring understanding.",
    "Anachronos sent the champion to the tear by the scarab wall, to look into the memory of the ancient war.",
    "A great sorrow surrounded the crystal, so strong it felt as though it could kill.",
    "The tear by the barrier held the grief of the War of the Shifting Sands, overwhelming to anyone who looked into it.")
hl(8288, "Broodlord Lashlayer fell in Blackwing Lair. The bronze dragons wondered whether a mortal had earned their favor for the first time in a thousand years.",
    "Lashlayer's head went to the Brood of Nozdormu, the first step toward becoming their champion.")
hl(8305, "At the crystalline tear by the scarab wall, the sorrow of the War of the Shifting Sands was almost too much to bear.",
    "The tear in southern Silithus held the ancient war's grief, powerful enough to feel deadly.")
q(8278, "Noggle's Last Hope", "Silithus", 57, "noggle", 4,
    "Beetix's antidote had failed. Noggle must have been stung by one of the stronger creatures of the far south, and their more potent poisons would make a better cure.",
    "Beetix Ficklespragg needed venom from more kinds of poisonous creatures in southern Silithus. It was Noggle's last chance.",
    "The new antidote worked, and Noggle began to come to. Beetix said they owed a great debt.",
    "Noggle stirred as the antidote took hold. Beetix was overjoyed.")
q(8282, "Noggle's Lost Satchel", "Silithus", 58, "noggle", 3,
    "Noggle had lost his satchel of rare reagents fleeing Deathclasp, the giant scorpid, and then blundered into a nest of stonelash flayers. Without those reagents, he and Beetix could not make Cenarion Hold's potions.",
    "Still too weak to stand, Noggle asked for his bag, lost in the southern mountains behind Bronzebeard's camp.",
    "Noggle had his satchel back with all his rare reagents, and promised to be in debt for a long time.",
    "The reagents were all there. Noggle and Beetix could make Cenarion Hold's potions again.")
q(8283, "Wanted - Deathclasp, Terror of the Sands", "Silithus", 59, "noggle", 4,
    "Deathclasp, a terrible scorpid, had retreated to the southern mountains as the silithid grew more active, threatening patrols and expeditions. Captain Vish Kozus at the Cenarion Hold watchtower offered the reward.",
    "Cenarion Hold posted a bounty on Deathclasp, payable to whoever brought her pincer to Captain Vish Kozus.",
    "Deathclasp's pincer reached Captain Vish Kozus. With her gone, the southern mountains could serve as a path around the silithid hives.",
    "The scorpid was dead, and Vish Kozus gained a strategic route through the southern range.")
q(8308, "Brann Bronzebeard's Lost Letter", "Silithus", 60, "bronzebeard", 4,
    "Brann Bronzebeard's letter said most of his crew was dead. He had found word of a battle between a Titan and an Old God, and an ancient tunnel leading to Ahn'Qiraj, and he had taken it.",
    "The letter from Brann asked to be carried to his old camp, with instructions that his monkey get food, water and hugs. A postscript warned of a night elf who worshipped an Old God.",
    "At Bronzebeard's camp, the letter explained a lot. If anyone found a way into Ahn'Qiraj, they asked that Brann be looked for, helpless as he was without his monkey.",
    "The letter reached Bronzebeard's camp. Brann had gone into Ahn'Qiraj, and his people hoped someone would find him there.")
q(8309, "Glyph Chasing", "Silithus", 60, "bronzebeard", 4,
    "The three silithid hives had been spewing out insects, and Rutgar Glyphshaper wondered whether the glyphs on their strange crystals explained it. He wanted rubbings from crystals in all three hives.",
    "Since the first foray into the hives and Natalia Mar'alith's madness, the swarms had grown. Rutgar hoped the glyphs on the hive crystals held the reason.",
    "Rutgar could make nothing of the glyphs. He had never seen their like and hoped Frankal's research would help.",
    "The rubbings from the three hives baffled Rutgar Glyphshaper, who passed his hopes on to Frankal.")
q(8310, "Breaking the Code", "Silithus", 60, "bronzebeard", 4,
    "Frankal Stonebridge thought he could brew an elixir to help decipher the language of the silithid and qiraji. He needed a brain from each type of silithid in the hives.",
    "So that Rutgar Glyphshaper's work would not be for nothing, Frankal Stonebridge wanted brains, one from every kind of silithid.",
    "Frankal called the brains outstanding and told his helper not to wander off, since more work might follow.",
    "The silithid brains reached Frankal Stonebridge, who set to work on his deciphering elixir.")
q(8321, "Vyral the Vile", "Silithus", 60, "twilight", 5,
    "The Twilight's Hammer had another base, a cave called Twilight's Run in the northeast of Silithus. Its leader, Vyral the Vile, wore a signet ring that would prove his death.",
    "Twilight's Run, a cave full of horrors, sheltered the cult's local leader, Vyral the Vile.",
    "Vyral was dead and his ring delivered. Cenarion Hold judged the blow one the cult's Silithus operations would not easily recover from, though some cultists remained.",
    "The death of Vyral the Vile meant doom for the Twilight's Hammer in Silithus, as Cenarion Hold saw it.")
q(8323, "True Believers", "Silithus", 59, "twilight", 3,
    "With the Twilight Lexicon in his hands, the former cultist wanted the cult's monthly encoded bulletin, the True Believer. It would say whether they still hunted him.",
    "The Twilight's Hammer circulated a secret bulletin among its members. Its pages might hold news of the search for its deserter, and other useful things.",
    "The former cultist took the encoded texts and promised to share anything of interest he decoded.",
    "The cult's bulletins reached their deserter, who began decoding them at once.")
hl(8321, "Vyral the Vile died in Twilight's Run. Cenarion Hold called it a blow the cult in Silithus would not easily recover from.",
    "The Twilight's Hammer lost its Silithus leader, Vyral the Vile.")
for _, id in ipairs({8286, 8288, 8301, 8302, 8303, 8305, 8278, 8282, 8283, 8308, 8309, 8310, 8321, 8323}) do src(id) end

-- Batch 10: the Defiler's weapon between Arkkoroc (3509) and the amulet (3627),
-- Hydraxis's errands, Kim'jael, the Fallen Hero's lost orders, the Firegut and
-- the Kargath Expeditionary Force. Argelmach's "death" in 4063 is the machine's.
P.threads.world_fallenhero = "the Fallen Hero's lost orders"
P.threads.world_kef = "the Kargath Expeditionary Force"
P.threads.world_kimjael = "Kim'jael's business in Azshara"
P.threads.world_machines = "Theodora's rogue machines"
q(3510, "The Name of the Beast", "Azshara", 58, "defiler", 3,
    "Lord Arkkoroc wanted Hetaera dead, the naga who called herself ruler of the oceans and killed his children. All her heads were the price of the demon lord's name.",
    "Arkkoroc called Hetaera a false god. He pointed southwest toward her clutch and promised the name, and something more, for her heads.",
    "Arkkoroc received Hetaera's heads and declared their bearer worthy of his wisdom at last.",
    "Hetaera was dead. Lord Arkkoroc bent to inspect the heads and judged the deed worthy.", true)
q(3511, "The Name of the Beast", "Azshara", 58, "defiler", 4,
    "Arkkoroc revealed the demon lord's name, Razelikh the Defiler, and squeezed the blood from Hetaera's heads to make a temper for the weapon. The temper and the true name, Rakh'likh, were for Loramus.",
    "The weapon against the Defiler needed a temper. Arkkoroc drained Hetaera's heads between his fists and sent the blood to Loramus with the beast's true name.",
    "Loramus said Arkkoroc's temper would give the forging the vitriol it needed. One step remained before the weapons could be made.",
    "The demon's true name and Arkkoroc's temper reached Loramus, who saw one step left before the weapons could be made.", true)
q(3602, "Azsharite", "Azshara", 58, "defiler", 3,
    "The cliff giants of southern Azshara ate rock and buildings and left behind Azsharite, a malleable and very strong crystal. Loramus wanted enough of it for the weapons' bodies, and lent his felhounds to help.",
    "Few ever recovered Azsharite, because the giants who produced it were so violent. Loramus needed it all the same.",
    "Loramus declared the work in Azshara complete and turned to forging the components for the next step.",
    "The Azsharite reached Loramus, who began forging what the weapons would need.")
q(3621, "The Formation of Felbane", "Stranglethorn Vale", 58, "defiler", 4,
    "The tempered Azsharite had to go to a smith who could harness fel energy. Galvan the Ancient, leader of the Mithril Order, kept a camp in Stranglethorn between Zul'Gurub and the Mosh'Ogg mound.",
    "Loramus sent the weapon materials to Galvan the Ancient in Stranglethorn Vale, and his blessing with them.",
    "Galvan had not heard the name Loramus in many years. He marveled that anyone had brought back such materials from Azshara alive, let alone after facing demigods and giants.",
    "The materials reached Galvan the Ancient, who could only imagine what it had taken to gather them.")
q(3625, "Enchanted Azsharite Fel Weaponry", "Stranglethorn Vale", 58, "defiler", 4,
    "Galvan warned that the Felcurse in the new weapon could be used only once every three minutes, and that its weakening of Razelikh and his minions might not last.",
    "Each weapon took time to forge, Galvan said, and the forging must not be interrupted.",
    "Galvan wiped the sweat from his brow. A finer demon slayer had never existed, he said.",
    "The Azsharite weapon was finished, and Galvan called it the finest demon slayer ever made.")
q(3626, "Return to the Blasted Lands", "Blasted Lands", 58, "defiler", 3,
    "With the new weaponry, it was time to return to the Fallen Hero of the Horde for the final objective.",
    "The hour of redemption was near. The Fallen Hero waited for the weapons from Galvan's forge.",
    "The Fallen Hero asked whether the bearer of the weapons was ready to face Razelikh and his minions.",
    "The weapons were back with the Fallen Hero, who saw the marks of battle and asked if the time had come to face Razelikh.")
q(2621, "The Disgraced One", "Swamp of Sorrows", 50, "fallenhero", 3,
    "The Fallen Hero of the Horde blamed himself for a regiment's ruin. If only he had waited for his orders, they might have warned of what waited in those cursed lands. Dispatch Commander Ruag in Stonard would know what became of them.",
    "Regret was all the spirit had left. He stood waiting for orders that never came, and wanted to know why.",
    "Commander Ruag remembered Thrall's Grasp. The Horde had lost some of its best soldiers when that battalion was destroyed.",
    "The dispatch commander in Stonard shook his head over the fate of the regiment called Thrall's Grasp.")
q(2622, "The Missing Orders", "Swamp of Sorrows", 50, "fallenhero", 3,
    "Ruag bristled at the question. He had relayed the orders, but the soldiers carrying them were ambushed by murlocs, and only Bengor survived, unable to walk and fed through a tube.",
    "The orders had been sent, Ruag insisted, with a warning about sticking noses where they might be bitten. Bengor, the lone survivor of the murloc ambush, might say more.",
    "Bengor could only stammer two words, Swamp Talker.",
    "The broken survivor managed a few halting syllables, naming the Swamp Talker.")
q(2623, "The Swamp Talker", "Blasted Lands", 55, "fallenhero", 4,
    "Bengor remembered the ambush on the way to the Blasted Lands. A murloc called Swamp Talker took the orders from his hands as a spear struck his skull, and went east to a cave.",
    "The Swamp Talker had the orders that never reached the Fallen Hero's regiment. Bengor pointed east before passing out.",
    "The orders reached the Fallen Hero at last, and they were worse than he had imagined. Nineteen of his men might have been spared; powerless himself, he asked for help for them.",
    "The recovered orders confirmed the Fallen Hero's fear. His haste had cost nineteen soldiers needless agony, and he begged that they be helped.")
hl(2623, "The orders taken by the Swamp Talker reached the Fallen Hero. Nineteen of his soldiers could have been spared, he said, and he asked for help for them.",
    "The lost orders came home to the Fallen Hero, proof that his haste had doomed nineteen men.")
q(6804, "Poisoned Water", "Azshara", 56, "waterlords", 3,
    "Water elemental scouts sent to the Eastern Plaguelands had been twisted by the plague. A vial holding an aspect of Neptulon would cure them, though their inner conflict would drive them into a surging madness.",
    "Hydraxis could not allow plagued water elementals to stain the Waterlords' purity. Their bracers of binding would prove they had been cured and defeated.",
    "Hydraxis approved. The corrupted elementals had been an outrage to all water, and purity was the Waterlords' strength in their war.",
    "The bracers of binding reached Hydraxis, who counted the cure a service to the purity of his kind.")
q(6805, "Stormers and Rumblers", "Azshara", 57, "waterlords", 3,
    "The water elementals warred against the lesser elements. Hydraxis wanted the air and earth servants of Silithus's Crystal Vale defeated, whatever they guarded.",
    "To prove conviction as an ally of the Waterlords, Hydraxis asked for an attack on the stormers and rumblers in the Crystal Vale.",
    "Hydraxis declared bravery proven, and hinted at tasks more fitting for a valued ally.",
    "The Crystal Vale's elementals were beaten. Hydraxis judged the newcomer worthy of greater tasks.")
q(5534, "Kim'jael's \"Missing\" Equipment", "Azshara", 53, "kimjael", 2,
    "Kim'jael wanted a rune the blood elves had been seeking, now held by the naga in the Ruins of Eldarath. A valuable employee, he said, would be paid adequately in time.",
    "Kim'jael haggled over pay and then offered more of it for a rune from the Ruins of Eldarath, one the blood elves had wanted.",
    "Kim'jael gloated over the rune and meant to learn why Magus Rimtori, who had hired him, wanted it. He paid up and went off to plot.",
    "The rune reached Kim'jael, who saw a chance to turn the tables on the blood elves who had hired him.")
q(3824, "Gor'tesh the Brute Lord", "Burning Steppes", 53, "blackrock", 4,
    "Oralius wanted the next strike against the Firegut to be decisive. Gor'tesh the Brute Lord ruled from a Blackrock building west of Dreadmaul Rock, and his head was needed for the third phase of the attack.",
    "The Firegut were reeling, Oralius said. Gor'tesh's head would prepare his next move.",
    "Oralius cackled over Gor'tesh's head. Set on a pike atop Dreadmaul Rock, he said, it would send the remaining ogres into hysteria.",
    "Gor'tesh was dead, and Oralius planned to use his head to terrify the Firegut.")
q(3825, "Ogre Head On A Stick = Party", "Burning Steppes", 53, "blackrock", 3,
    "Oralius had put Gor'tesh's head on a pike. Planted at the top of Dreadmaul Rock, it would send the ogres running.",
    "One task remained for Oralius, who seemed to be losing touch with reality. The pike had to go to the top of Dreadmaul Rock.",
    "Oralius called it outstanding work and nearly claimed a medal of bravery for himself before promising a handsome reward.",
    "The head stood on Dreadmaul Rock. Oralius was delighted and rewarded the work.")
q(4122, "Grark Lorkrub", "Burning Steppes", 58, "kef", 4,
    "Grark Lorkrub had been caught giving the Blackrock orcs information about the Horde's operations, then fled to their protection in the Burning Steppes. The traitor was to be shackled and led through Blackrock Mountain.",
    "The Kargath Expeditionary Force had tracked a traitor across the Searing Gorge and into the Burning Steppes. Grark Lorkrub was to be brought back in shackles.",
    "Grark, in shackles, still boasted of the power to be gained by joining the Blackrock.",
    "Grark Lorkrub was captured, unrepentant and full of praise for the Blackrock legion.")
q(4121, "Precarious Predicament", "Badlands", 58, "kef", 5,
    "Grark sneered that no one could break into a Blackrock fortress, take him, and reach the rendezvous unnoticed. The escort had to prove him wrong.",
    "Leading the captured traitor out through Blackrock Mountain meant fighting off his would-be rescuers.",
    "The traitor was handed over at the rendezvous. The deed earned a tribute, and the Warlord was ready to discuss the final mission.",
    "Grark Lorkrub was delivered into Horde custody, and the K.E.F. promised that the escort would not go unrecognized.")
q(4132, "Operation: Death to Angerforge", "Badlands", 58, "kef", 5,
    "General Angerforge had coordinated the attacks on the K.E.F.'s 109th division and the slaughter of its forces. The last mission was to bring him to justice in Blackrock Depths.",
    "Goretooth called it the most grueling mission of all, against the Dark Iron general known as the Butcher of Blackrock.",
    "Angerforge was dead. Goretooth gave a medallion as a symbol of dedication to the Horde and the K.E.F.",
    "The Butcher of Blackrock had been brought to justice. The Warlord rewarded the deed with the K.E.F.'s medallion.")
hl(4132, "General Angerforge, the Butcher of Blackrock, was killed. Goretooth gave a medallion in honor of the Horde and the K.E.F.",
    "The Dark Iron general behind the slaughter of the 109th was dead, and the Warlord rewarded the deed.")
q(4061, "The Rise of the Machines", "Badlands", 54, "machines", 3,
    "Machines had appeared in the Searing Gorge, imported from the Burning Steppes or perhaps Blackrock Depths. Theodora Mulvadania wanted shards from the rock automatons to trace their origin.",
    "Theodora meant to find who was building the rock creations. Their elemental shards would tell her.",
    "Theodora examined the fragments with an enormous monocle and found initials etched into each one.",
    "Initials were carved into the foundation of every shard, Theodora discovered.", true)
q(4063, "The Rise of the Machines", "Badlands", 58, "machines", 5,
    "Theodora could not believe it was Argelmach. She had killed him herself ten years earlier, after he twisted her life's work to his own ends. If he lived, he had to be destroyed, and she needed samples of his creations.",
    "The initials pointed to Argelmach, a dwarf Theodora thought she had killed long ago. His machines guarded him in Blackrock Depths.",
    "The head brought back was not flesh. It was a dark iron machine, a shadow of Argelmach, and Theodora expected another to rise in its place.",
    "Argelmach turned out to be another machine. Theodora warned that its destruction would not last, since a new one would take its place.", true)
fallback("The Rise of the Machines", "Badlands", "machines", "4061,4062,4063",
    "Theodora Mulvadania was tracing the rock machines that had appeared in the Searing Gorge.",
    "Someone was building rock automatons in the Burning Steppes, and Theodora wanted to know who.",
    "Theodora's inquiry into the rogue machines moved forward.",
    "The investigation into the rock automatons had one more answer.")
for _, id in ipairs({3510, 3511, 3602, 3621, 3625, 3626, 2621, 2622, 2623, 6804, 6805, 5534, 3824, 3825, 4122, 4121, 4132, 4061, 4063}) do src(id) end

-- Batch 11: Dustwallow's Stonemaul ogres, Trelane's lost items in Arathi, and
-- Faldir's Cove. The Stonemaul's new leader is not named by these records.
P.threads.world_stonemaul = "the Stonemaul's lost home"
P.threads.world_trelane = "Trelane's lost items"
P.threads.world_faldir = "the wreck at Faldir's Cove"
q(1166, "Overlord Mok'Morokk's Concern", "Dustwallow Marsh", 43, "stonemaul", 2,
    "Overlord Mok'Morokk, whom Rexxar had made leader of the Stonemaul, had led his clan out of their old home when dragons set it alight. He had left so fast that his grog, his snuff and his strongbox stayed behind in the south.",
    "Mok'Morokk boasted of keeping his clan safe, then sent someone else south to the Den of Flame and Stonemaul Ruins for his grog, snuff and strongbox.",
    "Mok'Morokk had his things back and declared that he liked the one who fetched them.",
    "The overlord's grog, snuff and strongbox were back in Brackenwall, and Mok'Morokk was pleased.")
q(1168, "Army of the Black Dragon", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Tharg wanted revenge. Black dragons had killed many ogres and his wife, and Mok'Morokk had told the clan to run. Ogres should fight, Tharg said, and he wanted to go home to the Stonemaul Ruins.",
    "To Tharg, Mok'Morokk cared only for himself. He asked for help fighting the black dragon army that held the clan's old home.",
    "Many of the black dragon army were dead, and Tharg was glad.",
    "Tharg praised the bravery shown against the black dragon army in the south.")
q(1169, "Identifying the Brood", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Draz'Zilb, an ogre who spoke with unexpected polish, was the only one trying to learn who had attacked the old village. Hearts and tongues from the black whelps and hatchlings would let him trace the source.",
    "While Mok'Morokk wallowed in power and Tharg grieved, Draz'Zilb wanted to know which dragon had brought her spawn to Stonemaul Village.",
    "Draz'Zilb called the collection a perilous affair and began delving into the arcane to trace the black menace.",
    "The whelps' hearts and tongues reached Draz'Zilb, who set to work tracing the dragons' origin.")
q(1170, "The Brood of Onyxia", "Dustwallow Marsh", 43, "stonemaul", 4,
    "Draz'Zilb found that Onyxia's brood had invaded Stonemaul Village. He suspected Deathwing's daughter had a purpose beyond besieging a band of ogres, and wanted Mok'Morokk told.",
    "The brood of Onyxia had taken the Stonemaul's home. Draz'Zilb urged that the overlord act at once.",
    "Mok'Morokk wanted nothing to do with dragons. There were none here, he said, and he liked it here.",
    "The overlord heard the news about Onyxia's brood and refused to care.", true)
q(1171, "The Brood of Onyxia", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Mok'Morokk sent word back to Draz'Zilb that the clan would stay where it was, away from the black dragons.",
    "The overlord's answer to the dragon threat was to stay put. Draz'Zilb had to hear it.",
    "Draz'Zilb called Mok'Morokk a lazy coward. The overlord had been strong while Rexxar led, he said, but power had changed him, and something had to be done.",
    "Draz'Zilb decided the overlord who demanded service instead of serving could not be left in charge.", true)
q(1172, "The Brood of Onyxia", "Dustwallow Marsh", 45, "stonemaul", 4,
    "Onyxia's brood was scattered across the Dragonmurk. Draz'Zilb wanted her eggs in the Wyrmbog destroyed before more whelps hatched, or Stonemaul Village could never be reclaimed.",
    "The Wyrmbog was surely Onyxia's lair. Draz'Zilb asked that her eggs be found and smashed, and hinted at other plans for Mok'Morokk.",
    "Draz'Zilb said it would be some time before Onyxia could produce more eggs. Then he asked for one last service, to drive Mok'Morokk out by force so the clan could choose a new leader.",
    "Onyxia's eggs were destroyed. Draz'Zilb gave thanks on behalf of his people and named Tharg as a worthy leader, if not for his age and injuries.", true)
fallback("The Brood of Onyxia", "Dustwallow Marsh", "stonemaul", "1170,1171,1172",
    "Onyxia's brood had driven the Stonemaul ogres from their old village.",
    "Draz'Zilb of the Stonemaul was trying to understand why Onyxia's dragons had come to the marsh.",
    "Draz'Zilb's effort against Onyxia's brood moved forward.",
    "The Stonemaul's struggle with the black dragons went on.")
q(1173, "Challenge Overlord Mok'Morokk", "Dustwallow Marsh", 45, "stonemaul", 5,
    "Mok'Morokk laughed at the challenge and promised a good beating whenever his challenger was ready.",
    "The overlord accepted the duel with a roar, sure of crushing the one who dared face him.",
    "Mok'Morokk fled like a frightened child. Draz'Zilb said the Stonemaul could now choose a leader to take them home.",
    "The cowardly overlord was driven out of Brackenwall, and the Stonemaul were free to appoint someone new.")
hl(1172, "Onyxia's eggs in the Wyrmbog were destroyed. Draz'Zilb gave thanks for his people, then asked that Mok'Morokk be driven out.",
    "Draz'Zilb said Onyxia would need time to lay more eggs, and turned to removing the clan's coward of an overlord.")
hl(1173, "Mok'Morokk fled from the challenge. Draz'Zilb said the Stonemaul could at last choose a leader to take them home.",
    "The overlord ran, and the Stonemaul were free to pick a new leader.")
q(693, "Wand over Fist", "Arathi Highlands", 39, "trelane", 3,
    "Skuerto had traced the first of Trelane's items. Kor'gresh had the wand in Boulderfist Hall and was learning to use it, blasting his own kin with ice to keep them in line.",
    "The wand belonged to Trelane, and the ogre Kor'gresh was close to mastering it. Skuerto wanted it taken back from Boulderfist Hall.",
    "Skuerto called it brilliant work, one item down and three to go. The other three lay in Stromgarde, and he advised rest before the next phase.",
    "Trelane's wand was recovered from Kor'gresh. Skuerto turned his thoughts to the three items still in Stromgarde.")
q(694, "Trelane's Defenses", "Arathi Highlands", 39, "trelane", 3,
    "Ogres surrounded the Tower of Arathor in Stromgarde. Its defenses could be woken with gems the Boulderfist shaman had stolen, once Kryten enchanted one as a key.",
    "Skuerto's plan needed an azure agate from the Boulderfist shaman. Kryten knew the spell to turn it into a key for the tower's defenses.",
    "Kryten marveled at the agate and set about enchanting it.",
    "The azure agate reached Kryten, who began casting the spell to make it a key.")
q(695, "An Apprentice's Enchantment", "Arathi Highlands", 39, "trelane", 3,
    "Kryten's enchanted gem would wake the tower's defenses when pressed against a pedestal at its base. He sent it with instructions to hear the rest from Skuerto.",
    "The gem was ready. Pressed to a pedestal by the Tower of Arathor, it would turn the tower's defenses against the ogres.",
    "Skuerto was ready to begin, if there were no more delays.",
    "With the gem enchanted, Skuerto called for the attack on the tower to start.")
q(696, "Attack on the Tower", "Arathi Highlands", 39, "trelane", 4,
    "Trelane's phylactery, orb and ember agate lay in chests inside the Tower of Arathor. The defenses would help, but the ogres would fight anyone they caught stealing.",
    "Skuerto named the three remaining items, all in the tower's chests, and warned that the ogres would have to be fought regardless.",
    "Skuerto called the mission an overwhelming success. Malin, he said, could not have asked for a worthier helper.",
    "Trelane's phylactery, orb and ember agate were recovered from Stromgarde, and Skuerto was delighted.")
q(690, "Malin's Request", "Arathi Highlands", 32, "trelane", 3,
    "Archmage Malin's old master, Trelane, had fled Stromgarde after failing to hold the Tower of Arathor, and wanted the items he left behind. Malin's agents in the Highlands had asked for more help.",
    "Stromgarde had fallen under siege. Archmage Malin sent help to his agents in Arathi to recover what Trelane had abandoned in the Tower of Arathor.",
    "Skuerto did not care who had sent help. He was busy, he said, and pointed to Kryten.",
    "At Refuge Pointe, Skuerto waved off Malin's latest helper and sent the questions to Kryten.", true)
q(697, "Malin's Request", "Stormwind City", 39, "trelane", 3,
    "Skuerto sent a letter back to Archmage Malin in Stormwind, saying that he and Kryten would soon be home.",
    "The work in Arathi was done. Archmage Malin was to have Skuerto's letter and the news of Trelane's items.",
    "Malin opened the letter and his eyes widened. Trelane would be so pleased, he said, and he rewarded the messenger.",
    "Archmage Malin read Skuerto's letter with delight. Trelane's items were on their way to Stormwind.", true)
fallback("Malin's Request", "Arathi Highlands", "trelane", "690,697",
    "Archmage Malin was helping his old master Trelane recover what was lost at Stromgarde.",
    "Trelane's items in the Tower of Arathor concerned Archmage Malin and his agents in Arathi.",
    "Malin's effort to recover Trelane's items moved forward.",
    "Word passed between Archmage Malin and his agents in the Highlands.")
q(663, "Land Ho!", "Arathi Highlands", 35, "faldir", 2,
    "Lolo the lookout welcomed newcomers to Faldir's Cove. The Harbinger was meant to stay only a few hours for the treasure, but two ships of its formation had sunk.",
    "At Faldir's Cove, Lolo feared a long stay. The Spirit of Silverpine and the Maiden's Folly lay on the bottom of the sea.",
    "Captain O'Breen explained the disaster. A contraption of the Professor's had pointed to treasure in the cove, the tide dropped, and two ships struck the reef, where something lay below.",
    "O'Breen feared Fleet Master Seahorn would have his ship for this. Something under the reef had wrecked the Spirit of Silverpine and the Maiden's Folly, and he wanted help for his crew.")
q(662, "Deep Sea Salvage", "Arathi Highlands", 40, "faldir", 3,
    "The Maiden's Folly and the Spirit of Silverpine had run aground on something like a temple in the reef. Their logs and charts could not be left for prying eyes.",
    "Losing the sunken ships' logs and charts to enemies would send the crew down the plank at Seahorn's order.",
    "The logs and charts were recovered. Knowing them secure would ease the command in Booty Bay.",
    "The sunken ships' logs and charts were safe again.")
q(664, "Drowned Sorrows", "Arathi Highlands", 40, "faldir", 3,
    "The Maiden's Folly's captain had survived the sinking, but naga killed the rest of his crew. He wanted the beasts dead.",
    "Sitting by the fire when he should have been in a watery grave, the Maiden's Folly's captain asked for vengeance on the naga.",
    "The naga's deaths could not bring back the ship or the crew, the captain said, but they gave him some solace.",
    "The Daggerspine naga had paid, and the grieving captain took some comfort from it.")
q(667, "Death From Below", "Arathi Highlands", 44, "faldir", 4,
    "The Daggerspines were massing to attack. Without the captain's knowledge of the seas, the crew could not get home to Booty Bay, so the cannon had to hold the naga back.",
    "The naga would come from the sea and keep coming until O'Breen was dead. He asked for help manning the cannon.",
    "The cove survived the attack. O'Breen would sail as soon as the tide rose, and said he would have offered a place on his crew to a hero with less important work.",
    "The Daggerspine attack was beaten off, and O'Breen made ready to leave with the tide.")
for _, id in ipairs({1166, 1168, 1169, 1170, 1171, 1172, 1173, 690, 693, 694, 695, 696, 697, 663, 662, 664, 667}) do src(id) end

-- Batch 12 (continued), at the alliance lane's request: the Ashenvale stages
-- of the Tower of Althalaxx. They share the alliance pack's thread key and
-- label verbatim; the title fallback stays in LoreAllianceStories.lua, so every
-- stage here is exact-only. Athrikus's death is told only by 981 (after 1143).
P.threads.alliance_althalaxx = "the Cult of the Dark Strand"
q(967, "The Tower of Althalaxx", "Ashenvale", 18, "althalaxx", 3,
    "Balthule's master was Delgren the Purifier, a paladin helping the Sentinels defend the forests against demons and the undead. Delgren had to know about the cult's operations at once, and he was at Maestra's Post in Ashenvale.",
    "Balthule feared the Dark Strand grew more dangerous by the hour. His letter was for Delgren the Purifier at Maestra's Post.",
    "Delgren read Balthule's letter and called the news disturbing. He helped the Sentinels destroy demons and undead wherever they were found, and had come to respect the night elves as allies.",
    "At Maestra's Post, Delgren the Purifier remarked that the messenger looked well equipped for the job, then read Balthule's warning with concern.", true)
q(970, "The Tower of Althalaxx", "Ashenvale", 21, "althalaxx", 3,
    "Delgren had been fighting the Dark Strand at Ordil'Aran, northeast of Maestra's Post. One of the cultists there carried a soul gem he believed held the secret of the cult's power.",
    "The Cult of the Dark Strand was a thorn in Delgren's side. A soul gem from Ordil'Aran might let him decipher its secrets.",
    "Delgren found dark magic in the soulstone and set about learning what was trapped inside.",
    "The soul gem from Ordil'Aran reached Delgren, who began to draw out the secret it held.", true)
q(973, "The Tower of Althalaxx", "Ashenvale", 24, "althalaxx", 4,
    "The soul gem pointed to Ilkrud Magthrull, a powerful orc warlock at the Fire Scar Shrine in southwestern Ashenvale. Delgren had thought him only an annoyance until now.",
    "Ilkrud Magthrull's time had come, Delgren decided. The warlock lived at the Fire Scar Shrine, a place of great evil.",
    "Ilkrud Magthrull was dead. Delgren praised the deed and turned to the warlock's writings.",
    "Delgren called facing down a warlock of Ilkrud's power a grand thing, and began reading what Ilkrud had left behind.", true)
q(1140, "The Tower of Althalaxx", "Ashenvale", 28, "althalaxx", 4,
    "Delgren had learned the orcs' writing despite the scorn of his order. Ilkrud's notes showed that Athrikus still held two soulgems, kept at Night Run and Satyrnaar in the satyr lands of northeast Ashenvale.",
    "Two of Athrikus's soulgems remained, in the blood-soaked satyr temples of Night Run and Satyrnaar. Delgren wanted them destroyed.",
    "With the soulgems destroyed, Delgren judged Athrikus's power greatly diminished, and saw the chance to finish him and his cult. He meant to speak with Elissa in Auberdine about the satyrs.",
    "The last of Athrikus's soulgems were broken. Delgren thought the satyrs had been allowed to persist too long, and that the cult could now be ended.", true)
q(981, "The Tower of Althalaxx", "Ashenvale", 31, "althalaxx", 5,
    "Balthule sent word back to Delgren that Athrikus Narassin was dead and the Cult of the Dark Strand beaten and scattered.",
    "With Athrikus stilled, Balthule wanted the victory reported to Delgren at Maestra's Post, and the work rewarded.",
    "Delgren had expected nothing less. He foresaw great deeds ahead and gave his blessing along with a gift.",
    "The news of the cult's defeat reached Delgren the Purifier, who gave his blessing and a reward.", true)
hl(981, "The Cult of the Dark Strand was beaten, and Delgren the Purifier sent his blessing and a gift.",
    "Word that Athrikus was dead reached Delgren at Maestra's Post, and he foresaw great deeds ahead.")
for _, id in ipairs({967, 970, 973, 1140, 981}) do
    src(id, "LoreAllianceStories.lua thread alliance_althalaxx (Darkshore stages); alliance lane hand-off 2026-11-05")
    P.questIDs[id].thread = "alliance_althalaxx"
    P.questIDs[id].threadLabel = P.threads.alliance_althalaxx
end

-- BEGIN WORLD2 PASS 20261105 (lane world2)
-- Mid-level shared zones. Exact IDs from corpus_vanilla_quests.txt, read in full;
-- NPC roles and places cross-checked against LoreForever quest/NPC entries
-- (facts only, own words). Report: StorageInvestigation/cj-overnight-20261105/world2/.
-- Batch W2-1: Hillsbrad. Lydon's elixirs, the Crown of Will, Krusk's search
-- for Gol'dir (which opens the pendant thread of 507/508), Farren Orinelle's
-- hopes of a transfer, and the watch on the Go'Shek Farm.
P.threads.world_lydon = "Apothecary Lydon's elixirs"
P.threads.world_crown = "the Crown of Will"
P.threads.world_farren = "Farren Orinelle's hopes of a transfer"
P.threads.world_goshek = "the watch on the Go'Shek Farm"
q(496, "Elixir of Suffering", "Hillsbrad Foothills", 22, "lydon", 2,
    "Apothecary Lydon found Tarren Mill's clean air depressing and wanted the humans plagued soon. He needed gray bear tongues and creeper ichor for his killing agents.",
    "Apothecary Lydon of Tarren Mill had no time to gather his own reagents. Ten gray bear tongues and a rare creeper's ichor would keep his work for the Dark Lady going.",
    "The tongues and ichor were perfect specimens. Lydon admitted they had brought him a hint of joy on another miserable day.",
    "Lydon had his bear tongues and creeper ichor, and gave his thanks in his gloomy way.", true)
q(499, "Elixir of Suffering", "Hillsbrad Foothills", 22, "lydon", 2,
    "Lydon mixed the tongues and ichor into what he named the Elixir of Suffering. Umpi, the frog he kept in his workshop, was to have the first taste.",
    "The new elixir needed a test before the Dark Lady used it on humans and Scourge. Lydon chose Umpi, his frog assistant.",
    "A taste of the Elixir of Suffering went to Umpi, who answered with a croak.",
    "The first dose of Lydon's elixir went to Umpi the frog, who croaked.", true)
fallback("Elixir of Suffering", "Hillsbrad Foothills", "lydon", "496,499",
    "Apothecary Lydon of Tarren Mill was brewing poisons for the Forsaken's new plague.",
    "Lydon's Elixir of Suffering began with reagents gathered around Tarren Mill.",
    "Lydon's work on the Elixir of Suffering moved forward.",
    "Another step of the apothecary's experiment in Tarren Mill was done.")
q(501, "Elixir of Pain", "Hillsbrad Foothills", 24, "lydon", 2,
    "In Tarren Mill, Lydon longed for the day the New Plague brought death to the world. His research called for the blood of a mountain lion.",
    "Hillsbrad's spring flowers only deepened Apothecary Lydon's gloom. He believed mountain lion blood would make a splendid death-brew for Lady Sylvanas.",
    "Lydon had the mountain lion blood and praised the collecting.",
    "The lion blood reached Lydon, ready for his next elixir.", true)
q(502, "Elixir of Pain", "Hillsbrad Foothills", 24, "lydon", 3,
    "Lydon turned the blood into an Elixir of Pain and wanted it tested. Farmer Ray kept a dog named Stanley on the northern farm in Hillsbrad Fields.",
    "Lydon thought the Elixir of Pain might be the start of something for Lady Sylvanas. Stanley, a farm dog in Hillsbrad Fields, was to be offered it as a treat.",
    "Some of Lydon's elixir was poured into a hand and held before Stanley's mouth.",
    "On the northern farm, Farmer Ray's dog Stanley was offered the Elixir of Pain.", true)
fallback("Elixir of Pain", "Hillsbrad Foothills", "lydon", "501,502",
    "Apothecary Lydon was brewing an Elixir of Pain in Tarren Mill.",
    "Lydon's Elixir of Pain needed blood from Hillsbrad's wildlife and then a test.",
    "Lydon's Elixir of Pain moved a step closer to use.",
    "The apothecary's experiment with blood from the foothills went on.")
q(509, "Elixir of Agony", "Hillsbrad Foothills", 28, "lydon", 2,
    "Lydon would have let the humans and the Scourge kill each other, but the Dark Lady wanted the process hurried. He sent for six mudsnout blossoms from the gnolls' field at Nethander Stead.",
    "Apothecary Lydon's next elixir began at Nethander Stead, south of Tarren Mill, where the gnolls grew mudsnout blossoms.",
    "Lydon savored the reek of the mudsnout blossoms. The gnolls, he said, were good for something after all.",
    "Six mudsnout blossoms reached Lydon for his Elixir of Agony.", true)
q(513, "Elixir of Agony", "Undercity", 28, "lydon", 3,
    "Lydon ground the blossoms into a composite. Master Apothecary Faranell in the Undercity had to add his colloid of decay before the work could go on.",
    "The mudsnout composite needed Faranell's colloid of decay. Lydon sent it to the Undercity at once.",
    "Faranell was too busy for visitors until he heard Lydon's name. He called Lydon one of their most dedicated members and liked what he was doing.",
    "The composite reached Master Apothecary Faranell, who understood Lydon's plan and expected it to please the Dark Lady.", true)
q(515, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 3,
    "Faranell added his colloid of decay to the composite. To wake it, Lydon would need a strong troll's blood potion, daggerspine scales and torn fin eyes from Hillsbrad's southern coast.",
    "The brew still lacked the reagents that would activate its contagion. Faranell named them and sent the mixture back to Lydon.",
    "Lydon had every reagent and declared himself giddy over the experiment.",
    "The scales, eyes and troll's blood potion reached Lydon, who could finish his elixir at last.", true)
q(517, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 3,
    "The Elixir of Agony was ready, and Lydon thought it wasted on a frog or a dog. He wanted a keg of Shindigger Stout stolen from the dwarves' barracks at Dun Garok.",
    "Lydon had a better use for a contagious plague than another animal test. A keg of the dwarves' Shindigger Stout from Dun Garok would carry it.",
    "Lydon had his keg of Shindigger Stout and was ready for action.",
    "The stolen keg from Dun Garok reached Tarren Mill, where Lydon could hardly wait to use it.", true)
q(524, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 4,
    "The Deathguards held captured farmers next door to Lydon. Darthalia had suspected a Stormwind strategist among them, but he was found dead in the Plaguelands, so she left the prisoners to Lydon.",
    "Lydon tainted the stolen stout with his elixir and meant the keg for the room where the Deathguards kept their captured farmers.",
    "The tainted keg was set on the dusty rug in the prisoners' room.",
    "The plagued stout was set down on the rug where the captured farmers were held.", true)
fallback("Elixir of Agony", "Hillsbrad Foothills", "lydon", "509,513,515,517,524",
    "Apothecary Lydon was preparing an Elixir of Agony for the Dark Lady.",
    "The Elixir of Agony passed between Lydon in Tarren Mill and the apothecaries of the Undercity.",
    "Lydon's Elixir of Agony moved closer to its test.",
    "Another stage of the apothecaries' work on the Elixir of Agony was done.")
hl(524, "Lydon's Elixir of Agony went into a keg of stolen dwarven stout. The keg was set down in the room where the Deathguards held captured farmers.",
    "Lydon's tainted keg was left on the rug in the prisoners' room in Tarren Mill.")

q(495, "The Crown of Will", "Hillsbrad Foothills", 39, "crown", 3,
    "Mug'Thol and his ogres had been sent to Alterac for the Crown of Will, on Lady Sylvanas's behalf. Instead he put it on, and it let him resist the possession that bound him to her.",
    "Sharlindra said the Dark Lady wanted an example made of Mug'Thol. Her lieutenant Melisara waited in Tarren Mill.",
    "Melisara wasted no time on chatter. Mug'Thol was an irritant, she said, and would be dealt with quickly.",
    "Melisara of Tarren Mill took up the matter of Mug'Thol and promised a thorough end to him.", true)
q(518, "The Crown of Will", "Hillsbrad Foothills", 39, "crown", 3,
    "Mug'Thol's Crushridge ogres had overrun the ruins of Alterac. Melisara, Sharlindra's lieutenant in Tarren Mill, wanted their numbers thinned before any punishment fell on him.",
    "In Tarren Mill, Melisara's plan against Mug'Thol began by softening up the Crushridge in the Ruins of Alterac.",
    "The snow ran red with ogre blood, but Melisara wanted the Crushridge's spirit crushed along with their numbers.",
    "The Crushridge lost many ogres, and Melisara meant to keep pressing them.", true)
q(519, "The Crown of Will", "Hillsbrad Foothills", 41, "crown", 3,
    "Targ, Muckrake and Glommus were Mug'Thol's lieutenants and loyal to him. Melisara wanted their heads before the ogre lord's own.",
    "Melisara of Tarren Mill asked for the heads of Mug'Thol's three lieutenants. Only then would she send anyone after the ogre who had stolen the Crown of Will.",
    "Three heads reached Melisara, who planned to mount them on pikes above Alterac, with Mug'Thol's to join them.",
    "Targ, Muckrake and Glommus were dead, and only Mug'Thol remained.", true)
q(520, "The Crown of Will", "Hillsbrad Foothills", 43, "crown", 4,
    "With his lieutenants dead, Mug'Thol was likely expecting trouble. Melisara wanted his head and the Crown of Will.",
    "Killing Mug'Thol would end the Crushridge resistance. Melisara expected him to be reluctant to give up the crown.",
    "Mug'Thol was dead. Melisara said his head would adorn the highest peak of Alterac's ruins, and the Deathguard would sweep away the rest of the Crushridge.",
    "Mug'Thol's head and the Crown of Will reached Melisara, who called the duty well done.", true)
q(521, "The Crown of Will", "Undercity", 43, "crown", 4,
    "Melisara sent the Crown of Will to Sharlindra in the Undercity, to be passed to Lady Sylvanas. She warned against using it, pointing to Mug'Thol's fate.",
    "Melisara sent the crown that had let an ogre slip the Dark Lady's will to the Undercity, with a warning attached.",
    "Sharlindra found it strange that so simple a relic held such power. She promised to take it to Lady Sylvanas and tell her who had brought it.",
    "The Crown of Will reached Sharlindra, who would deliver it to Lady Sylvanas.", true)
fallback("The Crown of Will", "Hillsbrad Foothills", "crown", "495,518,519,520,521",
    "Mug'Thol had used the Crown of Will to resist Lady Sylvanas, and the Forsaken wanted an example made.",
    "Melisara in Tarren Mill led the Forsaken effort against Mug'Thol and his Crushridge ogres.",
    "The Forsaken campaign against Mug'Thol moved forward.",
    "Melisara's work against the Crushridge went on.")
hl(520, "Mug'Thol was killed and the Crown of Will taken from him. Melisara meant to set his head on the highest peak of Alterac.",
    "Mug'Thol died in the ruins of Alterac, and his head and crown went to Melisara.")
hl(521, "Sharlindra received the Crown of Will for Lady Sylvanas. She marveled that so simple a relic had let an ogre defy the Dark Lady.",
    "Sharlindra in the Undercity took the Crown of Will, bound for the Dark Lady.")

q(498, "The Rescue", "Hillsbrad Foothills", 22, "perenolde", 3,
    "Thrall had sent Krusk and other warriors to Durnholde to recover an object and look into the Syndicate. Humans overwhelmed them there, and Drull and Tog'thar were still held in the keep.",
    "Krusk had escaped the ambush at Durnholde. Two of his warriors, Drull and Tog'thar, were still prisoners across the river.",
    "Drull and Tog'thar were free. Krusk learned that the humans had meant to make slaves of them, and that Gol'dir, their leader, had been taken elsewhere.",
    "The two captives were rescued from Durnholde. Gol'dir was still missing, and Krusk had no lead yet.")
q(533, "Infiltration", "Hillsbrad Foothills", 34, "perenolde", 3,
    "Rumor at last pointed to Gol'dir's whereabouts. Humans had been moving the captured orc leader, and Krusk turned to the large Syndicate camp north of Tarren Mill.",
    "In Tarren Mill, Krusk wanted any papers the Syndicate camp to the north could give up. Gol'dir, his captured leader, was worse off by the day.",
    "The papers showed where Gol'dir was held. Krusk hoped the Syndicate would be less prepared this time.",
    "The documents from the camp gave Krusk the place where Gol'dir was held.")
q(503, "Gol'dir", "Alterac Mountains", 36, "perenolde", 4,
    "Krusk read the documents and placed Gol'dir in a large Syndicate base in the Alterac Mountains. He had been a captive far too long.",
    "Gol'dir, the captured leader of Krusk's expedition, was locked in the Syndicate town of Strahnbrad. The key to his cell was in a jailor's keeping.",
    "Gol'dir took the key and undid the lock himself. He had led the expedition from Durotar, and the Syndicate had made him haul and dig while he was held.",
    "Gol'dir was freed in Strahnbrad. He brushed off his suffering and said he had news for whoever now led his warriors.")
q(506, "Blackmoore's Legacy", "Hillsbrad Foothills", 36, "perenolde", 4,
    "Aliden Perenolde, the Syndicate's leader, had visited Gol'dir and boasted of enslaving the orcs who opposed him, as his father and Blackmoore had planned. His mistress Elysa wore the pendant the Warchief wanted.",
    "Gol'dir had news for Krusk. Perenolde wanted orcs in chains again, and the pendant Thrall sought hung around the neck of his mistress, Elysa.",
    "Krusk swore that the orcs would never submit to the humans. Stopping Perenolde became his mission, along with recovering the Warchief's trinket.",
    "The news reached Krusk in Tarren Mill. Perenolde and the pendant were now a single target.")
hl(506, "Gol'dir's news reached Krusk. Aliden Perenolde wanted orcs enslaved as Blackmoore had, and his mistress Elysa wore the Warchief's pendant.",
    "Krusk learned where the Warchief's pendant was, and that Perenolde planned to make slaves of orcs.")

q(536, "Down the Coast", "Hillsbrad Foothills", 30, "farren", 2,
    "Lieutenant Farren Orinelle had been moved from the Stormwind city guard to Southshore and hated the smell of the harbor. Marshal Redpath wanted the murlocs on the Western Strand dealt with, and Farren could barely rouse himself.",
    "Farren spent his days at the Southshore inn calling for ale. He wanted someone to thin the murlocs on the Western Strand in his place.",
    "Farren hoped the dead murlocs would convince Redpath that he had followed orders. He mocked the dreaded menace of overgrown fish.",
    "The Western Strand murlocs were thinned, and Farren could claim that Redpath's orders were carried out.")
q(559, "Farren's Proof", "Hillsbrad Foothills", 32, "farren", 2,
    "Marshal Redpath was not satisfied with Lieutenant Farren Orinelle's word about the murlocs. He wanted their heads as proof.",
    "Lieutenant Farren Orinelle of Southshore needed murloc heads for Marshal Redpath and could not stand to cut them off himself.",
    "The heads dripped on the ground. Farren said he had not eaten fish in weeks, which in Southshore meant hardly eating.",
    "Farren had his murloc heads, though he would not touch them.", true)
q(560, "Farren's Proof", "Hillsbrad Foothills", 32, "farren", 2,
    "Farren would rather not handle the heads. He asked that they be carried to Marshal Redpath for him.",
    "The murloc heads were for Redpath, but Farren wanted nothing more to do with them.",
    "Redpath took the heads and guessed whose errand it was. He thanked the helper, since Southshore needed hard workers to stay safe.",
    "Marshal Redpath received the murloc heads and counted the work toward Southshore's protection.", true)
q(561, "Farren's Proof", "Hillsbrad Foothills", 32, "farren", 2,
    "Redpath had new orders for Lieutenant Orinelle. Lieutenant Farren Orinelle was to turn to the naga on the Eastern Strand and report in person when he had results.",
    "Marshal Redpath sent word back to Farren. The naga on the Eastern Strand were next.",
    "Farren laughed at the orders. Redpath must have heard the same news he had, and Farren swore the marshal would get no promotion from his toil.",
    "Farren heard Redpath's orders about the naga and had plans of his own for them.", true)
fallback("Farren's Proof", "Hillsbrad Foothills", "farren", "559,560,561",
    "Lieutenant Farren Orinelle owed Marshal Redpath proof of his work against Southshore's murlocs.",
    "Farren's proof for Redpath passed through other hands.",
    "Word between Farren and Redpath moved on.",
    "The matter of Farren's proof was settled for the moment.")
q(562, "Stormwind Ho!", "Hillsbrad Foothills", 32, "farren", 3,
    "Lieutenant Farren Orinelle's old mentor in the Stormwind guard wrote that High Command worried about the naga. Proving useful against them might win a transfer, but Farren could not handle naga himself.",
    "Farren Orinelle hated his post in Southshore and saw a way back to Stormwind in the naga threat. He needed someone else to fight them.",
    "With naga dead along the coast, Farren was sure of his reassignment. He longed to see Stormwind again.",
    "The naga near Southshore were put down, and Farren began to dream of Stormwind.")
q(563, "Reassignment", "Stormwind City", 32, "farren", 3,
    "Farren's report went to Major Samuelson, the new captain of the guard, who had been his mentor. He wanted it carried quietly so Redpath would not catch on.",
    "Farren's report on the naga was meant for Major Samuelson in Stormwind, far from Redpath's eyes.",
    "Samuelson was pleased that his pupil had applied himself to the naga. He would weigh the report when he next reviewed assignments.",
    "Major Samuelson read Farren's report and promised to consider it at the next review.")
hl(563, "Farren's report on the naga reached Major Samuelson, who promised to weigh it when he reviewed assignments.",
    "Major Samuelson received his old pupil's report and would consider a transfer the next month.")

q(659, "Hints of a New Plague?", "Arathi Highlands", 33, "goshek", 3,
    "Phin Odelic led a band of adventurers in Southshore. His cousin had put down a dog named Stanley after it grew huge and turned savage, and Phin blamed the undead.",
    "Two of Phin Odelic's companions, Quae and Kinelory, had gone to watch the Go'Shek Farm in Arathi and stopped sending word. Phin wanted them found before he worried any more.",
    "Quae was alive near the farm. She asked for quiet, since the orcs did not take well to spies.",
    "Quae was found watching the Go'Shek Farm. She warned that there was more to the place than it seemed.", true)
q(658, "Hints of a New Plague?", "Arathi Highlands", 36, "goshek", 3,
    "Kinelory had seen a courier leave a small house south of the Go'Shek Farm. Quae thought the courier might carry notes to Tarren Mill.",
    "Quae and Kinelory had watched the farm for days. A courier's papers might explain what was happening in Hillsbrad.",
    "The courier's folder reached Quae, who began to read it.",
    "The courier's papers were in Quae's hands at last.", true)
q(657, "Hints of a New Plague?", "Arathi Highlands", 36, "goshek", 3,
    "The folder showed that Apothecary Jorell was running deadly experiments at Go'Shek. Quae was hurt from a clash with orcs, so Kinelory needed protection to steal the research not yet sent to Tarren Mill.",
    "Quae could not tell what Apothecary Jorell's experiments at the farm had to do with Hillsbrad, but she would not let them go on. Hurt in a clash with orcs, she could not go with Kinelory to the farm.",
    "Kinelory said she would destroy every Forsaken herself if it brought Phin peace. Phin had done much for them since the plague.",
    "Kinelory agreed to go down to the farm and would start when her escort was ready.", true)
q(660, "Hints of a New Plague?", "Arathi Highlands", 37, "goshek", 4,
    "Kinelory, one of Phin Odelic's companions, was ready to go down to the Go'Shek Farm for Apothecary Jorell's research.",
    "The raid on the farm depended on keeping Kinelory alive on the way down and back.",
    "Back from the farm with its items, Kinelory was safe. Quae gave thanks and said Kin was friendly, but deadly to her enemies.",
    "Quae was grateful when Kinelory returned from the farm.", true)
q(661, "Hints of a New Plague?", "Hillsbrad Foothills", 37, "goshek", 4,
    "Kinelory's items from the farm might show Phin what the Forsaken were doing in Arathi. Quae and Kinelory stayed near the farm in case of reprisal.",
    "Quae sent news of the raid back to Phin Odelic in Southshore.",
    "Phin was glad to hear his two friends were alive. He gave his group's thanks and hoped to learn what the Forsaken were planning.",
    "Phin Odelic learned that Quae and Kinelory were safe, and rewarded the news.", true)
fallback("Hints of a New Plague?", "Arathi Highlands", "goshek", "657,658,659,660,661",
    "Phin Odelic's companions were watching the Go'Shek Farm for signs of a Forsaken plague.",
    "Phin Odelic suspected the Forsaken of strange work around Hillsbrad and Arathi.",
    "The watch on the Go'Shek Farm moved forward.",
    "Phin Odelic's investigation went on.")
hl(661, "Phin Odelic heard that Quae and Kinelory were alive, with items from Jorell's farm. He hoped to learn what the Forsaken were up to.",
    "Word of the Go'Shek raid reached Phin in Southshore, and he thanked the whole group.")
for _, id in ipairs({496, 499, 501, 502, 509, 513, 515, 517, 524, 495, 518, 519, 520, 521, 536, 559, 560, 561, 562, 563, 659, 658, 657, 660, 661}) do src(id) end
src(498, "LoreForever npc:krusk (wiki: Krusk)")
src(533, "LoreForever npc:krusk (wiki: Krusk)")
src(503, "LoreForever quest:503 (wiki: Gol'dir (quest)): Strahnbrad, the jailor's key")
src(506, "LoreForever quest:506 (wiki: Blackmoore's Legacy)")
src(499, "LoreForever npc:umpi (wiki: Umpi)")

-- Batch W2-2: Southshore and Tarren Mill around Alterac. The Syndicate papers
-- and Maleb's enemies (the decrypted letter's return is 525, above), Valik,
-- Darthalia's bounties, Helcular's apprentice, Voidglare's study of Dalaran's
-- elementals, Redpath's ogre bounties, and the hand-offs 634, 647 and 5321,
-- which join the alliance pack's threads verbatim (keys and labels).
P.threads.world_tarrenmill = "the Deathguard of Tarren Mill"
P.threads.world_helcular = "Helcular's revenge on Southshore"
-- 556/557 join the existing world_dalaran thread (544/545, Magus Wordeen).
P.threads.world_bisque = "the turtle bisque of the foothills"
P.threads.world_southshore = "the troubles of Southshore"
P.threads.world_hammerfall = "the defense of Hammerfall"
P.threads.alliance_dunmodr = "the fighting around Dun Modr"
P.threads.alliance_darkshore = "Darkshore's settlements"
q(510, "Foreboding Plans", "Hillsbrad Foothills", 34, "syndicate", 3,
    "Syndicate papers in Alterac listed supplies that were needed soon. Beside food and weapons they asked for masks, oil and poison, for an important mission against Southshore.",
    "A Syndicate supply list spoke of an urgent mission against Southshore. Magistrate Henry Maleb needed to see it.",
    "Maleb read the documents and judged that the Syndicate had waged war on Southshore.",
    "The supply list reached Magistrate Maleb, who now assumed the Syndicate meant war on his town.")
q(511, "Encrypted Letter", "Hillsbrad Foothills", 34, "syndicate", 3,
    "Among the Syndicate's papers in Alterac was a letter in a code no one could read. Loremaster Dibbs in Southshore might make sense of it.",
    "One letter on a Syndicate table was encrypted and inscrutable. It went to Loremaster Dibbs in Southshore.",
    "Dibbs had never seen this form of encryption, and admitted his knowledge of codes was far from complete.",
    "Dibbs studied the letter closely and could not read it.", true)
-- 511 shares its title with the Northshire rogue's letter (3102), so the title
-- context names neither Alterac nor a class.
P.quests["Encrypted Letter"] = {zone = false, thread = false, importance = 2,
    why = {"A sealed letter needed a reader who could make sense of it.", "The letter's seal and writing pointed to someone who could explain it."},
    after = {"The letter was handed to someone who could judge it.", "The sealed letter changed hands."},
    source = {"corpus_vanilla_quests.txt quests 511,3102"}}
q(514, "Letter to Stormpike", "Ironforge", 34, "syndicate", 3,
    "Dibbs had a colleague in Ironforge who might break the Syndicate's code. Prospector Stormpike studied in the library of the Hall of Explorers.",
    "If anyone north of Blackrock Spire could read the encrypted letter, Loremaster Dibbs said, it was Prospector Stormpike in Ironforge.",
    "Stormpike asked after the old bookworm in Southshore, then took the letter. Encryption, he said, was a specialty of his.",
    "Stormpike welcomed the encrypted letter and set to work on it.")
q(551, "The Ensorcelled Parchment", "Hillsbrad Foothills", 40, "syndicate", 3,
    "A spell hid the writing on a parchment found in Alterac. Only one word at its top could be read, Nagaz.",
    "The parchment carried a spell that made it indecipherable, except for the name Nagaz. Loremaster Dibbs in Southshore was the nearest scholar.",
    "Dibbs sighed at more encrypted notes from Alterac. He wished he could decipher them, but lacked the knowledge.",
    "Dibbs could not read the ensorcelled parchment.")
q(554, "Stormpike's Deciphering", "Ironforge", 40, "syndicate", 3,
    "Dibbs sent the parchment to Prospector Stormpike in Ironforge, whom he called a master of decryption. He had been sending Stormpike a lot of business lately.",
    "Only Prospector Stormpike, at the Prospectors' headquarters in Ironforge, had a chance of reading the spell-bound parchment.",
    "Stormpike found an intricate spell woven through the parchment. Untangling it would take time, so he bought it and promised to send word if its contents proved interesting.",
    "Prospector Stormpike purchased the parchment to study at his leisure, and promised to send for its finder.")
q(522, "Assassin's Contract", "Hillsbrad Foothills", 38, "syndicate", 3,
    "A contract for the murder of Magistrate Henry Maleb had been sealed in red wax with a distinctive signet ring.",
    "A shadowy assassin carried a contract with Magistrate Maleb's name on it. Its seal bore the mark of a signet ring.",
    "Maleb read the contract and understood the latest attack on Southshore. The Syndicate was after him, as it had been after the last magistrate.",
    "The contract reached Maleb, who saw that the Syndicate meant to kill him as it had meant to kill his predecessor.")
q(523, "Baron's Demise", "Alterac Mountains", 40, "syndicate", 4,
    "The contract was signed by Baron Vardus, a noble of old Alterac known for a cold heart and brutal ways. Maleb wanted him found among the Syndicate's haunts, at Strahnbrad or in the valley beyond.",
    "Magistrate Maleb wanted Baron Vardus brought to justice for sending his thugs against Southshore. The baron hid in the Syndicate's haunts north of the town.",
    "Baron Vardus was dead. Maleb said his head rested easier knowing the villain had lost his.",
    "Vardus's head reached Magistrate Maleb, who could rest a little easier.")
hl(523, "Baron Vardus, who had signed the contract on Maleb's life, was killed. The magistrate said his own head rested easier.",
    "Vardus was dead, and Southshore's magistrate could rest a little easier.")
q(535, "Valik", "Alterac Mountains", 34, "syndicate", 2,
    "Henchman Valik lay dying in a Syndicate camp. Sure of being killed anyway, Valik offered answers in exchange for a mug of Southshore stout.",
    "The wounded Syndicate henchman Valik wanted one last drink. A mug of Southshore stout would buy Valik's answers.",
    "Valik called the stout the sweetest thing ever tasted, handed over something of no use to the dead, and said to get on with it.",
    "Valik drank the Southshore stout and gave away a last possession, sure that death was near.")
q(566, "WANTED: Baron Vardus", "Alterac Mountains", 40, "syndicate", 4,
    "High Executor Darthalia had posted a bounty on Baron Vardus, a high-ranking Syndicate member wanted for crimes against the Forsaken. He had last been seen in the Uplands north of Tarren Mill.",
    "A Forsaken wanted poster named Baron Vardus of the Syndicate, wanted dead. Proof of his death would go to Darthalia.",
    "Darthalia paid the bounty. With Vardus dead, she said, the Syndicate's leaders grew fewer and their resistance would not last.",
    "Baron Vardus was dead, and Darthalia counted one less Syndicate leader.")

q(546, "Souvenirs of Death", "Hillsbrad Foothills", 25, "tarrenmill", 2,
    "Deathguard Samsa envied anyone sent to fight the humans of Hillsbrad while the Deathguard stood guard in Tarren Mill. Human skulls were Samsa's collection, and thirty would do.",
    "Stuck on guard duty in Tarren Mill, Deathguard Samsa asked for human skulls from the long fighting in Hillsbrad.",
    "Samsa called the skulls precious and beautiful, and paid as promised.",
    "Thirty human skulls reached Deathguard Samsa, who was delighted.")
q(547, "Humbert's Sword", "Hillsbrad Foothills", 30, "tarrenmill", 2,
    "Darthalia had sent Deathguard Humbert to watch Dun Garok from a distance. While Humbert gathered firewood, dwarven scouts made off with the gear.",
    "A dwarf of Dun Garok had stolen Deathguard Humbert's sword. If Darthalia learned of it, Humbert feared being hanged from the rafters.",
    "Humbert had the sword back and said it felt like being complete again.",
    "The stolen sword was returned to Deathguard Humbert, who was very grateful.")
q(567, "Dangerous!", "Hillsbrad Foothills", 28, "tarrenmill", 3,
    "Darthalia's notice named four Hillsbrad humans for bounty. Clerk Horrace Whitesteed, Citizen Wilkes and Miner Hackett were wanted for killing Forsaken, and Farmer Kalaba for ambushing supplies from the Undercity.",
    "Four humans of Hillsbrad had been marked as dangerous by High Executor Darthalia. All of them were hiding and hard to find.",
    "Darthalia called the work that of a true bounty hunter.",
    "The four wanted humans were dead, and the bounty was paid in Tarren Mill.")
q(552, "Helcular's Revenge", "Hillsbrad Foothills", 33, "helcular", 3,
    "Helcular had nearly become a lich when a human mob found his ritual lair, killed him and buried him in Southshore's cemetery. Novice Thaivand, his apprentice, wanted vengeance, and first needed his rod back from the yeti who had taken the lair.",
    "Novice Thaivand meant to bring vengeance on Southshore for the death of Helcular, a wizard the town's people had killed. The rod at the heart of the plan was with the yeti.",
    "Helcular's rod was recovered from the yeti, and Thaivand was delighted.",
    "Thaivand had the Rod of Helcular back.", true)
q(553, "Helcular's Revenge", "Hillsbrad Foothills", 33, "helcular", 4,
    "Helcular had built three pyres for his greatest spell. Charged at the flames of Azel and Veraz in the Foothill Caverns and Uzel in a cave above, the rod was to be driven into his grave in Southshore.",
    "Thaivand handed over Helcular's rod with instructions. Three flames would charge it, and Helcular's grave in guarded Southshore would receive it.",
    "The charged rod went into Helcular's grave, and a great rumbling rose from the ground.",
    "Helcular's grave took the rod, and the earth of the Southshore cemetery rumbled.", true)
fallback("Helcular's Revenge", "Hillsbrad Foothills", "helcular", "552,553",
    "Novice Thaivand sought revenge on Southshore for the death of Helcular, the novice's master.",
    "Helcular's apprentice planned a ritual against the town that had killed the wizard.",
    "Thaivand's plan for Helcular's revenge moved forward.",
    "Another part of the apprentice's ritual was done.")
hl(553, "Helcular's grave in Southshore took the Rod of Helcular, charged at three flames, and the ground rumbled.",
    "Helcular's grave took the charged rod, and the Southshore cemetery shook.")
q(556, "Stone Tokens", "Hillsbrad Foothills", 32, "dalaran", 2,
    "Dalaran's wizards used magical tokens to control elementals. Keeper Bel'varil wanted some for Magus Wordeen Voidglare to study, and named the internment camp as safer than Dalaran itself.",
    "Magus Wordeen Voidglare of Tarren Mill wanted to learn how Dalaran's wizards commanded elementals. Their stone tokens were the place to start.",
    "The tokens' magic had faded. Bel'varil thought that suited the Magus's first experiments.",
    "Worn stone tokens from Dalaran's lands reached Keeper Bel'varil for the Magus.")
q(557, "Bracers of Binding", "Hillsbrad Foothills", 34, "dalaran", 3,
    "Bracers of binding were set on the wrists of elementals to hold them in a mage's service. Keeper Bel'varil knew Magus Wordeen would want examples from the ruins of Dalaran.",
    "Dalaran's stone tokens had a counterpart, bracers worn by the elementals themselves. Keeper Bel'varil wanted some for Magus Wordeen.",
    "Bel'varil asked whether the elementals had been amenable, then admitted that death had robbed the Keeper of comic timing. The work served the Magus and the Dark Lady.",
    "Bracers of Earth Binding reached Keeper Bel'varil, who gave thanks on the Magus's behalf.")
q(555, "Soothing Turtle Bisque", "Hillsbrad Foothills", 31, "bisque", 2,
    "Chef Jessen claimed Southshore had the best cooking north of Stormwind. His turtle bisque needed snapjaw meat from Lake Lordamere and soothing spices, but the lake had grown too dangerous for him.",
    "Folk came from as far as Darkshire for Chef Jessen's turtle bisque, he said. He had not made any lately for want of snapjaw meat.",
    "Jessen's Soothing Turtle Bisque was served in Southshore once again.",
    "The meat and spices reached Chef Jessen, who could cook his famous bisque again.", true)
q(7321, "Soothing Turtle Bisque", "Hillsbrad Foothills", 31, "bisque", 2,
    "Christoph Jeffcoat of Tarren Mill joked that folk would come back from the dead for his turtle bisque. His work kept him from hunting snapjaws at Lake Lordamere.",
    "Christoph Jeffcoat meant to show that the undead could cook. He needed snapjaw meat and soothing spices for his bisque.",
    "Jeffcoat said his bisque would keep a body warm on a cold night, for anyone who cared about such things.",
    "Turtle meat and spices reached Christoph Jeffcoat, and the bisque could be made.", true)
fallback("Soothing Turtle Bisque", "Hillsbrad Foothills", "bisque", "555,7321",
    "A cook in the foothills needed snapjaw meat from Lake Lordamere and soothing spices for turtle bisque.",
    "Turtle bisque was a favorite in the foothills, and the snapjaws of Lake Lordamere were hard to reach.",
    "The cook had the ingredients for turtle bisque.",
    "The turtle meat and spices were delivered.")
q(564, "Costly Menace", "Hillsbrad Foothills", 34, "southshore", 2,
    "Darren Malvew of Southshore had lost horses to the undead, the Syndicate and other scoundrels. Worst of all were the mountain lions that came down from Alterac.",
    "Southshore's horses kept falling to mountain lions from the hills. Darren Malvew dared any would-be hero to do something about it.",
    "The news delighted Darren, who wished a war hero had turned up from day one to deal with the beasts.",
    "The Alterac lions were thinned, and Darren Malvew's horses were safer.")
q(500, "Crushridge Bounty", "Alterac Mountains", 36, "southshore", 3,
    "Crushridge ogres had dug a mound near ruined Alterac and taken the ruins. Marshal Redpath of Southshore feared they would move into the foothills next.",
    "Marshal Redpath offered a bounty on the Crushridge ogres of Alterac, paid for their dirty knucklebones.",
    "Redpath reckoned a whole mess of ogres had died for those knucklebones. It would keep the Crushridge back, at least for a while.",
    "The knucklebones earned Redpath's bounty and some respite from the ogres.")
q(504, "Crushridge Warmongers", "Alterac Mountains", 40, "southshore", 3,
    "Redpath wanted the Crushridge warmongers in the Ruins of Alterac cut down. Only that, he said, would teach the brutes to keep away from Alliance land.",
    "Marshal Redpath of Southshore wanted the Crushridge's noses bloodied in the ruins of Alterac.",
    "Redpath paid the reward and guessed that the old city was in a sorry state under the ogres. The fighting would help keep them away from Southshore.",
    "The warmongers were cut down, and Redpath expected the ogres to keep their distance from Southshore.")
q(676, "The Hammer May Fall", "Arathi Highlands", 32, "hammerfall", 3,
    "Tallow in Tarren Mill said Hammerfall was under attack and would fall without help. First he wanted the Boulderfist ogres northeast of Stromgarde faced as a test.",
    "Hammerfall in Arathi needed soldiers, but Tallow sent recruits to a Boulderfist ogre mound before Drum Fel would see them.",
    "Drum Fel wondered whether Tallow had hoped the newcomer would die at the mound. Either way, Hammerfall needed soldiers, and there was no shortage of fighting.",
    "Drum Fel took on another soldier for Hammerfall against the constant attacks.")

q(634, "Plea To The Alliance", "Arathi Highlands", 31, "dunmodr", 3,
    "Dun Modr's defenders still waited for reserves from Ironforge. Rhag Garmason asked Captain Nials at Refuge Pointe whether the Alliance could spare soldiers to retake Dun Modr and the Thandol Span.",
    "Rhag Garmason had heard of an Alliance camp at Refuge Pointe in Arathi. He sent a plea to its leader, Captain Nials, for soldiers.",
    "Nials grieved for Longbraid's soldiers, but Stromgarde had fallen too. Refuge Pointe would not leave the Highlands until Stromgarde was retaken, so Longbraid would be on his own.",
    "Captain Nials could spare no one, and would send word to Longbraid that Dun Modr stood alone.")
hl(634, "Captain Nials at Refuge Pointe could spare no soldiers for Dun Modr. Stromgarde had fallen, and his people would not leave Arathi until it was retaken.",
    "Refuge Pointe turned down Rhag Garmason's plea, and Longbraid was left on his own.")
q(647, "MacKreel's Moonshine", "Hillsbrad Foothills", 30, "dunmodr", 2,
    "Foggy MacKreel had passed out on watch near Dun Modr after too much moonshine. He owed Brewmeister Bilger in Southshore a batch, and it was nearly overdue.",
    "Foggy MacKreel feared Longbraid would have his head for sleeping on watch. His debt to Brewmeister Bilger in Southshore came due within a quarter hour.",
    "Bilger had expected the little debtor to be late again. He welcomed the moonshine to warm a brisk day.",
    "Foggy's moonshine reached Brewmeister Bilger in Southshore in time, and Bilger was pleased.")
q(5321, "The Sleeper Has Awakened", "Ashenvale", 20, "darkshore", 3,
    "Kerlonian Evershade, a druid of the Claw newly woken from the Emerald Dream, kept falling asleep on his way to Maestra's Post. His Horn of Awakening could rouse him.",
    "Kerlonian Evershade had stopped in Darkshore for a nap on his way to meet Liladris Moonriver. Sleep kept overtaking him, and the road south was long.",
    "Kerlonian reached Maestra's Post. Liladris Moonriver was glad he had made it, and expected to find him asleep somewhere nearby.",
    "Kerlonian was shown the way to Maestra's Post, and Liladris Moonriver gave thanks.")
for _, id in ipairs({510, 511, 514, 551, 554, 522, 523, 535, 566, 546, 547, 567, 552, 553, 556, 557, 555, 7321, 564, 500, 504, 676}) do src(id) end
for _, id in ipairs({634, 647}) do
    src(id, "LoreAllianceStories.lua thread alliance_dunmodr (Wetlands stages 472, 631-633); hand-off 2026-11-05")
    P.questIDs[id].thread = "alliance_dunmodr"
    P.questIDs[id].threadLabel = P.threads.alliance_dunmodr
end
src(5321, "LoreForever quest:5321 and npc:kerlonian-evershade (wiki: The Sleeper Has Awakened); thread alliance_darkshore; hand-off 2026-11-05")
P.questIDs[5321].thread = "alliance_darkshore"
P.questIDs[5321].threadLabel = P.threads.alliance_darkshore
src(553, "LoreForever quest:553 (wiki: Helcular's Revenge (2))")
src(556, "LoreForever quest:556 (wiki: Stone Tokens)")
src(676, "LoreForever quest:676 (wiki: The Hammer May Fall)")

-- Batch W2-3: Desolace. The Corrupter (Maurin and Takata at Ghost Walker Post),
-- the war among the centaur clans and its khans for Gelkis, Magram, Horde and
-- Alliance, Vahlarriel's search for the Malems, and the Karnitol shipwreck.
-- Tyranis's fate is told only by 1439; Azrethoc's death only by 1488.
P.threads.world_malem = "the missing Malems of Darnassus"
P.threads.world_reclaimers = "the Reclaimers' salvage in Desolace"
q(1480, "The Corrupter", "Desolace", 33, "burningblade", 3,
    "A flayed demon skin was marked in red with some strange script, and a symbol at its bottom looked like a signature. Maurin Bonesplitter at Ghost Walker Post might read it.",
    "The rotten, pliable skin carried red markings and what seemed a signature. Maurin Bonesplitter, the Forsaken scholar who watched the Burning Blade, was the one to ask.",
    "The runes were an old language, Maurin said, remotely like Eredun. It was a contract signed by a demon named Lord Azrethoc.",
    "The skin was a demonic contract, Maurin said, bearing the signature of Lord Azrethoc.", true)
q(1481, "The Corrupter", "Desolace", 33, "burningblade", 3,
    "Maurin believed he could scry for Lord Azrethoc with the right reagents. Breaking the demon's wards against scrying came first, and that needed the scalp of a Hatefury shadowstalker.",
    "Breaking a demon lord's wards was dangerous work. Maurin needed a scalp from a Hatefury shadowstalker in the northeastern ruins, and warned that the wrong one could kill them both.",
    "That the shadowstalkers had failed impressed Maurin. The scalp would serve, and he had gathered most of the other reagents himself.",
    "The Hatefury scalp reached Maurin, who now needed only a focus for his spell.", true)
q(1482, "The Corrupter", "Desolace", 35, "burningblade", 3,
    "Maurin's spell needed an oracle crystal, crafted by the naga for their oracles. Slitherblade naga kept them on the coral reef northwest of Ghost Walker Post.",
    "An oracle crystal from the Slitherblade naga would focus Maurin's scrying. He saw great favor with the Warchief in finding Azrethoc.",
    "Maurin called the crystal flawless and began the scrying at once, to learn what the demon was and where he could be found.",
    "The oracle crystal reached Maurin, and the spell to find Lord Azrethoc began.", true)
q(1484, "The Corrupter", "Desolace", 33, "burningblade", 3,
    "Azrethoc proved more dangerous than Maurin had expected. Maurin worried that Takata Steelblade would doubt him, and wanted the swordsman told without being pressed.",
    "The scrying had shown a demon lord too strong for Maurin alone. It had to reach Takata Steelblade, who led the Horde's fight against the Burning Blade.",
    "Takata had watched the demon's apparition and judged it stronger than Maurin. His duties kept him at Ghost Walker Post, so he could not hunt it himself.",
    "Takata Steelblade doubted Maurin could defeat Azrethoc, and was bound by his duties to stay.", true)
q(1488, "The Corrupter", "Desolace", 40, "burningblade", 5,
    "Takata agreed that Lord Azrethoc had to be stopped, above all if he sought influence over the Burning Blade. He trusted a party to kill the demon lord and his warlock servant to the south.",
    "Before the demon could bend the Burning Blade to his goals, Takata Steelblade wanted Azrethoc and his warlock servant dead.",
    "Takata called it a mighty victory. The Burning Blade would fail, he said, and one day his people might have a safe home again.",
    "Lord Azrethoc was dead, and Takata's hope for the Horde in Desolace returned.", true)
fallback("The Corrupter", "Desolace", "burningblade", "1480,1481,1482,1484,1488",
    "A demon's contract found in Desolace worried the Horde at Ghost Walker Post.",
    "Maurin Bonesplitter and Takata Steelblade sought the demon behind a Burning Blade contract.",
    "The hunt for the demon behind the Burning Blade moved forward.",
    "Another step against the Corrupter was taken.")
hl(1488, "Lord Azrethoc and his warlock servant were killed. Takata Steelblade called it a mighty victory and began to hope for a safe home.",
    "Takata Steelblade rejoiced that the demon lord Azrethoc was dead.")

q(1437, "Vahlarriel's Search", "Desolace", 33, "malem", 3,
    "Vahlarriel Demonslayer had come from Darnassus to find two missing nobles of House Malem, Tyranis and Dalinda. Their father feared the worst, and they had last been seen passing through Stonetalon.",
    "The Malem children had vanished somewhere in Desolace. Vahlarriel Demonslayer, at Nijel's Point, asked for word if their wagon was found.",
    "The Malems' wagon had been attacked with spells and weapons. There was no blood and no bodies, only the signs of a quick, one-sided fight.",
    "The wagon was found, wrecked by a swift and efficient attack, with no sign of the Malems.", true)
q(1465, "Vahlarriel's Search", "Desolace", 33, "malem", 3,
    "In the wagon lay a pendant, and footprints led south toward a fort where smoke rose from a kept fire. The Malems might have been taken there alive.",
    "The wreck held a pendant and tracks heading south. Word of them had to reach Vahlarriel at Nijel's Point.",
    "Vahlarriel was furious that the two had come despite warnings. The fort was full of the Burning Blade, orcs devoted to demons, and it was the best lead.",
    "Vahlarriel took the pendant and the news of the tracks, and pointed the search at the Burning Blade's fortress.", true)
q(1438, "Vahlarriel's Search", "Desolace", 33, "malem", 4,
    "Vahlarriel wanted both Malems found, starting at the fortress. Darnassus cared most that Dalinda came home safe, while Tyranis's motives worried Vahlarriel's superiors.",
    "The search for the Malems led into the Burning Blade's fortress. Meanwhile Vahlarriel would tell Darnassus how things stood.",
    "Dalinda Malem was alive in the fortress. The Burning Blade had captured her and Tyranis and meant to sacrifice her, and her brother had lately craved arcane knowledge against her people's wishes.",
    "Dalinda was found a captive of the Burning Blade, afraid for her brother Tyranis.", true)
fallback("Vahlarriel's Search", "Desolace", "malem", "1437,1438,1465",
    "Vahlarriel Demonslayer was searching Desolace for two missing nobles of House Malem.",
    "The Malem children had disappeared on their way through Desolace.",
    "The search for the Malems moved forward.",
    "Vahlarriel's search for the missing nobles went on.")
q(1439, "Search for Tyranis", "Desolace", 33, "malem", 4,
    "The orcs had slaughtered the Malems' guards and servants. Dalinda's brother Tyranis had tried to impress the captors with his arcane knowledge. She would not leave until she knew his fate.",
    "Dalinda Malem feared her brother Tyranis would try to join the Burning Blade. She wanted his fate known before she would think of escape.",
    "Tyranis was dead. Dalinda called it terrible but necessary, since her own people would have done it otherwise, and she was ready to escape.",
    "Dalinda learned her brother's fate. She asked forgiveness if her thanks seemed insincere, and prepared to leave the fortress.")
q(1440, "Return to Vahlarriel", "Desolace", 33, "malem", 4,
    "Dalinda was ready to leave the Burning Blade's fortress. She gave her thanks in advance, in case there was no chance later.",
    "With her brother's fate known, Dalinda Malem wanted out of the fortress and back to Nijel's Point.",
    "Dalinda reached Nijel's Point under her own power. Vahlarriel grieved that only one Malem came back, and said the shame of Tyranis's choices was Dalinda's to bear in Darnassus.",
    "Dalinda Malem came safely back to Nijel's Point, and Vahlarriel gave thanks.")
hl(1440, "Dalinda Malem escaped the Burning Blade's fortress and reached Nijel's Point. Her brother Tyranis did not come home.",
    "Vahlarriel welcomed Dalinda back to Nijel's Point, alone but safe.")

q(1454, "The Karnitol Shipwreck", "Desolace", 39, "reclaimers", 2,
    "Kreldig Ungor of the Reclaimers had a job from Karnitol, a Stormwind mage and noble. Sea giants had attacked Karnitol's ship off northwest Desolace, and he had teleported away and left a valuable chest behind.",
    "Karnitol wanted his abandoned chest found on the Desolace coast and returned to Stormwind. Kreldig Ungor at Nijel's Point took the job for the Reclaimers.",
    "The chest was dry, but its lid had been forced, and burn marks showed its magical traps had long since been sprung.",
    "Karnitol's chest was found broken open, its wards already triggered.", true)
q(1455, "The Karnitol Shipwreck", "Desolace", 39, "reclaimers", 2,
    "Long, deep scratches marked the chest's sides and lid, made by something other than a man or a giant. Inside, it was empty.",
    "Karnitol's chest held nothing. Only strange slashes along its sides hinted at who had opened it.",
    "Kreldig was dismayed that an empty chest would not pay, and wanted to hear more about the slashes.",
    "Back at Nijel's Point, Kreldig heard the chest was empty and grew curious about the claw marks.", true)
q(1456, "The Karnitol Shipwreck", "Desolace", 39, "reclaimers", 3,
    "Kreldig suspected the Slitherblade naga, who lived in sunken elven ruins near Ranazjar Isle. Their tidehunters and sea witches were the likeliest thieves.",
    "The slashes on Karnitol's chest pointed Kreldig Ungor to the naga. Karnitol's belongings might be with the strongest of the Slitherblade.",
    "Kreldig was delighted when Karnitol's belongings turned up among the naga. He said he would rather fight the Horde all his life than face their kind.",
    "The naga gave up Karnitol's belongings, and Kreldig called it a great service to the Reclaimers.", true)
q(1457, "The Karnitol Shipwreck", "Ironforge", 39, "reclaimers", 3,
    "Karnitol's things had to reach Roetten Stonehammer, who ran the Reclaimers from Ironforge and would pay for the work. Kreldig warned that Karnitol was impatient, but generous.",
    "The recovered goods went to Roetten in Ironforge. Kreldig joked that Roetten might ask their finder to join the Reclaimers full time.",
    "Roetten was pleased. The chest was lost, but Karnitol could judge the items himself, and the Reclaimers were paid to find things, not to polish them.",
    "Roetten Stonehammer received Karnitol's belongings and paid for a job well done.", true)
fallback("The Karnitol Shipwreck", "Desolace", "reclaimers", "1454,1455,1456,1457",
    "Karnitol, a Stormwind mage, had abandoned a valuable chest on the Desolace coast.",
    "The Reclaimers had taken the job of recovering Karnitol's lost belongings.",
    "The search for Karnitol's belongings moved forward.",
    "The Reclaimers' salvage job for Karnitol went on.")

q(1384, "Raid on the Kolkar", "Desolace", 32, "centaur", 2,
    "Uthek the Wise mocked the Kolkar's faith in their own magic. Their charms were to be brought back and thrown in the fire.",
    "To show the Kolkar their magic was weak, Uthek wanted them killed and their charms taken.",
    "Uthek said the Kolkar would die, their magic pathetic, and fear would make them weaker. In Gelkis lands, the feeble soon died.",
    "The Kolkar charms reached Uthek, who praised the deed as good for the Gelkis.")
q(1386, "Assault on the Kolkar", "Desolace", 32, "centaur", 2,
    "Warug of the Magram laughed at the Kolkar and killed them. He wanted proof that an outsider could kill Kolkar the same way.",
    "The Magram wanted the Kolkar to the north slain. Warug asked for a show of killing in the Magram manner.",
    "The Kolkar feared their attacker now, Warug said. He hoped there had been laughter, since an enemy should see its weakness.",
    "The Kolkar to the north were slain, and Warug was pleased.")
q(1369, "Broken Tears", "Desolace", 33, "centaur", 2,
    "Warug scorned the Gelkis belief that Theradras, mother of the centaur, protected them. He wanted the crystals in their cave, the tears of Theradras, broken and brought to him.",
    "Warug meant to prove that no one protected the centaur. The Gelkis hoarded crystals they called the tears of Theradras.",
    "Warug crowed that Theradras would not cry when the Magram crushed the Gelkis.",
    "Warug took the broken tears of Theradras and declared the Magram the strongest.")
q(1370, "Stealing Supplies", "Desolace", 35, "centaur", 2,
    "Full bellies fought harder, said Uthek the Wise. Raiding the Magram's stored meat would weaken them between hunts.",
    "Uthek wanted the Magram village's meat stores taken, so the Gelkis could fight longer.",
    "Magram bellies were grumbling, Uthek claimed, loud enough to hear from afar. The meat would let the Gelkis fight for days without rest.",
    "The stolen meat went to the Gelkis, and Uthek called it good work.")
q(1371, "Gizmo for Warug", "Desolace", 35, "centaur", 2,
    "Long ago Warug had killed a gnome with a cart full of strange things. He had kept a waving wooden human from it until he broke it, and wanted another.",
    "Warug of the Magram missed a toy from a dead gnome's cart, a wooden human that waved. He wanted a new one.",
    "Warug had his waving toy again and meant to make it move.",
    "Warug said the new gizmo made him laugh.")
q(1373, "Ongeku", "Desolace", 37, "centaur", 3,
    "Uthek heard from the earth of a red crystal called draenethyst, new to this world, from a place of flying mountains and demons. A shard was held by Ongeku in the Swamp of Sorrows.",
    "Uthek the Wise wanted a shard of draenethyst to strengthen her magic. Ongeku, one of the lost ones, held it in the Swamp of Sorrows.",
    "Uthek felt strong magic in the shard and would use it against the Gelkis' enemies. Soon, she said, the Gelkis might call its bearer a friend.",
    "The draenethyst shard reached Uthek the Wise, who meant to turn its magic on the enemies of the Gelkis.")
q(1374, "Khan Jehn", "Desolace", 37, "centaur", 4,
    "The earth told Uthek the Wise that the Magram were growing weak. She wanted the head of their khan, Jehn.",
    "With the Magram weakened, Uthek of the Gelkis judged it time to kill Khan Jehn.",
    "Uthek said Jehn had trusted his strength and not seen that earth magic was stronger. Without him, the Magram would fall.",
    "Khan Jehn of the Magram was dead, and Uthek foresaw the Gelkis ruling one day.")
q(1375, "Khan Shaka", "Desolace", 37, "centaur", 4,
    "Warug of the Magram wanted the head of Khan Shaka of the Gelkis, so he could stare at it and laugh.",
    "The Magram's friendship called for the death of the Gelkis khan, Shaka.",
    "Khan Shaka was dead. Warug would keep his head on a pike so Shaka could see the strength of the Magram.",
    "Shaka's head reached Warug, who was overjoyed.")
q(1380, "Khan Hratha", "Desolace", 42, "centaur", 4,
    "Uthek turned the Gelkis against the Maraudine. Their khan, Hratha, would answer the war horn atop a bluff in the Valley of Spears, once a mouthpiece was taken from a trusted Maraudine.",
    "Khan Hratha of the Maraudine carried a fragment of a key, and Uthek the Wise wanted it. Blowing the Maraudine war horn would draw him out.",
    "Khan Hratha was dead and the key fragment was Uthek's. She promised the Gelkis would remember the deed when they ruled.",
    "Hratha fell in the Valley of Spears, and his piece of the key went to Uthek the Wise.", true)
q(1381, "Khan Hratha", "Desolace", 42, "centaur", 4,
    "With the Gelkis khan dead, Warug turned on the Maraudine. Their khan, Hratha, would come to the horn in the Valley of Spears, and he held a piece of a key.",
    "Warug of the Magram wanted Khan Hratha's key fragment. Blowing the Maraudine war horn would bring the khan out.",
    "Warug said the Magram were now the strongest centaur and would rule Desolace. Their helper would be spared their hooves.",
    "Khan Hratha was dead, and Warug had his piece of the key.", true)
fallback("Khan Hratha", "Desolace", "centaur", "1380,1381",
    "Khan Hratha led the Maraudine centaur and carried a fragment of a key.",
    "One of the Desolace clans wanted the Maraudine khan dead.",
    "The war among the centaur clans went on.",
    "The fight against the Maraudine moved forward.")
hl(1380, "Khan Hratha answered the Maraudine war horn and was killed. His piece of a key went to Uthek the Wise.",
    "Hratha of the Maraudine was dead, and Uthek promised the Gelkis would remember.")
hl(1381, "Khan Hratha answered the Maraudine war horn and was killed. Warug took his piece of a key and declared the Magram the strongest clan.",
    "Hratha of the Maraudine was dead, and Warug had the key fragment.")
q(1382, "Strange Alliance", "Desolace", 35, "centaur", 3,
    "Captain Pentigast at Nijel's Point saw an advantage in the centaur feuds. Attacks on the Magram might win an alliance with the Gelkis, through Uthek the Wise.",
    "The Gelkis were at war with the Magram. Captain Pentigast hoped Uthek the Wise would treat with those who killed Magram.",
    "Uthek had heard the Gelkis whisper of the Magram blood spilled, and agreed it might be good to talk.",
    "Uthek the Wise allowed talks to begin, now that the Magram had bled.")
q(1385, "Brutal Politics", "Desolace", 35, "centaur", 3,
    "Captain Pentigast feared the victor of the centaur wars would turn on Nijel's Point. An alliance with the Magram, won by fighting the Gelkis, might show how to beat them.",
    "To learn how to beat the centaurs, Captain Pentigast wanted an ally among them. Only Gelkis blood would impress Warug of the Magram.",
    "Warug liked the many Gelkis dead. Maybe, he said, the Magram and the outsider could be friends.",
    "Warug was pleased by the Gelkis dead and opened the way to friendship with the Magram.")
q(1365, "Khan Dez'hepah", "Desolace", 35, "centaur", 4,
    "Felgur Twocuts at Ghost Walker Post was glad the centaur clans fought each other, and wanted them dealt with before they united. The first blow was to kill Khan Dez'hepah of the Kolkar.",
    "Felgur Twocuts wanted the Kolkar clan disrupted. Their leader, Khan Dez'hepah, was in the Kolkar Village to the northeast.",
    "Felgur called it a swift show of strength, the thing centaur understood best. The khan's death would unsettle the Kolkar and give the other clans pause.",
    "Khan Dez'hepah was dead, and Felgur expected the other clans to take note.")
q(1366, "Centaur Bounty", "Desolace", 31, "centaur", 2,
    "Felgur Twocuts wanted the centaur clans bled once they had been frightened. Their ears, from any clan, would earn a bounty.",
    "Felgur Twocuts at Ghost Walker Post paid for centaur ears, to stamp out any thought the clans had of expansion.",
    "The centaur, Felgur was sure, now knew and feared the banner of the Horde.",
    "A hoard of centaur ears reached Felgur, who counted the clans weaker for it.", true)
q(1387, "Centaur Bounty", "Desolace", 31, "centaur", 2,
    "Corporal Melkins at Nijel's Point thought every centaur clan shared one trait, cruelty. Peace, he said, meant removing them, and he paid for their ears.",
    "Corporal Melkins asked for many centaur ears, in service of the Alliance and an end to the war.",
    "Melkins accepted the ears and said the blood spilled in Desolace would save countless lives.",
    "The centaur ears reached Corporal Melkins, who praised the service to the Alliance.", true)
fallback("Centaur Bounty", "Desolace", "centaur", "1366,1387",
    "A bounty in Desolace was paid for centaur ears.",
    "The centaur clans of Desolace threatened the outposts of both factions.",
    "The bounty on the centaur was paid.",
    "Centaur ears were turned in for the bounty.")
for _, id in ipairs({1480, 1481, 1482, 1484, 1488, 1437, 1465, 1438, 1439, 1440, 1454, 1455, 1456, 1457,
    1384, 1386, 1369, 1370, 1371, 1373, 1374, 1375, 1380, 1381, 1382, 1385, 1365, 1366, 1387}) do src(id) end
src(1480, "LoreForever npc:maurin-bonesplitter (wiki: Maurin Bonesplitter): Ghost Walker Post, Forsaken scholar")
src(1484, "LoreForever npc:takata-steelblade (wiki: Takata Steelblade)")
src(1439, "LoreForever quest:1439 (wiki: Search for Tyranis): Thunder Axe Fortress")
src(1365, "LoreForever npc:felgur-twocuts (wiki: Felgur Twocuts): Ghost Walker Post")
src(1457, "LoreForever npc:roetten-stonehammer (wiki: Roetten Stonehammer)")

-- Batch W2-4: Dustwallow. The burned Shady Rest Inn for both factions (Vimes,
-- Reethe and the deserters; Krog, Ogron and Mosarn), the shield's first stages
-- before the existing 1319-1323, the spies around Theramore and Marg Nighteye
-- (whose spirit speaks in 1261, above), the Sterns' bayou recipes, Stinky,
-- Jarl and Mud. Reethe's death is told only by 1273; 1288 has no captured
-- completion text, so its outcome stops at the delivery.
P.threads.world_spies = "the spies around Theramore"
P.threads.world_marg = "the fate of Marg Nighteye"
P.threads.world_stern = "Morgan Stern's bayou recipes"
q(1282, "They Call Him Smiling Jim", "Dustwallow Marsh", 35, "shield", 3,
    "Guard Byron in Theramore pitied the man they called Smiling Jim. He had once run an inn out in the marsh, and Byron would say no more.",
    "Smiling Jim had not always been the way he was. Guard Byron sent questions about him to Captain Vimes.",
    "Vimes named him James Hyal. His Shady Rest Inn at the edge of the Barrens had done well until the ogres took the marsh roads, and he refused to leave. Then the inn was burned to the ground.",
    "Captain Vimes told how the Shady Rest Inn burned, and asked for a search of the rubble.")
q(1284, "Suspicious Hoofprints", "Dustwallow Marsh", 35, "shield", 2,
    "Rows of hoofprints led away from the smoking ruin of the Shady Rest Inn, some almost lost in the soft mud.",
    "The burned inn had left tracks behind it. Hoofprints ran from the ruins into the marsh.",
    "Vimes noted the many centaur camps near the marsh and sent his tracker, Falgran Hastil, to follow the prints.",
    "Captain Vimes heard about the hoofprints and sent Falgran Hastil after them.", true)
q(1268, "Suspicious Hoofprints", "Dustwallow Marsh", 35, "shield", 2,
    "Hoofprints led away from the still-smoking Shady Rest Inn into the soft mud of the marsh.",
    "The burned inn's ruins held tracks. Rows of hoofprints ran off into the marsh.",
    "Krog thought quilboar or centaur might have done it. The innkeeper's family had been killed too, he added, and he sent Kagoro to follow the tracks.",
    "Krog in Brackenwall Village sent Kagoro after the hoofprints, suspecting quilboar or centaur.", true)
fallback("Suspicious Hoofprints", "Dustwallow Marsh", "shield", "1268,1284",
    "Hoofprints led away from the burned Shady Rest Inn.",
    "The ruins of the Shady Rest Inn held tracks worth following.",
    "The hoofprints were reported, and a tracker was sent after them.",
    "Word of the tracks by the burned inn was passed on.")
q(1252, "Lieutenant Paval Reethe", "Dustwallow Marsh", 40, "shield", 3,
    "Under the rubble of the inn lay a Theramore guard badge, a gold anchor on white. The name embossed beneath it was Lieutenant Paval Reethe.",
    "A badge from the burned inn bore Theramore's anchor and the name of Lieutenant Paval Reethe.",
    "Vimes said a guard's badge never brought good news. Sometimes the guard had died, sometimes no one ever learned what happened, and sometimes it was worse.",
    "Captain Vimes took Reethe's badge with foreboding.", true)
q(1259, "Lieutenant Paval Reethe", "Dustwallow Marsh", 40, "shield", 2,
    "Vimes did not know the name Paval Reethe. Adjutant Tesoran kept the Theramore guard's personnel rolls and could look him up.",
    "Adjutant Tesoran kept track of every member of the Theramore guard. Captain Vimes sent the question of Reethe to him.",
    "Tesoran agreed to look up Reethe and went to find the right roll.",
    "Lieutenant Reethe's name went to Tesoran, who began searching his rolls.", true)
q(1269, "Lieutenant Paval Reethe", "Dustwallow Marsh", 37, "shield", 3,
    "Beneath the inn's rubble lay a Theramore guard badge, a gold anchor on white, with the name Lieutenant Paval Reethe.",
    "A badge from the burned inn carried the anchor of Theramore and a lieutenant's name, Paval Reethe.",
    "Krog knew the man. Reethe had deserted his fellow soldiers and was hiding in the woods, suspected of stealing Horde supplies, and Ogron had gone southeast to find him.",
    "Krog called Reethe a pathetic deserter and had already sent Ogron to track him down.", true)
fallback("Lieutenant Paval Reethe", "Dustwallow Marsh", "shield", "1252,1259,1269",
    "A Theramore guard badge found at the burned Shady Rest Inn bore the name of Lieutenant Paval Reethe.",
    "The name Paval Reethe was the clearest clue from the ruined inn.",
    "The question of Paval Reethe was passed along.",
    "Reethe's name entered the inquiry into the burned inn.")
q(1253, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "An iron shield, blackened by the fire, hung on the crumbling chimney of the Shady Rest Inn.",
    "One of the few things still standing at the inn was a chimney, and a burned iron shield was fixed to it.",
    "Vimes knew the use of arms better than their making. To him the shield looked ordinary, apart from the fire damage.",
    "Captain Vimes saw nothing unusual in the shield beyond its burns.", true)
q(1251, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "A fire-blackened iron shield was fixed to the chimney, one of the last parts of the Shady Rest Inn still standing.",
    "On the inn's crumbling chimney hung an iron shield, blackened by the fire.",
    "Krog doubted humans would decorate a fireplace with a plain iron shield. Whoever burned the inn might have left it as a warning, or a threat.",
    "Krog wondered if the burners had placed the shield there on purpose.", true)
q(1276, "The Black Shield", "Thunder Bluff", 37, "shield", 3,
    "At last Krog remembered the name. Mosarn was a respected blacksmith in Thunder Bluff, whose armor the Earthen Ring had once given Krog as thanks.",
    "With nothing useful from Reethe, the shield's maker was the only lead left. Mosarn worked in Thunder Bluff.",
    "The shield was his work, Mosarn confirmed, but he made too many to remember who had bought it.",
    "His own work, the smith agreed, but he could say nothing more about the buyer.", true)
q(1273, "Questioning Reethe", "Dustwallow Marsh", 37, "shield", 4,
    "Ogron had found Reethe, well hidden for a human. Worried the man had gone mad in the swamp, Ogron wanted company to question him.",
    "Paval Reethe was found at last, hiding in the marsh. Ogron set out to get answers from him, with help.",
    "Krog thought it a shame that humans were so frail. Reethe had not survived a little arrow wound, and that thread of the mystery led nowhere.",
    "Reethe died before he could tell much, and Krog turned the search elsewhere.")
q(1285, "Daelin's Men", "Dustwallow Marsh", 38, "shield", 3,
    "Tesoran found the entry. Paval Reethe had joined the Kul Tiras marines at sixteen and come to Theramore with Lady Proudmoore's recruits, and after distinguished service he was listed as missing.",
    "Adjutant Tesoran's rolls showed Reethe as a decorated former marine of Kul Tiras, now missing.",
    "Vimes read missing as traitor. Reethe was one of the men blindly loyal to Admiral Daelin, and Vimes found it ironic that such deserters accused Theramore of betraying the Alliance.",
    "Captain Vimes concluded that Reethe had deserted with the men still loyal to Admiral Daelin.")
q(1286, "The Deserters", "Dustwallow Marsh", 38, "shield", 3,
    "Deserters had squatted in Theramore's abandoned tower at Lost Point, southeast of the inn. Vimes wanted their leader, Jacken, questioned, and warned he would be hard to crack.",
    "Captain Vimes sent questions about Reethe to the deserters' leader, a man named Jacken, at Lost Point.",
    "Balos Jacken guessed that Vimes had sent someone to do his dirty work.",
    "Jacken met the visitor from Theramore with open scorn.", true)
q(1287, "The Deserters", "Dustwallow Marsh", 38, "shield", 3,
    "Jacken called Reethe a coward. The deserters had thrown him out for raiding the ogres' supplies at Brackenwall, a fight they were too few to risk, and Jacken wanted the meeting forgotten.",
    "Balos Jacken gave up what he knew about Reethe, then asked to be left alone.",
    "Vimes would send Lieutenant Caldwell to deal with the deserters at Lost Point and to find Reethe in the marsh.",
    "Captain Vimes heard Jacken's account and ordered Lieutenant Caldwell after both the deserters and Reethe.", true)
fallback("The Deserters", "Dustwallow Marsh", "shield", "1286,1287",
    "Theramore deserters had taken an old watchtower at Lost Point.",
    "The deserters at Lost Point might know something about the burned inn.",
    "The matter of the deserters at Lost Point moved forward.",
    "Captain Vimes's inquiry among the deserters went on.")
q(1288, "Vimes's Report", "Dustwallow Marsh", 38, "shield", 3,
    "Lady Proudmoore had asked Vimes to keep her informed of this delicate matter. He judged that the one who had done the work should report it to her.",
    "Captain Vimes sent his report on the inn, Reethe and the deserters to Lady Jaina Proudmoore.",
    "Vimes's report reached Lady Jaina Proudmoore in Theramore.",
    "Lady Proudmoore received the report on the deserters and the burned inn.")
hl(1287, "Jacken said the deserters had cast Reethe out for raiding the ogres. Vimes sent Lieutenant Caldwell after both the deserters and Reethe.",
    "The deserters at Lost Point gave up Reethe, and Vimes ordered him found.")
hl(1273, "Reethe was found hiding in the marsh, but died of a small arrow wound before he could explain the fire.",
    "Paval Reethe died under questioning, and Krog's search for the inn's burners had to look elsewhere.")

q(1201, "Theramore Spies", "Dustwallow Marsh", 35, "spies", 2,
    "Horde and Alliance held an uneasy truce in the marsh. Nazeer Bloodpike wanted the Theramore infiltrators east of Brackenwall Village slain before they reported more Horde movements.",
    "Alliance spies watched Brackenwall Village from the east. Nazeer Bloodpike wanted them hunted down as a message to Theramore.",
    "The infiltrators were skilled, Nazeer judged, but not good enough to escape the Horde's eye.",
    "The Theramore infiltrators were slain, and Nazeer was satisfied.")
q(1202, "The Theramore Docks", "Dustwallow Marsh", 35, "spies", 3,
    "Two of Nazeer's spies had stolen documents from a ship at Theramore's docks, then thrown them into the sea when caught. Their footlocker lay in the water beneath the docks.",
    "Papers vital to the Alliance lay in a footlocker under Theramore's docks. Nazeer Bloodpike wanted them recovered.",
    "It had been a hard mission, Nazeer said, and his superiors valued the documents greatly.",
    "The sunken documents reached Nazeer Bloodpike, whose superiors prized them.")
q(1219, "The Orc Report", "Dustwallow Marsh", 35, "spies", 2,
    "Loose dirt in the marsh hid a severed orc hand, clutching a bone tube with a parchment in orcish inside.",
    "An orcish document in a dead hand looked important enough to carry to a Theramore officer.",
    "The Theramore lieutenant could barely read orcish, but saw that it was a report written by an orc spy.",
    "A lieutenant of Theramore recognized the parchment as an orc spy's report.")
q(1220, "Captain Vimes", "Dustwallow Marsh", 35, "spies", 2,
    "Captain Vimes knew orcish better than most, and he needed to know there were Horde spies near Theramore.",
    "The orc spy's report went to Captain Vimes in the barracks of Theramore Isle.",
    "Vimes was alarmed by a report from an orc spy and set to reading it.",
    "Vimes took the orc report from the marsh and began to read.")
q(1238, "The Lost Report", "Dustwallow Marsh", 35, "marg", 3,
    "Loose dirt in the marsh hid a severed orc hand clutching a bone tube. Inside was a report from weeks of spying on Theramore, meant for the spymaster at Brackenwall.",
    "A dirt-stained spy's report, found in a dead orc's hand, belonged with Nazeer Bloodpike in Brackenwall Village.",
    "Nazeer named the agent as Marg Nighteye, stationed outside Theramore. This might be his last report, and Nazeer feared he had died in the swamp.",
    "Marg Nighteye's report reached Nazeer, who feared for his agent.")
q(1239, "The Severed Head", "Dustwallow Marsh", 35, "marg", 3,
    "Digging turned up an orc's head, raggedly severed, its lips frozen in a snarl.",
    "The marsh gave up a severed orc head, its eyes still defiant.",
    "Nazeer knew the head as Marg Nighteye's. He could not tell whether a weapon or a beast had made the ragged wound, and wanted to know if the Alliance had killed him.",
    "Marg Nighteye was dead, and Nazeer meant to learn who had killed him.")
q(1240, "The Troll Witchdoctor", "Stranglethorn Vale", 35, "marg", 3,
    "Only troll witch-magic could reveal how Marg died. Nazeer sent his head to Kin'weelay, the most powerful Darkspear witchdoctor, at Grom'gol Base Camp.",
    "Nazeer wanted Marg's spirit questioned. Kin'weelay at Grom'gol in Stranglethorn could speak with the dead.",
    "An angry spirit clung to the head, bound to the world by unfinished work. Kin'weelay prepared to speak with it.",
    "Marg's head reached Kin'weelay, who found the orc's spirit boiling with rage.")
q(1262, "Report to Zor", "Orgrimmar", 40, "marg", 3,
    "Marg had stolen a noble's pendant from common soldiers. Nazeer wanted its owner known and sent it to Zor Lonetree in Orgrimmar, who knew Alliance politics.",
    "A pendant too fine for a soldier needed a scholar of Stormwind's nobles. Nazeer sent it to Zor Lonetree in Orgrimmar.",
    "Zor said no orc would covet such a jewel, but many humans would. He would have the pendant studied.",
    "Zor Lonetree took the pendant for study, hoping its history would come clear in time.")
P.questIDs[1261].thread = "world_marg"
hl(1239, "Nazeer Bloodpike knew the severed head as Marg Nighteye's, and wanted to know whether the Alliance had killed his agent.",
    "Marg Nighteye was found dead in the marsh, and Nazeer meant to learn how.")

q(1260, "Morgan Stern", "Dustwallow Marsh", 38, "stern", 2,
    "Angus Stern was planning a bayou menu for the Blue Recluse in Stormwind. His nephew Morgan had gone to Theramore to gather recipes, and Angus wanted to know what he had found.",
    "Angus Stern of the Blue Recluse wanted news of his nephew Morgan, who was collecting marsh recipes in Theramore.",
    "Morgan had leads on several recipes, but needed help from someone who did not mind wet feet.",
    "Morgan Stern welcomed his uncle's messenger and asked for help with his research.")
q(1258, "... and Bugs", "Dustwallow Marsh", 40, "stern", 2,
    "Morgan's new dish needed pristine shelled legs of a giant crab. Dustwallow's muckshells would not do, so he wanted legs from the crabs of the Swamp of Sorrows.",
    "The presentation of Morgan Stern's dish depended on unscarred crab legs, and only the crabs of the Swamp of Sorrows had them.",
    "Morgan praised the perfect shells and tender meat, and declared that the blood of a chef ran in their collector's veins.",
    "Morgan Stern was delighted with the crab legs from the Swamp of Sorrows.")
q(1222, "Stinky's Escape", "Dustwallow Marsh", 37, "stern", 3,
    "Stinky Ignatz had been sent by Morgan Stern to gather bogbean leaves in the marsh, and found himself surrounded by its creatures.",
    "Morgan Stern's bogbean gatherer, Stinky, was trapped in the marsh and wanted an escort while he searched.",
    "With the leaves delivered, Morgan promised that his uncle would treat Stinky's rescuer to a feast at the Blue Recluse.",
    "Word that Stinky had been helped out of trouble reached Morgan Stern, who gave thanks.", true)
q(1270, "Stinky's Escape", "The Barrens", 37, "dustwallow", 3,
    "Stinky Ignatz had taken a goblin's money to gather bogbean leaves in the marsh for Mebok Mizzyrix of Ratchet, and had got himself surrounded.",
    "A swamp guide named Stinky was surrounded by marsh creatures while hunting bogbean for Mebok Mizzyrix.",
    "Mebok had his herbs from Stinky, who then walked back toward the marsh. Any friend of Stinky's, Mebok said, was a friend of his.",
    "Mebok Mizzyrix in Ratchet had his bogbean, and a gift for Stinky's helper.", true)
P.questIDs[1222].threadLabel = P.threads.world_stern -- the title context below carries another thread
fallback("Stinky's Escape", "Dustwallow Marsh", "dustwallow", "1222,1270",
    "Stinky Ignatz was surrounded in the marsh while hunting bogbean leaves.",
    "A swamp guide called Stinky needed help finding bogbean safely.",
    "Stinky got out of the marsh with the bogbean.",
    "The bogbean leaves reached the one who had hired Stinky.")
q(1203, "Jarl Needs a Blade", "Dustwallow Marsh", 35, "dustwallow", 2,
    "Jarl had cutting to do out in the marsh and would not say what. He wanted a moonsteel broadsword, which he called a swing blade.",
    "Jarl, out in the marsh, needed a certain blade, a moonsteel broadsword, before whatever he was cutting spoiled.",
    "It was a good swing blade, Jarl said, and he gave thanks over and over. He would try it later.",
    "The moonsteel broadsword delighted Jarl, though he put off trying it.")
q(1206, "Jarl Needs Eyes", "Dustwallow Marsh", 35, "dustwallow", 2,
    "Jarl liked eye juice for drinking, and spiders had the most eyes. He wanted unpopped eyes from the spiders of Darkmist Cavern.",
    "Darkmist spider eyes, smooth and salty, were Jarl's idea of a treat.",
    "Jarl said hello to the spider eyes and found they tasted like gooey, salty chicken.",
    "The Darkmist spider eyes thrilled Jarl, who meant to save some for company.")
q(1218, "Soothing Spices", "Dustwallow Marsh", 35, "dustwallow", 2,
    "Jarl liked good swamp cooking, fried frog legs and the like, and wanted soothing spice for his stew.",
    "Swamp stew, by Jarl's account, needed soothing spice.",
    "With the spice in hand, Jarl served out some swampy stew.",
    "The soothing spice went into Jarl's stew, and he shared a bowl.")
q(1177, "Hungry!", "Dustwallow Marsh", 36, "dustwallow", 2,
    "Mudcrush Durtfeet, a big ogre of the marsh, was hungry. He wanted fish brought to him, or he would eat the visitor instead.",
    "Mud the ogre demanded fish for his supper and backed the demand with threats.",
    "The fishy heads pleased Mud, who promised not to eat the one who brought them.",
    "Mudcrush Durtfeet was fed and lost his appetite for visitors.")
for _, id in ipairs({1282, 1284, 1268, 1252, 1259, 1269, 1253, 1251, 1276, 1273, 1285, 1286, 1287,
    1201, 1202, 1219, 1220, 1238, 1239, 1240, 1262, 1260, 1258, 1222, 1270, 1203, 1206, 1218, 1177}) do src(id) end
src(1288, "corpus record has no Completion text: outcome kept to the delivery")
src(1262, "LoreForever npc:zor-lonetree (wiki: Zor Lonetree)")
src(1270, "LoreForever npc:mebok-mizzyrix (wiki: Mebok Mizzyrix)")

-- Batch W2-5: Stranglethorn. The Bloodsail plot against Booty Bay, Cortello's
-- riddle, Mok'thardin's choker and the defense of Grom'gol, and the three
-- masteries of Nesingwary's camp (186 has no captured text and stays out).
-- Each mastery stage claims only its own kill; the title belongs to the last.
P.threads.world_bloodsail = "the Blackwater Raiders' war with the Bloodsail"
P.threads.world_cortello = "Cortello's hidden treasure"
P.threads.world_mokthardin = "Mok'thardin's enchanted choker"
P.threads.world_gromgol = "the defense of Grom'gol"
q(595, "The Bloodsail Buccaneers", "Stranglethorn Vale", 41, "bloodsail", 3,
    "First Mate Crazz of the Blackwater Raiders had heard the Bloodsail Buccaneers were all over southern Stranglethorn. His crew was busy with grog, so he wanted a scout to check the cove north of Booty Bay.",
    "The Blackwater Raiders' rivals, the Bloodsail Buccaneers, had been seen near Booty Bay. Crazz sent a scout up the Savage Coast.",
    "On a barrel at the cove lay a map with hasty writing and a few coins.",
    "A Bloodsail map turned up in the cove north of Booty Bay.", true)
q(597, "The Bloodsail Buccaneers", "Stranglethorn Vale", 41, "bloodsail", 3,
    "The map marked a red X at the cove itself. Its orders told the men to camp there quietly, wait for a signal from the southern command post, and kill anyone who came near.",
    "Bloodsail orders on the map spoke of a hidden camp and an attack awaiting a signal from the south. First Mate Crazz needed to see them.",
    "Crazz remembered his scout and took the map.",
    "Back in Booty Bay, First Mate Crazz received the Bloodsail orders.", true)
q(599, "The Bloodsail Buccaneers", "Stranglethorn Vale", 41, "bloodsail", 3,
    "The Bloodsail meant to attack Booty Bay. Crazz swore the town would always belong to the Blackwater Raiders and sent word to Fleet Master Seahorn.",
    "This was bigger than First Mate Crazz had thought. Fleet Master Seahorn had to hear of the planned attack at once.",
    "Seahorn scoffed that the Bloodsail might as well throw themselves off the Overlook Cliffs, but called the warning a great service to his fleet.",
    "The news of the Bloodsail plot reached Fleet Master Seahorn, who gave the Blackwater Raiders' thanks.", true)
q(604, "The Bloodsail Buccaneers", "Stranglethorn Vale", 43, "bloodsail", 4,
    "Seahorn trusted Crazz's scout with an important mission. The Bloodsail had a southern command post on the Wild Shore, and he wanted its charts and written orders.",
    "Fleet Master Seahorn wanted to know exactly what the Bloodsail were planning. Their charts and orders lay in the camp on the Wild Shore.",
    "With the charts and orders, Seahorn knew the Bloodsail plan. The fools, he noted, had dropped anchor just off the cape.",
    "Seahorn had the Bloodsail charts and now knew their plan of attack.", true)
q(608, "The Bloodsail Buccaneers", "Stranglethorn Vale", 45, "bloodsail", 5,
    "The Bloodsail fleet was led by Firallon, whom Seahorn scorned as a sailor. Rather than send the whole fleet, Seahorn wanted a skilled party to kill the Bloodsail leadership at Firallon's landing spot.",
    "Fleet Master Seahorn meant to strike before the Bloodsail did. A small party would assassinate their leaders where Firallon had come ashore.",
    "Seahorn called it a great day for the Blackwater Raiders and raised three cheers.",
    "The Bloodsail leadership was killed at Firallon's landing spot, and Seahorn rejoiced.", true)
fallback("The Bloodsail Buccaneers", "Stranglethorn Vale", "bloodsail", "595,597,599,604,608",
    "The Bloodsail Buccaneers were plotting against Booty Bay and its Blackwater Raiders.",
    "The Blackwater Raiders needed to know what their Bloodsail rivals were planning.",
    "The Blackwater Raiders learned more of the Bloodsail plot.",
    "The rivalry between the Blackwater Raiders and the Bloodsail went on.")
hl(604, "Fleet Master Seahorn read the Bloodsail charts and orders from the Wild Shore and knew their plan. Their ships lay at anchor off the cape.",
    "Seahorn read the stolen Bloodsail orders and knew where they meant to strike.")
hl(608, "Fleet Master Seahorn called it a great day for the Blackwater Raiders once the Bloodsail leadership was killed at Firallon's landing spot.",
    "Seahorn raised three cheers once the Bloodsail leaders were dead.")

q(624, "Cortello's Riddle", "Swamp of Sorrows", 43, "cortello", 2,
    "A riddle signed by Cortello spoke of an ornate bridge east of Deadwind and south of Redridge. Beneath it, in the Swamp of Sorrows, a clue was waiting.",
    "Cortello's riddle pointed to a well-traveled bridge in the Swamp of Sorrows, and to something hidden underneath.",
    "Under the bridge lay a soggy parchment with the next clue.",
    "A soggy scroll beneath the swamp's bridge carried Cortello's next clue.", true)
q(625, "Cortello's Riddle", "Dustwallow Marsh", 43, "cortello", 2,
    "The soggy scroll sent the search across the sea to Kalimdor. A clue waited in a cave in southwestern Dustwallow Marsh.",
    "Cortello's second clue named Dustwallow Marsh, east of the Barrens, and a cave in its southwest.",
    "In the cave lay a musty scroll.",
    "Inside the Dustwallow cave was a musty scroll.", true)
q(626, "Cortello's Riddle", "The Hinterlands", 51, "cortello", 3,
    "The musty scroll pointed back to Lordaeron. Its treasure lay under the water at the foot of the great falls on the Hinterlands coast.",
    "Cortello's last clue led to the Hinterlands coast, beneath the water at the base of the great falls.",
    "Under the falls lay Cortello's chest, and it was opened at last.",
    "At the end of the riddle was a chest beneath the Hinterlands falls.", true)
fallback("Cortello's Riddle", false, "cortello", "624,625,626",
    "A riddle bearing Cortello's name promised a hidden treasure.",
    "Cortello's riddle led from clue to clue across two continents.",
    "Another of Cortello's clues was found.",
    "The trail of Cortello's riddle went on.")

q(570, "Mok'thardin's Enchantment", "Stranglethorn Vale", 38, "mokthardin", 2,
    "Far Seer Mok'thardin at Grom'gol meant to harness the jungle's magic for the Horde. His enchantment began with Shadowmaw Panther claws and a pristine tigress fang.",
    "Mok'thardin promised a powerful enchanted item. First he needed panther claws and a tigress fang without a flaw.",
    "The claws and fang were perfect. Mok'thardin thanked the spirits for the beasts' sacrifice to the Horde's cause.",
    "Shadowmaw claws and a pristine fang reached the far seer.", true)
q(572, "Mok'thardin's Enchantment", "Stranglethorn Vale", 41, "mokthardin", 2,
    "The feline trinkets were only the start. Mok'thardin next wanted Jungle Stalker feathers, worn on the raptors' armbands south of Grom'gol.",
    "Jungle Stalker raptors near the great arena wore feathers on their armbands. Mok'thardin needed them for his ritual.",
    "Excellent, said Mok'thardin, and he began preparing the feathers at once.",
    "The Jungle Stalker feathers went to Mok'thardin for preparation.", true)
q(571, "Mok'thardin's Enchantment", "Stranglethorn Vale", 41, "mokthardin", 2,
    "To hold the feathers, claws and fang together, Mok'thardin needed a magical tether. Only a perfect aged sinew from an Elder Mistvale Gorilla, east of Booty Bay, would serve.",
    "The far seer's enchantment needed a tether. Mok'thardin asked for an aged gorilla sinew, which only the elder Mistvale gorillas carried.",
    "The sinew was ideal, Mok'thardin said, and the effort would soon pay off.",
    "An aged gorilla sinew reached the far seer, nearly completing his reagents.", true)
q(573, "Mok'thardin's Enchantment", "Stranglethorn Vale", 44, "mokthardin", 4,
    "One reagent remained, water from a Holy Spring high above the western bluffs. Every race claimed the spring as its own, and naga explorers had reached it.",
    "Mok'thardin's last need was Holy Spring Water. Naga had advanced on the spring in the south.",
    "With the Holy Spring Water, Mok'thardin enchanted the ceremonial choker and gave it to be worn in defense of the Horde.",
    "The ceremonial choker was finished, a gift from the far seer for the Warchief's cause.", true)
fallback("Mok'thardin's Enchantment", "Stranglethorn Vale", "mokthardin", "570,571,572,573",
    "Far Seer Mok'thardin at Grom'gol was preparing an enchantment from jungle reagents.",
    "Mok'thardin's enchantment needed parts of Stranglethorn's beasts.",
    "Another reagent for Mok'thardin's enchantment was gathered.",
    "The far seer's enchantment moved closer to completion.")
hl(573, "Mok'thardin finished his enchantment with water from the Holy Spring, and gave the ceremonial choker for the Horde.",
    "Mok'thardin's ceremonial choker was enchanted at last.")
q(568, "The Defense of Grom'gol", "Stranglethorn Vale", 36, "gromgol", 2,
    "Commander Aggro'gosh kept Grom'gol as the Warchief's base camp, supplying Stonard. Raptors outside the camp were hampering the supply effort.",
    "Grom'gol's supply line to Stonard was troubled by the jungle's raptors. Aggro'gosh wanted their numbers thinned.",
    "The commander declared the duty honorably done.",
    "The raptors around Grom'gol were thinned, and the commander was satisfied.", true)
q(569, "The Defense of Grom'gol", "Stranglethorn Vale", 37, "gromgol", 3,
    "The Horde had not come to make war on the jungle's tribes, but ogres in the Mizjah Ruins kept ambushing the supply caravans. Aggro'gosh wanted them driven out.",
    "Despite warnings, ogres from the Mizjah Ruins still raided Grom'gol's caravans. Commander Aggro'gosh wanted a firm message sent.",
    "The work had served the Warchief with honor, said Aggro'gosh.",
    "The Mizjah ogres were driven back, and Grom'gol's caravans had some respite.", true)
fallback("The Defense of Grom'gol", "Stranglethorn Vale", "gromgol", "568,569",
    "Commander Aggro'gosh was protecting Grom'gol's supply line to Stonard.",
    "Grom'gol's caravans faced threats from the jungle.",
    "Grom'gol's defenses were strengthened.",
    "Aggro'gosh's work protecting the base camp went on.")

q(185, "Tiger Mastery", "Stranglethorn Vale", 31, "nesingwary", 2,
    "Ajeck Rouack had learned tiger hunting from her father as a girl. At Nesingwary's camp she started new hunters easy, on the young tigers nearby.",
    "To join Hemet Nesingwary's hunt, a newcomer first had to prove a tracker's skill on young tigers near the camp.",
    "Ajeck Rouack, who ran the tiger trials, judged the first tigers nicely done and moved on to harder prey.",
    "The young tigers were taken, and Ajeck was ready to raise the stakes.", true)
q(187, "Tiger Mastery", "Stranglethorn Vale", 35, "nesingwary", 2,
    "Ajeck Rouack raised the stakes with ten Elder Stranglethorn Tigers, the hardest to find and the fiercest to fight.",
    "Elder Stranglethorn Tigers stood between the hunt and Ajeck's final challenge.",
    "Impressed, Ajeck thought her pupil almost ready.",
    "Ten elder tigers fell, and only Ajeck's final challenge remained.", true)
q(188, "Tiger Mastery", "Stranglethorn Vale", 37, "nesingwary", 3,
    "For weeks the camp had tracked an elusive tigress called Sin'Dall. Ajeck wanted her paw as proof.",
    "Ajeck Rouack's final challenge was Sin'Dall, a tigress the camp had tracked for weeks without success.",
    "Sin'Dall's paw earned the title of Master Tiger Hunter from Ajeck Rouack.",
    "Sin'Dall was dead, and Ajeck declared a new Master Tiger Hunter.", true)
fallback("Tiger Mastery", "Stranglethorn Vale", "nesingwary", "185,186,187,188",
    "Ajeck Rouack tested hunters on Stranglethorn's tigers.",
    "Tiger Mastery was one of the trials of Nesingwary's hunting camp.",
    "Ajeck's tiger hunt moved on to a harder stage.",
    "Another tiger hunt for Ajeck was finished.")
q(190, "Panther Mastery", "Stranglethorn Vale", 31, "nesingwary", 2,
    "Sir S. J. Erlgadin said anyone hoping to join Hemet's hunting party had to prove an able panther hunter. Ten young panthers were the start.",
    "Sir S. J. Erlgadin started new hunters easy, with young panthers that were half the challenge just to track.",
    "It was a good start, said Erlgadin.",
    "Sir Erlgadin approved of the ten young panthers.", true)
q(191, "Panther Mastery", "Stranglethorn Vale", 33, "nesingwary", 2,
    "Grown panthers were tougher than the young ones. Erlgadin wanted ten of them before a hunter could mix with the camp's big game hunters.",
    "Sir S. J. Erlgadin's second test called for ten full-grown panthers.",
    "By Erlgadin's account, the panther hunt was perfectly executed.",
    "Ten panthers were down, and Erlgadin was pleased.", true)
q(192, "Panther Mastery", "Stranglethorn Vale", 38, "nesingwary", 2,
    "Shadowmaw Panthers were the deadliest in Stranglethorn, and hard to track. Erlgadin wanted ten slain.",
    "A true panther hunter, Sir Erlgadin said, could drop Shadowmaw Panthers.",
    "The work on the Shadowmaws earned Erlgadin's praise.",
    "Ten Shadowmaw Panthers fell, and Erlgadin had one test left.", true)
q(193, "Panther Mastery", "Stranglethorn Vale", 40, "nesingwary", 3,
    "A panther called Bhag'thera had eluded the whole hunting party. Erlgadin wanted his fang.",
    "Erlgadin's last test was the great Bhag'thera, prowling the jungle unbeaten.",
    "Bhag'thera was dead. Erlgadin raised a cheer and gave his respect.",
    "The Fang of Bhag'thera earned Sir Erlgadin's respect.", true)
fallback("Panther Mastery", "Stranglethorn Vale", "nesingwary", "190,191,192,193",
    "Sir S. J. Erlgadin tested hunters on Stranglethorn's panthers.",
    "Panther Mastery was one of the trials of Nesingwary's hunting camp.",
    "Erlgadin's panther hunt moved on to a harder stage.",
    "Another panther hunt for Erlgadin was finished.")
q(194, "Raptor Mastery", "Stranglethorn Vale", 34, "nesingwary", 2,
    "Hemet Nesingwary put hunting skills to the test with ten Stranglethorn Raptors, and would not say where to find them.",
    "Finding the beasts was half the challenge, Hemet said. His first raptor test was ten Stranglethorn Raptors.",
    "Pleased with the first raptors, Hemet promised harder ones.",
    "Ten Stranglethorn Raptors were taken to Hemet's satisfaction.", true)
q(195, "Raptor Mastery", "Stranglethorn Vale", 36, "nesingwary", 2,
    "Lashtail Raptors were Hemet Nesingwary's next challenge, ten of them.",
    "Hemet stepped up the test with the bloody Lashtail Raptors.",
    "That, said Hemet, was how to get a trophy or two over the hearth.",
    "Ten Lashtails fell, and Hemet praised the killing.", true)
q(196, "Raptor Mastery", "Stranglethorn Vale", 41, "nesingwary", 2,
    "Jungle Stalkers were a cagey breed of raptor, harder to track and kill than the rest. Hemet promised a tip on the best hunting yet for ten of them.",
    "Hemet's next test was the Jungle Stalkers, the cagiest raptors in the jungle.",
    "A true raptor slayer, Hemet declared, and he was ready with his tip.",
    "Ten Jungle Stalkers were down, and Hemet was delighted.", true)
q(197, "Raptor Mastery", "Stranglethorn Vale", 43, "nesingwary", 3,
    "Even Hemet had failed to kill a wily raptor that Ajeck called Tethis. Bringing back his talon would be a feat no other big game hunter had managed.",
    "Hemet Nesingwary's best hunting yet was the ferocious raptor Tethis.",
    "Tethis was dead. Hemet hailed a master raptor slayer and liked the ring of it.",
    "The talon of Tethis won Hemet's highest praise.", true)
fallback("Raptor Mastery", "Stranglethorn Vale", "nesingwary", "194,195,196,197",
    "Hemet Nesingwary tested hunters on Stranglethorn's raptors.",
    "Raptor Mastery was one of the trials of Nesingwary's hunting camp.",
    "Hemet's raptor hunt moved on to a harder stage.",
    "Another raptor hunt for Hemet was finished.")
q(208, "Big Game Hunter", "Stranglethorn Vale", 43, "nesingwary", 4,
    "Hemet had one beast in mind above the rest, King Bangalash. The white tiger was the reason he had come to Stranglethorn.",
    "Hemet Nesingwary had his sights on King Bangalash, a white tiger. Killing it, he said, would prove hunting skill second to none.",
    "King Bangalash was dead. Hemet welcomed a comrade to his hunting party, one whose skill no one would doubt.",
    "Cheers went up from Hemet for the death of King Bangalash, where others had failed.")
hl(208, "King Bangalash, the white tiger Hemet Nesingwary had come for, was killed. Hemet raised cheers and welcomed a comrade to his hunting party.",
    "Nesingwary's camp cheered when the white tiger King Bangalash fell.")
hl(188, "Sin'Dall the tigress was killed, and Ajeck Rouack named a new Master Tiger Hunter.",
    "Ajeck's tiger trials ended with the paw of Sin'Dall.")
hl(193, "Sir Erlgadin gave his respect once the great panther Bhag'thera was killed.",
    "Bhag'thera's fang finished Erlgadin's panther trials.")
hl(197, "Hemet hailed a master raptor slayer when Tethis, a raptor even he had failed to kill, was dead.",
    "Tethis's talon finished Hemet's raptor trials.")
for _, id in ipairs({595, 597, 599, 604, 608, 624, 625, 626, 570, 572, 571, 573, 568, 569,
    185, 187, 188, 190, 191, 192, 193, 194, 195, 196, 197, 208}) do src(id) end
for _, id in ipairs({185, 187, 188, 190, 191, 192, 193, 194, 195, 196, 197, 208}) do
    P.questIDs[id].threadLabel = P.threads.world_nesingwary
end

-- Batch W2-6: hand-offs. The Wailing Caverns lead-ins after Tonga's oasis work
-- (horde pack 880), the Disciples of Naralex at the cave mouth, Zamah's
-- serpentbloom, Fizziks's envelope for Sputtervalve (1094, beside 1095 above),
-- and Forever's Stepping Stones note (79192). The Druids of the Fang die only
-- in 914; Naralex is never woken here.
P.threads.world_wailing = "the corruption of the Wailing Caverns"
q(1489, "Hamuul Runetotem", "Thunder Bluff", 16, "wailing", 3,
    "Tonga Runetotem found a taint in the oasis shells unlike any he had seen. He believed the Wailing Caverns were its source, and had sent word to the elder druid Hamuul Runetotem on the Elder Rise in Thunder Bluff.",
    "The land seemed to dream and could not wake, Tonga said. Before anyone went into the Wailing Caverns, Hamuul Runetotem in Thunder Bluff was to give counsel.",
    "Hamuul greeted the newcomer and warned that the task ahead was a dire one.",
    "On the Elder Rise, Hamuul Runetotem welcomed the messenger and spoke of a dire task.")
q(1490, "Nara Wildmane", "Thunder Bluff", 16, "wailing", 3,
    "Hamuul had entered the land of dreams and seen a cult of druids in the Wailing Caverns, once noble, now servants of the taint. Too old to stay long in the dreaming, he sent the question to Nara Wildmane, whose spirit was young and fierce.",
    "Nara Wildmane had stayed in the dreaming when Hamuul Runetotem fled it. She knew more of the tainted druids.",
    "Nara had seen the druids' twisted, scaled faces and knew their crimes and plans. She wanted them stopped.",
    "Nara Wildmane confirmed that the druids of the Wailing Caverns were real, and asked for them to be stopped.")
q(914, "Leaders of the Fang", "Thunder Bluff", 22, "wailing", 5,
    "The Druids of the Fang had once meant to heal the Barrens, but now sought to remake it to match their twisted dreams. Nara wanted the dream gems of their four leaders, who lurked deep in the Wailing Caverns.",
    "Four leaders of the Druids of the Fang each held a dream gem. Their faces haunted Nara Wildmane's dreams.",
    "The four leaders were dead. Nara's dreams were free of their faces, and she thanked her helper on behalf of Thunder Bluff's druids.",
    "The four dream gems reached Nara Wildmane, who said the Barrens had been saved from a cursed future.")
hl(914, "Anacondra, Cobrahn, Pythas and Serpentis, the leaders of the Druids of the Fang, were killed. Their dream gems went to Nara Wildmane in Thunder Bluff.",
    "Nara Wildmane's dreams were free of the Fang leaders' faces once their four gems reached her.")
q(962, "Serpentbloom", "Thunder Bluff", 18, "wailing", 2,
    "Apothecary Zamah served the Royal Apothecary Society from Thunder Bluff. A rare herb called serpentbloom had great potential, Zamah believed, and it grew only deep in the Wailing Caverns.",
    "Serpentbloom grew only in the darkest recesses of the Wailing Caverns. The Royal Apothecary Society wanted it in quantity.",
    "Zamah called the specimens splendid.",
    "Splendid specimens of serpentbloom reached Apothecary Zamah for the Society.")
q(1486, "Deviate Hides", "The Barrens", 17, "wailing", 2,
    "As Naralex sank deeper into his nightmare, deviate beasts had risen beneath the Barrens. One of his disciples, Nalpak, believed their hides could serve leatherworkers.",
    "Nalpak saw some good in the evil deviate creatures of the Wailing Caverns. Their hides were for leatherworking.",
    "The deviate hides reached Nalpak, who promised the effort would not go unnoticed.",
    "Nalpak thanked the gatherer for the deviate hides.")
q(1487, "Deviate Eradication", "The Barrens", 21, "wailing", 3,
    "Naralex had tried to enter the Emerald Dream and regrow the Barrens into forest, but his dream became a nightmare. His disciple Ebru cared less about waking him than about ridding the caverns of the deviate beasts.",
    "Ebru, a Disciple of Naralex, begged for war on the deviate creatures spawned in the Wailing Caverns.",
    "The bravery won Ebru's praise as the first step toward a restored Barrens.",
    "The deviate beasts were thinned, and Ebru gave the thanks of the Disciples of Naralex.")
q(1094, "Further Instructions", "The Barrens", 21, "stonetalon", 3,
    "Ziz Fizziks had been booted out of the Venture Company with an envelope of their internal documents, manuals and the Super Reaper 6000 blueprints. Sputtervalve, a little green fellow, had taken up residence in Ratchet.",
    "Fizziks's stolen Venture Company papers were meant for Sputtervalve in Ratchet.",
    "Distrustful of Fizziks, Sputtervalve still judged the information good enough. He wanted the Venture Company gone, though he admitted their machines had their uses.",
    "The envelope reached Sputtervalve in Ratchet, who accepted Fizziks's information despite his doubts.", true)
q(79192, "Stepping Stones", "The Barrens", 24, "steppingstones", 2,
    "A note spoke of two deaths during deliveries for the New Plague, dismissed as simple apothecary accidents. Its writer offered a safe place to talk, a cozy spot in the mountains between the Barrens and Desolace.",
    "Whoever wrote the note doubted that two deaths tied to the New Plague were accidents, and named a hidden camp in the mountains toward Desolace.",
    "At the camp in the mountains, the corner of another note was flapping in the breeze.",
    "Another note waited at the hidden camp between the Barrens and Desolace.")
P.threads.world_steppingstones = "the notes about the New Plague deliveries"
P.questIDs[79192].thread = "world_steppingstones"
for _, id in ipairs({1489, 1490, 914, 962, 1486, 1487, 1094}) do src(id) end
src(1489, "horde pack thread horde_oases (Tonga Runetotem, 880); hand-off 2026-11-05")
src(1486, "LoreForever quest:1486 (wiki: Deviate Hides): Nalpak, Disciple of Naralex")
P.questIDs[79192].source[2] = "Forever addition (ID above 65000): corpus_vanilla_quests.txt record, LoreForever quest:79192 (zone barrens)"
P.questIDs[79192].setting = "Forever"

-- Batch W2-8: Thousand Needles. The goblin racing team's sponsorship errand,
-- Razzeric's booster and the stolen indurium notes; the gnomes' helmets and
-- parts through Kravel Koalbeard; the track's basilisks; Freewind Post's
-- errands; Moktar's swarm; and Dorn's Final Passage. Dorn's earlier tests
-- (1149-1159, 6627, 6628), Zamek's Distraction (1191), Indurium Ore (1192) and
-- Encrusted Tail Fins (1107) have no captured text and stay unwritten.
P.threads.world_dorn = "Dorn Plainstalker's tests"
P.threads.world_freewind = "the requests of Freewind Post"
P.threads.world_swarm = "the insects beneath the Needles"
q(1394, "Final Passage", "Thousand Needles", 36, "dorn", 4,
    "Parqual Fintallas judged the tests passed, his own and those before it. Dorn Plainstalker in Thousand Needles would sense the change and see the effort rewarded.",
    "The last of the tests was done. Parqual Fintallas sent word back to Dorn Plainstalker, who had set the first leap.",
    "Many moons seemed to have passed since the first leap, said Dorn. He saw more strength and more understanding now, and gave a reward for seeing his tests to the end.",
    "Back in Thousand Needles, Dorn welcomed the return and rewarded the completed tests.")
q(1176, "Load Lightening", "Thousand Needles", 30, "racecar", 2,
    "Every bit counted in racing, Pozzik said. The goblin team built its racers' frames with vulture bones, light and strong, and the salt flats were littered with vultures.",
    "Pozzik of the goblin racing team paid a good price for vulture bones from the Shimmering Flats.",
    "Straight away, the bones went to Pozzik's crew for work on the racers.",
    "Pleased with the vulture bones, Pozzik set his crew to work.")
q(1178, "Goblin Sponsorship", "The Barrens", 37, "racecar", 2,
    "Gazlowe of Ratchet tracked down parts for the goblin racing team, and had promised Pozzik a prototype fuel regulator weeks ago. It had not come, and the gnomes were gaining.",
    "Pozzik's new fuel regulator was overdue. Gazlowe in Ratchet had promised it, and was usually prompt.",
    "Pozzik, Gazlowe said, had been one of the most respected tinkerers in Undermine before he retired to build racers and designed the two-engine model.",
    "Pozzik's messenger found a welcome in Ratchet, where Gazlowe praised the old tinkerer.", true)
q(1180, "Goblin Sponsorship", "Stranglethorn Vale", 37, "racecar", 2,
    "Gazlowe had never received the regulator himself. Baron Revilgaz in Booty Bay was meant to ship it, so Wharfmaster Lozgil's cargo logs would show whether it had left.",
    "The missing regulator might have slipped through the cracks in Booty Bay. Wharfmaster Lozgil kept the shipping logs.",
    "Lozgil's logs showed nothing for Ratchet but boots from Drizzlik, building supplies and tools. There were no race parts.",
    "No race parts had gone out of Booty Bay, Lozgil found.", true)
q(1181, "Goblin Sponsorship", "Stranglethorn Vale", 37, "racecar", 2,
    "Lozgil could help no further. Baron Revilgaz, at the top of the tavern across the harbor, knew his own business best.",
    "The question of the fuel regulator went up to Baron Revilgaz himself, in the Booty Bay tavern.",
    "Revilgaz knew all about it. His men had gone after the regulator's blueprints and come back empty-handed.",
    "His men had failed to find the blueprints, Revilgaz admitted.", true)
q(1182, "Goblin Sponsorship", "Stranglethorn Vale", 37, "racecar", 3,
    "The Venture Company's shredders at Lake Nazferiti carried a new model of fuel regulator. Their foreman Cozzle kept the blueprints locked in his house, and had outwitted the Baron's men.",
    "Revilgaz hoped Pozzik could use the Venture Company's new regulator design, if the blueprints were taken from Cozzle's house at Lake Nazferiti.",
    "Once he had copied the blueprints for his own notes, Revilgaz sent the originals on to Pozzik, so no one would think a sponsor had abandoned him.",
    "With his own copy made, the Baron sent the blueprints on for Pozzik.", true)
q(1183, "Goblin Sponsorship", "Thousand Needles", 37, "racecar", 3,
    "Baron Revilgaz sent his regards to Pozzik with the blueprints, and hoped to hear of a track record soon.",
    "The fuel regulator blueprints from Lake Nazferiti were bound for Pozzik on the Shimmering Flats.",
    "Pozzik had hoped for an assembled regulator, but saw a chance to improve the design from the ground up and have it installed soon.",
    "Pozzik took the blueprints and began sketching improved schematics.", true)
fallback("Goblin Sponsorship", "Thousand Needles", "racecar", "1178,1180,1181,1182,1183",
    "Pozzik's goblin racing team was waiting on a new fuel regulator.",
    "The search for the racing team's fuel regulator passed between Ratchet and Booty Bay.",
    "The search for the fuel regulator moved on.",
    "Another of the racing team's sponsors was consulted.")
hl(1183, "Pozzik had the Venture Company's regulator blueprints on the Shimmering Flats, and meant to build a better one from scratch.",
    "Pozzik had his fuel regulator blueprints at last.")
q(1186, "The Eighteenth Pilot", "Thousand Needles", 37, "racecar", 2,
    "Pozzik would be busy fitting the new regulator. Razzeric, the team's eighteenth pilot, liked to add modifications of his own and was a little off his rocker.",
    "Pozzik sent help to Razzeric, the goblin team's pilot, warning not to look surprised at him.",
    "Once, Razzeric said, he too had run around the pits helping the mechanics. Now he was the goblin racing team's pilot extraordinaire.",
    "The eighteenth pilot welcomed Pozzik's helper and boasted of his position.")
q(1187, "Razzeric's Tweaking", "Thousand Needles", 41, "racecar", 3,
    "Razzeric liked to load on firepower after Pozzik finished a racer. He had ordered a seaforium booster from Shreev in Gadgetzan, but the zeppelin carrying it had crashed in Dustwallow Marsh.",
    "A seaforium booster for Razzeric's racer lay somewhere in the wreck of a zeppelin in Dustwallow Marsh.",
    "Fifteen pounds of solid seaforium delighted Razzeric, who expected to beat the gnomes twice.",
    "The booster reached Razzeric, eager to strap it to his racer.")
q(1188, "Safety First", "Tanaris", 41, "racecar", 2,
    "Shreev had left a safety lock on the booster, limiting its power. Razzeric wanted it off, and only Shreev at the Gadgetzan Gizmorium could remove it.",
    "Razzeric sent the booster back to Shreev in Gadgetzan to have the safety removed.",
    "Shreev grumbled that only Razzeric would call it a safety lock. The booster was almost all explosives already, but Razzeric always wanted more.",
    "At the Gizmorium, Shreev agreed to change the booster, complaining about Razzeric.", true)
q(1189, "Safety First", "Thousand Needles", 41, "racecar", 3,
    "Shreev made the change and sent a warning. One slight mistake, and Razzeric would be a burnt spot on the track, and who knew if the nineteenth pilot would be any good.",
    "The altered booster went back to Razzeric with Shreev's warning to be careful.",
    "Razzeric was delighted and pictured the gnomes' faces when he set it off, on his way to a new course record.",
    "Razzeric was thrilled to have his booster ready.", true)
fallback("Safety First", "Thousand Needles", "racecar", "1188,1189",
    "Razzeric wanted more power from his seaforium booster.",
    "The goblin pilot's booster passed between the Shimmering Flats and Gadgetzan.",
    "The work on Razzeric's booster moved on.",
    "Shreev and Razzeric settled the matter of the booster.")
q(1190, "Keeping Pace", "Thousand Needles", 41, "racecar", 3,
    "The gnomes' cars had grown faster, though their designs looked the same. Pozzik suspected a new material, and Rizzle Brassbolts was always poring over its plans, so Zamek would make a diversion while the plans were taken.",
    "Pozzik wanted to know what had made the Brassbolts brothers' cars faster. Rizzle's plans would tell.",
    "Scribbled in a hurried hand, Rizzle's plans held notes and designs for refining some raw material.",
    "A scroll of Rizzle's notes on refining a raw material was taken.")
q(1194, "Rizzle's Schematics", "Thousand Needles", 41, "racecar", 3,
    "Rizzle's schematics described refining indurium ore, mined at Uldaman in the Badlands and valued for resisting heat. A raw hunk of the ore held the plans down.",
    "The stolen schematics, and the lump of indurium ore used as their paperweight, were for Pozzik.",
    "Heat-resistant indurium would explain the gnomes' speed, Pozzik said. He would test the sample, but needed more to make use of it.",
    "Pozzik took the indurium sample for testing and wanted more.")
hl(1194, "Rizzle's schematics showed that the gnomes' new speed came from indurium ore out of Uldaman. Pozzik took the sample to test.",
    "Pozzik learned the gnomes' secret was heat-resistant indurium.")
q(1179, "The Brassbolts Brothers", "Thousand Needles", 30, "racecar", 2,
    "Pilot Longbeard's gnome friends on the Shimmering Flats had a rocket car so fast its pilots kept crashing and giving themselves concussions. He had siege engine helmets for them, but could not make the trip.",
    "Pilot Longbeard sent siege engine helmets to the Brassbolts brothers, whose rocket car kept knocking out its pilots.",
    "Hooray, said Wizzle Brassbolts. With helmets, perhaps they could talk a pilot into driving the car.",
    "The helmets reached the Brassbolts brothers, who hoped they would find a pilot now.", true)
fallback("The Brassbolts Brothers", "Thousand Needles", "racecar", "1179,2769",
    "The Brassbolts brothers raced a gnomish rocket car on the Shimmering Flats.",
    "The gnome racers of the Shimmering Flats needed supplies from far away.",
    "The Brassbolts brothers' racing effort moved forward.",
    "A delivery for the gnome racers was made.")
q(1175, "A Bump in the Road", "Thousand Needles", 33, "racecar", 2,
    "After the goblins' Red Thunder racer crashed into a basilisk, Kronkrider hired Trackmaster Zherin to keep the track clear. The basilisks on the flats had grown big and had to be thinned.",
    "Trackmaster Zherin paid to keep basilisks from wandering onto the Shimmering Flats track.",
    "Zherin hoped none had died on the track itself, since the carcasses took a long time to rot in the sun.",
    "Once the basilisks were thinned, Zherin was satisfied.")
q(1111, "Wharfmaster Dizzywig", "The Barrens", 36, "racecar", 2,
    "Kravel Koalbeard got people what they needed, and the gnomes had a parts order waiting in Ratchet. He promised profitable jobs for anyone who fetched it from Wharfmaster Dizzywig.",
    "Kravel Koalbeard sent a parts order to Wharfmaster Dizzywig on the Ratchet docks.",
    "Dizzywig was glad to be rid of the parts before they rusted.",
    "On the Ratchet docks, Dizzywig handed over the parts for Kravel.", true)
-- The horde pack's 1492 holds this title; 1111 stays exact-only with its own label.
P.questIDs[1111].threadLabel = P.threads.world_racecar
q(1112, "Parts for Kravel", "Thousand Needles", 36, "racecar", 2,
    "Dizzywig gave up Kravel's package with a message that more special orders meant paying his tab.",
    "The gnomes' parts from Ratchet were for Kravel Koalbeard first.",
    "Kravel was pleased, then took one small item out of the package before it went on.",
    "Kravel took the package and helped himself to a small piece.")
q(1114, "Delivery to the Gnomes", "Thousand Needles", 36, "racecar", 2,
    "Kravel sent the parts on to Fizzle Brassbolts, sure the gnome would not miss the small, worthless piece he had removed.",
    "The rest of the gnomes' order was for Fizzle Brassbolts on the Shimmering Flats.",
    "Fizzle was thrilled with his hydro ratchets and repeater bolts.",
    "Fizzle Brassbolts had waited a long time for those parts.")

q(4767, "Wind Rider", "Thousand Needles", 29, "freewind", 2,
    "Elu of Freewind Post recruited wyverns for the master wind riders and hoped to become one. The demand was greater than they could train, so he wanted eggs from Highperch.",
    "Wyvern eggs from Highperch could help Elu keep up with the wind riders' need. The wyverns guarded them fiercely.",
    "With the eggs, Elu hoped to take the next step toward becoming a wind rider, and gave a token of thanks.",
    "Elu took the Highperch eggs and gave a token of appreciation.")
q(4821, "Alien Egg", "Thousand Needles", 26, "freewind", 3,
    "Rumor spoke of an alien egg in Thousand Needles, guarded by serpents as if it were their own. Hagar Lightninghoof wanted it found in one of the serpent dens below the cliffs.",
    "Hagar Lightninghoof of Freewind Post wanted to examine a strange egg no one had managed to get near.",
    "The egg was finally delivered, and Hagar's first close look left him astonished.",
    "One look at the mysterious egg alarmed Hagar Lightninghoof.")
q(4865, "Serpent Wild", "Thousand Needles", 26, "freewind", 3,
    "Hagar had seen something he would not have believed, and cried that vengeance had come to Thousand Needles. Motega Firemane at Whitereach Post would know what to do.",
    "What came of the alien egg sent Hagar running for help. Motega Firemane waited at Whitereach Post, northwest of Freewind.",
    "What Hagar had seen proved the old warning of Arikara true, Motega declared, and it had to be dealt with at once.",
    "Whitereach Post heard the news, and Motega Firemane named Arikara as the danger.")
q(5147, "Wanted - Arnak Grimtotem", "Thousand Needles", 29, "freewind", 3,
    "Arnak Grimtotem, an outcast, was wanted for murder and kidnapping. He had last been seen on the cliffs near Darkcloud Pinnacle.",
    "A poster offered a reward for Arnak Grimtotem, paid by Cliffwatcher Longhorn at Freewind Post.",
    "Longhorn had begun to fear Arnak would never face justice. His foul deeds had made the cliffwatcher's blood boil.",
    "Arnak Grimtotem was dead, and Cliffwatcher Longhorn paid the reward.")
q(5361, "Family Tree", "Desolace", 35, "freewind", 2,
    "Cliffwatcher Longhorn had not written to his brother Nataka in a year, and the centaur had grown restless since. His report was for Ghost Walker Post in Desolace, by way of Stonetalon and the Charred Vale.",
    "Longhorn wanted his brother Nataka, at Ghost Walker Post in Desolace, to know about the centaur activity.",
    "Nataka Longhorn welcomed his brother's messenger to Ghost Walker Post and pointed to others who needed help.",
    "Nataka Longhorn received his brother's report at Ghost Walker Post and welcomed its bearer.")
q(1147, "The Swarm Grows", "Thousand Needles", 35, "swarm", 3,
    "Belgrom wanted the insect creatures at the dig site pushed back into the depths. Moktar Krin's war party was half dead after fighting the Explorers' League's dwarves and could not do it alone.",
    "Moktar Krin's battered war party needed help against the insect creatures swarming from the dig site to the south.",
    "Laughing, Moktar said the ichor-covered helper reeked enough to start a kodo stampede. The smell alone proved the work against the insects.",
    "The insects at the dig site were pushed back, and Moktar gave his thanks.", true)
fallback("The Swarm Grows", "Thousand Needles", "swarm", "1145,1146,1147",
    "Insect creatures were swarming from the ground in Thousand Needles.",
    "The Horde wanted the insect swarm pushed back into the depths.",
    "The insect swarm was pushed back for a time.",
    "The fight against the swarm went on.")
-- The horde pack's 1492 entry stands in for this title; a neutral context
-- covers both its crate (1492) and Kravel's parts order (1111).
P.quests["Wharfmaster Dizzywig"] = {zone = "The Barrens", thread = false, importance = 2,
    why = {"Wharfmaster Dizzywig handled the cargo on the Ratchet docks.", "A shipment waited with Wharfmaster Dizzywig in Ratchet."},
    after = {"Wharfmaster Dizzywig dealt with the cargo.", "The business at the Ratchet docks was settled."},
    source = {"corpus_vanilla_quests.txt quests 1111,1492"}}
q(1148, "Parts of the Swarm", "The Barrens", 35, "swarm", 3,
    "The insects' carapaces were strong and their bodies highly evolved. Korran might learn from them what the creatures were and where they came from.",
    "A cracked carapace from the dig site seemed worth showing to Korran, who studied the insects.",
    "Word from Moktar pleased Korran. With the carapaces and the eggs from the Field of Giants, he could start to learn what the insects were and what they wanted.",
    "The specimens reached Korran, who began his study of the creatures.", true)
q(1184, "Parts of the Swarm", "Orgrimmar", 35, "swarm", 3,
    "Korran sent word to Belgrom in Orgrimmar that Moktar was doing his bidding well and the study was going forward.",
    "Belgrom Rockmaul in Orgrimmar was to hear of Moktar's work and Korran's progress.",
    "The Warchief would hear of the effort, Belgrom promised, and he wanted to know as soon as Korran learned more about the threat.",
    "Pleased with the report, Belgrom asked for news of Korran's findings.", true)
fallback("Parts of the Swarm", "Thousand Needles", "swarm", "1148,1184",
    "Strange insects had swarmed from a dig site in Thousand Needles.",
    "Korran was studying the insect creatures that troubled Moktar's war party.",
    "The study of the insect swarm moved forward.",
    "Word of the insect creatures passed along the Horde's chain of command.")
for _, id in ipairs({1394, 1176, 1178, 1180, 1181, 1182, 1183, 1186, 1187, 1188, 1189, 1190, 1194, 1179, 1175,
    1111, 1112, 1114, 4767, 4821, 4865, 5147, 5361, 1147, 1148, 1184}) do src(id) end
src(1394, "Test of Faith/Endurance/Strength/Lore (1149-1159, 6627, 6628) have no captured text in the corpus")

-- Batch W2-9: Swamp of Sorrows. Stonard's coast watch (Dar, Tok'Kar, Katar),
-- the Atal'ai exile's artifacts, Watcher Biggs's caravan for Nethergarde, the
-- runners between Stonard and Kargath, and the first steps of Eranikus's
-- redemption (3374, 3512). Eranikus is never redeemed here; 3512 stops at the
-- stolen augury device.
P.threads.world_stonard = "the watch on the Stonard coast"
P.threads.world_biggs = "Watcher Biggs's lost caravan"
P.threads.world_kargath = "the runners between Stonard and Kargath"
P.threads.world_eranikus = "the redemption of Eranikus"
q(698, "Lack of Surplus", "Swamp of Sorrows", 40, "stonard", 2,
    "Dar in Stonard was gathering supplies for the outpost on the beach, where Tok'Kar had little time between guard shifts and cooking. His soldiers liked sawtooth meat, from the older crocolisks only.",
    "Tok'Kar's beach outpost was short of sawtooth meat. Dar in Stonard wanted a shipment taken out to the soldiers.",
    "Fresh meat for the fire pleased Tok'Kar. The nights would be more tolerable, he said, and he joked that Dar's attitude reeked less than his smell.",
    "At the beach outpost, Tok'Kar welcomed the sawtooth meat with thanks.", true)
q(699, "Lack of Surplus", "Swamp of Sorrows", 42, "stonard", 2,
    "Tok'Kar's soldiers watched the coast for murlocs threatening Stonard. Sawtooth snapper claws made fine weapons, and he offered one in return for some.",
    "Tok'Kar needed sawtooth snapper claws for weapons, and promised one as thanks.",
    "With the claws in hand, Tok'Kar set to work on a weapon, quick from long practice.",
    "The snapper claws reached the beach outpost, and a weapon was promised.", true)
fallback("Lack of Surplus", "Swamp of Sorrows", "stonard", "698,699",
    "Stonard's beach outpost needed supplies from the swamp's sawtooth crocolisks.",
    "The soldiers on the Stonard coast were short of meat and weapons.",
    "The beach outpost was better supplied.",
    "Supplies from the swamp reached Stonard's coast watch.")
q(1422, "Threat From the Sea", "Swamp of Sorrows", 45, "stonard", 2,
    "While Tok'Kar worked on the weapon, Katar needed help patrolling the beach. Tok'Kar preferred sharp wits to getting drunk with the camp's other louses.",
    "Katar, on Stonard's beach, wanted help with patrols against the murlocs.",
    "Over the roar of the sea, Katar pointed out the gurgles of the fish men.",
    "On the beach, Katar heard the murlocs and called for silence.", true)
q(1426, "Threat From the Sea", "Swamp of Sorrows", 43, "stonard", 3,
    "Katar had no love for the sea or anything that came out of it, and enjoyed watching the fish men die at Horde hands. Even their most powerful kind were to be tested.",
    "On the Stonard coast, Katar wanted to see how many murlocs could be slain, and the strongest among them.",
    "The sea, Katar said, had been stained with the blood of its own spawn. Now the murlocs would have to rebuild their ranks, and he would smile at every scream.",
    "Many murlocs were dead along the beach, and Katar offered more reward for more.", true)
q(1427, "Threat From the Sea", "Swamp of Sorrows", 43, "stonard", 2,
    "Katar sent word that Tok'Kar had finished a few weapons, and would offer one for the help on the beach.",
    "Before resting, Katar advised, Tok'Kar should be seen about the weapons he had finished.",
    "For the sawtooth meat and for a smile on Katar's face, Tok'Kar offered one of his new weapons.",
    "A weapon from Tok'Kar's forge was the reward for the beach patrols.", true)
fallback("Threat From the Sea", "Swamp of Sorrows", "stonard", "1422,1426,1427",
    "Murlocs threatened Stonard's watch on the swamp's coast.",
    "Katar and Tok'Kar held the beach against the fish men.",
    "The fight against the murlocs on the beach went on.",
    "Stonard's coast watch had help against the fish men.")
q(1428, "Continued Threat", "Swamp of Sorrows", 45, "stonard", 2,
    "Katar wanted more fish men found along the beach, and promised a reward for diligence.",
    "More murlocs crawled up the Stonard coast. Katar asked for them slain.",
    "More fish men died, and Katar called for the rest to perish.",
    "Well done, said Katar, and he called for more murloc blood.")
q(1430, "Fresh Meat", "Swamp of Sorrows", 44, "stonard", 2,
    "Dar's customers wanted crawler meat, especially from the monstrous crawlers on the coast east of Stonard. He would ship the legs to Orgrimmar.",
    "Monstrous crawler legs fetched a good price with Dar, who sent them on to Orgrimmar.",
    "Dar could not wait to taste the legs cooked over an open fire, and offered a sample.",
    "The crawler legs reached Dar, who called them perfect.")
q(1429, "The Atal'ai Exile", "The Hinterlands", 44, "atalai", 3,
    "Fel'zerul's scout had found a scroll written in blood on dried flesh, a sentence against an Atal'ai priest. The priest had been exiled to the Witherbark trolls of the Hinterlands, and Fel'zerul wanted the artifacts' true use learned from him.",
    "The Atal'ai exile lived among the Witherbark in the Hinterlands. Fel'zerul in Stonard sent him a bundle of artifacts to explain.",
    "Recognizing the summoning artifacts, the exile saw that Jammal'an the Prophet was leading his disciples toward their chosen fate, and wondered whether Hakkar had returned to the temple.",
    "Among the Witherbark, the Atal'ai exile examined the artifacts and spoke of Jammal'an the Prophet.")

q(1396, "Encroaching Wildlife", "Swamp of Sorrows", 37, "biggs", 2,
    "Watcher Biggs's caravan had been bound for the eastern coast when Lost Ones attacked it. He alone had survived, sworn to guard the supplies, and beasts were closing in on his camp.",
    "Watcher Biggs, last survivor of an attacked caravan, needed the swamp's beasts kept away from his camp.",
    "The animal sounds grew faint and distant, and Biggs hoped they would not return.",
    "Biggs's camp was clear of beasts, for now.")
q(1421, "The Lost Caravan", "Swamp of Sorrows", 35, "biggs", 3,
    "Before he blacked out, Biggs had seen a wagon dragged to Fallow Sanctuary, the Lost Ones' village to the north. Its chest held reagents vital to the wizards of Nethergarde Keep.",
    "A caravan chest of reagents for Nethergarde had been taken to the Lost Ones' Fallow Sanctuary. Watcher Biggs wanted it back.",
    "With the reagents back, Nethergarde's wizards could go on with their work. Biggs did not know what it was, only that it concerned the Dark Portal and the Alliance's security.",
    "The reagents were recovered from Fallow Sanctuary, and Biggs was relieved.")
q(1398, "Driftwood", "Swamp of Sorrows", 42, "biggs", 2,
    "Biggs had to fix his wagon to reach Nethergarde, and the swamp's spongy wood would not serve. Sun-dried driftwood from the coast would.",
    "Watcher Biggs asked for sun-dried driftwood from the eastern coast to mend his wagon.",
    "Light but tough, the driftwood would work nicely, Biggs said.",
    "The driftwood reached Biggs, who began mending the wagon.")
q(1425, "Deliver the Shipment", "Blasted Lands", 42, "biggs", 3,
    "While he fixed the wagon, Biggs packed the most vital supplies saved from the attacks for Nethergarde Keep, watching over the Dark Portal in the Blasted Lands.",
    "Watcher Biggs sent his caravan's surviving supplies on to Nethergarde Keep.",
    "Quartermaster Lungertz had thought Biggs and his caravan lost. He hoped the package held Azoran crystals, a reagent the keep was running low on.",
    "Nethergarde received the package from Biggs's caravan, which had been given up for lost.")
hl(1425, "Biggs's surviving supplies reached Nethergarde Keep, where the quartermaster had given the caravan up for lost.",
    "Nethergarde had the package from Watcher Biggs at last.")

q(1418, "Neeka Bloodscar", "Badlands", 35, "kargath", 2,
    "Communication between Stonard and the Badlands outpost of Kargath was often cut. Helgrum the Swift wanted a report from Neeka Bloodscar, Kargath's head scout.",
    "Helgrum the Swift of Stonard sent for word from Neeka Bloodscar at Kargath.",
    "Neeka had sent an outrunner to Stonard three days before. If Helgrum had no report, that runner had failed.",
    "Neeka Bloodscar learned that her last runner from Kargath had never reached Stonard.")
q(1419, "Coyote Thieves", "Badlands", 40, "kargath", 2,
    "Crag coyotes were bold enough to creep into Kargath and steal its food. Neeka wanted their jawbones, as proof of knowing the Badlands.",
    "Neeka Bloodscar wanted the coyotes stealing Kargath's food hunted down.",
    "A fine collection of jawbones, Neeka said. The deed suggested its doer might survive in the Badlands.",
    "The coyotes would not tear through Kargath's supplies any more.")
q(1420, "Report to Helgrum", "Swamp of Sorrows", 40, "kargath", 3,
    "Neeka wrote a fresh report for Helgrum in Stonard, and warned its runner not to get lost or fall to an enemy.",
    "Neeka Bloodscar's fresh report had to reach Helgrum the Swift in Stonard.",
    "From Neeka's report, Helgrum learned the Alliance had its own troubles in the Badlands, and that some enemies might be shared.",
    "Helgrum the Swift had Neeka's report at last.")

q(3374, "The Essence of Eranikus", "Swamp of Sorrows", 55, "eranikus", 4,
    "Through an Oathstone, Itharius of Ysera's dragonflight asked for help redeeming the corrupted soul of Eranikus. The first step was to give him the gem that chained what free will remained in Eranikus's mind.",
    "Itharius wanted the essence of Eranikus, a gem holding what was left of the green dragon's free will.",
    "So it began, said Itharius. He judged the choices made so far correct, and said future deeds would decide whether that continued.",
    "With the essence of Eranikus in his keeping, Itharius began the work of redemption.", true)
fallback("The Essence of Eranikus", "Swamp of Sorrows", "eranikus", "3373,3374",
    "Eranikus of the Green Dragonflight had left part of his essence in a gem.",
    "The gem holding Eranikus's essence called for a choice about his fate.",
    "A choice was made about the essence of Eranikus.",
    "The gem of Eranikus left the hands that had carried it.")
q(3512, "In Eranikus' Own Words", "Winterspring", 55, "eranikus", 4,
    "Eranikus lay between sleep and death, twisted in nightmares. To speak with him through the gem, Itharius sent for Umbranse the Spiritspeaker, a human medium in eastern Winterspring.",
    "Itharius needed a way to reach Eranikus through the tainted essence. Umbranse the Spiritspeaker, who spoke for the dead, might help.",
    "His death-speaking was at Itharius's service, Umbranse said, but his most potent augury device had been taken from him, and without it he could not help Eranikus.",
    "Help would come from the Spiritspeaker once his stolen augury device was recovered.")
hl(3512, "Umbranse the Spiritspeaker would help Itharius reach Eranikus, once his stolen augury device came back.",
    "Umbranse, the medium, agreed to speak with Eranikus, but his augury device was missing.")
for _, id in ipairs({698, 699, 1422, 1426, 1427, 1428, 1430, 1429, 1396, 1421, 1398, 1425, 1418, 1419, 1420, 3374, 3512}) do src(id) end
P.questIDs[1429].threadLabel = P.threads.world_atalai

-- Batch W2-10: Badlands and the Burning Steppes. Hammertoe's amulet and the
-- Shadowforge at Angor Fortress (beside 720/718/733 above), Agmond's fate,
-- Lotwil Veriatus's shackles, Rigglefuzz, and Cyrus Therepentous's taste of
-- flame. Theldurin's Yagyin's Digest stages were held back here until the notes
-- lane added discovery facts; they are authored in batch W3-11 below.
P.threads.world_lotwil = "Lotwil Veriatus's elemental shackles"
P.threads.world_cyrus = "Cyrus Therepentous's taste of flame"
P.threads.world_badlands = "the camps of the Badlands"
q(719, "A Dwarf and His Tools", "Badlands", 35, "uldaman", 2,
    "Shadowforge Dark Irons had attacked the excavation site north of Prospector Ryedol's camp and killed nearly everyone, his boss Hammertoe among them. One of the Dark Irons had Ryedol's lucky pick.",
    "Prospector Ryedol had barely escaped the Shadowforge attack on the dig. He wanted his supplies back, and above all his lucky pick.",
    "Ryedol called his helper a savior, glad someone had taught the Shadowforge a lesson.",
    "Back went the lucky pick to Ryedol, who gave his thanks.")
q(723, "Prospect of Faith", "Badlands", 40, "uldaman", 4,
    "Badly wounded, Hammertoe Grez wanted his amulet taken to Ryedol. He had sought the origins of the dwarves, and meant to stop the Shadowforge finding the scrolls.",
    "Hammertoe's amulet, his life's work, was for Prospector Ryedol to carry on.",
    "Ryedol said his spirits had been higher when he thought Hammertoe dead, and knowing for sure only hurt more. He would not let the death be in vain.",
    "Ryedol took the amulet and swore his friend would not die for nothing.", true)
q(724, "Prospect of Faith", "Ironforge", 40, "uldaman", 3,
    "Ryedol knew who could help, Historian Karnik in Ironforge. Karnik and Hammertoe had worked together to find the lost artifacts of Uldaman.",
    "The Shadowforge must have learned how much Hammertoe and Historian Karnik knew. Ryedol sent the amulet to Karnik.",
    "Grief for Hammertoe would have to wait, Karnik said. He began to show why the amulet was so valuable.",
    "Historian Karnik took Hammertoe's amulet and understood what was at stake.", true)
fallback("Prospect of Faith", "Badlands", "uldaman", "723,724",
    "Hammertoe Grez's amulet held the work of his life.",
    "Hammertoe's amulet had to reach someone who could carry on his search.",
    "The amulet passed on to the next hands.",
    "Hammertoe's work moved a step further.")
q(725, "Passing Word of a Threat", "Ironforge", 40, "uldaman", 3,
    "Karnik wanted Advisor Belgrum told what had happened, and how to proceed. Meanwhile he would speak with Hammertoe's spirit.",
    "Historian Karnik sent a note about the Shadowforge to Advisor Belgrum, while he sought counsel from Hammertoe's spirit.",
    "Belgrum always had time for Karnik's business, and opened the note.",
    "Advisor Belgrum began reading Karnik's note.", true)
q(726, "Passing Word of a Threat", "Ironforge", 40, "uldaman", 4,
    "Belgrum's eyes widened at the end of the note. On the king's authority, Karnik was to halt the Shadowforge's work in the Badlands, swiftly.",
    "Advisor Belgrum called the news evil tidings and sent word back to Karnik to act at once, in the king's name.",
    "Karnik knew how to bring the Shadowforge down. Their work in Uldaman could be slowed by striking their base, Angor Fortress.",
    "Historian Karnik turned the king's authority against Angor Fortress.", true)
fallback("Passing Word of a Threat", "Ironforge", "uldaman", "725,726",
    "Word of the Shadowforge's work in the Badlands passed between Ironforge's historians and advisors.",
    "Historian Karnik and Advisor Belgrum weighed the threat from the Shadowforge.",
    "The warning about the Shadowforge moved on.",
    "Ironforge prepared to answer the Shadowforge.")
q(762, "An Ambassador of Evil", "Ironforge", 44, "uldaman", 5,
    "Ragnaros himself had sent Ambassador Infernus to Angor Fortress to oversee the Shadowforge's search for artifacts in Uldaman. Karnik wanted the ambassador destroyed before the artifacts could be used against Ironforge.",
    "Ambassador Infernus, sent by Ragnaros, commanded the Shadowforge at Angor Fortress. Proof of his death was for Advisor Belgrum.",
    "Belgrum thanked the destroyer of Infernus in Ironforge's name. Karnik would be told, and aid sent to recover the dig site, and there was one more request in King Bronzebeard's name.",
    "Infernus was dead, and Advisor Belgrum promised aid to recover the Badlands excavation.")
hl(762, "Ambassador Infernus, sent by Ragnaros to Angor Fortress, was destroyed. Advisor Belgrum promised aid to recover the excavation.",
    "Ironforge gave thanks once the Shadowforge's fiery overseer at Angor Fortress was dead.")
q(738, "Find Agmond", "Badlands", 38, "uldaman", 3,
    "Prospector Agmond had run the Explorers' digs in the Badlands, and no one had heard from him in weeks. His report was wanted by Prospector Ironband.",
    "Ironband's last word of Agmond put him at the southernmost dig, past Angor Fortress.",
    "A broken, battered skeleton, picked clean, lay at the dig site. It had to be Agmond.",
    "Agmond was found dead at the southern dig.")

q(710, "Study of the Elements: Rock", "Badlands", 37, "lotwil", 2,
    "Lotwil Veriatus was building shackles of elemental binding, to let mages summon more powerful elementals. His first tests needed small stone shards from the lesser rock elementals to the west.",
    "Lotwil Veriatus wanted stone shards from the Badlands' lesser rock elementals, to test spells and gizmos for his shackles.",
    "Rather more sand than expected, Lotwil muttered, already recalculating friction with frost oil in mind.",
    "The stone shards would do nicely, Lotwil said.", true)
q(711, "Study of the Elements: Rock", "Badlands", 39, "lotwil", 2,
    "Lotwil thought his helper more able than all his apprentices. Next he needed large stone slabs from the stronger rock elementals.",
    "Larger rock elementals carried slabs big enough for Lotwil Veriatus's next tests.",
    "Amazed, Lotwil said he would have expected it to take half a dozen tauren to carry so many slabs.",
    "The stone slabs reached Lotwil, who called the work simply amazing.", true)
q(712, "Study of the Elements: Rock", "Badlands", 42, "lotwil", 3,
    "Bracers of rock binding from the greater elementals would let Lotwil gauge the strength of his shackles. He wanted five, since his robot Servo misplaced things.",
    "Lotwil Veriatus needed bracers of rock binding from the greater rock elementals southwest of his camp.",
    "A career as a research assistant, Lotwil suggested, would suit such intelligence, curiosity and strength.",
    "The bracers reached Lotwil, who wondered aloud how he would manage without such help.", true)
fallback("Study of the Elements: Rock", "Badlands", "lotwil", "710,711,712",
    "Lotwil Veriatus studied the Badlands' rock elementals for his shackles of binding.",
    "Lotwil's elemental shackles needed pieces of the Badlands' rock elementals.",
    "Lotwil's study of the rock elementals moved forward.",
    "Another set of elemental samples reached Lotwil.")
q(713, "Coolant Heads Prevail", "Badlands", 37, "lotwil", 2,
    "Frost oil cooled gears and helped enchantments hold. Lotwil needed a vial for his shackles, strong enough to keep the summoned elemental from killing them all, and Bro'kin in Alterac could teach the making.",
    "Lotwil Veriatus wanted a vial of frost oil for his shackles. A goblin friend, Bro'kin, in Alterac, knew the recipe.",
    "Stupendous, said Lotwil. If the enchantments did not last a century, he would give all his belongings to Servo.",
    "The frost oil reached Lotwil, who promised the Assembly's mages would be in awe.")
q(714, "Gyro... What?", "Badlands", 37, "lotwil", 2,
    "Lotwil was distracted by his work, offered a job if they ever met in Kharanos, and needed one last small part, a gyrochronatom.",
    "Lotwil Veriatus needed a gyrochronatom to finish his contraption.",
    "Grabbing the gyrochronatom, Lotwil declared himself almost done, then allowed it might take a lot longer.",
    "The gyrochronatom went into Lotwil's contraption, which was nearly finished, he said, perhaps.")
q(734, "This Is Going to Be Hard", "Badlands", 42, "lotwil", 2,
    "Lotwil needed a cog number five, and Lucien Tosselwrench had it.",
    "Lucien Tosselwrench was to hand over a cog number five for Lotwil's shackles.",
    "Parting with cog number five, Lucien said, was not going to end well.",
    "With a grim look, the engineer fetched cog number five.", true)
q(777, "This Is Going to Be Hard", "Badlands", 42, "lotwil", 2,
    "Lucien handed over the cog and went to wait behind cover.",
    "Lucien Tosselwrench gave up cog number five for Lotwil, then took cover.",
    "Lotwil called the cog perfect and set to work, ready to make more history.",
    "With the cog in place, Lotwil worked feverishly.", true)
q(778, "This Is Going to Be Hard", "Badlands", 45, "lotwil", 4,
    "The shackles were done. Lotwil meant to summon a powerful elemental, a blend of alchemy, engineering and the arcane.",
    "Lotwil Veriatus called Lucien and Servo to witness the summoning that would prove his shackles.",
    "Quite an ordeal, Lotwil admitted. He could not say what went wrong, but his magic had sent the creature back to its own plane, and he gave a token of thanks.",
    "The summoning went wrong, the elemental was sent home, and Lotwil gave a token for the trouble.", true)
fallback("This Is Going to Be Hard", "Badlands", "lotwil", "734,777,778",
    "Lotwil Veriatus's shackles of elemental binding neared completion.",
    "Lotwil and Lucien Tosselwrench prepared for a dangerous summoning.",
    "Lotwil's work on the shackles went on.",
    "The summoning at Lotwil's camp drew closer.")
hl(778, "Lotwil's shackles failed when the elemental came, and his magic sent it home. He gave a token for the ordeal.",
    "Lotwil Veriatus's great summoning went wrong, and the creature was banished.")
q(703, "Barbecued Buzzard Wings", "Badlands", 40, "badlands", 2,
    "Rigglefuzz had everything for his barbecued buzzard wings except the wings. Enough of them might win the recipe.",
    "Rigglefuzz's barbecued buzzard wings brought the hungry from miles away, he said, once he had the wings.",
    "Already tasting them, Rigglefuzz started on the wings and shared his recipe.",
    "The buzzard wings went on the fire, and the recipe was Rigglefuzz's thanks.")
q(705, "Pearl Diving", "Badlands", 37, "badlands", 2,
    "Rigglefuzz scared off Badlands wildlife with flash bombs, and was low on crushed blue pearl. The pearls came from the clams of the Vile Reef in Stranglethorn.",
    "A small goblin had to be tricky to survive in the Badlands. Rigglefuzz needed blue pearls from Stranglethorn for his flash bombs.",
    "Smash, mix, and the scavengers would be flashed, Rigglefuzz said.",
    "Soon the blue pearls would be flash bomb powder, Rigglefuzz said.")

q(4022, "A Taste of Flame", "Burning Steppes", 54, "cyrus", 3,
    "Cyrus Therepentous in the Burning Steppes said the Flight knew of the work done in the Searing Gorge. He demanded to see the molt.",
    "Cyrus Therepentous asked to see the molt from the Searing Gorge, sharp with insults.",
    "Examining the molt, Cyrus granted that its bearer was not entirely useless.",
    "The molt satisfied Cyrus Therepentous, after a fashion.", true)
q(4023, "A Taste of Flame", "Burning Steppes", 54, "cyrus", 3,
    "Anyone who sought the Flight had to prove their worth to Cyrus Therepentous.",
    "Cyrus Therepentous wanted proof of worth before he would deal with a mortal.",
    "Grudgingly, after examining the molt, Cyrus allowed that the mortal was not entirely useless.",
    "A molt served as proof for Cyrus Therepentous.", true)
q(4024, "A Taste of Flame", "Burning Steppes", 58, "cyrus", 4,
    "Cyrus craved a taste of Blackrock's fires. Bael'Gar, a being of pure flame born of Ragnaros, dwelt in Blackrock Depths, and the molt could draw out his inner flame once he was slain.",
    "Cyrus Therepentous wanted the inner fire of the flame being Bael'Gar, taken from his remains in Blackrock Depths with the molt.",
    "Snatching the fiery essence, Cyrus cried out in triumph, paid, and ordered its bearer out of his sight.",
    "With the inner flame in hand, Cyrus paid and sent its bearer away.", true)
fallback("A Taste of Flame", "Burning Steppes", "cyrus", "4022,4023,4024",
    "Cyrus Therepentous of the Burning Steppes tested those who sought the Flight.",
    "A molt was Cyrus Therepentous's proof of worth.",
    "Cyrus Therepentous judged what was brought to him.",
    "The trial set by Cyrus Therepentous moved forward.")
hl(4024, "Bael'Gar was slain in Blackrock Depths, and his inner flame went to Cyrus Therepentous, who seized it in triumph.",
    "Cyrus Therepentous had his taste of flame from Bael'Gar's remains.")
for _, id in ipairs({719, 723, 724, 725, 726, 762, 738, 710, 711, 712, 713, 714, 734, 777, 778, 703, 705, 4022, 4023, 4024}) do src(id) end

-- Batch W2-11: Alliance work in the Hinterlands and Feralas. Brohann's search
-- for the sunken temple through Aerie Peak and Rhapsody Shindigger, the rescue
-- of Sharpbeak, Latronicus's naga campaign (joining the alliance pack's
-- Solarsal thread verbatim), and Troyas Moonbreeze's stave and Morrow Stone.
-- Sharpbeak is found only by 2992/2993 and freed only by 2994.
P.threads.world_sharpbeak = "the search for Sharpbeak"
P.threads.world_troyas = "Troyas Moonbreeze's stave"
P.threads.alliance_solarsal = "the Hatecrest presence at Solarsal"
q(1448, "In Search of The Temple", "Stormwind City", 43, "atalai", 3,
    "Brohann Caskbelly's last task for the Explorers' League was to find the Temple of Atal'Hakkar, rumored to lie in the Swamp of Sorrows. Too frail to search on foot, he had looked from a gryphon and never found it.",
    "Old Brohann Caskbelly wanted the Swamp of Sorrows searched for the Temple of Atal'Hakkar, his final quest for the League.",
    "Brohann was amazed to hear the temple had sunk beneath the Pool of Tears, ringed by the green dragonflight. Something, he said, had gone terribly wrong.",
    "Word of the sunken temple and its green dragons reached Brohann, who called it an amazing discovery.")
q(1449, "To The Hinterlands", "The Hinterlands", 43, "atalai", 2,
    "Brohann had flown over the swamp with a gryphon pilot from Aerie Peak, who fell from his mount. He could not recall the pilot's name, but Falstad Wildhammer would.",
    "To learn what became of his lost pilot, Brohann sent the question to Falstad Wildhammer at Aerie Peak.",
    "Falstad had trolls coming out of the woodwork and little patience for chatter.",
    "Falstad Wildhammer of Aerie Peak told the visitor to make it snappy.")
q(1450, "Gryphon Master Talonaxe", "The Hinterlands", 43, "atalai", 2,
    "Falstad had no time for Explorers' League errands, and sent all questions about flight assignments to Gryphon Master Talonaxe.",
    "The aviary's flight records were Gryphon Master Talonaxe's business, Falstad said.",
    "Talonaxe remembered lending Brohann his best rider, Rhapsody Shindigger. His own father had helped excavate Uldaman, and he had a soft spot for the League.",
    "Gryphon Master Talonaxe recalled the rider sent with Brohann, Rhapsody Shindigger, and how things had gone downhill.")
q(1451, "Rhapsody Shindigger", "The Hinterlands", 43, "atalai", 2,
    "No one flew like Rhapsody Shindigger, but he took to drink after the flight with Brohann, and Talonaxe had to let him go. He had set up a brew camp east of the aerie.",
    "Talonaxe's old rider Rhapsody had become a drunk and left the aviary. He kept a brew camp to the east.",
    "Rhapsody hiccuped, complained that the visitor kept bobbing up and down, and felt the ground shake.",
    "At his brew camp, Rhapsody Shindigger was very drunk.")
q(1452, "Rhapsody's Kalimdor Kocktail", "The Hinterlands", 43, "atalai", 2,
    "Rhapsody would only tell what happened over the swamp with a stiff drink in him. His Kalimdor Kocktail needed roc gizzards from Tanaris and groddoc and ironfur livers from Feralas.",
    "Rhapsody Shindigger wanted a Kalimdor Kocktail before reliving that flight, made from livers and gizzards from far-off Kalimdor.",
    "Shivering at the memory of the swamp, Rhapsody set about distilling his drink.",
    "With his gizzards and livers, Rhapsody could brew his fierce drink at last.")
q(1469, "Rhapsody's Tale", "Stormwind City", 43, "atalai", 4,
    "Rhapsody had drunk a keg of stout before the flight, fallen from his gryphon into the water and been sucked down among trolls. He swam out with a troll souvenir for Brohann.",
    "Rhapsody Shindigger's account was for Brohann. The temple was down there, under the water, and he had a troll artifact to prove it.",
    "Brohann remembered the name at last. Rhapsody had known about the temple all along, and the Atal'ai artifact was quite a find.",
    "So the pilot had known all along, Brohann said, delighted with the Atal'ai artifact.")
hl(1469, "Rhapsody Shindigger had fallen from his gryphon into the sunken temple's waters and swum out with an Atal'ai artifact. Brohann called it quite a find.",
    "Brohann learned his drunken pilot had found the sunken temple all along.")

q(2988, "Witherbark Cages", "The Hinterlands", 45, "sharpbeak", 3,
    "Sharpbeak, heir of Aerie Peak's mightiest gryphon, had vanished while hunting with his parents. Talonaxe suspected trolls and wanted the cages of the two Witherbark villages searched.",
    "Gryphon Master Talonaxe feared the Witherbark trolls had taken the gryphon child Sharpbeak.",
    "Grim news, Talonaxe called it. Sharpbeak was meant to lead the next generation, and the fleet's spirit would suffer if he were lost.",
    "Sharpbeak was not in the Witherbark cages, and Talonaxe grew worried.")
q(2989, "The Altar of Zul", "The Hinterlands", 48, "sharpbeak", 3,
    "With Sharpbeak not among the Witherbark, the Vilebranch might have him. Talonaxe wanted the Altar of Zul searched.",
    "The Vilebranch trolls' Altar of Zul, on the western edge of their land, was the next place to look for Sharpbeak.",
    "Relief came over Talonaxe, since the Vilebranch made sacrifices at the altar. A greater task was still ahead.",
    "Sharpbeak was not at the Altar of Zul, which Talonaxe took as good news too.")
q(2990, "Thadius Grimshade", "Blasted Lands", 47, "sharpbeak", 3,
    "Thadius Grimshade, a diviner, had left Aerie Peak for darker knowledge, but Talonaxe thought him a Wildhammer at heart. A feather from Sharpbeak's nest might let him find the gryphon.",
    "Talonaxe sent a feather from Sharpbeak's nest to Thadius Grimshade in the mage tower of Nethergarde Keep.",
    "Grimshade recognized the feather of a fine gryphon, destined for great things if he survived, and prepared to help.",
    "Thadius Grimshade took the feather in Nethergarde's mage tower and agreed to search.")
q(2992, "The Divination", "Blasted Lands", 47, "sharpbeak", 3,
    "Grimshade meant to follow the bond between the feather and its owner. If the ritual went wrong, he warned, it was better to close one's eyes.",
    "Thadius Grimshade's divination would trace Sharpbeak through the feather from his nest.",
    "The ritual worked. Grimshade had seen Sharpbeak and knew how to find him.",
    "Grimshade's divination showed where Sharpbeak was.")
q(2993, "Return to the Hinterlands", "The Hinterlands", 47, "sharpbeak", 3,
    "Sharpbeak was caged on a cliff atop Jintha'Alor, and Vile Priestess Hexx of the Vilebranch held the key. Grimshade had done his part.",
    "Grimshade's news was for Talonaxe at Aerie Peak. Sharpbeak was a captive of the Vilebranch.",
    "Talonaxe found it unbearable that the Vilebranch had Sharpbeak, and called for a force to bring him back.",
    "Word that the Vilebranch held Sharpbeak reached Talonaxe, who meant to organize a rescue.")
q(2994, "Saving Sharpbeak", "The Hinterlands", 51, "sharpbeak", 5,
    "Talonaxe wanted Sharpbeak saved. The key to his cage was with Vile Priestess Hexx, at the top of Jintha'Alor in the heart of Vilebranch land.",
    "Sharpbeak's rescue meant fighting to the top of Jintha'Alor and taking Priestess Hexx's key.",
    "Swiftwind and Keenclaw had their child back and fussed over him like new parents. Talonaxe admitted it brought mist to an old dwarf's eyes.",
    "Home with his parents again, Sharpbeak was safe, and Talonaxe said Aerie Peak could never repay the deed.")
hl(2994, "Sharpbeak was freed from Jintha'Alor and returned to his parents, Swiftwind and Keenclaw. Talonaxe had mist in his eyes.",
    "Aerie Peak's gryphon heir Sharpbeak came home, and Talonaxe gave thanks.")

-- 3130 (Against the Hatecrest) stays unwritten by an earlier editorial decision:
-- tests/StoryEditorialFollowup.lua keeps the referral and its shared title without context.
q(2870, "Against Lord Shalzaru", "Feralas", 45, "solarsal", 4,
    "Royalty commanded the naga, and scouts had named one of the crueler, Lord Shalzaru. He had dug up an odd relic in a cave on the Isle of Dread.",
    "Latronicus wanted Lord Shalzaru dead and his strange relic brought back for study.",
    "Shalzaru's death would throw the naga into disarray, Latronicus said. He paid from the stronghold's treasury and had one more favor to ask.",
    "Lord Shalzaru was dead, and Latronicus called the naga threat more under control than ever.")
q(2871, "Delivering the Relic", "Feralas", 45, "solarsal", 3,
    "Latronicus could make nothing of Shalzaru's relic, but his wife Vestia, a priestess and scholar, might.",
    "Shalzaru's relic went to Vestia Moonspear, Latronicus's wife and one of the best scholars around.",
    "Vestia thought the relic did not belong to the Ruins of Solarsal and was not of naga design. Studying it would take time.",
    "Vestia Moonspear began studying the strange relic and offered a gift for its delivery.")
hl(2870, "Lord Shalzaru was killed on the Isle of Dread and his relic taken. Latronicus said the naga would be thrown into disarray.",
    "Latronicus Moonspear paid a bounty for Shalzaru's death.")
q(2982, "The High Wilderness", "Feralas", 44, "troyas", 2,
    "Angelas Moonbreeze worried about Troyas, who kept going alone to the ruins of the High Wilderness. Gordunni ogres held them.",
    "Angelas wanted the ogres in the High Wilderness thinned, to make the ruins safer for Troyas.",
    "Grateful, Angelas asked that Troyas not hear a word of it.",
    "The ogres were thinned, and Angelas kept it a secret from Troyas.")
q(2939, "In Search of Knowledge", "Darnassus", 47, "troyas", 2,
    "Troyas Moonbreeze had found a stave in the ruins of Feralas that seemed more than ordinary. His colleague Daryn Lightwind in Darnassus might know what it was.",
    "Troyas sent questions about his strange stave to Daryn Lightwind, a historian in Darnassus.",
    "Daryn muttered that Troyas always thought he had found something important. Anything of value had probably been hoarded by ogres or harpies long ago, but she let the visitor look.",
    "Daryn Lightwind doubted Troyas's find and offered only the run of her shelves.")
q(2940, "Feralas: A History", "Darnassus", 47, "troyas", 2,
    "A worn, yellowed history of Feralas looked like what Troyas needed. It had to be borrowed from Daryn properly.",
    "Daryn Lightwind's shelves held an old history of Feralas that might explain the stave.",
    "Lending it, Daryn decided, would cost a favor first.",
    "Lending the history, Daryn said, came with a price.")
q(2941, "The Borrower", "Tanaris", 48, "troyas", 2,
    "Daryn's latest fascination was the snapjaws of the Hinterlands, and above all a giant one named Gammerita. Curgle Cranklehop in Tanaris had made her a device to capture a picture.",
    "Daryn Lightwind wanted a picture of Gammerita, and sent a letter to the inventor Curgle Cranklehop in Tanaris.",
    "Taking the visitor for another of Daryn's interns, Curgle praised the historian and fetched the Super Snapper FX.",
    "Her new invention went to Daryn's helper, handed over by Curgle Cranklehop.")
q(2944, "The Super Snapper FX", "Darnassus", 48, "troyas", 2,
    "Curgle's Super Snapper FX took a picture at the push of a button. Gammerita was somewhere on the Hinterlands beaches.",
    "With Curgle's device, a snapshot of the giant snapjaw Gammerita could be taken for Daryn.",
    "Pleased, though she warned against getting too excited, Daryn turned to finding the history she had promised.",
    "Daryn Lightwind had her snapshot of Gammerita.")
q(2943, "Return to Troyas", "Feralas", 48, "troyas", 2,
    "Daryn handed over her old volume with a plea to take care of it, sure that Troyas was waiting.",
    "Daryn's old history of Feralas was on loan for Troyas Moonbreeze.",
    "Troyas was delighted to see the old history.",
    "The borrowed history reached Troyas at last.")
q(2879, "The Stave of Equinex", "Feralas", 50, "troyas", 4,
    "The stave might be the Stave of Equinex, key to the Equinex Monolith in the Ruins of Ravenwind. Four flames there, Samha, Imbel, Byltan and Lahassa, could energize it.",
    "Troyas believed his stave could open the Equinex Monolith, once charged with the essence of four ancient flames.",
    "Power rumbled through the energized stave. At the monolith, a small door opened, an artifact lay inside, and beams of light filled the ruins.",
    "The Equinex Monolith opened to the stave and gave up the artifact hidden within.")
q(2942, "The Morrow Stone", "Feralas", 50, "troyas", 4,
    "As the artifact left the monolith, the stave's power began to fade.",
    "The artifact from the Equinex Monolith was for Troyas Moonbreeze to study.",
    "Troyas named it the Morrow Stone. He did not yet know its purpose, but anything hidden away like that had to be significant.",
    "Troyas Moonbreeze identified the Morrow Stone and went on with his studies.")
for _, id in ipairs({1448, 1449, 1450, 1451, 1452, 1469, 2988, 2989, 2990, 2992, 2993, 2994, 2870, 2871,
    2982, 2939, 2940, 2941, 2944, 2943, 2879, 2942}) do src(id) end
for _, id in ipairs({2870, 2871}) do
    src(id, "LoreAllianceStories.lua thread alliance_solarsal (2866, 2867); hand-off 2026-11-05")
    P.questIDs[id].thread = "alliance_solarsal"
    P.questIDs[id].threadLabel = P.threads.alliance_solarsal
end
for _, id in ipairs({1448, 1449, 1450, 1451, 1452, 1469}) do P.questIDs[id].threadLabel = P.threads.world_atalai end

-- BEGIN WORLD3 PASS 20261105 (lane world3)
-- Exact IDs from corpus_vanilla_quests.txt, read in full (Quest / Progress /
-- Completion); people and places cross-checked against LoreForever quest entries
-- (facts only, own words). Checked by tests/WorldOvernight3.lua.
-- Batch W3-1: Stranglethorn's rebel camp (Thorsen's land mines and secret, Herod's
-- strongbox, the traitor Merle), Corporal Kaleb's crock pot, the Stone of the Tides
-- and Drizzlik's Excelsior boots. Merle is named by 330; no stage says what became
-- of him. Gazban is named as the Stone's finder; no stage claims his death.
P.threads.world_tides = "the Stone of the Tides"
P.threads.world_crockpot = "Corporal Kaleb's broken cooking pot"
P.threads.world_excelsior = "Drizzlik's Excelsior boots"
q(198, "Supplies to Private Thorsen", "Stranglethorn Vale", 32, "kurzen", 3,
    "Krazek in Booty Bay had a shipment for Lieutenant Doren's camp in the north. Troll attacks had stopped the usual deliveries, and Private Thorsen was to receive it.",
    "Doren's rebels were waiting on their supplies from Booty Bay. Krazek hired a courier and warned that a lost crate would be owed back to him.",
    "Private Thorsen opened the shipment to find the land mines he expected. He said they would help the camp hold out against Kurzen and his men.",
    "Thorsen was relieved the crate had not been touched. Its land mines would help the rebels defend themselves from Colonel Kurzen.")
q(215, "Jungle Secrets", "Stranglethorn Vale", 33, "kurzen", 4,
    "Private Thorsen had been saved from an ambush, and he knew how it looked. He said Lieutenant Doren had ordered him to rejoin Kurzen's men as a spy.",
    "Thorsen's attempt to get inside Kurzen's Compound had gone wrong. His mission was secret, and only Lieutenant Doren could explain it.",
    "Doren confirmed Thorsen's orders and asked for discretion. Only Yohwa, Thorsen and he had known of the mission, so someone else had betrayed it.",
    "Doren feared for Thorsen's life if word got out. The rebels had once been loyal to Kurzen, and now Doren suspected a traitor among them.")
q(328, "The Hidden Key", "Stranglethorn Vale", 37, "kurzen", 3,
    "Herod's records said nothing of Thorsen, but a small brass key was hidden in a ledger's binding. His notes mentioned a secure strongbox in the Stockpile.",
    "A brass key from Bookie Herod's ledger might open the strongbox his papers described. It lay in the caverns behind Kurzen's Compound.",
    "Herod's bronze-bound strongbox opened to the key. Inside he kept his more valuable coins and belongings.",
    "Bookie Herod's strongbox was found in the Stockpile, and the brass key fit its lock.")
q(329, "The Spy Revealed!", "Stranglethorn Vale", 37, "kurzen", 4,
    "Among Herod's valuables was a muddy note tracking Thorsen's patrols, contacts and habits. It was signed with a single letter, M.",
    "The note in Herod's strongbox could only have been written by someone close to Thorsen. Its writer was the traitor in the rebel camp.",
    "Lieutenant Doren took the note as the clue the rebels needed to find their traitor.",
    "Doren gave his thanks for the note signed M. With it, he meant to root out the spy.")
q(330, "Patrol Schedules", "Stranglethorn Vale", 37, "kurzen", 3,
    "Doren could not place the M, but its writer had shared Thorsen's patrol the week before, and Corporal Sethman kept the schedules.",
    "Whoever had walked patrol with Thorsen last week had written the note. Doren sent the question to Corporal Sethman.",
    "Sethman checked his schedule. Private Merle had shared every patrol with Thorsen the week before.",
    "Sethman found the name in his records. Private Merle had kept the same patrol times as Thorsen all week.")
q(331, "Report to Doren", "Stranglethorn Vale", 37, "kurzen", 4,
    "Sethman's answer pointed to Private Merle, and Lieutenant Doren was waiting to hear it.",
    "The patrol records named Merle. That name had to reach Doren before the traitor could do more harm.",
    "Lieutenant Doren was pained to learn that Merle had betrayed them. He had thought him a brave soldier, and was relieved the spy was found before Kurzen could use him.",
    "Doren had believed Merle's heart was true. Finding him out was still a relief, he said, for with such a spy the rebels would not last long.")
q(210, "Krazek's Cookery", "Stranglethorn Vale", 37, "crockpot", 2,
    "Corporal Kaleb did most of the cooking at the rebel camp. His mechanical pot from Booty Bay had saved him hours until it broke, and he wanted it taken back to Krazek.",
    "Kaleb's broken crock pot had to go back to Krazek, the goblin who had sold it to him in Booty Bay.",
    "Krazek found the steam charger rusted and the fobulator missing teeth. Of course he could fix it, he said, but there was always a price.",
    "Krazek recognized his own crock pot and agreed to repair it, for a price.")
q(627, "Favor for Krazek", "Stranglethorn Vale", 37, "crockpot", 2,
    "Krazek's price for fixing Kaleb's pot was bloodstone ore. A cave in Drywhisker Gorge, far north in the Arathi Highlands, held a low grade of it that he still valued.",
    "While he worked on the crock pot, Krazek wanted samples of bloodstone from the Arathi Highlands. Even poor bloodstone was valuable to those who knew its uses.",
    "Krazek called the bloodstone a big favor and paid for it.",
    "Krazek had his bloodstone from Drywhisker Gorge, and paid as promised.")
q(622, "Return to Corporal Kaleb", "Stranglethorn Vale", 37, "crockpot", 2,
    "Krazek had fixed the pot and added a steam whistle and a chopper for leg bones. He was sure its owner would be pleased.",
    "The repaired crock pot was ready to go back to Corporal Kaleb, with a few improvements of Krazek's own.",
    "Corporal Kaleb was delighted to have his pot back and could start dinner. He had heard that Booty Bay's goblins sometimes dragged drunk sailors onto slave boats.",
    "Kaleb thanked the courier and set about dinner. He hoped Booty Bay had not been too rough on them.")
q(616, "The Haunted Isle", "Stranglethorn Vale", 37, "tides", 3,
    "Krazek gathered rumors for Baron Revilgaz. Sailors in the tavern spoke of a haunted island off the coast, with water elementals and a raving goblin ghost.",
    "Krazek put little stock in ghost stories, but this one about an island off the coast was worth passing to Baron Revilgaz.",
    "Baron Revilgaz remembered something he had once read about the trolls. If Krazek's report was true, the Stone of the Tides might soon join his collection.",
    "Revilgaz heard of the haunted island and thought of the Stone of the Tides, a relic the trolls spoke of.")
q(578, "The Stone of the Tides", "Stranglethorn Vale", 37, "tides", 4,
    "Revilgaz suspected that Gazban, a goblin mage, had found the Stone of the Tides. He wanted the haunted island located, and gave a scrip for the Stormwind Library, where the old account of the Stone could be read.",
    "If water elementals and a goblin mage haunted the island, the baron thought the Stone of the Tides could be his. Someone had to find the island first.",
    "Baron Revilgaz was thrilled that the stories were true. To take the Stone, its curse would have to be broken, and that needed a wizard.",
    "Revilgaz now knew the island and its elementals were real. A mage would have to help him overcome the Stone's curse.")
q(601, "Water Elementals", "Stranglethorn Vale", 37, "tides", 3,
    "The Stone of the Tides made its bearer fade in and out of existence. A mage of Dalaran, Revilgaz hoped, could study the magic left on the water elementals' bracers.",
    "Gazban had summoned the island's water elementals. Their bracers carried magical residue that might show how to counter the curse.",
    "Revilgaz could not judge the bracers himself and would not leave Booty Bay to chat with old mages. They were to go to Dalaran.",
    "Baron Revilgaz had his bracers and was sure at least one would help. A mage in Dalaran would have to examine them.")
q(602, "Magical Analysis", "Alterac Mountains", 37, "tides", 3,
    "Revilgaz named Archmage Ansirem Runeweaver, whose knowledge he trusted. The mages of Dalaran were busy rebuilding their city, but few could resist a magical puzzle.",
    "The bag of water elemental bracers went to the ruins of Dalaran. Revilgaz had dealt with Ansirem Runeweaver before.",
    "Archmage Ansirem had once written a tome on the legends of the Gurubashi Empire. He knew the Stone well, and found residue on one bracer to analyze.",
    "Ansirem Runeweaver took an interest at once. At least one of the bracers held magic he could study.")
q(603, "Ansirem's Key", "Stranglethorn Vale", 37, "tides", 3,
    "Ansirem found that the Stone's power was amplified through an altar. An ancient troll dagger could overpower it, but he had given the blade to his daughter Catelyn, who ran off to Booty Bay to be a pirate.",
    "The altar could be broken with a troll dagger Ansirem had found in Stranglethorn. It now belonged to his daughter, Catelyn the Blade of Booty Bay.",
    "Catelyn the Blade no longer had the dagger. She had lost a knife fight to a Bloodsail Buccaneer, and he had taken the blade as spoils.",
    "Catelyn took the request badly. Once the best knife fighter in Booty Bay, she had lost her blade to one of the Bloodsail.")
q(610, "\"Pretty Boy\" Duncan", "Stranglethorn Vale", 39, "tides", 3,
    "Catelyn was surprised her father had not given up on her. Her dagger was with Pretty Boy Duncan of the Bloodsail Buccaneers.",
    "Duncan had knocked Catelyn out with a blow to the head and taken her knife. She wanted it back from him by force.",
    "Catelyn had her dagger back from Duncan. She joked that she would not be challenging her helper to a fight any time soon.",
    "Catelyn the Blade had her knife again. Beating Duncan, she admitted, showed more experience than she had first guessed.")
q(611, "The Curse of the Tides", "Stranglethorn Vale", 40, "tides", 5,
    "Catelyn lent her dagger and wanted it back afterward. She had heard of a sunken troll city near the haunted island, where the altar might lie.",
    "With Catelyn's knife, the altar that strengthened the Stone could be broken. She pointed the search to a sunken troll city off the coast.",
    "Baron Revilgaz had cleared a place and bought a stand for the Stone of the Tides. He admired how a tide seemed trapped within its surface.",
    "Revilgaz received the Stone of the Tides at last. It would have a place of prominence among his troll artifacts.")
q(575, "Supply and Demand", "Stranglethorn Vale", 31, "excelsior", 2,
    "Drizzlik, a leatherworker in Booty Bay, had an order from Director Riddlevox of the Tinkers' Union for a dozen Excelsior boots. Their basic shape needed river crocolisk skins.",
    "Drizzlik called himself the finest leathercrafter of the South Seas. Riddlevox's order for Excelsior boots began with crocolisk skins from the northern rivers.",
    "Drizzlik accepted the skins for the boots' inner layer. If they were too stiff, tiger blood would soften them.",
    "Drizzlik had his skins. Their quality mattered little inside the boots, as long as they were comfortable.")
q(577, "Some Assembly Required", "Stranglethorn Vale", 36, "excelsior", 2,
    "Drizzlik's boots needed more filling than the first skins gave. The thicker, cheaper hides of the crocolisks around Lake Nazferiti would do, Drizzlik decided.",
    "Nobody would see the inner layers, Drizzlik reasoned, so cheaper skins from Lake Nazferiti would do.",
    "Drizzlik compared his boots to sausages. It was safer, he said, not to ask too carefully what was inside.",
    "Drizzlik filled out the boots and promised only the finest ingredients, so long as no one looked closely.")
q(628, "Excelsior", "Stranglethorn Vale", 38, "excelsior", 3,
    "Only the skin of an elder saltwater crocolisk would do for the outer layer. The elders came out only to defend the other crocolisks.",
    "An elder saltwater crocolisk's hide would be the canvas for Drizzlik's Excelsior designs.",
    "Drizzlik could ship Riddlevox's order to Undermine on the next boat, ahead of schedule. He gave a pair of the extras as thanks.",
    "Riddlevox's boots were finished early. Drizzlik handed over a spare pair, on the house.")
hl(215, "Private Thorsen had been spying on Kurzen at Doren's order. Doren confirmed it and saw that someone else must have betrayed the secret.",
    "Lieutenant Doren confirmed Thorsen's secret mission. Only three had known of it, so the rebels had a traitor.")
hl(331, "Lieutenant Doren learned that Private Merle was the traitor. He grieved for a soldier he had trusted, and was relieved the spy was found.",
    "Doren was pained that Merle had betrayed the rebels, and relieved to have found him out before Kurzen could use him.")
hl(578, "Baron Revilgaz learned that the haunted island was real. The Stone of the Tides was there, behind a curse only a wizard could help with.",
    "Revilgaz was thrilled that the island's stories were true, and began looking for a mage to break the Stone's curse.")
hl(611, "Baron Revilgaz received the Stone of the Tides, freed from its altar with Catelyn's dagger. It would have a place of honor among his troll artifacts.",
    "The Stone of the Tides reached Revilgaz, who had already bought a stand for it. A tide seemed trapped within its surface.")
for _, id in ipairs({198, 215, 328, 329, 330, 331, 210, 627, 622, 616, 578, 601, 602, 603, 610, 611, 575, 577, 628}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-2: the Missing Diplomat in Theramore (after Slim's confession, 1250,
-- so the king may be named; Hendel's arrest stays with 1324 above), the Horde and
-- Reclaimers' referrals to Desolace (1362, 1453), the Gizelton caravan, Leftwitch's
-- reagents for Kreldig Ungor, and Brother Anton's Scarlet recruitment. 1052 ends
-- with Raleigh the Devout in Southshore; it never claims a welcome at the monastery.
P.threads.world_gizelton = "the Gizelton caravan"
P.threads.world_scarletpath = "Brother Anton's Scarlet recruitment"
local MD3 = "diplomat"
q(1264, "The Missing Diplomat", "Dustwallow Marsh", 33, MD3, 4,
    "Mikhail knew the Kul Tiras marines who came to his tavern on payday, and thought Hendel was among them. If Elling's name was dropped, Commander Samaul in Theramore could find him.",
    "Hendel was likely one of Theramore's marines. Mikhail sent the search to Commander Samaul, who was loyal to Proudmoore but would help discreetly for Elling.",
    "Commander Samaul led Lady Proudmoore's forces in Theramore. He was busy, but offered to answer questions, and warned of the black dragons in the south of the swamp.",
    "Samaul introduced himself and agreed to help, briefly. Beyond the city, he warned, ogres, orcs, murlocs and black dragons waited in the marsh.", true)
q(1265, "The Missing Diplomat", "Dustwallow Marsh", 35, MD3, 4,
    "Samaul knew Hendel, and did not like that Elling had sent someone to him. He had a duty to protect the land, but said Hendel was posted at the first tower outside Theramore.",
    "Commander Samaul guessed that Elling's business was troubling. He pointed the way to the first tower outside the city, where Hendel had been stationed.",
    "Hendel was not at the tower. Lady Proudmoore had already learned of the matter from other sources, and offered help to find him and bring him to justice.",
    "Lady Proudmoore's people already knew why Hendel was wanted. They offered to say where he was, so he could face justice.", true)
q(1266, "The Missing Diplomat", "Dustwallow Marsh", 36, MD3, 4,
    "Private Hendel was west of the tower, guarding Theramore's infiltrators while they rested. They had been watching the Horde at Brackenwall.",
    "Hendel was on guard among the tents along the road, west of the city. Samaul promised to catch up soon.",
    "Private Hendel greeted the visitor as a wandering citizen. He warned of ogres and spoke of the slow search for a Horde base in the swamp.",
    "Hendel was found at the infiltrators' tents. He told the visitor to keep the questions short and watch for ogres.", true)
q(1362, "The Kolkar of Desolace", "Desolace", 32, "centaur", 3,
    "The Kolkar centaur had spread from Desolace into the Barrens, but their strength lay in Desolace. Regthar had sent Felgur Twocuts to Ghost Walker Post to learn how to deal with them.",
    "Regthar Deathgate wanted the Kolkar threat ended at its source. His agent Felgur Twocuts was gathering intelligence in Desolace.",
    "Felgur Twocuts welcomed someone sent by Regthar. He did not know how the campaign against the centaur would end, only that it would be long.",
    "Felgur said the struggle with the centaur would be long. He offered a seat and began to explain.")
q(1453, "Reclaimers' Business in Desolace", "Desolace", 33, "reclaimers", 2,
    "Reclaimers Inc. had work in Desolace. Its man, Kreldig Ungor, was holed up at Nijel's Point, a small camp hidden in the northern mountains.",
    "Kreldig Ungor needed hands at Nijel's Point. The Reclaimers had sent word that there was a good week's honest work for anyone who went.",
    "Kreldig Ungor was glad to see that the Reclaimers had both work and willing helpers. Everyone had lost something, he said, and for the right price they could find it.",
    "Kreldig welcomed the new hand. The Reclaimers, as he put it, found what people had lost, for the right price.")
q(5821, "Bodyguard for Hire", "Desolace", 35, "gizelton", 3,
    "Cork Gizelton and Rigger stopped their kodo caravan whenever they heard the Kolkar war drums. This time Cork offered pay for an escort past the Kolkar village.",
    "The Gizelton caravan needed a guard past the Kolkar centaur. Dead traders made no profit, Cork said, and the reward waited with Smeed Scrabblescrew.",
    "Smeed Scrabblescrew paid for the caravan's safe passage, grumbling at the cost. If he were taller, he said, he would ride shotgun himself.",
    "Smeed paid the guard and grumbled about the price. He would have shown the centaur himself, he claimed, with a bigger gun.")
q(5943, "Gizelton Caravan", "Desolace", 38, "gizelton", 3,
    "Rigger Gizelton and Cork had started the caravan to make a fortune. The demons of Mannoroc Coven usually ignored them, but this time the kodos were spooked.",
    "Rigger needed his caravan guarded past Mannoroc Coven. Once it was through, Smeed at Scrabblescrew's Camp would pay.",
    "Smeed paid again for the Gizelton Caravan's protection. As long as the brothers kept paying for his kodos, he cared little how they ran their business.",
    "Smeed Scrabblescrew paid the escort's wage. Cork and Rigger, he noted, made only a gold piece a week.")
q(1458, "Reagents for Reclaimers Inc.", "Desolace", 33, "reclaimers", 2,
    "Kreldig was collecting reagents for Leftwitch, a gnome mage in Kharanos, though Roetten had left him short-handed. The list began with Hatefury satyr horns and claws.",
    "Leftwitch's reagent list had come to Desolace with the Reclaimers, and Kreldig started with the satyr to the east.",
    "Kreldig was not sure the horns and claws were the quality Leftwitch wanted. The mage, he said, should have specified.",
    "Kreldig took the satyr horns and claws and turned to the next item on Leftwitch's list.", true)
q(1459, "Reagents for Reclaimers Inc.", "Desolace", 35, "reclaimers", 2,
    "Leftwitch was particular. The venom had to come from scorpashi, and the hide from an aged kodo rather than a dying or ancient one.",
    "Next on Leftwitch's list were scorpashi venom and aged kodo hide. Mages, in Kreldig's view, wanted strange things.",
    "Kreldig said the help was halving his time in Desolace. Once he was home in Ironforge, he would buy an ale.",
    "Kreldig welcomed the venom and hides. He was already thinking of warming his feet in Ironforge.", true)
q(1466, "Reagents for Reclaimers Inc.", "Desolace", 40, "reclaimers", 3,
    "The last of Leftwitch's reagents came from the demons of Mannoroc Coven. He wanted brains from mana eaters, wings from nether maidens and blood from doomwarders.",
    "Kreldig warned that the final list would take longer, since it meant fighting demons. He would understand anyone who passed on it.",
    "Kreldig could hardly believe the demon reagents had been gathered. He meant to tell Roetten about it in Ironforge.",
    "Kreldig praised anyone who could take on demons for a mage's experiments and come back whole.", true)
q(1467, "Reagents for Reclaimers Inc.", "Ironforge", 40, "reclaimers", 2,
    "Payment for Leftwitch's reagents waited with Roetten in Ironforge. Kreldig sent the package there and promised a good word.",
    "Roetten Stonehammer would pay for the package from Desolace. Kreldig expected to follow home soon.",
    "Roetten received Leftwitch's package and paid. Reclaimers Inc. always paid well for a hard week's work, he said.",
    "Roetten was glad to have the package off his hands. He paid the promised wage for the week's work.", true)
fallback("Reagents for Reclaimers Inc.", "Desolace", "reclaimers", "1458,1459,1466,1467",
    "Kreldig Ungor was gathering reagents in Desolace for Leftwitch, a gnome mage in Kharanos.",
    "Leftwitch's reagent list kept the Reclaimers busy in Desolace.",
    "Kreldig had more of Leftwitch's reagents.",
    "Another part of Leftwitch's list was done.")
q(6141, "Brother Anton", "Desolace", 39, "scarletpath", 3,
    "Brother Crowley's brother in arms, Anton, had heard of undead in Desolace and sailed there at once. He wanted brave helpers at Nijel's Point.",
    "Brother Anton of the Scarlet Crusade was hunting undead in distant Desolace. Crowley in Stormwind sent help his way.",
    "Brother Anton had heard that aid was coming from the east. He asked whether the newcomer had come to help the Crusade, and began to explain.",
    "Anton welcomed the help from the east and began to explain what the Crusade needed.")
q(261, "Down the Scarlet Path", "Desolace", 39, "scarletpath", 3,
    "Brother Anton saw the Scourge as an evil that had to be stopped. To prove allegiance to the Scarlet Crusade, he asked for the undead ravagers of the Valley of Bones to be destroyed.",
    "The Crusade would embrace those who fought the Scourge, Anton said. His test lay in the Valley of Bones to the south.",
    "Brother Anton commended the resolve shown against the ravagers. Perhaps, he suggested, the newcomer's path lay with the Crusade.",
    "Anton said the Scarlet Crusade commended the work in the Valley of Bones.", true)
q(1052, "Down the Scarlet Path", "Hillsbrad Foothills", 40, "scarletpath", 3,
    "Anton was proud of the Crusade's strongholds from Hearthglen to Tirisfal. The true threat lay in Lordaeron, and he sent a sealed commendation to Raleigh the Devout in Southshore.",
    "Brother Anton's letter would earn a place of honor at the Scarlet Monastery, he said. The letter was for Raleigh the Devout in Southshore.",
    "Raleigh the Devout read the letter with dismay. Brother Anton, he said, was still spreading the word of the Scarlet Crusade.",
    "Raleigh was startled to hear of Brother Anton. He seemed far less pleased with the Crusade than Anton was.", true)
fallback("Down the Scarlet Path", "Desolace", "scarletpath", "261,1052",
    "Brother Anton of the Scarlet Crusade was recruiting in Desolace.",
    "Anton's recruitment for the Scarlet Crusade began with the undead of Desolace.",
    "Brother Anton's recruitment moved a step further.",
    "The matter of Anton's Scarlet Crusade went on.")
hl(1266, "Private Hendel was found at the infiltrators' camp west of Theramore. He took the visitor for a wandering citizen.",
    "The search for Hendel reached a camp of Theramore infiltrators, where the private stood guard.")
hl(1466, "Kreldig Ungor could hardly believe Leftwitch's demon reagents had been gathered from Mannoroc Coven. He meant to praise the work to Roetten.",
    "The last of Leftwitch's list came from the demons of Mannoroc Coven. Kreldig promised a good word in Ironforge.")
hl(1052, "Brother Anton's commendation reached Raleigh the Devout in Southshore, who was dismayed to hear Anton still spoke for the Crusade.",
    "Raleigh the Devout read Anton's sealed letter in Southshore. He did not share Anton's pride in the Scarlet Crusade.")
for _, id in ipairs({1264, 1265, 1266, 1362, 1453, 5821, 5943, 1458, 1459, 1466, 1467, 6141, 261, 1052}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end
for _, id in ipairs({1264, 1265, 1266}) do P.questIDs[id].source[4] = "starters3 hand-off 2026-11-05: Theramore stages after Slim's confession (1250)" end

-- Batch W3-3: Searing Gorge. Locheed's outhouse and Krinkle's ledger, Pebblebitty's
-- doubt over Margol's horn, the Suntara Stones (Dorius's letter, the dying
-- archaeologist, Thorius's discovery), Kalaran's account, and the Thorium
-- Brotherhood's postings (Scrange, Hansel Heavyhands, Lolo's bounty). The brother's
-- betrayal is told only by 3566's completion; its why[1] and the thread label stay
-- neutral. 3481 (Trinkets...) has no outcome worth telling and stays out.
P.threads.world_locheed = "Locheed's locked outhouse"
P.threads.world_suntara = "the Suntara Stones"
P.threads.world_thoriumpoint = "the Thorium Brotherhood's postings in the Gorge"
P.threads.world_margol = "Margol's horn and the Searing Gorge gate"
q(4449, "Caught!", "Searing Gorge", 45, "locheed", 2,
    "A dwarf named Locheed had hidden in an outhouse from the Dark Iron geologists, and they had locked him in. He wanted them taught a lesson, and some silk cloth.",
    "Locked in a Dark Iron outhouse, Locheed asked for revenge on the geologists. He also wanted silk cloth, for reasons he would not explain.",
    "Locheed liked the feel of the silk. Then he remembered the geologists, and said the help gave him time to finish up in there.",
    "Locheed was delighted with the silk cloth. The beaten geologists seemed to come second.")
q(4450, "Ledger from Tanaris", "Tanaris", 46, "locheed", 2,
    "Locheed had taken a job in Tanaris for Krinkle Goodsteel, who wanted materials from the Searing Gorge and elsewhere. He slid Krinkle's ledger under the outhouse door.",
    "Krinkle Goodsteel's ledger came from under Locheed's door. The goods on its list had to be gathered and carried to Gadgetzan.",
    "Krinkle Goodsteel had expected to be asked to craft something. Instead every item on the list had been brought, and Krinkle offered a reward.",
    "Krinkle checked the goods against the ledger and found everything there, then paid despite a busy day.")
q(4451, "The Key to Freedom", "Searing Gorge", 47, "locheed", 3,
    "A small brass key turned up, marked Dark Iron Outhouse and warning against copies. Where it belonged was not yet clear.",
    "The words scratched on the brass key named a Dark Iron outhouse.",
    "Locheed knew the Dark Irons had hidden the key after locking him in. He asked for the key to be turned so he could get out.",
    "Locheed could hardly believe the key had been found. Freedom was a turn of the lock away.")
q(3181, "The Horn of the Beast", "Loch Modan", 48, "margol", 3,
    "Margol's giant horn held a broken axe head marked as the property of Mountaineer Pebblebitty. It shattered when pulled free.",
    "The horn bore Pebblebitty's name on the axe head lodged in it. That mountaineer guarded the gate between Loch Modan and the Searing Gorge.",
    "Pebblebitty called the horn a fake. He had faced Margol, he said, and her horn was eight times larger.",
    "Mountaineer Pebblebitty was not fooled, or thought he was not. The horn, he decided, came from some Barrens stormsnout.")
q(3367, "Suntara Stones", "Searing Gorge", 48, "suntara", 3,
    "Dorius Stonetender lay badly hurt in the Searing Gorge, bleeding inside. He begged for help getting back to Ironforge.",
    "Injured and dizzy, the dwarf excavator wanted to reach Ironforge.",
    "Dorius was shot before he got far. He dropped a singed letter when he was hit.",
    "Dorius Stonetender was shot before he could reach safety, and a letter fell from him.", true)
q(3368, "Suntara Stones", "Ironforge", 48, "suntara", 4,
    "Dorius's letter was meant for his brother. It said the Dark Irons held the Suntara Stones, and that their leader, Lathoric the Black, used them to enslave his excavation team.",
    "The singed letter called itself a dead man's final wish. Dorius's team had been taken to the Cauldron to build something called Obsidion.",
    "Curator Thorius wept over his brother's letter. Then he vowed, in the name of the Light, that Dorius would have his wish.",
    "Thorius read the letter and dried his face. His brother's last wish would be honored, he swore.", true)
fallback("Suntara Stones", "Searing Gorge", "suntara", "3367,3368",
    "Dorius Stonetender's excavation in the Searing Gorge concerned the Suntara Stones.",
    "The Suntara Stones and Dorius Stonetender's excavation team were in Dark Iron hands.",
    "Word of Dorius Stonetender's excavation went on toward Ironforge.",
    "The matter of the Suntara Stones moved on.")
q(3372, "Release Them", "Searing Gorge", 52, "suntara", 3,
    "A dying archaeologist said the Suntara's power kept the workers at their tasks even after their bodies gave out. Its altar needed a relic guarded by the Twilight's Hammer.",
    "The altar of Suntara was the key to freeing the workers. Its relic lay with the Twilight's Hammer in the hills above the cave.",
    "The mysterious artifact was set on the altar of Suntara.",
    "Placing the relic on the altar answered the archaeologist's plea.")
q(3566, "Rise, Obsidion!", "Ironforge", 52, "suntara", 5,
    "The dying archaeologist gasped that it had all been a trap. He begged for its maker to be killed, for the team and for Thorius.",
    "A last plea came from the archaeologist. Lathoric the Black and Obsidion were to die, and Thorius would need proof.",
    "Curator Thorius turned white at the proof. His own brother had set it all up and betrayed Ironforge, and he feared no one was safe from the will of Ragnaros.",
    "Thorius saw that his brother had betrayed him and Ironforge. If so noble a man could be turned by the Old Gods' influence, he said, no one was safe.")
q(3441, "Divine Retribution", "Searing Gorge", 48, "retribution", 3,
    "Kalaran Windblade's father had died at the hands of the Cauldron's filth. Stormwind's magistrate had ignored his plea for justice.",
    "Kalaran wanted vengeance for his father, with only an oafish squire beside him. He asked to be heard out.",
    "Kalaran Windblade finished his account and asked if his listener was ready to act.",
    "Kalaran had told of his loss and asked for help with his revenge.")
q(7728, "STOLEN: Smithing Tuyere and Lookout's Spyglass", "Searing Gorge", 48, "thoriumpoint", 2,
    "The Thorium Brotherhood had lost a smithing tuyere and a lookout's spyglass. They blamed jealous Dark Iron dwarves.",
    "A posting asked for the stolen tuyere and spyglass to be returned to Scrange. The tuyere could not be replaced.",
    "Taskmaster Scrange paid the reward for the tuyere and spyglass.",
    "Scrange had the stolen tools back and paid the promised reward.")
q(7729, "JOB OPPORTUNITY: Culling the Competition", "Searing Gorge", 48, "thoriumpoint", 2,
    "Taskmaster Scrange wanted the Dark Iron taskmasters and slavers of the Gorge cut down. His notice said to come back when the clothes were bloody enough.",
    "Scrange's posting called it culling the competition. His targets were the Dark Iron slavers and taskmasters.",
    "Scrange weighed the bloodied clothes at fifteen point nine pounds and called it a possible record.",
    "Scrange congratulated the new hire on a possible record for blood and gut weight.")
q(7723, "Curse These Fat Fingers", "Searing Gorge", 49, "thoriumpoint", 2,
    "Hansel Heavyhands claimed the climate had swollen his fingers like blood sausages. Someone else would have to pound the heavy war golems of the Gorge.",
    "With his fingers too fat to fight, Hansel handed out his orders. First were the Gorge's heavy war golems.",
    "Hansel was pleased and gave a little present for the trouble.",
    "Hansel was pleased with the work against the golems and handed over a gift.")
q(7724, "Fiery Menace!", "Searing Gorge", 49, "thoriumpoint", 2,
    "Greater lava spiders were causing trouble, and Overseer Oilfist said they shot fire from an unfortunate place. They had to be killed, Hansel decided, by someone else.",
    "Hansel's next job was the greater lava spiders. He had hoped for a moment to rest.",
    "Hansel sneezed and blamed the cold. He had wanted to know where the fire really came out.",
    "Hansel Heavyhands was told of the spiders and complained he was catching a cold.")
q(7727, "Incendosaurs? Whateverosaur is More Like It", "Searing Gorge", 49, "thoriumpoint", 3,
    "Scrange and Burninate wanted the incendosaurs of the Slag Pit cleared so teams could explore its lava pools. His bunions, Hansel said, kept him from doing it himself.",
    "Expeditions into the Slag Pit's lava pools could not start until the incendosaurs were dealt with. With bunions like his, the job went to someone else.",
    "Hansel rubbed his aching feet. Since no luffa had been found, he did not push the matter.",
    "Hansel Heavyhands complained about his feet when the incendosaurs were cleared.")
q(7701, "WANTED: Overseer Maltorius", "Searing Gorge", 50, "thoriumpoint", 4,
    "Overseer Oilfist wanted Maltorius dead. He was a rogue Thorium Brotherhood agent and now commanded the Dark Iron crew of the Slag Pit.",
    "A bounty in the Cauldron named Overseer Maltorius a traitor to the Thorium Brotherhood. His head would earn the reward from Lookout Captain Lolo Longstriker.",
    "Lolo Longstriker, quite drunk, said Maltorius looked better without the rest of him, and paid the bounty.",
    "Captain Lolo had never thought to see that ugly face again, and paid between hiccups.")
hl(3368, "Curator Thorius read his brother Dorius's letter about the Suntara Stones and his enslaved team, then vowed to honor the dead man's wish.",
    "Dorius's letter reached his brother Thorius in Ironforge. He wept, then swore that Dorius would have his wish.")
hl(3566, "Thorius saw the proof and turned white. His own brother had set the trap and betrayed Ironforge.",
    "Curator Thorius learned that his brother had set everything up. He feared the Old Gods' influence was still strong.")
hl(7701, "Overseer Maltorius, the Thorium Brotherhood's traitor, was dead. Lolo Longstriker paid the bounty between hiccups.",
    "Lookout Captain Lolo Longstriker paid the bounty on Maltorius, glad never to see that face again.")
for _, id in ipairs({4449, 4450, 4451, 3181, 3367, 3368, 3372, 3566, 3441, 7728, 7729, 7723, 7724, 7727, 7701}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-4: Desolace's coast and valleys (Mai'Lahii, Drulzegar's revenge on the
-- naga, Nataka's fish, Taiga Wisemane and the Hand of Iruxos, Azore's Book of the
-- Ancients, the Brimbuzzles, Bibbly's bones) and the Burning Steppes roads
-- (Archesonus's ruins, Oralius, Goretooth's postings, Lotwil and the G.L.A. shard).
-- 5381 recovers the Demon Box; only 5581 banishes the portals.
P.threads.world_iruxos = "the Hand of Iruxos"
P.threads.world_shadowprey = "the work around Shadowprey Village"
P.threads.world_brimbuzzle = "the Brimbuzzles' trade with the centaur"
P.threads.world_thaurissanruins = "the history of Thaurissan"
q(6142, "Clam Bait", "Desolace", 35, "shadowprey", 2,
    "Mai'Lahii at Shadowprey Village loved to fish, and swore by soft-shelled clam meat as bait. The clams lay around a wrecked ship off the northern coast.",
    "Soft-shelled clams from the wreck up north made the best bait, according to Mai'Lahii.",
    "Mai'Lahii said the witch doctor had prescribed fishing for a headache. With the clam meat, Mai'Lahii felt better already.",
    "Mai'Lahii had fresh bait and a cure for a headache, as the witch doctor had promised.")
q(6143, "Other Fish to Fry", "Desolace", 36, "shadowprey", 3,
    "Drulzegar Skraghook's crew had fished near Ranazjar Isle until the naga attacked one morning. Only Drulzegar survived, and the guilt drove him to seek revenge.",
    "Naga had killed every member of Drulzegar's fishing crew but him. He wanted them punished at Ranazjar Isle.",
    "Drulzegar was glad to hear the naga had been beaten, though his heart still felt empty. He swore to spend his life seeing them all killed.",
    "Drulzegar Skraghook paid as he had promised. The news was sweet to him, but did not fill the loss of his crew.")
q(5386, "Catch of the Day", "Desolace", 37, "shadowprey", 2,
    "Nataka Longhorn at Ghost Walker Post missed the smell of cooked fish. The centaur kept Nataka too busy to visit Jinar'Zillen, the fisherman at Shadowprey Village.",
    "Shadowprey's trolls caught the best fish in Desolace. Bloodbelly fish from Jinar'Zillen were Nataka's favorite.",
    "Nataka Longhorn called the fish-bearer a savior. The Bloodbelly fish looked almost good enough to eat raw.",
    "Nataka was delighted with the Bloodbelly fish and paid with a choice of items.")
q(5381, "Hand of Iruxos", "Desolace", 38, "iruxos", 3,
    "Taiga Wisemane said the Burning Blade used the Hand of Iruxos to open demon portals at Mannoroc Coven. It lay in their Demon Box, behind a red crystal in Thunder Axe Fortress.",
    "A demon pick could break the red crystal guarding the Burning Blade's Demon Box. The box held the Hand of Iruxos, and Taiga wanted both.",
    "Taiga Wisemane received the Demon Box and opened it to reveal the Hand of Iruxos.",
    "Taiga took the Demon Box from Thunder Axe Fortress and prepared to open it.")
q(5581, "Portals of the Legion", "Desolace", 38, "iruxos", 4,
    "The Hand of Iruxos was a gruesome thing, and it was needed to banish the demon portals at Mannoroc Coven. Their guardians, Taiga warned, would fight.",
    "With the Hand of Iruxos, the portals at Mannoroc Coven could be closed. The demons' road into the world had to be shut.",
    "Taiga Wisemane commended the work. The portals were banished, and Azeroth was safer for it.",
    "Taiga said the closing of the Mannoroc portals had greatly helped the fight against the demons.")
q(6027, "Book of the Ancients", "Desolace", 38, "shadowprey", 3,
    "Azore Aldamort gave the Gem of the Serpent, to be set in the hand of the Serpent Statue on Ranazjar Isle. It would summon the guardian of an ancient naga tome.",
    "An ancient naga tome held secrets kept for centuries. Its guardian answered only to the Gem of the Serpent.",
    "Azore Aldamort received the long-lost naga tome and promised it to the high council.",
    "Azore welcomed the naga tome and thanked its bearer as a hero should be thanked.")
q(6132, "Get Me Out of Here!", "Desolace", 39, "brimbuzzle", 3,
    "Melizza Brimbuzzle had gone to the Valley of Spears to do business with the Maraudine centaur. They had other ideas, and she heard talk of firewood for their cookpot.",
    "Melizza was caught among the Maraudine and wanted out. Her brother Hornizz, at the camp by the kodo graveyard, would pay.",
    "Hornizz Brimbuzzle thanked the rescuer for getting his sister out of her jam. He expected she had already found a new one.",
    "Hornizz was glad Melizza had been brought out of the Valley of Spears, for now.")
q(6134, "Ghost-o-plasm Round Up", "Desolace", 39, "brimbuzzle", 2,
    "Hornizz Brimbuzzle thought the Magram would pay well for ghost energy from the Valley of Bones. His ghost magnets drew the spirits to the Dead Goliaths.",
    "The Magram feared the ghosts in the Valley of Bones, so Hornizz meant to sell them the ghost-o-plasm.",
    "Hornizz admired the slimy ghost-o-plasm. It would be worth a fortune, if the centaur could be convinced what it was.",
    "Hornizz Brimbuzzle took the ghost-o-plasm and began to plan the sale.")
q(5501, "Bone Collector", "Desolace", 39, "brimbuzzle", 2,
    "Bibbly F'utzbuckle sold kodo bones to customers making furniture, instruments and blasting powder. A caravan carried them on to Shadowprey Village.",
    "Ten more kodo bones from the graveyard would give Bibbly a career high before the caravan arrived.",
    "Bibbly F'utzbuckle was overjoyed, and already pictured making the cover of Goblin'preneur.",
    "Bibbly had his bones and dreamed of being the richest goblin in the world.")
q(3701, "The Smoldering Ruins of Thaurissan", "Ironforge", 54, "thaurissanruins", 3,
    "Royal Historian Archesonus wanted information from the smoldering ruins of Thaurissan. Relics were said to litter them, guarded by Thaurissan's assassins.",
    "The Royal Historian sent a search into the ruins of Thaurissan in the Burning Steppes, warning of the guardians who kept their secrets.",
    "Archesonus found that the gathered information explained a great deal about Thaurissan, with much more still to learn.",
    "Archesonus was pleased with the relics from the ruins. There was more to learn about Thaurissan.", true)
q(3702, "The Smoldering Ruins of Thaurissan", "Ironforge", 54, "thaurissanruins", 3,
    "Royal Historian Archesonus offered a short history of the Dark Iron dwarves.",
    "A full account of Thaurissan's history was on offer from the Royal Historian.",
    "Archesonus finished the account of Thaurissan and was ready to proceed.",
    "Archesonus told the history of the Dark Irons to its end.", true)
fallback("The Smoldering Ruins of Thaurissan", "Burning Steppes", "thaurissanruins", "3701,3702",
    "Royal Historian Archesonus studied the ruins of Thaurissan in the Burning Steppes.",
    "The Dark Iron past lay in the smoldering ruins of Thaurissan.",
    "Archesonus's study of Thaurissan went on.",
    "The Royal Historian had more on Thaurissan.")
q(4283, "FIFTY! YEP!", "Burning Steppes", 56, "blackrock", 2,
    "Oralius at Morgan's Vigil claimed to be the only sane one there. He collected ogre ears and now wanted fifty orc badges.",
    "Oralius wanted orc badges to go with his ogre ear collection. He wanted fifty of them.",
    "Oralius rewarded the badges with the chance to rub his belly.",
    "Oralius had fifty badges, and offered his belly as the prize.")
q(4081, "KILL ON SIGHT: Dark Iron Dwarves", "Badlands", 52, "kef", 3,
    "Warlord Goretooth of the Kargath Expeditionary Force ordered General Angerforge's forces in Blackrock Depths destroyed. They had massacred the 109th division.",
    "A wanted sign in Kargath offered a tribute for breaking the first line of Angerforge's forces in Blackrock Depths.",
    "Warlord Goretooth said the first strike would put a crease in Angerforge's pants. He had battles to plan and pointed to the wanted signs.",
    "Goretooth paid the first tribute and sent the soldier back to the wanted signs.")
q(4082, "KILL ON SIGHT: High Ranking Dark Iron Officials", "Badlands", 54, "kef", 4,
    "Grandmaster Lexlort had found where Angerforge's high-ranking officers trained, through a locked gate near the heart of the Dark Iron city.",
    "A second posting named the Dark Iron officials who trained forces against the Horde in Blackrock Depths.",
    "Warlord Goretooth guessed Angerforge was angry by now. After a third tribute, he said, Operation Death to Angerforge would begin.",
    "Goretooth paid the second tribute. Operation Death to Angerforge, he hinted, would involve somebody dying.")
q(4062, "The Rise of the Machines", "Badlands", 54, "machines", 3,
    "The initials G.L.A. and a rank marking were etched into the elemental shards. Theodora sent a sample to Lotwil Veriatus, a scholar of elemental science.",
    "Theodora had found initials on the rock creatures' shards. A scholar in the camp to the east, Lotwil, might know them.",
    "Lotwil Veriatus turned white at the shard. He knew those markings.",
    "Lotwil recognized the G.L.A. markings at once, and went pale.", true)
hl(5581, "Taiga Wisemane commended the closing of the demon portals at Mannoroc Coven, done with the Hand of Iruxos.",
    "The Hand of Iruxos banished the portals at Mannoroc Coven. Taiga said Azeroth was safer for it.")
hl(4082, "Warlord Goretooth paid his second tribute and promised Operation Death to Angerforge after a third.",
    "Angerforge's officers in Blackrock Depths had fallen. Goretooth was already planning the next operation.")
for _, id in ipairs({6142, 6143, 5386, 5381, 5581, 6027, 6132, 6134, 5501, 3701, 3702, 4283, 4081, 4082, 4062}) do src(id) end
for _, id in ipairs({6142, 6143, 5386, 5381, 5581, 6132, 6134, 5501}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end
src(3701, "LoreForever npc:royal-historian-archesonus (facts only)")
src(3702, "LoreForever npc:royal-historian-archesonus (facts only)")

-- Batch W3-5: Blackrock Depths. The roads to Moira for both factions before the
-- rescue (Gor'shak and Thrall; Magni and Kharan), the Screwspigot bounty, the
-- Thunderbrew Lager recipe for Ragnar and for Vivian Lagrave, Nagmara's potion, and
-- the disharmony of fire (Pyron, Incendius, the Tablet of Kurniya). Kharan's own
-- account is not captured, so 4342 never says what he told; Moira's secrets stay
-- with the discovery-gated stages 4004/4363 above.
P.threads.world_screwspigot = "the bounty on Ribbly Screwspigot"
P.threads.world_thunderbrew = "the stolen Thunderbrew Lager recipe"
P.threads.world_rocknot = "Nagmara's love potion"
P.threads.world_disharmony = "the disharmony of fire in Blackrock"
local RR = "royal_rescue"
q(3981, "Commander Gor'shak", "Blackrock Depths", 52, RR, 3,
    "Galamav the Marksman's comrade Gargal had taken an arrow to the head. A note on its shaft showed an orc behind bars, signed by Commander Gor'shak.",
    "The note on the arrow suggested Commander Gor'shak was alive and imprisoned in Blackrock Depths. Galamav knew it might be a trap.",
    "Commander Gor'shak said there was little time. What he had to tell was classified.",
    "Gor'shak was found alive in his cell, and he had urgent news to share.")
q(3982, "What Is Going On?", "Blackrock Depths", 54, RR, 4,
    "Gor'shak had let himself be captured on Thrall's orders, to gather intelligence. He said Emperor Thaurissan had kidnapped the Princess of Ironforge and held her in the city.",
    "Commander Gor'shak whispered that Princess Bronzebeard was a prisoner in the Dark Iron city. Then guards came.",
    "Gor'shak called it a close call. The guards had been alerted, and more would come.",
    "The guards were beaten back from Gor'shak's cell, but the Dark Irons now knew intruders were there.", true)
q(4001, "What Is Going On?", "Orgrimmar", 54, RR, 4,
    "Gor'shak had convinced Kharan, a dwarf held across the hall, that the Horde meant him no harm. Above all, the Warchief wanted the princess returned safely to Ironforge.",
    "Kharan in the opposite cell knew more about the princess and her captors. Gor'shak wanted it all taken to the Warchief.",
    "Thrall saw a chance for the Horde to change the politics of a war-torn world. Failure, he said, was not an option.",
    "The Warchief heard what had been learned in the Depths and called the mission one the Horde could not fail.", true)
fallback("What Is Going On?", "Blackrock Depths", RR, "3982,4001",
    "Commander Gor'shak had news from inside the Dark Iron city.",
    "A Horde agent in Blackrock Depths was gathering intelligence.",
    "Gor'shak's intelligence moved a step further.",
    "Word from Gor'shak's cell went on its way.")
q(4002, "The Eastern Kingdoms", "Orgrimmar", 54, RR, 4,
    "Thrall said a Warchief had to do what was best for the Horde and its future generations. Helping the dwarves could strengthen the Horde's standing in the Eastern Kingdoms.",
    "The Warchief saw an opening to shape future alliances by aiding the dwarves. He asked whether the messenger was prepared.",
    "Thrall said there was no going back from this point.",
    "Warchief Thrall committed the Horde's agent to the mission. There was no turning back.")
q(4341, "Kharan Mighthammer", "Blackrock Depths", 59, RR, 4,
    "King Magni wept for his missing daughter. The dwarf meant to watch over her, Kharan Mighthammer, was said to be a prisoner in the Depths.",
    "Magni's men had searched the Steppes, and their only clue put his daughter in Blackrock Depths. He wanted answers from Kharan.",
    "Kharan Mighthammer was found in his cell. He asked to be allowed to explain.",
    "Kharan begged for a chance to explain himself.")
q(4342, "Kharan's Tale", "Blackrock Depths", 59, RR, 4,
    "Before anyone judged him, Kharan asked to be heard out.",
    "The imprisoned Kharan had an account to give about the princess.",
    "Kharan finished and insisted there had been nothing he could have done.",
    "Kharan Mighthammer told his account to its end, and said he had been helpless to stop it.")
q(4361, "The Bearer of Bad News", "Ironforge", 59, RR, 4,
    "Kharan wanted his news taken back to King Magni, sure the king would know what to do.",
    "What Kharan had said in his cell had to reach Ironforge.",
    "King Magni slammed his fist down in anger at the news.",
    "Magni heard Kharan's account and struck the table in rage.")
q(4324, "Yuka Screwspigot", "Burning Steppes", 53, "screwspigot", 2,
    "Ribbly Screwspigot had always wasted his family's money, but Baron Revilgaz had put a price on his head. His sister Yuka had tracked him to the Burning Steppes.",
    "The Screwspigots were glad that Ribbly was finally worth something. Their sister Yuka was hiding in Flame Crest and wanted hired hands.",
    "Yuka Screwspigot wanted her brother brought back, bless his heart. If not all of him, his head would do.",
    "Yuka was hunting her brother Ribbly and welcomed the help, whole or in part.")
q(4136, "Ribbly Screwspigot", "Burning Steppes", 53, "screwspigot", 3,
    "Revilgaz's bounty had sent Ribbly into hiding deep in Blackrock Depths. His sister wanted him brought back, or failing that, his head.",
    "Ribbly was hiding in Blackrock Depths from the price on his head. His sister wanted him, alive or not.",
    "Yuka Screwspigot saw that Ribbly had not come quietly. Her family was very happy, she said, and Ribbly had never looked so peaceful.",
    "Yuka was sorry only to have missed telling Ribbly of the plan to turn him in. She thanked the hunter on behalf of the Screwspigots.")
q(4128, "Ragnar Thunderbrew", "Dun Morogh", 55, "thunderbrew", 2,
    "Ragnar Thunderbrew was furious that someone had stolen his ale, and he would pay well for help. He was at the Thunderbrew Distillery in Kharanos.",
    "Word had spread that Ragnar Thunderbrew needed stalwart adventurers and was willing to pay.",
    "Ragnar was robbed of a family recipe and fuming. As if he lacked reasons to hate the Dark Irons, he said, they were in for it now.",
    "Ragnar Thunderbrew raged about the theft of a family recipe by the Dark Iron dwarves.")
q(4126, "Hurley Blackbreath", "Dun Morogh", 55, "thunderbrew", 3,
    "Hurley Blackbreath and his Dark Irons had stolen the recipe for Thunderbrew Lager. Their kegs were to be smashed and the recipe brought home.",
    "Ragnar could not stand the thought of Dark Irons drinking his family's lager. The recipe was somewhere in Blackrock Depths.",
    "Ragnar Thunderbrew had his recipe back. He hoped Hurley had taken a good thumping, and called the finder a hero of heroes.",
    "Ragnar celebrated the recovered recipe. The Thunderbrews, he said, were at the finder's service.")
q(4133, "Vivian Lagrave", "Badlands", 55, "thunderbrew", 2,
    "Shadowmaster Vivian Lagrave was in Kargath, pursuing rumors of a Dark Iron brew. She had asked for help.",
    "A summons led to Vivian Lagrave in the Badlands, where she was following talk of a brew from Blackrock Depths.",
    "Vivian Lagrave found Kargath lacking the comforts of the Apothecarium. Then she turned to business.",
    "Vivian greeted the arrival and wasted little time on pleasantries.")
q(4134, "Lost Thunderbrew Recipe", "Badlands", 55, "thunderbrew", 3,
    "Hurley Blackbreath had stolen the Thunderbrew Lager recipe, said to give its drinker strength and courage. The Forsaken wanted it studied for their own purposes.",
    "To find Hurley, the Forsaken were told, one had to threaten his precious ale. The recipe he had taken was what Vivian wanted.",
    "Vivian Lagrave sent the recipe to the Apothecarium. She found it amusing that the drink might one day be turned on the Alliance's dwarves.",
    "Vivian took the lager recipe for the apothecaries to study, and admitted death might have changed her sense of humor.")
q(4201, "The Love Potion", "Blackrock Depths", 54, "rocknot", 2,
    "Mistress Nagmara was spurned by Private Rocknot. Her potion needed gromsblood, giant silver veins from Azshara's cliff giants and water from Un'Goro's Golakka Springs.",
    "A succubus in the Grim Guzzler wanted to break down the walls around Rocknot's heart. Her potion called for ingredients from three distant lands.",
    "Nagmara could now brew her potion for Rocknot. She called the gatherer a champion of love.",
    "Mistress Nagmara was delighted with the ingredients and sure Rocknot would fall for her charms.")
q(3906, "Disharmony of Flame", "Badlands", 52, "disharmony", 3,
    "Thunderheart's elders had felt the elements in disarray. The Dark Irons had summoned Overmaster Pyron, a fire lord in the Blackrock quarry.",
    "A foul fire spirit threatened the land with endless drought, the elders said. Overmaster Pyron waited beyond the Chasm of Flame.",
    "Thunderheart found that Pyron's death had only lifted a veil. A deeper corruption lay within Blackrock.",
    "Pyron was destroyed, but Thunderheart sensed something more insidious beneath it.")
q(3907, "Disharmony of Fire", "Badlands", 56, "disharmony", 5,
    "Lord Incendius was only an emissary, Thunderheart said, and something commanded him. His master's hiding place had to be found.",
    "The wind and earth cried the name Lord Incendius. Whoever stood behind him had to be found.",
    "Thunderheart clutched the Tablet of Kurniya and named Ragnaros, a general of the Old Gods. Kargath would have to decide whether to stay and fight.",
    "Thunderheart read the tablet and learned that Ragnaros was in the world. A far greater evil lived in Blackrock's depths, he warned.")
q(4262, "Overmaster Pyron", "Burning Steppes", 52, "disharmony", 3,
    "Jalinda Sprig's last five mages had come back from Blackrock Mountain burned, or worse. Overmaster Pyron guarded the way into the Depths at the quarry.",
    "The Morgan's Vigil expedition could not reach Blackrock Depths while Overmaster Pyron held the quarry entrance.",
    "Jalinda Sprig heard the name Incendius and said, oh dear.",
    "Jalinda was relieved about Pyron, then dismayed to hear of Incendius.")
hl(3982, "Commander Gor'shak said Emperor Thaurissan had kidnapped the Princess of Ironforge. Then the Dark Iron guards attacked his cell.",
    "In Blackrock Depths, Gor'shak revealed he was a willing prisoner on Thrall's orders, gathering news of the captive princess.")
hl(4361, "Kharan's news reached King Magni, who slammed his fist down in anger.",
    "King Magni heard what Kharan had to say about his daughter and struck the table in rage.")
hl(4126, "Ragnar Thunderbrew had his family's lager recipe back from Hurley Blackbreath and called its finder a hero of heroes.",
    "The stolen Thunderbrew Lager recipe came home to Kharanos. Ragnar hoped Hurley had been thumped.")
hl(3907, "The Tablet of Kurniya told Thunderheart that Ragnaros was in the world. Kargath had to decide whether to fight or flee.",
    "Thunderheart learned from the tablet that Ragnaros commanded Incendius, and warned of the evil in Blackrock's depths.")
for _, id in ipairs({3981, 3982, 4001, 4002, 4341, 4342, 4361, 4324, 4136, 4128, 4126, 4133, 4134, 4201, 3906, 3907, 4262}) do src(id) end
for _, id in ipairs({3981, 3982, 4001, 4002, 4341, 4342, 4361}) do P.questIDs[id].threadLabel = P.threads.world_royal_rescue end

-- Batch W3-6: Revantusk Village in the Hinterlands (Horde). Katoom's snapjaws,
-- Huntsman Markhor's hunts and his brother's remains, Otho's messages to the
-- Wildhammer, Yayo'jin's cousins, Primal Torntusk's vessels and kidnapped mate,
-- and the guard captain's post. 7845 finds the elder; only 7846 frees him and only
-- 7847 tells his mate.
P.threads.world_revantusk = "the troubles of Revantusk Village"
P.threads.world_torntusk = "the rescue of Elder Torntusk"
q(7816, "Gammerita, Mon!", "The Hinterlands", 48, "revantusk", 2,
    "Katoom the Angler of Revantusk Village said Gammerita, leader of the saltwater snapjaws, had snapped his best lure right off the line. He wanted it back from her stomach.",
    "Since Gammerita stole his best lure, Katoom said, the fish had not bitten the same. The great snapjaw had swallowed it.",
    "Katoom was overjoyed to have his best lure back. With the snapjaws thinned out, he expected the fish to pile up.",
    "Katoom the Angler had his lure again, taken from Gammerita's stomach.")
q(7815, "Snapjaws, Mon!", "The Hinterlands", 50, "revantusk", 2,
    "Katoom could not fish for five minutes before a saltwater snapjaw broke his line. He asked for the whole lot of them killed, for Revantusk's sake.",
    "The saltwater snapjaws stole Katoom's bait and broke his lines. Revantusk Village would be better off without them, he said.",
    "Katoom could not thank the hunter enough, and offered a fishing pole as reward.",
    "Katoom the Angler handed over a fishing pole in thanks for the snapjaw hunt.")
q(7828, "Stalking the Stalkers", "The Hinterlands", 48, "revantusk", 2,
    "Huntsman Markhor had lost many hunters to the Silvermane wolves, which waited in the brush to strike. He wanted the stalkers stalked in turn.",
    "The Silvermane wolves ambushed Revantusk's hunters from cover. Every one of them was to be slain, Markhor said.",
    "Huntsman Markhor thanked the hunter on behalf of the Revantusk.",
    "Markhor called the wolf hunt a job well done.")
q(7829, "Hunt the Savages", "The Hinterlands", 48, "revantusk", 2,
    "Savage owlbeasts had killed many good Revantusk warriors. Every one was to be killed, and Markhor promised to weigh the effort.",
    "Markhor wanted the savage owlbeasts of the Hinterlands killed on sight. The work would be judged when it was done.",
    "Huntsman Markhor judged the hunt and named the hunter a worthy ally of the Revantusk.",
    "Markhor was satisfied with the owlbeast hunt and said so.")
q(7830, "Avenging the Fallen", "The Hinterlands", 48, "revantusk", 3,
    "The Wildhammer trained gryphons to kill trolls, Markhor said. He wanted the plume of a Razorbeak Skylord, one of the elder gryphons that bred the rest.",
    "Elder gryphons called Skylords fathered the birds that hunted Revantusk trolls. One of them was to die.",
    "Huntsman Markhor examined the plume and wondered how many of his hunters the beast had devoured.",
    "Markhor took the Skylord's plume as the beast's sentence carried out.")
q(7849, "Separation Anxiety", "The Hinterlands", 50, "revantusk", 4,
    "Markhor's twin brother Malkhor had been taken by the Vilebranch in the same raid as Torntusk's mate. He was executed and his remains thrown to the oozes and wolves.",
    "It was too late to save Malkhor's life, his brother said, but not his soul. His remains lay among the Vilebranch.",
    "Huntsman Markhor mourned his dearest brother. He would take the remains to Yayo'jin for a proper burial, and called their finder a hero.",
    "Markhor received his brother's remains and grieved for him. Mystic Yayo'jin would prepare them for burial.")
q(7841, "Message to the Wildhammer", "The Hinterlands", 48, "revantusk", 2,
    "Otho Moji'ko spat at the Wildhammer's new deals with the high elves. He wanted the Highvale elves killed and left as a warning.",
    "The Wildhammer were forging alliances with the high elves of Highvale. A message in blood was what Otho wanted.",
    "Otho Moji'ko said the Revantusk were forging new alliances too.",
    "Otho was pleased with the first message to the Wildhammer.")
q(7842, "Another Message to the Wildhammer", "The Hinterlands", 48, "revantusk", 2,
    "The Wildhammer were as close to their gryphons as trolls to their mates, Otho said. Gryphon feathers would make the next message.",
    "For the second message, Otho wanted feathers from the Hinterlands gryphons.",
    "Otho Moji'ko was gleeful. One more step and the Wildhammer would learn not to mess with trolls.",
    "Otho had his feathers, and one step left in his plan.")
q(7843, "The Final Message to the Wildhammer", "The Hinterlands", 50, "revantusk", 3,
    "Otho handed over a blood-drenched spear wrapped in gryphon feathers. It was to be planted by the well at the center of Aerie Peak.",
    "The final message was a bloody spear, to be driven into the ground in the heart of Aerie Peak.",
    "Otho Moji'ko wished he had seen the dwarves' faces. He wondered whether they were packing their bags, and rewarded the deed with his big mojo.",
    "Otho was delighted that the spear stood in Aerie Peak, and paid with his big mojo.")
q(7844, "Cannibalistic Cousins", "The Hinterlands", 48, "revantusk", 3,
    "Mystic Yayo'jin said the three troll tribes of the Hinterlands shared little but their home. The Vilebranch fed on other trolls, and with Zul'jin gone, the Revantusk had to deal with them.",
    "The Vilebranch were cannibals, Yayo'jin said, and Zul'jin had not returned to destroy them. Their numbers had to be cut.",
    "Mystic Yayo'jin said Zul'jin himself could not have done better.",
    "Yayo'jin praised the work against the Vilebranch.")
q(7850, "Dark Vessels", "The Hinterlands", 50, "torntusk", 3,
    "The Vilebranch fought with unnatural fury because of the Vile Priestess Hexx. Vessels of tainted blood in Jintha'Alor carried the blood god's magic.",
    "Taken from Jintha'Alor, the dark vessels could be cleansed of their taint by Primal Torntusk.",
    "Primal Torntusk lifted the dark energy that drove the Vilebranch, for now. Even if Hexx fell, she warned, another would take her place.",
    "Primal Torntusk cleansed the vessels and loosened the Vilebranch's madness, though she knew it would return.")
q(7845, "Kidnapped Elder Torntusk!", "The Hinterlands", 51, "torntusk", 4,
    "Primal Torntusk's mate had been taken in a midnight raid. Spies said he was alive atop Jintha'Alor, and Hexx meant to sacrifice him to Hakkar.",
    "The Vilebranch held Elder Torntusk prisoner on Jintha'Alor, readying him for the blood god.",
    "Elder Torntusk was found alive in his bonds. He urged haste, sure the guards had been alerted.",
    "Torntusk's mate was found atop Jintha'Alor, still a prisoner.")
q(7846, "Recover the Key!", "The Hinterlands", 51, "torntusk", 4,
    "The key to Elder Torntusk's shackles was held by Hitah'ya the Keeper, in a guarded cave nearby.",
    "Hitah'ya the Keeper had the key to the elder's bindings, and without it he could not go home.",
    "Elder Torntusk was free at last. Revantusk would know of the deed, he said.",
    "Elder Torntusk's shackles came off, and he thanked his rescuer.")
q(7847, "Return to Primal Torntusk", "The Hinterlands", 51, "torntusk", 4,
    "The freed elder asked that his mate be told he was coming home.",
    "Back at Revantusk Village, Primal Torntusk needed to hear that her mate was free.",
    "Primal Torntusk heard that her mate was coming home. The Revantusk owed a great debt, she said.",
    "Torntusk received the news of her mate's freedom with deep gratitude.")
q(7862, "Job Opening: Guard Captain of Revantusk Village", "The Hinterlands", 51, "revantusk", 3,
    "Guard Captain Malkhor was dead, and Revantusk needed a new one. The notice asked for Vilebranch berserkers, shadow hunters, blood drinkers and soul eaters to be killed.",
    "Primal Torntusk would review applications for captain of the guard. The test was a cull of the Vilebranch warriors.",
    "Torntusk called the applicant worthy and gave a trinket. She would review all applications next year.",
    "Torntusk accepted the application with a trinket of thanks, and promised a decision next year.")
hl(7849, "Huntsman Markhor mourned his twin brother Malkhor, whose remains came back from the Vilebranch for a proper burial.",
    "Markhor received his brother's remains. Mystic Yayo'jin would see them buried properly.")
hl(7843, "Otho Moji'ko's bloody spear stood by the well in Aerie Peak. He wished he could have seen the dwarves' faces.",
    "The final message to the Wildhammer was planted in Aerie Peak, to Otho's delight.")
hl(7847, "Primal Torntusk learned that her mate was free and coming home from Jintha'Alor.",
    "Elder Torntusk was free, and his mate gave the Revantusk's thanks.")
for _, id in ipairs({7816, 7815, 7828, 7829, 7830, 7849, 7841, 7842, 7843, 7844, 7850, 7845, 7846, 7847, 7862}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-7: Camp Mojache in Feralas (Horde). Witch Doctor Uzer'i's muisek (named only
-- in titles: the tests read the "i" after the apostrophe as a pronoun)
-- vessel from Neeru's herbs to the finished weapons (3129 alone seals the muisek
-- into a weapon), Krueg's report of the Grimtotem to Belgrom, Rok Orhan's Gordunni
-- orb, Talo Thornhoof's old grudge against the Northspring harpies, and the yeti
-- hides for both factions' leatherworkers.
P.threads.world_muisek = "the Mojache witch doctor's muisek vessel"
P.threads.world_talo = "Talo Thornhoof's revenge on the Northspring"
P.threads.world_yetihides = "the leatherworkers' yeti hides"
q(3121, "A Strange Request", "Orgrimmar", 45, "muisek", 2,
    "Camp Mojache's witch doctor needed an herb mixture from Neeru Fireblade in Orgrimmar. In exchange he sent the shrunken head of a dwarf he had met in the forest.",
    "A concoction for the Mojache witch doctor was ready in Orgrimmar's Cleft of Shadow, and its maker, Neeru Fireblade, had been promised a shrunken head for it.",
    "Neeru Fireblade had been waiting for the head. He handed over the herbs he had prepared for the witch doctor's experiments.",
    "Neeru received the shrunken head and gave the herb mixture in return.")
q(3122, "Return to Witch Doctor Uzer'i", "Feralas", 45, "muisek", 2,
    "The herbs had to go back to Camp Mojache, with word that the shrunken head had pleased Neeru.",
    "Back in Feralas, the herb mixture from Orgrimmar would begin the witch doctor's preparations.",
    "Mojache's witch doctor had what he needed to prepare the muisek vessel. He paused to perform the ritual and apply the herbs.",
    "Neeru's herbs went straight into the ritual that readied the muisek vessel.")
q(3125, "Faerie Dragon Muisek", "Feralas", 45, "muisek", 3,
    "The faerie dragons served the night elves as allies. Their spirit was strong, and the witch doctor wanted it captured for the Horde with his vessel.",
    "Sprite darters and sprite dragons looked fragile, but their spirit was powerful. Its muisek could be taken with the vessel once they were slain.",
    "Mojache's witch doctor now held the faerie dragons' muisek, their spiritual power available to the Horde.",
    "Eight faerie dragon spirits filled the vessel, and another task was already waiting.")
q(3124, "Hippogryph Muisek", "Feralas", 47, "muisek", 3,
    "Hippogryphs had long served the night elves, loyal and steadfast. The frayfeather hippogryphs of the High Wilderness were to be shrunk and captured next.",
    "The vessel had proved itself in trusted hands, so the witch doctor asked for hippogryph muisek.",
    "Mojache's witch doctor explained that an escaped muisek might return as a greater creature seeking vengeance. The dangerous task had been done well.",
    "Ten hippogryph spirits were held in the vessel, where they could take no revenge.")
q(3126, "Treant Muisek", "Feralas", 50, "muisek", 3,
    "Treants fought for the night elves against the Horde. Slow as they were, the wandering forest walkers were strong protectors.",
    "Three forest walkers were next for the vessel. The witch doctor meant to use their strength for the Horde.",
    "Mojache's witch doctor said his muisek collection was almost complete.",
    "Treant muisek joined the collection, with only one more to go.")
q(3127, "Mountain Giant Muisek", "Feralas", 50, "muisek", 3,
    "Mountain giants had come down to aid the night elves when the Burning Legion appeared. Their muisek was the last the witch doctor wanted.",
    "For the final muisek, the vessel went northwest to the shaking ground of the mountain giants.",
    "Mojache's witch doctor imagined what the captured spirits could become. With the right materials, he could bind them into whatever he wished.",
    "Seven mountain giants' muisek completed the collection.")
q(3128, "Natural Materials", "Feralas", 50, "muisek", 2,
    "Binding the muisek needed treant logs, encrusted minerals, resilient sinew and metallic fragments.",
    "Alongside the muisek, the witch doctor's work called for materials from treants, giants, faerie dragons, owlbeasts and hippogryphs.",
    "Mojache's witch doctor was pleased. The materials and the muisek together should give the results he wanted.",
    "Logs, minerals, sinew and fragments were ready for the binding.")
q(3129, "Weapons of Spirit", "Feralas", 50, "muisek", 4,
    "With everything gathered, the difficult work of imbuing weapons with the muisek could begin.",
    "The captured spirits and the materials were ready. Sealing them into weapons took a moment of the witch doctor's craft.",
    "Mojache's witch doctor offered a choice of weapons, each with a creature's muisek sealed into it for good.",
    "Weapons of spirit were finished, the muisek bound in them for their wielder to use.")
q(2976, "A Grim Discovery", "Orgrimmar", 45, "mojache_requests", 3,
    "Krueg Skullsplitter admitted he had mentioned a bounty. He crated the horns and sent word of what had been seen to Belgrom Rockmaul in Orgrimmar.",
    "Krueg said that Belgrom Rockmaul in the Valley of Honor would want to hear what had been found in Feralas.",
    "Belgrom Rockmaul was surprised to hear of the Grimtotem in Feralas. His peers would want the news, and he paid while he listened.",
    "Belgrom counted out the coin while hearing about the Grimtotem, and gave his thanks for the report.", true)
P.questIDs[2976].threadLabel = P.threads.world_mojache_requests
fallback("A Grim Discovery", "Feralas", "mojache_requests", "2974,2976",
    "Krueg Skullsplitter's business with the Grimtotem in Feralas concerned Belgrom's bounty.",
    "The Grimtotem had been found in Feralas, and Krueg wanted the matter handled.",
    "The matter of the Grimtotem in Feralas moved a step further.",
    "Krueg's dealings over the Grimtotem went on.")
P.quests["A Grim Discovery"].threadLabel = P.threads.world_mojache_requests
q(2979, "Dark Ceremony", "Feralas", 46, "woodpaw", 3,
    "The plans described a dark ceremony led by the Gordunni mage-lords. An orb from one of them was what Rok Orhan wanted.",
    "A mage-lord's orb held great power, Rok Orhan said, and could reveal more about the Gordunni ceremony.",
    "Rok Orhan took the orb to learn more about the Gordunni, and to plan their downfall.",
    "Rok had his Gordunni orb, and with it a way to study their magic.")
q(3063, "Vengeance on the Northspring", "Feralas", 50, "talo", 3,
    "Talo Thornhoof had once been a fearless hunter until harpies ambushed him in the forest. He still heard their cries, and wanted revenge on the Northspring.",
    "An old ambush by harpies had changed Talo Thornhoof forever. After all these years, he wanted to get even.",
    "Talo Thornhoof said his old mind was at peace.",
    "Talo thanked the avenger. The Northspring had paid for the old ambush.")
q(3062, "Dark Heart", "Feralas", 50, "talo", 4,
    "Edana Hatetalon ruled the Northspring harpies, and Talo heard her heart was made of crystal. Her horn, blown by the Hatetalon stones, would summon her.",
    "Talo wanted the Northspring queen's dark heart. A harpy horn sounded at the Hatetalon stones would bring her out.",
    "Talo Thornhoof knew Edana was truly dead. He would keep her heart as a reminder of what had been done for him.",
    "Talo held Edana Hatetalon's dark heart and was at last sure of her death.")
q(4120, "The Strength of Corruption", "Feralas", 52, "talo", 3,
    "Talo believed in knowing the enemy. The fel had driven Felwood's bears and wolves mad, and he suspected it had made them stronger.",
    "Felwood's tainted creatures might show what corruption could do. Their strength, Talo said, should be tested firsthand.",
    "Talo Thornhoof heard of the creatures' mindless ferocity. He urged learning more about the corruption.",
    "Talo listened to what had been seen in Felwood and repeated his lesson to know the enemy.")
q(2821, "The Mark of Quality", "Feralas", 46, "yetihides", 2,
    "Pratt McGrubben would not compromise on quality, and thick yeti hides from Feral Scar Vale had caught his eye. Ten would earn a choice of his leather goods.",
    "The yetis of Feral Scar Vale had thick hides that Pratt wanted for his leatherwork.",
    "Pratt McGrubben thought the hides, treated properly, could be stronger than iron. He offered a choice of his goods.",
    "Pratt was delighted with the yeti hides and the mark of quality they could bring.", true)
q(2822, "The Mark of Quality", "Feralas", 46, "yetihides", 2,
    "Jangdor Swiftstrider took pride in his leatherwork and had found thick yeti hides west of Camp Mojache. Ten would earn a choice of his goods.",
    "Thick yeti hides from Feral Scar Vale were wanted at Camp Mojache for Jangdor's leatherwork.",
    "Jangdor Swiftstrider said the treated hides would be as resilient as iron. The tanning would take many tries, but he was confident.",
    "Jangdor was pleased with the yeti hides and offered a choice of his crafts.", true)
fallback("The Mark of Quality", "Feralas", "yetihides", "2821,2822",
    "A Feralas leatherworker wanted thick yeti hides.",
    "Thick yeti hides from Feral Scar Vale were in demand for leatherwork.",
    "The leatherworker had the yeti hides.",
    "The yeti hides were delivered.")
q(7733, "Improved Quality", "Feralas", 48, "yetihides", 2,
    "Deep in Rage Scar Hold, Pratt had heard, lived tougher yetis with better hides still.",
    "The Rage Scar yetis of northern Feralas had hides Pratt hoped were as hard as thorium.",
    "Pratt McGrubben could tell the Rage Scar hides would be even harder once cured, and gave one of his latest creations.",
    "Pratt was excited by the Rage Scar hides and paid with new work of his own.", true)
q(7734, "Improved Quality", "Feralas", 48, "yetihides", 2,
    "A lead had reached Jangdor about tougher yetis in Rage Scar Hold, in northern Feralas.",
    "The yetis of Rage Scar Hold were tougher than those of Feral Scar Vale, and Jangdor wanted their hides.",
    "Jangdor Swiftstrider was sure the Rage Scar hides would cure harder still, and gave one of his latest creations.",
    "Jangdor was delighted with the Rage Scar hides and paid in leatherwork.", true)
fallback("Improved Quality", "Feralas", "yetihides", "7733,7734",
    "A Feralas leatherworker had heard of tougher yetis in Rage Scar Hold.",
    "Hides from the Rage Scar yetis were wanted for leatherwork.",
    "The Rage Scar hides were delivered.",
    "The leatherworker had the tougher hides.")
hl(3129, "Mojache's witch doctor sealed the captured muisek into weapons, and offered a choice of them.",
    "Weapons of spirit came from the muisek work, the creatures' spirits bound inside.")
hl(3062, "Talo Thornhoof received Edana Hatetalon's dark heart and knew the harpy queen was dead.",
    "The Northspring queen was dead, and Talo kept her heart as a reminder.")
for _, id in ipairs({3121, 3122, 3125, 3124, 3126, 3127, 3128, 3129, 2976, 2979, 3063, 3062, 4120, 2821, 2822, 7733, 7734}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-8: Oglethorpe's homing robots in Tanaris, the Hinterlands and Feralas
-- (each Find stage only wakes the robot; the Rescue stage ends in Booty Bay), Zorbin
-- Fandazzle's shrinker on the Forgotten Coast, Nimboya's grim message, Lydon's search
-- for the Witherbark venom through Gadrin to Shadra, and Rin'ji's tablet.
P.threads.world_oox = "Oglethorpe's homing robots"
P.threads.world_zorbin = "Zorbin Fandazzle's Ultra-Shrinker"
P.threads.world_shadra = "the venom of the Witherbark spider god"
P.threads.world_rinji = "Rin'ji's tablet"
q(351, "Find OOX-17/TN!", "Tanaris", 48, "oox", 2,
    "A metal egg turned up in Tanaris and opened into a gnomish device. Oglethorpe Obnoticus spoke from inside, saying his homing robot had crashed near the Gaping Chasm.",
    "Oglethorpe Obnoticus offered a reward for his lost homing robot. His beacon pointed to the Gaping Chasm.",
    "OOX-17/TN stood up, humming and whirring, once the beacon was placed inside. Oglethorpe said it worked, but needed major repairs.",
    "The robotic chicken came back to life with the beacon inside it. Oglethorpe asked for more help moving it.")
q(648, "Rescue OOX-17/TN!", "Stranglethorn Vale", 48, "oox", 3,
    "Oglethorpe needed OOX-17/TN moved to Steamwheedle Port for a long take-off. Its cloaking would take time to restore.",
    "The repaired robot had to be escorted to Steamwheedle Port, then Oglethorpe waited in Booty Bay.",
    "Oglethorpe Obnoticus called the escort the great savior of OOX-17/TN. The rescue had saved him hours of rebuilding and much gold.",
    "Oglethorpe thanked the robot's rescuer in Booty Bay and offered a choice of his items.")
q(485, "Find OOX-09/HL!", "The Hinterlands", 48, "oox", 2,
    "Another of Oglethorpe's metal eggs crackled to life in the Hinterlands. His homing robot had crashed at the head of the river near Skulk Rock.",
    "Oglethorpe Obnoticus had lost OOX-09/HL near Skulk Rock. His beacon could get it moving again.",
    "OOX-09/HL woke with the beacon inside it. Oglethorpe said it worked, but was too heavy to carry and needed watching.",
    "The beacon jump-started the robot near Skulk Rock. Oglethorpe had another idea to get it home.")
q(836, "Rescue OOX-09/HL!", "Stranglethorn Vale", 48, "oox", 3,
    "OOX-09/HL needed to reach the shore beyond Overlook Cliff, where it could begin its take-off.",
    "While he restored its cloaking, Oglethorpe asked for OOX-09/HL to be escorted to the shoreline beyond Overlook Cliff.",
    "Oglethorpe Obnoticus was delighted to meet the savior of OOX-09/HL. The recovery had spared him much rebuilding.",
    "Oglethorpe thanked the rescuer in Booty Bay and offered a reward for the Hinterlands robot.")
q(2766, "Find OOX-22/FE!", "Feralas", 45, "oox", 2,
    "A metal egg in Feralas opened, and Oglethorpe Obnoticus spoke from it. His homing robot had crashed in a cave near Feral Scar Vale.",
    "Oglethorpe's beacon pointed to a cave near Feral Scar Vale, where OOX-22/FE lay wrecked.",
    "OOX-22/FE struggled to its feet with the beacon inside. Oglethorpe needed it watched over a while longer.",
    "The beacon brought the Feralas robot back to life. Oglethorpe said it needed major repairs.")
q(2767, "Rescue OOX-22/FE!", "Stranglethorn Vale", 45, "oox", 3,
    "OOX-22/FE had to be escorted to the dock along the Forgotten Coast before it could take off.",
    "The Forgotten Coast's dock was where Oglethorpe wanted OOX-22/FE brought, while he restored its cloaking.",
    "Oglethorpe Obnoticus thanked the savior of OOX-22/FE and offered a choice of his items.",
    "Oglethorpe was grateful for the Feralas robot's rescue, which had saved him gold and hours of work.")
q(7003, "Zapped Giants", "Feralas", 48, "zorbin", 2,
    "Zorbin Fandazzle found the giants bad for business. He had built a goblin shrinking ray and wanted it tested on them, with their miniaturization residue brought back.",
    "A goblin variant of a gnomish shrinking ray needed a field test. Shrunken Feralas giants would leave the residue Zorbin wanted.",
    "Zorbin Fandazzle was relieved to see the residue and every limb intact. He called the tester a friend to goblins everywhere.",
    "Zorbin had his miniaturization residue, and the Ultra-Shrinker had not exploded.")
q(7721, "Fuel for the Zapping", "Feralas", 48, "zorbin", 2,
    "The elementals of the Forgotten Coast troubled Zorbin's shop. Their water cores could power his Ultra-Shrinker.",
    "Water elemental cores were raw power for the Ultra-Shrinker, and Zorbin wanted them.",
    "Zorbin Fandazzle had cores enough to keep him working, and fewer elementals near his shop.",
    "Zorbin paid in loot for the water elemental cores, despite the strain on his purse.")
q(7725, "Again With the Zapped Giants", "Feralas", 55, "zorbin", 2,
    "Zorbin could always use more residue. He offered less coin, and word of the deed to his goblin friends.",
    "More miniaturization residue was wanted, though the pay would be smaller this time.",
    "Zorbin Fandazzle said the deed was echoing through the halls of the Steamwheedle Cartel.",
    "Zorbin paid a smaller sum and promised his Cartel friends would hear of it.")
q(7726, "Refuel for the Zapping", "Feralas", 55, "zorbin", 2,
    "Zorbin needed more water elemental cores to set up shop on the coast. He promised to tell everyone in earshot.",
    "More cores were needed for the Ultra-Shrinker. The reward would be smaller, but the Cartel would hear of it.",
    "Zorbin Fandazzle paid what he could and promised his Steamwheedle comrades would hear about it.",
    "Zorbin had more cores, and promised to spread word of the help.")
q(2932, "Grim Message", "Stranglethorn Vale", 42, "shadra", 3,
    "The Witherbark trolls had once been allies of the Horde, then betrayed Thrall. Their skulls and Nimboya's pike were to stand in one of their villages.",
    "Nimboya wanted the Witherbark punished for betraying Thrall. His pike was to stand at Hiri'watha or Zun'watha.",
    "Nimboya had heard of the grim deed and called it one of honor. He hoped the Witherbark would heed it.",
    "Word of the pike in the Witherbark village reached Nimboya.")
q(2933, "Venom Bottles", "Hillsbrad Foothills", 43, "shadra", 2,
    "The Witherbark village held many bottles of green venom. An apothecary in Tarren Mill might want a sample.",
    "So many venom bottles suggested the Witherbark prized them. Tarren Mill's apothecaries might know why.",
    "Apothecary Lydon had had a day of failed experiments. He judged the venom to come from some spider, and asked where it had been found.",
    "Lydon was intrigued by the green venom and wanted to know its source.")
q(2934, "Undamaged Venom Sac", "Hillsbrad Foothills", 45, "shadra", 2,
    "Fresh venom was needed from the spiders near Shadra'Alor, in an undamaged sac, for Lydon's tests.",
    "A fresh, intact venom sac from the Hinterlands spiders was what Lydon wanted for his tests.",
    "Apothecary Lydon was delighted. The venom was fresh and very deadly.",
    "Lydon had his fresh venom, and a collection of small animals to test it on.")
q(2935, "Consult Master Gadrin", "Durotar", 45, "shadra", 3,
    "The broodguards' venom was weaker than the first sample. Lydon sent the question of its source to Master Gadrin in Sen'jin Village.",
    "Lydon wanted the venom's true source. A troll who knew the Witherbark well, Master Gadrin, might know it.",
    "Master Gadrin understood what was wanted and warned that the answer would not be welcome.",
    "Gadrin sat his visitor down. The source of the Witherbark venom was bad news.")
q(2936, "The Spider God", "Durotar", 45, "shadra", 4,
    "The Witherbark worshipped a spider god and took their strongest venom from her. Her true name was on a tablet guarded by Theka the Martyr in Zul'Farrak.",
    "To get the venom, Gadrin said, the spider god herself had to be summoned. Her name lay in Zul'Farrak, in Theka's tomb.",
    "Master Gadrin heard the name Elortha no Shadra and warned it should only be whispered. He set it down as a spell of summoning.",
    "Gadrin received the spider god's true name and began to write it into a summoning.")
q(2937, "Summoning Shadra", "Hillsbrad Foothills", 55, "shadra", 4,
    "Gadrin's parchment was to be read at the altar of Shadra'Alor, deep in the Witherbark realm. It would summon Shadra.",
    "The summoning spell would call Shadra to her altar in the Hinterlands, and her venom was the prize.",
    "Apothecary Lydon was thrilled to have the spider god's venom.",
    "Lydon had Shadra's venom at last.")
q(2938, "Venom to the Undercity", "Undercity", 55, "shadra", 3,
    "A drop of Shadra's venom had killed nearly two dozen rabbits. Lydon wanted a sample sent to Apothecary Faranell in the Undercity.",
    "Lydon's superior, Apothecary Faranell, would want to test the spider god's venom himself.",
    "Apothecary Faranell said Lydon was already finding new uses for the poison. He hoped there would be many.",
    "Faranell accepted the venom for the Royal Apothecary Society.")
q(2742, "Rin'ji is Trapped!", "The Hinterlands", 47, "rinji", 2,
    "Rin'ji, a Witherbark troll, had lost his axe and been captured. He begged for help and promised a secret hidden at the Overlook Cliffs.",
    "A captured Witherbark named Rin'ji pleaded to be freed, offering a hidden secret in return.",
    "Rin'ji's secret turned out to be a troll tablet covered in markings that could not be deciphered.",
    "At the Overlook Cliffs lay Rin'ji's secret, a tablet in Witherbark script.")
q(2782, "Rin'ji's Secret", "Undercity", 47, "rinji", 2,
    "The tablet might be valuable, or worthless. A troll in trouble would say anything to escape, but Oran Snakewrithe studied the Witherbark.",
    "A scholar of the Witherbark in the Undercity, Oran Snakewrithe, might read Rin'ji's tablet.",
    "Oran found the tablet unusual and asked where it had been found.",
    "Oran was intrigued by Rin'ji's tablet.")
hl(648, "Oglethorpe Obnoticus thanked the savior of OOX-17/TN in Booty Bay, once the robot reached Steamwheedle Port.",
    "OOX-17/TN reached Steamwheedle Port, and Oglethorpe paid in Booty Bay.")
hl(2936, "Master Gadrin learned the spider god's true name, Elortha no Shadra, from Theka's tablet, and wrote it into a summoning.",
    "The name of the Witherbark spider god came back from Zul'Farrak. Gadrin warned it should only be whispered.")
hl(2938, "Shadra's venom reached Apothecary Faranell in the Undercity, the most potent poison Lydon had found.",
    "Apothecary Faranell received the spider god's venom for the Royal Apothecary Society.")
for _, id in ipairs({351, 648, 485, 836, 2766, 2767, 7003, 7721, 7725, 7726, 2932, 2933, 2934, 2935, 2936, 2937, 2938, 2742, 2782}) do src(id) end
for _, id in ipairs({485, 836, 2766, 2767, 7003, 7721, 7725, 7726, 2932, 2933, 2934, 2935, 2742, 2782}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-9: Stranglethorn, continued. Barnil Stonepot's four recovered parts of
-- Nesingwary's manuscript (each claims only its own part; 338 above assembles the
-- whole), the Darkspear's questioning of the Bloodscalp heads and the Mind's Eye
-- for Horde players, the Skullsplitter feud, Trollbane, Kebok's schemes for
-- Revilgaz, Zanzil's mixture and the debts of the cursed gamblers, and two sailors
-- robbed by the Bloodsail. Pool prose avoids the meta words: "part" and "leaves".
P.threads.world_kebok = "Kebok's business for Revilgaz"
P.threads.world_dues = "the debts of Booty Bay's gamblers"
P.threads.world_sailors = "the sailors robbed by the Bloodsail"
P.threads.world_trolkalar = "the Darkspear's interest in Trol'kalar"
q(339, "Chapter I", "Stranglethorn Vale", 40, "greenhills", 2,
    "Barnil Stonepot had found the opening part of Nesingwary's manuscript riveting, not least because it mentioned him. Leaves 1, 4, 6 and 8 were still lost in the jungle.",
    "The first part of Nesingwary's manuscript set the scene and named his hunting companions. Four of its leaves were missing.",
    "Barnil Stonepot had the first part of the manuscript whole at last.",
    "Barnil pieced the opening of Nesingwary's work back together.")
q(340, "Chapter II", "Stranglethorn Vale", 40, "greenhills", 2,
    "The second part of the manuscript was full of panther and tiger hunts. Leaves 10, 11, 14 and 16 had blown away, and Barnil could have kicked himself.",
    "Most of the second part of Nesingwary's work was recovered, but four leaves were still out in the jungle.",
    "Barnil Stonepot declared the second part of the manuscript complete.",
    "Barnil had the tiger and panther hunts of the second part back in order.")
q(341, "Chapter III", "Stranglethorn Vale", 40, "greenhills", 2,
    "Barnil's favorite part told of Sir Erlgadin and Lady Rouack's first kill with a dwarven rifle, and ended on a cliffhanger. Leaves 18, 20, 21 and 24 were missing.",
    "Four leaves were still needed to finish the third part of Nesingwary's manuscript, the one Barnil liked best.",
    "Barnil Stonepot had the third part back together in one piece.",
    "Barnil was relieved to see his favorite part of the manuscript restored.")
q(342, "Chapter IV", "Stranglethorn Vale", 40, "greenhills", 2,
    "The last part of Nesingwary's manuscript held its big finale. Only leaves 25, 26 and 27 were missing.",
    "Three leaves stood between Barnil and the finale of Nesingwary's work.",
    "Barnil Stonepot had the final part of the manuscript ready.",
    "Barnil called the restored finale superb.")
q(585, "Speaking with Nezzliok", "Stranglethorn Vale", 40, "yenniku", 4,
    "Nezzliok's head admitted from the cauldron that he knew where the Darkspear child had been taken. He would say nothing until he was given three Skullsplitter trophy skulls as servants in the Nether.",
    "The bound spirit of Nezzliok demanded appeasement. Skullsplitter skulls from Balia'mah, Ziata'jai and Zul'Mamwe would buy his answer.",
    "Nezzliok was appeased. He looked forward to entering the Nether with three fine servants.",
    "Nezzliok's spirit accepted the three Skullsplitter skulls as his servants.")
q(586, "Speaking with Gan'zulah", "Stranglethorn Vale", 46, "yenniku", 4,
    "Gan'zulah's head cursed the questioner and demanded blood. He dared them to break themselves against Ana'thek the Cruel, chief of the Skullsplitters.",
    "Only revenge would cool Gan'zulah's rage. He wanted Ana'thek's shattered armor, and expected the attempt to fail.",
    "Gan'zulah could not deny what had been done, and his rage eased with Ana'thek defeated. He promised to wait for a rematch in the Nether.",
    "Gan'zulah grudgingly admitted Ana'thek's defeat. One day, he said, they would match strength again in the Nether.")
q(591, "The Mind's Eye", "Stranglethorn Vale", 46, "yenniku", 5,
    "Kin'weelay said the ogre mage Mai'Zoth held the Mind's Eye deep in the Mosh'Ogg mound. He knew Mai'Zoth from the Darkspear's years in Stranglethorn, and the Eye was the only hope for Yenniku.",
    "Mai'Zoth's magic was strong, and stronger still with the Mind's Eye. Without the jewel, Kin'weelay said, Yenniku could not be saved.",
    "Kin'weelay understood that Mai'Zoth had been sent to the Nether. He feared the ogre would rule anew among the spirits, but turned to the ritual that would bend the Eye to their needs.",
    "Kin'weelay had the Mind's Eye. Mai'Zoth was gone from the world of flesh, and the ritual could begin.")
q(598, "Split Bone Necklace", "Stranglethorn Vale", 42, "darkspear_trophies", 3,
    "The Darkspear no longer lived in Stranglethorn, but their war with the Skullsplitters went on. Split Bone Necklaces from the tribe to the southeast were Kin'weelay's next demand.",
    "The Darkspear's friendship was on offer in return for Skullsplitter necklaces.",
    "Kin'weelay said the Skullsplitters fell like saplings under a basilisk. The necklaces were a boon to the Darkspear.",
    "Kin'weelay counted the Split Bone Necklaces as a blow in the old feud.")
q(638, "Trollbane", "Arathi Highlands", 37, "trolkalar", 3,
    "Thoras Trollbane was dead, and Vol'jin wanted his sword Trol'kalar taken from the humans for the coming fight with Zul'Gurub's trolls.",
    "Nimboya sent word that Zengu, a seasoned Darkspear hunter, was at Hammerfall to oversee the effort to win Trol'kalar.",
    "Zengu welcomed the help at Hammerfall. Vol'jin's task would be difficult, he said.",
    "Zengu greeted the newcomer and called any help with Vol'jin's task necessary.")
q(189, "Bloodscalp Ears", "Stranglethorn Vale", 35, "kebok", 2,
    "Kebok was losing agents and guards to the Bloodscalp trolls, and dreaded explaining the costs to Baron Revilgaz. He offered pay for fifteen Bloodscalp ears.",
    "Bloodscalp skirmishes were costing Kebok his best guards. Troll ears would earn compensation.",
    "Kebok grumbled about profit margins, then remembered to pay.",
    "Kebok took the ears and paid, still muttering about costs.")
q(213, "Hostile Takeover", "Stranglethorn Vale", 36, "kebok", 3,
    "Gelriz was pushing out the moguls the trade princes had appointed, and now crossed Baron Revilgaz. His answer, Kebok decided, was to steal the blue crystals the Venture Company's geologists were studying.",
    "Revilgaz let Kebok handle Gelriz's Venture Company his own way. The geologists near Lake Nazferiti carried samples of strange blue stone.",
    "Kebok saw that the crystals had been tumbled, likely for fuel or a catalyst. Samples would go to Head Chemist Gigglefont.",
    "Kebok studied the stolen blue crystals and decided Head Chemist Gigglefont should see them.")
q(209, "Skullsplitter Tusks", "Stranglethorn Vale", 42, "kebok", 2,
    "Tiger fangs for the South Seas trade were expensive to come by. Skullsplitter tusks, Kebok had found, made convincing forgeries.",
    "What the buyer did not know would not hurt them, Kebok reasoned. He needed Skullsplitter tusks for the monthly shipment.",
    "Kebok wished the tusks had been cleaned better, but expected his operation's output to rise.",
    "Kebok had his tusks for the forged fang shipment.")
q(621, "Zanzil's Secret", "Stranglethorn Vale", 44, "dues", 3,
    "Zanzil the Outcast had been exiled because his own leaders feared him. His mixture of jungle plants bent his followers' will and strengthened their bodies.",
    "Samples of Zanzil's mixture would be worth much to anyone who wanted to control others, and Crank Fizzlebub meant to find a use for them.",
    "Crank Fizzlebub paid for the samples of Zanzil's mixture, with a little extra for discretion.",
    "Crank paid well for the mixture, and a bit more to keep quiet.")
q(609, "Voodoo Dues", "Stranglethorn Vale", 44, "dues", 3,
    "Maury Club Foot Wilkins, Jon-Jon the Crow and Chucky Ten Thumbs owed months of debts. They were said to be cursed and wandering the jungle ruins.",
    "The three debtors now wandered the Ruins of Aboraz and Jubuwal under some curse. Regardless, their creditor wanted his due.",
    "Their creditor was pleased with the valuables, especially whatever was inside Maury's foot. They should have been careful whom they gambled with, he said.",
    "The cursed debtors' valuables were collected. Nobody should bet what they could not afford to lose, their creditor said.")
q(613, "Cracking Maury's Foot", "Stranglethorn Vale", 44, "dues", 2,
    "Maury had put a lock on his wooden foot, and his loot was inside. He had once been chased from the Mosh'Ogg mound for winning too much, so the ogres might have the key.",
    "The key to Maury's foot was likely somewhere among the Mosh'Ogg ogres he used to gamble with.",
    "Maury's key was found, and the lock on his foot could be opened. The creditor called it a big help.",
    "Maury's key came back from the ogres, and the reward with it.")
q(587, "Up to Snuff", "Stranglethorn Vale", 41, "sailors", 2,
    "Deeg liked grog and good snuff when he came into port. Booty Bay's herbalist had sold out, his shipment hijacked by the Bloodsail.",
    "The Bloodsail had taken the herbalist's snuff, and Deeg wanted some before he shipped out.",
    "Deeg had his snuff just before shipping out, and could not thank his old friend enough.",
    "Deeg was delighted with the recovered snuff.")
q(576, "Keep An Eye Out", "Stranglethorn Vale", 42, "sailors", 2,
    "Dizzy One-Eye had a glass eye enchanted by a wizard in Menethil. Bloodsail Buccaneers had jumped him and taken it.",
    "A lookout who could not see was no use in the crow's nest. The Bloodsail had Dizzy's enchanted eye.",
    "Dizzy One-Eye found his beautiful eye still fit, and he could see again.",
    "Dizzy had his enchanted eye back from the Bloodsail, and his sight with it.")
hl(342, "Barnil Stonepot had the finale of Nesingwary's manuscript back together, its last missing leaves found.",
    "The last part of the scattered manuscript was restored for Barnil.")
hl(586, "Gan'zulah's rage eased once Ana'thek the Cruel was defeated. He promised a rematch in the Nether.",
    "Gan'zulah's head admitted that Ana'thek had fallen.")
hl(591, "Kin'weelay received the Mind's Eye from Mai'Zoth's mound and began the ritual to bend it to Yenniku's rescue.",
    "Mai'Zoth was gone and the Mind's Eye came to Kin'weelay, the only hope of saving Yenniku.")
for _, id in ipairs({585, 586, 591}) do P.questIDs[id].threadLabel = P.threads.world_yenniku end
P.questIDs[598].threadLabel = P.threads.world_darkspear_trophies
for _, id in ipairs({339, 340, 341, 342, 585, 586, 591, 598, 638, 189, 213, 209, 621, 609, 613, 587, 576}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-10: early dungeon errands. The Deadmines (Riell's bandanas, the lost
-- miners of the Moonbrook cave-in, Shoni's shredder power supply), Shadowfang Keep
-- for the Forsaken (the deathstalkers, Arugal's head), the Stockade's prisoners
-- and riot, Ragefire Chasm (Maur Grimtotem's satchel, the Searing Blade's books for
-- Varimathras), and two Wailing Caverns finds for Ratchet. Each outcome stays with
-- its completion speaker; the Stockade riot's further secrets are only promised.
P.threads.world_moonbrookmine = "the miners lost in the Moonbrook cave-in"
P.threads.world_gnomeregan = "the effort to retake Gnomeregan"
P.threads.world_stockade = "the prisoners of the Stormwind Stockade"
P.threads.world_shadowfang = "the Forsaken campaign against Arugal"
P.threads.world_ragefire = "the errands into Ragefire Chasm"
P.threads.world_ratchet = "Ratchet's errands below the Barrens"
q(214, "Red Silk Bandanas", "Westfall", 17, "moonbrookmine", 3,
    "Scout Riell had learned that the Defias marked rank by the material of their red bandanas. The highest-ranking members would be in VanCleef's secret hideout.",
    "Silk bandanas marked the Defias leaders. Ten of them would prove their deaths to Riell.",
    "Scout Riell saluted the work on behalf of the People's Militia, and promised the land would soon be returned to its people.",
    "Riell took the silk bandanas as proof against the Defias leadership and gave the militia's thanks.")
q(168, "Collecting Memories", "Stormwind City", 18, "moonbrookmine", 3,
    "Wilder Thistlenettle had lost many friends when the tunnel under Moonbrook caved in. Their Miners' Union cards would let their families know.",
    "Somewhere in the collapsed tunnels under Moonbrook lay the union cards of Wilder's lost co-workers.",
    "Wilder Thistlenettle took the union cards and promised to notify the families.",
    "Wilder thanked the finder. The cards would bring some peace to the dead of the cave-in.")
q(167, "Oh Brother...", "Stormwind City", 20, "moonbrookmine", 4,
    "Wilder had escaped the Moonbrook cave-in, but his brother had not been heard from since. His brother always carried an Explorers' League badge.",
    "Any sign of Wilder's brother in the tunnels, even his Explorers' League badge, would give some peace of mind.",
    "Wilder Thistlenettle saw the badge and knew his suspicions were right. His brother was gone, and the answer, though grim, ended the mystery.",
    "Wilder grieved for his poor brother, and thanked the bearer for an answer, however grim.")
q(2040, "Underground Assault", "Stormwind City", 20, "gnomeregan", 3,
    "Troggs held Gnomeregan. Deep in the Deadmines was a working goblin shredder, and Shoni the Shilent needed its power supply.",
    "The shredder's power supply would drive the gyrodrillmatic excavationators through Gnomeregan's rock and open the way for a gnomish assault.",
    "Shoni the Shilent said Gnomeregan was one step closer to its day of liberation.",
    "Shoni had the shredder's power supply for the excavationators.")
q(1098, "Deathstalkers in Shadowfang", "Shadowfang Keep", 25, "shadowfang", 3,
    "Two deathstalkers, Adamant and Vincent, had gone into Shadowfang Keep to scout for an assault and not returned. High Executor Hadrec needed their report.",
    "Hadrec's assault on Shadowfang depended on the report of Deathstalkers Adamant and Vincent.",
    "Deathstalker Vincent's body lay broken. Adamant would carry his own report to Hadrec, but whatever Vincent had learned died with him.",
    "Vincent was found dead, a small trinket clutched in his hand. Adamant's report would still reach Hadrec.")
q(1014, "Arugal Must Die", "Silverpine Forest", 27, "shadowfang", 5,
    "Silverpine could not be held for the Dark Lady while Arugal lived in Shadowfang Keep. Arugal's head was what Dalar Dawnweaver wanted.",
    "Arugal's magic would be seen to by Dalar Dawnweaver, but someone else had to bring the wizard's head.",
    "Dalar Dawnweaver declared Silverpine free of Arugal at last, a great service to the Dark Lady.",
    "Dalar received Arugal's head. The Forsaken's hold on Silverpine was stronger for it.")
q(386, "What Comes Around...", "Redridge Mountains", 25, "stockade", 3,
    "Targorr the Dread had been Gath'Ilzogg's executioner and tortured Stormwind's soldiers. A noble had put a hold on his execution, and Guard Berton suspected foul play.",
    "Berton feared some noble's trickery would free Targorr the Dread. He wanted the orc beheaded in the Stockade.",
    "Guard Berton was glad Targorr had met his fate. Sometimes, he said, justice was found outside the courtroom.",
    "Berton welcomed news of Targorr's death and called it justice beyond politics.")
q(377, "Crime and Punishment", "Duskwood", 26, "stockade", 3,
    "Dextren Ward had sold bodies from Darkshire's cemetery to Morbent Fel. Lord Ebonlocke sentenced him to death, but Stormwind kept him in its prison.",
    "Councilman Millstipe saw Ward's imprisonment as the House of Nobles spitting in Darkshire's eye. He wanted Ward's hand.",
    "Councilman Millstipe cheered Ward's death. The families had their peace, and the House of Nobles had a message.",
    "Millstipe said Duskwood would break free of Stormwind if its needs were ignored much longer.")
q(387, "Quell the Uprising", "Stormwind City", 26, "stockade", 3,
    "The Stockade's prisoners had risen, and Warden Thelwater feared for his job. He suspected foul play and wanted the inmates forced into submission.",
    "Thelwater wanted the rioting Defias prisoners killed. Insurgency, he said, was punished by death.",
    "Warden Thelwater called the effort valiant. The problem was bigger than both of them, he admitted.",
    "Thelwater was thankful for the work in the Stockade, though the riot was far from over.")
q(388, "The Color of Blood", "Stormwind City", 26, "stockade", 4,
    "Nikova Raskol's grandson Mac had guarded the Stockade at fourteen. He scolded prisoners for tearing blankets into gang scarves, and was stabbed in the back.",
    "Nikova wanted revenge for her grandson. Ten red wool bandanas from the Defias prisoners would be her proof.",
    "Nikova Raskol looked at the bandanas her Mac had died over and called it a waste. The past could not be undone, but her family had justice.",
    "Nikova grieved over the red bandanas. Her grandson's death had been avenged.")
q(378, "The Fury Runs Deep", "Wetlands", 27, "stockade", 4,
    "Roggo had proof that Kam Deepfury helped plan the attack on Thandol Span, where Longbraid lost his kin. The Dark Iron had to die, said Motley Garmason.",
    "Kam Deepfury was held in the Stockade for political reasons. Bound to stay with Longbraid, Motley wanted his head.",
    "Motley Garmason said the Thandol Span victims' families could rest. Longbraid's brother had been avenged.",
    "Motley was glad Deepfury had paid. The cowardly Dark Iron got what he deserved, he said.")
q(391, "The Stockade Riots", "Stormwind City", 29, "stockade", 5,
    "Bazil Thredd led the riot. The warden did not trust the volunteer, and Thelwater demanded Thredd's head as proof of loyalty.",
    "The warden wanted Thredd's head, and threatened the same fate if the volunteer took the rioters' side.",
    "Warden Thelwater admitted he had misjudged the volunteer. Without Thredd, the riots might be controlled, and he knew something of Thredd's activities.",
    "Thelwater had not expected anyone to come out alive. With Thredd dead, he offered what he knew of the ringleader's dealings.")
q(5722, "Searching for the Lost Satchel", "Ragefire Chasm", 16, "ragefire", 2,
    "Magatha's servant Maur Grimtotem had found something in Ragefire Chasm and never came out. Rahauro asked for his body and anything he carried.",
    "Magatha wanted Maur Grimtotem's body found, and whatever he had discovered while trying to speak with the troggs.",
    "Maur's body had been beaten by clubs and fists, but the troggs had left his belongings.",
    "Maur Grimtotem was found dead in the Chasm, his gear untouched.")
q(5724, "Returning the Lost Satchel", "Thunder Bluff", 16, "ragefire", 2,
    "A satchel lay under Maur's body, held tight as if he had died protecting it.",
    "Maur Grimtotem's satchel had to go back to Rahauro in Thunder Bluff.",
    "Rahauro thanked the finder and gave the reward Magatha had set aside.",
    "Rahauro received the satchel and paid as Magatha had instructed.")
q(5725, "The Power to Destroy...", "Undercity", 16, "ragefire", 3,
    "Two powerful spell books were in the hands of the Searing Blade, in the caverns below Orgrimmar. The Dark Lady wished to borrow them, Varimathras said.",
    "The Dark Lady wanted the Searing Blade's spell books, and Varimathras had a hundred other tasks to see to.",
    "Varimathras called the service to the Dark Lady well done, and hinted at future tasks.",
    "Varimathras took the Searing Blade's books for the Dark Lady.")
q(959, "Trouble at the Docks", "The Barrens", 18, "ratchet", 2,
    "Crane Operator Bigglefuzz had dropped a cargo stack, and Mad Magglish ran off with a bottle of 99-year-old port. He fled into the Wailing Caverns.",
    "The port Mad Magglish stole was a gift from Baron Revilgaz to Gazlowe. Its loss had put Bigglefuzz's job at risk.",
    "Crane Operator Bigglefuzz was saved from losing his job. Gazlowe would get his gift at once.",
    "Bigglefuzz had the port back for Gazlowe.")
q(6981, "The Glowing Shard", "The Barrens", 26, "ratchet", 2,
    "A green shard with smoke swirling under its surface was disturbing to look at. Someone in Ratchet might know what it was.",
    "Something about the glowing shard from the Wailing Caverns made it worth taking to Ratchet.",
    "The shard puzzled its examiner in Ratchet, who had never seen anything like it.",
    "Its examiner in Ratchet was taken aback by the glowing shard.", true)
fallback("The Glowing Shard", "The Barrens", "ratchet", "3366,6981",
    "A green shard from the Wailing Caverns had smoke swirling under its surface.",
    "The strange glowing shard seemed worth showing to someone in Ratchet.",
    "The glowing shard was taken to Ratchet.",
    "Ratchet saw the strange green shard.")
hl(167, "Wilder Thistlenettle saw his brother's Explorers' League badge and knew he had died in the Moonbrook cave-in.",
    "The badge from the collapsed tunnels ended Wilder's hope for his brother.")
hl(391, "Warden Thelwater had Bazil Thredd's head, and admitted he had misjudged the one who brought it.",
    "The Stockade riot lost its leader. Thelwater offered what he knew of Thredd's activities.")
hl(1014, "Dalar Dawnweaver declared Silverpine free of Arugal, a great service to the Dark Lady.",
    "Arugal's head reached Dalar at the Sepulcher.")
for _, id in ipairs({214, 168, 167, 2040, 1098, 1014, 386, 377, 387, 388, 378, 391, 5722, 5724, 5725, 959, 6981}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-11: Theldurin the Lost in the Badlands, now that the notes lane has
-- discovery facts for Gerrig Bonegrip (gerrig.cult: 727/735), Keeper Bel'dugur
-- (beldugur.cult: 728/736) and the bargain (yagyin.bargain: 735/736). Each stage
-- says only what its own text shows: Gerrig and Bel'dugur greet a supposed fellow
-- member, ask for three relics, and the digest reaches Theldurin. The thread label
-- names Theldurin's fear, not the order. 692 only fears that Myzrael may be free.
P.threads.world_yagyin = "Theldurin's search for Yagyin's Digest"
q(692, "The Lost Fragments", "Badlands", 41, "myzrael", 3,
    "Theldurin the Lost warned that the Scroll of Myzrael could pull her to the surface. Then he feared she might already be free, and the scroll needed to bind her again.",
    "Enraged elementals had stolen the Scroll of Myzrael and torn it apart. They fought over its fragments behind Theldurin's camp.",
    "Theldurin the Lost had the fragments, perhaps the only chance against Myzrael. He went looking for his scrap-ratchet to piece them together.",
    "Theldurin welcomed the torn scroll's fragments and set about reattaching them.")
q(727, "To Ironforge for Yagyin's Digest", "Ironforge", 40, "yagyin", 4,
    "The Tablet of Ryun'eh told Theldurin much, but not enough. Those he had fled kept a digest written by Yagyin, and Gerrig Bonegrip of Ironforge's Forlorn Cavern would take the bearer of his sigil for one of them.",
    "Theldurin wanted Yagyin's Digest for the knowledge it held. He gave a sigil to show Gerrig Bonegrip in the Forlorn Cavern.",
    "Gerrig Bonegrip saw the sigil and greeted the visitor as a brother, with praise to the dwellers beneath.",
    "Gerrig welcomed the sigil's bearer as one of his own.")
q(728, "To the Undercity for Yagyin's Digest", "Undercity", 40, "yagyin", 4,
    "The Tablet of Ryun'eh had not told Theldurin enough. Those he had fled studied a digest written by Yagyin, and Keeper Bel'dugur of the Undercity would take the bearer of his sigil for one of them.",
    "Theldurin sent his sigil to Keeper Bel'dugur in the Undercity, hoping to obtain Yagyin's Digest.",
    "Keeper Bel'dugur saw the sigil and urged discretion. Some would see their pledge fail if they knew of it, he warned.",
    "Bel'dugur took the sigil's bearer for a fellow believer, and counseled patience and care.")
q(735, "The Star, the Hand and the Heart", "Ironforge", 44, "yagyin", 4,
    "Gerrig assumed the digest was for a new branch of his order and asked no more. He had a spare copy, but wanted three items of power first, written down rather than spoken.",
    "An extra copy of Yagyin's Digest could be had from Gerrig Bonegrip for three relics, whose names he dared not say aloud.",
    "Gerrig Bonegrip called the visitor resourceful. If the charge was truly to found a new branch of the order, he believed it would be run well.",
    "Gerrig had his three relics, and judged their bearer resourceful.", true)
q(736, "The Star, the Hand and the Heart", "Undercity", 44, "yagyin", 4,
    "Bel'dugur assumed the digest was meant to gather a new flock. He would help, but wanted three items of power, which he would only write down.",
    "Keeper Bel'dugur would part with Yagyin's Digest for three relics. Gaining them, he said, would prove the bearer worthy.",
    "Keeper Bel'dugur was impressed by the relics and called their bearer an asset.",
    "Bel'dugur had his relics, won by great skill or great fortune, he said.", true)
fallback("The Star, the Hand and the Heart", "Badlands", "yagyin", "735,736",
    "Three items of power were the price of Yagyin's Digest.",
    "The keeper of Yagyin's Digest wanted three relics in exchange.",
    "The three relics were delivered.",
    "The price for Yagyin's Digest was paid.")
q(737, "Forbidden Knowledge", "Badlands", 40, "yagyin", 5,
    "The digest was handed over with a warning to keep it from unfriendly hands. It held many truths, and the truth could burn.",
    "Yagyin's Digest was ready to go back to Theldurin, with a warning that its knowledge was dangerous.",
    "Theldurin the Lost felt hope glimmer. He praised the deed, then warned that if they were freed and rose to the surface, everyone would be worm food.",
    "Theldurin had Yagyin's Digest at last. It might save them all, he said, unless they rose first.")
hl(727, "Gerrig Bonegrip took Theldurin's sigil as a mark of membership and greeted its bearer as a brother.",
    "Gerrig welcomed the sigil's bearer in the Forlorn Cavern, with praise to the dwellers beneath.")
hl(737, "Yagyin's Digest reached Theldurin the Lost, who felt hope, then dread of what might rise.",
    "Theldurin received the digest and praised the deed, while fearing what might yet be freed.")
for _, id in ipairs({692, 727, 728, 735, 736, 737}) do src(id, "LoreForever quest:" .. id .. " (facts only); notes3 discovery facts gerrig.cult, beldugur.cult, yagyin.bargain") end

-- Batch W3-12: Blackfathom Deeps for both factions (the Argent Dawn's scouts and
-- Kelris, Gershala's brain stems, Je'neu Sancrea's crystals, Lorgus, the fathom
-- core and Aquanis's globe) and the Scarlet Monastery errands (Varimathras, the
-- Compendium, the Mythology of the Titans, Vorrel's ring, Raleigh's charge). A
-- boss is dead only where the completion says the deed was done.
P.threads.world_blackfathom = "the Twilight's Hammer in Blackfathom Deeps"
P.threads.world_scarletmonastery = "the errands into the Scarlet Monastery"
q(6562, "Trouble in the Deeps", "Ashenvale", 22, "blackfathom", 2,
    "Tsunaman sent word that Je'neu Sancrea needed help at Zoram'gar Outpost, on the far western coast of Ashenvale.",
    "At Zoram'gar Outpost, among forces that would not welcome the Horde, Je'neu Sancrea of the Earthen Ring waited.",
    "Je'neu Sancrea welcomed the one Tsunaman had sent. They had matters to discuss.",
    "Je'neu greeted Tsunaman's messenger at Zoram'gar.")
q(6563, "The Essence of Aku'Mai", "Ashenvale", 22, "blackfathom", 3,
    "The naga were harvesting sapphire clusters in the first tunnels of Blackfathom Deeps. Their elemental power was great, Je'neu said, and they had to be kept from the naga.",
    "Until the naga's purpose was known, Je'neu wanted the sapphires of Blackfathom taken before they could be used.",
    "Je'neu Sancrea felt the spirits of water clinging to the crystals. Whatever the naga had meant to do with them, they no longer had them.",
    "Je'neu took the sapphires and was glad they were out of naga hands.")
q(1198, "In Search of Thaelrid", "Blackfathom Deeps", 24, "blackfathom", 3,
    "Dawnwatcher Shaedlass gathered news for the Argent Dawn. The scout Argent Guard Thaelrid had gone into Blackfathom Deeps weeks before and not reported.",
    "Rumors joined the Twilight's Hammer and the naga in Blackfathom Deeps. Shaedlass wanted her missing scout found.",
    "Argent Guard Thaelrid was found alive. He said a wicked plot was underway in the corrupted temple.",
    "Thaelrid welcomed the help Shaedlass had sent, and warned of a plot in the depths.")
q(1275, "Researching the Corruption", "Darkshore", 24, "blackfathom", 2,
    "Gershala Nightwhisper feared the blood elves would be deformed by demonic magic, as the naga and satyrs had been. Brain stems from both would help that study.",
    "Brain stems from the satyrs and naga of Blackfathom Deeps might show Gershala where the blood elves were headed.",
    "Gershala Nightwhisper thanked the traveler for selfless help with research meant for all Azeroth, then went back to work.",
    "Gershala took the brain stems and turned at once to her research.")
q(1199, "Twilight Falls", "Darnassus", 25, "blackfathom", 3,
    "The Twilight's Hammer sought the return of the Old Gods and had allied with the naga in Blackfathom Deeps, once a temple with a great moonwell.",
    "War on the Twilight's Hammer in Blackfathom was what Argent Guard Manados asked for, with proof brought back.",
    "Argent Guard Manados commended the work against the Twilight's Hammer on behalf of the Argent Dawn.",
    "Manados praised the courage shown against the cultists.")
fallback("Allegiance to the Old Gods", "Blackfathom Deeps", "blackfathom", "6564,6565",
    "Lorgus of the Twilight's Hammer served the Old Gods in Blackfathom Deeps.",
    "Je'neu Sancrea wanted the Twilight's Hammer plan in Blackfathom stopped.",
    "The matter of Lorgus moved a step further.",
    "Je'neu's effort against the Twilight's Hammer went on.")
q(6565, "Allegiance to the Old Gods", "Ashenvale", 26, "blackfathom", 4,
    "Lorgus of the Twilight's Hammer had a plan to serve the Old Gods, creatures of chaos defeated long ago. Too weak to stop him himself, Je'neu asked for help.",
    "Lorgus had to die in Blackfathom Deeps before the cultist's plan could be finished, Je'neu said.",
    "Je'neu Sancrea knew the Twilight's Hammer was not stopped, but another of their plans had been. They could rest easy for now.",
    "Je'neu was relieved that Lorgus was dead and his plan staved off.", true)
q(824, "Je'neu of the Earthen Ring", "Ashenvale", 27, "blackfathom", 3,
    "The Earthen Ring studied the elements and knew more of old gods and legends than most scholars. Mastok had a friend in the Ring at Zoram'gar.",
    "Mastok Wrilehiss sent the strange globe to Je'neu Sancrea, who might understand its significance.",
    "Je'neu Sancrea found the globe disturbing. Powerful elementals drew energy from such devices, and this one was tainted, so the Earthen Ring would study it.",
    "Je'neu took the tainted globe for the Earthen Ring's study and gave a fair exchange.")
q(1200, "Blackfathom Villainy", "Darnassus", 27, "blackfathom", 5,
    "Argent Guard Thaelrid said Blackfathom had been a temple of Elune until an Old God's corruption tainted its moonwell and Aku'Mai rose. The cultist Kelris sacrificed innocents to Aku'Mai.",
    "Kelris led the Twilight's Hammer in Blackfathom. Thaelrid wanted his head taken to Selgorm in Darnassus.",
    "Selgorm saluted the deed on behalf of the Argent Dawn. Kelris had long eluded them, and his end spared many innocents.",
    "Selgorm had long thought Kelris dead or missing. His death, Selgorm said, had saved many lives.", true)
q(6561, "Blackfathom Villainy", "Thunder Bluff", 27, "blackfathom", 5,
    "Thaelrid said the Old God's corruption had tainted Blackfathom's moonwell and raised Aku'Mai. Kelris and his cultists sacrificed innocents there.",
    "Kelris's head was to go to Bashana in Thunder Bluff, Thaelrid asked.",
    "Bashana praised the Earthmother. Kelris had sought to return the world to chaos, and his death spared many innocents.",
    "Bashana thanked the slayer of Kelris, a worshipper of the Old Gods.", true)
fallback("Blackfathom Villainy", "Blackfathom Deeps", "blackfathom", "1200,6561",
    "Kelris led the Twilight's Hammer in Blackfathom Deeps.",
    "The Argent Dawn wanted Kelris stopped.",
    "The matter of Kelris was taken to the Argent Dawn's contacts.",
    "Word of Blackfathom reached the Argent Dawn's allies.")
fallback("Amongst the Ruins", "Blackfathom Deeps", "blackfathom", "908,6921",
    "The Twilight's Hammer had moved into the Moonshrine Ruins of Blackfathom.",
    "A fathom core in Blackfathom's ruins held a history of the elements there.",
    "The fathom core was sought for study.",
    "The search of the Moonshrine Ruins went on.")
q(6921, "Amongst the Ruins", "Ashenvale", 27, "blackfathom", 3,
    "The Twilight's Hammer had moved into the Moonshrine Ruins of Blackfathom. A fathom core in the ruins' fathom stone would show all the elemental activity there.",
    "The fathom core lay in a stone in the Moonshrine Ruins' waters, and it would tell Je'neu what the cultists were doing.",
    "Je'neu Sancrea called the fathom core an incredible well of information. The Earthen Ring would uncover what the Twilight's Hammer was doing.",
    "Je'neu took the fathom core and thanked the helper on behalf of the Earthen Ring and the Horde.", true)
fallback("Baron Aquanis", "Blackfathom Deeps", "blackfathom", "909,6922",
    "Baron Aquanis, a corrupted water elemental, had left behind a strange globe.",
    "The globe from Blackfathom seemed worth showing to a scholar of the elements.",
    "The globe from Baron Aquanis was taken for study.",
    "Aquanis's globe went to those who studied the elements.")
q(6922, "Baron Aquanis", "Ashenvale", 30, "blackfathom", 4,
    "The defeated water elemental Baron Aquanis had left a strange globe, sloshing with putrid water. If anyone could make sense of it, it was Je'neu Sancrea.",
    "A globe that had fed Baron Aquanis seemed worth taking to the Earthen Ring at Zoram'gar.",
    "Je'neu Sancrea expected the globe to show what had corrupted Baron Aquanis, and how. He suspected the Twilight's Hammer.",
    "Je'neu took Aquanis's globe for study, with the Earthen Ring's warmest regards.", true)
q(1048, "Into The Scarlet Monastery", "Undercity", 42, "scarletmonastery", 5,
    "While the Dark Lady dealt with the Lich King, Varimathras saw to the Scarlet Crusade at home. He wanted High Inquisitor Whitemane and her lieutenants killed.",
    "Whitemane, Commander Mograine, Herod and Houndmaster Loksey were to die in the Scarlet Monastery, by Varimathras's order.",
    "Varimathras said the Dark Lady had been well served, and the loyalty shown would be remembered.",
    "Varimathras noted the loyalty to the Forsaken shown in the Monastery.")
q(1049, "Compendium of the Fallen", "Thunder Bluff", 38, "scarletmonastery", 3,
    "Sage Truthseeker distrusted the Forsaken and wanted to counsel Cairne well. The Compendium of the Fallen lay in the Scarlet Monastery, guarded by zealots.",
    "The Scarlet zealots' research might be useful, Sage Truthseeker thought, beginning with the Compendium of the Fallen.",
    "Sage Truthseeker had begun to wonder if the Compendium existed. The tauren of Thunder Bluff had been well served.",
    "Truthseeker welcomed the Compendium of the Fallen at last.")
q(1050, "Mythology of the Titans", "Ironforge", 38, "scarletmonastery", 3,
    "The library of the old Monastery in Tirisfal Glades was rumored to hold Mythology of the Titans, and Librarian Mae Paledust in Ironforge wanted it to study the past.",
    "The Explorers' League wanted Mythology of the Titans rescued from the Scarlet Crusade's halls and kept in Ironforge.",
    "Librarian Mae Paledust thanked the rescuer of the sacred text on behalf of the Explorers' League.",
    "Mae Paledust welcomed Mythology of the Titans to Ironforge.")
q(1051, "Vorrel's Revenge", "Hillsbrad Foothills", 33, "scarletmonastery", 4,
    "Vorrel Sengutz was dying after weeks of torture by Interrogator Vishas, who had given Vorrel's wedding ring to his own wife, Nancy. His last wish was Nancy's death and the ring's return to his wife Monika in Tarren Mill.",
    "Vorrel's last wish was revenge on Vishas's wife Nancy, by Lake Lordamere, and his ring returned to Monika.",
    "Monika Sengutz received the ring. Vorrel had led a troubled existence, she said, and been a good mate.",
    "Monika mourned Vorrel and cursed the humans.")
q(1053, "In the Name of the Light", "Hillsbrad Foothills", 40, "scarletmonastery", 5,
    "Raleigh the Devout had once served the Scarlet Crusade with pride, until he saw innocents tortured as plagued. He wanted its leaders in the Monastery slain.",
    "Raleigh named Whitemane, Mograine, Herod and Loksey. With them gone, he hoped the true cause might be rekindled.",
    "Raleigh the Devout did not revel in the loss of life, but accepted it for the greater good. The deeds in the Monastery had spared many innocents.",
    "Raleigh saluted the tenacity shown in the Monastery and the lives spared by it.")
hl(1200, "Selgorm received Kelris's head in Darnassus and saluted the deed for the Argent Dawn.",
    "Kelris was dead, and Selgorm said many innocents had been spared.")
hl(6561, "Bashana received Kelris's head in Thunder Bluff and praised the Earthmother.",
    "Kelris was dead, and Bashana thanked his slayer.")
hl(1053, "Raleigh the Devout accepted the deaths of the Monastery's leaders for the greater good. Many innocents had been spared.",
    "Raleigh saluted the deeds in the Scarlet Monastery.")
for _, id in ipairs({6562, 6563, 1198, 1275, 1199, 6565, 824, 1200, 6561, 6921, 6922}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end
for _, id in ipairs({1048, 1049, 1050, 1051, 1053}) do src(id) end

-- Batch W3-13: Uldaman. Baelog's lost dwarves and the Chamber of Khaz'mul, the
-- Tablet of Will for Belgrum, the power stones and the magenta caps, and the dead
-- paladin's necklace for both factions (Talvash del Kissel in Ironforge; Droffers
-- and Son and Jarkal Mossmeld for the Horde). Each stage claims only its own find:
-- the gems are located in 2200/2284, found in 2201/2339, and the necklace is
-- restored only in 2204 and 2341.
P.threads.world_talvash = "Talvash's shattered necklace"
P.threads.world_droffers = "the necklace from Uldaman"
P.threads.world_ulda_reagents = "the alchemists' Uldaman errands"
q(2398, "The Lost Dwarves", "Uldaman", 40, "uldaman", 3,
    "The troggs had overrun the Uldaman dig site so quickly that some dwarves might be trapped inside. Just before they came, Baelog had led a small band deep into the site.",
    "Prospector Stormpike feared for Baelog's band, caught behind the troggs' lines in Uldaman.",
    "Baelog was alive, and only worried about losing a bet with Olaf. Olaf had wagered his beard would reach his knees before another living face appeared.",
    "Baelog's band was found alive. He won his bet with Olaf and offered to split the winnings.")
q(2240, "The Hidden Chamber", "Ironforge", 40, "uldaman", 4,
    "Baelog's diary described how to open the locked door of the Chamber of Khaz'mul. His band was stuck, so someone else had to explore it.",
    "The Chamber of Khaz'mul lay behind a great locked door in Uldaman, and Baelog knew how to open it.",
    "Prospector Stormpike had doubted the Chamber of Khaz'mul existed. He hoped the find would spur Ironforge's leaders to retake Uldaman.",
    "Stormpike was amazed to hear of the chamber. If Uldaman were ever retaken, its secrets would belong to Ironforge.")
q(1139, "The Lost Tablets of Will", "Ironforge", 45, "uldaman", 5,
    "Hammertoe had dreamt of the Tablet of Will, a shard the titans inscribed to give their creations a will of their own. It had to be found before the Shadowforge clan could use it, Belgrum said.",
    "Hammertoe's death was not to be in vain. The Tablet of Will lay somewhere in Uldaman, and Belgrum feared what the Dark Irons' golems could become with it.",
    "Advisor Belgrum could hardly believe it. The stone shard would go to the king's mages to test the legends.",
    "Belgrum took the Tablet of Will for the king's mages, saying the help had gone beyond anything he expected.")
q(2418, "Power Stones", "Badlands", 36, "uldaman", 2,
    "The Shadowforge had made a tinkerer study two kinds of stones from Uldaman, then thrown him out once he found them to be stable power sources. He wanted both kinds for himself.",
    "Uldaman's strange stones could power devices for a long time, if treated right. Some were wanted by the tinkerer who had learned their secret.",
    "The tinkerer was delighted with the stones, sure his devices would keep going and going.",
    "The power stones went to the tinkerer, who had a robotic rodent waiting for them.")
q(17, "Uldaman Reagent Run", "Badlands", 42, "ulda_reagents", 2,
    "An alchemist wanted a dozen magenta fungus caps, a newly found plant growing deep in Uldaman, though the clusters could spew poison spores.",
    "Magenta fungus caps grew deep in Uldaman, and their alchemical use was worth studying.",
    "The alchemist welcomed the caps and gave a potent restorative from a personal stock.",
    "The caps were an interesting study, the alchemist said, and paid with a brew.", true)
q(2202, "Uldaman Reagent Run", "Loch Modan", 42, "ulda_reagents", 2,
    "An alchemist had heard of magenta fungus caps deep in the Uldaman dig site and wanted a dozen to study.",
    "Magenta fungus caps from Uldaman might have alchemical uses, and an alchemist would trade an elixir for them.",
    "The alchemist welcomed the caps and gave a potent restorative brew in return.",
    "The magenta caps reached the alchemist, who paid in elixirs.", true)
fallback("Uldaman Reagent Run", "Badlands", "ulda_reagents", "17,2202",
    "An alchemist wanted magenta fungus caps from deep in Uldaman.",
    "Magenta fungus caps from Uldaman were wanted for study.",
    "The alchemist had the magenta caps.",
    "The caps from Uldaman were delivered.")
q(2198, "The Shattered Necklace", "Ironforge", 41, "talvash", 3,
    "A shattered necklace from Uldaman bore Ironforge's seal and the letters TdK. Its three gems were missing.",
    "The necklace's seal and engraved initials pointed to a maker in Ironforge.",
    "Talvash del Kissel admitted making the necklace, but would not give information away for free.",
    "Talvash recognized his work and named a price for what he knew.")
q(2199, "Lore for a Price", "Ironforge", 41, "talvash", 3,
    "Talvash's reputation had been ruined by a competitor, and he had no copper. Five silver bars would finish his first order in an age.",
    "In exchange for five silver bars, Talvash would tell what he knew of the necklace.",
    "Talvash del Kissel explained that he had made the necklace for a paladin who went to cleanse Uldaman's taint. The paladin had died there, and Talvash's troubles began.",
    "Talvash told of the paladin who had carried his necklace into Uldaman and died.")
q(2200, "Back to Uldaman", "Uldaman", 42, "talvash", 3,
    "A rival had spread word that Talvash's necklace cursed the paladin. Talvash would reassemble it if the gems were found and his name cleared.",
    "The paladin's body in Uldaman might hold the clue to the gems. Talvash sent a phial to reach him from there.",
    "The paladin's diary named the gems' hiding places. Shadowforge dwarves had the ruby, the troggs had hidden the topaz near trapped dwarves, and the trogg elder held the sapphire.",
    "Reading the dead paladin's diary revealed where each of the three gems was.")
q(2201, "Find the Gems", "Uldaman", 43, "talvash", 4,
    "The paladin's diary pointed to the Shadowforge and the troggs. Once the gems were found, Talvash was to be told through the Phial of Scrying.",
    "With the diary's clues, the search for the ruby, topaz and sapphire began in earnest.",
    "Talvash confirmed the three gems through the scrying bowl. The necklace still needed a strong power source.",
    "Talvash saw the gems in the phial's water and said the work was not quite done.")
q(2204, "Restoring the Necklace", "Ironforge", 44, "talvash", 5,
    "The necklace needed a power source, and Talvash thought the biggest construct in Uldaman would have one.",
    "Without a power source from Uldaman's strongest construct, the necklace could not be fixed.",
    "Talvash del Kissel was glad to see the power source and began fusing it with the necklace and its gems.",
    "Talvash set to restoring the necklace with the power source, promising it to its finder.")
q(2283, "Necklace Recovery", "Orgrimmar", 41, "droffers", 3,
    "Droffers and Son Salvage had heard of a paladin who died in Uldaman with a valuable necklace of three gems. They would pay top silver for it.",
    "Damaged or not, the dead paladin's necklace from Uldaman was wanted by Dran Droffers.",
    "Dran Droffers noticed at once that the gems were missing. Even Malton could see that, he said, and the job was not done.",
    "Droffers would not pay for a necklace without its gems.")
q(2284, "Necklace Recovery, Take 2", "Uldaman", 41, "droffers", 3,
    "Dran was sure the gems were still in Uldaman, and the paladin's corpse might still have them.",
    "Dran sent the search back to Uldaman for the ruby, sapphire and topaz.",
    "The paladin's remains held a blood-stained diary in the human tongue, unreadable without a translation.",
    "A diary was found on the dead paladin, but it needed translating.")
q(2318, "Translating the Journal", "Badlands", 42, "droffers", 3,
    "The diary needed translating, and Kargath in the Badlands was the closest place with someone who might do it.",
    "The paladin's diary could not be read as it was. Kargath might have a translator.",
    "Jarkal Mossmeld already knew about the necklace. He claimed to be the only one who could translate the diary, and had a better offer than Droffers.",
    "Jarkal greeted the visitor knowing the whole affair, and proposed a deal.", true)
q(2338, "Translating the Journal", "Badlands", 42, "droffers", 3,
    "Jarkal wanted to study the necklace and learn to make such pieces himself. In exchange he would translate the diary, and Droffers need never know.",
    "A translation was on offer, in return for lending Jarkal the necklace while the gems were sought.",
    "Jarkal Mossmeld took the deal and cast a spell to translate the diary. He was a troll of his word, he said.",
    "Jarkal accepted the necklace and translated the paladin's diary.", true)
fallback("Translating the Journal", "Badlands", "droffers", "2318,2338",
    "A dead paladin's diary from Uldaman needed translating.",
    "The diary was written in the human tongue and could not be read.",
    "The diary's translation was arranged.",
    "The matter of the paladin's diary moved on.")
q(2339, "Find the Gems and Power Source", "Badlands", 44, "droffers", 4,
    "The translated diary said the dwarves hid the ruby, the troggs the topaz, and a trogg named Grimlok held the sapphire. A power source from Uldaman's strongest construct was needed too, Jarkal said.",
    "Deep in Uldaman lay the gems, and the power source Droffers did not know was needed.",
    "Jarkal Mossmeld was sure he could now make such necklaces himself. He analyzed the gems before they went to Orgrimmar.",
    "Jarkal kept the power source and checked the gems with an incantation.")
q(2340, "Deliver the Gems", "Orgrimmar", 44, "droffers", 3,
    "Jarkal kept the power source and sent the gems and necklace to Droffers and Son, asking for silence about their deal.",
    "In Orgrimmar, Droffers and Son Salvage were waiting for the necklace and gems.",
    "Dran Droffers checked everything and called it their greatest haul yet. He paid the salvage fee and kept the bag too.",
    "Droffers paid for the necklace and gems, laughing at the haul.")
q(2341, "Necklace Recovery, Take 3", "Badlands", 44, "droffers", 4,
    "A special reward might be waiting with Jarkal Mossmeld in Kargath.",
    "With the Droffers squabbling over their salvage, Jarkal waited in Kargath.",
    "Jarkal Mossmeld said the power source had exceeded his hopes. He had made two necklaces, one for each of them, with enough left for more.",
    "Jarkal gave a necklace of his own making, the Droffers none the wiser.")
hl(2240, "Prospector Stormpike heard that the Chamber of Khaz'mul was real, and hoped Ironforge would act to retake Uldaman.",
    "Baelog's hidden chamber in Uldaman existed. Stormpike was amazed.")
hl(1139, "Advisor Belgrum received the Tablet of Will, Hammertoe's dream, for the king's mages to study.",
    "The Tablet of Will reached Belgrum, the shard Hammertoe had dreamt of.")
hl(2204, "Talvash del Kissel fused the power source into the necklace and its gems, restoring the dead paladin's jewel.",
    "Talvash began restoring the necklace with the power source from Uldaman.")
hl(2341, "Jarkal Mossmeld gave a necklace made with the power source from Uldaman, while Droffers and Son knew nothing of it.",
    "The power source let Jarkal make necklaces for both of them.")
for _, id in ipairs({2398, 2240, 1139, 2418, 17, 2202, 2198, 2199, 2200, 2201, 2204, 2283, 2284, 2318, 2338, 2339, 2340, 2341}) do src(id) end

-- Batch W3-14: Zul'Farrak errands (Gahz'rilla's scale, Tabetha's tiara, Nekrum's
-- medallion for Sharpbeak's seer, the troll temper, Krazek's cousin and his scarab
-- shells), Maraudon (Willow's carvings, Vyletongue's vines, the Pariah's plan) and
-- the Sunken Temple (the Atal'ai exile's warning to Fel'Zerul, the fetishes, and
-- Brohann's tablets). Givers are named only where their own texts or the linked
-- chains name them.
P.threads.world_zulfarrak = "the errands into Zul'Farrak"
P.threads.world_maraudonerrands = "the errands into Maraudon"
P.threads.world_scarabs = "Krazek's missing scarab shells"
q(2770, "Gahz'rilla", "Thousand Needles", 50, "zulfarrak", 4,
    "The trolls of Zul'Farrak summoned a huge beast, Gahz'rilla, from a sacred pool. Its scales crackled with energy, and Wizzle Brassbolts wanted that energy for his car.",
    "Gahz'rilla's electrified scale could power a racer's car. First the trolls' summoning secret had to be wrested from them.",
    "Wizzle Brassbolts could not wait to get to work on the scale, and wanted to know if Gahz'rilla was as big as they said.",
    "Wizzle had his electrified scale, and questions about the beast it came from.")
q(2846, "Tiara of the Deep", "Dustwallow Marsh", 46, "zulfarrak", 3,
    "Tabetha's Tiara of the Deep was beautiful and powerful. The Hydromancer Velratha had sent agents to steal it while she was away.",
    "Velratha held Tabetha's stolen tiara in Zul'Farrak, and Tabetha wanted it wrenched from her.",
    "Tabetha was delighted to have her tiara back, and that Velratha no longer had it. She was, she said, much nicer to those who had not stolen from her.",
    "Tabetha thanked the finder of the Tiara of the Deep and declared herself forever in their debt.")
q(2991, "Nekrum's Medallion", "Blasted Lands", 47, "sharpbeak", 3,
    "Thadius Grimshade would find Sharpbeak, but wanted something first. Nekrum Gutchewer in Zul'Farrak had a medallion he wished to study.",
    "Nekrum's medallion was the price of the search for Sharpbeak. Powers were hidden in it, and Thadius wanted them.",
    "Thadius Grimshade said the medallion was rumored to have given Nekrum an unnaturally long life, at a cost. He would now keep his side of the bargain.",
    "Thadius took Nekrum's medallion and prepared to find Sharpbeak as promised.")
q(3042, "Troll Temper", "Tanaris", 45, "zulfarrak", 2,
    "The Sandfury of Zul'Farrak made a tempering agent from sandstone, prized by connoisseurs. A good supply would be well paid by Trenton Lighthammer in Gadgetzan.",
    "Troll temper from Zul'Farrak would improve the goods Trenton Lighthammer crafted.",
    "Trenton Lighthammer had enough temper to keep him at work for days, and paid well.",
    "Trenton Lighthammer called it very nice temper, and so much of it, then paid for the supply.")
q(2864, "Tran'rek", "Tanaris", 45, "scarabs", 2,
    "Krazek's cousin Tran'rek in Gadgetzan had promised a load of scarab shells weeks ago. A reminder was due before something got broken, Krazek said.",
    "Krazek sent word to his cousin in Gadgetzan that the scarab shells were overdue.",
    "Tran'rek asked after his cousin in Booty Bay, then began to explain about the scarab shells.",
    "Tran'rek welcomed news of Krazek and had a long account of the shells.")
q(2865, "Scarab Shells", "Tanaris", 45, "scarabs", 2,
    "Scarab shells were so useful that the scarabs had been hunted nearly to extinction. A colony survived in Zul'Farrak, Tran'rek said.",
    "The Zul'Farrak scarabs still had their shells, and Tran'rek needed uncracked ones for Krazek.",
    "Tran'rek called the shell-bearer a lifesaver. Krazek's load could go at last.",
    "Tran'rek had his scarab shells for his impatient cousin.")
q(7028, "Twisted Evils", "Desolace", 47, "maraudonerrands", 3,
    "Willow wanted relics of the old gods from the crystal caverns of Terramok, deep in Maraudon. Theradric crystal carvings would let Willow study powers long at rest.",
    "The carvings hidden in Maraudon's crystal caverns interested Willow, who promised to make the effort worth it.",
    "Willow laughed, having known the carvings would come, and muttered that some would do anything for the right price.",
    "Willow took the theradric carvings with a knowing laugh.")
q(7029, "Vyletongue Corruption", "Desolace", 47, "maraudon", 3,
    "The satyr Vyletongue had corrupted Maraudon's caverns and stunted their plants. Water from the orange crystal pool, in a treated vial, could heal the Vylestem vines.",
    "A vial filled at Maraudon's orange pool would become a healing agent for the vines Vyletongue had poisoned.",
    "Some of Vyletongue's corruption had been healed. The vial's remaining liquid would serve further study.",
    "Part of Maraudon's corruption was undone, and the leftover liquid went back for study.", true)
q(7041, "Vyletongue Corruption", "Desolace", 47, "maraudon", 3,
    "Vyletongue's corruption had stunted Maraudon's plants. A treated vial filled at the corrupted orange pool could purge the Vylestem vines.",
    "The coating in the vial would turn the corrupted pool's water into a cure for the vines.",
    "Some of the corruption Vyletongue spread had been healed, and the remaining liquid would serve further study.",
    "Part of Maraudon's corruption was undone, and gratitude came with the returned vial.", true)
fallback("Vyletongue Corruption", "Desolace", "maraudon", "7029,7041",
    "The satyr Vyletongue had corrupted the plants of Maraudon.",
    "A treated vial could heal the vines Vyletongue had poisoned.",
    "The vial came back from Maraudon.",
    "The work against Vyletongue's corruption went on.")
q(7067, "The Pariah's Instructions", "Desolace", 48, "maraudonerrands", 4,
    "An exiled centaur heretic believed his destiny was to unite the tribes, and needed an outsider to enter Maraudon's holy halls.",
    "Someone of no tribe was needed to set foot in the tomb his people guarded, the Centaur Pariah said.",
    "The Centaur Pariah rejoiced. Now he could begin uniting the tribes, and he hoped they would meet next on different terms.",
    "The Pariah had what he needed to forge one great centaur tribe.")
q(1444, "Return to Fel'Zerul", "Swamp of Sorrows", 44, "atalai", 3,
    "Jammal'an the Prophet had cast the Atal'ai exile out for his doubts. The artifacts were harmless, he said, but the right fetish enchantment could put the world in peril.",
    "Jammal'an's faith in his prophecy would destroy the Atal'ai, the exile warned. The news had to go back to Fel'Zerul in Stonard.",
    "Fel'Zerul had not seen the traveler in some time, and wanted to know what the exile had said.",
    "Fel'Zerul asked to hear the exile's knowledge.")
q(1445, "The Temple of Atal'Hakkar", "Swamp of Sorrows", 50, "atalai", 4,
    "Jammal'an believed Hakkar's return would make the Atal'ai immortal. It was trickery to Fel'Zerul, and the exile's enchanted fetishes worried him.",
    "If the fetishes were the key to the Atal'ai ritual, the Horde had to understand them. They had to be seized from the Temple, Fel'Zerul said.",
    "Fel'Zerul called the bearer a great champion of the Horde. The fetishes of Hakkar had to be dealt with at once.",
    "Fel'Zerul took the collected fetishes of Hakkar and would see to them.")
q(1475, "Into The Temple of Atal'Hakkar", "Stormwind City", 50, "atalai", 4,
    "The Temple of Atal'Hakkar lay sunk beneath the Pool of Tears. Near the end of his career, Brohann Caskbelly wanted its intact Atal'ai Tablets for the Explorers' League.",
    "His old bones could not brave the sunken temple, so Brohann asked for help with his last task for the Explorers' League.",
    "Brohann Caskbelly said that once he delivered the tablets to the Explorers' League, their names would go down in history together.",
    "Brohann thanked the finder of the Atal'ai Tablets, which he meant to deliver to the League as his final obligation.")
for _, id in ipairs({2770, 2846, 2991, 3042, 2864, 2865, 7028, 7029, 7041, 7067, 1444, 1445, 1475}) do src(id) end
for _, id in ipairs({1444, 1445, 1475}) do P.questIDs[id].threadLabel = P.threads.world_atalai end
P.questIDs[2991].threadLabel = P.threads.world_sharpbeak

-- Forever additions carry the Forever label in the compendium (fact-check
-- request 2026-11-05; explicit list, never inferred from the ID range).
for _, id in ipairs({94913, 94914}) do
    assert(P.questIDs[id], "Forever label for a missing stage " .. id).setting = "Forever"
end
A.Lore.RegisterStoryPack("world_journeys", P)
