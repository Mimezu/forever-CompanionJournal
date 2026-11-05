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
    "Uzzek received the new arrival for instruction.", "The referral reached the veteran; his practical test was still ahead.")
q(1498, "Path of Defense", "WARRIOR", "Durotar", 10, W,
    "Uzzek required singed scales from Thunder Ridge's lizards as proof of endurance.", "The defensive lesson began with surviving the assaults of lightning hides and thunder lizards.",
    "The scales earned Uzzek's instruction in defense.", "The trial against the thunder lizards was complete, and the veteran began his lesson.")
q(1638, "A Warrior's Training", "WARRIOR", "Stormwind City", 10, W,
    "Harry Burlguard offered a veteran's instruction at the Pig and Whistle.", "Old Town's tavern held a teacher whose experience could keep a young warrior alive.",
    "Harry received the referral at the tavern.", "The training errand reached Harry, with the actual test still to come.")
q(1640, "Beat Bartleby", "WARRIOR", "Stormwind City", 10, W,
    "Bartleby refused to part with his mug without a fight.", "A tavern brawl stood between the pupil and Bartleby's drinking mug.",
    "Bartleby conceded the fight and acknowledged the strength brought against him.", "The brawl was won; taking the mug back for instruction was a separate errand.")
q(1665, "Bartleby's Mug", "WARRIOR", "Stormwind City", 10, W,
    "Harry wanted Bartleby's mug as proof that the tavern challenge was finished.", "Bartleby had finally agreed to surrender his mug, after finishing its contents.",
    "Harry received the mug and moved on to the promised lesson.", "The mug completed the practical test Harry had set before instruction.")
q(1719, "The Affray", "WARRIOR", "The Barrens", 30, W,
    "Fray Island tested warriors against successive challengers before Big Will entered the fight.", "Klannoc required the Affray to be won within the allotted time before he would teach.",
    "The challengers and Big Will were defeated, and Klannoc agreed to teach.", "The Affray was passed, earning instruction from the island's veteran.", 5)
q(1712, "Cyclonian", "WARRIOR", "Alterac Mountains", 40, "class_warrior_wind",
    "Bath'rah needed materials before he could call the wind lord Cyclonian.", "The Windwatcher offered to put a whirlwind heart's power into a weapon, if the summoning and battle succeeded.",
    "The ritual materials were gathered; Cyclonian still had to be faced.", "Bath'rah had the components for his spell, not yet the wind lord's heart.")
q(1713, "The Summoning", "WARRIOR", "Alterac Mountains", 40, "class_warrior_wind",
    "Bath'rah was ready to summon Cyclonian and needed the wind lord's heart.", "The ritual would call forth a dangerous opponent whose power could be worked into a weapon.",
    "Cyclonian fell, and the Whirlwind Heart was recovered.", "Bath'rah received the heart needed for his promised weapon.", 5)
q(8425, "Voodoo Feathers", "WARRIOR", "Blasted Lands", 52, W,
    "The fallen hero needed the Sunken Temple guardians' feathers to regain physical form for a moment.", "A spirit's unused arms could be passed on only if the temple's magic briefly restored his body.",
    "The feathers let the hero feel steel again long enough to grant a reward.", "The temple trophies gave the spirit a brief return to physical form.", 5)

q(1642, "The Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "The Tome of Divinity placed compassion and patience beside strength in battle.", "Paladin instruction treated helping those in need as a practical duty.",
    "The discussion of the tome led to a test of charitable service.", "The lesson's principles had been set out; an act of service was still required.")
q(1643, "The Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "The test called for finding someone with a worthy need in Stormwind.", "Stephanie struggled to obtain cloth for children at the orphanage.",
    "Stephanie's need for clothing materials became clear.", "The search found a charitable household short of supplies; the cloth had yet to be gathered.")
q(1644, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "Stephanie needed linen to sew clothing for orphaned children.", "Food and shelter had consumed the time and means available for the children's clothes.",
    "The linen supplied Stephanie's sewing and freed time for the children's other needs.", "The cloth reached the charitable household, turning the lesson into useful aid.")
q(1781, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "The Symbol of Life was entrusted for a new task involving the wounded Gazin.", "Gazin rested by the cathedral altar after a disastrous encounter at Heroes' Vigil.",
    "Gazin explained what had happened to Henze; the Symbol had not yet been used.", "The inquiry reached the survivor at the altar, opening the task of helping his friend.")
q(1786, "The Tome of Divinity", "PALADIN", "Elwynn Forest", 13, PW,
    "Henze had fallen holding off Defias spellcasters while Gazin escaped Heroes' Vigil.", "The Symbol of Life offered a chance to help the paladin left on Stone Cairn Lake's island.",
    "Henze was brought back through the Symbol of Life.", "The fallen paladin returned to life, though the Defias documents still needed recovering.", 5)
q(1787, "The Tome of Divinity", "PALADIN", "Elwynn Forest", 13, PW,
    "Henze was too weak to recover the Defias papers from the island himself.", "The documents could establish the Defias presence and reveal something of their plans.",
    "Gazin received the papers and confirmation that Henze was safe.", "The evidence came back from Heroes' Vigil, ready for examination by the kingdom's advisers.")
q(1788, "The Tome of Divinity", "PALADIN", "Stormwind City", 13, PW,
    "Duthorian awaited the report after the Symbol of Life had brought Henze back.", "The trial's final return concerned a power beyond the borrowed Symbol.",
    "Duthorian taught the power to resurrect fallen companions.", "The completed trial earned instruction in resurrection.", 6)
q(94427, "A Lesson in Divinity", "PALADIN", "Undercity", 12, PF,
    "Tyr's Watch urged service to fellow Forsaken, beginning with Tanis Alderwood in the Trade Quarter.", "Tanis's need offered a practical test of charity amid distrust of the paladins.",
    "Tanis was found, frightened by the approach of a paladin.", "The errand reached the beggar; the help he needed was still to be learned.")
q(94434, "A Lesson in Divinity", "PALADIN", "Undercity", 12, PF,
    "Tanis needed fresh cloth to hold his wife together until an apothecary could tend to her.", "The apothecaries' other duties had left one Forsaken household waiting for help.",
    "Tanis received cloth for his wife's wrappings.", "A small act of service supplied the household while proper treatment remained pending.")
q(94435, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Tanis wanted his thanks carried back to the paladin who had sent help.", "The order sought to answer Forsaken suspicion through practical service.",
    "The charitable errand was acknowledged, and a Symbol was supplied for the next task.", "The report earned a Symbol of Life, with a further test still ahead.")
