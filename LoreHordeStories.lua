local _, A = ...
-- Curated against the client's captured quest text. Completion prose belongs
-- only to the recorded stage; old title-only records use restrained fallbacks.
-- The file named corpus_vanilla_quests.txt also contains Forever additions.
-- corpus_forever_new_quests.txt was empty at the time of this review.
-- Coverage: 272 curated IDs, 194 title contexts, eight regional expansions. The
-- tests derive these counts. This is not an exhaustive quest database.
-- Gaps: uncaptured Forever branches, most repeatable errands and referral-only
-- shaman captures (#96243, #98517) keep conservative title/general context.
-- No later-expansion Echo Isles reclamation or presumed Zephras rescue is used.
-- Silverpine now has exact scout, Arugal, Fenris and Deliah stages, including
-- Forever 98298; Hillsbrad has the seven executor campaign stages. Ambermill,
-- Hillsbrad's elixirs and most later outdoor regions remain coverage gaps.
-- Stonetalon's spirits/toxin route and Thousand Needles' camps, escorts and
-- Arikara extend the early Kalimdor coverage. Region-by-region review:
-- StorageInvestigation/cj-leveling-stage-research-20261012.txt.
local V = "StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt"
local F = "StorageInvestigation/journal-voice/part1_corpus.txt"
local pack = {sources = {V, F}, quests = {}, questIDs = {}, zones = {}, threads = {
    horde_narache = "daily life in Mulgore",
    horde_rites = "the Rites of the Earthmother",
    horde_wells = "the wells of Mulgore",
    horde_venture = "the Venture Company's mines",
    horde_mulgoreland = "the contested ground of Mulgore",
    horde_trials = "the Valley of Trials",
    horde_blade = "the Burning Blade in Durotar",
    horde_darkspear = "the troubles of the Darkspear",
    horde_roads = "the Horde's supply roads",
    horde_hunts = "the hunting lessons of the Barrens",
    horde_oases = "the mystery of the Barrens oases",
    horde_kolkar = "the Kolkar leaders of the Barrens",
    horde_ratchet = "Ratchet's harbor and workshops",
    horde_trade = "provisions for the Horde's towns",
    horde_scarlet = "the Scarlet forces in Tirisfal",
    horde_forsaken = "the needs of the Forsaken",
    horde_apothecary = "the apothecaries' research",
    shaman_earth = "the call of earth",
    shaman_fire = "the call of fire",
    shaman_water = "the call of water",
    shaman_air = "the call of air",
    forever_grove = "the needs of Thendal Grove",
    forever_cult = "the Al'Aketh threat",
    forever_winds = "the fading magic of Zephras",
}}
local function Q(id, title, zone, level, thread, why1, why2, after1, after2, source, stage)
    local s = {title = title, zone = zone, level = level, thread = thread,
        threadLabel = pack.threads[thread], importance = 3, covers = false,
        why = {why1, why2}, after = {after1, after2}, source = {(source or V) .. " #" .. id}}
    pack.questIDs[id] = s
    if not stage then pack.quests[title] = s end
    return s
end
local function Fallback(title, thread, why1, why2, after1, after2, refs)
    pack.quests[title] = {thread = thread, threadLabel = pack.threads[thread], importance = 3,
        covers = false, zone = false, level = false,
        why = {why1, why2}, after = {after1, after2}, source = refs}
end

-- Mulgore: daily provision, rites, water and the passage into Thunder Bluff.
Q(747, "The Hunt Begins", "Mulgore", 2, "horde_narache",
    "Meat and feathers had run short at {p:Camp Narache}.",
    "The plainstriders on Red Cloud Mesa supplied both food and material for clothing.",
    "The plainstrider provisions replenished the village's stores.",
    "Grull Hawkwind received meat and feathers for the people of Narache.")
Q(750, "The Hunt Continues", "Mulgore", 3, "horde_narache",
    "The children needed clothing, and the tents at Narache needed mending.",
    "Mountain cougar pelts had practical value to a village living from the plains.",
    "Fresh pelts supplied the tribe's clothing and repairs.",
    "Grull Hawkwind had the cougar hides needed by Camp Narache.")
Q(752, "A Humble Task", "Mulgore", 2, "horde_narache",
    "Greatmother Hawkwind had been away at the well longer than the chief expected.",
    "Tribal business kept Chief Hawkwind in Narache while his mother fetched water.",
    "Greatmother Hawkwind was found at the well.",
    "The chief's concern led to Greatmother Hawkwind, still attending to the village's water.", nil, true)
Q(753, "A Humble Task", "Mulgore", 3, "horde_narache",
    "A filled water pitcher still needed carrying from the well to Narache.",
    "Greatmother Hawkwind had a small errand for the chief's household.",
    "The water pitcher reached Chief Hawkwind at his mother's request.",
    "A pitcher of water returned to Narache, and the chief acknowledged the help.", nil, true)
Fallback("A Humble Task", "horde_narache",
    "Fetching water was part of the shared work that sustained Narache.",
    "The Hawkwind household depended on the same everyday work as the rest of the village.",
    "A small piece of Narache's daily work had received attention.",
    "Service to the village had taken a quieter form than hunting.", {V .. " #752, #753"})
Q(780, "The Battleboars", "Mulgore", 4, "horde_narache",
    "The Bristlebacks trained battleboars near the tribe's hunting grounds.",
    "Brambleblade Ravine held aggressive boars as well as the quilboar who trained them.",
    "The battleboar meat supplied stew for the village's young.",
    "The hunt reduced the boar threat and brought back food for Narache.")
Q(755, "Rites of the Earthmother", "Mulgore", 3, "horde_rites",
    "Chief Hawkwind directed the beginning of the three Rites of the Earthmother.",
    "Seer Graytongue kept an abode in the hills south of Camp Narache.",
    "Seer Graytongue received Chief Hawkwind's referral.",
    "The first rite had reached the seer who would explain its demands.", nil, true)
Q(757, "Rite of Strength", "Mulgore", 4, "horde_rites",
    "Bristlebacks from Brambleblade Ravine ambushed hunting parties and stole from Narache.",
    "The first of the Earthmother's rites called for proof against the tribe's raiders.",
    "The Bristleback belts supplied proof, and the first rite was passed.",
    "Chief Hawkwind accepted the evidence of strength against the Bristlebacks.")
Q(763, "Rites of the Earthmother", "Mulgore", 5, "horde_rites",
    "Baine Bloodhoof continued the rites at {p:Bloodhoof Village}.",
    "Chief Hawkwind's carved totem served as an introduction beyond Narache.",
    "Baine recognized Hawkwind's carving and received his message.",
    "The carved totem reached Bloodhoof Village, where the remaining rites awaited.", nil, true)
Fallback("Rites of the Earthmother", "horde_rites",
    "The rites linked Narache's teaching with the elders of Thunder Bluff.",
    "Strength, vision and wisdom each had a place in the tauren rites.",
    "Another part of the rites' work had been attended to.",
    "The recorded errand belonged to the path toward the elders' recognition.", {V .. " #755, #763, #776"})
Q(767, "Rite of Vision", "Mulgore", 6, "horde_rites",
    "Zarlman Two-Moons was the spiritual leader entrusted with the Rite of Vision.",
    "The rite began with instruction in Bloodhoof Village.",
    "Zarlman received the applicant for the Rite of Vision.",
    "The next stage of the rites reached Zarlman Two-Moons.", nil, true)
Q(771, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "Well stones and fallen ambercorn were needed for the Water of the Seers.",
    "Zarlman's brew drew its ingredients from Mulgore's wells and trees.",
    "Zarlman received the ingredients and could prepare the Water of the Seers.",
    "The gathered stones and ambercorn made the vision brew possible.", nil, true)
Q(772, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "The Water of the Seers was taken beside the tribal fire.",
    "Zarlman's rite called for a vision to be followed from the village fire.",
    "The Rite of Vision was passed.",
    "The vision's guidance brought that part of the rites to completion.", nil, true)
Fallback("Rite of Vision", "horde_rites",
    "Zarlman Two-Moons tended the teaching and preparations of the Rite of Vision.",
    "The Water of the Seers had a place in Mulgore's rites.",
    "The work belonged to the Rite of Vision.",
    "Another recorded part of the vision rite was complete.", {V .. " #767, #771, #772"})
Q(773, "Rite of Wisdom", "Mulgore", 10, "horde_rites",
    "The ancestral spirits at Red Rocks remembered the founding and defense of Thunder Bluff.",
    "Red Rocks was the sacred ground where the Rite of Wisdom ended.",
    "The ancestral spirit granted a blessing and recognized the Rite of Wisdom.",
    "The duty of protecting Thunder Bluff passed onward with the ancestral blessing.")
Q(775, "Journey into Thunder Bluff", "Thunder Bluff", 10, "horde_rites",
    "Cairne Bloodhoof waited atop Thunder Bluff's highest mesa.",
    "The introduction to Cairne brought the rites' business into the city above Mulgore.",
    "Cairne welcomed the arrival at his home above the plains.",
    "The journey reached Cairne Bloodhoof in Thunder Bluff.")
Q(776, "Rites of the Earthmother", "Thunder Bluff", 14, "horde_rites",
    "Cairne asked for the horn of Arra'chea as proof of hunting skill.",
    "The great kodo on Mulgore's plains offered a further test after the rites.",
    "Arra'chea's horn reached Cairne, who arranged to collect the hide and meat.",
    "The kodo hunt supplied proof for Cairne and provisions for the people.", nil, true)
Q(748, "Poison Water", "Mulgore", 5, "horde_wells",
    "Goblins and their servants had poisoned Mulgore's sacred wells.",
    "The Winterhoof well needed a cleansing totem made from wolf paws and plainstrider talons.",
    "The gathered paws and talons supplied the first cleansing totem's ingredients.",
    "The materials were ready for a totem; the poisoned well still needed its ritual.")
Q(754, "Winterhoof Cleansing", "Mulgore", 6, "horde_wells",
    "The Winterhoof totem had to be carried to the guarded well.",
    "Winterhoof water had been unusable while the goblins' taint remained.",
    "Beasts were already drinking from the cleansed Winterhoof well.",
    "The Winterhoof ritual restored a source of drinking water to the plains.")
Q(756, "Thunderhorn Totem", "Mulgore", 7, "horde_wells",
    "The Thunderhorn well grew more tainted while its totem awaited materials.",
    "Prairie stalker and flatland cougar claws were needed for the next cleansing totem.",
    "The predator claws supplied the Thunderhorn totem's preparation.",
    "The materials for cleansing Thunderhorn were gathered, with the ritual still ahead.")
Q(758, "Thunderhorn Cleansing", "Mulgore", 8, "horde_wells",
    "The Thunderhorn Water Well lay north of Bloodhoof Village.",
    "A prepared totem could carry the cleansing ritual to the Thunderhorn well.",
    "The Thunderhorn well was cleansed.",
    "The ritual removed the taint from Thunderhorn's water.")
Q(759, "Wildmane Totem", "Mulgore", 10, "horde_wells",
    "Prairie wolf alphas roamed near the base of Thunder Bluff.",
    "Their teeth were needed for the Wildmane cleansing totem.",
    "The alpha teeth supplied the Wildmane totem's materials.",
    "The hunt made preparation of the last cleansing totem possible.")
Q(760, "Wildmane Cleansing", "Mulgore", 10, "horde_wells",
    "The Wildmane well north of Thunder Bluff remained poisoned.",
    "The prepared Wildmane totem had one remaining well to cleanse.",
    "Clean water flowed at Wildmane again.",
    "The Wildmane ritual removed the poison from the last well in the cleansing work.")
Q(749, "The Ravaged Caravan", "Mulgore", 8, "horde_venture",
    "Venture Company salvagers had returned to burned wagons beside Stonebull Lake.",
    "Supply crates had survived the attack on the Venture Company caravan.",
    "The examined crate bore the mark of the Venture Company Mining Division.",
    "The crate's markings identified cargo intended for a mining processing plant.", nil, true)
Q(751, "The Ravaged Caravan", "Mulgore", 8, "horde_venture",
    "Ore and papers remained inside the caravan's supply crate.",
    "The burned caravan still held evidence of the company's mining work.",
    "The recovered papers confirmed the Venture Company's operations in Mulgore.",
    "The caravan's documents gave the outrunners evidence of the company's plans.", nil, true)
Fallback("The Ravaged Caravan", "horde_venture",
    "The Venture Company's burned caravan still held clues beside Stonebull Lake.",
    "Salvagers lingered around the mining company's abandoned cargo.",
    "The caravan investigation added evidence about the mining operation.",
    "The ruined wagons had yielded something of the company's business.", {V .. " #749, #751"})
Q(764, "The Venture Co.", "Mulgore", 10, "horde_venture",
    "The Venture Company mined Mulgore despite having been refused mining rights.",
    "A mine northeast of the ruined caravan lay behind the growing company presence.",
    "The company's workers met armed resistance to the unauthorized mining.",
    "The attack challenged the Venture Company's assumption that Mulgore could be taken without resistance.")
Q(765, "Supervisor Fizsprocket", "Mulgore", 12, "horde_venture",
    "The caravan documents implicated Supervisor Fizsprocket in plans to drive the tauren from their land.",
    "Fizsprocket directed the Venture Company's work from its mine.",
    "Fizsprocket was dead, and his clipboard was available for examination.",
    "The supervisor's personal papers offered further evidence of the company's intentions.")
Q(744, "Preparation for Ceremony", "Mulgore", 11, "horde_narache",
    "A headdress needed azure and bronze feathers before a brother's ceremony before Cairne.",
    "Leather straps were already being tanned while feathers remained to be gathered.",
    "The feathers supplied the headdress's unfinished design.",
    "The ceremony's gift was closer to completion, with its feathers delivered.")
Q(743, "Dangers of the Windfury", "Mulgore", 8, "horde_narache",
    "Windfury harpies nested along Mulgore's mountain edges away from the road.",
    "Ruul offered a test against the harpies before the journey beyond Mulgore.",
    "Ruul accepted the completed harpy test as preparation for travel.",
    "The fighting against the Windfury met Ruul's challenge.")
Q(745, "Sharing the Land", "Mulgore", 8, "horde_mulgoreland",
    "Palemane gnolls hunted Mulgore's wildlife without restraint.",
    "Attempts to communicate with the gnolls south of Bloodhoof had failed.",
    "The response to the Palemane hunting threat was acknowledged.",
    "The task ended with a reminder of responsibility toward the land and its creatures.")
Q(746, "Dwarven Digging", "Mulgore", 8, "horde_mulgoreland",
    "A dwarven dig threatened to disturb Mulgore's kodos.",
    "The excavation's tools could be smashed at a forge to interrupt the digging.",
    "The broken tools were returned as proof of interference with the excavation.",
    "The dwarves lost digging tools to the effort to protect the land.")
Q(761, "Swoop Hunting", "Mulgore", 6, "horde_narache",
    "Swoops ranged widely over Mulgore, making their quills a test of hunting skill.",
    "The birds of the open plains were quick and difficult quarry.",
    "The gathered quills supplied proof of the swoop hunt.",
    "The hunting trophy was accepted at Bloodhoof Village.")
Q(766, "Mazzranache", "Mulgore", 8, "horde_narache",
    "A bite from Mazzranache had left a traveler feverish with infection.",
    "The remedy required a wolf heart, cougar femur, plainstrider scale and swoop gizzard.",
    "The ingredients made a remedy possible for the infected bite.",
    "The gathered animal parts supplied treatment for Mazzranache's bite.")
Q(833, "A Sacred Burial", "Mulgore", 10, "horde_rites",
    "Bristleback intruders were ravaging the graves at Red Rocks.",
    "The burial ground honored tauren who had founded and defended Thunder Bluff.",
    "The intruders were driven back from the sacred burial ground.",
    "The attack checked the Bristlebacks' desecration at Red Rocks.")
Q(861, "The Hunter's Way", "Thunder Bluff", 10, "horde_narache",
    "Melor Stonehoof could be found on Thunder Bluff's Hunter Rise.",
    "Skorn Whitecloud's introduction called for flatland prowler claws as proof of skill.",
    "Melor received the claws and recognized Skorn's recommendation.",
    "The prowler trophy brought the plains' hunting work before Melor in Thunder Bluff.")

-- Durotar: first duties, Darkspear concerns and the road to Orgrimmar.
Q(4641, "Your Place in the World", "Durotar", 1, "horde_trials",
    "In the Valley of Trials, Kaltunk laughed at the thought of a new recruit strangling dragons barehanded. Gornek would have more suitable work.",
    "Kaltunk sent new recruits to Gornek in the Den, where their service to the Horde would begin with smaller trials.",
    "Gornek had little praise for Kaltunk's latest recruit. He meant to send a proud fighter of the Horde out of the Valley.",
    "Gornek's greeting was stern. Whatever he thought of Kaltunk's recruits, he promised they would leave the Valley ready to serve the Horde.")
Q(788, "Cutting Teeth", "Durotar", 2, "horde_trials",
    "Gornek chose the mottled boars north of the Den for a first test. A new recruit was more use alive than lost on a kodo hunt.",
    "Before sending anyone against the Barrens' great kodo, Gornek had a simpler trial in mind: the Valley's mottled boars.",
    "The boar hunt earned a little praise from Gornek, followed by a warning against pride. The next trial would need better protection.",
    "Gornek judged the hunt well done, but warned that harder opponents lay ahead. Boars were only the beginning.")
Q(789, "Sting of the Scorpid", "Durotar", 3, "horde_trials",
    "Scorpid venom had killed veterans as well as novices. Gornek wanted ten tails from the creatures northwest of the Den.",
    "The Valley's trainers kept antidote made from scorpid venom, ready for young recruits. Gornek's next test called for ten stinging tails.",
    "The tails brought Gornek's final lesson: even a small opponent could kill. He had no more to teach, but would follow the progress of his recruit.",
    "Gornek accepted the ten tails and warned against judging danger by size. His lessons were over; he would watch the journey beyond them with interest.")
Q(790, "Sarkoth", "Durotar", 5, "horde_trials",
    "Hana'zua lay wounded beneath a tree. Sarkoth had caught his leg and driven a stinger into his chest, and he begged for the scorpid's death.",
    "Hana'zua had struck Sarkoth's claw before the scorpid brought him down. Bleeding beneath a tree, he feared dying with his honor unavenged.",
    "Sarkoth was dead. Hana'zua could still see the damage of his own blow upon the claw, and found a little pride in it despite his wounds.",
    "The dead scorpid's claw bore Hana'zua's earlier wound. That mark gave the injured hunter a small measure of pride.", nil, true)
Q(804, "Sarkoth", "Durotar", 5, "horde_trials",
    "Hana'zua's resolve had returned, but his wounds kept him from reaching the Den. He asked for word to be taken to Gornek.",
    "The wounded Hana'zua wanted to live. Unable to walk back to the Den unaided, he put his hope in a message to Gornek.",
    "Gornek recognized Sarkoth from the account and promised immediate aid for Hana'zua. Fighting for a stranger's honor, he said, carried honor of its own.",
    "Gornek promised to send help to the wounded hunter at once. He praised both Sarkoth's defeat and the choice to answer a stranger's plea.", nil, true)
Fallback("Sarkoth", "horde_trials",
    "Hana'zua's encounter with Sarkoth had left a wounded hunter in the valley.",
    "The scorpid Sarkoth was at the center of Hana'zua's plight.",
    "Hana'zua's trouble had drawn help in the Valley of Trials.",
    "The task addressed the aftermath of Hana'zua's encounter with the scorpid.", {V .. " #790, #804"})
Q(792, "Vile Familiars", "Durotar", 4, "horde_blade",
    "The Burning Blade's familiars had spilled from a cave into the Valley of Trials.",
    "A cult coven had taken root inside the valley used to train recruits.",
    "The familiars were thinned, but the coven's darker powers remained.",
    "The first attack checked the cult's creatures outside the cave.")
Q(794, "Burning Blade Medallion", "Durotar", 5, "horde_blade",
    "A medallion of power lay inside the Burning Blade coven.",
    "The cult's cave concealed more than the familiars roaming the valley.",
    "The medallion was removed from the coven, leaving questions about the cult's wider aims.",
    "The recovered medallion struck at the valley coven without ending the Burning Blade's threat.")
Q(823, "Report to Orgnil", "Durotar", 7, "horde_blade",
    "News of the Burning Blade concerned Sen'jin Village as well as the Valley of Trials.",
    "Orgnil Soulscar watched for corruption from his post at Razor Hill.",
    "The report reached Orgnil at Razor Hill.",
    "Razor Hill received word of the trouble reported from the valley and Sen'jin.")
Q(827, "Skull Rock", "Durotar", 12, "horde_blade",
    "Cultists at Skull Rock wore collars that burned their flesh.",
    "Margoz sought searing collars to study the Burning Blade's demonic power.",
    "The recovered collars gave Margoz evidence for his investigation.",
    "Margoz had the cult's searing collars to examine.")
Q(829, "Neeru Fireblade", "Orgrimmar", 12, "horde_blade",
    "The demonic collars exceeded what Margoz could explain through his own divination.",
    "Neeru Fireblade claimed to study demons in the Warchief's service.",
    "Neeru received a collar for examination in the Cleft of Shadow.",
    "The investigation brought one of Skull Rock's collars to Neeru.")
Q(808, "Minshina's Skull", "Durotar", 9, "horde_darkspear",
    "Zalazane's magic held Minshina's spirit within a skull on the Echo Isles.",
    "A circle of skulls on the largest isle imprisoned more than mortal remains.",
    "The recovered skull freed Minshina's spirit from its captivity.",
    "Minshina's brother received the skull and an end to that spiritual enslavement.")
Q(826, "Zalazane", "Durotar", 10, "horde_darkspear",
    "Zalazane sent hexed followers from the Echo Isles to seize more Darkspear.",
    "The islands once called home had become the source of Sen'jin's danger.",
    "The returned head satisfied the village's demand for proof against Zalazane.",
    "The Darkspear credited the blow against Zalazane with relief for Sen'jin Village.")
Q(815, "Break a Few Eggs", "Durotar", 8, "horde_darkspear",
    "Sen'jin's next meal needed taillasher eggs from the Echo Isles.",
    "The taillashers guarded eggs that could supply the village's cooking pot.",
    "The eggs arrived in time for the cooking to continue.",
    "The cook had another batch of eggs for the village's meals.")
Q(817, "Practical Prey", "Durotar", 8, "horde_darkspear",
    "Tiger hides supplied blankets, armor and tents for a growing settlement.",
    "Stocks of hides had fallen behind the needs of Sen'jin's people.",
    "The tiger furs supplied material for protection against the weather.",
    "Fresh hides replenished the village's stores for clothing and shelter.")
Q(813, "Finding the Antidote", "Orgrimmar", 9, "horde_darkspear",
    "Kor'ghan needed venomtail poison sacs to make an antidote for Rhinag.",
    "The scorpids near Orgrimmar carried the substance needed to counter their own venom.",
    "Kor'ghan prepared the antidote, which still needed delivery to Rhinag.",
    "The remedy was ready for the poisoned hunter.")
Q(812, "Need for a Cure", "Durotar", 9, "horde_darkspear",
    "A venomtail sting was weakening Rhinag outside Orgrimmar.",
    "Rhinag's survival depended on Kor'ghan's antidote reaching him in time.",
    "The antidote saved Rhinag's life.",
    "Rhinag survived the venom and faced more training under Kor'ghan.")
Q(834, "Winds in the Desert", "Durotar", 9, "horde_roads",
    "Dustwind harpies had seized a shipment needed for Rezlak's work.",
    "Stolen caravan sacks lay in the canyons while construction waited.",
    "Rezlak recovered the supplies needed to resume work.",
    "The stolen shipment was back in Rezlak's hands.")
Q(835, "Securing the Lines", "Durotar", 11, "horde_roads",
    "Harpies in Drygulch Ravine threatened each new supply caravan.",
    "Recovering a shipment left the raiders along Rezlak's routes to contend with.",
    "The attack on the harpies gave Rezlak reason to expect safer deliveries.",
    "Pressure on the caravan routes eased after the Drygulch fighting.")
Q(840, "Conscript of the Horde", "The Barrens", 12, "horde_roads",
    "Takrin's recruitment letter needed Kargal's signature for Barrens duty.",
    "The Horde needed recruits at the outposts beyond Durotar.",
    "Kargal signed the letter and pointed toward the Crossroads.",
    "The recruitment letter was approved, with the Crossroads still needing help.")
Q(842, "Crossroads Conscription", "The Barrens", 12, "horde_roads",
    "Sergra Darkthorn directed the work awaiting recruits at the Crossroads.",
    "Kargal's signed letter served as an introduction to the Crossroads command.",
    "Sergra accepted the letter and made the demands of Crossroads duty clear.",
    "The recruitment errand reached Sergra Darkthorn.")
Q(844, "Plainstrider Menace", "The Barrens", 12, "horde_roads",
    "Plainstriders east of the Crossroads were harassing its food supplies.",
    "Keeping the outpost fed began with a hunt close to its supply routes.",
    "The plainstrider beaks proved a hunt that eased pressure on the food stores.",
    "Sergra judged the supplies easier to protect with fewer plainstriders harassing them.")
Q(845, "The Zhevra", "The Barrens", 13, "horde_roads",
    "Sergra's next hunting test called for zhevra hooves.",
    "The zhevra north and south of the Crossroads could strike hard with their hooves.",
    "The hooves supplied proof that Sergra's zhevra test was complete.",
    "Sergra accepted the zhevra hunt before proposing more difficult prey.")
Q(848, "Fungal Spores", "The Barrens", 15, "horde_apothecary",
    "The Barrens' oases nourished and altered the life around them.",
    "Mushrooms growing near the oases held spores useful to the apothecaries.",
    "The spores were accepted as potent research specimens.",
    "The apothecary received samples of the oases' unusual fungi.")
Q(868, "Egg Hunt", "The Barrens", 22, "horde_roads",
    "Little was known about the insect-like creatures in the Field of Giants.",
    "An observer working for Orgrimmar sought intact eggs from the southern mounds.",
    "The eggs and digging tool were returned for the study.",
    "The collected eggs supplied specimens of the Field of Giants' creatures.")
Q(869, "Raptor Thieves", "The Barrens", 13, "horde_roads",
    "Silver intended for the Crossroads guards' pay had been stolen, and a captured thief was a raptor.",
    "The missing payroll had prompted an unusual hunt for raptor thieves.",
    "The raptor heads supplied proof of the requested hunt.",
    "The hunt struck the suspected thieves without accounting for the missing silver.")

-- Forsaken beginnings and the apothecaries' early research. Each recipe stage
-- stands alone; no reagent delivery silently becomes a successful new plague.
Q(363, "Rude Awakening", "Tirisfal Glades", 1, "horde_forsaken",
    "Mordo had been ready to burn the body that stirred in Deathknell's crypt. Instead, he sent the newly awakened to Sarvis in the chapel below.",
    "Freedom from the Lich King began in Deathknell's cold crypt. Mordo directed the newly awakened toward Shadow Priest Sarvis at the foot of the hill.",
    "Sarvis named Sylvanas as the Forsaken's liberator and leader. Their freedom had brought war with the Scourge and the human holdouts around them.",
    "In the chapel, Sarvis explained what it meant to be Forsaken: freedom under Sylvanas, with the Scourge and the surviving humans as enemies.")
Q(364, "The Mindless Ones", "Tirisfal Glades", 2, "horde_forsaken",
    "The Mindless Ones overran northern Deathknell. Sarvis called them former brothers and sisters, still enslaved to the Lich King.",
    "Sarvis ordered the mindless undead in the north of the village destroyed. The Forsaken's old kin now served the Scourge.",
    "The mindless dead were cut down. Sarvis regretted that so many could not be brought into the Forsaken's ranks; he saw only enemies where allies might have stood.",
    "Sarvis lamented the numbers lost to the Scourge. Those destroyed in Deathknell would not join the Forsaken, and he believed that left no other course.")
Q(376, "The Damned", "Tirisfal Glades", 2, "horde_forsaken",
    "Novice Elreth tended Deathknell's wounded and made their clothing. Her supplies of wolf paws and bat wings were running low.",
    "Elreth offered armor for paws and wings from the creatures south of Deathknell. She urged care until she could provide some protection.",
    "Elreth traded the gathered paws and wings for armor. She hoped it would serve better than it had served its previous wearer.",
    "The paws and wings replenished Elreth's supplies. The armor she offered came with an ominous wish: that its next wearer would fare better than the last.")
Q(375, "The Chill of Death", "Tirisfal Glades", 8, "horde_forsaken",
    "A seamstress who made soldiers' body bags now needed a blanket against the chill.",
    "Duskbat pelts and coarse thread were a modest answer to an unrelenting cold.",
    "The pelts and thread supplied material for the seamstress's blanket.",
    "The requested materials offered the shivering seamstress some comfort.")
Q(382, "The Red Messenger", "Tirisfal Glades", 5, "horde_scarlet",
    "A Scarlet messenger carried information from the monastery to Deathknell.",
    "Executor Arren wanted the documents traveling with the Scarlet courier.",
    "The captured papers revealed the positions of Scarlet commanders and agents.",
    "Arren found a useful map among the messenger's orders and reports.")
Q(383, "Vital Intelligence", "Tirisfal Glades", 5, "horde_scarlet",
    "Arren's intelligence needed to reach Executor Zygand in Brill.",
    "The captured Scarlet dispositions offered Brill a chance to strike at the Crusade's officers.",
    "Zygand received the documents and considered attacks on the named officers.",
    "The intelligence reached Brill before any attack on the commanders had been proved.")
local scarlet = {
    {427, 8, "Scarlet warriors held a tower beyond Solliden Farmstead.", "Zygand sought a strike against the warriors west of Brill.", "The attack reduced the Scarlet warriors at the western tower.", "Zygand accepted the report against the tower's warriors."},
    {370, 9, "Captain Perrine commanded the ruined tower southwest of Brill.", "The captured dispositions placed Perrine with zealots and missionaries.", "Perrine fell with members of his detachment.", "The strike removed Captain Perrine from the Scarlet command in Tirisfal."},
    {371, 10, "Captain Vachon directed raids near Balnir Farmstead.", "Scarlet friars supported Vachon at the southeastern tower.", "Vachon's death slowed the Crusade's advance in Tirisfal.", "The attack struck Vachon and his friars at their tower."},
    {372, 12, "Captain Melrache held the northern tower beyond Faol's Rest.", "Two bodyguards protected the Scarlet commander at the northern tower.", "Melrache and his bodyguards were defeated.", "The northern Scarlet detachment lost its commander."},
}
for _, r in ipairs(scarlet) do Q(r[1], "At War With The Scarlet Crusade", "Tirisfal Glades", r[2], "horde_scarlet", r[3], r[4], r[5], r[6], nil, true) end
Fallback("At War With The Scarlet Crusade", "horde_scarlet",
    "Scarlet detachments occupied the ruined towers of Tirisfal.",
    "Brill's executors directed a series of attacks against the Crusade.",
    "The recorded strike was one part of the fighting against the Scarlet forces.",
    "The Crusade faced another attack in Tirisfal.", {V .. " #427, #370, #371, #372"})
local plague = {
    {367, 6, "Darkhound blood was the first material requested for a new plague.", "The apothecaries sought a weapon against the Scourge.", "The darkhound blood was delivered for experimentation.", "The blood samples supplied the apothecary's proposed research."},
    {368, 9, "Vile Fin scales were needed to investigate how the disease might spread.", "The next experiment depended on scales from the coastal murlocs.", "The scales met the apothecary's requirements for the mixture.", "The experiment gained its requested murloc specimens."},
    {369, 11, "Night Web venom was linked in an old text to an earlier plague.", "The apothecary wanted venom as the final component of the experimental mixture.", "The venom completed the mixture's ingredients, leaving its test ahead.", "The apothecary was ready to try the new agent after receiving the venom."},
}
for _, r in ipairs(plague) do Q(r[1], "A New Plague", "Tirisfal Glades", r[2], "horde_apothecary", r[3], r[4], r[5], r[6], nil, true) end
Fallback("A New Plague", "horde_apothecary",
    "The Royal Apothecary Society was experimenting with a new disease.",
    "Brill's apothecary collected reagents for a proposed weapon against the Scourge.",
    "The recorded work contributed to the apothecary's experiment.",
    "The research advanced another step without settling its eventual result.", {V .. " #367, #368, #369, #492"})
Q(449, "The Deathstalkers' Report", "Silverpine Forest", 11, "horde_forsaken",
    "Scouting Silverpine had proved more dangerous than High Executor Hadrec expected.",
    "With Quinn recovering, the Deathstalkers still needed their report delivered.",
    "Hadrec learned the extent of the Scourge presence and the scouts' difficulties.",
    "The Deathstalkers' report reached the Sepulcher's command.")
Q(447, "A Recipe For Death", "Undercity", 12, "horde_apothecary",
    "Renferrel sought spider blood and bear hearts for a lethal elixir.",
    "Silverpine's beasts supplied reagents intended for Faranell's laboratory.",
    "Faranell received the samples and began considering their toxic properties.",
    "The specimens reached the Royal Apothecary Society for study.", nil, true)
Q(450, "A Recipe For Death", "Silverpine Forest", 15, "horde_apothecary",
    "Berard's research remained in Pyrewood after Arugal's curse claimed the apothecary.",
    "A lost colleague's journal could preserve work on an ancient aquatic plague.",
    "Renferrel received Berard's journal from Pyrewood.",
    "Berard's surviving research was recovered for examination.", nil, true)
Q(451, "A Recipe For Death", "Undercity", 18, "horde_apothecary",
    "Berard's notes described useful moss and a rare murloc tumor.",
    "The waters of Lordamere held specimens named in the recovered journal.",
    "Faranell received new specimens that could continue Berard's work.",
    "The gathered moss and tumor preserved a use for the lost apothecary's research.", nil, true)
Fallback("A Recipe For Death", "horde_apothecary",
    "Renferrel and Faranell pursued the ingredients and records of plague research.",
    "The apothecaries' work connected Silverpine with the laboratories of the Undercity.",
    "Another part of the recipe's research reached the apothecaries.",
    "The recorded task supplied the continuing investigation.", {V .. " #447, #450, #451"})

-- Shaman trials. The title is shared across ingredients, introductions,
-- manifestations and rewards, including Forever's other racial routes.
Fallback("Call of Earth", "shaman_earth",
    "The earth rite taught patience, endurance and the foundations of the shaman's craft.",
    "Sapta and sacred ground had their places in the call of earth.",
    "The recorded task marked a stage in the earth rite.",
    "Another part of the earth's teaching had been attended to.", {V .. " #1516-1521, #92466-92468", F .. " #94374"})
Fallback("Call of Fire", "shaman_fire",
    "The fire rite concerned creation as well as destruction.",
    "The teaching of fire demanded more than strength alone.",
    "The recorded task completed a stage of the fire rite.",
    "The work belonged to the shaman's study of fire.", {V .. " #1522-1527, #2984", F .. " #94449, #94465-94468"})
Fallback("Call of Water", "shaman_water",
    "Water's healing power depended on purity, and its teaching ranged far beyond a single pool.",
    "The water rite joined practical gathering with concern for corrupted springs.",
    "The recorded task marked one stage in the water rite.",
    "Another part of the work of water had been completed.", {V .. " #63, #96, #100, #220, #1103, #1528-1536", F .. " #94495-94505"})
local earth = {
    {1516, "Durotar", "Felstalker hooves were needed to prepare Canaga's earth sapta.", "The trial began with materials from the felstalkers north of the valley camp.", "Canaga had the ingredients to prepare the earth sapta.", "The gathered hooves made the next step of the earth rite possible."},
    {1517, "Durotar", "Spirit Rock stood at the end of the Hidden Path.", "The earth sapta was reserved for the sacred ground at Spirit Rock.", "The earth spirit was encountered at Spirit Rock.", "The meeting with the earth spirit completed this part of the rite."},
    {1518, "Durotar", "A piece of rough quartz served as proof of the earth spirit's meeting.", "Canaga could make a totem with the spirit's small stone at its heart.", "Canaga granted the earth totem in exchange for the quartz.", "The quartz became the heart of a totem for earth magic."},
    {1519, "Mulgore", "Bristleback shamans kept ritual salve in the ravine east of Narache.", "Seer Ravenfeather needed Bristleback salve for a brew used in the earth rite.", "The salve was ready for Ravenfeather's brew.", "Ravenfeather accepted the salve and began preparing the sapta."},
    {1520, "Mulgore", "The potion had to be drunk on sacred ground, at the shaman shrine east of Narache.", "Earth sapta made the spirit at the shrine visible to those taking the rite.", "At the shrine, the earth spirit taught strength and patience.", "The earth spirit welcomed the meeting and acknowledged that the rite was passed."},
    {1521, "Mulgore", "A piece of rough quartz was the earth spirit's proof for Seer Ravenfeather.", "Seer Ravenfeather awaited the rough quartz given at the shrine.", "Ravenfeather granted the earth totem.", "The returned stone became the heart of a totem for earth magic."},
    {92466, "Zephras Isle", "An Al'Aketh signet was required as proof of resolve at the standing stones.", "Windshaper teaching began with earth even on an island sustained by wind.", "The signet provided the requested proof of resilience.", "The preliminary test was met, with the earth rite's next step still ahead."},
    {92467, "Zephras Isle", "The Rise of Spirits lay up the pass northeast of the grove.", "Earth sapta was to be taken on sacred ground at the Rise of Spirits.", "The earth spirit offered teaching, but no explanation for the vanished winds.", "The meeting revealed earth's guidance without answering why the winds had left."},
    {92468, "Zephras Isle", "Windshaper Boro awaited rough quartz from the earth spirit.", "A shard of quartz was to become the center of the promised totem.", "Boro granted the earth totem after receiving the quartz.", "The spirit's shard supplied a focus for the magic of earth."},
}
for _, r in ipairs(earth) do Q(r[1], "Call of Earth", r[2], 4, "shaman_earth", r[3], r[4], r[5], r[6], nil, true) end
Q(94374, "Call of Earth", "Dun Morogh", 4, "shaman_earth",
    "The Spirit Stone lay at the end of a hidden mountain path in the frozen land.",
    "The earth sapta was to be drunk on sacred ground at the Spirit Stone.",
    "The earth spirit welcomed the meeting among the snow and stone.",
    "The Spirit Stone rite ended with the earth spirit's welcome.", F, true)
Q(94373, "Call of Earth", "Dun Morogh", 4, "shaman_earth",
    "Frostmane necklaces made from Iceclaw bears were needed for the earth rite.",
    "The first preparations called for necklaces from the trolls' southern cave.",
    "The necklaces supplied the requested proof before the sapta was prepared.",
    "The gathered materials made preparation of the earth sapta possible.", nil, true)
Q(94375, "Call of Earth", "Dun Morogh", 4, "shaman_earth",
    "Teo Hammerstorm awaited rough quartz from the earth spirit.",
    "The spirit's small stone was to become the heart of a totem.",
    "Teo granted the earth totem after receiving the quartz.",
    "The returned stone supplied the promised focus for earth magic.", nil, true)
for _, id in ipairs({1522, 1523, 2984}) do
    Q(id, "Call of Fire", "The Barrens", 10, "shaman_fire",
        "Kranal Fiss lived north of the Crossroads and instructed shamans in fire.",
        "The next elemental teaching began with a referral to Kranal Fiss.",
        "Kranal accepted the referral and introduced the next rite.",
        "The fire teaching reached Kranal, with the sapta's preparation still ahead.", nil, true)
end
local fire = {
    {1524, 11, "Durotar", "Telf Joolam guarded the Shrine of the Dormant Flame high above Durotar.", "Kranal's torch marked an applicant for the shrine's teaching.", "Telf recognized the torch and admitted the purpose of the visit.", "The torch reached the keeper of the shrine, still awaiting its flame."},
    {1525, 12, "Durotar", "Fire tar and a Burning Blade reagent pouch were needed for the fire sapta.", "Telf's brew required materials bound to the element of fire.", "Telf received the materials needed for the sapta.", "The ingredients were ready for the fire rite's next stage."},
    {1526, 13, "Durotar", "The fire manifestation stood above the shrine, visible through the sapta.", "Its embers could kindle the shrine's brazier and the waiting torch.", "The manifestation's ember lit the brazier, and the torch caught fire.", "The trial at the shrine ended with the Torch of Eternal Flame alight."},
    {1527, 13, "The Barrens", "The burning torch was the proof Kranal Fiss awaited.", "The shrine's flame had to be returned to the teacher in the Barrens.", "Kranal granted the fire totem on receiving the torch.", "The returned flame completed the rite and earned the fire totem."},
}
for _, r in ipairs(fire) do Q(r[1], "Call of Fire", r[3], r[2], "shaman_fire", r[4], r[5], r[6], r[7], nil, true) end
for _, id in ipairs({1528, 1529, 2986}) do
    Q(id, "Call of Water", "The Barrens", 20, "shaman_water",
        "Islen Waterseer kept a fishing hut on the coast south of Ratchet.",
        "The water teaching began with a referral to Islen on the Barrens coast.",
        "Islen received the arrival and introduced the study of water's purity.",
        "The teaching reached Islen, with the work for the water sapta still ahead.", nil, true)
end
local water = {
    {1530, 22, "The Barrens", "Brine lived deep in the southern Barrens among the quilboar's threats.", "Islen sent the search for a water sapta onward to Brine.", "The errand reached Brine's remote home.", "Brine received the request for the next part of the water rite."},
    {1535, 22, "The Barrens", "A pond below Brine's hut held precious water in the dry Barrens.", "The quilboar guarded the small pool that supplied the first sample.", "The first waterskin returned filled from the Barrens pool.", "Brine received the local water sample for the rite."},
    {1536, 22, "The Barrens", "The well at Tarren Mill remained fresh despite the blighted country around it.", "Brine wanted water from a spring in the center of the Forsaken town.", "The Tarren Mill sample reached Brine, with one sample still needed.", "Brine received the fresh well water from Hillsbrad."},
    {1534, 23, "The Barrens", "A fountain at the Ruins of Stardust held the final water Brine requested.", "The water rite's last sample lay far to the north in Ashenvale.", "The Ashenvale sample completed the set needed for Brine's pure-water vial.", "Brine could prepare the vial after receiving the fountain water."},
    {220, 23, "The Barrens", "Brine's blessed vial was needed for Islen's next preparations.", "The pure water had another purpose beyond the making of sapta.", "Islen received the vial and prepared to direct the work toward Silverpine.", "The blessed water reached Islen for the next stage of the rite."},
    {63, 23, "Silverpine Forest", "A shrine west of the Sepulcher had fallen silent under corruption.", "The water manifestation's bracers and the blessed drops were needed at the brazier.", "The bracers and remaining potion were placed on the brazier for the cleansing ritual.", "The shrine's ritual began with bracers, blessed water and Islen's incantation."},
    {100, 23, "Silverpine Forest", "The completed incantation scattered corruption around the water shrine.", "A pure water spirit could speak after the ritual's light broke the corruption.", "The water spirit acknowledged the cleansing while warning that life still waned.", "The spirit's thanks marked a local cleansing, with the wider blight still present."},
    {96, 23, "The Barrens", "A shard from the water spirit served as proof for Islen.", "The rite's reward awaited evidence of the work in Silverpine.", "Islen granted the water totem after receiving the shard.", "The returned proof completed the water rite and earned its totem."},
    {1103, 23, "Silverpine Forest", "Tiev could help make the pure water spirit accessible again.", "Water sapta served as proof that the visitor was ready for Tiev's assistance.", "Tiev agreed to use his ritual materials so the spirit could be approached.", "The sapta secured Tiev's help in reaching the spirit at the shrine."},
}
for _, r in ipairs(water) do Q(r[1], "Call of Water", r[3], r[2], "shaman_water", r[4], r[5], r[6], r[7], nil, true) end
for _, id in ipairs({1531, 1532}) do
    Q(id, "Call of Air", "Thousand Needles", 30, "shaman_air",
        "Prate Cloudseer offered instruction in air from her refuge in Thousand Needles.",
        "The winds' teaching led south of the Barrens to Prate Cloudseer.",
        "Prate granted the air totem as a focus for the element's spells.",
        "The air totem was given, with further training left for a later time.", nil, true)
end
Fallback("Call of Air", "shaman_air",
    "The shaman's teaching included the elusive element of air.",
    "The winds had their own place among the four elemental paths.",
    "The recorded task marked work on the call of air.",
    "The air teaching had received another part of its due.", {V .. " #1531, #1532"})

-- Forever dwarf shaman stages use their own teachers and geography.
local dwarfFire = {
    {94449, 10, "Dun Morogh", "Bruegs Kindleborn lived in a cave above South Gate Outpost.", "The fire teaching led east through the mountains to Bruegs.", "Bruegs accepted the referral for the fire rite.", "The introduction reached Bruegs, who explained the need for restraint with fire."},
    {94465, 11, "Loch Modan", "Braldir Ashmantle guarded a sacred flame shrine beyond the Valley of Kings.", "Bruegs's torch marked the purpose of the journey to the shrine.", "Braldir recognized the torch and welcomed the applicant.", "The torch reached the shrine's keeper before the flame trial began."},
    {94466, 14, "Loch Modan", "Tunnel Rat fire tar and a Stonesplinter Seer's pouch were needed for the sapta.", "The shrine's preparations required two reagents tied to fire.", "Braldir received the requested sapta ingredients.", "The gathered reagents made the fire sapta possible."},
    {94467, 14, "Loch Modan", "The fire manifestation waited above the shrine.", "The brazier could be kindled with the manifestation's embers.", "The ember lit the brazier, and the torch caught its flame.", "The shrine trial ended with the torch alight above Loch Modan."},
    {94468, 14, "Dun Morogh", "Bruegs awaited the Torch of Eternal Flame as proof.", "The flame from Loch Modan's shrine had to return to its teacher.", "Bruegs granted the fire totem on receiving the torch.", "The returned flame completed Bruegs's rite and earned the totem."},
}
for _, r in ipairs(dwarfFire) do Q(r[1], "Call of Fire", r[3], r[2], "shaman_fire", r[4], r[5], r[6], r[7], F, true) end
local dwarfWater = {
    {94495, 22, "Wetlands", "Hervdana Saegrund lived beneath the southern falls in the Wetlands.", "The water teaching led to a family dwelling at the edge of the falls.", "The request for the water sapta reached Hervdana.", "Hervdana received the arrival for the next part of the rite."},
    {94497, 22, "Wetlands", "Freshwater met the brackish marsh below Hervdana's cave.", "The first waterskin was meant to hold water from the base of the falls.", "Hervdana received the estuary sample.", "The filled waterskin completed the first local sampling task."},
    {94499, 22, "Wetlands", "The murlocs below Stonewatch Falls raised suspicions about the water.", "Hervdana sought a sample where Lake Everstill's waters fell past the old fort.", "The sample proved pure; Hervdana attributed the changed murlocs to nearby shadow magic.", "Hervdana found no taint in the Redridge sample and requested one more."},
    {94500, 23, "Wetlands", "The lake around Astranaar held the last water Hervdana requested.", "Ancient ruins lay under the Ashenvale lake selected for the third sample.", "The Ashenvale water completed the samples for Hervdana's vial.", "Hervdana could brew the pure-water vial after the final sample arrived."},
    {94501, 23, "Loch Modan", "Norric awaited the water blessed by Hervdana.", "The vial was intended for sapta and a further task at Stendel's Pond.", "Norric received the blessed water for the next preparations.", "The vial reached Norric before the cleansing work in Westfall."},
    {94502, 23, "Westfall", "The spirits at Stendel's Pond had fallen silent under corruption.", "A dusty shrine beside the still pond awaited bracers and blessed water.", "The ritual materials were placed on the shrine, and the incantation began.", "The cleansing rite at Stendel's Pond was performed with the bracers and sacred drops."},
    {94503, 23, "Westfall", "The ritual's light scattered the corrupt spirits around Stendel's Pond.", "The water spirit could be approached after the corruption ebbed.", "The spirit gave thanks while warning that life still needed protection.", "The water spirit acknowledged the local cleansing."},
    {94505, 23, "Loch Modan", "A shard from the water spirit supplied Norric's requested proof.", "The final return brought evidence from the Westfall shrine to Norric.", "Norric granted the water totem.", "The shard completed Norric's rite and earned its elemental focus."},
}
for _, r in ipairs(dwarfWater) do Q(r[1], "Call of Water", r[3], r[2], "shaman_water", r[4], r[5], r[6], r[7], F, true) end
local skyFire = {
    {97243, "Olariaan Swiftburn tended the Shrine of Flames west of Valanaar.", "The Windshapers' fire teaching began with a torch carried to the island's edge.", "Olariaan received the torch and agreed to teach the call of fire.", "The introduction reached Olariaan at the Shrine of Flames."},
    {97244, "Skypriest Faladiel had abandoned the Windshapers for the Al'Aketh.", "The fire ritual demanded Faladiel's heart as an offering.", "Faladiel's heart supplied one of the ritual's offerings.", "The heart was delivered, with another offering still needed."},
    {97245, "The forest sprite Kuramaa dwelt in a twisted stump near the highlands' anchor pylon.", "Kuramaa's wooden mask held power needed for the flame ritual.", "The mask supplied the remaining offering for the ritual.", "The offerings were ready, with the lighting of the Eternal Flame still ahead."},
    {97257, "Flames brought from the Firelands quickly faded in Skywall.", "The lit torch had to reach Valanaar's brazier before its flame dissipated.", "The Eternal Flame burned again in Valanaar, and the fire totem was awarded.", "The rekindled brazier completed the trial and earned the fire totem."},
}
for _, r in ipairs(skyFire) do Q(r[1], "Call of Fire", "Zephras Isle", 10, "shaman_fire", r[2], r[3], r[4], r[5], nil, true) end

-- Zephras: both traditions share an endangered home. Never infer allegiance,
-- travel to Azeroth, or a successful defense from race identity alone.
Q(92460, "Coming of Age", "Zephras Isle", 1, "forever_grove",
    "Rorian the Dayseeker received the young at the entrance to the greatfather tree.",
    "Thendal's coming-of-age relics passed from one generation to the next.",
    "Rorian bestowed a relic carrying the village's continuing tradition.",
    "The coming-of-age ceremony placed an inherited relic in new keeping.")
Q(92461, "Harmony in Balance", "Zephras Isle", 1, "forever_grove",
    "The vuldren population had grown beyond what Thendal Grove could sustain.",
    "Changes in the island's wind magic could disturb even its normally docile animals.",
    "The cull reduced the pressure from Thendal's growing vuldren population.",
    "The work addressed an immediate imbalance in the grove's wildlife.")
Q(92462, "Infestation Investigation", "Zephras Isle", 2, "forever_grove",
    "Cirrusflies were swarming at the eastern end of Thendal Grove.",
    "The grove's rangers feared an insect infestation left unchecked.",
    "The report made the scale of the cirrusfly infestation clear.",
    "The first attack on the swarm confirmed that the grove had a serious pest problem.")
Q(92463, "The Cirrusfly Queen", "Zephras Isle", 3, "forever_grove",
    "Killing cirrusfly workers would not end the infestation while the queen remained.",
    "The queen's hive lay deeper in the forest, protected by larger soldiers.",
    "The queen's defeat struck at the source of the cirrusfly swarm.",
    "The grove's infestation lost its queen.")
Q(92464, "Elemental Unrest", "Zephras Isle", 3, "forever_winds",
    "The simple wind sprites near the standing stones had become agitated.",
    "Yala Windwatcher was observing the disturbed manifestations northeast of Thendal.",
    "The investigation reached Yala, who needed help at the stones.",
    "Yala received the arrival sent to learn about the restless sprites.")
Q(92465, "Agitators", "Zephras Isle", 3, "forever_cult",
    "Yala blamed the Al'Aketh for stirring the wind sprites into violence.",
    "The cult's activity near Thendal threatened the grove's simple manifestations.",
    "The violent sprites were dispersed and the cultists confronted.",
    "The immediate trouble at the standing stones was checked, at the cost of shen'dorei blood.")
Q(92469, "Return to Rorian", "Zephras Isle", 4, "forever_cult",
    "Rorian needed word of the cult's presence near Thendal's standing stones.",
    "The agitation of the wind sprites had gone beyond the cult's earlier movements.",
    "Rorian recognized the report as evidence of the cult's escalation.",
    "Thendal's leader learned how the Al'Aketh had disturbed the grove.")
Q(93552, "Harvesting Windstones", "Zephras Isle", 4, "forever_winds",
    "Windstones stored precious energy as the magic sustaining Zephras faded.",
    "The vanished wind elementals had left the island dependent on dwindling sources of power.",
    "The harvested windstones replenished a valuable supply of elemental energy.",
    "More raw windstones were gathered for an island whose anchor magic was weakening.", F)
Q(92597, "Reading the Ley Lines", "Zephras Isle", 4, "forever_winds",
    "A ley line had broken the surface near Thendal's standing stones.",
    "The island's arcane teaching drew on energies still running beneath its soil.",
    "The ley line was read at the standing stones.",
    "The exercise put the racial gift to use on the grove's exposed ley line.", F)
Q(92517, "The Criminal Element", "Zephras Isle", 7, "forever_cult",
    "Bandits operated from a cave hidden behind a waterfall north of Shen'dar.",
    "The cult's arrival had made Shen'dar's old bandit problem more dangerous.",
    "The bandits were dispersed, though survivors might still seek the cult's protection.",
    "Shen'dar gained relief from the cave's bandits without an end to the wider danger.", F)
Q(92528, "Among the Faithful", "Zephras Isle", 8, "forever_cult",
    "Falaath Village offered a chance to learn the Al'Aketh's intentions.",
    "A guest at Falaath's inn had drawn the attention of Skypriest Aanders.",
    "The report identified Lorthuna and warned of moves against Shen'dar and the western watchtower.",
    "Shen'dar learned of the cult's planned attacks, though the tower's importance remained unclear.", F)
Q(93926, "The Western Watch", "Zephras Isle", 8, "forever_cult",
    "Shen'dar's defenders were to abandon the exposed western tower and return to the village.",
    "Peacekeeper Vaaniel needed a recall order before the cult's attack cost more lives.",
    "The peacekeeper was already dead, with burns from the cult's storm magic.",
    "The recall reached a body at the watchtower rather than a living defender.", F)
Q(93927, "A Last Request", "Zephras Isle", 8, "forever_cult",
    "A bloodied note remained in the dead peacekeeper's hands.",
    "The western watch's last message offered a lead into the cult's work at the pylon.",
    "The priest and cultists at the tower were stopped, but the windstone cache raised new questions.",
    "Shen'dar learned of the dead watch and the cult's troubling interference with the pylon.", F)
Q(92579, "To Valanaar", "Zephras Isle", 8, "forever_cult",
    "Valennia Stormfist needed Shen'dar's report as the cult expanded.",
    "The peacekeepers could no longer keep apart from the Al'Aketh conflict.",
    "Valennia received Aonda's letter and began considering Valanaar's defense.",
    "The report reached Valanaar's peacekeeper command.", F)
Q(93949, "Bugged", "Zephras Isle", 8, "forever_cult",
    "A listening enchantment had been discovered on a skyhopper near Valanaar.",
    "The peacekeepers suspected the cult of using insects as spies.",
    "The skyhopper cull reduced the suspected spies without proving every insect was gone.",
    "Each destroyed enchanted skyhopper made eavesdropping around Valanaar harder.", F)
Q(93735, "The Broken Construct", "Zephras Isle", 9, "forever_winds",
    "One of Valanaar's few working wind constructs had been damaged.",
    "The Windshapers maintained machines left by the departed wind spirits.",
    "The artisan was found working inside the construct's opened armor.",
    "The investigation reached a construct missing its core and gyrozephyr.", F, true)
Q(93737, "The Broken Construct", "Zephras Isle", 9, "forever_winds",
    "Missing components had left Valanaar's construct close to losing its sustaining winds.",
    "The artisan needed scavenged materials before the machine could be repaired.",
    "The materials made repair possible; the construct's memory still needed testing.",
    "The artisan had the parts to restore the construct and investigate the theft.", F, true)
Fallback("The Broken Construct", "forever_winds",
    "A damaged wind construct in Valanaar needed the Windshapers' attention.",
    "Only a few of the island's old magical constructs still functioned.",
    "The recorded work addressed the damaged construct.",
    "The construct's condition had received attention in Valanaar.", {F .. " #93735, #93737"})
Q(92640, "Desperate Times", "Zephras Isle", 11, "forever_cult",
    "An assault on the shrine offered a chance to interrupt Lorthuna's scheme.",
    "Valennia's plan depended on cooperation between the Windshapers and the High Order.",
    "The preparations reached Valennia, with both traditions still needed for the assault.",
    "The shrine attack's requirements were laid out before the fighting began.", F)
Q(92643, "The Turncoat", "Zephras Isle", 11, "forever_cult",
    "An Al'Aketh defector sought protection in exchange for the cult's plans.",
    "A secluded house northwest of Valanaar concealed the would-be informant.",
    "The turncoat was found dead after the assassins' attack.",
    "The hoped-for informant could no longer tell the cult's secrets.", F)
Q(92644, "Unfortunate News", "Zephras Isle", 11, "forever_cult",
    "A damaged blue crystal had been recovered beneath the dead turncoat.",
    "High Elder Shadowsong needed the news and the crystal from the failed rendezvous.",
    "Shadowsong received the damaged crystal and the report of the turncoat's death.",
    "The crystal reached the high elder as the remaining clue from the informant.", F)
for _, id in ipairs({92646, 93835}) do
    Q(id, "Confront Lorthuna", "Zephras Isle", 12, "forever_cult",
        "Lorthuna had fled through a portal to the Rohashi Spires above the shrine.",
        "Ayessa and Elaadrin pursued Lorthuna while Valennia remained wounded below.",
        "Valennia's forces were brought back, but Zephras remained dangerously vulnerable.",
        "The confrontation ended with survivors recovering and the island's future still unsettled.", F, true)
end
Fallback("Confront Lorthuna", "forever_cult",
    "Lorthuna fled to the spires above the shrine, pursued by both elven traditions.",
    "The crisis at the shrine drew Ayessa and Elaadrin into the same confrontation.",
    "The survivors returned to an island whose protection remained in doubt.",
    "The confrontation's aftermath left Zephras with urgent decisions about its future.", {F .. " #92646, #93835"})
Q(94369, "The Fate of Zephras", "Zephras Isle", 12, "forever_winds",
    "The wards hiding Zephras had fallen, leaving the island exposed in Al'Akir's domain.",
    "Elaadrin's proposed mission to Azeroth needed High Elder Shadowsong's attention.",
    "Shadowsong acknowledged Lorthuna's defeat without dismissing the danger to Zephras.",
    "The high elder received the plan to seek help on Azeroth; the island's rescue remained ahead.", F)
Q(94485, "Tears of the Lady", "Zephras Isle", 12, "forever_grove",
    "Lady's Tear moss grew around Shadowgale's trees and could bind the druids' wounds.",
    "Elegael needed antiseptic moss for the injured members of the Nightclaw.",
    "The gathered moss supplied the poultices' main ingredient.",
    "Elegael received enough Lady's Tear to prepare treatment for the wounded.", F)
Q(95349, "The Earthen Ring", "Mulgore", 13, "forever_winds",
    "Alaana Stormwalker awaited the first Windshaper arrivals from Zephras in Mulgore.",
    "The crisis had delayed the Windshaper delegation, leaving a small vanguard to sail first.",
    "The arrival reached Alaana while the Windshapers were still establishing a foothold on Azeroth.",
    "Mulgore received the vanguard from Zephras, with the rest of the delegation still delayed.", F)

-- Durotar's ordinary work and reports connect the valley, coast and capital.
Q(781, "Attack on Camp Narache", "Mulgore", 4, "horde_narache",
    "The Bristleback map laid out plans for a prolonged siege of Camp Narache.",
    "A captured map held a warning for Chief Hawkwind and the village.",
    "Hawkwind had the warning needed to call for help from Bloodhoof Village.",
    "The siege plans reached the chief before the threatened attack.")
Q(5441, "Lazy Peons", "Durotar", 4, "horde_trials",
    "The valley's lumber workers kept falling asleep, to their overseer's anger.",
    "Keeping lumber work moving in the valley involved an overseer's blackjack.",
    "The sleeping peons were put back to work, and the blackjack was returned.",
    "The overseer's task ended with the workers roused and his blackjack back in hand.")
Q(6394, "Thazz'ril's Pick", "Durotar", 4, "horde_trials",
    "Thazz'ril had left his favorite pick in a cave that now held vicious creatures.",
    "A spell made Thazz'ril's lost pick visible in the dark, near the cave's waterfalls.",
    "The pick was back with Thazz'ril, who still hoped to find a place to mine.",
    "Thazz'ril recovered the tool left behind during his mineral survey.")
Q(2161, "A Peon's Burden", "Durotar", 5, "horde_trade",
    "Ukor had carried food to the Valley of Trials, only to find it was not needed.",
    "A peon's unwanted delivery still needed carrying back to the Razor Hill inn.",
    "Innkeeper Grosk received the food for his shelves and offered refreshment in return.",
    "Ukor's load reached Grosk, where the unused provisions could return to the inn's stores.")
Q(791, "Carry Your Weight", "Durotar", 7, "horde_trade",
    "An aging watchman made useful goods for younger fighters when his signal horn was quiet.",
    "Canvas carried by humans and centaurs could become a bag in the watchman's hands.",
    "The gathered canvas became a bag for carrying belongings.",
    "The watchman's work supplied a practical reward: a new bag.")
Q(805, "Report to Sen'jin Village", "Durotar", 5, "horde_darkspear",
    "News of the Burning Blade in the valley needed to reach Master Gadrin.",
    "Sen'jin Village was the next place to ask how far the cult's influence had spread.",
    "Gadrin received the report and described the Darkspears' own troubles on the Echo Isles.",
    "The valley's warning reached Gadrin; Sen'jin had dangers of its own offshore.")
Q(784, "Vanquish the Betrayers", "Durotar", 7, "horde_roads",
    "Lieutenant Benedict's forces had retaken Tiragarde Keep after Proudmoore's defeat.",
    "The human garrison at Tiragarde again threatened the settlements of Durotar.",
    "The attack on Benedict and his garrison answered Razor Hill's orders.",
    "Victory at Tiragarde checked the returning forces at the keep.")
Q(786, "Thwarting Kolkar Aggression", "Durotar", 8, "horde_roads",
    "Three Kolkar leaders held separate plans for attacks on Durotar's trolls and orcs.",
    "Beyond the ridge at Kolkar Crag, stolen intelligence had exposed preparations for an invasion.",
    "The three sets of attack plans were destroyed before the invasion could begin.",
    "Destroying the Kolkar plans disrupted the threatened assault on Durotar.")
Q(818, "A Solvent Spirit", "Durotar", 7, "horde_trade",
    "An elderly practitioner relied increasingly on alchemy as eyesight and other powers faded.",
    "Makrura eyes and crawler mucus from Durotar's coast were needed for alchemical work.",
    "The intact eyes and mucus supplied the requested ingredients.",
    "The coastal gathering ended with the materials delivered and the work acknowledged.")
Q(825, "From The Wreckage....", "Durotar", 8, "horde_roads",
    "Proudmoore's wrecked fleet still lay off the coast east of Tiragarde Keep.",
    "Alliance tools in the sunken ships offered a chance to study unfamiliar machinery.",
    "The recovered tools were set aside for the next caravan to Orgrimmar.",
    "The salvage supplied tools for study; their onward journey to the capital was being arranged.")
Q(830, "The Admiral's Orders", "Durotar", 7, "horde_roads",
    "A weathered envelope carried Admiral Proudmoore's seal.",
    "The document from Tiragarde looked important enough to put before Razor Hill's commander.",
    "Gar'Thok received the orders and recognized troubling news in them.",
    "Proudmoore's document reached Gar'Thok in Razor Hill.", nil, true)
Q(831, "The Admiral's Orders", "Orgrimmar", 7, "horde_roads",
    "Gar'Thok feared that Proudmoore's plans would outlive both the admiral and Benedict.",
    "Nazgrel needed the captured orders in Thrall's chamber in Orgrimmar.",
    "Nazgrel received the orders and prepared to counsel Thrall.",
    "The warning reached Nazgrel, bringing the threat on Durotar's coast before the capital.", nil, true)
Fallback("The Admiral's Orders", "horde_roads",
    "Proudmoore's written orders held a warning for the Horde's commanders.",
    "The admiral's plans remained a concern after his death.",
    "The captured orders had been passed on for attention.",
    "The document's warning had reached another pair of hands.", {V .. " #830, #831"})
Q(837, "Encroachment", "Durotar", 10, "horde_roads",
    "Razormane camps remained fortified among the brambles west of Razor Hill.",
    "The settlement's guards wanted the remaining quilboar positions cleared.",
    "The camps were cleared for the guards to deal with their abandoned structures.",
    "Word could go back that the targeted Razormane lairs had been emptied.")
Q(816, "Lost But Not Forgotten", "Durotar", 11, "horde_roads",
    "Kron had gone to hunt crocolisks along the Southfury River and had not returned.",
    "A mother waited for news of the son who had left after their argument.",
    "The recovered sign of Kron's fate ended his mother's uncertainty and allowed her mourning to begin.",
    "Kron's mother learned that he was dead and gave away the gift she had kept for his return.")
Q(806, "Dark Storms", "Durotar", 12, "horde_blade",
    "Fizzle Darkstorm and his Burning Blade followers had camped in Thunder Ridge.",
    "The cult's foothold in Thunder Ridge centered on a goblin warlock.",
    "Fizzle's claw supplied proof that the warlock had been killed.",
    "Fizzle Darkstorm's death removed one of the cult's agents from Durotar.")
Q(828, "Margoz", "Durotar", 12, "horde_blade",
    "Margoz knew more about the Burning Blade sheltering in Skull Rock.",
    "The shaman camped between the coast and Drygulch Ravine had advice about the cult.",
    "Margoz received the referral and recognized the work already reported from Durotar.",
    "The inquiry reached Margoz before any further action against Skull Rock.")
Q(832, "Burning Shadows", "Orgrimmar", 12, "horde_blade",
    "The Eye of Burning Shadow carried a voice calling for Gazz'uz and naming Neeru Fireblade.",
    "A pendant recovered from the cultists linked their warning to Neeru's name.",
    "Neeru took the pendant for study and claimed uncertainty about its message.",
    "The Eye of Burning Shadow reached Neeru, who offered no clear explanation for the voice.")
Q(809, "Ak'Zeloth", "The Barrens", 13, "horde_blade",
    "Neeru identified the Demon Seed on Dreadmist Peak as an object of the cult's power.",
    "Ak'Zeloth at Far Watch Post had instructions for dealing with the Demon Seed.",
    "Ak'Zeloth received Neeru's request and agreed to explain how to destroy the Seed.",
    "The referral reached Far Watch Post; the Seed itself remained to be dealt with.")
Q(924, "The Demon Seed", "The Barrens", 14, "horde_blade",
    "A demonic altar on Dreadmist Peak held the Demon Seed.",
    "Ak'Zeloth's power stone could disrupt the Seed's connection to the Legion, but its strength would not last.",
    "The Demon Seed was destroyed, sending out a surge of power that Ak'Zeloth had felt.",
    "Ak'Zeloth confirmed the Seed's destruction and warned that others might have noticed the released power.")

-- The Crossroads: supplies, hunts and a mystery beneath the water.
Q(854, "Journey to the Crossroads", "The Barrens", 12, "horde_roads",
    "The orcs at the Crossroads needed help from their allies in Mulgore.",
    "Thork awaited assistance where the roads through the Barrens met.",
    "Thork welcomed the arrival from the direction of Thunder Bluff.",
    "Thork received the new arrival inside the Crossroads.", nil, true)
Q(98024, "Journey to the Crossroads", "The Barrens", 13, "horde_roads",
    "After the passage from the elemental plane, the Warchief pointed toward the Crossroads' needs.",
    "Service in the Barrens offered a place to begin helping the Horde in this world.",
    "Thork received the Warchief's referral and warned how harsh the Barrens could be.",
    "The introduction reached Thork, who judged the new arrival by the work still ahead.", nil, true)
Fallback("Journey to the Crossroads", "horde_roads",
    "Thork and the people of the Crossroads needed assistance.",
    "The settlement at the meeting of the roads drew help from beyond the Barrens.",
    "Thork received the arrival at the Crossroads.",
    "The referral brought another helper to the settlement.", {V .. " #854, #98024"})
Q(860, "Sergra Darkthorn", "The Barrens", 10, "horde_hunts",
    "Sergra Darkthorn guided hunters beginning their work in the Barrens.",
    "The beasts beyond Mulgore offered different lessons, with Sergra at the Crossroads as their first guide.",
    "Sergra began her teaching with a reminder that hunting meant more than killing prey.",
    "Sergra welcomed the new hunter to a course of lessons on the dry plains.")
Q(871, "Disrupt the Attacks", "The Barrens", 12, "horde_roads",
    "Razormane raids on the Durotar road threatened the Crossroads' supplies.",
    "Scouts were still looking for the raiders' leader among the thorn-covered dens.",
    "The attacks on the Razormane reduced their numbers along the supply route.",
    "The first strike against the raiders was complete, though their leader's part remained unresolved.")
Q(872, "The Disruption Ends", "The Barrens", 15, "horde_roads",
    "A scout identified Kreenig Snarlsnout as the leader of the caravan raids.",
    "Kreenig's band operated just south of the road carrying supplies from Durotar.",
    "Kreenig's tusk proved the raiding leader was dead, weakening the attacks on the caravans.",
    "The supply raids lost their leader with Kreenig Snarlsnout's death.")
Q(867, "Harpy Raiders", "The Barrens", 15, "horde_roads",
    "Witchwing harpies had been taking supplies from the Horde's caravans.",
    "The first strike against the Witchwings targeted the raiders below their senior leaders.",
    "Witchwing talons proved the first attack on the raiders was complete.",
    "The caravan defense had begun with a blow against the harpies and roguefeathers.")
Q(875, "Harpy Lieutenants", "The Barrens", 16, "horde_roads",
    "Witchwing Slayers in the Dry Hills carried rings marking their rank.",
    "The campaign against the harpy raids moved up to the lieutenants who directed others.",
    "The lieutenants' rings supplied proof of the strike against the Witchwing command.",
    "The six rings accounted for the lieutenants targeted in the Dry Hills.")
Q(876, "Serena Bloodfeather", "The Barrens", 20, "horde_roads",
    "Serena Bloodfeather's attacks on caravans were described as revenge for her sister's death.",
    "The campaign's final target was Serena, whose sister had been killed by Rexxar.",
    "Serena's head supplied proof that the leader of the revenge attacks was dead.",
    "The campaign against Serena ended with her death and the promised reward.")
Q(850, "Kolkar Leaders", "The Barrens", 16, "horde_kolkar",
    "New leaders were rallying the Kolkar, turning scattered bands into a greater threat.",
    "Barak Kodobane camped near the Forgotten Pools, the first leader marked for attack.",
    "Barak's head confirmed the death of one of the Kolkar's capable leaders.",
    "The campaign against the Kolkar leadership began with Barak Kodobane's defeat.")
Q(851, "Verog the Dervish", "The Barrens", 18, "horde_kolkar",
    "Verog wandered widely, but the command tent at the Stagnant Oasis offered a way to draw him out.",
    "An alarm among the Kolkar near the oasis could bring Verog to their defense.",
    "Verog's head supplied proof that the second leader had been defeated.",
    "The disturbance at the Stagnant Oasis ended with Verog's death.")
Q(852, "Hezrul Bloodmark", "The Barrens", 19, "horde_kolkar",
    "Hezrul Bloodmark led the Barrens Kolkar from the Lushwater Oasis.",
    "The campaign now turned against the fierce leader above Barak and Verog.",
    "Hezrul's head confirmed the defeat of the Kolkar leader.",
    "Hezrul Bloodmark was dead, dealing the Kolkar another blow to their leadership.")
Q(855, "Centaur Bracers", "The Barrens", 14, "horde_kolkar",
    "A bounty on Kolkar bracers supported the Horde's contested holdings in the Barrens.",
    "The centaur troops remained a threat beyond the individual leaders marked for death.",
    "The gathered bracers earned the bounty for reducing the Kolkar ranks.",
    "The bracers accounted for losses among the centaur warriors, without ending the wider conflict.")
Q(886, "The Barrens Oases", "The Barrens", 10, "horde_oases",
    "Thunder Bluff's druids sensed a strange power leaking into the Barrens.",
    "Tonga Runetotem had been sent to investigate and needed help at the Crossroads.",
    "Tonga received the promised assistance for his inquiry into the oases.",
    "The druids' referral reached Tonga, while the source of the power remained a mystery.")
Q(870, "The Forgotten Pools", "The Barrens", 13, "horde_oases",
    "New oases had begun to stir with life in a country long left dry by catastrophe.",
    "Tonga's search for the returning power began beneath the Forgotten Pools.",
    "A fissure leaking gas beneath the water supplied the first clue.",
    "Tonga learned of the bubbling fissure, though its meaning was not yet clear.")
Q(877, "The Stagnant Oasis", "The Barrens", 16, "horde_oases",
    "Dead seeds offered a test of the power rising through the oasis fissures.",
    "Tonga wanted dried, infertile seeds placed beneath the Stagnant Oasis's waters.",
    "The seeds revived, showing that the power below the oasis could restore life.",
    "Tonga received evidence that the dead seeds had responded to the fissure's power.")
Q(880, "Altered Beings", "The Barrens", 16, "horde_oases",
    "Tonga wanted to know how the oasis waters affected the creatures drinking from them.",
    "Snapjaw shells from the Lushwater and Stagnant Oases offered another way to study the change.",
    "The shells reached Tonga for examination.",
    "Tonga had specimens from the oasis beasts, though his study still lay ahead.")
Q(903, "Prowlers of the Barrens", "The Barrens", 15, "horde_hunts",
    "Prowlers hunted in the tall grasses southwest of the Crossroads.",
    "Sergra's next lesson concerned predators capable of turning on their hunters.",
    "The completed prowler hunt led Sergra to propose a champion among the cats.",
    "Sergra acknowledged the hunt through the grass and prepared a harder test.")
Q(881, "Echeyakee", "The Barrens", 16, "horde_hunts",
    "Echeyakee's lair lay among giant kodo bones northeast of the Crossroads.",
    "A horn could summon the white lion whose stealth had earned the name Whitemist.",
    "Echeyakee was defeated, and Sergra framed the hunt as a lesson in subtlety and mercy.",
    "The white lion's hunt ended; Sergra's teaching turned to the qualities the beast represented.")
Q(905, "The Angry Scytheclaws", "The Barrens", 17, "horde_hunts",
    "The next hunting test reached beyond the quarry to the scytheclaws' nests.",
    "Sunscale feathers were to be placed in nests southwest of the Stagnant Oasis.",
    "The feathers reached the nests, completing the test in the raptors' own lairs.",
    "Sergra acknowledged the placement of the feathers among the scytheclaw nests.")
Q(882, "Ishamuhale", "The Barrens", 19, "horde_hunts",
    "A zhevra carcass beside the dead tree northwest of Ratchet could lure Ishamuhale.",
    "The raptor called Speartooth was the next quarry along the hunting path.",
    "Ishamuhale's fang became proof of the hunt, with a reminder to temper strength.",
    "The hunt ended with Speartooth's defeat and the presentation of his fang.")
Q(907, "Enraged Thunder Lizards", "The Barrens", 18, "horde_hunts",
    "The southern plains held thunder lizards large enough to make the ground rumble.",
    "Stormsnouts, Stormhides and Thunderheads presented a different danger from the smaller quarry.",
    "Proof of victory over the thunder lizards completed the next hunting test.",
    "The thunder lizard hunt was recognized as another completed part of the training.")
Q(913, "Cry of the Thunderhawk", "The Barrens", 20, "horde_hunts",
    "Thunderhawk wings were the proof required as the local hunting lessons approached their end.",
    "The hunting path turned toward the thunderhawks roaming the Barrens.",
    "The wings proved the hunt complete, and the teacher's final advice pointed beyond these lessons.",
    "The thunderhawk hunt closed this course of teaching without ending the hunter's wider path.")

-- Ratchet's harbor joins modest cargoes, damaged machines and coastal danger.
Q(1492, "Wharfmaster Dizzywig", "The Barrens", 11, "horde_ratchet",
    "The last caravan had gone, leaving a crate of potions and reagents to reach Ratchet by other means.",
    "Dizzywig could book the crate onto a ship bound for Blackwater Cove.",
    "Dizzywig entered the crate in his ledger for the next tide's sailing.",
    "The cargo reached the wharfmaster, who found room for it aboard the ship.")
Q(887, "Southsea Freebooters", "The Barrens", 14, "horde_ratchet",
    "The Freebooters had set up camp south of Ratchet after raiding Gazlowe's ships.",
    "The Trade Fleets had failed to keep Gazlowe's goods safe from coastal pirates.",
    "The strike against the pirates eased Gazlowe's immediate trouble, but his stolen goods remained missing.",
    "Gazlowe rewarded the attack on the Freebooters and turned attention to recovering his cargo.")
Q(890, "The Missing Shipment", "The Barrens", 14, "horde_ratchet",
    "Gazlowe wanted the dock records checked before blaming pirates for a late shipment.",
    "His ledger needed comparing with Dizzywig's logs at the waterfront.",
    "Dizzywig received the ledger and began checking the shipment against his records.",
    "The inquiry reached the wharfmaster's books; no cargo had yet been recovered.", nil, true)
Q(892, "The Missing Shipment", "The Barrens", 14, "horde_ratchet",
    "Dizzywig's records showed no misplaced delivery of Gazlowe's goods.",
    "The dockside check left the Freebooters as the likely explanation for the missing shipment.",
    "Gazlowe received Dizzywig's answer and turned to retrieving the goods from the pirates.",
    "The report ruled out a warehouse mistake, leaving the cargo recovery still to come.", nil, true)
Fallback("The Missing Shipment", "horde_ratchet",
    "Gazlowe's overdue cargo raised questions about Ratchet's shipping records and the coastal pirates.",
    "A missing shipment drew attention to the ledgers at Ratchet's docks.",
    "The inquiry into the overdue goods had moved forward.",
    "Another report about the missing cargo had been delivered.", {V .. " #890, #892"})
Q(888, "Stolen Booty", "The Barrens", 16, "horde_ratchet",
    "Gazlowe's observatory lacked its smaller lens, and his shipment of boots had also disappeared.",
    "The pirate camp held two cargoes Gazlowe particularly wanted returned.",
    "The lens and boots were returned to Gazlowe.",
    "Gazlowe recovered the observatory lens and the missing boot shipment, then offered future work.")
Q(895, "WANTED: Baron Longshore", "The Barrens", 16, "horde_ratchet",
    "Gazlowe's notice named Baron Longshore, captain of the Heedless, as wanted for piracy.",
    "The bounty demanded identifiable remains of the Freebooter captain.",
    "Gazlowe accepted proof of Longshore's death and paid the bounty.",
    "The captain of the Heedless would no longer lead raids on Gazlowe's shipping.")
Q(891, "The Guns of Northwatch", "The Barrens", 20, "horde_ratchet",
    "Northwatch's guns had sunk another vessel sailing the Merchant Coast.",
    "Captain Fairmount and her cannoneers were firing on ships from the hold.",
    "The targeted guns were silenced, and the soldiers' medals supplied proof of the attack.",
    "Fairmount and the cannoneers were defeated; the fleet's dead still needed recovery.")
Q(898, "Free From the Hold", "The Barrens", 20, "horde_ratchet",
    "Firebough had survived a sunken moonshine transport only to be imprisoned at Northwatch.",
    "The captured deckhand wanted help getting back to Ratchet from the hold.",
    "Firebough's rescue brought news of survival to people who had thought the deckhand dead.",
    "The escape was recognized by the Thalo'dan Privateers, who had given Firebough up for lost.")
Q(894, "Samophlange", "The Barrens", 14, "horde_ratchet",
    "The Venture Company was experimenting with a samophlange near the Sludge Fen.",
    "A copied operating manual offered a way into the research facility's unfamiliar controls.",
    "The control console was reached, with all three valves still showing open.",
    "The machinery's gauges and controls were found operating normally; removing the device still required work.", nil, true)
Q(900, "Samophlange", "The Barrens", 14, "horde_ratchet",
    "The console showed three open valves preventing the apparatus from being shut down.",
    "Closing the control valves was the next step in disengaging the machine.",
    "The valve lights dimmed, freeing the switch that could shut off the apparatus.",
    "All three valves were closed, making the shutdown control usable.", nil, true)
Q(901, "Samophlange", "The Barrens", 14, "horde_ratchet",
    "The deactivated apparatus still held the samophlange behind a locked panel.",
    "A key was needed before the idle console could be opened.",
    "The key unlocked the console, and the last red light went out.",
    "Power drained from the unlocked terminal, leaving the device accessible.", nil, true)
Q(902, "Samophlange", "The Barrens", 16, "horde_ratchet",
    "A tangle of wires and tubing concealed the samophlange inside the open console.",
    "The exposed device could finally be removed from its housing for study.",
    "The device was handed over for study, with Undermine its proposed destination.",
    "Even after its delivery, the samophlange's workings remained a puzzle.", nil, true)
Fallback("Samophlange", "horde_ratchet",
    "The Venture Company's samophlange required careful work around unfamiliar machinery.",
    "An experimental device drew Ratchet's interest toward a Venture Company facility.",
    "Another stage of the work around the samophlange was complete.",
    "The recorded task advanced the effort to obtain the experimental device.", {V .. " #894, #900, #901, #902"})
Q(858, "Ignition", "The Barrens", 18, "horde_ratchet",
    "Wizzlecrank had climbed into a Venture Company shredder without its ignition key.",
    "The supervisor above the derrick held the key needed to move the stolen machine.",
    "Wizzlecrank received the key and began working out the shredder's controls.",
    "The key made an escape possible, but the machine still had to be brought out.")
Q(863, "The Escape", "The Barrens", 18, "horde_ratchet",
    "Wizzlecrank was ready to attempt an escape in the unfamiliar shredder.",
    "The stolen prototype had to leave Venture Company ground with its improvised pilot.",
    "News of the wrecked prototype prompted plans for a salvage team at Wizzlecrank's location.",
    "The escape left a damaged shredder to recover, and Ratchet arranged to salvage what remained.", nil, true)
Fallback("The Escape", nil,
    "Getting out of danger required practical help.",
    "An escape depended on assistance before the immediate difficulty could be left behind.",
    "The requested help with the escape was supplied.",
    "The recorded escape errand was complete.", {V .. " #114, #863"})
pack.quests["The Escape"].thread = false
pack.quests["The Escape"].threadLabel = false
Q(896, "Miner's Fortune", "The Barrens", 18, "horde_ratchet",
    "News of a fist-sized emerald at Boulder Lode mine had reached Ratchet's wharfmaster.",
    "Dizzywig offered a share of the value if the Venture Company miners' emerald could be obtained.",
    "The emerald reached Dizzywig, who calculated and paid the promised share.",
    "Dizzywig accepted the great gem and settled the bargain.")
Q(865, "Raptor Horns", "The Barrens", 18, "horde_ratchet",
    "A proposed smart drink depended on the untested idea that raptor intelligence resided in the horns.",
    "Intact scytheclaw horns were wanted for a profitable experiment in drinks.",
    "The horns were delivered for grinding and mixing with wine; the drink's claims remained unproved.",
    "The experiment gained its ingredients, without establishing whether they could make anyone smarter.")
Q(866, "Root Samples", "The Barrens", 16, "horde_oases",
    "Oasis water appeared to give the Barrens' herbs slightly different properties.",
    "Root samples could be grown and compared with herbs from other regions.",
    "The roots were received for cultivation and study of their possible properties.",
    "The samples supplied the planned comparison, leaving any valuable discovery for later research.")
Q(862, "Dig Rat Stew", "The Barrens", 23, "horde_trade",
    "The dig rats overrunning Bael Modan could also fill a stew pot.",
    "A promised meal depended on gathering rats from the dwarven excavation.",
    "The gathered rats were cooked into Dig Rat Stew.",
    "The rat hunt ended with a prepared meal as promised.")
Q(899, "Consumed by Hatred", "The Barrens", 20, "horde_roads",
    "The call for quilboar tusks came from someone whose desire for revenge had not eased.",
    "A watcher scanned the horizon for quilboar and wanted more of them killed.",
    "The delivered tusks were welcomed, but the demand for vengeance remained unsatisfied.",
    "Proof of the quilboars' deaths brought thanks without ending the bitterness behind the task.")

-- Deliveries make the capitals part of everyday life without asserting a flight.
Q(853, "Apothecary Zamah", "Thunder Bluff", 15, "horde_apothecary",
    "Helbrim's spore emulsion needed to reach the Pools of Vision before it lost potency.",
    "Zamah worked in the cave beneath Thunder Bluff's Spirit Rise, waiting for the Barrens sample.",
    "Zamah received the emulsion while it was still potent.",
    "The delivery preserved Helbrim's preparation long enough for his colleague to receive it.")
Q(6361, "A Bundle of Hides", "The Barrens", 10, "horde_trade",
    "Jahan's Barrens hides were meant for Ahanu's leatherwork in Thunder Bluff.",
    "Devrak could arrange transport for a bundle linking the Crossroads' hunters to the city's craftspeople.",
    "Devrak was ready to arrange transport for the hides.",
    "The bundle reached the Crossroads wind rider master, with Thunder Bluff still ahead.")
Q(6362, "Ride to Thunder Bluff", "Thunder Bluff", 10, "horde_trade",
    "Ahanu waited for the hides at Hewa's Armory near the wind rider tower.",
    "A bundle from the Barrens was bound for leather goods in Thunder Bluff.",
    "Ahanu received the hides and prepared to work them.",
    "Ahanu paid for the delivery and turned to the new bundle of hides.")
Q(6363, "Tal the Wind Rider Master", "Thunder Bluff", 10, "horde_trade",
    "Ahanu's finished leather goods were ready for Jahan to sell at the Crossroads.",
    "The return cargo needed transport arrangements with Tal in Thunder Bluff.",
    "Tal offered transport for the leather goods bound for Jahan.",
    "Tal could send the finished leatherwork back toward the Crossroads.")
Q(6364, "Return to Jahan", "The Barrens", 10, "horde_trade",
    "The Crossroads' many hunters and adventurers offered a market for Ahanu's leatherwork.",
    "Jahan awaited finished goods in exchange for the hides sent to Thunder Bluff.",
    "Jahan received Ahanu's products for sale at the Crossroads.",
    "The exchange ended with new leather goods in Jahan's stock.")
Q(6365, "Meats to Orgrimmar", "The Barrens", 10, "horde_trade",
    "Zargh had choice cuts of meat for Gryshka, an innkeeper in Orgrimmar.",
    "A gift for the capital's inn began with a transport request to Devrak.",
    "Devrak received the request and offered passage for the delivery.",
    "The meat reached the wind rider master's part of the errand, still bound for Gryshka.")
Q(6384, "Ride to Orgrimmar", "Orgrimmar", 10, "horde_trade",
    "Gryshka's inn in the Valley of Strength was expecting Zargh's meat.",
    "The delivery connected the Crossroads' butcher with an inn near Orgrimmar's Skytower.",
    "Gryshka received the fine cuts and looked forward to cooking them.",
    "Zargh's gift reached Gryshka's kitchen in Orgrimmar.")
Q(6385, "Doras the Wind Rider Master", "Orgrimmar", 10, "horde_trade",
    "Gryshka had written a letter thanking Zargh for the meat.",
    "Doras could arrange the return journey for the innkeeper's letter.",
    "The letter reached Doras's part of the errand, with delivery to Zargh still ahead.",
    "Doras received the request for transport back to the Crossroads.")
Q(6386, "Return to the Crossroads", "The Barrens", 10, "horde_trade",
    "Zargh was waiting to hear how Gryshka had liked his gift.",
    "The capital errand ended with an innkeeper's letter returning to the Crossroads.",
    "Zargh received Gryshka's thanks and paid for the help.",
    "The letter brought Zargh news that his choice cuts had been appreciated.")

-- Silverpine's missing scouts, competing experiments and stolen dead. These
-- are recorded quest stages, not a presumed route through the entire forest.
local HS, HA, HF, HR, HB = "horde_silverpine", "horde_arugal", "horde_fenris", "horde_deliah", "horde_hillsbrad"
pack.threads[HS] = "the scouts of Silverpine"
pack.threads[HA] = "Dalar's inquiry into Arugal's magic"
pack.threads[HF] = "the stolen dead of Fenris Isle"
pack.threads[HR] = "the ring from the ferry"
pack.threads[HB] = "the Forsaken campaign in Hillsbrad"
Q(421, "Prove Your Worth", "Silverpine Forest", 10, HA,
    "Moonrage Whitescalps prowled near the road, complicating the Forsaken's plans for Silverpine.",
    "Dalar needed help against the worgen before entrusting anyone with his inquiry into Arugal's magic.",
    "The fighting against the Whitescalps earned Dalar's approval for more difficult work.",
    "Dalar accepted the service against the beasts as grounds for further assignments.")
Q(422, "Arugal's Folly", "Silverpine Forest", 11, HA,
    "A Deathstalker had spotted Arugal's spellbooks at the wheat farm north of the bridge.",
    "Dalar wanted the spell called Remedy of Arugal to understand the wizard's work.",
    "The recovered remedy gave Dalar the spell he had been seeking.",
    "Arugal's written spell reached Dalar for study; its usefulness remained to be established.", nil, true)
Q(423, "Arugal's Folly", "Silverpine Forest", 14, HA,
    "Dalar's examination pointed toward enchanted items used to reinforce Arugal's spells.",
    "Shackles carried by Moonrage gluttons and darksouls offered samples of the enchantments.",
    "Dalar received the shackles, though he questioned whether the samples held enough energy.",
    "The enchanted restraints reached the researcher, leaving the harder work of understanding them ahead.", nil, true)
Q(424, "Arugal's Folly", "Silverpine Forest", 15, HA,
    "Dalar's research was taking time while reports placed Arugal's influence in Deep Elem Mine.",
    "The tainted foreman Grimson the Pale stood between the Forsaken and the mine's resources.",
    "Grimson's death removed the foreman, and Dalar expected the mine to supply the Forsaken advance.",
    "The strike dealt with Grimson while Dalar's study of Arugal's enchantments continued.", nil, true)
Q(99, "Arugal's Folly", "Silverpine Forest", 15, HA,
    "Pyrewood's people appeared human by day and became Moonrage worgen after sunset.",
    "Dalar wanted Pyrewood shackles to study the enchantment behind the village's changes.",
    "The shackles supplied Dalar with more evidence for his research against Arugal.",
    "Dalar praised the gathered knowledge, but undoing the curse remained a promise.", nil, true)
Q(98298, "Arugal's Folly", "Silverpine Forest", 16, HA,
    "Dalar concluded that Arugal's shackles bound worgen rather than creating them.",
    "Reports of the curse spreading near the Greymane Wall sent Dalar's inquiry toward the beasts themselves.",
    "Dalar judged the remains evidence that Arugal had not caused the curse, leaving the search for a remedy unfinished.",
    "The examination discredited Arugal's remedy in Dalar's eyes; it did not cure the worgen.", nil, true)
Fallback("Arugal's Folly", HA,
    "Dalar's research concerned Arugal's spells and the worgen troubling Silverpine.",
    "The Forsaken's efforts in the forest included an inquiry into the wizard's enchantments.",
    "Dalar's work concerning Arugal received further help.",
    "Another part of the inquiry into the worgen's magic was finished.", {V .. " #422, #423, #424, #99, #98298"})
Q(428, "Lost Deathstalkers", "Silverpine Forest", 12, HS,
    "Rane and Quinn Yorick had failed to return from reconnaissance in northern Silverpine.",
    "The Sepulcher needed a search of the farms where its missing scouts had begun their mission.",
    "The missing Deathstalkers were found at the farm, still in need of help.",
    "The search reached the missing Deathstalkers and established that they had survived.")
Q(429, "Wild Hearts", "Silverpine Forest", 11, HS,
    "Ivar the Foul had badly injured Quinn, and Rane sought an apothecary's help for his recovery.",
    "Discolored worg hearts could supply Renferrel with ingredients for a healing potion.",
    "Renferrel accepted the hearts and supplied the recipe while preparing Quinn's potion.",
    "The ingredients reached the Sepulcher, but the medicine still needed carrying back to Quinn.")
Q(430, "Return to Quinn", "Silverpine Forest", 11, HS,
    "Renferrel's potion was ready for the injured Deathstalker waiting at the farm.",
    "Quinn's recovery depended on getting the prepared medicine back from the Sepulcher.",
    "Quinn drank the potion and felt it working, expecting to be able to travel soon.",
    "The medicine reached Quinn, who acknowledged its help while he continued recovering.")
Q(425, "Ivar the Foul", "Silverpine Forest", 12, HS,
    "Ivar still lurked in the barn while Quinn recovered from the ghoul's attack.",
    "Rane needed the nearby ghoul stopped before he could strike the wounded scout again.",
    "Ivar's death removed the immediate danger, and Rane promised to include the help in her report.",
    "Rane thanked the work against Ivar, giving Quinn time to recover without that ghoul returning.")
Q(435, "Escorting Erland", "Silverpine Forest", 11, HS,
    "Hungry wolves kept Erland from reaching his teammate Rane Yorick.",
    "Another Deathstalker's report needed an escort through Silverpine's wolf-haunted paths.",
    "Erland reached Rane with assistance, and she thanked the escort.",
    "The safe arrival put Rane's uncertainty about Erland's fate to rest.")
Q(437, "The Dead Fields", "Silverpine Forest", 14, HF,
    "The banshee Nightlash had repeatedly driven the Forsaken's assaults away from the Rot Hide base.",
    "The old farm called the Dead Fields remained protected by Nightlash's magic.",
    "Nightlash's essence supplied proof of her destruction at the Dead Fields.",
    "The banshee's dust confirmed the loss of a defender who had thwarted earlier assaults.")
Q(438, "The Decrepit Ferry", "Silverpine Forest", 16, HF,
    "Scourge patrols surrounded the Decrepit Ferry east of the Sepulcher.",
    "Hadrec wanted to know why the Rot Hides and other undead had occupied the ferry.",
    "The boat held wrapped corpses, with the opposite dock on Fenris Isle visible across the lake.",
    "The investigation found a cargo of bodies and a route toward Fenris Isle.")
Q(439, "Rot Hide Clues", "Silverpine Forest", 16, HF,
    "A ring on one of the ferry's corpses bore an engraving naming Deliah.",
    "The dead woman's ring offered evidence to carry back from the corpse-filled boat.",
    "Hadrec concluded that the Rot Hides were carrying bodies from Tirisfal's mass graves to Fenris Isle.",
    "The ring and the report pointed Hadrec toward stolen bodies as the ferry's cargo.")
Q(443, "Rot Hide Ichor", "Silverpine Forest", 17, HF,
    "The apothecaries hoped the fluid in the Rot Hide gnolls would reveal who had made them.",
    "An assault on Fenris Isle first required samples of the gnolls' strange ichor.",
    "Renferrel received the ichor for study, with the gnolls' nature and weaknesses still uncertain.",
    "The samples reached the apothecary; identifying their maker was work still to come.")
Q(444, "Rot Hide Origins", "Undercity", 17, HF,
    "Renferrel found warlock and necromantic magic in the ichor but could not draw a firm conclusion.",
    "Bethor Iceshard's magical knowledge offered another way to examine the Rot Hide samples.",
    "Bethor recognized old, powerful spells in the substance and began a divination.",
    "The sample reached Bethor, whose examination had not yet yielded its maker's name.")
Q(446, "Thule Ravenclaw", "Silverpine Forest", 16, HF,
    "Bethor identified the ichor as Thule Ravenclaw's work and supplied incantations to counter his spells.",
    "A former colleague's knowledge could help Renferrel prepare for an assault on Thule's stronghold.",
    "Renferrel received the magical scroll needed for a potion against Thule.",
    "The counterspells reached the apothecary; the confrontation on Fenris Isle still lay ahead.")
Q(448, "Report to Hadrec", "Silverpine Forest", 16, HF,
    "The plans for an assault on Fenris Isle needed to reach High Executor Hadrec.",
    "Hadrec could provide equipment before the attempt to confront Thule Ravenclaw.",
    "Hadrec accepted the report and offered aid from the Sepulcher's arsenal.",
    "The executor was briefed on Thule, leaving the actual assault still to be carried out.")
Q(442, "Assault on Fenris Isle", "Silverpine Forest", 24, HF,
    "Hadrec ordered a strike against Thule Ravenclaw in the Scourge stronghold on Fenris Isle.",
    "The inquiry into the Rot Hides had reached the necromancer behind them.",
    "Thule's death was confirmed, and Renferrel reported sensing the released energies from the Sepulcher.",
    "The assault killed Thule Ravenclaw, a blow Hadrec recognized as significant to the Forsaken.")
Q(440, "The Engraved Ring", "Tirisfal Glades", 16, HR,
    "The ring from the ferry might be traced through Magistrate Sevren's death records in Brill.",
    "Deliah's name offered a way to learn whose body the Rot Hides had taken.",
    "Sevren confirmed that a Deliah had lived in Brill and been buried in the mass grave.",
    "Brill's records gave the name a history, supporting the report that a buried body had been stolen.")
Q(441, "Raleigh and the Undercity", "Undercity", 16, HR,
    "Sevren directed the ring toward Raleigh, the husband of the Deliah recorded in Brill.",
    "Raleigh in the Trade Quarter could establish whether the ring belonged to his wife.",
    "Raleigh recognized Deliah's ring and spoke of his desire for revenge.",
    "The ring reached Deliah's husband, confirming its identity without settling his grievance.")
Q(530, "A Husband's Revenge", "Silverpine Forest", 20, HR,
    "Raleigh named his former friend Valdred as Deliah's murderer and wanted his hands as proof.",
    "Valdred had last been reported near the Greymane Wall, trying to escape into Gilneas.",
    "Valdred's hands reached Raleigh, who paid for his revenge and relinquished Deliah's ring.",
    "Raleigh accepted the proof of Valdred's death and kept the hands as a reminder of the betrayal.")
Q(264, "Until Death Do Us Part", "Silverpine Forest", 15, "horde_forsaken",
    "A Forsaken widow wanted a pendant left on the grave of the husband whose crusade had taken him from his family.",
    "The abandoned keepsake was bound for a neglected tomb at the Sepulcher.",
    "The pendant was placed on the grave, its gemstone appearing to lose its sheen.",
    "The keepsake lay on the coffin's carved hands, completing the widow's request.")
Q(460, "Resting in Pieces", "Silverpine Forest", 17, HF,
    "Thule's former servant Alaric survived as a severed head left to the Rot Hides as a plaything.",
    "Alaric believed his body lay in an unmarked grave near Fenris Keep's stable.",
    "Alaric's head reached the grave, where he found that his body had not been destroyed.",
    "The search reunited Alaric with his buried body; a resting place inside the keep was still to come.")
Q(461, "The Hidden Niche", "Silverpine Forest", 18, HF,
    "Alaric knew a concealed alcove in Fenris Keep that held something dear to Thule.",
    "A dusty shelf in the southwestern tower hid a place where Alaric wanted to be carried.",
    "Alaric opened the alcove and asked to be left there beyond the Rot Hides' reach.",
    "The hidden niche gave Alaric the resting place he requested, and he offered a reward.")
Q(491, "Wand to Bethor", "Undercity", 18, HF,
    "Thule had hidden a wand woven from the apprentice wands of three former friends.",
    "Alaric wanted the old token of friendship returned to Bethor Iceshard.",
    "Bethor recognized the Woven Wand and thanked its recovery after believing it lost.",
    "The wand returned to one of its makers, who said Thule had never invoked its power.")
Q(452, "Pyrewood Ambush", "Silverpine Forest", 15, HA,
    "A Forsaken operative hoped killing the Pyrewood Council would weaken Arugal's hold over the town.",
    "The council was expected back while Arugal attended to other business in the keep.",
    "The council was killed, but control of Pyrewood remained an ambition rather than an accomplished result.",
    "The ambush removed the council without establishing that the townsfolk had turned against Arugal.")
Q(516, "Beren's Peril", "Silverpine Forest", 21, HS,
    "Shadow Priest Allister had only scattered reports of undead preparing to attack the Forsaken. The trail led to Beren's Peril, a cave near the Dalaran wizards in Silverpine's hills.",
    "A cave called Beren's Peril concealed Ravenclaw undead. Shadow Priest Allister wanted them struck first, before the attack his scouts had warned of.",
    "Ravenclaw drudgers and guardians were slain in the cave. Allister praised the scouts whose reports had led to their hiding place.",
    "Ravenclaw drudgers and guardians fell at Beren's Peril. Allister hoped more such reports would help drive the Scourge from Forsaken lands.")
Q(493, "Journey to Hillsbrad Foothills", "Hillsbrad Foothills", 20, "horde_apothecary",
    "Pressure to develop the New Plague made sharing research important to the Royal Apothecary Society.",
    "Renferrel's latest findings were bound for Apothecary Lydon in Tarren Mill.",
    "Lydon received Renferrel's research and looked forward to studying it.",
    "The findings reached Tarren Mill, connecting the apothecaries' work across the two regions.")

-- The executor's orders are attributed to him; these stages neither declare a
-- character's allegiance nor turn assaults into a permanent conquest.
Q(527, "Battle of Hillsbrad", "Hillsbrad Foothills", 24, HB,
    "Tarren Mill's executor ordered attacks on the northern farms to disrupt Hillsbrad's food supply.",
    "The first orders named Farmer Ray and Farmer Getz among the targets in Hillsbrad Fields.",
    "The executor's sources confirmed the raid on the northern farms.",
    "The attacks on the fields fulfilled the first orders while the campaign continued.", nil, true)
Q(528, "Battle of Hillsbrad", "Hillsbrad Foothills", 25, HB,
    "Deathstalkers reported people fleeing the northern farm attacks into Hillsbrad's southern orchards.",
    "The executor ordered the campaign extended against the peasants seeking shelter in the fields.",
    "The executor accepted the attacks on the fleeing peasants as progress in his campaign.",
    "The southern fields had come under attack, and Tarren Mill's commander pressed his advantage.", nil, true)
Q(529, "Battle of Hillsbrad", "Hillsbrad Foothills", 26, HB,
    "Blacksmith Verringtan was arming Hillsbrad's resistance from the local forge.",
    "The executor demanded the deaths of the smith and apprentices, along with a shipment of their iron.",
    "The attack on Verringtan's forge was reported complete, with its iron shipment taken.",
    "The smith and his apprentices were dead, and the executor accepted the seized supplies.", nil, true)
Q(532, "Battle of Hillsbrad", "Hillsbrad Foothills", 26, HB,
    "Hillsbrad's people continued resisting around Magistrate Burnside and the town council.",
    "The executor's next orders targeted the leadership, the proclamation and the town registry.",
    "The executor received news of the strike on the magistrate and council.",
    "The town's leadership had been attacked, its proclamation destroyed and its registry seized.", nil, true)
Q(539, "Battle of Hillsbrad", "Hillsbrad Foothills", 28, HB,
    "The stolen registry identified Azureload Mine as a source of iron for Alliance armories.",
    "Foreman Bonds and the miners became the next targets of the executor's campaign.",
    "The executor welcomed the attack on Bonds and the miners as an opening to supply the Dark Lady's forces.",
    "The mine had been struck, and the executor spoke of using its ore for Forsaken weapons.", nil, true)
Q(541, "Battle of Hillsbrad", "Hillsbrad Foothills", 30, HB,
    "The executor directed the campaign toward the dwarven barracks at Dun Garok near Thoradin's Wall.",
    "Captain Ironhill and the dwarves aiding Hillsbrad were the targets of the final assault orders.",
    "The attack on Dun Garok and Captain Ironhill earned the executor's praise.",
    "The commander commended the fighting at Dun Garok, another blow in his continuing campaign.", nil, true)
Q(550, "Battle of Hillsbrad", "Undercity", 32, HB,
    "A sealed commendation was ready for Varimathras after the executor's Hillsbrad assignments.",
    "The field command wanted the Undercity to recognize the service recorded in its letter.",
    "Varimathras received the commendation and acknowledged the blows against Alliance forces in Hillsbrad.",
    "The campaign's report reached the Undercity and earned recognition from Varimathras.", nil, true)
Fallback("Battle of Hillsbrad", HB,
    "Tarren Mill's executor directed a campaign against Hillsbrad's people and their Alliance defenders.",
    "The Forsaken's orders concerned the farms, workshops and defenses of Hillsbrad.",
    "One assignment in the executor's campaign was finished.",
    "The executor acknowledged further service in Tarren Mill's campaign.", {V .. " #527, #528, #529, #532, #539, #541, #550"})
for _, id in ipairs({98298, 430, 442, 530, 461, 452, 550}) do pack.questIDs[id].importance = 4 end

-- Early Kalimdor routes absent from the starter pack's first editions.
local HT, HN, HK = "horde_stonetalon", "horde_freewind", "horde_arikara"
pack.threads[HT] = "the peril of Stonetalon's spirits"
pack.threads[HN] = "the camps of Thousand Needles"
pack.threads[HK] = "the summoning of Arikara"
Q(1060, "Letter to Jin'Zil", "Stonetalon Mountains", 20, HT,
    "Darsok had a letter for his old friend Jin'Zil in the mountains where the harpies originated.",
    "News of Serena Bloodfeather's death was bound for the witch doctor in Stonetalon.",
    "Jin'Zil received Darsok's letter and recalled the earlier fighting against the Bloodfeathers.",
    "The message reached Jin'Zil, carrying news between friends who had not spoken for years.")
Q(1061, "The Spirits of Stonetalon", "Stonetalon Mountains", 17, HT,
    "Seereth Stonebreak reported widespread logging while Stonetalon's spirits cried out against the destruction.",
    "The Horde had sent Seereth to the mountains, where she requested help near Greatwood Vale.",
    "Seereth welcomed the arrival at her camp. The Horde would need help against the plunderers of Stonetalon.",
    "At Seereth's camp, the appeal for help became a welcome: there was work against the forest's plunderers.")
Q(1062, "Goblin Invaders", "Stonetalon Mountains", 19, HT,
    "The Venture Company was cutting and burning the forest in Windshear Crag.",
    "Seereth sought a strike against the company's workers while the land's spirits suffered.",
    "Seereth praised the strike at the Venture Company's workers. To calm the suffering spirits, she thought the tauren elders' wisdom might be needed.",
    "The attack cost the Venture Company workers. Seereth called it a good first move, and looked to the elders for help with the spirits.")
Q(1063, "The Elder Crone", "Thunder Bluff", 18, HT,
    "Seereth believed tauren elders were needed to tend Stonetalon's wounded spirits.",
    "Magatha on Elder Rise was the elder Seereth knew to seek for spiritual counsel.",
    "Magatha received the request for counsel in Thunder Bluff.",
    "The appeal from Stonetalon reached the elder, leaving her advice still to follow.")
Q(1064, "Forsaken Aid", "Thunder Bluff", 18, HT,
    "Magatha proposed turning to the Forsaken's knowledge of disease to help remove Stonetalon's affliction.",
    "Apothecary Zamah served as a scholar and emissary beneath Thunder Bluff's Spirit Rise.",
    "Zamah received Magatha's referral and offered the Forsaken's assistance.",
    "The apothecary heard the request from the tauren elder, opening another avenue of help.")
Q(1065, "Journey to Tarren Mill", "Hillsbrad Foothills", 18, HT,
    "Zamah believed her colleague Lydon could supply a means of driving out the Venture Company.",
    "A note detailing Stonetalon's needs had to cross to Tarren Mill in Lordaeron.",
    "Lydon received Zamah's note and said he knew how to answer it.",
    "The request reached Tarren Mill, but Lydon's proposed remedy still needed making.")
Q(1066, "Blood of Innocents", "Hillsbrad Foothills", 23, HT,
    "Lydon proposed a toxin to render Venture Company workers weak and docile.",
    "Syndicate shadow mages at Durnholde kept the innocent blood required for his mixture.",
    "Lydon received the blood and began preparing the toxin.",
    "The ingredients reached the apothecary; the concoction had not yet gone to Stonetalon.")
Q(1067, "Return to Thunder Bluff", "Thunder Bluff", 23, HT,
    "Lydon's toxin needed Zamah's delivery method before it could be used against the Venture Company.",
    "The finished mixture was bound for Thunder Bluff for the next part of the plan.",
    "Zamah received Lydon's toxin and expected it to be effective against the company.",
    "The toxin reached Zamah, with its actual use against the Venture Company still ahead.")
Q(1086, "The Flying Machine Airport", "Stonetalon Mountains", 23, HT,
    "Zamah wanted the toxin placed at the small sky port she believed served the Venture Company.",
    "The company's messages and light cargo offered a possible route for the prepared poison.",
    "Zamah accepted the report that the port had been found and the toxin delivered.",
    "The poison reached the flying-machine port; whether it would reach headquarters remained uncertain.")
Q(4542, "Message to Freewind Post", "Thousand Needles", 25, HN,
    "Renewed centaur attacks called for an urgent warning to Cliffwatcher Longhorn at Freewind Post.",
    "The Great Lift's southern route led toward a settlement already troubled by caravan raids.",
    "Longhorn received the message and reported the slaughter of one of his supply caravans.",
    "The warning reached Freewind Post, where the centaur threat had already cost a caravan's lives.")
Q(4841, "Pacify the Centaur", "Thousand Needles", 25, HN,
    "Longhorn demanded a retaliatory attack on the centaur camp north of Freewind Post.",
    "The raids on the settlement's supplies had brought orders to strike at the nearby centaur.",
    "Longhorn rewarded the attack on the centaur camp.",
    "The requested retaliation was completed, without ending the wider conflict over the Needles.")
Q(4881, "Assassination Plot", "Thousand Needles", 28, HN,
    "A captured plan called for Kanati Greycloud's death at his camp southwest of the Great Lift.",
    "The assassins wanted to remove Kanati and discourage others from establishing hunting camps.",
    "Kanati learned of the plot and prepared to face the attackers.",
    "The warning reached its target before the confrontation; the assassins had not yet been held off.")
Q(4966, "Protect Kanati Greycloud", "Thousand Needles", 28, HN,
    "More centaur assassins than Kanati expected were coming for his hunting camp.",
    "The warned hunter asked for help defending the post against the approaching attackers.",
    "Kanati survived the centaur attack and said he could not have held the assassins off alone.",
    "The assassins were held back. Kanati thanked those who had stood with him when the centaur came.")
Q(4770, "Homeward Bound", "Thousand Needles", 29, HN,
    "Pao'ka Swiftmountain had become lost in Highperch after approaching a wyvern nest too closely.",
    "The stranded researcher needed an escort back to Motega at Whitereach Post.",
    "Motega learned what had happened to Pao'ka and rewarded the help bringing him back.",
    "Pao'ka returned from Highperch, ending an excursion his fellow researcher had not known about.")
Q(4904, "Free at Last", "Thousand Needles", 29, HN,
    "Arnak had kidnapped a woman after she refused him, killing her brother when he intervened.",
    "The captive at Darkcloud Pinnacle needed an escort back to Thalia.",
    "The escape reached Thalia, who had heard how the captive was helped out of Darkcloud Pinnacle.",
    "Thalia thanked the safe return and offered belongings of the captive's brother as a reward.")
Q(5064, "Grimtotem Spying", "Thousand Needles", 28, HN,
    "Three strangers had visited the Grimtotem, and Cliffwatcher Longhorn wanted to know what passed between them. Guarded chests on Darkcloud Pinnacle held their messages.",
    "Cliffwatcher Longhorn had learned of three mysterious visitors to the Grimtotem. Their correspondence lay in separate chests on Darkcloud Pinnacle, beyond the clan's guards.",
    "All three secret notes reached Longhorn. Alarmed by what they contained, he began planning for the danger they foretold.",
    "The messages were recovered from the pinnacle's three chests. Longhorn found their news grave enough to begin preparing for what might come.")
Q(5062, "Sacred Fire", "Thunder Bluff", 27, HK,
    "Motega called for Incendia agave to prepare the sacred fire that could summon Arikara.",
    "Magatha's enchantment was needed to turn the rare plant into powder for the dormant fire.",
    "Magatha received the agave and began enchanting it.",
    "The plant reached the shaman in Thunder Bluff; summoning Arikara was still ahead.")
Q(5088, "Arikara", "Thousand Needles", 28, HK,
    "Magatha's enchanted powder could summon Arikara at the sacred fire on Darkcloud Pinnacle.",
    "Magatha claimed the serpent might be stalking Cairne, giving urgency to her instructions.",
    "Motega rewarded Arikara's death but questioned why the serpent would have targeted Cairne.",
    "The serpent was slain, while Motega remained puzzled by Magatha's explanation.")
for _, id in ipairs({1086,4966,4770,4904,5088}) do pack.questIDs[id].importance = 4 end

-- Close these modest delivery arcs in Highlights before intermediary referrals.
for _, id in ipairs({888, 6364, 6386}) do pack.questIDs[id].importance = 4 end

-- Mark actual turning points for Highlights without raising every errand.
for _, id in ipairs({757, 772, 773, 775, 760, 765, 794, 808, 826, 383,
    816, 924, 872, 877, 881, 902, 863, 6384, 6362,
    1518, 1521, 1527, 96, 1531, 1532, 92460, 92468, 94375, 94468, 94505,
    97257, 93926, 92643, 92646, 93835, 94369, 95349}) do
    pack.questIDs[id].importance = 5
end

-- Regional material stays true before and after any particular quest chain.
pack.zones["Mulgore"] = {
    sight = {"The wells and grazing grounds broke the long sweep of Mulgore's plains.", "Thunder Bluff rose above a country of hunting camps and ancestral ground."},
    stakes = {"Village life depended on meat, hides and water as much as on feats of strength.", "The sacred wells and Venture Company mines made the use of the land a matter of daily conflict."}}
pack.zones["Thunder Bluff"] = {
    sight = {"The mesas lifted Thunder Bluff above the hunting grounds of Mulgore.", "Cairne's city stood high over the plains where the village trails began."},
    stakes = {"The elders' recognition connected the city's life with the work and rites of the plains.", "The city depended on the homeland spread beneath its bluffs."}}
pack.zones["Durotar"] = {
    sight = {"Razor Hill and Sen'jin stood between the valley's training grounds and the open coast.", "Caves cut into the dry hills, and the Echo Isles lay offshore."},
    stakes = {"Caravans needed protection while the settlements gathered food and hides.", "The Burning Blade's covens threatened the Horde from inside its new homeland."}}
pack.zones["Orgrimmar"] = {
    sight = {"The Cleft of Shadow held work very different from the traffic through Orgrimmar's gates.", "The city gathered the errands and reports arriving from Durotar's scattered settlements."},
    stakes = {"Trouble in the surrounding country reached the capital as reports, injuries and requests for help.", "The city's advisers depended on news from the roads and outposts beyond its walls."}}
pack.zones["The Barrens"] = {
    sight = {"The Crossroads stood where the Horde's long supply routes met.", "Small pools drew life together across the dry country."},
    stakes = {"Food stores and caravan routes demanded constant attention around the outposts.", "Water could sustain a settlement or draw rival bands to the same scarce pool."}}
pack.zones["Tirisfal Glades"] = {
    sight = {"The road from Deathknell led past the remnants of farms toward Brill.", "Ruined towers marked the country around the Forsaken villages."},
    stakes = {"The Forsaken needed clothing and care even while the Scourge and Crusade pressed near.", "The executors' war and the apothecaries' experiments competed for effort in the glades."}}
pack.zones["Silverpine Forest"] = {
    sight = {"The Sepulcher watched over a forest of dangerous roads and troubled waters.", "Lake Lordamere's shores lay beyond the pines and ruined settlements."},
    stakes = {"Scouting reports and recovered research carried news that the forest's dangers could otherwise swallow.", "The Forsaken's foothold depended on knowing what moved beyond the Sepulcher."}}
pack.zones["Zephras Isle"] = {
    setting = "Forever",
    source = {V .. " #92464 Elemental Unrest; #93552 Harvesting Windstones; #93735 The Broken Construct (Forever)"},
    sight = {"Standing stones and scattered windstones marked the groves of Zephras.", "Windshaper constructs survived among the settlements, remnants of the departed spirits' gifts."},
    stakes = {"The island's sustaining magic was fading, and its windstones grew increasingly precious.", "The Windshapers and High Order faced a common danger in the growing Al'Aketh cult."}}

-- Context-first compendium notes; storyteller why/after remain independent.
-- Reviewed evidence: StorageInvestigation/compendium-context-20261013/acceptance-context-v2.json
pack.quests["A Recipe For Death"].noteSummary = "The Royal Apothecary Society is developing a new plague for Sylvanas Windrunner, ruler of the Forsaken. Its researchers seek a weapon against Arthas's Scourge army; Apothecary Renferrel also names living humans among its intended victims. This work links Renferrel at the Sepulcher in Silverpine Forest with Master Apothecary Faranell in the Undercity.\n\nTheir research draws on poisonous reagents and the records of Apothecary Berard, a colleague who fell under the magic of Arugal, the wizard of Shadowfang Keep. Berard had investigated an ancient plague in Lordamere Lake. The quest's stages concern animal samples, his surviving journal in Pyrewood Village, and further specimens identified in his notes."
pack.quests["A Recipe For Death"].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #367; #445; #447; #450; #451"}
pack.quests["Arugal's Folly"].noteSummary = "Arugal is the wizard occupying Shadowfang Keep, a fortress in southern Silverpine Forest. The Moonrage worgen roaming the forest threaten the Forsaken effort to secure it for their ruler, Sylvanas Windrunner. Dalar Dawnweaver, a Forsaken mage at the Sepulcher, investigates Arugal's spellwork in search of a way to turn the wizard's magic against him.\n\nHis inquiry follows written spells and enchanted objects associated with Arugal and the worgen. The original stages examine the spell called Remedy of Arugal, shackles carried by Moonrage creatures, the trouble at Deep Elem Mine, and the nightly transformation of Pyrewood's villagers. These are parts of Dalar's investigation; his hopes of undoing the enchantments do not establish that a cure succeeds."
pack.quests["Arugal's Folly"].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #423; #424; #99; #1014", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)", "https://warcraft.wiki.gg/wiki/Shadowfang_Keep_%28Classic%29 (opening geography only)"}
pack.questIDs[447].noteSummary = "The Royal Apothecary Society is seeking a new plague for Sylvanas Windrunner, ruler of the Forsaken. Apothecary Renferrel, its researcher at the Sepulcher in Silverpine Forest, wants a weapon capable of destroying both Arthas's Scourge army and living humans. His work feeds the Society's experiments in the Undercity.\n\nRenferrel has found that spider blood mixed with a toxin from grizzled bear hearts makes a lethal elixir. He calls for blood from the spiders of the Skittering Dark and hearts from Silverpine's bears, to be delivered to Master Apothecary Faranell in the Undercity for further study."
pack.questIDs[447].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #367; #445; #447"}
pack.questIDs[450].noteSummary = "The Royal Apothecary Society is developing a new plague for the Forsaken, linking its researchers in Silverpine Forest with the Undercity. One of its promising members, Apothecary Berard, fell under the magic of Arugal, the wizard of Shadowfang Keep. Master Apothecary Faranell now regards Berard as Arugal's mindless servant, but believes his research can still serve the Society.\n\nBefore his loss, Berard studied an ancient plague said to have killed the aquatic life of Lordamere Lake. His journal remains in his study at the Pyrewood Village inn. Faranell wants it recovered and carried to Apothecary Renferrel at the Sepulcher, preserving the colleague's findings after the apothecaries have lost the man."
pack.questIDs[450].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #445; #447; #450; #1014"}
pack.questIDs[451].noteSummary = "The Royal Apothecary Society seeks a new plague for Sylvanas Windrunner, ruler of the Forsaken. Apothecary Renferrel at the Sepulcher and Master Apothecary Faranell in the Undercity continue research left by Apothecary Berard, a colleague lost to Arugal's magic. His surviving journal connects their work with the creatures of Lordamere Lake in eastern Silverpine.\n\nBerard's notes identify moss from Lake Skulkers and Creepers as potentially useful, along with an exceptionally rare hardened tumor found on a Vile Fin murloc. Renferrel calls for samples to be brought to Faranell. The specimens offer a way to carry Berard's work forward; their collection is part of the search for a plague, not proof that the final weapon is complete."
pack.questIDs[451].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #445; #447; #450; #451"}
pack.questIDs[422].noteSummary = "Arugal, a wizard of Dalaran now occupying Shadowfang Keep, has become an obstacle to Forsaken control of Silverpine Forest. Dalar Dawnweaver, a Forsaken mage at the Sepulcher, blames Arugal's reckless magic for the worgen troubling the region. He wants to understand the enchantments so he can turn them against the wizard and secure the forest for Sylvanas Windrunner.\n\nThe inquiry begins with Arugal's written work. A Deathstalker scout spotted spellbooks at the wheat farm north of the bridge, where Arugal first stayed, but could not retrieve them. Dalar specifically seeks the spell labeled Remedy of Arugal as evidence of what the wizard was attempting."
pack.questIDs[422].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #1014", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)"}
pack.questIDs[423].noteSummary = "Dalar Dawnweaver, a Forsaken mage at the Sepulcher, is investigating Arugal's hold over the worgen of Silverpine Forest. Arugal occupies Shadowfang Keep, and the Forsaken see his magic as an obstacle to securing the region for Sylvanas Windrunner. Dalar's study is intended to find a way to turn that magic against its wielder.\n\nExamining Arugal's spellwork has convinced Dalar that enchanted objects reinforce it. He therefore seeks shackles carried by Moonrage Gluttons and Moonrage Darksouls, whose enchantments can provide evidence for his research."
pack.questIDs[423].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #423; #1014", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)"}
pack.questIDs[424].noteSummary = "The Forsaken want Silverpine Forest secured for Sylvanas Windrunner, but Arugal's magic and the worgen associated with him complicate their advance. At the Sepulcher, the Forsaken mage Dalar Dawnweaver studies the enchantments of this wizard of Shadowfang Keep. His research is taking longer than expected while new reports demand action.\n\nDeathstalker scouts report that Arugal's influence has reached Deep Elem Mine in the southeastern hills. Its tainted foreman, Grimson the Pale, stands between the Forsaken and a useful source of resources. Dalar calls for Grimson's death so the mine can support the advance led by Sylvanas's subordinate Varimathras, while the investigation into Arugal's spells continues."
pack.questIDs[424].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #424; #1014", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)"}
pack.questIDs[99].noteSummary = "Pyrewood Village lies below Shadowfang Keep, the stronghold of Arugal in southern Silverpine Forest. The villagers appear human by day and become Moonrage worgen after sunset. Dalar Dawnweaver, a Forsaken mage researching Arugal's enchantments at the Sepulcher, sees their condition as another part of the wizard's interference with Forsaken control of the forest.\n\nDalar seeks six enchanted Pyrewood shackles placed on the villagers by Arugal, hoping to draw out their energy and understand the transformation. They extend his inquiry into the so-called Remedy of Arugal. He expects the gathered knowledge to help bring Arugal down and undo his magic, but the quest does not show the villagers being cured."
pack.questIDs[99].noteSources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #421; #422; #99", "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver (identity, class and original quest section only)", "https://warcraft.wiki.gg/wiki/Shadowfang_Keep_%28Classic%29 (Pyrewood below the keep)"}


-- Reviewed investigation stages; a shared title never inherits a later outcome.
pack.questIDs[5726] = {
    ["title"] = "Hidden Enemies",
    ["zone"] = "Orgrimmar",
    ["importance"] = 4,
    ["thread"] = "horde_blade",
    ["why"] = {"Thrall sought a Burning Blade lieutenant's insignia from Skull Rock.", "The investigation began with an insignia carried by the cultists east of Orgrimmar."},
    ["after"] = {"Thrall received the lieutenant's insignia.", "The recovered insignia completed the first assignment in Thrall's investigation."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5726"}
}
pack.questIDs[5726].threadLabel = pack.threads[pack.questIDs[5726].thread]
pack.questIDs[5727] = {
    ["title"] = "Hidden Enemies",
    ["zone"] = "Orgrimmar",
    ["importance"] = 4,
    ["thread"] = "horde_blade",
    ["why"] = {"Thrall identified Neeru as the Burning Blade's leader and planned to exploit his trust.", "A lieutenant's insignia offered a way to approach Neeru as a fellow cultist."},
    ["after"] = {"The report of Neeru's reaction reached Thrall.", "Thrall welcomed the first success of the infiltration and asked for the full account."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5727"}
}
pack.questIDs[5727].threadLabel = pack.threads[pack.questIDs[5727].thread]
pack.questIDs[5728] = {
    ["title"] = "Hidden Enemies",
    ["zone"] = "Orgrimmar",
    ["importance"] = 4,
    ["thread"] = "horde_blade",
    ["why"] = {"Thrall targeted Bazzalan and Jergosh in Ragefire Chasm while asking that the agent's cover be preserved.", "The Searing Blade's two named leaders were the next targets in Thrall's investigation."},
    ["after"] = {"Bazzalan and Jergosh were slain, leaving the caverns' cult leadership in disarray.", "Thrall received reports of the leaders' deaths and Neeru's agitation."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5728"}
}
pack.questIDs[5728].threadLabel = pack.threads[pack.questIDs[5728].thread]
pack.questIDs[5729] = {
    ["title"] = "Hidden Enemies",
    ["zone"] = "Orgrimmar",
    ["importance"] = 4,
    ["thread"] = "horde_blade",
    ["why"] = {"Thrall wanted another quiet conversation with Neeru after reports of his agitation.", "Closer contact with Neeru might yield more information about his allies."},
    ["after"] = {"Neeru angrily acknowledged that Bazzalan and Jergosh had been slain.", "Neeru blamed followers of Thrall for the deaths without accusing the infiltrator."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5729"}
}
pack.questIDs[5729].threadLabel = pack.threads[pack.questIDs[5729].thread]
pack.questIDs[5730] = {
    ["title"] = "Hidden Enemies",
    ["zone"] = "Orgrimmar",
    ["importance"] = 4,
    ["thread"] = "horde_blade",
    ["why"] = {"Neeru spoke of a new agenda for his agents in the Barrens and Ashenvale.", "Neeru's account pointed beyond Ragefire Chasm to the Shadow Council's wider schemes."},
    ["after"] = {"Thrall promised to send spies to investigate the reported presence in Ashenvale.", "The report reached Thrall, who ordered an investigation and asked that other work continue meanwhile."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5730"}
}
pack.questIDs[5730].threadLabel = pack.threads[pack.questIDs[5730].thread]
pack.quests["Burning Shadows"].why = {"A pendant from Skull Rock called for closer examination.", "An unusual object from the cultists prompted an inquiry in Orgrimmar."}
pack.quests["Burning Shadows"].after = {"The pendant's inquiry had received attention.", "The recorded errand concerning the pendant was complete."}
pack.quests["Burning Shadows"].source = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #832"}

-- Complete short scenes: exact recorded stages only; see editorial-20261016 author packet.
pack.questIDs[1061].highlight = {"The shaman Seereth Stonebreak welcomed help at her camp: goblin logging had left Stonetalon's spirits crying out.", "Stonetalon's wounded spirits had brought Seereth Stonebreak into the mountains. At her camp, the shaman welcomed help against the goblin loggers."}
pack.questIDs[1062].highlight = {"The strike against the Venture Company's workers earned Seereth's praise. Calming the spirits, she thought, might take the wisdom of the tauren elders.", "Seereth welcomed the losses inflicted on the Venture Company, but looked to the tauren elders for a way to calm Stonetalon's suffering spirits."}

A.Lore.RegisterStoryPack("horde-and-zephras", pack)
