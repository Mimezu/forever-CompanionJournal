local _, A = ...
-- Class identity supplies context, never evidence of a completed trial. Every
-- consequence below requires a recorded quest; shared titles stay stage-safe.
-- Source: local corpus_vanilla_quests.txt, quest/progress/completion sections.
-- It includes the server's human/skyborne hunter, Forsaken paladin, ursera and
-- incubus variants. No retail racial restrictions or later lore are inferred.
-- The exact-stage inventory is checked by tests/WorldBandDepth.lua; the pack
-- includes all nine classes, with early shaman trials in the regional packs.
-- Every stage has two setup and outcome choices; shared-title fallbacks are
-- independently audited across the corpus, including non-class title collisions.
local P = {sources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt; individual quest IDs cited on entries"}, quests = {}, questIDs = {}, threads = {
    class_warrior_training = "the warrior's training", class_warrior_wind = "the challenge of Cyclonian",
    class_paladin_divinity = "the paladin's acts of service", class_paladin_forsaken = "the service of Tyr's Watch",
    class_paladin_nobility = "the paladin's further instruction", class_hunter_taming = "the hunter's taming lessons",
    class_hunter_ogtinc = "Ogtinc's hunting trials", class_rogue_si7 = "SI:7's investigations",
    class_rogue_training = "the rogue's practical training", class_rogue_zanzil = "the remedy for Zanzil's poison",
    class_rogue_ravenholdt = "Ravenholdt's missing belongings", class_priest_service = "the priest's service to the wounded",
    class_priest_salve = "the salve for Felwood", class_mage_study = "the study of disturbed magic",
    class_mage_xylem = "Xylem's arcane research", class_warlock_binding = "the warlock's summoning trials",
    class_warlock_dreadsteed = "the ritual of Xoroth", class_druid_claw = "the lessons of the Claw",
    class_druid_water = "the trials of the sea lion", class_druid_poison = "the druid's work against poison",
    -- band5060 (2026-11-06)
    class_warlock_felsteed = "the warlock's felsteed", class_warlock_orahil = "the Orb of Orahil",
    class_mage_wand = "the mage's wand", class_mage_tabetha = "Tabetha's grudge in Zul'Farrak",
    class_druid_torwa = "Torwa's toxin for the crater",
}}
local function q(id, title, class, zone, level, thread, w1, w2, a1, a2, importance)
    P.questIDs[id] = {title = title, class = class, zone = zone, level = level,
        thread = thread, threadLabel = P.threads[thread], importance = importance or 4,
        why = {w1, w2}, after = {a1, a2}, covers = false,
        source = {"corpus_vanilla_quests.txt: quest " .. id}}
end
local W, PW, PF, PN = "class_warrior_training", "class_paladin_divinity", "class_paladin_forsaken", "class_paladin_nobility"
q(1505, "Veteran Uzzek", "WARRIOR", "The Barrens", 10, W,
    "Veteran Uzzek taught young warriors near the border between the Barrens and Durotar.", "The Horde valued experienced fighters who could pass their knowledge on.",
    "Uzzek greeted the young one and guessed at once that instruction was wanted.", "Hello, young one, said the veteran, and asked whether instruction was the reason for the visit.")
q(1498, "Path of Defense", "WARRIOR", "Durotar", 10, W,
    "Uzzek required singed scales from Thunder Ridge's lizards as proof of endurance.", "The defensive lesson began with surviving the assaults of lightning hides and thunder lizards.",
    "Uzzek took the singed scales as proof that the thunder lizards had been withstood, and began to show how tough skin and shrewd movement made a wall of defense.", "Surviving the thunder lizards proved the warrior tough, Uzzek said, and the lesson in defense began.")
q(1638, "A Warrior's Training", "WARRIOR", "Stormwind City", 10, W,
    "Harry Burlguard offered a veteran's instruction at the Pig and Whistle.", "Old Town's tavern held a teacher whose experience could keep a young warrior alive.",
    "Harry offered a drink first. The newcomer looked tough on the outside, he said, but he wanted to see whether that gut could handle a few mugs of the Pig and Whistle's strongest.", "At the Pig and Whistle, Harry offered a few mugs of the tavern's strongest before any talk of a lesson.")
q(1640, "Beat Bartleby", "WARRIOR", "Stormwind City", 10, W,
    "Bartleby refused to part with his mug without a fight.", "A tavern brawl stood between the pupil and Bartleby's drinking mug.",
    "Bartleby conceded the fight and acknowledged the strength brought against him.", "Bartleby lost the brawl and allowed that the newcomer was a lot tougher than they looked.")
q(1665, "Bartleby's Mug", "WARRIOR", "Stormwind City", 10, W,
    "Harry wanted Bartleby's mug as proof that the tavern challenge was finished.", "Bartleby had finally agreed to surrender his mug, after finishing its contents.",
    "Harry had Bartleby's mug. Its owner had not wanted to part with it, he said, but the persuasion had worked.", "Bartleby's mug went to Harry, and the tavern test gave way to the lesson.")
q(1719, "The Affray", "WARRIOR", "The Barrens", 30, W,
    "Fray Island tested warriors against successive challengers before Big Will entered the fight.", "Klannoc required the Affray to be won within the allotted time before he would teach.",
    "The challengers and Big Will were defeated, and Klannoc agreed to teach.", "Well done, said Klannoc. The Affray was passed, and he was honored to teach so worthy a warrior.", 5)
q(1712, "Cyclonian", "WARRIOR", "Alterac Mountains", 40, "class_warrior_wind",
    "Bath'rah needed materials before he could call the wind lord Cyclonian.", "The Windwatcher offered to put a whirlwind heart's power into a weapon, if the summoning and battle succeeded.",
    "The ritual materials were gathered; Cyclonian still had to be faced.", "Bath'rah had the components for his spell, not yet the wind lord's heart.")
q(1713, "The Summoning", "WARRIOR", "Alterac Mountains", 40, "class_warrior_wind",
    "Bath'rah was ready to summon Cyclonian and needed the wind lord's heart.", "The ritual would call forth a dangerous opponent whose power could be worked into a weapon.",
    "Cyclonian fell, and the Whirlwind Heart was recovered.", "Bath'rah had the Whirlwind Heart for his promised weapon, and Cyclonian was no more.", 5)
q(8425, "Voodoo Feathers", "WARRIOR", "Blasted Lands", 52, W,
    "The warrior's honor had brought the Fallen Hero some peace, and he meant to offer something in return. His weapons and armor had been splendid in life and were no use to him now. Magic feathers carried by the troll guardians of the sunken temple could reform his physical body long enough to grant them. The trolls were Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro.", "The Fallen Hero's splendid arms of life could pass to a warrior. First the voodoo feathers of six named trolls in the sunken temple had to give him a body for a moment.",
    "At last the Hero could feel the cold touch of steel again, if only for a moment.", "For a moment the feathers gave the Fallen Hero back the feel of steel, and he kept his promise.", 5)

q(1642, "The Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "The Tome of Divinity placed compassion and patience beside strength in battle.", "Paladin instruction treated helping those in need as a practical duty.",
    "Back at the cathedral, Duthorian asked how the study of the tome was going. A test of patience in helping the less fortunate would follow, he said.", "Duthorian had set out the principle, that a paladin strove to be good in all actions, and asked how the studies went.")
q(1643, "The Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "The test called for finding someone with a worthy need in Stormwind.", "Stephanie struggled to obtain cloth for children at the orphanage.",
    "Stephanie Turner greeted the paladin as luv. Leather and cloth were scarce these days, she said, and the orphanage children still needed clothes.", "The search for someone of noble intent ended with Stephanie Turner, who was glad to hear the paladin was doing well.")
q(1644, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "Stephanie needed linen to sew clothing for orphaned children.", "Food and shelter had consumed the time and means available for the children's clothes.",
    "The linen supplied Stephanie's sewing and freed time for the children's other needs.", "Stephanie thanked the paladin twice over for the linen she needed for the orphans' clothes.")
q(1781, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "The Symbol of Life was entrusted for a new task involving the wounded Gazin.", "Gazin rested by the cathedral altar after a disastrous encounter at Heroes' Vigil.",
    "Gazin explained what had happened to Henze; the Symbol had not yet been used.", "Gazin, coughing by the cathedral altar, was the man to ask about Henze.")
q(1786, "The Tome of Divinity", "PALADIN", "Elwynn Forest", 13, PW,
    "Henze had fallen holding off Defias spellcasters while Gazin escaped Heroes' Vigil.", "The Symbol of Life offered a chance to help the paladin left on Stone Cairn Lake's island.",
    "Henze was brought back through the Symbol of Life.", "Henze lived again, and thanked the paladin as a brother.", 5)
q(1787, "The Tome of Divinity", "PALADIN", "Elwynn Forest", 13, PW,
    "Henze was too weak to recover the Defias papers from the island himself.", "The documents could establish the Defias presence and reveal something of their plans.",
    "Gazin had the Defias papers and the news that Henze was saved. The Light was with the paladin for sure, he said.", "The evidence came back from Heroes' Vigil, ready for examination by the kingdom's advisers.")
q(1788, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "Duthorian awaited the report after the Symbol of Life had brought Henze back.", "The trial's final return concerned a power beyond the borrowed Symbol.",
    "Duthorian taught the power to resurrect fallen companions.", "The day's work had been done well, Duthorian said, and the power of resurrection was its reward.", 6)
q(94427, "A Lesson in Divinity", "PALADIN", "Undercity", 12, PF,
    "Tyr's Watch urged service to fellow Forsaken, beginning with Tanis Alderwood in the Trade Quarter.", "Tanis's need offered a practical test of charity amid distrust of the paladins.",
    "Tanis was found, frightened by the approach of a paladin.", "Tanis Alderwood, a beggar in the Trade Quarter, pleaded with the paladin to leave him be.")
q(94434, "A Lesson in Divinity", "PALADIN", "Undercity", 12, PF,
    "Tanis needed fresh cloth to hold his wife together until an apothecary could tend to her.", "The apothecaries' other duties had left one Forsaken household waiting for help.",
    "Very kind, Tanis said of the cloth, very kind indeed.", "The fresh cloth let Tanis wrap his wife while they waited for the apothecaries.")
q(94435, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Tanis wanted his thanks carried back to the paladin who had sent help.", "The order sought to answer Forsaken suspicion through practical service.",
    "The paladins' mentor praised the small act of service and handed over a symbol needed for the next task.", "A small thing, the mentor said, but even small acts of service strengthened the connection to the Light, and a Symbol of Life came with the next task.")
q(94436, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Deathguard Billmuth had petitioned the paladins for aid after the priests waved him away.", "The Symbol of Life was to be carried to a deathguard seeking aid for a friend.",
    "Billmuth admitted he was not proud of asking paladins for aid, but the priests had turned him away.", "The priests had waved Billmuth away, he admitted, and a paladin might be his friend's only chance.")
q(94438, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Falgan had told Billmuth to run when the Scarlets discovered the two deathguards near their camp in Venomweb Vale.", "Billmuth feared for Falgan, who he thought had stayed behind so he could flee a Scarlet camp.",
    "The Symbol of Life restored Falgan, who confirmed plans for a Scarlet attack.", "Falgan was back on his feet and said there might yet be more work to do for the Forsaken.", 5)
q(94440, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Scarlet deployment orders could give the Deathguard warning of the planned attack.", "Falgan asked for orders carried in the Crusaders' satchels to be taken to Billmuth.",
    "Billmuth thanked the paladin for his friend's life and took the plans to his commander, promising the crusaders a welcome they would not forget.", "Billmuth took the Crusaders' orders and promised to make sure others heard what a Forsaken paladin had done.")
q(94441, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Billmuth sent thanks to Danitha Morr for the service rendered by Tyr's Watch.", "Billmuth promised the Deathguard would hear of the service the paladins of Tyr's Watch had done.",
    "Danitha bestowed redemption, teaching the resurrection of fallen companions.", "Proud to count the paladin among Tyr's Watch, Danitha bestowed the gift of redemption, the power to raise fallen companions.", 6)
q(4485, "The Tome of Nobility", "PALADIN", "Stormwind City", 40, PN,
    "Further lessons awaited with Duthorian Rall at the Cathedral of Light.", "The summons directed an experienced paladin back to Stormwind's cathedral.",
    "A lot had happened lately, Duthorian said, and he would seek the paladin's aid if they proved worthy.", "Duthorian welcomed the paladin back to the cathedral. Treacherous enemies were about, he said, and he would ask for help once worth was proven.")

-- Hunting lessons differ by creature and by stage. A rod trial never proves
-- that a permanent pet was chosen, named, or present on another adventure.
local HT = "class_hunter_taming"
local function tame(id, zone, beast, place, final)
    q(id, "Taming the Beast", "HUNTER", zone, 10, HT,
        "The taming rod was meant for " .. beast .. " " .. place .. ".",
        "The lesson used " .. beast .. " to practice handling an animal companion.",
        final and "The final rod trial was complete, and the trainer taught taming, calling and dismissing a chosen pet." or "The rod trial with " .. beast .. " was complete; further instruction still lay ahead.",
        final and "The successful trial earned the skills needed to choose a permanent animal companion." or "The trainer accepted the practice with " .. beast .. " as another step in the lessons.", final and 5 or 4)
end
tame(6061, "Mulgore", "an adult plainstrider", "on Mulgore's plains")
tame(6062, "Durotar", "a dire mottled boar", "near Razor Hill")
tame(6063, "Teldrassil", "a webwood lurker", "in Teldrassil")
tame(6064, "Dun Morogh", "a large crag boar", "in Dun Morogh")
tame(6083, "Durotar", "a surf crawler", "off the coast near the Echo Isles")
tame(6084, "Dun Morogh", "a snow leopard", "in Dun Morogh's snowfields")
tame(6087, "Mulgore", "a prairie stalker", "on Mulgore's plains")
tame(6101, "Teldrassil", "a nightsaber stalker", "in Teldrassil")
tame(6082, "Durotar", "an armored scorpid", "in Durotar", true)
tame(6085, "Dun Morogh", "an ice claw bear", "east of Kharanos", true)
tame(6088, "Mulgore", "a swoop", "above Mulgore's plains", true)
tame(6102, "Teldrassil", "a strigid screecher", "in Teldrassil", true)
tame(94792, "Elwynn Forest", "a Rockhide Boar", "in the forest")
tame(94863, "Elwynn Forest", "a Gray Forest Wolf", "in Elwynn")
-- Forever's last human trial praises the bear tame but does not explicitly
-- teach spells in its completion text. Do not import another race's reward.
tame(94864, "Elwynn Forest", "a Young Forest Bear", "in Elwynn")
tame(94978, "Zephras Isle", "a Windsong Crawler", "beside Zephras's rivers and lakes")
tame(94979, "Zephras Isle", "a Galestrider", "in the lowlands")
q(94007, "Taming the Beast", "HUNTER", "Zephras Isle", 10, HT,
    "Quel'ana Quickgale taught beast taming at the port of Valanaar.", "The next hunting lesson required finding the trainer in Valanaar.",
    "Quel'ana was most glad the hunter had come, and the lessons began.", "At the port of Valanaar, the time had come for a hunter's very own animal companion, and Quel'ana Quickgale began the instruction in beast taming.")
q(94013, "Taming the Beast", "HUNTER", "Zephras Isle", 10, HT,
    "The final Zephras trial called for a Vuldren Alpha in the Gustberry Lowlands.", "After two beasts, the trainer set a last practical test with a Vuldren Alpha.",
    "A fast learner, Quel'ana said. With the basics known, the lasting bond with an animal companion could be taught.", "The last trial done, Quel'ana moved on to the lasting bond with a companion.", 5)
local function train(id, zone, teacher)
    q(id, "Training the Beast", "HUNTER", zone, 10, HT,
        teacher .. " offered the skills needed to care for and train a tamed animal.",
        "Taming alone did not provide the knowledge of pet care taught by " .. teacher .. ".",
        teacher .. " taught feeding, training and reviving a pet.",
        "The lesson covered a companion's upkeep and recovery as well as its abilities.", 5)
end
train(6081, "Orgrimmar", "Ormak Grimshot")
train(6086, "Ironforge", "Belia Thundergranite")
train(6089, "Thunder Bluff", "Holt Thunderhorn")
train(6103, "Darnassus", "Jocaste")
train(94050, "Zephras Isle", "Quel'dora")
train(94793, "Elwynn Forest", "Isaac Chan")
q(8151, "The Hunter's Charm", "HUNTER", "Azshara", 52, "class_hunter_ogtinc",
    "Ogtinc of Azshara had sent out a call for seasoned hunters. He was a furbolg hunter who had left his tribe to aid the Cenarion Circle. His teachings were meant to enrich the wisdom of others of his craft and guide them toward balance. He lived atop the cliffs northeast of the Ruins of Eldarath.", "A furbolg named Ogtinc, hunter turned teacher for the Cenarion Circle, waited on the cliffs of Azshara for seasoned hunters.",
    "It was no longer his purpose to hunt but to teach, Ogtinc said, for that was what fate had handed him. He proposed crafting a hunter's charm together, trophies from fallen prey to recall past trials and triumphs. In the end the charm would stay with him, and the hunter would get another reward.", "Ogtinc explained the hunter's charm, trophies of fallen prey, which he would keep, with another reward for the hunter.")
q(8232, "The Green Drake", "HUNTER", "Azshara", 52, "class_hunter_ogtinc",
    "Ogtinc set a dangerous hunt. The green drake Morphaz lived deep in the Temple of Atal'Hakkar, whose entrance lay in the Swamp of Sorrows. He was an enemy of many, and no one should go alone. His tooth stood for the power a hunter found in the company of others.", "Morphaz's tooth was the next trophy, Ogtinc said, and it stood for what a hunter could do in company. He lived deep in the Temple of Atal'Hakkar.",
    "The old ways had been learned, Ogtinc said, and he gave a gift from his days as a hunter.", "With Morphaz's tooth before him, Ogtinc called the old ways learned and gave a gift from his hunting days.", 5)

local RS, RT, RZ = "class_rogue_si7", "class_rogue_training", "class_rogue_zanzil"
q(2205, "Seek out SI: 7", "ROGUE", "Stormwind City", 10, RS,
    "A package for Mathias Shaw served as an introduction to SI:7.", "The intelligence service had work for a recruit who could find its contact in Stormwind.",
    "Mathias took the package and remarked that the run and the search looked to have been a strain.", "Keryn's package found Mathias Shaw, who looked the new arrival over and judged the run had taken its toll.")
q(2206, "Snatch and Grab", "ROGUE", "Elwynn Forest", 10, RS,
    "Defias smugglers used Jerod's Landing to move contraband between Redridge and Westfall.", "SI:7 wanted the dockmaster's shipping schedule from the dock house.",
    "Mathias was astonished that Keryn had finally found a recruit with the makings of a proper rogue. He gave a blade and said SI:7 would call again one day.", "The recovered shipping information gave the service evidence of the Defias route.")
q(2282, "Alther's Mill", "ROGUE", "Redridge Mountains", 20, RT,
    "Lucius kept a training chest at Alther's Mill with a token inside.", "The test required opening a lock at a mill where orcs had recently been seen.",
    "Lucius saw the token, knew the chest was cracked open, and called it nice work.", "The token from Alther's Mill told Lucius the lock had given way, orcs or no orcs.")
q(2360, "Mathias and the Defias", "ROGUE", "Westfall", 20, RS,
    "Agent Kearnen watched the Defias supply operation at an abandoned watchtower.", "Mathias needed another agent to make contact near the tower southeast of Sentinel Hill.",
    "Kearnen guessed Mathias had finally sent backup, and hoped the newcomer was ready for bad news.", "Outside the tower, Agent Kearnen had bad news waiting for whoever Mathias sent.")
