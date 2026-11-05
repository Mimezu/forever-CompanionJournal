local _, A = ...
-- Curated against the client's captured quest text. Completion prose belongs
-- only to the recorded stage; old title-only records use restrained fallbacks.
-- The file named corpus_vanilla_quests.txt also contains Forever additions.
-- corpus_forever_new_quests.txt was empty at the time of this review.
-- Coverage: 400 curated IDs, 303 title contexts, eight regional expansions. The
-- tests derive these counts. This is not an exhaustive quest database.
-- Overnight 2026-11-05 added Deathknell/Brill/Agamand/Brightwater, Durotar's
-- valley and coast, Bloodhoof and the Longwalkers, the Sepulcher's supply and
-- Ambermill chains, the Crossroads/Taurajo/Ratchet/Bael Modan stages and
-- Thendal's trials; see StorageInvestigation/cj-overnight-20261105/horde/REPORT.md.
-- Gaps: uncaptured Forever branches, most repeatable errands and referral-only
-- shaman captures (#96243, #98517) keep conservative title/general context.
-- No later-expansion Echo Isles reclamation or presumed Zephras rescue is used.
-- Silverpine now has exact scout, Arugal, Fenris and Deliah stages, including
-- Forever 98298; Hillsbrad has the seven executor campaign stages. Hillsbrad's
-- elixirs and most later outdoor regions remain coverage gaps.
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
    "Meat had run low at {p:Camp Narache}, and the tribe needed feathers for clothing. Grull Hawkwind sent the young to hunt the plainstriders of Red Cloud Mesa before they could prove themselves to his father, the chief.",
    "On Red Cloud Mesa the tauren hunted out of need as well as for sport. Grull Hawkwind asked for plainstrider meat and feathers to resupply the village.",
    "Grull Hawkwind thanked the hunter on behalf of the tauren of Narache, who saw much promise in the work.",
    "Plainstrider meat and feathers restocked Camp Narache. Grull called it a first step toward proving oneself before the chief.")
Q(750, "The Hunt Continues", "Mulgore", 3, "horde_narache",
    "Narache's children needed clothing and its tents needed mending. Grull Hawkwind wanted pelts from the mountain cougars in the hills to the south.",
    "A tauren hunter took prey for survival, not trophies, Grull Hawkwind said. The mountain cougars' pelts would impress the elders.",
    "The cougar pelts went to clothe Narache's children and mend its tents. Grull Hawkwind promised to tell his father of the gift.",
    "The pelts were gratefully received, and Grull predicted that such skill would one day be honored in Thunder Bluff.")
Q(752, "A Humble Task", "Mulgore", 2, "horde_narache",
    "Greatmother Hawkwind had gone to the well southeast of Narache that morning and was taking a long time. Tribal matters kept her son, the chief, in camp.",
    "Every member of the tribe shared in its work, Chief Hawkwind said. While he saw to tribal matters, he asked someone to check on his mother at the well.",
    "Greatmother Hawkwind was found at the well, surprised that anyone had come so far to help an old woman.",
    "At the well, Greatmother Hawkwind welcomed the visitor her son had sent and called the visitor a keeper.", nil, true)
Q(753, "A Humble Task", "Mulgore", 3, "horde_narache",
    "Greatmother Hawkwind's old legs had lost their vigor. She gave her water pitcher to younger hands for the walk back to her son in Camp Narache.",
    "Even the humblest task could earn the recognition of elders, Greatmother Hawkwind said, and handed over the pitcher for the chief.",
    "Chief Hawkwind received the pitcher his mother had sent, and said such willingness to help would make the tribe proud in Thunder Bluff.",
    "The water from the well reached the chief at the Greatmother's bidding, and he praised the help given to the people of Narache.", nil, true)
Fallback("A Humble Task", "horde_narache",
    "Fetching water was part of the shared work that sustained Narache.",
    "The Hawkwind household depended on the same everyday work as the rest of the village.",
    "A small piece of Narache's daily work had received attention.",
    "Service to the village had taken a quieter form than hunting.", {V .. " #752, #753"})
Q(780, "The Battleboars", "Mulgore", 4, "horde_narache",
    "The Bristleback quilboar trained battleboars to be vicious, and the beasts were pushing into the tribe's hunting grounds from Brambleblade Ravine. Narache wanted their snouts and flanks for stew.",
    "Battleboars from Brambleblade Ravine were encroaching on Narache's hunting grounds. Their meat could feed the village's young.",
    "The snouts and flanks would make a fine stew for Narache's young, and the dead boars were meant as a lesson to the Bristlebacks.",
    "The battleboars lost ground near Narache, and their meat went into stew for the village's young.")
Q(755, "Rites of the Earthmother", "Mulgore", 3, "horde_rites",
    "Chief Hawkwind saw greatness ahead for a young tauren willing to do humble work. First came the three Rites of the Earthmother, beginning with Seer Graytongue in the hills south of Camp Narache.",
    "The Rites of the Earthmother were three, and the Rite of Strength came first. Chief Hawkwind sent the young to Seer Graytongue.",
    "Seer Graytongue heard that Chief Hawkwind had sent the newcomer, and warned that the rites were no small task.",
    "In the hills south of Narache, Seer Graytongue received the chief's word and the first of the rites began.", nil, true)
Q(757, "Rite of Strength", "Mulgore", 4, "horde_rites",
    "Bristlebacks from Brambleblade Ravine ambushed hunting parties and stole from Narache.",
    "The first of the Earthmother's rites called for proof against the tribe's raiders.",
    "The Bristleback belts reached Chief Hawkwind, and the first of the Earthmother's rites was passed. The tribe, he said, would be proud.",
    "Chief Hawkwind took the Bristleback belts as proof of valor against the raiders of his tribe.")
Q(763, "Rites of the Earthmother", "Mulgore", 5, "horde_rites",
    "Baine Bloodhoof continued the rites at {p:Bloodhoof Village}.",
    "Chief Hawkwind's carved totem served as an introduction beyond Narache.",
    "Baine recognized Hawkwind's carving and received his message.",
    "The carved totem reached Bloodhoof Village, where the remaining rites awaited.", nil, true)
Fallback("Rites of the Earthmother", "horde_rites",
    "The rites linked Narache's teaching with the elders of Thunder Bluff.",
    "Strength, vision and wisdom each had a place in the tauren rites.",
    "The path of the rites led a little closer to the elders of Thunder Bluff.",
    "The Rites of the Earthmother moved on toward the elders' recognition.", {V .. " #755, #763, #776"})
Q(767, "Rite of Vision", "Mulgore", 6, "horde_rites",
    "The land was the tauren's most holy provider. For the Rite of Vision, the young were sent to Zarlman Two-Moons, spiritual leader of Bloodhoof Village.",
    "The second of the Earthmother's rites, the Rite of Vision, began with Zarlman Two-Moons in Bloodhoof Village.",
    "Zarlman Two-Moons said he had sensed the newcomer coming, and could always recognize one attempting the rites.",
    "Zarlman Two-Moons received the young tauren seeking the Rite of Vision, as he had expected.", nil, true)
Q(771, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "Well stones and fallen ambercorn were needed for the Water of the Seers.",
    "Zarlman's brew drew its ingredients from Mulgore's wells and trees.",
    "Zarlman received the ingredients and could prepare the Water of the Seers.",
    "From the well stones and fallen ambercorn, Zarlman Two-Moons could brew the Water of the Seers.", nil, true)
Q(772, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "The Water of the Seers was taken beside the tribal fire.",
    "Zarlman's rite called for a vision to be followed from the village fire.",
    "The vision rose by the fire and was followed to its end. There the Rite of Vision was declared passed, with a word to be not afraid.",
    "The Water of the Seers brought a vision by the tribal fire, and following it completed the Rite of Vision.", nil, true)
Fallback("Rite of Vision", "horde_rites",
    "Zarlman Two-Moons tended the teaching and preparations of the Rite of Vision.",
    "The Water of the Seers had a place in Mulgore's rites.",
    "The work belonged to the Rite of Vision.",
    "The Rite of Vision moved forward under Zarlman Two-Moons.", {V .. " #767, #771, #772"})
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
    "Goblins and their servants had tainted Mulgore's sacred wells. Mull Thunderhorn meant to make a cleansing totem for each, starting with the Winterhoof Water Well.",
    "For the Winterhoof totem, the land had to offer its aid. Mull Thunderhorn wanted prairie wolf paws and adult plainstrider talons.",
    "Mull Thunderhorn took the paws and talons to bind their power into a totem. The Winterhoof well itself was still poisoned.",
    "The wolf paws and plainstrider talons reached Mull Thunderhorn, ready to become the first cleansing totem.")
Q(754, "Winterhoof Cleansing", "Mulgore", 6, "horde_wells",
    "The Winterhoof totem had to be carried to the guarded well.",
    "Winterhoof water had been unusable while the goblins' taint remained.",
    "Beasts were already drinking from the cleansed Winterhoof well.",
    "The Winterhoof ritual restored a source of drinking water to the plains.")
Q(756, "Thunderhorn Totem", "Mulgore", 7, "horde_wells",
    "The Thunderhorn Water Well grew more tainted by the hour. Mull Thunderhorn needed the claws of the plains' predators, prairie stalkers and flatland cougars, for its totem.",
    "Prairie stalker and flatland cougar claws were needed for the next cleansing totem.",
    "Mull Thunderhorn had his claws. The goblins, he said, would never learn the difference between fighting the land and living in harmony with it.",
    "The predators' claws went into the Thunderhorn totem. The well's cleansing was still ahead.")
Q(758, "Thunderhorn Cleansing", "Mulgore", 8, "horde_wells",
    "The Thunderhorn Water Well lay north of Bloodhoof Village.",
    "A prepared totem could carry the cleansing ritual to the Thunderhorn well.",
    "The Thunderhorn well was cleansed.",
    "The ritual removed the taint from Thunderhorn's water.")
Q(759, "Wildmane Totem", "Mulgore", 10, "horde_wells",
    "Only the Wildmane Water Well remained. Its totem needed the teeth of prairie wolf alphas, which wandered near the base of Thunder Bluff.",
    "Mull Thunderhorn's last cleansing totem called for the teeth of a fierce predator, the prairie wolf alpha.",
    "Mull Thunderhorn felt the land's sacrifice in the alphas' teeth, and said his spirit swelled with sadness and pride.",
    "The alpha teeth reached Mull Thunderhorn for the Wildmane totem, the last of the three.")
Q(760, "Wildmane Cleansing", "Mulgore", 10, "horde_wells",
    "The Wildmane well north of Thunder Bluff remained poisoned.",
    "The prepared Wildmane totem had one remaining well to cleanse.",
    "Clean water flowed at Wildmane again. Bloodhoof Village was grateful, and Mull Thunderhorn wished that Mulgore's waters would stay clean forever.",
    "The last of the poisoned wells was cleansed. The spirits, Mull Thunderhorn said, already spoke of the work at Winterhoof and Thunderhorn.")
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
    "The Venture Company had been refused mining rights in Mulgore and was digging anyway. Morin Cloudstalker wanted a message sent to its mine northeast of the ravaged caravan.",
    "Show a goblin something, the saying went, and the scales could be heard in the background. Morin Cloudstalker meant to show the Venture Company that Mulgore was not for sale.",
    "Morin Cloudstalker doubted the Venture Company could misread the message. The tauren would not let them steal the land's resources without protest.",
    "The mine's workers learned that the tauren would not be taken lightly, and Morin was satisfied with the signal sent.")
Q(765, "Supervisor Fizsprocket", "Mulgore", 12, "horde_venture",
    "The caravan documents implicated Supervisor Fizsprocket in plans to drive the tauren from their land.",
    "Fizsprocket directed the Venture Company's work from its mine.",
    "Fizsprocket was dead, and his clipboard was available for examination.",
    "The supervisor's personal papers offered further evidence of the company's intentions.")
Q(744, "Preparation for Ceremony", "Mulgore", 11, "horde_narache",
    "Eyahn Eagletalon's brother would soon stand before Cairne Bloodhoof, and Eyahn was making his headdress. Six azure and six bronze harpy feathers were still missing.",
    "While Eyahn Eagletalon tanned the leather straps, there was no time to gather feathers for his brother's ceremonial headdress.",
    "The feathers completed Eyahn's design. Giving the headdress and witnessing the ceremony were all that remained of his part.",
    "Eyahn Eagletalon had his feathers, and his gift for his brother's ceremony before Cairne was nearly done.")
Q(743, "Dangers of the Windfury", "Mulgore", 8, "horde_narache",
    "Windfury harpies nested along Mulgore's southeastern mountain edges, away from the road. Ruul Eagletalon, warrior and teacher, offered them as a test of strength.",
    "Ruul Eagletalon judged that a young tauren had to prepare before adventuring beyond Mulgore. The Windfury harpies would be a good gauge of skill.",
    "Ruul judged the harpy fight well done and the fighter ready to travel onward, and wished the wind always at their back.",
    "The Windfury harpies met Ruul Eagletalon's challenge, and Ruul sent the young tauren on with a blessing of the wind.")
Q(745, "Sharing the Land", "Mulgore", 8, "horde_mulgoreland",
    "Palemane gnolls had settled south of Bloodhoof Village and slew Mulgore's wildlife without restraint. Baine Bloodhoof said words were no longer the answer.",
    "The gnolls south of Bloodhoof had scorned every attempt to speak with them. Baine Bloodhoof wanted the young to see how much harm even a small threat could do.",
    "Baine was glad the task had been taken seriously. Death and life were a circle, he said, and respect for the land must never be forgotten.",
    "The Palemane killing of Mulgore's wildlife was checked, and Baine Bloodhoof asked that the lesson of the land never be forgotten.")
Q(746, "Dwarven Digging", "Mulgore", 8, "horde_mulgoreland",
    "Dwarves were preparing a dig northwest of Bloodhoof Village, and Baine Bloodhoof feared it would enrage Mulgore's kodos. He wanted their tools taken and smashed at a forge.",
    "The dwarves believed secrets lay in the earth, and Baine Bloodhoof agreed, but hollowing the land was no way to earn its teachings.",
    "The dwarves' broken tools reached Baine, who said it would calm the beasts of Mulgore and perhaps teach the diggers a lesson.",
    "Smashed at a forge, the dwarves' tools went back to Baine as proof. He hoped the dig would trouble the kodos no longer.")
Q(761, "Swoop Hunting", "Mulgore", 6, "horde_narache",
    "Swoops ranged all over Mulgore and were hard to find and harder to catch. Harken Windtotem called a collection of their quills a badge of cleverness and determination.",
    "A hunter needed sharp eyes and quick hooves for the swoop. Harken Windtotem asked for their quills.",
    "Harken Windtotem knew the quills had not been easy to gather, and said it was good to have such a hunter at Bloodhoof Village.",
    "The swoop quills reached Harken Windtotem, proof of a hunter of merit.")
Q(766, "Mazzranache", "Mulgore", 8, "horde_narache",
    "Maur Raincaller's grandfather had told stories of a strider named Mazzranache, with red eyes and a venomous bite. Maur met it on the plains, and the bite left him feverish.",
    "To clean the infection from Mazzranache's bite, Maur Raincaller needed a wolf heart, a cougar femur, a plainstrider scale and a swoop gizzard before the fever took him.",
    "Maur Raincaller could make his remedy and said he owed his life for it. He would never forget Mazzranache's screeching call.",
    "The ingredients arrived in time for Maur to stop the infection's spread. He warned others to be wary on their travels.")
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
    "Zureetha Fargaze had come to the Valley of Trials to guide recruits and found a growing taint. The Burning Blade's coven hid in a cave to the northeast, and its vile familiars had spilled out.",
    "A cult coven had taken root inside the valley used to train recruits, and its vile familiars roamed outside the cave mouth.",
    "Zureetha Fargaze called the familiars mere pets of the coven's darker powers, but said the success foretold greater deeds.",
    "The vile familiars outside the Burning Blade's cave were cut down, a first blow against the cult in the Valley of Trials.", nil, true)
