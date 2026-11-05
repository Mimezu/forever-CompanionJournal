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

-- Batch 6: the paladin's charger and the hunter's ancients in Felwood. The
-- charger is claimed only by 7647's completion; the barding, feed and scryer
-- stages prepare it. The bow of Ancients is never finished by any single
-- stage here: 7636 gives the stave, 7635 the string, 7634 the quiver.
P.threads.class_paladin_charger = "the redemption of a fallen charger"
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
    "The coin given in Ironforge helped Rohan replace his censer and refill the reserves of food for the poor. He blessed the censer thrice for its new use.", 3)
q(7639, "To Show Due Judgment", "PALADIN", "Stormwind City", 60, PC2,
    "Rohan gave his censer with his blessing. He had used it in several exorcisms himself, and Grayson was waiting for it in Stormwind.",
    "With Rohan's exorcism censer in hand, the next step lay with Lord Grayson Shadowbreaker in Stormwind.",
    "Grayson accepted the censer as proof of sacrifice. Next would come judgment, and the censer would carry it to the tortured spirits of lost lands.",
    "The censer reached Grayson, who called sacrifice central to a paladin's duty. He would use it next to pass judgment on restless spirits.", 3)
q(7640, "Exorcising Terrordale", "PALADIN", "Stormwind City", 60, PC2,
    "Grayson added a pinch of tainted earth from Terrordale to the censer. Green auras in the Eastern Plaguelands marked where tormented spirits troubled the ground, and the censer would drive them out.",
    "In Terrordale, the physical world buckled under the torment of the spirit realm. Grayson's censer would pass judgment there.",
    "Grayson praised the judgments rendered in Terrordale. Next, he said, came the effort to reclaim the spirit of a fallen charger that now served the death knight Darkreaver.",
    "Terrordale's spirits had been judged. Grayson named the path ahead, to a fallen charger bound to the death knight Darkreaver.", 4)
q(7641, "The Work of Grimand Elmore", "PALADIN", "Stormwind City", 60, PC2,
    "A charger without barding was a pack animal, Grayson said, and this barding had to be attuned to the spirit realm. Grimand Elmore in the Dwarven District was among the finest craftsmen alive.",
    "Grayson recommended Grimand Elmore of Stormwind's Dwarven District, for barding of the finest quality at no small price.",
    "Grimand had expected the visit. He agreed to make the barding, warned it would be neither cheap nor easy, and claimed none better could be found in Azeroth.",
    "Grimand Elmore promised barding unmatched anywhere, and said plainly that it would cost a great deal.", 3)
q(7642, "Collection of Goods", "PALADIN", "Stormwind City", 60, PC2,
    "Grimand's barding needed runecloth for the lining, arcanite bars for the plating, Arthas' Tears for attunement and Stratholme holy water for imbuement, plus gold for his fee, saddle and stirrups included.",
    "Five things stood between Grimand and finished barding, four materials from across the Plaguelands and the forge, and his fee.",
    "Grimand found everything he had asked for and set to finishing the barding.",
    "The runecloth, arcanite, Arthas' Tears, holy water and gold reached Grimand, who admired the resourcefulness and went to work.", 3)
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
    "The Silver Hand had called Merideth Carlson of Southshore mad for claiming that spirit horses could be fed. The feed would be made, for Enriched Manna Biscuits from the Argent Dawn and gold as payment for years of mockery.",
    "Merideth Carlson could nourish spirit horses and wanted the paladins to pay for the old mockery. The price was Argent Dawn biscuits and gold.",
    "Payment for wrongs others had committed took Merideth by surprise. An offer of free feed in future followed, though the gold stayed in Southshore.",
    "The biscuits and gold reached Merideth Carlson, who answered the sacrifice with a promise of free feed in future and kept the money.", 3)
q(7644, "Blessed Arcanite Barding", "PALADIN", "Stormwind City", 60, PC2,
    "On the Ancient Equine Spirit's back the barding glowed, and the air thickened with power. Then it was blessed and ready to return to Grayson.",
    "The horse spirit's blessing had passed into the barding. Grayson wanted it brought back to Stormwind.",
    "Grayson declared the barding ready to harness the charger once its redemption was done. One last item remained to be made before the struggle ahead.",
    "The blessed barding reached Grayson. The great trial was near, he said, with one more thing still to make.", 4)