q(2359, "Klaven's Tower", "ROGUE", "Westfall", 24, RS,
    "A strange shipment from Duskwood had arrived with inhuman guards at the Defias tower.", "Kearnen needed the key and the contents of the chest under the abominations' guard.",
    "The recovered book linked the Defias drones to Zanzil's poisonous means of raising the dead.", "To Mathias the book explained the Defias drones outside the tower, the Venture Company's hand in it, and the strange shipments out of Duskwood.", 5)
q(2607, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "The investigation had brought back a poisonous affliction along with its information.", "Mathias referred the search for a cure to Doc Mixilpixil in the cellar.",
    "Doc Mixilpixil took the visitor for the cheese delivery and said to put it on the table.", "In the cellar, the doctor's first words were about the cheese and where to put it.")
q(2608, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "Doc Mixilpixil required a blood sample before treating the affliction.", "The cellar examination began with the doctor's plan to draw blood.",
    "The phlebotomy done, Doc Mixilpixil called Dr. Montgomery and Mr. Noarm into conference.", "Blood drawn, the doctor asked for a moment to confer with his colleagues.")
q(2609, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "The doctor's formula required wildflowers, a vial, a bronze tube and chartreuse thread.", "The unusual remedy depended on supplies from Stormwind's tradespeople.",
    "With the reagents in hand, Doc Mixilpixil prepared the remedy for the itis.", "The doctor took the reagents and told his patient not to get indignant while he devised the cure.")
q(8236, "The Azure Key", "ROGUE", "Alterac Mountains", 52, "class_rogue_ravenholdt",
    "Deciphering the fragments and removing the enchantment would take time, Xylem said, and he would deliver the bag to Lord Ravenholdt himself. There was still the matter of the key. A green drake named Morphaz was said to hold it, deep in the Temple of Atal'Hakkar in the Swamp of Sorrows. Friends were to be gathered for it, and Lord Ravenholdt would await the key.", "The bag's key lay with the green drake Morphaz in the Temple of Atal'Hakkar, and Lord Ravenholdt wanted it back.",
    "Ravenholdt had thought the key lost forever. His thanks was an enchanted garment from his stores, reserved for rogues of exceptional skill and loyalty. It should be known, he said, that its bearer was not to be trifled with.", "Ravenholdt had his key back and gave an enchanted garment reserved for rogues of exceptional skill, declaring its wearer not to be trifled with.", 5)

local PS, PC = "class_priest_service", "class_priest_salve"
q(5622, "In Favor of Elune", "PRIEST", "Teldrassil", 4, PS,
    "Laurna Morninglight in Dolanaar was ready to continue a young priest's instruction.", "From Shadowglen, Shanda sent the young priest on to Laurna, with whom the order's first garments were to be earned.",
    "Laurna was happy Shanda had sent the young priest to her. Teaching the ways of Elune gave her great satisfaction, she said.", "In Dolanaar, Laurna said teaching young priests the ways of Elune was a satisfaction to her.")
q(5621, "Garments of the Moon", "PRIEST", "Teldrassil", 4, PS,
    "Sentinel Shaya had been hurt patrolling south of Dolanaar.", "Laurna could not leave her students and asked for healing and fortification for the injured Sentinel.",
    "Shaya was healed and fortified, and the service earned a robe from Laurna.", "Shaya was mended south of Dolanaar, and Laurna said Elune had been served.")
q(5624, "Garments of the Light", "PRIEST", "Elwynn Forest", 4, PS,
    "Guard Roberts lay injured near the lake east of Goldshire.", "Josetta made helping the wounded guard the test for a priest's first robes.",
    "Roberts was healed and fortified, restoring a defender to the town.", "One more healthy guard made Goldshire safer, Josetta said, and she gave the robe of the order.")
q(5625, "Garments of the Light", "PRIEST", "Dun Morogh", 4, PS,
    "Mountaineer Dolf was injured just south of Kharanos.", "Maxan placed the mountaineer's immediate need ahead of a formal test.",
    "Dolf was healed and fortified, and Maxan said the Light was inside the priest for sure.", "A wounded mountaineer was helped, fulfilling the test for the church's garments.")
q(5650, "Garments of Darkness", "PRIEST", "Tirisfal Glades", 4, PS,
    "Deathguard Kel needed healing after defending the settlement from gnolls.", "The lesson required fortifying the wounded deathguard as well as mending his injuries.",
    "Kel was healed and fortified, completing the test for a robe of the order.", "The deathguard was mended and fortified, and the trainer said the test had been passed with ease.")
q(94774, "Divine Grace", "PRIEST", "Stormwind City", 10, PS,
    "The priest's superiors asked for a journey to the Cathedral of Light, where High Priestess Laurena would guide further training.", "The summons called a developing priest back to Stormwind's cathedral.",
    "Laurena was glad of the arrival. There was much to discuss, she said, but training in the Light came first.", "Laurena said there were lessons all servants of the Light had to learn, and offered to begin.")
q(8254, "Cenarion Aid", "PRIEST", "Azshara", 52, PC,
    "It was the way of the divine to help those in need, the priest's trainer said. The how was insignificant, and only the why mattered. Now the Cenarion Circle had such a need. Atop the cliffs northeast of the Ruins of Eldarath in Azshara, Ogtinc would say where aid was wanted.", "The Cenarion Circle needed help, and a priest was sent to Ogtinc on the cliffs of Azshara to give it.",
    "A weight lifted from Ogtinc's shoulders at the arrival, he said. There was much to do.", "Ogtinc said a weight had lifted from his shoulders, and that much remained to do.")
q(8255, "Of Coursers We Know", "PRIEST", "Azshara", 52, PC,
    "The mosshoof coursers of Azshara were magnificent animals who had once lived in Felwood, Ogtinc said. They resisted disease and poison by nature and had been untouched by the corruption there. In their ancestral wisdom they had simply left that sickened place. It saddened his heart to ask, but four courser glands were the first ingredient of a restorative salve to heal Felwood.", "The mosshoof coursers had walked out of Felwood unharmed by its corruption. Four of their glands were the first ingredient of Ogtinc's salve for the forest.",
    "Ogtinc was glad that the divine path had led the priest to them, for the priest's beliefs did not interfere with making the salve. The courser was sacred to the Cenarion Circle, and killing them for any reason, however necessary, weakened their spirit.", "Ogtinc took the glands with a word on the cost. The coursers were sacred to the Circle, and killing them weakened their spirit.")
q(8256, "The Ichor of Undeath", "PRIEST", "Azshara", 52, PC,
    "The restorative salve followed a simple formula, one part poison to two parts cure. One cure was in hand, and the poison would be the ichor of undeath. Evil sometimes coalesced into that sickly greenish goo in powerful undead, such as the lingering highborne of the Ruins of Eldarath. It was so potent that a single ichor would do.", "One ichor of undeath from the highborne dead of Eldarath was the poison in Ogtinc's formula of one part poison, two parts cure.",
    "Ogtinc could not say he was pleased to receive such a wretched substance, but it was a necessary evil, and he gave thanks.", "The ichor went to Ogtinc, who called it a necessary evil and did not pretend to like it.")
q(8257, "Blood of Morphaz", "PRIEST", "Felwood", 52, PC,
    "The last part was the second cure. Morphaz, the green drake, was known to be immune to every poison and disease. Many druids had died to bring that knowledge, and his blood would be potent for the salve. A courier from the Cenarion Circle would take the parts already gathered. Meanwhile the drake's lair in the sunken temple of Atal'Hakkar was to be sought with allies, and the blood taken to Greta Mosshoof in Felwood.", "Morphaz's blood, from the drake immune to all poison and disease, was the second cure, and Greta Mosshoof in Felwood waited for it.",
    "Greta could hardly believe the good news that Morphaz was slain and his blood carried to them. The ingredients would be combined at once and the healing of Felwood's trees and creatures begun. It would take a lifetime to undo what had happened, but now there was a means.", "With Morphaz's blood in Greta's hands, the salve could be made, and the lifetime's work of healing Felwood had its means.", 5)

local MS = "class_mage_study"
q(1860, "Speak with Jennea", "MAGE", "Stormwind City", 10, MS,
    "Jennea Cannon needed help with a matter affecting Stormwind and Elwynn.", "The task's details awaited in the Wizard's Sanctum.",
    "Jennea found it heartening to see a young mage eager to help the cause.", "In the Wizard's Sanctum, Jennea welcomed an eager young mage to her task.")
q(1861, "Mirror Lake", "MAGE", "Elwynn Forest", 10, MS,
    "Disturbed magical currents raised fears about the water below Mirror Lake's waterfall.", "Jennea needed a water sample before she could test for magical contamination.",
    "Jennea took the water from below the falls to test. She hoped it held nothing, for the sake of anyone who drank from Mirror Lake.", "Jennea had her sample of Mirror Lake, and the young mage a choice of an orb or a staff.")
q(1880, "Mage-tastic Gizmonitor", "MAGE", "Dun Morogh", 10, MS,
    "A knowledge-storing gizmonitor had been left behind during the flight from Gnomeregan.", "The device lay in a chest outside the lost city, among leper gnomes.",
    "Splendid day, said Bink, who had never guessed how dependent on the gizmonitor she would become. Her studies could begin anew.", "The gizmonitor came back before its energy ran out, and Bink's studies could begin anew.")
q(1882, "The Balnir Farmstead", "MAGE", "Tirisfal Glades", 10, MS,
    "Forsaken mages wanted to measure the plague's spread through magically receptive snapdragons.", "Flowers at Balnir Farmstead could supply evidence of the taint reaching eastern Tirisfal.",
    "The snapdragons were collected for the apothecaries to study.", "The mage called the snapdragon a fine specimen and sent it on to the apothecaries, who would measure how far the taint had spread.")
q(1884, "Ju-Ju Heaps", "MAGE", "Durotar", 10, MS,
    "Zalazane's fetishes disrupted magical currents around the Echo Isles.", "The tainted heaps strengthened hostile magic and corrupted the wildlife.",
    "The ju-ju heaps were destroyed, giving Durotar's magical currents a chance to recover.", "The trainer sensed the ju-ju heaps were gone. With time and luck, the flow of magic in Durotar would return to normal.")
q(1952, "Mage's Wand", "MAGE", "Dustwallow Marsh", 40, MS,
    "The preparations had reached the point where the promised wands could be made.", "A choice of crafted wands awaited at the end of the work.",
    "The finished wands were offered for a choice of reward.", "The crafting was complete, and one of the prepared wands could be taken.")
q(8253, "Destroy Morphaz", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Deep in the sunken temple of Atal'Hakkar lived a green drake named Morphaz, Xylem said. Years ago he had overwhelmed Xylem in a bold ambush and consumed his apprentice whole. The loss of an apprentice was nothing new, but this one had carried an arcane shard of unsurpassed size and quality. Xylem wanted powerful allies gathered and the shard recovered from the drake's ageless stomach.", "Xylem's lost apprentice, and an arcane shard of unsurpassed quality, lay in the stomach of the green drake Morphaz in the sunken temple.",
    "Incredible, Xylem said, for the shard had grown as it absorbed the drake's energy over the long years. There was no more he could ask. His full ability to forge the arcane had returned, and his first creation was the mage's to choose.", "Grown with the drake's energy, the shard restored Xylem's craft, and he offered his first creation.", 5)
q(7463, "Arcane Refreshment", "MAGE", "Dire Maul", 60, MS,
    "Lydros found a mage of that race wondrous, for he had not seen one in five hundred years, or whatever it was now. He had something to quench a thirst, but first came a task, and he snickered. A water elemental had taken residence in the east wing of Eldre'Thalas, an anomaly whose presence had to be catalogued. Its essence, taken from the Hydrospawn in the Warpwood Quarter, would earn a useful cantrip.", "Lydros wanted the Hydrospawn in the Warpwood Quarter catalogued through a sample of its essence, and promised a cantrip for it.",
    "Wonderful, Lydros said, and then he could not remember who had come. It mattered not. He could not recall what he was to give either, but a mage might find this useful.", "Having forgotten who had brought the essence and what he owed for it, Lydros found something a mage might use.", 5)

local WB = "class_warlock_binding"
q(1470, "Piercing the Veil", "WARLOCK", "Tirisfal Glades", 3, WB,
    "Three rattlecage skulls were required before instruction in binding a servant.", "The skeletons near the abandoned smithy supplied the trainer's test of practical ability.",
    "Untested as the pupil still was, the trainer judged the ability enough to summon and bind an imp. Small as an imp was, the trainer warned, it had powers and a cleverness that would serve well.", "The skulls proved ability enough, young as the warlock was, and the lesson in binding an imp followed.")
q(1598, "The Stolen Tome", "WARLOCK", "Elwynn Forest", 4, WB,
    "A novice who joined the Defias had stolen Powers of the Void from the abbey.", "The trainer wanted a protected library text now hidden in a vineyard tent.",
    "With the tome back, the trainer saw no reason not to show how to summon an imp.", "Powers of the Void came back from the vineyard. The trainer admitted she had never reached it herself; loitering in the abbey's protected wing would have looked suspicious.")
q(1478, "Halgar's Summons", "WARLOCK", "Undercity", 10, WB,
    "Carendin Halgar requested further training near the Temple of the Damned.", "The next warlock lesson awaited in the Undercity's Magic Quarter.",
    "Halgar was glad Ageron had found his pupil, and wasted no time on pleasantries. There was still much to learn, he said.", "In the Magic Quarter, Halgar skipped the small talk and went straight to the lesson.")
q(1506, "Gan'rul's Summons", "WARLOCK", "Orgrimmar", 10, WB,
    "Gan'rul wanted an immediate visit among the senior warlocks in the Cleft of Shadow.", "A summons interrupted other business for further warlock instruction.",
    "Gan'rul had feared his messenger Ophek would never find his pupil, and was glad to be wrong.", "Ophek's summons brought the warlock to Gan'rul in the Cleft of Shadow, where the next lesson waited.")
q(1685, "Gakin's Summons", "WARLOCK", "Stormwind City", 10, WB,
    "Master Gakin taught discreetly beneath the Slaughtered Lamb.", "The summons directed a pupil to the tavern's basement for further training.",
    "About time, said Gakin, and wondered aloud whether he should have sent someone more capable than Remen.", "Beneath the Slaughtered Lamb, Gakin blamed the delay on Remen, the messenger he had sent.")
q(1473, "Creature of the Void", "WARLOCK", "Tirisfal Glades", 10, WB,
    "A Scarlet agent had stolen Egalin's grimoire describing the first voidwalker summoning.", "The missing book lay at a tower west of the warlocks' contact.",
    "The grimoire was recovered for study; the voidwalker still had to be subdued.", "Egalin's musty book came back. Perrine, who stole it, had likely never known its true power, the trainer said.")
q(1501, "Creature of the Void", "WARLOCK", "Durotar", 11, WB,
    "Burning Blade warlocks kept the stolen Tablet of Verga in Skull Rock.", "The tablet's glyphs were needed before a voidwalker could be summoned for the trial.",
    "The Tablet of Verga came back from the Burning Blade, and the trainer hoped the cult had suffered other losses in the taking.", "The Burning Blade lost the Tablet of Verga, and the Horde's few warlocks had their summoning text back.")
q(1688, "Surena Caledon", "WARLOCK", "Elwynn Forest", 10, WB,
    "Gakin wanted the bloodstone choker he had given his former student Surena.", "Surena had left with a Defias companion and could be found at Brackwell Pumpkin Patch.",
    "Surena had talent, Gakin said, but not enough to master warlock magic on her own. A shame to waste it, but sometimes necessary.", "Surena was bested and her bloodstone choker returned. Gakin called the waste of her talent a shame, if a necessary one.")
local function binding(id, zone, level, demon, implement, lesson)
    q(id, "The Binding", "WARLOCK", zone, level, WB,
        "The summoning circle required " .. implement .. " to call forth " .. demon .. ".",
        "The trial demanded that " .. demon .. " be subdued before the trainer would offer further instruction.",
        lesson and "The summoned " .. demon:gsub("^an? ", "") .. " was overcome, and the trainer offered to teach the spell to call it forth." or "The felhunter was overcome, completing the summoning trial before Strahad.",
        lesson and "The successful binding led to the trainer's lesson in commanding " .. demon .. "." or "Strahad acknowledged the successful confrontation with the felhunter.", 5)
end
binding(1471, "Undercity", 10, "a voidwalker", "the prepared runes", true)
binding(1504, "Orgrimmar", 11, "a voidwalker", "the Tablet of Verga's glyphs", true)
binding(1689, "Stormwind City", 10, "a voidwalker", "the bloodstone choker", true)
binding(1474, "Undercity", 20, "a succubus", "the collected hearts", true)
binding(1739, "Stormwind City", 20, "a succubus", "a heartswood core", true)
binding(1795, "The Barrens", 30, "a felhunter", "the Tome of the Cabal and the acolytes' help", false)
binding(65597, "Undercity", 20, "an incubus", "the collected hearts", true)
binding(65603, "Stormwind City", 20, "an incubus", "the figurine placed at its center", true)
binding(65604, "Orgrimmar", 20, "an incubus", "the scarf carrying its owner's feelings", true)
q(1738, "Heartswood", "WARLOCK", "Ashenvale", 20, WB,
    "The heartswood at Ordil'Aran had grown where two lovers fell in the War of the Ancients.", "Its association with enduring love made the tree's core a lure for a succubus.",
    "The heartswood core would do nicely, Gakin said, and he asked for a moment to work with it.", "Gakin judged the heartswood core fit for the work and began on it at once.")
q(7631, "Dreadsteed of Xoroth", "WARLOCK", "Dire Maul", 60, "class_warlock_dreadsteed",
    "All the preparations were made. Now the ritual to create a Circle of Greater Summoning had to be performed. The parchment infused with Xorothian stardust would then open a portal to Xoroth. Its instructions were on a scroll, and each step had to be performed exactly. Mor'zul wished fortune, and that the souls of enemies would swiftly find their way into the shard pouch.", "The Circle of Greater Summoning and the stardust-infused parchment would open the portal to Xoroth, if every step of the scroll was followed exactly.",
    "Beaten at last, the Xorothian Dreadsteed's spirit still pulsed with rage through its ghostly flanks. Its soul was won, and it whispered dark magic into the warlock's mind and instilled the knowledge to summon a dreadsteed.", "Its soul won, the dreadsteed's spirit whispered dark magic into the warlock's mind, and with it the knowledge to summon its kind.", 6)

local DC, DW, DP = "class_druid_claw", "class_druid_water", "class_druid_poison"
q(6001, "Body and Heart", "DRUID", "Darkshore", 10, DC,
    "Cenarion Moondust would call Lunaclaw at the Moonkin Stone east of Auberdine.", "The Claw's trial required facing the defender of a moonkin cave's sacred stone.",
    "Mathrengyl sensed Lunaclaw's strength in the druid, and the teaching of the Great Bear Spirit with it. A large step into a much larger world, he called it.", "Mathrengyl sensed Lunaclaw's strength in the druid and called it a large step into a much larger world.", 5)
q(6002, "Body and Heart", "DRUID", "The Barrens", 10, DC,
    "Cenarion Lunardust would call Lunaclaw at the stone west of Taurajo.", "The stone near Mulgore's border held a test of the strength required by the Claw.",
    "Turak sensed the Great Bear Spirit's teaching and Lunaclaw's strength in the druid, and called it a large step into a much larger world.", "After the Moonkin Stone, Turak sensed Lunaclaw's strength in the young druid.", 5)