-- The warlock trial (#1485, #1499) shares this title with another giver.
Fallback("Vile Familiars", "horde_blade",
    "The Burning Blade's familiars had spilled from a cave into the Valley of Trials.",
    "A cult coven had taken root inside the valley used to train recruits.",
    "The familiars were thinned, but the coven's darker powers remained.",
    "The vile familiars in the Valley of Trials were cut down.", {V .. " #792, #1485, #1499"})
Q(794, "Burning Blade Medallion", "Durotar", 5, "horde_blade",
    "Zureetha Fargaze's divinations showed an item of power, the Burning Blade Medallion, hidden deep in the coven and perhaps carried by one of its agents.",
    "The cult's cave concealed more than the familiars roaming the valley. Zureetha wanted its medallion taken.",
    "Zureetha was glad to see the medallion, but feared the Burning Blade had further aims in Durotar.",
    "With the medallion taken, the coven in the Valley of Trials was weakened. Zureetha warned that the cult had not been seen for the last time.")
Q(823, "Report to Orgnil", "Durotar", 7, "horde_blade",
    "News of the Burning Blade concerned Sen'jin Village as well as the Valley of Trials.",
    "Orgnil Soulscar watched for corruption from his post at Razor Hill.",
    "Orgnil Soulscar, who kept Durotar watched for evils like the Burning Blade, demanded to hear the report.",
    "Orgnil in Razor Hill learned of the Burning Blade in the valley and of the trouble facing Sen'jin.")
Q(827, "Skull Rock", "Durotar", 12, "horde_blade",
    "Cultists at Skull Rock wore collars that burned their flesh.",
    "Margoz sought searing collars to study the Burning Blade's demonic power.",
    "Margoz had his searing collars and was sure the Burning Blade's secret hid within them.",
    "The searing collars from Skull Rock reached Margoz, who meant to learn how the cultists drew on demonic power.")
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
    "Cook Torka had nearly forgotten breakfast. Sen'jin's next meal needed taillasher eggs from the Echo Isles.",
    "The taillashers guarded eggs that could supply Cook Torka's pot, and buried them deep when they could.",
    "The cook judged the egg-gatherer weak but at least not clumsy, and went back to cooking.",
    "Cook Torka had three eggs, enough for the next day's meal, and wasted no more time on thanks.")
Q(817, "Practical Prey", "Durotar", 8, "horde_darkspear",
    "Vel'rin Fang made blankets, armor and tents from Durotar tiger hides. Sen'jin's numbers were growing faster than its stocks.",
    "The Darkspear hunted Durotar's tigers and let them thrive at the same time. Now Vel'rin Fang needed more furs from the islands than the stores held.",
    "The tiger furs meant Sen'jin's people would not go cold as the seasons changed.",
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
    "Rezlak, one of Gazlowe's goblins, had been sent to help the orcs of Durotar. The Dustwind harpies of Razorwind Canyon had snatched his last shipment.",
    "Stolen caravan sacks lay in the canyons while construction waited.",
    "Rezlak had his supplies back and could return to work, as soon as he found someone to haul the sacks.",
    "The stolen shipment was back in Rezlak's hands.")
Q(835, "Securing the Lines", "Durotar", 11, "horde_roads",
    "Harpies in Drygulch Ravine threatened each new supply caravan.",
    "Recovering a shipment left the raiders along Rezlak's routes to contend with.",
    "Rezlak could breathe easy about his caravans, just in time for a shipment of new toys. He suggested looking up his boss Gazlowe in Ratchet.",
    "With the Drygulch harpies dealt with, Rezlak paid as promised and expected his supply caravans to get through.")
Q(840, "Conscript of the Horde", "The Barrens", 12, "horde_roads",
    "Takrin Pathseeker had a recruitment letter for his friend Kargal Battlescar, who needed new hands for Barrens duty.",
    "The Horde needed recruits at the outposts beyond Durotar, and Takrin Pathseeker thought a strong newcomer should carry his letter to Kargal.",
    "Kargal signed the letter on his excellent scout Takrin's word. What he really needed, he said, was someone at the Crossroads.",
    "Kargal Battlescar approved the recruitment letter and pointed the recruit on toward the Crossroads.")
Q(842, "Crossroads Conscription", "The Barrens", 12, "horde_roads",
    "Sergra Darkthorn directed the work awaiting recruits at the Crossroads.",
    "Kargal called Sergra Darkthorn a nasty shaman who would talk a recruit's head in circles, though Thrall thought her something special.",
    "Sergra accepted the letter and made the demands of Crossroads duty clear.",
    "Sergra Darkthorn took Kargal's letter and warned that she would tolerate no insolence. Thrall, she said, had declared the Horde's women equal.")
Q(844, "Plainstrider Menace", "The Barrens", 12, "horde_roads",
    "Plainstriders east of the Crossroads were harassing its food supplies.",
    "Keeping the outpost fed began with a hunt close to its supply routes.",
    "With the plainstriders gone, Sergra expected the supply chains to be easier to keep intact. The next prey, she warned, had more fire in its blood.",
    "Sergra judged the supplies easier to protect with fewer plainstriders harassing them.")
Q(845, "The Zhevra", "The Barrens", 13, "horde_roads",
    "Sergra's next hunting test called for zhevra hooves.",
    "The zhevra north and south of the Crossroads could strike hard with their hooves.",
    "A zhevra's kick could knock even a tauren on its haunches, Sergra said. She judged the hunter strong enough for a real challenge.",
    "Sergra accepted the zhevra hooves before proposing more difficult prey.")
Q(848, "Fungal Spores", "The Barrens", 15, "horde_apothecary",
    "The Barrens' oases nourished and altered the life around them.",
    "Mushrooms growing near the oases held spores useful to the apothecaries.",
    "Apothecary Helbrim judged the spores potent and paid as promised. The Forsaken, he said, honored their contracts.",
    "Helbrim had his spores, needed for a concoction bound for his associate in Thunder Bluff.")
Q(868, "Egg Hunt", "The Barrens", 22, "horde_roads",
    "Little was known about the insect-like creatures in the Field of Giants.",
    "An observer working for Orgrimmar sought intact eggs from the southern mounds.",
    "Korran was pleased to have the eggs and his digging claw back unbroken, for his report to his masters in Orgrimmar.",
    "The eggs from the Field of Giants reached Korran, whose masters in Orgrimmar wanted to know more of the clever insect creatures.")
Q(869, "Raptor Thieves", "The Barrens", 13, "horde_roads",
    "Silver intended for the Crossroads guards' pay had been stolen, and a captured thief was a raptor.",
    "The missing payroll had prompted an unusual hunt for raptor thieves.",
    "Gazrog was glad to see the raptor heads and hoped no more silver would go missing. The stolen payroll itself was still unaccounted for.",
    "The raptors Gazrog blamed were hunted down, but the missing silver was not recovered.")

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
    "One more of the Crusade's detachments in Tirisfal had been struck.",
    "The Crusade faced another attack in Tirisfal.", {V .. " #427, #370, #371, #372"})
local plague = {
    {367, 6, "Sylvanas had challenged the Royal Apothecary Society to brew a plague that would ruin Arthas's Scourge. Apothecary Johaan in Brill believed the blood of beasts might be the key.", "Apothecary Johaan was testing a theory for the Dark Lady's new plague. His first experiment called for five vials of darkhound blood.", "Johaan had his darkhound blood and could begin testing his theory.", "Five vials of darkhound blood reached Johaan's workbench in Brill, and he gave his thanks."},
    {368, 9, "Poisoning one victim was child's play, Johaan said, but a plague meant to spread across a world needed more. Scales from the Vile Fin murlocs were next.", "For his disease to spread properly, Johaan wanted scales from the Vile Fin murlocs along Tirisfal's coast.", "Johaan declared the Vile Fin scales exactly what his concoction needed.", "The murloc scales went into Johaan's mixture, and he judged them perfect for it."},
    {369, 11, "One of Johaan's old tomes told of an ancient plague whose deadly agent had survived in the venom of Night Web spiders. He wanted that venom for his own concoction.", "The last ingredient of Johaan's experiment was venom from a Vicious Night Web Spider in eastern Tirisfal.", "With the venom added and the mixture boiled down, Johaan was ready to try his new agent.", "Johaan had every ingredient at last, and the test of his deadly agent was still to come."},
}
for _, r in ipairs(plague) do Q(r[1], "A New Plague", "Tirisfal Glades", r[2], "horde_apothecary", r[3], r[4], r[5], r[6], nil, true) end
Fallback("A New Plague", "horde_apothecary",
    "The Royal Apothecary Society was experimenting with a new disease.",
    "Brill's apothecary collected reagents for a proposed weapon against the Scourge.",
    "Brill's apothecary had more to work with for the Dark Lady's plague.",
    "The research advanced another step without settling its eventual result.", {V .. " #367, #368, #369, #492"})

-- Deathknell and Brill (overnight 2026-11-05). Read from the corpus by ID;
-- LoreForever's Z_tirisfal entries were used only to name the quest givers.
Q(492, "A New Plague", "Tirisfal Glades", 11, "horde_apothecary",
    "Another dwarven mountaineer had been captured and locked in the cellar of the Gallows' End Tavern. Apothecary Johaan sent down a special drink, a hint of what the Dark Lady planned for Azeroth.",
    "Johaan's new plague needed a living subject. The captured mountaineer in the tavern cellar was to taste his latest brew.",
    "The thirsty mountaineer took Johaan's drink, grumbling that it was no Rhapsody Malt.",
    "Still boasting that the Steam Tank Brigade would come for him, the dwarf accepted the brew.", nil, true)
Q(3901, "Rattling the Rattlecages", "Tirisfal Glades", 3, "horde_forsaken",
    "Shadow Priest Sarvis wanted to see the newly risen under pressure. The Rattlecage skeletons, more of the Lich King's mindless servants, were a harder foe than Deathknell's zombies.",
    "After the zombies, Sarvis turned his recruits against the Rattlecage skeletons. Thinning them would show whether the freedom given to the Forsaken had been well placed.",
    "Sarvis declared his lessons finished. Many would stand against what the Forsaken had become, he warned, but they were free and would not be shackled again.",
    "The Rattlecages were thinned, and Sarvis judged his recruit worthy of the freedom the Forsaken had been given. He handed over a reward and sent them on to much work ahead.")
Q(3902, "Scavenging Deathknell", "Tirisfal Glades", 3, "horde_forsaken",
    "More recruits were rising from Deathknell's graves, and Deathguard Saltain did not want them stumbling about naked. Stacks of boxes in the village might still hold useful equipment.",
    "Deathguard Saltain put the newly awakened to work searching Deathknell's crates. No one would give the Forsaken handouts, he said, so they would fend for themselves.",
    "Saltain admitted that his scavenger was not useless after all, and handed over one of the better items from the salvage.",
    "Gear from Deathknell's boxes was set aside for the recruits still rising. Saltain kept back one of the better finds as a reward.")
Q(6395, "Marla's Last Wish", "Tirisfal Glades", 5, "horde_forsaken",
    "Marla Fipps had died at the hands of her husband Samuel after the plague made him one of the Scourge. Her last wish, Novice Elreth said, was to be buried beside him.",
    "Samuel Fipps still roamed a ruined camp along the road northeast of Deathknell. Novice Elreth wanted him destroyed and laid in Marla's grave, in the first row of the village graveyard.",
    "Samuel's remains were buried in Marla's grave, granting her last wish. Elreth hoped the two would find peace there while the struggle with the Scourge went on.",
    "Marla and Samuel Fipps lay together in Deathknell's graveyard. To Elreth, respect for the dead was one of the things that set the Forsaken apart from the Scourge.")
Q(381, "The Scarlet Crusade", "Tirisfal Glades", 4, "horde_scarlet",
    "Executor Arren's scouts had found a Scarlet Crusade detachment setting up camp southeast of Deathknell. The Crusade would not rest until every undead was destroyed, so Arren meant to strike first.",
    "The Scarlet Crusade made no distinction between the Lich King's Scourge and the free Forsaken. When its zealots camped near Deathknell, Executor Arren ordered an attack before they could make one.",
    "The camp southeast of Deathknell lost its zealots. Arren joked about sitting them down for reasonable discourse, then called them Light-blinded fools.",
    "Arren was satisfied with the strike on the Scarlet camp. In his view, the zealots had sent themselves to their own graves.")
Q(8, "A Rogue's Deal", "Tirisfal Glades", 5, "horde_forsaken",
    "Calvin Montague in Deathknell had a letter for Renee, the innkeeper at Brill. He promised good pay for the delivery and said little about what was in it.",
    "Calvin Montague wanted a letter carried to Brill's innkeeper. He described her inn as a cozy place where the plague's victims could rest.",
    "Renee took the letter and claimed it came from her saintly mother in Deathknell. Then she dropped the act and told the courier to get lost until there was coin to spend.",
    "Innkeeper Renee received Calvin's letter in Brill. Who had written it, she said, was nobody's business.", nil, true)
Q(590, "A Rogue's Deal", "Tirisfal Glades", 5, "horde_forsaken",
    "Calvin Montague had promised pay for the letter to Brill. Asked for it, he denied owing anything and offered a fight instead.",
    "Back in Deathknell, Calvin Montague claimed he owed nothing and knew of no letter. Then he raised his fists.",
    "Calvin lost the fight and paid up, though less than he had promised. He admitted the first figure had been a lie.",
    "Beaten, Calvin handed over his coin. It came short of the promised sum, which he blamed on having lied in the first place.", nil, true)
Fallback("A Rogue's Deal", "horde_forsaken",
    "Calvin Montague of Deathknell had a letter bound for Brill and a promise of payment.",
    "A rogue in Deathknell offered coin for carrying his letter to Brill.",
    "Calvin Montague's bargain over the letter took another turn.",
    "The letter and the pay Calvin had promised for it changed hands.", {V .. " #8, #590"})
Q(404, "A Putrid Task", "Tirisfal Glades", 6, "horde_forsaken",
    "Scourge had trickled into the country west of Brill near the old bridge. Deathguard Dillinger wanted the rotting dead beaten back and their putrid claws brought in.",
    "Rotting dead and ravaged corpses had gathered by the old bridge west of Brill. Deathguard Dillinger offered a reward for their claws.",
    "The putrid claws reached Dillinger, whose only regret was not seeing the Scourge smashed himself.",
    "Fewer Scourge lingered near the old bridge west of Brill, and Dillinger paid the Deathguards' reward for the claws.")
Q(5481, "Gordo's Task", "Tirisfal Glades", 5, "horde_apothecary",
    "Gordo, an abomination whose hands were too big for picking, wanted help gathering weeds for his master. He promised not to hurt anyone who helped.",
    "On the road to Brill, Gordo asked for gloom weed for Junior Apothecary Holland. Picking was hard work for an abomination's hands.",
    "Holland had no use for gloom weed. Gordo, he complained, was out picking daisies and sending others to do the same, when what he needed was doom weed.",
    "The gloom weed reached Junior Apothecary Holland, who rejected it. He wanted doom weed, and had given up explaining the difference to Gordo.")
Q(5482, "Doom Weed", "Tirisfal Glades", 6, "horde_apothecary",
    "Junior Apothecary Holland needed doom weed, and Gordo kept bringing him the wrong plants. It grew near the mass gravesite north of Brill's graveyard, where gnolls roamed.",
    "Holland offered a reward for enough doom weed to suit his work. The plant grew by the mass graves north of the Brill graveyard.",
    "Holland rubbed his hands over the doom weed. He called it a fine service to himself, then corrected that to the Lady.",
    "The doom weed reached Holland, who promised it would come in handy and paid the reward.")
Q(99142, "Tomb Weed", "Tirisfal Glades", 11, "horde_apothecary",
    "Junior Apothecary Holland had altered his doom weed and replanted it at Balnir Farmstead. He called the result tomb weed and spoke of it as the herald of his destiny.",
    "Holland's tomb weed was growing at Balnir Farmstead, and the Scourge there seemed drawn to it. He wanted the crop brought back to Brill.",
    "Holland inspected the tomb weed and wished it had matured more violently. Progress, he decided, was still progress.",
    "The tomb weed reached Holland, who said a great many would die because of it.")
Q(358, "Graverobbers", "Tirisfal Glades", 8, "horde_forsaken",
    "The Mass Graves held Tirisfal's plague dead, and the Scourge had sent Rot Hide gnolls to take the bodies for its armies. Magistrate Sevren wanted the gnolls killed and their embalming ichor collected.",
    "Rot Hide gnolls were digging up the Mass Graves southwest of Garren's Haunt. Magistrate Sevren meant to stop them, and wanted the ichor that gave them life.",
    "The Rot Hides at the graves were cut down, and Sevren sent their ichor to the apothecaries. He hoped it held secrets the Forsaken could use against the Scourge.",
    "Sevren praised the work at the Mass Graves. The Scourge would not use those corpses, he said, and the gnolls' ichor would go to the apothecaries for study.")
Q(359, "Forsaken Duties", "Tirisfal Glades", 9, "horde_forsaken",
    "Magistrate Sevren needed a fresh report from the Deathguard waystation east of Brill. He feared more Scourge had slipped past the Bulwark.",
    "The border with the Plaguelands had to be watched. Sevren sent for Deathguard Linnea's latest word from the eastern waystation.",
    "Deathguard Linnea reported that the Bulwark held most of the Scourge back, though some slipped through. Their activity was heaviest around Balnir Farmstead.",
    "At the waystation, Linnea gave her report. The defenders on the Bulwark were holding, but Scourge had been seen east of the station near Balnir Farmstead.")
Q(360, "Return to the Magistrate", "Tirisfal Glades", 9, "horde_forsaken",
    "The waystation's word on the Bulwark was meant for Magistrate Sevren in Brill. Deathguard Linnea wanted it carried back quickly, with any Scourge on the road cut down.",
    "News from the eastern waystation had to reach Brill. Linnea sent her word back to the magistrate.",
    "Sevren was troubled that Scourge still slipped past the Bulwark. The Lich King, he said, would not take the Forsaken again.",
    "Linnea's report reached Sevren, who called the Lich King's minions ceaseless and said the Forsaken would not give in.")
