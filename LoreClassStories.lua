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

-- The character's side of every class stage (DESIGN §3.0; POV-GUIDE, pov-class lane,
-- 2026-11-07). Class work is personal, so each stage is `solo` and told with "I" even
-- when someone was along. Written from the same quest text as why/after, by class and
-- level: a novice at the first trials, a known figure at the level-60 rites and mounts.
local POV = {
    -- Warrior
    [3100] = {act = "answered Llane's sealed letter at the abbey", giver = "Llane", solo = true,
        "{I} came back from the kobold camps to a letter sealed with the insignia of Llane, the abbey's warrior trainer, and went to find him. He told {me} to learn the lay of the land and to come back for training whenever {I} needed it, night or day.",
        "Llane had sent for {me} with a sealed letter, {my} first summons as a warrior. The Silver Hand had made the abbey fairly safe, he said, but its people still had troubles a warrior could help with."},
    [92532] = {act = "climbed the watchtower to Blademaster Ren", giver = "Blademaster Ren", solo = true,
        "A note from Blademaster Ren waited for {me} when {I} came back to the village, and {I} climbed the watchtower to find her. She spoke of a changing world that would need people willing to lead and protect others, and promised to train {me} as {I} grew.",
        "Blademaster Ren had asked for {me}, so {I} went up into the village watchtower with her note. {My} path as a warrior began there, with her warning that the journey ahead would be dangerous."},
    [1505] = {act = "sought out Veteran Uzzek south of Far Watch Post", solo = true,
        "{My} trainer said the truly great warriors were great students too, and sent {me} to find Uzzek, a veteran of many battles. {I} found him south of Far Watch Post, and he greeted {me} as a young one come for instruction.",
        "{I} went south of Far Watch Post, the orc garrison on the border of the Barrens and Durotar, to look for Veteran Uzzek. The old orc knew at once that {I} had come to learn."},
    [1498] = {act = "braved the thunder lizards of Thunder Ridge for Uzzek", giver = "Veteran Uzzek", solo = true,
        "Uzzek wanted proof that {I} could take a beating, so {I} went up to Thunder Ridge and hunted the lightning hides and thunder lizards for their singed scales. When {I} brought them back he began to teach {me} defense, tough skin and shrewd movement together.",
        "Warriors were the shield of the Horde, Uzzek said, and {I} had to prove {my} mettle before he would teach. {I} braved the thunder lizards of Thunder Ridge, brought back their singed scales, and learned from him how a warrior becomes a wall."},
    [1638] = {act = "went to Harry Burlguard at the Pig and Whistle", solo = true,
        "{My} trainer judged {me} competent but still young, and sent {me} to Harry Burlguard, an old veteran who kept to the Pig and Whistle in Old Town. Harry offered {me} a drink before any lesson, to see whether {my} gut could take the tavern's strongest.",
        "In Old Town {I} found Harry Burlguard at the Pig and Whistle, a veteran who could show {me} moves to keep {me} breathing longer. He offered {me} a few mugs of the tavern's strongest before any talk of teaching."},
    [1639] = {act = "asked Bartleby the drunk for his mug", giver = "Harry Burlguard", solo = true,
        "Harry wanted to see what moves {I} already had, and pointed {me} at Bartleby, the drunk at the end of the bar. {I} asked for his mug, and Bartleby jeered at {me} for a prissy thing who might break a nail.",
        "{My} test at the Pig and Whistle was to take a mug from Bartleby, who would never just hand it over, Harry said. The drunk mocked {me} and warned {me} to mind {my} nails."},
    [1640] = {act = "beat Bartleby in a tavern brawl", solo = true,
        "Bartleby swore {I} would have to pry the mug from his cold, dead fingers, so {I} fought him for it at the end of the bar. When he went down he admitted that {I} fought a lot tougher than {I} looked.",
        "{My} first brawl as a warrior came at the end of a bar. Bartleby would not part with his mug, so {I} beat him for it, and he allowed that {I} had more fight in {me} than he had thought."},
    [1665] = {act = "brought Bartleby's mug to Harry Burlguard", giver = "Harry Burlguard", solo = true,
        "Bartleby handed over his mug once he had finished what was in it, and {I} carried it back to Harry Burlguard. Harry had watched the fight, called {me} persuasive, and began {my} lesson.",
        "With Bartleby's empty mug {I} went back to Harry, who said the drunk had not wanted to part with it. The tavern test was over, and Harry started teaching {me} the moves he knew."},
    [1666] = {act = "called on Marshal Haggard at the Eastvale Lumber Camp", giver = "Harry Burlguard", solo = true,
        "Harry thought {I} still needed a decent weapon and sent {me} to Marshal Haggard, retired at the Eastvale Lumber Camp. The old soldier's eyes were failing, and he took {me} for a gnoll as {I} walked up.",
        "{I} went out to Eastvale to find Marshal Haggard, who had collected a lot of gear in his career. He asked {me} to step a little closer, wondering whether Burlguard had come himself."},
    [1667] = {act = "took Haggard's badge back from Dead-tooth Jack's camp", giver = "Marshal Haggard", solo = true,
        "Marshal Haggard had been tricked out of his old badge by Dead-tooth Jack, a Defias villain in a Stormwind tabard, so {I} went to Jack's camp to the south to get it back. Haggard let {me} pick from the weapons of his marshal days.",
        "{I} found the marshal's badge in Dead-tooth Jack's camp and brought it back before the Defias could use it to pass as a Stormwind official. Haggard rewarded {me} with a weapon he had kept in great shape."},
    [1679] = {act = "reported to Muren Stormpike in the Hall of Arms", solo = true,
        "{My} trainer said {I} showed promise but still had tricks to learn, and sent {me} to Muren Stormpike in the Hall of Arms. Muren had already heard the warriors of Dun Morogh bouncing {my} name around.",
        "In the Military Ward {I} found Muren Stormpike, the dwarf who would teach {me} what it meant to be a warrior. He hoped, he said, that {I} had not spent all {my} time in the breweries."},
    [1818] = {act = "reported to Deathguard Dillinger by the graveyard", solo = true,
        "Word came that Deathguard Dillinger had a job for a warrior willing to prove their worth to the Dark Lady's forces, and {I} reported to his post by the graveyard. He promised a mission that would test {my} skill and {my} resolve.",
        "{I} went to the west end of the village and found Deathguard Dillinger near the graveyard. His mission, he said, would test {me} in combat and in the defense of the Forsaken."},
    [1819] = {act = "freed Ulag the Cleaver from his seal and killed him", giver = "Deathguard Dillinger", solo = true,
        "The Forsaken had held Ulag the Cleaver captive, free of mind but still enthralled by the Lich King, and every attempt to break that hold had failed. {I} triggered the skull stone by the mausoleum, lifted his seal, and killed him.",
        "{I} stood ready by the mausoleum as the seal that bound Ulag the Cleaver lifted. He had been no minor agent of the Scourge, Dillinger said, and killing him proved {me} worthy of further instruction."},
    [1820] = {act = "offered Coleman Farthing a warrior's blade", solo = true,
        "Having proved {my} worth to the Dark Lady, {I} went to the Gallow's End Tavern to serve one of her subjects. Coleman Farthing wanted a warrior to be the instrument of his revenge, and promised that the reward would be twofold.",
        "In the tavern on the east side of the village {I} met Coleman Farthing, who had little money and a need for a warrior. His task, he said, would serve both him and the Forsaken."},
    [1681] = {act = "avenged Sturgy Ironband and carried off the umbral ore", giver = "Muren Stormpike", solo = true,
        "Muren's mentor Sturgy Ironband had been killed with all his students when Dark Iron dwarves came for a load of umbral ore. {I} went into his compound south of Helm's Bed Lake, fought the Dark Irons, and brought the ore back to Muren.",
        "{I} avenged Muren's old master in Ironband's compound and found the umbral ore that had drawn the Dark Irons there. Muren was eager to learn its properties, and feared the compound would not be the last place they struck."},
    [1821] = {act = "robbed the Agamand crypt of its heirlooms", giver = "Coleman Farthing", solo = true,
        "Coleman blamed the Agamands, his employers in life, for his death, and wanted their family heirlooms. {I} went into their crypt at the north end of the mills, past lurking Scourge and dead Agamands, and came back with a sword, an axe, a dagger and a mace.",
        "{I} robbed the Agamand crypt of its four heirlooms and brought them to Coleman Farthing. The last memory of the family had been stripped from their lands, he said, and the Agamands were truly no more."},
    [1698] = {act = "answered Yorus Barleybrew's challenge at the Lakeshire Inn", solo = true,
        "Yorus Barleybrew had challenged every able warrior of the Alliance, and {I} went to the Lakeshire Inn to take him up on it. He sat {me} down with a drink and told {me} to savor it, in case it was {my} last.",
        "A grand reward was promised to anyone who passed Barleybrew's trial, and {I} had grown sure enough of {my} blade to try. {I} found him at the inn by the lake, and he offered {me} a drink before saying more."},
    [1699] = {act = "ran the Rethban Gauntlet through the gnolls", giver = "Yorus Barleybrew", solo = true,
        "{I} took a swig of Barleybrew Scalder and ran for the Rethban Caverns, fighting through heaps of gnolls to the first fork and back. {I} made it inside the hour, and Yorus called three cheers for {me}.",
        "Barleybrew's gauntlet was a race against the hour, from the inn to the caverns in the northern foothills and back, with gnolls all along the way. When {I} came back in time, he called it well done."},
    [1702] = {act = "carried a cask of Scalder to Furen Longbeard", giver = "Yorus Barleybrew", solo = true,
        "Barleybrew kept his word, though the reward waited in the city. {I} carried a cask of his Scalder to Furen Longbeard in the Dwarven District, and the shieldsmith promised {me} a shield like no other.",
        "{I} brought Furen Longbeard a cask of Barleybrew Scalder and a request for a shield, a favor Yorus said the dwarf owed him. Furen took the cask gladly and said {I} would find no better shield anywhere."},
    [1701] = {act = "gathered the rare materials for Furen's fire hardened mail", giver = "Furen Longbeard", solo = true,
        "Furen Longbeard knew how to make extremely hard mail for anyone willing to do the legwork, and {I} took his list and went after the rare materials. When {I} came back with everything, he set to work on the armor.",
        "{I} brought back every material on Furen's list, though he had feared the chimaeras would eat {me} first. He was amazed, and started on the mail at once."},
    [1700] = {act = "delivered Furen's armor notes to Grimand Elmore", giver = "Furen Longbeard", solo = true,
        "Furen had copied his notes on the armor he made for {me}, and {I} took them to Grimand Elmore at the weapon shop, ready to duck. Grimand was outraged, having taught Furen everything he knew, yet something in the notes made him want to try it.",
        "{I} delivered Furen's notes to Grimand Elmore, a smith too proud to learn from the dwarf he had taught. He fumed over them, then admitted there was something there worth trying."},
    [1704] = {act = "carried Furen's notes to Klockmort Spannerspan", giver = "Furen Longbeard", solo = true,
        "{I} carried a copy of Furen's notes to Klockmort Spannerspan, a gnomish blacksmith. He found them stupendous, a real breakthrough, and could not wait to try the technique himself.",
        "Furen bet that Klockmort would pull off his own beard in excitement, and when {I} handed the gnome the notes he said they made his knees go all a-wobbly. Furen had made a real breakthrough, he said."},
    [1705] = {act = "took burning blood from the Nightbane worgen", giver = "Grimand Elmore", solo = true,
        "{I} went into Roland's Doom in Duskwood for burning blood from the Nightbane worgen and a burning rock from their leader, Gutspill. Grimand needed both to test Furen's technique on new armor, and was pleased with what {I} brought.",
        "To earn Grimand's armor, {I} hunted the Nightbane worgen in the Roland's Doom mine and took a burning rock from their leader, Gutspill. Grimand Elmore took the blood and the rock with a word of thanks and went off to his own work."},
    [1708] = {act = "gathered searing coral south of Menethil Harbor", giver = "Klockmort Spannerspan", solo = true,
        "Klockmort wanted to try Furen's technique on armor of his own, and promised it to {me} for helping them both. {I} gathered searing coral along the coast south of Menethil Harbor, and he went off to smelt and hammer it.",
        "Searing coral grew in only one place, the Wetlands coast below Menethil Harbor, and {I} brought back enough of it for Klockmort. The gnome was sure the armor would be very, very tough."},
    [1718] = {act = "crossed the shallows to Fray Island", solo = true,
        "{My} renown as a warrior was growing, and {my} trainer said it was time to stand against {my} peers. {I} crossed the sand bar shallows of the Merchant Coast to Fray Island, where warriors met to fight, and Klannoc Macleod welcomed {me}.",
        "Fray Island lay off the coast south of Ratchet, a place where warriors went to meet and fight. {I} crossed the shallows to find its chief warrior, Klannoc Macleod, who would judge whether {I} deserved more teaching."},
    [1719] = {act = "won the Affray on Fray Island", giver = "Klannoc Macleod", solo = true,
        "Klannoc would teach only those who passed the Affray, so {I} stepped onto the grate in the middle of the crowd. Twiggy Flathead sent his challengers at {me} one after another and then Big Will, and {I} beat them all within the time.",
        "{I} fought the Affray against the clock, challenger after challenger and then Big Will himself. When {I} came back to Klannoc Macleod, he said he was honored to teach so worthy a warrior."},
    [1840] = {act = "sought Orm Stonehoof for the brutal helm", solo = true,
        "Thun'grim sent {me} to Orm Stonehoof, a tauren greatly respected for his skill, who could make the brutal helm. {I} found him by the pool near the city's great central totem.",
        "{I} went to the pool by the great totem to meet Orm Stonehoof, whose skill was greatly respected. Thun'grim had already told him that {I} wanted a helm made."},
    [1844] = {act = "freed the chimaera matriarch of the Charred Vale from her misery", giver = "Orm Stonehoof", solo = true,
        "Orm would make the helm only for the worthy, and sent {me} to the Charred Vale in the northwest of Stonetalon. {I} freed the chimaera matriarch from her misery among the ashes and brought Orm her galvanized horn.",
        "The Charred Vale had once been green, Orm said, and now what lived there was mad with pain and despair. {I} slew the chimaera matriarch, and her horn showed him the worth and resolve he asked of a warrior."},
    [1712] = {act = "gathered what Bath'rah needed to summon Cyclonian", giver = "Bath'rah the Windwatcher", solo = true,
        "Bath'rah the Windwatcher had spent ages waiting for a champion who could bring down the wind lord Cyclonian, and he thought {I} might be that one. {I} gathered every item on his parchment for the summoning, and he called it proof of {my} strength and cunning.",
        "{I} brought Bath'rah the components of his spell, the proof he wanted that {I} could face Cyclonian. The Windwatcher was satisfied, but warned that the next stage would be even more perilous."},
    [1713] = {act = "defeated the wind lord Cyclonian", giver = "Bath'rah the Windwatcher", solo = true,
        "Bath'rah performed his ritual, and Cyclonian came at his call. {I} defeated the wind lord and took his whirlwind heart, the heart the Windwatcher had promised to bind into a weapon for {me}.",
        "When the Windwatcher summoned Cyclonian, {I} stood against the wind lord and brought him down. Bath'rah had the whirlwind heart at last, after ages of watching for the champion who could win it."},
    [8417] = {act = "found the troubled spirit of a fallen hero", solo = true,
        "{My} trainer had one more road for a warrior of {my} standing, to a troubled spirit in that ruined land who had once been a great hero of the Horde. He wished {I} could simply strike him down, he said, but it was not that simple.",
        "A warrior's honor did not die with the body, {my} trainer told {me}, and the spirit of a fallen hero was waiting. {I} found him in the wastes, and he said {I} had come to ease his pain."},
    [8423] = {act = "proved a warrior's strength against the helboars", giver = "the Fallen Hero", solo = true,
        "The Hero looked {me} over and set a test before any honorable task. As Rexxar was said to measure his blades on a helboar, he measured {my} strength on them, and {I} hunted the helboars until he was satisfied.",
        "{I} killed the helboars the Hero asked for, beasts whose burning spines left terrible scars. He wanted no proof, and said he could see the determination etched in {my} face."},
    [8424] = {act = "carried the Hero's wrath to the Shadowsworn", giver = "the Fallen Hero", solo = true,
        "The Shadowsworn's rituals tormented the Hero even in death, so {I} carried his wrath to them across the wastes. When {I} came back, he said {I} had already eased his pain and honored him.",
        "Through {me} the fallen Hero delivered his own message of pain to the Shadowsworn. {I} cut down their cultists, and he thanked {me} for the honor."},
    [8425] = {act = "took the voodoo feathers from the sunken temple's troll guardians", giver = "the Fallen Hero", solo = true,
        "{I} went down into the sunken temple and killed its six troll guardians, from Gasher to Loro, for the voodoo feathers they carried. With them the Hero could take shape long enough to give {me} the arms he had worn in life.",
        "The fallen Hero had no use for his weapons and armor now, and meant them for {me}. When {I} returned with the trolls' feathers, he felt the cold touch of steel again, if only for a moment."},
    -- Paladin
    [3101] = {act = "answered Brother Sammuel's sealed letter at the abbey", giver = "Brother Sammuel", solo = true,
        "{I} came back from the kobold camps to a letter sealed with Brother Sammuel's insignia, and went to meet the abbey's paladin trainer. He told {me} the Holy Light shone within {me}, plain to friend and foe, and that {I} should act as the symbol {I} had become.",
        "Brother Sammuel had sent for {me} with a sealed letter, and in the abbey he greeted {me} as a Knight of the Silver Hand. He would teach {me} more, he said, once {I} had gained some experience in the valley."},
    [1642] = {act = "studied the Tome of Divinity", giver = "Duthorian Rall", solo = true,
        "Duthorian Rall gave {me} the Tome of Divinity to study, and its lesson was that a paladin strove to be good in all actions. When {I} came back to the cathedral he judged {me} ready to be tested in patience and compassion.",
        "{My} first real lesson in the Light came from the Tome of Divinity. Compassion, patience and bravery meant as much to a paladin as strength in battle, Duthorian said, and {I} would prove it by helping those less fortunate."},
    [1643] = {act = "found Stephanie Turner in need of help", giver = "Duthorian Rall", solo = true,
        "{I} went looking through the city for someone of noble intent who needed help, and found Stephanie Turner. She called {me} luv, and told {me} that cloth and leather were scarce, which made it hard to dress the orphanage children.",
        "The test was to find someone pure of heart who relied on {my} kindness. Stephanie Turner, sewing for the orphanage while her husband sought help in Ironforge, was the one {I} found."},
    [1644] = {act = "brought linen to Stephanie Turner for the orphans", giver = "Stephanie Turner", solo = true,
        "Most of Stephanie's orphans had lost their families to the Scourge, and she had no time left to sew for them. {I} brought her linen cloth, and she thanked {me} again and again, glad to turn to the children's other needs.",
        "{I} gathered linen for Stephanie Turner so she could sew shirts and trousers for the orphans. It saved her a great deal of time, she said, and she asked the Light to be with {me}."},
    [1781] = {act = "carried the Symbol of Life to the wounded Gazin", giver = "Duthorian Rall", solo = true,
        "Duthorian trusted {me} with the Symbol of Life and sent {me} to his friend Gazin, who lay wounded by the cathedral altar. Gazin coughed, waved off the Symbol for now, and told {me} what had befallen him and his friend Henze.",
        "{I} carried the Symbol of Life to Gazin, who had barely escaped the Defias near Heroes' Vigil with his life. The priest could take care of him, he said, but Henze might still need {me}."},
    [1786] = {act = "raised Henze with the Symbol of Life on Heroes' Vigil", giver = "Gazin", solo = true,
        "Henze had held off the Defias mages on Heroes' Vigil so that Gazin could escape, and he had fallen there. {I} crossed to the island in Stone Cairn Lake, called on the Light through the Symbol of Life, and brought him back.",
        "On the island in Stone Cairn Lake {I} found Henze where the Defias spellcasters had left him, and raised him with the Symbol of Life. Not everyone could use it, he said, and it boded well that {my} own faith had empowered it."},
    [1787] = {act = "took the Defias papers from the mages on Heroes' Vigil", giver = "Henze Faulk", solo = true,
        "Henze was too weak to fight, so {I} went after the Defias papers on the island alone. Gazin was delighted to hear that Henze lived, and said the Light was with {me} for sure.",
        "{I} took the Defias papers from the mages on Heroes' Vigil, the proof Gazin and Henze had wanted for the king's advisors. Back at the cathedral {I} told Gazin that his friend was safe."},
    [1788] = {act = "learned the power of resurrection from Duthorian Rall", giver = "Gazin", solo = true,
        "Duthorian told {me} to take some pride in what {I} had done that day. Calling on the Light to bring back the dead, he said, made {me} ready for one of a paladin's greatest honors, and he taught {me} the power of resurrection.",
        "Gazin kept the Defias papers for the king's advisors and sent {me} on to Duthorian with word of Henze. Not everyone could use the Symbol of Life, he said, and from then on {I} could raise fallen companions as {I} had raised Henze."},
    [2997] = {act = "went up to Tiza Battleforge in the Hall of Mysteries", solo = true,
        "{I} had been busy helping the folk of Dun Morogh when word came to go up to the city and see Tiza Battleforge. {I} climbed to the Hall of Mysteries, where she greeted {me} and hoped the Light would show {me} the true path.",
        "Tiza Battleforge was the one young paladins went to when it was time to learn more of the Light. {I} found her upstairs in the Mystic Ward, and she wished that the Light would keep {me} safe from evil."},
    [2998] = {act = "answered Duthorian Rall's call to the Cathedral of Light", solo = true,
        "Brother Wilhelm had overheard Duthorian Rall saying kind things about {me}, and that it was time to put {me} to the test. {I} went to the Cathedral of Light, and Rall said {my} timing could not have been better.",
        "Word that Duthorian Rall had praised {me} sent {me} to the cathedral where he spent most of his time. He remarked on the beauty of the city and said {I} had come at a good moment."},
    [2999] = {act = "went upstairs to Tiza Battleforge", solo = true,
        "When {I} had time from helping the people of Dun Morogh, {I} went upstairs to see Tiza Battleforge, one of the most respected of {my} order. She greeted {me} and hoped the Light would show {me} the true path.",
        "Younger paladins went to Tiza Battleforge to learn what the Light expected of them, and {I} climbed the stairs to her. She asked the Light to keep {me} safe from evil."},
    [3000] = {act = "came home to Tiza Battleforge in the Mystic Ward", solo = true,
        "Word reached {me} on {my} travels that it was time to go home and see Tiza Battleforge in the Hall of Mysteries. Young dwarven paladins went to her to learn more of the Light, and she greeted {me} and bade {me} welcome.",
        "{I} returned to the Mystic Ward from {my} travels to speak with Tiza Battleforge, one of the most respected paladins of {my} home. She welcomed {me} as one more young paladin come to learn."},
    [3681] = {act = "reported to Duthorian Rall for training", solo = true,
        "Word had gone out for paladins to report to the cathedral for training, and {I} broke off {my} travels to answer. Duthorian Rall, who trained paladins there, welcomed {me} to the Cathedral of Light.",
        "Someone stopped {me} on the road with word from the city that paladins were wanted for training. {I} went to the Cathedral of Light and found Duthorian Rall, who welcomed {me} there."},
    [94427] = {act = "sought out Tanis Alderwood in the Trade Quarter", solo = true,
        "{My} mentor at Tyr's Watch said a paladin pursued good for its own sake, and that the Forsaken among them had to keep that grace. {I} went down to the Trade Quarter to find Tanis Alderwood, a beggar who pleaded with {me} not to hurt him.",
        "{I} sought out Tanis Alderwood in the Trade Quarter, a Forsaken in need of grace. He knew {me} for a paladin at once, and pleaded with {me} to leave him be."},
    [94434] = {act = "brought fresh cloth to wrap Tanis's wife", giver = "Tanis Alderwood", solo = true,
        "Tanis could not believe a paladin wanted to help a beggar, but his wife was falling apart, and the apothecaries were busy with the Dark Lady's business. {I} brought him fresh cloth to wrap her until they could stitch her back together.",
        "{I} found fresh cloth for Tanis Alderwood, enough to hold his wife together while she waited for the apothecaries. He thanked {me}, a paladin, for a kindness he had never looked for."},
    [94435] = {act = "carried Tanis's thanks back to Tyr's Watch", giver = "Tanis Alderwood", solo = true,
        "Tanis promised {me} a friend for life and asked {me} to carry his thanks to whoever had sent {me}. Back at Tyr's Watch {my} mentor said even small acts of service strengthened a paladin's bond with the Light, and gave {me} a symbol for what came next.",
        "The Dark Lady and many of her servants mistrusted {my} order, {my} mentor said, and only service would answer them. {I} brought back Tanis's thanks and received a Symbol of Life for the next task."},
    [94436] = {act = "carried the Symbol of Life to Deathguard Billmuth", solo = true,
        "The Symbol of Life stung {my} hands, the Light's pain on the flesh of the Forsaken, but it was still {my} guide. {I} carried it downstairs to Deathguard Billmuth, who admitted he was not proud to ask paladins for aid.",
        "{I} went down to Deathguard Billmuth with the Symbol of Life, a talisman whose touch hurt as the Light always hurt the Forsaken. The priests had waved him away, he said, and {I} might be his friend's only chance."},
    [94438] = {act = "raised Deathguard Falgan in Venomweb Vale", giver = "Deathguard Billmuth", solo = true,
        "Billmuth and Falgan had been scouting a Scarlet camp in Venomweb Vale when a snapped twig gave them away, and Falgan stayed behind so Billmuth could run. {I} found him there and raised him with the Symbol of Life.",
        "In Venomweb Vale {I} called on the Light through the Symbol of Life, and Deathguard Falgan stood up again. He had not seen such a symbol since before the war, he said, and told {me} the Scarlets were planning an attack."},
    [94440] = {act = "took the Scarlet deployment orders for the Deathguard", giver = "Deathguard Falgan", solo = true,
        "Falgan wanted the Crusaders' deployment orders so the Deathguard could prepare an ambush, and {I} took a copy from the satchels of the Scarlets in the vale. Billmuth thanked {me} for his friend's life and promised the crusaders a welcome they would not forget.",
        "{I} brought Billmuth a copy of the Scarlet orders from the vale. Many Forsaken mistrusted paladins, he said, but he would make sure others heard what {I} had done that day."},
    [94441] = {act = "received the gift of redemption from Danitha Morr", giver = "Deathguard Billmuth", solo = true,
        "{I} carried Billmuth's thanks to Danitha Morr, along with his word that the Deathguard would hear what Tyr's Watch had done. Danitha said she was proud to count {me} among them and gave {me} the gift of redemption, the power to raise fallen companions.",
        "Danitha Morr judged {me} ready for one of the Light's greatest blessings when {I} returned from the vale. She taught {me} redemption, to bring back fallen companions, and said that winning the hearts of {my} own people was worth every effort."},
    [1649] = {act = "petitioned Duthorian Rall for the test of valor", giver = "Duthorian Rall", solo = true,
        "The Tome of Valor likened bravery to a rare mineral, to be refined into an alloy that few blows could break. {I} went to Duthorian Rall to petition for the test of valor, and he warned {me} that it could cost {my} life.",
        "{I} had grown surer in the Light since the Symbol of Life, and asked Duthorian Rall to test {my} faith and courage. He welcomed the petition, but said the Church wanted its paladins worthy and knew what that could cost."},
    [1650] = {act = "went to protect Daphne Stilwell on the Longshore", giver = "Duthorian Rall", solo = true,
        "Duthorian sent {me} to the far end of the Longshore, where Daphne Stilwell lived alone while her husband Jordan was in Ironforge. She had already killed half a dozen Defias since sunup, and expected more any minute.",
        "{I} went out to the small house overlooking the sea to protect Daphne Stilwell from the Defias who had all but taken the coast. She took {me} for either a land thief or the Church's help, and settled on the second."},
    [1651] = {act = "held the Stilwell house against the Defias", giver = "Daphne Stilwell", solo = true,
        "Daphne fetched her gun from the house, and when the Defias came {I} made {my} stand beside her. There were more of them than before, and when they were beaten she said {I} had shown bravery in the face of overwhelming odds.",
        "{I} held the Stilwell house against the Defias, with Daphne and her gun at {my} side and the Light's blessings on {me}. She thanked {me}, and said she had never thought a paladin could handle so many at once."},
    [1652] = {act = "told Duthorian Rall that the Stilwells were safe", giver = "Daphne Stilwell", solo = true,
        "Daphne asked {me} to tell Duthorian that she was safe for now, so word could reach Jordan in Ironforge. Back in the cathedral Rall said the Stilwells had helped the Church greatly, and rewarded {my} valor.",
        "{I} returned to Duthorian Rall with the news that the Stilwell home would stand another day. He said protecting the couple was the least the Church could do, and gave {me} the reward for valor."},
    [4485] = {act = "returned to Duthorian Rall for further lessons", solo = true,
        "{My} trainer saw {my} faith still strong and sent {me} back to Duthorian Rall for further lessons, with a warning not to let pride undo {my} humility. Rall said much had happened lately, and that he would seek {my} aid against treacherous enemies if {I} proved worthy.",
        "{I} came back to the Cathedral of Light sent by a trainer who reminded {me} that {my} standing came from humility and hard work. Duthorian Rall had enemies to stop, he said, and needed help from someone worthy."},
    [4486] = {act = "answered Duthorian Rall's summons to the cathedral", solo = true,
        "A fellow paladin confessed to some jealousy of {my} deeds before passing on Duthorian Rall's summons. {I} went to the cathedral, and Rall told {me} that treacherous enemies were about and he would need {my} help if {I} proved worthy.",
        "Word reached {me} through a paladin who admitted envying what {I} had done, and it sounded important. Duthorian Rall welcomed {me} back to the cathedral and spoke of enemies he needed help to stop."},
    [8415] = {act = "answered Commander Valorfist's call at Chillwind Point", solo = true,
        "Commander Ashlam Valorfist had called for a paladin of purity and valor, and the call came to {me}. {I} went to Chillwind Point, where he greeted {me} and said it was time to see what {I} could do.",
        "By then {my} name carried weight in the cause of the Light, and {I} answered Valorfist's call at Chillwind Point. The commander received {me} with a test already in mind."},
    [8414] = {act = "carried scourgestones to High Priest Thel'danis", giver = "Commander Ashlam Valorfist", solo = true,
        "Valorfist called crusaders like {me} a welcome sight in those desolate reaches, and wanted scourgestones taken from the undead. {I} gathered a great many under {my} Argent Dawn commission and carried them to High Priest Thel'danis at Uther's Tomb.",
        "{I} brought High Priest Thel'danis a load of scourgestones at Uther's Tomb on Sorrow Hill. Cleansing them would draw undead from countless miles, he warned, but he did not fear for one so strong in the Light."},
    [8416] = {act = "brought an inert scourgestone to Valorfist", giver = "High Priest Thel'danis", solo = true,
        "Thel'danis purged the evil from the stones and gave {me} the single inert one Commander Valorfist needed for bathing the Scourge in righteous fire. {I} carried it back to Chillwind Point, and the commander said {I} had earned his trust.",
        "{I} brought Valorfist the inert scourgestone without asking what it was for. That, he said, earned his trust, and he could tell {me} more of his plan."},
    [8418] = {act = "slew the troll guardians of the sunken temple for a Holy Mightstone", giver = "Commander Ashlam Valorfist", solo = true,
        "To turn the scourgestones' evil against itself Valorfist needed a magic only the trolls of the sunken temple carried. {I} went down and killed Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro, and the commander honored {me} with a Holy Mightstone.",
        "{I} cleared the six troll guardians from the sunken temple for Commander Valorfist, who said their corrupt souls deserved no remorse. He had never doubted {me}, he said, and bestowed one of the Holy Mightstones."},
    [7638] = {act = "went to Lord Grayson Shadowbreaker to learn of the charger", solo = true,
        "{My} trainer said the time had come to learn what it would take to win {my} charger, and sent {me} to Lord Grayson Shadowbreaker in the Cathedral District. {I} would have to save {my} future companion, Grayson said, from the evil {I} had fought all {my} life.",
        "{I} had waited a long time for word of a charger, and at last {my} trainer sent {me} to Lord Grayson Shadowbreaker. The trial would test {me} in many ways, he said, and {my} time had come."},
    [7670] = {act = "sought Lord Grayson Shadowbreaker for the trial of the charger", solo = true,
        "At last the word came that {I} had long waited for, and {I} went to Lord Grayson Shadowbreaker to learn how a paladin wins a charger. He spoke of many obstacles ahead, and of a future companion held in the clutches of evil.",
        "Lord Grayson Shadowbreaker would guide {me} through the trial of the charger, {my} trainer said, and {I} sought him out in the Cathedral District. {My} stature was beyond simple tests, Grayson told {me}, and {my} time had come."},
    [7637] = {act = "paid High Priest Rohan for his exorcism censer", giver = "Lord Grayson Shadowbreaker", solo = true,
        "The trial began with sacrifice, and {I} went to High Priest Rohan for his exorcism censer. {I} gave him far more coin than a new censer would cost, and he blessed {me} for a gift that would also feed the city's needy.",
        "{I} paid High Priest Rohan well beyond the price of his old censer, the due sacrifice Grayson had asked of {me}. Rohan had blessed it thrice with fresh incense for {my} use, and {my} gold would help feed those most in need."},
    [7639] = {act = "brought Rohan's censer to Lord Grayson", giver = "High Priest Rohan", solo = true,
        "Rohan sent {me} off with his censer and his blessing, the same censer he had used in several exorcisms. Grayson accepted it as proof of {my} sacrifice and named the next test, judgment upon the tortured spirits of lands lost to the Light.",
        "{I} carried the exorcism censer back to Lord Grayson, and he was glad to see {me} so willing to sacrifice. Next {I} would show due judgment, he said, with the censer as {my} vessel."},
    [7640] = {act = "drove the tormented spirits out of Terrordale", giver = "Lord Grayson Shadowbreaker", solo = true,
        "Grayson added a pinch of tainted earth from Terrordale to the censer, and {I} went into the Eastern Plaguelands to find where green auras seeped from the ground. With the censer {I} drove out the tormented spirits, and Grayson praised the judgment {I} had rendered.",
        "In Terrordale the physical world buckled under the torment of the spirit realm, and {I} passed the Light's judgment on the spirits there. Back with Grayson {I} learned the true trial, to reclaim the spirit of a fallen charger that served the death knight Darkreaver."},
    [7641] = {act = "asked Grimand Elmore to make horse armor for the charger", giver = "Lord Grayson Shadowbreaker", solo = true,
        "A charger without proper armor was only a pack animal, Grayson said, and {I} went to Grimand Elmore in the Dwarven District for horse armor attuned to the spirit realm. Grimand had been expecting {me}, and warned that it would be neither cheap nor easy.",
        "{I} sought out Grimand Elmore, among the finest craftsmen living, for {my} charger's horse armor. He agreed to make it, and claimed none better could be found anywhere in Azeroth."},
    [7642] = {act = "gathered the rare goods for Grimand's horse armor", giver = "Grimand Elmore", solo = true,
        "Grimand needed runecloth, arcanite bars, Arthas' Tears and Stratholme holy water for the horse armor, and gold for his fee. {I} gathered it all, and he called {me} resourceful and set to finishing the work.",
        "{I} brought Grimand Elmore everything on his list, from runecloth for the lining to holy water from Stratholme, and paid his fee in gold. He had exactly what he needed, and turned to finishing {my} horse armor."},
    [7648] = {act = "brought Grimand's finished horse armor to Lord Grayson", giver = "Grimand Elmore", solo = true,
        "Grimand wiped his brow and called {my} horse armor some of his finest work, as good as the set he had made for Grayson's own charger. {I} took it to Grayson, who praised it but said it still needed a blessing from a fitting spirit.",
        "{I} brought the finished horse armor and Grimand's thanks to Lord Grayson, who said Grimand's craft only improved with age. A paladin's charger was no ordinary beast, though, so Grayson kept the horse armor until it could be blessed."},
    [7645] = {act = "paid Merideth Carlson for her manna-enriched horse feed", giver = "Merideth Carlson", solo = true,
        "The Silver Hand had once called Merideth Carlson mad for claiming she could feed spirit horses, and she wanted a paladin to pay. {I} brought her the Argent Dawn's Enriched Manna Biscuits and the gold she demanded, though {I} had never mocked her.",
        "{I} paid Merideth Carlson in biscuits and gold for wrongs others had done her, and it took her by surprise. She said she had misjudged {me} and offered more feed free of charge, though she kept the money."},
    [7643] = {act = "freed the Ancient Equine Spirit from Tendris Warpwood", giver = "Lord Grayson Shadowbreaker", solo = true,
        "Deep in the ruins the corrupt treant Tendris Warpwood held an ancient horse spirit, and {I} passed judgment on him. Then {I} offered the spirit Merideth's feed, and after a few mouthfuls it turned as if waiting for the horse armor on its back.",
        "{I} freed the Ancient Equine Spirit from Tendris Warpwood and soothed it with the manna-enriched feed. It nuzzled the container as it ate, then looked at {my} horse armor and offered its back."},
    [7644] = {act = "brought the blessed horse armor back to Lord Grayson", solo = true,
        "When {I} laid the armor on the horse spirit's back it glowed, the air thick with power for a moment, and then it was blessed. {I} carried it back to Grayson, who said it was ready to harness {my} charger once its redemption was done.",
        "{I} brought the blessed horse armor back to Lord Grayson, who was not sure whether Merideth or the treant had been the greater threat. One last item remained to be made, he said, before the great struggle."},
    [7646] = {act = "gave Grayson two diamonds for the Divination Scryer", giver = "Lord Grayson Shadowbreaker", solo = true,
        "Grayson would build a Divination Scryer around the censer from Terrordale, and he needed two diamonds as unlike as day and night, an Azerothian and a Pristine Black. {I} gave him both, {my} last worldly sacrifice for the trial.",
        "With {my} diamonds set in the scryer, Grayson told {me} where {my} trial lay. In the Great Ossuary of Scholomance the hollowed soul of a once-noble charger served as the steed of the death knight Darkreaver, and only {I} could redeem it."},
    [7647] = {act = "defeated Darkreaver and redeemed the fallen charger", giver = "Lord Grayson Shadowbreaker", solo = true,
        "In the basement of the Great Ossuary {I} used the scryer to call up the accursed spirits and judged them, and then Darkreaver came. {I} defeated the death knight, gave the charger back its judged soul, and laid the blessed horse armor on its back.",
        "When the death knight Darkreaver fell, the charger he had ridden looked at {me} with mournful eyes. {I} handed back its soul, life came into its gaze, and it nuzzled {my} hand, {my} own charger at last."},
    -- Hunter
    [92482] = {act = "went to Tai'ree Farsight in the middle of the village", solo = true,
        "When {I} came back from dealing with the vuldren, a note from Tai'ree Farsight sent {me} to the middle of the village. She told {me} that only the keenest senses and quickest reflexes thrived in the wilds, and that she saw her younger self in {me}.",
        "Tai'ree Farsight greeted {me} with a curt nod, then spoke of the hunter's way, a life full of danger. She believed {I} had what it took, but said the choice belonged to {me} alone."},
    [6061] = {act = "tamed an adult plainstrider with the taming rod", solo = true,
        "{My} trainer said the tauren grew closer to the Earthmother by besting mighty creatures, and that taming a beast was a step toward being one with nature. With the taming rod {I} tamed an adult plainstrider and practiced at its side.",
        "{I} took the taming rod out onto the plains and made an adult plainstrider {my} companion for a time. When {I} returned, {my} trainer said the Earthmother had sent signs that {I} had done well."},
    [6087] = {act = "tamed a prairie stalker with the taming rod", solo = true,
        "{My} trainer saw a fiery spirit in {me} and sent {me} after a prairie stalker, a wolf as swift and fearless as a hunter should be. {I} tamed it and fought beside it, learning to work as one, muscle to muscle.",
        "With the rod {I} won over a prairie stalker, and in the fights that followed {I} learned how a hunter and a beast become a team. The Earthmother judged {me} ready for the next lesson, {my} trainer said."},
    [6088] = {act = "tamed a swoop and learned to choose a beast", solo = true,
        "{My} last trial on the plains was a creature of the sky. {I} tamed a swoop and practiced with it at {my} side, and {my} trainer gave {me} the power to tame, call and dismiss a beast of {my} own choosing, with the Earthmother's blessing.",
        "The swoop was a difficult opponent, and taming one with the rod finished {my} lessons. {My} trainer had taught {me} all there was to teach, and gave {me} the skill to tame a companion of {my} own."},
    [6089] = {act = "learned the care of a pet from Holt Thunderhorn", solo = true,
        "Taming was only half the craft, so {I} went to Holt Thunderhorn, who had bested the most feared beasts of Azeroth. He taught {me} to train {my} pet, to feed it, and to revive it if it fell in battle.",
        "{I} sought out Holt Thunderhorn, a hunter with strong ties to the Earthmother and many beasts of his own. He judged {me} a young hunter worth teaching, and showed {me} how to care for and train a companion."},
    [6062] = {act = "tamed a dire mottled boar near Razor Hill", solo = true,
        "Gaining control of an animal took determination, {my} trainer said, and handed {me} a taming rod. {I} tamed a dire mottled boar near Razor Hill and fought with it at {my} side before going back for {my} next task.",
        "{My} first taming was a dire mottled boar, found close to Razor Hill. {I} practiced in battle with the boar beside {me}, and {my} trainer judged {me} ready for more."},
    [6083] = {act = "tamed a surf crawler off the Echo Isles", solo = true,
        "{My} next beast lived in the water, so {I} went out across from Sen'jin Village near the Echo Isles and tamed a surf crawler with the rod. A pet should be an extension of {my} own strength, {my} trainer said, and called {me} a swift learner.",
        "{I} turned from the land to the sea for a spirited crab called the surf crawler, and won it over with the taming rod. When {I} came back, {my} trainer said {I} had done well."},
    [6082] = {act = "tamed an armored scorpid and learned to choose a beast", solo = true,
        "The last beast {my} trainer set before {me} was the armored scorpid, a creature that strikes quickly and confidently, one a hunter should strive to emulate. {I} tamed it, and came back to learn how to tame, call and dismiss a pet of {my} own.",
        "{I} tamed an armored scorpid with the rod and practiced at its side, {my} final trial. {My} trainer had taught {me} all there was to teach, and gave {me} the power to choose a beast and make it {my} companion."},
    [6081] = {act = "learned the care of a pet from Ormak Grimshot", solo = true,
        "Taming was not enough on its own, so {I} went to Ormak Grimshot near the Hall of the Brave, one of the most revered hunters of the Horde. He taught {me} to train {my} pet, to feed it, and to revive it if it fell in battle.",
        "{I} sought out Ormak Grimshot by the Hall of the Brave, and he saw a young hunter in front of him. He gave {me} the skills to teach {my} pet and care for it, and promised to speak with {me} again later."},
    [6063] = {act = "tamed a webwood lurker with the taming rod", solo = true,
        "Nature was to be respected, {my} trainer said, never bent to obey {my} wishes. With the taming rod {I} tamed a webwood lurker and practiced at its side, and {my} trainer called {me} a fast learner.",
        "{My} first lesson in taming was a webwood lurker, one of the spiders of the forest. {I} won it over with the rod and learned to fight with it, and {my} trainer praised how quickly {I} learned."},
    [6101] = {act = "tamed a nightsaber stalker to the south", solo = true,
        "{My} trainer wanted {me} to see how different the beasts of nature were, and sent {me} south for a nightsaber stalker. {I} tamed one with the rod and practiced with it, and {my} trainer saw that {I} had understood the lesson.",
        "{I} tamed a nightsaber stalker to the south, one of the great cats of the forest. Balance between nature and oneself was a way of life for every night elf, {my} trainer said, and {I} had shown {my} commitment to it."},
    [6102] = {act = "tamed a strigid screecher and learned to choose a beast", solo = true,
        "After two creatures of the land, {I} went west for one of the skies, a strigid screecher, and tamed the owl with the rod. {My} trainer then gave {me} the power to tame a beast of {my} own, and told {me} to choose it with care.",
        "The strigid screecher was {my} last trial beast, a mighty owl that soared above the forest. {I} tamed it, came back, and learned to tame, call and dismiss a companion, with a warning that it would be with {me} for a long time."},
    [6103] = {act = "learned the care of a pet from Jocaste", solo = true,
        "{I} went to the city to see Jocaste, a stern hunter who was always pleased to see another rise through the ranks. She taught {me} to train {my} pet, to feed it, and to revive it if it fell.",
        "Jocaste called {me} a fledgling hunter and showed {me} how to care for a companion and teach it new skills. She told {me} always to respect the balance and to live in awe of the nature around {me}."},
    [6064] = {act = "tamed a large crag boar with the taming rod", solo = true,
        "{My} trainer wanted {me} to try out a few beasts before choosing one, and began with a large crag boar. {I} tamed it with the rod and practiced with it, and {my} trainer already had the next beast in mind.",
        "A burly crag boar was the first beast {I} won over with the taming rod. {My} trainer promised that {I} would try a few more before settling on one."},
    [6084] = {act = "tamed a snow leopard with the taming rod", solo = true,
        "After the crag boar {my} trainer offered {me} something with more finesse, and sent {me} south and east to the snow leopards. {I} tamed one with the rod and found it swifter and more agile than the boar.",
        "{I} tamed a snow leopard, a large white cat with a powerful fighter behind its beautiful coat. When {I} came back, {my} trainer said {I} would soon be able to choose any pet {I} liked."},
    [6085] = {act = "tamed an ice claw bear and learned to choose a beast", solo = true,
        "{My} last trial beast was an ice claw bear east of Kharanos, a companion of little more than brute strength. {I} tamed it with the rod, and {my} trainer gave {me} the power to tame, call and dismiss a pet of {my} own.",
        "{I} went east of Kharanos and tamed an ice claw bear, the last of the beasts {my} trainer had set for {me}. Back in the village {I} learned to tame a companion of {my} choosing, and {my} trainer told {me} to find a loyal pet."},
    [6086] = {act = "learned the care of a pet from Belia Thundergranite", solo = true,
        "{I} went to the Hall of Arms to find Belia Thundergranite, a friendly sort, and she called {me} a new recruit on the way to becoming a great hunter. She taught {me} to train, feed and revive {my} pet.",
        "Belia Thundergranite showed {me} how to teach a pet new skills and how to care for it. The key, she said, was to respect it and treat it well, and it would be {my} most loyal friend."},
    [94792] = {act = "tamed a Rockhide Boar in the forest", solo = true,
        "Everything was easier with a friend, {my} trainer said, but a companion had to be won with care for the balance of nature. {I} took the taming rod into the forest, tamed a Rockhide Boar, and practiced at its side.",
        "{My} first tamed beast was a Rockhide Boar, won over with the taming rod among the trees. When {I} came back, {my} trainer called {me} a fast learner."},
    [94863] = {act = "tamed a Gray Forest Wolf with the taming rod", solo = true,
        "With a boar already tamed, {I} went after a fiercer companion, a Gray Forest Wolf, and earned its trust with the rod. {My} trainer said {I} seemed quite in tune with the beast.",
        "The forest held fiercer companions than boars, and {I} sought out a Gray Forest Wolf to tame. Mindful of nature's balance, {I} won it over and proved {my} skill once more."},
    [94864] = {act = "tamed a Young Forest Bear with the taming rod", solo = true,
        "{My} final challenge in the forest was a Young Forest Bear, the burliest of its beasts. {I} earned its trust with the taming rod, and {my} trainer called it brave work.",
        "After the boar and the wolf, {I} tamed a Young Forest Bear, the mightiest companion {my} trainer had set for {me}. The lesson was meant to deepen {my} bond with beasts, and {I} had earned the trust of the burliest of them."},
    [94793] = {act = "learned the care of a pet from Isaac Chan", solo = true,
        "There was none better to teach {me} the care of a pet than Isaac Chan, a lifelong woodsman. He showed {me} how to train {my} companion, feed it, and revive it if it fell in battle.",
        "{I} sought out Isaac Chan, who called {me} a fledgling hunter and gave {me} the skills to train and guide a pet. He told {me} always to respect the balance and to live in awe of nature."},
    [94007] = {act = "went to Quel'ana Quickgale at the port of Valanaar", solo = true,
        "{I} had grown comfortable in the wilds of the highlands, and {my} trainer said it was time for an animal companion of {my} own. {I} went southeast to the port of Valanaar, where Quel'ana Quickgale was glad to see {me} and began the lessons.",
        "Beast taming was taught at the port of Valanaar, and {I} went there to find Quel'ana Quickgale. Quel'ana was most glad {I} had come, and the lessons began at once."},
    [94978] = {act = "tamed a Windsong Crawler by the water", solo = true,
        "Every hunter began by learning the bond between beast and master, and {my} first challenge lay in the rivers and lakes of the isle. {I} took the taming rod, won the trust of a Windsong Crawler, and heard that {I} had become adept already.",
        "{My} first tamed beast was a Windsong Crawler at the water's edge. Earning its trust with the rod was the start of {my} path toward mastery, {my} trainer said."},
    [94979] = {act = "tamed a Galestrider in the lowlands", solo = true,
        "After the river's crawler {I} went onto open ground in the lowlands, where the Galestrider runs like the wind. {I} earned the trust of one with the taming rod and came back so quickly that {my} trainer was impressed.",
        "{I} tamed a Galestrider, a winged hunter of the plains, and tested {my} skill on open ground. {My} speed impressed {my} trainer, who had sent {me} out to prove {my} readiness for the trials still to come."},
    [94013] = {act = "tamed a Vuldren Alpha in the Gustberry Lowlands", solo = true,
        "{My} last trial took {me} to the Gustberry Lowlands with the taming rod, to tame a Vuldren Alpha and prove {my} mastery. Quel'ana called {me} a fast learner, and offered to teach {me} how to forge a lasting bond with a companion.",
        "After two beasts {I} faced the last, a Vuldren Alpha of the lowlands, and tamed it. Now that {I} knew the basics, Quel'ana said, the deeper ways of the hunter could begin."},
    [94050] = {act = "learned the care of a pet from Quel'dora", solo = true,
        "The trainer's sister Quel'dora had no equal at teaching the care of beasts, and she gave {me} the skills to train {my} pet, to feed it, and to revive it in battle.",
        "{I} went to Quel'dora, who called {me} a fledgling hunter and showed {me} how to guide a companion and teach it new skills. She told {me} always to respect the balance and to live in awe of nature."},
    [8151] = {act = "answered Ogtinc's call for seasoned hunters", solo = true,
        "Ogtinc had called for seasoned hunters, and {I} answered, climbing the cliffs northeast of the Ruins of Eldarath to find him. The furbolg had left his tribe to aid the Cenarion Circle, and now meant to teach rather than hunt.",
        "{I} had become one of the seasoned hunters Ogtinc sent for, and found him on the cliffs above the Ruins of Eldarath. He offered to craft with {me} a hunter's charm of trophies from fallen prey, to remind {me} of past trials and triumphs."},
    [8232] = {act = "slew the green drake Morphaz for Ogtinc", giver = "Ogtinc", solo = true,
        "Ogtinc set {me} on a dangerous hunt for Morphaz, the green drake deep in the Temple of Atal'Hakkar. {I} brought back his tooth, which stood for the power a hunter finds in the company of others, and Ogtinc gave {me} a gift from his own hunting days.",
        "Morphaz was an enemy of many, and Ogtinc warned {me} not to face the drake alone. With the drake's tooth {I} came back to the cliffs, and Ogtinc said {I} had learned the old ways."},
    [7632] = {act = "returned an ancient leaf to Vartrus the Ancient", solo = true,
        "{I} came by a glowing green leaf, deeply veined and plainly from something ancient and powerful, and went looking for its owner. Vartrus the Ancient knew his own leaf at once, and offered an exchange of service between the ancients and {me}.",
        "The leaf {I} carried glowed bright green, and it led {me} to Vartrus the Ancient. Vartrus groaned, then praised its perfect condition and suggested that {I} serve the ancients and they serve {me}."},
    [7636] = {act = "hunted the Legion's disguised agents for Vartrus", giver = "Vartrus the Ancient", solo = true,
        "Vartrus gave {me} a piece of his bark whose inscriptions led to the disguised agents of the Burning Legion, demons that made nature wilt wherever they went. {I} faced each of them alone, since they would flee from a group, and brought back their heads.",
        "Alone, as Vartrus warned, {I} hunted the demonic corrupters who hid among the living, and turned their arrogance into misery. Vartrus rewarded {me} with a stave of the ancients, to join with the bowstring Stoma could make."},
    [7634] = {act = "brought Hastat the sinew of an adult blue dragon", giver = "Hastat the Ancient", solo = true,
        "Hastat, Ancient of Lore, could bind one of his leaves into a quiver unseen for ten thousand years, if {I} brought him sinew from an adult blue dragon. {I} did, and he blessed the quiver so that {my} arrows might strike true.",
        "{I} hunted an adult blue dragon for its sinew and carried it back to Hastat. He bound his leaf into a quiver for {me}, and asked that it guard {my} arrows from harm."},
    [7635] = {act = "brought Stoma the sinew of a mature black dragon", giver = "Stoma the Ancient", solo = true,
        "Stoma alone could enchant the string for a bow of Ancients, and he sent {me} to slay a mature black dragon for its sinew. {I} brought it back, and Stoma, finding it reeking of evil, set to cleansing it and laying on his enchantments.",
        "{I} took the sinew from the bones of a mature black dragon, the task Stoma called simple. It reeked of evil, he said, and he began to make it into a bowstring that would be almost indestructible."},
    -- Rogue
    [3102] = {act = "answered Jorik's sealed letter at the back of the abbey", giver = "Jorik", solo = true,
        "{I} came back from the kobold camps to a letter sealed with Jorik's insignia, and slipped round to the back of the abbey where he kept out of sight. He was glad few people had seen {me} come, and offered {me} training whenever {I} wanted it.",
        "Jorik, the abbey's quiet trainer of rogues, had sent for {me} with a sealed letter. Plenty of outfits would covet {my} skills, he warned, the king's spies and even the Defias, and no one should bully {me} into anything."},
    [92483] = {act = "found Akeri Duskblade in the watchtower", solo = true,
        "Akeri Duskblade had left a note for {me}, and {I} found him inside the village watchtower, eyeing {me} suspiciously. He almost had not heard {me} coming, he said, and almost would not be good enough beyond the grove.",
        "{I} went up into the watchtower to meet Akeri Duskblade, a shady fellow by the villagers' account. A rogue had to be a slender blade, silent and steady, he told {me}, or end up with a slit throat in a ditch."},
    [2205] = {act = "carried Keryn Sylvius's package to Mathias Shaw", giver = "Keryn Sylvius", solo = true,
        "Keryn Sylvius called {me} a fish and guessed that Mathias Shaw would take {me} for the cheese delivery, but gave {me} a package for him all the same. {I} ran it across the city, found Mathias, and he thought the search had been a strain on {me}.",
        "{My} introduction to the king's spies was a package for Mathias Shaw, carried for Keryn Sylvius. Mathias looked {me} over when {I} found him, and offered either Renzik's help to an inn or some work."},
    [2206] = {act = "stole the Defias shipping schedule from Jerod's Landing", giver = "Mathias Shaw", solo = true,
        "The Defias had taken Jerod's Landing south of Goldshire for their smuggling between Redridge and Westfall, and Mathias wanted the dockmaster's shipping schedule. {I} slipped into the dock house, took it from the Dockmaster's pockets, and brought it back.",
        "Should {I} be caught, the service would disavow all knowledge of {me}, Mathias said, and sent {me} to Jerod's Landing anyway. {I} came back with the shipping schedule, and he gave {me} a blade, astonished that Keryn had found a proper rogue."},
    [2238] = {act = "sought out Onin MacHammar among the lepers", solo = true,
        "The Hidden Circle valued valuables, and thought the king should share his quarry's riches without knowing it. {I} went to Onin MacHammar, hidden among the lepers by Gnomeregan, for his report, and he hushed {me} at once.",
        "{My} first errand for the Hidden Circle took {me} to the lepers outside Gnomeregan, where Onin MacHammar had hidden himself. He shushed {me} and called {me} a daft fool, afraid they would be overheard."},
    [2300] = {act = "reported to Renzik of SI:7", giver = "Keryn Sylvius", solo = true,
        "Keryn Sylvius warned {me} not to keep Mathias's second in command waiting, so {I} went straight to Renzik. He asked whether {I} wanted to get to work or take a nap first.",
        "Renzik had been looking for {me}, word came, and {I} found him in Old Town. Mathias's second in command wanted to put {me} to work, if {I} could stay awake for it."},
    [2281] = {act = "went to Lucius on the Lakeshire docks", giver = "Renzik", solo = true,
        "Renzik judged that sending {me} into the field yet would be suicide, and sent {me} to Lucius, an associate of the service on the Lakeshire docks. Lucius called {my} fingers a little fat, and promised to make a rogue of {me} anyway.",
        "{I} found Lucius hanging around the Lakeshire docks with the other shady types. He had turned more useless thieves than {me} into accomplished rogues, he said, and took {me} on."},
    [2282] = {act = "cracked Lucius's training chest at Alther's Mill", giver = "Lucius", solo = true,
        "Lucius had kept a training chest up at Alther's Mill for years, and wanted the token inside. {I} picked the lock, though orcs had been nosing around the mill, and earned {my} Certificate of Thievery.",
        "Only after {I} had set off for Alther's Mill did Lucius mention the orcs. {I} cracked his chest open anyway and brought back the token, and he said that if {I} died now it would be from stupidity, not inexperience."},
    [2360] = {act = "made contact with Agent Kearnen near the Defias tower", giver = "Mathias Shaw", solo = true,
        "Mathias's scouts had seen heavy Defias activity at an abandoned watchtower southeast of Sentinel Hill, and Mathias sent {me} to Agent Kearnen for a debriefing. {I} found her hidden near the tower, and she had bad news waiting.",
        "Once again the service would disavow {me} if caught, and {I} crept down to the tower the Defias held southeast of Sentinel Hill. Agent Kearnen was glad Mathias had finally sent backup, and warned {me} the news was bad."},
    [2359] = {act = "stole the Defias writings from Klaven's Tower", giver = "Agent Kearnen", solo = true,
        "Agent Kearnen had watched a shipment from Duskwood arrive at the tower with guards that were not human. {I} took the key from the spiked zombie, got into the tower, and carried what was in the chest to Mathias.",
        "{I} stole into Klaven's Tower past the abominations and found writings in the chest they guarded. Mathias read in them that the Zanzil trolls of Stranglethorn could raise the dead with poison, and said {I} would need to understand poisons to be of any use to the service."},
    [2607] = {act = "sought a cure from Doc Mixilpixil for Zanzil's poison", solo = true,
        "{I} had brought back more than Mathias expected, a poison of Zanzil's working in {me}, and he sent {me} down to the cellar to Doc Mixilpixil. The doctor took {me} for the cheese delivery.",
        "Mathias had no cure for the poison {I} carried, so {I} went down to the cellar to find Doc Mixilpixil. The doctor told {me} to put the cheese on the table and skedaddle."},
    [2608] = {act = "gave Doc Mixilpixil a blood sample", giver = "Doc Mixilpixil", solo = true,
        "Doc Mixilpixil said {I} looked worse than death, and had {me} lie down on the cellar floor so he could draw blood. When the phlebotomy was done he called Dr. Montgomery and Mr. Noarm into conference.",
        "{I} lay down for the doctor's needle, which he promised only hurt the first fifty times or so. Then he went to confer with his colleagues about what ailed {me}."},
    [2609] = {act = "gathered the reagents for the doctor's cure", giver = "Doc Mixilpixil", solo = true,
        "The doctor's verdict was unanimous, the itis, and his cure needed wildflowers, a leaded vial, a bronze tube and chartreuse thread from The Finest Thread. {I} gathered it all, and he gave {me} a medicine to spray on.",
        "{I} went around the city's shops for the doctor's reagents, trying not to touch anyone on the way. Doc Mixilpixil devised his cure on the spot, a fantastic smelling spray, and promised {I} would be as good as new."},
    [2479] = {act = "carried Zanzil's mixture to Serge Hinott in Tarren Mill", solo = true,
        "If anyone could cure {me}, it was Serge Hinott, so {I} carried a sample of Zanzil's mixture to Tarren Mill. Serge said {I} looked deliciously pale, and wanted to know everything about the foul aroma {I} gave off.",
        "{I} took a sample of the mixture to Serge Hinott, the one who could cure it and teach the ways of poison to anyone who lived long enough. {My} pallor and {my} smell delighted him."},
    [2480] = {act = "took Serge Hinott's anti-toxin for Zanzil's poison", giver = "Serge Hinott", solo = true,
        "Serge Hinott had never heard of Zanzil, but he commended the poison's wondrous results before curing it. His anti-toxin stopped the creeping madness in {me}, though he could do nothing about the smell.",
        "{I} waited while Serge examined Zanzil's toxin, cure first and lessons in poison after. When he was done he gave {me} an anti-toxin that ended the creeping madness and left only the stink."},
    [8233] = {act = "answered Lord Ravenholdt's secret summons", solo = true,
        "Lord Jorach Ravenholdt had summoned {me} on a secret matter, and {I} found the path in the mountains northwest of Durnholde Keep to his manor. He welcomed {me} three times over, offered {me} a seat, and asked {me} to recover something dear he had lost, at any cost.",
        "By then {my} skills were known even at Ravenholdt Manor, where a summons came with no explanation but secrecy. Lord Ravenholdt wanted back something he had lost, and promised {me} something very nice for it."},
    [8234] = {act = "took back Ravenholdt's blue bag from a Timbermaw shaman", giver = "Lord Jorach Ravenholdt", solo = true,
        "Ravenholdt's small blue bag had been stolen by thieves now dead, who had sold it to a Timbermaw shaman as a holy relic. {I} took it back from the shaman and carried it to Archmage Xylem, who wanted to know why {I} had not said so sooner.",
        "{I} tracked down the Timbermaw shaman who had bought Ravenholdt's bag as a relic and came away with it. Archmage Xylem recognized it at once as Lord Ravenholdt's."},
    [8235] = {act = "gathered Xylem's encoded fragments from the forest oozes", giver = "Archmage Xylem", solo = true,
        "Xylem needed his destroyed writings on dispelling to lift the bag's enchantment, and their fragments had ended up inside the forest oozes of the northeast. {I} killed oozes until {I} had enough, and Xylem allowed that {I} might not be worthless after all.",
        "{I} hunted forest oozes in the northeast for the encoded fragments they had picked up, since they took in just about anything. Xylem looked them over and called them some of the better ones."},
    [8236] = {act = "took the azure key from the green drake Morphaz", giver = "Archmage Xylem", solo = true,
        "The key to Ravenholdt's bag lay with Morphaz, the green drake deep in the Temple of Atal'Hakkar, and {I} went down into the sunken temple after it. Lord Ravenholdt had thought it lost forever, and gave {me} an enchanted garment kept for rogues of exceptional skill and loyalty.",
        "{I} brought the key from Morphaz's lair back to Ravenholdt Manor, where the bag had already arrived from Xylem. Ravenholdt declared that no one should trifle with {me}, and let {me} choose a garment from his stores."},
    -- Priest
    [3103] = {act = "answered Priestess Anetta's sealed letter at the abbey", giver = "Priestess Anetta", solo = true,
        "{I} came back from the kobold camps to a letter sealed with Priestess Anetta's insignia, and found her expecting {me}. The Light shone on the path {I} had chosen, she said, and in harsh times it fell to {me} to aid as many as {I} could.",
        "Priestess Anetta had sent for {me} with a sealed letter, sure that {I} would find {my} way to her. She told {me} to go with compassion in {my} heart and let wisdom guide {me}, and to come back for her teaching as {I} grew."},
    [5622] = {act = "went to Laurna Morninglight in Dolanaar", giver = "Shanda", solo = true,
        "When {my} business in Shadowglen was done, Shanda sent {me} down to Dolanaar to Laurna Morninglight, who would teach {me} more of Elune's ways. Laurna was happy to see {me}, and said teaching young priests gave her great satisfaction.",
        "{I} left Shadowglen for Dolanaar with Shanda's wish for {my} safety, to earn {my} first garments as a servant of Elune. Laurna Morninglight welcomed {me} there and took up {my} instruction."},
    [5621] = {act = "healed and fortified Sentinel Shaya", giver = "Laurna Morninglight", solo = true,
        "Laurna could not leave her students, so she sent {me} south of Dolanaar to Sentinel Shaya, who had been hurt on patrol. {I} healed her wounds and fortified her body with {my} spells, and Laurna gave {me} a robe of the order.",
        "{My} duty to Elune that day was Sentinel Shaya, wounded south of the village. {I} mended her and fortified her body, and Laurna said {I} had earned {my} place among the order."},
    [5624] = {act = "healed and fortified Guard Roberts by the lake", giver = "Priestess Josetta", solo = true,
        "Instead of her usual test, Priestess Josetta sent {me} to Guard Roberts, lying hurt near the lake east of town. {I} healed him and fortified his body, and she gave {me} {my} first robe of the order.",
        "{I} found Guard Roberts wounded by the lake and mended him with the Light, then strengthened him with Fortitude. One more healthy guard made the town safer, Josetta said, and she was glad to see {me} using {my} gifts wisely."},
    [5625] = {act = "healed and fortified Mountaineer Dolf", giver = "Maxan Anvol", solo = true,
        "Maxan had more pressing matters than a formal test, so he sent {me} to Mountaineer Dolf, hurt just south of Kharanos. {I} healed Dolf and gave him Fortitude, and Maxan said {I} had the Light inside {me} for sure.",
        "{I} found Mountaineer Dolf wounded outside town and mended him with the Light, then fortified him against more blows. Maxan gave {me} a robe of the church, and told {me} there would be more tests later."},
    [5650] = {act = "healed and fortified Deathguard Kel", solo = true,
        "{My} order drew its power from darkness and shadow, but before knowing the dark {I} had to know the light. {I} healed Deathguard Kel north of the cemetery, fortified him for his return to duty, and passed the test with ease.",
        "Deathguard Kel had held off gnolls for a long time and needed healing, and {I} mended him north of the cemetery. {My} trainer gave {me} a robe of {my} station, and spoke of darker powers that lay ahead for {me}."},
    [94774] = {act = "went to High Priestess Laurena at the Cathedral of Light", solo = true,
        "{I} had caught the attention of {my} superiors, and they sent {me} to the Cathedral of Light to find High Priestess Laurena. She was glad {I} had come, and said {my} training in the ways of the Light came before anything else.",
        "Summoned to the cathedral, {I} found High Priestess Laurena waiting with lessons that every servant of the Light had to learn. There was much to discuss, she said, and the teaching began."},
    [5642] = {act = "hurried back to Ur'kyo in the Valley of Spirits", solo = true,
        "The messengers who came looking for troll priests were usually casual, but this time they hurried, so {I} left Thunder Bluff for the Valley of Spirits. Ur'kyo told {me} that one of the most important rites of a troll priest's faith had come, and judged {me} ready.",
        "Hurried messengers called {me} back to the Valley of Spirits, and {I} did not dally. Ur'kyo was waiting with word of a rite of passage, and said he would explain it now that {I} had come."},
    [5643] = {act = "returned to Ur'kyo for a troll priest's rite", solo = true,
        "A priest of another people sensed that {my} tribe's rite of passage was near, and sent {me} back to Ur'kyo in the Valley of Spirits. Ur'kyo greeted {me} and said the time of one of {my} faith's most important rites had come.",
        "Troll priests learned abilities vital to their survival through the rites of their tribe, and {I} went to the Valley of Spirits to learn {my} own. Ur'kyo judged {me} ready and began to explain."},
    [5673] = {act = "returned to Priestess Alathea in the Temple of the Moon", solo = true,
        "Some things {my} trainers could not teach, among them the gifts Elune gave her faithful, so {I} went home to the Temple of the Moon. Priestess Alathea blessed {me} for returning so quickly, and told {me} to rest from the journey before the next part of {my} training.",
        "{I} returned to Priestess Alathea in the Temple of the Moon to be tested in Elune's teachings. The order took this time very seriously, she said, and the path ahead would be discussed once {I} had rested."},
    [5675] = {act = "answered Priestess Alathea's call home", solo = true,
        "Word came from Priestess Alathea calling {me} home for training, much as those who served the Light were tested. {I} went to the Temple of the Moon, and she blessed {me} for coming so quickly.",
        "{I} heeded the message and set out for the Temple of the Moon, where Priestess Alathea waited. She said this was an important time in {my} training, one the whole order took seriously."},
    [8254] = {act = "answered the Cenarion Circle's need at Ogtinc's cliffs", solo = true,
        "It was the way of the divine to help those in need, {my} trainer said, and the Cenarion Circle had such a need. {I} climbed to Ogtinc's cliffs northeast of the Ruins of Eldarath, and the furbolg said {my} arrival lifted a weight from his shoulders.",
        "{My} faith had carried {me} a long way by then, and {my} trainer sent {me} when the Cenarion Circle needed help. Ogtinc welcomed {me} on his cliffs above Eldarath and said there was much to do."},
    [8255] = {act = "hunted mosshoof coursers for their glands", giver = "Ogtinc", solo = true,
        "The mosshoof coursers had left Felwood untouched by its corruption, and Ogtinc needed four of their glands for a salve to heal the forest. It saddened him to ask, but {I} hunted the coursers and brought him the glands.",
        "{I} brought Ogtinc four courser glands, a hunt the Cenarion Circle could not make without weakening its spirit. He was glad the divine path had led {me} to them, since {my} beliefs did not stand in the way."},
    [8256] = {act = "took the ichor of undeath from the highborne of Eldarath", giver = "Ogtinc", solo = true,
        "Ogtinc's salve was one part poison to two parts cure, and the poison was the ichor of undeath. {I} went among the lingering highborne of the Ruins of Eldarath and took a single ichor, a sickly green goo where evil had gathered, back to him.",
        "Among the highborne dead of Eldarath {I} found the ichor of undeath, evil so potent that one was enough. Ogtinc took the wretched stuff with thanks, calling it a necessary evil."},
    [8257] = {act = "carried the blood of Morphaz to Greta Mosshoof", giver = "Ogtinc", solo = true,
        "Morphaz, the green drake, was immune to every poison and disease, knowledge many druids had died to bring. {I} went into his lair in the sunken temple of Atal'Hakkar, took his blood, and carried it to Greta Mosshoof, who could hardly believe the news.",
        "{I} brought Greta Mosshoof the blood of Morphaz, the last part of the salve. The healing of the forest's trees and creatures could begin at once, she said, and though it would take a lifetime, {I} had given them the means."},
    -- Mage
    [3104] = {act = "answered Khelden's sealed letter at the abbey", giver = "Khelden Bremen", solo = true,
        "{I} came back from the kobold camps to a letter sealed with Khelden's insignia, and went to find the abbey's mage trainer. He laughed that his note had not put {me} off, and asked if {I} would challenge the gods themselves in the pursuit of knowledge and power.",
        "Khelden Bremen had sent for {me} with a sealed letter, and he did not soften what lay ahead. A mage would be feared as much as respected, he warned, but he would be there to train {me} as {I} grew."},
    [92481] = {act = "heard Dorii Brightwhisper's message in a recall crystal", solo = true,
        "A recall crystal from Dorii Brightwhisper held a message for {me}, and {I} found her in a building nearby. She looked {me} over and said {I} would make a fine young mage.",
        "The arcane had waned among {my} people over the millennia spent in the clouds, Dorii told {me}, and some sought to win back what was lost. She hoped {I} would lead that search and make them proud."},
    [1860] = {act = "went to Jennea Cannon in the Wizard's Sanctum", solo = true,
        "{My} trainer spoke of a task vital to the safety of the city and the forest, and sent {me} to Jennea Cannon in the Wizard's Sanctum. She was glad to see a young mage eager to help, but would not yet say what the cause was.",
        "{I} went to the Wizard's Sanctum to find Jennea Cannon, who studied there among the city's mages. The cause would be made known in time, she told {me}, and called {me} young one."},
    [1861] = {act = "drew a sample of water from below the falls of Mirror Lake", giver = "Jennea Cannon", solo = true,
        "Great mystic struggles had torn magic from its channels, and Jennea feared it was seeping into the water. {I} took her flask to the base of the waterfall at Mirror Lake and brought back a sample, and she gave {me} a choice of an orb or a staff.",
        "{I} filled Jennea's flask below the falls of Mirror Lake, southwest of the city gates. She would test it for magical taint, hoping for the sake of those who drank there that she found none."},
    [1879] = {act = "went up to Bink in the Hall of Mysteries", solo = true,
        "Bink, a gnome mage, would trust no one but a mage with her task, and {I} went up to the Hall of Mysteries to be that mage. She saw promise in {me}, warned that bad mages were part of the problem, and started from the beginning.",
        "Word came from Bink in the Mystic Ward, and {I} went to see what she needed. She saw promise in {me}, yes she did, but said it took more than promise to make a good mage."},
    [1880] = {act = "recovered Bink's gizmonitor from the leper gnomes", giver = "Bink", solo = true,
        "Bink had left her mage-tastic gizmonitor in a chest outside Gnomeregan when the gnomes fled, and the huts were crawling with leper gnomes. {I} fetched it back before its energy ran out, and she gave {me} a pick of her first tools as a mage.",
        "{I} went among the leper gnomes outside Gnomeregan for the device that held Bink's stored knowledge. She called it a splendid day, and said her studies could begin anew."},
    [1882] = {act = "gathered snapdragons at the Balnir Farmstead", solo = true,
        "The mages of the Forsaken meant to curb the plague's spread, but first they had to measure it. {I} gathered snapdragons from the garden of the Balnir Farmstead, flowers highly receptive to magic, and earned a choice of an orb or a staff.",
        "{I} went east to the Balnir Farmstead, close to the Plaguelands, for the snapdragons in its garden. {My} trainer called them fine specimens and sent them to the apothecaries to measure the taint."},
    [1884] = {act = "destroyed Zalazane's ju-ju heaps on the Echo Isles", solo = true,
        "The warlock Zalazane had set tainted ju-ju heaps among his huts on the main Echo Isle, twisting the flow of magic and corrupting the wildlife. {I} destroyed them, and {my} trainer sensed it, calling it a great deed for {my} people.",
        "{I} crossed to the Echo Isles and broke Zalazane's ju-ju heaps before the flow of magic could be altered for good. {I} had shown {my} worth to the mages of the Horde, {my} trainer said."},
    [1921] = {act = "gathered linen and rift gems for a wizard's robe", solo = true,
        "{I} had served {my} fellow mages well, and it was time to don a wizard's robe. {I} gathered linen and the charged rift gems left in the miners' league crates at Silver Stream in Loch Modan, and Wynne Larson promised a garment fit for a mage.",
        "Wynne Larson took {my} linen and the rift gems from the Silver Stream Mine and began on the robe. Once the gems were woven in, she said, it would be a garment fit for a mage."},
    [1961] = {act = "took mana gems from the Dalaran mages of Silverpine", solo = true,
        "{My} first robes as a mage needed mana gems from the Dalaran mages of Silverpine, and {my} trainer said that if they could not resist {me}, they did not deserve their lives. {I} took the gems and brought them with linen to Josef Gregorian.",
        "{I} killed Dalaran mages in Silverpine for their mana gems, somewhat distasteful work, {my} trainer admitted, for their beliefs were close to those of the Forsaken. Josef Gregorian took the gems and the linen and would soon know if they could make spellfire robes."},
    [1959] = {act = "reported to Anastasia Hartwell about the disturbance", solo = true,
        "The city's mages had felt a magical disturbance and called on mages of the Horde, and {I} went to Anastasia Hartwell in the Magic Quarter. She could not yet say whether it was malign or benign, and set {me} to gathering more information.",
        "{I} answered the call for Horde mages and found Anastasia Hartwell in the Magic Quarter. The disturbance was real, she told {me}, though its origin was unknown, and she had a task for {me}."},
    [1920] = {act = "captured the invisible creatures in the Blue Recluse", solo = true,
        "Invisible creatures wandered the Blue Recluse, and {my} trainer feared a mana rift had opened there. {I} read the cantation of manifestation in the tavern, subdued the creatures it revealed, and sealed them in containment coffers.",
        "{I} went into the Blue Recluse with a cantation and empty coffers, and came back with the coffers full. {My} trainer would study how the creatures had slipped into the world, and said {my} value to the society of mages had grown."},
    [1939] = {act = "climbed to High Sorcerer Andromath", solo = true,
        "High Sorcerer Andromath, one of the most powerful mages not locked away in Dalaran, asked to see {me}. {I} climbed to the top of the Wizard's Sanctum, and he hoped {I} had time to listen to an old man's words.",
        "Counsel with Andromath was high counsel indeed, and {I} went up the Wizard's Sanctum when he sent for {me}. He greeted {me} with pleasure, an old man with words to share."},
    [1940] = {act = "hunted carrion recluses for pristine spider silk", giver = "High Sorcerer Andromath", solo = true,
        "Andromath judged {my} service worthy of a finer robe, one for an adept mage. {I} hunted the carrion recluse spiders of Duskwood for their most pristine silk, and Wynne Larson set straight to work on it.",
        "{I} brought Wynne Larson the finest silk from Duskwood's carrion recluses, as Andromath had asked. She liked the specimens and began {my} robe at once."},
    [1938] = {act = "took Ur's Treatise on Shadow Magic from the tower of Ilgalar", giver = "High Sorcerer Andromath", solo = true,
        "Long ago one of three mages who studied in the Sanctum fell to the dark arts and was banished, taking Ur's Treatise on Shadow Magic to the tower of Ilgalar in Redridge. {I} went into his library and brought the tome back to Andromath.",
        "{I} took Ur's Treatise on Shadow Magic from Morganth's library in the tower of Ilgalar. Andromath had feared the fallen mage had found a way to open it, but the seals still held."},
    [1943] = {act = "answered Deino's call at the Darkbriar Lodge", solo = true,
        "The troll mage Deino needed a mage's help, and {I} went to the Darkbriar Lodge to find her. Her task was hard but vital to the society of mages, she said, and well worth {my} trouble.",
        "{I} answered Deino's call at the Darkbriar Lodge. She was glad {I} had come, and promised that aiding her would prove worthwhile."},
    [1947] = {act = "sought out the hermit Tabetha for a mage's wand", solo = true,
        "The time had come to earn {my} mage's wand, and the search began with Tabetha, a human hermit of vast knowledge. {I} found her cottage west of Theramore, north of the Stonemaul Ruins, and she hushed {me} at a delicate juncture of her work.",
        "{I} went deep into the marsh west of Theramore to find the hermit Tabetha. She told {me} to be quiet, for she must not be disturbed, and asked for one moment."},
    [1948] = {act = "gathered Tabetha's items of power for the wand", giver = "Tabetha", solo = true,
        "A mage's wand needed rare substances and a vessel to store great magical energy, and Tabetha wrote out exactly what to gather and how. {I} followed her parchment to the letter, found the jade and made the bramble, and came back with smoke rising from {my} ears.",
        "{I} gathered everything on Tabetha's list, standing a little too close when the lightning struck the totem sticks. She saw smoke rising from {my} ears and told {me} that being hit by lightning was good luck."},
    [1951] = {act = "took Rituals of Power from the Scarlet Monastery's library", giver = "Tabetha", solo = true,
        "Tabetha had sold her last copy of Rituals of Power to pay gambling debts, and it had gone to the library of the Scarlet Monastery. {I} went into the monastery and brought it back, and she could prepare the ritual for {my} wand.",
        "{I} took Rituals of Power from the Scarlet Monastery's library, where a Scarlet cleric had carried it. Tabetha had what she needed, and hoped it had not been too much trouble to find."},
    [1955] = {act = "killed the demon Tabetha drew from the summoner's orb", giver = "Tabetha", solo = true,
        "Tabetha drew the demon out of the summoner's orb, and {I} had to kill it before it could jump back in. {I} did, and she said the demon would think twice before coming back, though it might bring big scaly friends next time.",
        "With {my} strongest spells ready, {I} fought the demon Tabetha exorcised from the orb and beat it quickly. She called it nicely done, then asked whether she had scared {me}."},
    [1957] = {act = "fought the mana surges from Tabetha's rift", giver = "Tabetha", solo = true,
        "Tabetha opened a mana rift to fill the empty summoner's orb, and {I} killed the mana surges that poured out until their power was enough. She swore she had never doubted {me} for a second, or two at most.",
        "The last step was the most perilous, and {I} fought the surges from Tabetha's rift before it closed. Their energy went into {my} orb, and Tabetha admitted to a second's doubt, honestly no more."},
    [1952] = {act = "chose a wand from Tabetha's work", giver = "Tabetha", solo = true,
        "With the orb filled and the ritual prepared, Tabetha went off to make the wands she had promised. She brought them back and let {me} take {my} pick, the end of long work in the marsh and beyond.",
        "{I} waited while Tabetha made the wands, and then chose one from her work. It was the mage's wand {I} had set out to earn."},
    [2861] = {act = "heard Tabetha's grudge against a troll of Zul'Farrak", solo = true,
        "Word came that Tabetha had a bone to pick with a sand troll in Zul'Farrak, and {I} went to her cottage in the marsh. She wanted help picking all of the troll's bones, she said.",
        "{I} went to Tabetha's cottage north of the Stonemaul Ruins to hear about her grudge. Tabetha wanted every bone of a certain troll in Zul'Farrak, she said, and she asked for {my} help."},
    [8250] = {act = "found Sanath Lim-yo below Xylem's tower", solo = true,
        "Archmage Xylem had been asking for a mage of {my} experience, and {I} went north from the fork at the Ruins of Eldarath to the cliffs below his tower. His servant Sanath Lim-yo sneered at {me} and said the Archmage was waiting.",
        "{My} experience had come to the notice of Archmage Xylem, whose tower could be reached only by his servant's teleport. Sanath Lim-yo made his camp below the cliffs, and sneered as he sent {me} up."},
    [8251] = {act = "took the glittering dust from the blood elves of the cliffs", giver = "Archmage Xylem", solo = true,
        "The blood elves along the cliffs had killed Xylem's apprentice when he came to trade for their glittering dust. {I} took the dust by more persuasive means, and Xylem marveled at how persuasive a volley of arcane missiles could be.",
        "Talk was over, Xylem said, and {I} went among the blood elves of the cliffs for the glittering dust they made from magical items. He was pleased with what {I} brought back."},
    [8252] = {act = "took enchanted coral from the spitelash sirens", giver = "Archmage Xylem", solo = true,
        "The spitelash had overrun the beaches below Xylem's tower and taken most of the bay's enchanted coral. {I} parted the sirens from some of it, and Xylem called {my} skills precise and deadly.",
        "{I} fought the spitelash sirens, adept mages themselves, for the coral Xylem's research needed. He praised the specimen and hinted that {I} might be worthy of a true test of skill."},
    [8253] = {act = "destroyed Morphaz and recovered Xylem's arcane shard", giver = "Archmage Xylem", solo = true,
        "Years before, Morphaz had ambushed Xylem and swallowed his apprentice whole, along with an arcane shard of unsurpassed size. {I} went down into the sunken temple, destroyed the drake, and brought the shard back from his stomach.",
        "{I} slew Xylem's old nemesis Morphaz in the sunken temple and returned with the shard, grown over the years on the drake's energy. Xylem's full power to forge the arcane had come back, and his first creation was for {me}."},
    [7463] = {act = "brought Lydros the essence of the Hydrospawn", giver = "Lydros", solo = true,
        "Lydros had not seen a mage of {my} kind in five hundred years or so, and he snickered as he set {me} a task. {I} went into the Warpwood Quarter, took a portion of the Hydrospawn's essence, and came back for the useful cantrip he had promised.",
        "{I} brought Lydros the essence of the Hydrospawn, the water elemental that had settled in the east wing. By then he had forgotten who had brought it and what he owed, but he gave {me} something a mage might find useful."},
    -- Warlock
    [3105] = {act = "answered Drusilla's sealed letter at the abbey", giver = "Drusilla La Salle", solo = true,
        "{I} came back from the kobold camps to a letter sealed with Drusilla's insignia, and found her sneering at the guards who had given her curious looks. As {I} grew, she warned, temptation would come, and corruption could reach anyone who dealt with the Twisting Nether.",
        "Drusilla La Salle had sent for {me} with a sealed letter, and said {I} had come not a moment too soon. Be patient and prudent, she told {me}, but never let that repress {my} ambition."},
    [1470] = {act = "brought rattlecage skulls to learn to bind an imp", solo = true,
        "{My} trainer said knowledge was a warlock's greatest power, and promised to show {me} how to bind a servant once {I} brought three rattlecage skulls from near the abandoned smithy. {I} did, and learned to summon and bind an imp.",
        "{I} hunted the rattlecage skeletons by the old smithy for their skulls, {my} first test as a warlock. {My} trainer judged {me} able enough to master an imp, and warned {me} not to be deceived by its size."},
    [1485] = {act = "took the heads of six vile familiars", giver = "Ruzan", solo = true,
        "Warlocks were tolerated by the Horde but not loved, Ruzan told {me}, and before any lesson in summoning he wanted six heads of the vile familiars from the cave to the northeast. {I} brought them, and learned that even a small imp could be a formidable foe.",
        "{I} went into the cave northeast of the valley and took the heads of six vile familiars, imps that fought harder than their size suggested. Ruzan spoke of the many beings {I} would learn to call, all of them useful tools."},
    [1499] = {act = "told Zureetha Fargaze of the vile familiars", giver = "Ruzan", solo = true,
        "Ruzan thought helping Zureetha Fargaze cull the cave's creatures would be good experience, and sent {me} to tell her of the imps {I} had fought. She said {I} had done well, and that beating the familiars foretold greater deeds ahead.",
        "{I} told Zureetha Fargaze how {I} had dealt with the vile familiars in the cave. Those imps were only pets of the darker powers in the Burning Blade, she said, and gave {me} a reward."},
    [1598] = {act = "stole Powers of the Void back from the Defias", solo = true,
        "A novice who ran off to the Defias had stolen Powers of the Void from the abbey, and {my} trainer wanted it for herself. {I} took it from their tent in the vineyards, and she agreed to show {me} how to summon an imp.",
        "{My} trainer had never been able to reach Powers of the Void in the abbey's protected wing, so a Defias thief had done her a favor. {I} stole it back from their vineyard tent, and she judged {me} able to handle an imp of {my} own."},
    [1471] = {act = "called up and subdued a voidwalker beneath the city", solo = true,
        "In the circle of summoning below {my} trainer's chamber {I} used the runes to draw forth an unbound voidwalker, and dominated it with strength of arms and magic. Then {I} learned the spell to summon it, its power {my} own to command.",
        "{I} called a voidwalker from the void and fought it until it was subdued, the trial {my} trainer had set. The power it had turned on {me} became {my} own to command, and {I} learned the spell to call it."},
    [1473] = {act = "took Egalin's grimoire back from a Scarlet agent", solo = true,
        "Egalin had summoned the first voidwalker and set down the process in his grimoire, but an agent of the Scarlet Crusade had stolen it. {I} took the grimoire back from his tower to the west, and {my} trainer began to show {me} the structure of the spell.",
        "{I} recovered Egalin's grimoire from Perrine, a Scarlet agent who likely never knew its power. Egalin had taught {my} own trainer, and his grimoire held the summoning of a voidwalker, a being that could tear apart anyone who failed to control it."},
    [1478] = {act = "answered Carendin Halgar's summons in the Magic Quarter", solo = true,
        "Ageron passed on word that Carendin Halgar wanted to train {me} himself, an honor few young warlocks were given. {I} went to the Magic Quarter near the Temple of the Damned, and Halgar skipped the pleasantries, since there was still much {I} had to learn.",
        "Master Halgar did not often instruct a young warlock in person, and he had sent for {me}. In the Magic Quarter he went straight to {my} training."},
    [1506] = {act = "answered Gan'rul's summons in the Cleft of Shadow", solo = true,
        "Ophek found {me} with word that Gan'rul wanted {me} at once, a summons that could be very good or very bad. {I} went to the senior warlocks in the Cleft of Shadow, and Gan'rul said {my} other business would have to wait.",
        "{I} answered Gan'rul's summons in the Cleft of Shadow. He had feared Ophek would never reach {me}, and it was time to further {my} training."},
    [1685] = {act = "went down to Master Gakin beneath the Slaughtered Lamb", solo = true,
        "Remen had looked for {me} all day before {I} walked right up to him, and he sent {me} to Master Gakin in the basement of the Slaughtered Lamb, a place best kept quiet. Gakin said it was about time, and that {I} had gone too long without training.",
        "{I} went down beneath the Slaughtered Lamb, where Master Gakin taught out of sight of the city. He wondered aloud whether he should have sent someone more capable than Remen to find {me}."},
    [1688] = {act = "took Gakin's bloodstone choker from Surena Caledon", giver = "Master Gakin", solo = true,
        "Gakin's former student Surena Caledon had run off with the Defias Erlan Drudgemoor, taking the bloodstone choker he had given her. {I} found her at the Brackwell Pumpkin Patch and brought the choker back, and Gakin called the waste of her gifts a shame, if a necessary one.",
        "Surena Caledon had once stood where {I} stood, eager and gifted, until she left Gakin for a Defias. {I} bested her at the Brackwell Pumpkin Patch, and Gakin hoped his investment in {me} would turn out better."},
    [1689] = {act = "called up and subdued a voidwalker with Surena's choker", giver = "Master Gakin", solo = true,
        "With Surena's bloodstone choker {I} called a voidwalker forth at the summoning circle below and subdued it with every weapon {I} had. Gakin said {I} had done better than he expected, and taught {me} to command it.",
        "Besting Surena proved {me} at least as capable as she had been, Gakin said, but a warlock needed more than control of magic. {I} overcame the voidwalker in the circle below, and he showed {me} how to make it serve."},
    [1501] = {act = "took the Tablet of Verga from the Burning Blade in Skull Rock", solo = true,
        "So few warlocks remained in the Horde that {I} had to grow quickly, and the Burning Blade had stolen the Tablet of Verga. {I} took it back from their lair in Skull Rock, east of the city, and {my} trainer hoped {I} had hurt the cult while about it.",
        "{I} went into Skull Rock after the Tablet of Verga, the summoning text the Burning Blade had stolen. {My} trainer called the cult a great blight upon warlocks, and was glad to have the tablet back."},
    [1504] = {act = "called up and subdued a voidwalker in Neeru Fireblade's tent", solo = true,
        "{I} took the glyphs from the Tablet of Verga to the circle in Neeru Fireblade's tent and called forth a voidwalker, then defeated it with all {my} means. {My} trainer showed {me} how to summon one like it, and warned that harder tasks lay ahead.",
        "In Neeru Fireblade's tent {I} faced the voidwalker the glyphs called up, and beat it. {I} had matched the high expectations held for {me}, {my} trainer said, but should not let it go to {my} head."},
    [1474] = {act = "called up and subdued a succubus beneath the city", solo = true,
        "With the hearts {I} had gathered {I} opened a doorway at the summoning circle, and a succubus came through. {I} resisted its charms and overcame it, and {my} trainer said it had been a long time since a young warlock had shown such potential.",
        "The succubus was among the most dangerous powers beyond the void, for the weak were easily wrapped around its fingers. {I} defeated it at the circle, and learned the spell to summon it at {my} command."},
    [1738] = {act = "took the heartswood core from Ordil'Aran", solo = true,
        "Two lovers had fallen together in the War of the Ancients, and where they died a tree called the heartswood grew. {I} went to the ruins of Ordil'Aran in the northwest of the forest for its core, enough to tempt a succubus, and Gakin set to working with it.",
        "{I} took the core of the heartswood from Ordil'Aran, a tree grown from the undying love of two fallen lovers. Gakin judged it would do nicely, and called Takar, who had found it, a resourceful fellow."},
    [1739] = {act = "called up and subdued a succubus with the heartswood core", giver = "Master Gakin", solo = true,
        "With the heartswood core {I} opened a portal at the circle in the crypt below, and a succubus came through. {I} bested it and sent it back to the void, and Gakin said they had done right to train {me}.",
        "Succubi had overrun even the strongest minds, Gakin warned, and {I} went down to the crypt to face one. {I} came back unbroken, and he showed {me} how to call and control the demon."},
    [65597] = {act = "lured and subdued an incubus beneath the city", solo = true,
        "{I} placed the hearts at the center of the circle below and called forth an incubus, which was not pleased to find it had been lured into a trap. {I} did not fall for its beguilement, subdued it fully, and learned the spell to summon it.",
        "Many warlocks who thought themselves strong enough to command a sayaad had ended up commanded instead, {my} trainer said. The trial did not break {me}, and the incubus became {my} servant."},
    [65603] = {act = "lured and subdued an incubus with a figurine", solo = true,
        "{I} carried the figurine down into the crypts and set it at the center of the prepared circle, and the incubus crossed into the world. Anything it offered was false, {my} trainer had warned, and {I} defeated it with all {I} had been taught.",
        "Fail, and {my} soul was forfeit, {my} trainer said before {I} went down to face the incubus. {I} bested the fiend with {my} will unbroken, and learned the invocation to call it."},
    [65604] = {act = "lured and subdued an incubus with Magar's scarf", solo = true,
        "Magar's scarf still carried the love he had felt for Krilge, and the incubus could not resist it. {I} summoned the demon in Neeru's tent and slew it quickly, and {my} trainer was pleased to teach {me} to summon it.",
        "Love woven into a scarf lured an incubus into the circle in Neeru's tent, and {I} defeated it without entertaining its charms. {My} trainer called it a reminder of what set warlocks apart, who wielded the demons' darkness and were never wielded by it."},
    [1740] = {act = "gathered the pieces of the orb of Soran'ruk", solo = true,
        "Doan had spent his life studying the orbs that imprisoned fallen demons of the Legion, and wanted the pieces of Soran'ruk's orb. {I} took the shards from the Twilight's Hammer acolytes in Blackfathom Deeps and the larger piece from a wizard in Shadowfang Keep, and Doan made it whole again.",
        "{I} gathered the broken orb of Soran'ruk from Blackfathom Deeps and Shadowfang Keep and brought the pieces to Doan. Almost all of it was there, he said, and he would give it back to {me} remade in a form of {my} choosing."},
    [1798] = {act = "sought out Strahad Farsan in Ratchet", solo = true,
        "{My} trainer lacked the reagents to teach the felhunter summoning, and sent {me} to Strahad Farsan of the inner circle, in the goblin port of Ratchet. Strahad greeted {me} as the latest prodigy, joking that the real thing could not live up to the reputation.",
        "Word of {me} had gone ahead to Ratchet, and Strahad Farsan was expecting the latest prodigy. He feared {I} could not live up to the reputation, then put his jokes aside, since {I} had come to learn."},
    [2996] = {act = "climbed to Strahad's tower above Ratchet", solo = true,
        "{My} trainer judged {me} ready for greater summonings, and {I} went to Strahad in Ratchet, a small human of great power. He was watching the toil of the port below his tower, and saw hatred in {my} eyes that he meant to put to good use.",
        "{I} climbed above the port to Strahad's tower, sent by a trainer who warned that his small size hid great power. Strahad enjoyed the mystery, adventure and ignorance of a port city, he said, and liked the hatred he saw in {me}."},
    [3001] = {act = "sought Strahad for greater summonings", solo = true,
        "Strahad was human, {my} trainer warned, but neither weak nor {my} enemy, at least for now, and he could teach {me} greater summonings. {I} found him beside the tower above the port, where he said the hatred in {my} eyes would be put to good use.",
        "{I} sought out Strahad above the port town, a powerful man {my} trainer told {me} to respect. He talked of the busy port below as a place of mystery and ignorance, then asked whether that was hatred he saw in {me}."},
    [1795] = {act = "subdued a felhunter at Strahad's tower", giver = "Strahad Farsan", solo = true,
        "Strahad drew the basic summoning circle and his acolytes raised the greater one with their rods, and {I} read the incantation from the Tome of the Cabal. The felhunter came forth, and {I} brought it down while keeping {my} head on {my} shoulders.",
        "When Strahad faced his own felhunter he had barely escaped with his life, he admitted, and {I} beat the one {I} had summoned. He said {I} had the potential to become one of the most powerful warlocks of the era."},
    [4736] = {act = "went to Menara Voidrender on Briarthorn's word", solo = true,
        "Briarthorn said {I} had trained well without becoming corrupted, and deserved a reward from Menara Voidrender in Strahad's tower above Ratchet. Menara was pleased that word reached so far, and offered to help {me} make tools for {my} craft.",
        "{I} went to Menara Voidrender in the tower over Ratchet, warned that she was not friendly but looked after hard workers. Warlocks banded together regardless of race, she said, since the demons showed no mercy to those who failed to control them."},
    [4738] = {act = "went to Menara Voidrender despite Demisette's doubts", solo = true,
        "Demisette did not think a novice should ever help make an item of power, but the choice was not hers, and she sent {me} to Menara Voidrender in Ratchet. Menara was pleased that word reached so far, and offered to help {me} make tools to suit {my} skills.",
        "Despite Demisette's doubts, {I} climbed to the tower above the port and found Menara Voidrender. {I} had learned a great many things, Menara judged, and she would help {me} if {I} wished."},
    [4965] = {act = "returned to Menara Voidrender seeking something more substantial", solo = true,
        "{My} trainer was pleased to see {me} growing in power, and sent {me} to Menara Voidrender, who made orbs that could imprison even a demon. In Strahad's tower above Ratchet she welcomed {my} wish for power in forms other than knowledge, and asked if {I} felt ready.",
        "{I} returned to Menara Voidrender in Strahad's tower, seeking something more substantial than knowledge. She could help, she said, if {I} were truly prepared."},
    [4967] = {act = "went to Menara Voidrender despite a scornful trainer", solo = true,
        "{My} trainer laughed at {me} as a fool still seeking the trappings of mortals, yet admitted that those with some power felt {I} deserved more. {I} went to Menara Voidrender above Ratchet, who called it a welcome change to see a warlock seeking more than knowledge.",
        "Against {my} trainer's better judgment, others had decided {I} deserved more, and {I} went back to Menara Voidrender in the tower above Ratchet. She asked whether {I} felt ready for something more substantial."},
    [4968] = {act = "went to Menara Voidrender for a test of skill", solo = true,
        "{My} trainer was astonished that the arcane had not yet driven {me} mad, and proposed to push {me} further with a test of skill under Menara Voidrender. In Strahad's tower Menara offered her help, if {I} were truly prepared.",
        "Still sane after so long channeling the arcane, {I} went to Menara Voidrender above Ratchet to be tested. She welcomed a warlock seeking power beyond knowledge, and asked if {I} felt ready."},
    [4969] = {act = "went to Menara Voidrender for a mortal-forged weapon", solo = true,
        "One day infernals and dreadlords would bow before {me}, {my} trainer laughed, but until then {I} needed weapons forged by mortal hands. Menara Voidrender near Strahad's tower had another such creation in mind, and asked if {I} felt ready.",
        "{I} went to Menara Voidrender overlooking the port, seeking something more substantial than knowledge. She was glad of it, and would help if {I} were truly prepared."},
    [1799] = {act = "carried an Infernal Orb from Desolace to Tabetha", giver = "Menara Voidrender", solo = true,
        "Menara's price was two tasks, an acolyte's path chosen inside her tower and an Infernal Orb taken from the warlocks of the Mannoroc Coven in Desolace. {I} carried the orb to Tabetha in the southern marsh to be cleansed, and she let {me} stay as her guest.",
        "Tabetha took Menara's name as reason enough to help {me}, for the two had a history together. She could smell the arcane on {me}, she said, and wondered whether corruption was really so far from {me} after all."},
    [3631] = {act = "answered Strahad's call to his tower above Ratchet", solo = true,
        "{My} trainer did not think {me} prepared, but the choice belonged to Strahad, and he wanted to see {me} quickly. {I} went back to his little tower above Ratchet, where he thanked {me} with mock courtesy for gracing his presence again.",
        "Strahad's acolytes had wondered whether {I} would ever show up, but he had not. Where power was concerned, he told {me} at his tower, {I} came like a moth to the flame."},
    [4487] = {act = "went to Strahad for a blessing of sorts", solo = true,
        "{My} trainer had sent a demon after {me}, but {I} arrived first, and heard that talk of {my} growing power had earned {me} a blessing of sorts. {I} went to Strahad above Ratchet, who said power drew {me} like a moth to the flame.",
        "Word of {my} growing power had spread, good for {me} and possibly bad for others, and Strahad sent for {me} again. His acolytes had doubted {I} would come, he said at his tower, but he had never doubted it."},
    [4488] = {act = "went back to Strahad's tower over the port", solo = true,
        "{My} trainer called {me} a pup in true knowledge, with a will that corruption might yet overwhelm, and passed on Strahad's summons. At his tower above Ratchet Strahad greeted {me} with mock courtesy and talk of moths and flames.",
        "{I} went back to Strahad's tower over the port, though {my} trainer doubted {my} will. Strahad had told his acolytes he never doubted that power would bring {me} back."},
    [4489] = {act = "answered Strahad Farsan's call for a reward", solo = true,
        "A warlock stopped {me} with word that {my} growing power had been acknowledged and that a reward was due. Strahad Farsan wanted words with {me} above Ratchet, and he greeted {me} there with mock courtesy.",
        "{I} did not take long to reach Strahad Farsan's tower over the port. His acolytes had wondered if {I} would show, he said, but where power was concerned he had known {I} would."},
    [4490] = {act = "learned from Strahad to summon a felsteed", giver = "Strahad Farsan", solo = true,
        "Strahad rewarded {my} patience and hard work with the power to summon a felsteed, a demonic steed of {my} own. Such power would be much harder to earn in future, he warned, and he looked forward to seeing {me} again.",
        "{I} left Strahad's tower able to call a felsteed to carry {me}, a gift he said would not come so easily again. He wished {me} luck and said he expected to see {me} in the future."},
    [4961] = {act = "killed the demon Tabetha drew from the Infernal Orb", giver = "Tabetha", solo = true,
        "Tabetha found the taint in the Infernal Orb and drew out the demon within, and {I} had to kill it before it could slip back inside. {I} beat it quickly, and she sent {me} back to Menara with the cleansed orb.",
        "With {my} strongest spells ready {I} fought the demon Tabetha released from the orb, and she called it nicely done. {I} had shown great power and skill, she said, and perhaps she would meet {me} again."},
    [4962] = {act = "captured a felhound's soul in Desolace", solo = true,
        "{I} chose the felhound, and Menara's acolyte gave {me} a ruby to take its soul as it died. {I} went to Desolace, captured a felhound's spirit, and carried it with the ruby to Menara, who would merge it with the cleansed orb.",
        "Overpowering an enemy was as strong a tactic as balance, the acolyte said, and {I} chose the felhound's soul. In Desolace the ruby took it at the edge of death, and Menara praised the work."},
    [4963] = {act = "captured an infernal's soul in Desolace", solo = true,
        "{I} chose the infernal, and Menara's acolyte gave {me} an emerald to take its soul as it died. {I} went to Desolace, captured an infernal's spirit, and carried it with the emerald to Menara, who would merge it with the cleansed orb.",
        "Each choice should reflect {my} strengths, the acolyte said, and {I} chose to bind an infernal. The emerald took its soul as it fell in Desolace, and Menara would hold the spirit until the cleansed orb was ready."},
    [4964] = {act = "received the Orb of Dar'Orahil from Menara", giver = "Menara Voidrender", solo = true,
        "Menara worked the felhound's spirit into the cleansed orb, and let {me} choose its form, a staff for both hands or an orb beside a dagger or sword. Tackling a felhound had been a great feat, she said, and she would await word of {my} exploits.",
        "{I} waited while Menara bound the felhound's soul into the Orb of Dar'Orahil, the end of long work from Desolace to Tabetha's marsh. She told {me} to keep working hard in the arts."},
    [4975] = {act = "received the Orb of Noh'Orahil from Menara", giver = "Menara Voidrender", solo = true,
        "Menara worked the infernal's spirit into the cleansed orb and gave {me} the choice of a staff or an orb to go beside a blade. Tackling the infernal had been a great feat, she said, and the reward would fit {me} nicely.",
        "The Orb of Noh'Orahil was finished, an infernal's soul bound in the orb Tabetha and {I} had cleansed. Menara wished {me} further success in the arts."},
    [7601] = {act = "took on Niby's price for the secret of the infernal", solo = true,
        "Niby the Almighty would teach {me} to summon an infernal servant once {I} brought him the core of Kroshius, an infernal all but burned out. Raising Kroshius from the rubble needed demonic components, and Niby sent {me} to his imp Impsy, who sighed that here they went again.",
        "{I} came to Niby the Almighty for the secret of the infernal, and he set {me} a hard price, the core of the burned-out Kroshius. His imp Impsy greeted {me} with weary resignation."},
    [8419] = {act = "brought felcloth to Impsy north of Bloodvenom Falls", solo = true,
        "An imp named Impsy had asked for {me}, wanting a piece of felcloth as a sign of good faith. {I} took it from the satyrs of the forest and found him north of Bloodvenom Falls, where he called {me} a splendid warlock and savored the burn of the cloth.",
        "{I} brought Impsy the felcloth he wanted, the satyrs' cloth that burned the skin and wove evil thoughts through the mind. The imp loved the feel of it, and was delighted with {me}."},
    [8420] = {act = "brought Impsy felcloth for a pet of his own", giver = "Impsy", solo = true,
        "Niby had Impsy, and Impsy wanted a pet of his own, even one that was not alive. {I} killed satyrs until {I} had felcloth enough to start it, and the imp called {me} too kind for a warlock.",
        "{I} hunted the forest's satyrs for more felcloth so Impsy could begin his pet. He thought it unfair that Niby had him and he had nothing, and he savored the burn of the cloth."},
    [8421] = {act = "gathered irontree wood and bloodvenom essence for Impsy", giver = "Impsy", solo = true,
        "Impsy's pet needed eyes, so {I} ripped rotting wood from the irontree folk of the Irontree Woods for him to carve. {I} brought bloodvenom essence from the tainted oozes too, for that new demon smell, and Impsy said it would work so very well.",
        "{I} gathered wood from the irontree folk and essence from the tainted oozes near Niby's camp, the parts of an imp's homemade pet. Impsy was pleased with every piece."},
    [8422] = {act = "took the voodoo feathers of the sunken temple's trolls for Impsy", giver = "Impsy", solo = true,
        "Impsy's pet needed stuffing, and only the voodoo feathers of the sunken temple's trolls would do. {I} killed Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro, and Impsy paid {me} with something of Niby's before stuffing the doll and giving it a demonic hug.",
        "{I} went down into the sunken temple for the feathers of its six troll guardians, and Impsy stuffed his doll with them at once. He hugged it, then noticed the voodoo feathers had an odd side effect."},
    [7602] = {act = "gathered three flawless fel essences for Impsy's fel fire", giver = "Impsy", solo = true,
        "To reanimate Kroshius {I} needed fel fire, and Impsy could make it from three flawless fel essences. {I} took them from the Legashi satyrs of Azshara, the legionnaires of Jaedenar and the felguard sentries of the Blasted Lands, and Impsy began combining them.",
        "{I} gathered fel essences from three corners of the world for Impsy's fel fire. The imp confided that Niby was daft, then set to making the fire."},
    [7603] = {act = "raised Kroshius with fel fire and took his infernal core", giver = "Impsy", solo = true,
        "Impsy expected Kroshius to kill {me}, but {I} set the fel fire on his remains in Shatter Scar Vale, and when the infernal rose {I} destroyed him again. Niby took the core and, in a great hurry, gave {me} the knowledge he had promised.",
        "{I} raised Kroshius from his heap in Shatter Scar Vale with fel fire and brought him down for his infernal core. A deal was a deal, Niby said, and he handed over the secret of the infernal before his own greatest conjuration began."},
    [7562] = {act = "sought Mor'zul Bloodbringer at the Altar of Storms", solo = true,
        "{My} mastery over demons had grown so strong that {my} trainer thought {me} ready to bind one of the dreadsteeds of Xoroth. {I} found Mor'zul Bloodbringer camped by the Altar of Storms, and he guessed {my} purpose at once.",
        "A warlock of {my} stature did not shy from danger, {my} trainer said, and {I} went to Mor'zul Bloodbringer at the Altar of Storms. A dreadsteed would cost blood, sweat and gold, he warned, but it was a prize well worth winning."},
    [7563] = {act = "brought Mor'zul the blood of Winterspring's owl beasts", giver = "Mor'zul Bloodbringer", solo = true,
        "Mor'zul needed a special ink to scribe the glyphs that would bind a dreadsteed, and it came from the blood of Winterspring's owl beasts. Once pure, they had been driven mad by Darkwhisper Gorge, and {I} hunted them for their blood.",
        "{I} brought Mor'zul the blood of the maddened owl beasts of Winterspring, strong with magic. He would have it distilled into ink, and admitted he might keep a little, having heard its taste was euphoric."},
    [7564] = {act = "took Mor'zul's blood to Gorzeeki Wildeyes", giver = "Mor'zul Bloodbringer", solo = true,
        "Mor'zul sent {me} with the owl beast blood to his servant Gorzeeki Wildeyes, an alchemist who preferred his blood warm in a living rodent. Gorzeeki guessed at once that a dreadsteed ritual was coming, and warned that it would take far more than blood.",
        "{I} handed Gorzeeki the blood, and he had hoped it was a juicy spider instead. Seeing it was Mor'zul's, he grew excited at the thought of a dreadsteed, and said the ritual would need a lot more than blood."},
    [7623] = {act = "passed into Jaedenar to see Lord Banehollow", giver = "Gorzeeki Wildeyes", solo = true,
        "Opening a portal to Xoroth needed Xorothian stardust, and the only source Gorzeeki knew was Lord Banehollow, in Jaedenar among the Shadow Council. {I} drank Gorzeeki's shadowy potions to pass through, and reached Banehollow, whose patience spanned millennia but whose time did not.",
        "Cloaked in the Shadow Council's own evil by Gorzeeki's potions, {I} walked into Jaedenar to see Lord Banehollow. His patience spanned the millennia, he said, but {I} would have no more than an instant of his time."},
    [7624] = {act = "killed Ulathek the traitor in Shadow Hold", giver = "Lord Banehollow", solo = true,
        "Banehollow's servant Ulathek groveled before him while spying for Lord Hel'nurath of Xoroth. {I} confronted the traitor in his quarters in Shadow Hold and brought his heart back to Banehollow, who meant to eat it after a week of rotting.",
        "To win Lord Banehollow's favor {I} killed his servant Ulathek in Shadow Hold and carried the traitor's heart to him. His patience for {me} had grown, he said, marginally."},
    [7625] = {act = "bought Xorothian stardust from Banehollow's servant Ur'dan", giver = "Lord Banehollow", solo = true,
        "Lord Banehollow guessed {I} meant to steal a dreadsteed from his rival Hel'nurath, and sent {me} to his servant Ur'dan, who sold Xorothian stardust for a price. {I} paid it and brought the stardust to Gorzeeki, who could hardly believe it.",
        "{I} carried the Xorothian stardust from Jaedenar back to Gorzeeki, who guessed it had cost a big deal with the dreadlord, a large sum, or both. Now Mor'zul could finish the parchment that would open a portal to Xoroth."},
    [7626] = {act = "brought elixirs of shadow power for the Bell of Dethmoora", giver = "Mor'zul Bloodbringer", solo = true,
        "A Circle of Greater Summoning needed three tools, and the first was a bell named for the late warlock Dethmoora Darkeyes. {I} brought Gorzeeki the many elixirs of shadow power it took, and he began the bell, to keep until the ritual.",
        "{I} gathered a large supply of elixirs of shadow power for Gorzeeki's Bell of Dethmoora. He hoped they had not been too hard to get, since alchemists could be so miserly, and set to work."},
    [7627] = {act = "brought Gorzeeki shards and dark iron ore for the wheel", giver = "Mor'zul Bloodbringer", solo = true,
        "The Wheel of the Black March would contain the violent energies of the circle, and Gorzeeki needed large brilliant shards and dark iron ore to make it. {I} brought both, and he marveled at a warlock's dedication before promising to keep the wheel until the ritual.",
        "{I} gathered brilliant shards from an enchanter and dark iron ore from the depths of Blackrock for Gorzeeki's wheel. With that much dedication, he mused, {I} could have caught a feast of bugs."},
    [7628] = {act = "brought black dragonscales for the Doomsday Candle", giver = "Mor'zul Bloodbringer", solo = true,
        "The Doomsday Candle would burn any wayward demon that disrupted the ritual, and containing its fire took the essence in black dragon scales. {I} brought Gorzeeki the dragonscales, and he could make the candle without blowing up the whole camp.",
        "{I} found black dragonscales for Gorzeeki, the last thing he needed before he dared start the candle. He would hold it with the bell and the wheel until the ritual of the Circle of Greater Summoning."},
    [7629] = {act = "let Gorzeeki's imp loose in the alchemy lab of Scholomance", giver = "Gorzeeki Wildeyes", solo = true,
        "Mor'zul's parchment needed paper infused with Xorothian stardust, and only the alchemy lab in Scholomance had the equipment. {I} carried Gorzeeki's jar there and let out the clever imp J'eevee, who made the parchment, and then brought the jar back.",
        "{I} took a jarred imp into Scholomance on Caer Darrow and released it in the alchemy lab to infuse the parchment. Gorzeeki asked whether the bugs there were as delicious as he had heard, and was glad to have his jar back."},
    [7630] = {act = "brought Gorzeeki arcanite for the black lodestone", giver = "Gorzeeki Wildeyes", solo = true,
        "With the bell, wheel and candle made, Gorzeeki wanted a black lodestone to hold the ritual together if the other tools failed. {I} brought him the arcanite it needed, and he could make sure the ritual did not fizzle out.",
        "{I} brought Gorzeeki arcanite for the black lodestone, the last of the tools for the Circle of Greater Summoning. Nicely done, he said, and set to making it."},
    [7631] = {act = "opened a portal to Xoroth and won a dreadsteed's soul", giver = "Mor'zul Bloodbringer", solo = true,
        "Deep in the ruins {I} performed the ritual exactly as Mor'zul's scroll laid it out, raised the Circle of Greater Summoning, and opened a portal to Xoroth with the parchment. The dreadsteed came through, and {I} fought it until its soul answered to {me}.",
        "Even beaten, rage pulsed through the dreadsteed's ghostly flanks, but its soul belonged to {me}. It whispered dark magic into {my} mind, and {I} knew how to summon a dreadsteed of {my} own."},
    [7581] = {act = "took the blood of the Wildspawn satyrs for Daio's prison", giver = "Daio the Decrepit", solo = true,
        "Only a crystal prison of special make could hold a Doomguard, and Daio the Decrepit needed the coagulated blood of the Wildspawn satyrs of Dire Maul to bond its shards. {I} brought it back, and Daio said it would suppress the demon's defenses.",
        "{I} went into Dire Maul after the blood of the Wildspawn satyrs, lesser demons whose blood would bind Daio's prison. He called it a most excellent recovery."},
    [7582] = {act = "took the Tears of the Hederine in Darkwhisper Gorge", giver = "Daio the Decrepit", solo = true,
        "The Hederine of Darkwhisper Gorge secreted fel poisons that hardened into crystals no Doomguard could break. {I} took the Tears of the Hederine from them in Winterspring, and Daio had only to combine them with the satyr blood.",
        "Daio warned that the Hederine would not give up their Tears without a fight, and {I} fought them in Darkwhisper Gorge. With the crystals and the Wildspawn blood his prison would be ready."},
    [7583] = {act = "captured a Doomguard Commander in the Tainted Scar", giver = "Daio the Decrepit", solo = true,
        "Daio's prison was ready, and {I} went into the Tainted Scar to capture a Doomguard Commander in it. The demon turned all its fury on {me} as the ritual began, but the crystal held it, and Daio judged {me} ready to conjure and control such a beast.",
        "{I} captured a Doomguard Commander in the Tainted Scar, a cunning and lethal demon that fought to escape the crystal prison. Daio gave {me} the knowledge to conjure and control one."},
    -- Druid
    [92485] = {act = "sought out Xyton Silverwind beneath the great tree", solo = true,
        "Xyton Silverwind had left a note for {me}, and {I} found him on the ground floor of the village's great tree, a keeper of druidic lore. The island's life was a tapestry, he said, and druids were the keepers of its balance.",
        "{I} sought out Xyton Silverwind beneath the great tree, as the note asked. He saw potential in {me}, but warned that the path of the fang, the claw, the feather and the branch was not an easy one."},
    [6001] = {act = "faced Lunaclaw at the Moonkin Stone east of Auberdine", giver = "Mathrengyl Bearwalker", solo = true,
        "Mathrengyl gave {me} Cenarion Moondust and sent {me} to the moonkin cave nearest Auberdine, where Lunaclaw defended the Moonkin Stone. {I} faced Lunaclaw and won its strength, and Mathrengyl sensed the teaching of the Great Bear Spirit in {me}.",
        "{I} scattered the moondust on the Moonkin Stone east of Auberdine, and Lunaclaw came to face {me}. When it was beaten {I} carried its strength back to Mathrengyl, who called it a large step into a much larger world and taught {me} the ways of the Claw."},
    [6002] = {act = "faced Lunaclaw at the Moonkin Stone west of Taurajo", giver = "Turak Runetotem", solo = true,
        "Turak gave {me} Cenarion Lunardust and sent {me} west of Taurajo, where the plains meet Mulgore, to a Moonkin Stone guarded by Lunaclaw. {I} faced Lunaclaw and won its strength, and Turak sensed the Great Bear Spirit's teaching in {me}.",
        "At the Moonkin Stone near the border {I} applied the lunardust and fought Lunaclaw, its defender. Turak called it a large step into a much larger world, and began to teach {me} what it meant to be a druid of the Claw."},
    [94006] = {act = "met the great spirit Urs'endris by the falls", solo = true,
        "{My} studies had come far enough to meet one of the great spirits of the isle, and {I} went northeast to the waterfall below the Shrine of Akir. Urs'endris, who had taught druids the ursera shape for generations, asked if {I} wished to embrace the way of the claw.",
        "Urs'endris's domain was withering and falling into the sky like much of the isle, but the great spirit still waited by the falls. {I} found him in the shadow of the Shrine of Akir, and he agreed to speak with {me} of the claw."},
    [94911] = {act = "sought Turak Runetotem for the way to Moonglade", solo = true,
        "Promise in the druidic arts sent {me} to Turak Runetotem on the high bluffs, who could teach {me} the way to Moonglade. Turak marveled at a high elf speaking to him in his city, then welcomed {me} to Azeroth as a child of nature.",
        "{I} found Turak Runetotem among the tauren, and he called {me} a shaper of wind. The druids of the Cenarion Circle had much wisdom to share with {me}, he said, and Moonglade would welcome {me}."},
    [94912] = {act = "sought Sheldras Moontree for the way to Moonglade", solo = true,
        "Hoping to save {my} home, {I} went to Sheldras Moontree, a night elf in the human capital, to learn the way to Moonglade. He was glad to meet a fellow druid from among the Skyborne, and to be among the first to welcome {me} to Azeroth.",
        "{I} knew little of the Cenarion Circle, but Sheldras Moontree would teach {me} the way to its stronghold. He welcomed {me} as a child of nature, and promised that the druids of the Circle had much wisdom to share."},
    [6123] = {act = "gathered earthroot and lunar fungus for the deer's salve", solo = true,
        "The deer around Auberdine were sick, and Alanndarian needed earthroot and lunar fungus for a curative salve. {I} picked the fungus in the moonkin caves to the east, wary of the irritable moonkin, and brought it back with the earthroot.",
        "{I} brought Alanndarian earthroot and lunar fungus from the caves, enough with the water for ample doses of salve. Imagine curing a poison at will, Alanndarian said, without needing the exact antidote."},
    [6124] = {act = "cured the sick deer with Alanndarian's salve", solo = true,
        "{I} carried ten doses of salve along the coast and cured the sickly deer of their malaise. Dendrite Starblaze in Moonglade called them unwitting victims of a taint spreading through the land, and named {me} a friend of nature and the Circle.",
        "Some in Darnassus saw the corruption spreading through the land and some put on blinders, Dendrite told {me} after {I} had tended the deer. He hoped {I} would not be one of the blind, and gave {me} a symbol of the Circle's friendship."},
    [6125] = {act = "learned power over poison from Mathrengyl Bearwalker", giver = "Dendrite Starblaze", solo = true,
        "{I} had learned what it meant to cure poison without spiritual aid, and Dendrite sent {me} back to Mathrengyl Bearwalker for the lesson's end. Mathrengyl had followed {my} work, praised {my} grace under pressure, and gave {me} lasting power over poison.",
        "Mathrengyl had been following {my} progress since {I} left, and welcomed {me} back. The poisons around Auberdine troubled him and bore investigating, he said, and he taught {me} to purge poison with a spell."},
    [6126] = {act = "went to Dendrite Starblaze for the lesson in poison", solo = true,
        "Turak judged {me} ready to learn the druid's power over poison, but first {I} would treat poisonings as a layman would. {I} went to Dendrite Starblaze in Moonglade, who sent {me} to the Crossroads, where animals were being poisoned in earnest.",
        "Most druids had faced staged trials, Dendrite Starblaze told {me}, but {my} work would be real. A rash of animal poisonings at the Crossroads had defeated the locals, and Moonglade was sending {me} to help."},
    [6128] = {act = "gathered earthroot and kodo horns for the gazelles' salve", solo = true,
        "The gazelles of the plains were sick, and Tonga needed earthroot and whole kodo horns for a salve. {I} brought down kodos in the north for their horns, for the greater good of the balance, and Tonga had enough for ample doses.",
        "{I} brought Tonga earthroot and unbroken kodo horns, since mere chips would not do. With the water as a base it made enough salve to start making a difference, Tonga said."},
    [6129] = {act = "cured the sick gazelles with Tonga's salve", solo = true,
        "{I} took ten doses of Tonga's salve to the sickly gazelles of the northern plains and cured their malaise. Dendrite Starblaze called them unwitting victims of a taint spreading through the land, and named {me} a friend of nature and the Circle.",
        "After {I} had tended the gazelles, Dendrite praised {my} people's eagerness to learn the ways of Cenarius, proof that the need for balance crossed every racial barrier. He gave {me} a symbol of the Circle's friendship."},
    [6130] = {act = "learned power over poison from Turak Runetotem", giver = "Dendrite Starblaze", solo = true,
        "Dendrite sent {me} back to Turak Runetotem, and Turak had followed {my} progress since {I} left. He was surprised by the poisonings at the Crossroads, praised {my} grace under pressure, and gave {me} lasting power over poison.",
        "{I} returned to Turak having cured poison the hard way, as others must. The poisons near the Crossroads upset the balance and bore investigating, he said, and he taught {me} to purge them with a spell."},
    [27] = {act = "went to Dendrite Starblaze to learn of the aquatic form", solo = true,
        "{My} trainer had followed {my} progress with delight, and sent {me} to Nighthaven to learn a form that gave mastery of the water. Dendrite Starblaze told {me} the aquatic form had to be earned through two trials before it was mastered.",
        "{I} went to Dendrite Starblaze in Nighthaven to learn of the aquatic form, which let a druid move freely and endlessly through water. He set {me} two trials, one of work under water and one of understanding the form itself."},
    [28] = {act = "carried a Shrine Bauble from Lake Elune'ara to the Shrine of Remulos", giver = "Dendrite Starblaze", solo = true,
        "{I} searched the depths of Lake Elune'ara for a Shrine Bauble, then raced it to the Shrine of Remulos before it decayed. Tajarri, warden of the shrine, welcomed one more druid through the Trial of the Lake.",
        "The Shrine Bauble was fading fast when {I} brought it up from the lake, and {I} used it at the Shrine of Remulos in time. Tajarri told {me} the shrine honored Keeper Remulos, who guided the Cenarion Circle, and called it well done."},
    [30] = {act = "joined the two halves of the Pendant of the Sea Lion", giver = "Dendrite Starblaze", solo = true,
        "The Pendant of the Sea Lion was made of two halves, one for the sea lion's agility and one for its endurance. {I} asked the folk of the glade where they lay, found both and joined them, and Dendrite congratulated {me} on the second trial.",
        "{I} gathered both halves of the Pendant of the Sea Lion and joined them into one. Agility and endurance could not exist without each other under water, Dendrite said, and {I} should count on both once {I} had the aquatic form."},
    [31] = {act = "learned the aquatic form from Turak Runetotem", giver = "Dendrite Starblaze", solo = true,
        "{I} brought the Pendant of the Sea Lion back to Turak Runetotem as proof of {my} lessons in Moonglade. Turak said {my} ancestors would be pleased, and taught {me} the aquatic form so that {I} could become one with the water.",
        "With the pendant {I} returned to Turak, who found it very impressive. He gave {me} a gift for the two trials, and taught {me} the aquatic form with pleasure."},
    [5061] = {act = "learned the aquatic form from Mathrengyl Bearwalker", giver = "Dendrite Starblaze", solo = true,
        "{I} brought the Pendant of the Sea Lion to Mathrengyl Bearwalker as proof of {my} lessons in Moonglade. He called it very impressive and taught {me} the aquatic form, so that {I} could become one with the water.",
        "Back with Mathrengyl {I} showed him the joined pendant, and he gave {me} a gift in recognition of the two trials. Then, with pleasure, he taught {me} the aquatic form."},
    [9063] = {act = "answered Torwa Pathfinder's call for a druid", solo = true,
        "A hunter named Torwa Pathfinder had asked for a druid, saying only druids had the skills and respect for nature he needed. {I} found him where the road from Tanaris enters the crater, and he said {I} had come not a moment too soon.",
        "By then {I} had walked far in the ways of nature, and when Torwa Pathfinder asked for a druid, {I} answered. {I} met him by the Tanaris road at the crater's edge, after a long journey to reach him."},
    [9052] = {act = "gathered bloodcap mushrooms and Gorishi stings for Torwa", giver = "Torwa Pathfinder", solo = true,
        "Torwa wanted a toxin, not a deadly one, to pacify a great creature of the crater. {I} gathered bloodcap mushrooms from the bloodpetal sprouts and Gorishi stings from the wasps of the Slithering Scar, and Torwa mixed them with his soil.",
        "{I} searched the bloodpetal sprouts across the crater for bloodcap mushrooms and fought the giant wasps of the Slithering Scar for their stings. With the soil he had collected, Torwa made his toxin easily."},
    [9053] = {act = "took a putrid vine from the guardian of the sunken temple", giver = "Torwa Pathfinder", solo = true,
        "Torwa's toxin proved too weak for so powerful a creature, and it needed a putrid vine from the guardian at the bottom of the Temple of Atal'Hakkar. {I} unlocked the secrets of the altar, took the vine from the guardian, and Torwa could make the toxin in full.",
        "{I} went to the bottom of the sunken temple for the putrid vine Torwa needed. He had asked too much already, he said, and would not ask {me} to use the toxin on the creature again, but he gave {me} his thanks and respect."},
    -- Shaman (the early trials are told by the regional packs)
    [92484] = {act = "heard Windshaper Boro speak of the silent winds", solo = true,
        "A recall crystal from Windshaper Boro sent {me} to the middle of the village, where Boro asked if {I} could hear the whispers of the winds. The spirits had stopped speaking to {my} people years ago, Boro said, and shaman studied the elements hoping to speak with them again.",
        "{I} went to Windshaper Boro near the center of the village to begin the shaman's path. Boro asked whether {I} would walk it and master the elements, and offered to train {me} whenever {I} wished."},
    [8410] = {act = "answered Bath'rah the Windwatcher's summons", solo = true,
        "Bath'rah the Windwatcher had sent out a summons for a shaman of wisdom, and it found {me}. {I} followed the river north from east of Tarren Mill to the ruins where the old troll kept his watch.",
        "By then {my} command of the elements had earned a summons from Bath'rah the Windwatcher, and {I} went up the river to his ruins. He was pleased to see {me}, and said the talking could begin."},
    [8411] = {act = "brought Bath'rah a sample of each element", giver = "Bath'rah the Windwatcher", solo = true,
        "Bath'rah wanted the elements in hand before any talk, so {I} gathered a sample of each and brought them to his ruins. These were the ones he needed, he said, and the talking could begin.",
        "{I} brought a sample of every element to Bath'rah the Windwatcher, the proof of a shaman's mastery he had asked for. With the elements before him, the troll was ready to talk."},
    [8412] = {act = "gathered bear claws and spider eyes for Bath'rah's spirit totem", giver = "Bath'rah the Windwatcher", solo = true,
        "The elemental spirits had turned against Bath'rah and were trying to kill him, and he needed a spirit totem for protection, something more primal than the elements. {I} took bear claws and spider eyes in the Plaguelands, and he was eager to try the totem out.",
        "A shaman knew totems better than anyone, Bath'rah said, so {I} hunted bears, spiders and carrion birds for the claws and eyes his spirit totem needed. Great, mon, he said, and set about trying it."},
    [8413] = {act = "took the voodoo feathers of the sunken temple's trolls for Bath'rah", giver = "Bath'rah the Windwatcher", solo = true,
        "The spirit totem needed voodoo magic to work just right, and the trolls of the sunken temple carried feathers strong with it. {I} killed Gasher, Mijan, Zolo, Hukku, Zul'lor and Loro, and Bath'rah's totem could finally watch over his sleep.",
        "{I} brought Bath'rah the voodoo feathers of the sunken temple's six troll guardians, and his spirit totem was whole. It was about time he got a full night's rest, he said, and he offered {me} something from his long years of collecting."},
}
for id, pov in pairs(POV) do
    assert(P.questIDs[id], "pov for a missing class stage " .. id).pov = pov
end
A.Lore.RegisterStoryPack("class-stories", P)