q(94436, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Deathguard Billmuth had petitioned the paladins for help after other priests turned him away.", "The Symbol of Life was to be carried to a deathguard seeking aid for a friend.",
    "Billmuth's appeal was heard; his friend's rescue had yet to be attempted.", "The errand reached the deathguard, who admitted how much depended on the offered help.")
q(94438, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Falgan had stayed behind when Scarlet scouts discovered the two deathguards in Venomweb Vale.", "Billmuth feared for the friend who had covered his escape from a Scarlet camp.",
    "The Symbol of Life restored Falgan, who confirmed plans for a Scarlet attack.", "Falgan returned and pointed to further work against the Crusaders' orders.", 5)
q(94440, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Scarlet deployment orders could give the Deathguard warning of the planned attack.", "Falgan asked for orders carried in the Crusaders' satchels to be taken to Billmuth.",
    "Billmuth received the plans and intended to prepare an ambush with his commander.", "The recovered orders gave the Deathguard warning; the planned ambush had not yet occurred.")
q(94441, "A Lesson in Divinity", "PALADIN", "Tirisfal Glades", 12, PF,
    "Billmuth sent thanks to Danitha Morr for the service rendered by Tyr's Watch.", "The final report linked the rescued deathguard with the paladins' work to earn their people's trust.",
    "Danitha bestowed redemption, teaching the resurrection of fallen companions.", "The completed service earned the gift of redemption from Tyr's Watch.", 6)
q(4485, "The Tome of Nobility", "PALADIN", "Stormwind City", 40, PN,
    "Further lessons awaited with Duthorian Rall at the Cathedral of Light.", "The summons directed an experienced paladin back to Stormwind's cathedral.",
    "Duthorian received the arrival and spoke of further threats requiring aid.", "The referral reached Duthorian; no mount or completed trial was part of this exchange.")

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
    "Quel'ana welcomed the arrival and prepared to begin instruction.", "The referral reached the trainer; no animal had yet been tamed in this errand.")
q(94013, "Taming the Beast", "HUNTER", "Zephras Isle", 10, HT,
    "The final Zephras trial called for a Vuldren Alpha in the Gustberry Lowlands.", "After two beasts, the trainer set a last practical test with a Vuldren Alpha.",
    "The alpha trial was complete, and the trainer offered instruction in a lasting animal bond.", "The final practice earned the next lesson in keeping an animal companion.", 5)
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
    "Ogtinc had left his tribe to aid the Cenarion Circle and teach experienced hunters.", "The furbolg teacher waited on Azshara's cliffs with a task involving hunting trophies.",
    "Ogtinc explained the charm to be assembled from fallen prey.", "The call reached Ogtinc, whose practical hunting tasks were still ahead.")
q(8232, "The Green Drake", "HUNTER", "Azshara", 52, "class_hunter_ogtinc",
    "Ogtinc wanted Morphaz's tooth from deep within the Temple of Atal'Hakkar.", "The drake's trophy was meant to represent what a hunter could accomplish with others.",
    "Morphaz's tooth completed Ogtinc's trial and earned a gift from his hunting days.", "The drake trophy reached Ogtinc, closing the dangerous final hunt.", 5)

local RS, RT, RZ = "class_rogue_si7", "class_rogue_training", "class_rogue_zanzil"
q(2205, "Seek out SI: 7", "ROGUE", "Stormwind City", 10, RS,
    "A package for Mathias Shaw served as an introduction to SI:7.", "The intelligence service had work for a recruit who could find its contact in Stormwind.",
    "The package reached Mathias, opening the possibility of an assignment.", "The introduction was made; a field operation was still to come.")
q(2206, "Snatch and Grab", "ROGUE", "Elwynn Forest", 10, RS,
    "Defias smugglers used Jerod's Landing to move contraband between Redridge and Westfall.", "SI:7 wanted the dockmaster's shipping schedule from the dock house.",
    "The schedule reached SI:7 and earned a blade from Mathias.", "The recovered shipping information gave the service evidence of the Defias route.")
q(2282, "Alther's Mill", "ROGUE", "Redridge Mountains", 20, RT,
    "Lucius kept a training chest at Alther's Mill with a token inside.", "The test required opening a lock at a mill where orcs had recently been seen.",
    "The token proved that the chest's lock had been opened.", "Lucius accepted the successful lock exercise as proof of practical skill.")
q(2360, "Mathias and the Defias", "ROGUE", "Westfall", 20, RS,
    "Agent Kearnen watched the Defias supply operation at an abandoned watchtower.", "Mathias needed another agent to make contact near the tower southeast of Sentinel Hill.",
    "Kearnen received the backup and prepared to explain the troubling operation.", "The contact was made outside the tower; the guarded chest still needed investigating.")
q(2359, "Klaven's Tower", "ROGUE", "Westfall", 24, RS,
    "A strange shipment from Duskwood had arrived with inhuman guards at the Defias tower.", "Kearnen needed the key and the contents of the chest under the abominations' guard.",
    "The recovered book linked the Defias drones to Zanzil's poisonous means of raising the dead.", "Mathias received evidence connecting the strange shipments with a recipe for undeath.", 5)
q(2607, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "The investigation had brought back a poisonous affliction along with its information.", "Mathias referred the search for a cure to Doc Mixilpixil in the cellar.",
    "The referral reached the doctor, who initially mistook the visitor for a delivery.", "The doctor was found; examination and a remedy were still ahead.")
q(2608, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "Doc Mixilpixil required a blood sample before treating the affliction.", "The cellar examination began with the doctor's plan to draw blood.",
    "The examination was complete, and the doctor conferred with his colleagues.", "The examination ended in a consultation among Doc Mixilpixil and his colleagues.")
q(2609, "The Touch of Zanzil", "ROGUE", "Stormwind City", 20, RZ,
    "The doctor's formula required wildflowers, a vial, a bronze tube and chartreuse thread.", "The unusual remedy depended on supplies from Stormwind's tradespeople.",
    "The reagents became a medicine the doctor handed over with instructions to apply it.", "The doctor prepared the remedy; its use was left to the recipient.")
q(8236, "The Azure Key", "ROGUE", "Alterac Mountains", 52, "class_rogue_ravenholdt",
    "Ravenholdt's recovered bag still lacked its key, held by Morphaz in the Sunken Temple.", "Xylem worked on the enchantment while the missing key had to be recovered from a green drake.",
    "The key reached Ravenholdt and earned a choice of enchanted garments.", "Ravenholdt regained the key to the bag already returned by Xylem.", 5)

