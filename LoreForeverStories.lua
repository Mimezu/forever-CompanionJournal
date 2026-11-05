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
-- LoreHordeStories.lua already tells 92460-92469 and the other stages it lists;
-- these are the grove stages it does not. Givers: LoreForever quest:94414
-- (Halaan Hawk-Eye), 92474 (Myriaal Mistwake), 92473 (Valreaa Valewind),
-- 92544 (Hanaa Nightwind), 92598 (Ventaari Brightwish), 92470/92472 (Aetheen).
-- Class-trainer referrals (92481-92485, 92532) are left to the class pack.
q(94414, "The Anchors of Zephras", "Zephras Isle", 2, "forever_winds", 3,
    "Halaan Hawk-Eye often came to look upon the ancient anchor pylon, a gift of the wind spirits that bound and sustained the island.",
    "The anchor pylons' magic had grown unstable of late, though Halaan could see nothing wrong with them. He offered to lend his own gift for a closer look.",
    "Halaan was grateful for the company at the pylon, and went on watching over the grove and pondering the state of his homeland.",
    "Halaan called his gift simple and was grateful for it. In his view, yearning for what was lost only led to despair.",
    false, {"LoreForever quest:94414 (wiki: in-game quest text; Halaan Hawk-Eye)"})
q(92474, "Falling With Style", "Zephras Isle", 2, "forever_grove", 2,
    "Myriaal Mistwake dared the young of Thendal to jump from a ledge and float on the air, with bonus points for landing in front of Rorian and startling him.",
    "The shen'dorei could walk on the air, and Myriaal thought a jump from the ledge the best way to practice it.",
    "Rorian complained that Myriaal kept encouraging reckless use of the skyborne gifts, then allowed that a little practice in the village was acceptable.",
    "Rorian advised using the gift with care, so it would not be spent thoughtlessly before it was truly needed.",
    false, {"LoreForever quest:92474 (wiki: in-game quest text; Myriaal Mistwake to Rorian the Dayseeker)"})
q(92471, "Aetheen of the Gales", "Zephras Isle", 4, "forever_grove", 3,
    "Rorian said every task in Thendal had been a trial of sorts, and that Aetheen of the Gales had been watching.",
    "Aetheen of the Gales, one of the leaders of the shen'dorei on Zephras, had a task for those coming of age.",
    "Aetheen of the Council of Elders had come to Thendal Grove to read the winds and to judge the young. Rorian had already told her much.",
    "Aetheen had come to Thendal to read the winds, and to ask the young whether they were ready to serve Zephras Isle.",
    false, {"LoreForever quest:92471 (wiki: in-game quest text)"})
q(92473, "Aggressive Encroachment", "Zephras Isle", 4, "forever_grove", 3,
    "An adolescent ursera had wandered close to Thendal and attacked a boy playing beneath the elder tree, and Valreaa Valewind wanted the den to the southwest thinned.",
    "Hunger had made the ursera of the southwest den bold, and the rangers could not say what had changed them.",
    "The scrawniest of the ursera were put down, and their claws went to Valreaa. The Rangers of the Grove counted themselves in debt.",
    "Valreaa had her proof in ursera claws, and the den was less of a danger to the village.",
    false, {"LoreForever quest:92473 (wiki: in-game quest text; Valreaa Valewind)"})
q(92470, "Foul Matriarch", "Zephras Isle", 5, "forever_grove", 4,
    "Aetheen offered a test of resolve deep in the ursera caves to the south, where the rangers' quarry was a matriarch called Urs'anah.",
    "The ursera caves south of Thendal answered to a matriarch the rangers named Urs'anah, and Aetheen wanted her put down.",
    "Urs'anah's head went to Aetheen, who said the path ahead now led beyond the safety of Thendal Village.",
    "The matriarch of the caves was dead. Aetheen called it an important step, and warned that greater challenges lay ahead.",
    false, {"LoreForever quest:92470 (wiki: in-game quest text; Head of Urs'anah)"})
