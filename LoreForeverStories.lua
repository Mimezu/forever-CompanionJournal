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
local function Thread(key)
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
    "The abomination called the Baron had a head that had been sewn back on many times, each time a little weaker.",
    "When the Baron fell, its head came loose, and someone in the city below the ruins might know more about so unusual an abomination.",
    "The head was recognized at once, and its new keeper already had a use for it.",
    "The Baron's head reached the {p:Undercity}, where its old owner was known and its next purpose already planned.",
    true, {"part1_corpus.txt #97288"})
q(97289, "Unending Torment", "Undercity", 21, "othmar", 4,
    "The Baron's head had once belonged to Othmar, a Grand Marshal of the Alliance whom the Dark Lady had killed herself.",
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
    "The apothecaries of the {p:Undercity} had plans for the Baron's head.",
    "One step of the apothecaries' work on the Baron's head was done.",
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

-- Alliance-side stages (the rest are Horde or both); the test renders them as such.
P.alliance = {92415, 95161, 95189, 95195, 96408, 96392, 96390, 96391, 96393, 96394, 96403, 93461, 92596, 94413, 92701, 92699, 92834, 92840, 92741, 94493, 98021, 92742, 92744, 92745, 92747, 92748, 92749, 92750, 92751, 92752, 92753, 92819, 92909, 92910, 92911, 96139, 96138, 98447, 98190, 98191, 98322, 98319, 98323, 98321, 98326, 99158, 99159, 99160, 99161, 99162}

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