Q(356, "Rear Guard Patrol", "Tirisfal Glades", 11, "horde_forsaken",
    "The Bulwark's defenders could hold only one front, and Scourge slipping behind them threatened their supply line. Deathguard Linnea sent a patrol east toward Balnir Farmstead.",
    "Balnir Farmstead had become a haven for Scourge that slipped past the Bulwark. Linnea wanted the farm and the road around it cleared.",
    "The patrol thinned the Scourge around Balnir Farmstead. Linnea promised a commendation to her superior, Executor Zygand.",
    "Linnea accepted the report of the patrol east of her station. Fewer Scourge remained behind the Bulwark, and Zygand would hear of it.", nil, true)
Q(99156, "Rear Guard Patrol", "Tirisfal Glades", 13, "horde_forsaken",
    "A rogue abomination had been seen near Venomweb Vale in eastern Tirisfal. Deathguard Linnea wanted the matter kept quiet, since abominations did not slip past the Bulwark unnoticed.",
    "Linnea's new report placed an abomination near Venomweb Vale. She warned that it would take allies to bring down, and asked for its heart.",
    "The abomination's heart reached Linnea. She credited the kill to the cunning and coordination the mindless Scourge would never have.",
    "The abomination near Venomweb Vale was dead, and its heart was delivered as proof. How it had passed the Bulwark remained unexplained.", nil, true)
Fallback("Rear Guard Patrol", "horde_forsaken",
    "Deathguard Linnea watched Tirisfal's eastern flank behind the Bulwark.",
    "Scourge that slipped past the Bulwark troubled the road east of Brill.",
    "Linnea's patrols kept watch behind the Bulwark.",
    "The Scourge behind the Bulwark faced another patrol.", {V .. " #356, #99156"})
Q(374, "Proof of Demise", "Tirisfal Glades", 7, "horde_scarlet",
    "Varimathras wanted the Scarlet Crusade wiped from Tirisfal Glades. A Deathguard in Brill asked for ten of its insignia rings as proof of loyalty to him and the Dark Lady.",
    "Tirisfal was crawling with Scarlet Crusaders. Brill's Deathguard offered a reward for their insignia rings, taken as proof of the offensive.",
    "Ten Scarlet insignia rings reached Brill, and the Deathguard said Varimathras would be proud.",
    "The rings proved ten crusaders dead. In Brill, that counted as service to Varimathras and the Dark Lady.")
Q(365, "Fields of Grief", "Tirisfal Glades", 7, "horde_apothecary",
    "Deathguard Simmer wanted ten pumpkins stolen from a human farm patrolled by the Scarlet Crusade. They were reagents for Apothecary Johaan in Brill.",
    "A farm under the eye of a Scarlet tower still grew pumpkins. Simmer called the theft a lesson for the humans and sent the harvest to Apothecary Johaan.",
    "Johaan received the ten pumpkins and called the new Forsaken an asset to the Dark Lady's army.",
    "The stolen pumpkins reached Apothecary Johaan in Brill, who had been expecting them as much-needed reagents.", nil, true)
Q(407, "Fields of Grief", "Tirisfal Glades", 7, "horde_apothecary",
    "Apothecary Johaan had laced a pumpkin with his latest formula. A captured Scarlet Zealot in the cellar of the Gallows' End Tavern was to eat it.",
    "Johaan believed even a simple pumpkin could serve the Dark Lady. He sent his treated pumpkin down to the zealot held in the tavern cellar.",
    "The starving zealot cursed his undead visitor until he saw the pumpkin. Then he ate it gladly.",
    "The captive zealot took the pumpkin with thanks to the Light, too hungry to ask what was in it.", nil, true)
Fallback("Fields of Grief", "horde_apothecary",
    "Apothecary Johaan in Brill had found a use for pumpkins.",
    "Pumpkins from Tirisfal's human farms interested Brill's apothecaries.",
    "Johaan's pumpkin work went a little further.",
    "Another of Johaan's pumpkins served the apothecaries' purposes.", {V .. " #365, #407"})
Q(398, "WANTED: Maggot Eye", "Tirisfal Glades", 10, "horde_forsaken",
    "Brill had sentenced the gnoll Maggot Eye to death for stealing corpses for the Lich King's army. He was last seen near Garren's Haunt, north of the town.",
    "A wanted poster in Brill offered a reward for Maggot Eye's paw. The gnoll had been robbing the dead for the Scourge around Garren's Haunt.",
    "Executor Zygand accepted Maggot Eye's paw and thanked the executioner on behalf of Brill.",
    "Maggot Eye's corpse thefts were avenged. Zygand hoped the execution would warn anyone else who meant the Forsaken harm.")
for _, id in ipairs({6395, 398, 99156}) do pack.questIDs[id].importance = 4 end
pack.questIDs[3901].highlight = {"Sarvis tested the newly risen against Deathknell's Rattlecage skeletons. When they were thinned, he declared his lessons finished and swore the Forsaken would never be shackled again.", "The Rattlecage skeletons were a harder foe than Deathknell's zombies. Once they were thinned, Sarvis judged the freedom given to his recruit well placed."}
pack.questIDs[6395].highlight = {"Samuel Fipps, who had killed his wife Marla as one of the Scourge, was destroyed and buried in her grave. Novice Elreth hoped the two would find peace together.", "Marla Fipps had asked to be buried with the husband who killed her. Samuel's remains were laid in her grave at Deathknell, and Elreth called it a good deed."}
pack.questIDs[381].highlight = {"Executor Arren ordered a strike on the Scarlet camp southeast of Deathknell before its zealots could strike first. He called the dead crusaders Light-blinded fools.", "The Scarlet Crusade had camped close to Deathknell, hunting every undead it could find. The attack reached the camp first, and Arren had nothing kind to say about the fallen zealots."}
pack.questIDs[590].highlight = {"Calvin Montague tried to fight his way out of paying for the Brill letter. He lost, paid less than promised, and admitted the first offer had been a lie.", "Asked for his promised coin, Calvin Montague chose a fight instead. Beaten, he paid a smaller sum and blamed it on his own lie."}
pack.questIDs[5481].highlight = {"Gordo the abomination sent his gloom weed to Junior Apothecary Holland in Brill. Holland had wanted doom weed, and complained that Gordo kept picking the wrong plants.", "Gordo's gloom weed reached Holland and was refused. The apothecary needed doom weed, and had given up explaining the difference to his abomination."}
pack.questIDs[5482].highlight = {"Doom weed from the mass graves north of Brill reached Junior Apothecary Holland. He rubbed his hands over it and called it a fine service, first to himself, then to the Lady.", "Holland finally had the doom weed Gordo could never find. He paid for it and promised it would come in handy."}
pack.questIDs[358].highlight = {"Rot Hide gnolls had been taking bodies from the Mass Graves for the Scourge. They were cut down, and Magistrate Sevren sent their embalming ichor to the apothecaries.", "The Mass Graves were spared the Rot Hides' digging. Sevren was pleased, and hoped the gnolls' ichor would reveal something to use against the Scourge."}
pack.questIDs[407].highlight = {"Apothecary Johaan laced a pumpkin with his latest formula for the Scarlet Zealot in the Gallows' End cellar. The starving prisoner cursed his visitor, then ate it gladly.", "In the cellar of the Gallows' End Tavern, a captured zealot met Johaan's treated pumpkin. He was too hungry to wonder what was in it."}
pack.questIDs[398].highlight = {"Maggot Eye had been stealing Tirisfal's dead for the Lich King. Executor Zygand accepted the gnoll's paw and thanked the executioner on behalf of Brill.", "Brill's death sentence on the corpse-thief Maggot Eye was carried out near Garren's Haunt. Zygand hoped the execution would serve as a warning."}
pack.questIDs[99156].highlight = {"An abomination had slipped past the Bulwark toward Venomweb Vale. Its heart reached Deathguard Linnea, who credited the kill to Forsaken cunning.", "Deathguard Linnea kept the abomination near Venomweb Vale quiet until it was dead. Its heart came back as proof, though no one knew how it had passed the Bulwark."}

-- Agamand Mills, the lich of Brightwater Lake and Brill's everyday needs
-- (overnight 2026-11-05). Givers named from LoreForever Z_tirisfal/Z_undercity
-- entries (wiki-derived facts only). Forever's camping quests share one title
-- across start zones, so each start keeps its own exact stage.
Q(361, "A Letter Undelivered", "Tirisfal Glades", 7, "horde_forsaken",
    "Among the ruins of Agamand Mills lay a letter from Thurman, eldest son of Gregor Agamand, to Yvette Farthing. It had never reached her.",
    "Thurman Agamand had written to Yvette Farthing before the plague, and the letter had never been delivered. Yvette was now one of the Forsaken in Brill.",
    "Yvette mourned Thurman, who had stayed at Agamand Mills out of loyalty to his family, and blamed his brother Brand. Then her face grew cold, and she said that life was over.",
    "The letter told Yvette what had become of her lost love. She cursed the plague, then set regret aside as something for the weak.")
Q(362, "The Haunted Mills", "Tirisfal Glades", 10, "horde_forsaken",
    "Coleman Farthing was collecting the remains of the Agamands. Devlin, the weak and sharp-tongued younger son, still chattered madly near the road to the mills.",
    "Coleman Farthing had expected Devlin Agamand to succumb quickly when the plague reached the mills. He wanted the younger son destroyed and his bones brought to Brill.",
    "Coleman took Devlin's bones for his mantle. The Agamands had failed his family when the plague came, and he swore to smash what was left of them.",
    "Devlin Agamand's bones reached Coleman. If his cold heart found any warmth, he said, it was in knowing the Agamands were destroyed.")
Q(354, "Deaths in the Family", "Tirisfal Glades", 11, "horde_forsaken",
    "Coleman Farthing had worked the Agamand mills before the plague. The family's pride had kept their workers there to die, and now the Agamands served the Scourge.",
    "When the Scourge came, the Agamands fortified their home and persuaded their workers to stay and defend it. Coleman Farthing, one of those loyal fools, wanted the family's remains.",
    "The Agamands were destroyed. Coleman hoped they had known fear before the end, though he admitted it was a foolish hope.",
    "Coleman received the Agamands' remains and called revenge sweet. He hoped some trace of free will had let them feel it.")
Q(355, "Speak with Sevren", "Tirisfal Glades", 10, "horde_forsaken",
    "Coleman Farthing's revenge was satisfied, but Agamand Mills still threatened all the Forsaken. He had told Magistrate Sevren of the fighting there.",
    "Word of the work at Agamand Mills had reached Magistrate Sevren through Coleman Farthing. The magistrate wanted to meet the one responsible.",
    "Sevren had heard Coleman's praise and had new work for the Forsaken.",
    "In Brill, Sevren said the Forsaken needed those talents once again.")
Q(426, "The Mills Overrun", "Tirisfal Glades", 8, "horde_forsaken",
    "The Scourge were trying to make a base of Agamand Mills, from which they could stage attacks deeper into Tirisfal. Deathguard Dillinger had orders to destroy them.",
    "Across the bridge west of Brill and north to the windmills, the Scourge were gathering at Agamand Mills. Deathguard Dillinger wanted ribs and skulls from the skeletons and bonecasters there.",
    "Dillinger would not give thanks for necessary work, but said the Deathguards of Tirisfal would remember who had done it.",
    "Notched ribs and blackened skulls from the mills reached Dillinger. The Scourge gathering at Agamand had lost a good part of its soldiers.")
Q(408, "The Family Crypt", "Tirisfal Glades", 13, "horde_forsaken",
    "Captain Dargol, a skeleton, commanded the Scourge from the Agamand Family Crypt. With necromancy he had raised the Agamand ancestors to fight the Forsaken.",
    "The Agamand Family Crypt was the Scourge's strongest point at the mills. Magistrate Sevren wanted the raised ancestors put down and Captain Dargol's skull brought back.",
    "Dargol's skull reached Sevren, who called it a telling blow against the Scourge and one their enemies would notice.",
    "The Agamand crypt lost its captain and its raised ancestors. Sevren believed the Forsaken would one day drive the Lich King himself from Azeroth.")
Q(405, "The Prodigal Lich", "Undercity", 8, "horde_forsaken",
    "Bethor Iceshard, a powerful mage in the Undercity, wanted an agent with proven worth against the Scourge. Magistrate Sevren sent his orders south with one.",
    "Magistrate Sevren knew only that Bethor Iceshard's mission concerned a wayward lich, and that it would be dangerous. His orders were bound for the Magic Quarter.",
    "Bethor received Sevren's agent in the Magic Quarter and called the business crucial. He would judge for himself whether Sevren had chosen well.",
    "In the Undercity, Bethor read Sevren's orders and accepted the agent, reserving his judgment.")
Q(357, "The Lich's Identity", "Tirisfal Glades", 8, "horde_forsaken",
    "A lich on the island in Brightwater Lake set his minions on every undead who came near, believing them all slaves of the Scourge. Bethor Iceshard wanted his spellbook to learn who he was.",
    "The lich of Brightwater Lake had a free will of his own, and the Dark Lady would want him. Bethor Iceshard sent a thief into his camp for the spellbook.",
    "The spellbook belonged to Gunther Arcanus, and Bethor knew the name at once. The two had been friends and comrades before the plague.",
    "Bethor studied the stolen spellbook and found it was Gunther Arcanus's. Gunther had been a skilled necromancer in life and had grown stronger in death, and Bethor wanted him for the Forsaken.")
Q(366, "Return the Book", "Tirisfal Glades", 8, "horde_forsaken",
    "Bethor, Gunther and Thule Ravenclaw had once studied together in the Kirin Tor at Dalaran. Bethor placed a spell on Gunther's spellbook to show that he too was free of the Lich King.",
    "Bethor Iceshard hoped his old friend would join the Forsaken. The enchanted spellbook had to go back to Gunther Arcanus on his island in Brightwater Lake.",
    "Gunther recognized his stolen spellbook and the thief who had taken it. Then he saw Bethor's enchantment and began to wonder whether his friend had escaped the Lich King too.",
    "Gunther swore he would never again be a slave of the Scourge, until he noticed Bethor's spell on the returned spellbook. The news that Bethor was free gave him pause.")
Q(409, "Proving Allegiance", "Tirisfal Glades", 12, "horde_forsaken",
    "Gunther Arcanus wanted proof that his visitor was an enemy of the Scourge. Lillith Nefara, a Scourge agent, used a bloody altar just off the island's southern shore.",
    "A Candle of Beckoning lit on the old altar south of Gunther's island would wake Lillith Nefara. Gunther asked for her destruction as proof.",
    "Lillith Nefara was destroyed. Gunther had believed himself alone in breaking the Lich King's domination, and was astonished to find others free.",
    "With Lillith dead, Gunther accepted that his visitor was the Lich King's foe. He had thought no one else had broken free.")
Q(411, "The Prodigal Lich Returns", "Undercity", 12, "horde_forsaken",
    "Gunther Arcanus handed over a Nether Gem for Bethor Iceshard. Through it the two old comrades could speak, and Gunther had much to tell.",
    "A Nether Gem from Brightwater Lake would let Gunther Arcanus speak with Bethor Iceshard in the Undercity.",
    "Bethor learned that Gunther would join the Forsaken, and promised that the Dark Lady would be told.",
    "The Nether Gem reached Bethor, and with it Gunther's decision to join the Forsaken. Bethor called it a great deed for his people.")
Q(375, "The Chill of Death", "Tirisfal Glades", 8, "horde_forsaken",
    "Gretchen Dedmar had sewn body bags for Sylvanas's fallen soldiers. Now the chill of undeath made her hands shake, and she feared the mindless state would soon take her.",
    "Five duskbat pelts and a few sewing supplies would let Gretchen Dedmar make a blanket against the cold creeping through her veins.",
    "Gretchen had what she needed for her blanket, and hoped Sylvanas would one day recognize the help.",
    "With duskbat pelts in hand, Gretchen could sew her blanket and keep serving the Dark Lady's cause.")
Q(97558, "Hides for the Forsaken", "Tirisfal Glades", 11, "horde_forsaken",
    "Forsaken skin did not heal. Shelene Rhobart replaced damaged skin with animal hides, and her stocks were running low.",
    "Shelene Rhobart needed duskbat wing membranes, darkhound hides and Vile Fin skin. Each thickness suited a different part of a Forsaken body.",
    "Shelene promised the hides would be put to good use. Murloc skin served for cheeks and mouths, and the thin duskbat membranes for faces and fingers.",
    "Shelene's stock of skins was replenished, ready for the next Forsaken who came to her injured.")
Q(95314, "That Shadowvale Green Elixir", "Tirisfal Glades", 10, "horde_trade",
    "Before the Scourge came, the reclusive village of Shadowvale had distilled Whispering Elixir from herbs found only in Tyr's Fall. Brill still had buyers for it, ban or no ban.",
    "Bottles of Whispering Elixir might still lie in the ruins of Shadowvale, deep in the Whispering Forest. Its buyers in Brill offered generous pay.",
    "The elixirs from Shadowvale were paid for. The buyer had always found the forest folk odd, and repeated the rumor that the Whispering Forest was cursed.",
    "The bottles of Whispering Elixir reached Brill. Some said the elixir carried the curse of the forest it came from, but the payment was made all the same.")
