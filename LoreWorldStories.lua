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
    "One part of the work surrounding the centaur relic was complete.",
    "The completed errand belonged to the effort to investigate the Cloven Hoof.")
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
    "Another lead in the investigation had been followed.",
    "The completed assignment added a step to the search for the missing diplomat.")
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
    "The requested batch of reagents was delivered.",
    "The completed collection replenished an alchemist's working supplies.")
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
    "The discovered plans complicated the picture: the gnolls appeared to be fighting a threat south of the camp.")
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
    "One part of the effort surrounding the lost prayer was complete.",
    "The completed errand belonged to the captive's appeal to Elune.")
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
    "The tower-marking assignment was complete, preparing a later attack.",
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
    "Vandis laid out the plan: reach the four western cauldrons and change the plague they spread.", true)
fallback("The Scourge Cauldrons", "Western Plaguelands", "andorhal", "5215,5228",
    "The Scourge's plague cauldrons called for an indirect countermeasure.",
    "The proposed operation sought to turn the cauldrons' output against their makers.",
    "The introductory assignment established the cauldron operation.",
    "The work had reached its initial briefing, without yet securing the cauldrons.")
q(5142, "Little Pamela", "Eastern Plaguelands", 55, "darrowshire", 3,
    "When the battle of Darrowshire began, Marlene Redpath hid her niece Pamela. Now a wandering spirit, Marlene still did not know what had become of the child.",
    "Marlene Redpath's spirit longed for news of Pamela, the niece she had hidden during Darrowshire's battle. She asked for a search among the ruins to the east.",
    "Pamela was found in Darrowshire. She introduced herself and asked her visitor's name.",
    "The search ended with Pamela's simple greeting: she gave her name and wanted to know who had come to see her.")
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
    "One part of the mechanical yeti project was complete.",
    "The completed errand advanced the inventor's scheme for the mechanical yeti.")
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
    "The fragment secured the requested attunement.",
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
    "A stage of the seal's preparation was complete.",
    "The completed work advanced the making of the Seal of Ascension.")
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
    "The final restoration assignment was complete.",
    "The work to cleanse the staff had reached its conclusion.")
q(5921, "Moonglade", "Moonglade", 10, "bear", 3,
    "Dendrite Starblaze in Nighthaven offered the first guidance on the druidic path of the bear.",
    "Moonglade welcomed druids seeking instruction despite tensions within the Cenarion Circle.",
    "Dendrite's introduction began the instruction; mastery of the bear still lay ahead.",
    "The first meeting established the next lesson without yet completing bear training.", true)
fallback("Moonglade", "Moonglade", "bear", "5921,5922,94913,94914",
    "Nighthaven was a place of druidic teaching within the sacred lands of Moonglade.",
    "The journey to Moonglade led toward instruction among the druids.",
    "The introductory errand in Moonglade was complete.",
    "The visit established the next step in druidic instruction.")
q(5929, "Great Bear Spirit", "Moonglade", 10, "bear", 3,
    "The Great Bear Spirit taught in northwestern Moonglade before the next lesson with Dendrite.",
    "Dendrite required the spirit's instruction as preparation for understanding the bear.",
    "The spirit's lesson was completed, preparing the next stage of bear training.",
    "Dendrite accepted the return from the Great Bear Spirit; adopting the bear's form remained a further lesson.", true)
fallback("Great Bear Spirit", "Moonglade", "bear", "5929,5930",
    "The Great Bear Spirit's instruction was a required part of the druidic lesson.",
    "Dendrite sent students to the spirit before continuing the path of the bear.",
    "The spirit's instruction was completed, preparing the next stage of training.",
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
    "One stage of the search for the family portrait was complete.",
    "The completed assignment advanced the inquiry into Renfray's painting.")
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
    "One part of Raene's work was completed amid the forest's continuing troubles.",
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
    "The Stones of Binding opened. Myzrael's voice came through them with thanks: she could feel her restraints loosen.")