local PS, PC = "class_priest_service", "class_priest_salve"
q(5622, "In Favor of Elune", "PRIEST", "Teldrassil", 4, PS,
    "Laurna Morninglight in Dolanaar was ready to continue a young priest's instruction.", "The referral from Shadowglen concerned the path toward the order's first garments.",
    "Laurna welcomed the arrival for instruction.", "The referral reached Dolanaar; earning the robes still required service.")
q(5621, "Garments of the Moon", "PRIEST", "Teldrassil", 4, PS,
    "Sentinel Shaya had been hurt patrolling south of Dolanaar.", "Laurna could not leave her students and asked for healing and fortification for the injured Sentinel.",
    "Shaya was healed and fortified, and the service earned a robe from Laurna.", "The Sentinel received aid, completing the practical test for the order's garments.")
q(5624, "Garments of the Light", "PRIEST", "Elwynn Forest", 4, PS,
    "Guard Roberts lay injured near the lake east of Goldshire.", "Josetta made helping the wounded guard the test for a priest's first robes.",
    "Roberts was healed and fortified, restoring a defender to the town.", "The completed aid earned Josetta's robe and recognition of the practical test.")
q(5625, "Garments of the Light", "PRIEST", "Dun Morogh", 4, PS,
    "Mountaineer Dolf was injured just south of Kharanos.", "Maxan placed the mountaineer's immediate need ahead of a formal test.",
    "Dolf received healing and Fortitude, and Maxan awarded the robe.", "A wounded mountaineer was helped, fulfilling the test for the church's garments.")
q(5650, "Garments of Darkness", "PRIEST", "Tirisfal Glades", 4, PS,
    "Deathguard Kel needed healing after defending the settlement from gnolls.", "The lesson required fortifying the wounded deathguard as well as mending his injuries.",
    "Kel was healed and fortified, completing the test for a robe of the order.", "The deathguard received the requested aid, and the successful service was recognized.")
q(94774, "Divine Grace", "PRIEST", "Stormwind City", 10, PS,
    "High Priestess Laurena requested a visit to the Cathedral of Light for further training.", "The summons called a developing priest back to Stormwind's cathedral.",
    "Laurena welcomed the arrival and prepared to begin further lessons.", "The call for instruction was answered; the next lesson was still ahead.")
q(8254, "Cenarion Aid", "PRIEST", "Azshara", 52, PC,
    "The Cenarion Circle needed help, and Ogtinc waited on Azshara's cliffs.", "The request directed a priest's service toward the Circle's work with the damaged land.",
    "Ogtinc received the offer of aid and explained that much remained to be done.", "The referral reached the Circle's contact, opening the practical work on a salve.")
q(8255, "Of Coursers We Know", "PRIEST", "Azshara", 52, PC,
    "Disease-resistant mosshoof coursers supplied a needed ingredient for a restorative salve.", "Ogtinc reluctantly requested glands from animals sacred to the Circle.",
    "The courser glands supplied the salve's first curative ingredient.", "One part of the remedy was gathered, at a cost to animals the Circle held sacred.")
q(8256, "The Ichor of Undeath", "PRIEST", "Azshara", 52, PC,
    "The salve's formula required a single measure of ichor of undeath.", "Ogtinc's restorative combined curative ingredients with a carefully limited poison.",
    "The ichor supplied the poisonous part of the formula.", "Another ingredient reached Ogtinc; the salve still lacked its final cure.")
q(8257, "Blood of Morphaz", "PRIEST", "Felwood", 52, PC,
    "Morphaz's resistance to poison and disease made his blood the final ingredient in the salve.", "Greta Mosshoof awaited the drake's blood while the earlier ingredients were carried onward.",
    "Morphaz's blood reached Greta, giving the Circle the means to begin its long work of healing Felwood.", "The formula was complete, but undoing Felwood's corruption remained a lifetime's work.", 5)

local MS = "class_mage_study"
q(1860, "Speak with Jennea", "MAGE", "Stormwind City", 10, MS,
    "Jennea Cannon needed help with a matter affecting Stormwind and Elwynn.", "The task's details awaited in the Wizard's Sanctum.",
    "Jennea received the offer of help and prepared to explain the work.", "The referral reached the sanctum, before any field investigation had begun.")
q(1861, "Mirror Lake", "MAGE", "Elwynn Forest", 10, MS,
    "Disturbed magical currents raised fears about the water below Mirror Lake's waterfall.", "Jennea needed a water sample before she could test for magical contamination.",
    "The water from below Mirror Lake's falls reached Jennea for tests of magical contamination.", "Mirror Lake's water was collected for study and earned a choice of an orb or staff.")
q(1880, "Mage-tastic Gizmonitor", "MAGE", "Dun Morogh", 10, MS,
    "A knowledge-storing gizmonitor had been left behind during the flight from Gnomeregan.", "The device lay in a chest outside the lost city, among leper gnomes.",
    "The recovered gizmonitor allowed its owner's studies to resume.", "The stored knowledge came back from the abandoned hut before the device's power was lost.")
q(1882, "The Balnir Farmstead", "MAGE", "Tirisfal Glades", 10, MS,
    "Forsaken mages wanted to measure the plague's spread through magically receptive snapdragons.", "Flowers at Balnir Farmstead could supply evidence of the taint reaching eastern Tirisfal.",
    "The snapdragons were collected for the apothecaries to study.", "A suitable specimen reached the mage, leaving the extent of the contamination for testing to establish.")
q(1884, "Ju-Ju Heaps", "MAGE", "Durotar", 10, MS,
    "Zalazane's fetishes disrupted magical currents around the Echo Isles.", "The tainted heaps strengthened hostile magic and corrupted the wildlife.",
    "The ju-ju heaps were destroyed, giving Durotar's magical currents a chance to recover.", "The fetishes' destruction removed a source of disruption, though recovery still required time.")
q(1952, "Mage's Wand", "MAGE", "Dustwallow Marsh", 40, MS,
    "The preparations had reached the point where the promised wands could be made.", "A choice of crafted wands awaited at the end of the work.",
    "The finished wands were offered for a choice of reward.", "The crafting was complete, and one of the prepared wands could be taken.")
q(8253, "Destroy Morphaz", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Morphaz had swallowed Xylem's apprentice together with a valuable arcane shard.", "The shard Xylem wanted lay inside a green drake in the Temple of Atal'Hakkar.",
    "The recovered shard had grown in power, restoring Xylem's ability to forge the arcane.", "Morphaz's death returned the shard and earned a creation from Xylem's renewed craft.", 5)
q(7463, "Arcane Refreshment", "MAGE", "Dire Maul", 60, MS,
    "Lydros wanted a sample of Hydrospawn's essence from the Warpwood Quarter.", "A water elemental in Eldre'Thalas was an anomaly the scholar wished to catalogue.",
    "The elemental essence reached Lydros, who supplied the promised magical reward.", "Hydrospawn's sample completed the errand for the scholar's cantrip.", 5)