q(28, "Trial of the Lake", "DRUID", "Moonglade", 16, DW,
    "A rapidly fading bauble had to be carried from Lake Elune'ara to the Shrine of Remulos.", "The lake's trial tested speed and endurance before the bauble lost its power.",
    "The bauble was used at the Shrine of Remulos before it could decay, and Tajarri counted yet another druid through the Trial of the Lake.", "Tajarri greeted the newest druid to pass the Trial of the Lake with a well done, twice over.")
q(30, "Trial of the Sea Lion", "DRUID", "Moonglade", 16, DW,
    "The pendant's two halves represented the sea lion's agility and endurance.", "The trial required gathering both halves and joining them before Dendrite's inspection.",
    "Dendrite inspected the joined pendant, agility and endurance in one piece, and congratulated the druid on the Trial of the Sea Lion.", "Both halves made the Pendant of the Sea Lion, and Dendrite called the second trial complete.")
q(31, "Aquatic Form", "DRUID", "Thunder Bluff", 16, DW,
    "Turak Runetotem awaited the pendant as evidence of the lessons completed in Moonglade.", "The final return to Thunder Bluff would turn the trials' preparation into aquatic instruction.",
    "Turak found the pendant very impressive and said the druid's ancestors would be pleased. It was his pleasure, he said, to teach the aquatic form.", "In Thunder Bluff, Turak took the pendant as proof of Moonglade's lessons and taught the aquatic form.", 6)
q(5061, "Aquatic Form", "DRUID", "Darnassus", 16, DW,
    "Mathrengyl Bearwalker awaited the pendant as proof of the Moonglade trials.", "The final lesson in the aquatic aspect required returning to the trainer in Darnassus.",
    "Mathrengyl called the pendant very impressive and taught the aquatic form with pleasure.", "In Darnassus, Mathrengyl took the pendant as proof of Moonglade's lessons and taught the aquatic form.", 6)
q(6123, "Gathering the Cure", "DRUID", "Darkshore", 14, DP,
    "Earthroot and lunar fungus were needed for a salve to treat Darkshore's sick deer.", "The cure needed herbs and fungus from the moonkin caves, in addition to its water base.",
    "The water, earthroot and lunar fungus were enough for ample doses of salve, Alanndarian said, enough to start making a difference.", "Alanndarian judged the reagents good enough for ample doses of the salve.")
q(6124, "Curing the Sick", "DRUID", "Darkshore", 14, DP,
    "Ten doses of salve were ready for Darkshore's afflicted deer.", "The practical lesson called for administering a prepared remedy to the sick wildlife.",
    "The deer were treated, and Dendrite called them unwitting victims of a taint spreading through the whole land. Some in Darnassus saw it, he said, and some put on blinders.", "Dendrite praised the care given to Darkshore's deer and warned of the corruption spreading through the land.")
q(6125, "Power over Poison", "DRUID", "Darnassus", 14, DP,
    "The work with ordinary antidotes was preparation for Mathrengyl's lesson in curing poison.", "The final return concerned a lasting power beyond gathering ingredients for each remedy.",
    "Mathrengyl had followed the lesson from afar and was surprised by the situation in Auberdine. Such poisons in the land upset the balance, he said, and bore investigating.", "The lesson ended with the power to cure poison, and with Mathrengyl's worry about what had been loosed in Auberdine.", 5)
q(6128, "Gathering the Cure", "DRUID", "The Barrens", 14, DP,
    "Tonga needed earthroot and intact kodo horns for the gazelles' salve.", "The sampled water required curative ingredients before it could become a useful remedy.",
    "Tonga called the reagents good, enough for ample doses of the salve and a start on saving the gazelles.", "With water, earthroot and kodo horn in hand, Tonga could make enough salve to start making a difference.")
q(6129, "Curing the Sick", "DRUID", "The Barrens", 14, DP,
    "Ten doses of salve were available for the sick gazelles of the northern Barrens.", "The Circle's practical lesson required treating afflicted wildlife beyond the Crossroads.",
    "The gazelles were tended. Dendrite called them victims of a taint spreading through the land, and said the druid's people, like their elders in Thunder Bluff, were proving that the need for balance crossed racial barriers.", "The salve relieved sick animals while the greater source of corruption remained.")
q(6130, "Power over Poison", "DRUID", "Thunder Bluff", 14, DP,
    "Turak awaited the return from the practical work against the gazelles' poisoning.", "The antidote lesson was to end with permanent instruction at Thunder Bluff.",
    "Turak had followed the lesson from Thunder Bluff and was surprised by the situation at the Crossroads. Poison in the land upset the balance, he said, and bore investigating.", "The lesson ended with the power to cure poison, and with Turak's worry about what had been loosed near the Crossroads.", 5)
q(94006, "The Great Ursera Spirit", "DRUID", "Zephras Isle", 10, DC,
    "Urs'endris taught the ursera shape near the waterfall below the Shrine of Akir.", "The great spirit's domain was withering along with other parts of Zephras.",
    "So the child wished to embrace the way of the claw, said Urs'endris. Very well, then they would speak.", "Urs'endris, the spirit who had taught druids the ursera shape for generations, agreed to speak of the way of the claw.")
q(94911, "Child of Nature", "DRUID", "Thunder Bluff", 10, DC,
    "Turak Runetotem in Thunder Bluff could show a druid from Zephras the way to Moonglade.", "The stronghold of the Cenarion Circle lay at Moonglade, and Turak in Thunder Bluff could teach the way to reach it.",
    "Turak Runetotem wondered whether wonders would ever cease, with a high elf speaking to him in Thunder Bluff.", "Turak Runetotem marveled at a high elf speaking with him in Thunder Bluff.")
q(94912, "Child of Nature", "DRUID", "Stormwind City", 10, DC,
    "Sheldras Moontree in Stormwind could show a Skyborne druid the way to Moonglade.", "The Cenarion Circle, an ancient order of druids, kept its stronghold at Moonglade, and a night elf in Stormwind knew the way.",
    "Sheldras was pleased to meet a fellow druid from among the Skyborne, and to be among the first to welcome them to Azeroth.", "In Stormwind, Sheldras counted himself among the first to welcome a Skyborne druid to Azeroth.")

-- Additional staged source review: the level-52 temple requests begin with
-- errands in the open world; finding an instructor is not passing the trial.
P.threads.class_shaman_spirits = "Bath'rah's troubled spirits"
P.threads.class_paladin_mightstone = "the forging of a Holy Mightstone"
P.threads.class_warlock_impsy = "Impsy's own pet"
q(1740, "The Orb of Soran'ruk", "WARLOCK", "The Barrens", 25, WB,
    "Doan sought pieces of a demon-spirit orb from Blackfathom Deeps and Shadowfang Keep.", "Even broken, Soran'ruk's orb retained power that Doan believed he could restore.",
    "Almost every piece of Soran'ruk's orb was there, Doan said, and making it whole again was a simple thing.", "The orb had not been greatly fragmented, and Doan could make Soran'ruk whole again.")
q(8417, "A Troubled Spirit", "WARRIOR", "Blasted Lands", 52, W,
    "In the Blasted Lands was a troubled spirit who had once been a great hero of the Horde, the warrior's trainer said. A warrior's honor did not die with the body, and it would serve well to speak with him.", "A great hero of the Horde lingered in the Blasted Lands as a troubled spirit, and a warrior was sent to speak with him.",
    "So someone had come to alleviate his pain, the spirit said. He wished he could simply be struck down, but it was not that simple.", "The spirit wished it were as simple as being struck down. It was not, he said.")
q(8423, "Warrior Kinship", "WARRIOR", "Blasted Lands", 52, W,
    "The Hero looked the warrior over. He had an honorable task in mind, but strength had to be tested first. Rexxar, it was said, measured the sharpness of his blades by killing a helboar with a single swift strike. In the same way, the Hero would measure the warrior's strength by killing them.", "Before any honorable task, the Fallen Hero measured a warrior's strength on helboars, as Rexxar was said to have measured his blades.",
    "The Hero needed no proof to know what had been done; he could see the determination etched in the warrior's expression.", "No proof was needed, the Hero said, for the determination showed in the warrior's face.")
q(8424, "War on the Shadowsworn", "WARRIOR", "Blasted Lands", 52, W,
    "The continued presence of the Shadowsworn in the Blasted Lands brought the Hero great pain. Their dark rituals and spells caused agony unlike any he had felt while alive. Through the warrior he could deliver his own message of pain, and he sent forth his wrath.", "The Shadowsworn's rituals tormented the Fallen Hero even in death, and he asked a warrior to carry his wrath to them.",
    "Already the pain was subdued and the Hero honored, he said, and gave thanks.", "With the Shadowsworn thinned, the Hero's pain eased, and he thanked the warrior for the honor.")
local PM = "class_paladin_mightstone"
q(8415, "Chillwind Point", "PALADIN", "Western Plaguelands", 52, PM,
    "Commander Ashlam Valorfist had sent out a call for a paladin of purity and valor. He could be found at Chillwind Point in the south of the Western Plaguelands, and his cause for the Light needed aid.", "A paladin was called to Chillwind Point, where Commander Ashlam Valorfist fought for the Light.",
    "Very well, Valorfist said, and it was time to see what the paladin was made of.", "Valorfist received the paladin at Chillwind Point and promised a test.")
q(8414, "Dispelling Evil", "PALADIN", "Western Plaguelands", 52, PM,
    "Crusaders like the paladin were a welcome sight in those desolate reaches, Valorfist said. Holy strength was needed against the endless undead. A large number of scourgestones were to be collected and brought to High Priest Thel'danis, who guarded Uther's Tomb in Sorrow Hill. Only one with an Argent Dawn commission could hope to find them.", "Valorfist wanted scourgestones, found only under an Argent Dawn commission, carried to High Priest Thel'danis at Uther's Tomb in Sorrow Hill.",
    "There was risk in dispelling the evil from a scourgestone, Thel'danis said, for it drew the attention of undead for countless miles. But the paladin was strong in the Light, and he did not fear.", "Thel'danis took the scourgestones with a warning that cleansing them drew undead from miles around. He did not fear for one strong in the Light.")
q(8416, "Inert Scourgestones", "PALADIN", "Western Plaguelands", 52, PM,
    "The evil had been purged from the stones, Thel'danis said. He knew Commander Ashlam's plans, and a single inert stone was all the commander would need. With it the Scourge would be bathed in righteous fire.", "One cleansed scourgestone from Thel'danis was all Valorfist needed for his plan of righteous fire.",
    "The paladin had done as asked without question, Valorfist said. Trust was achieved, it seemed, and he could reveal the plan in more detail.", "The inert stone earned Valorfist's trust, and more of his plan.")
q(8418, "Forging the Mightstone", "PALADIN", "Western Plaguelands", 52, PM,
    "Now the inert scourgestones had to be combined into a weapon to shatter the ranks of the undead, and it was no trivial task, Valorfist said. Only the trolls of the sunken temple carried the rare magic able to turn the evil of a thing against itself. They were Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro, and their corrupt souls deserved no remorse.", "The magic to turn the scourgestones' evil against itself lay with six named trolls of the sunken temple, and Valorfist wanted it.",
    "Excellent, Valorfist said. He would say he was surprised, but he had known without question that the paladin would not let them down. It was his honor to bestow a Holy Mightstone, to be used well.", "Valorfist had never doubted, he said, and bestowed a Holy Mightstone.", 5)
q(8233, "A Simple Request", "ROGUE", "Alterac Mountains", 52, "class_rogue_ravenholdt",
    "Lord Jorach Ravenholdt had requested the rogue's presence on a secret matter, and nothing more could be said. Ravenholdt Manor lay in the Hillsbrad Foothills, up a path in the mountains northwest of Durnholde Keep.", "A summons to Ravenholdt Manor, northwest of Durnholde Keep, came with no explanation but secrecy.",
    "Welcome, welcome, welcome, Ravenholdt said, and offered a seat. He had recently lost something dear to him and wanted it back at all costs. There would be something very nice in it, he promised, and he asked whether the rogue was up for some adventure.", "With a warm welcome, Ravenholdt said he had lost something dear and wanted it back at any cost, with something very nice promised in return.")
q(8234, "Sealed Azure Bag", "ROGUE", "Azshara", 52, "class_rogue_ravenholdt",
    "First things first, Ravenholdt said. What he had lost was a small blue bag whose contents were a private matter. The thieves were already dead. Unable to open the bag, the fools had sold it to some Timbermaw shaman in Azshara as a holy relic. It was to be retrieved by subtlety or force, with better luck likely from the first, and taken to Archmage Xylem.", "Ravenholdt's small blue bag had been sold by its dead thieves to a Timbermaw shaman in Azshara as a relic. It was to be recovered and taken to Archmage Xylem.",
    "So that was Lord Ravenholdt's bag, Xylem said, and he wanted to know why no one had said so.", "Xylem recognized Lord Ravenholdt's bag and complained that no one had said so sooner.")
q(8235, "Encoded Fragments", "ROGUE", "Azshara", 52, "class_rogue_ravenholdt",
    "Lord Ravenholdt had asked a favor of them both, Xylem said. He wished the enchantment removed from the bag. Some of Xylem's writings on dispelling had been taken recently and destroyed by savages, and the remains were still valuable to him. Enough encoded fragments would let him piece them together. The forest oozes of northeast Azshara picked up just about anything and were the best chance.", "Xylem needed the encoded fragments of his destroyed writings on dispelling before he could work on the bag. They were best found in the forest oozes of northeast Azshara.",
    "These were some of the better fragments, Xylem allowed. Perhaps the rogue was not worthless after all.", "Looking over the fragments, Xylem found them among the better ones, and allowed that the rogue might not be worthless.")
q(8250, "Magecraft", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Archmage Xylem had been asking around for someone of the mage's experience. He could be found in Azshara, in a tower built high atop the cliffs. The only way up was a teleport invoked by his arrogant servant, Sanath Lim-yo. Sanath camped below the tower, due north from where Azshara's main road forked at the entrance to the Ruins of Eldarath.", "Xylem's tower on the cliffs of Azshara could be reached only through his servant Sanath Lim-yo's teleport, from the camp below.",
    "Archmage Xylem awaited, Sanath said with a sneer.", "With a sneer, Sanath said the Archmage was waiting.")
q(8251, "Magic Dust", "MAGE", "Azshara", 52, "class_mage_xylem",
    "The blood elves in Azshara had developed a method for pulverizing the magical items they acquired, Xylem said. Their glittering dust differed from the components of an ordinary disenchantment. When he sent his apprentice to trade for it, the apprentice was killed without hesitation, and for that they would pay. Now the time for talk was over, and more persuasive methods were to be used along the cliffs.", "Xylem's apprentice had died trying to trade for the blood elves' glittering dust, and Xylem wanted it taken from them instead, along the cliffs of Azshara.",
    "Well done, Xylem said, and it never ceased to amaze him how persuasive a volley of arcane missiles could be.", "With the glittering dust in hand, Xylem remarked on how persuasive arcane missiles could be.")
q(8252, "The Siren's Coral", "MAGE", "Azshara", 52, "class_mage_xylem",
    "The ruins and beaches around Xylem's tower were overrun with spitelash. They had recently learned to recognize the rare components of Azshara, and enchanted coral drew them for reasons unknown to him. Little was left in the bay. The coral was vital to his research, and the spitelash sirens were to be parted from some of it.", "The spitelash sirens had taken most of the bay's enchanted coral, and Xylem's research needed it back.",
    "It was a superb specimen of coral, Xylem said, and the mage's skills were unquestionably precise and deadly. The efforts had not gone unnoticed, and perhaps a true test of skill was deserved.", "Xylem praised the coral and the precision behind it, and hinted at a true test of skill.")
local SS = "class_shaman_spirits"
q(8410, "Elemental Mastery", "SHAMAN", "Alterac Mountains", 52, SS,
    "Bath'rah the Windwatcher had sent out a summons for a shaman of wisdom. His request was for a sample of each of the elements, to show readiness. He could be found by following the river east of Tarren Mill north to the ruins where he lived.", "A shaman was summoned to Bath'rah the Windwatcher, in the ruins up the river east of Tarren Mill, with a sample of each element.",
    "Excellent, mon, Bath'rah said, and now they were talking.", "Bath'rah took the samples and said now they were talking.")
q(8411, "Mastering the Elements", "SHAMAN", "Alterac Mountains", 52, SS,
    "Welcome, mon, Bath'rah said. The elements came first, and then they would do the talking.", "Bath'rah would talk once the elements were in his hands.",
    "These were the elements he needed, Bath'rah said. Now they would talk.", "With the elements before him, Bath'rah was ready to talk.")
q(8412, "Spirit Totem", "SHAMAN", "Western Plaguelands", 52, SS,
    "The elemental spirits of the place did not like Bath'rah any more, he said. A shaman knew totems better than anyone, and he needed a spirit totem to protect him. The elements were already in hand, and now something more primal was wanted. Bear claws and spider eyes would do, from the Western Plaguelands, where the carrion birds that ate everything might carry either.", "Bath'rah wanted a spirit totem against the spirits that had turned on him. He sent the shaman to the Western Plaguelands for bear claws and spider eyes.",
    "Great, mon, Bath'rah said, and it was time to try it out.", "Claws and eyes in hand, Bath'rah set about trying the totem.")
q(8413, "Da Voodoo", "SHAMAN", "The Temple of Atal'Hakkar", 52, SS,
    "The spirit totem just was not enough, Bath'rah said, for it needed voodoo magic to work just right. In the sunken temple, the trolls had feathers strong with voodoo magic. They were Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro, and their feathers would give magic enough for a real spirit totem.", "Voodoo feathers from six named trolls of the sunken temple would make Bath'rah's spirit totem work at last.",
    "It was about time the troll got a full night's rest, Bath'rah said, for the spirit totem would watch over him. He had been a long time collecting things, and offered something for the trouble.", "With the feathers in the totem, Bath'rah looked forward to a full night's rest and offered something from his long collecting.", 5)
local WI = "class_warlock_impsy"
q(8419, "An Imp's Request", "WARLOCK", "Felwood", 52, WI,
    "An imp in Felwood by the name of Impsy had requested the warlock's presence, the trainer said. Strangely, he asked for a piece of felcloth as a sign of good faith, and the satyrs of Felwood carried it. Impsy could be found just north of Bloodvenom Falls, said to be quite lovely that time of year.", "Impsy, an imp north of Bloodvenom Falls, wanted a warlock to visit, with felcloth from Felwood's satyrs as a token of good faith.",
    "What a splendid warlock, Impsy said. He loved the feel of felcloth, the way it burned the skin and wove evil thoughts through the mind.", "The felcloth delighted Impsy, who savored how it burned the skin and wove evil thoughts.")
q(8420, "Hot and Itchy", "WARLOCK", "Felwood", 52, WI,
    "It might sound strange from an imp, Impsy said, but he would like a pet of his own. Niby had him, and it was not fair that he got nothing. The pet did not even need to be living. Felcloth would start it, and the satyrs in Felwood sometimes carried some, so enough of them had to be killed.", "Impsy wanted a pet of his own, since Niby had him and he had nothing, and felcloth from the satyrs would start it.",
    "Wow, that was too kind, Impsy said, especially for a warlock. He loved the feel of the felcloth, the way it burned the skin.", "Too kind, Impsy called the warlock over the felcloth, and savored the burn of it.")
q(8421, "The Wrong Stuff", "WARLOCK", "Felwood", 52, WI,
    "With his felcloth, Impsy could really begin making his pet. It would need eyes, carved from rotting wood ripped from the irontree folk up north in the Irontree Woods. Bloodvenom essence would give it that new demon smell, and the tainted oozes that hung around near Niby and him carried it.", "Impsy's pet needed eyes carved from irontree wood and the new-demon smell of bloodvenom essence from the tainted oozes nearby.",
    "This would work so very well, Impsy said.", "The wood and essence pleased Impsy; they would work so very well.")
