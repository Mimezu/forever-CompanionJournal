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
pack.questIDs[6395].highlight = {"Samuel Fipps, who had killed his wife Marla as one of the Scourge, was destroyed and buried in her grave. Novice Elreth hoped the two would find peace together.", "Marla Fipps had asked to be buried with the husband who killed her. Samuel's remains were laid in her grave at Deathknell, and Elreth called it a good deed."}
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
    "Magatha's purified Incendia powder was to be thrown on the sacred fire of life at Darkcloud Pinnacle. The fire stood on the isolated needle where the Grimtotem buried their dead. She feared Arikara was stalking Cairne Bloodhoof, angered by how much tauren lore had changed, and urged haste.",
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
        "{I} woke on the cold stone of a crypt, and Mordo sent {me} down the hill to Shadow Priest Sarvis. In the chapel {I} learned what {I} had become, one of the Forsaken, free of the Lich King, with the Scourge and the last humans of Lordaeron as enemies.",
        "Mordo had been ready to burn {me} for a corpse when {I} stirred in the crypt. He sent {me} to Shadow Priest Sarvis instead, and Sarvis told {me} that Sylvanas had set the Forsaken free."},
    [364] = {act = "cut down the Mindless Ones in the north of the village", giver = "Shadow Priest Sarvis",
        "Sarvis sent {us} into the north of the village, where the Mindless Ones shambled among the houses, still slaves of the Lich King. {We} cut them down, and Sarvis only wished they could have joined the Forsaken instead.",
        "{We} cut down the Mindless Ones in the north of the village. They had been brothers and sisters to the Forsaken once, Sarvis said, but the Lich King still held them."},
    [376] = {act = "hunted wolves and bats for Novice Elreth", giver = "Novice Elreth",
        "South of the village {we} hunted wolves and bats for their paws and wings, and Novice Elreth gave {us} armor for them, hoping it would serve better than it had served its last wearer.",
        "Novice Elreth was short of wolf paws and bat wings for the wounded she tended. {We} brought her what she needed, and she found {us} armor in return."},
    [3901] = {act = "thinned the Rattlecage skeletons", giver = "Shadow Priest Sarvis",
        "The Rattlecage skeletons were a harder fight than the zombies, and {we} thinned them as Sarvis asked. When {we} came back he declared his lessons finished, and told {us} the Forsaken would never be shackled again.",
        "Sarvis tested {us} against the Rattlecage skeletons, bones that rattled among the graves. {We} thinned them, and he judged {us} worthy of the freedom the Forsaken had been given."},
    [3902] = {act = "searched the village crates for the recruits still rising", giver = "Deathguard Saltain",
        "{We} went through the crates and boxes of the village for gear the newly risen could wear, and Deathguard Saltain kept one of the better finds back for {us}.",
        "Deathguard Saltain wanted no recruit stumbling about naked, so {we} searched the village crates for anything to wear. He kept back one of the better finds as {our} reward."},
    [381] = {act = "struck the Scarlet camp outside the village", giver = "Executor Arren",
        "Scarlet zealots had made camp southeast of the village, and Executor Arren wanted them hit before they could strike first. {We} fell on the camp, and Arren called the dead crusaders Light-blinded fools.",
        "{We} struck the Scarlet Crusade's camp southeast of the village, zealots who hunted every undead they found. Arren said they had sent themselves to their own graves."},
    [6395] = {act = "laid Samuel Fipps in his wife's grave", giver = "Novice Elreth",
        "Novice Elreth told {us} of Marla Fipps, killed by her own husband once the plague had made him Scourge, and of her last wish. {We} found Samuel at a ruined camp northeast of the village, destroyed him, and laid his remains in her grave.",
        "{We} granted Marla Fipps her last wish. Her husband Samuel, who had killed her as one of the Scourge, still roamed a ruined camp beyond the village, and {we} laid what was left of him in her grave, where Elreth hoped the two would find peace."},
    [382] = {act = "took the papers of a Scarlet messenger", giver = "Executor Arren",
        "A Scarlet messenger was carrying word from the monastery, and {we} took his papers for Executor Arren. Among them Arren found the positions of the Crusade's commanders and agents.",
        "{We} took the documents a Scarlet courier carried and brought them to Executor Arren, who found a useful map among the orders."},
    [365] = {act = "stole pumpkins from a farm under a Scarlet tower", giver = "Deathguard Simmer",
        "Deathguard Simmer sent {us} to rob a human farm under the eye of a Scarlet tower. {We} came away with ten pumpkins, and Apothecary Johaan in Brill took them for his reagents and called {us} an asset to the Dark Lady.",
        "{We} stole ten pumpkins from a farm the Scarlet Crusade watched over and carried them to Apothecary Johaan in Brill, who needed them for his work."},
    [383] = {act = "carried the Scarlet papers to Executor Zygand in Brill",
        "{We} carried the captured Scarlet papers to Executor Zygand in Brill. He read out the names of the Crusade's officers in Tirisfal and spoke of what one swift strike against them all would do to the zealots.",
        "In Brill, {we} handed Executor Zygand the papers taken from the Scarlet courier. With the names of every Scarlet officer in Tirisfal, he said, the zealots could be shaken in a single blow."},
    [427] = {act = "fought the Scarlet warriors at the tower past the Solliden Farmstead", giver = "Executor Zygand",
        "With the Crusade's positions known at last, Executor Zygand sent {us} west past the Solliden Farmstead to its tower. {We} cut down the Scarlet warriors there, and Zygand called {our} skill in combat undeniable.",
        "{We} went west to the Scarlet tower beyond the Solliden Farmstead and killed the warriors who held it, as Executor Zygand had asked."},
    [5481] = {act = "picked gloom weed for Gordo",
        "On the road out of Brill an abomination named Gordo asked {us} to pick weeds for his master, his own hands being too big for it. {We} brought the gloom weed to Junior Apothecary Holland, who had wanted doom weed instead.",
        "{We} picked gloom weed for Gordo, an abomination with hands too big for picking, and carried it to Junior Apothecary Holland by the Brill graveyard. It was the wrong weed."},
    [86784] = {act = "carried firewood to Eleanor Shackleton's camp",
        "{We} carried a basket of firewood from Deathguard Bartholomew to Eleanor Shackleton, camped in the hills to the west. She welcomed it for the cold nights of the Glades and let {us} keep the basket.",
        "Eleanor Shackleton lived off the wilds, and {we} brought her a basket of firewood at her camp in the western hills. She already had a sling for wood, so the basket stayed with {us}."},
    [96656] = {act = "looked into a stranger camped down the road by Brill",
        "A stranger had made camp down the road by Brill, and with Scarlet Crusaders about, {we} went to see what she was doing. She was Eleanor Shackleton, an adventurer with no ties to the Crusade, and she offered to teach {us} camping.",
        "{We} went down the road by Brill to look into a stranger's camp. Eleanor Shackleton was only an adventurer between ventures, and she offered {us} lessons in camping."},
    [407] = {act = "fed Johaan's pumpkin to the zealot in the tavern cellar", giver = "Apothecary Johaan",
        "Apothecary Johaan had laced a pumpkin with his latest formula, and {we} took it down to the Scarlet zealot locked in the tavern cellar. The starving man cursed {us}, then saw the pumpkin and ate it gladly.",
        "{We} carried Johaan's treated pumpkin down to the captive zealot under the Gallows' End Tavern. He was too hungry to ask what was in it."},
}
for id, pov in pairs(POV) do
    if pack.questIDs[id] then pack.questIDs[id].pov = pov end
end
A.Lore.RegisterStoryPack("horde-and-zephras", pack)