local WB = "class_warlock_binding"
q(1470, "Piercing the Veil", "WARLOCK", "Tirisfal Glades", 3, WB,
    "Three rattlecage skulls were required before instruction in binding a servant.", "The skeletons near the abandoned smithy supplied the trainer's test of practical ability.",
    "The skulls earned a lesson in summoning and binding an imp.", "The completed errand led to instruction in commanding an imp.")
q(1598, "The Stolen Tome", "WARLOCK", "Elwynn Forest", 4, WB,
    "A novice who joined the Defias had stolen Powers of the Void from the abbey.", "The trainer wanted a protected library text now hidden in a vineyard tent.",
    "The recovered tome earned instruction in summoning an imp.", "The book reached the trainer, who judged the successful errand enough for the imp lesson.")
q(1478, "Halgar's Summons", "WARLOCK", "Undercity", 10, WB,
    "Carendin Halgar requested further training near the Temple of the Damned.", "The next warlock lesson awaited in the Undercity's Magic Quarter.",
    "Halgar received the summons' recipient and turned to the training still required.", "Halgar received the summons' recipient in the Magic Quarter and turned at once to further training.")
q(1506, "Gan'rul's Summons", "WARLOCK", "Orgrimmar", 10, WB,
    "Gan'rul wanted an immediate visit among the senior warlocks in the Cleft of Shadow.", "A summons interrupted other business for further warlock instruction.",
    "Gan'rul received the arrival and announced further training.", "The summons was answered, with the actual trial still ahead.")
q(1685, "Gakin's Summons", "WARLOCK", "Stormwind City", 10, WB,
    "Master Gakin taught discreetly beneath the Slaughtered Lamb.", "The summons directed a pupil to the tavern's basement for further training.",
    "Gakin received the arrival and pressed the need for more instruction.", "The referral reached the hidden training place before the next summoning trial.")
q(1473, "Creature of the Void", "WARLOCK", "Tirisfal Glades", 10, WB,
    "A Scarlet agent had stolen Egalin's grimoire describing the first voidwalker summoning.", "The missing book lay at a tower west of the warlocks' contact.",
    "The grimoire was recovered for study; the voidwalker still had to be subdued.", "Egalin's writing returned to the warlocks, supplying the spell's structure for the coming trial.")
q(1501, "Creature of the Void", "WARLOCK", "Durotar", 11, WB,
    "Burning Blade warlocks kept the stolen Tablet of Verga in Skull Rock.", "The tablet's glyphs were needed before a voidwalker could be summoned for the trial.",
    "The Tablet of Verga was recovered from the Burning Blade.", "The summoning text returned, but the trial against the voidwalker remained ahead.")
q(1688, "Surena Caledon", "WARLOCK", "Elwynn Forest", 10, WB,
    "Gakin wanted the bloodstone choker he had given his former student Surena.", "Surena had left with a Defias companion and could be found at Brackwell Pumpkin Patch.",
    "The choker was recovered, establishing readiness for Gakin's next test.", "Surena was bested and the bloodstone returned; the voidwalker trial was still to come.")
local function binding(id, zone, level, demon, implement, lesson)
    q(id, "The Binding", "WARLOCK", zone, level, WB,
        "The summoning circle required " .. implement .. " to call forth " .. demon .. ".",
        "The trial demanded that " .. demon .. " be subdued before the trainer would offer further instruction.",
        lesson and "The summoned " .. demon:gsub("^an? ", "") .. " was overcome, earning instruction in calling it forth." or "The felhunter was overcome, completing the summoning trial before Strahad.",
        lesson and "The successful binding led to the trainer's lesson in commanding " .. demon .. "." or "Strahad acknowledged the successful confrontation with the felhunter.", 5)
end
binding(1471, "Undercity", 10, "a voidwalker", "the prepared runes", true)
binding(1504, "Orgrimmar", 11, "a voidwalker", "the Tablet of Verga's glyphs", true)
binding(1689, "Stormwind City", 10, "a voidwalker", "the bloodstone choker", true)
binding(1474, "Undercity", 20, "a succubus", "the collected hearts", true)
binding(1739, "Stormwind City", 20, "a succubus", "a heartswood core", true)
binding(1795, "The Barrens", 30, "a felhunter", "the Tome of the Cabal and the acolytes' help", false)
binding(65597, "Undercity", 20, "an incubus", "the collected hearts", true)
binding(65603, "Stormwind City", 20, "an incubus", "the prepared figurine", true)
binding(65604, "Orgrimmar", 20, "an incubus", "the scarf carrying its owner's feelings", true)
q(1738, "Heartswood", "WARLOCK", "Ashenvale", 20, WB,
    "The heartswood at Ordil'Aran had grown where two lovers fell in the War of the Ancients.", "Its association with enduring love made the tree's core a lure for a succubus.",
    "The heartswood core was delivered for preparation.", "The summoning material was gathered; the succubus had yet to be called and challenged.")
q(7631, "Dreadsteed of Xoroth", "WARLOCK", "Dire Maul", 60, "class_warlock_dreadsteed",
    "The prepared ritual could open a portal to Xoroth through a Circle of Greater Summoning.", "Xorothian stardust and exact ritual preparations made the dreadsteed's summoning possible.",
    "The dreadsteed's spirit was defeated and imparted the knowledge to summon its kind.", "The completed ritual and confrontation earned the knowledge of dreadsteed summoning.", 6)

local DC, DW, DP = "class_druid_claw", "class_druid_water", "class_druid_poison"
q(6001, "Body and Heart", "DRUID", "Darkshore", 10, DC,
    "Cenarion Moondust would call Lunaclaw at the Moonkin Stone east of Auberdine.", "The Claw's trial required facing the defender of a moonkin cave's sacred stone.",
    "The challenge was passed, and the trainer offered the teaching of the Claw.", "Lunaclaw's test was complete, clearing the way for the trainer's instruction.", 5)
q(6002, "Body and Heart", "DRUID", "The Barrens", 10, DC,
    "Cenarion Lunardust would call Lunaclaw at the stone west of Taurajo.", "The stone near Mulgore's border held a test of the strength required by the Claw.",
    "The trial was passed, and the trainer offered the teaching of the Claw.", "The challenge at the Moonkin Stone was complete, opening the next lesson.", 5)