q(8422, "Trolls of a Feather", "WARLOCK", "The Temple of Atal'Hakkar", 52, WI,
    "The pet was almost done, and Impsy needed something to stuff it with. Only the voodoo feathers of the trolls in the sunken temple would do, and Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro were all to be killed. It was no trivial task, so he would make it worth the while with something of Niby's, who probably did not need it anyhow.", "Only the voodoo feathers of six named trolls in the sunken temple would stuff Impsy's pet, and he offered something of Niby's for them.",
    "Wonderful, Impsy said, for his pet was complete. He quickly stuffed the doll and gave it a demonic hug, then noticed what an odd side effect the voodoo feathers had.", "Impsy stuffed the doll, hugged it, and noticed an odd side effect from the voodoo feathers.", 5)

-- Overnight world pass 2026-11-05, batch 5: the warlock's level-sixty rituals.
-- corpus_vanilla_quests.txt Quest/Progress/Completion for each ID, read in full.
-- A ritual preparation never claims the summoning it prepares; only 7631 (above)
-- and the completions that state it (7583, 7603) hand over the knowledge.
P.threads.class_warlock_infernal = "Niby's infernal lesson"
P.threads.class_warlock_doomguard = "Daio's crystal prison"
local WD, WN, WG = "class_warlock_dreadsteed", "class_warlock_infernal", "class_warlock_doomguard"
q(7562, "Mor'zul Bloodbringer", "WARLOCK", "Burning Steppes", 58, WD,
    "The warlock's trainer judged that a mastery of demons this deep might bind one of the dreadsteeds. The ritual was costly, and Mor'zul Bloodbringer, camped near the Altar of Storms in the Burning Steppes, knew its price.",
    "A dreadsteed of Xoroth was won only through a perilous ritual. The first step was Mor'zul Bloodbringer at the Altar of Storms.",
    "Mor'zul guessed the purpose of the visit at once. Mastering a dreadsteed would cost blood, sweat and gold, he warned, but the prize was worth winning.",
    "Mor'zul Bloodbringer agreed to explain the ritual and its price in blood, sweat and gold.", 4)
q(7563, "Rage of Blood", "WARLOCK", "Burning Steppes", 58, WD,
    "Binding a dreadsteed meant invoking glyphs on a parchment, and Mor'zul needed a special ink to scribe them. It came from the blood of Winterspring's owl beasts, driven mad by the demonic emanations of Darkwhisper Gorge.",
    "The owl beasts of Winterspring had once been pure creatures. Maddened by Darkwhisper Gorge, their blood carried the magic Mor'zul wanted for his ink.",
    "Mor'zul took the blood to be distilled into ink for the parchment, and admitted he might keep a little for himself.",
    "Mor'zul would have the maddened owl beasts' blood made into ink, and he had heard its taste was euphoric.", 3)
q(7564, "Wildeyes", "WARLOCK", "Burning Steppes", 58, WD,
    "Mor'zul's servant Gorzeeki, an alchemist of some skill, was to prepare the ink from the blood Mor'zul had gathered.",
    "Gorzeeki Wildeyes would turn the owl beast blood into the ink for Mor'zul's glyph parchment.",
    "Gorzeeki, who preferred his blood still warm in a rodent, recognized Mor'zul's work. A dreadsteed ritual, he said with delight, would need far more than blood.",
    "Gorzeeki Wildeyes took the blood and guessed its purpose. If a dreadsteed was to be summoned, the ritual would need much more.", 3)
q(7623, "Lord Banehollow", "WARLOCK", "Felwood", 58, WD,
    "Opening a portal to Xoroth required Xorothian stardust. The only source Gorzeeki knew was Lord Banehollow in Jaedenar, seat of the Shadow Council, and getting in meant buying Gorzeeki's shadowy potions.",
    "Xorothian stardust was rare on Azeroth. Gorzeeki's potions would cloak a visitor in the Shadow Council's own evil long enough to reach Lord Banehollow.",
    "Lord Banehollow received the visitor with contempt. His patience spanned millennia, he said, but his time did not.",
    "In Jaedenar, Lord Banehollow granted an audience and warned that it would be brief.", 3)
q(7624, "Ulathek the Traitor", "WARLOCK", "Felwood", 58, WD,
    "Banehollow wanted proof of loyalty. His servant Ulathek was spying for Lord Hel'nurath of Xoroth, and Banehollow wanted the traitor confronted in Shadow Hold and his heart brought back.",
    "Ulathek groveled before Banehollow while plotting with his rival Hel'nurath. Banehollow asked for the spy's heart as the price of his favor.",
    "Banehollow took the traitor's heart and meant to eat it after a week of rotting. His patience for the newcomer had grown, he said, marginally.",
    "Ulathek was dead and his heart delivered. Lord Banehollow called it splendid and thought of sending for the head as well.", 4)
q(7625, "Xorothian Stardust", "WARLOCK", "Burning Steppes", 60, WD,
    "Banehollow knew the stardust was wanted to open a portal to Xoroth, the domain of his rival Hel'nurath. His servant Ur'dan would provide it, if the price was paid.",
    "Lord Banehollow guessed the stardust was meant for stealing a dreadsteed from Hel'nurath. He sent the buyer to his servant Ur'dan, who kept a supply of Xorothian stardust.",
    "Gorzeeki could hardly believe the stardust had been obtained. Now Mor'zul could finish the glyph parchment that would open a portal to Xoroth.",
    "Gorzeeki guessed the Xorothian stardust had cost a large sum, a bargain with the dreadlord, or both.", 4)
q(7626, "Bell of Dethmoora", "WARLOCK", "Burning Steppes", 60, WD,
    "A Circle of Greater Summoning needed three tools. One, a bell named for the late warlock Dethmoora Darkeyes, could be built by Gorzeeki only from a large supply of elixirs of shadow power.",
    "Gorzeeki could make a Bell of Dethmoora to conduct the circle's arcane power, but it took many elixirs of shadow power from an alchemist.",
    "Gorzeeki took the elixirs and set about making the bell, to keep until the ritual.",
    "With the elixirs of shadow power, Gorzeeki began the Bell of Dethmoora, grumbling about miserly alchemists.", 3)
q(7627, "Wheel of the Black March", "WARLOCK", "Burning Steppes", 60, WD,
    "The Wheel of the Black March would contain and direct the circle's violent energies. Gorzeeki needed large brilliant shards from an enchanter and dark iron ore from a master miner.",
    "For the second tool of the circle, Gorzeeki asked for large brilliant shards and dark iron ore.",
    "Gorzeeki praised a warlock's dedication and mused that such energy could have caught a feast of bugs. He promised to make the wheel and keep it until the ritual.",
    "With the shards and dark iron ore in hand, Gorzeeki could make the Wheel of the Black March.", 3)
q(7628, "Doomsday Candle", "WARLOCK", "Burning Steppes", 60, WD,
    "A Doomsday Candle would burn any wayward demon that disrupted the ritual. Containing its fire required the essence in black dragon scales.",
    "The third tool of the circle stored fire. Gorzeeki needed black dragonscales from a skinner before he dared start it.",
    "Gorzeeki had his dragonscales and could make the candle without blowing up the camp.",
    "With the black dragonscales, Gorzeeki could contain the candle's fire, and he would keep it until the ritual.", 3)
q(7629, "Imp Delivery", "WARLOCK", "Burning Steppes", 60, WD,
    "Mor'zul's parchment needed paper infused with Xorothian stardust, and only the alchemy lab in Scholomance had the equipment. Gorzeeki lent a jar holding a clever imp to do the work there.",
    "Gorzeeki could not travel to Caer Darrow himself. The imp in his jar could infuse the parchment, once released in Scholomance's alchemy lab.",
    "The imp J'eevee had made the parchment. Gorzeeki asked after Scholomance's bugs and took back his jar, which was not for sale.",
    "The infused parchment came back from Scholomance along with Gorzeeki's old jar.", 4)
q(7630, "Arcanite", "WARLOCK", "Burning Steppes", 60, WD,
    "With the bell, wheel and candle made, Gorzeeki wanted a black lodestone to sustain them if they failed during the ritual. The lodestone required arcanite.",
    "A black lodestone would keep the ritual from fizzling out. Gorzeeki could make one, given arcanite from an alchemist.",
    "Gorzeeki had his arcanite and could make the lodestone that would keep the ritual from failing.",
    "Once the arcanite was his, Gorzeeki could make the lodestone, so the ritual for the Circle of Greater Summoning would not fizzle out.", 3)
q(7601, "What Niby Commands", "WARLOCK", "Felwood", 50, WN,
    "Niby the Almighty would teach the summoning of an infernal servant once he had the infernal core of Kroshius. Kroshius had all but burned out and had to be raised from the rubble first; Niby's imp, Impsy, would explain.",
    "To learn the infernal summoning, Niby wanted Kroshius destroyed. That meant first reigniting the demon's burned-out corpse, and Impsy knew how.",
    "Impsy greeted the newcomer with weary resignation.",
    "Niby's imp received his master's next student with a weary remark that it was happening again.", 3)
q(7602, "Flawless Fel Essence", "WARLOCK", "Felwood", 55, WN,
    "Reanimating Kroshius needed fel fire, and Impsy could make it from three flawless fel essences. They came from the Legashi satyrs of Azshara, the legionnaires of Jaedenar and the felguard sentries of the Blasted Lands.",
    "Impsy's fel fire called for essences from three distinct regions. He also confided that Niby was daft.",
    "Impsy took the three essences and asked for a minute to combine them into fel fire.",
    "With three essences in hand, Impsy began making fel fire.", 3)
q(7603, "Kroshius' Infernal Core", "WARLOCK", "Felwood", 55, WN,
    "Fel fire set on the remains of Kroshius in Shatter Scar Vale would reanimate the fallen infernal. Impsy fully expected him to kill whoever tried, and advised bringing friends.",
    "Kroshius lay in a heap to the northeast. Raised with fel fire, he would have to be killed again for his infernal core.",
    "Niby had the infernal core of Kroshius. A deal was a deal, he said, and he hurried to hand over the knowledge before his own greatest conjuration began.",
    "Niby kept his side of the bargain for the core, though he was in a great hurry.", 5)
q(7581, "The Prison's Bindings", "WARLOCK", "Blasted Lands", 60, WG,
    "A Doomguard could be held only by a crystal prison of special make. Its bindings had to come from lesser demons, the Wildspawn satyrs of Dire Maul, whose blood would bond the Hederine shards.",
    "Daio the Decrepit needed coagulated blood from the Wildspawn satyrs of Dire Maul to bind his crystal prison.",
    "Daio judged the blood an excellent recovery. It would suppress the Doomguard's magical defenses.",
    "With the Wildspawn blood, Daio meant to turn the Doomguard's own magic against it.", 3)
q(7582, "The Prison's Casing", "WARLOCK", "Blasted Lands", 60, WG,
    "The Hederine of Darkwhisper Gorge in Winterspring secreted fel poisons that hardened into anti-magic crystals, the Tears of the Hederine. Not even a Doomguard could break a prison made of them.",
    "Daio's prison needed walls of the Tears of the Hederine, crystals the demons of Darkwhisper Gorge would not give up without a fight.",
    "Daio had the Tears and needed only to combine them with the Wildspawn blood for the prison to be ready.",
    "With the Tears of the Hederine and the satyr blood, Daio could make the crystal prison.", 3)
q(7583, "Suppression", "WARLOCK", "Blasted Lands", 60, WG,
    "The prison was ready. A Doomguard Commander in the Tainted Scar had to be captured in it, and Daio warned that the demon would turn all its fury on the one performing the ritual.",
    "Daio called the capture the hardest part. A cornered Doomguard Commander would flail and strike at its captor, and companions would be needed to stay alive.",
    "The Doomguard was imprisoned. Daio declared the warlock ready for the knowledge to conjure and control such a beast.",
    "With a Doomguard Commander captured in the crystal, Daio judged the task done and offered the knowledge to summon one.", 5)
P.questIDs[7583].highlight = {"A Doomguard Commander was captured in Daio's crystal prison, and Daio offered the knowledge to conjure and control one.",
    "Daio's prison held a Doomguard Commander from the Tainted Scar. The warlock, he said, was now ready to command such a beast."}
P.questIDs[7603].highlight = {"Kroshius was raised with fel fire and destroyed. Niby took the infernal core and, in a hurry, kept his side of the bargain.",
    "For the infernal core of Kroshius, Niby handed over the promised knowledge before his own conjuration began."}
