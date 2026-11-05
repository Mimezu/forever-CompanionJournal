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
    "The returned supplies preserved the expedition's work as well as its immediate means of survival.")
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
    "The Mark of Drakkisath was obtained, satisfying the orb's requirement for entry.",
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
    "The search reached the logistics officer's papers without yet naming the source of the leak.")
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
    "In Orgrimmar, the recovered orb drew a mage's warning about the danger bound up in its power.")

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
P.questIDs[7761].highlight = {"Blackhand's letter exposed the orb's safeguard. The Mark of Drakkisath was obtained, opening the way into Blackwing.", "The Mark of Drakkisath satisfied the Blackwing orb's ward, just as Blackhand's captured letter had described."}
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
    "In the Undercity, Varimathras laid out the Dark Lady's command. Nathanos was to strike at the Grand Crusader, whose forces poured into Forsaken lands from the safety of Stratholme.")
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

A.Lore.RegisterStoryPack("world_journeys", P)