q(7646, "The Divination Scryer", "PALADIN", "Stormwind City", 60, PC2,
    "The censer from Terrordale would be the heart of a Divination Scryer, and Grayson would build its housing. The scryer needed two diamonds, an Azerothian and a Pristine Black, to pierce the shadows.",
    "Grayson called the scryer the last worldly sacrifice before the trial. Two diamonds, one bright and one black, would complete it.",
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
    "The sinew reached Stoma, who began making it into a nearly indestructible bowstring.", 4)
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
    "The Forsaken had captured a Scourge champion, Ulag the Cleaver, whose mind was free but still enthralled by the Lich King. Every attempt to break that hold had failed, so the skull stone by the mausoleum would lift his seal, and he was to be killed.",
    "Dillinger could not free Ulag from the Lich King's control. What remained was to open the mausoleum's seal and kill him.",
    "Ulag was dead. Dillinger said he had been no minor agent of the Scourge, and that the deed proved a warrior worthy of further instruction.",
    "Ulag the Cleaver fell outside the mausoleum, and the Deathguards counted it proof of skill and resolve.", 5)
q(1820, "Speak with Coleman", "WARRIOR", "Tirisfal Glades", 10, WBR,
    "Coleman Farthing, in the Gallow's End Tavern in eastern Brill, wanted a warrior to be his instrument of revenge against the Forsaken's enemies.",
    "Having proved their worth to the Dark Lady, a warrior could now serve one of her subjects. Coleman Farthing waited at the Gallow's End.",
    "Coleman admitted his means were small, but his task would serve both him and the Forsaken, and pay twice over.",
    "At the Gallow's End Tavern, Coleman Farthing explained that his revenge and the Forsaken's cause ran together.", 3)
q(1821, "Agamand Heirlooms", "WARRIOR", "Tirisfal Glades", 11, WBR,
    "The Agamands had employed Coleman in life and caused his death. Now mindless servants of the Lich King, they still kept a sword, an axe, a dagger and a mace in their family crypt at the north end of the Agamand Mills.",
    "Coleman wanted the last vestiges of the Agamands' honor. Their crypt held four heirloom weapons among lurking Scourge and dead Agamands.",
    "Coleman had the four heirlooms. The last semblance of honor had been stripped from the cursed Agamand lands, he said, and the family was truly no more.",
    "The Agamand sword, axe, dagger and mace reached Coleman Farthing, who rejoiced that the family he hated was finished.", 4)
P.questIDs[1821].highlight = {"The Agamand heirlooms reached Coleman Farthing, whose employers had caused his death. He said the family was truly no more.",
    "Coleman took the sword, axe, dagger and mace from the Agamand crypt as the end of the family that had killed him."}
q(92481, "A Student of the Arcane", "MAGE", "Zephras Isle", 2, ZT,
    "With the vuldren dealt with, a recall crystal from Dorii Brightwhisper, Thendal Grove's mage trainer, carried a message.",
    "Dorii Brightwhisper had left a recall crystal for a new student of magic, and waited in the building behind the village's speaker.",
    "Dorii said the arcane had waned among the sky elves over the millennia spent in the clouds, and hoped the newcomer would help rediscover what was lost.",
    "Dorii Brightwhisper judged the newcomer a fine young mage and offered further steps when ready.", 3)
q(92482, "The Way of the Hunter", "HUNTER", "Zephras Isle", 2, ZT,
    "After the vuldren were dealt with, a note from Tai'ree Farsight, Thendal Grove's hunter trainer, asked for a visit near the center of the village.",
    "Tai'ree Farsight had left a note for a new hunter. She could be found in the middle of Thendal Grove.",
    "Tai'ree warned that the hunter's way was full of danger and belonged to those with keen senses and quick reflexes. She saw her younger self in the newcomer.",
    "Tai'ree Farsight nodded curtly, then said the newcomer had what it took, if the choice was made.", 3)
q(92483, "At Home in the Shadows", "ROGUE", "Zephras Isle", 2, ZT,
    "Akeri Duskblade, Thendal Grove's rogue trainer, had asked to speak with the newcomer. His note said to find him in the village watchtower.",
    "A shady fellow named Akeri Duskblade waited in the watchtower for a new rogue.",
    "Akeri almost did not hear the approach, and almost, he said, would not be good enough beyond Thendal Grove. Survival on Zephras would come down to vigilance.",
    "Akeri Duskblade eyed the newcomer with suspicion, then spoke of silence, patience and the dangers outside the grove.", 3)