for _, id in ipairs({7562, 7563, 7564, 7623, 7624, 7625, 7626, 7627, 7628, 7629, 7630, 7601, 7602, 7603, 7581, 7582, 7583}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
end

-- Batch 6: the paladin's charger and the hunter's ancients in Felwood. The
-- charger is claimed only by 7647's completion; the barding, feed and scryer
-- stages prepare it. The bow of Ancients is never finished by any single
-- stage here: 7636 gives the stave, 7635 the string, 7634 the quiver.
P.threads.class_paladin_charger = "the trial for a paladin's charger"
P.threads.class_hunter_ancients = "the gifts of Felwood's ancients"
local PC2, HA = "class_paladin_charger", "class_hunter_ancients"
q(7638, "Lord Grayson Shadowbreaker", "PALADIN", "Stormwind City", 60, PC2,
    "The paladin's trainer said the time had come to learn what it would take to win a charger. Lord Grayson Shadowbreaker, in Stormwind's Cathedral District, would guide the tasks.",
    "A paladin's most trusted mount was not simply given. Lord Grayson Shadowbreaker, close by in the Cathedral District, knew the trial.",
    "Lord Grayson warned that the tests would be many, and no mere lesson. The future charger had to be saved from the clutches of evil.",
    "Grayson Shadowbreaker explained the task ahead, to rescue a future companion from the very evil the paladins had always fought.", 4)
q(7670, "Lord Grayson Shadowbreaker", "PALADIN", "Stormwind City", 60, PC2,
    "The paladin's trainer said the time had come to learn what it would take to win a charger, and named Lord Grayson Shadowbreaker in Stormwind as the guide.",
    "Winning a charger began with a journey to Stormwind's Cathedral District, where Lord Grayson Shadowbreaker would explain the trial.",
    "Lord Grayson warned that the tests would be many, and no mere lesson. The future charger had to be saved from the clutches of evil.",
    "Grayson Shadowbreaker explained the task ahead, to rescue a future companion from the very evil the paladins had always fought.", 4)
q(7637, "Emphasis on Sacrifice", "PALADIN", "Ironforge", 60, PC2,
    "The trial began with sacrifice. High Priest Rohan's exorcism censer was needed, and Grayson asked that ample coin be given in Ironforge to offset its loss.",
    "High Priest Rohan's exorcism censer waited in Ironforge. Paying generously for it would show the sacrifice the trial demanded.",
    "Rohan blessed the donation, which went well beyond the cost of a new censer and would feed Ironforge's needy. He prepared the censer for the trial.",
    "The coin given in Ironforge would help Rohan make a new censer and bolster the food reserves for the needy. He had blessed his old censer thrice for its new use.", 3)
q(7639, "To Show Due Judgment", "PALADIN", "Stormwind City", 60, PC2,
    "Rohan gave his censer with his blessing. He had used it in several exorcisms himself, and Grayson was waiting for it in Stormwind.",
    "With Rohan's exorcism censer in hand, the next step lay with Lord Grayson Shadowbreaker in Stormwind.",
    "Grayson accepted the censer as proof of sacrifice. Next would come judgment, and the censer would carry it to the tortured spirits of lost lands.",
    "Grayson took the censer, called sacrifice a key part of a paladin's duty, and named judgment as the next test.", 3)
q(7640, "Exorcising Terrordale", "PALADIN", "Stormwind City", 60, PC2,
    "Grayson added a pinch of tainted earth from Terrordale to the censer. Green auras in the Eastern Plaguelands marked where tormented spirits troubled the ground, and the censer would drive them out.",
    "In Terrordale, the physical world buckled under the torment of the spirit realm. Rohan's censer would pass judgment there.",
    "Grayson praised the judgments rendered in Terrordale. Next, he said, came the effort to reclaim the spirit of a fallen charger that now served the death knight Darkreaver.",
    "Terrordale's spirits had been judged. Grayson named the path ahead, to a fallen charger bound to the death knight Darkreaver.", 4)
q(7641, "The Work of Grimand Elmore", "PALADIN", "Stormwind City", 60, PC2,
    "A charger without barding was a pack animal, Grayson said, and this barding had to be attuned to the spirit realm. Grimand Elmore in the Dwarven District was among the finest craftsmen alive.",
    "Grayson recommended Grimand Elmore of Stormwind's Dwarven District, for barding of the finest quality at no small price.",
    "Grimand had expected the visit. He agreed to make the barding, warned it would be neither cheap nor easy, and claimed none better could be found in Azeroth.",
    "Grimand Elmore promised barding unmatched anywhere, and said plainly that it would cost a great deal.", 3)
q(7642, "Collection of Goods", "PALADIN", "Stormwind City", 60, PC2,
    "Grimand's barding needed runecloth for the lining, arcanite bars for the plating, Arthas' Tears and Stratholme holy water. His fee in gold also covered the saddle and stirrups.",
    "Five things stood between Grimand and finished barding, four rare materials and the gold for his fee.",
    "Grimand found everything he had asked for and set to finishing the barding.",
    "Runecloth, arcanite, Arthas' Tears, holy water and gold were all there, and Grimand admired the resourcefulness and went to work.", 3)
q(7648, "Grimand's Finest Work", "PALADIN", "Stormwind City", 60, PC2,
    "Grimand wiped his brow and called the barding some of his finest work, as good as the set he had made for Grayson's own charger. He sent it to Grayson with his thanks.",
    "The finished barding was ready. Grimand wanted Grayson to see it for himself.",
    "Grayson admired the barding and said Grimand's craft improved with age. A charger's barding needed a blessing as well, so he kept it until one could be found.",
    "Grayson praised Grimand's work, but the barding was not yet worthy of a paladin's charger. It still needed blessing by a fitting spirit.", 3)
q(7643, "Ancient Equine Spirit", "PALADIN", "Dire Maul", 60, PC2,
    "The barding needed a blessing from the Ancient Equine Spirit in Dire Maul, held by the corrupt treant Tendris Warpwood. Freeing the spirit was not enough; it had to be soothed with special feed from Merideth Carlson of Southshore.",
    "Tendris Warpwood held an ancient horse spirit in Dire Maul. Only once the treant was judged and the spirit fed would it bless the barding.",
    "The Ancient Equine Spirit ate the Manna-Enriched Horse Feed, then stood as if waiting for the barding to be laid on its back.",
    "Freed from Tendris Warpwood and fed from Merideth's blend, the horse spirit turned expectantly toward the barding.", 4)
q(7645, "Manna-Enriched Horse Feed", "PALADIN", "Hillsbrad Foothills", 60, PC2,
    "Merideth Carlson of Southshore had been called mad by the Silver Hand for claiming spirit horses could be fed. The price was Enriched Manna Biscuits from the Argent Dawn, plus gold for the misery endured.",
    "Merideth Carlson could nourish spirit horses and wanted the paladins to pay for the old mockery. The price was Argent Dawn biscuits and gold.",
    "Payment for wrongs others had committed took Merideth by surprise. An offer of free feed in future followed, though the gold stayed in Southshore.",
    "For the biscuits and gold, Merideth Carlson answered the sacrifice with a promise of free feed in future, and kept the money.", 3)
q(7644, "Blessed Arcanite Barding", "PALADIN", "Stormwind City", 60, PC2,
    "On the Ancient Equine Spirit's back the barding glowed, and the air thickened with power. Then it was blessed and ready to return to Grayson.",
    "The horse spirit's blessing had passed into the barding. Grayson wanted it brought back to Stormwind.",
    "Grayson declared the barding ready to harness the charger once its redemption was done. One last item remained to be made before the struggle ahead.",
    "Back in Stormwind, the blessed barding went to Grayson. A great trial was near, he said, with one more thing still to make.", 4)
q(7646, "The Divination Scryer", "PALADIN", "Stormwind City", 60, PC2,
    "The censer from Terrordale would be the heart of a Divination Scryer, and Grayson would build its housing. Two diamonds, an Azerothian and a Pristine Black, would let the scryer pierce the shadows.",
    "Grayson called the diamonds the last worldly sacrifice before the trial. One bright and one black, they would complete the scryer.",
    "Grayson set the diamonds in place and revealed the trial. In the Great Ossuary of Scholomance, the hollowed soul of a once-noble charger served as the death knight Darkreaver's steed.",
    "The Divination Scryer was finished. Darkreaver waited in Scholomance with the charger he rode, and Grayson called the trial at hand.", 4)
q(7647, "Judgment and Redemption", "PALADIN", "Scholomance", 60, PC2,
    "Grayson gave a satchel for the trial. In the basement of the Great Ossuary, the scryer would call up accursed spirits to be judged, and then Darkreaver himself.",
    "Accursed spirits first, then the death knight Darkreaver, Grayson warned. Only then could the charger's lost soul be reclaimed.",
    "Darkreaver fell, and the charger's judged soul was returned to it. Life came back into its eyes, it accepted the barding, and from then on it would come as a steed when called.",
    "The fallen charger was redeemed in Scholomance. With the blessed barding on its back, it nuzzled the hand that had freed it.", 6)
P.questIDs[7647].highlight = {"Darkreaver fell in the Great Ossuary, and the fallen charger's soul was redeemed. It accepted the blessed barding, an epic charger ready to serve.",
    "In Scholomance, the charger Darkreaver had ridden was judged and redeemed. Wearing its blessed barding, it was ready to serve."}
P.questIDs[7640].highlight = {"The censer passed judgment on the tormented spirits of Terrordale. Grayson then named the true trial, a fallen charger serving Darkreaver.",
    "Terrordale's spirits were judged with Rohan's censer, and Grayson revealed the charger bound to the death knight Darkreaver."}

q(7632, "The Ancient Leaf", "HUNTER", "Felwood", 60, HA,
    "A glowing green leaf, deeply veined and wrinkled, seemed to come from something ancient and powerful. Its owner might be found.",
    "The strange leaf was in perfect condition and plainly not from any ordinary tree. Someone ancient might want it back.",
    "Vartrus the Ancient recognized his own leaf and was pleased it had been returned. He suggested an exchange of service between the ancients and their helper.",
    "The leaf belonged to Vartrus the Ancient, who groaned his thanks and offered an exchange of service.", 4)
q(7636, "Stave of the Ancients", "HUNTER", "Felwood", 60, HA,
    "Agents of the Burning Legion still corrupted the world in disguise. Vartrus wanted them tracked down and killed alone, as they would flee from a group, and their heads brought back.",
    "Vartrus gave a piece of his bark whose inscriptions led to hidden demonic corrupters. They had to be faced singly, and they would try to kill a lone hunter.",
    "Vartrus gave a stave from the ancients and said to combine it with the bowstring Stoma could make. Together they would form a formidable weapon.",
    "The demon agents were destroyed. Vartrus rewarded the service with a stave of the ancients, the body of a bow still lacking its string.", 5)
q(7635, "A Proper String", "HUNTER", "Felwood", 60, HA,
    "Stoma alone could enchant the string for a bow of Ancients. He wanted sinew from a mature black dragon.",
    "Vartrus could give the stave, but the bowstring was Stoma's to make. Its sinew had to come from a slain black dragon.",
    "Stoma found the black dragon's sinew foul with evil, and set to cleansing it and laying on the enchantments.",
    "Stoma began making the sinew into a nearly indestructible bowstring.", 4)
q(7634, "Ancient Sinew Wrapped Lamina", "HUNTER", "Felwood", 60, HA,
    "Hastat, Ancient of Lore, could bind one of his leaves into a quiver not seen in ten thousand years. He needed sinew from an adult blue dragon.",
    "A quiver to accompany a bow of Ancients could be made from Hastat's leaf, if bound with blue dragon sinew.",
    "Hastat blessed the finished quiver, that its arrows might be protected and strike true.",
    "The blue dragon sinew bound Hastat's leaf into a quiver, which he gave with a blessing.", 4)
P.questIDs[7636].highlight = {"Vartrus gave a stave of the ancients for slaying the Legion's disguised agents. Stoma's bowstring would complete it.",
    "The hidden demon corrupters were dead, and Vartrus answered with a stave of the ancients."}
for _, id in ipairs({7638, 7670, 7637, 7639, 7640, 7641, 7642, 7648, 7643, 7645, 7644, 7646, 7647, 7632, 7636, 7635, 7634}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
end

-- Batch 12, picked up from the horde lane's hand-off: the Forsaken warrior's
-- Brill trial (Coleman and the Agamand crypt are set up in the horde pack's
-- stages 354, 362 and 408) and Forever's Zephras class referrals. A referral
-- reaches a trainer; it never proves that a lesson or spell was learned.
P.threads.class_warrior_brill = "the Deathguards' test in Brill"
P.threads.class_zephras_trainers = "the trainers of Thendal Grove"
local WBR, ZT = "class_warrior_brill", "class_zephras_trainers"
q(1818, "Speak with Dillinger", "WARRIOR", "Tirisfal Glades", 10, WBR,
    "Deathguard Dillinger, posted at the west end of Brill near the graveyard, had a job for a warrior willing to prove their value to the Dark Lady's forces.",
    "A mission was waiting in Brill for a warrior of the Forsaken. Deathguard Dillinger kept his post by the graveyard.",
    "Dillinger had an important mission ready, one that would test both skill in combat and resolve in the defense of the Forsaken.",
    "Dillinger welcomed the new warrior and promised a test of resolve.", 3)
q(1819, "Ulag the Cleaver", "WARRIOR", "Tirisfal Glades", 10, WBR,
    "The Forsaken had captured one of the Scourge, Ulag the Cleaver, whose will was free though the Lich King still held him. Every attempt to break that hold had failed, so a skull stone by the mausoleum would lift his seal and he would be killed.",
    "Dillinger could not free Ulag from the Lich King's control. What remained was to open the mausoleum's seal and kill him.",
    "Ulag was dead. Dillinger said he had been no minor agent of the Scourge, and that the deed proved a warrior worthy of further instruction.",
    "Ulag the Cleaver fell, and the Deathguards counted it proof of skill and resolve.", 5)
q(1820, "Speak with Coleman", "WARRIOR", "Tirisfal Glades", 10, WBR,
    "Coleman Farthing, in the Gallow's End Tavern in eastern Brill, wanted a warrior to be his instrument of revenge against the Forsaken's enemies.",
    "Having proved their worth to the Dark Lady, a warrior could now serve one of her subjects. Coleman Farthing waited at the Gallow's End.",
    "Coleman admitted his means were small, but his task would serve both him and the Forsaken, and pay twice over.",
    "At the Gallow's End Tavern, Coleman Farthing explained that his revenge and the Forsaken's cause ran together.", 3)
q(1821, "Agamand Heirlooms", "WARRIOR", "Tirisfal Glades", 11, WBR,
    "Coleman said the Agamands, his employers in life, had caused his death. Now mindless servants of the Lich King, they kept a sword, an axe, a dagger and a mace in their crypt at the north end of the mills.",
    "Coleman wanted the last vestiges of the Agamands' honor. Their crypt held four heirloom weapons among lurking Scourge and dead Agamands.",
    "Coleman had the four heirlooms. The last semblance of honor had been stripped from the cursed Agamand lands, he said, and the family was truly no more.",
    "Sword, axe, dagger and mace went to Coleman Farthing, and with them, he said, the last memory of the Agamands.", 4)
P.questIDs[1821].highlight = {"Coleman Farthing had the Agamand heirlooms, taken from the employers who had caused his death. The family, he said, was truly no more.",
    "Coleman took the sword, axe, dagger and mace from the Agamand crypt as the end of the family that had killed him."}
q(92481, "A Student of the Arcane", "MAGE", "Zephras Isle", 2, ZT,
    "With the vuldren dealt with, a recall crystal from Dorii Brightwhisper, Thendal Grove's mage trainer, carried a message.",
    "Dorii Brightwhisper had left a recall crystal for a new student of magic and waited in a building in Thendal Grove.",
    "Dorii said the arcane had waned among their people over the millennia spent in the clouds, and hoped the newcomer would help rediscover what was lost.",
    "Dorii Brightwhisper judged the newcomer a fine young mage and offered further steps when ready.", 3)
q(92482, "The Way of the Hunter", "HUNTER", "Zephras Isle", 2, ZT,
    "After the vuldren were dealt with, a note from Tai'ree Farsight, Thendal Grove's hunter trainer, asked for a visit near the center of the village.",
    "Tai'ree Farsight had left a note for a new hunter. She could be found in the middle of Thendal Grove.",
    "Tai'ree warned that the hunter's way was full of danger and belonged to those with keen senses and quick reflexes. She saw her younger self in the newcomer.",
    "Tai'ree Farsight nodded curtly, then said the newcomer had what it took, if the choice was made.", 3)
q(92483, "At Home in the Shadows", "ROGUE", "Zephras Isle", 2, ZT,
    "Akeri Duskblade, Thendal Grove's rogue trainer, had asked to speak with the newcomer and left a note. He waited inside the village watchtower.",
    "Akeri Duskblade waited in the watchtower for a new rogue, a shady fellow by one villager's account.",
    "Akeri almost did not hear the approach, and almost, he said, would not be good enough beyond Thendal Grove. Survival on Zephras would come down to vigilance.",
    "Akeri Duskblade spoke of being a slender blade, silent and steady, and of the dangers waiting outside the grove.", 3)
q(92484, "Embracing the Elements", "SHAMAN", "Zephras Isle", 2, ZT,
    "Windshaper Boro, Thendal Grove's shaman trainer, had left a recall crystal and waited near the center of the village.",
    "With the vuldren dealt with, Windshaper Boro, Thendal Grove's shaman trainer, wanted to meet a new shaman.",
    "Boro explained that the spirits of the four winds had stopped speaking with their people years ago. Shaman studied the elements in the hope of restoring that dialogue.",
    "Boro asked whether the newcomer would walk the path to master the elements, and offered training when ready.", 3)
q(92485, "A Student of Nature", "DRUID", "Zephras Isle", 2, ZT,
    "Xyton Silverwind, Thendal Grove's druid trainer, had left a note. He waited on the ground floor of the village's great tree.",
    "A new druid was to seek out Xyton Silverwind, keeper of druidic lore, and heed his counsel.",
    "Xyton described the island's life as a tapestry that druids kept in balance. He saw potential, and warned that the path of the fang, claw, feather and branch was not easy.",
    "Xyton Silverwind welcomed a new student of nature and offered guidance for the road ahead.", 3)
q(92532, "The Warrior's Path", "WARRIOR", "Zephras Isle", 2, ZT,
    "Blademaster Ren, Thendal Grove's warrior trainer, had asked that the newcomer be sent to the village watchtower, and left a note.",
    "A note from Blademaster Ren waited for a new warrior, with directions to the watchtower.",
    "Ren spoke of a changing world that would need people willing to lead and protect others, and promised training as the newcomer grew.",
    "Blademaster Ren wished the newcomer luck and offered guidance on the dangerous journey ahead.", 3)
for _, id in ipairs({1818, 1819, 1820, 1821, 92481, 92482, 92483, 92484, 92485, 92532}) do
    P.questIDs[id].source[2] = id < 90000 and ("https://classicdb.ch/?quest=" .. id) or "Forever addition: corpus_vanilla_quests.txt record (no Classic database page)"
    P.questIDs[id].setting = id < 90000 and "Classic / Forever" or "Forever"
end

-- World2 pass 2026-11-05, batch W2-6: the Durotar warlock's first trial under
-- Ruzan. "Vile Familiars" is shared with Zureetha's own quest (horde pack 792,
-- which also owns the title fallback), so both stages are exact-only here and
-- neither claims a summoning lesson.
q(1485, "Vile Familiars", "WARLOCK", "Durotar", 4, "class_warlock_binding",
    "Ruzan said warlocks were tolerated by the Horde, not loved, and many dabbled in their magics alone. Before teaching summoning, Ruzan wanted six heads of the vile familiars from the cave to the northeast.",
    "The warlock trainer Ruzan, in the Valley of Trials, asked for six vile familiar heads before any lesson in summoning.",
    "Ruzan spoke of the many beings a warlock would learn to call, and warned against judging the imp by its size.",
    "Ruzan took the six heads and warned that the imp, small as it was, had proved a formidable foe.", 3)
q(1499, "Vile Familiars", "WARLOCK", "Durotar", 4, "class_warlock_binding",
    "Zureetha Fargaze was sending novices to cull the creatures in a cave near where the familiars were fought. Ruzan thought helping her would be good experience.",
    "Ruzan sent the novice to Zureetha Fargaze with word of the help given against the imps.",
    "Zureetha Fargaze heard that the cave's creatures were culled and said the novice had done well.",
    "Well done, Zureetha said of the culling, and she gave the novice a reward.", 3)
for _, id in ipairs({1485, 1499}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
    P.questIDs[id].source[3] = "LoreHordeStories.lua 792 and the Vile Familiars fallback; hand-off 2026-11-05"
end

-- World2 pass 2026-11-05, batch W2-7: the human class chains of Northshire and
-- Stormwind. The six Northshire letters reach a trainer and never claim a lesson.
-- Warrior: Burlguard, Haggard and Dead-tooth Jack, Barleybrew's gauntlet, Furen's
-- shield and mail, Grimand's armor (1706 and 1782 have no captured text and stay
-- out). Paladin: the call to Duthorian Rall and the Tome of Valor at the Stilwell
-- house. Mage: Andromath. Rogue: Renzik and Lucius. The priests' Desperate Prayer
-- stages stay unwritten (their records mix givers and destinations).
P.threads.class_northshire = "the trainers of Northshire Abbey"
P.threads.class_paladin_valor = "the paladin's test of valor"
P.threads.class_mage_andromath = "High Sorcerer Andromath's errands"
local NL, PV, MA = "class_northshire", "class_paladin_valor", "class_mage_andromath"
q(3100, "Simple Letter", "WARRIOR", "Elwynn Forest", 1, NL,
    "A letter waited at Northshire Abbey, sealed with the insignia of Llane, the local warrior trainer. Warriors had been gathering in Elwynn of late, which was bad news for the kobolds and the Defias.",
    "Llane, Northshire's warrior trainer, had sent a sealed letter asking to be found.",
    "Training was there whenever it was needed, night or day, Llane said. The Knights of the Silver Hand had made Northshire fairly safe, but its people still had problems a warrior could help with.",
    "Back at the abbey, the warrior trainer offered lessons whenever they were wanted.", 2)
q(3101, "Consecrated Letter", "PALADIN", "Elwynn Forest", 1, NL,
    "A letter at Northshire Abbey bore the insignia of Brother Sammuel, the local paladin trainer.",
    "Brother Sammuel, Northshire's paladin trainer, had sent a sealed letter.",
    "Sammuel said a paladin was a symbol to many, and the Light within would be plain to friend and foe. He would teach more once some experience had been gained in Northshire.",
    "Northshire's paladin trainer welcomed the newcomer and promised lessons later on.", 2)
q(3102, "Encrypted Letter", "ROGUE", "Elwynn Forest", 1, NL,
    "A letter at Northshire Abbey was sealed with the insignia of Jorik, one of the local trainers.",
    "Jorik, who trained rogues quietly at the back of the abbey, had left a sealed letter.",
    "Quiet suited Jorik. He warned that many outfits would covet a rogue's skills, SI:7 and the Defias among them, and offered training whenever it was wanted.",
    "At the back of the abbey, Jorik introduced himself, offered training any time, and advised answering to no one.", 2)
q(3103, "Hallowed Letter", "PRIEST", "Elwynn Forest", 1, NL,
    "A letter at Northshire Abbey bore the insignia of Priestess Anetta, the local priest trainer.",
    "Priestess Anetta, Northshire's priest trainer, had sent a sealed letter.",
    "As experience grew, Anetta promised to share her knowledge, and she urged compassion and wisdom on the way.",
    "Northshire's priest trainer welcomed the newcomer and offered to teach in time.", 2)
q(3104, "Glyphic Letter", "MAGE", "Elwynn Forest", 1, NL,
    "A letter at Northshire Abbey bore the insignia of Khelden, the local mage trainer.",
    "Khelden Bremen, Northshire's mage trainer, had sent a sealed letter.",
    "His note, Khelden laughed, had not put the newcomer off. A mage would be feared as much as respected, he warned, and he would be there for training.",
    "Northshire's mage trainer welcomed the newcomer and promised training to come.", 2)
q(3105, "Tainted Letter", "WARLOCK", "Elwynn Forest", 1, NL,
    "A letter at Northshire Abbey bore the insignia of Drusilla, one of the local trainers.",
    "Drusilla La Salle had sent a sealed letter for a new warlock at Northshire.",
    "Corruption could reach anyone who dealt with creatures of the Twisting Nether, Drusilla warned. Patience and prudence were needed, but ambition should not be repressed.",
    "Northshire's warlock trainer welcomed the newcomer and promised more teaching later.", 2)

q(1639, "Bartleby the Drunk", "WARRIOR", "Stormwind City", 10, W,
    "Harry Burlguard would teach, but first he wanted to see what moves a newcomer already had. Bartleby, the drunk at the end of the bar in the Pig and Whistle, would not give up his mug easily.",
    "Harry Burlguard's first test was to get Bartleby's mug, and Bartleby would not just hand it over.",
    "Insults about prissy hands and broken nails met the challenger at the end of the bar.",
    "At the end of the bar, Bartleby mocked the newcomer as a fancy boy who might break a nail.", 3)
q(1666, "Marshal Haggard", "WARRIOR", "Elwynn Forest", 10, W,
    "Harry Burlguard thought a decent weapon was still needed. Marshal Haggard, retired at the Eastvale Lumber Camp in Elwynn, had collected a lot of gear in his career.",
    "Burlguard sent the warrior to Marshal Haggard, an old soldier in Elwynn Forest, who might have a spare weapon.",
    "His eyes had failed him, and at first Haggard took the visitor for a gnoll.",
    "Old Marshal Haggard asked the visitor to step closer and wondered whether Burlguard had come himself.", 3)
q(1667, "Dead-tooth Jack", "WARRIOR", "Elwynn Forest", 10, W,
    "A Defias villain called Dead-tooth Jack had worn a Stormwind tabard in the dark and passed for Marshal Dughan. Haggard had handed over his old marshal's badge before Jack ran off laughing.",
    "Marshal Haggard wanted his stolen badge back from Dead-tooth Jack's camp to the south before the Defias used it.",
    "The badge was back, and the Defias could not use it to pose as a Stormwind official. Haggard offered a pick of his old weapons.",
    "With his badge recovered, Marshal Haggard let his visitor choose from the weapons of his marshal days.", 4)
q(1698, "Yorus Barleybrew", "WARRIOR", "Redridge Mountains", 20, W,
    "Yorus Barleybrew had challenged every able warrior of the Alliance. He waited at the Lakeshire Inn in Redridge with a grand reward for anyone who passed his trial.",
    "A warrior trainer passed on the challenge of Yorus Barleybrew, who waited at the Lakeshire Inn.",
    "Barleybrew offered a seat and a drink, and suggested savoring it in case it was the last.",
    "At the Lakeshire Inn, Yorus Barleybrew welcomed a challenger with a drink.", 3)
q(1699, "The Rethban Gauntlet", "WARRIOR", "Redridge Mountains", 22, W,
    "The Rethban Gauntlet meant a swig of Barleybrew Scalder, then a run to the first fork of the Rethban Caverns and back within an hour, through heaps of gnolls.",
    "Yorus Barleybrew's gauntlet ran from Lakeshire to the Rethban Caverns north of town, against the clock and the Redridge gnolls.",
    "Three cheers went up from Barleybrew for the runner who made it back in time.",
    "Back at the Lakeshire Inn, Barleybrew called the run through the Rethban Caverns well done.", 4)
q(1702, "The Shieldsmith", "WARRIOR", "Stormwind City", 22, W,
    "Barleybrew kept his word, but the reward was in Stormwind. Furen Longbeard, the best shieldsmith in the Dwarven District, owed him a favor and would get a cask of Scalder with a request for a shield.",
    "Yorus Barleybrew sent a cask of Scalder to Furen Longbeard in Stormwind, with a request for a shield.",
    "Gladly taking the Scalder, Furen promised a shield like no other.",
    "In the Dwarven District, the shieldsmith welcomed the cask and agreed to make the shield.", 3)
q(1701, "Fire Hardened Mail", "WARRIOR", "Stormwind City", 28, W,
    "Furen knew the secret of a very hard mail, made from rare materials. He would make a piece for anyone willing to gather them.",
    "Fire hardened mail needed rare materials from far away, and Furen Longbeard would make it if they were found.",
    "Furen was amazed, having feared the chimaeras would eat the gatherer, and started on the armor.",
    "Furen had every rare material for the mail, though he had feared the chimaeras would eat the warrior first.", 3)
q(1700, "Grimand Elmore", "WARRIOR", "Stormwind City", 28, W,
    "Furen had copied his notes on the techniques he learned making armor, and wanted them sent to Grimand Elmore in the Dwarven District's weapon shop. He advised ducking, since Grimand was proud of his skill.",
    "Furen Longbeard's armor notes were meant for Grimand Elmore, who would hate to learn anything from him.",
    "Grimand was outraged, having taught Furen everything he knew. Still, something in the notes made him want to try it.",
    "Grimand Elmore fumed over Furen's notes, then admitted there was something in them worth trying.", 3)
q(1705, "Burning Blood", "WARRIOR", "Stormwind City", 28, W,
    "Grimand grudgingly admitted Furen might have found something. To test the technique on new armor, he needed burning blood from the Nightbane worgen of Roland's Doom in Duskwood, and a burning rock from their leader, Gutspill.",
    "Grimand Elmore's armor called for burning blood and a burning rock. Both were to be found with the Nightbane worgen in Duskwood.",
    "Pleased with the materials, Grimand went off to his own work.",
    "Nice work, said Grimand of the burning blood and rock, and excused himself to his own.", 3)

q(2998, "Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "Brother Wilhelm had overheard Duthorian Rall speaking well of a young paladin, and saying it was time for a test.",
    "Duthorian Rall, one of the most influential paladins, wanted to see the newcomer at the Cathedral of Light in Stormwind.",
    "Rall remarked on Stormwind's beauty and said the timing could not have been better.",
    "At the Cathedral of Light, Duthorian Rall welcomed the paladin at a good moment.", 3)
q(1649, "The Tome of Valor", "PALADIN", "Stormwind City", 20, PV,
    "The Tome of Valor compared valor to a rare mineral, to be refined into a strong alloy. Faith and bravery had to be tested.",
    "The Tome of Valor taught that faith should never be lost, since the Light could overcome what others could not.",
    "Duthorian Rall welcomed a petition for the test of valor and warned that such a test could cost a life.",
    "Rall accepted the petition, warning that the Church wanted its paladins worthy.", 3)
q(1650, "The Tome of Valor", "PALADIN", "Westfall", 23, PV,
    "Daphne Stilwell lived alone at the far end of Westfall's Longshore while her husband Jordan, a fine smith, was in Ironforge. The Defias had all but taken over the area.",
    "Duthorian Rall sent the paladin to protect Daphne Stilwell, whose house on the Longshore stood among the Defias.",
    "Daphne had already killed half a dozen Defias since the last sunrise, and expected more any minute.",
    "Daphne Stilwell greeted her protector and warned that the Defias would come again soon.", 3)
q(1651, "The Tome of Valor", "PALADIN", "Westfall", 25, PV,
    "Daphne expected more Defias than before. She meant to grab her gun and make her stand near the house.",
    "Daphne Stilwell expected another Defias attack on her house, and meant to fight beside her protector.",
    "The Defias were beaten back. Daphne praised bravery in the face of overwhelming odds.",
    "The Stilwell house held against the Defias, and Daphne gave her thanks.", 4)
q(1652, "The Tome of Valor", "PALADIN", "Stormwind City", 25, PV,
    "Daphne asked that Duthorian Rall be told she was safe for now, so word could reach Jordan in Ironforge.",
    "The news of Daphne Stilwell's safety was for Duthorian Rall in the Cathedral of Light.",
    "Rall said the Stilwells had helped the Church greatly, and protecting them was the least it could do. He rewarded the paladin's valor.",
    "Duthorian Rall heard that the Stilwell home was safe for another day and gave a reward for valor.", 4)
P.questIDs[1652].highlight = {"Daphne Stilwell's house held against the Defias, and Duthorian Rall rewarded the paladin's valor.",
    "Rall learned the Stilwells were safe for now, and the paladin's valor was rewarded."}

q(1939, "High Sorcerer Andromath", "MAGE", "Stormwind City", 26, MA,
    "A summons came from High Sorcerer Andromath, one of the most powerful mages outside Dalaran. He waited at the top of the Wizard's Sanctum in Stormwind's mage district.",
    "High Sorcerer Andromath of Stormwind wished to speak with a promising mage.",
    "Andromath greeted the visitor and hoped there was time to hear an old man's words.",
    "At the top of the Wizard's Sanctum, Andromath welcomed the mage.", 3)
q(1938, "Ur's Treatise on Shadow Magic", "MAGE", "Stormwind City", 28, MA,
    "Long ago one of three mages studying in the tower fell to the dark arts and was banished. He took Ur's Treatise on Shadow Magic to his new tower of Ilgalar in Redridge.",
    "The mages of Stormwind wanted Ur's Treatise on Shadow Magic back from the library in the tower of Ilgalar.",
    "Andromath had feared that Morganth had hidden the treatise or found a way to open it. The seals placed on it still held.",
    "Ur's Treatise came back to Andromath with its seals unbroken.", 4)
q(1940, "Pristine Spider Silk", "MAGE", "Stormwind City", 26, MA,
    "Andromath judged that an adept mage deserved a finer robe. The silk had to come from carrion recluse spiders in Duskwood, the most pristine only, for Wynne Larson to craft it.",
    "A new robe for the adept mage needed pristine spider silk from Duskwood, taken to Wynne Larson in the mage district.",
    "Wynne Larson liked the specimens and set straight to work on the robe.",
    "Wynne Larson took the pristine silk and began the robe.", 3)

q(2300, "SI:7", "ROGUE", "Stormwind City", 16, "class_rogue_si7",
    "Mathias's second in command at SI:7, Renzik, had been looking for the new rogue, and Keryn Sylvius advised against keeping him waiting.",
    "Keryn Sylvius passed on word that Renzik of SI:7 wanted to see the new rogue.",
    "Renzik asked whether the recruit was ready to work or needed a nap first.",
    "SI:7's Renzik the Shiv was ready to put the recruit to work.", 3)
q(2281, "Redridge Rendezvous", "ROGUE", "Redridge Mountains", 16, "class_rogue_si7",
    "Sending an untrained rogue into the field would be suicide, Renzik judged. Lucius, an SI:7 associate on the Lakeshire docks, would bring the recruit up to speed.",
    "Renzik sent the recruit to Lucius, who lingered on the Lakeshire docks with the other shady types.",
    "Fat fingers did not worry Lucius, who had turned worse thieves into accomplished rogues.",
    "On the Lakeshire docks, Lucius took on the new recruit.", 3)
for _, id in ipairs({3100, 3101, 3102, 3103, 3104, 3105, 1639, 1666, 1667, 1698, 1699, 1702, 1701, 1700, 1705,
    2998, 1649, 1650, 1651, 1652, 1939, 1938, 1940, 2300, 2281}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
end

-- World3 pass 2026-11-05, batch W3-C1: class referrals and trials asked for by the
-- starters3 lane (Dun Morogh, Ironforge, Thunder Bluff and the Undercity), Furen's
-- notes to Klockmort, the Alliance warlocks' road to Menara Voidrender (4737/4739
-- and the shared-title fallback belong to the horde pack), and the druid's
-- referrals to Moonglade. A referral reaches a trainer; it never claims a lesson,
-- a form or a spell. 1709 has no captured text and stays out.
q(4736, "In Search of Menara Voidrender", "WARLOCK", "The Barrens", 31, "horde_menara",
    "Briarthorn judged that the student had trained well without being corrupted, and deserved a reward. Staying in Strahad Farsan's tower above Ratchet, Menara Voidrender was not friendly but looked after hard workers.",
    "Word came from Briarthorn of Menara Voidrender, who helped promising students from a tower overlooking Ratchet.",
    "Menara Voidrender was pleased that Briarthorn's word reached so far. Their kind banded together regardless of race, she said, and she offered to help make tools of their craft.",
    "Menara greeted Briarthorn's student and offered help in making tools of power.", 3)
q(4738, "In Search of Menara Voidrender", "WARLOCK", "The Barrens", 31, "horde_menara",
    "Demisette did not think a novice was ready to help make items of power, but the decision was not hers. She pointed to Menara Voidrender in the tower above Ratchet.",
    "Demisette disapproved, but others had decided the student should hear of Menara Voidrender in Ratchet.",
    "Menara Voidrender was pleased that Demisette's word reached so far. Those they dealt with showed no mercy to the careless, she warned, and offered to help make tools.",
    "Menara greeted the student Demisette had sent and offered help in making tools of power.", 3)
q(1704, "Klockmort Spannerspan", "WARRIOR", "Ironforge", 28, W,
    "Furen Longbeard had copied his notes on the new armor techniques for Klockmort Spannerspan, a gnomish blacksmith in Ironforge. He expected Klockmort to pull off his own beard in excitement.",
    "Furen's notes from making armor were meant for Klockmort Spannerspan in Ironforge.",
    "Klockmort Spannerspan found the notes stupendous. Furen had made a real breakthrough, he said, and he could not wait to try it.",
    "Klockmort was thrilled with Furen's notes and eager to test the new technique.", 3)
q(1708, "Iron Coral", "WARRIOR", "Ironforge", 29, W,
    "Klockmort wanted to try Furen's technique on his own armor, and promised the piece to the one who had helped them both. He needed searing coral from the coast south of Menethil Harbor.",
    "Searing coral grew only south of Menethil Harbor, and Klockmort needed it to finish his armor.",
    "Klockmort Spannerspan had his searing coral and went off to smelt and hammer it with Furen's technique.",
    "Klockmort took the coral and began work, sure the armor would be very tough.", 3)
q(1679, "Muren Stormpike", "WARRIOR", "Ironforge", 10, W,
    "A warrior of Dun Morogh showed promise but still had tricks to learn, and Muren Stormpike in Ironforge's Hall of Arms was the one to teach them.",
    "A promising warrior was wanted in the Military Ward of Ironforge, where Muren Stormpike would show what the path meant.",
    "Muren Stormpike had heard the warriors of Dun Morogh mention the newcomer's name. He hoped not too much time had gone to the breweries.",
    "Muren greeted the warrior whose name was going around Dun Morogh.", 3)
q(1681, "Ironband's Compound", "WARRIOR", "Ironforge", 11, W,
    "Muren's mentor, Sturgy Ironband, had taught blacksmithing at a compound south of Helm's Bed Lake. Soon after a student brought him strange umbral ore, Dark Iron dwarves attacked and killed everyone there.",
    "His master had to be avenged, Muren said, and he wanted the load of umbral ore that had brought the Dark Irons to Ironband's compound.",
    "Muren Stormpike had the umbral ore and was eager to learn its properties. He feared the compound would not be the last place the Dark Irons struck.",
    "Muren had the umbral ore from his master's compound, and hoped a host of Dark Irons had fallen in the search.", 4)
q(1718, "The Islander", "WARRIOR", "The Barrens", 30, W,
    "A warrior's growing renown needed testing against peers. Fray Island, south of Ratchet, was where warriors met and fought, and Klannoc Macleod led them.",
    "The chief warrior of Fray Island, Klannoc Macleod, would judge whether the newcomer was worthy of the path ahead.",
    "Klannoc Macleod welcomed the warrior to Fray Island and hoped it would suit.",
    "Klannoc Macleod was glad to see the warrior had made it to Fray Island.", 3)
q(1840, "Orm Stonehoof and the Brutal Helm", "WARRIOR", "Thunder Bluff", 30, W,
    "Orm Stonehoof was greatly respected for his skill and could make the brutal helm. He worked in Thunder Bluff, near the pool by the great central totem.",
    "Thun'grim sent word to Orm Stonehoof in Thunder Bluff about a helm.",
    "Orm Stonehoof introduced himself. Thun'grim had told him a helm was wanted.",
    "Orm greeted the warrior Thun'grim had sent.", 3)
q(1844, "Chimaeric Horn", "WARRIOR", "Thunder Bluff", 30, W,
    "Orm would make the helm only for the worthy. A chimaera matriarch in the ashen Charred Vale of Stonetalon was mad with pain, and her galvanized horn would be the proof.",
    "To earn the brutal helm, Orm wanted the matriarch of the Charred Vale's chimaeras freed from her misery.",
    "Orm Stonehoof saw the horn as proof of worth and resolve. The helm would be made.",
    "Worth and resolve were shown, Orm said, and the helm would be made.", 4)
q(1879, "Speak with Bink", "MAGE", "Ironforge", 10, MS,
    "A gnome mage in Ironforge's Hall of Mysteries, Bink, had a task that only a mage could be trusted with.",
    "A fellow mage passed on word from Bink in Ironforge, who needed a mage for her task.",
    "Bink saw promise in the young mage, and warned that bad mages were part of the problem. Then she started from the beginning.",
    "Bink welcomed the new mage and began to explain the task.", 3)
q(1959, "Report to Anastasia", "MAGE", "Undercity", 15, MS,
    "The mages of the Undercity had noticed a magical disturbance in the city and called on Horde mages to investigate. More was known by Anastasia Hartwell in the Magic Quarter.",
    "A disturbance in the Undercity's magic had its mages calling for help, and Anastasia Hartwell knew more about it.",
    "Anastasia Hartwell confirmed the disturbance. Whether it was malign or benign was not yet known, and more information was needed.",
    "Anastasia explained that the origin of the disturbance was unknown, and set out the task.", 3)
q(27, "A Lesson to Learn", "DRUID", "Moonglade", 16, DW,
    "A young druid was ready to learn of a form that gave mastery of the water, and Dendrite Starblaze of the Cenarion Circle waited in Nighthaven.",
    "The next animal aspect concerned water, and Dendrite Starblaze in Moonglade would guide the lesson.",
    "Dendrite Starblaze explained that the aquatic form had to be earned through two trials. The first would test work under water, the second understanding of the form.",
    "In the aquatic form a druid moved freely through water, Dendrite said, but the form had to be earned before it was mastered.", 3)
q(6126, "Lessons Anew", "DRUID", "Moonglade", 14, DP,
    "Druids could purge poison with an incantation, but this lesson began with treating poisonings as a layman would, under Dendrite Starblaze.",
    "The lesson on poison and its cure would begin in Moonglade, with Dendrite Starblaze.",
    "Dendrite Starblaze explained that there would be no staged trial. Animal poisonings at the Crossroads were real, and the druid was to help.",
    "Dendrite sent the young druid to the Crossroads, where animals were being poisoned.", 3)
q(2997, "Tome of Divinity", "PALADIN", "Ironforge", 12, PW,
    "Younger paladins went to Tiza Battleforge in the Hall of Mysteries when it was time to learn more of the Light.",
    "One of the most respected paladins of Ironforge, Tiza Battleforge, was ready to see a young paladin from Dun Morogh.",
    "Tiza Battleforge greeted the paladin and wished that the Light would keep them safe.",
    "Tiza welcomed the young paladin upstairs in the Hall of Mysteries.", 3)
q(2999, "Tome of Divinity", "PALADIN", "Ironforge", 12, PW,
    "When there was time, a young paladin was to go upstairs to Tiza Battleforge, who taught the Light and what it expected.",
    "Upstairs, Tiza Battleforge was waiting for younger paladins ready to learn more.",
    "Tiza Battleforge welcomed the paladin and hoped the Light would show the true path.",
    "Tiza greeted the young paladin in the Hall of Mysteries.", 3)
q(3000, "Tome of Divinity", "PALADIN", "Ironforge", 12, PW,
    "A dwarven paladin abroad was called home to Ironforge, to Tiza Battleforge in the Hall of Mysteries.",
    "It was time to return to Tiza Battleforge, who taught younger dwarven paladins about the Light.",
    "Tiza Battleforge greeted the returning paladin and bade them welcome.",
    "Tiza welcomed the dwarven paladin back to Ironforge.", 3)
q(3681, "Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "Stormwind had asked paladins to report for training, and Duthorian Rall taught them in the Cathedral of Light.",
    "Word came that Stormwind wanted paladins for training, and Duthorian Rall taught them at the Cathedral of Light.",
    "Duthorian Rall welcomed the paladin to the Cathedral of Light.",
    "Rall greeted the paladin who had answered Stormwind's call.", 3)
-- Batch W3-C2: thin classes. The troll and night elf priests' summons home for
-- their racial rites (the completions only promise the teaching; 5674 has no
-- captured outcome and stays out), Rall's call to a paladin at forty (1661 stays
-- under the Nobility fallback, as above), and the Hidden Circle's first job for a
-- dwarf rogue.
P.threads.class_priest_rites = "the priest's rites of passage"
P.threads.class_rogue_circle = "the Hidden Circle's business"
local PR = "class_priest_rites"
q(5642, "Shadowguard", "PRIEST", "Orgrimmar", 20, PR,
    "The messengers who came looking for troll priests were usually casual, but this time they were in a hurry. Something important waited in the Valley of Spirits in Orgrimmar.",
    "Hurried messengers had come to Thunder Bluff looking for troll priests, so it was time to return to the Valley of Spirits.",
    "Ur'kyo said one of the most important rites of passage for a troll priest had come. The young priest was ready, and he would explain.",
    "Ur'kyo welcomed the troll priest back to the Valley of Spirits and promised to explain the rite ahead.", 3)