q(92472, "The Next Step", "Zephras Isle", 5, "forever_cult", 4,
    "The Al'Aketh were zealots who worshipped Al'Akir the Windlord, and they threatened Shen'dar Village to the south.",
    "Elder Aetheen sent help south to Constable Aonda in Shen'dar, for the cult's ambitions grew more deadly by the day.",
    "Constable Aonda confessed to doubts, but Shen'dar Village would not turn down aid sent by Elder Aetheen herself.",
    "Aetheen's name was enough for Constable Aonda, and Shen'dar had one more ally against the cult.",
    false, {"LoreForever quest:92472 (wiki: in-game quest text; Aetheen to Constable Aonda)"})
q(92544, "Al'Aketh Thugs", "Zephras Isle", 5, "forever_cult", 3,
    "Cult ruffians led by Malduko Cloudcrush had camped by the temple ruins, attacking travelers and pressing the grove's people to join the Al'Aketh.",
    "Hanaa Nightwind believed High Priestess Lorthuna had sent the thugs from the Shrine of Akir. Hanaa could not leave her post to deal with them.",
    "Malduko and his band were dealt with. Hanaa had barely kept from joining the fight, and gave the thanks of the Rangers of Thendal Grove.",
    "The ruffians by the temple ruins were beaten, and Hanaa hoped the rest would take the message and leave.",
    false, {"LoreForever quest:92544 (wiki: in-game quest text; Hanaa Nightwind)"})
q(92598, "The Gift of Skysight", "Zephras Isle", 4, "forever_winds", 3,
    "Ventaari Brightwish taught that a Windshaper's skysight, a gift of the elemental spirits, grew strongest at an elemental convergence.",
    "An elemental convergence waited among the standing stones northeast of Thendal, a place where the spirits gathered.",
    "The skysight was used at the convergence. Ventaari said the gift had to be exercised like a muscle, and that hearing the elements might be the key to the island's survival.",
    "At the standing stones, the gift bridged the mortal and the spiritual, and Ventaari urged that the lesson be remembered.",
    false, {"LoreForever quest:92598 (wiki: in-game quest text; Ventaari Brightwish)"})

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
q(93746, "A Firm Response", "Zephras Isle", 9, "traditions", 5,
    "Ayessa wanted Belathaan Brightwish taught to respect the Windshapers' boundaries, and he had last been seen on the road to the Shrine of Akir.",
    "To make an example of Belathaan, Ayessa wanted him confronted alone on the road north.",
    "Belathaan was dead. He had gone to meet the Al'Aketh to discuss peace, and Ayessa blamed the High Order's arrogance for sending him alone.",
    "Ayessa learned that Belathaan was dead and that the High Order had been treating with the cult. There was no peace with the Al'Aketh, she said.",
    false, {"part1_corpus.txt #93746 (Belthaan Brightwish on the road to the Shrine of Akir)"})
q(94003, "The Skybreaker Bulwark", "Zephras Isle", 10, "forever_cult", 4,
    "Seena was the last of the Skybreakers on Zephras. The Al'Aketh had murdered the rest.",
    "A cultist named Zaal Stormshield carried the Skybreaker Bulwark, Seena's ancestral shield, at the Shrine of Akir.",
    "The Skybreaker Bulwark was back with Seena, and her family's honor restored. In thanks she offered to teach the Skybreaker Defense.",
    "Seena had her family's shield again. She offered the Skybreaker Defense, a secret few on Zephras were thought worthy of, and gave away the shield she no longer needed.")
P.threads.fv_windfield = "the Windfield orchard"

-- Alliance-side stages (the rest are Horde or both); the test renders them as such.
P.alliance = {92415, 95161, 95189, 95195, 96408, 96392, 96390, 96391, 96393, 96394, 96403, 93461, 92596, 94413, 92701, 92699}

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