Q(86784, "Sticks and Bones", "Tirisfal Glades", 7, "horde_forsaken",
    "Deathguard Bartholomew's associate Eleanor Shackleton camped in the western hills of Tirisfal. She had once told him to gather five times the firewood he thought he needed.",
    "Eleanor Shackleton lived by surviving the weather and monsters of the wilds. Deathguard Bartholomew sent her a basket of firewood, and a visitor who might learn from her.",
    "Eleanor welcomed the extra firewood for the cold nights of the Glades and let her visitor keep the basket.",
    "The firewood reached Eleanor's camp. She already had a sling for gathering wood, so the basket stayed with its carrier.")
Q(96656, "The Adventurer", "Tirisfal Glades", 6, "horde_forsaken",
    "A new adventurer had been seen down the road by Brill. Trusted after the fighting against the Scarlet Crusade, a newly risen Forsaken was sent to see what she was doing.",
    "With Scarlet Crusaders about, a stranger camped on the road to Brill needed looking into.",
    "The stranger was Eleanor Shackleton, an adventurer with no ties to the Scarlet Crusade. She offered to teach camping in the wild.",
    "Eleanor Shackleton had nothing to do with the Crusade. She was passing through before her next venture into the wilds, and offered lessons in camping.", nil, true)
Q(96652, "The Adventurer", "Durotar", 6, "horde_trials",
    "A plain notebook found in Durotar told of a stranger's travels, with many entries about camping.",
    "Someone near Razor Hill had lost a notebook full of travels and nights spent camping.",
    "Brakk had been missing his notebook for a while and was glad to have it back. He offered to teach camping in return.",
    "The notebook went back to Brakk near Razor Hill. He thought its finder had the look of an adventurer and offered lessons in camping.", nil, true)
Q(96659, "The Adventurer", "Mulgore", 6, "horde_narache",
    "Kaga Wildhoof had once helped Chief Hawkwind and refused any payment. Hawkwind saw a chance to repay her and sent supplies to her camp outside Bloodhoof Village.",
    "Chief Hawkwind owed a debt to the adventurer Kaga Wildhoof, camped just outside Bloodhoof Village. He sent supplies to settle it.",
    "Kaga had told Hawkwind long ago that she needed no payment, but she accepted his supplies. Then she offered to teach camping in the wild.",
    "Hawkwind's supplies reached Kaga Wildhoof, who observed that the chief had never listened to her. She offered lessons in camping in return.", nil, true)
Q(96638, "The Adventurer", "Zephras Isle", 6, "forever_grove",
    "More and more of Zephras's young were seeking fortune beyond Thendal Grove. An adventurer had made camp outside Shen'dar Village, on the road southwest of the grove.",
    "Aetheen of the Gales sent the newly seasoned to an adventurer camped near Shen'dar Village, to learn what might help their own travels.",
    "Raan Wildwind greeted his visitor at the camp outside Shen'dar Village.",
    "The road southwest from Thendal Grove led to Raan Wildwind's camp and a hearty welcome.", nil, true)
Fallback("The Adventurer", false,
    "An adventurer had made camp outside the settlement and knew how to live in the wilds.",
    "A traveler camped beyond the town had lessons to share.",
    "The adventurer offered to teach camping in the wild.",
    "The meeting with the adventurer led to talk of camps and fires.", {V .. " #96652, #96656, #96659, #96638"})
pack.quests["The Adventurer"].thread = false
pack.quests["The Adventurer"].threadLabel = false
for _, id in ipairs({408, 357, 409}) do pack.questIDs[id].importance = 4 end
pack.questIDs[411].importance = 5
pack.questIDs[361].highlight = {"Thurman Agamand's last letter finally reached Yvette Farthing in Brill. She mourned him and cursed his brother Brand, then declared that her old life was over.", "From an undelivered letter, Yvette Farthing learned what had become of Thurman Agamand. Regrets were for the weak, she decided, and love was no longer among her goals."}
pack.questIDs[362].highlight = {"Devlin Agamand still chattered madly near the road to the mills. His bones went to Coleman Farthing's mantle, a first piece of revenge on the family who had failed him.", "Coleman Farthing wanted every Agamand destroyed. Devlin, the younger son, was the first, and his bones ended up on Coleman's mantle."}
pack.questIDs[354].highlight = {"The Agamands, whose pride had doomed their workers to undeath, were destroyed at their mills. Coleman Farthing received their remains and hoped they had known fear.", "Coleman Farthing's revenge on the Agamand family was complete. He hoped, foolishly as he admitted, that they had felt fear at the end."}
pack.questIDs[408].highlight = {"Captain Dargol had raised the Agamand ancestors in their family crypt. His skull reached Magistrate Sevren, who called it a telling blow against the Scourge.", "The Scourge's strongest point at Agamand Mills fell with Captain Dargol. Sevren said the victory would not go unnoticed by the Forsaken or their enemies."}
pack.questIDs[357].highlight = {"A stolen spellbook told Bethor Iceshard that the lich of Brightwater Lake was Gunther Arcanus, his friend and comrade before the plague.", "The spellbook taken from the island in Brightwater Lake named its owner. Gunther Arcanus, Bethor's old comrade, had grown more powerful in death."}
pack.questIDs[366].highlight = {"Gunther Arcanus got his spellbook back from the same thief who had taken it. Bethor's enchantment on it suggested that his old friend was free of the Lich King.", "Bethor's spellbound message reached Gunther Arcanus on his island. The lich who trusted no undead began to wonder whether Bethor had escaped the Lich King too."}
pack.questIDs[409].highlight = {"Gunther Arcanus asked for Lillith Nefara's destruction as proof against the Scourge. When she fell, he admitted he had believed himself the only one with free will.", "Lillith Nefara rose at the bloody altar off Gunther's island and was destroyed. Gunther was astonished to learn that others had broken the Lich King's hold."}
pack.questIDs[411].highlight = {"Gunther Arcanus sent a Nether Gem to Bethor Iceshard. Through it the old friends from Dalaran could speak again, and Gunther agreed to join the Forsaken.", "Bethor received Gunther's Nether Gem in the Undercity. The lich of Brightwater Lake had been won over, and the Dark Lady would hear of it."}
pack.questIDs[97558].highlight = {"Forsaken skin did not heal, so Shelene Rhobart patched it with hides. Duskbat membranes, darkhound hides and murloc skin restocked her supplies.", "Shelene Rhobart's skins for injured Forsaken were running low. The new hides would serve, she said, from thick darkhound leather to fine membranes for faces and fingers."}
pack.questIDs[96656].highlight = {"A stranger on the road to Brill turned out to be Eleanor Shackleton, an adventurer with no ties to the Scarlet Crusade. She offered lessons in camping.", "Sent to check on a stranger near Brill, the newly risen found Eleanor Shackleton passing through, and an offer to learn camping."}

-- Durotar's valley, roads and coast (overnight 2026-11-05). Forever additions
-- (96821, 96822, 96825, 96876, 97279, 99048-99052) are labelled by their IDs;
-- names not in the quest text come from LoreForever Z_durotar/Z_general.
Q(787, "The New Horde", "Durotar", 1, "horde_trials",
    "Eitrigg oversaw the training of recruits in the Valley of Trials. He had once left the Horde over the Burning Legion's influence, and came back after Thrall rescued him from human captors.",
    "Thrall had charged Eitrigg with training the Horde's recruits. The old warrior spoke of a Horde free of demons and guided by its shamans, the vision that had brought him back.",
    "The recruit reached Gornek in the Den, as Eitrigg had directed.",
    "Eitrigg's account of the new Horde gave way to Gornek's instructions in the Den.")
Q(97279, "Wayward Weapons", "Durotar", 2, "horde_trials",
    "New recruits kept arriving at the Den, and the weaponsmith Kzan was running short of training weapons. Failed recruits had left theirs lying around the valley.",
    "A trainer in the Den wanted to see what a new recruit could do among the boars, and to salvage six abandoned training weapons for Kzan along the way.",
    "Kzan received the six weapons and set to repairing them for the next wave of recruits.",
    "The abandoned training weapons went back to Kzan, ready for recruits who had not yet arrived.")
Q(4402, "Galgar's Cactus Apple Surprise", "Durotar", 3, "horde_trials",
    "Galgar wiped his brow in the heat of the Valley of Trials. With ten cactus apples he could make his famous cactus apple surprise.",
    "Galgar promised a few portions of his cactus apple surprise, and a training manual, for ten cactus apples from around the valley.",
    "Galgar made his cactus apple surprise and added a little something extra.",
    "The cactus apples became Galgar's famous treat, a few portions of it packed for later travels.")
Q(96821, "Legging It", "Durotar", 6, "horde_roads",
    "Fewer travelers were coming from Razor Hill. Spiders had begun nesting along the road, on top of the scorpids.",
    "A troll on the road north wanted the new spider nests thinned, and word sent to Razor Hill that the path was safer.",
    "Razor Hill heard that the road was safer. The peons, afraid to travel south for some time, could go back to work.",
    "With the spiders thinned, Razor Hill could send its peons south to work again.")
Q(96822, "For Honor", "Durotar", 6, "horde_roads",
    "Many Horde warriors had died when Tiragarde Keep was sacked. The humans had since reinforced the ruins, and the fallen could not be gathered and honored.",
    "Weapons of the Horde's dead still lay in the ruins around Tiragarde Keep. They were wanted for a place of honor.",
    "The fallen warriors' weapons were recovered from the ruins. They would always be remembered.",
    "The weapons left at Tiragarde came home, and the warriors who had carried them would be remembered.")
Q(96876, "Ukor's Lost Pack", "Durotar", 8, "horde_trade",
    "A pack with Ukor's name crudely stitched on the flap lay abandoned in southern Durotar.",
    "Ukor the peon had dropped his pack while running from a huge spider.",
    "Ukor had never expected to see his pack again, and called its finder a hero.",
    "The pack went back to Ukor, who had dropped it fleeing a huge spider.")
Q(785, "A Strategic Alliance", "Durotar", 8, "horde_darkspear",
    "The orcs had sworn a pact of protection with the Darkspear trolls. Thrall's orders were to make sure Sen'jin Village faced no direct threat.",
    "Lar Prowltusk, one of the Darkspear's most trusted scouts, was keeping watch beyond Sen'jin Village. The Warchief's orders sent help his way.",
    "The help reached Lar Prowltusk where he watched over Sen'jin's western flank.",
    "The pact between orc and troll brought aid to Lar Prowltusk on Sen'jin's western flank.")
Q(99048, "A Missing Hand", "Durotar", 11, "horde_roads",
    "Heglan Shadeeye of the Shattered Hand had been watching Tiragarde Keep from a distance, and her reports had stopped. No one believed the humans had caught her.",
    "The Shattered Hand's watcher at Tiragarde Keep had gone silent. Something more dangerous than the human garrison was suspected.",
    "Heglan's body lay cold in the wreckage of her hut. Whatever had killed her did not seem human.",
    "The search found Heglan Shadeeye dead in her ruined hut, with signs nearby of an attacker that was not human.")
Q(99049, "Threat from Below", "Durotar", 11, "horde_roads",
    "Heglan Shadeeye's post had been wrecked in a skirmish, and her attackers had not escaped unhurt. Orgnil Soulscar would want any evidence they had left.",
    "Signs around Heglan's ruined post pointed to her killers. The evidence was bound for Orgnil in Razor Hill.",
    "Orgnil recognized the banner and blade fragment as naga work, come down the coast from the north. Pressure from two directions, he warned, would be too much for Razor Hill.",
    "The evidence named the naga. Orgnil would not let them gain a foothold on Durotar's coast.", nil, true)
Q(99051, "Threat from Below", "Durotar", 11, "horde_roads",
    "Naga scouts were setting up camp on Durotar's coast. Orgnil's orders were to slaughter them and bring back their fins as a lesson.",
    "It was not the first time the naga had troubled Durotar. Their scouts' camps were to be found and destroyed.",
    "The naga scouts' fins reached Razor Hill, and grunts were set to watch for stragglers in case the lesson had not taken.",
    "With their scouts killed, the naga were expected to go back north. Grunts were set to watch for any who stayed.", nil, true)
Q(99052, "Threat from Below", "Durotar", 12, "horde_roads",
    "A scout reported that a young sea giant had followed the naga down the coast. Young or not, it could rip an orc in half.",
    "The sea giant had to be killed before it caught anyone off guard, and the orders came with advice to bring help.",
    "The young sea giant was dead. Few, Razor Hill's defenders said, could claim to have survived such a fight.",
    "The sea giant that had followed the naga south would trouble Durotar's coast no longer.", nil, true)
Fallback("Threat from Below", false,
    "An enemy had come up out of the sea.",
    "Trouble from the water threatened the settlement nearby.",
    "The threat from the sea was met.",
    "The coast's defenders had one less danger to watch.", {V .. " #99049, #99051, #99052"})
pack.quests["Threat from Below"].thread = false
pack.quests["Threat from Below"].threadLabel = false
Q(96825, "This Fruit Could Bite Back", "Durotar", 6, "horde_trade",
    "Orgrimmar's hunters and fishers brought plenty of savory food, but rarely anything sweet. A cook for the troops had seen a prickly cactus fruit growing in the hills to the west, among the quilboar camps.",
    "A cook for Orgrimmar's troops wanted prickly pears from the western hills, as spiny as the quilboar who camped around them.",
    "The cook meant to make something tasty from the fruit and save the seeds. One day, he hoped, prickly pears would grow all around Orgrimmar.",
    "The prickly pears reached Orgrimmar, and their seeds were kept for planting.")
for _, id in ipairs({99048, 99049}) do pack.questIDs[id].importance = 4 end
pack.questIDs[99052].importance = 5
pack.questIDs[787].highlight = {"Eitrigg welcomed the recruits to the Valley of Trials. He had left the Horde once over the Legion's influence, and returned for Thrall's vision of a Horde guided by shamans.", "In the Valley of Trials, Eitrigg spoke of the Horde Thrall wanted, free of demons, then sent the recruit on to Gornek."}
pack.questIDs[4402].highlight = {"Ten cactus apples from the Valley of Trials became Galgar's famous cactus apple surprise, with something extra on the side.", "Galgar wanted cactus apples against the valley's heat. In return he made his famous surprise and added a little something extra."}
pack.questIDs[96822].highlight = {"Weapons of the warriors who fell at Tiragarde Keep were taken back from the reinforced ruins, so that the dead could be honored and remembered.", "The fallen of the Tiragarde assault had left their weapons in the ruins. Recovered, they would be displayed in a place of honor."}
pack.questIDs[99048].highlight = {"Heglan Shadeeye of the Shattered Hand had stopped reporting from Tiragarde Keep. She was found dead in her wrecked hut, killed by something that did not seem human.", "The search for the Shattered Hand's missing watcher ended at a wrecked hut, where Heglan Shadeeye lay dead."}
pack.questIDs[99049].highlight = {"The evidence around Heglan's post was naga work. Orgnil Soulscar warned that pressure from the sea and the land together would be too much for Razor Hill.", "A naga banner and a broken blade from Heglan's post reached Orgnil. The naga had come down the coast from the north, and he meant to stop them there."}
pack.questIDs[99052].highlight = {"A young sea giant had followed the naga down Durotar's coast. It was killed, and Razor Hill's defenders said few could claim to have survived such a fight.", "The sea giant that had followed the naga down the coast was dead. Razor Hill's defenders called it a kill to be proud of."}

-- Mulgore and Bloodhoof Village (overnight 2026-11-05). The Longwalker, Galak
-- and shredder stages are Forever additions (98424-98435, 99079-99101); names
-- beyond the quest text come from LoreForever Z_mulgore/Z_general.
local HL = "horde_longwalkers"
pack.threads[HL] = "the Longwalkers and the Galak raid"
Q(3376, "Break Sharptusk!", "Mulgore", 5, "horde_narache",
    "The Bristleback quilboar of Brambleblade Ravine kept up their war on the tauren under Chief Sharptusk Thornmantle. Brave Windfeather wanted the chief's head.",
    "Others had failed against Chief Sharptusk Thornmantle in his makeshift village east of Red Cloud Mesa. Brave Windfeather charged a newcomer with the hunt.",
    "Sharptusk's head reached Brave Windfeather, who declared justice served and the chief's death a warning to all who threatened the tauren's home.",
    "The Bristlebacks had lost their chief. Windfeather meant the deed as a warning to anyone else who would threaten Red Cloud Mesa.")
Q(1656, "A Task Unfinished", "Mulgore", 5, "horde_narache",
    "A young tauren in the middle of the Rite of Strength was too tired to carry a father's furs to the inn at Bloodhoof Village as well.",
    "Furs for the Bloodhoof inn waited on Red Cloud Mesa while their bearer was busy with the Rite of Strength.",
    "Innkeeper Kauth received the furs sooner than he had expected. They would make good blankets for anyone staying at his inn.",
    "The furs reached Innkeeper Kauth in Bloodhoof Village, who said his inn was open to all of his people.")
