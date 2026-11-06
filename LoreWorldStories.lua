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
    -- band5060 (2026-11-06): Blackrock Spire chains
    world_kibler = "Kibler's exotic pets", world_ridgewell = "Count Ridgewell's collection",
    world_lagrave = "the Darkstone Tablet", world_bijou = "Operative Bijou's reconnaissance",
    world_maxwell = "Marshal Maxwell's strike against Blackrock Spire", world_finkle = "Finkle Einhorn's suit",
    world_sabers = "the Forsaken's corrupted sabers", world_mulgris = "the dying druid's mercy",
    world_arkonarin = "Arko'narin's escape from Jaedenar",
    world_mauari = "Mau'ari's lucky charm", world_jaron = "Jaron's camp and the wildkin's amulet",
    world_skeletonkey = "the Skeleton Key to Scholomance", world_barov = "the Barov inheritance",
    world_frostwhisper = "the unmaking of Ras Frostwhisper", world_zverenhoff = "Duke Zverenhoff's champion",
    world_gordok = "the king of the Gordok", world_felvine = "the Felvine of Eldre'Thalas",
    world_quelserrar = "the forging of Quel'Serrar",
    world_cenarionwar = "the Cenarion Circle's war in Silithus", world_abyssal = "the Abyssal Council",
    world_calandrath = "Calandrath's desert kitchen", world_colossus = "the husks of the colossi",
    world_silithyst = "the race for silithyst", world_kumisha = "Kum'isha's draenethyst",
    world_termites = "the termites for Northridge Lumber Mill", world_hearthglen = "the scout at Hearthglen",
    world_scourgeinvasion = "the Scourge's necropolises",
    world_morrowgrain = "the Cenarion Circle's morrowgrain", world_muigin = "Muigin and Larion's quarrel",
    world_slimes = "the apothecaries' slime samples",
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
-- band2030 (2026-11-06): Piznik's ore sample for Ziz (corpus 1090, 1092; NPCs in LoreForever Z_stonetalon).
q(1090, "Gerenzo's Orders", "Stonetalon Mountains", 22, "stonetalon", 3,
    "Piznik had been the second most important goblin at the Venture Company's site until Gerenzo took over, fired his boss Ziz Fizziks and sent him down the mines. Ziz had told him to stay and gather information for his new employer. Gerenzo had ordered large amounts of a gold-green ore dug, and Piznik could get a sample if someone watched for patrols.",
    "Piznik was spying on Gerenzo from inside the diggings for Ziz Fizziks. The gold-green ore Gerenzo wanted so much of was the clue, and digging a sample out meant someone standing guard against the workers and patrols walking past.",
    "It had looked dicey for a moment, Piznik said, and they had drawn far too much attention. The important thing was the ore sample, and it had to reach Ziz as soon as possible.",
    "The sample of Gerenzo's gold-green ore came out of the diggings under the patrols' noses. Piznik wanted it on its way to Ziz at once.", true)
q(1092, "Gerenzo's Orders", "Stonetalon Mountains", 22, "stonetalon", 3,
    "Piznik reckoned it was time he got out too, before word of the theft reached the higher-ups. He would sneak out and look to Ziz for a new job. The ore sample went ahead of him to Ziz's camp on the western side of Windshear Crag.",
    "With the diggings stirred up, Piznik meant to clean up what he could and slip away. The ore sample for Ziz Fizziks could not wait for him.",
    "Ziz had known he was right to leave Piznik behind. The engineers in Undermine would be most interested in the ore, he said. He would keep a little piece for himself; what they did not know would not hurt them.",
    "In western Windshear Crag, Ziz Fizziks took the ore sample and thought of Undermine's engineers, and of a small cut for himself that nobody needed to know about.", true)
q(505, "Syndicate Assassins", "Alterac Mountains", 33, "syndicate", 3,
    "Henry Maleb had taken the magistrate's seat in Southshore after his predecessor was assassinated. Nobody had found the killers. His investigation pointed almost certainly to the Syndicate, thieves led by nobles of fallen Alterac.",
    "The last clues in the old magistrate's murder led to a Syndicate camp north of Tarren Mill. Magistrate Maleb wanted the thieves and footpads there slain.",
    "Maleb hoped that some of the dead thieves had been his predecessor's killers. Even if not, he said, the Syndicate was a stain on the land, and their deaths were welcome in Southshore.",
    "Thieves and footpads died in the camp north of Tarren Mill. Whether the assassins were among them, Maleb could not say, and he called the Syndicate a taint on the land regardless.")
q(549, "WANTED: Syndicate Personnel", "Hillsbrad Foothills", 22, "syndicate", 3,
    "A Forsaken bounty targeted Syndicate members gathering in the ruins of Durnholde Keep.",
    "High Executor Darthalia required proof of action against the Syndicate at Durnholde.",
    "Darthalia accepted the proof and paid the bounty against the Syndicate.",
    "At this rate, Darthalia said, the Syndicate pest would be rid from the land in no time.")
q(639, "Sigil of Strom", "Arathi Highlands", 37, "stromgarde", 3,
    "Zengu told of Lord Ignaeus of Strom, named Trollbane, who had ridden against the trolls with Trol'kalar. In the trolls' old tongue its name meant troll slayer. The sword lay protected by sigils divided among Stromgarde's survivors, and the Syndicate had taken the first.",
    "With the sons of Trollbane weakened and their stronghold in ruin, Zengu wanted the sigils that guarded Trol'kalar. One had passed to a Syndicate man in Stromgarde.",
    "Zengu called the first sigil a good start toward lifting Trol'kalar from Trollbane's tomb.",
    "Out of Syndicate hands came the Sigil of Strom, and Zengu began collecting what the tomb would need.")
q(642, "The Princess Trapped", "Arathi Highlands", 37, "myzrael", 3,
    "A voice calling itself Myzrael spoke through crystal shards and asked for motes from the Drywhisker kobolds.",
    "Myzrael claimed imprisonment beneath Arathi and sought power for another cluster of shards.",
    "The motes awakened the Drywhisker shards. Through them, Myzrael said she felt more like herself, though still far from free.",
    "From the newly powered shards, Myzrael's voice answered. She welcomed their strength and pleaded that freedom was still distant.")
q(1195, "The Sacred Flame", "Ashenvale", 25, "flame", 3,
    "Water from an Ashenvale moonwell was needed for an attempt to reach a Galak centaur relic.",
    "The task began with a dryad's phial and moonwell water near the Falfarren River.",
    "The moonwell water filled Rau's request, and the phial was entrusted to the next journey into Thousand Needles.",
    "The filled phial was ready for Rau. His associate suggested a visit to Thousand Needles to carry it to him.", true)
q(1196, "The Sacred Flame", "Thousand Needles", 29, "flame", 3,
    "Rau Cliffrunner awaited the moonwell water at Freewind Post.",
    "Rau meant the filled phial to help breach the flame protecting the centaur relic.",
    "The phial would serve perfectly, Rau said. Dryads and centaurs shared an ancestry, so moonwell water could breach the relic's protective flame.",
    "At Freewind Post, Rau welcomed the phial. The moonwell water, he explained, could pierce the eternal flame through the shared ancestry of dryads and centaurs.", true)
q(1197, "The Sacred Flame", "Thousand Needles", 29, "flame", 4,
    "Inside Splithoof Hold lay the Cloven Hoof, behind a flame that moonwell water could briefly douse.",
    "Rau's plan allowed only a short opening in the flame guarding the centaur artifact.",
    "Rau sensed a strange energy in the Cloven Hoof and expected its study to reveal surprising things about the centaur.",
    "The relic was recovered from the Galak stronghold and its examination could begin.", true)
fallback("The Sacred Flame", "Thousand Needles", "flame", "1195,1196,1197",
    "A relic of the Galak centaur in Thousand Needles could only be reached with moonwell water from Ashenvale.",
    "Rau Cliffrunner at Freewind Post wanted the relic the Galak kept at Splithoof Crag.",
    "Rau Cliffrunner's effort to reach the Cloven Hoof moved forward.",
    "Rau's plan for the centaur relic behind its eternal flame went on.")
q(1367, "Magram Alliance", "Desolace", 33, "centaur", 3,
    "Gurda Wildmane meant to use the centaur's hatred against them. An alliance with one clan would show how to beat them all. Before their spokesman Warug would talk, the Magram wanted dead Gelkis.",
    "Warug of the Magram waited on the outskirts of his village in southeast Desolace. He would speak only with someone who had slain many Gelkis.",
    "The Gelkis cried at the name, Warug said, and hated it as they hated the Magram. Maybe its owner was strong like the Magram, and the Magram would see.",
    "Warug allowed that the Gelkis now feared and hated the newcomer like the Magram themselves. Whether that was strength enough, he said, remained to be seen.")
q(1368, "Gelkis Alliance", "Desolace", 33, "centaur", 3,
    "Gurda Wildmane meant to use the centaur's hatred against them. The Gelkis would treat with whoever killed their most hated rival, the Magram. Their shaman Uthek the Wise waited outside the Gelkis Village in southwest Desolace.",
    "Uthek the Wise would listen once the ground was wet with Magram blood, Gurda said. Friendship with the Gelkis had to be proved first.",
    "Uthek heard from the earth that many Magram had died. That was good, Uthek said, and a friend of the Gelkis could hear of further tasks.",
    "Uthek the Wise heard of the dead Magram from the earth itself and called it good. More tasks waited for a friend of the Gelkis.")
q(1434, "Befouled by Satyr", "Desolace", 33, "burningblade", 3,
    "Takata Steelblade believed the satyrs preyed on pain, ambition and the desire for revenge. Their ties to the Burning Blade had brought orders from Thrall to strike them in Desolace.",
    "The Hatefury satyrs had ties to the Burning Blade. Takata Steelblade saw their cruelty as the work of an evil that found its way in through grief and hunger for power.",
    "The Hatefury lost rogues, felsworn and hellcallers. Takata promised that Thrall would hear who had helped fight them when the Desolace campaign was done.",
    "The attack drove back the Hatefury. Takata was grateful for the help and promised to carry word of it to the Warchief after the campaign.")
q(5741, "Sceptre of Light", "Desolace", 33, "burningblade", 4,
    "Azore Aldamort had heard that the Burning Blade in Thunder Axe Fortress held the Sceptre of Light, taken from the naga. The sceptre could sink whole cities beneath the sea, it was said. A Burning Blade seer studied it atop one of the watchtowers.",
    "A Burning Blade seer studied the Sceptre of Light from a Thunder Axe watchtower. Azore Aldamort would not let a relic said to sink cities stay in their hands.",
    "Elusive, Azore called the Sceptre of Light. Taking it from the Burning Blade had removed a grave threat to the world, he said.",
    "Down from the watchtower the sceptre came to Azore Aldamort, who judged a grave threat to the world removed.")
q(202, "Colonel Kurzen", "Stranglethorn Vale", 40, "kurzen", 4,
    "Deep in the Stockpile, Colonel Kurzen commanded the men who hunted his former comrades. Doren placed the rebels' survival in the attack against him and his leaders.",
    "Doren had seen enough to hope for a direct challenge to Kurzen. The Colonel waited beyond his defenders in the depths of the Stockpile.",
    "Proof of Kurzen's defeat convinced Doren of reports he had scarcely dared believe. The rebels were free of the commander whose cruelty and cunning he feared most.",
    "Kurzen and his leaders were defeated. Doren said the rebels could breathe more easily with their former commander's cruel intellect silenced.")
q(207, "Kurzen's Mystery", "Stranglethorn Vale", 38, "kurzen", 3,
    "Brother Nimetz remembered Kurzen as a noble man. Suspecting troll magic behind his fall, he sought copies of four tablets in Stranglethorn's ruins.",
    "Old troll writings might explain what had changed Kurzen, and Nimetz sent for transcriptions from Bal'lal, the Vile Reef and Zul'Kunda.",
    "Nimetz gave his thanks for the copied tablets and set out to look for a link between the trolls and the evil that possessed Kurzen.",
    "The transcriptions from the four tablets went to Nimetz, who would study their legends for an explanation of Kurzen's fall.")
q(338, "The Green Hills of Stranglethorn", "Stranglethorn Vale", 40, "greenhills", 3,
    "Barnil Stonepot had been trusted to proofread Nesingwary's novel, The Green Hills of Stranglethorn. A gust of wind had blown the manuscript through the camp. He had gathered most of it, but many leaves were still strewn about the jungle. Master Nesingwary would be so upset if he found out.",
    "Four parts of Nesingwary's manuscript each lacked leaves scattered by the wind, and Barnil would organize them if the leaves were found.",
    "Barnil said it had saved him a heap of trouble. It would not be long, he expected, before Master Nesingwary's novel stood in libraries throughout the world.",
    "The four parts came back to Barnil whole. He talked of the day the novel would reach libraries across the world.")
q(1324, "The Missing Diplomat", "Dustwallow Marsh", 38, "diplomat", 4,
    "Hendel did not take the accusation quietly. Charged with allying with the Defias, he said the visitor had had this coming for a long time, and attacked.",
    "Private Hendel answered the Defias accusation with violence.",
    "Archmage Tervosh and his people stepped in. Everyone was upset about current events, he said. Hendel would go back to Theramore for questioning, and then they would see about finding the king.",
    "Tervosh's people would take Hendel back to Theramore for questioning, and the search for the king remained open. Lady Proudmoore, Tervosh said, would want to give her thanks.", true)
fallback("The Missing Diplomat", "Dustwallow Marsh", "diplomat", "1241-1250,1264-1266,1274,1324",
    "A diplomat bound for Theramore had vanished, and the matter was being kept quiet.",
    "Bishop DeLavey's quiet inquiry into the missing diplomat followed leads from Stormwind to Theramore.",
    "One more step in the missing diplomat's case was taken.",
    "The search for the missing diplomat turned up another answer, though the diplomat himself was still not found.")
q(1321, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "Krog saw nothing out of the ordinary in the shield. Do'gol the blacksmith might tell more, he said, though he would not hold out hope.",
    "The heavy black shield went from Krog to Do'gol, Brackenwall's blacksmith, for a closer look.",
    "A good shield, Do'gol said, very strong and heavy. But he made shields, he did not buy them, and anyone should know that.",
    "Strong, heavy and good, Do'gol judged the shield, and he had no use for it, since he made his own.", true)
q(709, "Solution to Doom", "Badlands", 40, "uldaman", 3,
    "Theldurin the Lost spoke of a doom approaching and would not utter the names of those behind it, lest they hear him. Learning more of them might show how to foil them, he said. The Tablet of Ryun'eh lay deep in Uldaman, in a chest made before any dwarf's work.",
    "Theldurin wanted the Tablet of Ryun'eh from an ancient chest deep in Uldaman. He refused to say the name a second time.",
    "Theldurin took the tablet and said fortune was with them. They might yet be saved.",
    "Out of Uldaman came the Tablet of Ryun'eh. Theldurin spoke of fortune, and of a salvation still possible.")
q(2258, "Badlands Reagent Run", "Badlands", 39, "reagents", 2,
    "Jarkal Mossmeld of Kargath was an alchemist of some note, by his own account. He needed five buzzard gizzards, ten crag coyote fangs and five rock elemental shards from the Badlands. Those not the fighting type, he said, should bring friends who were.",
    "Jarkal Mossmeld's stocks had run low. The buzzards, crag coyotes and rock elementals of the Badlands would replenish them, for coin.",
    "Jarkal said the reagents would last him a while and paid as promised. More could be had from the depths of the Uldaman excavation, he added, for something better than shiny coins.",
    "Into Jarkal's stores went the gizzards, fangs and shards. He mentioned harder reagents in Uldaman, and a reward beyond coin for whoever fetched them.", true)
fallback("Badlands Reagent Run", "Badlands", "reagents", "2258,2500",
    "Badlands alchemy depended on supplies gathered from the surrounding creatures and elementals.",
    "An alchemist's work called for ingredients found in the Badlands.",
    "Buzzard gizzards, crag coyote fangs and rock elemental shards replenished an alchemist's stocks.",
    "Reagents taken from Badlands creatures and elementals would last the alchemist for a little while.")
q(1423, "The Lost Supplies", "Swamp of Sorrows", 40, "nethergarde", 2,
    "A small, sturdy barrel lay sealed with a yellow wax that stank. Stamped on its bottom were the words Quartermaster Lungertz, Nethergarde Keep.",
    "A wax-sealed barrel in the swamp bore the name of Quartermaster Lungertz at Nethergarde Keep.",
    "Lungertz was glad of it. So many supplies were lost between Darkshire and the keep, he said, that it was good to see some come back.",
    "So many supplies were lost between Darkshire and the keep, Lungertz said, that one barrel coming back was good to see.")
q(1424, "Pool of Tears", "Swamp of Sorrows", 43, "atalai", 3,
    "The Warchief had sent Fel'Zerul to investigate strange happenings at the Temple of Atal'Hakkar. Its Atal'ai were dark casters of forbidden magic. His party had arrived to find the temple sunk, with green dragons guarding the site and calling themselves protectors of Azeroth.",
    "Fel'Zerul wanted Atal'ai artifacts from around the Pool of Tears. From them he could piece together what the trolls had hoped to do and what had gone so wrong. Their spells, he thought, might even serve the Horde.",
    "Fel'Zerul called the diligence in collecting the artifacts worthy of praise.",
    "Fel'Zerul had his Atal'ai artifacts and praised the diligence it had taken.")
q(1446, "Jammal'an the Prophet", "Swamp of Sorrows", 53, "atalai", 4,
    "The Atal'ai exile had no home. Jammal'an, his people's spiritual leader, believed the summoning of Hakkar would bring the Atal'ai immortality. Having urged caution against a prophecy that might be mere manipulation, the exile now wanted Jammal'an's head.",
    "With Jammal'an leading them, the exile said, the Atal'ai faced certain destruction. He asked for the prophet's head from the sunken temple, for his exile and perhaps for his people's freedom.",
    "Jammal'an's reckless trust in false visions had led the Atal'ai to their eternal doom, the exile said. Thanks came for his avenged exile, but he mourned his people and had no home to return to.",
    "The prophet's head came to the exile among the Witherbark. His exile was avenged, he said, and he mourned a people he could not go back to.")
q(2862, "War on the Woodpaw", "Feralas", 42, "woodpaw", 3,
    "Hadoken Swiftstrider called the gnolls a constant threat to Camp Mojache's existence. Their attacks had grown more fevered of late, and he wanted ten Woodpaw manes.",
    "The Woodpaw would drive the Horde out of Feralas unless Camp Mojache hardened against them, Hadoken said. He would pay handsomely for ten of their manes.",
    "A good start, Hadoken said. Many had fought the Woodpaw before. Lately the gnolls had pushed north harder and more savagely, almost as if desperate. He had a plan to settle things.",
    "Hadoken took the manes and spoke of the gnolls' savage push northward, almost as if they were desperate. He had a plan.")
q(2902, "Woodpaw Investigation", "Feralas", 43, "woodpaw", 3,
    "Gnolls were not the sharpest tools in the shed, Hadoken said, but attacks that coordinated needed plans. He wanted them found in the Woodpaw camps.",
    "Hadoken sent the search back among the Woodpaw for anything resembling battle plans.",
    "The map was the one Hadoken wanted. Its arrows ran mostly south, away from Camp Mojache. Beside a drawing of a large insect stood rows of tick marks, perhaps the gnolls' losses against the bugs.",
    "The Woodpaw battle map showed troop movements headed south, and a picture of a big insect with tally marks beneath it.")
q(2987, "Gordunni Cobalt", "Feralas", 43, "cobalt", 2,
    "Orwin Gizzmick had just arrived in Feralas and heard that the Gordunni buried interesting minerals. He lent his shovel for the outpost to the north, and said to dig wherever the ground glowed blue.",
    "The Gordunni buried their cobalt, and a blue glow betrayed the spots. Orwin Gizzmick wanted some dug up before he moved on, since time was money.",
    "Perfect, Orwin called the cobalt. He meant to carry it along on his travels, sure that someone would pay a pretty penny for it.",
    "The cobalt went into Orwin Gizzmick's pack for sale on his travels, and he paid for the trouble.")
q(2880, "Troll Necklace Bounty", "The Hinterlands", 45, "hinterlands", 2,
    "Fraggar Thundermantle wanted one thing straight. The Wildhammers were not part of the Alliance, and they judged by deeds, not jibber-jabber. Five tribal necklaces from the trolls choking the hillsides would count as a step in the right direction.",
    "Friends at Aerie Peak had to prove their worth first, Fraggar said. He wanted five troll necklaces from the Hinterlands.",
    "Now that was what he was talking about, Fraggar said. The necklaces proved a willingness to get hands dirty, which the Wildhammers valued, and good graces might follow.",
    "Fraggar counted the necklaces a step toward the Wildhammers' good graces.")
q(7840, "Lard Lost His Lunch", "The Hinterlands", 49, "hinterlands", 2,
    "Lard had been having a picnic at his secret special spot when mean Vilebranch hit him with a big stick. He ran back to Revantusk and forgot his lunch on the island to the north. Now Lard was hungry and scared.",
    "Lard's lunch lay on an island north of Revantusk, where the Vilebranch had chased him from his picnic.",
    "The huge haunch of meat went to Lard, who stuffed it in his face. It hit the spot, he said, and he made a special picnic basket in return.",
    "Into Lard's face went the haunch of meat, and a picnic basket came back for the help.")
q(4787, "The Ancient Egg", "The Hinterlands", 50, "hakkar", 4,
    "The Prophecy of Mosh'aru spoke of an ancient egg, Yeh'kinya said. It was a relic from the days of vast troll empires, with the power to hold the essence of Hakkar. In a cave behind the amphitheater at the top of Jintha'Alor, it lay hidden.",
    "Yeh'kinya wanted the ancient egg from Jintha'Alor, which he called perhaps the only way to keep the world safe from Hakkar.",
    "Once the egg was his, Yeh'kinya bowed to whoever had brought it. Such strength and bravery, he said, would be long remembered.",
    "The ancient egg came down from Jintha'Alor to Yeh'kinya, who bowed and spoke of a deed long to be remembered.")
q(10, "The Scrimshank Redemption", "Tanaris", 48, "silithid", 4,
    "Fizzledowser's best assistant, Scrimshank, had vanished in the Gaping Chasm. His last report placed the strange insects there too; Fizzledowser asked for him, or at least his surveying gear.",
    "Scrimshank's last report carried news of insects in a second part of the desert. Now the surveyor was missing, and Fizzledowser feared that only his equipment could be recovered.",
    "Scrimshank's gear came back from the Gaping Chasm. Fizzledowser mourned the young goblin and hoped his records would give the loss some purpose; the insects' cunning made him suspect another power at work.",
    "Fizzledowser received the missing surveyor's equipment and remembered Scrimshank as a good goblin. He hoped its records could help explain insects so cunning that he feared they served an outside power.")
q(2605, "The Thirsty Goblin", "Tanaris", 49, "noggenfogger", 2,
    "Marin Noggenfogger had an idea. Dew collectors in the cactus garden to the southwest stored water in special glands. A gland might make a drink to quench his terrible thirst.",
    "Marin's thirst sent the search to the cactus garden southwest of Gadgetzan, for the gland of a dew collector.",
    "Wonderful, Marin called it, and he asked for the gland so he could drink it.",
    "The gland went straight to Marin, who meant to drink it at once.")
q(2768, "Divino-matic Rod", "Tanaris", 47, "water", 4,
    "Sergeant Bly had said he would only borrow Bilgewhizzle's cherished divino-matic rod, and then stolen it. Without it the chief engineer could not know where to dig new water holes. Bly had led his band of ill-reputed adventurers treasure hunting in Zul'Farrak.",
    "Bilgewhizzle wanted his divino-matic rod back from Sergeant Bly in Zul'Farrak. He hoped the trolls had taken care of Bly, since a fight with him would be a serious one.",
    "Bilgewhizzle had his rod again and wanted to know whether Bly had fought for it. He hoped Bly and his band had been knocked down good and hard.",
    "The divino-matic rod came out of Zul'Farrak to Bilgewhizzle, who hoped Bly had taken a beating for it.")
q(7722, "What the Flux?", "Searing Gorge", 50, "thorium", 3,
    "When Maltorius left the clan, Burninate said, he took something worth more than a pristine arcane crystal. It was the Thorium Brotherhood's recipe for fiery flux. Burninate would bet it had bought his promotion among the Dark Irons. He wanted the secret plans back from the Slag Pit.",
    "The Brotherhood's secret plans for fiery flux had gone into the Slag Pit with Maltorius. Master Smith Burninate wanted them back.",
    "With the plans back, Burninate hoped Maltorius had had his teeth kicked in too. Ragnaros knew he deserved it, he said, and now they could get down to business.",
    "The fiery flux plans came back to Burninate, who said the Brotherhood could get down to business.")
q(3377, "Prayer to Elune", "Searing Gorge", 50, "elune", 3,
    "Zamael Lunthistle spoke from a cage in the Searing Gorge. Before asking for help with a prayer to Elune, he wanted a passing mortal to hear him out.",
    "From a cage in the Searing Gorge, Zamael Lunthistle asked for help with a lost prayer.",
    "He had accepted his fate in the cage, Zamael said, but the prayer itself still needed recovery.",
    "Whatever became of him in the cage, Zamael said, the prayer had to be found.", true)
q(3378, "Prayer to Elune", "Searing Gorge", 50, "elune", 4,
    "The prayer had been etched on a golden tablet, and one of the idol-worshipping scoundrels of the Gorge carried it. Zamael asked that it go to Astarii Starseeker in Darnassus. He expected no absolution for the malevolence of his past.",
    "Zamael's prayer to Elune lay on a golden tablet among the idol worshippers of the Gorge. His faith rekindled or not, he said, the prayer had to be heard in Darnassus.",
    "Astarii received the prayer on its golden tablet in Darnassus. Elune smiled that eve, she said, for a lost soul had been returned to her. She gave a token of the temple's gratitude.",
    "The tablet reached Astarii in Darnassus, who spoke of a lost soul returned to Elune and gave a token of gratitude.", true)
fallback("Prayer to Elune", "Searing Gorge", "elune", "3377,3378",
    "A captive's appeal centered on a lost prayer to Elune.",
    "The prayer concerned a penitent whose past could not simply be undone.",
    "The captive's hope that the prayer to Elune would be heard moved forward.",
    "The captive's appeal to Elune had one more piece in place.")
q(3381, "A Meeting with the Master", "Azshara", 48, "azshara", 2,
    "Sanath Lim-yo made it plain that he did not like adventurers. His master had asked him to send on anyone who proved worthy. First Sanath wanted a couple of hippogryph feathers for his arrows.",
    "Two hippogryph feathers for Sanath's arrows were the price of leave to see his master.",
    "Sanath took the feathers for his arrows and allowed the meeting with his master.",
    "With the feathers in hand, Sanath gave leave to see his master.")
q(3628, "You Are Rakh'likh, Demon", "Blasted Lands", 60, "defiler", 5,
    "Razelikh's lair sat atop the highest mountain in the Blasted Lands. Only the teleport runes near the mountain reached it, and the amulet let its bearer use them. In the lair the beast had to be conjured at the Altar of the Defiler, with the amulet as the key. His horn would then be a symbol of hope, proof that heroes existed in a war-torn world.",
    "The amulet opened the teleport runes to Razelikh's lair, high on a mountain in the Blasted Lands. Used on the Altar of the Defiler, it would summon the demon. His horn was to be the proof.",
    "Razelikh fell, and the Fallen Hero called it a day to be remembered for all eternity. The demonic overlord of the Blasted Lands was gone at last.",
    "Finally the demonic overlord of the Blasted Lands had fallen. The Fallen Hero of the Horde declared the day one for all eternity.")
q(3881, "Expedition Salvation", "Un'Goro Crater", 53, "ungoro", 3,
    "Marshal's expedition had abandoned food and research equipment while fleeing its camps.",
    "The crater's dangers had left a stranded expedition short of both provisions and working tools.",
    "Both the food and research equipment were recovered, giving the expedition a chance to continue.",
    "Williden Marshal said the food and equipment had saved his people's lives, and called their helper a friend of Marshal Expeditions.")
q(4284, "Crystals of Power", "Un'Goro Crater", 53, "crystals", 2,
    "Crystals lay all over Un'Goro, and most people walked past them. J.D. Collie had a strange feeling that they held power. Her experiments at Marshal's Refuge had found nothing yet, and her stock of crystals was running low.",
    "J.D. Collie had been testing the crater's crystals for a while without a result. She was sure she was onto something, and she needed more of them.",
    "A fresh supply of crystals reached J.D., and her experiments could continue.",
    "J.D. thanked the gatherer for the crystals. Now, she said, her experiments would go on.")
q(4421, "The Corruption of the Jadefire", "Felwood", 54, "felwood", 4,
    "Few sought adventure in Felwood, where the corruption spread without care for what it touched. Eridan Bluewind of the Emerald Circle meant to heal the land. The Jadefire satyrs at the Ruins of Constellas meant to keep it festering, led by a particularly cruel satyr named Xavathras.",
    "From the Ruins of Constellas, the Jadefire satyrs spread Felwood's sickness to every creature they met. Their leader was a satyr named Xavathras. The Emerald Circle wanted him dead and his followers destroyed, to defend a land that had once been theirs.",
    "Xavathras was dead. Ridding Felwood of him was only the first step in a long repair, Eridan said. She sensed something far larger than satyrs at work in the forest.",
    "At Constellas the Jadefire lost their leader. Eridan counted it a first step and no more. A greater power stood behind the satyrs, she sensed, and only time would show the truth.")
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
    "A treasure seeker had come to the Burning Steppes after the legends of the Seven. They had been dwarves of great knowledge and power, and in the seeker's view wealth was sure to follow such things. Rumor placed the Tablet of the Seven in the ruins of Thaurissan, and the seeker wanted a copy of its text.",
    "The Tablet of the Seven was rumored to lie in the ruins of Thaurissan. It held knowledge of the ancient dwarves, and someone in the Steppes wanted its text copied in the hope of wealth.",
    "The transcription was superb, the seeker said. Payment followed as promised, with a question about whether its maker was really a scribe.",
    "A copy of the Tablet of the Seven earned the promised payment and a compliment on the handwriting.")
q(5097, "All Along the Watchtowers", "Western Plaguelands", 56, "andorhal", 4,
    "A magical device called a beacon torch could mark targets for a later attack by the troops. The Scourge were thought to be using Andorhal's watchtowers to control their movements. A beacon had to be planted in the doorway of each of the four towers, and the torch held only five charges.",
    "Andorhal's four watchtowers were suspected of directing the Scourge's movements. A beacon torch with five charges was to mark every one of them from its doorway.",
    "The priests' beacon trackers picked up extremely strong signals on all four towers, and the mission was called a complete success. With the towers marked, the preparations were in place for the attack. The time had come to take the fight to the Scourge.",
    "All four towers signaled strongly to the beacon trackers. The attack on Andorhal was ready, and the fight was to be taken to the Scourge.", true)
fallback("All Along the Watchtowers", "Western Plaguelands", "andorhal", "5097,5098",
    "Andorhal's watchtowers were targets for beacon marking ahead of an assault.",
    "The campaign required signals at the towers believed to direct Scourge movement.",
    "Beacons now marked Andorhal's watchtowers ahead of the planned assault.",
    "The watchtowers' beacon signals completed preparations for the planned attack on Andorhal.")
q(5215, "The Scourge Cauldrons", "Western Plaguelands", 53, "andorhal", 3,
    "Eight cauldrons stood in the lands of former Lordaeron, four in the west and four more in the east. They spewed poison into the air and spread the plague for the Scourge. Kel'Thuzad's necromantic might was too strong to shut them down outright, but there might be a way to subvert them. High Priestess MacDonnell, second in command at Chillwind Camp, would continue the briefing.",
    "The four western cauldrons could not be shut down against Kel'Thuzad's power, so the plan was to turn them. High Priestess MacDonnell was to explain.",
    "MacDonnell took over as coordinator for the sabotage of the cauldrons. The goal was to change the plague they made into something that harmed the Scourge. For that, access to each of the four western cauldrons had to be secured first.",
    "The plan, as MacDonnell laid it out, was to change what the cauldrons brewed into something that hurt the Scourge. First each of the four western cauldrons had to be reached.", true)
q(5228, "The Scourge Cauldrons", "Western Plaguelands", 53, "andorhal", 3,
    "Derrington entrusted Shadow Priestess Vandis with a plan to turn the Scourge's plague cauldrons against their makers.",
    "Kel'Thuzad's power protected the plague cauldrons, so Derrington sought a way to turn their poisons against the Scourge.",
    "At the Bulwark, Vandis explained how she hoped to make the cauldrons' plague harmful to the Scourge.",
    "Vandis laid out a plan to reach the four western cauldrons and change the plague they spread.", true)
fallback("The Scourge Cauldrons", "Western Plaguelands", "andorhal", "5215,5228",
    "The Scourge's plague cauldrons were too strong to be shut down outright.",
    "The proposed operation sought to turn the cauldrons' output against their makers.",
    "The plan to turn the plague cauldrons against the Scourge had been laid out.",
    "The cauldron sabotage was explained, and the four western cauldrons still lay ahead.")
q(5142, "Little Pamela", "Eastern Plaguelands", 55, "darrowshire", 3,
    "When the battle of Darrowshire began, Marlene Redpath hid her niece Pamela. Now a wandering spirit, Marlene still did not know what had become of the child.",
    "Marlene Redpath's spirit longed for news of Pamela, the niece she had hidden during Darrowshire's battle. She asked for a search among the ruins to the east.",
    "Pamela was found in Darrowshire. She introduced herself and asked her visitor's name.",
    "The search ended with Pamela's simple greeting. She gave her name and wanted to know who had come to see her.")
q(5149, "Pamela's Doll", "Eastern Plaguelands", 55, "darrowshire", 3,
    "Pamela's auntie Marlene had told her to stay in the house while her father went to fight. She called him the bravest man in the whole world, but she had waited a long time and he had not come. Bad people came and whispered to her sometimes. When it got dark she wanted her doll, and she had left it in town.",
    "Pamela had waited a long time in her house for a father who did not come. When it got dark she wanted her doll, and it was somewhere in the town.",
    "Pamela had her doll back, and thanked the finder over and over.",
    "The doll came back from the ruined town, and Pamela cried out that it had been found.")
q(5721, "The Battle of Darrowshire", "Eastern Plaguelands", 60, "darrowshire", 6,
    "Chromie's relic bundle, placed in Darrowshire's town square, would raise the village's spirits to fight their battle again. Two things had to come to pass. Davil had to survive beyond the death of Horgus, and Redpath had to survive to be corrupted, then be defeated. Only then would Joseph Redpath's spirit be saved, with word to carry to his daughter Pamela.",
    "Chromie said the spirits of Darrowshire would rise when the relics were placed in the town square. The battle would be fought again, and Davil had to outlive Horgus before the corrupted Redpath fell. Only that would save Joseph's spirit.",
    "The fighting was over, and Pamela had heard her daddy whisper to her. He had scared away all the ghosts and said he was coming home. Her father had also told her to welcome the visitor, so she had made tea with lots of sugar.",
    "Joseph Redpath's spirit was saved, and his daughter heard him say he was coming home. Pamela, overjoyed, served tea with lots of sugar.")
q(5054, "Ursius of the Shardtooth", "Winterspring", 56, "hunts", 3,
    "Ursius of the shardtooth bears stalked the snowy hills northwest of Everlook, agile and clever. Storm Shadowhoof set the hunt against him with a warning. All who had gone up against Ursius had quickly become the prey, and he the hunter.",
    "Ursius roamed the sloping hills northwest of Everlook, a hunter among bears. Storm Shadowhoof wanted him found before he discovered the intent.",
    "Ursius was dead. It had been no easy task, Storm allowed, but he warned against thinking he had been impressed.",
    "The bear that hunted hunters was tracked down in the hills and killed. Storm called the hunt well done, then warned not to think he was impressed.")
q(5082, "Threat of the Winterfall", "Winterspring", 56, "winterfall", 3,
    "Donova Snowden had come to Winterspring for the Frostfire Hot Springs, whose water had strange qualities she could not yet explain. The Winterfall furbolgs were drawn to the springs as she was. They had grown so protective that they kept her from the two larger pools to the north.",
    "The Winterfall would not let Donova near the two larger springs north of her camp. She wanted to continue her studies, and that meant fighting the furbolgs.",
    "Donova could get back to work at the springs. She thanked the help and asked whether anything of interest had turned up at the Winterfall camp.",
    "With the Winterfall pushed back from the pools, Donova returned to her study of the water. She wondered what the furbolgs' camp had held.")
q(3783, "Are We There, Yeti?", "Winterspring", 56, "yeti", 2,
    "Umi Rumplesnicker of Everlook had friends who were always coming up with great ideas. Until that day, Umi had never felt able to match them. The plan, shared under a promise of secrecy, was a mechanical yeti, sure to freak the friends out and then impress them. It started with thick fur from the ice thistle yetis to the southeast.",
    "The secret plan in Everlook was a mechanical yeti. Umi Rumplesnicker needed thick fur from the ice thistle yetis southeast of town to begin.",
    "The furs were perfect, Umi said, and the yeti was off to a great start.",
    "Thick yeti fur reached Umi in Everlook, and the mechanical yeti was off to a great start.", true)
q(977, "Are We There, Yeti?", "Winterspring", 58, "yeti", 2,
    "With fur to cover its moving parts, Umi's mechanical yeti needed two horns. The largest belonged to the ice thistle patriarchs and matriarchs in the cave to the southeast. Only the best-looking pair would do, nothing beaten up or broken.",
    "Two unbroken horns from ice thistle patriarchs or matriarchs were the last thing Umi's mechanical yeti lacked. They lived in a cave southeast of Everlook.",
    "Umi attached the horns to the mechanical yeti on the spot and pronounced them perfect. She could not wait to show her friends.",
    "The horns went onto the mechanical yeti in a moment. Perfect, Umi said, and she could not wait to show her friends.", true)
q(5163, "Are We There, Yeti?", "Winterspring", 58, "yeti", 3,
    "The mechanical yeti was ready, and Umi's friends had already received mail promising a surprise. Each of them was to get a visit, Legacki in Everlook, Sprinkle in Gadgetzan and Quixxil at Marshal's Refuge. The yeti was to be switched on and sent toward them, then brought back to Umi with the news.",
    "Legacki, Sprinkle and Quixxil would never expect it. Umi handed over the finished mechanical yeti to be turned loose on each of them, then brought back to Everlook.",
    "All three friends had met the yeti, and it was returned to Everlook. They would think twice before making fun of her ideas again, Umi said. She thanked the helper for the fun.",
    "Legacki, Sprinkle and Quixxil had each been surprised, and Umi had her yeti back. Hah, she said, they would think twice before making fun of her ideas again.", true)
fallback("Are We There, Yeti?", "Winterspring", "yeti", "3783,977,5163",
    "An inventor in Everlook planned a mechanical yeti to startle and then impress some friends.",
    "The inventor's scheme required materials and, eventually, a demonstration.",
    "The mechanical yeti project in Everlook moved forward.",
    "Work on the mechanical yeti and its planned surprise went on.")
q(8277, "Deadly Desert Venom", "Silithus", 55, "noggle", 3,
    "Noggle, cousin to Beetix Ficklespragg, made his living gathering rare herbs for the alchemists of Cenarion Hold. He came back from his last trip with a strong poison in his veins. Beetix had slowed the venom, but to neutralize it she needed samples from whatever had stung him. Noggle had come in from the north, so she would bet her shirt on stonelash scorpids or sand skitterers.",
    "Noggle lay poisoned at Cenarion Hold, and his cousin Beetix could only slow the venom. Stingers and fangs from the scorpids and skitterers of the northern desert might give her an antidote.",
    "Beetix took the stingers and fangs and told the helper to cross their fingers. Whether they could save Noggle was still to be seen.",
    "The samples went to Beetix, who could only hope they would be enough to save her cousin.")
q(8284, "The Twilight Mystery", "Silithus", 58, "twilight", 3,
    "A Twilight's Hammer camp had once thrived northwest of Cenarion Hold. Now elementals swarmed the spot, and only scattered wood and canvas marked it. Geologist Larksbane had recovered a few fragments of a clay tablet there, too few to piece together. She wanted the rest, to shed light on the cult's presence in Silithus.",
    "Among the wreckage of the cult's camp northwest of Cenarion Hold lay the rest of a clay tablet. Its fragments might explain what the Twilight's Hammer wanted in Silithus.",
    "The tablet came together, and single words could be read, but strung together they meant nothing. Twilight's Hammer sects were known to code their texts. Someone who understood such things would be needed next.",
    "The restored tablet made no sense, words with no logic behind them. Its makers had likely written it in code, Larksbane said. Someone who knew more about that sort of thing would have to read it.")
q(8279, "The Twilight Lexicon", "Silithus", 60, "twilight", 4,
    "The Twilight's Hammer were not kind to deserters, and they hunted Ortell still, like a beast. Any enemy of theirs was a friend of his. To decipher the tablet he needed the Twilight Lexicon, the cipher their scribes used for secret messages. It was so important that the cult kept its three parts in different places. Officers called Twilight Keepers held them at the cult's camps.",
    "Ortell could read the tablet with the Twilight Lexicon, the cult's cipher. Its three parts were held by Twilight Keepers in the Twilight's Hammer camps.",
    "All three parts reached Ortell, who set to work at once. He swapped every third word with the second part and every other word with the first. Then he wondered whether he had that backwards.",
    "Ortell had his lexicon. He began the decoding at once and promptly lost track of which part went first.")
q(8320, "Twilight Geolords", "Silithus", 60, "twilight", 3,
    "The Twilight's Hammer, a cult bent on destruction, had set up camps in Silithus and performed rituals day and night. Cenarion Hold did not know their plans, but suspected a link to the pulsing red crystals spread across the desert. The mystery could wait, but the geolords who led the camps to the west could not.",
    "Cenarion Hold meant to strike at the heads of the serpent. The Twilight geolords ran the cult's camps west of the Hold, and they were the immediate threat.",
    "Slaying the geolords had dealt the cult a grievous blow, Cenarion Hold said, and it hoped their plans were slowed.",
    "With the geolords slain in the western camps, Cenarion Hold counted the task well performed. It hoped the cult's plans would slow.")
q(6821, "Eye of the Emberseer", "Azshara", 60, "waterlords", 4,
    "Hydraxis granted that lesser foes had fallen for the Waterlords. The next test was a powerful one. Somewhere in Blackrock Spire the orcs held a servant of fire captive, the Pyroguard Emberseer. His eye would show what his slayer was worth.",
    "High in Blackrock Spire, orcs kept the Pyroguard Emberseer imprisoned. Hydraxis wanted his captors slain, then the Emberseer, and his eye brought back.",
    "Proof of strength, Hydraxis called the eye, and of cunning too. Blackrock Spire was more than a match for brute force alone, he said. A valued ally, he allowed, was still possible.",
    "The Emberseer's eye reached Hydraxis. Blackrock Spire could not be beaten by strength alone, he said, and he spoke of a valued ally in the making.")
q(6823, "Agent of Hydraxis", "Azshara", 60, "waterlords", 4,
    "Hydraxis invited a war on the servants of air, earth and fire. Each defeat would weaken their foothold, he said, and the campaign would be long.",
    "An allegiance with the Waterlords had to be earned by a long campaign against the other elements, Hydraxis said.",
    "Word of the exploits rang through the chambers of the Waterlords, Hydraxis said. Some had thought so small a form too fragile for their war. Respect had been earned among them regardless.",
    "Hydraxis spoke of great gains against the Waterlords' foes. Some had thought so small a form too fragile to fight, and to earn their respect was an unbelievable feat, he said.")
q(7487, "Attunement to the Core", "Blackrock Mountain", 60, "blackrock", 5,
    "Rifts stirred and tore all around Blackrock Mountain, said Lothos Riftwaker. Not two paces from where he stood, a tear led through the mountain's depths into the maw of the Firelord. The mortal races could not comprehend what they could not see or touch, but the portal was there. Attunement was simple, he said, and a core fragment from Blackrock Depths would let him bind a traveler's essence to the portal.",
    "A tear into the Firelord's domain stood two paces from its keeper, invisible to anyone not yet attuned. The price of attunement was a core fragment from Blackrock Depths.",
    "That fragment from the Depths bought attunement to the rift, and the way into the Molten Core stood open.",
    "With the fragment delivered, the traveler's essence was bound to the portal beside its keeper, the tear that led into the Firelord's domain.", true)
fallback("Attunement to the Core", "Blackrock Mountain", "blackrock", "7487,7848",
    "A fragment from Blackrock Depths was needed for attunement to the Core's portal.",
    "Lothos offered access through the rift after the recovery of a core fragment.",
    "Lothos Riftwaker used a core fragment to attune a traveler to his rift into the Molten Core.",
    "Attunement was complete, and Lothos could now send a traveler into the Molten Core on request.")
q(7761, "Blackhand's Command", "Blackrock Spire", 60, "blackrock", 5,
    "Blackhand's letter revealed that the orb required the Mark of Drakkisath.",
    "The protection on the route into Blackwing depended on a brand guarded by Drakkisath.",
    "Drakkisath's smoldering brand left the Mark of Drakkisath on its bearer's hand, the sign Blackhand's orb demanded for passage into Blackwing.",
    "The brand was pressed into flesh without a flinch. Its bearer now held the Mark of Drakkisath.")
q(4742, "Seal of Ascension", "Blackrock Spire", 60, "blackrock", 4,
    "The unadorned seal had three empty sockets, Vaelan explained. Each was to hold a gemstone representing the command of the lower citadel's leaders. Overlord Wyrmthalak, master of the lower citadel, would then have to forge the seal in the flames of the black dragonflight. Since the three generals rarely carried a gemstone at any given time, the search would take vigilance.",
    "Vaelan's seal needed three gemstones from the three generals of Blackrock Spire's lower citadel, and none of them carried one often. He warned that the search would take patience.",
    "Vaelan's image blurred for a moment and the gathered pieces vanished. The Unforged Seal of Ascension was ready, he said, and the final step had come.",
    "The gathered pieces disappeared as Vaelan's image flickered. An Unforged Seal of Ascension remained, with one step left.", true)
q(4743, "Seal of Ascension", "Dustwallow Marsh", 60, "blackrock", 5,
    "Few black dragonkin outside the upper citadel could forge the seal with their own breath. Wyrmthalak could, but his will was unbreakable. Vaelan sent the search instead to the Wyrmbog in Dustwallow Marsh, where an ancient drake named Emberstrife lived. His will was to be broken and Vaelan's orb used on his weakened form. In the scant seconds of control, his flames would be fanned to forge the seal.",
    "Emberstrife, an ancient drake of the Wyrmbog, could forge the seal in his breath. First his will had to be broken and Vaelan's orb used on him. There would be only seconds to direct the flame.",
    "With a final invocation of protection, his eyes turned to twin orbs of flame, Vaelan completed the Seal of Ascension. He had set powerful wards into it. In the darkest hour, when all seemed lost, the might of the red flight would be at its bearer's disposal.",
    "The Seal of Ascension was finished under Vaelan's last invocation. He had imbued it with protective wards and promised the might of the red flight when all appeared lost.", true)
fallback("Seal of Ascension", "Blackrock Spire", "blackrock", "4742,4743",
    "The Seal of Ascension required gemstones and a final forging in dragon flame.",
    "Vaelan's seal needed gems from Blackrock's generals and the flame of a black dragon.",
    "Work on the Seal of Ascension went forward.",
    "Vaelan's plan for the Seal of Ascension came a step closer.")
q(9251, "Atiesh, the Befouled Greatstaff", "Tanaris", 60, "atiesh", 6,
    "Anachronos could not say why the bearer of so evil an item was still alive. He did only as he must. Kel'Thuzad sat on his throne in Naxxramas, seeking what the bearer held and holding what the bearer sought. The base of the staff lay in Ahn'Qiraj, where Brann Bronzebeard had carried it and left it behind.",
    "The remaining pieces of Atiesh lay in two places. Kel'Thuzad held one in Naxxramas, and Brann Bronzebeard had left the base of the staff in Ahn'Qiraj. Anachronos wanted them brought back to him.",
    "Once the pieces were back in his hands, Anachronos sensed a being within the staff, one not of this world.",
    "With the pieces of Atiesh before him, Anachronos said there was something inside it that did not belong to this world.")
q(9257, "Atiesh, Greatstaff of the Guardian", "Stratholme", 60, "atiesh", 6,
    "Anachronos called the last task the hardest of all. The bearer had faced an Old God and the Lich King's general; now came the hand of Sargeras. Atiesh was to be taken to Stratholme, to a piece of consecrated earth where the greatest knights of Lordaeron had been murdered. Laid on that holy ground, the staff would release the entity inside it.",
    "In Stratholme lay ground where Lordaeron's greatest knights had been murdered, consecrated still. Atiesh placed upon it would force out the demon that controlled the staff, and Anachronos warned of an entity of immense power.",
    "The demon broke from the staff on the holy ground of Stratholme and was defeated, and Atiesh went back to Anachronos.",
    "On the consecrated earth in Stratholme the hand of Sargeras came out of the staff and fell. Atiesh went back to Anachronos at the Caverns of Time.", true)
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
    "Dendrite Starblaze in Nighthaven spoke of the path ahead for a young druid.")
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
    "Dendrite learned how the lesson with the Great Bear Spirit had gone.")
q(5846, "Of Love and Family", "Western Plaguelands", 58, "tirion", 4,
    "When Taelan was a child, the Fordrings had often visited Caer Darrow. On their last visit an artist named Renfray had painted them poised along the beachside. Tirion called it his fondest memory of Taelan and Karandra. With his wife and son in his arms, he had felt a bond of love and family he would never know again. If the painting still existed, he wanted it found on the ruined island.",
    "Tirion's fondest memory was a portrait Renfray had painted of his family on the beach at Caer Darrow. He asked that the ruined island be searched for the painting or the artist.",
    "Renfray's spirit remembered. Many spirits on the island were cursed to relive their last happy memory before their tragic end, Renfray said. The painter was cursed too, but remembered all. Perhaps the question of the portrait was the reason for the haunting, the spirit said, and its answer the way to be free.",
    "On Caer Darrow, the painter Renfray remembered the Fordrings. Renfray was one of the few spirits there who remembered everything, and wondered whether telling of the portrait might bring freedom.", true)
q(5848, "Of Love and Family", "Stratholme", 60, "tirion", 5,
    "The painting had hung on the wall of Renfray's workshop inside the Order's barracks for years. After Tirion's trial, Renfray had hidden it where no one would think to look. It lay deep in what was now the Scarlet Bastion in Stratholme, beneath a painting of the twin moons. Chipping away the paint would uncover the master work Renfray called Of Love and Family.",
    "Renfray's portrait of the Fordrings lay under a painting of the twin moons somewhere deep in Stratholme's Scarlet Bastion. The top layer had to be chipped away to reach it.",
    "Tirion nearly collapsed when he saw the painting, and began to sob.",
    "Uncovered at last, the portrait reached Tirion, who nearly collapsed at the sight of it and wept.", true)
fallback("Of Love and Family", "Western Plaguelands", "tirion", "5846,5848",
    "Tirion sought a portrait Renfray had painted of him with his wife and son at Caer Darrow.",
    "Renfray's painting preserved an earlier moment in the Fordring family's life.",
    "Tirion's wish for Renfray's painting of his family moved closer.",
    "The search for the Fordring portrait went on.")
q(5944, "In Dreams", "Western Plaguelands", 60, "tirion", 6,
    "For so long Taelan had been a puppet of the Grand Crusader. There had been no reason left to fight what the Crusade had become, and only the memories of his father had kept him alive. In his dreams his father stood proudly beside him as he was inducted into the Order, and they fought the Scourge side by side. He wanted not to dream anymore, and asked to be taken to him.",
    "Taelan dreamed of his father standing beside him at his induction into the Order, of fighting the Scourge side by side. He wanted the dreams to end, and asked to be taken to Tirion.",
    "Taelan died at the hands of the Crusade's monsters, and Tirion swore it would not pass without incident. The Order was reborn, he said. He took his place as Highlord of the new Order of the Silver Hand. The possessions of his past were all he had to offer, and he hoped to meet again in better times.",
    "The reunion ended with Taelan's death. Tirion answered it by taking his place as Highlord of a reborn Order of the Silver Hand. He gave away the possessions that had served him over the years.")
q(6024, "Hameya's Plea", "Eastern Plaguelands", 60, "hameya", 4,
    "The scroll begged for death before it was too late. Hameya and his brethren had eaten bad meat on the way to Zul'Mashar, and they had changed. Now he could feel the lich's words urging him to reach Zul'Mashar and infect more of his people. He had written the scroll while his will was still his own. His chest lay buried by a wagon behind the crypt, and only his key would open it.",
    "Hameya's scroll asked for his own death. He was infected and could not resist the lich's urging toward Zul'Mashar. His buried chest behind the crypt would open only with the key he carried.",
    "Hameya's key opened his chest.",
    "The plea was answered, and the key from Hameya's body opened the chest behind the crypt.")
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
    "Dendrite acknowledged existing mastery of the bear form and said the young druid was well on the way.",
    "Dendrite saw that the bear form was already mastered and said the druid was well on the way.", true)
q(94914, "Moonglade", "Moonglade", 10, "bear", 3,
    "Nighthaven offered instruction under Moonglade's protection.",
    "A druid was sent to Dendrite Starblaze in Nighthaven to speak about the path ahead.",
    "Dendrite saw that bear training was already accomplished before the druid arrived.",
    "In Nighthaven, Dendrite praised the bear form already mastered and said much progress lay ahead.", true)

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
    "Teronis's body lay broken atop the island. For some reason the murlocs had left it alone.", true)
q(1023, "Raene's Cleansing", "Ashenvale", 21, "raene", 4,
    "Teronis's surviving journal and the gem offered a way to continue his work.",
    "The gem sought at Lake Falathim still mattered, even after the discovery of Teronis's body.",
    "Raene promised to send Sentinels for her friend's body. Mourning would have to wait, she said, while the journal and gem carried his task forward.",
    "Terrible, Raene called the news of Teronis's death. His journal and the gem he had sought could still carry his task forward, if someone would finish it.", true)
q(1024, "Raene's Cleansing", "Ashenvale", 21, "raene", 3,
    "Teronis's notes pointed toward the remaining pieces of Dartol's rod.",
    "Shael'dryn, at the moonwell east of Iris Lake, could help interpret the unfinished search.",
    "If Raene had sent someone, Shael'dryn said, it must be serious indeed, and she asked how she could help.",
    "At the moonwell, the dryad Shael'dryn took Raene's errand for a serious one and offered her help.", true)
q(1026, "Raene's Cleansing", "Ashenvale", 27, "raene", 3,
    "A corrupted treant near Felwood carried the key to a hidden glade chest. Shael'dryn knew another piece of Dartol's rod lay inside.",
    "Shael'dryn pointed toward a hidden chest near the Felwood border. The treant carrying its wooden key had been twisted by the corruption that troubled her so deeply.",
    "The chest yielded the rod's iron shaft. Shael'dryn welcomed its recovery, though she wished she could do more for the corrupted treants.",
    "Shael'dryn was pleased to see the rod's iron shaft come out of the hidden chest. The treants' corruption weighed on her, and she wished she could do more for them.", true)
q(1027, "Raene's Cleansing", "Ashenvale", 28, "raene", 3,
    "The druids of Dor'danil had kept the rod's final piece, but they had been killed. Shael'dryn could point toward their shelter, though she did not know the piece's hiding place.",
    "The search for the final piece led toward the shelter of Dor'danil's slain druids. Shael'dryn promised to help rebuild the rod once it was found.",
    "Shael'dryn had the final piece, the iron pommel, and called it wonderful news for Raene. Next would come repairing the rod, she said.",
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
    "In the rod's disguise, a furbolg exile could be approached. He took the stranger for one of his kind, still whole and still clean, then described exile from his corrupted kin and blamed the night elves.",
    "The rod made contact possible with an uncorrupted furbolg, whose account gave the conflict another voice.", true)
q(1045, "Raene's Cleansing", "Ashenvale", 30, "raene", 5,
    "Ran Bloodtooth's violence troubled even a furbolg who bitterly resented the night elves.",
    "The uncorrupted furbolg sought an end to Ran's attacks, refusing to excuse them with the elves' failures.",
    "Ran Bloodtooth was slain, removing one violent leader from a forest that remained tainted.",
    "The furbolg welcomed Ran's defeat as a small repair to Ashenvale, not a cure for its corruption.", true)
q(1046, "Raene's Cleansing", "Ashenvale", 30, "raene", 5,
    "Ran's skull could carry news of the completed task back to Raene and the Sentinels.",
    "The work begun by Teronis now had a trophy to bring home to Astranaar.",
    "So this was the skull of Ashenvale's fiercest furbolg, Raene said. She meant to honor it beside Dartol's rod, in memory of the work Teronis began.",
    "The report brought Teronis's unfinished task back to Raene with proof that Ran's threat had ended.", true)
fallback("Raene's Cleansing", "Ashenvale", "raene", "991,1023,1024,1026,1027,1028,1055,1029,1030,1045,1046",
    "Raene's work concerned the furbolg attacks and Teronis's search for Dartol's rod.",
    "The search for a strange rod offered one approach to Ashenvale's furbolg troubles.",
    "Raene Wolfrunner's work against Ashenvale's troubles had one more piece in place.",
    "The work begun by Teronis was carried further in Ashenvale.")

q(1068, "Shredding Machines", "Stonetalon Mountains", 23, "stonetalon", 4,
    "A shaman's account of the suffering tree spirits singled out the shredders XT:4 and XT:9.",
    "Two marked machines in Windshear Crag cut timber at a pace that threatened the woods.",
    "The shredders XT:4 and XT:9 were destroyed. The shaman reported that many tree spirits were soothed, and hoped the Venture Company would leave.",
    "With the two shredders stopped, the shaman heard relief among Stonetalon's spirits. The hope now was that the company would withdraw.")
q(1095, "Further Instructions", "Stonetalon Mountains", 27, "stonetalon", 3,
    "Gerenzo's employment by the Venture Company had drawn opposition within goblin trade circles.",
    "Sputtervalve's instructions turned the stolen engineering plans into a task against their designer.",
    "Eliminate Gerenzo, Fizziks repeated; that was a prospect he had no objection to.",
    "Fizziks read Sputtervalve's instructions and found nothing in them to object to, least of all Gerenzo's end.", true)
fallback("Further Instructions", "Stonetalon Mountains", "stonetalon", "1094,1095",
    "Fizziks and Sputtervalve exchanged information about Venture Company engineering.",
    "The plans for the Super Reaper had become part of a dispute over the Company's machines.",
    "The next instructions in the engineering dispute reached their destination.",
    "The exchange continued the work around the Venture Company's machinery.")

q(640, "The Broken Sigil", "Arathi Highlands", 40, "stromgarde", 3,
    "Two sigils remained with the Stromgarde militia. Galen Trollbane had broken the Sigil of Thoradin into eleven pieces and spread them among his defenders. The troll shaman Tor'gan could bind them whole again.",
    "Thoras's son had divided the second sigil among Stromgarde's defenders, eleven pieces in all. Tor'gan at Hammerfall could rejoin them.",
    "All eleven pieces seemed to be there, Tor'gan said, and the magical structure would be easy to reform. He advised closing one's eyes.",
    "All the pieces seemed to be there, Tor'gan said, and reforming the sigil's magical structure would be easy.")
q(641, "Sigil of Thoradin", "Arathi Highlands", 40, "stromgarde", 3,
    "The reconstruction had worked flawlessly, Tor'gan said. It would unlock the seal on Trollbane's tomb, and Zengu would want it back.",
    "Tor'gan's rejoined Sigil of Thoradin went back to Zengu at Hammerfall.",
    "Zengu counted the collection halfway done. The third sigil's holders moved about Arathi, he said, and he did not know where they were.",
    "With two sigils in hand, Zengu was halfway to Trol'kalar. The third was carried by someone who moved around Arathi.")
q(643, "Sigil of Arathor", "Arathi Highlands", 41, "stromgarde", 3,
    "Prince Galen still trotted the remnants of his cavalry across the Highlands, though he barely held Stromgarde. Zengu could not understand why, but one sigil had gone to Lieutenant Valorcall, the cavalry's leader.",
    "Lieutenant Valorcall led what remained of Stromgarde's cavalry across Arathi, and carried the third sigil with him.",
    "Valorcall was dead and his sigil at Hammerfall. Zengu called it a large blow to Stromgarde's defenders and counted one sigil left.",
    "The cavalry's leader fell, and his sigil joined the others. Only one more stood between the Darkspear and Trol'kalar.")
q(644, "Sigil of Trollbane", "Arathi Highlands", 42, "stromgarde", 4,
    "Prince Galen Trollbane carried the last sigil himself, in a chapel in the militia-held districts of Stromgarde. He was well protected, Zengu warned, and no slouch of a warrior.",
    "The final sigil was with Thoras's son, deep in Stromgarde's chapel among his militia.",
    "Zengu called it quite a day. The blood of Trollbane would no longer haunt his people, he said, and every sigil was in their possession. Soon the Darkspear would strike at Zul'Gurub.",
    "Galen's sigil completed the set. Zengu spoke of the day, soon, when the Darkspear would strike against the hated trolls of Zul'Gurub.")
q(645, "Trol'kalar", "Arathi Highlands", 42, "stromgarde", 4,
    "Brought together, the four sigils had joined into one. Zengu had no doubt it would break the wardings on Trollbane's tomb, in the Sanctum behind Stromgarde's chapel.",
    "Thoras Trollbane lay entombed in the Sanctum behind the chapel in Stromgarde. With the joined Sigil of Ignaeus, his tomb and the sword inside could be opened.",
    "The lines on the face of the tomb matched the glowing lines of the Sigil of Ignaeus. A flash of light consumed the sigil, and Trol'kalar slipped free of the stone hands.",
    "The sigil burned away in a flash against the tomb, and the stone hands released Trol'kalar. Its delivery to Zengu still remained.", true)
q(646, "Trol'kalar", "Arathi Highlands", 42, "stromgarde", 5,
    "The light faded, and Trol'kalar was out of its stone sheath. At Hammerfall, Zengu waited for it.",
    "The sword of the Trollbanes had to be carried back to Zengu in Hammerfall.",
    "For generations, Zengu said, Strom and Arathor had ravaged the trolls. Now their greatest weapon was in Darkspear hands, and the inching progress in the forests of Zul'Gurub would end. He promised to send it to Nimboya at Grom'gol.",
    "Zengu took Trol'kalar and called the Darkspear indebted. The sword would go to Nimboya at Grom'gol, for the fight in Zul'Gurub.", true)
fallback("Trol'kalar", "Arathi Highlands", "stromgarde", "645,646",
    "Trollbane's sword was the object of Zengu's work around Stromgarde.",
    "The Darkspear sought Trol'kalar for their struggle against the trolls of Zul'Gurub.",
    "The task advanced the recovery of Trol'kalar from Stromgarde.",
    "The recovery of Trollbane's sword advanced the Darkspear's preparations for Zul'Gurub.")
q(651, "Stones of Binding", "Arathi Highlands", 38, "myzrael", 3,
    "Four Stones of Binding across Arathi kept Myzrael pinned beneath the earth. Only keys from three of them could unlock the strongest, the Stone of Inner Binding. Each was watched by a guardian.",
    "Myzrael spoke of guardians at every binding stone. Someone clever, or lucky, she said, might find a way to banish them and gather the keys.",
    "Through the opened stones, Myzrael announced that her shackles were loosening and called her helper a rescuer.",
    "The Stones of Binding opened. Myzrael's voice came through them with thanks, for she could feel her restraints loosen.")
q(652, "Breaking the Keystone", "Arathi Highlands", 42, "myzrael", 4,
    "Fozruk carried the Rod of Order, the key to the Keystone that still held Myzrael chained.",
    "Myzrael's promised release depended on a stone watcher's key and the charged Keystone.",
    "The Rod of Order was placed in the Keystone, and a shudder passed through the ground.",
    "Fozruk's Rod of Order went into the Keystone, and a shudder ran through the ground beneath it.")
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
    "Myzrael's prison was restored by the shackles, and the shards that once offered reassurance pulsed with menace.")
q(655, "Hammerfall", "Arathi Highlands", 34, "gormul", 3,
    "Gor'mul spoke of his years in the camp, bound by wood and steel. He remembered Doomhammer coming in his midnight plate with the warhammer held high. A coward's lance from behind had run the Warchief through. Gor'mul said he had fallen to his knees, and he still asked what hope there was.",
    "In Hammerfall, Gor'mul could still see Doomhammer struck down from behind by a rider's lance. He had found no hope since, and said so.",
    "Tor'gan knew of him. Gor'mul had been a captive when Thrall and Orgrim fought to free the camp. When the earth shook and the others escaped, he was left behind. He wandered alone for years until the Horde returned to Hammerfall.",
    "Tor'gan explained that Gor'mul had never recovered from Doomhammer's death. Left behind when the camp was freed, he had wandered alone without direction until the Horde came back to Hammerfall.")
q(672, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "Tor'gan's people had tried to cheer Gor'mul with talk of Orgrimmar and of Thrall, who bore Orgrim's armor and hammer. Nothing moved him. A demonstration of the new shamanic magic might, so Tor'gan asked for raptor eyes.",
    "Tor'gan meant to make a small object for Gor'mul from raptor eyes. Where talk of the Warchief had failed, he said, a show of shamanistic magic was worth a try.",
    "The raptor eyes went into Tor'gan's amulet. Its bearer, he said, would have the strength of the raptors' spirits.",
    "From the raptor eyes Tor'gan would make an amulet for Gor'mul. The spirits of the raptors, he said, would lend strength to its bearer. Gor'mul had yet to receive it.", true)
q(674, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "The amulet was finished. Tor'gan sent it to Gor'mul, hoping the raptors' strength would wake the warrior's flame that once burned in his veins.",
    "Tor'gan hoped the raptor amulet would stir the warrior Gor'mul had once been.",
    "Gor'mul called the amulet polished bone and asked what use he had for it. No trinket, he said, would restore the Horde to its glory.",
    "Polished bone, Gor'mul called it, and he doubted a trinket could restore the Horde's glory. The gift did not overcome his despair.", true)
q(675, "Raising Spirits", "Arathi Highlands", 34, "gormul", 3,
    "Gor'mul tossed the amulet into the ground. He could not understand Tor'gan's mercy, he said, when fate had denied him a death beside his Warchief.",
    "The amulet lay in the dirt where Gor'mul had thrown it, and Tor'gan had to be told that his gift was refused.",
    "Tor'gan saw that it had not worked. The amulet's power had been too small, he said. He still believed a show of the shamans' strength would one day return Gor'mul to his once proud self.",
    "Tor'gan admitted the amulet had failed, its power not great enough. He kept his faith that the shamans would restore Gor'mul in time.", true)
fallback("Raising Spirits", "Arathi Highlands", "gormul", "672,674,675",
    "Tor'gan sought a way to lift the spirits of Gor'mul, an old warrior at Hammerfall.",
    "The shaman's small amulet was part of an attempt to reach a dispirited veteran.",
    "Tor'gan's attempt to comfort Gor'mul went on.",
    "Tor'gan still hoped the power of the shamans would rouse Gor'mul.")

q(203, "The Second Rebellion", "Stranglethorn Vale", 33, "kurzen", 3,
    "Sergeant Yohwa said the rebels were losing their war with Colonel Kurzen. A brilliant tactician with ten men to their one, he could only be beaten with his own covert tactics. She wanted his men killed in his camp to the east, lots of them, before reinforcements closed in.",
    "Kurzen outnumbered the rebels at least ten to one, Yohwa said. A raid on his Jungle Fighters, in and out before reinforcements came, was the rebels' way of fighting.",
    "The loss of the Jungle Fighters would relieve some of the pressure on the camp, Yohwa said. She asked whether, after a taste of Kurzen's forces, anyone still wanted to throw in with the rebels.",
    "Yohwa counted the dead Jungle Fighters as pressure taken off the camp. After that taste of Kurzen's forces, she wanted to know whether the wish to join the rebels still held.")
q(204, "Bad Medicine", "Stranglethorn Vale", 34, "kurzen", 3,
    "Kurzen's Medicine Men healed his forces with Jungle Remedies and poisoned the rebels with Venom Fern Extracts. Yohwa wanted the remedies for her own wounded and a sample of the extract to study. Medicine Men carried the remedies, and the extracts were likely stowed in the supply boxes of Kurzen's Compound.",
    "To stand a chance against Kurzen, Yohwa said, his healing support had to be neutralized. Her rebels needed his remedies and a sample of his poison.",
    "Yohwa said the remedies would keep more of the rebels alive and in fighting shape. The extracts would help them make remedies of their own.",
    "Yohwa took the Jungle Remedies for the wounded and the Venom Fern Extracts for study.")
q(200, "Bookie Herod", "Stranglethorn Vale", 35, "kurzen", 3,
    "If Kurzen knew Thorsen's secret, Doren said, the rebels had a spy in their midst. Thorsen's contact in the compound had been Bookie Herod, Kurzen's logistics officer. His office was on the top floor of the camp's only house with an upper floor.",
    "Doren wanted Bookie Herod's notes and records. As Kurzen's logistics officer, Herod knew everything about the running of the compound. His papers might show how Thorsen had been discovered.",
    "Herod's notes and records lay in the upstairs office. Among them were a list of the camp's supplies, material requests from Colonel Kurzen, and various letters.",
    "Herod's upstairs office gave up his supply lists, Kurzen's material requests and a bundle of letters.")
q(574, "Special Forces", "Stranglethorn Vale", 38, "kurzen", 4,
    "Sergeant Yohwa knew Kurzen's elite troops personally, and knew them to be skilled, loyal and cruel. They hunted the rebels, then withdrew to the Stockpile cave behind the compound.",
    "Kurzen's commandos and headshrinkers sheltered deep in the Stockpile. Yohwa sent the attack against soldiers whose skill and cruelty she knew well.",
    "Doren welcomed the news of their defeat. He had feared his rebels stood alone against Kurzen's brilliance; now he could hope they might survive.",
    "The losses among Kurzen's elite gave Doren hope. Yohwa had trusted the help sent against them, and her commander trusted her judgment.")
q(206, "Mai'Zoth", "Stranglethorn Vale", 46, "kurzen", 5,
    "Nimetz believed the ogre mage Mai'Zoth had corrupted Kurzen. He feared the ogre's evil would spread to others, and wanted him slain and his Mind's Eye brought back.",
    "The inquiry pointed Nimetz toward Mai'Zoth in Stranglethorn's eastern mountains. Convinced that the ogre's magic had ruined Kurzen, he sought the Mind's Eye.",
    "Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve a good purpose; otherwise, he meant to destroy it.",
    "Nimetz received the Mind's Eye after Mai'Zoth's death. His study would decide whether it could serve good or must be destroyed.")

q(1319, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "Vimes could make little of the shield himself. He sent it to Caz Twosprocket, one of Theramore's best blacksmiths, at the forge in the smithy.",
    "Caz Twosprocket worked the forge at Theramore's smithy. Vimes wanted the burned shield under a blacksmith's eye.",
    "An interesting piece of iron, Caz called it. It was not his work, and not made by any blacksmith he knew on this side of the sea.",
    "Caz ruled out every smith he knew on this side of the sea, himself included. Where the shield came from, he could not say.", true)
q(1320, "The Black Shield", "Dustwallow Marsh", 35, "shield", 2,
    "Caz had almost missed it. The leather strap on the back had burned away. It had been made to fit a large person, a tauren at a guess, and that was all he could say.",
    "The burned strap was Caz's only clue. It had fitted someone large, perhaps a tauren, and he sent his apologies to Captain Vimes for so little.",
    "Vimes said it was not much to work on. He hoped the other pieces of the mystery would fall into place and paint a clearer picture.",
    "A tauren entered the investigation only as a guess, and Vimes said they would keep it in mind.", true)
q(1322, "The Black Shield", "Dustwallow Marsh", 37, "shield", 2,
    "There was writing on the rim of the shield, under the burned crust. Acid would clear it, Do'gol said, and the venom sacs of the marsh's Darkfang spiders would do.",
    "Writing had turned up on the shield's rim, and Do'gol wanted Darkfang venom to burn the soot away.",
    "Spiders too big to sit on and squish were not to Do'gol's liking. He took the sacs to rip open and pour onto the shield.",
    "Do'gol meant to pour the venom over the rim of the shield. The inscription's meaning was still ahead.", true)
q(1323, "The Black Shield", "Dustwallow Marsh", 37, "shield", 3,
    "Do'gol thought he had dropped too much acid on the shield. Hard to read, but the name looked like Mosarn, and he had never heard of him. Maybe Krog knew, he said, since Krog knew many people.",
    "The acid had brought up a name, Mosarn, as far as Do'gol could read it. He sent the question to Krog.",
    "Mosarn sounded familiar to Krog, but he could not put his finger on it. A shield could come from anywhere, he said, and mean nothing.",
    "Familiar, Krog said of the name, though he could not place it. It probably was not important, he added, leaving the mystery open.", true)
fallback("The Black Shield", "Dustwallow Marsh", "shield", "1251,1253,1276,1319-1323",
    "A burned shield offered a physical clue in the investigation of the ruined inn.",
    "Blacksmiths' knowledge could help make sense of the blackened shield.",
    "The burned shield passed through more hands, but who had burned the inn stayed unknown.",
    "The blackened shield was examined further, and it still named no culprit.")
q(2863, "Alpha Strike", "Feralas", 43, "woodpaw", 3,
    "Hadoken's plan was to kill the gnolls' leaders, the Alphas, in rapid succession. Five within an hour would sow chaos in their ranks and show them that Camp Mojache could destroy them.",
    "Five Woodpaw Alphas had to die within one hour, or Hadoken's plan would fail and the impasse remain.",
    "Hadoken saluted the deed. With their leaders slain the gnolls would think twice about storming the camp, he said. Something must have whipped them into a frenzy, and he wanted to know what before they regrouped.",
    "The Alphas fell within the hour. Hadoken paid, and he meant to learn what had driven the Woodpaw to such a frenzy.")
q(2903, "The Battle Plans", "Feralas", 43, "woodpaw", 4,
    "The plans had to go back to Hadoken Swiftstrider in Camp Mojache, where someone might make sense of them.",
    "A scrawled gnoll map was for Hadoken to read at Camp Mojache.",
    "Hadoken could not cipher most of the scrawl, but he had seen enough battle plans to read this one. The gnolls were fighting a war on two fronts, and their main effort was against a foe to the south.",
    "Camp Mojache was only one of the gnolls' enemies, the plans told Hadoken. Their main energy went south, and he wanted to know against whom.")
q(7046, "The Scepter of Celebras", "Desolace", 49, "maraudon", 5,
    "Celebras's scepter had once let him travel quickly through the caverns. He had hoped to bring peace to his uncle's spirit. That task he now passed on. Rejoining the rod and the diamond needed a ritual. He asked for help while he channeled it.",
    "Celebras led the way and gave his instructions while he channeled the energy to reunite the rod with the diamond. Together, he said, they would make the Scepter of Celebras again.",
    "Celebras gave the restored scepter and asked that its power be used for good. Deeper in the caverns, with hope, his uncle's remains might be found. Much danger waited on the way.",
    "The Scepter of Celebras was whole again and in new hands. Celebras spoke of the caverns ahead, where his uncle's fate still required attention, and offered to speak again at need.", true)

q(992, "Gadgetzan Water Survey", "Tanaris", 46, "silithid", 3,
    "Nomads had seized the Gadgetzan Water Company's wells. Fizzledowser supplied a dowsing widget to sample a pool near Sandsorrow Watch, within sight of the trolls.",
    "Fizzledowser offered temporary surveying work, tapping the water near Sandsorrow Watch and bringing the widget back. The company needed new sources after losing its wells to nomads.",
    "Back came the tapped widget with news of an insect ambush. Fizzledowser admitted he had dismissed earlier reports of creatures draining the desert's water as more trouble from the nomads.",
    "An insect ambush ended the water survey. Hearing the report, Fizzledowser could no longer dismiss the stories of water-draining creatures that he had blamed on the nomads.")
q(82, "Noxious Lair Investigation", "Tanaris", 47, "silithid", 3,
    "The insects were draining the pools at the Noxious Lair. Fizzledowser wanted Centipaar parts brought to Pestlezugg so the alchemist could identify the enemy.",
    "Fizzledowser knew what was happening to the Noxious Lair's water, but little about the creatures taking it. Centipaar specimens would give Pestlezugg something to examine.",
    "Pestlezugg began examining the Centipaar parts. He had seen no insects like them and already suspected an outside influence; an emergency with Fizzledowser called for an immediate return.",
    "The specimens baffled Pestlezugg, for these insects were unlike any he knew. He suspected something might be controlling them, then sent word of Fizzledowser's urgent need for help.")
q(110, "Insect Part Analysis", "Tanaris", 48, "silithid", 4,
    "Fizzledowser stayed with Scrimshank's gear and personal effects while asking for news from Pestlezugg. He feared the surveyor would not be the insects' last victim.",
    "Pestlezugg had been studying the insect parts. Fizzledowser needed the results while he examined Scrimshank's equipment and put the dead surveyor's belongings in order.",
    "Pestlezugg had the results ready, and they troubled him. He believed the insects had been changed into ravagers by a powerful, malignant force whose identity he did not know.",
    "The alchemist's results strengthened his suspicion of outside control. To Pestlezugg, the insects looked like creatures remade for destruction by an unknown and malignant power.", true)
q(113, "Insect Part Analysis", "Tanaris", 48, "silithid", 4,
    "Pestlezugg feared the danger could spread far beyond Tanaris. He wanted Fizzledowser to copy the report so that word could reach others.",
    "The alchemist urged that everyone who could read should see his warning. Fizzledowser needed the report and a request to make a copy for free distribution.",
    "Payment came for the report's delivery, and Fizzledowser agreed to make a copy. He disliked giving away information that could earn good coin, but trusted Pestlezugg's judgment enough to do it.",
    "The warning reached Fizzledowser. Years of knowing Pestlezugg outweighed his reluctance to surrender valuable information for nothing; he agreed to copy the report for others to read.", true)
fallback("Insect Part Analysis", "Tanaris", "silithid", "110,113",
    "The Gadgetzan Water Company had sent insect parts to Alchemist Pestlezugg for study.",
    "Pestlezugg's work sought an explanation for the unfamiliar desert insects.",
    "Pestlezugg's work brought a warning of possible outside control into the Water Company's investigation.",
    "The insect investigation yielded a warning from Pestlezugg, who suspected a dangerous power behind the creatures.")
q(2606, "In Good Taste", "Tanaris", 49, "noggenfogger", 2,
    "The dew tasted terrible, Marin said, and so much for that idea. Then he had another. His friend Sprinkle was an excellent chef. She might make it go down easier, or at least give it some kick.",
    "Marin sent his foul-tasting dew to Sprinkle, the chef, with a plea to make it drinkable.",
    "A good guy, Sprinkle said of Marin, just a little eccentric. And of course he needed her help, yet again.",
    "Sprinkle took the dew and remarked that Marin needed her help yet again.")
q(2641, "Sprinkle's Secret Ingredient", "The Hinterlands", 49, "noggenfogger", 3,
    "Sprinkle's remedy for the brew's taste was Violet Tragan, a mushroom growing beneath a Hinterlands lake.",
    "A cook's secret ingredient sent the search underwater, far from Marin's desert stall.",
    "The Violet Tragan reached Sprinkle, ready to be made into an addition for the brew.",
    "The mushroom was recovered, supplying Sprinkle's missing ingredient without yet finishing the elixir.")
q(2661, "Delivery for Marin", "Tanaris", 49, "noggenfogger", 2,
    "Sprinkle handed over her Violet Powder for Marin, with word that he owed her a favor.",
    "The Violet Powder went back to Marin in Gadgetzan, along with Sprinkle's reminder of a favor owed.",
    "Violet Powder, Marin said, and agreed to give it a try. It could not make the dew any worse.",
    "Marin took the powder to try in the dew, sure it could not make things worse.")
q(2662, "Noggenfogger Elixir", "Tanaris", 49, "noggenfogger", 3,
    "Marin mixed the powder into the dew and asked for a minute to perfect what he already called the fabulous Noggenfogger Elixir.",
    "A minute's mixing, Marin said, and the Noggenfogger Elixir would be perfected.",
    "Absolutely wonderful, Marin called the elixir. He had known he had it in him, and he asked his helper to stand aside from his business. Millions would come of it, Marin said, and Sprinkle's favor was only her kidding.",
    "The Noggenfogger Elixir was finished, and Marin talked of millions. As for the favor he owed Sprinkle, he called her such a kidder.")

q(4285, "The Northern Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "The rumors about crystal pylons would not leave J.D. alone. She admitted she believed most of what people told her, and she was sure these stories were true. One pylon was said to stand somewhere in the north.",
    "J.D. wanted the northern pylon found. She could not get the thought of the pylons out of her head.",
    "A pylon stood in the north of the crater, just as people had said. J.D. had known the stories were true.",
    "The northern pylon was where the rumors had put it. J.D. said she had known all along that the stories were true.")
q(4287, "The Eastern Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "During her stay in the crater, J.D. had heard of huge pylons out in the wilderness, their insides lined with crystals. She thought they had something to do with all the crystals found so far. One was supposed to stand in the east.",
    "J.D. wanted her curiosity put to rest. Somewhere in eastern Un'Goro, people said, stood a great pylon lined with crystals.",
    "The eastern pylon was there. J.D. called Un'Goro a strange place, a different world from the moment anyone entered the crater.",
    "Word of the eastern pylon reached J.D. Entering the crater, she said, was like stepping into another world.")
q(4288, "The Western Pylon", "Un'Goro Crater", 53, "crystals", 3,
    "J.D.'s experiments had given her nothing, so she pinned her hopes on the pylons. She wondered about combining colors at one of them, then caught herself. Another pylon was said to stand in the western part of the crater.",
    "Another pylon was rumored in the western crater. J.D. had an idea about combining colors there, but first the pylon had to be found.",
    "The western pylon was found. J.D. spoke of the hidden places along the crater's sides, reached by winding paths.",
    "Out in the west stood the pylon J.D. had hoped for. Much of Un'Goro stayed out of sight, she said, along the winding paths of the crater walls.")
q(4321, "Making Sense of It", "Un'Goro Crater", 53, "crystals", 4,
    "J.D. found the pylon reports very interesting. She asked for a moment to do her calculations.",
    "With all three pylons located, J.D. turned to her sums. The answer they had been looking for, she said, was a moment away.",
    "J.D. compiled everything into a manual and handed it over, hoping her diagrams were right. She could now answer any question about the crystals.",
    "Her calculations became a manual on the crystals. J.D. gave it away and hoped her diagrams were correct.")
q(4492, "Lost!", "Un'Goro Crater", 55, "ringo", 3,
    "Spraggle's friend Ringo had gone to explore the volcano south of Marshal's Refuge. He had been gone far too long, and she was worried. She sent her canteen with anyone who would look for him.",
    "Ringo had left for the volcano in the south and had not come back. Spraggle gave her canteen to the search, sure he would need it.",
    "Ringo was found at the volcano, dazed and glad that someone had come.",
    "The search ended at the volcano. Ringo could manage little more than relief that someone had found him.")
q(4491, "A Little Help From My Friends", "Un'Goro Crater", 55, "ringo", 4,
    "The heat had become unbearable while Ringo explored, and he blamed heat exhaustion. He thought he could follow someone back to Spraggle at Marshal's Refuge. If he fainted again, a splash from her canteen should bring him round.",
    "Ringo wanted to get back to Spraggle. He could walk, he said, and a splash from her canteen would wake him if he passed out.",
    "Ringo reached Marshal's Refuge in one piece, if not in the best shape. Spraggle was glad to have him back.",
    "Spraggle had Ringo back at the refuge, worse for the heat but whole.")
q(5157, "Collection of the Corrupt Water", "Felwood", 52, "felwood", 3,
    "Deep in Jaedenar lay Shadow Hold, the fortress of the Shadow Council. Braziers around it carried protective spells. Until they went out, Greta Mosshoof could not scry inside to learn who led the Council. Her first need was water from the moonwell at the center of Jaedenar.",
    "Greta wanted to find the leader of the Shadow Council. The braziers of Shadow Hold blocked her scrying. She handed over a canteen to be filled at the moonwell of Jaedenar.",
    "Jaedenar's moonwell filled the canteen. It would do nicely, Greta said, once it had been purified, and that meant a little travel.",
    "Greta had her moonwell water. Before it touched the braziers it needed purifying, and she hoped that could be done quickly.")
q(5159, "Cleansed Water Returns to Felwood", "Felwood", 54, "felwood", 3,
    "Islen Waterseer gave back the water purified. It was the spirits who had helped, she said, not her. She sent her regards to Greta, with a warning that the Shadow Council was not a force to be trifled with.",
    "The spirits had cleansed the water through Islen Waterseer. She asked that it be carried back to Greta, who was taking on something greater than many of them knew.",
    "Greta judged the water more than enough for her purpose. She knew Islen's strength with the water spirits. That both Islen and the spirits had blessed the task gave her hope that they were on the right path.",
    "The purified water reached Greta in Felwood. Islen and the spirits had both blessed the task, and Greta took that as a sign the path was right.")
q(5165, "Dousing the Flames of Protection", "Felwood", 55, "felwood", 4,
    "The braziers were likely spread through Shadow Hold. Dousing every flame would drop the Council's protections for a short time. In that window Greta meant to look deep inside and find the head of the beast.",
    "Greta would be watching. When the last brazier went out, she would look inside Shadow Hold to learn who commanded the Shadow Council. Only then would she consider a direct attack.",
    "Through her spells Greta saw the last brazier die. She learned a few things before the Council's warlocks recast their protections, and she hoped it would be enough.",
    "One by one the flames went out. Greta had her look inside Shadow Hold before the warlocks closed it again. She would share what she had learned in a moment.")

q(5083, "Winterfall Firewater", "Winterspring", 56, "winterfall", 3,
    "The vial from a Winterfall furbolg was empty. A few drops of strange green liquid inside it almost glowed. Donova Snowden, camped by the hot springs for some time, might know what it was.",
    "A few glowing drops in a furbolg's vial raised a question for Donova Snowden at the hot springs.",
    "At the springs, Donova asked whether the vial had really come from the Winterfall.",
    "The vial went to Donova, whose first question was where it had come from.")
q(5084, "Falling to Corruption", "Felwood", 56, "winterfall", 3,
    "The green liquid reminded Donova of the sludge she had seen in Felwood. She had also seen Winterfall runners passing into Timbermaw Hold. Past the Hold lived the Deadwood tribe, corrupted and driven mad by the fel. Their camp might show dealings between the two tribes.",
    "Donova put two things together, the sludge of Felwood and the Winterfall runners heading into Timbermaw. The Deadwood camp beyond the Hold was the place to look for a link.",
    "In the Deadwood camp a cauldron bubbled with a rotting, repulsive-smelling substance.",
    "Searching the Deadwood camp ended at a cauldron of something rotting and foul.")
q(5085, "Mystery Goo", "Winterspring", 56, "winterfall", 3,
    "The green substance in the Deadwood cauldron looked like the drops in the Winterfall flask. It might be as corrupted as the furbolgs who had made it. If the Winterfall were using it, they might soon be as far gone as the Deadwood. A sample went back to Donova.",
    "A sample from the Deadwood cauldron would let Donova compare it with the Winterfall flask.",
    "Donova called the gatherer resourceful. She wondered whether the Winterfall had been to the Deadwood camp themselves.",
    "The cauldron sample reached Donova, who asked whether the Winterfall furbolgs had visited the Deadwood.")
q(5086, "Toxic Horrors", "Felwood", 56, "winterfall", 3,
    "Donova thought the sample held traces of toxic elements, but she needed something to compare it with. She believed the Deadwood gathered those elements from other corrupted creatures in Felwood. Her guess was the toxic horrors of the Irontree Woods, and she warned that the place was very dangerous.",
    "To be sure of the poison in the cauldron sample, Donova needed samples from the toxic horrors of the Irontree Woods.",
    "Donova had her comparison samples. Once she set them against the cauldron substance, she said, they would know more.",
    "The samples from the Irontree Woods reached Donova's camp for comparison with the cauldron goo.")
q(5087, "Winterfall Runners", "Winterspring", 57, "winterfall", 4,
    "Mixed with water from the hot springs, Donova found, the toxic substance lost its poison. It kept only its power to affect those who drank it, for a time. That was why the Winterfall guarded the springs so fiercely, since they needed the water to purify their firewater. She wanted the tribes cut off from each other, starting with the runners who walked between Winterfall Village and Felwood.",
    "Donova had worked out the firewater. The hot springs made the raw substance safe to drink, and the Winterfall runners carried it from Felwood. Stopping the runners and seizing their shipment was the next step.",
    "Donova examined the contents of the seized crate. She wondered whether the substance made the furbolgs more aggressive, since they did seem much larger.",
    "The runners' crate went to Donova, who looked through it and remarked that the Winterfall did seem much larger.")
q(5121, "High Chief Winterfall", "Winterspring", 59, "winterfall", 4,
    "Donova still knew little about why the furbolgs drank the substance. She wanted it stopped before it got out of hand. The Winterfall were not normally aggressive, so she believed the orders came from their chief. Whatever damage was done could likely not be undone, but with their leader slain they would get no worse. Winterfall Village lay to the east.",
    "The Winterfall's change in behavior pointed to orders from their chief, Donova thought. She sent the hunt east to Winterfall Village.",
    "High Chief Winterfall was dead. Donova hoped to get back to her studies without fear of ambush, and she gave a reward.",
    "With the high chief slain in Winterfall Village, Donova gave her thanks and hoped for quieter work at the springs.")
q(5123, "The Final Piece", "Winterspring", 59, "winterfall", 3,
    "The log taken from the high chief looked extensive. Its markings were so crude and poorly formed that a few pages were enough to give up on reading it. Donova might make something of it.",
    "The high chief's log went to Donova, the last hope of reading its crude markings.",
    "Even Donova could make nothing of it.",
    "Its markings defeated Donova as well. She wondered what it all meant, and could not say.")

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
    "Many of Darrowshire's defenders had fallen in the battle, and many roamed again as servants of the Scourge. Carlin Redpath asked for the cannibal ghouls, gibbering ghouls and diseased flayers of Plaguewood and Corin's Crossing to be hunted. Most had been the good folk of his village, and destroying their forms would set their souls free.",
    "The ghouls and flayers of Plaguewood and Corin's Crossing had once been Darrowshire's good folk, Carlin said. Destroying their forms would set their souls free.",
    "Carlin was glad to hear that the tortured souls of his brethren had been found and freed. His heart would weep less, he said, knowing that some of Darrowshire's defenders no longer served the Scourge.",
    "Some of Darrowshire's defenders were free of the Scourge. Carlin said his heart would weep a little less.")
q(5206, "Marauders of Darrowshire", "Eastern Plaguelands", 60, "darrowshire", 4,
    "Chromie had told Carlin that the relics were reagents for a powerful spell. One more was needed, the skulls of Scourge who had fought at Darrowshire. Carlin gave an enchanted crystal that would resonate when passed over the skull of a champion from the battle. He sent the hunt to the Noxious Glade and the Fungal Vale.",
    "The last reagent for Chromie's spell was the skulls of Scourge champions who had fought in the battle of Darrowshire. Carlin's crystal would resonate over the right ones, in the Noxious Glade to the north and the Fungal Vale to the west.",
    "How the resonating skulls could help, Carlin did not fully understand. Still, he felt their power and knew in his bones that they were linked to his home village.",
    "The skulls were found. Carlin felt their power without understanding it, and was sure they belonged to Darrowshire.")
q(5941, "Return to Chromie", "Western Plaguelands", 60, "darrowshire", 4,
    "Each time more relics of the battle came back to Carlin, his heart yearned to protect his village from its fate. He knew that could not be. Yet Chromie, the strange gnome in Andorhal, said it was possible and that Darrowshire could be saved. She had asked him to gather the relics and send them to her at the ruined inn there.",
    "Carlin sent the gathered relics of Darrowshire to Chromie, who waited in the ruined inn of Andorhal and claimed the village could be saved.",
    "Chromie looked over the relics. Together they wove a powerful spell, she said, one that would raise the spirits of Darrowshire, and with a little luck save Joseph Redpath.",
    "The relics were all there. Chromie spoke of raising the spirits of Darrowshire with them, and of saving Joseph Redpath with a little luck.")
q(5942, "Hidden Treasures", "Eastern Plaguelands", 60, "darrowshire", 3,
    "Pamela's daddy had told her to give over a key to a chest out back behind the house, and to say thanks. She wanted to know whether he had been told about her doll, and called the visitor a very nice person.",
    "A key came from Pamela with her father's thanks. It opened a chest behind the house, she said.",
    "The key fitted the lock and the chest opened.",
    "Behind the Redpath house the key turned, and the chest opened.")

q(5542, "Demon Dogs", "Eastern Plaguelands", 56, "tirion", 3,
    "Anyone who stayed near Tirion's refuge had to earn their keep. There were many nuisances in need of discipline, he said, starting with the plaguehounds and their runts. All he could offer in return was a warm meal and some conversation.",
    "Tirion asked that the plaguehounds and their runts around his refuge be dealt with. He could promise only a warm meal and talk.",
    "Well done, Tirion said, and he offered rest, a meal and talk of days long past.",
    "With the plaguehounds thinned, there was a place at Tirion's table and talk of days long past.")
q(5543, "Blood Tinged Skies", "Eastern Plaguelands", 56, "tirion", 3,
    "Woe to those who wandered into the Plaguelands, Tirion said. The fanatical Scarlet Crusade killed anyone without their mark, and the Scourge looked only to add to their ranks. Even the wildlife had become rapacious man-eaters, and he asked for the plaguebats that struck from the skies to be destroyed.",
    "Between the Crusade and the Scourge, even the animals of the Plaguelands had turned man-eating. Tirion wanted the plaguebats gone from the skies.",
    "A shining example of decency, Tirion called the deed. It had been long since he had felt the blood of heroes pump through his veins.",
    "The plaguebats were dead, and Tirion said such bravery was uplifting. It was long since he had felt the blood of heroes in his veins.")
q(5544, "Carrion Grubbage", "Eastern Plaguelands", 56, "tirion", 3,
    "Tirion's food was running low, and he was ashamed to admit he might not have enough to share. The only beasts around untouched by the Plague were the carrion worms. Their meat was bland but kept for months, and he needed several hundred pounds of it for the coming winter.",
    "An old man's larder was nearly empty. Carrion worms were the one beast the Plague had left alone, Tirion said, and several hundred pounds of their bland meat would see him through the winter.",
    "Tirion gave his blessing and asked the Light to watch over his young helper.",
    "Several hundred pounds of carrion-worm meat went into Tirion's stores for the winter, with his blessing.")
q(5742, "Redemption", "Eastern Plaguelands", 56, "tirion", 4,
    "The work was done, Tirion said, and it was time to rest weary bones while he properly introduced himself.",
    "After the hounds, the bats and the worms, Tirion offered a proper introduction.",
    "Redemption for the Fordrings would be a difficult task, Tirion said, and he asked whether the listener was prepared.",
    "Tirion's introduction ended with a question of readiness. The redemption of the Fordrings, he warned, would not be easy.")
q(5781, "Of Forgotten Memories", "Eastern Plaguelands", 57, "tirion", 4,
    "To help Taelan regain what he had lost, Tirion wanted things gathered from his son's past. The first was a toy he had given Taelan on his seventh birthday. It was a miniature war hammer, an exact replica of Tirion's own, and the boy's most cherished possession. After Tirion was banished for treason, Taelan's mother told the boy his father had died. At Tirion's false grave in the Undercroft, Taelan had buried the hammer along with his father's memory.",
    "Taelan had buried his toy war hammer, a copy of his father's, at Tirion's false grave in the Undercroft. It had been his most cherished possession, and Tirion wanted it back.",
    "Over the little hammer, Tirion blinked back tears. It was destiny that they had met, he said, and he had been blessed with kindness.",
    "The toy hammer came back from the Undercroft, and Tirion, holding back tears, called the meeting destiny.")
q(5845, "Of Lost Honor", "Eastern Plaguelands", 58, "tirion", 4,
    "When Uther was slain, the Order of the Silver Hand was decimated. Taelan had held out as long as he could, Tirion said, pushed to the war-torn hamlet of Northdale for a final stand. There he had wondered whether any of the Order were left alive, and whether it mattered. With that thought he had thrown down the standard and renounced all he had known. His honor lay on the ground at Northdale, and Tirion wanted it recovered.",
    "At Northdale, Taelan had thrown down the standard of the Silver Hand and renounced all he had known. Tirion asked for that symbol of lost honor brought back.",
    "The standard was as glorious to Tirion in its tattered state as on the day he had taken his oath before it. Taelan's redemption was coming, he said, and perhaps his own with it.",
    "Tattered as it was, the standard of the Order was as glorious to Tirion as the day he swore his oath before it. He spoke of his son's redemption, and perhaps of his own.")
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
P.threads.world_linken = "the wrecked raft in Un'Goro"
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
    "Magistrate Maleb feared the Syndicate's leaders were bent on Southshore's ruin. Former Alterac nobles ran the gang from the ruins of Strahnbrad. A signet ring would mark each noble among the dead.",
    "The Syndicate used ruined Strahnbrad as a headquarters. Its nobles might hide among ordinary agents, Maleb said, but their signet rings would give them away.",
    "Maleb had the signet rings. Stripped of its nobility, he said, the Syndicate would lose the ability to act decisively and shrink to a gang of thugs.",
    "Rings taken from the nobles of Strahnbrad went to Maleb. Without them, he judged, the Syndicate was no more than a gang of thugs.")

q(525, "Further Mysteries", "Hillsbrad Foothills", 34, "syndicate", 3,
    "A decrypted letter from an Alterac thieves' camp needed to reach Southshore's magistrate.",
    "The cryptic message needed the attention of the town nearest the suspected threat.",
    "Maleb judged that the Syndicate was connected with another power whose nature he still feared to guess.",
    "Maleb read signs of another power behind the Syndicate, one whose identity troubled him.")

q(537, "Dark Council", "Alterac Mountains", 40, "syndicate", 4,
    "The letter had been written by Nagaz of the Argus Wake. Maleb did not know what the Argus Wake was, but he judged any ally of the Syndicate a threat. He wanted Nagaz and his shadow mages found and killed in the Uplands north of Strahnbrad.",
    "Nagaz and the Argus shadow mages named in the letter were somewhere in the Uplands, where the Syndicate was strongest. Maleb wanted them dead.",
    "Nagaz and his envoys were killed in the Uplands. Maleb did not want the Argus Wake running the Syndicate. Nagaz had served another, he warned, so the Wake might run deep through the continent, or the world.",
    "The Argus Wake's envoys were dead. Nagaz had only been the servant of another, Maleb said. The Wake might run deep through Azeroth, or through the whole world.")

q(507, "Lord Aliden Perenolde", "Alterac Mountains", 42, "perenolde", 4,
    "Krusk judged that Aliden Perenolde had to die and his foulness leave the world. His manor stood on the shore of Lordamere Lake, north of Tarren Mill. Krusk also wanted the pendant the Warchief desired.",
    "Krusk sent the hunt north to Lord Perenolde's manor on Lordamere Lake. The orders were to kill him and bring back the pendant the Warchief wanted.",
    "Perenolde was dead, and in his manor a woman begged not to be hurt. She had never meant the Horde any harm, she said, for he had kept her there against her will.",
    "Perenolde fell. A woman in the manor pleaded to be spared and said he had held her against her will.")

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
    "After weeks of studying the dragonkin of the Burning Steppes, a researcher believed she had made a breakthrough. Her device, the Draco Incarcinatrix 900, could capture the essence of dragon whelp broodlings, or so she thought. A broodling zapped with it and then defeated should release its essence. She wanted samples, and her patron was not a person to disappoint.",
    "The Draco Incarcinatrix 900 was meant to capture a broodling's essence, if it worked. Its maker wanted samples from the Burning Steppes, and mentioned a patron best kept happy.",
    "It worked. The essence would be invaluable, the researcher said, and she hoped one day to capture living whelps or their eggs and become the envy of dragon scholars. Her employer would be happy too, and he was someone to keep happy.",
    "The device had worked, and the essence samples went into the research. Its maker dreamed aloud of capturing live whelps, and of an employer kept happy.")

q(3627, "Uniting the Shattered Amulet", "Blasted Lands", 60, "defiler", 5,
    "To reach the Defiler, the Fallen Hero said, the triad of power had to be destroyed. Sevine, Allistarj and Grol had to fall in the Blasted Lands, and the pieces of the amulet be recovered from them.",
    "Three pieces of an amulet lay with Sevine, Allistarj and Grol, the Defiler's triad of power. The Fallen Hero of the Horde wanted all three dead and the amulet made whole.",
    "Razelikh the Defiler's amulet was complete again. He had sensed the disruption in his chain of command, and he knew someone was coming for him.",
    "Razelikh's amulet was whole once more. With his triad broken, the Defiler knew that someone was coming for him.")

q(1131, "Steelsnap", "Thousand Needles", 30, "hunts", 3,
    "At times the hunt was for food, Melor said, at times for honor, at times for the Earthmother's teachings. This hunt was none of those. The hyena Steelsnap was a tyrant outside the Earthmother's blessing. He drew other hyenas to him and spread fear among the gentler beasts of Thousand Needles.",
    "Melor sent the hunt south of the Barrens after Steelsnap, a hyena he called a tyrant who spread bloodshed among more peaceful beasts.",
    "Steelsnap's death had cleansed Thousand Needles of a horrible taint, Melor said. That was the day's lesson.",
    "A horrible taint was gone from the Needles with Steelsnap, Melor said, and that was the lesson.")

q(1136, "Frostmaw", "Alterac Mountains", 37, "hunts", 4,
    "Melor judged the time right for far-off lands. Frostmaw was a yeti of the Alterac Mountains whose white coat hid him in the snow. Melor wrote on a scroll how he might be lured out.",
    "Frostmaw rarely showed himself in the snows of Alterac. Melor's scroll told how to entice him, and the yeti's mane would prove the hunt done.",
    "Back to Melor came Frostmaw's mane. Both strength and cunning had been needed to find and defeat the yeti, he said.",
    "With the mane in hand, Melor spoke of the hunt's path, from the valleys of Thousand Needles to the mountains of Alterac. One day, he said, it would lead through all the Earthmother's lands.")

q(1104, "Salt Flat Venom", "Thousand Needles", 30, "racecar", 2,
    "Fizzle Brassbolts had so many designs for the rocket car, and meant to try them all. His new fuel would burn really, really hot. The scorpids of the Shimmering Flats carried a venom full of salt, just what the mixture needed.",
    "The scorpids of the salt flats had salty venom, and Fizzle wanted it for a fuel that would make the car fly.",
    "Fizzle said the venom would work great. Now he had only to boil it down, apply skipper-otomer and add a nega-catalyst. Then he could not find his notes.",
    "Fizzle took the venom for his fuel. He had the next steps in mind, but not his notes.")

q(1105, "Hardened Shells", "Thousand Needles", 30, "racecar", 2,
    "Wizzle Brassbolts thought his brother brilliant, so brilliant that the new fuel might eat right through the car's chassis. He wanted the hard shells of the flats' tortoises for new fuel tanks before that happened.",
    "Tortoise shells from the Shimmering Flats would make tanks strong enough for Fizzle's fuel, Wizzle hoped.",
    "The shells were harder than Wizzle had thought. Working them, he said, would probably bend a whole box of tools.",
    "Wizzle had his shells for the tanks, and expected to bend a box of tools on them.")

q(1106, "Martek the Exiled", "Badlands", 35, "racecar", 3,
    "Fizzle Brassbolts wanted an engine fast enough to fly, and every piston he made failed under the stress. A smith called Martek the Exiled knew more about metal than anyone, Fizzle said. He lived far away in a Badlands camp with a goblin, so a letter went across the sea to find him.",
    "A letter carried a racing engineer's problem across the sea to Martek the Exiled. Pistons that could take very heavy stress were what Fizzle needed.",
    "Martek read the letter and agreed at once. Fizzle and his brother were two of the few people who did not want him dead, he said. Pistons that strong meant the new car would be a volcano on wheels.",
    "Fizzle's name changed things, Martek said, and he would help. If he knew Fizzle, the new car was a volcano on wheels.")

q(1108, "Indurium", "Badlands", 39, "racecar", 3,
    "Martek had not come to the Badlands only to avoid people. There was metal here, he said, and indurium was rumored to resist heat and stress. The true ore lay deep in Uldaman, but Stonevault troggs sometimes carried flakes of it.",
    "Indurium might serve for Fizzle's pistons, if the rumors of its strength held. Martek wanted flakes of it from the Stonevault troggs to test.",
    "Fine for a test, Martek judged the flakes. He meant to put them in some heat and see how they fared.",
    "Into Martek's forge went the indurium flakes. Whether the metal would suit Fizzle's pistons, the fire would tell.")

q(1137, "News for Fizzle", "Thousand Needles", 38, "racecar", 3,
    "Indurium resisted heat amazingly, Martek said, and would work for Fizzle's pistons, but flakes would not do. True ore had to be mined deep in Uldaman. Martek expected Fizzle would send someone there as soon as he heard.",
    "Martek sent his regards to Fizzle with the news that indurium ore from Uldaman could solve the piston problem.",
    "Fizzle could not wait to hear. He asked whether Martek had been found and what he had said, and begged to be told everything.",
    "Fizzle demanded every word Martek had said, three times over.")

q(1110, "Rocket Car Parts", "Thousand Needles", 31, "racecar", 2,
    "Crashes on the Shimmering Flats left rocket car parts that the racing crews might buy again.",
    "Kravel saw a market in salvaging wreckage scattered around the course.",
    "A heap of recovered parts earned Kravel's coin, and he considered what he could sell to the crews.",
    "The wreckage became saleable salvage, with Kravel openly treating other racers' misfortune as profit.")
-- band2030 (2026-11-06): Kravel's parcel for Hemet (corpus 5762; NPCs in LoreForever Z_thousandneedles).
q(5762, "Hemet Nesingwary", "Stranglethorn Vale", 31, "racecar", 2,
    "Kravel Koalbeard had a package for an old customer, a dwarf named Hemet Nesingwary. It had taken weeks to arrive, and Hemet was long gone to hunt the beasts of Stranglethorn. He had left money for the delivery, though, and Kravel liked to keep in with the rich ones. Hemet's camp lay north of Grom'gol.",
    "A parcel for Hemet Nesingwary had sat too long at the Mirage Raceway. Kravel Koalbeard paid for it to be carried across the sea to the hunter's camp in Stranglethorn.",
    "Hemet knew the package from Koalbeard at once. The crate held special-gauge ammunition that would serve well in the jungle, he said. Then he asked after crusty old Kravel, surely still up to no good.",
    "Kravel's crate came to Hemet Nesingwary north of Grom'gol, full of special-gauge ammunition. Hemet paid the carrier and wagered that Kravel was still up to no good.")

q(720, "A Sign of Hope", "Badlands", 35, "uldaman", 3,
    "A crumpled map carried a message in chalk. Hammertoe had written that they were taking him to Uldaman, and asked Ryedol to send help.",
    "Hammertoe's chalked words on a map asked Ryedol for help. They were taking him to Uldaman, the note said.",
    "Ryedol read the chalk and called it amazing. Hammertoe was alive, or had been when he wrote it.",
    "To Ryedol it was amazing news. Hammertoe had lived at least long enough to write.", true)

q(718, "Mirages", "Badlands", 38, "uldaman", 2,
    "The expedition had left wagons and crates behind in its hurry to quit the Uldaman dig. Ogres from Camp Kosh had been on them like vultures, Sigrun Ironhew said. Among the losses was the weapons cart, so the camp could not even hunt for food.",
    "Without the weapons the ogres of Camp Kosh had carried off, Sigrun Ironhew's camp had gone hungry. Someone had to get the supply crate back.",
    "The supply crate came back from Camp Kosh. That night, Sigrun said, the camp would go out for food and eat like kings.",
    "While the crate was being fetched, Sigrun admitted to swallowing a mouthful of sand. Now the party could go out for food that night.")

q(733, "Scrounging", "Badlands", 40, "uldaman", 2,
    "Sigrun Ironhew needed scrap metal for defenses at the stranded camp. The ogres of the Badlands seemed well supplied with it. Their main camp lay at Dustbelch Grotto, a good trek to the west.",
    "The Prospector was worried about the state of the little camp. Sigrun Ironhew wanted to start on its defenses, and ogre scrap from Dustbelch Grotto would do.",
    "It was a start, Sigrun said, and it would have to do until word came from Ironforge or the Explorers' League. Salt for the quenching barrel was the next want.",
    "Ogre scrap gave Sigrun a beginning on the camp's defenses while it waited on Ironforge.")

q(739, "Murdaloc", "Badlands", 42, "uldaman", 3,
    "Agmond's tracks came in from the west in bloody smears across rock and sand, and ended where he died. Beside his dead hand, the word Murdaloc was scrawled in the sandstone.",
    "The dwarf had crawled some distance before he died. His last act had been to scratch a name, Murdaloc, into the Badlands sandstone.",
    "Ironband called the news sobering. Agmond had a strong arm and a skull as thick as they come, he said. He was sure the troggs who killed him had paid for it.",
    "Prospector Ironband heard of Agmond's death and the name beside his hand. Agmond's hammer-swing had been fierce, he said, and many troggs had likely gone down with him.")

q(717, "Tremors of the Earth", "Badlands", 50, "lethlor", 5,
    "Garek no longer trusted the prison in Lethlor to hold Blacklash and Hematus. Black dragons had settled there and the ogres had stolen the Sign of the Earth. He wanted the three runestones gathered with the Sign, the seal broken, and the drakes' dreams made eternal.",
    "Three runestones kept the drakes Blacklash and Hematus asleep in Lethlor. With the Sign of the Earth they could be taken and the seal broken, and Garek asked that the sleepers never wake.",
    "The Kirin Tor need no longer worry over the prisoners of Lethlor, Garek said. He would report success to his master, Krasus.",
    "Blacklash and Hematus were dead. Garek prepared to carry the news to Krasus, who he expected would be pleased.", true)

q(629, "The Vile Reef", "Stranglethorn Vale", 37, "yenniku", 3,
    "Long ago, Kin'weelay said, a shudder of the earth had sunk an old troll city beneath the waters of the Savage Coast. Murlocs lived in its ruins now, the Vile Reef. Among them stood a tablet telling of Gri'lek, a troll hero the Darkspear held sacred.",
    "The tablet of Gri'lek in the sunken city was too large to move. Kin'weelay wanted a shard of it to enshrine in the Darkspear's new home in Orgrimmar.",
    "When he returned to Orgrimmar, Kin'weelay would place the shard in a sacred place. It would remind his people of the might and honor of Gri'lek. The deed, he said, marked a growing friendship with the Darkspear.",
    "The shard of Gri'lek's tablet would go to a sacred place in Orgrimmar, Kin'weelay said. He spoke of a growing friendship with the Darkspear.")

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
    "Kin'weelay had reshaped the Mind's Eye into a Soul Gem. It would stun Yenniku, and placed on his head it would trap his soul, to be carried to Nimboya. The boy lived with Zanzil the Outcast at the Ruins of Aboraz, on the Crystal Shore of the distant Cape.",
    "Yenniku dwelt with Zanzil at the Ruins of Aboraz. Kin'weelay's Soul Gem was the way to take him back from the witchdoctor's will.",
    "Yenniku was freed from the will of Zanzil, Nimboya said, and the mission he had thought so desperate was done. The tribe would remember the name and etch the deed in stone to live forever.",
    "With the Soul Gem, Yenniku was freed from Zanzil's will. Nimboya promised that the Darkspear would carve the deed in stone.")

q(5561, "Kodo Roundup", "Desolace", 34, "caravan", 2,
    "Smeed Scrabblescrew's kodo kombobulator could jolt an aged or dying kodo into a tame one that followed its handler. The only caravan brave enough to cross Desolace relied on him, he said. He wanted five kodos brought in.",
    "Bibbly thought he was the only goblin in Desolace who knew how to make money, Smeed said. His own kombobulator tamed dying kodos for Cork and Rigger's caravan, and he needed five more.",
    "Smeed counted them off, three, four, five. He was going to be rich, he said, and he wanted to see Bibbly's green face when the news reached him.",
    "Five tamed kodos stood at Scrabblescrew's Camp. Smeed counted them and talked of riches, and of Bibbly's face when he heard.")

q(6161, "Claim Rackmore's Treasure!", "Desolace", 36, "rackmore", 3,
    "Rackmore's log told of his ship bound for Feathermoon Stronghold and attacked by sea creatures. He had hidden his chest on Ranazjar Isle, locked with a silver key and a gold one, and both keys were lost.",
    "Rackmore's chest waited on Ranazjar Isle, and his log said two keys, silver and gold, would open it.",
    "Both keys turned, and the chest on Ranazjar Isle opened on Rackmore's treasure.",
    "The silver key and the gold key opened Rackmore's chest at last.")

q(1204, "Mudrock Soup and Bugs", "Dustwallow Marsh", 38, "dustwallow", 2,
    "Morgan Stern was working on a dish he called Mudrock Soup and Bugs. Trudging through the marsh himself, he did not think he would last long. He wanted tongues from the Mudrock turtles along the coast. Only the forked ones would do, for they were said to have a distinct flavor.",
    "Forked tongues from the Mudrock turtles of the bay had a flavor Morgan Stern wanted in his soup.",
    "The tongues would do fine, Morgan said. He would try different cooking techniques to bring out their flavor. One day he would serve a dish worthy of the Blue Recluse in Stormwind.",
    "Morgan took the forked tongues and began planning how to cook them. The Blue Recluse was still some experiments away.")

q(1261, "Marg Speaks", "Dustwallow Marsh", 40, "dustwallow", 3,
    "Marg's spirit cursed the muckshell that had killed him, then remembered he was dead. Near Theramore he had spied Alliance soldiers camped on the beach. One of them wore a pendant with more gems than any soldier could afford. Marg had stolen it that night, and a crab-man killed him on the way back.",
    "The dead scout's mission was unfinished. Marg had stolen a jeweled pendant from an Alliance soldier on the beach, and the muckshell that killed him still had it.",
    "Nazeer could hardly believe a Stormwind soldier had worn such a pendant. Marg's death was explained, he said. The pendant was a new mystery, one that might have dire effects on Alliance and Horde alike.",
    "The pendant from the muckshell told Nazeer how Marg had died. Where a Stormwind soldier had got such a thing, he said, was a mystery that could matter to both Horde and Alliance.")

q(1389, "Draenethyst Crystals", "Swamp of Sorrows", 35, "harborage", 3,
    "Magtoor said the lost ones of the Fallow Sanctuary looked as the draenei looked. The journey to Azeroth had driven them mad. They had stolen the Harborage's draenethyst crystals, and without them, he feared, his people too might lose their way.",
    "The Harborage lacked the force to enter the Fallow Sanctuary. Its draenethyst lay among the lost ones' huts and campfires, so Magtoor asked for help.",
    "Back to Magtoor came the draenethyst, and he said his people were in debt for it.",
    "Magtoor took the crystals and spoke of a debt owed by the Harborage.")

q(1392, "Noboru the Cudgel", "Swamp of Sorrows", 39, "harborage", 3,
    "Noboru had plagued the draenei of the Harborage for months. His cudgel was a symbol of the brutality they had suffered from the lost ones.",
    "The cudgel of Noboru, taken from him in the swamp, belonged with the people he had terrorized.",
    "Magtoor asked whether Noboru was dead, then called it a joyous day for the Harborage. Noboru and his gang had killed any draenei who crossed their path. The Harborage had lacked the strength to face him, and Magtoor said they were fortunate in such a friend.",
    "Noboru's weapon told Magtoor that the terror of the swamps was dead. The Harborage was fortunate in its friends, he said.")

q(1393, "Galen's Escape", "Swamp of Sorrows", 38, "harborage", 3,
    "Galen Goodward begged for help before the creatures ate him. A great treasure waited in his camp north of Stonard, he said, in a strongbox opened by a trick only he knew. He would teach it to whoever got him out.",
    "Galen promised a treasure for his escape, locked in a strongbox in the swamp north of Stonard. Only his trick would open it.",
    "The strongbox's keyhole was filled with black resin and impossible to open. Galen, though, had spoken of a hidden latch on the bottom. A quick search found it, and the box opened.",
    "Black resin choked the keyhole of Galen's strongbox. The hidden latch he had spoken of, on the bottom, did what no key could.")

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
    "Master Apothecary Faranell meant to combine two diametrically opposed substances with an ever-toxic agent, for the most ghastly results. The hearts of the Scarlet Crusade's crazed disciples in the Scarlet Monastery were the next ingredient.",
    "In the northeastern peaks of Tirisfal stood the Scarlet Monastery. Faranell wanted its zealots' hearts for a wicked concoction. Varimathras and the Dark Lady would be glad of fewer Scarlet scum, he said.",
    "Such an abundance of gore, Faranell marveled, and he called the effort most excellent.",
    "Faranell called the zealous hearts an abundance of gore, and the effort most excellent.")

q(2975, "The Ogres of Feralas", "Feralas", 43, "gordunni", 3,
    "Rok Orhan said the Gordunni scarred the land by their very presence. Their outpost lay up the river to the north. He wanted their numbers cut before they spread further into Feralas.",
    "The Gordunni outpost north of Camp Mojache was the first target. Rok Orhan meant to show the ogres their kind was not wanted.",
    "In time the land would heal, Rok Orhan said. They must not give up.",
    "At Camp Mojache, Rok Orhan welcomed the blow at the outpost and spoke of the land healing in time.", true)

q(2980, "The Ogres of Feralas", "Feralas", 44, "gordunni", 3,
    "Rok Orhan trusted a proven fighter to go on. The Gordunni held ruined night elf structures in the High Wilderness to the southwest, among withered trees and desecrated ground. These ogres were stronger than those at the outpost, he warned.",
    "The next Gordunni held old night elf ruins in the High Wilderness. Rok Orhan warned that they were much stronger than the ogres at the outpost.",
    "Trustworthy and dependable, Rok Orhan called the ally who came back from the High Wilderness.",
    "The ogres in the High Wilderness were pushed back, and Rok Orhan counted a dependable ally won.", true)

q(2978, "The Gordunni Scroll", "Feralas", 43, "gordunni", 3,
    "A soiled scroll from the Gordunni Outpost seemed to depict a gathering or ceremony. What it meant to the ogres was a question for Rok Orhan at Camp Mojache.",
    "The markings on a dirty Gordunni scroll suggested some kind of ceremony. Its meaning was a question for Rok Orhan in Camp Mojache.",
    "Rok Orhan's first question about the soiled scroll was whether it had come from the Gordunni Outpost.",
    "Rok Orhan studied the soiled scroll and wanted to know if it was found among the ogres' huts.")

q(3002, "The Gordunni Orb", "Orgrimmar", 47, "gordunni", 3,
    "Rok Orhan knew his enemy well, but he was a warrior, and the Gordunni orb needed a mage's judgment.",
    "The investigation carried the orb to Orgrimmar for a better understanding of its magic.",
    "The mage recognized the orb as powerful and dangerous.",
    "The recovered orb drew a mage's warning about the danger bound up in its power.")

q(7730, "Zukk'ash Infestation", "Feralas", 45, "woodpaw", 4,
    "Hadoken's scouts believed the foe south of the gnolls was an insect race. Sentient or not, anything that drove the Woodpaw into a frenzy was as great a threat as the gnolls, he said. He wanted their numbers thinned in the Writhing Deep and carapaces brought back.",
    "The Zukk'ash dwelt in the Writhing Deep. Hadoken wanted them thinned and their carapaces brought back as evidence.",
    "Nothing short of a full-scale invasion would end the Zukk'ash presence, Hadoken said. The attack had bought time for a proper strategy, and he would have the carapaces analyzed.",
    "For study, the carapaces went to Hadoken. The Zukk'ash were a much larger problem than the camp had expected, he admitted, and the raid had bought time.")

q(7731, "Stinglasher", "Feralas", 47, "woodpaw", 4,
    "A scout in the Writhing Deep had seen an insect far larger than the rest, with an aura the others lacked. The camp named it Stinglasher, and Hadoken wanted its secretion glands cut out for study.",
    "Stinglasher's glands might show how to deal with the Zukk'ash. Hadoken wanted them at once.",
    "Most impressive, Hadoken said. If Stinglasher was among their strongest, studying it would prove valuable in time. His charge now was to hold the camp long enough to use it. He paid a bounty with the whole camp's thanks.",
    "Stinglasher's glands reached Hadoken, who paid a bounty in the camp's name. He spoke of defending the camp long enough to use what the study would show.")

q(7732, "Zukk'ash Report", "Orgrimmar", 48, "silithid", 4,
    "Hadoken's report collected what Camp Mojache had learned about the Zukk'ash for an expert in Orgrimmar.",
    "The insect attacks had grown beyond a local matter and needed a specialist's attention.",
    "Zilzibin identified the Zukk'ash as silithid and warned that the Horde was overlooking an ancient danger.",
    "The report connected Feralas's insects with the wider silithid threat and opened a further appeal for help.")

q(7839, "Vilebranch Hooligans", "The Hinterlands", 48, "hinterlands", 3,
    "Vilebranch scum had raided Revantusk Village and stolen Smith Slagtree's tools. He had spares, but the stolen set had been a gift. A kind-hearted gnome had given it to him after saving his life when he was a young orc. Markhor had reported the tools near the temples of Agol'watha and Shaol'watha.",
    "Slagtree's stolen tools meant the world to him, a gnome's gift from his youth. They had been spotted near the temples in the northeastern Hinterlands.",
    "Slagtree had his tools back and called it a glorious day.",
    "The gnome's gift came back to Smith Slagtree in Revantusk, who gave his thanks.")

q(7861, "Wanted: Vile Priestess Hexx and Her Minions", "The Hinterlands", 51, "hinterlands", 4,
    "By order of Primal Torntusk, Vile Priestess Hexx and her minions were to be brought to justice. A grand reward waited for whoever slew the priestess and all her Aman'zasi elite guard.",
    "A notice at Revantusk Village called for the death of Vile Priestess Hexx and her Aman'zasi elite guard, in Primal Torntusk's name.",
    "Primal Torntusk called it a crippling blow to the Vilebranch, and she paid richly.",
    "Hexx and her Aman'zasi guard were dead, and the grand reward was paid. To Primal Torntusk it was a crippling blow against the Vilebranch.")

q(3442, "The Flawless Flame", "Searing Gorge", 48, "retribution", 3,
    "Kalaran meant to strike where it would hurt most, the four sentry towers. With them in flames an offensive could begin before the Dark Irons reacted. The tool to light them needed four hearts of flame and four golem oil, from the elementals and golems of the Gorge.",
    "The torch of flawless flame came first. Kalaran wanted hearts of flame and golem oil for it. The golems and elementals of the Gorge, he said, were the place to start.",
    "Hearts and oil went to Kalaran. They were almost ready, he said.",
    "Four hearts of flame and four measures of golem oil went to Kalaran, who said they were almost ready.")

q(3443, "Forging the Shaft", "Searing Gorge", 48, "retribution", 3,
    "The flawless flame needed a shaft and a casing. Dark Iron taskmasters and slavers of the Cauldron carried weapons of enchanted thorium, a sturdy alloy. Eight of their plated daggers would give Kalaran metal to break down and reforge.",
    "Kalaran wanted eight thorium plated daggers from the Dark Iron taskmasters and slavers of the Cauldron. He would reforge their alloy into the torch's shaft.",
    "An exceptional laborer, Kalaran called his helper, and he suggested a change of vocation. He named detective, or junk collector, or one of the silly gnomes who crawled the beaches with metal-detecting contraptions.",
    "The daggers reached Kalaran. Such a laborer, he said, would make an ideal treasure-hunting gnome on the beaches of Azeroth.")

q(3452, "The Flame's Casing", "Searing Gorge", 50, "retribution", 3,
    "One piece remained for the torch. In the mountains to the northwest lay a large Twilight's Hammer encampment. Its cultists were said to carry symbols and idols of their god. A single symbol of Ragnaros might hold enchantment enough for a casing, Kalaran said.",
    "Kalaran wanted a symbol of Ragnaros from the Twilight's Hammer camp in the northwestern mountains. Its magic would go into the torch's casing.",
    "The symbol radiated foul magic, Kalaran said, perfectly suited to the task.",
    "Exactly right for the casing, Kalaran judged the symbol's foul magic.")

q(3453, "The Torch of Retribution", "Searing Gorge", 50, "retribution", 3,
    "A moment, Kalaran asked, to combine the pieces and lay the enchantments on them.",
    "Hearts, oil, shaft and casing lay before Kalaran, and he began the enchanting.",
    "The torch was made. One final task remained, Kalaran said.",
    "With the enchanting finished, Kalaran spoke of one last task before the torch could be used.", true)

q(3454, "The Torch of Retribution", "Searing Gorge", 50, "retribution", 4,
    "The torch had to be bound to its owner, Kalaran said, and that meant picking it up.",
    "The last instruction was simple. Pick up the torch, Kalaran said.",
    "Taken in both hands, the torch sent waves of hatred and anger through its bearer.",
    "Hatred and anger pulsed from the torch, bound now to its bearer. The towers still stood.", true)

q(3462, "Squire Maltrake", "Searing Gorge", 50, "retribution", 3,
    "Kalaran sent the torch's bearer to his envoy, Squire Maltrake, for instruction in its use.",
    "Squire Maltrake, Kalaran's envoy, would explain how the Torch of Retribution was to be used.",
    "Maltrake asked only whether the strike was ready to be made.",
    "The squire had one question, whether his master's torch-bearer was prepared to strike.")

q(3463, "Set Them Ablaze!", "Searing Gorge", 52, "retribution", 5,
    "The four towers could never be destroyed, Maltrake said. Still, the Torch of Retribution would set them ablaze for a very long time, with a fire no element could subdue. While they burned, no guard or sentry could hold the watch posts. The Dark Irons' first line of defense would be gone. He warned of their elite sentries.",
    "Each tower had to be entered and the torch used inside its fortifications, past the Dark Irons' elite sentry units. Maltrake promised a fire that nothing could put out.",
    "The four towers burned. Maltrake called it glorious, and asked his master whether it was not glorious.",
    "Fire took the Dark Iron watch posts. Squire Maltrake called it glorious and asked his master to agree.")

q(4441, "Felbound Ancients", "Felwood", 54, "ancientflute", 3,
    "The flute from Felwood had been carved from an ancient protector, one of the treants that had long guarded the night elves. Satyrs corrupted whatever they touched, ancients included. Through the fel, this ancient's spirit had been bound and tortured, never fully released. Blessed water from the Temple of the Moon in Darnassus might purify the flute.",
    "Fel magic held an ancient's spirit inside the flute, bound and in pain. A druid in Felwood meant to try purifying it. It needed blessed water from the Temple of the Moon in Darnassus, the druid said.",
    "The blessed water came from Darnassus. Now, the druid said, they could only pray that the damage could be undone.",
    "With water from the Temple of the Moon in hand, the attempt to free the ancient's spirit could begin.")

q(4442, "Purified!", "Felwood", 54, "ancientflute", 4,
    "With the water of Elune, the druid would try to purify the flute. Its suffering had to end, the druid said, and asked Elune to guide the work.",
    "Purifying the flute would take only a moment, the druid said, with the water of Elune.",
    "The blessed water broke the link between the flute and the ancient's spirit. Played in a sacred place, the druid thought, the flute might still summon the ancient spirits. The ruins in southern Irontree Woods were worth a try, where many corrupted treants had once lived.",
    "Once the link was broken, the druid suggested trying the purified flute among the ruins in the south of Irontree Woods. Treants' spirits might still linger there.")

q(5242, "A Final Blow", "Felwood", 58, "felwood", 5,
    "There was no other way into Shadow Hold, and Greta had no means to teleport anyone inside. The only path led straight down to the bottom. There waited Shadow Lord Fel'dan, the mortal in power and the one making pacts with the Legion, with two succubus servants.",
    "Greta named the head of the serpent, Shadow Lord Fel'dan. He ruled the bottom of Shadow Hold and dealt with the Burning Legion. Only a frontal attack could reach him.",
    "Fel'dan and his two succubi were dead. Greta praised the Earthmother and called it a great day. The Shadow Council would be hard pressed to regain the power it had held.",
    "At the bottom of Shadow Hold, Fel'dan fell. Greta gave thanks to the Earthmother and said the Council's hierarchy would not soon recover from the blow.")

q(8460, "Timbermaw Ally", "Felwood", 48, "timbermaw", 3,
    "The Timbermaw were the only furbolg tribe to escape the corruption. Other races now killed furbolgs blindly, without asking friend from foe, so the Timbermaw trusted very few. Their guard in southern Felwood offered a way to prove otherwise, against the Deadwood warriors, pathfinders and gardeners to the west.",
    "Trust from the Timbermaw had to be earned. Their guard in Felwood pointed west to the corrupted Deadwood tribe. Driving them back might one day make an ally of a stranger.",
    "The Timbermaw guard thanked the outsider for protecting the tribe. They still suffered much from the past, the guard said, and offered a small gift as a sign of growing friendship.",
    "For the fighting against the Deadwood, the Timbermaw guard gave a humble offering. The tribe suffered much from the events of the past, the guard said.", true)

q(8461, "Deadwood of the North", "Felwood", 55, "timbermaw", 4,
    "A Deadwood camp lay just southwest of Nafien's post, thick with corruption. The Deadwood were evil, he said, but it was the fel that polluted their minds. It saddened him to fight his own brethren, and he asked to be spared the details.",
    "Nafien wanted the Deadwood camp to the southwest dealt with before it became a problem. Their hostility was the fel's doing, not their own, and he did not want to hear how it was done.",
    "Nafien sensed the victory and called it a hollow word for what had to be done. Still, the deed had earned the tribe's trust. The Timbermaw inside the Hold might take time to stop treating a stranger with hostility.",
    "The Deadwood camp was broken. Nafien took no joy in the victory, but he called the outsider worthy of trust. So long as no weapon was ever raised against the Timbermaw, they would find common ground.")

q(8462, "Speak to Nafien", "Felwood", 55, "timbermaw", 3,
    "The Timbermaw guard in southern Felwood thought the newcomer capable of facing a larger threat. Far north along the road, outside the entrance to Timbermaw Hold, stood Nafien. He might look like a feral and unsavory beast, but he only sought help against the forces threatening his home.",
    "Nafien kept watch outside Timbermaw Hold at the north end of the Felwood road. He might look feral, the southern guard warned, but he was not to be feared.",
    "Nafien had heard on the wind of outsiders who sought to ally with the Timbermaw. He welcomed the newcomer but warned that the tribe reacted poorly to strangers. Anyone who had not proven themselves would meet open hostility inside the Hold.",
    "At the mouth of Timbermaw Hold, Nafien gave his welcome and his warning together. These were trying times, and the tribe trusted only those who had fought the land's corruption beside them.")

q(8465, "Speak to Salfa", "Winterspring", 55, "timbermaw", 3,
    "Corruption threatened the Timbermaw from the east as well, from the Winterfall furbolgs of Winterspring. Nafien sent further help across the Hold to Salfa at the Winterspring entrance. The crossing had to be quick and peaceful, since killing a Timbermaw, even in self-defense, would only alienate the tribe.",
    "Salfa stood guard on the far side of Timbermaw Hold, by the Winterspring entrance. The Timbermaw within would attack anyone they considered hostile, Nafien warned, so the crossing had to be quick.",
    "Salfa spoke for the Timbermaw in Winterspring and defended them as well. The Winterfall of that frigid land had fallen to the same corruption as the furbolgs of Felwood. Salfa's tribe was ready to accept an offer of aid.",
    "On the Winterspring side of the Hold, Salfa named the Winterfall as the eastern threat and accepted the offer of help.")

q(8464, "Winterfall Activity", "Winterspring", 58, "timbermaw", 4,
    "The Timbermaw kept to themselves and avoided other furbolg tribes when they could. Lately the Winterfall had turned hostile, engulfed by fear and hatred of anything they did not understand. Salfa asked for their numbers thinned at Winterfall Village, far to the east.",
    "Salfa described the Winterfall as a tribe in a state of rage. Their hostility toward the Timbermaw had grown, and Salfa wanted the threat lessened.",
    "With a token of thanks for the saddening work, Salfa asked that the help continue. The Timbermaw had very few allies, and alone the threats against the tribe would be too much.",
    "Fewer Winterfall remained in their village. Salfa called the work saddening, gave a token of thanks and asked for more help, since the tribe had very few allies to call on.")

q(3520, "Screecher Spirits", "Feralas", 44, "hakkar", 3,
    "Yeh'kinya wanted the spirits of the vale screechers of Feralas, cousins of an old god and linked to him. His bramble wand, waved over a fallen screecher, would coax its spirit out to be touched.",
    "A bramble wand from Yeh'kinya would draw the essence from vale screechers in southern and central Feralas. He promised to say more about the old god once it was done.",
    "Yeh'kinya took the essence and spoke of a prophecy among the trolls. One day, it said, the dead god Hakkar the Soulflayer would return. Some called it glory for trollkind, others the end of all things. He said he did not believe it, only that Hakkar's essence held a power best kept from those who would abuse it.",
    "With the essence collected, Yeh'kinya told of Hakkar the Soulflayer and the troll prophecy of his return. He did not believe the myth, he said, but the Soulflayer's power had to be kept from abuse.")

q(3527, "The Prophecy of Mosh'aru", "Zul'Farrak", 47, "hakkar", 4,
    "The prophecy of Mosh'aru told of a way to contain the god Hakkar's essence, Yeh'kinya said. It was written on two tablets carried to Zul'Farrak. The long-dead Theka the Martyr held one, and his persecutors were said to scuttle about his shrine as scarabs. Velratha the hydromancer held the other, near Gahz'rilla's sacred pool.",
    "Yeh'kinya wanted the two Mosh'aru tablets from Zul'Farrak, from Theka the Martyr's shrine and from Velratha by the sacred pool. He meant to study them for the way to contain Hakkar's essence.",
    "Yeh'kinya could fuse the ancient tablets together and study their hidden secrets, he said. His debt grew, and it would grow further still.",
    "The tablets of Mosh'aru reached Yeh'kinya, who spoke of fusing them and of a debt that would grow.")

q(3528, "The God Hakkar", "The Temple of Atal'Hakkar", 53, "hakkar", 5,
    "It was time to capture the essence of Hakkar's avatar. The Egg of Hakkar was to be taken to the Sanctum of the Fallen God in the Sunken Temple. Its power would stir the dead god, and he would send his minions. The Hakkari blood of his bloodrinkers could douse the eternal flames that held his spirit. When all the flames went out, the avatar would enter the world, to be defeated and its essence placed in the egg.",
    "In the Sanctum of the Fallen God, the egg would stir Hakkar. His bloodrinkers' blood could douse the eternal flames that held his spirit. Once the avatar came through, it had to be beaten and sealed into the egg.",
    "The egg stirred with life as Hakkar's essence filled it. Yeh'kinya wondered whether the myths of Hakkar were true, and he feared what Hakkar might do if birthed again. He promised to keep the egg from evil hands, and said the work with him was finished.",
    "Hakkar's essence went into the egg, and the egg stirred. Yeh'kinya called the labors finished and swore to keep it safe from evil hands, fearing what a reborn Hakkar might do.")

q(4788, "The Final Tablets", "Blackrock Spire", 58, "hakkar", 4,
    "While Yeh'kinya pored over the third and fourth tablets of Mosh'aru, the fifth and sixth were wanted. The Smolderthorn trolls held them inside Blackrock Spire, the dark mountain of fire between the Burning Steppes and the Searing Gorge. It was no place for decent folk, he warned.",
    "The last two tablets of Mosh'aru lay with the Smolderthorn trolls in Blackrock Spire. Yeh'kinya warned that the mountain was no place for decent folk.",
    "Unbelievable, Yeh'kinya said, and he called the finder of the tablets a hero. That was as well. From what he had read in the earlier tablets, a hero would be needed to stop what was coming.",
    "Both tablets reached Yeh'kinya. His reading of the earlier ones had already told him that a hero would be needed to stop what was coming.")

q(3508, "Breaking the Ward", "Azshara", 58, "defiler", 3,
    "Loramus called the attempt foolhardy, a quality he found admirable in mortals. He agreed to help, if only to see one of Razelikh's minions fall. Breaking the ward over them would take time and rare artifacts, beginning with his ritual of enlightenment.",
    "The demon hunter Loramus performed his enlightenment ritual before anything else. What he learned, he said, would help him forge weapons of great power against Razelikh's subordinates.",
    "The ritual ended with one requirement. Loramus said the name of the beast had to be found.",
    "Loramus finished his ritual of enlightenment, and what it gave him was a task. Someone had to find the name of the beast.")

q(3509, "The Name of the Beast", "Azshara", 58, "defiler", 3,
    "Only a weapon of power forged with the demon lord's true name could harm him and his minions. Loramus sent the search to Lord Arkkoroc, a lesser deity in Azshara. His servants would kill any intruder they found, Loramus warned. The name would also carry a price.",
    "Lord Arkkoroc in Azshara might know the demon lord's true name. Loramus expected the lesser god to ask a price for it.",
    "Arkkoroc laughed at the mention of a demon lord. The one might assist with that information, he said, but first the one would have to be assisted.",
    "Lord Arkkoroc neither refused nor helped. Assistance first, he said, and then perhaps the name.", true)

q(3601, "Kim'jael Indeed!", "Azshara", 53, "azshara", 3,
    "Kim'jael, the blood elves called him, which meant little rat or something like it. They had hired the goblin to scout for lost treasures, then turned on him and tried to kill him. Their hands still held his equipment.",
    "The blood elves kept Kim'jael's scouting equipment after trying to kill him. Treasure had drawn him into their service, he said, and a goblin could not trust a blood elf.",
    "That would teach the blood elves to betray their partners, Kim'jael said, especially a goblin merchant as loyal as himself. He paid for the time, as promised.",
    "His equipment back, Kim'jael paid up and spoke of the lesson the blood elves had learned about betraying a goblin.")

q(3844, "It's a Secret to Everybody", "Un'Goro Crater", 52, "linken", 3,
    "A destroyed raft rested on the shore of a small pond in Un'Goro. Nothing explained how it had got there, though the trees suggested the water level was not constant. A little exploration might turn up more.",
    "A wrecked raft lay beside a pond far too small to explain it. The trees around the water hinted that the level rose and fell.",
    "At the bottom of the pond rested a water-logged pack.",
    "Something lay on the bottom of the pond, a pack soaked through.", true)

q(3845, "It's a Secret to Everybody", "Un'Goro Crater", 52, "linken", 3,
    "The pack came up out of the water. Its contents might say who owned it, and a few stray travelers at Marshal's Refuge might know more.",
    "The items in the water-logged pack were the only clue to their owner. Marshal's Refuge was the nearest place to ask.",
    "Linken looked over the things from the pack. They did look familiar, he said, kind of.",
    "At Marshal's Refuge, the pack's contents stirred something in Linken, who found them familiar, more or less.", true)

q(3908, "It's a Secret to Everybody", "Winterspring", 52, "linken", 3,
    "Linken had no idea how he had ended up in Un'Goro. It was a secret to everybody, he said, and he could not remember anything. Still, the things from the pack stirred a memory. His sword was supposed to be strengthened, though he did not know why. Donova Snowden could temper it by the hot springs of Winterspring.",
    "Linken remembered one thing from the pack, his sword. It had to be strengthened somehow, and Donova Snowden could temper it at the hot springs in Winterspring.",
    "Of course she could temper the sword, Donova said. While she worked, she wanted to know what had taken Linken so long, since he was not usually one to forget things.",
    "At the pools, Donova set to tempering the sword. Forgetting things was not like Linken, she said, and she asked what had kept him.", true)

q(3909, "The Videre Elixir", "Feralas", 52, "linken", 3,
    "Donova learned that Linken had lost his memory. His sword was not complete, she said, and the one who could finish it would be hard to speak with. First a Videre Elixir was needed from Gregan Brewspewer, who camped somewhere in the wilds of Feralas.",
    "Gregan Brewspewer camped somewhere in the wilds of Feralas and was hard to track down. He was the only one Donova knew who could help with a Videre Elixir.",
    "Donova tested one vial to be sure. This was the stuff, she said.",
    "One vial of the Videre Elixir went to Donova's test, and it proved to be the true elixir.")

q(3961, "Linken's Adventure", "Un'Goro Crater", 54, "linken", 3,
    "So Linken had come to Un'Goro to rid the crater of Blazerunner. He seemed such an ordinary fellow, J.D. said, yet he took no interest in her experiments or gadgets, unlike most gnomes. She thought him a true warrior at heart. The totem might help him remember why he had come.",
    "J.D. had finally understood why Linken was in the crater. The totem might help him remember it himself.",
    "Linken took the Silver Totem and asked whether J.D. had been any help.",
    "Back with Linken, the totem drew one question first, whether J.D. had helped at all.")

q(3962, "It's Dangerous to Go Alone", "Un'Goro Crater", 56, "linken", 5,
    "Linken remembered at last. He had come to fight Blazerunner, the last step of a journey, but he was no longer the hero. Whoever had done all this for him had to finish it. Blazerunner guarded an artifact called the Golden Flame, a power vaster than anything Linken had known and dangerous in evil hands. It was dangerous to go alone, he warned.",
    "Blazerunner guarded the Golden Flame, Linken now remembered. That fight was no longer his to finish, and his advice was not to go alone.",
    "The Golden Flame would go back to Linken's homeland, to be protected and never again used for evil. Without the help, he said, he would still have no idea who he was. He offered a choice of something special.",
    "Blazerunner was beaten and the Golden Flame recovered. Linken knew who he was again. He meant to carry the Flame home, where it could be kept safe. Then he let the one who had helped him choose a gift.")

q(4123, "The Heart of the Mountain", "Blackrock Depths", 55, "blackrock", 4,
    "For years a collector had sought a gem the size of a fist, the Heart of the Mountain. The Dark Iron dwarves kept it locked in their vault and would not sell it, so force was the only way. Their secret safe in the Lower Vault of Blackrock Depths could be breached only once Watchman Doomgrip was defeated. He would not appear until every relic coffer in the vault had been opened.",
    "The Heart of the Mountain, a gem the size of a fist, lay in a secret safe in the Lower Vault of Blackrock Depths. Every relic coffer had to be opened to bring out Watchman Doomgrip, and the safe could be breached only once he fell.",
    "Even more beautiful than imagined, the collector called the Heart, and paid for it.",
    "Payment for the Heart of the Mountain changed hands, and its buyer found it more beautiful than expected.")

q(3801, "Dark Iron Legacy", "Blackrock Mountain", 52, "forgewright", 3,
    "Franclorn Forgewright introduced himself as the very architect of the stonewrought method. Anyone who had traveled the world had passed over or stood on one of his creations, he said. He needed help, and in exchange he offered the key to the depths of his accursed city.",
    "The spirit of Franclorn Forgewright, architect of the stonewrought method, offered the key to the depths of Blackrock in exchange for a service.",
    "Whether greed had brought the visitor or selfless devotion, Forgewright said, what lay ahead was for the good of all.",
    "Forgewright did not ask whether it was greed or devotion that had brought the help. Either way, he said, the task served everyone.", true)

q(3802, "Dark Iron Legacy", "Blackrock Depths", 52, "forgewright", 5,
    "Fineous Darkvire would be found beyond the Ring of Law, in the Hall of Crafting. Forgewright wanted the miserable cur killed and the hammer Ironfel recovered. Ironfel was then to go to the Shrine of Thaurissan, into the hands of the statue raised in Forgewright's honor. That would open the compartment where he had stored the master key. It would also keep Ironfel in his grasp forever, for statue and hammer alike would shatter if anyone tried to remove it.",
    "Ironfel, Forgewright's hammer, was in Fineous Darkvire's hands in the Hall of Crafting. Set in the grasp of Forgewright's statue at the Shrine of Thaurissan, it would open the compartment that held his master key.",
    "The hammer slid firmly into place in the grasp of the massive Dark Iron monument, and a tiny compartment opened at the base of the statue.",
    "At the Shrine of Thaurissan the hammer settled into the statue's hands, and a small compartment at its base opened.", true)

q(4263, "Incendius!", "Blackrock Depths", 56, "blackrock", 4,
    "Jalinda swallowed hard when she heard that Pyron had said the name Incendius as he died. Lord Incendius was said to be a minion of Ragnaros. While he kept raising Pyron from the ashes, no team would ever get in. She had no one else to send, and asked for Incendius found and destroyed.",
    "Pyron's dying word had been Incendius. Jalinda Sprig had nobody else to send, and asked for Lord Incendius destroyed so that Pyron would stay dead and a team could get in.",
    "Oh dear, Jalinda said, and asked whether Incendius had really said the name Ragnaros. She handed over a reward, patted the bearer's wrist and faded deep into thought.",
    "Incendius was dead, and had spoken another name as he fell, Ragnaros. Jalinda paid the reward absently and sank into thought.")

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
    "Krastinov was responsible for the deaths of thousands, Eva said, and justice had to be meted out. He was to suffer the agony he had inflicted on countless innocents. Once he was destroyed, her remains and her husband's were to be burned to ashes.",
    "Eva's spirit asked for Doctor Theolen Krastinov's death and for her own remains and her husband's to be burned after it.",
    "Her spirit was healing, Eva felt. The deed was a great service to her and her husband, she said, but she was certain there was more to be done.",
    "Krastinov was dead and the remains burned. Eva's spirit began to heal, and she spoke of more to be done.")

q(5515, "Krastinov's Bag of Horrors", "Scholomance", 60, "caerdarrow", 4,
    "A great weight had been lifted from Eva's heart and her husband's, but Krastinov's master, Kirtonos, still lived. He could not be faced until a way to summon him was found. Jandice Barov was said to steward the blood of innocents from Krastinov to Kirtonos. She wanted Jandice struck down in the sunken catacombs of Scholomance, and any clues brought back.",
    "To reach Kirtonos, Eva needed a way to summon him. Jandice Barov, who carried the blood of innocents between Krastinov and his master, was to be found in the sunken catacombs of Scholomance.",
    "Eva knew the bag of horrors at once.",
    "From Jandice Barov's catacombs came the bag of horrors, and Eva recognized it.")

q(5384, "Kirtonos the Herald", "Scholomance", 60, "caerdarrow", 5,
    "Eva pointed to the vial inside the bag. It held the blood of innocents, the purest blood, used to appease Krastinov's master. With it Kirtonos could be summoned, and with it he had to be destroyed. Placed on the brazier on the porch, it would bring him, for he could not resist.",
    "The vial of innocents' blood in Krastinov's bag would summon Kirtonos to the brazier on the porch of Scholomance. Eva asked that the fury of a thousand deaths be unleashed on him there.",
    "With Kirtonos dead, Eva said, one part of Scholomance's horror came to a close, though more remained. Others there now knew of the deed. She gave a piece of the Sarkhoffs' own essence, which would allow speech with the other lost souls of Caer Darrow.",
    "Kirtonos came to the brazier and died there. Eva gave a piece of her and her husband's essence, so that the other lost souls of Caer Darrow could be spoken with.")

q(5529, "Plagued Hatchlings", "Scholomance", 58, "plaguedragons", 4,
    "The Argent Dawn had learned that the Scourge were breeding their own plagued dragonflight at Scholomance, in the middle of Darrowmere Lake. If they gained a force of dragons, Betina Bigglezink said, they would sweep across Azeroth unchecked. She asked for as many hatchlings killed as possible, before they got any bigger.",
    "In Scholomance the Scourge's necromancers were raising plagued dragons. Betina Bigglezink wanted the hatchlings dead before they grew.",
    "Well done, Betina said. It would be a long time before the Scourge could grow another clutch of dragons, or so she hoped.",
    "The hatchlings were dead. Betina hoped it would be a long time before another clutch, and did not sound certain.")

q(5531, "Betina Bigglezink", "Eastern Plaguelands", 60, "plaguedragons", 3,
    "The frozen black dragon eggs would have been invaluable to the Scourge's experiments toward a plagued dragonflight, Leonid Barthalomew said. They would surely have quickened the timetable. It was time to end the research, and outside, Betina Bigglezink, learned in science and alchemy, had produced a weapon against the Scourge.",
    "Leonid sent the frozen dragon eggs out to Betina Bigglezink, whose new weapon was meant to deal the Scourge's dragon research a heavy blow.",
    "The container pleased Betina more than the eggs, which went into safekeeping for later study. She had built a device to destroy the undead scholars of Scholomance. Its name, Dawn's Gambit, came from her doubt that it worked.",
    "For safekeeping, Betina kept the eggs and asked for their container back. Her device, Dawn's Gambit, was named for her doubts about it, and she wanted someone to find out.")

q(4771, "Dawn's Gambit", "Scholomance", 60, "plaguedragons", 5,
    "Betina placed Dawn's Gambit in the container that had held the dragon eggs, to be carried deep into Scholomance. The undead mage Vectus led a team of Scourge scholars there. Set in their chamber, the viewing room, the device would react with the undead and, with a little luck, destroy them. After that, she said, Vectus should be no problem.",
    "Dawn's Gambit went into Scholomance in the egg container, meant for the viewing room where Vectus and his scholars worked. Betina trusted to luck for the rest.",
    "Vectus was defeated. Betina asked whether Dawn's Gambit had worked, and allowed that her device might not have been the success she had hoped. She was glad things had been handled anyway.",
    "Vectus fell in the viewing room. Betina allowed that Dawn's Gambit might not have done what she hoped, and gave thanks on behalf of the Dawn and the good people of Azeroth.")

q(5282, "The Restless Souls", "Stratholme", 60, "restless", 4,
    "Egan drew his will to keep living from his hatred of the Scourge, but he was no zealot. The Scarlet Crusade would sooner destroy innocent undead than show them an ounce of compassion, he said. His blaster would unchain the tortured souls of Stratholme, and he asked for it to be used on the ghosts of the ransacked streets.",
    "Egan's blaster could free the souls still chained to Stratholme's streets. He wanted the ghosts there released, not destroyed.",
    "Egan wiped a tear from his eye and asked whether his mother had been seen, and freed. He called the deed a shining example of decency.",
    "The ghosts of Stratholme were freed. Egan, in tears, asked after his mother.", true)

q(7441, "Pusillin and the Elder Azj'Tordin", "Dire Maul", 58, "shen", 4,
    "Azj'Tordin had let his guard down for one moment while escaping the grip of the fallen Prince. In that moment the imp Pusillin had robbed him of his incantations and the key to the once great halls of Eldre'Thalas. He no longer cared about the key, having traded his immortality for freedom. The incantations he needed desperately, and Pusillin was somewhere in the Warpwood Quarter of Dire Maul.",
    "The imp Pusillin had robbed Azj'Tordin of his incantations as he fled Prince Tortheldrin. He wanted them back from the Warpwood Quarter of Dire Maul.",
    "Azj'Tordin had his incantations back and cursed the miserable imp. His material possessions were meager, he said, but he offered a choice from them.",
    "Back from Pusillin came the incantations, and Azj'Tordin, cursing the imp, offered what little he had.")

q(7488, "Lethtendris's Web", "Dire Maul", 57, "letweb", 4,
    "Lethtendris's web trapped Dire Maul's magical energy, and Latronicus Moonspear feared the damage it could cause.",
    "Latronicus wanted Lethtendris's web recovered from Dire Maul so its stored magic could be released safely.",
    "Lethtendris was dead, and Latronicus received her web with plans to disperse its energy and destroy it.",
    "The recovered web reached Latronicus, who intended to release its power across the wilds before destroying the device.", true)

q(7489, "Lethtendris's Web", "Dire Maul", 57, "letweb", 4,
    "Lethtendris meant to turn Dire Maul's tainted magic against her enemies, and Talo Thornhoof wanted her web taken from her.",
    "Lethtendris had defied her own brethren to build her web. Talo wanted it taken from her before she unleashed its power, so that more clear-headed blood elves could study it.",
    "Lethtendris was dead, and Talo received the web, intending to entrust its stored power to more careful students of magic.",
    "The web was out of Lethtendris's hands; Talo planned to send it to other students who could guard its power.", true)

q(6822, "The Molten Core", "Molten Core", 60, "waterlords", 4,
    "Hydraxis judged it time for a real test. At the bottom of Blackrock Depths lay a passage to the Molten Core, a stronghold of his enemy. The most powerful servants of fire in the world held it. He wanted it entered and its defenders beaten. Nothing short of an army, he warned, could go in and live.",
    "The Molten Core, beyond the bottom of Blackrock Depths, was the stronghold of the Waterlords' enemy. Hydraxis sent his agent there, with advice to rally allies first.",
    "It was a thing most of the agent's kind would think impossible, Hydraxis said. The beings of the Molten Core had been faced and beaten. Some day, he said, there might be a true allegiance between the mortal races and the Waterlords.",
    "The Waterlords had their proof from the Molten Core. For so small a creature, Hydraxis said, the agent had shown great resource.")

q(6824, "Hands of the Enemy", "Molten Core", 60, "waterlords", 5,
    "The Waterlords were reluctant to risk so useful an agent, but this mission was deemed worth it. Hydraxis wanted four captains of the Molten Core destroyed, Lucifron, Sulfuron, Gehennas and Shazzrah, and their hands brought back. It would take every resource the agent had, and it would deal the Firelords a terrible blow.",
    "Hydraxis named four captains of the Molten Core and asked for their hands. He did not want to lose so useful an agent, but the blow to the Firelords was worth the risk.",
    "Hydraxis would not have thought it possible, had he not known the agent. Word of the fire captains' defeat would send waves among the Waterlords. The agent's name might one day be honored among them. He hinted at yet another task.",
    "The four captains' hands were delivered to Hydraxis. Word of the feat would send waves among the Waterlords, he said, and he might have one more task.")

q(7848, "Attunement to the Core", "Blackrock Mountain", 60, "blackrock", 5,
    "Rifts stirred and tore all around Blackrock Mountain, said Lothos Riftwaker. Two paces from where he stood, a tear led through the mountain's depths into the maw of the Firelord. Attunement was simple, he said, and a core fragment from Blackrock Depths would let him attune a traveler's essence to the portal.",
    "A tear into the Firelord's domain stood beside its keeper at Blackrock Mountain, open only to the attuned. He asked for a core fragment from Blackrock Depths.",
    "The keeper of the rift could now carry the attuned traveler into the Molten Core. One had only to ask, he said, and it would be done.",
    "With the attunement complete, the keeper of the rift stood ready to send the traveler through to the Molten Core whenever asked.", true)

q(8183, "The Heart of Hakkar", "Zul'Gurub", 60, "soulflayer", 6,
    "The Heart of Hakkar burned from within. Though the Soulflayer was defeated, the kernel of his power remained in the cursed organ.",
    "Even defeated, Hakkar had left a heart that burned with the last kernel of his power.",
    "Those who received the heart took it as proof that the Soulflayer had been slain. The world was saved, they said, and its bearer was a hero of the realm.",
    "With the Heart of Hakkar delivered, the Soulflayer's death was certain. Its bearer was hailed as a hero of the realm.")

q(8801, "C'Thun's Legacy", "Ahn'Qiraj Temple", 60, "ahnqiraj", 6,
    "The walls of Ahn'Qiraj trembled. A force of evil older than the world had been destroyed. Even in death, the legacy of C'Thun's evil hung over its remains. An eye stalk of the fiend went into a pack, to be taken to the dragons in the next chamber.",
    "C'Thun was dead, a thing thought impossible. One of its eye stalks was to go to the dragons in the chamber beyond.",
    "The dragons said they were freed of C'Thun's grasp. They would leave on their own, once certain the evil within was wholly destroyed. The journey, they said, was almost at an end.",
    "Freed of the Old God's grasp, the dragons chose to stay until they were sure the evil within was gone. The long journey, they said, was almost at its end.")

q(8802, "The Savior of Kalimdor", "Tanaris", 60, "ahnqiraj", 6,
    "The dragons sent the Eye of C'Thun to Anachronos at the Caverns of Time. He would surely want it for his master's collection.",
    "Anachronos awaited the Eye of C'Thun at the Caverns of Time, to place it in his master's collection.",
    "From the timeless cache his master had left, Anachronos offered the champion a choice of artifacts spanning thousands of years.",
    "At the Caverns of Time, Anachronos took the Eye of C'Thun and opened the timeless cache.")

q(9120, "The Fall of Kel'Thuzad", "Eastern Plaguelands", 60, "naxxramas", 6,
    "The phylactery was all that remained of the master of Naxxramas. Better judgment said to destroy it and keep the lich from ever reforming. Someone at Light's Hope would pay hugely for it, though, and that voice of reason went unheeded.",
    "Kel'Thuzad's phylactery, the one thing that could let the lich return, was carried to Light's Hope for a reward rather than destroyed.",
    "Father Montoy had never expected to see such a thing in all his days. Salivating, he promised a great reward and demanded the phylactery at once.",
    "Father Montoy promised a great reward and insisted on having the phylactery now.", true)

q(9121, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "In the thick of Plaguewood lay the entrance to the dread citadel of Naxxramas. Every attempt to enter had been stopped by the wards on its rune portal, until now. The Dawn had devised a way in through arcane cloaking, an old Kirin Tor cantrip with a few modifications. Since the traveler's dedication to the Dawn was somewhat lacking, the price was high.",
    "Arcane cloaking would carry a traveler past the wards of the Naxxramas rune portal in Plaguewood. The price was high for anyone the Dawn did not yet count as devoted.",
    "A slight tingle meant the cloaking was working. Once complete, the rune portal in Plaguewood would admit the traveler into Naxxramas.",
    "Once the cantrip took hold with a tingle, the warded portal in Plaguewood would no longer bar the way into Naxxramas.", true)

q(9122, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "In the thick of Plaguewood lay the entrance to the dread citadel of Naxxramas. Its rune portal had been warded against every earlier attempt to enter. The Dawn's answer was a permanent arcane cloaking, an old Kirin Tor cantrip with modifications, and admirable service to the Dawn brought its price down.",
    "Arcane cloaking would carry a traveler past the wards of the Naxxramas rune portal in Plaguewood. It came cheaper for someone the Dawn already held in regard.",
    "A slight tingle meant the cloaking was working. Once complete, the rune portal in Plaguewood would admit the traveler into Naxxramas.",
    "Once the cantrip took hold with a tingle, the warded portal in Plaguewood would no longer bar the way into Naxxramas.", true)

q(9123, "The Dread Citadel - Naxxramas", "Eastern Plaguelands", 60, "naxxramas", 5,
    "In the thick of Plaguewood lay the entrance to the dread citadel of Naxxramas. Its rune portal had been warded against every earlier attempt to enter. The Dawn's answer was a permanent arcane cloaking, an old Kirin Tor cantrip with modifications, and for unwavering dedication to the Dawn it came free.",
    "Arcane cloaking would carry a traveler past the wards of the Naxxramas rune portal in Plaguewood. The Dawn asked nothing for it from one so devoted.",
    "A slight tingle meant the cloaking was working. Once complete, the rune portal in Plaguewood would admit the traveler into Naxxramas.",
    "Once the cantrip took hold with a tingle, the warded portal in Plaguewood would no longer bar the way into Naxxramas.", true)

q(8285, "The Deserter", "Silithus", 59, "twilight", 3,
    "Rumor said a Twilight's Hammer member called Ortell had deserted his sect. He lived as a hermit in the mountains south of Southwind Village. Perhaps he could be enlisted to decipher the restored tablet.",
    "The restored tablet needed someone who could read it. Ortell, a deserter from the Twilight's Hammer, was said to live as a hermit in the mountains south of Southwind Village.",
    "Recognizing his old organization's work, Ortell guessed that the visitor came from Cenarion Hold. If the information was to be used against the cult, he said, they might be of use to each other.",
    "In his hiding place south of Southwind, Ortell saw the tablet and understood what Cenarion Hold wanted. He invited the visitor closer and spoke of mutual assistance.")

q(8287, "A Terrible Purpose", "Silithus", 60, "twilight", 4,
    "Ortell called what he had decoded a valuable chunk of information. He had seen the Cenarion Circle's forces arrive in Silithus to drive out the Twilight's Hammer. The parchment was for their leader, Commander Mar'alith. Once the cult was vanquished, Ortell would be beyond its grasp for good.",
    "The decoded tablet went to Commander Mar'alith at Cenarion Hold. Ortell wanted the cult driven out of Silithus as much as the Circle did. Only then would he be free of it.",
    "Mar'alith found the information very interesting. It shed light on the cult's presence in Silithus, he said, and would help in the struggle against them.",
    "Mar'alith received Ortell's parchment and said it explained a good deal about the Twilight's Hammer in Silithus. He rewarded the work handsomely.")

q(8304, "Dearest Natalia", "Silithus", 60, "natalia", 3,
    "Commander Mar'alith's dear Natalia had gone missing. For weeks before she vanished she had been acting strangely. More than once he had caught her talking to herself when no one was around. She had insisted that all was well and that her research must go on. The last sighting had her heading south to Bronzebeard's camp. His soldiers were spread too thin, so Mar'alith asked for the dwarves there to be questioned.",
    "Natalia Mar'alith had last been seen on the way to Bronzebeard's camp in the south. Her husband, the commander of Cenarion Hold, had no soldier to spare to ask after her.",
    "Mar'alith lowered his head in thought at the news. Alive or dead, Natalia had to be found, he said, but duty bound him to the outpost. He asked for help once more.",
    "The news from Bronzebeard's camp left Mar'alith resolved to find Natalia, alive or dead. Duty kept him at his post.")

q(8306, "Into The Maw of Madness", "Silithus", 60, "natalia", 5,
    "Mar'alith asked for Hive'Regal to be searched for what had become of Natalia. It was no task to do alone. The dwarves at Bronzebeard's camp might have tips on the silithid inside. If she truly was as mad as they said, he wanted what must be done to be done. Then he turned away.",
    "The search for Natalia led into Hive'Regal, and Mar'alith could not go himself. If she was as mad as the dwarves said, he wanted what must be done.",
    "At the account of what Natalia had become, Mar'alith clutched at his chest. He demanded to know what C'Thun was, and how such a fiend could have turned his sweet Natalia into a monster.",
    "The name C'Thun meant nothing to Mar'alith. He wanted to know what it was, and how it had turned Natalia into the monster described.")

q(8314, "Unraveling the Mystery", "Silithus", 60, "hivecode", 3,
    "The dwarves at Bronzebeard's camp were on the verge of a breakthrough. Rubbings from the hives had let them recreate the glyphs on a crystalline prism. The glyphs seemed to be a way for the Qiraji and other unknown entities to send messages to the silithid. That was all they could learn, so the prism went to Geologist Larksbane at Cenarion Hold.",
    "The glyphed prism carried messages between the Qiraji and the silithid, the dwarves believed, but they could not unlock them. Geologist Larksbane at Cenarion Hold might.",
    "Larksbane saw why the dwarves had failed. There was nothing to decipher, since the prism's shifting outer layer had to align with the markings on the inner crystal. The one clue on its surface, she said, looked grim.",
    "There was nothing to decode, Larksbane explained. The prism's outer shell had to line up with the inner crystal. Its only clue looked grim.")

q(8315, "The Calling", "Silithus", 60, "hivecode", 5,
    "The glyphs showed an emissary of the Qiraji meeting three silithid at the bones of a large dragon. Above them was what Larksbane took for a code, perhaps the key to summoning the emissary. She copied it to be drawn in the sand at the Bones of Grakkarond. If she was right, the Overlords would come expecting new data, and the emissary held the key to the crystals.",
    "Larksbane's copied code was to be drawn in the sand at the Bones of Grakkarond. It should bring the silithid overlords and a Qiraji emissary who held the key to the crystals.",
    "In her hands, Larksbane said, lay twenty thousand years of history.",
    "What came back from the Bones of Grakkarond left Larksbane holding, as she put it, twenty thousand years of history.")
-- END REVIEWED WORLD BANDS 20261012

-- BEGIN BAND 30-50 PASS 20261106 (lane band3050). Exact IDs read in full from
-- corpus_vanilla_quests.txt; quest givers cross-checked against LoreForever
-- zone data (facts only). Report: StorageInvestigation/cj-overnight-20261105/band3050/.
P.threads.world_fever = "the cure for Stranglethorn Fever"
P.threads.world_poobah = "the captive of the Skymane"
P.threads.world_crank = "Crank Fizzlebub's crystal trade"
P.threads.world_akiris = "the akiris reed trade"
P.threads.world_smotts = "Captain Smotts's revenge on the sea giants"
-- B1: the Shimmering Flats racers' scheme with Nazz Steamboil and the Fool's Stout
q(1115, "The Rumormonger", "Thousand Needles", 36, "racecar", 2,
    "After a service for the gnomes, Kravel Koalbeard wanted a favor done for the goblins. The goblin pilot Nazz Steamboil had not always used that name, and Kravel wondered whether the secret was worth something. Krazek of Booty Bay would know the truth, if anyone did.",
    "Kravel sent questions about the goblin racer Nazz Steamboil to Krazek in Booty Bay. A pilot who had changed his name might pay to keep the reason quiet.",
    "Nazz Steamboil was a racer pilot on the Shimmering Flats, Krazek knew. He might find something out, he said, but it would not be easy, or fast, or cheap.",
    "Yes, Krazek might be able to find something out about Nazz. Not easily, he warned, and not for free.")
q(1116, "Dream Dust in the Swamp", "Swamp of Sorrows", 36, "racecar", 2,
    "Information on Nazz was quite a favor, Krazek said, and while he contacted his sources he wanted something gathered. Dream dust from the dragon whelps of the Swamp of Sorrows would do nicely for his snuff pouch.",
    "Krazek's price for the gossip on Nazz Steamboil was dream dust for his snuff pouch, from the whelps of the Swamp of Sorrows.",
    "The dream dust was found. Krazek asked how the swamp had been, where a hot meal was hard to come by.",
    "In Booty Bay, Krazek took the dream dust and remarked that hot meals were scarce in the swamp.")
q(1117, "Rumors for Kravel", "Thousand Needles", 36, "racecar", 3,
    "Krazek had used up favors, given away a rare bottle of elven wine and done some heavy deducing, he said. Now he had the information. His letter held interesting bits on Nazz Steamboil, too dangerous for Krazek to use himself. No one was to learn where it came from.",
    "Krazek's letter on Nazz Steamboil went back to Kravel on the Shimmering Flats, with a plea never to say where it came from.",
    "Kravel found the letter very interesting. Perhaps he should bow to the goblin pilot the next time he saw him, he said. Nazz would surely pay a small fortune to keep his secret.",
    "Kravel read Krazek's letter and saw a small fortune in it. Nazz Steamboil, he judged, would pay well to stay a secret.")
q(1118, "Back to Booty Bay", "Stranglethorn Vale", 43, "racecar", 2,
    "Kravel had a new scheme, risky but worth a bundle. He trusted the right person to see it through and keep quiet. It began with a letter for Crank Fizzlebub in Booty Bay, and any help Crank might need.",
    "Kravel apologized for sending anyone back to Booty Bay so soon. This time the letter was for Crank Fizzlebub.",
    "Crank read the letter and liked Kravel's sinister mind. Something to addle wits was wanted, something powerful. He wondered whether the mixture Zanzil fed his zombies could be used.",
    "Kravel's big scheme needed something to addle wits, Crank saw. His thoughts went to the mixture Zanzil fed his zombies.")
q(1119, "Zanzil's Mixture and a Fool's Stout", "Thousand Needles", 44, "racecar", 3,
    "Crank had worked out how to turn Zanzil's mixture and stout into a powerful libation he called Fool's Stout. He wanted it tried out for Kravel. The mixture drove the stout's yeast into high gear, he warned, so it would not stay fresh forever.",
    "The Fool's Stout went to Kravel for a test, with Crank's warning not to keep it long.",
    "Fizzlebub had come through, Kravel said, and he would remember it. They both stood to make a lot of money.",
    "Kravel welcomed Crank's Fool's Stout and talked of the money they both stood to make.")
q(1120, "Get the Gnomes Drunk", "Thousand Needles", 44, "racecar", 3,
    "The Fool's Stout had to be tried on one of the pit crews. Kravel handed over the stout for the gnome pit boss, and said not to wait, since it would go bad.",
    "Kravel's test of the Fool's Stout fell on the gnome pit crew.",
    "The gnome pit boss called the stout considerate. His boys should not be drinking with a race coming up, he said. Still, they could do with a little, and it could not be that strong.",
    "A little before the race could not hurt, the gnome pit boss decided, and he doubted the stout could be that strong.")
q(1121, "Get the Goblins Drunk", "Thousand Needles", 44, "racecar", 3,
    "The Fool's Stout had to be tried on one of the pit crews. Kravel handed over the stout for the goblin pit boss, and said not to wait, since it would go bad.",
    "Kravel's test of the Fool's Stout fell on the goblin pit crew.",
    "Booze, the goblin pit boss said, and he did not mind if they had just a little.",
    "The goblin pit boss did not mind if his crew had just a little of the stout.")
q(1122, "Report Back to Fizzlebub", "Stranglethorn Vale", 44, "racecar", 3,
    "The Fool's Stout had worked great, Kravel said. He had placed a bet on the next race and hoped the drunken crew would do a number on their car. One task remained, a note for Crank Fizzlebub in Booty Bay about the successful test.",
    "Kravel sent word of the test to Crank in Booty Bay, and hoped for more Fool's Stout for future races.",
    "The note told Crank the Fool's Stout was a success, and he called it good news. More of Zanzil's mixture, he said, would mean more stout whenever it was wanted.",
    "Crank read of the success and offered to brew more Fool's Stout for more of Zanzil's mixture.")
q(1127, "Fool's Stout", "Stranglethorn Vale", 44, "racecar", 2,
    "Crank guessed that a request for more Fool's Stout meant a return to the races. More of Zanzil's mixture, he said, and he would make more stout.",
    "Another batch of Fool's Stout from Crank cost more of Zanzil's mixture.",
    "Crank took the mixture and brewed another batch of Fool's Stout.",
    "Fresh Fool's Stout came from Crank Fizzlebub for the races.")
q(1950, "Get the Scoop", "Thousand Needles", 30, "racecar", 2,
    "Magus Tirth would help with the tome, but first he needed help himself. It sat in his magically locked strongbox, opened by a phrase he could not remember. The assistant who remembered such things for him was nowhere to be found. Someone at the race track might have seen the apprentice.",
    "The tome lay in Magus Tirth's strongbox behind a forgotten phrase. His apprentice knew it, if he could be found around the race track.",
    "Tirth remembered now. He had put a little curse on Johnson and forgotten about it. Why, he could not recall, but he was sure the little ingrate had deserved it.",
    "The magic phrase came back to Tirth, along with the little curse he had put on Johnson. Johnson had deserved it, he was sure.")
-- B2: Stranglethorn leftovers (Fin's fever, Whiskey Slim, Princess Poobah, Crank's crystals, Shaky, Bloads, Captain Smotts)
q(348, "Stranglethorn Fever", "Stranglethorn Vale", 45, "fever", 3,
    "Fin Fizracket could barely speak. He had contracted Stranglethorn Fever, a deadly virus. The only cure was to eat the heart of Mokk the Savage, an elusive white beast. Only the witch doctor Unbagwa could summon it, from a hidden cave on the southern cape.",
    "Dying of Stranglethorn Fever, Fin Fizracket begged for the heart of Mokk the Savage. Witch Doctor Unbagwa in a hidden cave on the southern cape was the only one who could call the beast.",
    "Fin felt his strength returning and asked where he was. Booty Bay, he supposed, and he had had the strangest dream, though the weakness had not left him completely.",
    "Fin Fizracket came back from the edge on the heart of Mokk. He spoke of a strange dream and a weakness not yet gone.", true)
q(349, "Stranglethorn Fever", "Stranglethorn Vale", 35, "fever", 3,
    "Witch Doctor Unbagwa would speak with the spirits and make Mokk come, he said. Other gorilla-beasts listened to the spirit talk too. He wanted ten gorilla fangs first, and protection while he worked.",
    "Ten gorilla fangs were Unbagwa's price for summoning Mokk the Savage. He also wanted a guard against the other gorilla-beasts while he talked to the spirits.",
    "Unbagwa liked the gorilla fangs and agreed to talk to the spirits and make Mokk the Savage come. Without protection from the other gorilla-beasts, he warned, there would be no Mokk.",
    "The fangs satisfied Unbagwa. He would talk to the spirits for Mokk the Savage, as long as he was protected while he did it.", true)
fallback("Stranglethorn Fever", "Stranglethorn Vale", "fever", "348,349",
    "Fin Fizracket of Booty Bay lay dying of Stranglethorn Fever, and only the heart of Mokk the Savage could cure him.",
    "Witch Doctor Unbagwa on the southern cape was the one who could summon Mokk the Savage.",
    "The effort to cure Fin Fizracket's fever went forward.",
    "Unbagwa and the hunt for Mokk the Savage were part of the cure for Fin's fever.")
q(580, "Whiskey Slim's Lost Grog", "Stranglethorn Vale", 50, "sailors", 2,
    "Whiskey Slim told of a storm off the Overlook Cliffs that had nearly swallowed the ship whole. His captain had a crate of Pupellyverbos Port, taken from a privateer bound for Stormwind. It had been Slim's liquid courage until a wave tossed the bottles overboard. Slim would get a taste of the cat if they were not recovered.",
    "A crate of Pupellyverbos Port had gone over the side in a storm off the Hinterlands coast. Whiskey Slim had broken into it first. He needed the bottles back before the captain found out.",
    "The captain's grog came back to Slim, and he said he owed a big debt. With a storm brewing outside, he might keep warm with one of the bottles while it passed.",
    "Whiskey Slim had the captain's port back and called himself in debt. A storm was coming, and one bottle, he reckoned, would keep him warm.")
q(594, "Message in a Bottle", "Stranglethorn Vale", 45, "poobah", 3,
    "A bottle on the shore held a note in good handwriting. Its writer was held captive by a great Skymane on an island in the South Seas, under foreign stars. On clear days Wild Shore showed to the northwest and large sailing ships to the southwest.",
    "The note in the bottle begged for help from any would-be savior. A great Skymane held its writer on an island off the Cape.",
    "At the island, the note's writer asked whether freedom had come at last. She was Princess Poobah, and still a captive.",
    "The island held Princess Poobah, the note's writer, who asked whether rescue had come.", true)
q(630, "Message in a Bottle", "Stranglethorn Vale", 51, "poobah", 4,
    "Princess Poobah put her faith in whoever could be mustered. Her captor was King Mukla, the great Skymane who commanded the beasts of the island and kept her chained. Only his death and the key to her shackle would free her. He was not to be trifled with, she warned, and she often heard him to the southeast.",
    "King Mukla held the key to Princess Poobah's shackle. She often heard him on the southeast side of the island.",
    "Poobah was saved from a great dishonor, she said. Had it been in her power she would have offered a place in her tribe. For now she gave a token for courage and nobility.",
    "With Mukla dead and the shackle open, Princess Poobah spoke of a great dishonor averted and gave a token of thanks.", true)
fallback("Message in a Bottle", "Stranglethorn Vale", "poobah", "594,630",
    "A note in a bottle told of a captive held by a great Skymane on an island off the Cape of Stranglethorn.",
    "Princess Poobah's plea reached the mainland in a bottle.",
    "The search for the captive of the Skymane went on.",
    "Princess Poobah's rescue moved a step forward.")
q(600, "Venture Company Mining", "Stranglethorn Vale", 41, "crank", 2,
    "The Venture Company's operations across Stranglethorn kept hard-working goblins like Crank from honest gold, he said. Near Crystalvein their miners dug Singing Crystals from the hills, and Crank wanted the crystals taken from them, as proof.",
    "Crank Fizzlebub wanted the Venture Company shown they did not have the run of the jungle. Their Singing Crystals from the hills by Crystalvein would do as proof, and he could get a bundle for them.",
    "Great, wonderful, Crank said, he could get a bundle for the crystals. The Venture Company had picked the wrong jungle, and everyone would be better off if they moved out.",
    "Crank took the Singing Crystals, called it a good deed, and talked of the bundle they would fetch.")
q(605, "Singing Blue Shards", "Stranglethorn Vale", 35, "crank", 2,
    "Singing Crystals were unique to Stranglethorn and valuable to certain parties, Crank said. The Venture Company made them hard for an honest entrepreneur to gather. Basilisks ate the crystal, which hardened their skin, and decent shards could be harvested from them. The less nasty ones lived along the shore south of Zul'Kunda.",
    "Crank Fizzlebub hired help to harvest singing blue shards from the basilisks of the northern shore.",
    "Quite nicely, Crank said, the shards would do. He paid a cut and called it a pleasure doing business.",
    "A cut of the trade came from Crank for the blue shards, and he called it a pleasure doing business.")
q(606, "Scaring Shaky", "Stranglethorn Vale", 41, "dues", 2,
    "Sea Wolf MacKinley could not stand people who did not pay their gambling debts. Shaky Phillipe down by the docks owed him plenty from last week's game. To collect, Shaky had to be scared with a nice selection of giblets from elder Mistvale gorillas. He was not to know they came from an animal.",
    "MacKinley's plan for collecting from Shaky Phillipe was a bag of gorilla giblets and the worst Shaky could imagine.",
    "Shaky did not want to know where the giblets came from. He asked who had sent them, and guessed Sea Wolf.",
    "The giblets worked on Shaky, who guessed at once that Sea Wolf had sent them.")
q(607, "Return to MacKinley", "Stranglethorn Vale", 41, "dues", 2,
    "Shaky handed over a pouch for Sea Wolf and swore he had meant to pay him back. He had only got a little drunk and lost his way, he said, and there was no need to get rough.",
    "Shaky's pouch went back to MacKinley with his excuses.",
    "MacKinley wanted to know how hard Shaky had shaken at the sight of the giblets. The man was so easy to read, he said, that he could not help winning at cards against him. Now it was the collector's turn to get paid.",
    "MacKinley laughed at how easy Shaky was to read at cards, and he paid for the collection.")
q(617, "Akiris by the Bundle", "Stranglethorn Vale", 43, "akiris", 2,
    "Privateer Bloads had a friend named Groy who made a killing selling akiris reed. The naga called it that, a valuable ocean reed, and Bloads was not sure what it was for. Ten stalks from the naga on the beach to the north would start the business.",
    "Bloads offered work for ten stalks of akiris reed, taken from the naga north of Booty Bay.",
    "Not too much of a challenge after all, Bloads said of the ten stalks. No offense to the naga, but everybody had to make a living.",
    "For Groy's trade, Bloads had his ten stalks of akiris reed.", true)
q(623, "Akiris by the Bundle", "Dustwallow Marsh", 43, "akiris", 2,
    "Groy had sent word that he was satisfied with the last shipment and had a client who wanted more right away. Bloads would not sail for Theramore for a week, but anyone willing to make the journey could carry the reed. Theramore could be dangerous for the wrong kind of crowd, he warned.",
    "A bundle of akiris reed for Privateer Groy went across the sea to the docks of Theramore.",
    "Groy had better things to do than talk, until Bloads's name came up. The bundle would make his client happy, he said, and he paid with coin and advice, to get off his docks.",
    "Privateer Groy took the reed on the Theramore docks, paid, and said to get off them.", true)
fallback("Akiris by the Bundle", "Stranglethorn Vale", "akiris", "617,623",
    "Privateer Bloads of Booty Bay traded in akiris reed, the ocean reed the naga gathered.",
    "Akiris reed from the naga found buyers through Privateer Bloads and his friend Groy.",
    "The akiris trade went on.",
    "Bloads's business in akiris reed moved forward.")
q(8551, "The Captain's Chest", "Stranglethorn Vale", 47, "smotts", 3,
    "Captain Hecklebury Smotts had sailed from Booty Bay all the way to Ratchet, a successful captain with a sterling reputation. Then the sea giants smashed his ship, killed his crew and set him adrift in a lifeboat to Booty Bay. One of them, Gorlash, stole his captain's chest for a snuffbox. He wandered the coast to the east now, Smotts said.",
    "Smotts wanted his captain's chest back from the sea giant Gorlash, who had taken it for a snuffbox. Gorlash roamed the coast east of Booty Bay.",
    "Oh happy day, Smotts said. Getting his chest back cooled some of the fire in him, but his revenge was not complete.",
    "The chest came back from Gorlash, and Smotts spoke of fire cooled a little and a revenge not yet complete.", true)
q(8552, "The Monogrammed Sash", "Stranglethorn Vale", 50, "smotts", 4,
    "A fine sash carried the letters HS embroidered along its hem.",
    "The letters HS on a sash taken from a sea giant pointed to Captain Hecklebury Smotts.",
    "Smotts knew his sash, and knew what it meant. Mok'rash the sea giant was dead, one of the three who had smashed his ships and killed his crews, three times over.",
    "Mok'rash was dead, the sash told Smotts. The giant had been one of three who wrecked him three times. Smotts was glad the scurvy villain was gone.", true)
q(8553, "The Captain's Cutlass", "Stranglethorn Vale", 50, "smotts", 3,
    "After the first wreck Smotts had bought another ship and named her Smotts' Revenge. He filled her with crew and supplies and went hunting the giants. They beat him, smashed the ship, killed his second crew and set him adrift again. This time the giant Negolash took his cutlass. Sprogger, the cook who survived, could help find the giant.",
    "Smotts wanted his cutlass back from Negolash. His old cook Sprogger, a survivor of Smotts' Revenge, knew how to find the giant.",
    "The captain had told Sprogger that someone was going after Negolash.",
    "Word had reached Sprogger from the captain to expect a visitor about Negolash.", true)
q(618, "Facing Negolash", "Stranglethorn Vale", 50, "smotts", 4,
    "Negolash was a hungry giant, Sprogger said. When the giants destroyed the ship he had gone straight for the kitchen. He was not hungry for crew but for wine and Sprogger's barbecued buzzard wings. The recipe had been fetched all the way from the Badlands. Wine and a heap of wings in the old lifeboat along the coast to the southeast would bring him.",
    "Sprogger's lure for Negolash was wine and his specialty, barbecued buzzard wings, left in the old lifeboat southeast along the coast.",
    "Negolash came for the wine and the wings, and fell. The captain's cutlass went back to Smotts in Booty Bay.",
    "The lure in the lifeboat worked. Negolash was dead, and Smotts's cutlass came home.", true)
-- END BAND 30-50 BATCH 1
-- B3: Arathi (Refuge Pointe, Hammerfall, Myzrael's allies, Faldir's Cove), Badlands (Sigrun, Lucien, Garek, Gorn), Searing Gorge finds, Hinterlands (Gilveradin, Fraggar)
P.threads.world_refuge = "the defense of Refuge Pointe"
P.threads.world_gorgefinds = "odd finds in the Searing Gorge"
q(681, "Northfold Manor", "Arathi Highlands", 31, "refuge", 3,
    "Captain Nials said the war for Stromgarde was being lost. Ogres, Syndicate and his own people had divided the once great city into a bloody stalemate. His forces dwindled while the enemy grew. Supplies from Southshore could not get through while the Syndicate held Northfold Manor between them.",
    "The Syndicate base at Northfold Manor sat across the supply route from Southshore. Nials wanted its men slain so that more of the trains got through.",
    "With those Syndicate members dead, Nials said, supplies from Southshore should come easier. Perhaps the cause had hope yet.",
    "After the deaths at Northfold Manor, Nials counted on easier supplies from Southshore and allowed himself some hope.")
q(682, "Stromgarde Badges", "Arathi Highlands", 37, "refuge", 3,
    "The Syndicate leaders in Stromgarde had put a bounty on Nials' militia. Gold was paid for every Stromgarde Badge taken from a dead soldier. Nials would not let cutthroats keep trophies from his brave fallen. He wanted the badges hunted back out of the Syndicate-held districts.",
    "Stromgarde Badges, taken as bounty trophies from fallen militiamen, had to be recovered from the Syndicate in the city.",
    "The families would be told that their soldiers had died in battle, Nials said. It would be grim news, but better than the uncertainty of a missing loved one.",
    "The badges let Nials give the families certainty, grim as it was.")
q(691, "Worth Its Weight in Gold", "Arathi Highlands", 36, "trelane", 2,
    "Archmage Malin had sent Skuerto and Kryten to collect reagents, and Kryten had been at a loss how to do it. He needed Witherbark tusks and medicine pouches from their witch doctors. A shadow hunter's knife was on the list too, the one given after the rites of passage. There was no telling which shadow hunter carried it until the fight.",
    "Kryten's list for Archmage Malin came from the Witherbark of southeastern Arathi, tusks, medicine pouches and a rite-of-passage knife.",
    "Incredible, Kryten said, and he could see why Malin had sent for help. At this rate he and Skuerto would be back in Stormwind in no time. Skuerto was back from scouting Boulderfist Hall and looked as if he had scuffled with the ogres. Kryten advised against mentioning it, since the dwarf was sensitive about his scouting.",
    "The reagents earned Kryten's praise, and the next talk was for Skuerto. Back from Boulderfist Hall, the dwarf looked to have had a scuffle he would not want mentioned.")
q(673, "Foul Magics", "Arathi Highlands", 40, "hammerfall", 3,
    "Tor'gan had no doubt a powerful warlock lived within the walls of Stromgarde. Through an arcane relic, the warlock summoned terrible demons in numbers. He wanted the warlock killed and whatever magical object he carried brought back, to be destroyed.",
    "A warlock in Stromgarde had been summoning demons with a relic, and Tor'gan wanted the source of his power removed.",
    "Tor'gan's restless nights would turn to peaceful slumber once he destroyed the orb, he said. It was a chilling reminder of the power the demons had held over the orcs before Hellscream freed them from the curse.",
    "The warlock's orb went to Tor'gan for destruction. It reminded him, he said, of the demons' old hold on the orcs before Hellscream broke it.", true)
q(679, "Call to Arms", "Arathi Highlands", 40, "hammerfall", 4,
    "The head of the beast was ready to come off, Drum Fel said, with great force. Hammerfall's attackers had made their lair in the ruins of Stromgarde, that glaring symbol of human frailty. He wanted the Boulderfist lords and their lackey shaman slain.",
    "Drum Fel's final blow fell on the Boulderfist lords in the ruins of Stromgarde and the shaman who served them.",
    "The threat to Hammerfall was greatly lessened, Drum Fel said. He was sure the camp would begin to thrive in the Highlands.",
    "With the Boulderfist lords dead, Drum Fel expected Hammerfall to thrive in the Highlands.", true)
q(680, "The Real Threat", "Arathi Highlands", 40, "hammerfall", 4,
    "Korin Fel said her husband did not know why Hammerfall was under attack. Or'Kalar, Mug'thol's pawn in Stromgarde, hated Drum Fel for defeating him years ago and wanted him dead. Her auguries showed a trap. She had hidden the ogre's presence from her husband, who would rush off foolishly, and asked that Or'Kalar be slain.",
    "Korin Fel kept a secret from her husband, that the ogre Or'Kalar had laid a trap for him in Stromgarde. She asked for the ogre's death, and spoke of a different kind of strength and honor.",
    "Korin Fel called it a great service. Her husband's life and Hammerfall's safety were protected for another day, she said, and she gave a reward for courage.",
    "Or'Kalar was dead, and Korin Fel said her husband and Hammerfall were safe for another day.")
q(702, "Guile of the Raptor", "Arathi Highlands", 37, "gormul", 3,
    "Tor'gan's orb carried the essence of the raptor. Used on Gor'mul, he hoped, it would invigorate the old warrior's spirit and give him purpose. Then the Horde's current state could be explained to him, and a great warrior gained for its battles.",
    "Tor'gan tried once more with an orb of raptor essence. Gor'mul asked whether this time it was colored string, or a rope to end his misery.",
    "At least it was something interesting this time, Gor'mul said. The orb gave off a strange power.",
    "A strange power came from the orb, and Gor'mul allowed that it was interesting.", true)
q(847, "Guile of the Raptor", "Arathi Highlands", 37, "gormul", 4,
    "Gor'mul asked whether this was the power of the shamans that Tor'gan had tried to show him. It was interesting, he admitted, and for the time being Tor'gan had convinced him. He would listen.",
    "The raptor's power had reached Gor'mul at last. He sent word to Tor'gan that he would listen to what the shaman had to say.",
    "Tor'gan would speak with Gor'mul when the enchantment wore off. He thanked whoever had helped return Gor'mul to the land of the living. Gor'mul, he had no doubt, was grateful too.",
    "Gor'mul was back among the living, Tor'gan said, and he would talk with him once the enchantment faded.", true)
fallback("Guile of the Raptor", "Arathi Highlands", "gormul", "702,847",
    "Tor'gan hoped an orb of raptor essence would reach Gor'mul where the amulet had failed.",
    "The shaman's last attempt on Gor'mul's despair was an orb carrying the essence of the raptor.",
    "Tor'gan's effort to restore Gor'mul went on.",
    "The orb of raptor essence played its part in Tor'gan's work on Gor'mul.")
q(635, "Crystal in the Mountains", "Arathi Highlands", 35, "myzrael", 2,
    "The shard pulsed in the hand. It carried a sense of pleading, as if someone in desperate need were trying to speak. A vision showed the northern mountains of Arathi and a brilliant crystal jutting from the earth there.",
    "A pendant's shard carried a plea and a vision of a crystal in Arathi's northern mountains.",
    "The crystal in the mountains pulsed as if a living force were trapped within it.",
    "At the crystal jutting from the northern mountains, something within pulsed like a living thing.")
q(653, "Myzrael's Allies", "Arathi Highlands", 40, "myzrael", 3,
    "Free, Myzrael said, free to gather strength hidden from her captors. If they faced her now they would overpower and imprison her again. In time she would confront the giants. For the summoning she would one day need, she named Gerrig Bonegrip, in a shop of the Forlorn Cavern in Ironforge.",
    "Myzrael called her helper a noble ally and spoke of a summoning to come. Gerrig Bonegrip in Ironforge's Forlorn Cavern knew how it was done.",
    "The Lady had told Gerrig of the coming, he said. He welcomed the visit to his abode, since both of them served a higher cause.",
    "In the Forlorn Cavern, Gerrig was expecting the visit. The Lady had told him, and he spoke of a higher cause they both served.", true)
q(687, "Theldurin the Lost", "Badlands", 40, "myzrael", 3,
    "Theldurin the Lost had once been a member of the Twilight's Hammer, the order that served the Lady. Then he lost his mind and scorned its teachings. He had fled with the scroll of Myzrael, and rumor put him in the Badlands, gibbering and mad. To bring the Lady back, the scroll had to be found, and Theldurin first.",
    "The scroll of Myzrael had gone into the Badlands with Theldurin the Lost, a madman who had broken with the Twilight's Hammer.",
    "Theldurin said hello, several times, then apologized for being rude and took it back. That had been crazy talk, he admitted, and sometimes being crazy was his only solace.",
    "Theldurin the Lost greeted the visitor with a string of hellos and an apology he withdrew. Crazy talk, he called it, and his only solace.")
q(665, "Sunken Treasure", "Arathi Highlands", 40, "faldir", 2,
    "Professor Phizzlethorpe counted himself and the doctor full-fledged Blackwater Raiders now. Their job was to help O'Breen find the lost elven treasure. Gems were next to impossible to find in the dark sea without the doctor's goggles. The goggles had to be charged at the enchanted stone in the cave up the hill. That cave was cursed, with an ambush every time they came near.",
    "The professor needed a guard at the cursed cave while he charged the doctor's goggles from the enchanted stone.",
    "Doctor Draxlegauge said the goggles worked perfectly now.",
    "Charged at the stone, the goggles worked, and Doctor Draxlegauge called it well done.", true)
q(666, "Sunken Treasure", "Arathi Highlands", 40, "faldir", 2,
    "The treasure had lain on the sea floor so long that its gems had calcified into thick stone, Draxlegauge said. With the Goggles of Gem Hunting they would be easy to find. He lent them, with a reminder that he had important scientific business on safe, dry land, and wanted them back.",
    "The Goggles of Gem Hunting went down to the sea floor on loan, for Captain O'Breen's calcified treasure.",
    "Most superb, the doctor said. The Captain would be very pleased, and so would Fleetmaster Seahorn when word got back.",
    "Draxlegauge took back his goggles and the treasure, and talked of the Captain and Fleetmaster Seahorn.", true)
q(668, "Sunken Treasure", "Arathi Highlands", 40, "faldir", 2,
    "O'Breen should not be kept waiting, the doctor said, since the gems were why they were here. After a few weeks with the pirates, he and the professor had learned something. Being caught holding pirate treasure was the last thing good for their health.",
    "The gems went from the gnomes to Captain O'Breen, who would want to see them first hand.",
    "So the little gnomes had proved their worth after all, O'Breen said. He had known there was a reason to keep the ankle biters around.",
    "O'Breen took the gems and gave the gnomes grudging credit, ankle biters that they were.", true)
q(669, "Sunken Treasure", "Arathi Highlands", 40, "faldir", 3,
    "Fleet Master Seahorn had to hear of the find at once, O'Breen said. The tide was too low to leave, though, and the creatures they had disturbed watched every move. A sample of the treasure would prove the discovery to Seahorn in Booty Bay.",
    "Word of the treasure, with a sample as proof, had to reach Fleet Master Seahorn in Booty Bay from the stranded cove.",
    "Leave it to good old Shakes O'Breen, Seahorn said. He had known he was the right captain for the mission.",
    "Seahorn took the sample and praised his choice of Shakes O'Breen for the mission.", true)
q(670, "Sunken Treasure", "Arathi Highlands", 40, "faldir", 2,
    "Seahorn's fleet was stuck in Booty Bay until it could restock. Heavy things were brewing here and abroad, he said. He had top secret correspondence for Shakes O'Breen, tied up off the Arathi coast. It had to be delivered safely and in confidence.",
    "Fleet Master Seahorn trusted an adventurous type with secret correspondence for O'Breen off the Arathi coast.",
    "O'Breen gave thanks for the long and perilous journey, and the gratitude of the Blackwater Raiders.",
    "The correspondence came to O'Breen at Faldir's Cove after a long and perilous journey, and earned the Blackwater Raiders' gratitude.", true)
fallback("Sunken Treasure", "Arathi Highlands", "faldir", "665,666,668,669,670",
    "Captain O'Breen's crew at Faldir's Cove hunted a lost elven treasure beneath the sea, with two gnomes' goggles to help.",
    "The Blackwater Raiders' search for sunken treasure off the Arathi coast drew in gnomes, goggles and Fleet Master Seahorn.",
    "The search for the sunken treasure went on.",
    "O'Breen's treasure hunt at Faldir's Cove moved a step along.")
q(706, "Fiery Blaze Enchantments", "Badlands", 45, "uldaman", 2,
    "Sigrun Ironhew had been apprenticed to Feranor Steeltoe and learned his technique for fiery enchantments. Feranor was last heard of at a smithy with a hunting party up in Lordaeron. The process needed blood from the still-beating heart of a black drake whelp. With nothing to do but wait for word from Ironforge, Sigrun offered to show the skill for a heart from Lethlor Ravine.",
    "A black whelp's heart from Lethlor Ravine would let Sigrun Ironhew show the fiery enchantment learned from Feranor Steeltoe.",
    "The heart would do excellently, Sigrun said. Weapons would strike with searing heat.",
    "Sigrun took the whelp's heart and promised weapons that struck with searing heat.")
q(708, "The Black Box", "Badlands", 40, "badlands", 2,
    "A metallic black box, pitted as if by acid, had sat in a giant condor's stomach for a long time. Stamped on its bottom under a symbol were the words Engine 19, Ironforge Siege Brigade.",
    "The box from the condor's belly bore the mark of the Ironforge Siege Brigade and the number of an engine.",
    "Back to Pilot Longbeard of the Siege Brigade went the black box.",
    "Engine 19's box found its way to Pilot Longbeard.")
q(716, "Stone Is Better than Cloth", "Badlands", 42, "lotwil", 2,
    "Lucien Tosselwrench knew how cheap Lotwil could be, and offered to make something for all the trouble. It might even protect against the coming atrocity that was Lotwil's newest invention. He had been working the extra stones into enchanted bracers, and needed patterned bronze bracers from a blacksmith to finish them.",
    "Lucien's enchanted bracers, made from Lotwil's spare stones, wanted a blacksmith's patterned bronze bracers to complete.",
    "The finished bracers came from Lucien with an invitation to try them on.",
    "The bronze bracers came back from Lucien enchanted with Lotwil's spare stones.")
q(732, "Tremors of the Earth", "Badlands", 43, "lethlor", 3,
    "Garek had heard from Sigrun of the help given the camp, and wanted some himself. His master, Krasus of the Kirin Tor, had sent him to end the trouble brewing in Lethlor Ravine. He could not say what his tasks were. Wandering ogres near Camp Boff had stolen an object called the Sign of the Earth. He had to have it.",
    "Garek, an agent of Krasus, needed the Sign of the Earth back from the ogres seen near Camp Boff. He would say more once he had it.",
    "Garek called the Sign good tidings. The Dark Iron dwarves of Angor Fortress had made it to bind two of Deathwing's ruthless lieutenants, the twins Blacklash and Hematus.",
    "With the Sign of the Earth in hand, Garek explained what it was, a Dark Iron binding for Deathwing's lieutenants Blacklash and Hematus.", true)
q(782, "Broken Alliances", "Badlands", 43, "lethlor", 3,
    "Gorn remembered the Horde's alliance with the dragon Deathwing in the Second War. Two of Deathwing's lieutenants, Blacklash and Hematus, were imprisoned in Lethlor Ravine. To restore the Horde's honor the depraved old allies had to be silenced. The ogre mercenary Tho'grun, hired to obtain the Sign of the Earth, had betrayed the Horde and taken it to Camp Boff.",
    "Tho'grun and his ogre mercenaries had turned on the Horde and kept the Sign of the Earth, the key to the drakes' prison. Gorn wanted it back from Camp Boff, southeast of Kargath.",
    "With Tho'grun dead and his corpse left to the desert winds and the buzzards, Gorn expected the ogres to fall into disarray. A small victory, he said, that would lead to a larger one. The Sign of the Earth could now open the black drakes' prison, and they would be freed to their doom.",
    "From Tho'grun's body the Sign of the Earth came back to Gorn. Lethlor's prison could be opened now, he said, and the drakes freed only to die.", true)
q(793, "Broken Alliances", "Badlands", 50, "lethlor", 5,
    "Three runestones in the Pillars of Diamond, Opal and Amethyst held the Seal of the Earth in Lethlor Ravine, Gorn said. The Sign of the Earth would remove them and unlock the seal. Beyond it waited the black drakes Blacklash and Hematus, not to be trifled with. He wanted them dead and their bindings brought back.",
    "Gorn sent the Sign of the Earth to the far eastern Badlands. There stood the pillars of Lethlor Ravine, and the drakes waited behind the seal.",
    "Blacklash and Hematus were dead. The black dragonflight still allied with the renegade Blackrock orcs, Gorn said. Both had to be brought into line or removed. Now the Horde's attention could turn west toward Blackrock Spire.",
    "The drakes' bindings went to Gorn. With Blacklash and Hematus dead, he said, Blackrock Spire was next.", true)
fallback("Broken Alliances", "Badlands", "lethlor", "782,793",
    "Gorn in Kargath meant to silence Blacklash and Hematus, Deathwing's lieutenants imprisoned in Lethlor Ravine, for the Horde's honor.",
    "The Horde's old alliance with Deathwing had left two black drakes imprisoned in Lethlor, and Gorn wanted them dealt with.",
    "Gorn's campaign against the drakes of Lethlor went on.",
    "The work toward the prison in Lethlor Ravine moved forward.")
q(3481, "Trinkets...", "Searing Gorge", 50, "gorgefinds", 1,
    "A chest in the Searing Gorge appeared locked.",
    "The hoard of the black dragonflight lay in a chest that looked locked.",
    "At a touch the chest opened. There was only one way to find out how much cheese could possibly be in there.",
    "Open at a touch, the chest raised one question, how much cheese it could hold.")
q(7704, "Look at the Size of It!", "Searing Gorge", 50, "gorgefinds", 2,
    "The Chambermaid's gigantic ornate pillow had changed hands. Evonice Sootsmoker would want to get her grubby little hands all over it, and might offer goodies for the trouble.",
    "Chambermaid Pillaclencher's enormous pillow was the kind of thing Evonice Sootsmoker would pay for.",
    "The pillow went to Evonice Sootsmoker.",
    "The Chambermaid's pillow ended up in Evonice Sootsmoker's hands.")
q(77, "A Sticky Situation", "The Hinterlands", 48, "droffers", 2,
    "Gilveradin Sunchaser had original packaging for the ripple Dran Droffers sought. He would package it for Malton's abrasive father for a fee of two more bottles. They sat in crates in the abandoned Horde base near Skulk Rock. Foul slimes and oozes clung to the ruins, said to be led by a master ooze.",
    "Two extra bottles of ripple from the ooze-choked ruins near Skulk Rock were Gilveradin's price for packaging Dran Droffers' order.",
    "Finely executed, Gilveradin said, and he was glad the ripple had not been bruised. Nothing was worse than a jostled bouquet. No magic was involved, only empty packaging for Hinterlands Honey Ripple. The chicanery would turn the bottles into an alcoholic treasure of the ages.",
    "Gilveradin repackaged the bottles as Hinterlands Honey Ripple, no magic involved, and sent them onward for great booze.")
q(2877, "Skulk Rock Clean-up", "The Hinterlands", 48, "hinterlands", 2,
    "The Wildhammers remembered the past more than their brothers in Ironforge, Fraggar said, and friends got their hands dirty. Around Skulk Rock the Horde had abandoned its positions, now overrun with sludges and oozes. The Wildhammers had plans for the area once a clean-up crew made a hole.",
    "Fraggar wanted ten green sludges and ten jade oozes cleared from the old Horde positions at Skulk Rock. Move out, Sunshine, he said.",
    "Fraggar respected action, and said the clean-up mattered more than it might seem. With the oozes thinning out, the Wildhammers would extend their sphere of influence in no time. He added a little something to the new friendship.",
    "Skulk Rock's sludges and oozes were thinned, and Fraggar spoke of the Wildhammers' sphere of influence growing. He paid a little extra.")
-- END BAND 30-50 BATCH 2
-- B4: Alliance Feralas (Latronicus, Thalanaar, the Moonweavers, the sprite darter egg, Rockbiter and Shay, Angelas's referral, the two best yeti hides) and Roon's horn for Hemet
P.threads.world_feathermoon = "Feathermoon's war with the naga"
P.threads.world_moonweavers = "the Moonweavers and the Grimtotem"
P.threads.world_darteregg = "the sprite darter egg"
P.threads.world_shay = "Rockbiter and Shay"
q(4281, "Thalanaar Delivery", "Feralas", 44, "raschal", 2,
    "The parcel from the Woodpaw camps had been meant for the way-station of Thalanaar in southeastern Feralas. Whatever had become of the courier, the delivery was unfinished. A hand-written name on the packaging, Falfindel Waywarder, gave the likely recipient.",
    "The undelivered parcel bore the name Falfindel Waywarder, and Thalanaar lay in the southeast of Feralas.",
    "Falfindel praised Elune that the delivery from Feathermoon had arrived at last. He feared some ill fate had befallen Raschal, the usual courier. The Woodpaw had lately grown agitated by something to their south, he said, and he paid for the parcel.",
    "In Thalanaar, Falfindel Waywarder took the parcel and worried aloud about Raschal. The Woodpaw were agitated by something in the south, he said, and he advised care.")
q(2969, "Freedom for All Creatures", "Feralas", 47, "moonweavers", 3,
    "Kindal Moonweaver said the filthy Grimtotem were capturing faerie dragons, for what purpose she and Jer'kai could not tell. The two of them were not strong enough to fight into the camp. She gave a key to the cage and promised to stay close while the creatures escaped with their lives.",
    "The Grimtotem had caged faerie dragons in their camp. Kindal Moonweaver wanted them released with her key and seen safely out.",
    "Thanks went to Elune, and Kindal called the rescue a blessing to her and to the darters. She and Jer'kai could never have done it alone, she said, and the interference in Grimtotem affairs would be remembered. Free dragons need not stay free, Kindal warned, so she and Jer'kai meant to go on the offensive.",
    "Free went the darters, and Kindal said the rescue would be remembered. Now she and Jer'kai would take the fight to the Grimtotem.")
q(2970, "Doling Justice", "Feralas", 47, "moonweavers", 3,
    "Jer'kai and Kindal would take the fight to the Grimtotem, and Jer'kai welcomed help. They meant to pick off tauren from the camp below and the camps to the east. The Grimtotem would do everything in their power to take their heads, she warned. Now they would be coming for the one who had interfered too.",
    "Jer'kai Moonweaver asked for damage done to the Grimtotem camps by whatever tactics served, with Kindal's arrows alongside.",
    "Kindal had been right about the knack for this, Jer'kai said. A more seasoned adventurer than either of them had earned their thanks. The Grimtotem were far more hostile than most tauren, and she wondered whether their own kind frowned on them.",
    "For the blows against the Grimtotem, Jer'kai gave thanks, and she wondered aloud whether other tauren frowned on so hostile a clan.", true)
q(2972, "Doling Justice", "Feralas", 47, "moonweavers", 3,
    "Out in the wilderness the Moonweavers had little to give, so Jer'kai gave her signet ring. High Priestess Tyrande Whisperwind would be in the Temple of the Moon in Darnassus, she said. The ring would tell her the two of them were well, and credit whatever was told of Feralas.",
    "Jer'kai's signet ring was meant for Tyrande Whisperwind at the Temple of the Moon, as word that the Moonweavers in Feralas were well.",
    "Tyrande called it an amazing account, and was pleased that dragonkind and one of her own priestesses had both been helped. Jer'kai had been right to send its bearer, she said, and scouts bound for Feralas would carry the ring back to her.",
    "At the Temple of the Moon, Tyrande took Jer'kai's ring and promised that scouts heading for Feralas would return it. She asked her visitor to feel at home.", true)
fallback("Doling Justice", "Feralas", "moonweavers", "2970,2972",
    "Jer'kai and Kindal Moonweaver had taken up arms against the Grimtotem who caged faerie dragons in Feralas.",
    "The Moonweavers' fight with the Grimtotem of Feralas went on, and they had little to pay helpers with but thanks.",
    "The Moonweavers' campaign against the Grimtotem went forward.",
    "Jer'kai's part in the fight against the Grimtotem continued.")
q(3841, "An Orphan Looking For a Home", "Feralas", 47, "darteregg", 2,
    "Kindal was glad to see her helper back from Darnassus. The Moonweavers had made progress and even saved a nest of eggs, though the mother died before they reached her. Kindal offered one as a pet. Quentin at the race track in the Shimmering Flats would say more.",
    "A sprite darter egg from the nest the Moonweavers saved was on offer, for anyone willing to raise it. Quentin at the Shimmering Flats race track knew about such things.",
    "A sprite darter egg near maturation, Quentin judged, and in remarkably good condition. They were rarely seen in Feralas these days, he said, with poachers after them. He asked how it had been come by.",
    "Sprite darters were rarely seen in Feralas these days, Quentin said, with poachers after them. He wanted to know where the egg came from.")
q(3842, "A Short Incubation", "Thousand Needles", 47, "darteregg", 2,
    "Quentin found the Moonweavers most intriguing, and wished the darters could appreciate having those two look after them. Since the egg was a gift, its keeping was a responsibility for as long as one wished. He needed two elixirs of fortitude for a small spell to make sure it was healthy.",
    "Two elixirs of fortitude would let Quentin cast a protective spell on the egg and judge whether it would hatch healthy.",
    "The elixirs would do nicely, Quentin said. He would mix his components and see how well the egg would do.",
    "With the elixirs, Quentin had what he needed for his spell on the egg.")
q(3843, "The Newest Member of the Family", "The Hinterlands", 47, "darteregg", 3,
    "A magnificent specimen, Quentin called the egg. If it survived gestation it would be a healthy pet. He suggested one last step, a dwarf named Agnar Beastamer at Aerie Peak, a master animal handler. The fragile egg would not last long without proper care.",
    "Quentin sent the egg on to Agnar Beastamer at Aerie Peak for the final steps of incubation, and said to hurry.",
    "Agnar had not seen one of these in a dragon's age. A faerie dragon of the sprite darter variety, he judged, and if the little fella was to hatch strong, it would need food. It had reached him in time.",
    "Agnar Beastamer named the egg a sprite darter and said food came next. It had arrived in time.")
q(4297, "Food for Baby", "The Hinterlands", 47, "darteregg", 2,
    "Sprite darters were omnivores, Agnar said, and raw, juicy flanks of meat were good eating for the little ones. Why, he could not say, though it had something to do with Elune's plan for the elves. He would mind the egg while Silvermane stalker flanks were fetched, and admitted he was jealous of whoever had got it.",
    "Agnar wanted Silvermane stalker flanks ready for the hatchling, and kept the egg meanwhile.",
    "The flanks would do nicely, Agnar said, and the egg was just about ready to hatch. He laughed about the responsibility that was coming.",
    "Flanks in hand, Agnar said the egg was nearly ready, and joked about the responsibility ahead.")
q(4298, "Becoming a Parent", "The Hinterlands", 48, "darteregg", 3,
    "The egg was a lot more ready than Agnar had thought.",
    "The egg surprised Agnar by being readier than he expected.",
    "Back went the egg to its keeper, so that it would bond and look to that keeper as its dadda. Congratulations, Agnar said, a parent, kind of.",
    "A parent, kind of, Agnar said, and gave back the egg to bond with its keeper.")
q(2844, "The Giant Guardian", "Feralas", 49, "shay", 2,
    "Rockbiter said he was no good. He was supposed to be watching his little friend Shay. Somewhere in the ruins just north of his spot she had got away from him. Someone with faster legs, he asked, should go and look for her.",
    "Shay had wandered off from the giant Rockbiter in the ruins to the north, and he was awful worried.",
    "Glad to be found, Shay admitted she was a bit lost, and asked whether it was not a beautiful place.",
    "Found in the ruins, Shay confessed to being a little lost and admired the place anyway.")
q(2845, "Wandering Shay", "Feralas", 49, "shay", 3,
    "Shay wanted to find her way back to Rockbiter, who was supposed to be watching her. She did tend to wander, she said, with so much to see. One thing always got her attention, a precious bell kept in a chest, and she loved the sound of it. Ring it, and she would come running.",
    "Shay asked to be led home to Rockbiter. If she wandered, she gave her word, the precious bell from the chest would bring her back.",
    "Rockbiter marveled that the bell would work when Shay ran off, and gave a reward for all the help.",
    "Home came Shay to Rockbiter, who marveled at the bell and paid for the trouble.")
q(7735, "Pristine Yeti Hide", "Feralas", 48, "yetihides", 2,
    "A pristine yeti hide turned up, exceptionally thick and sturdy, more so than any from the yeti of Rage Scar. Pratt McGrubben at Feathermoon was in the market for hides, and this one might interest him considerably.",
    "One yeti hide stood out from all the Rage Scar hides, and Pratt McGrubben would want to see it.",
    "Incredible, Pratt said, the granddaddy of all yeti hides. He did not normally pay so much for one hide, but he could make something special from it.",
    "More than his usual price came from Pratt for the single hide, since he could make something special of it.")
q(7738, "Perfect Yeti Hide", "Feralas", 48, "yetihides", 2,
    "A yeti hide that might well be perfect turned up, exceptionally thick and sturdy, beyond anything from the yeti of Rage Scar. Jangdor Swiftstrider at Camp Mojache was in the market for hides.",
    "One hide outclassed every Rage Scar hide, and Jangdor Swiftstrider at Camp Mojache would want it.",
    "The finest yeti hide specimen he had ever seen, Jangdor called it, worthy of a proper bounty. He did not normally pay so much for one hide, but he could make something special from it.",
    "A bounty above his usual came from Jangdor for the single hide, since he could make something special of it.")
q(5763, "Hunting in Stranglethorn", "Stranglethorn Vale", 31, "nesingwary", 2,
    "Long ago a dwarf named Hemet had come to Desolace to hunt great beasts, Roon Wildmane said. His skill with the rifle was uncanny. The two had hunted together for many days with the enmity of their peoples forgotten. When Hemet left for Stranglethorn, Roon had vowed to welcome him back one day. Now a kodo horn went to him north of Grom'gol.",
    "Roon Wildmane's kodo horn was an invitation to Hemet Nesingwary, an old hunting companion from Desolace now camped north of Grom'gol.",
    "Hemet knew the horn for a tauren's, Roon Wildmane's, and remembered good times hunting the beasts of Desolace. He was neck deep in the jungle, he said, but his next expedition might take him back to the land of the centaurs.",
    "Hemet knew the kodo horn for Roon Wildmane's and recalled the hunts of Desolace. Perhaps his next expedition would go that way, he said.")
-- END BAND 30-50 BATCH 3
-- B5: Tanaris at forty-five (the Water Company, Zinge's kit, Stoley's rum, the wanted posters, Marvon, Tran'rek, Curgle, Tooga), the dungeon errands (Agmond's urns, the Garrett broom, Theradras, Belnistrasz and the Downs) and Azshara (the Haldarr, Eldarath, Belgrom's revenge)
P.threads.world_tanarisfield = "Zinge's field tests in Tanaris"
P.threads.world_hippogryphs = "Curgle's hippogryph eggs"
P.threads.world_tranrek = "Tran'rek's schemes"
P.threads.world_dunemaul = "the Dunemaul ogres of Tanaris"
P.threads.world_tooga = "Tooga's way home"
P.threads.world_belnistrasz = "Belnistrasz in Razorfen Downs"
P.threads.world_downs = "the Scourge pact in Razorfen Downs"
P.threads.world_eldarath = "the tablets of Eldarath"
q(243, "Into the Field", "Tanaris", 46, "tanarisfield", 2,
    "Apothecary Zinge sent the field work to the Tanaris desert, to test the tissue of its basilisks, scorpids and hyenas. The kit would reject a good share of the samples, so eight acceptable ones of each were wanted. It also needed a Gadgetzan power source from Chief Engineer Bilgewhizzle.",
    "Zinge's modified testing kit would not run without a goblin power source. Chief Engineer Bilgewhizzle in Gadgetzan had them.",
    "Bilgewhizzle knew the model 4711-FTZ power source well. They normally ran the water wells, but thanks to the vile nomads Gadgetzan had an overabundance. He would part with one for whatever nefarious experiment this was. Not for free, he said, since nothing in Gadgetzan was.",
    "A 4711-FTZ power source could be had, Bilgewhizzle said, but nothing in Gadgetzan was free.")
q(379, "Slake That Thirst", "Tanaris", 46, "tanarisfield", 2,
    "Bilgewhizzle's price for the 4711-FTZ was something to drink, five Wastewander water pouches. He suggested asking the nomads east of Gadgetzan nicely for them, and wanted to hear how that went.",
    "Five Wastewander water pouches would buy the power source from Bilgewhizzle.",
    "The power source changed hands with a warning. It was not designed for a science kit, Bilgewhizzle said. The data would go kablooey after two hours at most unless he shut it down properly. If the time ran out he would sell another one. Sell, he said.",
    "Bilgewhizzle handed over the 4711-FTZ and gave it two hours before the data in the kit went kablooey. He would shut it down properly in time, or sell another.")
q(654, "Tanaris Field Sampling", "Tanaris", 46, "tanarisfield", 3,
    "The power source made the field testing kit glow and vibrate, working as planned. By Bilgewhizzle's reckoning, two hours remained to collect the data in the Tanaris desert. After that it would be lost, and another power source would have to be bought.",
    "With the kit glowing, the clock ran on Zinge's samples. Bilgewhizzle was all about the Gadgetzan Water Company's profit, he said. He would sell power sources until the company could import water from the icy springs of Dun Morogh.",
    "A second was all Bilgewhizzle needed to remove the power source. The data inside was safe now, he said, to do with as one liked.",
    "With the power source out, Bilgewhizzle said, the data would keep.")
q(841, "Another Power Source?", "Tanaris", 46, "tanarisfield", 2,
    "Bilgewhizzle guessed the nefarious deed had not been done in time, or better still, that the kit had been dropped in the sand. He had more power sources to sell, at ten Wastewander water pouches this time. Times were tough, he said, and power sources did not grow on trees. Then he wondered whether they could make a power source tree.",
    "A second power source cost ten Wastewander water pouches, Bilgewhizzle said, and he mused about growing them on trees.",
    "Bilgewhizzle handed over another power source and highly recommended using it properly this time, unless ten more water pouches were on offer.",
    "Another power source came from Bilgewhizzle with advice to use it properly.")
q(1690, "Wastewander Justice", "Tanaris", 43, "water", 3,
    "The Wastewander nomads had seized almost all the water wells, Bilgewhizzle said. Without them the Gadgetzan Water Company's supply would dry up in no time. Anyone wanting its good graces could bring justice to ten Wastewander bandits and thieves east of town, on the double.",
    "Bilgewhizzle wanted ten Wastewander bandits and thieves brought down east of Gadgetzan. Justice waited for no man, or goblin.",
    "That was efficiency, Bilgewhizzle said. The nomads were thinned enough to start thinking about winning back the wells. Gadgetzan's Water Company gave thanks, though it was far from done with the nomads.",
    "With the nomads thinned, Bilgewhizzle began to think about the wells. The Water Company's thanks came with the next job.")
q(1691, "More Wastewander Justice", "Tanaris", 44, "water", 3,
    "The stronger ranks of the Wastewander came next, the rogues, assassins and shadow mages east and southeast of Gadgetzan. Bilgewhizzle would not lie about it. They were a nasty lot, but taking back the wells meant facing as few nomads as possible.",
    "Bilgewhizzle sent the fight against the Wastewander rogues, assassins and shadow mages, a nasty lot by his own account.",
    "Top notch, Bilgewhizzle said. The nomads were thinned to a point where Gadgetzan could take the fight to them. Spigot Operator Luglunket, he added, paid a bounty on any Wastewander water pouches picked up along the way.",
    "Top notch work, Bilgewhizzle called it, and he mentioned Luglunket's bounty on water pouches.")
q(1707, "Water Pouch Bounty", "Tanaris", 44, "water", 2,
    "Luglunket, a seasoned spigot operator, wanted any Wastewander water pouches found in the desert. It was Gadgetzan's water anyway, he said, only stolen, and the Water Company offered an official care package for every five. Huzzah, he added.",
    "The Gadgetzan Water Company paid a care package for every five Wastewander water pouches brought to Spigot Operator Luglunket.",
    "Every pouch reclaimed put them further from disaster, Luglunket said, and he would reward every five.",
    "Luglunket took the pouches and asked for more, five at a time.")
q(2781, "WANTED: Caliph Scorpidsting", "Tanaris", 46, "water", 4,
    "A poster offered a high bounty from the Gadgetzan Water Company for the head of Caliph Scorpidsting, leader of the Wastewander outlaws. His crimes were murdering the Company's employees, stealing its resources and seizing its property. Proof of his demise went to Chief Engineer Bilgewhizzle.",
    "The Gadgetzan Water Company wanted Caliph Scorpidsting dead, the Wastewander leader who had murdered its employees and seized its wells.",
    "Justice was served at last, Bilgewhizzle said, a mighty blow against the nomads. With Scorpidsting dead, the squatters might finally be pushed off Gadgetzan's water wells. By the authority of the Water Company he paid the bounty.",
    "Scorpidsting's head earned the Water Company's bounty from Bilgewhizzle, who hoped it would push the squatters off the wells.")
q(2872, "Stoley's Debt", "Tanaris", 45, "dues", 2,
    "Sea Wolf MacKinley's old buddy Stoley owed him a very special bottle of rum. Stoley tended bar at Steamwheedle Port in Tanaris and swore its rum was stronger than anything in Booty Bay. So sure was he that he would double the money he owed if MacKinley tried it and disagreed. Now MacKinley thought he had lost his nerve.",
    "MacKinley never backed down from a wager. At Steamwheedle Port, Stoley owed him a bottle of rum, and someone had to go and ask for it.",
    "Stoley knew what MacKinley thought, and it was not that. Handing over Steamwheedle bilge rum did not frighten him, he said. He simply had none to give.",
    "Stoley had not lost his nerve, only his rum.")
q(2873, "Stoley's Shipment", "Tanaris", 45, "dues", 2,
    "Stoley owed Sea Wolf MacKinley rum to settle a bet, and had none. Captain Cuergo had stolen his last shipment and stowed it in the walled pirate town to the south. With it back, he could prove Kalimdor's booze beat the dirt out of Booty Bay's.",
    "Stoley's rum sat in Captain Cuergo's walled pirate town south of Steamwheedle Port.",
    "Now he and MacKinley could finally settle their wager, Stoley said.",
    "The rum came home to Steamwheedle Port, and Stoley talked of settling with MacKinley.")
q(2874, "Deliver to MacKinley", "Stranglethorn Vale", 45, "dues", 2,
    "Stoley sent a bottle of Steamwheedle bilge rum to MacKinley, to put his crazy beliefs about Booty Bay booze to rest.",
    "A bottle of Steamwheedle bilge rum went across the sea to settle MacKinley's wager.",
    "MacKinley tried it and could not believe it. The stuff was terrible, thick as gravel and burning like lava, and that was great. Stoley could keep the money he owed, since he had been true to his word.",
    "Terrible, MacKinley called the bilge rum, and he meant it as praise. Stoley kept his money.")
q(2875, "WANTED: Andre Firebeard", "Tanaris", 45, "water", 3,
    "The pirate Andre Firebeard was wanted for crimes against Steamwheedle and Gadgetzan. By decree of the governing counsel, lethal force was authorized. Should Andre be deceased at his hearing, his head could act as proxy. Delivered to Security Chief Bilgewhizzle, it made a binding contract.",
    "A decree put a price on Andre Firebeard and allowed his head to stand in for him at trial.",
    "So Andre would make his trial after all, Security Chief Bilgewhizzle said. Payment for services rendered needed a signature. The small print was harmless, he promised, and too small for any magnifying glass anyway.",
    "The security chief of Steamwheedle Port paid for Andre Firebeard's head against a signature, and advised not worrying about the small print.")
q(2876, "Ship Schedules", "Tanaris", 45, "water", 2,
    "A scroll held the schedules of shipments between Steamwheedle Port and Booty Bay, past and future, with ship names. Large X marks stood next to some journeys, and notes like great loot and hard fight next to others. Someone at Steamwheedle Port would want it.",
    "A pirate's scroll of ship schedules between Steamwheedle Port and Booty Bay, annotated for loot, belonged in Steamwheedle hands.",
    "Security Chief Bilgewhizzle saw a list of departures and arrivals with accurate dates and times. Any pirate captain could have a field day with it. That it had come from a pirate was disturbing news, he said. He was glad the pirate was eating dirt.",
    "The schedules disturbed the security chief, who was glad the pirate who had carried them was dead.")
q(2954, "The Stone Watcher", "Tanaris", 50, "uldaman", 4,
    "A guardian of entry appeared at the pedestal in the Tanaris desert. Without the Plates of Uldum integrated into the disc set, it would not allow entry to the Uldum compound. The Stone Watcher of Norgannon was the reaction hoped for when the platinum discs were sent to Tanaris. Its history had to be learned before going on.",
    "The Stone Watcher of Norgannon answered the platinum discs at the Uldum pedestal and barred the way.",
    "With power and authority in its voice, the watcher said the discs would be returned once the pedestal was accessed. Once the Plates of Uldum were added to the set, the complex could be entered.",
    "Once the pedestal was used, the watcher said, the discs would come back. Entry waited on the Plates of Uldum.")
q(3022, "Handle With Care", "Tanaris", 47, "hippogryphs", 2,
    "Curgle Cranklehop could see dedication to the worthwhile cause, and had a crate of eggs for Erelas Ambersky. He was a druid who helped the eggs hatch and trained the young hippogryphs, in the small village of Rut'theran in southern Teldrassil.",
    "A crate of hippogryph eggs went from Curgle in Tanaris to the druid Erelas Ambersky at Rut'theran Village.",
    "Erelas gave thanks and said the hippogryph population would not flourish without them. Anyone who had traveled to Feralas and seen the Gordunni's devastation understood that, he said. He was hard at work, so it was best to be on the way.",
    "The eggs reached Erelas at Rut'theran, who spoke of the hippogryphs' survival and the devastation of Feralas.")
q(3362, "Thistleshrub Valley", "Tanaris", 50, "tranrek", 2,
    "Tran'rek did not trust the strange beasts of Thistleshrub Valley for a minute. Gnarled thistleshrubs and rootshapers, they were called, as far as Tran'rek could recall. Getting into the valley was the plan, but not with so many of them around. Clearing some out might bring a change of mind about going back.",
    "Thistleshrub Valley was a mighty dangerous place, Tran'rek said. Its thistleshrubs had to be thinned before any return there.",
    "They were that big, Tran'rek said, and the plan might need rethinking. The bargain had been kept, and so was the promise.",
    "Hearing how big the thistleshrubs were, Tran'rek reconsidered the plans for the valley and paid as promised.")
q(5863, "The Dunemaul Compound", "Tanaris", 49, "dunemaul", 3,
    "A large band of nomadic ogres had lately arrived in Tanaris, Andi Lynn said. They had built a compound in the desert to the south. Smaller bands wandered the desert, some in the old troll ruins. The compound had to be destroyed before they built up a force, beginning with their leader, Gor'marok the Ravager.",
    "Andi Lynn wanted the Dunemaul Compound broken and its leader, Gor'marok the Ravager, dead.",
    "Glad it was done, Andi Lynn gave her thanks.",
    "Gor'marok was dead, and Andi Lynn gave thanks for it.")
q(1560, "Tooga's Quest", "Tanaris", 50, "tooga", 2,
    "Tooga was so lost. His wife Torta had sent him out to fetch dinner and he had taken a wrong turn somewhere. He asked to be led back to her, south of Steamwheedle Port.",
    "Tooga could not find his way back to his wife Torta, who waited just south of Steamwheedle Port.",
    "So he could not find his way back on his own, Torta said. That figured, and the trouble deserved something.",
    "Torta took her husband back with a remark that it figured, and paid for the trouble.")
q(704, "Agmond's Fate", "Badlands", 38, "uldaman", 3,
    "Agmond's last report troubled Ironband more now that he was dead. His diggers had uncovered ancient urns at the dig site outside Uldaman. Ironband feared the urns had incited the troggs, as the idols he had found himself had done. He wanted the urns for the Prospectors' studies.",
    "Ironband wanted the ancient urns from Agmond's dig outside Uldaman, suspecting they had stirred the troggs as his own idols had.",
    "With luck and diligence, Ironband said, the Prospectors would find the link between the troggs and the ancient artifacts. The deed would not be forgotten, and neither would Agmond.",
    "Well done, said Ironband of the urns, and promised that neither the deed nor Agmond would be forgotten.")
q(2342, "Reclaimed Treasures", "Uldaman", 43, "uldaman", 2,
    "Sweeping the bat pens was not befitting a Garrett, the sweeper said. He would spend the little coin the job had earned him to better his station. The family's weapon of choice lay locked in a chest in the South Common Hall of Uldaman. Garretts had locked it there in the days they toiled in Uldaman as diggers.",
    "A Garrett reduced to sweeping bat pens wanted his family's weapon back from a chest in Uldaman's South Common Hall.",
    "At last he had a broom worthy of a Garrett. He declared the help worth every silver, and told the bats to tremble before the family weapon of choice.",
    "Its heir told the bats to tremble before the Garrett family weapon, which turned out to be a broom.", true)
q(7065, "Corruption of Earth and Seed", "Maraudon", 51, "maraudon", 4,
    "In the depths of Maraudon lived a creature of chaos, the Keeper said. Princess Theradras was an elemental force of earth tied somehow to the Old Gods. Long ago Zaetar, first son of Cenarius, had sought her out, and the centaur were the offspring of that union. Ever thankful, they had killed Zaetar, and Theradras kept his remains. The Keeper sought those powerful enough to slay her and bring the remains back before his return to Stonetalon.",
    "Princess Theradras held the remains of Zaetar, Cenarius's first son and father of the centaur, in the depths of Maraudon. The Keeper wanted her slain and the remains recovered.",
    "Most wonderful news, the Keeper said. That Zaetar's remains had not come back concerned him, but who was he to question the will of Cenarius's first born. Perhaps now the centaur's will would break and their thirst for blood lessen. He offered a token from the items given for those who aided the mission.",
    "Theradras was dead, and the Keeper gave a token of thanks. Zaetar's remains had stayed below, which he took as the will of Cenarius's son.", true)
q(3523, "Scourge of the Downs", "Razorfen Downs", 37, "belnistrasz", 3,
    "Belnistrasz gave his name and his thanks for the rescue. He had given himself up for dead, or for a meal, among vermin he called Scourge-infested. The Scourge had brokered some deal with the quilboar, he said. Rather than flee he wanted to make a difference. He asked for his oathstone back as a sign of commitment, a bond among his kind.",
    "Rescued in Razorfen Downs, Belnistrasz asked for a commitment sealed with an oathstone, as his kind did. Only then would the fight against the Scourge's bargain with the quilboar begin.",
    "Belnistrasz had thought his rescuer the heroic type. Their work was cut out for them, he said, but staying focused they should come out on top. Then he began to explain what had been going on.",
    "The oathstone sealed it, and Belnistrasz began to bring his new ally up to speed.")
q(3525, "Extinguishing the Idol", "Razorfen Downs", 37, "belnistrasz", 5,
    "Near the entrance stood an idol that served the quilboar as a macabre oven, Belnistrasz said. In it they consumed the abductees they took from the Barrens. He could shut it down and bind them from using it again. During the ritual, though, he could barely speak or defend himself. If they took him down, it was over.",
    "Belnistrasz needed an escort to the idol and protection while he worked the ritual to shut it down.",
    "Then Belnistrasz departed suddenly and left a burning brazier. In its flame the image of a great-winged red dragon appeared. A more graveled version of his voice spoke from it. These were the heroes he had hoped for, it said, and the beasts' butchery was a thing of the past. With it came a reward befitting a hero.",
    "The idol was shut down, and Belnistrasz was gone. From the brazier he left, a red dragon's image and voice named the deed heroic and gave a reward.")
q(3636, "Bring the Light", "Razorfen Downs", 42, "downs", 4,
    "The Scourge was a persistent threat to the Alliance, and a peculiar finding had come from the Barrens. Razorfen Downs had once been home to simple quilboar. A pact with the Scourge had bred far worse creatures, ruled now by the lich Amnennar the Coldbringer. The Light's servant asked for an end to the evil union.",
    "Amnennar the Coldbringer, a lich, ruled Razorfen Downs through a pact with the quilboar. The servant of the Light who sent word asked that it be ended.",
    "Now the Scourge would think twice before bolstering its ranks that way again, the Light's servant said. He gave the Light's blessing.",
    "Amnennar was destroyed, and the Scourge would think twice. A blessing of the Light went with the thanks.")
q(6521, "An Unholy Alliance", "Razorfen Downs", 36, "downs", 4,
    "Malcin claimed to be outside Razorfen Downs, Varimathras said. The ambassador had to be slain, his mission a failure in the Lich King's eyes. His presence explained the quilboar grown frightfully powerful and showing the Plague in their own way, the sign of a deal. The Scourge could not be allowed a foothold on Kalimdor. Only one sign gave hope, that the crone had seemed uncorrupted.",
    "Varimathras wanted Ambassador Malcin slain outside Razorfen Downs, so the Scourge's advances on Kalimdor would halt.",
    "With Malcin dead, Varimathras said, the Scourge's advances would at least be halted. The Dark Lady gave thanks and a gift. How far the Scourge's influence in the Downs reached was unknown, but their plots would be discovered soon enough.",
    "Malcin was dead, and Varimathras passed on the Dark Lady's thanks and a gift. The Scourge's plots in the Downs, he said, would come to light soon enough.", true)
q(5536, "A Land Filled with Hatred", "Azshara", 47, "azshara", 3,
    "A tauren in Azshara had sworn an oath to the Earthmother to help the elves rid the land of the satyr. Those disfigured, evil aspects of the night elves now infected the sacred lands Cenarius once walked. Northeast of the tauren lived the Haldarr clan, a test of strength.",
    "A tauren in Azshara, sworn to the Earthmother, sent the fight against the Haldarr satyr to the northeast.",
    "The tauren called the work skilled and cunning, a testament to loyalty to the Earthmother's tenets, whether or not one recognized her. She was in all things, he said, her eyes, one dark and one light, crossing the skies. He gave a small amount of coin.",
    "Once the Haldarr were beaten, the tauren spoke of the Earthmother's two eyes crossing the skies, and paid a little coin.")
q(3517, "Stealing Knowledge", "Azshara", 52, "eldarath", 2,
    "Belgrom's punishment had had its benefits, the exile admitted. Azshara held more valuable things lying around than anyone would guess. Four tablets in the Ruins of Eldarath to the east were wanted, each named after a Highborne wizard. A cut of the profits was promised.",
    "Four Highborne tablets from the Ruins of Eldarath would earn a cut of an exile's deals in Azshara.",
    "Perfect, the exile said, and in good condition. They would fetch a good price from all parties concerned, and there was money to make.",
    "The tablets of Eldarath went to the exile for sale, in good condition, and talk turned to money.")
P.threads.world_belgrom = "Belgrom's revenge on Magus Rimtori"
q(3505, "Betrayed", "Azshara", 53, "belgrom", 3,
    "Ag'tor Bloodfist had thought as much. The crusade against Magus Rimtori's workers began along the southern bluffs of Azshara's northern peninsula. They were to be killed with bloody rage, so they knew they had betrayed the wrong allies. Rimtori herself spent her time searching Azshara with her bodyguards. Her personal camp was to be scouted for something to provoke her.",
    "Ag'tor Bloodfist at Valormok wanted Rimtori's blood elf workers on the northern peninsula killed first, then a look at her camp.",
    "At the camp lay writings in an ancient script, Kaldorei perhaps. One leaf was marked with a thin strip of black silk. A diagram at its foot matched the crystals, the circle and the components laid out on the ground.",
    "A marked leaf at Rimtori's camp held a diagram, and the crystals and circle on the ground were set out just like it.", true)
q(3507, "Betrayed", "Azshara", 56, "belgrom", 4,
    "Ag'tor called it a good day and sent the head to Belgrom in Orgrimmar, who would want to see it for himself.",
    "Rimtori's head went to Belgrom Rockmaul in Orgrimmar, with Ag'tor's thanks.",
    "Belgrom spat on the remains and called the dead blood elf a pathetic woman. He would give a kingdom if it were in his power, he said, and offered a reward instead. Then he mocked the head in its burlap sack for betraying him.",
    "Belgrom Rockmaul gloated over Rimtori's head in its burlap sack, thanked his helper from the bottom of his heart, and paid.", true)
fallback("Betrayed", "Azshara", "belgrom", "3505,3507",
    "Belgrom Rockmaul's revenge on the blood elf Magus Rimtori, who had betrayed him, ran through Ag'tor Bloodfist's camp at Valormok in Azshara.",
    "Ag'tor and Belgrom wanted Magus Rimtori punished for her betrayal in Azshara.",
    "The campaign against Magus Rimtori went on.",
    "Belgrom's revenge on Rimtori moved a step forward.")
-- Conservative fallbacks for the titles above that the corpus repeats.
fallback("The Captain's Chest", "Stranglethorn Vale", "smotts", "8551",
    "Captain Hecklebury Smotts of Booty Bay wanted his chest back from the sea giants who had wrecked him.",
    "The sea giant Gorlash had taken Smotts's captain's chest for a snuffbox.",
    "Smotts's revenge on the sea giants went on.",
    "The captain's affairs with the sea giants moved a step along.")
fallback("The Monogrammed Sash", "Stranglethorn Vale", "smotts", "8552",
    "A sash marked HS pointed to Captain Hecklebury Smotts in Booty Bay.",
    "Captain Smotts had lost more than one ship to the sea giants.",
    "Captain Smotts's reckoning with the sea giants went on.",
    "The sash found its way toward the captain who had lost it.")
fallback("The Captain's Cutlass", "Stranglethorn Vale", "smotts", "8553",
    "Captain Smotts wanted his cutlass back from the sea giant Negolash.",
    "Smotts' Revenge had gone down to the giants, and Negolash had taken the captain's cutlass.",
    "The hunt for the captain's cutlass went on.",
    "Smotts's revenge on Negolash moved forward.")
fallback("Facing Negolash", "Stranglethorn Vale", "smotts", "618",
    "Sprogger, the cook who survived Smotts' Revenge, knew how to lure the giant Negolash.",
    "Negolash, the hungry giant, had a taste for wine and barbecued buzzard wings.",
    "The plan against Negolash went forward.",
    "Sprogger's lure for the giant played its part.")
fallback("Foul Magics", "Arathi Highlands", "hammerfall", "673",
    "Tor'gan at Hammerfall feared a warlock in Stromgarde who summoned demons through a relic.",
    "A warlock's relic in Stromgarde troubled the shaman Tor'gan.",
    "Tor'gan's concern with the warlock of Stromgarde went on.",
    "The matter of the warlock's relic moved a step forward.")
fallback("Call to Arms", "Arathi Highlands", "hammerfall", "679",
    "Drum Fel at Hammerfall meant to end the Boulderfist attacks with a blow at their leaders in Stromgarde's ruins.",
    "Hammerfall's fight with the Boulderfist ogres went to the ruins of Stromgarde.",
    "Drum Fel's campaign against the Boulderfist went on.",
    "The fight for Hammerfall against the ogres moved forward.")
fallback("Reclaimed Treasures", "Uldaman", "uldaman", "2342",
    "A Garrett who swept bat pens wanted his family's treasure back from a chest in Uldaman.",
    "The Garretts had dug in Uldaman once, and left a chest behind in its South Common Hall.",
    "The Garrett family's claim on Uldaman went on.",
    "The search for the Garrett treasure in Uldaman moved forward.")
fallback("Corruption of Earth and Seed", "Maraudon", "maraudon", "7065",
    "Princess Theradras, an elemental force of earth in the depths of Maraudon, kept the remains of Zaetar, first son of Cenarius.",
    "A Keeper in Desolace sought those strong enough to face Princess Theradras.",
    "The effort against Theradras in Maraudon went on.",
    "The Keeper's mission in Maraudon moved a step forward.")
fallback("An Unholy Alliance", "Razorfen Downs", "downs", "6521",
    "The quilboar of Razorfen Downs had struck a deal with the Scourge, and an ambassador named Malcin had been seen outside.",
    "Varimathras in the Undercity would not allow the Scourge a foothold on Kalimdor through Razorfen Downs.",
    "The matter of the Scourge's ambassador at Razorfen Downs went on.",
    "Varimathras's business with the Downs moved a step forward.")
-- END BAND 30-50 BATCH 4



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
    "An agent of Krasus was dealing with the danger around Lethlor Ravine.", "The Kirin Tor wanted the trouble in Lethlor Ravine put to an end.",
    "Krasus's agent had help with the danger at Lethlor Ravine.", "The work for Krasus's agent advanced another step.")
fallback("The Ogres of Feralas", "Feralas", "gordunni", "2975,2980",
    "The Gordunni ogres were scarring the land of Feralas as they spread.", "Camp Mojache wanted the ogres' expansion checked.",
    "The Gordunni ogres in Feralas had fewer warriors after the fighting.", "Camp Mojache's fight against the Gordunni went on.")
fallback("The Torch of Retribution", "Searing Gorge", "retribution", "3453,3454",
    "The gathered pieces were to be combined and enchanted into a single torch.", "The torch still needed its final enchantments before it could be used.",
    "The Torch of Retribution came closer to being ready.", "The work on the enchanted torch moved another step along.")
fallback("Timbermaw Ally", "Felwood", "timbermaw", "6131,8460",
    "The Timbermaw mistrusted outsiders who failed to distinguish them from corrupted tribes.", "Help against the Deadwood offered a way to earn the Timbermaw's confidence.",
    "The Timbermaw had one more reason to trust an outsider.", "Help given against the Deadwood counted with the Timbermaw.")
fallback("The Name of the Beast", "Azshara", "defiler", "3509,3510,3511",
    "A weapon against the demon lord could only harm him if it bore his true name.", "Loramus needed the demon's true name, and Lord Arkkoroc in Azshara would give it for a price.",
    "Loramus's plan to forge a weapon against the demon lord moved forward.", "Loramus's plan to strike at the demon lord moved on.")
fallback("It's a Secret to Everybody", false, "linken", "3844,3845,3908",
    "A ruined raft on the shore of a small pond opened a mystery in Un'Goro.", "Belongings found in a pond in Un'Goro held clues about their owner.",
    "The traveler's lost belongings yielded one more clue.", "The matter of the lost pack and its owner moved one step further.")
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
    "A victory in the Ashenvale Hunt, Senani called it, and Shadumbra's head a fitting trophy for such a fight.",
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
    "How happy the little woodland nymphs would be, said Jin'Zil; his special concoction would make them feel right at home.",
    "Jin'Zil had everything for his special concoction, and promised his caged nymphs would feel right at home.")
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
    "Wonderful, said Krueg; there were enough wings for Korrin's cloak and possibly more. He gave his thanks and hoped Feralas had not made the errand too dangerous.",
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
    "Morbent Fel was defeated. The dark riders were still at large, Sven said, but a small piece of what he had hoped beyond hope had come to pass.")
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
    "Barnil Stonepot pointed out Hemet Nesingwary, the Alliance war hero who now hunted Stranglethorn's great beasts. He thought a fellow adventurer might find a welcome despite the dwarf's dislike of strangers.",
    "Barnil Stonepot spoke warmly of Hemet Nesingwary, the veteran Alliance hero and big-game hunter at his expedition's camp. He suggested approaching the dwarf for advice on hunting in Stranglethorn.",
    "Hemet offered a place in the great hunt to anyone who passed three tests, hunting raptors with him, tigers with Ajeck and panthers with Sir Erlgadin.",
    "The welcome came with a challenge. Hemet would judge the raptor hunt, Ajeck the tigers, and Sir Erlgadin the panthers before the expedition shared its greater quarry.", true)
P.questIDs[583].threadLabel = P.threads.world_nesingwary
P.questIDs[583].source[2] = "https://classicdb.ch/?quest=583"

P.threads.world_yenniku = "the Darkspear's lost son"
q(581, "Hunt for Yenniku", "Stranglethorn Vale", 34, "yenniku", 4,
    "Nimboya had come from Orgrimmar to find Yenniku, the Darkspear chief's missing youngest son. He suspected the Bloodscalps held him and called for a hunt among the trolls to the north.",
    "By Darkspear custom, the chief's youngest son Yenniku had been given to the Gurubashi of Zul'Gurub. He was lost to his people after they left with Thrall, and Nimboya now suspected the Bloodscalps held him.",
    "Good tusks, Nimboya said. They proved the strength to hunt the Bloodscalps, and the search for Yenniku could go on.",
    "Nimboya accepted the tusks taken from the Bloodscalps. The trophies convinced him that the hunt could go further.", true)
P.questIDs[581].threadLabel = P.threads.world_yenniku
P.questIDs[581].source[2] = "https://classicdb.ch/?quest=581"

P.threads.world_yenniku = "the Darkspear's lost son"
q(582, "Headhunting", "Stranglethorn Vale", 37, "yenniku", 4,
    "Nimboya feared that Yenniku, the Darkspear chief's missing son, might already be dead. He wanted the shrunken heads carried by Bloodscalp Headhunters at Zuuldaia and Zul'Kunda, to see whether the boy's was among them.",
    "The search for Yenniku turned to the Bloodscalp Headhunters' trophies. Nimboya wished a six-hundred-year curse on their chief Gan'zulah's spirit if they had killed the Darkspear chief's son.",
    "Nimboya gave his thanks and said he would inspect each shrunken head, to be sure poor Yenniku had been spared the axe.",
    "The headhunters' grisly trophies went to Nimboya, who said he would examine them for any sign of Yenniku.", true)
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
    "Very good, said Kin'weelay of the necklaces. He would boil and leech them to paste, and their owners' spirits, he claimed, would weaken with them.",
    "Kin'weelay accepted the bloody necklaces and described how he would render them to paste to weaken their owners' spirits. He repaid the help with a gift.", true)
P.questIDs[596].threadLabel = P.threads.world_darkspear_trophies
P.questIDs[596].source[2] = "https://classicdb.ch/?quest=596"

P.threads.world_dalaran = "Magus Wordeen's Dalaran inquiry"
q(544, "Prison Break In", "Alterac Mountains", 34, "dalaran", 4,
    "Four Forsaken had fled the Undercity with bloodstone artifacts stolen from a secure vault. Magus Wordeen wanted the apothecaries' property recovered from Lordamere Internment Camp, where Dalaran's wizards had quarantined the fugitives.",
    "Magus Wordeen's research at Tarren Mill had been interrupted by a theft from Sylvanas's vault. Four Forsaken had carried the apothecaries' bloodstones to Dalaran and ended up confined in Lordamere Internment Camp.",
    "All four bloodstones returned to Wordeen. He welcomed back the sorely missed artifacts and called the punishment of Kegan and the other fugitives justice.",
    "Wedge, marble, shard and oval came back to Wordeen, who called it a great service to the Forsaken. The artifacts had been sorely missed, he said, and he praised the news that Kegan and the other betrayers had met justice.", true)
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
    "From the watcher's history, dwarves and troggs both traced back to the earthen. With the account heard, the discs were ready to produce a portable copy.",
    "A faint hum from the discs ended the history of earthen, troggs and dwarves. The watcher announced that a portable copy was ready to be made.", true)

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
P.questIDs[1058].highlight = {"Jin'Zil had his forest ingredients for the brew, and promised the three elves in his cages would feel right at home.", "With sap, eyes, whiskers and a fey dragon's scale delivered, Jin'Zil gleefully promised a special brew for his three captive elves."}
P.questIDs[1483].highlight = {"Ziz Fizziks had traded the Venture Company for Sputtervalve's Union. He complained about his new employer, but still preferred him to the gnome Gerenzo.", "At Windshear, Ziz Fizziks complained of Sputtervalve's cruelty. Even that was better, he thought, than working beside Gerenzo at the Venture Company."}
P.questIDs[1093].highlight = {"Ziz had the stolen Super Reaper plans for Sputtervalve, and Gerenzo's gnomish engineering baffled him at once.", "Ziz's eagerness to impress Sputtervalve with the Super Reaper blueprints soon turned to grumbling about gnomish designs."}
P.questIDs[5542].highlight = {"The plaguehounds were dealt with, and Tirion offered rest, a meal and talk of days long past.", "With the plaguehounds thinned, there was a place at Tirion's table and talk of days long past."}
P.questIDs[5543].highlight = {"Tirion called the plaguebat hunt a shining example of decency and said it had lifted him.", "The plaguebats were dead. It was long since Tirion had felt the blood of heroes in his veins, he said."}
P.questIDs[5544].highlight = {"Several hundred pounds of carrion-worm meat went into Tirion's stores for the winter, with his blessing.", "Tirion's winter larder was filled with carrion worm, the one meat the Plague had left alone."}
P.questIDs[5241].highlight = {"Pamela sent word that she was waiting for Carlin's story about rabbits and berry jam. Learning of her death, he wished he could take her place.", "Pamela wanted to hear about the rabbits and berry jam from her uncle again. Carlin grieved for her lingering spirit and wished himself in her place at Darrowshire."}
P.questIDs[5211].highlight = {"Some of Darrowshire's defenders were free of the Scourge, and Carlin said his heart would weep a little less.", "Carlin heard that the ghouls and flayers who had been his brethren were free of the Scourge at last."}
P.questIDs[588].highlight = {"Nezzliok named Zanzil as Yenniku's captor. Kin'weelay feared the witchdoctor's power, but held to a tiny hope of saving the boy.", "The cauldron's answer pointed to Zanzil's hold over Yenniku. To Kin'weelay, the hope of breaking it was faint, but still hope."}
P.questIDs[589].highlight = {"The basilisk shards for Yenniku's rescue reached Kin'weelay. He heard them sing and had learned where the Mind's Eye lay, and who guarded it.", "Kin'weelay welcomed the blue shards for the Mind's Eye ritual. The jungle spirits had meanwhile revealed the jewel's hiding place and guardian."}
P.questIDs[592].highlight = {"The Soul Gem reached Nimboya with Yenniku freed from Zanzil's will. Nimboya had thought the mission desperate, and it was done.", "Nimboya received the Soul Gem and confirmed Yenniku's freedom from Zanzil. He promised that the tribe would remember the rescue and etch it in stone."}
P.questIDs[652].highlight = {"Taken from the stone watcher Fozruk, the Rod of Order went into the Keystone that held Myzrael. The ground shuddered beneath it.", "Fozruk's Rod of Order, the key Myzrael sought, was placed in the Keystone. A shudder passed through the earth."}
P.questIDs[688].highlight = {"Myzrael sent word to Zaruk in Hammerfall. He welcomed the visit and was ready to discuss summoning her to the surface.", "In Hammerfall, Zaruk already knew of the visit from the Lady, and the talk turned to bringing Myzrael to the surface."}
P.questIDs[642].highlight = {"Motes taken from the Drywhiskers awakened Myzrael's crystal shards. The imprisoned voice welcomed their strength, still pleading for freedom.", "Myzrael spoke through the newly powered Drywhisker shards. The motes had strengthened her, she said, though freedom was still distant."}
P.questIDs[651].highlight = {"The Stones of Binding opened. Through them Myzrael announced that her shackles were loosening, and thanked her rescuer.", "Opening Arathi's binding stones brought Myzrael's grateful voice through the stone. She could feel her restraints loosen."}
P.questIDs[656].highlight = {"Myzrael was defeated and bound again with her Eldritch Shackles. A wail rose from below, and the once-comforting shards pulsed with menace.", "The summoning ended with Myzrael defeated and shackled beneath Arathi again. Her shards answered with a roar from below and open menace."}
P.questIDs[7044].highlight = {"Vyletongue's and Noxxion's stolen scepter pieces reached Celebras. Newly awake from his nightmare, he could hope for Maraudon's cleansing.", "The two scepter pieces were recovered for Celebras. Waking from corruption's nightmare, he saw a chance that Maraudon might one day be healed."}
P.questIDs[4285].highlight = {"There was a pylon in the north of the crater, just as people had told J.D. Collie. She had her proof that the stories were true.", "The northern pylon stood where the rumors had put it, and J.D. took it as proof that believing people had not made her gullible."}
P.questIDs[4287].highlight = {"The eastern pylon was there, lined with crystal. J.D. called Un'Goro a different world from the moment anyone entered the crater.", "Word of the eastern pylon reached J.D., who said the crater felt like another world entirely."}
P.questIDs[4288].highlight = {"The western pylon was found, the last of the three J.D. had heard of, and she spoke of the winding paths along the crater walls where so much stayed hidden.", "Three pylons were now accounted for, and J.D. talked of the hidden places along the crater's sides."}
P.questIDs[4492].highlight = {"Spraggle's friend Ringo was found at the volcano south of the refuge, dazed and glad that anyone had come.", "The search ended at the volcano, where Ringo could manage little more than relief that someone had found him."}
P.questIDs[4491].highlight = {"Ringo reached Marshal's Refuge in one piece, if not in the best shape, and Spraggle was glad to have him back.", "Spraggle had Ringo back at the refuge, worse for the heat but whole."}
P.questIDs[1195].highlight = {"Moonwell water was collected for the Galak relic expedition. The filled phial was ready to carry to Rau in Thousand Needles.", "The filled moonwell phial was prepared for Rau, who had requested it for the search for a Galak centaur relic."}
P.questIDs[1196].highlight = {"At Freewind Post, Rau explained how moonwell water, through the dryads' kinship with centaurs, could breach the flame around the relic.", "Rau called the phial perfect for the purpose. Moonwell water could pierce the relic's eternal flame, he said, through the shared ancestry of dryads and centaurs."}
P.questIDs[7761].highlight = {"Blackhand's letter named the orb's safeguard. Drakkisath's brand left its mark on the hand, the sign the orb demanded before it would carry anyone into Blackwing.", "The Mark of Drakkisath, which Blackhand's captured letter said the orb required, was burned into its bearer's hand."}
P.questIDs[4788].highlight = {"The last Mosh'aru tablets came out of Blackrock Spire, and Yeh'kinya said a hero would be needed for what was coming.", "The fifth and sixth tablets reached Yeh'kinya, whose reading of the earlier pair had already warned him of what was coming."}
P.questIDs[7848].highlight = {"With a core fragment from Blackrock Depths, the keeper of the rift completed the attunement and offered passage into the Molten Core.", "The core fragment bought attunement to the hidden tear at Blackrock Mountain, and its keeper could now send the traveler into the Molten Core."}
P.questIDs[583].highlight = {"At Nesingwary's camp, Hemet set three trials before the great hunt, raptors under his own eye, tigers under Ajeck and panthers under Sir Erlgadin.", "Barnil's introduction led to Hemet's hunting challenge, three hunts with three different hunters."}
P.questIDs[581].highlight = {"Nimboya sought Yenniku, the Darkspear chief's son once given to the Gurubashi. Bloodscalp tusks convinced him the hunt for the missing boy could go further.", "Nimboya was hunting for Yenniku, the Darkspear chief's missing son. Good tusks, he said of the Bloodscalp trophies; they proved the strength to hunt further."}
P.questIDs[582].highlight = {"Nimboya meant to inspect every Bloodscalp shrunken head, to be sure none was poor Yenniku's.", "Nimboya took the headhunters' trophies and prepared to look for Yenniku among them, hoping the boy had escaped their axes."}
P.questIDs[584].highlight = {"Seeking Yenniku's fate, Nimboya called for Gan'zulah and Nezzliok's heads. Both were placed in the green broth of his cauldron, ready for questioning.", "Gan'zulah's and Nezzliok's severed heads lay in the bubbling cauldron. Nimboya intended to question them about Yenniku."}
P.questIDs[596].highlight = {"Kin'weelay accepted Bloodscalp bone necklaces, planning to render them into paste. He claimed this would weaken their owners' spirits.", "Kin'weelay meant to boil the Bloodscalp necklaces into paste, a rite he claimed would weaken their owners' spirits."}
P.questIDs[2978].highlight = {"A soiled Gordunni scroll seemed to show a meeting or ceremony. Rok Orhan asked at once whether it came from the Gordunni Outpost.", "Rok Orhan studied the Gordunni scroll, whose markings might show a ceremony. His first question was whether it had come from the outpost."}
P.questIDs[89].highlight = {"With Lakeshire's iron spent on arms and a replacement caravan stolen, Oslow welcomed pikes and rivets for Everstill Bridge. He expected to shore up the crossing soon.", "War and a stolen shipment had emptied Lakeshire's stores, and Oslow's bridge was short of supplies. With the pikes and rivets, he said, it would be shored up in no time."}
P.questIDs[205].highlight = {"Brother Nimetz took the Skullsplitter fetishes, hoping their magic might explain Kurzen's descent into evil.", "Brother Nimetz received the troll fetishes for study, seeking an answer to Kurzen's downfall in Skullsplitter magic."}
P.questIDs[494].highlight = {"In Tarren Mill, Darthalia read Lesh's raven message as the signal to strike Hillsbrad, and expected Varimathras to be pleased.", "Darthalia understood the cryptic word from Lesh's reconnaissance. Hillsbrad was ready for attack. She thought Varimathras would be pleased."}
P.questIDs[5093].highlight = {"Gorlach's call against the Scourge led to Derrington at the Bulwark. He welcomed the response and warned of the dangerous frontier beyond.", "Derrington welcomed the answer to Gorlach's summons at the Bulwark, with the Scourge to the east and work waiting along the frontier."}
P.questIDs[5096].highlight = {"The Scarlet command tent was burned and a Scourge banner planted beside it. Derrington had sent a scout to watch the response and judged Andorhal worth the risk.", "Derrington's false-flag raid left a burned Scarlet tent and a Scourge banner. He sent a scout to see whether the deception worked, while considering Andorhal."}
P.questIDs[574].highlight = {"Kurzen's elite fell in the strike Sergeant Yohwa had sent, and Doren found hope for the rebels. He had feared they stood alone against the Colonel's brilliance.", "Kurzen's commandos and headshrinkers were defeated in the Stockpile. Doren took hope from the report, trusting Yohwa's judgment of the help she had found."}
P.questIDs[202].highlight = {"Kurzen and his leaders fell in the Stockpile. Doren welcomed proof that the rebels were free of the commander whose cunning he had feared.", "Doren had the proof he had scarcely dared believe. Kurzen and his leaders were defeated, and the rebels, he said, could breathe more easily."}
P.questIDs[207].highlight = {"Four troll tablets were transcribed for Nimetz, who hoped their old writings might explain how the once-noble Kurzen had fallen into evil.", "Nimetz had transcriptions from four tablets in Stranglethorn's ruins to study. He suspected troll magic behind Kurzen's downfall."}
P.questIDs[206].highlight = {"Mai'Zoth was slain and the Mind's Eye reached Nimetz. He would study whether it could serve good; if not, he meant to destroy it.", "Nimetz received the Mind's Eye after Mai'Zoth's defeat. He believed the ogre had corrupted Kurzen and would judge whether the artifact must be destroyed."}
P.questIDs[1068].highlight = {"The shredders XT:4 and XT:9 were destroyed. The shaman reported relief among Stonetalon's tree spirits and hoped the Venture Company would withdraw.", "Stopping XT:4 and XT:9 soothed many tree spirits, the shaman said. He hoped the machines' destruction would drive the Venture Company from the mountains."}
P.questIDs[5228].highlight = {"At Derrington's direction, Vandis explained a plan to turn the four western plague cauldrons against the Scourge by changing their poison.", "Vandis outlined the cauldron plan at the Bulwark, to gain access to the four western devices and make their plague harm the Scourge."}
P.questIDs[5229].highlight = {"Bilemaw's key opened the Felstone cauldron and vanished. Foul fumes rose from the mixture inside; its spigot offered a place to draw the sample Vandis needed.", "The Felstone cauldron opened with Bilemaw's key, releasing a foul smell. A spigot made its poisonous mixture accessible for Vandis's sample."}
P.questIDs[5230].highlight = {"The Felstone sample reached Vandis at the Bulwark. Dithers could now study it for a counteragent, though Vandis warned the cauldrons would need repeated treatment.", "Vandis received Felstone's poison for Dithers to analyze. She hoped sustained treatment of the cauldrons could weaken the Scourge before battle."}
P.questIDs[1026].highlight = {"The hidden chest near Felwood yielded Dartol's iron shaft. Shael'dryn welcomed its recovery and wished she could do more for the corrupted treants.", "A corrupted treant's key opened the chest holding the rod's iron shaft. Shael'dryn welcomed the find, still troubled by the treants' fate."}
P.questIDs[1027].highlight = {"With the iron pommel, the last of the rod's pieces, Shael'dryn could see about repairing it. Wonderful news for Raene, she called it.", "The search among Dor'danil's slain druids recovered the iron pommel. Shael'dryn called it wonderful news for Raene and offered to help repair the rod."}
P.questIDs[1029].highlight = {"Raene heard that Dartol's rod was whole again and said Teronis would be proud that his work had gone on after him.", "Raene welcomed word that Dartol's rod was restored. She thought Teronis would be proud to see his search carried on."}

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
    "Moira called the slain emperor her husband and said their unborn child would rule Ironforge. She swore the killers would be hunted, and said Thrall would want to hear of his meddling.",
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
    "Fizzledowser wanted his insect report read by Zilzibin Drumlore, a troll historian who had long studied creatures unique to Azeroth. Zil lived on the second tier of the Drag in Orgrimmar.",
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
    "A historian recognized the creatures in the report as the silithid, tools of a great threat.")
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
    "Pestlezugg allowed that Un'Goro might be the silithid's heart and a step toward understanding them.")
q(4496, "Bungle in the Jungle", "Tanaris", 53, "silithid", 4,
    "Pestlezugg's research suggested that the silithid behaved like bees, and that a dead queen would throw her hive into disarray. His lure needed an undamaged scent gland from the Un'Goro hive and samples of the crater's soil.",
    "To draw a silithid queen into the open, Pestlezugg meant to brew a lure. He needed a scent gland from one of the crater's insects, intact, and some of Un'Goro's native soil.",
    "The gland's membrane was intact and the soil would serve. Pestlezugg began grinding both into the lure he hoped would stop the silithid before they overran Gadgetzan.",
    "Pestlezugg had his reagents. With a few additions of his own, the gland and the Un'Goro soil would become a lure for the hive's queen.")
q(4507, "Pawn Captures Queen", "Tanaris", 54, "silithid", 5,
    "Pestlezugg's lure was meant for a crystal in the hive's hatcheries, which he believed the silithid used to attune the whole hive. It should draw out the queen, and he wanted her brain for study.",
    "The queen would answer the lure with guards around her. Pestlezugg asked for her brain, which he needed to learn whether a malign intelligence controlled the silithid.",
    "The queen's brain reached Pestlezugg, who called the day quite a victory. He still doubted that one queen was the full extent of the silithid; the resolution seemed too clean to him.",
    "The brain went to Pestlezugg for study, and he celebrated the success. Then he admitted his doubt that the silithid ended with this queen.")
q(4508, "Calm Before the Storm", "Darnassus", 54, "silithid", 4,
    "Pestlezugg sent his latest report to Gracina Spiritmight. She had friends among the Alliance's leaders, and Gadgetzan could not fight the silithid alone.",
    "The findings from the Un'Goro hive needed hands that could act on them. Pestlezugg hoped Gracina, in Darnassus, could bring powerful friends into the fight.",
    "Gracina doubted the report would change much. The Alliance looked only for threats from the Horde, she said, and Fandral Staghelm denied that the silithid were the ancient danger she believed them to be.",
    "Gracina accepted Pestlezugg's report with little hope. She blamed an Alliance blind to all but the Horde, scorned Fandral Staghelm's doubts, and urged that the fight against the silithid go on.", true)
q(4509, "Calm Before the Storm", "Orgrimmar", 54, "silithid", 4,
    "Pestlezugg sent his latest report to Zilzibin Drumlore. The troll had friends high in the Horde, and Gadgetzan could not fight the silithid alone.",
    "The findings from the Un'Goro hive needed hands that could act on them. Pestlezugg hoped Zilzibin, on the Drag in Orgrimmar, could bring powerful friends into the fight.",
    "Zilzibin doubted the report would do much good. The Horde looked for no enemy but the Alliance, he said; Thrall might act on the facts, but conflicting advice surrounded him.",
    "Zilzibin received Pestlezugg's findings with frustration. He believed Thrall would listen if the facts reached him, and blamed advisers who saw every danger as a chance to strike at the Alliance.", true)
fallback("Calm Before the Storm", "Tanaris", "silithid", "4508,4509",
    "Findings on the silithid passed from Gadgetzan to scholars with friends among the leaders of their faction.",
    "Gadgetzan could not fight the silithid alone, so Pestlezugg's report went to a scholar who might reach the powerful.",
    "The work against the silithid between Gadgetzan and the faction capitals moved a step further.",
    "Another step in the struggle against the silithid was done.")
hl(4507, "The silithid queen's brain reached Pestlezugg for study. He called it a victory, then said the resolution seemed too clean to be the end of the hives.",
    "Pestlezugg received the queen's brain from the Un'Goro hive. He doubted one queen was the full extent of the silithid.")
hl(4508, "Pestlezugg's report reached Gracina. She doubted it would move leaders who feared only the Horde, and blamed Fandral Staghelm's arrogance.",
    "Gracina took Pestlezugg's findings, unsure they would help. Fandral Staghelm, she said, refused to see the silithid as the ancient danger she believed them to be.")
hl(4509, "Pestlezugg's report reached Zilzibin. He doubted it would move a Horde that watched only the Alliance, though Thrall might act if the facts reached him.",
    "Zilzibin took Pestlezugg's findings with frustration. Thrall might listen, he said, but conflicting advice surrounded the Warchief.")
q(3161, "Gahz'ridian", "Tanaris", 48, "gahzridian", 2,
    "Long ago the trolls of Tanaris carved ornaments in honor of Gahz'rilla, the hydra they worshipped. Marvon Rivetseeker named their material Gahz'ridian and wanted more of it to study.",
    "Marvon Rivetseeker was a scientist and a treasure hunter at heart. He lent out a helmet of his own invention that detected the buried troll ornaments called Gahz'ridian.",
    "The ornaments suited Marvon's studies perfectly. He thanked the searcher, then asked for his helmet back.",
    "For study, the Gahz'ridian ornaments went to Marvon. His detector helmet came back to him as well.")

q(4124, "The Missing Courier", "Feralas", 43, "raschal", 3,
    "A Feathermoon courier had been missing for about a week, and the Stronghold's own searches had found nothing. Latronicus Moonspear asked for help on behalf of Ginro Hearthkindle.",
    "Latronicus Moonspear had declared the courier missing in action, but his associate Ginro Hearthkindle still wanted help finding him and the parcels he carried.",
    "Ginro welcomed the help, though he called the search a lost cause. Each day he went out into Feralas looking for Raschal and came back with nothing but gnoll teeth.",
    "At the Stronghold, Ginro accepted the offer of help. A week of his own searching for Raschal had brought him only gnoll teeth and disappointment.", true)
q(4125, "The Missing Courier", "Feralas", 43, "raschal", 3,
    "Raschal had set out for Thalanaar a week earlier, planning to row down the coast and cross southern Feralas away from the Horde camp. Ginro had never found his boat.",
    "Ginro knew Raschal's route. The courier, with Feathermoon since the expedition first landed, meant to take a rowboat down the coast, and the boat might hold a clue.",
    "Wrecked in muddy water lay the rowboat, its port side torn with holes and a Feathermoon crest painted on the other. Something had tried to snap it in two.",
    "Raschal's boat was found, nearly shredded to its frame, with the Stronghold's crest on its side. In the mud beneath it, something metal glinted.", true)
fallback("The Missing Courier", "Feralas", "raschal", "4124,4125",
    "Raschal, a Feathermoon courier bound for Thalanaar, had been missing for about a week.",
    "Ginro Hearthkindle was still searching Feralas for the Stronghold's missing courier.",
    "The search for Raschal moved a step forward.",
    "Ginro's search for the missing courier had new help.")
q(4127, "Boat Wreckage", "Feralas", 44, "raschal", 3,
    "A well-kept knife lay in the mud beneath the wrecked boat, and Ginro had asked for any clue to be brought back to the Stronghold.",
    "The knife from the wreck might have belonged to whoever was aboard, and Ginro Hearthkindle was waiting at Feathermoon for any clue.",
    "Ginro believed the knife was Raschal's. Alone it proved little, so he suggested an unusual way to learn more, a reading called psychometry.",
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
    "Ginro heard out Quint's visions. Gnolls had never worried Raschal, he said, and the courier's terror pointed to something worse.")
q(4131, "The Woodpaw Gnolls", "Feralas", 44, "raschal", 3,
    "Ginro doubted the Woodpaw had killed Raschal, but their camps were the best place to start. Gnolls kept what they scavenged, and the missing backpacks might be among their spoils.",
    "With Quint's vision to go on, Ginro no longer wanted to avoid a fight. He sent the search straight into the Woodpaw camps for Raschal's backpacks.",
    "Two leather backpacks hung on a tree near the Woodpaw camps, each marked with the small insignia of Feathermoon Stronghold.",
    "The backpacks from Quint's vision turned up among the gnoll camps, tacked to a tree and still bearing the Stronghold's insignia.")
q(4135, "The Writhing Deep", "Feralas", 46, "raschal", 4,
    "Raschal's backpacks held a parcel for Thalanaar and a hurried note. He had found insect creatures in the Writhing Deep, south of the gnoll camps, and gone to investigate them himself.",
    "A note signed by Raschal of Feathermoon described bug-like creatures in a place called the Writhing Deep. He believed they threatened all of Feralas.",
    "Inside the Writhing Deep stood a pod as tall as a person, slick and studded with hardened growths. A faint humanoid shape showed through its skin.",
    "Raschal's trail led into the Writhing Deep. There, through the skin of a strange pod, the shape of someone sealed inside could just be seen.")
q(4265, "Freed from the Hive", "Feralas", 46, "raschal", 5,
    "The pod split open and released Raschal, alive and stunned. Overwhelmed by the insects, he had woken paralyzed inside it.",
    "Raschal, the missing courier, came out of the pod alive and thanked Elune. He asked whether the Stronghold had sent help.",
    "Raschal reached Feathermoon and told Ginro what had happened. Ginro said the courier would have died without that timely aid, and promised to remain a friend.",
    "Back at the Stronghold, Raschal had already reported in. Ginro said the rescue had come without a mercenary's fee and called it a hero's deed.")
q(4266, "A Hero's Welcome", "Feralas", 46, "raschal", 4,
    "General Shandris Feathermoon wanted to give her thanks in person, and to discuss the Zukk'ash insects found in southern Feralas.",
    "Ginro sent word that Shandris Feathermoon was waiting in the main compound. The reports of the Zukk'ash had frightened the Stronghold.",
    "Shandris gave her thanks for Raschal's rescue and a reward on behalf of the whole Stronghold. With a Zukk'ash hive now found in Feralas, she asked for help once more.",
    "On the Stronghold's behalf, the general offered thanks and a reward. She already had another task in mind, one that concerned the Zukk'ash hive.")
hl(4135, "Raschal's backpacks held a note about insect creatures in the Writhing Deep. Inside that place stood a pod with an unknown humanoid shape within.",
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
    "At Morgan's Vigil, Helendis Riverhorn had learned that the Blackrock orcs answered to the black dragonflight, which she suspected fed their rage. She sealed the finding in a letter for Magistrate Solomon of Lakeshire.",
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
    "Before acting on Solomon's claims, Highlord Bolvar wanted the opinion of Lady Prestor, whom he called learned in dragons and dragonkin.",
    "Bolvar weighed the matter after the visit to Lady Prestor. He respected her stance, he said, but believed another solution might settle everyone's concerns.",
    "The Highlord listened, chin in hand. Lady Prestor had given her view, and Bolvar said he had a solution of his own in mind.", true)
q(4186, "The True Masters", "Redridge Mountains", 54, "truemasters", 3,
    "Bolvar made the bearer of Lakeshire's report an acting deputy of Stormwind and sent a decree back to Magistrate Solomon.",
    "Stormwind's answer to Lakeshire was a decree and a single new deputy. Bolvar sent both back to Solomon.",
    "Solomon read Bolvar's decree and said it could have been worse. Then he judged that Lakeshire's fate rested on the new deputy's shoulders, and his eyes filled with tears.",
    "Bolvar's decree reached Lakeshire. Solomon blinked rapidly as he read it and admitted that the town's fate now rested on one deputy.", true)
q(4223, "The True Masters", "Burning Steppes", 54, "truemasters", 3,
    "Solomon sighed and wished good luck. Stormwind's new deputy now had to report to Marshal Maxwell at Morgan's Vigil.",
    "Solomon's last instruction sent Stormwind's new deputy back to the Burning Steppes, to report to Marshal Maxwell.",
    "Marshal Maxwell laughed when Stormwind's new deputy reported to him.",
    "At Morgan's Vigil, Marshal Maxwell greeted Bolvar's deputy with a laugh.", true)
q(4224, "The True Masters", "Burning Steppes", 54, "truemasters", 3,
    "Maxwell had seen Stormwind's deputies before, and lost soldiers waiting for the kingdom to act. Marshal Windsor had vanished with all their intelligence on the Blackrock; Ragged John had been with him when a raiding party struck.",
    "The Vigil's evidence against the Blackrock had gone missing with its commander, Marshal Windsor. Maxwell sent the search to Ragged John, last seen in a cave to the north.",
    "Ragged John had been found and heard out in his cave. Maxwell joked that he might have warned about the man and had chosen not to.",
    "The visit to Ragged John was done. Maxwell admitted he could have given a warning first, but thought that would have spoiled the fun.", true)
fallback("The True Masters", "Burning Steppes", "truemasters", "4183,4184,4185,4186,4223,4224",
    "The defenders at Morgan's Vigil believed the black dragonflight was driving the Blackrock orcs.",
    "Word that the black dragonflight drove the Blackrock orcs was carried between the Burning Steppes, Lakeshire and Stormwind.",
    "Another part of Lakeshire's appeal to Stormwind was complete.",
    "The warning about the Blackrock's true masters was carried one step further.")
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
    "As he read the documents brought out of the Spire, Goretooth's green skin turned pale for a moment.",
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
    "Only the strongest of the black dragonflight could enter the brood mother's lair, Rexxar explained, with a key enchanted by General Drakkisath himself. An outsider would find passage difficult.",
    "There was one way into the lair, Rexxar said. Only black dragonkin who passed many trials earned the key, and Drakkisath enchanted it himself.")
q(6569, "Oculus Illusions", "Western Plaguelands", 60, "onyxia_key", 3,
    "Myranda the Hag could craft an illusion to pass among the black flight, but the divination needed a pack full of black dragonspawn eyes from the upper Spire.",
    "Rexxar and Thrall had sent the request to Myranda. The eyes of the creatures to be mimicked were the most important part of her illusion.",
    "Myranda approved of the eyes. From them she would make a medallion whose illusion could fool the black dragonflight's gatekeeper.",
    "The dragonspawn eyes would do nicely, Myranda said, and she set about making the illusion's medallion.")
q(6570, "Emberstrife", "Dustwallow Marsh", 60, "onyxia_key", 4,
    "Myranda's medallion would hold its illusion inside the den of Emberstrife, an ancient drake of the Wyrmbog who tested dragonspawn seeking to guard Onyxia.",
    "Emberstrife, an old gatekeeper of Nefarian, judged those who would rise to Onyxia's elite guard. Myranda's illusion was made to pass his inspection.",
    "Emberstrife took the disguise for a whelp sent by Nefarian. He said a broodling would never pass his tests.",
    "The disguise held. Emberstrife saw only a broodling and complained that Nefarian must be short of soldiers.")
q(6601, "Ascension...", "Desolace", 60, "onyxia_key", 4,
    "Emberstrife gave up a medallion shaped from the skulls of enemies. General Drakkisath was to place its final enchantment, marking ascension to the brood mother's guard.",
    "The medallion of the brood mother's guardians was unfinished. Emberstrife ordered it carried to Drakkisath in the Spire.",
    "Rexxar dismissed Emberstrife's speech as dragon-talk, more hot air than substance.",
    "Rexxar heard about the drake's medallion and said such pompous talk was to be expected from dragons.")
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
    "Windsor's sacrifice freed Bolvar from Onyxia's spell. Through the shattered medallion, the Highlord had glimpsed some of her secrets.")
hl(6502, "Haleh used Drakkisath's blood to turn the medallion fragment into the Drakefire Amulet, the key past Onyxia's wards.",
    "Drakkisath's blood mended the fragment. Haleh gave it back as the Drakefire Amulet, with the Blue Flight's wish for luck.")
hl(4974, "Rend Blackhand's head reached Thrall. With their Warchief slain, the Blackrock were thrown into chaos, and Thrall promised all of Kalimdor a reward.",
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
    "Varimathras said the Grand Crusader sat safe in the Scarlet Bastion while his forces murdered the Forsaken. Sylvanas had ordered Varimathras to deal with him, and he named the newcomer the instrument of that reckoning.",
    "Varimathras laid out the Dark Lady's command. He was to strike at the Grand Crusader, whose forces poured into Forsaken lands from the safety of the Scarlet Bastion.")
q(6145, "The Crimson Courier", "Eastern Plaguelands", 60, "marris_stead", 4,
    "The Scarlet command in Stratholme was too well defended to attack directly. Varimathras's deathstalkers had learned that a courier carried a daily report from there to Tyr's Hand, and he wanted it taken to Nathanos.",
    "Cut the body out from under the head, Varimathras said. The Crimson Courier's report from Stratholme to Tyr's Hand was the key, and it was to go to Nathanos.",
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
    "Valdelmar's answer reached Nathanos, who called the men of Tyr's Hand fools and prepared to strike.")
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
    "Flint wanted clues about the Blightcaller and the missing operatives, who he assumed were dead. Every SI:7 agent carried an insignia, and he swallowed hard as he asked for any that could be found.",
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
    "Betina Bigglezink had studied the plague for years and was startled to find its strength growing. She wanted samples of the most recently infected flesh from Stratholme.",
    "The plague's potency was rising, Betina believed, and the freshest tainted flesh in Stratholme would show her how.",
    "Betina found that something had changed in the chemistry of the plague's active agents. She needed more data.",
    "The samples showed Betina a change in the plague's chemistry. More data was needed, she said, and she asked for further tests.")
q(5213, "The Active Agent", "Eastern Plaguelands", 60, "lights_hope", 4,
    "The Scourge drew great power from the ziggurats beyond Stratholme's first gates. Betina wanted them searched for anything that might explain the plague's new active agent.",
    "Betina believed she was on the verge of identifying the plague's new agent. The answer, she hoped, lay in the ziggurats of Stratholme.",
    "Betina called the findings astonishing and months of work to analyze. The Argent Dawn thanked the searcher with a Seal or Rune of the Dawn.",
    "The ziggurat data reached Betina, who expected months of analysis. She offered the Dawn's seal or rune in thanks.")
q(5281, "The Restless Souls", "Eastern Plaguelands", 60, "restless", 3,
    "Many of Stratholme's people had thrown themselves into the burning city rather than join the Scourge. Caretaker Alen wanted their restless spirits helped, and pointed the way to Egan, who studied ghosts near the city.",
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
    "The demolition plan was simple, Smokey said. The compound would go into the marked structures, and the Argent Dawn's job would be done.",
    "The compound was planted in the marked Scourge buildings. Smokey laughed at the charred look of his partner, paid out the cut and added something for the burns.",
    "Smokey paid the rest of the Argent Dawn's commission, with a little extra to soothe the burns.")
hl(6041, "Smokey's compound was planted in the marked Scourge buildings of Plaguewood. He paid out the commission and added something for the burns.",
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
    "Winterspring was harsh country full of old elven ruins. Ivy Leafrunner sent a friend north to Wynd Nightchaser of Starfall Village.",
    "Wynd Nightchaser welcomed a friend of Ivy Leafrunner to Starfall.",
    "Wynd Nightchaser greeted the newcomer Ivy had sent north.")
q(5250, "Starfall", "Winterspring", 56, "starfall", 2,
    "Daryn Lightwind's studies kept her from Winterspring and its elven ruins. She sent a student north to Wynd Nightchaser at Starfall, who knew the area well.",
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
    "The sacred writings from Azshara reached Aurora, untouched for many years.",
    "Aurora received the old writings from Azshara. No one had turned those pages in a very long time.", true)
q(5247, "Fragments of the Past", "Eastern Plaguelands", 57, "zinmalor", 4,
    "To fuse the fragments, Aurora needed an enchanted thorium bar, five crystal restores and a vial of water from the dire pool along Eldreth Row in Dire Maul.",
    "Aurora could mend the crystal with strong magic. She asked for enchanted thorium, crystal restores and water from Dire Maul's dire pool, and warned that the relic must never be stolen again.",
    "Aurora had her materials and began fusing the fragments, hoping to restore the crystal to what it had been.",
    "The thorium, restores and dire pool water reached Aurora, and she set to joining the shards.", true)
fallback("Fragments of the Past", "Eastern Plaguelands", "zinmalor", "5246,5247",
    "Aurora Skycaller studied the shards recovered from Kel'Theril.",
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
    "Fandral knew of the crystal and its power over arcane forces. Impressed that its bearer had not tried to use it, he promised to keep it safe and hoped the cursed spirits would rest.",
    "The Crystal of Zin-Malor reached Fandral Staghelm. The Circle would guard it, he said, and he hoped the spirits that once guarded its shards could finally be at peace.")
hl(5253, "The restored Crystal of Zin-Malor reached Fandral Staghelm for safekeeping. He hoped Kel'Theril's cursed spirits would finally rest.",
    "Fandral Staghelm took charge of the Crystal of Zin-Malor, mended from the shards beneath Kel'Theril's ice.")
q(979, "Find Ranshalla", "Winterspring", 57, "wildkin", 3,
    "The wildkin feathers held the same enchantment Erelas Ambersky had noticed before. Erelas could not say what it meant, but urged the search for answers to go on. A colleague, Ranshalla, had recently gone into Winterspring to watch the wildkin in their own habitat.",
    "Erelas Ambersky could not explain the enchantment in the wildkin feathers. The question went on to Ranshalla, who was studying the wildkin of Winterspring where they lived.",
    "Ranshalla was just preparing to go up to the caves, and she did not mind company.",
    "Mention of Erelas was welcome. Ranshalla was about to head up to the caves, and glad of someone to go with.")
q(4901, "Guardians of the Altar", "Teldrassil", 59, "wildkin", 4,
    "Ranshalla believed an altar of Elune stood at the top of the ridge. Five torches in each cave had to be lit while she recited incantations copied from the ruins of Kel'Theril.",
    "The way to the altar lay through the caves along the ridge. Ranshalla would speak the incantations from Kel'Theril while the torches were lit one by one.",
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
    "Galford was dead and his archives burned. Years of Scarlet intelligence were lost, and the Argent Dawn expected the Crusade to feel the blow for weeks.",
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
    "Stormwind's census listed an Emma Felstone five years earlier. The factor began to suspect she was the woman called Ol' Emma.", true)
q(5023, "Better Late Than Never", "Undercity", 52, "felstone", 3,
    "Janice's package was addressed in a hurried hand to Jeremiah Felstone of Lordaeron, dated more than four years earlier. The Undercity's census overseers might know what had become of him.",
    "The package from the Felstone farm bore the name of Jeremiah Felstone of Lordaeron. The Undercity kept a census of its people, living and former.",
    "Jeremiah Felstone had lived in the city before the plague, the overseer found. As one of the Forsaken he now went by Jeremiah Payson, whom the overseer took for the cockroach vendor.",
    "The Undercity census traced Jeremiah Felstone to a new name, Jeremiah Payson. The overseer realized he was the cockroach vendor.", true)
fallback("Better Late Than Never", "Western Plaguelands", "felstone", "5021,5022,5023",
    "Janice Felstone's ghost still haunted her farmhouse, desperate for her package to be delivered at last.",
    "A package had waited at the Felstone farm for more than four years without being delivered.",
    "The search for the package's recipient moved forward.",
    "Janice Felstone's package was one step closer to the person it was addressed to.")
q(5048, "Good Natured Emma", "Stormwind City", 52, "felstone", 3,
    "Ol' Emma wandered Stormwind talking to herself, ornery but harmless. The census suggested she was Emma Felstone.",
    "The factor believed Ol' Emma was Emma Felstone. Asking her last name was the simplest test.",
    "Emma confirmed her name, the first time in years anyone had used it. She expected her sister to be dead and took the visitor for a grave-robber, until she heard there was a package from Janice.",
    "Ol' Emma admitted she was Emma Felstone. She had lost most of her family to the plague, and was startled to learn her sister had sent her something.")
q(5049, "The Jeremiah Blues", "Undercity", 52, "felstone", 3,
    "The evidence pointed to Jeremiah Payson, who sold cockroaches near the Undercity bank. The overseer added his good wishes with heavy sarcasm.",
    "The intended recipient was Jeremiah Payson, the cockroach vendor groveling beneath a walkway near the bank.",
    "Jeremiah admitted to the old name and called the messenger a vulture for claiming to have spoken to a sister four years dead. Then he heard there was a package.",
    "Jeremiah Payson had once been Jeremiah Felstone. He was ready to take offense, until he learned his dead sister had sent him a package.")
q(5050, "Good Luck Charm", "Western Plaguelands", 52, "felstone", 4,
    "The package held Janice's personal effects, even the deed to the Felstone farm. Her sibling apologized for the earlier suspicion and sent back half of a good luck charm, hoping it would let her rest. John, her husband, had carried the other half.",
    "Janice's sibling kept the farm deed for another day and returned half of her good luck charm, in the hope that her spirit might rest.",
    "Janice's ghost took the half-charm and asked for John's half. They could not be together without both, she said, and she asked whether he could see her.",
    "The half-charm reached Janice, who called for her husband and asked where he had put the other half.")
q(5051, "Two Halves Become One", "Western Plaguelands", 54, "felstone", 5,
    "Janice's ghost kept calling for John and his half of the charm, begging him to hurry before the plague changed them both. The other half had to be found and the charm made whole.",
    "Janice could not see John, but she felt him near. Only the whole good luck charm, both halves joined, would answer what her spirit sought.",
    "Janice took the reassembled charm and her form shimmered. With clear, sad eyes she said she was free, and gave the charm away in the hope it would bring the same solace.",
    "The reassembled charm came to rest in Janice Felstone's hands. Her spirit was freed, and she no longer needed it.")
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
    "Eridan did not know Linken, but knew what he had sought. Blazerunner, an elemental in Un'Goro, had an aura only great power could dispel. Eridan offered to teach that power in return for Felwood's silvery claws and an irontree heart.",
    "Eridan Bluewind offered knowledge to defeat the evil elemental Blazerunner. First she wanted eleven silvery claws and an irontree heart from Felwood's creatures.",
    "Eridan accepted the claws and the irontree heart as proof that the helper was serious about aiding a friend.",
    "The silvery claws and irontree heart reached Eridan, who judged the commitment to Linken sincere.")
q(4005, "Aquementas", "Un'Goro Crater", 54, "linken", 4,
    "Eridan sent a bag of supplies to a circle of stones on the eastmost peninsula of Lost Rigger Cove in Tanaris. Read from the tome of Aquor inside the circle, the words would summon Aquementas, who could transform the items into a totem against Blazerunner.",
    "Aquementas would not be pleased to be woken, Eridan warned, but only he could make the totem, and only for someone who stayed inside the circle.",
    "The finished totem was examined in Un'Goro. A strong elemental called Blazerunner lived in the charred heart of the crater, and none had pierced his aura.",
    "Back in the crater, the new totem drew a knowing answer. Everyone kept their distance from Blazerunner, protected by an aura none had broken.")
q(4289, "The Apes of Un'Goro", "Un'Goro Crater", 55, "torwa", 3,
    "To Torwa Pathfinder, Un'Goro's creatures were nobler versions of those found elsewhere, and the crater cried of the Earth Mother. The great apes to the north were a test for any mortal's strength.",
    "Torwa paid homage to the Earth Mother with every hunt across the crater. He asked for the pelts of the great apes as proof of strength.",
    "Torwa accepted the pelts as clothing for his tribe. Then he gave praise to the Earth Mother and thanked the spirits of the slain apes.",
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
    "Karna Remtravel had built a mechanical ape with scrying gems for eyes, to watch the apes of Un'Goro. Contact was lost at Fungal Rock, just as an alpha male rushed up to the machine.",
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
    "The torn notebook named its owner, Williden Marshal, and suggested he could be found in the northern crater.",
    "Williden was glad to have his notebook back and thanked its finder kindly.",
    "Williden had given the notebook up for lost, like almost everything else the expedition brought into Un'Goro, and was glad to see it again.")
hl(4292, "Lar'korwi was lured out with his own kill and his mates' scent, and killed. Torwa praised the Earth Mother and the hunter's courage.",
    "The great raptor Lar'korwi was dead. Torwa said only the greatest of his ancestors could have matched the deed.")
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
    "The embrace of death had all but overcome a Watcher in Silithus when a great being intervened, breathed once upon his maimed body, and bound him to remain. Now he believed a second war was upon the desert, and wanted to know whether his master had returned to the Caverns of Time.",
    "The Watcher of Cenarion Hold could not act until he knew that the resting place of the bronze dragons was no longer empty.",
    "Word from the Caverns of Time was as it should be. The great one had risen, and a long watch came to an end.",
    "In the Caverns of Time, the great one had risen, and a long watch was declared over.")
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
    "The fragments earned the right to choose one more deputy, and the dragon mused that all of Cenarion Hold might one day serve under the champion.")
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
hl(8288, "Broodlord Lashlayer fell in Blackwing Lair. The bronze dragon who wanted his head wondered whether a mortal could be the first in a thousand years to win the Brood's favor.",
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
    "At Bronzebeard's camp, the letter explained a lot. Anyone who found a way into Ahn'Qiraj was asked to look out for Brann, whom the camp feared powerless without his monkey.",
    "The letter reached Bronzebeard's camp. Brann had gone into Ahn'Qiraj, and his people hoped someone would find him there.")
q(8309, "Glyph Chasing", "Silithus", 60, "bronzebeard", 4,
    "The three silithid hives had been spewing out insects, and Rutgar Glyphshaper wondered whether the glyphs on their strange crystals explained it. He wanted rubbings from crystals in all three hives.",
    "Since the first foray into the hives and Natalia Mar'alith's madness, the swarms had grown. Rutgar hoped the glyphs on the hive crystals held the reason.",
    "Rutgar could make nothing of the glyphs. He had never seen their like and hoped Frankal's research would help.",
    "The rubbings from the three hives left Rutgar Glyphshaper baffled, so the glyphs waited on Frankal's research.")
q(8310, "Breaking the Code", "Silithus", 60, "bronzebeard", 4,
    "Frankal Stonebridge thought he could brew an elixir to help decipher the language of the silithid and Qiraji. He needed a brain from each type of silithid in the hives.",
    "So that Rutgar Glyphshaper's work would not be for nothing, Frankal Stonebridge wanted brains, one from every kind of silithid.",
    "Frankal called the brains outstanding and told his helper not to wander off, since more work might follow.",
    "The silithid brains reached Frankal Stonebridge, who warned that another task or two might follow.")
q(8321, "Vyral the Vile", "Silithus", 60, "twilight", 5,
    "The Twilight's Hammer had another base, a cave called Twilight's Run in the northeast of Silithus. Its leader, Vyral the Vile, wore a signet ring that would prove his death.",
    "Twilight's Run, a cave full of horrors, sheltered the cult's local leader, Vyral the Vile.",
    "Vyral was dead and his ring delivered. Cenarion Hold judged the blow one the cult's Silithus operations would not easily recover from, though a few cultists might still lurk.",
    "The death of Vyral the Vile meant doom for the Twilight's Hammer in Silithus, as Cenarion Hold saw it.")
q(8323, "True Believers", "Silithus", 59, "twilight", 3,
    "With the Twilight Lexicon in his hands, the former cultist wanted the cult's monthly encoded bulletin, the True Believer. It would say whether they still hunted him.",
    "The Twilight's Hammer circulated a secret bulletin among its members. Each issue might hold news of the search for its deserter, and other useful things.",
    "The former cultist took the encoded texts and promised to share anything of interest he decoded.",
    "The cult's bulletins reached their deserter, who promised to decode them as soon as he could.")
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
    "Lord Arkkoroc wanted Hetaera dead, the beast who called herself ruler of the oceans and killed his children. All her heads were the price of the demon lord's name.",
    "Arkkoroc called Hetaera a false god. He pointed southwest toward her clutch and promised the name, and something more, for her heads.",
    "Arkkoroc received Hetaera's heads and declared their bearer worthy of his wisdom at last.",
    "Hetaera was dead. Lord Arkkoroc bent down to look over her slayer and found that slayer worthy.", true)
q(3511, "The Name of the Beast", "Azshara", 58, "defiler", 4,
    "Arkkoroc revealed the demon lord's name, Razelikh the Defiler, and squeezed the blood from Hetaera's heads to make a temper for the weapon. The temper and the true name, Rakh'likh, were for Loramus.",
    "The weapon against the Defiler needed a temper. Arkkoroc drained Hetaera's heads between his fists and sent the blood to Loramus with the beast's true name.",
    "Loramus said Arkkoroc's temper would give the forging the vitriol it needed. One step remained before the weapons could be made.",
    "Loramus received Arkkoroc's temper and the demon's true name, and saw one step left before the weapons could be made.", true)
q(3602, "Azsharite", "Azshara", 58, "defiler", 3,
    "The cliff giants of southern Azshara ate rock and buildings and left behind Azsharite, a malleable and very strong crystal. Loramus wanted enough of it for the weapons' bodies, and lent his felhounds to help.",
    "Few ever recovered Azsharite, because the giants who produced it were so violent. Loramus needed it all the same.",
    "The work in Azshara was complete, Loramus declared, and he turned to forging the components for the next step.",
    "The Azsharite reached Loramus, who began forging what the weapons would need.")
q(3621, "The Formation of Felbane", "Stranglethorn Vale", 58, "defiler", 4,
    "The tempered Azsharite had to go to a smith who could harness fel energy. Galvan the Ancient, leader of the Mithril Order, kept a camp in Stranglethorn between Zul'Gurub and the Mosh'Ogg mound.",
    "Loramus sent the weapon materials to Galvan the Ancient in Stranglethorn Vale, and his blessing with them.",
    "It had been many years since Galvan heard the name Loramus. He marveled that anyone had brought back such materials from Azshara alive, let alone after facing demigods and giants.",
    "The materials reached Galvan the Ancient, who could only imagine what it had taken to gather them.")
q(3625, "Enchanted Azsharite Fel Weaponry", "Stranglethorn Vale", 58, "defiler", 4,
    "Galvan warned that the Felcurse in the new weapon could be used only once every three minutes, and that its weakening of Razelikh and his minions might vary in length.",
    "Each weapon took time to forge, Galvan said, and the forging must not be interrupted.",
    "A finer demon slayer had never existed, Galvan said, wiping the sweat from his brow.",
    "The Azsharite weapon was finished, and Galvan called it the finest demon slayer ever made.")
q(3626, "Return to the Blasted Lands", "Blasted Lands", 58, "defiler", 3,
    "With the new weaponry, it was time to return to the Fallen Hero of the Horde for the final objective.",
    "The hour of redemption was near. The Fallen Hero waited for the weapons from Galvan's forge.",
    "The Fallen Hero asked whether the bearer of the weapons was ready to face Razelikh and his minions.",
    "The Fallen Hero judged the new arrival battle hardened and asked if the time had come to face Razelikh.")
q(2621, "The Disgraced One", "Swamp of Sorrows", 50, "fallenhero", 3,
    "The Fallen Hero of the Horde blamed himself for a regiment's ruin. If only he had waited for his orders, they might have warned of what waited in those cursed lands. Dispatch Commander Ruag in Stonard would know what became of them.",
    "Regret was all the spirit had left. He stood waiting for orders that never came, and wanted to know why.",
    "Commander Ruag remembered Thrall's Grasp. The Horde had lost some of its best soldiers when that battalion was destroyed.",
    "The dispatch commander in Stonard shook his head over the fate of the regiment called Thrall's Grasp.")
q(2622, "The Missing Orders", "Swamp of Sorrows", 50, "fallenhero", 3,
    "Ruag bristled at the question. He had relayed the orders, but the soldiers carrying them were ambushed by murlocs, and only Bengor survived, unable to walk and fed through a tube.",
    "Ruag insisted the orders had been sent, and warned against sticking a nose where it might be bitten off. Bengor, the lone survivor of the murloc ambush, might say more.",
    "Two words were all Bengor could stammer, Swamp Talker.",
    "The broken survivor managed a few halting syllables, naming the Swamp Talker.")
q(2623, "The Swamp Talker", "Blasted Lands", 55, "fallenhero", 4,
    "Bengor remembered the ambush on the way to the Blasted Lands. A murloc called Swamp Talker took the orders from his hands as a spear struck his skull, and went east to a cave.",
    "The Swamp Talker had the orders that never reached the Fallen Hero's regiment. Bengor managed the words east and cave before passing out.",
    "The orders reached the Fallen Hero at last, and they were worse than he had imagined. Nineteen of his men might have been spared; powerless himself, he asked for help for them.",
    "The recovered orders confirmed the Fallen Hero's fear. His haste had cost nineteen soldiers needless agony, and he begged that they be helped.")
hl(2623, "The orders taken by the Swamp Talker reached the Fallen Hero. Nineteen of his soldiers could have been spared, he said, and he asked for help for them.",
    "Once the lost orders finally reached him, the Fallen Hero blamed his own rashness for his men's agony.")
q(6804, "Poisoned Water", "Azshara", 56, "waterlords", 3,
    "Water elemental scouts sent to the Eastern Plaguelands had been twisted by the plague. A vial holding an aspect of Neptulon would cure them, though their inner conflict would drive them into a surging madness.",
    "Hydraxis could not allow plagued water elementals to stain the Waterlords' purity. Their bracers of binding would prove they had been cured and defeated.",
    "Hydraxis approved. The corrupted elementals had been an outrage to all water, and purity was the Waterlords' strength in their war.",
    "The bracers of binding reached Hydraxis, who counted the cure a service to the purity of his kind.")
q(6805, "Stormers and Rumblers", "Azshara", 57, "waterlords", 3,
    "Hydraxis said the water elementals warred against the lesser elements. He wanted the air and earth servants of Silithus's Crystal Vale defeated, whatever they guarded.",
    "To prove conviction as an ally of the Waterlords, Hydraxis asked for an attack on the stormers and rumblers in the Crystal Vale.",
    "Hydraxis declared bravery proven, and hinted at tasks more fitting for a valued ally.",
    "The Crystal Vale's elementals were beaten. Hydraxis judged the newcomer worthy of greater tasks.")
q(5534, "Kim'jael's \"Missing\" Equipment", "Azshara", 53, "kimjael", 2,
    "Kim'jael wanted a rune the blood elves had been seeking, now held by the naga in the Ruins of Eldarath. A valuable employee, he said, would be paid adequately in time.",
    "Kim'jael haggled over pay and then offered more of it for a rune from the Ruins of Eldarath, one the blood elves had wanted.",
    "Gloating over the rune, Kim'jael meant to learn why Magus Rimtori, who had hired him, wanted it. He paid up and sent his helper off, since he had things to figure out.",
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
    "Grark sneered that no one could break into a Blackrock fortress, take him, and reach the rendezvous unnoticed. Proving him wrong was the escort's job.",
    "Leading the captured traitor out through Blackrock Mountain meant ignoring his threats that the escort would be destroyed.",
    "The traitor was handed over at the rendezvous. His delivery earned a tribute, and the Warlord was ready to discuss the final mission.",
    "Grark Lorkrub was delivered into Horde custody, and the K.E.F. promised that the escort would not go unrecognized.")
q(4132, "Operation: Death to Angerforge", "Badlands", 58, "kef", 5,
    "General Angerforge had coordinated the attacks on the K.E.F.'s 109th division and the slaughter of its forces. The last mission was to bring him to justice in Blackrock Depths.",
    "Goretooth called it the most grueling mission of all, against the Dark Iron general known as the Butcher of Blackrock.",
    "Angerforge was dead. Goretooth gave a medallion as a symbol of dedication to the Horde and the K.E.F.",
    "Justice came to the Butcher of Blackrock, and the Warlord rewarded the deed with the K.E.F.'s medallion.")
hl(4132, "General Angerforge, the Butcher of Blackrock, was killed. Goretooth gave a medallion in honor of the Horde and the K.E.F.",
    "The Dark Iron general behind the slaughter of the 109th was dead, and the Warlord rewarded the deed.")
q(4061, "The Rise of the Machines", "Badlands", 54, "machines", 3,
    "Machines had appeared in the Searing Gorge, imported from the Burning Steppes or perhaps Blackrock Depths. Theodora Mulvadania wanted shards from the rock automatons to trace their origin.",
    "Theodora meant to find who was building the rock creations. Their elemental shards would tell her.",
    "Under an enormous monocle, Theodora examined the fragments and found initials etched into each one.",
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
    "With his things back, Mok'Morokk declared that he liked the one who fetched them.",
    "The overlord's grog, snuff and strongbox were back in Brackenwall, and Mok'Morokk was pleased.")
q(1168, "Army of the Black Dragon", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Tharg wanted revenge. Black dragons had killed many ogres and his wife, and Mok'Morokk had told the clan to run. Ogres should fight, Tharg said, and he wanted to go home to the Stonemaul Ruins.",
    "To Tharg, Mok'Morokk cared only for himself. Tharg asked for help fighting the black dragon army that held the clan's old home.",
    "Many of the black dragon army were dead, and Tharg was glad.",
    "The bravery shown against the black dragon army in the south earned Tharg's praise.")
q(1169, "Identifying the Brood", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Draz'Zilb, an ogre who spoke with unexpected polish, believed he was the only one trying to learn who had attacked the old village. Hearts and tongues from the black whelps and hatchlings would let him trace the source.",
    "Draz'Zilb scorned Mok'Morokk for wallowing in power while Tharg grieved, and wanted to know which dragon had brought her spawn to Stonemaul Village.",
    "A perilous affair, Draz'Zilb called the collection, and he began delving into the arcane to trace the black menace.",
    "With hearts and tongues from the whelps, Draz'Zilb began to trace the black menace that had come to his former home.")
q(1170, "The Brood of Onyxia", "Dustwallow Marsh", 43, "stonemaul", 4,
    "Draz'Zilb found that Onyxia's brood had invaded Stonemaul Village. He suspected Deathwing's daughter had a purpose beyond besieging a band of ogres, and wanted Mok'Morokk told.",
    "The brood of Onyxia had taken the Stonemaul's home. Draz'Zilb urged that the overlord act at once.",
    "Mok'Morokk wanted nothing to do with dragons. There were none here, he said, and he liked it here.",
    "The overlord heard the news about Onyxia's brood and refused to care.", true)
q(1171, "The Brood of Onyxia", "Dustwallow Marsh", 43, "stonemaul", 3,
    "Mok'Morokk sent word back to Draz'Zilb that the clan would stay where it was, away from the black dragons.",
    "The overlord's answer to the dragon threat was to stay put. Draz'Zilb had to hear it.",
    "A lazy coward, Draz'Zilb called Mok'Morokk. The overlord had been strong while Rexxar led, he said, but power had changed him, and something had to be done.",
    "The overlord demanded service instead of serving, Draz'Zilb said, and something had to be done.", true)
q(1172, "The Brood of Onyxia", "Dustwallow Marsh", 45, "stonemaul", 4,
    "Onyxia's brood was scattered across the Dragonmurk. Draz'Zilb wanted her eggs in the Wyrmbog destroyed before more whelps hatched, or Stonemaul Village could never be reclaimed.",
    "Draz'Zilb was sure the Wyrmbog held Onyxia's lair. He asked that her eggs be found and smashed, and hinted at other plans for Mok'Morokk.",
    "It would be some time before Onyxia could produce more eggs, Draz'Zilb said. Then he asked for one last service, to drive Mok'Morokk out by force so the clan could choose a new leader.",
    "Onyxia's eggs were destroyed. Draz'Zilb gave thanks on behalf of his people and named Tharg as a worthy leader, if not for his age and injuries.", true)
fallback("The Brood of Onyxia", "Dustwallow Marsh", "stonemaul", "1170,1171,1172",
    "Onyxia's brood had driven the Stonemaul ogres from their old village.",
    "Draz'Zilb of the Stonemaul was trying to understand why Onyxia's dragons had come to the marsh.",
    "Draz'Zilb's effort against Onyxia's brood moved forward.",
    "The Stonemaul's struggle with the black dragons went on.")
q(1173, "Challenge Overlord Mok'Morokk", "Dustwallow Marsh", 45, "stonemaul", 5,
    "Mok'Morokk laughed at the challenge and promised a good beating whenever his challenger was ready.",
    "The overlord scoffed at the challenge, sure he would crush the one who dared face him.",
    "Like a frightened child, Mok'Morokk fled. Draz'Zilb said the Stonemaul could now choose a leader to take them home.",
    "Out of Brackenwall went the cowardly overlord, and the Stonemaul were free to appoint someone new.")
hl(1172, "Onyxia's eggs in the Wyrmbog were destroyed. Draz'Zilb gave thanks for his people, then asked that Mok'Morokk be driven out.",
    "Draz'Zilb said Onyxia would need time to lay more eggs, and turned to removing the clan's coward of an overlord.")
hl(1173, "Mok'Morokk fled from the challenge. Draz'Zilb said the Stonemaul could at last choose a leader to take them home.",
    "Overlord Mok'Morokk ran, and the Stonemaul Clan was free to pick a new leader.")
q(693, "Wand over Fist", "Arathi Highlands", 39, "trelane", 3,
    "Skuerto had traced the first of Trelane's items. Kor'gresh had the wand in Boulderfist Hall and was learning to use it, blasting his own kin with ice to keep them in line.",
    "The wand belonged to Trelane, and the ogre Kor'gresh was close to mastering it. Skuerto wanted it taken back from Boulderfist Hall.",
    "Brilliant work, Skuerto called it, one item down and three to go. The other three lay in Stromgarde, and he advised rest before the next phase.",
    "Trelane's wand was recovered from Kor'gresh. Skuerto turned his thoughts to the three items still in Stromgarde.")
q(694, "Trelane's Defenses", "Arathi Highlands", 39, "trelane", 3,
    "Ogres surrounded the Tower of Arathor in Stromgarde. Its defenses could be woken with gems the Boulderfist shaman had stolen, once Kryten enchanted one as a key.",
    "Skuerto's plan needed an azure agate from the Boulderfist shaman. Kryten knew the spell to turn it into a key for the tower's defenses.",
    "Praise came from Kryten, who set about enchanting the agate.",
    "Kryten said the find amazed him, and began the spell to enchant the azure agate.")
q(695, "An Apprentice's Enchantment", "Arathi Highlands", 39, "trelane", 3,
    "Kryten's enchanted gem would wake the tower's defenses when pressed against a pedestal at its base. He sent it with instructions to hear the rest from Skuerto.",
    "The gem was ready. Pressed to a pedestal by the Tower of Arathor, it would turn the tower's defenses against the ogres.",
    "Skuerto was ready to begin, if there were no more delays.",
    "With the gem enchanted, Skuerto called for the attack on the tower to start.")
q(696, "Attack on the Tower", "Arathi Highlands", 39, "trelane", 4,
    "Trelane's phylactery, orb and ember agate lay in chests inside the Tower of Arathor. The defenses would help, but the ogres would fight anyone they caught stealing.",
    "Skuerto named the three remaining items, all in the tower's chests, and warned that the ogres would have to be fought regardless.",
    "An overwhelming success, Skuerto called the mission. Malin, he said, could not have asked for a worthier helper.",
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
    "At Maestra's Post, Delgren the Purifier remarked that the courier seemed rather well armed for a messenger, then read Balthule's warning with concern.", true)
q(970, "The Tower of Althalaxx", "Ashenvale", 21, "althalaxx", 3,
    "Delgren had been fighting the Dark Strand at Ordil'Aran, northeast of Maestra's Post. One of the cultists there carried a soul gem he believed held the secret of the cult's power.",
    "The Cult of the Dark Strand was a thorn in Delgren's side. A soul gem from Ordil'Aran might let him decipher its secrets.",
    "Delgren found dark magic in the soulstone and set about learning what was trapped inside.",
    "Dark magic enchanted the soulstone from Ordil'Aran, Delgren said, and something was trapped inside it.", true)
q(973, "The Tower of Althalaxx", "Ashenvale", 24, "althalaxx", 4,
    "Delgren knew of Ilkrud Magthrull, a powerful orc warlock at the Fire Scar Shrine in southwestern Ashenvale. He had thought him only an annoyance until now.",
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
    "Delgren the Purifier had known the task would be met, he said, and he gave his blessing with a gift.", true)
hl(981, "The Cult of the Dark Strand was beaten, and Delgren the Purifier sent his blessing and a gift.",
    "Athrikus was dead, and Delgren at Maestra's Post said he had expected nothing less.")
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
    "Lydon mixed the tongues and ichor into what he named the Elixir of Suffering. The first taste was for Umpi, the frog he kept in his workshop.",
    "The new elixir needed a test before the Dark Lady used it on humans and Scourge. Lydon chose Umpi, his frog assistant.",
    "A taste of the Elixir of Suffering went to Umpi, who answered with a croak.",
    "Umpi tasted the Elixir of Suffering first. The frog gave only a croak.", true)
fallback("Elixir of Suffering", "Hillsbrad Foothills", "lydon", "496,499",
    "Apothecary Lydon of Tarren Mill was brewing poisons for the Forsaken's new plague.",
    "Lydon's Elixir of Suffering began with reagents gathered around Tarren Mill.",
    "Lydon's work on the Elixir of Suffering moved forward.",
    "Another step of the apothecary's experiment in Tarren Mill was done.")
q(501, "Elixir of Pain", "Hillsbrad Foothills", 24, "lydon", 2,
    "In Tarren Mill, Lydon longed for the day the New Plague brought death to the world. His research called for the blood of a mountain lion.",
    "Hillsbrad's spring flowers only deepened Apothecary Lydon's gloom. He believed mountain lion blood would make a splendid death-brew for Lady Sylvanas.",
    "Lydon had the mountain lion blood and praised the collecting.",
    "Lydon pronounced the collecting superb and set the lion blood aside for his next elixir.", true)
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
    "Lydon took the six mudsnout blossoms for his Elixir of Agony, reek and all.", true)
q(513, "Elixir of Agony", "Undercity", 28, "lydon", 3,
    "Lydon ground the blossoms into a composite. Master Apothecary Faranell in the Undercity had to add his colloid of decay before the work could go on.",
    "The mudsnout composite needed Faranell's colloid of decay. Lydon sent it to the Undercity at once.",
    "Faranell was too busy for visitors until he heard Lydon's name. He called Lydon one of their most dedicated members and liked what he was doing.",
    "Faranell had no time for visitors until Lydon's name came up. Then the composite was welcome, and so was Lydon's plan.", true)
q(515, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 3,
    "Faranell added his colloid of decay to the composite. To wake it, Lydon would need a strong troll's blood potion, daggerspine scales and torn fin eyes from Hillsbrad's southern coast.",
    "The brew still lacked the reagents that would activate its contagion. Faranell named them and sent the mixture back to Lydon.",
    "Lydon had every reagent and declared himself giddy over the experiment.",
    "With scales, eyes and the troll's blood potion in hand, Lydon promised to spread death and disease across the land.", true)
q(517, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 3,
    "The Elixir of Agony was ready, and Lydon thought it wasted on a frog or a dog. He wanted a keg of Shindigger Stout stolen from the dwarves' barracks at Dun Garok.",
    "Lydon had a better use for a contagious plague than another animal test. A keg of the dwarves' Shindigger Stout from Dun Garok would carry it.",
    "Lydon had his keg of Shindigger Stout and was ready for action.",
    "Finally, said Lydon over the keg stolen from Dun Garok; now they were ready for action.", true)
q(524, "Elixir of Agony", "Hillsbrad Foothills", 30, "lydon", 4,
    "The Deathguards held captured farmers next door to Lydon. Darthalia had suspected a Stormwind strategist among them, but he was found dead in the Plaguelands, so she left the prisoners to Lydon.",
    "Lydon tainted the stolen stout with his elixir and meant the keg for the room where the Deathguards kept their captured farmers.",
    "The tainted keg was set on the dusty rug in the prisoners' room.",
    "The plagued keg now rested in the farmers' room, as Lydon had asked.", true)
fallback("Elixir of Agony", "Hillsbrad Foothills", "lydon", "509,513,515,517,524",
    "Apothecary Lydon was preparing an Elixir of Agony for the Dark Lady.",
    "The Elixir of Agony passed between Lydon in Tarren Mill and the apothecaries of the Undercity.",
    "Lydon's Elixir of Agony moved closer to its test.",
    "Another stage of the apothecaries' work on the Elixir of Agony was done.")
hl(524, "Lydon's Elixir of Agony went into a keg of stolen dwarven stout. The keg was set down in the room where the Deathguards held captured farmers.",
    "Lydon's tainted keg was left on the rug in the prisoners' room in Tarren Mill.")

q(495, "The Crown of Will", "Hillsbrad Foothills", 39, "crown", 3,
    "Mug'Thol and his ogres had been sent to Alterac for the Crown of Will, on Lady Sylvanas's behalf. Instead he put it on, and it let him resist the possession that bound him to her.",
    "Sharlindra said the Dark Lady wanted an example made of Mug'Thol. The report was to go to Melisara, Sharlindra's lieutenant in Tarren Mill.",
    "Melisara wasted no time on chatter. Mug'Thol was an irritant, she said, and would be dealt with quickly.",
    "Melisara of Tarren Mill took up the matter of Mug'Thol and promised a thorough end to him.", true)
q(518, "The Crown of Will", "Hillsbrad Foothills", 39, "crown", 3,
    "Mug'Thol's Crushridge ogres had overrun the ruins of Alterac. Melisara of Tarren Mill wanted their numbers thinned before Mug'Thol himself could be punished.",
    "In Tarren Mill, Melisara's plan against Mug'Thol began by softening up the Crushridge in the Ruins of Alterac.",
    "The snow ran red with ogre blood, but Melisara wanted the Crushridge's spirit crushed along with their numbers.",
    "The Crushridge lost many ogres, and Melisara meant to keep pressing them.", true)
q(519, "The Crown of Will", "Hillsbrad Foothills", 41, "crown", 3,
    "Targ, Muckrake and Glommus were Mug'Thol's lieutenants and loyal to him. Melisara wanted their heads before the ogre lord's own.",
    "Melisara of Tarren Mill asked for the heads of Mug'Thol's three lieutenants. After that, only Mug'Thol's own head, crown and all, would remain.",
    "Three heads reached Melisara, who planned to mount them on pikes above Alterac, with Mug'Thol's to join them.",
    "Targ, Muckrake and Glommus were dead, and only Mug'Thol remained.", true)
q(520, "The Crown of Will", "Hillsbrad Foothills", 43, "crown", 4,
    "With his lieutenants dead, Mug'Thol was likely expecting trouble. Melisara wanted his head and the Crown of Will.",
    "Melisara said killing Mug'Thol would end the Crushridge resistance. She expected him to be reluctant to give up the crown.",
    "Mug'Thol was dead. Melisara said his head would adorn the highest peak of Alterac's ruins, and the Deathguard would sweep away the rest of the Crushridge.",
    "With the Crown of Will in hand, Melisara said that Mug'Thol's head would adorn the highest peak of Alterac's ruins, and the Deathguard would sweep the last of the Crushridge into the ground.", true)
q(521, "The Crown of Will", "Undercity", 43, "crown", 4,
    "Melisara sent the Crown of Will to Sharlindra in the Undercity, to be passed to Lady Sylvanas. She warned against using it, pointing to Mug'Thol's fate.",
    "Melisara sent the crown that had let an ogre slip the Dark Lady's will to the Undercity, with a warning attached.",
    "Sharlindra found it strange that so simple a relic held such power. She promised to take it to Lady Sylvanas and tell her who had brought it.",
    "So this was the relic an ogre had used to duck the Dark Lady's will, said Sharlindra, and took it for Lady Sylvanas.", true)
fallback("The Crown of Will", "Hillsbrad Foothills", "crown", "495,518,519,520,521",
    "Mug'Thol had used the Crown of Will to resist Lady Sylvanas, and the Forsaken wanted an example made.",
    "Melisara in Tarren Mill led the Forsaken effort against Mug'Thol and his Crushridge ogres.",
    "The Forsaken campaign against Mug'Thol moved forward.",
    "Melisara's work against the Crushridge went on.")
hl(520, "Mug'Thol was killed and the Crown of Will taken from him. Melisara meant to set his head on the highest peak of the ruins of Alterac.",
    "Mug'Thol died in the ruins of Alterac, and his head and crown went to Melisara.")
hl(521, "Sharlindra took the Crown of Will for Lady Sylvanas, marveling that so simple a relic had let an ogre duck the Dark Lady's will.",
    "Sharlindra in the Undercity took the Crown of Will, bound for the Dark Lady.")

q(498, "The Rescue", "Hillsbrad Foothills", 22, "perenolde", 3,
    "Thrall had sent Krusk and other warriors to Durnholde to recover an object and look into the Syndicate. Humans overwhelmed them there, and Drull and Tog'thar were still held in the keep.",
    "Krusk had escaped the ambush at Durnholde. Two of his warriors, Drull and Tog'thar, were still prisoners across the river.",
    "Drull and Tog'thar were free. Krusk learned that the humans had meant to make slaves of them, and that Gol'dir, their leader, had been taken elsewhere.",
    "The two captives were rescued from Durnholde. Gol'dir was still missing, and Krusk had no lead yet.")
q(533, "Infiltration", "Hillsbrad Foothills", 34, "perenolde", 3,
    "Rumor at last pointed to Gol'dir's whereabouts. Humans had been moving the captured orc, and Krusk turned to the large Syndicate camp north of Tarren Mill.",
    "In Tarren Mill, Krusk wanted any papers the Syndicate camp to the north could give up. He feared Gol'dir's prospects grew worse by the day.",
    "The papers showed where Gol'dir was held. Krusk hoped the Syndicate would be less prepared this time.",
    "The documents from the camp gave Krusk the place where Gol'dir was held.")
q(503, "Gol'dir", "Alterac Mountains", 36, "perenolde", 4,
    "Krusk read the documents and placed Gol'dir in a large Syndicate base in the Alterac Mountains. He had been a captive far too long.",
    "Gol'dir, the captured leader of Krusk's expedition, was locked in the Syndicate town of Strahnbrad. The key to his cell was in a jailor's keeping.",
    "Gol'dir took the key and undid the lock himself. He had led the expedition from Durotar, and the Syndicate had made him haul and dig while he was held.",
    "Gol'dir was freed in Strahnbrad. He brushed off his suffering and said he had news for whoever now led his warriors.")
q(506, "Blackmoore's Legacy", "Hillsbrad Foothills", 36, "perenolde", 4,
    "Aliden Perenolde, the Syndicate's leader, had visited Gol'dir and boasted of enslaving the orcs who opposed him, as his father and Blackmoore had planned. His mistress Elysa wore the pendant the Warchief wanted.",
    "Gol'dir had news for Krusk. Perenolde wanted orcs in chains again, and his mistress Elysa wore the pendant Thrall sought.",
    "Krusk swore that the orcs would never submit to the humans. Stopping Perenolde became his mission, along with recovering the Warchief's trinket.",
    "In Tarren Mill, Krusk swore the orcs would never submit to Perenolde's will. The man and the pendant were now a single target.")
hl(506, "Krusk heard Gol'dir's news and cursed the nerve of the humans. Aliden Perenolde wanted orcs enslaved as Blackmoore had, and his mistress Elysa wore the Warchief's pendant.",
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
    "Redpath took the murloc heads with a jab about Farren's errands, and allowed that Southshore needed hard workers for its protection.", true)
q(561, "Farren's Proof", "Hillsbrad Foothills", 32, "farren", 2,
    "Redpath had new orders for Lieutenant Farren Orinelle. The naga on the Eastern Strand were his next task, and he was to report in person once he had results.",
    "Marshal Redpath sent word back to Farren. The naga on the Eastern Strand were next.",
    "Farren laughed at the orders. Redpath must have heard the same news he had, and Farren swore the marshal would get no promotion from his toil.",
    "Farren heard Redpath's orders about the naga and had plans of his own for them.", true)
fallback("Farren's Proof", "Hillsbrad Foothills", "farren", "559,560,561",
    "Lieutenant Farren Orinelle owed Marshal Redpath proof of his work against Southshore's murlocs.",
    "Farren's proof for Redpath passed through other hands.",
    "Word between Farren and Redpath moved on.",
    "Another message passed between Farren and Marshal Redpath.")
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
hl(563, "Major Samuelson read his pupil's report on the naga and promised to weigh it at next month's review of assignments.",
    "Samuelson was pleased that Farren had applied himself to the naga, and said the report would count at the next month's review.")

q(659, "Hints of a New Plague?", "Arathi Highlands", 33, "goshek", 3,
    "Phin Odelic led a band of adventurers in Southshore. His cousin had put down a dog named Stanley after it grew huge and turned savage, and Phin blamed the undead.",
    "Two of Phin Odelic's companions, Quae and Kinelory, had gone to watch the Go'Shek Farm in Arathi and stopped sending word. Phin wanted them found before he worried any more.",
    "Quae was alive near the farm. She asked for quiet, since the orcs did not take well to spies.",
    "Quae was found watching the Go'Shek Farm. She warned that there was more to the place than it seemed.", true)
q(658, "Hints of a New Plague?", "Arathi Highlands", 36, "goshek", 3,
    "Kinelory had seen a courier leave a small house south of the Go'Shek Farm. Quae thought the courier might carry notes to Tarren Mill.",
    "Quae and Kinelory had watched the farm for days. A courier's papers might explain what was happening in Hillsbrad.",
    "Excellent, said Quae, and took the courier's folder.",
    "The courier's papers were in Quae's hands at last.", true)
q(657, "Hints of a New Plague?", "Arathi Highlands", 36, "goshek", 3,
    "The folder showed that Apothecary Jorell was running deadly experiments at Go'Shek. Quae was hurt from a clash with orcs, so Kinelory needed protection to steal the research not yet sent to Tarren Mill.",
    "Quae could not tell what Apothecary Jorell's experiments had to do with Hillsbrad, but Phin would not want them to go on. Hurt in a clash with orcs, she could not go with Kinelory to the farm.",
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
    "In Southshore, Phin was glad to hear the two troublemakers were alive, and said so with a reward.")
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
    "Syndicate papers in Alterac listed supplies that were needed soon. Besides food and weapons they asked for masks, oil and poison, for an important mission against Southshore.",
    "A Syndicate supply list spoke of an urgent mission against Southshore. Magistrate Henry Maleb needed to see it.",
    "Maleb read the documents and judged that the Syndicate had waged war on Southshore.",
    "Maleb read the supply list and judged that the Syndicate had waged war on Southshore.")
q(511, "Encrypted Letter", "Hillsbrad Foothills", 34, "syndicate", 3,
    "Among the Syndicate's papers in Alterac was a letter in a code no one could read. Loremaster Dibbs in Southshore might make sense of it.",
    "One letter on a Syndicate table was encrypted and inscrutable. It went to Loremaster Dibbs in Southshore.",
    "Dibbs had never seen this form of encryption, and admitted his knowledge of codes was far from complete.",
    "Dibbs studied the letter closely and could not read it.", true)
-- 511 shares its title with the Northshire rogue's letter (3102), so the title
-- context names neither Alterac nor a class.
P.quests["Encrypted Letter"] = {zone = false, thread = false, importance = 2,
    why = {"A sealed letter needed a reader who could make sense of it.", "The letter's writing pointed to someone who might explain it."},
    after = {"The letter was handed to someone who could judge it.", "The sealed letter changed hands."},
    source = {"corpus_vanilla_quests.txt quests 511,3102"}}
q(514, "Letter to Stormpike", "Ironforge", 34, "syndicate", 3,
    "Dibbs had a colleague in Ironforge who might break the Syndicate's code. Prospector Stormpike studied in the library of the Hall of Explorers.",
    "If anyone north of Blackrock Spire could read the encrypted letter, Loremaster Dibbs said, it was Prospector Stormpike in Ironforge.",
    "Stormpike asked after the old bookworm in Southshore, then took the letter. Encryption, he said, was a specialty of his.",
    "Stormpike welcomed the encrypted letter and set to work on it.")
q(551, "The Ensorcelled Parchment", "Hillsbrad Foothills", 40, "syndicate", 3,
    "A spell hid the writing on a parchment found in Alterac. Only one word at its top could be read, Nagaz.",
    "The parchment carried a spell that made it unreadable, except for the name Nagaz. Loremaster Dibbs in Southshore was asked to look at it.",
    "Dibbs recognized more encrypted notes from Alterac. He wished he could decipher them, but lacked the knowledge.",
    "Dibbs could not read the ensorcelled parchment.")
q(554, "Stormpike's Deciphering", "Ironforge", 40, "syndicate", 3,
    "Dibbs sent the parchment to Prospector Stormpike in Ironforge, whom he called a master of decryption. He had been sending Stormpike a lot of business lately.",
    "With luck, Prospector Stormpike at the Prospectors' headquarters in Ironforge could make sense of the spell-bound parchment.",
    "Stormpike found an intricate spell woven through the parchment. Untangling it would take time, so he bought it and promised to send word if its contents proved interesting.",
    "Prospector Stormpike bought the parchment to study at his leisure, and promised to send for its finder if it proved interesting.")
q(522, "Assassin's Contract", "Hillsbrad Foothills", 38, "syndicate", 3,
    "A contract for the murder of Magistrate Henry Maleb had been sealed in red wax with a distinctive signet ring.",
    "Someone had paid for Magistrate Maleb's death, and the contract said so. Its seal bore the mark of a signet ring.",
    "Maleb read the contract and understood the latest attack on Southshore. The Syndicate was after him, as it had been after the last magistrate.",
    "Maleb inspected the contract. The Syndicate wanted him dead, as it had wanted his predecessor.")
q(523, "Baron's Demise", "Alterac Mountains", 40, "syndicate", 4,
    "The contract was signed by Baron Vardus, a noble of old Alterac known for a cold heart and brutal ways. Maleb wanted him found among the Syndicate's haunts, at Strahnbrad or in the valley beyond.",
    "Magistrate Maleb wanted Baron Vardus brought to justice for sending his thugs against Southshore. He guessed the baron was among the Syndicate's haunts north of the town.",
    "Baron Vardus was dead. Maleb said his head rested easier knowing the villain had lost his.",
    "Vardus had lost his head, and Maleb said his own rested a little easier for it.")
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
    "Deathguard Samsa envied anyone sent to fight the humans of Hillsbrad while Samsa stood guard in Tarren Mill. Human skulls were Samsa's collection, and thirty would do.",
    "Stuck on guard duty in Tarren Mill, Deathguard Samsa asked for human skulls from the long fighting in Hillsbrad.",
    "Samsa called the skulls precious and beautiful, and paid as promised.",
    "Precious, beautiful skulls, Samsa called the thirty, and paid as he had promised.")
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
    "Novice Thaivand meant to bring vengeance on Southshore, where a human mob had buried the slain wizard Helcular. The rod at the heart of the plan was with the yeti.",
    "Helcular's rod was recovered from the yeti, and Thaivand was delighted.",
    "Thaivand had the Rod of Helcular back.", true)
q(553, "Helcular's Revenge", "Hillsbrad Foothills", 33, "helcular", 4,
    "Helcular had built three pyres for his greatest spell. His rod had to be charged at the flames of Azel, Veraz and Uzel, then driven into his grave in Southshore.",
    "Thaivand handed over Helcular's rod with instructions. Three flames would charge it, and Helcular's grave in guarded Southshore would receive it.",
    "The charged rod went into Helcular's grave, and a great rumbling rose from the ground.",
    "Helcular's grave took the rod, and the earth of the Southshore cemetery rumbled.", true)
fallback("Helcular's Revenge", "Hillsbrad Foothills", "helcular", "552,553",
    "Novice Thaivand sought revenge on Southshore for the death of Helcular, the novice's master.",
    "Helcular's apprentice planned a ritual against Southshore, where the slain wizard lay buried.",
    "Thaivand's plan for Helcular's revenge moved forward.",
    "Another part of the apprentice's ritual was done.")
hl(553, "Helcular's grave in Southshore took the Rod of Helcular, charged at three flames, and the ground rumbled.",
    "Helcular's grave took the charged rod, and the Southshore cemetery shook.")
q(556, "Stone Tokens", "Hillsbrad Foothills", 32, "dalaran", 2,
    "Dalaran's wizards used magical tokens to control elementals. Keeper Bel'varil wanted some for Magus Wordeen Voidglare to study, and named the internment camp as safer than Dalaran itself.",
    "Magus Wordeen Voidglare of Tarren Mill wanted to learn how Dalaran's wizards commanded elementals. Their stone tokens were the place to start.",
    "The tokens' magic had faded. Bel'varil thought that suited the Magus's first experiments.",
    "The faded tokens would do nicely, Bel'varil said; the Magus's first experiments were best done on inert specimens.")
q(557, "Bracers of Binding", "Hillsbrad Foothills", 34, "dalaran", 3,
    "Bracers of binding were set on the wrists of elementals to hold them in a mage's service. Keeper Bel'varil knew Magus Wordeen would want examples from the ruins of Dalaran.",
    "Dalaran's stone tokens had a counterpart, bracers worn by the elementals themselves. Keeper Bel'varil wanted some for Magus Wordeen.",
    "Bel'varil asked whether the elementals had been amenable, then admitted that death had robbed the Keeper of comic timing. The work served the Magus and the Dark Lady.",
    "Bel'varil had the Bracers of Earth Binding for the Magus, and hoped the elementals had been amenable about losing them.")
q(555, "Soothing Turtle Bisque", "Hillsbrad Foothills", 31, "bisque", 2,
    "Chef Jessen claimed Southshore had the best cooking north of Stormwind. His turtle bisque needed snapjaw meat from Lake Lordamere and soothing spices, but the lake had grown too dangerous for him.",
    "Folk came from as far as Darkshire for Chef Jessen's turtle bisque, he said. He had not made any lately for want of snapjaw meat.",
    "Jessen's Soothing Turtle Bisque was served in Southshore once again.",
    "Chef Jessen had his turtle meat and spices, and everyone in Southshore would be pleased to see his bisque served again.", true)
q(7321, "Soothing Turtle Bisque", "Hillsbrad Foothills", 31, "bisque", 2,
    "Christoph Jeffcoat of Tarren Mill joked that folk would come back from the dead for his turtle bisque. His work kept him from hunting snapjaws at Lake Lordamere.",
    "Christoph Jeffcoat meant to show that the undead could cook. He needed snapjaw meat and soothing spices for his bisque.",
    "Jeffcoat said his bisque would keep a body warm on a cold night, for anyone who cared about such things.",
    "Christoph Jeffcoat had his turtle meat and spices, and a bisque to keep a body warm on a cold night.", true)
fallback("Soothing Turtle Bisque", "Hillsbrad Foothills", "bisque", "555,7321",
    "A cook in the foothills needed snapjaw meat from Lake Lordamere and soothing spices for turtle bisque.",
    "Turtle bisque had gone unmade because its cook could no longer hunt Lake Lordamere's snapjaws.",
    "The cook had the ingredients for turtle bisque.",
    "The turtle meat and spices were delivered.")
q(564, "Costly Menace", "Hillsbrad Foothills", 34, "southshore", 2,
    "Darren Malvew of Southshore had lost horses to the undead, the Syndicate and other scoundrels. Worst of all were the mountain lions that came down from Alterac.",
    "Southshore's horses kept falling to mountain lions from the hills. Darren Malvew dared any would-be hero to do something about it.",
    "The news delighted Darren, who wished a war hero had turned up from day one to deal with the beasts.",
    "Many Alterac mountain lions were killed, and Darren Malvew called it great news.")
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
    "Roggo knew of an Alliance camp at Refuge Pointe in Arathi. Rhag Garmason sent a plea to its leader, Captain Nials, for soldiers.",
    "Nials grieved for Longbraid's soldiers, but Stromgarde had fallen too. Refuge Pointe would not leave the Highlands until Stromgarde was retaken, so Longbraid would be on his own.",
    "Captain Nials could spare no one, and would send word to Longbraid that Dun Modr stood alone.")
hl(634, "Captain Nials at Refuge Pointe could spare no soldiers for Dun Modr. Stromgarde had fallen, and his people would not leave Arathi until it was retaken.",
    "Refuge Pointe turned down Rhag Garmason's plea, and Longbraid was left on his own.")
q(647, "MacKreel's Moonshine", "Hillsbrad Foothills", 30, "dunmodr", 2,
    "Foggy MacKreel had passed out on watch near Dun Modr after too much moonshine. He owed Brewmeister Bilger in Southshore a batch, and it was nearly overdue.",
    "Foggy MacKreel feared Longbraid would have his head for sleeping on watch. His debt to Brewmeister Bilger in Southshore came due within a quarter hour.",
    "Bilger had expected the little debtor to be late again. He welcomed the moonshine to warm a brisk day.",
    "Nothing like Foggy MacKreel's moonshine on a brisk day, said Bilger, who had expected the little bugger to be overdue again.")
q(5321, "The Sleeper Has Awakened", "Ashenvale", 20, "darkshore", 3,
    "Kerlonian Evershade, newly woken from the Emerald Dream, kept falling asleep on his way to Maestra's Post. His horn, left in a nearby chest, could rouse him.",
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
    "The rotten, pliable skin carried red markings and what seemed a signature. Maurin Bonesplitter, the Forsaken warlock at Ghost Walker Post, was the one to ask.",
    "The runes were an old language, Maurin said, remotely like Eredun. It was a contract signed by a demon named Lord Azrethoc.",
    "The skin was a demonic contract, Maurin said, bearing the signature of Lord Azrethoc.", true)
q(1481, "The Corrupter", "Desolace", 33, "burningblade", 3,
    "Maurin believed he could scry for Lord Azrethoc with the right reagents. Breaking the demon's wards against scrying came first, and that needed the scalp of a Hatefury shadowstalker.",
    "Breaking a demon lord's wards was dangerous work. Maurin needed a scalp from a Hatefury shadowstalker in the northeastern ruins, and warned that the wrong one could kill them both.",
    "That the shadowstalkers had not prevailed impressed Maurin. The scalp would serve, and he had already gathered some of the other reagents himself.",
    "The shadowstalkers had failed to kill the bearer of the Hatefury scalp, and Maurin needed only a focus for his spell.", true)
q(1482, "The Corrupter", "Desolace", 35, "burningblade", 3,
    "Maurin's spell needed an oracle crystal, crafted by the naga for their oracles. Slitherblade naga kept them on the coral reef northwest of Ghost Walker Post.",
    "An oracle crystal from the Slitherblade naga would focus Maurin's scrying. He saw great favor with the Warchief in finding Azrethoc.",
    "Maurin called the crystal flawless and began the scrying at once, to learn what the demon was and where he could be found.",
    "Flawless, Maurin called the oracle crystal, and the scrying for Lord Azrethoc began.", true)
q(1484, "The Corrupter", "Desolace", 33, "burningblade", 3,
    "Azrethoc proved more dangerous than Maurin had expected. Maurin worried that Takata Steelblade would doubt him, and wanted the swordsman told without being pressed.",
    "The scrying had shown a demon lord far more dangerous than Maurin expected. Word had to reach Takata Steelblade, or his honor would be insulted.",
    "Takata had watched the demon's apparition and judged it stronger than Maurin. His duties kept him at Ghost Walker Post, so he could not hunt it himself.",
    "Takata Steelblade doubted Maurin could defeat Azrethoc, and was bound by his duties to stay.", true)
q(1488, "The Corrupter", "Desolace", 40, "burningblade", 5,
    "Takata agreed that Lord Azrethoc had to be stopped, above all if he sought influence over the Burning Blade. He trusted a party to kill the demon lord and his warlock servant to the south.",
    "Before the demon could bend the Burning Blade to his goals, Takata Steelblade wanted Azrethoc and his warlock servant dead.",
    "Takata called it a mighty victory. The Burning Blade would fail, he said, and one day his people might have a safe home again.",
    "Lord Azrethoc was dead, and Takata's hope for the Horde in Desolace returned.", true)
fallback("The Corrupter", "Desolace", "burningblade", "1480,1481,1482,1484,1488",
    "A torn skin covered in red markings turned up among the Horde at Ghost Walker Post.",
    "Maurin and Takata at Ghost Walker Post stood against the Burning Blade in Desolace.",
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
    "Vahlarriel was furious that the two had come despite warnings. Locals said the fort was full of the Burning Blade, orcs devoted to demons, and she called it the best lead.",
    "Vahlarriel took the pendant and the news of the tracks, and pointed the search at the Burning Blade's fortress.", true)
q(1438, "Vahlarriel's Search", "Desolace", 33, "malem", 4,
    "Vahlarriel wanted both Malems found, starting at the fortress. Darnassus cared most that Dalinda came home safe, while Tyranis's motives worried Vahlarriel's superiors.",
    "The search for the Malems led into the Burning Blade's fortress. Meanwhile Vahlarriel would tell Darnassus how things stood.",
    "Dalinda Malem was alive in the fortress, a captive of the Burning Blade with Tyranis. She feared they meant to sacrifice her, and said her brother had lately craved arcane knowledge.",
    "Dalinda was found a captive of the Burning Blade, afraid for her brother Tyranis.", true)
fallback("Vahlarriel's Search", "Desolace", "malem", "1437,1438,1465",
    "Vahlarriel Demonslayer was searching Desolace for two missing nobles of House Malem.",
    "The Malem children had disappeared on their way through Desolace.",
    "The search for the Malems moved forward.",
    "Vahlarriel's search for the missing nobles went on.")
q(1439, "Search for Tyranis", "Desolace", 33, "malem", 4,
    "The orcs had slaughtered the Malems' guards and servants. Tyranis had tried to speak with the captors, hoping to impress them, Dalinda thought. She would not leave until she knew his fate.",
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
    "Back at Nijel's Point, Kreldig heard the chest was empty and grew curious about the slashes.", true)
q(1456, "The Karnitol Shipwreck", "Desolace", 39, "reclaimers", 3,
    "Kreldig suspected the Slitherblade naga, who lived in sunken elven ruins near Ranazjar Isle. Their tidehunters and sea witches were the likeliest thieves.",
    "The slashes on Karnitol's chest pointed Kreldig Ungor to the naga. Karnitol's belongings might be with the strongest of the Slitherblade.",
    "Kreldig was delighted when Karnitol's belongings turned up among the naga. He said he would rather fight the Horde all his life than face their kind.",
    "The naga gave up Karnitol's belongings, and Kreldig called it a great service to the Reclaimers.", true)
q(1457, "The Karnitol Shipwreck", "Ironforge", 39, "reclaimers", 3,
    "Karnitol's things had to reach Roetten Stonehammer, who ran the Reclaimers from Ironforge and would pay for the work. Kreldig warned that Karnitol was impatient, but generous.",
    "The recovered goods went to Roetten in Ironforge. Kreldig joked that Roetten might ask their finder to join the Reclaimers full time.",
    "Roetten was pleased. The chest was lost, but Karnitol could judge the items himself, and the Reclaimers were paid to find things, not to polish them.",
    "The Karnitol business in Desolace was settled, Roetten Stonehammer said, and excellently.", true)
fallback("The Karnitol Shipwreck", "Desolace", "reclaimers", "1454,1455,1456,1457",
    "Karnitol, a Stormwind mage, had abandoned a valuable chest on the Desolace coast.",
    "The Reclaimers had taken the job of recovering Karnitol's lost belongings.",
    "The search for Karnitol's belongings moved forward.",
    "The Reclaimers' salvage job for Karnitol went on.")

q(1384, "Raid on the Kolkar", "Desolace", 32, "centaur", 2,
    "Uthek the Wise mocked the Kolkar's faith in their own magic. Their charms were to be brought back and thrown in the fire.",
    "To show the Kolkar their magic was weak, Uthek wanted them killed and their charms taken.",
    "Uthek said the Kolkar would die, their magic pathetic, and fear would make them weaker. In Gelkis lands, the feeble soon died.",
    "A good thing for the Gelkis, Uthek said of the charms. To Uthek the Kolkar were weak, their magic pathetic, and their fear would make them feebler still.")
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
    "This was the shard the earth had whispered of, Uthek said, and its magic would be used against the enemies of the Gelkis.")
q(1374, "Khan Jehn", "Desolace", 37, "centaur", 4,
    "The earth told Uthek the Wise that the Magram were growing weak. She wanted the head of their khan, Jehn.",
    "With the Magram weakened, Uthek of the Gelkis judged it time to kill Khan Jehn.",
    "Uthek said Jehn had trusted his strength and not seen that earth magic was stronger. Without him, the Magram would fall.",
    "Khan Jehn of the Magram was dead, and Uthek foresaw the Gelkis ruling one day.")
q(1375, "Khan Shaka", "Desolace", 37, "centaur", 4,
    "Warug of the Magram wanted the head of Khan Shaka of the Gelkis, so he could stare at it and laugh.",
    "The Magram's friendship called for the death of the Gelkis khan, Shaka.",
    "Khan Shaka was dead. Warug would keep his head on a pike so Shaka could see the strength of the Magram.",
    "Khan Shaka was dead, and Warug meant to keep his head on a pike so Shaka could see the strength of the Magram.")
q(1380, "Khan Hratha", "Desolace", 42, "centaur", 4,
    "Uthek wanted the Maraudine beaten next. Their khan, Hratha, would answer the war horn atop a bluff in the Valley of Spears, once a mouthpiece was taken from a trusted Maraudine.",
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
    "The centaur would know the name of their hunter now, Felgur said, and fear the banner of the Horde.", true)
q(1387, "Centaur Bounty", "Desolace", 31, "centaur", 2,
    "Corporal Melkins at Nijel's Point thought every centaur clan shared one trait, cruelty. Peace, he said, meant removing them, and he paid for their ears.",
    "Corporal Melkins asked for many centaur ears, in service of the Alliance and an end to the war.",
    "Melkins accepted the ears and said the blood spilled in Desolace would save countless lives.",
    "Well done, said Corporal Melkins of the ears; the blood spilled in Desolace would save countless lives, he was sure.", true)
fallback("Centaur Bounty", "Desolace", "centaur", "1366,1387",
    "A bounty in Desolace was paid for centaur ears.",
    "Both factions wanted the centaur clans of Desolace weakened, one ear at a time.",
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
    "The hoofprints were reported, and a tracker was to be sent after them.",
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
    "A Theramore insignia in the inn's rubble raised the question of who Paval Reethe was.",
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
    "Captain Vimes heard Jacken's account. Lieutenant Caldwell, he said, would hunt down both the deserters and Reethe.", true)
fallback("The Deserters", "Dustwallow Marsh", "shield", "1286,1287",
    "Theramore deserters had taken an old watchtower at Lost Point.",
    "The deserters at Lost Point might know something about the burned inn.",
    "The matter of the deserters at Lost Point moved forward.",
    "Captain Vimes's inquiry among the deserters went on.")
q(1288, "Vimes's Report", "Dustwallow Marsh", 38, "shield", 3,
    "Lady Proudmoore had asked Vimes to keep her informed of this delicate matter. He judged that the one who had done the work should report it to her.",
    "Captain Vimes sent his report on the inn, Reethe and the deserters to Lady Jaina Proudmoore.",
    "Lady Jaina Proudmoore had Vimes's report in Theramore.",
    "In Theramore, Lady Proudmoore read what Vimes had learned about the deserters and the burned inn.")
hl(1287, "Jacken said the deserters had cast Reethe out for raiding the ogres. Vimes meant to send Lieutenant Caldwell after both the deserters and Reethe.",
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
    "This had not been an easy mission, Nazeer said, but his superiors valued the documents greatly.")
q(1219, "The Orc Report", "Dustwallow Marsh", 35, "spies", 2,
    "Loose dirt in the marsh hid a severed orc hand, clutching a bone tube with a parchment in orcish inside.",
    "An orcish document in a dead hand looked important enough to carry to a Theramore officer.",
    "The Theramore officer could barely read orcish, but saw that it was a report written by an orc spy.",
    "A lieutenant of Theramore recognized the parchment as an orc spy's report.")
q(1220, "Captain Vimes", "Dustwallow Marsh", 35, "spies", 2,
    "Captain Vimes knew orcish better than most, and he needed to know there were Horde spies near Theramore.",
    "The orc spy's report went to Captain Vimes in the barracks of Theramore Isle.",
    "Vimes was surprised by a report from an orc spy and set to reading it.",
    "Vimes took the orc report from the marsh and began to read.")
q(1238, "The Lost Report", "Dustwallow Marsh", 35, "marg", 3,
    "Loose dirt in the marsh hid a severed orc hand clutching a bone tube. Inside was a report from weeks of spying on Theramore, meant for the spymaster at Brackenwall.",
    "A dirt-stained spy's report, found in a dead orc's hand, belonged with Nazeer Bloodpike in Brackenwall Village.",
    "Nazeer named the agent as Marg Nighteye, stationed outside Theramore. This might be his last report, and Nazeer feared he had died in the swamp.",
    "Good work, said Nazeer. The report was from his agent Marg Nighteye, stationed outside Theramore, and he feared it might be Marg's last.")
q(1239, "The Severed Head", "Dustwallow Marsh", 35, "marg", 3,
    "Digging turned up an orc's head, raggedly severed, its lips frozen in a snarl.",
    "The marsh gave up a severed orc head, its eyes still defiant.",
    "Nazeer knew the head as Marg Nighteye's. He could not tell whether a weapon or a beast had made the ragged wound, and wanted to know if the Alliance had killed him.",
    "Marg Nighteye was dead, and Nazeer meant to learn whether the Alliance or a beast had killed him.")
q(1240, "The Troll Witchdoctor", "Stranglethorn Vale", 35, "marg", 3,
    "Nazeer said only troll witch-magic could reveal how Marg died, and sent his head to Kin'weelay, the most powerful Darkspear witchdoctor, at Grom'gol Base Camp.",
    "Nazeer wanted Marg's spirit questioned. Kin'weelay at Grom'gol in Stranglethorn could speak with the dead.",
    "An angry spirit clung to the head, bound to the world by unfinished work. Kin'weelay prepared to speak with it.",
    "The orc's spirit was bound in the world, Kin'weelay saw, boiling with rage from a task yet undone.")
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
    "With the leaves delivered, Morgan promised to ask his uncle to treat Stinky's rescuer to a feast at the Blue Recluse.",
    "Mr. Ignatz had just been by with the bogbean leaves, Morgan said, and had told him about being helped out of real trouble.", true)
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
    "Back in Booty Bay, First Mate Crazz remembered the scout and took the Bloodsail orders.", true)
q(599, "The Bloodsail Buccaneers", "Stranglethorn Vale", 41, "bloodsail", 3,
    "The Bloodsail meant to attack Booty Bay. Crazz swore the town would always belong to the Blackwater Raiders and sent word to Fleet Master Seahorn.",
    "This was bigger than First Mate Crazz had thought. Fleet Master Seahorn had to hear of the planned attack at once.",
    "Seahorn scoffed that the Bloodsail might as well throw themselves off the Overlook Cliffs, but called the warning a great service to his fleet.",
    "The Bloodsail might as well throw themselves off the Overlook Cliffs, said Fleet Master Seahorn, but the warning had done his fleet a great service, and the Blackwater Raiders gave their thanks.", true)
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
    "Bloodsail Buccaneers had been spotted across southern Stranglethorn, near Booty Bay and its Blackwater Raiders.",
    "The Blackwater Raiders needed to know what their Bloodsail rivals were planning.",
    "The Blackwater Raiders gained ground against the Bloodsail Buccaneers.",
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
    "The next spot named in Cortello's riddle was searched.",
    "One more part of Cortello's riddle was solved.")

q(570, "Mok'thardin's Enchantment", "Stranglethorn Vale", 38, "mokthardin", 2,
    "Far Seer Mok'thardin at Grom'gol meant to harness the jungle's magic for the Horde. His enchantment began with Shadowmaw Panther claws and a pristine tigress fang.",
    "Mok'thardin promised a powerful enchanted item. First he needed panther claws and a tigress fang without a flaw.",
    "The claws and fang were perfect. Mok'thardin promised to thank the spirits for the beasts' sacrifice to the Horde's cause.",
    "Mok'thardin called the claws and fang perfect, and the jungle knowledge behind them strong.", true)
q(572, "Mok'thardin's Enchantment", "Stranglethorn Vale", 41, "mokthardin", 2,
    "The feline trinkets were only the start. Mok'thardin next wanted Jungle Stalker feathers, worn on the raptors' armbands south of Grom'gol.",
    "Jungle Stalker raptors near the great arena wore feathers on their armbands. Mok'thardin needed them for his ritual.",
    "Excellent, said Mok'thardin, and he promised to prepare the feathers at once.",
    "The Jungle Stalker feathers went to Mok'thardin for preparation.", true)
q(571, "Mok'thardin's Enchantment", "Stranglethorn Vale", 41, "mokthardin", 2,
    "To hold the feathers, claws and fang together, Mok'thardin needed a magical tether. Only a perfect aged sinew from an Elder Mistvale Gorilla, east of Booty Bay, would serve.",
    "The far seer's enchantment needed a tether. Mok'thardin asked for an aged gorilla sinew, which only the elder Mistvale gorillas carried.",
    "The sinew was ideal, Mok'thardin said, and the effort would soon pay off.",
    "One aged gorilla sinew, and Mok'thardin's reagents were nearly complete.", true)
q(573, "Mok'thardin's Enchantment", "Stranglethorn Vale", 44, "mokthardin", 4,
    "One reagent remained, water from a Holy Spring high above the western bluffs. Every race claimed the spring as its own, and naga explorers had reached it.",
    "Mok'thardin's last need was Holy Spring Water. Naga had advanced on the spring in the south.",
    "With the Holy Spring Water, Mok'thardin enchanted the ceremonial choker and gave it to be worn in defense of the Horde.",
    "The ceremonial choker was finished, a gift from the far seer for the Warchief's cause.", true)
fallback("Mok'thardin's Enchantment", "Stranglethorn Vale", "mokthardin", "570,571,572,573",
    "Far Seer Mok'thardin at Grom'gol was preparing an enchantment from jungle reagents.",
    "Mok'thardin's enchantment needed rare reagents gathered across Stranglethorn.",
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
    "The Horde had come to the jungle to supply Stonard, and ogres in the Mizjah Ruins kept ambushing its caravans. Aggro'gosh wanted them driven out.",
    "Despite warnings, ogres from the Mizjah Ruins still raided Grom'gol's caravans. Commander Aggro'gosh wanted a firm message sent.",
    "The work had served the Warchief with honor, said Aggro'gosh.",
    "The Mizjah ogres were attacked in their ruins, and the commander was pleased.", true)
fallback("The Defense of Grom'gol", "Stranglethorn Vale", "gromgol", "568,569",
    "Commander Aggro'gosh was protecting Grom'gol's supply line to Stonard.",
    "Grom'gol's caravans faced threats from the jungle.",
    "Some of the threats to Grom'gol's supply caravans were dealt with.",
    "Aggro'gosh's work protecting the base camp went on.")

q(185, "Tiger Mastery", "Stranglethorn Vale", 31, "nesingwary", 2,
    "Ajeck Rouack had learned tiger hunting from her father as a girl. At Nesingwary's camp she started new hunters easy, on the young tigers nearby.",
    "Every would-be tiger hunter started with Ajeck Rouack on the young cats near the camp, to test their tracking first.",
    "Ajeck Rouack, who ran the tiger trials, called the first hunt nicely done and judged the hunter ready to move on.",
    "The young tigers near the camp were taken, and Ajeck allowed the training to continue.", true)
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
    "Nesingwary's hunting camp set hard trials on Stranglethorn's tigers.",
    "Ajeck judged another tiger trial complete.",
    "Another tiger hunt for Ajeck was finished.")
q(190, "Panther Mastery", "Stranglethorn Vale", 31, "nesingwary", 2,
    "Sir S. J. Erlgadin said anyone hoping to join Hemet's hunting party had to prove an able panther hunter. Ten young panthers were the start.",
    "Sir S. J. Erlgadin started new hunters easy, with young panthers that were half the challenge just to track.",
    "It was a good start, said Erlgadin.",
    "The ten young panthers fell, and Sir Erlgadin approved.", true)
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
    "Erlgadin praised the work of a hunter set on mastering the panthers.",
    "Another panther hunt for Erlgadin was finished.")
q(194, "Raptor Mastery", "Stranglethorn Vale", 34, "nesingwary", 2,
    "Hemet Nesingwary put hunting skills to the test with ten Stranglethorn Raptors, and would not say where to find them.",
    "Finding the beasts was half the challenge, Hemet said. His first raptor test was ten Stranglethorn Raptors.",
    "Nicely done, Hemet said of the first raptor hunt.",
    "Ten Stranglethorn Raptors were taken to Hemet's satisfaction.", true)
q(195, "Raptor Mastery", "Stranglethorn Vale", 36, "nesingwary", 2,
    "Lashtail Raptors were Hemet Nesingwary's next challenge, ten of them.",
    "Hemet stepped up the test with the bloody Lashtail Raptors.",
    "That, said Hemet, was how to get a trophy or two over the hearth.",
    "Ten Lashtails fell, and Hemet praised the killing.", true)
q(196, "Raptor Mastery", "Stranglethorn Vale", 41, "nesingwary", 2,
    "Jungle Stalkers were a cagey breed of raptor, harder to track and kill than the rest. Hemet promised a tip on the best hunting yet for ten of them.",
    "Hemet's next test was the Jungle Stalkers, the cagiest raptors in the jungle.",
    "A true raptor slayer, Hemet declared, and he called the hunt nicely done.",
    "Ten Jungle Stalkers were down, and Hemet was delighted.", true)
q(197, "Raptor Mastery", "Stranglethorn Vale", 43, "nesingwary", 3,
    "Even Hemet had failed to kill a wily raptor that Ajeck called Tethis. Bringing back his talon would be a feat no other big game hunter had managed.",
    "Hemet Nesingwary's best hunting yet was the ferocious raptor Tethis.",
    "Tethis was dead. Hemet hailed a master raptor slayer and liked the ring of it.",
    "The talon of Tethis won Hemet's highest praise.", true)
fallback("Raptor Mastery", "Stranglethorn Vale", "nesingwary", "194,195,196,197",
    "Hemet Nesingwary tested hunters on Stranglethorn's raptors.",
    "Raptor Mastery was one of the trials of Nesingwary's hunting camp.",
    "Hemet cheered the hunter's work against the jungle's raptors.",
    "Another raptor hunt for Hemet was finished.")
q(208, "Big Game Hunter", "Stranglethorn Vale", 43, "nesingwary", 4,
    "Hemet had one beast in mind above the rest, King Bangalash. The white tiger was the reason he had come to Stranglethorn.",
    "Hemet Nesingwary had his sights on King Bangalash, a white tiger. Killing it, he said, would prove hunting skill second to none.",
    "King Bangalash was dead. Hemet welcomed a comrade to his hunting party, one whose skill no one would doubt.",
    "Hemet cheered the death of King Bangalash, a beast others had failed to kill.")
hl(208, "King Bangalash, the white tiger Hemet Nesingwary had come for, was killed. Hemet raised cheers and welcomed a comrade to his hunting party.",
    "Hemet Nesingwary cheered when the white tiger King Bangalash fell.")
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
    "With the four leaders dead, Nara Wildmane said the Barrens had been saved from a cursed future.")
hl(914, "Anacondra, Cobrahn, Pythas and Serpentis, the leaders of the Druids of the Fang, were killed. Their dream gems went to Nara Wildmane in Thunder Bluff.",
    "Nara Wildmane's dreams were free of the Fang leaders' wicked faces, and the Barrens, she said, of a cursed future.")
q(962, "Serpentbloom", "Thunder Bluff", 18, "wailing", 2,
    "Apothecary Zamah served the Royal Apothecary Society from Thunder Bluff. A rare herb called serpentbloom had great potential, Zamah believed, and it grew only deep in the Wailing Caverns.",
    "Serpentbloom grew only in the darkest recesses of the Wailing Caverns. The Royal Apothecary Society wanted it in quantity.",
    "Zamah called the specimens splendid.",
    "Splendid specimens, Zamah said of the serpentbloom, and well done.")
q(1486, "Deviate Hides", "The Barrens", 17, "wailing", 2,
    "As Naralex sank deeper into his nightmare, deviate beasts had risen beneath the Barrens. One of his disciples, Nalpak, believed their hides could serve leatherworkers.",
    "Nalpak saw some good in the evil deviate creatures of the Wailing Caverns. Their hides were for leatherworking.",
    "Nalpak promised that the effort of gathering the deviate hides would not go unnoticed.",
    "Nalpak thanked the gatherer for the deviate hides.")
q(1487, "Deviate Eradication", "The Barrens", 21, "wailing", 3,
    "Naralex had tried to enter the Emerald Dream and regrow the Barrens into forest, but his dream became a nightmare. His disciple Ebru cared less about waking him than about ridding the caverns of the deviate beasts.",
    "Ebru, a Disciple of Naralex, begged for war on the deviate creatures spawned in the Wailing Caverns.",
    "The work in the caverns was the first step toward a restored Barrens, Ebru said, praising the bravery shown there.",
    "The deviate beasts were thinned, and Ebru gave the thanks of the Disciples of Naralex.")
q(1094, "Further Instructions", "The Barrens", 21, "stonetalon", 3,
    "Ziz Fizziks had been booted out of the Venture Company with an envelope of their internal documents, manuals and the Super Reaper 6000 blueprints. Sputtervalve, a little green fellow, had taken up residence in Ratchet.",
    "Fizziks's stolen Venture Company papers were meant for Sputtervalve in Ratchet.",
    "Distrustful of Fizziks, Sputtervalve still judged the information good enough. He wanted the Venture Company gone, though he admitted their machines had their uses.",
    "At Ratchet, Sputtervalve could not say he trusted Fizziks, but the information in the envelope seemed good enough.", true)
q(79192, "Stepping Stones", "The Barrens", 24, "steppingstones", 2,
    "A note spoke of two people making deliveries for the New Plague and of simple apothecary accidents. Its writer offered a safe place to talk, a cozy spot in the mountains between the Barrens and Desolace.",
    "The note's writer called the New Plague delivery mishaps simple apothecary accidents, yet still offered a safe place to talk in the mountains toward Desolace.",
    "At the camp in the mountains, the corner of another note was flapping in the breeze.",
    "Another note waited at the backcountry camp between the Barrens and Desolace.")
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
    "The last of the tests was done. Parqual Fintallas sent the seeker back to Dorn Plainstalker, who had set the first leap.",
    "Many moons seemed to have passed since the first leap, said Dorn. He saw more strength and more understanding now, and gave a reward for seeing his tests to the end.",
    "Back in Thousand Needles, Dorn welcomed the return and rewarded the completed tests.")
q(1176, "Load Lightening", "Thousand Needles", 30, "racecar", 2,
    "Every bit counted in racing, Pozzik said. The goblin team used vulture bones, light and strong, for small tweaks to its racers, and the salt flats were littered with vultures.",
    "Pozzik of the goblin racing team paid a good price for vulture bones from the Shimmering Flats.",
    "Straight away, Pozzik meant to send the vulture bones to his crew for small tweaks to the racers.",
    "Pleased with the vulture bones, Pozzik said his crew could start on them right away.")
q(1178, "Goblin Sponsorship", "The Barrens", 37, "racecar", 2,
    "Gazlowe of Ratchet tracked down parts for the goblin racing team, and had promised Pozzik a prototype fuel regulator weeks ago. It had not come, and the gnomes were gaining.",
    "Pozzik's new fuel regulator was overdue. Gazlowe in Ratchet had promised it, and was usually prompt.",
    "Pozzik, Gazlowe said, had been one of the most respected tinkerers in Undermine. After retiring to the racers, he had designed the two-engine model.",
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
    "Once he had copied the blueprints for his own notes, Revilgaz sent the originals on, so Pozzik would not think a sponsor had abandoned him.",
    "With his own copy made, the Baron sent the blueprints on for Pozzik.", true)
q(1183, "Goblin Sponsorship", "Thousand Needles", 37, "racecar", 3,
    "Baron Revilgaz sent his regards to Pozzik with the blueprints, and hoped to hear of a new best time on the track soon.",
    "The fuel regulator blueprints from Lake Nazferiti were bound for Pozzik on the Shimmering Flats.",
    "Pozzik had hoped for an assembled regulator, but saw a chance to improve the design from the ground up and have it installed soon.",
    "Pozzik took the blueprints and planned to sketch improved schematics of his own.", true)
fallback("Goblin Sponsorship", "Thousand Needles", "racecar", "1178,1180,1181,1182,1183",
    "Pozzik's goblin racing team was waiting on a new fuel regulator.",
    "The search for the racing team's fuel regulator passed between Ratchet and Booty Bay.",
    "The search for the fuel regulator moved on.",
    "Pozzik's racing team was one step closer to a new fuel regulator.")
hl(1183, "Pozzik had the Venture Company's regulator blueprints on the Shimmering Flats, and meant to build a better one from scratch.",
    "Pozzik had his fuel regulator blueprints at last.")
q(1186, "The Eighteenth Pilot", "Thousand Needles", 37, "racecar", 2,
    "Pozzik would be busy fitting the new regulator. Razzeric, the team's eighteenth pilot, liked to add his own modifications, and Pozzik warned he was a little off his rocker.",
    "Pozzik sent help to Razzeric, the goblin team's pilot, warning not to look surprised at him.",
    "Once, Razzeric said, he too had run around the pits helping the mechanics. Now he was the goblin racing team's pilot extraordinaire.",
    "The eighteenth pilot welcomed Pozzik's helper and boasted of his position.")
q(1187, "Razzeric's Tweaking", "Thousand Needles", 41, "racecar", 3,
    "Razzeric liked to load on firepower after Pozzik finished a racer. He had ordered a seaforium booster from Shreev in Gadgetzan, but the zeppelin carrying it had crashed in Dustwallow Marsh.",
    "A seaforium booster for Razzeric's racer lay somewhere in the wreck of a zeppelin in Dustwallow Marsh.",
    "Fifteen pounds of solid seaforium delighted Razzeric, who expected to beat the gnomes twice.",
    "Razzeric called the booster a beauty, fifteen pounds of solid seaforium, and meant to strap it to his racer.")
q(1188, "Safety First", "Tanaris", 41, "racecar", 2,
    "Razzeric blamed Shreev for leaving a safety on the booster that limited its power. He had asked for it off, and wanted the Gizmorium in Gadgetzan to remove it.",
    "Razzeric sent the booster back to Shreev in Gadgetzan to have the safety removed.",
    "Shreev grumbled that only Razzeric would call it a safety lock. The booster was almost all explosives already, but Razzeric always wanted more.",
    "At the Gizmorium, Shreev agreed to change the booster, complaining about Razzeric.", true)
q(1189, "Safety First", "Thousand Needles", 41, "racecar", 3,
    "Shreev made the change and sent a warning. One slight mistake, and Razzeric would be a burnt spot on the track, and who knew if the nineteenth pilot would be any good.",
    "The altered booster went back to Razzeric with Shreev's warning to be careful.",
    "Razzeric was delighted and pictured the gnomes' faces when he set it off, on his way to a new best time on the course.",
    "Razzeric was thrilled to have his booster ready.", true)
fallback("Safety First", "Thousand Needles", "racecar", "1188,1189",
    "Razzeric wanted more power from his seaforium booster.",
    "The goblin pilot's booster passed between the Shimmering Flats and Gadgetzan.",
    "The work on Razzeric's booster moved on.",
    "Shreev handled the booster that Razzeric wanted to run without its safety.")
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
hl(1194, "Rizzle's schematics described refining indurium ore from Uldaman. Pozzik thought its heat resistance might explain the gnomes' new speed.",
    "Pozzik suspected heat-resistant indurium lay behind the gnomes' speed, and wanted more of it.")
q(1179, "The Brassbolts Brothers", "Thousand Needles", 30, "racecar", 2,
    "Pilot Longbeard's gnome friends on the Shimmering Flats had a rocket car so fast its pilots kept crashing and giving themselves concussions. He had siege engine helmets for them, but could not make the trip.",
    "Pilot Longbeard sent siege engine helmets to the Brassbolts brothers, whose rocket car kept knocking out its pilots.",
    "Hooray, said Wizzle Brassbolts. With helmets, perhaps they could talk a pilot into driving the car.",
    "Longbeard's helmets arrived to a hooray from the Brassbolts brothers, who hoped they could find a pilot now.", true)
fallback("The Brassbolts Brothers", "Thousand Needles", "racecar", "1179,2769",
    "The Brassbolts brothers raced a gnomish rocket car on the Shimmering Flats.",
    "The gnome racers of the Shimmering Flats needed supplies from far away.",
    "The Brassbolts brothers' racing effort moved forward.",
    "The gnome racers found new help for their rocket car.")
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
    "Kravel sent the parts on to Fizzle Brassbolts, sure the gnome would not miss the piece he had removed, which he called small and worthless.",
    "The rest of the gnomes' order was for Fizzle Brassbolts on the Shimmering Flats.",
    "Fizzle was thrilled with his hydro ratchets and repeater bolts.",
    "Fizzle Brassbolts had waited a long time for those parts.")

q(4767, "Wind Rider", "Thousand Needles", 29, "freewind", 2,
    "Elu of Freewind Post recruited wyverns for the master wind riders and hoped to become one. They could not train enough wyverns to meet the demand, so he wanted eggs from Highperch.",
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
    "What came of the alien egg left Hagar shaken, and he sent for help. Motega Firemane waited at Whitereach Post, northwest of Freewind.",
    "What Hagar had seen proved that Arikara was real, Motega declared, and it had to be dealt with at once.",
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
    "At Ghost Walker Post, Nataka Longhorn said his brother must trust the messenger, whatever the connection between them.")
q(1147, "The Swarm Grows", "Thousand Needles", 35, "swarm", 3,
    "Belgrom wanted the insect creatures at the dig site pushed back into the depths. Moktar Krin's war party was half dead after fighting the Explorers' League's dwarves and could not do it alone.",
    "Moktar Krin's battered war party needed help against the insect creatures swarming from the dig site to the south.",
    "Laughing, Moktar said the ichor-covered helper reeked enough to start a kodo stampede. The smell alone proved the work against the insects.",
    "Thanks came from Moktar for the fight against the dig site insects.", true)
fallback("The Swarm Grows", "Thousand Needles", "swarm", "1145,1146,1147",
    "Strange insect creatures were proving a bigger threat than the Horde had first thought.",
    "Korran of the Crossroads warned that the insect creatures were a growing danger to the Horde.",
    "The Horde's answer to the insect threat moved forward.",
    "The fight against the swarm went on.")
-- The horde pack's 1492 entry stands in for this title; a neutral context
-- covers both its crate (1492) and Kravel's parts order (1111).
P.quests["Wharfmaster Dizzywig"] = {zone = "The Barrens", thread = false, importance = 2,
    why = {"Wharfmaster Dizzywig handled the cargo on the Ratchet docks.", "Cargo had to pass through Wharfmaster Dizzywig at the Ratchet docks."},
    after = {"Wharfmaster Dizzywig dealt with the cargo.", "The business at the Ratchet docks was settled."},
    source = {"corpus_vanilla_quests.txt quests 1111,1492"}}
q(1148, "Parts of the Swarm", "The Barrens", 35, "swarm", 3,
    "The insects' carapaces were strong and their bodies highly evolved. Korran might learn from them what the creatures were and where they came from.",
    "A carapace from the dig site seemed worth showing to Korran, who might learn what the creatures were.",
    "News that Moktar had been seen pleased Korran. With the carapaces and the eggs from the Field of Giants, he could start to learn what the insects were and what they wanted.",
    "Word that Moktar was still looking out for him pleased Korran. With the eggs found in the Field of Giants, the specimens gave him a start on what the insects were.", true)
q(1184, "Parts of the Swarm", "Orgrimmar", 35, "swarm", 3,
    "Korran sent word to Belgrom in Orgrimmar that Moktar was doing his bidding well and the study was going forward.",
    "Belgrom Rockmaul in Orgrimmar was to hear of Moktar's work and Korran's progress.",
    "The Warchief would hear of the effort, Belgrom promised, and he wanted to know as soon as Korran learned more about the threat.",
    "Pleased with the report, Belgrom asked for news of Korran's findings.", true)
fallback("Parts of the Swarm", "Thousand Needles", "swarm", "1148,1184",
    "Strange insect creatures with powerful carapaces had turned up in Thousand Needles.",
    "Korran wanted to learn what the insect creatures were and where they came from.",
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
P.threads.world_eranikus = "the fate of Eranikus"
q(698, "Lack of Surplus", "Swamp of Sorrows", 40, "stonard", 2,
    "Dar in Stonard was gathering supplies for the outpost on the beach, where Tok'Kar had little time between guard shifts and cooking. His soldiers liked sawtooth meat, from the older crocolisks only.",
    "Tok'Kar's beach outpost was short of sawtooth meat. Dar in Stonard wanted a shipment taken out to the soldiers.",
    "Fresh meat for the fire pleased Tok'Kar. The nights would be more tolerable, he said, and he joked that Dar's attitude reeked less than his smell.",
    "At the beach outpost, Tok'Kar welcomed the sawtooth meat with thanks.", true)
q(699, "Lack of Surplus", "Swamp of Sorrows", 42, "stonard", 2,
    "Tok'Kar's soldiers watched the coast for murlocs threatening Stonard. Sawtooth snapper claws made fine weapons, and he offered one in return for some.",
    "Tok'Kar needed sawtooth snapper claws for weapons, and promised one as thanks.",
    "The claws went to the outpost's arsenal, and Tok'Kar said long practice would make the weapon quick work.",
    "The snapper claws would do nicely for the outpost's arsenal, Tok'Kar said, and a weapon would be made for their bearer before long.", true)
fallback("Lack of Surplus", "Swamp of Sorrows", "stonard", "698,699",
    "Stonard's beach outpost needed supplies from the swamp's sawtooth crocolisks.",
    "The soldiers on the Stonard coast wanted sawtooth meat for the fire and claws for weapons.",
    "The beach outpost was better supplied.",
    "Supplies from the swamp reached Stonard's coast watch.")
q(1422, "Threat From the Sea", "Swamp of Sorrows", 45, "stonard", 2,
    "While Tok'Kar worked on the weapon, he sent the helper to Katar for beach patrols. He would rather see wits kept sharp than spent drinking with the camp's louses.",
    "Katar, on Stonard's beach, wanted help with patrols against the murlocs.",
    "Over the roar of the sea, Katar pointed out the gurgles of the fish men.",
    "On the beach, Katar heard the murlocs and called for silence.", true)
q(1426, "Threat From the Sea", "Swamp of Sorrows", 43, "stonard", 3,
    "Katar had no love for the sea or anything that came out of it, and enjoyed watching the fish men die at Horde hands. He dared his helpers to face even their most powerful kind.",
    "On the Stonard coast, Katar wanted to see how many murlocs could be slain, and the strongest among them.",
    "The sea, Katar said, had been stained with the blood of its own spawn. Now the murlocs would have to rebuild their ranks, and he would smile at every scream.",
    "Many murlocs were dead along the beach, and Katar offered more reward for more.", true)
q(1427, "Threat From the Sea", "Swamp of Sorrows", 43, "stonard", 2,
    "Katar sent word that Tok'Kar had finished a few weapons, and would offer one for the help on the beach.",
    "Katar advised a visit to Tok'Kar before any rest, since the smith had finished a few weapons.",
    "For the sawtooth meat and for a smile on Katar's face, Tok'Kar offered one of his new weapons.",
    "A weapon from Tok'Kar's forge was the reward for the beach patrols.", true)
fallback("Threat From the Sea", "Swamp of Sorrows", "stonard", "1422,1426,1427",
    "Murlocs from the sea threatened the Horde on the coast of the Swamp of Sorrows.",
    "Katar and Tok'Kar held the beach against the fish men.",
    "The fight against the murlocs on the beach went on.",
    "The Horde's watch on the coast had help against the fish men.")
q(1428, "Continued Threat", "Swamp of Sorrows", 45, "stonard", 2,
    "Katar wanted more fish men found along the beach, and promised a reward for diligence.",
    "More murlocs crawled up the Stonard coast. Katar asked for them slain.",
    "More fish men died, and Katar called for the rest to perish.",
    "Well done, said Katar, and he called for more murloc blood.")
q(1430, "Fresh Meat", "Swamp of Sorrows", 44, "stonard", 2,
    "Dar's customers wanted crawler meat, especially from the monstrous crawlers on the coast east of Stonard. He would ship the legs to Orgrimmar.",
    "Monstrous crawler legs fetched a good price with Dar, who sent them on to Orgrimmar.",
    "Dar could not wait to taste the legs cooked over an open fire, and offered a sample.",
    "Perfect, said Dar of the crawler legs. Over an open fire they were delicious, and he offered a sample for the journey.")
q(1429, "The Atal'ai Exile", "The Hinterlands", 44, "atalai", 3,
    "Fel'Zerul's scout had found a scroll written in blood on dried flesh, a sentence against an Atal'ai priest. The priest had been exiled to the Witherbark of the Hinterlands, and Fel'Zerul wanted the artifacts' true use learned from him.",
    "The Atal'ai exile lived among the Witherbark in the Hinterlands. Fel'Zerul in Stonard sent him a bundle of artifacts to explain.",
    "Recognizing the summoning artifacts, the exile saw that Jammal'an the Prophet was leading his disciples toward their chosen fate, and wondered whether Hakkar had returned to the temple.",
    "Among the Witherbark, the Atal'ai exile examined the artifacts and spoke of Jammal'an the Prophet.")

q(1396, "Encroaching Wildlife", "Swamp of Sorrows", 37, "biggs", 2,
    "Watcher Biggs's caravan had been bound for the eastern coast when Lost Ones attacked it. He alone had survived, sworn to guard the supplies, and beasts were closing in on his camp.",
    "Watcher Biggs, last survivor of an attacked caravan, needed the swamp's beasts kept away from his camp.",
    "The animal sounds grew faint and distant, and Biggs hoped they would not return.",
    "Biggs heard the beasts' cries fade into the distance, at least for now.")
q(1421, "The Lost Caravan", "Swamp of Sorrows", 35, "biggs", 3,
    "Before he blacked out, Biggs had seen a wagon dragged to Fallow Sanctuary, the Lost Ones' village to the north. Its chest held reagents vital to the wizards of Nethergarde Keep.",
    "A caravan chest of reagents for Nethergarde had been taken to the Lost Ones' Fallow Sanctuary. Watcher Biggs wanted it back.",
    "With the reagents back, Nethergarde's wizards could go on with their work. Biggs did not know what it was, only that it concerned the Dark Portal and the Alliance's security.",
    "The reagents were taken back from Fallow Sanctuary and returned to Biggs.")
q(1398, "Driftwood", "Swamp of Sorrows", 42, "biggs", 2,
    "Biggs had to fix his wagon to reach Nethergarde, and the swamp's spongy wood would not serve. Sun-dried driftwood from the coast would.",
    "Watcher Biggs asked for sun-dried driftwood from the eastern coast to mend his wagon.",
    "Light but tough, the driftwood would work nicely, Biggs said.",
    "Biggs found the driftwood light but tough, and said it would work nicely.")
q(1425, "Deliver the Shipment", "Blasted Lands", 42, "biggs", 3,
    "While he fixed the wagon, Biggs packed the most vital supplies saved from the attacks for Nethergarde Keep, watching over the Dark Portal in the Blasted Lands.",
    "Watcher Biggs sent his caravan's surviving supplies on to Nethergarde Keep.",
    "Quartermaster Lungertz had thought Biggs and his caravan lost. He hoped the package held Azoran crystals, a reagent the keep was running low on.",
    "Nethergarde had given up Biggs and his caravan for lost, and then his package arrived.")
hl(1425, "Biggs's surviving supplies came to Nethergarde Keep, where the quartermaster had given the caravan up for lost.",
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
    "The coyotes, Neeka said, would no longer tear through Kargath's supplies.")
q(1420, "Report to Helgrum", "Swamp of Sorrows", 40, "kargath", 3,
    "Neeka wrote a fresh report for Helgrum in Stonard, and warned its runner not to get lost or fall to an enemy.",
    "Neeka Bloodscar's fresh report had to reach Helgrum the Swift in Stonard.",
    "From Neeka's report, Helgrum learned the Alliance had its own troubles in the Badlands, and that some enemies might be shared.",
    "Helgrum the Swift had Neeka's report at last.")

-- 3374 and the shared-title fallback for "The Essence of Eranikus" live with 3373 in the
-- band5060 Sunken Temple batch below (writer pass 2026-11-06: the earlier pair here was dead).
q(3512, "In Eranikus' Own Words", "Winterspring", 55, "eranikus", 4,
    "Eranikus lay between sleep and death, twisted in nightmares. To speak with him through the gem, Itharius sent for Umbranse the Spiritspeaker, a human medium in eastern Winterspring.",
    "Itharius needed a way to reach Eranikus through the tainted essence. Umbranse the Spiritspeaker, who spoke for the dead, might help.",
    "Death-speaking was Umbranse's skill, and he offered it. His most potent augury device had been taken, though, and without it he could not help Eranikus.",
    "Help would come from the Spiritspeaker once his stolen augury device was recovered.")
hl(3512, "Umbranse the Spiritspeaker would help Itharius reach Eranikus, once his stolen augury device came back.",
    "Umbranse, the medium, agreed to speak with Eranikus, but his augury device was missing.")
for _, id in ipairs({698, 699, 1422, 1426, 1427, 1428, 1430, 1429, 1396, 1421, 1398, 1425, 1418, 1419, 1420, 3512}) do src(id) end
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
    "Shadowforge Dark Irons had attacked the excavation site north of Prospector Ryedol's camp and, he said, killed nearly everyone, his boss Hammertoe among them. One of them had his lucky pick.",
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
    "Ryedol guessed the Shadowforge had learned how much Hammertoe and Historian Karnik knew. He sent the amulet to Karnik.",
    "Grief for Hammertoe would have to wait, Karnik said. He began to show why the amulet was so valuable.",
    "Historian Karnik took Hammertoe's amulet and said its sender had understood what was at stake.", true)
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
    "With the king's authority behind him, Historian Karnik named Angor Fortress as the place to strike.", true)
fallback("Passing Word of a Threat", "Ironforge", "uldaman", "725,726",
    "Word of the Shadowforge's work in the Badlands passed between Ironforge's historians and advisors.",
    "Historian Karnik and Advisor Belgrum weighed the threat from the Shadowforge.",
    "The warning about the Shadowforge moved on.",
    "Karnik and Belgrum each learned more of the Shadowforge threat.")
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
    "Lotwil had thought the slabs would take half a dozen tauren to carry, and said so.", true)
q(712, "Study of the Elements: Rock", "Badlands", 42, "lotwil", 3,
    "Bracers of rock binding from the greater elementals would let Lotwil gauge the strength of his shackles. He wanted five, since Servo often misplaced his reagents.",
    "Lotwil Veriatus needed bracers of rock binding from the greater rock elementals southwest of his camp.",
    "A career as a research assistant, Lotwil suggested, would suit such intelligence, curiosity and strength.",
    "Such help would be missed, Lotwil said, and he asked after a career as his research assistant.", true)
fallback("Study of the Elements: Rock", "Badlands", "lotwil", "710,711,712",
    "Lotwil Veriatus studied the Badlands' rock elementals for his shackles of binding.",
    "Lotwil's elemental shackles needed pieces of the Badlands' rock elementals.",
    "Lotwil's study of the rock elementals moved forward.",
    "Another set of elemental samples reached Lotwil.")
q(713, "Coolant Heads Prevail", "Badlands", 37, "lotwil", 2,
    "Frost oil cooled gears and helped enchantments hold. Lotwil needed a vial for his shackles, strong enough to keep the summoned elemental from killing them all, and Bro'kin in Alterac could teach the making.",
    "Lotwil Veriatus wanted a vial of frost oil for his shackles. A goblin friend, Bro'kin, in Alterac, knew the recipe.",
    "Stupendous, said Lotwil. If the enchantments did not last a century, he would give all his belongings to Servo.",
    "Stupendous, Lotwil called the frost oil, the perfect coolant for his new bracers; all the mages of the Assembly would be in awe.")
q(714, "Gyro... What?", "Badlands", 37, "lotwil", 2,
    "Lotwil was distracted by his work, offered a job if they ever met in Kharanos, and needed one last small part, a gyrochronatom.",
    "Lotwil Veriatus needed a gyrochronatom to finish his contraption.",
    "Grabbing the gyrochronatom, Lotwil declared himself almost done, then allowed it might take a lot longer.",
    "The gyrochronatom was about to go into Lotwil's contraption, which he claimed was nearly finished.")
q(734, "This Is Going to Be Hard", "Badlands", 42, "lotwil", 2,
    "Lotwil needed a cog number five, and Lucien Tosselwrench had it.",
    "Lucien Tosselwrench was to hand over a cog number five for Lotwil's shackles.",
    "Told that Lotwil wanted cog number five, Lucien said this was not going to be good.",
    "Cog number five, Lucien Tosselwrench said, meant trouble.", true)
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
    "The work at Lotwil's camp moved on to its next step.")
hl(778, "Lotwil's summoning went wrong in a way he could not explain, and his magic sent the elemental home. He gave a token for the ordeal.",
    "Lotwil Veriatus's great summoning went wrong, and the creature was banished.")
q(703, "Barbecued Buzzard Wings", "Badlands", 40, "badlands", 2,
    "Rigglefuzz had everything for his barbecued buzzard wings except the wings. Enough of them might win the recipe.",
    "The smell of Rigglefuzz's barbecued buzzard wings brought the hungry from miles away, he said, but he had no wings.",
    "Rigglefuzz could almost taste the wings already, and he handed over his recipe.",
    "Rigglefuzz meant to start on the buzzard wings right away, and shared the recipe as thanks.")
q(705, "Pearl Diving", "Badlands", 37, "badlands", 2,
    "Rigglefuzz scared off Badlands wildlife with flash bombs, and was low on crushed blue pearl. The pearls came from the clams of the Vile Reef in Stranglethorn.",
    "A small goblin had to be tricky to survive in the Badlands. Rigglefuzz needed blue pearls from Stranglethorn for his flash bombs.",
    "Smash, mix, and the scavengers would be flashed, Rigglefuzz said.",
    "Soon the blue pearls would be flash bomb powder, Rigglefuzz said.")

q(4022, "A Taste of Flame", "Burning Steppes", 54, "cyrus", 3,
    "Cyrus Therepentous in the Burning Steppes said the Flight knew of the work done in the Searing Gorge. He demanded to see the molt.",
    "With sharp insults, Cyrus Therepentous demanded to see the molt from the Searing Gorge.",
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
    "Cyrus Therepentous of the Burning Steppes made hard demands of the mortals who came to him.",
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
    "A temple sunk beneath the Pool of Tears and ringed by green dragons was an amazing discovery, Brohann said, though something had plainly gone terribly wrong.")
q(1449, "To The Hinterlands", "The Hinterlands", 43, "atalai", 2,
    "Brohann had flown over the swamp with a gryphon pilot from Aerie Peak, who fell from his mount. He could not recall the pilot's name, but Falstad Wildhammer would.",
    "To learn what became of his lost pilot, Brohann sent the question to Falstad Wildhammer at Aerie Peak.",
    "Falstad had trolls coming out of the woodwork and little patience for chatter.",
    "Falstad Wildhammer of Aerie Peak told the visitor to make it snappy.")
q(1450, "Gryphon Master Talonaxe", "The Hinterlands", 43, "atalai", 2,
    "Falstad had no time for Explorers' League errands, and sent all questions about flight assignments to Gryphon Master Talonaxe.",
    "The aviary's flight records were Gryphon Master Talonaxe's business, Falstad said.",
    "Talonaxe remembered lending Brohann his best rider, Rhapsody Shindigger. His own father had helped excavate Uldaman, and he had a soft spot for the League.",
    "Gryphon Master Talonaxe recalled the rider he had sent with Brohann, a fine gryphon jockey named Rhapsody Shindigger.")
q(1451, "Rhapsody Shindigger", "The Hinterlands", 43, "atalai", 2,
    "No one flew like Rhapsody Shindigger, but he took to drink after the flight with Brohann, and Talonaxe had to let him go. He had set up a brew camp east of the aerie.",
    "Talonaxe's old rider Rhapsody had become a drunk and left the aviary. He kept a brew camp to the east.",
    "Rhapsody hiccuped, complained that the visitor kept bobbing up and down, and felt the ground shake.",
    "At his brew camp, Rhapsody Shindigger was very drunk.")
q(1452, "Rhapsody's Kalimdor Kocktail", "The Hinterlands", 43, "atalai", 2,
    "Rhapsody would only tell what happened over the swamp with a stiff drink in him. His Kalimdor Kocktail needed roc gizzards from Tanaris and groddoc and ironfur livers from Feralas.",
    "Before reliving that flight, Rhapsody Shindigger wanted a Kalimdor Kocktail, brewed from livers and gizzards from far-off Kalimdor.",
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
    "It was bad news and good news at once, Talonaxe said, since the Vilebranch performed sacrifices at that altar. A greater task still lay ahead.",
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
    "Royalty commanded the naga, and scouts had named one of the crueler royals, Lord Shalzaru. He had dug up an odd relic in a cave on the Isle of Dread.",
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
    "Fewer ogres now roamed the High Wilderness, and Angelas wanted the deed hidden from Troyas.")
q(2939, "In Search of Knowledge", "Darnassus", 47, "troyas", 2,
    "Troyas Moonbreeze had found a stave in the ruins of Feralas that seemed more than ordinary. His colleague Daryn Lightwind in Darnassus might know what it was.",
    "Troyas sent questions about his strange stave to Daryn Lightwind, a historian in Darnassus.",
    "Daryn muttered that Troyas always thought he had found something important. In her view, ogres or harpies had long since hoarded anything of value, but she let the visitor look.",
    "Daryn Lightwind doubted Troyas's find and offered only the run of her shelves.")
q(2940, "Feralas: A History", "Darnassus", 47, "troyas", 2,
    "A worn, yellowed history of Feralas looked like what Troyas needed. It had to be borrowed from Daryn properly.",
    "Daryn Lightwind's shelves held an old history of Feralas that might explain the stave.",
    "Lending it, Daryn decided, would cost a favor first.",
    "The old history of Feralas could be borrowed, Daryn agreed, but only once a task was done for her.")
q(2941, "The Borrower", "Tanaris", 48, "troyas", 2,
    "Daryn's latest fascination was the snapjaws of the Hinterlands, and above all a giant one named Gammerita. Curgle Cranklehop in Tanaris had made her a device to capture a picture.",
    "Daryn Lightwind wanted a picture of Gammerita, and sent a letter to the inventor Curgle Cranklehop in Tanaris.",
    "The visitor looked like another of Daryn's interns to Curgle, who praised the historian and fetched the Super Snapper FX.",
    "The Super Snapper FX, Curgle's newest invention, went to the one she took for Daryn's intern.")
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
    "Troyas had read that it was called the Morrow Stone. He did not yet know its purpose, but he was sure anything hidden away like that was significant.",
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
    "Private Thorsen took the shipment of land mines. He said they would help the camp hold out against Kurzen and his men.",
    "Thorsen was relieved the crate had not been touched, since its land mines would help the rebels defend themselves from Colonel Kurzen.")
q(215, "Jungle Secrets", "Stranglethorn Vale", 33, "kurzen", 4,
    "Private Thorsen had been saved from an ambush, and he knew how it looked. He said Lieutenant Doren had ordered him to rejoin Kurzen's men as a spy.",
    "Thorsen's attempt to get inside Kurzen's Compound had gone wrong, and only Lieutenant Doren could explain his secret mission.",
    "Doren confirmed Thorsen's orders and asked for discretion. Only Yohwa, Thorsen and he had known of the mission, so someone else had betrayed it.",
    "Doren feared for Thorsen's life if word got out. The rebels had once been loyal to Kurzen, and now Doren suspected a traitor among them.")
q(328, "The Hidden Key", "Stranglethorn Vale", 37, "kurzen", 3,
    "Herod's records said nothing of Thorsen, but a small brass key was hidden in a ledger's binding. His notes mentioned a secure strongbox in the Stockpile.",
    "A brass key from Bookie Herod's ledger might open the strongbox his papers described, in the caverns behind Kurzen's Compound.",
    "Herod's bronze-bound strongbox opened to the key. Inside he kept his more valuable coins and belongings.",
    "Bookie Herod's strongbox was found in the Stockpile, and the brass key fit its lock.")
q(329, "The Spy Revealed!", "Stranglethorn Vale", 37, "kurzen", 4,
    "Among Herod's valuables was a muddy note tracking Thorsen's patrols, contacts and habits, signed with a single letter, M.",
    "The note in Herod's strongbox could only have been written by someone close to Thorsen. Its writer was the traitor in the rebel camp.",
    "Lieutenant Doren took the note as the clue the rebels needed to find their traitor.",
    "Doren gave his thanks for the note signed M, and meant to use it to root out the spy.")
q(330, "Patrol Schedules", "Stranglethorn Vale", 37, "kurzen", 3,
    "Doren could not place the M, but its writer had shared Thorsen's patrol the week before, and Corporal Sethman kept the schedules.",
    "Whoever had walked patrol with Thorsen last week had written the note, so Doren sent the question to Corporal Sethman.",
    "Sethman checked his schedule. Private Merle had shared every patrol with Thorsen the week before.",
    "Sethman found the name in his records, where Private Merle had kept the same patrol times as Thorsen all week.")
q(331, "Report to Doren", "Stranglethorn Vale", 37, "kurzen", 4,
    "Sethman's answer pointed to Private Merle, and Lieutenant Doren was waiting to hear it.",
    "The patrol records named Merle, and Doren had wanted that information brought back to him.",
    "Lieutenant Doren was pained to learn that Merle had betrayed them. He had thought him a brave soldier, and was relieved the spy was found at last.",
    "Doren had believed Merle's heart was true. Finding him out was still a relief, he said, for with such a spy the rebels would not last long.")
q(210, "Krazek's Cookery", "Stranglethorn Vale", 37, "crockpot", 2,
    "Corporal Kaleb did most of the cooking at the rebel camp. His mechanical pot from Booty Bay had saved him hours until it broke, and he wanted it taken back to Krazek.",
    "Kaleb's broken crock pot had to go back to Krazek, the goblin who had sold it to him in Booty Bay.",
    "Krazek found the steam charger rusted and the fobulator missing teeth. Of course he could fix it, he said, but there was always a price.",
    "Krazek recognized his own crock pot and agreed to repair it, for a price.")
q(627, "Favor for Krazek", "Stranglethorn Vale", 37, "crockpot", 2,
    "While he fixed Kaleb's pot, Krazek wanted bloodstone ore. A cave in Drywhisker Gorge, far north in the Arathi Highlands, held a low grade of it that he still valued.",
    "While he worked on the crock pot, Krazek wanted samples of bloodstone from the Arathi Highlands. Even poor bloodstone was valuable to those who knew its uses.",
    "Krazek called the bloodstone a big favor and paid for it.",
    "Krazek had his bloodstone from Drywhisker Gorge, and paid as promised.")
q(622, "Return to Corporal Kaleb", "Stranglethorn Vale", 37, "crockpot", 2,
    "Krazek had fixed the pot and added a steam whistle and a chopper for leg bones. He was sure its owner would be pleased.",
    "The repaired crock pot was ready to go back to Corporal Kaleb, with a few improvements of Krazek's own.",
    "Corporal Kaleb was delighted to have his pot back and could start dinner. He had heard that Booty Bay's goblins sometimes dragged drunk sailors onto slave boats.",
    "Kaleb thanked the courier and set about dinner, hoping Booty Bay had not been too rough on them.")
q(616, "The Haunted Isle", "Stranglethorn Vale", 37, "tides", 3,
    "Krazek gathered rumors for Baron Revilgaz. Sailors in the tavern spoke of a haunted island off the coast, with water elementals and a raving goblin ghost.",
    "Krazek put little stock in ghost stories, but this one about an island off the coast was worth passing to Baron Revilgaz.",
    "Baron Revilgaz remembered something he had once read about the trolls. If Krazek's report was true, the Stone of the Tides might soon join his collection.",
    "Revilgaz heard of the haunted island and thought of the Stone of the Tides, a relic the trolls spoke of.")
q(578, "The Stone of the Tides", "Stranglethorn Vale", 37, "tides", 4,
    "Revilgaz suspected that Gazban, a goblin mage, had found the Stone of the Tides. He wanted the haunted island located, and gave a scrip for the Stormwind Library, where the old account of the Stone could be read.",
    "If water elementals and a goblin mage haunted the island, the baron thought the Stone of the Tides could be his. Someone had to find the island first.",
    "Baron Revilgaz was thrilled that the stories were true. To take the Stone, its curse would have to be broken, and that needed a wizard.",
    "Revilgaz now knew the island and its elementals were real, but a mage would have to help him overcome the Stone's curse.")
q(601, "Water Elementals", "Stranglethorn Vale", 37, "tides", 3,
    "The Stone of the Tides made its bearer fade in and out of existence. A mage of Dalaran, Revilgaz hoped, could study the magic left on the water elementals' bracers.",
    "Revilgaz believed Gazban had summoned the island's water elementals. Their bracers carried magical residue that might show how to counter the curse.",
    "Revilgaz could not judge the bracers himself and would not leave Booty Bay to chat with old mages. They were to go to Dalaran.",
    "Baron Revilgaz had his bracers and was sure at least one would help, though a mage in Dalaran would have to examine them.")
q(602, "Magical Analysis", "Alterac Mountains", 37, "tides", 3,
    "Revilgaz named Archmage Ansirem Runeweaver, whose knowledge he trusted. The mages of Dalaran were busy rebuilding their city, but Revilgaz was sure none could resist a magical puzzle.",
    "The bag of water elemental bracers went to the ruins of Dalaran. Revilgaz had dealt with Ansirem Runeweaver before.",
    "Archmage Ansirem had once written a tome on the legends of the Gurubashi Empire. He knew the Stone well, and found residue on one bracer to analyze.",
    "Ansirem Runeweaver took an interest at once, since at least one of the bracers held magic he could study.")
q(603, "Ansirem's Key", "Stranglethorn Vale", 37, "tides", 3,
    "Ansirem found that the Stone's power was amplified through an altar. An ancient troll dagger could overpower it, but he had given the blade to his daughter Catelyn, who ran off to Booty Bay to be a pirate.",
    "The altar could be broken with a troll dagger Ansirem had found in Stranglethorn. It now belonged to his daughter, Catelyn the Blade of Booty Bay.",
    "Catelyn the Blade no longer had the dagger. She had lost a knife fight to a Bloodsail Buccaneer, and he had taken the blade as spoils.",
    "Catelyn took the request badly. Once the best knife fighter in Booty Bay, she had lost her blade to one of the Bloodsail.")
q(610, "\"Pretty Boy\" Duncan", "Stranglethorn Vale", 39, "tides", 3,
    "Surprised that her father had not given up on her, Catelyn said her dagger was with Pretty Boy Duncan of the Bloodsail Buccaneers.",
    "Duncan had knocked Catelyn out with a blow to the head and taken her knife. She wanted it back from him by force.",
    "Catelyn had her dagger back from Duncan. She joked that she would not be challenging her helper to a fight any time soon.",
    "Catelyn the Blade had her knife again, and admitted that beating Duncan showed more experience than she had first guessed.")
q(611, "The Curse of the Tides", "Stranglethorn Vale", 40, "tides", 5,
    "Catelyn lent her dagger and wanted it back afterward. She had heard of a sunken troll city near the haunted island, where the altar might lie.",
    "With Catelyn's knife, the altar that strengthened the Stone could be broken. She pointed the search to a sunken troll city off the coast.",
    "Baron Revilgaz had cleared a place and bought a stand for the Stone of the Tides. He admired how a tide seemed trapped within its surface.",
    "Amazing, Revilgaz called the Stone of the Tides, and promised it a place of prominence among his troll artifacts.")
q(575, "Supply and Demand", "Stranglethorn Vale", 31, "excelsior", 2,
    "Drizzlik, a leatherworker in Booty Bay, had an order from Director Riddlevox of the Tinkers' Union for a dozen Excelsior boots. Their basic shape needed river crocolisk skins.",
    "Drizzlik called himself the finest leathercrafter of the South Seas. Riddlevox's order for Excelsior boots began with crocolisk skins from the northern rivers.",
    "Drizzlik accepted the skins for the boots' inner layer, and if they were too stiff, tiger blood would soften them.",
    "Drizzlik had his skins. Their quality mattered little inside the boots, as long as they were comfortable.")
q(577, "Some Assembly Required", "Stranglethorn Vale", 36, "excelsior", 2,
    "Drizzlik's boots needed more filling than the first skins gave. The thicker, cheaper hides of the crocolisks around Lake Nazferiti would do, Drizzlik decided.",
    "Nobody would see the inner layers, Drizzlik reasoned, so cheaper skins from Lake Nazferiti would do.",
    "Drizzlik compared his boots to sausages, since it was safer, he said, not to ask too carefully what was inside.",
    "Drizzlik filled out the boots and promised only the finest ingredients, so long as no one looked closely.")
q(628, "Excelsior", "Stranglethorn Vale", 38, "excelsior", 3,
    "Only the skin of an elder saltwater crocolisk would do for the outer layer, and the elders came out only to defend the other crocolisks.",
    "An elder saltwater crocolisk's hide would be the canvas for Drizzlik's Excelsior designs.",
    "Drizzlik could ship Riddlevox's order to Undermine on the next boat, ahead of schedule. He gave a pair of the extras as thanks.",
    "With the elder crocolisk skin, Drizzlik could fill Riddlevox's order early. He handed over a spare pair, on the house.")
hl(215, "Private Thorsen had been spying on Kurzen at Doren's order. Doren confirmed it and saw that someone else must have betrayed the secret.",
    "Lieutenant Doren confirmed Thorsen's secret mission, and since only three had known of it, the rebels had a traitor.")
hl(331, "Lieutenant Doren learned that Private Merle was the traitor. He grieved for a soldier he had trusted, and was relieved the spy was found.",
    "Doren was pained that Merle had betrayed the rebels. Finding him out was a relief, since such a spy would have doomed them against Kurzen.")
hl(578, "Baron Revilgaz learned that the haunted island was real. The Stone of the Tides was there, behind a curse only a wizard could help with.",
    "Revilgaz was thrilled that the stories of the haunted island were true, though breaking the Stone's curse would need a mage.")
hl(611, "Freed from its altar with Catelyn's dagger, the Stone of the Tides was promised a place of prominence among Baron Revilgaz's troll artifacts.",
    "Revilgaz had already bought a stand for the Stone of the Tides. Magnificent, he said; a tide seemed trapped within its surface.")
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
    "Samaul introduced himself and agreed to help, briefly, warning that ogres, orcs, murlocs and black dragons waited in the marsh beyond the city.", true)
q(1265, "The Missing Diplomat", "Dustwallow Marsh", 35, MD3, 4,
    "Samaul knew Hendel, and did not like that Elling had sent someone to him. He had a duty to protect the land, but said Hendel was posted at the first tower outside Theramore.",
    "Commander Samaul guessed that Elling's business was troubling. He pointed the way to the first tower outside the city, where Hendel had been stationed.",
    "Hendel was not at the tower. Lady Proudmoore had already learned of the matter from other sources, and offered help to find him and bring him to justice.",
    "Lady Proudmoore's people already knew why Hendel was wanted, and offered to say where he was so he could face justice.", true)
q(1266, "The Missing Diplomat", "Dustwallow Marsh", 36, MD3, 4,
    "Private Hendel was west of the tower, guarding Theramore's infiltrators while they rested. They had been watching the Horde at Brackenwall.",
    "Hendel was on guard among the tents along the road, west of the tower. Archmage Tervosh promised to catch up soon.",
    "Private Hendel greeted the visitor as a wandering citizen. He warned of ogres and spoke of the slow search for a Horde base in the swamp.",
    "Hendel was found at the infiltrators' tents, and told the visitor to keep the questions short and watch for ogres.", true)
q(1362, "The Kolkar of Desolace", "Desolace", 32, "centaur", 3,
    "The Kolkar centaur had spread from Desolace into the Barrens, but their strength lay in Desolace. Regthar had sent Felgur Twocuts to Ghost Walker Post to learn how to deal with them.",
    "Regthar Deathgate wanted the Kolkar threat ended at its source, and his agent Felgur Twocuts was gathering intelligence in Desolace.",
    "Felgur Twocuts welcomed someone sent by Regthar. He did not know how the campaign against the centaur would end, only that it would be long.",
    "Felgur said the struggle with the centaur would be long, then offered a seat and began to explain.")
q(1453, "Reclaimers' Business in Desolace", "Desolace", 33, "reclaimers", 2,
    "Reclaimers Inc. had work in Desolace. Its man, Kreldig Ungor, was holed up at Nijel's Point, a small camp hidden in the northern mountains.",
    "Kreldig Ungor needed hands at Nijel's Point. The Reclaimers had sent word that there was a good week's honest work for anyone who went.",
    "Kreldig Ungor was glad to see that the Reclaimers had both work and willing helpers. Everyone had lost something, he said, and for the right price they could find it.",
    "Kreldig Ungor welcomed the new hand at Nijel's Point and called helping the Reclaimers a smart move.")
q(5821, "Bodyguard for Hire", "Desolace", 35, "gizelton", 3,
    "Cork Gizelton and Rigger stopped their kodo caravan whenever they heard the Kolkar war drums. This time Cork offered pay for an escort past the Kolkar village.",
    "The Gizelton caravan needed a guard past the Kolkar centaur. Dead traders made no profit, Cork said, and the reward waited with Smeed Scrabblescrew.",
    "Smeed Scrabblescrew paid for the caravan's safe passage, grumbling at the cost. If he were taller, he said, he would ride shotgun himself.",
    "Smeed paid the guard and grumbled about the price. Were he a bit taller, he claimed, he would ride along with a big gun and show the centaur himself.")
q(5943, "Gizelton Caravan", "Desolace", 38, "gizelton", 3,
    "Rigger Gizelton and Cork had started the caravan to make a fortune. The demons of Mannoroc Coven usually ignored them, but this time the kodos were spooked.",
    "Rigger needed his caravan guarded past Mannoroc Coven, and once it was through, Smeed at Scrabblescrew's Camp would pay.",
    "Smeed paid again for the Gizelton Caravan's protection. As long as Cork and Rigger kept paying for his kodos, he cared little how they ran their business.",
    "Smeed Scrabblescrew paid the escort's wage and noted that Cork and Rigger made only a gold piece a week.")
q(1458, "Reagents for Reclaimers Inc.", "Desolace", 33, "reclaimers", 2,
    "Kreldig was collecting reagents for Leftwitch, a gnome mage in Kharanos, though Roetten ignored how short-handed the crew was. The list began with Hatefury satyr horns and claws.",
    "Leftwitch's reagent list had come to Desolace with the Reclaimers, and Kreldig started with the satyr to the east.",
    "Kreldig was not sure the horns and claws were the quality Leftwitch wanted, and said the mage should have specified.",
    "Kreldig took the satyr horns and claws and turned to the next item on Leftwitch's list.", true)
q(1459, "Reagents for Reclaimers Inc.", "Desolace", 35, "reclaimers", 2,
    "Leftwitch was particular. The venom had to come from scorpashi, and the hide from an aged kodo rather than a dying or ancient one.",
    "Next on Leftwitch's list were scorpashi venom and aged kodo hide, the strange things mages wanted, in Kreldig's view.",
    "Kreldig said the help was halving his time in Desolace. Once he was home in Ironforge, he would buy an ale.",
    "Kreldig welcomed the venom and hides. He was already thinking of warming his feet in Ironforge.", true)
q(1466, "Reagents for Reclaimers Inc.", "Desolace", 40, "reclaimers", 3,
    "The last of Leftwitch's reagents came from the demons of Mannoroc Coven. He wanted brains from mana eaters, wings from nether maidens and blood from doomwarders.",
    "Kreldig warned that the final list would take longer, since it meant fighting demons. He would understand anyone who passed on it.",
    "Kreldig could hardly believe the demon reagents had been gathered, and meant to tell Roetten about it in Ironforge.",
    "Kreldig praised anyone who could take on demons for a mage's experiments and come back whole.", true)
q(1467, "Reagents for Reclaimers Inc.", "Ironforge", 40, "reclaimers", 2,
    "Payment for Leftwitch's reagents waited with Roetten in Ironforge. Kreldig sent the package there and promised a good word.",
    "Roetten Stonehammer would pay for the package from Desolace. Kreldig expected to follow home soon.",
    "Roetten appreciated the work and the timeliness, and paid. Reclaimers Inc. always paid well for a hard week's work, he said.",
    "Roetten was glad to have the package off his hands and paid the promised wage for the week's work.", true)
fallback("Reagents for Reclaimers Inc.", "Desolace", "reclaimers", "1458,1459,1466,1467",
    "Kreldig Ungor was gathering reagents in Desolace for Leftwitch, a gnome mage in Kharanos.",
    "Leftwitch's reagent list kept the Reclaimers busy in Desolace.",
    "The Reclaimers' work on Leftwitch's order moved forward.",
    "Another part of Leftwitch's list was done.")
q(6141, "Brother Anton", "Desolace", 39, "scarletpath", 3,
    "Brother Crowley's brother in arms, Anton, had heard of undead in Desolace and sailed there at once. He wanted brave helpers at Nijel's Point.",
    "In distant Desolace, Brother Anton of the Scarlet Crusade was hunting undead, and Crowley in Stormwind sent help his way.",
    "Brother Anton had heard that aid was coming from the east. He asked whether the newcomer had come to help the Crusade, and began to explain.",
    "Anton welcomed the help from the east and began to explain what the Crusade needed.")
q(261, "Down the Scarlet Path", "Desolace", 39, "scarletpath", 3,
    "Brother Anton saw the Scourge as an evil that had to be stopped. To prove allegiance to the Scarlet Crusade, he asked for the undead ravagers of the Valley of Bones to be destroyed.",
    "The Crusade would embrace those who fought the Scourge, Anton said, and his test lay in the Valley of Bones to the south.",
    "Brother Anton commended the resolve shown against the ravagers. Perhaps, he suggested, the newcomer's path lay with the Crusade.",
    "Anton said the Scarlet Crusade commended the work in the Valley of Bones.", true)
q(1052, "Down the Scarlet Path", "Hillsbrad Foothills", 40, "scarletpath", 3,
    "Anton was proud of the Crusade's strongholds from Hearthglen to Tirisfal. The true threat lay in Lordaeron, he said, and he sent a sealed commendation to Raleigh the Devout in Southshore.",
    "Brother Anton's letter would earn a place of honor at the Scarlet Monastery, he said. The letter was for Raleigh the Devout in Southshore.",
    "Raleigh the Devout read the letter with dismay, saying Brother Anton was still spreading the word of the Scarlet Crusade.",
    "In Southshore, Raleigh took the sealed letter and murmured that Brother Anton was still preaching for the Crusade.", true)
fallback("Down the Scarlet Path", "Desolace", "scarletpath", "261,1052",
    "Brother Anton of the Scarlet Crusade was recruiting in Desolace.",
    "Anton's recruitment for the Scarlet Crusade began with the undead of Desolace.",
    "Brother Anton's recruitment moved a step further.",
    "The path Brother Anton laid toward the Scarlet Crusade went on.")
hl(1266, "Private Hendel was found at the infiltrators' camp west of Theramore, and took the visitor for a wandering citizen.",
    "Private Hendel stood guard at a camp of Theramore infiltrators, and told the visitor to keep the questions short.")
hl(1466, "Kreldig Ungor could hardly believe Leftwitch's demon reagents had been gathered from Mannoroc Coven. He meant to praise the work to Roetten.",
    "The last of Leftwitch's list came from the demons of Mannoroc Coven. Kreldig promised a good word in Ironforge.")
hl(1052, "In Southshore, Raleigh the Devout read Anton's commendation with dismay. Brother Anton, he said, still spread the word of the Scarlet Crusade.",
    "Raleigh the Devout read Anton's sealed letter in Southshore, surprised that Anton still preached for the Crusade.")
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
    "Locheed had hidden in an outhouse from the Dark Iron geologists, and they had locked him in. He wanted them taught a lesson, and some silk cloth.",
    "Locked in a Dark Iron outhouse, Locheed asked for revenge on the geologists, and for silk cloth, for reasons he would not explain.",
    "Locheed liked the feel of the silk. Then he remembered the geologists, and said the help gave him time to finish up in there.",
    "Locheed was delighted with the silk cloth. The beaten geologists seemed to come second.")
q(4450, "Ledger from Tanaris", "Tanaris", 46, "locheed", 2,
    "Locheed had taken a job in Tanaris for Krinkle Goodsteel, who wanted materials from the Searing Gorge and elsewhere. He slid Krinkle's ledger under the outhouse door.",
    "The goods on Krinkle Goodsteel's ledger, which came from under Locheed's door, had to be gathered and carried to Gadgetzan.",
    "Krinkle Goodsteel had expected to be asked to craft something. Instead every item on the list had been brought, and Krinkle offered a reward.",
    "Krinkle checked the goods against the ledger and found everything there, then paid despite a busy day.")
q(4451, "The Key to Freedom", "Searing Gorge", 47, "locheed", 3,
    "A small brass key turned up, marked Dark Iron Outhouse and warning against copies, though where it belonged was not yet clear.",
    "The words scratched on the brass key named a Dark Iron outhouse.",
    "Locheed knew the Dark Irons had hidden the key after locking him in. He asked for the key to be turned so he could get out.",
    "Locheed could hardly believe the key had been found. Freedom was a turn of the lock away.")
q(3181, "The Horn of the Beast", "Loch Modan", 48, "margol", 3,
    "Margol's giant horn held a broken axe head marked as the property of Mountaineer Pebblebitty. It shattered when pulled free.",
    "The horn bore Pebblebitty's name on the axe head lodged in it, and that mountaineer guarded the gate between Loch Modan and the Searing Gorge.",
    "Pebblebitty called the horn a fake, since he had faced Margol, he said, and her horn was eight times larger.",
    "Mountaineer Pebblebitty was not fooled, or thought he was not. The horn, he decided, came from some Barrens stormsnout.")
q(3367, "Suntara Stones", "Searing Gorge", 48, "suntara", 3,
    "Dorius Stonetender lay badly hurt in the Searing Gorge, bleeding inside. He begged for help getting back to Ironforge.",
    "Injured and dizzy, the dwarf excavator wanted to reach Ironforge.",
    "Dorius was shot before he got far. He dropped a singed letter when he was hit.",
    "Dorius Stonetender was shot before he could reach safety, and a letter fell from him.", true)
q(3368, "Suntara Stones", "Ironforge", 48, "suntara", 4,
    "Dorius's letter was meant for his brother. It said the Dark Irons held the Suntara Stones, and that their leader, Lathoric the Black, used them to enslave his excavation team.",
    "The singed letter called itself a dead man's final wish. Dorius's team had been taken to the Cauldron to build something called Obsidion.",
    "Curator Thorius wept over his brother's letter, then vowed in the name of the Light that Dorius would have his wish.",
    "Thorius read the letter and dried his face. His brother's last wish would be honored, he swore.", true)
fallback("Suntara Stones", "Searing Gorge", "suntara", "3367,3368",
    "Dorius Stonetender's excavation in the Searing Gorge concerned the Suntara Stones.",
    "Dorius Stonetender's search for the Suntara Stones had gone badly in the Searing Gorge.",
    "Word of Dorius Stonetender's excavation went on toward Ironforge.",
    "The matter of the Suntara Stones moved on.")
q(3372, "Release Them", "Searing Gorge", 52, "suntara", 3,
    "A dying archaeologist said the Suntara's power kept the workers at their tasks even after their bodies gave out. Its altar needed a relic guarded by the Twilight's Hammer.",
    "Freeing the workers depended on the altar of Suntara. Its relic lay with the Twilight's Hammer in the hills above the cave.",
    "The mysterious artifact was set on the altar of Suntara.",
    "Before he collapsed, the archaeologist had begged for this. The relic taken from the Twilight's Hammer was placed on the altar of Suntara.")
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
    "The Thorium Brotherhood had lost a smithing tuyere and a lookout's spyglass, and blamed jealous Dark Iron dwarves.",
    "A posting asked for the stolen tuyere and spyglass to be returned to Scrange. The tuyere could not be replaced.",
    "Taskmaster Scrange paid the reward for the tuyere and spyglass.",
    "Scrange had the stolen tools back and paid the promised reward.")
q(7729, "JOB OPPORTUNITY: Culling the Competition", "Searing Gorge", 48, "thoriumpoint", 2,
    "Taskmaster Scrange wanted the Dark Iron taskmasters and slavers of the Gorge cut down. His notice said to come back when the clothes were bloody enough.",
    "Scrange's posting called it culling the competition. His targets were the Dark Iron slavers and taskmasters.",
    "Scrange found fifteen point nine pounds of blood and gut on the clothes and said it might be the most ever.",
    "Scrange congratulated the new hire on what might be the most blood and gut ever weighed.")
q(7723, "Curse These Fat Fingers", "Searing Gorge", 49, "thoriumpoint", 2,
    "Hansel Heavyhands claimed the climate had swollen his fingers like blood sausages. Someone else would have to pound the heavy war golems of the Gorge.",
    "With his fingers too fat to fight, Hansel handed out his orders, starting with the Gorge's heavy war golems.",
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
    "Hansel Heavyhands complained about his aching feet when the incendosaur hunt was done.")
q(7701, "WANTED: Overseer Maltorius", "Searing Gorge", 50, "thoriumpoint", 4,
    "Maltorius, a rogue Thorium Brotherhood agent, now commanded the Dark Iron crew of the Slag Pit. Overseer Oilfist wanted him dead.",
    "A bounty branded Overseer Maltorius of the Cauldron's Slag Pit crew a traitor to the Thorium Brotherhood. His head would earn the reward from Lookout Captain Lolo Longstriker.",
    "Lolo Longstriker, quite drunk, said Maltorius looked better without the rest of him, and paid the bounty.",
    "Captain Lolo had never thought to see that ugly face again, and paid between hiccups.")
hl(3368, "Curator Thorius read his brother Dorius's letter about the Suntara Stones and his enslaved team, then vowed to honor the dead man's wish.",
    "Dorius's letter reached his brother Thorius in Ironforge. He wept, then swore that Dorius would have his wish.")
hl(3566, "Thorius saw the proof and turned white. His own brother had set the trap and betrayed Ironforge.",
    "Curator Thorius learned that his brother had set everything up. He feared the Old Gods' influence was still strong.")
hl(7701, "Overseer Maltorius, the Thorium Brotherhood's traitor, was dead. Lolo Longstriker paid the bounty between hiccups.",
    "Lookout Captain Lolo Longstriker paid the bounty on Maltorius, surprised to see that ugly face again.")
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
    "Mai'Lahii said the witch doctor had prescribed fishing for a headache, and with the clam meat, Mai'Lahii felt better already.",
    "Mai'Lahii had fresh bait and a cure for a headache, as the witch doctor had promised.")
q(6143, "Other Fish to Fry", "Desolace", 36, "shadowprey", 3,
    "Drulzegar Skraghook's crew had fished near Ranazjar Isle until the naga attacked one morning. Only Drulzegar survived, and the guilt drove him to seek revenge.",
    "Naga had killed every member of Drulzegar's fishing crew but him, and he wanted them punished at Ranazjar Isle.",
    "Drulzegar was glad to hear the naga had been beaten, though his heart still felt empty. He swore to spend his life seeing them all killed.",
    "Drulzegar Skraghook paid as he had promised, though the sweet news did not fill the loss of his crew.")
q(5386, "Catch of the Day", "Desolace", 37, "shadowprey", 2,
    "Nataka Longhorn at Ghost Walker Post missed the smell of cooked fish. The centaur kept Nataka too busy to visit Jinar'Zillen, the fisherman at Shadowprey Village.",
    "Shadowprey's trolls caught the best fish in Desolace. Bloodbelly fish from Jinar'Zillen were Nataka's favorite.",
    "Nataka Longhorn called the fish-bearer a savior. The Bloodbelly fish looked almost good enough to eat raw.",
    "Nataka was delighted with the Bloodbelly fish and paid with a choice of items.")
q(5381, "Hand of Iruxos", "Desolace", 38, "iruxos", 3,
    "Taiga Wisemane said the Burning Blade used the Hand of Iruxos to open demon portals at Mannoroc Coven. It lay in their Demon Box, behind a red crystal in Thunder Axe Fortress.",
    "A demon pick could break the red crystal guarding the Burning Blade's Demon Box, which held the Hand of Iruxos, and Taiga wanted both.",
    "Taiga Wisemane asked for the Demon Box, to open it and reveal the Hand of Iruxos.",
    "Taiga took the Demon Box from Thunder Axe Fortress and prepared to open it.")
q(5581, "Portals of the Legion", "Desolace", 38, "iruxos", 4,
    "The Hand of Iruxos was a gruesome thing, and it was needed to banish the demon portals at Mannoroc Coven. Their guardians, Taiga warned, would fight.",
    "With the Hand of Iruxos, the portals at Mannoroc Coven could be closed. The demons' road into the world had to be shut.",
    "Taiga Wisemane commended the work. The portals were banished, and in Taiga's words all of Azeroth was safer for it.",
    "Taiga said the closing of the Mannoroc portals had greatly helped the fight against the demons.")
q(6027, "Book of the Ancients", "Desolace", 38, "shadowprey", 3,
    "Azore Aldamort gave the Gem of the Serpent, to be set in the hand of the Serpent Statue on Ranazjar Isle. It would summon the guardian of an ancient naga tome.",
    "An ancient naga tome held secrets kept for centuries. The Gem of the Serpent would summon its guardian.",
    "Azore Aldamort promised to pass the long-lost naga tome to the high council, and thanked its finder as a hero should be thanked.",
    "Azore welcomed the naga tome and thanked its bearer as a hero should be thanked.")
q(6132, "Get Me Out of Here!", "Desolace", 39, "brimbuzzle", 3,
    "Melizza Brimbuzzle had gone to the Valley of Spears to do business with the Maraudine centaur. They had other ideas, and she heard talk of firewood for their cookpot.",
    "Melizza was caught among the Maraudine and wanted out, and her brother Hornizz, at the camp by the kodo graveyard, would pay.",
    "Hornizz Brimbuzzle thanked the rescuer for getting his sister out of her jam. He expected she had already found a new one.",
    "Hornizz was glad Melizza had been brought out of the Valley of Spears, for now.")
q(6134, "Ghost-o-plasm Round Up", "Desolace", 39, "brimbuzzle", 2,
    "Hornizz Brimbuzzle thought the Magram would pay well for ghost energy from the Valley of Bones. His ghost magnets drew the spirits to the Dead Goliaths.",
    "The Magram, Hornizz reckoned, feared the ghosts in the Valley of Bones, so he meant to sell them the ghost-o-plasm.",
    "Hornizz admired the slimy ghost-o-plasm, which would be worth a fortune if the centaur could be convinced what it was.",
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
    "A brief account of the Dark Iron dwarves' history was on offer from the Royal Historian.",
    "Archesonus finished the account of Thaurissan and was ready to proceed.",
    "Archesonus told the history of the Dark Irons to its end.", true)
fallback("The Smoldering Ruins of Thaurissan", "Burning Steppes", "thaurissanruins", "3701,3702",
    "Royal Historian Archesonus studied the ruins of Thaurissan in the Burning Steppes.",
    "The Dark Iron past lay in the smoldering ruins of Thaurissan.",
    "Archesonus's study of Thaurissan went on.",
    "The Royal Historian had more on Thaurissan.")
q(4283, "FIFTY! YEP!", "Burning Steppes", 56, "blackrock", 2,
    "At Morgan's Vigil, Oralius claimed to be the only sane one there, and after collecting ogre ears he now wanted fifty orc badges.",
    "Oralius wanted orc badges to go with his ogre ear collection. He wanted fifty of them.",
    "Oralius rewarded the badges with the chance to rub his belly.",
    "Oralius had fifty badges, and offered his belly as the prize.")
q(4081, "KILL ON SIGHT: Dark Iron Dwarves", "Badlands", 52, "kef", 3,
    "Warlord Goretooth of the Kargath Expeditionary Force ordered General Angerforge's forces in Blackrock Depths destroyed. They had massacred the 109th division.",
    "A wanted sign in Kargath offered a tribute for breaking the first line of Angerforge's forces in Blackrock Depths.",
    "Warlord Goretooth said the first strike would put a crease in Angerforge's pants. He had battles to plan, and more work waited on the wanted signs.",
    "Goretooth paid the first tribute and sent the soldier back to the wanted signs.")
q(4082, "KILL ON SIGHT: High Ranking Dark Iron Officials", "Badlands", 54, "kef", 4,
    "Grandmaster Lexlort had found where high-ranking Dark Iron officials trained their forces, through a locked gate near the heart of the Dark Iron city.",
    "A second posting named the Dark Iron officials who trained forces against the Horde in Blackrock Depths.",
    "Warlord Goretooth guessed Angerforge was angry by now. After a third tribute, he said, Operation Death to Angerforge would begin.",
    "Goretooth paid the second tribute. Operation Death to Angerforge, he hinted, would involve somebody dying.")
q(4062, "The Rise of the Machines", "Badlands", 54, "machines", 3,
    "The initials G.L.A. and a rank marking were etched into the elemental shards. Theodora sent a sample to Lotwil Veriatus, a scholar of elemental science.",
    "Theodora had found initials on the rock creatures' shards, and a scholar in the camp to the east, Lotwil, might know them.",
    "Lotwil Veriatus turned white at the shard. He knew those markings.",
    "Lotwil recognized the G.L.A. markings at once, and went pale.", true)
hl(5581, "Taiga Wisemane commended the closing of the demon portals at Mannoroc Coven, done with the Hand of Iruxos.",
    "The Hand of Iruxos banished the portals at Mannoroc Coven. Taiga said Azeroth was safer for it.")
hl(4082, "Warlord Goretooth paid his second tribute and promised Operation Death to Angerforge after a third.",
    "High-ranking Dark Iron officials in Blackrock Depths had fallen. Goretooth was already planning the next operation.")
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
    "Kharan in the opposite cell knew more about the princess and her captors, and Gor'shak wanted it all taken to the Warchief.",
    "Thrall saw a chance for the Horde to change the politics of a war-torn world. Failure, he said, was not an option.",
    "The Warchief heard what had been learned in the Depths and called the mission one the Horde could not fail.", true)
fallback("What Is Going On?", "Blackrock Depths", RR, "3982,4001",
    "Commander Gor'shak had news from inside the Dark Iron city.",
    "A Horde agent in Blackrock Depths was gathering intelligence.",
    "Gor'shak's effort to learn about the Princess's captors moved forward.",
    "Gor'shak's work inside the Dark Iron city went on.")
q(4002, "The Eastern Kingdoms", "Orgrimmar", 54, RR, 4,
    "Thrall said a Warchief had to do what was best for the Horde and its future generations. Helping the dwarves could strengthen the Horde's standing in the Eastern Kingdoms.",
    "The Warchief saw an opening to shape future alliances by aiding the dwarves, and asked whether the messenger was prepared.",
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
    "Magni heard Kharan's account and brought his fist down in rage.")
q(4324, "Yuka Screwspigot", "Burning Steppes", 53, "screwspigot", 2,
    "Ribbly Screwspigot had been worthless his whole life, but now he was suddenly worth something. His sister Yuka had tracked him to the Burning Steppes.",
    "The Screwspigots were glad that Ribbly was finally worth something. His sister Yuka was holed up in Flame Crest and wanted hired hands.",
    "Yuka Screwspigot wanted her brother brought back, bless his heart. If not all of him, his head would do.",
    "Yuka was hunting her brother Ribbly and welcomed the help. She would take him whole, or just his head.")
q(4136, "Ribbly Screwspigot", "Burning Steppes", 53, "screwspigot", 3,
    "Revilgaz's bounty had sent Ribbly into hiding deep in Blackrock Depths. His sister wanted him brought back, or failing that, his head.",
    "Ribbly was hiding in Blackrock Depths from the price on his head, and his sister wanted him, alive or not.",
    "Yuka Screwspigot saw that Ribbly had not come quietly. Her family was very happy, she said, and Ribbly had never looked so peaceful.",
    "Yuka was sorry only to have missed telling Ribbly of the plan to turn him in. She gave thanks on behalf of the Screwspigots.")
q(4128, "Ragnar Thunderbrew", "Dun Morogh", 55, "thunderbrew", 2,
    "Ragnar Thunderbrew was furious that someone had stolen his ale, and he would pay well for help. He was at the Thunderbrew Distillery in Kharanos.",
    "Word had spread that Ragnar Thunderbrew needed stalwart adventurers and was willing to pay.",
    "Ragnar had been robbed of a family recipe and was fuming. As if he lacked reasons to hate the Dark Irons, he said, they were in for it now.",
    "Ragnar Thunderbrew raged about the theft of a family recipe by the Dark Iron dwarves.")
q(4126, "Hurley Blackbreath", "Dun Morogh", 55, "thunderbrew", 3,
    "Hurley Blackbreath and his Dark Irons had stolen the recipe for Thunderbrew Lager. Their kegs were to be smashed and the recipe brought home.",
    "The thought of Dark Irons drinking his family's lager was more than Ragnar could stand, and the recipe was somewhere in Blackrock Depths.",
    "Ragnar Thunderbrew had his recipe back. He hoped Hurley had taken a good thumping, and called the finder a hero of heroes.",
    "Ragnar celebrated the recovered recipe. The Thunderbrews, he said, were at the finder's service.")
q(4133, "Vivian Lagrave", "Badlands", 55, "thunderbrew", 2,
    "Shadowmaster Vivian Lagrave was in Kargath, pursuing rumors of a Dark Iron brew, and she had asked for help.",
    "A summons led to Vivian Lagrave in the Badlands, where she was following talk of a brew from Blackrock Depths.",
    "Vivian Lagrave found Kargath lacking the comforts of the Apothecarium. Then she turned to business.",
    "Vivian greeted the arrival and wasted little time on pleasantries.")
q(4134, "Lost Thunderbrew Recipe", "Badlands", 55, "thunderbrew", 3,
    "Hurley Blackbreath had stolen the Thunderbrew Lager recipe, said to give its drinker strength and courage. The Forsaken wanted it studied for their own purposes.",
    "Hurley might have to be lured out by threatening his precious ale, Vivian warned. The recipe he had taken was what she wanted.",
    "Vivian Lagrave planned to send the recipe to the Apothecarium. She found it amusing that the drink might one day be turned on the Alliance's dwarves.",
    "Vivian took the lager recipe for the apothecaries to study, and admitted death might have changed her sense of humor.")
q(4201, "The Love Potion", "Blackrock Depths", 54, "rocknot", 2,
    "Mistress Nagmara was spurned by Private Rocknot. Her potion needed gromsblood, giant silver veins from Azshara's cliff giants and water from Un'Goro's Golakka Springs.",
    "A succubus in the Grim Guzzler wanted to break down the walls around Rocknot's heart. Her potion called for gromsblood and rare ingredients from Azshara and Un'Goro.",
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
    "Thunderheart clutched the Tablet of Kurniya and named Ragnaros, a general of the Old Gods. Those at Kargath would have to decide whether to stay and fight.",
    "Thunderheart read the tablet and learned that Ragnaros was in the world, a far greater evil living in Blackrock's depths.")
q(4262, "Overmaster Pyron", "Burning Steppes", 52, "disharmony", 3,
    "Jalinda Sprig's last five mages had come back from Blackrock Mountain burned, or worse. Overmaster Pyron guarded the way into the Depths at the quarry.",
    "The Morgan's Vigil expedition could not reach Blackrock Depths while Overmaster Pyron held the quarry entrance.",
    "Jalinda Sprig heard the name Incendius and said, oh dear.",
    "With Pyron destroyed, Jalinda heard the name Incendius and could only say, oh dear.")
hl(3982, "Commander Gor'shak said Emperor Thaurissan had kidnapped the Princess of Ironforge. Then the Dark Iron guards attacked his cell.",
    "In Blackrock Depths, Gor'shak revealed he was a willing prisoner on Thrall's orders, gathering news of the captive princess.")
hl(4361, "Kharan's news reached King Magni, who slammed his fist down in anger.",
    "King Magni heard what Kharan had to say about his daughter and brought his fist down in rage.")
hl(4126, "Ragnar Thunderbrew had his family's lager recipe back from Hurley Blackbreath and called its finder a hero of heroes.",
    "The stolen Thunderbrew Lager recipe came home to Kharanos. Ragnar hoped Hurley had been thumped.")
hl(3907, "The Tablet of Kurniya told Thunderheart that Ragnaros was in the world. Those at Kargath had to decide whether to fight or flee.",
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
    "The saltwater snapjaws stole Katoom's bait and broke his lines, and Revantusk Village would be better off without them, he said.",
    "Katoom could not thank the hunter enough, and offered a fishing pole as reward.",
    "Katoom the Angler handed over a fishing pole in thanks for the snapjaw hunt.")
q(7828, "Stalking the Stalkers", "The Hinterlands", 48, "revantusk", 2,
    "Many Revantusk trolls had been lost to the wilds, and Huntsman Markhor named the Silvermane wolves among the worst threats. He wanted the stalkers stalked in turn.",
    "The Silvermane wolves ambushed Revantusk's hunters from cover. Every one of them was to be slain, Markhor said.",
    "Huntsman Markhor thanked the hunter on behalf of the Revantusk.",
    "Markhor called the wolf hunt a job well done.")
q(7829, "Hunt the Savages", "The Hinterlands", 48, "revantusk", 2,
    "Savage owlbeasts had killed many good Revantusk warriors. Every one was to be killed, and Markhor promised to weigh the effort.",
    "Every savage owlbeast in the Hinterlands was to be killed on sight, Markhor said, and the work would be judged when it was done.",
    "Huntsman Markhor judged the hunt and named the hunter a worthy ally of the Revantusk.",
    "Markhor was satisfied with the owlbeast hunt and said so.")
q(7830, "Avenging the Fallen", "The Hinterlands", 48, "revantusk", 3,
    "The Wildhammer trained gryphons to kill trolls, Markhor said. He wanted the plume of a Razorbeak Skylord, one of the elder gryphons that bred the rest.",
    "Elder gryphons called Skylords fathered the birds that hunted Revantusk trolls. One of them was to die.",
    "Huntsman Markhor examined the plume and wondered how many of his hunters the beast had devoured.",
    "Markhor took the Skylord's plume as proof that the beast had been brought to justice.")
q(7849, "Separation Anxiety", "The Hinterlands", 50, "revantusk", 4,
    "Markhor's twin brother Malkhor had been taken by the Vilebranch in the same raid as Torntusk's mate. He was executed and his remains thrown to the oozes and wolves.",
    "It was too late to save Malkhor's life, his brother said, but not his soul. His remains lay among the Vilebranch.",
    "Huntsman Markhor mourned his dearest brother. He would take the remains to Yayo'jin for a proper burial, and called their finder a hero.",
    "Markhor received his brother's remains and grieved for him. Mystic Yayo'jin would prepare them for burial.")
q(7841, "Message to the Wildhammer", "The Hinterlands", 48, "revantusk", 2,
    "Otho Moji'ko spat at the Wildhammer's new deals with the high elves. He wanted the Highvale elves killed and left as a warning.",
    "The Wildhammer were forging alliances with the high elves of Highvale, and a message in blood was what Otho wanted.",
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
    "The Vilebranch were cannibals, Yayo'jin said, and since Zul'jin had not returned to destroy them, their numbers had to be cut.",
    "Mystic Yayo'jin said Zul'jin himself could not have done better.",
    "Yayo'jin praised the work against the Vilebranch.")
q(7850, "Dark Vessels", "The Hinterlands", 50, "torntusk", 3,
    "The Vilebranch fought with unnatural fury because of the Vile Priestess Hexx. Vessels of tainted blood in Jintha'Alor carried the blood god's magic.",
    "Taken from Jintha'Alor, the dark vessels could be cleansed of their taint by Primal Torntusk.",
    "Primal Torntusk lifted the dark energy that drove the Vilebranch, for now. Even if Hexx fell, she warned, another would take her place.",
    "Primal Torntusk cleansed the vessels and loosened the blood god's grip on the Vilebranch, though only for now.")
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
    "Primal Torntusk would review applications for captain of the guard, and the test was a cull of the Vilebranch warriors.",
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
    "Neeru had been waiting for the witch doctor's shrunken head, and the herb mixture changed hands.")
q(3122, "Return to Witch Doctor Uzer'i", "Feralas", 45, "muisek", 2,
    "The herbs had to go back to Camp Mojache, with word that the shrunken head had pleased Neeru.",
    "Back in Feralas, the herb mixture from Orgrimmar would begin the witch doctor's preparations.",
    "Mojache's witch doctor had what he needed to prepare the muisek vessel. He paused to perform the ritual and apply the herbs.",
    "Neeru's herbs went straight into the ritual that readied the muisek vessel.")
q(3125, "Faerie Dragon Muisek", "Feralas", 45, "muisek", 3,
    "The faerie dragons served the night elves as allies. Their spirit was strong, and the witch doctor wanted it captured for the Horde with his vessel.",
    "Sprite darters and sprite dragons looked fragile, but their spirit was powerful. Once they were slain, the vessel could take their muisek.",
    "Mojache's witch doctor now held the faerie dragons' muisek, their spiritual power available to the Horde.",
    "Eight faerie dragon spirits filled the vessel, and another task was already waiting.")
q(3124, "Hippogryph Muisek", "Feralas", 47, "muisek", 3,
    "Hippogryphs had long served the night elves, loyal and steadfast. The frayfeather hippogryphs of the High Wilderness were to be shrunk and captured next.",
    "The vessel had proved itself in trusted hands, so the witch doctor asked for hippogryph muisek.",
    "Mojache's witch doctor explained that an escaped muisek might return as a greater creature seeking vengeance. The dangerous task had been done well.",
    "Ten hippogryph spirits were held in the vessel, where they could take no revenge.")
q(3126, "Treant Muisek", "Feralas", 50, "muisek", 3,
    "Treants fought for the night elves against the Horde. Slow as they were, the wandering forest walkers were strong protectors.",
    "Three forest walkers were next for the vessel, and the witch doctor meant to use their strength for the Horde.",
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
    "The captured spirits and the materials were ready, and sealing them into weapons took a moment of the witch doctor's craft.",
    "Mojache's witch doctor offered a choice of weapons, each with a creature's muisek sealed into it for good.",
    "Weapons of spirit were finished, the muisek bound in them for their wielder to use.")
q(2976, "A Grim Discovery", "Orgrimmar", 45, "mojache_requests", 3,
    "Krueg Skullsplitter admitted he had mentioned a bounty. He had the horns crated and sent their finder to report to Belgrom Rockmaul in Orgrimmar.",
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
q(2979, "Dark Ceremony", "Feralas", 46, "gordunni", 3,
    "The plans described a dark ceremony led by the Gordunni mage-lords. An orb from one of them was what Rok Orhan wanted.",
    "A mage-lord's orb held great power, Rok Orhan said, and could reveal more about the Gordunni ceremony.",
    "Rok Orhan took the orb to learn more about the Gordunni, and to plan their downfall.",
    "Rok had his Gordunni orb, and with it a way to study their magic.")
q(3063, "Vengeance on the Northspring", "Feralas", 50, "talo", 3,
    "Talo Thornhoof had once been a fearless hunter until harpies ambushed him in the forest. He still heard their cries, and wanted revenge on the Northspring.",
    "An old ambush by harpies had changed Talo Thornhoof forever, and after all these years he wanted to get even.",
    "Talo Thornhoof said his old mind was at peace.",
    "Talo thanked the avenger. The Northspring had paid for the old ambush.")
q(3062, "Dark Heart", "Feralas", 50, "talo", 4,
    "Edana Hatetalon ruled the Northspring harpies, and Talo heard her heart was made of crystal. A horn carried by her harpies, blown by the Hatetalon stones, would summon her.",
    "The Northspring queen's dark heart was what Talo wanted, and a harpy horn sounded at the Hatetalon stones would bring her out.",
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
    "Pratt McGrubben thought the hides, treated properly, could be stronger than iron, and offered a choice of his goods.",
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
P.threads.world_shadra = "the Witherbark venom"
P.threads.world_rinji = "Rin'ji's secret"
q(351, "Find OOX-17/TN!", "Tanaris", 48, "oox", 2,
    "A metal egg turned up in Tanaris and opened into a gnomish device. Oglethorpe Obnoticus spoke from inside, saying his homing robot had crashed near the Gaping Chasm.",
    "Oglethorpe Obnoticus offered a reward for his lost homing robot. His beacon pointed to the Gaping Chasm.",
    "OOX-17/TN stood up, humming and whirring, once the beacon was placed inside. Oglethorpe said it worked, but needed major repairs.",
    "The robotic chicken came back to life with the beacon inside it. Oglethorpe asked for help watching over it, since it was too heavy to carry.")
q(648, "Rescue OOX-17/TN!", "Stranglethorn Vale", 48, "oox", 3,
    "OOX-17/TN had to be moved to Steamwheedle Port for a long take-off, Oglethorpe said, since its cloaking would take time to restore.",
    "OOX-17/TN had to be escorted to Steamwheedle Port for its take-off, while Oglethorpe waited in Booty Bay.",
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
    "A goblin variant of a gnomish shrinking ray needed a field test, and shrunken Feralas giants would leave the residue Zorbin wanted.",
    "Zorbin Fandazzle was relieved to see the residue and every limb intact. He called the tester a friend to goblins everywhere.",
    "Zorbin had his miniaturization residue, and the Ultra-Shrinker had not exploded.")
q(7721, "Fuel for the Zapping", "Feralas", 48, "zorbin", 2,
    "The elementals of the Forgotten Coast troubled Zorbin's shop. Their water cores could power his Ultra-Shrinker.",
    "Water elemental cores were raw power for the Ultra-Shrinker, and Zorbin wanted them.",
    "Zorbin Fandazzle had cores enough to keep him working, and fewer elementals near his shop.",
    "Zorbin paid in loot for the water elemental cores, despite the strain on his purse.")
q(7725, "Again With the Zapped Giants", "Feralas", 55, "zorbin", 2,
    "More residue was always welcome to Zorbin, who offered less coin along with word of the deed to his goblin friends.",
    "More miniaturization residue was wanted, though the pay would be smaller this time.",
    "Zorbin Fandazzle said the deed was echoing through the halls of the Steamwheedle Cartel.",
    "Zorbin paid a smaller sum and promised his Cartel friends would hear of it.")
q(7726, "Refuel for the Zapping", "Feralas", 55, "zorbin", 2,
    "More water elemental cores were needed, but setting up shop had left Zorbin short of coin. He promised to tell everyone in earshot.",
    "More cores were needed for the Ultra-Shrinker, and though the reward would be smaller, the Cartel would hear of it.",
    "Zorbin Fandazzle paid what he could and promised his Steamwheedle comrades would hear about it.",
    "Zorbin had more cores, and promised to spread word of the help.")
q(2932, "Grim Message", "Stranglethorn Vale", 42, "shadra", 3,
    "The Witherbark trolls had once been allies of the Horde, then betrayed Thrall. Their skulls and Nimboya's pike were to stand in one of their villages.",
    "Nimboya wanted the Witherbark punished for betraying Thrall. His pike was to stand at Hiri'watha or Zun'watha.",
    "Nimboya had heard of the grim deed and called it one of honor. He hoped the Witherbark would heed it.",
    "A grim deed, Nimboya called the pike in the Witherbark village, but one of honor.")
q(2933, "Venom Bottles", "Hillsbrad Foothills", 43, "shadra", 2,
    "The Witherbark village held many bottles of green venom. An apothecary in Tarren Mill might want a sample.",
    "So many venom bottles suggested the Witherbark prized them. Tarren Mill's apothecaries might know why.",
    "Apothecary Lydon had had a day of failed experiments. He judged the venom to come from some spider, and asked where it had been found.",
    "Lydon was intrigued by the green venom and wanted to know its source.")
q(2934, "Undamaged Venom Sac", "Hillsbrad Foothills", 45, "shadra", 2,
    "Fresh venom was needed from the spiders near Shadra'Alor, in an undamaged sac, for Lydon's tests.",
    "A fresh, intact venom sac from the Hinterlands spiders was what Lydon wanted for his tests.",
    "Apothecary Lydon was delighted. The venom was fresh, and he was sure it was very deadly.",
    "Lydon had his fresh venom, and small animals already on order to test it on.")
q(2935, "Consult Master Gadrin", "Durotar", 45, "shadra", 3,
    "The broodguards' venom was weaker than the first sample. Lydon sent the question of its source to Master Gadrin in Sen'jin Village.",
    "Lydon wanted the venom's true source. A troll who knew the Witherbark well, Master Gadrin, might know it.",
    "Master Gadrin understood what was wanted and warned that the answer would not be welcome.",
    "Gadrin bid his visitor sit. The source of the Witherbark venom was bad news.")
q(2936, "The Spider God", "Durotar", 45, "shadra", 4,
    "The Witherbark worshipped a spider god and took their strongest venom from her. Her true name was on a tablet guarded by Theka the Martyr in Zul'Farrak.",
    "To get the venom, Gadrin said, the spider god herself had to be summoned. Her name lay in Zul'Farrak, in Theka's tomb.",
    "Master Gadrin heard the name Elortha no Shadra and warned it should only be whispered. He promised to set it down as a spell of summoning.",
    "Gadrin repeated the name, Elortha no Shadra, and said it should be spoken only in whispers; he would set it down as a summoning.")
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
    "At the Overlook Cliffs lay Rin'ji's secret, a troll tablet covered in markings that could not be read.")
q(2782, "Rin'ji's Secret", "Undercity", 47, "rinji", 2,
    "The tablet might be valuable, or worthless. A troll in trouble would say anything to escape, so the Witherbark markings needed an expert eye.",
    "Rin'ji's tablet was covered in Witherbark markings that only an expert could read.",
    "The tablet was judged quite unusual, and its finder was asked where it had come from.",
    "The tablet drew interest as something quite unusual.")
hl(648, "Oglethorpe Obnoticus thanked the savior of OOX-17/TN in Booty Bay, once the robot reached Steamwheedle Port.",
    "OOX-17/TN made it to Steamwheedle Port, and in Booty Bay Oglethorpe called its escort the robot's great savior.")
hl(2936, "Master Gadrin learned the spider god's true name, Elortha no Shadra, from Theka's tablet, and promised a spell of summoning.",
    "The name of the Witherbark spider god came back from Zul'Farrak. Gadrin warned it should only be whispered.")
hl(2938, "Shadra's venom, the most potent poison Lydon had found, reached Apothecary Faranell in the Undercity.",
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
    "Maury Club Foot Wilkins, Jon-Jon the Crow and Chucky Ten Thumbs had debts months overdue. They were said to be cursed and wandering the jungle ruins.",
    "The three debtors now wandered the Ruins of Aboraz and Jubuwal under some curse. Regardless, their creditor wanted his due.",
    "Their creditor was pleased with the valuables, especially whatever was inside Maury's foot. They should have been careful whom they gambled with, he said.",
    "The cursed debtors' valuables were collected. Nobody should bet what they could not afford to lose, their creditor said.")
q(613, "Cracking Maury's Foot", "Stranglethorn Vale", 44, "dues", 2,
    "Maury had put a lock on his foot, and his loot was inside. He had once been chased from the Mosh'Ogg mound for winning too much, so the ogres might have the key.",
    "The key to Maury's foot was likely somewhere among the Mosh'Ogg ogres he used to gamble with.",
    "Maury's key was found, and the lock on his foot could be opened. The creditor called it a big help.",
    "Maury's key came back from the ogres, and the reward with it.")
q(587, "Up to Snuff", "Stranglethorn Vale", 41, "sailors", 2,
    "Deeg liked grog and good snuff when he came into port. Booty Bay's herbalist had sold out, his shipment hijacked by the Bloodsail.",
    "The Bloodsail had taken the herbalist's snuff, and Deeg wanted some before he shipped out.",
    "Deeg had his snuff just before shipping out, and said he could not give enough thanks.",
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
hl(591, "Kin'weelay received the Mind's Eye from Mai'Zoth's mound. A ritual was still needed to bend it toward saving Yenniku.",
    "Mai'Zoth was gone, and the Mind's Eye, the only hope of saving Yenniku, came to Kin'weelay.")
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
P.threads.world_westfallmilitia = "the People's Militia against the Defias"
q(214, "Red Silk Bandanas", "Westfall", 17, "westfallmilitia", 3,
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
    "Silverpine was free of the wretch Arugal at last, Dalar said, and such tenacity would be rewarded.")
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
    "Kam Deepfury was held in the Stockade for political reasons. Honor bound Motley to stay with Longbraid, so he asked for Deepfury's head.",
    "Motley Garmason said the Thandol Span victims' families could rest. Longbraid's brother had been avenged.",
    "Motley was glad Deepfury had paid. The cowardly Dark Iron got what he deserved, he said.")
q(391, "The Stockade Riots", "Stormwind City", 29, "stockade", 5,
    "Bazil Thredd led the riot, and Warden Thelwater, who did not trust the volunteer, demanded his head as proof of loyalty.",
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
    "Excellent, said Rahauro, and paid for the satchel as Magatha had instructed.")
q(5725, "The Power to Destroy...", "Undercity", 16, "ragefire", 3,
    "Two powerful spell books were in the hands of the Searing Blade, in the caverns below Orgrimmar. The Dark Lady wished to borrow them, Varimathras said.",
    "The Dark Lady wanted the Searing Blade's spell tomes, and Varimathras had a hundred other tasks to see to.",
    "Varimathras called the service to the Dark Lady well done, and hinted at future tasks.",
    "Varimathras took the Searing Blade's tomes for the Dark Lady.")
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
    "Someone in Ratchet got a look at the strange green shard.")
hl(167, "Wilder Thistlenettle saw his brother's Explorers' League badge and knew he had died in the Moonbrook cave-in.",
    "The badge from the collapsed tunnels ended Wilder's hope for his brother.")
hl(391, "Warden Thelwater had Bazil Thredd's head, and admitted he had misjudged the one who brought it.",
    "The Stockade riot lost its leader. Thelwater offered what he knew of Thredd's activities.")
hl(1014, "Dalar Dawnweaver declared Silverpine free of Arugal, a great service to the Dark Lady.",
    "Arugal was dead, and Dalar at the Sepulcher called Silverpine free of the wretch at last.")
for _, id in ipairs({214, 168, 167, 2040, 1098, 1014, 386, 377, 387, 388, 378, 391, 5722, 5724, 5725, 959, 6981}) do src(id, "LoreForever quest:" .. id .. " (facts only)") end

-- Batch W3-11: Theldurin the Lost in the Badlands, now that the notes lane has
-- discovery facts for Gerrig Bonegrip (gerrig.cult: 727/735), Keeper Bel'dugur
-- (beldugur.cult: 728/736) and the bargain (yagyin.bargain: 735/736). Each stage
-- says only what its own text shows: Gerrig and Bel'dugur greet a supposed fellow
-- member, ask for three relics, and the digest reaches Theldurin. The thread label
-- names Theldurin's fear, not the order. 692 only fears that Myzrael may be free.
P.threads.world_yagyin = "Theldurin's search for Yagyin's Digest"
q(692, "The Lost Fragments", "Badlands", 41, "myzrael", 3,
    "Theldurin the Lost warned that the Scroll of Myzrael could pull her to the surface. Then he feared she might already be free, and that the scroll would be needed to trap her again.",
    "Enraged elementals had stolen the Scroll of Myzrael and torn it apart. They now fought among themselves over its fragments.",
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
hl(737, "Theldurin the Lost had Yagyin's Digest. Hope glimmered, he said, unless what he feared rose first.",
    "Hope glimmered for Theldurin the Lost with the digest in his hands, though he feared what might yet be freed.")
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
    "Rumors told of the Twilight's Hammer joining the naga in Blackfathom Deeps. Shaedlass wanted her missing scout found.",
    "Argent Guard Thaelrid was found alive. He said a wicked plot was underway in the corrupted temple.",
    "Thaelrid welcomed the help Shaedlass had sent, and warned of a plot in the depths.")
q(1275, "Researching the Corruption", "Darkshore", 24, "blackfathom", 2,
    "Gershala Nightwhisper feared the blood elves would be deformed by demonic magic, as the naga and satyrs had been. Brain stems from both would help that study.",
    "Brain stems from the satyrs and naga of Blackfathom Deeps might show Gershala where the blood elves were headed.",
    "Gershala Nightwhisper thanked the traveler for selfless help with research meant for all Azeroth, then went back to work.",
    "Gershala took the brain stems and thanked the traveler for help meant for all Azeroth.")
q(1199, "Twilight Falls", "Darnassus", 25, "blackfathom", 3,
    "The Twilight's Hammer sought the Old Gods' return. According to the Argent Dawn, it had joined the naga in Blackfathom Deeps, once a moonwell temple.",
    "War on the Twilight's Hammer in Blackfathom was what Argent Guard Manados asked for, with proof brought back.",
    "Argent Guard Manados commended the work against the Twilight's Hammer on behalf of the Argent Dawn.",
    "Manados praised the courage shown against the cultists.")
fallback("Allegiance to the Old Gods", "Blackfathom Deeps", "blackfathom", "6564,6565",
    "A Twilight's Hammer servant of the Old Gods schemed in Blackfathom Deeps.",
    "Je'neu Sancrea wanted the Twilight's Hammer plan in Blackfathom stopped.",
    "The matter of Lorgus moved a step further.",
    "Je'neu's effort against the Twilight's Hammer went on.")
q(6565, "Allegiance to the Old Gods", "Ashenvale", 26, "blackfathom", 4,
    "Lorgus of the Twilight's Hammer had a plan to serve the Old Gods, creatures of chaos defeated long ago. Too weak to stop him himself, Je'neu asked for help.",
    "Lorgus had to die in Blackfathom Deeps before the cultist's plan could be finished, Je'neu said.",
    "Je'neu Sancrea knew the Twilight's Hammer was not stopped, but another of its plans had been. Zoram'gar could rest easy for now.",
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
    "Thaelrid said the Old God's corruption had tainted Blackfathom's moonwell and raised Aku'Mai. There Kelris and his cultists sacrificed innocents.",
    "Thaelrid asked for the cult leader Kelris to be slain and his head taken to Bashana in Thunder Bluff.",
    "Bashana praised the Earthmother. Kelris had sought to return the world to chaos, and his death spared many innocents.",
    "Kelris had worshipped the Old Gods, and Bashana thanked the one who slew him.", true)
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
    "A globe that seemed to have fed Baron Aquanis was worth taking to the Earthen Ring at Zoram'gar.",
    "Je'neu Sancrea expected the globe to show what had corrupted Baron Aquanis, and how. He suspected the Twilight's Hammer.",
    "Je'neu took Aquanis's globe for study, with the Earthen Ring's warmest regards.", true)
q(1048, "Into The Scarlet Monastery", "Undercity", 42, "scarletmonastery", 5,
    "While the Dark Lady dealt with the Lich King, Varimathras saw to the Scarlet Crusade at home. He wanted High Inquisitor Whitemane and her lieutenants killed.",
    "Whitemane, Commander Mograine, Herod and Houndmaster Loksey were to die in the Scarlet Monastery, by Varimathras's order.",
    "Varimathras said the Dark Lady had been well served, and that such tenacity in combat would be remembered.",
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
    "Monika Sengutz took Vorrel's ring. He had led such a troubled existence, she said, and been such a good mate.",
    "Monika mourned Vorrel and cursed the humans.")
q(1053, "In the Name of the Light", "Hillsbrad Foothills", 40, "scarletmonastery", 5,
    "Raleigh the Devout had once served the Scarlet Crusade with pride, until he saw innocents tortured as plagued. He wanted its leaders in the Monastery slain.",
    "Raleigh named Whitemane, Mograine, Herod and Loksey. With them gone, he hoped the true cause might be rekindled.",
    "Raleigh the Devout did not revel in the loss of life, but accepted it for the greater good. The deeds in the Monastery had spared many innocents.",
    "Raleigh saluted the tenacity shown in the Monastery and the lives spared by it.")
hl(1200, "Kelris's head came to Selgorm in Darnassus, and he saluted the deed for the Argent Dawn.",
    "Kelris was dead, and Selgorm said many innocents had been spared.")
hl(6561, "Kelris's head came to Bashana in Thunder Bluff, and she praised the Earthmother.",
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
    "Baelog was alive and had nearly lost a bet with Olaf. Olaf had wagered his beard would reach his knees before another living face appeared.",
    "Baelog's band was found alive. He won his bet with Olaf and offered to split the winnings.")
q(2240, "The Hidden Chamber", "Ironforge", 40, "uldaman", 4,
    "Baelog's diary described how to open the locked door of the Chamber of Khaz'mul. His band was stuck, so someone else had to explore it.",
    "The Chamber of Khaz'mul lay behind a great locked door in Uldaman, and Baelog knew how to open it.",
    "Prospector Stormpike had doubted the Chamber of Khaz'mul existed. He hoped the find would spur Ironforge's leaders to retake Uldaman.",
    "Stormpike was amazed to hear of the chamber. If Uldaman were ever retaken, its secrets would belong to Ironforge.")
q(1139, "The Lost Tablets of Will", "Ironforge", 45, "uldaman", 5,
    "Hammertoe had dreamt of the Tablet of Will, a shard the titans were said to have inscribed to give their creations a will of their own. It had to be found before the Shadowforge clan found it, Belgrum said.",
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
    "Magenta fungus caps grew deep in Uldaman, and the alchemist hoped to study their use in alchemy.",
    "The alchemist welcomed the caps and gave a potent restorative from a personal stock.",
    "The alchemist called the caps an interesting study and paid with a restorative brew.", true)
q(2202, "Uldaman Reagent Run", "Loch Modan", 42, "ulda_reagents", 2,
    "An alchemist had heard of magenta fungus caps deep in the Uldaman dig site and wanted a dozen to study.",
    "Magenta fungus caps from Uldaman might have alchemical uses, and an alchemist would trade an elixir for them.",
    "The alchemist welcomed the caps and gave a potent restorative brew in return.",
    "The alchemist called the magenta caps an interesting study, worth a taste of his own stock.", true)
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
    "The paladin's diary named the gems' hiding places. Shadowforge dwarves had the ruby, the troggs had hidden the topaz near some Alliance dwarves, and the trogg elder held the sapphire.",
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
    "A translator for the dead paladin's diary was found at Kargath in the Badlands.",
    "The matter of the paladin's diary moved on.")
q(2339, "Find the Gems and Power Source", "Badlands", 44, "droffers", 4,
    "The translated diary said the dwarves hid the ruby, the troggs the topaz, and a trogg named Grimlok held the sapphire. A power source from Uldaman's strongest construct was needed too, Jarkal said.",
    "Deep in Uldaman lay the gems, and the power source Droffers did not know was needed.",
    "Jarkal Mossmeld was sure he could now make such necklaces himself. He meant to analyze the gems before they went to Orgrimmar.",
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
    "The Chamber of Khaz'mul in Uldaman was real after all. Prospector Stormpike was amazed.")
hl(1139, "Advisor Belgrum received the Tablet of Will, Hammertoe's dream, for the king's mages to study.",
    "Belgrum received the Tablet of Will, the stone shard Hammertoe had dreamt of finding.")
hl(2204, "Talvash del Kissel took the power source from Uldaman and prepared to fuse it with the necklace and its gems.",
    "Talvash began restoring the necklace with the power source from Uldaman.")
hl(2341, "Jarkal Mossmeld gave a necklace made with the power source from Uldaman, while Droffers and Son knew nothing of it.",
    "The power source let Jarkal Mossmeld make one necklace for his helper and another for himself.")
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
    "Tran'rek called the shell-bearer a real lifesaver. The shells were what Krazek's load had been waiting on.",
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
    "Jammal'an the Prophet had cast the Atal'ai exile out for his doubts. The artifacts were harmless, the exile said, but the right fetish enchantment could put the world in peril.",
    "Jammal'an's faith in his prophecy would destroy the Atal'ai, the exile warned. The news had to go back to Fel'Zerul in Stonard.",
    "Fel'Zerul had not seen the traveler in some time, and wanted to know what the exile had said.",
    "Fel'Zerul asked to hear the exile's knowledge.")
q(1445, "The Temple of Atal'Hakkar", "Swamp of Sorrows", 50, "atalai", 4,
    "Jammal'an believed Hakkar's return would make the Atal'ai immortal. To Fel'Zerul it was trickery, and the enchanted fetishes the exile spoke of worried him.",
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

-- band5060 (2026-11-06): Blackrock Spire chains (Helendis's worgs, Kibler, Tinkee's eggs,
-- Ridgewell's collectors, Vivian Lagrave, Ragged John, Bijou both factions, Finkle, Maxwell's strike).
q(4701, "Put Her Down", "Blackrock Spire", 59, "blackrock", 4,
    "No matter how many of the Blackrock worgs were destroyed, their numbers never dwindled. Helendis Riverhorn's scouts reported that the worgs were bred, trained and exported from Blackrock Spire, the capital of the Blackrock orcs. There the source of the menace had to be found and destroyed.",
    "Helendis Riverhorn at Morgan's Vigil wanted the source of the Blackrock worgs found inside Blackrock Spire, where the orcs bred and trained them. He called on Cenarius for protection.",
    "The beast at the source had been corrupt, Helendis said, a product of dark magic, and her suffering was not to be dwelt on. A great service had been done for the Alliance.",
    "The creature had been a thing of dark magic, Helendis said, and its suffering was not to weigh on the one who ended it. It was a great service to the Alliance.")
q(4729, "Kibler's Exotic Pets", "Burning Steppes", 59, "kibler", 2,
    "Kibler's cages said it all. An animal lover first and a salesman by trade, he tracked down exotic animals for the rich and famous and domesticated them into proper pets. He handed over a beast cage with a simple request, worg pups, in return for a worg of one's own.",
    "For a domesticated worg, Kibler asked only for worg pups brought back alive in his beast cage.",
    "The pups had come at the perfect time, Kibler said, since any later and they would have been untrainable. He asked for a minute to get the little fella ready to take home.",
    "Kibler took the pups and set about readying one as a pet. Another day, he said, and they could never have been trained.")
q(4734, "Egg Freezing", "Blackrock Spire", 60, "plaguedragons", 3,
    "Tinkee Steamboil had been working hard on a new device, the eggscilloscope. It was meant to project a burst of cold at a black dragon's egg and freeze it solid. High in Blackrock Spire the dragons kept a rookery, and that was where it had to be tested. Frozen eggs should be harmless, Tinkee said, and only the unfrozen ones were a worry.",
    "The eggscilloscope wanted testing on the black dragon eggs in the Rookery of Blackrock Spire. Frozen eggs should be harmless, Tinkee said.",
    "It worked, and Tinkee had known it would. While the test went on, she had built a new version with a much longer range. One went along in case of another visit to the Spire.",
    "Splendid, Tinkee said. A longer-range eggscilloscope was already finished, and one was given away for the next trip to Blackrock Spire.")
q(4735, "Egg Collection", "Blackrock Spire", 60, "plaguedragons", 4,
    "Tinkee was finally ready for real samples of dragon eggs. A collectronic module would extract an egg in the Rookery and prepare it for transport. She warned that the eggs had to be frozen first, or they might hatch before they could be collected.",
    "The collectronic module could extract a dragon egg for transport. Tinkee wanted eggs from the Rookery, frozen before they were taken.",
    "The collectronic module worked, and Tinkee claimed genius. Her patron would be very pleased to get the eggs.",
    "Frozen eggs from the Rookery reached Tinkee, who called the module's success proof of genius and spoke of a patron who would be pleased.")
q(4764, "Doomrigger's Clasp", "Blackrock Spire", 60, "ridgewell", 3,
    "High in Blackrock Spire was a chamber once called the Hall of Fortune. There the Dark Iron dwarves had kept their relics, trophies and objects of art. The hall was said to have collapsed and been turned to less savory uses, but Mayara Brightwing believed some old relics remained. One was Doomrigger's clasp, so encrusted with rare gems that any dwarf who gazed on it was said to weep.",
    "Mayara Brightwing wanted Doomrigger's clasp from the old Hall of Fortune in Blackrock Spire, a relic said to make any dwarf who saw it weep.",
    "So the rumors were true. Mayara's patron, Count Remington Ridgewell, would be pleased to add the clasp to his collection.",
    "Doomrigger's clasp came out of the Spire, and Mayara named the patron who would want it, Count Remington Ridgewell.")
q(4765, "Delivery to Ridgewell", "Stormwind City", 60, "ridgewell", 3,
    "Mayara packed Doomrigger's Clasp into a crate for shipment to Stormwind and asked one last favor, that it be delivered to Count Remington Ridgewell in the Keep.",
    "The crated clasp was bound for Count Remington Ridgewell in Stormwind Keep.",
    "Ridgewell gave his thanks and observed that the gratitude of a noble of his house was nigh worth a king's ransom.",
    "Delivered to the Keep, the crate earned the Count's thanks and a remark that the gratitude of his house was nigh worth a king's ransom.")
q(4766, "Mayara Brightwing", "Burning Steppes", 60, "ridgewell", 2,
    "Count Ridgewell had sent his agent Mayara Brightwing to scout the ruined city of Thaurissan for objects that would fit the family museum. She had found something, but not in Thaurissan. Retrieving it meant a foray into Blackrock Spire, and she was in the Burning Steppes to explain.",
    "Mayara Brightwing, Ridgewell's agent in the Burning Steppes, needed help with an object of art. It lay in Blackrock Spire rather than the ruins she had been sent to scout.",
    "Mayara knew of a piece Remington would kill to have in his museum, and extracting it would not be easy. That was where the newcomer came in.",
    "A visitor from Stormwind was welcome. Mayara had her eye on something Remington would kill for, and no easy way to get it.")
q(4768, "The Darkstone Tablet", "Blackrock Spire", 60, "lagrave", 3,
    "The Darkstone Tablet held the writings of the long-dead dwarf Urheld Darkstone. He had been an alchemist of great skill, thought insane by his contemporaries, and so he had etched his research onto tablets rather than share it. Vivian Lagrave believed one lay in Blackrock Spire, in a chamber once named the Hall of Fortune. Few entered Blackrock and returned.",
    "Vivian Lagrave wanted the Darkstone Tablet, the etched research of a mad alchemist, from the old Hall of Fortune in Blackrock Spire.",
    "The formulae on the tablet would consume days of research, Vivian said, and she was confident it would bear sweet fruit.",
    "The Darkstone Tablet reached Vivian Lagrave in Kargath. Days of research lay ahead, she said, and she expected sweet fruit from them.")
q(4769, "Vivian Lagrave and the Darkstone Tablet", "Badlands", 60, "lagrave", 2,
    "Word had come from Vivian Lagrave in Kargath. Her studies pointed to an ancient text inside Blackrock Spire that would help the research. Confirming it meant someone had to bring the text out of the Spire, and that was no easy task.",
    "Vivian Lagrave in Kargath believed an ancient text in Blackrock Spire would serve the research, and needed someone to fetch it.",
    "It was true, Vivian said. A tablet of old alchemical recipes lay somewhere in Blackrock Spire, and she needed help to retrieve it. She asked her visitor to get comfortable while she explained.",
    "In Kargath, Vivian confirmed the tablet of old recipes inside the Spire and settled in to explain the task.")
q(4866, "Mother's Milk", "Blackrock Spire", 60, "blackrock", 3,
    "Ragged John called it one of the most potent poisons in the world. In his jaunts into the Spire he had overheard the Blackrock talk of its lethality. They called it Mother's Milk, after Mother Smolderweb, the big spider in the Skitterweb cave. He wanted a live sample flowing through a volunteer's veins so he could milk it out, and he rubbed his hands at the thought.",
    "The gland alone would not do. Ragged John wanted Mother Smolderweb's poison carried back in a living body from the Skitterweb cave, and he would do the milking himself.",
    "It would make the best ale yet, John said, and he could not see why anyone had thought he wanted it for poison.",
    "The volunteer was milked of Mother's Milk and learned what Ragged John wanted it for. It was for ale, the best yet.")
q(4867, "Urok Doomhowl", "Blackrock Spire", 60, "blackrock", 3,
    "Someone cursed inside Blackrock Spire could barely speak. He pressed a note into a visitor's hands and begged for his mojo.",
    "In Blackrock Spire, a victim of a curse could hardly get the words out, only a note and a plea to bring back his mojo.",
    "His powers were returning already, he said, and Urok's curse no longer wracked his mind. Humility was beneath him, but he acknowledged the aid. Anyone who thought to reach the top of Blackrock Spire was a fool, he said, though of unquestioned bravery.",
    "With his mojo back and Urok's curse lifted from his mind, he managed thanks of a sort, since humility was beneath him. He wished the fool who meant to climb the Spire good fortune.")
q(4981, "Operative Bijou", "Blackrock Spire", 59, "bijou", 3,
    "Never trust a goblin, Lexlort said. Bijou was one of the K.E.F.'s slipperiest operatives. Lexlort had found out she was two-timing them for a shady exotic pet dealer in the Burning Steppes named Kibler, with Horde funds paying for it. He wanted her brought back alive from Blackrock Spire, where she was last seen, and warned against her sweet talk.",
    "Operative Bijou had been working for Kibler on Horde money, and Grandmaster Lexlort wanted her back from Blackrock Spire alive, sweet talk and all.",
    "Bijou did not lie about it. She had needed the money, and Kibler paid far better than the K.E.F. ever could. But her loyalties were not in doubt, she said. Only someone truly daft would come to Blackrock Spire to collect pets, and the last thing the world needed was that kind of person breeding.",
    "Found in the Spire, Bijou admitted taking Kibler's money and denied that her loyalties had ever wavered. Nobody came to Blackrock Spire for pets, she said, except the kind of person who should not be allowed to breed.")
q(4982, "Bijou's Belongings", "Blackrock Spire", 59, "bijou", 3,
    "At night, when the city was lightly guarded, Bijou crept around taking notes on anything of strategic value to the K.E.F. The night before, she had tripped a wire and set off an alarm. She had stashed her recon gear and run, and with the patrols doubled and tripled she could not get back to it. If her belongings came back, she said, she would return to the K.E.F. peacefully.",
    "Bijou's recon gear lay stashed somewhere in the Spire after a tripped alarm, and the patrols had tripled. She offered to come quietly once it was back in her hands.",
    "Bijou had her gear. Once Lexlort saw the plans, she said, he would forget all the nasty things he had meant to do to her. She called the one who fetched them her hero.",
    "Her belongings recovered, Bijou expected Lexlort's temper to melt at the sight of the plans, and declared the finder her hero.", true)
q(4983, "Bijou's Reconnaissance Report", "Badlands", 59, "bijou", 4,
    "Bijou's report was for Lexlort. It would redeem her good name, she said, and give the K.E.F. a strategic advantage over the orcs. She had far too much work to come along herself.",
    "Bijou stayed in the Spire and sent her reconnaissance report to Lexlort in Kargath, where it was needed as soon as possible.",
    "Lexlort had to hand it to her, for she had weaseled out of another sticky situation. The reports would prove invaluable against the Blackrock orcs, and he paid for the work.",
    "The reports reached Kargath, and Lexlort admitted Bijou had wriggled free again. Her notes on the Blackrock would be invaluable, he said.")
q(5001, "Bijou's Belongings", "Blackrock Spire", 59, "bijou", 3,
    "Bijou did not ordinarily deal with the Alliance, but she was stuck between a troll and a hard place. Her mission mattered to the Horde, yet what she had learned concerned the Alliance's well-being too. The Blackrock threat was bigger than a bunch of orcs, she said, and she proposed a deal, her information for the return of her lost belongings.",
    "Bijou, a Horde operative who called herself no Alliance sympathizer, offered a trade in Blackrock Spire. In return for her lost belongings, she would share information that concerned both sides.",
    "Astonished, Bijou asked where her belongings had been.",
    "Her belongings came back, and Bijou wanted to know where on earth they had been.", true)
fallback("Bijou's Belongings", "Blackrock Spire", "bijou", "4982,5001",
    "Bijou, a goblin operative of the K.E.F., had lost her recon gear somewhere in Blackrock Spire after tripping an alarm.",
    "Somewhere in the Spire lay the belongings Bijou had stashed when the alarms went off.",
    "Bijou's belongings were recovered from Blackrock Spire.",
    "The goblin operative had her gear back.")
q(5002, "Message to Maxwell", "Burning Steppes", 59, "bijou", 4,
    "A goblin of her word, Bijou shared what she knew. The Blackrock orcs were beasts of burden and cannon fodder for the black dragonflight, and their true leader was Nefarian, brood of Deathwing. She had found where his subordinates were in that part of the citadel and marked them on a map. It was to go to Marshal Maxwell in the Burning Steppes.",
    "Bijou's map marked the lairs of Nefarian's subordinates in Blackrock Spire, and named the black dragon as the orcs' true master. Marshal Maxwell was to have it.",
    "The map matched much of what Maxwell already knew. Interesting and rather unfortunate information, he called it, and its markings would be valuable in thinning the Blackrock menace.",
    "Maxwell took Bijou's map as confirmation of much that he already knew, unfortunate as it was. He valued its markings for thinning the Blackrock menace.")
q(5047, "Finkle Einhorn, At Your Service!", "Winterspring", 60, "finkle", 3,
    "Finkle Einhorn sent word to Malyfous Darkhammer in Everlook that Finkle was A-OK and the suit worked perfectly. With the message went a glowing piece of flesh, snatched from the beast's innards during his vacation. He reckoned Malyfous could say what might be made from parts of a monster like that.",
    "A glowing piece of flesh from inside the beast was to go to Malyfous Darkhammer in Everlook. With it went Finkle's message that he was alive and his suit had worked.",
    "Malyfous echoed the news that Finkle was alive and the suit had worked, then asked about the glowing flesh.",
    "In Everlook, Malyfous took in the news of Finkle in a few words and turned to the glowing flesh.")
q(5081, "Maxwell's Mission", "Blackrock Spire", 60, "maxwell", 5,
    "Bijou's information filled the gaps in Maxwell's otherwise impeccable intelligence of Blackrock Spire, and the attack had to be decisive. The war master, the troll Voone, had to die first, for without his battle plans the Blackrock orcs would be thrown into chaos. Then came the ogre Highlord Omokk, without whom the cowardly ogres were powerless. Last was the overlord of the citadel, Wyrmthalak, whose death would leave their central command without a conduit.",
    "Marshal Maxwell named three targets in the lower Spire, in order. They were War Master Voone, Highlord Omokk and Overlord Wyrmthalak, each a pillar the Blackrock could not stand without.",
    "Excellent work, Maxwell said. At the very least the strike had bought precious time.",
    "Voone, Omokk and Wyrmthalak were dead. Maxwell counted the time it bought as precious.")
q(5089, "General Drakkisath's Command", "Blackrock Spire", 60, "maxwell", 4,
    "On the corpse of the defeated serpent lay a note of some importance, a letter from his superior, General Drakkisath, concerning protocol. Instinct said to take it to Marshal Maxwell.",
    "A letter from General Drakkisath, found on the body of the serpent he commanded, belonged in Marshal Maxwell's hands.",
    "The plot thickened, Maxwell said.",
    "Maxwell read Drakkisath's letter and said the plot was thickening.")
q(5102, "General Drakkisath's Demise", "Blackrock Spire", 60, "maxwell", 6,
    "The Alliance fought the beasts of Blackrock on two fronts, Maxwell said. Stormwind fought them from the inside out, and here in the Burning Steppes the battle was taken to their doorstep. None were to be spared, as none of the Alliance's own had been spared when the enemy struck at homes and families. General Drakkisath was to be found and destroyed, and the reward would be extravagant.",
    "Marshal Maxwell wanted General Drakkisath dead. The task would not be simple, he said, but the rewards would be extravagant.",
    "Well done, Maxwell told the brave soldier of the Alliance. Surely the dragon lords would be next.",
    "Drakkisath was dead, and Maxwell spoke of the dragon lords as the next to be struck.")
for _, id in ipairs({4701, 4729, 4734, 4735, 4764, 4765, 4766, 4768, 4769, 4866, 4867, 4981, 4982, 4983, 5001, 5002, 5047, 5081, 5089, 5102}) do src(id) end

-- band5060 (2026-11-06): Felwood (Xavaric's flute, the Circle's blood amber, the ancient spirit, the
-- Forsaken's corrupted sabers, the wildkin of Winterspring, Greta's search for pure water, Arko'narin
-- and Trey Lightforge, the dying druid Mulgris, the furbolg ritual totems).
q(939, "Flute of Xavaric", "Felwood", 54, "ancientflute", 3,
    "The simple wooden flute taken from Xavaric felt solid enough. Yet the spirals in its surface seemed to spin and move when it was turned over. A sense of dread came with it. It was easy to blame on a trick of the mind. Other satyrs might carry clues to what it was, and the druid Eridan Bluewind lived in southern Felwood.",
    "Xavaric's flute was knotted wood whose patterns seemed to move. It went to the druid Eridan Bluewind in the south of Felwood, along with whatever else the satyrs carried.",
    "Eridan sensed the suffering of ancient ones in what had been found. Holding it was almost unbearable, she said.",
    "To Eridan the flute carried the suffering of ancient ones, and she could hardly bear to hold it.")
q(4101, "Cleansing Felwood", "Felwood", 55, "felwood", 3,
    "Plants gave life to Felwood, and even they suffered the taint. A druid of the Cenarion Circle knew ways to cleanse them, but would not share such knowledge with a stranger. Proof came first, in the form of blood amber. It was the sap of the Warpwood elementals in the Irontree Caverns to the north, which were beyond hope of cleansing. Studied, it might help save other life.",
    "Before the druid would teach the cleansing of Felwood's plants, trust had to be earned. Its price was blood amber, the sap of the Warpwood elementals of the Irontree Caverns.",
    "The blood amber would go toward a means of defeating Felwood's corruption. Its bringer now had the druid's trust. Killing the elementals might seem an odd proof, but saving countless beings justified the means. The time had come to cleanse Felwood, with the salves the druid could make.",
    "With the blood amber delivered, the druid spoke of trust and of salves. The time had come to cleanse Felwood.", true)
q(4102, "Cleansing Felwood", "Felwood", 55, "felwood", 3,
    "Even the plants that gave life to Felwood suffered its taint. The Cenarion Circle's druid could cleanse them, but only trusted hands would be taught how. First came blood amber from the Warpwood elementals in the Irontree Caverns to the north. Those creatures were past saving, and their sap would be studied to save others.",
    "Blood amber, the sap of the Warpwood elementals in the Irontree Caverns, was the price of the Circle's trust. With it came the knowledge to cleanse Felwood's plants.",
    "Over the blood amber, the druid spoke of a means to defeat the corruption. It was odd, the druid admitted, that killing the elementals should be the proof. The end of saving countless beings justified it, and the work of preservation could begin with the druid's salves.",
    "Trust was given with the blood amber, and the cleansing of Felwood could begin through the druid's salves.", true)
fallback("Cleansing Felwood", "Felwood", "felwood", "4101,4102",
    "A druid of the Cenarion Circle in Felwood knew how to cleanse the forest's tainted plants, and asked for proof of trust first.",
    "Blood amber from the Warpwood elementals of the Irontree Caverns was the Circle's test before it shared the cleansing of plants.",
    "The Circle's druid in Felwood received the blood amber.",
    "Work toward cleansing Felwood's plants went on.")
q(4261, "Ancient Spirit", "Felwood", 56, "ancientflute", 4,
    "Felwood had been peaceful once, the ancient spirit said, until the Legion took hold with its infernals, destruction and chaos. The skull of Gul'dan had ensured that none were spared. Even as a spirit it remained trapped, bearing the land's suffering. It asked to be led away to where it might rest. Once it was free, Kayneth Stillwind, a druid to the east in Ashenvale, was to be told.",
    "The ancient's spirit was still bound to the suffering of Felwood. It asked to be led away to rest. A druid in Ashenvale, Kayneth Stillwind, was to be told afterward.",
    "Kayneth Stillwind gave thanks, for Felwood had been through much hardship. One day it might be reclaimed from the corruption, and every kind deed helped.",
    "In Ashenvale, Kayneth Stillwind heard that the ancient spirit was free. Every kind deed helped toward reclaiming the forest, Kayneth said.")
q(4505, "Well of Corruption", "Felwood", 54, "sabers", 3,
    "Some might call it exceptionally cruel, the Forsaken said. It was only a strong desire to see the Horde gain any advantage over the Alliance. The newest interest was the moonwell at the Ruins of Constellas. Once a symbol of renewal for the insufferable night elves, it was now corrupted. The Jadefire satyrs used it to bring forth more of their kind. A sample of its water was wanted, for a little feline friend.",
    "A Forsaken in Felwood wanted water from the corrupted moonwell at the Ruins of Constellas, for an idea involving a kitten.",
    "Very well, the Forsaken said over the sample. A way had to be found to use the corruption against the enemy.",
    "The corrupted water arrived, and its collector spoke of finding a way to turn it against the Alliance.")
q(4506, "Corrupted Sabers", "Felwood", 54, "sabers", 4,
    "A small amount of the moonwell water had doubled the kitten in size and somehow made it stronger. Such cats might prove useful, the Forsaken thought. The kitten went into a carrier, to be released beside the moonwell in the Ruins of Constellas and brought back. Its keeper promised that the results would please.",
    "The corrupted water had already doubled one kitten in size. Released beside the moonwell at Constellas, the cat was expected to change further. Its keeper promised it would be worth the trouble.",
    "Excellent, the Forsaken said. The Forsaken would resort to any means to crush the Alliance. Corrupted water like this would surely serve in future efforts.",
    "Back from Constellas came the changed cat. Its keeper spoke of future efforts and of any means necessary against the Alliance.")
q(4521, "Wild Guardians", "Winterspring", 56, "wildkin", 3,
    "Winterspring lay just beyond Timbermaw, northeast of Felwood. It was said to be laden with wildkin, beasts known to guard secrets of the night elves. What lay hidden there was worth finding out. The ragged owlbeasts lived south of the road, the raging ones in the center of Winterspring. Both were to be cleared.",
    "Wildkin guarded the secrets of Winterspring. The first to be cleared were the ragged owlbeasts south of the road and the raging ones in the center.",
    "Excellent news, came the answer. With the beasts out of the way, the venture into Winterspring could go further, and more work was offered.",
    "With the first owlbeasts cleared, the way deeper into Winterspring lay open, and more work followed.", true)
q(4741, "Wild Guardians", "Winterspring", 58, "wildkin", 3,
    "In the north of Winterspring the wildkin grew even more ferocious. Measures continued there against the moontouched owlbeasts, and the ground they lived on was to be explored.",
    "Thirteen moontouched owlbeasts in northern Winterspring were the next measure, on dangerous ground.",
    "The one directing the hunt sensed that the work was being enjoyed, and believed they were onto something.",
    "After the thirteenth owlbeast, the one directing the hunt sensed they were onto something.", true)
q(4721, "Wild Guardians", "Winterspring", 59, "wildkin", 4,
    "Runners back from Winterspring reported a series of small caves in the south, with wildkin settled around them. If the creatures were guarding something valuable, that was where it would be. These wildkin were worse than the earlier kinds, maddened by exposure to the very thing they protected.",
    "Wildkin crowded the small caves in southern Winterspring, driven mad by whatever they guarded there. The caves were the next target.",
    "Hard work earned great respect, came the answer, and the plans for Winterspring could move forward.",
    "Once the caves in the south were cleared, the plans for Winterspring went forward.", true)
fallback("Wild Guardians", "Winterspring", "wildkin", "4521,4741,4721",
    "The wildkin of Winterspring were said to guard secrets of the night elves, and someone wanted them thinned to reach whatever was hidden.",
    "Owlbeasts across Winterspring stood between the curious and the secrets the wildkin guarded.",
    "More of Winterspring's wildkin were cleared.",
    "The measures against the wildkin of Winterspring continued.")
q(4906, "Further Corruption", "Felwood", 54, "felwood", 4,
    "A second camp of satyrs threatened Felwood to the north, led by the cruel Xavaric. Xavathras and his minions had been only part of a larger plan, Eridan explained. They had cultivated a corrupted moonwell to hand its spoils to Xavaric. With Xavathras gone, Xavaric was to be defeated.",
    "Xavathras had served Xavaric, whose satyrs held a second camp in the north of Felwood. Eridan asked that the task be finished there.",
    "Thanks came from Eridan for all that had been done, with a prayer that Elune protect and guide the path ahead.",
    "Xavaric was dead. Eridan's thanks came with a blessing of Elune for the path ahead.")
q(4984, "The Wildlife Suffers Too", "Western Plaguelands", 54, "mulgris", 3,
    "There was little one druid could do alone against the Scourge, the tauren said, but he had come to heal the damage done to nature. The animals suffered from the plague that choked the land, unable to find mercy or peace. For the diseased wolves nearby, the only salvation left was a merciful release. Ending their misery, he said, would soothe his own.",
    "A tauren druid in a cottage in the Plaguelands asked for the diseased wolves nearby to be put down. There was no cure for them but a merciful death.",
    "The druid sensed that the souls of the wolves now had rest, and gave thanks on their behalf and his own. Other creatures suffered in that damnable place, he said, and he had need of help once more.",
    "The wolves were at rest, the druid sensed. He gave thanks and spoke of other creatures suffering in that damnable place.", true)
q(4985, "The Wildlife Suffers Too", "Western Plaguelands", 56, "mulgris", 4,
    "To the east, near where the Eastern Plaguelands began, once proud grizzlies roamed the countryside. The plague had sundered them too, and they wandered in agony as their muscles stiffened and their fur and flesh rotted. As the druid said, the only cure for their misery was a swift death by another's hand.",
    "The plagued grizzlies east of the cottage were the druid's next mercy, and the only cure he knew for them was a swift death.",
    "Their torment was at an end, the druid knew. He had one more thing, written on a branch when he sensed his time in this realm was over. The creatures of that land might rest now, he said, and so would he. A heavy sigh followed, then a death rattle, and his body lay still on the cottage floor.",
    "Knowing the grizzlies' torment was over, the druid spoke of a branch he had written on when he felt his end coming. He gave his thanks and died on the floor of the cottage with a sigh.", true)
fallback("The Wildlife Suffers Too", "Western Plaguelands", "mulgris", "4984,4985",
    "A tauren druid in the Plaguelands asked for the plague-ridden animals to be given a merciful death.",
    "The druid in the cottage could not heal the plagued beasts, only ask for their release.",
    "More of the Plaguelands' suffering animals were released.",
    "The druid's mercy for the plagued wildlife went on.")
q(4986, "Glyphed Oaken Branch", "Darnassus", 56, "mulgris", 4,
    "The dead tauren's hand clutched a surprisingly healthy oaken branch carved with druidic glyphs. It was warm to the touch, more than it should have been. Holding it brought the image of Teldrassil to mind, Darnassus in particular, and the words Cenarion Circle to the tip of the tongue. That suggestion seemed to have been placed within the branch.",
    "An oaken branch, warm and carved with glyphs, lay in the dead druid's hand. It carried its own direction, Darnassus and the Cenarion Circle.",
    "The Circle in Darnassus found it strange that a tauren druid had entrusted a stranger with so much. Valuable information on the extent of the Scourge's plague had been given freely. They would make good use of it, and perhaps the tauren had not fallen as far from Cenarius as Fandral believed.",
    "In Darnassus the branch was received with surprise that a tauren had given it freely. The Circle promised to make good use of what it held about the plague. Perhaps, they said, the tauren had not fallen so far from Cenarius as Fandral believed.", true)
q(4987, "Glyphed Oaken Branch", "Thunder Bluff", 56, "mulgris", 4,
    "The dead tauren's hand clutched a surprisingly healthy oaken branch carved with druidic glyphs. It was warm to the touch, more than it should have been. Holding it brought Thunder Bluff to mind, Elder Rise in particular, and the words Cenarion Circle to the tip of the tongue.",
    "An oaken branch, warm and carved with glyphs, lay in the dead druid's hand. It carried its own direction, Elder Rise in Thunder Bluff and the Cenarion Circle.",
    "The branch was from Mulgris. Those on Elder Rise had heard he sought to minister to the suffering creatures of the Plaguelands. His death was unexpected and saddening. Mulgris had been a good friend, and the druid who received the branch would mourn him deeply. His efforts were not in vain. The branch stored much lore of the Scourge's plague, and they would study it.",
    "On Elder Rise, the druids learned that Mulgris was dead and mourned a good friend. The branch he had carved held much about the plague, and his efforts had not been in vain.", true)
fallback("Glyphed Oaken Branch", "Western Plaguelands", "mulgris", "4986,4987",
    "A dead tauren druid in the Plaguelands had left a glyphed oaken branch that carried its own direction to the Cenarion Circle.",
    "The warm, glyphed branch from the dead druid's hand was meant for the Cenarion Circle.",
    "The glyphed branch reached the Cenarion Circle.",
    "The dead druid's branch was delivered to the Circle.")
q(5156, "Verifying the Corruption", "Felwood", 54, "felwood", 3,
    "North along the east of the road, in Shatter Scar Vale, infernals had been called down during the last great war. The craters still scarred the land, as did the infernals themselves. Greta wanted to know whether entropic elementals still roamed there. She also wondered whether the craters still held the corrupt, fetid water of years ago.",
    "Greta wanted Shatter Scar Vale checked, for entropic elementals and for the foul water in the infernals' craters.",
    "Good that the visitor was alive, Greta said, and bad that the water still existed. She had hoped for at least one pure source of water in Felwood to ease the healing of the land. The search had failed, so she would save what forest creatures she could and destroy those too corrupt to spare.",
    "The craters still held their fetid water, and Greta's hope of a pure source in Felwood was gone. She turned to saving what creatures she could.")
q(5158, "Seeking Spiritual Aid", "The Barrens", 52, "felwood", 3,
    "Greta sent the corrupt water to the Barrens, to an old friend hidden along the shore south of Ratchet. The shaman Islen Waterseer had always had a strong bond with the spirits of water. A noble task should be enough to persuade her and the spirits, Greta said. The pirates nearby were only a nuisance, and no threat.",
    "The canteen of Jaedenar's water went to Islen Waterseer, a shaman camped at the water's edge south of Ratchet. Greta dismissed the pirates on the way as a nuisance.",
    "Islen understood the need, and called stopping the malice in Felwood noble enough. It was not hers to decide whether the water would be purified. She would ask the spirits of water, and it would be up to them whether the cause was just.",
    "At her camp on the shore, Islen agreed to put the plea to the spirits of water. The decision, she said, was theirs.")
q(5202, "A Strange Red Key", "Felwood", 55, "arkonarin", 3,
    "The small red key seemed made of bone, heavy in the hand yet fragile. Why a member of the Shadow Council carried such a thing was unclear. Perhaps it unlocked something in Jaedenar.",
    "A bone key taken from the Shadow Council might open something in Jaedenar. Its purpose was a mystery.",
    "The key was the right one. At the sight of it the prisoner begged to have it, to escape at last.",
    "At the sight of the red key the captive asked for it at once, since it meant escape.")
q(5203, "Rescue From Jaedenar", "Felwood", 55, "arkonarin", 5,
    "Before escaping, the captive had one thing to do, however it pained her. Trey's sword Lightforge had to be found before she left Shadow Hold to tell her superiors what was happening there. Their equipment was not far, and the path to the top had already been survived once. After the escape she would head for Darnassus. Her friend Jessir was to be found at the Emerald Circle's camp near the Ashenvale border.",
    "The captive would not leave Shadow Hold without Trey's sword Lightforge. After the escape, word was to go to her friend Jessir at the Emerald Circle's camp near the Ashenvale border.",
    "Jessir was glad to be found. Arko had passed by not long before, on her way to Darnassus with Lightforge. It was too urgent, she had said, to stop and be healed by the druids. She had told of the encounter with Trey's spirit, a terrible fate for a Knight of the Silver Hand. Whatever Arko showed, Jessir knew it was tearing her up inside.",
    "Arko'narin had escaped with Lightforge and gone on toward Darnassus without stopping to be healed. Jessir heard what had happened to Trey's spirit. Whatever Arko showed, Jessir knew that losing one of her closest friends was tearing her apart.")
q(5204, "Retribution of the Light", "Felwood", 57, "arkonarin", 5,
    "Arko would pretend she was fine, Jessir said, and wanted to be thought strong enough to bear it alone. Trey's death, and the torture he had suffered, would haunt her a long time. The loose ends could still be tied while she mourned in her own way. Jessir wanted Trey's torturer in Shadow Hold killed and his remains found.",
    "Jessir wanted Trey's torturer dead and the paladin's remains recovered from Shadow Hold, while Arko'narin mourned in private.",
    "Trey's remains were gathered as carefully as could be, his torturer dead. At least his spirit had been released from any pain forced upon it.",
    "Killing the torturer came first, and the paladin's remains were taken up afterward. His spirit, at least, was free of suffering.")
q(5385, "The Remains of Trey Lightforge", "Felwood", 57, "arkonarin", 5,
    "The sack of remains was for Jessir Moonbow, on the border of Felwood and Ashenvale. Passed on to his friends, the paladin might be given the proper respects.",
    "Trey Lightforge's remains went carefully back to Jessir Moonbow at the edge of Ashenvale.",
    "Jessir praised Elune and whichever powers the bearer worshipped. It was an honorable and noble thing, she said. Arko'narin would be pleased that her rescuer had also slain the creature who tortured one of her best friends. She gave what little she could.",
    "Jessir received Trey's remains with thanks to Elune. Arko'narin would be pleased, she said, that the torturer of her friend was dead too.")
q(8470, "Deadwood Ritual Totem", "Felwood", 55, "timbermaw", 3,
    "One of the Deadwood's ritual totems was plain in its construction, but a palpable despair came off it. No object showed better the corruption the Deadwood suffered under. A furbolg inside Timbermaw Hold might have a use for it, if trust had been earned enough for them to speak.",
    "A Deadwood ritual totem, plain to look at and heavy with despair, was carried into Timbermaw Hold for the furbolgs there.",
    "The Timbermaw recognized the Deadwood totem, thick with the stench of decay. Whatever foulness had turned their brethren against them was in it, they said. Through study and ritual they might uncover what polluted their brethren's minds, and they gave offerings in exchange.",
    "Inside the Hold, the totem was known for the Deadwood's and reeked of decay. The Timbermaw meant to study it for whatever had poisoned their brethren's minds. They gave offerings for the find.")
q(8471, "Winterfall Ritual Totem", "Winterspring", 56, "timbermaw", 3,
    "One of the Winterfall's ritual totems gave off an almost tangible dread and despair. If many of the Winterfall carried such things, that went a long way toward explaining their condition. A furbolg inside Timbermaw Hold might have a use for it, if trust had been earned.",
    "A Winterfall ritual totem, heavy with dread, went to the furbolgs inside Timbermaw Hold.",
    "The Timbermaw saw the shape of a Winterfall ritual totem, twisted by forces they could not comprehend. Whatever taint had set the Winterfall against them was in it. Divine wisdom had brought both totem and bearer, they said. They would study it, in the hope that one day the Winterfall would rage no longer.",
    "The Winterfall totem was twisted past the Timbermaw's understanding. They took it for study, hoping their eastern brethren might one day stop raging, and gave offerings for the benevolence.")
for _, id in ipairs({939, 4101, 4102, 4261, 4505, 4506, 4521, 4741, 4721, 4906, 4984, 4985, 4986, 4987, 5156, 5158, 5202, 5203, 5204, 5385, 8470, 8471}) do src(id) end

-- band5060 (2026-11-06): Winterspring (Mau'ari's charm, Krakle and the springs, Darkwhisper Gorge,
-- Kelek and the log, Meggi, Erelas's feathers, Jaron's camp, Kibler's spiders, the wildkin necklace,
-- the frostsaber trainer's hunts).
q(969, "Luck Be With You", "Winterspring", 60, "mauari", 2,
    "Mau'ari could tell at a glance who wanted a lucky charm, since Mau'ari always knew. South of her lay a canyon of giants made of solid ice. Their frostmaul shards had a powerful reflective quality. They could be taken from the giants or gathered in the canyon. Ten of them would buy her charm.",
    "Ten frostmaul shards from the ice giants' canyon to the south were Mau'ari's price for a lucky charm.",
    "Mau'ari took the shards and set about making the charm. Just wait, she said.",
    "The shards were enough. Mau'ari began on the charm and asked for patience.")
q(975, "Cache of Mau'ari", "Winterspring", 60, "mauari", 3,
    "Before handing over the charm, Mau'ari explained how it worked. Carried, it made certain items drop from the creatures one fought, items called E'ko that could not be found without it. Any E'ko brought back to old Mau'ari would earn her help. She asked for a moment to fix the charm.",
    "The charm had rules, Mau'ari said. Whoever carried it would find E'ko on the creatures they fought, and Mau'ari would help with any brought to her.",
    "Mau'ari handed over the finished charm with a reminder to carry it. Then she sent its owner back to the wilds to see what turned up.",
    "The charm was done. It had to be carried always, Mau'ari said, and the wilds would show what they gave up.")
q(974, "Finding the Source", "Un'Goro Crater", 55, "winterfall", 2,
    "The hot springs near Fire Plume Ridge were a mystery to Krakle. Krakle wanted to know where their heat came from, and whether the nearby volcano had something to do with it. A thermometer of Krakle's own making, reading in degrees Kraklenheit, was to take readings wherever the ridge was hottest.",
    "Krakle's thermometer read in degrees Kraklenheit. It was to take readings at the hot spots of Fire Plume Ridge, to link the volcano to the springs below.",
    "Krakle saw the correlation between the volcano's temperature and the hot springs at once. The equations needed double-checking, but the distance and the rate of heat transfer seemed to fit.",
    "The readings satisfied Krakle that the volcano heated the springs, though the equations still needed checking.")
q(980, "The New Springs", "Winterspring", 55, "winterfall", 2,
    "Krakle had heard of other hot springs far to the north, in a place called Winterspring, with no volcano anywhere near them. A friend of Krakle's, Donova Snowden, was staying by those springs and could say more.",
    "Hot springs without a volcano, up in Winterspring, puzzled Krakle. A friend named Donova Snowden was camped beside them.",
    "Donova confirmed what Krakle had said. The springs of Winterspring had no volcano near them.",
    "At the Winterspring springs, Donova said Krakle had told it true.")
q(4842, "Strange Sources", "Winterspring", 56, "winterfall", 3,
    "There were no volcanoes in Winterspring, Donova said, but she believed something far more threatening lay behind its hot springs. It had to be seen to be understood. Far in the south of Winterspring, the air turned thick and muggy and the sky dark, and there lay the source.",
    "Donova sent the question of the springs to the far south of Winterspring, where the sky went dark and the air thick. That, she believed, was the source.",
    "Donova believed the presence of demons in Darkwhisper Gorge was affecting the land. She would go on observing the springs, and advised growing stronger before going any farther into the gorge.",
    "Darkwhisper Gorge held demons, and Donova blamed their presence for the springs. She warned against going deeper into the gorge for now.")
q(5128, "Words of the High Chief", "Felwood", 59, "winterfall", 3,
    "The Winterfall were no longer a threat to Donova. Anyone still curious about what had driven the furbolgs to make and drink the firewater should seek out Kelek Skykeeper. He was one of the Emerald Circle's druids healing Felwood, with much experience of its furbolgs. Perhaps he could read the log.",
    "Donova passed the high chief's log on to Kelek Skykeeper of the Emerald Circle in Felwood. He knew the furbolgs better than she did.",
    "Kelek flipped through the pages and thought he might translate it, given time. He would send word once he had looked it over fully, since very little was known about the Winterfall furbolg.",
    "Kelek took the log for study and promised word once he had read it fully. The Winterfall, he said, were little known.")
q(6603, "Trouble in Winterspring!", "Winterspring", 56, "winterfall", 2,
    "There was trouble in Winterspring, Meggi said, and Meggi knew about such things. Hours in the wilds were golden, cultivating quick reflexes, a cool head and a keen eye. It took judgement, brains and maturity to appreciate the wilderness that way. Then Meggi remembered the point, and sent the matter to Donova Snowden at the hot springs.",
    "After a detour through a love of the wilds, Meggi pointed toward Donova Snowden at the hot springs. She could explain the trouble in Winterspring.",
    "Donova greeted the newcomer warmly. So Meggi had told of the trouble she had found there.",
    "At the springs, Donova guessed that Meggi had sent word of her trouble.")
q(978, "Moontouched Wildkin", "Winterspring", 55, "wildkin", 3,
    "Wildkin feathers from the Hinterlands held traces of magic, Erelas Ambersky found. The power seemed inherent to the creatures, part of their very essence, rather than something they wielded. A large population of wildkin was said to live in the snows of Winterspring. Their dropped feathers would show whether they shared it.",
    "Erelas wanted dropped feathers gathered from the wildkin of Winterspring, to compare their magic with the feathers from the Hinterlands.",
    "Now Erelas could compare the feathers, and set to it.",
    "With feathers from Winterspring beside those from the Hinterlands, Erelas began the comparison.")
q(4861, "Enraged Wildkin", "Winterspring", 59, "jaron", 3,
    "Jaron had been chased from his camp in southern Winterspring by bloodthirsty wildkin. He supposed he had got too close to something they guarded. Barely escaping himself, he feared a buddy of his had not been so lucky. Now he wanted his supplies back, and the amulet he had unearthed the day before at the dig site.",
    "Wildkin had driven Jaron off his dig in southern Winterspring. He wanted his supplies and the amulet he had dug up the day before.",
    "At the camp, a severely damaged crate stood out among the rest of the destroyed belongings.",
    "The camp was wrecked, and one badly broken crate stood out among the rest.", true)
q(4863, "Enraged Wildkin", "Winterspring", 59, "jaron", 3,
    "There was little at the camp that Jaron could want. The crate, though, had been smashed open, almost as if it was what the wildkin had been after. To the east an abandoned wagon could just be made out, and Jaron's things might be there.",
    "The smashed crate looked like the wildkin's real target. An abandoned wagon to the east was worth a look for Jaron's things.",
    "There was not much more for Jaron at the wagon either. On the ground, though, lay some crates, undamaged despite being half-buried in the snow.",
    "By the wagon, half-buried in snow, lay crates that had escaped damage.", true)
q(4864, "Enraged Wildkin", "Winterspring", 59, "jaron", 4,
    "The box held tools and other things Jaron could use, but no sign of the amulet. Wildkin lived to the north and east, so the next step was to face them and take it back.",
    "Jaron's tools were recovered, but the amulet was with the wildkin to the north and east.",
    "As much was expected, Jaron said, since the crazed beasts had destroyed most of his belongings. But the tools had come back, and most importantly the amulet. He wondered why the wildkin had defended it so fiercely, and he would think twice before heading their way again.",
    "Most of Jaron's belongings were gone, as he had guessed, but his tools and the amulet came back. Why the wildkin had fought so hard for it, he could not say.", true)
q(6604, "Enraged Wildkin", "Winterspring", 59, "jaron", 2,
    "The abandoned camp to the south looked as though the wildkin had gone crazy and destroyed everything they could find. Rumor said a survivor of the attack was resting at Starfall Village, to the west. What had happened there was hard not to wonder about.",
    "Someone was curious about the wrecked camp to the south, and had heard that a survivor rested at Starfall Village.",
    "At Starfall, the survivor asked what could be done.",
    "The survivor at Starfall Village was ready to talk.", true)
fallback("Enraged Wildkin", "Winterspring", "jaron", "4861,4863,4864,6604",
    "Wildkin had wrecked a camp in southern Winterspring, and its owner wanted his belongings and an unearthed amulet back.",
    "A dig camp in southern Winterspring lay destroyed by wildkin.",
    "The search of the wrecked camp in southern Winterspring went on.",
    "Work on the wildkin's attack on the southern camp continued.")
q(4862, "En-Ay-Es-Tee-Why", "Blackrock Spire", 59, "kibler", 2,
    "Believe it or not, Kibler said, people would pay for the most vile domesticated beast. He had sent Bijou into the Spire for spire spider eggs and had not heard from her in weeks. Now he offered a little cash and a domesticated spider to anyone who fetched the eggs from Blackrock Spire instead.",
    "Spire spider eggs from Blackrock Spire were Kibler's next want, since Bijou had gone quiet, and he promised cash and a pet spider for them.",
    "What a load, Kibler said, and the eggs would bring in a right few gold. He handed over a little critter to keep, with a warning not to get bitten.",
    "Pleased at the gold the eggs would bring, Kibler gave a spider to keep, with advice about bites.")
q(4882, "Guarding Secrets", "Winterspring", 59, "wildkin", 3,
    "A necklace fell from the neck of a slain wildkin. It glowed brightly, slowly fading in and out, and its significance was unclear. Trull Failbane knew the wildkin well and might say more.",
    "A glowing necklace from a dead wildkin went to Trull Failbane, whose knowledge of the creatures was extensive.",
    "An important discovery, Trull wondered aloud.",
    "Hearing of the necklace, Trull asked whether it was an important discovery.", true)
q(4883, "Guarding Secrets", "Thunder Bluff", 59, "wildkin", 4,
    "Trull knew much about the owlbeasts of Winterspring, but little of the magics they wielded. Nara Wildmane in Thunder Bluff was an expert in the field, and the necklace went to her.",
    "The necklace's magic was beyond Trull Failbane. He sent it to Nara Wildmane in Thunder Bluff.",
    "Only one source could give the necklace such energy, Nara said. The wildkin, misguided and confused now, had once been guided to serve. Elune, the night elf goddess, had created them to guard her most sacred places. It might seem to mean little, she said, but she urged a deeper look, and promised understanding in time.",
    "In Thunder Bluff, Nara Wildmane traced the necklace's energy to Elune, who had made the wildkin to guard her most sacred places. They had since lost their way, and there was more to it, she said, than first appeared.", true)
fallback("Guarding Secrets", "Winterspring", "wildkin", "4882,4883",
    "A glowing necklace taken from a Winterspring wildkin raised the question of where the creatures' magic came from.",
    "The necklace from a slain wildkin needed someone who understood the creatures' magic.",
    "The wildkin's necklace passed to someone who might explain it.",
    "The question of the wildkin's necklace went on.")
q(4970, "Frostsaber Provisions", "Winterspring", 60, "hunts", 2,
    "Proving oneself to the frostsaber trainer began with a simple but important task. Meat from the chimaera and the shardtooth bears nearby would feed the frostsabers in training.",
    "The frostsabers being trained in Winterspring needed feeding. Their keeper asked for chimaera and shardtooth meat as a first proof.",
    "The trainer gave thanks, and said that opinion of the newcomer grew as time passed.",
    "Fed on chimaera and shardtooth, the frostsabers in training were provided for, and their keeper's regard grew a little.")
q(5055, "Brumeran of the Chillwind", "Winterspring", 58, "hunts", 4,
    "Brumeran glided silently across the snows of southern Winterspring, swift and clever. Her graceful look did not make her harmless, Storm warned. All who crossed her paid dearly, often with their lives. The hunt was to find her among the chimaera and defeat her, Storm Shadowhoof said.",
    "Brumeran of the chillwind, a chimaera of southern Winterspring, had cost many their lives. Her death was Storm's next test.",
    "Storm called the one who returned a true hunter by nature. The most ferocious of creatures had been faced, beyond his expectations, and one final request remained.",
    "Brumeran was dead. Storm called her killer a true hunter by nature, ready for a final request.")
q(5056, "Shy-Rotam", "Winterspring", 60, "hunts", 5,
    "In northern Winterspring, great cats gathered around a landmark called Frostsaber Rock. Their leader was the matriarch Shy-Rotam, and defeating her would earn much respect. Sacred meat from the frostsabers, placed at her stone, would summon her in anger. Storm warned to be ready for her fury.",
    "Shy-Rotam, matriarch of the frostsabers at Frostsaber Rock, would come in anger to the meat of her kin laid on her stone. Storm asked for her defeat.",
    "Strength and determination had both been proven, Storm said. Many more challenges waited, but he had shown all that he could.",
    "Shy-Rotam answered the summons and fell. Storm said there was nothing left to teach.")
q(5057, "Past Endeavors", "Thunder Bluff", 60, "hunts", 4,
    "Storm had heard of the endeavors before they ever spoke, of an unyielding desire to prove oneself and an exceptional ability. Now he knew both to be true. Such excellence deserved recognition, and a marker went to his friend Melor Stonehoof in Thunder Bluff. Melor would remember what had been accomplished so long ago.",
    "Storm sent a marker of the Winterspring hunts to his friend Melor Stonehoof in Thunder Bluff. Melor would remember old deeds and want to hear of the recent victories.",
    "Life's experiences made one stronger and wiser, Melor said, and the visitor had grown much since they first spoke. He gave a remembrance of the difficult tasks accomplished, with his lasting respect and admiration.",
    "In Thunder Bluff, Melor Stonehoof remembered, and gave a token of the hard tasks done, with his respect and admiration.")
q(5201, "Winterfall Intrusion", "Winterspring", 60, "hunts", 3,
    "The frostsaber trainer went unnoticed by most, but one annoyance was firmly rooted in Winterspring, the Winterfall furbolgs. Never attacked by the trainer, they still seemed crazed and fearful of anything in their path. They had slain countless creatures that were simply in the wrong place. Weary of their meddling, the trainer wanted them fought back and kept from Frostsaber Rock.",
    "The crazed Winterfall were killing anything that crossed their path near Frostsaber Rock. Weary of them, the frostsaber trainer wanted them driven off.",
    "For a short while, the trainer said with relief, the Winterfall intrusion need not be worried about. Perseverance was beginning to show.",
    "Pushed back from Frostsaber Rock for a while, the Winterfall gave the trainer a moment's relief. The trainer saw perseverance beginning to show.")
for _, id in ipairs({969, 975, 974, 980, 4842, 5128, 6603, 978, 4861, 4863, 4864, 6604, 4862, 4882, 4883, 4970, 5055, 5056, 5057, 5201}) do src(id) end

-- band5060 (2026-11-06): Scholomance and Stratholme (the Skeleton Key both factions, the Barov
-- brothers, Ras Frostwhisper, Zverenhoff's champion and the Argent Hold, Ramstein, Betina's scale).
q(838, "Scholomance", "Western Plaguelands", 55, "skeletonkey", 3,
    "On the island of Caer Darrow lay Scholomance, a school that served the Scourge as a stronghold. Inside, the enemy safely pursued research that strengthened their power. A door barred the way, and no entry could be had without a proper key. Apothecary Dithers was well versed in Scholomance and had an idea for getting one. High Executor Derrington sent someone who could get things done to see him.",
    "Derrington wanted a way past the locked door of Scholomance on Caer Darrow, and sent the task to Apothecary Dithers, who had studied the place.",
    "The High Executor had said who might be trusted with the matter of the key, Dithers said. A fair part of his recent studies had gone into Scholomance. He believed he knew how to get a key that would open the front door at will, though such tasks were seldom easy.",
    "Dithers had expected the visit. A fair portion of his recent studies had gone into Scholomance. He knew a means to a key for its front door, though not an easy one.", true)
q(5533, "Scholomance", "Western Plaguelands", 55, "skeletonkey", 3,
    "On the island of Caer Darrow lay Scholomance, a wretched center of Scourge necromancy. Inside, the enemy conducted unspeakable acts on unwitting victims, or so Chillwind Camp surmised. A door barred the way, and no entry could be had without a proper key. Alchemist Arbington was well versed in Scholomance and had an idea for getting one.",
    "The commander at Chillwind wanted a key to the locked door of Scholomance, and sent the task to Alchemist Arbington, who had studied the place.",
    "A fair part of Arbington's recent studies had gone into Scholomance, and he believed he knew a means to a key for its front door. The horrid sights inside he could only imagine, and he did not know how heroic types did it.",
    "Arbington knew a way to a key for Scholomance's front door, and wondered aloud how heroic types stomached what lay behind it.", true)
fallback("Scholomance", "Western Plaguelands", "skeletonkey", "838,5533",
    "Scholomance, the Scourge's school on the island of Caer Darrow, kept its front door locked, and a key was wanted.",
    "No one entered Scholomance on Caer Darrow without a proper key, and someone who had studied the place had an idea for one.",
    "The matter of a key to Scholomance passed to the one who had studied the place.",
    "The search for a way into Scholomance went on.")
q(964, "Skeletal Fragments", "Western Plaguelands", 57, "skeletonkey", 3,
    "The key to Scholomance was called a Skeleton Key, Dithers explained. It had to be forged from the remains of several skeletons and hardened with the strongest of metals in a suitable mold. A signet of power from a being who could naturally open the portal would make it work. First came the skeletal fragments, from the skeletons inside Andorhal, or those outside the walls at a pinch.",
    "A Skeleton Key began with bone. Dithers wanted fragments from the skeletons of Andorhal for the forging.",
    "The fragments would work, Dithers said, and he would imbue them with a temper to survive the forging. Next came a mold. He knew a goblin blacksmith in Tanaris who had made molds for similarly macabre items, and who worked for the highest bidder.",
    "Tempered by Dithers, the bone fragments waited for a mold, and he named a goblin smith in Tanaris who worked for whoever paid most.", true)
q(5537, "Skeletal Fragments", "Western Plaguelands", 57, "skeletonkey", 3,
    "The key to Scholomance was called a Skeleton Key, Arbington explained. It had to be forged from the remains of several skeletons and hardened with the strongest of metals in a suitable mold. A signet of power from a being who could naturally open the portal would make it work. First came the skeletal fragments, from the skeletons inside Andorhal, or those outside the walls at a pinch.",
    "A Skeleton Key began with bone. Arbington wanted fragments from the skeletons of Andorhal for the forging.",
    "The fragments would work, Arbington said, and he would imbue them with a temper to survive the forging. Next came a mold. He knew a goblin blacksmith in Tanaris who had made molds for similarly macabre items, and who worked for the highest bidder.",
    "Tempered by Arbington, the bone fragments waited for a mold, and he named a goblin smith in Tanaris who worked for whoever paid most.", true)
fallback("Skeletal Fragments", "Western Plaguelands", "skeletonkey", "964,5537",
    "A Skeleton Key for Scholomance had to be forged from the remains of several skeletons, and Andorhal's dead could supply them.",
    "Bone from Andorhal's skeletons was the first ingredient of a key to Scholomance.",
    "The skeletal fragments for the key were gathered.",
    "Work on the Skeleton Key went on.")
q(5514, "Mold Rhymes With...", "Tanaris", 57, "skeletonkey", 3,
    "The goblin was Krinkle Goodsteel, who peddled his skills to the highest bidder in Gadgetzan. His services would not come cheap, and Dithers, an apothecary and no banker, asked that whatever fee he charged be paid. Krinkle had a mold for the skeleton key at fifteen gold, up front and no negotiation. Packing the fragments and a lesson in forging the stem without any smithing knowledge came free of charge.",
    "Krinkle Goodsteel of Gadgetzan had a mold for the skeleton key, fifteen gold up front and no negotiation. Dithers had no gold lying around, as he said rather too loudly.",
    "The goods had been delivered, as Dithers had promised, Krinkle said. A deal was a deal, so he packed the fragments into the mold. They were already imbued, which spared a long trip back to the Bulwark.",
    "In Gadgetzan the tempered fragments went into Krinkle's mold, and he remarked that mercenaries offered competitive deals after all.", true)
q(5538, "Mold Rhymes With...", "Tanaris", 57, "skeletonkey", 3,
    "The goblin was Krinkle Goodsteel, who peddled his skills to the highest bidder in Gadgetzan. His services would not come cheap, and Arbington, an alchemist and no banker, asked that whatever fee he charged be paid. Krinkle had a mold for the skeleton key at fifteen gold, up front and no negotiation. Packing the fragments and a lesson in forging the stem without any smithing knowledge came free of charge.",
    "Krinkle Goodsteel of Gadgetzan had a mold for the skeleton key, fifteen gold up front and no negotiation. Arbington had no gold lying around, as he said rather too loudly.",
    "The goods had been delivered, as Arbington had promised, Krinkle said. A deal was a deal, so he packed the fragments into the mold. They were already imbued, which spared a long trip back to Chillwind Point.",
    "In Gadgetzan the tempered fragments went into Krinkle's mold, and he remarked that mercenaries offered competitive deals after all.", true)
fallback("Mold Rhymes With...", "Tanaris", "skeletonkey", "5514,5538",
    "Krinkle Goodsteel in Gadgetzan could make a mold for the Skeleton Key, for fifteen gold up front.",
    "The mold for the key to Scholomance came from a goblin in Gadgetzan who worked for the highest bidder.",
    "Krinkle packed the bone fragments into his mold.",
    "The mold for the Skeleton Key was bought in Gadgetzan.")
q(5801, "Fire Plume Forged", "Un'Goro Crater", 57, "skeletonkey", 4,
    "The key stem needed two bars of thorium and a powerfully hot heat source. Thorium was the buyer's problem, Krinkle said, but the heat he could help with. West in Un'Goro Crater stood Fire Plume Ridge, a simmering volcano. Its lava lake was hot enough to fuse thorium and bone, and the mold needed only to be dipped in it. Arbington was to be seen again after that.",
    "Thorium and the lava lake atop Fire Plume Ridge would fuse the Skeleton Key in Krinkle's mold, and Arbington was to see the result.",
    "A costly skeleton key, Arbington called it, and still unfinished. The time had come to put focus behind it. That meant facing the foe all the work in Andorhal had been building toward, the being who ran the show inside the ruined city. He was Araj the Summoner, a lich and one of the most powerful beings the Scourge called its own.",
    "The key came back from the volcano forged but not finished. Its focus, Arbington said, would come from Araj the Summoner, the lich who ruled ruined Andorhal.", true)
q(5802, "Fire Plume Forged", "Un'Goro Crater", 57, "skeletonkey", 4,
    "The key stem needed two bars of thorium and a powerfully hot heat source. Thorium was the buyer's problem, Krinkle said, but the heat he could help with. West in Un'Goro Crater stood Fire Plume Ridge, a simmering volcano. Its lava lake was hot enough to fuse thorium and bone, and the mold needed only to be dipped in it. Dithers was to be seen again after that.",
    "Thorium and the lava lake atop Fire Plume Ridge would fuse the Skeleton Key in Krinkle's mold, and Dithers was to see the result.",
    "A costly skeleton key, Dithers called it, and still unfinished. The time had come to put focus behind it. That meant facing the foe all the work in Andorhal had been building toward, the being who ran the show inside the ruined city. He was Araj the Summoner, a lich and one of the most powerful beings the Scourge called its own.",
    "The key came back from the volcano forged but not finished. Its focus, Dithers said, would come from Araj the Summoner, the lich who ruled ruined Andorhal.", true)
fallback("Fire Plume Forged", "Un'Goro Crater", "skeletonkey", "5801,5802",
    "The Skeleton Key's stem was to be forged with thorium in the lava lake atop Fire Plume Ridge in Un'Goro.",
    "Krinkle's mold needed only a dip in the lava of Fire Plume Ridge, with thorium, to fuse the key.",
    "The Skeleton Key came out of the lava forged.",
    "The forging at Fire Plume Ridge was done.")
q(5341, "Barov Family Fortune", "Western Plaguelands", 60, "barov", 3,
    "Within Scholomance lay the Barov family fortune, and Alexi Barov was one of the last two heirs of the house. The other was his brother Weldon, a miserable coward in Alexi's words, who had fled during the war and so kept his worthless existence as a human. Weldon now searched for the deeds to claim the fortune. Alexi wanted them first, and promised wealth beyond dreams.",
    "Alexi Barov, undead heir of the house, wanted the family deeds out of Scholomance before his living brother Weldon could claim the fortune.",
    "Excellent work, Alexi said. His inheritance was next to be secured.",
    "The deeds reached Alexi, who turned at once to securing the inheritance.", true)
q(5343, "Barov Family Fortune", "Western Plaguelands", 60, "barov", 3,
    "Weldon Barov cursed himself for a fool. He had looked into the face of the enemy, his undead brother Alexi, and let him live. Now Alexi was searching for Weldon's inheritance. The family deeds lay in the ruins of Scholomance, and Weldon wanted them before his brother's bony hands found them, with vast riches promised.",
    "Weldon Barov, the living heir, wanted the family deeds out of Scholomance before his undead brother Alexi reached them.",
    "One more task remained, Weldon said.",
    "With the deeds in hand, Weldon spoke of one task more.", true)
fallback("Barov Family Fortune", "Western Plaguelands", "barov", "5341,5343",
    "The Barov family fortune lay in Scholomance, and the last two heirs of the house, one living and one undead, each wanted its deeds.",
    "Two Barov brothers, Alexi and Weldon, each hunted the family deeds hidden in Scholomance.",
    "The Barov deeds came out of Scholomance.",
    "The hunt for the Barov inheritance went on.")
q(5342, "The Last Barov", "Western Plaguelands", 60, "barov", 5,
    "With his brother alive, Alexi said, there might be some contention over who inherited, and that could not be. He hoped a low-down guttersnipe was not above a little cold-blooded murder. Weldon sat under Alliance protection at Chillwind Camp to the east, and his head was wanted. Alexi yawned and told the hireling to hurry along.",
    "Alexi wanted his brother dead and his head brought from Chillwind Camp, where Weldon sat under Alliance protection. He yawned through the instructions.",
    "Wonderful, Alexi said, for now he alone held the power and fortune of house Barov. He threw a large bag at the one who had done it and told the filthy animal to keep the change.",
    "Weldon's head made Alexi the last Barov. He threw a bag of coin and an insult, and told the hireling to keep the change.", true)
q(5344, "The Last Barov", "Western Plaguelands", 60, "barov", 5,
    "With the deeds recovered, one thing remained, Weldon said. Alexi had to be killed, so that no unscrupulous gang of mercenaries would ever come for Weldon's head. His brother hid under Horde protection at the Bulwark. Weldon wanted the head however it was got, since such behavior was below his noble upbringing.",
    "Weldon wanted his undead brother's head from the Bulwark, where Alexi sheltered under the Horde, and did not care how it was taken.",
    "A glorious day, Weldon called it, with the pockmark of house Barov eliminated and his fortune secure. He paid, and told the peasant to leave his sight.",
    "With Alexi's head, Weldon's fortune was secure. He paid the peasant and dismissed them from his sight.", true)
fallback("The Last Barov", "Western Plaguelands", "barov", "5342,5344",
    "One Barov brother wanted the other dead, so that the family fortune would have a single heir.",
    "The Barov inheritance, each brother believed, needed the other brother's head.",
    "A Barov brother's head was delivered.",
    "The feud between the Barov heirs went on.")
q(5461, "The Human, Ras Frostwhisper", "Western Plaguelands", 60, "frostwhisper", 3,
    "The undead feared life as the living feared death, Marduke said. It was not unusual for a sentient undead to destroy every remnant of a former life. To make an artifact that could turn Ras Frostwhisper mortal again, a keepsake from his years among the living was needed. One might be found in the ruined city of Stromgarde, his home.",
    "A keepsake of Ras Frostwhisper's mortal life, from the ruins of Stromgarde, was the first thing Marduke needed to unmake the lich.",
    "Marduke had doubted such an item still existed. It opened an incredible opportunity, one not to be squandered, and what he would ask next would lead into the depths of hell.",
    "The keepsake from Stromgarde surprised Marduke, who called it an opportunity not to be squandered and warned that the next step led into hell.")
q(5462, "The Dying, Ras Frostwhisper", "Eastern Plaguelands", 60, "frostwhisper", 3,
    "The keepsake had to be attuned on tainted soil. Rumor said Frostwhisper had succumbed to the Lich King in Stratholme, giving his life freely and with motive on bloodied ground to become one of the undying. That ground had to be found. Leonid Barthalomew the Revered at Light's Hope might know more. He was an undead dissenter from the Scourge, freed by the Banshee Queen but loyal to the Argent Dawn.",
    "Marduke sent the keepsake to Leonid Barthalomew at Light's Hope, who might know where in Stratholme Ras Frostwhisper had given himself to the Lich King.",
    "Leonid looked over the keepsake. The quandary stirred memories he had hoped would never resurface.",
    "The keepsake brought Leonid memories he had hoped were buried.")
q(5463, "Menethil's Gift", "Stratholme", 60, "frostwhisper", 4,
    "Leonid had watched the human Ras Frostwhisper pledge his undying soul to the Lich King. The mage had drawn a dagger across his own throat with a smile and collapsed inside the pentagram. With a single motion, the Lich King standing over him had made him a lich. That place had a name, Menethil's Gift, ground blessed by the Lich King and holy to the Scourge.",
    "Leonid remembered Ras Frostwhisper's death and rebirth, and named the ground where it happened, Menethil's Gift, holy to the Scourge.",
    "On the tainted soil of Menethil's Gift, the keepsake was placed.",
    "Where Frostwhisper had died, the keepsake was laid down.", true)
q(5464, "Menethil's Gift", "Stratholme", 60, "frostwhisper", 4,
    "The soul of the fallen clung to what represented its former life and transformed the keepsake into a soulbound one. It went back into the pack.",
    "On Menethil's Gift the keepsake changed, bound now to the soul that had clung to it.",
    "As the soul had clung to the keepsake, so it would cling to the physical form of Ras Frostwhisper.",
    "The soulbound keepsake would cling to Ras Frostwhisper's form as his soul had clung to it.", true)
fallback("Menethil's Gift", "Stratholme", "frostwhisper", "5463,5464",
    "Menethil's Gift was the ground in Stratholme where Ras Frostwhisper had given himself to the Lich King, holy to the Scourge.",
    "A keepsake of Ras Frostwhisper's mortal life had to be attuned on the ground in Stratholme where he became a lich.",
    "The work at Menethil's Gift went forward.",
    "The keepsake's attunement in Stratholme continued.")
q(5465, "Soulbound Keepsake", "Western Plaguelands", 60, "frostwhisper", 3,
    "The keepsake was to go back to Marduke, who would explain its use.",
    "Marduke waited for the soulbound keepsake and the instructions that went with it.",
    "Another hapless spirit was what Marduke had expected to see return, he admitted.",
    "Back with Marduke, the keepsake drew the admission that he had expected its bearer to return as a spirit.")
q(5466, "The Lich, Ras Frostwhisper", "Scholomance", 60, "frostwhisper", 6,
    "One task remained, Marduke said. The lich Ras Frostwhisper was to be confronted in his lair and the keepsake's power used against him without relenting. Its bearer had to weather the blows of the flailing beast and never give in to the pain. When the ritual was complete Ras would be mortal once more, and then he had to be struck down and his human head taken.",
    "The soulbound keepsake would make Ras Frostwhisper mortal in his own lair, if its bearer endured his fury through the ritual. Then he was to die, and his human head was proof.",
    "Ten thousand souls cried out in unison, Marduke said. A mortal blow had been struck to the Scourge and their masters.",
    "Ras Frostwhisper died a man, and Marduke spoke of ten thousand souls crying out at once, and of a mortal blow to the Scourge.")
q(5262, "The Truth Comes Crashing Down", "Eastern Plaguelands", 60, "zverenhoff", 6,
    "As the dust settled across the chamber, the events were hard to comprehend. The Grand Crusader of the Scarlet Crusade had been a demon, and not just any demon but brother to Varimathras, arch lord of the Undercity. Into a pack went the dreadlord's severed head, since no one would believe it without proof. Duke Nicholas Zverenhoff had to be told at once.",
    "The Grand Crusader had died a dreadlord, brother to Varimathras of the Undercity. His severed head was the proof Duke Nicholas Zverenhoff would need.",
    "Zverenhoff wondered what it would mean for the Crusade, whether they had been under the demon's control, unwittingly serving as pawns of a greater evil.",
    "Holding the dreadlord's head, Zverenhoff wondered whether the whole Crusade had been the unwitting pawn of a greater evil.")
q(5263, "Above and Beyond", "Stratholme", 60, "zverenhoff", 6,
    "A natural aptitude for destruction and a habit of following orders rarely coexisted, Zverenhoff observed. He clasped his hands before his face and spoke of a possible vehicle of divine justice. Kel'Thuzad's errand boy ruled over Stratholme. Baron Rivendare was to be destroyed and his head brought back, as proof of a champion, Zverenhoff's own.",
    "Zverenhoff wanted the head of Baron Rivendare, Kel'Thuzad's errand boy who ruled Stratholme, as proof of a champion worth ushering into the Dawn's ranks.",
    "It had been many years since Zverenhoff had ushered a champion into the ranks, he said. For the first time in years, an audience with Lord Maxwell would be granted.",
    "Rivendare's head earned what no one had been granted in years, an audience with Lord Maxwell.")
q(5264, "Lord Maxwell Tyrosus", "Eastern Plaguelands", 60, "zverenhoff", 4,
    "A great honor was about to be bestowed, Zverenhoff said. Lord Maxwell wished to reward service to the Argent Dawn, and it had been years since he granted an audience to outsiders.",
    "Lord Maxwell Tyrosus, who had not received outsiders in years, wished to reward the Dawn's champion.",
    "A worthy ally, Lord Maxwell said, who would reap the rewards of stalwart dedication.",
    "Maxwell named the champion a worthy ally and promised the rewards of dedication.")
q(5265, "The Argent Hold", "Eastern Plaguelands", 60, "zverenhoff", 5,
    "Through the years the Argent Hold had remained locked, Lord Maxwell said. None had been worthy to reach inside and take from it the power of the Argent Dawn, until that day. The Hold was open.",
    "The Argent Hold, locked for years against the unworthy, stood open to the Dawn's champion.",
    "Whoa, was all that came out at the sight of what the Hold held.",
    "What lay inside the Argent Hold drew a single astonished word.")
q(6163, "Ramstein", "Stratholme", 60, "marris_stead", 5,
    "On the very stead where he stood, Nathanos said, he had held his ground in defense of Lordaeron. A gigantic wave of Scourge had overwhelmed the farm and everyone on it. The wretch had hovered above him, entrails hanging from its gaping chest. He had woken as Scourge, helpless, his mind one with the Lich King's, until she came for him and he was free. Now he wanted vengeance on the thing that had taken his life, and it was to be destroyed.",
    "Nathanos named the thing that had killed him on the Marris Stead, the filth with entrails hanging from its chest, and wanted it destroyed in his name.",
    "Whether it had begged for mercy, Nathanos wondered aloud, and whether it could even know what mercy was. He spat and said he would hang the beast's head on his wall. Its killer had earned a place among his champions.",
    "Ramstein's head would hang on Nathanos's wall. He spat, wondered whether the beast had begged, and named its killer one of his champions.")
q(5582, "Healthy Dragon Scale", "Eastern Plaguelands", 58, "plaguedragons", 2,
    "One scale shed by a plagued dragon hatchling was healthy and unmarred. Betina Bigglezink would want this one to study, for the others on the infant beast were pocked and oozing.",
    "One healthy scale among a plagued hatchling's rotten ones was rare enough to interest Betina Bigglezink.",
    "Invaluable to her studies of the Scourge's machinations, Betina called the scale, and asked for any more that turned up.",
    "The unmarred scale went into Betina's studies, with a request for more like it.")
for _, id in ipairs({838, 5533, 964, 5537, 5514, 5538, 5801, 5802, 5341, 5343, 5342, 5344, 5461, 5462, 5463, 5464, 5465, 5466, 5262, 5263, 5264, 5265, 6163, 5582}) do src(id) end

-- band5060 (2026-11-06): Dire Maul (the Gordok king and his gauntlet, the ogre suit, the Felvine,
-- the Shen'dralar's madness and treasure, Kariel Winthalus, Hydraxis's coffer, Foror's compendium, Quel'Serrar).
q(1318, "Unfinished Gordok Business", "Dire Maul", 60, "gordok", 4,
    "The old king was dead and the title had passed, so Kromcrush hoped the new king might win back the prized Gordok artifact. A creepy elf who called himself Prince had it. Every king since Tortheldrin stole it from the old-timey Gordok king had failed. It was called the Gauntlet of Gordok Might, and the old stories said only the one true king of the Gordok could recover it. Found, it would become a mighty gauntlet to wear forever.",
    "Prince Tortheldrin had held the Gauntlet of Gordok Might since he stole it from an old Gordok king. Only the true king could take it back, Kromcrush believed.",
    "Kromcrush had the gauntlet back.",
    "From the Prince's halls the Gauntlet of Gordok Might came back to the Gordok.", true)
q(7703, "Unfinished Gordok Business", "Dire Maul", 60, "gordok", 5,
    "The old king was dead and the title had passed, so Kromcrush hoped the new king might win back the prized Gordok artifact. A creepy elf who called himself Prince had it. Every king since Tortheldrin stole it from the old-timey Gordok king had failed. It was called the Gauntlet of Gordok Might, and the old stories said only the one true king of the Gordok could recover it. Found, it would become a mighty gauntlet to wear forever.",
    "Prince Tortheldrin had held the Gauntlet of Gordok Might since he stole it from an old Gordok king. Only the true king could take it back, Kromcrush believed.",
    "Kromcrush declared the true king found, for he had never thought to see the gauntlet in his life. It looked drained of mojo, as if the creepy elf had tried to ruin it. Every Captain of the Gordok learned how to bring its ancient mark back to life, and Kromcrush did so and bade the king rule forever.",
    "Kromcrush woke the old mark on the recovered gauntlet, as every Gordok captain learned to, and handed it to the one true king to rule forever.", true)
fallback("Unfinished Gordok Business", "Dire Maul", "gordok", "1318,7703",
    "Captain Kromcrush believed only the true king of the Gordok could take the Gauntlet of Gordok Might back from Prince Tortheldrin.",
    "The Gauntlet of Gordok Might, stolen by the Prince of Eldre'Thalas long ago, waited for a true Gordok king.",
    "The matter of the Gordok gauntlet went forward.",
    "The new king of the Gordok pursued the stolen gauntlet.")
q(5518, "The Gordok Ogre Suit", "Dire Maul", 60, "gordok", 3,
    "Anyone bound to fight the king of that dump, the chained goblin said, would have to get past Captain Kromcrush. Killing him was one way, but leaving him alive might be better. Since his captivity the goblin had worked out how to make an ogre suit that would fool those bozos. It would be stable for ten minutes at most, if the materials were brought.",
    "A goblin in chains in Dire Maul offered an ogre suit good for ten minutes. That was enough to fool Captain Kromcrush into taking its wearer for one of his men.",
    "With a slip here and a tuck there the suit would do the trick, and a broad smile crossed the chained goblin's face. It would last ten minutes before it fell apart, he warned, and it would fool Kromcrush about its wearer alone, not the whole party.",
    "The goblin stitched the ogre suit together, grinning, and warned that it would last ten minutes and fool Kromcrush about one person only.")
q(5527, "A Reliquary of Purity", "Silithus", 60, "felvine", 3,
    "The first step was a container that could hold an extremely corruptible substance without harm to its handler. Only one device could contain something as vile as the Felvine, a Reliquary of Purity. One had been in the night elf village of Southwind, deep in the wastes of Silithus, many years ago. That secret had been kept while turmoil rose in Silithus, but the situation in Eldre'Thalas had ended the time for complacency.",
    "A Reliquary of Purity was the one vessel that could hold the Felvine. One lay in the ruins of Southwind in Silithus, a secret the Cenarion Circle had kept until Eldre'Thalas forced the matter.",
    "The Cenarion Circle called its finder as resourceful as many claimed. With the Reliquary back in the Circle's hands, the next request came more easily, a malfeasant demon faced and a dangerous item brought back.",
    "The Reliquary came out of Southwind's ruins, and the Circle felt able to ask for the next thing, a demon faced and a dangerous substance carried home.")
q(5526, "Shards of the Felvine", "Dire Maul", 60, "felvine", 5,
    "Knowledge of Eldre'Thalas, Dire Maul in Feralas, now came into play. In the eastern part of the ruined city Alzzin the Wildshaper had exerted his corrupt dominion. Near him grew the Fruit of Fertility, corrupted now into the Felvine. When Alzzin fell, whatever essence of the Felvine could be captured was to be sealed in the Reliquary and brought back.",
    "Alzzin the Wildshaper ruled the east of Dire Maul, and the Felvine grew beside him. His death and a sealed shard of the vine in the Reliquary were what the Cenarion Circle asked.",
    "It was done, and the Cenarion Circle was in the debt of the one who did it. The war was far from over, but a great battle had been won against those who would bring doom. Its winner was welcomed as a hero of the Circle.",
    "The Felvine's shard reached the Circle sealed in the Reliquary. A great battle had been won, they said, though the war went on, and they named its winner a hero of the Cenarion Circle.")
q(7461, "The Madness Within", "Dire Maul", 60, "shen", 5,
    "The madness had to end, one of the Shen'dralar said, for the age of the immortals had long since passed. Destroying the guardians around the pylons would lower the force field. Then Immol'thar was to die, and with the Prince's power greatly reduced, the Prince himself, so that the spirits of the city could rest.",
    "With the pylon guardians dead, the force field would fall, and then Immol'thar and a weakened Prince Tortheldrin could be ended. One of the Shen'dralar asked for exactly that.",
    "The Shen'dralar thanked their hero.",
    "Prince Tortheldrin was ended, the city's spirits could rest, and the Shen'dralar gave their thanks.")
q(7462, "The Treasure of the Shen'dralar", "Dire Maul", 60, "shen", 3,
    "In the library, the Athenaeum, an ancient chest lay hidden beneath the stairway, and whatever was desired could be taken from it.",
    "Beneath the stairway of the Athenaeum lay an ancient chest, and whatever was desired could be taken from it.",
    "The chest beneath the Athenaeum's stairway was opened.",
    "Whatever was desired came out of the Athenaeum's chest.", true)
q(7877, "The Treasure of the Shen'dralar", "Dire Maul", 60, "shen", 3,
    "In the library, the Athenaeum, an ancient chest lay hidden beneath the stairway, and whatever was desired could be taken from it.",
    "Beneath the stairway of the Athenaeum lay an ancient chest, and whatever was desired could be taken from it.",
    "The chest opened to reveal its contents.",
    "Under the Athenaeum's stairs, the chest came open.", true)
fallback("The Treasure of the Shen'dralar", "Dire Maul", "shen", "7462,7877",
    "The Shen'dralar kept an ancient chest beneath the stairway of their library, the Athenaeum.",
    "A chest under the Athenaeum's stairs held the Shen'dralar's thanks.",
    "The Shen'dralar's chest was opened.",
    "The treasure of the Shen'dralar was claimed.")
q(7481, "Elven Legends", "Dire Maul", 60, "shen", 3,
    "Several years ago a lone elven master named Kariel Winthalus had fled the devastation of his homeland with several ancient elven artifacts. The search for him had led from the ruins of Quel'Thalas through the Burning Steppes and across the sea to Feralas. He was thought to have sought sanctuary in the halls of Eldre'Thalas, now called Dire Maul. Alive or dead, the knowledge he carried had to be recovered.",
    "Kariel Winthalus, an elven master who had fled Quel'Thalas with ancient artifacts, was thought to have taken refuge in Eldre'Thalas. His searchers wanted him found, alive or dead.",
    "A shame, a tragedy, came the answer, for the items were lost and there was no trace of the master.",
    "Word that Kariel's artifacts were lost and the master himself gone without trace was met as a tragedy.", true)
q(7482, "Elven Legends", "Dire Maul", 60, "shen", 3,
    "A lone elven master, Kariel Winthalus, had fled the devastation of his homeland years before with several ancient artifacts. The search for him had run from the ruins of Quel'Thalas through the Burning Steppes and across the sea to Feralas. He was thought to have sought sanctuary in the halls of Eldre'Thalas, now Dire Maul. Whether he lived or not, the knowledge he carried had to be recovered.",
    "The lost master Kariel Winthalus and the artifacts he had carried out of Quel'Thalas were thought to be somewhere in Eldre'Thalas, and his searchers wanted them back.",
    "So the items were lost, and there was no trace of the master. It was a shame and a tragedy, came the answer.",
    "News that Kariel was gone without trace and his artifacts lost was received as a tragedy.", true)
fallback("Elven Legends", "Dire Maul", "shen", "7481,7482",
    "An elven master named Kariel Winthalus had fled his homeland with ancient artifacts and was thought to be in Eldre'Thalas.",
    "The search for Kariel Winthalus and his artifacts led into the halls of Dire Maul.",
    "The search for Kariel Winthalus in Eldre'Thalas was reported.",
    "Word of the lost elven master came back from Dire Maul.")
q(7486, "A Hero's Reward", "Azshara", 60, "waterlords", 4,
    "Service to the Waterlords had surpassed anything they expected of the denizens of the world, Hydraxis said. They did not understand mortal notions of gratitude or of rewarding good works, but in this case a reward seemed warranted. Under the surf at the southern base of the island lay a coffer.",
    "Hydraxis spoke of a coffer under the surf at the island's southern base, a reward the Waterlords did not quite understand but judged warranted.",
    "Down from the water's surface came Hydraxis's voice, bidding the choice of whatever suited best. He wished that it would protect against the foes of the Waterlords.",
    "From above the water Hydraxis's voice offered the choice of the coffer, with a wish that it protect its bearer against the Waterlords' foes.")
q(7507, "Foror's Compendium", "Dire Maul", 60, "quelserrar", 3,
    "Something of great importance had been uncovered, a tome unlike any other. Someone or something had shattered the seal of the Athenaeum, and the text inside was garbled and barely legible.",
    "A sealed tome from the Athenaeum had lost its seal, and its garbled text looked important enough to show to the keepers of Dire Maul's library.",
    "The compendium would have fetched a lot of gold on the black market, Lydros said. Its protective seal was broken, and the secrets of dragon slaying lay open to anyone with the intellect to take them in. A grand reward might be in order, one that would take enormous effort to obtain.",
    "Lydros priced the broken-sealed compendium on the black market, then spoke of a grand reward that would cost enormous effort.")
q(7508, "The Forging of Quel'Serrar", "Dire Maul", 60, "quelserrar", 3,
    "Anyone willing to take on the task was to present Lydros with the dull blade.",
    "Lydros would look at a dull blade from anyone who wished to take the task on.",
    "If the blade could be heated under the dragon's fiery breath in her lair and tempered in her blood, Lydros said, he would bind it for use.",
    "Once the blade was heated in the dragon's breath and tempered in her blood, Lydros promised to bind it.", true)
q(7509, "The Forging of Quel'Serrar", "Dire Maul", 60, "quelserrar", 6,
    "The unfired ancient blade was to go to the lair of Onyxia. Some trickery was needed to heat it. Planted nearby while she tried to incinerate her foes with her fiery breath, it might take the heat. Anyone who lived could then pick up the heated blade, finish the dragon, and plunge it into her smoldering corpse.",
    "Onyxia's own breath would fire the ancient blade, if it was planted in her path and its bearer survived to plunge it into her corpse.",
    "Lydros murmured something unintelligible, and handed over the blade of Quel'Serrar as promised.",
    "As promised, Quel'Serrar came from Lydros's hands, with a murmur no one could make out.", true)
fallback("The Forging of Quel'Serrar", "Dire Maul", "quelserrar", "7508,7509",
    "Lydros of the Shen'dralar could bind an ancient blade into Quel'Serrar, once it had been fired in a dragon's breath.",
    "The dull ancient blade from the Athenaeum could become Quel'Serrar, with dragonfire and dragon blood.",
    "The forging of Quel'Serrar went forward.",
    "Work on the ancient blade continued.")
for _, id in ipairs({1318, 7703, 5518, 5527, 5526, 7461, 7462, 7877, 7481, 7482, 7486, 7507, 7508, 7509}) do src(id) end

-- band5060 (2026-11-06): Silithus and the end game (the call to Cenarion Hold, Proudhorn's supply
-- lines, Calandrath's kitchen, the Abyssal Council through Aurel, Huum and Bor, field duty and the
-- scout reports, the templars and dukes, Morna, Narain and Maws, Vaelastrasz, Eranikus's redemption,
-- Malfurion's ring, Xandivious and the Timbermaw peace, the Qiraji dragons, Ossirian, the colossi, silithyst).
q(8275, "Taking Back Silithus", "Silithus", 55, "cenarionwar", 3,
    "The call went out to the heroes of the Alliance. Unchecked too long and unopposed, the silithid menace had been preparing a large-scale expansion. Cenarion Circle forces were gathering in Silithus to take the fight to them. Every able-bodied adventurer was to report to Windcaller Proudhorn at Cenarion Hold.",
    "Cenarion Circle forces were gathering in Silithus against the silithid. The Alliance's heroes were called to Windcaller Proudhorn at Cenarion Hold.",
    "Proudhorn welcomed a new recruit to Cenarion Hold, pleased that the emissaries' words were reaching heroes of such caliber. There would be no shortage of opportunities to help, and he expected a valuable ally.",
    "At Cenarion Hold, Windcaller Proudhorn welcomed the new recruit and promised no shortage of work against the silithid.", true)
q(8276, "Taking Back Silithus", "Silithus", 55, "cenarionwar", 3,
    "The call went out to the champions of the Horde. Tremors in the earth near silithid hives across Azeroth warned of large movements as the insects prepared to expand. Cenarion Circle forces were gathering in Silithus to take the fight to them before it was too late. All able-bodied combatants were to report to Windcaller Proudhorn at Cenarion Hold.",
    "Tremors near the silithid hives had warned the Horde. Its combatants were called to Windcaller Proudhorn at Cenarion Hold, where the Cenarion Circle gathered.",
    "Windcaller Proudhorn welcomed a new recruit against the silithid. The emissaries' words were plainly reaching heroes of caliber, he said. There would be no shortage of opportunities to help.",
    "A new recruit at Cenarion Hold, Proudhorn said, and one he expected to prove a valuable ally quickly.", true)
fallback("Taking Back Silithus", "Silithus", "cenarionwar", "8275,8276",
    "The Cenarion Circle was gathering in Silithus to take the fight to the silithid, and called for every able-bodied adventurer.",
    "Windcaller Proudhorn at Cenarion Hold received the recruits answering the Circle's call against the silithid.",
    "The call to Cenarion Hold was answered.",
    "A new recruit reported to Cenarion Hold.")
q(8280, "Securing the Supply Lines", "Silithus", 55, "cenarionwar", 3,
    "Cenarion Hold was a place of the utmost strategic importance, Proudhorn said. While it stood, victory over the silithid was guaranteed, provided the supplies kept coming. Desert worms had proven a greater threat to the caravans than the silithid themselves. That very morning, dredge strikers had ravaged a large shipment of morrowgrain, and their numbers had to be thinned.",
    "Dredge strikers had torn up a morrowgrain shipment that morning. Proudhorn wanted the worms thinned before they cost Cenarion Hold its supplies.",
    "Sincere gratitude came from Proudhorn, who said the help had shown true courage.",
    "The strikers were fewer, and Proudhorn spoke of true courage.")
q(8281, "Stepping Up Security", "Silithus", 57, "cenarionwar", 3,
    "The performance so far had been exemplary, Proudhorn said, but the supply lines were not safe yet. With the dredge strikers gone, their larger southern cousins would surely move north to take their place. Quite a few dredge crushers would have to die to keep them at bay.",
    "Dredge crushers from the south were expected to fill the gap the strikers had left. Proudhorn wanted them killed before they reached the supply lines.",
    "Excellent, Proudhorn said, the newcomer had proven a valuable ally in the preparations for war against the silithid.",
    "With the crushers held off, Proudhorn counted the newcomer a valuable ally in the war to come.")
q(8307, "Desert Recipe", "Silithus", 57, "calandrath", 2,
    "Adapting to the desert had been difficult, Calandrath said. The birds and trees of Auberdine were missed, and the arid land kept the food severely limited. There were few desert herbs to learn. Twilight's Hammer groups from the camp to the west had been seen hunting sandworms for food. Sandworm meat was so bitter that Calandrath could not imagine how they made it palatable. Anyone visiting their camp was asked to keep an eye open.",
    "Calandrath wanted to know how the Twilight's Hammer made bitter sandworm meat edible. Anyone visiting their camp west of Cenarion Hold was asked to look.",
    "Among the cult's things was a collection of recipes, common ones and a few unusual. A few seconds' browsing turned up one for sandworm meat.",
    "The cult's recipes turned up at the camp, and one of them used sandworm meat.")
q(8313, "Sharing the Knowledge", "Silithus", 57, "calandrath", 2,
    "The recipe for sandworm meat was legible but named herbs and spices no one had heard of. Calandrath might know the desert plants well enough to make sense of it.",
    "The sandworm recipe's strange herbs needed Calandrath's knowledge of what grew in the desert.",
    "Simple enough, Calandrath said, once the cult's own names for the herbs were worked out, and showed how.",
    "Over the recipe, Calandrath puzzled out the cult's names for the herbs and demonstrated it.")
q(8317, "Kitchen Assistance", "Silithus", 57, "calandrath", 2,
    "The recipe would come in handy, Calandrath said. Calandrath needed smoked desert dumplings for the day, and a helping hand would be made worth the while.",
    "Calandrath wanted a hand making smoked desert dumplings from the Twilight's Hammer's recipe.",
    "A life saver, Calandrath called the help. The dumplings turned out quite good, better than Calandrath had expected from the Twilight's Hammer.",
    "Smoked desert dumplings, Calandrath admitted, turned out unexpectedly good for a Twilight's Hammer recipe.")
q(8318, "Secret Communication", "Silithus", 60, "twilight", 2,
    "Some of the Twilight's Hammer cultists carried little papers with gibberish on them. Cenarion Hold could not make out what the gibberish meant, and that was not the point. The papers were how the cult's groups communicated in secret. Every text taken out of circulation left them less able to.",
    "The cultists' gibberish papers were their secret post. Cenarion Hold wanted a stack of them taken out of circulation.",
    "Excellent, came the word at Cenarion Hold. The papers would be stashed away in case they proved useful later.",
    "A stack of the cult's papers went into storage at Cenarion Hold for a later day.")
q(8331, "Aurel Goldleaf", "Silithus", 60, "abyssal", 3,
    "The hope that the Twilight's Hammer's operations in Silithus were slowing had been mistaken, Huum said. Continued forays had shown that an even darker power controlled the Hammer, the Abyssal Council. It worked through the arcane wind stones dotted among the cult's camps, and the next action would be against it. The craftsman Aurel Goldleaf, in the eastern section of Cenarion Hold, would be needed for the gambit.",
    "Behind the Twilight's Hammer stood the Abyssal Council, speaking through wind stones in the cult's camps. Huum sent the matter to Aurel Goldleaf, the craftsman in the east of Cenarion Hold.",
    "Aurel had been told of the plan to pit oneself against the Abyssal Council. She asked for close attention to her next words.",
    "Good day, Aurel said, and asked whether the Abyssal Council was really the aim. If so, there was much to explain.")
q(8332, "Dukes of the Council", "Silithus", 60, "abyssal", 4,
    "A wind stone might be used to ambush a duke of the Abyssal Council, Aurel thought. Someone would have to commune through it and convince the Council they were a middle-ranked leader of the Twilight's Hammer. That called for a replica of the cult's medallion of station. Aurel could make it from a large brilliant shard and crests worn by the Abyssal Templar.",
    "Aurel could forge a replica medallion of station, the badge of a middle-ranked cultist. She needed a large brilliant shard and the crests of Abyssal Templars.",
    "Very good, Aurel said, and she finished the medallion in a few moments. Worn with the rest of the twilight trappings at a wind stone, it would make the Abyssal Council see a cultist underling.",
    "The medallion was done in moments once the last ingredients arrived. With the twilight trappings, Aurel said, it would pass at a wind stone.")
q(8341, "Lords of the Council", "Silithus", 60, "abyssal", 4,
    "Lords of the Abyssal Council could be summoned only through the greater wind stones. Only the top-ranking members of the Twilight's Council could speak to them. Aurel, though, had found a way to upgrade the disguise. It called for a ring of lordship, worn only by the highest in the cult. Aurel could craft it from large brilliant shards and abyssal signets.",
    "To fool an Abyssal Lord at a greater wind stone, Aurel needed a ring of lordship. Large brilliant shards and abyssal signets would make it.",
    "One moment, Aurel said, and the ring was ready. Worn with a medallion of station and the rest of the trappings at a greater wind stone, it would pass for a servant's. Perhaps a lord could then be lured into an ambush.",
    "The ring of lordship was ready. With it and the medallion, Aurel said, even an Abyssal Lord might be lured out.")
q(8343, "Goldleaf's Discovery", "Silithus", 60, "abyssal", 3,
    "Aurel Goldleaf thought she had found a way to summon and defeat a ruling member of the Abyssal Council, Huum said. The task would be dangerous, but great respect had been earned among the Cenarion Circle. If anyone could do it, this one could.",
    "Huum sent word that Aurel believed she could summon a lord of the Abyssal Council. The Circle trusted one person to face it.",
    "What Huum said was true, Aurel confirmed. She believed she knew how to summon a lord of the Abyssal Council, and she began to explain.",
    "Aurel confirmed Huum's word and laid out how a lord of the Council might be summoned.")
q(8348, "Signet of the Dukes", "Silithus", 60, "abyssal", 4,
    "Huum had told Bor that the Abyssal Dukes could now be summoned, quite an accomplishment. Smashing one up really good would be another, Bor said, and would make an impression on their underlings. Its signet would be the proof.",
    "Bor Wildmane wanted an Abyssal Duke smashed up and its signet brought back as proof.",
    "From the minute the newcomer walked into Cenarion Hold, Bor said, he had known a tough one. He wanted it kept up.",
    "The duke's signet pleased Bor, who said he had seen toughness at first sight.")
q(8349, "Bor Wildmane", "Silithus", 60, "abyssal", 2,
    "With a medallion made and an Abyssal Duke within reach, Aurel sent the newcomer to Bor Wildmane. He would set a task against the Council, and Aurel offered more medallions whenever needed.",
    "Aurel pointed toward Bor Wildmane, who had work against the Abyssal Council for anyone with a medallion.",
    "Bor was glad to see the newcomer again. The medallion would be needed for what came next.",
    "A medallion made was good news to Bor, who had the next task ready.")
q(8351, "Bor Wishes to Speak", "Silithus", 60, "abyssal", 2,
    "A ruling member of the Twilight Council could now be impersonated. Aurel was certain Bor Wildmane would want to speak, and she warned of a very difficult mission.",
    "The ring of lordship done, Aurel sent word to Bor Wildmane, who had a very difficult mission in mind.",
    "That was right, Bor said, and a very tough task lay ahead.",
    "Bor confirmed it. The task ahead was a very tough one.")
q(8352, "Scepter of the Council", "Silithus", 60, "abyssal", 6,
    "Huum and Bor had just been talking about the newcomer, who was about ready to fight an Abyssal Lord. It was a very dangerous endeavor, Bor said. Backup meant not one or two friends but a top-notch, battle-ready fighting force. If the friends were as good as the newcomer, the lord might even be beaten. Evidence would earn a truly great reward.",
    "An Abyssal Lord was the next target, Bor said, and no job for one or two friends. A battle-ready force was needed, and proof afterward.",
    "Bor could hardly believe it was done. He gave the biggest chest they had lying around, filled with some of the best things they had found.",
    "The lord was dead. Bor handed over the biggest chest at Cenarion Hold, filled with the best they had.")
q(8361, "Abyssal Contacts", "Silithus", 60, "abyssal", 4,
    "Twilight's Hammer cultists had been seen performing rituals to summon powerful elemental nobles, Bor said. No one knew whether the cultists worshipped them or used them to reach greater forces. One thing was sure, though, that the cult took its orders from these elementals. Bor wanted an Abyssal Templar contacted and given a proper beating, with proof. Nothing threw troops into disarray like taking out the chain of command.",
    "The cult took its orders from elemental nobles, Bor said. He wanted an Abyssal Templar summoned and beaten, with proof.",
    "Hah, Bor said, it was done, and the Twilight's Hammer would soon be crushed.",
    "An Abyssal Templar had been beaten, and Bor declared that the cult would soon be crushed.")
q(8498, "Twilight Battle Orders", "Silithus", 60, "twilight", 3,
    "Scouts reported new battle orders from the Twilight's Hammer leaders, carried by Twilight Prophets under heavy escort. The orders were to be intercepted and brought to Commander Mar'alith.",
    "Twilight Prophets were carrying the cult's new battle orders under heavy escort, and Mar'alith wanted them intercepted.",
    "Excellent, Mar'alith said. Staying ahead of the enemy's next move mattered, and the orders would let Cenarion Hold anticipate the cult's attacks.",
    "With the intercepted orders, Mar'alith expected to anticipate the Twilight's Hammer's attacks.")
q(8507, "Field Duty", "Silithus", 60, "cenarionwar", 2,
    "Before more involved tasks in the war, a share of field duty was required. Captain Blackanvil's Ironforge Brigade stood outside Hive'Zora. A report to him or his lieutenant, Janela Stouthammer, and a return would earn a more advanced assignment. The Orgrimmar Legion was to be avoided, since the two forces were kept well apart for their mutual animosity.",
    "Field duty with Captain Blackanvil's Ironforge Brigade outside Hive'Zora came first, with a warning to keep clear of the Orgrimmar Legion.",
    "Very well, came the word at Cenarion Hold. A set of tasks had been prepared to make optimal use of the recruit's skills. With such help, the enemy would soon be vanquished. New briefings would come from Captain Blackanvil.",
    "With field duty done, a set of tasks waited at Cenarion Hold, and Captain Blackanvil would give the briefings.", true)
q(8731, "Field Duty", "Silithus", 60, "cenarionwar", 2,
    "Before more involved tasks in the war, a share of field duty was required. Captain Skullsplit's Orgrimmar Legion stood outside Hive'Regal, and proof of service with him would earn a more advanced assignment. Tensions ran high between the Alliance and Horde volunteers, so the Ironforge Brigade was best avoided.",
    "Field duty with Captain Skullsplit's Orgrimmar Legion outside Hive'Regal came first, with a warning to steer clear of the Ironforge Brigade.",
    "Krug had little use for paperwork, the officer observed, and had signed the proof in silithid blood. A set of tasks had been prepared, and with such efforts the enemy would soon be crushed.",
    "The proof came back signed in silithid blood, Krug having no use for paperwork. A set of tasks waited at Cenarion Hold.", true)
fallback("Field Duty", "Silithus", "cenarionwar", "8507,8731",
    "Cenarion Hold asked for a share of field duty with the volunteers outside the hives before it gave more involved tasks.",
    "The Alliance and Horde volunteers outside the hives were kept apart, and new recruits did field duty with their own.",
    "Field duty outside the hives was done.",
    "The recruit's field service was reported at Cenarion Hold.")
q(8534, "Hive'Zora Scout Report", "Silithus", 60, "cenarionwar", 2,
    "The best scouts had been sent deep into the silithid hives. Scout Azenel had watched the silithid at Hive'Zora for several days. Cenarion Hold wanted her written report as soon as possible.",
    "Scout Azenel's written report from Hive'Zora was wanted at Cenarion Hold without delay.",
    "The report would be read right away, with thanks, and the next assignment was ready.",
    "Azenel's report from Hive'Zora reached Cenarion Hold, and the next assignment waited.")
q(8738, "Hive'Regal Scout Report", "Silithus", 60, "cenarionwar", 2,
    "The best scouts had been sent deep into the silithid hives. Scout Landion had watched the silithid at Hive'Regal for several days. Cenarion Hold wanted his written report as soon as possible.",
    "Scout Landion's written report from Hive'Regal was wanted at Cenarion Hold without delay.",
    "The report would be read right away, with thanks, and the next assignment was ready.",
    "Landion's report from Hive'Regal reached Cenarion Hold, and the next assignment waited.")
q(8739, "Hive'Ashi Scout Report", "Silithus", 60, "cenarionwar", 2,
    "The best scouts had been sent deep into the silithid hives. Scout Jalia had watched the silithid at Hive'Ashi for several days. Cenarion Hold wanted her written report as soon as possible.",
    "Scout Jalia's written report from Hive'Ashi was wanted at Cenarion Hold without delay.",
    "The report would be read right away, with thanks, and the next assignment was ready.",
    "Jalia's report from Hive'Ashi reached Cenarion Hold, and the next assignment waited.")
q(8535, "Hoary Templar", "Silithus", 60, "abyssal", 3,
    "The Twilight's Hammer and the elemental nobles they worshipped were a formidable threat to the operations in Silithus. With new enemies inside Ahn'Qiraj, the guard could not be lowered against the enemies outside. A Hoary Templar was to be summoned and destroyed, and Bor Wildmane told.",
    "A Hoary Templar was to be summoned and destroyed, and the deed reported to Bor Wildmane.",
    "Good job, said Bor, and the next assignment followed.",
    "The Hoary Templar was dead, and Bor had another assignment ready.")
q(8536, "Earthen Templar", "Silithus", 60, "abyssal", 3,
    "The Twilight's Hammer and the elemental nobles they worshipped were a formidable threat to the operations in Silithus. With new enemies inside Ahn'Qiraj, the guard could not be lowered against the enemies outside. An Earthen Templar was to be summoned and destroyed, and Bor Wildmane told.",
    "An Earthen Templar was to be summoned and destroyed, and the deed reported to Bor Wildmane.",
    "Good job, said Bor, and the next assignment followed.",
    "The Earthen Templar was dead, and Bor had another assignment ready.")
q(8537, "Crimson Templar", "Silithus", 60, "abyssal", 3,
    "The Twilight's Hammer and the elemental nobles they worshipped were a formidable threat to the operations in Silithus. With new enemies inside Ahn'Qiraj, the guard could not be lowered against the enemies outside. A Crimson Templar was to be summoned and destroyed, and Bor Wildmane told.",
    "A Crimson Templar was to be summoned and destroyed, and the deed reported to Bor Wildmane.",
    "Good job, said Bor, and the next assignment followed.",
    "The Crimson Templar was dead, and Bor had another assignment ready.")
q(8737, "Azure Templar", "Silithus", 60, "abyssal", 3,
    "The Twilight's Hammer and the elemental nobles they worshipped were a formidable threat to the operations in Silithus. With new enemies inside Ahn'Qiraj, the guard could not be lowered against the enemies outside. An Azure Templar was to be summoned and destroyed, and Bor Wildmane told.",
    "An Azure Templar was to be summoned and destroyed, and the deed reported to Bor Wildmane.",
    "Good job, said Bor, and the next assignment followed.",
    "The Azure Templar was dead, and Bor had another assignment ready.")
q(8538, "The Four Dukes", "Silithus", 60, "abyssal", 5,
    "The links between the Twilight's Hammer and the Abyssal Council were proving more important than expected. Cenarion Hold believed the elemental nobles called the Abyssal Dukes were a primary force organizing the cultists. All four were to be lured into this plane and destroyed, a task given for dedication in past assignments.",
    "All four Abyssal Dukes, the nobles who organized the Twilight's Hammer, were to be lured out and killed.",
    "A great accomplishment for the cause, Cenarion Hold called it. Some of its most powerful enemies had been vanquished, and the deed earned great commendation.",
    "The four dukes were dead, and Cenarion Hold commended the deed greatly.")
q(8740, "Twilight Marauders", "Silithus", 60, "twilight", 3,
    "Bands of mounted Twilight's Hammer cultists had been spotted riding beyond the reach of Cenarion Hold's forces. They were picking off smaller patrols and caravans. The marauders and their leader, a terrible warrior named Morna, were to be defeated and Windcaller Proudhorn told.",
    "Morna led the mounted twilight marauders who picked off Cenarion Hold's patrols. Proudhorn wanted the leader and the band dead.",
    "Well done, Proudhorn said. The marauders had been inflicting an unacceptable number of casualties, and the next assignment was ready.",
    "With Morna and the marauders dead, Proudhorn moved to the next assignment.")
q(8728, "The Good News and The Bad News", "Tanaris", 60, "bronze", 3,
    "That had taken a little longer than expected, Narain said, and he read the ledger, mumbling under his breath. The good news was that he was ninety-nine percent certain he could make an arcanite buoy to the specifications. It wholly depended on the bad news, a need for a lot of arcanite, elementium ore and rare gemstones.",
    "Narain could build the arcanite buoy, he was almost sure, given a great deal of arcanite, elementium ore and rare gemstones.",
    "A deal was a deal, Narain said, and he hoped the buyer knew what they were getting into. It was an awful lot of trouble to go to for some fishing.",
    "Over the materials, Narain agreed to make the buoy. It was a lot of trouble for a fishing trip, he remarked.")
q(8729, "The Wrath of Neptulon", "Tanaris", 60, "bronze", 6,
    "Had he mentioned the bad news, Narain asked. Its name was Maws, a hundred feet of death and destruction. His superior psycho-psionic clairvoyance put the best spot off the coast of Azshara, in the Bay of Storms. The buoy was to be cast at a swirling maelstrom cluttered with wreckage. He hoped the fisher had friends. If by some miracle it worked, the scepter shard was to go to Anachronos.",
    "Maws, a hundred feet of death, waited at a wreck-strewn maelstrom in the Bay of Storms. Narain's buoy would call it up, and the scepter shard it held was for Anachronos.",
    "Well done, Anachronos said; he would soon be able to reform the Scepter of the Shifting Sands.",
    "Maws's shard reached Anachronos, who spoke of reforming the Scepter soon.")
q(8730, "Nefarius's Corruption", "Blackwing Lair", 60, "bronze", 6,
    "Was it the champion, Vaelastrasz asked. A thousand years he had held the shard, and at his darkest hour someone rose to relieve him of it. But what would tragedy be without cruelty, he said, and he coughed weakly. Nefarius now held the scepter shard and planned to destroy it, so time was of the essence.",
    "Vaelastrasz, dying, had lost the red shard to Nefarius, who meant to destroy it. There was no time to lose.",
    "Vaelastrasz's soul was at ease, Anachronos said, and the Aspects all watched with great interest. The champion had powerful allies, and Anachronos had been commanded to grant something to aid the struggle.",
    "The red shard was recovered from Nefarius, and Vaelastrasz's soul rested. Anachronos said the Aspects were watching.")
q(8733, "Eranikus, Tyrant of the Dream", "Teldrassil", 60, "eranikus", 4,
    "This was a journey of redemption, Malfurion said. Were he slain that day, he would have died for a just and righteous cause. The green scepter shard had to be recovered, and Eranikus cleansed of the taint the Old Gods had placed on him. Outside the walls of Darnassus, one of Malfurion's agents would set things in motion. It would inform Tyrande without alerting Staghelm. Malfurion sighed over a fall from grace a thousand years in the making.",
    "Malfurion wanted Eranikus cleansed and the green shard recovered. He sent the champion to an agent outside Darnassus, who would tell Tyrande and not Staghelm.",
    "The wisp outside the city was silent but for a low hum, and oddly enough it spoke through thoughts.",
    "Outside Darnassus, a humming wisp answered in thoughts rather than words.")
q(8734, "Tyrande and Remulos", "Moonglade", 60, "eranikus", 4,
    "Tyrande would be notified, the wisp said, for Shan'do Stormrage had prepared it for this contingency. Next came the Moonglade and Remulos, who had further instruction for the summoning of Eranikus. All wished great luck.",
    "The wisp sent the champion to Remulos in Moonglade for the summoning of Eranikus, and promised Tyrande would hear.",
    "It would be impossible to pull Eranikus from the Dream if he refused, Remulos said. His own intentions, though, required him to enter the world, for he sought to destroy the living manifestation of Malfurion. Malfurion was one of the Dream's most powerful allies. Should he fall, the Nightmare would consume all that remained.",
    "Remulos explained why Eranikus would come. He meant to destroy Malfurion, and if he succeeded the Nightmare would consume everything.")
q(8735, "The Nightmare's Corruption", "Moonglade", 60, "eranikus", 4,
    "The four dream portals of Azeroth each held a fragment of the Nightmare's corruption, carried by the dragonkin who lived around them. Remulos wanted all four gathered.",
    "Four fragments of the Nightmare's corruption, one from the dragonkin at each dream portal, were Remulos's price for the summoning.",
    "Was the world prepared for what they were about to invoke, Remulos wondered. He did not know, only that he was bound by duty to Malfurion, by duty and honor.",
    "With the four fragments in hand, Remulos admitted he did not know whether the world was ready. He knew only that duty to Malfurion bound him.")
q(8736, "The Nightmare Manifests", "Moonglade", 60, "eranikus", 6,
    "Restraint was needed against Eranikus, Remulos said, for he was to be redeemed, not destroyed. Tyrande was already on her way to help. The dragon's blows had to be weathered to save Nighthaven from destruction. All hope rested on the champion and allies.",
    "Eranikus had to be weathered, not killed, until Tyrande arrived, or Nighthaven would be destroyed. Remulos called the defenders his only hope.",
    "He was redeemed, Remulos said, and had returned to the Dream to right what he alone had done wrong. Eranikus would be a powerful ally to Malfurion and to Remulos's father. Armaments given by Ysera herself went to the champion, for the battles against the Qiraji.",
    "Eranikus was redeemed and went back into the Dream. Remulos gave armaments from Ysera for the war against the Qiraji.")
q(8741, "The Champion Returns", "Tanaris", 60, "bronze", 5,
    "Anachronos awaited the champion's return at the Caverns of Time, and the green scepter shard with it.",
    "The green shard of the Scepter went to Anachronos in the Caverns of Time.",
    "From Orgrimmar to the far reaches of the South Seas, Anachronos said, all would know the champion of the Bronze Flight.",
    "With the green shard delivered, Anachronos named the champion of the Bronze Flight and promised the deeds would be known everywhere.")
q(8446, "Shrouded in Nightmare", "Moonglade", 60, "eranikus", 3,
    "Corruption seeped from the object. There might be a link between it and the dragons coming forth from the Dream. Someone able to decipher it had to be found, perhaps among the druids of the Moonglade or Cenarion Hold.",
    "An object oozing corruption might be tied to the dragons emerging from the Dream. A druid of Moonglade or Cenarion Hold might read it.",
    "Remulos had to remove the taint from the object. It might shed light on his recent failures to delve into the Dream, and he asked for it.",
    "The object went to Remulos, who meant to cleanse it. He hoped it explained why the Dream had been closed to him lately.")
q(8447, "Waking Legends", "Moonglade", 60, "eranikus", 4,
    "The waters of Lake Elune'ara should dissolve the nightmares engulfing the object, Remulos said. He asked for a moment to perform the cleansing.",
    "Remulos took the object to the waters of Lake Elune'ara to wash the nightmares from it.",
    "His ring, Remulos said; it had served its purpose for Malfurion and would now serve a new one.",
    "Cleansed in Lake Elune'ara, Malfurion's ring passed on to a new purpose.")
q(8481, "The Root of All Evil", "Winterspring", 60, "timbermaw", 6,
    "Thanks to the help they had received, the Timbermaw had found a way to summon the root of all evil. It was the corrupting demon that dominated the Winterfall tribe. A torch planted at the mouth of High Chief Winterfall's personal cave would force it to show itself. Then it had to be struck down. Only the essence of the fallen demon could begin the long healing of the Winterfall, and the salvation of Timbermaw Hold.",
    "A torch at the mouth of the high chief's cave would draw out the demon that dominated the Winterfall. Its death, the Timbermaw said, would begin their healing.",
    "The Timbermaw said they were saved. Defeating the demon Xandivious had made their Hold safe for years to come. Healing would be slow and the conflict would go on, but the Winterfall had something new, a chance at survival.",
    "Xandivious was dead, and the Timbermaw called their Hold safe for years. The Winterfall's healing would be slow, they said, but for the first time the tribe had a chance to survive.")
q(8484, "The Brokering of Peace", "Ironforge", 60, "timbermaw", 5,
    "The deeds went beyond those of a simple hero, the Timbermaw said. If this was a representative of a people, then that people were ones they would make peace with. An offering was to go to the dwarven king in his mountain of iron, the city called Ironforge. In times past he had tried to make contact on behalf of his Alliance. It was fitting now to name the key to the Alliance's efforts at peace.",
    "The Timbermaw sent an offering of peace to the dwarven king in Ironforge. Its bearer was named the key to the Alliance's efforts.",
    "Magni called it a most fortuitous turn. A lasting peace with the furbolgs would give the Alliance an advantage in Kalimdor. It was one the night elves could not support on their own. The other leaders of the Alliance would be told at once, and further diplomats would be dispatched. He thanked the courage shown in diplomacy and in action, on behalf of the whole Alliance.",
    "Magni took the Timbermaw's offering as a fortuitous turn and promised diplomats. He thanked the courage shown in diplomacy and in action on behalf of the whole Alliance.", true)
q(8485, "The Brokering of Peace", "Orgrimmar", 60, "timbermaw", 5,
    "The deeds went beyond those of a simple hero, the Timbermaw said. If this was a representative of a people, then that people were ones they would make peace with. An offering was to go to the orcish warchief in the lands of Durotar, the city called Orgrimmar. In times past he had tried to make contact on behalf of his Horde. It was fitting now to name the key to the Horde's efforts at peace.",
    "The Timbermaw sent an offering of peace to the warchief in Orgrimmar. Its bearer was named the key to the Horde's efforts.",
    "Thrall called it a most fortuitous turn. A lasting peace with these creatures would help secure Kalimdor from external threats. The other leaders of the Horde would hear at once, and more diplomats would go. He thanked the courage shown in diplomacy and in action, on behalf of the entire Horde.",
    "Thrall took the Timbermaw's offering as a fortuitous turn and promised diplomats. He thanked the courage shown in diplomacy and in action on behalf of the entire Horde.", true)
fallback("The Brokering of Peace", "Winterspring", "timbermaw", "8484,8485",
    "The Timbermaw judged one hero's deeds worth an offering of peace to that hero's people.",
    "An offering of peace from the Timbermaw was carried to a capital.",
    "The Timbermaw's offering of peace was delivered.",
    "Word of the Timbermaw's offer of peace reached the leaders.")
q(8519, "A Pawn on the Eternal Board", "Silithus", 60, "bronze", 5,
    "Once composure returned and the gaze could focus, something stirred within the crystal. On closer inspection it showed the past, a memory long forgotten.",
    "Inside the crystal tear moved a memory of the past, long forgotten.",
    "After Staghelm's betrayal, Anachronos said, he had gathered the shattered pieces of the Scepter of the Shifting Sands. He had meant to keep the scepter from any who would use it to harm the world. So the charge of the Dragonflights was born. A scepter divided among the four mighty Aspects should have been nearly impossible to restore, or so he had thought. What a fool he had been, he said, hunted even now by that cursed flight.",
    "Anachronos told how the Scepter had been divided among the four Aspects after Staghelm's betrayal. The plan had failed, he admitted, and the cursed flight hunted him still.")
q(8829, "The Ultimate Deception", "Silithus", 60, "abyssal", 4,
    "The Twilight's Hammer operated through innumerable layers of secrecy and deceit. Its actions were carried out in this world but planned in a place not yet reached. The stones it used to summon its superiors were believed to allow two-way transport. To try them that way, a twilight emissary's robe had to be replicated to the last detail. Aurel Goldleaf wanted the materials for it.",
    "To travel the wind stones as the cult's superiors did, an exact copy of a twilight emissary's robe was needed. Aurel Goldleaf wanted the materials.",
    "Yes, these would suffice, Aurel said. She would craft them into the colors the Hammer's emissaries wore. With a prayer to Elune, she hoped her skills would fool the enemy once more. The help would be rewarded.",
    "For the emissary's robe, Aurel took the materials and called the one who gathered them a loyal and worthy ally.")
q(8784, "Secrets of the Qiraji", "Ahn'Qiraj Temple", 60, "ahnqiraj", 3,
    "An ancient Qiraji artifact had been found in the temple. One of the dragons near its entrance might have a use for the relic.",
    "The dragons at the entrance of the temple might want the ancient Qiraji artifact that had turned up inside.",
    "An exceptional find, the dragon said, simply marvelous; it would give insight into the enemy's twisted minds.",
    "Delighted, the dragon expected the artifact to reveal something of the Qiraji's twisted minds.")
q(8789, "Imperial Qiraji Armaments", "Ahn'Qiraj Temple", 60, "ahnqiraj", 5,
    "The dragons had not sat idly for a millennium, one of them said. They had watched the beasts feast on their own when their utility was exhausted. Listening, they had heard plots to destroy the world. Internal treachery had shown the dragons weaknesses they knew how to use. Ceremonial armaments of the Qiraji, combined with the element born of their own god's volatility, would become a force of reckoning.",
    "A dragon at the temple's entrance wanted the Qiraji's ceremonial armaments. They were to be combined with the element born of their god's own volatility.",
    "Infused with Elementium, the dragon said, the weapons would cut through the Qiraji and their god with incredible ease.",
    "The ceremonial armaments came back infused with Elementium, weapons the dragon promised would cut the Qiraji with ease.")
q(8790, "Imperial Qiraji Regalia", "Ahn'Qiraj Temple", 60, "ahnqiraj", 5,
    "Arygos theorized that the element born of conflict between the Old Gods and their minions was also deadly to them. That element was Elementium, the dragon said. Imperial Qiraji Regalia and the toxic element would let the dragon infuse weapons of great power.",
    "Imperial Qiraji Regalia and the toxic element, Elementium, were the dragon's price for weapons of great power.",
    "Use it well, the dragon said; let them feel the pain they so dearly wished to inflict on others.",
    "The infused weapon came with the dragon's wish that the Qiraji feel the pain they meant for others.")
q(8791, "The Fall of Ossirian", "Silithus", 60, "ahnqiraj", 6,
    "A terrible menace had been laid to rest; the cruel Ossirian was vanquished. The denizens of Kalimdor would be relieved to know it. Ossirian's head was to be presented to Commander Mar'alith of Cenarion Hold.",
    "Ossirian's head was proof for Commander Mar'alith that the terrible menace of the Ruins was dead.",
    "Mar'alith offered his highest commendation and the choice of an item of power. A great service had been done the people of Kalimdor.",
    "At Cenarion Hold, Ossirian's head earned Mar'alith's highest commendation and the choice of an item of power.")
q(8857, "Secrets of the Colossus - Ashi", "Stranglethorn Vale", 60, "colossus", 2,
    "Oglethorpe in Booty Bay wanted a fresh husk sample from the fallen Colossus of Ashi. The collector wanted no one near the corpse and handed over a sample instead. It had to be delivered quickly, since the husks were no good to Oglethorpe rotten.",
    "A sample of the Colossus of Ashi's husk had to reach Oglethorpe in Booty Bay before it rotted.",
    "Oglethorpe was delighted, and spoke of the chickens he would craft from such a wondrous husk.",
    "The husk was wondrous, Oglethorpe said, and he meant to craft chickens from it.")
q(8858, "Secrets of the Colossus - Regal", "Searing Gorge", 60, "colossus", 2,
    "The sample collector would have liked nothing more than to stuff the bug husk down Oilfist's fat face. Collecting samples from the overgrown cockroach would take until the wee hours, though. The sample was to go fast to Oilfist at Thorium Point in the Searing Gorge, who was paying big.",
    "A husk sample from the Colossus of Regal was bound for Oilfist at Thorium Point, who was paying big for it.",
    "Excellent, Oilfist said; incredibly powerful armor might be devised from the chitin, and the promised riches were paid.",
    "Oilfist paid the promised riches for the chitin and spoke of powerful armor.")
q(8859, "Secrets of the Colossus - Zora", "Eastern Plaguelands", 60, "colossus", 2,
    "Servants had nearly been killed recovering the sample, and there was no time to lose. Lord Maxwell Tyrosus eagerly awaited a fresh husk sample, believing the secrets of the Colossus could help in the war against the Scourge. It was to go to Light's Hope, for a handsome reward.",
    "A husk sample from the Colossus of Zora went to Lord Maxwell Tyrosus at Light's Hope. He hoped it held secrets for the war against the Scourge.",
    "Excellent and timely, Maxwell said, and well done.",
    "Maxwell called the sample excellent and timely.")
q(9419, "Scouring the Desert", "Silithus", 60, "silithyst", 2,
    "The Alliance had recently learned that the Horde was scavenging the Silithus desert for resources. At first it had paid that little mind. Stationing large numbers in the sweltering desert had not seemed worth it. Then the importance of the resources was discovered, and the Alliance scrambled to catch up. Silithyst was to be recovered from the desert and brought in.",
    "Silithyst from the desert was suddenly worth a scramble. Every load counted for the Alliance outpost in Silithus.",
    "Thank the Light, came the answer. Had the work only started sooner, the need would not be so desperate. The bounty of the desert had to be kept from the Horde.",
    "The silithyst went into the Alliance's stock, with regret that the work had started so late.", true)
q(9422, "Scouring the Desert", "Silithus", 60, "silithyst", 2,
    "For some time the Horde had been tapping the crystal resources of the Silithus desert. The only dangers had been the creatures that lived there and the oppressive sand, dust and heat. Now the Alliance seemed to have caught on. It was a race to capture the resources and keep them from the other side. The Horde needed every available hand.",
    "The Alliance had caught on to the Horde's silithyst, and the race for the desert's crystals needed every hand.",
    "Well done, came the answer. The resources would join the stockpiles, every bit a gain for the Horde and a loss for the enemy.",
    "Every load of silithyst, the Horde's collector said, was a gain for the Horde and a loss for the enemy.", true)
fallback("Scouring the Desert", "Silithus", "silithyst", "9419,9422",
    "Both Alliance and Horde raced to gather silithyst from the Silithus desert and keep it from the other.",
    "Silithyst in the desert had become a prize the two factions scrambled for.",
    "A load of silithyst was brought in from the desert.",
    "The race for the desert's silithyst went on.")
for _, id in ipairs({8275, 8276, 8280, 8281, 8307, 8313, 8317, 8318, 8331, 8332, 8341, 8343, 8348, 8349, 8351, 8352, 8361, 8498, 8507, 8731, 8534, 8738, 8739, 8535, 8536, 8537, 8737, 8538, 8740, 8728, 8729, 8730, 8733, 8734, 8735, 8736, 8741, 8446, 8447, 8481, 8484, 8485, 8519, 8829, 8784, 8789, 8790, 8791, 8857, 8858, 8859, 9419, 9422}) do src(id) end

-- band5060 (2026-11-06): the Blasted Lands (Kum'isha's spheres and junk, the Fallen Hero's account,
-- the eighteen stones, Kirith, Trebor's name, the demon hunter Loramus).
q(2521, "To Serve Kum'isha", "Blasted Lands", 55, "kumisha", 3,
    "Could so miniscule a brain comprehend the rarity of a flawless sphere of draenethyst, Kum'isha asked. Draenei had spent lifetimes searching for just one, only to meet horrible fates with their purpose unfulfilled. Knowing all that, the visitor still wished to assist. A flawless sphere found anywhere in those lands, brought to Kum'isha, would earn riches beyond the wildest dreams.",
    "Kum'isha, a draenei in the Blasted Lands, wanted a flawless sphere of draenethyst. His people had died searching for such things, and he promised riches for one.",
    "Impossible, Kum'isha said, and asked whether his eyes deceived him. Perhaps now a rift could be opened to return his people to their homeland.",
    "The flawless sphere left Kum'isha stammering, and hoping for a rift home.")
q(2522, "Kum'isha's Endeavors", "Blasted Lands", 55, "kumisha", 3,
    "The portal conjuration had failed, but Kum'isha remained hopeful about his next attempt. Draenei hope was as fervent as the visitor's greed for trinkets, he said. He wanted another flawless sphere from the cursed lands, though the choice was left entirely free, he said with a grin.",
    "Kum'isha's first portal had failed, and he wanted a second flawless sphere of draenethyst.",
    "Simply amazing, said Kum'isha. He had doubted another sphere could be found, yet there it was, pulsating in his hands. Any more, which he believed impossible, would be rewarded again.",
    "A second sphere pulsed in Kum'isha's hands, and he promised reward for any more, though he called that impossible.")
q(3501, "Everything Counts In Large Amounts", "Blasted Lands", 55, "kumisha", 2,
    "A flawless sphere might never be found, but imperfect fragments of draenethyst would surely turn up across the Blasted Lands. Kum'isha doubted the flawed pieces could carry him home. They might serve the draenei in other ways, though, and he would pay for any brought back.",
    "Flawed fragments of draenethyst were worth something to Kum'isha even if they could not open a portal.",
    "The visitor disgusted him, Kum'isha said, a grown adult drooling over a pile of junk. He paid, and ordered the visitor out of his sight.",
    "Payment for the fragments came with an insult about drooling over junk, and an order to get out of Kum'isha's sight.")
q(3502, "One Draenei's Junk...", "Blasted Lands", 55, "kumisha", 2,
    "After that display of voracious greed, Kum'isha felt nauseous, but he would not dwell on the material addiction. Each imperfect fragment would earn more junk in return. His junk heap shrank while the visitor's grew, which on Draenor was called a win-win. He clenched a fist and knocked on the visitor's head to ask whether anybody was home.",
    "Kum'isha offered junk for junk, fragment by fragment, a win-win as they said on Draenor. He rapped on his visitor's skull to check whether anyone was home.",
    "The same insult came again, pitiful, a grown adult drooling over junk, out of his sight. It should sound familiar, Kum'isha said, since he said it a thousand times a day. Oh, how he loathed this world.",
    "Word for word, Kum'isha repeated his insult. He admitted he said it a thousand times a day, and he cursed the world he was stuck in.")
q(2783, "Petty Squabbles", "Blasted Lands", 57, "fallenhero", 3,
    "They were fighting the wrong enemy, one of the Alliance in the Blasted Lands said. The true power in those lands grew in strength and number while they squabbled with orcs over scorched earth. A war against the Horde there would only end in a rout by the armies of the Burning Legion. The fallen hero of the Horde knew the truth behind the Blasted Lands. Old differences had to be set aside to hear him.",
    "The fallen hero of the Horde knew the truth of the Blasted Lands. Someone of the Alliance urged setting old differences aside to hear it.",
    "So the Alliance wished to assist, the Fallen Hero said. He had thought never to see such a day again, with Alliance fighting beside Horde against a common enemy. It would be so, and they would unite.",
    "An Alliance ally was welcome, the Fallen Hero said, and against the common enemy they would unite.")
q(2784, "Fall From Grace", "Blasted Lands", 50, "fallenhero", 2,
    "The Fallen Hero of the Horde asked only to be heard.",
    "Before anything else, the Fallen Hero wanted his account listened to.",
    "As a spirit he was powerless, the Fallen Hero said, and asked for help in regaining his honor.",
    "Powerless as a spirit, the Fallen Hero asked for help to regain his honor.")
q(2801, "A Tale of Sorrow", "Blasted Lands", 57, "fallenhero", 2,
    "Before they could go on, the Fallen Hero said, his account had to be heard.",
    "The Fallen Hero had more to tell before the work could continue.",
    "Now was the time to act, the Fallen Hero said.",
    "With the telling done, the Fallen Hero called for action.")
q(2681, "The Stones That Bind Us", "Blasted Lands", 57, "fallenhero", 5,
    "It would take more than one alone to overcome Razelikh and his subordinates, the Fallen Hero said. A suitable group was to be gathered to free his men from their eternal torture. Eighteen stones had to be shattered. Fight hard, he said, and die with honor.",
    "Eighteen stones bound the Fallen Hero's men in torment. He asked for a group strong enough to shatter them all.",
    "It was done, the Fallen Hero said, and the poor tortured souls could finally rest. The work was not over, and there was much to discuss and more to accomplish.",
    "The eighteen stones were broken and the tortured souls at rest. More remained, the Fallen Hero said, and much to discuss.")
q(2701, "Heroes of Old", "Blasted Lands", 57, "fallenhero", 3,
    "A relic of old was offered, since the freed spirits no longer had use for it. It was to serve well in the fight against the Legion.",
    "The freed men of the Fallen Hero had no more use for their relics. They offered one for the fight against the Legion.",
    "Sparkle and gleam blinded for a moment.",
    "For a moment the relic's gleam was blinding.", true)
q(2702, "Heroes of Old", "Blasted Lands", 57, "fallenhero", 3,
    "Nobility and heroism had honored the Fallen Hero, he said, and honored his men.",
    "The Fallen Hero spoke of honor done to him and to his men.",
    "Indeed, all of them were honored, the Fallen Hero said, and thanks alone were not sufficient.",
    "Thanks alone were not enough, the Fallen Hero said, for honor done to them all.", true)
fallback("Heroes of Old", "Blasted Lands", "fallenhero", "2701,2702",
    "The freed spirits of the Fallen Hero's men had relics of old to offer against the Legion.",
    "The Fallen Hero of the Horde spoke of honor done to his men.",
    "The Fallen Hero's men gave their thanks.",
    "Honor was done to the heroes of old.")
q(2721, "Kirith", "Blasted Lands", 58, "defiler", 4,
    "As one part of the adventure closed, another began, the Fallen Hero said. One of his men was still unaccounted for, Lieutenant Kirith, lost somewhere in the Blasted Lands. Both had been imprisoned and tortured by Allistarj, but poor Kirith's strength of will had faltered. From his cage the Hero had heard the experiments, the tortured screams ringing through the cave. That was the last he saw or heard of Kirith.",
    "Lieutenant Kirith, tortured by Allistarj in the same cave as the Fallen Hero, was still missing somewhere in the Blasted Lands.",
    "Trebor, Kirith repeated, Trebor had sent the visitor.",
    "Kirith was found, and he was surprised to hear that Trebor had sent the search.")
q(2743, "The Cover of Darkness", "Blasted Lands", 60, "defiler", 4,
    "There was no time to mince words, Kirith said, for his time there was limited. The triad of power protecting the demon lord Razelikh had to be destroyed, no simple task like freeing a damned soul. Each of Razelikh's underlings wore around the neck a third of an amulet of Razelikh's own making. It was the same amulet needed to summon the arch demon. Trebor was to be told what summoning Razelikh required.",
    "Kirith grinned over the triad. Each of Razelikh's underlings wore a third of the amulet that could summon the arch demon. Trebor needed to know it.",
    "The demon lord's cunning was almost as calculated as his brutality, Trebor said.",
    "Hearing what Kirith had learned, Trebor called Razelikh as cunning as he was brutal.")
q(2744, "The Demon Hunter", "Azshara", 60, "defiler", 4,
    "Razelikh protected the triad, Trebor said. In exchange for their servitude he had granted each of them nearly unlimited power within the Blasted Lands. The amulet pieces were attuned to their owners' lifeforce. As long as they stayed within the Blasted Lands they could not be slain, their lives extended to the end of days. One who might help was the demon hunter Loramus Thalipedes, somewhere on the islands of Azshara.",
    "The triad could not be killed inside the Blasted Lands, Trebor said. He sent the hunt to Azshara's islands for the demon hunter Loramus Thalipedes.",
    "Loramus would help, though he did not think the visitor fully understood what they were up against.",
    "On the islands, Loramus agreed to help and doubted the visitor knew what lay ahead.")
q(3141, "Loramus", "Azshara", 57, "defiler", 2,
    "So the visitor wished to battle demons, Loramus said; they would do well to listen to his account.",
    "Loramus had an account to give before any demon was fought.",
    "Be it so, then, Loramus said.",
    "The demon hunter agreed. So be it, he said.")
for _, id in ipairs({2521, 2522, 3501, 3502, 2783, 2784, 2801, 2681, 2701, 2702, 2721, 2743, 2744, 3141}) do src(id) end

-- band5060 (2026-11-06): the Sunken Temple (Eranikus's gem and Itharius's Oathstone, Marvon Rivetseeker's
-- stone circle, the altar and the idol's eye).
q(3373, "The Essence of Eranikus", "The Temple of Atal'Hakkar", 55, "eranikus", 4,
    "At a touch of the gem a deep voice spoke in the mind. It was Eranikus of the Green Dragonflight, keeper of the accursed temple. His charge to keep the trolls from ever again bringing forth their abomination of a god had for now ended in failure. As he imbued the gem with part of his essence, he felt his grip on the Dream twisting into chaos. He begged that the gem be placed in the essence font in his lair. There its magic could purge the taint from his psyche and let him rest.",
    "Eranikus's voice in the gem asked for one thing. It was to be set in the essence font in his lair. There the Green Dragonflight's magic might cleanse the corruption from what remained of him.",
    "The gem went into the font, and Eranikus's thanks turned to horror. Even a Green Dragonflight essence font was tainted by the accursed god's corruption, he cried. His essence was ripping from him and the grip of an eternal nightmare was taking hold. He begged that one of the Green Dragonflight be found to stop it, chained in darkness and forever in agony.",
    "In the essence font the gem did the opposite of what Eranikus had hoped. He screamed of his essence tearing away and an eternal nightmare taking hold. One of the Green Dragonflight had to be found, he begged.", true)
q(3374, "The Essence of Eranikus", "Swamp of Sorrows", 55, "eranikus", 4,
    "Through the Oathstone, Itharius spoke directly to the mind. Accepting the charge in the stone meant aiding his cause and that of Ysera's Dragonflight in redeeming the corrupted soul of Eranikus. The first sacrifice, one of many, was to give up the gem that chained what free-willed part of Eranikus's psyche remained.",
    "Itharius of Ysera's flight offered a charge through the Oathstone, the redemption of Eranikus. He asked first for the gem that held the last free part of him.",
    "So it began, Itharius said, now that the choice was made. Choices to date had been the correct ones, in his judgment, and actions from then on would decide whether that continued.",
    "With the gem given up, Itharius called it a beginning. So far the right choices had been made, he said; what came next would show whether that held.", true)
fallback("The Essence of Eranikus", "The Temple of Atal'Hakkar", "eranikus", "3373,3374",
    "Eranikus of the Green Dragonflight, keeper of the Sunken Temple, had bound part of his essence in a gem and asked for release.",
    "A gem in the Sunken Temple held part of the essence of Eranikus.",
    "The matter of Eranikus's gem went forward.",
    "The gem holding Eranikus's essence was carried a step further.")
q(3380, "The Sunken Temple", "Tanaris", 51, "atalai", 2,
    "There were restless spirits in the world, tainted by isolation and bound to an ancient evil. A place lay deep below the surface of the earth, banished there by powers greater than any the speaker had seen. Anyone who wished to learn of the Sunken Temple should find a goblin named Marvon Rivetseeker. He had studied many ancient places. Last word had him leaving his home in Ratchet for the troll ruins of Tanaris.",
    "Deep beneath the earth lay the Sunken Temple. The goblin Marvon Rivetseeker, last seen bound for the troll ruins of Tanaris, had studied it.",
    "Marvon had seen the Sunken Temple with his own eyes, he said. He had things to tell that might intrigue the adventurous type.",
    "In Tanaris, Marvon Rivetseeker admitted he had seen the temple himself and offered to say more.", true)
q(3445, "The Sunken Temple", "Tanaris", 51, "atalai", 2,
    "A place lay deep below the surface of the earth, banished there by powers greater than any the speaker had seen. Anyone who wished to learn of the Sunken Temple should find a goblin named Marvon Rivetseeker. Like Troyas and the speaker, he had studied many ancient places. He had last been known to leave Ratchet for the troll ruins of Tanaris. No one had heard from him in some time.",
    "Marvon Rivetseeker, a goblin scholar of ancient places, knew of the Sunken Temple. He had gone quiet somewhere in the troll ruins of Tanaris.",
    "Yes, the Sunken Temple, Marvon said. He had seen it with his own eyes, and had things to tell that might intrigue the adventurous type.",
    "In Tanaris, Marvon Rivetseeker admitted he had seen the temple himself and offered to say more.", true)
fallback("The Sunken Temple", "Tanaris", "atalai", "3380,3445",
    "The goblin scholar Marvon Rivetseeker, last seen among the troll ruins of Tanaris, had studied the Sunken Temple.",
    "A place banished deep below the earth, the Sunken Temple, was known to the goblin Marvon Rivetseeker.",
    "Marvon Rivetseeker was found in Tanaris.",
    "The search for what Marvon knew of the Sunken Temple went on.")
q(3444, "The Stone Circle", "The Barrens", 51, "atalai", 3,
    "Marvon had once entered the foreboding chambers of the Sunken Temple, where the evil penetrated everyone who entered. He had barely found his way out, wading through the ooze on the floors. All he remembered was stumbling through a large circular room filled with serpent statues. Recently he had found a round stone with the same serpent symbol and shipped it to his workshop in Ratchet. With it in hand he might remember more.",
    "A round stone marked with the serpent symbol of the Sunken Temple waited in Marvon's workshop in Ratchet. He wanted it brought back.",
    "Yes, this was the stone, Marvon said. It was all coming back to him.",
    "The stone from Ratchet brought Marvon's memories of the temple flooding back.")
q(3446, "Into the Depths", "The Temple of Atal'Hakkar", 51, "atalai", 4,
    "Inside the temple, Marvon had found a circular room with six balconies, a serpent statue on the edge of each. Curious, he had pushed one, and it was a trap. The explosion had nearly sent him to his death. Lying on the ledge, he had looked down and seen another statue at the base of the room. It was an altar of sorts, to Hakkar, he thought. That altar was the secret, and the token had to be brought to it.",
    "Marvon believed the altar at the base of the temple's circular room was the secret. The stone circle had to be taken down to it.",
    "Into the opening went the stone circle, and it locked into place. What came next was unclear, and the altar needed closer examination.",
    "Once the stone locked into place, the altar seemed worth a closer look.")
q(3447, "Secret of the Circle", "The Temple of Atal'Hakkar", 51, "atalai", 5,
    "Marvon's memories were cloudy, but he believed the circle of statues in the Sunken Temple held the secret to a greater treasure. From the main altar he had activated a series of lights. Whoever worked out what the lights meant might unlock what the room was hiding. Great evil lay in the temple, though, and anything valuable would be fervently guarded.",
    "The lights the altar lit among the serpent statues were the key to the room's treasure, Marvon thought. It would be guarded.",
    "Even in the temple's half-darkness the idol's eye glittered, and something shiny showed behind it. Sliding the eye aside revealed what lay inside the statue, the Atal'ai treasure.",
    "Behind the idol's glittering eye lay the Atal'ai treasure, there for the taking.")
for _, id in ipairs({3373, 3374, 3380, 3445, 3444, 3446, 3447}) do src(id) end

-- band5060 (2026-11-06): the Plaguelands (Araj and Andorhal both factions, the call to arms, Sorrow Hill,
-- Jessica and Pamela, Araj's scarab, the termites for Northridge, Sylvanas's champion, the scout at
-- Hearthglen, Zaeldarr, Gregor's reports, Umbranse's writing, a widow's revenge, Augustus, the Scourge's
-- necropolises, Ramaladni, Omarion's handbook).
q(105, "Alas, Andorhal", "Western Plaguelands", 60, "andorhal", 6,
    "The time to attack Andorhal and drive out the lich who controlled it had come. Araj the Summoner held dominion inside the ruins, guarded by numerous Scourge around the city's center and by a formidable personal retinue. Numerous allies would be needed to stand a chance against him. A shard of his phylactery would be the proof.",
    "Araj the Summoner ruled ruined Andorhal from its center, behind rings of Scourge and his own guardians. Derrington wanted him destroyed and a shard of his phylactery brought back.",
    "The lich was finally defeated, Derrington said, and it was a tremendous service to the Horde. Such bravery and perseverance showed what it meant to be a true hero. A token for all to see marked a victory for the ages.",
    "The lich of Andorhal was gone. Derrington called it a victory for the ages and gave a token for all to see.", true)
q(211, "Alas, Andorhal", "Western Plaguelands", 60, "andorhal", 6,
    "The time to attack Andorhal and drive out the lich who controlled it had come. Araj the Summoner held dominion inside the ruins, guarded by numerous Scourge around the city's center and by a formidable personal retinue. Numerous allies would be needed to stand a chance against him. A shard of his phylactery would be the proof.",
    "Araj the Summoner ruled ruined Andorhal from its center, behind rings of Scourge and his own guardians. Valorfist wanted him destroyed and a shard of his phylactery brought back.",
    "The lich was finally defeated, Valorfist said, and it was a tremendous service to the Alliance. Such bravery and perseverance showed what it meant to be a true hero. A token for all to see marked a victory for the ages.",
    "The lich of Andorhal was gone. Valorfist called it a victory for the ages and gave a token for all to see.", true)
fallback("Alas, Andorhal", "Western Plaguelands", "andorhal", "105,211",
    "Araj the Summoner, the lich who ruled ruined Andorhal, was the target of the long-prepared attack on the city.",
    "The attack on Andorhal aimed at the lich Araj the Summoner in the ruined city's heart.",
    "The attack on Andorhal's lich was carried out.",
    "The campaign against Araj the Summoner reached its end.")
q(5066, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 3,
    "The Kingdom of Stormwind had issued a call to arms, and all heroes were called on to heed it. Every able body was to take up arms against the dark threat of the Scourge in the northern lands of the Eastern Kingdoms. Rumors flew of new threats rising from the ruins of the Plaguelands. Heroes of the realm were to seek out Commander Ashlam Valorfist at Chillwind Camp, north of the Alterac Mountains.",
    "Stormwind's call to arms against the Scourge pointed north, to Commander Ashlam Valorfist's camp at Chillwind, north of the Alterac Mountains.",
    "Welcome to the Plaguelands, Valorfist said, one of the most dangerous frontiers in Azeroth. The Scourge loomed to the north and northeast. He was glad the clarion call of duty had not fallen on deaf ears, and there was plenty for willing hands to do.",
    "Valorfist welcomed another who had heard the call and promised plenty of work on the most dangerous frontier in Azeroth.", true)
q(5090, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 3,
    "All heroes were called on to heed Stormwind's call to arms. It had gone out against the Scourge in the north of the Eastern Kingdoms, where new threats were rumored to rise from the ruins of the Plaguelands. Commander Ashlam Valorfist waited at his base camp in Chillwind Camp, north of the Alterac Mountains.",
    "Rumors of new threats in the Plaguelands had brought Stormwind's call to arms, and volunteers were sent to Commander Ashlam Valorfist at Chillwind Camp.",
    "Valorfist welcomed another who had heard the call and promised plenty of work on the most dangerous frontier in Azeroth.",
    "Valorfist called the Plaguelands one of the most dangerous frontiers in Azeroth, with the Scourge looming north and northeast. He had plenty for willing hands to do.", true)
q(5091, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 3,
    "Stormwind had issued a call to arms against the dark threat of the Scourge in the northern lands. Every able body was entreated to answer it. Rumors flew of new threats rising from the ruins of the Plaguelands. Commander Ashlam Valorfist had set up his base camp at Chillwind Camp, north of the Alterac Mountains.",
    "Every able body was wanted at Chillwind Camp, where Commander Ashlam Valorfist gathered Stormwind's answer to the Scourge.",
    "Glad the clarion call of duty had not fallen on deaf ears, Valorfist welcomed the newcomer to the edge of the Plaguelands and its plentiful work.",
    "Valorfist called the Plaguelands one of the most dangerous frontiers in Azeroth and set the newcomer to work at its edge.", true)
q(5094, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 3,
    "The Horde called on the heroes of the realm for swift action. A call to arms had gone out against the Scourge. Rumors flew of new threats rising east of the Undercity, in the northern reaches of the lands now known as the Plaguelands. Heroes were to seek out High Executor Derrington at his base camp at the Bulwark, east of Tirisfal Glades.",
    "The Horde's call to arms against the Scourge pointed east of the Undercity, to High Executor Derrington's camp at the Bulwark.",
    "Welcome to the Plaguelands, Derrington said, one of the most dangerous frontiers in Azeroth. The Scourge loomed to the east, and further east still. He was glad the call of duty to the Horde had not fallen on deaf ears. There was plenty to do on the edge of the Plaguelands.",
    "Derrington welcomed another who had heard the call and promised plenty of work on the edge of the Plaguelands.", true)
q(5095, "A Call to Arms: The Plaguelands!", "Western Plaguelands", 50, "plaguelands_campaign", 3,
    "The Horde called for swift action against the Scourge. Rumors flew of new threats rising east of the Undercity, in the northern reaches of the Plaguelands. High Executor Derrington had set up his base camp at the Bulwark, east of Tirisfal Glades, and heroes of the realm were to seek him out.",
    "Rumors of new threats east of the Undercity had brought the Horde's call to arms, and volunteers were sent to High Executor Derrington at the Bulwark.",
    "Derrington welcomed another who had heard the call and promised plenty of work on the edge of the Plaguelands.",
    "Derrington called the Plaguelands one of the most dangerous frontiers in Azeroth, with the Scourge to the east and further east still. He had plenty for willing hands to do.", true)
fallback("A Call to Arms: The Plaguelands!", "Western Plaguelands", "plaguelands_campaign", "5093,5066,5090,5091,5094,5095",
    "A call to arms had gone out against the Scourge in the Plaguelands, and volunteers were sent to the base camps on its edge.",
    "Rumors of new threats in the ruins of the Plaguelands had brought a call to arms from both capitals.",
    "The call to arms for the Plaguelands was answered.",
    "A new volunteer reported to the edge of the Plaguelands.")
q(5092, "Clear the Way", "Western Plaguelands", 52, "andorhal", 3,
    "With Andorhal's western and northern roads well fortified, Valorfist meant to strike from the less defended eastern road. The Scourge relied on the undead infesting Sorrow Hill as a first line of defense. Its skeletons and ghouls had to be thinned first, to clear the way.",
    "Valorfist's advance on Andorhal would come through Sorrow Hill, and the skeletons and ghouls there had to be thinned first.",
    "Mission accomplished, Valorfist said, well played. Coin from the Stormwind coffers rewarded the work so far. It was best spent on materiel for the next mission, which would lead into the ruins of Andorhal itself.",
    "Sorrow Hill was thinned, and Valorfist paid from Stormwind's coffers with advice to spend it on gear for Andorhal.")
q(5098, "All Along the Watchtowers", "Western Plaguelands", 56, "andorhal", 4,
    "A magical device called a beacon torch could mark targets for a later attack by the troops. Derrington believed the Scourge were using Andorhal's watchtowers to control their movements. A beacon had to be planted in the doorway of each of the four towers, and the torch held only five charges.",
    "Derrington wanted all four of Andorhal's watchtowers marked with a beacon torch of five charges, from their doorways.",
    "Extremely strong signals came from all four towers, Derrington's warlocks reported. The orders had been executed with the skill and precision of a seasoned veteran, he said, and the service to the Horde was duly noted once more. With the towers marked, the preparations were in place, and the fight was to be taken to the Scourge.",
    "All four towers signaled to the beacon trackers, and Derrington said the time had come to take the fight to the Scourge.", true)
q(5601, "Sister Pamela", "Eastern Plaguelands", 55, "darrowshire", 4,
    "Jessica had fled Lordaeron during the great war and escaped before the Scourge swept through, but her family had not been so lucky. She feared they had all died in the battle of Darrowshire. The village lay in the southern hills of what was now the Eastern Plaguelands. She missed them all, especially her little sister Pamela, and asked for her to be found.",
    "Jessica, who had escaped Lordaeron before the Scourge came, asked for a search of Darrowshire for her family, and most of all for her little sister Pamela.",
    "Pamela wanted to know where her sister Jessica was. Jessica had left long ago, when Pamela was a little girl, and had cried so much. Pamela did not know why, unless she had fallen and hit her toe. They used to play games, dance and pick flowers around the house, and hide when daddy came home. If Jessica came back, maybe daddy would too, and they could all play together again.",
    "In Darrowshire, Pamela asked after her sister Jessica, who had left crying long ago. She remembered the games, the flowers and hiding from daddy, and hoped that if Jessica came back, daddy would too.")
q(5803, "Araj's Scarab", "Western Plaguelands", 60, "skeletonkey", 6,
    "Araj the Summoner lorded over Andorhal from the ruined city's heart. He had led Scholomance before he claimed the city as his own. To finish the key, his signet, called a scarab, had to be mounted as its head. Now that Araj was drawn into the open, his hold on the city was to be broken and the scarab seized from his fallen phylactery.",
    "Araj's scarab, the signet of the lich who ruled Andorhal, would be the head of the Skeleton Key. It was to be taken from his phylactery, Arbington said.",
    "Yes, this was it, Arbington said, amazed again at the depths of such heroism. A special solvent would secure the scarab as the head of the key. It would infuse the key with the power to breach the locked door of Scholomance, and here went nothing.",
    "Arbington set the scarab on the key with his solvent, and the Key to Scholomance was made.", true)
q(5804, "Araj's Scarab", "Western Plaguelands", 60, "skeletonkey", 6,
    "Araj the Summoner lorded over Andorhal from the ruined city's heart. He had led Scholomance before he claimed the city as his own. To finish the key, his signet, called a scarab, had to be mounted as its head. Now that Araj was drawn into the open, his hold on the city was to be broken and the scarab seized from his fallen phylactery.",
    "Araj's scarab, the signet of the lich who ruled Andorhal, would be the head of the Skeleton Key. It was to be taken from his phylactery, Dithers said.",
    "Yes, this was it, Dithers said, amazed at the depths of such cunning and bravery. A special solvent would secure the scarab as the head of the key. It would infuse the key with the power to breach the locked door of Scholomance, and it would take just a moment.",
    "Dithers set the scarab on the key with his solvent, and the Key to Scholomance was made.", true)
fallback("Araj's Scarab", "Western Plaguelands", "skeletonkey", "5803,5804",
    "The Skeleton Key needed its head, the scarab signet of Araj the Summoner, the lich who ruled Andorhal.",
    "Araj the Summoner's scarab, taken from his phylactery, would finish the key to Scholomance.",
    "Araj's scarab was taken.",
    "The last piece of the Skeleton Key was won in Andorhal.")
q(5901, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 2,
    "To bring pain and strife to the Scarlet Crusade, their precious lumber mill was to be taken from them. The loss of such a resource would hurt them as they defended and rebuilt the town. It all started with a jar, to be filled with termites from the mounds throughout Plaguewood in the Eastern Plaguelands.",
    "A jar of termites from the mounds of Plaguewood was the first step of a plan against the Scarlet Crusade's lumber mill.",
    "These would do nicely, came the thanks, and the next step waited.",
    "Enough termites filled the jar to go on with the plan.", true)
q(5902, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 3,
    "With plenty of termites gathered, a steel-reinforced barrel was to go to the Northridge Lumber Mill. The mill lay south of Hearthglen, west of the road up to the town. It was to be set somewhere high in the center of the mill, on a crate. Once it was opened, the rest would take care of itself.",
    "The barrel of termites was for the Northridge Lumber Mill south of Hearthglen, to be opened on a crate in the middle of the mill.",
    "On top of the crate, the termites were obviously getting restless.",
    "Set on a crate in the mill, the barrel shook with restless termites.", true)
q(6389, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 4,
    "A crowbar found around the lumber mill would open the barrel. After that the mill had to be left before the termites got loose.",
    "A crowbar from the mill would do for the barrel, and then it was a matter of getting out before the termites spread.",
    "Haha, it was done, came the thanks. A father's spirit could rest now, and the one who had asked could live in peace. Anything in return was there for the asking.",
    "The mill was infested, and the one who had asked for it spoke of a father's spirit at rest and a life in peace.", true)
q(5903, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 2,
    "Force alone had failed many times to rout the Scarlet Crusade, so the alternative was to make their lives more difficult. The lumber mill was to be infested with the most terrible species of termites ever found. In Plaguewood, near once-great Stratholme, lived a breed that had survived the plague and the Scourge combined. A jar was to be filled from their mounds.",
    "Termites from Plaguewood that had survived the plague itself were to fill a jar, for the Scarlet Crusade's lumber mill.",
    "These would do nicely, came the thanks, with so many of them all huddled up. The Crusade almost deserved pity, he said, but it had never been their mill to take.",
    "The jar came back full, and its receiver nearly pitied the Crusade before remembering whose mill it had been.", true)
q(5904, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 3,
    "With the termites in hand, a steel-reinforced barrel was to go to the Northridge Lumber Mill. The mill lay south of Hearthglen, west of the road up to the town. Opened somewhere suitable in the center of the mill, on a crate, it would let the termites do their work. The mill would then be useless to the Crusade.",
    "The barrel of termites was for a crate in the middle of the Northridge Lumber Mill, to make it useless to the Crusade.",
    "On top of the crate, the termites were obviously getting restless.",
    "Set on a crate in the mill, the barrel shook with restless termites.", true)
q(6390, "A Plague Upon Thee", "Western Plaguelands", 55, "termites", 4,
    "A crowbar found around the lumber mill would open the barrel, and then the mill had to be left before the termites got loose. For the one who had sent the barrel, it had been bad enough to see family lose their jobs and lives. Seeing the mill of a childhood taken over by those disgusting so-called holy men was worse.",
    "The barrel opened with a crowbar in the mill where the one who sent it had grown up, before the Crusade took it.",
    "Thanks came with a coin, with apologies that it was not more, and a wish that some joy be taken in wrecking the Scarlet Crusade's efforts.",
    "A coin and an apology for its size followed, and the hope of some joy in the Crusade's loss.", true)
fallback("A Plague Upon Thee", "Western Plaguelands", "termites", "5901,5902,6389,5903,5904,6390",
    "Termites from Plaguewood were to ruin the Scarlet Crusade's lumber mill at Northridge, south of Hearthglen.",
    "A plan against the Crusade's Northridge Lumber Mill ran on a jar of Plaguewood termites and a barrel.",
    "The plan against Northridge Lumber Mill moved a step on.",
    "Work against the Crusade's lumber mill went on.")
q(5961, "The Champion of the Banshee Queen", "Eastern Plaguelands", 56, "marris_stead", 3,
    "It pleased the Dark Lady to see the battle-hardened join her cause, and her numbers grew by the day. Among the first of her champions had been Nathanos, now called the Blightcaller, and few in her ranks matched his dedication or vigor. He resided at the Marris Stead in the Eastern Plaguelands. From there he roamed the wastes and slew any of the Scourge or the Alliance who crossed his path.",
    "Sylvanas sent a tested fighter to one of her first champions, Nathanos Blightcaller, at the Marris Stead in the Eastern Plaguelands.",
    "Surely the Dark Lady did not believe the visitor worthy to meet her champion, Nathanos said. The visitor must have come to feed his hounds, for there could be no other reason for the interruption.",
    "Nathanos assumed the newcomer had come to feed his hounds, since the Dark Lady could not possibly think them worthy of him.")
q(6004, "Unfinished Business", "Western Plaguelands", 56, "hearthglen", 3,
    "A scout had been sent to do some damage and gauge the strength of Hearthglen's defenses. Some in the Alliance felt the little town had more than historical importance, and it was not the scout's job to ask what. In no shape to continue without rest, the scout offered to pay handsomely for help. It would start at the Crusade's camp to the south, near their small bulwark.",
    "A weary Alliance scout near Hearthglen paid for help against the Crusade's camp by their small bulwark to the south. It was a test before the main goal.",
    "Well done, the scout said, amazed at how quickly they had been dealt with. No one the scout had met approved of the Scarlet Crusade and its methods. The scout believed in the Light as much as anyone in Stormwind, but the Crusade wanted only to kill anyone not loyal to it, innocents included.",
    "The Crusaders at the camp were dealt with, and the scout spoke of a Crusade that would kill even innocents.", true)
q(6023, "Unfinished Business", "Western Plaguelands", 57, "hearthglen", 4,
    "The scout's real mission had been to weaken the Crusade's outlying forces and then infiltrate Hearthglen to gauge their numbers. That was still impossible alone. Before being discovered, the scout had learned that two members were the backbone of the Crusade's forces outside the town. They were Huntsman Radley and Cavalier Durgen, somewhere along Hearthglen Pass.",
    "Huntsman Radley and Cavalier Durgen held the Crusade together outside Hearthglen, and the scout wanted both dead along the Pass.",
    "The help had been more than could have been hoped for, the scout said. Here the air seemed to suck the will away, and the scout felt tired and no better for staying. How to infiltrate Hearthglen itself and report on the Crusade's strength was another matter. Payment came with thanks.",
    "Radley and Durgen were dead. The scout, weakening in the Plaguelands' air, paid and wondered how Hearthglen itself could ever be entered.", true)
q(6025, "Unfinished Business", "Western Plaguelands", 58, "hearthglen", 5,
    "After so much help already, the scout could not possibly ask for Hearthglen itself to be entered. The town was far more dangerous than the Pass, and there was no protection or information to offer. If the offer was real, though, the task was to enter the town and find a high place with a good view. From there the Crusade's numbers could be gauged and reported back, carefully.",
    "Hearthglen itself was the last step, the scout said, far more dangerous than the Pass. A high place with a view of the town would give the count.",
    "It was done, the scout said with thanks. The return to Elling, or rather Stormwind, would be as soon as possible. A coin was the least that could be given to such a credit to the people.",
    "The count of Hearthglen reached the scout, who slipped and said Elling before correcting it to Stormwind, paid, and wished luck.", true)
fallback("Unfinished Business", "Western Plaguelands", "hearthglen", "6004,6023,6025",
    "A weary Alliance scout near Hearthglen paid for help against the Scarlet Crusade's forces outside the town.",
    "The Scarlet Crusade's hold on Hearthglen was the scout's unfinished business.",
    "The scout's work against the Crusade at Hearthglen went on.",
    "Another step of the scout's mission at Hearthglen was done.")
q(6021, "Zaeldarr the Outcast", "Eastern Plaguelands", 55, "lights_hope", 3,
    "After all the trouble in the Plaguelands, Caretaker Alen could hardly believe there were thieves to worry about too. They were not normal thieves but troll thieves, and dead troll thieves at that. Led by a big dead troll named Zaeldarr the Outcast, they came at night to steal bodies from the pit below. They took them back to the Undercroft to the west, and Alen was sick to death of the mischief.",
    "Zaeldarr the Outcast and his dead troll thieves were robbing the pit below Light's Hope by night, and Caretaker Alen wanted him dead in the Undercroft.",
    "Great, Alen said, and he hoped the gang had been taught a lesson too.",
    "Alen was glad to hear Zaeldarr was dead, and hoped his gang had learned something.")
q(6028, "The Everlook Report", "Western Plaguelands", 52, "lights_hope", 2,
    "Gregor represented the Argent Dawn's interests to the local governance of Everlook. He wanted a responsible individual for a small but important matter, a progress report for Argent Officer Pureheart at Chillwind Camp. That lay a ways off, along the southern fringe of the Western Plaguelands. It would be a perfect introduction to his superior, he said, and might earn some work from her.",
    "Gregor's progress report from Everlook was for Argent Officer Pureheart at Chillwind Camp, a chance for an introduction.",
    "Very resourceful, Pureheart called Gregor. He had dealt with the Steamwheedle Cartel for some time and become an expert in the art of goblin negotiations. Goblins' loyalties lay with the largest purse, but they respected diplomacy, if only for the repeat customers. The Argent Dawn acknowledged the effort with thanks.",
    "Pureheart read Gregor's report with a word on goblin negotiations and the Dawn's thanks.", true)
q(6029, "The Everlook Report", "Western Plaguelands", 52, "lights_hope", 2,
    "Gregor represented the Argent Dawn's interests to the local governance of Everlook. He wanted a responsible individual for a small but important matter, a progress report for Argent Officer Garush at the Bulwark. That lay a ways off, on the western fringe of the Western Plaguelands, east of Tirisfal Glades. It would be a perfect introduction to his superior, he said, and might earn some work from him.",
    "Gregor's progress report from Everlook was for Argent Officer Garush at the Bulwark, a chance for an introduction.",
    "Resourceful for a human, Garush called Gregor. He had dealt with the Steamwheedle Cartel for some time and become an expert in the art of goblin negotiations. Goblins' loyalties lay with the largest purse, but they respected diplomacy, if only for the repeat customers. The Argent Dawn acknowledged the effort with thanks.",
    "Garush read Gregor's report, allowed the human was resourceful, and gave the Dawn's thanks.", true)
fallback("The Everlook Report", "Winterspring", "lights_hope", "6028,6029",
    "Gregor, the Argent Dawn's representative in Everlook, had a progress report for an Argent officer in the Plaguelands.",
    "A report from the Dawn's man in Everlook was bound for the Plaguelands.",
    "Gregor's report was delivered.",
    "The Everlook report reached the Argent Dawn.")
q(6030, "Duke Nicholas Zverenhoff", "Eastern Plaguelands", 52, "lights_hope", 2,
    "A recluse medium named Umbranse had provided the Argent Dawn with a literary masterpiece, Gregor said. It was quite possibly the largest collection of jibber-jabber he had ever seen written. Duke Nicholas Zverenhoff, one of the Dawn's most respected leaders, was a brilliant linguist. He was at Light's Hope Chapel, far in the east of the Eastern Plaguelands, and the writing was for him.",
    "Umbranse's jibber-jabber went from Gregor to Duke Nicholas Zverenhoff at Light's Hope, the Dawn's brilliant linguist.",
    "It was a very special tome, Zverenhoff said, though whether special meant unique and quite possibly illuminating remained to be seen. He wondered who in their right mind thought up a line like Ooooooo. Still, he had heard of this Umbranse, so it was not without merit, and he would do his best to decipher it.",
    "Zverenhoff took Umbranse's writing with doubt and a promise to try deciphering it, courtesy of the Dawn.")
q(6162, "A Husband's Last Battle", "Felwood", 51, "felwood", 3,
    "A widow's husband had traveled Felwood for the honor of their clan, doing battle against the Shadow Council and other corrupt atrocities. After escaping death many times, he had written that a druid had asked his help against a great befouled furbolg named Overlord Ror. The two were never heard from again. She wanted Ror's clawed hand, to make it pay for leaving her a widow. The creature was thought to be to the south, near the Ashenvale border.",
    "Overlord Ror, a befouled furbolg near the Ashenvale border, had cost a widow her husband, and she wanted his clawed hand.",
    "Following through on a word brought her honor, the widow said. Her husband had died in battle and would have been proud of that. Still, she could not rest until the creature that forced her to live alone had paid.",
    "Ror's clawed hand reached the widow, who said her husband would have been proud of his death, and that now she could rest.")
q(6164, "Augustus' Receipt Book", "Eastern Plaguelands", 55, "lights_hope", 2,
    "Augustus was ready for business, except that he could not open shop without his receipt ledger. He must have left it in town, in the room he had at the inn. Once he had it back, his prices would be insane.",
    "Augustus the shopkeeper could not trade without the ledger of receipts he had left in his old room at the inn.",
    "There it was, Augustus said, and he had forgotten how full it was. It was a glorious day, he said, stupendous and insanely good.",
    "The ledger came back to Augustus fuller than he remembered, and he called the day insanely good.")
q(9033, "Echoes of War", "Eastern Plaguelands", 60, "naxxramas", 5,
    "Five years had passed since the last war, they said at Light's Hope, and tens of thousands of lives had been lost. The threat had never been fully extinguished. Now the Lich King stirred again, and his yes-man Kel'Thuzad was amassing for another attack. That would not be allowed. Whoever proved willing to risk life and limb against the madness would have the combined might of the Dawn and the Crusade at call. The Scourge inside Naxxramas were to be destroyed.",
    "Kel'Thuzad was massing in Naxxramas for another attack. Light's Hope asked for proof of dedication inside the citadel before it offered the might of the Dawn and the Crusade.",
    "A job well done, came the word, and the reward would come through the services of the men and women at Light's Hope.",
    "Naxxramas had been entered and its Scourge fought, and Light's Hope opened its services in reward.")
q(9085, "Shadows of Doom", "Eastern Plaguelands", 60, "scourgeinvasion", 4,
    "Once the defenses of the Scourge summoning circles in the attacked zones were brought down, the acolytes protecting them could be confronted. In truth they were not men but shadows, some of the Lich King's most frightening creatures. The necrotic runes they carried would reveal them, and then they could be destroyed by magic or strength of arms.",
    "The acolytes at the Scourge's summoning circles were shadows, to be revealed with necrotic runes and destroyed.",
    "Excellent work, the Dawn said. With the shadows destroyed, it could only be a matter of time before the Lich King recalled his necropolises and left the land in peace.",
    "With the shadows destroyed, the Argent Dawn hoped the Lich King would soon recall his necropolises.")
q(9153, "Under the Shadow", "Eastern Plaguelands", 60, "scourgeinvasion", 4,
    "The floating necropolises of the Scourge plagued the lands of Horde and Alliance alike. Tanaris, the Blasted Lands, Winterspring and the Burning Steppes lay in the shadows of the flying fortresses, and only combined effort would turn them away. Magical circles in the invaded areas supported them. Destroying the mindless hordes around the circles would destroy their defenses.",
    "Necropolises hung over Tanaris, the Blasted Lands, Winterspring and the Burning Steppes, and the Argent Dawn wanted the hordes around their summoning circles destroyed.",
    "Well done, the Dawn said, and through such incremental defeats they would prevail against the renewed Scourge threat. After rest the fight had to go back to the front, lest the ground gained be lost. Special items would be offered in trade for more necrotic runes.",
    "The circles' defenders fell, and the Dawn spoke of prevailing by increments, of rest, and of items to be had for necrotic runes.")
q(9154, "Light's Hope Chapel", "Eastern Plaguelands", 60, "scourgeinvasion", 3,
    "The Scourge had returned in greater numbers than ever seen. Now the Argent Dawn was recruiting all willing and capable men and women to defend the lands. Anyone who shared the cause was to take a document to the Keeper of the Rolls at Light's Hope Chapel in the Eastern Plaguelands.",
    "The Argent Dawn's recruiting document was for the Keeper of the Rolls at Light's Hope Chapel.",
    "Others had answered the Argent Dawn's call for aid, said the Keeper of the Rolls, and so had this recruit. There was no time for training. The Dawn placed its faith in the recruit's ability to help throw back the Scourge.",
    "Another name went onto the Rolls, and the Keeper said there was no time to train, only to trust.")
q(9229, "The Fate of Ramaladni", "Eastern Plaguelands", 60, "naxxramas", 4,
    "Ramaladni had been a warrior of the Brotherhood, Korfax said, a pupil of Highlord Mograine before the Dawn existed. When news of Mograine's death reached him, hatred and anger took over. Rage and retribution, once they took the reins, made a man cease to be a man and become the emotions that controlled him. So Ramaladni, the spirit of retribution, had entered Naxxramas to exact vengeance and never returned. His fate was to be found inside.",
    "Korfax wanted to know what had become of Ramaladni, Mograine's old pupil, who had gone into Naxxramas for vengeance and never come out.",
    "It was his ring, Korfax said, but it was destroyed, and nothing else of Ramaladni had been found. He grimaced, for it did not bode well, though the ring might be salvageable.",
    "Only Ramaladni's ruined ring came out of Naxxramas. Korfax grimaced at what that meant, and thought the ring might be saved.")
q(9230, "Ramaladni's Icy Grasp", "Eastern Plaguelands", 60, "naxxramas", 4,
    "Fixing the band would be challenging, Korfax said. It had been made from the very runes that formed inside Scourge structures like Naxxramas. Other materials were needed too, but the frozen runes mattered most, and with them he would restore the ring to its former glory.",
    "Frozen runes from inside Naxxramas, with other materials, would let Korfax restore Ramaladni's ring.",
    "Ramaladni himself could not have done better, Korfax said, and handed over the ring as promised.",
    "The ring was whole again, and Korfax gave it over.")
q(9233, "Omarion's Handbook", "Eastern Plaguelands", 60, "naxxramas", 3,
    "The handbook was addressed to Wilhelm. If he was reading it, Omarion wrote, then Omarion had finally perished, and his dying thoughts had been of Wilhelm's ineptitude at tradeskills. The bearer was in even worse shape at crafting. Inside were the rest of Omarion's recipes, and Wilhelm was to make the bearer whatever was asked. Omarion was sure he would charge a hefty fee, being, after all, a bastard.",
    "Omarion's handbook, left to Wilhelm with insults, held the rest of his recipes and an order to craft for its bearer at a hefty fee.",
    "He must have been off his rocker when he wrote it, Wilhelm said, for the two of them had been thick as thieves. It opened new possibilities anyhow, and he could now craft more items for a small fee and material charges.",
    "Reading Omarion's insults, Wilhelm insisted they had been thick as thieves, and found he could now craft more, for a fee.")
q(9292, "Cracked Necrotic Crystal", "Stormwind City", 60, "scourgeinvasion", 3,
    "On the corpse of the fallen abomination lay a cracked crystal, slowly pulsing with necrotic energy.",
    "A cracked crystal pulsing with necrotic energy came off the body of an invading abomination.",
    "The crystal had come from one of the invading abominations. Word had already come of the necropolis base camps the Scourge were summoning, and its reader suspected they had wanted one inside Stormwind. It was good they had been unsuccessful.",
    "Stormwind had heard of the Scourge's base camps, and the one who read the crystal suspected they had wanted one inside the city. Their failure was welcome.")
for _, id in ipairs({105, 211, 5066, 5090, 5091, 5094, 5095, 5092, 5098, 5601, 5803, 5804, 5901, 5902, 6389, 5903, 5904, 6390, 5961, 6004, 6023, 6025, 6021, 6028, 6029, 6030, 6162, 6164, 9033, 9085, 9153, 9154, 9229, 9230, 9233, 9292}) do src(id) end

-- band5060 (2026-11-06): Un'Goro (the Circle's soil and morrowgrain both factions, Jonespyre's doubts,
-- Marshal Expeditions' bones and hive samples, Muigin and Larion, Oralius's good stuff, the Forsaken
-- slime samples, Spraggle's pterrordax, the apprentice's ash, Shizzle's flyer, super sticky tar).
q(3762, "Assisting Arch Druid Runetotem", "Thunder Bluff", 50, "morrowgrain", 2,
    "The Cenarion Circle in Thunder Bluff wanted seasoned adventurers for a vital research project. None other than Hamuul Runetotem was leading it, on the Elder Rise.",
    "Hamuul Runetotem was leading the Circle's research from the Elder Rise in Thunder Bluff, and seasoned hands were wanted.",
    "Glad of the interest, Hamuul said there was much to do. It would be a disservice to pretend the work was not dangerous, though danger seemed familiar to the newcomer.",
    "On the Elder Rise, Hamuul Runetotem warned that the research was dangerous and judged the newcomer used to it.", true)
q(3784, "Assisting Arch Druid Runetotem", "Thunder Bluff", 50, "morrowgrain", 2,
    "Seasoned adventurers were wanted for a vital research project of the Cenarion Circle in Thunder Bluff. It was led by Hamuul Runetotem himself, on the Elder Rise.",
    "The Circle's research in Thunder Bluff needed seasoned hands, and Hamuul Runetotem on the Elder Rise was leading it.",
    "Hamuul was glad of the interest and honest about the danger. From the look of the newcomer, he said, danger was nothing new.",
    "Much remained to do, Hamuul said on the Elder Rise, and none of it safe.", true)
fallback("Assisting Arch Druid Runetotem", "Thunder Bluff", "morrowgrain", "3762,3784",
    "The Cenarion Circle in Thunder Bluff wanted seasoned adventurers for research led by Hamuul Runetotem.",
    "Hamuul Runetotem on the Elder Rise was gathering help for the Circle's research.",
    "The referral to Hamuul Runetotem was made.",
    "Hamuul Runetotem received another volunteer.")
q(3763, "Assisting Arch Druid Staghelm", "Darnassus", 50, "morrowgrain", 2,
    "The Cenarion Circle in Darnassus was looking for seasoned adventurers for a vital research project. None other than Arch Druid Fandral Staghelm was leading it, in the Cenarion Enclave.",
    "Fandral Staghelm himself led the Circle's research in the Cenarion Enclave of Darnassus, and seasoned hands were wanted.",
    "Well now, Staghelm said. Told that he led the research himself, the newcomer had obviously come as quickly as possible. He expected attention the first time he gave the details, having no desire to repeat himself.",
    "In the Cenarion Enclave, Fandral Staghelm received the newcomer with a warning that he did not repeat himself.", true)
q(3789, "Assisting Arch Druid Staghelm", "Darnassus", 50, "morrowgrain", 2,
    "Seasoned adventurers were wanted for a vital research project of the Cenarion Circle in Darnassus. Arch Druid Fandral Staghelm himself was leading it, in the Cenarion Enclave.",
    "The Circle's research in Darnassus needed seasoned hands, and Fandral Staghelm in the Cenarion Enclave was leading it.",
    "Staghelm took it as given that anyone told he led the research had hurried. He would give the details only once.",
    "Attention the first time, Staghelm demanded in the Enclave; he had no desire to repeat himself.", true)
q(3790, "Assisting Arch Druid Staghelm", "Darnassus", 50, "morrowgrain", 2,
    "The Cenarion Circle in Darnassus wanted seasoned adventurers for a vital research project. Arch Druid Fandral Staghelm was spearheading it from the Cenarion Enclave.",
    "Word of Staghelm's research project sent another volunteer to the Cenarion Enclave in Darnassus.",
    "Obviously the newcomer had come as quickly as possible, Staghelm said, having heard who led the research. The details would be given once.",
    "Staghelm received the volunteer in the Enclave and warned against making him repeat anything.", true)
fallback("Assisting Arch Druid Staghelm", "Darnassus", "morrowgrain", "3763,3789,3790",
    "The Cenarion Circle in Darnassus wanted seasoned adventurers for research led by Arch Druid Fandral Staghelm.",
    "Fandral Staghelm in the Cenarion Enclave was gathering help for the Circle's research.",
    "The referral to Fandral Staghelm was made.",
    "Fandral Staghelm received another volunteer.")
q(3761, "Un'Goro Soil", "Thunder Bluff", 50, "morrowgrain", 3,
    "The soil of Un'Goro Crater was reportedly enriched with potent magical qualities. Large quantities were wanted for the Cenarion Circle's study. Rich soil stuck out in piles here and there, and some of the beasts carried usable samples. All of it went to Ghede outside, the tauren barking orders by the piles of dirt. He meant well, so long as he was not riled.",
    "Hamuul wanted Un'Goro's magical soil in quantity, delivered to Ghede and his piles of dirt outside.",
    "Ghede complained, with heavy sarcasm, that no effort had been made to help him unload the soil onto the piles. If the Great Spirits had wanted it done, he said, they would have miracled it up there. Arch Druid Runetotem wanted another word, and a journeyman's skill in herbalism would help with the next task.",
    "The soil reached Ghede, who grumbled that no help came with the unloading. Runetotem had another task, easier for anyone with a little herbalism.", true)
q(3764, "Un'Goro Soil", "Darnassus", 50, "morrowgrain", 3,
    "The soil of Un'Goro Crater was reportedly enriched with potent magical qualities, and Staghelm wanted facts sorted from falsehoods. Quality samples were needed in quantity. Anyone who thought collection beneath them would not endear themselves to him or the Circle. The samples went to Jenal, who handled the logistics and was no doubt wasting time behind the tree outside.",
    "Staghelm wanted Un'Goro's soil in quantity, and Jenal behind the tree outside the Enclave handled the piles.",
    "Jenal took the precious cargo, a burden no doubt, not unlike the burden of being a visionary. The honorarium the Arch Druid had dictated was paid. Staghelm wanted another word, and a journeyman's skill in herbalism would help with the next task.",
    "Jenal took the soil with a remark about the burdens of visionaries and paid the Arch Druid's honorarium. Staghelm had more work, easier with a little herbalism.", true)
fallback("Un'Goro Soil", "Un'Goro Crater", "morrowgrain", "3761,3764",
    "The Cenarion Circle wanted the magical soil of Un'Goro Crater in large quantities for its research.",
    "Piles of Un'Goro's rich soil were wanted by the Circle's researchers in the capitals.",
    "The soil of Un'Goro was delivered to the Circle.",
    "The Circle's soil collection went on.")
q(3781, "Morrowgrain Research", "Darnassus", 50, "morrowgrain", 3,
    "With what the Circle called an Evergreen Pouch, Tharlendris seeds had been cultivated in soil from Un'Goro Crater. They blossomed into an array of random, potent herbs. One result was morrowgrain, a mysterious herb little understood, and Staghelm intended to unravel the mystery. A voucher for Mathrengyl downstairs would supply the first seeds, and more could be bought if they ran out.",
    "Staghelm's voucher bought Tharlendris seeds from Mathrengyl downstairs, the start of growing morrowgrain in Un'Goro soil.",
    "The voucher was good for twenty packets of seeds, Mathrengyl said, with more available. Tharlendris seeds were costly to produce in numbers, so the Circle asked its helpers to offset the cost. Those who returned with morrowgrain found the Arch Druid's reward well worth it.",
    "Mathrengyl handed over twenty packets of seeds against the voucher, and explained why the next ones would cost.", true)
q(3782, "Morrowgrain Research", "Thunder Bluff", 50, "morrowgrain", 3,
    "With what the Circle called an Evergreen Pouch, Tharlendris seeds had been cultivated in soil from Un'Goro Crater. They blossomed into an array of random, potent herbs. One result was morrowgrain, a mysterious herb little understood. Hamuul very much hoped to unravel the mystery for the Circle. A voucher for his daughter Bashana would supply the first seeds, and more could be bought if they ran out.",
    "Hamuul's voucher bought Tharlendris seeds from his daughter Bashana, the start of growing morrowgrain in Un'Goro soil.",
    "The voucher was good for twenty packets of seeds, Bashana said, with more for sale. Tharlendris seeds were costly to produce in numbers, so the Circle asked its helpers to offset the cost. Those who returned with morrowgrain found the Arch Druid's reward well worth it.",
    "Bashana handed over twenty packets of seeds against the voucher, and explained why the next ones would cost.", true)
q(3785, "Morrowgrain Research", "Darnassus", 50, "morrowgrain", 3,
    "The Evergreen Pouch was for use with the Tharlendris seeds, with Un'Goro soil as fertilizer. With everything in hand, the pouch took care of the rest. Morrowgrain was to come back to the enclave. A very busy man, the Arch Druid did not need disturbing with every batch.",
    "Morrowgrain grown in the Evergreen Pouch went back to the Cenarion Enclave, never to the busy Arch Druid directly.",
    "Well done, came the word in the enclave. The morrowgrain would go to the Arch Druid when he had need of it, with a token of the Circle's appreciation meanwhile. Morrowgrain was always needed, and more was welcome.",
    "The morrowgrain was taken in at the enclave with a token of thanks and a standing request for more.", true)
q(3786, "Morrowgrain Research", "Thunder Bluff", 50, "morrowgrain", 3,
    "The Evergreen Pouch was for use with the Tharlendris seeds, with Un'Goro soil as fertilizer. With everything in hand, the pouch took care of the rest. Morrowgrain was to come back to the Elder Rise, not to the Arch Druid. He would be very busy with the research and his multitude of concerns.",
    "Morrowgrain grown in the Evergreen Pouch went back to the Elder Rise, never to the busy Arch Druid directly.",
    "Well done, came the word on the Elder Rise. The morrowgrain would go to the Arch Druid when he had need of it, with a token of the Circle's appreciation meanwhile. For now, the need was constant.",
    "The morrowgrain was taken in on the Elder Rise with a token of thanks and a standing request for more.", true)
fallback("Morrowgrain Research", "Un'Goro Crater", "morrowgrain", "3781,3782,3785,3786",
    "The Cenarion Circle grew a mysterious herb, morrowgrain, from Tharlendris seeds in Un'Goro soil, and wanted more of it.",
    "Morrowgrain, grown in an Evergreen Pouch from Un'Goro soil, was the Circle's research, and it never had enough.",
    "More morrowgrain reached the Circle.",
    "The morrowgrain research went on.")
q(3787, "Jonespyre's Request", "Feralas", 50, "morrowgrain", 3,
    "A colleague wished to speak about the research being done with the Cenarion Circle. He was a druid named Quintis Jonespyre, at Feathermoon Stronghold in Feralas. Morrowgrain was his subject, and he very much wanted the talk kept from the ears of the Arch Druid.",
    "Quintis Jonespyre at Feathermoon wanted a quiet word about morrowgrain, away from the Arch Druid's ears.",
    "Introducing himself as a druid and humble servant of Malfurion and the Cenarion Circle, Quintis Jonespyre named his colleagues. He, General Shandris Feathermoon and the Protectorate wanted to talk about the work being done for Fandral Staghelm in Darnassus. It was to stay between them.",
    "At Feathermoon, Jonespyre spoke for himself, Shandris Feathermoon and the Protectorate. What followed about Staghelm's morrowgrain was to stay private.", true)
q(3788, "Jonespyre's Request", "Feralas", 50, "morrowgrain", 3,
    "A colleague at Feathermoon Stronghold, a druid named Quintis Jonespyre, wished to confer about the morrowgrain research. He very much wanted it kept from the ears of the Arch Druid.",
    "Jonespyre, a druid at Feathermoon, wanted a word about morrowgrain that the Arch Druid would not hear of.",
    "Giving his name, Jonespyre called himself a humble servant of Malfurion and the Circle. His colleagues were General Shandris Feathermoon and the Protectorate. They wanted to talk about the work for Fandral Staghelm, if it stayed between them.",
    "The talk at Feathermoon began with Jonespyre's request for secrecy and the names of Shandris Feathermoon and the Protectorate.", true)
fallback("Jonespyre's Request", "Feralas", "morrowgrain", "3787,3788",
    "Quintis Jonespyre, a druid at Feathermoon Stronghold, wanted a private word about the Circle's morrowgrain.",
    "A druid at Feathermoon had doubts about the morrowgrain research and wanted them kept from the Arch Druid.",
    "Jonespyre was met at Feathermoon.",
    "The quiet talk about morrowgrain began at Feathermoon.")
q(3791, "The Mystery of Morrowgrain", "Feralas", 50, "morrowgrain", 4,
    "Jonespyre spoke frankly about the Arch Druid in Darnassus. Staghelm was using the Cenarion Circle's name and resources to procure vast amounts of morrowgrain, and Jonespyre was concerned. Curses were his specialty as a researcher. He had heard that morrowgrain could exude qualities like herbs used in primitive curses. Ten morrowgrain would let him start learning more.",
    "Curses were Jonespyre's specialty, and he wanted ten morrowgrain to study. He also wanted to know why Staghelm wanted so much of it.",
    "The morrowgrain made Jonespyre feel weird, and he asked in Elune's name what Staghelm was up to with them. His research would take a while and need more. He might look into alchemical uses meanwhile, though he was uncomfortable even being near the stuff.",
    "Jonespyre said the morrowgrain made him feel weird, wondered aloud what Staghelm wanted them for, and promised a long study.")
q(3882, "Roll the Bones", "Un'Goro Crater", 51, "ungoro", 2,
    "Being chief digger for Marshal Expeditions did not mean liking digging, though worse things did not leap to mind. The dig was supposed to be in Terror Run, a fantastic name, for dead stegodons and diemetradons. Plenty of live ones were there too. Wil and Hol still wanted bones to study the death trap. Between friends, bones from live ones would do just as well.",
    "The chief digger of Marshal Expeditions needed dinosaur bones from Terror Run for Wil and Hol. Whether the owners were dead first did not much matter.",
    "Excellent, the digger said. Then came a loud announcement that the bones had been dug out of the ground and no native beast had been hurt. Whether that was true, the digger did not want to know, and paid to keep lips sealed.",
    "Bones in hand, the digger announced for anyone listening that no native beasts had been hurt, then paid for silence on the point.")
q(3883, "Alien Ecology", "Un'Goro Crater", 52, "ungoro", 3,
    "A setback did not mean research must stop. The Marshal Expedition had been investigating the Gorishi insects in the south of the crater before ending up at the refuge. Their presence was alien to Un'Goro's ecology, and the reason was wanted. Larval hatcheries had to lie somewhere in the hive network, marked by hanging larval spawns. A sample of the hive wall near one was to go into a vial.",
    "The Gorishi did not belong in Un'Goro's ecology. A sample of hive wall from near one of their larval hatcheries was wanted.",
    "Yes, the sample would do nicely, came the answer. Being virtually stranded in a savage land limited what could be given. Still, the research would not have been possible without the help.",
    "Back at the refuge, the hive sample drew thanks limited by what a stranded expedition could spare.")
q(4141, "Muigin and Larion", "Un'Goro Crater", 52, "muigin", 2,
    "It was Larion's fault they were there, Muigin said. He had warned that they were going the wrong way, Larion would not listen, and now Larion was the one not speaking. Until Larion changed his mind there was fun to be had. The strange plant-like creatures around were nothing but trouble. Properly trained, Muigin thought, they might obey commands, and he wanted samples to study.",
    "Muigin wanted samples of Un'Goro's plant creatures, to train them on his sulking companion Larion.",
    "Hopefully the plants had not given too much trouble, Muigin said, since he steered clear of them himself. He had tried jumping over one and been attacked, and plants just should not act that way.",
    "The samples reached Muigin, who had once been attacked trying to jump over one of the plants. He held strong views on how plants should behave.")
q(4142, "A Visit to Gregan", "Feralas", 52, "muigin", 2,
    "Muigin was not sure what to make of it. The plants seemed to have some minimal intelligence, and he was no expert, but he knew one. A buddy of his, Gregan Brewspewer, lived out in the wilderness of northern Feralas, not being the type for a big city.",
    "Muigin sent the question of the plants' intelligence to Gregan Brewspewer, his expert friend in the wilds of northern Feralas.",
    "Bloodpetal, Gregan said. The plan had better be explained first, and then he would say whether he could help.",
    "Gregan heard the word bloodpetal and asked for the whole plan before promising anything.")
q(4143, "Haze of Evil", "Un'Goro Crater", 52, "muigin", 3,
    "Gregan had never seen plants like that in his travels and thought he might visit the crater. He knew just the thing Muigin was looking for, Atal'ai haze. It was horrid stuff and hard to collect, but just what was needed to control the little monsters. Deep lurkers, murk worms and oozes in the temple of Atal'Hakkar, in the Swamp of Sorrows, carried it.",
    "Atal'ai haze from the lurkers, worms and oozes of the temple of Atal'Hakkar was Gregan's answer for controlling Muigin's plants.",
    "Muigin was hesitant to touch the stuff, but if Gregan said it would work, he would give it a try.",
    "The haze reached Muigin, who did not like touching it and trusted Gregan anyway.")
q(4145, "Larion and Muigin", "Un'Goro Crater", 52, "muigin", 2,
    "It was Muigin's fault, Larion said. He had known the way, but Muigin had insisted on a shortcut, and here they were. Worse, Muigin kept sending his crazy plant pests to annoy him. Larion was too angry to speak to him any time soon, but the pests were too much. Limiting the supply came first, so bloodpetals were to be hunted.",
    "Larion, not speaking to Muigin, wanted the bloodpetal pests his companion kept sending thinned out.",
    "Thanks for the help, Larion said, but he had some bad news.",
    "Thinning the bloodpetals earned Larion's thanks and a warning of bad news.")
q(4147, "Marvon's Workshop", "The Barrens", 52, "muigin", 2,
    "Larion had spied on Muigin and found him actually growing the things. The answer was not to go and talk to him, whatever anyone thought. It was to fight back. Larion's friend Marvon had a workshop in Ratchet and would surely build some gadget.",
    "Larion wanted a gadget against Muigin's plants from his friend Marvon's workshop in Ratchet, rather than a conversation.",
    "Marvon had been gone a long time, his apprentice said, off to Tanaris to study the ancient troll ruins. The apprentice asked what was needed.",
    "At the workshop in Ratchet, Marvon was long gone to Tanaris and its troll ruins. His apprentice heard the need out.")
q(4146, "Zapper Fuel", "Un'Goro Crater", 52, "muigin", 3,
    "Luck was in, Marvon's apprentice said. With Marvon gone, the apprentice had been working on experiments, one of them a short-range bug zapper. A few adjustments would make it great for ridding oneself of bloodpetal pests. One prototype could be had, but the fuel had to be collected. The zapper ran on Atal'ai haze from the deep lurkers, murk worms and oozes of the temple of Atal'Hakkar.",
    "Marvon's apprentice lent a bug zapper prototype for Larion's bloodpetals, to be fueled with Atal'ai haze from the temple of Atal'Hakkar.",
    "So Marvon was not around, Larion said. All the same, he wanted to see what had been brought.",
    "Larion heard that Marvon was away and asked to see the zapper anyway.")
q(4286, "The Good Stuff", "Blackrock Depths", 56, "blackrock", 2,
    "Captain Winky told Oralius that the Dark Irons in the Depths had all the good stuff. Asked to confirm it, Winky answered in Oralius's best pirate impersonation. Samples of the good stuff were to be brought back from inside. Get in there, Oralius said, and shake the moneymaker.",
    "Oralius wanted samples of the good stuff the Dark Irons kept in Blackrock Depths, on Captain Winky's authority.",
    "Rummaging through the mountainous pile of fanny packs, Oralius declared it wonderful. He stuck his large nose in for a whiff and called it delicious. There were plenty of goodies to go around, and one was for the taking.",
    "The fanny packs delighted Oralius, who sniffed the pile and offered one from it.")
q(4293, "A Sample of Slime...", "Felwood", 52, "slimes", 2,
    "Felwood was a forest far north of the Barrens, farther even than Ashenvale. Its slimes lived around pools of water blessed by the touch of Fel. The researcher said the Scourge had decimated the area with infernals and other demonic magics. During those attacks, the slimes had supposedly crept up through the earth. Samples would make a control group for the tests to come.",
    "A Forsaken researcher wanted Felwood's slimes, born of the infernals' attacks, as a control group for tests on other samples.",
    "Excellent, the researcher said, the samples would do nicely and were very interesting. Lady Sylvanas's hunch was beginning to seem not only correct but more insightful than even she could have predicted. The way the slimes reacted with the compounds called for further investigation.",
    "In the researcher's compounds, the Felwood slimes reacted in ways that made Sylvanas's hunch look better than she knew.")
q(4294, "... and a Batch of Ooze", "Un'Goro Crater", 56, "slimes", 3,
    "Un'Goro Crater, near the Tanaris desert, was a magnificent place, lush, vibrant and full of creatures and plant life. Word said it was completely untainted by outside hands, its secrets only now being discovered. The researcher wanted its slimes or oozes tested, to see how such creatures had evolved if they were truly uncorrupt.",
    "The Forsaken researcher wanted oozes from untouched Un'Goro, to see how such creatures grew where nothing had corrupted them.",
    "Truly amazing, the researcher said, for Un'Goro held many more secrets than expected. The samples were remarkably pure, elemental in nature but something more. They brought to mind the Old Gods, whose traces had been found throughout Azeroth. The creatures might be related to them somehow. Further tests would follow.",
    "Un'Goro's oozes amazed the researcher with their purity, brought the Old Gods to mind, and earned more tests.")
q(4501, "Beware of Pterrordax", "Un'Goro Crater", 55, "ungoro", 2,
    "A notice wanted a skilled fighter against the pterrordax of Un'Goro Crater, whose growing numbers menaced travelers. Ten pterrordax and fifteen frenzied pterrordax were to be slain. The reward would come from Spraggle Frock.",
    "A sign warned of pterrordax and offered a reward through Spraggle Frock for thinning them.",
    "Spraggle was absolutely terrified of the pterrordax, and thanked the one who had thinned them. Now she might feel safe enough to venture out of Marshal's Refuge.",
    "With the pterrordax fewer, Spraggle thought she might dare to leave Marshal's Refuge.")
q(4502, "Volcanic Activity", "Un'Goro Crater", 55, "ungoro", 2,
    "Marvon's apprentice had learned much, but with Marvon gone so long, it was time for experiments of the apprentice's own. Reading about Un'Goro Crater had turned up strange volcanic activity in its middle. A lot could be learned from the ash of the elementals there, if anyone was going that way.",
    "Ash from the fire elementals in the middle of Un'Goro was wanted by Marvon's apprentice, for experiments of the apprentice's own.",
    "The samples would be perfect, the apprentice said. Whoever found them would be the first to hear the results.",
    "The volcano's ash went into the apprentice's studies, with a promise of first word of any findings.")
q(4503, "Shizzle's Flyer", "Un'Goro Crater", 51, "ungoro", 2,
    "Shizzle was making a flying machine. Stranded and horrible at finding the way around, Shizzle needed a way back to Gadgetzan. Gryphons and wind riders were out, since those beasts were terrifying. Only the wings were left to build. Webby scales from the pterrordax and diemetradon would be perfect, if someone tougher fetched them.",
    "Webby scales from pterrordax and diemetradon were the last thing Shizzle's flying machine needed to get home to Gadgetzan.",
    "The scales were perfect, Shizzle said; the flyer would get off the ground with them for sure.",
    "Shizzle took the scales for the wings and was sure the flyer would fly now.")
q(4504, "Super Sticky", "Un'Goro Crater", 54, "ungoro", 2,
    "Tran'rek was always looking for a quick way to earn a gold. A cut of the profit from the newest idea was on offer. Tar from the tar pits of northern Un'Goro was wanted, though not just any tar. It had to come from the creatures around the pits. Their skin carried chlorophyll, and mixed with tar it made a super sticky glue.",
    "Tar from the creatures around Un'Goro's northern tar pits, extra sticky with their chlorophyll, was the raw material of Tran'rek's newest scheme.",
    "Just the stuff, Tran'rek said, and then found both hands stuck together. Maybe it had not been such a good idea. Then came the real money, a super sticky tar remover.",
    "Tran'rek's hands stuck together on the first handful of tar. A second scheme was born on the spot, tar remover.")
for _, id in ipairs({3762, 3784, 3763, 3789, 3790, 3761, 3764, 3781, 3782, 3785, 3786, 3787, 3788, 3791, 3882, 3883, 4141, 4142, 4143, 4145, 4147, 4146, 4286, 4293, 4294, 4501, 4502, 4503, 4504}) do src(id) end

-- Forever additions carry the Forever label in the compendium (fact-check
-- request 2026-11-05; explicit list, never inferred from the ID range).
for _, id in ipairs({94913, 94914}) do
    assert(P.questIDs[id], "Forever label for a missing stage " .. id).setting = "Forever"
end
A.Lore.RegisterStoryPack("world_journeys", P)