q(28, "Trial of the Lake", "DRUID", "Moonglade", 16, DW,
    "A rapidly fading bauble had to be carried from Lake Elune'ara to the Shrine of Remulos.", "The lake's trial tested speed and endurance before the bauble lost its power.",
    "The bauble was used at the shrine, and Tajarri acknowledged the completed trial.", "The lake trial was passed; the sea lion's other lessons still lay ahead.")
q(30, "Trial of the Sea Lion", "DRUID", "Moonglade", 16, DW,
    "The pendant's two halves represented the sea lion's agility and endurance.", "The trial required gathering both halves and joining them before Dendrite's inspection.",
    "The completed pendant passed Dendrite's inspection, finishing the trial.", "The sea lion's pendant was assembled, leaving the final instruction to the trainer.")
q(31, "Aquatic Form", "DRUID", "Thunder Bluff", 16, DW,
    "Turak Runetotem awaited the pendant as evidence of the lessons completed in Moonglade.", "The final return to Thunder Bluff would turn the trials' preparation into aquatic instruction.",
    "Turak accepted the pendant and taught the aquatic form.", "The return completed the training, earning the ability to take an aquatic aspect.", 6)
q(5061, "Aquatic Form", "DRUID", "Darnassus", 16, DW,
    "Mathrengyl Bearwalker awaited the pendant as proof of the Moonglade trials.", "The final lesson in the aquatic aspect required returning to the trainer in Darnassus.",
    "Mathrengyl accepted the pendant and taught the aquatic form.", "The return to Darnassus completed the aquatic training.", 6)
q(6123, "Gathering the Cure", "DRUID", "Darkshore", 14, DP,
    "Earthroot and lunar fungus were needed for a salve to treat Darkshore's sick deer.", "The cure needed herbs and fungus from the moonkin caves, in addition to its water base.",
    "The ingredients supplied enough material to begin making the salve.", "The remedy could be prepared, but the deer still needed treatment.")
q(6124, "Curing the Sick", "DRUID", "Darkshore", 14, DP,
    "Ten doses of salve were ready for Darkshore's afflicted deer.", "The practical lesson called for administering a prepared remedy to the sick wildlife.",
    "The deer were treated, and Dendrite acknowledged the service to Darkshore.", "Dendrite praised the care given to Darkshore's deer and warned of the corruption spreading through the land.")
q(6125, "Power over Poison", "DRUID", "Darnassus", 14, DP,
    "The work with ordinary antidotes was preparation for Mathrengyl's lesson in curing poison.", "The final return concerned a lasting power beyond gathering ingredients for each remedy.",
    "Mathrengyl taught the power to cure poison after the practical service.", "The completed lesson earned permanent instruction against poisonous afflictions.", 5)
q(6128, "Gathering the Cure", "DRUID", "The Barrens", 14, DP,
    "Tonga needed earthroot and intact kodo horns for the gazelles' salve.", "The sampled water required curative ingredients before it could become a useful remedy.",
    "The gathered materials allowed Tonga to prepare the salve.", "The ingredients were ready; the sick gazelles had yet to receive treatment.")
q(6129, "Curing the Sick", "DRUID", "The Barrens", 14, DP,
    "Ten doses of salve were available for the sick gazelles of the northern Barrens.", "The Circle's practical lesson required treating afflicted wildlife beyond the Crossroads.",
    "The gazelles were treated, earning Dendrite's acknowledgment of the service.", "The salve relieved sick animals while the greater source of corruption remained.")
q(6130, "Power over Poison", "DRUID", "Thunder Bluff", 14, DP,
    "Turak awaited the return from the practical work against the gazelles' poisoning.", "The antidote lesson was to end with permanent instruction at Thunder Bluff.",
    "Turak taught the power to cure poison after the work at the Crossroads.", "The final return earned instruction beyond the use of prepared salves.", 5)
q(94006, "The Great Ursera Spirit", "DRUID", "Zephras Isle", 10, DC,
    "Urs'endris taught the ursera shape near the waterfall below the Shrine of Akir.", "The great spirit's domain was withering along with other parts of Zephras.",
    "Urs'endris welcomed the inquiry and began a discussion of the Claw.", "Urs'endris agreed to speak about the way of the Claw.")
q(94911, "Child of Nature", "DRUID", "Thunder Bluff", 10, DC,
    "Turak Runetotem could introduce a druid from Zephras to the Cenarion Circle.", "The referral pointed toward Thunder Bluff before the journey to Moonglade.",
    "Turak welcomed the visitor to Azeroth and spoke of the Circle's wisdom.", "The introduction reached Thunder Bluff; travel to Moonglade remained a further step.")
q(94912, "Child of Nature", "DRUID", "Stormwind City", 10, DC,
    "Sheldras Moontree could introduce a Skyborne druid to the Cenarion Circle.", "The referral led to Stormwind for guidance toward Moonglade.",
    "Sheldras welcomed the visitor and described the Circle's knowledge.", "The introduction was made in Stormwind, before the further journey to Moonglade.")

-- Additional staged source review: the level-52 temple requests begin with
-- errands in the open world; finding an instructor is not passing the trial.
P.threads.class_shaman_spirits = "Bath'rah's troubled spirits"
P.threads.class_paladin_mightstone = "the forging of a Holy Mightstone"
P.threads.class_warlock_impsy = "Impsy's own pet"
q(1740, "The Orb of Soran'ruk", "WARLOCK", "The Barrens", 25, WB,
    "Doan sought pieces of a demon-spirit orb from Blackfathom Deeps and Shadowfang Keep.", "Even broken, Soran'ruk's orb retained power that Doan believed he could restore.",
    "The recovered pieces were sufficient for Doan to reconstruct the orb in a chosen form.", "The two dungeon searches supplied Doan's study and the promised restoration of Soran'ruk's orb.")
q(8417, "A Troubled Spirit", "WARRIOR", "Blasted Lands", 52, W,
    "A former Horde hero remained troubled after death and might receive a warrior willing to help.", "The referral led to a spirit whose honor and suffering had outlasted his body.",
    "The spirit received the visitor and explained that ending his pain would not be simple.", "The introduction reached the fallen hero, with his requests still ahead.")
q(8423, "Warrior Kinship", "WARRIOR", "Blasted Lands", 52, W,
    "The fallen hero tested strength through the helboars before entrusting an honorable task.", "A hunt among the Blasted Lands' burning beasts served as the spirit's first measure of a warrior.",
    "The hero recognized the determination proved by the helboar hunt.", "The strength test was acknowledged, opening further service to the troubled spirit.")