Q(770, "The Demon Scarred Cloak", "Mulgore", 12, "horde_narache",
    "Ghost Howl's ragged hide still bore a terrible wound from the white wolf's battles against the Burning Legion.",
    "The great wolf Ghost Howl was dead, and someone in Bloodhoof Village ought to know.",
    "An old hunter in Bloodhoof Village could barely believe Ghost Howl had been defeated. He gave one of his own weapons and hoped the wolf's spirit had found peace.",
    "Word of Ghost Howl reached Bloodhoof Village, where an aging hunter parted with a weapon from his own hunting days.")
Q(99079, "Longwalker Malah", "Mulgore", 9, HL,
    "The Longwalkers were the tauren's most trusted scouts, loyal to the High Chieftain alone. Longwalker Malah had gone to watch the eastern borders and was three days overdue.",
    "Brave Wildrunner had to keep Bloodhoof Village safe, so the search for the missing Longwalker Malah fell to others. She would be known by her headband and feathered staff.",
    "Malah had not died naturally. Arrows covered her back and the ground around her.",
    "The search found Longwalker Malah dead, shot with many arrows.")
Q(99081, "Grim Tidings", "Mulgore", 9, HL,
    "The arrows in Malah's back pointed toward a new centaur camp, stirring with a small raiding party. Her report was still clenched in her hand.",
    "Malah's report, and the centaur camp whose arrows had killed her, were news for Brave Wildrunner in Bloodhoof Village.",
    "Brave Wildrunner called the news dire and said Baine had to be told at once.",
    "Wildrunner learned of Malah's fate and the centaur raiders who had killed her. Baine Bloodhoof would have to know.")
Q(99101, "Our Ancient Enemy", "Mulgore", 9, HL,
    "Baine Bloodhoof led the village, and the dead Longwalker's report had to reach him without delay.",
    "Brave Wildrunner sent Malah's report to Baine at the center of the village.",
    "Baine read the report, his gaze darkening, and said the incursion would not stand.",
    "The centaur incursion was in Baine's hands now, and he declared that it would not stand.")
Q(99080, "Drive Them Out", "Mulgore", 9, HL,
    "Baine would not yield a blade of grass to the centaur. He wanted their camp destroyed before the raiders could rest and ride on Bloodhoof Village, with none left to rally others in the Barrens.",
    "Baine Bloodhoof ordered an attack on the centaur camp, and wanted the raiding party's leader's head as a warning to others.",
    "Baine said he had heard the moment the last centaur fell. He called it a great victory for the village, and a safety its young needed more than ever.",
    "The centaur raiders were gone from Mulgore. Baine called the centaur blood an honor unlike any other among his people, and gave his deepest thanks.")
Q(99082, "The High Chieftain", "Thunder Bluff", 9, HL,
    "Baine sent word of the defense to his father in Thunder Bluff. Cairne Bloodhoof had ridden with the young Thrall to reclaim the plains from the centaur.",
    "Baine Bloodhoof wanted the defense of Mulgore honored by the High Chieftain himself, atop Thunder Bluff's central rise.",
    "Cairne was angered that the Galak dared show themselves in Mulgore. Driving them out, he said, had brought pride to the ancestors.",
    "Cairne honored the victory over the Galak with a gift. He hoped the centaur would remember the pain that awaited any return.")
Q(98430, "The Longwalkers", "Mulgore", 8, HL,
    "Longwalker Perith Stormhoof had gone to Bleachmane Rock on Cairne Bloodhoof's orders to speak with the gnolls there. They answered his diplomacy with violence.",
    "The rest of Perith Stormhoof's mission was secret, as all Longwalker business was. He asked only for help escaping before the gnolls made a feast of him.",
    "Cairne was relieved to hear his most trusted scout was safe, and said the rescue had served the tauren more than anyone knew.",
    "Cairne learned that Longwalker Stormhoof was well. He thanked those who had risked their lives for his scout and offered the hospitality of Thunder Bluff.")
Q(98424, "Fizsprocket's Notes", "Mulgore", 10, "horde_venture",
    "Worn papers, folded apart from the rest, had been tucked in Supervisor Fizsprocket's breast pocket. They detailed the Venture Company's operations in the region.",
    "The supervisor's notes held information that could be used against the Venture Company, and Morin Cloudstalker in Bloodhoof Village was waiting for them.",
    "Morin Cloudstalker read Fizsprocket's notes and judged them most valuable. The next move, he said, was clear.",
    "Morin Cloudstalker found in the supervisor's papers what he needed against the company.")
Q(98427, "Ceasing Operations", "Mulgore", 12, "horde_venture",
    "Fizsprocket's notes spoke of a shredder in the mine northeast of Bloodhoof Village. Morin Cloudstalker had seen such machines erase whole glades in days.",
    "A Venture Company shredder threatened the trees a stone's throw from where Bloodhoof's young took their first steps. Morin wanted it stopped, and advised gathering others first.",
    "The shredder was stopped. Morin said all of Bloodhoof Village was in debt for it.",
    "The mine's shredder would fell no more trees, and Morin asked the Earth Mother's grace for those who had stopped it.")
Q(98435, "Thunderhorn's Report", "Thunder Bluff", 10, "horde_wells",
    "Mull Thunderhorn wanted the elders of Thunder Bluff to know what had been done for Mulgore's wells. His report was for Arch Druid Hamuul Runetotem on the Elder Rise.",
    "The work at Mulgore's wells had to reach the elders. Mull Thunderhorn sent his report to Hamuul Runetotem in Thunder Bluff.",
    "Hamuul said he could feel the joy running through Mulgore's streams. The wells, he said, sustained the tauren and the wildlife they depended on.",
    "Hamuul honored Mull Thunderhorn's request with a token of thanks for the work at the wells.")
for _, id in ipairs({3376, 770, 99079, 98430, 98427}) do pack.questIDs[id].importance = 4 end
for _, id in ipairs({99080, 99082}) do pack.questIDs[id].importance = 5 end
pack.questIDs[3376].highlight = {"Chief Sharptusk Thornmantle had led the Bristlebacks' war on the tauren. His head reached Brave Windfeather, who called it justice and a warning.", "Others had failed against Sharptusk Thornmantle in Brambleblade Ravine. When his head reached Brave Windfeather, the quilboar had lost their chief."}
pack.questIDs[770].highlight = {"Ghost Howl, the white wolf scarred in battle with the Burning Legion, was dead. An old hunter in Bloodhoof Village gave a weapon of his own and hoped the wolf's spirit was at peace.", "The demon-scarred hide of Ghost Howl reached Bloodhoof Village, where an aging hunter could barely believe the great wolf had fallen."}
pack.questIDs[99079].highlight = {"Longwalker Malah was three days overdue from the eastern borders. She was found dead, with arrows in her back and on the ground around her.", "The search for the missing Longwalker Malah ended in the east of Mulgore, where she lay shot with many arrows."}
pack.questIDs[99080].highlight = {"Baine Bloodhoof would not yield a blade of grass to the centaur raiding Mulgore. Their camp was destroyed, and he called it a great victory for the village and its young.", "The centaur raiding party was driven out of Mulgore before it could ride on Bloodhoof Village. Baine gave his deepest thanks."}
pack.questIDs[99082].highlight = {"Cairne Bloodhoof heard that the Galak had dared enter Mulgore and been driven out. He said the victory had brought pride to the ancestors.", "Baine's report of the defense reached his father atop Thunder Bluff. Cairne honored the victory over the Galak with a gift."}
pack.questIDs[98430].highlight = {"Longwalker Perith Stormhoof's mission to the gnolls had turned violent. He was brought out alive, and Cairne thanked those who had risked their lives for his most trusted scout.", "Cairne's secret envoy to the gnolls nearly became their feast. Perith Stormhoof escaped, and the High Chieftain was relieved to hear it."}
pack.questIDs[98427].highlight = {"A Venture Company shredder in the mine near Bloodhoof Village could erase a glade in days. It was stopped, and Morin Cloudstalker said the whole village was in debt.", "A Venture Company shredder had threatened the trees near Bloodhoof Village. Once it was stopped, Morin asked the Earth Mother's grace for those who had done it."}
pack.questIDs[98435].highlight = {"Mull Thunderhorn's report on Mulgore's wells reached Hamuul Runetotem, who said he could feel the joy in the plains' streams.", "Hamuul Runetotem received Mull Thunderhorn's report on the wells with a token of thanks. The water sustained the tauren and the animals they depended on."}

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
    "Renferrel and Faranell had more to work with in their search for a plague.",
    "Another sample or record reached the Royal Apothecary Society's plague research.", {V .. " #447, #450, #451"})

-- Shaman trials. The title is shared across ingredients, introductions,
-- manifestations and rewards, including Forever's other racial routes.
Fallback("Call of Earth", "shaman_earth",
    "The earth rite taught patience, endurance and the foundations of the shaman's craft.",
    "Sapta and sacred ground had their places in the call of earth.",
    "The earth rite moved a step further.",
    "Another part of the earth's teaching had been attended to.", {V .. " #1516-1521, #92466-92468", F .. " #94374"})
Fallback("Call of Fire", "shaman_fire",
    "The fire rite concerned creation as well as destruction.",
    "The teaching of fire demanded more than strength alone.",
    "The fire rite moved a step further.",
    "The work belonged to the shaman's study of fire.", {V .. " #1522-1527, #2984", F .. " #94449, #94465-94468"})
