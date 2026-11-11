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
-- Starters3 (2026-11-05, tests/Starters3.lua): 15 more classic stages in Horde
-- regions (Mankrik, Feegly, Kadrak, Menara, Falla, Veren, Nefarian's head) and
-- 22 first-batch outcomes rewritten around their people (Rhinag, Tonga, Gazlowe,
-- Fenris Isle, Deliah) with facts unchanged.
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
    "At the well, the Greatmother was surprised that anyone had come so far to help an old woman, and called her visitor a keeper.",
    "At the well, Greatmother Hawkwind welcomed the visitor her son had sent and called the visitor a keeper.", nil, true)
Q(753, "A Humble Task", "Mulgore", 3, "horde_narache",
    "Greatmother Hawkwind's old legs had lost their vigor. She gave her water pitcher to younger hands for the walk back to her son in Camp Narache.",
    "Even the humblest task could earn the recognition of elders, Greatmother Hawkwind said, and handed over the pitcher for the chief.",
    "Chief Hawkwind received the pitcher his mother had sent, and said such willingness to help would make the tribe proud in Thunder Bluff.",
    "The water from the well reached the chief at the Greatmother's bidding, and he praised the help given to the people of Narache.", nil, true)
Fallback("A Humble Task", "horde_narache",
    "Fetching water was part of the shared work that sustained Narache.",
    "The Hawkwind household depended on the same everyday work as the rest of the village.",
    "The Hawkwinds' errand at the well southeast of Narache was done.",
    "An errand for the Hawkwinds at the well was quieter work than hunting.", {V .. " #752, #753"})
Q(780, "The Battleboars", "Mulgore", 4, "horde_narache",
    "The Bristleback quilboar trained battleboars to be vicious, and the beasts were pushing into the tribe's hunting grounds from Brambleblade Ravine. Narache wanted their snouts and flanks for stew.",
    "Battleboars from Brambleblade Ravine were encroaching on Narache's hunting grounds. Their meat could feed the village's young.",
    "The snouts and flanks would make a fine stew for Narache's young, and the dead boars were meant as a lesson to the Bristlebacks.",
    "Some of the battleboars fell, and their meat went into stew for the village's young.")
Q(755, "Rites of the Earthmother", "Mulgore", 3, "horde_rites",
    "Chief Hawkwind saw greatness ahead for a young tauren willing to do humble work. First came the three Rites of the Earthmother, beginning with Seer Graytongue in the hills south of Camp Narache.",
    "The Rites of the Earthmother were three, and the Rite of Strength came first. Chief Hawkwind sent the young to Seer Graytongue.",
    "Seer Graytongue heard that Chief Hawkwind had sent the newcomer, and warned that the rites were no small task.",
    "Seer Graytongue heard Chief Hawkwind's name and said that embarking on the Rites of the Earthmother was no small task.", nil, true)
Q(757, "Rite of Strength", "Mulgore", 4, "horde_rites",
    "Bristlebacks from Brambleblade Ravine ambushed hunting parties and stole from Narache.",
    "The first of the Earthmother's rites called for proof against the tribe's raiders.",
    "The Bristleback belts reached Chief Hawkwind, and the first of the Earthmother's rites was passed. The tribe, he said, would be proud.",
    "Chief Hawkwind took the Bristleback belts as proof of valor against the raiders of his tribe.")
Q(763, "Rites of the Earthmother", "Mulgore", 5, "horde_rites",
    "Two more tests remained in the Rites of the Earthmother, and they lay beyond Narache. Chief Hawkwind sent a carved totem to Baine Bloodhoof, son of Cairne, at {p:Bloodhoof Village}.",
    "Chief Hawkwind carved a totem for Baine Bloodhoof, chief of Bloodhoof Village, so the rites could go on there. Hawkwind wanted it carried there with haste.",
    "Baine Bloodhoof knew his good friend Hawkwind's carvings at once, and said they marked their bearer as a special breed.",
    "At Bloodhoof Village, Baine read Hawkwind's totem as word from a good friend. The last two rites would begin here.", nil, true)
Fallback("Rites of the Earthmother", "horde_rites",
    "The rites linked Narache's teaching with the elders of Thunder Bluff.",
    "Strength, vision and wisdom each had a place in the tauren rites.",
    "The path of the rites led a little closer to the elders of Thunder Bluff.",
    "The Rites of the Earthmother moved on toward the elders' recognition.", {V .. " #755, #763, #776"})
Q(767, "Rite of Vision", "Mulgore", 6, "horde_rites",
    "The land was the tauren's most holy provider. For the Rite of Vision, the young were sent to Zarlman Two-Moons, spiritual leader of Bloodhoof Village.",
    "The second of the Earthmother's rites, the Rite of Vision, began with Zarlman Two-Moons in Bloodhoof Village.",
    "Zarlman Two-Moons said he had sensed the newcomer coming, and could always recognize one attempting the rites.",
    "Zarlman Two-Moons had sensed the visit before it came. He could always tell, he said, who was trying to pass the rites.", nil, true)
Q(771, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "For the Rite of Vision, Zarlman Two-Moons needed well stones from around Mulgore's wells and ambercorn fallen beneath its great trees, the makings of the Water of the Seers.",
    "Zarlman's Water of the Seers needed well stones and ambercorn, and the vision it brought before the tribal fire would have to be followed.",
    "Zarlman saw that the young tauren had learned to gather from the sacred land. He needed only a moment to brew the Water of the Seers.",
    "Well stones and ambercorn were enough. Zarlman set about brewing the Water of the Seers.", nil, true)
Q(772, "Rite of Vision", "Mulgore", 7, "horde_rites",
    "Zarlman Two-Moons handed over the Water of the Seers. Drunk near the tribal fire, it would bring a vision after a few moments, and the vision was to be followed to its end.",
    "The holy water from Zarlman was to be drunk at the tribal fire in Bloodhoof Village. Whatever appeared there had to be followed.",
    "The vision rose by the fire and was followed to its end. There the Rite of Vision was declared passed, with a word not to be afraid.",
    "The Water of the Seers brought a vision by the tribal fire, and following it completed the Rite of Vision.", nil, true)
Fallback("Rite of Vision", "horde_rites",
    "Zarlman Two-Moons tended the teaching and preparations of the Rite of Vision.",
    "The Water of the Seers had a place in Mulgore's rites.",
    "The work belonged to the Rite of Vision.",
    "The Rite of Vision moved forward under Zarlman Two-Moons.", {V .. " #767, #771, #772"})
Q(773, "Rite of Wisdom", "Mulgore", 10, "horde_rites",
    "The Rite of Wisdom was the last of the three. East of Thunder Bluff, at Red Rocks, the ancestral spirits gave their blessing only to those who had drunk the Water of the Seers.",
    "One rite remained before the elders of Thunder Bluff would accept a young tauren. The ancestral spirit at Red Rocks, east of the city, held the blessing.",
    "At Red Rocks, the ancestral spirit spoke for the tauren who had died founding and protecting Thunder Bluff, and handed that duty on. With the Rite of Wisdom passed, the spirit bade the young tauren enter the city with pride.",
    "The spirits of Red Rocks gave their blessing and the duty of protecting Thunder Bluff with it. The last of the three rites was done.")
Q(775, "Journey into Thunder Bluff", "Thunder Bluff", 10, "horde_rites",
    "A tauren who finished the Rites of the Earthmother was owed honor in Thunder Bluff. The last errand was to Cairne Bloodhoof himself, atop the highest mesa.",
    "The rites ended at the door of Cairne Bloodhoof, on the highest mesa of Thunder Bluff.",
    "Cairne Bloodhoof greeted the young tauren who had found the way to his doorstep.",
    "The journey into the city ended with Cairne Bloodhoof's greeting.")
Q(776, "Rites of the Earthmother", "Thunder Bluff", 14, "horde_rites",
    "Cairne asked for the horn of Arra'chea as proof of hunting skill.",
    "The great kodo on Mulgore's plains offered a further test after the rites.",
    "Arra'chea's horn reached Cairne, who arranged to collect the hide and meat.",
    "The kodo hunt supplied proof for Cairne and provisions for the people.", nil, true)
Q(748, "Poison Water", "Mulgore", 5, "horde_wells",
    "Goblins and their servants had tainted Mulgore's sacred wells. Mull Thunderhorn meant to make a cleansing totem for each, starting with the Winterhoof Water Well.",
    "For the Winterhoof totem, the land had to offer its aid. Mull Thunderhorn wanted prairie wolf paws and adult plainstrider talons.",
    "Mull Thunderhorn took the paws and talons to bind their power into a totem. The Winterhoof well itself was still poisoned.",
    "Mull Thunderhorn had his wolf paws and plainstrider talons, and would bind their power into the first totem of cleansing.")
Q(754, "Winterhoof Cleansing", "Mulgore", 6, "horde_wells",
    "Mull Thunderhorn had crafted the first totem. Goblins guarded the Winterhoof Water Well to the southeast, where the cleansing ritual had to be performed.",
    "The Winterhoof well had been poisoned by the goblins, and the cleansing totem was ready to carry there.",
    "News of the cleansing came to Mull Thunderhorn within moments, he said, and the beasts near the Winterhoof well were already drinking from it.",
    "The Winterhoof well ran clean. Mull Thunderhorn called it a great thing for the land and for the tauren.")
Q(756, "Thunderhorn Totem", "Mulgore", 7, "horde_wells",
    "The Thunderhorn Water Well grew more tainted by the hour. Mull Thunderhorn needed the claws of the plains' predators, prairie stalkers and flatland cougars, for its totem.",
    "Mull Thunderhorn's next totem was for the Thunderhorn well. He wanted stalker claws and cougar claws from the plains east and west of the village.",
    "Mull Thunderhorn had his claws. The goblins, he said, would never learn the difference between fighting the land and living in harmony with it.",
    "The purity with which those beasts hunted was vital to the totem, Mull said, and he had their claws now. The Thunderhorn well still waited.")
Q(758, "Thunderhorn Cleansing", "Mulgore", 8, "horde_wells",
    "Mull Thunderhorn's second totem was ready. The Thunderhorn Water Well lay north of the village, and the cleansing ritual was to be performed there.",
    "With the Thunderhorn totem made, Mull sent it north to the well and wished its bearer the spirits' guidance.",
    "The Thunderhorn well was cleansed. Ancestors of the Thunderhorn clan praised the work in Mull's dreams, he said, and left a gift for it.",
    "The ritual at the Thunderhorn well took the taint from its water. In a dream, Mull Thunderhorn heard the clan's ancestors praise the deed, and he passed on their gift.")
Q(759, "Wildmane Totem", "Mulgore", 10, "horde_wells",
    "Only the Wildmane Water Well remained. Its totem needed the teeth of prairie wolf alphas, which wandered near the base of Thunder Bluff.",
    "Mull Thunderhorn's last cleansing totem called for the teeth of a fierce predator, the prairie wolf alpha.",
    "Mull Thunderhorn felt the land's sacrifice in the alphas' teeth, and said his spirit swelled with sadness and pride.",
    "Mull Thunderhorn took the alphas' teeth for the last totem. He could feel the land's sacrifice in them, he said, with sadness and with pride.")
Q(760, "Wildmane Cleansing", "Mulgore", 10, "horde_wells",
    "Mull Thunderhorn had made the Wildmane totem. Its well, north of Thunder Bluff, was the only one still fetid.",
    "One well was left. Mull Thunderhorn sent the Wildmane totem north of Thunder Bluff to heal the land of the goblins' poison.",
    "Clean water flowed at Wildmane again. Bloodhoof Village was grateful, and Mull Thunderhorn wished that Mulgore's waters would stay clean forever.",
    "The last of the poisoned wells was cleansed. The spirits, Mull Thunderhorn said, already spoke of the work at Winterhoof and Thunderhorn.")
Q(749, "The Ravaged Caravan", "Mulgore", 8, "horde_venture",
    "The Outrunners had burned a Venture Company caravan on the north shore of Stonebull Lake and left its crates to the fire. Now salvagers were back among the wagons, and Morin Cloudstalker wanted to know what the crates held.",
    "Venture Company salvagers were picking over the caravan the Outrunners had burned at Stonebull Lake. Morin Cloudstalker wanted its crates examined.",
    "Every side of the crate was stamped with the mark of the Venture Company Mining Division, and its contents were bound for one of the company's processing plants.",
    "The crate by the burned wagons belonged to the Venture Company Mining Division, its cargo due at a central plant.", nil, true)
Q(751, "The Ravaged Caravan", "Mulgore", 8, "horde_venture",
    "Under the crate's lid lay ore and minerals, packed tight, with a bound sheaf of papers on top. In the foothills to the east, smoke rose from a large fire.",
    "The crate held ore from the Venture Company's digging in Mulgore and a sheaf of papers. If the goblins meant to exploit the land, Morin said, the Outrunners would put an end to it.",
    "The papers from the crate convinced Morin that the Venture Company was robbing Mulgore of its resources. It was good to know for certain, he said, and now something had to be done.",
    "Morin Cloudstalker read the caravan's papers as proof of the goblins' theft, and said the tauren would have to act.", nil, true)
Fallback("The Ravaged Caravan", "horde_venture",
    "The Venture Company's burned caravan still held clues beside Stonebull Lake.",
    "Salvagers lingered around the mining company's abandoned cargo.",
    "The caravan investigation added evidence about the mining operation.",
    "The ruined wagons had yielded something of the company's business.", {V .. " #749, #751"})
Q(764, "The Venture Co.", "Mulgore", 10, "horde_venture",
    "The Venture Company had been refused mining rights in Mulgore and was digging anyway. Morin Cloudstalker wanted a message sent to its mine northeast of the ravaged caravan.",
    "Show a goblin something, the saying went, and the scales could be heard in the background. Morin Cloudstalker meant to show the Venture Company that Mulgore was not for sale.",
    "Morin Cloudstalker doubted the Venture Company could misread the message. The tauren would not let them steal the land's resources without protest.",
    "Morin was satisfied with the signal sent to the mine. The Venture Co., he said, would know not to take the tauren lightly.")
Q(765, "Supervisor Fizsprocket", "Mulgore", 12, "horde_venture",
    "The caravan's papers showed Venture Company plans to drive the tauren from Mulgore and plunder it freely. Morin Cloudstalker wanted the mastermind, Supervisor Fizsprocket, dead and his clipboard brought back.",
    "The depths the Venture Company would sink to appalled Morin Cloudstalker. Supervisor Fizsprocket ran its mine east of the ravaged caravan, and Morin wanted his clipboard.",
    "Fizsprocket was dead, and Morin's anger eased a little at the news. He would go through the clipboard for the company's next plans.",
    "Morin took Fizsprocket's clipboard to read what the Venture Company meant to do next in Mulgore. The villain's death, he said, had lessened his anger somewhat.")
Q(744, "Preparation for Ceremony", "Mulgore", 11, "horde_narache",
    "Eyahn Eagletalon's brother would soon stand before Cairne Bloodhoof, and Eyahn was making his headdress. Six azure and six bronze harpy feathers were still missing.",
    "While Eyahn Eagletalon tanned the leather straps, there was no time to gather feathers for his brother's ceremonial headdress.",
    "The feathers completed Eyahn's design. Giving the headdress and witnessing the ceremony were all that remained of his part.",
    "Eyahn Eagletalon had his feathers, and his gift for his brother's ceremony before Cairne was nearly done.")
Q(743, "Dangers of the Windfury", "Mulgore", 8, "horde_narache",
    "Windfury harpies nested along Mulgore's southeastern mountain edges, away from the road. Ruul Eagletalon, warrior and teacher, offered them as a test of strength.",
    "Ruul Eagletalon judged that a young tauren had to prepare before adventuring beyond Mulgore. The Windfury harpies would be a good gauge of skill.",
    "Ruul judged the harpy fight well done and the fighter ready to travel onward, and wished the wind always at their back.",
    "The Windfury harpies tested a young tauren's skill, and Ruul Eagletalon sent the hunter on with a blessing of the wind.")
Q(745, "Sharing the Land", "Mulgore", 8, "horde_mulgoreland",
    "Palemane gnolls had settled south of Bloodhoof Village and slew Mulgore's wildlife without restraint. Baine Bloodhoof said words were no longer the answer.",
    "The gnolls south of Bloodhoof had scorned every attempt to speak with them. Baine Bloodhoof wanted the young to see how much harm even a small threat could do.",
    "Baine was glad the task had been taken seriously. Death and life were a circle, he said, and respect for the land must never be forgotten.",
    "The Palemane gnolls were fought south of Bloodhoof, and Baine Bloodhoof asked that the lesson of the land never be forgotten.")
Q(746, "Dwarven Digging", "Mulgore", 8, "horde_mulgoreland",
    "Dwarves were preparing a dig northwest of Bloodhoof Village, and Baine Bloodhoof feared it would enrage Mulgore's kodos. He wanted their tools taken and smashed at a forge.",
    "The dwarves believed secrets lay in the earth, and Baine Bloodhoof agreed, but hollowing the land was no way to earn its teachings.",
    "The dwarves' broken tools reached Baine, who said it would calm the beasts of Mulgore and perhaps teach the diggers a lesson.",
    "Smashed at a forge, the dwarves' tools went back to Baine as proof. He hoped the dig would trouble the kodos no longer.")
Q(761, "Swoop Hunting", "Mulgore", 6, "horde_narache",
    "Swoops ranged all over Mulgore and were hard to find and harder to catch. Harken Windtotem called a collection of their quills a badge of cleverness and determination.",
    "A hunter needed sharp eyes and quick hooves for the swoop. Harken Windtotem asked for their quills.",
    "Harken Windtotem knew the quills had not been easy to gather, and said it was good to have such a hunter at Bloodhoof Village.",
    "Harken Windtotem took the swoop quills and called their gatherer a hunter of merit, good to have at Bloodhoof Village.")
Q(766, "Mazzranache", "Mulgore", 8, "horde_narache",
    "Maur Raincaller's grandfather had told stories of a strider named Mazzranache, with red eyes and a venomous bite. Maur met it on the plains, and the bite became infected.",
    "To clean the infection from Mazzranache's bite, Maur Raincaller needed a wolf heart, a cougar femur, a plainstrider scale and a swoop gizzard. Time was short.",
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
    "Rhinag had hunted venomtails without carrying the antidote, and one had stung him. Kor'ghan in the Cleft of Shadow would not scold him now. He needed venomtail poison sacs to make the cure.",
    "The venomtails near the gate of Orgrimmar carried the poison sacs Kor'ghan needed. One of his own was dying of their sting.",
    "Kor'ghan handed over the antidote for Rhinag, with a warning to be careful on the way.",
    "The poison sacs became an antidote in Kor'ghan's hands. Rhinag still had to receive it.")
Q(812, "Need for a Cure", "Durotar", 9, "horde_darkspear",
    "A venomtail had stung Rhinag deeply, and he reckoned he had an hour to live. Kor'ghan, in the Cleft of Shadow in Orgrimmar, knew the antidote.",
    "Weakened by a scorpid's sting, Rhinag could not return to Sen'jin, where he expected to be mocked. He needed Kor'ghan's antidote before the poison finished him.",
    "The antidote reached Rhinag in time. He gave away something he would not need soon. Kor'ghan meant to march him through more rituals until he proved himself.",
    "Rhinag lived. He expected more boar hunts and scorpid tails from Kor'ghan before he had proved himself.")
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
    "Korran had been sent to the Crossroads to watch the land for his masters in Orgrimmar. The insect-like creatures of the Field of Giants were his study. They seemed cleverer than any normal animal. He lent a digging claw for taking eggs from their mounds.",
    "Little was known of the insect creatures in the Field of Giants except that they had intelligence and attacked when alerted. Korran wanted their eggs whole, dug from the mounds with his own claw.",
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
    "Zygand read the names of the Scarlet officers in Tirisfal and spoke of the blow to the zealots' morale if their leaders died in one swift strike.",
    "In Brill, Executor Zygand had the names of the Crusade's officers in Tirisfal. Killing them all at once, he said, would shake the zealots.")
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
    {367, 6, "Sylvanas had challenged the Royal Apothecary Society to brew a plague that would ruin Arthas's Scourge. Apothecary Johaan in Brill believed the blood of beasts might be the key.", "Apothecary Johaan was testing a theory for the Dark Lady's new plague. His first experiment called for five vials of darkhound blood.", "Johaan had his darkhound blood and could begin testing his theory.", "Five vials of darkhound blood went to Johaan in Brill, and he gave his thanks for the effort."},
    {368, 9, "Poisoning one victim was child's play, Johaan said, but a plague meant to spread across a world needed more. Scales from the Vile Fin murlocs were next.", "For his disease to spread properly, Johaan wanted scales from the Vile Fin murlocs along Tirisfal's coast.", "Johaan declared the Vile Fin scales exactly what his concoction needed.", "The murloc scales went into Johaan's mixture, and he judged them perfect for it."},
    {369, 11, "One of Johaan's old tomes told of an ancient plague whose deadly agent had survived in the venom of Night Web spiders. He wanted that venom for his own concoction.", "The last ingredient of Johaan's experiment was venom from a Vicious Night Web Spider in eastern Tirisfal.", "With the venom added and the mixture boiled down, Johaan was ready to try his new agent.", "Johaan had every ingredient at last, and the test of his deadly agent was still to come."},
}
for _, r in ipairs(plague) do Q(r[1], "A New Plague", "Tirisfal Glades", r[2], "horde_apothecary", r[3], r[4], r[5], r[6], nil, true) end
Fallback("A New Plague", "horde_apothecary",
    "The Royal Apothecary Society was experimenting with a new disease.",
    "Brill's apothecary collected reagents for a proposed weapon against the Scourge.",
    "Another reagent went onto Johaan's workbench in Brill for the Dark Lady's plague.",
    "Johaan's concoction was a step nearer, though what it would finally do was still untested.", {V .. " #367, #368, #369, #492"})

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
    "The Scarlet camp southeast of Deathknell was struck. Arren joked about sitting the zealots down for reasonable discourse, then called them Light-blinded fools.",
    "Arren was satisfied with the strike on the Scarlet camp. In his view, the zealots had sent themselves to their own graves.")
Q(8, "A Rogue's Deal", "Tirisfal Glades", 5, "horde_forsaken",
    "Calvin Montague in Deathknell had a letter for Renee, the innkeeper at Brill. He promised good pay for the delivery and said little about what was in it.",
    "Calvin Montague wanted a letter carried to Brill's innkeeper. He described her inn as a cozy place full of plague victims trying to make their way.",
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
    "Dillinger paid for the putrid claws. His one regret was missing the sight of the Scourge smashed to pulp.",
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
    "Sevren heard Linnea's word with unease. The Lich King's assaults were ceaseless, he said, and the Forsaken would not give in.")
Q(356, "Rear Guard Patrol", "Tirisfal Glades", 11, "horde_forsaken",
    "The Bulwark's defenders could hold only one front, and Scourge slipping behind them threatened their supply line. Deathguard Linnea sent a patrol east toward Balnir Farmstead.",
    "Balnir Farmstead had become a haven for Scourge that slipped past the Bulwark. Linnea wanted any Scourge to the east slain, the farm most of all.",
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
    "Ten Scarlet insignia rings went to the Deathguard in Brill. Varimathras would be proud, he said.",
    "The rings proved ten crusaders dead. In Brill, that counted as service to Varimathras and the Dark Lady.")
Q(365, "Fields of Grief", "Tirisfal Glades", 7, "horde_apothecary",
    "Deathguard Simmer wanted ten pumpkins stolen from a human farm patrolled by the Scarlet Crusade. They were reagents for Apothecary Johaan in Brill.",
    "A farm under the eye of a Scarlet tower still grew pumpkins. Simmer called the theft a lesson for the humans and sent the harvest to Apothecary Johaan.",
    "Johaan received the ten pumpkins and called the new Forsaken an asset to the Dark Lady's army.",
    "Ten pumpkins from the farm by the Scarlet tower went to Apothecary Johaan in Brill. Their thief, he said, was proving an asset to the Dark Lady's army.", nil, true)
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
pack.questIDs[6395].highlight = {"Samuel Fipps, who had killed his wife Marla when he was one of the Scourge, was destroyed and buried in her grave. Novice Elreth hoped the two would find peace together.", "Marla Fipps had asked to be buried with the husband who killed her. Samuel's remains were laid in her grave at Deathknell, and Elreth called it a good deed."}
pack.questIDs[381].highlight = {"Executor Arren ordered a strike on the Scarlet camp southeast of Deathknell before its zealots could strike first. He called the dead crusaders Light-blinded fools.", "The Scarlet Crusade had camped close to Deathknell, hunting every undead it could find. The attack reached the camp first, and Arren had nothing kind to say about the fallen zealots."}
pack.questIDs[590].highlight = {"Calvin Montague tried to fight his way out of paying for the Brill letter. He lost, paid less than promised, and admitted the first offer had been a lie.", "Asked for his promised coin, Calvin Montague chose a fight instead. Beaten, he paid a smaller sum and blamed it on his own lie."}
pack.questIDs[5481].highlight = {"Gordo the abomination sent his gloom weed to Junior Apothecary Holland in Brill. Holland had wanted doom weed, and complained that Gordo kept picking the wrong plants.", "Gordo's gloom weed reached Holland and was refused. The apothecary needed doom weed, and had given up explaining the difference to his abomination."}
pack.questIDs[5482].highlight = {"Doom weed from the mass graves north of Brill reached Junior Apothecary Holland. He rubbed his hands over it and called it a fine service, first to himself, then to the Lady.", "Holland finally had the doom weed Gordo could never find. He paid for it and promised it would come in handy."}
pack.questIDs[358].highlight = {"Rot Hide gnolls had been taking bodies from the Mass Graves for the Scourge. They were cut down, and Magistrate Sevren sent their embalming ichor to the apothecaries.", "Sevren said the Scourge would not use the corpses of the Mass Graves. He hoped the gnolls' ichor would reveal something to use against the Scourge."}
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
    "Yvette mourned Thurman, who had stayed at Agamand Mills out of loyalty to his family, and said she had known Brand meant him harm. Then her face grew cold, and she said that life was over.",
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
    "In Brill, Magistrate Sevren said the Forsaken needed the same fighting talents once again.")
Q(426, "The Mills Overrun", "Tirisfal Glades", 8, "horde_forsaken",
    "The Scourge were trying to make a base of Agamand Mills, from which they could stage attacks deeper into Tirisfal. Deathguard Dillinger had orders to destroy them.",
    "Across the bridge west of Brill and north to the windmills, the Scourge were gathering at Agamand Mills. Deathguard Dillinger wanted ribs and skulls from the skeletons and bonecasters there.",
    "Dillinger would not give thanks for necessary work, but said the Deathguards of Tirisfal would remember who had done it.",
    "Notched ribs and blackened skulls came back from the Agamand windmills. To Dillinger they were the war's necessary work, and he gave no thanks for it.")
Q(408, "The Family Crypt", "Tirisfal Glades", 13, "horde_forsaken",
    "Captain Dargol, a skeleton, commanded the Scourge from the Agamand Family Crypt. With necromancy he had raised the Agamand ancestors to fight the Forsaken.",
    "The Agamand Family Crypt was the Scourge's strongest point at the mills. Magistrate Sevren wanted the raised ancestors put down and Captain Dargol's skull brought back.",
    "Sevren took Captain Dargol's skull and called it a telling blow, one the Forsaken's enemies would notice too.",
    "Captain Dargol and many of the raised ancestors fell in the Agamand crypt. Sevren believed the Forsaken would one day drive the Lich King himself from Azeroth.")
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
    "Bottles of Whispering Elixir might still lie in the ruins of Shadowvale, deep in the Whispering Forest. Carolai Anise in Brill offered generous pay for them.",
    "The elixirs from Shadowvale were paid for. Carolai Anise called the forest folk an odd lot, and repeated the rumor that the Whispering Forest was cursed.",
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
    "Hawkwind's supplies reached Kaga Wildhoof, who observed that the chief had not listened to her. She offered lessons in camping in return.", nil, true)
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
pack.questIDs[361].highlight = {"Thurman Agamand's last letter finally reached Yvette Farthing in Brill. She mourned him and cursed the plague and the Scourge, then declared that her old life was over.", "From an undelivered letter, Yvette Farthing learned what had become of Thurman Agamand. Regrets were for the weak, she decided, and love was no longer among her goals."}
pack.questIDs[362].highlight = {"Devlin Agamand still chattered madly near the road to the mills. His bones went to Coleman Farthing's mantle, a first piece of revenge on the family who had failed him.", "Coleman Farthing wanted every Agamand destroyed. Devlin, the younger son, was the first, and his bones ended up on Coleman's mantle."}
pack.questIDs[354].highlight = {"The Agamands, whose pride had doomed their workers to undeath, were destroyed at their mills. Coleman Farthing received their remains and hoped they had known fear.", "Coleman Farthing's revenge on the Agamand family was complete. He hoped, foolishly as he admitted, that they had felt fear at the end."}
pack.questIDs[408].highlight = {"Captain Dargol had raised the Agamand ancestors in their family crypt. His skull reached Magistrate Sevren, who called it a telling blow against the Scourge.", "Captain Dargol, who led the Scourge from their strongest point at Agamand Mills, was slain. Sevren said the victory would not go unnoticed by the Forsaken or their enemies."}
pack.questIDs[357].highlight = {"A stolen spellbook told Bethor Iceshard that the lich of Brightwater Lake was Gunther Arcanus, his friend and comrade before the plague.", "The spellbook taken from the island in Brightwater Lake named its owner. Gunther Arcanus, Bethor's old comrade, had grown more powerful in death."}
pack.questIDs[366].highlight = {"Gunther Arcanus got his spellbook back from the same thief who had taken it. Bethor's enchantment on it suggested that his old friend was free of the Lich King.", "Bethor's spellbound message reached Gunther Arcanus on his island. The lich who trusted no undead began to wonder whether Bethor had escaped the Lich King too."}
pack.questIDs[409].highlight = {"Gunther Arcanus asked for Lillith Nefara's destruction as proof against the Scourge. When she fell, he admitted he had believed himself the only one with free will.", "Lillith Nefara rose at the bloody altar off Gunther's island and was destroyed. Gunther was astonished to learn that others had broken the Lich King's hold."}
pack.questIDs[411].highlight = {"Gunther Arcanus sent a Nether Gem to Bethor Iceshard. Through it the old friends from Dalaran could speak again, and Gunther agreed to join the Forsaken.", "Bethor received Gunther's Nether Gem in the Undercity. The lich of Brightwater Lake had been won over, and the Dark Lady would hear of it."}
pack.questIDs[97558].highlight = {"Forsaken skin did not heal, so Shelene Rhobart patched it with hides. Duskbat membranes, darkhound hides and murloc skin restocked her supplies.", "Shelene Rhobart's skins for injured Forsaken were running low. The new hides would serve, she said, from darkhound leather to fine membranes for faces and fingers."}
pack.questIDs[96656].highlight = {"A stranger on the road to Brill turned out to be Eleanor Shackleton, an adventurer with no ties to the Scarlet Crusade. She offered lessons in camping.", "Sent to check on a stranger near Brill, the newly risen found Eleanor Shackleton passing through, and an offer to learn camping."}

-- Durotar's valley, roads and coast (overnight 2026-11-05). Forever additions
-- (96821, 96822, 96825, 96876, 97279, 99048-99052) are labelled by their IDs;
-- names not in the quest text come from LoreForever Z_durotar/Z_general.
Q(787, "The New Horde", "Durotar", 1, "horde_trials",
    "Eitrigg oversaw the training of recruits in the Valley of Trials. He had once left the Horde over the Burning Legion's influence, and came back after Thrall rescued him from human captors.",
    "Thrall had charged Eitrigg with training the Horde's recruits. The old warrior spoke of a Horde free of demons and guided by its shamans, the vision that had brought him back.",
    "In the Den, Gornek had the further instructions Eitrigg had promised.",
    "Eitrigg's account of the new Horde gave way to Gornek's instructions in the Den.")
Q(97279, "Wayward Weapons", "Durotar", 2, "horde_trials",
    "New recruits kept arriving at the Den, and the weaponsmith Kzan was running short of training weapons. Failed recruits had left theirs lying around the valley.",
    "A trainer in the Den wanted to see what a new recruit could do among the boars. Six abandoned training weapons were to be salvaged for Kzan along the way.",
    "Kzan received the six weapons and set to repairing them for the next wave of recruits.",
    "The abandoned training weapons were back in the Den, waiting for Kzan's repairs.")
Q(4402, "Galgar's Cactus Apple Surprise", "Durotar", 3, "horde_trials",
    "Galgar wiped his brow in the heat of the Valley of Trials. With ten cactus apples he could make his famous cactus apple surprise.",
    "Galgar promised a few portions of his cactus apple surprise, and a training manual, for ten cactus apples from around the valley.",
    "Galgar made his cactus apple surprise and added a little something extra.",
    "The cactus apples became Galgar's famous treat, a few portions of it packed for later travels.")
Q(96821, "Legging It", "Durotar", 6, "horde_roads",
    "Fewer travelers were coming from Razor Hill. Spiders had begun nesting along the road, on top of the scorpids.",
    "A troll wanted the new spider nests along the road thinned, and word sent to Razor Hill that the path was safer.",
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
    "Lar Prowltusk was found at his post on Sen'jin's western flank, and the Warchief's help was his to use.",
    "The pact between orc and troll brought aid to Lar Prowltusk on Sen'jin's western flank.")
Q(99048, "A Missing Hand", "Durotar", 11, "horde_roads",
    "Heglan Shadeeye of the Shattered Hand had been watching Tiragarde Keep from a distance, and her reports had stopped. Her commander doubted the humans had caught her.",
    "The Shattered Hand's watcher at Tiragarde Keep had gone silent. Something more dangerous than the human garrison was suspected.",
    "Heglan's body lay cold in the wreckage of her hut. Whatever had killed her did not seem human.",
    "The search found Heglan Shadeeye dead in her ruined hut. Signs of what had happened might lie nearby.")
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
    "The young sea giant was dead. Few, Orgnil said, could claim to have survived such a fight.",
    "Durotar's coast was rid of the sea giant that had followed the naga south.", nil, true)
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
pack.questIDs[99049].highlight = {"The evidence around Heglan's post was naga work. Orgnil Soulscar warned that pressure from both directions would be too much for Razor Hill.", "A naga banner and a broken blade from Heglan's post reached Orgnil. The naga had come down the coast from the north, and he meant to stop them there."}
pack.questIDs[99052].highlight = {"A young sea giant had followed the naga down Durotar's coast. It was killed, and Orgnil said few could claim to have survived such a fight.", "The sea giant that had followed the naga down the coast was dead. Orgnil called it a kill to be proud of."}

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
    "A young tauren on Red Cloud Mesa was in the middle of the Rite of Strength, and too tired to carry a father's furs to the inn at Bloodhoof Village as well.",
    "Furs for the Bloodhoof inn waited on Red Cloud Mesa while their bearer was busy with the Rite of Strength.",
    "Innkeeper Kauth received the furs sooner than he had expected. They would make good blankets for anyone staying at his inn.",
    "Innkeeper Kauth took the furs for blankets and said his inn was open to all of his people.")
Q(770, "The Demon Scarred Cloak", "Mulgore", 12, "horde_narache",
    "Ghost Howl's ragged hide still bore a terrible wound from the white wolf's battles against the Burning Legion.",
    "The great wolf Ghost Howl was dead, and someone in Bloodhoof Village ought to know.",
    "An old hunter in Bloodhoof Village could barely believe Ghost Howl had been defeated. He gave one of his own weapons and hoped the wolf's spirit had found peace.",
    "In Bloodhoof Village an aging hunter heard that Ghost Howl was dead and hardly believed it. He parted with a weapon from his own hunting days.")
Q(99079, "Longwalker Malah", "Mulgore", 9, HL,
    "The Longwalkers were the tauren's most trusted scouts, loyal to the High Chieftain alone. Longwalker Malah had gone to watch the eastern borders and had not returned after three days.",
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
    "Baine Bloodhoof ordered an attack on the centaur camp, and wanted the head of the raiding party's leader as a warning to others.",
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
pack.questIDs[99079].highlight = {"Longwalker Malah had not returned from the eastern borders after three days. She was found dead, with arrows in her back and on the ground around her.", "The search for the missing Longwalker Malah ended in the east of Mulgore, where she lay shot with many arrows."}
pack.questIDs[99080].highlight = {"Baine Bloodhoof would not yield a blade of grass to the centaur raiding Mulgore. Their camp was destroyed, and he called it a great victory for the village and its young.", "The centaur raiding party was driven out of Mulgore before it could ride on Bloodhoof Village. Baine gave his deepest thanks."}
pack.questIDs[99082].highlight = {"Cairne Bloodhoof heard that the Galak had dared enter Mulgore and been driven out. He said the victory had brought pride to the ancestors.", "Baine's report of the defense reached his father atop Thunder Bluff. Cairne honored the victory over the Galak with a gift."}
pack.questIDs[98430].highlight = {"Longwalker Perith Stormhoof's mission to the gnolls had turned violent. He was brought out alive, and Cairne thanked those who had risked their lives for his most trusted scout.", "Cairne's secret envoy to the gnolls nearly became their feast. Perith Stormhoof escaped, and the High Chieftain was relieved to hear it."}
pack.questIDs[98427].highlight = {"A Venture Company shredder in the mine near Bloodhoof Village could erase a glade in days. It was stopped, and Morin Cloudstalker said the whole village was in debt.", "A Venture Company shredder had threatened the trees near Bloodhoof Village. Once it was stopped, Morin asked the Earth Mother's grace for those who had done it."}
pack.questIDs[98435].highlight = {"Mull Thunderhorn's report on Mulgore's wells reached Hamuul Runetotem, who said he could feel the joy in the plains' streams.", "Hamuul Runetotem received Mull Thunderhorn's report on the wells with a token of thanks. The water sustained the tauren and the animals they depended on."}

Q(449, "The Deathstalkers' Report", "Silverpine Forest", 11, "horde_forsaken",
    "Scouting Silverpine had proved more dangerous than High Executor Hadrec expected.",
    "With Quinn recovering, the Deathstalkers still needed their report delivered.",
    "Hadrec had not reckoned on so much Scourge in Silverpine, nor on his Deathstalkers' troubles. He promised a commendation for the help given them.",
    "The Deathstalkers' report surprised High Executor Hadrec with the Scourge's numbers in the forest.")
Q(447, "A Recipe For Death", "Undercity", 12, "horde_apothecary",
    "Renferrel's studies showed that spider blood and a toxin from grizzled bear hearts made a deadly elixir. The spiders were in the Skittering Dark, the bears all over Silverpine.",
    "Arthas's numbers were overwhelming, Renferrel said, but a new plague could end the Scourge and the humans together. He wanted spider blood and bear hearts for Faranell in the Undercity.",
    "Faranell was glad Renferrel had sent the samples, and said they would prove useful to the cause.",
    "In the Undercity, Master Apothecary Faranell took the spider blood and bear hearts and set to studying their toxins.", nil, true)
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
    "Apothecary Renferrel at the Sepulcher was gathering reagents for a plague he believed could end the Scourge and the humans alike. Master Apothecary Faranell in the Undercity studied what he sent.",
    "Berard, once one of the Society's most promising apothecaries, had been cursed by Arugal into a mindless servant. His research on an ancient plague of Lake Lordamere was still wanted.",
    "One more piece of the Society's plague was in apothecary hands, between the Sepulcher and the Undercity.",
    "The apothecaries of the Sepulcher and the Undercity were a step nearer the plague they wanted.", {V .. " #447, #450, #451"})

-- Shaman trials. The title is shared across ingredients, introductions,
-- manifestations and rewards, including Forever's other racial routes.
Fallback("Call of Earth", "shaman_earth",
    "Earth was the first of a shaman's four paths. Its teachers asked for patience and for a sapta drunk on holy ground.",
    "Patience was earth's greatest virtue, the shaman trainers said, and its rite led through a sapta to a pebble at the heart of a totem.",
    "One more step of the earth rite was behind the shaman.",
    "The earth's teaching had gone a little further.", {V .. " #1516-1521, #92466-92468", F .. " #94374"})
Fallback("Call of Fire", "shaman_fire",
    "Fire was the second path, and its teachers insisted it was about creation as much as destruction.",
    "Strength alone did not make a shaman ready for fire, its teachers warned.",
    "The shaman had come a step further along the path of fire.",
    "The fire rite had gone a little further.", {V .. " #1522-1527, #2984", F .. " #94449, #94465-94468"})
Fallback("Call of Water", "shaman_water",
    "Water healed only when it was pure, its teachers said, and polluted water ruined all it touched.",
    "The third path was water. Its lessons were about purity, and its samples came from far apart.",
    "The shaman had one more step of the water rite behind them.",
    "The water rite had gone a little further, from one pure sample to the next.", {V .. " #63, #96, #100, #220, #1103, #1528-1536", F .. " #94495-94505"})
local earth = {
    {1516, "Durotar", "Canaga Earthcaller judged a young shaman ready to stand before the earth itself. First he wanted two hooves from the felstalkers north of the Valley of Trials.", "Patience was earth's greatest virtue, Canaga Earthcaller said, and a time of conflict was drawing near. The felstalkers to the north would supply the hooves for a sapta.", "Canaga took the felstalker hooves and spoke of earth as the foundation of all things, strength and stamina and patience. He would brew the sapta now.", "The hooves satisfied Canaga. Earth would protect a shaman who respected it, he said, and it could be fickle like the rest. He turned to making the sapta."},
    {1517, "Durotar", "A sapta bound a shaman's spirit to one element, and it was drunk only in a holy place. Canaga's was for Spirit Rock, at the end of the Hidden Path southwest of the valley.", "Only a few shamans knew the recipe for a sapta. Canaga sent his to be drunk at Spirit Rock, where the earth could be seen as no one else saw it.", "At Spirit Rock the earth spirit was pleased to find a young shaman before it. Humility was all it asked; the other elements, it warned, would not be so passive.", "The earth spoke at Spirit Rock. The mountains would be the shaman's strength and the plains the shaman's patience, it said, and the rite was passed by standing humbly before it."},
    {1518, "Durotar", "The earth spirit gave a piece of rough quartz as proof of the meeting at Spirit Rock. Canaga Earthcaller would craft a totem around it.", "A pebble could outlast many larger things, the earth spirit said, and handed over a rough quartz for Canaga's totem.", "Canaga crafted the earth totem with the quartz at its heart. It was a focus for the earth's spells, he said, and the trainers would know when more was due.", "The rough quartz became an earth totem in Canaga's hands. He welcomed its bearer to the first of four paths."},
    {1519, "Mulgore", "Seer Ravenfeather saw wisdom in a young tauren already, and the earth was calling. The Bristleback shamans in the ravine east of Narache kept a salve she needed for a potion.", "Mountains became deserts and rivers canyons, Seer Ravenfeather said; the earth was the most stubborn and wise of the elements. Its first test was Bristleback salve from the ravine.", "Ravenfeather took the Bristleback salve and called the return a rebirth. She would make the sapta now, and a new path would open with it.", "The salve from the ravine was enough for Ravenfeather's sapta. The Earth Mother would protect a shaman who respected her, she said, and her secrets were not to be forgotten."},
    {1520, "Mulgore", "Ravenfeather's sapta was to be drunk at the shaman shrine east of Narache and nowhere else. It would show the earth as no one had seen it.", "A sapta tied a shaman's spirit to one element forever, Ravenfeather said. Hers was for the shrine to the east.", "At the shrine the earth spirit was pleased to find a young shaman before it. Humility was all it asked; the other elements, it warned, would not be so passive.", "The earth spoke at the shrine east of Narache. The mountains would be the shaman's strength and the plains the shaman's patience, it said, and the rite was passed by standing humbly before it."},
    {1521, "Mulgore", "The earth spirit gave a rough quartz as proof of the meeting at the shrine. Seer Ravenfeather would make it the heart of a totem.", "Even the smallest thing could outlast mountains, the earth spirit said, and gave a pebble for Ravenfeather's totem.", "Ravenfeather crafted the earth totem with the quartz at its heart, a focus for the earth's spells. Trainers across Kalimdor would know when more was due.", "The rough quartz from the shrine became an earth totem in Ravenfeather's hands. She welcomed its bearer to the first of four paths."},
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
for _, r in ipairs({{1522, "Searn"}, {1523, "Xanis"}, {2984, "Narm"}}) do
    Q(r[1], "Call of Fire", "The Barrens", 10, "shaman_fire",
        "A shaman strong in the ways of earth was ready to talk to Kranal Fiss, who lived north of the Crossroads and taught fire. Too far north, the warning went, and the trail ended in the elves' lands.",
        "The second element waited in the Barrens. Kranal Fiss, north of the Crossroads, could teach the ways of fire to anyone who thought they were ready.",
        "Kranal Fiss saw the burning and the desire already, he said, and offered the sapta of fire. Power and destruction would come easily; the lesson was knowing when to stay one's hand.",
        r[2] .. " could always be trusted, Kranal said, so the time for the fire sapta had come. He counseled patience, as earth had taught.", nil, true)
end
local fire = {
    {1524, 11, "Durotar", "Being strong enough to wield the fire totem did not mean being ready for it, Kranal Fiss said. A hidden trail along the Southfury River climbed to the Shrine of the Dormant Flame, where Telf Joolam kept watch. Kranal's torch had to come back lit from its brazier.", "Kranal Fiss gave an unlit torch as the mark of someone attempting to tame fire. It was for Telf Joolam, keeper of the Shrine of the Dormant Flame on one of the highest peaks in Durotar.", "Telf Joolam had been about to turn the visitor away until he saw the torch. Treasure hunters found an empty shrine up here, he said; to shamans it was sacred.", "The torch opened the Shrine of the Dormant Flame. Telf apologized for his welcome and spoke of the secret the peak kept from the rest of the Horde."},
    {1525, 12, "Durotar", "Telf Joolam needed two things for a fire sapta. Fire tar came from Razormane spellcasters in the eastern Barrens, and a reagent pouch from the Burning Blade cultists in a cave northeast of Razor Hill.", "A sapta was always made from things tied to its element, and warlocks were tied to fire. Telf wanted a Burning Blade reagent pouch and Razormane fire tar.", "Telf judged the tar and the pouch would do nicely. Fire was about life and creation as much as chaos, he said, and opposing forces gave one another meaning.", "With the fire tar and the Burning Blade pouch in hand, Telf could bind a shaman to the flame. He asked that fire be remembered as creation too."},
    {1526, 13, "Durotar", "The fire sapta was finished. At the top of the mountain a manifestation of fire waited, growing stronger the longer it lived, and its embers were to light the brazier and the torch.", "Telf sent the shaman up the mountain with the sapta to face the manifestation of flame. It would not attack until the shaman was ready, he said, and then it had to die quickly.", "A white-hot flame rose in the brazier when the ember went in. The torch caught at once.", "The manifestation's glowing ember lit the brazier of the Dormant Flame, and the torch took fire from the bowl."},
    {1527, 13, "The Barrens", "The torch burned, and the wind off the peak made its flame dance. The path led back down to Kranal Fiss in the Barrens.", "Kranal Fiss had asked for his torch back aflame from the shrine's brazier. It was time to carry it down.", "Kranal said the spirit before him burned brighter than any torch he had seen. He presented the fire totem and said that one day their brethren would look to its bearer for guidance.", "The burning torch earned Kranal's congratulations and the fire totem. Keep to this path, he said, and the elements would be there to command."},
}
for _, r in ipairs(fire) do Q(r[1], "Call of Fire", r[3], r[2], "shaman_fire", r[4], r[5], r[6], r[7], nil, true) end
for _, id in ipairs({1528, 1529, 2986}) do
    Q(id, "Call of Water", "The Barrens", 20, "shaman_water",
        "After fire came water. Islen Waterseer kept a fishing hut on the Barrens coast south of Ratchet, and could teach its purity to anyone ready to learn.",
        "Islen Waterseer lived along the eastern coast of the Barrens, south of the Southfury River and Ratchet. The third element was hers to teach.",
        "Islen saw a spirit already warmed by fire and judged it time to learn the purity of water. The first step, she said, was the shaman's own to take.",
        "At her fishing hut, Islen agreed that the time for water had come. The path so far would give the strength to go further, she said.", nil, true)
end
local water = {
    {1530, 22, "The Barrens", "Water meant rebirth, Islen said, and it healed only when it was pure. The water sapta had to be sought from {n:Brine}, who lived deep in the southern Barrens with quilboar all around her.", "Islen's one lesson of water was that polluted water devastated everything it touched. For the sapta itself she sent the shaman to {n:Brine}, far to the south among the quilboar.", "{n:Brine} guessed the question before it was asked. Everyone had reasons for how they lived, she said, and the better question was what brought a shaman so far to find her.", "Deep in the southern Barrens, {n:Brine} wondered aloud what possessed anyone to live out there unprotected, and then what brought a visitor to ask."},
    {1535, 22, "The Barrens", "{n:Brine} began with a simple task. Below her hut lay a pond, and a waterskin of it was the first of the pure samples she wanted.", "To earn the sapta, {n:Brine} said, one had to seek out the purest water and watch what lived by it. The first skin was to be filled at the pond below her hut.", "{n:Brine} had expected bloodshed at the pond. It was a pity, she said, that the quilboar did not see all living things as tied together, and a boon for the Barrens' other races that they did not.", "{n:Brine} took the first waterskin and spoke of the quilboar, for whom even a small pool was a hoard. Their greed only prolonged their own suffering, she said."},
    {1536, 22, "The Barrens", "Years ago, {n:Brine} had found a well of fresh spring water in the middle of Tarren Mill, a small holy vestige in an unhallowed sea. She wanted a skin of it.", "The second sample lay far to the north. {n:Brine} remembered a pure well at the center of Tarren Mill, which, she thought, its plagued citizens hardly valued.", "{n:Brine} called the Tarren Mill water good and the dedication behind it better. One more sample would make the reagent for the sapta, and Islen would be pleased.", "The well water from Tarren Mill was the second of three. {n:Brine} needed one more before she could make the sapta's reagent."},
    {1534, 23, "The Barrens", "The last sample lay beyond Lake Mystral in Ashenvale, in a small fountain at the center of the Ruins of Stardust. {n:Brine} gave the waterskin for it.", "{n:Brine} sent the third waterskin north into Ashenvale, to the fountain among the Ruins of Stardust. It would be the final component before Islen.", "With all three samples, {n:Brine} could make a vial of the purest water any living creature would find. She was pleased, she said, to count the shaman among her kind.", "The fountain water from Stardust completed {n:Brine}'s set. She would make the vial for the next steps of the rite, and said the shaman did all shamans proud."},
    {220, 23, "The Barrens", "{n:Brine}'s vial of pure water was for Islen Waterseer, who had one more task before the next totem.", "{n:Brine} gave the vial of water for Islen's last task and said they would meet again some day.", "Islen admired the vial Brine had made and blessed. It would make a sapta for the water spirits at the shrine in Silverpine, south of the Undercity, and its last drops had another use.", "Islen took the blessed vial. The sapta from it would open the shrine in Silverpine Forest, she said, and the remaining drops were for one more journey."},
    {63, 23, "Silverpine Forest", "On the coast of Silverpine, west of the Sepulcher, the plague had tainted a shrine and its spirits no longer spoke. Islen sent the shaman to kill the manifestation there and cleanse the pool.", "Islen's last task lay at a plagued shrine on the Silverpine coast. The corrupt manifestation had to fall, and its bracers and the last drops of Brine's potion go onto the brazier.", "The bracers went onto the brazier and Brine's last drops into the flame. They crackled, and the simple words Islen had taught began the ritual.", "At the brazier west of the Sepulcher, the elemental's bracers and the remaining drops of Brine's water started the incantation."},
    {100, 23, "Silverpine Forest", "Light burst out at the end of the incantation, and the corrupt spirits around the shrine were destroyed.", "The incantation finished in a burst of light that destroyed the corruption around the pool.", "A pure water spirit spoke at last. It gave thanks to the shamans, and warned that corruption ebbed while life still waned.", "The cleansed spirit thanked the shamans. The corruption had ebbed, it said, but it fell to shamans to protect a life that kept waning."},
    {96, 23, "The Barrens", "The water spirit gave a shard and a charge with it, to protect and give life with water's power. The shard was the proof Islen had asked for.", "Islen had asked for proof from Silverpine. The spirit's shard was it, with its words about water as life and corruption as its end.", "Islen took the shard as the proof she had asked for and gave the water totem. The next test would not come for some time, she said.", "The shard from Silverpine earned Islen's congratulations and the water totem. Pure water gave life back to the injured, she said, and had other uses a trainer could teach."},
    {1103, 23, "Silverpine Forest", "Tiev had just killed the corrupt water spirit himself and was about to use the brazier. He offered to wait, so a second shaman could see the pure spirit too, if shown a water sapta from Islen.", "At the Silverpine shrine, Tiev held his bracers back from the brazier. He knew how things went wrong, he said, and would share the ritual for proof of a sapta.", "Tiev saw the sapta and put his own parts into the brazier. He knew a trick or two about how sapta magic worked, he said, and asked to head down to the shrine and speak with the spirits together.", "The sapta was proof enough for Tiev. He offered his bracers and drops for the brazier so that both could speak to the spirit."},
}
for _, r in ipairs(water) do Q(r[1], "Call of Water", r[3], r[2], "shaman_water", r[4], r[5], r[6], r[7], nil, true) end
for _, id in ipairs({1531, 1532}) do
    Q(id, "Call of Air", "Thousand Needles", 30, "shaman_air",
        "The last element was air, and it was difficult to control. Prate Cloudseer, hidden in a hole far to the east of Thousand Needles, could say how the air totem was earned.",
        "Air was the fourth path. Prate Cloudseer in eastern Thousand Needles would teach it to a shaman who treated her with respect.",
        "Prate Cloudseer gave an air totem for the time being, enough to focus spells and call the spirits of air. She would train further when the shaman was ready.",
        "The air totem came from Prate Cloudseer without a trial. More training waited with her for later, she said.", nil, true)
end
Fallback("Call of Air", "shaman_air",
    "Air was the fourth of a shaman's paths and difficult to control, and Prate Cloudseer taught it from Thousand Needles.",
    "The winds had their own teacher, Prate Cloudseer, hidden in eastern Thousand Needles.",
    "The call of air had brought the shaman a step further.",
    "Prate Cloudseer's teaching of air went a little further.", {V .. " #1531, #1532"})

-- Forever dwarf shaman stages use their own teachers and geography.
local dwarfFire = {
    {94449, 10, "Dun Morogh", "Bruegs Kindleborn lived in a cave above South Gate Outpost.", "The fire teaching led east through the mountains to Bruegs.", "Bruegs Kindleborn took the elder's word as solid and judged the newcomer ready for the sapta of fire.", "Fire was easy to wield and hard to master, Bruegs warned, and a shaman had to know when to hold back."},
    {94465, 11, "Loch Modan", "Strength alone would not make a shaman ready for the fire totem, Bruegs said. A hidden path in the crags of Loch Modan, beyond the Valley of Kings, climbed to the Shrine of the Dormant Flame, where Braldir Ashmantle kept watch. Bruegs's torch had to come back burning from its brazier.", "Bruegs Kindleborn gave an unlit torch to show intent, for Braldir Ashmantle at the Shrine of the Dormant Flame on a sacred peak above Loch Modan.", "Braldir Ashmantle had been about to turn the climber back until he spotted the torch. Wanderers found only stone and silence up there, he said; to shamans the shrine held a sacred flame waiting to be awakened.", "The torch opened Braldir's shrine. He apologized for his welcome and spoke of truths the Alliance could not fathom in that place."},
    {94466, 14, "Loch Modan", "Braldir needed two things for a fire sapta. Fire tar came from the Tunnel Rat geomancers in the kobold caves to the north, and a reagent pouch from a Stonesplinter seer in the southern hills.", "A sapta to bind a shaman to the flame needed kobold fire tar and a Stonesplinter seer's pouch, Braldir said. Dangerous work, but worthy of the flame.", "The tar and the pouch would do fine, Braldir said. Fire was forge and the breath of creation as well as ruin, and mastering magic meant knowing when to blend rather than burn.", "With the fire tar and the seer's pouch, Braldir could bind a shaman to the flame. Without shadow, he said, light was only a glare."},
    {94467, 14, "Loch Modan", "The fire sapta was ready. At the peak above the shrine a spirit of flame waited, burning stronger the longer it lived, and its embers were to light the brazier and the torch. Blackrock Mountain stood in plain view from that sacred place.", "Braldir sent the shaman up to the peak with the sapta to face the flame. It would not strike first, he said, and then it had to die fast.", "A white-hot flame rose in the brazier when the ember went in, and the torch caught at once. The smoke drifted toward Blackrock.", "The spirit's glowing ember lit the brazier above Loch Modan, and the torch took fire from the bowl."},
    {94468, 14, "Dun Morogh", "The torch burned, and the wind off the peak made its flame dance over Loch Modan. The path led back to Bruegs Kindleborn in Dun Morogh.", "Bruegs Kindleborn had asked for his torch back aflame from the shrine's brazier. It was time to carry it down.", "By Madoran's beard, Bruegs said, the spirit before him burned brighter than any torch he had seen. He offered his hearty congratulations and the fire totem.", "The burning torch earned Bruegs's congratulations and the fire totem. Keep walking this path, he said, and the elements would bend to the shaman's will. Flameborn, he called the newcomer."},
}
for _, r in ipairs(dwarfFire) do Q(r[1], "Call of Fire", r[3], r[2], "shaman_fire", r[4], r[5], r[6], r[7], F, true) end
local dwarfWater = {
    {94495, 22, "Wetlands", "Water meant rebirth, Norric said, and it healed only when it was pure. The water sapta had to be sought from Hervdana Saegrund, whose family lived in a cave beneath the southern falls of the Wetlands.", "Norric's one truth of water was that tainted water ruined all it touched. For the sapta itself he sent the shaman to Hervdana Saegrund beneath the Wetlands' southern falls.", "Hervdana guessed the question in her visitor's eyes, about who would live out in the Wetlands with Dark Irons about and no guard. Everyone had reasons, she said, and the better question was what brought a shaman to her home.", "Beneath the falls, Hervdana Saegrund wondered aloud what brought a visitor so far, and reckoned they both knew the answer."},
    {94497, 22, "Wetlands", "Hervdana began simply. The first skin was to be filled at the base of the falls, where fresh water met brackish, and the marsh was to be minded on the way.", "To earn the sapta, Hervdana said, one had to seek water in its many forms and watch the beasts that guarded it. The first sample came from the foot of the falls.", "Hervdana was glad the Dark Irons had been avoided, and wondered what dwarfkind might do if the clans stopped squabbling. She called the estuary water a sacred offering and the start of a vessel's path.", "Hervdana took the first waterskin and spoke of the tides that flooded the marsh when the moons were strong. The offering marked the beginning, she said, of seeking the waters' wisdom."},
    {94499, 22, "Wetlands", "Redridge drank from Lake Everstill, Hervdana said, but something seeped in by the time the water tumbled down Stonewatch Falls, and the murlocs there were twisted brutes. She wanted a sample to learn whether it was magic, venom or worse.", "The second sample lay far to the south, below Stonewatch Falls in Redridge, where the murlocs grew big and strange. Hervdana wanted to know what was in that water.", "Hervdana called the Stonewatch water good and pure. The shadowseers' magic must be changing the murlocs, she said; one more sample would make the sapta's reagent, and Norric would be pleased.", "The Redridge water was nothing but pure, Hervdana found. She needed one more sample before she could brew the reagent."},
    {94500, 23, "Wetlands", "The last sample lay in Ashenvale, in the lake that cradled Astranaar, with ruins on its bed. Hervdana gave the waterskin for it and named the boat from Menethil.", "Hervdana sent the third waterskin across the sea to Astranaar's lake, pure and ancient and perhaps enchanted. The forest had eyes, she warned, and they did not blink.", "With all three samples, Hervdana would brew a vial of water so pure it would make the mountains weep. She was proud, she said, to call the shaman kin.", "The Astranaar water completed Hervdana's set. The vial she would brew from it was the final piece of the rite, and she said the shaman did all shamans proud."},
    {94501, 23, "Loch Modan", "Hervdana's vial of pure water was for Norric, who had one more task before the water totem.", "Hervdana gave the vial for Norric's last task and said they would meet again some day.", "Norric called the vial a gift, blessed by Hervdana and gathered by hand. It would birth a sapta to glimpse the water spirits at Stendel's Pond near Moonbrook, and not a drop of the rest was to be wasted.", "Norric took the blessed vial. The sapta from it would open Stendel's Pond in Westfall, he said, and its last drops had a purpose of their own."},
    {94502, 23, "Westfall", "Stendel's Pond outside Moonbrook had been a pure spring until dark forces touched it, and its spirits had gone silent. Norric sent the shaman to kill the corruption there and put its bracers and the last of Hervdana's drops on the shrine.", "Norric's last task lay at Stendel's Pond in Westfall. The corrupt manifestation had to fall, and its bracers and the sacred drops go onto the shrine to call a cleansed spirit.", "The bracers went onto the shrine and the last drops onto dry stone. They vaporized within the bindings as the simple words Norric had taught began the ritual.", "At the shrine by Stendel's Pond, the elemental's bracers and the remaining drops of Hervdana's water started the incantation."},
    {94503, 23, "Westfall", "Light erupted on the final word, and the corrupt spirits around Stendel's Pond unraveled like ash on the wind.", "The incantation ended in a burst of light that scattered the corruption around the pond.", "A pure water spirit spoke at last. It gave thanks to the shamans, and warned that corruption ebbed while life still waned.", "The cleansed spirit of Stendel's Pond thanked the shamans. The corruption had ebbed, it said, but it fell to shamans to protect a life that kept waning."},
    {94505, 23, "Loch Modan", "The water spirit gave a shard and a charge with it, to protect and give life with water's power. The shard was the proof Norric had asked for.", "Norric had asked for proof from Westfall. The spirit's shard was it, with its words about water as life and corruption as its end.", "Norric took the shard as the proof he had asked for and gave the water totem. The next trial would not come soon, he said, and pure water's gifts went beyond mending wounds.", "The shard from Stendel's Pond earned Norric's congratulations and the water totem. Use it wisely, he said, and fortune would walk beside its bearer."},
}
for _, r in ipairs(dwarfWater) do Q(r[1], "Call of Water", r[3], r[2], "shaman_water", r[4], r[5], r[6], r[7], F, true) end
local skyFire = {
    {97243, "Skywall was still the elemental plane, and all four elements spoke to those who listened. One Windshaper, the shen'dorei Olariaan Swiftburn, was attuned to fire, and a torch was to go to him at the Shrine of Flames in the Gustberry Lowlands.", "The Windshapers' fire teaching belonged to Olariaan Swiftburn at the Shrine of Flames, tucked along the island's edge west of Valanaar. A torch marked the pupil.", "Olariaan took the torch and agreed to teach the call of fire. It would not be easy, he said, but nothing done in that realm ever was.", "At the Shrine of Flames, Olariaan Swiftburn accepted the torch and a new pupil for the call of fire."},
    {97244, "Skypriest Faladiel had been a caller of the flame and a Windshaper before he sold his loyalty to the Al'Aketh, and his hands were stained with his former brothers' blood. Olariaan wanted him dead at the farm past Valanaar and his heart for the ritual.", "The fire ritual needed a traitor's heart. Faladiel, once a Windshaper, served the Al'Aketh now at a farm south of the Shrine of Akir.", "The Windshapers did not forget, Olariaan said, and blood was paid with blood. Faladiel's heart would feed the flames, and one more thing was needed.", "Faladiel's heart was one offering for the flames. Olariaan called it a painful reminder of the Windshapers' creed, and named a second task."},
    {97245, "The people of the Shen'dar Highlands spoke of an old forest sprite, Kuramaa, living in a twisted stump near the anchor pylon. A knock on the bark would bring it out, and only flame could lay it low. Olariaan wanted its wooden mask.", "The second offering was the wooden mask of Kuramaa, a forest sprite in a stump on a hill in the Shen'dar Highlands. Most magic would not touch it, Olariaan warned; fire would.", "Kuramaa's mask completed the offerings. Olariaan meant to light the Eternal Flame now and commune with the spirits of fire.", "With the sprite's mask and the traitor's heart in hand, Olariaan had what the ritual needed."},
    {97257, "Olariaan would lay the offerings on the altar and call the spirits of flame. If they accepted, they would light the Eternal Flame for the torch to catch. Then the torch had to reach the Brazier of Eternal Flames in Valanaar before the Firelands' fire faded in Skywall.", "Fire from the Firelands did not last long in Skywall. The lit torch had to be hurried from the Shrine of Flames to Valanaar's brazier.", "The Eternal Flame burned again in Valanaar. Olariaan presented the fire totem and said the elemental plane served those who respected it and consumed those who did not.", "The brazier in Valanaar caught before the torch could fade, and the trial was done. Olariaan gave the fire totem with a word on respect for the plane's power."},
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
    "Riaani had his head in the construct's innards when help arrived. Someone had taken its core and its gyrozephyr, and it was a miracle its winds had not dissipated.",
    "Riaani could not imagine why anyone would steal the construct's parts; outside it, they were nearly useless. He wanted them scavenged back before he could do more.",
    "Riaani thanked the scavenger for parts that had not been easy to get. With them he could start the construct, and if its memory was intact it might name the thief.",
    "With the scavenged parts, Riaani could get the construct running. Whether its memory would say who had stripped it was still to be seen.", F, true)
Fallback("The Broken Construct", "forever_winds",
    "A damaged wind construct in Valanaar needed the Windshapers' attention.",
    "Only a few of the island's old magical constructs still functioned.",
    "Riaani, the artisan working on the broken construct in Valanaar, had a helper.",
    "The wind construct in Valanaar was nearer to working again.", {F .. " #93735, #93737"})
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
    "Hanaa Nightwind could not leave the post that warned travelers leaving the grove. The cultists at the temple ruins and their leader Malduko Cloudcrush were left to others.",
    "Hanaa said she had barely kept herself from joining the fight. She hoped the cultists had got the message, and thanked the help on behalf of the Rangers of Thendal Grove.",
    "Malduko Cloudcrush and his ruffians were dealt with, and the Rangers of Thendal Grove gave their thanks.")
Q(92472, "The Next Step", "Zephras Isle", 5, "forever_cult",
    "The Al'Aketh Cult worshipped Al'Akir the Windlord, and its zealots grew more deadly by the day. Aetheen of the Gales sent help south to Constable Aonda in Shen'dar Village.",
    "Shen'dar Village, to the south, needed aid against the cult. Aetheen told the young to present themselves to Constable Aonda.",
    "Aonda said the newcomer did not look like much, but Shen'dar would not turn down help sent by Elder Aetheen.",
    "Constable Aonda accepted the aid Aetheen had sent, doubts and all.")
Q(93746, "A Firm Response", "Zephras Isle", 9, "forever_cult",
    "The High Order had been warned against meddling in Windshaper affairs. Ayessa Dawnsinger wanted Belathaan sent back to them bruised, and he had been seen on the road north toward the Shrine of Akir.",
    "Ayessa Dawnsinger meant to make an example of Belathaan of the High Order, and wanted him caught alone on the road north.",
    "Belathaan was dead. Ayessa learned that the High Order had sent him to talk peace with the Al'Aketh, and laid the blame on its arrogance.",
    "The news of Belathaan's death stunned Ayessa. There was no peace with the cult, she said, and Elaadrin should never have sent him to treat with them alone.")
Q(93090, "What Comes Next", "Zephras Isle", 13, "forever_winds",
    "High Elder Shadowsong gave the Windshapers' expedition his blessing. He hoped whatever solution they found would bring the stability Zephras had lacked for years.",
    "Shadowsong sent his thanks to Ayessa for all that the Windshapers and the Earthen Ring had done for Zephras Isle.",
    "Ayessa was pleased to have the high elder's blessing. With the cult defeated and preparations made, she judged it time to go.",
    "Muln had worked to make skycutter crossings to Mulgore reliable, and some of the Windshapers were already waiting there. Ayessa declared the expedition ready.")
Q(95350, "Welcome to Azeroth", "Orgrimmar", 13, "forever_winds",
    "The Earthen Ring belonged to the Horde, and these new allies were the Windshapers' hope of survival. An emissary was to travel from Thunder Bluff to Orgrimmar and meet Warchief Thrall.",
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
pack.questIDs[92544].highlight = {"Malduko Cloudcrush's cult ruffians had camped near the temple ruins, sent, Hanaa Nightwind believed, to prey on travelers. They were dealt with, and Hanaa gave thanks on behalf of the Rangers of Thendal Grove.", "The Al'Aketh thugs at the temple ruins southwest of the grove lost their leader, Malduko Cloudcrush."}
pack.questIDs[93746].highlight = {"Ayessa Dawnsinger wanted the High Order's envoy Belathaan sent home bruised. Instead he died, having been sent by Elaadrin to talk peace with the cult.", "Ayessa blamed Elaadrin for sending Belathaan of the High Order to treat with the Al'Aketh alone. The envoy was dead."}
pack.questIDs[93090].highlight = {"High Elder Shadowsong blessed the Windshapers' expedition to Kalimdor. With the cult defeated and skycutters crossing to Mulgore, Ayessa judged it time to go.", "Ayessa Dawnsinger received the high elder's blessing. Some Windshapers were already waiting in Mulgore, and the expedition was ready."}
pack.questIDs[95350].highlight = {"In Orgrimmar, Warchief Thrall received the Windshapers' emissary. He had not expected a high elf, but welcomed the guest and granted passage through Horde lands.", "The Windshapers' emissary met Thrall in Orgrimmar and left with his blessing to travel through Horde lands."}

-- Durotar's ordinary work and reports connect the valley, coast and capital.
Q(781, "Attack on Camp Narache", "Mulgore", 4, "horde_narache",
    "The map taken from the Bristlebacks was their warchief's plan for a long siege of Camp Narache. Chief Hawkwind had to see it.",
    "A Bristleback map, read carefully, showed a siege planned against Camp Narache.",
    "Chief Hawkwind called the plans alarming. With them he could summon Bloodhoof Village to break the attack, and he said many tauren lives had been saved.",
    "The siege plans were in Chief Hawkwind's hands, and he meant to call on Bloodhoof Village before the attack came.")
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
    "The Burning Blade had reached the Valley of Trials, and Zureetha feared it heralded something larger. Master Gadrin in Sen'jin Village had to hear of it.",
    "With the valley's trials finished, the question was whether the Burning Blade had reached Sen'jin Village too. Master Gadrin would know.",
    "Gadrin said the report came at a bad time. The Burning Blade was not in Sen'jin, but its evil had taken seed offshore on the Echo Isles, and the trolls needed help of their own.",
    "There was no Burning Blade in Sen'jin, Gadrin said, but their evil had rooted on the Echo Isles. The Darkspear wanted to help the orcs and needed help themselves.")
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
    "Neeru Fireblade named the collar as the Burning Blade's and said the cult rallied around a Demon Seed atop Dreadmist Peak. His assistant Ak'Zeloth at Far Watch Post would say how to destroy it.",
    "Neeru wanted the Demon Seed on Dreadmist Peak destroyed, and sent the matter west to Ak'Zeloth at Far Watch Post.",
    "Ak'Zeloth found it strange that Neeru wanted the Demon Seed gone. He agreed to say how it could be removed.",
    "At Far Watch Post, Ak'Zeloth thought Neeru's wish strange but agreed to explain the Seed's removal. The Seed itself still sat on Dreadmist Peak.")
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
    "Darsok Swiftdagger had one last task after the harpy lieutenants. Serena Bloodfeather's sister had been slain by Rexxar long ago, and the attacks on the Horde caravans were her revenge. Darsok wanted her head to send out on the next caravan.",
    "The harpy raids on the caravans came down to one grudge. Serena Bloodfeather wanted blood for her sister. Darsok wanted her throat slit and her head on a caravan wagon, for the other harpies to think about.",
    "Darsok had not been sure the task was within reach. Serena's head proved him wrong, and he called its bearer quite the cut-throat and paid the reward.",
    "Serena Bloodfeather's head reached Darsok, who laughed and admitted his doubts. The harpy epidemic had lost its leader.")
Q(850, "Kolkar Leaders", "The Barrens", 16, "horde_kolkar",
    "New leaders were rallying the Kolkar, turning scattered bands into a greater threat.",
    "Barak Kodobane camped near the Forgotten Pools, the first leader marked for attack.",
    "Barak's head confirmed the death of one of the Kolkar's capable leaders.",
    "The campaign against the Kolkar leadership began with Barak Kodobane's defeat.")
Q(851, "Verog the Dervish", "The Barrens", 18, "horde_kolkar",
    "Verog the Dervish wandered the Barrens and would be hard to find, Regthar Deathgate said. His base was the centaur command tent at the {p:Stagnant Oasis}. If enough centaur died there, an alarm would bring him running. His head was to join Barak Kodobane's.",
    "Regthar had a second head in mind for his collection. Verog the Dervish could be drawn out by stirring up the Kolkar around their command tent at the Stagnant Oasis.",
    "Regthar's guards had spotted the commotion down at the Stagnant Oasis. Verog's head went up beside Barak Kodobane's, and Regthar said there was much bravery in the one who brought it.",
    "Verog the Dervish answered the alarm at the oasis and died for it. Regthar placed the head with Barak's and spoke of a deed to be proud of.")
Q(852, "Hezrul Bloodmark", "The Barrens", 19, "horde_kolkar",
    "Hezrul Bloodmark led the Kolkar of the Barrens from the {p:Lushwater Oasis} to the south. Regthar called him fierce, brutal and cunning, and believed his death would fracture the Kolkar and shrink their threat.",
    "With Barak and Verog dead, Regthar named the last and highest of the Kolkar leaders. Hezrul Bloodmark held the Lushwater Oasis, and his head was wanted like the others.",
    "Regthar commended the deed. The centaur could not focus their rage as the orcs did, he said, but they were fierce, and Hezrul's head proved its bearer's valor.",
    "Hezrul Bloodmark's head made the third beside Barak's and Verog's. Regthar spoke of valor proven against an undisciplined but fierce enemy.")
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
    "The Barrens had once been lush, until war and cataclysm burned it dry. Now new oases were forming, and Tonga Runetotem's druids sensed a power leaking up from below.",
    "Tonga Runetotem wanted the waters of the Forgotten Pools, northwest of the Crossroads, searched for the power the druids sensed.",
    "A fissure in the earth beneath the Forgotten Pools was bubbling gas. Tonga could not yet say it was the answer, but it was a clue.",
    "Tonga was grateful for the bubbling fissure found under the water, the first clue to the power in the oases.")
Q(877, "The Stagnant Oasis", "The Barrens", 16, "horde_oases",
    "Dead seeds offered a test of the power rising through the oasis fissures.",
    "Tonga wanted dried, infertile seeds placed beneath the Stagnant Oasis's waters.",
    "The seeds revived, showing that the power below the oasis could restore life.",
    "Tonga received evidence that the dead seeds had responded to the fissure's power.")
Q(880, "Altered Beings", "The Barrens", 16, "horde_oases",
    "Tonga thought the oases' strange properties came from outside, or from deep inside the earth. He wanted to know how the fissures affected the beasts that drank there.",
    "The snapjaws of the Lushwater and Stagnant Oases drank the changed water every day. Tonga wanted their shells to study.",
    "The snapjaw shells reached Tonga. Studying an area's beasts told much about the area itself, he said. He gave away coins he had no need for.",
    "Tonga had shells from both oases to examine, and waited to see what they would show.")
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
    "Sergra Darkthorn set the next test. The thunder lizards of the southern Barrens were so large the ground rumbled under them. One false step put a hunter beneath their feet. Stormsnouts, Stormhides and Thunderheads were all to be bested.",
    "The great thunder lizards came after the smaller quarry in Sergra's lessons. She named the Stormsnouts, Stormhides and Thunderheads of the southern plains, and warned about their feet.",
    "Sergra was glad to see proof of victory over the thunder lizards, and gladder still that it came back with no bones broken.",
    "The thunder lizards were bested and the hunter's bones were whole. Sergra remarked on both.")
Q(913, "Cry of the Thunderhawk", "The Barrens", 20, "horde_hunts",
    "The thunderhawk was a fierce beast, Sergra said, and it was time to face one. Its wings would prove the hunt, and after that her teaching would be near its end.",
    "Sergra's last lesson in the Barrens was the thunderhawk, wherever it roamed, and its wings were to come back to her.",
    "Sergra said the hunter should be as proud as the thunderhawk. In her eyes every foe she had set had been bested with strength, courage and honor. Now it was time to move on, for true hunters never stopped walking their path.",
    "The thunderhawk's wings ended Sergra Darkthorn's lessons. She spoke of pride, and of a hunter's path that never ended.")

-- The Crossroads, Camp Taurajo and the road north (overnight 2026-11-05).
-- Thork, Gazrog, Regthar, Mangletooth's cage and Tatternack are placed from
-- LoreForever Z_barrens entries; everything else is from the quest text.
local HG = "horde_mangletooth"
pack.threads[HG] = "the bargain with caged Mangletooth"
Q(5041, "Supplies for the Crossroads", "The Barrens", 14, "horde_roads",
    "A Razormane attack on a caravan had taken supplies the Crossroads badly needed. Thork asked that the lost goods be watched for in the quilboar camps.",
    "The Razormane were growing fat on stolen Crossroads supplies. Thork wanted them recovered from the quilboar camps.",
    "Thork laughed as the supplies came back, and called their finder a boon to the Crossroads.",
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
    "Kadrak read the reports from Zoram'gar, Splintertree and the eastern road, and called them crucial to the Horde's plans.")
Q(878, "Tribes at War", "The Barrens", 21, HG,
    "Mangletooth, a Razormane caged at Camp Taurajo, offered to reveal who really troubled Thork. First he wanted the Bristlebacks' spiritual leaders killed, so his own tribe could win.",
    "From his cage, Mangletooth bargained for blood. He would give the Horde information once the Bristleback wise ones to the north were dead.",
    "Mangletooth should have been glad that the Bristlebacks knew his tribe's pain. Instead he complained that his own people had left him to rot in a cage.",
    "The Bristleback wise ones were dead, but Mangletooth's bitterness turned toward the Razormane who had abandoned him.")
Q(5052, "Blood Shards of Agamaggan", "The Barrens", 21, HG,
    "Agamaggan's blood had hardened into red stones in the earth, and the Bristlebacks carried them as totems. Mangletooth promised quilboar magic for enough of the shards.",
    "Mangletooth knew the secrets of the blood shards the Bristlebacks dug up. He asked for one to show that his visitor understood.",
    "Mangletooth held a blood shard again after a long time without one. No cage, he said, could stop Agamaggan's power.",
    "A blood shard reached Mangletooth, who promised to set his visitor loose on the people who had turned their backs on him.")
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
    "Sergra Darkthorn had taught all she would. To learn more, she said, the hunter had to go south to {p:Camp Taurajo} and find Jorn Skyseer, who would continue the guidance.",
    "The Crossroads lessons were over, and Jorn Skyseer at Camp Taurajo took over from Sergra.",
    "Jorn Skyseer greeted the young one and asked whether it was the hunter's path that had brought the visit. Very good, he said, and began.",
    "At Camp Taurajo, Jorn welcomed Sergra's student onto the hunter's path and started the next lessons at once.")
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
    "A crate of potions and reagents was bound for associates in the Old World. The last caravan to Ratchet had already left. Wharfmaster Dizzywig could put it on the next boat to Blackwater Cove.",
    "The last caravan to Ratchet had left without a crate of alchemy goods for the Old World. Wharfmaster Dizzywig could still see it aboard.",
    "Dizzywig judged the crate small enough and found room for it on the next tide's ship. Then he entered it in his ledger.",
    "The crate went into Dizzywig's ledger, bound for Blackwater Cove on the next tide.")
Q(887, "Southsea Freebooters", "The Barrens", 14, "horde_ratchet",
    "Gazlowe was tired of losing ships and goods to pirates while Vice Admiral Grezzlik's Trade Fleets failed to keep the seas safe. Now the Southsea Freebooters had camped just south of Ratchet.",
    "The Southsea Freebooters had set up on Gazlowe's doorstep. If Grezzlik would not deal with them, Gazlowe would pay someone who did.",
    "Gazlowe hoped the beating would convince the Freebooters to move their operation elsewhere. His stolen goods still had to be recovered.",
    "The pirates south of Ratchet were thinned out. Gazlowe called it good work, then turned to the goods they had stolen from him.")
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
    "Gazlowe's observatory was ready except for its smaller lens, which had been coming by ship and never arrived. His boot shipment from Drizzlik in Booty Bay was missing too.",
    "Gazlowe knew he would not see all his stolen goods again. The pirates' camp still held two he could not do without, an observatory lens and a shipment of boots.",
    "Gazlowe had his lens and his boots back. He offered work to anyone who could do that, and reminded them how well he paid.",
    "The observatory lens and Drizzlik's boots came back to Gazlowe, who was relieved to have them.")
Q(895, "WANTED: Baron Longshore", "The Barrens", 16, "horde_ratchet",
    "Gazlowe's notice named Baron Longshore, captain of the Heedless, as wanted for piracy.",
    "The bounty demanded identifiable remains of the Freebooter captain.",
    "Gazlowe accepted proof of Longshore's death and paid the bounty.",
    "The captain of the Heedless would no longer lead raids on Gazlowe's shipping.")
Q(891, "The Guns of Northwatch", "The Barrens", 20, "horde_ratchet",
    "Northwatch Hold's guns had sunk another ship of Captain Thalo'thas Brightsun's fleet. He wanted Captain Fairmount and her cannoneers dead, and her soldiers' medals as proof.",
    "Captain Fairmount and her cannoneers at Northwatch Hold shot at anything in sight, Thalo'thas Brightsun said. His fallen privateers needed avenging.",
    "The Alliance guns at Northwatch were silent. Brightsun paid for the medals, then turned to the grim work of recovering his dead.",
    "Fairmount and her cannoneers would sink no more of Brightsun's ships. The bodies of his privateers still had to be recovered.")
Q(898, "Free From the Hold", "The Barrens", 20, "horde_ratchet",
    "Gilthares Firebough had been a deckhand on a moonshine transport between Ratchet and Booty Bay when the zealots of Theramore sank it. The only survivor, he sat in a cell at {p:Northwatch Hold}, called an enemy of the Alliance, and wanted out.",
    "Theramore's soldiers had sunk a moonshine boat and locked up its one survivor at Northwatch. Firebough could not believe anyone had got past the guards, and asked for help breaking back to Ratchet.",
    "Thalo'thas Brightsun had thought Firebough long dead. The rescue earned a place of honor with the Thalo'dan Privateers.",
    "Firebough walked out of Northwatch Hold and back to Ratchet, to privateers who had given him up. Brightsun called the rescue heroics.")
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
    "Wizzlecrank had hopped into a Venture Company shredder before realizing he needed a key to unlock its movement column. When another operator asked if everything was all right, he had panicked and claimed a mechanical problem. The supervisor in the control room at the top of the derrick had the key.",
    "A goblin in a stolen shredder was stuck at the Sludge Fen for want of a key. Wizzlecrank wanted it fetched from the supervisor up the derrick before anyone grew suspicious.",
    "Wizzlecrank tried the key and worked through the shredder's controls one by one. He could not believe the Venture Company had designed something so much better than Ratchet's, and he meant to get it home.",
    "The key fit. Wizzlecrank marveled at the shredder's controls and wanted the machine back in Ratchet.")
Q(863, "The Escape", "The Barrens", 18, "horde_ratchet",
    "Wizzlecrank supposed he would learn the shredder as he went. A few buttons, a lever or two. The stolen prototype had to leave the Sludge Fen with a goblin at the sticks who had never driven one.",
    "The shredder had to leave Venture Company ground, and Wizzlecrank was its pilot by default. He asked only whether his escort was ready.",
    "Sputtervalve hoped something of value could be pulled from the wrecked prototype, since his time was running out. He sent a salvage team to Wizzlecrank's position on the double, and paid for the trouble.",
    "The prototype ended the run as a wreck. Sputtervalve dispatched a salvage team to Wizzlecrank and hoped the pieces were worth something.", nil, true)
Fallback("The Escape", nil,
    "Getting out of danger required practical help.",
    "An escape depended on assistance before the immediate difficulty could be left behind.",
    "The requested help with the escape was supplied.",
    "The escape was seen through.", {V .. " #114, #863"})
pack.quests["The Escape"].thread = false
pack.quests["The Escape"].threadLabel = false
Q(896, "Miner's Fortune", "The Barrens", 18, "horde_ratchet",
    "Wharfmaster Dizzywig kept his finger on the pulse of everything that moved between Ratchet and Booty Bay. His latest news was of an emerald the size of a fist. A Venture Company miner had found it at the {p:Boulder Lode Mine}, northeast of the Sludge Fen. He offered to go halves on its sale.",
    "A miner at the Boulder Lode had turned up a fist-sized emerald, and Dizzywig knew buyers. Which miner had it was the problem.",
    "Dizzywig marveled at the size of the emerald and declared them both rich. He worked out the cut from the rates on gems going into Undermine, fifty percent as promised, and called it a pleasure doing business.",
    "The emerald from the Boulder Lode reached Dizzywig, who paid out half by his own reckoning of the Undermine rates.")
Q(865, "Raptor Horns", "The Barrens", 18, "horde_ratchet",
    "Mebok Mizzyrix believed the raptors of the Barrens were smarter than raptors anywhere else, and that the smarts were hiding in their horns. Ground to powder, he thought, they would make smart drinks worth a fortune. He wanted intact horns from the sunscale scytheclaws.",
    "Mebok's fortune hinged on raptor horns. The sunscale scytheclaws roamed the southern Barrens and the north near Ashenvale, and only unbroken horns would do for his smart drinks.",
    "Mebok took the horns. All that remained, he said, was to grind them down and mix them with some wine. Whether the drink made anyone smarter was still to be seen.",
    "The scytheclaw horns reached Mebok, who meant to grind them into his smart drinks. In his mind the fortune was as good as made.")
Q(866, "Root Samples", "The Barrens", 16, "horde_oases",
    "Oasis water appeared to give the Barrens' herbs slightly different properties.",
    "Root samples could be grown and compared with herbs from other regions.",
    "The roots were received for cultivation and study of their possible properties.",
    "The samples supplied the planned comparison, leaving any valuable discovery for later research.")
Q(862, "Dig Rat Stew", "The Barrens", 23, "horde_trade",
    "Grub, east of the Crossroads, was starving all day long and reckoned anyone out in the Barrens must be too. He offered a stew in exchange for dig rats from {p:Bael Modan}, where the dwarves were overrun with them. Nobody was a seasoned adventurer, he said, until they had killed rats.",
    "Grub promised a nice stew for a few dig rats. The dwarves' excavation at Bael Modan had more than enough to spare.",
    "Grub liked his rats riper, left to rot a few weeks for flavor, but he said his customer looked too hungry to wait. He cooked the Dig Rat Stew on the spot and handed it over.",
    "The dig rats from Bael Modan went into Grub's pot fresher than he liked. The stew came out as promised.")
Q(899, "Consumed by Hatred", "The Barrens", 20, "horde_roads",
    "Mankrik stood at the Crossroads from sunrise to sunset scouring the horizon for quilboar. He had killed every pig man he met since, and his thirst for their blood was far from quenched. He asked for their tusks, so the deaths could be celebrated together.",
    "Mankrik wondered aloud whether he should have gone to Taurajo instead of the Crossroads. Either way he wanted quilboar dead, as many as possible, and their tusks brought back.",
    "Mankrik thanked the one who had taken his task seriously. His desire for revenge remained, he said, but he could at least smile to know the quilboar had felt pain themselves.",
    "The tusks reached Mankrik at the Crossroads. They did not quench his thirst for revenge, but the quilboar's pain let him smile.")

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
    "Gann Stonespire had wandered the roads alone since the dwarves of Bael Modan drove his tribe from its ancestral home. He meant to take the land back by force.",
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
pack.questIDs[3921].highlight = {"Sputtervalve had told colleagues in Undermine about the samophlange, then broke it. Wenikee Boltbucket had no idea what it was, but heard the gears inside and wanted to fix it.", "The broken samophlange went to Wenikee Boltbucket near Mor'shan Rampart, who was delighted by a machine she could not name."}
pack.questIDs[3923].highlight = {"Wenikee's gauges read the samophlange's integrity at an all-time low, so it went to Rilli Greasygob in Orgrimmar. The former Venture Company man called its bearer very brave or very stupid.", "Rilli Greasygob of Nogg's Machine Shop recognized the samophlange at once, and wondered who had dared take it from the Venture Company."}
pack.questIDs[3924].highlight = {"Boss Copperplug had hoarded the samophlange manual at the Boulder Lode Mine. Recovered, it went to his old rival Rilli, who promised word if the machine ever worked.", "Rilli Greasygob finally had the samophlange manual his Venture Company rival had kept from him. Sputtervalve sent thanks of his own."}
pack.questIDs[821].highlight = {"Brewmaster Drohn brewed Chen Stormstout's stormstout again from Barrens ingredients. The batch made him nostalgic, and he said the memories warmed his stomach.", "With lion tusks, plainstrider kidneys and a thunder lizard horn, Drohn made the stormstout he never thought he would brew again."}
pack.questIDs[843].highlight = {"Prospector Khazgorm, whose dig at Bael Modan had driven Gann Stonespire's tribe from its land, was dead. Gann felt no remorse and turned to the prospector's notebook.", "Gann Stonespire's talks with the dwarves had failed. Khazgorm's death at Bael Modan was his warning to all who threatened the tauren way of life."}
pack.questIDs[849].highlight = {"Gann Stonespire's charge, made from Khazgorm's own plans, destroyed the dwarves' flying machine at Bael Modan. Gann hoped Thunder Bluff would honor a champion of his lost tribe.", "Bael Modan's flying machine, an insult to the memory of Gann's tribe, was blown apart. Gann called it the work of a defender of sacred tauren lands."}
pack.questIDs[873].highlight = {"Isha Awak, the Deep Doom who had eaten many on the coast, was killed in the sea. Mahren Skyseer said his spirit now lurked in the hunter's eyes.", "Mahren Skyseer sent the hunter after Isha Awak, honorable prey to her. When his heart was brought to her, she declared the hunter one with him."}
pack.questIDs[92706].highlight = {"Bruuz, the shark circling Ratchet's dock, was killed. Gazlowe paid the bounty and thought of putting its fin in a soup, just to have the last laugh.", "Gazlowe's crews could go back in the water once Bruuz's fin reached him."}
pack.questIDs[95508].highlight = {"The hermit tanner above the Dry Hills had served in the Kul Tiras navy and objected to the execution of civilians in Durotar. When men came up his ridge, he survived, and said he had always known his past would catch up with him.", "Men came up the ridge for the former Kul Tiras sailor. Everyone survived, and the hermit tanner gave what reward he could."}

-- Deliveries make the capitals part of everyday life without asserting a flight.
Q(853, "Apothecary Zamah", "Thunder Bluff", 15, "horde_apothecary",
    "Helbrim's spore emulsion needed to reach the Pools of Vision before it lost potency.",
    "Zamah worked in the cave beneath Thunder Bluff's Spirit Rise, waiting for the Barrens sample.",
    "Zamah received the emulsion while it was still potent.",
    "The delivery preserved Helbrim's preparation long enough for his colleague to receive it.")
Q(6361, "A Bundle of Hides", "The Barrens", 10, "horde_trade",
    "Jahan's Barrens hides were meant for Ahanu's leatherwork in Thunder Bluff.",
    "Devrak could arrange transport for a bundle linking the Crossroads' hunters to the city's craftspeople.",
    "Devrak said anyone taking hides to Thunder Bluff was talking to the right orc.",
    "Devrak had a wind rider for the hides. Thunder Bluff was a flight away.")
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
    "Devrak called it no problem. For a small fee, his wind rider would carry the meat to Orgrimmar.",
    "For a small fee, Devrak's wind rider would take Zargh's meat to Orgrimmar.")
Q(6384, "Ride to Orgrimmar", "Orgrimmar", 10, "horde_trade",
    "Gryshka's inn in the Valley of Strength was expecting Zargh's meat.",
    "The delivery connected the Crossroads' butcher with an inn near Orgrimmar's Skytower.",
    "Gryshka called them fine cuts and said Zargh knew his way into a lady's heart. Meat was best served rare, she thought.",
    "Zargh's cuts delighted Gryshka, and she could not wait to cook them.")
Q(6385, "Doras the Wind Rider Master", "Orgrimmar", 10, "horde_trade",
    "Gryshka had written a letter thanking Zargh for the meat.",
    "Doras could arrange the return journey for the innkeeper's letter.",
    "Doras could fly the letter's bearer back to the Crossroads.",
    "Doras had a wind rider for the Crossroads, and Gryshka's letter still to be delivered there.")
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
    "Five Moonrage Whitescalps lay dead on the hill below the Sepulcher. Dalar called the killer a worthy aide for ridding Silverpine of Arugal's curse.",
    "With the Whitescalps dead, Dalar was satisfied. He had worthier work in mind now, against Arugal's curse.")
Q(422, "Arugal's Folly", "Silverpine Forest", 11, HA,
    "A Deathstalker had spotted Arugal's spellbooks at the wheat farm north of the bridge.",
    "Dalar wanted the spell called Remedy of Arugal to understand the wizard's work.",
    "The recovered remedy gave Dalar the spell he had been seeking.",
    "The Remedy of Arugal was precisely the spell Dalar had been after. Keep this up, he said, and there was quite a future among the Forsaken.", nil, true)
Q(423, "Arugal's Folly", "Silverpine Forest", 14, HA,
    "Dalar's examination pointed toward enchanted items used to reinforce Arugal's spells.",
    "Shackles carried by Moonrage gluttons and darksouls offered samples of the enchantments.",
    "Dalar wondered aloud whether nine shackles held enough energy. He should have asked for more, he said, but the collecting had been skillful.",
    "Six glutton shackles and three darksoul shackles went to Dalar. He doubted they would yield enough energy and said as much.", nil, true)
Q(424, "Arugal's Folly", "Silverpine Forest", 15, HA,
    "Dalar's research was taking time while reports placed Arugal's influence in Deep Elem Mine.",
    "The tainted foreman Grimson the Pale stood between the Forsaken and the mine's resources.",
    "Grimson the Pale was beheaded. Deep Elem Mine, Dalar said, would now supply the Forsaken advance through Silverpine and into Azeroth.",
    "With Grimson dead, Dalar counted the mine as taken. His study of Arugal's enchantments was still slow going.", nil, true)
Q(99, "Arugal's Folly", "Silverpine Forest", 15, HA,
    "Pyrewood's people appeared human by day and became Moonrage worgen after sunset.",
    "Dalar wanted Pyrewood shackles to study the enchantment behind the village's changes.",
    "Six Pyrewood shackles gave Dalar the last piece of his research. Arugal would fall, he said, and his reckless magic would be undone.",
    "Dalar praised the persistence behind the Pyrewood shackles. Undoing the curse was still a promise.", nil, true)
Q(98298, "Arugal's Folly", "Silverpine Forest", 16, HA,
    "Dalar concluded that Arugal's shackles bound worgen rather than creating them.",
    "Reports of the curse spreading near the Greymane Wall sent Dalar's inquiry toward the beasts themselves.",
    "Fangs, claws and gizzards from the Greymane Wall settled it for Dalar. Arugal had not made the curse, and so his remedy was worth nothing. The search for a cure went on.",
    "Dalar laughed last, by his own account. The remains from the wall proved the curse had nothing to do with Arugal, which left the worgen as uncured as before.", nil, true)
Fallback("Arugal's Folly", HA,
    "Dalar Dawnweaver, the Forsaken mage at the Sepulcher, held Arugal in contempt and meant to pick his magic apart. He wanted the wizard's spells and the shackles his worgen wore.",
    "Arugal's reckless magic had wreaked havoc in Silverpine, and the Forsaken wanted the forest for their advance south. At the Sepulcher, Dalar Dawnweaver was studying what the wizard had done.",
    "One more piece of Arugal's work was in Dalar's hands at the Sepulcher.",
    "Dalar had another sample of Arugal's magic to pull apart, and he thought little of its maker.", {V .. " #422, #423, #424, #99, #98298"})
Q(428, "Lost Deathstalkers", "Silverpine Forest", 12, HS,
    "Rane and Quinn Yorick had failed to return from reconnaissance in northern Silverpine.",
    "The Sepulcher needed a search of the farms where its missing scouts had begun their mission.",
    "The missing Deathstalkers were found at the farm, still in need of help.",
    "Rane and Quinn Yorick were alive at the farm, and Rane said the help had come not a moment too soon.")
Q(429, "Wild Hearts", "Silverpine Forest", 11, HS,
    "Ivar the Foul had badly injured Quinn, and Rane sought an apothecary's help for his recovery.",
    "Discolored worg hearts could supply Renferrel with ingredients for a healing potion.",
    "Renferrel took the worg hearts and found the Deathstalkers' failure troubling. He gave the potion's recipe along with the potion, in case they needed it again.",
    "At the Sepulcher, Renferrel made Quinn's potion from the discolored hearts and handed over its recipe too. The potion still had to go north.")
Q(430, "Return to Quinn", "Silverpine Forest", 11, HS,
    "Renferrel's potion was ready for the injured Deathstalker waiting at the farm.",
    "Quinn's recovery depended on getting the prepared medicine back from the Sepulcher.",
    "Quinn drank the potion and felt it working, expecting to be able to travel soon.",
    "Quinn drank Renferrel's potion and said he could feel it working. He would travel soon, and called the help a great favor.")
Q(425, "Ivar the Foul", "Silverpine Forest", 12, HS,
    "Ivar still lurked in the barn while Quinn recovered from the ghoul's attack.",
    "Rane needed the nearby ghoul stopped before he could strike the wounded scout again.",
    "Ivar's death removed the immediate danger, and Rane promised to include the help in her report.",
    "Rane thanked the work against Ivar, giving Quinn time to recover without that ghoul returning.")
Q(435, "Escorting Erland", "Silverpine Forest", 11, HS,
    "Hungry wolves kept Erland from reaching his teammate Rane Yorick.",
    "Another Deathstalker's report needed an escort through Silverpine's wolf-haunted paths.",
    "Erland came through the wolves to Rane Yorick. She had feared Silverpine had taken him, and thanked the escort.",
    "The safe arrival put Rane's uncertainty about Erland's fate to rest.")
Q(437, "The Dead Fields", "Silverpine Forest", 14, HF,
    "The Rot Hide gnolls held an old farm north of the Sepulcher, the Dead Fields. Every small assault there had been routed by the banshee Nightlash and her magic.",
    "High Executor Hadrec wanted Nightlash destroyed. If she did not show herself, killing enough Rot Hides at the Dead Fields would bring her out.",
    "Nightlash's essence had turned to dust, and the dust reached Hadrec as proof. The Scourge had lost ground that day, he said.",
    "With Nightlash gone, the Rot Hides at the Dead Fields had lost the banshee who broke every assault. Hadrec counted it ground taken from the Scourge.")
Q(438, "The Decrepit Ferry", "Silverpine Forest", 16, HF,
    "Rot Hides and other undead patrolled the Decrepit Ferry east of the Sepulcher. Hadrec wanted to know why the Scourge had made it a hive.",
    "The Scourge had a reason for guarding an old ferry on Lordamere Lake, and Hadrec meant to learn it.",
    "The ferry's boat was heaped with wrapped corpses. Across Lordamere Lake stood a dock on Fenris Isle, where the bodies had to be going.",
    "Wrapped corpses filled the boat at the Decrepit Ferry, and the dock opposite on Fenris Isle showed where they were bound.")
Q(439, "Rot Hide Clues", "Silverpine Forest", 16, HF,
    "Among the wrapped corpses a woman's hand lay bare, marked by plague but fairly fresh. Her ring was engraved For Deliah.",
    "A ring engraved For Deliah came off a dead woman's hand on the ferry, a clue to carry back to Hadrec.",
    "A fresh body could only have come from the mass graves in Tirisfal, Hadrec reasoned. The Rot Hides were carrying those corpses to Fenris Isle.",
    "Deliah's ring told Hadrec where the Rot Hides found their dead, in the mass graves of Tirisfal.")
Q(443, "Rot Hide Ichor", "Silverpine Forest", 17, HF,
    "The apothecaries believed the strange fluid in the Rot Hides' bodies would show who was behind the gnolls. An assault on Fenris Isle had to wait for that answer.",
    "Apothecary Renferrel, outside the Sepulcher, wanted ichor from the gnolls on Fenris Isle to learn who had made them.",
    "Renferrel took the ichor. It would show the nature of the Rot Hides, he said, and perhaps a weakness, if they had one.",
    "Renferrel called the ichor very good. It might show the Rot Hides' weakness, he said, if they had one.")
Q(444, "Rot Hide Origins", "Undercity", 17, HF,
    "Renferrel had broken the ichor into its parts and found warlock and necromantic magic in it, but nothing certain. Bethor Iceshard, a mage of the Magic Quarter, might know more.",
    "Bethor Iceshard was no apothecary, but Renferrel hoped his knowledge of magic could unravel how the Rot Hides were made.",
    "Bethor found the substance laced with spells he had not seen in a long time, and stopped to cast a divination.",
    "In the Magic Quarter, Bethor Iceshard recognized old and powerful spells in the sample and began a divination.")
Q(446, "Thule Ravenclaw", "Silverpine Forest", 16, HF,
    "Bethor knew the ichor's maker, his old colleague Thule Ravenclaw. Thule had been a promising young mage before he betrayed his brethren and joined the Scourge.",
    "Bethor Iceshard had not known that his old colleague Thule Ravenclaw still lived, let alone led the Rot Hides. He wrote out the incantations for a potion against Thule's spells, for Renferrel.",
    "Renferrel had never used such forces in a potion. The mixture would be powerful, he said, and useful against Thule in his stronghold on Fenris Isle.",
    "Renferrel found Bethor's scroll laced with powerful magic. The potion from it, he said, would serve well against Thule on Fenris Isle.")
Q(448, "Report to Hadrec", "Silverpine Forest", 16, HF,
    "Before any assault on Fenris Isle, Hadrec wanted a report. He might have information or equipment to give.",
    "The news of Thule Ravenclaw had to reach High Executor Hadrec before anyone crossed to Fenris Isle.",
    "If Bethor was right, Hadrec said, Thule Ravenclaw had to be dealt with soon. He opened the Sepulcher's arsenal for the task.",
    "Hadrec offered a pick from the Sepulcher's arsenal for the fight against Thule.")
Q(442, "Assault on Fenris Isle", "Silverpine Forest", 24, HF,
    "The time had come to strike the Scourge's stronghold in Silverpine. Hadrec wanted Thule Ravenclaw's head from Fenris Isle.",
    "Hadrec called the assault on Fenris Isle as dangerous as it was vital. Thule Ravenclaw had to die.",
    "Thule's death was no small event. Renferrel had felt the energies it released even at the Sepulcher, and Hadrec said the deed rang through the Forsaken's ranks.",
    "Hadrec took Thule Ravenclaw's head. The master of the Rot Hides was dead, and Hadrec said the deed rang through the Forsaken's ranks.")
Q(440, "The Engraved Ring", "Tirisfal Glades", 16, HR,
    "Whoever had given Deliah her ring might be traced through Magistrate Sevren in Brill, who kept the names of the recent dead.",
    "Hadrec thought the giver of Deliah's ring was probably dead, or undead and past caring. Still, Magistrate Sevren in Brill might know who she had been.",
    "A Deliah had lived in Brill and been buried in the mass grave, Sevren said. The Rot Hides must have taken her body to Silverpine.",
    "Sevren confirmed the name. Deliah of Brill had been buried in the mass grave, and her body stolen.")
Q(441, "Raleigh and the Undercity", "Undercity", 16, HR,
    "Deliah's husband Raleigh now dwelt in the Undercity's Trade Quarter. If the ring was hers, he would know it.",
    "Sevren sent the ring on to Raleigh, the husband of the Deliah who had lived in Brill.",
    "Raleigh knew the ring as his wife's. He felt nothing for her death or the theft of her body, he said. Revenge still burned in his dead heart.",
    "The ring was Deliah's. Her husband felt no grief, only a desire for revenge.")
Q(530, "A Husband's Revenge", "Silverpine Forest", 20, HR,
    "Raleigh named his old friend Valdred as Deliah's murderer, and wanted his hands. Valdred had last been seen at the Greymane Wall, trying to flee into Gilneas.",
    "Raleigh could not grieve, but he could want revenge. Valdred, the friend who had killed Deliah, was somewhere near the Greymane Wall in southern Silverpine.",
    "Raleigh took the hands that had killed his wife and gave back Deliah's ring, a bauble he no longer cared to keep. The hands he kept, to remember his friend's betrayal.",
    "Raleigh had his revenge for Deliah's murder. The ring went back to the one who had found it, and the hands stayed with him.")
Q(264, "Until Death Do Us Part", "Silverpine Forest", 15, "horde_forsaken",
    "A Forsaken widow wanted a pendant left on the grave of the husband whose crusade had taken him from his family.",
    "The abandoned keepsake was bound for a neglected tomb at the Sepulcher.",
    "The pendant was placed on the grave, its gemstone appearing to lose its sheen.",
    "The keepsake lay on the coffin's carved hands, completing the widow's request.")
Q(460, "Resting in Pieces", "Silverpine Forest", 17, HF,
    "Alaric had been Thule's head servant. Thule's spell had given him an unlife he could not escape. Then Thule beheaded him and gave the head to the Rot Hides as a plaything.",
    "Alaric's head wanted to be taken to his body, buried in an unmarked grave near the stable of Fenris Keep.",
    "The grave by the stable had been dug in haste, but Alaric's body was there. He had feared the gnolls had destroyed it.",
    "Alaric thanked his rescuer at the hasty grave near Fenris Keep's stable. His body had survived the gnolls.")
Q(461, "The Hidden Niche", "Silverpine Forest", 18, HF,
    "Alaric knew a hidden alcove in the southwestern tower of Fenris Keep, behind a dusty shelf. It held something dear to Thule and his old colleagues.",
    "Alaric wanted to be carried to the hidden niche inside Fenris Keep. His boots could stay behind, since they had never fit.",
    "The alcove opened, and Alaric asked to be left there and shut in tight against the Rot Hides. He gave a reward for the help.",
    "Alaric rested at last within the walls of Fenris Keep, in the niche behind the dusty shelf.")
Q(491, "Wand to Bethor", "Undercity", 18, HF,
    "Thule and two friends had once woven a wand from their apprentice wands. Thule came to despise it but could not part with it, so he hid it in Fenris Keep.",
    "Alaric gave up the Woven Wand for Bethor Iceshard, one of the friends who had made it.",
    "Bethor had thought the Woven Wand lost when Thule sided with the Lich King. Thule had never invoked its power, he said, or he would have sensed it.",
    "The Woven Wand came back to Bethor Iceshard, who called it a marvelous find.")
Q(452, "Pyrewood Ambush", "Silverpine Forest", 15, HA,
    "A Forsaken operative hoped killing the Pyrewood Council would weaken Arugal's hold over the town.",
    "The council was expected back while Arugal attended to other business in the keep.",
    "The council was killed, but control of Pyrewood remained an ambition rather than an accomplished result.",
    "The ambush removed the council without establishing that the townsfolk had turned against Arugal.")
Q(516, "Beren's Peril", "Silverpine Forest", 21, HS,
    "Shadow Priest Allister had only scattered reports of undead preparing to attack the Forsaken. The trail led to Beren's Peril, a cave near the Dalaran wizards in Silverpine's hills.",
    "A cave called Beren's Peril concealed Ravenclaw undead. Shadow Priest Allister wanted them struck first, before the attack his scouts had warned of.",
    "Ravenclaw drudgers and guardians were slain in the cave. Allister praised the scouts whose reports had led to their hiding place.",
    "At Beren's Peril the Ravenclaw drudgers and guardians died in their cave. Allister hoped more such reports would help drive the Scourge from Forsaken lands.")
Q(493, "Journey to Hillsbrad Foothills", "Hillsbrad Foothills", 20, "horde_apothecary",
    "The Dark Lady was pressing the Royal Apothecary Society hard for a New Plague. Apothecary Renferrel believed that sharing findings would bring it sooner. His latest work was for Apothecary Lydon in {p:Tarren Mill}, a long way south by the roads and the signposts.",
    "Renferrel's findings on the New Plague were bound for Lydon in Tarren Mill, a small town in the Hillsbrad Foothills. The journey was a long one, he warned, and the signs along the roads would show the way.",
    "Lydon called the findings most excellent. Renferrel had his utmost respect, he said, and he was anxious to study the work.",
    "Renferrel's research reached Lydon in Tarren Mill, who spoke of his colleague with respect and could not wait to read it.")

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
    "Apothecary Renferrel had sent a summons about the wolf hearts brought to him earlier.",
    "While the Deathstalkers were being helped, Renferrel asked to talk again about the hearts he had received.",
    "Renferrel said a matter concerning the wolf hearts demanded attention.",
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
    "Gordon Wendham read the Sepulcher's order in the Trade Quarter and called it an honor to serve those who served the Dark Lady.")
Q(6322, "Michael Garrett", "Undercity", 10, "horde_trade",
    "Gordon Wendham packed the Sepulcher's weapons into a crate. The Undercity's bat master, Michael Garrett, could send it to Silverpine.",
    "The crate of weapons from the Trade Quarter needed a bat to the Sepulcher.",
    "Michael Garrett said the crate could reach the Sepulcher easily, since his bats flew there daily.",
    "The Undercity's bat master took charge of the Sepulcher's crate. His bats made the flight every day.")
Q(6324, "Return to Podrig", "Silverpine Forest", 10, "horde_trade",
    "A bat from the Undercity could carry the crate of weapons back to Karos Razok at the Sepulcher.",
    "The weapons from the Undercity still had to reach Deathguard Podrig in Silverpine.",
    "Podrig received the weapons. The Deathguards would not be caught unprepared.",
    "Podrig had his weapons. The Deathguards would not be caught unprepared, he said, and the Dark Lady was well served.")
Q(477, "Border Crossings", "Silverpine Forest", 14, HM,
    "Ambermill remained a center of human opposition, backed by the wizards of Dalaran. Shadow Priest Allister wanted to know why Dalaran cared about a backwater village.",
    "Dalaran had been shipping crates by wagon from Hillsbrad to a small camp north of Pyrewood Village. Shadow Priest Allister wanted one of them opened.",
    "The crate held yellowed maps of Silverpine and western Lordaeron, and beneath them a pendant that looked magical.",
    "Inside the Dalaran crate lay old maps of western Lordaeron and a mysterious pendant.")
Q(478, "Maps and Runes", "Silverpine Forest", 14, HM,
    "The pendant from the Dalaran crate was taken before the lid went back on. Shadow Priest Allister was waiting for anything useful.",
    "The maps and the strange pendant from the wizards' supplies were bound for Shadow Priest Allister at the Sepulcher.",
    "Allister found the maps and pendant interesting, but the wizards' aim was still hidden from him. Dalar, he thought, might know more.",
    "Allister called the pendant interesting. Dalaran plainly wanted Ambermill for something, and he thought Dalar might know what the pendant was for.")
Q(481, "Dalar's Analysis", "Silverpine Forest", 14, HM,
    "Shadow Priest Allister hoped Dalar Dawnweaver could make sense of the pendant from the Dalaran crate.",
    "The pendant went to Dalar Dawnweaver, the Forsaken mage at the Sepulcher, for study.",
    "Dalar recognized a Kirin Tor artifact used by powerful wizards to channel magic. So many sent to Ambermill meant a project of some size, and he set out to pierce their shields.",
    "Dalar called the pendant more Kirin Tor machinations, and meant to learn what the wizards intended.")
Q(482, "Dalaran's Intentions", "Silverpine Forest", 14, HM,
    "Dalar remembered that the Kirin Tor had marked Ambermill for its dormant ley energy node. The wizards meant to wake it and use its power.",
    "Waking Ambermill's ley node would take great power, and taking the pendants could stall it. Dalar sent the warning to Allister.",
    "Allister trusted Dalar's judgment and agreed they had to move quickly. Until a plan was ready, the wizards' progress had to be delayed.",
    "Allister called it ill news and had no reason to doubt Dalar. He would confer on an attack; meanwhile the wizards had to be slowed.")
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
    "With the archmage dead and his staff in Allister's hands, the wizards' magic dissipated and the ley energies sank back to sleep.",
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

-- Quests recorded in the beta test journals that still had no
-- scene (Migration/ancestor-journals-20261105), plus Forever's Camping 101
-- family. Camping titles repeat across professions, races and zones, so they
-- stay title contexts with no zone or thread; each names only its own fixture.
Q(91921, "Return to Quinn (Again)", "Silverpine Forest", 11, HS,
    "Renferrel had a new potion for Quinn's recovery, made, he said, with love extracted from six whole hearts.",
    "Quinn Yorick was still waiting at the farm for a remedy. Apothecary Renferrel sent a new potion and asked to be excused from the visitor's company.",
    "Quinn drank the new potion and felt it working. He had begun to come to terms with turning into a ghoul, and now expected to travel soon.",
    "The potion reached Quinn, who thanked the courier for a great favor and expected to be on his feet before long.")
Q(5761, "Slaying the Beast", "Orgrimmar", 16, "horde_blade",
    "The Searing Blade made its home in Ragefire Chasm, secretly working to subvert members of the Horde. Its leader was a felguard, Taragaman the Hungerer.",
    "Rooting out the demonic influence in the Warchief's city meant killing Taragaman the Hungerer, who led the Searing Blade in Ragefire Chasm.",
    "Taragaman the Hungerer was dead, and his heart proved it. Thrall would hear of the victory.",
    "The felguard's heart came out of Ragefire Chasm to be dealt with properly, and Thrall was to hear of the kill.")
pack.questIDs[5761].importance = 5
pack.questIDs[91921].highlight = {"Renferrel's second potion, made with love extracted from six whole hearts, reached Quinn Yorick. Quinn had been coming to terms with turning into a ghoul, and now expected to travel soon.", "Quinn Yorick drank Renferrel's new potion at the farm and felt it working."}
pack.questIDs[5761].highlight = {"Taragaman the Hungerer, the felguard who led the Searing Blade in Ragefire Chasm, was slain. His heart was handed over, and Thrall was to hear of it.", "The Searing Blade lost its felguard master, Taragaman the Hungerer, deep in Ragefire Chasm."}
local camping = {
    {"Cooking", "Every camp began with a cook and a campfire, the camping teacher said.", "Cooking was the foundation of a camp, more than a way to make tasty food.", "A campfire could now be built anywhere in the wilds, the first piece of any camp.", "The first camping lesson was a plain campfire.", "#96626, #96629"},
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
    "High Executor Darthalia of Tarren Mill demanded that recruits stand at attention. Under Varimathras's command she meant to quell the humans until the apothecaries had their new plague. The first assignment was the northernmost farms of Hillsbrad Fields, where Farmer Ray and Farmer Getz were to be executed with their workers.",
    "The town of Hillsbrad was vulnerable, Darthalia's information said. Its food supply came first, and the orders named the two landowners of the northern farms, Ray and Getz.",
    "Darthalia put the recruit at ease. Her sources said the fighting on the Hillsbrad front had gone well.",
    "The northern farms had been raided and their owners were dead. Darthalia's sources had already told her so before the report came in.", nil, true)
Q(528, "Battle of Hillsbrad", "Hillsbrad Foothills", 25, HB,
    "Word of the attack on the northern farms had the townsfolk of Hillsbrad panicked, which pleased Darthalia. Her Deathstalkers reported peasants fleeing into the orchards of the southern fields, thinking they could hide there.",
    "The peasants of Hillsbrad had run for the orchards. Darthalia ordered them found and killed in the Dark Lady's name, and told the recruit to quit dawdling in Tarren Mill.",
    "The grip of death was tightening on the town of Hillsbrad, Darthalia said. The battle went well.",
    "The peasants hiding in the southern fields were dead. Darthalia spoke of a town with death's grip closing round it.", nil, true)
Q(529, "Battle of Hillsbrad", "Hillsbrad Foothills", 26, HB,
    "Blacksmith Verringtan was arming the townsfolk of Hillsbrad, and Darthalia blamed him for a resistance harder than she had expected. He and his apprentices were to die, and a shipment of their iron was to come back for the day Tarren Mill razed Southshore.",
    "Every supply line into Hillsbrad was to be cut, starting with Blacksmith Verringtan's forge. Darthalia wanted the smith, his apprentices and his iron.",
    "Darthalia called the mission accomplished, and skillfully carried out at that. The iron from Verringtan's stockpile was hers.",
    "Verringtan and his apprentices were dead and their iron was Darthalia's. She allowed that the work had been done with skill.", nil, true)
Q(532, "Battle of Hillsbrad", "Hillsbrad Foothills", 26, HB,
    "Hillsbrad was in disarray, but its people still rallied around Magistrate Burnside and the town council. Darthalia ordered the leaders killed, the Hillsbrad Proclamation destroyed and the town registry stolen.",
    "Darthalia meant to persist until the humans were wiped from the foothills. The magistrate, the council, their revered proclamation and their registry were the next targets.",
    "News of the strike on Hillsbrad's leadership had traveled fast. Darthalia said the work was well done.",
    "Magistrate Burnside and the council were dead, the proclamation destroyed and the registry in Darthalia's hands. She had heard of it before the report arrived.", nil, true)
Q(539, "Battle of Hillsbrad", "Hillsbrad Foothills", 28, HB,
    "The stolen registry showed the Azurelode Mine south of Hillsbrad under Alliance control and supplying iron to its armories. Darthalia sent for the death of Foreman Bonds and his miners as a message to the Alliance.",
    "Hillsbrad had taken a decisive blow, but the Alliance still guarded the Azurelode Mine. Darthalia wanted its foreman, a human named Bonds, and his miners dead.",
    "Darthalia expected the Dark Lady to be pleased with a new mine to arm her soldiers from.",
    "Bonds and his miners were dead in the Azurelode Mine. Darthalia already counted its ore as the Dark Lady's.", nil, true)
Q(541, "Battle of Hillsbrad", "Hillsbrad Foothills", 30, HB,
    "Dwarves were helping the humans, and Darthalia cursed them as filthy little beasts. Their barracks in southeastern Hillsbrad, {p:Dun Garok} along Thoradin's Wall, was the battle's final mission, and Captain Ironhill its leader had to die.",
    "Darthalia meant to test the strength of the Alliance at Dun Garok. If the dwarves felt the Forsaken's wrath, she thought, they would be less eager to help Hillsbrad.",
    "Darthalia judged the fighting at Dun Garok worthy of the highest praise.",
    "Captain Ironhill was dead in his barracks. Darthalia gave the highest praise she had.", nil, true)
Q(550, "Battle of Hillsbrad", "Undercity", 32, HB,
    "Darthalia had written a sealed commendation extolling the valor shown in the Battle of Hillsbrad. It was for Varimathras in the {p:Undercity}, to be carried with pride.",
    "The high command was to hear of the Battle of Hillsbrad. Darthalia's commendation went under seal to Varimathras.",
    "Varimathras had already heard of the decisive blow struck in the Hillsbrad Foothills. The Scourge from the north remained the primary threat, he said, but the humans could fall, and this proved it. He saw a future in the Dark Lady's ranks for such leadership.",
    "In the Undercity, Varimathras received Darthalia's commendation and said word of the exploits had traveled quickly. The human problem still impeded his plans, but the humans could be made to fall.", nil, true)
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
    "Darsok called his helper a regular lucky rabbit's foot and had one more errand. The harpies of the Barrens came from Stonetalon, far to the northwest. His old friend Jin'Zil, a witch doctor, lived there and would be glad to hear that Serena Bloodfeather was dead.",
    "Serena Bloodfeather's death was news worth carrying to {p:Stonetalon}. Darsok's letter was for Jin'Zil, an old friend of his, and he thought the mountains would prove interesting.",
    "Jin'Zil read Darsok's letter and said he had not heard from him in many years. So the last of the Bloodfeathers were dead. He remembered his friend Rokhan going with a crazy mok'nathal to kill her older sister, and wished he were young again.",
    "At Malaka'jin, Jin'Zil had a letter from a friend he had not heard from in many years. The news of Serena Bloodfeather set him remembering Rokhan and the hunt for her older sister.")
Q(1061, "The Spirits of Stonetalon", "Stonetalon Mountains", 17, HT,
    "The spirits of the Stonetalon Mountains were angry, for goblins and their servants were plundering and burning the land. Seereth Stonebreak, a promising shaman of the Horde, had been sent there and asked for aid.",
    "Those who listened for such things had heard the land of Stonetalon cry out. Seereth Stonebreak was camped near the Greatwood Vale, at the end of the road west from the Crossroads, with reports of massive deforestation.",
    "Seereth called the arrival very good. The plunderers of Stonetalon would take some dealing with, she said, and she would need every skill on hand.",
    "At her camp near the Greatwood Vale, Seereth Stonebreak said the newcomer's skills would be needed against the goblins.")
Q(1062, "Goblin Invaders", "Stonetalon Mountains", 19, HT,
    "The goblin-run Venture Company had moved into Stonetalon, felling trees and burning whole stretches of forest. The spirits of the place were nearly blind with pain and rage. Seereth wanted the goblins in {p:Windshear Crag} shown the Horde's answer in the language they understood best.",
    "Beyond the Greatwood Vale, in Windshear Crag, the Venture Company's goblins and their servants were at work. Seereth sent violence, since that was the language they understood.",
    "Seereth called it bravely done. Ridding the Venture Company of its workers was a good first move, she said. Calming the spirits might still take the wisdom of the tauren elders.",
    "The goblins of Windshear Crag had paid for the burning. Seereth counted it a first move, and looked to the elders of the tauren for the spirits' sake.")
Q(1063, "The Elder Crone", "Thunder Bluff", 18, HT,
    "To truly tend the spirits of Stonetalon, Seereth said, the tauren elders had to be consulted. She knew one name, Magatha, who was very old and knew much, and who lived on {p:Elder Rise} in Thunder Bluff.",
    "Seereth did not know many of the tauren leaders by name. Magatha of Elder Rise she knew, and believed that if anyone could marshal spiritual aid for Stonetalon, it was she.",
    "Magatha greeted the visitor on Elder Rise and asked whether counsel was what was wanted.",
    "On Elder Rise, Magatha received the plea from Stonetalon with a greeting and a question about counsel.")
Q(1064, "Forsaken Aid", "Thunder Bluff", 18, HT,
    "Magatha grieved for Stonetalon, but said the disease upon the land had to be removed before it could heal. The Forsaken knew much of disease, and helping would strengthen the trust between the peoples. Apothecary Zamah, their emissary, worked in the {p:Pools of Vision} below the Spirit Rise.",
    "Magatha turned to the Horde's allies for Stonetalon's cure. Apothecary Zamah, a scholar of the Forsaken, kept to the Pools of Vision beneath the Spirit Rise.",
    "Zamah had word from Magatha already. Her heart no longer beat, she said, but she felt sorrow for the spirits of Stonetalon, and the Forsaken were eager to help.",
    "In the Pools of Vision, Apothecary Zamah offered what help the Forsaken could give. Magatha had sent word ahead of the visit.")
Q(1065, "Journey to Tarren Mill", "Hillsbrad Foothills", 18, HT,
    "Zamah proposed extreme measures against the Venture Company, but without bloodshed. Her colleague Lydon in {p:Tarren Mill}, in the distant land of Lordaeron, might have the tool, and her note set out what was needed.",
    "The way to Lydon ran by zeppelin to the Undercity, then through Tirisfal and Silverpine to Hillsbrad. Zamah's note explained Stonetalon's needs to him.",
    "Lydon read Zamah's note and said her needs must be great to send word so far. Then he said he knew exactly what to do.",
    "Zamah's note reached Lydon in Tarren Mill. He called it splendid and knew at once how to answer it.")
Q(1066, "Blood of Innocents", "Hillsbrad Foothills", 23, HT,
    "Lydon meant to make a toxin that would bleed the violence out of the Venture Company and leave them weak and docile. It needed the blood of innocents, and the Syndicate's shadow mages in {p:Durnholde Keep} collected exactly that for their own purposes.",
    "The hard ingredient in Lydon's toxin was innocent blood. The shadow mages of the Syndicate at Durnholde Keep had already done the collecting.",
    "Lydon had his blood and was glad the Syndicate's mages had done the difficult work for him. He asked for a moment to create his concoction.",
    "The blood from Durnholde reached Lydon, who hoped the Syndicate had given little trouble. The toxin could be made now.")
Q(1067, "Return to Thunder Bluff", "Thunder Bluff", 23, HT,
    "Lydon's toxin was ready and he was excited to see his work applied in the field. Before anyone used it, Zamah in Thunder Bluff was to devise a delivery method that would make the most of it.",
    "The toxin from Tarren Mill promised favorable, perhaps contagious, results. Zamah was to see to its delivery.",
    "Zamah took the toxin and said that if she knew Lydon, it would be quite effective against the Venture Company.",
    "Lydon's toxin reached Zamah in the Pools of Vision, who expected good results from it.")
Q(1086, "The Flying Machine Airport", "Stonetalon Mountains", 23, HT,
    "The Venture Company had to move messages and light cargo between its headquarters and Stonetalon. Zamah guessed at a small sky port, too small for a zeppelin but enough for a flying machine. The toxin was to be placed there, and then it was time to run.",
    "Zamah's delivery plan rested on a sky port she was not sure existed. If the Venture Company's holdings in Stonetalon had one, the toxin went there.",
    "Zamah was sure the goblins had been surprised by the delivery and hoped the toxin would find its way to their headquarters. She advised ignoring any guilt over poisoning the Venture Company, which in her view deserved far worse.",
    "The sky port existed, and the toxin was placed there. Whether it would reach the goblins' headquarters remained uncertain. Zamah's one piece of Forsaken wisdom was never to shy from dark paths that led to victory.")
Q(4542, "Message to Freewind Post", "Thousand Needles", 25, HN,
    "Brave Moonhorn at the Great Lift had an urgent message for Cliffwatcher Longhorn at {p:Freewind Post}. The centaur had stepped up their attacks. He also advised steering clear of the Grimtotem, who had been acting strangely of late.",
    "The centaur were raiding harder around the Great Lift, and Freewind Post to the southeast had to know at once. Brave Moonhorn's message went by the hand of a traveler.",
    "Longhorn read the message and called it more bad news. The centaur had raided one of his supply caravans and slaughtered the whole party. He swore it would not go unpunished.",
    "At Freewind Post, Cliffwatcher Longhorn took the warning on top of his own loss. A supply caravan of his lay dead to the last tauren, and he wanted it answered.")
Q(4841, "Pacify the Centaur", "Thousand Needles", 25, HN,
    "Longhorn wanted the centaur who had slaughtered his caravan hunted down. Their camp lay north of Freewind Post, and he asked that wrath guide the hand that struck it.",
    "The caravan's dead were to be paid for at the centaur camp north of Freewind Post. Longhorn called it revenge and did not pretend otherwise.",
    "Longhorn paid for the dead centaur out of gratitude, and said so.",
    "The centaur camp north of Freewind had been struck. Cliffwatcher Longhorn gave a reward and his thanks.")
Q(4881, "Assassination Plot", "Thousand Needles", 28, HN,
    "Centaur orders found in the Needles named Kanati Greycloud, the tauren bold enough to set up a hunting camp there. They meant to kill him as a warning to anyone who followed, and to converge at the small post southwest of the Great Lift.",
    "The intercepted plan was plain. The centaur would gather southwest of the Great Lift and kill Kanati Greycloud at his hunting camp.",
    "Kanati heard that they were coming to kill him, and said he would show them how a tauren fights.",
    "The warning reached Kanati Greycloud ahead of the assassins. He meant to meet them as a tauren should.")
Q(4966, "Protect Kanati Greycloud", "Thousand Needles", 28, HN,
    "Kanati thought there might be more centaur than he had reckoned on. He asked for someone to stand beside him against the assassins when they came.",
    "The centaur were on their way to Kanati's camp, and he did not want to face them alone.",
    "Kanati survived the assassins and thanked the help against them. He could not have held them off without it, he said.",
    "The centaur assassins broke against Kanati's camp. He said plainly that he would not have held alone.")
Q(4770, "Homeward Bound", "Thousand Needles", 29, HN,
    "Pao'ka Swiftmountain had come to {p:Highperch} to study the wyverns and got too close to a nest. Chased off and lost, he had hidden for days without a friendly face. Motega at Whitereach Post did not even know he was missing.",
    "A young tauren was hiding among the wyverns of Highperch, sure that Motega would be furious to hear he had gone there alone. Whitereach Post lay just to the east, and he asked to be taken there.",
    "Motega said that had he known Pao'ka meant to snoop around Highperch, he would have chained him to a totem. The boy's father had been reluctant to let him come at all. He paid for the help and hoped it covered any misfortune.",
    "Pao'ka Swiftmountain came home to Whitereach Post. Motega had brought him to the Needles to study its creatures. He swore he would have chained him to a totem sooner than let him go to Highperch.")
Q(4904, "Free at Last", "Thousand Needles", 29, HN,
    "Lakota Windsong had refused Arnak Grimtotem's offer of marriage, and that night he came back for her. Her brother tried to stop him and died for it. She wanted out of Darkcloud Pinnacle and back to Thalia, who she said must be worried sick.",
    "A tauren woman named Lakota was held on Darkcloud Pinnacle by the Grimtotem who had killed her brother and carried her off. Thalia at Freewind Post was waiting for her.",
    "Thalia had known in her bones that Lakota would find her way back. Lakota had told her of the escape, and Thalia gave the belongings of the dead brother in thanks, sure Lakota would want it so.",
    "Lakota came down from Darkcloud Pinnacle to Thalia Amberhide at Freewind Post. The things Thalia gave in thanks had belonged to Lakota's brother.")
Q(5064, "Grimtotem Spying", "Thousand Needles", 28, HN,
    "Three strangers had visited the Grimtotem, and Cliffwatcher Longhorn wanted to know what passed between them. Guarded chests on Darkcloud Pinnacle held their messages.",
    "Cliffwatcher Longhorn had learned of three mysterious visitors to the Grimtotem. Their correspondence lay in separate chests on Darkcloud Pinnacle, beyond the clan's guards.",
    "All three secret notes reached Longhorn. Alarmed by what they contained, he began planning for the danger they foretold.",
    "The messages were recovered from the pinnacle's three chests. Longhorn found their news grave enough to begin preparing for what might come.")
Q(5062, "Sacred Fire", "Thunder Bluff", 27, HK,
    "Arikara was deadly and had to be dealt with swiftly, Motega said. The only way to hunt her was to light the sacred fire of life that summoned her. That took Incendia agave from the Boiling Pool and the enchantment of Magatha Grimtotem on Elder Rise.",
    "The sacred fire of life lay dormant and only one herb could light it. Incendia agave grew at the Boiling Pool northeast of Whitereach, and Magatha in Thunder Bluff could turn it into powder.",
    "Magatha called Motega's news of Arikara grave. She looked about her before she spoke of a creature born only to seek vengeance on those who had committed heinous acts. Then she smiled, took the agave and began to enchant it.",
    "On Elder Rise, Magatha said Arikara came only for the guilty of heinous acts. She took the Incendia agave, the one herb that could light the fire, and set to enchanting it.")
Q(5088, "Arikara", "Thousand Needles", 28, HK,
    "Magatha's purified Incendia powder was to be thrown on the sacred fire of life at Darkcloud Pinnacle. The fire stood on the isolated needle where the tauren buried their dead. She feared Arikara was stalking Cairne Bloodhoof, angered by how much tauren lore had changed, and urged haste.",
    "The enchanted powder would call Arikara to the fire on Darkcloud Pinnacle. Magatha said the serpent might be hunting Cairne himself, and that there was no time to lose.",
    "Arikara was dead, and Motega could not make sense of it. Why would Arikara be after Cairne, he asked, and yet Magatha could not be wrong, being their most powerful shaman. He shook his head and gave a reward for the deed.",
    "Motega rewarded Arikara's death and questioned Magatha's explanation. Nothing in it made sense to him, but he would not call the most powerful shaman of the tauren wrong.")
for _, id in ipairs({1086,4966,4770,4904,5088}) do pack.questIDs[id].importance = 4 end

-- Compact scenes for Mulgore's turning points (overnight 2026-11-05, same sources).
pack.questIDs[757].highlight = {"Bristlebacks from Brambleblade Ravine had ambushed Narache's hunters and stolen from the village. Their belts reached Chief Hawkwind, and the Rite of Strength was passed.", "The first of the Earthmother's rites was won against the Bristleback raiders. Chief Hawkwind said the tribe would be proud."}
pack.questIDs[772].highlight = {"Zarlman's Water of the Seers brought a vision by the tribal fire. Followed to its end, it completed the Rite of Vision.", "Beside the tribal fire, the Water of the Seers raised a vision to follow. At its end the Rite of Vision was passed."}
pack.questIDs[760].highlight = {"The last of Mulgore's poisoned wells, Wildmane, ran clean again. Bloodhoof Village was grateful, and Mull Thunderhorn wished the waters of Mulgore would stay clean forever.", "Mull Thunderhorn's third totem cleansed the Wildmane well north of Thunder Bluff. The goblins' poison was gone from all three wells."}
pack.questIDs[766].highlight = {"Mazzranache, the strider of Maur Raincaller's grandfather's tales, had bitten Maur, and the wound was infected. The remedy's ingredients arrived in time, and Maur said he owed his life.", "Maur Raincaller had met the strider his grandfather fought, and its bite left him with a spreading infection. With a wolf heart, a cougar femur, a scale and a gizzard, he could make his cure."}
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
    ["after"] = {"Thrall called it a first step toward the Shadow Council's destruction and wanted every word Neeru had said.", "Thrall welcomed the first success of the infiltration and asked for the full account."},
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
    ["after"] = {"Thrall promised to send spies to investigate the reported presence in Ashenvale.", "Thrall had heard nothing of the Council in Ashenvale. His spies would look into it, he said, and he would call for that help again soon."},
    ["source"] = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #5730"}
}
pack.questIDs[5730].threadLabel = pack.threads[pack.questIDs[5730].thread]
pack.quests["Burning Shadows"].why = {"A pendant from Skull Rock called for closer examination.", "An unusual object from the cultists prompted an inquiry in Orgrimmar."}
pack.quests["Burning Shadows"].after = {"The pendant from Skull Rock was handed over to be examined.", "The cultists' pendant went to Orgrimmar for study."}
pack.quests["Burning Shadows"].source = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt #832"}

-- Complete short scenes: exact recorded stages only; see editorial-20261016 author packet.
pack.questIDs[1061].highlight = {"Seereth Stonebreak welcomed help at her camp near the Greatwood Vale. Goblin logging had left Stonetalon's spirits crying out, and she had work for every skill.", "Stonetalon's wounded spirits had brought Seereth Stonebreak into the mountains. At her camp, the shaman welcomed help against the goblin loggers."}
pack.questIDs[1062].highlight = {"The strike against the Venture Company's workers earned Seereth's praise. Calming the spirits, she thought, might take the wisdom of the tauren elders.", "Seereth welcomed the losses inflicted on the Venture Company, but looked to the tauren elders for a way to calm Stonetalon's suffering spirits."}

-- Uncovered classic stages in Horde regions (starters3 lane, 2026-11-05):
-- Mankrik's wife (4921; Forever's 95774 continues it in LoreForeverStories.lua),
-- Feegly and the Tear, Tatternack's ore, the oasis shell for Mura, Kadrak's
-- scroll and the Talon Den, Menara Voidrender's Horde referrals (4737, 4739;
-- the Alliance referrals 4736/4738 are left to the class lane), Melor's summons,
-- Falla's Nightmare Shard, Zinge's hearts, Veren Tallstrider's leather and
-- Nefarian's head in Orgrimmar. Givers not named in the quest text (Feegly,
-- Tatternack, Tonga, Kadrak, Jorn, Falla, Veren) come from LoreForever
-- Z_barrens/Z_thunderbluff/Z_undercity entries. Feegly's fate after the Tear
-- is never told: the completion stops at his cry of triumph.
local HMK, HBM, HMV, HNF = "horde_mankrik", "horde_baelmodan", "horde_menara", "horde_blackrock"
pack.threads[HMK] = "Mankrik's search for his wife"
pack.threads[HBM] = "the dwarves' dig at Bael Modan"
pack.threads[HMV] = "Menara Voidrender's students"
pack.threads[HNF] = "the fall of Nefarian"
Q(4921, "Lost in Battle", "The Barrens", 20, HMK,
    "Mankrik and his wife had fought the Bristlebacks at a small tauren camp until they were separated. She held off three of them alone before more came, and Mankrik went down to their numbers.",
    "A tauren druid had found Mankrik fallen on the Gold Road and tended his wounds. He asked for any sign of his wife.",
    "Mankrik heard what had been found of his wife. The pain in his chest had already told him the worst, and he gave his thanks.",
    "The search for Mankrik's wife ended with the news he had feared, and he understood.")
Q(857, "The Tear of the Moons", "The Barrens", 30, HBM,
    "Feegly the Exiled had once held the Tear of the Moons, the first great find of the dig at Bael Modan. General Twinbraid called it cursed, locked it in the keep and drove Feegly off.",
    "Twinbraid had taken the Tear of the Moons from Feegly and banished him from Bael Modan. The exile raved that the relic should have been his, and wanted it stolen back.",
    "Feegly had the Tear of the Moons in his hands again, and cried that its power was his once more.",
    "The Tear left Twinbraid's keep and went back to the exile who craved it.")
Q(1153, "A New Ore Sample", "The Barrens", 29, "horde_roads",
    "Travelers from Thousand Needles had killed a kobold carrying an unusual ore, and would not sell Tatternack Steelforge a sample. He wanted one to examine for the warchief's sake.",
    "The warchief was pleased with Tatternack's work at Camp Taurajo. Before he praised his helper to Thrall, the smith wanted the strange ore of the Thousand Needles kobolds.",
    "Tatternack called it a good sample. The travelers could no longer lord their find over him. If the ore proved strong, a weapon made from it would go to the warchief.",
    "The ore reached Tatternack, who set to work on it at once and promised not to forget the help.")
Q(3301, "Mura Runetotem", "Silverpine Forest", 15, "horde_oases",
    "Tonga Runetotem's clanmate Mura had gone to Silverpine to bring life back to the Forsaken's dying forest. Tonga thought the strange life of the Barrens might help her, and sent her a shell.",
    "A shell from the altered beasts of the Barrens oases was bound for Mura Runetotem at the Sepulcher.",
    "Mura found an inner glow in the shell, as if it still pulsed with life. She meant to study it for a way to aid Silverpine.",
    "The Barrens shell reached Mura at the Sepulcher. She hoped it held a secret that could heal the forest.")
Q(3513, "The Runed Scroll", "The Barrens", 25, "horde_roads",
    "An official-looking scroll wrapped in silvery ribbon might concern the night elves. The outpost near the Ashenvale border to the north was the place to take it.",
    "A scroll tied with silver ribbon looked official. If it involved the night elves, the Horde's watch on the Ashenvale border would want to see it.",
    "Kadrak at Mor'shan Rampart took the scroll and wanted to know where it had been found.",
    "The runed scroll reached the Horde's watch on the Ashenvale border, and Kadrak took it.")
Q(3514, "Horde Presence", "The Barrens", 29, "horde_roads",
    "Kadrak's captured scroll came from Rynthariel, the dryad Keymaster of the Talon Den on Stonetalon Peak. Kadrak wanted her dead and a Horde flag raised in her den.",
    "Rynthariel's outrunners had been crossing Horde ground. Kadrak meant a flag in the Talon Den to warn her people off sending another messenger through the Barrens.",
    "Rynthariel was dead and the Horde flag stood in the Talon Den. Her people would be slow to regroup, Kadrak said, and fewer Alliance runners would cross the Barrens.",
    "With the Keymaster dead and the flag raised, Kadrak expected the Alliance to think again before sending a messenger his way.")
Q(4737, "In Search of Menara Voidrender", "The Barrens", 31, HMV,
    "Zevrost in Orgrimmar warned that the hunger for power ended in slavery to what one sought to master. Still, he passed on word that Menara Voidrender in Ratchet would make tools for those seeking power.",
    "Zevrost in Orgrimmar had little patience for ambition, but not all agreed with him. Menara Voidrender, in a tower above Ratchet, was taking students.",
    "Menara was pleased that Zevrost's word had reached so far. Those of her kind banded together whatever their race, she said, and she offered to help make tools for their craft.",
    "In Strahad Farsan's tower above Ratchet, Menara Voidrender greeted the student Zevrost had sent and offered her help.", nil, true)
Q(4739, "In Search of Menara Voidrender", "The Barrens", 31, HMV,
    "Kaal Soulreaper in the Undercity saw a new confidence in a student. Menara Voidrender tutored younger students in Strahad's tower above Ratchet, and gave gifts to those who passed her tests.",
    "Kaal Soulreaper judged a student ready, and sent word of Menara Voidrender, who taught the arcane in a tower above Ratchet.",
    "Menara was pleased that Kaal's word had reached so far. Her kind had to band together whatever their race, she said. The beings they dealt with showed no mercy to those who failed to control them.",
    "Menara Voidrender greeted Kaal's student in the tower above Ratchet and offered help in making tools of power.", nil, true)
Fallback("In Search of Menara Voidrender", HMV,
    "Menara Voidrender, in Strahad Farsan's tower above Ratchet, was said to teach students who were ready.",
    "Word came of Menara Voidrender, who made tools of power for students who passed her tests.",
    "Menara Voidrender received another student in her tower above Ratchet.",
    "In the tower above Ratchet, Menara Voidrender offered to help make tools of power.", {V .. " #4736, #4737, #4738, #4739"})
Q(1130, "Melor Sends Word", "Thunder Bluff", 30, "horde_hunts",
    "Melor Stonehoof had heard of deeds done in the Barrens, Jorn Skyseer said. He had set a path for whoever had done them. Melor waited on Hunter's Rise in Thunder Bluff.",
    "Melor Stonehoof of Hunter's Rise had a path in mind for those who proved themselves, and Jorn Skyseer sent the summons on.",
    "Melor asked whether the one he had summoned was ready to journey through distant lands.",
    "Melor Stonehoof, on Hunter's Rise, had distant lands in mind for the traveler Jorn Skyseer had sent.")
Q(3369, "In Nightmares", "Thunder Bluff", 25, "horde_oases",
    "Falla Sagewind saw the pure essence of the Emerald Dream in a shard, and in it a vision more like a nightmare. She would say no more, and wanted it in a wise druid's hands soon.",
    "Falla Sagewind sent the troubling shard to Hamuul Runetotem on Elder Rise in Thunder Bluff. She would not say what she had seen in it.",
    "Hamuul peered into the shard and faltered. Things in the Emerald Dream were not as the druids had thought, he said. Such matters were not to be spoken of.",
    "The shard reached Hamuul Runetotem, who advised against talking about what it held.", nil, true)
Q(1359, "Zinge's Delivery", "Undercity", 15, "horde_apothecary",
    "Renferrel had found a toxin in the wolf hearts that should have killed the wolves themselves. He kept samples for his colleague, Apothecary Zinge in the Undercity.",
    "The wolf hearts from Silverpine held a poison unlike any in similar beasts. Renferrel wanted the Royal Apothecary Society to study it.",
    "Zinge took the heart samples eagerly. New toxins were always of interest to the Royal Apothecary Society.",
    "Renferrel's heart samples reached Apothecary Zinge, who was eager to experiment with them.")
Q(768, "Gathering Leather", "Thunder Bluff", 8, "horde_trade",
    "Veren Tallstrider made clothes and armor from beast skins for the people of Thunder Bluff. He traded his work for hides from the hunt.",
    "The leatherworker Veren Tallstrider would fashion something in trade for skins from the plains.",
    "Veren judged the skins very nice pieces that would make fine leather goods, and gave something of his own in trade.",
    "The skins went to Veren Tallstrider's work for Thunder Bluff, and he paid with a piece of his craft.")
Q(769, "Kodo Hide Bag", "Thunder Bluff", 10, "horde_trade",
    "Veren Tallstrider would teach the making of a Kodo Hide Bag to a leatherworker who brought supplies for his trade. The kodo's strength was much respected among the tauren.",
    "The kodo beasts of Mulgore were strong and sturdy. Veren Tallstrider shared the bag's pattern only with leatherworkers who brought supplies for his trade.",
    "Veren took the supplies and taught the pattern. His heart swelled, he said, to see the young take up leatherworking.",
    "Veren Tallstrider passed on the Kodo Hide Bag pattern, proud to see youths interested in the craft.")
Q(7783, "The Lord of Blackrock", "Orgrimmar", 60, HNF,
    "The battle-scarred head of Nefarian was a prize for the warchief in Orgrimmar.",
    "Nefarian's head was to go to Thrall, who wished he could have seen the beast's face at the killing blow.",
    "Thrall said the Horde had been honored once more. The son of Deathwing lay dead, and surely the evil one stirred.",
    "Thrall took Nefarian's head as an honor to the Horde and a warning that the evil one surely stirred.", nil, true)
Q(7784, "The Lord of Blackrock", "Orgrimmar", 60, HNF,
    "Thrall sent the bearers of Nefarian's head to High Overlord Saurfang in the Valley of Strength.",
    "In the Valley of Strength, High Overlord Saurfang waited to mount the dragon's head.",
    "Saurfang offered a reward and mounted Nefarian's head for all of Orgrimmar to see.",
    "The head of the beast went up in the Valley of Strength, where all could see it.", nil, true)
for _, id in ipairs({4921, 3514, 3369}) do pack.questIDs[id].importance = 4 end
for _, id in ipairs({7783, 7784}) do pack.questIDs[id].importance = 6 end
pack.questIDs[857].importance = 4
pack.questIDs[4921].highlight = {"Mankrik's wife had held off three Bristlebacks alone before she was overwhelmed. The search for her ended with the news he had feared.", "Mankrik had asked for any sign of his wife after the Bristleback attack. He understood what was found, and gave his thanks."}
pack.questIDs[3514].highlight = {"Rynthariel, the dryad Keymaster of the Talon Den, was dead, and a Horde flag stood in her den. Kadrak expected fewer Alliance runners in the Barrens.", "Kadrak's flag went up in the Talon Den over the dead Keymaster, a warning to the Alliance's messengers."}
pack.questIDs[3369].highlight = {"Hamuul Runetotem looked into Falla Sagewind's shard and faltered. Things in the Emerald Dream were not as the druids had thought.", "Falla Sagewind's shard reached Hamuul Runetotem on Elder Rise, who advised keeping quiet about what it held."}
pack.questIDs[7783].highlight = {"Nefarian's head reached Thrall in Orgrimmar. The son of Deathwing lay dead, and Thrall said the Horde had been honored once more.", "Thrall received the head of Nefarian, and warned that the evil one surely stirred."}
pack.questIDs[7784].highlight = {"Saurfang mounted Nefarian's head in the Valley of Strength for all of Orgrimmar to see.", "High Overlord Saurfang put the head of Nefarian up in the Valley of Strength."}
pack.questIDs[857].highlight = {"Feegly the Exiled had the Tear of the Moons back from Twinbraid's keep, and cried that its power was his again.", "Feegly the Exiled took back the relic General Twinbraid had called cursed."}

-- Band 20-30 pass (2026-11-06, tests/Band2030.lua): Makaba's village and the
-- Grimtotem, Sun Rock Retreat's healing and bounties, Goggeroc, Braelyn's hunt
-- for Ordanus, the Ashenvale Hunt's call, Zoram'gar and Splintertree, Ratchet's
-- tubers and eggs, the Book of Ur, Wizlo's gizmo. Quest text by ID; NPCs and
-- places checked against Interface/AddOns/LoreForever/Data (facts only).
pack.threads.horde_flathoof = "the Grimtotem raid on Makaba's village"
pack.threads.horde_sunrock = "the healing of Stonetalon from Sun Rock Retreat"
pack.threads.horde_braelyn = "Braelyn Firehand's hunt for Ordanus"
pack.threads.horde_zoramgar = "the Horde's foothold at Zoram'gar"
pack.threads.horde_warsong = "the Horde's lumber camps in Ashenvale"
local HFH, HSR, HBF, HZG, HWS = "horde_flathoof", "horde_sunrock", "horde_braelyn", "horde_zoramgar", "horde_warsong"
local STM, ASH = "Stonetalon Mountains", "Ashenvale"
Q(6401, "Kaya's Alive", STM, 18, HFH,
    "Makaba Flathoof had word that his daughter Kaya was alive after the Grimtotem attack on their village, when all had thought her lost. Her aunt, Tammra Windfield, waited at {p:Sun Rock Retreat} along the path to the west and had to hear it.",
    "Kaya Flathoof was alive. Her father wanted the good news carried west to her aunt Tammra at Sun Rock Retreat.",
    "Tammra Windfield heard that her niece Kaya was alive. That was good news indeed, she said.",
    "At Sun Rock Retreat, Tammra heard that Kaya had survived the Grimtotem and gave her thanks for the news.")
Q(6523, "Protect Kaya", STM, 18, HFH,
    "Kaya Flathoof was free of the Grimtotem who had held her and wanted away before they noticed. She asked for an escort to Camp Aparaje, from where she knew her own way. Her father Makaba would be desperate to know she was safe.",
    "The Grimtotem had taken Kaya Flathoof from her village and would not be long in missing her. The trail to Camp Aparaje was the dangerous part.",
    "Kaya was alive, and Makaba Flathoof had the rescuer of his daughter to thank for it.",
    "Kaya reached Camp Aparaje and the news reached her father. Makaba Flathoof gave his thanks for her rescue.")
Q(6548, "Avenge My Village", STM, 18, HFH,
    "The Grimtotem had raided Makaba Flathoof's village and killed nearly everyone in it. He had killed all he could and barely escaped with his life, and now he wished only that more of them were dead. They were just to the west.",
    "Makaba Flathoof was the survivor of a massacre. He asked for Grimtotem blood from the camp west of where he stood.",
    "Makaba gave his thanks for the dead Grimtotem. He would never forget, he said, what they had done to his village.",
    "More Grimtotem lay dead to the west. Makaba said their deaths would never make him forget his village.")
Q(6629, "Kill Grundig Darkcloud", STM, 18, HFH,
    "Grundig Darkcloud and his personal band of brutes were the worst of the Grimtotem, Makaba said. It was Grundig who had led the attack on his village, and he camped at Grimtotem Post further up the path to the west.",
    "The one who had led the raid on Makaba's village had a name, Grundig Darkcloud, and a camp at Grimtotem Post. Makaba asked for his death, if anyone dared.",
    "Grundig Darkcloud was dead. Makaba Flathoof said he would always be grateful for what had been done that day.",
    "The leader of the raid died at Grimtotem Post among his brutes. Makaba's gratitude, he said, would last.")
Q(6421, "Boulderslide Ravine", STM, 18, HSR,
    "Mor'rogal at Sun Rock Retreat felt something amiss in Stonetalon. In a deep cave in Boulderslide Ravine to the southeast, kobolds were frantically mining a rare crystal called Resonite. He wanted ore samples and a look at the bottom of the cave.",
    "The kobolds of Boulderslide Ravine were digging for Resonite as if their lives depended on it. Mor'rogal needed to know what lay under the mountains before he could say what evil it was.",
    "The ore told Mor'rogal what he had half remembered. Resonite carried a trace of Earthen magic, and the kobolds must have dug deep enough to uncover one of the Earthen. The Titans had made those creatures to shape the land itself. He shook his head and thought he might enchant the samples against the kobolds' plot.",
    "Mor'rogal had his answer at last. The kobolds had dug up an Earthen, one of the Titans' shapers of the land. He meant to enchant the Resonite samples and turn them against the kobolds' plot.")
Q(6481, "Earthen Arise", STM, 20, HSR,
    "The Resonite cask in the kobolds' cave housed a slumbering Earthen named Goggeroc, Mor'rogal said. He had changed the mixture of the crystals with his shamanistic powers, and the enchanted Resonite would smash the cask open. Goggeroc would wake weak from his long sleep, and that was the moment to kill him.",
    "Mor'rogal feared that all of Stonetalon would be lost if the Earthen in the cask woke in his full strength. The enchanted crystal would rouse Goggeroc weak, and the killing had to follow at once.",
    "Mor'rogal called the news good and the deed a hero's. He feared what an Earthen loose in Kalimdor would have meant, and said all of Stonetalon and Kalimdor stood in debt.",
    "Goggeroc was dead in Boulderslide Ravine before his strength returned. Mor'rogal spoke of a debt owed by the whole of Kalimdor and gave a reward to the most honored one.")
Q(6461, "Blood Feeders", STM, 19, HSR,
    "The trolls of Malaka'jin had prospered on Stonetalon's hunting. Lately the spiders of the mountains had come raiding their camps at night to steal the kill. Xen'Zilla asked for the hairy blood feeders thinned, starting just north of the camp.",
    "Spiders were everywhere in Stonetalon, Xen'Zilla said, and he did not walk about at night because of them. Malaka'jin would be in the debt of anyone who killed a few.",
    "Sweet, Xen'Zilla said. With luck there would be fewer unwanted dinner guests that night, and Malaka'jin was forever in debt.",
    "The spiders north of Malaka'jin were fewer. Xen'Zilla hoped for a quiet night and spoke of a debt the trolls would remember.")
Q(6301, "Cycle of Rebirth", STM, 23, HSR,
    "Industrial greed and endless war had wrecked Stonetalon, Tammra Windfield said, and only the Earthmother's blessing could heal such injury. She asked for Gaea seeds, which grew only here, at the water's edge of Mirkfallon Lake north of Sun Rock Retreat.",
    "Tammra meant to speed the cycle of rebirth with shamanistic power. For that she needed the Gaea seeds that grew along Mirkfallon Lake.",
    "Tammra took the Gaea seeds and blessed them. Under the Earthmother's blessing, she said, even these small kernels of life would bloom and flourish.",
    "The Gaea seeds from Mirkfallon Lake went into Tammra's hands and took the Earthmother's blessing.")
Q(6381, "New Life", STM, 25, HSR,
    "Tammra's enchanted Gaea seeds were for the center of the destruction, the {p:Charred Vale} to the west. Harpies and angry fire elementals still plagued the scarred land there. The seeds were to be planted in whatever fertile mounds of soil remained.",
    "The cycle of life had to be helped along, Tammra said. The blessed seeds went west into the Charred Vale, to be planted among harpies and fire spirits.",
    "Tammra called it a great victory for the land. In time, she said, the Venture Company would pack up its buzz saws and axes. The fire spirits would calm, and the land would push the harpies out. Only then would Stonetalon be truly at peace.",
    "The Gaea seeds were in the ground of the Charred Vale. Tammra spoke of the forest that would one day stand there again, and of the peace that would come with it.")
Q(6393, "Elemental War", STM, 25, HSR,
    "Tsunaman at Sun Rock Retreat had been sent by the Tribunal of the Tides to wage war on the fire elementals of Stonetalon. Neptulon the Tidehunter himself wished them extinguished. The Incendrites they left behind in the Charred Vale would win Tsunaman favor with the Tribunal.",
    "The war between water and fire had raged across all dimensions for eons, Tsunaman said. The fire elementals of the Charred Vale were its latest front, and their Incendrites were wanted as proof.",
    "The water spirits within him bubbled with excitement, Tsunaman said. The Incendrites meant a glorious victory to report to the Tribunal of the Tides.",
    "Tsunaman had his Incendrites from the Charred Vale, and a glorious victory to report to the Tribunal of the Tides.")
Q(6282, "Harpies Threaten", STM, 26, HSR,
    "Maggran Earthbinder of Sun Rock Retreat called the tauren the protectors of the land, and the harpies in Stonetalon alarmed him. The Bloodfuries of the Charred Vale were the source of the harpies spreading across Kalimdor, and he wanted them culled.",
    "The Bloodfury harpies held the Charred Vale and kept the innocent from leaving their boundaries. Maggran asked for a cull.",
    "Maggran called it most excellent news and wanted to hear again how fear had been cast into the harpies' cold hearts. The Bloodfuries had been dealt a serious blow.",
    "The Bloodfuries had lost many in the Charred Vale, and Maggran asked to hear the account again.")
Q(6283, "Bloodfury Bloodline", STM, 26, HSR,
    "Culling the Bloodfuries would not be enough, Maggran said. Their queen in all but name, Bloodfury Ripper, roosted along the western hills of the Charred Vale. Only her death, he said, would truly thin the harpies.",
    "Maggran wanted the Bloodfury bloodline cut at its head. Bloodfury Ripper would not be easy to kill, he warned, but the reward would be great.",
    "Maggran felt the anger leave him and did not know what he would do with his time. Knowing evil moved near his land had kept his thoughts moving, and now they were silent. Perhaps, he said, he could focus on the good, as all tauren should.",
    "Bloodfury Ripper was dead on the western hills, and Maggran Earthbinder found himself at a loss without his anger. He thought that might be a good thing.")
Q(6284, "Arachnophobia", STM, 21, HSR,
    "A warning near Sishir Canyon said to enter at one's own risk. Besseleth and her eight-legged children had claimed the canyon, and Maggran Earthbinder at Sun Rock Retreat had put a bounty on her.",
    "Besseleth hunted the Webwinder Path at night with her brood, and Maggran wanted proof of her death. Her fang would do.",
    "Maggran called it good hunting and would not miss Besseleth, an old predator in those parts. With her gone, he hoped, more travelers would reach Sun Rock Retreat without fearing the dark.",
    "Besseleth's fang reached Maggran, who named the hunter the forest champion and paid the bounty.")
Q(5881, "Calling in the Reserves", "The Barrens", 28, HSR,
    "Maggran had a favor to ask. Grish Longrunner had been guarding the {p:Great Lift} in the southern Barrens a long while and had asked to see his family. Maggran's letter told him a reserve warrior was coming to relieve him.",
    "A letter from Maggran Earthbinder was bound for Grish Longrunner at the Great Lift. The Horde kept its troops fresh, Maggran said, and Grish was due his turn home.",
    "Grish Longrunner read the letter and whooped. He had been guarding that hunk of wood too long, he said, and now he could spend time with his family.",
    "The letter reached Grish at the Great Lift. His relief was coming, and he could visit his family.")
Q(1087, "Cenarius' Legacy", STM, 25, HBF,
    "Braelyn Firehand at Sun Rock Retreat hated Stonetalon. The children of Cenarius and the druids on the peak stifled the flow of magic, she said. Her master in Jaedenar would not let her return until her work was done, and she wanted them culled.",
    "Channeling magic in Stonetalon was like drawing water with a bucket full of holes, Braelyn complained. The keepers and druids of Stonetalon Peak were to blame, and she wanted them dead.",
    "Braelyn felt the power rushing back already and called it sweet. The kaldorei were fools, she said, to spurn magic's burning embrace.",
    "With the peak's druids thinned, Braelyn Firehand spoke of magic flooding back through her veins. Life without it, she said, was a pale mockery.")
Q(1088, "Ordanus", ASH, 29, HBF,
    "Braelyn's true sight had found Keeper Ordanus, one of the eldest sons of the forest god. The druids had spirited him from the peak to the top of a great tree at Raynewood in Ashenvale. She wanted his head and promised a mighty gift for it.",
    "The druids had thought they could hide Ordanus from Braelyn. She saw him at a crossroads in Ashenvale, atop the great tree of Raynewood, and his time was short.",
    "Braelyn had known Ordanus long ago, she said, and he had held himself above even the Highborne. His head did not rise so high now. She gave the reward she had promised.",
    "Ordanus's head reached Braelyn Firehand at Sun Rock Retreat. She remembered his arrogance, and paid as promised.")
Q(1089, "The Den", STM, 29, HBF,
    "The druids kept many powerful things in the Talon Den on Stonetalon Peak behind a complex scheme of keys. Braelyn had extracted the details from one of them. A Gatekeeper's Key in a lantern at the entrance opened caches around the den, and their contents opened the hoard in the middle.",
    "Braelyn Firehand wanted the druids' hoard in the Talon Den. The way in began with a key hidden in a small lantern by the door.",
    "Three keys slid into three keyholes carved in the stone, and in the glowing light between them a number of items appeared.",
    "The three keys from the den's caches opened the druids' hoard. Items appeared in the light.")
Q(742, "The Ashenvale Hunt", "Thunder Bluff", 20, HWS,
    "A call went out to young adventurers. The Horde had two outposts north of the Barrens, Splintertree Post and the one on the Zoram Strand. Senani Thunderheart at Splintertree wanted hunters for a great hunt of Ashenvale.",
    "The wilds of Ashenvale awaited, the notice said. Senani Thunderheart at {p:Splintertree Post}, straight north of the Barrens, would explain the hunt.",
    "Senani Thunderheart welcomed the newcomer to the frontier. Ashenvale was a land of opportunity for a young fighter, she said, with a second outpost out at the Zoram Strand worth seeing. She was glad to explain the hunt.",
    "At Splintertree Post, Senani called Ashenvale the new frontier and began to tell what the hunt required.", nil, true)
Q(235, "The Ashenvale Hunt", "Orgrimmar", 20, HWS,
    "Notices called young adventurers north to Ashenvale. The Horde held Splintertree Post and an outpost on the Zoram Strand. Senani Thunderheart at Splintertree wanted adventurers for a great hunt of Ashenvale.",
    "The Horde's new frontier lay north of the Barrens, and Senani Thunderheart at {p:Splintertree Post} wanted those who would prove themselves there.",
    "Senani welcomed the arrival to the new frontier and spoke of boundless chances for a young fighter in Ashenvale. Then she explained the hunt.",
    "At Splintertree Post, Senani Thunderheart said to look around the outpost and to visit the Zoram Strand too. Then she offered to explain the hunt.", nil, true)
Q(6382, "The Ashenvale Hunt", "The Barrens", 20, HWS,
    "Jorn Skyseer was impressed, and thought the hunter ready for bigger game. The forests of Ashenvale were an untamed wild the Horde meant to bend to its will, he said. Senani Thunderheart at {p:Splintertree Post} could guide a hunter there.",
    "Jorn Skyseer's lessons at Camp Taurajo ended with a direction. North of the Barrens road lay Splintertree Post, and Senani Thunderheart's hunt.",
    "Senani Thunderheart welcomed Jorn's student to the frontier. Ashenvale was a land of opportunity, she said, with a second outpost on the Zoram Strand, and the hunt was hers to explain.",
    "At Splintertree Post, Senani greeted the hunter from Camp Taurajo and began to describe the great hunt of Ashenvale.", nil, true)
Q(6442, "Naga at the Zoram Strand", ASH, 19, HZG,
    "Marukai at {p:Zoram'gar Outpost} spoke of evil along the coast. Zoram lay drowned beneath the sea, and the naga had come back to it for reasons no one knew. The Horde had worked hard to claim this land, and Marukai wanted twenty naga heads.",
    "The naga were growing in number on the Zoram Strand. Marukai asked for them thrown back to the depths and their heads brought to Zoram'gar.",
    "Marukai took the heads and said the outpost could use more of that kind of help.",
    "Twenty naga heads reached Zoram'gar. Marukai wished he had more fighters like the one who brought them.")
Q(6641, "Vorsha the Lasher", ASH, 23, HZG,
    "Vorsha the Lasher, a hydra of the seas, had attacked Zoram'gar unprovoked more than once and laid waste to whatever she met. Muglash had a plan. The naga kept a brazier lit to her on an island off the coast, and putting it out would bring her ashore in anger. He wanted strong allies along.",
    "Muglash of Zoram'gar meant to end Vorsha's attacks by dousing the naga's brazier and fighting the hydra when she came. It was no task for one.",
    "Muglash had seen many naga attacks since coming to Zoram'gar, and it put his mind at ease that Vorsha would roam free no more. The outpost was in debt, he said.",
    "Vorsha the Lasher was dead off the Zoram Strand. Muglash spoke of a debt owed by Zoram'gar.")
Q(216, "Between a Rock and a Thistlefur", ASH, 24, HZG,
    "Thistlefur Village east of Zoram'gar blocked the way to Splintertree Post that would skirt Astranaar, Karang Amakkar said. He would not allow an expansion path gap. The furbolgs were to be thinned, for pay and for the Horde.",
    "Karang wanted a road between Zoram'gar and Splintertree free of Alliance entanglements. The Thistlefur in the village to the east stood in the way.",
    "Karang would keep sending forces against the furbolg, but he could count now on a path clear of the Alliance. The Horde's conquest of Ashenvale was in full swing, he declared, and the pay was earned.",
    "Karang Amakkar saluted the work in Thistlefur Village. He had his second road to Splintertree, or the beginnings of one.")
Q(6462, "Troll Charm", ASH, 24, HZG,
    "Mitsuwa's kinfolk had been carrying sacred troll charms to Zoram'gar when the Thistlefur killed them on the way. She would see her brothers and sisters again in the afterlife, she said, but the charms belonged in this world. They sat in chests in Thistlefur Hold, the cave at the end of Thistlefur Village.",
    "The Thistlefur furbolgs had the charms of Mitsuwa's dead kin, and every moment they kept them made her blood boil.",
    "Mitsuwa thanked the one who brought the charms back, twice over. A troll without his charm was like an orc without his battle scars, she said, worthless.",
    "The sacred charms came out of Thistlefur Hold and back to Mitsuwa at Zoram'gar. She could not say how great a thing it was to her.")
Q(6482, "Freedom to Ruul", ASH, 24, HWS,
    "Ruul Snowhoof sat in a cage in Thistlefur Hold. The furbolgs had taken him for a bear and were starving him, and his strength was failing. He asked for help out and word to his sister Yama at Splintertree Post.",
    "A tauren mistaken for a bear by the Thistlefur was starving in their hold. Ruul wanted out, and his sister Yama at Splintertree would want to know.",
    "Yama was shocked to hear her brother had been held by the Thistlefur. Many furbolgs were noble, she said, but the Thistlefur were corrupt, and she did not want to think how they had treated poor Ruul. He would sleep long after this.",
    "Ruul Snowhoof escaped Thistlefur Hold, and his sister Yama at Splintertree Post heard the news. She expected him to sleep for a long while.")
Q(6503, "Ashenvale Outrunners", ASH, 24, HWS,
    "Reports had reached Kuray'bin that Ashenvale outrunners had left Silverwing Outpost and were sneaking near the Horde's territories, gathering word of its defenses. They were in the forests south of Splintertree and east of Silverwing, and Kuray'bin wanted them dead.",
    "Kuray'bin would not have the Alliance scouting Splintertree's defenses. The outrunners from Silverwing were to be hunted down in the forest.",
    "Kuray'bin called the hunting impressive. Losing the outrunners helped blind the Alliance, he said, and a blind enemy attacked less.",
    "The outrunners from Silverwing were dead in the forest. Kuray'bin counted the Alliance blinder for it.")
Q(6544, "Torek's Assault", ASH, 24, HWS,
    "Torek and his raiders were about to attack Silverwing Outpost to the west, and their target was its leader, Duriel Moonfire. The scouts said the place was heavily defended, and Torek called the coming battle glorious. Whoever shared in it could report the success to Ertog Ragetusk at Splintertree.",
    "Torek wanted company for his raid on Silverwing Outpost and the death of Duriel Moonfire. The report afterward went to Ertog Ragetusk.",
    "Ertog Ragetusk was pleased that Torek's attack had succeeded. Night elves were decent foes, he said, skinny but strong and fierce, and he hoped the fight had left a scar or two.",
    "Word of Torek's success at Silverwing reached Ertog Ragetusk at Splintertree. He thought it must have been something to see.")
Q(6441, "Satyr Horns", ASH, 26, HWS,
    "Pixel had stopped at Splintertree on her way to Ratchet and smelled an opportunity. Satyr horns were in high demand there, and the satyrs of Night Run, Satyrnaar and Xavian had the right kind. She was no match for satyrs herself.",
    "A goblin passing through Splintertree wanted satyr horns before she went on to Ratchet. Night Run, Satyrnaar and Xavian were where they grew.",
    "Pixel called the horns perfect and paid for the time.",
    "The satyr horns reached Pixel before she left for Ratchet, and she paid up.")
Q(6621, "King of the Foulweald", ASH, 26, HZG,
    "The Foulweald southeast of Astranaar were fewer than the Thistlefur but fierce, Karang said, and a show of force would remove the threat. A Horde banner planted on their totem mound would bring Chief Murgut out to save face, and Karang wanted the totem he carried.",
    "Karang Amakkar's challenge to the Foulweald was a banner on their sacred mound. It was no task for one fighter, he warned, and the prize was Chief Murgut's totem.",
    "Karang called it good work. The challenge and the death of their chief sent the Foulweald a strong message, he said, that the Horde was not to be trifled with. He did not expect trouble from that tribe for a long time.",
    "Karang took Chief Murgut's totem and did not expect trouble from the Foulweald for a long time.")
Q(6571, "Warsong Supplies", ASH, 27, HWS,
    "The Warsong lumber camp was short of a few things, Locke Okarr said. Pixel at Splintertree had the saw blades and Wharfmaster Lozgil in Booty Bay the crate of axes. The Thistlefur and Foulweald furbolgs had pilfered the rope. The satyrs of Night Run, Satyrnaar and Xavian had taken the oil for their rituals.",
    "Locke Okarr was in big trouble if the Warsong camp's supplies did not arrive soon. Saw blades, axes, rope and oil were scattered from Splintertree to Booty Bay and the satyr ruins.",
    "Locke called it excellent and said it had saved him a lot of work, and that he was grateful all the same.",
    "Saw blades, axes, rope and oil reached Locke Okarr for the Warsong lumber camp. He had feared big trouble if they came late.")
Q(6504, "The Lost Pages", ASH, 30, HWS,
    "Gurda Ragescar had picked up a shredder in Ratchet and was due back on duty at the {p:Warsong Lumber Camp}. On the way a gust of wind tore the pages of its manual from her hands. All she had left was the cover. Without the rest, she did not know how to run the machine.",
    "The pages of a shredder manual lay scattered across Ashenvale, and Gurda Ragescar could not get back to work without them.",
    "Gurda admitted reading was not her strong point, but with the pages back she could get to work.",
    "The lost pages reached Gurda Ragescar, who could now take her shredder on to the lumber camp.")
Q(1013, "The Book of Ur", "Shadowfang Keep", 26, "horde_apothecary",
    "Keeper Bel'dugur in the Undercity's Apothecarium prized the writings of Ur, a great mage of Dalaran before the Scourge came. Ur's studies of other worlds were of value to certain parties among the Forsaken. One of them lay in {p:Shadowfang Keep}, and Bel'dugur promised to report the service to the Dark Lady.",
    "Ur's writings on other worlds were somewhere in Shadowfang Keep. Keeper Bel'dugur wanted them for his collection.",
    "Bel'dugur added Ur's work to his collection. Ur's knowledge had been great, he said, but his conscience had held him from true power. When the Scourge tested his strength, it failed. In his view the Forsaken could afford no such weakness if they were to survive and conquer.",
    "Ur's writings came out of Shadowfang Keep to Bel'dugur. He spoke of a mage whose conscience had failed him, and of a people who could not afford one.")
Q(1361, "Regthar Deathgate", "The Barrens", 32, "horde_kolkar",
    "Regthar Deathgate, a warrior of the Horde, was recruiting agents for a mission into Desolace from his bunkers west of the Crossroads. Desolace was a place torn by war, the word went, and weapons should be sharpened first.",
    "Volunteers for Desolace were to find Regthar Deathgate in the bunkers west of the Crossroads.",
    "Regthar was recruiting, he confirmed, for a mission into Desolace against the centaur there. He kept it brief so the work could start.",
    "In the bunkers west of the Crossroads, Regthar Deathgate took on another volunteer against the centaur of Desolace and wasted no words.")
Q(5151, "Hypercapacitor Gizmo", "Thousand Needles", 30, HN,
    "Wizlo Bearingshiner was the only survivor of a caravan the centaur had attacked north of Whitereach Post. They had taken everything but a caged panther that wore his best gizmo, a hypercapacitor, around its neck. He handed over the cage key.",
    "A rare panther in a cage at the wrecked caravan wore Wizlo's hypercapacitor. Even the centaur trembled at the beast, he said, and left it alone.",
    "Wizlo had his hypercapacitor back. It would keep him busy a while, he said, until he worked out what it did.",
    "The hypercapacitor came off the panther's neck and back to Wizlo, who still had to discover its purpose.")
Q(1069, "Deepmoss Spider Eggs", STM, 20, "horde_ratchet",
    "Spider egg omelettes were the new fad in Booty Bay, and Booty Bay had no eggs. Mebok Mizzyrix smelled an opportunity. Deepmoss spiders laid in {p:Windshear Crag} under what trees remained, and in Sishir Canyon for those with strong stomachs.",
    "Mebok had a shipping deal with Wharfmaster Dizzywig before he had a single egg. The deepmoss spiders of Stonetalon were to supply them.",
    "Mebok could already taste the profits. The eggs would go to Dizzywig and on to Booty Bay. He paid out a cut for a deal he could not have made alone.",
    "Mebok had his deepmoss eggs for Booty Bay's omelettes, and shared the proceeds of a deal he could not have made alone.")
Q(1221, "Blueleaf Tubers", "Razorfen Kraul", 26, "horde_ratchet",
    "Blueleaf tubers were a delicacy the world over and grew in one place, deep in the earth of {p:Razorfen Kraul}. Mebok Mizzyrix had trained snufflenose gophers to smell them out at fifty paces, and he lent them for the hunt.",
    "Mebok's gophers could find the blueleaf tubers of Razorfen Kraul that no one else could. Getting them out of the quilboar warren was the hard part.",
    "Mebok could sell the tubers to his contacts for a bundle, and called the deliverer a great partner.",
    "The blueleaf tubers came out of Razorfen Kraul to Mebok, who thanked his partner for the delivery.")
Q(1144, "Willix the Importer", "Razorfen Kraul", 30, "horde_ratchet",
    "Willix the Importer had been held in {p:Razorfen Kraul} so long he could not remember the outside. He had heard Mebok Mizzyrix paid well for tubers from the pig pen and expected an easy in and out. He asked for help getting out and promised to make it worth the trouble.",
    "An entrepreneur named Willix sat prisoner in the Kraul after a tuber run gone wrong. He wanted an escort out.",
    "Willix was out of the Kraul at last. He had promised to make it worth the trouble, and he paid.",
    "Willix the Importer walked out of Razorfen Kraul and paid as promised.")
for _, id in ipairs({6629, 6481, 6283, 1088, 6641, 6621}) do pack.questIDs[id].importance = 4 end
pack.questIDs[6629].highlight = {"Grundig Darkcloud, who led the Grimtotem raid on Makaba Flathoof's village, died at Grimtotem Post. Makaba said his gratitude would last always.", "Makaba Flathoof's village was avenged on Grundig Darkcloud at Grimtotem Post."}
pack.questIDs[6481].highlight = {"Goggeroc the Earthen woke weak from his Resonite cask in Boulderslide Ravine and died there. Mor'rogal called it a hero's deed and said all Kalimdor was in debt.", "The Earthen Goggeroc died in Boulderslide Ravine before his strength returned. Mor'rogal spoke of a debt owed by all of Kalimdor."}
pack.questIDs[6283].highlight = {"Bloodfury Ripper, all but a queen to the Charred Vale's harpies, was dead. Maggran Earthbinder felt his anger leave and wondered what to do with his time.", "Maggran Earthbinder had Bloodfury Ripper's remains and no anger left. He thought that might be a good thing."}
pack.questIDs[1088].highlight = {"Keeper Ordanus, an elder son of Cenarius, died atop the great tree at Raynewood. Braelyn Firehand remembered his arrogance and paid for his head.", "Ordanus's head went to Braelyn Firehand at Sun Rock Retreat, who said it did not rise so high now."}
pack.questIDs[6641].highlight = {"Vorsha the Lasher came ashore when the naga's brazier went out and died there. Muglash said Zoram'gar was in debt.", "The hydra Vorsha was dead off the Zoram Strand, and Muglash's mind was at ease."}
pack.questIDs[6621].highlight = {"A Horde banner on the Foulweald's totem mound drew out Chief Murgut, who died defending it. Karang Amakkar expected no trouble from the tribe for a long time.", "Chief Murgut's totem reached Karang at Zoram'gar. The Foulweald had their message."}

-- Forever additions outside Zephras carry the Forever label in the compendium
-- (factcheck lane, 2026-11-05; explicit list, never inferred from the ID range).
for _, id in ipairs({86784, 91921, 92706, 93739, 94373, 94374, 94375, 94449, 94465, 94466, 94467, 94468, 94495, 94497, 94499, 94500, 94501, 94502, 94503, 94505, 95314, 95349, 95350, 95494, 95495, 95507, 95508, 95981, 96652, 96656, 96659, 96821, 96822, 96825, 96876, 97279, 97558, 98024, 98298, 98299, 98424, 98427, 98430, 98435, 99048, 99049, 99051, 99052, 99079, 99080, 99081, 99082, 99101, 99142, 99156}) do
    if pack.questIDs[id] then pack.questIDs[id].setting = "Forever" end
end

-- The character's side of a stage (DESIGN §3.0; format in JournalBook.lua, QD.Story):
-- `act` folds into a grouped line, the numbered lines tell the moment. Written from the
-- same quest text as why/after (balance lane, 2026-11-07): Deathknell and Brill first.
local POV = {
    [363] = {act = "rose in the crypt and went down to Shadow Priest Sarvis", solo = true,
        "{I} woke on the cold stone of a crypt, and Mordo sent {me} down the hill to the chapel. Shadow Priest Sarvis told {me} there what {I} had become, one of the Forsaken, free of the Lich King and at war with him.",
        "Mordo had been ready to burn {me} for a corpse when {I} stirred in the crypt. Instead he sent {me} to Shadow Priest Sarvis, who told {me} that Sylvanas had set the Forsaken free."},
    [364] = {act = "cut down the Mindless Ones in the north of the village", giver = "Shadow Priest Sarvis",
        "The Mindless Ones had overrun the north of the village, still slaves of the Lich King. {We} cut them down for Sarvis, who only wished they could have joined the Forsaken.",
        "{We} cut down the Mindless Ones in the north of the village. They had been brothers and sisters to the Forsaken once, Sarvis said, but the Lich King still held them."},
    [376] = {act = "hunted wolves and bats for Novice Elreth", giver = "Novice Elreth",
        "South of the village {we} hunted wolves and bats for their paws and wings. Novice Elreth gave {us} armor for them, and hoped it would serve {us} better than its last wearer.",
        "Novice Elreth was short of wolf paws and bat wings for the wounded she tended. {We} brought her what she needed, and she found {us} armor in return."},
    [3901] = {act = "thinned the Rattlecage skeletons", giver = "Shadow Priest Sarvis",
        "The Rattlecage skeletons were a harder fight than the zombies, and {we} thinned them as Sarvis asked. He declared his lessons finished, and told {us} the Forsaken would never be shackled again.",
        "Sarvis wanted to see {us} under pressure, and set {us} against the Rattlecage skeletons. {We} thinned them, and he judged {us} worthy of the freedom the Forsaken had been given."},
    [3902] = {act = "searched the village crates for the recruits still rising", giver = "Deathguard Saltain",
        "{We} searched the crates of the village for gear the newly risen could wear. Deathguard Saltain kept one of the better finds back for {us}.",
        "Deathguard Saltain wanted no recruit stumbling about naked, so {we} searched the village crates for anything to wear. He kept back one of the better finds as {our} reward."},
    [381] = {act = "struck the Scarlet camp outside the village", giver = "Executor Arren",
        "Scarlet zealots had made camp southeast of the village, and Executor Arren wanted them hit before they could strike first. {We} fell on the camp, and Arren called the dead crusaders Light-blinded fools.",
        "{We} struck the Scarlet Crusade's camp southeast of the village, zealots who hunted every undead they found. Arren said they had sent themselves to their own graves."},
    [6395] = {act = "laid Samuel Fipps in his wife's grave", giver = "Novice Elreth",
        "Marla Fipps had been killed by her husband Samuel after the plague made him Scourge. Her last wish was to lie beside him, so {we} destroyed him and laid his remains in her grave.",
        "{We} granted Marla Fipps her last wish. Her husband Samuel had killed her after the plague made him Scourge, and {we} laid what was left of him in her grave. Novice Elreth hoped the two would find peace there."},
    [382] = {act = "took the papers of a Scarlet messenger", giver = "Executor Arren",
        "A Scarlet messenger was carrying word from the monastery, and {we} took his papers for Executor Arren. Among them Arren found the positions of the Crusade's commanders and agents.",
        "{We} took the documents a Scarlet courier carried and brought them to Executor Arren, who found a useful map among the orders."},
    [365] = {act = "stole pumpkins from a farm under a Scarlet tower", giver = "Deathguard Simmer",
        "Deathguard Simmer sent {us} to rob a human farm under the eye of a Scarlet tower. {We} came away with ten pumpkins for Apothecary Johaan in Brill, who called {us} an asset to the Dark Lady's army.",
        "{We} stole ten pumpkins from a farm under the eye of a Scarlet tower. Apothecary Johaan in Brill wanted them for his reagents."},
    [383] = {act = "carried the Scarlet papers to Executor Zygand in Brill",
        "{We} carried captured Scarlet papers to Executor Zygand in Brill. He read out the names of the Crusade's officers in Tirisfal, and spoke of killing them all in one swift strike.",
        "In Brill, {we} handed Executor Zygand papers taken from a Scarlet courier. They named the Scarlet officers in Tirisfal, and he spoke of striking them all at once."},
    [427] = {act = "killed the Scarlet warriors who held the tower past the Solliden Farmstead", giver = "Executor Zygand",
        "With the Crusade's positions known at last, Executor Zygand sent {us} west past the Solliden Farmstead to its tower. {We} cut down the Scarlet warriors there, and Zygand called {our} skill in combat undeniable.",
        "{We} went west to the Scarlet tower beyond the Solliden Farmstead and killed the warriors who held it, as Executor Zygand had asked."},
    [5481] = {act = "picked gloom weed for Gordo",
        "Gordo the abomination had hands too big for picking, and asked {us} to gather weeds for his master. {We} brought the gloom weed to Junior Apothecary Holland, who had wanted doom weed.",
        "{We} picked gloom weed for Gordo, an abomination with hands too big for picking. Junior Apothecary Holland had no use for it. He had wanted doom weed."},
    [86784] = {act = "carried firewood to Eleanor Shackleton's camp",
        "{We} carried a basket of firewood from Deathguard Bartholomew to Eleanor Shackleton, camped in the hills to the west. She welcomed it for the cold nights of the Glades and let {us} keep the basket.",
        "Eleanor Shackleton lived off the wilds, and {we} brought her a basket of firewood at her camp in the western hills. She already had a sling for wood, so the basket stayed with {us}."},
    [96656] = {act = "looked into a stranger camped down the road by Brill",
        "A stranger had camped down the road by Brill, and with Scarlet Crusaders about {we} went to see why. She was Eleanor Shackleton, an adventurer with no ties to the Crusade, and she offered to teach {us} camping.",
        "{We} went down the road by Brill to look into a stranger's camp. She was Eleanor Shackleton, an adventurer, and she offered {us} lessons in camping."},
    [407] = {act = "fed Johaan's pumpkin to a captive zealot in the tavern cellar", giver = "Apothecary Johaan",
        "Apothecary Johaan had laced a pumpkin with his latest formula for the Scarlet zealot held in the tavern cellar. The starving man cursed {us}, then saw the pumpkin and ate it gladly.",
        "{We} carried Johaan's treated pumpkin down to the captive zealot under the Gallows' End Tavern. He was too hungry to ask what was in it."},
    -- pov-horde lane (2026-11-07): Tirisfal, Brill and the Undercity errands.
    [8] = {act = "carried Calvin Montague's letter to Renee at the inn", giver = "Calvin Montague",
        "Calvin Montague pressed a letter on {us} for Renee, the innkeeper at Brill, and promised good pay for the walk. Renee claimed it came from her saintly mother, then dropped the act and told {us} to come back with coin to spend.",
        "{We} carried Calvin's letter down the road to the inn, a cozy place by his account. Innkeeper Renee took it with a cheery word, then sent {us} off as loafers and said the sender was nobody's business."},
    [590] = {act = "beat the promised pay out of Calvin Montague", giver = "Calvin Montague",
        "When {we} came back for the pay he had promised, Calvin Montague denied any letter and raised his fists instead. {We} beat him, and he paid less than he had said, since the first figure had been a lie.",
        "Calvin Montague took {us} for easy prey when {we} asked for {our} coin. He lost the fight, admitted he had lied about the sum, and handed over what he had."},
    [367] = {act = "gathered darkhound blood for Johaan's new plague", giver = "Apothecary Johaan",
        "Apothecary Johaan told {us} of the Dark Lady's challenge to his society, a plague to bring Arthas's Scourge to ruin. {We} hunted darkhounds for five vials of their blood, and he set about testing his theory.",
        "{We} brought five vials of darkhound blood to Apothecary Johaan. He believed the blood of beasts might be the key to the plague Sylvanas had asked of the apothecaries."},
    [404] = {act = "beat back the Scourge by the old bridge", giver = "Deathguard Dillinger",
        "Deathguard Dillinger sent {us} west to the old bridge, where the rotting dead had trickled into the glades. {We} beat them back and brought him their putrid claws, and his one regret was missing the sight.",
        "By the old bridge west of the town {we} smashed walking corpses for their claws. Dillinger paid the Deathguards' reward and wished he had been there to watch them fall to pulp."},
    [5482] = {act = "gathered doom weed by the mass graves", giver = "Junior Apothecary Holland",
        "Gordo kept bringing Junior Apothecary Holland the wrong weed. {We} picked the doom weed he needed by the mass graves, where gnolls roamed, and Holland rubbed his hands over it.",
        "Among the mass graves north of the graveyard {we} gathered the doom weed Holland needed. He called it a fine service to him, then corrected that to the Lady."},
    [374] = {act = "hunted Scarlet Crusaders for ten of their insignia rings",
        "A Deathguard in Brill wanted ten Scarlet insignia rings as proof of loyalty to Varimathras and the Dark Lady. {We} brought the rings back, and he said Varimathras would be proud.",
        "{We} hunted Scarlet Crusaders until ten insignia rings proved the work. The Deathguard who took them counted it service to Varimathras, who wanted the Crusade wiped from the glades."},
    [361] = {act = "carried Thurman Agamand's lost letter to Yvette Farthing",
        "In the ruins of Agamand Mills {we} found a letter that had never reached Yvette Farthing. {We} carried it to her in Brill. She mourned Thurman Agamand, who had written it, then said that life was over.",
        "Yvette Farthing had begged Thurman to leave the mills with her, and his last letter came to her only through {us}. She thanked {us} for telling her what had become of him, then set regret aside as something for the weak."},
    [358] = {act = "killed the Rot Hide graverobbers at the Mass Graves", giver = "Magistrate Sevren",
        "Magistrate Sevren sent {us} north to the Mass Graves, where Rot Hide gnolls dug up the plague dead for the Scourge. {We} cut them down and drained their embalming ichor, which Sevren passed to the apothecaries in hope of secrets.",
        "Among the graves of the plague dead {we} killed the Rot Hide gnolls who stole corpses for the Scourge's armies. Sevren called it expertly done and said the struggle would give {us} more chances to prove {our} worth."},
    [359] = {act = "went east to Deathguard Linnea's waystation", giver = "Magistrate Sevren",
        "Magistrate Sevren feared more Scourge had slipped past the Bulwark, and sent {us} east to the Deathguard waystation. Deathguard Linnea told {us} the defenders held most of them back, though some got through near Balnir Farmstead.",
        "{We} took the south road and turned east at the fork to find Deathguard Linnea at her waystation. The Bulwark was holding, she said, but Scourge had been seen around Balnir Farmstead."},
    [360] = {act = "carried the report on the Bulwark back to Sevren", giver = "Deathguard Linnea",
        "Deathguard Linnea sent {us} back to Brill in haste, with orders to cut down any Scourge along the way. Magistrate Sevren heard her word with unease and swore that the Lich King would not take the Forsaken again.",
        "{We} carried the waystation's report to Magistrate Sevren. Scourge still slipped past the Bulwark, and he called the Lich King's assaults ceaseless, but said the Forsaken would not give in."},
    [370] = {act = "killed Captain Perrine at the ruined tower", giver = "Executor Zygand",
        "The captured papers placed Captain Perrine and his brigade in the ruined tower southwest of the town. {We} killed him there with his zealots and missionaries, and Executor Zygand said his death would please the Dark Lady.",
        "{We} fought through the zealots and missionaries at the ruined tower and killed Captain Perrine. Executor Zygand had sent {us} there, and said {we} had done {our} duty well."},
    [368] = {act = "took scales from the Vile Fin murlocs", giver = "Apothecary Johaan",
        "Poisoning one victim was child's play, Johaan told {us}, but a plague for a whole world needed more. {We} took scales from the Vile Fin murlocs on the coast, and he judged them exactly right for his concoction.",
        "Along the coast north and west of Brill {we} hunted Vile Fin murlocs for the scales Johaan wanted. His plague needed them to spread, he said, and he called them perfect."},
    [426] = {act = "broke the Scourge gathering at Agamand Mills", giver = "Deathguard Dillinger",
        "The Scourge meant to make a base of Agamand Mills, and Deathguard Dillinger sent {us} north to the windmills. {We} came back with notched ribs and blackened skulls, and he gave no thanks for necessary work.",
        "Among the windmills of Agamand Mills {we} fought skeletons and Darkeye bonecasters for their ribs and skulls. Dillinger would not thank {us} for it, but said the Deathguards of Tirisfal would remember who had done it."},
    [405] = {act = "carried Magistrate Sevren's orders to the mage Bethor Iceshard", giver = "Magistrate Sevren",
        "{We} brought Magistrate Sevren's orders to Bethor Iceshard, a powerful mage in the Undercity. His business concerned a wayward lich, and he would judge for himself whether Sevren had chosen well.",
        "{We} found Bethor Iceshard, a mage of high rank, in the Magic Quarter of the Undercity and gave him Sevren's orders. His task concerned a wayward lich, Sevren had warned, and it would be dangerous."},
    [357] = {act = "stole the spellbook of a lich on Brightwater Lake", giver = "Bethor Iceshard",
        "{We} stole a lich's spellbook from an island in Brightwater Lake and brought it to Bethor. He knew the name in it at once. Gunther Arcanus had been his friend before the plague.",
        "{We} took the spellbook from a lich's camp on Brightwater Lake and carried it to Bethor Iceshard. It belonged to Gunther Arcanus, a necromancer grown stronger in death, and Bethor wanted him for the Forsaken."},
    [366] = {act = "returned the spellbook to the lich Gunther Arcanus with Bethor's spell on it", giver = "Bethor Iceshard",
        "Bethor laid a spell on the stolen spellbook to show Gunther that he too was free. {We} carried it back to the island. Gunther remembered who had stolen it, then saw the spell and wondered about his old friend.",
        "{We} went back to Brightwater Lake with Gunther's spellbook and Bethor's enchantment upon it. Gunther swore he would never again be a Scourge slave, until he saw the spell and wondered if Bethor had escaped as well."},
    [375] = {act = "brought duskbat pelts to Gretchen Dedmar",
        "Gretchen Dedmar had sewn body bags for Sylvanas's army, and now the chill of undeath made her hands shake. {We} brought her duskbat pelts and thread for a blanket, and she hoped the Dark Lady would one day know of it.",
        "{We} hunted duskbats for Gretchen Dedmar, who feared the mindless state was near. With the pelts and thread she could sew a blanket against the cold and keep serving the cause."},
    [371] = {act = "killed Captain Vachon and his friars at the southeastern tower", giver = "Executor Zygand",
        "Executor Zygand sent {us} to the ruined tower near Balnir Farmstead, where Captain Vachon led the Scarlet raids. {We} killed Vachon and five of his friars, and Zygand said it would slow the Crusade a good deal.",
        "{We} went southeast to the tower by Balnir Farmstead and cut down Captain Vachon among his friars. Executor Zygand called his death a blow to the Crusade's advance in the glades."},
    [372] = {act = "slew Captain Melrache and his bodyguards beyond Faol's Rest", giver = "Executor Zygand",
        "Zygand trusted {us} with a dangerous mission at last, the northern tower past Faol's Rest and its ruthless commander, Captain Melrache. {We} killed Melrache and his two bodyguards, and Zygand said he had a good feeling about {us}.",
        "Past Faol's Rest {we} climbed to the northern Scarlet tower and killed Captain Melrache with both his bodyguards. Executor Zygand said such work brought the Forsaken a step closer to defeating Arthas."},
    [369] = {act = "took venom from a Night Web spider for Johaan", giver = "Apothecary Johaan",
        "One of Johaan's old tomes told of an ancient plague whose agent had lived on in the venom of Night Web spiders. {We} went east for the venom, and Johaan boiled down his mixture, ready at last to try it.",
        "{We} brought Johaan venom from a Vicious Night Web Spider, the last thing his experiment lacked. Everything else was already in the pot, and he could finally test what he had made."},
    [492] = {act = "gave Johaan's drink to the captured mountaineer", giver = "Apothecary Johaan",
        "Apothecary Johaan sent {us} down to the dwarven mountaineer locked in the tavern cellar with a special drink. It was a hint, he said, of what the Dark Lady planned for Azeroth. The dwarf took the cup gladly.",
        "{We} carried Johaan's brew down to the thirsty mountaineer in the cellar of the Gallows' End Tavern. He grumbled that it was no Rhapsody Malt and drank it anyway."},
    [99142] = {act = "brought Holland's tomb weed in from Balnir Farmstead", giver = "Junior Apothecary Holland",
        "Junior Apothecary Holland had altered his doom weed and planted it at Balnir Farmstead. He called the crop tomb weed, the herald of his destiny. {We} brought it back past the Scourge it drew, and he only wished it had grown more violently.",
        "Out at Balnir Farmstead {we} gathered the tomb weed Holland had planted, with Scourge drawn close around it. He inspected the weeds, called progress progress, and said a great many would die because of {us}."},
    [356] = {act = "cleared the Scourge from Balnir Farmstead", giver = "Deathguard Linnea",
        "The Bulwark could only hold one front, Deathguard Linnea told {us}, and Scourge behind it threatened the supply line. {We} cleared the haven they had made at Balnir Farmstead, and she promised word of it to Executor Zygand.",
        "{We} went east from Linnea's waystation and slew the Scourge who had slipped behind the Bulwark, most of all at Balnir Farmstead. Linnea said it did much to keep them at bay."},
    [99156] = {act = "brought down the rogue abomination near Venomweb Vale", giver = "Deathguard Linnea",
        "A rogue abomination had been seen near Venomweb Vale, and Deathguard Linnea wanted it kept quiet. Such things did not slip past the Bulwark unnoticed. {We} hunted it down and brought her its heart.",
        "Linnea warned {us} the abomination by Venomweb Vale would not fall easily and that {we} would need allies. {We} killed it and carried back its heart as proof of the deed."},
    [398] = {act = "executed the gnoll Maggot Eye", giver = "Executor Zygand",
        "A poster in Brill named the gnoll Maggot Eye, sentenced to death for stealing corpses for the Lich King. {We} carried out the sentence near Garren's Haunt and brought his paw to Executor Zygand, who thanked {us} for the town.",
        "{We} went north to Garren's Haunt and executed the corpse thief Maggot Eye. Executor Zygand took his paw, and hoped it would warn others who meant the Forsaken harm."},
    [362] = {act = "destroyed Devlin Agamand and took his bones to Coleman", giver = "Coleman Farthing",
        "Coleman Farthing was gathering what was left of the Agamands. He wanted Devlin, the sharp-tongued younger son, who still chattered madly near the road to the mills. {We} destroyed him, and Coleman set his bones on his mantle.",
        "{We} found Devlin Agamand near the road to the mills, still chattering, and brought his bones to Coleman Farthing. The Agamands had failed his family when the plague came, Coleman said, and he swore to smash their remains."},
    [354] = {act = "destroyed the risen Agamands for Coleman Farthing", giver = "Coleman Farthing",
        "Coleman Farthing had worked the Agamand mills, and the family's pride had kept him there to die. {We} destroyed the Agamands who now served the Scourge and brought him their remains, and he called revenge sweet.",
        "At Agamand Mills {we} put down the family whose pride had kept its workers there to die. Coleman Farthing, one of those workers, hoped they had known fear at the end, and admitted it was a foolish hope."},
    [355] = {act = "went on to Magistrate Sevren", giver = "Coleman Farthing",
        "Coleman's revenge was done, but the mills still threatened every Forsaken, and he had told Magistrate Sevren about {us}. {We} went to see Sevren, and he said the Forsaken had need of {us} once again.",
        "{We} found Magistrate Sevren already knowing of the work at Agamand Mills, since Coleman Farthing had spoken well of it. He had new need of fighters like {us}."},
    [408] = {act = "broke Captain Dargol's hold on the Agamand crypt", giver = "Magistrate Sevren",
        "Captain Dargol, a skeleton, had raised the Agamand ancestors in their family crypt to fight the Forsaken. {We} went down among them and came back with Dargol's skull, and Magistrate Sevren called it a telling blow.",
        "{We} fought through the risen ancestors in the Agamand Family Crypt and took Captain Dargol's skull. Sevren believed the Forsaken would one day drive the Lich King himself from Azeroth."},
    [409] = {act = "destroyed Lillith Nefara at the bloody altar", giver = "Gunther Arcanus",
        "Gunther Arcanus would not believe {us} free without proof that {we} stood against the Scourge. {We} lit a Candle of Beckoning on the bloody altar off his island and destroyed Lillith Nefara when she woke.",
        "{We} lit one of Gunther's candles on the old altar south of the island and killed Lillith Nefara, the Scourge agent it woke. Gunther had believed himself the only one free, and was astonished."},
    [411] = {act = "brought Bethor a Nether Gem so he and Gunther could speak", giver = "Gunther Arcanus",
        "Gunther Arcanus gave {us} a Nether Gem for Bethor, so the two old comrades could speak. Gunther would join the Forsaken, and Bethor promised the Dark Lady would hear of it.",
        "{We} carried Gunther's Nether Gem to the Magic Quarter. Through it he told Bethor he would join the Forsaken, and Bethor said the Dark Lady would be told."},
    [97558] = {act = "gathered hides for Shelene Rhobart",
        "Forsaken skin did not heal, Shelene Rhobart told {us}, and she patched wounds with the hides of living things. {We} brought her duskbat membranes, darkhound hides and Vile Fin skin, and she promised each would find its place on someone's body.",
        "{We} hunted duskbats, darkhounds and murlocs to fill Shelene Rhobart's stocks of skin. Murloc hide served for cheeks and mouths, she said, and the thin membranes for faces and fingers."},
    [95314] = {act = "brought Whispering Elixir out of Shadowvale", giver = "Carolai Anise",
        "Carolai Anise had buyers for the Whispering Elixir once distilled in Shadowvale, ban or no ban. {We} went deep into the Whispering Forest to the ruined village for bottles of it, and she called the forest folk an odd lot.",
        "In the ruins of Shadowvale {we} found the bottles of Whispering Elixir Carolai Anise wanted. Some said the forest was cursed and its elixir too, she told {us}, but she paid all the same."},
    -- Silverpine: the Sepulcher, Dalar's inquiry and the lost Deathstalkers.
    [445] = {act = "carried Johaan's findings to Renferrel at the Sepulcher", giver = "Apothecary Johaan",
        "Apothecary Johaan trusted {us} with his findings for a colleague, and {we} followed the roads south out of the glades into Silverpine Forest. At the Sepulcher, Apothecary Renferrel was glad of the research and asked {us} to stay and help.",
        "{We} took Johaan's research south to Apothecary Renferrel at the Sepulcher, a long way from the town {we} knew. So much was happening in the forest, Renferrel said, that he had nearly forgotten the delivery."},
    [6321] = {act = "took Podrig's weapons order to the bat master", giver = "Deathguard Podrig",
        "The Sepulcher's Deathguards had lost weapons in the field, and Deathguard Podrig gave {us} his order for a dealer in the Undercity. {We} took it first to Karos Razok, the bat master, who saw it was official business and urged speed.",
        "Deathguard Podrig had taken stock of the Sepulcher for High Executor Hadrec and found it short of weapons. {We} carried his requisition to the bat master Karos Razok, who would arrange the way to the Undercity."},
    [6323] = {act = "flew a bat to the Undercity with the Sepulcher's order", giver = "Karos Razok",
        "For a small fee Karos Razok put {us} on a bat for the Trade Quarter of the Undercity. Gordon Wendham read the Sepulcher's order and called it an honor to serve.",
        "{We} rode a bat from the Sepulcher to the Undercity with Podrig's order. In the Trade Quarter Gordon Wendham kept his weapons cleaned and ready, and he took the order gladly."},
    [6322] = {act = "brought the weapon crate to the Undercity's bat master", giver = "Gordon Wendham",
        "Gordon Wendham packed the Sepulcher's weapons into a crate, and {we} carried it to Michael Garrett, the bat master of the Undercity. His bats flew to the Sepulcher every day, he said, so the crate would reach it easily.",
        "{We} took Gordon Wendham's crate of weapons to Michael Garrett, who sent bats to Silverpine daily. Now that {we} had met the bat master at the Sepulcher, one could carry {us} back there too."},
    [6324] = {act = "flew the weapons back to Deathguard Podrig", giver = "Michael Garrett",
        "A bat carried {us} and the crate of weapons from the Undercity back to the Sepulcher. Deathguard Podrig opened it and said his Deathguards would not be caught unprepared now, and that {we} had served the Dark Lady well.",
        "{We} flew back to Silverpine with the weapons from the Trade Quarter and handed them to Deathguard Podrig. His Deathguards were armed again, and he called it a valuable service to the Dark Lady."},
    [421] = {act = "killed Moonrage Whitescalps below the Sepulcher", giver = "Dalar Dawnweaver",
        "Dalar Dawnweaver blamed Arugal's reckless magic for the worgen in the forest, and wanted {us} to prove {our} worth first. {We} killed five Moonrage Whitescalps on the hill below the road, and Dalar had worthier work for {us} after that.",
        "{We} went down the hill below the Sepulcher and killed the Moonrage Whitescalps that prowled by the road. Dalar Dawnweaver judged {us} worthy aides against Arugal's curse."},
    [422] = {act = "found the Remedy of Arugal at the wheat farm", giver = "Dalar Dawnweaver",
        "Dalar Dawnweaver wanted to know exactly what magic Arugal had used, so he could turn it against him. {We} found the spellbooks at the wheat farm north of the bridge and brought back the Remedy of Arugal, the very spell he sought.",
        "A Deathstalker had seen Arugal's spellbooks at the wheat farm north of the bridge, and {we} went to fetch the one Dalar wanted. He said that with work like that there was quite a future for {us} among the Forsaken."},
    [423] = {act = "took enchanted shackles from the Moonrage worgen", giver = "Dalar Dawnweaver",
        "Arugal had used enchanted items to prop up his weak magic, Dalar said, and he wanted to see them for himself. {We} hunted Moonrage gluttons and darksouls north and east for their shackles, and Dalar wondered aloud if nine were enough.",
        "{We} brought Dalar six glutton shackles and three darksoul shackles from the worgen of the forest. He doubted they held enough energy, said he should have asked for more, and still called the collecting skillful."},
    [424] = {act = "beheaded Grimson the Pale in Deep Elem Mine", giver = "Dalar Dawnweaver",
        "Arugal's magic had spread to Deep Elem Mine in the southeastern hills, and Dalar wanted it taken for Varimathras's advance. {We} went in and beheaded its tainted foreman, Grimson the Pale, and Dalar counted the mine as the Forsaken's.",
        "{We} climbed into the hills southeast to Deep Elem Mine and killed Grimson the Pale, the foreman Arugal's magic had tainted. With him dead, Dalar said, the mine would supply the Forsaken advance."},
    [99] = {act = "took shackles from the cursed villagers of Pyrewood", giver = "Dalar Dawnweaver",
        "By day Pyrewood's villagers looked human, and after sunset they turned into Moonrage worgen. {We} went there for six of the shackles Arugal had laid on them. Dalar said his research was complete and Arugal would fall.",
        "{We} took six enchanted shackles from the people of Pyrewood Village, human by day and worgen by night. Dalar praised {our} persistence and promised Arugal's reckless magic would be undone."},
    [98298] = {act = "tore apart worgen by the Greymane Wall", giver = "Dalar Dawnweaver",
        "Dalar had decided Arugal could bind the worgen but never create them. He sent {us} south to the Greymane Wall, where the curse was spreading. {We} brought back fangs, claws and gizzards, and they proved Arugal's remedy worthless.",
        "{We} went to the Greymane Wall and tore the worgen apart for whatever Dalar could study. He laughed at Arugal, whose curse turned out to be no curse at all, and the search for a cure went on."},
    [428] = {act = "found the lost Deathstalkers at a northern farm",
        "Two Deathstalkers, Rane and Quinn Yorick, had not come back from scouting the north of the forest. {We} searched the farms where their mission began and found them alive, and Rane said {we} had come not a moment too soon.",
        "{We} went north to the farms after Rane and Quinn Yorick, missing for weeks. They were alive, though they still needed help, and Rane greeted {us} with real relief."},
    [429] = {act = "gathered worg hearts for Quinn Yorick's potion", giver = "Rane Yorick",
        "The ghoul Ivar the Foul had mauled Quinn badly, and his sister Rane sent {us} after worg hearts for a healing potion. {We} hunted worgs toward Malden's Orchard and took the discolored hearts to Apothecary Renferrel. He made the potion and gave {us} its recipe too.",
        "{We} brought discolored worg hearts to Apothecary Renferrel so he could brew a potion for Quinn Yorick. He found the Deathstalkers' failure troubling, and handed over the recipe in case it was needed again."},
    [430] = {act = "carried Renferrel's potion to Quinn Yorick", giver = "Apothecary Renferrel",
        "{We} carried Renferrel's healing potion north to the farm where Quinn Yorick lay hurt. He drank it, felt it working at once, and said {we} had done him a great favor.",
        "Quinn Yorick had heard from his sister that {we} came to help. {We} gave him the potion from the Sepulcher, and he expected to travel again soon."},
    [91921] = {act = "carried Renferrel's second potion to Quinn", giver = "Apothecary Renferrel",
        "Apothecary Renferrel made Quinn a new potion, with love extracted from six whole hearts, he said. {We} took it north, and Quinn drank it and felt it working.",
        "Quinn Yorick had begun to come to terms with turning into a ghoul when {we} came back with Renferrel's new potion. He drank it, thanked {us} for a great favor, and expected to travel soon."},
    [425] = {act = "killed Ivar the Foul in the farm's barn", giver = "Rane Yorick",
        "Ivar the Foul waited in the barn for Rane's guard to drop, and Quinn still lay healing. {We} went into the barn and killed the ghoul, and Rane promised to name {us} in her report.",
        "{We} killed Ivar the Foul, the ghoul who had mauled Quinn Yorick, in the barn beside the farm. Rane thanked {us}, and her brother had time to heal at last."},
    [435] = {act = "escorted Erland through the wolves to Rane Yorick", giver = "Deathstalker Erland",
        "Hungry wolves circled Deathstalker Erland's door, and he needed to reach Rane Yorick with his report. {We} walked him through them, and Rane, who had feared the forest had taken him, thanked {us} for his safe arrival.",
        "{We} took Erland out past the wolves that eyed him every time he stepped outside, and brought him to his teammate Rane. She had given him up for lost."},
    [449] = {act = "brought the Deathstalkers' report to High Executor Hadrec", giver = "Rane Yorick",
        "With Quinn on the mend, Rane Yorick wanted her report in High Executor Hadrec's hands without delay. {We} carried it to the Sepulcher. Hadrec admitted he had not reckoned on so much Scourge in the forest, and promised {us} a commendation.",
        "{We} delivered the Yoricks' report to High Executor Hadrec at the Sepulcher. The Scourge's numbers surprised him, and he called {our} help to his Deathstalkers invaluable."},
    [3221] = {act = "answered Renferrel's summons about the wolf hearts",
        "While {we} helped the Deathstalkers, Apothecary Renferrel had sent for {us} about the wolf hearts. {We} went back to him at the Sepulcher, and he said a matter concerning them demanded attention.",
        "{We} returned to Apothecary Renferrel when his summons reached {us}. Something about the wolf hearts {we} had brought him earlier would not wait, he said."},
    [437] = {act = "destroyed the banshee Nightlash at the Dead Fields", giver = "High Executor Hadrec",
        "Every small assault on the Dead Fields had broken against the banshee Nightlash, and High Executor Hadrec wanted her gone. {We} cut through the Rot Hides at the old farm until she appeared, destroyed her, and carried her dust back as proof.",
        "{We} went north to the Dead Fields and killed Rot Hides until Nightlash came out to defend them. Her essence turned to dust, and Hadrec said the Scourge had lost ground that day."},
    [438] = {act = "searched the Decrepit Ferry on Lordamere Lake", giver = "High Executor Hadrec",
        "Hadrec wanted to know why the Scourge guarded an old ferry east of the Sepulcher. {We} went past the Rot Hide patrols and found its boat heaped with wrapped corpses. Across the lake lay a dock on Fenris Isle, where they had to be going.",
        "At the Decrepit Ferry {we} found what the undead patrols were guarding, a boat piled with wrapped bodies. Looking east over Lordamere Lake, {we} could see the dock on Fenris Isle that waited for them."},
    [439] = {act = "took Deliah's ring from a corpse on the ferry",
        "Among the corpses on the ferry a woman's hand lay bare, marked by the plague but fairly fresh. {We} took the ring from it, engraved For Deliah. Hadrec reasoned the body could only have come from the mass graves of Tirisfal.",
        "{We} brought High Executor Hadrec a ring from a dead woman's hand, engraved For Deliah. A body that fresh, he said, meant the Rot Hides were carrying the dead of the mass graves to Fenris Isle."},
    [443] = {act = "took Rot Hide ichor on Fenris Isle", giver = "High Executor Hadrec",
        "Before any assault, Hadrec needed to know who stood behind the Rot Hides, and the apothecaries believed the answer flowed in their veins. {We} crossed to Fenris Isle and drained ichor from the gnolls there for Apothecary Renferrel.",
        "{We} crossed the water to Fenris Isle and came back with Rot Hide ichor. Renferrel said it might show the gnolls' weakness, if they had one."},
    [444] = {act = "took Renferrel's ichor sample to Bethor Iceshard", giver = "Apothecary Renferrel",
        "Renferrel had found warlock and necromantic magic in the ichor but could go no further. {We} carried a sample to Bethor Iceshard in the Magic Quarter. He found spells in it he had not seen in a long time, and began a divination at once.",
        "{We} carried a sample of the Rot Hide ichor down into the Undercity for Bethor Iceshard. He was no apothecary, but he knew the spells in it, some of them very old."},
    [446] = {act = "brought Bethor's counter-spell scroll to Renferrel", giver = "Bethor Iceshard",
        "Bethor knew the maker of the ichor, his old colleague Thule Ravenclaw, who had betrayed his brethren for the Scourge. He wrote out a scroll of incantations against Thule's spells, and {we} carried it back to Renferrel for a potion.",
        "{We} learned in the Magic Quarter that Thule Ravenclaw still lived and led the Rot Hides. {We} brought Bethor's scroll to Apothecary Renferrel, who said its potion would serve well against Thule on Fenris Isle."},
    [448] = {act = "reported to Hadrec before the assault on Fenris Isle", giver = "Apothecary Renferrel",
        "Before crossing to Fenris Isle {we} reported to High Executor Hadrec with Bethor's news. If Thule Ravenclaw truly led the Rot Hides, he said, he had to be dealt with soon. He opened the Sepulcher's arsenal to {us}.",
        "{We} told High Executor Hadrec what Bethor had learned of Thule Ravenclaw. Hadrec let {us} choose from the Sepulcher's arsenal for the fight to come."},
    [442] = {act = "took Thule Ravenclaw's head on Fenris Isle", giver = "High Executor Hadrec",
        "{We} went back to Fenris Isle surer of {our} strength, to the Scourge's stronghold in the forest, and destroyed Thule Ravenclaw. The energies of his death were felt even at the Sepulcher, and Hadrec said the deed rang through the Forsaken's ranks.",
        "Hadrec called the assault on Fenris Isle as dangerous as it was vital. {We} fought through Thule's keep and brought back his head, and the master of the Rot Hides was dead."},
    [440] = {act = "asked Magistrate Sevren about the ring's owner", giver = "High Executor Hadrec",
        "Hadrec doubted the giver of Deliah's ring still cared. {We} carried it north all the same to Magistrate Sevren, who kept the names of the recent dead. A Deliah had lived in Brill, Sevren said, buried in the mass grave and since stolen.",
        "{We} went back to Brill with the engraved ring. Magistrate Sevren found Deliah in his records and said the Rot Hides must have taken her body to Silverpine."},
    [441] = {act = "brought Deliah's ring to her husband Raleigh", giver = "Magistrate Sevren",
        "Deliah's husband Raleigh now lived in the Trade Quarter, and {we} took the ring to him there. He knew it as his wife's and said he felt nothing for her death. Only revenge still burned in his dead heart, he told {us}.",
        "{We} found Raleigh in the Undercity and showed him the ring from the ferry. It was Deliah's, he said, and her fate was that of all who failed to endure."},
    [530] = {act = "killed Valdred at the Greymane Wall for Raleigh", giver = "Raleigh",
        "Raleigh named his old friend Valdred as Deliah's murderer, last seen at the Greymane Wall trying to flee into Gilneas. {We} found him there and brought Raleigh his hands. Raleigh gave {us} back the ring, a bauble he no longer cared to keep.",
        "{We} went south to the Greymane Wall after Valdred, the friend who had killed Deliah. Raleigh kept the hands to remember the betrayal and called {us} the instrument of his revenge."},
    [264] = {act = "laid a widow's pendant on her husband's tomb",
        "A Forsaken widow cursed the husband whose crusade had taken him from her and their children, and pushed his pendant into {our} hands. {We} laid it on his neglected tomb at the Sepulcher, and its gem seemed to lose its sheen.",
        "{We} carried an angry widow's keepsake to her husband's tomb at the Sepulcher, cold and nicked and littered with trash. {We} set it on the carved hands of the coffin, as she had asked."},
    [460] = {act = "carried Alaric's head to his grave in Fenris Keep",
        "In Fenris Keep {we} met the head of Alaric. Thule had beheaded his servant and given the head to the Rot Hides as a plaything. {We} carried him to the hasty grave by the stable, and his body was still there.",
        "Alaric's head begged {us} to take him to his body, buried near the stable of Fenris Keep. {We} found the unmarked grave, and he had feared the gnolls had destroyed what lay in it."},
    [461] = {act = "laid Alaric to rest in the keep's hidden niche", giver = "Alaric",
        "Alaric asked {us} to carry him, boots left behind since they had never fit, to a hidden alcove in the southwestern tower. Behind a dusty shelf it opened, and {we} shut him in tight against the Rot Hides, where he wanted to rest.",
        "{We} took Alaric's body to the niche behind the dusty shelf in Fenris Keep. He had spent his best days in the keep, he said, and gave {us} a reward before {we} closed the alcove on him."},
    [491] = {act = "brought the Woven Wand to Bethor Iceshard", giver = "Alaric",
        "Alaric gave {us} the Woven Wand, which Thule and two friends had made from their apprentice wands. {We} took it to Bethor Iceshard, one of those friends. Bethor had thought it lost when Thule sided with the Lich King.",
        "{We} carried the Woven Wand from Fenris Keep to the Magic Quarter. Bethor called it a marvelous find and was glad Thule had never used its power, or he would have sensed it."},
    [452] = {act = "ambushed the Pyrewood Council",
        "A Forsaken operative waited outside Pyrewood for the council Arugal used as his puppets, and {we} arrived just in time to help. {We} fought beside her, and she hoped the sons of Arugal would turn on their master without the council.",
        "{We} helped lay an ambush for the Pyrewood Council as they came back to the village. They died, and the operative said {we} fought like true disciples of the Dark Lady."},
    [516] = {act = "put down the Ravenclaw undead in Beren's Peril", giver = "Shadow Priest Allister",
        "Shadow Priest Allister had only scattered reports of undead gathering to attack, somewhere near the Dalaran wizards in the hills. {We} found their cave at Beren's Peril and killed the Ravenclaw drudgers and guardians before they could move.",
        "{We} knew the forest well by then, and searched its hills until {we} found the cave called Beren's Peril. The Ravenclaw undead died inside, and Allister praised the scouts whose word had led {us} there."},
    [447] = {act = "gathered spider blood and bear hearts for Faranell", giver = "Apothecary Renferrel",
        "Renferrel believed spider blood and the toxin of a grizzled bear's heart made a deadly elixir, the start of a new plague. {We} gathered both in the forest and carried them to Master Apothecary Faranell in the Undercity.",
        "{We} brought spider blood and bear hearts from the forest down to the Royal Apothecary Society. Master Apothecary Faranell thanked Renferrel for sending {us} and began studying their toxins at once."},
    [1359] = {act = "took Renferrel's poisoned wolf hearts to Apothecary Zinge", giver = "Apothecary Renferrel",
        "The wolf hearts {we} had gathered held a toxin that should have killed the wolves themselves, and Renferrel wanted it studied. {We} carried his samples to Apothecary Zinge in the Undercity, who was eager to experiment with them.",
        "{We} went down to the apothecaries' halls in the Undercity with Renferrel's wolf heart samples. Apothecary Zinge said new toxins always interested the Royal Apothecary Society."},
    [450] = {act = "took Berard's notes from the Pyrewood inn", giver = "Master Apothecary Faranell",
        "Arugal's curse had made Apothecary Berard a mindless servant, but his findings on an ancient plague in Lake Lordamere might still be of use. {We} slipped into his study at the Pyrewood inn and brought his notes back to Renferrel, who called {us} brave.",
        "{We} went into Pyrewood Village for the notes of a lost apothecary, cursed by Arugal along with the rest. Renferrel was eager to see what Berard had been working on before he went mad."},
    [451] = {act = "brought lake moss and a murloc tumor to Faranell", giver = "Apothecary Renferrel",
        "Berard's notes named moss from the Lake Skulkers and Creepers of Lordamere's islands, and a tumor so rare he had found only one. {We} gathered both and took them to Master Apothecary Faranell, who said the Society was on the cusp of something great.",
        "{We} waded among the islands of Lake Lordamere for moss and hunted Vile Fin murlocs until {we} found the hardened tumor Berard described. Faranell said that if {we} fought less well, he would have recruited {us} for the Society."},
    [3301] = {act = "brought a glowing Barrens shell to Mura Runetotem", giver = "Tonga Runetotem",
        "Tonga Runetotem's clanmate Mura had gone to heal Silverpine's dying forest, and Tonga sent {us} with a shell from the Barrens. Mura smelled the dust of the Barrens on {us} and found an inner glow in the shell, as if it still lived.",
        "{We} carried a shell from the altered beasts of the Barrens all the way to the Sepulcher for Mura Runetotem. She meant to study it for a way to bring new life to the forest."},
    [477] = {act = "opened a Dalaran crate north of Pyrewood", giver = "Shadow Priest Allister",
        "Shadow Priest Allister wanted to know why Dalaran's wizards cared about a backwater like Ambermill. {We} found their camp north of Pyrewood and pried open a crate. Beneath a bundle of yellowed maps lay a pendant that looked magical.",
        "{We} went to the small camp north of Pyrewood where Dalaran's wagons left their crates. Inside one {we} found maps of western Lordaeron and a pendant {we} did not understand."},
    [478] = {act = "took the maps and pendant to Shadow Priest Allister",
        "{We} slipped the pendant out of the Dalaran crate and carried it to Shadow Priest Allister with the maps. He called it interesting, but the wizards' aim was still hidden from him, and he thought Dalar might know more.",
        "Shadow Priest Allister looked over the maps and the strange pendant {we} brought from the wizards' camp. Dalaran plainly wanted Ambermill for something, he said."},
    [481] = {act = "showed the pendant to Dalar Dawnweaver", giver = "Shadow Priest Allister",
        "{We} took the pendant to Dalar Dawnweaver, who knew it for a Kirin Tor artifact used to channel magic. So many sent to Ambermill meant a project of some size, he said, and he set about piercing the wizards' shields.",
        "Dalar Dawnweaver turned the pendant over and called it more machinations of the Kirin Tor. {We} learned from him that powerful wizards used such things to channel their energies."},
    [482] = {act = "carried Dalar's warning about Ambermill to Allister", giver = "Dalar Dawnweaver",
        "Dalar remembered that the Kirin Tor had marked Ambermill for its sleeping ley node, and the wizards meant to wake it. {We} carried his warning to Shadow Priest Allister, who called it ill news and said the wizards had to be slowed.",
        "{We} brought Allister word that Ambermill held a dormant ley energy node and that taking the pendants could stall the wizards. He had no reason to doubt Dalar, and agreed they had to move quickly."},
    [479] = {act = "took the pendants from Ambermill's wizards", giver = "Shadow Priest Allister",
        "{We} took the main road south and the eastern fork into Ambermill, and took pendants from its conjurers, mages and protectors. It slowed the wizards, but Dalar found their weaving far along, guided by a wizard of great power.",
        "In Ambermill {we} fought the conjurers and protectors who carried Dalaran's pendants. Allister feared the Forsaken might lose the forest if the wizards finished, and the pendants bought only a little time."},
    [95981] = {act = "culled Dalaran's watchers on the roads around Ambermill", giver = "Shadow Priest Allister",
        "Taking the pendants was only a first step, Allister said, and he wanted Dalaran's relics stopped at the source. {We} hunted the wizards and watchers on the roads around Ambermill. He did not care why the Kirin Tor held those roads so tightly.",
        "{We} cleared the roads around Ambermill of Dalaran's wizards and watchers, who had crossed the Forsaken borders freely for too long. Allister judged their reasons beside the point."},
    [480] = {act = "killed the archmage weaving Ambermill's ley node", giver = "Shadow Priest Allister",
        "An archmage was waking the ley node at Ambermill, and Allister saw no way to stop it but his death. {We} fought through his mages and warders and killed him for his staff, and the ley energies sank back to sleep.",
        "{We} went into the heart of Ambermill, surer of {our} strength by then, and killed the archmage at the ley node. Allister took his staff and called it a major blow to Dalaran."},
    [98299] = {act = "put down the refugees at the Greymane Wall",
        "The worgen curse could not touch the Forsaken, but the human refugees gathered by the Greymane Wall might become Arugal's servants. {We} went to the wall and put them down, and Gilneas had let none of them through.",
        "Sent to the Greymane Wall to stop the curse before it spread, {we} took the warning not to get bitten. The refugees died there, and since Gilneas let no one past, the curse seemed unlikely to reach its city."},
    -- The Valley of Trials and Durotar.
    [4641] = {act = "reported to Gornek in the Den", solo = true,
        "Kaltunk looked {me} over at the edge of the valley and laughed at the thought of {me} strangling dragons barehanded. He sent {me} west to Gornek in the Den. Gornek called {me} a sorry sight, but promised {I} would leave the valley a proud fighter of the Horde.",
        "{My} first day in the Valley of Trials began with Kaltunk, who judged {me} of age to fight for the Warchief. In the Den, Gornek greeted Kaltunk's new recruit sternly and promised to make something of {me}."},
    [787] = {act = "heard Eitrigg speak of the new Horde", solo = true,
        "Old Eitrigg, charged by Thrall with training recruits, greeted {me} in the valley with his own past. He had left the Horde over the Legion's taint, and come back for Thrall's vision of a Horde free of demons.",
        "{I} met Eitrigg among the recruits of the valley, a veteran whom Thrall himself had rescued from human captors. He spoke of a Horde guided by its shamans, then sent {me} to Gornek for {my} first orders."},
    [788] = {act = "hunted mottled boars north of the Den", giver = "Gornek",
        "Gornek would not send a fresh recruit after kodo in the Barrens, since a live recruit was more use. {We} hunted the mottled boars north of the Den instead, and he gave {us} a little praise and a warning against pride.",
        "{Our} first hunt in the valley was against its mottled boars. Gornek judged it well done, then warned that harder opponents lay ahead and that the next trial would need better protection."},
    [97279] = {act = "salvaged training weapons for Kzan", giver = "Gornek",
        "So many recruits had come through the valley that Kzan, the weaponsmith in the Den, was short of training weapons. {We} gathered six that failed recruits had left lying among the boars, and Kzan set about mending them for the next wave.",
        "Out among the boars {we} picked up abandoned training weapons, left behind by recruits who had not made it. {We} carried six back to Kzan in the Den, who welcomed {us} and put them back in order."},
    [789] = {act = "took scorpid tails for Gornek", giver = "Gornek",
        "Gornek warned that veterans and novices alike had died of scorpid venom, and he kept antidote ready for young bloods like {us}. {We} brought him ten tails from the northwest, and he said he had nothing more to teach.",
        "{We} hunted the scorpids northwest of the Den for ten of their stinging tails. Gornek's last lesson was that even a small opponent could kill, and he promised to follow {our} progress."},
    [4402] = {act = "picked cactus apples for Galgar",
        "Galgar wiped his brow in the heat of the valley and wished for cactus apples. {We} picked ten among the cactus plants, and he made his famous cactus apple surprise with a little something extra for {us}.",
        "{We} gathered cactus apples around the valley for Galgar the cook. He turned them into portions of his cactus apple surprise for {us} to carry, along with a training manual."},
    [790] = {act = "killed Sarkoth for the wounded Hana'zua", giver = "Hana'zua",
        "{We} found Hana'zua bleeding beneath a tree, stung in the chest by a scorpid called Sarkoth, and begging for his honor. {We} climbed to the plateau to the south and killed the beast, and he could still see his own blow on its claw.",
        "Hana'zua lay wounded under a tree and feared dying unavenged. {We} hunted down Sarkoth on the plateau above. The young orc took a little pride in the mark he had left on its claw."},
    [804] = {act = "brought word of Hana'zua to Gornek", giver = "Hana'zua",
        "Hana'zua could not walk back to the Den, so {we} carried word of him to Gornek. Gornek knew Sarkoth from {our} account, sent help at once, and said fighting for a stranger's honor carried honor of its own.",
        "{We} ran back to the Den with news of the wounded Hana'zua. Gornek promised aid immediately, and was impressed that {we} had killed Sarkoth."},
    [792] = {act = "killed the Burning Blade's vile familiars", giver = "Zureetha Fargaze",
        "Zureetha Fargaze had found a taint in the valley, a coven of the Burning Blade in a cave to the northeast. {We} fought the vile familiars spilling from its mouth, {our} first blow against the cult, and she said greater deeds would follow.",
        "Imps of the Burning Blade, vile familiars, ran loose outside a cave in the valley. {We} cut them down for Zureetha Fargaze, who called them mere pets of the coven's darker powers."},
    [5441] = {act = "woke the lazy peons with a blackjack",
        "The lumber peons of the valley kept falling asleep on the job, and their overseer handed {us} a blackjack. {We} gave the sleepers a good smack and sent them back to work.",
        "{We} went through the trees of the valley with a blackjack, waking peons napping on the job. Their overseer hoped they would think twice before slacking again."},
    [6394] = {act = "brought Thazz'ril's pick out of the coven", giver = "Thazz'ril",
        "Thazz'ril had left his favorite pick in a cave now full of vicious beasts, the Burning Blade Coven. {We} went into the dark and found it glowing by a chamber of waterfalls, as his spell promised, and brought it back to him.",
        "{We} searched the Burning Blade Coven for a pick that shone in the dark, near the waterfalls inside. Thazz'ril had it back, and still hoped to find a place to mine."},
    [2161] = {act = "carried Ukor's food back to the inn at Razor Hill", giver = "Ukor",
        "Ukor the peon had braved scorpids and spiders to bring food to the valley, only to find it was not needed. He called {us} heroes and begged {us} to carry it back. {We} took it down the road to Innkeeper Grosk at Razor Hill.",
        "{We} carried a peon's unwanted load of food out of the valley to the inn at Razor Hill. Innkeeper Grosk knew it for Ukor's delivery and offered {us} refreshment."},
    [794] = {act = "took the Burning Blade Medallion from the coven", giver = "Zureetha Fargaze",
        "Zureetha Fargaze's divinations showed a medallion of power deep in the coven, perhaps held by one of the cult's agents. {We} went down past the beasts and black magic and took it. Zureetha was glad of it, but feared the Burning Blade had further aims in Durotar.",
        "Deep in the Burning Blade Coven {we} found the medallion Zureetha had seen in her divinations and brought it out. Zureetha was glad to see it, though she feared the cult had more in mind."},
    [96821] = {act = "thinned the spider nests along the road north",
        "Spiders had begun nesting along the road, and fewer travelers came from Razor Hill. {We} killed them on {our} way north and told Razor Hill the path was safer. The peons who had feared it could go back to work.",
        "A troll on the road asked {us} to thin the spiders on the road to Razor Hill. {We} cut through their nests and carried word to the town that the way was clearer."},
    [96822] = {act = "recovered fallen warriors' weapons from Tiragarde's ruins",
        "Many Horde warriors had died when Tiragarde Keep was sacked, and the humans' new walls kept their kin from honoring them. {We} searched the ruins for their weapons and brought them back, to be shown in a place of honor.",
        "{We} went among the reinforced ruins around Tiragarde Keep for the weapons of the Horde's dead. They would always be remembered now, because {we} had carried them home."},
    [96825] = {act = "picked prickly pears among the quilboar camps",
        "A cook for Orgrimmar's troops longed for something sweet and knew of a cactus fruit in the western hills. {We} slipped past the quilboar camps and brought back the prickly pears, as spiny as he had warned.",
        "{We} went into the western hills among the quilboar for a cook's prickly pears. He meant to make something tasty and save the seeds, and hoped one day they would grow all around Orgrimmar."},
    [96652] = {act = "returned a lost notebook to Brakk the adventurer",
        "{We} found a plain notebook full of someone's travels and nights spent camping. {We} returned it to its owner Brakk near Razor Hill, who had missed it and offered to teach {us} to camp.",
        "A lost notebook about camping led {us} to Brakk, an adventurer near Razor Hill. He was glad to have it back, and thought {we} had the look of adventurers too."},
    [805] = {act = "took word of the Burning Blade to Master Gadrin", giver = "Zureetha Fargaze",
        "Zureetha Fargaze sent {us} to Sen'jin Village to ask whether the Burning Blade had reached the trolls too. Master Gadrin said it had not, but its evil had taken root on the Echo Isles. The Darkspear needed help of their own.",
        "{We} left the Valley of Trials behind and went down to Sen'jin Village with Zureetha's warning. Master Gadrin heard it at a bad time, since the Echo Isles offshore had become the trolls' own trouble."},
    [823] = {act = "reported the Burning Blade to Orgnil Soulscar", giver = "Master Gadrin",
        "The trolls of Sen'jin thanked {us} and sent {us} north to Razor Hill with their troubles and {our} news from the valley. Orgnil Soulscar, who policed Durotar against evils like the Burning Blade, demanded to hear it all.",
        "{We} carried Sen'jin's plight and the word of the Burning Blade north to Orgnil Soulscar at Razor Hill. He wanted every detail of what {we} had seen in the valley."},
    [784] = {act = "stormed Tiragarde Keep against Lieutenant Benedict",
        "Admiral Proudmoore's men had broken the Warchief's pact, and now Lieutenant Benedict's reserves held Tiragarde Keep again. {We} went south and fought the humans there, and word of it travelled fast enough to be heralded in Orgrimmar.",
        "{We} stormed Tiragarde Keep against the Kul Tiran garrison that threatened Durotar once more. Razor Hill had ordered it as a matter of honor, and {we} came back having answered."},
    [830] = {act = "found Admiral Proudmoore's orders at Tiragarde",
        "In Tiragarde Keep {we} found an old envelope sealed with Admiral Proudmoore's mark. {We} carried it to Gar'Thok, Razor Hill's commander, who read troubling news in it.",
        "A document bearing Proudmoore's seal came out of the keep with {us}. Gar'Thok in Razor Hill opened it and did not like what he read."},
    [831] = {act = "carried Proudmoore's orders to Nazgrel in Orgrimmar", giver = "Gar'Thok",
        "Gar'Thok feared Proudmoore's plans would outlive the admiral, and sent {us} to Orgrimmar with the orders. {We} climbed to Thrall's chamber and gave them to Nazgrel, who would counsel the Warchief on them.",
        "{We} walked into Orgrimmar with a warning for the Warchief's own advisor. Nazgrel took Proudmoore's orders from {us} in Grommash Hold and prepared to put them before Thrall."},
    [786] = {act = "destroyed the Kolkar attack plans at Kolkar Crag",
        "A scout had found that the Kolkar centaurs planned a three-pronged attack on Durotar, the plans split among three of their leaders. {We} went over the ridge into Kolkar Crag, took the plans from each of them, and destroyed them.",
        "{We} slipped into Kolkar Crag and killed the three centaur leaders who carried the invasion plans. The Horde would have won anyway, the scout said, but this spared its warriors the bloodshed."},
    [818] = {act = "gathered makrura eyes and crawler mucus for an old troll",
        "An old troll whose eyes were failing leaned on alchemy now, and would take no apprentice he thought unworthy. {We} gathered intact makrura eyes and crawler mucus along the coast, and he said well done, young one.",
        "{We} went down to the shore for makrura eyes and vials of crawler mucus. The old alchemist who had asked had warned that patience was the true test, and {we} brought them all."},
    [825] = {act = "salvaged Alliance tools from Proudmoore's wrecked fleet",
        "Proudmoore's fleet still lay wrecked off the coast east of Tiragarde Keep, and the Horde wanted to learn the Alliance's machines. {We} swam through the wreckage for the tools, and they went to Orgrimmar with the next caravan.",
        "{We} dived among the sunken ships of Proudmoore's fleet and brought up the tools of the Alliance. Knowing how the humans' machines worked would help the Horde in battles to come."},
    [785] = {act = "took the Warchief's help to Lar Prowltusk", giver = "Gar'Thok",
        "The orcs and the Darkspear had sworn a pact, and Thrall wanted no direct threat to Sen'jin Village. {We} went out to Lar Prowltusk, one of the trolls' most trusted scouts, at his post on the village's western flank.",
        "{We} found Lar Prowltusk keeping watch west of Sen'jin, and offered him the help the Warchief's orders promised. The pact between orc and troll had sent {us} his way."},
    [815] = {act = "took taillasher eggs for Cook Torka",
        "Cook Torka had nearly forgotten breakfast, and the next meal at Sen'jin needed eggs from the Echo Isles. {We} dug three from the taillashers' nests, and Torka judged {us} weak but at least not clumsy.",
        "{We} crossed to the Echo Isles for taillasher eggs, buried deep where the beasts guarded them. Cook Torka took three and went back to his pot."},
    [817] = {act = "brought Durotar tiger furs to Vel'rin Fang",
        "Sen'jin was growing faster than its stores, and Vel'rin Fang needed tiger hides for blankets, armor and tents. {We} hunted Durotar tigers on the Echo Isles and brought back the furs, so the village would not go cold.",
        "{We} took the furs of Durotar tigers for Vel'rin Fang, who made the village's clothing and shelter from them. He still remembered his own first tiger hunt, on the largest of the isles."},
    [808] = {act = "freed Minshina's spirit from Zalazane's circle",
        "A troll at Sen'jin heard his dead brother Minshina calling in his dreams, his spirit trapped in his own skull by Zalazane. {We} found the circle of skulls on the largest Echo Isle, brought Minshina's back, and his brother said {we} had saved his spirit.",
        "{We} went to the largest of the Echo Isles for one skull among many in Zalazane's circle of power. With it back in his brother's hands, Minshina's soul was free."},
    [826] = {act = "killed the witch doctor Zalazane", giver = "Master Gadrin",
        "Zalazane sent hexed trolls from the Echo Isles to drag more Darkspear under his sway, from the islands the tribe once called home. {We} fought through his minions, killed him, and brought back his head, and Sen'jin could sleep in peace.",
        "{We} went to the heart of the Echo Isles and killed the witch doctor Zalazane among the trolls he had stolen from the Darkspear. The tribe owed {us} much, Master Gadrin said."},
    [96876] = {act = "returned Ukor's lost pack",
        "{We} found a pack with Ukor's name crudely stitched on its flap. {We} brought it back to the peon, who had dropped it fleeing a huge spider and never expected to see it again.",
        "Ukor the peon called {us} heroes when {we} handed back his pack. He had lost it running from a spider far bigger than he cared to fight."},
    [834] = {act = "recovered Rezlak's stolen supplies from the harpies", giver = "Rezlak",
        "Rezlak, one of Gazlowe's goblins, had lost his last shipment to the Dustwind harpies of Razorwind Canyon. {We} searched the canyon for the stolen sacks and brought them back, and he could get back to work.",
        "{We} went into Razorwind Canyon after the caravan sacks the harpies had snatched. Rezlak had his supplies, though he still needed someone to haul them."},
    [835] = {act = "drove the harpies from Drygulch Ravine", giver = "Rezlak",
        "Harpies in Drygulch Ravine threatened every new caravan, so {we} went in after them for Rezlak. He could breathe easy again, and told {us} to look up his boss Gazlowe in Ratchet.",
        "{We} cleared the harpies from Drygulch Ravine so Rezlak's caravans could get through. He paid as promised, and mentioned Gazlowe in Ratchet."},
    [837] = {act = "cleared the Razormane camps west of Razor Hill",
        "The Razormane quilboar still held fortified camps among the brambles west of Razor Hill. {We} drove them out, and word went back that their structures could be set on fire.",
        "{We} went into the bramble camps of the Razormane and emptied them. The orcs had driven out most of the quilboar already, and these lairs were the last they held near the town."},
    [816] = {act = "found what became of Kron",
        "Kron had gone west to hunt crocolisks on the Southfury River after an argument with his mother, and had not come back. {We} searched the crocolisks along the banks and found a sign of his fate, and she could finally begin to mourn.",
        "{We} brought a grieving mother proof that her son Kron was dead, taken from a crocolisk's belly on the Southfury. She gave {us} the gift she had kept for his return."},
    [806] = {act = "killed the warlock Fizzle Darkstorm in Thunder Ridge", giver = "Orgnil Soulscar",
        "Orgnil Soulscar had tracked a Burning Blade warlock, the goblin Fizzle Darkstorm, to Thunder Ridge in the northwest. {We} found his camp, killed him among his cultists, and brought Orgnil his claw.",
        "{We} went up into Thunder Ridge after Fizzle Darkstorm and his followers. Orgnil saw the warlock's claw and said Durotar was free of one more agent of evil."},
    [828] = {act = "sought out the shaman Margoz", giver = "Orgnil Soulscar",
        "Orgnil sent {us} to Margoz, a shaman camped between the coast and Drygulch Ravine, who knew of the cultists in Skull Rock. Word of {our} work had reached him already, and he called {us} a fighter of growing renown.",
        "{We} found Margoz in his camp to the northeast, as Orgnil had told {us}. He knew of {our} deeds in Durotar and urged {us} to stay on the pure path."},
    [827] = {act = "took searing collars from the cultists of Skull Rock", giver = "Margoz",
        "The cultists of Skull Rock, just outside Orgrimmar, wore collars that burned their flesh. {We} went into the cave and took them, and Margoz was sure the Burning Blade's secret hid within.",
        "{We} fought the Burning Blade in Skull Rock for their searing collars. Margoz turned them over in his hands and meant to learn how the cult drew on demonic power."},
    [829] = {act = "took a searing collar to Neeru Fireblade", giver = "Margoz",
        "The collars were beyond Margoz's skill as a shaman, so he sent {us} to a warlock, Neeru Fireblade, in the Cleft of Shadow. Neeru greeted {us} with great courtesy and took a closer look.",
        "{We} went down into Orgrimmar's Cleft of Shadow with a searing collar for Neeru Fireblade. Margoz had warned that Neeru claimed his research was benign, and left {us} to judge."},
    [832] = {act = "brought Neeru the pendant that spoke his name",
        "A pendant from Skull Rock spoke into {my} mind, a voice calling for Gazz'uz and threatening him with Neeru Fireblade. {We} took it to Neeru, who found it strange to be named and set about studying it.",
        "{We} carried the Eye of Burning Shadow to Neeru Fireblade in the Cleft of Shadow. He was known for hunting the Warchief's enemies, he said, and meant to ponder why the cult had singled him out."},
    [812] = {act = "ran to Orgrimmar for Rhinag's antidote", giver = "Rhinag",
        "Rhinag had been stung deep by a venomtail and reckoned he had an hour to live. {We} ran north to Kor'ghan in Orgrimmar's Cleft of Shadow and came back with the antidote in time. Rhinag pressed a gift on {us} for saving his life.",
        "{We} found Rhinag poisoned and too proud to go back to Sen'jin as he was. The antidote {we} brought him from Kor'ghan saved him, though he expected more rituals before he had proved himself."},
    [813] = {act = "gathered venomtail poison sacs for Kor'ghan", giver = "Kor'ghan",
        "Kor'ghan would not scold Rhinag for hunting venomtails without the antidote, not while one of his own lay dying. {We} took poison sacs from the venomtails by Orgrimmar's gate. He made the cure and sent {us} back with a warning to be careful.",
        "{We} hunted the venomtails near the entrance of Orgrimmar for the poison sacs Kor'ghan needed. He told {us} to study any creature {we} hunted, since that could save a life, and handed over the antidote."},
    [99048] = {act = "searched for Heglan Shadeeye near Tiragarde Keep",
        "Heglan Shadeeye of the Shattered Hand had watched Tiragarde Keep from a distance until her reports stopped. {We} went to find her and found her body cold in the wreckage of her hut, killed by something that did not seem human.",
        "{We} searched the hills near Tiragarde Keep for a silent watcher of the Shattered Hand. Heglan Shadeeye lay dead in her ruined hut, and the signs pointed to something worse than the human garrison."},
    [99049] = {act = "brought the naga's banner and blade to Orgnil", giver = "Orgnil Soulscar",
        "Around Heglan's ruined post {we} found what her attackers had left behind, a banner and a piece of a blade. Orgnil Soulscar knew them for naga work, come down the coast from the north. Razor Hill, he warned, could not take pressure from two directions.",
        "{We} brought Orgnil the evidence from Heglan's hut, and he named her killers at once as naga. He would not let them gain a foothold on Durotar's coast."},
    [99051] = {act = "slaughtered the naga scouts on the coast", giver = "Orgnil Soulscar",
        "Orgnil wanted the naga taught that they were not tolerated, so {we} found their scouts' camps along the coast and killed them. {We} brought back their fins, and he set grunts to watch for any stragglers.",
        "{We} hunted naga scouts in their new camps on the shore and carried their fins to Razor Hill. Orgnil hoped it would send them back north."},
    [99052] = {act = "killed the young sea giant that followed the naga", giver = "Orgnil Soulscar",
        "A young sea giant had followed the naga down the coast, big enough to rip an orc in half. {We} found it on the shore and brought it down, and Orgnil said few could claim to have survived such a fight.",
        "Orgnil advised {us} to bring help against the sea giant on the coast, and {we} killed it. He claimed to have heard its body fall from Razor Hill."},
    -- Orgrimmar: Thrall's hidden enemies, the Windshaper guest, and the end of the road.
    [5726] = {act = "took a Burning Blade lieutenant's insignia for Thrall", giver = "Thrall",
        "Thrall himself spoke to {us} in Grommash Hold. He would not tolerate traitors, and a young adventurer could go where his agents could not. {We} went into Skull Rock and took a lieutenant's insignia from the Burning Blade.",
        "The Warchief wanted the true head of the beast found, and the first step was an insignia from the cultists in Skull Rock. {We} brought it back to Thrall, who said it would be a vital tool."},
    [5727] = {act = "showed Neeru the insignia as one of his own", giver = "Thrall", solo = true,
        "Thrall told {me} that Neeru Fireblade, who believed he had the Warchief's trust, in truth led the Burning Blade. {I} took the insignia to him in the Cleft of Shadow, and Neeru took {me} for one of his own.",
        "{I} went down into the Cleft of Shadow wearing a cultist's insignia and spoke with Neeru Fireblade as a friend. Thrall called it a first step toward the Shadow Council's destruction and wanted every word Neeru had said."},
    [5728] = {act = "killed Bazzalan and Jergosh in Ragefire Chasm", giver = "Thrall",
        "Neeru had named the leaders of the Searing Blade, and Thrall wanted them dead without Neeru learning who had done it. {We} went down into Ragefire Chasm and killed the satyr Bazzalan and the warlock Jergosh, and the caverns fell into disarray.",
        "{We} slipped into Ragefire Chasm beneath the city and slew Bazzalan and Jergosh while keeping {our} cover. Thrall heard that Neeru was more than agitated."},
    [5729] = {act = "went back to an angry Neeru Fireblade", giver = "Thrall", solo = true,
        "Thrall wanted {me} close to Neeru while his anger ran high. {I} went back to the Cleft of Shadow. Neeru raged like a kodo bull about the leaders slain in Ragefire Chasm, then apologized to {me} and blamed himself.",
        "{I} stood before Neeru Fireblade as one of his followers while he cursed the deaths of Bazzalan and Jergosh. He never suspected that {I} had killed them."},
    [5730] = {act = "brought Neeru's new agenda back to Thrall", giver = "Neeru Fireblade", solo = true,
        "Neeru named {me} one of his lieutenants and spoke of new work for his agents in the Barrens and Ashenvale. {I} carried it all back to Thrall, who had heard nothing of the Council in Ashenvale and sent his spies to look.",
        "As one of Neeru's new lieutenants {I} learned of the Shadow Council's schemes beyond Ragefire Chasm. Thrall told {me} {I} had done well and promised to call on {me} again soon."},
    [5761] = {act = "slew Taragaman the Hungerer in Ragefire Chasm",
        -- (when the run's own lines told the kill: only what came of it)
        afterRun = {"{We} came up into {zone} with Taragaman's heart, proof for Thrall that the cult under his city had lost its master.",
            "Taragaman's heart came up out of the chasm with {us}, and with it the proof Thrall wanted that the Searing Blade had lost its felguard."},
        "The Searing Blade worked from Ragefire Chasm to subvert the Horde, led by a felguard named Taragaman the Hungerer. {We} went down into the fire beneath the city and killed him, and his heart went up to be shown to Thrall.",
        "{We} fought down through Ragefire Chasm to Taragaman the Hungerer and cut out his heart. The demon who had led the Searing Blade under the Warchief's own city was dead."},
    [95350] = {act = "carried the Windshapers' greeting to Thrall", solo = true,
        "The Earthen Ring sent {me} on as the Windshapers' emissary, and a wind rider carried {me} from Thunder Bluff to Orgrimmar. Thrall had been told to expect {me}, though not a high elf, and he welcomed {me} and granted passage through the Horde's lands.",
        "{I} stood before Warchief Thrall in Orgrimmar on behalf of the Windshapers, whose hope of survival lay with their new allies. He greeted {me} as a guest and gave {me} his blessing to travel."},
    [93739] = {act = "went to Nazgrel for directions through the Horde's lands", giver = "Thrall", solo = true,
        "The Horde's lands were vast, Thrall told {me}, and a guest should see Orgrimmar, Thunder Bluff and the Undercity in turn. He sent {me} to his advisor Nazgrel, who had the directions.",
        "{I} went from the Warchief to his advisor Nazgrel in Grommash Hold, meaning to see every capital of the Horde. A guest of the Horde, Thrall had said, should know its peoples."},
    [235] = {act = "answered the call to the Ashenvale Hunt",
        "A notice in the city called young adventurers north to Ashenvale, and {we} took the road past the Barrens to Splintertree Post. Senani Thunderheart welcomed {us} to the new frontier and explained her great hunt.",
        "{We} answered the call to Ashenvale and came to Splintertree Post, the Horde's foothold north of the Barrens. Senani Thunderheart said a fighter could find boundless chances there and told {us} to see the Zoram Strand as well."},
    [7783] = {act = "carried Nefarian's head to Thrall",
        "Before {us} lay the battle-scarred head of Nefarian, son of Deathwing, and {we} carried it home to Orgrimmar. Thrall said {we} had honored the Horde once more, and warned that the evil one surely stirred.",
        "By then the whole Horde knew {our} name. {We} brought Nefarian's head to Thrall, who wished he could have seen the beast's face at the killing blow."},
    [7784] = {act = "saw Nefarian's head raised in the Valley of Strength", giver = "Thrall",
        "Thrall sent {us} to High Overlord Saurfang in the Valley of Strength. There the head of Deathwing's son went up for all of Orgrimmar to see. Saurfang offered {us} a reward of {our} choosing.",
        "{We} walked through the Valley of Strength with Nefarian's head and gave it to High Overlord Saurfang. He mounted it high, where every orc in the city could see what {we} had brought down."},
    -- Red Cloud Mesa, the Rites of the Earthmother and Bloodhoof Village.
    [747] = {act = "hunted plainstriders for Grull Hawkwind", giver = "Grull Hawkwind",
        "Meat had run low at Camp Narache, and Grull Hawkwind sent {us} out onto the mesa after plainstriders. {We} brought back meat and feathers, and he thanked {us} for the tauren of Narache.",
        "{Our} first hunt on Red Cloud Mesa was for the plainstriders that fed and clothed the camp. Grull Hawkwind took the meat and feathers and saw promise in {us}."},
    [750] = {act = "hunted mountain cougars for their pelts", giver = "Grull Hawkwind",
        "A tauren hunted to live, not for trophies, Grull Hawkwind told {us}, and the camp's children needed clothing. {We} went into the hills to the south after the mountain cougars and brought their pelts back to mend the tents.",
        "{We} brought Grull Hawkwind cougar pelts from the southern hills to clothe the children of Narache. He promised to tell his father and said such skill would be honored one day in Thunder Bluff."},
    [752] = {act = "went to check on Greatmother Hawkwind at the well", giver = "Chief Hawkwind",
        "Greatmother Hawkwind had gone to the well southeast of the camp and was taking a long time. Her son the chief could not leave, so {we} walked out to her. The old woman was surprised anyone had come so far to help.",
        "Chief Hawkwind asked {us} to look in on his mother, since every member of the tribe shared its work. {We} found the Greatmother at the well southeast of Narache, glad of the company."},
    [753] = {act = "carried the Greatmother's water pitcher back to the chief", giver = "Greatmother Hawkwind",
        "Greatmother Hawkwind's legs had lost their strength, so she gave {us} her water pitcher for the walk back to her son. Chief Hawkwind took it and said that willingness to help would make the tribe proud in Thunder Bluff.",
        "{We} carried the Greatmother's pitcher from the well to Chief Hawkwind. Even the humblest task could earn an elder's notice, she had said, and the chief praised {us} for it."},
    [780] = {act = "hunted the Bristleback battleboars", giver = "Grull Hawkwind",
        "Bristleback battleboars, trained to be vicious, were pushing into the tribe's hunting grounds from Brambleblade Ravine. {We} hunted them for their snouts and flanks, which went into a stew for the young of Narache.",
        "{We} drove back the battleboars coming out of Brambleblade Ravine and carried their meat to the camp. The dead boars were meant as a lesson to the Bristlebacks."},
    [755] = {act = "went to Seer Graytongue to begin the Rites of the Earthmother", giver = "Chief Hawkwind", solo = true,
        "Chief Hawkwind saw greatness ahead for {me} and sent {me} to begin the Rites of the Earthmother. In the hills south of the camp, Seer Graytongue heard the chief's name and warned that the rites were no small task.",
        "{I} climbed into the hills south of Camp Narache to Seer Graytongue, who would set {me} on the first of three rites. Strength came first, he said, and none of it would be easy."},
    [757] = {act = "passed the Rite of Strength against the Bristlebacks", giver = "Seer Graytongue", solo = true,
        "For the Rite of Strength {I} went against the Bristlebacks of Brambleblade Ravine, who ambushed the tribe's hunters and stole from Narache. {I} brought their belts to Chief Hawkwind, and he said the tribe would be proud.",
        "{My} first rite of the Earthmother was fought in Brambleblade Ravine against the quilboar raiders. Chief Hawkwind took the Bristleback belts as proof of {my} valor."},
    [781] = {act = "brought the Bristleback siege plans to Chief Hawkwind",
        "Among the quilboar {we} found a map. Reading it carefully, {we} saw the Bristleback warchief's plan for a long siege of Camp Narache. Chief Hawkwind called it alarming, sent for help from Bloodhoof Village, and said {we} had saved many lives.",
        "{We} carried a Bristleback map to Chief Hawkwind before the siege it planned could begin. With it he could call on Bloodhoof Village to break the attack."},
    [3376] = {act = "brought Chief Sharptusk's head to Brave Windfeather", giver = "Brave Windfeather",
        "Others had failed against Chief Sharptusk Thornmantle, who led the Bristleback war on the tauren, and Brave Windfeather hoped {we} would not. {We} went into his makeshift village in the ravine, killed him, and brought back his head.",
        "{We} hunted the Bristleback chief Sharptusk Thornmantle in Brambleblade Ravine, the greatest hunt a tauren could ask for, by Windfeather's account. Windfeather declared justice served and his death a warning to any who threatened the tribe."},
    [1656] = {act = "carried a tired tauren's furs to Innkeeper Kauth",
        "A young tauren in the middle of the Rite of Strength was too tired to carry a father's furs to the inn as well. {We} took them down off the mesa to Innkeeper Kauth at Bloodhoof Village, who made blankets of them for his guests.",
        "{We} carried a bundle of furs from the mesa to Bloodhoof Village, a long walk for a newcomer. Innkeeper Kauth had them sooner than he expected and said his inn was open to all his people."},
    [763] = {act = "carried Hawkwind's totem to Baine Bloodhoof", giver = "Chief Hawkwind", solo = true,
        "Two rites remained, and they lay beyond the camp. Chief Hawkwind carved a totem for Baine Bloodhoof, and {I} carried it down from Red Cloud Mesa. Baine knew his good friend's carving at once.",
        "{I} went down from the mesa into Mulgore's open plains with Chief Hawkwind's totem. Baine Bloodhoof read it as word from a friend and said it marked {me} as a special breed."},
    [767] = {act = "went to Zarlman Two-Moons for the Rite of Vision", giver = "Baine Bloodhoof", solo = true,
        "The land was the tauren's most holy provider, Baine said, and he sent {me} to Zarlman Two-Moons for the Rite of Vision. The spiritual leader of the village said he had sensed {me} coming.",
        "{I} sought out Zarlman Two-Moons in Bloodhoof Village for the second rite. He could always tell, he said, who was trying to pass the rites."},
    [771] = {act = "gathered well stones and ambercorn for the Water of the Seers", giver = "Zarlman Two-Moons", solo = true,
        "Zarlman needed well stones from around Mulgore's wells and ambercorn fallen under its great trees to brew the Water of the Seers. {I} gathered both from the sacred land, and he needed only a moment to make the brew.",
        "{I} walked from well to well across the plains and searched under the great trees for ambercorn. Zarlman saw that {I} had learned to gather from the land, and set about the brew."},
    [772] = {act = "followed the vision of the Water of the Seers", giver = "Zarlman Two-Moons", solo = true,
        "{I} drank the Water of the Seers by the tribal fire, and after a few moments a vision rose before {me}. {I} followed it to its end, and there the Rite of Vision was passed, with a word not to be afraid.",
        "By the fire in Bloodhoof Village the Water of the Seers brought {me} a vision. Zarlman had told {me} to follow wherever it went. At its end {my} second rite was done."},
    [773] = {act = "received the blessing of the ancestral spirits at Red Rocks", giver = "Seer Wiserunner", solo = true,
        "Only one rite remained, the Rite of Wisdom, and {I} went east of Thunder Bluff to Red Rocks. The ancestral spirit there spoke for the tauren who had died founding the city. It handed their duty to {me}, and bade {me} enter Thunder Bluff with pride.",
        "Among the graves at Red Rocks {I} met the Ancestral Spirit, who blessed only those who had drunk the Water of the Seers. With the Rite of Wisdom the last of the three rites was done."},
    [775] = {act = "climbed Thunder Bluff to meet Cairne Bloodhoof", solo = true,
        "Having passed the rites, {I} would be revered in Thunder Bluff, and {my} last errand was to its leader. {I} climbed to the highest mesa of the city, and Cairne Bloodhoof greeted {me} at his door.",
        "{I} went up into Thunder Bluff as one who had passed the Rites of the Earthmother. At the top of the highest mesa Cairne Bloodhoof himself welcomed {me}."},
    [776] = {act = "hunted the great kodo Arra'chea for Cairne", giver = "Cairne Bloodhoof",
        "To keep {my} place among {my} people Cairne wanted proof of {our} skill as hunters, the horn of the great kodo Arra'chea. {We} tracked it on the plains of Mulgore and brought the horn back, and he sent a party for the hide and meat.",
        "{We} brought down Arra'chea, the mighty kodo of the plains below Thunder Bluff, and carried its horn to Cairne Bloodhoof. He called it a fine kill and a great deed for the tauren."},
    [748] = {act = "gathered paws and talons for Mull Thunderhorn's first totem", giver = "Mull Thunderhorn",
        "Goblins had poisoned Mulgore's sacred wells, and Mull Thunderhorn meant to make a cleansing totem for each. {We} hunted prairie wolves and adult plainstriders for their paws and talons, and he set about binding their power into the first.",
        "{We} brought Mull Thunderhorn wolf paws and plainstrider talons, the land's own aid for the Winterhoof totem. The well was still poisoned, but now he could begin."},
    [754] = {act = "cleansed the Winterhoof Water Well", giver = "Mull Thunderhorn",
        "{We} carried Mull's first totem southeast past the goblins who guarded the Winterhoof Water Well and performed the cleansing there. By the time {we} returned the beasts were already drinking from it, Mull said. He called it a great thing for the land.",
        "At the Winterhoof Water Well {we} set Mull Thunderhorn's totem and took the goblins' poison out of the water. The well ran clean again."},
    [756] = {act = "took stalker and cougar claws for the Thunderhorn totem", giver = "Mull Thunderhorn",
        "The Thunderhorn Water Well grew fouler by the hour, and its totem needed the claws of the plains' hunters. {We} took them from prairie stalkers and flatland cougars. Mull said the goblins would never learn the difference between fighting the land and living with it.",
        "{We} hunted prairie stalkers and flatland cougars east and west of the village for Mull's second totem. The purity of their hunting mattered to it, he said."},
    [758] = {act = "cleansed the Thunderhorn Water Well", giver = "Mull Thunderhorn",
        "{We} took the second totem north of the village to the Thunderhorn Water Well and performed the ritual. That night, Mull said, the Thunderhorn ancestors praised the deed in his dreams, and he passed their gift on to {us}.",
        "The Thunderhorn Water Well ran clean once {we} had set Mull's totem beside it. He told {us} the spirits of his clan had spoken of it in a dream."},
    [759] = {act = "took prairie wolf alpha teeth for the last totem", giver = "Mull Thunderhorn",
        "Only the Wildmane Water Well was left, and its totem needed the teeth of the prairie wolf alphas near the foot of Thunder Bluff. {We} brought them back, and Mull felt the land's sacrifice in them, with sadness and with pride.",
        "{We} hunted the prairie wolf alphas below Thunder Bluff for Mull's last totem. He held their teeth and said his spirit swelled with both sorrow and pride."},
    [760] = {act = "cleansed the Wildmane Water Well", giver = "Mull Thunderhorn",
        "{We} carried the last totem north of Thunder Bluff to the Wildmane Water Well, the only one still fetid. Clean water flowed there again, Bloodhoof Village was grateful, and Mull wished Mulgore's waters would stay clean forever.",
        "With the Wildmane totem set, the last of the poisoned wells ran clean, and every well {we} had tended was healed. Mull Thunderhorn said the spirits already spoke of the work."},
    [761] = {act = "gathered swoop quills for Harken Windtotem", giver = "Harken Windtotem",
        "Swoops ranged all over Mulgore and were hard to find and harder to catch. {We} chased them across the plains for their quills, and Harken Windtotem called it a badge of cleverness.",
        "Harken Windtotem said a hunter needed sharp eyes and quick hooves for the swoop. {We} brought him their quills, and he knew they had not been easy to gather."},
    [743] = {act = "fought the Windfury harpies on the mountain edges", giver = "Ruul Eagletalon",
        "Ruul Eagletalon wanted {us} tested before {we} went adventuring beyond Mulgore. He set the Windfury harpies on the southeastern mountain edges as the measure. {We} fought them, and he judged {us} ready and wished the wind always at {our} back.",
        "{We} climbed off the road to the harpy nests on the mountain edges of the southeast. Ruul Eagletalon, warrior and teacher, called the fight well done and sent {us} on with the wind's blessing."},
    [745] = {act = "drove back the Palemane gnolls", giver = "Baine Bloodhoof",
        "The Palemane gnolls south of Bloodhoof Village killed Mulgore's wildlife without restraint and scorned every word of peace. Baine Bloodhoof sent {us} against them, and afterward told {us} that death and life were a circle and the land must be respected.",
        "{We} went south of the village and fought the gnolls who had wasted the plains' creatures. Baine was glad {we} had taken it seriously, and asked that the lesson never be forgotten."},
    [746] = {act = "smashed the dwarves' digging tools", giver = "Baine Bloodhoof",
        "Dwarves were digging northwest of Bloodhoof Village, and Baine feared it would enrage the kodos. {We} took their tools and smashed them at a forge, and Baine said the land's secrets were not won by hollowing it out.",
        "{We} raided the dwarves' dig for their tools and broke them at a forge. Baine Bloodhoof hoped it would calm the beasts of Mulgore and teach the diggers a lesson."},
    [766] = {act = "gathered a remedy for Mazzranache's bite", giver = "Maur Raincaller",
        "Maur Raincaller had met Mazzranache on the plains, the red-eyed strider his grandfather used to speak of, and its bite had festered. {We} gathered a wolf heart, a cougar femur, a plainstrider scale and a swoop gizzard, and he said he owed {us} his life.",
        "{We} hunted across the plains for the four things Maur Raincaller needed against Mazzranache's poison, and came back in time. He would never forget the strider's screeching call, he said."},
    [749] = {act = "searched the ravaged caravan at Stonebull Lake", giver = "Morin Cloudstalker",
        "The Outrunners had burned a Venture Company caravan by Stonebull Lake, and now salvagers picked over its wagons. {We} went to look at the crates for Morin Cloudstalker and found them stamped with the mark of the company's Mining Division.",
        "{We} reached the burned wagons on the north shore of Stonebull Lake while goblin salvagers were still at work. The crate {we} opened was bound for a Venture Company plant."},
    [751] = {act = "brought the caravan's papers to Morin Cloudstalker",
        "Under the crate's lid lay ore from Mulgore and a bound sheaf of papers, and smoke rose in the foothills to the east. {We} carried the papers to Morin Cloudstalker, who read them as proof the goblins were robbing the land.",
        "{We} brought Morin Cloudstalker the Venture Company's papers and a sample of the ore they had dug. It was good to know for certain, he said, and now something had to be done."},
    [764] = {act = "sent the Venture Company a message at their mine", giver = "Morin Cloudstalker",
        "The Venture Company had been refused mining rights in Mulgore and was digging anyway. {We} went to their mine northeast of the ravaged caravan and gave them Morin's message, and he doubted they could misread it.",
        "Morin Cloudstalker meant to show the goblins Mulgore was not for sale, and {we} carried that message into their mine with weapons. He was satisfied the Venture Company would not take the tauren lightly again."},
    [765] = {act = "killed Supervisor Fizsprocket in the Venture mine", giver = "Morin Cloudstalker",
        "The papers showed the Venture Company meant to drive the tauren from Mulgore, and Supervisor Fizsprocket was behind it. {We} went deep into the mine, killed him, and brought Morin his clipboard, and Morin's anger eased a little.",
        "{We} found Supervisor Fizsprocket in the depths of the Venture Company mine and took his clipboard from his body. Morin Cloudstalker meant to read the company's next plans in it."},
    [744] = {act = "gathered harpy feathers for Eyahn Eagletalon's headdress", giver = "Eyahn Eagletalon",
        "Eyahn Eagletalon was making a headdress for his brother's ceremony before Cairne Bloodhoof and had no time to gather feathers. {We} brought him six azure and six bronze harpy feathers, and his design was complete.",
        "{We} hunted harpies for the feathers missing from a ceremonial headdress. Eyahn Eagletalon had only to give it to his brother and watch the ceremony."},
    [833] = {act = "drove the Bristlebacks from the graves at Red Rocks",
        "Bristleback intruders were ravaging the graves at Red Rocks, where the tauren who founded and defended Thunder Bluff lay. {We} went up among the burial grounds and drove them back.",
        "{We} fought the quilboar desecrating the sacred burial ground at Red Rocks. The tauren's honored dead were left in peace."},
    [861] = {act = "brought prowler claws to Melor Stonehoof", giver = "Skorn Whitecloud", solo = true,
        "Skorn Whitecloud sent {me} to Melor Stonehoof on Thunder Bluff's Hunter Rise, with flatland prowler claws as proof of {my} skill. Melor took the claws and recognized Skorn's word for {me}.",
        "{I} hunted flatland prowlers on the plains and carried their claws up to the Hunter Rise of Thunder Bluff. Melor Stonehoof accepted them on Skorn Whitecloud's recommendation."},
    [96659] = {act = "carried Chief Hawkwind's supplies to Kaga Wildhoof", giver = "Chief Hawkwind",
        "Kaga Wildhoof had once helped Chief Hawkwind and refused any payment, so he sent {us} to her camp outside Bloodhoof Village with supplies. She noted the chief had not listened to her, took them anyway, and offered to teach {us} to camp in the wild.",
        "{We} found the adventurer Kaga Wildhoof camped just outside Bloodhoof Village and handed her Hawkwind's gift. In return she offered {us} lessons in camping."},
    [99079] = {act = "searched for the missing Longwalker Malah", giver = "Brave Wildrunner",
        "Longwalker Malah had gone to watch the eastern borders and had not come back in three days. Brave Wildrunner could not leave the village, so {we} went. {We} found her dead, her back and the ground around her full of arrows.",
        "{We} went east looking for Longwalker Malah, one of the High Chieftain's trusted scouts. She had not died naturally, and the arrows lay thick around her body."},
    [99081] = {act = "brought Malah's report back to Brave Wildrunner",
        "Malah still clutched her report, and the arrows in her back pointed to a new centaur camp where a raiding party stirred. {We} carried the grim news to Brave Wildrunner, who said Baine had to be told at once.",
        "{We} took the dead Longwalker's report from her hand and brought it to Brave Wildrunner in Bloodhoof Village, who called the news dire."},
    [99101] = {act = "delivered the Longwalker's report to Baine Bloodhoof", giver = "Brave Wildrunner",
        "{We} brought Malah's report to Baine Bloodhoof at the center of the village. His gaze darkened as he read it, and he said the centaur incursion would not stand.",
        "Brave Wildrunner sent {us} on to Baine with the dead Longwalker's words. Baine read of the centaur camp and declared it would not stand."},
    [99080] = {act = "destroyed the centaur raiders' camp", giver = "Baine Bloodhoof",
        "Baine would not yield a blade of grass to the centaur. He sent {us} to destroy their camp before they could ride on the village. {We} killed the raiders and their leader, and Baine said he had heard the moment the last of them fell.",
        "{We} struck the centaur camp in the east and brought Baine the head of the raiding party's leader. He gave {us} his deepest thanks and said the village's young were safer for it."},
    [99082] = {act = "carried Baine's word of the victory to Cairne", giver = "Baine Bloodhoof",
        "Baine wanted his father to hear of the defense. {We} climbed to the central rise of Thunder Bluff to tell the High Chieftain. Cairne Bloodhoof, who had ridden with young Thrall to free the plains from the centaur, said {we} had brought pride to the ancestors.",
        "{We} stood before Cairne Bloodhoof with news of the Galak driven from Mulgore. He was angry they had dared show themselves, and honored {us} with a gift."},
    [98430] = {act = "rescued Longwalker Perith Stormhoof from the gnolls",
        "Longwalker Perith Stormhoof had gone to Bleachmane Rock on Cairne's orders to speak with the gnolls, and they had answered with violence. {We} got him out before they made a feast of him, and Cairne said the rescue served the tauren more than anyone knew.",
        "{We} brought Perith Stormhoof, Cairne Bloodhoof's most trusted scout, safely away from the gnolls of Bleachmane Rock. Cairne thanked {us} for risking {our} lives and offered the hospitality of Thunder Bluff."},
    [98424] = {act = "brought Fizsprocket's hidden notes to Morin Cloudstalker",
        "In Supervisor Fizsprocket's breast pocket {we} found worn papers folded apart from the rest, detailing the Venture Company's work in the region. {We} took them to Morin Cloudstalker, who judged them most valuable and said the next move was clear.",
        "{We} carried the supervisor's private notes to Morin Cloudstalker in Bloodhoof Village. He found in them what he needed against the company."},
    [98427] = {act = "stopped the Venture Company shredder in the mine", giver = "Morin Cloudstalker",
        "Fizsprocket's notes spoke of a shredder in the mine, and Morin had seen such machines erase whole glades in days. {We} gathered others as he advised, went in and stopped it, and he said all of Bloodhoof Village was in {our} debt.",
        "{We} went back into the Venture Company mine for the shredder that threatened the trees near the village. Morin asked the Earth Mother's grace for {us} once it would fell no more."},
    [98435] = {act = "took Mull Thunderhorn's report to Hamuul Runetotem", giver = "Mull Thunderhorn",
        "Mull Thunderhorn wanted the elders to know what had been done for Mulgore's wells. {We} carried his report up to Arch Druid Hamuul Runetotem on the Elder Rise. Hamuul said he could feel the joy running through the streams.",
        "{We} brought word of the cleansed wells to Hamuul Runetotem in Thunder Bluff. The wells sustained the tauren and the beasts they lived by, he said, and he gave {us} a token of thanks."},
    [770] = {act = "brought Ghost Howl's scarred hide to an old hunter",
        "{We} brought down Ghost Howl, the great white wolf, and his hide still bore a terrible wound from battles against the Burning Legion. An old hunter in Bloodhoof Village could barely believe it, and gave {us} a weapon of his own.",
        "Into Bloodhoof Village {we} carried the demon-scarred cloak of Ghost Howl. The aging hunter who saw it hoped the wolf's spirit had found peace, and parted with a weapon from his hunting days."},
    [95349] = {act = "reached Alaana Stormwalker in Mulgore with the Windshaper vanguard", solo = true,
        "The crisis on Zephras had delayed the Windshaper delegation, so {I} sailed ahead with a small vanguard. In Mulgore {I} met Alaana Stormwalker of the Earthen Ring, who had been waiting for the first of {us}.",
        "{I} came from Zephras to Mulgore among the first Windshapers to arrive. Alaana Stormwalker received {me} while the rest of the delegation was still delayed."},
    [768] = {act = "traded skins to Veren Tallstrider", solo = true,
        "Veren Tallstrider made clothes and armor for the people of Thunder Bluff from the skins of the hunt. {I} brought him hides from the plains, and he called them very nice pieces and traded something of his own for them.",
        "{I} carried skins up to Veren Tallstrider, the leatherworker of Thunder Bluff. He said they would make fine leather goods and paid with a piece of his craft."},
    [769] = {act = "learned the Kodo Hide Bag from Veren Tallstrider", solo = true,
        "Veren Tallstrider taught the Kodo Hide Bag only to leatherworkers who brought supplies for his trade. {I} brought them, and he showed {me} the pattern, his heart swelling to see the young take up the craft.",
        "The kodo's strength was respected among the tauren, and so was a bag made from its hide. {I} paid Veren Tallstrider in supplies and learned the pattern from him."},
    -- Zephras Isle: Thendal Grove, Shen'dar and the Al'Aketh.
    [92460] = {act = "came of age before Rorian the Dayseeker", solo = true,
        "Ailee greeted {me} bright-eyed in Thendal Village and sent {me} to Rorian the Dayseeker at the greatfather tree. He gave {me} {my} coming-of-age relic, carried by many before {me}. He said the winds of home would go with {me} wherever {I} travelled.",
        "{I} came of age at the greatfather tree, where Rorian the Dayseeker recognized what {I} might bring the shen'dorei. The relic he gave {me} would one day pass on to another, when {my} ashes were scattered to the winds."},
    [92461] = {act = "culled the vuldren of Thendal Grove",
        "The vuldren of the grove had grown too many to sustain, and {we} went east to cull them. Usually they were docile, {we} learned, but the animals of Zephras could sense when the magic on the winds was out of balance.",
        "{Our} first task on the island was an ordinary one, thinning the vuldren east of the village. Even the mundane mattered now, in such uncertain times for the shen'dorei."},
    [92462] = {act = "exterminated cirrusflies at the east end of the grove",
        "A ranger had reported cirrusflies swarming at the eastern end of Thendal Grove, and {we} went to kill as many as {we} could. {We} came back covered in bug entrails, which told the rangers all they needed about the size of the swarm.",
        "{We} fought the cirrusfly swarm in the east of the grove before it could grow dangerous. Judging by the state of {us}, the rangers said, it was quite an infestation."},
    [92463] = {act = "killed the cirrusfly queen at her hive",
        "Killing workers would never end the infestation, so {we} went deeper into the forest for the cirrusfly queen. {We} put her down by her hive among her bigger soldiers, and the ranger who had sent {us} called it excellent work.",
        "{We} found the cirrusfly hive deep in the forest and killed its queen among her soldiers, the bigger the meaner. One less problem for the grove to think about."},
    [92464] = {act = "found Yala Windwatcher at the standing stones", giver = "Rorian the Dayseeker",
        "Since the elemental benefactors left the island, Rorian said, it had been one unrest after another. Now the wind sprites by the standing stones were agitated. {We} went northeast to his apprentice Yala Windwatcher, who was glad of {our} aid.",
        "{We} went out to the standing stones northeast of the village to see what had stirred the simple wind sprites. Yala Windwatcher was watching them and could use the help."},
    [92465] = {act = "dispersed the angry sprites and the Al'Aketh agitators", giver = "Yala Windwatcher",
        "Yala blamed the Al'Aketh cult for turning the simple wind sprites violent. {We} dispersed the roiling winds and fought the cultists among the stones, and it pained her to shed shen'dorei blood in the grove.",
        "Cultists of the Al'Aketh had stirred the sprites at the standing stones into violence, and {we} helped Yala Windwatcher end it. The cult had its message that it was not welcome in the grove."},
    [92469] = {act = "told Rorian of the cult at the standing stones", giver = "Yala Windwatcher",
        "{We} went back to the village and told Rorian the Dayseeker that the Al'Aketh had stirred the sprites. He was troubled but unsurprised, since the grove had watched the cult from afar, and he called it a clear escalation.",
        "Rorian heard {our} word of the cult at the stones and thanked {us} for a hard but needed service to Thendal Grove. The Al'Aketh were no longer content to keep their distance."},
    [94414] = {act = "looked upon the anchor pylon with Halaan Hawk-Eye", solo = true,
        "Halaan Hawk-Eye often came to look on the ancient anchor pylon. It was a gift of the wind spirits that held Zephras together, its magic now unsteady. {I} took the gift Halaan offered and looked too, and Halaan was grateful for the shared moment.",
        "{I} stood with Halaan Hawk-Eye before the anchor pylon that sustained the island. Yearning for what was lost led only to despair, Halaan said, and went on watching over the grove."},
    [92474] = {act = "leapt from a ledge to startle Rorian", solo = true,
        "Myriaal Mistwake dared {me} to jump from a ledge, slow the fall on the air, and land in front of Rorian the Dayseeker. {I} did, and Rorian grumbled that Myriaal kept encouraging reckless use of the skyborne gift.",
        "{I} leapt and floated down on {my} skyborne gift to land before a startled Rorian, as Myriaal had dared. Rorian warned {me} not to waste the gift, though a little practice in the village was acceptable."},
    [92598] = {act = "used skysight at the elemental convergence", giver = "Ventaari Brightwish", solo = true,
        "Ventaari Brightwish taught {me} skysight, the gift of the elemental spirits. It ran strongest at the convergence among the standing stones. {I} used it there, and Ventaari said hearing the elements might be the key to the Windshapers' survival.",
        "At the standing stones northeast of the village {I} drew on the skysight Ventaari had shown {me}. It had to be exercised like a muscle, she said, and bridging the mortal and spiritual could prove invaluable."},
    [92597] = {act = "tapped the ley line at the standing stones", solo = true,
        "A ley line had broken the surface by the standing stones. {I} went there to draw its energy into {me} as {my} birthright. {My} teacher said {I} had taken {my} first steps, and that the shen'dorei must search for knowledge and power to survive.",
        "{I} felt the arcane energy of the ley line at the standing stones, latent power running under the island's soil. Such energy, {I} learned, could be found and tapped in many places."},
    [93552] = {act = "harvested raw windstones around the grove",
        "The wind elementals had left Zephras centuries ago, and the magic that sustained the island was fading. {We} gathered raw windstones around the grove, each holding the concentrated energy of the winds, and were given a manual for {our} trouble.",
        "{We} harvested windstones scattered across the grove, precious now that the anchor pylons were weakening. Every elf had a deep tie to magic, said the one who took them, and these stones held it."},
    [92473] = {act = "culled the starving ursera in the southwestern den", giver = "Valreaa Valewind",
        "Only last week a young ursera had nearly attacked a boy by the elder tree. Valreaa Valewind wanted the hungry beasts in the southwestern den thinned. {We} put down the scrawniest and brought back their claws, and the Rangers of the Grove were in {our} debt.",
        "{We} went into the ursera den southwest of the village and culled the beasts that hunger had made dangerous. Valreaa took the claws, still wondering what had made them so fierce."},
    [92471] = {act = "went before Aetheen of the Gales", giver = "Rorian the Dayseeker", solo = true,
        "Everything {I} had done in Thendal had been a trial of sorts, Rorian said, and Aetheen of the Gales had been watching. {I} went to her, one of the island's elders come to read the winds. She asked whether {I} stood ready to serve Zephras.",
        "Rorian sent {me} to Aetheen of the Gales, a member of the Council of Elders, who had heard much of {me}. She asked whether the next step could begin."},
    [92470] = {act = "killed the ursera matriarch Urs'anah", giver = "Aetheen of the Gales",
        "Aetheen of the Gales offered a dangerous test of resolve, the ursera matriarch the rangers called Urs'anah, in the caves south of the village. {We} went into the dark and killed her, and Aetheen said {our} path now led beyond the safety of Thendal.",
        "{We} faced Urs'anah, matriarch of the southern caves, as Aetheen's first real challenge and came back victorious. She saw great promise and said it was time to look beyond the village."},
    [92544] = {act = "routed Malduko Cloudcrush's thugs at the temple ruins", giver = "Hanaa Nightwind",
        "Al'Aketh ruffians under Malduko Cloudcrush camped by the temple ruins southwest of the grove, attacking travelers and pressing them into the cult. Hanaa Nightwind could not leave her post, so {we} went and dealt with them. She thanked {us} for the Rangers of Thendal Grove.",
        "{We} fought Malduko Cloudcrush and his thugs at the old temple ruins. Hanaa Nightwind said she had barely kept herself from joining in, and hoped the cult had got the message."},
    [92472] = {act = "went south to Constable Aonda in Shen'dar", giver = "Aetheen of the Gales",
        "The Al'Aketh worshipped Al'Akir the Windlord and grew deadlier by the day, and Aetheen sent {us} south to help Shen'dar Village. Constable Aonda said {we} did not look like much, but would not refuse help Elder Aetheen had sent.",
        "{We} left Thendal Grove behind for Shen'dar Village and reported to Constable Aonda. The doubts were plain, but so was the need."},
    [96638] = {act = "visited Raan Wildwind's camp outside Shen'dar",
        "More of the island's young were seeking fortune beyond the grove, and an adventurer had made camp on the road southwest of it. {We} found Raan Wildwind outside Shen'dar Village, and he greeted {us} heartily.",
        "Aetheen sent {us} to learn from Raan Wildwind, an adventurer camped near Shen'dar Village. {We} found his camp on the road southwest of Thendal Grove and a warm welcome there."},
    [92517] = {act = "cleared the bandits from the cave behind the waterfall", giver = "Constable Aonda",
        "Bandits had worked from a cave behind a waterfall north of Shen'dar for years, and since the cult came they had become a terror. {We} went in after them and their leader, \"Badwind\" Bennic. Aonda took the win, though she feared the survivors would run to the cult.",
        "{We} found the hidden cave behind the waterfall and scattered the bandits inside. Constable Aonda had no people to spare for it, and she was glad of one less problem."},
    [92528] = {act = "slipped into Falaath Village among the cult's recruits", solo = true,
        "{I} walked into Falaath Village as one more eager recruit of the Al'Aketh, warned off the inn where Skypriest Aanders had a guest. {I} learned enough to bring Constable Aonda the name Lorthuna, the cult's own leader, and her plans against Shen'dar and the western watchtower.",
        "Among the faithful of Al'Akir in Falaath {I} played the unshaven recruit and listened. Aonda heard {my} report with alarm, ready for the attack on the village but puzzled why anyone wanted the western watchtower."},
    [93926] = {act = "carried the recall order to the western watchtower", giver = "Constable Aonda",
        "Aonda would not lose her people over a minor lookout post, so she sent {us} southwest to call Peacekeeper Vaaniel home. {We} found him at the tower already dead, his skin burned and scorched by the cult's storm magic.",
        "{We} hurried to the western watchtower with orders for its defenders to fall back to the village. The recall came too late for Peacekeeper Vaaniel, freshly killed by the cult's spellcasters."},
    [93927] = {act = "stopped the cultists at the anchor pylon", giver = "Constable Aonda",
        "A bloody note fell from the dead peacekeeper's hands, and it led {us} on to the cultists at work by the pylon. {We} killed their priest and stopped them, and found a great cache of windstones there, which troubled Aonda more than anything.",
        "Following the dead peacekeeper's last note, {we} fell on the cult's priest and cultists at the tower. Constable Aonda cursed the cult for her dead and wondered what such a store of windstones was meant to power."},
    [92579] = {act = "carried Aonda's report to Valennia Stormfist in Valanaar", giver = "Constable Aonda",
        "Aonda told {us} {we} would always have friends in Shen'dar and sent {us} southeast to Valanaar with her report. Valennia Stormfist, leader of the island's peacekeepers, read it with a darkening face. She said she would try to trust {us} as Aonda did.",
        "{We} crossed the island to Valanaar on its southeastern edge with word of the cult's moves. Valennia Stormfist had to plan for a fight now, and told {us} to keep busy in the city meanwhile."},
    [93949] = {act = "exterminated the enchanted skyhoppers around Valanaar",
        "A High Order mage had found a listening spell on a dead skyhopper. The peacekeepers suspected the cult of using the insects as spies. No one could tell the enchanted ones by looking, so {we} killed every skyhopper {we} found.",
        "It was skyhopper season in the lowlands, and {we} stamped out the pests around Valanaar in case they carried the cult's spells. Each one made the city a little safer, the peacekeepers said."},
    [93735] = {act = "went to help Riaani with a broken wind construct",
        "The Windshapers tended the constructs the wind spirits had left them, and only a few still worked. At the west end of Valanaar {we} found the artisan Riaani with his head buried in a damaged one. He was cursing because someone had taken its core.",
        "{We} found Riaani wedged under the armor plates of a broken construct, too busy to notice {us}. Its core and gyrozephyr were both gone, and it was a miracle its winds still held."},
    [93737] = {act = "scavenged a core and gyrozephyr for Riaani's construct", giver = "Riaani",
        "Riaani could not imagine why anyone would steal the construct's parts, nearly useless outside it. {We} scavenged a new core and gyrozephyr for him. He could start it again and, if its memory held, learn who had stripped it.",
        "{We} brought Riaani the parts he needed to wake the construct. He thanked {us}, since they had not been easy to get, and hoped the machine would name its thief."},
    [93746] = {act = "struck down Belathaan of the High Order on the north road", giver = "Ayessa Dawnsinger",
        "Ayessa Dawnsinger wanted the High Order taught not to meddle in Windshaper affairs. She sent {us} after Belathaan on the road north toward the Shrine of Akir. {We} caught him alone and killed him, and Ayessa learned he had been sent to talk peace with the cult.",
        "{We} found Belathaan of the High Order on the north road and he did not survive the meeting. The news stunned Ayessa, who said there was no peace to be had with the Al'Aketh and blamed Elaadrin for sending him alone."},
    [92640] = {act = "learned Valennia's plan to storm the Shrine of Akir",
        "Meeting the cult in the open was hopeless. The only chance was to strike the shrine and take Lorthuna before she finished her scheme. {We} went to Valennia Stormfist, who had long prepared a plan for it.",
        "Valennia laid out her plan to assault the Shrine of Akir for {us}. Tensions between the Windshapers and the High Order ran high, she admitted, but neither could do it alone."},
    [92643] = {act = "went to bring in the Al'Aketh turncoat",
        "A cultist claimed to know the Al'Aketh's true intentions and would come in for protection. {We} went discreetly to his hidden house northwest of Valanaar. Assassins waited outside, and when {we} had fought through them the turncoat lay dead.",
        "{We} fought the cult's assassins outside a secluded house in the highlands, too late for the defector inside. Kneeling by his body, {we} saw something glinting beneath him."},
    [92644] = {act = "brought the turncoat's crystal to High Elder Shadowsong",
        "Beneath the turncoat's still-warm body {we} found a small, glowing blue crystal, damaged but perhaps important. {We} took it to High Elder Shadowsong, who called the news unfortunate and turned the crystal over with interest.",
        "{We} came back to High Elder Shadowsong alone, with a dead informant to report and only his cracked blue crystal to show for it. Shadowsong took the crystal and found it interesting."},
    [92646] = {act = "followed Ayessa through the portal to stop Lorthuna", giver = "Valennia Stormfist",
        "Lorthuna fled through a portal to the Rohashi Spires, Ayessa and Elaadrin went after her, and the wounded Valennia could go no further. {We} went through on {our} own and helped stop the cult's leader, and Ayessa said the island was more vulnerable than ever.",
        "Valennia sent {us} through the portal above the Shrine of Akir to find Ayessa and stop Lorthuna, with no promise of help. {We} survived the spires, and afterward Ayessa spoke of what came next for the Windshapers on Azeroth."},
    [93835] = {act = "followed Elaadrin through the portal to stop Lorthuna", giver = "Valennia Stormfist",
        "Lorthuna fled through a portal to the Rohashi Spires with Elaadrin close behind. The wounded Valennia could only send {us} after them. {We} helped Elaadrin stop her, and Elaadrin said they had survived the day but Zephras was dangerously exposed.",
        "{We} went up through the portal to the spires above the shrine, alone unless help came, to find Elaadrin and stop Lorthuna. Elaadrin sent mages to bring Valennia home and began planning for what was to come."},
    [94369] = {act = "told High Elder Shadowsong of Lorthuna's end and the plan for Azeroth", giver = "Elaadrin",
        "With the wards that hid Zephras gone, the island lay open in Al'Akir's own domain. It fell to {us} to tell High Elder Shadowsong. He heard what had happened above the shrine and of the mission to Azeroth, and found much to fear but much to celebrate.",
        "{We} told Talaanis Shadowsong of the Shrine of Akir, and of the plan to seek the means of saving Zephras on Azeroth. Lorthuna was gone, he said, and by the reckoning of elemental demigods, Al'Akir might not turn to them for years."},
    [94485] = {act = "gathered Lady's Tear moss for Elegael's wounded",
        "Elegael needed a poultice for the wounded of the Nightclaw Den. Its heart was Lady's Tear, a spindly moss on the trees of Shadowgale. {We} gathered it quickly, sticky and binding, and Elegael took it with a weak smile.",
        "{We} searched the base of Shadowgale's trees for the antiseptic moss Elegael needed for the injured left behind in the den. It was exactly what was needed, Elegael said."},
    [93090] = {act = "carried High Elder Shadowsong's blessing to Ayessa", giver = "High Elder Shadowsong", solo = true,
        "High Elder Shadowsong gave the expedition to Azeroth his blessing and sent {me} to Ayessa with his thanks for all the Windshapers had done. With the cult beaten and the skycutter crossings to Mulgore made reliable, Ayessa declared it was time to go.",
        "{I} brought Ayessa the high elder's blessing for the journey to Azeroth, where some Windshapers already waited in Mulgore. She judged everything ready for the crossing, and so was {I}."},
    -- The Barrens: the Crossroads and its roads.
    [840] = {act = "carried Takrin Pathseeker's letter to Kargal Battlescar", giver = "Takrin Pathseeker",
        "Takrin Pathseeker thought {us} strong enough for the outposts beyond Durotar and gave {us} a recruitment letter for his friend Kargal Battlescar. Kargal signed it on his scout's word, then said what he truly needed was someone at the Crossroads.",
        "{We} crossed out of Durotar into the Barrens with Takrin's letter and found Kargal Battlescar at his post. He approved {us} at once and pointed {us} on toward the Crossroads."},
    [842] = {act = "reported to Sergra Darkthorn at the Crossroads", giver = "Kargal Battlescar",
        "Kargal warned {us} that Sergra Darkthorn would talk {our} head in circles, though Thrall thought her something special. {We} reached the Crossroads, where the roads of the Barrens met, and Sergra took the letter and said she would tolerate no insolence.",
        "{We} walked into the Crossroads with Kargal's letter for Sergra Darkthorn. Thrall had declared the Horde's women equal, she reminded {us}, and she made the demands of duty plain."},
    [854] = {act = "came to Thork at the Crossroads from Mulgore",
        "A seer of Mulgore had foreseen {our} coming and said {we} had grown. {We} took the road east out of Mulgore and north to the Crossroads, where Thork welcomed allies come from as far as Thunder Bluff.",
        "The orcs of the Crossroads needed their tauren allies. {We} followed the road from Mulgore into the open Barrens and found Thork within its walls. He welcomed {us} gladly."},
    [98024] = {act = "came to Thork at the Crossroads on the Warchief's word", solo = true,
        "Thrall had sent {me} southwest into the Barrens to start doing some good in this world. Thork called {me} a little skinny for an elf, and said that out here {I} would either thrive or die.",
        "{I} came to the Crossroads fresh from the elemental plane, and the Barrens' dangers did not seem small for long. Thork grunted at the Warchief's referral and judged {me} by the work still ahead."},
    [860] = {act = "sought out Sergra Darkthorn to walk the hunter's path", solo = true,
        "If {I} meant to walk the hunter's path, {my} trainer said, it led to the Barrens, whose beasts were strong-willed and fierce. {I} found Sergra Darkthorn at the Crossroads, who saw {my} young eyes and promised to toughen body and mind alike.",
        "{I} travelled east from Bloodhoof Village into the Barrens to begin {my} lessons with Sergra Darkthorn. There was more to hunting than killing prey, she said, and {my} journey began now."},
    [844] = {act = "hunted the plainstriders harassing the Crossroads' food", giver = "Sergra Darkthorn",
        "Sergra Darkthorn promised {our} first prey would be easy, the plainstriders east of the Crossroads that harassed its food supplies. {We} brought back their beaks, and she warned the next prey had more fire in its blood.",
        "{We} hunted plainstriders east of the Crossroads for Sergra, and the outpost's supply chains were easier to keep for it. She hoped {we} had learned a few tricks out there."},
    [845] = {act = "took zhevra hooves for Sergra Darkthorn", giver = "Sergra Darkthorn",
        "The zhevra north and south of the Crossroads kicked hard enough to knock a tauren on its haunches, Sergra said. {We} hunted them for their hooves, and she judged {us} strong enough for a real challenge.",
        "{We} took zhevra hooves on the plains around the Crossroads as Sergra's next test. She had harder prey in mind for {us} next."},
    [871] = {act = "struck the Razormane raiders on the Durotar road", giver = "Thork",
        "The Razormane quilboar kept raiding the supply lines from Durotar, and Thork's scouts were still hunting their leader. {We} went northeast to their thorny dens and thinned them, and Thork said the pig men would learn the Horde's might.",
        "{We} sought out the Razormane dens by the great thorny vines that broke from the earth, and killed the raiders inside. Every one {we} killed made the Crossroads easier to supply."},
    [872] = {act = "killed Kreenig Snarlsnout for his raids on the caravans", giver = "Thork",
        "A scout had seen Kreenig Snarlsnout lead a raid on a Durotar caravan, just south of the road. {We} killed him along with more of his tribe and brought Thork his tusk, and Thork said {our} people should be proud.",
        "Cut off the head of the leader and chaos followed, Thork taught {us}. {We} found Kreenig Snarlsnout south of the Durotar road and brought back his tusk, and the raids on the caravans fell off."},
    [867] = {act = "took Witchwing talons for Darsok Swiftdagger", giver = "Darsok Swiftdagger",
        "Darsok Swiftdagger had snooped around the harpy nests and worked out who led whom. {We} started at the bottom, cutting down Witchwing harpies and roguefeathers in the northwest, and he liked the talons {we} brought.",
        "{We} went to the Witchwing nests in the northwest and came back with eight talons for Darsok. It was a start against the harpies who ravaged the caravans, and he looked forward to more."},
    [875] = {act = "assassinated the harpy lieutenants in the Dry Hills", giver = "Darsok Swiftdagger",
        "Darsok wanted the Witchwing Slayers, the harpies' lieutenants, dead in the Dry Hills, and he wanted it painful. {We} brought him six of their rings, and he said {we} would go far in the Horde.",
        "{We} hunted the Witchwing Slayers through the Dry Hills and took the rings that marked their rank. To Darsok it was a decisive strike against the harpies' matriarchy."},
    [876] = {act = "killed the harpy Serena Bloodfeather", giver = "Darsok Swiftdagger",
        "The raids on the caravans came down to one grudge, Serena Bloodfeather's revenge for a sister Rexxar had slain long ago. {We} went into her nests and brought back her head for the next caravan, and Darsok laughed and admitted his doubts.",
        "By then {we} fought with more surety, and Serena Bloodfeather, the last of Darsok's harpies, died at {our} hands. He called {us} quite the cut-throats and paid the reward."},
    [850] = {act = "brought Barak Kodobane's head to Regthar Deathgate", giver = "Regthar Deathgate",
        "New leaders were rallying the Kolkar, and the first marked was Barak Kodobane, camped near the Forgotten Pools. {We} found him and brought back his head, and Regthar said centaur with wit and vision were the most dangerous kind.",
        "{We} went north to the Forgotten Pools and killed Barak Kodobane, one of the few Kolkar with the wit to lead. Regthar Deathgate was glad he was dead."},
    [851] = {act = "drew out and killed Verog the Dervish at the Stagnant Oasis", giver = "Regthar Deathgate",
        "Verog the Dervish wandered the Barrens and would be hard to find. {We} killed centaur at their command tent by the Stagnant Oasis until the alarm brought him running. Regthar set his head beside Barak's and spoke of bravery.",
        "{We} stirred up the Kolkar at the Stagnant Oasis until Verog the Dervish came to answer, and he died there. Regthar's guards had seen the commotion from the bunkers."},
    [852] = {act = "killed Hezrul Bloodmark at the Lushwater Oasis", giver = "Regthar Deathgate",
        "Hezrul Bloodmark, fierce and cunning, led the Kolkar of the Barrens from the Lushwater Oasis, and Regthar believed his death would break them. {We} went south and killed him, and his head made the third beside Barak's and Verog's.",
        "{We} brought Regthar the head of Hezrul Bloodmark, the highest of the Kolkar leaders. The centaur could not focus their rage as orcs did, Regthar said, but they were fierce, and the head proved {our} valor."},
    [855] = {act = "took centaur bracers for the Horde's bounty",
        "The Kolkar threatened the Horde's claims in the Barrens, and a bounty was offered for their bracers. {We} gathered a heap of them from the centaur warriors. The bounty was paid with the hope that the rest would stop their advances.",
        "{We} fought the Kolkar across their lands for the bracers the Horde would pay for. They ought to calm themselves now, said the one who paid, though he did not believe they would."},
    [869] = {act = "hunted the raptors blamed for the stolen payroll", giver = "Gazrog",
        "The silver for the Crossroads guards had been stolen, and the thief they caught was a raptor. Gazrog did not care why raptors wanted silver, only that they died, so {we} hunted them and brought back their heads.",
        "{We} hunted raptors across the Barrens for Gazrog, who wanted no more of his guards' pay to go missing. He called {us} people of worth, though the silver was still gone."},
    [848] = {act = "gathered oasis mushroom spores for Apothecary Helbrim", giver = "Apothecary Helbrim",
        "Apothecary Helbrim told {us} the oases of the Barrens hid a mystery, waters that invigorated and altered all that drank them. {We} gathered spores from the mushrooms that grew there, and he judged them potent and paid, since the Forsaken honored their contracts.",
        "{We} picked spores from the mushrooms beside the oases for a Forsaken apothecary at the Crossroads. Helbrim needed them for a concoction bound for his associate in Thunder Bluff."},
    [868] = {act = "dug eggs from the Field of Giants for Korran", giver = "Korran",
        "Korran watched the land for his masters in Orgrimmar and studied the insect creatures of the Field of Giants, cleverer than any animal. He lent {us} a digging claw, and {we} dug their eggs whole from the mounds and brought claw and eggs back unbroken.",
        "{We} went into the Field of Giants, surer of {our} footing in the Barrens by then. {We} dug eggs from the creatures' mounds with Korran's digging claw, and he was pleased to have them for his report."},
    [886] = {act = "went to aid Tonga Runetotem at the Crossroads",
        "The druids of Thunder Bluff sensed a strange power leaking into the Barrens, and Tonga Runetotem had gone to find its source. {We} took the road east from Bloodhoof Village and north at the fork. Tonga said his brethren had been wise to send {us}.",
        "{We} found Tonga Runetotem at the Crossroads, sent by the druids to unravel the mystery of the Barrens. He could not solve it alone, he said, and hoped {we} would help him find answers."},
    [870] = {act = "found the fissure beneath the Forgotten Pools", giver = "Tonga Runetotem",
        "The Barrens had once been lush before war burned it dry, and now new oases were forming. {We} went down into the Forgotten Pools for Tonga and found a fissure in the earth, bubbling gas beneath the water.",
        "{We} searched the waters of the Forgotten Pools and found where something seeped up from below. Tonga Runetotem could not yet call it an answer, but it was a start."},
    [877] = {act = "planted dead seeds in the Stagnant Oasis fissure", giver = "Tonga Runetotem",
        "Tonga gave {us} seeds that were dead and dry and sent {us} to the Stagnant Oasis to look for another fissure. {We} found it and placed the seeds inside, and they came to life, which Tonga called amazing.",
        "At the Stagnant Oasis {we} set Tonga's dead seeds in the fissure beneath the water and watched. Whatever lay under the oases could make life from nothing, he said."},
    [880] = {act = "brought Tonga shells from the oasis beasts", giver = "Tonga Runetotem",
        "Tonga wanted to know how the fissures changed the beasts that drank from them. {We} hunted the snapjaws of the oases and brought him their shells. Studying an area's beasts, he said, told much about the land itself.",
        "{We} took shells from the altered snapjaws around the oases for Tonga Runetotem's study. He paid {us} in coins he said he had no need for."},
    [1358] = {act = "brought Helbrim a sample of the poisoned wolf hearts",
        "Apothecary Helbrim at the Crossroads was studying how the toxins of Lordaeron touched the beasts of Kalimdor. {We} brought him a sample of the wolf hearts from Silverpine, and he hoped their poison could advance the apothecaries' craft.",
        "{We} carried a sample of the Silverpine wolf hearts from the Undercity to Helbrim, the Forsaken apothecary at the Crossroads. If the first reports were true, he said, it was a find."},
    [5041] = {act = "recovered stolen Crossroads supplies from the Razormane", giver = "Thork",
        "A Razormane attack on a caravan had taken goods the Crossroads badly needed. Thork asked {us} to watch for them in the quilboar camps. {We} found them and brought them back, and Thork laughed and called {us} a boon to the outpost.",
        "{We} searched the Razormane camps and carried the stolen supplies back to Thork. The Crossroads would not go short after all."},
    [3281] = {act = "found the stolen payroll in the Raptor Grounds", giver = "Gazrog",
        "The raptor thieves were dead, but the guards' silver was still missing, and Gazrog suspected the Raptor Grounds south of Ratchet. {We} found it in their lair, and he wondered whether the stories of their cunning were true after all.",
        "{We} went into the Raptor Grounds and brought back the Crossroads guards' stolen silver. Gazrog said the guards owed {us} their next month's pay."},
    [903] = {act = "hunted the prowlers in the tall grass", giver = "Sergra Darkthorn",
        "The prowlers of the Barrens were tough, sly and deadly, and Sergra warned that a careless hunter would become the prey. {We} hunted them in the tall grass southwest of the Crossroads, and she asked whether {we} felt ready for a champion among them.",
        "{We} hunted prowlers among the tall grasses for Sergra Darkthorn, careful to stay the predator. She saw how busy {we} had been and had a greater cat in mind."},
    [881] = {act = "blew the horn and killed Echeyakee", giver = "Sergra Darkthorn",
        "Echeyakee, Whitemist, was the king of the savannah cats, and the tauren called him both mercy and death. {We} blew Sergra's horn among the giant kodo bones northeast of the Crossroads. When he came {we} killed him, and his spirit went with {us}.",
        "{We} went to Echeyakee's lair among the kodo bones and called him out with the horn. Sergra said he would teach {us} the strength in subtlety and the honor in mercy."},
    [905] = {act = "laid sunscale feathers in the scytheclaw nests", giver = "Sergra Darkthorn",
        "The hunt deepened, Sergra said, and {we} had to take the fight to the prey's own lair. {We} took feathers from the sunscale raptors and laid them in the scytheclaw nests southwest of the Stagnant Oasis. She said {we} looked tougher for it.",
        "{We} carried the feathers of slain sunscales into the scytheclaw nests to show the raptors {we} did not fear them. Sergra called it a fair portion of courage and said the Barrens was doing its job."},
    [907] = {act = "bested the thunder lizards of the southern Barrens", giver = "Jorn Skyseer",
        "The thunder lizards of the southern Barrens were so big the ground rumbled under them, and one false step meant being crushed. {We} bested the stormsnouts, stormhides and thunderheads, and Jorn Skyseer was glad {we} came back with no bones broken.",
        "{We} hunted the great thunder lizards in the south for Jorn Skyseer, keeping clear of their feet. He was glad of the proof, and gladder to see {us} whole."},
    [882] = {act = "lured and killed Ishamuhale with a zhevra carcass", giver = "Jorn Skyseer",
        "Ishamuhale, Speartooth, was the fiercest sunscale raptor of the Barrens, who killed because it was his nature. {We} dragged a zhevra carcass to the dead tree northwest of Ratchet, and when he came for it {we} took his fang.",
        "{We} followed the taloned tracks of Ishamuhale and baited him with his favorite prey. Jorn Skyseer took the fang as a token and told {us} the raptor's strength was in {us} now, to be used with temperance."},
    [913] = {act = "brought down a thunderhawk for Jorn Skyseer", giver = "Jorn Skyseer",
        "Jorn Skyseer set {us} against the thunderhawk, a fierce beast whose wings would prove the hunt. {We} brought them back. He said {we} had bested every foe set before {us}, and that true hunters never stopped walking their path.",
        "{We} went after a thunderhawk as {our} time with Jorn Skyseer neared its end, and brought back its wings. He told {us} to be as proud as the beast {we} had killed, and to move on."},
    [4021] = {act = "broke the Kolkar counterattack on Regthar's bunkers", giver = "Regthar Deathgate",
        "{Our} victories over the Kolkar had maddened them, and a war band came from Desolace to strike Regthar Deathgate's bunkers from the west. {We} met the attack and took the banner of its leader Krom'zar, and Regthar promised that Thrall would hear of it.",
        "{We} held the bunkers west of the Crossroads against the centaur who came for vengeance. Krom'zar's banner went to Regthar as proof the invaders were beaten."},
    [6541] = {act = "reported to Kadrak at the northern watch tower",
        "The Horde had set up an outpost on the Zoram Strand in Ashenvale and wanted recruits for its new fronts. {We} went north to Kadrak at the watch tower, who led the campaign. He spoke of Ashenvale as a divided land where the Horde was winning ground.",
        "{We} answered the call for Ashenvale and found Kadrak at his watch tower on the northern edge of the Barrens. The Horde held the Zoram Strand and Splintertree Post now, he said, and could always use more fighters."},
    [6542] = {act = "reported to Kadrak at the northern watch tower",
        "Word reached {us} that the Horde's new fronts in Ashenvale needed defenders. {We} went to Kadrak at the watch tower in the north of the Barrens. He told {us} of the outposts at the Zoram Strand and Splintertree, and of a land divided.",
        "{We} took up the call for recruits and climbed to Kadrak's watch tower, where the Barrens met the forests of Ashenvale. He was heading the campaign there and had orders for {us}."},
    [6543] = {act = "carried Kadrak's orders to his scouts in Ashenvale", giver = "Kadrak",
        "Kadrak had scouts scattered through Ashenvale and needed a runner. {We} carried his orders to Zoram'gar on the coast, to Splintertree Post, and to a scout on the road toward Azshara. {We} came back with their reports, and he said {we} could be counted on.",
        "{We} ran Kadrak's orders through the forest to each of his scouts and brought him what they had seen. It took {us} across much of Ashenvale, and Kadrak could plan the Horde's next move."},
    [3261] = {act = "went south to Jorn Skyseer at Camp Taurajo", giver = "Sergra Darkthorn", solo = true,
        "Sergra Darkthorn had taught {me} all she would, and sent {me} south to Camp Taurajo to find Jorn Skyseer. He asked whether it was the hunter's path that had brought {me}, said very good, and began.",
        "{I} left the Crossroads for Camp Taurajo in the south, where Jorn Skyseer would carry on {my} guidance. Jorn took up {my} lessons where Sergra had left them."},
    [883] = {act = "brought the Hoof of Lakota'mani to Jorn Skyseer",
        "{We} brought down Lakota'mani, the great kodo, and carried his hoof to Jorn Skyseer at Camp Taurajo. Jorn named him Earthshaker, whose steps were like gathered thunder, and said his courage walked with {us} now.",
        "Jorn Skyseer saw a new power in {our} stride before {we} showed him the Hoof of Lakota'mani. Walk tall, he told {us}, as the kodo had."},
    [884] = {act = "brought Owatanka's tailspike to Jorn Skyseer",
        "The tailspike {we} took from the thunder lizard Owatanka still threw sparks when touched. Jorn named the beast Bluebolt, struck long ago by lightning and fed by the sky's rage. Its speed ran in {us} now, he said.",
        "{We} carried Owatanka's sparking tailspike to Jorn Skyseer, who knew the great lizard as Bluebolt. Its swiftness went with {us} now, he said."},
    [885] = {act = "brought Washte Pawne's feather to Jorn Skyseer",
        "The feather {we} took from the thunderhawk Washte Pawne stung to the touch. Jorn Skyseer called it the Spirit Biter and said its sting was the pain of regret, and that regret could turn to wisdom.",
        "{We} brought the painful feather of Washte Pawne to Jorn Skyseer at Camp Taurajo. He spoke of regret and of the wisdom that could grow from it."},
    [897] = {act = "showed Jorn Skyseer the strange harvester",
        "{We} killed a creature in the Barrens that looked like no beast of the land, insect-like and wrong. Jorn Skyseer could read nothing of it, since its spirit had fled. He agreed it did not belong, and feared it heralded a grim future.",
        "Troubled by what {we} had found, {we} carried the head of the strange harvester to Jorn Skyseer. He hoped time would unravel its mystery."},
    [878] = {act = "killed the Bristleback mystics for the caged Mangletooth", giver = "Mangletooth",
        "Mangletooth, a Razormane caged at Camp Taurajo, offered to tell {us} who truly troubled Thork. First he wanted the Bristlebacks' spiritual leaders dead. {We} killed them, and instead of gladness he complained his own tribe had left him to rot.",
        "{We} struck down the Bristleback mystics and geomancers so a caged quilboar's tribe might win their war. Mangletooth took the news, then went back to cursing the Razormane who had abandoned him."},
    [5052] = {act = "gathered blood shards of Agamaggan for Mangletooth", giver = "Mangletooth",
        "The quilboar carried red stones of Agamaggan's hardened blood as totems, and Mangletooth offered his magic for enough of them. {We} brought him blood shards, and touching one again after so long, he said no cage could stop Agamaggan's power.",
        "{We} took blood shards from the quilboar of the Barrens and traded them through the bars of Mangletooth's cage for his blessings."},
    [879] = {act = "killed the three Razormane who led the raids on the Horde", giver = "Mangletooth",
        "Mangletooth named the three Razormane who led the raids on the Horde, Nak, Kuz and Lok Orcbane, far in the southern Barrens. {We} went down and killed all three, and he said his old tribe should have made sure of him before turning their backs.",
        "{We} travelled deep into the south of the Barrens, sure of {our} ground by now. There {we} slew the three Razormane leaders who had left Mangletooth to die. He said it was better this way."},
    [906] = {act = "brought Lok Orcbane's head to Thork", giver = "Mangletooth",
        "Mangletooth wanted Lok Orcbane's head taken to Thork at the Crossroads, who would never believe a caged quilboar had helped. {We} laid it before Thork, and he was amazed, having blamed a different quilboar for the raids all along.",
        "{We} carried the head of Lok Orcbane north to the Crossroads. Thork admitted he had been wrong about who led the attacks on his supply lines."},
    [893] = {act = "brought Razormane weapons to Tatternack Steelforge", giver = "Tatternack Steelforge",
        "Tatternack Steelforge at Camp Taurajo had heard the Razormane were making sturdier weapons with no skilled smiths among them. {We} took a dagger, a wand and a shield from their warriors, and he warned the Horde might have underestimated its enemy.",
        "{We} brought Tatternack the quilboar weapons he wanted to study. They were better made than he expected, and that worried him."},
    -- Ratchet, the coast and the Sludge Fen.
    [1492] = {act = "shipped a crate of reagents through Wharfmaster Dizzywig",
        "The last caravan to Ratchet had left without a crate of potions and reagents bound for the Old World. {We} carried it down to the harbor. Wharfmaster Dizzywig found room on the next tide's ship to Blackwater Cove and wrote it in his ledger.",
        "{We} brought a crate for the Old World down to Ratchet's docks and Wharfmaster Dizzywig. He made room for it on the next boat out and noted it in his ledger."},
    [887] = {act = "beat back the Southsea Freebooters south of Ratchet", giver = "Gazlowe",
        "Gazlowe was tired of losing ships and goods to pirates, and the Southsea Freebooters had camped just south of Ratchet. {We} gave them a beating he hoped would send them elsewhere, though his stolen goods were still out there.",
        "{We} fought the Southsea Freebooters in their camp on the coast south of Ratchet. Gazlowe, Ratchet's goblin boss, counted on them to take the hint."},
    [890] = {act = "took Gazlowe's ledger to Wharfmaster Dizzywig", giver = "Gazlowe",
        "Before blaming the pirates for his late shipment from Booty Bay, Gazlowe wanted his records checked. {We} took his ledger down to Dizzywig on the docks. He looked through his own logs and guessed Gazlowe was waiting on boots from Drizzlik.",
        "{We} carried Gazlowe's ledger to Wharfmaster Dizzywig to be sure the missing goods had not simply gone to the wrong place. Dizzywig checked his logs line by line."},
    [892] = {act = "brought Dizzywig's answer back to Gazlowe", giver = "Wharfmaster Dizzywig",
        "Dizzywig's records were square. {We} carried the bad news back to Gazlowe along with word of some things from Undermine waiting for him. Gazlowe trusted his wharfmaster, who was on the payroll, and decided it had to be the Freebooters.",
        "{We} told Gazlowe his shipment had never reached the dock. If it was the pirates, he said, he had goods to get back, and he looked at {us} hopefully."},
    [888] = {act = "took back Gazlowe's lens and boots from the pirates", giver = "Gazlowe",
        "Gazlowe's observatory needed only its smaller lens, lost at sea with a shipment of boots from Booty Bay. {We} took both back from the Southsea Freebooters, and he offered {us} more work and reminded {us} how well he paid.",
        "{We} raided the pirates' camp for the lens and the boots they had stolen from Gazlowe. He had his observatory part at last, and his boots too."},
    [895] = {act = "killed Baron Longshore of the Heedless", giver = "Gazlowe",
        "A notice in Ratchet named Baron Longshore of Gilneas, captain of the Heedless, as wanted for piracy. {We} found him among the Freebooters and brought back proof. Gazlowe paid the bounty, remembering how the Heedless had looked gliding across the sea.",
        "{We} hunted down Baron Longshore on the coast and brought his remains to Gazlowe in identifiable condition, as the notice demanded. His ships would be troubled no longer."},
    [891] = {act = "silenced the guns of Northwatch Hold", giver = "Captain Thalo'thas Brightsun",
        "Northwatch Hold's guns had sunk another of Captain Thalo'thas Brightsun's ships, and he wanted Captain Fairmount and her cannoneers dead. {We} stormed the hold and brought back her soldiers' medals, and Brightsun turned to the grim work of recovering his dead.",
        "{We} went into Northwatch Hold, an Alliance fortress on the coast, and killed the cannoneers along with Captain Fairmount. The guns fell silent, and Brightsun paid for the medals."},
    [898] = {act = "freed Gilthares Firebough from Northwatch Hold",
        "Gilthares Firebough, a deckhand whose moonshine boat Theramore's zealots had sunk, sat in a cell in Northwatch Hold. {We} got him out, and Captain Brightsun, who had thought him long dead, gave {us} a place of honor among the Thalo'dan Privateers.",
        "{We} fought into Northwatch Hold to free the only survivor of a sunken transport and bring him back to Ratchet. Thalo'thas Brightsun could hardly believe Firebough lived."},
    [894] = {act = "reached the Venture Company's samophlange console", giver = "Sputtervalve",
        "Sputtervalve wanted to know what a samophlange was, and gave {us} a stolen operating manual. {We} found the Venture Company's research site southwest of the Sludge Fen. Its console was all buttons, levers and blinking lights, with three valves still open.",
        "{We} reached the samophlange apparatus north of Ratchet with the goblins' manual in hand. The gauges read optimal and three control valves stood open."},
    [900] = {act = "shut the three valves on the samophlange console",
        "The console's readings told {us} the three control valves had to be closed before the machine could stop. {We} found and shut them, the lights faded from green to yellow, and the main switch could move at last.",
        "{We} closed the samophlange's three control valves one by one. Their lights dimmed on the console, and the apparatus could finally be turned off."},
    [901] = {act = "unlocked the samophlange console with its key",
        "With the apparatus quiet, only a locked panel kept the samophlange inside. {We} got the key, turned it, and the red light at the top went out as all power drained from the console.",
        "{We} found the key to the Venture Company's console and unlocked it. Everything sat idle at zero, the last red light gone dark."},
    [902] = {act = "brought the samophlange to Sputtervalve", giver = "Sputtervalve",
        "Inside the console lay a jumble of wires and tubing, and deep within it the samophlange, which came loose with a tug. {We} carried it back to Sputtervalve, who called it interesting and meant to have a look himself before sending it to Undermine.",
        "{We} pulled the samophlange from its housing and brought it to Ratchet. Sputtervalve still did not know what it was, but the Tinkers' Union would."},
    [858] = {act = "took the shredder key from the Venture Company supervisor", giver = "Wizzlecrank",
        "Wizzlecrank had climbed into a Venture Company shredder before realizing it needed a key. The supervisor at the top of the derrick had it. {We} fought up to the control room and took it, and Wizzlecrank marveled that the company built so much better than Ratchet.",
        "{We} climbed the derrick in the Sludge Fen to the supervisor's control room and brought down the key to Wizzlecrank's stolen shredder. He worked through its controls one by one."},
    [863] = {act = "guarded Wizzlecrank's escape in the stolen shredder", giver = "Wizzlecrank",
        "Wizzlecrank meant to learn the shredder as he drove it, a few buttons, a lever or two. {We} guarded him out of the Sludge Fen until the prototype gave out. Sputtervalve sent a salvage team and paid for the trouble.",
        "{We} fought off the Venture Company as Wizzlecrank drove his stolen shredder out of the fen, with no idea how. The wreck still held something of value, Sputtervalve hoped."},
    [896] = {act = "brought the miner's emerald to Dizzywig", giver = "Wharfmaster Dizzywig",
        "Dizzywig had heard of an emerald the size of a fist found by a Venture Company miner at the Boulder Lode Mine. {We} went in and took it, and he marveled, declared {us} rich, and paid {our} half at Undermine's rates.",
        "{We} brought Wharfmaster Dizzywig the great emerald from the Boulder Lode Mine. He worked out the cut, fifty percent as promised, and called it a pleasure doing business."},
    [865] = {act = "took sunscale horns for Mebok's smart drinks", giver = "Mebok Mizzyrix",
        "Mebok Mizzyrix believed the Barrens' raptors were smarter than any other, and that the smarts hid in their horns. {We} took intact horns from the sunscale scytheclaws, and he meant to grind them into smart drinks with a little wine.",
        "{We} hunted sunscale raptors for their horns and brought them to Mebok in Ratchet. Whether his drink would make anyone smarter was another matter."},
    [866] = {act = "gathered root samples from the Barrens' herbs", solo = true,
        "Oasis water had made the herbs of the Barrens just slightly different, and an herbalist wanted to study them. {I} gathered root samples from the plants {I} picked, and they were judged very nice and set to grow.",
        "{I} brought back roots from the herbs of the Barrens for study. If they held new properties, the herbalist said, {I} would be the first to know, since someone would need to gather more."},
    [862] = {act = "brought dig rats from Bael Modan for Grub's stew", giver = "Grub",
        "Grub, east of the Crossroads, said no one was a seasoned adventurer until they had killed rats. {We} brought him dig rats from Bael Modan, where the dwarves were overrun, and he cooked the stew on the spot.",
        "{We} went south to Bael Modan for the dig rats Grub wanted, by now well used to the long roads of the Barrens. He liked his rats left to rot a few weeks, but said {we} looked too hungry to wait."},
    [899] = {act = "brought Mankrik quilboar tusks", giver = "Mankrik",
        "Mankrik stood at the Crossroads from sunrise to sunset watching for quilboar, and his thirst for their blood was far from quenched. {We} brought him their tusks, and he said he could at least smile knowing they had felt pain too.",
        "{We} took tusks from the quilboar of the Barrens for Mankrik, who wanted their deaths celebrated. His desire for revenge remained, but he thanked {us} for taking it seriously."},
    [3921] = {act = "took Sputtervalve's broken samophlange to Wenikee Boltbucket", giver = "Sputtervalve",
        "Sputtervalve had boasted to Undermine about the samophlange and then broken it, and he hoped Wenikee Boltbucket could fix it. {We} found her south of Mor'shan Rampart, and she had no idea what it was but loved the sound of its gears.",
        "{We} carried the broken samophlange north to Wenikee Boltbucket. She wanted to start fixing it at once, whatever it turned out to be."},
    [3922] = {act = "stole nugget slugs from the Venture Company's tool buckets", giver = "Wenikee Boltbucket",
        "Wenikee needed seventeen-point-five gauge nugget slugs to mend the samophlange, and the Venture Company kept them in tool buckets at the Sludge Fen. {We} went into the fen and brought them, and she set to work.",
        "{We} searched the Venture Company's tool buckets in the Sludge Fen for Wenikee's nugget slugs. With them in hand she could finally get at the samophlange."},
    [3923] = {act = "brought the samophlange to Rilli Greasygob in Orgrimmar", giver = "Wenikee Boltbucket",
        "Wenikee's gauges read the samophlange's integrity at an all-time low. She sent {us} to Rilli Greasygob, once of the Venture Company, at Nogg's Machine Shop in Orgrimmar. Rilli knew it at once and decided {we} must be very brave or very stupid.",
        "{We} took the battered samophlange all the way to Orgrimmar and Nogg's Machine Shop. Rilli Greasygob asked if {we} had been poking around Venture Company holdings, and did not need the answer."},
    [3924] = {act = "took the samophlange manual pages from Boss Copperplug", giver = "Rilli Greasygob",
        "Rilli could fix the samophlange with its manual. But his old rival Boss Copperplug had hoarded it at the Boulder Lode Mine and split it among a trusted few. {We} gathered the scattered sheets and took the rest from Copperplug himself, and Rilli had his manual at last.",
        "{We} went to the Boulder Lode Mine for the samophlange manual and brought every scrap of it to Rilli Greasygob. Sputtervalve sent thanks and a reward, and Rilli promised word if the thing ever worked."},
    [819] = {act = "brought Chen Stormstout's empty keg to Brewmaster Drohn",
        "{We} found an empty keg with a placard wishing Chen Stormstout raised spirits, and carried it to Brewmaster Drohn. Chen had traveled with Rexxar long ago, Drohn said, and he had not heard of him in a kodo's age.",
        "Brewmaster Drohn knew the empty keg {we} brought him for one of Chen Stormstout's. He thanked {us} warmly for the memory of an old traveller."},
    [821] = {act = "gathered the makings of stormstout for Brewmaster Drohn", giver = "Brewmaster Drohn",
        "Drohn had learned Chen's stormstout from his mentor, who had it from Chen himself, and wanted to brew it again. {We} brought savannah lion tusks, plainstrider kidneys and a thunder lizard horn, and he laughed as he brewed.",
        "{We} hunted the Barrens for the strange ingredients of Chen's stormstout. Brewmaster Drohn's batch stirred his nostalgia, and reminded him of another of Chen's brews."},
    [822] = {act = "gathered the makings of Chen's trogg brew", giver = "Brewmaster Drohn",
        "Drohn had one more of Chen's recipes, a trogg brew with a real kick. {We} brought him stormhide lightning glands, a greater thunderhawk's saliva gland and a kodo liver, and he brewed it. {Our} hands were surer than when {we} first met him.",
        "{We} hunted stormhides, a thunderhawk and a kodo for Drohn's trogg brew and carried back the makings. He promised more brew whenever {we} brought more."},
    [1491] = {act = "gathered wailing essence for Mebok's smart drinks", giver = "Mebok Mizzyrix",
        "Mebok's raptor horn drinks had made no one smarter. Now he believed the answer was wailing essence from the ectoplasmic creatures of the Wailing Caverns. {We} went into the caverns and brought it out, and he promised more reward once he was rich.",
        "{We} gathered wailing essence from the ectoplasms of the Wailing Caverns for Mebok Mizzyrix. He was sure this time it would make his fortune."},
    [92706] = {act = "killed the shark Bruuz off Ratchet's docks", giver = "Gazlowe",
        "A giant shark the dockworkers called Bruuz was circling Ratchet's dock, attacking sailors and small boats. {We} swam out after it and brought Gazlowe its fin, and he thought he might have it in a soup that night.",
        "{We} went into the water off Ratchet to hunt Bruuz, the shark that had terrorized the docks. Gazlowe paid the hefty reward and looked forward to the last laugh."},
    [95494] = {act = "brought lion hides to the injured hunter Vrang", giver = "Vrang",
        "Vrang had hurt his leg and could not hunt, though he had a tanner to supply. It stung his pride to ask a stranger. {We} brought him lion hides from the plains, and he judged them good.",
        "{We} hunted savannah lions for Vrang, who had never come up short with his tanner and did not mean to start. He took the hides with thanks and some embarrassment."},
    [95495] = {act = "carried Vrang's hides to the hermit tanner on the ridge", giver = "Vrang",
        "Vrang could not climb the ridge behind his camp, and warned {us} not to be alarmed by the tanner's looks. {We} carried the hides up, and the hermit took them and wished Vrang had come himself.",
        "{We} climbed the steep ridge to a hermit tanner who was no threat, whatever he looked like. He had a matter he wanted to discuss with Vrang."},
    [95507] = {act = "checked Vrang's traps across the valley", giver = "Vrang",
        "Vrang's traps lay strewn across the valley, and his wounded leg kept him from them. {We} checked them and brought back the game, and he said he would have gone to bed hungry without it.",
        "{We} walked the valley from trap to trap for the injured Vrang and carried the catch back to his camp. He was grateful for every bit of it."},
    [95508] = {act = "defended the hermit tanner from the men on the ridge",
        "The hermit tanner had served in the Kul Tiras navy. He had objected to the Lord Admiral's campaign in Durotar, the killing of civilians most of all. He was still telling {us} when armed men came up the ridge, and {we} fought them off.",
        "{We} stood with the tanner when men came up the ridge for him. Everyone lived, and he admitted he had always known his past would catch up with him."},
    [843] = {act = "drove back the dig at Bael Modan for Gann Stonespire", giver = "Gann Stonespire",
        "The dwarves of Bael Modan were blasting holes in the land that had fed Gann Stonespire's tribe, and talks had failed. {We} drove into the dig and killed Prospector Khazgorm, and Gann felt no remorse as he opened his notebook.",
        "{We} fought through the dwarves' dig at Bael Modan and took Prospector Khazgorm's notebook for Gann Stonespire. He began reading it at once."},
    [846] = {act = "gathered explosives from the soldiers of Bael Modan", giver = "Gann Stonespire",
        "Khazgorm's notebook showed how much the dig depended on explosives, and Gann wanted the makings of a charge of his own. {We} took nitroglycerin, wood pulp and sodium nitrate from the keep's soldiers, and he promised the dwarves a surprise.",
        "{We} raided the keep at Bael Modan for the makings of a charge, and Gann Stonespire set about building it."},
    [849] = {act = "blew up the flying machine at Bael Modan", giver = "Gann Stonespire",
        "Gann built an explosive from Khazgorm's plans, and to him the dwarves' flying machine at Bael Modan insulted the memory of his tribe. {We} set the charge and destroyed it, and Gann hoped {we} would be revered in Thunder Bluff as champions of his lost people.",
        "{We} carried Gann's charge into Bael Modan and blew the flying machine apart. Gann Stonespire had his revenge for his tribe's lost land."},
    [874] = {act = "went to Mahren Skyseer on the coast", giver = "Jorn Skyseer",
        "A true hunter could stalk prey down any path, Jorn Skyseer said, even the sea. He sent {us} to his sister Mahren on the coast. She gave her respect to any who had earned her brother's and offered to teach the ways of the water beasts.",
        "{We} travelled to the coast to meet Mahren Skyseer, Jorn's sister, who hunted the great beasts of the water. She welcomed {us} on her brother's word."},
    [873] = {act = "killed Isha Awak in the waters off the coast", giver = "Mahren Skyseer",
        "Isha Awak, the Deep Doom, ruled the coastal waters and had eaten many humans on the shore. Mahren Skyseer called him honorable prey. {We} went into the sea after him and brought back his heart, and she said his spirit now lurked in {our} eyes.",
        "{We} hunted Isha Awak in the waters off the coast, a beast Mahren did not fear. She took his heart and said the Deep Doom now looked out from {our} eyes."},
    [853] = {act = "hurried Helbrim's spore emulsion to Apothecary Zamah", giver = "Apothecary Helbrim",
        "Helbrim had made the oasis spores into an emulsion that would only stay potent a short while. {We} hurried it to Thunder Bluff and down the hidden path to the Pools of Vision. Apothecary Zamah said {we} must have wasted no time.",
        "{We} carried Helbrim's emulsion from the Crossroads to the caves beneath Thunder Bluff's shamans. Apothecary Zamah found it still potent and paid from her stores."},
    [6361] = {act = "took Jahan's bundle of hides to the wind rider master", giver = "Jahan Hawkwing",
        "Jahan Hawkwing had a bundle of Barrens hides for a leatherworker in Thunder Bluff, and the quickest way there was by wind rider. {We} took them to Devrak, the Crossroads' wind rider master, who said anyone taking hides to Thunder Bluff was talking to the right orc.",
        "{We} carried Jahan's bundle of hides to Devrak at the Crossroads to arrange a flight to Thunder Bluff. He would see it flown there."},
    [6362] = {act = "flew to Thunder Bluff with the hides for Ahanu", giver = "Devrak",
        "A wind rider carried {us} over the Barrens to Thunder Bluff, and {we} found Ahanu at Hewa's Armory near the wind rider tower. He took Jahan's hides and set about working them.",
        "{We} rode a wind rider from the Crossroads to Thunder Bluff with a bundle of hides. Ahanu the leatherworker was waiting for them by the tower."},
    [6363] = {act = "took Ahanu's leather goods to Tal the wind rider master", giver = "Ahanu",
        "Ahanu had leather goods ready for Jahan to sell at the Crossroads, and {we} carried them to Tal, Thunder Bluff's wind rider master. Tal offered a ride back for the goods and for {us}.",
        "With Ahanu's finished leatherwork in hand {we} went to Tal at the wind rider tower. He had a mount ready to carry it all back to the Crossroads."},
    [6364] = {act = "brought Ahanu's leatherwork back to Jahan", giver = "Tal",
        "{We} flew back to the Crossroads with Ahanu's leather goods, where so many hunters and adventurers passed that Jahan could sell them easily. Jahan took them and paid {us} for the round trip.",
        "Jahan Hawkwing had his leatherwork back from {us}, made from his own hides. The circle from Barrens to Thunder Bluff and back was done."},
    [6365] = {act = "took Zargh's meat to the wind rider master", giver = "Zargh",
        "Zargh had choice cuts of meat for a friend, Gryshka, the innkeeper in Orgrimmar. {We} took them to Devrak, who said it was no problem and that for a small fee his wind rider would fly {us} there.",
        "{We} carried Zargh's gift of meat to Devrak's wind rider post at the Crossroads. Orgrimmar was only a flight away."},
    [6384] = {act = "flew Zargh's meat to Gryshka in Orgrimmar", giver = "Devrak",
        "A wind rider bore {us} from the Crossroads to Orgrimmar, and {we} brought Zargh's meat to Gryshka's inn in the Valley of Strength. She called them fine cuts and said Zargh knew the way to a lady's heart.",
        "{We} delivered Zargh's choice cuts to Innkeeper Gryshka in Orgrimmar. Meat was best served rare, she thought, and she was pleased."},
    [6385] = {act = "took Gryshka's letter to Doras the wind rider master", giver = "Gryshka",
        "Gryshka wrote Zargh a letter of thanks, and {we} carried it to Doras, Orgrimmar's wind rider master. Doras could fly {us} straight back to the Crossroads.",
        "{We} took Innkeeper Gryshka's letter to the wind rider tower in Orgrimmar. Doras had a mount ready for the flight south."},
    [6386] = {act = "brought Gryshka's thanks back to Zargh", giver = "Doras",
        "Zargh had been waiting to hear how Gryshka liked his gift, and {we} flew back to the Crossroads with her letter. He read her thanks happily and paid {us} for the help.",
        "Back at the Crossroads {we} handed Zargh the letter Gryshka had written him. The meat had pleased her, and that pleased him a great deal."},
    [4921] = {act = "searched for Mankrik's wife", giver = "Mankrik",
        "Mankrik and his wife had fought the Bristlebacks at a small tauren camp until they were separated. He had fallen to their numbers. {We} searched for her and found what was left, and Mankrik said the pain in his chest had already told him.",
        "{We} went looking for Mankrik's wife, who had held off three Bristlebacks alone before more came. The news {we} brought him was the worst, and he thanked {us} quietly."},
    [6382] = {act = "went to Ashenvale on Jorn Skyseer's word", giver = "Jorn Skyseer", solo = true,
        "Jorn Skyseer thought {me} ready for bigger game, the untamed forests of Ashenvale that the Horde meant to bend to its will. {I} went north to Splintertree Post, and Senani Thunderheart welcomed Jorn's student and explained her hunt.",
        "{I} left the Barrens behind for the frontier of Ashenvale, sent by Jorn Skyseer to Senani Thunderheart. A land of opportunity, she called it."},
    [5881] = {act = "relieved Grish Longrunner at the Great Lift", giver = "Maggran Earthbinder",
        "Grish Longrunner had guarded the Great Lift in the southern Barrens a long time and had asked to see his family. {We} brought him Maggran's letter saying a reserve was coming. He whooped and said he had guarded that hunk of wood too long.",
        "{We} carried Maggran's letter south to the Great Lift. Grish Longrunner read it and could finally go home to his family."},
    [3513] = {act = "brought a runed scroll to Kadrak at Mor'shan Rampart",
        "{We} found an official-looking scroll wrapped in silvery ribbon that might concern the night elves. {We} took it north to the outpost by the Ashenvale border. Kadrak at Mor'shan Rampart took it and wanted to know where it had been found.",
        "Kadrak at Mor'shan Rampart took the night elf scroll {we} brought him and was keen to learn where it had come from."},
    [3514] = {act = "killed the dryad Rynthariel and raised a Horde flag in her den", giver = "Kadrak",
        "The scroll came from Rynthariel, the dryad Keymaster of the Talon Den on Stonetalon Peak. {We} went up the peak, killed her and raised a Horde flag in her den. Kadrak said her people would be slow to regroup.",
        "{We} climbed Stonetalon Peak to the Talon Den, a long way from Kadrak's rampart, and left Rynthariel dead under a Horde flag. Fewer Alliance runners would cross the Barrens, Kadrak said."},
    [1153] = {act = "brought Tatternack an unusual ore sample", giver = "Tatternack Steelforge",
        "Travelers from Thousand Needles had found a strange ore on a kobold and would not sell Tatternack Steelforge a sample. {We} got him one, and he said if it proved strong, a weapon of it would go to the warchief.",
        "{We} brought Tatternack the ore sample the travelers had lorded over him. He called it good, and they could boast of it no longer."},
    [857] = {act = "took the Tear of the Moons back for Feegly the Exiled", giver = "Feegly the Exiled",
        "Feegly the Exiled raved about the Tear of the Moons, the first great find at Bael Modan. General Twinbraid had called it cursed and locked it in the keep. {We} fought into the keep and took it, and Feegly cried that its power was his again.",
        "{We} went into Bael Modan, surer of {our} strength by then, and took the Tear of the Moons from the dwarves' keep. Feegly snatched it and would not stop saying mine."},
    [4737] = {act = "sought out Menara Voidrender at Strahad's tower", giver = "Zevrost", solo = true,
        "Zevrost warned {me} that the hunger for power ended in slavery to what one sought to master. Still, he said Menara Voidrender in Ratchet would make tools for the ambitious. {I} found her in Strahad's tower, and she offered her help.",
        "{I} climbed to Strahad's tower above Ratchet to meet Menara Voidrender on Zevrost's word. Warlocks of every race had to band together, she said."},
    [4739] = {act = "sought out Menara Voidrender at Strahad's tower", giver = "Kaal Soulreaper", solo = true,
        "Kaal Soulreaper saw a new confidence in {me} and sent {me} to Menara Voidrender, who tutored students in Strahad's tower above Ratchet. Menara was pleased his word had reached so far. She spoke of beings that showed no mercy to those who failed to control them.",
        "{I} went from the Undercity to Strahad's tower in Ratchet to learn from Menara Voidrender. Her kind banded together, she told {me}, whatever their race."},
    [1361] = {act = "joined Regthar Deathgate's mission to Desolace",
        "Regthar Deathgate was recruiting for a mission into Desolace, a land torn by war. {We} went to his bunkers west of the Crossroads ready for it. He confirmed the work against the centaur there and wasted no words.",
        "{We} came to the bunkers west of the Crossroads, older hands at war by then, to volunteer for Desolace. Regthar kept it brief, so the work against the centaur could begin."},
    [791] = {act = "brought canvas to the old watchman for a bag",
        "An old watchman who had fought beside the Warchief now blew his signal horn less and less. He passed the time making goods for younger warriors. {We} brought him canvas taken from humans and centaurs, and he made {us} a bag for {our} belongings.",
        "{We} gathered canvas for the aging watchman on his lookout, who wore the scars of the war against Archimonde. Watching and providing had given him a new purpose, and he sewed {us} a bag."},
    [809] = {act = "went to Ak'Zeloth at Far Watch Post on Neeru's word", giver = "Neeru Fireblade",
        "Neeru Fireblade named the collar the Burning Blade's and said the cult rallied around a Demon Seed atop Dreadmist Peak. {We} went west to his assistant Ak'Zeloth at Far Watch Post. He thought it strange Neeru wanted the seed gone, but agreed to say how.",
        "{We} crossed into the Barrens to Far Watch Post with Neeru's word for Ak'Zeloth. The Demon Seed had to be destroyed, and Ak'Zeloth knew the way."},
    [924] = {act = "destroyed the Demon Seed on Dreadmist Peak", giver = "Ak'Zeloth",
        "Ak'Zeloth gave {us} a power stone that would consume itself in time. {We} hurried west and climbed the northern face of Dreadmist Peak to the altar of fire. {We} set the stone by the Demon Seed and destroyed it, and Ak'Zeloth felt the surge of power it sent out.",
        "{We} carried a power stone up Dreadmist Peak and broke the Demon Seed's tie to the Legion on its demonic altar. Ak'Zeloth warned that other beings had surely felt it too."},
    -- Hillsbrad: the Tarren Mill campaign.
    [493] = {act = "carried Renferrel's findings to Apothecary Lydon in Tarren Mill", giver = "Apothecary Renferrel",
        "The Dark Lady pressed the apothecaries hard for their plague, and Renferrel sent {us} far south with his latest findings for Apothecary Lydon. {We} kept to the roads and followed the signs into the Hillsbrad Foothills, and Lydon called the work most excellent.",
        "{We} took the long road out of Silverpine to Tarren Mill, sure of {our} way by then, with Renferrel's research. Apothecary Lydon was anxious to study it."},
    [527] = {act = "raided the northern farms of Hillsbrad Fields", giver = "High Executor Darthalia",
        "High Executor Darthalia of Tarren Mill wanted the humans quelled until the apothecaries had their plague. Her first order was the northernmost farms of Hillsbrad Fields. {We} raided them and killed Farmer Ray and Farmer Getz with their workers, and her sources told her {we} had performed well.",
        "{We} stood at attention for High Executor Darthalia and took her first orders west to Hillsbrad's farms. The landowners and their workers died, and Darthalia said the fighting had gone well."},
    [528] = {act = "cut down the peasants hiding in Hillsbrad's orchards", giver = "High Executor Darthalia",
        "Word of the raid had the town of Hillsbrad panicked, and Darthalia's Deathstalkers saw peasants fleeing into the orchards of the southern fields. {We} went after them as ordered, and Darthalia said the grip of death was tightening on the town.",
        "{We} followed Darthalia's orders into Hillsbrad's southern orchards, where the townsfolk had hoped to hide. The battle went well, she said."},
    [529] = {act = "killed Blacksmith Verringtan and took his iron", giver = "High Executor Darthalia",
        "The townsfolk of Hillsbrad fought harder than Darthalia expected, armed by Blacksmith Verringtan. {We} killed him and his apprentices and carried back a shipment of their iron, saved for the day Tarren Mill turned on Southshore.",
        "{We} shut down Hillsbrad's forge for High Executor Darthalia, killing the blacksmith who armed the town. She called the mission skillfully carried out and took the iron."},
    [532] = {act = "struck down Hillsbrad's magistrate and council", giver = "High Executor Darthalia",
        "The people of Hillsbrad still rallied around Magistrate Burnside and the town council. {We} killed them, destroyed the Hillsbrad Proclamation and stole the town registry, and news of it reached Tarren Mill before {we} did.",
        "{We} went into Hillsbrad and struck at the leaders who kept its people fighting. Darthalia had the registry, and said {we} had done well."},
    [539] = {act = "attacked the Azurelode Mine and its foreman", giver = "High Executor Darthalia",
        "The stolen registry showed the Azurelode Mine south of Hillsbrad feeding iron to the Alliance armories. {We} went down and killed Foreman Bonds and his miners, and Darthalia expected the Dark Lady to be pleased with a new mine.",
        "{We} took the fight to the Azurelode Mine on Darthalia's orders and left its foreman dead. The Alliance had its message, and the Forsaken a new source of iron."},
    [541] = {act = "laid siege to Dun Garok and killed Captain Ironhill", giver = "High Executor Darthalia",
        "Dwarves had come to help the humans, and Darthalia's final mission of the battle was their barracks at Dun Garok along Thoradin's Wall. {We} laid siege to it and killed Captain Ironhill, and she judged the fighting worthy of the highest praise.",
        "{We} stormed Dun Garok in southeastern Hillsbrad, the last stronghold of the battle, and brought down Captain Ironhill. The final mission of High Executor Darthalia's battle was done."},
    [550] = {act = "carried Darthalia's commendation to Varimathras", giver = "High Executor Darthalia",
        "Darthalia wrote a sealed commendation of {our} valor in the Battle of Hillsbrad and sent {us} to the Undercity with pride. Varimathras had already heard of the blow {we} had struck, and said {we} had quite a future in the Dark Lady's ranks.",
        "By the time {we} reached Varimathras with Darthalia's commendation, word of {our} deeds had travelled ahead of {us}. The Scourge was still the first threat, he said, but the humans could fall, and {we} had shown it."},
    -- Stonetalon: Seereth's spirits, the Flathoofs and Sun Rock Retreat.
    [1061] = {act = "answered Seereth Stonebreak's call in Stonetalon",
        "The spirits of Stonetalon cried out as goblins plundered and burned the land. Seereth Stonebreak, a promising shaman of the Horde, had asked for aid. {We} followed the road west from the Crossroads to her camp near the Greatwood Vale, and she was glad of {our} skills.",
        "{We} went west out of the Barrens into the Stonetalon Mountains to find Seereth Stonebreak. The plunderers would take some dealing with, she said, and she needed every hand."},
    [1062] = {act = "struck the Venture Company in Windshear Crag", giver = "Seereth Stonebreak",
        "The Venture Company was felling and burning Stonetalon's forests, and its spirits were nearly blind with pain and rage. {We} went into Windshear Crag and showed the goblins the Horde's answer in the language they understood best. Seereth called it bravely done.",
        "Beyond the Greatwood Vale {we} fell on the goblins and their servants clearing Windshear Crag. Seereth said it was a good first move, though calming the spirits might need the tauren elders."},
    [1063] = {act = "sought counsel from Magatha on Elder Rise", giver = "Seereth Stonebreak",
        "To truly tend Stonetalon's spirits, Seereth said, the tauren elders had to be asked. She knew one name, Magatha, very old and wise. {We} went to Thunder Bluff and climbed to Elder Rise, where Magatha greeted {us} and asked if {we} sought counsel.",
        "{We} carried Stonetalon's plight to Elder Rise in Thunder Bluff and found Magatha, the elder crone Seereth had named. She heard {us} out."},
    [1064] = {act = "went to Apothecary Zamah for the Forsaken's aid", giver = "Magatha",
        "Magatha grieved for Stonetalon, but said its disease had to be removed before it could heal, and the Forsaken knew much of disease. {We} went down to Apothecary Zamah in the Pools of Vision. Her heart no longer beat, she said, but she still felt sorrow for the spirits.",
        "{We} took Magatha's word to Zamah, the Forsaken emissary beneath the Spirit Rise. Helping would strengthen the trust between the peoples, Magatha believed, and Zamah was eager."},
    [1065] = {act = "carried Zamah's note to Apothecary Lydon in Tarren Mill", giver = "Apothecary Zamah",
        "Zamah wanted the Venture Company driven out by extreme measures without bloodshed, and her colleague Lydon might have the tool. {We} took the zeppelin to the Undercity and travelled south through Silverpine to Tarren Mill. Lydon read her note and knew exactly what to do.",
        "{We} crossed the sea to Lordaeron with Zamah's note and walked all the way to Tarren Mill in the Hillsbrad Foothills. Apothecary Lydon said her needs must be great to send word so far."},
    [1066] = {act = "took innocents' blood from the Syndicate's shadow mages", giver = "Apothecary Lydon",
        "Lydon meant to make a toxin that would bleed the violence from the Venture Company, and it needed the blood of innocents. The Syndicate's shadow mages in Durnholde Keep collected exactly that. {We} took it from them, and Lydon was glad they had done the hard part.",
        "{We} fought the Syndicate's shadow mages in Durnholde Keep for the innocent blood they hoarded. Apothecary Lydon took it and asked for a moment to make his concoction."},
    [1067] = {act = "brought Lydon's toxin back to Zamah", giver = "Apothecary Lydon",
        "Lydon's toxin was ready, and he was excited to see his work used in the field. {We} carried it back across the sea to Zamah in Thunder Bluff. If she knew Lydon, she said, it would be quite effective.",
        "{We} brought the toxin from Tarren Mill to the Pools of Vision, a long road behind {us}. Apothecary Zamah took it and set about making the most of it."},
    [1086] = {act = "planted Lydon's toxin at the Venture Company's sky port", giver = "Apothecary Zamah",
        "Zamah guessed the Venture Company had a small sky port in Stonetalon for its flying machines. {We} searched the goblins' holdings until {we} found it, placed the toxin and ran. Zamah told {us} not to feel guilty, since the goblins deserved far worse.",
        "{We} found the Venture Company's little airport in the mountains and left Lydon's toxin among its cargo. Zamah hoped it would find its way to the goblins' headquarters."},
    [1060] = {act = "carried Darsok's letter to Jin'Zil in Stonetalon", giver = "Darsok Swiftdagger",
        "Darsok called {us} a regular lucky rabbit's foot. He gave {us} a letter for his old friend Jin'Zil, a witch doctor in Stonetalon, where the harpies came from. Jin'Zil was glad to hear Serena Bloodfeather was dead.",
        "{We} took Darsok's letter northwest into Stonetalon to Jin'Zil the witch doctor. He had not heard from Darsok in years, and the news of the last Bloodfeathers made him wish he were young again."},
    [6461] = {act = "thinned the blood feeder spiders around Malaka'jin", giver = "Xen'Zilla",
        "The spiders of the mountains had been raiding the trolls' camp at Malaka'jin at night to steal their kill. {We} thinned the hairy blood feeders north of the camp, and Xen'Zilla hoped for fewer dinner guests that night.",
        "{We} hunted blood feeders around Malaka'jin for the trolls who lived on Stonetalon's game. Xen'Zilla said the camp was forever in {our} debt."},
    [6548] = {act = "avenged Makaba Flathoof's village on the Grimtotem", giver = "Makaba Flathoof",
        "The Grimtotem had raided Makaba Flathoof's village and killed nearly everyone in it, and he had barely escaped. {We} went west and killed the Grimtotem there, and Makaba said he would never forget what they had done.",
        "{We} fought the Grimtotem just west of Makaba Flathoof's ruined village, as he had wished. He thanked {us}, though nothing would undo it."},
    [6629] = {act = "killed Grundig Darkcloud at Grimtotem Post", giver = "Makaba Flathoof",
        "Grundig Darkcloud had led the attack on Makaba's village, and he camped with his brutes at Grimtotem Post further up the path. {We} went up and killed him, and Makaba said he would always be grateful for that day.",
        "{We} found Grundig Darkcloud among his brutes at Grimtotem Post and ended him. Makaba Flathoof's village was avenged on the one who had led the raid."},
    [6523] = {act = "escorted Kaya Flathoof away from the Grimtotem", giver = "Kaya Flathoof",
        "Kaya Flathoof had slipped free of the Grimtotem who held her and wanted to be gone before they noticed. {We} escorted her to Camp Aparaje, from where she knew her own way. Her father Makaba had {us} to thank that his daughter lived.",
        "{We} found Kaya, Makaba's daughter, alive when everyone had thought her lost, and brought her safely past the Grimtotem. Makaba Flathoof could hardly thank {us} enough."},
    [6401] = {act = "told Tammra Windfield her niece Kaya was alive", giver = "Makaba Flathoof",
        "Kaya was alive, and her aunt Tammra Windfield had to hear it. {We} took the path west to Sun Rock Retreat, and Tammra called it good news indeed.",
        "{We} carried Makaba's news up the path to Sun Rock Retreat and told Tammra Windfield that her niece had survived the Grimtotem. The words were a gift to her."},
    [6421] = {act = "took Resonite samples in Boulderslide Ravine", giver = "Mor'rogal",
        "Mor'rogal felt something amiss in Stonetalon, kobolds frantically mining a rare crystal in Boulderslide Ravine. {We} brought back Resonite samples and saw the bottom of their cave. He remembered that Resonite carried Earthen magic, which meant the kobolds had uncovered one of the Earthen.",
        "{We} went deep into the kobold cave in Boulderslide Ravine for Mor'rogal and came back with ore and an account of what lay below. He shook his head and meant to enchant the samples against the kobolds' plot."},
    [6481] = {act = "killed the Earthen Goggeroc as he woke", giver = "Mor'rogal",
        "Mor'rogal's enchanted Resonite would smash open the cask where the Earthen Goggeroc slept, and he would wake weak. {We} broke it in the cave of Boulderslide Ravine and killed him before his strength returned, and Mor'rogal called it a hero's deed.",
        "{We} went back down into Boulderslide Ravine to wake the Earthen Goggeroc and kill him at his weakest. Mor'rogal said all of Stonetalon and Kalimdor stood in {our} debt."},
    [6284] = {act = "killed Besseleth in Sishir Canyon", giver = "Maggran Earthbinder",
        "A warning by Sishir Canyon said to enter at one's own risk, for Besseleth and her eight-legged children had claimed it. {We} went in and killed her for Maggran Earthbinder's bounty. He hoped more travelers would now reach Sun Rock Retreat without fearing the dark.",
        "{We} went into Sishir Canyon after Besseleth, an old predator of those parts. Maggran Earthbinder called it good hunting and would not miss her."},
    [1069] = {act = "gathered deepmoss spider eggs for Mebok", giver = "Mebok Mizzyrix",
        "Spider egg omelettes were the new fad in Booty Bay. Mebok Mizzyrix had a deal with Dizzywig before he had a single egg. {We} gathered deepmoss eggs in Windshear Crag and Sishir Canyon. Mebok paid out a cut of a deal he could not have made alone.",
        "{We} took eggs from under the deepmoss spiders of Stonetalon for Mebok's latest scheme. He could already taste the profits from Booty Bay."},
    [6301] = {act = "gathered Gaea seeds by Mirkfallon Lake", giver = "Tammra Windfield",
        "Greed and endless war had wrecked Stonetalon, Tammra Windfield said, and only the Earthmother's blessing could heal it. {We} gathered Gaea seeds at the water's edge of Mirkfallon Lake, the only place they grew. She blessed them so they would bloom.",
        "{We} walked the shore of Mirkfallon Lake north of Sun Rock Retreat for the Gaea seeds Tammra needed. Even such small kernels of life would flourish, she said, under the Earthmother's blessing."},
    [6381] = {act = "planted Tammra's Gaea seeds in the Charred Vale", giver = "Tammra Windfield",
        "Tammra's blessed seeds were meant for the Charred Vale, the heart of the destruction, where harpies and fire elementals still haunted the land. {We} planted them in what fertile mounds remained, and she called it a great victory for the land.",
        "{We} carried the Gaea seeds into the burned Charred Vale and set them in the soil among harpies and fire. Tammra spoke of the day the goblins would pack up their saws and Stonetalon would know peace."},
    [6393] = {act = "gathered Incendrites in the Charred Vale for Tsunaman", giver = "Tsunaman",
        "Tsunaman had been sent by the Tribunal of the Tides to war on Stonetalon's fire elementals, as Neptulon the Tidehunter wished. {We} fought them in the Charred Vale and brought back the Incendrites they left behind. The water spirits within him bubbled with excitement.",
        "{We} quenched fire elementals across the Charred Vale and carried their Incendrites to Tsunaman at Sun Rock Retreat. He had a glorious victory to report to the Tribunal of the Tides."},
    [6282] = {act = "culled the Bloodfury harpies of the Charred Vale", giver = "Maggran Earthbinder",
        "The Bloodfuries of the Charred Vale were the source of the harpies spreading across Kalimdor, Maggran Earthbinder said. {We} culled them, and he wanted to hear again how fear had been cast into their cold hearts.",
        "{We} went into the Charred Vale and struck the Bloodfury harpies a serious blow. Maggran Earthbinder called it most excellent news."},
    [6283] = {act = "killed Bloodfury Ripper in the Charred Vale", giver = "Maggran Earthbinder",
        "Culling was not enough, Maggran said, while Bloodfury Ripper, a queen in all but name, roosted in the western hills of the Charred Vale. {We} found her and killed her, and Maggran felt his anger leave him and wondered what he would do with his time.",
        "{We} climbed the western hills of the Charred Vale and brought down Bloodfury Ripper. Maggran Earthbinder's thoughts fell silent, and he thought he might focus on the good, as all tauren should."},
    [1087] = {act = "culled the children of Cenarius on Stonetalon Peak", giver = "Braelyn Firehand",
        "Braelyn Firehand at Sun Rock Retreat hated Stonetalon, where the children of Cenarius and the druids of the peak stifled the flow of magic. {We} culled them for her, and she felt the power rushing back and called the kaldorei fools for spurning it.",
        "{We} climbed Stonetalon Peak and fought the druids and the children of Cenarius there, as Braelyn wanted. She called the returning flow of magic sweet."},
    [1088] = {act = "took Keeper Ordanus's head at Raynewood", giver = "Braelyn Firehand",
        "Braelyn's sight had found Keeper Ordanus, one of the eldest sons of Cenarius, hidden atop a great tree at Raynewood in Ashenvale. {We} climbed the tree, killed him and brought her his head, and she said he had held himself above even the Highborne once.",
        "{We} went to Raynewood for Braelyn Firehand, surer of {our} strength than ever, and took the head of Ordanus. It did not rise so high now, Braelyn said, and she paid the gift she had promised."},
    [1089] = {act = "opened the druids' hoard in the Talon Den", giver = "Braelyn Firehand",
        "Braelyn had pried the secret of the Talon Den from one of the druids. It was a chain of keys, starting with a Gatekeeper's Key in a lantern at the entrance. {We} worked through the caches and set three keys into the stone, and the hoard appeared in the light between them.",
        "{We} went up into the Talon Den on Stonetalon Peak and opened the druids' caches one by one. The last three keys slid into the stone, and their treasure shone up for {us}."},
    [742] = {act = "answered the call to the Ashenvale Hunt",
        "A call went out in Thunder Bluff for young adventurers to come north to Ashenvale. {We} went past the Barrens to Splintertree Post. Senani Thunderheart welcomed {us} to the frontier, told {us} to see the Zoram Strand too, and explained her hunt.",
        "{We} travelled from Thunder Bluff to Splintertree Post to join Senani Thunderheart's great hunt of Ashenvale. A land of opportunity, she called it, for fighters like {us}."},
    [3369] = {act = "brought Falla Sagewind's dream shard to Hamuul Runetotem", giver = "Falla Sagewind",
        "Falla Sagewind saw the Emerald Dream in a shard, and a vision in it more like a nightmare. She wanted it in a wise druid's hands soon. {We} took it to Hamuul Runetotem in Thunder Bluff, who looked into it and faltered.",
        "{We} carried the shard to Arch Druid Hamuul Runetotem on Elder Rise. Things in the Emerald Dream were not as the druids had thought, he said, and would say no more."},
    [5062] = {act = "took Incendia agave to Magatha for the sacred fire", giver = "Motega Firemane",
        "Arikara was deadly, Motega said, and could only be summoned by lighting the sacred fire of life. {We} gathered Incendia agave at the Boiling Pool and took it to Magatha Grimtotem on Elder Rise. She called the news grave, then smiled and began to enchant it.",
        "{We} brought Incendia agave to Magatha Grimtotem for the fire that would summon Arikara. She looked about her before she spoke of a creature born to avenge heinous deeds."},
    [1130] = {act = "answered Melor Stonehoof's summons", giver = "Jorn Skyseer", solo = true,
        "Word of {my} deeds in the Barrens had reached Melor Stonehoof, Jorn Skyseer said, and Melor had set a path for {me}. {I} went to Hunter's Rise in Thunder Bluff, and Melor asked whether {I} stood ready to journey through distant lands.",
        "{I} climbed to Hunter's Rise at Melor Stonehoof's summons, a hunter with a name of {my} own by then. He had distant lands in mind for {me}."},
    -- Ashenvale: Zoram'gar and Splintertree.
    [6442] = {act = "threw the naga back from the Zoram Strand", giver = "Marukai",
        "Beneath the sea off the Zoram Strand lay the drowned city of Zoram. The naga had come back to it for reasons no one knew. Marukai wanted the land the Horde had worked for defended, and {we} brought him twenty naga heads.",
        "{We} fought the naga along the coast below Zoram'gar Outpost, where an old city lay sunk and nearly forgotten. Marukai said the outpost could use more of {our} kind."},
    [6641] = {act = "put out the naga's brazier and killed Vorsha the Lasher", giver = "Muglash",
        "Vorsha the Lasher, a hydra of the seas, had attacked Zoram'gar more than once, and Muglash had a plan. {We} went with him to the island off the coast, put out the naga's brazier, and killed Vorsha when she came ashore in anger.",
        "{We} stood with Muglash on the island where the naga kept a brazier lit for Vorsha, and when it went dark the hydra came. She died there, and Muglash said Zoram'gar was in {our} debt."},
    [216] = {act = "thinned the Thistlefur furbolgs east of Zoram'gar", giver = "Karang Amakkar",
        "Thistlefur Village blocked the path between Zoram'gar and Splintertree that skirted Astranaar, and Karang Amakkar would not allow an expansion path gap. {We} went in and thinned the furbolgs, and he declared the Horde's conquest of Ashenvale in full swing.",
        "{We} fought through Thistlefur Village so the Horde's two outposts could be linked without passing Astranaar. Karang Amakkar paid as promised and called it duty done for the Horde."},
    [6462] = {act = "recovered the troll charms from Thistlefur Hold", giver = "Mitsuwa",
        "Mitsuwa's kin had died to the Thistlefur while carrying sacred troll charms to Zoram'gar. {We} found the charms in the chests of Thistlefur Hold. A troll without his charm, she said, was like an orc without his scars.",
        "{We} went to the cave at the end of Thistlefur Village for the charms of Mitsuwa's dead kinfolk. She would meet them in the afterlife, she said, but the charms belonged in this world."},
    [6482] = {act = "freed Ruul Snowhoof from the Thistlefur", giver = "Ruul Snowhoof",
        "The Thistlefur had taken Ruul Snowhoof for a bear and were starving him in a cage in Thistlefur Hold. {We} helped him escape and carried word to his sister Yama at Splintertree Post. She was shocked, and said Ruul would sleep long after this.",
        "{We} brought Ruul Snowhoof out of Thistlefur Hold and told his sister at Splintertree what had happened. Many furbolgs were noble, Yama said, but the Thistlefur were corrupt."},
    [6503] = {act = "hunted the Ashenvale outrunners from Silverwing", giver = "Kuray'bin",
        "Outrunners from Silverwing Outpost were sneaking near the Horde's lands to learn its defenses, and Kuray'bin wanted them dead. {We} hunted them through the forests south of Splintertree, and he said a blind enemy attacked less.",
        "{We} crept through the woods east of Silverwing after the Alliance's scouts and killed them. Kuray'bin called {our} hunting impressive."},
    [6544] = {act = "joined Torek's raid on Silverwing Outpost",
        "Torek and his raiders were about to strike Silverwing Outpost and its leader, Duriel Moonfire, and Torek called the coming battle glorious. {We} fought beside them, and Ertog Ragetusk at Splintertree hoped it had left {us} a scar or two.",
        "{We} marched with Torek's raiders on the heavily defended Silverwing Outpost and saw Duriel Moonfire fall. Ertog Ragetusk thought it must have been something to see, and said night elves were skinny but fierce."},
    [6441] = {act = "gathered satyr horns for Pixel", giver = "Pixel",
        "Pixel the goblin had stopped at Splintertree on her way to Ratchet and smelled an opportunity in satyr horns. {We} took them from the satyrs of Night Run, Satyrnaar and Xavian, and she called them perfect and paid.",
        "{We} went into the satyr haunts of Ashenvale for the horns Pixel could sell in Ratchet. She was no match for satyrs herself, she said, and gladly paid for {our} time."},
    [6621] = {act = "planted the Horde banner and killed Chief Murgut", giver = "Karang Amakkar",
        "Karang wanted the Foulweald shown the Horde's force, a banner planted on their sacred totem mound to bring out Chief Murgut. {We} planted it, killed Murgut when he came to save face, and brought Karang his totem.",
        "{We} challenged the Foulweald on their own mound southeast of Astranaar and took their chief's totem. Karang expected no trouble from that tribe for a long time."},
    [6571] = {act = "gathered the supplies the Warsong camp lacked", giver = "Locke Okarr",
        "The Warsong lumber camp was short of saw blades, axes, rope and oil, scattered from Splintertree to Booty Bay and the satyr ruins. {We} gathered every piece of it for Locke Okarr, who said it had saved him a lot of work.",
        "{We} ran Locke Okarr's errands from the furbolg camps to the satyr ruins and as far as Booty Bay. The Warsong camp had its supplies, and Locke was grateful."},
    [6504] = {act = "gathered the lost pages of Gurda's shredder manual", giver = "Gurda Ragescar",
        "Gurda Ragescar had picked up a shredder in Ratchet, but the wind tore its manual from her hands and scattered it across Ashenvale. {We} found the loose sheets and brought them back. Gurda admitted reading was not her strong point but she could get to work.",
        "{We} searched the forest for the scattered sheets of a shredder manual so Gurda could get back to the lumber camp. Reading was not her strong suit, she admitted, but she would manage."},
    -- Thousand Needles, the Kraul and Shadowfang Keep.
    [4542] = {act = "carried Brave Moonhorn's warning to Freewind Post", giver = "Brave Moonhorn",
        "Brave Moonhorn at the Great Lift had an urgent message for Freewind Post about the centaur's attacks. {We} carried it to Cliffwatcher Longhorn, who called it more bad news, since the centaur had just slaughtered one of his caravans.",
        "{We} took Brave Moonhorn's message across the canyon floor of Thousand Needles to Freewind Post. Cliffwatcher Longhorn swore the caravan's slaughter would not go unpunished."},
    [4841] = {act = "struck the centaur camp north of Freewind Post", giver = "Cliffwatcher Longhorn",
        "Cliffwatcher Longhorn wanted the centaur who had slaughtered his caravan hunted down, and asked that wrath guide {our} hand. {We} attacked their camp north of Freewind Post, and he paid out of gratitude.",
        "{We} took Longhorn's revenge to the centaur camp north of the post. The Horde's answer to the caravan's slaughter was delivered."},
    [4881] = {act = "warned Kanati Greycloud of the centaur plot",
        "{We} found centaur orders to kill Kanati Greycloud, a tauren bold enough to set up a hunting camp in the Needles. {We} warned him, and Kanati said he would show them how a tauren fought.",
        "Centaur orders taken in the Needles told of a plan to kill Kanati Greycloud as a warning to others. {We} carried the news to his camp southwest of the Great Lift."},
    [4966] = {act = "stood with Kanati Greycloud against the centaur assassins", giver = "Kanati Greycloud",
        "Kanati feared there would be more centaur than he could handle, and asked {us} to stand beside him. {We} fought off the assassins when they came, and he said he could not have held them without {us}.",
        "{We} waited with Kanati Greycloud at his hunting camp and fought the centaur assassins sent to kill him. He lived, and thanked {us} for it."},
    [4770] = {act = "brought the lost Pao'ka Swiftmountain home from Highperch",
        "Pao'ka Swiftmountain had come to Highperch to study the wyverns, got too close to a nest and had hidden for days. {We} brought him east to Whitereach Post, where Motega said he would have chained the boy to a totem had he known.",
        "{We} found young Pao'ka lost among the wyvern nests of Highperch and walked him home to Whitereach Post. Motega paid for the help and hoped it covered any misfortune."},
    [4904] = {act = "led Lakota Windsong out of Darkcloud Pinnacle",
        "Lakota Windsong had refused Arnak Grimtotem's offer of marriage, and that night he took her and killed her brother. {We} escorted her out of Darkcloud Pinnacle. Her friend Thalia had known in her bones she would come back, and gave {us} the dead brother's belongings.",
        "{We} brought Lakota Windsong down from the Grimtotem's Darkcloud Pinnacle to Thalia, who was worried sick. Lakota told her of the escape, and Thalia thanked {us} with what Lakota's brother had left."},
    [5064] = {act = "stole the Grimtotem's secret messages from Darkcloud Pinnacle", giver = "Cliffwatcher Longhorn",
        "Three strangers had visited the Grimtotem, and Cliffwatcher Longhorn trusted {us} to learn why. {We} took the guarded messages from the chests on Darkcloud Pinnacle. Longhorn read them in alarm and began planning for what they foretold.",
        "{We} broke into the Grimtotem's chests on Darkcloud Pinnacle and brought Longhorn all three secret notes. Great Spirit Totem, he said, and called it dire news."},
    [5088] = {act = "summoned and killed Arikara at the sacred fire", giver = "Magatha Grimtotem",
        "Magatha feared Arikara was stalking Cairne Bloodhoof. {We} carried her purified Incendia powder to the sacred fire, on the isolated needle where the tauren buried their dead. {We} threw it on the flames and killed Arikara when she came.",
        "{We} summoned Arikara at the sacred fire of life on Darkcloud Pinnacle and slew her. Motega could not see why she would hunt Cairne, but Magatha was their most powerful shaman, and he shook his head."},
    [5151] = {act = "freed Wizlo's hypercapacitor from the caged panther", giver = "Wizlo Bearingshiner",
        "Wizlo Bearingshiner was the only survivor of a caravan the centaur had attacked. A caged panther wore his best gizmo around its neck. He gave {us} the key, {we} opened the cage and won the hypercapacitor back, and he meant to work out what it did.",
        "{We} took the key from Wizlo and faced the rare panther the centaur had left alone in its cage. Wizlo had his hypercapacitor, and a puzzle to keep him busy."},
    [1221] = {act = "dug blueleaf tubers in Razorfen Kraul with Mebok's gophers", giver = "Mebok Mizzyrix",
        "Blueleaf tubers grew in one place, deep in Razorfen Kraul, and Mebok Mizzyrix had trained snufflenose gophers to smell them at fifty paces. {We} took his gophers into the quilboar warren and came out with tubers, and he called it a great partnership.",
        "{We} went down among the quilboar of Razorfen Kraul with Mebok's gophers and dug the tubers they found. Mebok had contacts who would pay a bundle for them."},
    [1144] = {act = "escorted Willix the Importer out of Razorfen Kraul",
        "Willix the Importer had been held so long in Razorfen Kraul he could not remember the outside, all for a tuber run gone wrong. {We} fought him out through the warren, and he paid {us} as he had promised.",
        "{We} found a goblin prisoner deep in the Kraul and brought him back into the light. Willix had promised to make it worth {our} trouble, and he did."},
    [1013] = {act = "brought Ur's writings out of Shadowfang Keep", giver = "Keeper Bel'dugur",
        "Keeper Bel'dugur prized the writings of Ur, a mage of Dalaran who had studied other worlds, and one lay in Shadowfang Keep. {We} went in and brought it out. Bel'dugur said Ur's conscience had held him back from true power, a weakness the Forsaken could not afford.",
        "{We} fought through Shadowfang Keep for the work of a long-dead mage of Dalaran and gave it to Keeper Bel'dugur in the Apothecarium. He promised to tell the Dark Lady of the service."},
    -- The shaman's four calls, told as the character's own trials.
    [1516] = {act = "took felstalker hooves for Canaga Earthcaller", giver = "Canaga Earthcaller", solo = true,
        "Canaga Earthcaller judged {me} ready to stand before the earth itself, and patience was its greatest virtue, he said. {I} took two hooves from the felstalkers north of the valley, and he turned to brewing {my} sapta.",
        "{My} first step on the shaman's path was a hunt for felstalker hooves. Canaga spoke of earth as the foundation of all things, strength and stamina and patience, and set to work on the sapta."},
    [1517] = {act = "drank the earth sapta at Spirit Rock", giver = "Canaga Earthcaller", solo = true,
        "A sapta was drunk only in a holy place, Canaga said. {I} carried his to Spirit Rock at the end of the Hidden Path. There the earth spoke to {me}, pleased to find a humble young shaman. The other elements, it warned, would not be so still.",
        "At Spirit Rock {I} drank the sapta and saw the earth as no one else could. The mountains would be {my} strength and the plains {my} patience, it said."},
    [1518] = {act = "brought the earth spirit's quartz back to Canaga", giver = "Canaga Earthcaller", solo = true,
        "The earth spirit gave {me} a rough quartz as proof of {our} meeting, saying even the smallest thing could outlast many larger ones. {I} carried it back to Canaga Earthcaller, who made it the heart of {my} first totem.",
        "{I} returned from Spirit Rock with a pebble of quartz, and Canaga crafted an earth totem around it. He welcomed {me} to the first of the four paths."},
    -- (#1519: a repeated completion is told as an "again" turn by name, QD.Moment, 2026-11-07)
    [1519] = {act = "took salve from the Bristleback shamans for Seer Ravenfeather", giver = "Seer Ravenfeather", solo = true,
        "Seer Ravenfeather saw wisdom in {me} already, and said the earth was calling {me}. {I} went into the ravine east of the camp and took the salve the Bristleback shamans used in their rituals. She judged {me} prepared for the next step.",
        "The earth was the most stubborn and wise of the elements, Ravenfeather taught, and its first test was Bristleback salve. {I} brought back enough for her to make {my} sapta."},
    [1520] = {act = "drank the earth sapta at the shrine east of Narache", giver = "Seer Ravenfeather", solo = true,
        "Ravenfeather's sapta was to be drunk at the shaman shrine east of the camp and nowhere else. {I} drank it there, and the earth spoke to {me}, pleased to find a young shaman humble before it. The other elements, it warned, would not be so passive.",
        "At the shrine east of Narache {I} drank the sapta and the earth showed itself to {me}. The mountains would be {my} strength, it said, and the plains {my} patience."},
    [1521] = {act = "brought the earth spirit's quartz back to Ravenfeather", giver = "Seer Ravenfeather", solo = true,
        "The earth spirit gave {me} a rough quartz, a pebble that could outlast mountains, as proof of {our} meeting. {I} carried it to Seer Ravenfeather, who crafted {my} first totem around it.",
        "{I} brought the quartz from the shrine back to Seer Ravenfeather, and she made it the heart of an earth totem. She welcomed {me} to the first of the four paths."},
    [92466] = {act = "took an Al'Aketh signet at the standing stones", giver = "Windshaper Boro", solo = true,
        "The Windshapers owed their prosperity to the winds, but {my} path meant answering all four elements, beginning with earth. First {I} had to prove {my} resolve. {I} drove the Al'Aketh converts from the standing stones and brought back one of their signets.",
        "Before {my} first trial Windshaper Boro wanted proof of resolve against the cult that had weakened the island's bond with the winds. {I} fought the Al'Aketh at the standing stones for a signet."},
    [92467] = {act = "drank the earth sapta at the Rise of Spirits", giver = "Windshaper Boro", solo = true,
        "{I} carried {my} sapta up the pass to the Rise of Spirits, sacred ground, and drank it there. The earth called {me} a child of the four winds, and said it could not tell {me} why the winds had left.",
        "At the Rise of Spirits the earth spoke to {me}. It knew what {I} sought, answers about the vanished winds, but those were not its to give."},
    [92468] = {act = "brought the earth spirit's quartz to Windshaper Boro", giver = "Windshaper Boro", solo = true,
        "The earth spirit gave {me} a shard of rough quartz for Windshaper Boro, the heart of the totem it promised. {I} brought it down from the Rise, and Boro made {my} earth totem.",
        "{I} returned to Windshaper Boro with the quartz and received {my} first totem. The winds were only one of the world's forces, Boro taught, and the path was not simple."},
    [94373] = {act = "took Frostmane necklaces for Teo Hammerstorm", giver = "Teo Hammerstorm", solo = true,
        "Teo Hammerstorm said {I} had the grit of stone for the earth's path, and sent {me} south to the Frostmane trolls' cave. {I} brought back two of their necklaces carved from Iceclaw bears, and he could brew {my} sapta.",
        "{My} first test as a shaman was in the snow, two Frostmane necklaces from the trolls' cave. Teo told {me} patience was the earth's finest virtue, and that trouble brewed on the horizon."},
    [94374] = {act = "drank the earth sapta at the Spirit Stone", giver = "Teo Hammerstorm", solo = true,
        "{I} climbed the hidden path up the mountain to the Spirit Stone and drank Teo's sapta there. The earth welcomed {me} even in that frozen land and told {me} the other elements clashed and roared.",
        "At the Spirit Stone, among snow and stone, the earth bound itself to {me}. To pass the rite, it said, {I} needed only to stand humbly before it."},
    [94375] = {act = "brought the earth spirit's quartz to Teo Hammerstorm", giver = "Teo Hammerstorm", solo = true,
        "The earth gave {me} a rough quartz for Teo Hammerstorm, small but able to outlast many larger things. {I} carried it down the mountain, and Teo made it the heart of {my} first totem.",
        "{I} returned to Teo Hammerstorm with the stone, proof that the mountain had chosen {me}. He crafted {my} earth totem with the stone at its heart."},
    [1522] = {act = "went to Kranal Fiss for the call of fire", giver = "Searn Firewarder", solo = true,
        "Searn judged {me} strong in the ways of earth, and sent {me} north of the Crossroads to Kranal Fiss. Kranal saw the burning in {my} eyes and offered {me} the sapta of fire.",
        "{I} found Kranal Fiss in his dwelling north of the Crossroads on Searn's word. Power and destruction would come easily to {me}, he said, and the lesson was knowing when to stay {my} hand."},
    [1523] = {act = "went to Kranal Fiss for the call of fire", giver = "Xanis Flameweaver", solo = true,
        "{My} trainer said the time had come to learn destruction and chaos, if {I} would pay the price. {I} went to Kranal Fiss north of the Crossroads. Kranal trusted Xanis's word and saw the desire for power already in {me}.",
        "{I} took the road north of the Crossroads, stopping short of the night elf lands, to Kranal Fiss's small dwelling. He offered {me} the sapta of fire."},
    [2984] = {act = "went to Kranal Fiss for the call of fire", giver = "Narm Skychaser", solo = true,
        "Narm Skychaser judged {my} patience proven and said the time had come to learn of fire, of destruction and chaos. {I} went north of the Crossroads to Kranal Fiss, who trusted Narm and saw the burning in {my} eyes.",
        "On Narm's word {I} sought out Kranal Fiss, who lived alone north of the Crossroads. He offered {me} the sapta of fire, and warned that knowing when to stay {my} hand was the true lesson."},
    [1524] = {act = "climbed to the Shrine of the Dormant Flame with Kranal's torch", giver = "Kranal Fiss", solo = true,
        "Kranal said strength was not the same as readiness, and gave {me} a torch to carry to the Shrine of the Dormant Flame. {I} climbed the hidden trail along the Southfury River, and Telf Joolam nearly turned {me} away until he saw it.",
        "{I} climbed the hidden trail above the Southfury to the Shrine of the Dormant Flame. To treasure hunters it was an empty shrine, Telf Joolam said, and to shamans it was sacred."},
    [1525] = {act = "gathered fire tar and a cultist's pouch for Telf Joolam", giver = "Telf Joolam", solo = true,
        "Telf Joolam needed two things for {my} fire sapta, fire tar from the Razormane spellcasters and a reagent pouch from the Burning Blade's cave. {I} brought both, and he said fire was about life and creation as much as chaos.",
        "{I} took fire tar from the Razormane and a pouch from the Burning Blade cultists, the more dangerous of the two. Telf judged they would do nicely and began the sapta."},
    [1526] = {act = "defeated the fire manifestation atop the shrine's peak", giver = "Telf Joolam", solo = true,
        "{I} drank the fire sapta at the shrine and climbed to the top of the mountain. A manifestation of fire waited there, growing stronger the longer it lived. {I} struck it down quickly and set its glowing embers in the brazier, and a white-hot flame rose to light {my} torch.",
        "At the peak above the Shrine of the Dormant Flame {I} faced the spirit of fire the sapta let {me} see. Its embers lit the brazier, and {my} torch caught at once."},
    [1527] = {act = "carried the burning torch back to Kranal Fiss", solo = true,
        "Torch in hand, {I} looked out over Durotar from the peak and felt an excitement tugging at {my} spirit. Kranal Fiss said {my} spirit burned brighter than any torch he had seen and gave {me} the fire totem.",
        "{I} carried the flame from the shrine all the way to Kranal Fiss north of the Crossroads. One day, he said, {my} brethren would look to {me} for guidance and wisdom."},
    [97243] = {act = "carried a torch to Olariaan Swiftburn at the Shrine of Flames", solo = true,
        "Even in Skywall all four elements spoke to those who listened, and Olariaan Swiftburn was the Windshaper closest to fire. {I} carried a torch to him at the Shrine of Flames, on the island's edge west of Valanaar. He agreed to teach {me}, though it would not be easy.",
        "{I} found the hidden Shrine of Flames in the Gustberry Lowlands and gave Olariaan Swiftburn the torch. Nothing done in this realm was ever easy, he said, and {my} trial began."},
    [97244] = {act = "killed Skypriest Faladiel and took his heart", giver = "Olariaan Swiftburn", solo = true,
        "Skypriest Faladiel had been a caller of the flame and a Windshaper before he sold his loyalty to the Al'Aketh. His hands were stained with his brothers' blood. {I} killed him at the farm past Valanaar and brought his heart to Olariaan for the ritual.",
        "{I} hunted down the betrayer Faladiel near the Shrine of Akir and carried back his heart, a powerful offering. The Windshapers did not forget, Olariaan said, and blood was paid with blood."},
    [97245] = {act = "took the wooden mask of the sprite Kuramaa", giver = "Olariaan Swiftburn", solo = true,
        "The highland folk spoke of Kuramaa, an ancient forest sprite in a twisted stump near the anchor pylon. {I} knocked on the bark, fought the spirit with flame since little else could touch it, and brought Olariaan its wooden mask.",
        "{I} climbed the hill by the highlands' anchor pylon and rapped on Kuramaa's stump until the sprite came out. With its mask the offerings were complete, and Olariaan meant to light the Eternal Flame."},
    [97257] = {act = "carried the Eternal Flame to Valanaar's brazier", giver = "Olariaan Swiftburn", solo = true,
        "Olariaan laid the offerings on the altar and called the spirits of flame, and they lit the Eternal Flame for {my} torch. {I} ran it to the Brazier of Eternal Flames in Valanaar before the fire could fade in Skywall. It burned there once more.",
        "{I} caught the Eternal Flame on {my} torch and carried it quickly to Valanaar. Olariaan gave {me} the fire totem and said the elemental plane served those who respected it and consumed those who did not."},
    [94449] = {act = "went to Bruegs Kindleborn for the call of fire", solo = true,
        "{My} elder said it was time to learn of chaos and destruction. {I} went east into the mountains to Bruegs Kindleborn's cave above South Gate Outpost. Bruegs took the elder's word as solid and saw the burning in {my} eyes.",
        "{I} climbed to the cave above South Gate Outpost to find Bruegs Kindleborn. He judged {me} ready for the next sapta, the sapta of fire."},
    [94465] = {act = "climbed to the Shrine of the Dormant Flame in Loch Modan", giver = "Bruegs Kindleborn", solo = true,
        "Strength alone would not make {me} ready for the fire totem, Bruegs said. He gave {me} a torch for the Shrine of the Dormant Flame. {I} climbed the hidden path beyond the Valley of Kings, and Braldir Ashmantle nearly turned {me} back until he saw it.",
        "{I} climbed to the shrine high in Loch Modan's crags with Bruegs's torch. Wanderers found only stone and silence there, Braldir Ashmantle said, but shamans found a sacred flame waiting to wake."},
    [94466] = {act = "gathered fire tar and a seer's pouch for Braldir Ashmantle", giver = "Braldir Ashmantle", solo = true,
        "Braldir needed two things for {my} fire sapta, fire tar from the Tunnel Rat geomancers and a pouch from a Stonesplinter seer. {I} brought both, and he said fire was the forge and the breath of creation as well as ruin.",
        "{I} went into the kobold caves for fire tar and into the southern hills for a seer's pouch. Braldir said mastering magic meant knowing when to blend rather than burn."},
    [94467] = {act = "defeated the spirit of flame above the shrine", giver = "Braldir Ashmantle", solo = true,
        "{I} drank Braldir's sapta and climbed to the peak above the shrine, where a spirit of flame waited, burning stronger the longer it lived. {I} struck it down, set its embers in the brazier, and the torch caught with Blackrock Mountain in plain view.",
        "On the peak above the Shrine of the Dormant Flame {I} fought the spirit of fire only the sapta let {me} see. A white-hot flame rose in the brazier, and its smoke drifted toward Blackrock."},
    [94468] = {act = "carried the burning torch back to Bruegs Kindleborn", solo = true,
        "Torch in hand, {I} looked out over Loch Modan from the shrine and felt an excitement tugging at {my} spirit. By Madoran's beard, Bruegs said, {my} spirit burned brighter than any torch he had seen, and he gave {me} the fire totem.",
        "{I} brought the flame from Loch Modan's peak all the way to Bruegs Kindleborn's cave. He offered his hearty congratulations and {my} fire totem."},
    [1528] = {act = "went to Islen Waterseer for the call of water", solo = true,
        "{My} trainer saw {me} strong in the ways of fire, and sent {me} south along the Southfury River to Islen Waterseer, just beyond Ratchet. Islen found {my} spirit warmed by fire and judged it time to learn the purity of water.",
        "{I} found Islen Waterseer's fishing hut on the coast south of Ratchet. The first step on water's path, she said, was {my} own to take."},
    [2986] = {act = "went to Islen Waterseer for the call of water", solo = true,
        "{My} trainer said the time had come for {me} to learn the purity of water. {I} went to Islen Waterseer's fishing hut on the coast south of Ratchet. Islen saw the earth steady under {me} and {my} spirit warmed by fire.",
        "{I} travelled to the eastern coast of the Barrens to begin the call of water with Islen Waterseer. She judged {me} ready for the next path."},
    [1529] = {act = "went to Islen Waterseer for the call of water", solo = true,
        "{My} trainer judged {my} patience proven, and sent {me} to learn the purity of water from Islen Waterseer south of Ratchet. Islen found {my} spirit already warmed by fire.",
        "{I} sought Islen Waterseer at her fishing hut on the Barrens coast, as {my} trainer had bidden. The water's lessons began with her."},
    [1530] = {act = "sought Brine in the southern Barrens for the water sapta", giver = "Islen Waterseer", solo = true,
        "Water meant rebirth, Islen taught {me}, and it healed only when pure. {I} went deep into the southern Barrens to Brine, whose home the quilboar kept harassing. She guessed {my} question before {I} asked it.",
        "{I} crossed the quilboar's ground in the south of the Barrens to find Brine, who held the secret of the water sapta. Everyone had reasons for how they lived, she said."},
    [1535] = {act = "filled a waterskin at the pond below Brine's hut", giver = "Brine", solo = true,
        "Brine began with a simple task, a skin of water from the pond below her hut. She told {me} to watch the creatures that lived by the water and guarded it. The quilboar, she said, failed to see all living things as tied together.",
        "{I} filled Brine's waterskin at the pond beneath her hut, the first of her pure samples. Water that sustained life could also drive creatures to take it, she taught."},
    [1536] = {act = "drew spring water from the well in Tarren Mill", giver = "Brine", solo = true,
        "Years ago Brine had found a well of fresh spring water in the middle of Tarren Mill, a holy vestige in an unhallowed sea. {I} travelled all the way to Hillsbrad for a skin of it, and she called the water good and {my} dedication better.",
        "{I} crossed to Lordaeron and drew water from the well at the heart of the Forsaken's Tarren Mill. One more sample, Brine said, and the reagent would be complete."},
    [1534] = {act = "drew water from the fountain in the Ruins of Stardust", giver = "Brine", solo = true,
        "The last sample lay far north in Ashenvale, in a small fountain at the center of the Ruins of Stardust beyond Lake Mystral. From it Brine made a vial of the purest water any creature would find, and she was pleased to count {me} among her kind.",
        "{I} went into the night elves' forest to the holy Ruins of Stardust for Brine's final sample. With all three she could make the vial that would send {me} back to Islen."},
    [220] = {act = "brought Brine's blessed vial back to Islen", giver = "Brine", solo = true,
        "Brine sent {me} back to Islen Waterseer with the vial of water she had made and blessed. Islen admired it. It would make a sapta for the spirits of a shrine in Silverpine, she said, with its last drops kept for another task.",
        "{I} returned to Islen's fishing hut on the coast carrying Brine's vial. One more task stood between {me} and the water totem."},
    [63] = {act = "cleansed the plagued water shrine in Silverpine", giver = "Islen Waterseer", solo = true,
        "On the Silverpine coast west of the Sepulcher the plague had tainted a shrine, and its spirits no longer spoke. {I} killed the corrupt manifestation there and laid its bracers and the last of Brine's drops on the brazier. Then {I} spoke the simple words Islen had taught.",
        "{I} went to the tainted shrine on the coast of Silverpine and defeated the water spirit the plague had twisted. The drops crackled in the flame as {I} began the ritual."},
    [100] = {act = "spoke with the pure water spirit at the cleansed shrine", solo = true,
        "Light burst out as {I} finished the incantation, and the corrupt spirits around the shrine were destroyed. A pure water spirit spoke to {me} at last, thanking the shamans and warning that corruption ebbed while life still waned.",
        "When the ritual ended, the shrine in Silverpine was clean, and its water spirit could speak. It was up to shamans to protect life, it told {me}."},
    [1103] = {act = "showed Tiev a water sapta at the Silverpine shrine", solo = true,
        "Tiev had just killed the corrupt water spirit himself and was about to use the brazier. He offered to wait so {I} could see the pure spirit too. {I} showed him Islen's sapta, and he put in his parts and took {me} down to the shrine.",
        "At the shrine in Silverpine a troll shaman named Tiev offered to share his ritual with {me}. Once he saw {my} sapta, he said he knew a trick or two about how its magic worked."},
    [96] = {act = "brought the water spirit's shard to Islen Waterseer", giver = "Islen Waterseer", solo = true,
        "The water spirit gave {me} a shard and a charge to protect and give life with water's power. {I} carried it back to Islen, who took it as proof and gave {me} the water totem. Even small successes mattered, she said, in a land so corrupt.",
        "{I} returned from Silverpine to Islen's hut with the spirit's shard. She gave {me} {my} third totem, and said the next test would not come for some time."},
    [94495] = {act = "sought Hervdana Saegrund in the Wetlands for the water sapta", giver = "Norric", solo = true,
        "Water meant rebirth, Norric taught {me}, and it healed only when pure. {I} went to the Wetlands to find Hervdana Saegrund in her family's cave beneath the southern falls. She read the question in {my} eyes before {I} asked it.",
        "{I} crossed the Wetlands, with Dark Irons about, to the cave beneath the southern falls. Hervdana Saegrund said everyone had reasons for how they lived, and asked what had brought a shaman to her door."},
    [94497] = {act = "filled a waterskin where the falls met the brackish water", giver = "Hervdana Saegrund", solo = true,
        "Hervdana began simply, a skin filled at the base of the falls where fresh water met brackish. She told {me} to watch the beasts and land the water touched. {I} brought it back without crossing the Dark Irons, and she called it a sacred offering.",
        "{I} filled Hervdana's waterskin in the estuary below the falls, minding the marsh as she said. She wondered aloud what dwarfkind might do if the clans ever stopped squabbling."},
    [94499] = {act = "drew a sample from Stonewatch Falls in Redridge", giver = "Hervdana Saegrund", solo = true,
        "Something seeped into Lake Everstill's water by the time it tumbled down Stonewatch Falls, Hervdana said, and the murlocs there were twisted brutes. {I} went to Redridge for a sample, and she called it good and pure and blamed the shadowseers' magic for the murlocs.",
        "{I} brought Hervdana water from the foot of Stonewatch Falls, past the big murlocs that kept to its base. One more sample, she said, and Norric would be pleased."},
    [94500] = {act = "drew water from the lake at Astranaar", giver = "Hervdana Saegrund", solo = true,
        "The last sample lay far across the sea, in the lake that cradled Astranaar with ruins on its bed. {I} took the boat from Menethil and brought it back. Hervdana said she would brew water pure enough to make the mountains weep.",
        "{I} sailed to Kalimdor and walked into Ashenvale's shade for water from the lake at Astranaar. Hervdana was proud, she said, to call {me} kin."},
    [94501] = {act = "brought Hervdana's blessed vial back to Norric", giver = "Hervdana Saegrund", solo = true,
        "Hervdana sent {me} back to Norric with the vial she had blessed. He called it a gift, gathered by {my} own hands. It would birth a sapta to glimpse the water spirits at Stendel's Pond near Moonbrook.",
        "{I} returned to Norric in Loch Modan with Hervdana's vial of pure water. Not a drop of what remained was to be wasted, he warned, for one more task lay ahead."},
    [94502] = {act = "cleansed Stendel's Pond outside Moonbrook", giver = "Norric", solo = true,
        "Stendel's Pond outside Moonbrook had been a pure spring until dark forces touched it, and its spirits had gone silent. {I} faced the corruption there and laid its bracers on the old shrine with the last of Hervdana's drops. Then {I} spoke the words Norric had taught.",
        "{I} went to Westfall and fought the thing that fouled Stendel's Pond. The drops turned to mist on the dusty shrine as {my} ritual began."},
    [94503] = {act = "spoke with the pure water spirit at Stendel's Pond", solo = true,
        "Light erupted as the last word left {my} lips, and the corrupt spirits around Stendel's Pond scattered like ash. A pure water spirit spoke to {me} at last, thanking the shamans and warning that life still waned.",
        "When {my} ritual ended, the water spirit of Stendel's Pond could speak again. It told {me} it was up to shamans to protect life."},
    [94505] = {act = "brought the water spirit's shard to Norric", giver = "Norric", solo = true,
        "The water spirit gave {me} a shard and a charge to protect and give life with water's power. {I} brought it back to Norric, who was proud to be the first to congratulate {me} and gave {me} {my} water totem.",
        "{I} returned from Westfall to Norric with the spirit's shard as proof. The next trial would not come soon, he said, and pure water's gifts went beyond mending wounds."},
    [1531] = {act = "sought Prate Cloudseer in Thousand Needles for the air totem", solo = true,
        "Air was the last element and the hardest to control. {My} trainer laughed and sent {me} south to find Prate Cloudseer, hiding in a hole in the east of Thousand Needles. Prate gave {me} an air totem for the time being and promised more training when {I} stood ready.",
        "By then {I} had walked three of the four paths, and the call of air took {me} far into Thousand Needles to Prate Cloudseer. She gave {me} what {I} needed to call upon the spirits of air."},
    [1532] = {act = "sought Prate Cloudseer in Thousand Needles for the air totem", solo = true,
        "The winds of Kalimdor rushed to meet {me}, {my} trainer said, and {I} would be counted among the most powerful of the shamans. {I} went to the far east of Thousand Needles to Prate Cloudseer, who gave {me} an air totem for the time being.",
        "{I} travelled through the Barrens and down into Thousand Needles to learn the last of the four elements from Prate Cloudseer. She would teach {me} more when {I} stood ready."},
}
for id, pov in pairs(POV) do
    if pack.questIDs[id] then pack.questIDs[id].pov = pov end
end
A.Lore.RegisterStoryPack("horde-and-zephras", pack)