q(8424, "War on the Shadowsworn", "WARRIOR", "Blasted Lands", 52, W,
    "The Shadowsworn's rituals caused the fallen hero torment even after death.", "The spirit asked for an attack on the spellcasters whose presence deepened his suffering.",
    "The action against the Shadowsworn eased the hero's pain and earned his thanks.", "The spirit felt relief from the assault on those responsible for his continuing agony.")
local PM = "class_paladin_mightstone"
q(8415, "Chillwind Point", "PALADIN", "Western Plaguelands", 52, PM,
    "Commander Valorfist called for a paladin to assist the campaign at Chillwind Point.", "The summons offered service against the undead in the Western Plaguelands.",
    "Valorfist received the paladin and prepared to set a practical test.", "The call was answered at Chillwind, before the commander's assignments began.")
q(8414, "Dispelling Evil", "PALADIN", "Western Plaguelands", 52, PM,
    "Scourgestones were to be carried to High Priest Thel'danis near Uther's Tomb.", "The campaign needed stones gathered under the Argent Dawn's commission for a cleansing ritual.",
    "The stones reached Thel'danis, who warned that dispelling their evil could attract undead.", "The high priest received the materials and explained the danger attending their purification.")
q(8416, "Inert Scourgestones", "PALADIN", "Western Plaguelands", 52, PM,
    "Thel'danis had purged the stones and asked that one be returned to Commander Valorfist.", "The cleansed stone was a component of a plan against the Scourge that the commander had yet to explain fully.",
    "Valorfist accepted the inert stone and offered to reveal more of the plan.", "The delivery earned the commander's trust, with the weapon's completion still ahead.")
q(8418, "Forging the Mightstone", "PALADIN", "Western Plaguelands", 52, PM,
    "Sunken Temple magic was needed to turn the inert scourgestones into a weapon against the undead.", "The temple's six named trolls held the rare power sought for a Holy Mightstone.",
    "The completed temple assignment earned a Holy Mightstone from the commander.", "The final components secured the promised weapon for use against the Scourge.", 5)
q(8233, "A Simple Request", "ROGUE", "Alterac Mountains", 52, "class_rogue_ravenholdt",
    "Lord Jorach Ravenholdt requested a private meeting about a matter kept secret by the messenger.", "The summons led to Ravenholdt Manor for a personal request from its lord.",
    "Jorach explained that something precious had been lost and offered a reward for its recovery.", "At Ravenholdt Manor, Jorach offered a reward for the return of something dear to him.")
q(8234, "Sealed Azure Bag", "ROGUE", "Azshara", 52, "class_rogue_ravenholdt",
    "Thieves had sold Jorach's sealed blue bag to Timbermaw shamans as a holy relic.", "The recovery required bringing the bag to Archmage Xylem while its private contents remained sealed.",
    "Xylem recognized Lord Ravenholdt's recovered bag.", "The missing bag reached the archmage, with its enchantment still to be addressed.")
q(8235, "Encoded Fragments", "ROGUE", "Azshara", 52, "class_rogue_ravenholdt",
    "Xylem needed fragments of destroyed books to work on removing the bag's enchantment.", "Forest oozes might have preserved pieces of the archmage's lost writings on dispelling.",
    "Xylem accepted useful fragments for reconstructing his books.", "The fragments returned pieces of Xylem's lost writings on dispelling to his hands.")
q(8250, "Magecraft", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Xylem sought an experienced mage, and his tower could be reached through Sanath's teleportation.", "The referral required finding the servant below the archmage's high tower in Azshara.",
    "Sanath confirmed that Xylem awaited the visitor.", "The approach reached the tower's gatekeeper, before Xylem's practical requests.")
q(8251, "Magic Dust", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Xylem wanted the unusual dust made by Azshara's blood elves from magical objects.", "The death of an apprentice sent to trade had turned the archmage's request into a violent collection.",
    "The glittering dust was delivered, earning Xylem's approval.", "The research gained the material Xylem's earlier trading attempt had failed to obtain.")
q(8252, "The Siren's Coral", "MAGE", "Azshara", 52, "class_mage_xylem",
    "Spitelash sirens had gathered enchanted coral that Xylem needed for research.", "The archmage wanted a rare local component now difficult to find freely in the bay.",
    "Xylem accepted the coral and judged the work worthy of a further test.", "The enchanted coral earned Xylem's praise and his suggestion of a more demanding test.")
local SS = "class_shaman_spirits"
q(8410, "Elemental Mastery", "SHAMAN", "Alterac Mountains", 52, SS,
    "Bath'rah called for a shaman to bring samples of the elements as evidence of readiness.", "The Windwatcher's summons asked for elemental materials before a further discussion.",
    "Bath'rah accepted the elemental samples and agreed to continue the conversation.", "The materials answered the Windwatcher's first request, with his need still to be explained.")
q(8411, "Mastering the Elements", "SHAMAN", "Alterac Mountains", 52, SS,
    "Bath'rah required the elemental samples before proceeding with his request.", "The Windwatcher would discuss the task once the needed elements were supplied.",
    "The elements reached Bath'rah, who was ready to talk further.", "The collection requirement was satisfied before the work on his protection began.")
q(8412, "Spirit Totem", "SHAMAN", "Western Plaguelands", 52, SS,
    "Bath'rah feared the local spirits and wanted a protective totem made with primal materials.", "Bear claws and spider eyes from the Plaguelands were needed alongside the gathered elements.",
    "The components reached Bath'rah, who was ready to try the totem.", "The primal materials completed this preparation, leaving the protection's adequacy untested.")
q(8413, "Da Voodoo", "SHAMAN", "The Temple of Atal'Hakkar", 52, SS,
    "The first spirit totem proved insufficient, so Bath'rah sought the temple trolls' magical feathers.", "Voodoo power from six named trolls was needed to strengthen the Windwatcher's protection.",
    "Bath'rah considered the strengthened spirit totem ready to guard him and offered a reward.", "The feathers completed the protection that the earlier totem had lacked.", 5)
local WI = "class_warlock_impsy"
q(8419, "An Imp's Request", "WARLOCK", "Felwood", 52, WI,
    "Impsy requested a warlock's presence with a piece of felcloth as a token of good faith.", "Felwood's satyrs carried the cloth sought by Niby's imp near Bloodvenom Falls.",
    "Impsy delighted in the delivered felcloth.", "The cloth satisfied the imp's opening request, before the rest of his project was supplied.")
q(8420, "Hot and Itchy", "WARLOCK", "Felwood", 52, WI,
    "Impsy wanted a pet of his own and proposed making one from felcloth.", "The imp resented having no companion of his own and needed fabric to begin his creation.",
    "Impsy accepted the cloth with delight.", "The pet project gained its first material, leaving the doll unfinished.")