Fallback("Call of Water", "shaman_water",
    "Water's healing power depended on purity, and its teaching ranged far beyond a single pool.",
    "The water rite joined practical gathering with concern for corrupted springs.",
    "The water rite moved a step further.",
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
    "The call of air moved a step further.",
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
    "The damaged construct in Valanaar received attention.",
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

-- Zephras: Thendal's first trials, the cult's reach and the Windshapers'
-- crossing to Kalimdor (Forever content, overnight 2026-11-05). Halaan,
-- Myriaal, Ventaari, Valreaa, Hanaa and Belathaan's family name come from
-- LoreForever Z_zephras; the rest is quest text. No race implies allegiance.
Q(94414, "The Anchors of Zephras", "Zephras Isle", 2, "forever_winds",
    "Halaan Hawk-Eye often came to look upon the ancient anchor pylon. Gifts of the wind spirits, the pylons bound and sustained Zephras, but their magic had grown unstable.",
    "The anchor pylons that held Zephras together showed no sign of distress, yet their magic wavered. Halaan Hawk-Eye offered to lend a gift so that others could look upon them.",
    "Halaan gave thanks for the shared moment, and went on watching over the grove and pondering the state of the homeland.",
    "Halaan called the gift simple and mundane, but was grateful for it. Yearning for what was lost, Halaan said, led only to despair.")
Q(92474, "Falling With Style", "Zephras Isle", 2, "forever_grove",
    "Myriaal Mistwake had a game for the young of Thendal. Jump from a ledge, walk on the air to slow the fall, and land in front of Rorian the Dayseeker to startle him.",
    "Myriaal Mistwake dared the young to leap and float on their skyborne gift, with bonus points for startling Rorian.",
    "Rorian complained that Myriaal kept encouraging reckless use of the skyborne gifts, but allowed that a little practice inside the village was acceptable.",
    "Rorian warned against exhausting the gift thoughtlessly when it might be needed in earnest, though practice in the village was acceptable.")
Q(92598, "The Gift of Skysight", "Zephras Isle", 4, "forever_winds",
    "Ventaari Brightwish taught young Windshapers to use skysight, the gift of the elemental spirits. It was strongest at the elemental convergence among the standing stones northeast of the village.",
    "Windshapers could draw on skysight anywhere, but an elemental convergence made it stronger. The standing stones northeast of Thendal held one.",
    "Skysight, Ventaari said, had to be exercised like a muscle. Hearing what the elements said might be the key to the Windshapers' survival.",
    "The skysight was used at the convergence. Ventaari urged that the lesson be remembered, since bridging the mortal and the spiritual could prove invaluable.")
Q(92473, "Aggressive Encroachment", "Zephras Isle", 4, "forever_grove",
    "Only last week the rangers had killed a young ursera that nearly attacked a boy playing by Thendal's elder tree. Valreaa Valewind wanted the hungry beasts in the southwestern den culled.",
    "Hunger and desperation had made the ursera too dangerous to leave unchecked. Valreaa Valewind asked for the scrawniest put down and their claws brought back.",
    "Valreaa said the Rangers of the Grove were in debt for the cull, while still wondering what had made the ursera so aggressive.",
    "The ursera claws reached Valreaa. Why the beasts had turned so fierce remained a question for the rangers.")
Q(92471, "Aetheen of the Gales", "Zephras Isle", 4, "forever_grove",
    "Everything done in Thendal so far had been a trial of sorts. Aetheen of the Gales, one of the island's leaders, had been watching and had a task to give.",
    "Rorian sent the young to Aetheen of the Gales, who was assessing those coming of age.",
    "Aetheen, a member of the Council of Elders, had come to read the winds in Thendal Grove. She asked whether the young were ready to serve Zephras Isle.",
    "Aetheen had heard much from Rorian, and asked whether the next step could begin.")
Q(92470, "Foul Matriarch", "Zephras Isle", 5, "forever_grove",
    "Aetheen of the Gales offered a dangerous test of resolve. In the caves south of the village, the ursera matriarch the rangers called Urs'anah had to be put down.",
    "To be of service to Zephras Isle, Aetheen said, the young would face much greater challenges. The first was Urs'anah, matriarch of the southern caves.",
    "Aetheen judged the test well done. The path ahead, she said, had to lead beyond the safety of Thendal Village.",
    "Urs'anah was dead. Aetheen saw great promise, and said it was time to look beyond Thendal Village.")
Q(92544, "Al'Aketh Thugs", "Zephras Isle", 5, "forever_cult",
    "Al'Aketh ruffians under Malduko Cloudcrush had camped by the temple ruins southwest of the grove, attacking travelers and pressing people into the cult. Hanaa Nightwind believed Lorthuna had sent them.",
    "Hanaa Nightwind could not leave the post that warned travelers leaving the grove, so the cultists at the temple ruins and their leader Malduko Cloudcrush were left to others.",
    "Hanaa had barely kept from joining the fight, hoped the cultists had got the message, and gave thanks on behalf of the Rangers of Thendal Grove.",
    "Malduko Cloudcrush and his ruffians were dealt with, and the Rangers of Thendal Grove gave their thanks.")
Q(92472, "The Next Step", "Zephras Isle", 5, "forever_cult",
    "The Al'Aketh Cult worshipped Al'Akir the Windlord, and its zealots grew more deadly by the day. Aetheen of the Gales sent help south to Constable Aonda in Shen'dar Village.",
    "Shen'dar Village, to the south, needed aid against the cult. Aetheen told the young to present themselves to Constable Aonda.",
    "Aonda said the newcomer did not look like much, but Shen'dar would not turn down help sent by Elder Aetheen.",
    "Constable Aonda accepted the aid Aetheen had sent, doubts and all.")
Q(93746, "A Firm Response", "Zephras Isle", 9, "forever_cult",
    "The High Order had been warned against meddling in Windshaper affairs. Ayessa Dawnsinger wanted Belathaan sent back to them bruised, and he had been seen on the road north toward the Shrine of Akir.",
    "Ayessa Dawnsinger meant to make an example of Belathaan, the High Order's envoy, and confront him alone on the road north.",
    "Belathaan was dead. Ayessa learned that the High Order had sent him to talk peace with the Al'Aketh, and blamed its arrogance, not the one who brought the news.",
    "The news of Belathaan's death stunned Ayessa. There was no peace with the cult, she said, and Elaadrin should never have sent him to treat with them alone.")
Q(93090, "What Comes Next", "Zephras Isle", 13, "forever_winds",
    "High Elder Shadowsong gave the Windshapers' expedition his blessing. He hoped whatever solution they found would bring the stability Zephras had lacked for years.",
    "Shadowsong sent his thanks to Ayessa for all that the Windshapers and the Earthen Ring had done for Zephras Isle.",
    "Ayessa was pleased to have the high elder's blessing. With the cult defeated and preparations made, she judged it time to go.",
    "Muln had worked to make skycutter crossings to Mulgore reliable, and some of the Windshapers were already waiting there. Ayessa declared the expedition ready.")
Q(95350, "Welcome to Azeroth", "Orgrimmar", 13, "forever_winds",
    "The Earthen Ring belonged to the Horde, and its allies were the Windshapers' hope of survival. An emissary was to travel from Thunder Bluff to Orgrimmar and meet Warchief Thrall.",
    "The Windshapers needed the Horde's friendship. Their emissary was sent from Mulgore to Thrall in Orgrimmar.",
    "Thrall had been told to expect an emissary of the Windshapers. He had not expected a high elf, but welcomed the guest and granted passage through Horde lands.",
    "Warchief Thrall gave the Windshaper his blessing to travel through Horde lands.")
Q(93739, "Exploring the Horde", "Orgrimmar", 13, "forever_winds",
    "The Horde's territory was vast, and Thrall advised a guest to visit Orgrimmar, Thunder Bluff and the Undercity in turn.",
    "Thrall's advisor Nazgrel had directions for a guest who meant to see the Horde's capital cities.",
    "The Windshaper guest reached Nazgrel in Grommash Hold.",
    "Thrall's advice brought the Windshaper guest to Nazgrel.")
for _, id in ipairs({92470, 92472, 93746}) do pack.questIDs[id].importance = 4 end
for _, id in ipairs({93090, 95350}) do pack.questIDs[id].importance = 5 end
pack.questIDs[94414].highlight = {"Halaan Hawk-Eye watched the anchor pylons that bound Zephras together. Their splendor had not changed, but their magic had grown unstable.", "Through Halaan Hawk-Eye's gift, the ancient anchor pylon could be seen as Halaan saw it, sound to the eye though its magic wavered."}
pack.questIDs[92474].highlight = {"Myriaal Mistwake's game sent the young leaping and floating down to startle Rorian the Dayseeker. Rorian disapproved, then allowed that practice in the village was acceptable.", "Floating down on the skyborne gift to land before Rorian earned a lecture on recklessness, and grudging permission to practice in the village."}
pack.questIDs[92473].highlight = {"After a young ursera nearly attacked a boy by Thendal's elder tree, Valreaa Valewind had the hungry den culled. Why the beasts had grown so aggressive, no one knew.", "The ursera den southwest of Thendal was culled, and the Rangers of the Grove were in debt for it."}
pack.questIDs[92470].highlight = {"Aetheen of the Gales tested the young against Urs'anah, matriarch of the ursera in the southern caves. When she fell, Aetheen said the path now led beyond Thendal Village.", "Urs'anah, the ursera matriarch, was put down in the caves south of Thendal. Aetheen saw great promise in the deed."}
pack.questIDs[92544].highlight = {"Malduko Cloudcrush's cult ruffians had been preying on travelers near the temple ruins. They were dealt with, and Hanaa Nightwind thanked the help for the Rangers of Thendal Grove.", "The Al'Aketh thugs at the temple ruins southwest of the grove lost their leader, Malduko Cloudcrush."}
pack.questIDs[93746].highlight = {"Ayessa Dawnsinger wanted the High Order's envoy Belathaan sent home bruised. Instead he died, having been sent by Elaadrin to talk peace with the cult.", "Ayessa blamed Elaadrin for sending Belathaan of the High Order to treat with the Al'Aketh alone. The envoy was dead."}
pack.questIDs[93090].highlight = {"High Elder Shadowsong blessed the Windshapers' expedition to Kalimdor. With the cult defeated and skycutters crossing to Mulgore, Ayessa judged it time to go.", "Ayessa Dawnsinger received the high elder's blessing. Some Windshapers were already waiting in Mulgore, and the expedition was ready."}
pack.questIDs[95350].highlight = {"In Orgrimmar, Warchief Thrall received the Windshapers' emissary. He had not expected a high elf, but welcomed the guest and granted passage through Horde lands.", "The Windshapers' emissary met Thrall in Orgrimmar and left with his blessing to travel through Horde lands."}

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

-- The Crossroads, Camp Taurajo and the road north (overnight 2026-11-05).
-- Thork, Gazrog, Regthar, Mangletooth's cage and Tatternack are placed from
-- LoreForever Z_barrens entries; everything else is from the quest text.
local HG = "horde_mangletooth"
pack.threads[HG] = "the bargain with caged Mangletooth"
Q(5041, "Supplies for the Crossroads", "The Barrens", 14, "horde_roads",
    "A Razormane attack on a caravan had taken supplies the Crossroads badly needed. Thork asked that the lost goods be watched for in the quilboar camps.",
    "The Razormane were growing fat on stolen Crossroads supplies. Thork wanted them recovered from the quilboar camps.",
    "Thork laughed with relief as the supplies came back, and called their finder a boon to the Crossroads.",
    "The supplies came back from the quilboar camps, and Thork offered his help in return.")
Q(3281, "Stolen Silver", "The Barrens", 18, "horde_roads",
    "The raptor thieves were dead, but the Crossroads guards' silver was still missing. Gazrog suspected it lay in the Raptor Grounds south of Ratchet.",
    "Gazrog wanted the guards' stolen payroll recovered from the raptor nests south of Ratchet.",
    "The silver was found in the raptors' lair. Gazrog wondered whether the stories of their intelligence were truer than he had thought, and said the guards owed their next month's pay to its finder.",
    "The guards' silver came back to the Crossroads. Gazrog could hardly believe raptors would want silver at all.")
Q(1358, "Sample for Helbrim", "The Barrens", 15, "horde_apothecary",
    "Apothecary Helbrim at the Crossroads was studying how Lordaeron's toxins affected the beasts of Kalimdor. A sample of the wolf hearts Renferrel had sent to the Undercity was meant for him.",
    "The wolf hearts from Silverpine had a use across the sea. A sample was bound for Apothecary Helbrim at the Crossroads.",
    "Helbrim welcomed the sample. If the first reports were true, the hearts' toxicity could advance the apothecaries' knowledge of poisons.",
    "The hearts reached Helbrim, who hoped their poison would teach him more.")
Q(4021, "Counterattack!", "The Barrens", 20, "horde_kolkar",
    "Horde victories over the Kolkar had maddened the centaur. A war band had come from Desolace for vengeance and was moving on Regthar Deathgate's bunkers from the west.",
    "Regthar Deathgate expected the Kolkar invaders to keep coming until their leader, Warlord Krom'zar, showed himself. He wanted a piece of Krom'zar's banner as proof.",
    "Krom'zar's banner proved the Kolkar invaders defeated. Regthar promised that Thrall would hear of it.",
    "The counterattack from Desolace broke at the bunkers with Warlord Krom'zar's defeat. Regthar told the victors to stand tall.")
Q(6541, "Report to Kadrak", "The Barrens", 19, "horde_roads",
    "The Horde had set up an outpost on the Zoram Strand in Ashenvale and needed recruits for its new fronts. Kadrak at the northern watch tower led the campaign.",
    "Kadrak, in charge of the Ashenvale campaign, was taking new recruits at the watch tower in the northern Barrens.",
    "Kadrak spoke of Ashenvale as a divided land, where the Horde now held Zoram Strand and Splintertree Post.",
    "At the watch tower, Kadrak told of recent successes, with outposts at the Zoram Strand and at Splintertree just to the north.", nil, true)
Q(6542, "Report to Kadrak", "The Barrens", 19, "horde_roads",
    "New fronts in Ashenvale needed defenders, and recruits were sent to Kadrak at the watch tower in the northern Barrens.",
    "The Horde's outpost on the Zoram Strand was new, and Kadrak was gathering recruits to hold it.",
    "Kadrak described the Horde's progress in Ashenvale, a divided land, with outposts at the Zoram Strand and Splintertree.",
    "The recruit reached Kadrak, who had good news from Ashenvale and two outposts to show for it.", nil, true)
Fallback("Report to Kadrak", "horde_roads",
    "Kadrak led the Horde's campaign into Ashenvale from the watch tower in the northern Barrens.",
    "The Horde's new fronts in Ashenvale needed recruits.",
    "Kadrak spoke of the Horde's outposts in Ashenvale.",
    "The watch tower in the northern Barrens received another recruit.", {V .. " #6541, #6542"})
Q(6543, "The Warsong Reports", "The Barrens", 19, "horde_roads",
    "Kadrak had scouts in Ashenvale and needed a runner to carry their orders. The route ran to Zoram'gar on the coast, to Splintertree Post, and to a scout on the road toward Azshara.",
    "Kadrak's scouts in Ashenvale were waiting for orders, and he wanted their reports in return.",
    "Kadrak had his scouts' updates and could plan the Horde's next move in Ashenvale.",
    "The reports from Zoram'gar, Splintertree and the eastern road reached Kadrak. He called them crucial to the Horde's plans.")
Q(878, "Tribes at War", "The Barrens", 21, HG,
    "Mangletooth, a Razormane caged at Camp Taurajo, offered to reveal who really troubled Thork. First he wanted the Bristlebacks' spiritual leaders killed, so his own tribe could win.",
    "From his cage, Mangletooth bargained for blood. He would give the Horde information once the Bristleback wise ones to the north were dead.",
    "Mangletooth should have been glad that the Bristlebacks knew his tribe's pain. Instead he complained that his own people had left him to rot in a cage.",
    "The Bristleback wise ones were dead, but Mangletooth's bitterness turned toward the Razormane who had abandoned him.")
Q(5052, "Blood Shards of Agamaggan", "The Barrens", 21, HG,
    "Agamaggan's blood had hardened into red stones in the earth, and the Bristlebacks carried them as totems. Mangletooth promised quilboar magic for enough of the shards.",
    "Mangletooth knew the secrets of the blood shards the Bristlebacks dug up. He asked for one to show that his visitor understood.",
    "Mangletooth held a blood shard again after a long time without one. No cage, he said, could stop Agamaggan's power.",
    "The shards reached Mangletooth, who promised to set his visitor loose on the people who had turned their backs on him.")
Q(879, "Betrayal from Within", "The Barrens", 25, HG,
    "Mangletooth named the three Razormane who led the raids on the Horde, Nak, Kuz and Lok Orcbane, far in the southern Barrens. He wanted them dead as they had left him to die.",
    "The Razormane raids on the Crossroads were led by a caster, a tracker and a warrior called Orcbane. Mangletooth promised peace from his tribe if all three were killed.",
    "Nak, Kuz and Lok Orcbane were dead. Mangletooth said it was better this way, and that his old tribe should have made sure of him before turning their backs.",
    "Mangletooth's betrayers were dead, and he regretted nothing. One task remained, he said.", nil, true)
Q(906, "Betrayal from Within", "The Barrens", 25, HG,
    "Mangletooth wanted Lok Orcbane's head taken to Thork at the Crossroads. Thork would understand without words, though he would never believe a caged quilboar had helped.",
    "Lok's head was bound for Thork. Mangletooth stayed in his cage, promising Agamaggan's blessing to the one who carried it.",
    "Thork was amazed that the leader of the raids was dead. He admitted he had thought a different quilboar was behind the attacks on his supply lines.",
    "Lok Orcbane's head reached Thork, who had no words but plenty of thanks. The Crossroads, he said, should respect such strength.", nil, true)
Fallback("Betrayal from Within", HG,
    "The caged Mangletooth had turned against the Razormane who abandoned him.",
    "Mangletooth's grudge against his old tribe reached as far as the Crossroads.",
    "Mangletooth's revenge on the Razormane went a step further.",
    "The Razormane leaders felt the weight of Mangletooth's betrayal.", {V .. " #879, #906"})
Q(893, "Weapons of Choice", "The Barrens", 24, "horde_roads",
    "Tatternack Steelforge at Camp Taurajo had heard that the Razormane were making sturdier weapons with no skilled smiths among them. He wanted a dagger, a wand and a shield to study.",
    "On the Warchief's orders, Tatternack Steelforge set out to learn what he could of Razormane smithing beyond the Field of Giants.",
    "The quilboar weapons were better than Tatternack had expected. He warned that the Horde might have underestimated its enemy.",
    "Tatternack found the Razormane further along than he had thought, and turned to examining the weapons closely.")
Q(3261, "Jorn Skyseer", "The Barrens", 18, "horde_hunts",
    "Sergra Darkthorn's teaching was over. Further guidance lay south at Camp Taurajo, with Jorn Skyseer.",
    "The hunter's lessons in the Barrens continued under Jorn Skyseer at Camp Taurajo.",
    "Jorn Skyseer greeted the hunter and began the next lessons.",
    "At Camp Taurajo, Jorn welcomed a new student to the hunter's path.")
Q(883, "Lakota'mani", "The Barrens", 22, "horde_hunts",
    "The hoof of the great kodo Lakota'mani was a symbol of strength.",
    "Lakota'mani's hoof was carried to Jorn Skyseer at Camp Taurajo.",
    "Jorn named Lakota'mani the Earthshaker, whose steps were like gathered thunder. He said the kodo's courage now walked with its hunter.",
    "Jorn Skyseer told of the great kodo the tauren called Earthshaker. With its courage, he said, no conflict was beyond facing.")
Q(884, "Owatanka", "The Barrens", 24, "horde_hunts",
    "Sparks flew from the thunder lizard Owatanka's tailspike when it was touched.",
    "The tailspike of the thunder lizard Owatanka was carried to Jorn Skyseer.",
    "Jorn named Owatanka Bluebolt, struck long ago by lightning and fed by the sky's rage. Its speed, he said, now ran in its hunter.",
    "The tauren called Owatanka Bluebolt, for a speed that belied his size. Jorn said the hunter now kept pace with him.")
Q(885, "Washte Pawne", "The Barrens", 25, "horde_hunts",
    "The feather of the thunderhawk Washte Pawne was painful to the touch.",
    "Washte Pawne's feather, which stung whoever held it, was brought to Jorn Skyseer.",
    "Jorn called Washte Pawne the Spirit Biter. The sting of its feather, he said, was the pain of regret, and regret could turn to wisdom.",
    "A thunderhawk's death could portend fortune or doom, Jorn said, and the Spirit Biter could bring either or both. He saw in the hunter a strength won through pain.")
Q(897, "The Harvester", "The Barrens", 24, "horde_hunts",
    "A strange, insect-like creature had been killed in the Barrens. It looked like nothing that belonged there.",
    "The head of an insect-like creature, outside the natural order of the plains, was brought to Jorn Skyseer at Camp Taurajo.",
    "Jorn Skyseer could learn nothing of the beast, for its spirit had fled. He agreed it did not belong in the Barrens, and feared it might herald a grim future.",
    "Jorn found no answers in the creature's remains, only a fear that it foretold dark times for his people.")
for _, id in ipairs({5041, 3281, 878, 879, 6543}) do pack.questIDs[id].importance = 4 end
for _, id in ipairs({4021, 906}) do pack.questIDs[id].importance = 5 end
pack.questIDs[4021].highlight = {"Kolkar from Desolace came for vengeance against Regthar Deathgate's bunkers. Their warlord Krom'zar fell, and Regthar promised that Thrall would hear of it.", "The Kolkar counterattack broke when Warlord Krom'zar was defeated. Regthar Deathgate took a piece of his banner as proof and told the victors to stand tall."}
pack.questIDs[3281].highlight = {"The Crossroads guards' stolen silver turned up in the raptors' nests south of Ratchet. Gazrog said the guards owed their next month's pay to its finder.", "Gazrog's missing payroll was found in the Raptor Grounds. He began to wonder whether raptors were cleverer than he had believed."}
pack.questIDs[878].highlight = {"Caged at Camp Taurajo, the Razormane Mangletooth traded information for the deaths of the Bristleback wise ones. When they fell, he only grumbled that his own tribe had abandoned him.", "Mangletooth wanted the Bristlebacks to feel his tribe's pain. They did, but the caged quilboar's real grievance was with the Razormane who had left him to rot."}
pack.questIDs[879].highlight = {"Nak, Kuz and Lok Orcbane had led the Razormane raids on the Horde. Mangletooth, who had named them from his cage, said it was better this way.", "The three Razormane leaders Mangletooth had betrayed were dead. The caged quilboar regretted nothing."}
pack.questIDs[906].highlight = {"Lok Orcbane's head reached Thork at the Crossroads. He had blamed a different quilboar for the raids on his supply lines, and was left without words.", "Thork learned who had truly led the raids when Lok Orcbane's head reached the Crossroads. He was without words, but not without thanks."}
pack.questIDs[883].highlight = {"Lakota'mani's hoof went to Jorn Skyseer at Camp Taurajo. He called the great kodo the Earthshaker, and said its courage now walked with the hunter.", "Jorn Skyseer received the hoof of Lakota'mani, the kodo whose steps were like gathered thunder."}
pack.questIDs[884].highlight = {"Owatanka's sparking tailspike went to Jorn Skyseer. The tauren called the thunder lizard Bluebolt, and Jorn said the hunter now kept pace with him.", "Jorn Skyseer told of Bluebolt, a thunder lizard struck by lightning long ago, whose speed belied his size."}
pack.questIDs[885].highlight = {"Washte Pawne's feather stung whoever held it. Jorn Skyseer called the thunderhawk the Spirit Biter, and said its sting was the pain of regret turned to wisdom.", "Jorn Skyseer saw strength won through pain in the hunter who brought him Washte Pawne's feather."}
pack.questIDs[897].highlight = {"The insect-like creature killed in the Barrens baffled Jorn Skyseer. It did not belong there, he agreed, and he feared it heralded a grim future.", "Jorn Skyseer could read nothing in the strange creature's remains, but he feared what its arrival in the Barrens might mean."}

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
    "The work around the samophlange moved forward.", {V .. " #894, #900, #901, #902"})
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
    "The escape was seen through.", {V .. " #114, #863"})
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