q(652, "Breaking the Keystone", "Arathi Highlands", 42, "myzrael", 4,
    "Fozruk carried the Rod of Order needed to open the Keystone's remaining lock.",
    "Myzrael's promised release depended on a stone watcher's key and the charged Keystone.",
    "The Rod of Order was placed in the Keystone, and a shudder passed through the ground.",
    "Fozruk's Rod of Order fitted the Keystone. The ground beneath it shuddered.")
q(688, "Myzrael's Allies", "Arathi Highlands", 40, "myzrael", 3,
    "Myzrael spoke of gathering strength out of the giants' reach. She named Zaruk in Hammerfall as the ally who knew how to summon her to the surface.",
    "Myzrael promised to confront the giants once she was stronger. For the summoning she planned, she directed the search to Zaruk in Hammerfall.",
    "Zaruk was expecting the visit: the Lady had told him. He welcomed a discussion of how to bring her to the surface.",
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
    "Gor'mul's history was explained: he had been left behind and wandered until the Horde returned to Hammerfall.",
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
    "The report brought Tor'gan no good news: Gor'mul had rejected the amulet.", true)
fallback("Raising Spirits", "Arathi Highlands", "gormul", "672,674,675",
    "Tor'gan sought a way to help Gor'mul through the loss that still shadowed his life at Hammerfall.",
    "The shaman's small amulet was part of an attempt to reach a dispirited veteran.",
    "Another part of Tor'gan's attempt to bring comfort to Gor'mul was finished.",
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
    "Sergeant Yohwa knew Kurzen's elite troops personally: skilled, loyal and cruel. They hunted the rebels, then withdrew to the Stockpile cave behind the compound.",
    "Kurzen's commandos and headshrinkers sheltered deep in the Stockpile. Yohwa sent the attack against soldiers whose skill and cruelty she knew well.",
    "Doren welcomed the news of their defeat. He had feared his rebels stood alone against Kurzen's brilliance; now he could hope they might survive.",
    "The losses among Kurzen's elite gave Doren hope. Yohwa had trusted the help sent against them, and her commander trusted her judgment.")
q(206, "Mai'Zoth", "Stranglethorn Vale", 46, "kurzen", 5,
    "Nimetz believed the ogre mage Mai'Zoth had corrupted Kurzen. He feared the Mind's Eye could bend another mind to the same evil, and called for its recovery.",
    "The inquiry pointed Nimetz toward Mai'Zoth in Stranglethorn's eastern mountains. Convinced that the ogre's magic had ruined Kurzen, he sought the Mind's Eye.",
    "Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve a good purpose; otherwise, he meant to destroy it.",
    "Nimetz received the Mind's Eye after Mai'Zoth's death. Its fate rested on his study: a use for good, or destruction.")

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
    "Another part of the inquiry was completed, though the shield alone did not establish a culprit.")
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
    "Fizzledowser offered temporary surveying work: tap the water near Sandsorrow Watch and bring the widget back. The company needed new sources after losing its wells to nomads.",
    "The tapped widget returned with news of an insect ambush. Fizzledowser admitted he had dismissed earlier reports of creatures draining the desert's water as more trouble from the nomads.",
    "The water survey ended in an insect ambush. Hearing the report, Fizzledowser could no longer dismiss the stories of water-draining creatures that he had blamed on the nomads.")
q(82, "Noxious Lair Investigation", "Tanaris", 47, "silithid", 3,
    "The insects were draining the pools at the Noxious Lair. Fizzledowser wanted Centipaar parts brought to Pestlezugg so the alchemist could identify the enemy.",
    "Fizzledowser knew what was happening to the Noxious Lair's water, but little about the creatures taking it. Centipaar specimens would give Pestlezugg something to examine.",
    "Pestlezugg began examining the Centipaar parts. He had seen no insects like them and already suspected an outside influence; an emergency with Fizzledowser called for an immediate return.",
    "The specimens baffled Pestlezugg: these insects were unlike any he knew. He suspected something might be controlling them, then sent word of Fizzledowser's urgent need for help.")
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
    "The insect investigation yielded a warning from Pestlezugg: he suspected a dangerous power behind the creatures.")
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
    "A letter carried a racing engineer's problem across the sea: the engine needed metal that could endure greater stress.",
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
    "From the cauldron, Nezzliok named the witchdoctor who held Yenniku: Zanzil the Outcast. He doubted that the Darkspear had magic powerful enough to break that hold.",
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
    "The scroll reached Rok Orhan. The first question was where it had been found: the Gordunni Outpost?")

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
    "Incendius's defeat brought Jalinda another troubling name: Ragnaros.",
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
    "Another lead in the search for Hammertoe had been followed.", "The search for the missing prospector advanced a step.")