q(8421, "The Wrong Stuff", "WARLOCK", "Felwood", 52, WI,
    "Impsy wanted rotting wood for his pet's carved eyes and bloodvenom essence for its scent.", "The doll required materials from Irontree creatures and the tainted oozes near the imp's camp.",
    "Impsy received the wood and essence for his creation.", "The pet gained the ingredients for its eyes and scent, while stuffing was still required.")
q(8422, "Trolls of a Feather", "WARLOCK", "The Temple of Atal'Hakkar", 52, WI,
    "The nearly finished doll needed magical feathers from the Sunken Temple's six named trolls.", "Impsy promised something of Niby's in return for the stuffing that would finish his own pet.",
    "Impsy stuffed and embraced the completed doll, noticing an odd effect from the feathers.", "The temple materials finished the imp's pet and produced an unexpected magical side effect.", 5)

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
    "The maddened owl beasts' blood reached Mor'zul. He would have it made into ink, and had heard its taste was euphoric.", 3)
q(7564, "Wildeyes", "WARLOCK", "Burning Steppes", 58, WD,
    "Mor'zul's servant Gorzeeki, an alchemist of some skill, was to prepare the ink. The gathered blood went to him.",
    "Gorzeeki Wildeyes would turn Mor'zul's blood into the ink for the glyph parchment.",
    "Gorzeeki, who preferred his blood still warm in a rodent, recognized Mor'zul's work. A dreadsteed ritual, he said with delight, would need far more than blood.",
    "Gorzeeki Wildeyes took the blood and guessed its purpose. If a dreadsteed was to be summoned, the ritual would need much more.", 3)
q(7623, "Lord Banehollow", "WARLOCK", "Felwood", 58, WD,
    "Opening a portal to Xoroth required Xorothian stardust. The only source Gorzeeki knew was Lord Banehollow in Jaedenar, seat of the Shadow Council, and getting in meant buying his shadowy potions.",
    "Xorothian stardust was rare on Azeroth. Gorzeeki's potions would cloak a visitor in the Shadow Council's own evil long enough to reach Lord Banehollow.",
    "Lord Banehollow received the visitor with contempt. His patience spanned millennia, he said, but his time did not.",
    "In Jaedenar, Lord Banehollow granted an audience and warned that it would be brief.", 3)
q(7624, "Ulathek the Traitor", "WARLOCK", "Felwood", 58, WD,
    "Banehollow wanted proof of loyalty. His servant Ulathek was spying for Lord Hel'nurath of Xoroth, and Banehollow wanted the traitor confronted in Shadow Hold and his heart brought back.",
    "Ulathek groveled before Banehollow while plotting with his rival Hel'nurath. Banehollow asked for the spy's heart as the price of his favor.",
    "Banehollow savored the traitor's heart and meant to let it rot a week first. His patience for the newcomer had grown, he said, marginally.",
    "Ulathek was dead and his heart delivered. Lord Banehollow was pleased, by his own account only slightly.", 4)
q(7625, "Xorothian Stardust", "WARLOCK", "Burning Steppes", 60, WD,
    "Banehollow knew the stardust was wanted to open a portal to Xoroth, the domain of his rival Hel'nurath. His servant Ur'dan would provide it, if the price was paid.",
    "Stealing a dreadsteed from Hel'nurath amused Lord Banehollow. He sent the buyer to his servant Ur'dan, who kept a supply of Xorothian stardust.",
    "Gorzeeki could hardly believe the stardust had been obtained. Now Mor'zul could finish the glyph parchment that would open a portal to Xoroth.",
    "The Xorothian stardust reached Gorzeeki, who guessed it had cost a large sum, a bargain with the dreadlord, or both.", 4)
q(7626, "Bell of Dethmoora", "WARLOCK", "Burning Steppes", 60, WD,
    "A Circle of Greater Summoning needed three tools. The first, a bell named for the late warlock Dethmoora Darkeyes, could be built by Gorzeeki only from a large supply of elixirs of shadow power.",
    "Gorzeeki could make a Bell of Dethmoora to conduct the circle's arcane power, but it took many elixirs of shadow power from an alchemist.",
    "Gorzeeki took the elixirs and set about making the bell, to keep until the ritual.",
    "The elixirs of shadow power reached Gorzeeki, who grumbled about miserly alchemists and began the Bell of Dethmoora.", 3)
q(7627, "Wheel of the Black March", "WARLOCK", "Burning Steppes", 60, WD,
    "The Wheel of the Black March would contain and direct the circle's violent energies. Gorzeeki needed large brilliant shards from an enchanter and dark iron ore from a master miner.",
    "For the second tool of the circle, Gorzeeki asked for enchanted shards and dark iron ore from the depths of Blackrock.",
    "Gorzeeki marveled at a warlock's dedication, then confessed he would rather see it spent on catching bugs. He began the wheel.",
    "With the shards and dark iron ore in hand, Gorzeeki started on the Wheel of the Black March.", 3)
q(7628, "Doomsday Candle", "WARLOCK", "Burning Steppes", 60, WD,
    "A Doomsday Candle would burn any wayward demon that disrupted the ritual. Containing its fire required the essence in black dragon scales.",
    "The third tool of the circle stored fire. Gorzeeki needed black dragonscales from a skinner before he dared start it.",
    "Gorzeeki had his dragonscales and could make the candle without blowing up the camp.",
    "The black dragonscales reached Gorzeeki, who would contain the candle's fire with them and keep it until the ritual.", 3)
q(7629, "Imp Delivery", "WARLOCK", "Burning Steppes", 60, WD,
    "Mor'zul's parchment needed paper infused with Xorothian stardust, and only the alchemy lab in Scholomance had the equipment. Gorzeeki lent a jar holding a clever imp to do the work there.",
    "Gorzeeki could not travel to Caer Darrow himself. The imp in his jar could infuse the parchment, once released in Scholomance's alchemy lab.",
    "The imp J'eevee had made the parchment. Gorzeeki asked after Scholomance's bugs and took back his jar, which was not for sale.",
    "The infused parchment came back from Scholomance along with Gorzeeki's old jar.", 4)
q(7630, "Arcanite", "WARLOCK", "Burning Steppes", 60, WD,
    "With the bell, wheel and candle made, Gorzeeki wanted a black lodestone to sustain them if they failed during the ritual. The lodestone required arcanite.",
    "A black lodestone would keep the ritual from fizzling out. Gorzeeki could make one, given arcanite from an alchemist.",
    "Gorzeeki had his arcanite and could make the lodestone that would keep the ritual from failing.",
    "The arcanite reached Gorzeeki, completing the materials for the Circle of Greater Summoning.", 3)