-- Ratchet's broken samophlange, Chen's brews, Gann's revenge, the coast and
-- Vrang's ridge (overnight 2026-11-05). Sputtervalve, Wenikee, Drohn, Mebok
-- and Gann are named from LoreForever Z_barrens; Vrang's chain (95494-95508)
-- and Bruuz (92706) are Forever additions.
local HV, HN2 = "horde_gann", "horde_vrang"
pack.threads[HV] = "Gann Stonespire's war on Bael Modan"
pack.threads[HN2] = "Vrang and the hermit tanner"
Q(3921, "Wenikee Boltbucket", "The Barrens", 14, "horde_ratchet",
    "Sputtervalve had already told colleagues in Undermine about the samophlange, and then he broke it. He hoped Wenikee Boltbucket, south of Mor'shan Rampart, could fix it.",
    "The broken samophlange went to Wenikee Boltbucket near Mor'shan Rampart. Sputtervalve called her clever and inquisitive.",
    "Wenikee had no idea what a samophlange was. She liked the way it moved and the sound of the gears inside, and wanted to fix it at once.",
    "Wenikee asked what a samophlange was, then heard the intricate gears inside and decided she had to fix it.")
Q(3922, "Nugget Slugs", "The Barrens", 15, "horde_ratchet",
    "Wenikee needed seventeen-point-five gauge nugget slugs to fix the samophlange. The Venture Company kept them in tool buckets at the Sludge Fen.",
    "Repairs on the samophlange waited on nugget slugs from the Venture Company's tool buckets in the Sludge Fen.",
    "Wenikee had her nugget slugs and set to work on the samophlange.",
    "The nugget slugs reached Wenikee, who could finally begin tinkering.")
Q(3923, "Rilli Greasygob", "Orgrimmar", 18, "horde_ratchet",
    "Wenikee's extra gauges read the samophlange's structural integrity at an all-time low. Rather than add more dials, she sent it to Rilli Greasygob, a former Venture Company man at Nogg's Machine Shop in Orgrimmar.",
    "If anyone could fix the samophlange, Wenikee thought, it was Rilli Greasygob in Orgrimmar's Valley of Honor.",
    "Rilli recognized the samophlange at once and asked whether its bearer had been poking around Venture Company holdings. Very brave or very stupid, he decided.",
    "The samophlange reached Rilli Greasygob, who judged anyone carrying it either very brave or very stupid.")
Q(3924, "Samophlange Manual", "Orgrimmar", 19, "horde_ratchet",
    "Rilli could fix the samophlange with its manual. His old Venture Company rival, Boss Copperplug at the Boulder Lode Mine, had hoarded it and handed out pages to a trusted few.",
    "Boss Copperplug had kept the samophlange's secrets from Rilli in their Venture Company days. The manual, and any pages he had given away, were at the Boulder Lode Mine.",
    "Rilli had the manual at last. Sputtervalve sent thanks and a reward, and Rilli promised word if the samophlange ever worked.",
    "The manual reached Rilli, eager to learn how to fix the samophlange. The repair itself was still ahead.")
Q(819, "Chen's Empty Keg", "The Barrens", 15, "horde_trade",
    "A small placard on an empty keg named Chen Stormstout and wished that it would always raise his spirits.",
    "An empty keg with Chen Stormstout's name on it was taken to Brewmaster Drohn.",
    "Drohn recognized one of Chen Stormstout's kegs. Chen had traveled with Rexxar long ago, and Drohn had not heard of him in years.",
    "The keg reminded Brewmaster Drohn of Chen Stormstout, who had traveled with Rexxar a long time before.", nil, true)
Q(821, "Chen's Empty Keg", "The Barrens", 15, "horde_trade",
    "Brewmaster Drohn had learned Chen's stormstout from his mentor, who had it from Chen himself. He needed savannah lion tusks, plainstrider kidneys and a thunder lizard horn.",
    "To brew stormstout, Chen Stormstout's namesake, Drohn needed ingredients from the beasts of the Barrens.",
    "Drohn laughed at brewing stormstout again. The batch stirred his nostalgia and reminded him of the last trogg brew he had made.",
    "The stormstout was brewed, and Drohn said the memories warmed his stomach.", nil, true)
Q(822, "Chen's Empty Keg", "The Barrens", 24, "horde_trade",
    "Drohn had another of Chen's recipes, a trogg brew with a real kick. It called for stormhide lightning glands, a greater thunderhawk's saliva gland and a kodo liver.",
    "Chen Stormstout had also taught a trogg brew, and Drohn offered to make it for anyone who brought the glands and liver.",
    "Drohn brewed his trogg brew and promised more whenever the ingredients came back.",
    "The trogg brew was ready. Drohn had known the offer would be hard to resist.", nil, true)
Fallback("Chen's Empty Keg", "horde_trade",
    "Chen Stormstout's empty keg had found its way into the Barrens.",
    "Brewmaster Drohn kept recipes that Chen Stormstout had passed on.",
    "Chen Stormstout's name came up over Drohn's brewing.",
    "Drohn's brews kept Chen Stormstout's recipes alive.", {V .. " #819, #821, #822"})
Q(1491, "Smart Drinks", "The Barrens", 18, "horde_ratchet",
    "Mebok Mizzyrix's raptor horn drinks had not worked. He now believed that wailing essence, gathered in the ectoplasmic creatures of the Wailing Caverns, would make them smart.",
    "Mebok Mizzyrix wanted wailing essence for his smart drinks. He thought it caused the strange plants and animals of the Barrens.",
    "Mebok had his wailing essence and was sure it would make his fortune. He promised more reward once he was rich.",
    "The essence reached Mebok, who could not wait to try it in his drink. Its effect remained to be seen.")
Q(843, "Gann's Reclamation", "The Barrens", 23, HV,
    "The dwarves of Bael Modan blasted holes in the land that had once fed Gann Stonespire's tribe. Talks had failed, and Gann wanted the dig driven out and Prospector Khazgorm's notebook brought to him.",
    "Gann Stonespire wandered the roads alone since the dwarves of Bael Modan drove his tribe from its ancestral home. He meant to take the land back by force.",
    "Khazgorm was dead, and Gann felt no remorse for him. He turned to studying the prospector's notebook.",
    "The prospector's death was a warning, Gann said, to all who threatened the tauren way of life. Khazgorm's notebook was his to read.")
Q(846, "Revenge of Gann", "The Barrens", 26, HV,
    "Khazgorm's notebook showed how much the dig depended on explosives. Gann wanted nitroglycerin, wood pulp and sodium nitrate from the keep's soldiers to make a charge of his own.",
    "A new foreman would soon take over at Bael Modan. Gann meant to give the dwarves a taste of their own medicine.",
    "Gann had the makings of his charge and promised the dwarves a surprise.",
    "The ingredients reached Gann, who praised the industry of whoever had brought them.", nil, true)
Q(849, "Revenge of Gann", "The Barrens", 26, HV,
    "Gann fashioned an explosive from Khazgorm's plans. The flying machine at Bael Modan served the dig and the war, and to him it insulted the memory of his tribe.",
    "Gann handed over an explosive stick meant for the dwarves' flying machine at Bael Modan.",
    "The flying machine at Bael Modan was destroyed. Gann hoped its destroyer would be revered in Thunder Bluff as a champion of his lost tribe.",
    "Gann had his revenge on Bael Modan's flying machine, and called it the work of a defender of sacred tauren lands.", nil, true)
Fallback("Revenge of Gann", HV,
    "Gann Stonespire wanted revenge on the dwarves of Bael Modan.",
    "The dig at Bael Modan had cost Gann's tribe its ancestral land.",
    "Gann's plans against Bael Modan moved forward.",
    "The dwarves of Bael Modan felt more of Gann's anger.", {V .. " #846, #849"})
Q(874, "Mahren Skyseer", "The Barrens", 27, "horde_hunts",
    "A true hunter, Jorn Skyseer said, could stalk prey down any path, even the sea. His sister Mahren hunted the great water beasts along the coast.",
    "Jorn Skyseer sent the hunter to his sister Mahren on the human-held Barrens coast.",
    "Mahren gave her respect to anyone who had earned her brother's, and offered to teach the ways of the water beasts.",
    "Mahren Skyseer welcomed her brother's student and asked if the hunter was ready to go farther down the hunter's path.")
Q(873, "Isha Awak", "The Barrens", 27, "horde_hunts",
    "Isha Awak, the Deep Doom, was lord of the coastal waters and had eaten many of the humans on the shore. Mahren Skyseer did not fear him. To her he was honorable prey.",
    "Mahren sent the hunter into the sea after Isha Awak. His spirit dwelt in his heart, she said, and to hear it beat was to know one's fate.",
    "Isha Awak's heart reached Mahren. His spirit, she said, now lurked in the hunter's eyes.",
    "The Deep Doom was dead, and Mahren declared the hunter one with Isha Awak.")
Q(92706, "WANTED: Bruuz", "The Barrens", 20, "horde_ratchet",
    "A giant shark the dockworkers called Bruuz was circling Ratchet's shipping dock, attacking sailors and small boats. Gazlowe offered a hefty reward for its fin.",
    "Gazlowe could not get a crew into the water while all of Ratchet cried shark. He posted a bounty on Bruuz.",
    "Gazlowe paid for Bruuz's fin and thought he might put it in a soup that night, to have the last laugh.",
    "With Bruuz dead, Gazlowe could get his crews back in the water.")
Q(95494, "Bruised Pride and Lion Hides", "The Barrens", 18, HN2,
    "Vrang had injured his leg and could not hunt, but he had obligations to keep. It stung his pride to ask a stranger for lion hides.",
    "Vrang traded raw lion hides to a local tanner for finished leather. With his leg hurt, he needed someone else to take the big lions.",
    "Vrang judged the hides good. He had never come up short on his arrangement with the tanner and did not mean to start now.",
    "The lion hides would keep Vrang's bargain with the tanner, injury or not.")
Q(95495, "The Hermit Tanner", "The Barrens", 18, HN2,
    "Vrang's hides were bound for a hermit tanner on the ridge behind his camp. Vrang could not manage the climb, and warned that the tanner's looks were no cause for alarm.",
    "A tanner who lived alone atop the ridge above the Dry Hills traded leather for Vrang's hides.",
    "The tanner accepted the hides and regretted that Vrang had not come himself. There was a matter he wanted to discuss with him.",
    "The hides reached the hermit tanner, who had something he wished to talk over with Vrang.")
Q(95507, "Vrang's Game", "The Barrens", 18, HN2,
    "Vrang's traps were strewn across the valley, and his injured leg kept him from checking them.",
    "Vrang wanted the small game from his traps brought back, and warned of other wildlife in the valley.",
    "Vrang was grateful for the game. Without it, he said, his wounded leg might have sent him to bed hungry.",
    "The trapped game reached Vrang, who would not go hungry after all.")
Q(95508, "Unwelcome Guests", "The Barrens", 18, HN2,
    "The hermit tanner had once served in the Kul Tiras navy. He had objected to the Lord Admiral's campaign in Durotar, above all the execution of civilians.",
    "Before the hermit could tell the rest of his past, a group of men came up the ridge.",
    "Everyone on the ridge survived the attack. The tanner said he had always known his past would catch up with him, and gave what reward he could.",
    "The men on the ridge were beaten off. The former Kul Tiras sailor said he was in debt for the help.")
for _, id in ipairs({3924, 843, 873, 95508}) do pack.questIDs[id].importance = 4 end
pack.questIDs[849].importance = 5
pack.questIDs[3921].highlight = {"Sputtervalve had boasted to Undermine about the samophlange, then broke it. Wenikee Boltbucket had no idea what it was, but heard the gears inside and wanted to fix it.", "The broken samophlange went to Wenikee Boltbucket near Mor'shan Rampart, who was delighted by a machine she could not name."}
pack.questIDs[3923].highlight = {"Wenikee's repairs left the samophlange worse, so it went to Rilli Greasygob in Orgrimmar. The former Venture Company man called its bearer very brave or very stupid.", "Rilli Greasygob of Nogg's Machine Shop recognized the samophlange at once, and wondered who had dared take it from the Venture Company."}
pack.questIDs[3924].highlight = {"Boss Copperplug had hoarded the samophlange manual at the Boulder Lode Mine. Recovered, it went to his old rival Rilli, who promised word if the machine ever worked.", "Rilli Greasygob finally had the samophlange manual his Venture Company rival had kept from him. Sputtervalve sent thanks of his own."}
pack.questIDs[821].highlight = {"Brewmaster Drohn brewed Chen Stormstout's stormstout again from Barrens ingredients. The batch made him nostalgic, and he said the memories warmed his stomach.", "With lion tusks, plainstrider kidneys and a thunder lizard horn, Drohn made stormstout for the first time in years."}
pack.questIDs[843].highlight = {"Prospector Khazgorm, whose dig at Bael Modan had driven Gann Stonespire's tribe from its land, was dead. Gann felt no remorse and turned to the prospector's notebook.", "Gann Stonespire's talks with the dwarves had failed. Khazgorm's death at Bael Modan was his warning to all who threatened the tauren way of life."}
pack.questIDs[849].highlight = {"Gann Stonespire's charge, made from Khazgorm's own plans, destroyed the dwarves' flying machine at Bael Modan. Gann hoped Thunder Bluff would honor a champion of his lost tribe.", "Bael Modan's flying machine, an insult to the memory of Gann's tribe, was blown apart. Gann called it the work of a defender of sacred tauren lands."}
pack.questIDs[873].highlight = {"Isha Awak, the Deep Doom who had eaten many on the coast, was killed in the sea. Mahren Skyseer said his spirit now lurked in the hunter's eyes.", "Mahren Skyseer sent the hunter after Isha Awak, honorable prey to her. When his heart was brought to her, she declared the hunter one with him."}
pack.questIDs[92706].highlight = {"Bruuz, the shark circling Ratchet's dock, was killed. Gazlowe paid the bounty and thought of putting its fin in a soup, just to have the last laugh.", "Gazlowe's crews could go back in the water once Bruuz's fin reached him."}
pack.questIDs[95508].highlight = {"The hermit tanner above the Dry Hills had left the Kul Tiras navy over the execution of civilians in Durotar. When armed men came up his ridge, he survived, and said he had always known his past would catch up with him.", "Men came up the ridge for the former Kul Tiras sailor. Everyone survived, and the hermit tanner gave what reward he could."}

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
    "Dalar Dawnweaver had more evidence for his inquiry into the worgen of Silverpine.", {V .. " #422, #423, #424, #99, #98298"})
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

-- Silverpine: the Sepulcher's supply flights, Johaan's research and Dalaran's
-- work at Ambermill (overnight 2026-11-05). Allister, Podrig and Ataeric are
-- named from LoreForever Z_silverpine; 95981 and 98299 are Forever additions.
local HM = "horde_ambermill"
pack.threads[HM] = "Dalaran's work at Ambermill"
Q(445, "Delivery to Silverpine Forest", "Silverpine Forest", 10, "horde_apothecary",
    "Apothecary Johaan believed a member of the Royal Apothecary Society had to share his knowledge. His findings were bound for Apothecary Renferrel at the Sepulcher in Silverpine Forest.",
    "Johaan's research from Brill had to reach Renferrel at the Sepulcher. Time, he said, was a luxury the Dark Lady's servants did not have.",
    "Renferrel was glad of Johaan's research, though so much was happening in Silverpine that he had nearly forgotten it. He urged the courier to stay and help.",
    "Johaan's findings reached the Sepulcher, where Renferrel rambled about Silverpine's many new developments before asking the courier to stay on.")
Q(3221, "Speak with Renferrel", "Silverpine Forest", 12, "horde_silverpine",
    "Apothecary Renferrel had sent a summons about the worg hearts brought to him earlier.",
    "While the Deathstalkers were being helped, Renferrel asked to talk again about the hearts he had received.",
    "Renferrel said a matter concerning the worg hearts demanded attention.",
    "The summons led back to Renferrel at the Sepulcher, who had more to say about the hearts.")
Q(6321, "Supplying the Sepulcher", "Silverpine Forest", 10, "horde_trade",
    "High Executor Hadrec did not want the Sepulcher's Deathguards short of gear with the Scourge in the woods. Deathguard Podrig found them well stocked except for weapons lost in the field.",
    "Deathguard Podrig had a requisition for weapons from Gordon Wendham in the Undercity. The first step was the Sepulcher's bat master, Karos Razok.",
    "Karos Razok saw that the order was official business and agreed it had to reach the Undercity quickly.",
    "The bat master read Podrig's order and urged speed. The Sepulcher could not be left short.")
Q(6323, "Ride to the Undercity", "Undercity", 10, "horde_trade",
    "Karos Razok's bats could carry a rider to the Undercity for a small fee. Gordon Wendham kept his weapons in the Trade Quarter, where the bats landed.",
    "The Sepulcher's weapons order was bound for Gordon Wendham in the Undercity's Trade Quarter.",
    "Gordon Wendham accepted the Sepulcher's order and called it an honor to serve those who served the Dark Lady.",
    "The order reached Gordon Wendham, who kept his weapons cleaned and ready.")
Q(6322, "Michael Garrett", "Undercity", 10, "horde_trade",
    "Gordon Wendham packed the Sepulcher's weapons into a crate. The Undercity's bat master, Michael Garrett, could send it to Silverpine.",
    "The crate of weapons from the Trade Quarter needed a bat to the Sepulcher.",
    "Michael Garrett said the crate could reach the Sepulcher easily, since his bats flew there daily.",
    "The Undercity's bat master took charge of the Sepulcher's crate. His bats made the flight every day.")