q(5643, "Shadowguard", "PRIEST", "Orgrimmar", 20, PR,
    "A troll priest's own tribe held rites of passage that taught abilities vital to survival. The time had come to speak with Ur'kyo in Orgrimmar's Valley of Spirits.",
    "A priest of another people sensed that a troll priest's rite was near, and sent them to Ur'kyo in Orgrimmar.",
    "Ur'kyo told the troll priest that an important rite of passage had come, and that they were ready to hear of it.",
    "Ur'kyo greeted the priest and began to explain the rite.", 3)
q(5673, "Elune's Grace", "PRIEST", "Darnassus", 20, PR,
    "Some things the trainers could not teach, among them the gifts Elune granted her faithful. It was time to return to the Temple of the Moon and Priestess Alathea.",
    "A night elf priest was called home to Darnassus, where Priestess Alathea would test the faithful of Elune.",
    "Priestess Alathea welcomed the priest's swift return. The order took this time seriously, and the next part of the training would follow after rest.",
    "Alathea blessed the returning priest in Elune's name and promised to discuss the path ahead.", 3)
q(5675, "Elune's Grace", "PRIEST", "Darnassus", 20, PR,
    "Word had come from Priestess Alathea for a night elf priest to come home to Darnassus for testing.",
    "A message from the Temple of the Moon said the priest was ready to be tested, much as those who served the Light were.",
    "Priestess Alathea thanked the priest for coming quickly. After rest, they would discuss where the training led next.",
    "Alathea welcomed the night elf priest back to the Temple of the Moon.", 3)