q(92484, "Embracing the Elements", "SHAMAN", "Zephras Isle", 2, ZT,
    "Windshaper Boro, Thendal Grove's shaman trainer, had left a recall crystal and waited near the center of the village.",
    "With the vuldren dealt with, Windshaper Boro, Thendal Grove's shaman trainer, wanted to meet a new shaman.",
    "Boro explained that the spirits of the four winds had stopped speaking with the sky elves years ago. Shaman studied the elements in the hope of restoring that dialogue.",
    "Boro asked whether the newcomer would walk the path to master the elements, and offered training when ready.", 3)
q(92485, "A Student of Nature", "DRUID", "Zephras Isle", 2, ZT,
    "Xyton Silverwind, Thendal Grove's druid trainer, had left a note. He waited on the ground floor of the great tree behind the village's speaker.",
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
    "Six familiar heads reached Ruzan, who judged the novice ready to go on.", 3)
q(1499, "Vile Familiars", "WARLOCK", "Durotar", 4, "class_warlock_binding",
    "Zureetha Fargaze was sending novices to cull the creatures near the familiars' cave. Ruzan thought helping her would be good experience.",
    "Ruzan sent the novice to Zureetha Fargaze with word of the help given against the imps.",
    "Word of the culled imps pleased Zureetha, who rewarded Ruzan's novice and foresaw greater deeds.",
    "Zureetha Fargaze welcomed the news of the imp problem and gave a reward.", 3)
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
    "At the end of the bar, Bartleby answered with a sneer.", 3)
q(1666, "Marshal Haggard", "WARRIOR", "Elwynn Forest", 10, W,
    "Harry Burlguard thought a decent weapon was still needed. Marshal Haggard, retired at the Eastvale Lumber Camp in Elwynn, had collected a lot of gear in his career.",
    "Burlguard sent word to Marshal Haggard, an old soldier in Elwynn Forest, who might have a spare weapon.",
    "His eyes had failed him, and at first Haggard took the visitor for a gnoll.",
    "Old Marshal Haggard squinted at the visitor and asked whether Burlguard had come himself.", 3)
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
    "Barleybrew kept his word, but the reward was in Stormwind. Furen Longbeard, the best shieldsmith in the Dwarven District, owed him a favor and would trade a shield for a cask of Barleybrew Scalder.",
    "Yorus Barleybrew sent a cask of Scalder to Furen Longbeard in Stormwind, with a request for a shield.",
    "Gladly taking the Scalder, Furen promised a shield like no other.",
    "In the Dwarven District, the shieldsmith welcomed the cask and agreed to make the shield.", 3)
q(1701, "Fire Hardened Mail", "WARRIOR", "Stormwind City", 28, W,
    "Furen knew the secret of a very hard mail, made from rare materials. He would make a piece for anyone willing to gather them.",
    "Fire hardened mail needed rare materials from far away, and Furen Longbeard would make it if they were found.",
    "Furen was amazed, having feared the chimaeras would eat the gatherer, and started on the armor.",
    "Every material for the fire hardened mail reached Furen, who set to work.", 3)
q(1700, "Grimand Elmore", "WARRIOR", "Stormwind City", 28, W,
    "Furen had copied his notes on the techniques he learned making armor, and wanted them sent to Grimand Elmore in the Dwarven District's weapon shop. He advised ducking, since Grimand was proud of his skill.",
    "Furen Longbeard's armor notes were meant for Grimand Elmore, who would hate to learn anything from him.",
    "Grimand was outraged, having taught Furen everything he knew. Still, something in the notes made him want to try it.",
    "Grimand Elmore fumed over Furen's notes, then admitted there was something in them worth trying.", 3)
q(1705, "Burning Blood", "WARRIOR", "Stormwind City", 28, W,
    "Grimand grudgingly admitted Furen might have found something. To test the technique on new armor, he needed burning blood from the Nightbane worgen of Roland's Doom in Duskwood, and a burning rock from their leader, Gutspill.",
    "Grimand Elmore's armor called for burning blood and a burning rock. Both were to be found with the Nightbane worgen in Duskwood.",
    "Pleased with the materials, Grimand went off to his own work.",
    "The burning blood and the rock reached Grimand, who began testing Furen's technique.", 3)