Q(6324, "Return to Podrig", "Silverpine Forest", 10, "horde_trade",
    "A bat from the Undercity could carry the crate of weapons back to Karos Razok at the Sepulcher.",
    "The weapons from the Undercity still had to reach Deathguard Podrig in Silverpine.",
    "Podrig received the weapons. The Deathguards would not be caught unprepared.",
    "The crate reached Podrig at the Sepulcher, and he called it a valuable service to the Dark Lady.")
Q(477, "Border Crossings", "Silverpine Forest", 14, HM,
    "Ambermill remained a center of human opposition, backed by the wizards of Dalaran. Shadow Priest Allister wanted to know why Dalaran cared about a backwater village.",
    "Dalaran had been shipping crates by wagon from Hillsbrad to a small camp north of Pyrewood Village. Shadow Priest Allister wanted one of them opened.",
    "The crate held yellowed maps of Silverpine and western Lordaeron, and beneath them a pendant that looked magical.",
    "Inside the Dalaran crate lay old maps of western Lordaeron and a mysterious pendant.")
Q(478, "Maps and Runes", "Silverpine Forest", 14, HM,
    "The pendant from the Dalaran crate was taken before the lid went back on. Shadow Priest Allister was waiting for anything useful.",
    "The maps and the strange pendant from the wizards' supplies were bound for Shadow Priest Allister at the Sepulcher.",
    "Allister found the maps and pendant interesting, but the wizards' aim was still hidden from him. Dalar, he thought, might know more.",
    "The pendant reached Allister, who could see Dalaran's interest in Ambermill but not its purpose. He looked to Dalar Dawnweaver for answers.")
Q(481, "Dalar's Analysis", "Silverpine Forest", 14, HM,
    "Shadow Priest Allister hoped Dalar Dawnweaver could make sense of the pendant from the Dalaran crate.",
    "The pendant went to Dalar Dawnweaver, the Forsaken mage at the Sepulcher, for study.",
    "Dalar recognized a Kirin Tor artifact used by powerful wizards to channel magic. So many sent to Ambermill meant a project of some size, and he set out to pierce their shields.",
    "Dalar called the pendant more Kirin Tor machinations, and meant to learn what the wizards intended.")
Q(482, "Dalaran's Intentions", "Silverpine Forest", 14, HM,
    "Dalar remembered that the Kirin Tor had marked Ambermill for its dormant ley energy node. The wizards meant to wake it and use its power.",
    "Waking Ambermill's ley node would take great power, and taking the pendants could stall it. Dalar sent the warning to Allister.",
    "Allister trusted Dalar's judgment and agreed they had to move quickly. Until a plan was ready, the wizards' progress had to be delayed.",
    "The warning reached Allister, who meant to plan an attack with Dalar and slow the wizards in the meantime.")
Q(479, "Ambermill Investigations", "Silverpine Forest", 16, HM,
    "Dalar was searching for the source of the wizards' spellcasting. Until he found it, Allister wanted the pendants taken from Ambermill's conjurers, mages and protectors.",
    "If the wizards' plans came to fruition, Allister feared, the Forsaken might lose their hold on Silverpine. The pendants were the first thing to take.",
    "Dalar found the weaving far along despite the lost pendants. A wizard of great power was guiding the energy, and Allister wanted him stopped.",
    "The pendants slowed Ambermill's wizards, but not enough. Allister learned from Dalar that a powerful wizard was guiding the work.")
Q(95981, "Watching the Roads", "Silverpine Forest", 20, HM,
    "Taking the pendants was only a first step. Allister wanted the Kirin Tor's wizards and watchers on the roads around Ambermill cut down, to stop the relics at their source.",
    "Dalaran's people had moved freely across the Forsaken borders for too long. Allister ordered the roads around Ambermill cleared of them.",
    "Fewer Kirin Tor wizards watched the roads. Allister noted they had kept a death grip on them since Dalaran's barrier went down, and did not care why.",
    "Fewer of Dalaran's watchers remained on the roads. Whatever made the Kirin Tor so wary, Allister judged it beside the point.")
Q(480, "The Weaver", "Silverpine Forest", 22, HM,
    "An archmage of great power was overseeing the reactivation of Ambermill's ley energy node. Allister saw no way to stop it but his death.",
    "Mages and warders protected the archmage at Ambermill's ley node. Allister wanted him killed quickly and his staff brought back.",
    "Archmage Ataeric's staff reached Allister. The wizards' magic dissipated, and the ley energies sank back into dormancy.",
    "The ley node at Ambermill fell dormant again. Allister counted it a major blow to Dalaran, but with such power so close, plans had to be made.")
Q(98299, "Stop the Spread", "Silverpine Forest", 20, HA,
    "At the Sepulcher, Arugal was blamed for the worgen in Silverpine, whether by his own doing or not. How the curse spread was still unknown, and human refugees had gathered by the Greymane Wall.",
    "The worgen curse seemed unable to touch the Forsaken, but living humans were another matter. The refugees at the Greymane Wall were to be put down before they could become Arugal's servants.",
    "The refugees were dead, and Gilneas had let none of them past its wall. At the Sepulcher, that was taken as a sign the curse would not reach the Gilnean city.",
    "The killing at the Greymane Wall was reported to the Sepulcher. Since the Gilneans let no one through, the curse seemed unlikely to spread into their kingdom.")
for _, id in ipairs({482, 479, 6324}) do pack.questIDs[id].importance = 4 end
pack.questIDs[480].importance = 5
pack.questIDs[477].highlight = {"Dalaran's wizards were shipping crates to a camp north of Pyrewood. Opened for Shadow Priest Allister, one held old maps of western Lordaeron and a mysterious pendant.", "Allister wanted to know why Dalaran cared about Ambermill. A crate from the wizards' camp held maps and a pendant that looked magical."}
pack.questIDs[482].highlight = {"Dalar Dawnweaver remembered that the Kirin Tor had marked Ambermill for its dormant ley energy node. Allister agreed they had to move quickly against the wizards.", "The pendant from Dalaran's crate pointed Dalar to Ambermill's sleeping ley node. His warning reached Allister, who meant to slow the wizards while they planned an attack."}
pack.questIDs[479].highlight = {"The pendants taken from Ambermill's wizards slowed them, but Dalar found the weaving far along. A powerful wizard was guiding it, and Allister wanted him stopped.", "Ambermill's conjurers and mages lost their pendants. Even so, Dalar warned Allister that the weaving was well advanced under a wizard of great power."}
pack.questIDs[480].highlight = {"Archmage Ataeric was killed at Ambermill and his staff brought to Shadow Priest Allister. The ley node the Kirin Tor had been waking fell dormant again.", "With the archmage dead, Dalaran's magic at Ambermill dissipated. Allister called it a major blow to the wizards, though such power so close still worried him."}
pack.questIDs[6324].highlight = {"Deathguard Podrig's weapons order went to the Undercity by bat and came back as a crate from Gordon Wendham. The Sepulcher's Deathguards would not be caught unprepared.", "The weapons from the Undercity reached Deathguard Podrig at the Sepulcher. He called the errand a valuable service to the Dark Lady."}
pack.questIDs[98299].highlight = {"Human refugees had gathered at the Greymane Wall, where the Forsaken feared Arugal's curse would take them. They were put down, and Gilneas kept its gate shut.", "To keep Arugal's curse from spreading, the refugees at the Greymane Wall were killed. The Gilneans let no one through their wall."}

-- Quests recorded in Alberich's and Dahlia's beta journals that still had no
-- scene (Migration/ancestor-journals-20261105), plus Forever's Camping 101
-- family. Camping titles repeat across professions, races and zones, so they
-- stay title contexts with no zone or thread; each names only its own fixture.
Q(91921, "Return to Quinn (Again)", "Silverpine Forest", 11, HS,
    "Renferrel had a new potion for Quinn's recovery, made, he said, with love extracted from six whole hearts. He wanted it delivered before more paperwork could be required.",
    "Quinn Yorick was still waiting at the farm for a remedy. Apothecary Renferrel sent a new potion and asked to be excused from the visitor's company.",
    "Quinn drank the new potion and felt it working. He had begun to come to terms with turning into a ghoul, and now expected to travel soon.",
    "The potion reached Quinn, who thanked the courier for a great favor and expected to be on his feet before long.")
Q(5761, "Slaying the Beast", "Orgrimmar", 16, "horde_blade",
    "The Searing Blade made its home in Ragefire Chasm, secretly working to subvert members of the Horde. Its leader was a felguard, Taragaman the Hungerer.",
    "Rooting out the demonic influence in the Warchief's city meant killing Taragaman the Hungerer, who led the Searing Blade in Ragefire Chasm.",
    "Taragaman's heart was handed over with the promise that Thrall would hear of the victory.",
    "Taragaman's heart was taken to be dealt with properly, and Thrall was to hear of the victory.")
pack.questIDs[5761].importance = 5
pack.questIDs[91921].highlight = {"Renferrel's second potion, made with love extracted from six whole hearts, reached Quinn Yorick. Quinn had been coming to terms with turning into a ghoul, and now expected to travel soon.", "Quinn Yorick drank Renferrel's new potion at the farm and felt it working."}
pack.questIDs[5761].highlight = {"Taragaman the Hungerer, the felguard who led the Searing Blade in Ragefire Chasm, was slain. His heart was handed over, and Thrall was to hear of it.", "The Searing Blade lost its felguard master, Taragaman the Hungerer, deep in Ragefire Chasm."}
local camping = {
    {"Cooking", "Every camp began with a cook and a campfire, the camping teacher said.", "Cooking was the foundation of a camp, more than a way to make tasty food.", "A campfire could now be built anywhere in the wilds, the first piece of any camp.", "The basics of a campfire were learned. Bigger fires would come with more cooking skill.", "#96626, #96629"},
    {"First Aid", "Injuries were a fact of adventuring, and a First Aid Kit at camp could save lives.", "A camping teacher knew someone who could show a first aider how to make a First Aid Kit for camp.", "A First Aid Kit could now be made for camp, to be set out in the wilds away from town.", "The First Aid Kit joined what could be built at camp, once a campfire was lit.", "#96047, #97903"},
    {"Alchemy", "An alchemist could learn to build a Mana Well, a refreshment for the healers and spellcasters around a camp.", "A camping teacher offered to show an alchemist how to craft a Mana Well for camp.", "A Mana Well could now be crafted, to be tried out at a camp in the wilds.", "The Mana Well could stand beside a campfire in the wilds, since no camp was complete without one.", "#96045, #97899"},
    {"Mining", "A miner could learn to build a Lodestone, which gave fighters gathered at a camp extra strength.", "Mining was honest work, the camping teacher said, and it could furnish a camp with a Lodestone.", "A Lodestone could now be crafted, to be tried out at a camp in the wilds.", "The Lodestone was ready for the next camp, though the teacher reminded that a fire had to come first.", "#96046, #97907"},
    {"Fishing", "A fisher could learn to build a Fish Bowl, a bit of joy for adventurers at camp.", "Fishing could serve a camp too, the camping teacher said, by way of a Fish Bowl.", "A Fish Bowl could now be crafted, to be tried out at a camp in the wilds.", "The Fish Bowl joined what could be built at camp, once a campfire was lit.", "#96050, #97904"},
    {"Tailoring", "A tailor could learn to make a banner for camp, to keep morale high.", "Inspiration and morale mattered on any battlefield, the camping teacher said, and a tailor could sew a rallying banner.", "A rallying banner could now be made, to be raised at a camp in the wilds.", "The banner could stand beside a campfire in the wilds, since no camp was complete without one.", "#96057, #97925"},
    {"Enchanting", "An enchanter could learn to make an Enchanted Lute, for entertainment between hard days.", "A camping teacher offered to show an enchanter how to craft an Enchanted Lute for camp.", "An Enchanted Lute could now be crafted, to be played at a camp in the wilds.", "The Enchanted Lute was ready for the next camp, though the teacher reminded that a fire had to come first.", "#96059, #97901"},
    {"Blacksmithing", "A blacksmith could learn to build a Sharpening Wheel, where warriors and rogues at camp could hone their weapons.", "A camping teacher knew someone who could show a blacksmith how to craft a Sharpening Wheel.", "A Sharpening Wheel could now be crafted, to be set up at a camp in the wilds.", "The Sharpening Wheel joined what could be built at camp, once a campfire was lit.", "#96044, #97900"},
    {"Leatherworking", "A leatherworker could learn to make a tent, cool on hot days and dry on rainy ones.", "Good rest kept a traveler sharp, the camping teacher said, and a leatherworker could make a tent.", "A camp tent could now be made, to be pitched in the wilds away from town.", "The tent could stand beside a campfire in the wilds, since no camp was complete without one.", "#96031, #97906"},
    {"Engineering", "An engineer could learn to build a Reagent Bot, keeping a camp supplied with the materials spells needed.", "A camping teacher knew someone who could show an engineer how to build a Reagent Bot for camp.", "A Reagent Bot could now be built, to be tried out at a camp in the wilds.", "The Reagent Bot was ready for the next camp, though the teacher reminded that a fire had to come first.", "#96058, #97902"},
    {"Herbalism", "An herbalist could learn to make an Incense Candle, to keep healers and spellcasters at camp in high spirits.", "Picking flowers could be useful and profitable, the camping teacher said, and could furnish a camp with an Incense Candle.", "An Incense Candle could now be made, to be lit at a camp in the wilds.", "The Incense Candle joined what could be built at camp, once a campfire was lit.", "#96055, #97957"},
    {"Skinning", "A skinner could learn to make a Camp Chair from gathered hides, a place to rest between fights.", "A bit of relaxation kept an adventurer at peak condition, the camping teacher said, and hides could make a Camp Chair.", "A Camp Chair could now be made, to be set out at a camp in the wilds.", "The Camp Chair could stand beside a campfire in the wilds, since no camp was complete without one.", "#96056, #97960"},
}
for _, r in ipairs(camping) do
    local title = "Camping 101: " .. r[1]
    Fallback(title, false, r[2], r[3], r[4], r[5], {V .. " " .. r[6]})
    pack.quests[title].thread, pack.quests[title].threadLabel = false, false
end

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

-- Compact scenes for Mulgore's turning points (overnight 2026-11-05, same sources).
pack.questIDs[757].highlight = {"Bristlebacks from Brambleblade Ravine had ambushed Narache's hunters and stolen from the village. Their belts reached Chief Hawkwind, and the Rite of Strength was passed.", "The first of the Earthmother's rites was won against the Bristleback raiders. Chief Hawkwind said the tribe would be proud."}
pack.questIDs[772].highlight = {"Zarlman's Water of the Seers brought a vision by the tribal fire. Followed to its end, it completed the Rite of Vision.", "Beside the tribal fire, the Water of the Seers raised a vision to follow. At its end the Rite of Vision was passed."}
pack.questIDs[760].highlight = {"The last of Mulgore's poisoned wells, Wildmane, ran clean again. Bloodhoof Village was grateful, and Mull Thunderhorn wished the waters of Mulgore would stay clean forever.", "Mull Thunderhorn's third totem cleansed the Wildmane well north of Thunder Bluff. The goblins' poison was gone from all three wells."}
pack.questIDs[766].highlight = {"Mazzranache, the strider of Maur Raincaller's grandfather's tales, had bitten Maur and left him feverish. The remedy's ingredients arrived in time, and Maur said he owed his life.", "Maur Raincaller had met the strider his grandfather fought, and nearly died of its bite. With a wolf heart, a cougar femur, a scale and a gizzard, he could make his cure."}
pack.questIDs[745].highlight = {"Palemane gnolls had been slaughtering Mulgore's wildlife and scorned every attempt at talk. When they were checked, Baine Bloodhoof spoke of death and life as a circle.", "Baine Bloodhoof sent the young against the Palemane gnolls so they would see how much harm a small threat could do to the land."}
pack.questIDs[744].highlight = {"Eyahn Eagletalon was making a headdress for his brother's ceremony before Cairne Bloodhoof. The harpy feathers he lacked completed the design.", "Twelve harpy feathers finished the headdress Eyahn Eagletalon was making for his brother's ceremony before Cairne."}

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
pack.quests["Burning Shadows"].after = {"The pendant from Skull Rock was handed over to be examined.", "The cultists' pendant went to Orgrimmar for study."}
pack.quests["Burning Shadows"].source = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #832"}

-- Complete short scenes: exact recorded stages only; see editorial-20261016 author packet.
pack.questIDs[1061].highlight = {"The shaman Seereth Stonebreak welcomed help at her camp: goblin logging had left Stonetalon's spirits crying out.", "Stonetalon's wounded spirits had brought Seereth Stonebreak into the mountains. At her camp, the shaman welcomed help against the goblin loggers."}
pack.questIDs[1062].highlight = {"The strike against the Venture Company's workers earned Seereth's praise. Calming the spirits, she thought, might take the wisdom of the tauren elders.", "Seereth welcomed the losses inflicted on the Venture Company, but looked to the tauren elders for a way to calm Stonetalon's suffering spirits."}

A.Lore.RegisterStoryPack("horde-and-zephras", pack)