q(4486, "The Tome of Nobility", "PALADIN", "Stormwind City", 40, PN,
    "A fellow paladin, admittedly jealous of the deeds done, passed on word from Duthorian Rall. He wanted to see the paladin at the Cathedral of Light, and it sounded important.",
    "A summons from Duthorian Rall asked a seasoned paladin to come to the Cathedral of Light.",
    "Duthorian Rall said much had happened. Treacherous enemies were about, and he would seek help from a paladin who proved worthy.",
    "Rall welcomed the paladin back to the Cathedral and spoke of enemies he needed help to stop.", 3)
q(2238, "Simple Subterfugin'", "ROGUE", "Dun Morogh", 10, "class_rogue_circle",
    "The Hidden Circle felt the king should share the riches of his quarry, without the king knowing, and their man Onin MacHammar was hiding among the lepers near Gnomeregan.",
    "The Hidden Circle wanted a report from Onin MacHammar, who had hidden himself among the lepers by Gnomeregan.",
    "Onin MacHammar hushed his visitor at once, afraid they would be overheard.",
    "Onin was found among the lepers, and told the visitor to keep quiet.", 3)
for _, id in ipairs({5642, 5643, 5673, 5675, 4486, 2238}) do P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id end
for _, id in ipairs({4736, 4738}) do P.questIDs[id].threadLabel = "Menara Voidrender's students" end
for _, id in ipairs({4736, 4738, 1704, 1708, 1679, 1681, 1718, 1840, 1844, 1879, 1959, 27, 6126, 2997, 2999, 3000, 3681}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
end
for _, id in ipairs({4736, 4738}) do P.questIDs[id].source[3] = "LoreHordeStories.lua thread horde_menara and title fallback (4737, 4739); starters3 hand-off 2026-11-05" end

-- Shared-title outcomes are never copied from a convenient last stage. Several
-- Forever titles that look like trials are only referrals, notably 94007.
local shared = {
    ["The Tome of Divinity"] = true, ["The Tome of Nobility"] = true,
    ["A Lesson in Divinity"] = true, ["Taming the Beast"] = true, ["Training the Beast"] = true,
    ["The Touch of Zanzil"] = true, ["Alther's Mill"] = true, ["Garments of the Light"] = true, ["Divine Grace"] = true,
    ["Gakin's Summons"] = true, ["Creature of the Void"] = true, ["The Binding"] = true,
    ["Body and Heart"] = true, ["Trial of the Lake"] = true, ["Trial of the Sea Lion"] = true,
    ["Aquatic Form"] = true, ["Gathering the Cure"] = true, ["Curing the Sick"] = true,
    ["Power over Poison"] = true, ["Child of Nature"] = true, ["Lord Grayson Shadowbreaker"] = true,
    ["Vile Familiars"] = true, -- the horde pack owns this title's fallback (792 is Zureetha's own stage)
    ["Encrypted Letter"] = true, -- the world pack's neutral title context covers 3102 and Alterac's 511
    ["In Search of Menara Voidrender"] = true, -- the horde pack owns the neutral fallback (4736-4739)
    ["A Lesson to Learn"] = true, ["Lessons Anew"] = true, -- shared with 26 and 6121; neutral fallbacks below
    ["Shadowguard"] = true, ["Elune's Grace"] = true,
}
for _, e in pairs(P.questIDs) do if not shared[e.title] then P.quests[e.title] = e end end
local function fallback(title, id, w1, w2, a1, a2)
    local e = P.questIDs[id]
    P.quests[title] = {class = e.class, zone = false, level = e.level, importance = e.importance,
        thread = e.thread, threadLabel = e.threadLabel, covers = false,
        why = {w1, w2}, after = {a1, a2}, source = {"corpus_vanilla_quests.txt: all entries titled " .. title}}
    -- No guessed zone: the same title can span distant cities and factions.
end
fallback("Shadowguard", 5642,
    "A troll priest was called back to the Valley of Spirits in Orgrimmar for a rite of passage.", "Ur'kyo in Orgrimmar was waiting for a troll priest.",
    "The troll priest reached Ur'kyo in the Valley of Spirits.", "Ur'kyo had a rite of passage to explain.")
fallback("Elune's Grace", 5673,
    "A night elf priest was called home to the Temple of the Moon.", "Priestess Alathea in Darnassus was waiting to test a night elf priest.",
    "The priest returned to Priestess Alathea in Darnassus.", "Alathea had the next part of the training ready.")
fallback("A Lesson to Learn", 27,
    "A young druid was called to Moonglade to learn of another animal aspect.", "Dendrite Starblaze of the Cenarion Circle had a lesson waiting in Nighthaven.",
    "The druid reached Moonglade for the next lesson.", "Dendrite Starblaze had the young druid's next lesson ready.")
fallback("Lessons Anew", 6126,
    "A druid's lesson on poison began in Moonglade.", "Dendrite Starblaze in Moonglade had a lesson on poison and its cure.",
    "The young druid reached Dendrite Starblaze for the lesson on poison.", "The lesson on poison was ready to begin.")
fallback("The Tome of Divinity", 1642,
    "The paladin's lessons tested service to others as well as strength.", "The study of divinity was tied to practical acts of aid.",
    "Another part of the paladin's assignment was completed.", "The errand advanced the lessons in charitable service.")
fallback("Tome of Divinity", 1642,
    "A paladin trainer had called for a visit concerning further instruction.", "The next lessons required reporting to the trainer.",
    "The referral reached its destination, before the practical trials.", "The call for further instruction was answered.")
fallback("A Lesson in Divinity", 94427,
    "Tyr's Watch sought to serve fellow Forsaken despite their distrust of paladins.", "The lesson placed practical aid at the heart of the order's work.",
    "One part of the order's assignment was completed.", "The errand advanced Tyr's Watch's work among the Forsaken.")
fallback("The Tome of Nobility", 4485,
    "Further paladin instruction concerned Duthorian Rall at the Cathedral of Light.", "The cathedral's trainer had more to discuss with an experienced paladin.",
    "The exchange with the trainer was completed.", "Another step in the paladin's further instruction was finished.")
fallback("Taming the Beast", 6061,
    "The hunter's lessons concerned handling animal companions with care.", "Learning to work with beasts involved practical trials and guidance from trainers.",
    "One step in the taming lessons was complete.", "The training errand advanced the hunter's instruction.")
fallback("Training the Beast", 6081,
    "A tamed animal needed care as well as direction in battle.", "The master hunters taught how to sustain and train an animal companion.",
    "The lesson covered feeding, training and reviving a pet.", "The instruction added the care and recovery of an animal companion to its training.")
fallback("The Touch of Zanzil", 2607,
    "Doc Mixilpixil's help was needed with a poisonous affliction.", "The search for a remedy led to the doctor's cellar work.",
    "Another part of the medical errand was complete.", "The work toward a remedy advanced another step.")
fallback("Alther's Mill", 2282,
    "Alther's Mill stood beyond the road in troubled Redridge.", "The mill was a place for errands outside the town's protection.",
    "The assignment at the mill was completed.", "The work concerning Alther's Mill was finished.")
P.quests["Alther's Mill"].class = false
P.quests["Alther's Mill"].thread = false
P.quests["Alther's Mill"].threadLabel = false
fallback("Garments of the Light", 5624,
    "A wounded defender needed healing and fortification.", "The test for the order's garments took the form of practical aid.",
    "The defender received the requested spells, earning recognition from the trainer.", "The service to the wounded completed the test for the robe.")
fallback("Divine Grace", 94774,
    "Further priestly instruction awaited at the Cathedral of Light.", "The summons concerned another stage of the priest's training.",
    "The call for instruction was answered.", "The referral reached its destination, with further lessons still ahead.")
fallback("Gakin's Summons", 1685,
    "Gakin requested further training beneath the Slaughtered Lamb.", "The summons concerned the warlock instructor's next lesson.",
    "The summons was answered at Gakin's training place.", "The referral reached Gakin, before the next practical trial.")
fallback("Creature of the Void", 1473,
    "A stolen summoning text was needed for the voidwalker trial.", "The warlocks lacked the writings required for their next lesson.",
    "The stolen text was recovered for the preparations.", "The writings returned, while summoning and subduing a voidwalker remained a further task.")
fallback("The Binding", 1471,
    "The summoning trial required a demon to be overcome at a prepared circle.", "The warlock's teacher demanded practical mastery before further instruction.",
    "The summoned demon was overcome, completing the binding trial.", "The successful trial earned the trainer's acknowledgment.")
fallback("Body and Heart", 6001,
    "Lunaclaw guarded a Moonkin Stone where the strength required by the Claw was tested.", "The druid's trial concerned the strength of body and heart.",
    "The challenge was completed, opening the trainer's further instruction.", "Lunaclaw's trial was passed, and the trainer offered the next teaching.")
fallback("Trial of the Lake", 28,
    "The lake's fading bauble had to reach the Shrine of Remulos before its power failed.", "Lake Elune'ara supplied the object for a timed druidic trial.",
    "The bauble was used at the shrine, completing the lake trial.", "Tajarri acknowledged the successful trial before the sea lion's further lessons.")
fallback("Trial of the Sea Lion", 30,
    "The sea lion's pendant united emblems of agility and endurance.", "Both halves of the pendant were required for Dendrite's inspection.",
    "The pendant was assembled and the trial completed.", "Dendrite accepted the pendant, leaving final training to the druid's teacher.")
fallback("Aquatic Form", 31,
    "The completed pendant served as evidence of the trials in Moonglade.", "The aquatic lessons ended with a return to the druid's trainer.",
    "The trainer accepted the pendant and taught the aquatic form.", "The return completed the training in the aquatic aspect.")
fallback("Gathering the Cure", 6123,
    "A salve for sick wildlife needed curative ingredients.", "The remedy required gathering materials before treatment could begin.",
    "The ingredients were supplied for preparation of the salve.", "The remedy could be made, with treatment still a further task.")
fallback("Curing the Sick", 6124,
    "Prepared salve could help animals affected by the spreading poison.", "The druidic lesson required practical treatment of sick wildlife.",
    "The afflicted animals received the salve, earning the Circle's thanks.", "The Circle recognized the care given to the sick animals as service to nature.")
fallback("Power over Poison", 6125,
    "The practical antidote work prepared the way for lasting instruction against poison.", "The final return concerned a power beyond individually prepared salves.",
    "The trainer taught the power to cure poisonous afflictions.", "The completed practical lesson earned permanent instruction against poison.")
fallback("Lord Grayson Shadowbreaker", 7638,
    "A paladin ready for a charger was sent to Lord Grayson Shadowbreaker in Stormwind's Cathedral District.", "Lord Grayson Shadowbreaker knew the trial that would win a paladin's charger.",
    "Lord Grayson explained that a future charger had to be rescued from evil.", "Grayson Shadowbreaker set out the long trial for the charger ahead.")
fallback("Child of Nature", 94911,
    "The Cenarion Circle offered further knowledge to druids newly arrived from Zephras.", "A mainland trainer could introduce a visitor to the Circle's work.",
    "The introduction was made, opening the way toward further instruction.", "The referral reached a welcoming druid, before the journey to Moonglade.")

fallback("The Tome of Valor", 1649,
    "Duthorian Rall of the Cathedral of Light tested paladins by sending them to defend others.", "The test of valor began with a tome in Stormwind's Cathedral of Light.",
    "A step of the test of valor was done.", "The paladin's test of valor went on.")

-- band5060 (2026-11-06): the warlock's felsteed and the Orb of Orahil, the mage's robes and wand,
-- Tabetha's grudge, the rogue's cure at Tarren Mill, Torwa's toxin for druids.
local WF, WO, MW = "class_warlock_felsteed", "class_warlock_orahil", "class_mage_wand"
q(1798, "Seeking Strahad", "WARLOCK", "The Barrens", 30, WB,
    "It was time to learn the felhunter summoning, the trainer said, but the reagents and items for teaching it were not to hand. Strahad Farsan, another of the inner circle, kept his residence in the goblin port of Ratchet. Word of the warlock's coming would be sent ahead.", "The felhunter summoning waited with Strahad Farsan in Ratchet, and the trainer sent word ahead.",
    "Ah, of course, Strahad said, the latest prodigy. The real thing could not live up to the reputation, he feared, but no matter. After all, the warlock had come to learn, not to hear him make jokes to himself.", "Greeting the latest prodigy, Strahad joked at the gap between the reputation and the warlock before him, and turned to the lesson.")
q(2996, "Seeking Strahad", "WARLOCK", "The Barrens", 30, WB,
    "The trainer had taught skills in the past, but the time had come for another to teach. His name was Strahad, and he lived in Ratchet. Strahad was human, which was not to be mistaken for weakness, for he was powerful though small. He could teach more powerful summonings, and the warlock was ready for them. Above the port town, next to his tower, was where to find him.", "Strahad in Ratchet, human and powerful for all his size, could teach greater summonings, and the warlock was judged ready for them.",
    "It was a busy day in Ratchet, Strahad said. He enjoyed watching the toil of a port city, with so much mystery, so much adventure and so much ignorance. Seeing hatred in the warlock's eyes, he said it would be put to good use.", "Watching Ratchet's toil with pleasure, Strahad saw something like hatred in the warlock's eyes and promised to put it to use.")
q(3001, "Seeking Strahad", "WARLOCK", "The Barrens", 30, WB,
    "The trainer had taught skills in the past, but the time had come for another to teach. That was Strahad, in Ratchet, a human not to be mistaken for weak, nor for an enemy, at least for now. He was powerful and to be respected, and he could teach greater summonings the warlock was prepared for. His place was above the port town, next to the tower there.", "Strahad of Ratchet, human, powerful, and no enemy for now, had greater summonings to teach.",
    "It was a busy day in Ratchet, Strahad remarked, and he enjoyed the toil of a port city, with all its mystery, adventure and ignorance. The hatred he saw in the warlock's eyes would be put to good use.", "Hatred in the warlock's eyes pleased Strahad, who meant to put it to good use.")
q(3631, "Summon Felsteed", "WARLOCK", "The Barrens", 40, WF,
    "The trainer did not think the warlock prepared, but it was not the trainer's decision. Strahad felt otherwise, and it was his decision to make, this time. He wished to speak quickly, and was still above Ratchet in the Barrens, at his little tower with his acolytes.", "Against the trainer's judgment, Strahad wanted to speak with the warlock at his tower above Ratchet, and quickly.",
    "So the warlock had decided to grace his presence again, Strahad said, and how kind. His acolytes had wondered whether the warlock would ever show up, but he had told them there was no doubt. Where power was concerned, the warlock was drawn in like a moth to the flame.", "Strahad received the warlock with mock courtesy and a remark about moths and flames.")
q(4487, "Summon Felsteed", "WARLOCK", "The Barrens", 40, WF,
    "The trainer had sent a demon after the warlock to get attention, but the warlock had arrived first, and that was no matter. There had been talk lately of growing power, good for the warlock and possibly bad for others, but irrelevant. The point was that the warlock had proven worthy of a blessing of sorts. Strahad, met before, waited above Ratchet in the Barrens.", "Talk of the warlock's growing power had reached the trainer, who sent word of a blessing of sorts waiting with Strahad above Ratchet.",
    "How kind of the warlock to grace his presence again, Strahad said. His acolytes had wondered, but he had known that where power was concerned the warlock would come like a moth to the flame.", "A moth to the flame, Strahad called the warlock, and had told his acolytes as much.")
q(4488, "Summon Felsteed", "WARLOCK", "The Barrens", 40, WF,
    "So the warlock had seen fit to grace them with a presence, the trainer said, and how wonderful. No one was going to wait hand and foot on a pup, the trainer added. The warlock grew quickly in power but knew little of true knowledge and understanding, and without care that weak will would be overwhelmed by corruption. Now Strahad wished to speak at his tower overlooking Ratchet in the Barrens, and soon.", "The trainer called the warlock a pup with a weak will and passed on Strahad's wish to speak at his tower above Ratchet.",
    "Strahad greeted the warlock with mock courtesy. His acolytes had wondered whether the warlock would show, and he had told them that power drew the warlock like a moth to the flame.", "How kind of the warlock to come, Strahad said, and spoke of moths and flames.")
q(4489, "Summon Felsteed", "WARLOCK", "The Barrens", 40, WF,
    "The warlock was called over by name and told it would be short. Growing power had been acknowledged, and the time had come to be rewarded for it. Above Ratchet in the Barrens waited Strahad Farsan, perhaps remembered from before. He would have words, and it was best not to take long.", "Acknowledged for growing power, the warlock was sent to Strahad Farsan above Ratchet for a reward, and told not to dawdle.",
    "Strahad received the warlock with mock courtesy and a remark about moths and flames. His acolytes had wondered, he said, and he had not.", "So the warlock had decided to grace his presence again, Strahad said. It was kind, and no surprise where power was concerned.")
q(4490, "Summon Felsteed", "WARLOCK", "The Barrens", 40, WF,
    "Strahad would give a reward for patience and hard work. The ability to summon a felsteed would be much harder to come by in future, he warned. It would have to be earned, and not easily. For now, the power to summon such a creature was granted, to be used as the warlock saw fit.", "Strahad granted the summoning of a felsteed as a reward, warning that such power would be much harder to earn in future.",
    "Good luck, Strahad said. He looked forward to seeing the warlock in the future.", "With the felsteed's summoning granted, Strahad wished the warlock luck and expected to meet again.", 6)
q(4965, "Knowledge of the Orb of Orahil", "WARLOCK", "The Barrens", 35, WO,
    "Well, well, well, the trainer said, it was a pleasure to see the warlock growing in power. Menara Voidrender in the Barrens was the one to speak to now. The trainer had never met another expert in the creation of items, orbs specifically, that could imprison even a demon so easily. She was in Strahad's tower above Ratchet.", "Menara Voidrender in Strahad's tower above Ratchet made orbs that imprisoned demons, and the trainer judged the warlock ready for her.",
    "Ah, something more substantial, Menara said. That she could help with, if the warlock was truly prepared. It was a welcome change to see one of their kind seeking power in forms other than knowledge, and she asked whether the warlock felt ready.", "Power in forms other than knowledge was a welcome change, Menara said, and asked whether the warlock was ready.")
q(4967, "Knowledge of the Orb of Orahil", "WARLOCK", "The Barrens", 35, WO,
    "Still a fool, and still seeking the trappings of mortals, the trainer said with open arrogance, and laughed at how pathetic the warlock was. But it mattered not what the trainer thought, only what those willing to deal with the warlock thought. Against the trainer's better judgment, those with some portion of power felt the warlock deserved more. The one to speak to was Menara Voidrender, in the tower above Ratchet.", "With undisguised contempt, the trainer admitted that others with power judged the warlock worthy of more, and named Menara Voidrender above Ratchet.",
    "Ah, something more substantial, Menara said. That she could help with, if the warlock was truly prepared. It was a welcome change to see one of their kind seeking power in forms other than knowledge.", "Menara asked whether the warlock was ready for something more substantial, and called the wish a welcome change.")