q(2998, "Tome of Divinity", "PALADIN", "Stormwind City", 12, PW,
    "Brother Wilhelm had overheard Duthorian Rall speaking well of a young paladin, and saying it was time for a test.",
    "Duthorian Rall, one of the most influential paladins, wanted to see the newcomer at the Cathedral of Light in Stormwind.",
    "Rall remarked on Stormwind's beauty and said the timing could not have been better.",
    "At the Cathedral of Light, Duthorian Rall welcomed the paladin at a good moment.", 3)
q(1649, "The Tome of Valor", "PALADIN", "Stormwind City", 20, PV,
    "The Tome of Valor compared valor to a rare mineral, to be refined into a strong alloy. Faith and bravery had to be tested.",
    "A paladin's courage, by the Tome of Valor, had to be put to the test with the Light's help.",
    "Duthorian Rall welcomed a petition for the test of valor and warned that such a test could cost a life.",
    "Rall accepted the petition, warning that the Church wanted its paladins worthy.", 3)
q(1650, "The Tome of Valor", "PALADIN", "Westfall", 23, PV,
    "Daphne Stilwell lived alone at the far end of Westfall's Longshore while her husband Jordan, a fine smith, was in Ironforge. The Defias had all but taken over the area.",
    "Duthorian Rall sent the paladin to protect Daphne Stilwell, whose house on the Longshore stood among the Defias.",
    "Daphne had already killed half a dozen Defias since the last sunrise, and expected more any minute.",
    "Daphne Stilwell greeted her protector and warned that the Defias would come again soon.", 3)
q(1651, "The Tome of Valor", "PALADIN", "Westfall", 25, PV,
    "More Defias were coming than before. Daphne fetched her gun and made her stand by the house.",
    "Daphne Stilwell expected another Defias attack on her house, and meant to fight beside her protector.",
    "The Defias were beaten back. Daphne praised bravery in the face of overwhelming odds.",
    "The Stilwell house held against the Defias, and Daphne gave her thanks.", 4)
q(1652, "The Tome of Valor", "PALADIN", "Stormwind City", 25, PV,
    "Daphne asked that Duthorian Rall be told she was safe for now, so word could reach Jordan in Ironforge.",
    "The news of Daphne Stilwell's safety was for Duthorian Rall in the Cathedral of Light.",
    "Rall said the Stilwells had helped the Church greatly, and protecting them was the least it could do. He rewarded the paladin's valor.",
    "Duthorian Rall heard that the Stilwell home was safe and gave a reward for valor.", 4)
P.questIDs[1652].highlight = {"Daphne Stilwell's house held against the Defias, and Duthorian Rall rewarded the paladin's valor.",
    "Rall heard that the Stilwells were safe and gave a reward for valor."}

q(1939, "High Sorcerer Andromath", "MAGE", "Stormwind City", 26, MA,
    "Jennea Cannon passed on a summons from High Sorcerer Andromath, one of the most powerful mages outside Dalaran. He waited at the top of the Wizard's Sanctum.",
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
fallback("Lord Grayson Shadowbreaker", 7638,
    "A paladin ready for a charger was sent to Lord Grayson Shadowbreaker in Stormwind's Cathedral District.", "Lord Grayson Shadowbreaker knew the trial that would win a paladin's charger.",
    "Lord Grayson explained that a future charger had to be rescued from evil.", "Grayson Shadowbreaker set out the long trial for the charger ahead.")
fallback("Child of Nature", 94911,
    "The Cenarion Circle offered further knowledge to druids newly arrived from Zephras.", "A mainland trainer could introduce a visitor to the Circle's work.",
    "The introduction was made, opening the way toward further instruction.", "The referral reached a welcoming druid, before the journey to Moonglade.")

fallback("The Tome of Valor", 1649,
    "Duthorian Rall of the Cathedral of Light tested paladins by sending them to defend others.", "The test of valor began with a tome in Stormwind's Cathedral of Light.",
    "A step of the test of valor was done.", "The paladin's test of valor went on.")

-- Coverage is deliberately representative: class membership never selects these
-- entries on its own. Unwritten areas include most armor/weapon crafting chains,
-- priest racial spell quests without complete reward evidence, paladin epic-mount
-- stages, Rhok'delar and most advanced druid adventures. The 1661 source does not
-- name its reward; it remains under the safe Nobility fallback. Moonglade entry
-- quests and shaman trials are authored by their respective regional packs.
A.Lore.RegisterStoryPack("class-stories", P)