fallback("Tremors of the Earth", "Badlands", "lethlor", "717,732",
    "An agent of Krasus was dealing with the danger around Lethlor Ravine.", "The Kirin Tor's concern in Lethlor depended on old binding magic.",
    "One part of the assignment concerning Lethlor was complete.", "The work for Krasus's agent advanced another step.")
fallback("The Ogres of Feralas", "Feralas", "gordunni", "2975,2980",
    "The Gordunni presence was damaging ground around its settlements in Feralas.", "Camp Mojache wanted the ogres' expansion checked.",
    "The assigned attack checked one part of the Gordunni's presence.", "The campaign against the Gordunni gained another completed task.")
fallback("The Torch of Retribution", "Searing Gorge", "retribution", "3453,3454",
    "The gathered components were to become a torch for the planned tower strike.", "The enchanted torch still required preparation before its use against the watch posts.",
    "A step in preparing the Torch of Retribution was complete.", "The work on the torch advanced before the strike on the towers.")
fallback("Timbermaw Ally", "Felwood", "timbermaw", "6131,8460",
    "The Timbermaw mistrusted outsiders who failed to distinguish them from corrupted tribes.", "Help against the Deadwood offered a way to earn the Timbermaw's confidence.",
    "The task contributed to the effort to gain the Timbermaw's trust.", "The work on behalf of the Timbermaw took another step.")
fallback("The Name of the Beast", "Azshara", "defiler", "3509,3510,3511",
    "A weapon against the demon lord required his true name and a suitable temper.", "The search for the demon's name brought Loramus's work into Arkkoroc's concerns.",
    "Another part of the search and preparation was complete.", "The work toward a weapon against the demon lord advanced a step.")
fallback("It's a Secret to Everybody", false, "linken", "3844,3845,3908",
    "A ruined raft and scattered belongings opened a mystery around a traveler in Un'Goro.", "The inquiry followed personal possessions whose full story remained uncertain.",
    "Another clue in the traveler's story had been followed.", "The errand advanced the inquiry without settling the whole mystery.")
fallback("Dark Iron Legacy", false, "forgewright", "3801,3802",
    "Franclorn Forgewright offered access to his city in return for assistance.", "The architect's legacy concerned a hidden key and the return of his hammer.",
    "One part of Forgewright's assignment was completed.", "The work concerning the architect's legacy advanced a step.")
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
    "One part of the work concerning Stratholme's spirits was complete.", "The errand advanced the effort to help the restless dead.")
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
    "Traffic between Ashenvale and Stonetalon had stopped at Mystral Lake. Mastok saw a second use for the expedition: scouting the gazebo overlooking the Alliance outpost.",
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
    "West of Camp Mojache, sprite darters carried the delicate wings Krueg Skullsplitter wanted for a gift: a new cloak for his life-mate, Korrin.",
    "Krueg received enough wings for Korrin's cloak, perhaps with some to spare. He gave his thanks and hoped Feralas had not made the errand too dangerous.",
    "The wings delighted Krueg: there were enough for the cloak he meant to make for Korrin, and possibly more.")
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
    "Hemet offered a place in the great hunt after three tests: raptors with him, tigers with Ajeck, and panther tracking with Sir Erlgadin.",
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
    "Nimboya thanked the Great Serpent: Yenniku was not among the heads he had examined. He now sought answers from the Bloodscalp chief Gan'zulah and witchdoctor Nezzliok, whose dead heads he meant to question in a cauldron.",
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
    "Wordeen received the stolen artifacts: a bloodstone wedge, marble, shard and oval. The apothecaries had their missing materials back, and he praised the reckoning with the thieves.", true)