q(7601, "What Niby Commands", "WARLOCK", "Felwood", 50, WN,
    "Niby the Almighty would teach the summoning of an infernal servant once he had the infernal core of Kroshius. Kroshius had all but burned out and had to be raised from the rubble first; Niby's imp, Impsy, would explain.",
    "To learn the infernal summoning, Niby wanted Kroshius destroyed. That meant first reigniting the demon's burned-out corpse, and Impsy knew how.",
    "Impsy greeted the newcomer with weary resignation.",
    "Niby's imp received his master's next student with a sigh, as if he had seen it all before.", 3)
q(7602, "Flawless Fel Essence", "WARLOCK", "Felwood", 55, WN,
    "Reanimating Kroshius needed fel fire, and Impsy could make it from three flawless fel essences, from the Legashi satyrs of Azshara, the legionnaires of Jaedenar and the felguard sentries of the Blasted Lands.",
    "Impsy's fel fire called for essences from three distinct regions. He also confided that Niby was daft.",
    "Impsy took the three essences and combined them into fel fire.",
    "The three essences reached Impsy, who began making fel fire.", 3)
q(7603, "Kroshius' Infernal Core", "WARLOCK", "Felwood", 55, WN,
    "Fel fire set on the remains of Kroshius in Shatter Scar Vale would reanimate the fallen infernal. Impsy fully expected him to kill whoever tried, and advised bringing friends.",
    "Kroshius lay in a heap to the northeast. Raised with fel fire, he would have to be killed again for his infernal core.",
    "Kroshius's infernal core reached Niby. A deal was a deal, he said, and he hurried to hand over the knowledge before his own greatest conjuration began.",
    "Niby received the core and kept his side of the bargain, though he was in a great hurry.", 5)
q(7581, "The Prison's Bindings", "WARLOCK", "Blasted Lands", 60, WG,
    "A Doomguard could be held only by a crystal prison of special make. Its bindings had to come from lesser demons, the Wildspawn satyrs of Dire Maul, whose blood would bond the Hederine shards.",
    "Daio the Decrepit needed coagulated blood from the Wildspawn satyrs of Dire Maul to bind his crystal prison.",
    "Daio judged the blood an excellent recovery. It would suppress the Doomguard's magical defenses.",
    "The Wildspawn blood reached Daio, who meant to use it against the Doomguard's magic.", 3)
q(7582, "The Prison's Casing", "WARLOCK", "Blasted Lands", 60, WG,
    "The Hederine of Darkwhisper Gorge in Winterspring secreted fel poisons that hardened into anti-magic crystals, the Tears of the Hederine. Not even a Doomguard could break a prison made of them.",
    "Daio's prison needed walls of the Tears of the Hederine, crystals the demons of Darkwhisper Gorge would not give up without a fight.",
    "Daio had the Tears and needed only to combine them with the Wildspawn blood for the prison to be ready.",
    "The Tears of the Hederine reached Daio. With the satyr blood, they would make the crystal prison.", 3)
q(7583, "Suppression", "WARLOCK", "Blasted Lands", 60, WG,
    "The prison was ready. A Doomguard Commander in the Tainted Scar had to be captured in it, and Daio warned that the demon would turn all its fury on the one performing the ritual.",
    "Daio called the capture the hardest part. A cornered Doomguard Commander would flail and strike at its captor, and companions would be needed to stay alive.",
    "The Doomguard was imprisoned. Daio declared the warlock ready for the knowledge to conjure and control such a beast.",
    "With a Doomguard Commander captured in the crystal, Daio judged the task done and offered the knowledge to summon one.", 5)
P.questIDs[7583].highlight = {"A Doomguard Commander was captured in Daio's crystal prison, and Daio offered the knowledge to conjure and control one.",
    "Daio's prison held a Doomguard Commander from the Tainted Scar. The warlock, he said, was now ready to command such a beast."}
P.questIDs[7603].highlight = {"Kroshius was raised with fel fire and destroyed. Niby took the infernal core and, in a hurry, kept his side of the bargain.",
    "The infernal core of Kroshius reached Niby, who handed over the promised knowledge before his own conjuration."}
for _, id in ipairs({7562, 7563, 7564, 7623, 7624, 7625, 7626, 7627, 7628, 7629, 7630, 7601, 7602, 7603, 7581, 7582, 7583}) do
    P.questIDs[id].source[2] = "https://classicdb.ch/?quest=" .. id
end

-- Shared-title outcomes are never copied from a convenient last stage. Several
-- Forever titles that look like trials are only referrals, notably 94007.
local shared = {
    ["The Tome of Divinity"] = true, ["The Tome of Nobility"] = true,
    ["A Lesson in Divinity"] = true, ["Taming the Beast"] = true, ["Training the Beast"] = true,
    ["The Touch of Zanzil"] = true, ["Alther's Mill"] = true, ["Garments of the Light"] = true, ["Divine Grace"] = true,
    ["Gakin's Summons"] = true, ["Creature of the Void"] = true, ["The Binding"] = true,
    ["Body and Heart"] = true, ["Trial of the Lake"] = true, ["Trial of the Sea Lion"] = true,
    ["Aquatic Form"] = true, ["Gathering the Cure"] = true, ["Curing the Sick"] = true,
    ["Power over Poison"] = true, ["Child of Nature"] = true,
}
for _, e in pairs(P.questIDs) do if not shared[e.title] then P.quests[e.title] = e end end
local function fallback(title, id, w1, w2, a1, a2)
    local e = P.questIDs[id]
    P.quests[title] = {class = e.class, zone = false, level = e.level, importance = e.importance,
        thread = e.thread, threadLabel = e.threadLabel, covers = false,
        why = {w1, w2}, after = {a1, a2}, source = {"corpus_vanilla_quests.txt: all entries titled " .. title}}
    -- No guessed zone: the same title can span distant cities and factions.
end
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
fallback("Child of Nature", 94911,
    "The Cenarion Circle offered further knowledge to druids newly arrived from Zephras.", "A mainland trainer could introduce a visitor to the Circle's work.",
    "The introduction was made, opening the way toward further instruction.", "The referral reached a welcoming druid, before the journey to Moonglade.")

-- Coverage is deliberately representative: class membership never selects these
-- entries on its own. Unwritten areas include most armor/weapon crafting chains,
-- priest racial spell quests without complete reward evidence, paladin epic-mount
-- stages, Rhok'delar and most advanced druid adventures. The 1661 source does not
-- name its reward; it remains under the safe Nobility fallback. Moonglade entry
-- quests and shaman trials are authored by their respective regional packs.
A.Lore.RegisterStoryPack("class-stories", P)