q(4968, "Knowledge of the Orb of Orahil", "WARLOCK", "The Barrens", 35, WO,
    "The warlock had made it this far, the trainer said, truly astonishing. By now the corruption of channeling the arcane should have seeped into the very soul and brought madness. The trainer proposed to push further. In Strahad's tower above Ratchet, Menara Voidrender would guide a test of skill.", "Astonished the warlock was still sane, the trainer suggested a further push, a test of skill with Menara Voidrender in Strahad's tower.",
    "Something more substantial, Menara said. She could help, if the warlock was truly prepared, and she welcomed one of their kind seeking power in forms other than knowledge.", "Menara offered her help for a warlock truly prepared, and asked whether this one felt ready.")
q(4969, "Knowledge of the Orb of Orahil", "WARLOCK", "The Barrens", 35, WO,
    "Haha, the young warlock was doing very well, the trainer said, and given time infernals and dreadlords would bow. Until then the warlock had to rely on weapons forged by mortal hands. The warlock seemed prepared for another such creation, and Menara Voidrender near Strahad's tower overlooking Ratchet would speak when the warlock was ready.", "Infernals and dreadlords would bow one day, the trainer said, but for now Menara Voidrender near Strahad's tower had another mortal-forged creation to offer.",
    "Something more substantial was what the warlock sought, Menara said, and she could help if the warlock was truly prepared. Power sought in forms other than knowledge was a welcome change, and she asked whether the warlock felt ready.", "Menara asked only whether the warlock felt ready for something more substantial.")
q(1799, "Fragments of the Orb of Orahil", "WARLOCK", "Dustwallow Marsh", 40, WO,
    "Good, then they would begin, Menara said. First the warlock was to speak to her acolytes inside and choose one of their paths. Second came Desolace, for an Infernal Orb from one of the warlocks of the Mannoroc Coven. It was to be cleansed with the help of a mage named Tabetha deep in southern Dustwallow Marsh. She would aid them for the sake of their history together. Not until both were done was the warlock to come back.", "Menara's price was an acolyte's path chosen and an Infernal Orb from the Mannoroc Coven in Desolace, cleansed by the mage Tabetha in Dustwallow Marsh.",
    "So Menara had sent the warlock, Tabetha said. Fair enough, the warlock could stay as her guest for the time being. But the business must be pressing, perhaps a search for lost power, or perhaps she was mistaken. Perhaps corruption was not so far from the warlock after all.", "Tabetha took Menara's name as reason enough to play host, and wondered aloud how far corruption was from her guest.")
q(4961, "Cleansing of the Orb of Orahil", "WARLOCK", "Dustwallow Marsh", 40, WO,
    "A summoner's orb was where the taint came from, Tabetha said. The demon within had to be exorcised before the warlock could use it, which she could do easily. Her part was the easy one. The hard job was killing the demon once she released it. It had to be quick, or he would return to the orb and they would have to start over. Strongest spells were called for, potions handy, and a friend if there was one. It would not be pretty.", "Tabetha would draw the demon out of the Infernal Orb. Killing it before it slipped back in was the warlock's job, and not a pretty one.",
    "Nicely done, Tabetha said. The demon had been taught a lesson he would not soon forget, and the warlock had shown great power and skill. It was time to return to Menara with the cleansed orb and put it to good use. Perhaps their paths would cross again.", "The orb was cleansed and the demon beaten, and Tabetha sent the warlock back to Menara with it.", 5)
q(4962, "Shard of a Felhound", "WARLOCK", "The Barrens", 40, WO,
    "So the warlock had chosen to capture the soul of a felhound, the acolyte said, and that was good. A ruby would capture the creature's soul. Like spells already known, it was to be used when the creature was close to dying, and the felhounds of Desolace would do nicely. Afterward the captured spirit and the ruby were to go to Menara. Each choice was personal, the acolyte added, and overpowering an enemy was as strong a tactic as balance.", "The acolyte's ruby would take a felhound's soul in Desolace at the moment of its death, and spirit and ruby alike were for Menara.",
    "Ah, the spirit of a felhound, Menara said, and well done. When she had both the spirit and the cleansed orb she would merge the two, and not before.", "Menara took the felhound's spirit and waited for the cleansed orb before she would merge them.")
q(4963, "Shard of an Infernal", "WARLOCK", "The Barrens", 40, WO,
    "So the warlock had chosen to capture the soul of an infernal, the acolyte said, and that was good. An emerald would capture the creature's soul. Like spells already known, it was to be used when the creature was close to dying, and the infernals of Desolace would do nicely. Afterward the captured spirit and the emerald were to go to Menara. Each choice was personal, the acolyte added, and overpowering an enemy was as strong a tactic as balance.", "The acolyte's emerald would take an infernal's soul in Desolace at the moment of its death, and spirit and emerald alike were for Menara.",
    "Ah, the spirit of an infernal, Menara said, and well done. When she had both the spirit and the cleansed orb she would merge the two, and not before.", "Menara took the infernal's spirit and waited for the cleansed orb before she would merge them.")
q(4964, "The Completed Orb of Dar'Orahil", "WARLOCK", "The Barrens", 40, WO,
    "Menara would start at once on crafting the orb and infusing the new demon into it. When it was done the warlock could choose a staff or an orb. She had always thought it important to cater to a warlock's chosen weapon.", "The felhound's spirit and the cleansed orb went together under Menara's hands, to become a staff or an orb as the warlock chose.",
    "It was done, Menara said, and the choice was a staff for both hands or an orb that left room for a dagger or sword. Tackling a felhound had been a great feat, and the item would serve well. She expected to hear of further exploits.", "Finished, the Orb of Dar'Orahil came with Menara's praise for the feat of the felhound and a wish to hear of exploits to come.", 5)
q(4975, "The Completed Orb of Noh'Orahil", "WARLOCK", "The Barrens", 40, WO,
    "Menara would start at once on crafting the orb and infusing the new demon into it. When it was done the warlock could choose a staff or an orb. She had always thought it important to cater to a warlock's chosen weapon.", "The infernal's spirit and the cleansed orb went together under Menara's hands, to become a staff or an orb as the warlock chose.",
    "It was done, Menara said, and the choice was a staff for both hands or an orb that left room for a dagger or sword. Tackling the infernal had been a great feat, and the reward would fit nicely. She wished further success in the arts.", "Finished, the Orb of Noh'Orahil came with Menara's praise for the infernal's defeat and a wish for success in the arts.", 5)
q(1920, "Investigate the Blue Recluse", "MAGE", "Stormwind City", 16, MS,
    "A disturbance had been reported at the Blue Recluse tavern in the Mage Quarter, where strange invisible creatures wandered and a mana rift was feared. The tavern was to be investigated and the creatures captured. Made visible with the cantation of manifestation and subdued, they were to be taken in containment coffers. Coffers full and empty, and the cantation, were to come back.", "Invisible creatures haunted the Blue Recluse in the Mage Quarter, and a mage was sent to capture them in containment coffers.",
    "Very well done, the trainer said. The creatures would be studied, and with diligence and luck it would be learned how they had slipped into the world. Such work raised the mage's value to the society of mages.", "The captured creatures went to the trainer for study, and the young mage's value to the society of mages grew.")
q(1921, "Gathering Materials", "MAGE", "Stormwind City", 15, MS,
    "The mage had served fellow mages well, and it was time to don the wizard's robe. Wynne Larson could make it from linen, which was easy to find, and charged rift gems. The gems were known only from the dwarven workings at Silver Stream in Loch Modan, left in crates by the dwarven miners' league. Everything was to go to Larson Clothiers in the Mage District.", "A wizard's robe from Wynne Larson needed linen and charged rift gems from the miners' league crates at Silver Stream in Loch Modan.",
    "Great pieces of linen, Wynne said, and a fine robe could be made from them. Once the rift gems were woven in, it would be a garment fit for a mage.", "Linen and gems in hand, Wynne Larson promised a garment fit for a mage.")
q(1961, "Gathering Materials", "MAGE", "Undercity", 15, MS,
    "It was time to don the first mage's robes, a sign of station and a testament to worth. The mana gems for them came from the Dalaran mages of Silverpine. Their beliefs were similar, the trainer said, so killing them was somewhat distasteful, but if they lacked the strength to resist, they did not deserve their lives. Gems and linen went to Josef Gregorian at the Magic Quarter's tailor shop.", "Mana gems taken from the Dalaran mages of Silverpine, with linen, would make a Forsaken mage's first robes at Josef Gregorian's shop.",
    "Very good material, Josef said. He lacked the talent to gauge the mana gems' quality, but they would soon know whether they held the power to create spellfire robes.", "Josef Gregorian took the linen and gems and reserved judgment on the gems until the spellfire robes were tried.")
q(1943, "Speak with Deino", "MAGE", "Orgrimmar", 26, MW,
    "The troll mage Deino had need of assistance, and resided in Orgrimmar, in the Darkbriar Lodge.", "Deino of the Darkbriar Lodge in Orgrimmar had asked for a mage's help.",
    "Good, the mage had come, Deino said. Her task was not easy but vital to the society of mages, and aiding her would prove worthwhile.", "Hard and vital to the society of mages, Deino called her task, and worth the trouble.")
q(1947, "Journey to the Marsh", "MAGE", "Dustwallow Marsh", 38, MW,
    "It was time to earn the mage's wand, and the quest began with the human hermit Tabetha in Dustwallow Marsh. The shack lay deep in the marsh west of Theramore, just north of the Stonemaul Ruins. Her knowledge was vast, the trainer said.", "The mage's wand began with Tabetha, a hermit whose cottage stood west of Theramore in the marsh.",
    "Quiet, Tabetha said, for she was at a delicate juncture and must not be disturbed. She asked for one moment.", "Tabetha asked for a moment's quiet at a delicate juncture before anything else.")
q(1948, "Items of Power", "MAGE", "Dustwallow Marsh", 40, MW,
    "Building a mage's wand was not easy, Tabetha said. Rare substances were required, and a vessel that could store great quantities of magical energy. A parchment listed what was needed and how to get it. Everything had to be followed to the letter, or things might go badly when they made the wand.", "Tabetha's parchment listed the rare substances for the wand and the instructions that had to be followed exactly, or the making might go badly.",
    "Aha, Tabetha said, the jade was found and the bramble made, and well done. She noticed smoke rising from the mage's ears. Perhaps the mage had been too close when the lightning struck the totem sticks, but being hit by lightning was good luck.", "Smoke was rising from the mage's ears, Tabetha noticed; a lightning strike, she said, was good luck.")
q(1951, "Rituals of Power", "MAGE", "Dustwallow Marsh", 40, MW,
    "Now that she thought about it, Tabetha did not have her copy of Rituals of Power. Gambling debts had made her sell the last one to a member of the clergy, of the Scarlet Brotherhood. He must have taken it to the library in the Scarlet Monastery in Tirisfal Glades. Anyone who wanted it would have to go there, and she was sorry for the trouble. She was not herself those days.", "Tabetha had sold her last copy of Rituals of Power to pay gambling debts, and it had gone to the Scarlet Monastery's library in Tirisfal.",
    "That was it, Tabetha said, just what she needed to prepare the ritual for the wand. She hoped it had not been too much trouble to find.", "Rituals of Power came back from the monastery, and Tabetha could prepare the ritual.")
q(1955, "The Exorcism", "MAGE", "Dustwallow Marsh", 40, MW,
    "With a summoner's orb in hand, the demon within had to be exorcised, Tabetha said, and that she could do. It was the easy part. The hard job was killing the demon once it was out. It had to be quick, or the demon would jump back into the orb and they would have to start over. Strongest spells were called for, potions handy, and a friend if there was one. It would not be pretty.", "Tabetha would draw the demon from the summoner's orb. The mage had to kill it before it jumped back in, and it would not be pretty.",
    "Nicely done, Tabetha said. The demon had been taught a lesson he would not soon forget. He would think twice before sticking his ugly head back into the world to look for the mortal who beat him. Next time he would probably bring friends, big scaly ones who wanted nothing more than to tear that mortal to pieces. She hoped she had not scared anyone.", "Once the demon was beaten, Tabetha teased that it might come back with big scaly friends.")
q(1957, "Mana Surges", "MAGE", "Dustwallow Marsh", 40, MW,
    "They were almost finished, Tabetha said, and the last step was the most perilous. She had the empty summoner's orb and was ready to empower it by harnessing a mana rift. Her spell would open a rift for a time, and mana surges would pour out. As they were defeated their power would be released, and she would collect it. If enough mana surges died before the rift closed, all their energy would go into the orb.", "Tabetha's spell would open a mana rift. Then the mage had to kill enough of the mana surges that poured out for their power to fill the orb.",
    "It was done, Tabetha said, and she had never doubted for a second. Maybe for a second or two, she admitted, but basically she had not had much doubt, honestly.", "The orb was filled, and Tabetha swore she had hardly doubted at all.", 5)
q(2861, "Tabetha's Task", "MAGE", "Dustwallow Marsh", 46, "class_mage_tabetha",
    "Rumor had it that Tabetha, a mage colleague deep in Dustwallow Marsh, had a bone to pick with a certain sand troll in Zul'Farrak. She could say more. Friends were to be brought, since no one should go to Zul'Farrak alone. Her cottage stood west of Theramore, just north of the Stonemaul Ruins.", "Tabetha in Dustwallow had a bone to pick with a sand troll in Zul'Farrak, and wanted help picking it.",
    "That was right, Tabetha said, she had a bone to pick with a troll. In fact she had a few bones to pick, all of the troll's bones, and she wanted help.", "Every one of the troll's bones was owed, Tabetha said, and she asked for help.")
q(2479, "Hinott's Assistance", "ROGUE", "Hillsbrad Foothills", 26, RZ,
    "A sample of the mixture was to go to Serge Hinott in Tarren Mill. If anyone could cure the rogue, it was Serge, and anyone who lived long enough would learn the ways of poison from him.", "Serge Hinott in Tarren Mill was the one to cure Zanzil's mixture, and to teach poison to those who survived it.",
    "The rogue looked deliciously pale, Serge said, and gave off a foul aroma he had to know about.", "Pallor and stink alike delighted Serge, who wanted to know everything.")
q(2480, "Hinott's Assistance", "ROGUE", "Hillsbrad Foothills", 20, RZ,
    "Serge had never seen such wondrous results from a poison. He had never heard of Zanzil, but commended him on the concoction. Curing it came first and teaching its use second, and he asked for a few moments to examine the toxin.", "Serge Hinott examined Zanzil's toxin with admiration before curing it.",
    "The cure was ready, Serge said. His anti-toxin would stop the creeping madness, though he could do nothing about the smell.", "The anti-toxin stopped the creeping madness and left the smell, Serge said.")
q(9063, "Torwa Pathfinder", "DRUID", "Un'Goro Crater", 52, "class_druid_torwa",
    "A hunter named Torwa Pathfinder had asked for the help of a druid, saying only druids had the skills and the respect for nature he needed. He was close by the road from Tanaris as it entered Un'Goro Crater.", "Torwa Pathfinder wanted a druid's help, and waited where the Tanaris road entered the crater.",
    "The druid had traveled far to meet him, Torwa said, and not a moment too soon.", "Not a moment too soon, Torwa said of the druid's arrival.")
q(9052, "Bloodpetal Poison", "DRUID", "Un'Goro Crater", 52, "class_druid_torwa",
    "Torwa asked for help with a toxin of sorts to pacify a great creature living in the crater. It was not deadly, and only a druid's keen eyes could hope to collect its ingredients. Bloodcap mushrooms grew within the bloodpetal sprouts across the crater. Gorishi stings came from the giant flying wasps in and around the Slithering Scar to the south.", "Bloodcap mushrooms from the bloodpetal sprouts and Gorishi stings from the wasps of the Slithering Scar were Torwa's ingredients for a pacifying toxin.",
    "The ingredients at last, Torwa said. With the Un'Goro soil he had collected, the toxin was easily concocted.", "With his Un'Goro soil, Torwa mixed the toxin from the mushrooms and the stings.")
q(9053, "A Better Ingredient", "DRUID", "Un'Goro Crater", 52, "class_druid_torwa",
    "It was as Torwa feared. The toxin was simply too weak for so powerful a creature. A potent enough toxin needed a putrid vine from the guardian at the bottom of the Temple of Atal'Hakkar, past the secrets of the altar. The temple was dangerous, and friends should come.", "Torwa's toxin needed a putrid vine from the guardian at the bottom of the Temple of Atal'Hakkar to be strong enough.",
    "At last the toxin could be made in full, Torwa said. He dared not ask the druid to inflict it on the creature again, having asked too much already, and gave his thanks and respect.", "His toxin at full strength, Torwa would ask no more, and gave the druid his thanks and respect.", 5)
fallback("Seeking Strahad", 1798,
    "A warlock's trainer sent the warlock to Strahad Farsan in Ratchet for greater summonings.", "Strahad Farsan, above the port of Ratchet, taught the summonings a trainer could not.",
    "Strahad received the warlock in Ratchet.", "The warlock reached Strahad's tower above Ratchet.")
fallback("Summon Felsteed", 4490,
    "Strahad Farsan above Ratchet had a reward for a warlock whose growing power had been acknowledged.", "A warlock judged ready was sent to Strahad's tower above Ratchet.",
    "Strahad received the warlock at his tower.", "The matter of the felsteed went on at Strahad's tower.")
fallback("Knowledge of the Orb of Orahil", 4965,
    "A warlock's trainer judged the warlock ready for Menara Voidrender, who made orbs that imprisoned demons, in Strahad's tower above Ratchet.", "Menara Voidrender above Ratchet had something more substantial for a warlock grown in power.",
    "Menara was asked whether she could help.", "The warlock was sent on to Menara Voidrender.")
fallback("Gathering Materials", 1921,
    "A young mage's first robes needed linen and gems gathered for a tailor.", "The materials for a mage's robe were to be gathered.",
    "The tailor received the materials for the robe.", "The gathering for the mage's robe was done.")
fallback("Hinott's Assistance", 2479,
    "Serge Hinott in Tarren Mill could cure Zanzil's mixture and teach the use of poison.", "A rogue poisoned by Zanzil's mixture was sent to Serge Hinott in Tarren Mill.",
    "Serge Hinott examined the poisoned rogue.", "The matter of Zanzil's poison went on in Tarren Mill.")

-- Coverage is deliberately representative: class membership never selects these
-- entries on its own. Unwritten areas include most armor/weapon crafting chains,
-- priest racial spell quests without complete reward evidence, paladin epic-mount
-- stages, Rhok'delar and most advanced druid adventures. The 1661 source does not
-- name its reward; it remains under the safe Nobility fallback. Moonglade entry
-- quests and shaman trials are authored by their respective regional packs.
-- Forever additions carry the Forever label in the compendium (fact-check
-- request 2026-11-05; explicit list, never inferred from the ID range).
for _, id in ipairs({65597, 65603, 65604, 94006, 94007, 94013, 94050, 94427, 94434, 94435, 94436, 94438, 94440, 94441, 94774, 94792, 94793, 94863, 94864, 94911, 94912, 94978, 94979}) do
    assert(P.questIDs[id], "Forever label for a missing stage " .. id).setting = "Forever"
end
A.Lore.RegisterStoryPack("class-stories", P)