P.questIDs[544].threadLabel = P.threads.world_dalaran
P.questIDs[544].source[2] = "https://classicdb.ch/?quest=544"

P.threads.world_dalaran = "Magus Wordeen's Dalaran inquiry"
q(545, "Dalaran Patrols", "Alterac Mountains", 35, "dalaran", 3,
    "Dalaran's great dome kept its purpose hidden: protection, some said; seclusion for the wizards, said others. Magus Wordeen cared more about the magical treasures that might remain in the ruins outside it.",
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
    "Lesh's reconnaissance carried a cryptic message for High Executor Darthalia: the raven's cry from the west. He wanted it taken to Tarren Mill at once.",
    "Darthalia understood the signal: Hillsbrad was ready for attack. She expected the plan of destruction to please Varimathras.",
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
P.questIDs[652].highlight = {"Fozruk's Rod of Order opened the Keystone that held Myzrael. The ground shuddered beneath it.", "The key Myzrael sought was placed in the Keystone: Fozruk's Rod of Order. A shudder passed through the earth."}
P.questIDs[688].highlight = {"Myzrael sent word to Zaruk in Hammerfall. He welcomed the visit and was ready to discuss summoning her to the surface.", "Myzrael had told Zaruk to expect the visit in Hammerfall. He was ready to discuss her summoning to the surface."}
P.questIDs[642].highlight = {"Motes taken from the Drywhiskers awakened Myzrael's crystal shards. The imprisoned voice welcomed their strength, still pleading for freedom.", "Myzrael spoke through the newly powered Drywhisker shards. The motes had strengthened her, she said, though freedom was still distant."}
P.questIDs[651].highlight = {"The Stones of Binding opened. Through them Myzrael announced that her shackles were loosening, and thanked her rescuer.", "Opening Arathi's binding stones brought Myzrael's grateful voice through the stone: she could feel her restraints loosen."}
P.questIDs[656].highlight = {"Myzrael was defeated and bound again with her Eldritch Shackles. A wail rose from below, and the once-comforting shards pulsed with menace.", "The summoning ended with Myzrael defeated and shackled beneath Arathi again. Her shards answered with a roar from below and open menace."}
P.questIDs[7044].highlight = {"Vyletongue's and Noxxion's stolen scepter pieces reached Celebras. Newly awake from his nightmare, he could hope for Maraudon's cleansing.", "The two scepter pieces were recovered for Celebras. Waking from corruption's nightmare, he saw a chance that Maraudon might one day be healed."}
P.questIDs[4285].highlight = {"The rumors led to a real pylon in northern Un'Goro, another clue to the crater's scattered crystals.", "The northern pylon was found, confirming the rumors behind the search for Un'Goro's crystal structures."}
P.questIDs[4287].highlight = {"The survey found a crystal-lined pylon in eastern Un'Goro, giving the crater's crystal research another site to study.", "A visit confirmed the rumored eastern pylon, one of the structures being sought among Un'Goro's scattered crystals."}
P.questIDs[4288].highlight = {"The search found Un'Goro's western pylon, extending the survey of its mysterious crystal structures.", "The western pylon was located, another site for the search into Un'Goro's crystals."}
P.questIDs[4492].highlight = {"Spraggle's missing friend Ringo was found alive at the volcano, dazed but grateful that someone had reached him.", "The search for Spraggle's friend found Ringo at the volcano. He was alive, and barely able to express his relief."}
P.questIDs[4491].highlight = {"Despite the heat exhaustion, Ringo reached Marshal's Refuge with help. Spraggle was glad to have her friend back alive.", "Ringo was brought back to Spraggle at Marshal's Refuge, still suffering from the heat but alive."}
P.questIDs[1195].highlight = {"Moonwell water was collected for the Galak relic expedition. The filled phial was ready to carry to Rau in Thousand Needles.", "The filled moonwell phial was prepared for Rau, who had requested it for the search for a Galak centaur relic."}
P.questIDs[1196].highlight = {"Rau received the moonwell water at Freewind Post. He explained how dryads' kinship with centaurs would let it breach the relic's protective flame.", "The phial reached Rau, who explained its use: through the dryads' shared ancestry with centaurs, moonwell water could pierce the relic's eternal flame."}
P.questIDs[7761].highlight = {"Blackhand's letter exposed the orb's safeguard. The Mark of Drakkisath was obtained, opening the way into Blackwing.", "The Mark of Drakkisath satisfied the Blackwing orb's ward, just as Blackhand's captured letter had described."}
P.questIDs[4788].highlight = {"The last Mosh'aru tablets were recovered from Blackrock Spire's Smolderthorn. Their reader feared what the earlier passages foretold.", "The fifth and sixth Mosh'aru tablets reached the scholar, whose reading of the earlier pair had already raised fears of what was coming."}
P.questIDs[7848].highlight = {"With a core fragment from Blackrock Depths, Lothos completed the attunement and offered passage into Molten Core.", "Lothos received the core fragment and attuned the traveler to the hidden portal. He could now offer transport to Molten Core."}
P.questIDs[583].highlight = {"At Nesingwary's expedition, Hemet offered three tests before the great hunt: his raptors, Ajeck's tigers and Sir Erlgadin's panthers.", "Barnil's introduction brought Hemet's hunting challenge: raptors with him, tigers with Ajeck, and panthers with Sir Erlgadin."}
P.questIDs[581].highlight = {"Nimboya sought Yenniku, the Darkspear chief's son once given to the Gurubashi. Bloodscalp tusks convinced him the hunt for the missing boy could go further.", "Bloodscalp tusks reached Nimboya in the search for Yenniku, the Darkspear chief's missing son. Nimboya took the trophies as grounds for a harder hunt."}
P.questIDs[582].highlight = {"Bloodscalp shrunken heads reached Nimboya for inspection. He feared that one might belong to the missing Yenniku.", "Nimboya received the headhunters' trophies and prepared to look for Yenniku among them, hoping the boy had escaped their axes."}
P.questIDs[584].highlight = {"Seeking Yenniku's fate, Nimboya called for Gan'zulah and Nezzliok's heads. Both were placed in the green broth of his cauldron, ready for questioning.", "Gan'zulah's and Nezzliok's severed heads lay in the bubbling cauldron. Nimboya intended to question them about Yenniku."}
P.questIDs[596].highlight = {"Kin'weelay accepted Bloodscalp bone necklaces, planning to render them into paste. He claimed this would weaken their owners' spirits.", "The Bloodscalp trophies reached Kin'weelay. He meant to boil the necklaces into paste, a rite he claimed would weaken the enemy's spirits."}
P.questIDs[2978].highlight = {"A gathering or ceremony seemed to mark a soiled Gordunni scroll. Rok Orhan received it and asked whether it came from the Gordunni Outpost.", "Rok Orhan received the Gordunni scroll, whose markings might show a ceremony. His first question was whether it had come from the outpost."}
P.questIDs[89].highlight = {"With Lakeshire's iron spent on arms and a replacement caravan stolen, Oslow welcomed pikes and rivets for Everstill Bridge. He expected to shore up the crossing soon.", "Pikes and rivets reached Oslow's bridge effort after war and a stolen shipment had emptied Lakeshire's stores. He expected the crossing's repairs to move quickly."}
P.questIDs[205].highlight = {"Skullsplitter fetishes reached Brother Nimetz, who hoped their magic might explain Kurzen's descent into evil.", "Brother Nimetz received the troll fetishes for study, seeking an answer to Kurzen's downfall in Skullsplitter magic."}
P.questIDs[494].highlight = {"Lesh's raven message reached Darthalia in Tarren Mill. She read it as the signal to attack Hillsbrad, and expected Varimathras's approval.", "Darthalia understood the cryptic word from Lesh's reconnaissance: Hillsbrad was ready for attack. She thought Varimathras would be pleased."}
P.questIDs[5093].highlight = {"Gorlach's call against the Scourge led to Derrington at the Bulwark. He welcomed the response and warned of the dangerous frontier beyond.", "Derrington welcomed the answer to Gorlach's summons at the Bulwark, with the Scourge to the east and work waiting along the frontier."}
P.questIDs[5096].highlight = {"The Scarlet command tent was burned and a Scourge banner planted beside it. Derrington had sent a scout to watch the response and judged Andorhal worth the risk.", "Derrington's false-flag raid left a burned Scarlet tent and a Scourge banner. He sent a scout to see whether the deception worked, while considering Andorhal."}
P.questIDs[574].highlight = {"Yohwa's strike against Kurzen's elite brought Doren hope for the rebels. He had feared they were alone against the Colonel's brilliance.", "Kurzen's commandos and headshrinkers were defeated in the Stockpile. Doren took hope from the report, trusting Yohwa's judgment of the help she had found."}
P.questIDs[202].highlight = {"Kurzen and his leaders fell in the Stockpile. Doren welcomed proof that the rebels were free of the commander whose cunning he had feared.", "Proof of Kurzen's defeat reached Doren. The rebels' former commander was dead, and Doren said they could breathe more easily."}
P.questIDs[207].highlight = {"Four troll tablets were transcribed for Nimetz, who hoped their legends might explain how the once-noble Kurzen had fallen into evil.", "The copied legends from Stranglethorn's ruins reached Nimetz for study. He suspected troll magic behind Kurzen's downfall."}
P.questIDs[206].highlight = {"Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve good; if not, he meant to destroy it.", "Nimetz received the Mind's Eye after Mai'Zoth's defeat. He believed the ogre had corrupted Kurzen and would judge whether the artifact must be destroyed."}
P.questIDs[1068].highlight = {"The shredders XT:4 and XT:9 were destroyed. The shaman reported relief among Stonetalon's tree spirits and hoped the Venture Company would withdraw.", "Stopping XT:4 and XT:9 soothed many tree spirits, the shaman said. He hoped the machines' destruction would drive the Venture Company from the mountains."}
P.questIDs[5228].highlight = {"At Derrington's direction, Vandis explained a plan to turn the four western plague cauldrons against the Scourge by changing their poison.", "Vandis outlined the cauldron plan at the Bulwark: gain access to the four western devices and make their plague harm the Scourge."}
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
    "Moira's explanation turned the rescue into an accusation: Thaurissan had been her husband, and their unborn child would inherit Ironforge. Thrall was to hear what his intervention had done.",
    "The news startled Thrall. He saw a future Dark Iron ruler of Ironforge as a new threat, rewarded the completed mission, and dismissed the messenger so he could consult Sylvanas and Cairne.",
    "Thrall was taken aback by Moira's news. He feared what her unborn child's claim to Ironforge would mean, paid the promised reward, and said he must consult Sylvanas and Cairne.", true)
q(4363, "The Princess's Surprise", "Ironforge", 59, "royal_rescue", 5,
    "Moira praised Thaurissan as honorable and said his death had ruined her life and her unborn child's. She demanded that Magni be told Ironforge's heir would be a Dark Iron dwarf.",
    "Moira sent a defiant message to her father: the heir to Ironforge would be a Dark Iron dwarf, with or without his approval. News of her unborn child had to reach the king.",
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
P.questIDs[110].highlight = {"Pestlezugg's results troubled him. He believed an unknown malignant power had remade the insects into ravagers.", "The analysis strengthened Pestlezugg's suspicion of outside control: he believed the insects had been changed into ravagers by an unknown power."}
P.questIDs[113].highlight = {"Fizzledowser agreed to copy the report for free distribution. He disliked giving away valuable information, but trusted Pestlezugg's warning.", "The report reached Fizzledowser, who agreed to copy it. Pestlezugg's judgment outweighed his reluctance to give valuable findings away."}

A.Lore.RegisterStoryPack("world_journeys", P)
