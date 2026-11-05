local _, A = ...
-- Forever's own quests: the stages Blizzard added for WoW Forever (quest IDs
-- 65000 and up, mostly 9xxxx), told from the captured quest text. Curated, not
-- an exhaustive database. Load after the other story packs (TOC: after
-- LoreClassStories.lua).
--
-- Evidence: StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt
-- (it holds the Forever additions too) and part1_corpus.txt / quests_corpus.txt
-- for objectives and giver names. Lore Forever (Interface/AddOns/LoreForever,
-- text adapted from warcraft.wiki.gg under CC BY-SA) is used for facts only,
-- never for its sentences; such facts are cited as LoreForever <entry id>
-- (wiki: <article>) in the entry's source.
--
-- Each exact stage has two why and two after lines with different focus or
-- shape. A completed stage permits only its own consequence. Titles shared by
-- several stages get a conservative fallback that never finishes the chain.
--
-- Another pack may author the same quest ID tonight or later: the other pack
-- wins, and this pack drops its own copy before registering (see the end).
local L = A.Lore
if not (L and L.RegisterStoryPack) then return end
local V = "corpus_vanilla_quests.txt quest "
local P = {setting = "Forever",
    sources = {"StorageInvestigation/journal-voice/review/corpus_vanilla_quests.txt",
        "StorageInvestigation/journal-voice/part1_corpus.txt", "StorageInvestigation/journal-voice/quests_corpus.txt",
        "Interface/AddOns/LoreForever/Data (facts only, CC BY-SA 4.0, attributed per entry)"},
    quests = {}, questIDs = {}, zones = {}, threads = {}}
-- q(id, title, zone, level, thread, importance, why1, why2, after1, after2, shared, refs)
-- shared: the title belongs to several stages, so no title-level entry.
-- refs: extra sources (giver names from part1_corpus, LoreForever facts).
-- Zephras stages join the Zephras threads of LoreHordeStories.lua (forever_grove,
-- forever_cult, forever_winds) so a chain told across both packs stays one
-- thread; the labels below are only used if that pack ever drops them.
local SHARED_THREADS = {forever_grove = "the needs of Thendal Grove", forever_cult = "the Al'Aketh threat",
    forever_winds = "the fading magic of Zephras"}
-- Forever stages that continue a chain told in LoreHordeStories.lua join its
-- thread under the same label (starters3 lane, 2026-11-05).
local HORDE_THREADS = {horde_vrang = "Vrang and the hermit tanner", horde_ratchet = "Ratchet's harbor and workshops",
    horde_mankrik = "Mankrik's search for his wife"}
local function Thread(key)
    if HORDE_THREADS[key] then P.threads[key] = HORDE_THREADS[key]; return key end
    if SHARED_THREADS[key] then
        if not L.storyThreads[key] then P.threads[key] = SHARED_THREADS[key] end
        return key
    end
    return "fv_" .. key
end
local function q(id, title, zone, level, thread, importance, why1, why2, after1, after2, shared, refs)
    local v = {title = title, zone = zone, level = level, thread = Thread(thread), importance = importance,
        setting = "Forever", why = {why1, why2}, after = {after1, after2}, source = {V .. id}}
    for _, ref in ipairs(refs or {}) do v.source[#v.source + 1] = ref end
    P.questIDs[id] = v
    if not shared then P.quests[title] = v end
    return v
end
local function fallback(title, zone, thread, ids, w1, w2, a1, a2)
    P.quests[title] = {zone = zone, thread = "fv_" .. thread, importance = 3, setting = "Forever",
        why = {w1, w2}, after = {a1, a2}, source = {"corpus_vanilla_quests.txt quests " .. ids}}
end
P.threads = {
    fv_heartweaver = "the Heartweavers of Lordaeron",
    fv_ruins = "the Scourge in the Ruins of Lordaeron",
    fv_relics = "the relics of fallen Lordaeron",
    fv_othmar = "the Grand Marshal's head",
    fv_apothecary = "the Apothecarium's errands",
}

---------------------------------------------------------------- Ruins of Lordaeron (Forever dungeon, 15-22)
-- Horde and Alliance halves of the Heartweaver family are separate stages: the
-- Horde wife never learns of the Alliance letter, and the reverse.
q(92401, "A Frightened Request", "Undercity", 22, "heartweaver", 4,
    "Edward Heartweaver went to the graveyard in the Lordaeron ruins every week, still looking for the son lost when Arthas razed the city. This time he had not come back.",
    "His wife in the {p:Undercity} had warned Edward against the overrun ruins. Days after he left, she still had no word of him.",
    "Edward's wife learned what had become of him in the ruins. She said it had not been fair to ask, and gave what thanks she could.",
    "The search for Edward was over. His wife hoped their next meeting would carry less sorrow.",
    false, {"part1_corpus.txt #92401 (objective: the disappearance of Edward Heartweaver)"})
q(92415, "Remember That I Love You", "Ruins of Lordaeron", 22, "heartweaver", 5,
    "A torn, stained bundle of parchment from the graveyard spoke of a missing child of the Heartweaver family.",
    "The letter had survived the undead-trodden graves above the {p:Undercity}, and the orphan matron in {p:Stormwind} might know the name.",
    "Matron Nightingale remembered little Jeremy Heartweaver, brought to the orphanage after Lordaeron fell and lately adopted by a woman in {p:Duskwood}.",
    "By the orphanage's account, Jeremy Heartweaver had lost both parents in the attack on Lordaeron. A new mother in {p:Duskwood} had taken him in.",
    true, {"LoreForever quest:92415 (wiki: in-game quest text)"})
q(95161, "Remember That I Love You", "Duskwood", 22, "heartweaver", 5,
    "Jeremy Heartweaver now lived in {p:Duskwood} with Avette Fellwood, the woman who had adopted him, and the letter from the ruins was meant for him.",
    "Matron Nightingale sent the letter on to Avette Fellwood, and asked that Jeremy hear the orphanage was thinking of him.",
    "Avette took the letter but would not show it to Jeremy yet. The boy had not spoken since Lordaeron fell, and she meant to give it to him when he was older.",
    "Avette kept the letter for a later day. She would not hide his past from Jeremy, but she would not force it on a silent child either.",
    true, {"LoreForever quest:95161 (wiki: in-game quest text)"})
fallback("Remember That I Love You", "Ruins of Lordaeron", "heartweaver", "92415, 95161",
    "A stained letter from the graveyard of the Lordaeron ruins named a child of the Heartweaver family.",
    "The Heartweaver letter had survived the ruins, and someone in the Alliance's care might still be meant to read it.",
    "The Heartweaver letter moved one step closer to the child it named.",
    "The letter from the ruins was in kinder hands than the graveyard's.")
q(92421, "Light's Justice", "Ruins of Lordaeron", 22, "ruins", 4,
    "A Forsaken paladin needed flesh from the Scourge above the {p:Undercity}. The Forsaken's decaying bodies could not be mended without replacements.",
    "Captain Garek Bandarion had begun the work of reclaiming the ruins and healing the Forsaken. One of his paladins believed the captain would have wanted it finished.",
    "The parts taken from the Scourge gave the Forsaken's wounded a chance to see another day.",
    "The paladin had replacement parts for the Forsaken's wounded, and said the work did Captain Bandarion proud.")
q(92422, "The Wrath of Rath'mael", "Ruins of Lordaeron", 22, "ruins", 6,
    "Scouts at {p:Lordamere Overlook} reported an unholy fog in the streets and graveyard of the ruins, and a necromancer named Rath'mael behind it.",
    "The fog let the Scourge move unseen above the {p:Undercity}. Deathguard Kristof in {p:Brill} wanted its maker driven out and could not afford to wait.",
    "Rath'mael was dead. Kristof expected the Scourge to find another like him, but hoped their ranks would thin in the meantime.",
    "The necromancer behind the fog had fallen. In {p:Brill}, Kristof took it as a reprieve rather than an end.",
    false, {"part1_corpus.txt #92422 (Deathguard Kristof in Brill)"}).highlight = {
    "Rath'mael, the necromancer behind the fog over the ruins, was dead.",
    "The fog's maker had fallen, and Kristof hoped the Scourge would be thinner for a while."}
q(95189, "Crest of Lordaeron", "Ruins of Lordaeron", 22, "relics", 3,
    "A weathered crest of Lordaeron had survived the kingdom's fall, and few such relics were left.",
    "Lady Dena Kennedy in {p:Stormwind} was keen to have any relic of Lordaeron, and this crest bore the old kingdom's mark.",
    "Lady Kennedy marveled at the crest's condition and set her best people to restoring it as a piece of Alliance history.",
    "The crest reached the gallery in {p:Stormwind}, where Lady Kennedy's people would restore it.",
    true, {"LoreForever quest:95189 (wiki: in-game quest text; Lady Dena Kennedy)"})
q(95204, "Crest of Lordaeron", "Ruins of Lordaeron", 22, "relics", 3,
    "A weathered crest of Lordaeron had come out of the ruins, and Oran Snakewrithe in the {p:Undercity} wanted relics of the old kingdom.",
    "Few relics remained after Lordaeron fell, and the Forsaken still counted the kingdom as their home.",
    "Oran bit the crest to test it, then called it a genuine relic of home and promised to handle it with care.",
    "The crest went to Oran Snakewrithe, who took it as a piece of the Forsaken's history restored.",
    true, {"part1_corpus.txt #95204 (Oran Snakewrithe in Undercity)"})
fallback("Crest of Lordaeron", "Ruins of Lordaeron", "relics", "95189, 95204",
    "A weathered crest of Lordaeron lay among the ruins above the {p:Undercity}.",
    "Relics of the fallen kingdom were rare, and both {p:Stormwind} and the {p:Undercity} wanted them.",
    "The crest left the ruins for safekeeping.",
    "One more relic of Lordaeron was out of the rubble.")
q(95195, "Bloodied Insignia", "Ruins of Lordaeron", 22, "relics", 3,
    "Old Alliance insignia of Lordaeron's soldiers lay throughout the ruins, and living kin might still want them back.",
    "Many of Lordaeron's people had fled to {p:Stormwind} when the kingdom fell to the Scourge. Their dead soldiers' medals had stayed behind.",
    "The bloodied insignia went to {p:Stormwind}, to be handed on to the soldiers' next of kin.",
    "Stormwind would pass the insignia to whatever kin remained, though few were left to claim them.",
    false, {"part1_corpus.txt #95195 (objective: collect 10)"})
q(95216, "The New Plague", "Ruins of Lordaeron", 22, "apothecary", 4,
    "Theodore Griffs of the Royal Apothecary Society had heard of a spider in the ruins whose venom ate through undead flesh. He wanted a sample.",
    "A venomous creature called Witherfang stalked the ruins above the {p:Undercity}, and the Apothecarium wished to test its toxin for itself.",
    "Griffs was put out that Witherfang had been killed, but the ichor was enough to reverse engineer the strain.",
    "The toxic strain from Witherfang reached the Apothecarium, where Griffs meant to learn how it worked.",
    false, {"part1_corpus.txt #95216 (Theodore Griffs in Undercity; Witherfang)"})
-- The Baron's head (Horde, 97288 to 97292). Othmar's name is first spoken in
-- 97289; 97288 keeps it unsaid.
q(97288, "Unending Torment", "Ruins of Lordaeron", 21, "othmar", 4,
    "The abomination called {n:the Baron} had a head that had been sewn back on many times, each time a little weaker.",
    "When {n:the Baron} fell, its head came loose, and someone in the city below the ruins might know more about so unusual an abomination.",
    "The head was recognized at once, and its new keeper already had a use for it.",
    "{n:The Baron}'s head reached the {p:Undercity}, where its old owner was known and its next purpose already planned.",
    true, {"part1_corpus.txt #97288"})
q(97289, "Unending Torment", "Undercity", 21, "othmar", 4,
    "{n:The Baron}'s head had once belonged to Othmar, a Grand Marshal of the Alliance whom the Dark Lady had killed herself.",
    "The apothecaries wanted the head set beside a body in the next room, so that Othmar's secrets might be made to talk.",
    "Set beside the body, the head brought it twitching to life, and Othmar relived his final moments.",
    "Othmar's body stirred in a panic once the head lay beside it.",
    true, {"part1_corpus.txt #97289 (Head of the Baron; the body of Othmar)"})
q(97290, "Unending Torment", "Undercity", 21, "othmar", 3,
    "Othmar's head spoke again, but only to refuse.",
    "The revived Grand Marshal answered with broken words and would not help the apothecaries.",
    "The apothecary welcomed the refusal as a challenge.",
    "The Grand Marshal's defiance pleased the apothecary in charge of him.",
    true, {"part1_corpus.txt #97290"})
q(97291, "Unending Torment", "Undercity", 21, "othmar", 3,
    "Master Apothecary Faranell meant to bind Othmar to the Dark Lady's will with a potion.",
    "Faranell's potion needed a Toxic Skullcap from Tawny Grisette, blisterweed from the herbalists and a vial of Essence of Agony.",
    "Faranell had his reagents and looked forward to testing how much bravado Othmar had left.",
    "The ingredients were in hand, and the potion could be brewed.",
    true, {"part1_corpus.txt #97291 (Master Apothecary Faranell; Tawny Grisette)"})
q(97292, "Unending Torment", "Undercity", 21, "othmar", 5,
    "Faranell's Hissing Serum was meant to drip into the workings above Othmar's body, to teach him the value of loyal service.",
    "For Othmar's crimes against the Dark Lady, Faranell wanted him placed beneath an oozing specimen.",
    "The serum went into the workings above the body. Faranell left the flesh to simmer and spoke of many plans for Othmar's future.",
    "The serum was in place, dripping onto the Grand Marshal, and the master apothecary meant to let his new guest acclimate.",
    true, {"part1_corpus.txt #97292 (Hissing Serum)"})
fallback("Unending Torment", "Undercity", "othmar", "97288 to 97292",
    "The head of an abomination from the ruins had caught the interest of the apothecaries in the {p:Undercity}.",
    "The apothecaries of the {p:Undercity} had plans for {n:the Baron}'s head.",
    "One step of the apothecaries' work on {n:the Baron}'s head was done.",
    "The apothecaries' work on the head from the ruins went on.")
q(97891, "Prompt Potion Runner", "Undercity", 16, "apothecary", 2,
    "Alessandro's potion would spoil unless it crossed the slime canal quickly, and his knees popped out of joint whenever he ran.",
    "Doctor Martin Felben in the Apothecarium was waiting on a potion with a very short shelf life.",
    "The potion reached Doctor Felben in time. The six before it had gone bad on the way.",
    "Felben had Alessandro's potion at last, still stable, and went back to his experiments.",
    false, {"part1_corpus.txt #97891"})

---------------------------------------------------------------- Dun Morogh and the Hall of Thanes (Forever dungeon, 13-18)
-- Givers: LoreForever quest:96408 (Beldin Steelgrill to Earthseer Farsen),
-- quest:96390/96392 (Earthseer Farsen), quest:96393 (to King Magni Bronzebeard).
q(96408, "A Visitor to Dun Morogh", "Dun Morogh", 13, "thanes", 3,
    "A mountaineer had seen a campfire in the night, high on a hillside above the Gol'Bolar Quarry, and Beldin Steelgrill wanted to know whose it was.",
    "The fire above the quarry was probably nothing. If its keepers were not friendly, the mountaineers wanted them dealt with.",
    "The camp above the quarry was friendly. Its keeper, Earthseer Farsen, had a cheerful greeting ready.",
    "The fire belonged to Earthseer Farsen, who welcomed his visitor as a friend.",
    false, {"LoreForever quest:96408 (wiki: World of Warcraft: Forever)"})
q(96392, "Farsen's Watch", "Dun Morogh", 13, "thanes", 3,
    "Earthseer Farsen had come to {p:Dun Morogh} from Aerie Peak, and on the way he had noticed a Dark Iron problem.",
    "Farsen offered to show the trouble with a bit of his own magic, a farsight that could see a great deal from the sky.",
    "Seen from the sky, the Dark Irons were thick as cockroaches, Farsen said, and he wanted something done about them.",
    "Farsen's farsight showed the Dark Irons spread across the hills, and he asked for a bit of violence.",
    false, {"LoreForever quest:96392 (wiki: World of Warcraft: Forever)"})
q(96390, "Nip 'Em in the Bud", "Dun Morogh", 13, "thanes", 3,
    "Dark Iron spies had slipped into {p:Dun Morogh}, and Farsen meant to stop them before their purpose could grow.",
    "The spies gathered at Ironband's Compound in the east, and no one yet knew what they wanted.",
    "The spies at Ironband's Compound were cut down. Farsen called the Dark Irons cousins but not family, and shed no tears for them.",
    "The band at Ironband's Compound was broken up, and Farsen hoped it would put them off further incursions.",
    false, {"part1_corpus.txt #96390 (objective: slay 10)", "LoreForever quest:96390 (wiki: World of Warcraft: Forever)"})
q(96391, "Underground Map", "Dun Morogh", 15, "thanes", 4,
    "A Dark Iron map showed tunnels and highways that met at a point beneath {p:Ironforge} itself.",
    "The map's runes were in the jagged script of the Dark Irons, but the tunnels needed no translation. Farsen had to see it.",
    "Farsen read the map as a plan to break into the vaults beneath {p:Ironforge}. The spies at the compound had been a scouting force.",
    "Farsen judged the map a road into the vaults below {p:Ironforge}, and wanted to get there before the Dark Irons did.",
    false, {"part1_corpus.txt #96391 (Dark Iron Map to Earthseer Farsen)"})
q(96393, "Old Ironforge Incursion", "The Hall of Thanes", 16, "thanes", 6,
    "Farsen had made out one name on the Dark Iron map, Durgen Dirgehammer, and took him for the commander of the incursion.",
    "The way to the Dark Irons ran into the caverns beneath {p:Old Ironforge}, down to the lowest vaults of the tombs.",
    "King Magni Bronzebeard heard of the incursion beneath his feet and was relieved its commander was dead. His guards would clear the rest and seal the breaches.",
    "Dirgehammer's head reached King Magni, who ordered the lower levels reinforced. He also asked that his old friend Farsen come for a proper visit.",
    false, {"part1_corpus.txt #96393", "LoreForever quest:96393 (wiki: Hall of Thanes (instance))"}).highlight = {
    "Durgen Dirgehammer's head reached King Magni, and the breaches beneath Ironforge would be sealed.",
    "Magni took the commander's head as proof of the incursion beneath his city, and sent his guards to clear the rest."}
q(96394, "The Restless Dead", "The Hall of Thanes", 15, "tombs", 3,
    "Something had disturbed the tombs of the Hall of Thanes, and strange noises came up from the vaults.",
    "The keepers of the hall knew the dead were light sleepers. Whatever was happening below had woken them.",
    "The woken dead were put back down, and the keepers had no more reason to stay out of the hall.",
    "The restless dead lay still again. Their keeper was glad, for the others had refused to enter the hall on account of ghosts.",
    false, {"part1_corpus.txt #96394 (objective: kill 15)"})
q(96395, "An Ancient Grudge", "The Hall of Thanes", 15, "tombs", 4,
    "A ghostly attendant among the tombs begged, a few words at a time, for its master the thane to be given rest.",
    "Faldrim Anvilmar, a thane of old, was so consumed by an ancient grudge that his spirit could not rest.",
    "The thane's spirit was put to rest, as his attendant had asked.",
    "The old thane lay quiet at last, as the attendant had begged.",
    false, {"part1_corpus.txt #96395 (objective: put the spirit of Faldrim Anvilmar to rest)", "LoreForever quest:96395 (wiki: in-game quest text)"})
q(96403, "Important Heirlooms", "The Hall of Thanes", 15, "tombs", 3,
    "Thom, a gnome who said he had been patrolling the vaults, wanted their heirlooms saved from the Dark Irons.",
    "Dark Irons had come out of the depths in mole machines, and Thom feared for the priceless loot. Cultural heirlooms, he corrected himself.",
    "Thom took the recovered heirlooms and promised to catalogue them, though he kept saying appraise.",
    "The heirlooms went to Thom, who called the finder brave and enterprising and set about his cataloguing.",
    false, {"part1_corpus.txt #96403 (objective: collect 8)"})
P.threads.fv_thanes = "the Dark Iron incursion beneath Ironforge"
P.threads.fv_tombs = "the restless tombs of the thanes"

---------------------------------------------------------------- Zephras Isle, Thendal Grove (Skyborne start, 1-6)
-- LoreHordeStories.lua tells the grove stages (92460-92474, 92544, 92598,
-- 94414, 96638); none of them is registered here (coordinator, 2026-11-05).
-- Class-trainer referrals (92481-92485, 92532) are left to the class pack.

---------------------------------------------------------------- Zephras Isle, Shen'dar Village and Falaath (6-8)
-- The two traditions: Windshapers (Horde) and the High Order (Alliance, of
-- Highborne descent from Eldre'Thalas, per #92596). Each sees the other's work
-- from its own side; attribute every judgement. LoreHordeStories.lua tells
-- 92517, 92528, 93926, 93927 and 92579; these are the stages around them.
q(92514, "Welcome to Shen'dar Village", "Zephras Isle", 6, "traditions", 2,
    "Shen'dar Village sent each newcomer to the elder of their own tradition, and a Windshaper went first to Illaya Amberwind near the center of town.",
    "In Shen'dar it was said that a Windshaper left a little static on the skin. The village's Windshaper elder, Illaya Amberwind, waited outside.",
    "The High Order and the Windshapers were at odds those days, but in Shen'dar they kept things civil. Everyone there knew the village had bigger problems.",
    "With the elder met, Shen'dar had work waiting, starting with its bandits.",
    true)
q(93461, "Welcome to Shen'dar Village", "Zephras Isle", 6, "traditions", 2,
    "In Shen'dar it was said that those of Highborne blood had a twinkle in their eyes. The village's High Order elder, Rathiril Sunlance, kept to the main lodge.",
    "Shen'dar Village sent each newcomer to the elder of their own tradition, and one of the High Order went first to Rathiril Sunlance.",
    "The High Order and the Windshapers kept things civil inside Shen'dar. What happened out in the wilds, the village said, stayed in the wilds.",
    "With the elder met, Shen'dar had a few things that needed doing.",
    true)
fallback("Welcome to Shen'dar Village", "Zephras Isle", "traditions", "92514, 93461",
    "Shen'dar Village sent newcomers to the elder of their own tradition, Windshaper or High Order.",
    "Both the Windshapers and the High Order kept an elder in Shen'dar.",
    "Inside Shen'dar, the two traditions kept the peace.",
    "With an elder met, Shen'dar had work waiting.")
q(92595, "The Windshapers", "Zephras Isle", 6, "traditions", 3,
    "Illaya Amberwind had sensed the skysight at first meeting. She said even those never trained as shamans could carry the gift.",
    "Illaya wished to speak of the Windshapers' mandate and the plight of the shen'dorei.",
    "Illaya taught that every soul with the skysight mattered if the shen'dorei were ever to speak with the spirits of the winds again.",
    "Illaya named the Al'Aketh and the uncertain safety of Skywall as the dangers, and the Windshapers' gifts as the way to save their home.")
q(92596, "The High Order", "Zephras Isle", 6, "traditions", 3,
    "Rathiril Sunlance felt a strong aura of arcane energy even in those never initiated as mages.",
    "Rathiril wished to speak of the High Order and the nature of the arcane on Zephras.",
    "Rathiril held the elemental benefactors in high regard, but said plainly that they were gone and the shen'dorei were on their own.",
    "As descendants of the Highborne of Eldre'Thalas, Rathiril said, the High Order would see the shen'dorei stand on their own again.")
q(92515, "The Problem With Prideclaws", "Zephras Isle", 6, "shendar", 2,
    "Prideclaws had grown thick in the hills around Shen'dar and bolder by the day, and the village feared for its pets and children.",
    "Culling the prideclaws before a tragedy seemed a mercy, and their pelts could be made into goods the village needed.",
    "The pelts came in, and the one who had wanted them pointed out that no one had promised clean work.",
    "A stack of prideclaw pelts went to be turned into goods for Shen'dar.")
q(92516, "Hippogryph Harrassment", "Zephras Isle", 7, "shendar", 2,
    "A flock of hippogryphs had made nesting grounds southeast of Shen'dar and were attacking travelers on the road.",
    "The road near Shen'dar had grown dangerous, for hippogryphs nesting nearby struck at whoever passed.",
    "The hippogryph flock was thinned, and the road near Shen'dar was safer for it.",
    "The nesting hippogryphs were fewer, and the work had been done fast enough to earn a word of praise.")
q(93951, "A Little Beauty", "Zephras Isle", 7, "shendar", 2,
    "Many skyborne liked to wear bright plumes in their hair, and hippogryph down was the most vibrant and the softest.",
    "Fallen feathers lay around the hippogryph nests near Shen'dar, though the wild birds did not welcome visitors.",
    "The feathers went to a crafter who admitted it seemed a vain thing in such times, but held that small joys mattered all the more.",
    "With the hippogryph down in hand, Shen'dar's crafter hoped to make something that would bring someone joy.")
q(92553, "Restocking the Larders", "Zephras Isle", 6, "shendar", 2,
    "No one in Shen'dar had found time to hunt or forage with the danger growing, and the village needed eggs and strider meat.",
    "Shen'dar's cook promised one of a set of famous recipes in return for fresh eggs and strider meat.",
    "The eggs were hard to come by, and the cook swore they were delicious fried in ursera tallow.",
    "The larders had fresh eggs and strider meat again, and the cook offered to share a few tricks of the trade.")
q(93319, "Pilfered Windstones", "Zephras Isle", 7, "shendar", 3,
    "Windstones kept in reserve for emergencies had been going missing from Shen'dar's stores, and stolen stones had turned up on captured bandits.",
    "The bandits' cave to the north was suspected of holding the stolen windstones. Constable Aonda would not spare peacekeepers for a raid while the cult grew at Falaath.",
    "Some of the windstones came back from the bandit cave. It was enough to get by, unless the supply routes failed.",
    "The reclaimed windstones eased Shen'dar's shortage for now, though stolen stones were the smaller worry if the supply routes could not be fixed.")
q(94411, "Meddlesome Mages", "Zephras Isle", 6, "traditions", 3,
    "Mages of the High Order kept meddling at the Windshapers' sacred standing stones north of Shen'dar, despite every warning.",
    "The Windshapers were loath to shed shen'dorei blood, but they wanted the High Order driven from the standing stones.",
    "The mages were driven from the stones. The Windshapers held that fighting their own kin weakened the shen'dorei, but feared the High Order's meddling more.",
    "The standing stones were clear of the High Order. To the Windshapers, one careless spell could undo the fragile forces that bound the island.",
    false, {"part1_corpus.txt #94411 (objective: slay 6)"})
q(94413, "A Magical Affront", "Zephras Isle", 6, "traditions", 3,
    "Ley lines had broken the surface of Zephras, and the High Order valued the new access to the island's magic.",
    "The Windshapers called the ley lines scars to be healed, and the High Order meant to drive them from the one in the southwestern forest.",
    "The Windshapers were driven off. To the High Order, their refusal to change was hard to tell from the zealotry of the Al'Aketh.",
    "The ley line was the High Order's for now. If the winds truly guided the shen'dorei, the order held, the Windshapers should be flowing with them.")
q(93036, "Infiltrating the Cult", "Zephras Isle", 8, "forever_cult", 4,
    "Sania Silverstream, a missionary of the Al'Aketh, recruited openly in Shen'dar, and the village had tolerated her to avoid open conflict.",
    "The peace with the cult would not last, and Shen'dar needed someone unknown to get close to Sania and learn the cult's plans.",
    "Sania introduced herself as a junior priestess of the Order of the Al'Aketh and spoke of the Windlord's table, with room for the righteous and the repentant.",
    "Sania offered to teach of Al'Akir, and the way into the cult stood open.")
q(92529, "Falaath Village", "Zephras Isle", 8, "forever_cult", 4,
    "Sania preached that the spirits of the wind had left the shen'dorei because of their pride, and that only contrition would bring them back.",
    "Sania sent new recruits to Missionary Jasaan in Falaath Village, marked so the faithful would know them.",
    "Missionary Jasaan welcomed an acolyte sent by Sister Sania, and called the day blessed by the four winds.",
    "Jasaan took the mark at face value and welcomed a supposed new acolyte of Al'Akir.")
q(92551, "Stolen Supplies", "Zephras Isle", 8, "forever_cult", 3,
    "The Al'Aketh had raided Shen'dar's supply caravans for months and blamed the bandits, but the goods all ended up in the same place.",
    "Food and windstones taken from Shen'dar's caravans might still be stored in Falaath Village.",
    "The recovered supplies were shared out to the townsfolk in most dire need, with the constable's help.",
    "Shen'dar had been barely getting by without its deliveries, and the caches from Falaath bought it some relief.")
q(92550, "Havoc in the Highlands", "Zephras Isle", 8, "forever_cult", 5,
    "Shen'dar expected an attack from Falaath, and meant to strike first at the cultists and their commander.",
    "The village readied its few peacekeepers and armed its citizens, while the cult's commander in Falaath was marked for death.",
    "The commander's head reached Shen'dar. Sania Silverstream had slipped out of town as the people armed themselves.",
    "With the commander dead, Shen'dar had turned the tables. If the cult came back to the highlands, it would not find an easy target.").highlight = {
    "The cult's commander at Falaath was dead, and Shen'dar was ready if the zealots came back.",
    "Shen'dar struck first at Falaath, and Sania Silverstream fled the village as its people armed."}
P.threads.fv_traditions = "the rift between the Windshapers and the High Order"
P.threads.fv_shendar = "the needs of Shen'dar Village"

---------------------------------------------------------------- Zephras Isle, Valanaar and the lowlands (9-10)
-- The Windfield orchard (92679 to 92703) is a complete small chain: Alvarion,
-- wounded in Valanaar; Aamelia, holding the orchard against Ferauu's bandits.
-- 92703 hints that Aamelia is expecting; the lines keep her secret as hers.
q(92701, "To Valanaar", "Zephras Isle", 9, "forever_cult", 4,
    "Constable Aonda sent word to Valennia Stormfist in Valanaar, captain of the island's peacekeepers. The cult was spreading, and the days of avoiding a fight were over.",
    "With the pylon and Shen'dar safe for now, Aonda's report had to reach Valanaar at the island's southeastern edge.",
    "Valennia's face darkened as she read Aonda's letter. She needed to consult her few remaining peacekeepers before saying more.",
    "The letter reached Valennia, who trusted Aonda's word and began planning for a cult attack on Valanaar.",
    true)
q(92699, "The Supreme Magister", "Zephras Isle", 9, "traditions", 3,
    "Elaadrin Evengale, the Supreme Magister, led the High Order from its lodge in the southeast of Valanaar.",
    "Valanaar's peacekeepers would not tolerate faction violence in the streets, and warned the High Order to give the Windshapers a wide berth.",
    "Elaadrin had a missive from Rathiril and saw promise in a vibrant arcane aura. Whether it came with boldness and strength, he said, remained to be seen.",
    "The Supreme Magister welcomed Rathiril's recommendation. Few shen'dorei, he said, still had the aptitude and the will to save their home.")
q(92700, "The Grand Skyseer", "Zephras Isle", 9, "traditions", 3,
    "The Grand Skyseer led the Windshapers of Valanaar from the lodge near the center of town.",
    "Valanaar's peacekeepers would not tolerate faction violence in the streets, and warned the Windshapers to give the High Order a wide berth.",
    "Elder Amberwind's message about Shen'dar had reached the Grand Skyseer, and she gave a warm welcome.",
    "Fewer and fewer shen'dorei had the skysight, the Grand Skyseer said, and Zephras needed every one of them.")
q(93948, "Deliver the Signet", "Zephras Isle", 9, "forever_cult", 4,
    "A signet ring recovered from the western watchtower belonged with Talaanis Shadowsong, High Elder of Zephras Isle, and so did the news of his nephew.",
    "Talaanis Shadowsong was well loved by the people despite their hardships, and Shen'dar dreaded how he would take the news of his nephew.",
    "Talaanis was sorry to learn that his nephew was dead, and thanked the bearer for bringing the ring back to him.",
    "The High Elder took back the signet and the news of his nephew's death, then pointed toward Valennia Stormfist, who needed all the help she could get.")
q(92679, "Blood Tithe", "Zephras Isle", 9, "windfield", 4,
    "Alvarion Windfield had come to Valanaar badly hurt, looking for fighters to save his farm.",
    "Alvarion's wife Aamelia kept their stormapple orchard in the lowlands west of Valanaar, and he wanted help sent to her.",
    "Aamelia was relieved that Alvarion was safe in Valanaar, but warned that her husband had likely sent help there to die for nothing.",
    "Aamelia learned what had become of Alvarion, and said plainly that this was not a stranger's fight.")
q(92682, "Make Yourself Useful", "Zephras Isle", 9, "windfield", 3,
    "Ferauu's bandits were due to collect their take of the Windfield harvest, and some of his people had come early to tamper with the stormapples.",
    "Aamelia put help to work for its meals, gathering stormapples and clearing the bandits who lurked among the trees.",
    "Aamelia had watched the bandits fall from her window, and judged it not bad.",
    "The day's stormapples were in, and the bandits in the orchard were dead.")
q(92683, "Flutterfly Dust", "Zephras Isle", 9, "windfield", 2,
    "Giant flutterflies drifted over the fields near the Windfield orchard, and their wing dust had uses about the house.",
    "A swat with Aamelia's flutterfly swatter usually sent the big bugs off with a shake and a pile of dust.",
    "Aamelia had her dust at last, a chore put off for weeks while bandits lurked near the house. She would not say what it was for.",
    "The flutterfly dust got everywhere, as Aamelia had warned, and she kept its use to herself.")
q(92684, "Ornery Ornery Galestriders", "Zephras Isle", 9, "windfield", 2,
    "Galestriders had been raiding the orchard for stormapples in a year when the harvest was already light.",
    "The lowland galestriders were bigger and angrier than the highland kind, and a well-timed kick could put a fighter down for good.",
    "The galestrider tenderloins were big ones, and Aamelia could cook a real meat supper for the first time in too long.",
    "The galestriders were culled, and their meat went to Aamelia's kitchen.")
q(92685, "The Hills Have Eyes", "Zephras Isle", 9, "windfield", 4,
    "Ferauu's bandits kept a small camp in the hills north of the orchard, and Aamelia meant to hit them before they came for her.",
    "Aamelia wanted the bandits' masks, the bloodier the better.",
    "The masks were bloody enough to please her. Aamelia said she had spent weeks waiting for the end, and now had hope again.",
    "With the hill camp broken, Aamelia had begun to hope. Ferauu and his thugs were due any time.")
q(92693, "Standing Our Ground", "Zephras Isle", 9, "windfield", 6,
    "Ferauu and his thugs came at last for their share of the harvest, and Aamelia walked out to meet them with her head held high.",
    "Aamelia offered one last chance to go back to Valanaar. She meant to face Ferauu whatever happened.",
    "It was over, and Aamelia could hardly believe it. She had to stop and calm herself before her heart leapt out of her chest.",
    "Aamelia's stand against Ferauu was over. There were not stormapples enough in Skywall to repay it, she said.").highlight = {
    "Aamelia Windfield faced Ferauu's bandits at her orchard, and when it was over she could hardly believe it.",
    "The stand at the Windfield orchard was over, and Aamelia still had her land."}
q(92698, "What Is My Purpose?", "Zephras Isle", 9, "forever_winds", 3,
    "A great construct wandered the fields by the orchard, repeating fragments of words from beneath its armor plates.",
    "Under its armor, the old construct muttered of function errors and questions, and no one nearby could say what it wanted.",
    "Aamelia said the construct had wandered the fields since the wind elementals left. Alvarion thought it had once hauled harvests or tended livestock.",
    "The Windshapers had once kept such constructs, Aamelia said, but no one had ever asked them to look at this one.")
q(92703, "Deliver the News", "Zephras Isle", 9, "windfield", 5,
    "Aamelia wanted Alvarion told what had happened at the orchard, and asked that he bring a Windshaper to look over the old construct once he was on his feet.",
    "Aamelia wanted the old construct made safe for her family, for a reason she was keeping from Alvarion for now.",
    "Alvarion wept as he heard what had happened at the orchard. He had come to Valanaar on a vain hope, he said, and found a hero instead.",
    "Alvarion promised a welcome at the Windfield home, and said he would never forget what had been done for them.")
q(93317, "Crab Season", "Zephras Isle", 9, "shendar", 2,
    "Windsong crawlers lived only in Windsong Lake on Zephras, and could be harvested just a few weeks of the year.",
    "Cult activity had kept the crab gatherer away from the lake, and the season was nearly over.",
    "The crawler meat looked fantastic. It had once been a delicacy on Anvilas and Siroccas, back when the skystreams were open.",
    "The season's crawlers were in, and their buyer remembered the days when the islands of Anvilas and Siroccas could still be reached.")
q(93318, "WANTED: Vulgara the Insatiable", "Zephras Isle", 9, "shendar", 3,
    "Constable Aonda had put a bounty on Vulgara the Insatiable, a winged vuldren that terrorized the Shen'dar highlands.",
    "Vulgara had last been seen on a hilltop southwest of Shen'dar Village, and the peacekeepers called her highly dangerous.",
    "Vulgara's head went to Danarii Bellowveil, and the bounty was paid.",
    "The highlands were rid of Vulgara. With the cult and the bandits to face, Shen'dar was glad to see one danger gone.",
    false, {"part1_corpus.txt #93318 (Vulgara in the Shen'dar Highlands)"})
q(93736, "Unwelcome Spirits", "Zephras Isle", 9, "forever_winds", 4,
    "Strange wind sprites called hollows had appeared in Shadowgale Forest after the spirits of the wind left, and the Windshapers wanted to know why.",
    "Endaria of the Windshapers wanted the hollows of Shadowgale Forest dispersed and their remains brought back for study.",
    "Endaria felt a malevolent, regretful aura from the hollows' essences, and did not look forward to studying them.",
    "The remains of the hollows reached Endaria, who shuddered as she handled them.")
q(93738, "The Broken Construct", "Zephras Isle", 9, "forever_winds", 4,
    "The construct's missing parts led to Belathaan Brightwish of the High Order, and the Windshapers had forbidden that order to meddle with their knowledge.",
    "The news of who had stripped the construct went to Ayessa Dawnsinger of the Windshapers, to decide what came next.",
    "Ayessa was disappointed that Belathaan, Valennia Stormfist's cousin and the son of a Windshaper, had a hand in the broken construct.",
    "Ayessa Dawnsinger heard that the High Order was behind the broken construct, and needed a moment to reflect.",
    true)
q(94003, "The Skybreaker Bulwark", "Zephras Isle", 10, "forever_cult", 4,
    "Seena was the last of the Skybreakers on Zephras. The Al'Aketh had murdered the rest.",
    "A cultist named Zaal Stormshield carried the Skybreaker Bulwark, Seena's ancestral shield, at the Shrine of Akir.",
    "The Skybreaker Bulwark was back with Seena, and her family's honor restored. In thanks she offered to teach the Skybreaker Defense.",
    "Seena had her family's shield again. She offered the Skybreaker Defense, a secret few on Zephras were thought worthy of, and gave away the shield she no longer needed.")
P.threads.fv_windfield = "the Windfield orchard"

---------------------------------------------------------------- Zephras Isle, the war with the Al'Aketh (11-13)
-- LoreHordeStories.lua tells 92640, 92643, 92644, 92646/93835, 94369 and 94485;
-- these are the stages between them. The Windshaper and High Order versions of
-- the Belathaan affair (93746 in LoreHordeStories.lua, 92834 here) each keep
-- their own side's account.
q(93320, "Tower Defense", "Zephras Isle", 11, "forever_cult", 4,
    "The cult was attacking the pylon watchtower east of Valanaar, and Valennia had sent her last spare peacekeepers to break through to the defenders.",
    "Valennia's lieutenant Yorana Windyreed had led the relief force to the east watchtower, if she still lived.",
    "Yorana's fighters were holding the cult off for now, but they were outnumbered and tiring, and the stalemate had to break soon.",
    "The defenders at the east watchtower still held, though the cult had greater numbers.")
q(92642, "Disrupting Logistics", "Zephras Isle", 11, "forever_cult", 3,
    "Yorana could hardly believe Valennia had sent a single fighter against a full assault, but she would take what she could get.",
    "The cult's healers kept its attackers coming at the east watchtower, and Yorana wanted them taken out.",
    "The cult's healers were cut down below the hill. Yorana called it a small miracle that anyone came back alive.",
    "With the healers dead, Yorana hoped her people could rally and push the attackers back.")
q(92645, "Breaking the Breaker", "Zephras Isle", 11, "forever_cult", 5,
    "Belguilos the Breaker commanded the cult's assault from a villa at the foot of the hill. She had been a peacekeeper once, and even then something about her was off.",
    "Yorana believed the attack on the watchtower could not be broken while Belguilos lived.",
    "Belguilos was dead, and Yorana began to think her people might come out of it alive.",
    "The cult's commander at the east watchtower had fallen, and Yorana blessed the four winds for it.").highlight = {
    "Belguilos the Breaker was dead, and the east watchtower might hold after all.",
    "The cult lost its commander at the east watchtower, a former peacekeeper called Belguilos the Breaker."}
q(92880, "Return to Valanaar", "Zephras Isle", 11, "forever_cult", 3,
    "The east watchtower was stable, though mopping up the attackers would take time, and Yorana's report had to reach Valennia.",
    "Yorana sent her report back to Valanaar. The watchtower was stable, and the chances of holding it far better.",
    "Valennia was visibly relieved to hear that the eastern watchtower held.",
    "The report from the eastern watchtower reached Valennia, who thanked the winds.",
    false, {"part1_corpus.txt #92880 (Yorna's Report)"})
q(92881, "The High Elder's Request", "Zephras Isle", 11, "forever_cult", 4,
    "The attacks on both watchtowers were no coincidence. After what the skypriest had done at the western tower, the peacekeepers guessed the cult was after the anchor pylons.",
    "High Elder Shadowsong had a lead that might explain what the cult wanted with the anchor pylons.",
    "Talaanis Shadowsong had a small matter that needed an adventurer's kind of help.",
    "The High Elder was ready to share his lead on the cult's designs.")
q(94568, "The Cult's True Plans", "Zephras Isle", 11, "forever_cult", 4,
    "The turncoat had feared the cult's plans enough to defect, and had died before he could tell them.",
    "The damaged crystal the turncoat had carried was all that remained of his attempt to warn Valanaar.",
    "Open battle with the cult would go badly for the peacekeepers, and Valanaar's leaders agreed they needed a different approach.",
    "Valanaar's leaders weighed sending peacekeepers straight at the cult, and judged they would not fare well in open battle.")
q(92834, "Avenged Tenfold", "Zephras Isle", 11, "forever_cult", 5,
    "Elaadrin Evengale had sent his friend Belathaan Brightwish to the Shrine of Akir to open talks. A box came back holding Belathaan's tongue, dipped in silver pigment.",
    "Elaadrin had argued for dialogue while the Windshapers and peacekeepers postured. After Belathaan's death he wanted the cultists' prayer charms instead.",
    "Elaadrin's eyes crackled with arcane light. The cult had mistaken the High Order's prudence for weakness, he said, and was not ready to pay for that error.",
    "The prayer charms reached Elaadrin, who admitted the Windshapers had been right about the cult, and that his mistake had cost a friend's life.")
q(92840, "Catching Wind", "Zephras Isle", 11, "traditions", 4,
    "The magic that sustained Zephras lingered at the standing stones of the Shen'dar Highlands, sacred to the Windshapers and closed to the High Order's study.",
    "With the Windshapers busy elsewhere, the High Order wanted a device placed at the standing stones to gather data, discreetly.",
    "Windshaper blood had been spilled at the stones. The High Order laid the blame on the Windshapers, who would not retaliate in Valanaar but would not forget.",
    "The device gathered its data at the standing stones, and word of the fighting there spread quickly among the Windshapers.")
q(93740, "Blood for Blood", "Zephras Isle", 11, "forever_cult", 4,
    "Windshaper novices had been found dead in the highlands, and Ayessa suspected the Al'Aketh. Windshapers traded blood for blood.",
    "Ayessa wanted the Al'Aketh to the north killed and their windstone prayer charms brought back as proof.",
    "Ayessa took the windstone charms looking shaken and distant. It had been a trying day, she said.",
    "The prayer charms reached Ayessa, who called it only the start of the cult's reckoning.")
q(98512, "Al'Aketh Assassins", "Zephras Isle", 11, "forever_cult", 3,
    "A scout on patrol near the border had spotted Al'Aketh skulking around a house on the hill to the north.",
    "No one knew what the Al'Aketh wanted at the house on the hill, but it could not be good.",
    "The Al'Aketh at the house were dead. The scout, glad of the help, meant to mention it in the report to Valanaar.",
    "The assassins near the border were dealt with, though what they had been after remained a question.",
    false, {"part1_corpus.txt #98512 (objective: kill 10)"})
q(93065, "Prepare for Battle", "Zephras Isle", 12, "forever_cult", 4,
    "The peacekeepers were mobilizing, and everyone was to meet on the eastern road north out of Valanaar for a final check before the march.",
    "Valanaar's fighters geared up for the march on the cult, with the Windshapers and the High Order among them.",
    "At the eastern road, the peacekeepers said they were as ready as they would ever be.",
    "The final check was done, and the march on the cult could begin.")
q(92947, "Making Our Move", "Zephras Isle", 12, "forever_cult", 5,
    "Valennia sent her best fighters in through the front of the shrine as a distraction, while she led the Windshapers and the High Order in from the flank.",
    "The plan was to punch through quickly and reach the High Priestess, while others caused trouble on the way to the shrine's steps.",
    "At the steps of the shrine, Hyusaa Quickbreeze said they had fought hard to get that far, and it was not over yet.",
    "The assault had reached the shrine steps, where Valennia's second, Hyusaa Quickbreeze, waited. More fighting lay ahead.",
    false, {"part1_corpus.txt #92947 (objective: slay 8)"})
q(93958, "The Inner Sanctum", "Zephras Isle", 12, "forever_cult", 5,
    "Valennia's forces had breached the inner sanctum, and after thick fighting it had gone unsettlingly quiet.",
    "One fighter stayed at the entrance to watch the way back, while someone went in to find Valennia and whatever was left of her forces.",
    "Valennia was found inside, gravely wounded.",
    "Valennia was still alive in the sanctum, but gravely wounded.")
q(93459, "More Al'Aketh Ears", "Zephras Isle", 13, "shadowgale", 2,
    "The druids of Shadowgale Forest kept rumors of a haunting alive to keep folk away, and now the Al'Aketh had come anyway.",
    "Vayn Moonclaw offered coin, and in time the secrets of the order, for the ears of Al'Aketh cultists.",
    "Vayn paid for the ears as promised.",
    "Vayn paid for the cultists' ears, as the druids of Shadowgale had promised.",
    false, {"part1_corpus.txt #93459 (Vayn Moonclaw in Shadowgale Forest)"})
q(92741, "Unwelcome Visitors", "Zephras Isle", 13, "shadowgale", 3,
    "Shrieklings had multiplied in Shadowgale Forest and begun spreading beyond the woods, and a scholar of the High Order wanted their talons.",
    "Shriekling talons had alchemical properties, and the High Order saw scholarly gain in a much-needed culling.",
    "The scholar could not wait to dig into the haul of talons.",
    "The talons went to the High Order, which did not usually work as trappers, but would for a scholar's gain.")
P.threads.fv_shadowgale = "the dangers of Shadowgale Forest"

---------------------------------------------------------------- Zephras Isle, Shadowgale Forest (11-13)
-- The Nightfang Den: Elegael Thornpaw and the Nightclaw druids (94484 to 94491;
-- LoreHordeStories.lua tells 94485). The quest text spells the fallen village
-- Ban'aethall once and Ban'aethal elsewhere; the lines use Ban'aethal. 94487's
-- heirlooms are the coming-of-age relics of 92460. 94902 is a placeholder quest
-- (its text reads "[PH]") and is left out.
q(94484, "Unnerving Silence", "Zephras Isle", 11, "nightfang", 4,
    "Lotheluum in Valanaar had waited too long for word from the druid conclave in Shadowgale Forest, and feared the worst with Ban'aethal in ruins.",
    "The druids of Shadowgale were long overdue with their letters, and Lotheluum wanted Elegael Thornpaw found.",
    "Elegael Thornpaw paled to learn that no reinforcements were coming. Her message had never reached Valanaar.",
    "Elegael learned her call for help had not got through, and decided the druids would have to handle it on their own, and quickly.")
q(94493, "A Sacrifice in Vain", "Zephras Isle", 11, "nightfang", 4,
    "Elegael's message to Valanaar had not got through, and no reinforcements were coming to the druids of Shadowgale.",
    "The Al'Aketh had ambushed the druids' den, and Elegael resolved to deal with it without waiting for Valanaar.",
    "Elegael told how the cultists had struck with little warning, leaving many in her den wounded or dying.",
    "Many in the druids' den lay wounded or dying, and Elegael begged for help before it was too late.")
q(94486, "Feathers for Binding", "Zephras Isle", 11, "nightfang", 3,
    "Elegael's poultice needed feathers from young shrieklings, to cover the moss and keep its antiseptic sap from drying.",
    "The shrieklings of Shadowgale were usually docile but had turned hostile, and Elegael regretted asking for the young ones' feathers.",
    "Elegael took the feathers and promised to use every one, so the shrieklings' deaths would not be wasted.",
    "The shriekling feathers gave Elegael what she still needed for her poultices.")
q(94487, "Unwanted and Unworthy", "Zephras Isle", 11, "nightfang", 4,
    "The Al'Aketh had ambushed the druids without warning, and Elegael wanted the cultists slain and the heirlooms they wore taken back.",
    "Elegael said the cultists did not deserve to be called shen'dorei. Their ashes, she said, did not deserve the winds.",
    "Elegael looked at the bloodied heirlooms in distress. So many young lives were gone, she said, and the relics would wait in the High Elder's collection for a worthier generation.",
    "The cultists' heirlooms would go back to the High Elder, Elegael said, to wait for the next generation coming of age.")
q(94488, "The Ties That Bind", "Zephras Isle", 11, "nightfang", 5,
    "Haalien, a druid of the circle who had vanished months before, had joined the cultists who attacked his own kin.",
    "Elegael caught Haalien's scent over the bloodshed, and wanted his head for the blood he had spilled.",
    "Elegael grimaced at Haalien's head and nodded. He was her cousin, and she could not easily have struck him down herself.",
    "Haalien was dead. Elegael asked that no one mourn him, for his malice had killed many innocents that day.")
q(94490, "Ripped Missive", "Zephras Isle", 12, "nightfang", 5,
    "A torn, bloodstained note tucked behind Haalien's bracer held something of why the cult had attacked the druids' den.",
    "Haalien had carried orders, and Elegael would want to read them.",
    "The cult had come for the pylon, and the druids had died for being in the way. The orders seemed to come from Valanaar, and Elegael sent the missive to Lotheluum.",
    "Elegael read that the attack was about the pylon, not her people. If the orders came from Valanaar, a traitor was hiding there.")
q(94489, "The Wounds of Betrayal", "Zephras Isle", 12, "nightfang", 5,
    "Elegael's poultices were ready for the druids in the Nightfang Den, too hurt to heal their own wounds. There were so few shen'dorei druids that every life was precious.",
    "Elegael's mate, Jorel Windsinger, had been in dire condition when she left the den, and she asked that he be found.",
    "Elegael heard what had become of Jorel and the others, and choked back a sob. She swore that anyone allied with the Al'Aketh would feel her wrath.",
    "The poultices reached the den, but the news of Jorel was worse than Elegael had feared. She swore the cult would pay.",
    false, {"part1_corpus.txt #94489 (the Nightfang Den; heal 7 druids)"})
q(94491, "The Fate of the Den", "Zephras Isle", 12, "nightfang", 6,
    "Someone in Valanaar was feeding the cult information, and Lotheluum had to hear of it, and of those the den had lost.",
    "Elegael was in no shape to travel, and stayed behind with cultists still to slay.",
    "Lotheluum went pale at the account of the den. If the missive was genuine, Valanaar held an accomplice or a traitor, and he took it straight to the High Elder.",
    "Lotheluum had no words for the loss. He carried the missive to the High Elder, determined that the druids' sacrifice would not be in vain.").highlight = {
    "Lotheluum learned of the slaughter in the Nightfang Den, and of a traitor feeding the cult from Valanaar.",
    "The missive from the den reached Lotheluum, and the High Elder would hear of a traitor in Valanaar."}
q(93165, "Mercy Falls on Deaf Ears", "Zephras Isle", 13, "nightfang", 2,
    "The Al'Aketh had brought tragedy on the Nightclaw enclave, and its druids meant to repay blood with blood.",
    "The Nightclaw offered coin, and in time their secrets, for the ears of slain cultists.",
    "The Nightclaw paid for the ears and hoped the cult understood that their resentments ran deep.",
    "The cultists' ears were counted and paid for, and the Nightclaw asked for more.",
    false, {"part1_corpus.txt #93165 (objective: 10 cultist ears)"})
q(93159, "The Strange Hermit", "Zephras Isle", 13, "shadowgale", 2,
    "A hooded hermit lived alone in Shadowgale Forest, so long out of company that speaking came hard.",
    "The hermit of Shadowgale stammered a greeting and asked how the day was going.",
    "The hermit had friends and handmade things, and seemed to need little else, but admitted it was nice to talk to someone who talked back.",
    "The forest spirits tried to talk with the hermit, but only ever sang. A visitor who answered made a welcome change.")
q(93160, "The Forest's Bounty", "Zephras Isle", 13, "shadowgale", 2,
    "The hermit had gathered the acorns close by, but raptor-birds roamed the rest of the forest floor.",
    "The hermit offered to cook something tasty in return for acorns, rather than risk becoming a giant bird's lunch.",
    "The hermit swore the acorns were delicious roasted, and went off to cook them.",
    "The acorns were in, and the hermit set about roasting them.")
q(93172, "Free the Hollows", "Zephras Isle", 13, "shadowgale", 4,
    "Ghost-like spirits gathered at the old ruins northeast of the hermit's home, and some nights they seemed to sing something very sad.",
    "The hermit believed something terrible had happened at the ruins, and that the spirits were trapped there.",
    "The hollows at the ruins were set free, and the hermit hoped they would find peace.",
    "The trapped spirits were released from the ruins, and the hermit gave quiet thanks.")
q(94896, "Aid For The Refugees", "Zephras Isle", 11, "banaethal", 3,
    "Ban'aethal, deep in Shadowgale Forest, had begun to fall into the sky one night, and its people fled with little more than their clothes.",
    "Ealaane and the other refugees could not go back to Ban'aethal, and hoped someone would recover what they had left behind.",
    "Ealaane promised to return the recovered belongings to their owners. It gave the refugees a place to start over.",
    "The belongings from Ban'aethal went back to the refugees, a small kindness after losing their home.",
    false, {"part1_corpus.txt #94896 (objective: collect 8)"})
q(94897, "The Fate of a Loved One", "Zephras Isle", 11, "banaethal", 5,
    "Resaan had gone back to Ban'aethal for supplies though Ealaane begged him not to, and a week had passed without word.",
    "Ealaane feared Resaan was dead, and asked that his heirloom be brought back if he was.",
    "Ealaane wept over Resaan's heirloom. Their life together had only just begun, and now her home and her love were both gone.",
    "Resaan had not survived the ruins of Ban'aethal. His heirloom gave Ealaane some closure, if little else.",
    false, {"part1_corpus.txt #94897 (find Resaan in the Ruins of Ban'aethal)"})
P.threads.fv_nightfang = "the slaughter at the Nightfang Den"
P.threads.fv_banaethal = "the fall of Ban'aethal"

---------------------------------------------------------------- Tirisfal, the risen paladins and Bandarion Keep (1-13)
-- Forever's Forsaken paladins: Aramis Hammerhand at Deathknell, Shari Stilwell
-- in Brill, Danitha Morr's order at Bandarion Keep, and Forever's own history
-- of Naxxramas striking at the Undercity (#96896, #96898), where Garek Bandarion
-- fell. Class quests (category -141) are only offered to paladins, so a stage
-- here never makes a paladin of anyone else. Givers: LoreForever quest:98601,
-- 90902, 91208, 91209, 98389 (Shadow Priest Sarvis, Aramis Hammerhand).
q(98601, "A Difficult Path", "Tirisfal Glades", 1, "risen", 4,
    "A scroll reeking of the Light had come to Deathknell for a newly risen paladin, and Shadow Priest Sarvis wanted to be well away when it was read.",
    "Paladins made Shadow Priest Sarvis uneasy, but the scroll he handed over sent a risen paladin to Aramis Hammerhand.",
    "Aramis Hammerhand said the training could begin in earnest. The Light would hurt now, and the pain, he said, was a crucible.",
    "Aramis warned against turning from the Light even for a moment, and urged that its pain be embraced.",
    false, {"LoreForever quest:98601 (wiki: World of Warcraft: Forever)"})
q(90902, "Rediscovering the Light", "Tirisfal Glades", 2, "risen", 4,
    "Aramis Hammerhand welcomed another newly risen paladin, and warned that healing with the Light would now hurt.",
    "Injured Deathguards near the chapel needed healing, and the only way past the pain of the Light, Aramis said, was through it.",
    "The Forsaken were hardy to pain, Aramis said, and this pain was proof of still serving the Light.",
    "The injured Deathguards were healed, and Aramis called the pain that came with it a badge of honor.",
    false, {"part1_corpus.txt #90902 (objective: heal 5)", "LoreForever quest:90902 (wiki: World of Warcraft: Forever; Injured Deathguard)"})
q(91208, "Coming to Terms", "Tirisfal Glades", 4, "risen", 4,
    "A newly risen paladin had fled into the hills west of the chapel, unable to bear becoming what she had fought in life.",
    "Aramis hoped a kind word could lead the frightened paladin back into the Light, though many in her state turned violent.",
    "The frightened paladin could not be brought back. Aramis said a prayer for her, and called her end a clean one.",
    "Aramis said that sometimes the best the Forsaken could give their risen was a clean end, and prayed to the Light for her.",
    false, {"LoreForever quest:91208 (wiki: World of Warcraft: Forever)"})
q(98389, "A Light in the Darkness", "Tirisfal Glades", 4, "risen", 3,
    "Some Forsaken feared their paladins would smite them as monsters, and Aramis meant to show otherwise.",
    "Freshly raised Forsaken were trapped by the spiders of Night's Web Hollow, and freeing them would prove what the paladins were for.",
    "The webbed Forsaken were freed. Aramis hoped Executor Arren and the others would see that the paladins lived to protect their people, as in life.",
    "Aramis believed the paladins would in time be seen as just as valuable to the Dark Lady as any other Forsaken.",
    false, {"LoreForever quest:98389 (wiki: World of Warcraft: Forever; Webbed Forsaken)"})
q(91209, "Continue Your Training", "Tirisfal Glades", 4, "risen", 3,
    "Aramis sent his risen paladins on to Shari Stilwell in {p:Brill}, warning that many in the Dark Lady's service distrusted those close to the Light.",
    "The lands of the Forsaken still needed protecting, and the next part of a paladin's training lay with Shari Stilwell in {p:Brill}.",
    "Shari Stilwell welcomed one more of their number, and promised guidance once the people of {p:Brill} had seen proof of worth.",
    "Shari Stilwell took over the training in {p:Brill}, where there was work for any paladin willing.",
    false, {"LoreForever quest:91209 (wiki: World of Warcraft: Forever; Aramis Hammerhand to Shari Stilwell)"})
q(91282, "A Second Home", "Tirisfal Glades", 11, "risen", 4,
    "Risen paladins had begun to form a new order in Tirisfal, at a monastery called Bandarion Keep on the bluffs of Northface Rock.",
    "The paladins of Tirisfal believed faith and fellowship were the way for the risen to thrive, and their new order kept a keep northwest of the Solliden Farmstead.",
    "Breton Samuels welcomed the new recruit to Tyr's Watch, as he called it.",
    "At Bandarion Keep, Breton Samuels took in another recruit.",
    false, {"part1_corpus.txt #91282 (Bandarion Keep; Breton Samuels)"})
q(91285, "Murlocs at the Gates", "Tirisfal Glades", 11, "risen", 2,
    "The Vile Fin murlocs had once spawned where the keep now stood, and they had attacked it ever since the paladins drove them out.",
    "Breton Samuels could not rebuild the keep with murlocs lurking in the bluffs and around the lake.",
    "The murlocs were driven back for now. Breton hoped it would slow them, since rebuilding was hard enough without a spear in the back.",
    "The Vile Fin attacks would not stop entirely, Breton said, but the keep had some breathing room.",
    false, {"part1_corpus.txt #91285 (Vile Fin Attackers and Seers; Breton Samuels)"})
q(91294, "Touring the Grounds", "Tirisfal Glades", 11, "risen", 3,
    "With the murlocs under control, Breton Samuels encouraged a look around the keep before meeting its leader.",
    "Bandarion Keep was not much yet, Breton said, but it was home.",
    "Danitha Morr, the closest thing the keep had to a commander, offered fellowship to those still loyal to the Light.",
    "The keep's leader, Danitha Morr, welcomed help, for much work remained before the order was fully established.")
q(91316, "Making Repairs", "Tirisfal Glades", 11, "risen", 2,
    "Far from the Undercity, the keep was short of building materials, and an old root cellar in ruined Shadowvale might hold some.",
    "The keep looked imposing on its bluffs, the paladins admitted, but it was hard to supply so far from proper civilization.",
    "Sturdy lumber from Shadowvale reached the keep, and more recruits would be sent to clear out the rest of the cellar.",
    "The Shadowvale cellar yielded its lumber, and the restoration of the keep could go on.",
    false, {"part1_corpus.txt #91316 (12 Sturdy Lumber from Shadowvale)"})
q(91317, "The Tarnished", "Tirisfal Glades", 12, "risen", 5,
    "Some risen paladins had carried their old prejudices into undeath, and these Tarnished were killing other Forsaken from Shadowvale.",
    "Every Forsaken the Tarnished killed made the people of Tirisfal trust their paladins less, and the order wanted their leader's head.",
    "Commander Rudolph Gelhardt's head was taken. The order hoped it would help secure its place in Tirisfal, though acceptance might take decades.",
    "The Tarnished at Shadowvale were broken. Earning the Forsaken's trust, the order expected, could still take years.",
    false, {"part1_corpus.txt #91317 (Commander Rudolph Gelhardt)"})
q(95803, "A Token of Good Faith", "Undercity", 12, "risen", 6,
    "Sylvanas Windrunner mistrusted the paladins and all but openly disparaged them. Danitha sent the Tarnished commander's head to the {p:Undercity} to show the order kept its own house.",
    "Rudolph Gelhardt's head was a gift for the Dark Lady, proof of the paladins' devotion to the Forsaken.",
    "Sylvanas did not doubt Danitha's sincerity, but expected more paladins to go mad and turn the Light on their own. The order would be watched.",
    "The Dark Lady received the head coldly. She might one day stop tolerating the order, she said, and told its paladins to serve diligently.",
    false, {"part1_corpus.txt #95803 (Rudolph Gelhardt's head to Sylvanas Windrunner)"}).highlight = {
    "Sylvanas took the Tarnished commander's head, and warned that the paladins' order would be watched.",
    "The Dark Lady accepted the paladins' token, though not yet their order."}
q(96895, "The Argent Emissary", "Tirisfal Glades", 13, "argent", 3,
    "Two Forsaken emissaries of the Argent Dawn had passed through Tirisfal, and not everyone liked them poking around unsupervised.",
    "One of the Argent emissaries had gone southeast, toward Scourge cultists snooping near the {p:Undercity}.",
    "The Argent Dawn member was found near the {p:Undercity}, watching the cultists and warning to stay low.",
    "The emissary was found keeping watch on the cultists, who were not to be trifled with.",
    false, {"part1_corpus.txt #96895"})
q(96896, "A Righteous Cause", "Tirisfal Glades", 13, "argent", 5,
    "Leonid Barthalomew the Revered had fought beside Danitha Morr when Naxxramas attacked the {p:Undercity}, and lost many friends that day.",
    "Garek Bandarion, after whom the keep was named, had died defending the {p:Undercity} from Naxxramas. He might have been the first Forsaken to wield the Light as a paladin.",
    "Leonid would stay a while among old friends before returning to {p:Light's Hope Chapel}, where the Argent Dawn could always use more help.",
    "Leonid saw Bandarion's legacy living on in Danitha's order, and wished the rest of the Forsaken felt the same.",
    false, {"part1_corpus.txt #96896 (Danitha Morr and Leonid Barthalomew the Revered)"})
q(96897, "The Cult of the Damned", "Tirisfal Glades", 13, "argent", 3,
    "Cultists of the Cult of the Damned were at work on the outskirts of the {p:Undercity}, and the Argent emissary wanted them stopped.",
    "Between the mindless dead and the Scarlet Crusade, Tirisfal had enough to deal with without the Scourge's living servants.",
    "The cultists were cut down. The emissary warned that only vigilance would keep Lordaeron's history from repeating.",
    "The Dark Neophytes and Enforcers near the {p:Undercity} were dead.",
    false, {"part1_corpus.txt #96897 (Dark Neophytes and Dark Enforcers)"})
q(96898, "Remnants of War", "Tirisfal Glades", 13, "argent", 4,
    "When Naxxramas bore down on the {p:Undercity}, the great necrotic crystal beneath it had shattered, and its fragments lay scattered near the city.",
    "The cultists had likely come for the necrotic crystal fragments, and the Argent emissary meant to deny them.",
    "The most conspicuous fragments were gathered. The emissary expected Tirisfal's people to be digging the rest out of the ground for years.",
    "The necrotic fragments were out of the Scourge's reach, and the cult's work near the {p:Undercity} was slowed.",
    false, {"part1_corpus.txt #96898 (12 Necrotic Crystal Fragments)"})
q(96899, "Bandarion Keep", "Tirisfal Glades", 13, "argent", 4,
    "The Argent emissary and his commander had been bound for Bandarion Keep before the cultists turned up.",
    "The emissary's commander, Leonid Barthalomew, waited at Bandarion Keep to the northwest.",
    "Leonid remembered the keep from the Argent Dawn's war against the Scourge in Tirisfal, and was glad Danitha's paladins kept it now.",
    "The keep had once been the Argent Dawn's, Leonid said, and Danitha had named it after a friend they shared.",
    false, {"part1_corpus.txt #96899 (Leonid Barthalomew at Bandarion Keep)"})
-- The order's errand in Silverpine (class quests, 22-26): Lumina Windsinger, a
-- Windshaper on Azeroth, and the Moonsilver Blade for Old Fire-Eye. Givers:
-- part1_corpus.txt objectives; LoreForever quest:91859 (Trevan Rol to
-- Deathguard Baldren). The seller of the Kor Gem lore in Ashenvale is unnamed.
q(91858, "Diplomatic Incident", "Silverpine Forest", 22, "lumina", 4,
    "Two dignitaries of the Earthen Ring had gone missing in {p:Silverpine} on their way to {p:Tarren Mill}, and Danitha saw a chance for her order to prove its worth to the Horde.",
    "Rumor called the missing Earthen Ring travelers a diplomatic incident. Bandarion Keep's man at {p:the Sepulcher}, Trevan Rol, knew more.",
    "Trevan Rol already knew why Danitha had sent help, and called the business a damned fine mess.",
    "At {p:the Sepulcher}, Trevan Rol took up the search for the missing travelers with the order's help.",
    false, {"part1_corpus.txt #91858 (Trevan Rol at the Sepulcher)"})
q(91859, "A Curious Pair", "Silverpine Forest", 22, "lumina", 4,
    "The missing dignitaries were no ordinary diplomats. One was a tauren, and the other, Trevan would swear, a high elf.",
    "No one knew why an elf traveled with a tauren through Horde lands, and Trevan sent the search on to Deathguard Baldren at the town's entrance.",
    "Deathguard Baldren cared little for paladins, but admitted the timing was impeccable.",
    "Baldren had news to share, though he made no secret of his opinion of paladins.",
    false, {"LoreForever quest:91859 (wiki: World of Warcraft: Forever; Trevan Rol to Deathguard Baldren)"})
q(91860, "A Grim Fate", "Silverpine Forest", 22, "lumina", 4,
    "Deathguard Baldren had seen gnolls dump a large body onto a pyre on {p:Fenris Isle}, and thought the elf was likely long dead.",
    "Baldren called the search a lost cause of the kind paladins loved, and pointed the way to {p:Fenris Isle} anyway.",
    "The body on the pyre was a tauren's, heavily gnawed. There was no sign of the elf woman, and the fortress nearby might still hold her.",
    "Only the tauren had burned on the pyre. The elf might still be alive deeper in the fortress.",
    false, {"part1_corpus.txt #91860"})
q(91861, "Into Fenris Keep", "Silverpine Forest", 22, "lumina", 4,
    "Only one body had been found on the pyre, and that gave some hope that the elf was alive inside Fenris Keep.",
    "The missing member of the Earthen Ring party had to be somewhere in the fortress north of the pyre.",
    "Deep in the keep, a captive asked whether her finder was one of the Forsaken, and begged to be freed while there was time.",
    "The missing elf was found alive in Fenris Keep, caged and pleading for haste.",
    false, {"part1_corpus.txt #91861"})
q(91862, "Lumina Windsinger", "Silverpine Forest", 22, "lumina", 5,
    "The captive was no high elf. She was Lumina Windsinger, a Windshaper of the shen'dorei, come as a guest of the Earthen Ring to study the elemental convergences of Arathi.",
    "Lumina's cage key lay with the gnolls nearby, and she would tell the rest once safely away.",
    "Lumina was free, though not yet out of danger.",
    "The cage opened, and Lumina called the gnolls the second worst creatures she had met on Azeroth.",
    false, {"part1_corpus.txt #91862"})
q(96204, "The Windshaper's Wrath", "Silverpine Forest", 22, "lumina", 5,
    "Freed, Lumina meant to make the gnolls regret ever laying eyes on a Windshaper.",
    "Lumina had to be brought out of Fenris Keep, and she meant to make the gnolls pay on the way.",
    "Lumina reached {p:the Sepulcher} and met Trevan. She had heard little good of paladins, but said they had a friend among the Windshapers.",
    "As a shen'dorei walking Horde lands, Lumina knew how easily prejudice took root. The paladins of Bandarion Keep, she said, had a friend among the Windshapers.",
    false, {"part1_corpus.txt #96204"}).highlight = {
    "Lumina Windsinger was brought out of Fenris Keep, and the paladins gained a friend among the Windshapers.",
    "Lumina reached the Sepulcher alive, and promised the paladins a friend among the Windshapers."}
q(95034, "The Debt", "Silverpine Forest", 24, "lumina", 5,
    "It had not been gnolls who first attacked Lumina and Banon on the road, but a worgen. Banon threw himself in its path and was badly bitten.",
    "Lumina wanted it known what had truly happened to Banon on the road through {p:Silverpine}.",
    "Pierced by gnoll blades and at the end of his strength, Banon had turned on Lumina, still knowing her and unable to stop himself. She swore on the sky to kill the creature that doomed him.",
    "Lumina swore upon the sky to see the worgen that doomed Banon dead, so it could never do the same to another.",
    false, {"part1_corpus.txt #95034"})
q(95036, "A Moon-Kissed Blade", "Silverpine Forest", 25, "lumina", 4,
    "The worgen that attacked Lumina was Old Fire-Eye, the biggest of his kind in {p:Silverpine}, and some magic kept him from staying dead.",
    "Putting Old Fire-Eye down would take a special weapon, and Trevan Rol had a list of what was needed to forge it.",
    "Trevan had the materials, and knew of a smith who could make the blade.",
    "The materials for the moon-kissed blade were gathered. The Light needed a good blade to guide, Trevan said.",
    false, {"part1_corpus.txt #95036 (Trevan Rol in the Sepulcher)"})
q(95042, "Seeking the Kor Gem", "Ashenvale", 25, "lumina", 3,
    "A scholar in {p:Ashenvale} was amused to meet a Forsaken paladin, and said the Kor Gems of the naga could empower a weapon.",
    "The naga below {p:Blackfathom Deeps} still used Kor Gems, and the scholar warned against going alone.",
    "The gem was corrupted by the naga witches, but the scholar dispelled the evil simply enough, and offered to buy it instead.",
    "The scholar cleansed the gem's corruption, with some regret at what might have been learned from it.",
    false, {"part1_corpus.txt #95042"})
q(95111, "An Underrated Talent", "Hillsbrad Foothills", 25, "lumina", 3,
    "Ott, a weaponsmith of {p:Tarren Mill}, sold plain blades to travelers, but smiths in the {p:Undercity} had once mistaken one of his swords for a master's work.",
    "Trevan wanted to give Ott, an unassuming orc, the chance to make something truly special.",
    "Ott had never been asked for a custom commission, and wondered why anyone would pass over the smiths of the {p:Undercity} for him.",
    "Ott accepted the commission. He made humble, honest weapons, he said, and sought no glory.",
    false, {"part1_corpus.txt #95111"})
q(95125, "Ott's Masterwork", "Hillsbrad Foothills", 25, "lumina", 4,
    "Ott called the materials truly fine, and hoped he could live up to the trust placed in him.",
    "With the materials in hand, Ott began to forge the blade.",
    "Ott called the blade his finest work, and said farewell in the orcish way.",
    "The blade was finished, the best Ott had ever made.")
q(95126, "The Moonsilver Blade", "Silverpine Forest", 25, "lumina", 4,
    "Ott's finished blade was to go back to Trevan Rol, with Ott's thanks for the chance.",
    "Trevan waited at {p:the Sepulcher} to see whether Ott had managed the commission.",
    "Trevan inspected the Moonsilver Blade and declared it would do nicely. He had known Ott had it in him.",
    "The Moonsilver Blade passed Trevan's inspection. Only the beast remained.",
    false, {"part1_corpus.txt #95126"})
q(95140, "Old Fire-Eye", "Silverpine Forest", 26, "lumina", 6,
    "Old Fire-Eye hunted south of {p:the Sepulcher}, near the gates of Gilneas, and the Moonsilver Blade had been made to end him.",
    "Lumina prayed the new blade would not fail against the worgen that had doomed Banon.",
    "Old Fire-Eye was destroyed, and Banon could rest in peace. Lumina laid a small measure of her people's magic on the bloodied blade.",
    "Lumina's oath was kept. She touched the bloodied blade with a little of the winds' magic and prayed it would serve well.",
    false, {"part1_corpus.txt #95140 (Use the Moonsilver Blade to destroy Old Fire-Eye)"}).highlight = {
    "Old Fire-Eye fell to the Moonsilver Blade, and Lumina Windsinger's oath for Banon was kept.",
    "The worgen that doomed Banon was dead, and Lumina blessed the blade that killed it."}
P.threads.fv_lumina = "Lumina Windsinger and the Moonsilver Blade"
P.threads.fv_risen = "the risen paladins of Tirisfal"
P.threads.fv_argent = "the Argent Dawn in Tirisfal"

---------------------------------------------------------------- Westfall, Alba Fairmoon and the poisoned land (12-18)
-- Forever's Westfall chain: the poison in the soil traced from the wells to a
-- forge in the Deadmines. Givers: LoreForever quest:92742-92819 (Alba Fairmoon,
-- Sprite Jumpsprocket, Jasper Fel). 92819's verdict on Stormwind is Alba's own
-- and stays attributed. 93928 is a placeholder ("(PH) Thanks!") and is left out.
q(98021, "Journey to Sentinel Hill", "Westfall", 13, "alba", 3,
    "Stormwind sent newcomers who wished to do some good to Gryan Stoutmantle at {p:Sentinel Hill}, where the people of {p:Westfall} needed aid.",
    "The troubles of {p:Westfall} might seem small to someone from another plane, but to the people living them they meant everything.",
    "Gryan Stoutmantle had begged Stormwind for aid for months, and grumbled that it had sent him a skinny elf. Beggars could not be choosers, he said.",
    "At {p:Sentinel Hill}, Gryan Stoutmantle took the help Stormwind had sent and set about putting it to work.")
q(92742, "Testing the Wells", "Westfall", 12, "alba", 3,
    "Something was poisoning the land of {p:Westfall}, and Alba Fairmoon meant to begin with the groundwater under the farms.",
    "Alba Fairmoon wanted water from the wells at the Jansen Stead and the Molsen Farm, to learn what was corrupting the land.",
    "Samples from the wells of the Jansen Stead and the Molsen Farm went to Alba Fairmoon for testing.",
    "Alba had well water from two of Westfall's farms, the first step in finding the poison.")
-- Not in corpus_vanilla_quests.txt: the description comes from part1_corpus.txt
-- and the completion text was never captured, so the outcome stays minimal.
P.questIDs[92742].source = {"part1_corpus.txt quest 92742 (description only)"}
q(92744, "Murloc Gills", "Westfall", 12, "alba", 3,
    "Alba feared the corruption of Westfall's crops had reached the sea, and that tainted fish could bring famine to Stormwind.",
    "Murloc gills were sensitive to contaminants, and Alba meant to read the coast's seawater in them.",
    "The gills looked healthy, for now. Alba would not let that make her complacent.",
    "By the evidence of the murloc gills, the sea off {p:Westfall} was still clean.")
q(92745, "The State of the Mines", "Westfall", 14, "alba", 3,
    "The well samples held toxic metals, and if the poisoning went on, it would be decades before crops grew in that soil again.",
    "The Defias held the mines of {p:Westfall} and stripped them with creature labor, and Alba wanted their miners at Jangolode and the Gold Coast Quarry cut down.",
    "The Defias miners were disrupted, but Alba feared the poison came from somewhere else.",
    "The miners at the Jangolode and the Gold Coast were dealt with, yet the source of the poison still eluded Alba.")
q(92747, "Moonbrook Espionage", "Westfall", 16, "alba", 4,
    "The poison did not come from the mines already searched. The Deadmines beneath {p:Moonbrook}, abandoned since the First War, were the last lead.",
    "Alba wanted evidence from {p:Moonbrook} that the old Deadmines were working again.",
    "Alba looked over the industrial supplies found in {p:Moonbrook} and asked what it all was.",
    "Moonbrook yielded suspicious industrial supplies, signs of some operation in the old mines.",
    false, {"LoreForever quest:92747 (wiki: World of Warcraft: Forever; Suspicious Industrial Supplies)"})
q(92748, "Explosive Consultation", "Westfall", 16, "alba", 3,
    "The supplies from {p:Moonbrook} pointed to a massive industrial operation in the Deadmines, and to the source of the toxins.",
    "Whatever lay in the Deadmines would be hard to destroy, and Alba wanted an engineer in Stormwind's Dwarven District to supply explosives.",
    "In the Dwarven District, Sprite Jumpsprocket asked whether something needed blowing up.",
    "Sprite Jumpsprocket, an engineer of the Dwarven District, was ready to listen.",
    true, {"LoreForever quest:92748 (wiki: World of Warcraft: Forever; Alba Fairmoon to Sprite Jumpsprocket)"})
q(92749, "A Dynamite Plan", "Westfall", 16, "alba", 3,
    "Industrial sabotage caught Sprite Jumpsprocket's attention, and the plan began with dynamite.",
    "Sprite needed coarse dynamite for the bomb meant for the Deadmines.",
    "The dynamite was a great start, Sprite said, and needed only tying together and a little extra zing.",
    "Sprite had the dynamite and set about building something with more zing.",
    false, {"LoreForever quest:92749 (wiki: World of Warcraft: Forever; Coarse Dynamite)"})
q(92750, "Detonation at a Distance", "Westfall", 16, "alba", 3,
    "Sprite had no remote detonator, and suggested the sneaky folk of Stormwind Intelligence might find one.",
    "A controlled explosion meant keeping all one's limbs, and that needed a remote detonator.",
    "Jasper Fel of Stormwind Intelligence asked whether something specific was wanted.",
    "Stormwind Intelligence had been found, and Jasper Fel was listening.",
    true, {"LoreForever quest:92750 (wiki: World of Warcraft: Forever; Sprite Jumpsprocket to Jasper Fel)"})
q(92751, "Detonation at a Distance", "Westfall", 16, "alba", 4,
    "Stormwind Intelligence already knew of the work in {p:Moonbrook}. Jasper Fel offered a prototype remote detonator, and asked that his part be kept from the elf.",
    "Jasper Fel advised being well outside the caves before any explosion, and handed over his engineers' newest detonator.",
    "Sprite was delighted. It was just the detonator they needed.",
    "The prototype detonator reached Sprite, and the bomb could be finished.",
    true, {"LoreForever quest:92751 (wiki: World of Warcraft: Forever; Jasper Fel to Sprite Jumpsprocket)"})
q(92752, "Explosive Consultation", "Westfall", 16, "alba", 3,
    "Sprite's bomb was ready, and the detonator with it.",
    "With the bomb finished, Alba Fairmoon waited to hear of it.",
    "Alba was glad to see the bomb and its detonator brought back.",
    "The bomb reached Alba Fairmoon, ready for the Deadmines.",
    true, {"LoreForever quest:92752 (wiki: World of Warcraft: Forever; Sprite Jumpsprocket to Alba Fairmoon)"})
q(92753, "Destruction in Deadmines", "The Deadmines", 18, "alba", 5,
    "Alba believed the poison came from a large forge hidden in the Deadmines, and the explosives had to be placed there.",
    "Alba would wait in the hills behind {p:Moonbrook} until the forge was found and the bomb set. With the forge gone, the land might begin to heal.",
    "The forge was found and the bomb planted. Only the detonation remained.",
    "The bomb lay at the forge in the Deadmines, and Alba waited for the last step.",
    true)
q(92819, "Destruction in Deadmines", "Westfall", 18, "alba", 6,
    "The bomb was planted at the forge, and all that was left was the detonator.",
    "Alba Fairmoon waited in the hills behind {p:Moonbrook} for the end of it.",
    "The detonator was used and the forge destroyed. Alba could hardly believe that Stormwind would put its military ambitions before the livelihood of its people.",
    "With the forge gone, Alba was left with a bitter thought, that Stormwind had put its military ambitions over its own people.",
    true).highlight = {
    "The poisoning forge beneath {p:Moonbrook} was destroyed, and Alba Fairmoon blamed Stormwind's military ambitions for it.",
    "The forge in the Deadmines was blown apart, and Alba could hardly believe what Stormwind had put before its people."}
fallback("Explosive Consultation", "Westfall", "alba", "92748, 92752",
    "Alba Fairmoon's search for the poison in {p:Westfall} needed explosives from Stormwind's Dwarven District.",
    "An engineer named Sprite Jumpsprocket was building a bomb for the Deadmines.",
    "The work on the bomb for the Deadmines moved forward.",
    "One step toward the bomb was done.")
fallback("Detonation at a Distance", "Westfall", "alba", "92750, 92751",
    "The bomb for the Deadmines needed a remote detonator, and Stormwind Intelligence had one.",
    "A controlled explosion beneath {p:Westfall} needed a detonator that worked from afar.",
    "The search for a remote detonator moved forward.",
    "One step toward a safe detonation was done.")
fallback("Destruction in Deadmines", "Westfall", "alba", "92753, 92819",
    "Alba Fairmoon had traced the poison of {p:Westfall} to a forge hidden in the Deadmines.",
    "A bomb from Stormwind's Dwarven District was meant for the forge beneath {p:Moonbrook}.",
    "The plan against the hidden forge moved forward.",
    "One step of the work in the Deadmines was done.")
q(92909, "Harvesting the Harvesters", "Westfall", 15, "harvesters", 3,
    "A tinkerer from Ironforge had come to recalibrate the harvesters of {p:Westfall}, and they had chased the poor tinkerer into a stable.",
    "Isosprings and gyrostabilizers from the harvesters could build a device to cover an escape from the stable.",
    "The tinkerer had the parts and set to work on an escape plan.",
    "The harvester parts reached the stable, and the escape plan could begin.",
    true)
q(92910, "Harvesting the Harvesters", "Westfall", 15, "harvesters", 2,
    "A part salvaged from a harvester was mostly intact, and someone interested in harvest golems would want to see it.",
    "The harvest golems of {p:Westfall} had turned aggressive, and an intact piece of one was worth studying.",
    "The tinkerer from Ironforge took the salvaged part with great interest.",
    "The salvaged assembly reached the tinkerer, who wanted to know what it was.",
    true)
q(92911, "Harvesting the Harvesters", "Westfall", 15, "harvesters", 3,
    "The salvaged assembly showed the tinkerer what made the harvesters tick, and gave an idea for overriding them, at least for a moment.",
    "The tinkerer needed more parts to build a device against the harvesters.",
    "The device was ready to try. The tinkerer would stay behind in the stable, which was starting to feel like home.",
    "The tinkerer handed over the finished device and chose to stay in the stable.",
    true)
fallback("Harvesting the Harvesters", "Westfall", "harvesters", "92909, 92910, 92911",
    "The harvest golems of {p:Westfall} had grown aggressive, and a tinkerer from Ironforge was hiding from them in a stable.",
    "Parts from the harvesters could help the trapped tinkerer.",
    "The tinkerer's work against the harvesters moved forward.",
    "One step of the tinkerer's plan was done.")
P.threads.fv_alba = "Alba Fairmoon's search for Westfall's poison"
P.threads.fv_harvesters = "the tinkerer in the stable"

---------------------------------------------------------------- Duskwood and Stormwind (22-28)
-- Sirra Von'Indi's Valor family search and King Terenas's statuette. 96137
-- (Ira's Dagger) and 98219 (The Shamed Lieutenant) have no captured objective or
-- completion and are left out; 98447 has an objective but no completion, so its
-- outcome stays at what the objective itself establishes.
q(96139, "The Valor Family", "Duskwood", 22, "valor", 3,
    "Sirra Von'Indi kept a library in {p:Darkshire} but had almost nothing on Raven Hill, whose history had died with its people.",
    "Sirra wanted Darkshire's heroes remembered as well as its foes, and asked for anything found at Raven Hill.",
    "The tome from Raven Hill was about the Valor family. Sirra had heard of a few of them, good folk, and made a copy.",
    "Sirra doubted the Valors merited a whole tome of their own, but copied it and asked for anything else about them.",
    true, {"part1_corpus.txt #96139 (Sirra Von'Indi in Darkshire)"})
q(96138, "Merrick's Bow", "Duskwood", 28, "valor", 3,
    "A bow left by the spirit of Merrick Valor, a Watcher who had kept the roads safe, hinted at his unfinished business.",
    "Merrick's spirit wandered the roads near Raven Hill, and the Splint Fist ogres south of town might be what troubled it.",
    "The Splint Fist warriors and taskmasters south of Raven Hill were cut down, and Sirra Von'Indi heard of it in {p:Darkshire}.",
    "The ogres near Merrick's old home were dealt with, and Sirra Von'Indi was told.",
    false, {"part1_corpus.txt #96138 (8 Splint Fist Warriors, 4 Taskmasters; Sirra Von'Indi)"})
q(98447, "The Valor Family", "Duskwood", 27, "valor", 4,
    "Even with the Valor ghosts put down, the attacks around Raven Hill had not stopped, and Sirra suspected their unfinished business was still unsettled.",
    "Sirra believed the whole Valor family had vanished at once, and hoped their weapons would stir something at Raven Hill.",
    "The cause of the Valor ghosts was found at Raven Hill, as Sirra had hoped.",
    "Sirra Von'Indi learned what lay behind the Valor family's ghosts.",
    true, {"part1_corpus.txt #98447 (objective only: find the cause of the Valor family ghosts)"})
fallback("The Valor Family", "Duskwood", "valor", "96139, 98447",
    "Sirra Von'Indi of {p:Darkshire} wanted the Valor family of Raven Hill remembered.",
    "Raven Hill's history had died with its people, and Sirra searched for what was left of it.",
    "Sirra's search into the Valor family moved forward.",
    "One more piece of the Valors' history reached Sirra.")
q(98190, "A Friend of the Family", "Wetlands", 25, "terenas", 4,
    "A statuette of King Terenas had come to {p:Menethil Harbor}, and its keepers feared the Dragonmaw would loot it.",
    "Menethil was a calm harbor in a storm of enemies, and the statuette was to go straight to Highlord Fordragon in {p:Stormwind}.",
    "The statuette of King Terenas reached Highlord Bolvar Fordragon in {p:Stormwind}.",
    "Bolvar Fordragon had the statuette, delivered past every rung of the chain of command.",
    true, {"LoreForever quest:98190 (wiki: World of Warcraft: Forever; to Highlord Bolvar Fordragon)"})
q(98191, "A Friend of the Family", "Stormwind City", 25, "terenas", 4,
    "Terenas had been a humble king who hated memorials, and few had survived Lordaeron's fall. The Light seemed to have gathered in this one.",
    "Bolvar wanted the statuette kept in the Cathedral of Light, with Lord Grayson Shadowbreaker.",
    "Lord Grayson Shadowbreaker took the statuette of King Terenas into the Cathedral's safekeeping.",
    "The statuette of King Terenas found its place in the Cathedral of Light.",
    true, {"LoreForever quest:98191 (wiki: World of Warcraft: Forever; Bolvar Fordragon to Lord Grayson Shadowbreaker)"})
fallback("A Friend of the Family", "Stormwind City", "terenas", "98190, 98191",
    "A statuette of King Terenas, one of the few memorials to survive Lordaeron's fall, needed safekeeping.",
    "Stormwind wanted the statuette of King Terenas kept out of the Dragonmaw's reach.",
    "The statuette of King Terenas was a step closer to safekeeping.",
    "The statuette moved on toward its keeping in {p:Stormwind}.")
P.threads.fv_valor = "the Valor family of Raven Hill"
P.threads.fv_terenas = "the statuette of King Terenas"

---------------------------------------------------------------- Dun Morogh, the Grizzled Den and Father Gavin (7-9)
-- Senir Whitebeard's reports (98322, 98319, 98323 share a title), the miners'
-- lost ore, and Father Gavin's hermitage of the Argent Dawn in the peaks.
q(98322, "Secure the Mountain", "Dun Morogh", 8, "grizzled", 3,
    "Senir Whitebeard sent mountaineers to learn about the wendigos spreading through the hills, and one of his reports had never come back.",
    "Whitebeard was late with his reports to Ironforge, and wanted someone to check on Mountaineer Gretchen west of town.",
    "Gretchen had Whitebeard's report, and called the whole situation a mess.",
    "Mountaineer Gretchen was found west of town, with news of a mess in the hills.",
    true, {"part1_corpus.txt #98322"})
q(98319, "Secure the Mountain", "Dun Morogh", 8, "grizzled", 4,
    "Wendigos had filled the Grizzled Den, and Gretchen's partner Cornelius had charged in head first.",
    "Gretchen could not finish Whitebeard's report without Cornelius, who had gone into the Grizzled Den alone.",
    "Cornelius was found in the den. Gretchen grieved for the brave fool, and said they had their report.",
    "The search for Cornelius ended in the Grizzled Den, and Gretchen had her answer for Whitebeard.",
    true, {"part1_corpus.txt #98319 (Mountaineer Cornelius in the Grizzled Den)"})
q(98323, "Secure the Mountain", "Dun Morogh", 8, "grizzled", 4,
    "Gretchen would send no one else into the Grizzled Den, and her letter for Senir Whitebeard said the cave was a lost cause.",
    "Gretchen meant to hold her post until the mountain was secure, and sent her word back to Whitebeard.",
    "Whitebeard was not surprised to hear the den was completely overrun, and folded Gretchen's letter into his pile of notes.",
    "The report of the overrun den reached Senir Whitebeard, who added it to the rest.",
    true, {"part1_corpus.txt #98323"})
fallback("Secure the Mountain", "Dun Morogh", "grizzled", "98322, 98319, 98323",
    "Wendigos had spread from their caves into the Grizzled Den, and Senir Whitebeard's mountaineers were watching them.",
    "The mountaineers of {p:Dun Morogh} reported on the wendigos to Senir Whitebeard.",
    "One more report on the wendigos was in.",
    "Whitebeard's reports on the Grizzled Den moved forward.")
q(98321, "Flintfire's Shipment", "Dun Morogh", 7, "grizzled", 3,
    "Wendigos had overrun the cave that gave Flintfire's forge its ore, and the miners had dropped everything when they fled.",
    "Flintfire was short of supplies, and the lost shipments still lay in the Grizzled Den.",
    "The shipments came back from the Grizzled Den, and Flintfire expected the forge to be running again in no time.",
    "Flintfire had the ore again. The miners had at least all got out alive.",
    false, {"part1_corpus.txt #98321"})
q(98326, "Frosthowl", "Dun Morogh", 9, "grizzled", 3,
    "A wendigo called Frosthowl had stolen a sack of fish that had taken days to catch on the frozen lake.",
    "Paxton had fished the frozen lake for days, and his wife could not bear to tell him the whole catch was lost to a wendigo.",
    "The fish came back from the Grizzled Den. Paxton would not have to spend another night on the lake, and there might be a real feast.",
    "Frosthowl was dead and the catch recovered, sparing Paxton's wife an awkward confession.",
    false, {"part1_corpus.txt #98326 (Frosthowl in the Grizzled Den)"})
q(99158, "Dawn in the Mountains", "Dun Morogh", 8, "gavin", 2,
    "Father Gavin of the Argent Dawn had fixed up an old building in the peaks as a rest for travelers, and a shipment of holy candles was due to him.",
    "Father Gavin was a priest who would rather heal than fight, and lived in a hermitage among the mountains of {p:Dun Morogh}.",
    "The candles from Ironforge reached Father Gavin, one of the few things his hermitage needed from the city.",
    "The priest took the holy candles gladly. He lived mostly on his own, he said, but valued a few gifts from the city.")
q(99159, "Finding Warmth", "Dun Morogh", 8, "gavin", 2,
    "Father Gavin's hearth was open to any soul, but he had been too busy to gather firewood.",
    "The hermitage needed firewood, and Father Gavin had other tasks on his mind.",
    "The firewood was stacked at the hermitage, the wet pieces left to dry.",
    "He had his firewood now, and more tasks for anyone willing.",
    false, {"part1_corpus.txt #99159 (14 pieces of firewood)"})
q(99160, "Rime's Wrath", "Dun Morogh", 8, "gavin", 3,
    "A shelf of rock and ice had fallen from the peaks and riled the elementals near Father Gavin's hermitage.",
    "The frozen road was treacherous enough without the elements taking form, and Father Gavin was no longer one for fighting.",
    "The elementals were put down. Father Gavin wished they could have been calmed instead, but they had been too dangerous to leave.",
    "The road near the hermitage was safer, though Father Gavin regretted that the spirits could not simply be placated.",
    true)
q(99161, "Rime's Wrath", "Dun Morogh", 8, "gavin", 4,
    "The first elemental to appear after the rockslide was larger than the rest, and Father Gavin called it Avala. It seemed to cause the sudden weather and the smaller slides.",
    "Father Gavin wanted Avala killed and its core brought back as proof.",
    "Avala's core reached Father Gavin, who hoped the peaks would now claim fewer lives.",
    "With Avala dead, Father Gavin blessed the work that made the mountain road safer.",
    true)
fallback("Rime's Wrath", "Dun Morogh", "gavin", "99160, 99161",
    "A rockslide in the peaks of {p:Dun Morogh} had stirred the elementals near Father Gavin's hermitage.",
    "Father Gavin wanted the mountain road made safe from the restless elementals.",
    "Part of the trouble with the elementals was dealt with.",
    "The road near the hermitage was a little safer.")
q(99162, "Treacherous Cold", "Dun Morogh", 8, "gavin", 4,
    "After every slide, Father Gavin searched for survivors or victims, praying there was nothing to find, but the restless elements kept him close to home.",
    "Mountaineers of Ironforge had been lost in the peaks, and Father Gavin wanted their rifles brought back.",
    "The mountaineers engraved their names on their rifle stocks. Father Gavin would send the rifles to Ironforge, to be passed to their families.",
    "The lost mountaineers' rifles went to Father Gavin, bound for Ironforge and whatever kin remained.",
    false, {"part1_corpus.txt #99162 (rifles of fallen mountaineers)"})
P.threads.fv_grizzled = "the wendigos of the Grizzled Den"
P.threads.fv_gavin = "Father Gavin's hermitage"

---------------------------------------------------------------- Horde-zone additions the horde lane left (coordinator note, 2026-11-05)
-- Durotar's profession lessons at Thunder Ridge, Orgrimmar's alchemists, a
-- Mulgore arena, Pal'juh, Leonid's letter, the druid's return and Chol'aruk.
-- 97277 (Grund and Gozwin) is left out: its zone could not be confirmed.
q(96873, "A Pain in the Neck", "Durotar", 8, "durotar", 2,
    "Zalazane bound the minds of the trolls east of the village with pendants wrapped in evil binding spells.",
    "Stripping the binding magic from Zalazane's pendants made good practice for an enchanter, so long as no one put one on.",
    "The pendants' binding spells were stripped away. The slain trolls were a shame, but their spirits could rest now.",
    "With the binding spells removed from the pendants, the spirits of Zalazane's thralls could rest.")
q(96874, "This Is Spinal Axe", "Durotar", 10, "durotar", 2,
    "Ug'thok of {p:Orgrimmar} thought the spines of the Thunder Ridge beasts would make the head of a mighty axe, though Saru had laughed at him.",
    "Ug'thok's smithing lesson called for weathered spines from Thunder Ridge and rough grinding stones to sharpen them.",
    "The spines were tougher than Ug'thok expected. The axe might not come easily, but he would keep working on it.",
    "Ug'thok had his spines and grinding stones, and a harder job ahead than he had thought.",
    false, {"part1_corpus.txt #96874 (Ug'thok in Orgrimmar)"})
q(96875, "Beasts of Thunder Ridge", "Durotar", 10, "durotar", 2,
    "Orgrimmar kept growing, and Kamari supplied the peons with lizard hides from Thunder Ridge to line its walls and roofs.",
    "Kamari wanted rough lizard hides and a few cured light hides, a test of skill with leather.",
    "The hides went into Orgrimmar's new buildings. Kamari said the city grew with that work.",
    "Kamari took the hides for the builders, and called it work that helped Orgrimmar grow.",
    false, {"part1_corpus.txt #96875 (Kamari in Orgrimmar)"})
q(96877, "Halikor's Hoof", "Durotar", 12, "durotar", 3,
    "The enormous hoof of Halikor was proof of victory over the mighty lizard of Thunder Ridge.",
    "Halikor had left behind a hoof big enough to make a fine trophy.",
    "The hoof drew admiration as a fine trophy, and talk of what a fight it must have been.",
    "The hoof was handed over and admired.")
q(97275, "Whuut's the Rush", "Orgrimmar", 15, "durotar", 2,
    "Whuut was an alchemy prodigy who burned through the rarest reagents without learning the basics, and Yelmak wanted to slow him down.",
    "Yelmak brewed a potion from common plants by a quick tonic method, meant to show Whuut what careful work could do.",
    "Whuut was astonished that Yelmak's potion used only speargrass and cattail, and began to think he had skipped too far ahead.",
    "Whuut took Yelmak's lesson to heart. There might be much he had missed by starting with the rarest flora.")
q(99108, "Sparring Match", "Mulgore", 6, "durotar", 2,
    "In the arena of the young, it did not matter who one's mother was or whether one fought with sword or bow.",
    "The arena's teacher offered a lesson in direct combat to any young one willing to face the novices.",
    "The teacher was honored by the fight, and saw hope in the new generation.",
    "The sparring was done, and the teacher handed over something to tend the wounds, for many more battles lay ahead.")
q(99123, "Lost in the Shadows", "Durotar", 8, "durotar", 3,
    "Pal'juh had gone scouting the crag alone, run out of magic at the wrong moment, and been stuck hiding ever since.",
    "A young hunter named Pal'juh was trapped in the crag and needed help to escape.",
    "Pal'juh got out of the crag. Her teacher hoped she had learned her lesson about going alone.",
    "She was safe now. A promising hunter, her teacher said, who acted more like a raptor than a tiger.",
    false, {"part1_corpus.txt #99123"})
q(98545, "Leonid's Letter", "Tirisfal Glades", 13, "argent", 3,
    "Leonid Barthalomew had a colorful history with the Dark Lady, and wanted a neutral hand to carry his letter to an old friend in the {p:Undercity}.",
    "Leonid's letter was for Glix Xizzix, a goblin of the Trade Quarter, who Leonid said would pay for the trouble.",
    "Glix Xizzix had not seen Leonid since Naxxramas rained hell on their heads. He took the letter, and grudgingly paid with junk from the lost and found.",
    "The letter reached Glix, who had never agreed to any tip, but offered a pick from the lost and found.",
    false, {"part1_corpus.txt #98545 (Glix Xizzix in the Undercity)"})
q(98362, "To Thunder Bluff", "Thunder Bluff", 20, "durotar", 4,
    "Dendrite Starblaze sent a young druid back to Turak Runetotem in {p:Thunder Bluff}, to learn the shape of the cat.",
    "The trial of the Great Cat Spirit was done, and the lessons now led back to the druid's teacher.",
    "Turak Runetotem sensed that the Great Cat Spirit's trial had been passed, and began teaching the shape of the cat.",
    "Turak was proud. Every druid had to pass the Great Cat Spirit's trial, he said, and now came the cat's shape.",
    false, {"LoreForever quest:98362 (wiki: World of Warcraft: Forever; Dendrite Starblaze to Turak Runetotem)"})
q(97003, "Chol'aruk the Ravener", "The Barrens", 21, "durotar", 4,
    "The Razormane spoke of Chol'aruk the Ravener, a quilboar five times the size of any other, laired in a cave at Thorn Hill.",
    "Most doubted the tales of Chol'aruk, but the veteran who asked had fought one of its kind, and it had taken six fighters to bring it down.",
    "The veteran meant to carry Chol'aruk's head to {p:Orgrimmar}, so none would doubt his tales again, and to speak loudly of who had earned it.",
    "Chol'aruk was dead. The veteran called the head grim proof that such beasts existed.",
    true, {"part1_corpus.txt #97003"})
fallback("Chol'aruk the Ravener", "The Barrens", "durotar", "97003, 97005",
    "The Razormane spoke of Chol'aruk the Ravener, a giant quilboar laired at Thorn Hill.",
    "Few believed the tales of Chol'aruk, a quilboar far larger than any other.",
    "The hunt for Chol'aruk moved forward.",
    "One step against Chol'aruk was done.")
P.threads.fv_durotar = "lessons and hunts around the Horde's towns"

---------------------------------------------------------------- Starter-zone additions (forever2 lane, 2026-11-05)
-- Forever stages in the starting zones that no pack told yet. Zones come from
-- the category in part1_corpus.txt where captured (12 Elwynn, 85 Tirisfal, 130
-- Silverpine, 77 Anvilmar in Dun Morogh), otherwise from Lore Forever's entry.

-- Dun Morogh: Grund and Gozwin's camp (#97277, cat 77, Anvilmar).
q(97277, "Grund and Gozwin", "Dun Morogh", 6, "dunmorogh", 3,
    "A snow leopard had dragged Gozwin away from his camp in the northwestern hills until Grund fired his shotgun over its head. Gozwin's mechanic's log was lost in the scramble.",
    "Grund's gnome friend Gozwin had come away from a snow leopard with deep scratches. He worried more about the log for his mecha-walker than about himself.",
    "The log came back to camp. Grund said Gozwin would have one less thing to fret over, and could now put his energy into getting back on his feet.",
    "The log for Gozwin's mecha-walker came back from the hills. Grund was not surprised that the leopard had been after the boar they were roasting.",
    false, {"part1_corpus.txt #97277 (cat 77; camp in the northwestern hills)", "LoreForever quest:97277 (wiki: World of Warcraft: Forever; Grund a dwarf, Gozwin a gnome)"})
P.threads.fv_dunmorogh = "the camps in the hills of Dun Morogh"

-- Elwynn: Crystal Lake's fisherman and Remy "Two Times" (#99127 to #99131).
-- The giver of 99127-99129 is the fisherman Jason Mathers, per Lore Forever and
-- 99131; Lee only set the traps.
q(99127, "A Net Disaster", "Elwynn Forest", 7, "crystallake", 2,
    "A fisherman at {p:Crystal Lake} had not seen a single minnow in the water, and his hooks kept coming up empty.",
    "Lee had set traps in {p:Crystal Lake} overnight, and the fisherman who depended on them wanted to know if anything had been caught.",
    "Every one of Lee's nets had been damaged. The fisherman saw that his new neighbors on the lake were doing more harm than anyone had known.",
    "Whatever had been at the nets was doing real damage, and the fisherman feared he would go broke unless something was done.",
    false, {"LoreForever quest:99127 (wiki: World of Warcraft: Forever; Crystal Lake)"})
q(99128, "Slimy Menace", "Elwynn Forest", 7, "crystallake", 2,
    "The fisherman blamed the murlocs on the far side of {p:Crystal Lake}, and feared there would soon be no fish left anywhere in it.",
    "Murlocs across {p:Crystal Lake} had a vicious temper and teeth to match, and the fishing was suffering for it.",
    "The murlocs across the lake were thinned out. The fisherman could still hear their warbling, and expected their numbers back soon enough.",
    "That would slow the murlocs down, the fisherman said, though he had no doubt they would make up their numbers quickly.",
    false, {"LoreForever quest:99128 (wiki: World of Warcraft: Forever; Crystal Lake, Elwynn Forest)"})
q(99129, "A Man About a Murloc", "Elwynn Forest", 7, "crystallake", 2,
    "Jason Mathers, the fisherman at {p:Crystal Lake}, hoped Remy in {p:Goldshire} had some idea how to keep the murlocs away from his fish.",
    "Remy hated murlocs as much as Jason Mathers did, and the fisherman thought he might know how to keep them off the lake.",
    "Remy had been warning the guards about the murlocs, and they would not listen. He had a few ideas of his own for getting back at them.",
    "The guards had ignored Remy's warnings, so he meant to deal with the murlocs himself, once he had what he needed.",
    false, {"LoreForever quest:99129 (wiki: World of Warcraft: Forever; Jason to Remy Two Times)"})
q(99130, "An Enticing Offer", "Elwynn Forest", 7, "crystallake", 2,
    "Duskweed grew on the farms near {p:Goldshire}, and in large amounts its petals were toxic to most animals. Remy meant to turn it into murloc bait.",
    "Remy's plan against the murlocs was bait made from duskweed, which would clear a few farmers' fields in the bargain.",
    "Remy mixed the bait, simple but safe enough as long as nobody's pet got into it. Jason was to be told not to eat any.",
    "The duskweed became murloc bait. Remy's only warning was that Jason should not eat it.",
    false, {"part1_corpus.txt #99130 (cat 12, Elwynn Forest; ingredients for murloc bait)"})
q(99131, "Baited for Success", "Elwynn Forest", 7, "crystallake", 3,
    "Jason Mathers could pick up Remy's murloc bait later that day, along with advice on how to use it.",
    "Remy hoped the bait would let Mathers sell his fish again, and leave fewer murlocs in the world.",
    "Mathers did not mind poisoned bait, as long as the fish would not eat it. He meant to visit Remy later to collect it.",
    "Mathers had his answer to the murlocs. As long as the fish left the poison alone, he hoped to sell his catch again.",
    false, {"LoreForever quest:99131 (wiki: World of Warcraft: Forever; Remy to Jason Mathers)"})
P.threads.fv_crystallake = "the murlocs of Crystal Lake"
-- 99143's angler is unnamed; Elwynn per the coordinator's zone check.
q(99143, "Bottles and Baubles", "Elwynn Forest", 7, "elwynn", 2,
    "An angler reasoned that murlocs must think like fish, so anything the murlocs liked, the fish would like too.",
    "The murlocs kept heaps of junk in their camps, and an angler wanted anything in them that might make good bait.",
    "The angler called the junk an interesting collection, good enough for bait, and gave some older fishing supplies in return.",
    "The murlocs' baubles would serve as bait, the angler said, and handed over old supplies meant for anyone finding their footing in fishing.",
    false, {"LoreForever quest:99143 (wiki: World of Warcraft: Forever; an angler and murloc junk)"})
P.threads.fv_elwynn = "small troubles around Elwynn Forest"

-- Tirisfal: Executor Zygand's Deathguard (#99134, #99141; Lore Forever names
-- the giver), Bareth Dawnstone of Bandarion Keep (#99144), and the Scourge
-- beneath Shadowvale (#99152 Hilda the Breaker, #99153 Ephram Barbaro).
q(99134, "Discipline", "Tirisfal Glades", 6, "zygand", 2,
    "Executor Zygand in {p:Brill} kept a ledger of Deathguards who had disappointed him, and wanted someone from outside the guard to punish them.",
    "Zygand preferred an outsider for the work. Anyone who was not of the Deathguard had not yet had a chance to disappoint him.",
    "Pain was chief among the few delights left to the dead, Zygand said. The punishment pleased him, and so, he said, it pleased the Dark Lady.",
    "The Deathguards on Zygand's ledger had been punished, and the executor hinted that there might be further use for such work.",
    false, {"LoreForever quest:99134 (wiki: World of Warcraft: Forever; Executor Zygand)"})
q(99141, "Patience", "Tirisfal Glades", 6, "zygand", 3,
    "Reports from several of Executor Zygand's Deathguards were overdue, and his patience had run out.",
    "Deathguard Dillinger by the graveyard and Deathguard Kristof at the waystation owed Zygand reports. So did Gordo, an abomination who wandered near Stillwater Pond.",
    "The reports reached Zygand. Gordo's was of no use, and the executor wanted his lapse in trusting an abomination with a pen kept quiet.",
    "Zygand had his overdue reports at last, and allowed that there might be hope yet.",
    false, {"part1_corpus.txt #99141 (cat 85; Dillinger, Kristof and Gordo)", "LoreForever quest:99141 (wiki: World of Warcraft: Forever; Executor Zygand)"})
P.threads.fv_zygand = "Executor Zygand's Deathguard"
q(99144, "Seeking Refuge", "Tirisfal Glades", 7, "risen", 4,
    "Bareth Dawnstone, a risen paladin, had been captured on his way from Bandarion Keep to Shari Stilwell in {p:Brill}. His captors wielded the Light with hatred in their hearts.",
    "Bareth Dawnstone knew some still took issue with risen paladins, but swore their intentions were pure. He needed help to escape the zealots who held him.",
    "Dawnstone got away. His order was still taking root in Tirisfal, and losing one so promising would have been a heavy blow.",
    "Bareth Dawnstone was free. His order welcomed any who sought guidance in the Light at Bandarion Keep, on the bluffs northwest of the Solliden Farmstead.",
    false, {"part1_corpus.txt #99144 (cat 85; help Bareth Dawnstone)", "LoreForever quest:99144 (wiki: World of Warcraft: Forever; captured at Crusader's Outpost)"})
q(99152, "As Above, So Below", "Tirisfal Glades", 10, "shadowvale", 4,
    "Hilda the Breaker feared the cellars beneath Shadowvale would fester into a Scourge uprising against Bandarion Keep.",
    "The Tarnished were trouble enough in Shadowvale, but Hilda wanted bones from the Scourge below the town that still glowed with their first reanimation magic.",
    "Hilda had her glowing bones, and hoped they would show how the threat beneath Shadowvale had gone unnoticed for so long.",
    "With bones from the cellars in hand, Hilda meant to study how the Scourge had gathered beneath Shadowvale unseen.",
    false, {"part1_corpus.txt #99152 (cat 85; 6 bones beneath Shadowvale)", "LoreForever quest:99152 (wiki: World of Warcraft: Forever; Hilda the Breaker at Bandarion Keep)"})
q(99153, "The One That Got Away", "Tirisfal Glades", 10, "shadowvale", 4,
    "A cultist had slipped away from the remnants of the battle with Naxxramas, carrying a piece of a focusing crystal that still had power in it.",
    "Ephram Barbaro believed the crystal fragment was somewhere beneath Shadowvale, either raising the dead or making them stronger.",
    "The hidden crystal fragment was found beneath Shadowvale, quickly enough to please Ephram Barbaro.",
    "The fragment came out from beneath Shadowvale before its power could get out of hand.",
    false, {"part1_corpus.txt #99153 (cat 85; Hidden Crystal Fragment beneath Shadowvale)", "LoreForever quest:99153 (wiki: World of Warcraft: Forever; Ephram Barbaro)"})
P.threads.fv_shadowvale = "the Scourge beneath Shadowvale"

-- Silverpine: the offering stone at Beren's Peril (#95884, #95883, #95885, in
-- that order). Object quests: nobody gives them, and the ritual's purpose is
-- never told, so the lines keep it unknown.
q(95884, "The Offering Stone", "Silverpine Forest", 23, "berens", 3,
    "A scrap of note, mostly illegible, spoke of preparations for an offering and a ritual at an offering stone.",
    "Someone had been preparing a ritual in Beren's Peril, and a worn note pointed to an offering stone close by.",
    "The offering stone was found nearby, its rough surface littered with strange implements.",
    "The stone named in the note was found, strange items scattered across it.",
    false, {"part1_corpus.txt #95884 (cat 130; the Offering Stone in Beren's Peril)"})
q(95883, "The Tortured Soul", "Silverpine Forest", 23, "berens", 3,
    "The ritual on the offering stone had been hastily assembled. By the note's account it lacked only an offering of blood and a tortured soul.",
    "The undead around Beren's Peril looked tortured enough to supply the soul the ritual still needed.",
    "Brought to the offering stone, the tortured soul gave off a foul energy, and the ritual drew closer to its end.",
    "The tortured soul reached the offering stone, and a foul energy stirred in its presence.",
    false, {"part1_corpus.txt #95883 (cat 130)"})
q(95885, "The Offering of Blood", "Silverpine Forest", 23, "berens", 4,
    "All the ritual still needed was an offering of blood. The note called it a willing sacrifice.",
    "The last step at the offering stone in Beren's Peril was blood, freely given, by the note's account.",
    "The ritual drained the offering stone of its power. To what end was unknown, but the stone cracked and crumbled, and something glittered in the rubble.",
    "The offering stone lay inert, its power spent, and the rough rock fell apart.",
    false, {"part1_corpus.txt #95885 (cat 130)"}).highlight = {
    "The ritual at Beren's Peril drained the offering stone, and it crumbled to rubble.",
    "Whatever the ritual had been for, the offering stone was spent and broken."}
P.threads.fv_berens = "the offering stone at Beren's Peril"

-- Elwynn: Brother Paxton's stolen library (#91741, #92124, #91743, #91745,
-- #91752, #91758, #91772, #91775, #91777; cat 12 in part1_corpus.txt). The
-- kobolds carry the books from Northshire to Fargodeep and Jasperlode. Givers
-- not named in the quest text come from Lore Forever (Kelsey Fargo for 91752,
-- Marshal Dughan for 91775); unnamed ones stay unnamed.
q(91741, "Nibbled-On Book", "Elwynn Forest", 2, "paxton", 2,
    "A kobold had dropped a volume that looked half eaten. It seemed to belong to the small library Brother Paxton kept in {p:Northshire Abbey}.",
    "The nibbled volume bore the look of Brother Paxton's library, kept inside {p:Northshire Abbey}.",
    "Brother Paxton recognized his volume and feared the kobolds were stealing his collection again, to eat it.",
    "One volume was back on Paxton's shelf. The rest of his collection was still missing.",
    false, {"part1_corpus.txt #91741 (cat 12; return the book to Brother Paxton)"})
q(92124, "Book Inventory", "Elwynn Forest", 2, "paxton", 2,
    "Brother Paxton needed to know how many books were missing, and sent word to Daniel, an assistant more interested in Elwynn's trade professions than in his duties.",
    "Paxton's assistant Daniel could count the shelves quickly, if he could be kept from talking about tradeskills.",
    "Daniel had warned Paxton three times about kobolds tunneling under the abbey. Whole bookshelves stood empty.",
    "The count was grim, with whole shelves emptied. Daniel had seen it coming, and still wanted to talk about tradeskills.",
    false, {"LoreForever quest:92124 (wiki: World of Warcraft: Forever; Brother Paxton and Daniel)"})
q(91743, "Rascally Rodents", "Elwynn Forest", 2, "paxton", 2,
    "The kobolds were carrying off Brother Paxton's books, and he feared they would devour his whole library.",
    "Brother Paxton wanted his books taken back from the kobolds of {p:Northshire} before nothing was left of his library.",
    "Eight books came back, and Paxton gave away a how-to manual he did not need. The kobolds were not eating the rest, he noticed, and he wondered why they wanted them.",
    "Some of Paxton's books were rescued, but many more were missing. Whatever the kobolds wanted them for, it was not food.",
    false, {"part1_corpus.txt #91743 (cat 12; retrieve 8 books)"})
q(91745, "Mining Consultant", "Elwynn Forest", 3, "paxton", 2,
    "Kelsey Fargo, a new mining apprentice, worked just outside the tunnels and had probably seen what the kobolds were doing with the books.",
    "The mining apprentice Kelsey Fargo kept watch outside the kobolds' tunnels, and might teach a little mining besides.",
    "Kelsey had seen kobolds running back and forth with books and yelling at each other. She thought they were stealing from the library in the abbey.",
    "Kelsey Fargo confirmed it. Kobolds were hauling books out of the abbey's library.",
    false, {"LoreForever quest:91745 (wiki: World of Warcraft: Forever; Kelsey Fargo at Echo Ridge Mine)"})
q(91752, "The Big Picture", "Elwynn Forest", 3, "paxton", 3,
    "Now and then a kobold came out of the tunnels yelling about pictures for Narf. Kelsey Fargo guessed Narf was a leader deep inside, with a whole sack of books.",
    "Narf's sack of stolen books lay at the back of the tunnels, among kobolds a good deal meaner than those outside.",
    "Marshal McBride took the stolen books and promised to get them back to Brother Paxton at once.",
    "The stolen books from the back of the tunnels reached Marshal McBride, bound for Brother Paxton's shelves.",
    false, {"part1_corpus.txt #91752 (cat 12; type 1)", "LoreForever quest:91752 (wiki: World of Warcraft: Forever; Shinyfinder Narf, Marshal McBride)"})
q(91758, "Follow That Kobold!", "Elwynn Forest", 4, "paxton", 2,
    "Another kobold had left the tunnels with a large sack of books, Kelsey reported, and Marshal McBride wanted it tracked down.",
    "Tordrin Sternblade, a hunter trainer newly arrived from {p:Ironforge}, kept to the stable behind the abbey. McBride thought he could help track the kobold thief.",
    "Tordrin agreed to help track the thief, and set about making something for the hunt.",
    "Tordrin Sternblade was ready to whip up something to follow the kobold's trail.")
q(91772, "Shhh! We're Hunting Kobolds", "Elwynn Forest", 4, "paxton", 3,
    "Tordrin's tracking kit could follow the kobold that worried Marshal McBride. Tordrin suspected the thieves were up to something outside {p:Northshire}.",
    "The kobold tracks led out of {p:Northshire}, and Tordrin wanted whatever they showed taken to Marshal Dughan in {p:Goldshire}.",
    "Dughan was unimpressed. Of course the kobolds were headed for the {p:Fargodeep Mine}, he said, and someone would have to deal with that.",
    "The tracks led toward the {p:Fargodeep Mine}, which Dughan called infested with kobolds.",
    false, {"part1_corpus.txt #91772 (cat 12; follow the tracks and report to Marshal Dughan)"})
q(91775, "Book Return", "Elwynn Forest", 6, "paxton", 3,
    "Brother Paxton's books had gone to the {p:Fargodeep Mine}. He worried most about one called Fun with Elementals, which he thought even a kobold could use to summon a servant.",
    "Marshal Dughan sent a bag for the books down into the {p:Fargodeep Mine}, where the kobolds had taken more of Paxton's library.",
    "By Paxton's list, most of the missing books were found. The rest had likely gone to the {p:Jasperlode Mine}.",
    "Most of Paxton's books came out of Fargodeep. Only the last few were still unaccounted for, probably in Jasperlode.",
    false, {"part1_corpus.txt #91775 (cat 12; type 1)", "LoreForever quest:91775 (wiki: World of Warcraft: Forever; Marshal Dughan)"})
q(91777, "Rare Books", "Elwynn Forest", 7, "paxton", 4,
    "Two books were still missing from Brother Paxton's list, one on geomancy and one explaining arcane magic in simple words. The kobolds had likely taken them to the {p:Jasperlode Mine}.",
    "If an apprentice kobold could summon an elemental from one of Paxton's books, there was no telling what its master at the {p:Jasperlode Mine} could do.",
    "Brother Paxton had his library back. He gave away one of the weapons meant for the militia in thanks.",
    "The last two books came home to {p:Northshire Abbey}, and Paxton said his library was saved.",
    false, {"part1_corpus.txt #91777 (cat 12; type 1)"}).highlight = {
    "Brother Paxton's last stolen books came back from the {p:Jasperlode Mine}, and his library was whole again.",
    "The kobolds' thefts from the abbey ended with Paxton's library restored."}
P.threads.fv_paxton = "Brother Paxton's stolen books"

-- Elwynn at level 7-10: the enchanters' lesson, Eastvale's carters and smith,
-- and two trophies. Givers from Lore Forever (Kitta Firewind, Ormin Pelford,
-- Hagar Lowe); the watch and the trophy buyer stay unnamed.
q(91753, "An Enchanting Lesson", "Elwynn Forest", 7, "elwynn", 2,
    "Kitta Firewind held that theory alone did not make an enchanter. Kobolds had no schooling, yet bound simple enchantments into wax effigies.",
    "The kobolds' wax effigies held crude enchantments, and taking them apart was the practical half of an enchanter's lesson.",
    "Once the kobolds' charms were unpicked, Kitta said that theory and practice were two sides of a coin.",
    "The enchantments in the kobolds' effigies were laid bare, and Kitta's lesson was learned.",
    false, {"part1_corpus.txt #91753 (cat 12)", "LoreForever quest:91753 (wiki: World of Warcraft: Forever; Kitta Firewind at the Tower of Azora)"})
q(91733, "Downstream", "Elwynn Forest", 10, "elwynn", 2,
    "A wagon from the trading post had tipped over, and its supplies had washed downstream before anyone could catch them.",
    "Murlocs and wolves roamed the riverbank where the lost supplies had come to rest, and their owner could not face them alone.",
    "The supplies were pulled out of the river, and their owner apologized for the soaking.",
    "The lost shipment came back from downstream, damp but whole.",
    false, {"part1_corpus.txt #91733 (cat 12)", "LoreForever quest:91733 (wiki: World of Warcraft: Forever; Ormin Pelford near Eastvale)"})
q(91732, "Good Steel", "Elwynn Forest", 10, "elwynn", 2,
    "Good steel had been scarce since the war, and the tools around {p:Eastvale} had suffered for it. Miners had once used fine picks in the {p:Jasperlode Mine}, and some might still lie in its depths.",
    "Hagar Lowe hoped to reuse the steel from the picks the miners had left in the depths of the {p:Jasperlode Mine}.",
    "The old Jasperlode picks still shone. Hagar Lowe said they did not make them like that anymore.",
    "Fine steel from the abandoned picks went to Hagar Lowe, to be made into new tools.",
    false, {"LoreForever quest:91732 (wiki: World of Warcraft: Forever; Hagar Lowe at Eastvale Logging Camp)"})
q(91740, "Croaky's Head", "Elwynn Forest", 10, "elwynn", 3,
    "Croaky, a murloc who had terrorized the local roads, was dead, and the watch would want to know.",
    "Croaky's head was proof that the murloc on Elwynn's roads would trouble no one again.",
    "The watch had lost two of its members to the murlocs the week before. With their leader dead, the guards hoped to start pushing the murlocs out of Elwynn.",
    "Croaky's head reached the watch, who hoped to drive the leaderless murlocs out of Elwynn.",
    false, {"part1_corpus.txt #91740 (cat 12)"})
q(91746, "Elmpaw's Head", "Elwynn Forest", 10, "elwynn", 2,
    "Elmpaw's head made an impressive trophy, and a local hunter or skinner might want to hear how it was won.",
    "Elmpaw was dead, and its head was worth something to the right buyer.",
    "The buyer was impressed, and knew a few collectors who would pay well to hang Elmpaw's head over their mantles.",
    "Elmpaw's head went to be prepared for some collector's mantle.",
    false, {"part1_corpus.txt #91746 (cat 12)"})

-- Teldrassil and Darnassus (cat 141 and 1657 where captured). Givers from Lore
-- Forever where the text leaves them out: Tarindrella (#97977), Byancie in
-- Dolanaar (#99050), Lynessa Duskblossom (#99053), Arynia Cloudsbreak (#98392).
-- Eralya Leafshadow's fate is never told: #99073 ends with her at peace, not
-- saved. 98391 (The Sisterhood of Elune) is a class referral and is left out.
q(97979, "The Goddess Provides", "Teldrassil", 1, "teldrassil", 3,
    "The Long Vigil that followed the defense of {p:Mount Hyjal} had ended, and the kaldorei had joined an Alliance of other peoples. In the boughs of {p:Teldrassil}, their young learned the gifts of Mother Moon.",
    "Elune's grace could help a kaldorei strike true, or hide one as the moon may eclipse the sun. Every child of the stars was taught to know those gifts.",
    "The gifts of Elune had been shown, with a promise that the goddess would never forsake those who used them well.",
    "The lesson in Elune's gifts was done. Use them well, the teaching went, and Mother Moon would never forsake her children.",
    false, {"LoreForever quest:97979 (wiki: World of Warcraft: Forever; a rite for young night elves)"})
q(97977, "Nature's Call", "Teldrassil", 3, "gnarlpine", 4,
    "The Gnarlpine furbolg had been allies of the night elves for ages, and Tarindrella would not believe they had turned so readily. Their abandoned camps on the western edge of {p:Shadowglen} might hold the answer.",
    "Totems left in the Gnarlpine's abandoned homes bore engravings that might tell what had happened to the furbolg.",
    "The engravings told of nightmares. The Gnarlpine had dreamed of being wiped out by a great shadow, and their fear had turned to rage against their old elven friends.",
    "It was worse than Tarindrella had feared. A dread of some great shadow had driven the Gnarlpine mad, and that madness had turned on the kaldorei.",
    false, {"LoreForever quest:97977 (wiki: World of Warcraft: Forever; Tarindrella in Shadowglen)"}).highlight = {
    "The Gnarlpine's own totems told how nightmares of a great shadow had turned the furbolg against the night elves.",
    "Engraved totems showed that the Gnarlpine had gone mad with fear before they turned on their allies."}
P.threads.fv_gnarlpine = "the madness of the Gnarlpine"
q(97236, "Fang of Githyiss", "Teldrassil", 5, "teldrassil", 2,
    "Githyiss was a spider of great size, and a fresh fang from such a beast was quite a find. Someone in {p:Aldrassil} who studied spiders would want it.",
    "The fang of Githyiss was a rare specimen, and a scholar of spiders in {p:Aldrassil} might put it to use.",
    "The spider scholar in {p:Aldrassil} loved surprises, and said the fang would surely further the work.",
    "Githyiss's fang went to {p:Aldrassil}, where it would help the study of the forest's spiders.")
q(87288, "Soft Saber Pelts", "Teldrassil", 7, "teldrassil", 2,
    "A trader in {p:Dolanaar} needed nightsaber pelts. The cats were beautiful, he said, but the local ones were aggressive.",
    "The nightsabers near {p:Dolanaar} had grown aggressive enough to threaten the roads, and a local trader had use for their pelts.",
    "The trader thought it a shame to fight such majestic animals, but the roads were safer, and the pelts would make blankets and shawls.",
    "The pelts went to the trader in {p:Dolanaar}, for blankets and shawls, and the roads were a little safer.")
P.threads.fv_teldrassil = "small tasks in the boughs of Teldrassil"

-- The Oracle Tree's runners (#99046, #99047, #99050, #99073, in order) and the
-- sentinel lost in Ban'ethil (#99053).
q(99046, "The Lost Runner", "Teldrassil", 9, "oracle", 4,
    "Sentinels ran the Oracle Tree's messages to the elders in {p:Darnassus}. The latest runner was long overdue, and it would have been Eralya Leafshadow's turn, though she was still in training.",
    "The Oracle Tree's messages came at odd intervals, but none had been this late. Someone needed to find the runner on the road west to the {p:Oracle Glade}.",
    "Eralya Leafshadow was found, gravely hurt, calling on Elune's grace.",
    "The missing runner, Eralya, was alive but gravely wounded.",
    false, {"LoreForever quest:99046 (wiki: World of Warcraft: Forever; the Oracle Tree's courier)"})
q(99047, "Not Dead Yet", "Teldrassil", 9, "oracle", 5,
    "Eralya and her sisters had been sent to the Oracle Tree for a message, and harpies had been everywhere. She begged for word to reach Byancie in {p:Dolanaar}.",
    "Eralya, the wounded runner from the Oracle Tree, was coughing up blood. No one else was coming, and her only hope was Byancie in {p:Dolanaar}.",
    "Byancie knew the foulness spreading through the forest had touched the harpies, and Eralya with them. She did not think the sentinel had long.",
    "Word of Eralya reached {p:Dolanaar}. Byancie blamed the same foulness that had taken hold of the harpies, and meant to hurry.",
    false, {"LoreForever quest:99047 (wiki: World of Warcraft: Forever; Eralya to Byancie in Dolanaar)"})
q(99050, "The Great Tree Provides", "Teldrassil", 10, "oracle", 3,
    "Byancie hoped a salve could hold Eralya's affliction back long enough for her to reach {p:Dolanaar}. Its core was the fronds of dewy lashers, found around {p:Lake Al'Ameth} and {p:Wellspring Lake}.",
    "Teldrassil was a living home and would provide, Byancie said. Lasher fronds, an empty vial and some spring water were all the salve needed.",
    "Byancie had her ingredients and set about making the salve. It would take only a moment.",
    "The lasher fronds, vial and spring water reached Byancie, who began the salve at once.",
    false, {"part1_corpus.txt #99050 (cat 141; 6 dewy lasher fronds)"})
q(99073, "Easing Suffering", "Teldrassil", 10, "oracle", 5,
    "Byancie's salve was ready. She did not know if it would cure Eralya, for the rot festered quickly, but it would at least ease her suffering.",
    "The rot in Eralya grew stronger as it spread. Byancie's salve might not save her, but it could still ease her pain.",
    "Eralya took the salve, and her breathing calmed. She might not survive, but she was at peace.",
    "The salve reached Eralya in time to ease her. Whether she would live, no one could say.",
    false, {"part1_corpus.txt #99073 (cat 141; take the salve to Eralya)"}).highlight = {
    "Byancie's salve reached Eralya Leafshadow and eased her, though no one knew if she would survive.",
    "The wounded runner from the Oracle Tree was at peace, if not saved."}
q(99053, "Escaping Ban'ethil", "Teldrassil", 9, "oracle", 4,
    "Lynessa Duskblossom had carried a message from the Oracle Tree to the sleeping druids, and found {p:Ban'ethil Barrow Den} overrun by furbolg. They had dragged her underground.",
    "The Gnarlpine held a sentinel beneath {p:Ban'ethil Barrow Den}, and she feared she would be their next meal.",
    "Lynessa escaped the Gnarlpine. She was one of the best sentinels, said a friend who gave thanks for her safety.",
    "Lynessa Duskblossom was out of the barrow den and spared a dark fate.",
    false, {"part1_corpus.txt #99053 (cat 141)", "LoreForever quest:99053 (wiki: World of Warcraft: Forever; Sentinel Lynessa Duskblossom)"})
q(98392, "Darkness in the Glade", "Teldrassil", 12, "oracle", 5,
    "The leather of the harpy belts from the {p:Oracle Glade} had a taint running through its fibers. Arynia Cloudsbreak suspected its source, but needed proof.",
    "If the harpy leaders' necklaces carried the same darkness as their belts, Arynia Cloudsbreak would have her answer.",
    "Foul green swirls ran through the gems of the harpies' amulets. It was fel moss corruption, and Arynia went to tell her superiors at once.",
    "The harpy amulets confirmed it. Fel moss corruption was turning Teldrassil's own creatures against it, as reports from {p:Shadowglen} had warned.",
    false, {"LoreForever quest:98392 (wiki: World of Warcraft: Forever; Sentinel Arynia Cloudsbreak)"})
q(98398, "The Oracle Tree", "Teldrassil", 12, "oracle", 4,
    "The Oracle Tree had shed a piece of its bark, and that usually meant it had a task it wished done.",
    "Fallen bark from the Oracle Tree was a summons, and the sentinel at the glade thought greater tasks lay ahead.",
    "A calm voice spoke from the fallen bark of the Oracle Tree.",
    "The Oracle Tree's bark carried its message, gentle as a breeze through the leaves.")
P.threads.fv_oracle = "the Oracle Tree and its sentinels"
q(98067, "Eyes of the Sentinels", "Darnassus", 11, "teldrassil", 3,
    "General Feathermoon made sure every sentinel had time to pray to Elune. Something was amiss in Teldrassil, and sentinel owls were to watch the city in the meantime.",
    "Sentinel owls were needed at the tunnels below Cenarion Hold, the bank, the inn on the Craftsman's Terrace and the city gates of {p:Darnassus}.",
    "The owls were in place around {p:Darnassus}. The sentinel found peace in the daily rituals, but was glad of a moment to reflect.",
    "The city's watch was set, owl by owl, and the sentinel had a rare moment to pray.",
    false, {"part1_corpus.txt #98067 (cat 1657; Sentinel Owls)", "LoreForever quest:98067 (wiki: World of Warcraft: Forever; Sentinel Dalia Sunblade)"})

-- Darkshore and the new ship to Stormwind (#97894, #97914, #97926), Auberdine's
-- bounty (#98025) and the guardian of Mathystra (#98028). Givers from Lore
-- Forever: Borgus Steelhand, Elder Thundris Windweaver. "The recent tragedy"
-- in Auberdine is never explained in the text, so it stays unexplained.
q(97894, "Business in Auberdine", "Darkshore", 17, "auberdine", 2,
    "Borgus Steelhand's brother Gorbold had joined a merchant stall in {p:Auberdine} weeks before, and Borgus had not heard from him since.",
    "A new ship sailed from {p:Stormwind} to {p:Auberdine}, and Borgus Steelhand wanted someone aboard to check on his brother.",
    "Gorbold Steelhand was glad his brother was looking out for him. Business in {p:Auberdine} had all but stopped since a recent tragedy, and he could use the help.",
    "Gorbold was found at his stall in {p:Auberdine}, where trade had nearly stopped since a recent tragedy.",
    false, {"LoreForever quest:97894 (wiki: World of Warcraft: Forever; Borgus Steelhand in Stormwind)"})
q(97914, "Expanding Horizons", "Stormwind City", 17, "auberdine", 3,
    "No one in {p:Darnassus} spoke of {p:Auberdine}, only of the cities the Sundering had taken. Its elder wanted the village's work known, and wrote to a man in {p:Stormwind} named Baros Alexston.",
    "A new vessel linked {p:Auberdine} to {p:Stormwind}, bringing supplies to its shores, and the village elder sent a letter on its next voyage.",
    "Baros Alexston opened the elder's letter with a smile, and it faded as he read.",
    "The letter from {p:Auberdine} reached Baros Alexston in {p:Stormwind}, and his good humor did not last the reading.",
    false, {"LoreForever quest:97914 (wiki: World of Warcraft: Forever; Thundris Windweaver)"})
q(97926, "Making Do", "Darkshore", 17, "auberdine", 4,
    "Baros Alexston wished he could help {p:Auberdine}, but {p:Stormwind}'s coffers were not what they had been, and what remained was spread thin. His reply went back across the sea.",
    "Many in the Alliance went without, Baros said. His answer to the elder of {p:Auberdine} was not what the village hoped for, but it was all he could offer.",
    "The elder took the news sadly. With neither {p:Stormwind} nor {p:Darnassus} coming to help, he said, {p:Auberdine}'s fate was its own to decide.",
    "No aid would come to {p:Auberdine}. Its elder resolved that the village would decide its fate alone.",
    false, {"part1_corpus.txt #97926 (cat 148)", "LoreForever quest:97926 (wiki: World of Warcraft: Forever; Elder Thundris Windweaver)"}).highlight = {
    "Stormwind's answer reached Auberdine. No aid was coming, and the elder said the village's fate was its own.",
    "Auberdine learned that neither Stormwind nor Darnassus would help it."}
P.threads.fv_auberdine = "Auberdine's plea across the sea"
q(98025, "WANTED: Jai'vhanel", "Darkshore", 13, "darkshore", 3,
    "The village council of {p:Auberdine} offered a bounty on Jai'vhanel, an owl called Swordfeather, who had gone mad and attacked travelers on the road.",
    "Jai'vhanel had last been seen north of the ruins of Ameth'Aran, and Sentinel Glynda Nal'Shea would pay for one of her jet black feathers.",
    "Glynda Nal'Shea was sad there had been no other way. Jai'vhanel had long been a guardian of the area, and no one knew what had driven her mad.",
    "The roads to {p:Auberdine} were safe again. Glynda grieved a little for the owl, who had once guarded them.",
    false, {"LoreForever quest:98025 (wiki: World of Warcraft: Forever; Sentinel Glynda Nal'Shea)"})
q(98028, "Baron Marinous", "Darkshore", 21, "darkshore", 5,
    "All that remained of Baron Marinous, the elemental guardian of the ruins, was a globe of water, clouded by something that seemed to resist being seen.",
    "Whatever had happened to the elemental and the ruins it guarded was still at work, and only Onu, the Ancient of Lore at the Grove of the Ancients, might know more.",
    "Onu was as surprised as an ancient could be to hear of stairs leading down in Mathystra. He meant to confer with the others, and was glad it had been found before the naga or their cult allies.",
    "The clouded globe reached Onu, who would take word of Mathystra's hidden stairs to the other ancients.",
    false, {"part1_corpus.txt #98028 (cat 148; bring the globe to Onu)"})
P.threads.fv_darkshore = "the troubles along the Darkshore coast"

-- Redridge (cat 44). Givers from Lore Forever: Foreman Oslow, Marshal Marris,
-- Deputy Feldon; the bounty names Magistrate Solomon itself.
q(98407, "Show of Force", "Redridge Mountains", 17, "redridge", 2,
    "The gnolls were camping close to the humans of {p:Redridge}, and seemed to respect strength above all else.",
    "Slaying the worst of the gnolls, their thrashers, might remind the pack to stay in the hills where it belonged.",
    "The thrashers' collars came back by the armful. It did not solve the gnoll problem, but they would think twice about pushing further.",
    "The gnolls had been discouraged from pushing closer to {p:Lakeshire}, though they were not gone.",
    false, {"part1_corpus.txt #98407 (cat 44; 5 collars)", "LoreForever quest:98407 (wiki: World of Warcraft: Forever; Deputy Feldon)"})
q(98386, "Alther's Mill", "Redridge Mountains", 21, "redridge", 2,
    "Orcs, gnolls and murlocs had already delayed the bridge at {p:Lakeshire}, and now tarantulas infested the lumber mill it depended on.",
    "Foreman Oslow could not safely send his workers to Alther's Mill while spiders were snatching them up.",
    "The mill was worse than Oslow had thought, but its tarantulas had been cleared.",
    "Alther's Mill was clear of spiders, and lumber for the bridge could move again.",
    false, {"part1_corpus.txt #98386 (cat 44; slay 12)", "LoreForever quest:98386 (wiki: World of Warcraft: Forever; Foreman Oslow)"})
q(98387, "Blackrock Blockade", "Redridge Mountains", 21, "redridge", 4,
    "The Blackrock orcs had pushed into Alliance land and now lived off the mountains. Marshal Marris called it a war of attrition, and meant to starve them.",
    "The orc camps south of Stonewatch Keep held food and weapons, most of it taken from {p:Lakeshire} in the first place.",
    "The Blackrock camps lost their axes and supplies. Cut off from their allies in the Burning Steppes, Marris said, the orcs could not hold their foothold for long.",
    "The supplies taken from the Blackrock camps went back to {p:Lakeshire}, and the orcs were left hungrier and worse armed.",
    false, {"part1_corpus.txt #98387 (cat 44; Battleworn Axes)", "LoreForever quest:98387 (wiki: World of Warcraft: Forever; Marshal Marris)"})
q(95999, "WANTED: Incinerator Gar'im", "Redridge Mountains", 25, "redridge", 5,
    "Incinerator Gar'im led an orc incursion in Render's Valley and was said to work with the Blackrock of Stonewatch Keep. Magistrate Solomon offered a reward for proof of his death.",
    "Gar'im and his Shadowcasters were extremely dangerous, the bounty warned, and they held Render's Valley.",
    "Gar'im had been preparing to strengthen the defenses of Stonewatch Keep. With him dead, Magistrate Solomon thought the keep might yet be retaken.",
    "Incinerator Gar'im was dead, and {p:Lakeshire} began to hope of reclaiming Stonewatch Keep.",
    false, {"part1_corpus.txt #95999 (cat 44; type 1)"}).highlight = {
    "Incinerator Gar'im fell in Render's Valley, and Magistrate Solomon hoped to retake Stonewatch Keep.",
    "The orc who was to fortify Stonewatch Keep was dead."}
P.threads.fv_redridge = "the defense of Lakeshire"

-- The Wetlands and the ships from Auberdine. Valstag Ironjaw gives #98197 (Lore
-- Forever); #98461 leaves Tarrel's missing wife to the vanilla chain.
q(98197, "Spoils of War", "Wetlands", 22, "menethil", 3,
    "By Valstag Ironjaw's account, the Old Horde had first built {p:Menethil Harbor} to launch its fleet against Hillsbrad, with timber and iron stolen from Khaz Modan. Much of it still lay under the water.",
    "With the Dragonmaw on the move, Valstag Ironjaw wanted the Old Horde's sunken materials raised to shore up the town's defenses.",
    "The timber and iron came up a bit damp. Valstag was glad not to rely only on shipments from Theramore or {p:Auberdine} for once.",
    "The Old Horde's sunken spoils went into {p:Menethil}'s defenses.",
    false, {"LoreForever quest:98197 (wiki: World of Warcraft: Forever; Valstag Ironjaw in Menethil Harbor)"})
q(98459, "A Lack of Virtue", "Wetlands", 21, "menethil", 2,
    "Tom Half-fish called Bart Tidewater a cheapskate and a cheat at poker, no real captain but an actor who had won the Maiden's Virtue at cards. He sent a parcel to {p:Menethil Harbor}.",
    "Old Half-fish had a gift for Bart Tidewater, captain of the Maiden's Virtue in {p:Menethil Harbor}, and wanted him told who it was from.",
    "Bart unwrapped the gift and swore. Half-fish was the cheat, he said, thrown out of their poker circle. Then he apologized and welcomed the courier to {p:Menethil Harbor}.",
    "Half-fish's gift reached Bart Tidewater, who answered the insult with one of his own before welcoming the messenger aboard the finest ship in the Great Sea.",
    false, {"LoreForever quest:98459 (wiki: World of Warcraft: Forever; Tom Half-fish to Bart Tidewater)"})
q(98461, "Unrequited Love", "Wetlands", 21, "menethil", 3,
    "Hollee in {p:Auberdine} had studied with Tarrel Rockweaver, who went on to the Wetlands after they finished school. She wanted to know he was all right, and sent him a note.",
    "Hollee had a note for her old classmate Tarrel, somewhere near {p:Menethil Harbor}. She mentioned his wife, Merrin, only as an afterthought.",
    "Tarrel read Hollee's note with pity. He was happily married, and would not reply. His wife was missing, and he had more pressing worries.",
    "Tarrel decided not to answer Hollee's note. He did not know how to let her down, and his wife Merrin was missing.",
    false, {"LoreForever quest:98461 (wiki: World of Warcraft: Forever; Hollee to Tarrel Rockweaver)"})
P.threads.fv_menethil = "the harbor at Menethil"

-- Loch Modan (cat 38).
q(86585, "Banner of the Fallen", "Loch Modan", 17, "lochmodan", 4,
    "A mountaineer lay dead in trogg country, killed by a blow to the head, and the standard of Ironforge she carried had been trampled.",
    "The trogg that killed the mountaineer was likely still near, and raising her banner of Ironforge might call it out.",
    "The fallen mountaineer was Ylva. She had gone looking for a patrol that never came back, set on showing the troggs that Ironforge would never fall. Her banner would be cleaned and displayed.",
    "Ylva's fate was known at last. Her banner went back to be cleaned and hung, and her weapon was passed on to fight the troggs.",
    false, {"part1_corpus.txt #86585 (cat 38; raise the standard, call out the trogg)"})
q(86614, "Silver of the Waves", "Loch Modan", 20, "lochmodan", 2,
    "Among the rusty hooks and broken spools in some fishing debris lay an ornate silver hair clip marked K.D.",
    "A silver hair clip, corroded but finely made, had turned up in the fishing debris, and someone had surely missed it.",
    "The owner of the hair clip had thought it lost for good, and was sure it would shine again with a little work.",
    "The silver clip went back to its owner, who was busy with chores but glad of it.",
    false, {"part1_corpus.txt #86614 (cat 38)"})
q(86667, "Snowbound", "Loch Modan", 20, "lochmodan", 3,
    "Grenhild's old mentor Norric had sent a minor elemental asking for a jar of snow. She was busy learning the local elementals, and South Gate Pass had snow all year.",
    "Norric needed snow for his shamanic workings, and his student Grenhild had learned long ago not to question his ways.",
    "Norric was delighted that Grenhild had sent his snow, though he had hoped she might come herself.",
    "The jar of snow reached Norric. He wished his old student had brought it in person.",
    false, {"part1_corpus.txt #86667 (cat 38)", "LoreForever quest:86667 (wiki: World of Warcraft: Forever; Grenhild and Norric Lochthane)"})
P.threads.fv_lochmodan = "small troubles around Loch Modan"

-- Stormwind (cat 1519): Roy Lewells's reading club and the library (#97234,
-- #97237), and old Gray at the harbor (#95065, Gilbert Gray per Lore Forever).
q(97234, "Reading Room", "Stormwind City", 18, "stormwind", 2,
    "Roy Lewells's reading club was trading some of its less popular works to the {p:Stormwind} library for more modern writing.",
    "The reading club had a wrapped parcel and a list of titles for the librarian, with refreshments promised for the courier.",
    "The librarian recognized Roy's way of wrapping. The club always returned what it borrowed in good condition, however provoking the words.",
    "The librarian took the parcel and agreed to the exchange.",
    false, {"part1_corpus.txt #97234 (cat 1519; Roy Lewells)"})
q(97237, "Shelf Picked", "Stormwind City", 18, "stormwind", 2,
    "Every title on Roy Lewells's list was in the library, but the librarian would not fetch them. They had to be found on the shelves.",
    "The library had all of the reading club's selections, and a courier could carry them back to Roy on the club's account.",
    "Roy was delighted with the new titles, some of which smelled exotic, and looked forward to lively talk about them in the cellar after hours.",
    "The reading club had its new material, and Roy kept his promise of refreshments on the house.",
    false, {"part1_corpus.txt #97237 (cat 1519)"})
q(95065, "Fishin' Time", "Stormwind City", 12, "stormwind", 2,
    "Old Gray was fishing in {p:Stormwind} and the fish were biting, but he was down to his last bait. Catherine Leland sold fishing goods along the canals.",
    "Old Gray, fishing the harbor, wanted supplies from Catherine Leland's shop, west of the Trade District.",
    "Gray had caught a big one with his last bait, and shared a few fish for keeping him in business.",
    "The fresh bait reached old Gray in time, and he handed over a few fish for the road.",
    false, {"LoreForever quest:95065 (wiki: World of Warcraft: Forever; Gilbert Gray)"})
P.threads.fv_stormwind = "errands around Stormwind"

-- More Horde starter-zone stages (cat 14 Durotar, 85 Tirisfal, 130 Silverpine,
-- 1638 Thunder Bluff) and the Alliance half of Chol'aruk (#97005, cat 17; the
-- veteran is Bainham per Lore Forever). Rezlak's orb is never shown charged,
-- so the outcome stops at his hope.
q(97005, "Chol'aruk the Ravener", "The Barrens", 21, "durotar", 4,
    "The Razormane spoke of Chol'aruk the Ravener, a beast in a cave on Thorn Hill said to swallow an orc whole. An Alliance veteran believed the tales, because he had fought one like it.",
    "It had taken six fighters to bring down a beast like Chol'aruk, and all but two had died. Far from Alliance lands, the veteran still meant to honor his fallen brothers.",
    "Chol'aruk's head reached the veteran. His dead men would rest easier, he said, with one less of these monsters in the world.",
    "Chol'aruk was dead. For the men he had lost, the Alliance veteran said, there was one less monster in the world.",
    true, {"part1_corpus.txt #97005 (cat 17; type 1)", "LoreForever quest:97005 (wiki: World of Warcraft: Forever; Bainham)"})
q(97281, "A Simmering Storm", "Durotar", 11, "durotar", 2,
    "A harpy had been carrying a dull orb with a dark mist swirling inside it, and small sparks of lightning ran through it.",
    "The harpy's orb hummed with a faint current, and Rezlak the goblin might want to know what it was.",
    "Rezlak loved the orb, and it reminded him of something his old boss Gazlowe used to say.",
    "The stormy orb went to Rezlak, who was delighted with it.",
    false, {"part1_corpus.txt #97281 (cat 14; the Dull Stormy Orb to Rezlak)", "LoreForever quest:97281 (wiki: World of Warcraft: Forever; Dustwind harpies of Drygulch Ravine)"})
q(97282, "Stormy Potential", "Durotar", 11, "durotar", 3,
    "Rezlak thought the harpies' orb was only drained, and that the charged organs of the thunder lizards in the gorge to the west could fill it again.",
    "Gazlowe had taught Rezlak to seize an opportunity when it came knocking. The goblin meant to recharge the orb, if someone brought him thunder lizard organs.",
    "Rezlak had his organs and hoped to charge the orb with them. He bet it would make the harpies think twice about attacking his caravan.",
    "The thunder lizard organs reached Rezlak. Whether the orb would charge, he could only hope.",
    false, {"part1_corpus.txt #97282 (cat 14; 5 organs)"})
q(95328, "Whispering Horror Residue", "Tirisfal Glades", 10, "tirisfal", 2,
    "The remains of a creature from beneath the Whispering Forest were still squirming. Someone in the {p:Undercity} might have a use for them.",
    "A beast from under the Whispering Forest had left a residue behind, and the {p:Undercity} studied stranger things.",
    "The residue went to a scholar in the {p:Undercity} who knew the Whispering Forest was touched by the void, and welcomed the chance to explore the mysteries of shadow.",
    "The squirming remains became a specimen in the {p:Undercity}, paid for gladly.",
    false, {"part1_corpus.txt #95328 (cat 85)", "LoreForever quest:95328 (wiki: World of Warcraft: Forever; Father Lankester)"})
P.threads.fv_tirisfal = "strange finds around Tirisfal"
q(91920, "Wild Eyes", "Silverpine Forest", 11, "silverpine", 2,
    "A Deathstalker had taken Apothecary Renferrel's potion and felt no better, and wondered if murloc eyes from Lake Lordamere might work where hearts had not.",
    "Renferrel was obsessed with hearts lately, and an ailing Deathstalker risked his temper by suggesting murloc eyes instead.",
    "His potion had failed, Renferrel said, because it had been brewed with too few hearts. Still, he took the eyes, and offered some of his own hearts to restore the Deathstalker's strength.",
    "The murloc eyes reached Renferrel, who had not thought of using murloc parts until then.",
    false, {"part1_corpus.txt #91920 (cat 130; 3 eyes)"})
P.threads.fv_silverpine = "the Sepulcher's ailing Deathstalker"
q(97485, "Traditions of the Bluff", "Thunder Bluff", 10, "bluff", 3,
    "The tauren had a tradition of scattering incense to the winds. Its makings, herbs, cedar, sinew thread and ceremonial flint, came from the traders of {p:Thunder Bluff}.",
    "Incense was scattered off the south cliff of Hunter's Rise for many reasons, to ask the Earthmother's watch over someone or to bless a hunt.",
    "The incense was crafted and spread from the cliffs of Hunter's Rise, in the old way of the tauren.",
    "The incense went to the winds off Hunter's Rise. Its makings could always be bought again, for any other day worth giving thanks.",
    false, {"part1_corpus.txt #97485 (cat 1638; Nida, Nata, Mahu and Naal)"})
P.threads.fv_bluff = "the traditions of Thunder Bluff"

---------------------------------------------------------------- Remaining starter-zone stages (starters3 lane, 2026-11-05)
-- Orgrimmar (cat 1637): Yelmak's shop before Whuut's the Rush (#97275), and
-- Migi's lunches and games behind Grommash Hold. Kor'geld, Thatog and Thra
-- are named from Lore Forever; the rest is the quest text.
q(97242, "Yelmak's Medley", "Orgrimmar", 15, "durotar", 2,
    "Yelmak's apprentice Whuut kept breaking the shop's equipment and was too proud to ask for help. Kor'geld wanted cattail and speargrass from the Valley of Honor for one of Yelmak's home brews.",
    "Kor'geld could not leave Yelmak's shop without Whuut guessing that everyone was humoring his mood. The cuttings for the medley grew by the water in the Valley of Honor.",
    "Kor'geld said that cattail and speargrass like these grew only in {p:Orgrimmar}, fed by mountain springs and the city's red dust. Yelmak would use them to win back Whuut's ear with a lesson at the bench.",
    "The cuttings went to Yelmak, who hoped a lesson with his own hands would reach his proud apprentice.",
    false, {"part1_corpus.txt #97242 (cat 1637)", "LoreForever quest:97242 (wiki: in-game quest text; Kor'geld and Whuut)"})
q(97246, "Meal Appeal", "Orgrimmar", 15, "migi", 2,
    "Thatog's son Migi played behind Grommash Hold all day. He almost never stopped for the lunch his father had arranged at Borstan's. The boy came home starving, and Thatog's duties kept him at his post.",
    "Thatog could not watch over every meal his son Migi skipped. He asked that Borstan be told, at his firepit, that someone had come for Migi's lunch.",
    "Borstan knew the arrangement well. Migi was meant to collect a bagged lunch every day, and some weeks he hardly came at all.",
    "At the firepit, Borstan admitted that Migi often left his lunch behind. He wondered where the boy found the energy to play all day.",
    false, {"part1_corpus.txt #97246 (cat 1637)", "LoreForever quest:97246 (wiki: in-game quest text; Thatog)"})
q(97249, "Favorite Food", "Orgrimmar", 15, "migi", 3,
    "Migi's parents had made Borstan promise to vary the boy's lunches. Migi never missed lunch when sweetglazed hog belly came out of the smoker. So Borstan began crumbling the glazed bits over any meal.",
    "Borstan had a plan to bring Migi in for lunch. Crispy sweetglaze crumbs could go on any dish. Migi was behind Grommash Hold with his friends.",
    "Migi smelled the lunch and said it tasted like his favorite, only better. If it was this good every day, his friends would stop their game to eat with him.",
    "Borstan's lunch reached Migi behind Grommash Hold. The boy liked the strong crumbs and decided the game could wait while everyone ate.",
    false, {"part1_corpus.txt #97249 (cat 1637)", "LoreForever quest:97249 (wiki: in-game quest text; Borstan's Meats)"}).highlight = {
    "Borstan's sweetglaze crumbs won Migi over. The boy decided his friends could stop their game behind Grommash Hold to eat lunch.",
    "Migi took Borstan's lunch behind Grommash Hold and called it his favorite."}
q(97326, "Rocks to Rests", "Orgrimmar", 15, "migi", 2,
    "Behind Grommash Hold, Thra and the other children set up their figures in a clear patch of dirt. They had no rocks to use as chairs or tables.",
    "Thra wanted smooth, medium-sized rocks for the children's game behind Grommash Hold, flat enough to sit on when they needed a rest.",
    "Thra marveled that anyone could carry so many boulders. Most had a flat side, and the children could push them through the dirt wherever they wanted.",
    "Eight smooth rocks reached the clearing behind Grommash Hold, and the children no longer had to sit in the dirt.",
    false, {"part1_corpus.txt #97326 (cat 1637; 8 rocks)", "LoreForever quest:97326 (wiki: in-game quest text; Thra)"})
P.threads.fv_migi = "the children behind Grommash Hold"

-- The Barrens (cat 17). #95621 comes before the Horde pack's Unwelcome Guests
-- (#95508): the tanner learns here that the soldiers want a deserter, and tells
-- his navy past there. Walton and Wrenix are named from Lore Forever. #95774
-- follows Mankrik's Lost in Battle (#4921, Horde pack). Stepping Stones
-- (#79192) is the world lane's.
q(95621, "Trouble in the Valley", "The Barrens", 18, "horde_vrang", 4,
    "The hermit tanner Walton had watched human soldiers search the valley below his ridge. He had used his rifle's scope. They wore the livery of Kul Tiras.",
    "Walton, the hermit tanner, called the last of Daelin Proudmoore's fleet as rotten as the admiral had been. Its soldiers had camped by a wrecked caravan to the south, and he wanted to know why.",
    "The soldiers by the wrecked caravan had been looking for a deserter. The hermit tanner said his past had finally caught up with him.",
    "The Kul Tiran camp was broken, and its purpose came out. They were hunting a deserter, and the tanner knew it was him.",
    false, {"part1_corpus.txt #95621 (cat 17)", "LoreForever quest:95621 (wiki: in-game quest text; Walton)"}).highlight = {
    "Kul Tiran soldiers in the valley had come looking for a deserter. The hermit tanner on the ridge knew his past had caught up with him.",
    "Walton, the hermit tanner, learned that the soldiers by the wrecked caravan wanted a deserter. He took it as his own past come back."}
q(95774, "Her Name Is Olgra", "The Barrens", 20, "horde_mankrik", 4,
    "Mankrik's wife Olgra had died fighting, and the healer who saved him could not save her. Her jewels of polished bone were gone from her body.",
    "Mankrik was building a memorial so that he would never forget Olgra. He wanted back the bone adornments she had worn, taken by the Razormane raiders near where she fell.",
    "Olgra's bone adornments went to the memorial Mankrik was raising for her. His blood still ran hot for revenge.",
    "Mankrik placed his wife's jewels with her memorial, so that he would never forget her.",
    false, {"part1_corpus.txt #95774 (cat 17)", "LoreForever quest:95774 (wiki: in-game quest text; Mankrik)"}).highlight = {
    "Olgra's jewels of polished bone came back from the Razormane. Mankrik laid them with the memorial he was building for his wife.",
    "Mankrik had his wife's adornments for her memorial. He would never forget Olgra, he said, and his blood still ran hot for revenge."}
q(97250, "Wrongly Blamed, Justly Corrected", "The Barrens", 23, "eastcoast", 4,
    "Human soldiers had dug in at the border of Dustwallow Marsh and were toppling the landmarks left by tauren pathfinders. A favored tavern there had burned, and the Alliance blamed the Horde.",
    "A tavern near Dustwallow Marsh had burned, and the Alliance blamed the Horde. True or not, Alliance soldiers on Horde land could not stand, and the order was to strike first.",
    "The rumors had been true. Tensions along the eastern coast had been rising for some time, and the soldiers at the marsh border were beaten.",
    "The soldiers at the border fell, a stern warning to the Alliance. Who had burned the tavern was still in doubt, for too many Horde travelers needed that road.",
    false, {"part1_corpus.txt #97250 (cat 17)", "LoreForever quest:97250 (wiki: in-game quest text)"})
P.threads.fv_eastcoast = "the trouble on the eastern coast"
q(97253, "Parts and Pieces", "The Barrens", 14, "horde_ratchet", 2,
    "Five or six fighters Wrenix had sent against the pirates south of {p:Ratchet} had never come back. So he sent a machine, and the pirates took it apart with their scimitars.",
    "Pieces of Wrenix's machine lay scattered across the pirate camp south of {p:Ratchet}. Picking them up, he reckoned, was far safer work than fighting.",
    "Wrenix had his parts back and could start on his next prototype. It also spared him another of Gagsprocket's lectures on the cost of metal.",
    "The scattered parts came back to Wrenix, who had planned no reward and offered a box instead.",
    false, {"part1_corpus.txt #97253 (cat 17)", "LoreForever quest:97253 (wiki: in-game quest text; Wrenix the Wretched)"})
q(98093, "Field to Clear", "The Barrens", 23, "taurajo", 2,
    "A walker from {p:Camp Taurajo} had gone down the golden road on a fine morning and ended up in a tree. Hyenas circled below, and Stormhide lizards blocked the way home.",
    "A walker from {p:Camp Taurajo} was stuck up a tree. Too many Hecklefang stalkers and Stormhide lizards prowled the fields to risk the run home.",
    "The fields below the tree were clear. The walker promised to tell {p:Camp Taurajo} of the rescue, and began the careful climb down.",
    "With the hyenas and lizards gone, the walker could climb down. It beat being stuck in the tree all day.",
    false, {"part1_corpus.txt #98093 (cat 17)"})
P.threads.fv_taurajo = "the fields around Camp Taurajo"

-- Dun Morogh (cat 1). Jemma Quikswitch, Amberstill Ranch and Quarrymaster
-- Thesten are named from Lore Forever. #98423 starts from a tablet in a vault;
-- Magni names his ancestor Madoran in the completion text.
q(95041, "Data Hoarders", "Dun Morogh", 10, "gnomes", 2,
    "Before fleeing Gnomeregan, Jemma Quikswitch had copied her family's archives onto punch cards. A hole in her pack had lost several of them in the snow outside the city.",
    "The Quikswitch archives held arcanotechnical field equations, submarine hull designs from the Second War and Grandma Quikswitch's chili recipe. Without the lost cards, the rest was too scrambled to read.",
    "The punch cards were a bit damp, but Jemma thought she could work with them.",
    "Jemma had her lost cards back, damp but usable, and her family's archives could be pieced together.",
    false, {"part1_corpus.txt #95041 (cat 1)", "LoreForever quest:95041 (wiki: in-game quest text; Jemma Quikswitch)"})
P.threads.fv_gnomes = "the gnomes who fled Gnomeregan"
q(95212, "Never Saddle on Quality", "Dun Morogh", 10, "morogh", 2,
    "A team of rams was to reinforce the Alliance expedition in Alterac. {p:Amberstill Ranch} had run out of material for their saddles.",
    "A ram handler was outfitting rams for the cold of Alterac. Only pelts from the largest leopards to the east would do for their saddles.",
    "The leopard pelts would make fine saddles for the rams bound for Alterac.",
    "The ranch had its pelts, and the rams for the north could be saddled.",
    false, {"part1_corpus.txt #95212 (cat 1)", "LoreForever quest:95212 (wiki: in-game quest text; Amberstill Ranch)"})
q(95214, "Stolen Blasting Powder", "Dun Morogh", 10, "morogh", 3,
    "Troggs had stolen a keg of blasting powder from the Gol'Bolar Quarry. Quarrymaster Thesten said it held enough to turn King Magni's throne room into an open-air courtyard.",
    "Thesten wanted his quarry's powder back from the troggs before they worked out how to light it.",
    "All the stolen powder was back. Thesten paid for it and asked that the little incident not be mentioned to anyone.",
    "The troggs no longer had the quarry's powder, and Thesten hoped no one else would hear of its loss.",
    false, {"part1_corpus.txt #95214 (cat 1)", "LoreForever quest:95214 (wiki: in-game quest text; Quarrymaster Thesten)"})
P.threads.fv_morogh = "work for the dwarves of Dun Morogh"
q(98423, "The Treaty of Understanding", "Ironforge", 16, "tombs", 5,
    "In a vault lay a tablet with the terms of a peace between the Bronzebeard and Wildhammer clans. It dated from just after the War of the Three Hammers. The king of {p:Ironforge} would want it.",
    "The old tablet was a piece of dwarven history. Two of the three clans that had fought over the mountain had made peace on it.",
    "King Magni knew the treaty. His ancestor Madoran, the first Bronzebeard king of {p:Ironforge}, had drafted it after the civil war. The Wildhammers had signed it, and the Dark Irons had not.",
    "The tablet reached King Magni. Only the Bronzebeards and Wildhammers had signed it, he pointed out, and never the Dark Irons.",
    false, {"part1_corpus.txt #98423 (cat 1)", "LoreForever quest:98423 (wiki: in-game quest text; Madoran Bronzebeard)"}).highlight = {
    "King Magni received a treaty tablet from a vault. His ancestor Madoran had drafted it after the War of the Three Hammers, and the Dark Irons had never signed.",
    "King Magni recognized the tablet as the peace his ancestor Madoran had made with the Wildhammers. The Dark Iron clan's mark was missing from it."}

-- Mulgore. Three tests by one teacher who hoped to find talent for the
-- subtle arts. The giver is not named in the captured text, so neither is
-- here, and no class is inferred.
q(76156, "Stalk With The Earthmother", "Mulgore", 10, "earthmother", 2,
    "A teacher in Mulgore sensed a hidden talent for the subtle arts. The test was to wear a mask into the {p:Venture Co. Mine} and steal its supplies.",
    "A teacher in Mulgore handed over a mask for slipping into the {p:Venture Co. Mine}. It hardly looked convincing, but a skilled rogue needed only a winning smile and a distraction, the teacher said.",
    "The teacher had heard the approach the moment it reached the mesa. Disguises, perhaps, were not the strength after all.",
    "The stolen supplies came back, but the teacher judged that disguises were not the hidden talent.",
    true)
q(76160, "Stalk With The Earthmother", "Mulgore", 11, "earthmother", 2,
    "Perhaps the talent lay in poisons. Harpies to the north nested in a tree whose fallen cones could be crushed into a searing salve for blades.",
    "The Mulgore teacher's second test was a venomous salve from the cones beneath the harpies' nesting tree. Even a touch of it on skin would hurt.",
    "What came back was pine nut butter. The teacher thought it better spread on spice bread than on a dagger.",
    "The salve turned out to be pine nut butter, formidable only against a foe with a nut allergy, the teacher said.",
    true)
q(76240, "Stalk With The Earthmother", "Mulgore", 11, "earthmother", 3,
    "The teacher had one last, less direct idea. A raw Brilliant Smallfish was to be cleaned and filleted with the teacher's daggers, without thinking too hard.",
    "There was still hidden talent to coax out, the teacher believed. This time the test was a fish and a pair of daggers.",
    "The filleting showed no rogue's precision, but an impressive ambidexterity. The teacher gave up on training a rogue and offered to teach one thing instead.",
    "The daggers worked in both hands at once. The teacher would find someone else to train in the subtle arts, and said the Horde would need heroes like this.",
    true)
fallback("Stalk With The Earthmother", "Mulgore", "earthmother", "76156, 76160, 76240",
    "A teacher in Mulgore was looking for hidden talent in the subtle arts.",
    "The teacher's tests were meant to find a gift for stealth, poison or the blade.",
    "Another of the teacher's tests was done.",
    "The teacher learned a little more about where the talent lay.")
P.threads.fv_earthmother = "a teacher's search for hidden talent"

-- Alliance-side stages (the rest are Horde or both); the test renders them as such.
P.alliance = {92415, 95161, 95189, 95195, 96408, 96392, 96390, 96391, 96393, 96394, 96403, 93461, 92596, 94413, 92701, 92699, 92834, 92840, 92741, 94493, 98021, 92742, 92744, 92745, 92747, 92748, 92749, 92750, 92751, 92752, 92753, 92819, 92909, 92910, 92911, 96139, 96138, 98447, 98190, 98191, 98322, 98319, 98323, 98321, 98326, 99158, 99159, 99160, 99161, 99162,
    97277, 99127, 99128, 99129, 99130, 99131, 99143,
    91741, 92124, 91743, 91745, 91752, 91758, 91772, 91775, 91777, 91753, 91733, 91732, 91740, 91746,
    97979, 97977, 97236, 87288, 99046, 99047, 99050, 99073, 99053, 98392, 98398, 98067,
    97894, 97914, 97926, 98025, 98028, 98407, 98386, 98387, 95999, 98197, 98459, 98461, 86585, 86614, 86667, 97234, 97237, 95065,
    97005, 95041, 95212, 95214, 98423}

---------------------------------------------------------------- registration
-- Drop any stage or title another pack already owns (it loads earlier and
-- wins); RegisterStoryPack refuses duplicate quest IDs.
P.skipped = {}
for id in pairs(P.questIDs) do
    if L.questStoryIDs and L.questStoryIDs[id] then P.questIDs[id] = nil; P.skipped[#P.skipped + 1] = id end
end
for title in pairs(P.quests) do
    if L.questStory[title] and L.questStory[title].pack then P.quests[title] = nil end
end
table.sort(P.skipped)
L.RegisterStoryPack("forever_content", P)
